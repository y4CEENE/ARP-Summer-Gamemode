/// @file      Hunter.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-02-14 20:56:40 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define HUNTER_EVENT_ID 101

static Hunters[MAX_PLAYERS];

stock IsHunted(playerid)
{
    return Hunters[playerid] > 0;
}

hook OnPlayerInit(playerid)
{
    Hunters[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    if (Hunters[playerid])
    {
        Hunters[playerid] = 0;
        DeletePVar(playerid, "EventToken");
        SendClientMessageToAllEx(COLOR_LIGHTORANGE, "(( The hunted AIDS victim %s has left the server ))", GetRPName(playerid));
    }
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken == HUNTER_EVENT_ID)
    {
        if (Hunters[playerid])
        {
            if (killerid == INVALID_PLAYER_ID)
            {
                SendClientMessageToAllEx(COLOR_LIGHTORANGE, "(( Our dear friend %s has died of vicious AIDS, may he rest in piece. ))", GetRPName(playerid));
            }
            else
            {
                SendClientMessageToAllEx(COLOR_LIGHTORANGE, "(( Our dear friend %s was slain by %s, may he rest in piece. ))", GetRPName(playerid), GetRPName(killerid));
                SendClientMessageEx(killerid, COLOR_AQUA, "You have slain the hunted %s, you have been flagged for a prize.", GetRPName(playerid));
                DBQuery("INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Allhunt winner')", PlayerData[killerid][pID]);


                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: Server flagged %s's account for 'Allhunt winner'.",  GetRPName(killerid));
            }
        }
        Hunters[playerid] = 0;
        DeletePVar(playerid, "EventToken");
        SetPlayerWeapons(playerid);
        SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
        SetPlayerToSpawn(playerid);
    }
    return 1;
}

CMD:allhunt(playerid, params[])
{
    new targetid, weaponid;
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid, weaponid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /allhunt [targetid] [weapon (0 for wepset)]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid playerid");
    }
    if (!IsPlayerIdle(targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "This player is not in idle state.");
    }
    if (PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
    if (weaponid == 38 && !IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The minigun was disabled due to abuse.");
    }
    SavePlayerVariables(targetid);
    ResetPlayerWeapons(targetid);
    if (weaponid != 0 && (1 <= weaponid <= 46))
    {
        GivePlayerWeaponEx(weaponid, weaponid, true);
    }
    else
    {
        GivePlayerWeaponEx(targetid, 24, true);
        GivePlayerWeaponEx(targetid, 27, true);
        GivePlayerWeaponEx(targetid, 29, true);
        GivePlayerWeaponEx(targetid, 31, true);
        GivePlayerWeaponEx(targetid, 34, true);
    }
    SetPVarInt(targetid, "EventToken", HUNTER_EVENT_ID);
    Hunters[targetid] = 1;

    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged] && GetPlayerInterior(i) == GetPlayerInterior(targetid))
        {
            SetPlayerMarkerForPlayer(i, targetid, COLOR_RETIRED);
        }
    }
    SendClientMessageToAllEx(COLOR_LIGHTRED, "[Hunt time] %s has made %s a hunted. Kill them to win a prize!", GetRPName(playerid), GetRPName(targetid));
    return 1;
}
