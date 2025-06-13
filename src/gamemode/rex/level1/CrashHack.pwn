/// @file      Anti-CrashHack.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-03-04 00:11:59 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

hook OnPlayerUpdate(playerid)
{
    if (IsAdminOnDuty(playerid, false))
    {
        return 1;
    }

    // Crash Hack:
    //   local sync = samp_create_sync_data('player')
    //   sync.weapon = 40
    //   sync.keysData = 128
    //   sync.send()
    if (GetPlayerWeapon(playerid) == 40)
    {
        if (PlayerData[playerid][pWeapons][GetWeaponSlot(40)] == 40)
        {
            RemovePlayerWeapon(playerid, 40);
            SendClientMessage(playerid, COLOR_GREY, "The detonator is not allowed in the server.");
        }
        else
        {
            KickPlayer(playerid, "Suspicious crash hack");
        }
        return 0;
    }
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (GetPlayerWeapon(playerid) == 40)
    {
        if (PlayerData[playerid][pWeapons][GetWeaponSlot(40)] == 40)
        {
            RemovePlayerWeapon(playerid, 40);
            SendClientMessage(playerid, COLOR_GREY, "The detonator is not allowed in the server.");
        }
        else
        {
            KickPlayer(playerid, "Suspicious crash hack");
        }
    }
    return 1;
}

CMD:checkcarmods(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_8))
        return 1;
    new line[256];
    new count=0;
    new total=0;
    foreach(new vehicleid: Vehicle)
    {
        total++;
        line = "";
        for (new i=0;i<14;i++)
        {
            new mod = GetVehicleComponentInSlot(vehicleid, i);
            if (mod != 0 && !IsVehicleUpgrade(vehicleid, mod))
            {
                format(line, sizeof(line), "%s[Slot=%i,Comp=%i]", line, i, mod);
            }
        }
        if (!isnull(line))
        {
            count++;
            SendClientMessageEx(playerid, COLOR_RED, "VehicleID: %d %s", vehicleid, line);
        }
    }
    SendClientMessageEx(playerid, COLOR_RED, "Total bugged vehicles: %d/%d", count, total);
    return 1;
}

CMD:fixcarmods(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_8))
        return 1;
    new line[256];
    new count=0;
    new total=0;
    foreach(new vehicleid: Vehicle)
    {
        total++;
        line = "";
        for (new i=0;i<14;i++)
        {
            new mod = GetVehicleComponentInSlot(vehicleid, i);
            if (mod != 0 && !IsVehicleUpgrade(vehicleid, mod))
            {
                RemoveVehicleComponent(vehicleid, mod);
                VehicleInfo[vehicleid][vMods][i] = 0;
                format(line, sizeof(line), "%s[Slot=%i,Comp=%i]", line, i, mod);
            }
        }
        if (!isnull(line))
        {
            count++;
            SendClientMessageEx(playerid, COLOR_RED, "VehicleID: %d %s", vehicleid, line);
        }
    }
    SendClientMessageEx(playerid, COLOR_RED, "Total fixed vehicles: %d/%d", count, total);
    return 1;
}
