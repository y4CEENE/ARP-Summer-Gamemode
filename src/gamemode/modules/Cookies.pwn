/// @file      Cookies.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-07-08 15:15:43 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerCookies[MAX_PLAYERS + 1];


GetPlayerCookies(playerid)
{
    return PlayerCookies[playerid];
}

SetPlayerCookies(playerid, amount)
{
    PlayerCookies[playerid] = amount;

    if (PlayerCookies[playerid] >= 5)
    {
        AwardAchievement(playerid, ACH_CookieJar);
    }

    DBQuery("UPDATE "#TABLE_USERS" SET cookies = %i WHERE uid = %i", PlayerCookies[playerid], PlayerData[playerid][pID]);

}

GivePlayerCookies(playerid, amount)
{
    PlayerCookies[playerid] += amount;

    if (PlayerCookies[playerid] >= 5)
    {
        AwardAchievement(playerid, ACH_CookieJar);
    }

    DBQuery("UPDATE "#TABLE_USERS" SET cookies = %i WHERE uid = %i", PlayerCookies[playerid], PlayerData[playerid][pID]);

}

hook OnPlayerInit(playerid)
{
    PlayerCookies[playerid] = 0;
    // BackPack Part
    PlayerData[playerid][pBackpack] = 0;
	PlayerData[playerid][bpWearing] = 0;
	PlayerData[playerid][bpCash] = 0;
	PlayerData[playerid][bpMaterials] = 0;
	PlayerData[playerid][bpWeed] = 0;
	PlayerData[playerid][bpCocaine] = 0;
	PlayerData[playerid][bpHeroin] = 0;
	PlayerData[playerid][bpPainkillers] = 0;
	PlayerData[playerid][bpWeapons] = 0;
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    PlayerCookies[playerid] = GetDBIntField(row, "cookies");
    // BackPack Part
    PlayerData[playerid][pBackpack] = GetDBIntField(row, "backpack");
    return 1;
}

CMD:usecookies(playerid, params[])
{
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are too hurt to use this command. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
    }

    new string[1536] = "Perk\tDescription\tCost", title[64];

    strcat(string, "\nReplenish\tReplenishes you with full health & armor.\t{00AA00}2 cookies{FFFFFF}");
    strcat(string, "\nJail Time\tReduce your IC jailtime by 50 percent.\t{00AA00}5 cookies{FFFFFF}");
    strcat(string, "\nRespect\tGives you 4 respect points.\t{F7A763}6 cookies{FFFFFF}");
    strcat(string, "\nMaterials\tGives you 20000 materials.\t{F7A763}10 cookies{FFFFFF}");
	strcat(string, "\nCustom Title\t15 Days Custom Title ( /report ).\t{F7A763}50 cookies{FFFFFF}");
	strcat(string, "\nGold VIP\t10 days Limited VIP subscription\t{F7A763}100 cookies{FFFFFF}");
    strcat(string, "\nBackPack\tGive you a Small BackPack.\t{FF0000}150 cookies{FFFFFF}");
    strcat(string, "\nRandom Vehicle\tGive You a Random Vehicle.\t{FF0000}300 cookies{FFFFFF}");

//    strcat(string, "\nShoutout\tBroadcast your message of choice globally.\t{F7A763}3 cookies{FFFFFF}");
//    strcat(string, "\nWeather\tOne time use: change weather globally.\t{F7A763}10 cookies{FFFFFF}");
//    strcat(string, "\nNumber\tChoose a phone number of your choice.\t{00AA00}80 cookies{FFFFFF}");
//    strcat(string, "\nJob\tChoose a job to 1x level up.\t{F7A763}100 cookies{FFFFFF}");
//    strcat(string, "\nDouble XP\tAwards you with 8 hours of double XP.\t{00AA00}150 cookies{FFFFFF}");
//    strcat(string, "\nVehicle\tFree vehicle ticket under $200k value.\t{00AA00}300 cookies{FFFFFF}");
//    strcat(string, "\nHouse\tFree house ticket under $250k value.\t{00AA00}350 cookies{FFFFFF}");
//    strcat(string, "\nBusiness\tFree business ticket of any type.\t{00AA00}600 cookies{FFFFFF}");

    format(title, sizeof(title), "Cookie rewards (You have %i cookies.)", GetPlayerCookies(playerid));
    Dialog_Show(playerid, UseCookies, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Redeem", "Cancel");

    return 1;
}

#define MAX_RANDOM_VEHICLES 10

new const RandomVehicles[MAX_RANDOM_VEHICLES] = {
    411,  // Infernus
    415,  // Cheetah
    451,  // Turismo
    521,  // FCR-900
    560,  // Sultan
    562,  // Elegy
    489,  // Rancher
    541,  // Bullet
    534,  // Remington
    510   // Mountain Bike
};

Dialog:UseCookies(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    switch (listitem)
	{
		case 0:
		{
			if (GetPlayerCookies(playerid) < 2)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}

			PlayerData[playerid][pHealth] = 150;
			PlayerData[playerid][pArmor] = 150;
			SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
			SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);

			GivePlayerCookies(playerid, -2);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 2 cookies and received full health & armor.");
		}
		case 1:
		{
			if (GetPlayerCookies(playerid) < 5)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}

			if (PlayerData[playerid][pJailType] == JailType_None)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You are not in prison");
			}

			if (PlayerData[playerid][pJailType] != JailType_OOCPrison)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't apply jail time reduction in admin prison");
			}

			if (PlayerData[playerid][pJailTime] < 60)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't apply jail time reduction for time less then 1 minute");
			}

			PlayerData[playerid][pJailTime] = PlayerData[playerid][pJailTime] / 2;
			GivePlayerCookies(playerid, -5);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 5 cookies and received a reduction on your IC jailtime by 50 percent.");
		}
		case 2:
		{
			if (GetPlayerCookies(playerid) < 6)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}

			PlayerData[playerid][pEXP] += 4;
			DBQuery("UPDATE "#TABLE_USERS" SET exp = %i WHERE uid = %i", PlayerData[playerid][pEXP], PlayerData[playerid][pID]);

			GivePlayerCookies(playerid, -6);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 6 cookies and received 4 respect points.");
		}
		case 3:
		{
			if (GetPlayerCookies(playerid) < 10)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}

			PlayerData[playerid][pMaterials] += 20000;
			DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);

			GivePlayerCookies(playerid, -10);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 10 cookies and received 20000 materials.");
		}
		case 4:
		{
			if (GetPlayerCookies(playerid) < 50)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}

			GivePlayerCookies(playerid, -50);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 50 cookies and received 15 days Custem Title.");
		}
		case 5:
		{
			if (GetPlayerCookies(playerid) < 100)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}

			new rank=2, days = 10;
			GivePlayerVIP(playerid, rank, days);
			DBQuery("UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerData[playerid][pDonator], PlayerData[playerid][pVIPTime], PlayerData[playerid][pID]);

			GivePlayerCookies(playerid, -100);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 050 cookies and received 10 days Limited Gold VIP subscription.");
		}
		case 6:
		{
			if (GetPlayerCookies(playerid) < 150)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}
			PlayerData[playerid][pBackpack] = 1;

			GivePlayerCookies(playerid, -150);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 150 cookies and received a Small BackPack.");
		}
		case 7:
		{
			if (GetPlayerCookies(playerid) < 300)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}
			new randomIndex = random(sizeof(RandomVehicles));
			new Model = RandomVehicles[randomIndex];

			GivePlayerVehicle(playerid, Model); // Pass a single vehicle model
			GivePlayerCookies(playerid, -300);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 300 cookies and received a Random Vehicle.");
		}
	}

    return 1;
}

CMD:givecookie(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /givecookie [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (PlayerCookies[targetid] > 500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player already has 500 cookies!");
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {089DCE}cookie{FF6347} to %s, reason: %s", GetRPName(playerid), GetRPName(targetid), reason);
    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been awarded a {089DCE}cookie{FF6347} by %s for %s", GetRPName(playerid), reason);
    GivePlayerCookies(targetid, 1);
    DBLog("log_givecookie", "%s (uid: %i) has given a cookie to %s (uid: %i) for reason %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason);
    return 1;
}

CMD:givecookies(playerid, params[])
{
    new targetid, amount, reason[128];

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "uds[128]", targetid, amount, reason))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /givecookie [playerid] [amount] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (PlayerCookies[targetid] + amount > 500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player already have to much cookies!");
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %d {089DCE}cookie{FF6347} to %s, reason: %s", GetRPName(playerid), amount, GetRPName(targetid), reason);
    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been awarded %d {089DCE}cookie{FF6347} by %s for %s", amount, GetRPName(playerid), reason);
    GivePlayerCookies(targetid, amount);
    DBLog("log_givecookie", "%s (uid: %i) has given %d cookie to %s (uid: %i) for reason %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason);
    return 1;
}

CMD:givecookiesall(playerid, params[])
{
    new amount;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givecookiesall [amount]");
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged])
        {

            if (GetPlayerCookies(i) + amount > 500)
            {
                if (GetPlayerCookies(i) < 500)
                {
                    SetPlayerCookies(i, 500);
                }
                continue;
            }
            GivePlayerCookies(i, amount);
        }
    }

    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has given %d {089DCE}cookie{FF6347} to every player online.", GetRPName(playerid), amount);
    DBLog("log_givecookie", "%s (uid: %i) has given %d cookie to every player online", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);

    return 1;
}

CMD:givecookieall(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged])
        {

            if (GetPlayerCookies(i) > 500)
            {
                continue;
            }
            GivePlayerCookies(i, 1);
        }
    }

    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has given a {089DCE}cookie{FF6347} to every player online.", GetRPName(playerid));
    DBLog("log_givecookie", "%s (uid: %i) has given a cookie to every player online", GetPlayerNameEx(playerid), PlayerData[playerid][pID]);

    return 1;
}

// BackPack Part

ResetBackpack(playerid)
{
	if(PlayerData[playerid][pLogged] && !PlayerData[playerid][pAdminDuty])
	{
		PlayerData[playerid][pBackpack] = 0;
		PlayerData[playerid][bpCash] = 0;
		PlayerData[playerid][bpMaterials] = 0;
		PlayerData[playerid][bpWeed] = 0;
		PlayerData[playerid][bpCocaine] = 0;
		PlayerData[playerid][bpHeroin] = 0;
		PlayerData[playerid][bpPainkillers] = 0;
		PlayerData[playerid][bpWeapons][0] = 0;
		PlayerData[playerid][bpWeapons][1] = 0;
		PlayerData[playerid][bpWeapons][2] = 0;
		PlayerData[playerid][bpWeapons][3] = 0;
		PlayerData[playerid][bpWeapons][4] = 0;
		PlayerData[playerid][bpWeapons][5] = 0;
		PlayerData[playerid][bpWeapons][6] = 0;
		PlayerData[playerid][bpWeapons][7] = 0;
		PlayerData[playerid][bpWeapons][8] = 0;
		PlayerData[playerid][bpWeapons][9] = 0;
		PlayerData[playerid][bpWeapons][10] = 0;
		PlayerData[playerid][bpWeapons][11] = 0;
		PlayerData[playerid][bpWeapons][13] = 0;
		PlayerData[playerid][bpWeapons][14] = 0;
	}
	SavePlayerVariables(playerid);
}

GetBackpackCapacity(playerid, item)
{
	static const stashCapacities[][] = {
		// Cash   Mats    W     C    M    P   HP   PT   FMJ  WEP
	    {30000,   5000,   25,   25,  10,  5,  80,  60,  50,  4}, // Small
	    {55000,   10000,  50,   50,  25,  10, 100, 80,  60,  8}, // Medium
	    {120000,  25000,  100,  75,  50,  20, 125, 100, 70,  12} // Large
	};

	if(PlayerData[playerid][pBackpack] > 0)
	{
		return stashCapacities[PlayerData[playerid][pBackpack] - 1][item];
	}

	return 0;
}

CMD:givebackpack(playerid, params[])
{
	new targetid, size[10];
	if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDeveloper])
    {
        return SendUnauthorized(playerid);
    }
	if(sscanf(params, "us[14]S()[32]", targetid, size))
	{
	    SCM(playerid, COLOR_SYNTAX, "Usage: /givebackpack [playerid] [size]");
	    SCM(playerid, COLOR_WHITE, "Sizes:   Small, Medium, Large");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!strcmp(size, "small", true))
	{
		PlayerData[targetid][pBackpack] = 1;
	    SM(targetid, COLOR_WHITE, "** %s has given you a small backpack.", GetRPName(playerid));
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a small backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	if(!strcmp(size, "medium", true))
	{
		PlayerData[targetid][pBackpack] = 2;
	    SM(targetid, COLOR_WHITE, "** %s has given you a medium backpack.", GetRPName(playerid));
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a medium backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	if(!strcmp(size, "large", true))
	{
		PlayerData[targetid][pBackpack] = 3;
	    SM(targetid, COLOR_WHITE, "** %s has given you a large backpack.", GetRPName(playerid));
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a large backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	return 1;
}

GetHealth(playerid)
{
	new Float:health;
	GetPlayerHealth(playerid, health);
	return floatround(health);
}

GiveWeapon(playerid, weaponid, bool:temp = false)
{
    if(PlayerData[playerid][pWeaponRestricted]) return 1;
	if(1 <= weaponid <= 46)
	{
	    if(temp)
		{
			PlayerData[playerid][pTempWeapons][GetWeaponSlot(weaponid)] = weaponid;
			GivePlayerWeapon(playerid, weaponid, 500);
	    }
		else
		{
			PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] = weaponid;
			SetPlayerWeapons(playerid);
		}

		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    SetPlayerArmedWeapon(playerid, 0);
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			switch(weaponid)
			{
		    	case 22, 25, 28, 29, 30, 31, 32:
		    	{
		    	    SetPlayerArmedWeapon(playerid, weaponid);
			    }
			    default:
			    {
		    	    SetPlayerArmedWeapon(playerid, 0);
				}
			}
		}
		else
		{
		    SetPlayerArmedWeapon(playerid, weaponid);
		}

		SavePlayerWeapons(playerid);

		PlayerData[playerid][pACTime] = gettime() + 2;
	}
	return 1;
}

CMD:bp(playerid, params[]) { return callcmd::backpack(playerid, params); }
CMD:backpack(playerid, params[])
{
    if(PlayerData[playerid][pBackpack] != 0)
    {
		new option[14], param[32];
	 	if(sscanf(params, "s[14]S()[32]", option, param))
		{
	 		return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [wear | balance | deposit | withdraw]");
	 	}
		if(!strcmp(option, "wear", true))
		{
		    if(PlayerData[playerid][pPaintball] || IsPlayerInEvent(playerid))
			    {
		        return SCM(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
			}
		    if(!PlayerData[playerid][bpWearing])
		    {
		        if(PlayerData[playerid][pBackpack] == 1)
		    	{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s wears his small backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				else if(PlayerData[playerid][pBackpack] == 2)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s wears his medium backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				else if(PlayerData[playerid][pBackpack] == 3)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s wears his large backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
				}
    			PlayerData[playerid][bpWearing] = 1;
			}
			else
			{
		        if(PlayerData[playerid][pBackpack] == 1)
		    	{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s takes off his small backpack from his back.", GetRPName(playerid));
					PlayerData[playerid][bpWearing] = 0;
				}
				else if(PlayerData[playerid][pBackpack] == 2)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s takes off his medium backpack from his back.", GetRPName(playerid));
					PlayerData[playerid][bpWearing] = 0;
				}
				else if(PlayerData[playerid][pBackpack] == 3)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s takes off his large backpack from his back.", GetRPName(playerid));
					PlayerData[playerid][bpWearing] = 0;
				}
				RemovePlayerAttachedObject(playerid, 1);
				return 1;
			}
		}
		if(PlayerData[playerid][bpWearing])
		{
			if(!strcmp(option, "balance", true))
		 	{
    			new count;

				for(new i = 0; i < 15; i ++)
    			{
		        	if(PlayerData[playerid][bpWeapons][i])
          			{
            			count++;
          			}
       			}
				SCM(playerid, COLOR_GREY, "Backpack Balance:");
    			SM(playerid, COLOR_GREY2, "(Cash: $%i/$%i)", PlayerData[playerid][bpCash], GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
				SM(playerid, COLOR_GREY2, "(Materials: %i/%i) | (Weapons: %i/%i)", PlayerData[playerid][bpMaterials], GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS), count, GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS));
		        SM(playerid, COLOR_GREY2, "(Weed: %i/%i grams) | (Cocaine: %i/%i grams)", PlayerData[playerid][bpWeed], GetBackpackCapacity(playerid, STASH_CAPACITY_WEED), PlayerData[playerid][bpCocaine], GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
		        SM(playerid, COLOR_GREY2, "(Heroin: %i/%i grams) | (Painkillers: %i/%i pills)", PlayerData[playerid][bpHeroin], GetBackpackCapacity(playerid, STASH_CAPACITY_HEROIN), PlayerData[playerid][bpPainkillers], GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS));
				return 1;
			}
			else if(!strcmp(option, "deposit", true))
		 	{
				new value;

				if(sscanf(param, "s[14]S()[32]", option, param))
		  		{
		    		SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [option]");
		      		SCM(playerid, COLOR_WHITE, "Available options: Cash, Materials, Weed, Cocaine, Heroin, Painkillers, Weapon");
			        return 1;
		    	}
			    if(!strcmp(option, "cash", true))
				{
		  			if(sscanf(param, "i", value))
					{
						return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [cash] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pCash])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpCash] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_CASH))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to $%i at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
				    }

				    GivePlayerCash(playerid, -value);
				    PlayerData[playerid][bpCash] += value;

				    SM(playerid, COLOR_AQUA, "** You have stored $%i in your backpack.", value);
				}
				else if(!strcmp(option, "materials", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [materials] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pMaterials])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpMaterials] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i materials at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS));
				    }

				    PlayerData[playerid][pMaterials] -= value;
				    PlayerData[playerid][bpMaterials] += value;

				    DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have stored %i materials in your backpack.", value);
	   			}
				else if(!strcmp(option, "weed", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [weed] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pWeed])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpWeed] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_WEED))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of weed at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_WEED));
				    }

				    PlayerData[playerid][pWeed] -= value;
				    PlayerData[playerid][bpWeed] += value;

				    DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have stored %ig of weed in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "cocaine", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [cocaine] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pCocaine])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpCocaine] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of cocaine at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
				    }

				    PlayerData[playerid][pCocaine] -= value;
				    PlayerData[playerid][bpCocaine] += value;

				    DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have stored %ig of cocaine in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "heroin", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [heroin] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pHeroin])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpHeroin] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_HEROIN))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of heroin at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_HEROIN));
				    }

				    PlayerData[playerid][pHeroin] -= value;
				    PlayerData[playerid][bpHeroin] += value;

				    DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have stored %ig of heroin in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "painkillers", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [painkillers] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pPainkillers])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpPainkillers] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i painkillers at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS));
				    }

				    PlayerData[playerid][pPainkillers] -= value;
				    PlayerData[playerid][bpPainkillers] += value;

				    DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have stored %i painkillers in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "weapon", true))
	   			{
	   			    new weaponid;

	   			    if(sscanf(param, "i", weaponid))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
					}
					if(!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
					{
					    return SCM(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
					}
					if(GetHealth(playerid) < 60)
					{
					    return SCM(playerid, COLOR_SYNTAX, "You can't store weapons as your health is below 60.");
					}
					for(new i = 0; i < GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS); i ++)
					{
						if(!PlayerData[playerid][bpWeapons][i])
	   				    {
							PlayerData[playerid][bpWeapons][i] = weaponid;

							RemovePlayerWeapon(playerid, weaponid);
							SM(playerid, COLOR_AQUA, "** You have stored a %s in slot %i of your backpack.", GetWeaponNameEx(PlayerData[playerid][bpWeapons][i]), i + 1);
							return 1;
						}
					}

					SCM(playerid, COLOR_SYNTAX, "This backpack has no more slots available for weapons.");
				}
			}
	        else if(!strcmp(option, "withdraw", true))
		    {
		        new value;

		        if(sscanf(param, "s[14]S()[32]", option, param))
		        {
		            SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [option]");
		            SCM(playerid, COLOR_WHITE, "Available options: Cash, Weed, Cocaine, Heroin, Painkillers, Weapon");
		            return 1;
		        }
		        if(!strcmp(option, "cash", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [cash] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpCash])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }

				    GivePlayerCash(playerid, value);
				    PlayerData[playerid][bpCash] -= value;

				    SM(playerid, COLOR_AQUA, "** You have taken $%i from your backpack.", value);
				}
				else if(!strcmp(option, "materials", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [materials] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpMaterials])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if (PlayerData[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
                    }

				    PlayerData[playerid][pMaterials] += value;
				    PlayerData[playerid][bpMaterials] -= value;

				    DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have taken %i materials from your backpack.", value);
	   			}
				else if(!strcmp(option, "weed", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [weed] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpWeed])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][pWeed] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
					}

				    PlayerData[playerid][pWeed] += value;
				    PlayerData[playerid][bpWeed] -= value;

				    DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have taken %ig of weed from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "cocaine", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [cocaine] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpCocaine])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][pCocaine] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
					}

				    PlayerData[playerid][pCocaine] += value;
				    PlayerData[playerid][bpCocaine] -= value;

				    DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have taken %ig of cocaine from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "heroin", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [heroin] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpHeroin])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpHeroin] + value > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
					}

				    PlayerData[playerid][pHeroin] += value;
				    PlayerData[playerid][bpHeroin] -= value;

				    DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have taken %ig of heroin from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "painkillers", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SCM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [painkillers] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpPainkillers])
					{
					    return SCM(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
					}

				    PlayerData[playerid][pPainkillers] += value;
				    PlayerData[playerid][bpPainkillers] -= value;

				    DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);

				    SM(playerid, COLOR_AQUA, "** You have taken %i painkillers from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "weapon", true))
	   			{
	   			    new slots = GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS);

	   			    if(sscanf(param, "i", value))
				    {
				        return SM(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [weapon] [slot (1-%i)]", slots);
					}
					if(!(1 <= value <= slots))
					{
					    return SCM(playerid, COLOR_SYNTAX, "Invalid slot, or the slot specified is locked.");
	   			    }
	   			    if(!PlayerData[playerid][bpWeapons][value-1])
	   			    {
	   			        return SCM(playerid, COLOR_SYNTAX, "The slot specified contains no weapon which you can take.");
					}

					GiveWeapon(playerid, PlayerData[playerid][bpWeapons][value-1]);
					SM(playerid, COLOR_AQUA, "** You have taken a %s from slot %i of your backpack.", GetWeaponNameEx(PlayerData[playerid][bpWeapons][value-1]), value);

					PlayerData[playerid][bpWeapons][value-1] = 0;
				}
			}
		}
		else
		{
	 		return SCM(playerid, COLOR_SYNTAX, "You must be wearing your backpack to use these commands.");
	 	}
	}
	else
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not in possession of a backpack.");
	}
	return 1;
}