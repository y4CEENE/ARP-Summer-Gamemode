/// @file      ServerStats.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-09-09 13:26:41 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define TABLE_SERVER_STATS     "server_stats"
#define SERVER_STATS_FILENAME  "export/server_stats.json"

static Stats_PlayerRecord;
static Stats_PlayerRecordDate[24];
static Stats_Connections;
static Stats_TotalRegistered;
static Stats_TotalKills;
static Stats_TotalDeaths;
static Stats_TotalHours;
static Stats_AnticheatBans;

static loading = true;
static writeToFile = false;
static updateTime = 1;
static isServerStatsUpToDate = false;
static lastServerUpdate = 0;

hook OnPlayerConnect(playerid)
{
    if (Iter_Count(Player) > Stats_PlayerRecord)
    {
        Stats_PlayerRecord = Iter_Count(Player);
        Stats_PlayerRecordDate = GetDateTime();
        isServerStatsUpToDate = false;
    }
    return 1;
}

hook OnPlayerInit(playerid)
{
    Stats_Connections++;
    isServerStatsUpToDate = false;
    return 1;
}

IncreaseTotalRegistered()
{
    Stats_TotalRegistered++;
    isServerStatsUpToDate = false;
    return 1;
}

IncreaseTotalHours()
{
    Stats_TotalHours++;
    isServerStatsUpToDate = false;
    return 1;
}

IncreaseAnticheatBans()
{
    Stats_AnticheatBans++;
    isServerStatsUpToDate = false;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (!IsPlayerConnected(playerid) || !PlayerData[playerid][pLogged])
    {
        return 1;
    }

    if ((gettime() - PlayerData[playerid][pLastDeath]) < 2)
    {
        return 1;
    }

    if (!IsPlayerConnected(killerid) || !PlayerData[killerid][pLogged])
    {
        Stats_TotalDeaths++;
    }
    else
    {
        Stats_TotalKills++;
    }
    isServerStatsUpToDate = false;
    return 1;
}

hook OnLoadGameMode()
{
    new Node:serverStats;
    if (!GetServerConfig("server_stats", serverStats))
    {
        JSON_GetInt(serverStats, "write_to_file", writeToFile);
        JSON_GetInt(serverStats, "update_time_s", updateTime);
        if (updateTime <= 0)
            updateTime = 1;
    }

    DBQueryWithCallback("select *, (select count(uid) from users) as db_total_registered, "\
        "(select sum(hours) from "#TABLE_USERS") as db_total_hours from "#TABLE_SERVER_STATS, "OnLoadServerStats");
    return 1;
}

DB:OnLoadServerStats()
{
    GetDBStringField(0, "player_record_date", Stats_PlayerRecordDate, 24);
    Stats_PlayerRecord    = GetDBIntField(0, "player_record");
    Stats_TotalDeaths     = GetDBIntField(0, "total_deaths");
    Stats_TotalKills      = GetDBIntField(0, "total_kills");
    Stats_AnticheatBans   = GetDBIntField(0, "total_anticheat_bans");
    Stats_Connections     = GetDBIntField(0, "total_connections");
    Stats_TotalHours      = GetDBIntField(0, "db_total_hours");
    Stats_TotalRegistered = GetDBIntField(0, "db_total_registered");

    loading = false;
}

hook OnServerHeartBeat(timestamp)
{
    if (!loading && !isServerStatsUpToDate && (timestamp - lastServerUpdate) > updateTime)
    {
        isServerStatsUpToDate = true;
        DBFormat("UPDATE "#TABLE_SERVER_STATS" SET \
            player_record = %i, player_record_date = '%e', total_deaths = %i, total_kills = %i, total_anticheat_bans = %i, total_hours = %i, total_registered = %i, total_connections = %i",
            Stats_PlayerRecord, Stats_PlayerRecordDate, Stats_TotalDeaths, Stats_TotalKills, Stats_AnticheatBans, Stats_TotalHours, Stats_TotalRegistered, Stats_Connections);
        DBExecute("SaveServerStatsToFile");
    }
    return 1;
}

DB:SaveServerStatsToFile()
{
    if (writeToFile)
    {
        new Node:stats = JSON_Object(
            "player_record",        JSON_Int(Stats_PlayerRecord),
            "player_record_date",   JSON_String(Stats_PlayerRecordDate),
            "total_deaths",         JSON_Int(Stats_TotalDeaths),
            "total_kills",          JSON_Int(Stats_TotalKills),
            "total_anticheat_bans", JSON_Int(Stats_AnticheatBans),
            "total_hours",          JSON_Int(Stats_TotalHours),
            "total_registered",     JSON_Int(Stats_TotalRegistered),
            "total_connections",    JSON_Int(Stats_Connections)
        );
        JSON_SaveFile(SERVER_STATS_FILENAME, stats);
    }
}

CMD:serverstats(playerid, params[])
{
    new houses, businesses, garages, vehicles, lands, entrances, turfs, gangs, factions, lockers;

    houses = Iter_Count(House);
    businesses = Iter_Count(Business);
    garages = Iter_Count(Garage);
    vehicles = Iter_Count(Vehicle);
    lands = Iter_Count(Land);
    entrances = Iter_Count(Entrance);
    turfs = Iter_Count(Turf);
    for (new i = 0; i < MAX_GANGS; i ++)      if (GangInfo[i][gSetup])        gangs++;
    for (new i = 0; i < MAX_FACTIONS; i ++)   if (FactionInfo[i][fType])      factions++;
    for (new i = 0; i < MAX_LOCKERS; i ++)    if (LockerInfo[i][lExists])     lockers++;

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ %s Stats ______", GetServerName());
    SendClientMessageEx(playerid, COLOR_GREY2, "Connections: %i - Registered: %i - Kill Counter: %i - Death Counter: %i - Hours Played: %i", Stats_Connections, Stats_TotalRegistered, Stats_TotalKills, Stats_TotalDeaths, Stats_TotalHours);
    SendClientMessageEx(playerid, COLOR_GREY2, "Houses: %i/%i - Businesses: %i/%i - Garages: %i/%i - Lands: %i/%i - Vehicles: %i/%i", houses, MAX_HOUSES, businesses, MAX_BUSINESSES, garages, MAX_GARAGES, lands, MAX_LANDS, vehicles, MAX_VEHICLES);
    SendClientMessageEx(playerid, COLOR_GREY2, "Entrances: %i/%i - Turfs: %i/%i - Gangs: %i/%i - Factions: %i/%i - Lockers: %i/%i", entrances, MAX_ENTRANCES, turfs, MAX_TURFS, gangs, MAX_GANGS, factions, MAX_FACTIONS, lockers, MAX_LOCKERS);
    SendClientMessageEx(playerid, COLOR_GREY2, "Players Online: %i/%i - Player Record: %i - Record Date: %s - Anticheat Bans: %i", Iter_Count(Player), GetMaxPlayers(), Stats_PlayerRecord, Stats_PlayerRecordDate, Stats_AnticheatBans);
    return 1;
}
