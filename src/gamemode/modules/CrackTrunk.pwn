/// @file      CrackTrunk.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static CrackTrunk[MAX_PLAYERS];
static CrackTime[MAX_PLAYERS];
static CrackFrom[MAX_PLAYERS];

hook OnPlayerReset(playerid)
{
    CrackTrunk[playerid] = INVALID_VEHICLE_ID;
}

hook OnPlayerInit(playerid)
{
    CrackTime[playerid]  = 0;
    CrackFrom[playerid]  = INVALID_VEHICLE_ID;
    CrackTrunk[playerid] = INVALID_VEHICLE_ID;
}

Dialog:CrackTrunk(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }

    new vehicleid = CrackFrom[playerid], amount;

    if (!IsPlayerInRangeOfBoot(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't steal anything from the trunk now. You're not near it.");
    }

    if (VehicleInfo[vehicleid][vLocked])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't steal anything from the trunk now. The vehicle is locked!");
    }

    if (strfind(inputtext, "Weed") != -1 && (amount = VehicleInfo[vehicleid][vWeed] / 20) > 0)
    {
        if (PlayerData[playerid][pWeed] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
            return ShowDialogCrackTrunk(playerid);
        }

        VehicleInfo[vehicleid][vWeed] -= amount;
        PlayerData[playerid][pWeed] += amount;

        DBQuery("UPDATE vehicles SET weed = %i WHERE id = %i", VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vID]);
        DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
        ShowActionBubble(playerid, "* %s steals %i grams of weed from the trunk.", GetRPName(playerid), amount);
    }
    else if (strfind(inputtext, "Cocaine") != -1 && (amount = VehicleInfo[vehicleid][vCocaine]/20) > 0)
    {
        if (PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
            return ShowDialogCrackTrunk(playerid);
        }

        VehicleInfo[vehicleid][vCocaine] -= amount;
        PlayerData[playerid][pCocaine] += amount;

        DBQuery("UPDATE vehicles SET cocaine = %i WHERE id = %i", VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vID]);
        DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
        ShowActionBubble(playerid, "* %s steals %i grams of cocaine from the trunk.", GetRPName(playerid), amount);
    }
    else if (strfind(inputtext, "Heroin") != -1 && (amount = VehicleInfo[vehicleid][vHeroin]/20) > 0)
    {
        if (PlayerData[playerid][pHeroin] + amount > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
            return ShowDialogCrackTrunk(playerid);
        }

        VehicleInfo[vehicleid][vHeroin] -= amount;
        PlayerData[playerid][pHeroin] += amount;

        DBQuery("UPDATE vehicles SET heroin = %i WHERE id = %i", VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vID]);
        DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
        ShowActionBubble(playerid, "* %s steals %i grams of Heroin from the trunk.", GetRPName(playerid), amount);
    }
    else if (strfind(inputtext, "Painkillers") != -1 && (amount = VehicleInfo[vehicleid][vPainkillers]/20) > 0)
    {
        if (PlayerData[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
            return ShowDialogCrackTrunk(playerid);
        }

        VehicleInfo[vehicleid][vPainkillers] -= amount;
        PlayerData[playerid][pPainkillers] += amount;

        DBQuery("UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);
        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
        ShowActionBubble(playerid, "* %s steals %i painkillers from the trunk.", GetRPName(playerid), amount);
    }
    else if (strfind(inputtext, "Materials") != -1 && (amount = VehicleInfo[vehicleid][vMaterials]/20) > 0)
    {
        if (PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
            return ShowDialogCrackTrunk(playerid);
        }

        VehicleInfo[vehicleid][vMaterials] -= amount;
        PlayerData[playerid][pMaterials] += amount;

        DBQuery("UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);
        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
        ShowActionBubble(playerid, "* %s steals %i materials from the trunk.", GetRPName(playerid), amount);
    }
    else if (strfind(inputtext, "Cash") != -1 && (amount = VehicleInfo[vehicleid][vCash]/20) > 0)
    {
        VehicleInfo[vehicleid][vCash] -= amount;
        PlayerData[playerid][pCash] += amount;

        DBQuery("UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);
        DBQuery("UPDATE "#TABLE_USERS" SET cash = %i WHERE uid = %i", PlayerData[playerid][pCash], PlayerData[playerid][pID]);
        ShowActionBubble(playerid, "* %s steals %s worth of cash from the trunk.", GetRPName(playerid), FormatCash(amount));
    }
    else
    {
        for (new i = 0; i < 5; i ++)
        {
            if (VehicleInfo[vehicleid][vWeapons][i] != 0 && !strcmp(GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]), inputtext))
            {
                if (PlayerHasWeapon(playerid, VehicleInfo[vehicleid][vWeapons][i]))
                {
                    SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    return ShowDialogCrackTrunk(playerid);
                }

                GivePlayerWeaponEx(playerid, VehicleInfo[vehicleid][vWeapons][i]);
                ShowActionBubble(playerid, "* %s steals a %s from the trunk.", GetRPName(playerid), GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
                DBQuery("UPDATE vehicles SET weapon_%i = 0 WHERE id = %i", i + 1, VehicleInfo[vehicleid][vID]);
                VehicleInfo[vehicleid][vWeapons][i] = 0;
                break;
            }
        }
    }
    CrackTrunk[playerid] = INVALID_PLAYER_ID;
    return 1;
}


ShowDialogCrackTrunk(playerid)
{
    new vehicleid = CrackFrom[playerid];
    new string[256];

    string = "Content\tQuantity";

    if (VehicleInfo[vehicleid][vCash] / 20 > 0)
        format(string, sizeof(string), "%s\nCash\t%s", string, FormatCash(VehicleInfo[vehicleid][vCash] / 20));

    if (VehicleInfo[vehicleid][vMaterials] / 20 > 0)
        format(string, sizeof(string), "%s\nMaterials\t%s", string, FormatNumber(VehicleInfo[vehicleid][vMaterials] / 20));

    if (VehicleInfo[vehicleid][vWeed] / 20 > 0)
        format(string, sizeof(string), "%s\nWeed\t%ig", string, VehicleInfo[vehicleid][vWeed] / 20);

    if (VehicleInfo[vehicleid][vCocaine] / 20 > 0)
        format(string, sizeof(string), "%s\nCocaine\t%ig", string, VehicleInfo[vehicleid][vCocaine] / 20);

    if (VehicleInfo[vehicleid][vHeroin] / 20 > 0)
        format(string, sizeof(string), "%s\nHeroin\t%ig", string, VehicleInfo[vehicleid][vHeroin] / 20);

    if (VehicleInfo[vehicleid][vPainkillers] / 20 > 0)
        format(string, sizeof(string), "%s\nPainkillers\t%ig", string, VehicleInfo[vehicleid][vPainkillers] / 20);

    for (new x = 0; x < 5; x ++)
    {
        if (VehicleInfo[vehicleid][vWeapons][x] != 0)
        {
            format(string, sizeof(string), "%s\n%s\t ", string, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][x]));
        }
    }

    Dialog_Show(playerid, CrackTrunk, DIALOG_STYLE_TABLIST_HEADERS, "Choose ONE item to take from the trunk.", string, "Take", "Cancel");
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (CrackTrunk[playerid] == INVALID_VEHICLE_ID)
        return 1;


    if (!IsPlayerInRangeOfBoot(playerid, CrackTrunk[playerid]))
    {
        CrackTrunk[playerid] = INVALID_VEHICLE_ID;
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer cracking the trunk as you left your spot.");
    }

    if (VehicleInfo[CrackTrunk[playerid]][vLocked])
    {
        CrackTrunk[playerid] = INVALID_VEHICLE_ID;
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer cracking the trunk as the vehicle is now locked.");
    }

    CrackTime[playerid]--;

    if (CrackTime[playerid] <= 0)
    {
        new count;

        for (new x = 0; x < 5; x ++)
        {
            if (VehicleInfo[CrackTrunk[playerid]][vWeapons][x] != 0)
            {
                count++;
            }
        }

        if (count == 0 &&
            VehicleInfo[CrackTrunk[playerid]][vCocaine] == 0 &&
            VehicleInfo[CrackTrunk[playerid]][vHeroin] == 0 &&
            VehicleInfo[CrackTrunk[playerid]][vWeed] == 0 &&
            VehicleInfo[CrackTrunk[playerid]][vPainkillers] == 0 &&
            VehicleInfo[CrackTrunk[playerid]][vMaterials] == 0 &&
            VehicleInfo[CrackTrunk[playerid]][vCash] == 0)
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s cracks open the trunk of the %s and finds nothing.",
                                 GetRPName(playerid), GetVehicleName(CrackTrunk[playerid]));
        }
        else
        {
            CrackFrom[playerid] = CrackTrunk[playerid];
            ShowDialogCrackTrunk(playerid);
        }
        CrackTrunk[playerid] = INVALID_VEHICLE_ID;
    }
    else
    {
        new string[40];
        format(string, sizeof(string), "~w~Cracking trunk... ~r~%i", CrackTime[playerid]);
        GameTextForPlayer(playerid, string, 2000, 3);
    }
    return 1;
}

CMD:cracktrunk(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);

    if (PlayerData[playerid][pCocaineCooldown] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds before cracking into another trunk.", PlayerData[playerid][pCocaineCooldown]);
    }
    if (vehicleid == INVALID_VEHICLE_ID || !IsPlayerInRangeOfBoot(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be close to a vehicle's trunk.");
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from inside the vehicle.");
    }
    if (IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't cocaine the trunk on your own vehicle.");
    }
    if (VehicleInfo[vehicleid][vOwnerID] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only cocaine into a player owned vehicle's trunk.");
    }
    if (VehicleInfo[vehicleid][vLocked])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is locked. /breakin to attempt to unlock it.");
    }
    if (CrackTrunk[playerid] != INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already cracking a trunk at the moment. Leave the area to cancel.");
    }
    CrackTrunk[playerid] = vehicleid;

    ShowActionBubble(playerid, "* %s begins to pry open the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    SendClientMessageEx(playerid, COLOR_WHITE, "* This will take about %i seconds. Do not move during the process.", CrackTime[playerid]);
    return 1;
}
