CMD:div(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /div [division chat]");
	}
	if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
	if(PlayerData[playerid][pDivision] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any divisions in your faction.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pFaction] == PlayerData[playerid][pFaction] && PlayerData[i][pDivision] == PlayerData[playerid][pDivision] && PlayerData[i][pLogged])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
		        SendClientMessageEx(i, COLOR_LIGHTORANGE, "* [%s] %s %s: %.*s... *", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SendClientMessageEx(i, COLOR_LIGHTORANGE, "* [%s] %s %s: ...%s *", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SendClientMessageEx(i, COLOR_LIGHTORANGE, "* [%s] %s %s: %s *", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]], FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
			}
		}
	}

	return 1;
}