/// @file      DuelEvent.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define DUEL_EVENT_TOKEN 716

stock DuelOffer[MAX_PLAYERS];
stock Dueling[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    DuelOffer[playerid] = INVALID_PLAYER_ID;
    Dueling[playerid] = INVALID_PLAYER_ID;
}

hook OnPlayerReset(playerid)
{
    if (IsDueling(playerid))
    {
        EndDuel(playerid);
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (GetPVarInt(playerid, "EventToken") != DUEL_EVENT_TOKEN)
    {
        return 1;
    }
    DeletePVar(playerid, "EventToken");

    foreach(new i : Player)
    {
        if (DuelOffer[i] == playerid)
        {
            DuelOffer[i] = INVALID_PLAYER_ID;
        }
        if (Dueling[i] == playerid)
        {
            SendClientMessage(i, COLOR_WHITE, "Your duel target has left the server.");
            Dueling[i] = INVALID_PLAYER_ID;
            DeletePVar(i, "EventToken");
            SetPlayerToSpawn(i);
        }
    }
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken != DUEL_EVENT_TOKEN || !IsDueling(playerid))
    {
        return 1;
    }
    new entranceid = GetInsideEntrance(playerid);

    SendClientMessageEx(playerid, COLOR_LIGHTORANGE, "(( You lost your duel against %s! ))", GetRPName(Dueling[playerid]));

    if (killerid != INVALID_PLAYER_ID)
    {
        SendClientMessageEx(killerid, COLOR_LIGHTORANGE, "(( You won the duel against %s! ))", GetRPName(playerid));

        if (entranceid >= 0 && EntranceInfo[entranceid][eType] == 1)
        {
            foreach(new i : Player)
            {
                if (GetInsideEntrance(i) == entranceid)
                {
                    SendClientMessageEx(i, COLOR_YELLOW, "Duel Arena: %s has won their duel against %s.", GetRPName(killerid), GetRPName(playerid));
                }
            }
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has won their duel against %s.", GetRPName(killerid), GetRPName(playerid));
        }

        SetPlayerWeapons(killerid);
        SetPlayerToSpawn(killerid);
    }
    return 1;
}

IsDueling(playerid)
{
    return Dueling[playerid] != INVALID_PLAYER_ID;
}

EndDuel(playerid)
{
    Dueling[Dueling[playerid]] = INVALID_PLAYER_ID;
    DeletePVar(Dueling[playerid], "EventToken");
    Dueling[playerid] = INVALID_PLAYER_ID;
    DeletePVar(playerid, "EventToken");
}

ForcePlayersInDuel(player1, player2, Float:health, Float:armor, weapon1, weapon2 = 0, weapon3 = 0, weapon4 = 0, weapon5 = 0, entranceid = -1)
{
    DuelOffer[player1] = INVALID_PLAYER_ID;
    DuelOffer[player2] = INVALID_PLAYER_ID;

    SavePlayerVariables(player1);
    SavePlayerVariables(player2);

    ResetPlayerWeapons(player1);
    ResetPlayerWeapons(player2);

    SetPlayerPos(player1, 1370.3395, -15.4556, 1000.9219);
    SetPlayerPos(player2, 1414.4841, -15.1239, 1000.9253);
    SetPlayerFacingAngle(player1, 270.0000);
    SetPlayerFacingAngle(player2, 90.0000);

    SetPlayerInterior(player1, 1);
    SetPlayerInterior(player2, 1);
    if (entranceid == -1)
    {
        SetPlayerVirtualWorld(player1, 0);
        SetPlayerVirtualWorld(player2, 0);
    }
    else
    {
        SetPlayerVirtualWorld(player1, EntranceInfo[entranceid][eWorld]);
        SetPlayerVirtualWorld(player2, EntranceInfo[entranceid][eWorld]);
    }

    SetPlayerHealth(player1, health);
    SetPlayerArmour(player1, armor);
    SetPlayerHealth(player2, health);
    SetPlayerArmour(player2, armor);

    if (weapon1 != 0)
    {
        GivePlayerWeaponEx(player1, weapon1, true);
        GivePlayerWeaponEx(player2, weapon1, true);
    }
    if (weapon2 != 0)
    {
        GivePlayerWeaponEx(player1, weapon2, true);
        GivePlayerWeaponEx(player2, weapon2, true);
    }
    if (weapon3 != 0)
    {
        GivePlayerWeaponEx(player1, weapon3, true);
        GivePlayerWeaponEx(player2, weapon3, true);
    }
    if (weapon4 != 0)
    {
        GivePlayerWeaponEx(player1, weapon4, true);
        GivePlayerWeaponEx(player2, weapon4, true);
    }
    if (weapon5 != 0)
    {
        GivePlayerWeaponEx(player1, weapon5, true);
        GivePlayerWeaponEx(player2, weapon5, true);
    }

    GameTextForPlayer(player1, "~r~Duel time!", 3000, 3);
    GameTextForPlayer(player2, "~r~Duel time!", 3000, 3);

    Dueling[player1] = player2;
    Dueling[player2] = player1;
    SetPVarInt(player1, "EventToken", DUEL_EVENT_TOKEN);
    SetPVarInt(player2, "EventToken", DUEL_EVENT_TOKEN);
}

CMD:offerduel(playerid, params[])
{
    new entranceid = GetInsideEntrance(playerid), targetid;

    if (entranceid == -1 || EntranceInfo[entranceid][eType] != 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of a duel arena.");
    }
    if (EntranceInfo[entranceid][eAdminLevel] && !IsAdmin(playerid, EntranceInfo[entranceid][eAdminLevel]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your administrator level is too low to initiate duels here.");
    }
    if (EntranceInfo[entranceid][eFaction] >= 0 && PlayerData[playerid][pFaction] != EntranceInfo[entranceid][eFaction])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific faction type.");
    }
    if (EntranceInfo[entranceid][eGang] >= 0 && EntranceInfo[entranceid][eGang] != PlayerData[playerid][pGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific gang type.");
    }
    if (EntranceInfo[entranceid][eVIP] && PlayerData[playerid][pDonator] < EntranceInfo[entranceid][eVIP])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a higher VIP level.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /offerduel [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 15.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't offer to duel with yourself.");
    }
    if (Dueling[targetid] != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already in a duel.");
    }

    DuelOffer[targetid] = playerid;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has offered you to duel with them. (/accept duel)", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a duel offer.", GetRPName(targetid));
    return 1;
}

CMD:duel(playerid, params[])
{
    new target1, target2, Float:health, Float:armor, weapon1, weapon2;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uuffii", target1, target2, health, armor, weapon1, weapon2))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /duel [player1] [player2] [health] [armor] [weapon1] [weapon2]");
    }
    if (target1 == INVALID_PLAYER_ID || target2 == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player specified.");
    }
    if (health < 1.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Health can't be under 1.0.");
    }
    if (!(0 <= weapon1 <= 46) || !(0 <= weapon2 <= 46))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon. Valid weapon IDs range from 0 to 46.");
    }
    ForcePlayersInDuel(target1, target2, health, armor, weapon1, weapon2);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s and %s into a duel.", GetRPName(playerid), GetRPName(target1), GetRPName(target2));
    return 1;
}

Accept:duel(playerid)
{
    new offeredby = DuelOffer[playerid], entranceid = GetInsideEntrance(playerid);

    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers to duel.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 15.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (entranceid == -1 || EntranceInfo[entranceid][eType] != 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a duel arena.");
    }
    if (Dueling[playerid] != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already participating in a duel at the moment.");
    }
    if (Dueling[offeredby] != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is in a duel at the moment.");
    }

    foreach(new i : Player)
    {
        if (GetInsideEntrance(i) == entranceid && Dueling[i] != INVALID_PLAYER_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There is a duel in progress already. Wait until the current one has ended.");
        }
    }
    ForcePlayersInDuel(playerid, offeredby, 100.0, 100.0, 24, 27, 29, 31, 34, entranceid);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted the duel offer.", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's duel offer.", GetRPName(offeredby));
    return 1;
}
