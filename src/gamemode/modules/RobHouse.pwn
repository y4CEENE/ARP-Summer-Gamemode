#include <YSI\y_hooks>

static RobHouse[MAX_PLAYERS];
static RobHouseCash[MAX_PLAYERS];
static RobHouseLootTime[MAX_PLAYERS];
static RobHouseLastLoad[MAX_PLAYERS];
static RobHouseLastRobbery[MAX_PLAYERS]; // <-- timestamp of last robbery

static RobHouseCooldown = 5;      // cooldown between loot ticks
static RobHouseBaseCash = 100;
static RobHouseRandomCash = 300;
static RobHouseWantedLevel = 2;
static RobHouseMinimalLevel = 3;
static RobHouseLootingLimit = 2000;
static RobHouseGlobalCooldown = 60 * 5; // 5 minutes between house robberies

hook OnPlayerInit(playerid)
{
    RobHouse[playerid] = -1;
    RobHouseCash[playerid] = 0;
    RobHouseLootTime[playerid] = 0;
    RobHouseLastLoad[playerid] = 0;
    RobHouseLastRobbery[playerid] = 0; 
}

IsLootingHouse(playerid)
{
    return RobHouseLootTime[playerid] != 0;
}

hook OnPlayerReset(playerid)
{
    RobHouse[playerid] = -1;
    RobHouseCash[playerid] = 0;
    RobHouseLootTime[playerid] = 0;
    RobHouseLastLoad[playerid] = 0;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (RobHouse[playerid] < 0) return 1;
    if (RobHouseCash[playerid] <= 0) return 1;

    if (gettime() - RobHouseLastLoad[playerid] < 60 && !IsAdmin(playerid, JUNIOR_ADMIN))
    {
        SendClientMessage(playerid, COLOR_GREY, "Robbery failed. You arrived at the checkpoint too fast.");
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] arrived to the house robbery checkpoint too fast.", GetRPName(playerid), playerid);
        return 1;
    }

    new string[64];
    GivePlayerCash(playerid, RobHouseCash[playerid]);
    format(string, sizeof(string), "~g~+$%i", RobHouseCash[playerid]);
    GameTextForPlayer(playerid, string, 5000, 1);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} for successfully completing the house robbery.", RobHouseCash[playerid]);

    RobHouseCash[playerid] = 0;
    RobHouse[playerid] = -1;
    DisablePlayerCheckpoint(playerid);
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (RobHouseLootTime[playerid] <= 0) return 1;

    if ((RobHouseCooldown - RobHouseLootTime[playerid]) % 5 == 0)
    {
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
        GameTextForPlayer(playerid, "~w~Looting house...", 5000, 3);
    }

    RobHouseLootTime[playerid]--;

    if ((RobHouse[playerid] >= 0 && RobHouse[playerid] == GetInsideHouse(playerid)) && RobHouseLootTime[playerid] <= 0)
    {
        new string[24];
        ClearAnimations(playerid, 1);
        new amount = random(RobHouseRandomCash) + RobHouseBaseCash;
        RobHouseCash[playerid] += amount;
        RobHouseLastLoad[playerid] = gettime();
        format(string, sizeof(string), "~g~+$%i", amount);
        GameTextForPlayer(playerid, string, 5000, 1);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have looted {00AA00}$%i{33CCFF} and now have $%i.", amount, RobHouseCash[playerid]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You can keep looting or deliver the cash to the {FF6347}marker{33CCFF} (/stophouserobbery).");
        SetActiveCheckpoint(playerid, CHECKPOINT_ROBHOUSE, 1429.9939, 1066.9581, 9.8938, 3.0);

        if (RobHouseCash[playerid] < RobHouseLootingLimit)
        {
            RobHouseLootTime[playerid] = RobHouseCooldown;
        }
        else
        {
            callcmd::stophouserobbery(playerid, "/1");
        }
    }
    return 1;
}

// --- Commands ---
CMD:robhouse(playerid, params[])
{
    new houseid;

    if (IsLawEnforcement(playerid))
        return SendClientMessage(playerid, COLOR_GREY, "Law Enforcement Officials cannot rob the house.");

    if (PlayerData[playerid][pLevel] < RobHouseMinimalLevel)
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be level %d+ to rob a house.", RobHouseMinimalLevel);

    if (RobHouse[playerid] >= 0)
        return SendClientMessage(playerid, COLOR_GREY, "You're already robbing a house.");

    if (gettime() - RobHouseLastRobbery[playerid] < RobHouseGlobalCooldown)
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %d seconds before robbing another house.", RobHouseGlobalCooldown - (gettime() - RobHouseLastRobbery[playerid]));

    if ((houseid = GetInsideHouse(playerid)) == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You aren't inside a house that you can rob.");

    if (RobHouseLootTime[playerid] > 0)
        return SendClientMessage(playerid, COLOR_GREY, "You are already looting a house.");

    if (RobHouseCash[playerid] >= RobHouseLootingLimit)
        return SendClientMessageEx(playerid, COLOR_GREY, "Your pockets can't hold more than %s of money!", FormatCash(RobHouseLootingLimit));

    RobHouse[playerid] = houseid;
    RobHouseLootTime[playerid] = RobHouseCooldown;
    RobHouseLastRobbery[playerid] = gettime(); 
    GiveWantedLevel(playerid, RobHouseWantedLevel);
    GivePlayerRankPointIllegalJob(playerid, 250);
    SendLawEnforcementMessage(COLOR_AQUA, "HQ: All Units APB: {FF0606}A house is about to get robbed by {f0f0f0}%s{ff0606}!", GetPlayerNameEx(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "You start robbing this house!");
    SendClientMessage(playerid, COLOR_RED, "WARNING: The alarm has been turned on and cops are notified!");
    return 1;
}

CMD:stophouserobbery(playerid, params[])
{
    return callcmd::stoprobhouse(playerid, params);
}

CMD:stoprobhouse(playerid, params[])
{
    if (RobHouse[playerid] < 0)
        return SendClientMessage(playerid, COLOR_GREY, "You aren't actively robbing a house.");

    if (GetInsideHouse(playerid) != RobHouse[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You aren't inside the house you were robbing.");

    ClearAnimations(playerid, 1);
    RobHouseLootTime[playerid] = 0;
    SendClientMessageEx(playerid, COLOR_AQUA, "You have robbed a total of %s. You need to get this cash immediately to the {FF6347}marker{33CCFF} before the cops catch you!", FormatCash(RobHouseCash[playerid]));
    SetActiveCheckpoint(playerid, CHECKPOINT_ROBHOUSE, 1429.9939, 1066.9581, 9.8938, 3.0);
    return 1;
}
