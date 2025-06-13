/// @file      RentSystem.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 14:01:23 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>
//TODO: NOP Check

#define RENT_CAR_SIZE 62
#define RENT_CAR_PRICE 300
#define RENT_VEHICLE_RESPAWN 300

static rentcar[RENT_CAR_SIZE];
static Renting[MAX_PLAYERS];
static WaitRentingTimeout[MAX_PLAYERS];

IsARentableCar(vehicleid)
{
    return (rentcar[0] <= vehicleid && vehicleid <= rentcar[RENT_CAR_SIZE - 1]);
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("{FFA500}All Saints\nRent a bike", -1, 1218.0000, -1301.0000, 13.1500, 10.0);
    rentcar[0] = AddStaticVehicleEx(462, 1218.0000, -1292.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[1] = AddStaticVehicleEx(462, 1218.0000, -1295.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[2] = AddStaticVehicleEx(462, 1218.0000, -1298.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[3] = AddStaticVehicleEx(462, 1218.0000, -1301.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[4] = AddStaticVehicleEx(462, 1218.0000, -1304.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[5] = AddStaticVehicleEx(462, 1218.0000, -1307.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[6] = AddStaticVehicleEx(462, 1218.0000, -1310.0000, 13.1500, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);


    CreateDynamic3DTextLabel("{FFA500}Pershing Square\nRent a bike", -1, 1507.0000, -1714.0000, 13.6300, 10.0);// LSPD
    rentcar[7] = AddStaticVehicleEx(462, 1507.0000, -1714.0000, 13.6300, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[8] = AddStaticVehicleEx(462, 1507.0000, -1711.0000, 13.6300, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[9] = AddStaticVehicleEx(462, 1507.0000, -1708.0000, 13.6300, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[10] = AddStaticVehicleEx(462, 1507.0000, -1705.0000, 13.6300, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[11] = AddStaticVehicleEx(462, 1507.0000, -1702.0000, 13.6300, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[12] = AddStaticVehicleEx(462, 1507.0000, -1699.0000, 13.6300, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}Market\nRent a bike", -1, 1115.0000, -1451.0000, 15.3400, 10.0);
    rentcar[13] = AddStaticVehicleEx(462, 1115.0000, -1448.0000, 15.3400, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[14] = AddStaticVehicleEx(462, 1115.0000, -1451.0000, 15.3400, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[15] = AddStaticVehicleEx(462, 1115.0000, -1454.0000, 15.3400, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[16] = AddStaticVehicleEx(481, 1112.0000, -1454.0000, 15.3200, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[17] = AddStaticVehicleEx(481, 1112.0000, -1448.0000, 15.3200, 270.0000, 1, 1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}Market\nRent a bike", -1, 1142.0000, -1451.0000, 15.3400, 10.0);
    rentcar[18] = AddStaticVehicleEx(462, 1142.0000, -1448.0000, 15.3400, 90.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[19] = AddStaticVehicleEx(462, 1142.0000, -1451.0000, 15.3400, 90.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[20] = AddStaticVehicleEx(462, 1142.0000, -1454.0000, 15.3400, 90.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[21] = AddStaticVehicleEx(481, 1145.0000, -1448.0000, 15.3200, 90.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[22] = AddStaticVehicleEx(481, 1145.0000, -1454.0000, 15.3200, 90.0000, 1, 1, RENT_VEHICLE_RESPAWN);

    rentcar[23] = AddStaticVehicleEx(471, 1141.4000, -1466.8000, 15.2500, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[24] = AddStaticVehicleEx(462, 1138.4000, -1466.8000, 15.3700, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[25] = AddStaticVehicleEx(471, 1135.6000, -1466.8000, 15.2500, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[26] = AddStaticVehicleEx(462, 1132.8000, -1466.8000, 15.3700, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[27] = AddStaticVehicleEx(462, 1124.9000, -1466.8000, 15.3700, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[28] = AddStaticVehicleEx(471, 1121.9500, -1466.8000, 15.2500, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[29] = AddStaticVehicleEx(462, 1119.4000, -1466.8000, 15.3700, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[30] = AddStaticVehicleEx(471, 1116.4000, -1466.8000, 15.2500, 0.0000, 1, 1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}LS Beach Hotel\nRent a bike", -1, 848.9000, -2052.5000, 12.4670, 10.0);
    rentcar[31] = AddStaticVehicleEx(462, 848.9000, -2059.7000, 12.4670, 90.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[32] = AddStaticVehicleEx(462, 848.9000, -2057.0000, 12.4670, 90.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[33] = AddStaticVehicleEx(462, 848.9000, -2054.3000, 12.4670, 90.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[34] = AddStaticVehicleEx(462, 848.9000, -2051.6000, 12.4670, 90.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[35] = AddStaticVehicleEx(462, 848.9000, -2048.9000, 12.4670, 90.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[36] = AddStaticVehicleEx(462, 848.9000, -2046.2000, 12.4670, 90.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}LS Beach Hotel\nRent a bike", -1, 824.4000, -2052.5000, 12.4670, 10.0);
    rentcar[37] = AddStaticVehicleEx(462, 824.4000, -2059.7000, 12.4670, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[38] = AddStaticVehicleEx(462, 824.4000, -2057.0000, 12.4670, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[39] = AddStaticVehicleEx(462, 824.4000, -2054.3000, 12.4670, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[40] = AddStaticVehicleEx(462, 824.4000, -2051.6000, 12.4670, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[41] = AddStaticVehicleEx(462, 824.4000, -2048.9000, 12.4670, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[42] = AddStaticVehicleEx(462, 824.4000, -2046.2000, 12.4670, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);


    CreateDynamic3DTextLabel("{FFA500}County Hospital\nRent a bike", -1, 1979.0000, -1445.0000, 13.1558, 10.0);
    rentcar[43] = AddStaticVehicleEx(462, 1979.0000, -1448.0000, 13.1527, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[44] = AddStaticVehicleEx(462, 1979.0000, -1446.0000, 13.1645, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[45] = AddStaticVehicleEx(462, 1979.0000, -1444.0000, 13.1558, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[46] = AddStaticVehicleEx(462, 1979.0000, -1442.0000, 13.2022, 270.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}County Hospital\nRent a bike", -1, 1971.6000, -1452.7000, 13.1500, 10.0);
    rentcar[47] = AddStaticVehicleEx(462, 1974.6000, -1452.7000, 13.1500, 180.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[48] = AddStaticVehicleEx(462, 1972.6000, -1452.7000, 13.1500, 180.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[49] = AddStaticVehicleEx(462, 1970.6000, -1452.7000, 13.1500, 180.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);
    rentcar[50] = AddStaticVehicleEx(462, 1968.6000, -1452.7000, 13.1500, 180.0000 ,1 ,1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}Casino\nRent a bike", -1, 1453.0000, -1046.1400, 23.4000, 10.0);
    rentcar[51] = AddStaticVehicleEx(463, 1448.0000, -1046.1400, 23.4000,0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[52] = AddStaticVehicleEx(463, 1450.0000, -1046.1400, 23.4000,0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[53] = AddStaticVehicleEx(463, 1452.0000, -1046.1400, 23.4000,0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[54] = AddStaticVehicleEx(463, 1454.0000, -1046.1400, 23.4000,0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[55] = AddStaticVehicleEx(463, 1456.0000, -1046.1400, 23.4000,0.0000, 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[56] = AddStaticVehicleEx(463, 1458.0000, -1046.1400, 23.4000,0.0000, 1, 1, RENT_VEHICLE_RESPAWN);

    CreateDynamic3DTextLabel("{FFA500}Saint Fierro\nRent a bike", -1, -1509.0000, 736.0000, 6.9500, 10.0);
    rentcar[57] = AddStaticVehicleEx(521, -1509.0000, 728.0000, 6.9500, 90.000 , 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[58] = AddStaticVehicleEx(415, -1509.0000, 732.0000, 6.9500, 90.000 , 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[59] = AddStaticVehicleEx(451, -1509.0000, 736.0000, 6.9500, 90.000 , 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[60] = AddStaticVehicleEx(541, -1509.0000, 740.0000, 6.9500, 90.000 , 1, 1, RENT_VEHICLE_RESPAWN);
    rentcar[61] = AddStaticVehicleEx(521, -1509.0000, 744.0000, 6.9500, 90.000 , 1, 1, RENT_VEHICLE_RESPAWN);

    return 1;
}


hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if ((IsARentableCar(vehicleid) && Renting[playerid] != vehicleid))
        {
            WaitRentingTimeout[playerid] = 5;
            Dialog_Show(playerid, RentCar, DIALOG_STYLE_MSGBOX, "Rent a truck", "Are you sure you want to rent this truck for $%d?", "Yes", "No", RENT_CAR_PRICE);
        }
    }
    return 1;
}
hook OnPlayerHeartBeat(playerid)
{
    if (WaitRentingTimeout[playerid])
    {
        WaitRentingTimeout[playerid]--;

        if (WaitRentingTimeout[playerid] == 0)
        {
            Dialog_Show(playerid, 1, DIALOG_STYLE_MSGBOX, "Rent a truck", "You failed to rent this vehicle.", "Ok", "");
            RemovePlayerFromVehicle(playerid);
        }
    }
    return 1;
}
hook OnPlayerInit(playerid)
{
    Renting[playerid] = 0;
    WaitRentingTimeout[playerid] = 0;
}

Dialog:RentCar(playerid, response, listitem, inputtext[])
{
    WaitRentingTimeout[playerid] = 0;

    if (!response)
    {
        RemovePlayerFromVehicle(playerid);
    }
    else
    {
        if (PlayerData[playerid][pCash] < RENT_CAR_PRICE)
        {
            SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't rent this.");
            RemovePlayerFromVehicle(playerid);
        }
        else
        {
            GivePlayerCash(playerid, -RENT_CAR_PRICE);
            SendClientMessage(playerid, COLOR_GREY, "Dealership: Thank you for renting, have fun!");
            Renting[playerid] = GetPlayerVehicleID(playerid);
        }
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
    if (GetPlayerState(playerid) == 1)
        return 1;

    if (Renting[playerid] != 0 && Renting[playerid] == GetPlayerVehicleID(playerid))
    {
        SendClientMessage(playerid, COLOR_RED, "You have 60 seconds to go back at truck otherwise you will have to re-pay for it.");
        SetTimerEx("LeftVehicle", 60000, false, "i", playerid);
    }
    return 1;
}

publish LeftVehicle(playerid)
{
    if (Renting[playerid] != GetPlayerVehicleID(playerid) && Renting[playerid] != 0)
    {
        Renting[playerid] = 0;
        SendClientMessage(playerid, COLOR_RED, "Your renting timer is over, you are now able to rent again.");
    }
    WaitRentingTimeout[playerid] = 0;
    return 1;
}
