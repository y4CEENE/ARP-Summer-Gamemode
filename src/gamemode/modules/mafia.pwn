#include <YSI\y_hooks>

#define Mafia_Farming_World 45
#define Mafia_Farming_InteriorID 2
#define Mafia_Farming_Base 2000

enum {
    MafiaFarmingCheckpoint
};

static IsFarming[MAX_PLAYERS];
static FarmingTimer[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    IsFarming[playerid] = 0;
    FarmingTimer[playerid] = -1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (FarmingTimer[playerid] != -1) {
        KillTimer(FarmingTimer[playerid]);
        FarmingTimer[playerid] = -1;
    }
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Type /gmats\nto start farming", COLOR_YELLOW,  1342.766723, 799.112243, 8732.478515, 10.0);
    CreateDynamic3DTextLabel("Materials Factory\nDeliver the stock.", COLOR_YELLOW, 1367.997924, 796.098571, 8732.478515, 10.0);
    CreateDynamicPickup(1575, 1, 1342.766723, 799.112243, 8732.478515);
    return 1;
}

CMD:gmats(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1 || !GangInfo[PlayerData[playerid][pGang]][gIsMafia])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Only mafia can use this command.");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1342.766723, 799.112243, 8732.478515))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the material factory point!");
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {     
        return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
    }
    if (IsFarming[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are already farming. Wait until you're done.");

    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    GameTextForPlayer(playerid, "~w~Farming ...", 9000, 3);

    IsFarming[playerid] = 1;
    FarmingTimer[playerid] = SetTimerEx("Farming_Timer", 9000, false, "i", playerid);
    return 1;
}

forward Farming_Timer(playerid);
public Farming_Timer(playerid)
{
    FarmingTimer[playerid] = -1;

    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
    SetPlayerAttachedObject(playerid, 9, 3014, 6);

    SetPlayerCheckpoint(playerid, 1367.997924, 796.098571, 8732.478515, 2.5);
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (!IsFarming[playerid]) return 1;

    new earned = Mafia_Farming_Base + (random(4001) + 3000); // 3000-7000 range

    new msg[128];
    format(msg, sizeof(msg), "You earned %d materials (Total: %d)", earned, PlayerData[playerid][pMaterials]);
    SendClientMessage(playerid, COLOR_AQUA, msg);
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
    RemovePlayerAttachedObject(playerid, 9);

    IsFarming[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    return 1;
}

