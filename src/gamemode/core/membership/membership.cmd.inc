#include "core\membership\faction\faction.cmd.pwn"
#include "core\membership\gang\gang.cmd.pwn"

CMD:members(playerid, params[])
{
	if(PlayerData[playerid][pGang] != -1)
	{
		callcmd::gmembers(playerid, params);
	}
	if(PlayerData[playerid][pFaction] != -1)
	{
 		callcmd::fmembers(playerid, params);
	}
	return 1;
}

CMD:bk(playerid, params[])
{
	return callcmd::backup(playerid, params);
}

CMD:backup(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot call for backup when you are dead.");
	}
	if(PlayerData[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
	}
	if(PlayerData[playerid][pTied])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
	if(!PlayerData[playerid][pBackup])
	{
        PlayerData[playerid][pBackup] = 1;
	}
	else
	{
	    PlayerData[playerid][pBackup] = 0;
	}


	foreach(new i : Player)
	{
        switch(GetPlayerFaction(i))
		{
            case FACTION_POLICE, FACTION_MEDIC, FACTION_FEDERAL, FACTION_ARMY, FACTION_GOVERNMENT:
			{
	    	    if(PlayerData[playerid][pBackup])
	    	    {
	    	        SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: %s %s is requesting backup in %s (marked on map).", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
	    	        SetPlayerMarkerForPlayer(i, playerid, (FactionInfo[PlayerData[playerid][pFaction]][fColor] & ~0xff) + 0xFF);
				}
				else
				{
	    	        SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: %s %s has cancelled their backup request.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
	    	        SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
				}
			}
		}
	}

	return 1;
}
