/// @file      BreakCuffs.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static bool:IsBreakingCuffs[MAX_PLAYERS];
static BreakingCuffsTarget[MAX_PLAYERS];
static BreakingCuffsTimer[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    IsBreakingCuffs[playerid]     = false;
    BreakingCuffsTimer[playerid]  = -1;
    BreakingCuffsTarget[playerid] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(BreakingCuffsTimer[playerid]);
}

hook OnPlayerHeartBeat(playerid)
{
    if (IsBreakingCuffs[playerid])
    {
        if (!IsPlayerConnected(BreakingCuffsTarget[playerid]) || !IsPlayerNearPlayer(playerid, BreakingCuffsTarget[playerid], 6.0))
        {
            KillTimer(BreakingCuffsTimer[playerid]);
            IsBreakingCuffs[playerid]     = false;
            BreakingCuffsTimer[playerid]  = -1;
            BreakingCuffsTarget[playerid] = INVALID_PLAYER_ID;
            SendClientMessageEx(playerid, COLOR_GREEN, "You have failed to pick the cuffs.");
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has failed to pick the cuffs.", GetRPName(playerid));
        }
    }
}

CMD:breakcuffs(playerid, params[])
{
    return callcmd::picklockcuffs(playerid, params);
}

CMD:picklockcuffs(playerid, params[])
{
    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /picklockcuffs [playerid/name]");
    }

    if (PlayerData[playerid][pCrowbar] == 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a crowbar.");
    }

    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 6.0) || targetid == playerid)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The specified player is disconnected or not near you.");
    }

    if (!PlayerData[targetid][pCuffed])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The specified player is not cuffed.");
    }

    KillTimer(BreakingCuffsTimer[playerid]);
    BreakingCuffsTimer[playerid]  = SetTimerEx("BreakCuffs", 3000, false, "d", playerid);
    BreakingCuffsTarget[playerid] = targetid;
    IsBreakingCuffs[playerid]     = true;
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s attempts to pick the cuffs with a crowbar.", GetRPName(playerid));
    return 1;
}

publish BreakCuffs(playerid)
{
    new targetid = BreakingCuffsTarget[playerid];

    IsBreakingCuffs[playerid]     = false;
    BreakingCuffsTimer[playerid]  = -1;
    BreakingCuffsTarget[playerid] = INVALID_PLAYER_ID;

    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 6.0))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The specified player is disconnected or not near you.");
    }

    if (random(2))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "You have failed to pick the cuffs.");
        return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has failed to pick the cuffs.", GetRPName(playerid));
    }

    PlayerData[targetid][pCuffed] = 0;
    PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;

    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
    TogglePlayerControllableEx(targetid, 1);
    RemovePlayerAttachedObject(targetid, 9);
    SendClientMessage(playerid, COLOR_GREEN, "You have picked the cuffs.");
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has picked the cuffs from %s's wrists.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}
