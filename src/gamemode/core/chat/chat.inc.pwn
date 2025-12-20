#include "core\chat\admin.chat.pwn"
#include "core\chat\alliance.chat.pwn"
#include "core\chat\chatingwithadmin.chat.pwn"
#include "core\chat\crew.chat.pwn"
#include "core\chat\department.chat.pwn"
#include "core\chat\division.chat.pwn"
#include "core\chat\faction.chat.pwn"
#include "core\chat\gang.chat.pwn"
#include "core\chat\general.chat.pwn"
#include "core\chat\helper.chat.pwn"
#include "core\chat\newbie.chat.pwn"
#include "core\chat\ooc.chat.pwn"
#include "core\chat\privateradio.chat.pwn"
#include "core\chat\radio.chat.pwn"
#include "core\chat\report.chat.pwn"
#include "core\chat\govannonce.chat.pwn"

CMD:f(playerid, params[])
{
	if(PlayerData[playerid][pFaction] != -1)
		callcmd::fc(playerid, params);
	else callcmd::gc(playerid, params);
}

CMD:unmute(playerid, params[])
{
	new string[128];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unmute [newbie | report | global]");
	}

	if(!strcmp(params, "newbie", true))
	{
	    if(!PlayerData[playerid][pNewbieMuted])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not muted from the newbie chat.");
		}
		if(PlayerData[playerid][pNewbieMuteTime] > gettime())
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait at least %i minutes before requesting an unmute.", (PlayerData[playerid][pNewbieMuteTime] - gettime()) / 60);
		}

		format(string, sizeof(string), "Fine ($%i)\n10 Minute Jail", percent(PlayerData[playerid][pCash]+PlayerData[playerid][pBank], 5));
		Dialog_Show(playerid, DIALOG_NEWBIEUNMUTE, DIALOG_STYLE_LIST, "Choose your punishment for this unmute.", string, "Select", "Cancel");
	}
	else if(!strcmp(params, "report", true))
	{
	    if(!PlayerData[playerid][pReportMuted])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not muted from submitting reports.");
		}
		if(PlayerData[playerid][pReportMuted] <= 12)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "Your report mute is not indefinite and expires in %i playing hours.", PlayerData[playerid][pReportMuted]);
		}
		if(PlayerData[playerid][pReportMuteTime] > gettime())
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait at least %i minutes before requesting an unmute.", (PlayerData[playerid][pReportMuteTime] - gettime()) / 60);
		}

		format(string, sizeof(string), "Fine ($%i)\n10 Minute Jail", percent(PlayerData[playerid][pCash]+PlayerData[playerid][pBank], 5));
		Dialog_Show(playerid, DIALOG_REPORTUNMUTE, DIALOG_STYLE_LIST, "Choose your punishment for this unmute.", string, "Select", "Cancel");
	}
	else if(!strcmp(params, "global", true))
	{
	    if(!PlayerData[playerid][pGlobalMuted])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not muted from the global chat.");
		}
		if(PlayerData[playerid][pGlobalMuteTime] > gettime())
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait at least %i minutes before requesting an unmute.", (PlayerData[playerid][pGlobalMuteTime] - gettime()) / 60);
		}

		format(string, sizeof(string), "Fine ($%i)\n10 Minute Jail", percent(PlayerData[playerid][pCash]+PlayerData[playerid][pBank], 5));
		Dialog_Show(playerid, DIALOG_GLOBALUNMUTE, DIALOG_STYLE_LIST, "Choose your punishment for this unmute.", string, "Select", "Cancel");
	}

	return 1;
}

