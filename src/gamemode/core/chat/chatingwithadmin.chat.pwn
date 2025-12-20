
CMD:startchat(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /startchat [playerid]");
	}
	if(IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already in an active chat. /invitechat to invite them.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
    if(IsPlayerChatActive(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is in an active chat with another admin.");
	}

	chattingWith[playerid]{targetid} = true;
	chattingWith[targetid]{playerid} = true;

	SendClientMessageEx(targetid, COLOR_YELLOW, "Administrator %s has started a chat with you. /(re)ply to speak with this admin.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have started a chat with %s (ID %i). /(re)ply to speak to the player.", GetRPName(targetid), targetid);
	return 1;
}

CMD:invitechat(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /invitechat [playerid]");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have not started a chat yet. /startchat to start one.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
    if(IsPlayerChatActive(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is in an active chat with another admin.");
	}

	chattingWith[playerid]{targetid} = true;
	chattingWith[targetid]{playerid} = true;

	SendClientMessageEx(targetid, COLOR_YELLOW, "Administrator %s has invited you to a chat. /(re)ply to speak with them.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have invited %s (ID %i) to your chat.", GetRPName(targetid), targetid);
	return 1;
}

CMD:kickchat(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /kickchat [playerid]");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have not started a chat yet. /startchat to start one.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
    if(!chattingWith[playerid]{targetid})
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently not in a chat with you.");
	}

	chattingWith[playerid]{targetid} = false;
	chattingWith[targetid]{playerid} = false;

	SendClientMessageEx(targetid, COLOR_YELLOW, "Administrator %s has removed you from the chat.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have removed %s (ID %i) from your chat.", GetRPName(targetid), targetid);
	return 1;
}

CMD:endchat(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have not started a chat yet. /startchat to start one.");
	}

	foreach(new i : Player)
	{
	    if(i == playerid || chattingWith[playerid]{i})
	    {
	        chattingWith[playerid]{i} = false;
	        SendClientMessageEx(i, COLOR_YELLOW, "Administrator %s has ended the chat.", GetRPName(playerid));
		}
	}

	return 1;
}

CMD:re(playerid, params[])
{
	return callcmd::reply(playerid, params);
}

CMD:reply(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(re)ply [text]");
	}
	if(!IsPlayerChatActive(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You haven't been invited to any chats by an admin.");
	}

	foreach(new i : Player)
	{
	    if(i == playerid || chattingWith[i]{playerid})
	    {
	        if(PlayerData[playerid][pAdmin] > 1 && PlayerData[playerid][pAdminHide] == 0)
	        	SendClientMessageEx(i, COLOR_YELLOW, "* %s %s (ID %i): %s *", GetAdminRank(playerid), GetRPName(playerid), playerid, params);
			else
			    SendClientMessageEx(i, COLOR_YELLOW, "* Player %s (ID %i): %s *", GetRPName(playerid), playerid, params);
	    }
	}

	return 1;
}
