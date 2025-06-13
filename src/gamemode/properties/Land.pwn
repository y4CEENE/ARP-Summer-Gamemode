/// @file      Land.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static LandObjectIndex[MAX_PLAYERS];

IsPointInLand(landid, Float:x, Float:y)
{
    if ((LandInfo[landid][lMinX] <= x <= LandInfo[landid][lMaxX]) && (LandInfo[landid][lMinY] <= y <= LandInfo[landid][lMaxY]))
    {
        return 1;
    }

    return 0;
}
IsLandOwner(playerid, landid)
{
    return (LandInfo[landid][lOwnerID] == PlayerData[playerid][pID]);
}

SetLandOwner(landid, playerid)
{
    if (playerid == INVALID_PLAYER_ID)
    {
        strcpy(LandInfo[landid][lOwner], "Nobody", MAX_PLAYER_NAME);
        LandInfo[landid][lOwnerID] = 0;
    }
    else
    {
        GetPlayerName(playerid, LandInfo[landid][lOwner], MAX_PLAYER_NAME);
        LandInfo[landid][lOwnerID] = PlayerData[playerid][pID];
    }

    DBQuery("UPDATE lands SET ownerid = %i, owner = '%e' WHERE id = %i", LandInfo[landid][lOwnerID], LandInfo[landid][lOwner], LandInfo[landid][lID]);

    ReloadLand(landid);
}

ShowLandsOnMap(playerid, enable)
{
    foreach(new i : Land)
    {
        if (LandInfo[i][lExists])
        {
            if (enable)
            {
                GangZoneShowForPlayer(playerid, LandInfo[i][lGangZone], COLOR_LAND);
            }
            else
            {
                GangZoneHideForPlayer(playerid, LandInfo[i][lGangZone]);
            }
        }
    }

    PlayerData[playerid][pShowLands] = enable;
}
GetLandId(sql_id)
{
    foreach(new i : Land)
    {
        if (LandInfo[i][lExists] && LandInfo[i][lID] == sql_id)
        {
            return i;
        }
    }
    return -1;
}

GetLandObjectID(sql_id)
{
    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID) == sql_id)
        {
            return i;
        }
    }

    return INVALID_OBJECT_ID;
}

GetLandObjectCapacity(level)
{
    switch (level)
    {
        case 1: return 100;
        case 2: return 150;
        case 3: return 200;
        case 4: return 250;
        case 5: return 300;
    }

    return 0;
}

RemoveLandObject(objectid)
{
    if (IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
    {
        new
            id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

        DeleteLandObject(objectid);

        DBQuery("DELETE FROM landobjects WHERE id = %i", id);
    }
}

DeleteLandObject(objectid)
{
    if (IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
    {
        new Text3D:textid = Text3D:Streamer_GetExtraInt(objectid, E_OBJECT_3DTEXT_ID);

        if (IsValidDynamic3DTextLabel(textid))
        {
            DestroyDynamic3DTextLabel(textid);
        }
        DestroyDynamicObject(objectid);
    }
}

RemoveAllLandObjects(landid)
{
    if (LandInfo[landid][lExists])
    {
        for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
        {
            if (IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
            {
                new Text3D:textid = Text3D:Streamer_GetExtraInt(i, E_OBJECT_3DTEXT_ID);

                if (IsValidDynamic3DTextLabel(textid))
                {
                    DestroyDynamic3DTextLabel(textid);
                }

                DestroyDynamicObject(i);
            }
        }

        DBQuery("DELETE FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
        UpdateLandText(landid);
    }
}

ReloadLandObject(objectid, labels)
{
    if (IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
    {
        new
            id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

        DeleteLandObject(objectid);

        DBFormat("SELECT * FROM landobjects WHERE id = %i", id);
        DBExecute("OnLoadLandObjects", "i", labels);
    }
}

ReloadAllLandObjects(landid)
{
    if (LandInfo[landid][lExists])
    {
        for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
        {
            if (IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
            {
                DeleteLandObject(i);
            }
        }

        DBFormat("SELECT * FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
        DBExecute("OnLoadLandObjects", "i", LandInfo[landid][lLabels]);
    }
}

ReloadLand(landid)
{
    if (LandInfo[landid][lExists])
    {
        DestroyDynamicArea(LandInfo[landid][lArea]);
        GangZoneDestroy(LandInfo[landid][lGangZone]);
        DestroyDynamic3DTextLabel(LandInfo[landid][lTextdraw]);

        LandInfo[landid][lArea] = CreateDynamicRectangle(LandInfo[landid][lMinX], LandInfo[landid][lMinY], LandInfo[landid][lMaxX], LandInfo[landid][lMaxY]);
        LandInfo[landid][lGangZone] = GangZoneCreateEx(LandInfo[landid][lMinX], LandInfo[landid][lMinY], LandInfo[landid][lMaxX], LandInfo[landid][lMaxY]);
        LandInfo[landid][lTextdraw] = CreateDynamic3DTextLabel("Land", COLOR_GREY, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ], 10.0);
        UpdateLandText(landid);
        foreach(new i : Player)
        {
            if (PlayerData[i][pShowLands])
            {
                GangZoneShowForPlayer(i, LandInfo[landid][lGangZone], (LandInfo[landid][lOwnerID] > 0) ? (0xFF6347AA) : (0x33CC33AA));
            }
        }
    }
}

GetNearbyLand(playerid)
{
    if (GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
    {
        foreach(new i : Land)
        {
            if (LandInfo[i][lExists] && IsPlayerInDynamicArea(playerid, LandInfo[i][lArea]))
            {
                return i;
            }
        }
    }

    return -1;
}
DB:LandLabelsUpdate(landid)
{
    new string[128];
    if (IsValidDynamic3DTextLabel(LandInfo[landid][lTextdraw]))
    {
        if (LandInfo[landid][lOwnerID] > 0)
        {
            format(string, sizeof(string), "This land belong to \n{33CCFF}%s (%i)\n{FFD700}Level: %i\n{FFFFFF}%i/%i Objects",LandInfo[landid][lOwner],landid, LandInfo[landid][lLevel], GetDBIntFieldFromIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
        }
        else
        {
            format(string, sizeof(string), "This land(%i) is for sale by the state\n{00AA00}Price: %s{FFFFFF}\n{FFD700}Level: %i\n{FFFFFF}%i/%i Objects", landid, FormatCash(LandInfo[landid][lPrice]), LandInfo[landid][lLevel], GetDBIntFieldFromIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
        }
        if (LandInfo[landid][lSeized])
        {
            format(string, sizeof(string), "{FF0000}Seized Land{AFAFAF}\n%s", string);
        }
        UpdateDynamic3DTextLabelText(LandInfo[landid][lTextdraw], COLOR_GREY, string);
    }
}

DB:CountLandObjects(playerid)
{
    new landid = GetNearbyLand(playerid);

    if (GetDBIntFieldFromIndex(0, 0) >= GetLandObjectCapacity(LandInfo[landid][lLevel]))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You are only only allowed up to %i objects for your land.", GetLandObjectCapacity(LandInfo[landid][lLevel]));
    }
    else
    {
        ShowLandBuildTypeDialog(playerid);
        //ShowLandBuildCategoryDialog(playerid);
    }
}

DB:LandObjectInfo(playerid)
{
    if (GetDBNumRows())
    {
        new name[32];

        GetDBStringField(0, "name", name);
        new objid = PlayerData[playerid][pSelected];
        new modelid = GetDBIntField(0, "modelid");
        new Float:x = GetDBFloatField(0, "pos_x");
        new Float:y = GetDBFloatField(0, "pos_y");
        new Float:z = GetDBFloatField(0, "pos_z");
        new Float:rx = GetDBFloatField(0, "rot_x");
        new Float:ry = GetDBFloatField(0, "rot_y");
        new Float:rz = GetDBFloatField(0, "rot_z");

        SendClientMessageEx(playerid, COLOR_YELLOW2, "Object Name: %s [ID: %i, Model: %i] X: %.4f | Y: %.4f | Z: %.4f | RX: %.4f | RY: %.4f | RZ: %.4f", name,objid, modelid, x, y, z, rx, ry, rz);
    }
    PlayerData[playerid][pSelected] = 0;
}

DB:SellLandObject(playerid)
{
    if (GetDBNumRows())
    {
        new name[32], price = percent(GetDBIntField(0, "price"), 75);

        GetDBStringField(0, "name", name);
        GivePlayerCash(playerid, price);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have sold {FF6347}%s{33CCFF} and received a 75 percent refund of {00AA00}$%i{33CCFF}.", name, price);
        RemoveLandObject(PlayerData[playerid][pSelected]);
        UpdateLandText(GetNearbyLand(playerid));
    }
}

DB:DuplicateLandObjectCheck(playerid)
{
    if (GetDBIntFieldFromIndex(0, 0) >= GetLandObjectCapacity(LandInfo[PlayerData[playerid][pObjectLand]][lLevel]))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You are only only allowed up to %i objects for your land.", GetLandObjectCapacity(LandInfo[PlayerData[playerid][pObjectLand]][lLevel]));
    }
    else
    {
        DBFormat("SELECT name, modelid, price, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z FROM landobjects WHERE id = %i", Streamer_GetExtraInt(PlayerData[playerid][pSelected], E_OBJECT_INDEX_ID));
        DBExecute("DuplicateLandObject", "i", playerid);
    }
}

DB:DuplicateLandObject(playerid)
{
    if (GetDBNumRows())
    {
        new string[20], name[32], landid = GetNearbyLand(playerid);

        new modelid = GetDBIntField(0, "modelid");
        new price = GetDBIntField(0, "price");
        new Float:x = GetDBFloatField(0, "pos_x");
        new Float:y = GetDBFloatField(0, "pos_y");
        new Float:z = GetDBFloatField(0, "pos_z");
        new Float:rx = GetDBFloatField(0, "rot_x");
        new Float:ry = GetDBFloatField(0, "rot_y");
        new Float:rz = GetDBFloatField(0, "rot_z");

        if (PlayerData[playerid][pCash] < price)
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't afford to duplicate this object.");
        }
        else
        {
            PlayerData[playerid][pObjectLand] = landid;
            GetDBStringField(0, "name", name);

            GivePlayerCash(playerid, -price);
            SendClientMessageEx(playerid, COLOR_GREEN, "%s duplicated for $%i. You will now edit this object.", name, price);

            format(string, sizeof(string), "~r~-$%i", price);
            GameTextForPlayer(playerid, string, 5000, 1);

            DBFormat("INSERT INTO landobjects VALUES "\
                    "(null, %i, %i, '%e', %i, '%f', '%f', '%f', '%f', '%f', '%f', 0, 0, '0.0', '0.0', '0.0', '-1000.0', '-1000.0', '-1000.0')",
                    LandInfo[landid][lID], modelid, name, price, x, y, z, rx, ry, rz);
            DBExecute("LandObjectDuplicated", "i", playerid);

            DBQueryWithCallback("SELECT * FROM landobjects WHERE id = LAST_INSERT_ID()", "OnLoadLandObjects", "i", LandInfo[landid][lLabels]);
            UpdateLandText(landid);
        }
    }
}

DB:LandObjectDuplicated(playerid)
{
    new id = GetDBInsertID();

    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID) == id)
        {
            PlayerData[playerid][pEditType] = EDIT_LAND_OBJECT;
            PlayerData[playerid][pEditObject] = i;

            EditDynamicObject(playerid, i);
            GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
            break;
        }
    }
}

DB:ClearLandObjects(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "Your land contains no furniture which can be sold.");
    }
    else
    {
        new price, landid = GetNearbyLand(playerid);

        for (new i = 0; i < rows; i ++)
        {
            price += percent(GetDBIntField(i, "price"), 75);
        }

        RemoveAllLandObjects(landid);

        GivePlayerCash(playerid, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have sold a total of %i items and received {00AA00}$%i{33CCFF} back.", rows, price);
    }
}

DB:LandObjectList(playerid)
{
    new rows = GetDBNumRows();

    if ((!rows) && PlayerData[playerid][pPage] == 1)
    {
        SendClientMessage(playerid, COLOR_GREY, "Your land contains no objects which can be listed.");
    }
    else
    {
        static string[MAX_LISTED_OBJECTS * 48], name[32];

        string = "#\tName\tCost\tDistance";

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "name", name);
            format(string, sizeof(string), "%s\n%i\t%s\t{00AA00}$%i{FFFFFF}\t%.1fm", string, GetLandObjectID(GetDBIntField(i, "id")), name, GetDBIntField(i, "price"), GetPlayerDistanceFromPoint(playerid, GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z")));
        }

        if (PlayerData[playerid][pPage] > 1)
        {
            strcat(string, "\n{FF6347}<< Go back{FFFFFF}");
        }
        if (rows == MAX_LISTED_OBJECTS)
        {
            strcat(string, "\n{00AA00}>> Next page{FFFFFF}");
        }

        Dialog_Show(playerid, LandObjects, DIALOG_STYLE_TABLIST_HEADERS, "List of objects", string, "Select", "Back");
    }
}

DB:LandMainMenu(playerid)
{
    new string[64];
    new landid = GetNearbyLand(playerid);
    format(string, sizeof(string), "Land menu {FFD700}(Level: %i/5) (%i/%i objects)", LandInfo[landid][lLevel], GetDBIntFieldFromIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
    Dialog_Show(playerid, LandMenu, DIALOG_STYLE_LIST, string, "Build object\nEdit object\nToggle labels\nList all objects\nSell all objects\nUpgrade land\nPermissions", "Select", "Cancel");
}

DB:LandInformation(playerid)
{
    new landid = GetNearbyLand(playerid);

    //SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ My Land _______");
    //SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) - (Value: $%i) - (Objects: %i/%i) - (Location: %s)", landid, LandInfo[landid][lPrice], GetDBIntFieldFromIndex(0, 0), GetLandObjectCapacity(landid), GetZoneName(LandInfo[landid][lMinX], LandInfo[landid][lMinY], LandInfo[landid][lHeight]));
    SendClientMessageEx(playerid, COLOR_WHITE, "* Your level %i/3 land in %s is worth {00AA00}%s{FFFFFF} and contains %i/%i objects.", LandInfo[landid][lLevel], GetZoneName(LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]), FormatCash(LandInfo[landid][lPrice]), GetDBIntFieldFromIndex(0, 0), GetLandObjectCapacity(LandInfo[landid][lLevel]));
}

DB:OnAdminCreateLand(playerid, landid, price, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:heightx, Float:heighty, Float:heightz)
{
    GetPlayerPos(playerid, heightx, heighty, heightz);
    strcpy(LandInfo[landid][lOwner], "Nobody", MAX_PLAYER_NAME);
    LandInfo[landid][lExists] = 1;
    LandInfo[landid][lID] = GetDBInsertID();
    LandInfo[landid][lOwnerID] = 0;
    LandInfo[landid][lLevel] = 1;
    LandInfo[landid][lPrice] = price;
    LandInfo[landid][lMinX] = minx;
    LandInfo[landid][lMinY] = miny;
    LandInfo[landid][lMaxX] = maxx;
    LandInfo[landid][lMaxY] = maxy;
    LandInfo[landid][lHeightX] = heightx;
    LandInfo[landid][lHeightY] = heighty;
    LandInfo[landid][lHeightZ] = heightz;
    LandInfo[landid][lSeized] = 0;
    LandInfo[landid][lGangZone] = -1;
    LandInfo[landid][lArea] = -1;
    Iter_Add(Land, landid);

    ReloadLand(landid);
    SendClientMessageEx(playerid, COLOR_GREEN, "* Land %i created successfully.", landid);
}

DB:OnLoadLands()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_LANDS; i ++)
    {
        GetDBStringField(i, "owner", LandInfo[i][lOwner], MAX_PLAYER_NAME);

        LandInfo[i][lID] = GetDBIntField(i, "id");
        LandInfo[i][lOwnerID] = GetDBIntField(i, "ownerid");
        LandInfo[i][lLevel] = GetDBIntField(i, "level");
        LandInfo[i][lPrice] = GetDBIntField(i, "price");
        LandInfo[i][lMinX] = GetDBFloatField(i, "min_x");
        LandInfo[i][lMinY] = GetDBFloatField(i, "min_y");
        LandInfo[i][lMaxX] = GetDBFloatField(i, "max_x");
        LandInfo[i][lMaxY] = GetDBFloatField(i, "max_y");
        LandInfo[i][lHeightX] = GetDBFloatField(i, "heightx");
        LandInfo[i][lHeightY] = GetDBFloatField(i, "heighty");
        LandInfo[i][lHeightZ] = GetDBFloatField(i, "heightz");
        LandInfo[i][lSeized] = GetDBIntField(i, "seized");
        LandInfo[i][lGangZone] = -1;
        LandInfo[i][lArea] = -1;
        LandInfo[i][lLabels] = 0;

        //LandInfo[i][lTextdraw];
        LandInfo[i][lExists] = 1;
        Iter_Add(Land, i);

        ReloadLand(i);
    }

    printf("[Script] %i lands loaded.", rows);
}

DB:OnLoadLandObjects(labelsVisibility)
{
    new rows = GetDBNumRows();
    new lastlandid = -1;
    new lastsqlid = -1;

    for (new i = 0; i < rows; i ++)
    {
        new sqlid = GetDBIntField(i, "landid");
        if (sqlid != lastsqlid)
        {
            lastlandid = GetLandId(sqlid);
            lastsqlid = sqlid;
        }
        new objectid;
        if (lastlandid >= 0 && LandInfo[lastlandid][lSeized])
        {
            objectid = CreateDynamicObject(GetDBIntField(i, "modelid"), GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z"), GetDBFloatField(i, "rot_x"), GetDBFloatField(i, "rot_y"), GetDBFloatField(i, "rot_z"), SEIZED_LAND_VW);
        }
        else
        {
            objectid = CreateDynamicObject(GetDBIntField(i, "modelid"), GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z"), GetDBFloatField(i, "rot_x"), GetDBFloatField(i, "rot_y"), GetDBFloatField(i, "rot_z"));
        }

        Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_LAND);
        Streamer_SetExtraInt(objectid, E_OBJECT_INDEX_ID, GetDBIntField(i, "id"));
        Streamer_SetExtraInt(objectid, E_OBJECT_EXTRA_ID, GetDBIntField(i, "landid"));
        Streamer_SetExtraFloat(objectid, E_OBJECT_X, GetDBFloatField(i, "pos_x"));
        Streamer_SetExtraFloat(objectid, E_OBJECT_Y, GetDBFloatField(i, "pos_y"));
        Streamer_SetExtraFloat(objectid, E_OBJECT_Z, GetDBFloatField(i, "pos_z"));

        if (labelsVisibility)
        {
            new string[48];
            GetDBStringField(i, "name", string);

            format(string, sizeof(string), "[%i] - %s", objectid, string);
            Streamer_SetExtraInt(objectid, E_OBJECT_3DTEXT_ID, _:CreateDynamic3DTextLabel(string, COLOR_GREY2, GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z"), 10.0));
        }
    }
}

Dialog:LandBuildType(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 0;
    }

    if (response)
    {
        PlayerData[playerid][pMenuType] = listitem;
        ShowLandBuildCategoryDialog(playerid);
    }
    else
    {
        ShowPlayerLandMenu(playerid);
    }
    return 1;
}

ShowPlayerLandMenu(playerid)
{
    new landid = GetNearbyLand(playerid);
    DBFormat("SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
    DBExecute("LandMainMenu", "i", playerid);
}

Dialog:LandBuildCategory(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 0;
    }

    if (response)
    {
        switch (PlayerData[playerid][pMenuType])
        {
            case 0: // Model selection
            {
                PlayerData[playerid][pCategory] = listitem;
                ShowLandObjects(playerid, MODEL_SELECTION_LANDOBJECTS);
            }
            case 1:
            {
                PlayerData[playerid][pCategory] = listitem;
                ShowLandObjectSelectionDialog(playerid);
            }
       }
    }
    else
    {
        ShowLandBuildTypeDialog(playerid);
    }
    return 1;
}
Dialog:LandObjectSelection(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 0;
    }

    if (response)
    {
        PurchaseLandObject(playerid, landid, listitem + LandObjectIndex[playerid]);
    }
    else
    {
        ShowLandBuildCategoryDialog(playerid);
    }
    return 1;
}

Dialog:LandMenu(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                DBFormat("SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
                DBExecute("CountLandObjects", "i", playerid);
            }
            case 1:
            {
                Dialog_Show(playerid, EditLandObjectId, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
            }
            case 2:
            {
                if (!LandInfo[landid][lLabels])
                {
                    LandInfo[landid][lLabels] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "You will now see labels appear above the objects in your land.");
                }
                else
                {
                    LandInfo[landid][lLabels] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any labels appear above your land objects.");
                }

                ReloadAllLandObjects(landid);
                ShowPlayerLandMenu(playerid);
            }
            case 3:
            {
                PlayerData[playerid][pPage] = 1;
                ShowLandObjectsDialog(playerid);
            }
            case 4:
            {
                Dialog_Show(playerid, DIALOG_LANDSELLALL, DIALOG_STYLE_MSGBOX, "Clear objects", "This option sells all the objects in your land. You will receive\n75 percent of the total cost of all your objects.\n\nPress {FF6347}Confirm{A9C4E4} to proceed with the operation.", "Confirm", "Back");
            }
            case 5:
            {
                if (LandInfo[landid][lLevel] >= 5)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your land can't be upgraded any further.");
                }

                new
                    string[224];

                format(string, sizeof(string), "You are about to upgrade your land to level %i/5.\n\nThis upgrade will cost you {00AA00}$100,000{A9C4E4} and unlocks %i more\nobject slots for your land.\n\nAre you sure you want to upgrade your land?", LandInfo[landid][lLevel] + 1, GetLandObjectCapacity(LandInfo[landid][lLevel] + 1) - GetLandObjectCapacity(LandInfo[landid][lLevel]));
                Dialog_Show(playerid, DIALOG_LANDUPGRADE, DIALOG_STYLE_MSGBOX, "Upgrade land", string, "Yes", "No");
            }
            case 6:
            {
                Dialog_Show(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
            }
        }
    }
    return 1;
}

Dialog:DIALOG_LANDUPGRADE(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 1;
    }

    if (response)
    {
        if (LandInfo[landid][lLevel] < 5)
        {
            if (PlayerData[playerid][pCash] < 100000)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't afford to upgrade your land.");
            }

            LandInfo[landid][lLevel]++;

            DBQuery("UPDATE lands SET level = level + 1 WHERE id = %i", LandInfo[landid][lID]);

            GivePlayerCash(playerid, -100000);
            GameTextForPlayer(playerid, "~r~-$100000", 5000, 1);
            SendClientMessageEx(playerid, COLOR_GREEN, "You paid $100,000 to upgrade your land to level %i/5. Your land can now have up to %i objects.", LandInfo[landid][lLevel], GetLandObjectCapacity(LandInfo[landid][lLevel]));
        }
    }
    else
    {
        ShowPlayerLandMenu(playerid);
    }
    return 1;
}

Dialog:EditLandObjectId(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 1;
    }

    if (response)
    {
        new objectid;

        if (sscanf(inputtext, "i", objectid))
        {
            return Dialog_Show(playerid, EditLandObjectId, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
        }
        if (!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
        {
            SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
            return Dialog_Show(playerid, EditLandObjectId, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
        }
        if (Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
        {
            SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
            return Dialog_Show(playerid, EditLandObjectId, DIALOG_STYLE_INPUT, "Edit object", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
        }

        PlayerData[playerid][pSelected] = objectid;
        ShowLandEditObjectDialog(playerid);
    }
    else
    {
        ShowPlayerLandMenu(playerid);
    }
    return 1;
}

Dialog:LandEditObject(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 1;
    }

    if (response)
    {
        new objectid = PlayerData[playerid][pSelected];

        if (!strcmp(inputtext, "Edit object"))
        {
            if (Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't edit your gate while it is opened.");
            }

            PlayerData[playerid][pEditType] = EDIT_LAND_OBJECT;
            PlayerData[playerid][pEditObject] = objectid;
            PlayerData[playerid][pObjectLand] = landid;

            EditDynamicObject(playerid, objectid);
            GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
        }
        else if (!strcmp(inputtext, "Edit gate destination"))
        {
            if (Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't edit your gate while it is opened.");
            }

            PlayerData[playerid][pEditType] = EDIT_LAND_GATE_MOVE;
            PlayerData[playerid][pEditObject] = objectid;
            PlayerData[playerid][pObjectLand] = landid;

            EditDynamicObject(playerid, objectid);
            SendClientMessage(playerid, COLOR_WHITE, "You are now editing the move-to position for your gate.");
            GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
        }
        else if (!strcmp(inputtext, "Duplicate object"))
        {
            PlayerData[playerid][pSelected] = objectid;
            PlayerData[playerid][pObjectLand] = landid;
            DBFormat("SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
            DBExecute("DuplicateLandObjectCheck", "i", playerid);

        }
        else if (!strcmp(inputtext, "Sell object"))
        {
            PlayerData[playerid][pSelected] = objectid;

            DBFormat("SELECT name, price FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
            DBExecute("SellLandObject", "i", playerid);
        }
    }
    else
    {
        ShowPlayerLandMenu(playerid);
    }
    return 1;
}
Dialog:LandObjects(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!strcmp(inputtext, ">> Next page", true))
        {
            PlayerData[playerid][pPage]++;
            ShowLandObjectsDialog(playerid);
        }
        else if (!strcmp(inputtext, "<< Go back", true) && PlayerData[playerid][pPage] > 1)
        {
            PlayerData[playerid][pPage]--;
            ShowLandObjectsDialog(playerid);
        }
        else
        {
            new objectid = strval(inputtext);

            if (IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_LAND)
            {
                PlayerData[playerid][pSelected] = objectid;
                ShowLandEditObjectDialog(playerid);
            }
        }
    }
    else
    {
        ShowPlayerLandMenu(playerid);
    }
    return 1;
}
Dialog:DIALOG_LANDSELLALL(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return 1;
    }

    if (response)
    {
        DBFormat("SELECT price FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
        DBExecute("ClearLandObjects", "i", playerid);
    }
    else
    {
        ShowPlayerLandMenu(playerid);
    }
    return 1;
}

Dialog:DIALOG_LANDPERMS(playerid, response, listitem, inputtext[])
{
    new landid = GetNearbyLand(playerid), targetid;

    if (landid == -1 || !IsLandOwner(playerid, landid))
    {
        return 1;
    }

    if (response)
    {
        if (sscanf(inputtext, "u", targetid))
        {
            return Dialog_Show(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
        }
        if (!IsPlayerConnected(targetid))
        {
            SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
            return Dialog_Show(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
        }
        if (targetid == playerid)
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't give permissions to yourself.");
            return Dialog_Show(playerid, DIALOG_LANDPERMS, DIALOG_STYLE_INPUT, "Permissions", "Please enter the name or ID of the player to take or give permissions to:", "Submit", "Back");
        }

        if (GetPlayerPropertyKey(playerid, PropertyType_Land, landid) != KeyRole_Unauthorized)
        {
            RemovePlayerPropertyAccess(targetid, PropertyType_Land, landid);
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your access to their land's objects.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's access to your land's objects.", GetRPName(targetid));
        }
        else
        {
            GivePlayerPropertyAccess(targetid, PlayerData[playerid][pID], PropertyType_Land, landid, KeyRole_Editor, gettime() + 30 * 24 * 3600);
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has granted you access to their land's objects for 30 days.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You have granted %s access to your land's objects for 30 days.", GetRPName(targetid));
        }
    }

    ShowPlayerLandMenu(playerid);
    return 1;
}

PurchaseLandObject(playerid, landid, index)
{
    if (PlayerData[playerid][pCash] < landArray[index][fPrice])
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't purchase this. You don't have enough money for it.");
    }
    else
    {
        new
            Float:x,
            Float:y,
            Float:z,
            Float:a;

        if (PlayerData[playerid][pEditType] == EDIT_LAND_OBJECT_PREVIEW && IsValidDynamicObject(PlayerData[playerid][pEditObject])) // Bug fix where if you did '/furniture buy' again while editing your object gets stuck. (12/28/2016)
        {
            DestroyDynamicObject(PlayerData[playerid][pEditObject]);
            PlayerData[playerid][pEditObject] = INVALID_OBJECT_ID;
        }

        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        PlayerData[playerid][pEditType] = EDIT_LAND_OBJECT_PREVIEW;
        PlayerData[playerid][pEditObject] = CreateDynamicObject(landArray[index][fModel], x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z + 1.0, 0.0, 0.0, ((19353 <= landArray[index][fModel] <= 19417) || (19426 <= landArray[index][fModel] <= 19465)) ? (a + 90.0) : (a), GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        PlayerData[playerid][pObjectLand] = landid;
        PlayerData[playerid][pSelected] = index;

        SendClientMessageEx(playerid, COLOR_AQUA, "You are now previewing {FF6347}%s{33CCFF}. This object costs {00AA00}%s{33CCFF} to purchase.", landArray[index][fName], FormatCash(landArray[index][fPrice]));
        SendClientMessageEx(playerid, COLOR_AQUA, "Use your cursor to control the editor interface. Click the floppy disk to save changes.");
        Streamer_Update(playerid);
        EditDynamicObject(playerid, PlayerData[playerid][pEditObject]);
    }
}
ShowLandObjects(playerid, type)
{
    new index;
    new models[MAX_SELECTION_MENU_ITEMS] = {-1, ...};

    LandObjectIndex[playerid] = -1;

    for (new i = 0; i < sizeof(landArray); i ++)
    {
        if (!strcmp(landArray[i][fCategory], landCategories[PlayerData[playerid][pCategory]]))
        {
            if (LandObjectIndex[playerid] == -1)
            {
                LandObjectIndex[playerid] = i;
            }

            models[index++] = landArray[i][fModel];
        }
    }

    ShowPlayerSelectionMenu(playerid, type, landCategories[PlayerData[playerid][pCategory]], models, index);
}

UpdateLandText(landid)
{
    DBFormat("SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
    DBExecute("LandLabelsUpdate", "i", landid);
}

DB:OnPlayerRamLandDoor(playerid, objectid, id)
{
    if (GetDBIntField(0, "door_opened"))
    {
        SendClientMessage(playerid, COLOR_GREY, "The door is already opened.");
    }
    else
    {
        ShowActionBubble(playerid, "* %s rams the door down.", GetRPName(playerid));

        new Float:rx, Float:ry, Float:rz;
        GetDynamicObjectRot(objectid, rx, ry, rz);
        rz -= 90.0;
        SetDynamicObjectRot(objectid, rx, ry, rz);

        DBQuery("UPDATE landobjects SET rot_z = '%f', door_locked = 0, door_opened = 1 WHERE id = %i", rz, id);
    }
}

DB:OnPlayerLockLandDoor(playerid, id)
{
    new status = !GetDBIntField(0, "door_locked");

    if (status)
    {
        ShowActionBubble(playerid, "* %s locks the door.", GetRPName(playerid));
    }
    else
    {
        ShowActionBubble(playerid, "* %s unlocks the door.", GetRPName(playerid));
    }

    DBQuery("UPDATE landobjects SET door_locked = %i WHERE id = %i", status, id);
}

DB:OnPlayerUseLandGate(playerid, objectid, id)
{
    if (!Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
    {
        new
            Float:x = GetDBFloatField(0, "move_x"),
            Float:y = GetDBFloatField(0, "move_y"),
            Float:z = GetDBFloatField(0, "move_z");

        if (x == 0.0 && y == 0.0 && z == 0.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "This gate has no destination set.");
        }
        else
        {
            MoveDynamicObject(objectid, x, y, z, 3.0, GetDBFloatField(0, "move_rx"), GetDBFloatField(0, "move_ry"), GetDBFloatField(0, "move_rz"));
            ShowActionBubble(playerid, "* %s uses their remote to open the gate.", GetRPName(playerid));
            Streamer_SetExtraInt(objectid, E_OBJECT_OPENED, 1);
        }
    }
    else
    {
        MoveDynamicObject(objectid, GetDBFloatField(0, "pos_x"), GetDBFloatField(0, "pos_y"), GetDBFloatField(0, "pos_z"), 3.0, GetDBFloatField(0, "rot_x"), GetDBFloatField(0, "rot_y"), GetDBFloatField(0, "rot_z"));
        ShowActionBubble(playerid, "* %s uses their remote to close the gate.", GetRPName(playerid));
        Streamer_SetExtraInt(objectid, E_OBJECT_OPENED, 0);
    }
}

DB:OnPlayerUseLandDoor(playerid, objectid, id)
{
    if (GetDBIntFieldFromIndex(0, 1))
    {
        SendClientMessage(playerid, COLOR_GREY, "This door is locked.");
    }
    else
    {
        new
            status = !GetDBIntFieldFromIndex(0, 0),
            Float:rx,
            Float:ry,
            Float:rz;

        GetDynamicObjectRot(objectid, rx, ry, rz);

        if (status)
        {
            rz -= 90.0;
        }
        else
        {
            rz += 90.0;
        }

        SetDynamicObjectRot(objectid, rx, ry, rz);

        DBQuery("UPDATE landobjects SET rot_z = '%f', door_opened = %i WHERE id = %i", rz, status, id);

        if (status)
            ShowActionBubble(playerid, "* %s opens the door.", GetRPName(playerid));
        else
            ShowActionBubble(playerid, "* %s closes the door.", GetRPName(playerid));
    }
}

CMD:asellland(playerid, params[])
{
    new landid;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellland [landid]");
    }
    if (!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
    }

    SetLandOwner(landid, INVALID_PLAYER_ID);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold land %i.", landid);
    return 1;
}

CMD:createland(playerid, params[])
{
    new price;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", price))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createland [price]");
    }
    if (price < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
    }
    if (GetNearbyLand(playerid) >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is a land in range. Find somewhere else to create this one.");
    }
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot create lands indoors.");
    }

    PlayerData[playerid][pLandCost] = price;
    SetPlayerCreatingZone(playerid, ZoneType_Land);
    return 1;
}

CMD:gotoland(playerid, params[])
{
    new landid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoland [landid]");
    }
    if (!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:removelandobjects(playerid, params[])
{
    new landid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelandobjects [landid]");
    }
    if (!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
    }

    RemoveAllLandObjects(landid);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed all land objects for land %i.", landid);
    UpdateLandText(landid);
    return 1;
}

IsValidLand(landid)
{
    return (0 <= landid < MAX_LANDS) && LandInfo[landid][lExists];
}

CMD:removeland(playerid, params[])
{
    new landid;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeland [landid]");
    }
    if (!IsValidLand(landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
    }

    RemoveAllLandObjects(landid);

    GangZoneDestroy(LandInfo[landid][lGangZone]);
    DestroyDynamicArea(LandInfo[landid][lArea]);
    DestroyDynamic3DTextLabel(LandInfo[landid][lTextdraw]);

    DBQuery("DELETE FROM lands WHERE id = %i", LandInfo[landid][lID]);

    LandInfo[landid][lID] = 0;
    LandInfo[landid][lExists] = 0;
    LandInfo[landid][lOwnerID] = 0;
    Iter_Remove(Land, landid);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed land %i.", landid);

    DBLog("log_land", "%s (uid: %i) has removed land (id: %i) land owner (%i).", GetRPName(playerid), PlayerData[playerid][pID], landid, PlayerData[LandInfo[landid][lOwner]][pID]);
    return 1;
}

CMD:buyland(playerid, params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands.");
    }
    if (LandInfo[landid][lOwnerID] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This land is already owned.");
    }
    if (strcmp(params, "confirm", true))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /buyland [confirm] (This land costs %s.)", FormatCash(LandInfo[landid][lPrice]));
    }
    if (PlayerData[playerid][pCash] < LandInfo[landid][lPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this land.");
    }

    SetLandOwner(landid, playerid);
    GivePlayerCash(playerid, -LandInfo[landid][lPrice]);

    SendClientMessageEx(playerid, COLOR_GREEN, "You paid %s for this land! /landhelp to see the available commands for your land.", FormatCash(LandInfo[landid][lPrice]));
    DBLog("log_property", "%s (uid: %i) purchased a land (id: %i) in %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], LandInfo[landid][lID], GetPlayerZoneName(playerid), LandInfo[landid][lPrice]);
    return 1;
}

CMD:sellland(playerid, params[])
{
    new landid = GetNearbyLand(playerid), targetid, amount;

    if (landid == -1 || !IsLandOwner(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands of yours.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellland [playerid] [amount]");
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

    PlayerData[targetid][pLandOffer] = playerid;
    PlayerData[targetid][pLandOffered] = landid;
    PlayerData[targetid][pLandPrice] = amount;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you to buy their land for %s. (/accept land)", GetRPName(playerid), FormatCash(amount));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You offered %s to buy your land for %s.", GetRPName(targetid), FormatCash(amount));
    return 1;
}

CMD:sellmyland(playerid, params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !IsLandOwner(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands of yours.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmyland [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your land back to the state. You will receive %s back.", FormatCash(percent(LandInfo[landid][lPrice], 75)));
        return 1;
    }

    SetLandOwner(landid, INVALID_PLAYER_ID);
    GivePlayerCash(playerid, percent(LandInfo[landid][lPrice], 75));

    SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your land to the state and received %s back.", FormatCash(percent(LandInfo[landid][lPrice], 75)));
    DBLog("log_property", "%s (uid: %i) sold their land (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], LandInfo[landid][lID], percent(LandInfo[landid][lPrice], 75));
    return 1;
}

CMD:landinfo(playerid, params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands.");
    }

    if (!LandInfo[landid][lOwnerID])
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "* This land is currently not owned and is for sale, price: {00AA00}$%i{FFFFFF}.", LandInfo[landid][lPrice]);
    }
    else if (!IsLandOwner(playerid, landid))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "* This land is owned by %s.", LandInfo[landid][lOwner]);
    }
    else
    {
        DBFormat("SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
        DBExecute("LandInformation", "i", playerid);
    }

    return 1;
}

CMD:droplandkeys(playerid, params[])
{
    new landid;
    if (sscanf(params, "i", landid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /droplandkeys [landid]");
    }

    if (GetPlayerPropertyKey(playerid, PropertyType_Land, landid) != KeyRole_Unauthorized)
    {
        RemovePlayerPropertyAccess(playerid, PropertyType_Land, landid);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have dropped land %i's keys.", landid);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You don't have keys to a land.");
    }
    return 1;
}

CMD:land(playerid, params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands of yours.");
    }
    if (!PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have permission to build in this land.");
    }
    ShowPlayerLandMenu(playerid);
    return 1;
}

CMD:setlandobj(playerid,params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }

    new axecontrol[10],objectid;
    new Float:val;

    if (sscanf(params,"is[10]f", objectid, axecontrol, val))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setlandobj [objectid] [Z-RX-RY-RZ] [value]");
    }

    if (!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
    }
    if (Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
    }

    if (!strcmp(axecontrol,"z", true))
    {
        DBQuery("UPDATE landobjects SET pos_z = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
    }
    else if (!strcmp(axecontrol,"rx", true))
    {
        DBQuery("UPDATE landobjects SET rot_x = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
    }
    else if (!strcmp(axecontrol,"ry", true))
    {
        DBQuery("UPDATE landobjects SET rot_y = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
    }
    else if (!strcmp(axecontrol,"rz", true))
    {
        DBQuery("UPDATE landobjects SET rot_z = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
    }
    else
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setlandobj [objectid] [z-rx-ry-rz] [value]");
    }
    ReloadLandObject(objectid, LandInfo[landid][lLabels]);

    return SendClientMessageEx(playerid, COLOR_GREY, "The object %d has been updated.",objectid);
}

CMD:checklandobj(playerid,params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }

    new objectid;

    if (sscanf(params, "i", objectid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checklandobj [objectid]");
    }
    if (!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
    }
    if (Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
    }
    PlayerData[playerid][pSelected] = objectid;

    DBFormat("SELECT name, modelid, pos_x,pos_y,pos_z,rot_x,rot_y,rot_z FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
    DBExecute("LandObjectInfo", "i", playerid);
    return 1;
}

CMD:editlandobj(playerid,params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }

    new objectid;

    if (sscanf(params, "i", objectid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlandobj [objectid]");
    }
    if (!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
    }
    if (Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
    }

    PlayerData[playerid][pSelected] = objectid;
    if (Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't edit your gate while it is opened.");
    }

    PlayerData[playerid][pEditType] = EDIT_LAND_OBJECT;
    PlayerData[playerid][pEditObject] = objectid;
    PlayerData[playerid][pObjectLand] = landid;

    EditDynamicObject(playerid, objectid);
    GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
    return 1;
}

CMD:duplandobj(playerid,params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }

    new objectid;

    if (sscanf(params, "i", objectid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /duplandobj [objectid]");
    }
    if (!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
    }
    if (Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
    }

    PlayerData[playerid][pSelected] = objectid;
    PlayerData[playerid][pObjectLand] = landid;
    DBFormat("SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
    DBExecute("DuplicateLandObjectCheck", "i", playerid);
    return 1;
}

CMD:selllandobj(playerid,params[])
{
    new landid = GetNearbyLand(playerid);

    if (landid == -1 || !PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }

    new objectid;
    if (sscanf(params, "i", objectid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelandobj [objectid]");
    }
    if (!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
    }
    if (Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
    }

    PlayerData[playerid][pSelected] = objectid;

    DBFormat("SELECT name, price FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
    DBExecute("SellLandObject", "i", playerid);
    return 1;
}

CMD:editland(playerid, params[])
{
    new landid, option[32], param[32];
    if (!IsGodAdmin(playerid)  && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[32]S()[32]", landid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editland [landid] [option]");
        SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Price, Level, Height, Owner, Seized");
        return 1;
    }
    if (!IsValidLand(landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
    }
    if (!strcmp(option, "seized", true))
    {
        new value;
        if (sscanf(param, "i", value))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [0/1]", landid, option);
        }
        if (!(0<= value <= 1))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "Value cannot be less than 1 or more than 100M");
        }
        LandInfo[landid][lLabels] = 0;
        LandInfo[landid][lSeized] = value;
        DBQuery("UPDATE lands SET seized = %i WHERE id = %i", value, LandInfo[landid][lID]);

        ReloadAllLandObjects(landid);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's seized to %i.", landid, value);
    }
    else if (!strcmp(option, "price", true))
    {
        new value;
        if (sscanf(param, "i", value))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
        }
        if (!(1<= value <= 100000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "Value cannot be less than 1 or more than 100M");
        }
        LandInfo[landid][lPrice] = value;
        DBQuery("UPDATE lands SET price = %i WHERE id = %i", value, LandInfo[landid][lID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's price to %i.", landid, value);
        ReloadLand(landid);
    }
    else if (!strcmp(option, "level", true))
    {
        new value;
        if (sscanf(param, "i", value))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
        }
        if (!(1 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Land levels cannot be below 0 or more than 3");
        }
        LandInfo[landid][lLevel] = value;
        DBQuery("UPDATE lands SET level = %i WHERE id = %i", value, LandInfo[landid][lID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's price to %i.", landid, value);
        ReloadLand(landid);
    }
    else if (!strcmp(option, "height", true))
    {
        if (sscanf(param, "s", "confirm"))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [confirm]", landid, option);
        }

        GetPlayerPos(playerid, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]);
      //  LandInfo[landid][lPickup] = zCoord[1]; We need this, land pickup, when you create a land at height it will create a pickup like house pickup.
        DBQuery("UPDATE lands SET heightx = %f, heighty = %f, heightz = %f WHERE id = %i", LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ], LandInfo[landid][lID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have land %i's (height) pos to your current height Pos (%f %f %f).", landid, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]);
        ReloadLand(landid);
    }
    else if (!strcmp(option, "owner", true))
    {
        new targetid;
        if (sscanf(param, "u", targetid))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
        }
        SetLandOwner(landid, targetid);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's owner to %s.", landid, GetRPName(targetid));
        ReloadLand(landid);
    }
    return 1;
}

CMD:showlands(playerid, params[])
{
    if (!PlayerData[playerid][pShowLands])
    {
        ShowLandsOnMap(playerid, true);
        SendClientMessage(playerid, COLOR_AQUA, "You will now see lands on your mini-map.");
    }
    else
    {
        ShowLandsOnMap(playerid, false);
        SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any lands on your mini-map.");
    }

    return 1;
}

CMD:landhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** LAND HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** LAND ** /buyland /lock /door /landinfo /land /sellmyland /sellland /droplandkeys");
    SendClientMessage(playerid, COLOR_GREY, "** LAND ** /editlandobj /duplandobj /setlandobj /selllandobj /checklandobj");
    SendClientMessage(playerid, COLOR_GREY, "** LAND ** '/showlands' to show or hide lands on your mini-map.");
    return 1;
}

hook OnConfirmZoneCreation(playerid, ZoneType:type, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    if (type != ZoneType_Land || (!IsAdmin(playerid, ADMIN_LVL_10) && !PlayerData[playerid][pGangMod]))
    {
        return 1;
    }
    for (new i = 0; i < MAX_LANDS; i++)
    {
        if (!LandInfo[i][lExists])
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);

            DBFormat("INSERT INTO lands (price, min_x, min_y, max_x, max_y, heightx, heighty, heightz)"\
                     " VALUES(%i, '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
                     PlayerData[playerid][pLandCost], minx, miny, maxx, maxy, x, y, z);
            DBExecute("OnAdminCreateLand", "iiifffffff", playerid, i, PlayerData[playerid][pLandCost],
                      minx, miny, maxx, maxy, x, y, z);
            return 1;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "Land slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

ShowLandBuildTypeDialog(playerid)
{
    Dialog_Show(playerid, LandBuildType, DIALOG_STYLE_LIST, "Choose your browsing method.", "Browse by Model\nBrowse by List", "Select", "Back");
}

ShowLandBuildCategoryDialog(playerid)
{
    new string[4096];
    for (new i = 0; i < sizeof(landCategories); i ++)
    {
        if (i == 0)
            format(string, sizeof(string), "%s", landCategories[i]);
        else
            format(string, sizeof(string), "%s\n%s", string, landCategories[i]);
    }

    Dialog_Show(playerid, LandBuildCategory, DIALOG_STYLE_LIST, "Choose a category to browse.", string, "Select", "Back");
}

ShowLandObjectSelectionDialog(playerid)
{
    new string[4096];
    new index = -1;

    for (new i = 0; i < sizeof(landArray); i ++)
    {
        if (!strcmp(landArray[i][fCategory], landCategories[PlayerData[playerid][pCategory]]))
        {
            if (index == -1)
            {
                index = i;
            }

            format(string, sizeof(string), "%s\n%s (%s)", string, landArray[i][fName], FormatCash(landArray[i][fPrice]));
        }
    }

    LandObjectIndex[playerid] = index;
    Dialog_Show(playerid, LandObjectSelection, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Back");
}

ShowLandEditObjectDialog(playerid)
{
    if (IsGateObject(PlayerData[playerid][pSelected]))
    {
        Dialog_Show(playerid, LandEditObject, DIALOG_STYLE_LIST, "Choose how you want to edit this object.", "Edit object\nEdit gate destination\nDuplicate object\nSell object", "Select", "Back");
    }
    else
    {
        Dialog_Show(playerid, LandEditObject, DIALOG_STYLE_LIST, "Choose how you want to edit this object.", "Edit object\nDuplicate object\nSell object", "Select", "Back");
    }
}

ShowLandObjectsDialog(playerid)
{
    new landid = GetNearbyLand(playerid);
    if (landid >= 0 && PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
    {
        DBFormat("SELECT * FROM landobjects WHERE landid = %i ORDER BY id DESC LIMIT %i, %i", LandInfo[landid][lID], (PlayerData[playerid][pPage] - 1) * MAX_LISTED_OBJECTS, MAX_LISTED_OBJECTS);
        DBExecute("LandObjectList", "i", playerid);
    }
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    switch (PlayerData[playerid][pEditType])
    {
        case EDIT_LAND_OBJECT_PREVIEW:
        {
            if (response != EDIT_RESPONSE_UPDATE)
            {
                DestroyDynamicObject(PlayerData[playerid][pEditObject]);
                PlayerData[playerid][pEditObject] = INVALID_OBJECT_ID;
                PlayerData[playerid][pEditType] = 0;

                if (response == EDIT_RESPONSE_FINAL)
                {
                    new landid = PlayerData[playerid][pObjectLand];

                    if (landid >= 0 && PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
                    {
                        if (PlayerData[playerid][pCash] < landArray[PlayerData[playerid][pSelected]][fPrice])
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You couldn't afford to purchase this item.");
                        }
                        if (!IsPointInLand(landid, x, y))
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "The object has exceeded the boundaries for your land.");
                        }

                        new string[16];

                        GivePlayerCash(playerid, -landArray[PlayerData[playerid][pSelected]][fPrice]);

                        DBQuery("INSERT INTO landobjects VALUES(null, %i, %i, '%e', %i, '%f', '%f', '%f', '%f', '%f', '%f', 0, 0, '0.0', '0.0', '0.0', '-1000.0', '-1000.0', '-1000.0')", LandInfo[landid][lID], landArray[PlayerData[playerid][pSelected]][fModel], landArray[PlayerData[playerid][pSelected]][fName], landArray[PlayerData[playerid][pSelected]][fPrice], x, y, z, rx, ry, rz);
                        DBQueryWithCallback("SELECT * FROM landobjects WHERE id = LAST_INSERT_ID()", "OnLoadLandObjects", "i", LandInfo[landid][lLabels]);

                        format(string, sizeof(string), "~r~-$%i", landArray[PlayerData[playerid][pSelected]][fPrice]);
                        GameTextForPlayer(playerid, string, 5000, 1);
                        UpdateLandText(landid);
                        if (!strcmp(landArray[PlayerData[playerid][pSelected]][fCategory], "Doors & Gates"))
                        {
                            if (IsGateModel(landArray[PlayerData[playerid][pSelected]][fModel]))
                            {
                                SendClientMessage(playerid, COLOR_WHITE, "You can use /gate to open and close your gate. To change the destination coordinates, use /land and choose 'Edit object'.");
                            }
                            else
                            {
                                SendClientMessage(playerid, COLOR_WHITE, "You can use /door to control your door and /lock to unlock or lock it.");
                            }
                        }
                    }
                }
                else if (response == EDIT_RESPONSE_CANCEL)
                {
                    if (PlayerData[playerid][pMenuType] == 0)
                        ShowLandObjects(playerid, MODEL_SELECTION_LANDOBJECTS);
                    else
                        ShowLandObjectSelectionDialog(playerid);
                }
            }
        }
        case EDIT_LAND_OBJECT:
        {
            if (response != EDIT_RESPONSE_UPDATE)
            {
                if (response == EDIT_RESPONSE_FINAL)
                {
                    if (!IsPointInLand(PlayerData[playerid][pObjectLand], x, y))
                    {
                        SendClientMessage(playerid, COLOR_GREY, "The object has exceeded the boundaries for your land.");
                    }
                    else
                    {
                        DBQuery("UPDATE landobjects SET pos_x = '%f', pos_y = '%f', pos_z = '%f', rot_x = '%f', rot_y = '%f', rot_z = '%f' WHERE id = %i", x, y, z, rx, ry, rz, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
                        SendClientMessage(playerid, COLOR_GREY, "Changes saved.");
                    }
                }

                ReloadLandObject(objectid, LandInfo[PlayerData[playerid][pObjectLand]][lLabels]);
                PlayerData[playerid][pEditType] = 0;
            }
        }
        case EDIT_LAND_GATE_MOVE:
        {
            if (response != EDIT_RESPONSE_UPDATE)
            {
                if (response == EDIT_RESPONSE_FINAL)
                {
                    if (!IsPointInLand(PlayerData[playerid][pObjectLand], x, y))
                    {
                        SendClientMessage(playerid, COLOR_GREY, "The object has exceeded the boundaries for your land.");
                    }
                    else
                    {
                        DBQuery("UPDATE landobjects SET move_x = '%f', move_y = '%f', move_z = '%f', move_rx = '%f', move_ry = '%f', move_rz = '%f' WHERE id = %i", x, y, z, rx, ry, rz, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
                        SendClientMessage(playerid, COLOR_GREY, "Changes saved.");
                    }
                }

                ReloadLandObject(objectid, LandInfo[PlayerData[playerid][pObjectLand]][lLabels]);
                PlayerData[playerid][pEditType] = 0;
            }
        }
    }
    return 1;
}

hook OnPlayerMenuResponse(playerid, extraid, response, listitem, modelid)
{
    switch (extraid)
    {
        case MODEL_SELECTION_LANDOBJECTS:
        {
            if (response && listitem >= 0)
            {
                new landid = GetNearbyLand(playerid);
                if (landid >= 0 && PlayerHasPropertyAccess(playerid, PropertyType_Land, landid, KeyAccess_Edit))
                {
                    PurchaseLandObject(playerid, landid, listitem + LandObjectIndex[playerid]);
                }
            }
            else
            {
                ShowLandBuildCategoryDialog(playerid);
            }
        }
    }
    return 1;
}
