#include "core/admin/IPManagment.pwn"

#include <discord-connector>

new DCC_Guild:GName;
static DCC_Channel:login;
static DCC_Channel:logout;
static DCC_Channel:plogs;
new DCC_Channel:NameLogs;
static DCC_Channel:duty;
static DCC_Channel:moneylog;
static DCC_Channel:revivelog;
static DCC_Channel:Prisoned;
static DCC_Channel:Released;
static DCC_Channel:Whisper;

hook OnGameModeInit() 
{
    GName = DCC_FindGuildById("1412020994029387798");
    NameLogs = DCC_FindChannelById("1412010274923352194");
	plogs = DCC_FindChannelById("1412021477116477540");
    login = DCC_FindChannelById("1412021388193042522");
	logout = DCC_FindChannelById("1412021440168853534");
	duty = DCC_FindChannelById("1412021670130225265");
	moneylog = DCC_FindChannelById("1412021692175487088");
	revivelog = DCC_FindChannelById("1412023535055933460");
	Prisoned = DCC_FindChannelById("1412364482730004571");
	Released = DCC_FindChannelById("1412364501579206656");
	Whisper = DCC_FindChannelById("1413110136511139881");
	SetTimer("AutoSaveAdminDutyTime", 300000, true); // Save every 5 minutes
}

hook OnLoadPlayer(playerid)
{
    new query[256];
    format(query, sizeof(query), "**🟢%s Has logged in the server (IP: %s)**", GetRPName(playerid), GetPlayerIP(playerid));
    DCC_SendChannelMessage(login, query);
}

hook OnPlayerDisconnect(playerid)
{
    new query[256];
    format(query, sizeof(query), "**🔴(%s) Has disconnected from the server**", GetRPName(playerid));
    DCC_SendChannelMessage(logout, query);
}

CMD:pm(playerid, params[])
{
    new targetid, text[128], string[128];

    if (sscanf(params, "us[128]", targetid, text))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(pm) [playerid] [text]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't pm to yourself.");
    }
    if (PlayerData[playerid][pHours] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to play at least 3 hours+ to use this command");
    }
    if (PlayerData[targetid][pTogglePM])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming private messages.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }
    if (PlayerData[playerid][pCash] < 3000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need $3,000 to send private message.");
    }
    SendClientMessageEx(targetid, COLOR_GREEN, "(( PM from %s: %s ))", GetRPName(playerid), text);
    SendClientMessageEx(playerid, COLOR_GREEN, "(( PM to %s: %s ))", GetRPName(targetid), text);

	format(string, sizeof(string), "[PM] (( %s to %s: %s ))", GetRPName(playerid), GetRPName(targetid), text);
	DCC_SendChannelMessage(plogs, string);

    if (PlayerData[targetid][pWhisperFrom] == INVALID_PLAYER_ID)
    {
        SendClientMessage(targetid, COLOR_WHITE, "* You can use '/rpm [message]' to reply to this private message.");
    }

    GivePlayerCash(playerid, -3000);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$3,000", 5000, 1);
    PlayerData[targetid][pWhisperFrom] = playerid;
    return 1;
}

CMD:revive(playerid, params[])
{
	new targetid, string[128];

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /revive [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is not injured.");
	}

	PlayerData[targetid][pInjured] = 0;

	SetPlayerHealth(targetid, 100.0);
	ClearAnimations(targetid, 1);

	SendClientMessage(targetid, COLOR_YELLOW, "You have been revived by an admin!");
	if(PlayerData[targetid][pAcceptedEMS] != INVALID_PLAYER_ID)
	{
	    SendClientMessageEx(PlayerData[targetid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has somehow found the strength to get up.", GetRPName(targetid));
	    PlayerData[targetid][pAcceptedEMS] = INVALID_PLAYER_ID;
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has revived %s.", GetRPName(playerid), GetRPName(targetid));
	format(string, sizeof(string), "```%s has revived %s```", GetRPName(playerid), GetRPName(targetid));
    DCC_SendChannelMessage(revivelog, string);
	return 1;
}

stock RevivePlayer(playerid)
{
    if (PlayerData[playerid][pInjured])
    {
        PlayerData[playerid][pInjured] = 0;
        SetPlayerHealth(playerid, 100.0);
        ClearAnimations(playerid, 1);

        if (PlayerData[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
        {
            SendClientMessageEx(PlayerData[playerid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has somehow found the strength to get up.", GetRPName(playerid));
            PlayerData[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
        }
        return 1;
    }
    return 0;
}

CMD:pay(playerid, params[])
{
	new targetid, amount, szString[128];

	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pay [playerid] [amount]");
	}
	if(gettime() - PlayerData[playerid][pLastPay] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Please wait three seconds between each transaction.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't pay yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
	}
	if(amount > PlayerData[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have that much.");
	}
	if(amount > 1000 && PlayerData[playerid][pLevel] < 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can only pay up to $1,000 at a time as a level 1.");
	}
	if(amount > 100000)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are only allowed to pay up to $100,000 at a time.");
	}
	if(PlayerData[playerid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
	}

	PlayerData[playerid][pLastPay] = gettime();

	GivePlayerCash(playerid, -amount);
	GivePlayerCash(targetid, amount);

	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);

	ShowActionBubble(playerid, "* %s takes out %s and gives it to %s.", GetRPName(playerid), FormatCash(amount), GetRPName(targetid));
	Log_Write("log_give", "%s (uid: %i) (IP: %s) gives $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid), amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetPlayerIP(targetid));

	format(szString, sizeof(szString), " %s has given $%i to %s.", GetRPName(playerid), amount, GetRPName(targetid));
	DCC_SendChannelMessage(moneylog, szString);

    SendClientMessageEx(targetid, COLOR_AQUA, "You have been given {00AA00}%s{33CCFF} by %s.", FormatCash(amount), GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "You have given {FF6347}%s{33CCFF} to %s.", FormatCash(amount), GetRPName(targetid));

	if(!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
	{
	    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has given %s to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), FormatCash(amount), GetRPName(targetid), GetPlayerIP(targetid));
	}

	return 1;
}

CMD:givemoney(playerid, params[])
{
	new targetid, amount, szString[128];

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givemoney [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	GivePlayerCash(targetid, amount);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s to %s.", GetRPName(playerid), FormatCash(amount), GetRPName(targetid));
	Log_Write("log_givemoney", "%s (uid: %i) has used /givemoney to give $%i to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	format(szString, sizeof(szString), " %s has given $%i to %s.", GetRPName(playerid), amount, GetRPName(targetid));
	DCC_SendChannelMessage(moneylog, szString);
	return 1;
}

CMD:prison(playerid, params[])
{
	new targetid, minutes, reason[128];
	new szString[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /prison [playerid] [minutes] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be prisoned.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
	}
	if(gettime() - PlayerData[playerid][pLastPrison] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /prison again.", 60 - (gettime() - PlayerData[playerid][pLastPrison]));
	}

    PlayerData[targetid][pJailType] = 2;
    PlayerData[targetid][pJailTime] = minutes * 60;

	ResetPlayerWeaponsEx(targetid);
	ResetPlayer(targetid);

	SetPlayerInJail(targetid);
	SetPlayerSkin(targetid, 50);
	GameTextForPlayer(targetid, "~w~Welcome to~n~~r~admin jail", 5000, 3);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET prisonedby = '%e', prisonreason = '%e' WHERE uid = %i", GetPlayerNameEx(playerid), reason, PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	GetPlayerName(playerid, PlayerData[targetid][pPrisonedBy], MAX_PLAYER_NAME);
	strcpy(PlayerData[targetid][pPrisonReason], reason, 128);

	PlayerData[playerid][pLastPrison] = gettime();

	Log_Write("log_punishments", "%s (uid: %i) prisoned %s (uid: %i) for %i minutes, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes, reason);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for %i minutes by %s, reason: %s", GetRPName(targetid), minutes, GetRPName(playerid), reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been admin prisoned for %i minutes by %s.", minutes, GetRPName(playerid));
	format(szString, sizeof(szString), "%s was prisoned for %i minutes by %s, reason: %s", GetRPName(targetid), minutes, GetRPName(playerid), reason);
    DCC_SendChannelMessage(Prisoned, szString);
    return 1;
}

CMD:oprison(playerid, params[])
{
	new username[MAX_PLAYERS], minutes, reason[128];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]is[128]", username, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /oprison [username] [minutes] [reason]");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /prison instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel, uid FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflinePrison", "isis", playerid, username, minutes, reason);
	return 1;
}

CMD:release(playerid, params[])
{
    new targetid, reason[128];
	new szString[128];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /release [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pJailType])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not jailed.");
	}

	PlayerData[targetid][pJailTime] = 1;
	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was released from jail/prison by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
	format(szString, sizeof(szString), "%s was released from jail/prison by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
    DCC_SendChannelMessage(Released, szString);
	return 1;
}

CMD:acceptname(playerid, params[])
{
	new targetid, string[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	    return SendClientErrorUnauthorizedCmd(playerid);

	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /acceptname [playerid]");

	if(!IsPlayerConnected(targetid))
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");

	if(isnull(PlayerData[targetid][pNameChange]))
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested a namechange.");

	if(PlayerData[targetid][pFreeNamechange] == 0 && PlayerData[targetid][pCash] < PlayerData[targetid][pLevel] * 7500)
	    return SendClientMessage(playerid, COLOR_GREY, "That player can't afford the namechange.");

	new cost = PlayerData[targetid][pLevel] * 7500;

	if(PlayerData[targetid][pFreeNamechange])
	{
	    if (PlayerData[targetid][pFreeNamechange] == 2 &&
	        (
	            GetPlayerFaction(targetid) == FACTION_HITMAN ||
	            GetPlayerFaction(targetid) == FACTION_FEDERAL ||
	            GetPlayerFaction(targetid) == FACTION_TERRORIST ||
	            GetPlayerFaction(targetid) == FACTION_GOVERNMENT ||
	            (PlayerData[targetid][pGang] != -1 && GangInfo[PlayerData[targetid][pGang]][gIsMafia])
	        ))
	    {
	        GetPlayerName(targetid, PlayerData[targetid][pPassportName], MAX_PLAYER_NAME);

	        PlayerData[targetid][pPassport] = 1;
	        PlayerData[targetid][pPassportLevel] = PlayerData[targetid][pLevel];
	        PlayerData[targetid][pPassportSkin] = PlayerData[targetid][pSkin];
	        PlayerData[targetid][pPassportPhone] = PlayerData[targetid][pPhone];
			PlayerData[targetid][pLevel] = PlayerData[targetid][pChosenLevel];
			PlayerData[targetid][pSkin] = PlayerData[targetid][pChosenSkin];
			PlayerData[targetid][pPhone] = random(100000) + 899999;

			SetPlayerSkin(targetid, PlayerData[targetid][pSkin]);

			Log_Write("log_faction", "%s (uid: %i) used the /passport command to change their name to %s, level to %i and skin to %i.", GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange], PlayerData[targetid][pLevel], PlayerData[targetid][pSkin]);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET level = %i, skin = %i, phone = %i, passport = 1, passportname = '%s', passportlevel = %i, passportskin = %i, passportphone = %i WHERE uid = %i",
			PlayerData[targetid][pLevel], PlayerData[targetid][pSkin], PlayerData[targetid][pPhone], PlayerData[targetid][pPassportName], PlayerData[targetid][pPassportLevel], PlayerData[targetid][pPassportSkin], PlayerData[targetid][pPassportPhone], PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
	    }

		Log_Write("log_admin", "%s (uid: %i) accepted %s's (uid: %i) free namechange to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange]);
		Log_Write("log_namechanges", "%s (uid: %i) accepted %s's (uid: %i) free namechange to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange]);


		format(string, sizeof(string), "```%s has accepted %s namechange to %s```", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange]);
        DCC_SendChannelMessage(NameLogs, string);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has accepted %s's free namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange]);
		SendClientMessageEx(targetid, COLOR_YELLOW, "Your namechange request to %s was approved for free.", PlayerData[targetid][pNameChange]);

        if(!IsPlayerLoggedIn(targetid))
  			ShowLoginDlg(targetid);

		if(PlayerData[targetid][pFreeNamechange] == 2)
		    SendClientMessage(targetid, COLOR_WHITE, "* You can use /passport again to return to your old name and stats.");
	}
	else
	{
	    Log_Write("log_admin", "%s (uid: %i) accepted %s's (uid: %i) namechange to %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange], cost);
		Log_Write("log_namechanges", "%s (uid: %i) accepted %s's (uid: %i) namechange to %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange], cost);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has accepted %s's namechange to %s for %s.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange], FormatCash(cost));
		SendClientMessageEx(targetid, COLOR_YELLOW, "Your namechange request to %s was approved for %s.", PlayerData[targetid][pNameChange], FormatCash(cost));

        GivePlayerCash(targetid, -cost);
        AddToTaxVault(cost);
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO log_namehistory VALUES(null, %i, '%s', '%s', '%s', NOW())", PlayerData[targetid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pNameChange], GetPlayerNameEx(playerid));
	mysql_tquery(connectionID, queryBuffer);

	Namechange(targetid, GetPlayerNameEx(targetid), PlayerData[targetid][pNameChange]);
	PlayerData[targetid][pNameChange] = 0;
	PlayerData[targetid][pFreeNamechange] = 0;
	return 1;
}

CMD:w(playerid, params[])
{
    return callcmd::whisper(playerid, params);
}

// /whisper command
CMD:whisper(playerid, params[])
{
    new targetid, text[128], szString[128];

    if (sscanf(params, "us[128]", targetid, text))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(w)hisper [playerid] [text]");
    }

    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (!IsPlayerNearPlayer(playerid, targetid, 5.0) && (!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be near that player to whisper them.");
    }

    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't whisper to yourself.");
    }

    if (PlayerData[targetid][pToggleWhisper])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming whispers.");
    }

    SendClientMessageEx(targetid, COLOR_YELLOW, "* Whisper from %s: %s *", GetRPName(playerid), text);
    SendClientMessageEx(playerid, COLOR_YELLOW, "* Whisper to %s: %s *", GetRPName(targetid), text);

    format(szString, sizeof(szString), "[WHISPER] %s whisper to %s: %s", GetRPName(playerid), GetRPName(targetid), text);
    DCC_SendChannelMessage(Whisper, szString);

    if (PlayerData[playerid][pBugged])
    {
        foreach (new i : Player)
        {
            if (GetPlayerFaction(i) == FACTION_FEDERAL)
            {
                SendClientMessageEx(i, 0x9ACD3200, "(bug) %s whispers: %s", GetRPName(playerid), text);
            }
        }
    }

    if (PlayerData[targetid][pWhisperFrom] == INVALID_PLAYER_ID)
    {
        SendClientMessage(targetid, COLOR_WHITE, "* You can use '/rw [message]' to reply to this whisper.");
    }

    PlayerData[targetid][pWhisperFrom] = playerid;
    return 1;
}


CMD:aduty(playerid, params[])
{
    new string[128];

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    
    if(!PlayerData[playerid][pAdminDuty])
    {
        if(PlayerData[playerid][pUndercover][0])
        {
            OnUndercover(playerid, 0, "", 0, 0.0, 0.0);
        }

        SavePlayerVariables(playerid);
        ResetPlayerWeapons(playerid);

        SetPlayerHealth(playerid, 32767);
        SetScriptArmour(playerid, 0.0);
        SetPlayerSkin(playerid, ADMIN_SKIN);

        PlayerData[playerid][pAdminDutyStart] = gettime();
        PlayerData[playerid][pAdminDutyPaused] = 0; 
        PlayerData[playerid][pAdminDutyPausedTime] = 0;

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s is now on admin duty.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_WHITE, "You are now on admin duty. Your stats will not be saved until you're off duty.");
        SendClientMessage(playerid, COLOR_YELLOW, "NOTE: Duty time tracking will pause automatically if you go AFK.");

        format(string, sizeof(string), "```%s is now on admin duty```", GetRPName(playerid));
        DCC_SendChannelMessage(duty, string);

        PlayerData[playerid][pAdminDuty] = 1;
        PlayerData[playerid][pTogglePhone] = 1;
        
        if(strcmp(PlayerData[playerid][pAdminName], "None", true) != 0)
        {
            SetPlayerName(playerid, PlayerData[playerid][pAdminName]);
        }
    }
    else
    {
        new savecheck = 0;

        if(PlayerData[playerid][pPaycheck] > 1)
        {
            savecheck = PlayerData[playerid][pPaycheck];
        }
        
        if(PlayerData[playerid][pNoDamage])
        {
            PlayerData[playerid][pNoDamage] = 0;
            SendClientMessage(playerid, COLOR_GREY, "Your god mode was turned off.");
        }

        if(PlayerData[playerid][pAdminDutyStart] > 0)
        {
            new dutytime = CalculateActiveDutyTime(playerid);
            PlayerData[playerid][pAdminDutyTime] += dutytime;
            
            new hours, minutes, seconds;
            seconds = dutytime;
            hours = seconds / 3600;
            seconds -= hours * 3600;
            minutes = seconds / 60;
            seconds -= minutes * 60;
            
            format(string, sizeof(string), "You were on duty for: %02d:%02d:%02d (AFK time excluded)", hours, minutes, seconds);
            SendClientMessage(playerid, COLOR_YELLOW, string);
            

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
                "UPDATE "#TABLE_USERS" SET admin_duty_time = %i WHERE uid = %i", 
                PlayerData[playerid][pAdminDutyTime], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            
            PlayerData[playerid][pAdminDutyStart] = 0;
            PlayerData[playerid][pAdminDutyPaused] = 0;
            PlayerData[playerid][pAdminDutyPausedTime] = 0;
        }

        ClearDeathList(playerid);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM "#TABLE_USERS" WHERE uid = %i", PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer, "db_THREAD_PROCESS_LOGIN", "i", playerid);
        PlayerData[playerid][pPaycheck] = savecheck;
    }

    return 1;
}


stock CalculateActiveDutyTime(playerid)
{
    if(PlayerData[playerid][pAdminDutyStart] <= 0)
        return 0;
    
    new totaltime = gettime() - PlayerData[playerid][pAdminDutyStart];
    
    if(PlayerData[playerid][pAdminDutyPaused] && PlayerData[playerid][pAdminDutyPausedTime] > 0)
    {
        new afktime = gettime() - PlayerData[playerid][pAdminDutyPausedTime];
        totaltime -= afktime;
    }
    
    return totaltime;
}

stock OnPlayerGoAFK(playerid)
{
    if(PlayerData[playerid][pAdminDuty] && !PlayerData[playerid][pAdminDutyPaused])
    {
        if(PlayerData[playerid][pAdminDutyStart] > 0)
        {
            new activetime = gettime() - PlayerData[playerid][pAdminDutyStart];
            PlayerData[playerid][pAdminDutyTime] += activetime;
            
            PlayerData[playerid][pAdminDutyPaused] = 1;
            PlayerData[playerid][pAdminDutyPausedTime] = gettime();
            
            SendClientMessage(playerid, COLOR_ORANGE, "[DUTY] Your admin duty time tracking has been paused (AFK detected).");
        }
    }
}

stock OnPlayerReturnFromAFK(playerid)
{
    if(PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdminDutyPaused])
    {
        PlayerData[playerid][pAdminDutyStart] = gettime();
        PlayerData[playerid][pAdminDutyPaused] = 0;
        PlayerData[playerid][pAdminDutyPausedTime] = 0;
        
        SendClientMessage(playerid, COLOR_GREEN, "[DUTY] Your admin duty time tracking has resumed (Welcome back!).");
    }
}

CMD:dutytime(playerid, params[])
{
    new targetid;
    
    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    
    if(sscanf(params, "u", targetid))
    {
        targetid = playerid;
    }
    
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Player is not connected.");
    }
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
        "SELECT admin_duty_time FROM "#TABLE_USERS" WHERE uid = %i", 
        PlayerData[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer, "OnCheckDutyTime", "ii", playerid, targetid);
    
    return 1;
}

forward OnCheckDutyTime(playerid, targetid);
public OnCheckDutyTime(playerid, targetid)
{
    if(cache_num_rows() > 0)
    {
        new string[256];
        new totaltime = cache_get_field_content_int(0, "admin_duty_time");
        
        if(PlayerData[targetid][pAdminDuty] && PlayerData[targetid][pAdminDutyStart] > 0)
        {
            totaltime += CalculateActiveDutyTime(targetid);
        }
        
        new hours, minutes, seconds;
        seconds = totaltime;
        hours = seconds / 3600;
        seconds -= hours * 3600;
        minutes = seconds / 60;
        seconds -= minutes * 60;
        
        format(string, sizeof(string), "_____ %s's Admin Duty Time _____", GetRPName(targetid));
        SendClientMessage(playerid, COLOR_WHITE, string);
        format(string, sizeof(string), "Total Duty Time: %d hours, %d minutes, %d seconds", hours, minutes, seconds);
        SendClientMessage(playerid, COLOR_WHITE, string);
        
        if(PlayerData[targetid][pAdminDuty])
        {
            if(PlayerData[targetid][pAdminDutyPaused])
            {
                SendClientMessage(playerid, COLOR_ORANGE, "Status: On duty (PAUSED - AFK)");
            }
            else
            {
                new currenttime = CalculateActiveDutyTime(targetid);
                seconds = currenttime;
                hours = seconds / 3600;
                seconds -= hours * 3600;
                minutes = seconds / 60;
                seconds -= minutes * 60;
                
                format(string, sizeof(string), "Current Session: %02d:%02d:%02d (AFK time excluded)", hours, minutes, seconds);
                SendClientMessage(playerid, COLOR_GREEN, string);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "Status: Currently off duty");
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Error: Could not retrieve duty time from database.");
    }
    
    return 1;
}

CMD:staffduty(playerid, params[])
{
    new string[256];
    
    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    
    SendClientMessage(playerid, COLOR_GREEN, "_____ Staff Duty Times _____");
    
    foreach(new i : Player)
    {
        if(PlayerData[i][pAdmin] >= JUNIOR_ADMIN)
        {
            new totaltime = PlayerData[i][pAdminDutyTime];
            
            if(PlayerData[i][pAdminDuty] && PlayerData[i][pAdminDutyStart] > 0)
            {
                totaltime += CalculateActiveDutyTime(i);
            }
            
            new hours, minutes;
            minutes = totaltime / 60;
            hours = minutes / 60;
            minutes -= hours * 60;
            
            new statustext[32];
            if(PlayerData[i][pAdminDuty])
            {
                if(PlayerData[i][pAdminDutyPaused])
                    statustext = "(ON DUTY - AFK)";
                else
                    statustext = "(ON DUTY)";
            }
            else
            {
                statustext = "";
            }
            
            format(string, sizeof(string), "%s (Level %d): %d hours, %d minutes %s", 
                GetRPName(i), 
                PlayerData[i][pAdmin], 
                hours, 
                minutes,
                statustext);
            SendClientMessage(playerid, COLOR_WHITE, string);
        }
    }
    
    return 1;
}

CMD:givemoneyall(playerid, params[])
{
	new amount;

	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givemoneyall [amount]");
	}
    
    foreach(new targetid: Player)
    {
        if(!PlayerData[targetid][pLogged])
        {
            continue;
        }
        GivePlayerCash(targetid, amount);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s to %s.", GetRPName(playerid), FormatCash(amount), GetRPName(targetid));
        Log_Write("log_givemoney", "%s (uid: %i) has used /givemoney to give $%i to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
	return 1;
}

CMD:osetvip(playerid, params[])
{
	new username[MAX_PLAYER_NAME], level, time;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]iI(0)", username, level, time))
	{
		SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /osetvip [username] [level(0-3)] [days]");
		SendClientMessage(playerid, COLOR_GREY3, "List of ranks: (0) None (1) Silver (2) Gold (3) Legendary");
		return 1;
	}
	if(!(0 <= level <= 3))
	{
	    	return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 3.");
	}
	if(!(1 <= time <= 365))
	{
	    	return SendClientMessage(playerid, COLOR_GREY, "The amount of days must range from 1 to 365.");
	}
	if(IsPlayerOnline(username))
	{
	    	return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /setvip instead.");
	}
	if(level == 0)
	{
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's VIP package.", GetRPName(playerid), username);
		time = 0;
	}
	else if(time >= 30)
	{
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {A028AD}%s{FF6347} VIP package to %s for %i months.", GetRPName(playerid), GetVIPRank(level), username, time / 30);
		time = gettime() + (time * 86400);
	}
	else
	{
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {A028AD}%s{FF6347} VIP package to %s for %i days.", GetRPName(playerid), GetVIPRank(level), username, time);
		time = gettime() + (time * 86400);
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE username = '%e'", level, time, username);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:setvip(playerid, params[])
{
	new targetid, rank, days, drugs, weed, cocaine, heroin, painkillers, seeds;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uii", targetid, rank, days))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setvip [playerid] [rank] [days]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of ranks: (1) Silver (2) Gold (3) Legendary");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!(1 <= rank <= 3))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
	}
	if(!(1 <= days <= 365))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount of days must range from 1 to 365.");
	}

	weed = GetPlayerCapacity(playerid, CAPACITY_WEED);
	cocaine = GetPlayerCapacity(playerid, CAPACITY_COCAINE);
	heroin = GetPlayerCapacity(playerid, CAPACITY_HEROIN);
    painkillers = GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS);
    seeds = GetPlayerCapacity(playerid, CAPACITY_SEEDS);

	if(drugs)
	{
	    PlayerData[targetid][pWeed] = weed;
	    PlayerData[targetid][pCocaine] = cocaine;
	    PlayerData[targetid][pHeroin] = heroin;
	    PlayerData[targetid][pPainkillers] = painkillers;
	    PlayerData[targetid][pSeeds] = seeds;
	    PlayerData[targetid][pBoombox] = 1;
	    PlayerData[targetid][pMP3Player] = 1;
	    SendClientMessageEx(targetid, COLOR_VIP, "%s %s has given you a full load of drugs with your %s VIP Package", GetAdminRank(playerid), GetRPName(playerid), GetVIPRank(rank));
	}


	PlayerData[targetid][pDonator] = rank;
	PlayerData[targetid][pVIPTime] = gettime() + (days * 86400);
	PlayerData[targetid][pVIPCooldown] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0, weed = %i, cocaine = %i, heroin = %i, painkillers = %i, seeds = %i WHERE uid = %i", PlayerData[targetid][pDonator], PlayerData[targetid][pVIPTime], PlayerData[targetid][pWeed], PlayerData[targetid][pCocaine], PlayerData[targetid][pHeroin], PlayerData[targetid][pPainkillers], PlayerData[targetid][pSeeds], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(days >= 30)
	{
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {D909D9}%s{FF6347} VIP package to %s for %i months.", GetRPName(playerid), GetVIPRank(rank), GetRPName(targetid), days / 30);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have given %s a {D909D9}%s{33CCFF} VIP package for %i months.", GetRPName(targetid), GetVIPRank(rank), days / 30);
		SendClientMessageEx(targetid, COLOR_AQUA, "* %s has given you a {D909D9}%s{33CCFF} VIP package for %i months.", GetRPName(playerid), GetVIPRank(rank), days / 30);
	}
	else
	{
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {D909D9}%s{FF6347} VIP package to %s for %i days.", GetRPName(playerid), GetVIPRank(rank), GetRPName(targetid), days);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have given %s a {D909D9}%s{33CCFF} VIP package for %i days.", GetRPName(targetid), GetVIPRank(rank), days);
		SendClientMessageEx(targetid, COLOR_AQUA, "* %s has given you a {D909D9}%s{33CCFF} VIP package for %i days.", GetRPName(playerid), GetVIPRank(rank), days);
	}

	Log_Write("log_vip", "%s (uid: %i) has given %s (uid: %i) a %s VIP package for %i days.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetVIPRank(rank), days);
	return 1;
}

CMD:removevip(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removevip [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!PlayerData[targetid][pDonator])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player doesn't have a VIP subscription which you can remove.");
	}

	Log_Write("log_vip", "%s (uid: %i) has removed %s's (uid: %i) %s VIP package.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetVIPRank(PlayerData[targetid][pDonator]));

	PlayerData[targetid][pDonator] = 0;
	PlayerData[targetid][pVIPTime] = 0;
	PlayerData[targetid][pVIPColor] = 0;
    PlayerData[targetid][pSecondJob] = JOB_NONE;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET vippackage = 0, viptime = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has revoked %s's VIP subscription.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has revoked your VIP subscription.", GetRPName(playerid));
	return 1;
}


CMD:forcepayday(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(sscanf(params, "s", "confirm"))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcepayday [confirm] (gives everyone a paycheck)");
	}
	foreach(new i : Player)
	{
	    SendPaycheck(i);
	}

	return 1;
}

CMD:setpassword(playerid, params[])
{
	new username[MAX_PLAYER_NAME], password[128];

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && ! PlayerData[playerid][pAdminPersonnel])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]s[128]", username, password))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setpassword [username] [new password]");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. You can't change their password.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminChangePassword", "iss", playerid, username, password);
	return 1;
}

CMD:setadmin(playerid, params[])
{
    return callcmd::makeadmin(playerid, params);
}

CMD:makeadmin(playerid, params[])
{
	new targetid, level;

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pAdminPersonnel])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "ui", targetid, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /makeadmin [playerid] [level]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!(0 <= level <= 10))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 10.");
	}
	if(PlayerData[playerid][pAdminPersonnel] && level > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Level cannot be higher than your admin level.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin] && level < PlayerData[targetid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be demoted.");
	}

	if(level <= 1 && PlayerData[targetid][pAdminDuty])
	{
	    SetPlayerName(targetid, PlayerData[targetid][pUsername]);

		PlayerData[targetid][pAdminDuty] = 0;
    }

    PlayerData[targetid][pAdmin] = level;
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s (%i).", GetRPName(playerid), GetRPName(targetid), GetAdminRank(targetid), level);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET adminlevel = %i WHERE uid = %i", level, PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(level == 0)
	{
		SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's administrator powers.", GetRPName(targetid));
		SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your administrator powers.", GetRPName(playerid));
		PlayerData[targetid][pDeveloper] = 0;
		PlayerData[targetid][pFactionMod] = 0;
		PlayerData[targetid][pWebDev] = 0;
		PlayerData[targetid][pBanAppealer] = 0;
		PlayerData[targetid][pGangMod] = 0;
		PlayerData[targetid][pHelperManager] = 0;
		PlayerData[targetid][pDynamicAdmin] = 0;
		PlayerData[targetid][pAdminPersonnel] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET removeddate = '%s', scripter = 0, gangmod = 0, banappealer = 0, factionmod = 0, webdev = 0, helpermanager = 0, dynamicadmin = 0, adminpersonnel = 0 WHERE uid = %i", GetDateTime(), PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET addeddate = '%s' WHERE uid = %i", GetDateTime(), PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have set %s's admin level to {FF6347}%s{33CCFF} (%i).", GetRPName(targetid), GetAdminRank(targetid), level);
		SendClientMessageEx(targetid, COLOR_AQUA, "%s has set your admin level to {FF6347}%s{33CCFF} (%i).", GetRPName(playerid), GetAdminRank(targetid), level);
	}

	Log_Write("log_makeadmin", "%s (uid: %i) set %s's (uid: %i) admin level to %i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], level);
	return 1;
}


CMD:omakeadmin(playerid, params[])
{
	new username[MAX_PLAYER_NAME], level;

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pAdminPersonnel])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]i", username, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /omakeadmin [username] [level]");
	}
	if(!(0 <= level <= 8))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 8.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /makeadmin instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminSetAdminLevel", "isi", playerid, username, level);
	return 1;
}

CMD:sethelper(playerid, params[])
{
	return callcmd::makehelper(playerid, params);
}

CMD:makehelper(playerid, params[])
{
	new targetid, level;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && PlayerData[playerid][pHelper] < 7 && !PlayerData[playerid][pHelperManager])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /makehelper [playerid] [level]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!(0 <= level <= 7))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 7.");
	}
	if((PlayerData[playerid][pAdmin] < GENERAL_MANAGER) && PlayerData[targetid][pHelper] > PlayerData[playerid][pHelper] && level < PlayerData[targetid][pHelper])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher helper level than you. They cannot be demoted.");
	}

	if(level == 0)
	{

		if(PlayerData[targetid][pAcceptedHelp])
		{
		    callcmd::return(targetid, "\1");
		}
	}

	SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a level %i helper.", GetRPName(playerid), GetRPName(targetid), level);
	PlayerData[targetid][pHelper] = level;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET helperlevel = %i WHERE uid = %i", level, PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {00AA00}%s{33CCFF} (%i).", GetRPName(targetid), GetHelperRank(targetid), level);
	SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {00AA00}%s{33CCFF} (%i).", GetRPName(playerid), GetHelperRank(targetid), level);

	Log_Write("log_makehelper", "%s (uid: %i) set %s's (uid: %i) helper level to %i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], level);
	return 1;
}

CMD:omakehelper(playerid, params[])
{
	new username[MAX_PLAYER_NAME], level;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pHelperManager])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "s[24]i", username, level))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /omakehelper [username] [level]");
	}
	if(!(0 <= level <= 4))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 4.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /makehelper instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT helperlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminSetHelperLevel", "isi", playerid, username, level);
	return 1;
}

CMD:olisthelpers(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER && PlayerData[playerid][pHelper] < 3 && !PlayerData[playerid][pHelperManager])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	mysql_tquery(connectionID, "SELECT username, lastlogin, helperlevel FROM "#TABLE_USERS" WHERE helperlevel > 0 ORDER BY lastlogin DESC", "OnQueryFinished", "ii", THREAD_LIST_HELPERS, playerid);
	return 1;
}

CMD:givegun(playerid, params[])
{
	new targetid, weaponid;

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, weaponid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givegun [playerid] [weaponid]");
        SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
        SendClientMessage(playerid, COLOR_SYNTAX, "1: Brass Knuckles 2: Golf Club 3: Nite Stick 4: Knife 5: Baseball Bat 6: Shovel 7: Pool Cue 8: Katana 9: Chainsaw");
        SendClientMessage(playerid, COLOR_SYNTAX, "10: Purple Dildo 11: Small White Vibrator 12: Large White Vibrator 13: Silver Vibrator 14: Flowers 15: Cane 16: Frag Grenade");
        SendClientMessage(playerid, COLOR_SYNTAX, "17: Tear Gas 18: Molotov Cocktail 19: Vehicle Missile 20: Hydra Flare 21: Jetpack 22: 9mm 23: Silenced 9mm 24: Desert Eagle");
        SendClientMessage(playerid, COLOR_SYNTAX, "26: Sawnoff Shotgun 27: Combat Shotgun 28: Micro SMG (Mac 10) 29: SMG (MP5) 30: AK-47 31: M4 32: Tec9 33: Rifle");
        SendClientMessage(playerid, COLOR_SYNTAX, "25: Shotgun 34: Sniper Rifle 35: Rocket Launcher 36: HS Rocket Launcher 37: Flamethrower 38: Minigun 39: Satchel Charge");
        SendClientMessage(playerid, COLOR_SYNTAX, "40: Detonator 41: Spraycan 42: Fire Extinguisher 43: Camera 44: Nightvision Goggles 45: Infared Goggles 46: Parachute");
        SendClientMessage(playerid, COLOR_SYNTAX, "_______________________________________");
		return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
	if(!(1 <= weaponid <= 46))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon.");
	}

	if(weaponid == 38 && PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The minigun was disabled due to abuse.");
	}

	if(PlayerHasWeapon(targetid, weaponid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player already have this weapon.");
	}
											//ammo
	GivePlayerWeaponEx(targetid, weaponid); // true = pgunsammo

	SendClientMessageEx(targetid, COLOR_AQUA, "You have received a {00AA00}%s{33CCFF} from %s.", GetWeaponNameEx(weaponid), GetRPName(playerid));
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a %s to %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
	Log_Write("log_givegun", "%s (uid: %i) gives a %s to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetWeaponNameEx(weaponid), GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	return 1;
}

CMD:setweather(playerid, params[])
{
	new weatherid;

	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", weatherid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setweather [weatherid]");
	}

	SetDBWeatherID(weatherid);
	SetWeather(weatherid);
	SendClientMessageEx(playerid, COLOR_GREY2, "Weather changed to %i.", weatherid);
	return 1;
}

CMD:settime(playerid, params[])
{
	new hour;

	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", hour))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settime [hour]");
	}
	if(!(0 <= hour <= 23))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The hour must range from 0 to 23.");
	}

	gWorldTime = hour;

	SetWorldTime(hour);
	SendClientMessageToAllEx(COLOR_GREY2, "Time of day changed to %i hours.", hour);
	return 1;
}

CMD:setstat(playerid, params[])
{
	new targetid, option[24], param[32], value;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [option]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Gender, Age, Cash, Bank, Level, Respect, UpgradePoints, Hours, Warnings");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: SpawnHealth, SpawnArmor, FightStyle, Accent, Cookies, Phone, Crimes, Arrested");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: WantedLevel, Materials, Weed, Crack, Heroin, Painkillers, Cigars, PrivateRadio");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Channel, Spraycans, Boombox, Phonebook, Paycheck, CarLicense, Seeds, Chems");
		SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: InventoryUpgrade, AddictUpgrade, TraderUpgrade, AssetUpgrade, LaborUpgrade");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Notoriety, MP3Player, Job, MuriaticAcid, BakingSoda, Watch, GPS, GasCan, Condom");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: DMWarnings, WeaponRestricted, FishingSkill, ArmsDealerSkill, FarmerSkill");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: MechanicSkill, LawyerSkill, DetectiveSkill, SmugglerSkill, DrugDealerSkill");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: ForkliftSkill, CarjackerSkill, PizzaSkill, TruckerSkill, HookerSkill, RobberySkill");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Bombs, FirstAid, PoliceScanner, Bodykits, Rimkits, Diamonds, Marriage, Skates, RankPoints");
	    return 1;
	}

	if(!strcmp(option, "rankpoints", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [rankpoints] [value]");
		}
		if(value < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0.");
		}

        ResetPlayerRankPoints(targetid);
        GivePlayerRankPoints(targetid, value);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's rank points to %i.", GetRPName(targetid), value);
    }
	if(!strcmp(option, "gender", true))
	{
	    if(isnull(param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gender] [male | female | shemale]");
		}
		if(!strcmp(param, "male", true))
		{
		    PlayerData[targetid][pGender] = 1;
		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gender to Male.", GetRPName(targetid));

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gender = 1 WHERE uid = %i", PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "female", true))
		{
		    PlayerData[targetid][pGender] = 2;
		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gender to Female.", GetRPName(targetid));

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gender = 2 WHERE uid = %i", PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "shemale", true))
		{
		    PlayerData[targetid][pGender] = 3;
		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gender to Shemale.", GetRPName(targetid));

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gender = 3 WHERE uid = %i", PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
	}
	else if(!strcmp(option, "condom", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [condom] [value]");
		}
		if(!(0 <= value <= 128))
		{
		    return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 128.");
		}
		PlayerData[playerid][pCondom] = value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET condom = %i WHERE uid = %i", PlayerData[playerid][pCondom], PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's condom number to %i.", GetRPName(targetid), value);
	}
	else if(!strcmp(option, "notoriety", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [notoriety] [value]");
		}
		if(!(0 <= value <= 20000))
		{
		    return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 20,000.");
		}
		PlayerData[playerid][pNotoriety] = value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET notoriety = %i WHERE uid = %i", PlayerData[playerid][pNotoriety], PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's notoriety to %i.", GetRPName(targetid), value);
	}
	else if(!strcmp(option, "age", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [age] [value]");
		}
		if(!(0 <= value <= 128))
		{
		    return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 128.");
		}

		PlayerData[targetid][pAge] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's age to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET age = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "cash", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cash] [value]");
		}

		PlayerData[targetid][pCash] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cash to $%i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cash = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "bank", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bank] [value]");
		}

		PlayerData[targetid][pBank] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's bank money to $%i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "level", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [level] [value]");
		}

		PlayerData[targetid][pLevel] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's level to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET level = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "respect", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [respect] [value]");
		}

		PlayerData[targetid][pEXP] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's respect points to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET exp = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "upgradepoints", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [upgradepoints] [value]");
		}

		PlayerData[targetid][pUpgradePoints] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's upgrade points to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET upgradepoints = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "hours", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [hours] [value]");
		}

		PlayerData[targetid][pHours] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's playing hours to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET hours = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "warnings", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [warnings] [value]");
		}
		if(!(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 3.");
		}

		PlayerData[targetid][pWarnings] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's warnings to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET warnings = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spawnhealth", true))
	{
	    new Float:amount;

	    if(sscanf(param, "f", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [spawnhealth] [value]");
		}

		PlayerData[targetid][pSpawnHealth] = amount;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's spawn health to %.1f.", GetRPName(targetid), amount);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spawnhealth = '%f' WHERE uid = %i", amount, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spawnarmor", true))
	{
	    new Float:amount;

	    if(sscanf(param, "f", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [spawnarmor] [value]");
		}

		PlayerData[targetid][pSpawnArmor] = amount;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's spawn armor to %.1f.", GetRPName(targetid), amount);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spawnarmor = '%f' WHERE uid = %i", amount, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "fightstyle", true))
	{
	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [fightstyle] [option]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Normal, Boxing, Kungfu, Kneehead, Grabkick, Elbow");
	        return 1;
		}
		if(!strcmp(param, "normal", true))
		{
		    PlayerData[targetid][pFightStyle] = FIGHT_STYLE_NORMAL;

		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Normal.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "boxing", true))
		{
		    PlayerData[targetid][pFightStyle] = FIGHT_STYLE_BOXING;

		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Boxing.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "kungfu", true))
		{
		    PlayerData[targetid][pFightStyle] = FIGHT_STYLE_KUNGFU;

		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Kung Fu.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "kneehead", true))
		{
		    PlayerData[targetid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;

		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Kneehead.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "grabkick", true))
		{
		    PlayerData[targetid][pFightStyle] = FIGHT_STYLE_GRABKICK;

		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Grabkick.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else if(!strcmp(param, "elbow", true))
		{
		    PlayerData[targetid][pFightStyle] = FIGHT_STYLE_ELBOW;

		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Elbow.", GetRPName(targetid));
		    SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
	}
    else if(!strcmp(option, "accent", true))
	{
	    new accent[16];

	    if(sscanf(param, "s[16]", accent))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [accent] [text]");
		}

		strcpy(PlayerData[targetid][pAccent], accent, 16);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's accent to '%s'.", GetRPName(targetid), accent);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET accent = '%e' WHERE uid = %i", accent, PlayerData[targetid][pID]);
  		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "cookies", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cookies] [value]");
		}

        SetPlayerCookies(playerid, value);
		
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cookies to %i.", GetRPName(targetid), value);
	}
	else if(!strcmp(option, "phone", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [phone] [number]");
		}
		if(value == 911)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
		}

		if(value == 0)
		{
		    PlayerData[targetid][pPhone] = 0;
		    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's phone number to 0.", GetRPName(targetid));

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET phone = 0 WHERE uid = %i", PlayerData[targetid][pID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		else
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE phone = %i", value);
			mysql_tquery(connectionID, queryBuffer, "OnAdminSetPhoneNumber", "iii", playerid, targetid, value);
			return 1;
		}
	}
	else if(!strcmp(option, "crimes", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [crimes] [value]");
		}

		PlayerData[targetid][pCrimes] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's commited crimes to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET crimes = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "arrested", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [arrested] [value]");
		}

		PlayerData[targetid][pArrested] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's arrested count to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET arrested = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "wantedlevel", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [wantedlevel] [value]");
		}
		if(!(0 <= value <= 6))
		{
		    return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 6.");
		}

		PlayerData[targetid][pWantedLevel] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's wanted level to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [materials] [value]");
		}

		PlayerData[targetid][pMaterials] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's materials to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "weed", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [weed] [value]");
		}

		PlayerData[targetid][pWeed] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's weed to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [crack] [value]");
		}

		PlayerData[targetid][pCocaine] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's crack to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "heroin", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [heroin] [value]");
		}

		PlayerData[targetid][pHeroin] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's Heroin to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [painkillers] [value]");
		}

		PlayerData[targetid][pPainkillers] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's painkillers to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
 	else if(!strcmp(option, "cigars", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cigars] [value]");
		}

		PlayerData[targetid][pCigars] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cigars to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "privateradio", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [privateradio] [0/1]");
		}

		PlayerData[targetid][pPrivateRadio] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's private radio to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET walkietalkie = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "channel", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [channel] [value]");
		}

		PlayerData[targetid][pChannel] = value;
		CallRemoteFunction("OnRadioFrequencyChange", "ii", targetid, PlayerData[targetid][pChannel] );
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's radio channel to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET channel = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spraycans", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [spraycans] [value]");
		}

		PlayerData[targetid][pSpraycans] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's spraycans to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "boombox", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [boombox] [0/1]");
		}

		if((value == 0) && PlayerData[targetid][pBoomboxPlaced])
		{
		    DestroyBoombox(targetid);
		}

		PlayerData[targetid][pBoombox] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's boombox to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET boombox = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "phonebook", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [phonebook] [0/1]");
		}

		PlayerData[targetid][pPhonebook] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's phonebook to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET phonebook = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "paycheck", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [paycheck] [value]");
		}

		PlayerData[targetid][pPaycheck] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's paycheck to $%i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET paycheck = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "carlicense", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [carlicense] [0/1]");
		}

		PlayerData[targetid][pCarLicense] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's car license to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET carlicense = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "seeds", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [seeds] [value]");
		}

		PlayerData[targetid][pSeeds] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's seeds to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "chems", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [ephedrine] [value]");
		}

		PlayerData[targetid][pEphedrine] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's chems to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "job", true))
	{
	    if(sscanf(param, "i", value))
	    {
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [job] [value (-1 = none)]");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (0) Pizzaman (1) Courier (2) Fisherman (3) Bodyguard (4) Arms Dealer (5) Mechanic (6) Miner");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (7) Sweeper (8) Taxi Driver (9) Drug Dealer (10) Lawyer (11) Detective (12) Thief (13) Garbage Man (14) Farmer");
			return 1;
		}
		if(!(-1 <= value <= 14))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid job.");
		}

		PlayerData[targetid][pJob] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's job to %s.", GetRPName(targetid), GetJobName(value));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET job = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "inventoryupgrade", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [inventoryupgrade] [value]");
		}
		if(!(0 <= value <= 5))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 5.");
		}

		PlayerData[targetid][pInventoryUpgrade] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's inventory upgrade to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET inventoryupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "addictupgrade", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [addictupgrade] [value]");
		}
		if(!(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 3.");
		}

		PlayerData[targetid][pAddictUpgrade] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's addict upgrade to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET addictupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "traderupgrade", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [traderupgrade] [value]");
		}
		if(!(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 3.");
		}

		PlayerData[targetid][pTraderUpgrade] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's trader upgrade to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET traderupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "assetupgrade", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [assetupgrade] [value]");
		}
		if(!(0 <= value <= 4))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 4.");
		}

		PlayerData[targetid][pAssetUpgrade] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's asset upgrade to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET assetupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "laborupgrade", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [laborupgrade] [value]");
		}
		if(!(0 <= value <= 5))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 5.");
		}

		PlayerData[targetid][pLaborUpgrade] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's labor upgrade to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET laborupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "mp3player", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [mp3player] [0/1]");
		}

		PlayerData[targetid][pMP3Player] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's MP3 player to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET mp3player = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "muriaticacid", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [muriaticacid] [value]");
		}

		PlayerData[targetid][pMuriaticAcid] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's muriatic acid to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET muriaticacid = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "bakingsoda", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bakingsoda] [value]");
		}

		PlayerData[targetid][pBakingSoda] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's baking soda to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bakingsoda = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "dmwarnings", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [dmwarnings] [value]");
		}
		if(!(0 <= value <= 4))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 4.");
		}

		PlayerData[targetid][pDMWarnings] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's DM warnings to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET dmwarnings = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "weaponrestricted", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [weaponrestricted] [hours]");
		}

		PlayerData[targetid][pWeaponRestricted] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's weapon restriction to %i hours.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weaponrestricted = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "watch", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [watch] [0/1]");
		}

		PlayerData[targetid][pWatch] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's watch to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET watch = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "gps", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gps] [0/1]");
		}

		PlayerData[targetid][pGPS] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's GPS to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gps = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "gascan", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gascan] [value]");
		}

		PlayerData[targetid][pGasCan] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gas can to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "smugglerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [smugglerskill] [value]");
		}

		PlayerData[targetid][pSmugglerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's courier skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET smugglerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "fishingskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [fishingskill] [value]");
		}

		PlayerData[targetid][pFishingSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fishing skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fishingskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "armsdealerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [armsdealerskill] [value]");
		}

		PlayerData[targetid][pWeaponSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's weapon skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weaponskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(option, "mechanicskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [mechanicskill] [value]");
		}

		PlayerData[targetid][pMechanicSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's mechanic skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET mechanicskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "lawyerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [lawyerskill] [value]");
		}

		PlayerData[targetid][pLawyerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's lawyer skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET lawyerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "detectiveskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [detectiveskill] [value]");
		}

		PlayerData[targetid][pDetectiveSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's detective skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET detectiveskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "drugdealerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [drugdealerskill] [value]");
		}

		PlayerData[targetid][pDrugDealerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's drugdealer skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET drugdealerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "farmerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [farmerskill] [value]");
		}

		PlayerData[targetid][pFarmerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's farmer skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET farmerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "forkliftskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [forkliftskill] [value]");
		}

		PlayerData[targetid][pForkliftSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's forklift skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET forkliftskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "carjackerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [carjackerskill] [value]");
		}

		PlayerData[targetid][pCarJackerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's car jacker skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET carjackerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "craftskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [craftskill] [value]");
		}

		PlayerData[targetid][pCraftSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's craft skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET craftskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "pizzaskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [pizzaskill] [value]");
		}

		PlayerData[targetid][pPizzaSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's pizza skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET pizzaskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "truckerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [truckerskill] [value]");
		}

		PlayerData[targetid][pTruckerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's trucker skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET truckerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "hookerskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [hookerskill] [value]");
		}

		PlayerData[targetid][pHookerSkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's hooker skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET hookerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "robberyskill", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [robberyskill] [value]");
		}

		PlayerData[targetid][pRobberySkill] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's robbery skill to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET robberyskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "bombs", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bombs] [value]");
		}

		PlayerData[targetid][pBombs] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's bombs to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "firstaid", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [firstaid] [value]");
		}

		PlayerData[targetid][pFirstAid] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's first aid kits to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "policescanner", true))
	{
	    if(sscanf(param, "i", value) || !(0 <= value <= 1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [policescanner] [0/1]");
		}

		PlayerData[targetid][pPoliceScanner] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's police scanner to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET policescanner = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "bodykits", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bodykits] [value]");
		}

		PlayerData[targetid][pBodykits] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's bodykits to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "rimkits", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [rimkits] [value]");
		}

		PlayerData[targetid][pRimkits] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's rimkits to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rimkits = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "diamonds", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [diamonds] [value]");
		}

		PlayerData[targetid][pDiamonds] = value;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's diamonds to %i.", GetRPName(targetid), value);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "marriage", true))
	{
	    if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [marriedto] [playerid(-1 to reset)]");
		}

		if(IsPlayerConnected(value))
		{
			PlayerData[targetid][pMarriedTo] = PlayerData[value][pID];
			strcpy(PlayerData[targetid][pMarriedName], GetPlayerNameEx(value), MAX_PLAYER_NAME);
	    	SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's marriage to %s.", GetRPName(targetid), GetRPName(value));

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET marriedto = %i WHERE uid = %i", PlayerData[value][pID], PlayerData[targetid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
		else if(value == -1)
		{
			PlayerData[targetid][pMarriedTo] = -1;
			strcpy(PlayerData[targetid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
	    	SendClientMessageEx(playerid, COLOR_WHITE, "You have reset %s's marriage.", GetRPName(targetid));

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET marriedto = -1 WHERE uid = %i",  PlayerData[targetid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
	}
	else if(!strcmp(option, "skates", true))
	{
	    if(sscanf(param, "i", value) || !(0<=value<=1))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [skates] [1/0]");
		}
		else
		{
			PlayerData[targetid][pSkates] = value;
	    	SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's skates to %i.", GetRPName(targetid), value);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rollerskates = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
	}
	else
	{
	    return 1;
	}

	Log_Write("log_setstat", "%s (uid: %i) set %s's (uid: %i) %s to %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], option, param);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s set %s's %s to %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), option, param);
	return 1;
}

CMD:deleteaccount(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deleteaccount [username]");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. You can't delete their account.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminDeleteAccount", "is", playerid, username);
	return 1;
}

CMD:previewint(playerid, params[])
{
	new type, string[32];

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", type))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /previewint [1-%i]", sizeof(houseInteriors));
	}
	if(!(1 <= type <= sizeof(houseInteriors)))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}

	type--;

	format(string, sizeof(string), "~w~%s", houseInteriors[type][intClass]);
	GameTextForPlayer(playerid, string, 5000, 1);

	SetPlayerPos(playerid, houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ]);
	SetPlayerFacingAngle(playerid, houseInteriors[type][intA]);
	SetPlayerInterior(playerid, houseInteriors[type][intID]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:nearest(playerid, params[])
{
	new id;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Nearest Items _______");

	if((id = GetNearbyHouse(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of house ID %i.", id);
	}
	if((id = GetNearbyGarage(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of garage ID %i.", id);
	}
	if((id = GetNearbyBusiness(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of business ID %i.", id);
	}
	if((id = GetNearbyEntrance(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of entrance ID %i.", id);
	}
	if((id = GetNearbyLand(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of land ID %i.", id);
	}
	if((id = GetNearbyTurf(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of turf ID %i.", id);
	}
	if((id = GetNearbyLocker(playerid)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of locker ID %i.", id);
	}
	if((id = GetNearbyLocation(playerid, 20.0)) >= 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of (location) %s [%i].", LocationInfo[id][locName], id);
	}
	if((id = GetNearbyAtm(playerid)) >= 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of atm ID %i", id);
	}
	if((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID)
	{
		SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of vehicle ID %i", id);
	}
	if((id = GetNearbyGate(playerid)) >= 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of dynamic gate ID %i", id);
	}
	if((id = GetNearbyImpound(playerid)) >= 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of impound ID %i", id);
	}

	return 1;
}

CMD:dynamichelp(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	else if (isnull(params))
	{
		SendSyntaxMessage(playerid, "/dynamichelp (type)");
		SendClientMessage(playerid, COLOR_GREY, "Types: house, businesses, entrances, atms, lands, factions, gangs");
		SendClientMessage(playerid, COLOR_GREY, "Types: locations, points, turfs, fires, lockers, payphones, gangtags");
		return 1;
	}
	else if (!strcmp(params, "house", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "HOUSES:{DDDDDD} /createhouse, /edithouse, /removehouse, /gotohouse, /asellhouse, /removefurniture.");
	}
	else if (!strcmp(params, "garages", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "GARAGES:{DDDDDD} /creategarage, /editgarage, /removegarage, /gotogarage, /asellgarage.");
	}
    else if (!strcmp(params, "businesses", true))
    {
		SendClientMessage(playerid, COLOR_GREEN, "BUSINESSES:{DDDDDD} /createbiz, /editbiz, /removebiz, /gotobiz, /asellbiz.");
	}
	else if (!strcmp(params, "entrances", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "ENTRANCES:{DDDDDD} /createentrance, /editentrance, /removeentrance, /gotoentrance.");
	}
	else if (!strcmp(params, "lands", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "LANDS:{DDDDDD} /createland, /landcancel, /removeland, /gotoland, /asellland, /removelandobjects.");
    }
	else if (!strcmp(params, "factions", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "FACTIONS:{DDDDDD} /createfaction, /editfaction, /removefaction, /switchfaction, /purgefaction.");
    }
	else if (!strcmp(params, "gangs", true))
	{
	    SendClientMessage(playerid, COLOR_GREEN, "GANGS:{DDDDDD} /creategang, /editgang, /removegang, /gangstrike, /switchgang, /turfscaplimit, /setcooldown.");
	    SendClientMessage(playerid, COLOR_GREEN, "GANGS:{DDDDDD} /purgegang, /createganghq, /removeganghq.");
    }
	else if (!strcmp(params, "points", true))
	{
	    SendClientMessage(playerid, COLOR_GREEN, "POINTS:{DDDDDD} /createpoint, /editpoint, /removepoint, /gotopoint.");
    }
	else if (!strcmp(params, "turfs", true))
	{
	    SendClientMessage(playerid, COLOR_GREEN, "TURFS:{DDDDDD} /createturf, /turfcancel, /editturf, /removeturf, /gototurf.");
    }
	else if (!strcmp(params, "fires", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "FIRES:{DDDDDD} /randomfire, /killfire, /spawnfire.");
    }
	else if (!strcmp(params, "lockers", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "LOCKERS:{DDDDDD} /createlocker, /editlocker, /removelocker.");
    }
	else if (!strcmp(params, "locations", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "LOCATIONS:{DDDDDD} /createlocation, /editlocation, /removelocation.");
    }
	else if (!strcmp(params, "atms", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "ATMS:{DDDDDD} /createatm, /gotoatm, /editatm, /deleteatm.");
    }
	else if (!strcmp(params, "gangtags", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "Gang Tags:{DDDDDD} /creategangtag, /destroygangtag");
    }
	else if (!strcmp(params, "payphones", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "Payphones:{FFFFFF} /addpayphone, /gotopayphone, /editpayphone, /deletepayphone.");
    }
	return 1;
}


CMD:healnear(playerid, params[])
{
    if(IsAdmin(playerid, 3))
    {
        if(!IsAdminOnDuty(playerid) && !IsAdmin(playerid, 7))
        {
            return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
        }

        new count;
        foreach(new i : Player) 
        {
	        if(IsPlayerNearPlayer(playerid, i, 12.0))
            {
                SetPlayerHealth(i, 100);
                SetScriptArmour(i, 100);
                count++;
            }
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "You have healed everyone (%d) nearby.", count);
    }
    return 1;
}

CMD:serialnumber(playerid, params[])
{
    if(!IsAdmin(playerid, 2))
    {
		return 0;
	}
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /serialnumber [targetid]");
	}
	if(!IsPlayerConnected(targetid))
	{
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
	}
	new serialnumber[32];
	serialnumber = GetPlayerSerialNumber(targetid);

	if(isnull(serialnumber))
	{
		return SendClientMessage(playerid, COLOR_GREY, "Cannot get serial number.");
	}
	
	SendClientMessageEx(playerid, COLOR_ORANGE, "The serial number of %s is '%s'", GetPlayerNameEx(targetid), serialnumber);
	return 1;
}

GetPlayerSerialNumber(playerid)
{
	new serialnumber[32];
	if(strlen(PlayerData[playerid][pRegDate]) > 18)
	{
		serialnumber[0] = PlayerData[playerid][pRegDate][0];
		serialnumber[1] = PlayerData[playerid][pRegDate][1];
		serialnumber[2] = PlayerData[playerid][pRegDate][2];
		serialnumber[3] = PlayerData[playerid][pRegDate][3];
		serialnumber[4] = PlayerData[playerid][pRegDate][5];
		serialnumber[5] = PlayerData[playerid][pRegDate][6];
		serialnumber[6] = PlayerData[playerid][pRegDate][8];
		serialnumber[7] = PlayerData[playerid][pRegDate][9];
		serialnumber[8] = PlayerData[playerid][pRegDate][11];
		serialnumber[9] = PlayerData[playerid][pRegDate][12];
		serialnumber[10] = PlayerData[playerid][pRegDate][14];
		serialnumber[11] = PlayerData[playerid][pRegDate][15];
		serialnumber[12] = PlayerData[playerid][pRegDate][17];
		serialnumber[13] = PlayerData[playerid][pRegDate][18];
		serialnumber[14] = 'X';
		serialnumber[15] = 0;
		format(serialnumber, sizeof(serialnumber), "%s%09d", serialnumber, PlayerData[playerid][pID]);
	}
	else
	{
		serialnumber[0] = 0;
	}
	return serialnumber;
}
