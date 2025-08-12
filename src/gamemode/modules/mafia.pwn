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
    CreateDynamic3DTextLabel("Type /gmats\nto start farming", COLOR_YELLOW,  1652.592895, -2567.482910, 210.193023, 10.0, .worldid = Mafia_Farming_World, .interiorid = Mafia_Farming_InteriorID);
    CreateDynamicPickup(1575, 1, 1652.592895, -2567.482910, 210.193023, .worldid = Mafia_Farming_World, .interiorid = Mafia_Farming_InteriorID);
    // FOR TEST
    Create3DTextLabel("Checkpoint here", 0xFFFFFFFF, 1663.1552, -2554.1355, 210.193023, 40.0, Mafia_Farming_World, Mafia_Farming_InteriorID);

    return 1;
}

CMD:gmats(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1 || !GangInfo[PlayerData[playerid][pGang]][gIsMafia])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Only mafia can use this command.");
	}
    if (!IsPlayerInRangeOfPoint(playerid, 3.0,  1652.592895, -2567.482910, 210.193023))
    {   
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of materials pickup.");
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

    SetPlayerCheckpoint(playerid, 1663.1552, -2554.1355, 210.2299, 2.5);
    //SetActiveCheckpoint(playerid, MafiaFarmingCheckpoint, 2564.7836, -1292.9316, 1044.1250, 2.0);
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


// Debug command (remove it)
CMD:goo1(playerid)
{
    SetPlayerVirtualWorld(playerid, Mafia_Farming_World);
    SetPlayerInterior(playerid, Mafia_Farming_InteriorID);
    SetPlayerPos(playerid, 1652.592895, -2567.482910, 210.193023);
    return 1;
}

