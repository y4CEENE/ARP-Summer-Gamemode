/// @file      Skate.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022


CMD:skate(playerid,params[])
{
    if (!PlayerData[playerid][pSkates])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You do not own any skates.");
    }
    if (!IsPlayerInAnyVehicle(playerid))
    {
        ApplyAnimation(playerid, "CARRY","null",0,0,0,0,0,0,0);
        ApplyAnimation(playerid, "SKATE","null",0,0,0,0,0,0,0);
        ApplyAnimation(playerid, "CARRY","crry_prtial",4.0,0,0,0,0,0);
        SetPlayerArmedWeapon(playerid,0);
        if (!PlayerData[playerid][pSkating])
        {
            PlayerData[playerid][pSkating] = true;
            DestroyDynamicObject(PlayerData[playerid][pSkateObj]);
            RemovePlayerAttachedObject(playerid, 5);
            SetPlayerAttachedObject(playerid, 5,19878,6,-0.055999,0.013000,0.000000,-84.099983,0.000000,-106.099998,1.000000,1.000000,1.000000);
            PlayerPlaySound(playerid,21000,0,0,0);
            SendClientMessage(playerid, COLOR_AQUA,"You have equiped your skating gear. Press RMB or Aim Key to skate.");
        }
        else
        {
            PlayerData[playerid][pSkating] = false;
            DestroyDynamicObject(PlayerData[playerid][pSkateObj]);
            RemovePlayerAttachedObject(playerid, 5);
            PlayerPlaySound(playerid,21000,0,0,0);
            SendClientMessage(playerid, COLOR_AQUA, "You are no longer skating.");
        }
    }
    else SendClientMessage(playerid, COLOR_GREY, "You must not be inside a vehicle.");
    return 1;
}
