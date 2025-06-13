/// @file      Job_Fisherman.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static const FisherZone[] = {100, -4500, 900, -2150}; // MinX MinY MaxX MaxY
static const FisherNet[]  = {723, -1495, 2};

static Fisher_DolphinSellValue = 3;
static Fisher_SharkSellValue   = 1;
static Fisher_CrabSellValue    = 2;
static Fisher_SmallNetCost     = 200;
static Fisher_MediumNetCost    = 350;
static Fisher_LargeNetCost     = 500;
static Fisher_SmallNetSize     = 100;
static Fisher_MediumNetSize    = 200;
static Fisher_LargeNetSize     = 300;
static Fisher_MaxFishWeight    = 1500;
static Fisher_BaseSellPrice    = 50;
static Fisher_RandomSellPrice  = 300;
static Fisher_UnitSellPrice    = 1;

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "fisherman", config))
    {
        JSON_GetInt(config, "dolphin_sell_value",Fisher_DolphinSellValue);
        JSON_GetInt(config, "shark_sell_value",  Fisher_SharkSellValue);
        JSON_GetInt(config, "crab_sell_value",   Fisher_CrabSellValue);
        JSON_GetInt(config, "small_net_cost",    Fisher_SmallNetCost);
        JSON_GetInt(config, "medium_net_cost",   Fisher_MediumNetCost);
        JSON_GetInt(config, "large_net_cost",    Fisher_LargeNetCost);
        JSON_GetInt(config, "small_net_size",    Fisher_SmallNetSize);
        JSON_GetInt(config, "medium_net_size",   Fisher_MediumNetSize);
        JSON_GetInt(config, "large_net_size",    Fisher_LargeNetSize);
        JSON_GetInt(config, "max_fish_weight",   Fisher_MaxFishWeight);
        JSON_GetInt(config, "base_sell_price",   Fisher_BaseSellPrice);
        JSON_GetInt(config, "random_sell_price", Fisher_RandomSellPrice);
        JSON_GetInt(config, "unit_sell_price",   Fisher_UnitSellPrice);
    }

    //Fisher Net
    SetTimer("fishsPrices", 2000, true);

    new string[128];
    format(string, sizeof string, "{33CCFF}Type '/net' to purchase \n\n{33CCFF}A Fishing Net");
    CreateDynamic3DTextLabel(string, COLOR_YELLOW, FisherNet[0], FisherNet[1], FisherNet[2], 10.0, .testlos = 1, .streamdistance = 10.0);
    CreateDynamicPickup(1239, 1, FisherNet[0], FisherNet[1], FisherNet[2]);

    //Fish biz door
    CreateDynamicObject(1522, 394.50470, -2052.61890, 6.80930,   0.00000, 0.00000, 270.00000);
    return 1;
}

hook OnPlayerInit(playerid)
{
    //Fisher
    new fisherZone = GangZoneCreateEx(FisherZone[0],FisherZone[1], FisherZone[2], FisherZone[3]);
    GangZoneShowForPlayer(playerid, fisherZone, 0x0578f8AA);
    return 1;
}

publish fishsPrices()
{
    new string[512];
    new weatherscore = GetWeatherScore();
    new dolphinprice = Fisher_DolphinSellValue * weatherscore;
    new sharkprice   = Fisher_SharkSellValue   * weatherscore;
    new crabprice    = Fisher_CrabSellValue    * weatherscore;
    format(string, sizeof(string), "Dolphin: $%d~n~Shark: $%d~n~Crab: $%d", dolphinprice, sharkprice,crabprice);

    foreach(new playerid : Player)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5, FisherNet[0], FisherNet[1], FisherNet[2]))
        {
            GameTextForPlayer(playerid, string, 5000, 3);
        }
    }
}

GetWeatherScore()
{
    switch (GetDBWeatherID())
    {
        case 0..7 :     { return 5;}     //Blue skies
        case 8 :        { return 2;}     //Stormy
        case 9 :        { return 3;}     // Cloudy and foggy
        case 10 :       { return 5;}     // Clear blue sky
        case 11 :       { return 3;}     //Heatwave
        case 12..15 :   { return 3;}     //Dull, colourless
        case 16 :       { return 3;}     //Dull, cloudy ,rainy
        case 17..18 :   { return 3;}     //Heatwave
        case 19 :       { return 1;}     //Sandstorm
        case 20 :       { return 2;}     //Foggy, Greenish
        case 21 :       { return 2;}     //Very dark, gradiented skyline, purple
        case 22 :       { return 2;}     //Very dark, gradiented skyline, purple
        case 23..26 :   { return 4;}     //Pale orange
        case 27..29 :   { return 3;}     //Fresh blue
        case 30..32 :   { return 2;}     //Dark, cloudy, teal
        case 33 :       { return 2;}     //Dark, cloudy, brown
        case 34 :       { return 5;}     //Blue/purple, regular
        case 35 :       { return 3;}     //Dull brown
        case 36..38 :   { return 4;}     //Bright, foggy, orange
        case 39 :       { return 4;}     //Very bright
        case 40..42 :   { return 3;}     //Blue/purple cloudy
        case 43 :       { return 2;}     //Toxic clouds
        case 44 :       { return 1;}     //Black/white sky
        case 51..53 :   { return 3;}     //Amazing draw distance
        case 700 :      { return 1;}     //Stormy weather with pink sky and crystal water
        case 150 :      { return 1;}     //Darkest weather ever
    }
    return 0;

}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_FISHER)
        return 1;

    if (IsPlayerInRangeOfPoint(playerid, 20, 724, -1510, -0.22))
    {
        new weatherscore = GetWeatherScore();
        new dolphinprice = Fisher_DolphinSellValue * weatherscore * PlayerData[playerid][pDolphinWeight];
        new sharkprice   = Fisher_SharkSellValue   * weatherscore * PlayerData[playerid][pSharkWeight];
        new crabprice    = Fisher_CrabSellValue    * weatherscore * PlayerData[playerid][pCrabWeight];
        PlayerData[playerid][pCash] += dolphinprice + sharkprice + crabprice;
        PlayerData[playerid][pDolphinWeight]=0;
        PlayerData[playerid][pDolphinCount]=0;
        PlayerData[playerid][pSharkWeight]=0;
        PlayerData[playerid][pSharkCount]=0;
        PlayerData[playerid][pCrabWeight]=0;
        PlayerData[playerid][pCrabCount]=0;
        PlayerData[playerid][pNetSize]=0;
        if (PlayerData[playerid][pDolphinWeight])
            SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d kg of Dolphin for $%d.",PlayerData[playerid][pDolphinWeight],dolphinprice);
        if (PlayerData[playerid][pSharkWeight])
            SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d kg of Shark for $%d.",PlayerData[playerid][pSharkWeight],sharkprice);
        if (PlayerData[playerid][pCrabWeight])
            SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d kg of Crab for $%d.",PlayerData[playerid][pCrabWeight],crabprice );
        SendClientMessageEx(playerid, COLOR_AQUA, "You sold all catched fishes and you got $%d.",crabprice + sharkprice + dolphinprice );
        GivePlayerRankPointLegalJob(playerid, 500);
        IncreaseJobSkill(playerid, JOB_FISHERMAN);
    }
    else
    {
        GameTextForPlayer(playerid, "REELING IN FISH...~n~PLEASE WAIT.", 5000, 3);
        TogglePlayerControllableEx(playerid, 0);
        SetTimerEx("fisherwait", 5000, false, "i", playerid);
    }
    return 1;
}

publish fisherwait(playerid)
{
    //ShowPlayerFooter(playerid, "Truck was Loaded....~n~Deliver it to the destination business.");
    TogglePlayerControllableEx(playerid, 1);
    new DolphinWeight   = Random(1, 40);
    new DolphinCount    = Random(1, 20);
    new SharkWeight     = Random(1, 20);
    new SharkCount      = Random(1, 20);
    new CrabWeight      = Random(1, 20);
    new CrabCount       = Random(1, 20);

    PlayerData[playerid][pDolphinWeight]+= DolphinWeight;
    PlayerData[playerid][pDolphinCount] += DolphinCount;
    PlayerData[playerid][pSharkWeight]  += SharkWeight;
    PlayerData[playerid][pSharkCount]   += SharkCount;
    PlayerData[playerid][pCrabWeight]   += CrabWeight;
    PlayerData[playerid][pCrabCount]    += CrabCount;

    SendClientMessageEx(playerid, COLOR_AQUA, "You catched %d Dolphin weighting %d Kg.",DolphinCount,DolphinWeight);
    SendClientMessageEx(playerid, COLOR_AQUA, "You catched %d Shark weighting %d Kg.",SharkCount,SharkWeight);
    SendClientMessageEx(playerid, COLOR_AQUA, "You catched %d Crab weighting %d Kg.",CrabCount,CrabWeight );

    if (PlayerData[playerid][pNetSize] <= PlayerData[playerid][pDolphinWeight] + PlayerData[playerid][pSharkWeight] + PlayerData[playerid][pCrabWeight])
    {
        SetActiveRaceCheckpoint(playerid, CHECKPOINT_FISHER, 724, -1510, 0, 10.0);
        SendClientMessage(playerid, COLOR_AQUA, "You net is full now return to Santa Marina to get your paid.");
    }
    else
    {
        new x = Random(5000 + FisherZone[0],5000 + FisherZone[2]) - 5000;
        new y = Random(5000 + FisherZone[1],5000 + FisherZone[3]) - 5000;
        SetActiveRaceCheckpoint(playerid, CHECKPOINT_FISHER, x, y, 0, 10.0);
    }
}

CMD:gofish(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_FISHERMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
    }
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if (!(FisherZone[0] < x < FisherZone[2] && FisherZone[1] < y < FisherZone[3]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in deep enough water. (Los Santos South Coast)");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have a checkpoint. Use /kcp to remove it.");
    }
    if (PlayerData[playerid][pNetSize] <= PlayerData[playerid][pDolphinWeight] + PlayerData[playerid][pSharkWeight] + PlayerData[playerid][pCrabWeight])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your net is full.");
    }
    x = Random(5000 + FisherZone[0],5000 + FisherZone[2]) - 5000;
    y = Random(5000 + FisherZone[1],5000 + FisherZone[3]) - 5000;
    SetActiveRaceCheckpoint(playerid, CHECKPOINT_FISHER, x, y, 0, 10.0);
    return 1;
}

CMD:endfish(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_FISHERMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
    }
    SetActiveRaceCheckpoint(playerid, CHECKPOINT_FISHER, 724, -1510, 0, 10.0);
    return SendClientMessage(playerid, COLOR_AQUA, "Return to Santa Marina to get your paid.");
}

IsPlayerAtFishingPlace(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 1.0, 403.8266, -2088.7598, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 398.7553, -2088.7490, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 396.2197, -2088.6692, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 391.1094, -2088.7976, 7.8359))
    {
        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 1.0, 383.4157, -2088.7849, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 374.9598, -2088.7979, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 369.8107, -2088.7927, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 367.3637, -2088.7925, 7.8359))
    {
        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 1.0, 362.2244, -2088.7981, 7.8359) || IsPlayerInRangeOfPoint(playerid, 1.0, 354.5382, -2088.7979, 7.8359))
    {
        return 1;
    }

    return 0;
}

CMD:fish(playerid, params[])
{
    /*if (!PlayerHasJob(playerid, JOB_FISHERMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
    }*/
    if (!PlayerData[playerid][pFishingRod])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a fishing rod. You need a fishing rod to fish!");
    }
    if (PlayerData[playerid][pFishTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are fishing already. Wait for your line to be reeled in first.");
    }
    if (PlayerData[playerid][pFishWeight] >= Fisher_MaxFishWeight)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have too much Anchovy and can't fish any longer.");
    }
    if (!IsABoat(GetPlayerVehicleID(playerid)) && !(IsPlayerAtFishingPlace(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT))
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not close to anywhere where you can fish.");
        return SendClientMessage(playerid, COLOR_GREY, "You can fish using a boat or in Santa Maria Beach.");
    }

    ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 0, 0, 0, 1, 0, 1);
    SetPlayerAttachedObject(playerid, 9, 18632, 6, 0.112999, 0.024000, 0.000000, -172.999954, 28.499994, 0.000000);
    ShowActionBubble(playerid, "* %s reels the line of their fishing rod into the water.", GetRPName(playerid));
    PlayerData[playerid][pFishTime] = 6;

    if (PlayerData[playerid][pFishingBait] > 0)
    {
        PlayerData[playerid][pFishingBait]--;
        PlayerData[playerid][pUsedBait] = 1;
        DBQuery("UPDATE "#TABLE_USERS" SET fishingbait = fishingbait - 1 WHERE uid = %i", PlayerData[playerid][pID]);
        //SendClientMessage(playerid, COLOR_AQUA, "* You used one fish bait. Your odds of catching a bigger fish are increased!");
    }
    else
    {
        PlayerData[playerid][pUsedBait] = 0;
    }
    return 1;
}


CMD:sellfish(playerid, params[])
{
    new businessid;

    /*if (!PlayerHasJob(playerid, JOB_FISHERMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
    }*/
    if ((businessid = GetInsideBusiness(playerid)) == -1 || BusinessInfo[businessid][bType] != BUSINESS_STORE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any Supermarket business.");
    }
    if (!PlayerData[playerid][pFishWeight])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no Anchovy which you can sell.");
    }

    new amount = (PlayerData[playerid][pFishWeight] * Fisher_UnitSellPrice) + random(Fisher_RandomSellPrice) + Fisher_BaseSellPrice;

    if (PlayerData[playerid][pLaborUpgrade] > 0)
    {
        amount += percent(amount, PlayerData[playerid][pLaborUpgrade]);
    }

    SendClientMessageEx(playerid, COLOR_AQUA, "* You earned {00AA00}$%i{33CCFF} for selling %i g of Anchovy.", amount, PlayerData[playerid][pFishWeight]);
    GivePlayerCash(playerid, amount);
    GivePlayerRankPointLegalJob(playerid, amount / 100);

    DBQuery("UPDATE "#TABLE_USERS" SET fishweight = 0 WHERE uid = %i", PlayerData[playerid][pID]);


    PlayerData[playerid][pFishWeight] = 0;
    return 1;
}

CMD:myfish(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ My Fish _______");
    SendClientMessageEx(playerid, COLOR_GREY2, "* %i/%i g of anchovy", PlayerData[playerid][pFishWeight], Fisher_MaxFishWeight);
    if (PlayerHasJob(playerid, JOB_FISHERMAN))
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "- %i Dolphin(s) weighing %i kg.", PlayerData[playerid][pDolphinCount], PlayerData[playerid][pDolphinWeight]);
        SendClientMessageEx(playerid, COLOR_AQUA, "- %i Shark(s) weighing %i kg.", PlayerData[playerid][pSharkCount], PlayerData[playerid][pSharkWeight]);
        SendClientMessageEx(playerid, COLOR_AQUA, "- %i Crab(s) weighing %i kg.", PlayerData[playerid][pCrabCount], PlayerData[playerid][pCrabWeight]);
        SendClientMessageEx(playerid, COLOR_GREY, "You can hold up to %i kg of fish in your boat.", PlayerData[playerid][pNetSize]);
    }

    return 1;
}


CMD:net(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_FISHERMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 5, FisherNet[0], FisherNet[1], FisherNet[2]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're not at the Fishing Net Retailers, go to Santa Marina.");
    }

    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_GREY, "USAGE: /net [small/medium/large]");
        return SendClientMessageEx(playerid, COLOR_GREY, "Prices: Small - %s, Medium - %s, Large - %s",
                                   FormatCash(Fisher_SmallNetCost),
                                   FormatCash(Fisher_MediumNetCost),
                                   FormatCash(Fisher_LargeNetCost));
    }

    new netSize, cost;
    if (strcmp(params, "small", true) == 0)       { cost = Fisher_SmallNetCost;  netSize = Fisher_SmallNetSize;  }
    else if (strcmp(params, "medium", true) == 0) { cost = Fisher_MediumNetCost; netSize = Fisher_MediumNetSize; }
    else if (strcmp(params, "large", true) == 0)  { cost = Fisher_LargeNetCost;  netSize = Fisher_LargeNetSize;  }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "USAGE: /net [small/medium/large]");
        return SendClientMessage(playerid, COLOR_GREY, "Prices: Small - $200, Medium - $350, Large - 500$");
    }

    if (PlayerData[playerid][pNetSize] == netSize)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have this type of net.");
    }
    else if (PlayerData[playerid][pNetSize] > netSize)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have a more big net.");
    }

    if (PlayerData[playerid][pCash] < cost)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to buy that net.");
    }
    PlayerData[playerid][pCash] -= cost;
    PlayerData[playerid][pNetSize] = netSize;

    SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a %s fishing net for $%d.",params,cost);
    SendClientMessageEx(playerid, COLOR_AQUA, "You can carry roughly about %d kg of fish in your boat.",PlayerData[playerid][pNetSize]);

    return 1;
}
