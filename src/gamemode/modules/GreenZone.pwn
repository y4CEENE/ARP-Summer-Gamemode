/// @file      GreenZone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-30 23:52:03 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerInsideGreenZone[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    PlayerInsideGreenZone[playerid] = false;
    return 1;
}

task ServerMicrobeat[400]()
{
    foreach(new playerid: Player)
    {
        if (!IsPlayerInsideGreenZone(playerid))
        {
            PlayerInsideGreenZone[playerid] = false;
            continue;
        }
        if (!PlayerInsideGreenZone[playerid])
        {
            ShowNotification(playerid, "GreenZone: Shooting or killing is not allowed", NotificationType_Info);
            PlayerInsideGreenZone[playerid] = true;
        }
        if (PlayerData[playerid][pAdminDuty] != 0)
        {
            continue;
        }
        if (IsPlayerInAnyVehicle(playerid))
        {
            continue;
        }
        new weaponid = GetPlayerWeapon(playerid);

        if (PlayerData[playerid][pTazer] == 1 && weaponid == 23)
        {
            continue;
        }

        if (weaponid != 0 && weaponid < 43)
        {
            SetPlayerArmedWeapon(playerid,0); // disables weapon
            SendClientMessage(playerid, COLOR_RED, "You can't switch a weapon since you are in Green Zone.");
            SendClientMessage(playerid, COLOR_WHITE, "RULE: No shooting or killing in green zone, else prison for 5 minutes.");
        }
    }
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if ( !IsAdminOnDuty(playerid) &&
        amount > 0.0 &&
        IsPlayerInRangeOfPoint(damagedid, 100.0, 1201.0815, -1323.8598, 13.0767) ||  // Allsaints
        IsPlayerInRangeOfPoint(damagedid, 100.0, 1529.6000,-1691.2000,13.3828)   ||  // LSPD
        IsPlayerInRangeOfPoint(damagedid, 100.0, 2036.6906,-1408.4742,17.1641)   ||  // County hospital
        IsPlayerInRangeOfPoint(damagedid, 100.0, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]))      // Spawn
    {
        SendClientMessage(playerid, COLOR_WHITE, "RULE: No shooting or killing in green zone.");
        GivePlayerHealth(playerid, -2.0*amount);
    }
    return 1;
}
