/// @file      Job_Bodyguard.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#error DISABLED: Job_Bodyguard

#include <YSI\y_hooks>

static VestOffer[MAX_PLAYERS];
static VestPrice[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    VestOffer[playerid] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid, reason)
{
    foreach(new i : Player)
    {
        if (VestOffer[i] == playerid)
        {
            VestOffer[i] = INVALID_PLAYER_ID;
        }
    }
}

CMD:sellvest(playerid, params[])
{
    //TODO: who can sell vest?
    new targetid, amount;
    if (true) //TODO: remove if
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Bodyguard.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellvest [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
    }
    if (amount < 500 || amount > 2500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount specified must range between $500 and $2500.");
    }
    if (gettime() - PlayerData[playerid][pLastSell] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
    }
    if (GetPlayerArmourEx(targetid) >= 50.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player already has a vest.");
    }
    PlayerData[playerid][pLastSell] = gettime();
    VestOffer[targetid] = playerid;
    VestPrice[targetid] = amount;
    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you a vest with %.1f points of armor for %s (/accept vest).", GetRPName(playerid), 50.0, FormatCash(amount));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You offered %s a vest with %.1f points of armor for %s.", GetRPName(targetid), 50.0, FormatCash(amount));
    return 1;
}

Accept:vest(playerid)
{
    new offeredby = VestOffer[playerid];
    new price = VestPrice[playerid];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a vest.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy the vest.");
    }

    new Float:armor = 50.0 ;

    SetScriptArmour(playerid, armor);
    GivePlayerCash(offeredby, price);
    GivePlayerCash(playerid, -price);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's vest and paid %s for %.1f armor points.", GetRPName(offeredby), FormatCash(price), armor);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your vest offer and paid %s for %.1f armor points.", GetRPName(playerid), FormatCash(price), armor);

    TurfTaxCheck(offeredby, price);

    VestOffer[playerid] = INVALID_PLAYER_ID;
    return 1;
}
