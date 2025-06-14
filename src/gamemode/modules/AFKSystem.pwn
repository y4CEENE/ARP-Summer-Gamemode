#include <YSI\y_hooks>



static Float:AFKPosition[MAX_PLAYERS][6];
static AFKTime[MAX_PLAYERS];
static PlayerLastUpdate[MAX_PLAYERS];

GetAFKTime(playerid)
{
    return AFKTime[playerid];
}

IsPlayerAFK(playerid)
{
    return AFKTime[playerid] > 0;
}

stock GetPlayerPauseTime(playerid)
{
    new diff = gettime() - PlayerLastUpdate[playerid];

    if(diff < 5)
    {
        return 0;
    }
    return diff;
}

IsPlayerPaused(playerid)
{
    return ((gettime() - PlayerLastUpdate[playerid]) >= 5);
}

hook OnPlayerInit(playerid)
{
	AFKPosition[playerid][0] = 0.0;
	AFKPosition[playerid][1] = 0.0;
	AFKPosition[playerid][2] = 0.0;
	AFKPosition[playerid][3] = 0.0;
	AFKPosition[playerid][4] = 0.0;
	AFKPosition[playerid][5] = 0.0;
	PlayerLastUpdate[playerid] = 0;
    AFKTime[playerid] = 0;
}

hook OnPlayerText(playerid, text[])
{
    AFKTime[playerid] = 0;
    return 1;
}

hook OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    AFKTime[playerid] = 0;
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:cx,
	    Float:cy,
	    Float:cz;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerCameraPos(playerid, cx, cy, cz);

	if(AFKPosition[playerid][0] == x && AFKPosition[playerid][1] == y && AFKPosition[playerid][2] == z && AFKPosition[playerid][3] == cx && AFKPosition[playerid][4] == cy && AFKPosition[playerid][5] == cz)
	{
	    if(AFKTime[playerid] == 60)
	    {
		    SendClientMessageEx(playerid, COLOR_LIGHTORANGE, ">>{FFFFFF} You are now marked as {00AA00}Away from keyboard{FFFFFF} as you haven't moved in one minute.");
		}

		AFKTime[playerid]++;
	}
	else
	{
		if(AFKTime[playerid] >= 60)
		{
		    if(AFKTime[playerid] < 120)
            {
		        SendClientMessageEx(playerid, COLOR_LIGHTORANGE, ">>{FFFFFF} You are no longer marked as {00AA00}Away from keyboard{FFFFFF} after %i seconds.", AFKTime[playerid]);
			} 
            else 
            {
		        SendClientMessageEx(playerid, COLOR_LIGHTORANGE, ">>{FFFFFF} You are no longer marked as {00AA00}Away from keyboard{FFFFFF} after %i minutes.", AFKTime[playerid] / 60);
			}
		}

		AFKTime[playerid] = 0;
	}

	AFKPosition[playerid][0] = x;
	AFKPosition[playerid][1] = y;
	AFKPosition[playerid][2] = z;
	AFKPosition[playerid][3] = cx;
	AFKPosition[playerid][4] = cy;
	AFKPosition[playerid][5] = cz;
    return 1;
}


hook OnPlayerUpdate(playerid)
{
	PlayerLastUpdate[playerid] = gettime();
    return 1;
}
