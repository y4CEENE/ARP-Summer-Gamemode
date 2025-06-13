/// @file      BodyCams.pwn
/// @author    Khalil
/// @date      Created at 2025-04-07 19:50:00
/// @copyright Copyright (c) 2025

#include <YSI\y_hooks>

// This Code Past In Spectate.pwn

/*hook OnPlayerInit(playerid)
{
    PlayerData[playerid][pBodyCam] = 0;
    return 1;
}

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
	if(sscanf(params, "u", targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /WatchBodyCams [playerid/off]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 3960.052734, 1011.483886, 734.651489))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of Camera Center.");
    }
	if (PlayerData[targetid][pBodyCam] == 0)
    {
    return SendClientMessage(playerid, COLOR_GREY, "The their bodycam currently disabled.");
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

// ramadan 3ala abwab 
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
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_ROYALBLUE, ">: %s has enabled their BodyCam.**", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_AQUA, "You have enabled your bodycam successfully.");
    }
    else if (!strcmp(option, "off", true))
    {
        if (PlayerData[playerid][pBodyCam] == 0)
        {
            return SCM(playerid, COLOR_GREY, "Your bodycam is already disabled.");
        }

        PlayerData[playerid][pBodyCam] = 0; // ✅ Disable bodycam
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_ROYALBLUE, ">: %s has disabled their BodyCam.**", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_AQUA, "You have disabled your bodycam successfully.");
    }
    else
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bodycam [on/off]");
    }

    return 1;
}*/