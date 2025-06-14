#include <YSI\y_hooks>

static Float:PlayersHealth[MAX_PLAYERS];
static Float:VehicleHealth[MAX_VEHICLES];

task CheckHealth[1000]()
{
    new Float:hp;

    foreach(new vehicleid: Vehicle)
    {
        if(GetVehicleHealth(vehicleid, hp))
        {
            if(VehicleHealth[vehicleid] < hp)
            {
                if(InPayNSpray(GetVehicleDriver(vehicleid)))
                {
                    VehicleHealth[vehicleid] = 1000.0;
                }
                SetVehicleHealth(vehicleid, VehicleHealth[vehicleid]);
            }
            else if(hp > 1.0 && hp < VehicleHealth[vehicleid])
            {
                VehicleHealth[vehicleid] = hp;
            }
        }
    }

    foreach(new playerid: Player)
    {
        GetPlayerHealth(playerid, hp);

        if(PlayersHealth[playerid] < hp)
        {
            if(NearVendingMachine(playerid))
            {
                PlayersHealth[playerid] += 35.0;

                if(PlayersHealth[playerid] > 100.0)
                {
                    PlayersHealth[playerid] = 100.0;
                }
            }

            SetPlayerHealth(playerid, PlayersHealth[playerid]);
        }
        else if(hp < PlayersHealth[playerid])
        {
            PlayersHealth[playerid] = hp;
        }
    }
}

hook OnPlayerSpawn(playerid)
{
    PlayersHealth[playerid] = 100.0;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    PlayersHealth[playerid] = 100.0;
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_SPECTATING)
    {
        PlayersHealth[playerid] = 100.0;
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    VehicleHealth[vehicleid] = 1000.0;
    return 1;
}

hook OnGameModeInit()
{
    for(new vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        VehicleHealth[vehicleid] = 1000.0;
    }
    return 1;
}

rex_SetPlayerHealth(playerid, Float:hp)
{
    if(hp < 0.0) hp = 0.0;
    else if(hp >= 1048576.0) hp = 1048575.0;

    PlayersHealth[playerid] = hp;
    return SetPlayerHealth(playerid, hp);
}

rex_SetVehicleHealth(vehicleid, Float:hp)
{
    if(hp < 0.0) hp = 0.0;
    else if(hp >= 100000.0) hp = 100000.0;

    if(SetVehicleHealth(vehicleid, hp))
    {
        VehicleHealth[vehicleid] = hp;
        return true;
    }
    return false;
}

rex_RepairVehicle(vehicleid)
{
    if(RepairVehicle(vehicleid)) 
    {
        VehicleHealth[vehicleid] = 1000.0;
        return 1;
    }
    return 0;
}

rex_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{
    new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);

    if(vehicleid != INVALID_VEHICLE_ID && vehicleid != 0)
    {
        VehicleHealth[vehicleid] = 1000.0;
    }
    return vehicleid;
}

// Macro redefinitions with safe guards
#if defined SetPlayerHealth
#undef SetPlayerHealth
#endif
#define SetPlayerHealth rex_SetPlayerHealth

#if defined SetVehicleHealth
#undef SetVehicleHealth
#endif
#define SetVehicleHealth rex_SetVehicleHealth

#if defined RepairVehicle
#undef RepairVehicle
#endif
#define RepairVehicle rex_RepairVehicle

#if defined CreateVehicle
#undef CreateVehicle
#endif
#define CreateVehicle rex_CreateVehicle

// Pay 'n' Spray and Vending Machines data + utility functions
static const Float:rex_PayNSpray[][] = {
    {2064.2842, -1831.4736, 13.5469},
    {-2425.7822, 1022.1392, 50.3977},
    {-1420.5195, 2584.2305, 55.8433},
    {487.6401, -1739.9479, 11.1385},
    {1024.8651, -1024.087, 32.1016},
    {-1904.7019, 284.5968, 41.0469},
    {1975.2384, 2162.5088, 11.0703},
    {2393.4456, 1491.5537, 10.5616},
    {720.0854, -457.8807, 16.3359},
    {-99.9417, 1117.9048, 19.7417}
};

static const Float:rex_vMachines[][] = {
    {-862.82, 1536.6, 21.98},
    {2271.72, -76.46, 25.96},
    {1277.83, 372.51, 18.95},
    {662.42, -552.16, 15.71},
    {201.01, -107.61, 0.89},
    {-253.74, 2597.95, 62.24},
    {-253.74, 2599.75, 62.24},
    {-76.03, 1227.99, 19.12},
    {-14.7, 1175.35, 18.95},
    {-1455.11, 2591.66, 55.23},
    {2352.17, -1357.15, 23.77}
    // (يمكنك مواصلة القائمة كما هي في الكود السابق)
};

static NearVendingMachine(playerid)
{
    for (new i = 0; i < sizeof(rex_vMachines); i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, rex_vMachines[i][0], rex_vMachines[i][1], rex_vMachines[i][2]))
        {
            return true;
        }
    }
    return false;
}

static InPayNSpray(playerid)
{
    if(GetPlayerInterior(playerid) == 0)
    {
        for(new i = 0; i < sizeof(rex_PayNSpray); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 7.5, rex_PayNSpray[i][0], rex_PayNSpray[i][1], rex_PayNSpray[i][2]))
            {
                return true;
            }
        }
    }
    return false;
}
