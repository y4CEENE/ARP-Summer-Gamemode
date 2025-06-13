/// @file      Job_Construction.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-10-10 17:26:46 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static Construction_MinPayment = 50;
static Construction_MaxPayment = 80;

static MCIndex[MAX_PLAYERS];
static MCTimeOut[MAX_PLAYERS];

enum eCimentCycle
{
    Float:ccX,
    Float:ccY,
    Float:ccZ,
    ccTask[24]
};

static MCCycle[][eCimentCycle] =
{
    { -2045.6644, -204.5797, 35.3203, "Get rocks"},
    { -2019.0441, -228.6365, 35.3203, "Drop rock"},
    { -2036.2573, -232.1140, 35.4627, "Get sand"},
    { -2019.0441, -228.6365, 35.3203, "Drop sand"},
    { -2068.9702, -263.1207, 35.4279, "Get rocks"},
    { -2019.0441, -228.6365, 35.3203, "Drop rocks"},
    { -2026.1760, -276.6941, 35.3203, "Get ciment"},
    { -2087.5781, -251.1111, 35.3203, "Drop ciment"}
};

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "construction", config))
    {
        JSON_GetInt(config, "min_payment", Construction_MinPayment);
        JSON_GetInt(config, "max_payment", Construction_MaxPayment);
    }
}

hook OnGameModeInit()
{
    CreateDynamicObject(3214, -2087.53418, -251.66980, 42.77020,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11081, -2061.21411, -272.43149, 40.42530,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11290, -2049.45483, -262.76779, 39.67030,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(16076, -2027.81201, -272.57590, 38.19813,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(16072, -2019.12451, -248.30150, 41.89970,   0.00000, 0.00000, 119.00100);
    CreateDynamicObject(3214, -2018.92810, -229.61630, 42.70694,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(16085, -2062.95947, -230.98900, 35.45240,   0.00000, 0.00000, 294.62549);
    CreateDynamicObject(16077, -2055.79248, -207.26450, 36.45230,   0.00000, 0.00000, 228.12601);
    CreateDynamicObject(16337, -2061.13989, -106.73709, 34.90140,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(944, -2087.98828, -157.34589, 35.01238,   0.00000, 0.00000, 354.66022);
    CreateDynamicObject(944, -2091.99365, -157.56198, 35.01238,   0.00000, 0.00000, 2.32392);
    CreateDynamicObject(944, -2092.58740, -159.77783, 35.01238,   0.00000, 0.00000, 356.65494);
    CreateDynamicObject(944, -2088.39233, -162.74355, 35.01238,   0.00000, 0.00000, 47.52940);
    CreateDynamicObject(944, -2088.39722, -159.69429, 35.01238,   0.00000, 0.00000, 2.44716);
    CreateDynamicObject(944, -2091.81836, -162.02971, 35.01238,   0.00000, 0.00000, 1.04622);
    CreateDynamicObject(16084, -2079.88989, -188.70929, 30.13470,   0.00000, 0.00000, 14.00000);
    CreateDynamicObject(16084, -2026.64661, -190.32681, 30.13470,   0.00000, 0.00000, 194.00000);
    CreateDynamicObject(10985, -2084.90405, -269.86340, 35.44680,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(10984, -2074.49561, -270.88748, 35.17700,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2092.92334, -170.87538, 36.07150,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2073.96460, -174.93303, 36.07150,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2078.56641, -174.56726, 36.07150,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2069.63086, -175.29097, 36.07150,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2065.12183, -175.80679, 36.07150,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2083.13965, -173.12656, 36.07150,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3865, -2088.46313, -171.55702, 36.07150,   0.00000, 0.00000, 0.00000);
    return 1;
}

hook OnRemoveBuildings(playerid)
{
    RemoveBuildingForPlayer(playerid, 11372, -2076.4375, -107.9297, 36.9688, 0.25);
    RemoveBuildingForPlayer(playerid, 11014, -2076.4375, -107.9297, 36.9688, 0.25);
    return 1;
}


hook OnPlayerReset(playerid)
{
    if (MCTimeOut[playerid] > 0)
    {
        ClearAnimations(playerid, 1);
    }
    MCTimeOut[playerid] = 0;

    return 1;
}

CMD:makeciment(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_CONSTRUCTION))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a construction worker.");
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't work while in vehicle.");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_AQUA, "Make sure you dont have any checkpoint. Use /kcp to clear current checkpoints.");
    }
    MCIndex[playerid] = 0;
    SendClientMessageEx(playerid, COLOR_AQUA, "Task: %s", MCCycle[MCIndex[playerid]][ccTask]);
    SetActiveCheckpoint(playerid, CHECKPOINT_MAKECIMENT, MCCycle[MCIndex[playerid]][ccX], MCCycle[MCIndex[playerid]][ccY], MCCycle[MCIndex[playerid]][ccZ], 5.0);
    return 1;
}


hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_MAKECIMENT)
        return 1;

    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't work while in vehicle.");
    }

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 9);

    if (MCIndex[playerid] + 1 == sizeof(MCCycle))
    {
        MCIndex[playerid] = 0;
        new amount = Random(Construction_MinPayment, Construction_MaxPayment);
        new string[64];
        format(string, sizeof(string), "~g~+$%i", amount);
        GameTextForPlayer(playerid, string, 5000, 1);

        AddToPaycheck(playerid, amount);
        GivePlayerRankPointLegalJob(playerid, 50);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}%s{33CCFF} on your paycheck for your work.", FormatCash(amount));
        ClearAnimations(playerid, 1);
        return 1;
    }

    SendClientMessageEx(playerid, COLOR_AQUA, "Task: %s", MCCycle[MCIndex[playerid]][ccTask]);
    MCTimeOut[playerid] = 3;
    ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.1, 1, 0, 0, 0, 0, 1);
    SetPlayerAttachedObject(playerid, 9, 337, 6);
    return 1;
}


hook OnPlayerHeartBeat(playerid)
{
    if (MCTimeOut[playerid])
    {
        MCTimeOut[playerid]--;

        if (MCTimeOut[playerid] == 0)
        {
            RemovePlayerAttachedObject(playerid, 9);
            SetPlayerAttachedObject(playerid, 9, 3014, 1, 0.12, 0.5, -0.1, 0.0, 270.0, 0.0);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
            ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

            MCIndex[playerid]++;
            SetActiveCheckpoint(playerid, CHECKPOINT_MAKECIMENT, MCCycle[MCIndex[playerid]][ccX], MCCycle[MCIndex[playerid]][ccY], MCCycle[MCIndex[playerid]][ccZ], 5.0);
        }
    }
}
