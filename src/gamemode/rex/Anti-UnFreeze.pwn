#include <YSI\y_hooks>

static IsFreezed          [MAX_PLAYERS];
static Float:FreezePosX   [MAX_PLAYERS];
static Float:FreezePosY   [MAX_PLAYERS];
static Float:FreezePosZ   [MAX_PLAYERS];

hook OnPlayerHeartBeat(playerid)
{
    if(IsFreezed[playerid])
    {
        new Float:x;
        new Float:y;
        new Float:z;
        GetPlayerPosEx(playerid, x, y, z);

        if(FreezePosX[playerid] != x || FreezePosY[playerid] != y || FreezePosZ[playerid] != z)
        {
            TogglePlayerControllable(playerid, 0);
            FreezePosX[playerid] = x;
            FreezePosY[playerid] = y;
            FreezePosZ[playerid] = z;
        }
    }
    return 1;
}

TogglePlayerControllableEx(playerid, toggle)
{
    IsFreezed[playerid] = (toggle == 0);
    GetPlayerPosEx(playerid, FreezePosX[playerid], FreezePosY[playerid], FreezePosZ[playerid]);
    TogglePlayerControllable(playerid, toggle);
    return 1;
}

IsPlayerFreezed(playerid)
{
    return IsFreezed[playerid];
}