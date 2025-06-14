//Made by lokii.

//credits to adri1 for his text draw editor, pottus - for optimising the script and gammix for helping with text draw.

#include <a_samp> //credits to sa-mp team

#define         PING_LEVEL_UPDATE   -1
#define         PING_LEVEL_1        0
#define         PING_LEVEL_2        1
#define         PING_LEVEL_3        2
#define         PING_LEVEL_4        3
#define         PING_LEVEL_5        4

static PingLevel[MAX_PLAYERS] = { -1, ...};

static Text:WifiBox;
static Text:Bar1;
static Text:Bar2;
static Text:Bar3;
static Text:Bar4;
static Text:Bar5;
static timer;

static PingLevelColors[][5] = {
	{ 0x3692EDFF, 0x3692EDFF, 0x3692EDFF, 0x3692EDFF, 0x3692EDFF  },
	{ 0x00DD00FF, 0x00DD00FF, 0x00DD00FF, 0x00DD00FF, 0xC0C0C0FF  },
	{ 0xFDEB11FF, 0xFDEB11FF, 0xFDEB11FF, 0xC0C0C0FF , 0xC0C0C0FF   },
	{ 0xFF5959FF, 0xFF5959FF, 0xC0C0C0FF , 0xC0C0C0FF , 0xC0C0C0FF   },
	{ 0xFF0000FF, 0xC0C0C0FF , 0xC0C0C0FF , 0xC0C0C0FF , 0xC0C0C0FF   }
};

public OnFilterScriptInit()
{
	timer = SetTimer("WifiCheck", 1000, true);
	WifiBox = TextDrawCreate(5.333310, 421.941436, "box");
	TextDrawLetterSize(WifiBox, 0.000000, 2.248336);
	TextDrawTextSize(WifiBox, 24.349935, 0.000000);
	TextDrawAlignment(WifiBox, 1);
	TextDrawColor(WifiBox, -1);
	TextDrawUseBox(WifiBox, 1);
	TextDrawBoxColor(WifiBox, 102);
	TextDrawSetShadow(WifiBox, 0);
	TextDrawBackgroundColor(WifiBox, 255);
	TextDrawFont(WifiBox, 1);
	TextDrawSetProportional(WifiBox, 1);
    Bar1 = TextDrawCreate(9.466705, 437.567565, "box");
	TextDrawLetterSize(Bar1, 0.000000, 0.358998);
	TextDrawTextSize(Bar1, 4.729997, 0.000000);
	TextDrawAlignment(Bar1, 1);
	TextDrawColor(Bar1, -1061109505);
	TextDrawUseBox(Bar1, 1);
	TextDrawBoxColor(Bar1, -1061109505);
	TextDrawSetShadow(Bar1, 0);
	TextDrawBackgroundColor(Bar1, 255);
	TextDrawFont(Bar1, 1);
	TextDrawSetProportional(Bar1, 1);
	Bar2 = TextDrawCreate(13.066704, 435.167541, "box");
	TextDrawLetterSize(Bar2, 0.000000, 0.637996);
	TextDrawTextSize(Bar2, 8.329997, 0.000000);
	TextDrawAlignment(Bar2, 1);
	TextDrawColor(Bar2, -1061109505);
	TextDrawUseBox(Bar2, 1);
	TextDrawBoxColor(Bar2, -1061109505);
	TextDrawSetShadow(Bar2, 0);
	TextDrawBackgroundColor(Bar2, 255);
	TextDrawFont(Bar2, 1);
	TextDrawSetProportional(Bar2, 1);
	Bar3 = TextDrawCreate(17.066711, 433.267425, "box");
	TextDrawLetterSize(Bar3, 0.000000, 0.885999);
	TextDrawTextSize(Bar3, 12.329998, 0.000000);
	TextDrawAlignment(Bar3, 1);
	TextDrawColor(Bar3, -1061109505);
	TextDrawUseBox(Bar3, 1);
	TextDrawBoxColor(Bar3, -1061109505);
	TextDrawSetShadow(Bar3, 0);
	TextDrawBackgroundColor(Bar3, 255);
	TextDrawFont(Bar3, 1);
	TextDrawSetProportional(Bar3, 1);
	Bar4 = TextDrawCreate(20.966726, 430.467254, "box");
	TextDrawLetterSize(Bar4, 0.000000, 1.195999);
	TextDrawTextSize(Bar4, 16.230014, 0.000000);
	TextDrawAlignment(Bar4, 1);
	TextDrawColor(Bar4, -1061109505);
	TextDrawUseBox(Bar4, 1);
	TextDrawBoxColor(Bar4, -1061109505);
	TextDrawSetShadow(Bar4, 0);
	TextDrawBackgroundColor(Bar4, 255);
	TextDrawFont(Bar4, 1);
	TextDrawSetProportional(Bar4, 1);
	Bar5 = TextDrawCreate(24.966741, 428.567138, "box");
	TextDrawLetterSize(Bar5, 0.000000, 1.443999);
	TextDrawTextSize(Bar5, 20.230030, 0.000000);
	TextDrawAlignment(Bar5, 1);
	TextDrawColor(Bar5, -1061109505);
	TextDrawUseBox(Bar5, 1);
	TextDrawBoxColor(Bar5, -1061109505);
	TextDrawSetShadow(Bar5, 0);
	TextDrawBackgroundColor(Bar5, 255);
	TextDrawFont(Bar5, 1);
	TextDrawSetProportional(Bar5, 1);
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
	    if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;
	    TextDrawShowForPlayer(i, WifiBox);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid, WifiBox);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(timer);
	TextDrawDestroy(WifiBox);
	TextDrawDestroy(Bar1);
	TextDrawDestroy(Bar2);
	TextDrawDestroy(Bar3);
	TextDrawDestroy(Bar4);
	TextDrawDestroy(Bar5);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	PingLevel[playerid] = PING_LEVEL_UPDATE;
	return 1;
}

forward WifiCheck();

public WifiCheck()
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;

        else if(GetPlayerPing(i) >= 0 && GetPlayerPing(i) < 201 && PingLevel[i] != PING_LEVEL_1)
        {
            PingLevel[i] = PING_LEVEL_1;

            UpdateConnectionStatus(i, PING_LEVEL_1);
		}
		else if(GetPlayerPing(i) >= 201 && GetPlayerPing(i) < 401 && PingLevel[i] != PING_LEVEL_2)
		{
            PingLevel[i] = PING_LEVEL_2;
            UpdateConnectionStatus(i, PING_LEVEL_2);
		}

		else if(GetPlayerPing(i) >= 401 && GetPlayerPing(i) < 551 && PingLevel[i] != PING_LEVEL_3)
		{
            PingLevel[i] = PING_LEVEL_3;
            UpdateConnectionStatus(i, PING_LEVEL_3);
		}
		else if(GetPlayerPing(i) >= 551 && GetPlayerPing(i) < 701 && PingLevel[i] != PING_LEVEL_4)
		{
            PingLevel[i] = PING_LEVEL_4;
            UpdateConnectionStatus(i, PING_LEVEL_4);
		}
		else if(GetPlayerPing(i) > 700 && PingLevel[i] != PING_LEVEL_5)
		{
            PingLevel[i] = PING_LEVEL_5;
            UpdateConnectionStatus(i, PING_LEVEL_5);
		}
	}
	return 1;
}

static UpdateConnectionStatus(playerid, level)
{

    TextDrawHideForPlayer(playerid, Bar1);
    TextDrawHideForPlayer(playerid, Bar2);
    TextDrawHideForPlayer(playerid, Bar3);
    TextDrawHideForPlayer(playerid, Bar4);
    TextDrawHideForPlayer(playerid, Bar5);
    TextDrawBoxColor(Bar1, PingLevelColors[level][0]);
    TextDrawBoxColor(Bar2, PingLevelColors[level][1]);
    TextDrawBoxColor(Bar3, PingLevelColors[level][2]);
    TextDrawBoxColor(Bar4, PingLevelColors[level][3]);
    TextDrawBoxColor(Bar5, PingLevelColors[level][4]);
    TextDrawShowForPlayer(playerid, Bar1);
    TextDrawShowForPlayer(playerid, Bar2);
    TextDrawShowForPlayer(playerid, Bar3);
    TextDrawShowForPlayer(playerid, Bar4);
    TextDrawShowForPlayer(playerid, Bar5);
	return 1;
}


//EOF.