/// @file      Robbery.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static RobberyCooldown[MAX_PLAYERS];
static RobCooldown = 45 * 60; // 45 minutes
static RobCooldownDecrease = 3 * 60; // 3 minutes
//When player died lost cash

hook OnLoadGameMode(timestamp)
{
    new Node:robbery;
    if (!GetServerConfig("robbery", robbery))
    {
        JSON_GetInt(robbery, "cooldown_seconds", RobCooldown);
        JSON_GetInt(robbery, "cooldown_decrease_seconds", RobCooldownDecrease);
    }
}

hook OnLoadPlayer(playerid, row)
{
    RobberyCooldown[playerid] = GetDBIntField(row, "robbery_cooldown");
}

hook OnPlayerHeartBeat(playerid)
{
    if (RobberyCooldown[playerid] > 0)
        RobberyCooldown[playerid]--;
}

SetRobberyCooldown(playerid)
{
    new cooldown = RobCooldown;
    if(PlayerData[playerid][pLevel] > 3)  { cooldown -= RobCooldownDecrease; }
    if(PlayerData[playerid][pLevel] > 6)  { cooldown -= RobCooldownDecrease; }
    if(PlayerData[playerid][pLevel] > 9)  { cooldown -= RobCooldownDecrease; }
    if(PlayerData[playerid][pLevel] > 12) { cooldown -= RobCooldownDecrease; }
    if(PlayerData[playerid][pLevel] > 15) { cooldown -= RobCooldownDecrease; }
    RobberyCooldown[playerid] = cooldown;
}

CanPlayerRob(playerid)
{
    return RobberyCooldown[playerid] == 0;
}

GetRemaingSecondsToRob(playerid)
{
    return RobberyCooldown[playerid];
}

IsPlayerLootingInRobbery(playerid)
{
    return //IsLootingAtm(playerid) ||
           //IsLootingHouse(playerid) ||
           //IsLootingBusiness(playerid) ||
           IsLootingBank(playerid);
}


CMD:robhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN, "You can rob house, atm and business every %d minutes and bank every %d hours.", RobCooldown / 60, GetBankRobberyCooldown());
    SendClientMessage(playerid, COLOR_GREEN, "CMDS:");
    SendClientMessage(playerid, COLOR_GREEN, "  /robbank,  /robinvite, /bombvault, /lootbox, /robbers");
    SendClientMessage(playerid, COLOR_GREEN, "  /robhouse, /stoprobhouse");
    SendClientMessage(playerid, COLOR_GREEN, "  /robatm,   /stoprobatm");
    SendClientMessage(playerid, COLOR_GREEN, "  /robbiz,   /stoprobbiz");
    new robTimeout = GetRemaingSecondsToRob(playerid);
    if (robTimeout > 0)
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "You need to wait %s seconds to rob a house, a business or an atm.", robTimeout);
    }
    new bankTimeout = GetBankRobberyTime();
    if (bankTimeout > 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "The bank can be robbed again in %i hours.", bankTimeout);
    }
    return 1;
}
