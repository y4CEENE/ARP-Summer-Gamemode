#include <a_samp>

#pragma tabsize 0

main() {}
#define IP_LEN 32
new ips[MAX_PLAYERS][IP_LEN];
#define strcpy(%0,%1,%2) \
    strcat((%0[0] = '\0', %0), %1, %2)
public OnPlayerConnect(playerid) 
{
	new ip[IP_LEN];
	GetPlayerIp(playerid, ip, IP_LEN);

	for(new index = 0;index < IP_LEN;index++)
	{

		if(strcmp(ips[index], ip, true) == 0 && ips[index][0] != 0)
		{
			SendClientMessage(playerid, 0xBD0000FF, "[Rex] You're kicked as you are already connected with another account.");
			
			new elc_str[120], elc_name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, elc_name, sizeof(elc_name));
			format(elc_str,sizeof(elc_str),"[Rex] %s was kicked from the server. Reason: Connecting with multiple accounts [id: %d, ip1: %s, ip2: %s]", elc_name, index, ip, ips[index]);
			printf(elc_str);
			SendClientMessageToAll(0xBD0000FF,elc_str);

			Kick(playerid);
			return 1;
		}
	}

	strcpy(ips[playerid], ip, IP_LEN);
	return 1;
	
}

public OnPlayerDisconnect(playerid, reason) 
{
	ips[playerid][0] = 0;
	return 1;	
}

public OnGameModeInit() 
{
	for(new index = 0;index < IP_LEN;index++)
	{
		strcpy(ips[index], "", IP_LEN);		
	}	
	return 1;
}

