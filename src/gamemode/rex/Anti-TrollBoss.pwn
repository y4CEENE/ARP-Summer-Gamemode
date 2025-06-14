#include <YSI\y_hooks>

//TODO: Anti-Flood Change seats

static TrollBossVehicle[MAX_PLAYERS];


PlayerTrollBoss(playerid, vehicleid)
{
    new driverid = INVALID_PLAYER_ID;

    foreach(new targetid:Player)
    {
        if(TrollBossVehicle[targetid] == vehicleid && targetid != playerid)
        {
            driverid = targetid;
            break;
        }
    }

    if(IsPlayerConnected(driverid))
    {
        SendAdminWarning(2, "[AntiCheat]: %s[%d] is posibble ussing troll cheats on vehicle %d (Driver: %s[%d]) %s", GetPlayerNameEx(playerid), playerid,vehicleid, GetPlayerNameEx(driverid), driverid);
    }
    else
    {
        SendAdminWarning(2, "[AntiCheat]: %s[%d] is posibble ussing troll cheats on vehicle %d (No driver)", GetPlayerNameEx(playerid), playerid,vehicleid);
    }
    
    return 1;
}

hook OnPlayerInit(playerid)
{
    TrollBossVehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    TrollBossVehicle[playerid] = vehicleid;

    return 1;
}

hook OnPlayerExitVehicle(playerid,vehicleid)
{
    TrollBossVehicle[playerid] = INVALID_VEHICLE_ID;
   
    return 1;
}


hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    //tb.fly state updates: 1->3  3->2 2->1
    if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_DRIVER)
    {
        PlayerTrollBoss(playerid, GetPlayerVehicleID(playerid));
        SetPlayerHealth(playerid, 0);
        BanPlayer(playerid, "TrollBoss");
    }

    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_PASSENGER)
    {
        BanPlayer(playerid, "TrollBoss");
    }

    //client: tb.kick 1 -> 2 Exit 2->1
    
    return 1;
}

//DEFINE_HOOK_REPLACEMENT(OnUnoccupied, OU_);

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 5.0)
    {
        return 0; // Reject the update
    }
 
    return 1;
}
