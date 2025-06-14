#include <YSI\y_hooks>

#define TABLE_SERVER_STATS     "server_stats"
#define SERVER_STATS_FILENAME  "server_stats.json"

new gPlayerRecord, gPlayerRecordDate[24], gConnections, gTotalRegistered, gTotalKills, gTotalDeaths, gTotalHours, gAnticheatBans;

static loading = true;
static writeToFile = false;
static updateTime = 1;
static isServerStatsUpToDate = false;
static lastServerUpdate = 0;

hook OnPlayerConnect(playerid)
{
    if(Iter_Count(Player) > gPlayerRecord)
	{
		gPlayerRecord = Iter_Count(Player);
		gPlayerRecordDate = GetDateTime();
        isServerStatsUpToDate = false;
	}
    return 1;
}

hook OnPlayerInit(playerid)
{
    gConnections++;
    isServerStatsUpToDate = false;
    return 1;
}

IncreaseTotalRegistered()
{
    gTotalRegistered++;
    isServerStatsUpToDate = false;
    return 1;
}

IncreaseTotalHours()
{
    gTotalHours++;
    isServerStatsUpToDate = false;
    return 1;
}

IncreaseAnticheatBans()
{
    gAnticheatBans++;
    isServerStatsUpToDate = false;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(!IsPlayerConnected(playerid) || !PlayerData[playerid][pLogged])
    {
        return 1;
    }

	if((gettime() - PlayerData[playerid][pLastDeath]) < 2)
	{
	    return 1;
	}

    if(!IsPlayerConnected(killerid) || !PlayerData[killerid][pLogged])
    {
        gTotalDeaths++;
    }
    else
    {
        gTotalKills++;
    }
    isServerStatsUpToDate = false;
    return 1;
}

hook OnLoadGameMode()
{    
    if(!strcmp(GetServerStatsWriteToFile(), "true", true))
    {
        writeToFile = true;
    }
    new t = strval(GetServerStatsUpdateTime());
    if(t <= 0)
    {
        t = 1;
    }
    updateTime = t;
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "select *, (select count(*) from users) as db_total_registered, (select sum(hours) from "#TABLE_USERS") as db_total_hours from "#TABLE_SERVER_STATS);
    mysql_tquery(connectionID, queryBuffer, "OnLoadServerStats");

    return 1;
}

publish OnLoadServerStats()
{
    cache_get_field_content(0, "player_record_date", gPlayerRecordDate, connectionID, 24);
    gPlayerRecord    = cache_get_field_content_int(0, "player_record");
    gTotalDeaths     = cache_get_field_content_int(0, "total_deaths");
    gTotalKills      = cache_get_field_content_int(0, "total_kills");
    gAnticheatBans   = cache_get_field_content_int(0, "total_anticheat_bans");
    gConnections     = cache_get_field_content_int(0, "total_connections");
    gTotalHours      = cache_get_field_content_int(0, "db_total_hours");
    gTotalRegistered = cache_get_field_content_int(0, "db_total_registered");
    
    loading = false;
}

hook OnServerHeartBeat(timestamp)
{
    if(!loading && !isServerStatsUpToDate && (timestamp - lastServerUpdate) > updateTime)
    {
        isServerStatsUpToDate = true;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_SERVER_STATS" SET \
        player_record = %i, player_record_date = '%e', total_deaths = %i, total_kills = %i, total_anticheat_bans = %i, total_hours = %i, total_registered = %i, total_connections = %i", 
        gPlayerRecord, gPlayerRecordDate, gTotalDeaths, gTotalKills, gAnticheatBans, gTotalHours, gTotalRegistered, gConnections);
        mysql_tquery(connectionID, queryBuffer, "SaveServerStatsToFile");
    }
    return 1;
}

publish SaveServerStatsToFile()
{
    if(writeToFile)
    {
        new string[512];
        format(string, sizeof(string), "{\n \"player_record\":%i,\n \"player_record_date\":\"%s\",\n \"total_deaths\":%i,\n \"total_kills\":%i,\n \"total_anticheat_bans\":%i,\n \"total_hours\":%i,\n \"total_registered\":%i,\n \"total_connections\":%i\n}", 
            gPlayerRecord, gPlayerRecordDate, gTotalDeaths, gTotalKills, gAnticheatBans, gTotalHours, gTotalRegistered, gConnections);

        new File:file = fopen(SERVER_STATS_FILENAME, io_write);
        if(file)
        {
            fwrite(file, string);
            fclose(file);
        }
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
	for(new i = 0; i < MAX_GANGS; i ++) 	 if(GangInfo[i][gSetup]) 		gangs++;
	for(new i = 0; i < MAX_FACTIONS; i ++) 	 if(FactionInfo[i][fType]) 		factions++;
	for(new i = 0; i < MAX_LOCKERS; i ++) 	 if(LockerInfo[i][lExists]) 	lockers++;

	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ %s Stats ______", GetServerName());
	SendClientMessageEx(playerid, COLOR_GREY2, "Connections: %i - Registered: %i - Kill Counter: %i - Death Counter: %i - Hours Played: %i", gConnections, gTotalRegistered, gTotalKills, gTotalDeaths, gTotalHours);
	SendClientMessageEx(playerid, COLOR_GREY2, "Houses: %i/%i - Businesses: %i/%i - Garages: %i/%i - Lands: %i/%i - Vehicles: %i/%i", houses, MAX_HOUSES, businesses, MAX_BUSINESSES, garages, MAX_GARAGES, lands, MAX_LANDS, vehicles, MAX_VEHICLES);
	SendClientMessageEx(playerid, COLOR_GREY2, "Entrances: %i/%i - Turfs: %i/%i - Gangs: %i/%i - Factions: %i/%i - Lockers: %i/%i", entrances, MAX_ENTRANCES, turfs, MAX_TURFS, gangs, MAX_GANGS, factions, MAX_FACTIONS, lockers, MAX_LOCKERS);
	SendClientMessageEx(playerid, COLOR_GREY2, "Players Online: %i/%i - Player Record: %i - Record Date: %s - Anticheat Bans: %i", Iter_Count(Player), MAX_PLAYERS, gPlayerRecord, gPlayerRecordDate, gAnticheatBans);
	return 1;
}

