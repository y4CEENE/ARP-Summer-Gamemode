/// @file      Job_DrugDealer.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static DD_WeedObject[MAX_PLAYERS];
static DD_PickPlant[MAX_PLAYERS];
static DD_PickTime[MAX_PLAYERS];
static DD_CookHeroin[MAX_PLAYERS];
static DD_CookTime[MAX_PLAYERS];
static DD_CookGrams[MAX_PLAYERS];
static DD_WeedPlanted[MAX_PLAYERS];
static DD_WeedTime[MAX_PLAYERS];
static DD_WeedGrams[MAX_PLAYERS];
static Float:DD_WeedX[MAX_PLAYERS];
static Float:DD_WeedY[MAX_PLAYERS];
static Float:DD_WeedZ[MAX_PLAYERS];
static Float:DD_WeedA[MAX_PLAYERS];

static DD_SeedPrice           = 60;
static DD_CocainePrice        = 60;
static DD_ChemsPrice          = 60;
static DD_SeedsPerPlant       = 10;
static DD_PlantGrowingSeconds = 3600;
static DD_HeroinCookSeconds   = 15;
static DD_PlantPickSeconds    = 5;
static DD_PlantTotalWeeds     = 30;

stock GetPlayerWeedTime(playerid)
{
    return DD_WeedTime[playerid];
}

stock GetPlayerWeedGrams(playerid)
{
    return DD_WeedGrams[playerid];
}


ResetCooking(playerid)
{
    DD_CookHeroin[playerid]  = 0;
    DD_CookGrams[playerid] = 0;
    DD_CookTime[playerid]  = 0;
}

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "drug_dealer", config))
    {
        JSON_GetInt(config, "seed_price",            DD_SeedPrice);
        JSON_GetInt(config, "cocaine_price",         DD_CocainePrice);
        JSON_GetInt(config, "chem_price",            DD_ChemsPrice);
        JSON_GetInt(config, "seeds_per_plant",       DD_SeedsPerPlant);
        JSON_GetInt(config, "plant_growing_seconds", DD_PlantGrowingSeconds);
        JSON_GetInt(config, "heroin_cook_seconds",   DD_HeroinCookSeconds);
        JSON_GetInt(config, "plant_pick_seconds",    DD_PlantPickSeconds);
        JSON_GetInt(config, "plant_total_weeds",     DD_PlantTotalWeeds);
    }
}

hook OnPlayerInit(playerid)
{
    DD_WeedObject[playerid]  = INVALID_OBJECT_ID;
    DD_PickPlant[playerid]   = INVALID_PLAYER_ID;
    DD_PickTime[playerid]    = 0;
    DD_CookHeroin[playerid]    = 0;
    DD_CookTime[playerid]    = 0;
    DD_CookGrams[playerid]   = 0;
    DD_WeedPlanted[playerid] = 0;
    DD_WeedTime[playerid]    = 0;
    DD_WeedGrams[playerid]   = 0;
    DD_WeedX[playerid]       = 0;
    DD_WeedY[playerid]       = 0;
    DD_WeedZ[playerid]       = 0;
    DD_WeedA[playerid]       = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (IsValidDynamicObject(DD_WeedObject[playerid]))
    {
        DestroyDynamicObject(DD_WeedObject[playerid]);
    }
}

DestroyWeedPlant(playerid)
{
    if (DD_WeedPlanted[playerid])
    {
        DestroyDynamicObject(DD_WeedObject[playerid]);

        DBQuery("UPDATE "#TABLE_USERS" SET weedplanted = 0, weedtime = 0, weedgrams = 0, weed_x = 0.0, weed_y = 0.0, weed_z = 0.0, weed_a = 0.0 WHERE uid = %i", PlayerData[playerid][pID]);

        DD_WeedPlanted[playerid] = 0;
        DD_WeedTime[playerid] = 0;
        DD_WeedGrams[playerid] = 0;
        DD_WeedX[playerid] = 0.0;
        DD_WeedY[playerid] = 0.0;
        DD_WeedZ[playerid] = 0.0;
        DD_WeedA[playerid] = 0.0;
    }
}

hook OnLoadPlayer(playerid, row)
{
    DD_WeedPlanted[playerid] = GetDBIntField(row, "weedplanted");
    DD_WeedTime[playerid] = GetDBIntField(row, "weedtime");
    DD_WeedGrams[playerid] = GetDBIntField(row, "weedgrams");
    DD_WeedX[playerid] = GetDBFloatField(row, "weed_x");
    DD_WeedY[playerid] = GetDBFloatField(row, "weed_y");
    DD_WeedZ[playerid] = GetDBFloatField(row, "weed_z");
    DD_WeedA[playerid] = GetDBFloatField(row, "weed_a");

    if (!PlayerData[playerid][pSetup] &&
        DD_WeedPlanted[playerid] &&
        DD_WeedObject[playerid] == INVALID_OBJECT_ID)
    {
        DD_WeedObject[playerid] = CreateDynamicObject(3409, DD_WeedX[playerid], DD_WeedY[playerid], DD_WeedZ[playerid] - 1.8, 0.0, 0.0, DD_WeedA[playerid]);
    }
}

hook OnPlayerHeartBeat(playerid)
{
    if (DD_WeedPlanted[playerid] && DD_WeedTime[playerid] > 0)
    {
        DD_WeedTime[playerid]--;

        if ((DD_WeedTime[playerid] % (DD_PlantGrowingSeconds / DD_PlantTotalWeeds)) == 0)
        {
            DD_WeedGrams[playerid]++;
        }
    }

    if (DD_PickPlant[playerid] != INVALID_PLAYER_ID)
    {
        DD_PickTime[playerid]--;

        if (DD_PickTime[playerid] <= 0)
        {
            new planterid = DD_PickPlant[playerid];

            if (!IsPlayerConnected(planterid) || !PlayerData[planterid][pLogged] || !DD_WeedPlanted[planterid])
            {
                SendClientMessage(playerid, COLOR_GREY, "This plant is no longer available to pick.");
            }
            else if (!IsPlayerInRangeOfPoint(playerid, 3.0, DD_WeedX[planterid], DD_WeedY[planterid], DD_WeedZ[planterid]))
            {
                SendClientMessage(playerid, COLOR_GREY, "Picking failed. You left the area of the plant.");
            }
            else if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
            {
                SendClientMessage(playerid, COLOR_GREY, "Picking failed. You must stay crouched when picking a plant.");
            }
            else
            {
                PlayerData[playerid][pWeed] += DD_WeedGrams[planterid];
                DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have harvested %i grams of weed from this plant.", DD_WeedGrams[planterid]);
                DestroyWeedPlant(planterid);
            }

            DD_PickPlant[playerid] = INVALID_PLAYER_ID;
            DD_PickTime[playerid] = 0;
        }
    }
    if (DD_CookHeroin[playerid] > 0)
    {
        DD_CookTime[playerid]--;

        if (DD_CookTime[playerid] <= 0)
        {
            if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1.2179, 2.8095, 999.4284))
            {
                SendClientMessage(playerid, COLOR_GREY, "Cooking failed. You have left the cooking spot.");
                ResetCooking(playerid);
            }
            else if (PlayerData[playerid][pChemicals] <= 0)
            {
                SendClientMessage(playerid, COLOR_GREY, "Cooking failed. You have ran out of chemicals.");
                ResetCooking(playerid);
            }
            else if (PlayerData[playerid][pHeroin] + 2 > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
            {
                SendClientMessage(playerid, COLOR_GREY, "Cooking failed. You have ran out of inventory space for Heroin.");
                ResetCooking(playerid);
            }
            else
            {
                GameTextForPlayer(playerid, "~g~+2~w~ grams of Heroin", 3000, 3);

                PlayerData[playerid][pChemicals] -= 1;
                PlayerData[playerid][pHeroin] += 2;
                DD_CookGrams[playerid] += 2;

                if ((DD_CookGrams[playerid] % 4) == 0)
                {
                    PlayerData[playerid][pMuriaticAcid]--;
                }

                DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i, heroin = %i, muriaticacid = %i WHERE uid = %i", PlayerData[playerid][pChemicals], PlayerData[playerid][pHeroin], PlayerData[playerid][pMuriaticAcid], PlayerData[playerid][pID]);

                if (!PlayerData[playerid][pChemicals])
                {
                    SendClientMessageEx(playerid, COLOR_LIGHTRED, "You ran out of chemicals therefore ending your cookoff. You made %i grams of Heroin from %i grams of chemicals.", DD_CookGrams[playerid], DD_CookGrams[playerid] / 2);
                    ResetCooking(playerid);
                }
                else if (!PlayerData[playerid][pMuriaticAcid])
                {
                    SendClientMessageEx(playerid, COLOR_LIGHTRED, "You ran out of muriatic acid therefore ending your cookoff. You made %i grams of Heroin from %i grams of chems.", DD_CookGrams[playerid], DD_CookGrams[playerid] / 2);
                    ResetCooking(playerid);
                }
                else if (PlayerData[playerid][pHeroin] >= GetPlayerCapacity(playerid, CAPACITY_HEROIN))
                {
                    SendClientMessageEx(playerid, COLOR_LIGHTRED, "You ran out of inventory space for heroin therefore ending your cookoff. You made %i grams of heroin from %i grams of chems.", DD_CookGrams[playerid], DD_CookGrams[playerid] / 2);
                    ResetCooking(playerid);
                }
                else
                {
                    DD_CookTime[playerid] = DD_HeroinCookSeconds;
                }
            }
        }
    }
}

CMD:plantweed(playerid, params[])
{
    if (DD_WeedPlanted[playerid] == 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have 1 active weed plant already.");
    }
    if (PlayerData[playerid][pSeeds] < 10)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough seeds. You need at least 10 seeds in order to plant them.");
    }
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't plant indoors.");
    }

    GetPlayerPos(playerid, DD_WeedX[playerid], DD_WeedY[playerid], DD_WeedZ[playerid]);
    GetPlayerFacingAngle(playerid, DD_WeedA[playerid]);

    PlayerData[playerid][pSeeds] -= DD_SeedsPerPlant;
    DD_WeedPlanted[playerid] = 1;
    DD_WeedTime[playerid] = DD_PlantGrowingSeconds;
    DD_WeedGrams[playerid] = 0;
    DD_WeedObject[playerid] = CreateDynamicObject(3409, DD_WeedX[playerid], DD_WeedY[playerid], DD_WeedZ[playerid] - 1.8, 0.0, 0.0, DD_WeedA[playerid]);

    DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i, weedplanted = 1, weedtime = %i, weedgrams = %i, weed_x = '%f', weed_y = '%f', weed_z = '%f', weed_a = '%f' WHERE uid = %i", PlayerData[playerid][pSeeds], DD_WeedTime[playerid], DD_WeedGrams[playerid], DD_WeedX[playerid], DD_WeedY[playerid], DD_WeedZ[playerid], DD_WeedA[playerid], PlayerData[playerid][pID]);

    ShowActionBubble(playerid, "* %s plants some seeds into the ground.", GetRPName(playerid));
    SendClientMessage(playerid, COLOR_GREEN, "You have planted a weed plant. Every two minutes your plant will grow one gram of weed.");
    SendClientMessage(playerid, COLOR_GREEN, "Your plant will be ready in 60 minutes. Be careful, as anyone who sees your plant can pick it!");
    return 1;
}

CMD:plantinfo(playerid, params[])
{
    foreach(new i : Player)
    {
        if (DD_WeedPlanted[i] && IsPlayerInRangeOfPoint(playerid, 3.0, DD_WeedX[i], DD_WeedY[i], DD_WeedZ[i]))
        {
            ShowActionBubble(playerid, "* %s inspects the plant.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "* This plant has so far grown %i grams of weed. It will be ready in %i/60 minutes.", DD_WeedGrams[i], DD_WeedTime[i]);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any plants.");
    return 1;
}

CMD:destroyplant(playerid, params[])
{
    if (IsLawEnforcement(playerid))
    {
        if (DD_WeedPlanted[playerid] && IsPlayerInRangeOfPoint(playerid, 3.0, DD_WeedX[playerid], DD_WeedY[playerid], DD_WeedZ[playerid]))
        {
            DD_PickPlant[playerid] = playerid;
            DestroyWeedPlant(playerid);
            SendClientMessage(playerid, COLOR_GREY, "You've destroyed the plant, reward $738");
            GivePlayerCash(playerid, 738);
        }
    }
    else return SendClientMessage(playerid, COLOR_GREY, "You are not a cop");
    return 1;
}

CMD:pickplant(playerid, params[])
{
    if (IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cant pickup plants as a cop, use /destroyplant instead");
    }

    foreach(new i : Player)
    {
        if (DD_WeedPlanted[i] && IsPlayerInRangeOfPoint(playerid, 3.0, DD_WeedX[i], DD_WeedY[i], DD_WeedZ[i]))
        {
            if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You need to be crouched in order to pick a plant.");
            }
            if (DD_WeedGrams[i] < 2)
            {
                return SendClientMessage(playerid, COLOR_GREY, "This plant hasn't grown that much yet. Wait a little while first.");
            }
            if (PlayerData[playerid][pWeed] + DD_WeedGrams[i] > GetPlayerCapacity(playerid, CAPACITY_WEED))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
            }
            DD_PickPlant[playerid] = i;
            DD_PickTime[playerid] = DD_PlantPickSeconds;
            GivePlayerRankPoints(playerid, 100);
            ShowActionBubble(playerid, "* %s crouches down and starts picking at the weed plant.", GetRPName(playerid));
            return 1;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any plants.");
    return 1;
}

CMD:seizeplant(playerid, params[])
{
    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }

    foreach(new i : Player)
    {
        if (DD_WeedPlanted[i] && IsPlayerInRangeOfPoint(playerid, 3.0, DD_WeedX[i], DD_WeedY[i], DD_WeedZ[i]))
        {
            ShowActionBubble(playerid, "* %s seizes a weed plant weighing %i grams.", GetRPName(playerid), DD_WeedGrams[i]);
            DestroyWeedPlant(i);
            return 1;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any plants.");
    return 1;
}

CMD:cookheroin(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1.2179, 2.8095, 999.4284))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in Heisenberg's trailer. You can't use this command.");
    }
    if (!DD_CookHeroin[playerid])
    {
        if (!PlayerData[playerid][pChemicals])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have any Chems which you could turn into Heroin.");
        }
        if (!PlayerData[playerid][pMuriaticAcid])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need muriatic acid in order to cook Heroin. Go buy some at 24/7.");
        }

        DD_CookHeroin[playerid] = 1;
        DD_CookTime[playerid] = DD_HeroinCookSeconds;
        DD_CookGrams[playerid] = 0;

        SendClientMessageEx(playerid, COLOR_GREEN, "You have started cooking Heroin. One gram of chems will turn into 2 grams of Heroin every %i seconds.", DD_HeroinCookSeconds);
        SendClientMessage(playerid, COLOR_GREEN, "Type the /cookheroin command again in order to stop cooking.");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "You have stopped cooking. You converted %i grams of chems into %i grams of Heroin.", DD_CookGrams[playerid] / 2, DD_CookGrams[playerid]);
        ResetCooking(playerid);
    }
    return 1;
}

CMD:getseeds(playerid, params[])
{
    new amount, cost;

    if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getseeds [amount]");
    }

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 321.8347, 1117.1797, 1083.8828))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of the drug den.");
    }
    if (amount < 1 || amount > 10)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't buy less than 1 or more than 10 seeds at a time.");
    }
    if (amount > gSeedsStock)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There aren't that many seeds left in stock.");
    }
    if (PlayerData[playerid][pCash] < (cost = amount * DD_SeedPrice))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy that many seeds.");
    }
    if (PlayerData[playerid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i seeds. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS));
    }
    gSeedsStock -= amount;
    PlayerData[playerid][pSeeds] += amount;
    GivePlayerCash(playerid, -cost);
    DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased %i weed seeds for {00AA00}$%i{33CCFF}. /planthelp for more help.", amount, cost);
    return 1;
}

CMD:getcocaine(playerid, params[])
{
    new amount, cost;

    if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getcocaine [amount]");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2342.7766, -1187.0839, 1027.9766))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of the cocaine house.");
    }
    if (amount < 1 || amount > 10)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't buy less than 1 or more than 10 grams at a time.");
    }
    if (amount > gCocaineStock)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There isn't that much cocaine left in stock.");
    }
    if (PlayerData[playerid][pCash] < (cost = amount * DD_CocainePrice))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy that many grams.");
    }
    if (PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
    }
    gCocaineStock -= amount;
    PlayerData[playerid][pCocaine] += amount;
    GivePlayerCash(playerid, -cost);
    DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased %i grams of cocaine for {00AA00}$%i{33CCFF}.", amount, cost);
    return 1;
}

CMD:getchems(playerid, params[])
{
    new amount, cost;

    if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getchems [amount]");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -942.1650, 1847.1581, 5.0051))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of the Chems lab.");
    }
    if (amount < 1 || amount > 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't buy less than 1 or more than 5 grams at a time.");
    }
    if (amount > gChemicalsStock)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There isn't that much chems left in stock.");
    }
    if (PlayerData[playerid][pCash] < (cost = amount * DD_ChemsPrice))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy that many grams.");
    }
    if (PlayerData[playerid][pChemicals] + amount > GetPlayerCapacity(playerid, CAPACITY_CHEMICALS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i chems. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pChemicals], GetPlayerCapacity(playerid, CAPACITY_CHEMICALS));
    }
    gChemicalsStock -= amount;
    PlayerData[playerid][pChemicals] += amount;
    GivePlayerCash(playerid, -cost);
    DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i WHERE uid = %i", PlayerData[playerid][pChemicals], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased %i grams of raw chems for {00AA00}$%i{33CCFF}.", amount, cost);
    return 1;
}
