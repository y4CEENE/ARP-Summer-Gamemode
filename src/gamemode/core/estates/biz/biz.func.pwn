
Dialog:DIALOG_BUSINESSMENU(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		new string[256];
		new title[50];				
		new id;
        new businessid = GetNearbyBusinessEx(playerid);// GetInsideBusiness(playerid);
        
        if(businessid == -1)
        {
			return 1;
        }

		switch(listitem){
			case 0: {
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
				format(string,sizeof(string), "Value \t%s \n Type \t%s \n Location \t%s \n Active \t%s \n Status \t%s\n", FormatCash(BusinessInfo[businessid][bPrice]), bizInteriors[BusinessInfo[businessid][bType]][intType], 
				GetZoneName(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]), (gettime() - BusinessInfo[businessid][bTimestamp] > 2592000) ? ("{FF6347}No{C8C8C8}") : ("Yes"), 
				(BusinessInfo[businessid][bLocked]) ? ("{FF0000}Closed{FFFFFF}") : ("{00FF00}Opened{FFFFFF}"));
				format(string,sizeof(string),"%s Vault \t%s \n Entry Fee \t%s \n Products \t%i \n Materials \t%i",string, FormatCash(BusinessInfo[businessid][bCash]), FormatCash(BusinessInfo[businessid][bEntryFee]), BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bMaterials]);
				Dialog_Show(playerid, DIALOG_BUSINESSMENU_I, DIALOG_STYLE_TABLIST, title, string, "Cancel", ""); 
			}
			case 1:{
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
				Dialog_Show(playerid, DIALOG_BIZ_NAME, DIALOG_STYLE_INPUT, title, "Enter new business name:", "Ok", "Cancel");
			}case 2:{
				Dialog_Show(playerid, DIALOG_BMESSAGE, DIALOG_STYLE_INPUT, "Business Menu - Change Message", "Enter new message below for your business.", "Confirm", "Return");	
			}case 3:{
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
				Dialog_Show(playerid, DIALOG_BIZ_FEE, DIALOG_STYLE_INPUT, title, "Enter new entry fee:", "Ok", "Cancel");
			}case 4:{
				if((id = GetNearbyBusinessEx(playerid)) >= 0 && IsBusinessOwner(playerid, id))
				{
					if(!BusinessInfo[id][bLocked])
					{
						BusinessInfo[id][bLocked] = 1;

						GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
						ShowActionBubble(playerid, "* %s locks their business door.", GetRPName(playerid));
					}
					else
					{
						BusinessInfo[id][bLocked] = 0;

						GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
						ShowActionBubble(playerid, "* %s unlocks their business door.", GetRPName(playerid));
					}

					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);
					mysql_tquery(connectionID, queryBuffer);
					return 1;
				}
			}
			case 5:
			{
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
				format(string, sizeof(string),"\n Vault: %s \nEnter the amount of money you want to deposit:" ,FormatCash(BusinessInfo[businessid][bCash]));
				Dialog_Show(playerid, DIALOG_BIZ_DEPOSIT, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
			}
			case 6:
			{
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
				format(string, sizeof(string),"\n Vault: %s \nEnter the amount of money you want to withdraw:" ,FormatCash(BusinessInfo[businessid][bCash]));
				Dialog_Show(playerid, DIALOG_BIZ_WITHDRAW, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
			}
			case 7:
			{
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
				format(string, sizeof(string),"\n Materials: %i \nEnter the amount of materials you want to deposit:" ,BusinessInfo[businessid][bMaterials]);
				Dialog_Show(playerid, DIALOG_BIZ_DEPOSIT_MATS, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
			}
			case 8:
			{
				format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
				format(string, sizeof(string),"\n Materials: %i \nEnter the amount of materials you want to withdraw:" ,BusinessInfo[businessid][bMaterials]);
				Dialog_Show(playerid, DIALOG_BIZ_WITHDRAW_MATS, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
			}
		
		}
	}
	return 1;
}	
Dialog:DIALOG_BMESSAGE(playerid, response, listitem, inputtext[])
{
	if(response) { 
		new businessid = GetInsideBusiness(playerid);
        if(businessid == -1)
        {
            return 1;
        }
		new string28[150];

		format(BusinessInfo[businessid][bMessage], 128, inputtext);
		format(string28,sizeof(string28), "You have set your business message to %s.", inputtext);
		SendClientMessage(playerid, COLOR_AQUA, string28);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET message = '%e' WHERE id = %i", BusinessInfo[businessid][bMessage], BusinessInfo[businessid][bID]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	}
    return 1;
}
Dialog:DIALOG_BUSINESSMENU_I(playerid, response, listitem, inputtext[])
{}
Dialog:DIALOG_BIZ_NAME(playerid, response, listitem, inputtext[])
{
	if(response){
        new businessid = GetInsideBusiness(playerid);
		if(businessid == -1){
			return SendClientMessage(playerid,COLOR_SYNTAX,"You can only use this command inside your business.");
		}
		if(5 <= strlen(inputtext) <= MAX_BUSINESSES_NAME)
		{			
			strcpy(BusinessInfo[businessid][bName], inputtext, MAX_BUSINESSES_NAME);
			//format(,"%s");
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET name = '%e' WHERE id = %i", inputtext, BusinessInfo[businessid][bID]);
			mysql_tquery(connectionID, queryBuffer);
			SendClientMessageEx(playerid,COLOR_SYNTAX,"Business Name of (%i) changed to: %s",BusinessInfo[businessid][bID],inputtext);
			ReloadBusiness(businessid);
		}else{
			SendClientMessage(playerid,COLOR_SYNTAX,"Unvalid Business Name length.");
		}
	}
	return 1;
}

Dialog:DIALOG_BIZ_FEE(playerid, response, listitem, inputtext[])
{
	if(response){
		callcmd::entryfee(playerid,inputtext);
	}
}

Dialog:DIALOG_BIZ_WITHDRAW(playerid, response, listitem, inputtext[]){
	if(response){
		callcmd::bwithdraw(playerid, inputtext);
	}
}
Dialog:DIALOG_BIZ_DEPOSIT(playerid, response, listitem, inputtext[]){
	if(response){
		callcmd::bdeposit(playerid, inputtext);
	}
}
Dialog:DIALOG_BIZ_WITHDRAW_MATS(playerid, response, listitem, inputtext[]){
	if(response){
		callcmd::bwithdrawmats(playerid, inputtext);
	}
}
Dialog:DIALOG_BIZ_DEPOSIT_MATS(playerid, response, listitem, inputtext[]){
	if(response){
		callcmd::bdepositmats(playerid, inputtext);
	}
}

Store:Menu_GunStore(playerid, response, itemid, modelid, price, amount, itemname[])
{
	if(!response) return 1;
	new businessid = GetInsideBusiness(playerid);
	if(businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_GUNSHOP)
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any gunstore.");
	if(PlayerData[playerid][pGunLicense] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You don't have a gun license, you may request that on our forums");
	}
	if(PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted])
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
	}
	if(PlayerData[playerid][pCash] < price)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to purchase %s.", FormatCash(price),itemname);
	}
	switch(itemid)
	{
		case 1:
		{
			if(PlayerHasWeapon(playerid, 22))
			{
				return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
			}
			GivePlayerWeaponEx(playerid, 22);
		}
		case 2:
		{
			if(PlayerHasWeapon(playerid, 25))
			{
				return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
			}
			GivePlayerWeaponEx(playerid, 25);
		}
		case 3:
		{
			if(PlayerHasWeapon(playerid, 33))
			{
				return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
			}
			GivePlayerWeaponEx(playerid, 33);
		}
		case 4:
		{
			SetScriptArmour(playerid, 50.0);
		}
		case 5:
		{
			SetScriptArmour(playerid, 75.0);
		}
	}
	
	if(PlayerData[playerid][pTraderUpgrade] > 0)
	{
		price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
		SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of %s to $%i.", PlayerData[playerid][pTraderUpgrade],itemname, price);
	}
	GivePlayerCash(playerid, -price);
    
                    
    if(BusinessInfo[businessid][bProducts] > 0)
    {
        BusinessInfo[businessid][bCash] += price;
        BusinessInfo[businessid][bProducts]--;
        
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
        mysql_tquery(connectionID, queryBuffer);
    }
	ShowActionBubble(playerid, "* %s paid $%i to the shopkeeper and received a %s.", GetRPName(playerid), price, itemname);
	SendClientMessageEx(playerid, COLOR_WHITE, "%s purchased.", itemname);
    
    if(itemid < 4)
    {
        AwardAchievement(playerid, ACH_IllegalWeapon);
    }
	return 1;
}
Store:Menu_ToolShop(playerid, response, itemid, modelid, price, amount, itemname[])
{
	if(!response) return 1;
	new businessid = GetInsideBusiness(playerid);
	if(businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_TOOLSHOP)
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any toolshop.");
	//First aid kit\t500 materials\nBody repair kit\t1000 materials\nPolice scanner\t2000 materials\nRimkit\t4000 materials
	if(PlayerData[playerid][pMaterials] < price)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't have %i materials to buy %s.",price,itemname);
	}
	switch(itemid)
	{
		case 1:
		{
			if(PlayerData[playerid][pFirstAid] + 1 > 20)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 20 first aid kits.");
			}

			PlayerData[playerid][pFirstAid]++;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
			SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /firstaid to in order to use a first aid kit.");
		}
		case 2:
		{
			if(PlayerData[playerid][pBodykits] + 1 > 10)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 10 bodywork kits.");
			}

			PlayerData[playerid][pBodykits]++;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			
			SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /bodykit in a vehicle to repair its bodywork and health.");
		}
		case 3:
		{
			if(PlayerData[playerid][pPoliceScanner])
			{
				return SendClientMessage(playerid, COLOR_GREY, "You already have this item.");
			}

			PlayerData[playerid][pPoliceScanner] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET policescanner = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /scanner to listen to emergency and department chats.");
		}
		case 4:
		{
			if(PlayerData[playerid][pRimkits] + 1 > 5)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 5 rimkits.");
			}

			PlayerData[playerid][pRimkits]++;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rimkits = %i WHERE uid = %i", PlayerData[playerid][pRimkits], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /rimkit in your vehicle to install a new set of rims.");
		}
		case 5:
		{
			if(PlayerData[playerid][pHelmet])
			{
				return SendClientMessage(playerid, COLOR_GREY, "You already have this item.");
			}
			PlayerData[playerid][pHelmet] = 1;
			
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET helmet = %d WHERE uid = %i", PlayerData[playerid][pHelmet], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			
			SendClientMessage(playerid, COLOR_GREEN, "Helmet purchased. /helmet to use it.");

		}
		case 6: //pCrowbar
		{
			if(PlayerData[playerid][pVehicleCMD] == 1)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 vehicle command.");
			}
			PlayerData[playerid][pCrowbar] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET crowbar = %i WHERE uid = %i", PlayerData[playerid][pRimkits], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "HINT: Use '/breakcuffs' to break cuffs from anybody's hand.");
		}
		case 7:
		{
			if(PlayerData[playerid][pHouseAlarm] > 1)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 house alarm.");
			}
			PlayerData[playerid][pHouseAlarm]++;
			
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET housealarm = %i WHERE uid = %i", PlayerData[playerid][pRimkits], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /usehousealarm in your house to install the alarm.");
		}
		/*case 8: //pVehicleCMD
		{
			if(PlayerData[playerid][pVehicleCMD] == 1)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 vehicle command.");
			}
			PlayerData[playerid][pVehicleCMD] = 1;
			
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vehiclecmd = %i WHERE uid = %i", PlayerData[playerid][pRimkits], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "HINT: Press '2' while you are driving an vehicle to activate.");
		}*/
	}
	PlayerData[playerid][pMaterials] -= price;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
               
    if(BusinessInfo[businessid][bProducts] > 0)
    {
        BusinessInfo[businessid][bMaterials] += price;
        BusinessInfo[businessid][bProducts]--;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET materials = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
        mysql_tquery(connectionID, queryBuffer);

    }

	ShowActionBubble(playerid, "* %s exchanged %i materials to the shopkeeper and received a %s.", GetRPName(playerid), price,itemname);
	return 1;
}
Store:Menu_Bar(playerid, response, itemid, modelid, price, amount, itemname[])
{
	if(!response) return 1;
	new businessid = GetInsideBusiness(playerid);
	if(businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_BARCLUB)
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any bar.");
	if(PlayerData[playerid][pCash] < price)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't have $%i to buy %s.", price, itemname);
	}
	switch(itemid)
	{
		case 1:
		{
			GivePlayerHealth(playerid, 10.0);
		}
		case 2:
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
		}
		case 3:
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
		}
		case 4:
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
		}
		case 5:
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
		}
	}
	
	if(PlayerData[playerid][pTraderUpgrade] > 0)
	{
		price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
		SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
	}

	GivePlayerCash(playerid, -price);

                   
    if(BusinessInfo[businessid][bProducts] > 0)
    {
        BusinessInfo[businessid][bCash] += price;
        BusinessInfo[businessid][bProducts]--;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
        mysql_tquery(connectionID, queryBuffer);
    }

	ShowActionBubble(playerid, "* %s paid $%i to the shopkeeper and received a %s.", GetRPName(playerid), price,itemname);
	return 1;
}
Store:Menu_Restaurant(playerid, response, itemid, modelid, price, amount, itemname[])
{
	if(!response) return 1;
	new businessid = GetInsideBusiness(playerid);
	if(businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_RESTAURANT)
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any restaurant.");
	if(PlayerData[playerid][pCash] < price)
		return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to purchase %s.", FormatCash(price),itemname);
	
    switch(itemid)
	{
		case 1:
		{			
			GivePlayerHealth(playerid, 10.0);			
		}
		case 2:
		{
			GivePlayerHealth(playerid, 15.0);
		}
		case 3:
		{
			GivePlayerHealth(playerid, 20.0);
		}
		case 4:
		{
			GivePlayerHealth(playerid, 20.0);
		}
		case 5:
		{
			GivePlayerHealth(playerid, 30.0);
		}
		case 6:
		{
			GivePlayerHealth(playerid, 30.0);
		}
		case 7:
		{
			GivePlayerHealth(playerid, 35.0);
		}
		case 8:
		{
			GivePlayerHealth(playerid, 45.0);
		}
		case 9:
		{
			GivePlayerHealth(playerid, 55.0);
		}
	}
	if(PlayerData[playerid][pTraderUpgrade] > 0)
	{
		price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
		SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
	}
	
	GivePlayerCash(playerid, -price);

    if(BusinessInfo[businessid][bProducts] > 0)
    {
	    BusinessInfo[businessid][bCash] += price;
	    BusinessInfo[businessid][bProducts]--;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);
    }


	ShowActionBubble(playerid, "* %s paid $%i to the shopkeeper and received %s.", GetRPName(playerid), price,itemname);
	return 1;
}

Store:Menu_Market(playerid, response, itemid, modelid, price, amount, itemname[])
{
	if(!response) return 1;
	new businessid = GetInsideBusiness(playerid);
	if(businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_STORE)
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any 24/7 store.");
	if(PlayerData[playerid][pCash] < price)
		return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to purchase %s.", FormatCash(price),itemname);
	switch(itemid)
	{
		case 1:
		{
			PlayerData[playerid][pPhone] = random(100000) + 899999;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerData[playerid][pPhone], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			SendClientMessageEx(playerid, COLOR_WHITE, "** Mobile phone purchased. Your new phone number is %i.", PlayerData[playerid][pPhone]);
		}
		case 2:
		{
			if(PlayerData[playerid][pPrivateRadio])
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a Portable Radio already.");
			}

			PlayerData[playerid][pPrivateRadio] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET walkietalkie = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "** Portable Radio purchased. Use /pr to speak and /setfreq to change the frequency.");
		}
		case 3:
		{
			if(PlayerData[playerid][pCigars] + amount > 20)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 cigars.");
			}

			PlayerData[playerid][pCigars] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cigars = %i WHERE uid = %i", PlayerData[playerid][pCigars], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "** %i cigars purchased. Use /usecigar to smoke a cigar.", amount);
		}
		case 4:
		{
			if(PlayerData[playerid][pSpraycans] + amount > 20)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 spraycans.");
			}

			PlayerData[playerid][pSpraycans] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "** %i spraycans purchased. Use /colorcar and /paintcar in a vehicle to use them.", amount);
		}
		case 5:
		{
			if(PlayerData[playerid][pPhonebook])
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a phonebook already.");
			}

			PlayerData[playerid][pPhonebook] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonebook = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "** Phonebook purchased. Use /phonebook to lookup a player's number.");
		}
		case 6:
		{
			GivePlayerWeaponEx(playerid, 43);

			SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s paid $%i to the shopkeeper and received a camera.", GetRPName(playerid), price);
			SendClientMessage(playerid, COLOR_WHITE, "** Camera purchased.");
		}
		case 7:
		{
			if(PlayerData[playerid][pMP3Player])
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have an MP3 player already.");
			}

			PlayerData[playerid][pMP3Player] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET mp3player = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "** MP3 player purchased. Use /mp3 for a list of options.");
		}
		case 8:
		{
			if(PlayerData[playerid][pFishingRod])
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a fishing rod already.");
			}

			PlayerData[playerid][pFishingRod] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingrod = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "** Fishing rod purchased. Use /fish at the pier or in a boat to begin fishing.");
		}
		case 9:
		{
			if(PlayerData[playerid][pFishingBait] + amount >= 20)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 pieces of bait.");
			}

			PlayerData[playerid][pFishingBait] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishingbait = %i WHERE uid = %i", PlayerData[playerid][pFishingBait], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "** %i fish baits purchased. Bait increases the odds of catching bigger fish.", amount);
		}
		case 10:
		{
			if(PlayerData[playerid][pMuriaticAcid] + amount > 10)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 bottles of muriatic acid.");
			}

			PlayerData[playerid][pMuriaticAcid] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET muriaticacid = %i WHERE uid = %i", PlayerData[playerid][pMuriaticAcid], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s paid $%i to the shopkeeper and received a bottle of muriatic acid.", GetRPName(playerid), price);
			SendClientMessageEx(playerid, COLOR_WHITE, "** %i muriatic acid bottles purchased.", amount);
		}
		case 11:
		{
			if(PlayerData[playerid][pBakingSoda] + amount > 10)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 bottles of baking soda.");
			}

			PlayerData[playerid][pBakingSoda] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bakingsoda = %i WHERE uid = %i", PlayerData[playerid][pBakingSoda], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "** %i baking soda bottles purchased.", amount);
		}
		case 12:
		{
			if(PlayerData[playerid][pWatch])
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a pocket watch already.");
			}

			PlayerData[playerid][pWatch] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET watch = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "** Pocket watch purchased. Use /watch to toggle it.");
		}
		case 13:
		{
			if(PlayerData[playerid][pGPS])
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a GPS already.");
			}

			PlayerData[playerid][pGPS] = 1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gps = 1 WHERE uid = %i", PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessage(playerid, COLOR_WHITE, "** GPS purchased. Use /gps to toggle it.");
		}
		case 14:
		{
			if(PlayerData[playerid][pGasCan] + amount > GetPlayerCapacity(playerid, CAPACITY_GAZCAN))
			{
				return SendClientMessageEx(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than %i liters of gas.", GetPlayerCapacity(playerid, CAPACITY_GAZCAN));
			}

			PlayerData[playerid][pGasCan] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gascan = %i WHERE uid = %i", PlayerData[playerid][pGasCan], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "** %i gas cans purchased. Use /gascan in a vehicle to refill its fuel.", amount);
		}
		case 15:
		{
			if(PlayerData[playerid][pRope] + amount > 10)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 ropes.");
			}

			PlayerData[playerid][pRope] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET rope = %i WHERE uid = %i", PlayerData[playerid][pRope], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s paid $%i to the shopkeeper and received 2 ropes.", GetRPName(playerid), price);
			SendClientMessageEx(playerid, COLOR_WHITE, "%i ropes purchased. Use /tie to tie people in your vehicle.", amount);
		}
		case 16:
		{
			if(PlayerData[playerid][pBlindfold] + amount > 10)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 blindfolds.");
			}

			PlayerData[playerid][pBlindfold] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET blindfold = %i WHERE uid = %i", PlayerData[playerid][pBlindfold], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "%i blindfolds purchased. Use /blindfold to blindfold people in your vehicle.", amount);
		}
		case 17:
		{
			if(PlayerData[playerid][pCondom] + amount > 20)
			{
				return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 condoms.");
			}

			PlayerData[playerid][pCondom] += amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET condom = %i WHERE uid = %i", PlayerData[playerid][pCondom], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_WHITE, "%i condom(s) purchased. Next time when you have sex you will not got STD.", amount);
		}
		
	}
	GivePlayerCash(playerid, -price);
    
    
    if(BusinessInfo[businessid][bProducts] > 0)
    {
        BusinessInfo[businessid][bCash] += price;
        BusinessInfo[businessid][bProducts]--;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i, products = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
        mysql_tquery(connectionID, queryBuffer);
    }

	return 1;
}
GetClosestBusiness(playerid, type)
{
	new
	    Float:distance[2] = {99999.0, 0.0},
	    index = -1;

    foreach(new i : Business)
	{
		if((BusinessInfo[i][bExists] && BusinessInfo[i][bType] == type) && (BusinessInfo[i][bOutsideInt] == 0 && BusinessInfo[i][bOutsideVW] == 0))
		{
			distance[1] = GetPlayerDistanceFromPoint(playerid, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]);

			if(distance[0] > distance[1])
			{
			    distance[0] = distance[1];
			    index = i;
			}
		}
	}

	return index;
}

GetNearbyBusinessEx(playerid)
{
	return GetNearbyBusiness(playerid) == -1 ? GetInsideBusiness(playerid) : GetNearbyBusiness(playerid);
}

GetNearbyBusiness(playerid, Float:radius = 2.0)
{
    foreach(new i : Business)
	{
	    if(BusinessInfo[i][bExists] && IsPlayerInRangeOfPoint(playerid, radius, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]) && GetPlayerInterior(playerid) == BusinessInfo[i][bOutsideInt] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bOutsideVW])
	    {
	        return i;
		}
	}

	return -1;
}

GetInsideBusiness(playerid)
{
 	foreach(new i : Business)
	{
	    if(BusinessInfo[i][bExists] && IsPlayerInRangeOfPoint(playerid, 100.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]) && GetPlayerInterior(playerid) == BusinessInfo[i][bInterior] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bWorld])
	    {
	        return i;
		}
	}

	return -1;
}


SetBusinessOwner(businessid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(BusinessInfo[businessid][bOwner], "Nobody", MAX_PLAYER_NAME);
	    BusinessInfo[businessid][bOwnerID] = 0;
	}
	else
	{
     	GetPlayerName(playerid, BusinessInfo[businessid][bOwner], MAX_PLAYER_NAME);
	    BusinessInfo[businessid][bOwnerID] = PlayerData[playerid][pID];
	}

	BusinessInfo[businessid][bTimestamp] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", BusinessInfo[businessid][bTimestamp], BusinessInfo[businessid][bOwnerID], BusinessInfo[businessid][bOwner], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBusiness(businessid);
}
OfflineSetBusinessOwner(aplayerid, businessid,username[])
{
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM "#TABLE_USERS" WHERE username = '%s'", username);
    mysql_tquery(connectionID, queryBuffer, "OnOChangeBizOwnerGotUsers", "ii",aplayerid,businessid);
}
forward OnOChangeBizOwnerGotUsers(playerid,businessid);
public OnOChangeBizOwnerGotUsers(playerid,businessid)
{
	new rows = cache_get_row_count(connectionID);
    if(rows)
    {
        cache_get_field_content(0, "username", BusinessInfo[businessid][bOwner], connectionID, MAX_PLAYER_NAME);
        
        BusinessInfo[businessid][bOwnerID] = cache_get_field_content_int(0, "uid");
        BusinessInfo[businessid][bTimestamp] = gettime();

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", BusinessInfo[businessid][bTimestamp], BusinessInfo[businessid][bOwnerID], BusinessInfo[businessid][bOwner], BusinessInfo[businessid][bID]);
        mysql_tquery(connectionID, queryBuffer);
        Log_Write("log_property", "%s (uid: %i) has edited business id owner to (id: %s).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], BusinessInfo[businessid][bOwner]);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of business %i to %s.", businessid, BusinessInfo[businessid][bOwner]);

        ReloadBusiness(businessid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Unvalid username.");
    }
}
/*
GetBusinessDefaultPickup(business)
{
	switch (BusinessInfo[business][bType]) {
		case BUSINESS_STORE: return 1274;
		case BUSINESS_CLOTHES: return 1275;
		case BUSINESS_RESTAURANT: return 19094;
		case BUSINESS_TOOLSHOP: return 1274;
		case BUSINESS_AGENCY: return 1274;
		case BUSINESS_BARCLUB:
		{
		    new rnd = random(4);
		    if (rnd == 0) return 1486;
		    if (rnd == 1) return 1543;
		    if (rnd == 2) return 1544;
		    if (rnd == 3) return 1951;
		}
		case BUSINESS_GYM: return 1318;
		default: return 1274;
	}
	return 1318;
}*/

ReloadBusiness(businessid)
{
	if(BusinessInfo[businessid][bExists])
	{
	    new
	        string[300];

		DestroyDynamic3DTextLabel(BusinessInfo[businessid][bText]);
		DestroyDynamicPickup(BusinessInfo[businessid][bPickup]);
        if(BusinessInfo[businessid][bMapIcon] != -1)
			DestroyDynamicMapIcon(BusinessInfo[businessid][bMapIcon]);

        if(BusinessInfo[businessid][bOwnerID] == 0)
        {
	        format(string, sizeof(string), "{AAC4E5}%s (ID %i)\n{FFFFFF}\nType: {AAC4E5}%s\n{FFFFFF}Entry Fee: $%i\nPrice: {FFFFFF}%s\n%s",BusinessInfo[businessid][bName], businessid, bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bEntryFee], FormatCash(BusinessInfo[businessid][bPrice]), (BusinessInfo[businessid][bLocked]) ? ("{FFFF00}Closed") : ("{00AA00}Opened"));
		}
		else
		{
		    format(string, sizeof(string), "{AAC4E5}%s (ID %i)\n{FFFFFF}Owner: %s\nType: {AAC4E5}%s\n{FFFFFF}Entry Fee: $%i\n%s", BusinessInfo[businessid][bName], businessid, BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bEntryFee], (BusinessInfo[businessid][bLocked]) ? ("{FFFF00}Closed") : ("{00AA00}Opened"));
		}

		BusinessInfo[businessid][bText] = CreateDynamic3DTextLabel(string, COLOR_GREY1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ] + 0.4, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, BusinessInfo[businessid][bOutsideVW], BusinessInfo[businessid][bOutsideInt], -1 , 10.0);
	    BusinessInfo[businessid][bPickup] = CreateDynamicPickup(1272, 1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt]);
	    //BusinessInfo[businessid][bPickup] = CreateDynamicPickup(GetBusinessDefaultPickup(businessid), 1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt]);
		
		if(BusinessInfo[businessid][bDisplayMapIcon]){ 			
			switch(BusinessInfo[businessid][bType])
			{
				case BUSINESS_DEALERSHIP: 		BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 55, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_STORE: 		BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 17, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_GUNSHOP: 		BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 6, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_CLOTHES: 		BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 45, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_RESTAURANT: 	BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 10, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_GYM: 			BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 54, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_AGENCY: 		BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 58, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_BARCLUB: 		BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 49, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
				case BUSINESS_TOOLSHOP:     BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 11, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
			}
		}
	}
}

IsBusinessOwner(playerid, businessid)
{
	return (BusinessInfo[businessid][bOwnerID] == PlayerData[playerid][pID]);
}


GenerateBusinessName(type)
{
	new string[MAX_BUSINESSES_NAME];
	switch(type)
	{
		case BUSINESS_STORE:{
			format(string,sizeof(string), "24/7");
		}
		case BUSINESS_GUNSHOP:{
			format(string ,sizeof(string), "Gunstore");
		}
		case BUSINESS_CLOTHES:{
			format(string ,sizeof(string), "Clothes Store");
		}
		case BUSINESS_GYM:{
			format(string ,sizeof(string), "Gym");
		}
		case BUSINESS_RESTAURANT:{
			format(string ,sizeof(string), "Restaurant");
		}
		case BUSINESS_AGENCY:{
			format(string ,sizeof(string), "AdStore");
		}
		case BUSINESS_BARCLUB:{
			format(string ,sizeof(string), "BarClub");
		}
		case BUSINESS_TOOLSHOP:{
			format(string ,sizeof(string), "ToolShop");
		}
		case BUSINESS_DEALERSHIP:{
			format(string ,sizeof(string), "Dealership");
		}
		default:{
			format(string ,sizeof(string), "N/A");
		}
	}
	return string;
}

forward OnAdminCreateBusiness(playerid, businessid, type, Float:x, Float:y, Float:z, Float:angle);
public OnAdminCreateBusiness(playerid, businessid, type, Float:x, Float:y, Float:z, Float:angle)
{
	strcpy(BusinessInfo[businessid][bOwner], "Nobody", MAX_PLAYER_NAME);

	BusinessInfo[businessid][bExists] = 1;
	BusinessInfo[businessid][bID] = cache_insert_id(connectionID);
	BusinessInfo[businessid][bOwnerID] = 0;
	BusinessInfo[businessid][bName] = GenerateBusinessName(type);
	//format(BusinessInfo[businessid][bMessage],sizeof(BusinessInfo[businessid][bMessage]),"Welcome, please use /buy to buy products!");
	BusinessInfo[businessid][bDealerShipType] = 0;
	BusinessInfo[businessid][bType] = type;
	BusinessInfo[businessid][bPrice] = bizInteriors[type][intPrice];
	BusinessInfo[businessid][bEntryFee] = 0;
	BusinessInfo[businessid][bLocked] = 0;
	BusinessInfo[businessid][bPosX] = x;
	BusinessInfo[businessid][bPosY] = y;
	BusinessInfo[businessid][bPosZ] = z;
	BusinessInfo[businessid][bPosA] = angle;
	BusinessInfo[businessid][bIntX] = bizInteriors[type][intX];
	BusinessInfo[businessid][bIntY] = bizInteriors[type][intY];
	BusinessInfo[businessid][bIntZ] = bizInteriors[type][intZ];
	BusinessInfo[businessid][bIntA] = bizInteriors[type][intA];
	BusinessInfo[businessid][bInterior] = bizInteriors[type][intID];
	BusinessInfo[businessid][bWorld] = BusinessInfo[businessid][bID] + 3000000;
	BusinessInfo[businessid][bOutsideInt] = GetPlayerInterior(playerid);
	BusinessInfo[businessid][bOutsideVW] = GetPlayerVirtualWorld(playerid);
	BusinessInfo[businessid][bCash] = 0;
	BusinessInfo[businessid][bProducts] = 500;
	BusinessInfo[businessid][bMaterials] = 0;
	BusinessInfo[businessid][bText] = Text3D:INVALID_3DTEXT_ID;
	BusinessInfo[businessid][bPickup] = -1;
	BusinessInfo[businessid][bMapIcon] = -1;
	BusinessInfo[businessid][bDisplayMapIcon] = 0;
	Iter_Add(Business, businessid);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET world = %i WHERE id = %i", BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBusiness(businessid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created a business id %i, type %i.",GetAdmCmdRank(playerid), GetRPName(playerid), businessid, BusinessInfo[businessid][bType]);
	SendClientMessageEx(playerid, COLOR_GREEN, "* Business %i created successfully.", businessid);
}
new PlayerText:BizMessageText[MAX_PLAYERS];

DisplayBizMessage(playerid,businessid)
{
	PlayerTextDrawSetString(playerid, BizMessageText[playerid], BusinessInfo[businessid][bMessage]); // <<< Update the text to show the vehicle health
    PlayerTextDrawShow(playerid, BizMessageText[playerid]);
	defer HideBizMessage(playerid);
}

timer HideBizMessage[10000](playerid)
{
	PlayerTextDrawHide(playerid,BizMessageText[playerid]);
}

InitBizMessage(playerid)
{
	
	BizMessageText[playerid] = CreatePlayerTextDraw(playerid, 131.599975, 340.100830, "Welcome,$_please_use_/buy_to_buy_products!");
	PlayerTextDrawLetterSize(playerid, BizMessageText[playerid], 0.208500, 0.974376);
	PlayerTextDrawAlignment(playerid, BizMessageText[playerid], 1);
	PlayerTextDrawColor(playerid, BizMessageText[playerid], -1);
	PlayerTextDrawSetShadow(playerid, BizMessageText[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BizMessageText[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, BizMessageText[playerid], 255);
	PlayerTextDrawFont(playerid, BizMessageText[playerid], 2);
	PlayerTextDrawSetProportional(playerid, BizMessageText[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BizMessageText[playerid], 0);


}