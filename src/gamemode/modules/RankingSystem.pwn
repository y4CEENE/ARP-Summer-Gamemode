/// @file      RankingSystem.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-05-21 00:07:36 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MINIMUM_RANKING_LEVEL 3
/*
 * OK JOB_PIZZAMAN
 * OK JOB_TRUCKER
 * OK JOB_FISHERMAN
 * OK JOB_ARMSDEALER
 * OK JOB_MECHANIC
 * OK JOB_MINER
 *    JOB_TAXIDRIVER
 * OK JOB_DRUGDEALER
 * OK JOB_DRUGSMUGGLER
 * OK JOB_LAWYER
 *    JOB_DETECTIVE
 * OK JOB_GARBAGEMAN
 * OK JOB_FARMER
 *    JOB_HOOKER
 *    JOB_CRAFTMAN
 * OK JOB_FORKLIFT
 * OK JOB_CARJACKER
 * OK JOB_ROBBERY
 *    JOB_SWEEPER
 *    JOB_BARTENDER
 * OK JOB_LUMBERJACK
 */
enum eRank
{
    Rank_Name[32],
    Rank_Points,
    Rank_Color
};

static RanksList[][eRank] = {
    {"UnRanked"    ,      0, 0xFFFFFF},
    {"Bronze"      ,  10000, 0xCD7F32},
    {"Silver"      ,  30000, 0xC0C0C0},
    {"Gold"        ,  50000, 0xFFD700},
    {"Platinum"    ,  80000, 0x006BC7},
    {"Diamond"     , 100000, 0x76154F},
    {"GrandMaster" , 150000, 0xF21828}
};

static PlayerRankPoints[MAX_PLAYERS];
static PlayerMembershipRankPoints[MAX_PLAYERS];

stock GetPlayerRankPoints(playerid)
{
    return PlayerRankPoints[playerid];
}

GivePlayerRankPoints(playerid, points)
{
    if (PlayerData[playerid][pLevel] < MINIMUM_RANKING_LEVEL)
    {
        return;
    }
    if (PlayerRankPoints[playerid] + points < 0)
    {
        PlayerRankPoints[playerid] = 0;
    }
    else
    {
        PlayerRankPoints[playerid] += points;
    }

    if (PlayerData[playerid][pGang] != -1 && PlayerData[playerid][pBandana])
    {
        new gangid = PlayerData[playerid][pGang];

        if (GangInfo[gangid][gRankingPoints] + points < 0)
        {
            PlayerMembershipRankPoints[playerid] -=  GangInfo[gangid][gRankingPoints];
            GangInfo[gangid][gRankingPoints] = 0;
        }
        else
        {
            PlayerMembershipRankPoints[playerid] += points;
            GangInfo[gangid][gRankingPoints] += points;
        }
    }
}

ResetPlayerCommitRankPoints(playerid)
{
    PlayerMembershipRankPoints[playerid] = 0;
}

GetPlayerCommitRankPoints(playerid)
{
    return PlayerMembershipRankPoints[playerid];
}

GivePlayerRankPointLegalJob(playerid, points)
{
    if (PlayerData[playerid][pGang] != -1 &&  PlayerData[playerid][pBandana])
    {
        GivePlayerRankPoints(playerid, -points);
    }
    else if (PlayerData[playerid][pFaction]!= -1 && PlayerData[playerid][pDuty])
    {
        GivePlayerRankPoints(playerid, -points);
    }
    else
    {
        GivePlayerRankPoints(playerid, points);
    }
}

GivePlayerRankPointIllegalJob(playerid, points)
{
    if (PlayerData[playerid][pGang] != -1 &&  PlayerData[playerid][pBandana])
    {
        GivePlayerRankPoints(playerid, points);
    }
    else if ((GetPlayerFaction(playerid) == FACTION_HITMAN || GetPlayerFaction(playerid) == FACTION_TERRORIST) && PlayerData[playerid][pDuty])
    {
        GivePlayerRankPoints(playerid, points);
    }
    else
    {
        GivePlayerRankPoints(playerid, -points);
    }
}

ResetPlayerRankPoints(playerid)
{
    PlayerRankPoints[playerid] = 0;
}

GetPlayerRankID(playerid)
{
    for (new i = sizeof(RanksList) - 1; i >= 0 ; i--)
    {
        if (PlayerRankPoints[playerid] >= RanksList[i][Rank_Points])
        {
            return i;
        }
    }
    return 0;
}

stock GetPlayerRankName(playerid)
{
    new name[32];
    format(name, sizeof(name), RanksList[GetPlayerRankID(playerid)][Rank_Name]);
    return name;
}

hook OnPlayerInit(playerid)
{
    PlayerRankPoints[playerid] = 0;
    return 1;
}

hook OnServerBeacon(timestamp)
{
    DBFormat("");
    for (new gangid=0;gangid<MAX_GANGS;gangid++)
    {
        if (GangInfo[gangid][gSetup])
        {
            DBContinueFormat("UPDATE "#TABLE_GANGS" SET rankingpoints = %i WHERE id = %i;",
                             GangInfo[gangid][gRankingPoints],
                             gangid);
        }
    }
    DBExecute();
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (!PlayerData[playerid][pLogged])
    {
        return 1;
    }

    if (IsPlayerInTutorial(playerid))
    {
        return 1;
    }

    if (PlayerData[playerid][pLevel] >= MINIMUM_RANKING_LEVEL)
    {
        DBQuery("UPDATE "#TABLE_USERS" SET rankingpoints = %i WHERE uid = %i", PlayerRankPoints[playerid], PlayerData[playerid][pID]);

    }
    return 1;
}

hook OnLoadUser(playerid, row)
{
    PlayerRankPoints[playerid] = GetDBIntField(row, "rankingpoints");
    PlayerMembershipRankPoints[playerid] = GetDBIntField(row, "membership_rankingpoints");
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (!IsPlayerConnected(killerid))
    {
        return 1;
    }
    if (PlayerData[playerid][pLevel] < MINIMUM_RANKING_LEVEL && PlayerData[killerid][pLevel] >= MINIMUM_RANKING_LEVEL)
    {
        GivePlayerRankPoints(killerid, -500);
        return 1;
    }

    new is_killer_cop = IsLawEnforcement(killerid) && PlayerData[killerid][pDuty];
    new is_killer_in_gang = PlayerData[killerid][pGang] != -1 && PlayerData[killerid][pBandana];

    new is_player_cop = IsLawEnforcement(playerid) && PlayerData[playerid][pDuty];
    new is_player_in_gang = PlayerData[playerid][pGang] != -1 && PlayerData[playerid][pBandana];

    new killer_rank = PlayerData[killerid][pGangRank];
    new player_rank = PlayerData[playerid][pGangRank];

    if (is_killer_cop)
    {
        killer_rank = PlayerData[killerid][pFactionRank];
    }

    if (is_player_cop)
    {
        player_rank = PlayerData[killerid][pFactionRank];
    }

    if ((is_killer_cop || is_killer_in_gang) && (is_player_cop || is_player_in_gang))
    {
        new killer_points = 0;
        new player_points = 0;
        new in_same_turf = IsInSameActiveTurf(playerid, killerid);

        if ((is_killer_in_gang && is_player_cop) || (is_killer_cop && is_player_in_gang))
        {
            killer_points += (50 * in_same_turf + 50) * (player_rank + 1);
            player_points += (50 * in_same_turf + 50) * (7 - killer_rank + 1);
        }
        else if ((is_killer_cop && is_player_cop) || (is_killer_in_gang && is_player_in_gang && PlayerData[killerid][pGang] == PlayerData[playerid][pGang]))
        {
            if (in_same_turf)
            {
                killer_points = -140 * player_rank;
            }
            else
            {
                killer_points = -70 * player_rank;
            }
        }
        else if (is_killer_in_gang && is_player_in_gang)
        {
            killer_points += (50 * in_same_turf + 50) * (player_rank + 1);
            player_points += (50 * in_same_turf + 50) * (7 - killer_rank + 1);
        }

        GivePlayerRankPoints(killerid, killer_points);
        GivePlayerRankPoints(playerid, player_points);
    }
    else if (is_killer_cop)
    {
        new points = 0;

        if (GetWantedLevel(playerid) > 0)
        {
            points += 30 * GetWantedLevel(playerid);
        }

        if (PlayerData[playerid][pNotoriety] > 0)
        {
            points += 30 * PlayerData[playerid][pNotoriety] / 4000;
        }

        if (points == 0)
        {
            points = -100;
        }
        GivePlayerRankPoints(killerid, points);
    }
    else if (is_killer_in_gang)
    {
        GivePlayerRankPoints(killerid, -100);
    }
    else if (PlayerData[killerid][pFaction] >= 0)
    {
        switch (GetPlayerFaction(killerid))
        {
            case FACTION_MEDIC:       { GivePlayerRankPoints(killerid, -300); }
            case FACTION_NEWS:        { GivePlayerRankPoints(killerid, -100); }
            case FACTION_GOVERNMENT:  { GivePlayerRankPoints(killerid,  -50); }
            case FACTION_HITMAN:      { GivePlayerRankPoints(killerid,  -10); }
            case FACTION_TERRORIST:   { GivePlayerRankPoints(killerid,   -5); }
            default:                  { GivePlayerRankPoints(killerid, -150); }
        }
    }
    else
    {
        // Killer is civilian
        if (PlayerData[playerid][pFaction] >= 0)
        {
            switch (GetPlayerFaction(playerid))
            {
                case FACTION_MEDIC:       { GivePlayerRankPoints(killerid, -300); }
                case FACTION_NEWS:        { GivePlayerRankPoints(killerid, -100); }
                case FACTION_GOVERNMENT:  { GivePlayerRankPoints(killerid, -250); }
                case FACTION_HITMAN:      { GivePlayerRankPoints(killerid,  150); }
                case FACTION_TERRORIST:   { GivePlayerRankPoints(killerid,  200); }
                default:                  { GivePlayerRankPoints(killerid, -150); }
            }
        }
        else if (PlayerData[playerid][pGang] >= 0)
        {
            if (IsInSameActiveTurf(playerid, killerid))
            {
                GivePlayerRankPoints(killerid, -1000);
            }
            else
            {
                GivePlayerRankPoints(killerid, 100 * player_rank);
                GivePlayerRankPoints(playerid, -200);
            }
        }
        else
        {
            GivePlayerRankPoints(killerid, -50);
            GivePlayerRankPoints(playerid, -25);
        }
    }
    return 1;
}

DB:OnGetTopCriminalPlayers(playerid)
{
    new rows = GetDBNumRows();
    new index=0;
    new username[MAX_PLAYER_NAME];
    new last_rank = 0;
    new last_value = 0;

    for (index=0;index<rows;index++)
    {
        new value = GetDBIntField(index, "crimes");

        if (value == 0)
        {
            break;
        }
        if (last_value != value)
        {
            last_value = value;
            last_rank++;
        }
        GetDBStringField(index, "username", username, MAX_PLAYER_NAME);

        if (index == 0)
        {
            new year, month, day;
            getdate(year, month, day);
            SendClientMessageEx(playerid, COLOR_GREEN, "----- Top Ranking Players %i/%i/%i -----", year, month, day);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "{FF7F27}#%i{FFFFFF} '%s' {FF0000}Crimes: %d{FFFFFF}",
                            last_rank, username, value);
    }

    if (index == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no available data for the moment.");
    }

    return 1;
}

DB:OnGetTopAddictPlayers(playerid)
{
    new rows = GetDBNumRows();
    new index=0;
    new username[MAX_PLAYER_NAME];
    new last_rank = 0;
    new last_value = 0;

    for (index=0;index<rows;index++)
    {
        new value = GetDBIntField(index, "hours");

        if (value == 0)
        {
            break;
        }
        if (last_value != value)
        {
            last_value = value;
            last_rank++;
        }
        GetDBStringField(index, "username", username, MAX_PLAYER_NAME);

        if (index == 0)
        {
            new year, month, day;
            getdate(year, month, day);
            SendClientMessageEx(playerid, COLOR_GREEN, "----- Top Ranking Players %i/%i/%i -----", year, month, day);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "{FF7F27}#%i{FFFFFF} '%s' {FF0000}Hours: %d{FFFFFF}",
                            last_rank, username, value);
    }

    if (index == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no available data for the moment.");
    }

    return 1;
}

DB:OnGetTopPlayersRank(playerid)
{
    new rows = GetDBNumRows();
    new index=0;
    new username[MAX_PLAYER_NAME];
    new last_rank = 0;
    new last_points = 0;

    for (index=0;index<rows;index++)
    {
        new rankingpoints = GetDBIntField(index, "rankingpoints");

        if (rankingpoints == 0)
        {
            break;
        }
        if (last_points != rankingpoints)
        {
            last_points = rankingpoints;
            last_rank++;
        }
        GetDBStringField(index, "username", username, MAX_PLAYER_NAME);

        new rankid = sizeof(RanksList) - 1;

        for (; rankid >= 0 ; rankid--)
        {
            if (rankingpoints >= RanksList[rankid][Rank_Points])
            {
                break;
            }
        }

        new nextrank = rankid;

        if (rankid < sizeof(RanksList) - 1)
        {
            nextrank += 1;
        }

        if (index == 0)
        {
            new year, month, day;
            getdate(year, month, day);
            SendClientMessageEx(playerid, COLOR_GREEN, "----- Top Ranking Players %i/%i/%i -----", year, month, day);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "{FF7F27}#%i{FFFFFF} '%s' {22B14C}Points:{FFFFFF} %d/%d {22B14C}Current Rank:{FFFFFF} {%06x}%s (%d){FFFFFF}", last_rank, username, last_points, RanksList[nextrank][Rank_Points], RanksList[rankid][Rank_Color], RanksList[rankid][Rank_Name], rankid);

    }

    if (index == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no available data for the moment.");
    }

    return 1;
}

DB:OnGetPlayerRank(playerid, targetid)
{
    new rows = GetDBNumRows();
    if (rows != 1)
    {
        return SendClientMessageEx(playerid, COLOR_RED, "Internal error cannot extract player (%d) rank", targetid);
    }
    new pos = GetDBIntField(0, "position") + 1;

    new rankid = GetPlayerRankID(targetid);
    new nextrank = rankid;

    if (rankid < sizeof(RanksList) - 1)
    {
        nextrank += 1;
    }
    SendClientMessageEx(playerid, COLOR_WHITE, "{FF7F27}#%i{FFFFFF} '%s' {22B14C}Points:{FFFFFF} %d/%d {22B14C}Current Rank:{FFFFFF} {%06x}%s (%d){FFFFFF}", pos, GetRPName(targetid), PlayerRankPoints[targetid], RanksList[nextrank][Rank_Points], RanksList[rankid][Rank_Color], RanksList[rankid][Rank_Name], rankid);

    return 1;
}

CMD:rankhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREY, "Ranking system commands: /myrank /rank /topranks /gangranks");
    return 1;
}

CMD:myrank(playerid, params[])
{
    if (PlayerData[playerid][pLevel] < MINIMUM_RANKING_LEVEL)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be level %d to be ranked.", MINIMUM_RANKING_LEVEL);
    }
    DBFormat("SELECT count(uid) as 'position' FROM "#TABLE_USERS" WHERE level > 2 AND rankingpoints > %i", PlayerRankPoints[playerid]);
    DBExecute("OnGetPlayerRank", "ii", playerid, playerid);

    return 1;
}

CMD:rank(playerid, params[])
{
    new targetid;
    if (sscanf(params, "i", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rank [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "Invalid player id.");
    }
    if (PlayerData[targetid][pLevel] < MINIMUM_RANKING_LEVEL)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "This player need to be level %d to be ranked.", MINIMUM_RANKING_LEVEL);
    }
    DBFormat("SELECT count(uid) as 'position' FROM "#TABLE_USERS" WHERE level > 2 AND rankingpoints > %i", PlayerRankPoints[targetid]);
    DBExecute("OnGetPlayerRank", "ii", playerid, targetid);

    return 1;
}

CMD:top(playerid)
{
    if (!IsGodAdmin(playerid))
    {
        return 0;
    }
    Dialog_Show(playerid, TopPlayers, DIALOG_STYLE_TABLIST, "Top Players",
                "{FF0000}Top Richest in the City\n"\
                "{FF0000}Top Cash holders in the City\n"\
                "{FF0000}Top Materials holders in the City\n"\
                "{FF0000}Top Weed holders in the City\n"\
                "{FF0000}Top Heroin holders in the City\n"\
                "{FF0000}Top Cocaine holders in the City\n"\
                "{FFFF00}Top 10 Criminal in the City.\n"\
                "{00FF00}Top 10 Addict in the City.",
                "Select", "Close");
    return 1;
}

Dialog:TopPlayers(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    switch (listitem)
    {
        case 0:
        {
            Dialog_Show(playerid, TopRichPlayers, DIALOG_STYLE_INPUT, "Top Players",
                "Enter the number of top richest players to show (Max: 50).\n"\
                "{FF0000}[!] Operation may take more than 3 minutes with some server lag)", "Show", "Cancel");
        }
        case 1:
        {
            Dialog_Show(playerid, TopCashPlayers, DIALOG_STYLE_INPUT, "Top Players",
                "Enter the number of top cash holders to show (Max: 50).\n"\
                "{FF0000}[!] Operation may take more than 3 minutes with some server lag)", "Show", "Cancel");
        }
        case 2:
        {
            Dialog_Show(playerid, TopMatsPlayers, DIALOG_STYLE_INPUT, "Top Players",
                "Enter the number of top materials holders to show (Max: 50).\n"\
                "{FF0000}[!] Operation may take more than 3 minutes with some server lag)", "Show", "Cancel");
        }
        case 3:
        {
            Dialog_Show(playerid, TopWeedPlayers, DIALOG_STYLE_INPUT, "Top Players",
                "Enter the number of top weed holders to show (Max: 50).\n"\
                "{FF0000}[!] Operation may take more than 3 minutes with some server lag)", "Show", "Cancel");
        }
        case 4:
        {
            Dialog_Show(playerid, TopHeroinPlayers, DIALOG_STYLE_INPUT, "Top Players",
                "Enter the number of top heroin holders to show (Max: 50).\n"\
                "{FF0000}[!] Operation may take more than 3 minutes with some server lag)", "Show", "Cancel");
        }
        case 5:
        {
            Dialog_Show(playerid, TopCocainePlayers, DIALOG_STYLE_INPUT, "Top Players",
                "Enter the number of top cocaine holders to show (Max: 50).\n"\
                "{FF0000}[!] Operation may take more than 3 minutes with some server lag)", "Show", "Cancel");
        }
        case 6:
        {
            DBFormat("select username, level, crimes from "#TABLE_USERS" where level > 2 ORDER BY crimes DESC,level DESC LIMIT 5");
            DBExecute("OnGetTopCriminalPlayers", "i", playerid);
        }
        case 7:
        {
            DBFormat("select username, level, hours from "#TABLE_USERS" where level > 2 ORDER BY hours DESC,level DESC LIMIT 5");
            DBExecute("OnGetTopAddictPlayers", "i", playerid);
        }
    }
    return 1;
}

Dialog:TopRichPlayers(playerid, response, listitem, inputtext[])
{
    if  (!response)
        return 1;

    new limit = strval(inputtext);
    if (limit <= 0 || limit > 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value (Max: 50).");
    }
    SendClientMessage(playerid, COLOR_RED, "[!] Estimated time: at least 3 min (You may notice some lag).");
    SendClientMessage(playerid, COLOR_RED, "[!] Nb. Don't use it alot of times, use it when there is few online players.");

    DBFormat("SELECT username,level,lastlogin,cash,bank,cars,houses,businesses,"\
            "garages,lands,cash+bank+cars+houses+businesses+garages+lands as total "\
            "From(");
    DBContinueFormat("SELECT t4.uid,t4.username,t4.level,t4.lastlogin,t4.cash,t4.bank,t4.cars,t4.houses,t4.businesses,t4.garages,"\
                    "COALESCE(sum(l.price),0) AS lands "\
                    "FROM(");
    DBContinueFormat(   "SELECT t3.uid,t3.username,t3.level,t3.lastlogin,t3.cash,t3.bank,t3.cars,t3.houses,t3.businesses,"\
                        "COALESCE(sum(g.price),0) AS garages "\
                        "FROM(");
    DBContinueFormat(       "SELECT t2.uid,t2.username,t2.level,t2.lastlogin,t2.cash,t2.bank,t2.cars,t2.houses,"\
                            "COALESCE(sum(b.price+b.cash),0) AS businesses "\
                            "FROM(");
    DBContinueFormat(           "SELECT t1.uid,t1.username,t1.level,t1.lastlogin,t1.cash,t1.bank,t1.cars,"\
                                "COALESCE(sum(h.price+h.cash),0) AS houses "\
                                "FROM(");
    DBContinueFormat(               "SELECT u.uid,u.username,u.level,u.lastlogin,u.cash,u.bank,"\
                                    "COALESCE(sum(v.price+v.cash),0) AS cars "\
                                    "FROM users AS u "\
                                    "LEFT JOIN vehicles AS v ON v.ownerid=u.uid "\
                                    "GROUP BY u.uid ");
    DBContinueFormat(           ") t1 "\
                                "LEFT JOIN houses AS h ON h.ownerid=t1.uid "\
                                "GROUP BY t1.uid ");
    DBContinueFormat(       ") t2 "\
                            "LEFT JOIN businesses AS b ON b.ownerid=t2.uid "\
                            "GROUP BY t2.uid ");
    DBContinueFormat(   ") t3 "\
                        "LEFT JOIN garages AS g ON g.ownerid=t3.uid "\
                        "GROUP BY t3.uid ");
    DBContinueFormat(") t4 "\
                     "LEFT JOIN lands AS l ON l.ownerid=t4.uid "\
                     "GROUP BY t4.uid ");
    DBContinueFormat(") t5 ORDER BY total DESC LIMIT %i;", limit);
    DBExecute("TopRichPlayers", "i", playerid);
    return 1;
}

DB:TopRichPlayers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME];
    for (new i=0; i < rows; i++)
    {
        GetDBStringField(i, "username", username);

        SendClientMessageEx(playerid, COLOR_GREY, "[RICH#%i][User=%s][Total=%s][Lvl=%i][LastLogin=%s]",
                            i + 1,
                            username,
                            FormatCash(GetDBIntField(i, "total")),
                            GetDBIntField(i, "level"),
                            TimestampToString(GetDBIntField(i, "lastlogin"), 5));
        SendClientMessageEx(playerid, COLOR_GREY, "[RICH#%i][Cash=%s][Bank=%s][Cars=%s][Houses=%s][Biz=%s][Garages=%s][Lands=%s]",
                            i + 1,
                            FormatCash(GetDBIntField(i, "cash")),
                            FormatCash(GetDBIntField(i, "bank")),
                            FormatCash(GetDBIntField(i, "cars")),
                            FormatCash(GetDBIntField(i, "houses")),
                            FormatCash(GetDBIntField(i, "businesses")),
                            FormatCash(GetDBIntField(i, "garages")),
                            FormatCash(GetDBIntField(i, "lands")));
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "[!] You can check 'Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt' for full chat logs");
}

Dialog:TopCashPlayers(playerid, response, listitem, inputtext[])
{
    if  (!response)
        return 1;

    new limit = strval(inputtext);
    if (limit <= 0 || limit > 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value (Max: 50).");
    }
    SendClientMessage(playerid, COLOR_RED, "[!] Estimated time: at least 3 min (You may notice some lag).");
    SendClientMessage(playerid, COLOR_RED, "[!] Nb. Don't use it alot of times, use it when there is few online players.");

    DBFormat("SELECT username,level,lastlogin,cash,bank,cars,houses,businesses,"\
            "cash+bank+cars+houses+businesses as total "\
            "From(");
    DBContinueFormat("SELECT t2.uid,t2.username,t2.level,t2.lastlogin,t2.cash,t2.bank,t2.cars,t2.houses,"\
                    "COALESCE(sum(b.cash),0) AS businesses "\
                    "FROM(");
    DBContinueFormat(   "SELECT t1.uid,t1.username,t1.level,t1.lastlogin,t1.cash,t1.bank,t1.cars,"\
                        "COALESCE(sum(h.cash),0) AS houses "\
                        "FROM(");
    DBContinueFormat(       "SELECT u.uid,u.username,u.level,u.lastlogin,u.cash,u.bank,"\
                            "COALESCE(sum(v.cash),0) AS cars "\
                            "FROM users AS u "\
                            "LEFT JOIN vehicles AS v ON v.ownerid=u.uid "\
                            "GROUP BY u.uid ");
    DBContinueFormat(   ") t1 "\
                        "LEFT JOIN houses AS h ON h.ownerid=t1.uid "\
                        "GROUP BY t1.uid ");
    DBContinueFormat(") t2 "\
                    "LEFT JOIN businesses AS b ON b.ownerid=t2.uid "\
                    "GROUP BY t2.uid "\
                    ") t3 ORDER BY total DESC LIMIT %i;", limit);
    DBExecute("TopCashPlayers", "i", playerid);
    return 1;
}

DB:TopCashPlayers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME];
    for (new i=0; i < rows; i++)
    {
        GetDBStringField(i, "username", username);

        SendClientMessageEx(playerid, COLOR_GREY, "[CASH#%i][User=%s][Total=%s][Lvl=%i][LastLogin=%s]",
                            i + 1,
                            username,
                            FormatCash(GetDBIntField(i, "total")),
                            GetDBIntField(i, "level"),
                            TimestampToString(GetDBIntField(i, "lastlogin"), 5));
        SendClientMessageEx(playerid, COLOR_GREY, "[CASH#%i][Cash=%s][Bank=%s][Cars=%s][Houses=%s][Biz=%s]",
                            i + 1,
                            FormatCash(GetDBIntField(i, "cash")),
                            FormatCash(GetDBIntField(i, "bank")),
                            FormatCash(GetDBIntField(i, "cars")),
                            FormatCash(GetDBIntField(i, "houses")),
                            FormatCash(GetDBIntField(i, "businesses")));
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "[!] You can check 'Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt' for full chat logs");
}

Dialog:TopMatsPlayers(playerid, response, listitem, inputtext[])
{
    if  (!response)
        return 1;

    new limit = strval(inputtext);
    if (limit <= 0 || limit > 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value (Max: 50).");
    }
    SendClientMessage(playerid, COLOR_RED, "[!] Estimated time: at least 3 min (You may notice some lag).");
    SendClientMessage(playerid, COLOR_RED, "[!] Nb. Don't use it alot of times, use it when there is few online players.");

    DBFormat("SELECT username,level,lastlogin,materials,cars,houses,businesses,"\
            "materials+cars+houses+businesses as total "\
            "From(");
    DBContinueFormat("SELECT t2.uid,t2.username,t2.level,t2.lastlogin,t2.materials,t2.cars,houses,"\
                    "COALESCE(sum(b.materials),0) AS businesses "\
                    "FROM(");
    DBContinueFormat(   "SELECT t1.uid,t1.username,t1.level,t1.lastlogin,t1.materials,t1.cars,"\
                        "COALESCE(sum(h.materials),0) AS houses "\
                        "FROM(");
    DBContinueFormat(       "SELECT u.uid,u.username,u.level,u.lastlogin,u.materials,"\
                            "COALESCE(sum(v.materials),0) AS cars "\
                            "FROM users AS u "\
                            "LEFT JOIN vehicles AS v ON v.ownerid=u.uid "\
                            "GROUP BY u.uid ");
    DBContinueFormat(   ") t1 "\
                        "LEFT JOIN houses AS h ON h.ownerid=t1.uid "\
                        "GROUP BY t1.uid ");
    DBContinueFormat(") t2 "\
                    "LEFT JOIN businesses AS b ON b.ownerid=t2.uid "\
                    "GROUP BY t2.uid "\
                    ") t3 ORDER BY total DESC LIMIT %i;", limit);
    DBExecute("TopMatsPlayers", "i", playerid);
    return 1;
}

DB:TopMatsPlayers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME];
    for (new i=0; i < rows; i++)
    {
        GetDBStringField(i, "username", username);

        SendClientMessageEx(playerid, COLOR_GREY, "[MATS#%i][User=%s][Total=%s][Lvl=%i][LastLogin=%s]",
                            i + 1,
                            username,
                            FormatNumber(GetDBIntField(i, "total")),
                            GetDBIntField(i, "level"),
                            TimestampToString(GetDBIntField(i, "lastlogin"), 5));
        SendClientMessageEx(playerid, COLOR_GREY, "[MATS#%i][Materials=%s][Cars=%s][Houses=%s][Biz=%s]",
                            i + 1,
                            FormatNumber(GetDBIntField(i, "materials")),
                            FormatNumber(GetDBIntField(i, "cars")),
                            FormatNumber(GetDBIntField(i, "houses")),
                            FormatNumber(GetDBIntField(i, "businesses")));
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "[!] You can check 'Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt' for full chat logs");
}

Dialog:TopCocainePlayers(playerid, response, listitem, inputtext[])
{
    if  (!response)
        return 1;

    new limit = strval(inputtext);
    if (limit <= 0 || limit > 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value (Max: 50).");
    }
    SendClientMessage(playerid, COLOR_RED, "[!] Estimated time: at least 3 min (You may notice some lag).");
    SendClientMessage(playerid, COLOR_RED, "[!] Nb. Don't use it alot of times, use it when there is few online players.");

    DBFormat("SELECT username,level,lastlogin,cocaine,cars,houses,"\
             "cocaine+cars+houses as total "\
             "FROM(");
    DBContinueFormat("SELECT t1.uid,t1.username,t1.level,t1.lastlogin,t1.cocaine,t1.cars,"\
                     "COALESCE(sum(h.cocaine),0) AS houses "\
                     "FROM(");
    DBContinueFormat(   "SELECT u.uid,u.username,u.level,u.lastlogin,u.cocaine,"\
                        "COALESCE(sum(v.cocaine),0) AS cars "\
                        "FROM users AS u "\
                        "LEFT JOIN vehicles AS v ON v.ownerid=u.uid "\
                        "GROUP BY u.uid ");
    DBContinueFormat(") t1 "\
                     "LEFT JOIN houses AS h ON h.ownerid=t1.uid "\
                     "GROUP BY t1.uid ");
    DBContinueFormat(") t2 ORDER BY total DESC LIMIT %i;", limit);
    DBExecute("TopCocainePlayers", "i", playerid);
    return 1;
}

DB:TopCocainePlayers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME];
    for (new i=0; i < rows; i++)
    {
        GetDBStringField(i, "username", username);

        SendClientMessageEx(playerid, COLOR_GREY, "[COCAINE#%i][User=%s][Total=%s][Lvl=%i][LastLogin=%s]",
                            i + 1,
                            username,
                            FormatNumber(GetDBIntField(i, "total")),
                            GetDBIntField(i, "level"),
                            TimestampToString(GetDBIntField(i, "lastlogin"), 5));
        SendClientMessageEx(playerid, COLOR_GREY, "[COCAINE#%i][Cocaine=%s][Cars=%s][Houses=%s]",
                            i + 1,
                            FormatNumber(GetDBIntField(i, "cocaine")),
                            FormatNumber(GetDBIntField(i, "cars")),
                            FormatNumber(GetDBIntField(i, "houses")));
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "[!] You can check 'Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt' for full chat logs");
}

Dialog:TopWeedPlayers(playerid, response, listitem, inputtext[])
{
    if  (!response)
        return 1;

    new limit = strval(inputtext);
    if (limit <= 0 || limit > 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value (Max: 50).");
    }
    SendClientMessage(playerid, COLOR_RED, "[!] Estimated time: at least 3 min (You may notice some lag).");
    SendClientMessage(playerid, COLOR_RED, "[!] Nb. Don't use it alot of times, use it when there is few online players.");

    DBFormat("SELECT username,level,lastlogin,weed,cars,houses,"\
             "weed+cars+houses as total "\
             "FROM(");
    DBContinueFormat("SELECT t1.uid,t1.username,t1.level,t1.lastlogin,t1.weed,t1.cars,"\
                     "COALESCE(sum(h.weed),0) AS houses "\
                     "FROM(");
    DBContinueFormat(   "SELECT u.uid,u.username,u.level,u.lastlogin,u.weed,"\
                        "COALESCE(sum(v.weed),0) AS cars "\
                        "FROM users AS u "\
                        "LEFT JOIN vehicles AS v ON v.ownerid=u.uid "\
                        "GROUP BY u.uid ");
    DBContinueFormat(") t1 "\
                     "LEFT JOIN houses AS h ON h.ownerid=t1.uid "\
                     "GROUP BY t1.uid ");
    DBContinueFormat(") t2 ORDER BY total DESC LIMIT %i;", limit);

    DBExecute("TopWeedPlayers", "i", playerid);
    return 1;
}

DB:TopWeedPlayers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME];
    for (new i=0; i < rows; i++)
    {
        GetDBStringField(i, "username", username);

        SendClientMessageEx(playerid, COLOR_GREY, "[WEED#%i][User=%s][Total=%s][Lvl=%i][LastLogin=%s]",
                            i + 1,
                            username,
                            FormatNumber(GetDBIntField(i, "total")),
                            GetDBIntField(i, "level"),
                            TimestampToString(GetDBIntField(i, "lastlogin"), 5));
        SendClientMessageEx(playerid, COLOR_GREY, "[WEED#%i][Weed=%s][Cars=%s][Houses=%s]",
                            i + 1,
                            FormatNumber(GetDBIntField(i, "weed")),
                            FormatNumber(GetDBIntField(i, "cars")),
                            FormatNumber(GetDBIntField(i, "houses")));
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "[!] You can check 'Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt' for full chat logs");
}

Dialog:TopHeroinPlayers(playerid, response, listitem, inputtext[])
{
    if  (!response)
        return 1;

    new limit = strval(inputtext);
    if (limit <= 0 || limit > 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value (Max: 50).");
    }
    SendClientMessage(playerid, COLOR_RED, "[!] Estimated time: at least 3 min (You may notice some lag).");
    SendClientMessage(playerid, COLOR_RED, "[!] Nb. Don't use it alot of times, use it when there is few online players.");

    DBFormat("SELECT username,level,lastlogin,heroin,cars,houses,"\
             "heroin+cars+houses as total "\
             "FROM(");
    DBContinueFormat("SELECT t1.uid,t1.username,t1.level,t1.lastlogin,t1.heroin,t1.cars,"\
                     "COALESCE(sum(h.heroin),0) AS houses "\
                     "FROM(");
    DBContinueFormat(   "SELECT u.uid,u.username,u.level,u.lastlogin,u.heroin,"\
                        "COALESCE(sum(v.heroin),0) AS cars "\
                        "FROM users AS u "\
                        "LEFT JOIN vehicles AS v ON v.ownerid=u.uid "\
                        "GROUP BY u.uid ");
    DBContinueFormat(") t1 "\
                     "LEFT JOIN houses AS h ON h.ownerid=t1.uid "\
                     "GROUP BY t1.uid ");
    DBContinueFormat(") t2 ORDER BY total DESC LIMIT %i;", limit);
    DBExecute("TopHeroinPlayers", "i", playerid);
    return 1;
}

DB:TopHeroinPlayers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME];
    for (new i=0; i < rows; i++)
    {
        GetDBStringField(i, "username", username);

        SendClientMessageEx(playerid, COLOR_GREY, "[HEROIN#%i][User=%s][Total=%s][Lvl=%i][LastLogin=%s]",
                            i + 1,
                            username,
                            FormatNumber(GetDBIntField(i, "total")),
                            GetDBIntField(i, "level"),
                            TimestampToString(GetDBIntField(i, "lastlogin"), 5));
        SendClientMessageEx(playerid, COLOR_GREY, "[HEROIN#%i][Heroin=%s][Cars=%s][Houses=%s]",
                            i + 1,
                            FormatNumber(GetDBIntField(i, "heroin")),
                            FormatNumber(GetDBIntField(i, "cars")),
                            FormatNumber(GetDBIntField(i, "houses")));
    }
    SendClientMessageEx(playerid, COLOR_AQUA, "[!] You can check 'Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt' for full chat logs");
}

CMD:topranks(playerid, params[])
{
    DBFormat("select username,level,rankingpoints from "#TABLE_USERS" where level > 2 ORDER BY rankingpoints DESC,level DESC LIMIT 5");
    DBExecute("OnGetTopPlayersRank", "i", playerid);
    return 1;
}

CMD:gangranks(playerid, params[])
{
    new year, month, day;
    getdate(year, month, day);

    SendClientMessageEx(playerid, COLOR_GREEN, "----- Gang Ranking %i/%i/%i -----", year, month, day);

    for (new gangid=0;gangid<MAX_GANGS;gangid++)
    {
        if (GangInfo[gangid][gSetup])
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "{%06x}[%02d] %s{FFFFFF}: %d", GetGangColor(gangid), gangid, GangInfo[gangid][gName], GangInfo[gangid][gRankingPoints]);
        }
    }
}

CMD:newseason(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /newseason [password]");
    }

    if (strcmp("d15q6a", params, true))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid password!");
    }

    SendClientMessage(playerid, COLOR_GREY, "[New season]: Decreasing gang ranking points");

    for (new gangid=0;gangid<MAX_GANGS;gangid++)
    {
        if (GangInfo[gangid][gSetup])
        {
            GangInfo[gangid][gRankingPoints] = GangInfo[gangid][gRankingPoints] * 75 / 100;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "[New season]: Decreasing players ranking points");
    foreach(new targetid:Player)
    {
        DBQuery("UPDATE "#TABLE_USERS" SET rankingpoints = %i WHERE uid = %i", PlayerRankPoints[playerid], PlayerData[playerid][pID]);

        PlayerRankPoints[playerid] = PlayerRankPoints[playerid] * 75 / 100;
    }
    DBQuery("UPDATE "#TABLE_USERS" SET rankingpoints = rankingpoints * 75 / 100");

    SendClientMessage(playerid, COLOR_GREY, "[New season]: Please wait 10 seconds to have the gangs ranking points saved.");
    SendClientMessageToAll(COLOR_AQUA, "[News] New season has been started. All ranks has been decreased.");
    return 1;
}
