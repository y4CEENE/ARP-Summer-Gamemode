#include <YSI\y_hooks>

#define Gang_Farming_Base 1
#define Gang_Farming_World 0
#define Gang_Farming_Interior 0

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
    CreateDynamic3DTextLabel("Type /farm\nto start farming drug", COLOR_YELLOW,  1543.883056, 1732.446777, 149.042617, 10.0, .worldid = Gang_Farming_World, .interiorid = Gang_Farming_Interior);
    CreateDynamicPickup(1575, 1, 1543.883056, 1732.446777, 149.042617);

    return 1;
}

CMD:farm(playerid, params[])
{
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(PlayerData[playerid][pCrew] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any crew in your gang.");
	}
    if (!IsPlayerInRangeOfPoint(playerid, 3.0,  1543.883056, 1732.446777, 149.042617))
    {    
		return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the drugs factory.");
	}
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

    SetPlayerCheckpoint(playerid, 1546.171264, 1741.191772, 149.018981, 2.5);
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
            format(drugName, sizeof(drugName), "Cocaine");
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
                "UPDATE users SET cocaine = %i WHERE uid = %i", 
                PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
        }
        case 1: {
            PlayerData[playerid][pHeroin] += earned;
            format(drugName, sizeof(drugName), "Heroin");
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
                "UPDATE users SET heroin = %i WHERE uid = %i", 
                PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
        }
        case 2: {
            PlayerData[playerid][pWeed] += earned;
            format(drugName, sizeof(drugName), "Weed");
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


// Debug command (remove it)
CMD:goo2(playerid)
{
    SetPlayerPos(playerid, 1546.171264, 1741.191772, 149.018981);
    return 1;
}

