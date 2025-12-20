
CMD:listbugs(playerid, params[])
{
	if(GetPlayerFaction(playerid) != FACTION_FEDERAL)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a federal agent.");
	    return 1;
	}
	
	SendClientMessage(playerid, COLOR_GREEN, "Online Bugged players:");
	foreach(new i : Player)
	{
		if(PlayerData[i][pBugged])
		{
		    //SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Placed by: %s - Location: %s", GetRPName(i), PlayerData[i][pBuggedBy], GetPlayerZoneName(i));
			SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Placed by: %s", GetRPName(i), PlayerData[i][pBuggedBy]);
		}
	}
	return 1;
}

CMD:olistbugs(playerid, params[])
{
	if(GetPlayerFaction(playerid) != FACTION_FEDERAL)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a federal agent.");
	    return 1;
	}
	
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username,buggedby FROM "#TABLE_USERS" WHERE bugged = 1");
    mysql_tquery(connectionID, queryBuffer, "OnPlayerSelectAllBugged", "i", playerid);
	return 1;
}
forward OnPlayerSelectAllBugged(playerid);
public OnPlayerSelectAllBugged(playerid)
{
	new rows = cache_get_row_count(connectionID);
	new username[MAX_PLAYER_NAME],
		buggedby[MAX_PLAYER_NAME];

	SendClientMessage(playerid, COLOR_GREEN, "All Bugged players:");

	for (new i = 0; i < rows; i ++)
	{
		cache_get_field_content(i, "username", username);
		cache_get_field_content(i, "buggedby", buggedby);
		SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Placed by: %s", username, buggedby);
	}
}
CMD:bug(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_FEDERAL)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not a federal agent.");
	}
	if(!PlayerData[playerid][pToggleBug])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Enable the bug channel first! (/tog bugged)");
	}
    new
		targetid;

    if(sscanf(params, "u", targetid))
	{
		SendClientMessage(playerid, COLOR_WHITE, "USAGE: /bug [playerid]");
	}
    if(PlayerData[targetid][pAdminDuty])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't place bugs on admins.");
	}
	if(PlayerData[targetid][pBugged] == 1)
	{
		PlayerData[targetid][pBugged] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bugged = 0, buggedby='' WHERE uid = %i", PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);	
	 	SendClientMessageEx(playerid, COLOR_GREY, "The bug on %s has been disabled.", GetRPName(targetid));
	}
	else if(IsPlayerNearPlayer(playerid, targetid, 4.0))
	{
		PlayerData[targetid][pBugged] = 1;
		strcpy(PlayerData[targetid][pBuggedBy], GetRPName(playerid),MAX_PLAYER_NAME);
    	SendClientMessageEx(playerid, COLOR_GREY ,"You have placed a bug on %s.",GetRPName(targetid));
		
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bugged = 1, buggedby='%s' WHERE uid = %i", PlayerData[targetid][pBuggedBy], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "You need to be closer to that person.");
		return 1;
	}
	
	return 1;
}
CMD:clearbugs (playerid, params[])
{
	if(GetPlayerFaction(playerid) != FACTION_FEDERAL)
	{
		return SendClientMessage(playerid, COLOR_GREY, "[!] You are not a federal agent.");
	}

	if(PlayerData[playerid][pFactionRank] < 4)
	{
		return SendClientMessage(playerid, COLOR_GREY, "[!] You are not a allowed to use this command.");
	}

	foreach(new i : Player)
	{
	    PlayerData[i][pBugged] = 0;
	}
	

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bugged = 0, buggedby=''");
	mysql_tquery(connectionID, queryBuffer);
	
	SendClientMessage(playerid, COLOR_GREY, "All bugs has been cleared.");
	
	return 1;
}
CMD:notoriety(playerid, params[])
{
	
    if(GetPlayerFaction(playerid) != FACTION_FEDERAL && !PlayerHasJob(playerid, JOB_LAWYER))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a lawyer or a federal agent.");
	}

	SendClientMessageEx(playerid, COLOR_BLUE, "Listing notorious suspects...");
	
	foreach(new i : Player)
	{
		if(PlayerData[i][pNotoriety] >= 4000)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "%s - Notoriety Level: %d", GetPlayerNameEx(i), PlayerData[i][pNotoriety]);
		}
	}
	
	return 1;
}

CMD:sweep(playerid, params[])
{
	
	if(PlayerData[playerid][pSweep] <= 0)
		return SendClientMessage(playerid, COLOR_GREY, "You don't have a bug sweep!");

	if(PlayerData[playerid][pSweepLeft] <= 0)
	{
		PlayerData[playerid][pSweep]--;
		PlayerData[playerid][pSweepLeft] = 3;
		return SendClientMessage(playerid, COLOR_GREY, "Your Bug Sweeper has ran out of batteries!");
	}

	new giveplayerid;

	if(sscanf(params, "u", giveplayerid)) 
		return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sweep [playerid/partofname]");



    if(!IsPlayerNearPlayer(playerid, giveplayerid, 4.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be close to the person.");
    }

	PlayerData[playerid][pSweepLeft]--;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET sweep = %i, sweepleft = %i WHERE uid = %i", PlayerData[playerid][pSweep], PlayerData[playerid][pSweepLeft], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	
	SendNearbyMessage(playerid, 30.0, COLOR_AQUA, "* %s sweeps a large wand around %s's body...", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));

	if(PlayerData[giveplayerid][pBugged] <= 0)
	{
		return SendNearbyMessage(playerid, 30.0, COLOR_GREEN, "Nothing happens.");
	}

	PlayerData[giveplayerid][pBugged] = 0;
	SendNearbyMessage(playerid, 30.0, COLOR_YELLOW, "* A small spark is seen as the bug on %s shorts out.", GetPlayerNameEx(giveplayerid));

	foreach(new i : Player)
	{
		if(GetPlayerFaction(i) == FACTION_FEDERAL)
		{
			SendClientMessageEx(i, 0x9ACD3200, "(bug) %s says [radio]: *static*", GetRPName(giveplayerid));
		}
	}
	return 1;
}