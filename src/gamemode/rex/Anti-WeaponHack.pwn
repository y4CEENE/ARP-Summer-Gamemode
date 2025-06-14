#include <YSI\y_hooks>


hook OnPlayerHeartBeat(playerid)
{

    if(!PlayerData[playerid][pLogged])
    {
	    return 1;
    }
    
    if(IsPlayerInTutorial(playerid))
    {
        return 1;
    }

    if(PlayerData[playerid][pKicked])
    {
        return 1;
    }

    if(gettime() <= PlayerData[playerid][pACTime])
    {
        return 1;
    }

    if(IsAdminOnDuty(playerid, false))
    {
        return 1;
    }

    if(IsPlayerInEvent(playerid))
    {
        return 1;
    }

    new current_weapon = GetPlayerWeapon(playerid);

    if(current_weapon > 1 && !PlayerHasWeapon(playerid, current_weapon, true) && !PlayerData[playerid][pKicked])
    {
        PlayerData[playerid][pACTime] = gettime() + 5;
        SendAdminWarning(2, "%s[%i] has- a desynced %s (trying sync weapons).", GetRPName(playerid), playerid, GetWeaponNameEx(current_weapon));
        Log_Write("log_cheat", "%s (uid: %i) had a desynced %s with %i ammunition.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetWeaponNameEx(current_weapon), GetPlayerAmmo(playerid));
    	ResetPlayerWeapons(playerid);
   		SetPlayerWeapons(playerid);
    }

    // Jetpack
    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && !PlayerData[playerid][pJetpack])
    {
        BanPlayer(playerid, "Jetpack");
    }

    // Armor hacks
    if(!IsPlayerInEvent(playerid) && PlayerData[playerid][pPaintball] == 0 && PlayerData[playerid][pDueling] == INVALID_PLAYER_ID)
    {
        new
            Float:armor;

        GetPlayerArmour(playerid, armor);

        if(floatround(armor) > floatround(PlayerData[playerid][pArmor]))
        {
            SendAdminWarning(2, "%s[%i] is possibly armor hacking. (old: %.2f, new: %.2f)", GetRPName(playerid), playerid, PlayerData[playerid][pArmor], armor);
            Log_Write("log_cheat", "%s (uid: %i) possibly hacked armor. (old: %.2f, new: %.2f)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], PlayerData[playerid][pArmor], armor);
            SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);
        }
    }
    return 1;
}

CanPlayerShootWithWeapon(playerid, weaponid, hittype, hitid)
{
    if(hittype == BULLET_HIT_TYPE_VEHICLE)
    {
        return 1;
    }
	if((PlayerData[playerid][pPaintball] > 0) && (GetPlayerVirtualWorld(playerid) != 1001 && GetPlayerVirtualWorld(playerid) != 1000))
	{
	    if(gettime() - PlayerData[playerid][pLastShot] >= 3)
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

	if(PlayerData[playerid][pDueling] != INVALID_PLAYER_ID && !IsPlayerInRangeOfPoint(playerid, 150.0, 1419.6472, 4.0132, 1002.3906) && (entranceid = GetInsideEntrance(playerid)) != -1 && EntranceInfo[entranceid][eType] != 1)
	{
	    if(gettime() - PlayerData[playerid][pLastShot] >= 3)
	    {
			PlayerData[playerid][pLastShot] = gettime();
            ResetPlayerWeapons(playerid);
            SetPlayerWeapons(playerid);
		    SendAdminWarning(2, "%s[%i] is using duel weapons outside of the duel arena (trying sync weapons).", GetRPName(playerid), playerid);
            PlayerData[playerid][pACTime] = gettime() + 5;
		}

		return 0;
	}

	if(!IsPlayerInEvent(playerid)  && !PlayerHasWeapon(playerid, weaponid, true) && PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && !PlayerData[playerid][pKicked] && gettime() > PlayerData[playerid][pACTime])
	{
        PlayerData[playerid][pACTime] = gettime() + 5;
        SendAdminWarning(2, "%s[%i] has+ a desynced %s (trying sync weapons).", GetPlayerNameEx(playerid), playerid, GetWeaponNameEx(weaponid));
    	ResetPlayerWeapons(playerid);
   		SetPlayerWeapons(playerid);
	    return 0;
	}

	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
	    if(!IsPlayerInEvent(hitid) && !PlayerData[hitid][pPaintball] && PlayerData[hitid][pDueling] == INVALID_PLAYER_ID)
		{
	    	GetPlayerArmour(hitid, PlayerData[hitid][pArmor]);
		}
	}
    if(hitid != INVALID_PLAYER_ID && PlayerData[hitid][pNoDamage])
    {
        return 0;
    }
	return 1;
}
