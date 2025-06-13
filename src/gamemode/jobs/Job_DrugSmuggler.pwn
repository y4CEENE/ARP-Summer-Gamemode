/// @file      Job_DrugSmuggler.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static DrugSmuggler_CrateCost          = 100;
static DrugSmuggler_TipPerLevel        = 100;
static DrugSmuggler_SeedsPaymentBase   = 200;
static DrugSmuggler_CocainePaymentBase = 300;
static DrugSmuggler_ChemsPaymentBase   = 250;
static DrugSmuggler_SeedsPerDelivery   = 4;
static DrugSmuggler_CocainePerDelivery = 5;
static DrugSmuggler_ChemsPerDelivery   = 4;
static DrugSmuggler_MaxSeedsStock      = 1000;
static DrugSmuggler_MaxCocaineStock    = 500;
static DrugSmuggler_MaxChemsStock      = 250;

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "drug_smuggler", config))
    {
        JSON_GetInt(config, "crate_cost",           DrugSmuggler_CrateCost);
        JSON_GetInt(config, "tip_per_level",        DrugSmuggler_TipPerLevel);
        JSON_GetInt(config, "seeds_payment_base",   DrugSmuggler_SeedsPaymentBase);
        JSON_GetInt(config, "cocaine_payment_base", DrugSmuggler_CocainePaymentBase);
        JSON_GetInt(config, "chems_payment_base",   DrugSmuggler_ChemsPaymentBase);
        JSON_GetInt(config, "seeds_per_delivery",   DrugSmuggler_SeedsPerDelivery);
        JSON_GetInt(config, "cocaine_per_delivery", DrugSmuggler_CocainePerDelivery);
        JSON_GetInt(config, "chems_per_delivery",   DrugSmuggler_ChemsPerDelivery);
        JSON_GetInt(config, "max_seeds_stock",      DrugSmuggler_MaxSeedsStock);
        JSON_GetInt(config, "max_cocaine_stock",    DrugSmuggler_MaxCocaineStock);
        JSON_GetInt(config, "max_chems_stock",      DrugSmuggler_MaxChemsStock);
    }
}

publish DrugDeliveryDetect(playerid)
{
    new Float:x, Float:y, Float:z, zone[26];
    GetPlayerPos(playerid, x, y, z);
    strcpy(zone, GetZoneName(x, y, z));
    foreach(new targetid : Player)
    {
        new factiontype = GetPlayerFaction(targetid);

        if (factiontype == FACTION_POLICE || factiontype == FACTION_FEDERAL || factiontype == FACTION_ARMY)
        {
            SendFactionMessage(targetid, COLOR_YELLOW, "HQ: CamDetect: A drug delivery has been spoted at %s, please send a unit immediately!", zone);
        }
    }
    return 1;
}

CMD:loadpack(playerid, params[])
{
    if (PlayerData[playerid][pSmuggleDrugs] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any drug pack to load.");
    }
    new vehicleid = GetNearbyVehicle(playerid);

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!VehicleHasDoors(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no boot.");
    }
    if (!IsVehicleParamOn(vehicleid, VEHICLE_BOOT))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vehicle trunk is not open");
    }
    switch (PlayerData[playerid][pSmuggleDrugs])
    {
        case 1:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            RemovePlayerAttachedObject(playerid, 9);
            PlayerData[playerid][pSmuggleTime] = gettime();
            SetTimerEx("DrugDeliveryDetect", 8000, 0, "i", playerid);
            SetActiveCheckpoint(playerid, CHECKPOINT_DRUGS, 2160.4971,-1700.8091,15.0859, 3.0);
            SendClientMessage(playerid, COLOR_GREEN, "Item loaded, deliver it to your marker!");
        }
        case 2:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            RemovePlayerAttachedObject(playerid, 9);
            PlayerData[playerid][pSmuggleTime] = gettime();
            SetTimerEx("DrugDeliveryDetect", 8000, 0, "i", playerid);
            SetActiveCheckpoint(playerid, CHECKPOINT_DRUGS, 2349.7727, -1169.6304, 28.0243, 3.0);
            SendClientMessage(playerid, COLOR_GREEN, "Item loaded, deliver it to your marker!");
        }
        case 3:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            RemovePlayerAttachedObject(playerid, 9);
            PlayerData[playerid][pSmuggleTime] = gettime();
            SetTimerEx("DrugDeliveryDetect", 8000, 0, "i", playerid);
            SetActiveCheckpoint(playerid, CHECKPOINT_DRUGS, 1765.2086, -2048.8926, 14.0429, 3.0);
            SendClientMessage(playerid, COLOR_GREEN, "Item loaded, deliver it to your marker!");
        }
    }
    return 1;
}

CMD:getcrate(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_DRUGSMUGGLER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Smuggler.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 2205.9263, 1581.7888, 999.9827))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the smuggle point.");
    }
    new amount = DrugSmuggler_CrateCost / GetJobLevel(playerid, JOB_DRUGSMUGGLER);
    if (PlayerData[playerid][pCash] < amount)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money.");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
    }

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getcrate [seeds | cocaine | chems]");
    }
    if (!strcmp(params, "seeds", true))
    {
        if (gSeedsStock + 10 > 1000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The drug house can't hold anymore seeds. Therefore you can't smuggle them.");
        }
        SetPlayerAttachedObject(playerid, 9, 1578, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        PlayerData[playerid][pSmuggleDrugs] = 1;
        GivePlayerCash(playerid, -amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have paid $%i for a package of {00AA00}weed seeds{33CCFF}. Load it to your vehicle's trunk (/loadpack).", amount);
    }
    else if (!strcmp(params, "cocaine", true))
    {
        if (gCocaineStock + 10 > 500)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The cocaine house can't hold anymore cocaine. Therefore you can't smuggle it.");
        }
        SetPlayerAttachedObject(playerid, 9, 1575, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        PlayerData[playerid][pSmuggleDrugs] = 2;
        GivePlayerCash(playerid, -amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have paid $%i for a package of {00AA00}cocaine{33CCFF}. Load it to your vehicle's trunk (/loadpack).", amount);
    }
    else if (!strcmp(params, "chems", true))
    {
        if (gChemicalsStock + 10 > 250)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The drug house can't hold anymore chems. Therefore you can't smuggle ir.");
        }
        SetPlayerAttachedObject(playerid, 9, 1576, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        PlayerData[playerid][pSmuggleDrugs] = 3;
        GivePlayerCash(playerid, -amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have paid $%i for a package of {00AA00}Chems{33CCFF}. Load it to your vehicle's trunk (/loadpack).", amount);
    }
    return 1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_DRUGS)
        return 1;

    new amount = (GetJobLevel(playerid, JOB_DRUGSMUGGLER) * DrugSmuggler_TipPerLevel);

    switch (PlayerData[playerid][pSmuggleDrugs])
    {
        case 1:
        {
            if (!IsPlayerInRangeOfPoint(playerid, 5.0, 2160.4971, -1700.8091, 15.0859))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You aren't at the correct dropoff spot.");
            }
            if (gSeedsStock >= DrugSmuggler_MaxSeedsStock)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The drug den does not need anymore seeds.");
            }
            amount += DrugSmuggler_SeedsPaymentBase;
            gSeedsStock += DrugSmuggler_SeedsPerDelivery;

        }
        case 2:
        {
            if (!IsPlayerInRangeOfPoint(playerid, 5.0, 2349.7727, -1169.6304, 28.0243))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You aren't at the correct dropoff spot.");
            }
            if (gCocaineStock >= DrugSmuggler_MaxCocaineStock)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The cocaine house does not need anymore cocaine.");
            }
            amount += DrugSmuggler_CocainePaymentBase;
            gCocaineStock += DrugSmuggler_CocainePerDelivery;
        }
        case 3:
        {
            if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1765.2086, -2048.8926, 14.0429))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You aren't at the correct dropoff spot.");
            }
            if (gChemicalsStock >= DrugSmuggler_MaxChemsStock)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The drug den does not need anymore chemicals.");
            }
            amount += DrugSmuggler_ChemsPaymentBase;
            gChemicalsStock += DrugSmuggler_ChemsPerDelivery;
        }
    }
    amount = amount * 2;
    IncreaseJobSkill(playerid, JOB_DRUGSMUGGLER);
    GivePlayerCash(playerid, amount);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}%s{33CCFF} for your delivery of drugs.", FormatCash(amount));

    if (gettime() - PlayerData[playerid][pSmuggleTime] < 60 && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        PlayerData[playerid][pACWarns]++;

        if (PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport drug smuggling (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerData[playerid][pSmuggleTime]);
        }
        else if (!PlayerData[playerid][pKicked])
        {
            BanPlayer(playerid, "Teleport drug smuggling");
        }
    }
    else
    {
        if (PlayerData[playerid][pGang] >= 0)
        {
            GiveGangPoints(PlayerData[playerid][pGang], 1);
        }
    }
    GiveNotoriety(playerid, 10);
    GivePlayerRankPointIllegalJob(playerid, 80);

    SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 10 notoriety for drug smuggling, you now have %d.", PlayerData[playerid][pNotoriety]);
    PlayerData[playerid][pSmuggleDrugs] = 0;
    return 1;
}
