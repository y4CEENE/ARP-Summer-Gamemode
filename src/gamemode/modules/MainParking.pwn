/// @file      MainParking.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-31 15:18:30 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static Float:ParkingGetCarPosition[][] = {{1232.1295, -1308.2200, 13.5124}, {-2035.0459, 307.3203, 35.6635}, {1626.1976,-1137.2291,23.9063}};
static Float:ParkingSpawnPosition [][] = {{1230.8282, -1299.5665, 13.0709}, {-2029.4335, 290.6786, 35.1635}, {1626.2640,-1128.4218,23.6218}};

#define MAIN_PARKING_PRICE 500

static ParkingSpawnTimer=0;

hook OnGameModeInit()
{
    new str[128];
    format(str, sizeof(str), "Type /getmycar\n to get your car here\nFees: %s", FormatCash(MAIN_PARKING_PRICE));
    for (new index=0;index<sizeof(ParkingGetCarPosition);index++)
    {
        CreateDynamicPickup(1239, 23, ParkingGetCarPosition[index][0], ParkingGetCarPosition[index][1], ParkingGetCarPosition[index][2], -1);
        CreateDynamic3DTextLabel(str, COLOR_YELLOW, ParkingGetCarPosition[index][0], ParkingGetCarPosition[index][1], ParkingGetCarPosition[index][2] + 0.5, 4.0);
    }
}

GetNearestParkingID(playerid)
{
    for (new index=0;index<sizeof(ParkingGetCarPosition);index++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, ParkingGetCarPosition[index][0], ParkingGetCarPosition[index][1], ParkingGetCarPosition[index][2]))
        {
            return index;
        }
    }
    return -1;
}

CMD:getmycar(playerid, params[])
{
    if (PlayerData[playerid][pAdminDuty] == 1)
    {
       return SendClientMessage(playerid,COLOR_WHITE, "You can't use this command while on-duty as admin.");
    }

    if (GetNearestParkingID(playerid) == -1)
    {
        return SendClientMessage(playerid, COLOR_WHITE, "You are not in a parking.");
    }

    if (ParkingSpawnTimer>0)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You need to wait %dsec before spawning a car.", ParkingSpawnTimer);
    }

    DBFormat("SELECT * FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
    DBExecute("OnMainParkingMenu", "i",  playerid);

    return 1;
}


DB:OnMainParkingMenu(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "You own no vehicles which you can spawn.");
    }
    else
    {
        new string[1024], vehicleid;

        string = "Model\tStatus\tLocation\tTickets";

        for (new i = 0; i < rows; i ++)
        {
            if (GetDBIntField(i, "carImpounded"))
            {
                format(string, sizeof(string), "%s\n[#%i] %s\t{FF6347}Impounded{FFFFFF}\t%s\t%s",
                    string,
                    i + 1,
                    GetVehicleNameByModel(GetDBIntField(i, "modelid")),
                    (GetDBIntField(i, "world")) ? ("Garage") : (GetZoneName(GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z"))),
                    FormatCash(GetDBIntField(i, "tickets") + GetDBIntField(i, "carImpoundPrice")));
            }
            else if ((vehicleid = GetVehicleLinkedID(GetDBIntField(i, "id"))) != INVALID_VEHICLE_ID)
            {
                format(string, sizeof(string), "%s\n[#%i] %s\t{00AA00}Spawned{FFFFFF}\t%s\t%s",
                    string,
                    i + 1,
                    GetVehicleNameByModel(GetVehicleModel(vehicleid)),
                    GetVehicleZoneName(vehicleid),
                    FormatCash(GetDBIntField(i, "tickets")));
            }
            else
            {
                format(string, sizeof(string), "%s\n[#%i] %s\t{FF6347}Despawned{FFFFFF}\t%s\t%s",
                    string,
                    i + 1,
                    GetVehicleNameByModel(GetDBIntField(i, "modelid")),
                    (GetDBIntField(i, "world")) ? ("Garage") : (GetZoneName(GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z"))),
                    FormatCash(GetDBIntField(i, "tickets")));
            }
        }
        Dialog_Show(playerid, MainParkingResponse, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to (de)spawn.", string, "Select", "Cancel");
    }
    return 1;
}

Dialog:MainParkingResponse(playerid, response, listitem, inputtext[])
{
    if (response && listitem != -1)
    {
        DBFormat("SELECT id,carImpounded FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerData[playerid][pID], listitem);
        DBExecute("OnMainParkingUseCar", "i", playerid);

    }
    return 1;
}

DB:OnMainParkingUseCar(playerid)
{
    new vehicleid = GetVehicleLinkedID(GetDBIntField(0, "id"));

    if (GetDBIntField(0, "carImpounded"))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is impounded. You must pay the tickets in DMV.");
    }

    if (ParkingSpawnTimer>0)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You need to wait %dsec before spawning a car.", ParkingSpawnTimer);
    }

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        DBFormat("SELECT * FROM vehicles WHERE id = %i AND ownerid = %i", GetDBIntField(0, "id"), PlayerData[playerid][pID]);
        DBExecute("OnParkingSpawnVehicle", "ii", playerid, false);
        return 1;
    }

    if (IsVehicleBeingPicked(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is being broken into!");
    }

    if (IsVehicleTowedToTrailer(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is towed!");
    }

    DespawnVehicle(vehicleid);
    return 1;
}

DB:OnParkingSpawnVehicle(playerid, parked)
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The slot specified contains no valid vehicle which you can spawn.");
    }
    else
    {
        if (ParkingSpawnTimer>0)
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "You need to wait %dsec before spawning a car.", ParkingSpawnTimer);
        }
        ParkingSpawnTimer = 10;

        if (GetVehicleLinkedID(GetDBIntField(0, "id")) != INVALID_VEHICLE_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle is spawned already. /findcar to track it.");
        }

        if (GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES && PlayerData[playerid][pDonator] < 3)//vipveh
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
        }

        if (GetPlayerCash(playerid) < MAIN_PARKING_PRICE)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to get your car.", FormatCash(MAIN_PARKING_PRICE));
        }

        GivePlayerCash(playerid, -MAIN_PARKING_PRICE);

        SendClientMessageEx(playerid, COLOR_AQUA, "You paid %s to get your car. You have 30 seconds to get your car.", FormatCash(MAIN_PARKING_PRICE));

        new
            modelid = GetDBIntField(0, "modelid"),
            Float:x = GetDBFloatField(0, "pos_x"),
            Float:y = GetDBFloatField(0, "pos_y"),
            Float:z = GetDBFloatField(0, "pos_z"),
            Float:a = GetDBFloatField(0, "pos_a"),
            color1 = GetDBIntField(0, "color1"),
            color2 = GetDBIntField(0, "color2"),
            vehicleid;

        new parkingid = GetNearestParkingID(playerid);

        if (parkingid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Internal Error! Cannot get parking id.");
        }

        vehicleid = CreateVehicle(modelid, ParkingSpawnPosition[parkingid][0], ParkingSpawnPosition[parkingid][1], ParkingSpawnPosition[parkingid][2], 270.0000, color1, color2, -1);

        if (vehicleid != INVALID_VEHICLE_ID)
        {
            ResetVehicle(vehicleid);

            GetDBStringField(0, "owner", VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
            GetDBStringField(0, "plate", VehicleInfo[vehicleid][vPlate], 32);
            VehicleInfo[vehicleid][vID] = GetDBIntField(0, "id");
            VehicleInfo[vehicleid][vOwnerID] = GetDBIntField(0, "ownerid");
            VehicleInfo[vehicleid][vPrice] = GetDBIntField(0, "price");
            VehicleInfo[vehicleid][vTickets] = GetDBIntField(0, "tickets");
            VehicleInfo[vehicleid][vLocked] = GetDBIntField(0, "locked");
            VehicleInfo[vehicleid][vHealth] = 1000.0;
            VehicleInfo[vehicleid][vPaintjob] = GetDBIntField(0, "paintjob");
            VehicleInfo[vehicleid][vInterior] = GetDBIntField(0, "interior");
            VehicleInfo[vehicleid][vWorld] = GetDBIntField(0, "world");
            VehicleInfo[vehicleid][vNeon] = GetDBIntField(0, "neon");
            VehicleInfo[vehicleid][vNeonEnabled] = GetDBIntField(0, "neonenabled");
            VehicleInfo[vehicleid][vTrunk] = GetDBIntField(0, "trunk");
            VehicleInfo[vehicleid][vAlarm] = GetDBIntField(0, "alarm");
            VehicleInfo[vehicleid][vMods][0] = GetDBIntField(0, "mod_1");
            VehicleInfo[vehicleid][vMods][1] = GetDBIntField(0, "mod_2");
            VehicleInfo[vehicleid][vMods][2] = GetDBIntField(0, "mod_3");
            VehicleInfo[vehicleid][vMods][3] = GetDBIntField(0, "mod_4");
            VehicleInfo[vehicleid][vMods][4] = GetDBIntField(0, "mod_5");
            VehicleInfo[vehicleid][vMods][5] = GetDBIntField(0, "mod_6");
            VehicleInfo[vehicleid][vMods][6] = GetDBIntField(0, "mod_7");
            VehicleInfo[vehicleid][vMods][7] = GetDBIntField(0, "mod_8");
            VehicleInfo[vehicleid][vMods][8] = GetDBIntField(0, "mod_9");
            VehicleInfo[vehicleid][vMods][9] = GetDBIntField(0, "mod_10");
            VehicleInfo[vehicleid][vMods][10] = GetDBIntField(0, "mod_11");
            VehicleInfo[vehicleid][vMods][11] = GetDBIntField(0, "mod_12");
            VehicleInfo[vehicleid][vMods][12] = GetDBIntField(0, "mod_13");
            VehicleInfo[vehicleid][vMods][13] = GetDBIntField(0, "mod_14");
            VehicleInfo[vehicleid][vCash] = GetDBIntField(0, "cash");
            VehicleInfo[vehicleid][vMaterials] = GetDBIntField(0, "materials");
            VehicleInfo[vehicleid][vWeed] = GetDBIntField(0, "weed");
            VehicleInfo[vehicleid][vCocaine] = GetDBIntField(0, "cocaine");
            VehicleInfo[vehicleid][vHeroin] = GetDBIntField(0, "heroin");
            VehicleInfo[vehicleid][vPainkillers] = GetDBIntField(0, "painkillers");
            VehicleInfo[vehicleid][vWeapons][0] = GetDBIntField(0, "weapon_1");
            VehicleInfo[vehicleid][vWeapons][1] = GetDBIntField(0, "weapon_2");
            VehicleInfo[vehicleid][vWeapons][2] = GetDBIntField(0, "weapon_3");
            VehicleInfo[vehicleid][vWeapons][3] = GetDBIntField(0, "weapon_4");
            VehicleInfo[vehicleid][vWeapons][4] = GetDBIntField(0, "weapon_5");
            VehicleInfo[vehicleid][vGang] = -1;
            VehicleInfo[vehicleid][vFaction] = -1;
            VehicleInfo[vehicleid][vFGDivision] = -1;
            VehicleInfo[vehicleid][vJob] = JOB_NONE;
            VehicleInfo[vehicleid][vRespawnDelay] = -1;
            VehicleInfo[vehicleid][vModel] = modelid;
            VehicleInfo[vehicleid][vPosX] = x;
            VehicleInfo[vehicleid][vPosY] = y;
            VehicleInfo[vehicleid][vPosZ] = z;
            VehicleInfo[vehicleid][vPosA] = a;
            VehicleInfo[vehicleid][vColor1] = color1;
            VehicleInfo[vehicleid][vColor2] = color2;
            VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
            VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
            VehicleInfo[vehicleid][vTimer] = -1;
            VehicleInfo[vehicleid][vRank] = 0;
            VehicleInfo[vehicleid][carImpounded] = GetDBIntField(0, "carImpounded");
            VehicleInfo[vehicleid][carImpoundPrice] = GetDBIntField(0, "carImpoundPrice");
            RefuelVehicle(vehicleid);
            adminVehicle[vehicleid] = false;

            VehicleInfo[vehicleid][vForSale] = bool:GetDBIntField(0, "forsale");
            VehicleInfo[vehicleid][vForSalePrice] = GetDBIntField(0, "forsaleprice");

            VehicleInfo[vehicleid][vMileage] = GetDBFloatField(0, "mileage");

            if (VehicleInfo[vehicleid][vForSale])
            {
                new forsale[264];
                format(forsale, sizeof(forsale), "FOR SALE\n%s - %s\nPh: %i.", GetVehicleName(vehicleid), FormatCash(VehicleInfo[vehicleid][vForSalePrice]), PlayerData[playerid][pPhone]);
                VehicleInfo[vehicleid][vForSaleLabel] = CreateDynamic3DTextLabel(forsale, COLOR_GREY2, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, vehicleid, 1, -1, 0, -1, 30.0);
            }
            SetVehicleToRespawn(vehicleid);
            ReloadVehicle(vehicleid);



        }

    }

    return 1;
}

static VehicleParkingRespawnTimer[MAX_VEHICLES];

hook OnVehicleSpawn(vehicleid)
{
    VehicleParkingRespawnTimer[vehicleid] = 0;
    return 1;
}
hook OnServerHeartBeat(timestamp)
{
    if (ParkingSpawnTimer>0)
    {
        ParkingSpawnTimer--;
    }
}

hook OnServerBeacon(timestamp)
{
    new Float:x;
    new Float:y;
    new Float:z;

    for (new vehicleid=0;vehicleid<MAX_VEHICLES;vehicleid++)
    {
        if (!IsValidVehicle(vehicleid))
        {
            continue;
        }

        GetVehiclePos(vehicleid, x, y, z);

        new isCarNearParking = false;
        for (new index=0;index<sizeof(ParkingSpawnPosition);index++)
        {
            if (IsPointInRangeOfPoint(x, y, z, 30.0, ParkingSpawnPosition[index][0], ParkingSpawnPosition[index][1], ParkingSpawnPosition[index][2]))
            {
                isCarNearParking = true;
            }
        }

        if ( !isCarNearParking || IsVehicleOccupied(vehicleid) || adminVehicle[vehicleid] || IsARentableCar(vehicleid))
        {
            VehicleParkingRespawnTimer[vehicleid] = 0;
            continue;
        }


        VehicleParkingRespawnTimer[vehicleid]++;

        if (VehicleParkingRespawnTimer[vehicleid] > 3)
        {
            VehicleParkingRespawnTimer[vehicleid] = 0;

            if (VehicleInfo[vehicleid][vOwnerID]>0)
            {
                new playerid = GetVehicleOwnerID(vehicleid);

                if (IsPlayerConnected(playerid))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You vehicle has been auto parked for leaving it near parking.");
                }
                DespawnVehicle(vehicleid);
            }
            else
            {
                SetVehicleToRespawn(vehicleid);
            }
        }
    }
    return 1;
}
