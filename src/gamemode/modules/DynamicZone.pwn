/// @file      DynamicZone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-10-07 12:50:24 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MAX_DYNAMIC_ZONES 30

enum eDynamicZone
{
    bool:DZ_Exists,
    DZ_Id,
    ZoneType:DZ_Type,
    bool:DZ_Enabled,
    bool:DZ_Map,
    Float:DZ_MinX,
    Float:DZ_MinY,
    Float:DZ_MaxX,
    Float:DZ_MaxY,
    DZ_GangZone
};

static DynamicZone[MAX_DYNAMIC_ZONES][eDynamicZone];

hook OnLoadDatabase(timestamp)
{
    DBQueryWithCallback("SELECT * FROM dynamic_zones", "OnLoadDynamicZones");
    return 1;
}

DB:OnLoadDynamicZones()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_DYNAMIC_ZONES; i ++)
    {
        DynamicZone[i][DZ_Id]       = GetDBIntField(i, "id");
        DynamicZone[i][DZ_Map]      = GetDBBoolField(i,  "map");
        DynamicZone[i][DZ_Type]     = ZoneType:GetDBIntField(i, "type");
        DynamicZone[i][DZ_MinX]     = GetDBFloatField(i, "min_x");
        DynamicZone[i][DZ_MinY]     = GetDBFloatField(i, "min_y");
        DynamicZone[i][DZ_MaxX]     = GetDBFloatField(i, "max_x");
        DynamicZone[i][DZ_MaxY]     = GetDBFloatField(i, "max_y");
        DynamicZone[i][DZ_Enabled]  = GetDBBoolField(i,  "enabled");
        DynamicZone[i][DZ_GangZone] = -1;
        DynamicZone[i][DZ_Exists]   = true;
        ReloadDynamicZone(i);
    }
    printf("[Script] %i dynamic zones loaded.", rows);
}

hook OnLoadPlayer(playerid, row)
{
    ShowDynamicZoneOnMap(playerid, true);
}

hook OnConfirmZoneCreation(playerid, ZoneType:type, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
    {
        return 1;
    }
    if (type != ZoneType_GreenZone && type != ZoneType_ToxicZone && type != ZoneType_DangerZone)
    {
        return 1;
    }
    CreateDynamicZone(playerid, type, minx, miny, maxx, maxy, true);
    return 1;
}

GetDynamicZoneColor(zoneid)
{
    switch (DynamicZone[zoneid][DZ_Type])
    {
        case ZoneType_Turf:       return 0x000000AA;
        case ZoneType_Land:       return COLOR_LAND;
        case ZoneType_GreenZone:  return 0x0088007F;
        case ZoneType_ToxicZone:  return 0xFF7F007F;
        case ZoneType_DangerZone: return 0xFF00007F;
    }
    return -1;
}

ShowDynamicZoneOnMap(playerid, enable)
{
    for (new i = 0; i < MAX_DYNAMIC_ZONES; i++)
    {
        if (!DynamicZone[i][DZ_Exists] || !DynamicZone[i][DZ_Map])
        {
            continue;
        }
        if (!enable)
        {
            GangZoneHideForPlayer(playerid, DynamicZone[i][DZ_GangZone]);
        }
        else
        {
            GangZoneShowForPlayer(playerid, DynamicZone[i][DZ_GangZone], GetDynamicZoneColor(i));
        }
    }
}

CreateDynamicZone(playerid, ZoneType:type, Float:minx, Float:miny, Float:maxx, Float:maxy, bool:map)
{
    for (new i = 0; i < MAX_DYNAMIC_ZONES; i++)
    {
        if (!DynamicZone[i][DZ_Exists])
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);

            DBFormat("INSERT INTO dynamic_zones (enabled, type, min_x, min_y, max_x, max_y, map)"\
                     " VALUES(1, %i, '%.4f', '%.4f', '%.4f', '%.4f', %i)",
                     _:type, minx, miny, maxx, maxy, map);
            DBExecute("OnCreateDynamicZone", "iiiffff", playerid, i, _:type, minx, miny, maxx, maxy, map);
            return 1;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "Land slots are currently full. Ask developers to increase the internal limit.");
    return 0;
}

DB:OnCreateDynamicZone(playerid, zoneid, ZoneType:type, Float:minx, Float:miny, Float:maxx, Float:maxy, bool:map)
{
    DynamicZone[zoneid][DZ_Exists] = true;
    DynamicZone[zoneid][DZ_Id] = GetDBInsertID();
    DynamicZone[zoneid][DZ_Type] = type;
    DynamicZone[zoneid][DZ_Enabled] = true;
    DynamicZone[zoneid][DZ_Map] = true;
    DynamicZone[zoneid][DZ_MinX] = minx;
    DynamicZone[zoneid][DZ_MinY] = miny;
    DynamicZone[zoneid][DZ_MaxX] = maxx;
    DynamicZone[zoneid][DZ_MaxY] = maxy;
    ReloadDynamicZone(zoneid);
}

ReloadDynamicZone(zoneid)
{
    if (DynamicZone[zoneid][DZ_GangZone] >= 0)
    {
        GangZoneDestroy(DynamicZone[zoneid][DZ_GangZone]);
    }
    if (DynamicZone[zoneid][DZ_Map])
    {
        DynamicZone[zoneid][DZ_GangZone] = GangZoneCreate(DynamicZone[zoneid][DZ_MinX], DynamicZone[zoneid][DZ_MinY],
                                                          DynamicZone[zoneid][DZ_MaxX], DynamicZone[zoneid][DZ_MaxY]);
    }
    else
    {
        DynamicZone[zoneid][DZ_GangZone] = -1;
    }

    foreach(new i : Player)
    {
        ShowDynamicZoneOnMap(i, true);
    }
}

stock GetNearByDynamicZone(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for (new i = 0; i < MAX_DYNAMIC_ZONES; i++)
    {
        if (!DynamicZone[i][DZ_Exists])
        {
            continue;
        }
        new Float:minx = DynamicZone[zoneid][DZ_MinX];
        new Float:miny = DynamicZone[zoneid][DZ_MinY];
        new Float:maxx = DynamicZone[zoneid][DZ_MaxX];
        new Float:maxy = DynamicZone[zoneid][DZ_MaxY];
        if (minx > maxx)
        {
            minx = DynamicZone[zoneid][DZ_MaxX];
            maxx = DynamicZone[zoneid][DZ_MinX];
        }
        if (miny > maxy)
        {
            miny = DynamicZone[zoneid][DZ_MaxY];
            maxy = DynamicZone[zoneid][DZ_MinY];
        }
        if (DynamicZone[i][DZ_Exists] && minx <= x <= maxx && miny <= y <= maxy)
        {
            return i;
        }
    }
    return -1;
}

IsPlayerInsideGreenZone(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (IsPlayerInRangeOfPoint(playerid, 100.0, 1201.0815, -1323.8598, 13.0767) ||  // Allsaints
        IsPlayerInRangeOfPoint(playerid, 100.0, 1529.6000,-1691.2000,13.3828)   ||  // LSPD
        IsPlayerInRangeOfPoint(playerid, 100.0, 2036.6906,-1408.4742,17.1641)   ||  // County hospital
        IsPlayerInRangeOfPoint(playerid, 100.0, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]))// Spawn
    {
        return true;
    }

    for (new i = 0; i < MAX_DYNAMIC_ZONES; i++)
    {
        if (!DynamicZone[i][DZ_Exists] || DynamicZone[i][DZ_Type] != ZoneType_GreenZone)
        {
            continue;
        }

        new Float:minx = DynamicZone[i][DZ_MinX];
        new Float:miny = DynamicZone[i][DZ_MinY];
        new Float:maxx = DynamicZone[i][DZ_MaxX];
        new Float:maxy = DynamicZone[i][DZ_MaxY];
        if (minx > maxx)
        {
            minx = DynamicZone[i][DZ_MaxX];
            maxx = DynamicZone[i][DZ_MinX];
        }
        if (miny > maxy)
        {
            miny = DynamicZone[i][DZ_MaxY];
            maxy = DynamicZone[i][DZ_MinY];
        }
        if (DynamicZone[i][DZ_Exists] && minx <= x <= maxx && miny <= y <= maxy)
        {
            return true;
        }
    }
    return false;
}

CMD:createzone(playerid, params[])
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    new type, map;
    if (sscanf(params, "ii", type, map))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createzone [type]");
        return SendClientMessage(playerid, COLOR_SYNTAX, "Type: GreenZone (1), ToxicZone (2), DangerZone (3)");
    }
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot create zone indoors.");
    }

    switch (type)
    {
        case 1: SetPlayerCreatingZone(playerid, ZoneType_GreenZone);
        case 2: SetPlayerCreatingZone(playerid, ZoneType_ToxicZone);
        case 3: SetPlayerCreatingZone(playerid, ZoneType_DangerZone);
    }
    return 1;
}

CMD:removezone(playerid, params[])
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    new id;
    if (sscanf(params, "i", id) || id < 0 || id >= MAX_DYNAMIC_ZONES)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removezone [id]");
    }
    if (!DynamicZone[id][DZ_Exists])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid zoneid");
    }

    DBQuery("DELETE FROM dynamic_zones WHERE id = %i", DynamicZone[id][DZ_Id]);
    DynamicZone[id][DZ_Id] = 0;
    DynamicZone[id][DZ_Exists] = false;
    GangZoneDestroy(DynamicZone[id][DZ_GangZone]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed zone %i.", id);
    return 1;
}

CMD:editzone(playerid, params[])
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    new id, option[32], value;
    if (sscanf(params, "isi(-1)", id, option, value) || id < 0 || id >= MAX_DYNAMIC_ZONES)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editzone [id] [option] [value]");
        return SendClientMessage(playerid, COLOR_SYNTAX, "OPTIONS: type, map");
    }

    if (!DynamicZone[id][DZ_Exists])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid zoneid");
    }

    if (!strcmp(option, "type", true))
    {
        if (value < 1 || value > 3)
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editzone [id] type [value]");
            return SendClientMessage(playerid, COLOR_SYNTAX, "Value: GreenZone (1), ToxicZone (2), DangerZone (3)");
        }
        switch (value)
        {
            case 1: DynamicZone[id][DZ_Type] = ZoneType_GreenZone;
            case 2: DynamicZone[id][DZ_Type] = ZoneType_ToxicZone;
            case 3: DynamicZone[id][DZ_Type] = ZoneType_DangerZone;
            default: return 1;
        }
        DBQuery("UPDATE dynamic_zones set type = %i WHERE id = %i",
                _:DynamicZone[id][DZ_Type], DynamicZone[id][DZ_Id]);
        ReloadDynamicZone(id);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You set zone %i's type to %i.",
                            id, ZoneTypeToString(DynamicZone[id][DZ_Type]));
        return 1;
    }

    if (!strcmp(option, "map", true))
    {
        if (value < 0 || value > 1)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editzone [id] type [0-1]");
        }

        DynamicZone[id][DZ_Map] = (value == 1);
        DBQuery("UPDATE dynamic_zones set map = %i WHERE id = %i",
                DynamicZone[id][DZ_Map], DynamicZone[id][DZ_Id]);
        ReloadDynamicZone(id);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You set zone %i's map to %i.", id, value);
        return 1;
    }
    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editzone [id] type [value]");
    return SendClientMessage(playerid, COLOR_SYNTAX, "Value: GreenZone (1), ToxicZone (2), DangerZone (3)");
}
