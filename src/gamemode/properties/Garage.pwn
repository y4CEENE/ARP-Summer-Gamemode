/// @file      Garage.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


DB:OnLoadGarages()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_GARAGES; i ++)
    {
        GetDBStringField(i, "owner", GarageInfo[i][gOwner], MAX_PLAYER_NAME);

        GarageInfo[i][gID] = GetDBIntField(i, "id");
        GarageInfo[i][gOwnerID] = GetDBIntField(i, "ownerid");
        GarageInfo[i][gType] = GetDBIntField(i, "type");
        GarageInfo[i][gPrice] = GetDBIntField(i, "price");
        GarageInfo[i][gLocked] = GetDBIntField(i, "locked");
        GarageInfo[i][gTimestamp] = GetDBIntField(i, "timestamp");
        GarageInfo[i][gPosX] = GetDBFloatField(i, "pos_x");
        GarageInfo[i][gPosY] = GetDBFloatField(i, "pos_y");
        GarageInfo[i][gPosZ] = GetDBFloatField(i, "pos_z");
        GarageInfo[i][gPosA] = GetDBFloatField(i, "pos_a");
        GarageInfo[i][gExitX] = GetDBFloatField(i, "exit_x");
        GarageInfo[i][gExitY] = GetDBFloatField(i, "exit_y");
        GarageInfo[i][gExitZ] = GetDBFloatField(i, "exit_z");
        GarageInfo[i][gExitA] = GetDBFloatField(i, "exit_a");
        GarageInfo[i][gWorld] = GetDBIntField(i, "world");
        GarageInfo[i][gText] = Text3D:INVALID_3DTEXT_ID;
        GarageInfo[i][gPickup] = -1;
        GarageInfo[i][gExists] = 1;
        Iter_Add(Garage, i);

        ReloadGarage(i);
    }

    printf("[Script] %i garages loaded.", rows);
}

DB:OnAdminCreateGarage(playerid, garageid, type, Float:x, Float:y, Float:z, Float:angle)
{
    strcpy(GarageInfo[garageid][gOwner], "Nobody", MAX_PLAYER_NAME);

    GarageInfo[garageid][gExists] = 1;
    GarageInfo[garageid][gID] = GetDBInsertID();
    GarageInfo[garageid][gOwnerID] = 0;
    GarageInfo[garageid][gType] = type;
    GarageInfo[garageid][gPrice] = garageInteriors[type][intPrice];
    GarageInfo[garageid][gLocked] = 0;
    GarageInfo[garageid][gPosX] = x;
    GarageInfo[garageid][gPosY] = y;
    GarageInfo[garageid][gPosZ] = z;
    GarageInfo[garageid][gPosA] = angle;
    GarageInfo[garageid][gExitX] = x - 3.0 * floatsin(-angle, degrees);
    GarageInfo[garageid][gExitY] = y - 3.0 * floatsin(-angle, degrees);
    GarageInfo[garageid][gExitZ] = z;
    GarageInfo[garageid][gExitA] = angle - 180.0;
    GarageInfo[garageid][gWorld] = GarageInfo[garageid][gID] + 2000000;
    GarageInfo[garageid][gText] = Text3D:INVALID_3DTEXT_ID;
    GarageInfo[garageid][gPickup] = -1;
    Iter_Add(Garage, garageid);
    DBQuery("UPDATE garages SET world = %i WHERE id = %i", GarageInfo[garageid][gWorld], GarageInfo[garageid][gID]);

    ReloadGarage(garageid);
    SendClientMessageEx(playerid, COLOR_GREEN, "* Garage %i created successfully.", garageid);
}

DB:OnPlayerUpgradeGarage(playerid, garageid)
{
    new count, rows = GetDBNumRows(), vehicleid;

    for (new i = 0; i < rows; i ++)
    {
        vehicleid = GetVehicleLinkedID(GetDBIntField(0, "id"));

        if ((vehicleid == INVALID_VEHICLE_ID) || (vehicleid != INVALID_VEHICLE_ID && GetVehicleVirtualWorld(vehicleid) == GarageInfo[garageid][gWorld]))
        {
            count++;
        }
    }

    if (count)
    {
        SendClientMessage(playerid, COLOR_GREY, "You have despawned vehicles parked in your garage. Park them outside before upgrading.");
    }
    else
    {
        foreach(new i : Player)
        {
            if (GetInsideGarage(i) == garageid)
            {
                SetPlayerPos(i, garageInteriors[GarageInfo[garageid][gType] + 1][intVX], garageInteriors[GarageInfo[garageid][gType] + 1][intVY], garageInteriors[GarageInfo[garageid][gType] + 1][intVZ]);
                SetPlayerFacingAngle(i, garageInteriors[GarageInfo[garageid][gType] + 1][intVA]);
                SetPlayerInterior(i, garageInteriors[GarageInfo[garageid][gType] + 1][intID]);
                SetCameraBehindPlayer(i);
            }
        }

        GarageInfo[garageid][gType]++;
        GarageInfo[garageid][gPrice] = garageInteriors[GarageInfo[garageid][gType]][intPrice];

        GivePlayerCash(playerid, -garageInteriors[GarageInfo[garageid][gType]][intPrice]);
        SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your garage's size to %s for %s.", garageInteriors[GarageInfo[garageid][gType]][intName], FormatCash(garageInteriors[GarageInfo[garageid][gType]][intPrice]));

        DBQuery("UPDATE garages SET type = %i, price = %i WHERE id = %i", GarageInfo[garageid][gType], GarageInfo[garageid][gPrice], GarageInfo[garageid][gID]);

        DBLog("log_property", "%s (uid: %i) upgraded their garage (id: %i) to %s size for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GarageInfo[garageid][gID], garageInteriors[GarageInfo[garageid][gType]][intName], garageInteriors[GarageInfo[garageid][gType]][intPrice]);
    }
}

IsGarageOwner(playerid, garageid)
{
    return (GarageInfo[garageid][gOwnerID] == PlayerData[playerid][pID]);
}

GetNearbyGarageEx(playerid)
{
    return GetNearbyGarage(playerid) == -1 ? GetInsideGarage(playerid) : GetNearbyGarage(playerid);
}

GetNearbyGarage(playerid)
{
    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && IsPlayerInRangeOfPoint(playerid, 4.0, GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]))
        {
            return i;
        }
    }

    return -1;
}

GetInsideGarage(playerid)
{
    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && IsPlayerInRangeOfPoint(playerid, 50.0, garageInteriors[GarageInfo[i][gType]][intVX], garageInteriors[GarageInfo[i][gType]][intVY], garageInteriors[GarageInfo[i][gType]][intVZ]) && GetPlayerInterior(playerid) == garageInteriors[GarageInfo[i][gType]][intID] && GetPlayerVirtualWorld(playerid) == GarageInfo[i][gWorld])
        {
            return i;
        }
    }

    return -1;
}

ReloadGarage(garageid)
{
    if (GarageInfo[garageid][gExists])
    {
        new string[128];

        DestroyDynamic3DTextLabel(GarageInfo[garageid][gText]);
        DestroyDynamicPickup(GarageInfo[garageid][gPickup]);

        if (GarageInfo[garageid][gOwnerID] == 0)
        {
            format(string, sizeof(string), "[{ADADAD}Garage{54878D}]\nPrice: {00AA00}%s{54878D}\nSize: %s\nCapacity: %i cars", FormatCash(GarageInfo[garageid][gPrice]), garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gType] + 1);
        }
        else
        {
            format(string, sizeof(string), "[{ADADAD}Garage{54878D}]\nOwner: %s\nSize: %s\nCapacity: %i cars", GarageInfo[garageid][gOwner], garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gType] + 1);
        }

        GarageInfo[garageid][gText] = CreateDynamic3DTextLabel(string, 0x54878DFF, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ] + 0.1, 10.0);
        GarageInfo[garageid][gPickup] = CreateDynamicPickup(1316, 1, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
    }
}

SetGarageOwner(garageid, playerid)
{
    if (playerid == INVALID_PLAYER_ID)
    {
        strcpy(GarageInfo[garageid][gOwner], "Nobody", MAX_PLAYER_NAME);
        GarageInfo[garageid][gOwnerID] = 0;
    }
    else
    {
        GetPlayerName(playerid, GarageInfo[garageid][gOwner], MAX_PLAYER_NAME);
        GarageInfo[garageid][gOwnerID] = PlayerData[playerid][pID];
    }

    GarageInfo[garageid][gTimestamp] = gettime();

    DBQuery("UPDATE garages SET timestamp = %i, ownerid = %i, owner = '%e' WHERE id = %i", GarageInfo[garageid][gTimestamp], GarageInfo[garageid][gOwnerID], GarageInfo[garageid][gOwner], GarageInfo[garageid][gID]);

    ReloadGarage(garageid);
}

CMD:creategarage(playerid, params[])
{
    new size[8], type = -1, Float:x, Float:y, Float:z, Float:a;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[8]", size))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /creategarage [small/medium/large]");
    }
    if (GetNearbyGarage(playerid) >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is a garage in range. Find somewhere else to create this one.");
    }
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
    }

    if (!strcmp(size, "small", true))
    {
        type = 0;
    }
    else if (!strcmp(size, "medium", true))
    {
        type = 1;
    }
    else if (!strcmp(size, "large", true))
    {
        type = 2;
    }

    if (type == -1)
    {
         SendClientMessage(playerid, COLOR_GREY, "Invalid size. Valid sizes range from Small, Medium and Large.");
    }
    else
    {
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        for (new i = 0; i < MAX_GARAGES; i ++)
        {
            if (!GarageInfo[i][gExists])
            {
                DBFormat("INSERT INTO garages (type, price, pos_x, pos_y, pos_z, pos_a, exit_x, exit_y, exit_z, exit_a) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", type, garageInteriors[type][intPrice], x, y, z, a, x - 3.0 * floatsin(-a, degrees), y - 3.0 * floatcos(-a, degrees), z, a - 180.0);
                DBExecute("OnAdminCreateGarage", "iiiffff", playerid, i, type, x, y, z, a);

                return 1;
            }
        }

        SendClientMessage(playerid, COLOR_GREY, "Garage slots are currently full. Ask developers to increase the internal limit.");
    }

    return 1;
}

stock IsValidGarage(garageid)
{
    return (0 <= garageid < MAX_GARAGES) && GarageInfo[garageid][gExists];
}

CMD:editgarage(playerid, params[])
{
    new garageid, option[10], param[32];

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[10]S()[32]", garageid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Entrance, Exit, Type, Owner, Price, Locked, Freeze");
        return 1;
    }
    if (!IsValidGarage(garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
    }

    if (!strcmp(option, "entrance", true))
    {
        if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
        }

        GetPlayerPos(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
        GetPlayerFacingAngle(playerid, GarageInfo[garageid][gPosA]);

        DBQuery("UPDATE garages SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f' WHERE id = %i", GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], GarageInfo[garageid][gPosA], GarageInfo[garageid][gID]);


        ReloadGarage(garageid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entrance of garage %i.", garageid);
    }
    else if (!strcmp(option, "freeze", true))
    {
        new status;

        if (sscanf(param, "i", status) || !(0 <= status <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [freeze] [0/1]");
        }

        GarageInfo[garageid][gFreeze] = status;

        DBQuery("UPDATE garages SET freeze = %i WHERE id = %i", GarageInfo[garageid][gFreeze], GarageInfo[garageid][gID]);


        ReloadGarage(garageid);

        if (status)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled freeze & object loading for entrance %i.", garageid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled freeze & object loading for entrance %i.", garageid);
    }
    else if (!strcmp(option, "exit", true))
    {
        if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
        }

        GetPlayerPos(playerid, GarageInfo[garageid][gExitX], GarageInfo[garageid][gExitY], GarageInfo[garageid][gExitZ]);
        GetPlayerFacingAngle(playerid, GarageInfo[garageid][gExitA]);

        DBQuery("UPDATE garages SET exit_x = '%f', exit_y = '%f', exit_z = '%f', exit_a = '%f' WHERE id = %i", GarageInfo[garageid][gExitX], GarageInfo[garageid][gExitY], GarageInfo[garageid][gExitZ], GarageInfo[garageid][gExitA], GarageInfo[garageid][gID]);


        ReloadGarage(garageid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the vehicle exit spawn of garage %i.", garageid);
    }
    else if (!strcmp(option, "type", true))
    {
        new size[8], type = -1;

        if (sscanf(param, "s[8]", size))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [type] [small/medium/large]");
        }

        if (!strcmp(size, "small", true))
        {
            type = 0;
        }
        else if (!strcmp(size, "medium", true))
        {
            type = 1;
        }
        else if (!strcmp(size, "large", true))
        {
            type = 2;
        }

        if (type == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
        }

        GarageInfo[garageid][gType] = type;

        DBQuery("UPDATE garages SET type = %i WHERE id = %i", type, GarageInfo[garageid][gID]);


        ReloadGarage(garageid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the type of garage %i to %s.", garageid, size);
    }
    else if (!strcmp(option, "owner", true))
    {
        new targetid;

        if (sscanf(param, "u", targetid))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [owner] [playerid]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (!PlayerData[targetid][pLogged])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
        }

        SetGarageOwner(garageid, targetid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of garage %i to %s.", garageid, GetRPName(targetid));
    }
    else if (!strcmp(option, "price", true))
    {
        new price;

        if (sscanf(param, "i", price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [price] [value]");
        }
        if (price < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
        }

        GarageInfo[garageid][gPrice] = price;

        DBQuery("UPDATE garages SET price = %i WHERE id = %i", GarageInfo[garageid][gPrice], GarageInfo[garageid][gID]);


        ReloadGarage(garageid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the price of garage %i to $%i.", garageid, price);
    }
    else if (!strcmp(option, "locked", true))
    {
        new locked;

        if (sscanf(param, "i", locked) || !(0 <= locked <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgarage [garageid] [locked] [0/1]");
        }

        GarageInfo[garageid][gLocked] = locked;

        DBQuery("UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[garageid][gLocked], GarageInfo[garageid][gID]);


        ReloadGarage(garageid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of garage %i to %i.", garageid, locked);
    }

    return 1;
}

CMD:removegarage(playerid, params[])
{
    new garageid;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", garageid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removegarage [garageid]");
    }
    if (!IsValidGarage(garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
    }

    DestroyDynamic3DTextLabel(GarageInfo[garageid][gText]);
    DestroyDynamicPickup(GarageInfo[garageid][gPickup]);

    DBQuery("DELETE FROM garages WHERE id = %i", GarageInfo[garageid][gID]);


    GarageInfo[garageid][gExists] = 0;
    GarageInfo[garageid][gID] = 0;
    GarageInfo[garageid][gOwnerID] = 0;
    Iter_Remove(Garage, garageid);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed garage %i.", garageid);
    return 1;
}

CMD:gotogarage(playerid, params[])
{
    new garageid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", garageid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotogarage [garageid]");
    }
    if (!IsValidGarage(garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]);
    SetPlayerFacingAngle(playerid, GarageInfo[garageid][gPosA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:garagehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** GARAGE HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** GARAGE ** /buygarage /lock /upgradegarage /sellgarage /sellmygarage /garageinfo");
    SendClientMessage(playerid, COLOR_GREY, "** GARAGE ** /repair");
    return 1;
}

CMD:buygarage(playerid, params[])
{
    new garageid;

    if ((garageid = GetNearbyGarage(playerid)) == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no garage in range. You must be near a garage.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buygarage [confirm]");
    }
    if (GarageInfo[garageid][gOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This garage already has an owner.");
    }
    if (PlayerData[playerid][pCash] < GarageInfo[garageid][gPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this garage.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_GARAGES) >= GetPlayerAssetLimit(playerid, LIMIT_GARAGES))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i garages. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
    }

    SetGarageOwner(garageid, playerid);
    GivePlayerCash(playerid, -GarageInfo[garageid][gPrice]);

    SendClientMessageEx(playerid, COLOR_GREEN, "You paid %s to make this garage yours! /garagehelp for a list of commands.", FormatCash(GarageInfo[garageid][gPrice]));
    DBLog("log_property", "%s (uid: %i) purchased %s garage (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], GarageInfo[garageid][gPrice]);
    return 1;
}

CMD:upgradegarage(playerid, params[])
{
    new garageid = GetNearbyGarageEx(playerid);

    if (garageid == -1 || !IsGarageOwner(playerid, garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
    }
    if (GarageInfo[garageid][gType] >= 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your garage is already at its maximum possible size. You cannot upgrade it further.");
    }
    if (isnull(params) || strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradegarage [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "The next garage size available is %s and costs %s to upgrade to.", garageInteriors[GarageInfo[garageid][gType] + 1][intName], FormatCash(garageInteriors[GarageInfo[garageid][gType] + 1][intPrice]));
        return 1;
    }
    if (PlayerData[playerid][pCash] < garageInteriors[GarageInfo[garageid][gType] + 1][intPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to upgrade your garage.");
    }

    foreach(new i: Vehicle)
    {
        if (IsVehicleInGarage(i, garageid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You must remove all vehicles from your garage before proceeding.");
        }
    }

    DBFormat("SELECT id FROM vehicles WHERE ownerid = %i AND interior > 0 AND world = %i", PlayerData[playerid][pID], GarageInfo[garageid][gWorld]);
    DBExecute("OnPlayerUpgradeGarage", "ii", playerid, garageid);

    return 1;
}

CMD:sellgarage(playerid, params[])
{
    new garageid = GetNearbyGarageEx(playerid), targetid, amount;

    if (garageid == -1 || !IsGarageOwner(playerid, garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellgarage [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
    }

    PlayerData[targetid][pGarageOffer] = playerid;
    PlayerData[targetid][pGarageOffered] = garageid;
    PlayerData[targetid][pGaragePrice] = amount;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their garage for %s (/accept garage).", GetRPName(playerid), FormatCash(amount));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your garage for %s.", GetRPName(targetid), FormatCash(amount));
    return 1;
}

CMD:sellmygarage(playerid, params[])
{
    new garageid = GetNearbyGarageEx(playerid);

    if (garageid == -1 || !IsGarageOwner(playerid, garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmygarage [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your garage back to the state. You will receive %s back.", FormatCash(percent(GarageInfo[garageid][gPrice], 75)));
        return 1;
    }

    SetGarageOwner(garageid, INVALID_PLAYER_ID);
    GivePlayerCash(playerid, percent(GarageInfo[garageid][gPrice], 75));

    SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your garage to the state and received %s back.", FormatCash(percent(GarageInfo[garageid][gPrice], 75)));
    DBLog("log_property", "%s (uid: %i) sold their %s garage (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], percent(GarageInfo[garageid][gPrice], 75));
    return 1;
}

CMD:garageinfo(playerid, params[])
{
    new garageid = GetNearbyGarageEx(playerid);

    if (garageid == -1 || !IsGarageOwner(playerid, garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any garage of yours.");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ Garage ID %i _______", garageid);
    SendClientMessageEx(playerid, COLOR_GREY2, "Value: %s - Size: %s - Location: %s - Active: %s - Locked: %s", FormatCash(GarageInfo[garageid][gPrice]), garageInteriors[GarageInfo[garageid][gType]][intName], GetZoneName(GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ]), (gettime() - GarageInfo[garageid][gTimestamp] > 2592000) ? ("{FF6347}No{C8C8C8}") : ("Yes"), (GarageInfo[garageid][gLocked]) ? ("Yes") : ("No"));
    return 1;
}

CMD:asellgarage(playerid, params[])
{
    new garageid;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", garageid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellgarage [garageid]");
    }
    if (!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
    }

    SetGarageOwner(garageid, INVALID_PLAYER_ID);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold garage %i.", garageid);
    return 1;
}
