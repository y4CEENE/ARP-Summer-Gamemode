/// @file      Job_Hooker.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static STDProbability[][] = {
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3},
    {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3}
};

static STDName[][14]={
    "no STI",
    "a Chlamydia",
    "a Gonorrhea",
    "a Syphilis"
};

static SexOffer[MAX_PLAYERS];
static SexPrice[MAX_PLAYERS];
static SexLastTime[MAX_PLAYERS];
static STD[MAX_PLAYERS];
static STDTimerId[MAX_PLAYERS];

static SexReloadTime = 300;
static MaxSexPrice   = 10000;

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "hooker", config))
    {
        JSON_GetInt(config, "sex_reload_time", SexReloadTime);
        JSON_GetInt(config, "max_sex_price",   MaxSexPrice);
    }
}

hook OnPlayerInit(playerid)
{
    SexOffer[playerid] = -1;
    SexPrice[playerid] = 0;
    SexLastTime[playerid] = 0;
    STD[playerid] = 0;
    STDTimerId[playerid]=0;
    return 1;
}

STDChance(hookerid, clientid)
{
    new idx = random(21);
    new lvl = GetJobLevel(hookerid, JOB_HOOKER);

    if (lvl < 5)
    {
        STD[hookerid] = STDProbability[lvl - 1][idx];
    }

    if (STD[hookerid] != 0)
    {
        STD[clientid] = STD[hookerid];
    }

    return STD[hookerid];
}

OnAcceptSex(playerid)
{
    new offeredby=SexOffer[playerid];
    SexOffer[playerid]=-1;

    if (offeredby == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "No one offered you sex.");
    }

    if (SexPrice[playerid] > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash!");
    }

    if (!PlayersCanHaveSex(playerid, offeredby))
        return 1;


    GivePlayerCash(offeredby, SexPrice[playerid]);
    GivePlayerCash(playerid, -SexPrice[playerid]);

    if (PlayerData[playerid][pCondom] > 0)
    {
        PlayerData[playerid][pCondom]--;
        DBQuery("UPDATE "#TABLE_USERS" SET condom = %i WHERE uid = %i", PlayerData[playerid][pCondom], PlayerData[playerid][pID]);

        STD[offeredby] = 0;
        STD[playerid] = 0;
        SendClientMessage(offeredby, COLOR_DOCTOR, "* The player used a Condom.");
        SendClientMessage(playerid, COLOR_DOCTOR, "* You used a Condom.");
    }
    else
    {
        STDChance(offeredby, playerid);
    }

    new Float:health;
    GetPlayerHealth(playerid, health);
    health += 10 * GetJobLevel(offeredby, JOB_HOOKER);
    if (health > 150)
        health = 150;
    SetPlayerHealth(playerid, health);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You got %d Health + %s while having Sex.", 10 * GetJobLevel(offeredby, JOB_HOOKER), STDName[STD[playerid]]);
    if (STD[playerid] == 0)
        SendClientMessageEx(offeredby, COLOR_GREEN, "* You haven't got a STI while having Sex.");
    else SendClientMessageEx(offeredby, COLOR_RED, "* You got %s because of the Sex.", STDName[STD[playerid]]);

    IncreaseJobSkill(offeredby, JOB_HOOKER);
    SendNearbyMessage(playerid, 15.0, COLOR_AQUA, "%s and %s are having sex.",GetRPName(playerid),GetRPName(offeredby));
    SendClientMessageEx(playerid, COLOR_AQUA, "* %s had sex with you. And you have earned $%d.", GetRPName(offeredby), SexPrice[playerid]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* You had sex with Hooker %s, for $%d.", GetRPName(playerid), SexPrice[playerid]);

    GiveNotoriety(playerid, 5);
    GiveNotoriety(offeredby, 5);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for prostitution, you now have %d.", PlayerData[playerid][pNotoriety]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 5 notoriety for prostitution, you now have %d.", PlayerData[offeredby][pNotoriety]);

    STDTimerId[offeredby] = SetTimerEx("STDTimer", 1000, true, "i", offeredby);
    STDTimerId[playerid] = SetTimerEx("STDTimer", 1000, true, "i", playerid);
    AwardAchievement(offeredby, ACH_YouAreAHooker);

    return 1;
}

publish STDTimer(playerid)
{

    new Float:health;
    GetPlayerHealth(playerid, health);
    SetPlayerHealth(playerid, health - STD[playerid]);
    if (health - STD[playerid] <= 0)
    {
        STD[playerid] = 0;
        KillTimer(STDTimerId[playerid]);//Disable timer
    }
}

PlayersCanHaveSex(playerid, targetid)
{
    if (!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        return 0;
    }
    if (targetid == playerid)
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
        return 0;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid,x, y, z);
    if (!IsPlayerInRangeOfPoint(targetid,5,x,y,z))
    {
        SendClientMessage(playerid,-1,"This isn't near you.");
        return 0;
    }

    if (!IsPlayerInAnyVehicle(playerid) || !IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
    {
        SendClientMessage(playerid, COLOR_GREY, "   You or the other player must be in a Car together!");
        return 0;
    }

    return 1;
}

CMD:sex(playerid, params[])
{

    if (!PlayerHasJob(playerid, JOB_HOOKER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Hooker.");
    }
    if (!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "   You can only have Sex in a Car!");
        return 1;
    }

    new targetid, money;

    if (sscanf(params, "ud", targetid, money))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sex [playerid] [price]");
    }
    if (money < 1 || money > MaxSexPrice)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "   Price not lower then $1 or above %s!", FormatCash(MaxSexPrice));
        return 1;
    }

    if (!PlayersCanHaveSex(playerid, targetid))
        return 1;


/*  PlayerData[targetid][pSexOffer] = playerid;
    SendClientMessageEx(targetid, COLOR_AQUA, "%s offered you to have sex. /accept sex to have sex with him/her.",GetRPName(playerid));
    return SendClientMessageEx(playerid, COLOR_AQUA, "You offered %s to have sex.",GetRPName(targetid));
*/

    if (gettime() - SexLastTime[playerid] < SexReloadTime)
    {
        SendClientMessage(playerid, COLOR_GREY, " You have already had sex, wait for your reload time to finish!");
        return 1;
    }

    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You Offered %s to have Sex with you, for $%d.", GetPlayerNameEx(targetid), money);
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* Hooker %s has Offered you to have Sex with them, for $%d (type /accept sex) to accept.", GetPlayerNameEx(playerid), money);
    SexOffer[targetid] = playerid;
    SexPrice[targetid] = money;
    SexLastTime[playerid] = gettime();
    return 1;
}

CMD:healme(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 2.0, -2299.6079, 123.6063, -5.3468))
    {
        if (STD[playerid] != 0)
        {
            STD[playerid] = 0;
            GivePlayerCash(playerid, -100);
            SendClientMessage(playerid, COLOR_DOCTOR, "* You're no longer infected with a STD anymore because of the Hospital's help!");
            SendClientMessage(playerid, COLOR_DOCTOR, "Doc: Your medical bill contained $100. Have a nice day!");
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "   You don't have a STD to heal!");
            return 1;
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "   You're not at a Hospital!");
    }
    return 1;
}
