
CMD:changegender(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 2)
    {
	    return SendClientMessage(playerid, COLOR_GREY, "This command is only available to donators level 2+.");
    }

	if(isnull(params))
    {
	    return SendClientMessage(playerid, COLOR_GREY, "USAGE: /changegender ['male' or 'female']");
    }
    if(!strcmp(params, "male", true))
    {
        PlayerData[playerid][pGender] = 1;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gender = 1 WHERE uid = %i", PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	    SendClientMessage(playerid, COLOR_WHITE, "You are now Male.");
    }
    else if(!strcmp(params, "female", true))
    {
        PlayerData[playerid][pGender] = 2;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gender = 2 WHERE uid = %i", PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	    SendClientMessage(playerid, COLOR_WHITE, "You are now Female.");
    }
    else SendClientMessage(playerid, COLOR_GREY, "I'm afraid we don't do that here.");

    return 1;
}

CMD:changeage(playerid, params[])
{
    new value;
	if(PlayerData[playerid][pDonator] < 2)
    {
	    return SendClientMessage(playerid, COLOR_GREY, "This command is only available to donators level 2+.");
    }
    
    if(sscanf(params, "i", value))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changeage [18 <= value <= 128 ]");
    }
    if(!(18 <= value <= 128))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 128.");
    }

    PlayerData[playerid][pAge] = value;
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET age = %i WHERE uid = %i", value, PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_WHITE, "You have changed your age to %d.", PlayerData[playerid][pAge]);
    return 1;
}
CMD:locatelounge(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 1)
    {
	    return SendClientMessage(playerid, COLOR_GREY, "This command is only available to donators.");
    }
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You already have a checkpoint use /kcp to clear it.");
	}
    if(GetPlayerDistanceFromPoint(playerid, 1308.8757, -1367.2715, 13.5256) < GetPlayerDistanceFromPoint(playerid, -1549.5186,  1171.9185,  7.1875))
    {
        SetPlayerCheckpoint(playerid, 1308.8757, -1367.2715, 13.5256, 2.5);
        SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to LS VIP Lounge");
        PlayerData[playerid][pCP] = CHECKPOINT_MISC;
    }
    else
    {
        SetPlayerCheckpoint(playerid, -1549.5186,  1171.9185,  7.1875, 2.5);
        SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to SF VIP Lounge");
        PlayerData[playerid][pCP] = CHECKPOINT_MISC;
    }
    return 1;
}
CMD:changeplates(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 3)
    {
	    return SendClientMessage(playerid, COLOR_GREY, "This command is only available to donators level 3.");
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    
    if(vehicleid == INVALID_VEHICLE_ID || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be inside your vehicle that you want to change the plates on.");
    }

	new color[32], plate[32], coloredplate[32];

	if(sscanf(params, "s[32]s[32]", color, plate))
	{
        SendClientMessage(playerid, COLOR_WHITE, "USAGE: /changeplates [color] [new plate]");
		SendClientMessage(playerid, COLOR_GREY, "Available colors: {EFEFEF}default, black, white, blue, red, green, purple");
		SendClientMessage(playerid, COLOR_GREY, "{EFEFEF}yellow, lightblue, darkgreen, darkblue, darkgrey, darkbrown, pink");
		return 1;
	}
	new Float: fVehicleHealth;
	
    GetVehicleHealth(vehicleid, fVehicleHealth);

    if(fVehicleHealth < 800)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your vehicle needs to have 800 HP before you can change the plates on it.");
    }
    
    if(strlen(plate) > 8)
    {
		return SendClientMessage(playerid, COLOR_GREY, "The license plate can not be longer than 8 characters!");
    }

    if(strcmp(color, "black", true)==0)          format(coloredplate, 32, "{000000}%s", plate);
    else if(strcmp(color, "white", true)==0)     format(coloredplate, 32, "{FFFFFF}%s", plate);
    else if(strcmp(color, "blue", true)==0)      format(coloredplate, 32, "{2641FE}%s", plate);
    else if(strcmp(color, "red", true)==0)       format(coloredplate, 32, "{AA3333}%s", plate);
    else if(strcmp(color, "green", true)==0)     format(coloredplate, 32, "{33AA33}%s", plate);
    else if(strcmp(color, "purple", true)==0)    format(coloredplate, 32, "{C2A2DA}%s", plate);
    else if(strcmp(color, "yellow", true)==0)    format(coloredplate, 32, "{FFFF00}%s", plate);
    else if(strcmp(color, "lightblue", true)==0) format(coloredplate, 32, "{33CCFF}%s", plate);
    else if(strcmp(color, "darkgreen", true)==0) format(coloredplate, 32, "{2D6F00}%s", plate);
    else if(strcmp(color, "darkblue", true)==0)  format(coloredplate, 32, "{0B006F}%s", plate);
    else if(strcmp(color, "darkgrey", true)==0)  format(coloredplate, 32, "{525252}%s", plate);
    else if(strcmp(color, "gold", true)==0)      format(coloredplate, 32, "{B46F00}%s", plate);
    else if(strcmp(color, "darkbrown", true)==0||strcmp(color, "dennell", true)==0) format(coloredplate, 32, "{814F00}%s", plate);
    else if(strcmp(color, "darkred", true)==0)   format(coloredplate, 32, "{750A00}%s", plate);
    else if(strcmp(color, "pink", true)==0)      format(coloredplate, 32, "{FF51F1}%s", plate);
    else strcpy(coloredplate, plate);

    strcpy(VehicleInfo[vehicleid][vPlate], coloredplate, 32);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET plate = '%e' WHERE id = %i", VehicleInfo[vehicleid][vPlate], VehicleInfo[vehicleid][vID]);
    mysql_tquery(connectionID, queryBuffer);
    SendClientMessageEx(playerid, COLOR_GREY, "Park your vehicle (/park) to get your new license plate %s", VehicleInfo[vehicleid][vPlate]);
    return 1;
}

