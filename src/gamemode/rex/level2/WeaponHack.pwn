#include <YSI\y_hooks>


hook OnPlayerAntiCheatCheck(playerid)
{
    new current_weapon = GetPlayerWeapon(playerid);

    if (current_weapon > 1 && !PlayerHasWeapon(playerid, current_weapon, true) && !PlayerData[playerid][pKicked])
    {
        PlayerData[playerid][pACTime] = gettime() + 5;
        SendAdminWarning(2, "%s[%i] has- a desynced %s (trying sync weapons).", GetRPName(playerid), playerid, GetWeaponNameEx(current_weapon));
        DBLog("log_cheat", "%s (uid: %i) had a desynced %s with %i ammunition.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetWeaponNameEx(current_weapon), GetPlayerAmmo(playerid));
        ResetPlayerWeapons(playerid);
        SetPlayerWeapons(playerid);
    }

    // Armor hacks
    if (!IsPlayerInEvent(playerid) && PlayerData[playerid][pPaintball] == 0 && !IsDueling(playerid))
    {
        new
            Float:armor;

        GetPlayerArmour(playerid, armor);

        if (floatround(armor) > floatround(PlayerData[playerid][pArmor]))
        {
            SendAdminWarning(2, "%s[%i] is possibly armor hacking. (old: %.2f, new: %.2f)", GetRPName(playerid), playerid, PlayerData[playerid][pArmor], armor);
            DBLog("log_cheat", "%s (uid: %i) possibly hacked armor. (old: %.2f, new: %.2f)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], PlayerData[playerid][pArmor], armor);
            SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);
        }
    }
    return 1;
}

CanPlayerShootWithWeapon(playerid, weaponid, hittype, hitid)
{
    if (hittype != BULLET_HIT_TYPE_PLAYER)
    {
        return 1;
    }
    if (!IsPlayerConnected(hitid))
    {
        return 0;
    }
    if (!IsValidWeaponID(weaponid))
    {
        return 0;
    }

    if ((PlayerData[playerid][pPaintball] > 0) && (GetPlayerVirtualWorld(playerid) != 1001 && GetPlayerVirtualWorld(playerid) != 1000))
    {
        if (gettime() - PlayerData[playerid][pLastShot] >= 3)
        {
            PlayerData[playerid][pLastShot] = gettime();
            ResetPlayerWeapons(playerid);
            SetPlayerWeapons(playerid);
            SendAdminWarning(2, "%s[%i] is using paintball weapons outside of paintball (trying sync weapons).", GetRPName(playerid), playerid);
            PlayerData[playerid][pACTime] = gettime() + 5;
        }

        return 0;
    }

    new entranceid;

    if (IsDueling(playerid) && !IsPlayerInRangeOfPoint(playerid, 150.0, 1419.6472, 4.0132, 1002.3906) && (entranceid = GetInsideEntrance(playerid)) != -1 && EntranceInfo[entranceid][eType] != 1)
    {
        if (gettime() - PlayerData[playerid][pLastShot] >= 3)
        {
            PlayerData[playerid][pLastShot] = gettime();
            ResetPlayerWeapons(playerid);
            SetPlayerWeapons(playerid);
            SendAdminWarning(2, "%s[%i] is using duel weapons outside of the duel arena (trying sync weapons).", GetRPName(playerid), playerid);
            PlayerData[playerid][pACTime] = gettime() + 5;
        }

        return 0;
    }

    if (!IsPlayerInEvent(playerid)  && !PlayerHasWeapon(playerid, weaponid, true) && !IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pKicked] && gettime() > PlayerData[playerid][pACTime])
    {
        PlayerData[playerid][pACTime] = gettime() + 5;
        SendAdminWarning(2, "%s[%i] has+ a desynced %s (trying sync weapons).", GetPlayerNameEx(playerid), playerid, GetWeaponNameEx(weaponid));
        ResetPlayerWeapons(playerid);
        SetPlayerWeapons(playerid);
        return 0;
    }

    if (hittype == BULLET_HIT_TYPE_PLAYER)
    {
        if (!IsPlayerInEvent(hitid) && !PlayerData[hitid][pPaintball])
        {
            GetPlayerArmour(hitid, PlayerData[hitid][pArmor]);
        }
        if (PlayerData[hitid][pNoDamage])
        {
            return 0;
        }
    }
    return 1;
}
