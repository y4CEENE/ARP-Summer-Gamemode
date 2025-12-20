
//#include <tp>
#include <YSI\y_hooks>


hook OnPlayerTeleport(playerid, Float:distance)
{

    if(!PlayerData[playerid][pLogged])
    {
	    return 1;
    }
    
    if(IsPlayerInTutorial(playerid))
    {
        return 1;
    }

    if(PlayerData[playerid][pKicked])
    {
        return 1;
    }

    if(IsAdminOnDuty(playerid, false))
    {
        return 1;
    }
    
    if(gettime() > PlayerData[playerid][pACTime])
    {
        return 1;
    }
    
    if(IsPlayerInRangeOfPoint(playerid, 3.0, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]))
    {
        return 1;
    }

    PlayerData[playerid][pACWarns]++;
    
    new vw       = PlayerData[playerid][pWorld];
    new interior = PlayerData[playerid][pInterior];
    new Float:x  = PlayerData[playerid][pPosX];
    new Float:y  = PlayerData[playerid][pPosY];
    new Float:z  = PlayerData[playerid][pPosZ];
    new Float:a;
    GetPlayerFacingAngle(playerid, a);
    
    TeleportToCoords(playerid, x, y, z, a, interior, vw, true);

    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport hacking (distance: %.1f).", GetRPName(playerid), playerid, distance);
    Log("Rex/Anti-TeleportHack.log", "%s (uid: %i) possibly teleport hacked (distance: %.1f)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], distance);

    // if(PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
    // {
    //     SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport hacking (distance: %.1f).", GetRPName(playerid), playerid, distance);
    //     Log_Write("log_cheat", "%s (uid: %i) possibly teleport hacked (distance: %.1f)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], distance);
    // }
    // else
    // {
    //     BanPlayer(playerid, "Teleport hacks");
    // }	

	return 1;
}


hook OnPlayerAirbreak(playerid)
{
    if(!PlayerData[playerid][pLogged])
    {
	    return 1;
    }

    if(IsPlayerInTutorial(playerid))
    {
        return 1;
    }

    if(PlayerData[playerid][pKicked])
    {
        return 1;
    }

    PlayerData[playerid][pACWarns]++;
    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using airbreak.", GetRPName(playerid), playerid);
    Log("Rex/Anti-TeleportHack.log", "%s (uid: %i) possibly used airbreak.", GetPlayerNameEx(playerid), PlayerData[playerid][pID]);

    // if(PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
    // {
    //     Log_Write("log_cheat", "%s (uid: %i) possibly used airbreak.", GetPlayerNameEx(playerid), PlayerData[playerid][pID]);
    // }
    // else
    // {
    //     BanPlayer(playerid, "Airbreak");
    // }

	return 1;
}


