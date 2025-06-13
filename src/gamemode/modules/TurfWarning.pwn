/// @file      TurfWarning.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-06-05 18:27:04 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerInTurf[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    PlayerInTurf[playerid] = -1;
    return 1;
}

hook OnServerHeartBeat(timestamp)
{
    foreach (new turfid : Turf)
    {
        if (IsValidTurfId(turfid) && IsActiveTurf(turfid))
        {
            foreach (new playerid: Player)
            {
                if (IsPlayerInTurf(playerid, turfid))
                {
                    if (PlayerInTurf[playerid] != turfid)
                    {
                        if (PlayerData[playerid][pVIPColor])
                        {
                            PlayerData[playerid][pVIPColor] = 0;
                            SendClientMessage(playerid, COLOR_AQUA, "Your VIP nametag color was disabled automatically as you entered a turf in an active war.");
                        }
                        // You entered active turf!!
                        if (PlayerData[playerid][pGang] >= 0 && !PlayerData[playerid][pBandana])
                        {
                            SetPlayerBandana(playerid, true);
                            SendClientMessage(playerid, COLOR_WHITE, "Your bandana was enabled automatically as you entered a turf in an active war.");
                        }
                        ShowNotification(playerid, "Danger: you entered an active gang war!", NotificationType_Danger, "ld_dual:ex3");
                        PlayerInTurf[playerid] = turfid;
                    }
                }
                else if (PlayerInTurf[playerid] == turfid)
                {
                    PlayerInTurf[playerid] = -1;
                }
            }
        }
    }
    return 1;
}
