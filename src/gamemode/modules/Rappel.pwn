/// @file      Rappel.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-04-09 22:49:41 +0200
/// @copyright Copyright (c) 2022


static HelicopterRope[58];

CMD:rappel(playerid,params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid) || !IsAnHelicopter(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY,"You need be in helicopter!");
    }

    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY,"Only helicopter passengers can rappel!");
    }

    if (GetVehicleSpeed(vehicleid) == 0.0)
    {
        return SendClientMessage(playerid, COLOR_GREY,"You cannot rappel now!");
    }

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }

    RemovePlayerFromVehicle(playerid);
    new Float:x, Float:y, Float:z,Float:a;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(playerid, x, y, z - 2);
    GetPlayerFacingAngle(playerid, a);
    Dyuze(playerid, "Notice", "~B~Rappelling");

    new offset = 5;
    for (new i = 0; i < 58; i++)
    {
        DestroyDynamicObject(HelicopterRope[i]);
        HelicopterRope[i] = CreateDynamicObject(19089, x, y, z + offset, 0, 0, a);
        offset -= 3;
    }
    ApplyAnimation(playerid,"ped","abseil",4.0,0,0,0,1,0);

    defer DestroyHelicopterRope(playerid);
    return 1;
}

timer DestroyHelicopterRope[5000](playerid)
{
    for (new i = 0; i < 58; i++)
    {
        DestroyDynamicObject(HelicopterRope[i]);
    }
    ClearAnimations(playerid);
    return 1;
}
