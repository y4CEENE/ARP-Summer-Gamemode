
CMD:creategarage(playerid, params[])
{
	new size[8], type = -1, Float:x, Float:y, Float:z, Float:a;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[8]", size))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /creategarage [small/medium/large]");
	}
	if(GetNearbyGarage(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a garage in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
	}

	if(!strcmp(size, "small", true)) {
	    type = 0;
	} else if(!strcmp(size, "medium", true)) {
	    type = 1;
	} else if(!strcmp(size, "large", true)) {
	    type = 2;
	}

	if(type == -1)
	{
	     SendClientMessage(playerid, COLOR_GREY, "Invalid size. Valid sizes range from Small, Medium and Large.");
	}
	else
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

  		for(new i = 0; i < MAX_GARAGES; i ++)
		{
		    if(!GarageInfo[i][gExists])
		    {
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO garages (type, price, pos_x, pos_y, pos_z, pos_a, exit_x, exit_y, exit_z, exit_a) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", type, garageInteriors[type][intPrice], x, y, z, a, x - 3.0 * floatsin(-a, degrees), y - 3.0 * floatcos(-a, degrees), z, a - 180.0);
				mysql_tquery(connectionID, queryBuffer, "OnAdminCreateGarage", "iiiffff", playerid, i, type, x, y, z, a);
				return 1;
			}
		}

		SendClientMessage(playerid, COLOR_GREY, "Garage slots are currently full. Ask developers to increase the internal limit.");
	}

	return 1;
}

CMD:editgarage(playerid, params[])
{
	new garageid, option[10], param[32];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[10]S()[32]", garageid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Entrance, Exit, Type, Owner, Price, Locked, Freeze");
	    return 1;
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
	}

	if(!strcmp(option, "entrance", true))
	{
	    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
		}

	    GetPlayerPos(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
	    GetPlayerFacingAngle(playerid, GarageInfo[garageid][gPosA]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f' WHERE id = %i", GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], GarageInfo[garageid][gPosA], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadGarage(garageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entrance of garage %i.", garageid);
	}
	else if(!strcmp(option, "freeze", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [freeze] [0/1]");
		}

		GarageInfo[garageid][gFreeze] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET freeze = %i WHERE id = %i", GarageInfo[garageid][gFreeze], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);

		if(status)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled freeze & object loading for entrance %i.", garageid);
		else
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled freeze & object loading for entrance %i.", garageid);
	}
	else if(!strcmp(option, "exit", true))
	{
	    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
		}

	    GetPlayerPos(playerid, GarageInfo[garageid][gExitX], GarageInfo[garageid][gExitY], GarageInfo[garageid][gExitZ]);
	    GetPlayerFacingAngle(playerid, GarageInfo[garageid][gExitA]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET exit_x = '%f', exit_y = '%f', exit_z = '%f', exit_a = '%f' WHERE id = %i", GarageInfo[garageid][gExitX], GarageInfo[garageid][gExitY], GarageInfo[garageid][gExitZ], GarageInfo[garageid][gExitA], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadGarage(garageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the vehicle exit spawn of garage %i.", garageid);
	}
	else if(!strcmp(option, "type", true))
	{
	    new size[8], type = -1;

	    if(sscanf(param, "s[8]", size))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [type] [small/medium/large]");
		}

		if(!strcmp(size, "small", true)) {
		    type = 0;
		} else if(!strcmp(size, "medium", true)) {
		    type = 1;
		} else if(!strcmp(size, "large", true)) {
		    type = 2;
		}

		if(type == -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

		GarageInfo[garageid][gType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET type = %i WHERE id = %i", type, GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the type of garage %i to %s.", garageid, size);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [owner] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(!PlayerData[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
		}

        SetGarageOwner(garageid, targetid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of garage %i to %s.", garageid, GetRPName(targetid));
	}
	else if(!strcmp(option, "price", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [price] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
		}

		GarageInfo[garageid][gPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET price = %i WHERE id = %i", GarageInfo[garageid][gPrice], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the price of garage %i to $%i.", garageid, price);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [locked] [0/1]");
		}

		GarageInfo[garageid][gLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[garageid][gLocked], GarageInfo[garageid][gID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadGarage(garageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of garage %i to %i.", garageid, locked);
	}

	return 1;
}

CMD:removegarage(playerid, params[])
{
	new garageid;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removegarage [garageid]");
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
	}

	DestroyDynamic3DTextLabel(GarageInfo[garageid][gText]);
	DestroyDynamicPickup(GarageInfo[garageid][gPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM garages WHERE id = %i", GarageInfo[garageid][gID]);
	mysql_tquery(connectionID, queryBuffer);

	GarageInfo[garageid][gExists] = 0;
	GarageInfo[garageid][gID] = 0;
	GarageInfo[garageid][gOwnerID] = 0;
    Iter_Remove(Garage, garageid);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed garage %i.", garageid);
	return 1;
}

CMD:gotogarage(playerid, params[])
{
	new garageid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotogarage [garageid]");
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
	SetPlayerFacingAngle(playerid, GarageInfo[garageid][gPosA]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:garagehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** GARAGE HELP ** type a command for more information.");
	SendClientMessage(playerid, COLOR_GREY, "** GARAGE ** /buygarage /lock /upgradegarage /sellgarage /sellmygarage /garageinfo");
	SendClientMessage(playerid, COLOR_GREY, "** GARAGE ** /repair");
	return 1;
}

CMD:buygarage(playerid, params[])
{
	new garageid;

	if((garageid = GetNearbyGarage(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no garage in range. You must be near a garage.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buygarage [confirm]");
	}
	if(GarageInfo[garageid][gOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This garage already has an owner.");
	}
	if(PlayerData[playerid][pCash] < GarageInfo[garageid][gPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this garage.");
	}
	if(GetPlayerAssetCount(playerid, LIMIT_GARAGES) >= GetPlayerAssetLimit(playerid, LIMIT_GARAGES))
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i garages. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
	}

	SetGarageOwner(garageid, playerid);
	GivePlayerCash(playerid, -GarageInfo[garageid][gPrice]);

	SendClientMessageEx(playerid, COLOR_GREEN, "You paid %s to make this garage yours! /garagehelp for a list of commands.", FormatCash(GarageInfo[garageid][gPrice]));
    Log_Write("log_property", "%s (uid: %i) purchased %s garage (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], GarageInfo[garageid][gPrice]);
	return 1;
}

CMD:upgradegarage(playerid, params[])
{
	new garageid = GetNearbyGarageEx(playerid);

	if(garageid == -1 || !IsGarageOwner(playerid, garageid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
	}
	if(GarageInfo[garageid][gType] >= 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your garage is already at its maximum possible size. You cannot upgrade it further.");
	}
	if(isnull(params) || strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradegarage [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "The next garage size available is %s and costs %s to upgrade to.", garageInteriors[GarageInfo[garageid][gType] + 1][intName], FormatCash(garageInteriors[GarageInfo[garageid][gType] + 1][intPrice]));
		return 1;
	}
	if(PlayerData[playerid][pCash] < garageInteriors[GarageInfo[garageid][gType] + 1][intPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to upgrade your garage.");
	}

	foreach(new i: Vehicle)
	{
	    if(IsVehicleInGarage(i, garageid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You must remove all vehicles from your garage before proceeding.");
		}
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM vehicles WHERE ownerid = %i AND interior > 0 AND world = %i", PlayerData[playerid][pID], GarageInfo[garageid][gWorld]);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerUpgradeGarage", "ii", playerid, garageid);
	return 1;
}

CMD:sellgarage(playerid, params[])
{
	new garageid = GetNearbyGarageEx(playerid), targetid, amount;

	if(garageid == -1 || !IsGarageOwner(playerid, garageid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellgarage [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
	}

	PlayerData[targetid][pGarageOffer] = playerid;
	PlayerData[targetid][pGarageOffered] = garageid;
	PlayerData[targetid][pGaragePrice] = amount;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their garage for %s (/accept garage).", GetRPName(playerid), FormatCash(amount));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your garage for %s.", GetRPName(targetid), FormatCash(amount));
	return 1;
}

CMD:sellmygarage(playerid, params[])
{
	new garageid = GetNearbyGarageEx(playerid);

	if(garageid == -1 || !IsGarageOwner(playerid, garageid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmygarage [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your garage back to the state. You will receive %s back.", FormatCash(percent(GarageInfo[garageid][gPrice], 75)));
	    return 1;
	}

	SetGarageOwner(garageid, INVALID_PLAYER_ID);
	GivePlayerCash(playerid, percent(GarageInfo[garageid][gPrice], 75));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your garage to the state and received %s back.", FormatCash(percent(GarageInfo[garageid][gPrice], 75)));
    Log_Write("log_property", "%s (uid: %i) sold their %s garage (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], percent(GarageInfo[garageid][gPrice], 75));
	return 1;
}

CMD:garageinfo(playerid, params[])
{
    new garageid = GetNearbyGarageEx(playerid);

	if(garageid == -1 || !IsGarageOwner(playerid, garageid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
	}

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ Garage ID %i _______", garageid);
	SendClientMessageEx(playerid, COLOR_GREY2, "Value: %s - Size: %s - Location: %s - Active: %s - Locked: %s", FormatCash(GarageInfo[garageid][gPrice]), garageInteriors[GarageInfo[garageid][gType]][intName], GetZoneName(GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]), (gettime() - GarageInfo[garageid][gTimestamp] > 2592000) ? ("{FF6347}No{C8C8C8}") : ("Yes"), (GarageInfo[garageid][gLocked]) ? ("Yes") : ("No"));
	return 1;
}