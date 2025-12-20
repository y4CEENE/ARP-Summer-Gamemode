
CMD:buyhousealarm(playerid, params[])
{
	foreach(new i : House)
	{
		if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
		{
			if(HouseInfo[i][hAlarm] != 1 && PlayerData[playerid][pCash] > 100000)
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "You have bought an house alarm for $25,000");
			    GivePlayerCash(playerid, -25000);
			    HouseInfo[i][hAlarm] = 1;
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET alarm = %i, where id = %i", HouseInfo[i][hAlarm], HouseInfo[i][hID]);
			    mysql_tquery(connectionID, queryBuffer);
				return 1;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already own a house alarm or don't have enough cash on-hand to cover the cost.");
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	}
	return 1;
}
CMD:househelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** HOUSE HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** HOUSE **  /buyhouse /lock /stash /furniture /upgradehouse /sellhouse /sellmyhouse");
	SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /door /renthouse /unrent /setrent /tenants /evict /evictall /houseinfo");
	SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /houseinvite /hlights /installhousealarm (/iha), /uninstallhousealarm (/uha)");
	return 1;
}


CMD:upgradehouse(playerid, params[])
{
	new
		houseid = GetNearbyHouseEx(playerid),
		option[10],
		param[12],
		string[20];

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "s[10]S()[12]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradehouse [level/interior]");
	}
	if(!strcmp(option, "level", true))
	{
	    new cost = (HouseInfo[houseid][hLevel] * 50000) + 50000;

	    if(HouseInfo[houseid][hLevel] >= 5)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Your house is already at the maximum level possible.");
		}
		if(isnull(param) || strcmp(param, "confirm", true) != 0)
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradehouse [level] [confirm]");
		    SendClientMessageEx(playerid, COLOR_SYNTAX, "You are about to upgrade to level %i/5 which will cost you $%i.", HouseInfo[houseid][hLevel] + 1, cost);
			return 1;
		}
		if(PlayerData[playerid][pCash] < cost)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You don't have that much cash.");
		}

		HouseInfo[houseid][hLevel]++;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET level = level + 1 WHERE id = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer);

		format(string, sizeof(string), "~r~-$%i", cost);
		GameTextForPlayer(playerid, string, 5000, 1);

		GivePlayerCash(playerid, -cost);
		ReloadHouse(houseid);

		if(HouseInfo[houseid][hLevel] == 1)
		{
		    SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your house to level %i/5. You unlocked a stash for your house! (/stash)", HouseInfo[houseid][hLevel]);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your house to level %i/5. Your stash capacity was increased.", HouseInfo[houseid][hLevel]);
		}

		SendClientMessageEx(playerid, COLOR_GREEN, "Your tenant and furniture capacity were also both increased to %i/%i.", GetHouseTenantCapacity(houseid), GetHouseFurnitureCapacity(houseid));
		Log_Write("log_property", "%s (uid: %i) upgraded their house (id: %i) to level %i for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hID], HouseInfo[houseid][hLevel], cost);
	}
	else if(!strcmp(option, "interior", true))
	{
	    static interiors[sizeof(houseInteriors) * 64];

	    if(isnull(interiors))
	    {
	        interiors = "#\tClass\tPrice";

	  		for(new i = 0; i < sizeof(houseInteriors); i ++)
			{
			    format(interiors, sizeof(interiors), "%s\n%i\t%s\t{00AA00}$%i{FFFFFF}", interiors, i + 1, houseInteriors[i][intClass], houseInteriors[i][intPrice]);
			}
		}

		Dialog_Show(playerid, DIALOG_HOUSEINTERIORS, DIALOG_STYLE_TABLIST_HEADERS, "Choose an interior to preview.", interiors, "Preview", "Cancel");
	}

	return 1;
}


CMD:sellhouse(playerid, params[])
{
	new houseid = GetNearbyHouseEx(playerid), targetid, amount;

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellhouse [playerid] [amount]");
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

	PlayerData[targetid][pHouseOffer] = playerid;
	PlayerData[targetid][pHouseOffered] = houseid;
	PlayerData[targetid][pHousePrice] = amount;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their house for %s (/accept house).", GetRPName(playerid), FormatCash(amount));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your house for %s.", GetRPName(targetid), FormatCash(amount));
	return 1;
}

CMD:sellmyhouse(playerid, params[])
{
	new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmyhouse [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your house back to the state. You will receive %s back.", FormatCash(percent(HouseInfo[houseid][hPrice], 75)));
	    return 1;
	}

	SetHouseOwner(houseid, INVALID_PLAYER_ID);
	GivePlayerCash(playerid, percent(HouseInfo[houseid][hPrice], 75));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your house to the state and received %s back.", FormatCash(percent(HouseInfo[houseid][hPrice], 75)));
    Log_Write("log_property", "%s (uid: %i) sold their house (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hID], percent(HouseInfo[houseid][hPrice], 75));
	return 1;
}

CMD:houseinfo(playerid, params[])
{
    new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT (SELECT COUNT(*) FROM rp_furniture WHERE fHouseID = %i) AS furnitureCount, (SELECT COUNT(*) FROM "#TABLE_USERS" WHERE rentinghouse = %i) AS tenantCount", HouseInfo[houseid][hID], HouseInfo[houseid][hID]);
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_HOUSE_INFORMATION, playerid);

	return 1;
}


CMD:setrent(playerid, params[])
{
	new price, houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "i", price))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setrent [price ('0' to disable)]");
	}
	if(!(0 <= price <= 10000))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid price. The price must range between $0 and $10,000.");
	}

	HouseInfo[houseid][hRentPrice] = price;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET rentprice = %i WHERE id = %i", price, HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadHouse(houseid);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the rental price to $%i.", price);
	return 1;
}

CMD:renthouse(playerid, params[])
{
	new houseid;

	if((houseid = GetNearbyHouse(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no house in range. You must be near a house.");
	}
	/*if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /renthouse [confirm]");
	}*/
	if(!HouseInfo[houseid][hOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This house is not owned and therefore cannot be rented.");
	}
	if(!HouseInfo[houseid][hRentPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This house's owner has chosen to disable renting for this house.");
	}
	if(PlayerData[playerid][pCash] < HouseInfo[houseid][hRentPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to rent here.");
	}
	if(IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are the owner of this house. You can't rent here.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM "#TABLE_USERS" WHERE rentinghouse = %i", HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerRentHouse", "ii", playerid, houseid);

 	return 1;
}

CMD:unrent(playerid, params[])
{
	if(!PlayerData[playerid][pRentingHouse])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not renting at any property. You can't use this command.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rentinghouse = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	PlayerData[playerid][pRentingHouse] = 0;
	SendClientMessage(playerid, COLOR_WHITE, "You have ripped up your rental contract.");
	return 1;
}


CMD:hlights(playerid, params[])
{
	new option, houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "i", option) || !(0 <= option <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hlights [lights (1/0)]");
	}
	if(option)
	{
	    SendClientMessage(playerid, COLOR_AQUA, "* You've turned on the lights to this house.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_AQUA, "* You've turned off the lights to this house.");
	}
	HouseInfo[houseid][hLights] = option;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET lights = %i WHERE id = %i", option, HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);
	foreach(new i : Player)
	{
	    if(GetInsideHouse(i) == houseid)
	    {
	        if(HouseInfo[houseid][hLights] == 1)
	        {
	            TextDrawHideForPlayer(i, houseLights);
	        }
	        else
	        {
	            TextDrawShowForPlayer(i, houseLights);
			}
	    }
	}

	return 1;
}

CMD:tenants(playerid, params[])
{
	new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin FROM "#TABLE_USERS" WHERE rentinghouse = %i ORDER BY lastlogin DESC", HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LIST_TENANTS, playerid);
	return 1;
}

CMD:evict(playerid, params[])
{
    new username[MAX_PLAYER_NAME], houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /evict [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e' AND rentinghouse = %i", username, HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerEvict", "is", playerid, username);
	return 1;
}

CMD:evictall(playerid, params[])
{
    new houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}

	foreach(new i : Player)
    {
        if(PlayerData[i][pLogged] && PlayerData[i][pRentingHouse] == HouseInfo[houseid][hID])
        {
            PlayerData[i][pRentingHouse] = 0;
            SendClientMessage(i, COLOR_RED, "You have been evicted from your home by the owner.");
        }
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rentinghouse = 0 WHERE rentinghouse = %i", HouseInfo[houseid][hID]);
    mysql_tquery(connectionID, queryBuffer);

    SendClientMessage(playerid, COLOR_WHITE, "You have evicted all tenants from your home.");
    return 1;
}

CMD:houseinvite(playerid, params[])
{
	new targetid, houseid = GetNearbyHouseEx(playerid);

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(sscanf(params, "i", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /houseinvite [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't invite yourself to your own home.");
	}

	PlayerData[targetid][pInviteOffer] = playerid;
	PlayerData[targetid][pInviteHouse] = houseid;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has offered you an invitation to their house in %s. (/accept invite)", GetRPName(playerid), GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s an invitation to your house.", GetRPName(targetid));
	return 1;
}
CMD:givehousekeys(playerid, params[])
{
	new targetid, houseid = GetInsideHouse(playerid), option;
	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in your house");
	}
	if(sscanf(params, "di", targetid, option))
	{
		return SendClientMessage(playerid, COLOR_GREY, "Usage: /givehousekeys [playerid] [0/1]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	switch(option)
	{
		case 0:
		{
		    PlayerData[targetid][pHouseKeys] = -1;
		    SendClientMessageEx(playerid, COLOR_GREY, "You have taken %s's house keys", GetRPName(targetid));
		}
		case 1:
		{
			PlayerData[targetid][pHouseKeys] = houseid;
			SendClientMessageEx(playerid, COLOR_GREY, "You have given %s a copy of your house keys", GetRPName(targetid));
		}
	}
	return 1;
}
CMD:iha(playerid, params[])
{
	return callcmd::installhousealarm(playerid, params);
}
CMD:installhousealarm(playerid, params[])
{
	new houseid = GetInsideHouse(playerid);
	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(HouseInfo[houseid][hAlarm] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This house has an installed alarm system already");
	}
	if(PlayerData[playerid][pHouseAlarm] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a house alarm, you can buy one from a tool shop");
	}
	PlayerData[playerid][pHouseAlarm] = 0;
	HouseInfo[houseid][hAlarm] = 1;
	SendClientMessage(playerid, COLOR_YELLOW, "You've sucessfully installed your house alarm, now it's legal protected by the Police.");
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET alarm = %i WHERE id = %i", HouseInfo[houseid][hAlarm], HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET housealarm = %i WHERE uid = %i", PlayerData[playerid][pHouseAlarm], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:uha(playerid, params[])
{
	return callcmd::uninstallhousealarm(playerid, params);
}
CMD:uninstallhousealarm(playerid, params[])
{
	new houseid = GetInsideHouse(playerid);
	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
	}
	if(HouseInfo[houseid][hAlarm] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This house doesn't have an installed alarm system.");
	}

	PlayerData[playerid][pHouseAlarm] += 1;
	HouseInfo[houseid][hAlarm] = 0;
	SendClientMessage(playerid, COLOR_YELLOW, "You've sucessfully uninstalled your house alarm, now it's not anymore protected by the Police.");
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET alarm = %i WHERE id = %i", HouseInfo[houseid][hAlarm], HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET housealarm = %i WHERE uid = %i", PlayerData[playerid][pHouseAlarm], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:furniture(playerid, params[])
{
	new id = GetInsideHouse(playerid);
	if(id == -1)
	{
		id = GetFurnitureHouse(playerid);
	}
    if (!IsHouseOwner(playerid, id) && PlayerData[playerid][pFurniturePerms] != id)
	{
		return SendErrorMessage(playerid, "You don't have permissions to furnish this house.");
	}
    else
    {
        PlayerData[playerid][pHouse] = id;
	    Dialog_Show(playerid, HouseFurniture, DIALOG_STYLE_LIST, "{FFFFFF}Manage Furniture", "Purchase\nAdjustments", "Select", "Cancel");
	}
	return 1;
}

CMD:buyhouse(playerid, params[])
{
	new houseid, type[16];

	if((houseid = GetNearbyHouse(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no house in range. You must be near a house.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buyhouse [confirm]");
	}
	if(HouseInfo[houseid][hOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This house already has an owner.");
	}
	if(PlayerData[playerid][pCash] < HouseInfo[houseid][hPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this house.");
	}
	if(GetPlayerAssetCount(playerid, LIMIT_HOUSES) >= GetPlayerAssetLimit(playerid, LIMIT_HOUSES))
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i houses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
	}

	if(HouseInfo[houseid][hType]) {
	    type = "House";
	} else {
		strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
	}

	SetHouseOwner(houseid, playerid);
	GivePlayerCash(playerid, -HouseInfo[houseid][hPrice]);

	SendClientMessageEx(playerid, COLOR_GREEN, "You paid %s to make this house yours! /househelp for a list of commands.", FormatCash(HouseInfo[houseid][hPrice]));
	Log_Write("log_property", "%s (uid: %i) purchased %s (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], type, HouseInfo[houseid][hID], HouseInfo[houseid][hPrice]);
    AwardAchievement(playerid, ACH_HomeSweetHome);
	return 1;
}
CMD:hstorage(playerid, params[])
{
	return callcmd::stash(playerid, params);
}
CMD:stash(playerid, params[])
{
	new houseid;

	if((houseid = GetInsideHouse(playerid)) >= 0 && IsHouseOwner(playerid, houseid))
	{
	    new option[14], param[32];

		if(!HouseInfo[houseid][hLevel])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This house has no stash upgrade. '/upgradehouse level' to purchase one.");
	    }
		if(sscanf(params, "s[14]S()[32]", option, param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [balance | deposit | withdraw]");
	    }
	    if(PlayerData[playerid][pAdminDuty])
	    {
			return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
		}
	    if(!strcmp(option, "balance", true))
	    {
	        new count;

	        for(new i = 0; i < 10; i ++)
	        {
	            if(HouseInfo[houseid][hWeapons][i])
	            {
	                count++;
	            }
	        }

	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Stash Balance ______");
	        SendClientMessageEx(playerid, COLOR_GREY2, "Cash: $%i/$%i", HouseInfo[houseid][hCash], GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH));
			SendClientMessageEx(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", HouseInfo[houseid][hMaterials], GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS), count, GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS));
	        SendClientMessageEx(playerid, COLOR_GREY2, "Weed: %i/%i grams | Crack: %i/%i grams", HouseInfo[houseid][hWeed], GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED), HouseInfo[houseid][hCocaine], GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE));
	        SendClientMessageEx(playerid, COLOR_GREY2, "Heroin: %i/%i grams | Painkillers: %i/%i pills", HouseInfo[houseid][hHeroin], GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN), HouseInfo[houseid][hPainkillers], GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS));

			if(count > 0)
			{
				SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Stash Weapons ______");

            	for(new i = 0; i < 10; i ++)
	            {
    	            if(HouseInfo[houseid][hWeapons][i])
	    	        {
	        	        SendClientMessageEx(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]));
					}
				}
	        }
		}
		else if(!strcmp(option, "deposit", true))
	    {
	        new value;

	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [option]");
	            SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Cash, Materials, Weed, Crack, Heroin, Painkillers, Weapon");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [cash] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pCash])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH) < HouseInfo[houseid][hCash] + value)
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your stash can only hold up to %s at your house's level.", FormatCash(GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH)));
			    }

			    GivePlayerCash(playerid, -value);
			    HouseInfo[houseid][hCash] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %s in your house stash.", FormatCash(value));
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [materials] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pMaterials])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS) < HouseInfo[houseid][hMaterials] + value)
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your stash can only hold up to %i materials at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS));
			    }

			    PlayerData[playerid][pMaterials] -= value;
			    HouseInfo[houseid][hMaterials] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET materials = %i WHERE id = %i", HouseInfo[houseid][hMaterials], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %i materials in your house stash.", value);
   			}
			else if(!strcmp(option, "weed", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [weed] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pWeed])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED) < HouseInfo[houseid][hWeed] + value)
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your stash can only hold up to %i grams of weed at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED));
			    }

			    PlayerData[playerid][pWeed] -= value;
			    HouseInfo[houseid][hWeed] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET weed = %i WHERE id = %i", HouseInfo[houseid][hWeed], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of weed in your house stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [crack] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pCocaine])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE) < HouseInfo[houseid][hCocaine] + value)
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your stash can only hold up to %i grams of crack at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE));
			    }

			    PlayerData[playerid][pCocaine] -= value;
			    HouseInfo[houseid][hCocaine] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cocaine = %i WHERE id = %i", HouseInfo[houseid][hCocaine], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of crack in your house stash.", value);
   			}
   			else if(!strcmp(option, "heroin", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [heroin] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pHeroin])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN) < HouseInfo[houseid][hHeroin] + value)
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your stash can only hold up to %i grams of Heroin at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN));
			    }

			    PlayerData[playerid][pHeroin] -= value;
			    HouseInfo[houseid][hHeroin] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET heroin = %i WHERE id = %i", HouseInfo[houseid][hHeroin], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of Heroin in your house stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [painkillers] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS) < HouseInfo[houseid][hPainkillers] + value)
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your stash can only hold up to %i painkillers at your house's level.", GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS));
			    }

			    PlayerData[playerid][pPainkillers] -= value;
			    HouseInfo[houseid][hPainkillers] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET painkillers = %i WHERE id = %i", HouseInfo[houseid][hPainkillers], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %i painkillers in your house stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new weaponid;

   			    if(sscanf(param, "i", weaponid))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
				}
				if(!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You don't have that weapon. /guninv for a list of your weapons.");
				}
				if(IsLawEnforcement(playerid))
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Law enforcement is prohibited from storing weapons.");
				}
				if(GetPlayerHealthEx(playerid) < 60)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't store weapons as your health is below 60.");
				}

				for(new i = 0; i < GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS); i ++)
				{
					if(!HouseInfo[houseid][hWeapons][i])
   				    {
						HouseInfo[houseid][hWeapons][i] = weaponid;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET weapon_%i = %i WHERE id = %i", i + 1, HouseInfo[houseid][hWeapons][i], HouseInfo[houseid][hID]);
						mysql_tquery(connectionID, queryBuffer);

						RemovePlayerWeapon(playerid, weaponid);
						SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored a %s in slot %i of your house stash.", GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]), i + 1);
						return 1;
					}
				}

				SendClientMessage(playerid, COLOR_GREY, "Your house stash has no more slots available for weapons.");
			}
		}
		else if(!strcmp(option, "withdraw", true))
	    {
	        new value;

	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [option]");
	            SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Cash, Weed, Crack, Heroin, Painkillers, Weapon");

	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [cash] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hCash])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }

			    GivePlayerCash(playerid, value);
			    HouseInfo[houseid][hCash] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %s from your house stash.", FormatCash(value));
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [materials] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hMaterials])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    PlayerData[playerid][pMaterials] += value;
			    HouseInfo[houseid][hMaterials] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET materials = %i WHERE id = %i", HouseInfo[houseid][hMaterials], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %i materials from your house stash.", value);
   			}
			else if(!strcmp(option, "weed", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [weed] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hWeed])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pWeed] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
				}

			    PlayerData[playerid][pWeed] += value;
			    HouseInfo[houseid][hWeed] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET weed = %i WHERE id = %i", HouseInfo[houseid][hWeed], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of weed from your house stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [crack] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hCocaine])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pCocaine] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i crack. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				}

			    PlayerData[playerid][pCocaine] += value;
			    HouseInfo[houseid][hCocaine] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET cocaine = %i WHERE id = %i", HouseInfo[houseid][hCocaine], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of crack from your house stash.", value);
   			}
   			else if(!strcmp(option, "heroin", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [heroin] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hHeroin])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pHeroin] + value > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
				}

			    PlayerData[playerid][pHeroin] += value;
			    HouseInfo[houseid][hHeroin] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET heroin = %i WHERE id = %i", HouseInfo[houseid][hHeroin], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of Heroin from your house stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [painkillers] [amount]");
				}
				if(value < 1 || value > HouseInfo[houseid][hPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				}

			    PlayerData[playerid][pPainkillers] += value;
			    HouseInfo[houseid][hPainkillers] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET painkillers = %i WHERE id = %i", HouseInfo[houseid][hPainkillers], HouseInfo[houseid][hID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %i painkillers from your house stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new slots = GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS);

   			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /stash [withdraw] [weapon] [slot (1-%i)]", slots);
				}
				if(value < 1 || value > slots)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Invalid slot, or the slot specified is locked.");
   			    }
   			    if(!HouseInfo[houseid][hWeapons][value-1])
   			    {
   			        return SendClientMessage(playerid, COLOR_GREY, "The slot specified contains no weapon which you can take.");
				}
				if(PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
				}

				GivePlayerWeaponEx(playerid, HouseInfo[houseid][hWeapons][value-1]);
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken a %s from slot %i of your house stash.", GetWeaponNameEx(HouseInfo[houseid][hWeapons][value-1]), value);

				HouseInfo[houseid][hWeapons][value-1] = 0;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET weapon_%i = 0 WHERE id = %i", value, HouseInfo[houseid][hID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any stash which you can use.");
	}

	return 1;
}

//Admin commands:
CMD:createhouse(playerid, params[])
{
	new type, Float:x, Float:y, Float:z, Float:a;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", type))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /createhouse [type (1-%i)]", sizeof(houseInteriors));
	}
	if(!(1 <= type <= sizeof(houseInteriors)))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}
	if(GetNearbyHouse(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a house in range. Find somewhere else to create this one.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	type--;

	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(!HouseInfo[i][hExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO houses (type, price, pos_x, pos_y, pos_z, pos_a, int_x, int_y, int_z, int_a, interior, outsideint, outsidevw) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, %i)", type, houseInteriors[type][intPrice], x, y, z, a - 180.0,
				houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ], houseInteriors[type][intA], houseInteriors[type][intID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateHouse", "iiiffff", playerid, i, type, x, y, z, a);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "House slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:edithouse(playerid, params[])
{
	new houseid, option[10], param[32];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[10]S()[32]", houseid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Entrance, Exit, World, Type, Owner, Price, RentPrice, Level, Locked, Delivery");
	    return 1;
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
	}

	if(!strcmp(option, "entrance", true))
	{
	    GetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
	    GetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);

	    HouseInfo[houseid][hOutsideInt] = GetPlayerInterior(playerid);
	    HouseInfo[houseid][hOutsideVW] = GetPlayerVirtualWorld(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], HouseInfo[houseid][hPosA], HouseInfo[houseid][hOutsideInt], HouseInfo[houseid][hOutsideVW], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entrance of house %i.", houseid);
	}
	else if(!strcmp(option, "exit", true))
	{
	    new type = -1;

	    for(new i = 0; i < sizeof(houseInteriors); i ++)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 100.0, houseInteriors[i][intX], houseInteriors[i][intY], houseInteriors[i][intZ]))
	        {
	            type = i;
			}
	    }

	    GetPlayerPos(playerid, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ]);
	    GetPlayerFacingAngle(playerid, HouseInfo[houseid][hIntA]);

	    HouseInfo[houseid][hInterior] = GetPlayerInterior(playerid);
		HouseInfo[houseid][hType] = type;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", type, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the exit of house %i.", houseid);
	}
	else if(!strcmp(option, "world", true))
	{
	    new worldid;

	    if(sscanf(param, "i", worldid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [world] [vw]");
		}

		HouseInfo[houseid][hWorld] = worldid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET world = %i WHERE id = %i", HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the virtual world of house %i to %i.", houseid, worldid);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [type] [value (1-%i)]", sizeof(houseInteriors));
		}
		if(!(1 <= type <= sizeof(houseInteriors)))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

		type--;

		HouseInfo[houseid][hType] = type;
		HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
		HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
		HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
		HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
		HouseInfo[houseid][hIntA] = houseInteriors[type][intA];

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the type of house %i to %i.", houseid, type + 1);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [owner] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(!PlayerData[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
		}

        SetHouseOwner(houseid, targetid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of house %i to %s.", houseid, GetRPName(targetid));
	}
	else if(!strcmp(option, "price", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [price] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
		}

		HouseInfo[houseid][hPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET price = %i WHERE id = %i", HouseInfo[houseid][hPrice], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the price of house %i to $%i.", houseid, price);
	}
	else if(!strcmp(option, "rentprice", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [rentprice] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
		}

		HouseInfo[houseid][hRentPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET rentprice = %i WHERE id = %i", HouseInfo[houseid][hRentPrice], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the rent price of house %i to $%i.", houseid, price);
	}
	else if(!strcmp(option, "level", true))
	{
	    new level;

	    if(sscanf(param, "i", level))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [level] [value (0-5)]");
		}
		if(!(0 <= level <= 6))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 5.");
		}

		HouseInfo[houseid][hLevel] = level;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET level = %i WHERE id = %i", HouseInfo[houseid][hLevel], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the level of house %i to %i.", houseid, level);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [locked] [0/1]");
		}

		HouseInfo[houseid][hLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[houseid][hLocked], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of house %i to %i.", houseid, locked);
	}
	 else if(!strcmp(option, "delivery", true))
	{
	    new delivery;

	    if(sscanf(param, "i", delivery) || !(0 <= delivery <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [locked] [0/1]");
		}

		HouseInfo[houseid][hDelivery] = delivery;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET delivery = %i WHERE id = %i", HouseInfo[houseid][hDelivery], HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadHouse(houseid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the ability to be to delivered of house %i to %i.", houseid, delivery);
	}
 	return 1;
}


CMD:removehouse(playerid, params[])
{
	new houseid;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removehouse [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
	}

    RemoveAllFurniture(houseid);

	DestroyDynamic3DTextLabel(HouseInfo[houseid][hText]);
	DestroyDynamicPickup(HouseInfo[houseid][hPickup]);
//	DestroyDynamicMapIcon(HouseInfo[houseid][hMapIcon]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM houses WHERE id = %i", HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	HouseInfo[houseid][hExists] = 0;
	HouseInfo[houseid][hID] = 0;
	HouseInfo[houseid][hOwnerID] = 0;

 	Iter_Remove(House, houseid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed house id %i", GetPlayerNameEx(playerid), houseid);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed house %i.", houseid);
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	new houseid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotohouse [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
	SetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);
	SetPlayerInterior(playerid, HouseInfo[houseid][hOutsideInt]);
	SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hOutsideVW]);
	SetCameraBehindPlayer(playerid);
	return 1;
}
CMD:asellhouse(playerid, params[])
{
	new houseid;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellhouse [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
	}

	SetHouseOwner(houseid, INVALID_PLAYER_ID);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold house %i.", houseid);
	return 1;
}
CMD:removefurniture(playerid, params[])
{
	new houseid;

	if(PlayerData[playerid][pAdmin] < 5)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "[USAGE]{ffffff} /removefurniture [houseid]");
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_RED, "[ERROR]{ffffff} Invalid house.");
	}

	RemoveAllFurniture(houseid);
	SendClientMessageEx(playerid, COLOR_AQUA, "** You have removed all furniture for house %i.", houseid);
	return 1;
}

CMD:playerhouses(playerid,params[])
{
    
	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(params[0]==0)
	{
		return SendClientMessage(playerid, COLOR_GREY, "[USAGE]{ffffff} /playerhouses [playerid]");
	}
    DisplayPlayerHousesList(playerid,params);
	return 1;
}

CMD:ochangehouseowner(playerid, params[])
{
    new houseid, username[32];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[20]S()[32]", houseid, username))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ochangehouseowner [houseid] [username]");
	    return 1;
	}
	if(!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid house id.");
	}
	
    OfflineSetHouseOwner(playerid,houseid,username);    
    return 1;
}
CMD:edit(playerid, params[])
{
	new
		furniture;

	if (PlayerData[playerid][pHouseEdit] == -1 || !HouseInfo[PlayerData[playerid][pHouseEdit]][hEdit])
	{
	    return SendErrorMessage(playerid, "You are not editing furniture.");
	}
	else if (sscanf(params, "i", furniture))
	{
	    return SendSyntaxMessage(playerid, "/edit (furniture ID)");
	}
	else if (!IsValidFurnitureID(furniture))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
	}
	else if (Furniture[furniture][fHouseID] != HouseInfo[PlayerData[playerid][pHouseEdit]][hID])
	{
	    return SendErrorMessage(playerid, "The specified ID belongs to another house.");
	}
	else if (PlayerData[playerid][pEdit] == EDIT_TYPE_PREVIEW)
	{
	    return SendErrorMessage(playerid, "You can't edit furniture while previewing.");
	}
	else
	{
	    SetPVarInt(playerid, "FurnID", furniture);
	    Dialog_Show(playerid, FurnEditConfirm, DIALOG_STYLE_LIST, "Furniture Edit", "Edit Position\nEdit Texture\nDuplicate Object\nDelete Object", "Select", "Cancel");
		SendInfoMessage(playerid, "You are now editing ID: %i. Click the disk icon to save changes.", furniture);
	}
	return 1;
}

CMD:edittexture(playerid, params[])
{
	new
		furniture;

	if (PlayerData[playerid][pHouseEdit] == -1 || !HouseInfo[PlayerData[playerid][pHouseEdit]][hEdit])
	{
	    return SendErrorMessage(playerid, "You are not editing furniture.");
	}
	else if (sscanf(params, "i", furniture))
	{
	    return SendSyntaxMessage(playerid, "/edit (furniture ID)");
	}
	else if (!IsValidFurnitureID(furniture))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
	}
	else if (Furniture[furniture][fHouseID] != HouseInfo[PlayerData[playerid][pHouseEdit]][hID])
	{
	    return SendErrorMessage(playerid, "The specified ID belongs to another house.");
	}
	else if (PlayerData[playerid][pEdit] == EDIT_TYPE_PREVIEW)
	{
	    return SendErrorMessage(playerid, "You can't edit furniture while previewing.");
	}
	else
	{

		SendInfoMessage(playerid, "You are now editing ID: %i. Click the disk icon to save changes.", furniture);
	}
	return 1;
}

CMD:delete(playerid, params[])
{
	new
		furniture;

	if (PlayerData[playerid][pHouseEdit] == -1 || !HouseInfo[PlayerData[playerid][pHouseEdit]][hEdit])
	{
	    return SendErrorMessage(playerid, "You are not editing furniture.");
	}
	else if (sscanf(params, "i", furniture))
	{
	    return SendSyntaxMessage(playerid, "/delete (furniture ID)");
	}
	else if (!IsValidFurnitureID(furniture))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
	}
	else if (Furniture[furniture][fHouseID] != HouseInfo[PlayerData[playerid][pHouseEdit]][hID])
	{
	    return SendErrorMessage(playerid, "The specified ID belongs to another house.");
	}
	else
	{
		if (PlayerData[playerid][pEdit] == EDIT_TYPE_FURNITURE)
		{
			CancelObjectEdit(playerid);
		}
		DeleteFurniture(furniture);
		SendInfoMessage(playerid, "You are deleted furniture ID: %i.", furniture);
	}
	return 1;
}


CMD:cancel(playerid, params[])
{
	if (PlayerData[playerid][pHouseEdit] == -1 || !HouseInfo[PlayerData[playerid][pHouseEdit]][hEdit])
	{
	    return SendErrorMessage(playerid, "You are not editing furniture.");
	}
	else
	{
	    SetFurnitureEditMode(PlayerData[playerid][pHouseEdit], false);

	    PlayerData[playerid][pHouseEdit] = -1;
	    SendInfoMessage(playerid, "You are no longer editing furniture.");
	}
	return 1;
}

