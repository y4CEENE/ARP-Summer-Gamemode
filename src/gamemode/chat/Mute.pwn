/// @file      Mute.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-03-13
/// @copyright Copyright (c) 2023

#include <YSI\y_hooks>

static UnMuteType[MAX_PLAYERS];
static AdMuted[MAX_PLAYERS];
static GlobalMuted[MAX_PLAYERS];
static HelpMuted[MAX_PLAYERS];
static LiveMuted[MAX_PLAYERS];
static NewbieMuted[MAX_PLAYERS];
static ReportMuted[MAX_PLAYERS];

static ReportWarns[MAX_PLAYERS];
static PlayerWarnings[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    AdMuted[playerid]        = 0;
    GlobalMuted[playerid]    = 0;
    LiveMuted[playerid]      = 0;
    NewbieMuted[playerid]    = 0;
    ReportMuted[playerid]    = 0;

    ReportWarns[playerid]    = 0;
    PlayerWarnings[playerid] = 0;
}

hook OnLoadPlayer(playerid, row)
{
    AdMuted[playerid]        = GetDBIntField(row, "admuted");
    GlobalMuted[playerid]    = GetDBIntField(row, "globalmuted");
    HelpMuted[playerid]      = GetDBIntField(row, "helpmuted");
    LiveMuted[playerid]      = GetDBIntField(row, "livemuted");
    NewbieMuted[playerid]    = GetDBIntField(row, "newbiemuted");
    ReportMuted[playerid]    = GetDBIntField(row, "reportmuted");

    ReportWarns[playerid]    = GetDBIntField(row, "reportwarns");
    PlayerWarnings[playerid] = GetDBIntField(row, "warnings");
}

stock IsAdMuted     (playerid) { return AdMuted[playerid]     == -1 || AdMuted[playerid]     > gettime(); }
stock IsGlobalMuted (playerid) { return GlobalMuted[playerid] == -1 || GlobalMuted[playerid] > gettime(); }
stock IsHelpMuted   (playerid) { return HelpMuted[playerid]   == -1 || HelpMuted[playerid]   > gettime(); }
stock IsLiveMuted   (playerid) { return LiveMuted[playerid]   == -1 || LiveMuted[playerid]   > gettime(); }
stock IsNewbieMuted (playerid) { return NewbieMuted[playerid] == -1 || NewbieMuted[playerid] > gettime(); }
stock IsReportMuted (playerid) { return ReportMuted[playerid] == -1 || ReportMuted[playerid] > gettime(); }

stock AdMutePlayer(playerid, minute = -1)
{
    AdMuted[playerid] = (minute == -1 || minute == 0) ? minute :  (gettime() + minute * 60);
    DBQuery("UPDATE "#TABLE_USERS" SET admuted = %i WHERE uid = %i", AdMuted[playerid], PlayerData[playerid][pID]);
}

stock GlobalMutePlayer(playerid, minute = -1)
{
    GlobalMuted[playerid] = (minute == -1 || minute == 0) ? minute :  (gettime() + minute * 60);
    DBQuery("UPDATE "#TABLE_USERS" SET globalmuted = %i WHERE uid = %i", GlobalMuted[playerid], PlayerData[playerid][pID]);
}

stock HelpMutePlayer(playerid, minute = -1)
{
    HelpMuted[playerid] = (minute == -1 || minute == 0) ? minute :  (gettime() + minute * 60);
    DBQuery("UPDATE "#TABLE_USERS" SET helpmuted = %i WHERE uid = %i", HelpMuted[playerid], PlayerData[playerid][pID]);
}

stock LiveMutePlayer(playerid, minute = -1)
{
    LiveMuted[playerid] = (minute == -1 || minute == 0) ? minute :  (gettime() + minute * 60);
    DBQuery("UPDATE "#TABLE_USERS" SET livemuted = %i WHERE uid = %i", LiveMuted[playerid], PlayerData[playerid][pID]);
}

stock NewbieMutePlayer(playerid, minute = -1)
{
    NewbieMuted[playerid] = (minute == -1 || minute == 0) ? minute :  (gettime() + minute * 60);
    DBQuery("UPDATE "#TABLE_USERS" SET newbiemuted = %i WHERE uid = %i", NewbieMuted[playerid], PlayerData[playerid][pID]);
}

stock ReportMutePlayer(playerid, minute = -1)
{
    ReportMuted[playerid] = (minute == -1 || minute == 0) ? minute :  (gettime() + minute * 60);
    ReportWarns[playerid] = minute == 0 ? 0 : ReportWarns[playerid];
    DBQuery("UPDATE "#TABLE_USERS" SET reportmuted = %i, reportwarns = %i WHERE uid = %i",
            ReportMuted[playerid], ReportWarns[playerid], PlayerData[playerid][pID]);
}

stock GetPlayerReportWarns(playerid)
{
    return ReportWarns[playerid];
}

stock SetPlayerReportWarns(playerid, value)
{
    ReportWarns[playerid] = value;
    DBQuery("UPDATE "#TABLE_USERS" SET reportwarns = %i WHERE uid = %i",
            ReportWarns[playerid], PlayerData[playerid][pID]);
}

stock GetPlayerWarnings(playerid)
{
    return PlayerWarnings[playerid];
}

stock SetPlayerWarnings(playerid, value)
{
    PlayerWarnings[playerid] = value;
    DBQuery("UPDATE "#TABLE_USERS" set warnings=%i where uid=%i", PlayerWarnings[playerid], PlayerData[playerid][pID]);
}

Dialog:UnmuteSelectPunishment(playerid, response, listitem, inputtext[])
{
    if (!response || listitem < 0 || listitem > 1)
        return 1;

    new action[24];

    switch (UnMuteType[playerid])
    {
        case 0: // Advertise
        {
            RCHECK(AdMuted[playerid], "You are not muted from the Advertise.");
            RCHECK(AdMuted[playerid] != -1, "You are permanent muted from the Advertise.");
            RCHECK(AdMuted[playerid] < gettime(),
                   "You need to wait at least %i minutes before requesting an unmute.",
                   (AdMuted[playerid] - gettime()) / 60);
            action = "Advertise unmute";
            AdMutePlayer(playerid, 0);
        }
        case 1: // Global chat
        {
            RCHECK(GlobalMuted[playerid],       "You are not muted from the Global chat.");
            RCHECK(GlobalMuted[playerid] != -1, "You are permanent muted from the Global chat.");
            RCHECK(GlobalMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (GlobalMuted[playerid] - gettime()) / 60);
            action = "Global chat unmute";
            GlobalMutePlayer(playerid, 0);
        }
        case 2: // Help
        {
            RCHECK(HelpMuted[playerid],       "You are not muted from the Help.");
            RCHECK(HelpMuted[playerid] != -1, "You are permanent muted from the Help.");
            RCHECK(HelpMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (HelpMuted[playerid] - gettime()) / 60);
            action = "Help unmute";
            HelpMutePlayer(playerid, 0);
        }
        case 3: // Live chat
        {
            RCHECK(LiveMuted[playerid],       "You are not muted from the Live chat.");
            RCHECK(LiveMuted[playerid] != -1, "You are permanent muted from the Live chat.");
            RCHECK(LiveMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (LiveMuted[playerid] - gettime()) / 60);
            action = "Live chat unmute";
            LiveMutePlayer(playerid, 0);
        }
        case 4: // Newbie chat
        {
            RCHECK(NewbieMuted[playerid],       "You are not muted from the Newbie chat.");
            RCHECK(NewbieMuted[playerid] != -1, "You are permanent muted from the Newbie chat.");
            RCHECK(NewbieMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (NewbieMuted[playerid] - gettime()) / 60);
            action = "Newbie chat unmute";
            NewbieMutePlayer(playerid, 0);
        }
        case 5: // Report
        {
            RCHECK(ReportMuted[playerid],       "You are not muted from the Report.");
            RCHECK(ReportMuted[playerid] != -1, "You are permanent muted from the Report.");
            RCHECK(ReportMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (ReportMuted[playerid] - gettime()) / 60);
            action = "Report unmute";
            ReportMutePlayer(playerid, 0);
        }
        default: return 1;
    }
    switch (listitem)
    {
        case 0:
        {
            new fine = percent(PlayerData[playerid][pCash] + PlayerData[playerid][pBank], 5);
            GivePlayerCash(playerid, -fine);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have chosen to pay a 5 percent fine of {FF6347}$%i{33CCFF} for %s.", fine, action);
        }
        case 1:
        {
            RCHECK(PlayerData[playerid][pJailTime] < 600,
                   "This punishment is not available to you as you are jailed for more than 10 minutes.");

            SetPlayerInJail(playerid, JailType_OOCJail, 10 * 60, action);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have chosen a 10 minute jail sentence for %s.", action);
        }
    }
    return 1;
}

Dialog:UnMute(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    UnMuteType[playerid] = listitem;

    switch (UnMuteType[playerid])
    {
        case 0: // Advertise
        {
            RCHECK(AdMuted[playerid],       "You are not muted from the Advertise.");
            RCHECK(AdMuted[playerid] != -1, "You are permanent muted from the Advertise.");
            RCHECK(AdMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (AdMuted[playerid] - gettime()) / 60);
        }
        case 1: // Global chat
        {
            RCHECK(GlobalMuted[playerid],       "You are not muted from the Global chat.");
            RCHECK(GlobalMuted[playerid] != -1, "You are permanent muted from the Global chat.");
            RCHECK(GlobalMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (GlobalMuted[playerid] - gettime()) / 60);
        }
        case 2: // Help
        {
            RCHECK(HelpMuted[playerid],       "You are not muted from the Help.");
            RCHECK(HelpMuted[playerid] != -1, "You are permanent muted from the Help.");
            RCHECK(HelpMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (HelpMuted[playerid] - gettime()) / 60);
        }
        case 3: // Live chat
        {
            RCHECK(LiveMuted[playerid],       "You are not muted from the Live chat.");
            RCHECK(LiveMuted[playerid] != -1, "You are permanent muted from the Live chat.");
            RCHECK(LiveMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (LiveMuted[playerid] - gettime()) / 60);
        }
        case 4: // Newbie chat
        {
            RCHECK(NewbieMuted[playerid],       "You are not muted from the Newbie chat.");
            RCHECK(NewbieMuted[playerid] != -1, "You are permanent muted from the Newbie chat.");
            RCHECK(NewbieMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (NewbieMuted[playerid] - gettime()) / 60);
        }
        case 5: // Report
        {
            RCHECK(ReportMuted[playerid],       "You are not muted from the Report.");
            RCHECK(ReportMuted[playerid] != -1, "You are permanent muted from the Report.");
            RCHECK(ReportMuted[playerid] < gettime(),
                "You need to wait at least %i minutes before requesting an unmute.",
                (ReportMuted[playerid] - gettime()) / 60);
        }
        default: return 1;
    }
    Dialog_Show(playerid, UnmuteSelectPunishment, DIALOG_STYLE_LIST, "Choose your punishment for this unmute.",
                "Fine ($%i)\n10 Minute Jail", "Select", "Cancel", percent(PlayerData[playerid][pCash] + PlayerData[playerid][pBank], 5));
    return 1;
}

CMD:unmute(playerid, params[])
{
    Dialog_Show(playerid, UnMute, DIALOG_STYLE_LIST, "Choose chat to unmute.",
                "Advertise\n"\
                "Global chat\n"\
                "Help\n"\
                "Live chat\n"\
                "Newbie chat\n"\
                "Report",
                "Select", "Cancel");
    return 1;
}

CMD:nmute(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3) && PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nmute [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (!IsNewbieMuted(targetid))
    {
        NewbieMutePlayer(targetid, 4 * 60);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from newbie chat by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from newbie chat by %s.", GetRPName(playerid));
    }
    else
    {
        NewbieMutePlayer(targetid, 0);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from newbie chat by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from newbie chat by %s.", GetRPName(playerid));
    }

    return 1;
}

CMD:hmute(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3) && PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hmute [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (!IsHelpMuted(targetid))
    {
        HelpMutePlayer(targetid, 4 * 60);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from help requests by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from help requests by %s.", GetRPName(playerid));
    }
    else
    {
        HelpMutePlayer(targetid, 0);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from help requests by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from help requests by %s.", GetRPName(playerid));
    }

    return 1;
}

CMD:admute(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pHelper])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /admute [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (!IsAdMuted(targetid))
    {
        AdMutePlayer(targetid, 4 * 60);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from advertisements by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from advertisements by %s.", GetRPName(playerid));
    }
    else
    {
        AdMutePlayer(targetid, 0);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from advertisements by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from advertisements by %s.", GetRPName(playerid));
    }

    return 1;
}

CMD:gmute(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid) && PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gmute [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (!IsGlobalMuted(targetid))
    {
        GlobalMutePlayer(targetid, 4 * 60);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from global chat by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from global chat by %s.", GetRPName(playerid));
    }
    else
    {
        GlobalMutePlayer(targetid, 0);
        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from global chat by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from global chat by %s.", GetRPName(playerid));
    }

    return 1;
}

CMD:rwarn(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rwarn [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (IsReportMuted(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is muted from reports.");
    }
    new warns = GetPlayerReportWarns(targetid) + 1;
    SetPlayerReportWarns(targetid, warns);
    SendClientMessageEx(targetid, COLOR_LIGHTRED, "* %s issued you a report warning, reason: %s (%i/3)",
                        GetRPName(playerid), reason, warns);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was given a report warning by %s, reason: %s",
                     GetRPName(targetid), GetRPName(playerid), reason);

    if (warns >= 3)
    {
        ReportMutePlayer(targetid, 3 * 24 * 60);
        SendClientMessage(targetid, COLOR_LIGHTRED, "* You have been muted from reports for 3 days.");
    }
    return 1;
}

CMD:rmute(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rmute [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (!IsReportMuted(targetid))
    {
        ReportMutePlayer(targetid, 4 * 60);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from submitting reports by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from submitting reports by %s.", GetRPName(playerid));
    }
    else
    {
        ReportMutePlayer(targetid, 0);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from submitting reports by %s.", GetRPName(targetid), GetRPName(playerid));
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from submitting reports by %s.", GetRPName(playerid));
    }

    return 1;
}

CMD:runmute(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /runmute [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsReportMuted(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not muted from reports.");
    }
    ReportMutePlayer(targetid, 0);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from reports by %s.", GetRPName(targetid), GetRPName(playerid));
    SendClientMessageEx(targetid, COLOR_YELLOW, "Your report mute has been lifted by %s. Your report warnings were reset.", GetRPName(playerid));
    return 1;
}

CMD:warn(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /warn [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be warned.");
    }

    new warns = GetPlayerWarnings(targetid) + 1;
    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
            "WARN", "%s was warned by %s %s. Reason: %s Warn (%i/3)",
            GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid), reason, warns);

    if (warns < 3)
    {
        SetPlayerWarnings(targetid, warns);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was warned by %s %s, reason: %s", GetRPName(targetid), GetAdmCmdRank(playerid),  GetRPName(playerid), reason);
        SendClientMessageEx(targetid, COLOR_LIGHTRED, "%s %s has warned you, reason: %s", GetAdmCmdRank(playerid),  GetRPName(playerid), reason);
    }
    else
    {
        SetPlayerWarnings(targetid, 0);//When player is banned player is not saved
        format(reason, sizeof(reason), "%s (3/3 warnings)", reason);
        BanPlayer(targetid, reason, playerid);
    }

    return 1;
}
