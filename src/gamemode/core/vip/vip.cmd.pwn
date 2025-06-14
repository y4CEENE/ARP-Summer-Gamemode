
CMD:v(playerid, params[])
{
	return callcmd::vip(playerid, params);
}

CMD:vip(playerid, params[])
{
	if(!PlayerData[playerid][pDonator] && PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(v)ip [vip chat]");
	}
    if(PlayerData[playerid][pToggleVIP])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the VIP chat as you have it toggled.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pDonator] > 0 && !PlayerData[i][pToggleVIP] && PlayerData[i][pAdmin] > JUNIOR_ADMIN)
	    {
			SendClientMessageEx(i, COLOR_VIP, "* %s VIP %s: %s *", GetVIPRank(PlayerData[playerid][pDonator]), GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:viplocker(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 2)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You need a donator package (Gold VIP+) to access this locker.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, 1988.5000, -1255.9500, 2690.8100))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the VIP Lounge.");
	}
 	if(PlayerData[playerid][pDonator] == 2)
	{
		Dialog_Show(playerid, DIALOG_BLACKMARKET1, DIALOG_STYLE_LIST, "Gold VIP Locker", "Deagle\nMp5", "Select", "Cancel");
	}
	else if(PlayerData[playerid][pDonator] == 3)
	{
		Dialog_Show(playerid, DIALOG_BLACKMARKET2, DIALOG_STYLE_LIST, "Legendary VIP Locker", "Katana\nDeagle\nMp5\nRifle\nAk47\nM4", "Select", "Cancel");
	}
	return 1;
}


CMD:vipcolor(playerid, params[])
{
    if(!PlayerData[playerid][pDonator])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
	}

	if(!PlayerData[playerid][pVIPColor])
	{
        PlayerData[playerid][pVIPColor] = 1;
	    SendClientMessage(playerid, COLOR_AQUA, "* You have enabled the VIP nametag color.");
	}
	else
	{
	    PlayerData[playerid][pVIPColor] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "* You have disabled the VIP nametag color.");
	}

	return 1;
}

CMD:vipinvite(playerid, params[])
{
	new targetid;

	if(!PlayerData[playerid][pDonator])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
	}
	if((PlayerData[playerid][pVIPTime] - gettime()) < 259200)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your VIP subscription expires in less than 3 days. You can't do this now.");
	}

	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vipinvite [playerid]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "This command grants a temporary VIP subscription which lasts one hour to a player of your choice.");

	    if(PlayerData[playerid][pVIPCooldown] > gettime()) {
			SendClientMessageEx(playerid, COLOR_SYNTAX, "You can only use this command once every 24 hours. You have %i hours left until you can use it again.", (PlayerData[playerid][pVIPCooldown] - gettime()) / 3600);
		} else {
		    SendClientMessage(playerid, COLOR_SYNTAX, "You can only use this command once every 24 hours. You currently have no cooldown for this command.");
		}

		return 1;
	}
	if(PlayerData[playerid][pVIPCooldown] > gettime())
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You have already used this command today. Please wait another %i hours.", (PlayerData[playerid][pVIPCooldown] - gettime()) / 3600);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(PlayerData[targetid][pDonator])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player already has a VIP subscription.");
	}

	PlayerData[targetid][pDonator] = PlayerData[playerid][pDonator];
	PlayerData[targetid][pVIPTime] = gettime() + 10800;
	PlayerData[playerid][pVIPCooldown] = gettime() + 86400;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i WHERE uid = %i", PlayerData[targetid][pDonator], PlayerData[targetid][pVIPTime], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vipcooldown = %i WHERE uid = %i", PlayerData[playerid][pVIPCooldown], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has given you a temporary three hour {D909D9}%s{33CCFF} VIP package.", GetRPName(playerid), GetVIPRank(PlayerData[targetid][pDonator]));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have given %s a temporary three hour {D909D9}%s{33CCFF} VIP package.", GetRPName(targetid), GetVIPRank(PlayerData[targetid][pDonator]));

	Log_Write("log_vip", "%s VIP %s (uid: %i) has given %s (uid: %i) a temporary three hour package.", GetVIPRank(PlayerData[playerid][pDonator]), GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	return 1;
}

CMD:vipinfo(playerid, params[])
{
	if(!PlayerData[playerid][pDonator])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
	}

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ VIP Package ______");
	SendClientMessageEx(playerid, COLOR_GREY2, "Your {D909D9}%s{C8C8C8} VIP subscription expires on %s.", GetVIPRank(PlayerData[playerid][pDonator]), TimestampToString(PlayerData[playerid][pVIPTime], 4));

	if(PlayerData[playerid][pVIPCooldown] > gettime())
	{
	    new time = PlayerData[playerid][pVIPCooldown] - gettime();

	    if(time > 3600) {
	        SendClientMessageEx(playerid, COLOR_GREY2, "You will be able to use the /vipinvite command again in %i hours.", time / 3600);
		} else {
			SendClientMessageEx(playerid, COLOR_GREY2, "You will be able to use the /vipinvite command again in %i minutes.", time / 60);
	    }
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "Your cooldown period for /vipinvite is over and you may use it again.");
	}

	return 1;
}

//	CMD:vipnumber(playerid, params[])
//	{
//		new number;
//	
//		if(!PlayerData[playerid][pDonator])
//		{
//			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
//		}
//		if(sscanf(params, "i", number))
//		{
//		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vipnumber [phone number]");
//		    SendClientMessage(playerid, COLOR_SYNTAX, "This command costs $10,000 and changes your phone number to your chosen one.");
//		    return 1;
//		}
//		if(PlayerData[playerid][pCash] < 10000)
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "You need at least $10,000 for pay for this.");
//		}
//		if(number == 0 || number == 911)
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
//		}
//	
//		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE phone = %i", number);
//		mysql_tquery(connectionID, queryBuffer, "OnPlayerBuyPhoneNumber", "ii", playerid, number);
//		return 1;
//	}
