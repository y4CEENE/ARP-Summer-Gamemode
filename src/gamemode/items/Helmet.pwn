/// @file      Helmet.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static HelmetEnabled[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    HelmetEnabled[playerid] = 0;
    return 1;
}

GetPlayerHelmet(playerid)
{
    switch (PlayerData[playerid][pHelmet])
    {
        case 1: return 18645; //MotorcycleHelmet
        case 2: return 18976;   //MotorcycleHelmet2
        case 3: return 18977;   //MotorcycleHelmet3
        case 4: return 18978;   //MotorcycleHelmet4
        case 5: return 18979;   //MotorcycleHelmet5
    }
    return true;
}

CMD:helmet(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (PlayerData[playerid][pHelmet] == 1)
    {
        if (HelmetEnabled[playerid] == 1)
        {
            HelmetEnabled[playerid] = 0;
            ShowActionBubble(playerid, "{FF8000}* {C2A2DA}%s reaches for their helmet and takes it off.", GetPlayerNameEx(playerid));
            RemovePlayerAttachedObject(playerid, 3);
        }
        else if (HelmetEnabled[playerid] == 0)
        {
            if (IsAMotorBike(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                HelmetEnabled[playerid] = 1;
                ShowActionBubble(playerid, "{FF8000}* {C2A2DA}%s reaches for their helmet and puts it on.", GetPlayerNameEx(playerid));
                SetPlayerAttachedObject(playerid, 3, GetPlayerHelmet(playerid), 2, 0.101, -0.0, 0.0, 5.50, 84.60, 83.7, 1, 1, 1);
            }
            else return SendClientMessage(playerid, COLOR_GREY, "You must be in a bike to use this command");
        }
    }
    else return SendClientMessage(playerid, COLOR_GREY, "You dont have a helmet, buy one from a tool shop.");
    return 1;
}
