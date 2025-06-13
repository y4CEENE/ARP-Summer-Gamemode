/// @file      House.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include "properties/HouseMenu.pwn"

//TODO: give 75% of furniture cost when sold

static FurniturePreviewIndex[MAX_PLAYERS];

hook OnGameModeInit()
{
    // House Lights
    houseLights = TextDrawCreate(0.0, 0.0, "|");
    TextDrawUseBox(houseLights, 1);
    TextDrawBoxColor(houseLights, 0x000000BB);
    TextDrawTextSize(houseLights, 660.000000, 22.000000);
    TextDrawAlignment(houseLights, 0);
    TextDrawBackgroundColor(houseLights, 0x000000FF);
    TextDrawFont(houseLights, 3);
    TextDrawLetterSize(houseLights, 1.000000, 52.200000);
    TextDrawColor(houseLights, 0x000000FF);
    TextDrawSetOutline(houseLights, 1);
    TextDrawSetProportional(houseLights, 1);
    TextDrawSetShadow(houseLights, 1);
}

GetHouseStashCapacity(houseid, item)
{
    return houseStashCapacities[HouseInfo[houseid][hLevel] - 1][item];
}

GetHouseTenantCapacity(houseid)
{
    switch (HouseInfo[houseid][hLevel])
    {
        case 1: return  5;
        case 2: return 10;
        case 3: return 15;
        case 4: return 20;
        case 5: return 25;
        case 6: return 30;
    }

    return 0;
}

GetHouseFurnitureCapacity(houseid)
{
    switch (HouseInfo[houseid][hLevel])
    {
        case 1: return  50;
        case 2: return  80;
        case 3: return 110;
        case 4: return 140;
        case 5: return 170;
        case 6: return 200;
    }

    return 0;
}

GetRandomHouse(playerid) // For pizzaboy job.
{
    new index, houseIDs[MAX_HOUSES] = {-1, ...};

    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && HouseInfo[i][hOutsideInt] == 0 && HouseInfo[i][hOutsideVW] == 0)
        {
            if (300.0 <= GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]) <= 1200.0)
            {
                if (HouseInfo[i][hDelivery])
                {
                    houseIDs[index++] = i;
                }
            }
        }
    }

    if (index == 0)
    {
        return -1;
    }

    return houseIDs[random(index)];
}

GetNearbyHouseEx(playerid)
{
    return GetNearbyHouse(playerid) == INVALID_HOUSE_ID ? GetInsideHouse(playerid) : GetNearbyHouse(playerid);
}

IsPointInsideHouse(houseid, Float:x, Float:y, Float:z, int, vw)
{
    return HouseInfo[houseid][hExists] &&
           GetDistanceBetweenPoints(x, y, z, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ]) < 30.0 &&
           int == HouseInfo[houseid][hInterior] && vw == HouseInfo[houseid][hWorld];
}

GetNearbyHouse(playerid)
{
    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hOutsideInt] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hOutsideVW])
        {
            return i;
        }
    }

    return INVALID_HOUSE_ID;
}

GetInsideHouse(playerid)
{
    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && IsPlayerInRangeOfPoint(playerid, 100.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hInterior] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hWorld])
        {
            return i;
        }
    }

    return -1;
}

SetHouseOwner(houseid, playerid)
{
    if (playerid == INVALID_PLAYER_ID)
    {
        strcpy(HouseInfo[houseid][hOwner], "Nobody", MAX_PLAYER_NAME);
        HouseInfo[houseid][hOwnerID] = 0;
    }
    else
    {
        GetPlayerName(playerid, HouseInfo[houseid][hOwner], MAX_PLAYER_NAME);
        HouseInfo[houseid][hOwnerID] = PlayerData[playerid][pID];
    }
    HouseInfo[houseid][hTimestamp] = gettime();
    DBQuery("UPDATE houses SET timestamp = %i, ownerid = %i, owner = '%e' WHERE id = %i", HouseInfo[houseid][hTimestamp], HouseInfo[houseid][hOwnerID], HouseInfo[houseid][hOwner], HouseInfo[houseid][hID]);
    ReloadHouse(houseid);
}

CountPlayerHouses(playerid)
{
    new count = 0;
    for (new i = 0; i < MAX_HOUSES; i++)
    {
        if (HouseInfo[i][hExists])
        {
            if (IsHouseOwner(playerid, i))
            {
                count++;
            }
        }
    }
    return count;
}

ReloadHouse(houseid)
{
    if (HouseInfo[houseid][hExists])
    {
        new string[268];
        new type[16];

        DestroyDynamic3DTextLabel(HouseInfo[houseid][hText]);
        DestroyDynamicPickup(HouseInfo[houseid][hPickup]);

        if (HouseInfo[houseid][hType] == -1)
        {
            type = "Other";
        }
        else
        {
            strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
        }

        if (HouseInfo[houseid][hOwnerID] == 0)
        {
            format(string, sizeof(string), "{AAC4E5}[HOUSE FOR SALE] ({FFFFFF}ID %i{AAC4E5})\n{FFFFFF}Class: {AAC4E5}%s\n{FFFFFF}House Level: {AAC4E5}%i\n{FFFFFF}Price: {AAC4E5}%s", houseid, type, HouseInfo[houseid][hLevel], FormatCash(HouseInfo[houseid][hPrice]));
            HouseInfo[houseid][hPickup] = CreateDynamicPickup(1273, 1, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
        }
        else
        {
            if (HouseInfo[houseid][hRentPrice] > 0)
            {
                format(string, sizeof(string), "{AAC4E5}[HOUSE] ({FFFFFF}ID %i{AAC4E5})\n{FFFFFF}Owner: {AAC4E5}%s\n{FFFFFF}Class: {AAC4E5}%s\n{FFFFFF}Rent: {AAC4E5}$%i\n{FFFFFF}House Level: {AAC4E5}%i", houseid, HouseInfo[houseid][hOwner], type, HouseInfo[houseid][hRentPrice], HouseInfo[houseid][hLevel]);
            }
            else
            {
                format(string, sizeof(string), "{AAC4E5}[HOUSE] ({FFFFFF}ID %i{AAC4E5})\n{FFFFFF}Owner: {AAC4E5}%s\n{FFFFFF}Class: {AAC4E5}%s\n{FFFFFF}House Level: {AAC4E5}%i", houseid, HouseInfo[houseid][hOwner], type, HouseInfo[houseid][hLevel]);
            }
            HouseInfo[houseid][hPickup] = CreateDynamicPickup(19522, 1, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
        }

        HouseInfo[houseid][hText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]+0.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, HouseInfo[houseid][hOutsideVW], HouseInfo[houseid][hOutsideInt], -1 , 10.0);
        //HouseInfo[houseid][hMapIcon] = CreateDynamicMapIcon(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 31, 1, -1, -1, -1, 100.0);
    }
}

IsValidFurnitureID(id)
{
    return (id >= 0 && id < MAX_FURNITURE) && Furniture[id][fExists];
}

IsValidHouse(id)
{
    return (id >= 0 && id < MAX_HOUSES) && HouseInfo[id][hExists];
}
IsHouseOwner(playerid, houseid)
{
    if (houseid == -1)
    {
        return false;
    }
    return (HouseInfo[houseid][hOwnerID] == PlayerData[playerid][pID]);
}

PreviewFurniture(playerid, index)
{
    new Float:x;
    new Float:y;
    new Float:z;
    new Float:angle;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);

    x += 2.0 * floatsin(-angle, degrees);
    y += 2.0 * floatcos(-angle, degrees);

    if (IsValidDynamicObject(gPreviewFurniture[playerid]))
    {
        DestroyDynamicObject(gPreviewFurniture[playerid]);
    }

    FurniturePreviewIndex[playerid] = index;
    gPreviewFurniture[playerid] = CreateDynamicObject(g_FurnitureList[index][e_ModelID], x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    EditDynamicObjectEx(playerid, EDIT_TYPE_PREVIEW, gPreviewFurniture[playerid]);
    SendInfoMessage(playerid, "Press ESC to cancel. Click the disk icon to save changes.");
    return 1;
}

ShowFurniturePreviewer(playerid)
{
    new
        models[MAX_SELECTION_MENU_ITEMS] = {-1, ...},
        index;

    FurniturePreviewIndex[playerid] = -1;

    for (new i = 0; i < sizeof(g_FurnitureList); i ++)
    {
        if (g_FurnitureList[i][e_ModelCategory] == PlayerData[playerid][pSelected])
        {
            if (FurniturePreviewIndex[playerid] == -1)
            {
                FurniturePreviewIndex[playerid] = i;
            }

            models[index++] = g_FurnitureList[i][e_ModelID];
        }
    }
    ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_FURNITURE, "House Furniture", models, index);
    return 0;
}

ReloadFurniture(furniture)
{
    if (!IsValidFurnitureID(furniture))
    {
        return 0;
    }
    DestroyDynamicObject(Furniture[furniture][fObject]);
    Furniture[furniture][fObject] = CreateDynamicObject(Furniture[furniture][fModel],    Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1],
                                                        Furniture[furniture][fSpawn][2], Furniture[furniture][fSpawn][3], Furniture[furniture][fSpawn][4],
                                                        Furniture[furniture][fSpawn][5], Furniture[furniture][fWorld], Furniture[furniture][fInterior]);

    Streamer_SetExtraInt(Furniture[furniture][fObject], E_OBJECT_TYPE,     E_OBJECT_FURNITURE);
    Streamer_SetExtraInt(Furniture[furniture][fObject], E_OBJECT_INDEX_ID, Furniture[furniture][fID]);
    Streamer_SetExtraInt(Furniture[furniture][fObject], E_OBJECT_EXTRA_ID, Furniture[furniture][fHouseId]);
    for (new i = 0; i != 3; i ++)
    {
        if (MaterialIDs[Furniture[furniture][fMaterial][i]][ModelID] != 0)
        {
            SetDynamicObjectMaterial(Furniture[furniture][fObject], i, MaterialIDs[Furniture[furniture][fMaterial][i]][ModelID], MaterialIDs[Furniture[furniture][fMaterial][i]][TxdName], MaterialIDs[Furniture[furniture][fMaterial][i]][TextureName], MaterialColors[Furniture[furniture][fMatColour][i]][ColorHex]);
        }
        else if (Furniture[furniture][fMatColour][i] != 0)
        {
            SetDynamicObjectMaterial(Furniture[furniture][fObject], i, -1, MaterialIDs[Furniture[furniture][fMaterial][i]][TxdName], MaterialIDs[Furniture[furniture][fMaterial][i]][TextureName], MaterialColors[Furniture[furniture][fMatColour][i]][ColorHex]);
        }
    }
    ReloadFurnitureText(furniture);
    return 1;
}

SetHouseEditMode(houseid, enable)
{
    HouseInfo[houseid][hLabels] = enable;
    for (new i = 0; i < MAX_FURNITURE; i++)
    {
        if (Furniture[i][fExists] && Furniture[i][fHouseId] == houseid)
        {
            ReloadFurnitureText(i);
        }
    }
}

ReloadFurnitureText(furniture)
{
    new string[64];
    if (!IsValidFurnitureID(furniture))
    {
        return 0;
    }
    DestroyDynamic3DTextLabel(Furniture[furniture][fText]);

    if (HouseInfo[Furniture[furniture][fHouseId]][hLabels])
    {
        format(string, sizeof(string), "ID: {00FF00}%i{FFFFFF}\n/edit, /delete.", furniture);
        Furniture[furniture][fText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
    }
    else
    {
        if (Furniture[furniture][fModel] == 2332)
        {
            if (Furniture[furniture][fSafeOpen])
            {
                Furniture[furniture][fText] = CreateDynamic3DTextLabel("Status: {00FF00}Opened{AFAFAF}\nPress Y to use safe", COLOR_GREY, Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
            }
            else
            {
                Furniture[furniture][fText] = CreateDynamic3DTextLabel("Status: {FF5030}Closed{AFAFAF}\nPress Y to use safe", COLOR_GREY, Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
            }
        }
        else
        {
            Furniture[furniture][fText] = INVALID_3DTEXT_ID;
        }
    }
    return 1;
}

SaveFurniture(furniture)
{
    if (!IsValidFurnitureID(furniture)) return 0;

    DBQuery("UPDATE rp_furniture SET fModel = %i, fX = %.4f, fY = %.4f, fZ = %.4f, fRX = %.4f, fRY = %.4f, fRZ = %.4f, fInterior = %i, fWorld = %i, fCode = %i, fMoney = %i, Mat1 = %i, Mat2 = %i, Mat3 = %i, MatColor1 = %i, MatColor2 = %i, MatColor3 = %i WHERE fID = %i",
        Furniture[furniture][fModel],
        Furniture[furniture][fSpawn][0],
        Furniture[furniture][fSpawn][1],
        Furniture[furniture][fSpawn][2],
        Furniture[furniture][fSpawn][3],
        Furniture[furniture][fSpawn][4],
        Furniture[furniture][fSpawn][5],
        Furniture[furniture][fInterior],
        Furniture[furniture][fWorld],
        Furniture[furniture][fCode],
        Furniture[furniture][fMoney],
        Furniture[furniture][fMaterial][0],
        Furniture[furniture][fMaterial][1],
        Furniture[furniture][fMaterial][2],
        Furniture[furniture][fMatColour][0],
        Furniture[furniture][fMatColour][1],
        Furniture[furniture][fMatColour][2],
        Furniture[furniture][fID]
    );
    return 1;
}

DeleteFurniture(furniture)
{
    if (!IsValidFurnitureID(furniture))
    {
        return 0;
    }

    DestroyDynamicObject(Furniture[furniture][fObject]);
    DestroyDynamic3DTextLabel(Furniture[furniture][fText]);

    DBQuery("DELETE FROM rp_furniture WHERE fID = %i", Furniture[furniture][fID]);

    Furniture[furniture][fID] = 0;
    Furniture[furniture][fExists] = 0;
    Furniture[furniture][fObject] = INVALID_OBJECT_ID;
    Furniture[furniture][fText] = INVALID_3DTEXT_ID;
    return 1;
}

ShowFurnitureCategories(playerid)
{
    new string[192];

    for (new i = 0; i < sizeof(g_FurnitureTypes); i ++)
    {
        strcat(string, g_FurnitureTypes[i]);
        strcat(string, "\n");
    }
    Dialog_Show(playerid, BuyFurniture, DIALOG_STYLE_LIST, "{FFFFFF}Select category", string, "Select", "Cancel");
}

GetNextFurnitureID()
{
    for (new i = 0; i < MAX_FURNITURE; i ++)
    {
        if (!Furniture[i][fExists])
        {
            return i;
        }
    }
    return -1;
}

AddFurniture(house, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, interior, worldid)
{
    new id = GetNextFurnitureID();

    if (id != -1)
    {
        Furniture[id][fExists] = 1;
        Furniture[id][fHouseId] = house;
        Furniture[id][fHouseDbId] = HouseInfo[house][hID];
        Furniture[id][fModel] = modelid;
        Furniture[id][fSpawn][0] = x;
        Furniture[id][fSpawn][1] = y;
        Furniture[id][fSpawn][2] = z;
        Furniture[id][fSpawn][3] = rx;
        Furniture[id][fSpawn][4] = ry;
        Furniture[id][fSpawn][5] = rz;
        Furniture[id][fInterior] = interior;
        Furniture[id][fWorld] = worldid;
        Furniture[id][fCode] = 0;
        Furniture[id][fMoney] = 0;
        Furniture[id][fSafeOpen] = 0;
        Furniture[id][fDoorOpen] = 0;
        Furniture[id][fObject] = INVALID_OBJECT_ID;
        Furniture[id][fText] = INVALID_3DTEXT_ID;

        for (new i = 0; i != 3; i ++)
        {
            Furniture[id][fMaterial][i] = 0;
            Furniture[id][fMatColour][i] = 0;
        }

        ReloadFurniture(id);

        DBFormat("INSERT INTO rp_furniture (fHouseID) VALUES (%i)", Furniture[id][fHouseDbId]);
        DBExecute("OnFurnitureAdded", "i", id);
    }
    return id;
}

DB:OnFurnitureAdded(furniture)
{
    Furniture[furniture][fID] = GetDBInsertID();
    SaveFurniture(furniture);
}


FurnitureChange(playerid, furnid, index, list, status = 1) // 1 for mat, 2 for color
{
    new model, txd[24], texture[24], color;
    switch (status)
    {
        case 1:
        {
            SendClientMessage(playerid, -1, "Furniture texture has been updated.");
            Furniture[furnid][fMaterial][index] = list;
            SetDynamicObjectMaterial(Furniture[furnid][fObject], index, MaterialIDs[ Furniture[furnid][fMaterial][index] ][ModelID], MaterialIDs[ Furniture[furnid][fMaterial][index] ][TxdName], MaterialIDs[ Furniture[furnid][fMaterial][index] ][TextureName], MaterialColors[ Furniture[furnid][fMatColour][index] ][ColorHex]);
            SaveFurniture(furnid);
        }
        case 2:
        {
            if (Furniture[furnid][fMaterial][index] == 0)
            {
                Furniture[furnid][fMatColour][index] = list;
                SetDynamicObjectMaterial(Furniture[furnid][fObject], index, -1, MaterialIDs[ Furniture[furnid][fMaterial][index] ][TxdName], MaterialIDs[ Furniture[furnid][fMaterial][index] ][TextureName], MaterialColors[ Furniture[furnid][fMatColour][index] ][ColorHex]);
                SaveFurniture(furnid);
            }
            else
            {
                SendClientMessage(playerid, -1, "Furniture color has been updated.");
                Furniture[furnid][fMatColour][index] = list;
                GetDynamicObjectMaterial(Furniture[furnid][fObject], index, model, txd, texture, color);
                SetDynamicObjectMaterial(Furniture[furnid][fObject], index, model, txd, texture, MaterialColors[ Furniture[furnid][fMatColour][index] ][ColorHex]);
                SaveFurniture(furnid);
            }
        }
    }
    return 1;
}

DB:OnPlayerRentHouse(playerid, houseid)
{
    if (GetDBIntFieldFromIndex(0, 0) >= GetHouseTenantCapacity(houseid))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "This house has reached its limit of %i tenants.", GetHouseTenantCapacity(houseid));
    }
    else
    {
        //Dialog_Show(HouseInfo[houseid][hOwner], DIALOG_HOUSERENT, DIALOG_STYLE_MSGBOX, "House Rent", "%s is trying to rent a room in your house, do you accept it?", "Accept", "Decline");
        //SendClientMessage(playerid, COLOR_GREY, "Your renting deal has been sent to the owner, please wait.");
        DBQuery("UPDATE "#TABLE_USERS" SET rentinghouse = %i WHERE uid = %i", HouseInfo[houseid][hID], PlayerData[playerid][pID]);

        PlayerData[playerid][pRentingHouse] = HouseInfo[houseid][hID];
        SendClientMessageEx(playerid, COLOR_GREEN, "You are now renting at %s's house. You will pay %s every paycheck.", HouseInfo[houseid][hOwner], FormatCash(HouseInfo[houseid][hRentPrice]));
    }
}

DB:OnAdminCreateHouse(playerid, houseid, type, Float:x, Float:y, Float:z, Float:angle)
{
    strcpy(HouseInfo[houseid][hOwner], "Nobody", MAX_PLAYER_NAME);

    HouseInfo[houseid][hExists] = 1;
    HouseInfo[houseid][hID] = GetDBInsertID();
    HouseInfo[houseid][hOwnerID] = 0;
    HouseInfo[houseid][hType] = type;
    HouseInfo[houseid][hPrice] = houseInteriors[type][intPrice];
    HouseInfo[houseid][hRentPrice] = 0;
    HouseInfo[houseid][hLevel] = 1;
    HouseInfo[houseid][hLocked] = 0;
    HouseInfo[houseid][hPosX] = x;
    HouseInfo[houseid][hPosY] = y;
    HouseInfo[houseid][hPosZ] = z;
    HouseInfo[houseid][hPosA] = angle;
    HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
    HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
    HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
    HouseInfo[houseid][hIntA] = houseInteriors[type][intA];
    HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
    HouseInfo[houseid][hWorld] = HouseInfo[houseid][hID] + 1000000;
    HouseInfo[houseid][hOutsideInt] = GetPlayerInterior(playerid);
    HouseInfo[houseid][hOutsideVW] = GetPlayerVirtualWorld(playerid);
    HouseInfo[houseid][hCash] = 0;
    HouseInfo[houseid][hMaterials] = 0;
    HouseInfo[houseid][hWeed] = 0;
    HouseInfo[houseid][hCocaine] = 0;
    HouseInfo[houseid][hHeroin] = 0;
    HouseInfo[houseid][hPainkillers] = 0;
    HouseInfo[houseid][hLabels] = 0;
    HouseInfo[houseid][hText] = Text3D:INVALID_3DTEXT_ID;
    HouseInfo[houseid][hPickup] = -1;
    HouseInfo[houseid][hDelivery] = 1;
    HouseInfo[houseid][hLights] = 1;
    Iter_Add(House, houseid);
    for (new i = 0; i < 10; i ++)
    {
        HouseInfo[houseid][hWeapons][i] = 0;
    }
    DBQuery("UPDATE houses SET world = %i WHERE id = %i", HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
    ReloadHouse(houseid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created house id %i, type %i.",GetAdmCmdRank(playerid), GetRPName(playerid), houseid, HouseInfo[houseid][hType]);
    SendClientMessageEx(playerid, COLOR_GREEN, "* House %i created successfully.", houseid);
}

DB:OnLoadFurniture()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows; i ++)
    {
        Furniture[i][fID] = GetDBIntField(i, "fID");
        Furniture[i][fHouseDbId] = GetDBIntField(i, "fHouseID");
        Furniture[i][fHouseId] = GetHouseID(Furniture[i][fHouseDbId]);
        if (Furniture[i][fHouseId] == INVALID_HOUSE_ID)
        {
            printf("[Warning] Furniture %i doesn't belongs to any house", Furniture[i][fID]);
            continue; // SKIP
        }

        Furniture[i][fExists] = 1;

        Furniture[i][fModel] = GetDBIntField(i, "fModel");
        Furniture[i][fSpawn][0] = GetDBFloatField(i, "fX");
        Furniture[i][fSpawn][1] = GetDBFloatField(i, "fY");
        Furniture[i][fSpawn][2] = GetDBFloatField(i, "fZ");
        Furniture[i][fSpawn][3] = GetDBFloatField(i, "fRX");
        Furniture[i][fSpawn][4] = GetDBFloatField(i, "fRY");
        Furniture[i][fSpawn][5] = GetDBFloatField(i, "fRZ");
        Furniture[i][fInterior] = GetDBIntField(i, "fInterior");
        Furniture[i][fWorld] = GetDBIntField(i, "fWorld");
        Furniture[i][fCode] = GetDBIntField(i, "fCode");
        Furniture[i][fMoney] = GetDBIntField(i, "fMoney");

        Furniture[i][fMaterial][0] = GetDBIntField(i, "Mat1");
        Furniture[i][fMaterial][1] = GetDBIntField(i, "Mat2");
        Furniture[i][fMaterial][2] = GetDBIntField(i, "Mat3");
        Furniture[i][fMatColour][0] = GetDBIntField(i, "MatColor1");
        Furniture[i][fMatColour][1] = GetDBIntField(i, "MatColor2");
        Furniture[i][fMatColour][2] = GetDBIntField(i, "MatColor3");

        Furniture[i][fObject] = INVALID_OBJECT_ID;
        Furniture[i][fText] = INVALID_3DTEXT_ID;
        ReloadFurniture(i);
    }
    printf("[Script] %i furnitures loaded.", rows);
}

Dialog:HouseInteriors(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new houseid = GetNearbyHouseEx(playerid);

        if (houseid >= 0 && IsHouseOwner(playerid, houseid))
        {
            SetFreezePos(playerid, houseInteriors[listitem][intX], houseInteriors[listitem][intY], houseInteriors[listitem][intZ]);
            SetPlayerFacingAngle(playerid, houseInteriors[listitem][intA]);
            SetPlayerInterior(playerid, houseInteriors[listitem][intID]);
            SetCameraBehindPlayer(playerid);

            PlayerData[playerid][pPreviewHouse] = houseid;
            PlayerData[playerid][pPreviewType] = listitem;
            PlayerData[playerid][pPreviewTime] = 60;

            SendClientMessageEx(playerid, COLOR_AQUA, "This {FF6347}%s{33CCFF} interior costs %s. You have 60 seconds to look around and make up your mind.", houseInteriors[listitem][intClass], FormatCash(houseInteriors[listitem][intPrice]));
            SendClientMessageEx(playerid, COLOR_AQUA, "Use /confirmupgrade if you wish to upgrade to this interior. Use /cancelupgrade to cancel preview mode.");
        }
    }
    return 1;
}

Dialog:LocateHouse(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        foreach(new i : House)
        {
            if (HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
            {
                SetActiveCheckpoint(playerid, CHECKPOINT_MISC, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ], 2.5);
                SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to your house.");
            }
        }
    }
    return 1;
}

RemoveAllFurniture(houseid)
{
    if (HouseInfo[houseid][hExists])
    {
        for (new i = 0; i < MAX_FURNITURE; i ++)
        {
            if (Furniture[i][fExists] && Furniture[i][fHouseDbId] == HouseInfo[houseid][hID])
            {
                new objectid = Furniture[i][fObject];
                if (IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
                {
                    new Text3D:textid = Text3D:Streamer_GetExtraInt(objectid, E_OBJECT_3DTEXT_ID);
                    if (IsValidDynamic3DTextLabel(textid))
                    {
                        DestroyDynamic3DTextLabel(textid);
                    }
                    DestroyDynamicObject(objectid);
                }
            }
        }

        DBQuery("DELETE FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);

    }
}

DisplayPlayerHousesList(playerid,target[])
{
    new targetid,useid=true;
    if (sscanf(target, "i", targetid))
        useid=false;
    else if (targetid>MAX_PLAYERS)
        return SendClientMessage(playerid,COLOR_GREY, "Unvalid player id.");

    new housestring[1064], type[16];
    housestring = "ID\tOwner\tHouse Type - Locations\tStatus";

    foreach(new i : House)
    {
        new displayrow=false;
        if (!HouseInfo[i][hExists])
            continue;
        if (HouseInfo[i][hType] == -1)
        {
            type = "Other";
        }
        else
        {
            strcpy(type, houseInteriors[HouseInfo[i][hType]][intClass]);
        }
        if (useid)
        {
            displayrow = IsHouseOwner(targetid, i);
        }
        else
        {
            displayrow = (strcmp(HouseInfo[i][hOwner], target, true)==0) || (!strcmp(target,"all",true,4));
        }
        if (displayrow)
        {
            format(housestring, sizeof(housestring), "%s\n%d\t%s\t%s - %s\t%s",housestring, i,  HouseInfo[i][hOwner],type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (HouseInfo[i][hLocked]) ? ("Locked") : ("Unlocked"));
        }
    }
    if (strlen(housestring) > 0)
    {
        Dialog_Show(playerid, PlayerHousesList, DIALOG_STYLE_TABLIST_HEADERS, "Houses list", housestring, "Preview","Close");
    }
    return 1;
}

Dialog:PlayerHousesList(playerid, response, listitem, inputtext[])
{

    if (response)
    {
        new houseid;
        new type[16];

        if (sscanf(inputtext,"i",houseid))
        {
            return SendClientMessage(playerid,COLOR_RED,"Can't parse house id contact an admin to fix that.");
        }
        //SendClientMessageEx(playerid,COLOR_RED,"Selected value: '%s', Parsed value: %i", inputtext, houseid);

        if (HouseInfo[houseid][hType] == -1)
        {
            type = "Other";
        }
        else
        {
            strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
        }
        //SendClientMessage(playerid,COLOR_RED,"Step 1");
        new liststr[1024];
        format(liststr, sizeof(liststr),
            "hID\t%i\nOwner\t%s\nType\t%s\nPrice\t $%i\nRentPrice\t%i\nLevel\t%i\nLocked\t%s\n"\
            "Alarm\t%i\nCash\t%i\nMaterials\t%i\nWeed\t%i\nCocaine\t%i\nHeroin\t%i\nPainkillers\t%i\n"\
            "Delivery\t%s\nLights\t%s\nWeapon slot 0\t%s\nWeapon slot 1\t%s\nWeapon slot 2\t%s\n"\
            "Weapon slot 3\t%s\nWeapon slot 4\t%s\nWeapon slot 5\t%s\nWeapon slot 6\t%s\n"\
            "Weapon slot 7\t%s\nWeapon slot 8\t %s \nWeapon slot 9\t %s",
            HouseInfo[houseid][hID],
            HouseInfo[houseid][hOwner],
            type,
            HouseInfo[houseid][hPrice],
            HouseInfo[houseid][hRentPrice],
            HouseInfo[houseid][hLevel],
            HouseInfo[houseid][hLocked]?("Closed"):("Open"),
            HouseInfo[houseid][hAlarm],
            HouseInfo[houseid][hCash],
            HouseInfo[houseid][hMaterials],
            HouseInfo[houseid][hWeed],
            HouseInfo[houseid][hCocaine],
            HouseInfo[houseid][hHeroin],
            HouseInfo[houseid][hPainkillers],
            HouseInfo[houseid][hDelivery]?("Enabled"):("Disabled"),
            HouseInfo[houseid][hLights]?("On"):("Off"),
            HouseInfo[houseid][hWeapons][0] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][0]):("None"),
            HouseInfo[houseid][hWeapons][1] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][1]):("None"),
            HouseInfo[houseid][hWeapons][2] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][2]):("None"),
            HouseInfo[houseid][hWeapons][3] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][3]):("None"),
            HouseInfo[houseid][hWeapons][4] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][4]):("None"),
            HouseInfo[houseid][hWeapons][5] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][5]):("None"),
            HouseInfo[houseid][hWeapons][6] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][6]):("None"),
            HouseInfo[houseid][hWeapons][7] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][7]):("None"),
            HouseInfo[houseid][hWeapons][8] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][8]):("None"),
            HouseInfo[houseid][hWeapons][9] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][9]):("None")
        );
        //SendClientMessage(playerid,COLOR_RED,"Step2");
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST, "House status", liststr, "Ok", "");
    }
    return 1;
}

Dialog:BuyFurniture(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new houseid = GetInsideHouse(playerid);
        if (houseid >= 0)
        {
            DBFormat("SELECT COUNT(*) AS furnitureCount FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);
            DBExecute("CheckHouseFurnitures", "iii", playerid, houseid, listitem);
        }
    }
    return 1;
}

DB:CheckHouseFurnitures(playerid, houseid, listitem)
{
    if (GetDBIntFieldFromIndex(0, 0) >= GetHouseFurnitureCapacity(houseid))
    {
        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]{ffffff} Your house is only allowed up to %i furniture at its current level.", GetHouseFurnitureCapacity(houseid));
    }
    else
    {
        PlayerData[playerid][pSelected] = listitem;
        ShowFurniturePreviewer(playerid);
    }
    return 1;
}

Dialog:ChangeMat(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;
    if (listitem == 0 || listitem == 1) return ShowColorList(playerid);
    new t = -1;
    for (new x = 0; x < sizeof(MaterialIDs); x++)
    {
        if (strcmp(inputtext, MaterialIDs[x][Name], true) == 0)
        {
            t = x;
            break;
        }
    }
    if (t == -1) return SendClientMessage(playerid, COLOR_RED, "An error has occurred, please try it later! (DEBUG: \"ChangeMatHandler\")");
    FurnitureChange(playerid, GetPVarInt(playerid, "FurnID"), GetPVarInt(playerid, "MatSlot"), t, 1);
    return true;
}

Dialog:ChangeColor(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;
    if (listitem == 0 || listitem == 1)
    {
        Dialog_Show(playerid, TextureResources, DIALOG_STYLE_LIST, "Texture Category:",
                    "Material Colors\nPrinted Fabrics\nWooden\nTiles\nBuilding\nMetals\nPaintings\nWallpapers\nMisc",
                    "Select", "Exit");
    }
    FurnitureChange(playerid, GetPVarInt(playerid, "FurnID"), GetPVarInt(playerid, "MatSlot"), listitem, 2);
    return true;
}

ListTexture(playerid)
{
    new fid = GetPVarInt(playerid, "FurnID");

    new list[256], header[64];
    format(header, sizeof(header), "You are now editing ID: %d.", GetPVarInt(playerid, "FurnID"));
    format(list, sizeof(list), "Index 1: %s\nIndex 2: %s\nIndex 3: %s\n \nClear Textures", Furniture[fid][fMaterial][0] ? ("{FFFF00}In Use") : ("{C3C3C3}Empty"), Furniture[fid][fMaterial][1] ? ("{FFFF00}In Use") : ("{C3C3C3}Empty"), Furniture[fid][fMaterial][2] ? ("{FFFF00}In Use") : ("{C3C3C3}Empty"));
    Dialog_Show(playerid, MaterialHandler, DIALOG_STYLE_LIST, header, list, ">>", "Cancel");
    return 1;
}

Dialog:MaterialHandler(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;
    if (listitem == 4)
    {
        for (new i = 0; i != 3; i ++)
        {
            Furniture[GetPVarInt(playerid, "FurnID")][fMaterial][i] = 0;
            Furniture[GetPVarInt(playerid, "FurnID")][fMatColour][i] = 0;
            SetDynamicObjectMaterial(Furniture[GetPVarInt(playerid, "FurnID")][fObject], i, -1, "none", "none", 0);
        }
        SaveFurniture(GetPVarInt(playerid, "FurnID"));
    }
    SetPVarInt(playerid, "MatSlot", listitem);
    Dialog_Show(playerid, TextureResources, DIALOG_STYLE_LIST, "Texture Category:", "Material Colors\nPrinted Fabrics\nWooden\nTiles\nBuilding\nMetals\nPaintings\nWallpapers\nMisc", "Select", "Exit");
    //ShowMaterialList(playerid);
    return true;
}

Dialog:TextureResources(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;
    new gstr[2056], gString[256];
    format(gString, sizeof(gString), " << {F3FF02}Select Color\n");
    strcat(gstr, gString);
    for (new i = 0; i < sizeof(MaterialIDs); i++)
    {
        if (strcmp("None", MaterialIDs[i][Resource], true) == 0) continue;
        if (strcmp(inputtext, MaterialIDs[i][Resource], true) == 0)
        {
            strcat(gstr, MaterialIDs[i][Name]);
            strcat(gstr, "\n");
        }
    }
    Dialog_Show(playerid, ChangeMat, DIALOG_STYLE_LIST, "Texture List", gstr, ">>", "Cancel");
    return 1;
}

ShowColorList(playerid)
{
    new list[4056], bigStr[256], gString[256];
    format(gString, sizeof(gString), " << {F3FF02}Select Texture\n");
    strcat(list, gString);
    for (new i = 0; i < sizeof(MaterialColors); i++)
    {
        if (strcmp("none", MaterialColors[i][ColorName], true) == 0) continue;
        format(bigStr, sizeof(bigStr), "%s\n", MaterialColors[i][ColorName]);
        strcat(list, bigStr);
    }
    Dialog_Show(playerid, ChangeColor, DIALOG_STYLE_LIST, "Color List", list, ">>", "Cancel");
    return 1;
}

OfflineSetHouseOwner(aplayerid, houseid, username[])
{

    DBFormat("SELECT * FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnOChangeHouseOwnerGotUsers", "ii",aplayerid,houseid);

}

DB:OnOChangeHouseOwnerGotUsers(playerid,houseid)
{
    new rows = GetDBNumRows();
    if (rows)
    {
        GetDBStringField(0, "username", HouseInfo[houseid][hOwner], MAX_PLAYER_NAME);

        HouseInfo[houseid][hOwnerID] = GetDBIntField(0, "uid");
        HouseInfo[houseid][hTimestamp] = gettime();

        DBQuery("UPDATE houses SET timestamp = %i, ownerid = %i, owner = '%e' WHERE id = %i", HouseInfo[houseid][hTimestamp], HouseInfo[houseid][hOwnerID], HouseInfo[houseid][hOwner], HouseInfo[houseid][hID]);

        DBLog("log_property", "%s (uid: %i) has edited house id owner to (id: %s).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hOwner]);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of house %i to %s.", houseid, HouseInfo[houseid][hOwner]);

        ReloadHouse(houseid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Unvalid username.");
    }
}

DB:OnLoadHouses()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_HOUSES; i ++)
    {
        GetDBStringField(i, "owner", HouseInfo[i][hOwner], MAX_PLAYER_NAME);

        HouseInfo[i][hID] = GetDBIntField(i, "id");
        HouseInfo[i][hOwnerID] = GetDBIntField(i, "ownerid");
        HouseInfo[i][hType] = GetDBIntField(i, "type");
        HouseInfo[i][hPrice] = GetDBIntField(i, "price");
        HouseInfo[i][hRentPrice] = GetDBIntField(i, "rentprice");
        HouseInfo[i][hLevel] = GetDBIntField(i, "level");
        HouseInfo[i][hLocked] = GetDBIntField(i, "locked");
        HouseInfo[i][hTimestamp] = GetDBIntField(i, "timestamp");
        HouseInfo[i][hPosX] = GetDBFloatField(i, "pos_x");
        HouseInfo[i][hPosY] = GetDBFloatField(i, "pos_y");
        HouseInfo[i][hPosZ] = GetDBFloatField(i, "pos_z");
        HouseInfo[i][hPosA] = GetDBFloatField(i, "pos_a");
        HouseInfo[i][hIntX] = GetDBFloatField(i, "int_x");
        HouseInfo[i][hIntY] = GetDBFloatField(i, "int_y");
        HouseInfo[i][hIntZ] = GetDBFloatField(i, "int_z");
        HouseInfo[i][hIntA] = GetDBFloatField(i, "int_a");
        HouseInfo[i][hInterior] = GetDBIntField(i, "interior");
        HouseInfo[i][hWorld] = GetDBIntField(i, "world");
        HouseInfo[i][hOutsideInt] = GetDBIntField(i, "outsideint");
        HouseInfo[i][hOutsideVW] = GetDBIntField(i, "outsidevw");
        HouseInfo[i][hCash] = GetDBIntField(i, "cash");
        HouseInfo[i][hMaterials] = GetDBIntField(i, "materials");
        HouseInfo[i][hWeed] = GetDBIntField(i, "weed");
        HouseInfo[i][hCocaine] = GetDBIntField(i, "cocaine");
        HouseInfo[i][hHeroin] = GetDBIntField(i, "heroin");
        HouseInfo[i][hPainkillers] = GetDBIntField(i, "painkillers");
        HouseInfo[i][hWeapons][0] = GetDBIntField(i, "weapon_1");
        HouseInfo[i][hWeapons][1] = GetDBIntField(i, "weapon_2");
        HouseInfo[i][hWeapons][2] = GetDBIntField(i, "weapon_3");
        HouseInfo[i][hWeapons][3] = GetDBIntField(i, "weapon_4");
        HouseInfo[i][hWeapons][4] = GetDBIntField(i, "weapon_5");
        HouseInfo[i][hWeapons][5] = GetDBIntField(i, "weapon_6");
        HouseInfo[i][hWeapons][6] = GetDBIntField(i, "weapon_7");
        HouseInfo[i][hWeapons][7] = GetDBIntField(i, "weapon_8");
        HouseInfo[i][hWeapons][8] = GetDBIntField(i, "weapon_9");
        HouseInfo[i][hWeapons][9] = GetDBIntField(i, "weapon_10");
        HouseInfo[i][hDelivery] = GetDBIntField(i, "delivery");
        HouseInfo[i][hLights] = GetDBIntField(i, "lights");
        HouseInfo[i][hAlarm] = GetDBIntField(i, "alarm");
        HouseInfo[i][hText] = Text3D:INVALID_3DTEXT_ID;
        HouseInfo[i][hPickup] = -1;
        HouseInfo[i][hLabels] = 0;
        HouseInfo[i][hExists] = 1;
        Iter_Add(House, i);
        ReloadHouse(i);
    }
    printf("[Script] %i houses loaded.", rows);
    DBQueryWithCallback("SELECT * FROM rp_furniture", "OnLoadFurniture");
}

DB:HouseInformation(playerid)
{
    new type[16], houseid = GetNearbyHouseEx(playerid);

    if (HouseInfo[houseid][hType] == -1)
    {
        type = "Other";
    }
    else
    {
        strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ House ID %i _______", houseid);
    SendClientMessageEx(playerid, COLOR_GREY2, "Value: %s - Rent Price: %s - Level: %i/5 - Active: %s - Locked: %s", FormatCash(HouseInfo[houseid][hPrice]), FormatCash(HouseInfo[houseid][hRentPrice]), HouseInfo[houseid][hLevel], (gettime() - HouseInfo[houseid][hTimestamp] > 2592000) ? ("{FF6347}No{C8C8C8}") : ("Yes"), (HouseInfo[houseid][hLocked]) ? ("Yes") : ("No"));
    SendClientMessageEx(playerid, COLOR_GREY2, "Class: %s - Location: %s - Furniture: %i/%i - Tenants: %i/%i", type, GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]), GetDBIntFieldFromIndex(0, 0), GetHouseFurnitureCapacity(houseid), GetDBIntFieldFromIndex(0, 1), GetHouseTenantCapacity(houseid));
}

CMD:househelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** HOUSE HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /house /buyhouse /renthouse /unrent /houseinfo");
    SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /door /lock /edit /edittexture /delete");
    return 1;
}

CMD:renthouse(playerid, params[])
{
    new houseid;

    if ((houseid = GetNearbyHouse(playerid)) == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no house in range. You must be near a house.");
    }
    if (!HouseInfo[houseid][hOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This house is not owned and therefore cannot be rented.");
    }
    if (!HouseInfo[houseid][hRentPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This house's owner has chosen to disable renting for this house.");
    }
    if (PlayerData[playerid][pCash] < HouseInfo[houseid][hRentPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to rent here.");
    }
    if (IsHouseOwner(playerid, houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are the owner of this house. You can't rent here.");
    }
    DBFormat("SELECT COUNT(*) FROM "#TABLE_USERS" WHERE rentinghouse = %i", HouseInfo[houseid][hID]);
    DBExecute("OnPlayerRentHouse", "ii", playerid, houseid);
    return 1;
}

CMD:unrent(playerid, params[])
{
    if (!PlayerData[playerid][pRentingHouse])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not renting at any property. You can't use this command.");
    }
    DBQuery("UPDATE "#TABLE_USERS" SET rentinghouse = 0 WHERE uid = %i", PlayerData[playerid][pID]);
    PlayerData[playerid][pRentingHouse] = 0;
    SendClientMessage(playerid, COLOR_WHITE, "You have ripped up your rental contract.");
    return 1;
}

CMD:buyhouse(playerid, params[])
{
    new houseid, type[16];

    if ((houseid = GetNearbyHouse(playerid)) == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no house in range. You must be near a house.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buyhouse [confirm]");
    }
    if (HouseInfo[houseid][hOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This house already has an owner.");
    }
    if (PlayerData[playerid][pCash] < HouseInfo[houseid][hPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this house.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_HOUSES) >= GetPlayerAssetLimit(playerid, LIMIT_HOUSES))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i houses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
    }

    if (HouseInfo[houseid][hType])
    {
        type = "House";
    }
    else
    {
        strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
    }

    SetHouseOwner(houseid, playerid);
    GivePlayerCash(playerid, -HouseInfo[houseid][hPrice]);

    SendClientMessageEx(playerid, COLOR_GREEN, "You paid %s to make this house yours! /househelp for a list of commands.", FormatCash(HouseInfo[houseid][hPrice]));
    DBLog("log_property", "%s (uid: %i) purchased %s (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], type, HouseInfo[houseid][hID], HouseInfo[houseid][hPrice]);
    AwardAchievement(playerid, ACH_HomeSweetHome);
    return 1;
}

//Admin commands:
CMD:createhouse(playerid, params[])
{
    new type, Float:x, Float:y, Float:z, Float:a;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", type))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /createhouse [type (1-%i)]", sizeof(houseInteriors));
    }
    if (!(1 <= type <= sizeof(houseInteriors)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
    }
    if (GetNearbyHouse(playerid) >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is a house in range. Find somewhere else to create this one.");
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    type--;

    for (new i = 0; i < MAX_HOUSES; i++)
    {
        if (!HouseInfo[i][hExists])
        {
            DBFormat("INSERT INTO houses (type, price, pos_x, pos_y, pos_z, pos_a, int_x, int_y, int_z, int_a, interior, outsideint, outsidevw) VALUES(%i, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, %i)", type, houseInteriors[type][intPrice], x, y, z, a - 180.0,
                houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ], houseInteriors[type][intA], houseInteriors[type][intID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            DBExecute("OnAdminCreateHouse", "iiiffff", playerid, i, type, x, y, z, a);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "House slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:edithouse(playerid, params[])
{
    new houseid, option[10], param[32];

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[10]S()[32]", houseid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Entrance, Exit, World, Type, Owner, Price, RentPrice, Level, Locked, Delivery");
        return 1;
    }
    if (!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
    }

    if (!strcmp(option, "entrance", true))
    {
        GetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
        GetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);

        HouseInfo[houseid][hOutsideInt] = GetPlayerInterior(playerid);
        HouseInfo[houseid][hOutsideVW] = GetPlayerVirtualWorld(playerid);

        DBQuery("UPDATE houses SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], HouseInfo[houseid][hPosA], HouseInfo[houseid][hOutsideInt], HouseInfo[houseid][hOutsideVW], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entrance of house %i.", houseid);
    }
    else if (!strcmp(option, "exit", true))
    {
        new type = -1;

        for (new i = 0; i < sizeof(houseInteriors); i ++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 100.0, houseInteriors[i][intX], houseInteriors[i][intY], houseInteriors[i][intZ]))
            {
                type = i;
            }
        }

        GetPlayerPos(playerid, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ]);
        GetPlayerFacingAngle(playerid, HouseInfo[houseid][hIntA]);

        HouseInfo[houseid][hInterior] = GetPlayerInterior(playerid);
        HouseInfo[houseid][hType] = type;

        DBQuery("UPDATE houses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", type, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the exit of house %i.", houseid);
    }
    else if (!strcmp(option, "world", true))
    {
        new worldid;

        if (sscanf(param, "i", worldid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [world] [vw]");
        }

        HouseInfo[houseid][hWorld] = worldid;

        DBQuery("UPDATE houses SET world = %i WHERE id = %i", HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the virtual world of house %i to %i.", houseid, worldid);
    }
    else if (!strcmp(option, "type", true))
    {
        new type;

        if (sscanf(param, "i", type))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [type] [value (1-%i)]", sizeof(houseInteriors));
        }
        if (!(1 <= type <= sizeof(houseInteriors)))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
        }

        type--;

        HouseInfo[houseid][hType] = type;
        HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
        HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
        HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
        HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
        HouseInfo[houseid][hIntA] = houseInteriors[type][intA];

        DBQuery("UPDATE houses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the type of house %i to %i.", houseid, type + 1);
    }
    else if (!strcmp(option, "owner", true))
    {
        new targetid;

        if (sscanf(param, "u", targetid))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [owner] [playerid]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (!PlayerData[targetid][pLogged])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
        }

        SetHouseOwner(houseid, targetid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of house %i to %s.", houseid, GetRPName(targetid));
    }
    else if (!strcmp(option, "price", true))
    {
        new price;

        if (sscanf(param, "i", price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [price] [value]");
        }
        if (price < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
        }

        HouseInfo[houseid][hPrice] = price;

        DBQuery("UPDATE houses SET price = %i WHERE id = %i", HouseInfo[houseid][hPrice], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the price of house %i to $%i.", houseid, price);
    }
    else if (!strcmp(option, "rentprice", true))
    {
        new price;

        if (sscanf(param, "i", price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [rentprice] [value]");
        }
        if (price < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
        }

        HouseInfo[houseid][hRentPrice] = price;

        DBQuery("UPDATE houses SET rentprice = %i WHERE id = %i", HouseInfo[houseid][hRentPrice], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the rent price of house %i to $%i.", houseid, price);
    }
    else if (!strcmp(option, "level", true))
    {
        new level;

        if (sscanf(param, "i", level))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [level] [value (0-5)]");
        }
        if (!(0 <= level <= 6))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 5.");
        }

        HouseInfo[houseid][hLevel] = level;

        DBQuery("UPDATE houses SET level = %i WHERE id = %i", HouseInfo[houseid][hLevel], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the level of house %i to %i.", houseid, level);
    }
    else if (!strcmp(option, "locked", true))
    {
        new locked;

        if (sscanf(param, "i", locked) || !(0 <= locked <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [locked] [0/1]");
        }

        HouseInfo[houseid][hLocked] = locked;

        DBQuery("UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[houseid][hLocked], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of house %i to %i.", houseid, locked);
    }
     else if (!strcmp(option, "delivery", true))
    {
        new delivery;

        if (sscanf(param, "i", delivery) || !(0 <= delivery <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /edithouse [houseid] [locked] [0/1]");
        }

        HouseInfo[houseid][hDelivery] = delivery;

        DBQuery("UPDATE houses SET delivery = %i WHERE id = %i", HouseInfo[houseid][hDelivery], HouseInfo[houseid][hID]);


        ReloadHouse(houseid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the ability to be to delivered of house %i to %i.", houseid, delivery);
    }
    return 1;
}

CMD:removehouse(playerid, params[])
{
    new houseid;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", houseid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removehouse [houseid]");
    }
    if (!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
    }

    RemoveAllFurniture(houseid);

    DestroyDynamic3DTextLabel(HouseInfo[houseid][hText]);
    DestroyDynamicPickup(HouseInfo[houseid][hPickup]);
//  DestroyDynamicMapIcon(HouseInfo[houseid][hMapIcon]);

    DBQuery("DELETE FROM houses WHERE id = %i", HouseInfo[houseid][hID]);

    HouseInfo[houseid][hExists] = 0;
    HouseInfo[houseid][hID] = 0;
    HouseInfo[houseid][hOwnerID] = 0;

    Iter_Remove(House, houseid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed house id %i", GetPlayerNameEx(playerid), houseid);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed house %i.", houseid);
    return 1;
}

CMD:gotohouse(playerid, params[])
{
    new houseid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", houseid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotohouse [houseid]");
    }
    if (!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
    SetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);
    SetPlayerInterior(playerid, HouseInfo[houseid][hOutsideInt]);
    SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hOutsideVW]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:asellhouse(playerid, params[])
{
    new houseid;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", houseid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellhouse [houseid]");
    }
    if (!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid house.");
    }

    SetHouseOwner(houseid, INVALID_PLAYER_ID);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold house %i.", houseid);
    return 1;
}

CMD:removefurnitures(playerid, params[])
{
    new houseid;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "[USAGE]{ffffff} /removefurnitures [houseid]");
    }
    if (!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
    {
        return SendClientMessage(playerid, COLOR_RED, "[ERROR]{ffffff} Invalid house.");
    }

    RemoveAllFurniture(houseid);
    SendClientMessageEx(playerid, COLOR_AQUA, "** You have removed all furniture for house %i.", houseid);
    return 1;
}

CMD:playerhouses(playerid, params[])
{

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (params[0]==0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "[USAGE]{ffffff} /playerhouses [playerid]");
    }
    DisplayPlayerHousesList(playerid,params);
    return 1;
}

CMD:ochangehouseowner(playerid, params[])
{
    new houseid, username[32];

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[20]S()[32]", houseid, username))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ochangehouseowner [houseid] [username]");
        return 1;
    }
    if (!(0 <= houseid < MAX_HOUSES) || !HouseInfo[houseid][hExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid house id.");
    }

    OfflineSetHouseOwner(playerid,houseid,username);
    return 1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_HOUSE)
        return 1;
    ShowActionBubble(playerid, "* %s has entered the house.", GetRPName(playerid));
    SetPlayerPos(playerid, HouseInfo[PlayerData[playerid][pInviteHouse]][hIntX], HouseInfo[PlayerData[playerid][pInviteHouse]][hIntY], HouseInfo[PlayerData[playerid][pInviteHouse]][hIntZ]);
    SetPlayerFacingAngle(playerid, HouseInfo[PlayerData[playerid][pInviteHouse]][hIntA]);
    SetPlayerInterior(playerid, HouseInfo[PlayerData[playerid][pInviteHouse]][hInterior]);
    SetPlayerVirtualWorld(playerid, HouseInfo[PlayerData[playerid][pInviteHouse]][hWorld]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock GetHouseID(dbHouseId)
{
    for (new i = 0; i < sizeof(HouseInfo); i++)
    {
        if (HouseInfo[i][hExists] && HouseInfo[i][hID] == dbHouseId)
            return i;
    }
    return INVALID_HOUSE_ID;
}


CMD:houseinfo(playerid, params[])
{
    new houseid = GetNearbyHouseEx(playerid);
    if (houseid == -1 || !IsHouseOwner(playerid, houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any house of yours.");
    }
    DBFormat("SELECT (SELECT COUNT(*) FROM rp_furniture WHERE fHouseID = %i) AS furnitureCount, (SELECT COUNT(*) FROM "#TABLE_USERS" WHERE rentinghouse = %i) AS tenantCount", HouseInfo[houseid][hID], HouseInfo[houseid][hID]);
    DBExecute("HouseInformation", "i", playerid);
    return 1;
}

// Begin Section: Edit Furniture
CMD:edit(playerid, params[])
{
    new furnitureid;
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be inside a house that you have access to build.");
    }

    if (sscanf(params, "i", furnitureid))
    {
        return SendSyntaxMessage(playerid, "/edit (furniture ID)");
    }

    if (!IsValidFurnitureID(furnitureid))
    {
        return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
    }

    if (Furniture[furnitureid][fHouseId] != houseid)
    {
        return SendErrorMessage(playerid, "The specified ID belongs to another house.");
    }

    if (PlayerData[playerid][pEdit] == EDIT_TYPE_PREVIEW)
    {
        return SendErrorMessage(playerid, "You can't edit furniture while previewing.");
    }

    SetPVarInt(playerid, "FurnID", furnitureid);
    Dialog_Show(playerid, FurnEditConfirm, DIALOG_STYLE_LIST, "Furniture Edit", "Edit Position\nEdit Texture\nDuplicate Object\nDelete Object", "Select", "Cancel");
    SendInfoMessage(playerid, "You are now editing ID: %i. Click the disk icon to save changes.", furnitureid);
    return 1;
}

CMD:edittexture(playerid, params[])
{
    new furnitureid;
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be inside a house that you have access to build.");
    }

    if (sscanf(params, "i", furnitureid))
    {
        return SendSyntaxMessage(playerid, "/edit (furniture ID)");
    }

    if (!IsValidFurnitureID(furnitureid))
    {
        return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
    }

    if (Furniture[furnitureid][fHouseId] != houseid)
    {
        return SendErrorMessage(playerid, "The specified ID belongs to another house.");
    }

    if (PlayerData[playerid][pEdit] == EDIT_TYPE_PREVIEW)
    {
        return SendErrorMessage(playerid, "You can't edit furniture while previewing.");
    }
    ListTexture(playerid);
    SendInfoMessage(playerid, "You are now editing ID: %i. Click the disk icon to save changes.", furnitureid);
    return 1;
}

CMD:delete(playerid, params[])
{
    new furnitureid;
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be inside a house that you have access to build.");
    }

    if (sscanf(params, "i", furnitureid))
    {
        return SendSyntaxMessage(playerid, "/delete (furniture ID)");
    }

    if (!IsValidFurnitureID(furnitureid))
    {
        return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
    }

    if (Furniture[furnitureid][fHouseId] != houseid)
    {
        return SendErrorMessage(playerid, "The specified ID belongs to another house.");
    }

    if (PlayerData[playerid][pEdit] == EDIT_TYPE_FURNITURE)
    {
        CancelObjectEdit(playerid);
    }

    DeleteFurniture(furnitureid);
    SendInfoMessage(playerid, "You are deleted furniture ID: %i.", furnitureid);
    return 1;
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (PlayerData[playerid][pEdit] == EDIT_TYPE_FURNITURE)
    {
        new furnitureid = PlayerData[playerid][pEditID];
        if (response == EDIT_RESPONSE_CANCEL)
        {
            PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
            ReloadFurniture(furnitureid);
        }
        else if (response == EDIT_RESPONSE_FINAL)
        {
            PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
            new houseid = Furniture[furnitureid][fHouseId];
            PlayerData[playerid][pEditID] = -1;

            if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
            {
                ReloadFurniture(furnitureid);
                return SendClientMessage(playerid, COLOR_GREY, "You don't have permission in this house.");
            }

            if (!IsPointInsideHouse(houseid, x, y,z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid)))
            {
                ReloadFurniture(furnitureid);
                return SendClientMessage(playerid, COLOR_GREY, "Object is not inside the house.");
            }

            Furniture[furnitureid][fSpawn][0] = x;
            Furniture[furnitureid][fSpawn][1] = y;
            Furniture[furnitureid][fSpawn][2] = z;
            Furniture[furnitureid][fSpawn][3] = rx;
            Furniture[furnitureid][fSpawn][4] = ry;
            Furniture[furnitureid][fSpawn][5] = rz;

            ReloadFurniture(furnitureid);
            SaveFurniture(furnitureid);
            SendInfoMessage(playerid, "You have edited furniture ID: %i.", furnitureid);
        }
    }
    else if (PlayerData[playerid][pEdit] == EDIT_TYPE_PREVIEW)
    {
        if (response == EDIT_RESPONSE_CANCEL)
        {
            PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
            DestroyDynamicObject(gPreviewFurniture[playerid]);
            gPreviewFurniture[playerid] = INVALID_OBJECT_ID;
        }
        else if (response == EDIT_RESPONSE_FINAL)
        {
            PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
            DestroyDynamicObject(gPreviewFurniture[playerid]);
            gPreviewFurniture[playerid] = INVALID_OBJECT_ID;

            new houseid = GetInsideHouse(playerid);
            if (houseid == INVALID_HOUSE_ID)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You are not inside any house of yours.");
            }

            if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have permission in this house.");
             }

            if (!IsPointInsideHouse(houseid, x, y,z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid)))
            {
                return SendClientMessage(playerid, COLOR_GREY, "Object is not inside the house.");
            }

            if (!PlayerCanAfford(playerid, g_FurnitureList[FurniturePreviewIndex[playerid]][e_ModelPrice]))
            {
                return SendErrorMessage(playerid, "You don't have enough money.");
            }
            else
            {
                new id = AddFurniture(houseid, g_FurnitureList[FurniturePreviewIndex[playerid]][e_ModelID], x, y, z, rx, ry, rz,
                                      HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld]);

                if (id == -1)
                {
                    SendErrorMessage(playerid, "There are no available furniture slots.");
                    SendAdminMessage(COLOR_RED, "Admin: %s has failed to add furniture! \"MAX_FURNITURE\" needs to be adjusted.", GetRPName(playerid));
                }
                else
                {
                    GivePlayerCash(playerid, -g_FurnitureList[FurniturePreviewIndex[playerid]][e_ModelPrice]);

                    ShowFurnitureCategories(playerid);
                    SendInfoMessage(playerid, "Furniture purchased for {33CC33}%s{FFFFFF}. Use /edit to manage your furniture.", FormatCash(g_FurnitureList[FurniturePreviewIndex[playerid]][e_ModelPrice]));
                }
            }
        }
    }
    return 1;
}

hook OnPlayerMenuResponse(playerid, extraid, response, listitem, modelid)
{
    if (extraid != MODEL_SELECTION_FURNITURE || !response || listitem < 0)
        return 1;

    new houseid = GetInsideHouse(playerid);
    if (houseid != INVALID_HOUSE_ID && PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
    {
        PreviewFurniture(playerid, listitem + FurniturePreviewIndex[playerid]);
    }
    return 1;
}

// End Section: Edit Furniture
