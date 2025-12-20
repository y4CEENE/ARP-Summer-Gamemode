GiveNotoriety(playerid, value)
{
	PlayerData[playerid][pNotoriety] += value;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET notoriety = %i WHERE uid = %i", PlayerData[playerid][pNotoriety], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
}


forward OnPlayerListAllFactions(playerid);
public OnPlayerListAllFactions(playerid)
{
	new str[1024];
	str = " ID\t Name\t Leader\t Members";

    new sqlcount=cache_get_row_count(connectionID);
	new sqlidx=0;
    new currentfactionid,currentmemberscount;

	if(sqlcount==0)
	{
		currentfactionid=-1;
		currentmemberscount=0;
	}else{
		currentfactionid = cache_get_row_int(0,0);
		currentmemberscount = cache_get_row_int(0,1);
	}
	for(new i = 0; i < MAX_FACTIONS; i ++)
	{
	    if(FactionInfo[i][fType] != FACTION_NONE)
	    {
			new members=0;
			if(currentfactionid == i)
			{
				members=currentmemberscount;
				if(sqlidx + 1 < sqlcount){
					sqlidx++;
					currentfactionid = cache_get_row_int(sqlidx, 0);
					currentmemberscount = cache_get_row_int(sqlidx, 1);
				}else{
					currentfactionid=-1;
					currentmemberscount=0;
				}
			}

			new color = (FactionInfo[i][fColor] == -1 || FactionInfo[i][fColor] == -256)? 0xC8C8C8FF:FactionInfo[i][fColor];

			if(FactionInfo[i][fType] == FACTION_HITMAN && PlayerData[playerid][pAdmin] < ASST_MANAGEMENT)
				format(str, sizeof(str), "%s\n %i \t {%06x}%s{FFFFFF} \t Classified \t Classified", str, i, color >>> 8, FactionInfo[i][fName]);
			else
				format(str, sizeof(str), "%s\n %i \t {%06x}%s{FFFFFF} \t %s \t %i", str, i, color >>> 8, FactionInfo[i][fName], FactionInfo[i][fLeader], members);
	    }
	}

	Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "{00FF00}* List of Factions *", str, "Cancel", "");
}


forward OnPlayerOfflineKickFaction(playerid, username[]);
public OnPlayerOfflineKickFaction(playerid, username[])
{
    if(!cache_get_row_count(connectionID))
	{
	    SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
	}
	else if(cache_get_row_int(0, 1) != PlayerData[playerid][pFaction])
	{
	    SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your faction.");
	}
	/*else if(cache_get_row_int(0, 2) > PlayerData[playerid][pFactionRank])
	{
	    SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
	}*/
	else
	{
	    new uid = cache_get_row_int(0, 0), factionid = cache_get_row_int(0, 1), rankid = cache_get_row_int(0, 2);

		Log_Write("log_faction", "%s (uid: %i) offline kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, uid, FactionInfo[factionid][fName], factionid, FactionRanks[factionid][rankid], rankid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET faction = -1, factionrank = 0, factionleader = 0, division = -1 WHERE uid = %i", uid);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "You have offline kicked %s from your faction.", username);
	}
}



RemoveFaction(factionid)
{
	foreach(new i : Player)
	{
	    if(PlayerData[i][pFaction] == factionid)
	    {
			SetPlayerFaction(i, -1);
	        SendClientMessageEx(i, COLOR_LIGHTRED, "The faction you were apart of has been deleted by an administrator.");
	    }
	}

	DestroyDynamic3DTextLabel(FactionInfo[factionid][fText]);
	DestroyDynamicPickup(FactionInfo[factionid][fPickup]);

    FactionInfo[factionid][fName] = 0;
    FactionInfo[factionid][fLeader] = 0;
	FactionInfo[factionid][fType] = FACTION_NONE;
	FactionInfo[factionid][fColor] = 0;
	FactionInfo[factionid][fRankCount] = 0;
    FactionInfo[factionid][fTurfTokens] = 0;
    FactionInfo[factionid][fText] = Text3D:INVALID_3DTEXT_ID;
    FactionInfo[factionid][fPickup] = -1;

    for(new i = 0; i < MAX_FACTION_RANKS; i ++)
    {
        strcpy(FactionRanks[factionid][i], "Unspecified", 32);
        FactionInfo[factionid][fPaycheck][i] = 0;
	}

	for(new i = 0; i < MAX_FACTION_DIVISIONS; i ++)
	{
	    FactionDivisions[factionid][i][0] = 0;
	}


	for(new i = 0; i < MAX_LOCKERS; i ++)
	{
		if(LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
		{
		    DestroyDynamic3DTextLabel(LockerInfo[i][lText]);
		    DestroyDynamicPickup(LockerInfo[i][lPickup]);
		    LockerInfo[i][lExists] = 0;
		}
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factions WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionranks WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionskins WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionpay WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM divisions WHERE id = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionlockers WHERE factionid = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET faction = -1, factionrank = 0, factionleader = 0, division = -1 WHERE faction = %i", factionid);
	mysql_tquery(connectionID, queryBuffer);
}

GetFactionSkinCount(factionid)
{
	new count;

	for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	{
	    if(FactionInfo[factionid][fSkins][i] != 0)
	    {
	        count++;
		}
	}

	return count;
}
GetTotalFactionPay(factionid)
{
	new amount;

    for(new i = 0; i < FactionInfo[factionid][fRankCount]; i ++)
    {
        amount += FactionInfo[factionid][fPaycheck][i];
	}

	return amount;
}
GetPlayerFaction(playerid)
{
	if(PlayerData[playerid][pFaction] >= 0)
	{
	    return FactionInfo[PlayerData[playerid][pFaction]][fType];
	}

	return FACTION_NONE;
}

SetPlayerFaction(playerid, factionid, rank = 0, leader = 0)
{
	// This needed its own function because I got fed up of having to put "[pFaction] = -1" everywhere.

	if(factionid == -1)
	{
	    if(PlayerData[playerid][pFaction] >= 0)
	    {
	        SetScriptSkin(playerid, 230);
	        ResetPlayerWeaponsEx(playerid);
	    }

	    PlayerData[playerid][pFaction] = -1;
	    PlayerData[playerid][pFactionRank] = 0;
	    PlayerData[playerid][pFactionLeader] = 0;
	    PlayerData[playerid][pDivision] = -1;
	    PlayerData[playerid][pDuty] = 0;
	    PlayerData[playerid][pTazer] = 0;
	}
	else if((0 <= factionid < MAX_FACTIONS) && FactionInfo[factionid][fType] != FACTION_NONE)
	{
	    if(PlayerData[playerid][pFaction] >= 0 && factionid != PlayerData[playerid][pFaction])
	    {
	        PlayerData[playerid][pDivision] = -1;
	    }

	    PlayerData[playerid][pFaction] = factionid;
	    PlayerData[playerid][pFactionRank] = rank;
	    PlayerData[playerid][pFactionLeader] = leader;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET faction = %i, factionrank = %i, division = %i, factionleader = %i WHERE uid = %i", PlayerData[playerid][pFaction], PlayerData[playerid][pFactionRank], PlayerData[playerid][pDivision], PlayerData[playerid][pFactionLeader], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
}

SetupFaction(factionid, name[], type)
{
    strcpy(FactionInfo[factionid][fName], name, 48);
    strcpy(FactionInfo[factionid][fShortName], "None", 24);
    strcpy(FactionInfo[factionid][fMOTD], "None", 128);
	strcpy(FactionInfo[factionid][fLeader], "No-one", MAX_PLAYER_NAME);

    FactionInfo[factionid][fType] = type;
    FactionInfo[factionid][fColor] = 0xFFFFFF00;
    FactionInfo[factionid][fRankCount] = 6;
    FactionInfo[factionid][fTurfTokens] = 0;
    FactionInfo[factionid][fText] = Text3D:INVALID_3DTEXT_ID;
    FactionInfo[factionid][fPickup] = -1;

    for(new i = 0; i < MAX_FACTION_RANKS; i ++)
    {
        strcpy(FactionRanks[factionid][i], "Unspecified", 32);
        FactionInfo[factionid][fPaycheck][i] = 0;
	}
	for(new i = 0; i < MAX_FACTION_SKINS; i ++)
	{
	    FactionInfo[factionid][fSkins][i] = 0;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factions (id, name, type) VALUES(%i, '%e', %i)", factionid, name, type);
	mysql_tquery(connectionID, queryBuffer);
}

IsPlayerInRangeOfLocker(playerid, factionid)
{
	new lockerid;

	if((lockerid = GetNearbyLocker(playerid)) >= 0 && LockerInfo[lockerid][lFaction] == factionid)
	{
	    return 1;
	}

	return 0;
}

IsFireActive()
{
	for(new i = 0; i < MAX_FIRES; i ++)
	{
	    if(IsValidDynamicObject(gFireObjects[i]))
	    {
	        return 1;
		}
	}

	return 0;
}
