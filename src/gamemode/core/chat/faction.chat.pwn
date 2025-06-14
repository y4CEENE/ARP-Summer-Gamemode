CMD:fc(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /f [faction chat]");
	}
	if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
    if(PlayerData[playerid][pToggleFaction])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the faction chat as you have it toggled.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /f if you're dead!");
	}
	if(PlayerData[playerid][pTied])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cant speak in /f while tied.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pFaction] == PlayerData[playerid][pFaction] && !PlayerData[i][pToggleFaction] && PlayerData[i][pLogged])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
		        SendClientMessageEx(i, COLOR_FACTIONCHAT, "(( %s %s: %.*s... ))", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SendClientMessageEx(i, COLOR_FACTIONCHAT, "(( %s %s: ...%s ))", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
   			{
			    SendClientMessageEx(i, COLOR_FACTIONCHAT, "(( %s %s: %s ))", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
			}
		}
	}

	return 1;
}