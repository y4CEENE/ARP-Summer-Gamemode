CMD:hc(playerid, params[])
{
	if(PlayerData[playerid][pHelper] < 1 && PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hc [helper chat]");
	}
	if(PlayerData[playerid][pToggleHelper])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the helper chat as you have it toggled.");
	}

	foreach(new i : Player)
	{
		if((PlayerData[i][pHelper] > 0 || PlayerData[i][pAdmin] > 0) && !PlayerData[i][pToggleHelper] && PlayerData[i][pLogged])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SendStaffMessage(0xBDF38BFF, "* %s %s: %.*s... *", GetStaffRank(playerid), GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	            SendStaffMessage(0xBDF38BFF, "* %s %s: ...%s *", GetStaffRank(playerid), GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
				SendStaffMessage(0xBDF38BFF, "* %s %s: %s *", GetStaffRank(playerid), GetRPName(playerid), params);
			}
			return 1;
		}
	}
	return 1;
}