
CMD:o(playerid, params[])
{
	return callcmd::ooc(playerid, params);
}

CMD:ooc(playerid, params[])
{
	new string[64];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(o)oc [global OOC]");
	}
	if(!enabledOOC && PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The global OOC channel is disabled at the moment.");
	}
	if(PlayerData[playerid][pToggleOOC])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the OOC chat as you have it toggled.");
	}
	
    if((!isnull(PlayerData[playerid][pCustomTitle]) && strcmp(PlayerData[playerid][pCustomTitle], "None", true) != 0) && PlayerData[playerid][pAdminHide] == 0) 
    {
	    new color;
		if(PlayerData[playerid][pCustomTColor] == -1 || PlayerData[playerid][pCustomTColor] == -256)
		{
	    	color = 0xC8C8C8FF;
		}
		else
		{
		    color = PlayerData[playerid][pCustomTColor];
		}
	    format(string, sizeof(string), "{%06x}%s{FFFFFF} %s", color >>> 8, PlayerData[playerid][pCustomTitle], GetRPName(playerid));
	} else if(PlayerData[playerid][pAdmin] > 1 && PlayerData[playerid][pAdminHide] == 0) {
		format(string, sizeof(string), "%s %s", GetAdminRank(playerid), GetRPName(playerid));
	} else if(PlayerData[playerid][pHelper] > 0) {
	    format(string, sizeof(string), "%s %s", GetHelperRank(playerid), GetRPName(playerid));
    } else if(PlayerData[playerid][pFormerAdmin]) {
	    format(string, sizeof(string), "{FF69B5}Former Admin{FFFFFF} %s", GetRPName(playerid));
	} else if(PlayerData[playerid][pDonator] > 0) {
	    format(string, sizeof(string), "{D909D9}%s VIP{FFFFFF} %s", GetVIPRank(PlayerData[playerid][pDonator]), GetRPName(playerid));
	} else {
	    format(string, sizeof(string), "%s", GetRPName(playerid));
	}

	foreach(new i : Player)
	{
	    if(!PlayerData[i][pToggleOOC] && PlayerData[i][pLogged])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
				SendClientMessageEx(i, COLOR_WHITE, "(( %s: %.*s... ))", string, MAX_SPLIT_LENGTH, params);
				SendClientMessageEx(i, COLOR_WHITE, "(( %s: ...%s ))", string, params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SendClientMessageEx(i, COLOR_WHITE, "(( %s: %s ))", string, params);
			}
		}
	}
	new message[512];
	format(message,sizeof(message),"(( *%s*: %s ))", GetRPName(playerid), params);

	return 1;
}

