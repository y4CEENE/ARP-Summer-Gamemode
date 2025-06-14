#include <YSI\y_hooks>

#define MAX_ALLOWED_PING 500

static PingMeasurment[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    PingMeasurment[playerid] = 0;
}


hook OnPlayerHeartBeat(playerid)
{
	if (GetPlayerPing(playerid) > MAX_ALLOWED_PING)
    {
        PingMeasurment[playerid] ++;

        if(PingMeasurment[playerid] > 30)
        {
		    KickPlayer(playerid, "Having high ping for more than 30sec", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
        }
	}
    else if(PingMeasurment[playerid] > 0)
    {
        PingMeasurment[playerid]--;
    }
}
