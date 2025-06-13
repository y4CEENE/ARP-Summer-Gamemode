/// @file      RobBusiness.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-19 14:03:20 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static RobBiz[MAX_PLAYERS];
static RobBizCash[MAX_PLAYERS];
static RobBizLootTime[MAX_PLAYERS];
static RobBizLastLoad[MAX_PLAYERS];
static RobBizCooldown = 5;
static RobBizBaseCash = 100;
static RobBizRandomCash = 300;
static RobBizWantedLevel = 2;
static RobBizMinimalLevel = 3;
static RobBizLootingLimit = 2000;

hook OnLoadGameMode(timestamp)
{
    new Node:robbery;
    new Node:robbiz;
    if (!GetServerConfig("robbery", robbery) && !JSON_GetObject(robbery, "robbiz", robbiz))
    {
        JSON_GetInt(robbiz, "looting_cooldown", RobBizCooldown);
        JSON_GetInt(robbiz, "looting_base_cash", RobBizBaseCash);
        JSON_GetInt(robbiz, "looting_random_cash", RobBizRandomCash);
        JSON_GetInt(robbiz, "looting_limit", RobBizLootingLimit);
        JSON_GetInt(robbiz, "wanted_level", RobBizWantedLevel);
        JSON_GetInt(robbiz, "minimal_level", RobBizMinimalLevel);
    }
}

hook OnPlayerInit(playerid)
{
    RobBiz[playerid] = -1;
    RobBizCash[playerid] = 0;
    RobBizLootTime[playerid] = 0;
    RobBizLastLoad[playerid] = 0;
}

IsLootingBusiness(playerid)
{
    return RobBizLootTime[playerid] != 0;
}

hook OnPlayerReset(playerid)
{
    RobBiz[playerid] = -1;
    RobBizCash[playerid] = 0;
    RobBizLootTime[playerid] = 0;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_ROBBIZ)
        return 1;

    if (gettime() - RobBizLastLoad[playerid] < 60 && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        SendClientMessage(playerid, COLOR_GREY, "Robbery failed. You arrived at the checkpoint too fast.");
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] arrived to the business robbery checkpoint too fast.", GetRPName(playerid), playerid);
    }

    if (RobBiz[playerid] >= 0 && RobBizCash[playerid] > 0)//it's biz robbery
    {
        new string[20];
        GivePlayerCash(playerid, RobBizCash[playerid]);
        format(string, sizeof(string), "~g~+$%i", RobBizCash[playerid]);
        GameTextForPlayer(playerid, string, 5000, 1);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} for successfully completing the business robbery.", RobBizCash[playerid]);

        switch(BusinessInfo[RobBiz[playerid]][bType])
        {
            case BUSINESS_GUNSHOP:
            {
                //ammunation
                new gun = 0;
                new prob = random(20);
                if(prob < 1)
                {
                    gun = 24; // deagle
                }
                else if(prob < 3)
                {
                    gun = 27; // Combat Shotgun
                }
                else if(prob <5)
                {
                    gun=25; // shotgun
                }
                else if(prob < 8)
                {
                    gun=22; // 9mm
                }

                if (gun != 0)
                {
                    GivePlayerWeaponEx(playerid, gun);
                    SendClientMessageEx(playerid, COLOR_AQUA, "Rob perk: You robbed a %s from gun shop!", GetWeaponNameEx(gun));
                }
            }
            case BUSINESS_RESTAURANT, BUSINESS_BARCLUB:
            {
                if(random(2) == 0)
                {
                    SetPlayerHealth(playerid, 150);
                    SendClientMessageEx(playerid, COLOR_AQUA, "Rob perk: You got full hp!");
                }
            }
            case BUSINESS_GYM:
            {
                new prob = random(6);
                if (prob < 1)
                {
                    SetScriptArmour(playerid, 100);
                    SendClientMessageEx(playerid, COLOR_AQUA, "Rob perk: You got a large vest!");
                }
                else if (prob < 3)
                {
                    SetScriptArmour(playerid, 75);
                    SendClientMessageEx(playerid, COLOR_AQUA, "Rob perk: You got a medium vest!");
                }
            }
            case BUSINESS_TOOLSHOP:
            {
                new gun = 0;
                new prob = random(6);
                if (prob < 1)
                {
                    gun = 1; // Brass knuckles
                }
                else if (prob < 3)
                {
                    gun = 5; // Baseball bat
                }

                if (gun != 0)
                {
                    GivePlayerWeaponEx(playerid, gun);
                    SendClientMessageEx(playerid, COLOR_AQUA, "Rob perk: You robbed a %s from tool shop!", GetWeaponNameEx(gun));
                }
            }
        }
    }
    RobBizCash[playerid] = 0;
    RobBiz[playerid] = -1;
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (RobBizLootTime[playerid] <= 0)
        return 1;

    if ((RobBizCooldown - RobBizLootTime[playerid]) % 5 == 0)
    {
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        GameTextForPlayer(playerid, "~w~Looting atm vault...", 5000, 3);
    }

    RobBizLootTime[playerid]--;

    if ((RobBiz[playerid] >= 0 && RobBiz[playerid] == GetInsideBusiness(playerid)) && RobBizLootTime[playerid] <= 0)
    {
        new string[24];
        ClearAnimations(playerid, 1);
        new amount = random(RobBizRandomCash) + RobBizBaseCash;
        RobBizCash[playerid] += amount;
        RobBizLastLoad[playerid] = gettime();
        format(string, sizeof(string), "~g~+$%i", amount);
        GameTextForPlayer(playerid, string, 5000, 1);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have looted {00AA00}$%i{33CCFF} and now have $%i.", amount, RobBizCash[playerid]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You can keep looting or deliver the cash to the {FF6347}marker{33CCFF} (/stopbizrobbery).");
        SetActiveCheckpoint(playerid, CHECKPOINT_ROBBIZ, 1429.9939, 1066.9581, 9.8938, 3.0);
        if (RobBizCash[playerid] < RobBizLootingLimit)
        {
            RobBizLootTime[playerid] = RobBizCooldown;
        }
        else
        {
            callcmd::stopbizrobbery(playerid, "/1");
        }
    }
    return 1;
}

CMD:robbiz(playerid, params[])
{
    new bizid;
    if (IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Law Enforcement Officials cannot rob the business.");
    }
    if (PlayerData[playerid][pLevel] < RobBizMinimalLevel)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be level %d+ to rob a business.", RobBizMinimalLevel);
    }
    if (RobBiz[playerid] >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're already robbing a business.");
    }
    if (!CanPlayerRob(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %d seconds before you can rob again.", GetRemaingSecondsToRob(playerid));
    }
    if (GetOnlineCopsCount() < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need at least 1 cop in town in order to rob the business, try again later!");
    }
    if ((bizid = GetInsideBusiness(playerid)) == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't inside a business that you can rob.");
    }
    if (IsBusinessOwner(playerid, bizid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't rob your business.");
    }
    if (RobBizLootTime[playerid] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already looting a business.");
    }
    if (RobBizCash[playerid] >= RobBizLootingLimit)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Your pockets can't hold more than %s of money!", FormatCash(RobBizLootingLimit));
    }

    RobBiz[playerid] = bizid;
    RobBizLootTime[playerid] = RobBizCooldown;
    GiveWantedLevel(playerid, RobBizWantedLevel);
    SetRobberyCooldown(playerid);
    GivePlayerRankPointIllegalJob(playerid, 250);
    SendLawEnforcementMessage(COLOR_AQUA, "HQ: All Units APB: {FF0606}A business is about to get robbed by {f0f0f0}%s{ff0606}!",GetPlayerNameEx(playerid));
    SendClientMessageEx(playerid, COLOR_GREY, "You start robbing %s!", GetBusinessTypeStr(BusinessInfo[bizid][bType]));
    SendClientMessage(playerid, COLOR_RED, "WARNING: The alarm has been turned on and cops are notified!");
    return 1;
}

CMD:stopbizrobbery(playerid, params[])
{
    return callcmd::stoprobbiz(playerid, params);
}

CMD:stoprobbiz(playerid, params[])
{
    if (RobBiz[playerid] < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't actively robbing a business.");
    }
    if (GetInsideBusiness(playerid) != RobBiz[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't inside the business you were robbing.");
    }
    ClearAnimations(playerid, 1);
    RobBizLootTime[playerid] = 0;
    SendClientMessageEx(playerid, COLOR_AQUA, "You have robbed a total of %s. You need to get this cash immediately to the {FF6347}marker{33CCFF} before the cops catch you!", FormatCash(RobBizCash[playerid]));
    SetActiveCheckpoint(playerid, CHECKPOINT_ROBBIZ, 1429.9939, 1066.9581, 9.8938, 3.0);
    return 1;
}
