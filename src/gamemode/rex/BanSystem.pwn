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

/*forward OnAdminBanIP(playerid, userip[], reason[], duration);
public OnAdminBanIP(playerid, userip[], reason[], duration)
{
	if(cache_get_row_count(connectionID))
	{
	    SCM(playerid, COLOR_SYNTAX, "This IP address is already banned.");
	}
	else
	{
	    foreach(new i : Player)
	    {
	        if(!strcmp(GetPlayerIP(i), userip))
			{
				SM(i, COLOR_YELLOW, "** Your IP address has been banned by %s, reason: %s", GetRPName(playerid), reason);
				defer RexKickPlayer(playerid, true);
			}
		}

	    //mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO users_bans VALUES(null, 'n/a', '%s', '%s', NOW(), '%s', 0)", ip, GetPlayerNameEx(playerid), reason);
	    //mysql_tquery(connectionID, queryBuffer);

        new username[32];
        new userid = PlayerData[playerid][pID];
        new adminid = 0;
        new adminname[32];

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),"INSERT INTO users_bans (id, userid, username, userip, adminid, adminname, reason, date, duration) ""VALUES (NULL, %i, '%e', '%e', %i, '%e', '%e', NOW(), %i)",userid, username, userip, adminid, adminname, reason, duration);
        mysql_tquery(connectionID, queryBuffer);

	    SAM(COLOR_LIGHTRED, "AdmCmd: %s has banned IP '%s', reason: %s", GetRPName(playerid), userip, reason);
	    Log_Write("log_punishments", "%s (uid: %i) has banned IP: %s, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], userip, reason);
	}
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
}*/

AddIPBan(ip[])
{
    if (CheckIPBan(ip) == 0)
    {
        // Check for valid IP length
        if (strlen(ip) == 0 || strlen(ip) >= 16) return 0;

        // Open file safely
        new File:file = fopen(BANNED_IP_FILENAME, io_append);
        if (file)
        {
            new string[32]; // Increased buffer size
            format(string, sizeof(string), "%s\n", ip); // no leading newline
            fwrite(file, string);
            fclose(file);
            return 1;
        }
        else
        {
            printf("[ERROR] Failed to open file: %s", BANNED_IP_FILENAME);
        }
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

LoginKickBannedPlayer(playerid, msg[], adminmsg[])
{
    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }

    if (PlayerData[playerid][pKicked])
    {
        return 1;
    }

    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF8040} KICK REPORT",
        "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\n"\
        "You may appeal against this at our website.", "Ok", "", msg);

    foreach(new i: Player)
    {
        if (i != playerid && IsAdmin(i))
        {
            SendClientMessageEx(i, COLOR_LIGHTRED, adminmsg);
        }
    }

    PlayerData[playerid][pKicked] = true;
    PlayerData[playerid][pLogged] = 0;
    defer RexKickPlayer(playerid, false);
    return 1;
}

BanPlayerPermanent(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL)
{
    return BanPlayer(playerid, reason, staffid, visibility, PERMANENT_BAN_DURATION);
}

stock FormatBanDuration(duration)
{
    new str[32];
    if (duration == 0)
    {
        str = "Permanent ban";
    }
    else if (duration == 1)
    {
        str = "1 day";
    }
    else
    {
        format(str, sizeof(str), "%d days", duration);
    }
    return str;
}

forward PerformBan(userid, username[], userip[], adminid, adminname[], reason[], duration);
public PerformBan(userid, username[], userip[], adminid, adminname[], reason[], duration)
{
    if (cache_get_row_count(connectionID))
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users_bans SET date=now(), username = '%e', userip = '%e', adminid = %i,"\
           "adminname = '%e', reason = '%e', duration = %i WHERE id = %i",
           username, userip, adminid, adminname, reason, duration, cache_get_row_int(0, 0));
        mysql_tquery(connectionID, queryBuffer);
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO users_bans "\
            "(date, userid, username, userip, adminid, adminname, reason, duration) VALUES"\
            "(NOW(), %i, '%e', '%e', %i, '%e', '%e', %i)",
            userid, username, userip, adminid, adminname, reason, duration);
        mysql_tquery(connectionID, queryBuffer);
    }
}

BanPlayer(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL, duration=3)
{
    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }

    if (PlayerData[playerid][pKicked])
    {
        return 1;
    }

    if (IsAdmin(playerid) && IsAdminOnDuty(playerid,false))
    {
        callcmd::aduty(playerid, "");
    }

    new adminname[32];
    new adminid = 0;
    if (staffid == INVALID_PLAYER_ID || !IsPlayerConnected(staffid))
    {
        if (IsProductionServer() && PlayerData[playerid][pLogged] && IsAdmin(playerid, ASST_MANAGEMENT))
        {
            return 1;
        }
        format(adminname, sizeof(adminname), "Rex");
        IncreaseAnticheatBans();
    }
    else
    {
        adminid = PlayerData[staffid][pID];
        GetPlayerName(staffid, adminname, sizeof(adminname));

    }
    new username[32];
    new userip[32];
    new durationstr[32];
    GetPlayerName(playerid, username, sizeof(username));
    GetPlayerIp(playerid, userip, sizeof(userip));
    durationstr = FormatBanDuration(duration);

    /*mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM users_bans WHERE userip = '%s'", userip);
	mysql_tquery(connectionID, queryBuffer, "OnAdminBanIP", "iss", playerid, userip, reason);*/

    AddIPBan(userip);

    new string[512];
    format(string, sizeof(string),
        "\n{808080}Player name: {FFFFFF}%s\n"\
        "{808080}Player IP: {FFFFFF}%s\n"\
        "{808080}Ban reason: {FFFFFF}%s\n"\
        "{808080}Duration: {FFFFFF}%s\n"\
        "{808080}Banned by: {FFFFFF}%s",
        username,
        userip,
        reason,
        durationstr,
        adminname);
    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF0000} BAN REPORT",
        "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\n"\
        "You may appeal against this at our website.", "Ok", "", string);


    if (PlayerData[playerid][pLogged])
    {
        new userid = PlayerData[playerid][pID];

        LogPlayerPunishment(staffid, userid, userip,
            "BAN", "%s was banned by %s for %s. Reason: %s",
            username, adminname, durationstr, reason);
        
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM users_bans WHERE userid = %i", userid);
        mysql_tquery(connectionID, queryBuffer, "PerformBan", "ississi", userid, username, userip, adminid, adminname, reason, duration);
    }

    foreach(new i: Player)
    {
        if (i != playerid)
        {
            new player_ip[16];
            GetPlayerIp(i, player_ip, sizeof(player_ip));

            if (strcmp(player_ip, userip) == 0)
            {
                PlayerData[i][pKicked] = true;
                PlayerData[i][pLogged] = 0;
                format(string, sizeof(string),
                    "\n{808080}Player name: {FFFFFF}%s\n"\
                    "{808080}Player IP: {FFFFFF}%s\n"\
                    "{808080}Ban reason: {FFFFFF}Your IP was banned (related account: '%s')\n"\
                    "{808080}Duration: {FFFFFF}%s\n"\
                    "{808080}Banned by: {FFFFFF}Rex",
                    GetPlayerNameEx(i),
                    player_ip,
                    username,
                    durationstr);
                Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF0000} BAN REPORT",
                    "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\n"\
                    "You may appeal against this at our website.", "Ok", "", string);

                defer RexKickPlayer(i, false);
            }
            else if (visibility == BAN_VISIBILITY_ALL)
            {
                if (IsAdmin(i))
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED ,
                        "AdmCmd: %s (IP: %s) was banned by %s. Duration: %s, Reason: %s",
                        username, userip, adminname, durationstr, reason);
                }
                else
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED ,
                        "[REX] %s was banned by %s. Reason: %s",
                        username, adminname, reason);
                }
            }
            else if (IsAdmin(i) && visibility == BAN_VISIBILITY_ADMIN)
            {
                SendClientMessageEx(i, COLOR_LIGHTRED ,
                    "AdmCmd: %s (IP: %s) was banned silently by %s. Duration: %s, Reason: %s",
                    username, userip, adminname, durationstr, reason);
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

OfflineBan(userid, username[], userip[], reason[], staffid=INVALID_PLAYER_ID, duration = 3)
{
    new adminname[MAX_PLAYER_NAME];
    new adminid = 0;

    if (staffid == INVALID_PLAYER_ID || !IsPlayerConnected(staffid))
    {
        format(adminname, sizeof(adminname), "Rex");
    }
    else
    {
        adminid = PlayerData[staffid][pID];
        GetPlayerName(staffid, adminname, sizeof(adminname));
    }

    if (!isnull(username) && !isnull(userip))
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM users_bans WHERE userid = %i", userid);
        mysql_tquery(connectionID, queryBuffer, "PerformBan", "ississi", userid, username, userip, adminid, adminname, reason, duration);
    }
}

CMD:banip(playerid, params[])
{
    new ip[16], reason[128];

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN && !PlayerData[playerid][pBanAppealer])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

    if (sscanf(params, "s[16]S(N/A)[128]", ip, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /banip [ip address] [reason (optional)]");
    }

    if (!IsAnIP(ip))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid IP address.");
    }
    if (AddIPBan(params))
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has banned IP '%s'.", GetRPName(playerid), params);
    else
        SendClientMessage(playerid, COLOR_GREY, "This ip is already banned");
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

CMD:mapstealer(playerid, params[])
{
    new username[MAX_PLAYER_NAME], ip[16], reason[32];

    GetPlayerName(playerid, username, sizeof(username)); // Corrected function
    GetPlayerIp(playerid, ip, sizeof(ip));

    format(reason, sizeof(reason), "Map Stealing"); // Define the reason properly

    // Log the ban into the database
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
        "INSERT INTO users_bans (username, ip, reason, bannedby, date) VALUES ('%e', '%e', '%e', '%e', NOW())",
        username, ip, reason, "Server");
    mysql_tquery(connectionID, queryBuffer);

    // Notify admins
    SendAdminMessage(COLOR_LIGHTRED, "[BAN] %s has been permanently banned for Map Stealing.", GetRPName(playerid));

    // Permanent Ban and kick the player
    BanPlayerPermanent(playerid, "Map Stealing - Permanent Ban");
    return 1;
}

/*publish OnBanAttempt(username[], ip[], from[], reason[], duration)
{
	if(cache_get_row_count(connectionID))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users_bans SET reason = '%e' WHERE id = %i", reason, cache_get_row_int(0, 0));
		mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO users_bans VALUES(null, '%s', '%s', '%s', NOW(), '%e', %i)", username, ip, from, reason, duration);
		mysql_tquery(connectionID, queryBuffer);
	}
}*/

CMD:showbans(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 6)
        return SendClientMessage(playerid, COLOR_GREY, "[!] You don't have permission to use this command.");

    new query[256];
    format(query, sizeof(query),
        "SELECT username, bannedby, reason, duration, userip FROM users_bans LIMIT 110");

    mysql_tquery(connectionID, query, "OnShowBans", "i", playerid);
    return 1;
}


forward OnShowBans(playerid);
public OnShowBans(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    if(rows == 0)
        return SendClientMessage(playerid, -1, "{FF0000}No players currently banned.");

    new ss[4096], line[256], username[32], bannedby[64], reason[128], duration[16], userip[24];
    ss[0] = '\0';

    for(new i = 0; i < rows; i++)
    {
        cache_get_field_content(i, "username", username);
        cache_get_field_content(i, "bannedby", bannedby);
        cache_get_field_content(i, "reason", reason);
        cache_get_field_content(i, "duration", duration);
        cache_get_field_content(i, "userip", userip);

        format(line, sizeof(line),
            "%s | IP: %s | Banned by: %s | Reason: %s | Duration: %s\n",
            username, userip, bannedby, reason, duration);

        strcat(ss, line);
    }

    ShowPlayerDialog(playerid, 110, DIALOG_STYLE_LIST,
        "{00FFFF}Showing Currently Banned Players",
        ss, "Select", "Close");

    return 1;
}
