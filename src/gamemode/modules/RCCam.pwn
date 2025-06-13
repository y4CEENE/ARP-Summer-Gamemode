/// @file      RCCam.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

enum rccamStatusEnum{
    bool:enabled,
    Float:rcX,
    Float:rcY,
    Float:rcZ,
    rcveh,
    rctimer
}
static rccamStatus[MAX_PLAYERS][rccamStatusEnum];

publish rccam(playerid)
{
    if (rccamStatus[playerid][enabled])
    {
        DestroyVehicleEx(rccamStatus[playerid][rcveh]);
        //VehicleRadioStation[rccamStatus[playerid][rcveh]] = 0;
        SetPlayerPos(playerid, rccamStatus[playerid][rcX], rccamStatus[playerid][rcY], rccamStatus[playerid][rcZ]);
        rccamStatus[playerid][enabled] = false;
        KillTimer(rccamStatus[playerid][rctimer]);
        SendClientMessage(playerid, COLOR_GREY, "Your RC Cam has ran out of batteries!");
    }
}

CMD:rccam(playerid, params[])
{
    if (PlayerData[playerid][pRccam] > 0)
    {
        if (rccamStatus[playerid][enabled] == false)
        {
            if (IsPlayerInAnyVehicle(playerid))
            {
                SendClientMessage(playerid, COLOR_GREY, "You must be on foot to place an RCCam!");
                return 1;
            }
            PlayerData[playerid][pRccam]--;
            rccamStatus[playerid][enabled]=true;

            new Float:X, Float:Y, Float:Z;
            GetPlayerPos(playerid, X, Y, Z);
            rccamStatus[playerid][rcX] = X;
            rccamStatus[playerid][rcY] = Y;
            rccamStatus[playerid][rcZ] = Z;

            if (rccamStatus[playerid][rcveh] != 0)
            {
                DestroyVehicleEx(rccamStatus[playerid][rcveh]);
                //VehicleRadioStation[rccamStatus[playerid][rcveh]] = 0;
            }
            //rccamStatus[playerid][rcveh] = AddStaticVehicle(594, X, Y, Z, 0, 0, 0);
            rccamStatus[playerid][rcveh] = AddStaticVehicle(441, X, Y, Z, 0, 79, 1);

            PutPlayerInVehicle(playerid, rccamStatus[playerid][rcveh], 0);
            rccamStatus[playerid][rctimer] = SetTimerEx("rccam", 60000, 0, "d", playerid);

            SendNearbyMessage(playerid, 30.0, COLOR_AQUA,  "* %s places something on the ground.", GetPlayerNameEx(playerid));
            return 1;
        }
    }
    if (rccamStatus[playerid][enabled])
    {
            DestroyVehicleEx(rccamStatus[playerid][rcveh]);
            //VehicleRadioStation[rccamStatus[playerid][rcveh]] = 0;
            SetPlayerPos(playerid, rccamStatus[playerid][rcX], rccamStatus[playerid][rcY], rccamStatus[playerid][rcZ]);
            rccamStatus[playerid][enabled] = false;
            KillTimer(rccamStatus[playerid][rctimer]);
    }

    if (PlayerData[playerid][pRccam] <= 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "You don't have an RC Cam!");
    }

    return 1;
}
