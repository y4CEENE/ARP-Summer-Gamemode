#include <YSI\y_hooks>


static PlayerLastFire[MAX_PLAYERS];
static PlayerFastFireWarnings[MAX_PLAYERS];
static AntiHackMinimumFireDelay = 25;

hook OnPlayerInit(playerid)
{
    PlayerLastFire[playerid] = 0;
    PlayerFastFireWarnings[playerid] = 0;
    return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{

	if((22 <= weaponid <= 27) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    new time = NetStats_GetConnectedTime(playerid);
        new delay = (time - PlayerLastFire[playerid]);

	    if(delay < AntiHackMinimumFireDelay)
	    {
	        PlayerFastFireWarnings[playerid]++;

            Log("Rex/Anti-RapidFire.log", "Player: %s, Ping: %d, Suspect of: RapidFire warning %d/5, Delay: %s", GetPlayerNameEx(playerid), GetPlayerPing(playerid), PlayerFastFireWarnings[playerid], delay);

	        if(PlayerFastFireWarnings[playerid] >= 5)
	        {
             	//BanPlayer(playerid, "Rapid fire");
				PlayerFastFireWarnings[playerid]=0;
				TogglePlayerControllableEx(playerid, 0);
				SetTimerEx("UnfreezeNewbie", 5000, false, "i", playerid);
				SendClientMessage(playerid, COLOR_RED, "[Rex] You were freezed suspect of RapidFire.");
	        }
	    }

	    PlayerLastFire[playerid] = time;
	}
    return 1;
}

GetMinimumFireDelay()
{
    return AntiHackMinimumFireDelay;
}

SetMinimumFireDelay(value)
{
    AntiHackMinimumFireDelay = value;
}