/// @file      RobAtm.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-19 14:03:20 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

//TODO: save cooldown

static RobAtm[MAX_PLAYERS];
static RobAtmCash[MAX_PLAYERS];
static RobAtmLootTime[MAX_PLAYERS];
static RobAtmLastLoad[MAX_PLAYERS];
static RobAtmCooldown = 5;
static RobAtmBaseCash = 100;
static RobAtmRandomCash = 300;
static RobAtmWantedLevel = 3;
static RobAtmMinimalLevel = 5;
static RobAtmLootingLimit = 2000;

hook OnLoadGameMode(timestamp)
{
    new Node:robbery;
    new Node:robatm;
    if (!GetServerConfig("robbery", robbery) && !JSON_GetObject(robbery, "robatm", robatm))
    {
        JSON_GetInt(robatm, "looting_cooldown", RobAtmCooldown);
        JSON_GetInt(robatm, "looting_base_cash", RobAtmBaseCash);
        JSON_GetInt(robatm, "looting_random_cash", RobAtmRandomCash);
        JSON_GetInt(robatm, "looting_limit", RobAtmLootingLimit);
        JSON_GetInt(robatm, "wanted_level", RobAtmWantedLevel);
        JSON_GetInt(robatm, "minimal_level", RobAtmMinimalLevel);
    }
}

hook OnPlayerInit(playerid)
{
    RobAtm[playerid] = -1;
    RobAtmCash[playerid] = 0;
    RobAtmLootTime[playerid] = 0;
    RobAtmLastLoad[playerid] = 0;
}

IsLootingAtm(playerid)
{
    return RobAtmLootTime[playerid] != 0;
}

hook OnPlayerReset(playerid)
{
    RobAtm[playerid] = -1;
    RobAtmCash[playerid] = 0;
    RobAtmLootTime[playerid] = 0;
    RobAtmLastLoad[playerid] = 0;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_ROBATM)
        return 1;

    if (gettime() - RobAtmLastLoad[playerid] < 60 && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        SendClientMessage(playerid, COLOR_GREY, "Robbery failed. You arrived at the checkpoint too fast.");
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] arrived to the atm robbery checkpoint too fast.", GetRPName(playerid), playerid);
    }

    if (RobAtm[playerid] >= 0 && RobAtmCash[playerid] > 0)
    {
        new string[20];
        GivePlayerCash(playerid, RobAtmCash[playerid]);
        format(string, sizeof(string), "~g~+$%i", RobAtmCash[playerid]);
        GameTextForPlayer(playerid, string, 5000, 1);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} for successfully completing the atm robbery.", RobAtmCash[playerid]);
    }
    RobAtmCash[playerid] = 0;
    RobAtm[playerid] = -1;
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (RobAtmLootTime[playerid] <= 0)
        return 1;

    if ((RobAtmCooldown - RobAtmLootTime[playerid]) % 5 == 0)
    {
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        GameTextForPlayer(playerid, "~w~Looting atm vault...", 5000, 3);
    }

    RobAtmLootTime[playerid]--;

    if ((RobAtm[playerid] >= 0 && RobAtm[playerid] == GetNearbyAtm(playerid)) && RobAtmLootTime[playerid] <= 0)
    {
        new string[24];
        ClearAnimations(playerid, 1);
        new amount = random(RobAtmRandomCash) + RobAtmBaseCash;
        RobAtmCash[playerid] += amount;
        RobAtmLastLoad[playerid] = gettime();
        format(string, sizeof(string), "~g~+$%i", amount);
        GameTextForPlayer(playerid, string, 5000, 1);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have looted {00AA00}$%i{33CCFF} and now have $%i.", amount, RobAtmCash[playerid]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You can keep looting or deliver the cash to the {FF6347}marker{33CCFF} (/stopatmrobbery).");
        SetActiveCheckpoint(playerid, CHECKPOINT_ROBATM, 1429.9939, 1066.9581, 9.8938, 3.0);

        if (RobAtmCash[playerid] < RobAtmLootingLimit)
        {
            RobAtmLootTime[playerid] = RobAtmCooldown;
        }
        else
        {
            callcmd::stopatmrobbery(playerid, "/1");
        }
    }
    return 1;
}

CMD:robatm(playerid, params[])
{
    new atmid;
    if (IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "   Law Enforcement Officials cannot rob the atm.");
    }
    if (PlayerData[playerid][pLevel] < RobAtmMinimalLevel)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be level %d+ to rob an atm.", RobAtmMinimalLevel);
    }
    if (RobAtm[playerid] >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're already robbing an atm.");
    }
    if (!CanPlayerRob(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "   You need to wait %d seconds before you can rob again.", GetRemaingSecondsToRob(playerid));
    }
    if (GetOnlineCopsCount() < 1)
    {
        return SendClientMessage(playerid, COLOR_GRAD2, "You need at least 1 cop in town in order to rob the atm, try again later!");
    }
    if ((atmid = GetNearbyAtm(playerid)) == -1)
    {
        return SendClientMessage(playerid, COLOR_RED, "You are not near an atm!");
    }
    if (RobAtmLootTime[playerid] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already looting an atm.");
    }
    if (RobAtmCash[playerid] >= RobAtmLootingLimit)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Your pockets can't hold more than %s of money!", FormatCash(RobAtmLootingLimit));
    }

    RobAtm[playerid] = atmid;
    RobAtmLootTime[playerid] = RobAtmCooldown;
    GiveWantedLevel(playerid, RobAtmWantedLevel);
    SetRobberyCooldown(playerid);
    GivePlayerRankPointIllegalJob(playerid, 250);
    SendLawEnforcementMessage(COLOR_AQUA, "HQ: All Units APB: {FF0606}An atm is about to get robbed by {f0f0f0}%s{ff0606}!", GetPlayerNameEx(playerid));
    SendClientMessage(playerid, COLOR_AQUA, "You start robbing atm!");
    SendClientMessage(playerid, COLOR_RED, "WARNING: The alarm has been turned on and cops are notified!");
    return 1;
}

CMD:stopatmrobbery(playerid, params[])
{
    return callcmd::stoprobatm(playerid, params);
}

CMD:stoprobatm(playerid, params[])
{
    if (RobAtm[playerid] < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't actively robbing an atm.");
    }
    if (GetNearbyAtm(playerid) != RobAtm[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't near the atm you were robbing.");
    }
    ClearAnimations(playerid, 1);
    RobAtmLootTime[playerid] = 0;
    SendClientMessageEx(playerid, COLOR_AQUA, "You have robbed a total of %s. You need to get this cash immediately to the {FF6347}marker{33CCFF} before the cops catch you!", FormatCash(RobAtmCash[playerid]));
    SetActiveCheckpoint(playerid, CHECKPOINT_ROBATM, 1429.9939, 1066.9581, 9.8938, 3.0);
    return 1;
}
