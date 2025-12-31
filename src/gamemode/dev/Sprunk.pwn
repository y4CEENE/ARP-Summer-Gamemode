/// @file      Sprunk.pwn
/// @author    Khalil
/// @date      Created at 2025-04-07
/// @copyright Copyright (c) 2024

// Based on Dynamic Sprunk Machine System V1.0 by Weponz

#include <YSI\y_hooks>

// #define REMOVE_DEFAULT_MACHINES//Comment out to keep default vending machines
#define TABLE_SPRUNKS "`sprunks`"

#define MAX_SPRUNKS   150
#define SPRUNK_PRICE  5
#define SPRUNK_HEALTH 10.0 // Adds 10 HP
#define SPRUNK_KEY    KEY_SECONDARY_ATTACK // Enter Key

enum eSprunkData
{
	Sprunk_Id,
    Sprunk_Object,
    Sprunk_Area,
    Sprunk_Interior,
    Sprunk_World,
    Float:Sprunk_PosX,
    Float:Sprunk_PosY,
    Float:Sprunk_PosZ,
    Float:Sprunk_PosR
};
static SprunkData[MAX_SPRUNKS][eSprunkData];
static Iterator:Sprunks<MAX_SPRUNKS>;

hook OnLoadDatabase()
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM `SPRUNKS`");
    mysql_tquery(connectionID, queryBuffer, "SELECT * FROM "TABLE_SPRUNKS, "OnLoadSprunks", "");
}

forward OnLoadSprunks();
public OnLoadSprunks()
{
    new rows = cache_get_row_count(connectionID);
    for (new i = 0; i < rows && i < MAX_FACTIONS; i ++)
    {
        SprunkData[i][Sprunk_Id]       = cache_get_field_content_int(i, "id");
        SprunkData[i][Sprunk_PosX]     = cache_get_field_content_float(i, "PosX");
        SprunkData[i][Sprunk_PosY]     = cache_get_field_content_float(i, "PosY");
        SprunkData[i][Sprunk_PosZ]     = cache_get_field_content_float(i, "PosZ");
        SprunkData[i][Sprunk_PosR]     = cache_get_field_content_float(i, "PosR");
        SprunkData[i][Sprunk_Interior] = cache_get_field_content_int(i, "INTERIOR");
        SprunkData[i][Sprunk_World]    = cache_get_field_content_int(i, "WORLD");
        SprunkData[i][Sprunk_Object]   = CreateDynamicObject(1775, SprunkData[i][Sprunk_PosX], SprunkData[i][Sprunk_PosY], SprunkData[i][Sprunk_PosZ], 0.0, 0.0, SprunkData[i][Sprunk_PosR], SprunkData[i][Sprunk_World], SprunkData[i][Sprunk_Interior], -1, 100.0);
        SprunkData[i][Sprunk_Area]     = CreateDynamicSphere(SprunkData[i][Sprunk_PosX], SprunkData[i][Sprunk_PosY], SprunkData[i][Sprunk_PosZ], 1.5, SprunkData[i][Sprunk_World], SprunkData[i][Sprunk_Interior], -1, 0);
        Iter_Add(Sprunks, i);
    }
    return 1;
}

hook OnGameModeExit()
{
    foreach(new i : Sprunks)
    {
        DestroyDynamicObject(SprunkData[i][Sprunk_Object]);
        DestroyDynamicArea(SprunkData[i][Sprunk_Area]);
    }
    Iter_Clear(Sprunks);
    return 1;
}

hook OnRemoveBuilding(playerid)
{
    #if defined REMOVE_DEFAULT_MACHINES
        RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);//Sprunk Vending Machine #1
        RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);//Normal Vending Machine #1
        RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);//Soda Vending Machine #1
        RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);//Soda Vending Machine #2
        RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);//Sprunk Vending Machine #2
        RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);//Normal Vending Machine #2
    #endif
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (IsKeyPress(SPRUNK_KEY, newkeys, oldkeys) && IsPlayerInAnyDynamicArea(playerid, 0))
    {
        foreach (new i : Sprunks)
        {
            if (IsPlayerInDynamicArea(playerid, SprunkData[i][Sprunk_Area], 0))
            {
                new Float:x = SprunkData[i][Sprunk_PosX], Float:y = SprunkData[i][Sprunk_PosY];
                x -= (1.0 * floatsin(-SprunkData[i][Sprunk_PosR], degrees));
                y -= (1.0 * floatcos(-SprunkData[i][Sprunk_PosR], degrees));

                SetPlayerPos(playerid, x, y, SprunkData[i][Sprunk_PosZ]);
                SetPlayerFacingAngle(playerid, SprunkData[i][Sprunk_PosR]);
                SetCameraBehindPlayer(playerid);
                GivePlayerCash(playerid, -SPRUNK_PRICE);
                ApplyAnimation(playerid, "VENDING", "VEND_Use", 4.1, 0, 0, 0, 0, 0);
                return SetTimerEx("OnPlayerUseMachine", 2600, false, "d", playerid);
            }
        }
    }
    return 1;
}

forward OnPlayerUseMachine(playerid);
public OnPlayerUseMachine(playerid)
{
    new Float:health;
    GetPlayerHealth(playerid, health);
    if (health + SPRUNK_HEALTH <= 100.0)
    {
        SetPlayerHealth(playerid, health + SPRUNK_HEALTH);
        PlayerData[playerid][pHealth] = health + SPRUNK_HEALTH; 
    }
    else
    {
        SetPlayerHealth(playerid, 100.0);
        PlayerData[playerid][pHealth] = 100.0;
    }
    return ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
}

CMD:createsprunk(playerid, params[])
{
    if(!IsAdmin(playerid, HEAD_ADMIN))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    new Float:pos[4], id = Iter_Free(Sprunks);
    if (id != -1)
	{
		return SendErrorMessage(playerid, "You have reached the max aloud sprunk machines. (Increase MAX_SPRUNKS)");
	}

    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    SprunkData[id][Sprunk_PosX]     = pos[0];
    SprunkData[id][Sprunk_PosY]     = pos[1];
    SprunkData[id][Sprunk_PosZ]     = pos[2];
    SprunkData[id][Sprunk_PosR]     = pos[3];
    SprunkData[id][Sprunk_Interior] = GetPlayerInterior(playerid);
    SprunkData[id][Sprunk_World]    = GetPlayerVirtualWorld(playerid);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO "#TABLE_SPRUNKS" (`PosX`, `PosY`, `PosZ`, `PosR`, `INTERIOR`, `WORLD`)"\
             " VALUES ('%f', '%f', '%f', '%f', '%i', '%i')",
             SprunkData[id][Sprunk_PosX], SprunkData[id][Sprunk_PosY], SprunkData[id][Sprunk_PosZ], SprunkData[id][Sprunk_PosR],
             SprunkData[id][Sprunk_Interior], SprunkData[id][Sprunk_World]);
	mysql_tquery(connectionID, queryBuffer, "OnSprunkCreated", "ii", playerid, id);
    pos[0] -= (1.5 * floatsin(-pos[3], degrees));
    pos[1] -= (1.5 * floatcos(-pos[3], degrees));
    SetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	return 1;
}

forward OnSprunkCreated(playerid, index);
public OnSprunkCreated(playerid, index)
{
    new msg[256];
	SprunkData[index][Sprunk_Id] = cache_insert_id(connectionID);
    SprunkData[index][Sprunk_Object] = CreateDynamicObject(1775, SprunkData[index][Sprunk_PosX], SprunkData[index][Sprunk_PosY], SprunkData[index][Sprunk_PosZ], 0.0, 0.0, SprunkData[index][Sprunk_PosR], SprunkData[index][Sprunk_World], SprunkData[index][Sprunk_Interior], -1, 100.0);
    SprunkData[index][Sprunk_Area]   = CreateDynamicSphere(SprunkData[index][Sprunk_PosX], SprunkData[index][Sprunk_PosY], SprunkData[index][Sprunk_PosZ], 1.5, SprunkData[index][Sprunk_World], SprunkData[index][Sprunk_Interior], -1, 0);
    Iter_Add(Sprunks, index);
    format(msg, sizeof(msg), "~g~Machine Created! (%i/%i Created)", Iter_Count(Sprunks), MAX_SPRUNKS);
    return GameTextForPlayer(playerid, msg, 3000, 5);//TODO: GameTextForPlayerEx
}

CMD:deletesprunk(playerid, params[])
{
    if(!IsAdmin(playerid, HEAD_ADMIN))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    new interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);

    foreach(new i : Sprunks)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, SprunkData[i][Sprunk_PosX], SprunkData[i][Sprunk_PosY], SprunkData[i][Sprunk_PosZ]) && interior == SprunkData[i][Sprunk_Interior] && world == SprunkData[i][Sprunk_World])
        {
            DestroyDynamicObject(SprunkData[i][Sprunk_Object]);
            DestroyDynamicArea(SprunkData[i][Sprunk_Area]);
            Iter_Remove(Sprunks, i);
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM "#TABLE_SPRUNKS" WHERE `ID` = %i", SprunkData[i][Sprunk_Id]);
			mysql_tquery(connectionID, queryBuffer);
            new msg[64];
            format(msg, sizeof(msg), "~r~Machine Deleted! (%i/%i Left)", Iter_Count(Sprunks), MAX_SPRUNKS);
            return GameTextForPlayer(playerid, msg, 3000, 5);
        }
    }
    return SendClientMessage(playerid, -1, "There are no sprunk machines nearby to delete.");
}
