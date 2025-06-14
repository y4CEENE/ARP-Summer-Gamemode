// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

//Mobile include by Jekmant

native gpci(playerid, buffer[], size = sizeof(buffer));

#define MIN_PACKET_SIZE     3
#define MOBILE_AUTH_KEY     "ED40ED0E8089CC44C08EE9580F4C8C44EE8EE990"
const ID_CUSTOM_SYNC = 221;
const RPC_INIT_MOBILE = 0x10;

enum pMobileInfo
{
    bool:isMobile,
    bool:isHaveAutoaim
}
new PlayerMobileInfo[MAX_PLAYERS][pMobileInfo];

public OnPlayerConnect(playerid)
{
    new gpciStr[64];
	gpci(playerid, gpciStr);
    if(!strcmp(gpciStr, MOBILE_AUTH_KEY)) // system for older version, will be deprecated
		PlayerMobileInfo[playerid][isMobile] = true;
	else
		PlayerMobileInfo[playerid][isMobile] = false;
	return 1;
}
