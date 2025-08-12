// No YSI include here

new Flasher[MAX_VEHICLES];
new FlasherState[MAX_VEHICLES];

public OnGameModeInit()
{
    for (new x = 0; x < MAX_VEHICLES; x++)
    {
        Flasher[x] = 0;
        FlasherState[x] = 0;
    }
    SetTimer("FlasherFunc", 200, true); // no FlashTimer var since we don't stop it
    return 1;
}

forward FlasherFunc();
public FlasherFunc()
{
    new panelsx, doorsx, lightsx, tiresx;
    for (new p = 0; p < MAX_VEHICLES; p++)
    {
        if (Flasher[p] == 1)
        {
            GetVehicleDamageStatus(p, panelsx, doorsx, lightsx, tiresx);
            if (FlasherState[p] == 1)
            {
                UpdateVehicleDamageStatus(p, panelsx, doorsx, 4, tiresx);
                FlasherState[p] = 0;
            }
            else
            {
                UpdateVehicleDamageStatus(p, panelsx, doorsx, 1, tiresx);
                FlasherState[p] = 1;
            }
        }
    }
    return 1;
}

CMD:flash(playerid, params[])
{
    new vehicleid, panels, doors, lights, tires;
    vehicleid = GetPlayerVehicleID(playerid);

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't part of law enforcement.");

    if (PlayerData[playerid][pDuty] == 0)
        return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SCM(playerid, COLOR_WHITE, "You are not the driver.");

    if (!IsPlayerInAnyVehicle(playerid))
        return SCM(playerid, COLOR_WHITE, "You are not in a vehicle!");

    if (!Flasher[vehicleid])
    {
        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        SetVehicleParams(vehicleid, VEHICLE_LIGHTS, true);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE,
            "**{C2A2DA} %s turns on the emergency lights of the %s.",
            GetRPName(playerid), GetVehicleName(vehicleid));
        Flasher[vehicleid] = 1;
    }
    else
    {
        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        UpdateVehicleDamageStatus(vehicleid, panels, doors, 5, tires);
        Flasher[vehicleid] = 0;
        SetVehicleParams(vehicleid, VEHICLE_LIGHTS, false);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE,
            "**{C2A2DA} %s turns off the emergency lights of the %s.",
            GetRPName(playerid), GetVehicleName(vehicleid));
    }
    return 1;
}
