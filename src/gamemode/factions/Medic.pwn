/// @file      Medic.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

hook OnPlayerInit(playerid)
{
    PlayerData[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (PlayerData[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
    {
        SendClientMessageEx(PlayerData[playerid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has left the server while injured.", GetRPName(playerid));
        PlayerData[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pAcceptedEMS] == playerid)
        {
            SendClientMessage(i, COLOR_YELLOW, "Your medic has left the server while rescuing you. (you can now accept your fate)");
            PlayerData[i][pAcceptedEMS] = INVALID_PLAYER_ID;
        }
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return 1;
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pAcceptedEMS] == playerid)
        {
            PlayerData[i][pAcceptedEMS] = INVALID_PLAYER_ID;
            SendClientMessage(i, COLOR_YELLOW, "Your medic got injured. (you can now accept your fate)");

            foreach(new j : Player)
            {
                if (GetPlayerFaction(j) == FACTION_MEDIC)
                {
                    SendClientMessageEx(j, 0xEC004DFF, "Dispatch: {FFFFFF}Beacon (%i) %s [%i hp] is in need of immediate medical assistance.",
                                        playerid, GetRPName(playerid), GetPlayerHealthEx(playerid));
                }
            }
        }
    }
    return 1;
}

DB:OnPlayerListInjuries(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "That player doesn't have any injuries.");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ %s's Injuries ______", GetRPName(targetid));

        for (new i = 0; i < rows; i ++)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "[%i seconds ago] %s was shot with a %s", gettime() - GetDBIntFieldFromIndex(i, 1), GetRPName(targetid), GetWeaponNameEx(GetDBIntFieldFromIndex(i, 0)));
        }
    }
}

publish InjuredTimer()
{
    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged] && PlayerData[i][pInjured] && GetVehicleModel(GetPlayerVehicleID(i)) != 416)
        {
            new
                Float:health;
            GetPlayerHealth(i, health);
            SetPlayerHealth(i, health - 1.0);
        }
    }
}

CMD:heal(playerid, params[])
{
    new targetid, price;

    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
    }
    if (sscanf(params, "ud", targetid, price))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /heal [playerid] [price]");
    }
    if (price < 100 || price > 300)
    {
        SendClientMessage(playerid, COLOR_GREY, "Healing price can't below $100 or above $300.");
        return 1;
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't heal yourself.");
    }
    if (PlayerData[targetid][pReceivingAid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player already has first aid effects.");
    }
    if (GetPlayerHealthEx(targetid) >= 100)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player doesn't need first aid.");
    }
    if (PlayerData[targetid][pInjured] && GetPlayerHealthEx(targetid) < 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That's an urgent case we must take him to the hospital.");
    }

    PlayerData[targetid][pReceivingAid] = 1;
    GivePlayerCash(targetid, -price);
    GivePlayerCash(playerid, price);
    GivePlayerRankPoints(playerid, 100);

    ShowActionBubble(playerid, "* %s administers first aid to %s.", GetRPName(playerid), GetRPName(targetid));

    SendClientMessageEx(targetid, COLOR_AQUA, "You have received first aid from %s for $%d. Your health will now regenerate until full.", GetRPName(playerid), price);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have administered first aid to %s for $%d.", GetRPName(targetid), price);
    return 1;
}

CMD:stretcher(playerid, params[])
{
    new targetid, vehicleid = GetPlayerVehicleID(playerid);

    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stretcher [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 15.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (!PlayerData[targetid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not injured.");
    }
    if (IsPlayerInAnyVehicle(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already in a vehicle.");
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER && (VehicleInfo[vehicleid][vFaction] > -1 && FactionInfo[VehicleInfo[vehicleid][vFaction]][fType] != FACTION_MEDIC))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be driving an ambulance.");
    }

    for (new seat = 2; seat < GetVehicleSeats(vehicleid); seat ++)
    {
        if (!IsSeatOccupied(vehicleid, seat))
        {
            PlayerData[targetid][pVehicleCount] = 0;

            ClearAnimations(targetid);
            TogglePlayerControllableEx(targetid, false);
            PutPlayerInVehicle(targetid, vehicleid, seat);
            SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* You were loaded by paramedic %s.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You loaded patient %s.", GetRPName(targetid));
            ShowActionBubble(playerid, "* %s places %s on a stretcher in the Ambulance.", GetRPName(playerid), GetRPName(targetid));
            return 1;
        }
    }

    if (!IsSeatOccupied(vehicleid, 1))
    {
        PlayerData[targetid][pVehicleCount] = 0;

        ClearAnimations(targetid);
        TogglePlayerControllableEx(targetid, false);
        PutPlayerInVehicle(targetid, vehicleid, 1);
        SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* You were loaded by paramedic %s.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You loaded patient %s.", GetRPName(targetid));
        ShowActionBubble(playerid, "* %s places %s on a stretcher in the Ambulance.", GetRPName(playerid), GetRPName(targetid));
        return 1;
    }

    SendClientMessage(playerid, COLOR_GREY, "There are no unoccupied seats left. Find another vehicle.");
    return 1;
}

CMD:deliverpatient(playerid, params[])
{
    new targetid, amount;

    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deliverpatient [playerid]");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 2007.6256, -1410.2455, 16.9922) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1140.5344, -1326.5345, 13.6328) && !IsPlayerInRangeOfPoint(playerid, 5.0, 2070.4307, -1422.8580, 48.331) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1161.8879, -1358.6638, 31.3811)
    && !IsPlayerInRangeOfPoint(playerid, 5.0, 1510.7773, -2151.7322, 13.7483) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1480.4819, -2166.9712, 35.2578) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1539.1060, -2167.2058, 35.2578)
    && !IsPlayerInRangeOfPoint(playerid, 5.0, -2684.1162, 626.1478, 14.0291) && !IsPlayerInRangeOfPoint(playerid, 5.0, -2664.0845,638.4924,66.0938))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any delivery points at the hospital.");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 7.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (!PlayerData[targetid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not injured.");
    }
    switch (PlayerData[playerid][pFactionRank])
    {
        case 0:  { amount = 3000; }
        case 1:  { amount = 3000; }
        case 2:  { amount = 3500; }
        case 3:  { amount = 4000; }
        case 4:  { amount = 4500; }
        default: { amount = 5000; }
    }
    if (PlayerData[playerid][pLaborUpgrade] > 0)
    {
        amount += percent(amount, PlayerData[playerid][pLaborUpgrade]);
    }

    PlayerData[targetid][pInjured] = 0;
    PlayerData[targetid][pDelivered] = 0;
    PlayerData[playerid][pTotalPatients]++;

    if (IsPlayerInRangeOfPoint(playerid, 5.0, 2007.6256, -1410.2455, 16.9922) || IsPlayerInRangeOfPoint(playerid, 5.0, 2070.4307,-1422.8580,48.331))
    {
        SetPlayerVirtualWorld(targetid, HOSPITAL_COUNTY);
    }
    else if (IsPlayerInRangeOfPoint(playerid, 5.0, 1147.3577, -1345.3729, 13.6328) || IsPlayerInRangeOfPoint(playerid, 5.0, 1161.1458,-1364.4767,26.6485))
    {
        SetPlayerVirtualWorld(targetid, HOSPITAL_ALLSAINTS);
    }
    else if (IsPlayerInRangeOfPoint(playerid, 5.0, -2684.1162, 626.1478, 14.0291) || IsPlayerInRangeOfPoint(playerid, 5.0, -2664.0845,638.4924,66.0938))
    {
        SetPlayerVirtualWorld(targetid, HOSPITAL_SAN_FIERRO);
    }
    else if (IsPlayerInRangeOfPoint(playerid, 5.0, 1510.7773,-2151.7322,13.7483) || IsPlayerInRangeOfPoint(playerid, 5.0, 1480.4819,-2166.9712,35.2578) || IsPlayerInRangeOfPoint(playerid, 5.0,  1539.1060,-2167.2058,35.2578))
    {
        SetPlayerVirtualWorld(targetid, HOSPITAL_FMDHQ);
    }
    else
    {
        SetPlayerVirtualWorld(targetid, HOSPITAL_ALLSAINTS);
    }

    if (GetPlayerFaction(targetid) == FACTION_POLICE || GetPlayerFaction(targetid) == FACTION_MEDIC)
    {
        SendClientMessage(targetid, COLOR_DOCTOR, "You have not been billed for your stay. You also keep all of your weapons!");
    }
    else
    {
        SendClientMessage(targetid, COLOR_DOCTOR, "You have been billed $250 for your stay. You also keep all of your weapons!");
    }

    SetFreezePos(targetid, -2297.6084,111.1512,-5.3336);//hospitalspawn
    SetPlayerFacingAngle(targetid, 89.7591);
    SetPlayerInterior(targetid, 1);
    SetCameraBehindPlayer(targetid);
    ClearAnimations(targetid, 1);

    if (!(GetPlayerFaction(targetid) == FACTION_POLICE || GetPlayerFaction(targetid) == FACTION_MEDIC) || PlayerData[playerid][pHours] > 8)
    {
        GivePlayerCash(targetid, -250);
        GameTextForPlayer(targetid, "~w~Discharged~n~~r~-$250", 5000, 1);
    }

    SetPlayerDrunkLevel(targetid, 0);

    SetPlayerHealth(targetid, PlayerData[targetid][pSpawnHealth]);
    SetScriptArmour(targetid, PlayerData[targetid][pSpawnArmor]);
    PlayerData[targetid][pAcceptedEMS] = INVALID_PLAYER_ID;
    GivePlayerCash(playerid, amount);
    GivePlayerRankPoints(playerid, 500);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have delivered %s to the hospital and earned {00AA00}$%i{33CCFF}.", GetRPName(targetid), amount);
    return 1;
}

CMD:listpt(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
        return 1;
    }
    SendClientMessage(playerid, COLOR_GREEN, "Injured - (/injuries):");
    new Float:pos[3];
    GetPlayerPosEx(playerid, pos[0], pos[1], pos[2]);

    foreach(new i : Player)
    {
        if (PlayerData[i][pInjured])
        {
            new accepted[24];
            if (IsPlayerConnected(PlayerData[i][pAcceptedEMS]))
            {
                accepted = GetRPName(PlayerData[i][pAcceptedEMS]);
            }
            else
            {
                accepted = "None";
            }
            new Float: distance = GetPlayerDistanceFromPoint(i, pos[0], pos[1], pos[2]);
            SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Location: %s - Medic: %s - Distance: %.2fm", GetRPName(i), GetPlayerZoneName(i), accepted, distance);
        }
    }
    SendClientMessage(playerid, COLOR_AQUA, "Use /getpt [playerid] to track them!");
    return 1;
}

CMD:getpt(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be a Medic to use this command.");
    }

    new targetid;
    if (sscanf(params, "u", targetid) || !IsPlayerConnected(targetid) || targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /getpt [playerid]");
    }

    if (!PlayerData[targetid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That person is not injured!");
    }

    if (IsPlayerConnected(PlayerData[targetid][pAcceptedEMS]))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Someone has already accepted that call!");
    }

    if (PlayerData[targetid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on jailed players.");
    }

    PlayerData[targetid][pAcceptedEMS] = playerid;
    new Float:ppos[3];
    GetPlayerPosEx(targetid, ppos[0], ppos[1], ppos[2]);
    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, ppos[0],ppos[1],ppos[2], 3.0);
    GameTextForPlayer(playerid, "~w~EMS Caller~n~~r~Go to the red marker.", 5000, 1);
    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_DOCTOR, "EMS Driver %s has accepted the Emergency Dispatch call for %s.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted EMS Call from %s, you will see the marker until you have reached it.", GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_AQUA, "* EMS Driver %s has accepted your EMS Call; please be patient as they are on the way!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:loadpt(playerid, params[])
{
    return callcmd::stretcher(playerid, params);
}
CMD:deliverpt(playerid, params[])
{
    return callcmd::deliverpatient(playerid, params);
}
CMD:movept(playerid, params[])
{
    return callcmd::drag(playerid, params);
}
CMD:injuries(playerid, params[])
{
    new targetid;

    if (GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /injuries [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }

    DBFormat("SELECT weaponid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
    DBExecute("OnPlayerListInjuries", "ii", playerid, targetid);

    return 1;
}
