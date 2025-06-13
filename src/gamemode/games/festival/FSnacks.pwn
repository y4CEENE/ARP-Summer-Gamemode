/// @file      FSnacks.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

static const cCornDogsPos[Point3D]   = { 1468.1566, -76.7717, 23.2247 };
static const cPizzaPos[Point3D]      = { 1477.4579, -70.6260, 23.2188 };
static const cFriedDoughPos[Point3D] = { 1465.0697, -86.3609, 23.2247 };

hook OnGameModeInit()
{
    CreateDynamicLabeledPickup(0xFFFF00AA, "Corn Dogs\n/corndog", cCornDogsPos[P3_PosX], cCornDogsPos[P3_PosY], cCornDogsPos[P3_PosZ], 0, 0, 1239, 10.0);
    CreateDynamicLabeledPickup(0xFFFF00AA, "Pizza\n/pizza", cPizzaPos[P3_PosX], cPizzaPos[P3_PosY], cPizzaPos[P3_PosZ], 0, 0, 1239, 10.0);
    CreateDynamicLabeledPickup(0xFFFF00AA, "Fried Dough\n/frieddough", cFriedDoughPos[P3_PosX], cFriedDoughPos[P3_PosY], cFriedDoughPos[P3_PosZ], 0, 0, 1239, 10.0);
}

CMD:corndog(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, cCornDogsPos[P3_PosX], cCornDogsPos[P3_PosY], cCornDogsPos[P3_PosZ]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, cCornDogsPos[P3_PosX], cCornDogsPos[P3_PosY], cCornDogsPos[P3_PosZ], 5.0);
        }
        return SendClientMessage(playerid, COLOR_GREY, "You are not at a corn dog stand.");
    }
    RCHECK(PlayerHasCash(playerid, 50), "You need $50 to buy a corn dog.");

    new Float:health;
    GetPlayerHealth(playerid, health);
    if (health < 100)
    {
        SetPlayerHealth(playerid, health > 90.0 ? 100.0 : health + 10.0);
    }
    GivePlayerCash(playerid, -50);
    PlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
    SendClientMessageEx(playerid, COLOR_GRAD4, "You have purchased a 'Corn Dog' for $50.");
    return 1;
}

CMD:pizza(playerid, params[])
{

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, cPizzaPos[P3_PosX], cPizzaPos[P3_PosY], cPizzaPos[P3_PosZ]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, cPizzaPos[P3_PosX], cPizzaPos[P3_PosY], cPizzaPos[P3_PosZ], 5.0);
        }
        return SendClientMessage(playerid, COLOR_GREY, "You are not at a pizza stand.");
    }
    RCHECK(PlayerHasCash(playerid, 50), "You need $50 to buy a pizza.");

    new Float:health;
    GetPlayerHealth(playerid, health);
    if (health < 100)
    {
        SetPlayerHealth(playerid, health > 90.0 ? 100.0 : health + 10.0);
    }
    GivePlayerCash(playerid, -50);
    PlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
    SendClientMessageEx(playerid, COLOR_GRAD4, "You have purchased a 'Pizza' for $50.");
    return 1;
}

CMD:frieddough(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, cFriedDoughPos[P3_PosX], cFriedDoughPos[P3_PosY], cFriedDoughPos[P3_PosZ]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, cFriedDoughPos[P3_PosX], cFriedDoughPos[P3_PosY], cFriedDoughPos[P3_PosZ], 5.0);
        }
        return SendClientMessage(playerid, COLOR_GREY, "You are not at a fried dough stand.");
    }
    RCHECK(PlayerHasCash(playerid, 50), "You need $50 to buy a fried dough.");

    new Float:health;
    GetPlayerHealth(playerid, health);
    if (health < 100)
    {
        SetPlayerHealth(playerid, health > 90.0 ? 100.0 : health + 10.0);
    }
    GivePlayerCash(playerid, -50);
    PlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
    SendClientMessageEx(playerid, COLOR_GRAD4, "You have purchased a 'Fried Dough' for $50.");
    return 1;
}
