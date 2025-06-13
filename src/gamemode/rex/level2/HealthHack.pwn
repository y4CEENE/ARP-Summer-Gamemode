#include <YSI\y_hooks>

static Float:PlayersHealth[MAX_PLAYERS];
static Float:VehicleHealth[MAX_VEHICLES];

task CheckHealth[1000]()
{
    new Float:hp;

    foreach(new vehicleid: Vehicle)
    {
        if (GetVehicleHealth(vehicleid, hp))
        {
            if (VehicleHealth[vehicleid] < hp)
            {
                if (IsPlayerInsidePaySpray(GetVehicleDriver(vehicleid)))
                {
                    VehicleHealth[vehicleid] = 1000.0;

                }
                SetVehicleHealth(vehicleid, VehicleHealth[vehicleid]);
            }
            else if (hp > 1.0 && hp < VehicleHealth[vehicleid])
            {
                VehicleHealth[vehicleid] = hp;
            }
        }
    }

    foreach(new playerid: Player)
    {
        GetPlayerHealth(playerid, hp);

        if (PlayersHealth[playerid] < hp)
        {
            if (NearVendingMachine(playerid))
            {
                PlayersHealth[playerid] += 35.0;

                if (PlayersHealth[playerid] > 100.0)
                {
                    PlayersHealth[playerid] = 100.0;
                }
            }

            SetPlayerHealth(playerid, PlayersHealth[playerid]);
        }
        else if (hp < PlayersHealth[playerid])
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
    if (newstate == PLAYER_STATE_SPECTATING)
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
    for (new vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        VehicleHealth[vehicleid] = 1000.0;
    }
    return 1;
}

stock IsPlayerImmune(playerid)
{
    return PlayersHealth[playerid] == 0.0;
}

rex_SetPlayerHealth(playerid, Float:hp)
{
    if (hp < 0.0)
    {
        hp = 0.0;
    }
    else if (hp >= 1048576.0)
    {
        hp = 1048575.0;
    }
    PlayersHealth[playerid] = hp;

    return SetPlayerHealth(playerid, hp);
}

#define SetPlayerHealth rex_SetPlayerHealth

rex_SetVehicleHealth(vehicleid, Float:hp)
{
    if (hp < 0.0)
    {
        hp = 0.0;
    }
    else if (hp >= 100000.0)
    {
        hp = 100000.0;
    }

    if (SetVehicleHealth(vehicleid, hp))
    {
        VehicleHealth[vehicleid] = hp;
        return true;
    }

    return false;
}

#define SetVehicleHealth rex_SetVehicleHealth


rex_RepairVehicle(vehicleid)
{
    if (RepairVehicle(vehicleid))
    {
        VehicleHealth[vehicleid] = 1000.0;
        return 1;
    }
    return 0;
}

#define RepairVehicle rex_RepairVehicle


rex_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{
    new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);

    if (vehicleid != INVALID_VEHICLE_ID && vehicleid != 0)
    {
        VehicleHealth[vehicleid] = 1000.0;
    }
    return vehicleid;
}
#if defined CreateVehicle
#undef CreateVehicle
#endif
#define CreateVehicle rex_CreateVehicle

static const Float:rex_vMachines[][] =
    {
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
        {2352.17, -1357.15, 23.77},
        {2325.97, -1645.13, 14.21},
        {2139.51, -1161.48, 23.35},
        {2153.23, -1016.14, 62.23},
        {1928.73, -1772.44, 12.94},
        {1154.72, -1460.89, 15.15},
        {2480.85, -1959.27, 12.96},
        {2060.11, -1897.64, 12.92},
        {1729.78, -1943.04, 12.94},
        {1634.1, -2237.53, 12.89},
        {1789.21, -1369.26, 15.16},
        {-2229.18, 286.41, 34.7},
        {2319.99, 2532.85, 10.21},
        {2845.72, 1295.04, 10.78},
        {2503.14, 1243.69, 10.21},
        {2647.69, 1129.66, 10.21},
        {-2420.21, 984.57, 44.29},
        {-2420.17, 985.94, 44.29},
        {2085.77, 2071.35, 10.45},
        {1398.84, 2222.6, 10.42},
        {1659.46, 1722.85, 10.21},
        {1520.14, 1055.26, 10.0},
        {-1980.78, 142.66, 27.07},
        {-2118.96, -423.64, 34.72},
        {-2118.61, -422.41, 34.72},
        {-2097.27, -398.33, 34.72},
        {-2092.08, -490.05, 34.72},
        {-2063.27, -490.05, 34.72},
        {-2005.64, -490.05, 34.72},
        {-2034.46, -490.05, 34.72},
        {-2068.56, -398.33, 34.72},
        {-2039.85, -398.33, 34.72},
        {-2011.14, -398.33, 34.72},
        {-1350.11, 492.28, 10.58},
        {-1350.11, 493.85, 10.58},
        {2222.36, 1602.64, 1000.06},
        {2222.2, 1606.77, 1000.05},
        {2155.9, 1606.77, 1000.05},
        {2155.84, 1607.87, 1000.06},
        {2209.9, 1607.19, 1000.05},
        {2202.45, 1617.0, 1000.06},
        {2209.24, 1621.21, 1000.06},
        {2576.7, -1284.43, 1061.09},
        {330.67, 178.5, 1020.07},
        {331.92, 178.5, 1020.07},
        {350.9, 206.08, 1008.47},
        {361.56, 158.61, 1008.47},
        {371.59, 178.45, 1020.07},
        {374.89, 188.97, 1008.47},
        {-19.03, -57.83, 1003.63},
        {-36.14, -57.87, 1003.63},
        {316.87, -140.35, 998.58},
        {2225.2, -1153.42, 1025.9},
        {-15.1, -140.22, 1003.63},
        {-16.53, -140.29, 1003.63},
        {-35.72, -140.22, 1003.63},
        {373.82, -178.14, 1000.73},
        {379.03, -178.88, 1000.73},
        {495.96, -24.32, 1000.73},
        {500.56, -1.36, 1000.73},
        {501.82, -1.42, 1000.73},
        {-33.87, -186.76, 1003.63},
        {-32.44, -186.69, 1003.63},
        {-16.11, -91.64, 1003.63},
        {-17.54, -91.71, 1003.63}
    };

static NearVendingMachine(playerid)
{
    new ac_i, ac_s;

    switch (GetPlayerInterior(playerid))
    {
        case 0: ac_i = 44, ac_s = -1;
        case 1: ac_i = 51, ac_s = 44;
        case 2: ac_i = 52, ac_s = 51;
        case 3: ac_i = 58, ac_s = 52;
        case 6: ac_i = 60, ac_s = 58;
        case 7: ac_i = 61, ac_s = 60;
        case 15: ac_i = 62, ac_s = 61;
        case 16: ac_i = 65, ac_s = 62;
        case 17: ac_i = 72, ac_s = 65;
        case 18: ac_i = 74, ac_s = 72;
        default: return 0;
    }
    for (; ac_i > ac_s; --ac_i)
    {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, rex_vMachines[ac_i][0], rex_vMachines[ac_i][1], rex_vMachines[ac_i][2]))
        {
            return true;
        }
    }
    return false;
}
