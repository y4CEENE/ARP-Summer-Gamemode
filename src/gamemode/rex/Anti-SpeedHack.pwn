
hook OnPlayerHeartBeat(playerid)
{

    if(IsPlayerInTutorial(playerid))
    {
        return 1;
    }

    if(PlayerData[playerid][pKicked])
    {
        return 1;
    }

    if(gettime() > PlayerData[playerid][pACTime])
    {
        return 1;
    }

    if(IsAdminOnDuty(playerid, false))
    {
        return 1;
    }

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return 1;
    }
    
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:vehiclespeed = GetVehicleSpeed(vehicleid);

    if(IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
    {
        return 1;
    }

    if(vehiclespeed > 350)
    {
        new username[32];
        GetPlayerName(playerid, username, sizeof(username));
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly speedhacking, speed: %.1f km/h.", username, playerid, vehiclespeed);
        Log("Rex/Anti-SpeedHack.log", "%s (uid: %i) possibly speedhacked, speed: %.1f km/h", username, PlayerData[playerid][pID], vehiclespeed);
        Log_Write("log_cheat", "%s (uid: %i) possibly speedhacked, speed: %.1f km/h", username, PlayerData[playerid][pID], vehiclespeed);
    }
}