/// @file      Police.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

stock GetPlayerNotorietyFine(playerid)
{
    new money = PlayerData[playerid][pCash] + PlayerData[playerid][pBank];
    new noto = PlayerData[playerid][pNotoriety];
    new fine = 0;

    if (noto > 20000)
    {
        fine = percent(money, 25);
    }
    else if (noto > 14000)
    {
        fine = percent(money, 20);
    }
    else if (noto > 8000)
    {
        fine = percent(money, 15);
    }
    else if (noto > 4000)
    {
        fine = percent(money, 10);
    }
    if (fine > 25000)
    {
        fine = 25000;
    }
    return fine;
}

publish RechargeTazer(playerid)
{
    if (PlayerData[playerid][pTazer])
    {
        GivePlayerWeapon(playerid, 23, 1);
    }
    TogglePlayerControllableEx(playerid, 1);
}

GetWantedLevel(playerid)
{
    return PlayerData[playerid][pWantedLevel];
}

GiveWantedLevel(playerid, amount)
{
    SetWantedLevel(playerid, PlayerData[playerid][pWantedLevel] + amount);
}

SetWantedLevel(playerid, value)
{
    new newValue = value < 0 ? 0 : (value > 6 ? 6 : value);
    if (newValue != PlayerData[playerid][pWantedLevel])
    {
        PlayerData[playerid][pWantedLevel] = newValue;
        DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = %i WHERE uid = %i", PlayerData[playerid][pWantedLevel], PlayerData[playerid][pID]);
    }
}

ArrestPlayer(playerid, const reason[], arrestedby = INVALID_PLAYER_ID)
{
    new minutes = GetWantedLevel(playerid) * 10;
    new notorityfine = GetPlayerNotorietyFine(playerid);
    new fine = minutes * 50;

    if (notorityfine > 0)
    {
        SendClientMessageEx(playerid, COLOR_VIP, "You was fined $%d for having %d notoriety.", notorityfine, PlayerData[playerid][pNotoriety]);
        fine += notorityfine;
    }

    if (PlayerData[playerid][pDonator] == 1)
    {
        SendClientMessageEx(playerid, COLOR_VIP, "VIP Perk: Your %i minutes of jail time has been reduced by 50 percent to %i minutes.", minutes, percent(minutes, 50));
        minutes = percent(minutes, 50);
    }
    else if (PlayerData[playerid][pDonator] >= 2)
    {
        SendClientMessageEx(playerid, COLOR_VIP, "VIP Perk: Your %i minutes of jail time has been reduced by 75 percent to %i minutes.", minutes, percent(minutes, 75));
        minutes = percent(minutes, 25);
    }

    GivePlayerCash(playerid, -fine);

    if (IsPlayerConnected(arrestedby))
    {
        SetPlayerInJail(playerid, JailType_ICPrison, minutes * 60, reason, GetPlayerNameEx(arrestedby));

        new payment = 0;
        switch (PlayerData[playerid][pFactionRank])
        {
            case 0:  { payment = 3000; }
            case 1:  { payment = 3000; }
            case 2:  { payment = 3500; }
            case 3:  { payment = 4000; }
            case 4:  { payment = 4500; }
            default: { payment = 5000; }
        }
        GivePlayerCash(arrestedby, payment);
        GivePlayerRankPoints(arrestedby, 500);

        new factionid = PlayerData[arrestedby][pFaction];

        SendClientMessageToAllEx(COLOR_LIGHTRED, "<< %s %s has completed their arrest. %s has been sent to jail for %i days and fined %s. >>",
            FactionRanks[factionid][PlayerData[arrestedby][pFactionRank]], GetRPName(arrestedby), GetRPName(playerid), minutes, FormatCash(fine));
        DBLog("log_faction", "%s (uid: %i) has arrested %s (uid: %i) for %i minutes, fine: %s.",
            GetPlayerNameEx(arrestedby), PlayerData[arrestedby][pID], GetPlayerNameEx(playerid),
            PlayerData[playerid][pID], minutes, FormatCash(fine));
    }
    else
    {
        SetPlayerInJail(playerid, JailType_ICPrison, minutes * 60, reason, "Law enforcement");
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "* You've been arrested for %i minutes, fine: %s.", minutes, FormatCash(fine));
    SendClientMessageEx(playerid, COLOR_WHITE, "* You can request a lawyer using (/requestlawyer).");
    return 1;
}

CMD:arrest(playerid, params[])
{
    new targetid;

    if (!IsLawEnforcement(playerid)  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /arrest [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't arrest yourself.");
    }
    if (!PlayerData[targetid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not handcuffed.");
    }
    if (!PlayerData[targetid][pWantedLevel])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't arrest a player with no active charges. /charge to add them.");
    }

    for (new i = 0; i < sizeof(arrestPoints); i ++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2]))
        {
            return ArrestPlayer(targetid, "Arrested", playerid);
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any arrest points.");
    return 1;
}

CMD:taser(playerid, params[])
{
    return callcmd::tazer(playerid, params);
}

CMD:tazer(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0 || IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (PlayerData[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command when you are weapon restricted.");
    }
    if (!PlayerData[playerid][pDuty])
    {
        return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You must be on duty before using /tazer.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to pull out your tazer. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
    if (!PlayerData[playerid][pTazer])
    {
        PlayerData[playerid][pTazer] = 1;
        ShowActionBubble(playerid, "* %s reaches for their tazer.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_PURPLE, "* %s reaches for their tazer.", GetRPName(playerid));
        pTazerReplace{playerid} = PlayerData[playerid][pWeapons][2];
        GivePlayerWeaponEx(playerid, 23);
        SetPlayerArmedWeapon(playerid, 23);
    }
    else
    {
        PlayerData[playerid][pTazer] = 0;
        RemovePlayerWeapon(playerid, 23);
        SetPlayerWeapons(playerid);
        GivePlayerWeaponEx(playerid, pTazerReplace{playerid});
        ShowActionBubble(playerid, "* %s puts their tazer back in their duty belt.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_PURPLE, "* %s puts their tazer back in their duty belt.", GetRPName(playerid));
        if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
            SetPlayerArmedWeapon(playerid, PlayerData[playerid][pWeapons][2]);
        }
    }

    return 1;
}

CMD:mir(playerid, params[])
{
    if (IsLawEnforcement(playerid))
    {
        SetTimerEx("showMirandaRights", 1000, false, "ii", playerid, 1);
    }
    return 1;
}

CMD:swat(playerid, params[])
{
    if (!PlayerData[playerid][pLogged])return true;

    new factionid = PlayerData[playerid][pFaction];

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (!IsPlayerInRangeOfLocker(playerid, factionid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any of your faction lockers.");
    }
    if (!PlayerData[playerid][pDuty])
    {
        return SendClientMessage(playerid, COLOR_ADM, "ACCESS DENIED:{FFFFFF} You must be on duty before SWATing up.");
    }

    if (PlayerData[playerid][pSWATduty] == true)
    {
        SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
        SetScriptArmour(playerid, 100);
        GivePlayerHealth(playerid, 100);
        SendFactionMessage(factionid, COLOR_FACTIONCHAT, "* HQ: %s %s is now off tactical duty! *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
        PlayerData[playerid][pSWATduty] = false;
    }
    else
    {
        SetPlayerSkin(playerid, 285);
        SetScriptArmour(playerid, 100);
        GivePlayerHealth(playerid, 100);
        SendFactionMessage(factionid, COLOR_FACTIONCHAT, "* HQ: %s %s is now ready for tactical duty! *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
        PlayerData[playerid][pSWATduty] = true;
    }
    return true;
}
CMD:cuff(playerid, params[])
{
    new targetid;

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /cuff [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (PlayerData[targetid][pJailType] != JailType_None)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't cuff this player when he is in jail.");
    }
    if (PlayerData[targetid][pPaintball])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't cuff this player when he is in paintball.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't cuff yourself.");
    }
    if (PlayerData[targetid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already handcuffed.");
    }
    if (PlayerData[targetid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already tied.");
    }
    if (PlayerData[targetid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't handcuff an injured player.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to cuff anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    new bool:canHandcuff;

    if (PlayerData[targetid][pTazedTime] > 0)
        canHandcuff = true;

    if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_HANDSUP)
        canHandcuff = true;

    if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DUCK)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1441)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1151)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1150)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 960)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1701)
        canHandcuff = true;

    if (!canHandcuff)
        return SendClientMessage(playerid, COLOR_ADM, "That player needs to be crouched, have their hands up or be on the floor.");

    PlayerData[targetid][pCuffed] = 1;
    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
    SetPlayerAttachedObject(targetid, 9, 19418,6,-0.031999,0.024000,-0.024000,-7.900000,-32.000011,-72.299987,1.115998,1.322000,1.406000);

    TogglePlayerControllableEx(targetid, 0);

    ShowActionBubble(playerid, "* %s tightens a pair of handcuffs around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_PURPLE, "* %s tightens a pair of handcuffs around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
    GameTextForPlayer(targetid, "~r~Cuffed", 3000, 3);
    return 1;
}

CMD:uncuff(playerid, params[])
{
    new targetid;

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST && PlayerData[playerid][pAdminDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /uncuff [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid && PlayerData[playerid][pAdminDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't uncuff yourself.");
    }
    if (!PlayerData[targetid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not handcuffed.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to uncuff anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    PlayerData[targetid][pCuffed] = 0;
    PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;

    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
    TogglePlayerControllableEx(targetid, 1);
    RemovePlayerAttachedObject(targetid, 9);
    ShowActionBubble(playerid, "* %s loosens the pair of handcuffs from around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_PURPLE, "* %s loosens the pair of handcuffs from around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
    GameTextForPlayer(targetid, "~g~Uncuffed", 3000, 3);
    return 1;
}

CMD:detain(playerid, params[])
{
    new targetid, vehicleid = GetPlayerVehicleID(playerid);

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /detain [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 15.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't detain yourself.");
    }
    if (!PlayerData[targetid][pCuffed] && !PlayerData[targetid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not handcuffed or tied.");
    }
    if (IsPlayerInAnyVehicle(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already in a vehicle.");
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
    }

    for (new i = (GetVehicleSeats(vehicleid) == 4) ? 2 : 1; i < GetVehicleSeats(vehicleid); i ++)
    {
        if (!IsSeatOccupied(vehicleid, i))
        {
            PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;
            PlayerData[targetid][pVehicleCount] = 0;

            TogglePlayerControllableEx(targetid, 0);
            PutPlayerInVehicle(targetid, vehicleid, i);

            SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
            ShowActionBubble(playerid, "* %s throws %s into their vehicle.", GetRPName(playerid), GetRPName(targetid));
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "There are no unoccupied back seats left. Find another vehicle.");
    return 1;
}

CMD:charge(playerid, params[])
{
    new targetid, reason[128];

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement or government.");
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /charge [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't charge yourself.");
    }
    if (PlayerData[targetid][pWantedLevel] >= 6)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player is already at the maximum wanted level (6).");
    }
    if (GetPlayerFaction(targetid) == FACTION_FEDERAL && GetPlayerFaction(playerid) == FACTION_POLICE && GetPlayerFaction(playerid) == FACTION_ARMY)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is in a faction of higher authority and therefore can't be charged.");
    }

    PlayerData[targetid][pWantedLevel]++;
    PlayerData[targetid][pCrimes]++;

    DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = %i, crimes = %i WHERE uid = %i", PlayerData[targetid][pWantedLevel], PlayerData[targetid][pCrimes], PlayerData[targetid][pID]);

    DBQuery("INSERT INTO charges VALUES(null, %i, '%e', NOW(), '%e')", PlayerData[targetid][pID], GetPlayerNameEx(playerid), reason);
    new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour,minute,second);
    new datum[64], time[64];
    format(time, sizeof(time), "%d:%d:%d", hour, minute, second);
    format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
    DBQuery("INSERT INTO criminals(`player`, `officer`, `date`, `time`, `crime`, `served`) VALUES ('%e','%e','%e','%e','%e', 0)",
        GetPlayerNameEx(targetid), GetPlayerNameEx(playerid), datum, time, reason);

    foreach(new i : Player)
    {
        if (IsLawEnforcement(i))
        {
            SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: %s %s has charged %s with {FF6347}%s{9999FF}. *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), reason);
        }
    }

    SendClientMessageEx(targetid, COLOR_LIGHTRED, "* Officer %s has charged you with %s.", GetRPName(playerid), reason);
    DBLog("log_faction", "%s (uid: %i) has charged %s (uid: %i) with %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason);
    return 1;
}
CMD:su(playerid, params[])
{
    return callcmd::charge(playerid, params);
}

CMD:wanted(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && !PlayerHasJob(playerid, JOB_LAWYER) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement or a lawyer.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Wanted Players _____");

    foreach(new i : Player)
    {
        if (PlayerData[i][pWantedLevel] > 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s - Wanted Level: %i", i, GetRPName(i), PlayerData[i][pWantedLevel]);
        }
    }

    return 1;
}

CMD:find(playerid, params[])
{
    new targetid;

    if (!PlayerHasJob(playerid, JOB_DETECTIVE) && GetPlayerFaction(playerid) != FACTION_POLICE &&  GetPlayerFaction(playerid) != FACTION_FEDERAL && GetPlayerFaction(playerid) != FACTION_ARMY && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Detective.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /find [playerid]");
    }
    if (PlayerData[playerid][pDetectiveCooldown] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds to use this command again.", PlayerData[playerid][pDetectiveCooldown]);
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (PlayerData[targetid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on an on duty administrator.");
    }
    if (PlayerData[targetid][pTogglePhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player's phone is turned off. Therefore you can't find them.");
    }
    if (GetPlayerInterior(targetid) && GetPlayerInterior(targetid) != GetPlayerInterior(playerid))
    {
        //TODO: manage /find when detective is inside interior and the player outside
        new id;
        new entName[32];
        new bool:found = false;
        new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0;
        if ((id = GetInsideHouse(playerid)) >= 0)
        {
            entName = "House";
            x = HouseInfo[id][hPosX];
            y = HouseInfo[id][hPosY];
            z = HouseInfo[id][hPosZ];
            found = true;
        }
        else if ((id = GetInsideBusiness(playerid)) >= 0)
        {
            entName = "Business";
            x = BusinessInfo[id][bPosX];
            y = BusinessInfo[id][bPosY];
            z = BusinessInfo[id][bPosZ];
            found = true;
        }
        else if ((id = GetInsideGarage(playerid)) >= 0)
        {
            entName = "Garage";
            x = GarageInfo[id][gPosX];
            y = GarageInfo[id][gPosY];
            z = GarageInfo[id][gPosZ];
            found = true;
        }
        else if ((id = GetInsideEntrance(playerid)) >= 0)
        {
            entName = "Entrance";
            x = EntranceInfo[id][ePosX];
            y = EntranceInfo[id][ePosY];
            z = EntranceInfo[id][ePosZ];
            found = true;
        }
        else if (GetPlayerInterior(playerid))
        {
            for (new i = 0; i < sizeof(staticEntrances); i ++)
            {
                if (IsPlayerInRangeOfPoint(playerid, 100.0, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ]))
                {
                    strcpy(entName, staticEntrances[i][eName], 32);
                    x = staticEntrances[i][ePosX];
                    y = staticEntrances[i][ePosY];
                    z = staticEntrances[i][ePosZ];
                    found = true;
                    break;
                }
            }
        }
        if (found)
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 5.0);
            SendClientMessageEx(playerid, COLOR_AQUA, "This player is inside {00FF00}%s", entName);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "This player is in an interior. You can't find them at the moment.");
        }
        return 1;
    }

    switch (GetJobLevel(playerid, JOB_DETECTIVE))
    {
        case 1:
        {
            PlayerData[playerid][pFindTime] = 6;
            PlayerData[playerid][pDetectiveCooldown] = 120;
        }
        case 2:
        {
            PlayerData[playerid][pFindTime] = 8;
            PlayerData[playerid][pDetectiveCooldown] = 90;
        }
        case 3:
        {
            PlayerData[playerid][pFindTime] = 10;
            PlayerData[playerid][pDetectiveCooldown] = 60;
        }
        case 4:
        {
            PlayerData[playerid][pFindTime] = 12;
            PlayerData[playerid][pDetectiveCooldown] = 30;
        }
        case 5:
        {
            PlayerData[playerid][pFindTime] = 14;
            PlayerData[playerid][pDetectiveCooldown] = 15;
        }
    }

    SetPlayerMarkerForPlayer(playerid, targetid, 0xF70000FF);

    ShowActionBubble(playerid, "* %s takes out a cellphone and begins to track someone.", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_WHITE, "* %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerData[playerid][pFindTime]);

    IncreaseJobSkill(playerid, JOB_DETECTIVE);
    PlayerData[playerid][pFindPlayer] = targetid;
    return 1;
}
CMD:take(playerid, params[])
{
    new targetid, option[14];

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "us[14]", targetid, option))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /take [playerid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapons, Weed, Cocaine, Heroin, Painkillers, CarLicense");
        return 1;
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (!PlayerData[targetid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not cuffed.");
    }

    if (!strcmp(option, "weapons", true))
    {
        ResetPlayerWeaponsEx(targetid);
        ShowActionBubble(playerid, "* %s takes away %s's weapons.", GetRPName(playerid), GetRPName(targetid));

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your weapons.", GetRPName(playerid));
        DBLog("log_faction", "%s (uid: %i) has taken %s's (uid: %i) weapons.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "weed", true))
    {
        if (!PlayerData[targetid][pWeed])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has no weed on them.");
        }

        ShowActionBubble(playerid, "* %s takes away %s's weed.", GetRPName(playerid), GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i grams of weed.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        DBLog("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of weed.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pWeed]);

        DBQuery("UPDATE "#TABLE_USERS" SET weed = 0 WHERE uid = %i", PlayerData[targetid][pID]);

        PlayerData[targetid][pWeed] = 0;
    }
    else if (!strcmp(option, "cocaine", true))
    {
        if (!PlayerData[targetid][pCocaine])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has no cocaine on them.");
        }

        ShowActionBubble(playerid, "* %s takes away %s's cocaine.", GetRPName(playerid), GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i grams of cocaine.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        DBLog("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of cocaine.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pCocaine]);

        DBQuery("UPDATE "#TABLE_USERS" SET cocaine = 0 WHERE uid = %i", PlayerData[targetid][pID]);

        PlayerData[targetid][pCocaine] = 0;
    }
    else if (!strcmp(option, "heroin", true))
    {
        if (!PlayerData[targetid][pHeroin])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has no Heroin on them.");
        }

        ShowActionBubble(playerid, "* %s takes away %s's Heroin.", GetRPName(playerid), GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i grams of Heroin.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        DBLog("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of Heroin.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pHeroin]);

        DBQuery("UPDATE "#TABLE_USERS" SET heroin = 0 WHERE uid = %i", PlayerData[targetid][pID]);

        PlayerData[targetid][pHeroin] = 0;
    }
    else if (!strcmp(option, "painkillers", true))
    {
        if (!PlayerData[targetid][pPainkillers])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has no painkillers on them.");
        }

        ShowActionBubble(playerid, "* %s takes away %s's painkillers.", GetRPName(playerid), GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i painkillers.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        DBLog("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i painkillers.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pPainkillers]);

        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = 0 WHERE uid = %i", PlayerData[targetid][pID]);

        PlayerData[targetid][pPainkillers] = 0;
    }
    else if (!strcmp(option, "carlicense", true))
    {
        if (!PlayerHasLicense(playerid, PlayerLicense_Car))
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has no driving license on them.");
        }

        RemovePlayerLicense(targetid, PlayerLicense_Car, 60);
        ShowActionBubble(playerid, "* %s takes away %s's drivers license.", GetRPName(playerid), GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your drivers license.", GetRPName(playerid));
        DBLog("log_faction", "%s (uid: %i) has taken %s's (uid: %i) drivers license.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }

    return 1;
}
CMD:ticket(playerid, params[])
{
    new targetid, amount, reason[128];

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "uis[128]", targetid, amount, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ticket [playerid] [amount] [reason]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't ticket yourself.");
    }
    if (!(1000 <= amount <= 10000))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The ticket amount must range between $1000 and $10000.");
    }

    PlayerData[targetid][pTicketOffer] = playerid;
    PlayerData[targetid][pTicketPrice] = amount;
    format(PlayerData[targetid][pTicketReason], 128, reason);
    GivePlayerRankPoints(playerid, 50);

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s writes you a %s ticket for %s. (/accept ticket)", GetRPName(playerid), FormatCash(amount), reason);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered a %s ticket to %s for %s.", FormatCash(amount), GetRPName(targetid), reason);
    return 1;
}

Accept:ticket(playerid)
{
    new offeredby = PlayerData[playerid][pTicketOffer];
    new price = PlayerData[playerid][pTicketPrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a ticket.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to pay this ticket.");
    }
    AddToTaxVault(price);
    GivePlayerCash(playerid, -price);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have paid the %s ticket written by %s.", FormatCash(price), GetRPName(offeredby));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has paid the %s ticket which was written to them.", GetRPName(playerid), FormatCash(price));
    DBLog("log_faction", "%s (uid: %i) has paid %s (uid: %i) a ticket for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], price);
    PlayerData[playerid][pTicketOffer] = INVALID_PLAYER_ID;
    new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour,minute,second);
    new datum[64], timel[64];
    format(timel, sizeof(timel), "%d:%d:%d", hour, minute, second);
    format(datum, sizeof(datum), "%d-%d-%d", year, month, day);

    DBQuery("INSERT INTO "#TABLE_PDTICKET"(player, officer, time, date, amount, reason)"\
            " VALUES ('%e','%e','%e','%e',%d,'%e')",
            GetPlayerNameEx(playerid), GetPlayerNameEx(offeredby),
            timel,datum, price, PlayerData[playerid][pTicketReason]);
    return 1;
}

CMD:ram(playerid, params[])
{
    new id;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }

    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
        {
            //TODO: ram house, land doors
            /*if ((id = GetInsideHouse(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[id][hID])
            {
                DBFormat("SELECT door_opened FROM rp_furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerRamFurnitureDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }
            else if ((id = GetNearbyLand(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[id][lID])
            {
                DBFormat("SELECT door_opened FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerRamLandDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }*/
        }
    }

    if ((id = GetNearbyHouse(playerid)) >= 0)
    {
        if (!HouseInfo[id][hLocked])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This house is unlocked. You don't need to ram the door.");
        }

        HouseInfo[id][hLocked] = 0;

        DBQuery("UPDATE houses SET locked = 0 WHERE id = %i", HouseInfo[id][hID]);

        ShowActionBubble(playerid, "* %s rams down %s's house door.", GetRPName(playerid), HouseInfo[id][hOwner]);
    }
    else if ((id = GetNearbyBusiness(playerid)) >= 0)
    {
        if (!BusinessInfo[id][bLocked])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This business is unlocked. You don't need to ram the door.");
        }

        BusinessInfo[id][bLocked] = 0;

        DBQuery("UPDATE businesses SET locked = 0 WHERE id = %i", BusinessInfo[id][bID]);

        ShowActionBubble(playerid, "* %s rams down %s's business door.", GetRPName(playerid), BusinessInfo[id][bOwner]);
    }
    else if ((id = GetNearbyGarage(playerid)) >= 0)
    {
        if (!GarageInfo[id][gLocked])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This garage is unlocked. You don't need to ram the door.");
        }

        GarageInfo[id][gLocked] = 0;

        DBQuery("UPDATE garages SET locked = 0 WHERE id = %i", GarageInfo[id][gID]);

        ShowActionBubble(playerid, "* %s rams down %s's garage door.", GetRPName(playerid), GarageInfo[id][gOwner]);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not in range of any door which can be rammed.");
    }

    return 1;
}

CMD:clearwanted(playerid, params[])
{
    new targetid;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /clearwanted [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't clear yourself.");
    }
    if (!PlayerData[targetid][pWantedLevel])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has no active charges to clear.");
    }

    PlayerData[targetid][pWantedLevel] = 0;
    GivePlayerRankPoints(playerid, -100);

    DBQuery("DELETE FROM charges WHERE uid = %i", PlayerData[targetid][pID]);

    DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = 0 WHERE uid = %i", PlayerData[targetid][pID]);
    ShowActionBubble(playerid, "* %s calls in dispatch and asks for a warrant removal of %s.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_WHITE, "* Your crimes were cleared by %s.", GetRPName(playerid));
    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has cleared %s's charges and wanted level.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:vticket(playerid, params[])
{
    new amount, vehicleid;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vticket [amount]");
    }
    if ((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleInfo[vehicleid][vOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
    }
    if (!(100 <= amount <= 500))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount must range from $100 to $500.");
    }
    if (VehicleInfo[vehicleid][vTickets] >= 2000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has over $2000 in tickets. You can't add anymore.");
    }

    VehicleInfo[vehicleid][vTickets] += amount;
    GivePlayerRankPoints(playerid, 50);

    DBQuery("UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
    SendClientMessageEx(playerid, COLOR_YELLOW3, "* %s writes up a %s ticket and attaches it to the %s.", GetRPName(playerid), FormatCash(amount), GetVehicleName(vehicleid));

    ShowActionBubble(playerid, "* %s writes up a %s ticket and attaches it to the %s.", GetRPName(playerid), FormatCash(amount), GetVehicleName(vehicleid));
    DBLog("log_faction", "%s (uid: %i) placed a ticket for $%i on %s's (uid: %i) %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
    return 1;
}
CMD:vcheck(playerid, params[])
{
    new vehicleid;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if ((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleInfo[vehicleid][vOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
    }

    if (VehicleInfo[vehicleid][vTickets])
        return SendClientMessageEx(playerid,COLOR_GREY,"** COMPUTER ** The %s(%i) owned by %s have a ticket of value $%i", GetVehicleName(vehicleid),vehicleid, VehicleInfo[vehicleid][vOwner],VehicleInfo[vehicleid][vTickets]);
    else return SendClientMessageEx(playerid,COLOR_GREY,"** COMPUTER ** The %s(%i) owned by %s have no ticket of value", GetVehicleName(vehicleid),vehicleid, VehicleInfo[vehicleid][vOwner]);
}
CMD:siren(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), Float:x, Float:y, Float:z, Float:tmp;

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
    }
    if (!VehicleHasWindows(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle cannot have a siren attached to it.");
    }

    if (!IsValidDynamicObject(vehicleSiren[vehicleid]))
    {
        GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, z, z, z);
        GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, tmp);

        vehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachDynamicObjectToVehicle(vehicleSiren[vehicleid], vehicleid, -x, y, z / 1.9, 0.0, 0.0, 0.0);

        ShowActionBubble(playerid, "* %s places a detachable siren on the roof of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }
    else
    {
        DestroyDynamicObject(vehicleSiren[vehicleid]);
        vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
        ShowActionBubble(playerid, "* %s detaches the siren from the roof of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }

    return 1;
}

CMD:callsign(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
    }
    if (isnull(params) || strlen(params) > 12)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /callsign [text ('none' to reset)]");
    }

    if (IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
    {
        DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
        vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

        if (!strcmp(params, "none", true))
        {
            SendClientMessage(playerid, COLOR_WHITE, "* Callsign removed from the vehicle.");
        }
    }

    if (strcmp(params, "none", true) != 0)
    {
        vehicleCallsign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_GREY2, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
        SendClientMessage(playerid, COLOR_WHITE, "* Callsign attached. '/callsign none' to detach the callsign.");
    }

    return 1;
}

CMD:vfrisk(playerid, params[])
{
    new vehicleid;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if ((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleInfo[vehicleid][vOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
    }

    new count;

    for (new i = 0; i < 5; i ++)
    {
        if (VehicleInfo[vehicleid][vWeapons][i])
        {
            count++;
        }
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Trunk Balance ______");
    SendClientMessageEx(playerid, COLOR_GREY2, "Cash: $%i/$%i", VehicleInfo[vehicleid][vCash], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH));
    SendClientMessageEx(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", VehicleInfo[vehicleid][vMaterials], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS), count, GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS));
    SendClientMessageEx(playerid, COLOR_GREY2, "Weed: %i/%i grams | Cocaine: %i/%i grams", VehicleInfo[vehicleid][vWeed], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED), VehicleInfo[vehicleid][vCocaine], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
    SendClientMessageEx(playerid, COLOR_GREY2, "Heroin: %i/%i grams | Painkillers: %i/%i pills", VehicleInfo[vehicleid][vHeroin], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN), VehicleInfo[vehicleid][vPainkillers], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));

    if (count > 0)
    {
        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Trunk Weapons ______");

        for (new i = 0; i < 5; i ++)
        {
            if (VehicleInfo[vehicleid][vWeapons][i])
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
            }
        }
    }

    ShowActionBubble(playerid, "* %s prys open the trunk of the %s and takes a look inside.", GetRPName(playerid), GetVehicleName(vehicleid));
    return 1;
}

CMD:vtake(playerid, params[])
{
    new vehicleid, option[14];

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (sscanf(params, "s[14]", option))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vtake [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapons, Weed, Cocaine, Heroin, Painkillers");
        return 1;
    }
    if ((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleInfo[vehicleid][vOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
    }

    if (!strcmp(option, "weapons", true))
    {
        VehicleInfo[vehicleid][vWeapons][0] = 0;
        VehicleInfo[vehicleid][vWeapons][1] = 0;
        VehicleInfo[vehicleid][vWeapons][2] = 0;
        VehicleInfo[vehicleid][vWeapons][3] = 0;
        VehicleInfo[vehicleid][vWeapons][4] = 0;

        DBQuery("UPDATE vehicles SET weapon_1 = 0, weapon_2 = 0, weapon_3 = 0, weapon_4 = 0, weapon_5 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);

        ShowActionBubble(playerid, "* %s takes the weapons from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessage(playerid, COLOR_AQUA, "You have taken the weapons from the trunk.");
        DBLog("log_faction", "%s (uid: %i) has taken the weapons from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
    }
    else if (!strcmp(option, "weed", true))
    {
        ShowActionBubble(playerid, "* %s takes the weed from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i grams of weed from the trunk.", VehicleInfo[vehicleid][vWeed]);
        DBLog("log_faction", "%s (uid: %i) has taken the %i grams of weed from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        DBQuery("UPDATE vehicles SET weed = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);

        VehicleInfo[vehicleid][vWeed] = 0;
    }
    else if (!strcmp(option, "cocaine", true))
    {
        ShowActionBubble(playerid, "* %s takes the cocaine from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i grams of cocaine from the trunk.", VehicleInfo[vehicleid][vCocaine]);
        DBLog("log_faction", "%s (uid: %i) has taken the %i grams of cocaine from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        DBQuery("UPDATE vehicles SET cocaine = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);

        VehicleInfo[vehicleid][vCocaine] = 0;
    }
    else if (!strcmp(option, "heroin", true))
    {
        ShowActionBubble(playerid, "* %s takes the Heroin from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i grams of Heroin from the trunk.", VehicleInfo[vehicleid][vHeroin]);
        DBLog("log_faction", "%s (uid: %i) has taken the %i grams of Heroin from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        DBQuery("UPDATE vehicles SET heroin = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);

        VehicleInfo[vehicleid][vHeroin] = 0;
    }
    else if (!strcmp(option, "painkillers", true))
    {
        ShowActionBubble(playerid, "* %s takes the painkillers from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i painkillers from the trunk.", VehicleInfo[vehicleid][vPainkillers]);
        DBLog("log_faction", "%s (uid: %i) has taken the %i painkillers from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        DBQuery("UPDATE vehicles SET painkillers = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);

        VehicleInfo[vehicleid][vPainkillers] = 0;
    }
    else
    {
        return 1;
    }
    GivePlayerRankPoints(playerid, 50);
    return 1;
}

CMD:fingerprint(playerid, params[])
{
    new targetid;

    if (!IsACop(playerid))
    {
        return SendNoPermission(playerid);
    }

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /fingerprint [playerid/partofname]");
    }

    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected.");
    }

    if (GetDistanceBetweenPlayers(targetid, playerid) > 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
    }

    if (PlayerData[targetid][pCrimes] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "IAFIS has found no matches for the scanned fingerprint.");
    }

    // if (PlayerData[targetid][pHouse] != INVALID_HOUSE_ID)
    // {
    //     new
    //         szZone[MAX_ZONE_NAME];
    //
    //     Get2DPosZone(HouseInfo[PlayerData[targetid][pHouse]][hExteriorX], HouseInfo[PlayerData[targetid][pHouse]][hExteriorY], szZone, MAX_ZONE_NAME);
    //     SendClientMessageEx(playerid, COLOR_WHITE, "House: %d %s", PlayerData[targetid][pHouse], szZone);
    // }
    // else if (PlayerData[targetid][pHouse2] != INVALID_HOUSE_ID)
    // {
    //     new
    //         szZone[MAX_ZONE_NAME];
    //
    //     Get2DPosZone(HouseInfo[PlayerData[targetid][pHouse2]][hExteriorX], HouseInfo[PlayerData[targetid][pHouse2]][hExteriorY], szZone, MAX_ZONE_NAME);
    //     SendClientMessageEx(playerid, COLOR_WHITE, "House (2): %d %s", PlayerData[targetid][pHouse2], szZone);
    // }
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------");
    SendClientMessageEx(playerid, COLOR_WHITE, "Name: %s (age: %d, gender: %s)", GetPlayerNameEx(targetid), PlayerData[targetid][pAge], GetPlayerGenderStr(targetid));
    SendClientMessageEx(playerid, COLOR_WHITE, "Job 1: %s, Job 2: %s", GetJobName(PlayerData[targetid][pJob]), GetJobName(PlayerData[targetid][pSecondJob]));
    SendClientMessageEx(playerid, COLOR_WHITE, "Prior convictions: %d", PlayerData[targetid][pCrimes]);
    SendClientMessageEx(playerid, COLOR_WHITE, "Prior arrests: %d", PlayerData[targetid][pArrested]);
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------");

    return 1;
}
