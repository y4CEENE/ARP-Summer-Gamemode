#include <YSI\y_hooks>

static sweeperVehicles[18];

IsSweepingVehicle(vehicleid)
{
    return (sweeperVehicles [0] <= vehicleid <= sweeperVehicles	[sizeof(sweeperVehicles) - 1]);
}

startsweeping(playerid)
{
	if(PlayerData[playerid][pSweeping])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are sweeping already. /stopsweeping to stop.");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 574)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not sitting inside a Sweeper.");
	}

	PlayerData[playerid][pSweeping] = 1;
	PlayerData[playerid][pSweepTime] = 80;
	PlayerData[playerid][pSweepEarnings] = 0;

	SendClientMessage(playerid, COLOR_AQUA, "* You are now sweeping. Drive around with your sweeper to earn money towards your paycheck.");
	return 1;
}

stopsweeping(playerid)
{
	if(!PlayerData[playerid][pSweeping])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not sweeping right now.");
	}

	SendClientMessageEx(playerid, COLOR_AQUA, "* You are no longer sweeping. You earned a total of {00AA00}$%i{33CCFF} towards your paycheck during your shift.", PlayerData[playerid][pSweepEarnings]);
    PlayerData[playerid][pSweeping] = 0;
	PlayerData[playerid][pSweepTime] = 0;
	PlayerData[playerid][pSweepEarnings] = 0;
	return 1;
}

hook OnLoadGameMode(timestamp)
{
    sweeperVehicles[0] = AddStaticVehicleEx(574, 2187.6636, -1975.8738, 13.3012, 180.0000, 26, 26, 300); // sweeper 1
	sweeperVehicles[1] = AddStaticVehicleEx(574, 2184.9255, -1975.8738, 13.3029, 180.0000, 26, 26, 300); // sweeper 2
	sweeperVehicles[2] = AddStaticVehicleEx(574, 2181.8672, -1975.8738, 13.3005, 180.0000, 26, 26, 300); // sweeper 3
	sweeperVehicles[3] = AddStaticVehicleEx(574, 2179.0005, -1975.8738, 13.2679, 180.0000, 26, 26, 300); // sweeper 4
    sweeperVehicles[4] = AddStaticVehicleEx(574, 2173.3564, -1976.1001, 13.2799, 176.8126, 26, 26, 300); // Sweeper	574
    sweeperVehicles[5] = AddStaticVehicleEx(574, 2170.4497, -1976.0883, 13.2801, 177.9358, 26, 26, 300); // Sweeper	574
    sweeperVehicles[6] = AddStaticVehicleEx(574, 2192.2224, -1985.3699, 13.2750, 94.19140, 26, 26, 300); // Sweeper	574
    sweeperVehicles[7] = AddStaticVehicleEx(574, 2192.3171, -1988.2561, 13.2720, 94.86550, 26, 26, 300); // Sweeper	574
    sweeperVehicles[8] = AddStaticVehicleEx(574, 2192.5437, -1991.5342, 13.2720, 95.74950, 26, 26, 300); // Sweeper	574
    sweeperVehicles[9] = AddStaticVehicleEx(574, 2192.5432, -1994.6887, 13.2721, 93.93960, 26, 26, 300); // Sweeper	574
    sweeperVehicles[10] = AddStaticVehicleEx(574, 2192.6975, -1997.8274, 13.2721, 93.9140, 26, 26, 300); // Sweeper	574
    sweeperVehicles[11] = AddStaticVehicleEx(574, 2181.2537, -1993.1422, 13.2922, 313.7846, 26, 26, 300); // Sweeper	574
    sweeperVehicles[12] = AddStaticVehicleEx(574, 2178.6917, -1990.9169, 13.2707, 318.3488, 26, 26, 300); // Sweeper	574
    sweeperVehicles[13] = AddStaticVehicleEx(574, 2175.7310, -1988.2180, 13.2752, 315.0988, 26, 26, 300); // Sweeper	574
    sweeperVehicles[14] = AddStaticVehicleEx(574, 2172.9075, -1986.2037, 13.2760, 323.0492, 26, 26, 300); // Sweeper	574
    sweeperVehicles[15] = AddStaticVehicleEx(574, 2168.8049, -1985.5548, 13.2758, 319.2138, 26, 26, 300); // Sweeper	574
    sweeperVehicles[16] = AddStaticVehicleEx(574, 2182.8384, -1995.6630, 13.2720, 308.7154, 26, 26, 300); // Sweeper	574
    sweeperVehicles[17] = AddStaticVehicleEx(574, 2176.0437, -1975.9700, 13.2794, 179.8427, 26, 26, 300); // Sweeper	574

    return 1;
}


hook OnPlayerHeartBeat(playerid)
{
	new string[256];
    new vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerData[playerid][pSweeping] && GetVehicleModel(vehicleid) == 574 && GetVehicleSpeed(vehicleid) > 35.0 && !IsPlayerAFK(playerid))
    {
        PlayerData[playerid][pSweepTime]--;

        if(PlayerData[playerid][pSweepTime] <= 0)
        {
            new cost = 100 + random(50);

            if(PlayerData[playerid][pLaborUpgrade] > 0)
            {
                cost += percent(cost, PlayerData[playerid][pLaborUpgrade]);
            }

            AddToPaycheck(playerid, cost);

            format(string, sizeof(string), "~g~+$%i", cost);
            GameTextForPlayer(playerid, string, 5000, 1);
            GivePlayerCash(playerid, cost);
            
            GiveNotoriety(playerid, -5);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have lost -5 notoriety for public services, you now have %d.", PlayerData[playerid][pNotoriety]);

            PlayerData[playerid][pSweepEarnings] += cost;
            PlayerData[playerid][pSweepTime] = 80;
        }
    }
    return 1;
}