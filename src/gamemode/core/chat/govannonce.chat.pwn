
CMD:gov(playerid, params[])
{
    if(PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
	}
 	if(PlayerData[playerid][pFactionRank] < 4)
 	{
 	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gov [text]");
	}

	switch(FactionInfo[PlayerData[playerid][pFaction]][fType])
	{
	    case FACTION_MEDIC:
	    {
	        if(!PlayerData[playerid][pGovTimer])
	        	SendClientMessageToAll(COLOR_GREY1, "____________ Public Service Announcement ____________");

			SendClientMessageToAllEx(COLOR_DOCTOR, "* %s %s: %s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
			PlayerData[playerid][pGovTimer] = 30;
		}
		case FACTION_POLICE:
		{
            if(!PlayerData[playerid][pGovTimer])
	        	SendClientMessageToAll(COLOR_GREY1, "____________ Public Service Announcement ____________");

			SendClientMessageToAllEx(COLOR_BLUE, "* %s %s: %s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
			PlayerData[playerid][pGovTimer] = 30;
		}
        case FACTION_GOVERNMENT:
		{
		    if(!PlayerData[playerid][pGovTimer])
            {
                // tobe rollbacked after adding terrorist faction
                new ss[128];
                format(ss,sizeof(ss), "____________ %s News Announcement ____________", FactionInfo[PlayerData[playerid][pFaction]][fName]);
                SendClientMessageToAll(COLOR_GREY1, ss);
            }
	        	

			SendClientMessageToAllEx(COLOR_BLUE, "* %s %s: %s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
			PlayerData[playerid][pGovTimer] = 30;
		}
		case FACTION_FEDERAL:
		{
		    if(!PlayerData[playerid][pGovTimer])
	        	SendClientMessageToAll(COLOR_GREY1, "____________ Public Service Announcement ____________");

			SendClientMessageToAllEx(COLOR_OLDSCHOOL, "* %s %s: %s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
			PlayerData[playerid][pGovTimer] = 30;
		}
		case FACTION_ARMY:
		{
		    if(!PlayerData[playerid][pGovTimer])
	       	 SendClientMessageToAll(COLOR_GREY1, "____________ Public Service Announcement ____________");

			SendClientMessageToAllEx(COLOR_YELLOW2, "* %s %s: %s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);

			PlayerData[playerid][pGovTimer] = 30;
		}
		case FACTION_TERRORIST:
		{
		    if(!PlayerData[playerid][pGovTimer])
	       	SendClientMessageToAll(COLOR_GREY1, "____________ Terrorist Organization Announcement ____________");

			SendClientMessageToAllEx(0xff0000ff, "* %s Unknown: %s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], params);

			PlayerData[playerid][pGovTimer] = 30;
		}
		default:
		{
		    SendClientMessage(playerid, COLOR_GREY, "Your faction is not authorized to use this command.");
		}
	}

	return 1;
}