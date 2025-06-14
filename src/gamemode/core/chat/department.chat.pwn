CMD:d(playerid, params[])
{
	new header[128];

    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /d [department radio]");
	}
	if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(PlayerData[playerid][pToggleRadio])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in your radio as you have it toggled.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /d if you're dead!");
	}
	if(PlayerData[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
	if(PlayerData[playerid][pCuffed])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}

    if(!strcmp(FactionInfo[PlayerData[playerid][pFaction]][fShortName], "None", true))
	{
	    if(PlayerData[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerData[playerid][pFaction]][fName], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerData[playerid][pFaction]][fName], FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
		}
	}
	else
	{
		if(PlayerData[playerid][pDivision] == -1)
	    {
		    format(header, sizeof(header), "(%s) %s %s", FactionInfo[PlayerData[playerid][pFaction]][fShortName], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
		}
		else
		{
		    format(header, sizeof(header), "(%s) [%s] %s %s", FactionInfo[PlayerData[playerid][pFaction]][fShortName], FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
		}
	}

	switch(FactionInfo[PlayerData[playerid][pFaction]][fType])
	{
	    case FACTION_POLICE, FACTION_MEDIC, FACTION_GOVERNMENT, FACTION_FEDERAL, FACTION_ARMY, FACTION_NEWS:
	    {
			foreach(new i : Player)
			{
			    if(((PlayerData[i][pPoliceScanner] && PlayerData[i][pScannerOn]) || ((!PlayerData[i][pToggleRadio]) && (GetPlayerFaction(i) == FACTION_POLICE || GetPlayerFaction(i) == FACTION_MEDIC || GetPlayerFaction(i) == FACTION_GOVERNMENT || GetPlayerFaction(i) == FACTION_FEDERAL || GetPlayerFaction(i) == FACTION_ARMY || GetPlayerFaction(i) == FACTION_NEWS)))  && PlayerData[i][pLogged]) 
			    {
       				if(strlen(params) > MAX_SPLIT_LENGTH)
			        {
			            SendClientMessageEx(i, COLOR_YELLOW, "* %s: %.*s... *", header, MAX_SPLIT_LENGTH, params);
				        SendClientMessageEx(i, COLOR_YELLOW, "* %s: ...%s *", header, params[MAX_SPLIT_LENGTH]);
					}
					else
					{
					    SendClientMessageEx(i, COLOR_YELLOW, "* %s: %s *", header, params);
					}

					if((PlayerData[i][pPoliceScanner] && PlayerData[i][pScannerOn]) && random(100) <= 3)
		            {
		                SendProximityMessage(i, 20.0, COLOR_PURPLE, "* %s's police scanner would shoot a spark and short out.", GetRPName(i));
		                SendClientMessage(i, COLOR_GREY2, "Your police scanner shorted out and is now broken.");

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET policescanner = 0, scanneron = 0 WHERE uid = %i", PlayerData[i][pID]);
		                mysql_tquery(connectionID, queryBuffer);

		            	PlayerData[i][pPoliceScanner] = 0;
		            	PlayerData[i][pScannerOn] = 0;
					}
				}
			}
		}
		default:
		{
		    SendClientMessage(playerid, COLOR_GREY, "Your faction is not authorized to speak in department radio.");
		}
	}

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "[Radio]: %s", params);
	return 1;
}