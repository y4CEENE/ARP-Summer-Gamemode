#include <YSI\y_hooks>

static KickLocalhostUsers = false;

hook OnGameModeInit()
{
    KickLocalhostUsers = IsProductionServer();
    KickLocalhostUsers = false;
}

hook OnPlayerInit(playerid)
{
	// check whether or not the player is using a proxy
	if(IsVPNCheckEnabled())
	{
		new ip[16], string[59];
		GetPlayerIp(playerid, ip, sizeof ip);
		format(string, sizeof string, "www.shroomery.org/ythan/proxycheck.php?ip=%s", ip);
		HTTP(playerid, HTTP_GET, string, "", "ProxyCheckHttpResponse");
	}
    return 1;
}

 
forward ProxyCheckHttpResponse(playerid, response_code, data[]);
public ProxyCheckHttpResponse(playerid, response_code, data[])
{
	new name[MAX_PLAYERS],string[256];
	new ip[16];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerIp(playerid, ip, sizeof ip);
	if(strcmp(ip, "127.0.0.1", true) == 0 && KickLocalhostUsers)
	{
		format(string, 256, "[LOCALHOST] %s(%d) has joined the server and was kicked.", name, playerid);
        Log("Rex/Anti-Proxy.log", string);
        ABroadCast(0xFF0000FF, string, 2);
        SendClientMessage(playerid, 0x09F7DFC8, "Localhost users cannot login.");
		KickPlayer(playerid, "Localhost users cannot login");
		
        return 1;
	}
	if(response_code == 200)
	{	
		if(data[0] == 'Y')
		{
			format(string, 256, "[PROXY DETECTED] %s(%d) has been kicked from the server.", name, playerid);
            Log("Rex/Anti-Proxy.log", string);
            ABroadCast(0xFF0000FF, string, 2);
	    	SendClientMessage(playerid, 0xFF0000FF, "_________Please disable your proxy/VPN and rejoin!_________");
	    	KickPlayer(playerid, "Disable your proxy/VPN and rejoin!");
            return 1;
		}
		if(data[0] == 'N')
		{
	    	SendClientMessageEx(playerid, COLOR_AQUA, "[PROXY NOT DETECTED] %s(%d) thank you for joining!", name, playerid);
		}
		if(data[0] == 'X')
		{
			format(string, 256, "[ERROR] Wrong ip format '%s' for %s(%d).", ip, name, playerid);
            Log("Rex/Anti-Proxy.log", string);
		}
		else
		{
			format(string, 256, "[ERROR] The request failed! The response code was: %d", response_code);
            Log("Rex/Anti-Proxy.log", string);
		}
	}
	return 1;
}


CMD:disablevpn(playerid, params[])
{
	new status;

	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", status) || !(0 <= status <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /disablevpn [0/1]");
	}

	if(status) {
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disabled joining with VPN.", GetRPName(playerid));
	} else {
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has enabled joining with VPN.", GetRPName(playerid));
	}

	SetVPNState(status);
	return 1;
}
