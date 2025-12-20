CMD:r(playerid, params[])
{
	return callcmd::radio(playerid, params);
}

CMD:radio(playerid, params[])
{
    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(r)adio [faction radio]");
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
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /r if you're dead!");
	}
	if(PlayerData[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /r while tied.");
	}
	foreach(new i : Player)
	{
	    if(((PlayerData[i][pFaction] == PlayerData[playerid][pFaction] && !PlayerData[i][pToggleRadio]) || (PlayerData[i][pPoliceScanner] && PlayerData[i][pScannerOn] && IsEmergencyFaction(playerid))) && PlayerData[i][pLogged])
	    {
	        new color = (FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_MEDIC) ? (COLOR_DOCTOR) : (COLOR_OLDSCHOOL);

			if(strlen(params) > MAX_SPLIT_LENGTH)
			{
			    if(PlayerData[playerid][pDivision] == -1)
			    {
				    SendClientMessageEx(i, color, "* %s %s: %.*s... *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
				    SendClientMessageEx(i, color, "* %s %s: ...%s *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
				}
				else
				{
				    SendClientMessageEx(i, color, "* [%s] %s %s: %.*s... *", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
				    SendClientMessageEx(i, color, "* [%s] %s %s: ...%s *", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
				}
			}
			else
			{
			    if(PlayerData[playerid][pDivision] == -1)
			    {
				    SendClientMessageEx(i, color, "* %s %s: %s *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
				}
				else
				{
				    SendClientMessageEx(i, color, "* [%s] %s %s: %s *", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
				}
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

	SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "[Radio]: %s", params);

	return 1;
}