#include <YSI\y_hooks>

static SpectateTargetID[MAX_PLAYERS];
static SpectateType[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
	SpectateTargetID[playerid] = INVALID_PLAYER_ID;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    foreach(new targetid: Player)
    {
        if(SpectateTargetID[targetid] == playerid)
        {
            SendClientMessageEx(targetid, COLOR_ORANGE, "You are no longer spectating %s[%i] (Player left the game).", GetRPName(playerid), playerid);
            SpectateTargetID[targetid] = INVALID_PLAYER_ID;
            SetPlayerToSpawn(targetid);
        }
    }
    return 1;
}

hook OnTwoPlayersHeartBeat(playerid, targetid)
{
    if(SpectateTargetID[playerid] == targetid)
    {
        if(GetPlayerInterior(playerid) != GetPlayerInterior(targetid))
        {
            SetPlayerInterior(playerid, GetPlayerInterior(targetid));
        }

		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(targetid))
        {
            SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
        }

        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
        {
            TogglePlayerSpectating(playerid, 1);
        }

        if(SpectateType[playerid] == 0 && IsPlayerInAnyVehicle(targetid))
        {
            SpectateType[playerid] = 1;
	        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
        }
        else if(SpectateType[playerid] == 1 && !IsPlayerInAnyVehicle(targetid))
        {
            SpectateType[playerid] = 0;
	        PlayerSpectatePlayer(playerid, targetid);
        }

    }
    return 1;
}

CMD:spec(playerid, params[])
{
    return callcmd::spectate(playerid, params);
}

CMD:spectate(playerid, params[])
{
    new targetid;

	if(!IsAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!strcmp(params, "off", true) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    SendClientMessageEx(playerid, COLOR_ORANGE, "You are no longer spectating %s (ID %i).", GetRPName(SpectateTargetID[playerid]), SpectateTargetID[playerid]);
	    SpectateTargetID[playerid] = INVALID_PLAYER_ID;
	    SetPlayerToSpawn(playerid);
    	if(IsAdminOnDuty(playerid, false))
		{
		    PlayerData[playerid][pTogglePhone] = 0;
		}
	    return 1;
 	}

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /spec [playerid/off]");
	}

	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't spectate yourself.");
	}

    if(IsGodAdmin(targetid) && !IsGodAdmin(playerid))
    {
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot spectate on this admin.");
    }

	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
	}
	if(IsAdminOnDuty(playerid, false))
	{
	    PlayerData[playerid][pTogglePhone] = 1;
	}

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
	    SavePlayerVariables(playerid);
    }
	TogglePlayerSpectating(playerid, 1);

	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

	if(IsPlayerInAnyVehicle(targetid))
	{
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
	}
	else
	{
	    PlayerSpectatePlayer(playerid, targetid);
	}

	RefreshPlayerTextdraws(playerid);

	SpectateTargetID[playerid] = targetid;
	SendClientMessageEx(playerid, COLOR_ORANGE, "You are now spectating %s (ID %i).", GetRPName(targetid), targetid);
	return 1;
}
