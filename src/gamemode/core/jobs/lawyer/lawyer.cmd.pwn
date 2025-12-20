CMD:defend(playerid, params[])
{
	new targetid, amount, time = (5 - GetJobLevel(playerid, JOB_LAWYER)) * 30;

    if(!PlayerHasJob(playerid, JOB_LAWYER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Lawyer.");
	}
	if(gettime() - PlayerData[playerid][pLastDefend] < time)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only defend a player every %i seconds. Please wait %i more seconds.", time, time - (gettime() - PlayerData[playerid][pLastDefend]));
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /defend [playerid] [amount]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't defend yourself.");
	}
	if(!PlayerData[targetid][pWantedLevel])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not wanted.");
	}
	if(amount < 500 || amount > 1500)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $500 or above $1500.");
	}

	PlayerData[targetid][pDefendOffer] = playerid;
	PlayerData[targetid][pDefendPrice] = amount;
	PlayerData[playerid][pLastDefend] = gettime();

	SendClientMessageEx(targetid, COLOR_AQUA, "* Lawyer %s has offered to defend your wanted level for $%i. (/accept lawyer)", GetRPName(playerid), amount);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to defend %s's wanted level for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:free(playerid, params[])
{
	new targetid, time = GetJobLevel(playerid, JOB_LAWYER);

    if(!PlayerHasJob(playerid, JOB_LAWYER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Lawyer.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /free [playerid]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if (IsPlayerInBankRobbery(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't be defended while in bank robbery.");
    }
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(PlayerData[targetid][pJailType] != 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not in IC jail.");
	}
	if(PlayerData[targetid][pJailTime] < time * 60)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't free this player, their jail time expires soon.");
	}

	PlayerData[targetid][pJailTime] -= time * 60;

    GiveNotoriety(playerid, -10);	
    GivePlayerRankPointLegalJob(playerid, 500);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have lost -10 notoriety for legal affairs, you now have %d.", PlayerData[playerid][pNotoriety]);
    
	SendClientMessageEx(targetid, COLOR_AQUA, "* Lawyer %s has reduced your jail sentence by %i minutes.", GetRPName(playerid), time);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have reduced %s's jail sentence by %i minutes.", GetRPName(targetid), time);
	return 1;
}

CMD:neutralize(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_LAWYER))
	{
		SendClientMessage(playerid, COLOR_GREY, "   You're not a Lawyer!");
		return 1;
	}

	new giveplayerid, noto;
	
	if(sscanf(params, "ud", giveplayerid, noto))
    {
		return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /neutralize [playerid] [notoriety]");
    }
	
	if(!IsPlayerConnected(giveplayerid))
    {
		return 	SendClientMessage(playerid, COLOR_GREY, "Invalid player specified.");
    }

	if(giveplayerid == playerid)
	{
		return SendClientMessage(playerid, COLOR_GREY, "   You can't offer neutralize to yourself!");
	}

	if(!IsPlayerNearPlayer(playerid, giveplayerid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, " That player is not near you!");
    }

    if(noto <= 0)
    {
		return 	SendClientMessage(playerid, COLOR_GREY, "Invalid notoriety value.");
    }

	if(PlayerData[giveplayerid][pNotoriety] < noto)
    {
		return SendClientMessage(playerid, COLOR_GREY, "Player does not have that much notoriety!"); 
    }

	new cash = noto * 2;

    SendClientMessageEx(playerid, COLOR_AQUA,  "* You offered to neutralize %s for $%d (%d notoriety).", GetPlayerNameEx(giveplayerid), cash, noto);
    SendClientMessageEx(giveplayerid, COLOR_AQUA, "* Lawyer %s wants to neutralize you for $%d (%d notoriety), (type /accept neutralize) to accept.", GetPlayerNameEx(playerid), cash, noto);
    DefendNOffer[giveplayerid] = playerid;
    DefendNQuantity[giveplayerid] = noto;
	
	return 1;
}