/// @file      Casino.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022


CMD:dicebet(playerid, params[])
{
    new targetid, amount;

    if (!IsPlayerInRangeOfPoint(playerid, 50.0, 1949.3925,1018.5336,992.4745))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the casino.");
    }
    if (PlayerData[playerid][pLevel] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be at least level 3+ in order to dice bet.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dicebet [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (PlayerData[targetid][pLevel] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player must be at least level 3+ to bet with them.");
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $1.");
    }
    if (PlayerData[playerid][pCash] < amount)
    {
        PlayerPlaySound(playerid, 5406, 0.0, 0.0, 0.0); // Sorry sir you do not have enough funds.
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money to bet.");
    }
    if (gettime() - PlayerData[playerid][pLastBet] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastBet]));
    }

    PlayerData[targetid][pDiceOffer] = playerid;
    PlayerData[targetid][pDiceBet] = amount;
    PlayerData[targetid][pDiceRigged] = 0;
    PlayerData[playerid][pLastBet] = gettime();

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has initiated a dice bet with you for $%i (/accept dicebet).", GetRPName(playerid), amount);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have initiated a dice bet against %s for $%i.", GetRPName(targetid), amount);
    return 1;
}

CMD:dicebetrigged(playerid, params[]) // Added to keep the economy in control. And to make people qq when they lose all their cash.
{
    new targetid, amount;

    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return -1;
    }
    if (!IsPlayerInRangeOfPoint(playerid, 50.0, 1949.3925,1018.5336,992.4745))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the casino.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dicebetrigged [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (PlayerData[targetid][pLevel] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player must be at least level 3+ to bet with them.");
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $1.");
    }
    if (PlayerData[playerid][pCash] < amount)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money to bet.");
    }
    if (gettime() - PlayerData[playerid][pLastBet] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastBet]));
    }

    PlayerData[targetid][pDiceOffer] = playerid;
    PlayerData[targetid][pDiceBet] = amount;
    PlayerData[targetid][pDiceRigged] = 1;
    PlayerData[playerid][pLastBet] = gettime();

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has initiated a dice bet with you for $%i (/accept dicebet).", GetRPName(playerid), amount);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have initiated a dice bet against %s for $%i.", GetRPName(targetid), amount);
    return 1;
}

CMD:dice(playerid, params[])
{
    SendProximityMessage(playerid, 20.0, COLOR_WHITE, "* %s rolls a dice which lands on the number %i.", GetRPName(playerid), random(6) + 1);
    return 1;
}

CMD:flipcoin(playerid, params[])
{
    SendProximityMessage(playerid, 20.0, COLOR_WHITE, "* %s flips a coin which lands on %s.", GetRPName(playerid), (random(2)) ? ("Heads") : ("Tails"));
    return 1;
}
