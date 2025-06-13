/// @file      Entrance.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


GetNearbyEntranceEx(playerid)
{
    return GetNearbyEntrance(playerid) == -1 ? GetInsideEntrance(playerid) : GetNearbyEntrance(playerid);
}

GetNearbyEntrance(playerid)
{
    foreach(new i : Entrance)
    {
        if (EntranceInfo[i][eExists] && IsPlayerInRangeOfPoint(playerid, EntranceInfo[i][eRadius], EntranceInfo[i][ePosX], EntranceInfo[i][ePosY], EntranceInfo[i][ePosZ]) && GetPlayerInterior(playerid) == EntranceInfo[i][eOutsideInt] && GetPlayerVirtualWorld(playerid) == EntranceInfo[i][eOutsideVW])
        {
            return i;
        }
    }

    return -1;
}

RemoveEntrance(entranceid)
{
    DestroyDynamic3DTextLabel(EntranceInfo[entranceid][eText]);
    DestroyDynamicPickup(EntranceInfo[entranceid][ePickup]);

    DBQuery("DELETE FROM entrances WHERE id = %i", EntranceInfo[entranceid][eID]);

    EntranceInfo[entranceid][eExists] = 0;
    EntranceInfo[entranceid][eID] = 0;
    EntranceInfo[entranceid][eOwnerID] = 0;
    Iter_Remove(Entrance, entranceid);
}

GetInsideEntrance(playerid)
{
    foreach(new i : Entrance)
    {
        if (EntranceInfo[i][eExists] &&
            IsPlayerInRangeOfPoint(playerid, 100.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]) &&
            GetPlayerInterior(playerid) == EntranceInfo[i][eInterior] &&
            GetPlayerVirtualWorld(playerid) == EntranceInfo[i][eWorld])
        {
            return i;
        }
    }

    return -1;
}

SetEntranceOwner(entranceid, playerid)
{
    if (playerid == INVALID_PLAYER_ID)
    {
        strcpy(EntranceInfo[entranceid][eOwner], "Nobody", MAX_PLAYER_NAME);
        EntranceInfo[entranceid][eOwnerID] = 0;
    }
    else
    {
        GetPlayerName(playerid, EntranceInfo[entranceid][eOwner], MAX_PLAYER_NAME);
        EntranceInfo[entranceid][eOwnerID] = PlayerData[playerid][pID];
    }
    DBQuery("UPDATE entrances SET ownerid = %i, owner = '%e' WHERE id = %i", EntranceInfo[entranceid][eOwnerID], EntranceInfo[entranceid][eOwner], EntranceInfo[entranceid][eID]);
    ReloadEntrance(entranceid);
}

ReloadEntrance(entranceid)
{
    if (EntranceInfo[entranceid][eExists])
    {
        new
            string[128];

        DestroyDynamic3DTextLabel(EntranceInfo[entranceid][eText]);
        DestroyDynamicPickup(EntranceInfo[entranceid][ePickup]);
        DestroyDynamicMapIcon(EntranceInfo[entranceid][eMapIconID]);

        if (EntranceInfo[entranceid][eLabel])
        {
            new color;
            if (EntranceInfo[entranceid][eColor] == -256)
            {
                color = 0xC8C8C8FF;
                color = EntranceInfo[entranceid][eColor];
            }
            else
            {
                color = EntranceInfo[entranceid][eColor];
            }
            if (EntranceInfo[entranceid][eOwnerID])
            {
                format(string, sizeof(string), "{ffff00}[{%06x}%s{ffff00}]{afafaf}\nOwner: %s\nPress 'y' to go inside.", color >>> 8, EntranceInfo[entranceid][eName], EntranceInfo[entranceid][eOwner]);
            }
            else
            {
                if (EntranceInfo[entranceid][eType] == 1)
                    format(string, sizeof(string), "%s\n{AFAFAF}/offerduel to duel.", EntranceInfo[entranceid][eName]);
                else if (EntranceInfo[entranceid][eType] == 2)
                    format(string, sizeof(string), "%s\n{AFAFAF}/repaircar to repair your vehicle.", EntranceInfo[entranceid][eName]);
                else
                    format(string, sizeof(string), "{ffff00}[{%06x}%s{ffff00}]\n{AFAFAF}Press 'y' to go inside.", color >>> 8, EntranceInfo[entranceid][eName]);
            }

            EntranceInfo[entranceid][eText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], (EntranceInfo[entranceid][eIcon] == 19902) ? (EntranceInfo[entranceid][ePosZ] + 0.1) : (EntranceInfo[entranceid][ePosZ]), 10.0, .worldid = EntranceInfo[entranceid][eOutsideVW], .interiorid = EntranceInfo[entranceid][eOutsideInt]);

        }

        EntranceInfo[entranceid][ePickup] = CreateDynamicPickup(EntranceInfo[entranceid][eIcon], 1, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], (EntranceInfo[entranceid][eIcon] == 19902) ? (EntranceInfo[entranceid][ePosZ] - 1.0) : (EntranceInfo[entranceid][ePosZ]), .worldid = EntranceInfo[entranceid][eOutsideVW], .interiorid = EntranceInfo[entranceid][eOutsideInt]);

        if (EntranceInfo[entranceid][eMapIcon])
        {
            EntranceInfo[entranceid][eMapIconID] = CreateDynamicMapIcon(EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], EntranceInfo[entranceid][eMapIcon], 0, .worldid = EntranceInfo[entranceid][eOutsideVW], .interiorid = EntranceInfo[entranceid][eOutsideInt]);
        }
    }
}

IsEntranceOwner(playerid, entranceid)
{
    return (EntranceInfo[entranceid][eOwnerID] == PlayerData[playerid][pID]);
}


DB:OnAdminCreateEntrance(playerid, entranceid, name[], Float:x, Float:y, Float:z, Float:angle)
{
    strcpy(EntranceInfo[entranceid][eOwner], "Nobody", MAX_PLAYER_NAME);
    strcpy(EntranceInfo[entranceid][eName], name, 40);
    strcpy(EntranceInfo[entranceid][ePassword], "None", 64);

    EntranceInfo[entranceid][eExists] = 1;
    EntranceInfo[entranceid][eID] = GetDBInsertID();
    EntranceInfo[entranceid][eOwnerID] = 0;
    EntranceInfo[entranceid][eIcon] = 19132;
    EntranceInfo[entranceid][eLocked] = 0;
    EntranceInfo[entranceid][eRadius] = 3.0;
    EntranceInfo[entranceid][ePosX] = x;
    EntranceInfo[entranceid][ePosY] = y;
    EntranceInfo[entranceid][ePosZ] = z;
    EntranceInfo[entranceid][ePosA] = angle;
    EntranceInfo[entranceid][eIntX] = 0.0;
    EntranceInfo[entranceid][eIntY] = 0.0;
    EntranceInfo[entranceid][eIntZ] = 0.0;
    EntranceInfo[entranceid][eIntA] = 0.0;
    EntranceInfo[entranceid][eInterior] = 0;
    EntranceInfo[entranceid][eWorld] = EntranceInfo[entranceid][eID] + 4000000;
    EntranceInfo[entranceid][eOutsideInt] = GetPlayerInterior(playerid);
    EntranceInfo[entranceid][eOutsideVW] = GetPlayerVirtualWorld(playerid);
    EntranceInfo[entranceid][eAdminLevel] = 0;
    EntranceInfo[entranceid][eFaction] = -1;
    EntranceInfo[entranceid][eGang] = -1;
    EntranceInfo[entranceid][eVIP] = 0;
    EntranceInfo[entranceid][eVehicles] = 0;
    EntranceInfo[entranceid][eFreeze] = 0;
    EntranceInfo[entranceid][eLabel] = 1;
    EntranceInfo[entranceid][eType] = 0;
    EntranceInfo[entranceid][eMapIcon] = 0;
    EntranceInfo[entranceid][eText] = Text3D:INVALID_3DTEXT_ID;
    EntranceInfo[entranceid][ePickup] = -1;
    EntranceInfo[entranceid][eMapIconID] = -1;
    EntranceInfo[entranceid][eColor] = -256;
    Iter_Add(Entrance, entranceid);

    DBQuery("UPDATE entrances SET world = %i WHERE id = %i", EntranceInfo[entranceid][eWorld], EntranceInfo[entranceid][eID]);

    ReloadEntrance(entranceid);
    SendClientMessageEx(playerid, COLOR_GREEN, "* Entrance %i created successfully.", entranceid);
}

DB:OnAdminCreateGangHQ(playerid, entranceid, gangid, Float:x, Float:y, Float:z, Float:angle, Float:ix, Float:iy, Float:iz, Float:ia, interior, vw)
{
    strcpy(EntranceInfo[entranceid][eOwner], "Nobody", MAX_PLAYER_NAME);
    strcpy(EntranceInfo[entranceid][eName], GangInfo[gangid][gName], 40);
    strcpy(EntranceInfo[entranceid][ePassword], "None", 64);

    EntranceInfo[entranceid][eExists] = 1;
    EntranceInfo[entranceid][eID] = GetDBInsertID();
    EntranceInfo[entranceid][eOwnerID] = 0;
    EntranceInfo[entranceid][eIcon] = 19132;
    EntranceInfo[entranceid][eLocked] = 0;
    EntranceInfo[entranceid][eRadius] = 3.0;
    EntranceInfo[entranceid][ePosX] = x;
    EntranceInfo[entranceid][ePosY] = y;
    EntranceInfo[entranceid][ePosZ] = z;
    EntranceInfo[entranceid][ePosA] = angle;
    EntranceInfo[entranceid][eIntX] = ix;
    EntranceInfo[entranceid][eIntY] = iy;
    EntranceInfo[entranceid][eIntZ] = iz;
    EntranceInfo[entranceid][eIntA] = ia;
    EntranceInfo[entranceid][eInterior] = interior;
    EntranceInfo[entranceid][eWorld] = vw;
    EntranceInfo[entranceid][eOutsideInt] = GetPlayerInterior(playerid);
    EntranceInfo[entranceid][eOutsideVW] = GetPlayerVirtualWorld(playerid);
    EntranceInfo[entranceid][eAdminLevel] = 0;
    EntranceInfo[entranceid][eFaction] = -1;
    EntranceInfo[entranceid][eGang] = gangid;
    EntranceInfo[entranceid][eVIP] = 0;
    EntranceInfo[entranceid][eVehicles] = 0;
    EntranceInfo[entranceid][eFreeze] = 0;
    EntranceInfo[entranceid][eLabel] = 1;
    EntranceInfo[entranceid][eType] = 0;
    EntranceInfo[entranceid][eMapIcon] = 0;
    EntranceInfo[entranceid][eText] = Text3D:INVALID_3DTEXT_ID;
    EntranceInfo[entranceid][ePickup] = -1;
    EntranceInfo[entranceid][eMapIconID] = -1;
    EntranceInfo[entranceid][eColor] = -256;
    Iter_Add(Entrance, entranceid);

    ReloadEntrance(entranceid);
    SendClientMessageEx(playerid, COLOR_GREEN, "* GangHQ created successfully.");
}

DB:OnLoadEntrances()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_ENTRANCES; i ++)
    {
        GetDBStringField(i, "owner", EntranceInfo[i][eOwner], MAX_PLAYER_NAME);
        GetDBStringField(i, "name", EntranceInfo[i][eName], 40);
        GetDBStringField(i, "password", EntranceInfo[i][ePassword], 64);

        EntranceInfo[i][eID] = GetDBIntField(i, "id");
        EntranceInfo[i][eOwnerID] = GetDBIntField(i, "ownerid");
        EntranceInfo[i][eIcon] = GetDBIntField(i, "iconid");
        EntranceInfo[i][eLocked] = GetDBIntField(i, "locked");
        EntranceInfo[i][eRadius] = GetDBFloatField(i, "radius");
        EntranceInfo[i][ePosX] = GetDBFloatField(i, "pos_x");
        EntranceInfo[i][ePosY] = GetDBFloatField(i, "pos_y");
        EntranceInfo[i][ePosZ] = GetDBFloatField(i, "pos_z");
        EntranceInfo[i][ePosA] = GetDBFloatField(i, "pos_a");
        EntranceInfo[i][eIntX] = GetDBFloatField(i, "int_x");
        EntranceInfo[i][eIntY] = GetDBFloatField(i, "int_y");
        EntranceInfo[i][eIntZ] = GetDBFloatField(i, "int_z");
        EntranceInfo[i][eIntA] = GetDBFloatField(i, "int_a");
        EntranceInfo[i][eInterior] = GetDBIntField(i, "interior");
        EntranceInfo[i][eWorld] = GetDBIntField(i, "world");
        EntranceInfo[i][eOutsideInt] = GetDBIntField(i, "outsideint");
        EntranceInfo[i][eOutsideVW] = GetDBIntField(i, "outsidevw");
        EntranceInfo[i][eAdminLevel] = GetDBIntField(i, "adminlevel");
        EntranceInfo[i][eFaction] = GetDBIntField(i, "faction");
        EntranceInfo[i][eGang] = GetDBIntField(i, "gang");
        EntranceInfo[i][eVIP] = GetDBIntField(i, "vip");
        EntranceInfo[i][eVehicles] = GetDBIntField(i, "vehicles");
        EntranceInfo[i][eFreeze] = GetDBIntField(i, "freeze");
        EntranceInfo[i][eLabel] = GetDBIntField(i, "label");
        EntranceInfo[i][eType] = GetDBIntField(i, "type");
        EntranceInfo[i][eMapIcon] = GetDBIntField(i, "mapicon");
        EntranceInfo[i][eColor] = GetDBIntField(i, "color");
        EntranceInfo[i][eText] = Text3D:INVALID_3DTEXT_ID;
        EntranceInfo[i][ePickup] = -1;
        EntranceInfo[i][eMapIconID] = -1;
        EntranceInfo[i][eExists] = 1;
        Iter_Add(Entrance, i);

        ReloadEntrance(i);
    }

    printf("[Script] %i entrances loaded.", rows);
}

CMD:createentrance(playerid, params[])
{
    new name[40], Float:x, Float:y, Float:z, Float:a;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[40]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createentrance [name]");
    }
    if (GetNearbyEntrance(playerid) >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is an entrance in range. Find somewhere else to create this one.");
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    for (new i = 0; i < MAX_ENTRANCES; i ++)
    {
        if (!EntranceInfo[i][eExists])
        {
            DBFormat("INSERT INTO entrances (name, pos_x, pos_y, pos_z, pos_a, outsideint, outsidevw) VALUES('%e', '%f', '%f', '%f', '%f', %i, %i)", name, x, y, z, a - 180.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            DBExecute("OnAdminCreateEntrance", "iisffff", playerid, i, name, x, y, z, a);

            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Entrance slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

IsValidEntrance(entranceid)
{
    return ((0 <= entranceid < MAX_ENTRANCES) && EntranceInfo[entranceid][eExists]);
}

CMD:editentrance(playerid, params[])
{
    new entranceid, option[14], param[64];

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[14]S()[64]", entranceid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Exterior, Interior, Name, Icon, World, Owner, Locked, Radius, AdminLevel");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Faction, Gang, VIP, Vehicles, Freeze, Label, Password, Type, MapIcon, Color");
        return 1;
    }
    if (!IsValidEntrance(entranceid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid entrance.");
    }

    if (!strcmp(option, "exterior", true))
    {
        GetPlayerPos(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]);
        GetPlayerFacingAngle(playerid, EntranceInfo[entranceid][ePosA]);

        EntranceInfo[entranceid][eOutsideInt] = GetPlayerInterior(playerid);
        EntranceInfo[entranceid][eOutsideVW] = GetPlayerVirtualWorld(playerid);

        DBQuery("UPDATE entrances SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], EntranceInfo[entranceid][ePosA], EntranceInfo[entranceid][eOutsideInt], EntranceInfo[entranceid][eOutsideVW], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the exterior of entrance %i.", entranceid);
    }
    else if (!strcmp(option, "interior", true))
    {
        GetPlayerPos(playerid, EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ]);
        GetPlayerFacingAngle(playerid, EntranceInfo[entranceid][eIntA]);

        EntranceInfo[entranceid][eInterior] = GetPlayerInterior(playerid);

        DBQuery("UPDATE entrances SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ], EntranceInfo[entranceid][eIntA], EntranceInfo[entranceid][eInterior], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the interior of entrance %i.", entranceid);
    }
    else if (!strcmp(option, "name", true))
    {
        new name[32];

        if (sscanf(param, "s[32]", name))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [name] [text]");
        }

        strcpy(EntranceInfo[entranceid][eName], name, 32);

        DBQuery("UPDATE entrances SET name = '%e' WHERE id = %i", EntranceInfo[entranceid][eName], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the name of entrance %i to '%s'.", entranceid, name);
    }
    else if (!strcmp(option, "icon", true))
    {
        new iconid;

        if (sscanf(param, "i", iconid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [icon] [iconid (19300 = hide)]");
        }
        if (!IsValidModel(iconid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID.");
        }

        EntranceInfo[entranceid][eIcon] = iconid;

        DBQuery("UPDATE entrances SET iconid = %i WHERE id = %i", EntranceInfo[entranceid][eIcon], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the pickup icon model of entrance %i to %i.", entranceid, iconid);
    }
    else if (!strcmp(option, "world", true))
    {
        new worldid;

        if (sscanf(param, "i", worldid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [world] [vw]");
        }

        EntranceInfo[entranceid][eWorld] = worldid;

        DBQuery("UPDATE entrances SET world = %i WHERE id = %i", EntranceInfo[entranceid][eWorld], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the virtual world of entrance %i to %i.", entranceid, worldid);
    }
    else if (!strcmp(option, "owner", true))
    {
        new targetid;

        if (!isnull(param) && !strcmp(param, "none", true))
        {
            SetEntranceOwner(entranceid, INVALID_PLAYER_ID);
            return SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the owner of entrance %i.", entranceid);
        }
        if (sscanf(param, "u", targetid))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [owner] [playerid/none]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (!PlayerData[targetid][pLogged])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
        }

        SetEntranceOwner(entranceid, targetid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of entrance %i to %s.", entranceid, GetRPName(targetid));
    }
    else if (!strcmp(option, "locked", true))
    {
        new locked;

        if (sscanf(param, "i", locked) || !(0 <= locked <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [locked] [0/1]");
        }

        EntranceInfo[entranceid][eLocked] = locked;

        DBQuery("UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[entranceid][eLocked], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of entrance %i to %i.", entranceid, locked);
    }
    else if (!strcmp(option, "radius", true))
    {
        new Float:radius;

        if (sscanf(param, "f", radius))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [radius] [range]");
        }
        if (!(1.0 <= radius <= 20.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The entry radius must range between 1.0 and 20.0.");
        }

        EntranceInfo[entranceid][eRadius] = radius;

        DBQuery("UPDATE entrances SET radius = '%f' WHERE id = %i", EntranceInfo[entranceid][eRadius], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entry radius of entrance %i to %.1f.", entranceid, radius);
    }
    else if (!strcmp(option, "adminlevel", true))
    {
        new level;

        if (sscanf(param, "i", level))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [adminlevel] [level]");
        }
        if (!(0 <= level <= 7))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 7.");
        }

        EntranceInfo[entranceid][eAdminLevel] = level;

        DBQuery("UPDATE entrances SET adminlevel = %i WHERE id = %i", EntranceInfo[entranceid][eAdminLevel], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the admin level of entrance %i to %i.", entranceid, level);
    }
    else if (!strcmp(option, "faction", true))
    {
        new factionid;

        if (sscanf(param, "i", factionid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [faction] [factionid (-1 = none)]");
            return 1;
        }
        if ( (factionid != -1) && (!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction id.");
        }
        EntranceInfo[entranceid][eFaction] = factionid;

        DBQuery("UPDATE entrances SET faction = %i WHERE id = %i", EntranceInfo[entranceid][eFaction], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);

        if (factionid == -1)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the faction type of entrance %i.", entranceid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the faction type of entrance %i to %s (%i).", entranceid, FactionInfo[factionid][fName], factionid);
    }
    else if (!strcmp(option, "gang", true))
    {
        new gangid;

        if (sscanf(param, "i", gangid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [gang] [gangid]");
        }
        if (!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
        }

        EntranceInfo[entranceid][eGang] = gangid;

        DBQuery("UPDATE entrances SET gang = %i WHERE id = %i", EntranceInfo[entranceid][eGang], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);

        if (gangid == -1)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the gang of entrance %i.", entranceid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the gang of entrance %i to %s (%i).", entranceid, GangInfo[gangid][gName], gangid);
    }
    else if (!strcmp(option, "vip", true))
    {
        new rankid;

        if (sscanf(param, "i", rankid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [vip] [rankid]");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of ranks: (0) None (1) Silver (2) Gold (3) Legendary");
            return 1;
        }
        if (!(0 <= rankid <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid VIP rank.");
        }

        EntranceInfo[entranceid][eVIP] = rankid;

        DBQuery("UPDATE entrances SET vip = %i WHERE id = %i", EntranceInfo[entranceid][eVIP], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the VIP rank of entrance %i to {D909D9}%s{33CCFF} (%i).", entranceid, GetVIPRank(rankid), rankid);
    }
    else if (!strcmp(option, "vehicles", true))
    {
        new status;

        if (sscanf(param, "i", status) || !(0 <= status <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [vehicles] [0/1]");
        }

        EntranceInfo[entranceid][eVehicles] = status;

        DBQuery("UPDATE entrances SET vehicles = %i WHERE id = %i", EntranceInfo[entranceid][eVehicles], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);

        if (status)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've allowed vehicle entry for entrance %i.", entranceid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've disallowed vehicle entry for entrance %i.", entranceid);
    }
    else if (!strcmp(option, "freeze", true))
    {
        new status;

        if (sscanf(param, "i", status) || !(0 <= status <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [freeze] [0/1]");
        }

        EntranceInfo[entranceid][eFreeze] = status;

        DBQuery("UPDATE entrances SET freeze = %i WHERE id = %i", EntranceInfo[entranceid][eFreeze], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);

        if (status)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled freeze & object loading for entrance %i.", entranceid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled freeze & object loading for entrance %i.", entranceid);
    }
    else if (!strcmp(option, "label", true))
    {
        new status;

        if (sscanf(param, "i", status) || !(0 <= status <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [label] [0/1]");
        }

        EntranceInfo[entranceid][eLabel] = status;

        DBQuery("UPDATE entrances SET label = %i WHERE id = %i", EntranceInfo[entranceid][eLabel], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);

        if (status)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled the 3D text label for entrance %i.", entranceid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled the 3D text label for entrance %i.", entranceid);
    }
    else if (!strcmp(option, "password", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [password] [text ('none' to reset)]");
        }

        strcpy(EntranceInfo[entranceid][ePassword], param, 64);

        DBQuery("UPDATE entrances SET password = '%e' WHERE id = %i", EntranceInfo[entranceid][ePassword], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the password of entrance %i to '%s'.", entranceid, param);
    }
    else if (!strcmp(option, "type", true))
    {
        new type;

        if (sscanf(param, "i", type))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [type] [type id]");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (0) None (1) Duel Arena (2) Repair");
            return 1;
        }
        if (!(0 <= type <= 2))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
        }

        EntranceInfo[entranceid][eType] = type;

        if (type == 1)
        {
            EntranceInfo[entranceid][eIntX] = 1419.6472;
            EntranceInfo[entranceid][eIntY] = 4.0132;
            EntranceInfo[entranceid][eIntZ] = 1002.3906;
            EntranceInfo[entranceid][eIntA] = 90.0000;
            EntranceInfo[entranceid][eInterior] = 1;

            DBQuery("UPDATE entrances SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, type = %i WHERE id = %i", EntranceInfo[entranceid][eIntX], EntranceInfo[entranceid][eIntY], EntranceInfo[entranceid][eIntZ], EntranceInfo[entranceid][eIntA], EntranceInfo[entranceid][eInterior], EntranceInfo[entranceid][eType], EntranceInfo[entranceid][eID]);

        }
        else
        {
            DBQuery("UPDATE entrances SET type = %i WHERE id = %i", EntranceInfo[entranceid][eType], EntranceInfo[entranceid][eID]);

        }

        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the special type for entrance %i to %i.", entranceid, type);
    }
    else if (!strcmp(option, "mapicon", true))
    {
        new type;

        if (sscanf(param, "i", type))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [mapicon] [type (0-63)]");
        }
        if (!(0 <= type <= 63))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid map icon.");
        }

        EntranceInfo[entranceid][eMapIcon] = type;

        DBQuery("UPDATE entrances SET mapicon = %i WHERE id = %i", EntranceInfo[entranceid][eMapIcon], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map icon of entrance %i to %i.", entranceid, type);
    }
    else if (!strcmp(option, "color", true))
    {
        new color;

        if (sscanf(param, "h", color))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editentrance [entranceid] [color] [0xRRGGBBAA]");
        }

        EntranceInfo[entranceid][eColor] = (color & ~0xFF) | 0xFF;

        DBQuery("UPDATE entrances SET color = %i WHERE id = %i", EntranceInfo[entranceid][eColor], EntranceInfo[entranceid][eID]);


        ReloadEntrance(entranceid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the {%06x}color{33CCFF} of entrance ID %i.", color >>> 8, entranceid);
    }

    return 1;
}

CMD:removeentrance(playerid, params[])
{
    new entranceid;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", entranceid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeentrance [entranceid]");
    }
    if (!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid entrance.");
    }

    RemoveEntrance(entranceid);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed entrance %i.", entranceid);
    return 1;
}

GotoEntrance(playerid, entranceid)
{
    SetPlayerPos(playerid, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ]);
    SetPlayerFacingAngle(playerid, EntranceInfo[entranceid][ePosA]);
    SetPlayerInterior(playerid, EntranceInfo[entranceid][eOutsideInt]);
    SetPlayerVirtualWorld(playerid, EntranceInfo[entranceid][eOutsideVW]);
    SetCameraBehindPlayer(playerid);
}

CMD:gotoentrance(playerid, params[])
{
    new entranceid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", entranceid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoentrance [entranceid]");
    }
    if (!(0 <= entranceid < MAX_ENTRANCES) || !EntranceInfo[entranceid][eExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid entrance.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    GotoEntrance(playerid, entranceid);
    return 1;
}

publish StreamedCheck(playerid, Float:x, Float:y, Float:z, interior, world)
{
    foreach(new i : Entrance)
    {
        if (EntranceInfo[i][eExists] && EntranceInfo[i][eFreeze] &&
            IsPointInRangeOfPoint(x, y, z, 100.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]) &&
            interior == EntranceInfo[i][eInterior] && world == EntranceInfo[i][eWorld])
        {
            SetFreezePos(playerid, x, y, z);
            return 1;
        }
    }

    for (new i = 0; i < sizeof(staticEntrances); i ++)
    {
        if (staticEntrances[i][eFreeze] && IsPointInRangeOfPoint(x, y, z, 100.0, staticEntrances[i][eIntX],
            staticEntrances[i][eIntY], staticEntrances[i][eIntZ]) && world == staticEntrances[i][eWorld])
        {
            SetFreezePos(playerid, x, y, z);
            return 1;
        }
    }

    return 0;
}
