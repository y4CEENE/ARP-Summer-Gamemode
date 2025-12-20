#include <YSI\y_hooks>

static PlayerRespawnDelay = 120;
static LastPlayerRespawn[MAX_PLAYERS];
static IsPlayerRespawning[MAX_PLAYERS];
static Float:PlayerRespawningX[MAX_PLAYERS];
static Float:PlayerRespawningY[MAX_PLAYERS];
static Float:PlayerRespawningZ[MAX_PLAYERS];

CMD:respawn(playerid, params[]) 
{
    if(gettime() - LastPlayerRespawn[playerid] < PlayerRespawnDelay)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can't respawn for the moment. Please wait %i more seconds.", PlayerRespawnDelay - (gettime() - LastPlayerRespawn[playerid]));
	}
	
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 
       || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0 || IsPlayerInEvent(playerid) || IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to use drugs. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}
    IsPlayerRespawning[playerid] = 30;
    GetPlayerPos(playerid, PlayerRespawningX[playerid], PlayerRespawningY[playerid], PlayerRespawningZ[playerid]);
    SendClientMessageEx(playerid, COLOR_AQUA, "Don't move or respawn will fail (You will lose your weapons!).", IsPlayerRespawning[playerid]);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    LastPlayerRespawn[playerid] = gettime();
    IsPlayerRespawning[playerid] = 0;
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if(IsPlayerRespawning[playerid])
    {
        if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 
           || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0 || PlayerData[playerid][pHurt] > 0 || IsPlayerInEvent(playerid) || IsPlayerInAnyVehicle(playerid))
        {
	        IsPlayerRespawning[playerid] = 0;
            return SendClientMessage(playerid, COLOR_GREY, "Failed to respawn.");
        }
        if(!IsPlayerNearPoint(playerid, 2, PlayerRespawningX[playerid], PlayerRespawningY[playerid], PlayerRespawningZ[playerid]))
        {
	        IsPlayerRespawning[playerid] = 0;
            return SendClientMessage(playerid, COLOR_GREY, "Failed to respawn.");
        }

        IsPlayerRespawning[playerid]--;

        if(IsPlayerRespawning[playerid] == 0)
        {
            TeleportToCoords(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2], NewbSpawnPos[3], 0, 0, false);
		    ResetPlayerWeapons(playerid);
            LastPlayerRespawn[playerid] = gettime();
            GameTextForPlayer(playerid, "Teleported to spawn point", 5000, 1);
            return 1;
        }
        else
        {
            new string[128];
            format(string, sizeof(string), "Respawning in %i seconds", IsPlayerRespawning[playerid]);
            GameTextForPlayer(playerid, string, 1000, 1);
        }
    }
    return 1;
}