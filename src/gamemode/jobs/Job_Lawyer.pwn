/// @file      Job_Lawyer.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static Lawyer_MinFreePrice = 200;
static Lawyer_MaxFreePrice = 1000;
static Lawyer_MinDefendPrice = 500;
static Lawyer_MaxDefendPrice = 1500;
static Lawyer_NeutralizeCost = 2;

static DefendNOffer[MAX_PLAYERS];
static DefendNQuantity[MAX_PLAYERS];
static OfferFree[MAX_PLAYERS];
static OfferFreePrice[MAX_PLAYERS];
static LastLawyerRequest[MAX_PLAYERS];

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "lawyer", config))
    {
        JSON_GetInt(config, "min_free_price",   Lawyer_MinFreePrice);
        JSON_GetInt(config, "max_free_price",   Lawyer_MaxFreePrice);
        JSON_GetInt(config, "min_defend_price", Lawyer_MinDefendPrice);
        JSON_GetInt(config, "max_defend_price", Lawyer_MaxDefendPrice);
        JSON_GetInt(config, "neutralize_cost",  Lawyer_NeutralizeCost);
    }
}

hook OnPlayerInit(playerid)
{
    OfferFree[playerid] = INVALID_PLAYER_ID;
    OfferFreePrice[playerid] = 0;
    LastLawyerRequest[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    foreach(new i : Player)
    {
        if (OfferFree[i] == playerid)
        {
            OfferFree[i] = INVALID_PLAYER_ID;
        }
    }
}

AcceptNeutralize(playerid)
{
    new giveplayer = DefendNOffer[playerid];
    new noto = DefendNQuantity[playerid];
    new price_buy  = noto * Lawyer_NeutralizeCost;
    new price_sell = price_buy * 3 / 4;

    DefendNOffer[playerid] = INVALID_PLAYER_ID;
    DefendNQuantity[playerid] = 0;

    if (giveplayer == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   No-one offered you a neutralize!");
    }

    if (!IsPlayerConnected(giveplayer))
    {
        return SendClientMessage(playerid, COLOR_GREY, "   The lawyer has been disappeared!");
    }

    if (!IsPlayerNearPlayer(playerid, giveplayer, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You are not near lawyer.");
    }

    if (GetPlayerCash(playerid) < price_buy)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You can't afford the neutralize!");
    }

    GiveNotoriety(playerid, -noto);
    GiveNotoriety(giveplayer, -30);
    GivePlayerCash(giveplayer, price_sell);
    GivePlayerCash(playerid, - price_buy);
    IncreaseJobSkill(giveplayer, JOB_LAWYER);

    GivePlayerRankPointLegalJob(giveplayer, noto/100);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You accepted the neutralize for $%d (%d notoriety) from Lawyer %s.", price_buy, noto, GetPlayerNameEx(giveplayer));
    SendClientMessageEx(giveplayer, COLOR_AQUA, "* %s accepted your neutralize, you paid taxes and $%d was added to your money.",GetPlayerNameEx(playerid), price_sell);
    SendClientMessageEx(giveplayer, COLOR_AQUA, "You have lost -30 notoriety for legal affairs, you now have %d.", PlayerData[giveplayer][pNotoriety]);


    return 1;
}

CMD:defend(playerid, params[])
{
    new targetid, amount, time = (5 - GetJobLevel(playerid, JOB_LAWYER)) * 30;

    if (!PlayerHasJob(playerid, JOB_LAWYER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Lawyer.");
    }
    if (gettime() - PlayerData[playerid][pLastDefend] < time)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only defend a player every %i seconds. Please wait %i more seconds.", time, time - (gettime() - PlayerData[playerid][pLastDefend]));
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /defend [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't defend yourself.");
    }
    if (IsPlayerInBankRobbery(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't defend player while he is in bank robbery.");
    }
    if (!PlayerData[targetid][pWantedLevel])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not wanted.");
    }
    if (amount < Lawyer_MinDefendPrice || amount > Lawyer_MaxDefendPrice)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The amount can't be below %s or above %s.",
                FormatCash(Lawyer_MinDefendPrice), FormatCash(Lawyer_MaxDefendPrice));
    }

    PlayerData[targetid][pDefendOffer] = playerid;
    PlayerData[targetid][pDefendPrice] = amount;
    PlayerData[playerid][pLastDefend]  = gettime();

    SendClientMessageEx(targetid, COLOR_AQUA, "* Lawyer %s has offered to defend your wanted level for $%i. (/accept lawyer)", GetRPName(playerid), amount);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to defend %s's wanted level for $%i.", GetRPName(targetid), amount);
    return 1;
}

CMD:free(playerid, params[])
{
    new targetid, price, time = GetJobLevel(playerid, JOB_LAWYER);

    if (!PlayerHasJob(playerid, JOB_LAWYER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Lawyer.");
    }
    if (sscanf(params, "ui", targetid, price))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /free [playerid] [price]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (price < Lawyer_MinFreePrice || price > Lawyer_MaxFreePrice)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Price must be between %s and %s.",
                FormatCash(Lawyer_MinFreePrice), FormatCash(Lawyer_MaxFreePrice));
    }
    if (PlayerData[targetid][pJailType] != JailType_ICPrison)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not in IC jail.");
    }
    if (PlayerData[targetid][pJailTime] < time * 60)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't free this player, their jail time expires soon.");
    }
    OfferFree[targetid] = playerid;
    OfferFreePrice[targetid] = price;
    SendClientMessageEx(targetid, COLOR_AQUA, "* Lawyer %s has offered to decrease your jail time by %i minutes for $%i. (/accept free)", GetRPName(playerid), time, price);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to decrease your jail time by %i minutes for $%i.", GetRPName(targetid), time, price);
    return 1;
}

Accept:free(playerid)
{
    new offeredby = OfferFree[playerid];
    new price = OfferFreePrice[playerid];
    if (!IsPlayerConnected(offeredby))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers yet.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (price < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid price.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player doesn't have enought money.");
    }

    new time = GetJobLevel(playerid, JOB_LAWYER);
    PlayerData[playerid][pJailTime] -= time * 60;
    GivePlayerCash(playerid, -price);
    GivePlayerCash(offeredby, price * 3 / 4);

    GiveNotoriety(offeredby, -10);
    GivePlayerRankPointLegalJob(offeredby, 500);
    SendClientMessageEx(offeredby, COLOR_AQUA, "You have lost -10 notoriety for legal affairs, you now have %d.", PlayerData[offeredby][pNotoriety]);

    SendClientMessageEx(playerid, COLOR_AQUA, "* Lawyer %s has reduced your jail sentence by %i minutes.", GetRPName(offeredby), time);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* You have reduced %s's jail sentence by %i minutes.", GetRPName(playerid), time);
    return 1;
}

CMD:neutralize(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_LAWYER))
    {
        SendClientMessage(playerid, COLOR_GREY, "   You're not a Lawyer!");
        return 1;
    }

    new giveplayerid, noto;

    if (sscanf(params, "ud", giveplayerid, noto))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /neutralize [playerid] [notoriety]");
    }

    if (!IsPlayerConnected(giveplayerid))
    {
        return  SendClientMessage(playerid, COLOR_GREY, "Invalid player specified.");
    }

    if (giveplayerid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You can't offer neutralize to yourself!");
    }

    if (!IsPlayerNearPlayer(playerid, giveplayerid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, " That player is not near you!");
    }

    if (noto <= 0)
    {
        return  SendClientMessage(playerid, COLOR_GREY, "Invalid notoriety value.");
    }

    if (PlayerData[giveplayerid][pNotoriety] < noto)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Player does not have that much notoriety!");
    }

    new cash = noto * Lawyer_NeutralizeCost;

    SendClientMessageEx(playerid, COLOR_AQUA,  "* You offered to neutralize %s for $%d (%d notoriety).", GetPlayerNameEx(giveplayerid), cash, noto);
    SendClientMessageEx(giveplayerid, COLOR_AQUA, "* Lawyer %s wants to neutralize you for $%d (%d notoriety), (type /accept neutralize) to accept.", GetPlayerNameEx(playerid), cash, noto);
    DefendNOffer[giveplayerid] = playerid;
    DefendNQuantity[giveplayerid] = noto;

    return 1;
}

CMD:requestlawyer(playerid, params[])
{
    if (PlayerData[playerid][pJailType] != JailType_ICPrison)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be in IC prison to request a lawyer.");
    }

    if (gettime() - LastLawyerRequest[playerid] < 20)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can request a lawyer each 20 seconds.");
    }
    new counter = 0;
    foreach (new targetid : Player)
    {
        if (PlayerHasJob(targetid, JOB_LAWYER) && PlayerData[targetid][pJailType] == JailType_None)
        {
            counter++;
            SendClientMessageEx(targetid, COLOR_WHITE,  "* %s is requesting a lawyer to free him from the jail (%d seconds left).",
                                GetRPName(playerid), PlayerData[playerid][pJailTime]);
        }
    }
    if (counter)
    {
        LastLawyerRequest[playerid] = gettime();
        SendClientMessageEx(playerid, COLOR_WHITE, "* Request has been sent to %d lawyer(s).", counter);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY, "There is no lawyer in the city");
    }
    return 1;
}
