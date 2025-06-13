/// @file      RobBank.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static BankRobberyCash[MAX_PLAYERS];
static BankRobberyLootTime[MAX_PLAYERS];
static BankRobberyLastLoad[MAX_PLAYERS];

enum robberyEnum
{
    rTime,
    rPlanning,
    rStarted,
    rStolen,
    rRobbers[MAX_BANK_ROBBERS],
    rObjects[2],
    Text3D:rText[5]
};
static RobberyInfo[robberyEnum];

static RobBankRobberyCooldown = 8;
static RobBankLootingCooldown = 5;
static RobBankBaseCash = 500;
static RobBankRandomCash = 500;
static RobBankLootingLimit = 100000;
static RobBankMinimalLevel = 7;

hook OnLoadGameMode(timestamp)
{
    new Node:robbery;
    new Node:robbank;
    if (!GetServerConfig("robbery", robbery) && !JSON_GetObject(robbery, "robbank", robbank))
    {
        JSON_GetInt(robbank, "robbery_cooldown_hours", RobBankRobberyCooldown);
        JSON_GetInt(robbank, "looting_cooldown_seconds", RobBankLootingCooldown);
        JSON_GetInt(robbank, "looting_base_cash", RobBankBaseCash);
        JSON_GetInt(robbank, "looting_random_cash", RobBankRandomCash);
        JSON_GetInt(robbank, "looting_limit", RobBankLootingLimit);
        JSON_GetInt(robbank, "minimal_level", RobBankMinimalLevel);
    }
}

GetBankRobberyCooldown()
{
    return RobBankRobberyCooldown;
}

GetBankRobberyTime()
{
    return RobberyInfo[rTime];
}

GetBankNbRobbers()
{
    new count;
    for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
    {
        if (RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
        {
            count++;
        }
    }
    return count;
}

AddToBankRobbery(playerid)
{
    for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
    {
        if (RobberyInfo[rRobbers][i] == INVALID_PLAYER_ID)
        {
            RobberyInfo[rRobbers][i]  = playerid;
            BankRobberyCash[playerid] = 0;
            return 1;
        }
    }
    return 0;
}

IsPlayerInBankRobbery(playerid)
{
    if (RobberyInfo[rPlanning] || RobberyInfo[rStarted])
    {
        for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
        {
            if (RobberyInfo[rRobbers][i] == playerid)
            {
                return 1;
            }
        }
    }
    return 0;
}

RemoveFromBankRobbery(playerid)
{
    for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
    {
        if (RobberyInfo[rRobbers][i] == playerid)
        {
            RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
        }
    }
    if (!GetBankNbRobbers())
    {
        ResetRobbery();
    }
    else if (RobberyInfo[rPlanning] && RobberyInfo[rRobbers][0] == INVALID_PLAYER_ID)
    {
        for (new i = 1; i < MAX_BANK_ROBBERS; i ++)
        {
            if (RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
            {
                RobberyInfo[rRobbers][0] = RobberyInfo[rRobbers][i];
                RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
                SendClientMessageEx(RobberyInfo[rRobbers][0], COLOR_AQUA, "You are now the leader of this bank heist!");
                break;
            }
        }
    }
    BankRobberyCash[playerid] = 0;
    CancelActiveCheckpoint(playerid);
    RemovePlayerAttachedObject(playerid, 8);
    RemovePlayerAttachedObject(playerid, 9);
    PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
    return 0;
}

ResetRobbery()
{
    if (RobberyInfo[rStarted])
    {
        SendClientMessageToAllEx(COLOR_AQUA, "Breaking News: The bank robbery is now finished. %s was stolen from the bank.", FormatCash(RobberyInfo[rStolen]));
    }
    if (IsValidDynamicObject(RobberyInfo[rObjects][0]))
    {
        DestroyDynamicObject(RobberyInfo[rObjects][0]);
    }
    if (IsValidDynamicObject(RobberyInfo[rObjects][1]))
    {
        DestroyDynamicObject(RobberyInfo[rObjects][1]);
    }

    for (new i = 0; i < 5; i ++)
    {
        DestroyDynamic3DTextLabel(RobberyInfo[rText][i]);
        RobberyInfo[rText][i] = Text3D:INVALID_3DTEXT_ID;
    }

    for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
    {
        RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
    }

    RobberyInfo[rTime] = RobBankRobberyCooldown;
    RobberyInfo[rPlanning] = 0;
    RobberyInfo[rStarted] = 0;
    RobberyInfo[rStolen] = 0;
    RobberyInfo[rObjects][0] = CreateDynamicObject(19799, 1678.248901, -988.194702, 671.695007, 0.000000, 0.000000, 0.000000);
    RobberyInfo[rObjects][1] = INVALID_OBJECT_ID;
}

hook OnPlayerHeartBeat(playerid)
{
    if (BankRobberyLootTime[playerid] <= 0)
    {
        return 1;
    }

    BankRobberyLootTime[playerid]--;

    if (IsPlayerInBankRobbery(playerid) && BankRobberyLootTime[playerid] <= 0)
    {
        new string[24];
        ClearAnimations(playerid, 1);
        new amount = random(RobBankRandomCash) + RobBankBaseCash;
        BankRobberyCash[playerid] += amount;
        BankRobberyLastLoad[playerid] = gettime();

        format(string, sizeof(string), "~g~+$%i", amount);
        GameTextForPlayer(playerid, string, 5000, 1);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have looted {00AA00}$%i{33CCFF} and now have $%i.", amount, BankRobberyCash[playerid]);
        SendClientMessageEx(playerid, COLOR_AQUA, " You can keep looting or deliver the cash to the {FF6347}marker{33CCFF}.");
        SetActiveCheckpoint(playerid, CHECKPOINT_ROBBERY, 1429.9939, 1066.9581, 9.8938, 3.0);
    }
    return 1;
}

CMD:setbanktimer(playerid, params[])
{
    new hours;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", hours))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setbanktimer [hours]");
    }
    if (hours < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Hours can't be below 0.");
    }

    RobberyInfo[rTime] = hours;
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the bank robbery timer to %i hours.", GetRPName(playerid), hours);
    return 1;
}

CMD:resetrobbery(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }

    ResetRobbery();
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the active bank robbery.", GetRPName(playerid));
    return 1;
}

CMD:addtorobbery(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /addtorobbery [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!RobberyInfo[rPlanning] && !RobberyInfo[rStarted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no bank robbery in progress.");
    }
    if (GetBankNbRobbers() >= MAX_BANK_ROBBERS)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "There can't be more than %i bank robbers in this robbery.", MAX_BANK_ROBBERS);
    }
    if (IsPlayerInBankRobbery(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already in the bank robbery.");
    }

    AddToBankRobbery(targetid);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has added %s to the bank robbery.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_AQUA, "%s has added you to the bank robbery.", GetRPName(playerid));
    return 1;
}

CMD:robbank(playerid, params[])
{
    new count;

    if (PlayerData[playerid][pLevel] < RobBankMinimalLevel)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level %d+ to use this command.", RobBankMinimalLevel);
    }
    if (!IsPlayerInRangeOfPoint(playerid, 20.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }
    if (PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be rank 5 in gang to robbank");
    }
    if (RobberyInfo[rTime] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The bank can be robbed again in %i hours. You can't rob it now.", RobberyInfo[rTime]);
    }
    if (RobberyInfo[rPlanning])
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is a bank robbery being planned already. Ask the leader to join.");
    }
    if (RobberyInfo[rStarted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't rob the bank as a robbery has already started.");
    }
    if (IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't rob the bank as a law enforcer. Ask your boss for a raise.");
    }

    foreach(new i : Player)
    {
        if (IsLawEnforcement(i) && !PlayerData[i][pAdminDuty])
        {
            count++;
        }
    }

    if (count < 10)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There needs to be at least 10+ LEO online in order to rob the bank.");
    }

    RobberyInfo[rRobbers][0] = playerid;
    RobberyInfo[rPlanning] = 1;

    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1677.2610, -987.6659, 671.1152, 2.0);


    SendClientMessage(playerid, COLOR_AQUA, "You have setup a {FF6347}bank robbery{33CCFF}. You need to /robinvite at least 2 more people in order to begin the heist.");
    SendClientMessage(playerid, COLOR_AQUA, "After you've found two additional heisters, you can use /bombvault at the checkpoint to blow the vault.");
    return 1;
}

CMD:robinvite(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /robinvite [playerid]");
    }
    if (!(RobberyInfo[rPlanning] && RobberyInfo[rRobbers][0] == playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are currently not planning a bank robbery.");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (IsPlayerInBankRobbery(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already in the robbery with you.");
    }
    if (GetBankNbRobbers() >= MAX_BANK_ROBBERS)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i bank robbers in this robbery.", MAX_BANK_ROBBERS);
    }
    if (IsLawEnforcement(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't invite law enforcement to rob the bank.");
    }

    PlayerData[targetid][pRobberyOffer] = playerid;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has invited you to a bank robbery. (/accept robbery)", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have invited %s to join your bank robbery.", GetRPName(targetid));
    return 1;
}

CMD:bombvault(playerid, params[])
{
    if (RobberyInfo[rPlanning] == 0 && RobberyInfo[rRobbers][0] != playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are currently not planning a bank robbery.");
    }
    if (GetBankNbRobbers() < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need at least two other heisters in your robbery.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1677.2610, -987.6659, 671.1152))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the vault.");
    }
    if (IsValidDynamicObject(RobberyInfo[rObjects][1]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The vault is already being bombed at the moment.");
    }

    RobberyInfo[rObjects][1] = CreateDynamicObject(1654, 1677.787475, -988.009765, 671.625366, 0.000000, 0.000000, 180.680709);

    ShowActionBubble(playerid, "* %s firmly plants an explosive on the vault door.", GetRPName(playerid));
    SendClientMessage(playerid, COLOR_WHITE, "* Bomb planted. Shoot at the bomb to blow that sumbitch' up!");
    return 1;
}

CMD:lootbox(playerid, params[])
{
    if (!IsPlayerInBankRobbery(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in an active bank robbery.");
    }
    if (!RobberyInfo[rStarted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The bank robbery hasn't started yet.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2344, -994.6146, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2335, -998.6115, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2344, -1002.5356, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1674.2708, -998.4954, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1674.2708, -994.5173, 671.0032))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the deposit boxes.");
    }
    if (BankRobberyLootTime[playerid] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already looting a deposit box.");
    }
    if (BankRobberyCash[playerid] >= RobBankLootingLimit)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your pockets can't hold more than $100,000 of money!");
    }
    if (!IsPlayerInBankRobbery(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of this bank robbery.");
    }

    BankRobberyLootTime[playerid] = RobBankLootingCooldown;

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
    GameTextForPlayer(playerid, "~w~Looting deposit box...", 5000, 3);
    return 1;
}

CMD:robbers(playerid, params[])
{
    if (!RobberyInfo[rStarted] && !IsPlayerInBankRobbery(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no bank robbery currently active.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Robbers Alive ______");

    foreach(new i : Player)
    {
        if (IsPlayerInBankRobbery(i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s {00AA00}(%s stolen)", i, GetRPName(i), FormatCash(BankRobberyCash[i]));
        }
    }

    return 1;
}

hook OnPlayerInit(playerid)
{
    BankRobberyCash[playerid] = 0;
}

hook OnPlayerReset(playerid)
{
    if (RobberyInfo[rPlanning] || RobberyInfo[rStarted])
    {
        RemoveFromBankRobbery(playerid);
    }
}

hook OnNewHour(timestamp, hour)
{
    if (RobberyInfo[rTime] > 0)
    {
        RobberyInfo[rTime]--;
    }
}

hook OnPlayerDisconnect(playerid)
{
    if (!RobberyInfo[rPlanning] && !RobberyInfo[rStarted])
    {
        return 1;
    }

    for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
    {
        if (RobberyInfo[rRobbers][i] == playerid)
        {
            RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
        }
    }

    if (!GetBankNbRobbers())
    {
        ResetRobbery();
    }
    else if (RobberyInfo[rPlanning] && RobberyInfo[rRobbers][0] == INVALID_PLAYER_ID)
    {
        for (new i = 1; i < MAX_BANK_ROBBERS; i ++)
        {
            if (RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
            {
                RobberyInfo[rRobbers][0] = RobberyInfo[rRobbers][i];
                RobberyInfo[rRobbers][i] = INVALID_PLAYER_ID;
                SendClientMessageEx(RobberyInfo[rRobbers][0], COLOR_AQUA, "You are now the leader of this bank heist!");
                break;
            }
        }
    }

    BankRobberyCash[playerid] = 0;

    RemovePlayerAttachedObject(playerid, 8);
    RemovePlayerAttachedObject(playerid, 9);
    PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
    CancelActiveCheckpoint(playerid);
    return 1;
}

hook OP_ShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
    if (RobberyInfo[rPlanning] && objectid == RobberyInfo[rObjects][1])
    {
        new bank[32];

        if (GetPlayerVirtualWorld(playerid) == GetStaticEntranceWorld("Mulholland Bank"))
        {
            bank = "Mulholland Bank";
        }
        else if (GetPlayerVirtualWorld(playerid) == GetStaticEntranceWorld("Rodeo Bank"))
        {
            bank = "Rodeo Bank";
        }

        for (new i = 0; i < MAX_BANK_ROBBERS; i ++)
        {
            if (RobberyInfo[rRobbers][i] != INVALID_PLAYER_ID)
            {
                PlayerPlaySound(RobberyInfo[rRobbers][i], 3401, 0.0, 0.0, 0.0);
                GameTextForPlayer(RobberyInfo[rRobbers][i], "~w~Heist started", 5000, 1);
                SetPlayerAttachedObject(RobberyInfo[rRobbers][i], 8, 19801, 2, 0.091000, 0.012000, -0.000000, 0.099999, 87.799957, 179.500015, 1.345999, 1.523000, 1.270001, 0, 0);
                SetPlayerAttachedObject(RobberyInfo[rRobbers][i], 9, 1550, 1, 0.116999, -0.170999, -0.016000, -3.099997, 87.800018, -179.400009, 0.602000, 0.640000, 0.625000, 0, 0);
                ApplyAnimation(RobberyInfo[rRobbers][i], "GOGGLES", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
                PlayerData[RobberyInfo[rRobbers][i]][pWantedLevel] = 6;
                PlayerData[RobberyInfo[rRobbers][i]][pCrimes]++;

                DBQuery("INSERT INTO charges VALUES(null, %i, 'The State', NOW(), 'Bank Robbery')", PlayerData[RobberyInfo[rRobbers][i]][pID]);
                DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = 6, crimes = crimes + 1 WHERE uid = %i", PlayerData[RobberyInfo[rRobbers][i]][pID]);
            }
        }

        foreach(new i : Player)
        {
            if (IsLawEnforcement(i))
            {
                SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: A robbery is occurring at the %s. There are %i confirmed robbers.", bank, GetBankNbRobbers());
            }
        }

        GetDynamicObjectPos(RobberyInfo[rObjects][1], x, y, z);
        MoveDynamicObject(RobberyInfo[rObjects][0], 1678.248901, -988.181152, 670.224853, 5.0, 90.000000, 0.000000, 0.000000);
        DestroyDynamicObject(RobberyInfo[rObjects][1]);

        CreateExplosion(x, y, z, 12, 6.0);
        SendClientMessageToAllEx(COLOR_AQUA, "Breaking News: A bank robbery is currently taking place at the %s!", bank);

        RobberyInfo[rText][0] = CreateDynamic3DTextLabel("/lootbox\nto loot deposit box.", COLOR_YELLOW, 1680.2344, -994.6146, 671.0032, 10.0);
        RobberyInfo[rText][1] = CreateDynamic3DTextLabel("/lootbox\nto loot deposit box.", COLOR_YELLOW, 1680.2335, -998.6115, 671.0032, 10.0);
        RobberyInfo[rText][2] = CreateDynamic3DTextLabel("/lootbox\nto loot deposit box.", COLOR_YELLOW, 1680.2344, -1002.5356, 671.0032, 10.0);
        RobberyInfo[rText][3] = CreateDynamic3DTextLabel("/lootbox\nto loot deposit box.", COLOR_YELLOW, 1674.2708, -998.4954, 671.0032, 10.0);
        RobberyInfo[rText][4] = CreateDynamic3DTextLabel("/lootbox\nto loot deposit box.", COLOR_YELLOW, 1674.2708, -994.5173, 671.0032, 10.0);

        RobberyInfo[rStarted] = 1;
        RobberyInfo[rStolen] = 0;
        RobberyInfo[rPlanning] = 0;
    }
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_ROBBERY)
        return 1;

    if (IsPlayerInBankRobbery(playerid) && BankRobberyCash[playerid] > 0)
    {
        if (gettime() - BankRobberyLastLoad[playerid] < 60 && !IsAdmin(playerid, ADMIN_LVL_3))
        {
            SendClientMessage(playerid, COLOR_GREY, "Robbery failed. You arrived at the checkpoint too fast.");
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] arrived to the bank robbery checkpoint too fast.", GetRPName(playerid), playerid);
        }
        else
        {
            if (PlayerData[playerid][pGang] >= 0)
            {
                GiveGangPoints(PlayerData[playerid][pGang], 50);
            }

            RobberyInfo[rStolen] += BankRobberyCash[playerid];
            GivePlayerCash(playerid, BankRobberyCash[playerid]);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} for successfully completing the bank robbery.", BankRobberyCash[playerid]);
        }

        RemoveFromBankRobbery(playerid);
        GivePlayerRankPointIllegalJob(playerid, 120);
    }
    return 1;
}

Accept:robbery(playerid)
{
    new offeredby = PlayerData[playerid][pRobberyOffer];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invitations to a bank heist.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (RobberyInfo[rRobbers][0] != offeredby || RobberyInfo[rStarted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The robbery invite is no longer available.");
    }
    if (GetBankNbRobbers() >= MAX_BANK_ROBBERS)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "This bank robbery has reached its limit of %i robbers.", MAX_BANK_ROBBERS);
    }
    if (PlayerData[playerid][pLevel] < RobBankMinimalLevel)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level %d+ to rob the bank.", RobBankMinimalLevel);
    }

    AddToBankRobbery(playerid);
    GivePlayerRankPointIllegalJob(offeredby, 500);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's bank robbery invitation.", GetRPName(offeredby));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your bank robbery invitation.", GetRPName(playerid));

    PlayerData[playerid][pRobberyOffer] = INVALID_PLAYER_ID;
    return 1;
}

IsLootingBank(playerid)
{
    return BankRobberyLootTime[playerid] != 0;
}
