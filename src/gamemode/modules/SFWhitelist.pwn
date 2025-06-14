#include <YSI_Coding\y_hooks>

#define SFWHITELIST_MIN_LEVEL 17
static SFWhiteList[MAX_PLAYERS];
static SFW_PlayerHP[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    SFWhiteList[playerid] = 0;
    SFW_PlayerHP[playerid] = -1;
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    SFWhiteList[playerid] = cache_get_field_content_int(row, "sfwhitelist");
    return 1;
}
IsSFWhitelisted(playerid)
{
    return PlayerData[playerid][pLevel] >= SFWHITELIST_MIN_LEVEL && SFWhiteList[playerid];
}
hook OnPlayerHeartBeat(playerid)
{
    if(IsSFWhitelisted(playerid))
    {
        return 1;
    }

    if(!IsPlayerInRangeOfPoint(playerid, 1800.0, -2208.5339, 207.5916, 34.7299)) // SF Center
    {
        return 1;
    }
    
    if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0)
    {
        return 1;
    }

    if(IsAdmin(playerid))
    {
        return 1;
    }

    
    SendClientMessageEx(playerid, COLOR_RED, "[Area level %i+] You entered a danger zone. You must leave this area or you will die!", SFWHITELIST_MIN_LEVEL);
    

    if(SFW_PlayerHP[playerid] == -1)
    {
       SFW_PlayerHP[playerid] = GetPlayerHealthEx(playerid);
    }

    SFW_PlayerHP[playerid] -= 25;

    if(SFW_PlayerHP[playerid] <= 0)
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
    if(!IsAdmin(playerid, 6))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

    new targetid, value;
	if(sscanf(params, "ui", targetid, value))
	{
	    return SendSyntaxMessage(playerid, " /sfwhitelist [playerid] [0/1]");
	}
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Player id.");
    }

    if(value!=0)
    {
		SendAdminWarning(2, "AdmCmd: %s[%i] has added %s[%i] to sf whitelist.", GetRPName(playerid), playerid, GetRPName(targetid), targetid);
        
        SFWhiteList[targetid] = 1;
    }
    else
    {
		SendAdminWarning(2, "AdmCmd: %s[%i] has removed %s[%i] from sf whitelist.", GetRPName(playerid), playerid, GetRPName(targetid), targetid);

        SFWhiteList[targetid] = 0;
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET sfwhitelist=%i WHERE uid = %i", SFWhiteList[targetid], PlayerData[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    return 1;
}