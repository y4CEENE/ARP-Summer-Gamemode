#include <YSI\y_hooks>

enum MeterEnum {
    meterStart,
    Float:meterX,
    Float:meterY,
    Float:meterZ
};

static Meter[MAX_PLAYERS][MeterEnum];

hook OnPlayerInit(playerid)
{
    Meter[playerid][meterStart] = false;
    return 1;
}


CMD:meter(playerid, params[])
{
    if(Meter[playerid][meterStart])
    {
        SendClientMessageEx(playerid, COLOR_GREY, " * The distance is %.2fm.", 
            GetPlayerDistanceFromPoint(playerid, Meter[playerid][meterX], Meter[playerid][meterY], Meter[playerid][meterZ]));
        Meter[playerid][meterStart] = false;
    }
    else
    {
        GetPlayerPosEx(playerid, Meter[playerid][meterX], Meter[playerid][meterY], Meter[playerid][meterZ]);
        SendClientMessageEx(playerid, COLOR_GREY, " * You have marked this point goto the next point and use /meter to get the distance.");
        Meter[playerid][meterStart] = true;
    }
    return 1;
}