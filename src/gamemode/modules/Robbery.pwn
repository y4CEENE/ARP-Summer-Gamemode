#include <YSI\y_hooks>

static RobberyCooldown[MAX_PLAYERS];
static RobCooldown = 45 * 60; // 45 minutes
static RobCooldownDecrease = 3 * 60; // 3 minutes
static CurrentCheckpointId[MAX_PLAYERS];

hook OnLoadPlayer(playerid, row)
{
    RobberyCooldown[playerid] = cache_get_field_content_int(row, "robbery_cooldown");
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
    return IsLootingAtm(playerid) ||
           IsLootingHouse(playerid);
           //IsLootingBusiness(playerid) ||
           //IsLootingBank(playerid);
}


CMD:robhelp(playerid, params[])
{
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
    return 1;
}

stock SetActiveCheckpoint(playerid, id, Float:x, Float:y, Float:z, Float:size = 5.0)
{
    if (id == CHECKPOINT_NONE)
    {
        CancelActiveCheckpoint(playerid);
    }
    else
    {
        CurrentCheckpointId[playerid] = id;
        SetPlayerCheckpoint(playerid, x, y, z, size);
        CallRemoteFunction("OnPlayerNewCheckpoint", "ii", playerid, id);
    }
}
