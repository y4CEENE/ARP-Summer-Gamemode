#include "core\membership\faction\fbi\fbi.cmd.pwn"
#include "core\membership\faction\hitman\hitman.cmd.pwn"
#include "core\membership\faction\pd\pd.cmd.pwn"
#include "core\membership\faction\medic\medic.cmd.pwn"
#include "core\membership\faction\gov\gov.cmd.pwn"
#include "core\membership\faction\news\news.cmd.pwn"
#include "core\membership\faction\faction.locker.pwn"

//UPDATE `factions` SET `name` = 'Federal Bureau of Investigation' WHERE `factions`.`id` = 5;
CMD:fmhelp(playerid,params[])
{
	if(!PlayerData[playerid][pFactionMod])
		return SendClientErrorUnauthorizedCmd(playerid);
	SendClientMessage(playerid, COLOR_GREEN, "FACTION MOD:{DDDDDD} /factionkick /faction /division /purgefaction /switchfaction /fpark /gotolocker");
	return SendClientMessage(playerid, COLOR_GREEN, "FACTION MOD:{DDDDDD} /spawnfire /killfire /randomfire.");
}
CMD:factionhelp(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not apart of any faction.");
	}
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
	SendClientMessage(playerid, COLOR_WHITE, "** FACTION HELP ** type a command for more information.");
	SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /fmotd /f /d /(r)adio /div  /(m)egaphone /hm /showbadge");
	SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /faction /division /locker /quitfaction /froster /frespawncars");

	switch(FactionInfo[PlayerData[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY:
	    {
	        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /gate /door /cell /tazer /cuff /uncuff /drag /detain /charge /arrest");
	        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /wanted /bloodtest /frisk /take /ticket /gov /ram /deploy /undeploy /undeployall /backup /swat");
	        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /mdc /clearwanted /siren /badge /vticket /vfrisk /vtake /seizeplant /mir");

			if(FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_FEDERAL)
				SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /listcallers /trackcall /cells /passport /callsign /bug /listbugs /tog bugged");
			else
			    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /listcallers /trackcall /cells /claim /callsign");
		}
		case FACTION_MEDIC:
		{
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /heal /drag /stretcher /deliverpt /getpt /listpt /injuries /deploy /undeploy /undeployall");
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /badge /gov /backup /listcallers /trackcall /callsign");
		}
		case FACTION_NEWS:
		{
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /news /live /endlive /liveban /badge /addeposit /adwithdraw");
		}
		case FACTION_GOVERNMENT:
		{
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /gov /settax /tazer /cuff /uncuff /detain /taxdeposit /taxwithdraw");
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /backup /badge /drag /gate /door /cell /arrest /frisk /take");
		}
		case FACTION_HITMAN:
		{
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /contracts /takehit /profile /passport /plantbomb /pickupbomb /detonate");
		    SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /hfind, /noknife, /hm");
		}
	}

	return 1;
}



CMD:showbadge(playerid, params[])
{
	new targetid, factionid, rankid;

    if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}

	if(GetPlayerFaction(playerid) == FACTION_HITMAN)
	{
	    if(sscanf(params, "uii", targetid, factionid, rankid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /showbadge [playerid] [factionid] [rankid]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "Use /factions for a list of factions to use with factionid parameter.");
	        return 1;
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
		}
		if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	    }
	    if(!(0 <= rankid < FactionInfo[factionid][fRankCount]))
	    {
	        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid rank. Valid ranks for this faction range from 0 to %i.", FactionInfo[factionid][fRankCount] - 1);
	    }
	    if(FactionInfo[factionid][fType] == FACTION_HITMAN)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't use this faction for your fake badge.");
	    }

	    SendClientMessageEx(targetid, COLOR_WHITE, "* %s is rank %s (%i) in %s. *", GetRPName(playerid), FactionRanks[factionid][rankid], rankid, FactionInfo[factionid][fName]);
	    ShowActionBubble(playerid, "* %s shows their badge to %s.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
		if(sscanf(params, "u", targetid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /showbadge [playerid]");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
		}

	    SendClientMessageEx(targetid, COLOR_WHITE, "* %s is rank %s (%i) in %s. *", GetRPName(playerid), FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], PlayerData[playerid][pFactionRank], FactionInfo[PlayerData[playerid][pFaction]][fName]);
	    ShowActionBubble(playerid, "* %s shows their badge to %s.", GetRPName(playerid), GetRPName(targetid));
	}

	return 1;
}

CMD:m(playerid, params[])
{
	return callcmd::megaphone(playerid, params);
}

CMD:megaphone(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your faction is not authorized to use the megaphone.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(m)egaphone [text]");
	}

	SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s %s:o< %s]", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
	return 1;
}
CMD:hm(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hm [text]");
	}

	SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s:o< %s]", GetRPName(playerid), params);
	return 1;
}


CMD:factions(playerid, params[])
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),"SELECT factions.id, COUNT(users.uid) AS count FROM factions LEFT JOIN users ON users.faction = factions.id GROUP BY factions.id;");
	mysql_tquery(connectionID, queryBuffer, "OnPlayerListAllFactions", "i", playerid);

	return 1;
}

CMD:factionkick(playerid, params[])
{
	if(!PlayerData[playerid][pFactionMod])
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /factionkick [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
		return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	Log_Write("log_faction", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], FactionInfo[PlayerData[playerid][pFaction]][fName], PlayerData[playerid][pFaction], FactionRanks[PlayerData[targetid][pFaction]][PlayerData[targetid][pFactionRank]], PlayerData[targetid][pFactionRank]);

	SetPlayerFaction(targetid, -1);
	RemovePlayerFromVehicle(playerid);
	SendClientMessageEx(targetid, COLOR_AQUA, "%s has kicked you from the faction.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "You have kicked %s from your faction.", GetRPName(targetid));
	if(PlayerData[targetid][pSpawnSelect] == 2)
	{
		PlayerData[targetid][pSpawnSelect] = 0;
	}
	return 1;
}
CMD:fmotd(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");

	return SendClientMessageEx(playerid, COLOR_YELLOW, "* Faction MOTD: %s", FactionInfo[PlayerData[playerid][pFaction]][fMOTD]);
}

/*CMD:quitfaction(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");

	if(isnull(params) || strcmp(params, "confirm", true) != 0)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /quitfaction [confirm]");
	}

	SendClientMessageEx(playerid, COLOR_AQUA, "You have quit %s as a {00AA00}%s{33CCFF} (%i).", FactionInfo[PlayerData[playerid][pFaction]][fName], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], PlayerData[playerid][pFactionRank]);
	Log_Write("log_faction", "%s (uid: %i) has quit %s (id: %i) has rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], FactionInfo[PlayerData[playerid][pFaction]][fName], PlayerData[playerid][pFaction], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], PlayerData[playerid][pFactionRank]);
	SetPlayerFaction(playerid, -1);
	RemovePlayerFromVehicle(playerid);
	return 1;
}*/

CMD:froster(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");

	if(PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 2)
		return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 2);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin, factionrank FROM "#TABLE_USERS" WHERE faction = %i ORDER BY factionrank DESC", PlayerData[playerid][pFaction]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_FACTION_ROSTER, playerid);
	return 1;
}
CMD:frespawncars(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");

	if(PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 2)
		return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 2);

	foreach(new i: Vehicle)
	{
		if(!IsVehicleOccupied(i) && VehicleInfo[i][vFaction] == PlayerData[playerid][pFaction])
		{
			SetVehicleToRespawn(i);
		}
	}

	SendFactionMessage(PlayerData[playerid][pFaction], COLOR_FACTIONCHAT, "(( %s %s has respawned all unoccupied faction vehicles. ))", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
	SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has respawned their faction vehicles.", GetRPName(playerid), playerid);
	return 1;
}

CMD:faction(playerid, params[])
{
	new targetid, option[14], param[128];
	

	if(!PlayerData[playerid][pFactionLeader] && !PlayerData[playerid][pFactionMod])
    {
        return SendClientErrorNoPermission(playerid);
	}
	new factionid = PlayerData[playerid][pFaction];
    if(factionid == -1)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You need to be in the faction in order to use this command.");
	}
	if(sscanf(params, "s[14]S()[128]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /faction [option]");
		
		if(PlayerData[playerid][pFactionMod])
	    	SendClientMessage(playerid, COLOR_SYNTAX, "List of options: MOTD, Invite, Kick, Offlinekick, Rank, Leadership, Pay");
		else if(PlayerData[playerid][pFactionRank] >= 6)
	    	SendClientMessage(playerid, COLOR_SYNTAX, "List of options: MOTD, Invite, Kick, Offlinekick, Rank, Leadership");
		else
	    	SendClientMessage(playerid, COLOR_SYNTAX, "List of options: MOTD, Invite, Kick, Offlinekick, Rank");
	    return 1;
	}
	if(!strcmp(option, "motd", true))
	{
		if(isnull(param))
		{   
			SendClientMessageEx(playerid, COLOR_YELLOW, "* Faction MOTD: %s", FactionInfo[factionid][fMOTD]);
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /faction [motd] [text ('none' to reset)]");
		    SendClientMessageEx(playerid, COLOR_SYNTAX, "Current MOTD: %s", FactionInfo[factionid][fMOTD]);
		    return 1;
		}

		strcpy(FactionInfo[factionid][fMOTD], param, 128);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have changed the MOTD for your faction.");

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET motd = '%e' WHERE id = %i", param, factionid);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "invite", true))
	{
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /faction [invite] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pFaction] != -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of a faction.");
		}
		if(PlayerData[targetid][pGang] != -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is apart of a gang and therefore can't join a faction.");
		}

		PlayerData[targetid][pFactionOffer] = playerid;
		PlayerData[targetid][pFactionOffered] = factionid;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s has invited you to join {00AA00}%s{33CCFF} (/accept faction).", GetRPName(playerid), FactionInfo[factionid][fName]);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have invited %s to join your faction.", GetRPName(targetid));
	}
	else if(!strcmp(option, "kick", true))
	{
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /faction [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pFaction] != factionid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your faction.");
		}
		if(PlayerData[targetid][pFactionRank] >= PlayerData[playerid][pFactionRank])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
		}

		Log_Write("log_faction", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", 
				GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], 
				FactionInfo[factionid][fName], factionid, FactionRanks[factionid][PlayerData[targetid][pFactionRank]], 
				PlayerData[targetid][pFactionRank]);

		SetPlayerFaction(targetid, -1);
		RemovePlayerFromVehicle(playerid);
		SendClientMessageEx(targetid, COLOR_AQUA, "%s has kicked you from the faction.", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have kicked %s from your faction.", GetRPName(targetid));
		if(PlayerData[targetid][pSpawnSelect] == 2)
		{
		    PlayerData[targetid][pSpawnSelect] = 0;
		}
	}
	else if(!strcmp(option, "offlinekick", true))
	{
	    new username[MAX_PLAYER_NAME];

		if(sscanf(param, "s[24]", username))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /faction [offlinekick] [username]");
		}
		if(IsPlayerOnline(username))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use '/faction kick' instead.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, faction, factionrank FROM "#TABLE_USERS" WHERE username = '%e'", username);
		mysql_tquery(connectionID, queryBuffer, "OnPlayerOfflineKickFaction", "is", playerid, username);
	}
	else if(!strcmp(option, "rank", true))
	{
	    new rankid;

		if(sscanf(param, "ui", targetid, rankid))
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /faction [rank] [playerid] [rankid (0-%i)]", FactionInfo[factionid][fRankCount] - 1);
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(rankid < 0 || rankid >= FactionInfo[factionid][fRankCount])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
		}
		if(PlayerData[targetid][pFaction] != factionid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your faction.");
		}
		if(PlayerData[targetid][pFactionRank] >= PlayerData[playerid][pFactionRank])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
		}

		PlayerData[targetid][pFactionRank] = rankid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET factionrank = %i WHERE uid = %i", rankid, PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has set your rank to {00AA00}%s{33CCFF} (%i).", GetRPName(playerid), FactionRanks[factionid][rankid], rankid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set %s's rank to {00AA00}%s{33CCFF} (%i).", GetRPName(targetid), FactionRanks[factionid][rankid], rankid);
		Log_Write("log_faction", "%s (uid: %i) has set %s's (uid: %i) rank in %s (id: %i) to %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], FactionInfo[factionid][fName], factionid, FactionRanks[factionid][rankid], rankid);
	}
	else if(!strcmp(option, "leadership", true))
	{
		if(PlayerData[playerid][pFactionRank] < 6 || !PlayerData[playerid][pFactionMod])
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(sscanf(param, "u", targetid))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /faction [leadership] [playerid]");
		    SendClientMessage(playerid, COLOR_SYNTAX, "This command grants or revokes a fellow faction member's leadership flags.");
		    return 1;
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pFaction] != factionid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your faction.");
		}

	    if(!PlayerData[targetid][pFactionLeader])
	    {
	        PlayerData[targetid][pFactionLeader] = 1;

	        SendClientMessageEx(targetid, COLOR_AQUA, "%s has {00AA00}granted{33CCFF} you the leadership flags to the faction.", GetRPName(playerid));
	        SendClientMessageEx(playerid, COLOR_AQUA, "You have {00AA00}granted{33CCFF} %s the leadership flags to your faction.", GetRPName(targetid));
	        Log_Write("log_faction", "%s (uid: %i) granted leadership flags to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
		}
		else
		{
	        PlayerData[targetid][pFactionLeader] = 0;

	        SendClientMessageEx(targetid, COLOR_AQUA, "%s has {FF6347}revoked{33CCFF} your leadership flags to the faction.", GetRPName(playerid));
	        SendClientMessageEx(playerid, COLOR_AQUA, "You have {FF6347}revoked{33CCFF} %s's leadership flags to your faction.", GetRPName(targetid));
	        Log_Write("log_faction", "%s (uid: %i) revoked leadership flags from %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET factionleader = %i WHERE uid = %i", PlayerData[targetid][pFactionLeader], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "pay", true))
	{
		if(!PlayerData[playerid][pFactionMod])
		    return SendClientErrorNoPermission(playerid);

		if(FactionInfo[factionid][fType] == FACTION_HITMAN)
			return SendClientMessage(playerid, COLOR_GREY, "Hitman factions have no federal budget.");

		PlayerData[playerid][pFactionEdit] = factionid;
		ShowDialogToPlayer(playerid, DIALOG_FACTIONPAY1);
	}

	return 1;
}

CMD:division(playerid, params[])
{
	new targetid, divisionid, option[10], param[32];

	if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Hitman factions do not have access to the division system.");
	}
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /division [option]");
		if(IsGodAdmin(playerid))
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Create, Remove, List, Assign, Kick");
		else if(PlayerData[playerid][pFactionRank]>=4  || PlayerData[playerid][pFactionMod])
 			return SendClientMessage(playerid, COLOR_SYNTAX, "List of options: List, Assign, Kick");
 		else return SendClientMessage(playerid, COLOR_SYNTAX, "List of options: List");
	}
	if(!strcmp(option, "create", true))
	{
		
		if(!IsGodAdmin(playerid))
		{
			return SendClientErrorUnauthorizedCmd(playerid);
		}
		if(isnull(param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /division [create] [name]");
		}

		for(new i = 0; i < MAX_FACTION_DIVISIONS; i ++)
		{
		    if(isnull(FactionDivisions[PlayerData[playerid][pFaction]][i]))
		    {
		        strcpy(FactionDivisions[PlayerData[playerid][pFaction]][i], param, 32);
		        SendClientMessageEx(playerid, COLOR_AQUA, "You have created division {FFA763}%s{33CCFF}. The ID of this division is %i.", param, i);

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO divisions VALUES(%i, %i, '%e')", PlayerData[playerid][pFaction], i, param);
		        mysql_tquery(connectionID, queryBuffer);
		        return 1;
			}
		}

		SendClientMessageEx(playerid, COLOR_GREY, "Your faction can only have up to %i divisions.", MAX_FACTION_DIVISIONS);
	}
	else if(!strcmp(option, "remove", true))
	{
		if(!IsGodAdmin(playerid))
		{
			return SendClientErrorUnauthorizedCmd(playerid);
		}
		if(sscanf(param, "i", divisionid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /division [remove] [divisionid]");
		}
		if(!(0 <= divisionid < MAX_FACTION_DIVISIONS) || isnull(FactionDivisions[PlayerData[playerid][pFaction]][divisionid]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid division ID.");
	    }

	    foreach(new i : Player)
	    {
	        if(PlayerData[i][pFaction] == PlayerData[playerid][pFaction] && PlayerData[i][pDivision] == divisionid)
	        {
	            PlayerData[i][pDivision] = -1;
	            SendClientMessage(i, COLOR_LIGHTRED, "The division you were apart of has been deleted by the faction owner.");
		    }
		}

		SendClientMessageEx(playerid, COLOR_AQUA, "You have deleted division {F7A763}%s{33CCFF} (%i).", FactionDivisions[PlayerData[playerid][pFaction]][divisionid], divisionid);
		FactionDivisions[PlayerData[playerid][pFaction]][divisionid][0] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM divisions WHERE id = %i AND divisionid = %i", PlayerData[playerid][pFaction], divisionid);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET division = -1 WHERE faction = %i", PlayerData[playerid][pFaction]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "assign", true))
	{
	    if(PlayerData[playerid][pFactionRank]<4 &&  !PlayerData[playerid][pFactionMod] && !IsGodAdmin(playerid))
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(sscanf(param, "ui", targetid, divisionid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /division [assign] [playerid] [divisionid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pFaction] != PlayerData[playerid][pFaction])
		{
			return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your faction.");
		}
		if(!(0 <= divisionid < MAX_FACTION_DIVISIONS) || isnull(FactionDivisions[PlayerData[playerid][pFaction]][divisionid]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid division ID.");
	    }
	    if(PlayerData[targetid][pDivision] == divisionid)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of that division.");
	    }
	    if(PlayerData[targetid][pDivision] >= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of another division.");
	    }
	    if(PlayerData[playerid][pDivision] != divisionid && PlayerData[playerid][pFactionRank]<5 && !IsGodAdmin(playerid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can only assign members to your division.");
	    }

	    PlayerData[targetid][pDivision] = divisionid;

	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has assigned you to the {F7A763}%s{33CCFF} division.", GetRPName(playerid), FactionDivisions[PlayerData[playerid][pFaction]][divisionid]);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have assigned %s to the {F7A763}%s{33CCFF} division.", GetRPName(targetid), FactionDivisions[PlayerData[playerid][pFaction]][divisionid]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET division = %i WHERE uid = %i", divisionid, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "kick", true))
	{
	    if(PlayerData[playerid][pFactionRank]<4 &&  !PlayerData[playerid][pFactionMod] && !IsGodAdmin(playerid))
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /division [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pFaction] != PlayerData[playerid][pFaction])
		{
			return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your faction.");
		}
	    if(PlayerData[targetid][pDivision] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of any division.");
	    }

	    if(PlayerData[playerid][pDivision] != divisionid && PlayerData[playerid][pFactionRank]<5 && !IsGodAdmin(playerid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your division.");
	    }

	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed you from the {F7A763}%s{33CCFF} division.", GetRPName(playerid), FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[targetid][pDivision]]);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s from the {F7A763}%s{33CCFF} division.", GetRPName(targetid), FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[targetid][pDivision]]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET division = -1 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

        PlayerData[targetid][pDivision] = -1;
	}
	else if(!strcmp(option, "list", true))
	{
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Divisions List _____");

	    for(new i = 0; i < MAX_FACTION_DIVISIONS; i ++)
	    {
	        if(isnull(FactionDivisions[PlayerData[playerid][pFaction]][i]))
	        {
	            SendClientMessageEx(playerid, COLOR_GREY1, "ID: %i | Name: Empty Slot", i);
	        }
	        else
	        {
	            SendClientMessageEx(playerid, COLOR_GREY1, "ID: %i | Name: %s", i, FactionDivisions[PlayerData[playerid][pFaction]][i]);
	        }
	    }
	}

	return 1;
}

CMD:createfaction(playerid, params[])
{
	new type[12], name[48], type_id = -1;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[12]s[48]", type, name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createfaction [type] [name]");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of types: Police, Medic, News, Government, Hitman, Federal, Army");
		return 1;
	}

	if(!strcmp(type, "police", true)) {
	    type_id = FACTION_POLICE;
	} else if(!strcmp(type, "medic", true)) {
	    type_id = FACTION_MEDIC;
	} else if(!strcmp(type, "news", true)) {
	    type_id = FACTION_NEWS;
	} else if(!strcmp(type, "government", true)) {
	    type_id = FACTION_GOVERNMENT;
	} else if(!strcmp(type, "hitman", true)) {
	    type_id = FACTION_HITMAN;
	} else if(!strcmp(type, "federal", true)) {
	    type_id = FACTION_FEDERAL;
	} else if(!strcmp(type, "army", true)) {
		type_id = FACTION_ARMY;
	}

	if(type_id == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}

	for(new i = 0; i < MAX_FACTIONS; i ++)
	{
	    if(!FactionInfo[i][fType])
	    {
	        SetupFaction(i, name, type_id);

	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has created a {F7A763}%s{FF6347} faction named '%s'.", GetRPName(playerid), factionTypes[type_id], name);
	        SendClientMessageEx(playerid, COLOR_WHITE, "* This faction's ID is %i. /editfaction to edit.", i);
	        return 1;
		}
	}

    SendClientMessage(playerid, COLOR_GREY, "Faction slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editfactionleader(playerid, params[])
{
	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pFactionMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	new factionid, leader[MAX_PLAYER_NAME];

	if(sscanf(params, "is[24]", factionid, leader))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfactionleader [factionid] [leader_name]");
		SendClientMessage(playerid, COLOR_SYNTAX, "This only updates the text for the leader's name in /factions. Use /switchfaction to appoint someone as faction leader.");
		return 1;
	}
	
	if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}

	strcpy(FactionInfo[factionid][fLeader], leader, MAX_PLAYER_NAME);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET leader = '%e' WHERE id = %i", leader, factionid);
	mysql_tquery(connectionID, queryBuffer);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the leader of faction ID %i to %s.", GetRPName(playerid), factionid, leader);
	return 1;
}

CMD:editfaction(playerid, params[])
{
	new factionid, option[12], param[48];

	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[12]S()[48]", factionid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, Shortname, Type, Color, RankCount, RankName, Skin, Paycheck, Leader, TurfTokens, Budget");
		return 1;
	}
	if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}

	if(!strcmp(option, "name", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [name] [text]");
		}

		strcpy(FactionInfo[factionid][fName], param, 48);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET name = '%e' WHERE id = %i", param, factionid);
		mysql_tquery(connectionID, queryBuffer);

  		ReloadLockers(factionid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the name of faction ID %i to '%s'.", GetRPName(playerid), factionid, param);
	}
	else if(!strcmp(option, "shortname", true))
	{
	    if(isnull(param) || strlen(param) > 24)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [shortname] [text]");
		}

		strcpy(FactionInfo[factionid][fShortName], param, 24);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET shortname = '%e' WHERE id = %i", param, factionid);
		mysql_tquery(connectionID, queryBuffer);

  		ReloadLockers(factionid);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the short name of faction ID %i to '%s'.", GetRPName(playerid), factionid, param);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type_id;

	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [type] [option]");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of types: Police, Medic, News, Government, Hitman, Federal, Army");
			return 1;
		}

		if(!strcmp(param, "police", true)) {
		    type_id = FACTION_POLICE;
		} else if(!strcmp(param, "medic", true)) {
		    type_id = FACTION_MEDIC;
		} else if(!strcmp(param, "news", true)) {
		    type_id = FACTION_NEWS;
		} else if(!strcmp(param, "government", true)) {
		    type_id = FACTION_GOVERNMENT;
		} else if(!strcmp(param, "hitman", true)) {
		    type_id = FACTION_HITMAN;
		} else if(!strcmp(param, "federal", true)) {
		    type_id = FACTION_FEDERAL;
		} else if(!strcmp(param, "army", true)) {
			type_id = FACTION_ARMY;
		}

		if(type_id == -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

		FactionInfo[factionid][fType] = type_id;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET type = %i WHERE id = %i", type_id, factionid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the type of faction ID %i to %s.", GetRPName(playerid), factionid, factionTypes[type_id]);
	}
	else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [color] [0xRRGGBBAA]");
		}

		FactionInfo[factionid][fColor] = color & ~0xff;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET color = %i WHERE id = %i", FactionInfo[factionid][fColor], factionid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of faction ID %i.", GetRPName(playerid), color >>> 8, factionid);
	}
	else if(!strcmp(option, "rankcount", true))
	{
	    new ranks;

	    if(sscanf(param, "i", ranks))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [rankcount] [amount]");
		}
		if(!(1 <= ranks <= MAX_FACTION_RANKS))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "The amount of ranks must range from 1 to %i.", MAX_FACTION_RANKS);
		}

		FactionInfo[factionid][fRankCount] = ranks;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET rankcount = %i WHERE id = %i", ranks, factionid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the rank count of faction ID %i to %i.", GetRPName(playerid), factionid, ranks);
	}
	else if(!strcmp(option, "rankname", true))
	{
	    new rankid, rank[32];

	    if(sscanf(param, "is[32]", rankid, rank))
	    {
	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Rank Names ______");

	        for(new i = 0; i < FactionInfo[factionid][fRankCount]; i ++)
	        {
	            if(isnull(FactionRanks[factionid][i]))
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: %s", i, FactionRanks[factionid][i]);
	        }

	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [rankname] [slot (0-%i)] [name]", FactionInfo[factionid][fRankCount] - 1);
	    }
	    if(!(0 <= rankid < FactionInfo[factionid][fRankCount]))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
		}

	    strcpy(FactionRanks[factionid][rankid], rank, 32);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", factionid, rankid, rank, rank);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's name of faction ID %i to '%s'.", GetRPName(playerid), rankid, factionid, rank);
	}
	else if(!strcmp(option, "skin", true))
	{
	    new slot, skinid;

	    if(sscanf(param, "ii", slot, skinid))
	    {
	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Faction Skins ______");

	        for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	        {
	            if(FactionInfo[factionid][fSkins][i] == 0)
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, FactionInfo[factionid][fSkins][i]);
	        }

	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [skin] [slot (1-%i)] [skinid]", MAX_FACTION_SKINS);
	    }
	    if(!(1 <= slot <= MAX_FACTION_SKINS))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
		}
		if(!(1 <= skinid <= 311))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid skin.");
		}

		slot--;

		FactionInfo[factionid][fSkins][slot] = skinid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", factionid, slot, skinid, skinid);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_WHITE, "* You have set the skin in slot %i to ID %i.", slot + 1, skinid);
	}
	else if(!strcmp(option, "paycheck", true))
	{
	    new rankid, amount;

        if(FactionInfo[factionid][fType] == FACTION_HITMAN)
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You can't set the paychecks for hitman factions.");
		}
	    if(sscanf(param, "ii", rankid, amount))
	    {
	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Rank Paychecks ______");

	        for(new i = 0; i < FactionInfo[factionid][fRankCount]; i ++)
	        {
	            if(isnull(FactionRanks[factionid][i]))
	            	SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
				else
				    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: %s ($%i)", i, FactionRanks[factionid][i], FactionInfo[factionid][fPaycheck][i]);
	        }

	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [paycheck] [slot (0-%i)] [amount]", FactionInfo[factionid][fRankCount] - 1);
	    }
	    if(!(0 <= rankid < FactionInfo[factionid][fRankCount]))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
		}
		if(!(0 <= amount <= 100000))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The amount must range from $0 to $100000.");
		}

	    FactionInfo[factionid][fPaycheck][rankid] = amount;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionpay VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE amount = %i", factionid, rankid, amount, amount);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's paycheck of faction ID %i to $%i.", GetRPName(playerid), rankid, factionid, amount);
	}
	else if(!strcmp(option, "leader", true))
	{
	    new leader[MAX_PLAYER_NAME];

	    if(sscanf(param, "s[24]", leader))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [leader] [name]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "This only updates the text for the leader's name in /factions. Use /switchfaction to appoint someone as faction leader.");
			return 1;
		}

		strcpy(FactionInfo[factionid][fLeader], leader, MAX_PLAYER_NAME);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET leader = '%e' WHERE id = %i", leader, factionid);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the leader of faction ID %i to %s.", GetRPName(playerid), factionid, leader);
	}
	else if(!strcmp(option, "locker", true))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This option has been removed in favor of the dynamic locker system.");
	    SendClientMessage(playerid, COLOR_WHITE, "Use /dynamichelp for a list of commands related to dynamic lockers.");
	}
    else if(!strcmp(option, "turftokens", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [turftokens] [amount]");
		}
		if(FactionInfo[factionid][fType] != FACTION_POLICE && FactionInfo[factionid][fType] != FACTION_FEDERAL && FactionInfo[factionid][fType] != FACTION_ARMY)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can only set the turf tokens for police factions.");
		}

		FactionInfo[factionid][fTurfTokens] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET turftokens = %i WHERE id = %i", amount, factionid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the turf tokens of faction ID %i to %i.", GetRPName(playerid), factionid, amount);
	}
	else if(!strcmp(option, "budget", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editfaction [factionid] [budget] [amount (max 100k)]");
		}
		if(amount > 100000)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Faction budget cannot be over $100,000!");
		}
		FactionInfo[factionid][fBudget] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET budget = %i WHERE id = %i", FactionInfo[factionid][fBudget], factionid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set %s's faction budget to %i.", GetRPName(playerid), FactionInfo[factionid][fName], amount);
	}

	return 1;
}

CMD:purgefaction(playerid, params[])
{
	new factionid;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pFactionMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /purgefaction [factionid]");
	}
	if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pFaction] == factionid)
	    {
	        SetPlayerFaction(i, -1);
	        SendClientMessageEx(i, COLOR_LIGHTRED, "The faction you were apart of has been purged by an administrator.");
		}
	}

	strcpy(FactionInfo[factionid][fLeader], "No-one", MAX_PLAYER_NAME);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET faction = -1, factionrank = 0, division = -1 WHERE faction = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET leader = 'No-one' WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has purged faction %s.", GetRPName(playerid), FactionInfo[factionid][fName]);
	Log_Write("log_faction", "%s (uid: %i) has purged faction %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], FactionInfo[factionid][fName], factionid);

	return 1;
}

CMD:removefaction(playerid, params[])
{
	new factionid;

	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", factionid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removefaction [factionid]");
	}
	if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has deleted faction %s.", GetRPName(playerid), FactionInfo[factionid][fName]);
	RemoveFaction(factionid);
	Log_Write("log_faction", "%s (uid: %i) has deleted faction %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], FactionInfo[factionid][fName], factionid);
	return 1;
}

CMD:switchfaction(playerid, params[])
{
	new targetid, factionid, rankid, leader;

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pFactionMod] && PlayerData[playerid][pGameAffairs])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uiI(-1)I(0)", targetid, factionid, rankid, leader))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /switchfaction [playerid] [factionid (-1 = none)] [rank (optional)] [leader (0/1)]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!(-1 <= factionid < MAX_FACTIONS) || (factionid >= 0 && FactionInfo[factionid][fType] == FACTION_NONE))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
	}
	if((factionid != -1 && !(-1 <= rankid < FactionInfo[factionid][fRankCount])))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
	}

	if(factionid == -1)
	{
        SetPlayerFaction(targetid, -1);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed you from your faction.", GetRPName(playerid));
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s from their faction.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
		if(rankid == -1)
		{
	    	rankid = FactionInfo[factionid][fRankCount] - 1;
		}

	    SetPlayerFaction(targetid, factionid, rankid, leader);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {00AA00}%s{33CCFF} in %s.", GetRPName(playerid), FactionRanks[factionid][rankid], FactionInfo[factionid][fName]);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s in %s.", GetRPName(playerid), GetRPName(targetid), FactionRanks[factionid][rankid], FactionInfo[factionid][fName]);
	}

	return 1;
}

CMD:fmembers(playerid, params[])
{
	if(PlayerData[playerid][pFaction] == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not apart of any faction.");
	}

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____________ Members Online _____________");
    new string[128], color = FactionInfo[PlayerData[playerid][pFaction]][fColor];

    foreach(new i : Player)
    {
        if(PlayerData[i][pFaction] == PlayerData[playerid][pFaction] && !PlayerData[i][pAdminHide])
        {
			if(PlayerData[playerid][pDuty])
            	format(string, sizeof(string), "(ID: %i) %s {%06x}%s{FFFFFF}", i, FactionRanks[PlayerData[i][pFaction]][PlayerData[i][pFactionRank]], color >>> 8, GetRPName(i));
			else format(string, sizeof(string), "(ID: %i) %s %s{FFFFFF}", i, FactionRanks[PlayerData[i][pFaction]][PlayerData[i][pFactionRank]],GetRPName(i));
			if(PlayerData[i][pDivision] >= 0)
			{
			    format(string, sizeof(string), "%s | Division: %s", string, FactionDivisions[PlayerData[i][pFaction]][PlayerData[i][pDivision]]);
			}
			if(PlayerData[i][pFactionLeader])
			{
			    format(string, sizeof(string), "%s | {06FF00}Leader{FFFFFF}", string);
			}
			if(FactionInfo[PlayerData[i][pFaction]][fType] == FACTION_MEDIC)
			{
			    format(string, sizeof(string), "%s | Total Patients: %i | Total Fires: %i", string, PlayerData[i][pTotalPatients], PlayerData[i][pTotalFires]);
			}
			format(string, sizeof(string), "%s | Location: %s", string, GetPlayerZoneName(i));
			if(IsPlayerAFK(i))
            {
				format(string, sizeof(string), "%s | {FFA500}AFK{FFFFFF} (%d secs)", string, GetAFKTime(i));
			}
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
    }

	return 1;
}

CMD:drag(playerid, params[])
{
    new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /drag [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't drag yourself.");
	}
	if(IsPlayerInAnyVehicle(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command when player is in a vehicle use [/eject].");
    }
	if(!PlayerData[targetid][pInjured] && !PlayerData[targetid][pCuffed] && !PlayerData[targetid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not injured, handcuffed or tied.");
	}
	if(PlayerData[targetid][pInjured] && GetPlayerFaction(playerid) != FACTION_MEDIC)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't drag an injured player unless you're a medic.");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to drag anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}
    new string[128];

	if(PlayerData[targetid][pDraggedBy] == INVALID_PLAYER_ID)
	{
		PlayerData[targetid][pDraggedBy] = playerid;
        format(string, sizeof(string), "* %s grabs onto %s and begins to drag them.", GetRPName(playerid), GetRPName(targetid));
	}
	else
	{
	    PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;
		format(string, sizeof(string), "* %s stops dragging %s.", GetRPName(playerid), GetRPName(targetid));
	}
    SendClientMessageEx(playerid, COLOR_PURPLE, string);
    ShowActionBubble(playerid, string);

	return 1;
}

CMD:deploy(playerid, params[])
{
	new type[12], type_id = -1, Float:x, Float:y, Float:z, Float:a;

    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}
    if(PlayerData[playerid][pFactionRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't R4+.");
    }
	if(sscanf(params, "s[12]", type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deploy [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Spikestrip, Cone, Roadblock, Barrel, Flare");
	    return 1;
	}
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while being in a vehicle");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't deploy objects inside.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	if(!strcmp(type, "spikestrip", true)) {
	    type_id = DEPLOY_SPIKESTRIP;
	} else if(!strcmp(type, "cone", true)) {
		type_id = DEPLOY_CONE;
	} else if(!strcmp(type, "roadblock", true)) {
	    type_id = DEPLOY_ROADBLOCK;
	} else if(!strcmp(type, "barrel", true)) {
	    type_id = DEPLOY_BARREL;
	} else if(!strcmp(type, "flare", true)) {
	    type_id = DEPLOY_FLARE;
	}

	if(type_id == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}
	if(DeployObject(type_id, x, y, z, a) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The deployable objects pool is full. Try deleting some first.");
	}

	if(IsLawEnforcement(playerid))
		SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has deployed a %s in %s.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), deployableItems[type_id], GetZoneName(x, y, z));
	else
	    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_DOCTOR, "* HQ: %s %s has deployed a %s in %s.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), deployableItems[type_id], GetZoneName(x, y, z));

	return 1;
}
CMD:undeployall(playerid, params[])
{
	if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}

	for(new i = 0; i < MAX_DEPLOYABLES; i ++)
	{
		if(DeployInfo[i][dExists])
	 	{
			DestroyDynamicObject(DeployInfo[i][dObject]);
			DeployInfo[i][dExists] = 0;
   			DeployInfo[i][dType] = -1;
		}
	}
	SendFactionMessage(PlayerData[playerid][pFaction], (IsLawEnforcement(playerid)) ? (COLOR_OLDSCHOOL) : (COLOR_DOCTOR), "* HQ: %s %s has removed all deployed objects.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
	return 1;
}
CMD:undeploy(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}

    for(new i = 0; i < MAX_DEPLOYABLES; i ++)
    {
        if(DeployInfo[i][dExists])
        {
            new Float:range;

            if(DeployInfo[i][dType] == DEPLOY_SPIKESTRIP || DeployInfo[i][dType] == DEPLOY_BARREL || DeployInfo[i][dType] == DEPLOY_FLARE || DeployInfo[i][dType] == DEPLOY_CONE) {
                range = 2.0;
            } else if(DeployInfo[i][dType] == DEPLOY_ROADBLOCK) {
                range = 5.0;
            }

        	if(IsPlayerInRangeOfPoint(playerid, range, DeployInfo[i][dPosX], DeployInfo[i][dPosY], DeployInfo[i][dPosZ]))
        	{
      	  		SendFactionMessage(PlayerData[playerid][pFaction], (IsLawEnforcement(playerid)) ? (COLOR_OLDSCHOOL) : (COLOR_DOCTOR), "* HQ: %s %s has removed a %s in %s.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), deployableItems[DeployInfo[i][dType]], GetZoneName(DeployInfo[i][dPosX], DeployInfo[i][dPosY], DeployInfo[i][dPosZ]));
				DestroyDynamicObject(DeployInfo[i][dObject]);

        	    DeployInfo[i][dExists] = 0;
        	    DeployInfo[i][dType] = -1;
        	    return 1;
			}
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any deployed objects.");
	return 1;
}

CMD:hfind(playerid, params[])
{
	new targetid;

    if(GetPlayerFaction(playerid) != FACTION_HITMAN && GetPlayerFaction(playerid) != FACTION_FEDERAL)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman or federal agent.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hfind [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(GetPlayerInterior(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player is an interior. You can't find them at the moment.");
	}
	if(PlayerData[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on an on duty administrator.");
	}

	PlayerData[playerid][pFindTime] = 15;
	PlayerData[playerid][pFindPlayer] = targetid;

    SetPlayerMarkerForPlayer(playerid, targetid, 0xF70000FF);
	SendClientMessageEx(playerid, COLOR_WHITE, "* %s's location marked on your radar. 15 seconds remain until the marker disappears.", GetRPName(targetid));
	return 1;
}

CMD:passport(playerid, params[])
{
	new name[24], level, skinid;

    if(PlayerData[playerid][pPassport])
	{
  		Namechange(playerid, GetPlayerNameEx(playerid), PlayerData[playerid][pPassportName]);
  		SetScriptSkin(playerid, PlayerData[playerid][pPassportSkin]);
		SendClientMessage(playerid, COLOR_AQUA, "You have burned your passport and received your old name, clothes, level and number back.");

		PlayerData[playerid][pLevel] = PlayerData[playerid][pPassportLevel];
		PlayerData[playerid][pPhone] = PlayerData[playerid][pPassportPhone];
		PlayerData[playerid][pPassport] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET passport = 0, passportname = 'None', passportlevel = 0, passportskin = 0, passportphone = 0, level = %i, phone = %i WHERE uid = %i", PlayerData[playerid][pLevel], PlayerData[playerid][pPhone], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}

    if (GetPlayerFaction(playerid) != FACTION_HITMAN &&
        GetPlayerFaction(playerid) != FACTION_FEDERAL &&
        GetPlayerFaction(playerid) != FACTION_TERRORIST &&
        GetPlayerFaction(playerid) != FACTION_GOVERNMENT &&
        !(PlayerData[playerid][pGang] != -1 && GangInfo[PlayerData[playerid][pGang]][gIsMafia]))
    {
     
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman or federal agent.");
    }
	if(sscanf(params, "s[24]ii", name, level, skinid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /passport [name] [level] [skinid]");
	}
	if(!(3 <= strlen(name) <= 20))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your name must range from 3 to 20 characters.");
	}
	if(strfind(name, "_") == -1 || name[strlen(name)-1] == '_')
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your name needs to contain at least one underscore.");
	}
	if(!IsValidUsername(name))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid characters. Your name may only contain letters and underscores.");
	}
	if(PlayerData[playerid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't allowed to change your name while on admin duty,");
	}
	if(!(1 <= level <= PlayerData[playerid][pLevel]))
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "Your level must range from 1 to %d.", PlayerData[playerid][pLevel]);
	}
	if(!(1 <= skinid <= 311))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The skin ID must range from 0 to 311.");
	}
	if(!isnull(PlayerData[playerid][pNameChange]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have already requested a namechange. Please wait for a response.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnHitmanPassport", "isii", playerid, name, level, skinid);
	return 1;
}

CMD:factionpark(playerid, params[])
{
	return callcmd::fpark(playerid, params);
}

CMD:fpark(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

	if(!IsGodAdmin(playerid) && !PlayerData[playerid][pFactionMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any of your faction vehicles.");
	}
	if(VehicleInfo[vehicleid][vFaction] != PlayerData[playerid][pFaction])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't park this vehicle as it doesn't belong to your faction.");
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

	SendClientMessage(playerid, COLOR_GREEN, "* Faction vehicle parked. It will now spawn here.");

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

CMD:badge(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(!PlayerData[playerid][pDuty])
	{
	    if(IsPlayerInEvent(playerid) || PlayerData[playerid][pPaintballTeam] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can not put on your badge on while in a event or paintball match.");
		}
	    PlayerData[playerid][pDuty] = 1;
	    SendClientMessage(playerid, COLOR_WHITE, "You have enabled your badge. Your nametag color now shows for all players.");
	}
	else
	{
	    PlayerData[playerid][pDuty] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "You have disabled your badge. Your nametag color no longer shows for any players.");
	}

	return 1;
}

