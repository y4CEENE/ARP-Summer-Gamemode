#include <YSI\y_hooks>

enum FakeSampLagType
{
    FSLT_Player,
    FSLT_EnterVehicle,
    FSLT_ExitVehicle,
    FSLT_RequestSpawn,
    FSLT_RequestClass
};

static FakeSamp_Lags[MAX_PLAYERS];
static FakeSampLagType:FakeSamp_LagsType[MAX_PLAYERS];
static FakeSamp_LagsTarget[MAX_PLAYERS];
static FakeSamp_Deaths[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    FakeSamp_Lags[playerid] = 0;
    return 1;
}

hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    FakeSamp_Lags[playerid]++;
    FakeSamp_LagsType[playerid] = FSLT_Player;
    FakeSamp_LagsTarget[playerid] = clickedplayerid;
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    FakeSamp_Lags[playerid]++;
    FakeSamp_LagsType[playerid] = FSLT_EnterVehicle;
    FakeSamp_LagsTarget[playerid] = vehicleid;
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
    FakeSamp_Lags[playerid]++;
    FakeSamp_LagsType[playerid] = FSLT_ExitVehicle;
    FakeSamp_LagsTarget[playerid] = vehicleid;
    return 1;
}

hook OnPlayerRequestSpawn(playerid)
{
    FakeSamp_Lags[playerid]++;
    FakeSamp_LagsType[playerid] = FSLT_RequestSpawn;
    return 1;
}

hook OnPlayerRequestClass(playerid, classid)
{
    FakeSamp_Lags[playerid]++;
    FakeSamp_LagsType[playerid] = FSLT_RequestClass;
    FakeSamp_LagsTarget[playerid] = classid;
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    FakeSamp_Lags[playerid]++;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (IsPlayerConnected(killerid))
    {
        FakeSamp_Deaths[killerid]++;
    }
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (FakeSamp_Lags[playerid] > 10)
    {
        new reason[128];
        switch (FakeSamp_LagsType[playerid])
        {
            case FSLT_Player:       format(reason, sizeof(reason), "Suspected lag hacks (Player %s [%i])", GetPlayerNameEx(FakeSamp_LagsTarget[playerid]), FakeSamp_LagsTarget[playerid]);
            case FSLT_EnterVehicle: format(reason, sizeof(reason), "Suspected lag hacks (EnterVehicle %i)", FakeSamp_LagsTarget[playerid]);
            case FSLT_ExitVehicle:  format(reason, sizeof(reason), "Suspected lag hacks (ExitVehicle %i)", FakeSamp_LagsTarget[playerid]);
            case FSLT_RequestSpawn: format(reason, sizeof(reason), "Suspected lag hacks (RequestSpawn)");
            case FSLT_RequestClass: format(reason, sizeof(reason), "Suspected lag hacks (RequestClass %i)", FakeSamp_LagsTarget[playerid]);
        }

        KickPlayer(playerid, reason);
    }
    if (FakeSamp_Deaths[playerid] > 10)
    {
        KickPlayer(playerid, "Suspected fake kills");
    }

    FakeSamp_Lags[playerid] = 0;
    FakeSamp_Deaths[playerid] = 0;
    return 1;
}
