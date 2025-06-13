/// @file      DoorAndGate.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

//TODO: merge with Gates.pwn

#define FT_LAW_ENFORCEMENT -1

enum eGateInfo
{
    gateFactionType,
    gateObject,
    gateModelId,
    Float:gateX,
    Float:gateY,
    Float:gateZ,
    Float:gateRX,
    Float:gateRY,
    Float:gateRZ,
    Float:gateMoveSpeed,
    Float:gateMoveX,
    Float:gateMoveY,
    Float:gateMoveZ,
    Float:gateMoveRX,
    Float:gateMoveRY,
    Float:gateMoveRZ
};
new gGates[][eGateInfo] = {
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 980, 2666.76978, -2504.55322,   15.3131, 0.0, 0.0,  90.0, 2.0, 2666.76978, -2515.98240,   15.3131, 0.0, 0.0,  90.0 },
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 980, 2607.69126, -2402.08350,   15.3131, 0.0, 0.0, -99.0, 2.0, 2609.80920, -2391.08150,   15.3131, 0.0, 0.0, -99.0 },
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 980, 2756.19800, -2561.67260,   15.3131, 0.0, 0.0,   0.0, 2.0, 2744.69800, -2561.67260,   15.3131, 0.0, 0.0,   0.0 },
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 980, 2693.25000, -2330.81740,   15.3131, 0.0, 0.0, 180.0, 2.0, 2704.25000, -2330.81740,   15.3131, 0.0, 0.0, 180.0 },
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 980, 2720.52560, -2403.64870,   15.3131, 0.0, 0.0,  90.0, 2.0, 2720.52560, -2395.64870,   15.3131, 0.0, 0.0,  90.0 },
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 980, 2720.42090, -2502.32050,   15.3131, 0.0, 0.0,  90.0, 2.0, 2720.42090, -2494.32050,   15.3131, 0.0, 0.0,  90.0 },
    { FACTION_NEWS, INVALID_OBJECT_ID, 980,  777.83300, -1384.47000,   15.5000, 0.0, 0.0, 180.0, 2.0,  768.16300, -1384.47000,   15.5000, 0.0, 0.0, 180.0 },
    { FACTION_NEWS, INVALID_OBJECT_ID, 980,  778.21800, -1330.67000,   15.3040, 0.0, 0.0,  -1.0, 2.0,  768.30000, -1330.50000,   15.3040, 0.0, 0.0,  -1.0 },
    { FT_LAW_ENFORCEMENT, INVALID_OBJECT_ID, 1536, 1175.58325,  2972.05029, 1005.0759, 0.0, 0.0, 180.0, 2.0, 1176.9000,  2972.05029, 1005.0759, 0.0, 0.0, 180.0 }
};

IsGateModel(modelid)
{
    switch (modelid)
    {
        case 8957, 7891, 3037, 19861, 19864, 19912, 971, 975, 980, 985, 19870, 988:
        {
            return 1;
        }
    }

    return 0;
}
IsDoorModel(modelid)
{
    switch (modelid)
    {
        case 19802, 2930, 2911, 1567, 1491, 1492, 1493, 1494, 1495, 1496, 1497, 1498, 1499, 1500, 1501, 1502, 1504, 1505, 1506, 1507, 1523, 8957, 7891, 3109, 3089, 3061, 3037, 3029, 2970, 2949, 2948,2947, 2946, 2944, 977:
        {
            return 1;
        }
    }

    return 0;
}
IsGateObject(objectid)
{
    new
        modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

    if ((modelid) && IsGateModel(modelid))
    {
        return 1;
    }

    return 0;
}

IsDoorObject(objectid)
{
    new
        modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

    if ((modelid) && !IsGateObject(objectid))
    {
        for (new i = 0; i < sizeof(landArray); i ++)
        {
            if (!strcmp(landArray[i][fCategory], "Doors & Gates") && landArray[i][fModel] == modelid)
            {
                return 1;
            }
        }
    }

    return 0;
}

GetStaticEntranceWorld(name[])
{
    for (new i = 0; i < sizeof(staticEntrances); i ++)
    {
        if (!strcmp(staticEntrances[i][eName], name))
        {
            return staticEntrances[i][eWorld];
        }
    }

    return 0;
}

GetClosestDoor(playerid, Float:range)
{
    for (new i = 0; i < MAX_FURNITURE; i ++)
    {
        if (Furniture[i][fExists] && IsDoorModel(Furniture[i][fModel]) && IsPlayerNearPoint(playerid, range, Furniture[i][fSpawn][0], Furniture[i][fSpawn][1], Furniture[i][fSpawn][2], Furniture[i][fInterior], Furniture[i][fWorld]))
        {
            return i;
        }
    }
    return -1;
}

GateCheck(playerid)
{
    new id;
    for (new idx=0;idx<sizeof(gGates); idx++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 10.0, gGates[idx][gateX], gGates[idx][gateY], gGates[idx][gateZ]))
        {
            if (gGates[idx][gateFactionType] == FT_LAW_ENFORCEMENT)
            {
                if (!IsLawEnforcement(playerid))
                {
                    return SendUnautorizedGate(playerid);
                }
            }
            else if (GetPlayerFaction(playerid) != gGates[idx][gateFactionType])
            {
                return SendUnautorizedGate(playerid);
            }
            if (!Streamer_GetExtraInt(gGates[idx][gateObject], E_OBJECT_OPENED))
            {
                ShowActionBubble(playerid, "* %s uses their remote to open the gate.", GetRPName(playerid));
                MoveDynamicObject(gGates[idx][gateObject], gGates[idx][gateMoveX], gGates[idx][gateMoveY], gGates[idx][gateMoveZ],
                    gGates[idx][gateMoveSpeed], gGates[idx][gateMoveRX], gGates[idx][gateMoveRY], gGates[idx][gateMoveRZ]);
                Streamer_SetExtraInt(gGates[idx][gateObject], E_OBJECT_OPENED, 1);
            }
            else
            {
                ShowActionBubble(playerid, "* %s uses their remote to close the gate.", GetRPName(playerid));
                MoveDynamicObject(gGates[idx][gateObject], gGates[idx][gateX], gGates[idx][gateY], gGates[idx][gateZ],
                    gGates[idx][gateMoveSpeed], gGates[idx][gateRX], gGates[idx][gateRY], gGates[idx][gateRZ]);
                Streamer_SetExtraInt(gGates[idx][gateObject], E_OBJECT_OPENED, 0);
            }
            return 1;
        }
    }
    if (IsPlayerInRangeOfPoint(playerid, 10.0, 1544.639892, -1631.008666, 13.252797)) // PD barrier
    {
        if (GetPlayerFaction(playerid) != FACTION_POLICE && GetPlayerFaction(playerid) != FACTION_FEDERAL && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
        {
            return SendUnautorizedGate(playerid);
        }

        if (!Streamer_GetExtraInt(gPDGates[0], E_OBJECT_OPENED))
        {
            ShowActionBubble(playerid, "* %s uses their remote to open the gate.", GetRPName(playerid));
            MoveDynamicObject(gPDGates[0], 1544.689941, -1630.818481, 13.116797, 0.2, 0.000000, 0.000000, 90.000000);
            Streamer_SetExtraInt(gPDGates[0], E_OBJECT_OPENED, 1);
        }
        else
        {
            ShowActionBubble(playerid, "* %s uses their remote to close the gate.", GetRPName(playerid));
            MoveDynamicObject(gPDGates[0], 1544.639892, -1631.008666, 13.252797, 0.2, 0.000000, 90.000000, 90.000000);
            Streamer_SetExtraInt(gPDGates[0], E_OBJECT_OPENED, 0);
        }

        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 10.0, 1588.042602, -1638.079956, 14.602818)) // PD garage gate
    {
        if (GetPlayerFaction(playerid) != FACTION_POLICE && GetPlayerFaction(playerid) != FACTION_FEDERAL && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
        {
            return SendUnautorizedGate(playerid);
        }

        if (!Streamer_GetExtraInt(gPDGates[1], E_OBJECT_OPENED))
        {
            ShowActionBubble(playerid, "* %s uses their remote to open the gate.", GetRPName(playerid));
            MoveDynamicObject(gPDGates[1], 1597.332763, -1638.079956, 14.602818, 3.0);
            Streamer_SetExtraInt(gPDGates[1], E_OBJECT_OPENED, 1);
        }
        else
        {
            ShowActionBubble(playerid, "* %s uses their remote to close the gate.", GetRPName(playerid));
            MoveDynamicObject(gPDGates[1], 1588.042602, -1638.079956, 14.602818, 3.0);
            Streamer_SetExtraInt(gPDGates[1], E_OBJECT_OPENED, 0);
        }

        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 10.0, 321.255279, -1488.601318, 25.281988)) // FBI garage gate
    {
        if (GetPlayerFaction(playerid) != FACTION_FEDERAL  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
        {
            return SendUnautorizedGate(playerid);
        }

        if (!Streamer_GetExtraInt(gFBIGates[0], E_OBJECT_OPENED))
        {
            ShowActionBubble(playerid, "* %s uses their remote to open the gate.", GetRPName(playerid));
            MoveDynamicObject(gFBIGates[0], 327.033508, -1492.691650, 25.281988, 3.0);
            Streamer_SetExtraInt(gFBIGates[0], E_OBJECT_OPENED, 1);
        }
        else
        {
            ShowActionBubble(playerid, "* %s uses their remote to close the gate.", GetRPName(playerid));
            MoveDynamicObject(gFBIGates[0], 321.255279, -1488.601318, 25.281988, 3.0);
            Streamer_SetExtraInt(gFBIGates[0], E_OBJECT_OPENED, 0);
        }

        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 10.0, 283.590423, -1542.835083, 25.281988)) // FBI garage gate
    {
        if (GetPlayerFaction(playerid) != FACTION_FEDERAL  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
        {
            return SendUnautorizedGate(playerid);
        }

        if (!Streamer_GetExtraInt(gFBIGates[1], E_OBJECT_OPENED))
        {
            ShowActionBubble(playerid, "* %s uses their remote to open the gate.", GetRPName(playerid));
            MoveDynamicObject(gFBIGates[1], 289.593841, -1547.023071, 25.281988, 3.0);
            Streamer_SetExtraInt(gFBIGates[1], E_OBJECT_OPENED, 1);
        }
        else
        {
            ShowActionBubble(playerid, "* %s uses their remote to close the gate.", GetRPName(playerid));
            MoveDynamicObject(gFBIGates[1], 283.590423, -1542.835083, 25.281988, 3.0);
            Streamer_SetExtraInt(gFBIGates[1], E_OBJECT_OPENED, 0);
        }

        return 1;
    }
    else if ((id = GetNearbyGate(playerid)) >= 0)
    {
        ToggleGate(playerid, id);
    }
    if ((id = GetNearbyLand(playerid)) >= 0 && PlayerHasPropertyAccess(playerid, PropertyType_Land, id, KeyAccess_Doors))
    {
        for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
        {
            if (IsValidDynamicObject(i) && IsGateObject(i) && IsPlayerInRangeOfPoint(playerid, 10.0, Streamer_GetExtraFloat(i, E_OBJECT_X), Streamer_GetExtraFloat(i, E_OBJECT_Y), Streamer_GetExtraFloat(i, E_OBJECT_Z)) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[id][lID])
            {
                DBFormat("SELECT * FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerUseLandGate", "ii", playerid, i);
                return 1;
            }
        }
    }

    return 0;
}

DoorCheck(playerid)
{
    new houseid = GetInsideHouse(playerid), landid = GetNearbyLand(playerid);

    new Float:angle;
    for (new i = 0; i < sizeof(gPDDoors); i ++)
    {
        if (IsPlayerInRangeOfDynamicObject(playerid, gPDDoors[i], 3.0))
        {
            if (GetPlayerFaction(playerid) != FACTION_POLICE && GetPlayerFaction(playerid) != FACTION_FEDERAL)
            {
                return SendUnautorizedDoor(playerid);
            }
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, gPDDoors[i], E_STREAMER_R_Z, angle);
            if (!Streamer_GetExtraInt(gPDDoors[i], E_OBJECT_OPENED))
            {
                ShowActionBubble(playerid, "* %s uses their card to open the door.", GetRPName(playerid));
                SetDynamicObjectRot(gPDDoors[i], 0.0000, 0.0000, angle + 90.0);
                Streamer_SetExtraInt(gPDDoors[i], E_OBJECT_OPENED, 1);
            }
            else
            {
                ShowActionBubble(playerid, "* %s uses their card to close the door.", GetRPName(playerid));
                SetDynamicObjectRot(gPDDoors[i], 0.0000, 0.0000, angle - 90.0);
                Streamer_SetExtraInt(gPDDoors[i], E_OBJECT_OPENED, 0);
            }
            return 1;
        }
    }
    if (houseid != INVALID_HOUSE_ID)
    {
        if (IsValidFurnitureID(GetClosestDoor(playerid, 2.0)))
        {
            if (Furniture[GetClosestDoor(playerid, 2.0)][fDoorOpen] == 1)
            {
                Furniture[GetClosestDoor(playerid, 2.0)][fSpawn][5] = Furniture[GetClosestDoor(playerid, 2.0)][fSpawn][5] + 90.0;
                Furniture[GetClosestDoor(playerid, 2.0)][fDoorOpen] = 0;
                ReloadFurniture(GetClosestDoor(playerid, 2.0));
            }
            else
            {
                Furniture[GetClosestDoor(playerid, 2.0)][fSpawn][5] = Furniture[GetClosestDoor(playerid, 2.0)][fSpawn][5] - 90.0;
                Furniture[GetClosestDoor(playerid, 2.0)][fDoorOpen] = 1;
                ReloadFurniture(GetClosestDoor(playerid, 2.0));
            }
        }
    }
    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
        {
            if (landid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
            {
                DBFormat("SELECT door_opened, door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerUseLandDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }
        }
    }

    return 0;
}

EnterCheck(playerid)
{
    new id, string[40];

    if ((gettime() - PlayerData[playerid][pLastEnter]) < 3 && PlayerData[playerid][pAdminDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Please wait a moment before entering or exiting again.");
    }
    new closestcar = GetClosestVehicle(playerid, INVALID_VEHICLE_ID, 6.0);
    new Float:vehicleHp;
    GetVehicleHealth(closestcar, vehicleHp);//TODO: GetVehicleHealthEx
    if (vehicleHp >= 250.0 && GetPlayerInterior(playerid) == 0)
    {//TODO: save player pos outside vehicle
     //TODO: what happen when vehicle destroyed
        new bool:hasInterior = true;
        switch (GetVehicleModel(closestcar))
        {
            case 519: // Shamal
            {
                TeleportToCoords(playerid, 2.509036, 23.118730, 1199.593750, 82.14, 1, closestcar, true, false);
            }
            case 431: // Bus
            {
                TeleportToCoords(playerid, 2022.0204, 2236.0549, 2103.9536, 2.01, 1, closestcar, true, false);
            }
            case 508: // Journey
            {
                TeleportToCoords(playerid, 2512.6985, -1729.2311, 778.6371, 85.67, 1, closestcar, true, false);
            }
            case 563: // Raindance
            {
                TeleportToCoords(playerid, -537.9229, 1303.6589, 2075.6223, 137.62, 1, closestcar, true, false);
            }
            case 433: // Barracks
            {
                TeleportToCoords(playerid, 1101.5210, 1074.7563, 3510.9238, 87.62, 1, closestcar, true, false);
            }
            case 548: // Cargobob
            {
                TeleportToCoords(playerid, 1472.1326, 1778.1577, -45.2152, 176.85, 1, closestcar, true, false);
            }
            case 417: // Leviathan
            {
                TeleportToCoords(playerid, 2650.8535, 858.0659, 633.7065, 201.70, 1, closestcar, true, false);
            }
            case 427: // Enfrocer
            {
                TeleportToCoords(playerid, -26.4598, 42.3772, 1000.1084, 179.77, 1, closestcar, true, false);
            }
            default:
            {
                hasInterior = false;
            }
        }
        if (hasInterior)
        {
            SetCameraBehindPlayer(playerid);
            PlayerData[playerid][pWorld] = closestcar;
            SetPlayerVirtualWorld(playerid, closestcar);
            PlayerData[playerid][pInterior] = 1;
            SetPlayerInterior(playerid, 1);
            InsideShamal[playerid] = closestcar;
            SendClientMessage(playerid, COLOR_WHITE, "Type /exit near the door to exit the vehicle, or /window to look outside.");
            ShowActionBubble(playerid, "* %s enters the %s as a passenger.", GetRPName(playerid), GetVehicleName(closestcar));
        }
    }
    if ((id = GetNearbyHouse(playerid)) >= 0)
    {
        if (HouseInfo[id][hLocked])
        {
            ShowPlayerFooter(playerid, "~r~Locked");
            return 0;
        }

        if (IsHouseOwner(playerid, id))
        {
            HouseInfo[id][hTimestamp] = gettime();

            DBQuery("UPDATE houses SET timestamp = %i WHERE id = %i", gettime(), HouseInfo[id][hID]);

            ShowActionBubble(playerid, "* %s has entered their house.", GetRPName(playerid));
        }
        else
        {
            ShowActionBubble(playerid, "* %s has entered the house.", GetRPName(playerid));
        }

        PlayerData[playerid][pLastEnter] = gettime();
        SetFreezePos(playerid, HouseInfo[id][hIntX], HouseInfo[id][hIntY], HouseInfo[id][hIntZ]);
        SetPlayerFacingAngle(playerid, HouseInfo[id][hIntA]);
        SetPlayerInterior(playerid, HouseInfo[id][hInterior]);
        SetPlayerVirtualWorld(playerid, HouseInfo[id][hWorld]);
        SetCameraBehindPlayer(playerid);
        if (HouseInfo[id][hLights] == 1)
        {
            TextDrawHideForPlayer(playerid, houseLights);
        }
        else
        {
            TextDrawShowForPlayer(playerid, houseLights);
        }
        return 1;
    }
    else if ((id = GetNearbyGarage(playerid)) >= 0)
    {
        if (GarageInfo[id][gLocked])
        {
            ShowPlayerFooter(playerid, "~r~Locked");
            return 0;
        }

        if (IsGarageOwner(playerid, id))
        {
            GarageInfo[id][gTimestamp] = gettime();

            DBQuery("UPDATE garages SET timestamp = %i WHERE id = %i", gettime(), GarageInfo[id][gID]);

            ShowActionBubble(playerid, "* %s has entered their garage.", GetRPName(playerid));
        }
        else
        {
            ShowActionBubble(playerid, "* %s has entered the garage.", GetRPName(playerid));
        }

        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            TeleportToCoords(playerid, garageInteriors[GarageInfo[id][gType]][intVX], garageInteriors[GarageInfo[id][gType]][intVY], garageInteriors[GarageInfo[id][gType]][intVZ], garageInteriors[GarageInfo[id][gType]][intVA], garageInteriors[GarageInfo[id][gType]][intID], GarageInfo[id][gWorld], true, true);
        }
        else
        {
            PlayerData[playerid][pLastEnter] = gettime();
            SetFreezePos(playerid, garageInteriors[GarageInfo[id][gType]][intPX], garageInteriors[GarageInfo[id][gType]][intPY], garageInteriors[GarageInfo[id][gType]][intPZ]);
            SetPlayerFacingAngle(playerid, garageInteriors[GarageInfo[id][gType]][intPA]);
            SetPlayerInterior(playerid, garageInteriors[GarageInfo[id][gType]][intID]);
            SetPlayerVirtualWorld(playerid, GarageInfo[id][gWorld]);
            SetCameraBehindPlayer(playerid);
        }

        return 1;
    }
    else if ((id = GetNearbyBusiness(playerid)) >= 0)
    {
        return TryEnterBusiness(playerid, id);
    }
    else if ((id = GetNearbyEntrance(playerid)) >= 0)
    {
        if (EntranceInfo[id][eLocked])
        {
            ShowPlayerFooter(playerid, "~r~Locked");
            return 0;
        }
        if (EntranceInfo[id][eIntX] == 0.0 && EntranceInfo[id][eIntY] == 0.0 && EntranceInfo[id][eIntZ] == 0.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "This entrance has no interior and therefore cannot be entered.");
            return 0;
        }
        if (EntranceInfo[id][eType] == 2)
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot enter this type of entrance!");
            return 0;
        }

        if (!PlayerData[playerid][pAdminDuty])
        {
            if (EntranceInfo[id][eAdminLevel] && !IsAdmin(playerid, EntranceInfo[id][eAdminLevel]))
            {
                SendClientMessage(playerid, COLOR_GREY, "Your administrator level is too low. You may not enter.");
                return 0;
            }
            if (EntranceInfo[id][eFaction] >= 0 && PlayerData[playerid][pFaction] != EntranceInfo[id][eFaction])
            {
                SendClientMessage(playerid, COLOR_GREY, "This entrance is only accesible to a specific faction type. You may not enter.");
                return 0;
            }
            if (EntranceInfo[id][eGang] >= 0 && EntranceInfo[id][eGang] != PlayerData[playerid][pGang])
            {
                SendClientMessage(playerid, COLOR_GREY, "This entrance is only accesible to a specific gang. You may not enter.");
                return 0;
            }
            if (EntranceInfo[id][eVIP] && PlayerData[playerid][pDonator] < EntranceInfo[id][eVIP])
            {
                SendClientMessage(playerid, COLOR_GREY, "Your VIP rank is too low. You may not enter.");
                return 0;
            }
        }

        PlayerData[playerid][pLastEnter] = gettime();
        ShowActionBubble(playerid, "* %s has entered the building.", GetRPName(playerid));

        if (EntranceInfo[id][eType] == 1)
        {
            SendClientMessage(playerid, COLOR_WHITE, "This entrance can be used for OOC duels. Use /offerduel to initiate one!");
        }
        else if (EntranceInfo[id][eType] == 2)
        {
            SendClientMessage(playerid, COLOR_WHITE, "This entrance can be used to repair vehicles, use /repaircar.");
        }

        if (EntranceInfo[id][eVehicles] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            if (EntranceInfo[id][eFreeze])
            {
                TeleportToCoords(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ], EntranceInfo[id][eIntA], EntranceInfo[id][eInterior], EntranceInfo[id][eWorld], true);
            }
            else
            {
                TeleportToCoords(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ], EntranceInfo[id][eIntA], EntranceInfo[id][eInterior], EntranceInfo[id][eWorld]);
            }
        }
        else
        {
            if (EntranceInfo[id][eFreeze])
            {
                SetFreezePos(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ]);
            }
            else
            {
                SetPlayerPos(playerid, EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ]);
            }

            SetPlayerFacingAngle(playerid, EntranceInfo[id][eIntA]);
            SetPlayerInterior(playerid, EntranceInfo[id][eInterior]);
            SetPlayerVirtualWorld(playerid, EntranceInfo[id][eWorld]);
            SetCameraBehindPlayer(playerid);
        }

        if (!EntranceInfo[id][eFreeze])
        {
            format(string, sizeof(string), "~w~%s", EntranceInfo[id][eName]);
            GameTextForPlayer(playerid, string, 5000, 1);
        }

        return 1;
    }
    else
    {
        if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !PlayerData[playerid][pRepairTime])
        {
            for (new i = 0; i < sizeof(g_RepairShops); i ++)
            {
                if (IsPlayerInRangeOfPoint(playerid, 5.0, g_RepairShops[i][0], g_RepairShops[i][1], g_RepairShops[i][2]))
                {
                    if (IsRepairShopInUse(i))
                    {
                        return SendErrorMessage(playerid, "This Pay n' Spray is currently in use.");
                    }
                    if ((!PlayerCanAfford(playerid, 500)) && (GetPlayerFaction(playerid) != FACTION_POLICE && GetPlayerFaction(playerid) != FACTION_MEDIC))
                    {
                        return SendErrorMessage(playerid, "You can't afford the entry cost.");
                    }

                    SetVehiclePos(GetPlayerVehicleID(playerid), g_RepairShops[i][3], g_RepairShops[i][4], g_RepairShops[i][5]);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), g_RepairShops[i][6]);

                    TogglePlayerControllableEx(playerid, 0);
                    SendClientMessage(playerid, COLOR_WHITE, "Garage: You will be moved out the garage in 8 seconds.");

                    if (GetPlayerFaction(playerid) == FACTION_POLICE || GetPlayerFaction(playerid) == FACTION_MEDIC)
                    {
                        SendClientMessage(playerid, COLOR_GREEN, "Your vehicle is fixed free of charge due to being in a government faction!");
                    }
                    else
                    {
                        GivePlayerCash(playerid, -500);
                    }

                    PlayerData[playerid][pRepairTime] = 8;
                    PlayerData[playerid][pRepairShop] = i;
                    return 1;
                }
            }
        }

        for (new i = 0; i < sizeof(staticEntrances); i ++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 3.0, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ]))
            {
                if (PlayerData[playerid][pDonator] < staticEntrances[i][eVIP])
                {
                    SendClientMessage(playerid, COLOR_GREY, "This lounge is only available to those with a VIP subscription.");
                    return 0;
                }

                if (staticEntrances[i][eFreeze])
                {
                    SetFreezePos(playerid, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ]);
                }
                else
                {
                    SetPlayerPos(playerid, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ]);

                    format(string, sizeof(string), "~w~%s", staticEntrances[i][eName]);
                    GameTextForPlayer(playerid, string, 5000, 1);
                }

                PlayerData[playerid][pLastEnter] = gettime();
                ShowActionBubble(playerid, "* %s has entered the building.", GetRPName(playerid));
                SetPlayerFacingAngle(playerid, staticEntrances[i][eIntA]);
                SetPlayerInterior(playerid, staticEntrances[i][eInterior]);
                SetPlayerVirtualWorld(playerid, staticEntrances[i][eWorld]);
                SetCameraBehindPlayer(playerid);
                return 1;
            }
        }
    }

    return 0;
}

ExitCheck(playerid)
{
    new id;

    if ((gettime() - PlayerData[playerid][pLastEnter]) < 3 && PlayerData[playerid][pAdminDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Please wait a moment before entering or exiting again.");
    }
    if (InsideShamal[playerid] != INVALID_VEHICLE_ID && GetPlayerInterior(playerid) > 0)
    {
        ShowActionBubble(playerid, "* %s exits the %s.", GetRPName(playerid), GetVehicleName(InsideShamal[playerid]));

        new Float:X, Float:Y, Float:Z;
        GetVehiclePos(InsideShamal[playerid], X, Y, Z);
        SetPlayerPos(playerid, X-4, Y-2.3, Z);

        PlayerData[playerid][pWorld] = 0;
        SetPlayerVirtualWorld(playerid, 0);
        PlayerData[playerid][pInterior] = 0;
        SetPlayerInterior(playerid, 0);
        InsideShamal[playerid] = INVALID_VEHICLE_ID;
    }
    if ((id = GetInsideHouse(playerid)) >= 0 && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[id][hIntX], HouseInfo[id][hIntY], HouseInfo[id][hIntZ]))
    {
        PlayerData[playerid][pLastEnter] = gettime();
        ShowActionBubble(playerid, "* %s has exited the house.", GetRPName(playerid));
        SetPlayerPos(playerid, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]);
        SetFreezePos(playerid, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]);
        SetPlayerFacingAngle(playerid, HouseInfo[id][hPosA]);
        SetPlayerInterior(playerid, HouseInfo[id][hOutsideInt]);
        SetPlayerVirtualWorld(playerid, HouseInfo[id][hOutsideVW]);
        SetCameraBehindPlayer(playerid);
        TextDrawHideForPlayer(playerid, houseLights);
        return 1;

    }
    else if ((id = GetInsideGarage(playerid)) >= 0)
    {
        if ((GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInRangeOfPoint(playerid, 6.0, garageInteriors[GarageInfo[id][gType]][intVX], garageInteriors[GarageInfo[id][gType]][intVY], garageInteriors[GarageInfo[id][gType]][intVZ])) ||
            ((GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) && (IsPlayerInRangeOfPoint(playerid, 2.0, garageInteriors[GarageInfo[id][gType]][intPX], garageInteriors[GarageInfo[id][gType]][intPY], garageInteriors[GarageInfo[id][gType]][intPZ]) || IsPlayerInRangeOfPoint(playerid, 4.0, garageInteriors[GarageInfo[id][gType]][intVX], garageInteriors[GarageInfo[id][gType]][intVY], garageInteriors[GarageInfo[id][gType]][intVZ]))))
        {

            ShowActionBubble(playerid, "* %s has exited the garage.", GetRPName(playerid));

            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                TeleportToCoords(playerid, GarageInfo[id][gExitX], GarageInfo[id][gExitY], GarageInfo[id][gExitZ], GarageInfo[id][gExitA], 0, 0);
            }
            else
            {
                SetPlayerPos(playerid, GarageInfo[id][gPosX], GarageInfo[id][gPosY], GarageInfo[id][gPosZ]);
                SetFreezePos(playerid, GarageInfo[id][gPosX], GarageInfo[id][gPosY], GarageInfo[id][gPosZ]);
                SetPlayerFacingAngle(playerid, GarageInfo[id][gPosA]);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetCameraBehindPlayer(playerid);
            }
        }

        PlayerData[playerid][pLastEnter] = gettime();
        return 1;
    }
    else if ((id = GetInsideBusiness(playerid)) >= 0 && IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[id][bIntX], BusinessInfo[id][bIntY], BusinessInfo[id][bIntZ]))
    {
        PlayerData[playerid][pLastEnter] = gettime();


        ShowActionBubble(playerid, "* %s has exited the business.", GetRPName(playerid));

        SetPlayerPos(playerid, BusinessInfo[id][bPosX], BusinessInfo[id][bPosY], BusinessInfo[id][bPosZ]);
        SetFreezePos(playerid, BusinessInfo[id][bPosX], BusinessInfo[id][bPosY], BusinessInfo[id][bPosZ]);
        SetPlayerFacingAngle(playerid, BusinessInfo[id][bPosA]);
        SetPlayerInterior(playerid, BusinessInfo[id][bOutsideInt]);
        SetPlayerVirtualWorld(playerid, BusinessInfo[id][bOutsideVW]);
        SetCameraBehindPlayer(playerid);
        return 1;
    }
    else if ((id = GetInsideEntrance(playerid)) >= 0 && IsPlayerInRangeOfPoint(playerid, (IsPlayerInAnyVehicle(playerid)) ? (7.0) : (3.0), EntranceInfo[id][eIntX], EntranceInfo[id][eIntY], EntranceInfo[id][eIntZ]))
    {
        if (EntranceInfo[id][eType] == 1)
        {
            SetPlayerWeapons(playerid);
        }

        PlayerData[playerid][pLastEnter] = gettime();

        ShowActionBubble(playerid, "* %s has exited the building.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA,"* %s has exited the building.", GetRPName(playerid));

        if (EntranceInfo[id][eVehicles] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            if (EntranceInfo[id][eFreeze])
            {
                TeleportToCoords(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ], EntranceInfo[id][ePosA], EntranceInfo[id][eOutsideInt], EntranceInfo[id][eOutsideVW], true);
            }
            else
            {
                TeleportToCoords(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ], EntranceInfo[id][ePosA], EntranceInfo[id][eOutsideInt], EntranceInfo[id][eOutsideVW]);
            }
        }
        else
        {
            if (EntranceInfo[id][eFreeze])
            {
                SetFreezePos(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ]);
            }
            else
            {
                SetPlayerPos(playerid, EntranceInfo[id][ePosX], EntranceInfo[id][ePosY], EntranceInfo[id][ePosZ]);
            }

            SetPlayerFacingAngle(playerid, EntranceInfo[id][ePosA]);
            SetPlayerInterior(playerid, EntranceInfo[id][eOutsideInt]);
            SetPlayerVirtualWorld(playerid, EntranceInfo[id][eOutsideVW]);
            SetCameraBehindPlayer(playerid);
        }

        return 1;
    }
    else
    {
        for (new i = 0; i < sizeof(staticEntrances); i ++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 3.0, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ]) && GetPlayerVirtualWorld(playerid) == staticEntrances[i][eWorld])
            {
                if (staticEntrances[i][eFreeze])
                {
                    SetFreezePos(playerid, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ]);
                }
                else
                {
                    SetPlayerPos(playerid, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ]);
                }

                PlayerData[playerid][pLastEnter] = gettime();

                ShowActionBubble(playerid, "* %s has exited the building.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA,"* %s has exited the building.", GetRPName(playerid));

                SetPlayerFacingAngle(playerid, staticEntrances[i][ePosA]);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetCameraBehindPlayer(playerid);
                return 1;
            }
        }
    }

    return 0;
}


LoadGatesAndCells()
{

    gPDGates[0] = CreateDynamicObject(968, 1544.639892, -1631.008666, 13.252797, 0.000000, 90.000000, 90.000000);
    gPDGates[1] = CreateDynamicObject(980, 1588.042602, -1638.079956, 14.602818, 0.000000, 0.000000, 0.000000);

    // FBI exterior
    gFBIGates[0] = CreateDynamicObject(985, 321.255279, -1488.601318, 25.281988, 0.000000, 0.000000, -35.299957);
    gFBIGates[1] = CreateDynamicObject(985, 283.590423, -1542.835083, 25.281988, 0.000000, 0.000000, -34.899955);

    for (new idx=0;idx<sizeof(gGates); idx++)
    {
        gGates[idx][gateObject] = CreateDynamicObject(gGates[idx][gateModelId],gGates[idx][gateX], gGates[idx][gateY], gGates[idx][gateZ],
                gGates[idx][gateRX], gGates[idx][gateRY], gGates[idx][gateRZ]);
    }
    /*gPrisonCells[0] = CreateDynamicObject(19302,1205.69995117,-1328.09997559,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[1] = CreateDynamicObject(19302,1205.69995117,-1331.30004883,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[2] = CreateDynamicObject(19302,1205.69995117,-1331.30004883,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[3] = CreateDynamicObject(19302,1205.69995117,-1328.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[4] = CreateDynamicObject(19302,1215.30004883,-1328.09997559,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[5] = CreateDynamicObject(19302,1215.30004883,-1331.30004883,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[6] = CreateDynamicObject(19302,1215.30004883,-1331.30004883,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[7] = CreateDynamicObject(19302,1215.30004883,-1328.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[8] = CreateDynamicObject(19302,1215.30004883,-1334.50000000,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[9] = CreateDynamicObject(19302,1215.29980469,-1337.69921875,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[10] = CreateDynamicObject(19302,1215.30004883,-1340.90002441,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[11] = CreateDynamicObject(19302,1215.30004883,-1340.90002441,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[12] = CreateDynamicObject(19302,1215.30004883,-1337.69995117,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[13] = CreateDynamicObject(19302,1215.30004883,-1334.50000000,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[14] = CreateDynamicObject(19302,1205.69995117,-1334.50000000,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[15] = CreateDynamicObject(19302,1205.69995117,-1337.69995117,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[16] = CreateDynamicObject(19302,1205.69995117,-1340.90002441,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[17] = CreateDynamicObject(19302,1205.69995117,-1334.50000000,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[18] = CreateDynamicObject(19302,1205.69995117,-1337.69995117,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[19] = CreateDynamicObject(19302,1205.69995117,-1340.90002441,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[20] = CreateDynamicObject(19302,1215.30004883,-1344.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[21] = CreateDynamicObject(19302,1215.30004883,-1344.09997559,797.00000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[22] = CreateDynamicObject(19302,1205.69995117,-1344.09997559,800.50000000,0.00000000,0.00000000,90.00000000);
    gPrisonCells[23] = CreateDynamicObject(19302,1205.69995117,-1344.09997559,797.00000000,0.00000000,0.00000000,90.00000000);

    for (new i = 0; i < 24; i ++)
    {
        SetDynamicObjectMaterial(gPrisonCells[i], 0, 19302, "pd_jail_door02", "pd_jail_door02", 0xFF000000);
    }*/
}

CMD:cells(playerid, params[])
{
    new status;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }

    for (new i = 0; i < sizeof(gPrisonCells); i ++)
    {
        if (!Streamer_GetExtraInt(gPrisonCells[i], E_OBJECT_OPENED))
        {
            MoveDynamicObject(gPrisonCells[i], cellPositions[i][3], cellPositions[i][4], cellPositions[i][5], 2.0);
            Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 1);
            status = true;
        }
        else
        {
            MoveDynamicObject(gPrisonCells[i], cellPositions[i][0], cellPositions[i][1], cellPositions[i][2], 2.0);
            Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 0);
            status = false;
        }
    }

    if (status)
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has opened all cells in the prison.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
    else
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has closed all cells in the prison.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));

    return 1;
}

CMD:cell(playerid, params[])
{
    if (!IsLawEnforcement(playerid))
    {
        return SendUnautorizedCell(playerid);
    }

    for (new i = 0; i < sizeof(gPrisonCells); i ++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, cellPositions[i][0], cellPositions[i][1], cellPositions[i][2]))
        {
            if (!Streamer_GetExtraInt(gPrisonCells[i], E_OBJECT_OPENED))
            {
                ShowActionBubble(playerid, "* %s uses their key to open the cell door.", GetRPName(playerid));
                MoveDynamicObject(gPrisonCells[i], cellPositions[i][3], cellPositions[i][4], cellPositions[i][5], 2.0);
                Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 1);
            }
            else
            {
                ShowActionBubble(playerid, "* %s uses their key to close the cell door.", GetRPName(playerid));
                MoveDynamicObject(gPrisonCells[i], cellPositions[i][0], cellPositions[i][1], cellPositions[i][2], 2.0);
                Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 0);
            }

            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any prison cells.");
    return 1;
}

CMD:door(playerid, params[])
{
    if (!DoorCheck(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not in range of any door which you can open.");
    }

    return 1;
}

CMD:gate(playerid, params[])
{
    if (!GateCheck(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not in range of any gates which you can open.");
    }

    return 1;
}

CMD:lock(playerid, params[])
{
    new id, houseid = GetInsideHouse(playerid), landid = GetNearbyLand(playerid);

    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
        {
            if (houseid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Doors))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have permission from the house owner to lock this door.");
                }

                DBFormat("SELECT door_locked FROM rp_furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerLockFurnitureDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }
            else if (landid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
            {

                if (!PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Doors))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have permission from the land owner to lock this door.");
                }

                DBFormat("SELECT door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerLockLandDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }
        }
    }

    if ((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID && PlayerHasPropertyAccess(playerid, PropertyType_Vehicle, id, KeyAccess_Doors))
    {
        if (!VehicleInfo[id][vLocked])
        {
            new string[24];
            VehicleInfo[id][vLocked] = 1;
            format(string, sizeof(string), "~r~%s locked", GetVehicleName(id));
            GameTextForPlayer(playerid, string, 3000, 3);
            ShowActionBubble(playerid, "* %s locks their %s.", GetRPName(playerid), GetVehicleName(id));
        }
        else
        {
            VehicleInfo[id][vLocked] = 0;
            new string[24];
            format(string, sizeof(string), "~b~%s unlocked", GetVehicleName(id));
            GameTextForPlayer(playerid, string, 3000, 3);
            ShowActionBubble(playerid, "* %s unlocks their %s.", GetRPName(playerid), GetVehicleName(id));
        }

        SetVehicleParams(id, VEHICLE_DOORS, VehicleInfo[id][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[id][vLocked], VehicleInfo[id][vID]);

        return 1;
    }
    else if ((id = GetNearbyHouseEx(playerid)) >= 0 && PlayerHasPropertyAccess(playerid, PropertyType_House, id, KeyAccess_Doors))
    {
        if (!HouseInfo[id][hLocked])
        {
            HouseInfo[id][hLocked] = 1;

            GameTextForPlayer(playerid, "~r~House locked", 3000, 6);
            ShowActionBubble(playerid, "* %s locks their house door.", GetRPName(playerid));
        }
        else
        {
            HouseInfo[id][hLocked] = 0;

            GameTextForPlayer(playerid, "~g~House unlocked", 3000, 6);
            ShowActionBubble(playerid, "* %s unlocks their house door.", GetRPName(playerid));
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[id][hLocked], HouseInfo[id][hID]);

        return 1;
    }
    else if ((id = GetNearbyGarageEx(playerid)) >= 0 && IsGarageOwner(playerid, id))
    {
        if (!GarageInfo[id][gLocked])
        {
            GarageInfo[id][gLocked] = 1;

            GameTextForPlayer(playerid, "~r~Garage locked", 3000, 6);
            ShowActionBubble(playerid, "* %s locks their garage door.", GetRPName(playerid));
        }
        else
        {
            GarageInfo[id][gLocked] = 0;

            GameTextForPlayer(playerid, "~g~Garage unlocked", 3000, 6);
            ShowActionBubble(playerid, "* %s unlocks their garage door.", GetRPName(playerid));
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[id][gLocked], GarageInfo[id][gID]);

        return 1;
    }
    else if ((id = GetNearbyBusinessEx(playerid)) >= 0 && IsBusinessOwner(playerid, id))
    {
        if (!BusinessInfo[id][bLocked])
        {
            BusinessInfo[id][bLocked] = 1;

            GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
            ShowActionBubble(playerid, "* %s locks their business door.", GetRPName(playerid));
        }
        else
        {
            BusinessInfo[id][bLocked] = 0;

            GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
            ShowActionBubble(playerid, "* %s unlocks their business door.", GetRPName(playerid));
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);

        return 1;
    }
    else if ((id = GetNearbyEntranceEx(playerid)) >= 0)
    {
        new correct_pass;

        if (!IsEntranceOwner(playerid, id) && strcmp(EntranceInfo[id][ePassword], "None", true) != 0)
        {
            if (isnull(params))
            {
                return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lock [password]");
            }
            else if (strcmp(params, EntranceInfo[id][ePassword]) != 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Incorrect password.");
            }
            else
            {
                correct_pass = true;
            }
        }

        if ((correct_pass) || IsEntranceOwner(playerid, id))
        {
            if (!EntranceInfo[id][eLocked])
            {
                EntranceInfo[id][eLocked] = 1;

                GameTextForPlayer(playerid, "~r~Entrance locked", 3000, 6);
                ShowActionBubble(playerid, "* %s locks their entrance door.", GetRPName(playerid));
            }
            else
            {
                EntranceInfo[id][eLocked] = 0;

                GameTextForPlayer(playerid, "~g~Entrance unlocked", 3000, 6);
                ShowActionBubble(playerid, "* %s unlocks their entrance door.", GetRPName(playerid));
            }

            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

            DBQuery("UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[id][eLocked], EntranceInfo[id][eID]);

        }

        return 1;
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not close to anything which you can lock.");

    return 1;
}

CMD:alock(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
        {
            if ((id = GetInsideHouse(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[id][hID])
            {
                DBFormat("SELECT door_locked FROM rp_furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerLockFurnitureDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }
            else if ((id = GetNearbyLand(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[id][lID])
            {
                DBFormat("SELECT door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                DBExecute("OnPlayerLockLandDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
                return 1;
            }
        }
    }

    if ((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID)
    {
        if (!VehicleInfo[id][vLocked])
        {
            VehicleInfo[id][vLocked] = 1;
            GameTextForPlayer(playerid, "~r~Vehicle locked", 3000, 6);
        }
        else
        {
            VehicleInfo[id][vLocked] = 0;
            GameTextForPlayer(playerid, "~g~Vehicle unlocked", 3000, 6);
        }

        SetVehicleParams(id, VEHICLE_DOORS, VehicleInfo[id][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[id][vLocked], VehicleInfo[id][vID]);

        return 1;
    }
    else if ((id = GetNearbyHouseEx(playerid)) >= 0)
    {
        if (!HouseInfo[id][hLocked])
        {
            HouseInfo[id][hLocked] = 1;
            GameTextForPlayer(playerid, "~r~House locked", 3000, 6);
        }
        else
        {
            HouseInfo[id][hLocked] = 0;
            GameTextForPlayer(playerid, "~g~House unlocked", 3000, 6);
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[id][hLocked], HouseInfo[id][hID]);

        return 1;
    }
    else if ((id = GetNearbyGarageEx(playerid)) >= 0)
    {
        if (!GarageInfo[id][gLocked])
        {
            GarageInfo[id][gLocked] = 1;
            GameTextForPlayer(playerid, "~r~Garage locked", 3000, 6);
        }
        else
        {
            GarageInfo[id][gLocked] = 0;
            GameTextForPlayer(playerid, "~g~Garage unlocked", 3000, 6);
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[id][gLocked], GarageInfo[id][gID]);

        return 1;
    }
    else if ((id = GetNearbyBusinessEx(playerid)) >= 0)
    {
        if (!BusinessInfo[id][bLocked])
        {
            BusinessInfo[id][bLocked] = 1;
            GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
        }
        else
        {
            BusinessInfo[id][bLocked] = 0;
            GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);

        return 1;
    }
    else if ((id = GetNearbyEntranceEx(playerid)) >= 0)
    {
        if (!EntranceInfo[id][eLocked])
        {
            EntranceInfo[id][eLocked] = 1;
            GameTextForPlayer(playerid, "~r~Entrance locked", 3000, 6);
        }
        else
        {
            EntranceInfo[id][eLocked] = 0;
            GameTextForPlayer(playerid, "~g~Entrance unlocked", 3000, 6);
        }

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

        DBQuery("UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[id][eLocked], EntranceInfo[id][eID]);

        return 1;
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not close to anything which you can lock.");

    return 1;
}
