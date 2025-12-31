#include <YSI\y_hooks>

#define Gang_Farming_Base 1
#define Gang_Farming_World 3
#define Gang_Farming_Interior 3

static IsFarmingDrug[MAX_PLAYERS];
static DrugTimer[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    IsFarmingDrug[playerid] = 0;
    DrugTimer[playerid] = -1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (DrugTimer[playerid] != -1) {
        KillTimer(DrugTimer[playerid]);
        DrugTimer[playerid] = -1;
    }
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, 1351.111694, 784.417907, 8732.478515, 10.0);
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, 1342.971801, 785.036987, 8732.478515, 10.0);
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, 1342.858276, 792.624389, 8732.478515, 10.0);
    CreateDynamic3DTextLabel("Drug Factory\ntype /farm to start farming.", COLOR_YELLOW, 1350.780761, 792.484313, 8732.478515, 10.0);
    CreateDynamic3DTextLabel("Drug Factory\nDeliver the stock.", COLOR_YELLOW, 1333.135253, 780.857604, 8732.478515, 10.0);

    return 1;
}

CMD:farm(playerid, params[])
{
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1351.111694, 784.417907, 8732.478515) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1342.971801, 785.036987, 8732.478515) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1342.858276, 792.624389, 8732.478515) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1350.780761, 792.484313, 8732.478515))
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the drug factory point!");
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {    
		return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
	}
    if (IsFarmingDrug[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are already farming. Wait until you're done.");

    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    GameTextForPlayer(playerid, "~w~Farming Drug ...", 10000, 3);

    IsFarmingDrug[playerid] = 1;
    DrugTimer[playerid] = SetTimerEx("Drug_Timer", 10000, false, "i", playerid);
    return 1;
}

forward Drug_Timer(playerid);
public Drug_Timer(playerid)
{
    DrugTimer[playerid] = -1;

    SetPlayerCheckpoint(playerid, 1333.135253, 780.857604, 8732.478515, 2.5);
    SendClientMessage(playerid, COLOR_AQUA, "Go to the checkpoint to complete your drugs farm.");
    ClearAnimations(playerid);
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (!IsFarmingDrug[playerid]) return 1;

    new earned = Gang_Farming_Base + (random(1) + 1); // Total: 4 to 6
    new drugType = random(1); // 0 = Cocaine, 1 = Heroin, 2 = Weed
    new drugName[16];

    switch (drugType)
    {
        case 0: {
            PlayerData[playerid][pCocaine] += earned;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
                "UPDATE users SET cocaine = %i WHERE uid = %i",
                PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
        }
        case 1: {
            PlayerData[playerid][pHeroin] += earned;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
                "UPDATE users SET heroin = %i WHERE uid = %i",
                PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
        }
        case 2: {
            PlayerData[playerid][pWeed] += earned;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
                "UPDATE users SET weed = %i WHERE uid = %i",
                PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
        }
    }

    new msg[128];
    format(msg, sizeof(msg), "You earned %d grams of %s!", earned, drugName);
    SendClientMessage(playerid, COLOR_AQUA, msg);

    mysql_tquery(connectionID, queryBuffer);

    IsFarmingDrug[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    return 1;
}

