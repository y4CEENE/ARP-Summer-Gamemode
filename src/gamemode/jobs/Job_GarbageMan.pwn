/// @file      Job_GarbageMan.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static GarbagePayment_Base = 800;
static GarbagePayment_MaxRandomTip = 300;

static garbageVehicles[6];

IsGarbageManVehicle(vehicleid)
{
    return (garbageVehicles[0] <= vehicleid <= garbageVehicles[sizeof(garbageVehicles) - 1]);
}

hook OnLoadGameMode(timestamp)
{

    garbageVehicles[0] = AddStaticVehicleEx(408,2393.8396,-2067.1531,14.0653,269.0117,-1,-1,300); // Garbage 1
    garbageVehicles[1] = AddStaticVehicleEx(408,2393.5693,-2073.0764,14.0457,267.8859,-1,-1,300); // Garbage 2
    garbageVehicles[2] = AddStaticVehicleEx(408,2393.7993,-2078.0479,14.0671,268.3996,-1,-1,300); // Garbage 3
    garbageVehicles[3] = AddStaticVehicleEx(408,2393.9253,-2082.4292,14.0769,269.0119,-1,-1,300); // Garbage 4
    garbageVehicles[4] = AddStaticVehicleEx(408,2393.5903,-2087.6238,14.0850,267.6086,-1,-1,300); // Garbage 5
    garbageVehicles[5] = AddStaticVehicleEx(408,2393.9868,-2093.4773,14.0934,270.5913,-1,-1,300); // Garbage 6

    //Garbageman
    CreateDynamicObject(849,2389.9387200,-2105.4360400,12.8231000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(854,2390.0080600,-2103.6989700,12.7462000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(851,2391.9619100,-2104.5752000,12.8073000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(853,2390.5703100,-2107.2663600,12.9275000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(852,2388.7666000,-2106.1113300,12.5072000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(1338,2387.9494600,-2108.0686000,13.2269000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(3035,2387.2028800,-2105.0000000,13.1672000,0.0000000,0.0000000,90.0000000); //
    CreateDynamicObject(3035,2387.2028800,-2102.8000500,13.1672000,0.0000000,0.0000000,90.0000000); //
    CreateDynamicObject(5422,2369.3999000,-2093.4152800,14.5574000,0.0000000,0.0000000,90.0000000); //
    CreateDynamicObject(11714,2376.7199700,-2071.1201200,15.0024000,0.0000000,0.0000000,0.0000000); //
    CreateDynamicObject(18248, 2380.57715, -2130.29199, 19.74463,   0.00000, 0.00000, 82.50024);

    new Node:job;
    new Node:garbage;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "garbage_man", garbage))
    {
        JSON_GetInt(garbage, "payment_base",           GarbagePayment_Base);
        JSON_GetInt(garbage, "payment_max_random_tip", GarbagePayment_MaxRandomTip);
    }
    return 1;
}

publish garbagewait(playerid)
{
    ShowPlayerFooter(playerid, "Garbage Loaded....~n~Proceed to the next checkpoint.");
    TogglePlayerControllableEx(playerid, 1);
}


hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_GARBAGE)
        return 1;

    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 408 && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a Trashmaster.");
    }
    if (PlayerData[playerid][pGarbage] == 1)
    {
        GameTextForPlayer(playerid, "Loading Garbage....~n~Please wait.", 5000, 3);
        TogglePlayerControllableEx(playerid, 0);
        SetTimerEx("garbagewait", 5000, false, "i", playerid);

        PlayerData[playerid][pGarbage] = 2;
        SetActiveCheckpoint(playerid, CHECKPOINT_GARBAGE, 1138.8413,-1333.5553,13.6871, 5.0);
    }
    if (PlayerData[playerid][pGarbage] == 2)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 1138.8413,-1333.5553,13.6871))
        {
            GameTextForPlayer(playerid, "Loading Garbage....~n~Please wait.", 5000, 3);
            TogglePlayerControllableEx(playerid, 0);
            SetTimerEx("garbagewait", 5000, false, "i", playerid);
            PlayerData[playerid][pGarbage] = 3;
            SetActiveCheckpoint(playerid, CHECKPOINT_GARBAGE, 2121.7314,-1342.7231,23.9844, 5.0);
        }

    }
    if (PlayerData[playerid][pGarbage] == 3)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 2121.7314,-1342.7231,23.9844))
        {
            GameTextForPlayer(playerid, "Loading Garbage....~n~Please wait..", 5000, 3);
            TogglePlayerControllableEx(playerid, 0);
            SetTimerEx("garbagewait", 5000, false, "i", playerid);
            PlayerData[playerid][pGarbage] = 4;
            SetActiveCheckpoint(playerid, CHECKPOINT_GARBAGE, 1920.7303,-1791.3890,13.3828, 5.0);
        }
    }
    if (PlayerData[playerid][pGarbage] == 4)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 1920.7303,-1791.3890,13.3828))
        {
            GameTextForPlayer(playerid, "Loading Garbage....~n~Please wait.", 5000, 3);
            TogglePlayerControllableEx(playerid, 0);
            SetTimerEx("garbagewait", 5000, false, "i", playerid);
            PlayerData[playerid][pGarbage] = 5;
            SetActiveCheckpoint(playerid, CHECKPOINT_GARBAGE, 2392.6050,-2106.0879,13.5469, 5.0);
        }

    }
    if (PlayerData[playerid][pGarbage] == 5)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 2392.6050,-2106.0879,13.5469))
        {
            GameTextForPlayer(playerid, "Unloading Garbage....~n~Please wait.", 5000, 3);
            PlayerData[playerid][pGarbage] = 0;
            new amount = GarbagePayment_Base + random(GarbagePayment_MaxRandomTip);
            SendClientMessageEx(playerid, COLOR_AQUA, "Paycheck: You've earned $%i for your time working as a garbage man.", amount);
            GivePlayerCash(playerid, amount);
        }
    }
    GiveNotoriety(playerid, -2);
    GivePlayerRankPointLegalJob(playerid, 60);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have lost -2 notoriety for public service, you now have %d.", PlayerData[playerid][pNotoriety]);
    return 1;
}

CMD:garbage(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!PlayerHasJob(playerid, JOB_GARBAGEMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a Garbage Man.");
    }

    if (!IsPlayerInRangeOfPoint(playerid, 8.0,  2404.9758, -2070.3882, 13.5469))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the starting point");
    }
    if (PlayerData[playerid][pGarbage] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're already doing a garbage run!");
    }
    if (GetVehicleModel(vehicleid) == 408 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {

        GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
        PlayerData[playerid][pGarbage] = 1;
        SetActiveCheckpoint(playerid, CHECKPOINT_GARBAGE, 2382.1963,-1937.9064,13.5469, 5.0);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You must be in a trashmaster vehicle as a driver");
    }
    return 1;
}
