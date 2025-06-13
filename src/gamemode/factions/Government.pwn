/// @file      Government.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


/*CMD:settax(playerid, params[])
{
    new amount;

    if (GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of government.");
    }
    if (PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1);
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settax [rate]");
    }
    if (!(10 <= amount <= 50))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The tax percentage must range from 10 to 50.");
    }

    SetTaxPercent(amount);

    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s has adjusted the income tax rate to %i percent.", GetRPName(playerid), amount);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the income tax rate to %i percent.", amount);
    DBLog("log_faction", "%s (uid: %i) set the income tax rate to %i percent.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
    return 1;
}
*/
/*CMD:taxwithdraw(playerid, params[])
{
    new amount, reason[64];

    if (GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of government.");
    }
    if (PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1);
    }
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }
    if (sscanf(params, "is[64]", amount, reason))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /taxwithdraw [amount] [reason] ($%i available)", GetTaxVault());
    }
    if (amount < 1 || amount > GetTaxVault())
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }

    AddToTaxVault(-amount);
    GivePlayerCash(playerid, amount);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %s from the tax vault. The new balance is %s.", FormatCash(amount), FormatCash(GetTaxVault()));
    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s has withdrawn %s from the tax vault, reason: %s", GetRPName(playerid), FormatCash(amount), reason);
    DBLog("log_faction", "%s (uid: %i) has withdrawn $%i from the tax vault, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, reason);
    return 1;
}
*/
/*
CMD:taxdeposit(playerid, params[])
{
    new amount;

    if (GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of government.");
    }
    if (PlayerData[playerid][pFactionRank] < FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerData[playerid][pFaction]][fRankCount] - 1);
    }
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /taxdeposit [amount] ($%i available)", GetTaxVault());
    }
    if (amount < 1 || amount > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }

    AddToTaxVault(amount);
    GivePlayerCash(playerid, -amount);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited $%i in the tax vault. The new balance is $%i.", amount, GetTaxVault());
    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s has deposited $%i in the tax vault.", GetRPName(playerid), amount);
    DBLog("log_faction", "%s (uid: %i) has deposited $%i in the tax vault.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
    return 1;
}
*/