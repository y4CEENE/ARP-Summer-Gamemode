
CMD:buycomps(playerid, params[])
{
	new amount, price, cost = 1200 - (GetJobLevel(playerid, JOB_MECHANIC) * 200);

	if(!PlayerHasJob(playerid, JOB_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic.");
	}
	if(!IsPlayerAtMechanicComponent(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the component shop.");
	}
	if(sscanf(params, "i", amount))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buycomps [amount]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "You are paying $%i per component at your current skill level.", cost);
		return 1;
	}
	if(!(1 <= amount <= 10))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount must range between 1 and 10.");
	}
	if(PlayerData[playerid][pComponents] + amount > 50)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 50 components.");
	}

	price = amount * cost;

	if(PlayerData[playerid][pCash] < price)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "You can't afford to purchase %i components for $%i.", amount, price);
	}
	else
	{
	    PlayerData[playerid][pComponents] += amount;

		GivePlayerCash(playerid, -price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i components for $%i.", amount, price);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}