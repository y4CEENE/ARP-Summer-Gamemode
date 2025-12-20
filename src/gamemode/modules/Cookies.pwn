#include <YSI\y_hooks>

static PlayerCookies[MAX_PLAYERS + 1];


GetPlayerCookies(playerid)
{
    return PlayerCookies[playerid];
}

SetPlayerCookies(playerid, amount)
{
    PlayerCookies[playerid] = amount;

    if(PlayerCookies[playerid] >= 5)
    {
        AwardAchievement(playerid, ACH_CookieJar);
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cookies = %i WHERE uid = %i", PlayerCookies[playerid], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
}

GivePlayerCookies(playerid, amount)
{
    PlayerCookies[playerid] += amount;

    if(PlayerCookies[playerid] >= 5)
    {
        AwardAchievement(playerid, ACH_CookieJar);
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cookies = %i WHERE uid = %i", PlayerCookies[playerid], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
}

hook OnPlayerInit(playerid)
{
    PlayerCookies[playerid] = 0;
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    PlayerCookies[playerid] = cache_get_field_content_int(row, "cookies");
    return 1;
}

CMD:usecookies(playerid, params[])
{
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are too hurt to use this command. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}

	new string[1536] = "Perk\tDescription\tCost", title[64];

    strcat(string, "\nReplenish\tReplenishes you with full health & armor.\t{00AA00}10 cookies{FFFFFF}");
	strcat(string, "\nJail Time\tReduce your IC jailtime by 50 percent.\t{00AA00}5 cookies{FFFFFF}");
	strcat(string, "\nRespect\tGives you 4 respect points.\t{F7A763}6 cookies{FFFFFF}");
	strcat(string, "\nMaterials\tGives you 20000 materials.\t{F7A763}10 cookies{FFFFFF}");
	strcat(string, "\nGold VIP\t15 days Limited VIP subscription\t{F7A763}100 cookies{FFFFFF}");
	strcat(string, "\nLegendary VIP\t15 days Limited VIP subscription\t{F7A763}250 cookies{FFFFFF}");
    strcat(string, "\nRandom Vehicle\tGive You a Random Vehicle.\t{FF0000}250 cookies{FFFFFF}");

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
    switch(listitem)
    {
        case 0:
        {
            if(GetPlayerCookies(playerid) < 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
            }
            
            PlayerData[playerid][pHealth] = 150;
            PlayerData[playerid][pArmor] = 150;
            SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
            SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);

            GivePlayerCookies(playerid, -10);
            SendClientMessageEx(playerid, COLOR_AQUA, "You spent 10 cookies and received full health & armor.");
        }
        case 1:
        {
            if(GetPlayerCookies(playerid) < 5)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
            }

            if(PlayerData[playerid][pJailType] > 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You are not in prison");
            }

            if(PlayerData[playerid][pJailType] != 3)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't apply jail time reduction in admin prison");
            }

            if(PlayerData[playerid][pJailTime] < 60)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't apply jail time reduction for time less then 1 minute");
            }
            
            PlayerData[playerid][pJailTime] = PlayerData[playerid][pJailTime] / 2;
            GivePlayerCookies(playerid, -5);
            SendClientMessageEx(playerid, COLOR_AQUA, "You spent 5 cookies and received a reduction on your IC jailtime by 50 percent.");
        }
        case 2:
        {
            if(GetPlayerCookies(playerid) < 6)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
            }

            PlayerData[playerid][pEXP] += 4;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET exp = %i WHERE uid = %i", PlayerData[playerid][pEXP], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            GivePlayerCookies(playerid, -6);
            SendClientMessageEx(playerid, COLOR_AQUA, "You spent 6 cookies and received 4 respect points.");
        }
        case 3:
        {
            if(GetPlayerCookies(playerid) < 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
            }
            
            PlayerData[playerid][pMaterials] += 20000;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            GivePlayerCookies(playerid, -10);
            SendClientMessageEx(playerid, COLOR_AQUA, "You spent 10 cookies and received 20000 materials.");
        }
        case 4:
        {
            if(GetPlayerCookies(playerid) < 100)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
            }
            
            new days = 15;

            PlayerData[playerid][pDonator] = 2;
            PlayerData[playerid][pVIPTime] = gettime() + (days * 86400);
            PlayerData[playerid][pVIPCooldown] = 0;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", 
                PlayerData[playerid][pDonator], PlayerData[playerid][pVIPTime], PlayerData[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
            GivePlayerCookies(playerid, -100);
            SendClientMessageEx(playerid, COLOR_AQUA, "You spent 100 cookies and received 15 days Limited VIP subscription.");
        }
        case 5:
        {
            if(GetPlayerCookies(playerid) < 250)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
            }
            
            new days = 15;

	        PlayerData[playerid][pDonator] = 3;
	        PlayerData[playerid][pVIPTime] = gettime() + (days * 86400);
	        PlayerData[playerid][pVIPCooldown] = 0;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", 
                PlayerData[playerid][pDonator], PlayerData[playerid][pVIPTime], PlayerData[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
            GivePlayerCookies(playerid, -250);
            SendClientMessageEx(playerid, COLOR_AQUA, "You spent 500 cookies and received 15 days Limited VIP subscription.");
        }
        case 6:
		{
			if (GetPlayerCookies(playerid) < 250)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cookies");
			}
			new randomIndex = random(sizeof(RandomVehicles));
			new Model = RandomVehicles[randomIndex];

			GivePlayerVehicle(playerid, Model); // Pass a single vehicle model
			GivePlayerCookies(playerid, -250);
			SendClientMessageEx(playerid, COLOR_AQUA, "You spent 250 cookies and received a Random Vehicle.");
		}
    }    

    return 1;
}

CMD:givecookie(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /givecookie [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(PlayerCookies[targetid] > 500)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player already has 500 cookies!");
	}

 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {089DCE}cookie{FF6347} to %s, reason: %s", GetRPName(playerid), GetRPName(targetid), reason);
 	SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been awarded a {089DCE}cookie{FF6347} by %s for %s", GetRPName(playerid), reason);
    GivePlayerCookies(targetid, 1);
 	Log_Write("log_givecookie", "%s (uid: %i) has given a cookie to %s (uid: %i) for reason %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason);
	return 1;
}

CMD:givecookies(playerid, params[])
{
	new targetid, amount, reason[128];

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uds[128]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /givecookie [playerid] [amount] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(PlayerCookies[targetid] + amount > 500)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player already have to much cookies!");
	}

 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %d {089DCE}cookie{FF6347} to %s, reason: %s", GetRPName(playerid), amount, GetRPName(targetid), reason);
 	SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been awarded %d {089DCE}cookie{FF6347} by %s for %s", amount, GetRPName(playerid), reason);
    GivePlayerCookies(targetid, amount);
 	Log_Write("log_givecookie", "%s (uid: %i) has given %d cookie to %s (uid: %i) for reason %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason);
	return 1;
}

CMD:givecookiesall(playerid, params[])
{
	new amount;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givecookiesall [amount]");
	}

    foreach(new i : Player)
	{
	    if(PlayerData[i][pLogged])
		{
            
		    if(GetPlayerCookies(i) + amount > 500)
			{
                if(GetPlayerCookies(i) < 500)
                {
                    SetPlayerCookies(i, 500);
                }
				continue;
			}
            GivePlayerCookies(i, amount);
		}
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has given %d {089DCE}cookie{FF6347} to every player online.", GetRPName(playerid), amount);
	Log_Write("log_givecookie", "%s (uid: %i) has given %d cookie to every player online", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);

    return 1;
}

CMD:givecookieall(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	foreach(new i : Player)
	{
	    if(PlayerData[i][pLogged])
		{
            
		    if(GetPlayerCookies(i) > 500)
			{
				continue;
			}
            GivePlayerCookies(i, 1);
		}
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has given a {089DCE}cookie{FF6347} to every player online.", GetRPName(playerid));
	Log_Write("log_givecookie", "%s (uid: %i) has given a cookie to every player online", GetPlayerNameEx(playerid), PlayerData[playerid][pID]);

	return 1;
}
