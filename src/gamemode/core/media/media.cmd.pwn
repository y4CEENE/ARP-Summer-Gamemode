CMD:boombox(playerid, params[])
{
	new option[10], param[128];

	if(!PlayerData[playerid][pBoombox])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no boombox and therefore can't use this command.");
	}
	if(sscanf(params, "s[10]S()[128]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /boombox [place | pickup | play]");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}

	if(!strcmp(option, "place", true))
	{
	    if(PlayerData[playerid][pBoomboxPlaced])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have placed down a boombox already.");
	    }
	    if(GetNearbyBoombox(playerid) != INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "There is already a boombox nearby. Place this one somewhere else.");
        }

		new
		    Float:x,
	    	Float:y,
	    	Float:z,
	    	Float:a,
			string[128];

		format(string, sizeof(string), "{FFFF00}Boombox placed by:\n{FF0000}%s{FFFF00}\n/boombox for more options.", GetPlayerNameEx(playerid));

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

	    PlayerData[playerid][pBoomboxPlaced] = 1;
    	PlayerData[playerid][pBoomboxObject] = CreateDynamicObject(2102, x, y, z - 1.0, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    	PlayerData[playerid][pBoomboxText] = CreateDynamic3DTextLabel(string, COLOR_LIGHTORANGE, x, y, z - 0.8, 10.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid));
        PlayerData[playerid][pBoomboxURL] = 0;

    	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
		ShowActionBubble(playerid, "* %s places a boombox on the ground.", GetRPName(playerid));
	}
	else if(!strcmp(option, "pickup", true))
	{
	    if(!PlayerData[playerid][pBoomboxPlaced])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have not placed down a boombox.");
	    }
	    if(!IsPlayerInRangeOfDynamicObject(playerid, PlayerData[playerid][pBoomboxObject], 3.0))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your boombox.");
		}

		ShowActionBubble(playerid, "* %s picks up their boombox and switches it off.", GetRPName(playerid));
		DestroyBoombox(playerid);
	}
    else if(!strcmp(option, "play", true))
	{
        if(!PlayerData[playerid][pBoomboxPlaced])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have not placed down a boombox.");
	    }
	    if(!IsPlayerInRangeOfDynamicObject(playerid, PlayerData[playerid][pBoomboxObject], 3.0))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your boombox.");
		}

    	PlayerData[playerid][pMusicType] = MUSIC_BOOMBOX;
        ShowMP3Player(playerid);
	}

	return 1;
}

CMD:mp3(playerid, params[])
{
	if(!PlayerData[playerid][pMP3Player])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have an MP3 player.");
	}

	PlayerData[playerid][pMusicType] = MUSIC_MP3PLAYER;
    ShowMP3Player(playerid);
	return 1;
}

CMD:setradio(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in any vehicle.");
	}

	PlayerData[playerid][pMusicType] = MUSIC_VEHICLE;
    ShowMP3Player(playerid);
	return 1;
}