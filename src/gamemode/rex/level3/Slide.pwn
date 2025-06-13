/// @file      Anti-Slide.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-11
/// @copyright Copyright (c) 2023

// Based on: Anti fake kill by Rogue 2018/3/25

#include <YSI\y_hooks>

static LastMouseAiming[MAX_PLAYERS];

hook OnPlayerHeartBeat(playerid)
{
    new playerWeapon = GetPlayerWeapon(playerid);
    new Float:playerSpeed = GetPlayerSpeed(playerid);

    if (playerSpeed > 15.0 && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID &&
        IsPlayerAiming(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT &&
        JustMouseAiming(playerid) && (22 <= playerWeapon <= 38) )
    {
        KickPlayer(playerid, "Player Slide");
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if( (newkeys & 128) && ( newkeys & 8)  && (newkeys & 2))
    {
        LastMouseAiming[playerid] = gettime();
    }
}

hook OnPlayerInit(playerid)
{
    LastMouseAiming[playerid] = 0;
}

static JustMouseAiming(playerid, lastSeconds = 2)
{
    return gettime() - LastMouseAiming[playerid] < lastSeconds;
}
