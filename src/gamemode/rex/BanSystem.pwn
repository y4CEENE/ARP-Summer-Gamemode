#include <YSI\y_hooks>

//TODO: GetPlayerIP(playerid), GetPlayerIPRange(playerid)

static Node:BannedIPs;

#define BANNED_IP_FILENAME "data/BannedIP.json"
#define PERMANENT_BAN_DURATION 0
#define BAN_VISIBILITY_NONE  0
#define BAN_VISIBILITY_ADMIN 1
#define BAN_VISIBILITY_ALL   2

hook OnGameModeInit()
{
    JSON_ParseFile(BANNED_IP_FILENAME, BannedIPs);
    return 1;
}

hook OnPlayerInit(playerid)
{
    PlayerData[playerid][pKicked] = false;
    return 1;
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

bool:CheckIPBan(ip[])
{
    new len;
    new Node:item;
    new currentIp[24];
    JSON_ArrayLength(BannedIPs, len);
    for (new i = 0; i < len; i++)
    {
        if (!JSON_ArrayObject(BannedIPs, i, item) && !JSON_GetNodeString(item, currentIp) && !strcmp(ip, currentIp))
        {
            return true;
        }
    }
    return false;
}

bool:AddIPBan(ip[])
{
    if (!CheckIPBan(ip))
    {
        BannedIPs = JSON_Append(BannedIPs, JSON_Array(JSON_String(ip)));
        JSON_SaveFile(BANNED_IP_FILENAME, BannedIPs);
        return true;
    }
    return false;
}

bool:RemoveIPBan(ip[])
{
    new string[128];
    format(string, sizeof(string), "unbanip %s", ip);
    SendRconCommand(string);
    SendRconCommand("reloadbans");

    new len;
    new Node:item;
    new currentIp[24];
    JSON_ArrayLength(BannedIPs, len);
    for (new i = 0; i < len; i++)
    {
        if (!JSON_ArrayObject(BannedIPs, i, item) && !JSON_GetNodeString(item, currentIp) && !strcmp(ip, currentIp))
        {
            JSON_RemoveIndex(BannedIPs, i);
            JSON_SaveFile(BANNED_IP_FILENAME, BannedIPs);
            return true;
        }
    }
    return false;
}

KickPlayer(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL)
{
    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }
    if (PlayerData[playerid][pKicked])
    {
        return 1;
    }
    new adminname[MAX_PLAYER_NAME];
    if (staffid == INVALID_PLAYER_ID || !IsPlayerConnected(staffid))
    {
        format(adminname, sizeof(adminname), "Rex");
    }
    else
    {
        GetPlayerName(staffid, adminname, sizeof(adminname));
    }

    new username[MAX_PLAYER_NAME];
    new userip[16];
    GetPlayerName(playerid, username, sizeof(username));
    GetPlayerIp(playerid, userip, sizeof(userip));

    new string[512];
    format(string, sizeof(string),
        "\n{808080}Player name: {FFFFFF}%s"\
        "\n{808080}Kick reason: {FFFFFF}%s"\
        "\n{808080}Kicked by: {FFFFFF}%s",
        GetPlayerNameEx(playerid),
        reason,
        adminname);

    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FF8040} KICK REPORT",
        "%s\n\nIt's strongly recommended that you keep this report for future reference (Press F8).\n"\
        "You may appeal against this at our website.", "Ok", "", string);

    if (PlayerData[playerid][pLogged])
    {
        LogPlayerPunishment(staffid, PlayerData[playerid][pID], userip,
            "KICK", "%s was kicked by %s. Reason: %s",
            username, adminname, reason);
    }

    foreach(new i: Player)
    {
        if (i != playerid)
        {
            if (visibility == BAN_VISIBILITY_ALL)
            {
                if (IsAdmin(i))
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED,
                        "AdmCmd: %s (IP: %s) was kicked by %s. Reason: %s",
                        username, userip, adminname, reason);
                }
                else
                {
                    SendClientMessageEx(i, COLOR_LIGHTRED,
                        "[REX] %s was kicked by %s. Reason: %s",
                        username, adminname, reason);
                }
            }
            else if (IsAdmin(i) && visibility == BAN_VISIBILITY_ADMIN)
            {
                SendClientMessageEx(i, COLOR_LIGHTRED,
                    "AdmCmd: %s (IP: %s) was kicked silently by %s. Reason: %s",
                    username, userip, adminname, reason);
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
    if (PlayerData[playerid][pKicked])
    {
        Kick(playerid);
        if (blockip)
        {
            new banned_ip[32];
            GetPlayerIp(playerid, banned_ip, sizeof(banned_ip));
        }
    }
    return 1;
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
        if (IsProductionServer() && PlayerData[playerid][pLogged] && IsAdmin(playerid, ADMIN_LVL_9))
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

        DBFormat("SELECT id FROM "#TABLE_BANS" WHERE userid = %i", userid);
        DBExecute("PerformBan", "ississi", userid, username, userip, adminid, adminname, reason, duration);
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

BanPlayerPermanent(playerid, reason[], staffid=INVALID_PLAYER_ID, visibility=BAN_VISIBILITY_ALL)
{
    return BanPlayer(playerid, reason, staffid, visibility, PERMANENT_BAN_DURATION);
}

OfflineBanPlayer(userid, username[], userip[], reason[], staffid=INVALID_PLAYER_ID, duration = 3)
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
        DBFormat("SELECT id FROM "#TABLE_BANS" WHERE userid = %i", userid);
        DBExecute("PerformBan", "ississi", userid, username, userip, adminid, adminname, reason, duration);
    }
}

DB:PerformBan(userid, username[], userip[], adminid, adminname[], reason[], duration)
{
    if (GetDBNumRows())
    {
        DBQuery("UPDATE "#TABLE_BANS" SET date=now(), username = '%e', userip = '%e', adminid = %i,"\
           "adminname = '%e', reason = '%e', duration = %i WHERE id = %i",
           username, userip, adminid, adminname, reason, duration, GetDBIntFieldFromIndex(0, 0));
    }
    else
    {
        DBQuery("INSERT INTO "#TABLE_BANS" "\
            "(date, userid, username, userip, adminid, adminname, reason, duration) VALUES"\
            "(now(), %i, '%e', '%e', %i, '%e', '%e', %i)",
            userid, username, userip, adminid, adminname, reason, duration);
    }
}

CMD:banip(playerid, params[])
{
    new ip[16], reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_5) && !PlayerData[playerid][pBanAppealer])
    {
        return SendUnauthorized(playerid);
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
    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pBanAppealer])
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAnIP(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unbanip [ip address]");
    }
    if (RemoveIPBan(params))
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has unbanned IP '%s'.", GetRPName(playerid), params);
    else
        SendClientMessage(playerid, COLOR_SYNTAX, "This ip is not banned");
    return 1;
}


public OnRconLoginAttempt(ip[], password[], success)
{
    // This callback is only called when the player is not yet logged in.
    // When the player is logged in, OnRconCommand is called instead.
    foreach(new i : Player)
    {
        if (!strcmp(GetPlayerIP(i), ip))
        {
            if (PlayerData[i][pLogged] && IsGodAdmin(i))
            {
                return 1;
            }
            else if (PlayerData[i][pLogged])
            {
                BanPlayer(i, "Unauthorized RCON login", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
            }
            else
            {
                KickPlayer(i, "Unauthorized RCON login", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
            }
        }
    }
    return 1;
}

stock UnbanPlayer(playerid, username[])
{
    DBFormat("SELECT * FROM "#TABLE_BANS" WHERE username = '%e'", username);
    DBExecute("UnbanPlayer", "is", playerid, username);
}

DB:UnbanPlayer(playerid, username[])
{
    if (GetDBNumRows())
    {
        new userid   = GetDBIntField(0, "userid");
        new duration = GetDBIntField(0, "duration");
        new isbanned = GetDBIntField(0, "isbanned");
        new userip[16];
        GetDBStringField(0, "userip", userip);

        if (duration == PERMANENT_BAN_DURATION && !IsAdmin(playerid, ADMIN_LVL_8))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This player is permanently banned. Permabans may only be lifted by management.");
        }
        DBQuery("DELETE FROM "#TABLE_BANS" WHERE userid = %i", userid);

        if (!isbanned)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This player is not banned. Cleaning ban cache.");
        }
        RemoveIPBan(userip);
        LogPlayerPunishment(playerid, userid, userip,
            "UNBAN", "%s was unbanned by %s %s.",
            username, GetAdminRank(playerid), GetRPName(playerid));

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has unbanned %s.",GetAdmCmdRank(playerid), GetRPName(playerid), username);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "There is no banned player known by that name.");
    }

    return 1;
}

CMD:baninfo(playerid, params[])
{
    new username[MAX_PLAYER_NAME];

    if (!IsAdmin(playerid, ADMIN_LVL_4) && !PlayerData[playerid][pBanAppealer])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /baninfo [username/ip]");
    }

    DBFormat("SELECT * FROM "#TABLE_BANS" WHERE (username = '%e' OR userip = '%e') and (isbanned=true)", username, username);
    DBExecute("BanInfo", "is", playerid, username);
    return 1;
}

DB:BanInfo(playerid, name[])
{
    if (GetDBNumRows() == 0)
    {
        DBFormat("SELECT uid, username, ip FROM "#TABLE_USERS" WHERE (username = '%e' or ip='%e') LIMIT 1", name, name);
        DBExecute("BanInfoIPCheck", "is", playerid, name);
        return 1;
    }

    new adminname[MAX_PLAYER_NAME], username[MAX_PLAYER_NAME];
    new userip[16], date[24], end[24], reason[128], durationstr[32];
    new duration = GetDBIntField(0, "duration");
    new isbanned = GetDBIntField(0, "isbanned");
    new banstate[32], banipstate[32];
    new string[512];
    new title[128];

    GetDBStringField(0, "username", username);
    GetDBStringField(0, "userip", userip);
    GetDBStringField(0, "adminname", adminname);
    GetDBStringField(0, "reason", reason);
    GetDBStringField(0, "date", date);
    GetDBStringField(0, "end", end);
    durationstr = FormatBanDuration(duration);

    if (isbanned)
    {
        banstate = "{FF0000}Active{FFFFFF}";
    }
    else
    {
        banstate = "{00FF00}Inactive{FFFFFF}";
    }

    if (CheckIPBan(userip))
    {
        banipstate = "{FF0000}Active{FFFFFF}";
    }
    else
    {
        banipstate = "{00FF00}Inactive{FFFFFF}";
    }

    format(string, sizeof(string),
        "{808080}Player name: {FFFFFF}%s\t"\
        "{808080}Player IP: {FFFFFF}%s\n"\
        "{808080}Banned by: {FFFFFF}%s\t"\
        "{808080}Ban State: {FFFFFF}%s\t\t"\
        "{808080}BanIP State: {FFFFFF}%s\n"\
        "{808080}Duration: {FFFFFF}%s\t\t"\
        "{808080}Date: {FFFFFF}%s\t"\
        "{808080}End: {FFFFFF}%s\n"\
        "{808080}Ban reason: {FFFFFF}%s",
        username,
        userip,
        adminname,
        banstate,
        banipstate,
        durationstr,
        date,
        end,
        reason);

    format(title, sizeof(title), "{FF0000} BAN REPORT of '%s'", name);
    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, title, string, "Ok", "Cancel", string);
    return 1;
}

DB:BanInfoIPCheck(playerid, name[])
{
    new rows = GetDBNumRows();
    if (rows == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There are no bans that match your criteria.");
    }
    new userip[16], username[MAX_PLAYER_NAME];
    GetDBStringField(0, "ip", userip);

    if (CheckIPBan(userip))
    {
        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "username", username);
            SendClientMessageEx(playerid, COLOR_GREY, "[BanIPCheck] %s's IP %s is banned.", username, userip);
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "There are no bans that match your criteria.");
    }
    return 1;
}

CMD:oban(playerid, params[])
{
    new username[MAX_PLAYERS], duration, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]ds[128]", username, duration, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /oban [username] [duration in days] [reason]");
    }

    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /ban instead.");
    }

    if (duration <= 0 || duration >= 365 * 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid duration value.");
    }
    DBFormat("SELECT adminlevel, ip, uid FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OBanCheckPlayer", "isis", playerid, username, duration, reason);
    return 1;
}

DB:OBanCheckPlayer(playerid, username[], duration, reason[])
{
    if (GetDBNumRows() == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not registered.");
    }

    if (!IsAdmin(playerid, GetDBIntField(0, "adminlevel") + 1))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
    }

    new userid = GetDBIntField(0, "uid");
    new userip[16];
    GetDBStringField(0, "ip", userip);

    OfflineBanPlayer(userid, username, userip, reason, playerid, duration);

    LogPlayerPunishment(playerid, userid, userip,
        "BAN", "%s was offline banned by %s %s for %d days. Reason: %s",
        username, GetAdminRank(playerid), GetRPName(playerid), duration, reason);

    SendAdminMessage(COLOR_LIGHTRED,
        "AdmCmd: %s (IP: %s) was offline banned by %s %s. Reason: %s",
        username, userip, GetAdmCmdRank(playerid), GetPlayerNameEx(playerid), reason);
    return 1;
}

CMD:permaban(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /permaban [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
    }
    BanPlayerPermanent(targetid, reason, playerid);
    return 1;
}


CMD:unban(playerid, params[])
{
    new username[MAX_PLAYER_NAME];

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pBanAppealer])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unban [username]");
    }
    UnbanPlayer(playerid, username);
    return 1;
}

/*
CMD:banhistory(playerid, params[])
{
    new name[MAX_PLAYER_NAME];

    if (!IsAdmin(playerid, ADMIN_LVL_4) && !PlayerData[playerid][pBanAppealer] && !PlayerData[playerid][pHumanResources])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /banhistory [username]");
    }

    DBFormat("SELECT a.date, a.description FROM log_bans a, "#TABLE_USERS" b WHERE a.uid = b.uid AND b.username = '%e' ORDER BY a.date DESC", name);
    DBExecute("OnAdminCheckBanHistory", "is", playerid, name);

    return 1;
}

DB:OnAdminCheckBanHistory(playerid, username[])
{
    new rows = GetDBNumRows();

    if (rows == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player has no ban history recorded.");
    }
    new date[24], description[255];

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringFieldFromIndex(i, 0, date);
        GetDBStringFieldFromIndex(i, 1, description);

        SendClientMessageEx(playerid, COLOR_LIGHTRED, "[%s] %s", date, description);
    }
    return 1;
}*/
