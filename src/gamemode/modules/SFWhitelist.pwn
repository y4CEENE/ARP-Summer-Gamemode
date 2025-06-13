/// @file      SFWhitelist.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-06-19 11:26:57 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define SFWHITELIST_MIN_LEVEL 17
static SFWhiteList[MAX_PLAYERS];
static SFW_PlayerHP[MAX_PLAYERS];
static SFW_NOPCheck[MAX_PLAYERS];
static SFWhiteListEnabled = false; // To enable SF whitelist change it to true
static WhiteListEnabled   = false; // To disable whitelist change it to false

hook OnPlayerConnect(playerid)
{
    SFWhiteList[playerid]  = 0;
    SFW_PlayerHP[playerid] = -1;
    SFW_NOPCheck[playerid] = 0;
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    SFWhiteList[playerid] = GetDBIntField(row, "sfwhitelist");
    return 1;
}

IsWhiteListEnabled()
{
    return WhiteListEnabled;
}

IsSFWhitelisted(playerid)
{
    return PlayerData[playerid][pLevel] >= SFWHITELIST_MIN_LEVEL && SFWhiteList[playerid];
}

hook OnPlayerHeartBeat(playerid)
{
    if (!SFWhiteListEnabled || IsSFWhitelisted(playerid))
    {
        return 1;
    }

    if (!IsPlayerInRangeOfPoint(playerid, 1800.0, -2208.5339, 207.5916, 34.7299)) // SF Center
    {
        return 1;
    }

    if (GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0)
    {
        return 1;
    }

    if (IsAdmin(playerid))
    {
        return 1;
    }


    SendClientMessageEx(playerid, COLOR_RED, "[Area level %i+] You entered a danger zone. You must leave this area or you will die!", SFWHITELIST_MIN_LEVEL);

    if (SFW_PlayerHP[playerid] == -1)
    {
        SFW_PlayerHP[playerid] = GetPlayerHealthEx(playerid);
        SFW_NOPCheck[playerid]++;
        if (SFW_NOPCheck[playerid] > 10)
        {
            SendAdminWarning(2, "%s[%i] is probably accessing SF without whitelist.", GetRPName(playerid), playerid);
        }
    }

    SFW_PlayerHP[playerid] -= 25;

    if (SFW_PlayerHP[playerid] <= 0)
    {
        SFW_PlayerHP[playerid] = -1;
        SetPlayerHealth(playerid, 0);
    }
    else
    {
        SetPlayerHealth(playerid, SFW_PlayerHP[playerid]);
    }
    return 1;
}

CMD:sfwhitelist(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }

    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

    new targetid, value;
    if (sscanf(params, "ui", targetid, value))
    {
        return SendSyntaxMessage(playerid, " /sfwhitelist [playerid] [0/1]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Player id.");
    }

    if (value!=0)
    {
        SendAdminWarning(2, "AdmCmd: %s[%i] has added %s[%i] to sf whitelist.", GetRPName(playerid), playerid, GetRPName(targetid), targetid);

        SFWhiteList[targetid] = 1;
    }
    else
    {
        SendAdminWarning(2, "AdmCmd: %s[%i] has removed %s[%i] from sf whitelist.", GetRPName(playerid), playerid, GetRPName(targetid), targetid);

        SFWhiteList[targetid] = 0;
    }

    DBQuery("UPDATE "#TABLE_USERS" SET sfwhitelist=%i WHERE uid = %i", SFWhiteList[targetid], PlayerData[targetid][pID]);


    return 1;
}

CMD:whitelist(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        if (PlayerData[playerid][pWhitelist])
            return SendClientMessage(playerid,COLOR_GREEN, "You're whitelisted.");
        else
            return SendClientMessage(playerid,COLOR_RED, "You're not whitelisted.");
    }

    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

    new serialnumber[32], value;
    if (sscanf(params, "s[32]I(-1)", serialnumber, value))
    {
        return SendSyntaxMessage(playerid, " /whitelist [serial_number/username] [0/1]");
    }

    new targetuid = strval(serialnumber);
    if (targetuid == 0)
    {
        new idx = strfind(serialnumber, "x");
        if (idx == -1)
            idx = strfind(serialnumber, "X");
        if (idx == -1)
        {

            if (value == -1)
            {
                DBFormat("SELECT uid, username, whitelist, adminlevel FROM users WHERE username = '%e'", serialnumber);
                DBExecute("OnCheckWhitelist", "ii", playerid, targetuid);
            }
            else
            {
                DBFormat("SELECT uid, username, whitelist, adminlevel FROM users WHERE username = '%e'", serialnumber);
                DBExecute("OnPlayerWhitelist", "ii", playerid, value != 0);
            }
            return 1;
        }
        new uidstr[32];
        strmid(uidstr, serialnumber, idx + 1, strlen(serialnumber), 32);
        targetuid = strval(uidstr);
    }
    if (targetuid == 0)
    {
        return SendSyntaxMessage(playerid, " /whitelist [serial_number/username] [0/1]");
    }

    if (value == -1)
    {
        DBFormat("SELECT uid, username, whitelist, adminlevel FROM users WHERE uid = %i", targetuid);
        DBExecute("OnCheckWhitelist", "ii", playerid, targetuid);
    }
    else
    {
        DBFormat("SELECT uid, username, whitelist, adminlevel FROM users WHERE uid = %i", targetuid);
        DBExecute("OnPlayerWhitelist", "ii", playerid, value != 0);
    }

    return 1;
}

DB:OnCheckWhitelist(playerid)
{
    new rows = GetDBNumRows();
    if (rows != 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Account not found.");
    }
    new username[32];
    GetDBStringField(0, "username", username, 32);

    if (GetDBIntField(0, "whitelist") != 0)
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "%s is whitelisted", username);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_RED, "%s is not whitelisted", username);
    }
    return 1;
}

DB:OnPlayerWhitelist(playerid, whitelist)
{
    new rows = GetDBNumRows();
    if (rows != 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Account not found.");
    }
    new targetuid = GetDBIntField(0, "uid");
    if (IsUIDGodAdmin(targetuid) || !IsAdmin(playerid, GetDBIntField(0, "adminlevel") + 1))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to do that.");
    }
    new isAlreadyWhitelisted = GetDBIntField(0, "whitelist") != 0;
    if (isAlreadyWhitelisted == whitelist)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Nothing todo.");
    }
    new username[32];
    GetDBStringField(0, "username", username, 32);

    if (whitelist)
    {
        SendAdminWarning(2, "AdmCmd: %s[%i] has added %s to whitelist.", GetRPName(playerid), playerid, username);
    }
    else
    {
        SendAdminWarning(2, "AdmCmd: %s[%i] has removed %s from whitelist. A player relog is required.", GetRPName(playerid), playerid, username);
    }
    DBQuery("UPDATE "#TABLE_USERS" SET whitelist=%i WHERE uid = %i", whitelist, targetuid);
    return 1;
}
