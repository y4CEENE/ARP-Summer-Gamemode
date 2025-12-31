#include <YSI\y_hooks>

static SpectateTargetID[MAX_PLAYERS];
static SpectateType[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
	SpectateTargetID[playerid] = INVALID_PLAYER_ID;
    return 1;
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Body Camera\n/watchbodycams to start watch.", COLOR_YELLOW, 1579.379882, -1683.562133, 2110.538330, 10.0);

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
	if(!IsAdminOnDuty(playerid) && !PlayerData[playerid][pAdminPersonnel])
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	if(!strcmp(params, "off", true) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    SendClientMessageEx(playerid, COLOR_ORANGE, "You are no longer spectating %s (ID %i).", GetRPName(SpectateTargetID[playerid]), SpectateTargetID[playerid]);
	    SpectateTargetID[playerid] = INVALID_PLAYER_ID;
		PlayerData[playerid][pBodyCam] = 0;
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

// From BodyCams.pwn

CMD:BodyCamsList(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_POLICE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a part of the Police Faction.");
    }

    SCM(playerid, COLOR_BLUE, "List Officer:");
    new string[128];
    foreach(new i : Player)
    {
        if(PlayerData[i][pFaction] == PlayerData[playerid][pFaction])
        {
            format(string, sizeof(string), "(ID: %i) %s", i, GetRPName(i));
			SCM(playerid, COLOR_WHITE, string);
		}
    }

	return 1;
}

CMD:WatchBodyCams(playerid, params[])
{
    new targetid;

	if (GetPlayerFaction(playerid) != FACTION_POLICE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a part of the Police Faction.");
    }
	if(!strcmp(params, "off", true) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    SendClientMessageEx(playerid, COLOR_BLUE, "You are no longer spectating %s (ID %i).", GetRPName(SpectateTargetID[playerid]), SpectateTargetID[playerid]);
	    SpectateTargetID[playerid] = INVALID_PLAYER_ID;
	    SetPlayerToSpawn(playerid);
	    return 1;
 	}
    if(PlayerData[playerid][pFactionRank] < 1)
 	{
 	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /WatchBodyCams [playerid/off]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1579.379882, -1683.562133, 2110.538330))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of Camera Center.");
    }
	if (PlayerData[targetid][pBodyCam] == 0)
    {
    return SendClientMessage(playerid, COLOR_GREY, "The officer their bodycam currently disabled.");
    }
    if (GetPlayerFaction(targetid) != FACTION_POLICE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command on this player.");
    }
	if(targetid == playerid)
	{
	    return SCM(playerid, COLOR_SYNTAX, "You can't spectate yourself.");
	}

	SavePlayerVariables(playerid);
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

	SpectateTargetID[playerid] = targetid;
	SendClientMessageEx(playerid, COLOR_BLUE, "You are now spectating %s (ID %i).", GetRPName(targetid), targetid);
	return 1;
}

CMD:bodycam(playerid, params[])
{
    new option[14];

    if (GetPlayerFaction(playerid) != FACTION_POLICE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a part of the Police Faction.");
    }
    if (sscanf(params, "s[14]", option)) // Fixed sscanf format
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bodycam [on/off]");
    }

    if (!strcmp(option, "on", true))
    {
        if (PlayerData[playerid][pBodyCam] == 1)
        {
            return SCM(playerid, COLOR_GREY, "Your bodycam is already enabled.");
        }

        PlayerData[playerid][pBodyCam] = 1; // ✅ Enable bodycam
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_ROYALBLUE, ">: %s has enabled their bodyCam successfully.**", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_PURPLE, "* %s has enabled his bodycam successfully.", GetRPName(playerid));
        ShowActionBubble(playerid, "* %s has enabled his bodycam successfully.", GetRPName(playerid));
    }
    else if (!strcmp(option, "off", true))
    {
        if (PlayerData[playerid][pBodyCam] == 0)
        {
            return SCM(playerid, COLOR_GREY, "Your bodycam is already disabled.");
        }

        PlayerData[playerid][pBodyCam] = 0; // ✅ Disable bodycam
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_ROYALBLUE, ">: %s has disabled their BodyCam.**", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_PURPLE, "* %s has disabled his bodycam successfully.", GetRPName(playerid));
        ShowActionBubble(playerid, "* %s has disabled his bodycam successfully.", GetRPName(playerid));
    }
    else
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bodycam [on/off]");
    }

    return 1;
}
