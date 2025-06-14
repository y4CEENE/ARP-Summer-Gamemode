CMD:createentrance(playerid, params[])
{
	new name[40], Float:x, Float:y, Float:z, Float:a;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[40]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createentrance [name]");
	}
	if(GetNearbyEntrance(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is an entrance in range. Find somewhere else to create this one.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	for(new i = 0; i < MAX_ENTRANCES; i ++)
	{
	    if(!EntranceInfo[i][eExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO entrances (name, pos_x, pos_y, pos_z, pos_a, outsideint, outsidevw) VALUES('%e', '%f', '%f', '%f', '%f', %i, %i)", name, x, y, z, a - 180.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateEntrance", "iisffff", playerid, i, name, x, y, z, a);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Entrance slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editentrance(playerid, params[])
{
	new entranceid, option[14], param[64];

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[14]S()[64]", entranceid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Exterior, Interior, Name, Icon, World, Owner, Locked, Radius, AdminLevel");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Faction, Gang, VIP, Vehicles, Freeze, Label, Password, Type, MapIcon, Color");
	    return 1;
	}
	if(!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid entrance.");
	}

	if(!strcmp(option, "exterior", true))
	{
	    GetPlayerPos(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]);
	    GetPlayerFacingAngle(playerid, EntranceInfo[entranceid][ePosA]);

	    EntranceInfo[entranceid][eOutsideInt] = GetPlayerInterior(playerid);
	    EntranceInfo[entranceid][eOutsideVW] = GetPlayerVirtualWorld(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], EntranceInfo[entranceid][ePosA], EntranceInfo[entranceid][eOutsideInt], EntranceInfo[entranceid][eOutsideVW], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the exterior of entrance %i.", entranceid);
	}
	else if(!strcmp(option, "interior", true))
	{
	    GetPlayerPos(playerid, EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ]);
	    GetPlayerFacingAngle(playerid, EntranceInfo[entranceid][eIntA]);

	    EntranceInfo[entranceid][eInterior] = GetPlayerInterior(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ], EntranceInfo[entranceid][eIntA], EntranceInfo[entranceid][eInterior], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the interior of entrance %i.", entranceid);
	}
	else if(!strcmp(option, "name", true))
	{
	    new name[32];

	    if(sscanf(param, "s[32]", name))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [name] [text]");
		}

		strcpy(EntranceInfo[entranceid][eName], name, 32);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET name = '%e' WHERE id = %i", EntranceInfo[entranceid][eName], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the name of entrance %i to '%s'.", entranceid, name);
	}
	else if(!strcmp(option, "icon", true))
	{
	    new iconid;

	    if(sscanf(param, "i", iconid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [icon] [iconid (19300 = hide)]");
		}
		if(!IsValidModel(iconid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID.");
		}

		EntranceInfo[entranceid][eIcon] = iconid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET iconid = %i WHERE id = %i", EntranceInfo[entranceid][eIcon], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the pickup icon model of entrance %i to %i.", entranceid, iconid);
	}
	else if(!strcmp(option, "world", true))
	{
	    new worldid;

	    if(sscanf(param, "i", worldid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [world] [vw]");
		}

		EntranceInfo[entranceid][eWorld] = worldid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET world = %i WHERE id = %i", EntranceInfo[entranceid][eWorld], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the virtual world of entrance %i to %i.", entranceid, worldid);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(!isnull(param) && !strcmp(param, "none", true))
		{
 			SetEntranceOwner(entranceid, INVALID_PLAYER_ID);
	    	return SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the owner of entrance %i.", entranceid);
		}
		if(sscanf(param, "u", targetid))
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [owner] [playerid/none]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(!PlayerData[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
		}

        SetEntranceOwner(entranceid, targetid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of entrance %i to %s.", entranceid, GetRPName(targetid));
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [locked] [0/1]");
		}

		EntranceInfo[entranceid][eLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[entranceid][eLocked], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of entrance %i to %i.", entranceid, locked);
	}
	else if(!strcmp(option, "radius", true))
	{
	    new Float:radius;

	    if(sscanf(param, "f", radius))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [radius] [range]");
		}
		if(!(1.0 <= radius <= 20.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The entry radius must range between 1.0 and 20.0.");
		}

		EntranceInfo[entranceid][eRadius] = radius;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET radius = '%f' WHERE id = %i", EntranceInfo[entranceid][eRadius], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entry radius of entrance %i to %.1f.", entranceid, radius);
	}
	else if(!strcmp(option, "adminlevel", true))
	{
	    new level;

	    if(sscanf(param, "i", level))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [adminlevel] [level]");
		}
		if(!(0 <= level <= 7))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 7.");
		}

		EntranceInfo[entranceid][eAdminLevel] = level;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET adminlevel = %i WHERE id = %i", EntranceInfo[entranceid][eAdminLevel], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the admin level of entrance %i to %i.", entranceid, level);
	}
	else if(!strcmp(option, "faction", true))
	{
	    new factionid;

	    if(sscanf(param, "i", factionid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [faction] [factionid]");
	        return 1;
		}
	    if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction id.");
        }
		EntranceInfo[entranceid][eFaction] = factionid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET faction = %i WHERE id = %i", EntranceInfo[entranceid][eFaction], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(factionid == -1)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the faction type of entrance %i.", entranceid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the faction type of entrance %i to %s (%i).", entranceid, FactionInfo[factionid][fName], factionid);
	}
	else if(!strcmp(option, "gang", true))
	{
	    new gangid;

	    if(sscanf(param, "i", gangid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [gang] [gangid]");
		}
		if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		}

		EntranceInfo[entranceid][eGang] = gangid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET gang = %i WHERE id = %i", EntranceInfo[entranceid][eGang], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(gangid == -1)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the gang of entrance %i.", entranceid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the gang of entrance %i to %s (%i).", entranceid, GangInfo[gangid][gName], gangid);
	}
	else if(!strcmp(option, "vip", true))
	{
	    new rankid;

	    if(sscanf(param, "i", rankid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [vip] [rankid]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "List of ranks: (0) None (1) Silver (2) Gold (3) Legendary");
	        return 1;
		}
		if(!(0 <= rankid <= 3))
		{
			return SendClientMessage(playerid, COLOR_GREY, "Invalid VIP rank.");
		}

		EntranceInfo[entranceid][eVIP] = rankid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET vip = %i WHERE id = %i", EntranceInfo[entranceid][eVIP], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the VIP rank of entrance %i to {D909D9}%s{33CCFF} (%i).", entranceid, GetVIPRank(rankid), rankid);
	}
	else if(!strcmp(option, "vehicles", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [vehicles] [0/1]");
		}

		EntranceInfo[entranceid][eVehicles] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET vehicles = %i WHERE id = %i", EntranceInfo[entranceid][eVehicles], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(status)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've allowed vehicle entry for entrance %i.", entranceid);
		else
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've disallowed vehicle entry for entrance %i.", entranceid);
	}
	else if(!strcmp(option, "freeze", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [freeze] [0/1]");
		}

		EntranceInfo[entranceid][eFreeze] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET freeze = %i WHERE id = %i", EntranceInfo[entranceid][eFreeze], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(status)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled freeze & object loading for entrance %i.", entranceid);
		else
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled freeze & object loading for entrance %i.", entranceid);
	}
	else if(!strcmp(option, "label", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [label] [0/1]");
		}

		EntranceInfo[entranceid][eLabel] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET label = %i WHERE id = %i", EntranceInfo[entranceid][eLabel], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);

		if(status)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled the 3D text label for entrance %i.", entranceid);
		else
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled the 3D text label for entrance %i.", entranceid);
	}
	else if(!strcmp(option, "password", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [password] [text ('none' to reset)]");
		}

		strcpy(EntranceInfo[entranceid][ePassword], param, 64);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET password = '%e' WHERE id = %i", EntranceInfo[entranceid][ePassword], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the password of entrance %i to '%s'.", entranceid, param);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [type] [type id]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (0) None (1) Duel Arena (2) Repair");
	        return 1;
		}
		if(!(0 <= type <= 2))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

        EntranceInfo[entranceid][eType] = type;

		if(type == 1)
		{
		    EntranceInfo[entranceid][eIntX] = 1419.6472;
			EntranceInfo[entranceid][eIntY] = 4.0132;
			EntranceInfo[entranceid][eIntZ] = 1002.3906;
			EntranceInfo[entranceid][eIntA] = 90.0000;
			EntranceInfo[entranceid][eInterior] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, type = %i WHERE id = %i", EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ], EntranceInfo[entranceid][eIntA], EntranceInfo[entranceid][eInterior], EntranceInfo[entranceid][eType], EntranceInfo[entranceid][eID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET type = %i WHERE id = %i", EntranceInfo[entranceid][eType], EntranceInfo[entranceid][eID]);
		    mysql_tquery(connectionID, queryBuffer);
		}

		ReloadEntrance(entranceid);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the special type for entrance %i to %i.", entranceid, type);
	}
	else if(!strcmp(option, "mapicon", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [mapicon] [type (0-63)]");
		}
		if(!(0 <= type <= 63))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid map icon.");
		}

		EntranceInfo[entranceid][eMapIcon] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET mapicon = %i WHERE id = %i", EntranceInfo[entranceid][eMapIcon], EntranceInfo[entranceid][eID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map icon of entrance %i to %i.", entranceid, type);
	}
	else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [color] [0xRRGGBBAA]");
		}

		EntranceInfo[entranceid][eColor] = (color & ~0xFF) | 0xFF;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET color = %i WHERE id = %i", EntranceInfo[entranceid][eColor], EntranceInfo[entranceid][eID]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadEntrance(entranceid);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the {%06x}color{33CCFF} of entrance ID %i.", color >>> 8, entranceid);
	}

	return 1;
}

CMD:removeentrance(playerid, params[])
{
	new entranceid;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", entranceid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeentrance [entranceid]");
	}
	if(!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid entrance.");
	}

	RemoveEntrance(entranceid);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed entrance %i.", entranceid);
	return 1;
}

GotoEntrance(playerid, entranceid)
{
	SetPlayerPos(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]);
	SetPlayerFacingAngle(playerid, EntranceInfo[entranceid][ePosA]);
	SetPlayerInterior(playerid, EntranceInfo[entranceid][eOutsideInt]);
	SetPlayerVirtualWorld(playerid, EntranceInfo[entranceid][eOutsideVW]);
	SetCameraBehindPlayer(playerid);
}

CMD:gotoentrance(playerid, params[])
{
	new entranceid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", entranceid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoentrance [entranceid]");
	}
	if(!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid entrance.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	GotoEntrance(playerid, entranceid);
	return 1;
}