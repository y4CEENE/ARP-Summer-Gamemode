#define MAX_NOP_WARNINGS 4

static NOPTrigger[MAX_PLAYERS];


ExecuteNOPAction(playerid)
{
    RemovePlayerFromVehicle(playerid);

    new newcar = GetPlayerVehicleID(playerid);

    if (NOPTrigger[playerid] >= MAX_NOP_WARNINGS)
    {
        KickPlayer(playerid, "Using illegal car", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
        return 1;
    }

    NOPTrigger[playerid]++;

    RemovePlayerFromVehicle(playerid);

    new Float:X, Float:Y, Float:Z;

    GetPlayerPos(playerid, X, Y, Z);

    SetPlayerPos(playerid, X, Y, Z+2);

    if (NOPTrigger[playerid] > 1)
    {
        new sec = (NOPTrigger[playerid] * 5) - 1;

        SendAdminWarning(2, "%s (ID %d) may be NOP hacking - restricted vehicle (model %d) for %d seconds.", GetPlayerNameEx(playerid), playerid, GetVehicleModel(newcar),sec);
    }
    return 1;
}

task NOPCarCheck[5000]()
{
    foreach(new playerid: Player)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if (vehicleid == 0)
        {
            continue;
        }
        if (GetPlayerVehicleSeat(playerid) != 0 && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        {
            continue;
        }
        else if (IsJobCar(vehicleid) && !CanEnterJobCar(playerid,vehicleid))
        {
            ExecuteNOPAction(playerid);
        }
        else if (VehicleInfo[vehicleid][vFaction] > -1 && (PlayerData[playerid][pFaction] != VehicleInfo[vehicleid][vFaction]))
        {
            ExecuteNOPAction(playerid);
        }
        else if (VehicleInfo[vehicleid][vGang] >= 0 && PlayerData[playerid][pGang] != VehicleInfo[vehicleid][vGang])
        {
            ExecuteNOPAction(playerid);
        }
        else if ((testVehicles[0] <= vehicleid <= testVehicles[4]) && !PlayerData[playerid][pDrivingTest])
        {
            ExecuteNOPAction(playerid);
        }
        //else if (IsAPlane(vehicleid)      && PlayerInfo[playerid][pFlyLic]  != 1) ExecuteNOPAction(playerid);
        else if (NOPTrigger[playerid] > 0)
        {
            NOPTrigger[playerid]--;
        }

        if (NOPTrigger[playerid] >= 15)
        {
            KickPlayer(playerid, "Suspected NOP hacks");
        }
    }
    return 1;
}
