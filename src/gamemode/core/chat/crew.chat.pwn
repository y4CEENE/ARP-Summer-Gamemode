
CMD:crew(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [crew chat]");
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(PlayerData[playerid][pCrew] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any crew in your gang.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pGang] == PlayerData[playerid][pGang] && PlayerData[i][pCrew] == PlayerData[playerid][pCrew] && PlayerData[i][pLogged])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
		        SendClientMessageEx(i, COLOR_LIGHTORANGE, "* [%s] %s %s: %.*s... *", GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		        SendClientMessageEx(i, COLOR_LIGHTORANGE, "* [%s] %s %s: ...%s *", GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SendClientMessageEx(i, COLOR_LIGHTORANGE, "* [%s] %s %s: %s *", GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), params);
			}
		}
	}

	return 1;
}
