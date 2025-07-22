
CMD:gbackup(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot call for backup when you are dead.");
	}
	if(PlayerData[playerid][pCuffed])
	{
 		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}
	if(PlayerData[playerid][pTied])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
	if(!PlayerData[playerid][pBackup])
	{
        PlayerData[playerid][pBackup] = 1;
	}
	else
	{
	    PlayerData[playerid][pBackup] = 0;
	}

	foreach(new i : Player)
	{
        if(PlayerData[i][pGang] == PlayerData[playerid][pGang])
        {
    	    if(PlayerData[playerid][pBackup])
    	    {
    	        SendClientMessageEx(i, COLOR_AQUA, "* %s %s is requesting backup in %s (marked on map). *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
    	        SetPlayerMarkerForPlayer(i, playerid, (GangInfo[PlayerData[playerid][pGang]][gColor] & ~0xff) + 0xFF);
			}
			else
			{
    	        SendClientMessageEx(i, COLOR_AQUA, "* %s %s has cancelled their backup request. *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
    	        SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
			}
		}
	}

	return 1;
}

CMD:gmembers(playerid, params[])
{
	if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
	}

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____________ Members Online _____________");
	new string[256], color = GangInfo[PlayerData[playerid][pGang]][gColor];
    foreach(new i : Player)
    {
        if(PlayerData[i][pGang] == PlayerData[playerid][pGang] && !PlayerData[i][pAdminHide])
        {
            format(string, sizeof(string), "(%i) %s {%06x}%s{FFFFFF}", PlayerData[i][pGangRank], GangRanks[PlayerData[i][pGang]][PlayerData[i][pGangRank]], color >>> 8, GetRPName(i));
            if(PlayerData[i][pCrew] >= 0)
			{
			    format(string, sizeof(string), "%s | Crew: %s", string, GangCrews[PlayerData[i][pGang]][PlayerData[i][pCrew]]);
			}
   			format(string, sizeof(string), "%s | Location: %s", string, GetPlayerZoneName(i));
			if(IsPlayerAFK(i))
            {
				format(string, sizeof(string), "%s | {FFA500}AFK{FFFFFF} (%d secs)", string, GetAFKTime(i));
			}
            format(string, sizeof(string), "%s | Points: %d", string, GetPlayerCommitRankPoints(i));
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
    }

    return 1;
}

CMD:ganglocker(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	new gangid, option[32];
	if(sscanf(params, "ds[32]", gangid, option)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ganglocker [gangid] [remove/place/goto]");
	if(!strcmp(option, "place", true))
    {
		GetPlayerPos(playerid, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ]);
		GangInfo[gangid][gStashInterior] = GetPlayerInterior(playerid);
		GangInfo[gangid][gStashWorld] = GetPlayerVirtualWorld(playerid);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET stash_x = '%f', stash_y = '%f', stash_z = '%f', stashinterior = %i, stashworld = %i WHERE id = %i", GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], GangInfo[gangid][gStashInterior], GangInfo[gangid][gStashWorld], gangid);
		mysql_tquery(connectionID, queryBuffer);
		ReloadGang(gangid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have moved %s's locker to your currently position.", GangInfo[gangid][gName]);
	}
	else if(!strcmp(option, "remove", true))
    {
		DestroyDynamic3DTextLabel(GangInfo[gangid][gText][0]);
		DestroyDynamicPickup(GangInfo[gangid][gPickup]);
		GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET stash_x = 0, stash_y = 0, stash_z = 0, stashinterior = 1, stashworld = 1 WHERE id = %i", gangid);
		mysql_tquery(connectionID, queryBuffer);
		ReloadGang(gangid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's locker.", GangInfo[gangid][gName]);
	}
	else if(!strcmp(option, "goto", true))
    {
		TeleportToCoords(playerid, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], 0.0, GangInfo[gangid][gStashInterior], GangInfo[gangid][gStashWorld]);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET stash_x = 0, stash_y = 0, stash_z = 0, stashinterior = 1, stashworld = 1 WHERE id = %i", gangid);
		mysql_tquery(connectionID, queryBuffer);
		ReloadGang(gangid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's locker.", GangInfo[gangid][gName]);
	}
	return 1;
}

CMD:gang(playerid, params[])
{
	new targetid, option[16], param[128];

	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(sscanf(params, "s[16]S()[128]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Invite, Kick, Rank, Roster, Online, Quit, Offlinekick");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: MOTD, Stash, Stats, Turfs, Rankname, Upgrade, War, Alliance");
	    return 1;
	}
	if(!strcmp(option, "invite", true))
	{
		if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [invite] [playerid]");
		}
		if(GangInfo[PlayerData[playerid][pGang]][gInvCooldown] > 0 && GetGangInviteCooldown())
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You're gang is currently on a invite cooldown. Please wait %i minutes before the next invite.", GangInfo[PlayerData[playerid][pGang]][gInvCooldown]);
		}
		if(GangClaimingTurfs(PlayerData[playerid][pGang]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can not use invite if your gang is attending a turf or point.");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pGang] != -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of a gang.");
		}

		if(PlayerData[targetid][pFaction] != -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is apart of a faction and therefore can't join a gang.");
		}
		
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM "#TABLE_USERS" WHERE gang = %i", PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptInviteGang", "ii", playerid, targetid);
	}
	else if(!strcmp(option, "skin", true))
	{
		if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
		{
			return SendClientErrorUnauthorizedCmd(playerid);
		}		
	    new slot, skinid, gangid = PlayerData[playerid][pGang];
		if(PlayerData[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6 to use this command.");
		}
	    if(sscanf(param, "ii", slot, skinid))
	    {

	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Gang Skins ______");

	        for(new i = 0; i < MAX_GANG_SKINS; i ++)
	        {
	            if(GangInfo[gangid][gSkins][i] == 0)
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, GangInfo[gangid][gSkins][i]);
	        }

	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /gang [skin] [slot (1-%i)] [skinid]", MAX_GANG_SKINS);
	    }
		new forbidSkin[35] =
		{
			0, 71, 74, 264, 265, 266, 267, 274, 275, 276,
			277, 278, 279, 280, 281, 282, 283, 284, 285,
			286, 287, 288, 300, 301, 302, 306, 307, 308,
			309, 310, 311
		};


	    if(!(1 <= slot <= MAX_GANG_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
		}
		if(!(1 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid skin.");
		}
		for(new i = 0; i < sizeof forbidSkin; i++)
		{
			if(skinid == forbidSkin[i])
			{
				return SendClientMessage(playerid, COLOR_GREY, "You can't select this skin.");
			}
		}
		slot--;

		GangInfo[gangid][gSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", gangid, slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_WHITE, "* You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "kick", true))
	{
		if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
		}
		if(PlayerData[targetid][pGangRank] > PlayerData[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
		}

		if(PlayerData[targetid][pID] == GangInfo[PlayerData[playerid][pGang]][gLeaderUID])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You cannot kick this person.");
		}

		Log_Write("log_gang", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang], GangRanks[PlayerData[targetid][pGang]][PlayerData[targetid][pGangRank]], PlayerData[targetid][pGangRank]);

        GangInfo[PlayerData[targetid][pGang]][gCount]--;

		PlayerData[targetid][pGang] = -1;
		PlayerData[targetid][pGangRank] = 0;
        DestroyDynamic3DTextLabel(fRepfamtext[targetid]);
        fRepfamtext[targetid] = Text3D:INVALID_3DTEXT_ID;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has kicked you from the gang.", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have kicked %s from your gang.", GetRPName(targetid));
	}
	else if(!strcmp(option, "rank", true))
	{
	    new rankid;

		if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "ui", targetid, rankid))
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /gang [rank] [playerid] [rankid (0-6)]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(rankid < 0 || rankid > PlayerData[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The rank specified is either invalid or higher than your rank.");
		}
		if(PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
		}
		if(PlayerData[targetid][pGangRank] > PlayerData[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
		}

		PlayerData[targetid][pGangRank] = rankid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gangrank = %i WHERE uid = %i", rankid, PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has set your rank to {00AA00}%s{33CCFF} (%i).", GetRPName(playerid), GangRanks[PlayerData[playerid][pGang]][rankid], rankid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set %s's rank to {00AA00}%s{33CCFF} (%i).", GetRPName(targetid), GangRanks[PlayerData[playerid][pGang]][rankid], rankid);
		Log_Write("log_gang", "%s (uid: %i) has set %s's (uid: %i) rank in %s (id: %i) to %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang], GangRanks[PlayerData[playerid][pGang]][rankid], rankid);
	}
	else if(!strcmp(option, "stash", true))
	{
		SendClientMessage(playerid, COLOR_GREY, "This command was removed, Contact an admin to place your locker.");
 	}
	else if(!strcmp(option, "turfs", true))
	{
		ListGangTurfs(playerid);
	}
	else if(!strcmp(option, "stats", true))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM "#TABLE_USERS" WHERE gang = %i", PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnGangInformation", "i", playerid);
	}
	else if(!strcmp(option, "roster", true))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin, gangrank,membership_rankingpoints FROM "#TABLE_USERS" WHERE gang = %i ORDER BY gangrank DESC", PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_GANG_ROSTER, playerid);
	}
	else if(!strcmp(option, "online", true))
	{
	    callcmd::gmembers(playerid, "\1");
	}
	else if(!strcmp(option, "quit", true))
	{
	    /*if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [quit] [confirm]");
	    }*/
		SendClientMessage(playerid, COLOR_SYNTAX, "{7E7D7D}Hi {5B0303}You Gangster{7E7D7D} This Command Is Disabled");

	    //SendClientMessageEx(playerid, COLOR_AQUA, "You have quit %s as a {00AA00}%s{33CCFF} (%i).", GangInfo[PlayerData[playerid][pGang]][gName], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], PlayerData[playerid][pGangRank]);
		/*Log_Write("log_gang", "%s (uid: %i) has quit %s (id: %i) has rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], PlayerData[playerid][pGangRank]);

        GangInfo[PlayerData[playerid][pGang]][gCount]--;
	    PlayerData[playerid][pGang] = -1;
		PlayerData[playerid][pGangRank] = 0;
        DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
        fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);*/
	}
	else if(!strcmp(option, "offlinekick", true))
	{
	    new username[MAX_PLAYER_NAME];

		if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "s[24]", username))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [offlinekick] [username]");
		}
		if(IsPlayerOnline(username))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use '/gang kick' instead.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, gang, gangrank FROM "#TABLE_USERS" WHERE username = '%e'", username);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerOfflineKickGang", "is", playerid, username);
	}
	else if(!strcmp(option, "offlinerank", true))
	{
	    new username[MAX_PLAYER_NAME], newrank;

		if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
		}
		if(sscanf(param, "s[24]i", username, newrank))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [offlinerank] [username] [rankid (0-6)]");
		}
		if(IsPlayerOnline(username))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use '/gang rank' instead.");
		}
		if(newrank < 0 || newrank > PlayerData[playerid][pGangRank])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The rank specified is either invalid or higher than your rank.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, gang, gangrank FROM "#TABLE_USERS" WHERE username = '%e'", username);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerOfflineRankGang", "isi", playerid, username, newrank);
	}
	else if(!strcmp(option, "motd", true))
	{
	    if(PlayerData[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
		}
	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [motd] [text]");
	        SendClientMessageEx(playerid, COLOR_SYNTAX, "Current MOTD: %s", GangInfo[PlayerData[playerid][pGang]][gMOTD]);
	        return 1;
		}

		strcpy(GangInfo[PlayerData[playerid][pGang]][gMOTD], param, 128);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET motd = '%e' WHERE id = %i", param, PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(PlayerData[playerid][pGang]);
		SendClientMessage(playerid, COLOR_AQUA, "You have changed the MOTD for your gang.");
	}
	else if(!strcmp(option, "rankname", true))
	{
	    new rankid, rank[32];

        if(PlayerData[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
		}
	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Rank Names ______");

	        for(new i = 0; i < 7; i ++)
	        {
	            if(isnull(GangRanks[PlayerData[playerid][pGang]][i]))
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: %s", i, GangRanks[PlayerData[playerid][pGang]][i]);
	        }

	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [rankname] [slot (0-6)] [name]");
	    }
	    if(!(0 <= rankid <= 6))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
		}

	    strcpy(GangRanks[PlayerData[playerid][pGang]][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", PlayerData[playerid][pGang], rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the name of rank %i to {00AA00}%s{33CCFF}.", rankid, rank);
	}
	else if(!strcmp(option, "upgrade", true))
	{
	    if(PlayerData[playerid][pGangRank] < 6)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
		}

		new
		    title[48],
			string[1024] = "Perk\tDescription\tCost";

		strcat(string, "\nDrug dealer\tAn NPC which sells individually stocked drugs\t{F7A763}500 GP {FFFFFF}+{00AA00} $50,000");
		strcat(string, "\nArms dealer\tAn NPC which sells individually stocked weapons\t{F7A763}500 GP {FFFFFF}+{00AA00} $50,000");
		strcat(string, "\nDuel arena\tAn OOC 1v1 duel arena for your gang.\t{F7A763}400 GP {FFFFFF}+{00AA00} $75,000");
	    strcat(string, "\nMapping\tUp to 50 mapped objects for your gang.\t{F7A763}4500 GP {FFFFFF}+{00AA00} $100,000");
	    strcat(string, "\nInterior\tCustom interior exclusively for your gang.\t{F7A763}5000 GP {FFFFFF}+{00AA00} $100,000");
		// gang and mat s0ns
	    format(string, sizeof string, "%s\nMaterials level up\tReceive more materials from successfully captured turfs.\t{F7A763}%s GP {FFFFFF}+{00AA00} $%s", string, FormatNumber(1500 + (500*GangInfo[PlayerData[playerid][pGang]][gMatLevel])), FormatNumber(100000 + (50000*GangInfo[PlayerData[playerid][pGang]][gMatLevel])));
	    format(string, sizeof string, "%s\nGun level up\tReceive more guns from successfully captured turfs.\t{F7A763} %s GP {FFFFFF}+{00AA00} $%s", string, FormatNumber(1500 + (250*GangInfo[PlayerData[playerid][pGang]][gGunLevel])), FormatNumber(40000 + (20000 * GangInfo[PlayerData[playerid][pGang]][gGunLevel])));

		if(GangInfo[PlayerData[playerid][pGang]][gLevel] == 1)
		{
		    strcat(string, "\nLevel Up\tAdvance your gang's level to 2/3.\t{F7A763}6000 GP {FFFFFF}+{00AA00} $75,000");
		}
		else if(GangInfo[PlayerData[playerid][pGang]][gLevel] == 2)
		{
		    strcat(string, "\nLevel Up\tAdvance your gang's level to 3/3.\t{F7A763}12000 GP {FFFFFF}+{00AA00} $100,000");
		}

		format(title, sizeof(title), "Gang upgrades (Your gang has %i GP.)", GangInfo[PlayerData[playerid][pGang]][gPoints]);
		Dialog_Show(playerid, DIALOG_GANGPOINTSHOP, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Select", "Cancel");
	}
	else if(!strcmp(option, "alliance", true))
	{
	    new gangid = PlayerData[playerid][pGang];

		if(PlayerData[playerid][pGangRank] < 6)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
	  	}
		if(sscanf(param, "u", targetid))
	  	{
	   		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [alliance] [playerid]");
	  	}
  	 	if(GangInfo[gangid][gAlliance] >= 0)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You're already in an alliance, end it first! (/endalliance)");
	  	}
	  	if(PlayerData[targetid][pGangRank] < 6)
	  	{
			return SendClientMessage(playerid, COLOR_GREY, "The player you're offering to ally with must be R6 in their gang!");
	  	}
        if(PlayerData[targetid][pGang] == gangid)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You cannot form an alliance with your own gang!");
		}

		if(GangInfo[gangid][gAlliance] == -1)
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You've offered to form a gang alliance with %s.", GetRPName(targetid));
			SendClientMessageEx(targetid, COLOR_AQUA, "%s has offered to form an alliance with your gang. (/accept alliance)", GetRPName(playerid));
			PlayerData[targetid][pAllianceOffer] = playerid;
		}
	}

	return 1;
}

CMD:gstash(playerid, params[])
{
	if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
	}
    if(!(IsPlayerInRangeOfPoint(playerid, 5.0, GangInfo[PlayerData[playerid][pGang]][gStashX], GangInfo[PlayerData[playerid][pGang]][gStashY], GangInfo[PlayerData[playerid][pGang]][gStashZ]) && GetPlayerVirtualWorld(playerid) == GangInfo[PlayerData[playerid][pGang]][gStashWorld]))
    {
		return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your gang stash.");
	}
    if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to open the stash. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}
	ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
	return 1;
}

CMD:repfam(playerid, params[])
{
	callcmd::bandana(playerid, params);
}

CMD:bandana(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
	}
    if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to takeoff your bandana. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}
	if(!PlayerData[playerid][pBandana])
	{
	    new color;
	 	if(GangInfo[PlayerData[playerid][pGang]][gColor] == -1 || GangInfo[PlayerData[playerid][pGang]][gColor] == -256)
		{
			color = 0xC8C8C8FF;
		}
		else
		{
		    color = GangInfo[PlayerData[playerid][pGang]][gColor];
		}
		if(IsPlayerInEvent(playerid) || PlayerData[playerid][pPaintballTeam] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can not put on your bandana on while in a event or paintball match.");
		}
	    PlayerData[playerid][pBandana] = 1;

	    SendClientMessage(playerid, COLOR_AQUA, "You have enabled your bandana. Your nametag color has been set to your gang color.");
	    ShowActionBubble(playerid, "* %s takes out a bandana and wraps it around their head.", GetRPName(playerid));
		new string[120];
		format(string, sizeof(string), "{%06x}%s", color >>> 8, GangInfo[PlayerData[playerid][pGang]][gName]);
        fRepfamtext[playerid] = CreateDynamic3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, -0.3, 20.0, .attachedplayer = playerid, .testlos = 1);

	}
	else
	{
	    PlayerData[playerid][pBandana] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "You have disabled your bandana. Your nametag color was reset back to normal.");
	    ShowActionBubble(playerid, "* %s takes off their bandana from around their head.", GetRPName(playerid));
		DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
        fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
	}

	foreach(new i : Player)
	{
        if(PlayerData[i][pGang] == PlayerData[playerid][pGang])
        {
            if(PlayerData[playerid][pBandana])
            {
    	        SetPlayerMarkerForPlayer(i, playerid, (GangInfo[PlayerData[playerid][pGang]][gColor] & ~0xff) + 0xFF);
			}
			else
			{
    	        SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
			}
		}
	}
	return 1;
}

CMD:gpark(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

	if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in any gang at the moment.");
	}
	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any of your gang vehicles.");
	}
	if(VehicleInfo[vehicleid][vGang] != PlayerData[playerid][pGang])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't park this vehicle as it doesn't belong to your gang.");
	}
    if(IsPlayerInRangeOfPoint(playerid, 20.0, 1233.1134,-1304.1257,13.5124))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't park your vehicle here.");
    }
	// Save the vehicle's information.
	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);

    VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
    VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);

	SendClientMessage(playerid, COLOR_AQUA, "* Gang vehicle parked. It will now spawn here.");

	// Update the database record with the new information, then despawn the vehicle.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	SaveVehicleModifications(vehicleid);
 	DespawnVehicle(vehicleid, false);

	// Finally, we reload the vehicle from the database.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);

	return 1;
}

CMD:gfindcar(playerid, params[])
{
	new string[512], count;

    if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
	}

	string = "#\tModel\tLocation";

	foreach(new i: Vehicle)
	{
	    if(VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerData[playerid][pGang])
	    {
	        format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
	        count++;
		}
	}

	if(!count)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your gang has no vehicles which you can track.");
	}

	Dialog_Show(playerid, DIALOG_GANGFINDCAR, DIALOG_STYLE_TABLIST_HEADERS, "Gang vehicles", string, "Track", "Cancel");
	return 1;
}

CMD:grespawncars(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in any gang at the moment.");
	}

    foreach(new i: Vehicle)
	{
	    if(VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerData[playerid][pGang] && !IsVehicleOccupied(i))
	    {
	        SetVehicleToRespawn(i);
		}
	}

	SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has respawned their gang vehicles.", GetRPName(playerid), playerid);
	SendClientMessage(playerid, COLOR_YELLOW, "You have respawned all of your unoccupied gang vehicles.");
	return 1;
}

CMD:gsellcar(playerid, params[])
{
  	new vehicleid = GetPlayerVehicleID(playerid);

	if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in any gang at the moment.");
	}
	if(GangInfo[PlayerData[playerid][pGang]][gLeaderUID] != PlayerData[playerid][pID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Only gang leader can sell gang cars.");
	}
	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any of your gang vehicles.");
	}
	if(VehicleInfo[vehicleid][vGang] != PlayerData[playerid][pGang])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell this vehicle as it doesn't belong to your gang.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 8.0, 542.0433, -1293.5909, 17.2422))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the Grotti car dealership.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gsellcar [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command permanently deletes your gang vehicle. You will receive %s back.", FormatCash(percent(VehicleInfo[vehicleid][vPrice], 75)));
	    return 1;
	}

	GivePlayerCash(playerid, percent(VehicleInfo[vehicleid][vPrice], 75));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your %s to the dealership and received %s back.", GetVehicleName(vehicleid), FormatCash(percent(VehicleInfo[vehicleid][vPrice], 75)));
    Log_Write("log_gang", "%s (uid: %i) sold their gang owned %s (id: %i) to the dealership for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], percent(VehicleInfo[vehicleid][vPrice], 75));

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	DespawnVehicle(vehicleid, false);
	return 1;
}
CMD:ganghelp(playerid, params[])
{
	if(PlayerData[playerid][pGang] == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a gang member.");
	}

    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** GANG HELP ** type a command for more information.");
	SendClientMessage(playerid, COLOR_GREY, "** GANG ** /f /gang /gstash /gbackup /bandana /capture /claim /reclaim /turfinfo /gspray");
    SendClientMessage(playerid, COLOR_GREY, "** GANG ** /gbuyvehicle /gpark /gfindcar /grespawncars /gsellcar /gunmod /lock /endalliance");
    SendClientMessage(playerid, COLOR_GREY, "** CREW ** /managecrew /crew /locateganghq");
	return 1;
}


CMD:creategang(playerid, params[])
{
	new name[32];

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[32]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /creategang [name]");
	}

	for(new i = 0; i < MAX_GANGS; i ++)
	{
	    if(!GangInfo[i][gSetup])
	    {
	        SetupGang(i, name);

	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has setup gang {F7A763}%s{FF6347} in slot ID %i.", GetRPName(playerid), name, i);
	        SendClientMessageEx(playerid, COLOR_WHITE, "* This gang's ID is %i. /editgang to edit.", i);
	        return 1;
		}
	}

    SendClientMessage(playerid, COLOR_GREY, "Gang slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editgang(playerid, params[])
{
	new gangid, option[14], param[128];

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[14]S()[128]", gangid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, MOTD, Leader, Level, Color, Points, TurfTokens, RankName, Skin, Strikes, RankingPoints, Mafia");
		return 1;
	}
	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}

	if(!strcmp(option, "rankingpoints", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [rankingpoints] [value]");
		}
		if(value < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid ranking point value.");
		}

		GangInfo[gangid][gRankingPoints] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rankingpoints = %i WHERE id = %i", GangInfo[gangid][gRankingPoints], gangid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the ranking points of gang ID %i to %i.", GetRPName(playerid), gangid, value);
	}
	if(!strcmp(option, "name", true))
	{
	    if(isnull(param) || strlen(params) > 32)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [name] [text]");
		}

		strcpy(GangInfo[gangid][gName], param, 32);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET name = '%e' WHERE id = %i", param, gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the name of gang ID %i to '%s'.", GetRPName(playerid), gangid, param);
	}
	else if(!strcmp(option, "motd", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [motd] [text]");
		}

		strcpy(GangInfo[gangid][gMOTD], param, 128);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET motd = '%e' WHERE id = %i", param, gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has adjusted the MOTD of gang ID %i.", GetRPName(playerid), gangid);
	}
	else if(!strcmp(option, "leader", true))
	{
	    new leaderid;

	    if(sscanf(param, "d", leaderid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [leader] [leaderid]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "  This updates the text for the leader's name in /gangs and prevent players from kicking him.");
	        SendClientMessage(playerid, COLOR_SYNTAX, "  To remove the leader use id -1");
			return 1;
		}
		if(leaderid == -1)
		{	
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET leaderid = 0 WHERE id = %i", gangid);
			mysql_tquery(connectionID, queryBuffer);
			strcpy(GangInfo[gangid][gLeader], "No-one", MAX_PLAYER_NAME);
			GangInfo[gangid][gLeaderUID] = 0;
			SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has removed the leader of the gang %s[%i].", GetRPName(playerid), playerid, GangInfo[gangid][gName], gangid);
			Log_Write("log_gang", "%s (uid: %i) has removed the leader of gang %s (id: %i).",
				GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
		}
		else
		{
			GetPlayerName(leaderid, GangInfo[gangid][gLeader], MAX_PLAYER_NAME);
			GangInfo[gangid][gLeaderUID] = PlayerData[leaderid][pID];
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET leaderid = %d WHERE id = %i", PlayerData[leaderid][pID], gangid);
			mysql_tquery(connectionID, queryBuffer);

			PlayerData[leaderid][pGang] = gangid;
			PlayerData[leaderid][pGangRank] = 6;
			PlayerData[leaderid][pCrew] = -1;

			SendClientMessageEx(leaderid, COLOR_AQUA, "%s has made you the leader of {00AA00}%s{33CCFF}.", GetRPName(playerid), GangInfo[gangid][gName]);

			SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has set %s[%i] the leader of the gang %s[%i].", GetRPName(playerid), playerid, GetRPName(leaderid), leaderid, GangInfo[gangid][gName], gangid);
			Log_Write("log_gang", "%s (uid: %i) has set %s's (uid: %i) the leader of gang %s (id: %i).",
				GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(leaderid), PlayerData[leaderid][pID], GangInfo[gangid][gName], gangid);
		}
	}
	else if(!strcmp(option, "level", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [level] [value (1-3)]");
		}
		if(!(1 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid level.");
		}

		GangInfo[gangid][gLevel] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET level = %i WHERE id = %i", GangInfo[gangid][gLevel], gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the level of gang ID %i to %i/3.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "mafia", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [mafia] [value (0-1)]");
		}
		if(!(0 <= value <= 1))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid value (must be 0 or 1).");
		}

		GangInfo[gangid][gIsMafia] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET is_mafia = %i WHERE id = %i", GangInfo[gangid][gIsMafia], gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the mafia value of gang ID %i to %i.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [color] [0xRRGGBBAA]");
		}

		GangInfo[gangid][gColor] = color & ~0xff;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET color = %i WHERE id = %i", GangInfo[gangid][gColor], gangid);
		mysql_tquery(connectionID, queryBuffer);

  		foreach(new i : Turf)
		{
		    if(IsTurfCapturedByGang(i, gangid))
		    {
		        ReloadTurf(i);
			}
		}

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of gang ID %i.", GetRPName(playerid), color >>> 8, gangid);
	}
	else if(!strcmp(option, "points", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [points] [value]");
		}

		GangInfo[gangid][gPoints] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET points = %i WHERE id = %i", GangInfo[gangid][gPoints], gangid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the gang points of gang ID %i to %i.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "turftokens", true))
	{
	    new value;

	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [turftokens] [value]");
		}

		GangInfo[gangid][gTurfTokens] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET turftokens = %i WHERE id = %i", GangInfo[gangid][gTurfTokens], gangid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the turf tokens of gang ID %i to %i.", GetRPName(playerid), gangid, value);
	}
	else if(!strcmp(option, "rankname", true))
	{
	    new rankid, rank[32];

	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Rank Names ______");

	        for(new i = 0; i < 7; i ++)
	        {
	            if(isnull(GangRanks[gangid][i]))
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: %s", i, GangRanks[gangid][i]);
	        }

	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [rankname] [slot (0-6)] [name]");
	    }
	    if(!(0 <= rankid <= 6))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
		}

	    strcpy(GangRanks[gangid][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", gangid, rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's name of gang ID %i to '%s'.", GetRPName(playerid), rankid, gangid, rank);
	}
	else if(!strcmp(option, "skin", true))
	{
	    new slot, skinid;

	    if(sscanf(param, "ii", slot, skinid))
	    {
	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Gang Skins ______");

	        for(new i = 0; i < MAX_GANG_SKINS; i ++)
	        {
	            if(GangInfo[gangid][gSkins][i] == 0)
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, GangInfo[gangid][gSkins][i]);
	        }

	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [skin] [slot (1-%i)] [skinid]", MAX_GANG_SKINS);
	    }
	    if(!(1 <= slot <= MAX_GANG_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
		}
		slot--;
        if(skinid == 0 && GangInfo[gangid][gSkins][slot] != -1)
        {
		    GangInfo[gangid][gSkins][slot] = skinid;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM gangskins WHERE id=%i and slot = %i", gangid, slot);
            mysql_tquery(connectionID, queryBuffer);
            return SendClientMessageEx(playerid, COLOR_WHITE, "* You have removed the skin in slot %i.", slot + 1);
        }
		if(!(1 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid skin.");
		}

		GangInfo[gangid][gSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO gangskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", gangid, slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_WHITE, "* You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "strikes", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [strikes] [amount]");
		}
		if(!(0 <= amount <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The amount must range from 0 to 3.");
		}

		GangInfo[gangid][gStrikes] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET strikes = %i WHERE id = %i", amount, gangid);
		mysql_tquery(connectionID, queryBuffer);

		ReloadGang(gangid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the strikes of gang ID %i to %i.", GetRPName(playerid), gangid, amount);
	}
	else if(!strcmp(option, "alliance", true))
	{
		new allyid;

	    if(sscanf(param, "i", allyid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [alliance] [gangid]");
		}

		if(allyid == -1)
		{
		    if(GangInfo[gangid][gAlliance] >= 0)
		    {
		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", GangInfo[gangid][gAlliance]);
				mysql_tquery(connectionID, queryBuffer);
		        GangInfo[GangInfo[gangid][gAlliance]][gAlliance] = -1;
			}

			GangInfo[gangid][gAlliance] = -1;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", gangid);
			mysql_tquery(connectionID, queryBuffer);

			ReloadGang(gangid);
			SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the alliance of gang ID %i.", GetRPName(playerid), gangid);
		}
		else
		{
		    if(!(0 <= allyid < MAX_GANGS) || GangInfo[allyid][gSetup] == 0)
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		    }

			GangInfo[gangid][gAlliance] = allyid;
			GangInfo[allyid][gAlliance] = gangid;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", allyid, gangid);
			mysql_tquery(connectionID, queryBuffer);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", gangid, allyid);
			mysql_tquery(connectionID, queryBuffer);

			ReloadGang(gangid);
			SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the alliance of gang ID %i to gang %i.", GetRPName(playerid), gangid, allyid);
		}
	}
	return 1;
}

CMD:createganghq(playerid, params[])
{
	new gangid;
	new Float:x, Float:y, Float:z, Float:a;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(GetNearbyEntrance(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is an entrance in range. Find somewhere else to create this one.");
	}
	if(sscanf(params, "i", gangid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createganghq [gangid]");
	}

	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	
	if(GetGangHQ(gangid) != -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "This gang alreaddy have an HQ.");
	}
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new Float:ix = 2214.47 ;
	new Float:iy = -1150.37;
	new Float:iz = 1025.8;
	new Float:ia = 269.491;
	new interior = 15;
	new world = 35000 + gangid;

	for(new i = 0; i < MAX_ENTRANCES; i ++)
	{
	    if(!EntranceInfo[i][eExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO entrances (name, pos_x, pos_y, pos_z, pos_a, outsideint, outsidevw, gang, int_x, int_y, int_z, int_a, interior, world) VALUES('%e', '%f', '%f', '%f', '%f', %i, %i, %i, '%f', '%f', '%f', '%f', %i, %i)", GangInfo[gangid][gName], x, y, z, a - 180.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), gangid, ix, iy, iz, ia, interior, world);
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateGangHQ", "iiiffffffffii", playerid, i, gangid, x, y, z, a, ix, iy, iz, ia, interior, world);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Entrance slots are currently full. Ask developers to increase the internal limit.");

    return 1;
}

CMD:locateganghq(playerid, params[])
{
	if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
	}
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You already have a checkpoint use /kcp to clear it.");
	}
	
	new entranceid = GetGangHQ(PlayerData[playerid][pGang]);
	if(entranceid == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have an HQ.");
	}
	
	SetPlayerCheckpoint(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], 2.5);
	SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to your gang hq");
	PlayerData[playerid][pCP] = CHECKPOINT_MISC;
	return 1;
}

CMD:gotoganghq(playerid, params[])
{
	new gangid;
	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	if(sscanf(params, "i", gangid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoganghq [gangid]");
	}

	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	
	new entranceid = GetGangHQ(gangid);
	if(entranceid == -1)
	{
		SendClientMessage(playerid, COLOR_GREY, "This gang doesn't have an HQ.");
	}
	else
	{
		GotoEntrance(playerid, entranceid);
	}
	return 1;
}

CMD:removeganghq(playerid, params[])
{
	new gangid;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	if(sscanf(params, "i", gangid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeganghq [gangid]");
	}

	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	
	new entranceid = GetGangHQ(gangid);
	if(entranceid == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "This gang doesn't have an HQ.");
	}
	
	RemoveEntrance(entranceid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed the HQ of gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have removed the HQ of gang  {F7A763}%s{FF6347}.", GangInfo[gangid][gName]);
	Log_Write("log_gang", "%s (uid: %i) has removed the HQ of gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
	return 1;
}

CMD:purgegang(playerid, params[])
{
	new gangid;
	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", gangid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /purgegang [gangid]");
	}
	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	foreach(new i : Player)
	{
	    if(PlayerData[i][pGang] == gangid)
	    {
	        SendClientMessageEx(i, COLOR_LIGHTRED, "The gang you were apart of has been deleted by an administrator.");
	        PlayerData[i][pGang] = -1;
	        PlayerData[i][pGangRank] = 0;
	    }
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE gang = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has purged gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have purged the gang {F7A763}%s{FF6347}.", GangInfo[gangid][gName]);
	Log_Write("log_gang", "%s (uid: %i) has purged the gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
	GangInfo[gangid][gCount] = 0;
	return 1;
}

CMD:removegang(playerid, params[])
{
	new gangid;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", gangid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removegang [gangid]");
	}
	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}

	RemoveGang(gangid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has deleted gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have permanently deleted the {F7A763}%s{FF6347} gang slot.", GangInfo[gangid][gName]);
	Log_Write("log_gang", "%s (uid: %i) has removed gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
	return 1;
}

CMD:adminstrike(playerid, params[])
{
	new targetid, reason[128];
	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pAdminPersonnel])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /adminstrike [playerid] [reason]");
	}
	PlayerData[targetid][pAdminStrike]++;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET adminstrikes = %i WHERE uid = %i", PlayerData[targetid][pAdminStrike], targetid);
	mysql_tquery(connectionID, queryBuffer);
	Log_Write("log_strike", "%s (uid: %i) has admin striked player %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GetRPName(targetid), targetid);
	switch(PlayerData[targetid][pAdminStrike])
	{
		case 1: SendAdminMessage(COLOR_WHITE, "(( Admin News: %s{FFFFFF} has received their 1st strike, reason: %s ))", GetRPName(targetid), reason);
		case 2: SendAdminMessage(COLOR_WHITE, "(( Admin News: %s{FFFFFF} has received their 2nd strike, reason: %s ))", GetRPName(targetid), reason);
		case 3:
		{
		    PlayerData[targetid][pAdmin] -= 1;
		    PlayerData[targetid][pAdminStrike] = 0;
		    SendClientMessage(targetid, COLOR_GREY, "The admin strike system works perfectly fine");
		    GameTextForPlayer(targetid, "~r~DEMOTED", 5000, 1);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET adminlevel = %i, adminstrikes = %i WHERE uid = %i", PlayerData[targetid][pAdmin], PlayerData[targetid][pAdminStrike], PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			SendAdminMessage(COLOR_WHITE, "(( Admin News: %s{FFFFFF} has received their 3rd strike, reason: %s ))", GetRPName(targetid), reason);
		}
	}
	return 1;
}

CMD:gangstrike(playerid, params[])
{
	new gangid, reason[128], color;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[128]", gangid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gangstrike [gangid] [reason]");
	}
	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	if(GangInfo[gangid][gStrikes] >= 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This gang already has 3 strikes.");
	}

	GangInfo[gangid][gStrikes]++;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET strikes = %i WHERE id = %i", GangInfo[gangid][gStrikes], gangid);
	mysql_tquery(connectionID, queryBuffer);
	Log_Write("log_gang", "%s (uid: %i) has striked gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
	if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
	{
		color = 0xC8C8C8FF;
	}
	else
	{
	    color = GangInfo[gangid][gColor];
	}
	switch(GangInfo[gangid][gStrikes])
	{
		case 1: SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has received their 1st strike, reason: %s ))", color >>> 8, GangInfo[gangid][gName], reason);
		case 2: SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has received their 2nd strike, reason: %s ))", color >>> 8, GangInfo[gangid][gName], reason);
		case 3: SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has received their 3rd strike, reason: %s ))", color >>> 8, GangInfo[gangid][gName], reason);
	}

	return 1;
}

CMD:switchgang(playerid, params[])
{
	new targetid, gangid, rankid;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uiI(-1)", targetid, gangid, rankid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /switchgang[playerid] [gangid (-1 = none)] [rank (optional)]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	if((gangid != -1 && !(-1 <= rankid <= 6)))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
	}

	if(gangid == -1)
	{
        if(PlayerData[targetid][pGang] > 0)
        {
            GangInfo[PlayerData[targetid][pGang]][gCount]--;
        }
	    PlayerData[targetid][pGang] = -1;
		PlayerData[targetid][pGangRank] = 0;
		PlayerData[targetid][pCrew] = -1;

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed you from your gang.", GetRPName(playerid));
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s from their gang.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
        if(PlayerData[targetid][pGang] > 0)
        {
            GangInfo[PlayerData[targetid][pGang]][gCount]--;
        }
        GangInfo[gangid][gCount]++;

		if(rankid == -1)
		{
	    	rankid = 6;
		}

	    /*if(rankid == 6)
	    {
	        GetPlayerName(targetid, GangInfo[gangid][gLeader], MAX_PLAYER_NAME);

	    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET leader = '%e' WHERE id = %i", GangInfo[gangid][gLeader], gangid);
			mysql_tquery(connectionID, queryBuffer);
		}*/

		PlayerData[targetid][pGang] = gangid;
		PlayerData[targetid][pGangRank] = rankid;
		PlayerData[targetid][pCrew] = -1;

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {00AA00}%s{33CCFF} in %s.", GetRPName(playerid), GangRanks[gangid][rankid], GangInfo[gangid][gName]);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s in %s.", GetRPName(playerid), GetRPName(targetid), GangRanks[gangid][rankid], GangInfo[gangid][gName]);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gang = %i, gangrank = %i, crew = -1 WHERE uid = %i", gangid, rankid, PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:families(playerid, params[])
{
	return callcmd::gangs(playerid, params);
}

CMD:gangs(playerid, params[])
{
	new gangid;

	if(sscanf(params, "i", gangid))
	{
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "___________________ Gangs ___________________");

		for(new i = 0; i < MAX_GANGS; i ++)
		{
		    if(GangInfo[i][gSetup])
		    {
                OnPlayerListGangs(playerid, i, GangInfo[i][gCount]);
		    }
		}
		return 1;
	}
	if(PlayerData[playerid][pGang] != gangid && !IsAdmin(playerid))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can view only your gang members.");
	}
	if(!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	if(GangInfo[gangid][gAlliance] != -1)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Leader: %s - Strikes: %i/3 - Alliance: %s", GangInfo[gangid][gName], GangInfo[gangid][gLeader], GangInfo[gangid][gStrikes], GangInfo[GangInfo[gangid][gAlliance]][gName]);
	}
	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Members Online _____");

	foreach(new i : Player)
	{
	    if(PlayerData[i][pLogged] && PlayerData[i][pGang] == gangid)
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "(%i) %s %s", PlayerData[i][pGangRank], GangRanks[gangid][PlayerData[i][pGangRank]], GetRPName(i));
		}
	}

	return 1;
}

IsPlayerGangAlliance(playerid, targetid)
{
    if(PlayerData[playerid][pGang] >= 0 && PlayerData[targetid][pGang] >= 0)
    {
        return (PlayerData[playerid][pGang] == GangInfo[PlayerData[targetid][pGang]][gAlliance]);
    }
    return false;
}

CMD:capture(playerid, params[])
{
    return callcmd::claim(playerid, params);
}


CMD:endalliance(playerid, params[])
{
	new gangid = PlayerData[playerid][pGang];
	
    if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be in a gang to use this command");
	}

	new allyid = GangInfo[gangid][gAlliance];
	new color, color2;

	if(isnull(params) || strcmp(params, "confirm", true) != 0)
	{
	   return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /endalliance [confirm]");
	}
	if(PlayerData[playerid][pGangRank] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be rank 6 to use this command.");
	}
	if(GangInfo[gangid][gAlliance] == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Your gang isn't currently in an alliance.");
	}

	SendClientMessageEx(playerid, COLOR_YELLOW, "You just ended your alliance with %s.", GangInfo[gangid][gName]);

	if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
	{
		color = 0xC8C8C8FF;
	}
	else
	{
	    color = GangInfo[gangid][gColor];
	}
	if(GangInfo[allyid][gColor] == -1 || GangInfo[allyid][gColor] == -256)
	{
	    color2 = 0xC8C8C8FF;
	}
	else
	{
	    color2 = GangInfo[allyid][gColor];
	}

	SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has ended their alliance with {%06x}%s{FFFFFF} ))", color >>> 8, GangInfo[gangid][gName], color2 >>> 8, GangInfo[allyid][gName]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", gangid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", allyid);
	mysql_tquery(connectionID, queryBuffer);

	GangInfo[allyid][gAlliance] = -1;
	GangInfo[gangid][gAlliance] = -1;

	return 1;
}


publish OnPlayerListGangs(playerid, gangid, members)
{
	new color, color2, gangname[32], allyname[32];
	new alliance = GangInfo[gangid][gAlliance];

	if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
	{
		color = 0xC8C8C8FF;
	}
	else
	{
	    color = GangInfo[gangid][gColor];
	}

	if(GangInfo[gangid][gIsMafia])
	{
		color = 0x3F3F3FFF;
		format(gangname, sizeof(gangname), "[Mafia] %s", GangInfo[gangid][gName]);
	}
	else
	{
		format(gangname, sizeof(gangname), "%s", GangInfo[gangid][gName]);
	}

	if(alliance >= 0)
	{

		strcpy(allyname, GangInfo[alliance][gName]);

		if(GangInfo[alliance][gColor] == -1 || GangInfo[alliance][gColor] == -256)
		{
	    	color2 = 0xC8C8C8FF;
		}
		else if(GangInfo[gangid][gIsMafia])
		{
			color = 0x3F3F3FFF;
		}
		else
		{
		    color2 = GangInfo[alliance][gColor];
		}
	    SendClientMessageEx(playerid, 0xC8C8C8AA, "(Id %i) {%06x}%s{C8C8C8} | Leader: %s | Members: %i/%i | Strikes: %i/3 | Points: %d | Ally: {%06x}%s{C8C8C8}", gangid, color >>> 8, gangname, GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes], GangInfo[gangid][gPoints], color2 >>> 8, allyname);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY2, "(Id %i) {%06x}%s{C8C8C8} | Leader: %s | Members: %i/%i | Strikes: %i/3 | Points: %d", gangid, color >>> 8, gangname, GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes], GangInfo[gangid][gPoints]);
	}
}

CMD:gl(playerid, params[]) 
{

	if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
	}

	if(PlayerData[playerid][pGangRank] < 5)
	{
        return SendClientMessage(playerid, COLOR_GREY, "You need to R5+ to speak in this chat.");
	}

    if(isnull(params))
    {
        return SendUsageHeader(playerid, "gl", "[gang leaders chat]");
    }

    if(PlayerData[playerid][pToggleGang])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the gang chat as you have it toggled.");
	}

	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot speak in /gl while dead.");
	}

	if(PlayerData[playerid][pCuffed])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}
    
	if(PlayerData[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}

    new gangid = PlayerData[playerid][pGang];
    new string[128];
    new rank = PlayerData[playerid][pGangRank];

    format(string, sizeof(string), "[{%06x}%s{FFFFFF}] %s (%d) %s: {800080}%s", GangInfo[gangid][gColor] >>> 8, GangInfo[gangid][gName], GangRanks[gangid][rank], rank, GetPlayerNameEx(playerid), params); 

    SetPlayerChatBubble(playerid, string, COLOR_WHITE, 15.0,5000);
    
    foreach(new i : Player) 
    {
        if((PlayerData[i][pGang] != -1 && PlayerData[i][pGangRank] >= 5) || (PlayerData[i][pGangMod]))
        {
            SendClientMessage(i, COLOR_WHITE, string);
        }
    }
    return 1;
}



CMD:setcooldown(playerid, params[])
{
    new option[12], amount;
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && PlayerData[playerid][pGangMod] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[12]i", option, amount))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /setcooldown [ganginvite] [minutes]");
	}
	if(!strcmp(option, "ganginvite", true))
	{
	    if(-1 > amount > GetGangInviteCooldown())
	    {
	        return SendClientMessageEx(playerid, COLOR_GREY, "Amount must be above -1 and less then %i", GetGangInviteCooldown());
	    }
	    SetGangInviteCooldown(amount);
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the invite cooldown for gangs to %i.", GetRPName(playerid), amount);
	}
	return 1;
}
CMD:turfscaplimit(playerid, params[])
{
	new amount;
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && PlayerData[playerid][pGangMod] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /turfscaplimit [amount]");
	}
    if(0 > amount > MAX_TURFS)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Amount must be above 0 and less then %i.", MAX_TURFS);
    }
    SetMaxTurfCap(amount);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the max active turf claim limit for gangs to %i.", GetRPName(playerid), amount);


	return 1;
}