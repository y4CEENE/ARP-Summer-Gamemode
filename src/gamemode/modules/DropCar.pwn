/// @file      DropCar.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

GetVehicleCranePrice(vehicleid, bool:extras = true)
{
    new amount;

    if ((VehicleInfo[vehicleid][vOwnerID] > 0) ||  (testVehicles[0] <= vehicleid <= testVehicles[4]) || IsJobCar(vehicleid))
    {
        return 0;
    }
    if ((VehicleInfo[vehicleid][vID] > 0) && (VehicleInfo[vehicleid][vFaction] >= 0 || VehicleInfo[vehicleid][vGang] >= 0 && VehicleInfo[vehicleid][vJob] >= 0))
    {
        return 0;
    }

    switch (GetVehicleModel(vehicleid))
    {
        case 481, 509, 510: // Bicycles.
            amount = 80;

        case 448, 462, 463, 468, 471: // Mid bikes.
            amount = 150;

        case 461, 521, 522, 581: // High bikes.
            amount = 200;

        case 402, 429, 475, 477, 494, 496, 502..504, 558..562, 565, 587, 589, 602, 603: // Muscle cars and mid sports cars.
            amount = 300;

        case 411, 415, 451, 506, 541: // High sports cars.
            amount = 400;

        case 403, 408, 414, 443, 455, 456, 498, 499, 514, 515, 524, 578, 609: // Boxed trucks and trucks.
            amount = 350;

        case 413, 418, 422, 440, 459, 478, 482, 543, 552, 554, 582, 600, 605: // Pickup trucks and vans.
            amount = 250;

        case 400, 424, 444, 470, 489, 495, 500, 505, 556, 557, 568, 573, 579: // Offroad vehicles
            amount = 275;

        case 412, 534..536, 566, 567, 575, 576: // Lowriders
            amount = 250;

        case 401, 404, 405, 410, 419, 421, 426, 436, 445, 458, 466, 467, 474, 479, 491, 492, 516..518, 526, 527, 529, 540, 542, 546, 547, 549..551, 580, 585, 604: // Saloon cars & station wagons.
            amount = 200;
    }

    if (extras)
    {
        amount += amount;
    }

    return amount;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_DROPCAR)
        return 1;
    new vehicleid = GetPlayerVehicleID(playerid);

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
    }
    if (IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't drop off your own vehicle.");
    }
    if (!GetVehicleCranePrice(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is not worth anything.");
    }
    if (VehicleInfo[vehicleid][vID] > 0 && IsPointInRangeOfPoint(VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], 300.0, 2695.8010, -2226.6643, 13.5501))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is parked too close to the crane. You can't deliver it.");
    }

    if (gettime() - PlayerData[playerid][pDropTime] < 10 && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        PlayerData[playerid][pACWarns]++;

        if (PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport car delivering (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerData[playerid][pDropTime]);
        }
        else if (!PlayerData[playerid][pKicked])
        {
            BanPlayer(playerid, "Teleport delivering");
        }
    }

    new money = GetVehicleCranePrice(vehicleid);

    GivePlayerCash(playerid, money);

    SetVehicleToRespawn(vehicleid);
    IncreaseJobSkill(playerid, JOB_CARJACKER);
    GiveNotoriety(playerid, 10);
    GivePlayerRankPointIllegalJob(playerid, 60);
    return SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 10 notoriety for car jacking, you now have %d.", PlayerData[playerid][pNotoriety]);
}


CMD:dropcar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (PlayerData[playerid][pThiefCooldown] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds before dropping off another car.", PlayerData[playerid][pThiefCooldown]);
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
    }
    if (PlayerHasPropertyAccess(playerid, PropertyType_Vehicle, vehicleid, KeyAccess_Doors))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't drop off a vehicle that belongs to you.");
    }
    if (!GetVehicleCranePrice(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't worth anything. Therefore you can't sell it.");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have an active checkpoint already. /killcp to cancel it.");
    }
    if (VehicleInfo[vehicleid][vID] > 0 && IsPointInRangeOfPoint(VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], 600.0, 2695.8010, -2226.6643, 13.5501))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is parked too close to the crane.");
    }

    if (!IsPlayerInRangeOfPoint(playerid, 300.0, 2695.8010, -2226.6643, 13.5501))
    {
        PlayerData[playerid][pDropTime] = gettime();
    }

    SendClientMessage(playerid, COLOR_AQUA, "Navigate to the {FF6347}checkpoint{33CCFF} at the crane to drop off your vehicle.");
    SetActiveCheckpoint(playerid, CHECKPOINT_DROPCAR, 2695.8010, -2226.6643, 13.5501, 5.0);
    return 1;
}

CMD:sellcar(playerid, params[])//TODO: fix this function
{
    new vehicleid = GetPlayerVehicleID(playerid), targetid, amount;

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }

    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellcar [playerid] [amount]");
    }

    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
    }
    if (gettime() - PlayerData[playerid][pLastSell] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
    }
    if (GetPlayerActiveCheckpoint(playerid) == CHECKPOINT_DROPCAR)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell your vehicle unless you cancel your car delivery. (/killcp)");
    }

    PlayerData[playerid][pLastSell] = gettime();
    PlayerData[targetid][pCarOffer] = playerid;
    PlayerData[targetid][pCarOffered] = vehicleid;
    PlayerData[targetid][pCarPrice] = amount;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their %s for %s (/accept vehicle).", GetRPName(playerid), GetVehicleName(vehicleid), FormatCash(amount));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your %s for %s.", GetRPName(targetid), GetVehicleName(vehicleid), FormatCash(amount));
    return 1;
}

CMD:carvalue(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be in a vehicle to use this command.");
    }
    if (PlayerHasPropertyAccess(playerid, PropertyType_Vehicle, vehicleid, KeyAccess_Doors))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle belongs to you. It's not worth anything.");
    }
    if (!GetVehicleCranePrice(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't worth anything.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Car Value _____");
    SendClientMessageEx(playerid, COLOR_GREY2, "Name: %s", GetVehicleName(vehicleid));

    if (GetVehicleCranePrice(vehicleid, false) == GetVehicleCranePrice(vehicleid))
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Value: {00AA00}$%i", GetVehicleCranePrice(vehicleid));
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Value: {00AA00}$%i", GetVehicleCranePrice(vehicleid, false));

        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            if (VehicleInfo[vehicleid][vNeon] != 0)
            {
                SendClientMessage(playerid, COLOR_GREY2, "Neon: {00AA00}+$1000");
            }
            if (VehicleInfo[vehicleid][vAlarm] != 0)
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "Alarm: {00AA00}+$%i", VehicleInfo[vehicleid][vAlarm] * 500);
            }
            if (VehicleInfo[vehicleid][vTrunk] != 0)
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "Trunk: {00AA00}+$%i", VehicleInfo[vehicleid][vTrunk] * 250);
            }
        }

        SendClientMessageEx(playerid, COLOR_GREY2, "Total Value: {00AA00}$%i", GetVehicleCranePrice(vehicleid));
    }

    return 1;
}
