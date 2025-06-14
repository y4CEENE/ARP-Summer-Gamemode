
CMD:news(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a news reporter.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /news [text]");
	}
	if(strlen(params) > 80)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Text is too long.");
	}
	if(PlayerData[playerid][pToggleNews])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't make news broadcasts as you have it toggled.");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 488 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 582)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can only use this command from within a news van or news chopper.");
	}

    new count = 0;

	foreach(new i : Player)
	{
	    if(!PlayerData[i][pToggleNews])
	    {
			SendClientMessageEx(i, COLOR_LIGHTGREEN, "News Reporter %s: %s", GetRPName(playerid), params);
			count++;
		}
	}

    new cash = strlen(params) * count / 8;
    new string[128];
    GivePlayerCash(playerid, cash);
    format(string, sizeof(string), "~g~+$%i", cash);
	GameTextForPlayer(playerid, string, 5000, 1);
	return 1;
}

CMD:live(playerid, params[])
{
	new targetid;

    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a news reporter.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /live [playerid]");
	}
	if(PlayerData[playerid][pLiveMuted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are banned from live interviews. Ask a higher rank to lift your ban.");
	}
	if(PlayerData[playerid][pLiveBroadcast] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already doing a live interview. /endlive to finish it.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't interview yourself.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(PlayerData[targetid][pLiveMuted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is banned from live interviews.");
	}
	if(PlayerData[targetid][pCallLine] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is on a phone call at the moment.");
	}

	PlayerData[targetid][pLiveOffer] = playerid;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you a live interview. (/accept live)", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s a live interview.", GetRPName(targetid));
	return 1;
}

CMD:endlive(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a news reporter.");
	}
    if(PlayerData[playerid][pLiveBroadcast] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are currently not doing a live interview.");
	}

	SendClientMessage(playerid, COLOR_AQUA, "You have ended the live interview.");
	SendClientMessageEx(PlayerData[playerid][pLiveBroadcast], COLOR_AQUA, "%s has ended the live interview.", GetRPName(playerid));

	PlayerData[PlayerData[playerid][pLiveBroadcast]][pLiveBroadcast] = INVALID_PLAYER_ID;
	PlayerData[playerid][pLiveBroadcast] = INVALID_PLAYER_ID;
	return 1;
}

CMD:liveban(playerid, params[])
{
	new targetid;

    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a news reporter.");
	}
	if(PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 2)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 2);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /liveban [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}

	if(!PlayerData[targetid][pLiveMuted])
	{
		if(PlayerData[targetid][pLiveBroadcast] != INVALID_PLAYER_ID)
		{
	    	PlayerData[PlayerData[targetid][pLiveBroadcast]][pLiveBroadcast] = INVALID_PLAYER_ID;
	    	PlayerData[targetid][pLiveBroadcast] = INVALID_PLAYER_ID;
		}

		PlayerData[targetid][pLiveMuted] = 1;
		SendClientMessageEx(targetid, COLOR_LIGHTRED, "%s has banned you from live interviews.", GetPlayerNameEx(playerid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have banned %s from live interviews.", GetPlayerNameEx(targetid));
	}
	else
	{
	    PlayerData[targetid][pLiveMuted] = 0;
		SendClientMessageEx(targetid, COLOR_YELLOW, "%s has unbanned you from live interviews.", GetPlayerNameEx(playerid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have unbanned %s from live interviews.", GetPlayerNameEx(targetid));
	}

	return 1;
}
CMD:adwithdraw(playerid, params[])
{
	new amount, reason[64];

    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of the news faction.");
	}
    if(PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1);
	}
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}
	if(sscanf(params, "is[64]", amount, reason))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /adwithdraw [amount] [reason] ($%i available)", GetNewsVault());
	}
	if(amount < 1 || amount > GetNewsVault())
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}

	AddToNewsVault(-amount);
	GivePlayerCash(playerid, amount);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %s from the advertisement vault. The new balance is %s.", FormatCash(amount), FormatCash(GetTaxVault()));
	SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s has withdrawn %s from the advertisement vault, reason: %s", GetRPName(playerid), FormatCash(amount), reason);
	Log_Write("log_faction", "%s (uid: %i) has withdrawn $%i from the advertisement vault, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, reason);
	return 1;
}

CMD:addeposit(playerid, params[])
{
	new amount;

    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of the news faction.");
	}
    if(PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1);
	}
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /addeposit [amount] ($%i available)", GetNewsVault());
	}
	if(amount < 1 || amount > PlayerData[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}

	AddToNewsVault(amount);
	GivePlayerCash(playerid, -amount);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited $%i in the advertisement vault. The new balance is $%i.", amount, GetNewsVault());
	SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s has deposited $%i in the advertisement vault.", GetRPName(playerid), amount);
	Log_Write("log_faction", "%s (uid: %i) has deposited $%i in the advertisement vault.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
	return 1;
}