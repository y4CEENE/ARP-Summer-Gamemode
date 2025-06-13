/// @file      Anti-Spam.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-07
/// @copyright Copyright (c) 2023

// Based on 'Anti spam by Rogue 2018/3/25'

#include <YSI\y_hooks>

enum eChatSpamData
{
	CSD_FirstText,
	CSD_SecondText,
	CSD_SpamTimer,
	CSD_SpamWarnings
};

static sChatSpamData[MAX_PLAYERS][eChatSpamData];

#define MAX_WAIT_TIME 1 //max waiting time in seconds

hook OnPlayerText(playerid, text[])
{
    CheckChatSpam(playerid);
}

hook OnPlayerCommandReceived(playerid, cmdtext[])
{
	CheckChatSpam(playerid);
}

stock CheckChatSpam(playerid)
{
	if(sChatSpamData[playerid][CSD_FirstText] == 0)
    {
        sChatSpamData[playerid][CSD_FirstText] = gettime();
    }
	else if(sChatSpamData[playerid][CSD_SecondText] == 0)
    {
        sChatSpamData[playerid][CSD_SecondText] = gettime();
    }
	else if(sChatSpamData[playerid][CSD_SecondText] - sChatSpamData[playerid][CSD_FirstText] < MAX_WAIT_TIME)
	{
		sChatSpamData[playerid][CSD_SpamWarnings]++;
		switch (sChatSpamData[playerid][CSD_SpamWarnings])
		{
			case 1:
			{
				KillTimer(sChatSpamData[playerid][CSD_SpamTimer]);
				sChatSpamData[playerid][CSD_SpamTimer] = SetTimerEx("ClearChatSpamWarns", 1500, false, "i", playerid);
			}
			case 2:
			{
				KillTimer(sChatSpamData[playerid][CSD_SpamTimer]);
				sChatSpamData[playerid][CSD_SpamTimer] = SetTimerEx("ClearChatSpamWarns", 3000, false, "i", playerid);
			}
			case 3:
			{
				KillTimer(sChatSpamData[playerid][CSD_SpamTimer]);
				sChatSpamData[playerid][CSD_SpamWarnings] = 0;
				CallLocalFunction("OnPlayerSpamChat", "i", playerid);
			}
		}
		sChatSpamData[playerid][CSD_FirstText] = 0;
		sChatSpamData[playerid][CSD_SecondText] = 0;
		return 0;
	}
	else if(sChatSpamData[playerid][CSD_SecondText] - sChatSpamData[playerid][CSD_FirstText] >= MAX_WAIT_TIME)
	{
		sChatSpamData[playerid][CSD_FirstText] = 0;
		sChatSpamData[playerid][CSD_SecondText] = 0;
	}
	return 1;
}

hook OnPlayerInit(playerid)
{
    KillTimer(sChatSpamData[playerid][CSD_SpamTimer]);
    sChatSpamData[playerid][CSD_SpamWarnings] = 0;
	sChatSpamData[playerid][CSD_FirstText] = 0;
	sChatSpamData[playerid][CSD_SecondText] = 0;
	return 1;
}

publish ClearChatSpamWarns(playerid)
{
    KillTimer(sChatSpamData[playerid][CSD_SpamTimer]);
    sChatSpamData[playerid][CSD_SpamWarnings] = 0;
}

hook OnPlayerSpamChat(playerid)
{
    KickPlayer(playerid, "Chat Spam");
}
