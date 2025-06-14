
CMD:sex(playerid, params[])
{
	
	if(!PlayerHasJob(playerid, JOB_HOOKER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Hooker.");
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_GREY, "   You can only have Sex in a Car!");
		return 1;
	}
	
	new targetid, money;
		
	if(sscanf(params, "ud", targetid, money))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sex [playerid] [price]");
	}
	if(money < 1 || money > 10000) { SendClientMessage(playerid, COLOR_GREY, "   Price not lower then $1 or above $10,000!"); return 1; }

	if(!PlayersCanHaveSex(playerid, targetid))
        return 1;


/*	PlayerData[targetid][pSexOffer] = playerid;
	SendClientMessageEx(targetid, COLOR_AQUA, "%s offered you to have sex. /accept sex to have sex with him/her.",GetRPName(playerid));
	return SendClientMessageEx(playerid, COLOR_AQUA, "You offered %s to have sex.",GetRPName(targetid));
*/
	
	if(gettime() - SexLastTime[playerid] < 300){
		SendClientMessage(playerid, COLOR_GREY, " You have already had sex, wait for your reload time to finish!");
		return 1;
	}	
	
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You Offered %s to have Sex with you, for $%d.", GetPlayerNameEx(targetid), money);
	SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* Hooker %s has Offered you to have Sex with them, for $%d (type /accept sex) to accept.", GetPlayerNameEx(playerid), money);
	SexOffer[targetid] = playerid;
	SexPrice[targetid] = money;
	SexLastTime[playerid] = gettime();
	return 1;
}

CMD:healme(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, -2299.6079, 123.6063, -5.3468))
	{
		if(STD[playerid] != 0)
		{
            STD[playerid] = 0;
            GivePlayerCash(playerid, -100);
            SendClientMessage(playerid, COLOR_DOCTOR, "* You're no longer infected with a STD anymore because of the Hospital's help!");
			SendClientMessage(playerid, COLOR_DOCTOR, "Doc: Your medical bill contained $100. Have a nice day!");
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "   You don't have a STD to heal!");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "   You're not at a Hospital!");
	}
	return 1;
}