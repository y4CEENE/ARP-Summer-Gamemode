/// @file      Anti-SpeedHack.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-04-01
/// @copyright Copyright (c) 2021

// Based on: Anti speed cheats by Rogue 2018/3/26

#include <YSI\y_hooks>

#define ASH_MAX_FOOT_SPEED  62
#define ASH_MAX_CAR_SPEED   162
#define ASH_MAX_PLANE_SPEED 190
#define ASH_MAX_SPEED_WARNS 2

enum eSpeedHack
{
	SH_LastWarn,
	SH_IsFalling,
	SH_Warns,
	SH_PosZ,
	SH_ResetTimer
};
static SpeedHack[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
	KillTimer(SpeedHack[playerid][SH_ResetTimer]);
	SpeedHack[playerid][SH_LastWarn]  = 0;
	SpeedHack[playerid][SH_IsFalling] = 0;
	SpeedHack[playerid][SH_Warns]     = 0;
	SpeedHack[playerid][SH_PosZ]	  = 0.0;
}

hook OnPlayerHeatBeat(playerid)
{
    if (!IsAntiCheatEnabled() ||
        PlayerData[playerid][pKicked] ||
        IsPlayerInTutorial(playerid) ||
        IsAdminOnDuty(playerid, false) ||
        gettime() - SpeedHack[playerid][SH_LastWarn] < 2)
    {
        return 1;
    }

	new Float:AscX, Float:AscY, Float:AscZ;
	GetPlayerPos(playerid, AscX, AscY, AscZ);
	if(AscZ < 0.0 || SpeedHack[playerid][SH_PosZ] < 0.0 )
	{
		return 1;
	}
	else if(SpeedHack[playerid][SH_IsFalling] == 0 && SpeedHack[playerid][SH_PosZ] - AscZ > 3)
	{
		SpeedHack[playerid][SH_IsFalling] = 1;
	}
	else if(SpeedHack[playerid][SH_IsFalling] == 1 && SpeedHack[playerid][SH_PosZ] - AscZ < 3)
	{
		SpeedHack[playerid][SH_IsFalling] = 2;
		SetTimerEx("ResetFallTeleport", 3000, false, "i", playerid);
	}

	if(SpeedHack[playerid][SH_IsFalling] == 0)
	{
        new speed = GetPlayerSpeed(playerid);
		switch(GetPlayerState(playerid))
		{
			case PLAYER_STATE_ONFOOT:
			{
				if(speed > ASH_MAX_FOOT_SPEED && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID)
				{
					GivePlayerSpeedHackWarn(playerid, speed, ASH_MAX_FOOT_SPEED);
				}
			}
			case PLAYER_STATE_DRIVER:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				new limit = (IsAPlane(vehicleid) || IsAnHelicopter(vehicleid)) ? ASH_MAX_PLANE_SPEED : ASH_MAX_CAR_SPEED;
				if (speed > limit)
				{
					GivePlayerSpeedHackWarn(playerid, speed, limit);
				}
			}
		}
	}
	SpeedHack[playerid][SH_PosZ] = AscZ;
	return 1;
}

hook OnNewMinute(timestamp)
{
	foreach (new playerid : player)
	{
		SpeedHack[playerid][SH_Warns] = 0;
	}
}

static GivePlayerSpeedHackWarn(playerid, Float:speed, limit)
{
	SpeedHack[playerid][SH_LastWarn] = gettime();
	SpeedHack[playerid][SH_Warns]++;
	if(SpeedHack[playerid][SH_Warns] >= ASH_MAX_SPEED_WARNS)
	{
		SpeedHack[playerid][SH_Warns] = 0;
		new reason[64];
        new Float:speed = GetPlayerSpeed(playerid);
		new vehicleid = GetPlayerVehicleID(vehicleid);
		if (vehicleid)
			format(reason, sizeof(reason), "Speed hack using %s, speed: %.1f km/h", GetVehicleName(vehicleid));
		else
			format(reason, sizeof(reason), "Speed hack on foot, speed: %.1f km/h", speed);

        new username[32];
        GetPlayerName(playerid, username, sizeof(username));
        Log("logs/Rex/Anti-SpeedHack.log", "%s (uid: %i) possibly %s", username, PlayerData[playerid][pID], reason, limit);
        DBLog("log_cheat", "%s (uid: %i) possibly %s, limit: %i km/h", username, PlayerData[playerid][pID], reason, limit);
		KickPlayer(playerid, reason, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
	}
}

publish ResetFallTeleport(playerid)
{
    return SpeedHack[playerid][SH_IsFalling] = 0;
}
