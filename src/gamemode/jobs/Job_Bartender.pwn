/// @file      Job_Bartender.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static Bartender_BeerCost    = 60;
static Bartender_VodkaCost   = 100;
static Bartender_WhiskeyCost = 100;
static Bartender_WaterCost   = 20;
static Bartender_SodaCost    = 20;

enum bartenderStatusEnum{
    btDrinkOffer,
    btDrinkName[32],
    btDrinkPrice,
    btDrinkSpecialAction,
    btDrinkCooledDown
};

static BarTenderStatus[MAX_PLAYERS][bartenderStatusEnum];


hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "bartender", config))
    {
        JSON_GetInt(config, "beer_cost",    Bartender_BeerCost);
        JSON_GetInt(config, "vodka_cost",   Bartender_VodkaCost);
        JSON_GetInt(config, "whiskey_cost", Bartender_WhiskeyCost);
        JSON_GetInt(config, "water_cost",   Bartender_WaterCost);
        JSON_GetInt(config, "soda_cost",    Bartender_SodaCost);
    }
}

IsDrinking(playerid)
{
    new action = GetPlayerSpecialAction(playerid);
    return (
                (action == SPECIAL_ACTION_DRINK_BEER) ||
                (action == SPECIAL_ACTION_DRINK_WINE) ||
                (action == SPECIAL_ACTION_DRINK_SPRUNK)
    );
}

publish DrinkCooldown(playerid)
{
    BarTenderStatus[playerid][btDrinkCooledDown] = 1;
    return 1;
}

BarTenderKeyStateChanged(playerid, newkeys)
{
    if (!(IsDrinking(playerid) && (newkeys & KEY_FIRE)))
        return 1;
    if (BarTenderStatus[playerid][btDrinkCooledDown] == 1)
    {
        new Float: cHealth;
        GetPlayerHealth(playerid, cHealth);

        new action = GetPlayerSpecialAction(playerid);
        if (cHealth<100)
        {
            if (action == SPECIAL_ACTION_DRINK_WINE)
            {
                cHealth += 8;
            }
            else if (action == SPECIAL_ACTION_DRINK_BEER)
            {
                cHealth += 5;
            }
            else
            {
                cHealth += 2;
            }

            if (cHealth > 100)
            {
                cHealth = 100;
            }

            SetPlayerHealth(playerid, cHealth);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "* You finish up the drink and throw it away.");
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            return 1;
        }
        BarTenderStatus[playerid][btDrinkCooledDown] = 0;
        SetTimerEx("DrinkCooldown", 2500, 0, "i", playerid);
    }
    return 1;
}

Dialog:BarTenderGiveTip(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        BarTenderStatus[playerid][btDrinkOffer] = INVALID_PLAYER_ID;
        return 1;
    }
    if (GetPlayerCash(playerid) >= strval(inputtext))
    {
        if (strval(inputtext) <= 0 || strval(inputtext) > 1000)
        {
            return Dialog_Show(playerid, BarTenderGiveTip, DIALOG_STYLE_INPUT, "Tipping the Bartender", "Must be above $0 and below $1000.\nHow much would you like to tip the bartender for his service?", "OK", "Cancel");
        }

        SendNearbyMessage(playerid, 15.0, COLOR_AQUA, "** %s gives %s a tip for his service.", GetPlayerNameEx(playerid), GetPlayerNameEx(BarTenderStatus[playerid][btDrinkOffer]));
        SendClientMessageEx(BarTenderStatus[playerid][btDrinkOffer], COLOR_AQUA, "* %s has given you a tip of $%d for your service.", GetPlayerNameEx(playerid), strval(inputtext));

        GivePlayerCash(BarTenderStatus[playerid][btDrinkOffer], strval(inputtext));
        GivePlayerCash(playerid, -strval(inputtext));

        BarTenderStatus[playerid][btDrinkOffer] = INVALID_PLAYER_ID;
    }
    return 1;
}

Dialog:BarTenderTip(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        Dialog_Show(playerid, BarTenderGiveTip, DIALOG_STYLE_INPUT, "Tipping the Bartender", "How much would you like to tip the bartender for his service?", "OK", "Cancel");
    }
    else
    {
        BarTenderStatus[playerid][btDrinkOffer] = INVALID_PLAYER_ID;
    }
    return 1;
}

Dialog:BarTenderMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        BarTenderStatus[playerid][btDrinkOffer] = INVALID_PLAYER_ID;
        return 1;
    }
    new drinkname[32];
    new drinkprice;
    new dspecialaction;
    switch (listitem)
    {
        case 0:
        {
            drinkname = "Beer";
            drinkprice = Bartender_BeerCost;
            dspecialaction = SPECIAL_ACTION_DRINK_BEER;
        }
        case 1:
        {
            drinkname = "Vodka";
            drinkprice = Bartender_VodkaCost;
            dspecialaction = SPECIAL_ACTION_DRINK_WINE;
        }
        case 2:
        {
            drinkname = "Whiskey";
            drinkprice = Bartender_WhiskeyCost;
            dspecialaction = SPECIAL_ACTION_DRINK_WINE;
        }
        case 3:
        {
            drinkname = "Water";
            drinkprice = Bartender_WaterCost;
            dspecialaction = SPECIAL_ACTION_DRINK_SPRUNK;
        }
        case 4:
        {
            drinkname = "Soda";
            drinkprice = Bartender_SodaCost;
            dspecialaction = SPECIAL_ACTION_DRINK_SPRUNK;
        }
    }

    if (GetPlayerCash(playerid) < drinkprice)
    {
        return SendClientMessage(playerid, COLOR_AQUA, "* You don't have enough money for this drink!");
    }

    BarTenderStatus[playerid][btDrinkName] = drinkname;
    BarTenderStatus[playerid][btDrinkPrice] = drinkprice;
    BarTenderStatus[playerid][btDrinkSpecialAction] = dspecialaction;

    new string[140];
    format(string, sizeof(string), "You have asked the bartender for a drink of %s for $%d.\n Do you want to tip the bartender?", drinkname, drinkprice);
    Dialog_Show(playerid, BarTenderTip, DIALOG_STYLE_MSGBOX, "Drink Purchase", string, "Yes", "No");

    SendNearbyMessage(playerid, 15.0, COLOR_AQUA, "* %s pours %s a %s and hands it to them.", GetPlayerNameEx(BarTenderStatus[playerid][btDrinkOffer]), GetPlayerNameEx(playerid), drinkname);

    SendClientMessageEx(BarTenderStatus[playerid][btDrinkOffer], COLOR_AQUA, "* You pour %s a %s, they slide you the money. ($%d)", GetPlayerNameEx(playerid), drinkname, drinkprice);

    GivePlayerCash(BarTenderStatus[playerid][btDrinkOffer], drinkprice);
    GivePlayerCash(playerid, -drinkprice);

    SetPlayerSpecialAction(playerid, dspecialaction);
    BarTenderStatus[playerid][btDrinkCooledDown] = 1;

    return 1;
}

Accept:drink(playerid)
{
    if ((BarTenderStatus[playerid][btDrinkOffer] == INVALID_PLAYER_ID) || (!IsPlayerConnected(BarTenderStatus[playerid][btDrinkOffer])))
    {
        SendClientMessage(playerid, COLOR_GREY, " No-one has offered you a drink.");
        return 1;
    }
    if (!IsPlayerNearPlayer(playerid, BarTenderStatus[playerid][btDrinkOffer], 5.0))
    {
        SendClientMessage(playerid, COLOR_GREY, "You're too far away from the bartender.");
        BarTenderStatus[playerid][btDrinkOffer] = INVALID_PLAYER_ID;
        return 1;
    }

    if (!IsAtBar(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "   You're not at a Bar!");
        return 1;
    }

    new content[128];
    format(content, sizeof(content), "Beer (%s)\n"\
                                     "Vodka (%s)\n"\
                                     "Whiskey (%s)\n"\
                                     "Water (%s)\n"\
                                     "Soda (%s)",
                                     FormatCash(Bartender_BeerCost),
                                     FormatCash(Bartender_VodkaCost),
                                     FormatCash(Bartender_WhiskeyCost),
                                     FormatCash(Bartender_WaterCost),
                                     FormatCash(Bartender_SodaCost));

    Dialog_Show(playerid, BarTenderMenu, DIALOG_STYLE_LIST, "Available Drinks",
                content, "Purchase", "Cancel");
    return 1;
}

IsAtBar(playerid)
{
    if (IsPlayerConnected(playerid))
    {
        if (IsPlayerInRangeOfPoint(playerid,3.0,495.7801,-76.0305,998.7578) || IsPlayerInRangeOfPoint(playerid,3.0,499.9654,-20.2515,1000.6797) || IsPlayerInRangeOfPoint(playerid,9.0,1497.5735,-1811.6150,825.3397))
        {//In grove street bar (with girlfriend), and in Havanna
            return 1;
        }
        else if (IsPlayerInRangeOfPoint(playerid,4.0,1215.9480,-13.3519,1000.9219) || IsPlayerInRangeOfPoint(playerid,10.0,-2658.9749,1407.4136,906.2734) || IsPlayerInRangeOfPoint(playerid,10.0,2155.3367,-97.3984,3.8308))
        {//PIG Pen
            return 1;
        }
        else if (IsPlayerInRangeOfPoint(playerid,6.0,300.351287, 1030.323120, 1104.560058) || IsPlayerInRangeOfPoint(playerid,6.0,311.184661, 1011.819274, 1098.540039) || IsPlayerInRangeOfPoint(playerid,10.0,-1091.006958, 607.855773, 1116.507812))
        {// First two: Tableau Club - Last one: The Lubu Gentlemen's club
            return 1;
        }
        else if (IsPlayerInRangeOfPoint(playerid,6.0,255.606887, 1086.537109, 5099.806152))
        {// Santa Maria Surfer's Lounge.
            return 1;
        }
        else if (IsPlayerInRangeOfPoint(playerid,10.0,453.2437,-105.4000,999.5500) || IsPlayerInRangeOfPoint(playerid,10.0,1255.69, -791.76, 1085.38) ||
        IsPlayerInRangeOfPoint(playerid,10.0,2561.94, -1296.44, 1062.04) || IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) ||
        IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) || IsPlayerInRangeOfPoint(playerid, 10.0, 880.06, 1430.86, -82.34) ||
        IsPlayerInRangeOfPoint(playerid,10.0,499.96, -20.66, 1000.68))
        {
            //Bars
            return 1;
        }
    }
    return 0;
}


CMD:selldrink(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_BARTENDER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Bartender.");
    }

    if (!IsAtBar(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "   You're not at a Bar!");
        return 1;
    }


    new giveplayerid;
    if (sscanf(params, "u", giveplayerid))
        return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /selldrink [playerid]");

    if (!IsPlayerConnected(giveplayerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, " That player is not connected!");
    }
    if (playerid == giveplayerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, " You can't sell drinks to yourself.");
    }

    if (!IsPlayerNearPlayer(playerid, giveplayerid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, " That player is not near you!");
    }

    BarTenderStatus[giveplayerid][btDrinkOffer] = playerid;
    SendClientMessageEx(giveplayerid, COLOR_AQUA, "* Bartender %s has offered to pour you a drink. /accept drink to select a drink.", GetPlayerNameEx(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s a drink.",GetPlayerNameEx(giveplayerid));

    return 1;
}
