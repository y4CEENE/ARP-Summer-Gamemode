#include <YSI\y_hooks>

static pizzaVehicles[6];
static PlayerPizzas[MAX_PLAYERS];
static PlayerPizzaTime[MAX_PLAYERS];
static PlayerLastPizza[MAX_PLAYERS];
static PlayerPizzaCooldown[MAX_PLAYERS];

IsPizzaJobVehicle(vehicleid)
{
    return (pizzaVehicles[0] <= vehicleid <= pizzaVehicles[sizeof(pizzaVehicles) - 1]);
}

GetPizzaCoolDown(playerid)
{
    return PlayerPizzaCooldown[playerid];
}
hook OnLoadGameMode(timestamp)
{
    pizzaVehicles[0] = AddStaticVehicleEx(448, 2097.8396, -1792.2556, 12.9978, 90.0000, 3, 6, 300); // bike 1
	pizzaVehicles[1] = AddStaticVehicleEx(448, 2097.8396, -1794.0065, 12.9978, 90.0000, 3, 6, 300); // bike 2
	pizzaVehicles[2] = AddStaticVehicleEx(448, 2097.8396, -1795.7574, 12.9978, 90.0000, 3, 6, 300); // bike 3
	pizzaVehicles[3] = AddStaticVehicleEx(448, 2097.8396, -1797.5083, 12.9978, 90.0000, 3, 6, 300); // bike 4
	pizzaVehicles[4] = AddStaticVehicleEx(448, 2097.8396, -1799.2592, 12.9978, 90.0000, 3, 6, 300); // bike 5
	pizzaVehicles[5] = AddStaticVehicleEx(448, 2097.8396, -1801.0101, 12.9978, 90.0000, 3, 6, 300); // bike 6
    return 1;
}

hook OnPlayerClearCheckPoint(playerid)
{
	PlayerPizzas[playerid] = 0;

    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerData[playerid][pCP] == CHECKPOINT_PIZZA)
    {
        new string[32];
        new amount = (100 + GetJobLevel(playerid, JOB_PIZZAMAN) * 100 + random(100)), tip = percent(amount, 5);

        if(gettime() - PlayerLastPizza[playerid] < 15 && PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && !PlayerData[playerid][pKicked])
        {
            PlayerData[playerid][pACWarns]++;

            if(PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
            {
                SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport pizza delivering (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerLastPizza[playerid]);
            }
            else
            {
                BanPlayer(playerid, "Teleport pizza runs");
            }
        }

        if(PlayerData[playerid][pLaborUpgrade] > 0)
        {
            amount += percent(amount, PlayerData[playerid][pLaborUpgrade]);
        }

        format(string, sizeof(string), "~g~+$%i", amount);
        GameTextForPlayer(playerid, string, 5000, 1);

        AddToPaycheck(playerid, amount);
        GivePlayerCash(playerid, tip);
        IncreaseJobSkill(playerid, JOB_PIZZAMAN);
        GivePlayerRankPointLegalJob(playerid, 50);

        PlayerPizzas[playerid] = 0;
        PlayerPizzaTime[playerid] = 0;
        PlayerData[playerid][pCP] = CHECKPOINT_NONE;
        SendClientMessageEx(playerid, COLOR_AQUA, "You received {00AA00}$%i{33CCFF} for this delivery. You also received a {00AA00}$%i{33CCFF} tip.", amount, tip);
        DisablePlayerCheckpoint(playerid);
    }
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if(PlayerPizzas[playerid] > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 448)
        {
            if(PlayerPizzaTime[playerid] < 90)
            {
                PlayerPizzaTime[playerid]++;
            }
        }
        else
        {
            PlayerPizzas[playerid] = 0;
            PlayerData[playerid][pCP] = 0;

            DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_GREY, "Pizza delivery cancelled. You went into another vehicle.");
        }
    }
    
    if(PlayerPizzaCooldown[playerid] > 0)
    {
        PlayerPizzaCooldown[playerid]--;
    }
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    PlayerPizzaCooldown[playerid] = cache_get_field_content_int(row, "pizzacooldown");
    return 1;
}

CMD:getpizza(playerid, params[])
{
	new houseid;

    if(!PlayerHasJob(playerid, JOB_PIZZAMAN))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a Pizzaman.");
	}
	if(PlayerPizzaCooldown[playerid] > 0)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds before you can load another pizza.", PlayerPizzaCooldown[playerid]);
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 448)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a pizza bike.");
	}
	/*if(PlayerPizzas[playerid] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have pizzas already. Deliver them first.");
	}*/
	if(!IsPlayerInRangeOfPoint(playerid, 6.0, jobLocations[JOB_PIZZAMAN][jobX], jobLocations[JOB_PIZZAMAN][jobY], jobLocations[JOB_PIZZAMAN][jobZ]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be closer to the job icon at the pizza stacks.");
	}
	if((houseid = GetRandomHouse(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There are no houses in the server to deliver pizza to. Ask an admin to set them up.");
	}

	PlayerData[playerid][pDistance] = GetPlayerDistanceFromPoint(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
    PlayerPizzas[playerid] = 1;
	PlayerLastPizza[playerid] = gettime();
    PlayerPizzaTime[playerid] = 0;
    PlayerPizzaCooldown[playerid] = 60;
    PlayerData[playerid][pCP] = CHECKPOINT_PIZZA;
	SetPlayerCheckpoint(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 2.0);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You loaded your bike with a hot and ready pizza. Deliver it to %s.", GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]));
	return 1;
}
