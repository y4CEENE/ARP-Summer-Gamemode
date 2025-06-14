#include <YSI\y_hooks>

#define IP_LEN 32

static MaxConnectionPerIP = 4;
static PlayerIP[MAX_PLAYERS];
static TimedIP_Key[MAX_PLAYERS];
static TimedIP_Value[MAX_PLAYERS];

GetPlayerBinaryIP(playerid)
{
	new ipstr[IP_LEN];
	GetPlayerIp(playerid, ipstr, IP_LEN);   
    return  IPToInt(ipstr);
}

hook OnPlayerInit(playerid) 
{
    new binary_ip = GetPlayerBinaryIP(playerid);
    PlayerIP[playerid] = binary_ip;
    
    if(binary_ip == 0)
    {
        SendAdminWarning(5, "Cannot decode ip for player [%d] '%s' ", playerid, GetPlayerNameEx(playerid));
        return 1;
    }

	new targetidx = -1;
    new available_connections = 0;

    for(new index = 0;index < MAX_PLAYERS;index++)
	{
		if(PlayerIP[index] == binary_ip)
		{
			available_connections++;
		}
		if((TimedIP_Key[index] == binary_ip || TimedIP_Key[index] == 0) && targetidx == -1)
        {
            targetidx = index;
        }
	}

    if(targetidx == -1)
    {
        return 1;
    }

    new now = gettime();
    new diff_time = now - TimedIP_Value[targetidx];
    TimedIP_Key[targetidx] = binary_ip;
    TimedIP_Value[targetidx] = now;


	if(available_connections > MaxConnectionPerIP) 
	{
		return KickPlayer(playerid, "Connecting with multiple accounts");
	}

    if(diff_time < 5)
    {
        return KickPlayer(playerid, "Auto-Connect");
    }

	return 1;
	
}

hook OnServerHeartBeat(timestamp)
{
    for(new index = 0;index < MAX_PLAYERS;index++)
	{
		if(TimedIP_Key[index] > 0 && ((timestamp - TimedIP_Value[index]) > 5))
        {
            TimedIP_Key[index] = 0;
            TimedIP_Value[index] = 0;
        }
	}
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    PlayerIP[playerid] = 0;
	return 1;	
}

hook OnGameModeInit() 
{
	for(new index = 0;index < MAX_PLAYERS;index++)
	{
        PlayerIP[index] = 0;
        TimedIP_Key[index] = 0;
        TimedIP_Value[index] = 0;
	}	
	return 1;
}

GetMaximumConnectionPerIP()
{
    return MaxConnectionPerIP;
}

SetMaximumConnectionPerIP(value)
{
    MaxConnectionPerIP = value;
}
