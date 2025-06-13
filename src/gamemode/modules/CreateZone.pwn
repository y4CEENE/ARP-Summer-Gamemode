/// @file      CreateZone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-09-21 11:40:26 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum eCreateZone
{
    ZoneType:CZ_Type,
    bool:CZ_CreationMode,
    CZ_Pickups[4],
    CZ_ZoneID,
    Float:CZ_P1X,
    Float:CZ_P1Y,
    Float:CZ_P2X,
    Float:CZ_P2Y
};
static CreateZone[MAX_PLAYERS][eCreateZone];

hook OnPlayerInit(playerid)
{
    CreateZone[playerid][CZ_CreationMode] = false;
    CreateZone[playerid][CZ_Type] = ZoneType_None;
    CreateZone[playerid][CZ_P1X] = 0.0;
    CreateZone[playerid][CZ_P1Y] = 0.0;
    CreateZone[playerid][CZ_P2X] = 0.0;
    CreateZone[playerid][CZ_P2Y] = 0.0;
    CreateZone[playerid][CZ_ZoneID] = -1;
    for (new i = 0; i < 4; i++)
    {
        CreateZone[playerid][CZ_Pickups][i] = -1;
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (CreateZone[playerid][CZ_ZoneID] >= 0)
    {
        GangZoneDestroy(CreateZone[playerid][CZ_ZoneID]);
    }
    for (new i = 0; i < 4; i++)
    {
        if (IsValidDynamicPickup(CreateZone[playerid][CZ_Pickups][i]))
        {
            DestroyDynamicPickup(CreateZone[playerid][CZ_Pickups][i]);
        }
    }
}

ZoneTypeToString(ZoneType:type)
{
    new result[32];
    switch (type)
    {
        case ZoneType_Turf:       result = "Turf";
        case ZoneType_Land:       result = "Land";
        case ZoneType_GreenZone:  result = "GreenZone";
        case ZoneType_ToxicZone:  result = "ToxicZone";
        case ZoneType_DangerZone: result = "DangerZone";
        default:                  result = "None";
    }
    return result;
}

SetPlayerCreatingZone(playerid, ZoneType:type)
{
    CreateZone[playerid][CZ_Type] = type;
    CreateZone[playerid][CZ_CreationMode] = (type != ZoneType_None);
    CreateZone[playerid][CZ_P1X] = 0.0;
    CreateZone[playerid][CZ_P1Y] = 0.0;
    CreateZone[playerid][CZ_P2X] = 0.0;
    CreateZone[playerid][CZ_P2Y] = 0.0;

    for (new i = 0; i < 4; i++)
    {
        DestroyDynamicPickup(CreateZone[playerid][CZ_Pickups][i]);
        CreateZone[playerid][CZ_Pickups][i] = -1;
    }
    GangZoneDestroy(CreateZone[playerid][CZ_ZoneID]);
    CreateZone[playerid][CZ_ZoneID] = -1;

    if (CreateZone[playerid][CZ_CreationMode])
    {
        new zoneType[32], title[64];
        zoneType = ZoneTypeToString(type);
        format(title, sizeof(title), "%s creation system", zoneType);

        Dialog_Show(playerid, CreateDynamicZone, DIALOG_STYLE_MSGBOX, title,
                    "You have entered the %s creation mode. In order to create a %s you need\n"\
                    "to mark two points around the area you want your %s to be in, forming\n"\
                    "a square. You must make a square or your outcome won't be as expected.\n\n"\
                    "Press {00AA00}Confirm{A9C4E4} to begin %s creation.",
                    "Confirm", "Cancel", zoneType, zoneType, zoneType, zoneType);
        SendClientMessage(playerid, COLOR_WHITE, "Note: You can use /cancelzone to exit creation mode.");
    }
}

Dialog:CreateDynamicZone(playerid, response, listitem, inputtext[])
{
    if (response && (IsAdmin(playerid, ADMIN_LVL_10) || PlayerData[playerid][pGangMod] || PlayerData[playerid][pDynamicAdmin]))
    {
        CreateZone[playerid][CZ_CreationMode] = true;
        SendClientMessageEx(playerid, COLOR_WHITE,
                            "Your %s needs to be within a square or rectangle. /confirm to set the boundary points.",
                            ZoneTypeToString(CreateZone[playerid][CZ_Type]));
    }
    else
    {
        CreateZone[playerid][CZ_Type] = ZoneType_None;
        CreateZone[playerid][CZ_CreationMode] = false;
    }
    return 1;
}

CMD:confirm(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }

    if (!CreateZone[playerid][CZ_CreationMode])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not creating any zone at the moment.");
    }

    new Float:z;
    if (CreateZone[playerid][CZ_P1X] == 0.0)
    {
        GetPlayerPos(playerid, CreateZone[playerid][CZ_P1X], CreateZone[playerid][CZ_P1Y], z);
        CreateZone[playerid][CZ_Pickups][0] = CreateDynamicPickup(1239, 1, CreateZone[playerid][CZ_P1X], CreateZone[playerid][CZ_P1Y], z, .playerid = playerid);
        SendClientMessage(playerid, COLOR_WHITE, "* Boundary 1/2 set (min X, min Y).");
    }
    else if (CreateZone[playerid][CZ_P2X] == 0.0)
    {
        GetPlayerPos(playerid, CreateZone[playerid][CZ_P2X], CreateZone[playerid][CZ_P2Y], z);
        CreateZone[playerid][CZ_Pickups][1] = CreateDynamicPickup(1239, 1, CreateZone[playerid][CZ_P1X], CreateZone[playerid][CZ_P2Y], z, .playerid = playerid);
        CreateZone[playerid][CZ_Pickups][2] = CreateDynamicPickup(1239, 1, CreateZone[playerid][CZ_P2X], CreateZone[playerid][CZ_P2Y], z, .playerid = playerid);
        CreateZone[playerid][CZ_Pickups][3] = CreateDynamicPickup(1239, 1, CreateZone[playerid][CZ_P2X], CreateZone[playerid][CZ_P1Y], z, .playerid = playerid);
        CreateZone[playerid][CZ_ZoneID] = GangZoneCreate(CreateZone[playerid][CZ_P1X], CreateZone[playerid][CZ_P1Y],
                                                         CreateZone[playerid][CZ_P2X], CreateZone[playerid][CZ_P2Y]);
        GangZoneShowForPlayer(playerid, CreateZone[playerid][CZ_ZoneID], 0x44FF007F);
        SendClientMessage(playerid, COLOR_WHITE, "* Boundary 2/2 set (max X, max Y).");
    }
    else
    {
        //Confirm
        new type = _:CreateZone[playerid][CZ_Type];
        new Float:minx = CreateZone[playerid][CZ_P1X];
        new Float:maxx = CreateZone[playerid][CZ_P2X];
        new Float:miny = CreateZone[playerid][CZ_P1Y];
        new Float:maxy = CreateZone[playerid][CZ_P2Y];
        if (minx > maxx)
        {
            minx = CreateZone[playerid][CZ_P2X];
            maxx = CreateZone[playerid][CZ_P1X];
        }
        if (miny > maxy)
        {
            miny = CreateZone[playerid][CZ_P2Y];
            maxy = CreateZone[playerid][CZ_P1Y];
        }

        SetPlayerCreatingZone(playerid, ZoneType_None);
        CallRemoteFunction("OnConfirmZoneCreation", "iiffff", playerid, type, minx, miny, maxx, maxy);
    }
    return 1;
}

CMD:cancelzone(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    SetPlayerCreatingZone(playerid, ZoneType_None);
    SendClientMessage(playerid, COLOR_LIGHTRED, "* Zone creation cancelled.");
    return 1;
}
