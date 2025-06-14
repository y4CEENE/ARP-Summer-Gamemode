#include <YSI\y_hooks>

static FakeSamp_Lags[MAX_PLAYERS];
static FakeSamp_Deaths[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    FakeSamp_Lags[playerid] = 0;
    return 1;
}

hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    FakeSamp_Lags[playerid]++;
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    FakeSamp_Lags[playerid]++;
	return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
    FakeSamp_Lags[playerid]++;
	return 1;
}

hook OnPlayerRequestSpawn(playerid)
{
    FakeSamp_Lags[playerid]++;
    return 1;
}

hook OnPlayerRequestClass(playerid, classid)
{
    FakeSamp_Lags[playerid]++;
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    FakeSamp_Lags[playerid]++;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    FakeSamp_Deaths[playerid]++; //TODO: Check
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if(FakeSamp_Lags[playerid] > 10)
    {
        KickPlayer(playerid, "Suspected lag hacks");
    }
    FakeSamp_Lags[playerid] = 0;
    return 1;
}