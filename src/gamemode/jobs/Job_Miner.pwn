/// @file      Job_Miner.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static MiningTime[MAX_PLAYERS];
static MiningRock[MAX_PLAYERS];

static OrdinaryStone_BasePrice   = 40;
static OrdinaryStone_RandomPrice = 10;
static QualityStone_BasePrice    = 60;
static QualityStone_RandomPrice  = 10;

static RareRockHoursCoolDown     = 60;
static RareStone_BasePrice       = 100;
static RareStone_RandomPrice     = 10;
static RubyStone_BasePrice       = 125;
static RubyStone_RandomPrice     = 25;
static DiamonStone_BasePrice     = 150;
static DiamonStone_RandomPrice   = 50;
static SapphireStone_BasePrice   = 130;
static SapphireStone_RandomPrice = 30;

static const Float:minerPositions[][] =
{
    {1276.6024, -1252.0608, 13.8471},
    {1264.3618, -1240.3776, 16.0091},
    {1255.6558, -1242.5010, 17.6045},
    {1255.5265, -1251.3208, 13.8461}
};

IsPlayerMining(playerid)
{
    return (MiningTime[playerid] > 0);
}

IsPlayerInMiningArea(playerid)
{
    for (new i = 0; i < sizeof(minerPositions); i ++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 4.0, minerPositions[i][0], minerPositions[i][1], minerPositions[i][2]))
        {
            return 1;
        }
    }

    return 0;
}

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "miner", config))
    {
        JSON_GetInt(config, "rare_rock_hours_cooldown",    RareRockHoursCoolDown);
        JSON_GetInt(config, "ordinary_stone_base_price",   OrdinaryStone_BasePrice);
        JSON_GetInt(config, "ordinary_stone_random_price", OrdinaryStone_RandomPrice);
        JSON_GetInt(config, "quality_stone_base_price",    QualityStone_BasePrice);
        JSON_GetInt(config, "quality_stone_random_price",  QualityStone_RandomPrice);
        JSON_GetInt(config, "rare_stone_base_price",       RareStone_BasePrice);
        JSON_GetInt(config, "rare_stone_random_price",     RareStone_RandomPrice);
        JSON_GetInt(config, "ruby_base_price",             RubyStone_BasePrice);
        JSON_GetInt(config, "ruby_random_price",           RubyStone_RandomPrice);
        JSON_GetInt(config, "diamon_base_price",           DiamonStone_BasePrice);
        JSON_GetInt(config, "diamon_random_price",         DiamonStone_RandomPrice);
        JSON_GetInt(config, "sapphire_base_price",         SapphireStone_BasePrice);
        JSON_GetInt(config, "sapphire_random_price",       SapphireStone_RandomPrice);
    }

    for (new i = 0; i < sizeof(minerPositions); i ++)
    {
        CreateDynamic3DTextLabel("/mine\nto begin mining.", COLOR_GREEN, minerPositions[i][0], minerPositions[i][1], minerPositions[i][2], 25.0);
    }
    return 1;
}

hook OnPlayerInit(playerid)
{
    MiningTime[playerid] = 0;
    MiningRock[playerid] = 0;
    return 1;
}

hook OnPlayerReset(playerid)
{
    if (MiningTime[playerid] > 0)
    {
        ClearAnimations(playerid, 1);
    }
    MiningTime[playerid] = 0;
    MiningRock[playerid] = 0;
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (MiningTime[playerid] > 0)
    {
        MiningTime[playerid]--;

        if (MiningTime[playerid] <= 0)
        {
            if (IsPlayerInMiningArea(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !PlayerData[playerid][pTazedTime] && !PlayerData[playerid][pCuffed])
            {
                new number = random(10) + 1;
                SetPlayerAttachedObject(playerid, 9, 3929, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

                ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
                SetActiveCheckpoint(playerid, CHECKPOINT_MINING, 1278.0778, -1267.9661, 12.5413, 2.0);

                if (1 <= number <= 5)
                {
                    MiningRock[playerid] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "You have dug up an ordinary stone. Drop it off at the marker.");
                }
                else if (number == 6 && !PlayerData[playerid][pRareTime])
                {
                    SendClientMessage(playerid, COLOR_AQUA, "Woah, this looks oddly weird to find in the middle of a city, lets show it to the boss.");
                    MiningRock[playerid] = 3;
                }
                else
                {
                    MiningRock[playerid] = 2;
                    SendClientMessage(playerid, COLOR_AQUA, "You have dug up a quality stone. Drop it off at the marker.");
                }
            }
            else
            {
                RemovePlayerAttachedObject(playerid, 9);
                ClearAnimations(playerid, 1);
            }
        }
    }
    return 1;
}

hook OnPlayerClearCheckpoint(playerid)
{
    MiningTime[playerid] = 0;
    MiningRock[playerid] = 0;
    return 1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_MINING)
        return 1;

    new cost, string[20];

    if (MiningRock[playerid] == 1)
    {
        cost = OrdinaryStone_BasePrice + random(OrdinaryStone_RandomPrice);
    }
    else if (MiningRock[playerid] == 2)
    {
        cost = QualityStone_BasePrice + random(QualityStone_RandomPrice);
    }
    else if (MiningRock[playerid] == 3)
    {
        new rock = random(552);
        switch (rock)
        {
            case 0..250:
            {
                cost = RareStone_BasePrice + random(RareStone_RandomPrice);
                SendClientMessageEx(playerid, COLOR_WHITE, "Bam, a great stone indeed, the fact you can find stuff in this dump makes me wonder whether theres a diamond hidden in there somewhere.");
            }
            case 251..380:
            {
                cost = RubyStone_BasePrice + random(RubyStone_RandomPrice);
                SendClientMessage(playerid, COLOR_WHITE, "Looks like a ruby, awesome. I'll be sending this Mining Enterprises immediately.");
            }
            case 381..400:
            {
                cost = DiamonStone_BasePrice + random(DiamonStone_RandomPrice);
                AwardAchievement(playerid, ACH_Diamond);
                SendClientMessage(playerid, COLOR_WHITE, "BINGO!, It's a freakin' diamond, we're going to be damn rich!");
                SendClientMessage(playerid, COLOR_WHITE, "Boss: You know what? since you found it, you should get to keep it.");
                GivePlayerDiamonds(playerid, 1);
            }
            case 401..552:
            {
                cost = SapphireStone_BasePrice + random(SapphireStone_RandomPrice);
                SendClientMessage(playerid, COLOR_WHITE, "Looks like you've found a sapphire, damn good job. Let's go for that diamond!");
            }
        }
        PlayerData[playerid][pRareTime] = RareRockHoursCoolDown * 60;

        SendClientMessageEx(playerid, COLOR_GREY, "A cooldown for %i minutes (of playtime) has been applied. Until then you can't find anymore rare stones.",
                            RareRockHoursCoolDown);
    }

    if (PlayerData[playerid][pLaborUpgrade] > 0)
    {
        cost += percent(cost, PlayerData[playerid][pLaborUpgrade]);
    }
    cost = cost * 1;
    MiningRock[playerid] = 0;
    AddToPaycheck(playerid, cost);
    GivePlayerRankPointLegalJob(playerid, 20);

    SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} on your paycheck for your mined rock.", cost);
    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);

    format(string, sizeof(string), "~g~+$%i", cost);
    GameTextForPlayer(playerid, string, 5000, 1);

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 9);
    return 1;
}

CMD:mine(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_MINER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Miner.");
    }
    if (MiningTime[playerid] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are mining already. Wait until you are done.");
    }
    if (MiningRock[playerid] > 0 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to drop off your current rock first.");
    }
    if (!IsPlayerInMiningArea(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the mining area.");
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
    }

    GameTextForPlayer(playerid, "~w~Mining...", 6000, 3);
    ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.1, 1, 0, 0, 0, 0, 1);

    CancelActiveCheckpoint(playerid);
    SetPlayerAttachedObject(playerid, 9, 337, 6);

    MiningTime[playerid] = 6;
    return 1;
}
