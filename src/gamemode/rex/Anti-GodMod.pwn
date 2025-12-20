#include <YSI\y_hooks>

hook OnPlayerHeartBeat(playerid)
{
    new Float:HPValue;
    GetPlayerHealth(playerid, HPValue);
    if (HPValue > 99.0)
    {
        SetPlayerHealth(playerid, 99.0);
    }
    return 1;
}