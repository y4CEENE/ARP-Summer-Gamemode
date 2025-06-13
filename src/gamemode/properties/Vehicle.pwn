/// @file      Vehicle.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


GetVehicleOwnerID(vehicleid)
{
    foreach(new playerid: Player)
    {
        if (PlayerData[playerid][pID] == VehicleInfo[vehicleid][vOwnerID])
        {
            return playerid;
        }
    }
    return INVALID_PLAYER_ID;
}

GetGangVehicles(gangid)
{
    new count;

    foreach(new i: Vehicle)
    {
        if (VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == gangid)
        {
            count++;
        }
    }

    return count;
}

GetGangVehicleLimit(gangid)
{
    switch (GangInfo[gangid][gLevel])
    {
        case 1: return 8;
        case 2: return 10;
        case 3: return 15;
    }

    return 0;
}

GetSpawnedVehicles(playerid)
{
    new count;

    foreach(new i: Vehicle)
    {
        if (IsVehicleOwner(playerid, i))
        {
            count++;
        }
    }

    return count;
}

GetVehicleGarage(vehicleid)
{
    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && GarageInfo[i][gWorld] == GetVehicleVirtualWorld(vehicleid))
        {
            return i;
        }
    }

    return -1;
}

ResetVehicleObjects(vehicleid)
{
    if (IsValidDynamicObject(vehicleSiren[vehicleid]))
    {
        DestroyDynamicObject(vehicleSiren[vehicleid]);
        vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
    }
    if (IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
    {
        DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
        DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
    }
    if (IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
    {
        DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
        vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
    }
    if (VehicleInfo[vehicleid][vNeonEnabled])
    {
        if (IsValidDynamicObject(VehicleInfo[vehicleid][vObjects][0]))
        {
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
            VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
        }
        if (IsValidDynamicObject(VehicleInfo[vehicleid][vObjects][1]))
        {
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
            VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
        }
    }

    adminVehicle[vehicleid] = false;
}

DestroyVehicleEx(vehicleid)
{
    if (IsValidVehicle(vehicleid))
    {
        ResetVehicleObjects(vehicleid);
    }

    return DestroyVehicle(vehicleid);
}

GetNearbyVehicle(playerid)
{
    new Float:x, Float:y, Float:z;

    foreach(new i: Vehicle)
    {
        if (IsVehicleStreamedIn(i, playerid))
        {
            GetVehiclePos(i, x, y, z);

            if (IsPlayerInRangeOfPoint(playerid, 3.5, x, y, z))
            {
                return i;
            }
        }
    }

    return INVALID_VEHICLE_ID;
}

IsVehicleOwner(playerid, vehicleid)
{
    return (VehicleInfo[vehicleid][vOwnerID] == PlayerData[playerid][pID]);
}

IsPlayerGangVehicle(playerid, vehicleid)
{
    return ((VehicleInfo[vehicleid][vGang] == PlayerData[playerid][pGang]) &&
            (PlayerData[playerid][pGang]   >= 0));
}

SetVehicleNeon(vehicleid, modelid)
{
    if (18647 <= modelid <= 18652)
    {
        if (VehicleInfo[vehicleid][vNeonEnabled])
        {
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
        }

        VehicleInfo[vehicleid][vNeon] = modelid;
        VehicleInfo[vehicleid][vNeonEnabled] = (modelid > 0);

        DBQuery("UPDATE vehicles SET neon = %i, neonenabled = 1 WHERE id = %i", VehicleInfo[vehicleid][vNeon], VehicleInfo[vehicleid][vID]);

        ReloadVehicleNeon(vehicleid);
    }
}

ReloadVehicleNeon(vehicleid)
{
    if (VehicleInfo[vehicleid][vID] > 0)
    {
        DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
        DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);

        if (VehicleInfo[vehicleid][vNeon] && VehicleInfo[vehicleid][vNeonEnabled])
        {
            new
                Float:x,
                Float:y,
                Float:z;

            GetVehicleModelInfo(VehicleInfo[vehicleid][vModel], VEHICLE_MODEL_INFO_SIZE, x, y, z);

            VehicleInfo[vehicleid][vObjects][0] = CreateDynamicObject(VehicleInfo[vehicleid][vNeon], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            VehicleInfo[vehicleid][vObjects][1] = CreateDynamicObject(VehicleInfo[vehicleid][vNeon], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

            AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vObjects][0], vehicleid, -x / 2.8, 0.0, -0.6, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vObjects][1], vehicleid, x / 2.8, 0.0, -0.6, 0.0, 0.0, 0.0);
        }
    }
}

ResyncVehicle(vehicleid)
{
    new
        worldid = GetVehicleVirtualWorld(vehicleid);
    SetVehicleVirtualWorld(vehicleid, cellmax);
    SetVehicleVirtualWorld(vehicleid, worldid);
}

SaveVehicleModifications(vehicleid, save_damage=false)
{
    VehicleInfo[vehicleid][vPaintjob] = GetVehiclePaintJob(vehicleid);
    GetVehicleColor(vehicleid, VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2]);
    DBFormat("UPDATE vehicles SET paintjob = %i, color1 = %i, color2 = %i",
            VehicleInfo[vehicleid][vPaintjob],
            VehicleInfo[vehicleid][vColor1],
            VehicleInfo[vehicleid][vColor2]);

    for (new i = 0; i < 14; i ++)
    {
        VehicleInfo[vehicleid][vMods][i] = GetVehicleComponentInSlot(vehicleid, i);
        DBContinueFormat(", mod_%i = %i", i + 1, VehicleInfo[vehicleid][vMods][i]);
    }
    if (save_damage)
    {
        new Float:health;
        GetVehicleHealth(vehicleid, health);
        DBContinueFormat(", fuel = %i, mileage = '%f', health = '%f'",
            GetVehicleFuel(vehicleid),
            VehicleInfo[vehicleid][vMileage],
            health);
    }
    DBContinueFormat(" WHERE id = %i", VehicleInfo[vehicleid][vID]);
    DBExecute();
}

ReloadVehicle(vehicleid)
{
    if (VehicleInfo[vehicleid][vPaintjob] >= 0)
    {
        ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][vPaintjob]);
    }
    if (VehicleInfo[vehicleid][vNeon] && VehicleInfo[vehicleid][vNeonEnabled])
    {
        ReloadVehicleNeon(vehicleid);
    }

    for (new i = 0; i < 14; i ++)
    {
        new mod = VehicleInfo[vehicleid][vMods][i];
        if (mod >= 1000 && IsVehicleUpgrade(vehicleid, mod))
        {
            AddVehicleComponent(vehicleid, mod);
        }
    }
    SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][vPlate]);
    ResyncVehicle(VehicleInfo[vehicleid][vID]);
    LinkVehicleToInterior(vehicleid, VehicleInfo[vehicleid][vInterior]);
    SetVehicleVirtualWorld(vehicleid, VehicleInfo[vehicleid][vWorld]);
    SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][vHealth]);
    SetVehicleParams(vehicleid, VEHICLE_DOORS, VehicleInfo[vehicleid][vLocked]);
}

DespawnVehicle(vehicleid, bool:save = true)
{
    if (VehicleInfo[vehicleid][vID] > 0)
    {
        if (VehicleInfo[vehicleid][vNeonEnabled])
        {
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
        }

        if (save)
        {
            SaveVehicleModifications(vehicleid, true);
        }
        else
        {
            DBQuery("UPDATE vehicles SET mileage = '%f' WHERE id = %i", VehicleInfo[vehicleid][vMileage], VehicleInfo[vehicleid][vID]);
        }

        DestroyVehicleEx(vehicleid);
        ResetVehicle(vehicleid);
    }
}

ResetVehicle(vehicleid)
{
    strcpy(VehicleInfo[vehicleid][vOwner], "Nobody", MAX_PLAYER_NAME);

    if (VehicleInfo[vehicleid][vTimer] >= 0)
    {
        KillTimer(VehicleInfo[vehicleid][vTimer]);
    }
    strcpy(VehicleInfo[vehicleid][vPlate], "XYZSR998");
    VehicleInfo[vehicleid][vID] = 0;
    VehicleInfo[vehicleid][vOwnerID] = 0;
    VehicleInfo[vehicleid][vModel] = 0;
    VehicleInfo[vehicleid][vPrice] = 0;
    VehicleInfo[vehicleid][vTickets] = 0;
    VehicleInfo[vehicleid][vLocked] = 0;
    VehicleInfo[vehicleid][vCorp] = -1;
    VehicleInfo[vehicleid][vHealth] = 1000.0;
    VehicleInfo[vehicleid][vPosX] = 0.0;
    VehicleInfo[vehicleid][vPosY] = 0.0;
    VehicleInfo[vehicleid][vPosZ] = 0.0;
    VehicleInfo[vehicleid][vPosA] = 0.0;
    VehicleInfo[vehicleid][vColor1] = 0;
    VehicleInfo[vehicleid][vColor2] = 0;
    VehicleInfo[vehicleid][vPaintjob] = -1;
    VehicleInfo[vehicleid][vInterior] = 0;
    VehicleInfo[vehicleid][vWorld] = 0;
    VehicleInfo[vehicleid][vCash] = 0;
    VehicleInfo[vehicleid][vMaterials] = 0;
    VehicleInfo[vehicleid][vWeed] = 0;
    VehicleInfo[vehicleid][vCocaine] = 0;
    VehicleInfo[vehicleid][vHeroin] = 0;
    VehicleInfo[vehicleid][vPainkillers] = 0;
    VehicleInfo[vehicleid][vWeapons][0] = 0;
    VehicleInfo[vehicleid][vWeapons][1] = 0;
    VehicleInfo[vehicleid][vWeapons][2] = 0;
    VehicleInfo[vehicleid][vWeapons][3] = 0;
    VehicleInfo[vehicleid][vWeapons][4] = 0;
    VehicleInfo[vehicleid][vGang] = -1;
    VehicleInfo[vehicleid][vFaction] = -1;
    VehicleInfo[vehicleid][vFGDivision] = -1;
    VehicleInfo[vehicleid][vVIP] = 0;
    VehicleInfo[vehicleid][vJob] = JOB_NONE;
    VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
    VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
    VehicleInfo[vehicleid][vTimer] = -1;
    VehicleInfo[vehicleid][vRank] = 0;
    VehicleInfo[vehicleid][vMileage] = 0.0;

    VehicleInfo[vehicleid][vForSale] = false;
    VehicleInfo[vehicleid][vForSalePrice] = 0;

    if (VehicleInfo[vehicleid][vForSaleLabel] != Text3D:INVALID_3DTEXT_ID) DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][vForSaleLabel]);
    VehicleInfo[vehicleid][vForSaleLabel] = Text3D:INVALID_3DTEXT_ID;

    for (new i = 0; i < 14; i ++)
    {
        VehicleInfo[vehicleid][vMods][i] = 0;
    }

    ResetVehicleObjects(vehicleid);
}

static const vehicleStashCapacities[][] = {
    // Cash      Mats      W      C     M     P   W
    { 250000,   50000,   250,   250,  100,   50,  3}, // level 1
    { 500000,  100000,   500,   500,  250,  100,  4}, // level 2
    {1000000,  250000,  1000,   750,  500,  200,  5}  // level 3
};

GetVehicleStashCapacity(vehicleid, item)
{

    if (VehicleInfo[vehicleid][vTrunk] > 0)
    {
        return vehicleStashCapacities[VehicleInfo[vehicleid][vTrunk] - 1][item];
    }

    return 0;
}

IsVehicleInGarage(vehicleid, garageid)
{
    new
        Float:x,
        Float:y,
        Float:z;

    GetVehiclePos(vehicleid, x, y, z);

    return IsPointInRangeOfPoint(x, y, z, 50.0, garageInteriors[GarageInfo[garageid][gType]][intVX], garageInteriors[GarageInfo[garageid][gType]][intVY], garageInteriors[GarageInfo[garageid][gType]][intVZ]) && GetVehicleVirtualWorld(vehicleid) == GarageInfo[garageid][gWorld];
}

DB:ListVehicles(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "You own no vehicles which you can spawn.");
    }
    else
    {
        static string[1024];

        string = "#\tModel\tLocation";

        for (new i = 0; i < rows; i ++)
        {
            format(string, sizeof(string), "%s\n%i\t%s\t%s", string, i + 1, GetVehicleNameByModel(GetDBIntField(i, "modelid")), (GetDBIntField(i, "world")) ? ("Garage") : (GetZoneName(GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z"))));
        }

        Dialog_Show(playerid, DIALOG_SPAWNCAR, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to spawn.", string, "Select", "Cancel");
    }
}

DB:CarStorage(playerid)
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
        Dialog_Show(playerid, DIALOG_CARSTORAGE, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to (de)spawn.", string, "Select", "Cancel");
    }
}

DB:OnLoadVehicles()
{
    new rows = GetDBNumRows();
    new modelid;
    new Float:pos_x;
    new Float:pos_y;
    new Float:pos_z;
    new Float:pos_a;
    new color1;
    new color2;
    new respawndelay;
    new siren;
    new vehicleid;

    for (new i = 0; i < rows; i ++)
    {
        modelid         = GetDBIntField(i, "modelid"),
        pos_x           = GetDBFloatField(i, "pos_x"),
        pos_y           = GetDBFloatField(i, "pos_y"),
        pos_z           = GetDBFloatField(i, "pos_z"),
        pos_a           = GetDBFloatField(i, "pos_a"),
        color1          = GetDBIntField(i, "color1"),
        color2          = GetDBIntField(i, "color2"),
        respawndelay    = GetDBIntField(i, "respawndelay");
        siren           = GetDBIntField(i, "siren");

        vehicleid = CreateVehicle(modelid, pos_x, pos_y, pos_z, pos_a, color1, color2, respawndelay, siren);


        if (vehicleid != INVALID_VEHICLE_ID)
        {
            ResetVehicle(vehicleid); // Forgot this!
            GetDBStringField(0, "plate", VehicleInfo[vehicleid][vPlate], 32);
            VehicleInfo[vehicleid][vID] = GetDBIntField(i, "id");
            VehicleInfo[vehicleid][vGang] = GetDBIntField(i, "gangid");
            VehicleInfo[vehicleid][vFaction] = GetDBIntField(i, "factionid");
            VehicleInfo[vehicleid][vFGDivision] = GetDBIntField(i, "fgdivisionid");
            VehicleInfo[vehicleid][vRank] = GetDBIntField(i, "rank");
            VehicleInfo[vehicleid][vVIP] = GetDBIntField(i, "vippackage");
            VehicleInfo[vehicleid][vJob] = GetDBIntField(i, "job");
            VehicleInfo[vehicleid][vHealth] = GetDBFloatField(i, "health");
            VehicleInfo[vehicleid][carImpounded] = GetDBIntField(i, "carImpounded");
            VehicleInfo[vehicleid][carImpoundPrice] = GetDBIntField(i, "carImpoundPrice");
            VehicleInfo[vehicleid][vMileage] = GetDBFloatField(i, "mileage");
            VehicleInfo[vehicleid][vPrice] = GetDBIntField(i, "price");
            VehicleInfo[vehicleid][vLocked] = GetDBIntField(i, "locked");
            VehicleInfo[vehicleid][vPaintjob] = GetDBIntField(i, "paintjob");
            VehicleInfo[vehicleid][vInterior] = GetDBIntField(i, "interior");
            VehicleInfo[vehicleid][vWorld] = GetDBIntField(i, "world");
            VehicleInfo[vehicleid][vMods][0] = GetDBIntField(i, "mod_1");
            VehicleInfo[vehicleid][vMods][1] = GetDBIntField(i, "mod_2");
            VehicleInfo[vehicleid][vMods][2] = GetDBIntField(i, "mod_3");
            VehicleInfo[vehicleid][vMods][3] = GetDBIntField(i, "mod_4");
            VehicleInfo[vehicleid][vMods][4] = GetDBIntField(i, "mod_5");
            VehicleInfo[vehicleid][vMods][5] = GetDBIntField(i, "mod_6");
            VehicleInfo[vehicleid][vMods][6] = GetDBIntField(i, "mod_7");
            VehicleInfo[vehicleid][vMods][7] = GetDBIntField(i, "mod_8");
            VehicleInfo[vehicleid][vMods][8] = GetDBIntField(i, "mod_9");
            VehicleInfo[vehicleid][vMods][9] = GetDBIntField(i, "mod_10");
            VehicleInfo[vehicleid][vMods][10] = GetDBIntField(i, "mod_11");
            VehicleInfo[vehicleid][vMods][11] = GetDBIntField(i, "mod_12");
            VehicleInfo[vehicleid][vMods][12] = GetDBIntField(i, "mod_13");
            VehicleInfo[vehicleid][vMods][13] = GetDBIntField(i, "mod_14");
            VehicleInfo[vehicleid][vModel] = modelid;
            VehicleInfo[vehicleid][vPosX] = pos_x;
            VehicleInfo[vehicleid][vPosY] = pos_y;
            VehicleInfo[vehicleid][vPosZ] = pos_z;
            VehicleInfo[vehicleid][vPosA] = pos_a;
            VehicleInfo[vehicleid][vColor1] = color1;
            VehicleInfo[vehicleid][vColor2] = color2;
            VehicleInfo[vehicleid][vRespawnDelay] = respawndelay;
            VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
            VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
            VehicleInfo[vehicleid][vTimer] = -1;

            ReloadVehicle(vehicleid);
            RefuelVehicle(vehicleid);
            SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][vPlate]);
            SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][vHealth]);
        }
        else     SendClientMessageToAllEx(-1, "Cannot create %i", i);

    }
}


publish VehEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsVehicleParamOn(vehicleid, VEHICLE_ENGINE))
    {
        SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
        ShowActionBubble(playerid, "* %s's engine was turned on (( %s )).", GetVehicleName(vehicleid), GetRPName(playerid));
    }
    else
    {
        SetVehicleParams(vehicleid, VEHICLE_ENGINE, false);
        ShowActionBubble(playerid, "* %s's engine was turned off (( %s )).", GetVehicleName(vehicleid), GetRPName(playerid));

    }
    return 1;
}


Dialog:DIALOG_REMOVEPVEH(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new targetid = PlayerData[playerid][pRemoveFrom];

        if (targetid == INVALID_PLAYER_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player has disconnected. You can't remove their vehicles now.");
        }

        DBFormat("SELECT id, modelid FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerData[targetid][pID], listitem);
        DBExecute("OnVerifyRemoveVehicle", "ii", playerid, targetid);
    }
    return 1;
}

Dialog:DIALOG_VEHICLELOOKUP1(playerid, response, listitem, inputtext[])
{
    if ((response) && IsLawEnforcement(playerid))
    {
        new vehicleid, string[128];

        if (sscanf(inputtext, "i", vehicleid))
        {
            return Dialog_Show(playerid, DIALOG_VEHICLELOOKUP1, DIALOG_STYLE_INPUT, "Vehicle lookup", "Enter the ID of the vehicle to lookup.\n(( You can find out the ID of a vehicle by using /dl. ))", "Submit", "Cancel");
        }
        if (!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vOwnerID])
        {
            SendClientMessage(playerid, COLOR_GREY, "The vehicle ID specified is not owned by any particular person.");
            return Dialog_Show(playerid, DIALOG_VEHICLELOOKUP1, DIALOG_STYLE_INPUT, "Vehicle lookup", "Enter the ID of the vehicle to lookup.\n(( You can find out the ID of a vehicle by using /dl. ))", "Submit", "Cancel");
        }

        PlayerData[playerid][pSelected] = vehicleid;

        format(string, sizeof(string), "Name: %s\nOwner: %s\nTickets: $%i\nLocation: %s", GetVehicleName(vehicleid), VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vTickets], GetVehicleZoneName(vehicleid));
        Dialog_Show(playerid, DIALOG_VEHICLELOOKUP2, DIALOG_STYLE_MSGBOX, "Vehicle lookup", string, "Track", "Cancel");
    }
    return 1;
}
Dialog:DIALOG_VEHICLELOOKUP2(playerid, response, listitem, inputtext[])
{
    if ((response) && IsLawEnforcement(playerid))
    {
        new garageid, vehicleid = PlayerData[playerid][pSelected];

        if ((garageid = GetVehicleGarage(vehicleid)) >= 0)
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
            SendClientMessage(playerid, COLOR_WHITE, "Checkpoint marked at the garage this vehicle is inside of.");
        }
        else
        {
            new Float:x, Float:y, Float:z;
            GetVehiclePos(vehicleid, x, y, z);
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 3.0);
            SendClientMessage(playerid, COLOR_WHITE, "Checkpoint marked at the vehicle's last known location.");
        }
    }
    return 1;
}

Dialog:DIALOG_SPAWNCAR(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        DBFormat("SELECT * FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerData[playerid][pID], listitem);
        DBExecute("OnPlayerSpawnVehicle", "ii", playerid, false);
    }
    return 1;
}

Dialog:DIALOG_DESPAWNCAR(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new count;

        foreach(new i: Vehicle)
        {
            if ((VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i)) && (count++ == listitem))
            {
                if (IsVehicleOccupied(i) && GetVehicleDriver(i) != playerid)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This vehicle is occupied.");
                }

                SendClientMessageEx(playerid, COLOR_AQUA, "Your {FF6347}%s{33CCFF} which is located in %s has been despawned.", GetVehicleName(i), GetVehicleZoneName(i));
                DespawnVehicle(i);
                return 1;
            }
        }
    }
    return 1;
}

Dialog:DIALOG_CARSTORAGE(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        DBFormat("SELECT id FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerData[playerid][pID], listitem);
        DBExecute("OnPlayerUseCarStorage", "i", playerid);
    }
    return 1;
}

Dialog:DIALOG_FINDCAR(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new count, garageid;

        foreach(new i: Vehicle)
        {
            if ((VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i)) && (count++ == listitem))
            {
                if ((garageid = GetVehicleGarage(i)) >= 0)
                {
                    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "Your %s is located in a garage. Checkpoint marked at the garage's location.", GetVehicleName(i));
                }
                else
                {
                    new Float:x, Float:y, Float:z;
                    GetVehiclePos(i, x, y, z);
                    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 3.0);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "Your %s is located in %s. Checkpoint marked at the location.", GetVehicleName(i), GetZoneName(x, y, z));
                }
                return 1;
            }
        }
    }
    return 1;
}

Dialog:DIALOG_BUYVEHICLENEW(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: ShowVehicleSelectionMenu(playerid, MODEL_SELECTION_VEHICLES);
            case 1: SendClientMessage(playerid, COLOR_GREY, "TODO: Feature disabled");
        }
    }
    return 1;
}


public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
    {
        VehicleInfo[vehicleid][vColor1] = color1;
        VehicleInfo[vehicleid][vColor2] = color2;

        DBQuery("UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);
    }
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
    {
        VehicleInfo[vehicleid][vPaintjob] = paintjobid;

        DBQuery("UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
    }

    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    if (!GetPlayerInterior(playerid) && !IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pKicked])
    {
        BanPlayer(playerid, "Illegal modding");
        return 0;
    }

    if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
    {
        new slotid = GetVehicleComponentType(componentid);

        VehicleInfo[vehicleid][vMods][slotid] = componentid;

        DBQuery("UPDATE vehicles SET mod_%i = %i WHERE id = %i", slotid + 1, componentid, VehicleInfo[vehicleid][vID]);
    }

    return 1;
}

public OnVehicleSpawn(vehicleid)
{

    if (IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
    {
        DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
        DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
    }
    if (adminVehicle[vehicleid])
    {
        DestroyVehicleEx(vehicleid);
        adminVehicle[vehicleid] = false;
    }
    if (IsValidDynamicObject(vehicleSiren[vehicleid]))
    {
        DestroyDynamicObject(vehicleSiren[vehicleid]);
        vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
    }
    if (IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
    {
        DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
        vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;
    }


    if (VehicleInfo[vehicleid][vID] > 0)
    {
        ReloadVehicle(vehicleid);

        if (VehicleInfo[vehicleid][vOwnerID])
        {
            SetVehicleHealth(vehicleid, VehicleInfo[vehicleid][vHealth]);
        }
        else
        {
            RefuelVehicle(vehicleid);
        }
    }
    else
    {
        RefuelVehicle(vehicleid);
    }

    if (IsJobCar(vehicleid))
    {
        OnJobVehicleRespawn(vehicleid);
    }

    vehicleStream[vehicleid][0] = 0;
    return 1;
}

Dialog:DIALOG_BUYVEHICLE2(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        DBFormat("SELECT COUNT(*) FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
        DBExecute("OnPlayerAttemptBuyVehicle", "ii", playerid, PlayerData[playerid][pSelected]);
    }
    return 1;
}

GetVehicleValue(vehicleid)
{
    new
        price = VehicleInfo[vehicleid][vPrice];

    switch (VehicleInfo[vehicleid][vAlarm])
    {
        case 1: price += 15000;
        case 2: price += 30000;
        case 3: price += 60000;
    }

    if (VehicleInfo[vehicleid][vNeon])
    {
        price += 30000;
    }
    if (VehicleInfo[vehicleid][vTrunk])
    {
        price += VehicleInfo[vehicleid][vTrunk] * 10000;
    }
    return price;
}


GetVehicleLinkedID(id)
{
    foreach(new i: Vehicle)
    {
        if (VehicleInfo[i][vID] == id)
        {
            return i;
        }
    }

    return INVALID_VEHICLE_ID;
}

DB:OnVerifyRemoveVehicle(playerid, targetid)
{
    if (GetDBNumRows())
    {
        new vehicleid = GetVehicleLinkedID(GetDBIntField(0, "id")), modelid = GetDBIntField(0, "modelid");

        DBQuery("DELETE FROM vehicles WHERE id = %i", GetDBIntField(0, "id"));

        if (vehicleid != INVALID_VEHICLE_ID)
        {
            DespawnVehicle(vehicleid, false);
        }

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has removed %s's %s.", GetAdmCmdRank(playerid), GetRPName(playerid), GetRPName(targetid), GetVehicleNameByModel(modelid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}%s{33CCFF} from your vehicle list.", GetRPName(playerid), GetVehicleNameByModel(modelid));
    }
}

task MileageTimer[1000]()
{
    foreach(new i: Vehicle)
    {
        if ((GetVehicleDriver(i)) != INVALID_PLAYER_ID)
        {
            VehicleInfo[i][vMileage] += (GetVehicleSpeed(i, SPEED_UNIT_KMPH) * 0.00009722222);
        }
    }
}

publish DespawnTimer(vehicleid)
{
    if (VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOccupied(vehicleid) && !IsVehicleBeingPicked(vehicleid))
    {
        DespawnVehicle(vehicleid);
    }
    else
    {
        // ANOTHER TEN MINUTES!
        VehicleInfo[vehicleid][vTimer] = SetTimerEx("DespawnTimer", 300000, false, "i", vehicleid);
    }
}




hook OnPlayerExitVehicle(playerid, vehicleid)
{
    if (!IsValidVehicle(vehicleid))
    {
        return 1;
    }
    if (IsJobCar(vehicleid))
        CallRemoteFunction("OnPlayerExitJobCar", "iii", playerid, vehicleid, GetCarJobType(vehicleid));

    if (seatbelt[playerid] == 1)
    {
        RemovePlayerAttachedObject(playerid, 7);
        ShowActionBubble(playerid, "* %s reaches for their seatbelt, and unbuckles it.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_WHITE, "You have taken off your seatbelt.");
    }
    return 1;
}

DB:OnPlayerUseCarStorage(playerid)
{
    new vehicleid = GetVehicleLinkedID(GetDBIntField(0, "id"));

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        DBFormat("SELECT * FROM vehicles WHERE id = %i AND ownerid = %i", GetDBIntField(0, "id"), PlayerData[playerid][pID]);
        DBExecute("OnPlayerSpawnVehicle", "ii", playerid, false);
        return 1;
    }

    if (IsVehicleOccupied(vehicleid) && GetVehicleDriver(vehicleid) != playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is occupied.");
    }

    if (IsVehicleBeingPicked(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is being broken into!");
    }

    if (IsVehicleTowedToTrailer(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is towed!");
    }

    new Float:health;
    GetVehicleHealth(vehicleid, health);
    if (health < 600.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is too damaged to be despawned.");
    }
    DespawnVehicle(vehicleid);
    SendClientMessageEx(playerid, COLOR_AQUA, "Your {FF6347}%s{33CCFF} which is located in %s has been despawned.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
    return 1;
}

DB:OnPlayerAttemptBuyVehicleEx(playerid, offeredby, vehicleid, price)
{
    new count = GetDBIntFieldFromIndex(0, 0);

    if (count >= GetPlayerAssetLimit(playerid, LIMIT_VEHICLES))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i vehicles. You can't own anymore unless you upgrade your asset perk.", count, GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
    }
    else
    {
        GetPlayerName(playerid, VehicleInfo[vehicleid][vOwner], MAX_PLAYER_NAME);
        VehicleInfo[vehicleid][vOwnerID] = PlayerData[playerid][pID];

        DBQuery("UPDATE vehicles SET ownerid = %i, owner = '%e' WHERE id = %i", VehicleInfo[vehicleid][vOwnerID], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vID]);

        if (VehicleInfo[vehicleid][vForSale])
        {
            VehicleInfo[vehicleid][vForSale] = false;
            VehicleInfo[vehicleid][vForSalePrice] = 0;
            DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][vForSaleLabel]);
            VehicleInfo[vehicleid][vForSaleLabel] = Text3D:INVALID_3DTEXT_ID;

            DBQuery("UPDATE vehicles SET forsale = 0, forsaleprice = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        }

        GivePlayerCash(offeredby, price);
        GivePlayerCash(playerid, -price);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's vehicle offer and paid %s for their %s.", GetRPName(offeredby), FormatCash(price), GetVehicleName(vehicleid));
        SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your vehicle offer and paid %s for your %s.", GetRPName(playerid), FormatCash(price), GetVehicleName(vehicleid));
        DBLog("log_property", "%s (uid: %i) (IP: %s) sold their %s (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));
    }
}

DB:OnPlayerSpawnVehicle(playerid, parked)
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The slot specified contains no valid vehicle which you can spawn.");
    }
    else
    {

        if (GetVehicleLinkedID(GetDBIntField(0, "id")) != INVALID_VEHICLE_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle is spawned already. /findcar to track it.");
        }
        if (GetDBIntField(0, "carImpounded"))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle is impounded. You must pay the tickets in DMV.");
        }

        if (GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES && PlayerData[playerid][pDonator] < 3)//vipveh
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
        }
        new modelid = GetDBIntField(0, "modelid");
        new Float:x = GetDBFloatField(0, "pos_x");
        new Float:y = GetDBFloatField(0, "pos_y");
        new Float:z = GetDBFloatField(0, "pos_z");
        new Float:a = GetDBFloatField(0, "pos_a");
        new color1 = GetDBIntField(0, "color1");
        new color2 = GetDBIntField(0, "color2");
        new vehicleid;


        vehicleid = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);

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
            VehicleInfo[vehicleid][vHealth] = GetDBFloatField(0, "health");
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
            SetVehicleFuel(vehicleid, GetDBIntField(0, "fuel"));
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


            if (!parked)
            {
                SendClientMessageEx(playerid, COLOR_AQUA, "You have spawned your {00AA00}%s{33CCFF} which is located in %s. /findcar to track it.", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
            }
        }
    }

    return 1;
}


stock GetPlayerFreeVehicleId(playerid)
{
    for (new i; i < MAX_VEHICLES; ++i)
    {
        if (VehicleInfo[i][vModel] == 0) return i;
    }
    return -1;
}

publish VehicleUnfreeze(playerid, vehicleid, Float:x, Float:y, Float:z, interior, world)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInRangeOfPoint(playerid, 100.0, x, y, z) && GetPlayerInterior(playerid) == interior && GetPlayerVirtualWorld(playerid) == world)
    {
        SetVehiclePos(vehicleid, x, y, z);
    }
    HideFreezeTextdraw(playerid);
    TogglePlayerControllableEx(playerid, 1);
}

CMD:spawncar(playerid, params[])
{
    return callcmd::carstorage(playerid, params);
}
CMD:carstorage(playerid, params[])
{
    DBFormat("SELECT * FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
    DBExecute("CarStorage", "i", playerid);
    return 1;
}

CMD:vs(playerid, params[])
{
    return callcmd::carstorage(playerid, params);
}
CMD:vst(playerid, params[])
{
    return callcmd::carstorage(playerid, params);
}
CMD:vstorage(playerid, params[])
{
    return callcmd::carstorage(playerid, params);
}

CMD:park(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
    }
    if (!IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't park this vehicle as it doesn't belong to you.");
    }

    if (IsPlayerInRangeOfPoint(playerid, 20.0, 1233.1134,-1304.1257,13.5124))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't park your vehicle here.");
    }

    new Float:health;
    GetVehicleHealth(vehicleid, health);
    if (health < 600.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is too damaged to /park.");
    }

    ShowActionBubble(playerid, "* %s parks their %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    SendClientMessageEx(playerid, COLOR_AQUA, "You have parked your {00AA00}%s{33CCFF} which will spawn in this spot from now on.", GetVehicleName(vehicleid));

    // Save the vehicle's information.
    GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
    GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);

    VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
    VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);

    // Update the database record with the new information, then despawn the vehicle.
    DBQuery("UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);

    DespawnVehicle(vehicleid);

    // Finally, we reload the vehicle from the database.
    DBFormat("SELECT * FROM vehicles WHERE id = %i", id);
    DBExecute("OnPlayerSpawnVehicle", "ii", playerid, true);

    return 1;
}

CMD:givekeys(playerid, params[])
{
    new targetid, vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givekeys [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't give keys to yourself.");
    }
    if (GetPlayerPropertyKey(targetid, PropertyType_Vehicle, vehicleid) != KeyRole_Unauthorized)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player already has keys to your vehicle.");
    }

    if (GivePlayerPropertyAccess(targetid, PlayerData[playerid][pID], PropertyType_Vehicle, vehicleid, KeyRole_Editor, gettime() + 24 * 3600))
    {
        ShowActionBubble(playerid, "* %s gives %s the keys to their %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleName(vehicleid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you the keys to their {00AA00}%s{33CCFF}.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %s the keys to your {00AA00}%s{33CCFF}.", GetRPName(targetid), GetVehicleName(vehicleid));
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Cannot give %s the keys to your {00AA00}%s{33CCFF}.", GetRPName(targetid), GetVehicleName(vehicleid));
    }
    return 1;
}

CMD:takekeys(playerid, params[])
{
    new targetid, vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /takekeys [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't take keys from yourself.");
    }
    if (GetPlayerPropertyKey(targetid, PropertyType_Vehicle, vehicleid) == KeyRole_Unauthorized)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player doesn't have the keys to your vehicle.");
    }

    if (RemovePlayerPropertyAccess(targetid, PropertyType_Vehicle, vehicleid))
    {
        ShowActionBubble(playerid, "* %s takes back the keys to their %s from %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleName(vehicleid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken back the keys to their {00AA00}%s{33CCFF}.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have taken back the keys to your {00AA00}%s{33CCFF} from %s.", GetRPName(targetid), GetVehicleName(vehicleid));
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Cannot take the keys to your {00AA00}%s{33CCFF} from %s.", GetRPName(targetid), GetVehicleName(vehicleid));
    }

    return 1;
}

CMD:findcar(playerid, params[])
{
    new string[MAX_SPAWNED_VEHICLES * 64], count;

    string = "#\tModel\tLocation";

    foreach(new i: Vehicle)
    {
        if (VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i))
        {
            format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
            count++;
        }
    }

    if (!count)
    {
        SendClientMessage(playerid, COLOR_GREY, "You have no vehicles spawned at the moment.");
    }
    else
    {
        Dialog_Show(playerid, DIALOG_FINDCAR, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to track.", string, "Select", "Cancel");
    }

    return 1;
}

CMD:upgradevehicle(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), option[8], param[32];

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }
    if (!IsAtDealership(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're not in range of any dealership");
    }
    if (sscanf(params, "s[8]S()[32]", option, param))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [trunk | neon | alarm]");
    }

    if (!strcmp(option, "trunk", true))
    {
        if (isnull(param) || strcmp(param, "confirm", true) != 0)
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [trunk] [confirm]");
            SendClientMessageEx(playerid, COLOR_SYNTAX, "Your vehicle's trunk level is at %i/3. Upgrading your trunk will cost you $10,000.", VehicleInfo[vehicleid][vTrunk]);
            return 1;
        }
        RCHECK(VehicleInfo[vehicleid][vTrunk] < 3, "This vehicle's trunk is already at its maximum level.");
        RCHECK(PlayerData[playerid][pCash] >= 1000, "You don't have enough money to upgrade your trunk.");

        GivePlayerCash(playerid, -1000);
        GameTextForPlayer(playerid, "~r~-$1,000", 5000, 1);

        VehicleInfo[vehicleid][vTrunk]++;
        DBQuery("UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
        DBLog("log_property", "%s (uid: %i) upgraded the trunk of their %s (id: %i) to level %i/3.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], VehicleInfo[vehicleid][vTrunk]);
        SendClientMessageEx(playerid, COLOR_GREEN, "You have paid $1,000 for trunk level %i/3. '/vstash balance' to see your new capacities.", VehicleInfo[vehicleid][vTrunk]);
    }
    else if (!strcmp(option, "neon", true))
    {
        if (isnull(param))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [neon] [color] (costs $3,000)");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of colors: Red, Blue, Green, Yellow, Pink, White");
            return 1;
        }
        if (PlayerData[playerid][pCash] < 3000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least $3,000 to upgrade your neon.");
        }
        if (!VehicleHasWindows(vehicleid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't support neon.");
        }

        if (!strcmp(param, "red", true))
        {
            SetVehicleNeon(vehicleid, 18647);
            GivePlayerCash(playerid, -3000);
            GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 for red neon. You can use /neon to toggle your neon.");
            DBLog("log_property", "%s (uid: %i) purchased red neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
        }
        else if (!strcmp(param, "blue", true))
        {
            SetVehicleNeon(vehicleid, 18648);
            GivePlayerCash(playerid, -3000);
            GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 for blue neon. You can use /neon to toggle your neon.");
            DBLog("log_property", "%s (uid: %i) purchased blue neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
        }
        else if (!strcmp(param, "green", true))
        {
            SetVehicleNeon(vehicleid, 18649);
            GivePlayerCash(playerid, -3000);
            GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 for green neon. You can use /neon to toggle your neon.");
            DBLog("log_property", "%s (uid: %i) purchased green neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
        }
        else if (!strcmp(param, "yellow", true))
        {
            SetVehicleNeon(vehicleid, 18650);
            GivePlayerCash(playerid, -3000);
            GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 for yellow neon. You can use /neon to toggle your neon.");
            DBLog("log_property", "%s (uid: %i) purchased yellow neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
        }
        else if (!strcmp(param, "pink", true))
        {
            SetVehicleNeon(vehicleid, 18651);
            GivePlayerCash(playerid, -3000);
            GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 for pink neon. You can use /neon to toggle your neon.");
            DBLog("log_property", "%s (uid: %i) purchased pink neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
        }
        else if (!strcmp(param, "white", true))
        {
            SetVehicleNeon(vehicleid, 18652);
            GivePlayerCash(playerid, -3000);
            GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 for white neon. You can use /neon to toggle your neon.");
            DBLog("log_property", "%s (uid: %i) purchased white neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
        }
    }
    else if (!strcmp(option, "alarm", true))
    {
        new level;

        if (sscanf(param, "i", level))
        {
            SendClientMessage(playerid, COLOR_WHITE, "* Level 1: Alarm sound effects and notification to owner. {FFD700}($1,500)");
            SendClientMessage(playerid, COLOR_WHITE, "* Level 2: Alarm sound effects and notification to owner and online LEO. {FFD700}($3,000)");
            SendClientMessage(playerid, COLOR_WHITE, "* Level 3: Alarm alarm effects and notification to owner and blip for online LEO. {FFD700}($6,000)");
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [alarm] [level]");
            return 1;
        }
        if (!(1 <= level <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid level.");
        }

        switch (level)
        {
            case 1:
            {
                RCHECK(VehicleInfo[vehicleid][vAlarm] != 1, "Your vehicle's alarm is already at this level.");
                RCHECK(PlayerData[playerid][pCash] >= 1500, "You can't afford to purchase this alarm level.");

                VehicleInfo[vehicleid][vAlarm] = 1;
                DBQuery("UPDATE vehicles SET alarm = 1 WHERE id = %i", VehicleInfo[vehicleid][vID]);

                GivePlayerCash(playerid, -1500);
                GameTextForPlayer(playerid, "~r~-$1,500", 5000, 1);

                SendClientMessage(playerid, COLOR_GREEN, "You have paid $1,500 to install a level 1 alarm on your vehicle.");
                DBLog("log_property", "%s (uid: %i) purchased a level 1 alarm for their %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
            }
            case 2:
            {
                RCHECK(VehicleInfo[vehicleid][vAlarm] != 2, "Your vehicle's alarm is already at this level.");
                RCHECK(PlayerData[playerid][pCash] >= 3000, "You can't afford to purchase this alarm level.");

                VehicleInfo[vehicleid][vAlarm] = 2;
                DBQuery("UPDATE vehicles SET alarm = 2 WHERE id = %i", VehicleInfo[vehicleid][vID]);


                GivePlayerCash(playerid, -3000);
                GameTextForPlayer(playerid, "~r~-$3,000", 5000, 1);

                SendClientMessage(playerid, COLOR_GREEN, "You have paid $3,000 to install a level 2 alarm on your vehicle.");
                DBLog("log_property", "%s (uid: %i) purchased a level 1 alarm for their %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
            }
            case 3:
            {
                RCHECK(VehicleInfo[vehicleid][vAlarm] != 3, "Your vehicle's alarm is already at this level.");
                RCHECK(PlayerData[playerid][pCash] >= 6000, "You can't afford to purchase this alarm level.");

                VehicleInfo[vehicleid][vAlarm] = 3;
                DBQuery("UPDATE vehicles SET alarm = 3 WHERE id = %i", VehicleInfo[vehicleid][vID]);

                GivePlayerCash(playerid, -6000);
                GameTextForPlayer(playerid, "~r~-$6,000", 5000, 1);

                SendClientMessage(playerid, COLOR_GREEN, "You have paid $6,000 to install a level 3 alarm on your vehicle.");
                DBLog("log_property", "%s (uid: %i) purchased a level 3 alarm for their %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
            }
        }
    }
    return 1;
}

CMD:neon(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
    }
    if (!PlayerHasPropertyAccess(playerid, PropertyType_Vehicle, vehicleid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to you.");
    }
    if (!VehicleInfo[vehicleid][vNeon])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no neon installed.");
    }

    if (!VehicleInfo[vehicleid][vNeonEnabled])
    {
        VehicleInfo[vehicleid][vNeonEnabled] = 1;
        GameTextForPlayer(playerid, "~g~Neon activated", 3000, 3);

        ShowActionBubble(playerid, "* %s presses a button to activate their neon tubes.", GetRPName(playerid));
        //SendClientMessage(playerid, COLOR_AQUA, "* Neon enabled. The tubes appear under your vehicle.");
    }
    else
    {
        VehicleInfo[vehicleid][vNeonEnabled] = 0;
        GameTextForPlayer(playerid, "~r~Neon deactivated", 3000, 3);

        ShowActionBubble(playerid, "* %s presses a button to deactivate their neon tubes.", GetRPName(playerid));
        //SendClientMessage(playerid, COLOR_AQUA, "* Neon disabled.");
    }

    DBQuery("UPDATE vehicles SET neonenabled = %i WHERE id = %i", VehicleInfo[vehicleid][vNeonEnabled], VehicleInfo[vehicleid][vID]);


    ReloadVehicleNeon(vehicleid);
    return 1;
}

CMD:vstash(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);

    if (vehicleid != INVALID_VEHICLE_ID && IsVehicleOwner(playerid, vehicleid))
    {
        new option[14], param[32];

        if (!VehicleInfo[vehicleid][vTrunk])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no trunk installed. /upgradevehicle to purchase one.");
        }
        if (sscanf(params, "s[14]S()[32]", option, param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [balance | deposit | withdraw]");
        }
        if (!strcmp(option, "balance", true))
        {
            new count;

            for (new i = 0; i < 5; i ++)
            {
                if (VehicleInfo[vehicleid][vWeapons][i])
                {
                    count++;
                }
            }

            SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Stash Balance ______");
            SendClientMessageEx(playerid, COLOR_GREY2, "Cash: $%i/$%i", VehicleInfo[vehicleid][vCash], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH));
            SendClientMessageEx(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", VehicleInfo[vehicleid][vMaterials], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS), count, GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS));
            SendClientMessageEx(playerid, COLOR_GREY2, "Weed: %i/%i grams | Cocaine: %i/%i grams", VehicleInfo[vehicleid][vWeed], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED), VehicleInfo[vehicleid][vCocaine], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
            SendClientMessageEx(playerid, COLOR_GREY2, "Heroin: %i/%i grams | Painkillers: %i/%i pills", VehicleInfo[vehicleid][vHeroin], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN), VehicleInfo[vehicleid][vPainkillers], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));

            if (count > 0)
            {
                SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Stash Weapons ______");

                for (new i = 0; i < 5; i ++)
                {
                    if (VehicleInfo[vehicleid][vWeapons][i])
                    {
                        SendClientMessageEx(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
                    }
                }
            }
        }
        else if (!strcmp(option, "deposit", true))
        {
            new value;

            if (IsPlayerInAnyVehicle(playerid))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
            }
            if (sscanf(param, "s[14]S()[32]", option, param))
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [option]");
                SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Cash, Materials, Weed, Cocaine, Heroin, Painkillers, Weapon");
                return 1;
            }
            if (!strcmp(option, "cash", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [cash] [amount]");
                }
                if (value < 1 || value > PlayerData[playerid][pCash])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (VehicleInfo[vehicleid][vCash] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %s at its level.", FormatCash(GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH)));
                }

                GivePlayerCash(playerid, -value);
                VehicleInfo[vehicleid][vCash] += value;

                DBQuery("UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %s in your vehicle stash.", FormatCash(value));
            }
            else if (!strcmp(option, "materials", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [materials] [amount]");
                }
                if (value < 1 || value > PlayerData[playerid][pMaterials])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (VehicleInfo[vehicleid][vMaterials] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i materials at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS));
                }

                PlayerData[playerid][pMaterials] -= value;
                VehicleInfo[vehicleid][vMaterials] += value;

                DBQuery("UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %i materials in your vehicle stash.", value);
            }
            else if (!strcmp(option, "weed", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [weed] [amount]");
                }
                if (value < 1 || value > PlayerData[playerid][pWeed])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (VehicleInfo[vehicleid][vWeed] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i grams of weed at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED));
                }

                PlayerData[playerid][pWeed] -= value;
                VehicleInfo[vehicleid][vWeed] += value;

                DBQuery("UPDATE vehicles SET weed = %i WHERE id = %i", VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of weed in your vehicle stash.", value);
            }
            else if (!strcmp(option, "cocaine", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [cocaine] [amount]");
                }
                if (value < 1 || value > PlayerData[playerid][pCocaine])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (VehicleInfo[vehicleid][vCocaine] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i grams of cocaine at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
                }

                PlayerData[playerid][pCocaine] -= value;
                VehicleInfo[vehicleid][vCocaine] += value;

                DBQuery("UPDATE vehicles SET cocaine = %i WHERE id = %i", VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of cocaine in your vehicle stash.", value);
            }
            else if (!strcmp(option, "heroin", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [heroin] [amount]");
                }
                if (value < 1 || value > PlayerData[playerid][pHeroin])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (VehicleInfo[vehicleid][vHeroin] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i grams of heroin at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN));
                }

                PlayerData[playerid][pHeroin] -= value;
                VehicleInfo[vehicleid][vHeroin] += value;

                DBQuery("UPDATE vehicles SET heroin = %i WHERE id = %i", VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of Heroin in your vehicle stash.", value);
            }
            else if (!strcmp(option, "painkillers", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [painkillers] [amount]");
                }
                if (value < 1 || value > PlayerData[playerid][pPainkillers])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (VehicleInfo[vehicleid][vPainkillers] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i painkillers at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));
                }

                PlayerData[playerid][pPainkillers] -= value;
                VehicleInfo[vehicleid][vPainkillers] += value;

                DBQuery("UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %i painkillers in your vehicle stash.", value);
            }
            else if (!strcmp(option, "weapon", true))
            {
                new weaponid;

                if (sscanf(param, "i", weaponid))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
                }
                if (!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have that weapon. /guninv for a list of your weapons.");
                }
                if (IsLawEnforcement(playerid) || GetPlayerFaction(playerid) == FACTION_HITMAN)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Faction weapons cannot be stored.");
                }
                if (GetPlayerHealthEx(playerid) < 60)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't store weapons as your health is below 60.");
                }

                for (new i = 0; i < GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS); i ++)
                {
                    if (!VehicleInfo[vehicleid][vWeapons][i])
                    {
                        VehicleInfo[vehicleid][vWeapons][i] = weaponid;

                        DBQuery("UPDATE vehicles SET weapon_%i = %i WHERE id = %i", i + 1, VehicleInfo[vehicleid][vWeapons][i], VehicleInfo[vehicleid][vID]);


                        RemovePlayerWeapon(playerid, weaponid);
                        SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored a %s in slot %i of your vehicle stash.", GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]), i + 1);
                        return 1;
                    }
                }

                SendClientMessage(playerid, COLOR_GREY, "This vehicle has no more slots available for weapons.");
            }
        }
        else if (!strcmp(option, "withdraw", true))
        {
            new value;

            if (IsPlayerInAnyVehicle(playerid))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
            }
            if (sscanf(param, "s[14]S()[32]", option, param))
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [option]");
                SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Cash, Weed, Cocaine, Heroin, Painkillers, Weapon");
                return 1;
            }
            if (!strcmp(option, "cash", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [cash] [amount]");
                }
                if (value < 1 || value > VehicleInfo[vehicleid][vCash])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }

                GivePlayerCash(playerid, value);
                VehicleInfo[vehicleid][vCash] -= value;

                DBQuery("UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %s from your vehicle stash.", FormatCash(value));
            }
            else if (!strcmp(option, "materials", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [materials] [amount]");
                }
                if (value < 1 || value > VehicleInfo[vehicleid][vMaterials])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (PlayerData[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
                }

                PlayerData[playerid][pMaterials] += value;
                VehicleInfo[vehicleid][vMaterials] -= value;

                DBQuery("UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %i materials from your vehicle stash.", value);
            }
            else if (!strcmp(option, "weed", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [weed] [amount]");
                }
                if (value < 1 || value > VehicleInfo[vehicleid][vWeed])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (PlayerData[playerid][pWeed] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
                }

                PlayerData[playerid][pWeed] += value;
                VehicleInfo[vehicleid][vWeed] -= value;

                DBQuery("UPDATE vehicles SET weed = %i WHERE id = %i", VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of weed from your vehicle stash.", value);
            }
            else if (!strcmp(option, "cocaine", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [cocaine] [amount]");
                }
                if (value < 1 || value > VehicleInfo[vehicleid][vCocaine])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (PlayerData[playerid][pCocaine] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
                }

                PlayerData[playerid][pCocaine] += value;
                VehicleInfo[vehicleid][vCocaine] -= value;

                DBQuery("UPDATE vehicles SET cocaine = %i WHERE id = %i", VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of cocaine from your vehicle stash.", value);
            }
            else if (!strcmp(option, "heroin", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [heroin] [amount]");
                }
                if (value < 1 || value > VehicleInfo[vehicleid][vHeroin])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (PlayerData[playerid][pHeroin] + value > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
                }

                PlayerData[playerid][pHeroin] += value;
                VehicleInfo[vehicleid][vHeroin] -= value;

                DBQuery("UPDATE vehicles SET heroin = %i WHERE id = %i", VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of Heroin from your vehicle stash.", value);
            }
            else if (!strcmp(option, "painkillers", true))
            {
                if (sscanf(param, "i", value))
                {
                    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [painkillers] [amount]");
                }
                if (value < 1 || value > VehicleInfo[vehicleid][vPainkillers])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                }
                if (PlayerData[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
                }

                PlayerData[playerid][pPainkillers] += value;
                VehicleInfo[vehicleid][vPainkillers] -= value;

                DBQuery("UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);


                DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);


                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %i painkillers from your vehicle stash.", value);
            }
            else if (!strcmp(option, "weapon", true))
            {
                new slots = GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS);

                if (sscanf(param, "i", value))
                {
                    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [weapon] [slot (1-%i)]", slots);
                }
                if (!(1 <= value <= slots))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Invalid slot, or the slot specified is locked.");
                }
                if (!VehicleInfo[vehicleid][vWeapons][value-1])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "The slot specified contains no weapon which you can take.");
                }
                if (PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
                }

                GivePlayerWeaponEx(playerid, VehicleInfo[vehicleid][vWeapons][value-1]);
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken a %s from slot %i of your vehicle stash.", GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][value-1]), value);

                VehicleInfo[vehicleid][vWeapons][value-1] = 0;

                DBQuery("UPDATE vehicles SET weapon_%i = 0 WHERE id = %i", value, VehicleInfo[vehicleid][vID]);

            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle of yours.");
    }

    return 1;
}

CMD:unmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
    }
    if (!PlayerHasPropertyAccess(playerid, PropertyType_Vehicle, vehicleid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to you.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unmod [color | paintjob | mods | neon]");
    }

    if (!strcmp(params, "color", true))
    {
        VehicleInfo[vehicleid][vColor1] = 0;
        VehicleInfo[vehicleid][vColor2] = 0;

        DBQuery("UPDATE vehicles SET color1 = 0, color2 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        ChangeVehicleColor(vehicleid, 0, 0);
        SendClientMessage(playerid, COLOR_WHITE, "* Vehicle color has been set back to default.");
    }
    else if (!strcmp(params, "paintjob", true))
    {
        VehicleInfo[vehicleid][vPaintjob] = -1;

        DBQuery("UPDATE vehicles SET paintjob = -1 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        ChangeVehiclePaintjob(vehicleid, 3);
        SendClientMessage(playerid, COLOR_WHITE, "* Vehicle paintjob has been set back to default.");
    }
    else if (!strcmp(params, "mods", true))
    {
        for (new i = 0; i < 14; i ++)
        {
            if (VehicleInfo[vehicleid][vMods][i] >= 1000)
            {
                RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
            }
        }

        DBQuery("UPDATE vehicles SET mod_1 = 0, mod_2 = 0, mod_3 = 0, mod_4 = 0, mod_5 = 0, mod_6 = 0, mod_7 = 0, mod_8 = 0, mod_9 = 0, mod_10 = 0, mod_11 = 0, mod_12 = 0, mod_13 = 0, mod_14 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        SendClientMessage(playerid, COLOR_WHITE, "* All vehicle modifications have been removed.");
    }
    else if (!strcmp(params, "neon", true))
    {
        if (!VehicleInfo[vehicleid][vNeon])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no neon which you can remove.");
        }

        if (VehicleInfo[vehicleid][vNeonEnabled])
        {
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
            DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
        }

        VehicleInfo[vehicleid][vNeon] = 0;
        VehicleInfo[vehicleid][vNeonEnabled] = 0;
        VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
        VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;

        DBQuery("UPDATE vehicles SET neon = 0, neonenabled = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        SendClientMessage(playerid, COLOR_WHITE, "* Neon has been removed from vehicle.");
    }

    return 1;
}

CMD:gunmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
    }
    if (VehicleInfo[vehicleid][vGang] >= 0 && VehicleInfo[vehicleid][vGang] != PlayerData[playerid][pGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to your gang.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gunmod [color | paintjob | mods]");
    }

    if (!strcmp(params, "color", true))
    {
        VehicleInfo[vehicleid][vColor1] = 0;
        VehicleInfo[vehicleid][vColor2] = 0;

        DBQuery("UPDATE vehicles SET color1 = 0, color2 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        ChangeVehicleColor(vehicleid, 0, 0);
        SendClientMessage(playerid, COLOR_WHITE, "* Vehicle color has been set back to default.");
    }
    else if (!strcmp(params, "paintjob", true))
    {
        VehicleInfo[vehicleid][vPaintjob] = -1;

        DBQuery("UPDATE vehicles SET paintjob = -1 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        ChangeVehiclePaintjob(vehicleid, 3);
        SendClientMessage(playerid, COLOR_WHITE, "* Vehicle paintjob has been set back to default.");
    }
    else if (!strcmp(params, "mods", true))
    {
        for (new i = 0; i < 14; i ++)
        {
            if (VehicleInfo[vehicleid][vMods][i] >= 1000)
            {
                RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
            }
        }

        DBQuery("UPDATE vehicles SET mod_1 = 0, mod_2 = 0, mod_3 = 0, mod_4 = 0, mod_5 = 0, mod_6 = 0, mod_7 = 0, mod_8 = 0, mod_9 = 0, mod_10 = 0, mod_11 = 0, mod_12 = 0, mod_13 = 0, mod_14 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);


        SendClientMessage(playerid, COLOR_WHITE, "* All vehicle modifications have been removed.");
    }

    return 1;
}

CMD:colorcar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), color1, color2;


    if (sscanf(params, "ii", color1, color2))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /colorcar [color1] [color2]");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not sitting inside any vehicle.");
    }
    if (VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid) && !PlayerHasJob(playerid, JOB_MECHANIC))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't belong to you, therefore you can't respray it.");
    }
    if (VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pMechanicSkill] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 5 mechanic to paint cars you dont own.");
    }
    if (!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The color specified must range between 0 and 255.");
    }

    if (!PlayerHasJob(playerid, JOB_MECHANIC))
    {
        if (!IsVehicleOwner(playerid, vehicleid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not vehicle owner.");
        }
        if (PlayerData[playerid][pSpraycans] <= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
        }
        if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
        {
            VehicleInfo[vehicleid][vColor1] = color1;
            VehicleInfo[vehicleid][vColor2] = color2;

            DBQuery("UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);

        }
        PlayerData[playerid][pSpraycans]--;
        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);

        ShowActionBubble(playerid, "* %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
        ChangeVehicleColor(vehicleid, color1, color2);
        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
        return 1;
    }
    if (PlayerHasJob(playerid, JOB_MECHANIC))
    {
        if (PlayerData[playerid][pMechanicSkill] < 5)
        {
            if (PlayerData[playerid][pSpraycans] <= 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
            }
            if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
            {
                VehicleInfo[vehicleid][vColor1] = color1;
                VehicleInfo[vehicleid][vColor2] = color2;

                DBQuery("UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);

            }
            PlayerData[playerid][pSpraycans]--;
            DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);

            ShowActionBubble(playerid, "* %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
            ChangeVehicleColor(vehicleid, color1, color2);
            PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            return 1;
        }
        if (PlayerData[playerid][pComponents] <= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough components for this.");
        }
        if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
        {
            VehicleInfo[vehicleid][vColor1] = color1;
            VehicleInfo[vehicleid][vColor2] = color2;

            DBQuery("UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);

        }
        PlayerData[playerid][pComponents]--;
        DBQuery("UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);

        ShowActionBubble(playerid, "* %s sprays the vehicle to a different color.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i components left.", PlayerData[playerid][pComponents]);
        ChangeVehicleColor(vehicleid, color1, color2);
        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
        return 1;
    }

    return 1;
}

CMD:paintcar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), paintjobid;

    if (sscanf(params, "i", paintjobid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /paintcar [paintjobid (-1 = none)]");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not sitting inside any vehicle.");
    }
    if (VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid) && !PlayerHasJob(playerid, JOB_MECHANIC))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't belong to you, therefore you can't respray it.");
    }
    if (VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pMechanicSkill] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 5 mechanic to paint cars you dont own.");
    }
    if (!(-1 <= paintjobid <= 5))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The paintjob specified must range between -1 and 5.");
    }
    if (paintjobid == -1) paintjobid = 3;

    if (!PlayerHasJob(playerid, JOB_MECHANIC))
    {
        if (PlayerData[playerid][pSpraycans] <= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
        }
        if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
        {
            VehicleInfo[vehicleid][vPaintjob] = paintjobid;

            DBQuery("UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);

        }
        PlayerData[playerid][pSpraycans]--;
        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);

        ShowActionBubble(playerid, "* %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
        ChangeVehiclePaintjob(vehicleid, paintjobid);
        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
        return 1;
    }
    if (PlayerHasJob(playerid, JOB_MECHANIC))
    {
        if (PlayerData[playerid][pMechanicSkill] < 5)
        {
            if (PlayerData[playerid][pSpraycans] <= 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
            }
            if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
            {
                VehicleInfo[vehicleid][vPaintjob] = paintjobid;

                DBQuery("UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);

            }
            PlayerData[playerid][pSpraycans]--;
            DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);

            ShowActionBubble(playerid, "* %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
            ChangeVehiclePaintjob(vehicleid, paintjobid);
            PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            return 1;
        }

        if (PlayerData[playerid][pComponents] <= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough components for this.");
        }

        if (VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
        {
            VehicleInfo[vehicleid][vPaintjob] = paintjobid;

            DBQuery("UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);

        }
        PlayerData[playerid][pComponents]--;
        DBQuery("UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);

        ShowActionBubble(playerid, "* %s sprays the vehicle to a different color.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i components left.", PlayerData[playerid][pComponents]);
        ChangeVehiclePaintjob(vehicleid, paintjobid);
        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
        return 1;
    }
    return 1;
}

CMD:sellmycar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }

    if (!IsPlayerInRangeOfPoint(playerid, 18.0, 1442.0000, -2447.5000, 13.6000) && // Plane
        !IsPlayerInRangeOfPoint(playerid, 8.0,   213.0000, -1936.9008,  1.0000) && // Boat
        !IsPlayerInRangeOfPoint(playerid, 8.0,   557.4300, -1282.8500, 17.2500))   // Car
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the Grotti car dealership.");
    }

    new price = percent(GetVehicleValue(vehicleid), 10);

    if (strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmycar [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "This command permanently deletes your vehicle. You will receive %s back.", FormatCash(price));
        return 1;
    }

    GivePlayerCash(playerid, price);

    SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your %s to the dealership and received %s back.", GetVehicleName(vehicleid), FormatCash(price));
    DBLog("log_property", "%s (uid: %i) sold their %s (id: %i) to the dealership for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price);

    DBQuery("DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);

    DespawnVehicle(vehicleid, false);

    return 1;
}

CMD:carhelp(playerid, params[])
{
    return callcmd::vehiclehelp(playerid, params);
}

CMD:eject(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /eject [playerid]");
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected, or is not in your vehicle.");
    }

    RemovePlayerFromVehicle(targetid);
    ShowActionBubble(playerid, "* %s ejects %s from the vehicle.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:paytickets(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), amount;
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1186.8889,-1795.3860,13.5703))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of ticket pay.");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle of yours.");
    }
    if (!PlayerHasPropertyAccess(playerid, PropertyType_Vehicle, vehicleid, KeyAccess_Doors))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to you.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /paytickets [amount] (There is $%i in unpaid tickets.)", VehicleInfo[vehicleid][vTickets]);
    }
    if (amount < 1 || amount > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }
    if (amount > VehicleInfo[vehicleid][vTickets])
    {
        return SendClientMessage(playerid, COLOR_GREY, "There isn't that much in unpaid tickets to pay.");
    }

    VehicleInfo[vehicleid][vTickets] -= amount;
    GivePlayerCash(playerid, -amount);

    DBQuery("UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "You have paid %s in unpaid tickets. This vehicle now has %s left in unpaid tickets.", FormatCash(amount), FormatCash(VehicleInfo[vehicleid][vTickets]));
    return 1;
}

CMD:carinfo(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }

    new neon[12], Float:health;

    GetVehicleHealth(vehicleid, health);

    switch (VehicleInfo[vehicleid][vNeon])
    {
        case 18647: neon = "Red";
        case 18648: neon = "Blue";
        case 18649: neon = "Green";
        case 18650: neon = "Yellow";
        case 18651: neon = "Pink";
        case 18652: neon = "White";
        default: neon = "None";
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s Stats _______", GetVehicleName(vehicleid));
    SendClientMessageEx(playerid, COLOR_GREY2, "Owner: %s - Value: $%i - Tickets: $%i - License Plate: ", VehicleInfo[vehicleid][vOwner], GetVehicleValue(vehicleid), VehicleInfo[vehicleid][vTickets]);
    SendClientMessageEx(playerid, COLOR_GREY2, "Neon: %s - Trunk Level: %i/3 - Alarm Level: %i/3 - Health: %.1f - Fuel: %i/100", neon, VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vAlarm], health, GetVehicleFuel(vehicleid));
    return 1;
}

CMD:hood(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleHasDoors(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no hood.");
    }
    if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in the passenger seat.");
    }

    if (!IsVehicleParamOn(vehicleid, VEHICLE_BONNET))
    {
        SetVehicleParams(vehicleid, VEHICLE_BONNET, true);
        ShowActionBubble(playerid, "* %s opens the hood of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }
    else
    {
        SetVehicleParams(vehicleid, VEHICLE_BONNET, false);
        ShowActionBubble(playerid, "* %s closes the hood of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }

    return 1;
}

CMD:trunk(playerid, params[])
{
    return callcmd::boot(playerid, params);
}

CMD:boot(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleHasDoors(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no boot.");
    }
    if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in the passenger seat.");
    }

    if (!IsVehicleParamOn(vehicleid, VEHICLE_BOOT))
    {
        SetVehicleParams(vehicleid, VEHICLE_BOOT, true);
        ShowActionBubble(playerid, "* %s opens the boot of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }
    else
    {
        SetVehicleParams(vehicleid, VEHICLE_BOOT, false);
        ShowActionBubble(playerid, "* %s closes the boot of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }

    return 1;
}

CMD:setforsale(playerid, params[])
{
    new askingprice, forsale[264], vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }

    if (VehicleInfo[vehicleid][vForSale]) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is already for sale.");
    if (!PlayerData[playerid][pPhone]) return SendClientMessage(playerid, COLOR_GREY, "You don't have any phone setup.");

    if (sscanf(params, "i", askingprice)) return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setforsale [price]");
    if (askingprice < 1 || askingprice > 50000000) return SendClientMessage(playerid, COLOR_GREY, "Price must be between $1 and $50,000,000.");

    VehicleInfo[vehicleid][vForSale] = true;
    VehicleInfo[vehicleid][vForSalePrice] = askingprice;

    DBQuery("UPDATE vehicles SET forsale = 1, forsaleprice = %i WHERE id = %i",  askingprice, VehicleInfo[vehicleid][vID]);


    format(forsale, sizeof(forsale), "FOR SALE\n%s - %s\nPh: %i.", GetVehicleName(vehicleid), FormatCash(VehicleInfo[vehicleid][vForSalePrice]), PlayerData[playerid][pPhone]);
    VehicleInfo[vehicleid][vForSaleLabel] = CreateDynamic3DTextLabel(forsale, COLOR_GREY2, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, vehicleid, 1, -1, 0, -1, 30.0);

    SendClientMessageEx(playerid, COLOR_WHITE, "You have set your %s for sale with an asking price of $%s.", GetVehicleName(vehicleid), FormatCash(VehicleInfo[vehicleid][vForSalePrice]));
    return 1;
}

CMD:cancelforsale(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || !IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
    }

    if (!VehicleInfo[vehicleid][vForSale]) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is not for sale.");

    VehicleInfo[vehicleid][vForSale] = false;
    VehicleInfo[vehicleid][vForSalePrice] = 0;

    DBQuery("UPDATE vehicles SET forsale = 0, forsaleprice = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);


    DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][vForSaleLabel]);

    SendClientMessageEx(playerid, COLOR_WHITE, "You have cancelled the sale of your %s.", GetVehicleName(vehicleid));
    return true;
}

CMD:windows(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be inside a vehicle to use this command.");
    }
    if (PlayerData[playerid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed");
    }
    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
    }
    if (!VehicleHasWindows(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have any windows.");
    }
    new driver, passenger, backleft, backright;
    GetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, backright);
    SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), !driver, !passenger, !backleft, !backright);
    if (CarWindows[vehicleid] == 0)
    {
        CarWindows[vehicleid] = 1;
        SendProximityMessage(playerid, 20.0, 0xFFA500FF, "*{C2A2DA} %s rolls down the vehicle windows of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));

    }
    else
    {
        CarWindows[vehicleid] = 0;
        SendProximityMessage(playerid, 20.0, 0xFFA500FF, "*{C2A2DA} %s rolls up the vehicle windows of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }
    return 1;
}

CMD:seatbelt(playerid, params[])
{
    if (IsPlayerInAnyVehicle(playerid) == 0)
    {
        SendClientMessage(playerid, COLOR_WHITE, "You are not in a vehicle!");
        return 1;
    }
    if (IsPlayerInAnyVehicle(playerid) == 1 && seatbelt[playerid] == 0)
    {
        seatbelt[playerid] = 1;
        if (IsAMotorBike(GetPlayerVehicleID(playerid)))
        {
            SetPlayerAttachedObject(playerid, 7, 18645, 2, 0.1, 0.02, 0.0, 0.0, 90.0, 90.0, 1.0, 1.0, 1.0);
            ShowActionBubble(playerid, "* %s reaches for their helmet, and puts it on.", GetRPName(playerid));
            SendClientMessage(playerid, COLOR_WHITE, "You have put on your helmet.");
        }
        else
        {
            ShowActionBubble(playerid, "* %s reaches for their seatbelt, and buckles it up.", GetRPName(playerid));
            SendClientMessage(playerid, COLOR_WHITE, "You have put on your seatbelt.");
        }

    }
    else if (IsPlayerInAnyVehicle(playerid) == 1 && seatbelt[playerid] == 1)
    {
        seatbelt[playerid] = 0;
        if (IsAMotorBike(GetPlayerVehicleID(playerid)))
        {
            RemovePlayerAttachedObject(playerid, 7);
            ShowActionBubble(playerid, "* %s reaches for their helmet, and takes it off.", GetRPName(playerid));
            SendClientMessage(playerid, COLOR_WHITE, "You have taken off your helmet.");
        }
        else
        {
            ShowActionBubble(playerid, "* %s reaches for their seatbelt, and unbuckles it.", GetRPName(playerid));
            SendClientMessage(playerid, COLOR_WHITE, "You have taken off your seatbelt.");
        }
    }
    return 1;
}

CMD:checkbelt(playerid, params[])
{
    new giveplayerid;
    if (sscanf(params, "i", giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /checkbelt [playerid]");

    if (GetPlayerState(giveplayerid) == PLAYER_STATE_ONFOOT)
    {
        SendClientMessage(playerid,COLOR_GREY,"That player is not in any vehicle!");
        return 1;
    }
    if (!IsPlayerConnected(giveplayerid) || !IsPlayerNearPlayer(playerid, giveplayerid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }

    new stext[4];
    if (seatbelt[giveplayerid] == 0)
    {
        stext = "off";
    }
    else
    {
        stext = "on";
    }
    if (IsAMotorBike(GetPlayerVehicleID(playerid)))
    {
        ShowActionBubble(playerid, "* %s looks at %s, checking to see if they are wearing a helmet.", GetRPName(playerid),GetRPName(giveplayerid));
        SendClientMessageEx(playerid,COLOR_WHITE, "%s's helmet is currently %s.", GetRPName(giveplayerid) , stext);
    }
    else
    {
        ShowActionBubble(playerid, "* %s peers through the window at %s, checking to see if they are wearing a seatbelt.", GetRPName(playerid),GetRPName(giveplayerid));
        SendClientMessageEx(playerid,COLOR_WHITE, "%s's seat belt is currently %s.", GetRPName(giveplayerid) , stext);
    }
    return 1;
}

CMD:checkmybelt(playerid, params[])
{
    if (seatbelt[playerid] == 1)
    {
        SendClientMessage(playerid, COLOR_WHITE, "You have your seatbelt on.");
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "Your seatbelt is off.");
    }
    return 1;
}
CMD:vcode(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (PlayerData[playerid][pDonator] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need a Legendary donator package to access use this command.");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
    }
    if (isnull(params) || strlen(params) > 64)
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /vcode [text ('none' to reset)]");
    }

    if (IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
    {
        DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
        DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

        if (!strcmp(params, "none", true))
        {
            SendClientMessage(playerid, COLOR_WHITE, "* Car text removed from the vehicle.");
        }
    }

    if (strcmp(params, "none", true) != 0)
    {
        DonatorCallSign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_VIP, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
        SendClientMessage(playerid, COLOR_WHITE, "* Car text attached. '/vcode none' to detach the Car text.");
    }

    return 1;
}

CMD:detach(playerid, params[])
{
    #pragma unused params

    new veh = GetPlayerVehicleID(playerid);

    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in a vehicle to do this.");
    if (!IsTrailerAttachedToVehicle(veh)) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have a trailer attached to your vehicle.");

    DetachTrailerFromVehicle(veh);
    SendClientMessageEx(playerid, COLOR_GREY, "Your trailer has been detached from your vehicle.");

    return 1;
}

CMD:switchspeedo(playerid, params[])
{
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /switchspeedo [kmh/mph]");
    }
    if (!strcmp(params, "kmh", true))
    {
        PlayerData[playerid][pSpeedometer] = 1;
        SendClientMessage(playerid, COLOR_AQUA, "Your speedometer will now display speed as {00AA00}Kilometers per hour{33CCFF}.");

        DBQuery("UPDATE "#TABLE_USERS" SET speedometer = 1 WHERE uid = %i", PlayerData[playerid][pID]);

    }
    else if (!strcmp(params, "mph", true))
    {
        PlayerData[playerid][pSpeedometer] = 2;
        SendClientMessage(playerid, COLOR_AQUA, "Your speedometer will now display speed as {00AA00}Miles per hour{33CCFF}.");

        DBQuery("UPDATE "#TABLE_USERS" SET speedometer = 2 WHERE uid = %i", PlayerData[playerid][pID]);

    }

    return 1;
}

CMD:pvehicles(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:pcars(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:pvehs(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:listpvehs(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:listpvehicles(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listpvehs [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }

    DBFormat("SELECT id, modelid, pos_x, pos_y, pos_z, interior FROM vehicles WHERE ownerid = %i", PlayerData[targetid][pID]);
    DBExecute("OnAdminListVehicles", "ii", playerid, targetid);
    return 1;
}


CMD:removepcar(playerid, params[])
{
    return callcmd::removepveh(playerid, params);
}
CMD:removepvehicle(playerid, params[])
{
    return callcmd::removepveh(playerid, params);
}
CMD:removepveh(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removepveh [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT id, modelid, pos_x, pos_y, pos_z, interior FROM vehicles WHERE ownerid = %i", PlayerData[targetid][pID]);
    DBExecute("OnAdminVehiclesForRemoval", "ii", playerid, targetid);
    return 1;
}

CMD:despawnpvehicle(playerid, params[])
{
    return callcmd::despawnpveh(playerid, params);
}
CMD:despawnpcar(playerid, params[])
{
    return callcmd::despawnpveh(playerid, params);
}
CMD:despawnpveh(playerid, params[])
{
    new vehicleid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", vehicleid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /despawnpveh [vehicleid]");
    }
    if (!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or not owned by any player.");
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "You have despawned %s's %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid));
    DespawnVehicle(vehicleid);
    return 1;
}

CMD:gveh(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    ShowSpawnVehicleMenu(playerid, MODEL_SELECTION_ADMIN_VEHICLES);
    return 1;
}

CMD:veh(playerid, params[])
{
    new model[20], modelid, color1, color2, vehicleid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[20]I(-1)I(-1)", model, color1, color2))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /veh [modelid/name] [color1 (optional)] [color2 (optional)]");
    }
    if ((modelid = GetVehicleModelByName(model)) == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle model.");
    }
    if (!(-1 <= color1 <= 255) || !(-1 <= color2 <= 255))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid color. Valid colors range from -1 to 255.");
    }
    vehicleid = GivePlayerAdminVehicle(playerid, modelid, color1, color2);
    if (!IsValidVehicle(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Cannot spawn vehicle. The vehicle pool is currently full.");
    }
    else
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s spawned a %s.", GetRPName(playerid), GetVehicleName(vehicleid));
        SendClientMessageEx(playerid, COLOR_WHITE, "%s (ID %i) spawned. Use '/savevehicle %i' to save this vehicle to the database.", GetVehicleName(vehicleid), vehicleid, vehicleid);
    }
    return 1;
}

CMD:saveveh(playerid, params[])
{
    return callcmd::savevehicle(playerid, params);
}

CMD:savevehicle(playerid, params[])
{
    new vehicleid, gangid, factionid, delay, vip;

    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "ii(-1)i(-1)i(300)I(0)", vehicleid, gangid, factionid, delay, vip))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /savevehicle [vehicleid] [gangid (-1 = none)] [faction (-1 = none)] [respawn delay (seconds)] [vip level]");
        return 1;
    }
    if (!IsValidVehicle(vehicleid) || !adminVehicle[vehicleid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is either invalid or not an admin spawned vehicle.");
    }
    if (!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }
    if (!(-1 <= factionid < MAX_FACTIONS) || (factionid >= 0 && FactionInfo[factionid][fType] == FACTION_NONE))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
    }
    if (!(0 <= vip <= 3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid vip.");
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "%s saved. This vehicle will now spawn here from now on.", GetVehicleName(vehicleid));

    new Float:x, Float:y, Float:z, Float:a, plate[32];
    new modelid = GetVehicleModel(vehicleid);
    new color1 = vehicleColors[vehicleid][0];
    new color2 = vehicleColors[vehicleid][1];
    new interior = GetPlayerInterior(playerid);
    new world = GetPlayerVirtualWorld(playerid);
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    adminVehicle[vehicleid] = false;
    DestroyVehicleEx(vehicleid);

    format(plate, 32, "%c%c%c %i", Random('A', 'Z'), Random('A', 'Z'), Random('A', 'Z'), Random(100, 999));

    DBFormat("INSERT INTO vehicles "\
        "(modelid, pos_x, pos_y, pos_z, pos_a, plate, color1, color2,"\
        " gangid, factionid, vippackage, respawndelay, interior, world)"\
        " VALUES (%i, '%.4f', '%.4f', '%.4f', '%.4f', '%e', %i, %i, %i, %i, %i, %i, %i, %i)",
        modelid, x, y, z, a, plate, color1, color2, gangid, factionid, vip, delay, interior, world);
    DBExecute("OnAdminVehicleSaved");
    return 1;
}

DB:OnAdminVehicleSaved()
{
    DBFormat("SELECT * FROM vehicles WHERE id = %i;", GetDBInsertID());
    DBExecute("OnLoadVehicles");
}

CMD:editvehicle(playerid, params[])
{
    new vehicleid, option[14], param[32], value, Float:value2;

    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[14]S()[32]", vehicleid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Spawn, Price, Tickets, Locked, Plate, Color, Paintjob, Neon, Trunk, Health");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Gang, Faction, Job, VIP, Respawndelay, Siren, Rank, Type, Division");
        return 1;
    }
    if (!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
    }

    if (!strcmp(option, "spawn", true))
    {
        new id = VehicleInfo[vehicleid][vID];

        //if (VehicleInfo[vehicleid][vFaction] >= 0)
        //{
        //    return SendClientMessage(playerid, COLOR_GREY, "You can't set the spawn of a faction vehicle indoors.");
        //}

        if (IsPlayerInAnyVehicle(playerid))
        {
            GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
            GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);
        }
        else
        {
            GetPlayerPos(playerid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
            GetPlayerFacingAngle(playerid, VehicleInfo[vehicleid][vPosA]);
        }

        if (VehicleInfo[vehicleid][vGang] >= 0 || VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
            VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);
            SaveVehicleModifications(vehicleid);
        }

        DBQuery("UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], id);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have moved the spawn point for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
        DespawnVehicle(vehicleid, false);

        DBFormat("SELECT * FROM vehicles WHERE id = %i", id);
        DBExecute("OnLoadVehicles", "i", -1);


    }
    else if (!strcmp(option, "price", true))
    {
        if (!VehicleInfo[vehicleid][vOwnerID])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [price] [value]");
        }

        VehicleInfo[vehicleid][vPrice] = value;

        DBQuery("UPDATE vehicles SET price = %i WHERE id = %i", VehicleInfo[vehicleid][vPrice], VehicleInfo[vehicleid][vID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the price of %s's %s (ID %i) to $%i.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
        DBLog("log_admin", "%s (uid: %i) has edited vehicle id %d price to $%d", GetPlayerNameEx(playerid), vehicleid, value);

    }

    else if (!strcmp(option, "mileage", true))
    {
        if (sscanf(param, "i", value2))
        {
            return SendSyntaxMessage(playerid, " /editvehicle [vehicleid] [mileage] [value]");
        }

        VehicleInfo[vehicleid][vMileage] = value2;

        DBQuery("UPDATE vehicles SET mileage = %.2f WHERE id = %i", VehicleInfo[vehicleid][vMileage], VehicleInfo[vehicleid][vID]);


        if (value2 == 0)
            SendClientMessageEx(playerid, COLOR_AQUA, "** Ju keni ristartuar kilometrazhin e vetures %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "** Ju keni edituar kilometrazhin e vetures %s (ID %i) n? (%i) KM.", GetVehicleName(vehicleid), vehicleid, value);
    }

    else if (!strcmp(option, "type", true))
    {
        if (VehicleInfo[vehicleid][vOwnerID])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on a not player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [type] [0/1]");
        }

        VehicleInfo[vehicleid][vType] = value;

        DBQuery("UPDATE vehicles SET type = %i WHERE id = %i", VehicleInfo[vehicleid][vType], VehicleInfo[vehicleid][vID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the type of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
    }
    else if (!strcmp(option, "tickets", true))
    {
        if (!VehicleInfo[vehicleid][vOwnerID])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [tickets] [value]");
        }

        VehicleInfo[vehicleid][vTickets] = value;

        DBQuery("UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the tickets of %s's %s (ID %i) to $%i.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
    }
    else if (!strcmp(option, "locked", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [locked] [0/1]");
        }
        if (VehicleInfo[vehicleid][vFaction] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Faction vehicles can't be locked.");
        }

        VehicleInfo[vehicleid][vLocked] = value;

        DBQuery("UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[vehicleid][vLocked], VehicleInfo[vehicleid][vID]);


        SetVehicleParams(vehicleid, VEHICLE_DOORS, value);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the locked state of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
    }

    else if (!strcmp(option, "color", true))
    {
        new color1, color2;

        if (sscanf(param, "ii", color1, color2))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [color] [color 1] [color 2]");
        }
        if (!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The colors must range from 0 to 255.");
        }

        VehicleInfo[vehicleid][vColor1] = color1;
        VehicleInfo[vehicleid][vColor2] = color2;

        DBQuery("UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2], VehicleInfo[vehicleid][vID]);


        ChangeVehicleColor(vehicleid, color1, color2);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the colors of %s (ID %i) to %i, %i.", GetVehicleName(vehicleid), vehicleid, color1, color2);
    }
    else if (!strcmp(option, "paintjob", true))
    {
        new paintjobid;

        if (sscanf(param, "i", paintjobid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [paintjobid] [value (-1 = none)]");
        }
        if (!(-1 <= paintjobid <= 5))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The paintjob must range from -1 to 5.");
        }
        if (VehicleInfo[vehicleid][vFaction] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't change the paintjob on a faction vehicle.");
        }

        VehicleInfo[vehicleid][vPaintjob] = paintjobid;

        DBQuery("UPDATE vehicles SET paintjob = %i WHERE id = %i", VehicleInfo[vehicleid][vPaintjob], VehicleInfo[vehicleid][vID]);


        ChangeVehiclePaintjob(vehicleid, paintjobid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the paintjob of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, paintjobid);
    }
    else if (!strcmp(option, "impound", true))
    {
        if (!VehicleInfo[vehicleid][vOwnerID])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
        }
        new paintjobid;
        if (sscanf(param, "i", paintjobid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [impound] [-1 to reset]");
            return 1;
        }

        VehicleInfo[vehicleid][carImpounded] = paintjobid;
        VehicleInfo[vehicleid][carImpoundPrice] = -1;
        DBQuery("UPDATE `vehicles` SET `carImpounded` = '%i', `carImpoundPrice` = '100' WHERE `id` = '%i'", paintjobid, VehicleInfo[vehicleid][vID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the neon type of %s's %s (ID %i) to %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, param);
    }
    else if (!strcmp(option, "neon", true))
    {
        if (!VehicleInfo[vehicleid][vOwnerID])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
        }
        if (isnull(param))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [neon] [color]");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of colors: None, Red, Blue, Green, Yellow, Pink, White");
            return 1;
        }

        if (!strcmp(param, "neon", true))
        {
            SetVehicleNeon(vehicleid, 0);
        }
        else if (!strcmp(param, "red", true))
        {
            SetVehicleNeon(vehicleid, 18647);
        }
        else if (!strcmp(param, "blue", true))
        {
            SetVehicleNeon(vehicleid, 18648);
        }
        else if (!strcmp(param, "green", true))
        {
            SetVehicleNeon(vehicleid, 18649);
        }
        else if (!strcmp(param, "yellow", true))
        {
            SetVehicleNeon(vehicleid, 18650);
        }
        else if (!strcmp(param, "pink", true))
        {
            SetVehicleNeon(vehicleid, 18651);
        }
        else if (!strcmp(param, "white", true))
        {
            SetVehicleNeon(vehicleid, 18652);
        }
        else
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid color.");
        }

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the neon type of %s's %s (ID %i) to %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, param);
    }
    else if (!strcmp(option, "trunk", true))
    {
        if (!VehicleInfo[vehicleid][vOwnerID])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value) || !(0 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [trunk] [level (0-3)]");
        }

        VehicleInfo[vehicleid][vTrunk] = value;

        DBQuery("UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the trunk of %s's %s (ID %i) to level %i/3.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
    }
    else if (!strcmp(option, "health", true))
    {
        new Float:amount;

        if (sscanf(param, "f", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [health] [amount]");
        }
        if (!(300.0 <= amount <= 10000.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The health value must range from 300.0 to 10000.0.");
        }

        VehicleInfo[vehicleid][vHealth] = amount;

        DBQuery("UPDATE vehicles SET health = '%f' WHERE id = %i", VehicleInfo[vehicleid][vHealth], VehicleInfo[vehicleid][vID]);


        SetVehicleHealth(vehicleid, amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the health of %s (ID %i) to %.2f.", GetVehicleName(vehicleid), vehicleid, amount);
    }
    else if (!strcmp(option, "gang", true))
    {
        new gangid;

        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", gangid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [gang] [gangid (-1 = none)]");
        }
        if (!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
        }

        VehicleInfo[vehicleid][vGang] = gangid;

        DBQuery("UPDATE vehicles SET gangid = %i WHERE id = %i", VehicleInfo[vehicleid][vGang], VehicleInfo[vehicleid][vID]);


        if (gangid == -1)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You have reset the gang for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the gang of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GangInfo[gangid][gName], gangid);
    }
    else if (!strcmp(option, "faction", true))
    {
        new factionid;

        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", factionid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [faction] [factionid (-1 = none)]");
            return 1;
        }

        if ( (factionid != -1) && (!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
        }
        VehicleInfo[vehicleid][vFaction] = factionid;

        DBQuery("UPDATE vehicles SET factionid = %i WHERE id = %i", VehicleInfo[vehicleid][vFaction], VehicleInfo[vehicleid][vID]);


        if (factionid == -1)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the faction type for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the faction type of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid,
            FactionInfo[factionid][fName], factionid);
    }
    else if (!strcmp(option, "division", true))
    {
        new id;

        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", id))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [division] [id]");
        }
        if (!(-1 <= id < MAX_FACTION_DIVISIONS))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid id.");
        }
        if (id!=-1 && isnull(FactionDivisions[PlayerData[playerid][pFaction]][id]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid id.");
        }
        VehicleInfo[vehicleid][vFGDivision] = id;

        DBQuery("UPDATE vehicles SET fgdivisionid = %i WHERE id = %i", VehicleInfo[vehicleid][vFGDivision], VehicleInfo[vehicleid][vID]);


        if (id == -1)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the faction division for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the faction division of %s (ID %i) to (%i).", GetVehicleName(vehicleid), vehicleid, id);
    }
    else if (!strcmp(option, "job", true))
    {
        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [job] [type]");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (-1) None (0) Pizzaman (1) Courier (2) Fisherman (3) Bodyguard (4) Arms Dealer (5) Mechanic");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (6) Miner (7) Sweeper (8) Taxi Driver (9) Drug Dealer (10) Lawyer (11) Detective (12) Thief");
            return 1;
        }
        if (!(-1 <= value < JOB_SIZE))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid job.");
        }

        VehicleInfo[vehicleid][vJob] = value;

        DBQuery("UPDATE vehicles SET job = %i WHERE id = %i", VehicleInfo[vehicleid][vJob], VehicleInfo[vehicleid][vID]);


        if (value == JOB_NONE)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the job type for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the job type of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GetJobName(value), value);
    }
    else if (!strcmp(option, "vip", true))
    {
        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [vip] [level (0-3)]");
        }
        if (!(0 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid level.");
        }

        VehicleInfo[vehicleid][vVIP] = value;

        DBQuery("UPDATE vehicles SET vippackage = %i WHERE id = %i", VehicleInfo[vehicleid][vVIP], VehicleInfo[vehicleid][vID]);


        if (value == 0)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the VIP restriction for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the VIP restriction of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GetVIPRank(value), value);
    }
    else if (!strcmp(option, "respawndelay", true))
    {
        new id = VehicleInfo[vehicleid][vID];

        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [respawndelay] [seconds (-1 = none)]");
        }

        VehicleInfo[vehicleid][vRespawnDelay] = value;

        DBQuery("UPDATE vehicles SET respawndelay = %i WHERE id = %i", VehicleInfo[vehicleid][vRespawnDelay], id);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the respawn delay of %s (ID %i) to %i seconds.", GetVehicleName(vehicleid), vehicleid, value);
        SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
        DespawnVehicle(vehicleid, false);

        DBFormat("SELECT * FROM vehicles WHERE id = %i", id);
        DBExecute("OnLoadVehicles", "i", -1);
    }
    else if (!strcmp(option, "siren", true))
    {
        new id = VehicleInfo[vehicleid][vID];

        if (VehicleInfo[vehicleid][vFaction] == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on faction vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [siren] [1/0]");
        }

        DBQuery("UPDATE vehicles SET siren = %i WHERE id = %i", value, id);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the siren of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
        SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
        DespawnVehicle(vehicleid, false);

        DBFormat("SELECT * FROM vehicles WHERE id = %i", id);
        DBExecute("OnLoadVehicles", "i", -1);
    }
    else if (!strcmp(option, "rank", true))
    {
        if (VehicleInfo[vehicleid][vOwnerID] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
        }
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [rank] [rank(0-12)]");
        }
        if (!(0 <= value <= 12))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
        }

        VehicleInfo[vehicleid][vRank] = value;

        DBQuery("UPDATE vehicles SET vehicles.rank = %i WHERE id = %i", VehicleInfo[vehicleid][vRank], VehicleInfo[vehicleid][vID]);


        if (value == 0)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the rank restriction for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the rank restriction of %s (ID %i) to %i (%i).", GetVehicleName(vehicleid), vehicleid, VehicleInfo[vehicleid][vRank], value);
    }

    return 1;
}

CMD:removeveh(playerid, params[])
{
    return callcmd::removevehicle(playerid, params);
}

CMD:removevehicle(playerid, params[])
{
    new vehicleid;

    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", vehicleid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removevehicle [vehicleid]");
    }
    if (!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
    }

    if (VehicleInfo[vehicleid][vOwnerID])
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have deleted %s's %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid));
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have deleted %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
    }

    DBQuery("DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);

    DespawnVehicle(vehicleid, false);
    return 1;
}

CMD:vehicleinfo(playerid, params[])
{
    new vehicleid, neon[12], gang[32], Float:health;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", vehicleid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vehicleinfo [vehicleid]");
    }
    if (!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
    }

    GetVehicleHealth(vehicleid, health);

    switch (VehicleInfo[vehicleid][vNeon])
    {
        case 18647: neon = "Red";
        case 18648: neon = "Blue";
        case 18649: neon = "Green";
        case 18650: neon = "Yellow";
        case 18651: neon = "Pink";
        case 18652: neon = "White";
        default: neon = "None";
    }

    if (VehicleInfo[vehicleid][vGang] >= 0)
    {
        strcat(gang, GangInfo[VehicleInfo[vehicleid][vGang]][gName]);
    }
    else
    {
        gang = "None";
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s Stats _______", GetVehicleName(vehicleid));
    SendClientMessageEx(playerid, COLOR_GREY2, "Owner: %s - Value: %s - Tickets: %s - License Plate: %s", VehicleInfo[vehicleid][vOwner], FormatCash(VehicleInfo[vehicleid][vPrice]), FormatCash(VehicleInfo[vehicleid][vTickets]), VehicleInfo[vehicleid][vPlate]);
    SendClientMessageEx(playerid, COLOR_GREY2, "Neon: %s - Trunk Level: %i/3 - Alarm Level: %i/3 - Health: %.1f - Fuel: %i/100", neon, VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vAlarm], health, GetVehicleFuel(vehicleid));
    //SendClientMessageEx(playerid, COLOR_GREY2, "Gang: %s - Faction: %s - Rank: %i - Job Type: %s - Respawn Delay: %i seconds", gang, factionTypes[VehicleInfo[vehicleid][vFaction]], VehicleInfo[vehicleid][vRank], GetJobName(VehicleInfo[vehicleid][vJob]), VehicleInfo[vehicleid][vRespawnDelay]);
    return 1;
}

CMD:aclearwanted(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /aclearwanted [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pWantedLevel])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has no active charges to clear.");
    }

    PlayerData[targetid][pWantedLevel] = 0;

    DBQuery("DELETE FROM charges WHERE uid = %i", PlayerData[targetid][pID]);

    DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = 0 WHERE uid = %i", PlayerData[targetid][pID]);


    SendClientMessageEx(targetid, COLOR_WHITE, "Your crimes were cleared by %s.", GetRPName(playerid));
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has cleared %s's crimes and wanted level.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:removedm(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removedm [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pDMWarnings] && !PlayerData[targetid][pWeaponRestricted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't been punished for DM recently.");
    }

    PlayerData[targetid][pDMWarnings]--;
    PlayerData[targetid][pWeaponRestricted] = 0;

    if (PlayerData[targetid][pJailType] == JailType_OOCPrison)
    {
        PlayerData[targetid][pJailType] = JailType_None;
        PlayerData[targetid][pJailTime] = 0;

        SetPlayerPos(targetid, 1544.4407, -1675.5522, 13.5584);
        SetPlayerFacingAngle(targetid, 90.0000);
        SetPlayerInterior(targetid, 0);
        SetPlayerVirtualWorld(targetid, 0);
        SetCameraBehindPlayer(targetid);
        SetPlayerWeapons(targetid);
    }

    SendClientMessageEx(targetid, COLOR_AQUA, "* Your DM punishment has been reversed by %s.", GetRPName(playerid));
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reversed %s's DM punishment.", GetRPName(playerid), GetRPName(targetid));
    DBLog("log_admin", "%s (uid: %i) reversed %s's (uid: %i) DM punishment.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

    DBQuery("UPDATE "#TABLE_USERS" SET jailtype = 0, jailtime = 0, dmwarnings = %i, weaponrestricted = 0 WHERE uid = %i", PlayerData[targetid][pDMWarnings], PlayerData[targetid][pID]);


    return 1;
}

CMD:destroyveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    if (adminVehicle[vehicleid])
    {
        DestroyVehicleEx(vehicleid);
        adminVehicle[vehicleid] = false;
        return SendClientMessage(playerid, COLOR_GREY, "Admin vehicle destroyed.");
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (adminVehicle[i])
        {
            if (IsValidDynamicObject(vehicleSiren[i]))
            {
                DestroyDynamicObject(vehicleSiren[i]);
                vehicleSiren[i] = INVALID_OBJECT_ID;
            }

            DestroyVehicleEx(i);
            adminVehicle[i] = false;
        }
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s destroyed all admin spawned vehicles.", GetRPName(playerid));
    return 1;
}

CMD:respawncars(playerid, params[])
{
    new option[10], param[12];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[10]S()[12]", option, param))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /respawncars [job | faction | vip | nearby | all]");
    }

    if (!strcmp(option, "vip", true))
    {
        RespawnVipVehicles();
        SendClientMessageEx(playerid, COLOR_GREY, "You have respawned all unoccupied VIP Vehicles.");
    }
    else if (!strcmp(option, "job", true))
    {
        foreach(new i: Vehicle)
        {
            if (!IsVehicleOccupied(i) && !adminVehicle[i])
            {
                if (IsJobCar(i))
                {
                    SetVehicleToRespawn(i);
                }
            }
        }

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied job vehicles.", GetRPName(playerid));
    }
    else if (!strcmp(option, "faction", true))
    {
        new factionid;

        if (sscanf(param, "i", factionid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /respawncars [faction] [factionid]");
            return 1;
        }
        if (!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction id.");
        }

        foreach(new i: Vehicle)
        {
            if (!IsVehicleOccupied(i) && !adminVehicle[i] && VehicleInfo[i][vFaction] == factionid)
            {
                SetVehicleToRespawn(i);
            }
        }

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied {F7A763}%s{FF6347} vehicles.", GetRPName(playerid), FactionInfo[factionid][fName]);
    }
    else if (!strcmp(option, "nearby", true))
    {
        foreach(new i: Vehicle)
        {
            if (!IsVehicleOccupied(i) && !adminVehicle[i] && IsVehicleStreamedIn(i, playerid))
            {
                SetVehicleToRespawn(i);
            }
        }

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied vehicles in %s.", GetRPName(playerid), GetPlayerZoneName(playerid));
    }
    else if (!strcmp(option, "all", true))
    {
        foreach(new i: Vehicle)
        {
            if (!IsVehicleOccupied(i) && !adminVehicle[i])
            {
                SetVehicleToRespawn(i);
            }
        }

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied vehicles.", GetRPName(playerid));
    }

    return 1;
}

CMD:fixveh(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    if (!IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't fix a vehicle if you're not sitting in one.");
    }

    RepairVehicle(GetPlayerVehicleID(playerid));
    SendClientMessage(playerid, COLOR_GREY, "Vehicle fixed.");
    return 1;
}

CMD:givepveh(playerid, params[])
{
    return callcmd::givepvehicle(playerid, params);
}
CMD:givepcar(playerid, params[])
{
    return callcmd::givepvehicle(playerid, params);
}
CMD:givepvehicle(playerid, params[])
{
    new model[20], modelid, targetid, color1, color2, Float:x, Float:y, Float:z, Float:a, plate[32];

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[20]ii", targetid, model, color1, color2))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givepveh [playerid] [modelid/name] [color1] [color2]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if ((modelid = GetVehicleModelByName(model)) == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle model.");
    }
    if (!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid color. Valid colors range from 0 to 255.");
    }

    GetPlayerPos(targetid, x, y, z);
    GetPlayerFacingAngle(targetid, a);
    format(plate, 32, "%c%c%c %i", Random('A', 'Z'), Random('A', 'Z'), Random('A', 'Z'), Random(100, 999));

    DBQuery("INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, plate, color1, color2, carImpounded) VALUES(%i, '%e', %i, '%f', '%f', '%f', '%f', '%e', %i, %i, '0')", PlayerData[targetid][pID], GetPlayerNameEx(targetid), modelid, x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a, plate, color1, color2);

    SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you your own {00AA00}%s{33CCFF}. /carstorage to spawn it.", GetRPName(playerid), GetVehicleNameByModel(modelid));
    SendClientMessageEx(playerid, COLOR_AQUA, "You have given %s their own {00AA00}%s{33CCFF}.", GetRPName(targetid), GetVehicleNameByModel(modelid));

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s their own %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleNameByModel(modelid));
    DBLog("log_admin", "%s (uid: %i) has given %s (uid: %i) their own %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetVehicleNameByModel(modelid));
    return 1;
}
