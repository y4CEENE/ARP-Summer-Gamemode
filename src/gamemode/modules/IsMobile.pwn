/// @file      IsMobile.pwn
/// @author    Khalil
/// @date      Created at 2022-05-08 21:25:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static MobileAuthKey[] = "ED40ED0E8089CC44C08EE9580F4C8C44EE8EE990";

#if !defined gpci
    native gpci(playerid, buffer[], size = sizeof(buffer));
#endif

enum
{
    PlayerDevice_Windows,
    PlayerDevice_Android
};

static PlayerDeviceType[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    new gpciStr[64];
    gpci(playerid, gpciStr, sizeof(gpciStr));

    if (!strcmp(gpciStr, MobileAuthKey)) // system for older version, will be deprecated
        PlayerDeviceType[playerid] = PlayerDevice_Android;
    else
        PlayerDeviceType[playerid] = PlayerDevice_Windows;
    return 1;
}

stock GetPlayerDeviceType(playerid)
{
    return PlayerDeviceType[playerid];
}

stock IsMobile(playerid)
{
    return (PlayerDeviceType[playerid] == PlayerDevice_Android);
}
