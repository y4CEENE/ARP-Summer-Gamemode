#include <YSI\y_hooks>

static taxiVehicles[4];

hook OnLoadGameMode(timestamp)
{
    taxiVehicles[0] = AddStaticVehicleEx(420, 1775.6141, -1860.0100, 13.2745, 269.2006, 6, 1, 300); // taxi 1
	taxiVehicles[1] = AddStaticVehicleEx(420, 1763.0121, -1860.0037, 13.2723, 271.2998, 6, 1, 300); // taxi 2
	taxiVehicles[2] = AddStaticVehicleEx(420, 1748.9358, -1859.9502, 13.2721, 270.3943, 6, 1, 300); // taxi 3
	taxiVehicles[3] = AddStaticVehicleEx(420, 1734.6754, -1859.9305, 13.2740, 270.5646, 6, 1, 300); // taxi 4
    return 1;
}

IsTaxiJobVehicle(vehicleid)
{
    return (taxiVehicles[0] <= vehicleid <= taxiVehicles[sizeof(taxiVehicles) - 1]);
}


CMD:setfare(playerid, params[])
{
	new amount;

	if(!PlayerHasJob(playerid, JOB_TAXIDRIVER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Taxi Driver.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setfare [amount]");
	}
	if(!(0 <= amount <= 500))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The fare must range between $0 and $500.");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 420 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 438)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in a taxi type vehicle.");
	}
	if(gettime() - PlayerData[playerid][pLastFare] < 50)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only speak in this channel every 50 seconds. Please wait %i more seconds.", 50 - (gettime() - PlayerData[playerid][pLastFare]));
	}
	if(amount == 0)
	{
	    if(PlayerData[playerid][pTaxiFare] == 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "The fare is already set to zero.");
	    }

	    PlayerData[playerid][pTaxiFare] = 0;
	    SendClientMessage(playerid, COLOR_YELLOW, "* You have set the fare to $0 and went off duty.");
	}
	else
	{
	    if(PlayerData[playerid][pTaxiFare] == amount)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "The fare is already set to this amount.");
	    }
        PlayerData[playerid][pLastFare] = gettime();
	    PlayerData[playerid][pTaxiFare] = amount;
	    SendClientMessageToAllEx(COLOR_YELLOW, "* Taxi driver %s is now on duty, fare: $%i. /call taxi for a ride.", GetRPName(playerid), amount);
	}

	return 1;
}
