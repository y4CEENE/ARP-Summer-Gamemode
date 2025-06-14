CMD:a(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1 && !PlayerData[playerid][pDeveloper] && !IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /a [admin chat]");
	}
	if(PlayerData[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the admin chat as you have it toggled.");
	}
    params[0] = toupper(params[0]);
	//return SendMessageToAllMembers(playerid,mtAdmin,params);

	foreach(new i : Player)
	{
        if(!PlayerData[i][pLogged])
        {
            continue;
        }
	    if((PlayerData[i][pAdmin] > 0 || PlayerData[i][pDeveloper] || IsGodAdmin(i)) && !PlayerData[i][pToggleAdmin])
	    {
			new adminname[24];
			adminname = GetRPName(playerid);
			if(PlayerData[playerid][pUndercover][0])
			{
			    if(strcmp(PlayerData[playerid][pAdminName], "None", true))
			    {
			    	strcpy(adminname, PlayerData[playerid][pAdminName]);
				}
			}
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SendClientMessageEx(i, COLOR_YELLOW, "* [%s %s{FFFF00}] %s: %.*s... *", GetAdminDivision(playerid), GetAdminRank1(playerid), adminname, MAX_SPLIT_LENGTH, params);
	            SendClientMessageEx(i, COLOR_YELLOW, "* [%s %s{FFFF00}] %s: ...%s *", GetAdminDivision(playerid), GetAdminRank1(playerid), adminname, params[MAX_SPLIT_LENGTH]);
			}
			else
			{
				SendClientMessageEx(i, COLOR_YELLOW, "* [%s %s{FFFF00}] %s: %s *", GetAdminDivision(playerid), GetAdminRank1(playerid), adminname, params);
			}
		}
	}
	return 1;
}

CMD:fa(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 1 && !PlayerData[playerid][pFormerAdmin])
    {
    	return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fa [Former Admin chat]");
	}
	if(PlayerData[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the Former Admin chat as you have it toggled.");
	}

	//return SendMessageToAllMembers(playerid,mtFormerAdmin,params);
	
	foreach(new i : Player)
	{
        if(!PlayerData[i][pLogged])
        {
            continue;
        }
	    if((PlayerData[i][pAdmin] > 0 || PlayerData[i][pFormerAdmin]) && !PlayerData[i][pToggleAdmin])
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
	            SendClientMessageEx(i, COLOR_RETIRED, "* [%s] %s: %.*s... *", GetAdminRank(playerid), GetRPName(playerid), MAX_SPLIT_LENGTH, params);
	            SendClientMessageEx(i, COLOR_RETIRED, "* [%s] %s: ...%s *", GetAdminRank(playerid), GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
				SendClientMessageEx(i, COLOR_RETIRED, "* [%s] %s: %s *", GetAdminRank(playerid), GetRPName(playerid), params);
			}
		}
	}
	return 1;
}

CMD:ha(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ha [head admin chat]");
	}
	if(PlayerData[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the head administrator chat as you have admin chats toggled.");
	}

	foreach(new i : Player)
	{
        if(!PlayerData[i][pLogged])
        {
            continue;
        }
	    if((PlayerData[i][pAdmin] > 4) && !PlayerData[i][pToggleAdmin])
	    {
			SendClientMessageEx(i, 0x5C80FFFF, "* [%s] %s: %s *", GetAdminRank(playerid), GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:e(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /e [Management chat]");
	}
	if(PlayerData[playerid][pToggleAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the executive chat as you have admin chats toggled.");
	}

	foreach(new i : Player)
	{
        if(!PlayerData[i][pLogged])
        {
            continue;
        }
	    if((PlayerData[i][pAdmin] > 5) && !PlayerData[i][pToggleAdmin])
	    {
			SendClientMessageEx(i, 0xA077BFFF, "* [%s] %s: %s *", GetAdminRank(playerid), GetRPName(playerid), params);
		}
	}

	return 1;
}


CMD:graphicchat(playerid, params[])
{
	if(PlayerData[playerid][pGraphic] >= 1)
	{
		new msg[128];
		new str[128];
		if(!sscanf(params, "s[128]", msg))
		{
			if(PlayerData[playerid][pGraphic] == GRAPHICRANK_REGULAR) str = "Graphics Designer";
			else if(PlayerData[playerid][pGraphic] == GRAPHICRANK_SENIOR) str = "Video Editor";
			else if(PlayerData[playerid][pGraphic] == GRAPHICRANK_MANAGER) str = "Graphic Manager";

			format(str, sizeof(str), "* %s %s: %s *", str, GetRPName(playerid), msg);
			SendGraphicMessage(0xFA58ACFF, str);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(g)raphic(c)hat [message]");
		}
	}
	else
	{
		return SendClientErrorUnautorizedChat(playerid);
	}
	return 1;
}


CMD:ap(playerid, params[])
{
	if(PlayerData[playerid][pAdminPersonnel] || PlayerData[playerid][pAdmin] >= MANAGEMENT)
	{
		new msg[128];
		new str[128];
		if(!sscanf(params, "s[128]", msg))
		{
			format(str, sizeof(str), "* [AP]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
			SendAPMessage(COLOR_AQUA, str);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(a)dmin(p)ersonnel [message]");
		}
	}
	else
	{
		return SendClientErrorUnautorizedChat(playerid);
	}
	return 1;
}

CMD:dga(playerid, params[])
{
	if(PlayerData[playerid][pGameAffairs] >= 1 || PlayerData[playerid][pAdmin] >= ASST_MANAGEMENT)
	{
		new msg[128];
		new str[128];
		if(!sscanf(params, "s[128]", msg))
		{
			format(str, sizeof(str), "* [DGA]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
			SendDGAMessage(COLOR_GLOBAL, str);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /dga [message]");
		}
	}
	else
	{
		return SendClientErrorUnautorizedChat(playerid);
	}
	return 1;
}

CMD:wd(playerid, params[])
{
	if(PlayerData[playerid][pWebDev] >= 1 || PlayerData[playerid][pAdmin] >= ASST_MANAGEMENT)
	{
		new msg[128];
		new str[128];
		if(!sscanf(params, "s[128]", msg))
		{
			format(str, sizeof(str), "* [WD]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
			SendWDMessage(COLOR_GLOBAL, str);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /dga [message]");
		}
	}
	else
	{
		return SendClientErrorUnautorizedChat(playerid);
	}
	return 1;
}

CMD:fm(playerid, params[])
{
    if(PlayerData[playerid][pFactionMod] || PlayerData[playerid][pGameAffairs] || PlayerData[playerid][pAdmin] >= ASST_MANAGEMENT)
	{
		new msg[128];
		new str[128];
		if(!sscanf(params, "s[128]", msg))
		{
			format(str, sizeof(str), "* [FM]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
			SendFMMessage(COLOR_BLUE, str);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(f)action(m)managment [message]");
		}
	}
	else
	{
		return SendClientErrorUnautorizedChat(playerid);
	}
	return 1;
}
CMD:gm(playerid, params[])
{
    if(PlayerData[playerid][pGangMod] || PlayerData[playerid][pGameAffairs] || PlayerData[playerid][pAdmin] >= ASST_MANAGEMENT)
	{
		new msg[128];
		new str[128];
		if(!sscanf(params, "s[128]", msg))
		{
			format(str, sizeof(str), "* [GM]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
			SendGMMessage(COLOR_GREEN, str);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(g)ang (m)managment [message]");
		}
	}
	else
	{
		return SendClientErrorUnautorizedChat(playerid);
	}
	return 1;
}