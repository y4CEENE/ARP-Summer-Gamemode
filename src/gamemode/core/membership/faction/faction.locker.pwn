/*
gotolocker **
fpark **
factionkick
switchfaction **
editfaction
purgefaction **
"/factionpay" and "/faction edit" are the same
*/

CMD:createlocker(playerid, params[])
{
	new factionid, Float:x, Float:y, Float:z;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createlocker [factionid]");
	}
    if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}

    GetPlayerPos(playerid, x, y, z);

	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
		if(!LockerInfo[i][lExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionlockers (factionid, pos_x, pos_y, pos_z, interior, world) VALUES(%i, '%f', '%f', '%f', %i, %i)", factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateLocker", "iiifffii", playerid, i, factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Locker slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editlocker(playerid, params[])
{
	new lockerid, option[32], param[32];

	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[32]S()[32]", lockerid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [option]");
		SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Position, FactionID, Icon, Label, Weapons");
		return 1;
	}
	if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
	}
    if(!strcmp(option, "position", true))
    {
		GetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
		LockerInfo[lockerid][lInterior] = GetPlayerInterior(playerid);
		LockerInfo[lockerid][lWorld] = GetPlayerVirtualWorld(playerid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET pos_x = '%f', pos_y = '%f', pos_z = '%f', interior = %i, world = %i WHERE id = %i", LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], LockerInfo[lockerid][lInterior], LockerInfo[lockerid][lWorld], LockerInfo[lockerid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have moved locker %i to your position.", lockerid);
		ReloadLocker(lockerid);
	}
	else if(!strcmp(option, "factionid", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editlocker [%i] [%s] [value]", lockerid, option);
		}
	    LockerInfo[lockerid][lFaction] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET factionid = %i WHERE id = %i", LockerInfo[lockerid][lFaction], LockerInfo[lockerid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You set locker %i's faction to %i.", lockerid, value);
		ReloadLocker(lockerid);
	}
	else if(!strcmp(option, "icon", true))
	{
	    new iconid;

	    if(sscanf(param, "i", iconid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [icon] [iconid (19300 = hide)]");
		}
		if(!IsValidModel(iconid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID.");
		}

		LockerInfo[lockerid][lIcon] = iconid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET iconid = %i WHERE id = %i", LockerInfo[lockerid][lIcon], LockerInfo[lockerid][lID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadLocker(lockerid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the pickup icon model of locker %i to %i.", lockerid, iconid);
	}
	else if(!strcmp(option, "label", true))
	{
	    new status;

	    if(sscanf(param, "i", status) || !(0 <= status <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [label] [0/1]");
		}

		LockerInfo[lockerid][lLabel] = status;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET label = %i WHERE id = %i", LockerInfo[lockerid][lLabel], LockerInfo[lockerid][lID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadLocker(lockerid);

		if(status)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled the 3D text label for locker %i.", lockerid);
		else
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled the 3D text label for locker %i.", lockerid);
	}
	else if(!strcmp(option, "weapons", true))
	{
	    if(FactionInfo[LockerInfo[lockerid][lFaction]][fType] == FACTION_HITMAN)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Weapons for hitman agency lockers cannot be edited in-game.");
	    }
	    new inputtext[24], opt2[8], amount;
	    if(sscanf(param, "s[24]s[8]i", inputtext, opt2, amount))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [weapons] [weaponname] [option] [amount]");
            SendClientMessage(playerid, COLOR_GREEN, "Weapon Name: Kevlar, Medkit, Nitestick, Mace, Deagle, Shotgun, M4, MP5, Spas12, Sniper, Camera, FireExt, Painkillers");
			SendClientMessage(playerid, COLOR_YELLOW, "Options: Allow, Price");
			SendClientMessage(playerid, COLOR_ORANGE, "Amount: Price (amount), Allow (1 or 0)");
	        return 1;
	    }
		if(!strcmp(opt2, "allow", true))
		{
		    if(!(0 <= amount <= 1)) return SendClientMessage(playerid, COLOR_GREY, "Amount can be 1 or 0");
			if(!strcmp(inputtext, "Kevlar", true))
			{
				LockerInfo[lockerid][locKevlar][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_kevlar = %i WHERE id = %i", LockerInfo[lockerid][locKevlar][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Medkit", true))
			{
                LockerInfo[lockerid][locMedKit][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_medkit = %i WHERE id = %i", LockerInfo[lockerid][locMedKit][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Nitestick", true))
			{
                LockerInfo[lockerid][locNitestick][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_nitestick = %i WHERE id = %i", LockerInfo[lockerid][locNitestick][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Mace", true))
			{
                LockerInfo[lockerid][locMace][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_mace = %i WHERE id = %i", LockerInfo[lockerid][locMace][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
            else if(!strcmp(inputtext, "Deagle", true))
			{
                LockerInfo[lockerid][locDeagle][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_deagle = %i WHERE id = %i", LockerInfo[lockerid][locDeagle][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Shotgun", true))
			{
			    LockerInfo[lockerid][locShotgun][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_shotgun = %i WHERE id = %i", LockerInfo[lockerid][locShotgun][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "MP5", true))
			{
                LockerInfo[lockerid][locMP5][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_mp5 = %i WHERE id = %i", LockerInfo[lockerid][locMP5][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "M4", true))
			{
                LockerInfo[lockerid][locM4][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_m4 = %i WHERE id = %i", LockerInfo[lockerid][locM4][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Spas12", true))
			{
                LockerInfo[lockerid][locSpas12][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_spas12 = %i WHERE id = %i", LockerInfo[lockerid][locSpas12][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Sniper", true))
			{
                LockerInfo[lockerid][locSniper][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_sniper = %i WHERE id = %i", LockerInfo[lockerid][locSniper][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Camera", true))
			{
                LockerInfo[lockerid][locCamera][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_camera = %i WHERE id = %i", LockerInfo[lockerid][locCamera][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "FireExt", true))
			{
                LockerInfo[lockerid][locFireExt][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_fire_extinguisher = %i WHERE id = %i", LockerInfo[lockerid][locFireExt][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Painkillers", true))
			{
                LockerInfo[lockerid][locPainKillers][0] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET weapon_painkillers = %i WHERE id = %i", LockerInfo[lockerid][locPainKillers][0], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			SendClientMessageEx(playerid, COLOR_GREY, "Locker %i's %s status set to %i", lockerid, inputtext, amount);
		}
		else if(!strcmp(opt2, "price", true))
		{
            if(!strcmp(inputtext, "Kevlar", true))
			{
				LockerInfo[lockerid][locKevlar][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_kevlar = %i WHERE id = %i", LockerInfo[lockerid][locKevlar], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Medkit", true))
			{
                LockerInfo[lockerid][locMedKit][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_medkit = %i WHERE id = %i", LockerInfo[lockerid][locMedKit], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Nitestick", true))
			{
                LockerInfo[lockerid][locNitestick][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_nitestick = %i WHERE id = %i", LockerInfo[lockerid][locNitestick][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Mace", true))
			{
                LockerInfo[lockerid][locMace][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_mace = %i WHERE id = %i", LockerInfo[lockerid][locMace][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
            else if(!strcmp(inputtext, "Deagle", true))
			{
                LockerInfo[lockerid][locDeagle][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_deagle = %i WHERE id = %i", LockerInfo[lockerid][locDeagle][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Shotgun", true))
			{
			    LockerInfo[lockerid][locShotgun][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_shotgun = %i WHERE id = %i", LockerInfo[lockerid][locShotgun][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "MP5", true))
			{
                LockerInfo[lockerid][locMP5][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_mp5 = %i WHERE id = %i", LockerInfo[lockerid][locMP5][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "M4", true))
			{
                LockerInfo[lockerid][locM4][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_m4 = %i WHERE id = %i", LockerInfo[lockerid][locM4][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Spas12", true))
			{
                LockerInfo[lockerid][locSpas12][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_spas12 = %i WHERE id = %i", LockerInfo[lockerid][locSpas12][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Sniper", true))
			{
                LockerInfo[lockerid][locSniper][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_sniper = %i WHERE id = %i", LockerInfo[lockerid][locSniper][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Camera", true))
			{
                LockerInfo[lockerid][locCamera][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_camera = %i WHERE id = %i", LockerInfo[lockerid][locCamera][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "FireExt", true))
			{
                LockerInfo[lockerid][locFireExt][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_fire_extinguisher = %i WHERE id = %i", LockerInfo[lockerid][locFireExt][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
			else if(!strcmp(inputtext, "Painkillers", true))
			{
                LockerInfo[lockerid][locPainKillers][1] = amount;
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET price_painkillers = %i WHERE id = %i", LockerInfo[lockerid][locPainKillers][1], LockerInfo[lockerid][lID]);
	    		mysql_tquery(connectionID, queryBuffer);
			}
		    SendClientMessageEx(playerid, COLOR_GREY, "Locker %i's %s price set to %i", lockerid, inputtext, amount);
		}
	}
	return 1;
}

CMD:removelocker(playerid, params[])
{
	new lockerid;
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", lockerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelocker [lockerid]");
	}
	if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
	}

	DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
	DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionlockers WHERE id = %i", LockerInfo[lockerid][lID]);
	mysql_tquery(connectionID, queryBuffer);

	LockerInfo[lockerid][lExists] = 0;
	LockerInfo[lockerid][lID] = 0;

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed locker %i.", lockerid);
	return 1;
}

CMD:gotolocker(playerid, params[])
{
	new lockerid;

	if(!PlayerData[playerid][pFactionMod] && !IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && !IsGodAdmin(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", lockerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotolocker [lockerid]");
	}
	if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
	SetPlayerInterior(playerid, LockerInfo[lockerid][lInterior]);
	SetPlayerVirtualWorld(playerid, LockerInfo[lockerid][lWorld]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:locker(playerid, params[])
{
    if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(!IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any of your faction lockers.");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to use the lockers. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}

	switch(FactionInfo[PlayerData[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY, FACTION_TERRORIST:
	    {
	        Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Toggle duty\nEquipment\nUniforms\nClothing", "Select", "Cancel");
		}
		case FACTION_MEDIC:
		{
		    Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Toggle duty\nEquipment\nUniforms", "Select", "Cancel");
		}
		case FACTION_GOVERNMENT, FACTION_NEWS:
		{
		    Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Equipment\nUniforms", "Select", "Cancel");
		}
	}

	return 1;
}

GetNearbyLocker(playerid)
{
	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
	    if(LockerInfo[i][lExists] && IsPlayerNearPoint(playerid, 3.0, LockerInfo[i][lPosX], LockerInfo[i][lPosY], LockerInfo[i][lPosZ], LockerInfo[i][lInterior], LockerInfo[i][lWorld]))
	    {
	        return i;
		}
	}

	return -1;
}

ReloadLockers(factionid)
{
	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
	    if(LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
	    {
	        ReloadLocker(i);
		}
	}
}

ReloadLocker(lockerid)
{
	if(LockerInfo[lockerid][lExists])
	{
	    DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
	    DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);
	    if(LockerInfo[lockerid][lLabel])
	    {
	        new string[128];
			if(FactionInfo[LockerInfo[lockerid][lFaction]][fType] == FACTION_HITMAN)
				format(string, sizeof(string), "%s\nBlack market access\n/order to access black market.", FactionInfo[LockerInfo[lockerid][lFaction]][fName]);
			else format(string, sizeof(string), "%s\nLocker access\n/locker to access locker.", FactionInfo[LockerInfo[lockerid][lFaction]][fName]);
     		LockerInfo[lockerid][lText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], 10.0, .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
		}
		LockerInfo[lockerid][lPickup] = CreateDynamicPickup(LockerInfo[lockerid][lIcon], 1, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
	}
}
