/// @file      TestDrive.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_TEST)
        return 1;

    PlayerData[playerid][pTestCP]++;

    if (PlayerData[playerid][pTestCP] < sizeof(drivingTestCPs))
    {
        if (!(testVehicles[0] <= GetPlayerVehicleID(playerid) <= testVehicles[4]))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You failed the test as you exited your vehicle.");
            SetVehicleToRespawn(PlayerData[playerid][pTestVehicle]);
            PlayerData[playerid][pDrivingTest] = 0;
        }
        else
        {
            new Float:x = drivingTestCPs[PlayerData[playerid][pTestCP]][0];
            new Float:y = drivingTestCPs[PlayerData[playerid][pTestCP]][1];
            new Float:z = drivingTestCPs[PlayerData[playerid][pTestCP]][2];
            SetActiveCheckpoint(playerid, CHECKPOINT_TEST, x, y, z, 3.0);
        }
    }
    else
    {
        new Float:health;
        GetVehicleHealth(PlayerData[playerid][pTestVehicle], health);

        PlayerPlaySound(playerid, 1183, 0.0, 0.0, 0.0); // *Driving school results music*

        if (health < 900.0)
        {
            GameTextForPlayer(playerid, "~r~Failed", 5000, 1);
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You brought back the vehicle damaged and therefore failed your test.");
        }
        else
        {
            AwardAchievement(playerid, ACH_LegalDriver);

            GameTextForPlayer(playerid, "~w~Passed!~n~~r~-$500", 5000, 1);
            SendClientMessage(playerid, COLOR_AQUA, "You successfully passed your drivers test and received your license!");

            GivePlayerCash(playerid, -500);
            GivePlayerLicense(playerid, PlayerLicense_Car);
        }
        SetVehicleToRespawn(PlayerData[playerid][pTestVehicle]);
        PlayerData[playerid][pDrivingTest] = 0;
    }
    return 1;
}

CMD:taketest(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2033.2953, -117.4508, 1035.1719))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the desk in the Licensing department.");
    }
    if (PlayerHasLicense(playerid, PlayerLicense_Car))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have your drivers license already.");
    }
    if (PlayerData[playerid][pDrivingTest])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already taking your drivers test.");
    }
    if (PlayerData[playerid][pCash] < 400)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need $400 to pay the licensing fee if you pass the test.");
    }

    SendClientMessage(playerid, COLOR_WHITE, "* You've taken on the drivers test. Go outside and enter one of the vehicles to begin.");
    SendClientMessage(playerid, COLOR_WHITE, "* Once you have passed the test, you will receive your license and pay a $500 licensing fee.");

    PlayerData[playerid][pTestVehicle] = INVALID_VEHICLE_ID;
    PlayerData[playerid][pDrivingTest] = 1;
    PlayerData[playerid][pTestCP] = 0;
    return 1;
}


hook OnPlayerClearCheckpoint(playerid, type, flag)
{
    PlayerData[playerid][pTestVehicle] = INVALID_VEHICLE_ID;
    PlayerData[playerid][pDrivingTest] = 0;
    PlayerData[playerid][pTestCP] = 0;
    if (PlayerData[playerid][pDrivingTest])
    {
        SetVehicleToRespawn(PlayerData[playerid][pTestVehicle]);
    }
}
