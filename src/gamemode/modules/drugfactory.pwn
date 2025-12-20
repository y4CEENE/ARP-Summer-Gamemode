#include <YSI\y_hooks>

#define Gang_Farming_Base 1

static IsFarmingDrug[MAX_PLAYERS];
static DrugTimer[MAX_PLAYERS];
static HasStock[MAX_PLAYERS];
static PlayerDrugGrams[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    IsFarmingDrug[playerid] = 0;
    DrugTimer[playerid] = -1;
    HasStock[playerid] = 0;
    PlayerDrugGrams[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (DrugTimer[playerid] != -1)
    {
        KillTimer(DrugTimer[playerid]);
        DrugTimer[playerid] = -1;
    }
    IsFarmingDrug[playerid] = 0;
    HasStock[playerid] = 0;
    PlayerDrugGrams[playerid] = 0;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (DrugTimer[playerid] != -1)
    {
        KillTimer(DrugTimer[playerid]);
        DrugTimer[playerid] = -1;
    }
    IsFarmingDrug[playerid] = 0;
    HasStock[playerid] = 0;
    PlayerDrugGrams[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    ClearAnimations(playerid);
    return 1;
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, -1080.671508, 1949.646484, 67.815429, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, -1072.696899, 1949.213500, 67.815429, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, -1067.206787, 1949.133300, 67.815429, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
    return 1;
}

CMD:farm(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -1080.671508, 1949.646484, 67.815429) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, -1072.696899, 1949.213500, 67.815429) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, -1067.206787, 1949.133300, 67.815429))
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the drug factory point!");

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");

    if (IsFarmingDrug[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are already farming. Wait until you're done.");

    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    GameTextForPlayer(playerid, "~w~Farming Drug ...", 10000, 3);

    IsFarmingDrug[playerid] = 1;
    DrugTimer[playerid] = SetTimerEx("Drug_Timer", 10000, false, "i", playerid);
    return 1;
}

CMD:loadstock(playerid, params[])
{
    if (PlayerDrugGrams[playerid] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any drug stock to load. Use /farm first.");

    if (HasStock[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You already loaded the stock. Deliver it first.");

    new vehicleid = GetNearbyVehicle(playerid);

    if (vehicleid == INVALID_VEHICLE_ID || !IsPlayerInRangeOfBoot(playerid, vehicleid))
        return SendClientMessage(playerid, COLOR_GREY, "You need to be near a vehicle's trunk.");

    if (GetVehicleModel(vehicleid) != 482) // Burrito
        return SendClientMessage(playerid, COLOR_GREY, "Only gang delivery vehicles can carry stock.");

    if (IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GREY, "Exit the vehicle before loading the stock.");

    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
    GameTextForPlayer(playerid, "~g~Stock Loaded!", 3000, 3);
    PlayerData[playerid][pWantedLevel] = 6;

    HasStock[playerid] = 1;
    IsFarmingDrug[playerid] = 0;

    SetPlayerCheckpoint(playerid, 2456.931396, -1899.660522, 13.546875, 2.5);
    SendClientMessage(playerid, COLOR_AQUA, "You have loaded the stock! Deliver it to the checkpoint.");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(queryBuffer, sizeof(queryBuffer), "HQ: All Units: %s has started a drug stock delivery!", name);
    SendLawEnforcementMessage(COLOR_YELLOW, queryBuffer);
    return 1;
}

forward Drug_Timer(playerid);
public Drug_Timer(playerid)
{
    DrugTimer[playerid] = -1;
    if (!IsFarmingDrug[playerid]) return 1;

    new earned = Gang_Farming_Base + random(3); // 1 to 3 grams
    PlayerDrugGrams[playerid] += earned;

    new msg[128];
    format(msg, sizeof(msg), "~g~Farming complete! You got ~w~%d grams~g~. Total: ~w~%d grams", earned, PlayerDrugGrams[playerid]);
    GameTextForPlayer(playerid, msg, 5000, 3);

    IsFarmingDrug[playerid] = 0;
    ClearAnimations(playerid);

    if (PlayerDrugGrams[playerid] >= 50)
        SendClientMessage(playerid, COLOR_AQUA, "You have reached 50 grams. You can now deliver the stock using /loadstock.");
    else
        SendClientMessage(playerid, COLOR_AQUA, "You can continue farming or deliver the current stock with /loadstock.");

    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (!HasStock[playerid] || PlayerDrugGrams[playerid] <= 0)
        return 1;

    new gangid = PlayerData[playerid][pGang];
    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");

    new totalGrams = PlayerDrugGrams[playerid];
    new drugType = random(3); // 0 = Cocaine, 1 = Heroin, 2 = Weed

    new drugName[16];
    new limit, current, updated;

    switch (drugType)
    {
        case 0:
        {
            format(drugName, sizeof drugName, "Cocaine");
            limit = GetGangStashCapacity(gangid, STASH_CAPACITY_COCAINE);
            current = GangInfo[gangid][gCocaine];
            updated = (current + totalGrams > limit) ? limit : current + totalGrams;
            GangInfo[gangid][gCocaine] = updated;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
                "UPDATE "#TABLE_GANGS" SET cocaine = %i WHERE id = %i", updated, gangid);
        }
        case 1:
        {
            format(drugName, sizeof drugName, "Heroin");
            limit = GetGangStashCapacity(gangid, STASH_CAPACITY_HEROIN);
            current = GangInfo[gangid][gHeroin];
            updated = (current + totalGrams > limit) ? limit : current + totalGrams;
            GangInfo[gangid][gHeroin] = updated;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
                "UPDATE "#TABLE_GANGS" SET heroin = %i WHERE id = %i", updated, gangid);
        }
        case 2:
        {
            format(drugName, sizeof drugName, "Weed");
            limit = GetGangStashCapacity(gangid, STASH_CAPACITY_WEED);
            current = GangInfo[gangid][gWeed];
            updated = (current + totalGrams > limit) ? limit : current + totalGrams;
            GangInfo[gangid][gWeed] = updated;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
                "UPDATE "#TABLE_GANGS" SET weed = %i WHERE id = %i", updated, gangid);
        }
    }

    new msg[128];
    format(msg, sizeof(msg), "You delivered %d grams of %s to your gang's stash!", totalGrams, drugName);
    PlayerData[playerid][pWantedLevel] = 0;
    SendClientMessage(playerid, COLOR_AQUA, msg);

    mysql_tquery(connectionID, queryBuffer);

    PlayerDrugGrams[playerid] = 0;
    HasStock[playerid] = 0;
    IsFarmingDrug[playerid] = 0;

    DisablePlayerCheckpoint(playerid);
    return 1;
}