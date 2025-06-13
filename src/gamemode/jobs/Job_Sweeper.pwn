/// @file      Job_Sweeper.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static sweeperVehicles[18];
static Sweeping[MAX_PLAYERS];
static SweepTime[MAX_PLAYERS];
static SweepEarnings[MAX_PLAYERS];

static Sweeper_BasePrice = 100;
static Sweeper_RandomPrice = 50;
static Sweeper_CooldownSeconds = 80;

IsSweepingVehicle(vehicleid)
{
    return (sweeperVehicles [0] <= vehicleid <= sweeperVehicles [sizeof(sweeperVehicles) - 1]);
}

StartSweeping(playerid)
{
    if (Sweeping[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are sweeping already. /stopsweeping to stop.");
    }
    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 574)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not sitting inside a Sweeper.");
    }

    Sweeping[playerid] = 1;
    SweepTime[playerid] = 80;
    SweepEarnings[playerid] = 0;

    SendClientMessage(playerid, COLOR_AQUA, "* You are now sweeping. Drive around with your sweeper to earn money towards your paycheck.");
    return 1;
}

StopSweeping(playerid)
{
    if (!Sweeping[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not sweeping right now.");
    }

    SendClientMessageEx(playerid, COLOR_AQUA, "* You are no longer sweeping. You earned a total of {00AA00}$%i{33CCFF} towards your paycheck during your shift.", SweepEarnings[playerid]);
    Sweeping[playerid] = 0;
    SweepTime[playerid] = 0;
    SweepEarnings[playerid] = 0;
    return 1;
}

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "sweeper", config))
    {
        JSON_GetInt(config, "base_price",       Sweeper_BasePrice);
        JSON_GetInt(config, "random_price",     Sweeper_RandomPrice);
        JSON_GetInt(config, "cooldown_seconds", Sweeper_CooldownSeconds);
    }

    sweeperVehicles[0] = AddStaticVehicleEx(574, 2187.6636, -1975.8738, 13.3012, 180.0000, 26, 26, 300); // sweeper 1
    sweeperVehicles[1] = AddStaticVehicleEx(574, 2184.9255, -1975.8738, 13.3029, 180.0000, 26, 26, 300); // sweeper 2
    sweeperVehicles[2] = AddStaticVehicleEx(574, 2181.8672, -1975.8738, 13.3005, 180.0000, 26, 26, 300); // sweeper 3
    sweeperVehicles[3] = AddStaticVehicleEx(574, 2179.0005, -1975.8738, 13.2679, 180.0000, 26, 26, 300); // sweeper 4
    sweeperVehicles[4] = AddStaticVehicleEx(574, 2173.3564, -1976.1001, 13.2799, 176.8126, 26, 26, 300); // Sweeper 574
    sweeperVehicles[5] = AddStaticVehicleEx(574, 2170.4497, -1976.0883, 13.2801, 177.9358, 26, 26, 300); // Sweeper 574
    sweeperVehicles[6] = AddStaticVehicleEx(574, 2192.2224, -1985.3699, 13.2750, 94.19140, 26, 26, 300); // Sweeper 574
    sweeperVehicles[7] = AddStaticVehicleEx(574, 2192.3171, -1988.2561, 13.2720, 94.86550, 26, 26, 300); // Sweeper 574
    sweeperVehicles[8] = AddStaticVehicleEx(574, 2192.5437, -1991.5342, 13.2720, 95.74950, 26, 26, 300); // Sweeper 574
    sweeperVehicles[9] = AddStaticVehicleEx(574, 2192.5432, -1994.6887, 13.2721, 93.93960, 26, 26, 300); // Sweeper 574
    sweeperVehicles[10] = AddStaticVehicleEx(574, 2192.6975, -1997.8274, 13.2721, 93.9140, 26, 26, 300); // Sweeper 574
    sweeperVehicles[11] = AddStaticVehicleEx(574, 2181.2537, -1993.1422, 13.2922, 313.7846, 26, 26, 300); // Sweeper    574
    sweeperVehicles[12] = AddStaticVehicleEx(574, 2178.6917, -1990.9169, 13.2707, 318.3488, 26, 26, 300); // Sweeper    574
    sweeperVehicles[13] = AddStaticVehicleEx(574, 2175.7310, -1988.2180, 13.2752, 315.0988, 26, 26, 300); // Sweeper    574
    sweeperVehicles[14] = AddStaticVehicleEx(574, 2172.9075, -1986.2037, 13.2760, 323.0492, 26, 26, 300); // Sweeper    574
    sweeperVehicles[15] = AddStaticVehicleEx(574, 2168.8049, -1985.5548, 13.2758, 319.2138, 26, 26, 300); // Sweeper    574
    sweeperVehicles[16] = AddStaticVehicleEx(574, 2182.8384, -1995.6630, 13.2720, 308.7154, 26, 26, 300); // Sweeper    574
    sweeperVehicles[17] = AddStaticVehicleEx(574, 2176.0437, -1975.9700, 13.2794, 179.8427, 26, 26, 300); // Sweeper    574

    return 1;
}

hook OnPlayerConnect(playerid)
{
    Sweeping[playerid] = 0;
    SweepTime[playerid] = 0;
    SweepEarnings[playerid] = 0;
}

hook OnPlayerHeartBeat(playerid)
{
    new string[256];
    new vehicleid = GetPlayerVehicleID(playerid);

    if (Sweeping[playerid] && GetVehicleModel(vehicleid) == 574 && GetVehicleSpeed(vehicleid) > 35.0 && !IsPlayerAFK(playerid))
    {
        SweepTime[playerid]--;

        if (SweepTime[playerid] <= 0)
        {
            new cost = Sweeper_BasePrice + random(Sweeper_RandomPrice);

            if (PlayerData[playerid][pLaborUpgrade] > 0)
            {
                cost += percent(cost, PlayerData[playerid][pLaborUpgrade]);
            }

            AddToPaycheck(playerid, cost);

            format(string, sizeof(string), "~g~+$%i", cost);
            GameTextForPlayer(playerid, string, 5000, 1);
            GivePlayerCash(playerid, cost);

            GiveNotoriety(playerid, -5);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have lost -5 notoriety for public services, you now have %d.", PlayerData[playerid][pNotoriety]);

            SweepEarnings[playerid] += cost;
            SweepTime[playerid] = Sweeper_CooldownSeconds;
        }
    }
    return 1;
}


hook OnPlayerExitJobCar(playerid, vehicleid, jobtype)
{
    if (jobtype == JOB_SWEEPER)
    {
        StopSweeping(playerid);
    }
}

hook OnPlayerEnterJobCar(playerid, vehicleid, jobtype)
{
    if (jobtype == JOB_SWEEPER)
    {
        StartSweeping(playerid);
    }
}
