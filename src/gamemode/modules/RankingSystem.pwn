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
    if(PlayerData[playerid][pLevel] < MINIMUM_RANKING_LEVEL)
    {
        return;
    }
    if(PlayerRankPoints[playerid] + points < 0)
    {
        PlayerRankPoints[playerid] = 0;
    }
    else
    {
        PlayerRankPoints[playerid] += points;
    }

    if(PlayerData[playerid][pGang] != -1 && PlayerData[playerid][pBandana])
    {
        new gangid = PlayerData[playerid][pGang];

        if(GangInfo[gangid][gRankingPoints] + points < 0)
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
    if(PlayerData[playerid][pGang] != -1 &&  PlayerData[playerid][pBandana])
    {
        GivePlayerRankPoints(playerid, -points);
    }
    else if(PlayerData[playerid][pFaction]!= -1 && PlayerData[playerid][pDuty])
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
    if(PlayerData[playerid][pGang] != -1 &&  PlayerData[playerid][pBandana])
    {
        GivePlayerRankPoints(playerid, points);
    }
    else if((GetPlayerFaction(playerid) == FACTION_HITMAN || GetPlayerFaction(playerid) == FACTION_TERRORIST) && PlayerData[playerid][pDuty])
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
    for(new i = sizeof(RanksList) - 1; i >= 0 ; i--)
    {
        if(PlayerRankPoints[playerid] >= RanksList[i][Rank_Points])
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
    for(new gangid=0;gangid<MAX_GANGS;gangid++)
    {
	    if(GangInfo[gangid][gSetup])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rankingpoints = %i WHERE id = %i", GangInfo[gangid][gRankingPoints], gangid );
            mysql_tquery(connectionID, queryBuffer);
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(!PlayerData[playerid][pLogged])
    {
	    return 1;
    }

    if(IsPlayerInTutorial(playerid))
    {
        return 1;
    }

    if(PlayerData[playerid][pLevel] >= MINIMUM_RANKING_LEVEL)
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rankingpoints = %i WHERE uid = %i", PlayerRankPoints[playerid], PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
    }
    return 1;
}

hook OnLoadUser(playerid, row)
{
    PlayerRankPoints[playerid] = cache_get_field_content_int(row, "rankingpoints");
    PlayerMembershipRankPoints[playerid] = cache_get_field_content_int(row, "membership_rankingpoints");
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(!IsPlayerConnected(killerid))
    {
        return 1;
    }
    if(PlayerData[playerid][pLevel] < MINIMUM_RANKING_LEVEL && PlayerData[killerid][pLevel] >= MINIMUM_RANKING_LEVEL)
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
    
    if(is_killer_cop)
    {
        killer_rank = PlayerData[killerid][pFactionRank];
    }

    if(is_player_cop)
    {
        player_rank = PlayerData[killerid][pFactionRank];
    }

    if((is_killer_cop || is_killer_in_gang) && (is_player_cop || is_player_in_gang))
    {
        new killer_points = 0;
        new player_points = 0;
        new in_same_turf = IsInSameActiveTurf(playerid, killerid);

        if((is_killer_in_gang && is_player_cop) || (is_killer_cop && is_player_in_gang))
        {
            killer_points += (50 * in_same_turf + 50) * (player_rank + 1);
            player_points += (50 * in_same_turf + 50) * (7 - killer_rank + 1);
        }
        else if((is_killer_cop && is_player_cop) || (is_killer_in_gang && is_player_in_gang && PlayerData[killerid][pGang] == PlayerData[playerid][pGang]))
        {
            if(in_same_turf)
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
    else if(is_killer_cop)
    {
        new points = 0;

        if(PlayerData[playerid][pWantedLevel] > 0)
        {
            points += 30 * PlayerData[playerid][pWantedLevel];
        }
        
        if(PlayerData[playerid][pNotoriety] > 0)
        {
            points += 30 * PlayerData[playerid][pNotoriety] / 4000;
        }

        if(points == 0)
        {
            points = -100;
        }
        GivePlayerRankPoints(killerid, points);
    }
    else if(is_killer_in_gang)
    {
        GivePlayerRankPoints(killerid, -100);
    }
    else if(PlayerData[killerid][pFaction] >= 0)
    {
        switch(GetPlayerFaction(killerid))
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
        if(PlayerData[playerid][pFaction] >= 0)
        {
            switch(GetPlayerFaction(playerid))
            {
                case FACTION_MEDIC:       { GivePlayerRankPoints(killerid, -300); }
                case FACTION_NEWS:        { GivePlayerRankPoints(killerid, -100); }
                case FACTION_GOVERNMENT:  { GivePlayerRankPoints(killerid, -250); }
                case FACTION_HITMAN:      { GivePlayerRankPoints(killerid,  150); }
                case FACTION_TERRORIST:   { GivePlayerRankPoints(killerid,  200); }
                default:                  { GivePlayerRankPoints(killerid, -150); }
            }
        }
        else if(PlayerData[playerid][pGang] >= 0)
        {
            if(IsInSameActiveTurf(playerid, killerid))
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
publish OnGetTopPlayersRank(playerid)
{
    new rows = cache_get_row_count(connectionID);
    new index=0;
    new username[MAX_PLAYER_NAME];
    new last_rank = 0;
    new last_points = 0;

    for(index=0;index<rows;index++)
    {
        new rankingpoints = cache_get_field_content_int(index, "rankingpoints");
        
        if(rankingpoints == 0)
        {
            break;
        }
        if(last_points != rankingpoints)
        {
            last_points = rankingpoints;
            last_rank++;
        }
        cache_get_field_content(index, "username", username, connectionID, MAX_PLAYER_NAME);

        new rankid = sizeof(RanksList) - 1;

        for(; rankid >= 0 ; rankid--)
        {
            if(rankingpoints >= RanksList[rankid][Rank_Points])
            {
                break;
            }
        }

        new nextrank = rankid;

        if(rankid < sizeof(RanksList) - 1)
        {
            nextrank += 1;
        }

        if(index == 0)
        {
            new year, month, day;
		    getdate(year, month, day);
            SendClientMessageEx(playerid, COLOR_GREEN, "----- Top Ranking Players %i/%i/%i -----", year, month, day);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "{FF7F27}#%i{FFFFFF} '%s' {22B14C}Points:{FFFFFF} %d/%d {22B14C}Current Rank:{FFFFFF} {%06x}%s (%d){FFFFFF}", last_rank, username, last_points, RanksList[nextrank][Rank_Points], RanksList[rankid][Rank_Color], RanksList[rankid][Rank_Name], rankid);

    }
    
    if(index == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no available data for the moment.");
    }

    return 1;
}

publish OnGetPlayerRank(playerid, targetid)
{
    new rows = cache_get_row_count(connectionID);
    if(rows != 1)
    {
        return SendClientMessageEx(playerid, COLOR_RED, "Internal error cannot extract player (%d) rank", targetid);
    }
    new pos = cache_get_field_content_int(0, "position") + 1;
    
    new rankid = GetPlayerRankID(targetid);
    new nextrank = rankid;

    if(rankid < sizeof(RanksList) - 1)
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
    if(PlayerData[playerid][pLevel] < MINIMUM_RANKING_LEVEL)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be level %d to be ranked.", MINIMUM_RANKING_LEVEL);
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT count(uid) as 'position' FROM "#TABLE_USERS" WHERE level > 2 AND rankingpoints > %i", PlayerRankPoints[playerid]);
    mysql_tquery(connectionID, queryBuffer, "OnGetPlayerRank", "ii", playerid, playerid);
    return 1;
}

CMD:rank(playerid, params[])
{
    new targetid;
    if(sscanf(params, "i", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rank [playerid]");
    }
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "Invalid player id.");
    }
    if(PlayerData[targetid][pLevel] < MINIMUM_RANKING_LEVEL)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "This player need to be level %d to be ranked.", MINIMUM_RANKING_LEVEL);
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT count(uid) as 'position' FROM "#TABLE_USERS" WHERE level > 2 AND rankingpoints > %i", PlayerRankPoints[targetid]);
    mysql_tquery(connectionID, queryBuffer, "OnGetPlayerRank", "ii", playerid, targetid);
    return 1;
}

CMD:topranks(playerid, params[])
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "select username,level,rankingpoints from "#TABLE_USERS" where level > 2 ORDER BY rankingpoints DESC,level DESC LIMIT 5");
    mysql_tquery(connectionID, queryBuffer, "OnGetTopPlayersRank", "i", playerid);
    return 1;
}

CMD:newseason(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
	if(isnull(params)) 
    {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /newseason [password]");
    }
    
	if(strcmp("d15q6a", params, true)) 
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid password!");
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[New season]: Decreasing gang ranking points");

    for(new gangid=0;gangid<MAX_GANGS;gangid++)
    {
	    if(GangInfo[gangid][gSetup])
        {
            GangInfo[gangid][gRankingPoints] = GangInfo[gangid][gRankingPoints] * 75 / 100;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "[New season]: Decreasing players ranking points");
    foreach(new targetid:Player)
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rankingpoints = %i WHERE uid = %i", PlayerRankPoints[playerid], PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
        PlayerRankPoints[playerid] = PlayerRankPoints[playerid] * 75 / 100;
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rankingpoints = rankingpoints * 75 / 100");
    mysql_tquery(connectionID, queryBuffer);
    SendClientMessage(playerid, COLOR_GREY, "[New season]: Please wait 10 seconds to have the gangs ranking points saved.");
    SendClientMessageToAll(COLOR_AQUA, "[News] New season has been started. All ranks has been decreased.");
    return 1;
}