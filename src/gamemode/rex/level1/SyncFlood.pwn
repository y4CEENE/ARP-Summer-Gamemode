/// @file      SyncFlood.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-09-06
/// @copyright Copyright (c) 2023

#include <YSI\y_hooks>

// https://en.wikipedia.org/wiki/SYN_flood

static CheckPingTimer[MAX_PLAYERS];

publish CheckPingBeforeLogin(playerid)
{
    if (!PlayerData[playerid][pLogged])
    {
        new ping = GetPlayerPing(playerid);
        if (ping <= 0 || ping > 1000)
        {
            Kick(playerid); // Don't send kick reason as the client doesn't respond
        }
        else
        {
            CheckPingTimer[playerid] = SetTimerEx("CheckPingBeforeLogin", 1000, false, "i", playerid);
        }
    }
}

hook OnPlayerConnect(playerid)
{
    CheckPingTimer[playerid] = SetTimerEx("CheckPingBeforeLogin", 1000, false, "i", playerid);
}

hook OnPlayerDisconnect(playerid)
{
    KillTimer(CheckPingTimer[playerid]);
}
