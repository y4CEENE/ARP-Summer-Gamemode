#include <YSI\y_hooks>

#define BANNED_IP_FILENAME "Rex/BannedIP.cfg"
#define PERMANENT_BAN_DURATION 0
#define BAN_VISIBILITY_NONE  0
#define BAN_VISIBILITY_ADMIN 1
#define BAN_VISIBILITY_ALL   2

hook OnGameModeInit()
{
    if(!fexist(BANNED_IP_FILENAME))
    {
        fcreate(BANNED_IP_FILENAME);
    }
}
hook OnPlayerInit(playerid)
{
    PlayerData[playerid][pKicked] = false;
}

CheckIPBan(ip[])
{
    new string[20];
    new File: file = fopen(BANNED_IP_FILENAME, io_read);
    
    if(!file)
    {
        return 0;
    }

    while(fread(file, string))
    {
        if(strcmp(ip, string, true, strlen(ip)) == 0 && string[0]!=0)
        {
            fclose(file);
            return 1;
        }
    }
    fclose(file);
    return 0;
}

AddIPBan(ip[])
{
    if(CheckIPBan(ip) == 0)
    {
        new File: file = fopen(BANNED_IP_FILENAME, io_append);
        new string[20];
        format(string, sizeof(string), "\n%s", ip);
        fwrite(file, string);
        fclose(file);
        return 1;
    }
    return 0;
}

RemoveIPBan(ip[])
{
    new string[128];
    if(CheckIPBan(ip) == 1)
    {
        new File: file = fopen(BANNED_IP_FILENAME, io_read);
        if(!file)
        {
            return 0;
        }
        fcreate(BANNED_IP_FILENAME".tmp");
        new File: file2 = fopen(BANNED_IP_FILENAME".tmp", io_append);
        while(fread(file, string))
        {
            if(strcmp(ip, string, true, strlen(ip)) != 0 && strcmp("\n", string) != 0)
            {
                fwrite(file2, string);
            }
        }
        fclose(file);
        fclose(file2);
        file = fopen(BANNED_IP_FILENAME, io_write);
        file2 = fopen(BANNED_IP_FILENAME".tmp", io_read);
        if(!file2)
        {
            return 0;
        }
        while(fread(file2, string))
        {
            fwrite(file, string);
        }
        fclose(file);
        fclose(file2);
        fremove(BANNED_IP_FILENAME".tmp");
            
        return 1;
    }
    format(string, sizeof(string), "unbanip %s", ip);
    SendRconCommand(string);
    SendRconCommand("reloadbans");
    return 0;
}


BanPlayerPermanent(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL)
{
    return BanPlayer(playerid, reason, staffid, visibility, PERMANENT_BAN_DURATION);
}

BanPlayer(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL, duration=3)
{
    if(!IsPlayerConnected(playerid))
    {
        return 1;
    }
    
    if(PlayerData[playerid][pKicked])
    {
        return 1;
    }

    if(IsAdmin(playerid) && IsAdminOnDuty(playerid,false))
    {
        callcmd::aduty(playerid, "");
    }
    
    new staff_name[32];

    if(staffid == INVALID_PLAYER_ID || !IsPlayerConnected(staffid))
    {
        format(staff_name, sizeof(staff_name), "Rex");
        IncreaseAnticheatBans();
    }
    else
    {
        GetPlayerName(staffid, staff_name, sizeof(staff_name));

    }
    new username[32];
    new banned_ip[32];
    new durationstr[32];
    GetPlayerName(playerid, username, sizeof(username));
    GetPlayerIp(playerid, banned_ip, sizeof(banned_ip));
    AddIPBan(banned_ip);
    if(duration == 0)
    {
        durationstr = "Permanent ban";
    }
    else if(duration == 1)
    {
        durationstr = "1 day";
    }
    else
    {
        format(durationstr, sizeof(durationstr), "%d days", duration);
    }
    
    
    new string[512];
    format(string, sizeof(string), "\n{808080}Player name: {FFFFFF}%s\n{808080}Player IP: {FFFFFF}%s\n{808080}Ban reason: {FFFFFF}%s\n{808080}Duration: {FFFFFF}%s\n{808080}Banned by: {FFFFFF}%s",
                                   username,
                                   banned_ip,
                                   reason,
                                   durationstr,
                                   staff_name);
    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF0000} BAN REPORT", "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\nYou may appeal against this at our website.", "Ok", "", string);
    
    format(string, sizeof(string), "Player: %s, IP: %s, Reason: %s, Banned by: %s",
                                   username,
                                   banned_ip,
                                   reason,
                                   staff_name);

	Log_Write("log_punishments", string);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO log_bans VALUES(null, %i, NOW(), '%s')", PlayerData[playerid][pID], string);
    mysql_tquery(connectionID, queryBuffer);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM bans WHERE username = '%s' OR ip = '%s'", username, banned_ip);
    mysql_tquery(connectionID, queryBuffer, "OnBanAttempt", "ssssi", username, banned_ip, staff_name, reason, duration);
    
    foreach(new i: Player)
    {
        if(i != playerid)
        {
            new player_ip[32];
            GetPlayerIp(i, player_ip, sizeof(player_ip));

            if(strcmp(player_ip, banned_ip) == 0)
			{
                PlayerData[i][pKicked] = true;
                PlayerData[i][pLogged] = 0;
                format(string, sizeof(string), "\n{808080}Player name: {FFFFFF}%s\n{808080}Player IP: {FFFFFF}%s\n{808080}Ban reason: {FFFFFF}Your IP was banned (related account: '%s')\n{808080}Banned by: {FFFFFF}Rex", 
                                   GetPlayerNameEx(i),
                                   player_ip,
                                   username);
                Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF0000} BAN REPORT", "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\nYou may appeal against this at our website.", "Ok", "", string);

				defer RexKickPlayer(i, false);
			}
            else if(visibility == BAN_VISIBILITY_ALL)
            {
                if(IsAdmin(i))
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED , "AdmCmd: %s was banned by %s, reason: %s", username, staff_name, reason);
                }
                else
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED , "[REX] %s was banned by %s, reason: %s", username, staff_name, reason);
                }
            }
            else if(IsAdmin(i) && visibility == BAN_VISIBILITY_ADMIN)
            {
                SendClientMessageEx(i, COLOR_LIGHTRED , "AdmCmd: %s was banned silently by %s, reason: %s", username, staff_name, reason);
            }
        }
    }
    
    PlayerData[playerid][pKicked] = true;
    PlayerData[playerid][pLogged] = 0;
    defer RexKickPlayer(playerid, true);
    return 1;
}

KickPlayer(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL)
{
    if(!IsPlayerConnected(playerid))
    {
        return 1;
    }
    if(PlayerData[playerid][pKicked])
    {
        return 1;
    }
    new staff_name[32];

    if(staffid == INVALID_PLAYER_ID || !IsPlayerConnected(staffid))
    {
        format(staff_name, sizeof(staff_name), "Rex");
    }
    else
    {
        GetPlayerName(staffid, staff_name, sizeof(staff_name));
    }

    new string[512];
    format(string, sizeof(string), "\n{808080}Player name: {FFFFFF}%s\n{808080}Kick reason: {FFFFFF}%s\n{808080}Kicked by: {FFFFFF}%s",
                                   GetPlayerNameEx(playerid),
                                   reason,
                                   staff_name);
    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF8040} KICK REPORT", "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\nYou may appeal against this at our website.", "Ok", "", string);
    
    new banned_ip[32];
    GetPlayerIp(playerid, banned_ip, sizeof(banned_ip));
    format(string, sizeof(string), "Player: %s, IP: %s, Reason: %s, Kicked by: %s",
                                   GetPlayerNameEx(playerid),
                                   banned_ip,
                                   reason,
                                   staff_name);

    Log_Write("log_punishments", string);

    foreach(new i: Player)
    {
        if(i != playerid)
        {
            if(visibility == BAN_VISIBILITY_ALL)
            {
                if(IsAdmin(i))
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED , "AdmCmd: %s was kicked by %s, reason: %s", GetPlayerNameEx(playerid), staff_name, reason);
                }
                else
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED , "[REX] %s was kicked by %s, reason: %s", GetPlayerNameEx(playerid), staff_name, reason);
                }
            }
            else if(IsAdmin(i) && visibility == BAN_VISIBILITY_ADMIN)
            {
                SendClientMessageEx(i, COLOR_LIGHTRED , "AdmCmd: %s was kicked silently by %s, reason: %s", GetPlayerNameEx(playerid), staff_name, reason);
            }
        }
    }

    PlayerData[playerid][pKicked] = true;
    PlayerData[playerid][pLogged] = 0;
    defer RexKickPlayer(playerid, false);
    return 1;
}

timer RexKickPlayer[1000](playerid, blockip)
{
    if(PlayerData[playerid][pKicked])
    {
        Kick(playerid);
        if(blockip)
        {
            new banned_ip[32];
            GetPlayerIp(playerid, banned_ip, sizeof(banned_ip));
        }
    }
    return 1;
}


OfflineBan(username[], ip[], reason[], staffid=INVALID_PLAYER_ID, duration = 3)
{
    new staff_name[32];

    if(staffid == INVALID_PLAYER_ID || !IsPlayerConnected(staffid))
    {
        format(staff_name, sizeof(staff_name), "Rex");
    }
    else
    {
        GetPlayerName(staffid, staff_name, sizeof(staff_name));
    }

	if(!isnull(username) && !isnull(ip))
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM bans WHERE (username = '%e' OR ip = '%e') and ((date + interval duration day) > now() || duration = 0)", username, ip);
		mysql_tquery(connectionID, queryBuffer, "OnBanAttempt", "ssssi", username, ip, staff_name, reason, duration);
	}
}

CMD:banip(playerid, params[])
{
	new ip[16], reason[128];

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN && !PlayerData[playerid][pBanAppealer])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	
    if(sscanf(params, "s[16]S(N/A)[128]", ip, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /banip [ip address] [reason (optional)]");
	}

	if(!IsAnIP(ip))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid IP address.");
	}
    AddIPBan(params);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has banned IP '%s'.", GetRPName(playerid), params);

	return 1;
}


CMD:unbanip(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pBanAppealer])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAnIP(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unbanip [ip address]");
	}
    RemoveIPBan(params);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has unbanned IP '%s'.", GetRPName(playerid), params);
	return 1;
}


public OnRconLoginAttempt(ip[], password[], success)
{
	if(success)
	{
	    foreach(new i : Player)
	    {
	        if(!strcmp(GetPlayerIP(i), ip) && !IsGodAdmin(i))
	        {
                BanPlayer(i, "Unauthorized RCON login");
			}
		}
	}

	return 1;
}


publish OnBanAttempt(username[], ip[], from[], reason[], duration)
{
	if(cache_get_row_count(connectionID))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE bans SET reason = '%e' WHERE id = %i", reason, cache_get_row_int(0, 0));
		mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO bans VALUES(null, '%s', '%s', '%s', NOW(), '%e', %i)", username, ip, from, reason, duration);
		mysql_tquery(connectionID, queryBuffer);
	}
}