/// @file      Weapon.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022



GetCraftWeaponPrice(playerid, weaponid)
{
    new cost = -1;

    switch (weaponid)
    {
        case  2: cost =   200; // Golf Club
        case  5: cost =   200; // Baseball Bat
        case  6: cost =   200; // Shovel
        case  7: cost =   200; // Pool Cue
        case  8: cost = 20000; // Katana
        case 10: cost =    50; // Purple Dildo
        case 14: cost =    50; // Flowers
        case 15: cost =   200; // Cane
        case 22: cost =  1500; // 9mm
        case 23: cost =  2250; // Silenced 9mm
        case 24: cost =  5000; // Desert Eagle
        case 25: cost =  2500; // Shotgun
        case 28: cost =  3500; // Micro SMG/Uzi
        case 29: cost =  5000; // MP5
        case 30: cost =  5000; // AK-47
        case 31: cost =  6000; // M4
        case 32: cost =  4500; // Tec-9
        case 33: cost =  1500; // Country Rifle
        case 34: cost =  12000; // Sniper Rifle
    }

    if (PlayerData[playerid][pDonator] == 3)
    {

        switch (weaponid)
        {
            case  8: cost = 15000; // Katana
            case 27: cost = 10000; // Combat Shotgun
            case 34: cost = 10000; // Sniper Rifle
        }
    }

    return cost;
}

GetGStashCraftWeaponPrice(weaponid)
{
    new cost = -1;

    switch (weaponid)
    {
        case 22: cost =   500; // 9mm
        case 23: cost =   750; // Silenced 9mm
        case 25: cost =  1000; // Shotgun
        case 28: cost =  2500; // Micro SMG/Uzi
        case 32: cost =  2000; // Tec-9
        case 33: cost =  1500; // Country Rifle
    }
    return cost;
}

SellWeapon(playerid, targetid, weaponid, price = 0)
{
    new cost = GetCraftWeaponPrice(playerid, weaponid);

    if (cost == -1)
    {
        return SendClientMessageEx(playerid, COLOR_AQUA, "You cannot craft this weapon {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
    }

    if (PlayerData[playerid][pMaterials] >= cost)
    {
        PlayerData[playerid][pMaterials] -= cost;
        PlayerData[playerid][pLastSell] = gettime();
        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);

        if (targetid == playerid)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have crafted yourself a {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
            ShowActionBubble(playerid, "* %s puts together some materials and crafts themselves a %s.", GetRPName(playerid), GetWeaponNameEx(weaponid));
        }
        else
        {
            ShowActionBubble(playerid, "* %s puts together some materials and crafts a %s for %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You have sold %s a {FF6347}%s{33CCFF} for {00AA00}%s{33CCFF}.", GetRPName(targetid), GetWeaponNameEx(weaponid), FormatCash(price));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has sold you a {FF6347}%s{33CCFF} for {00AA00}%s{33CCFF}.", GetRPName(playerid), GetWeaponNameEx(weaponid), FormatCash(price));
            GivePlayerCash(playerid, price);
            GivePlayerCash(targetid, -price);
        }

        if (weaponid >= 22)
        {
            IncreaseJobSkill(playerid, JOB_ARMSDEALER);
        }

        GivePlayerWeaponEx(targetid, weaponid);

        GiveNotoriety(playerid, 5);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for trafficking, you now have %d.", PlayerData[playerid][pNotoriety]);
        GiveNotoriety(targetid, 5);
        SendClientMessageEx(targetid, COLOR_AQUA, "You have gained 5 notoriety for trafficking, you now have %d.", PlayerData[targetid][pNotoriety]);

        return 1;
    }
    else
    {
        SendClientMessage(targetid, COLOR_GREY, "That player has ran out of materials.");
    }

    return 0;
}

CMD:dropgun(playerid, params[])
{
    new weaponid = GetScriptWeapon(playerid), objectid, Float:x, Float:y, Float:z;

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to drop weapons.");
    }
    if (!weaponid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be holding the weapon you're willing to drop.");
    }
    if (PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell this weapon as you don't have it.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (GetPlayerHealthEx(playerid) < 60)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't drop weapons as your health is below 60.");
    }

    GetPlayerPos(playerid, x, y, z);

    new weaponmodelid = GetWeaponModelID(weaponid);

    if (!weaponmodelid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Internal error: Cannot get weapon model id.");
    }
    objectid = CreateDynamicObject(weaponmodelid, x, y, z - 1.0, 93.7, 93.7, 120.0);
    SetTimerEx("DestroyWeapon", 300000, false, "i", objectid);
    Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_WEAPON);
    Streamer_SetExtraInt(objectid, E_OBJECT_WEAPONID, weaponid);
    Streamer_SetExtraInt(objectid, E_OBJECT_FACTION, PlayerData[playerid][pFaction]);
    RemovePlayerWeapon(playerid, weaponid);



    ShowActionBubble(playerid, "* %s drops their %s on the ground.", GetRPName(playerid), GetWeaponNameEx(weaponid));
    SendClientMessageEx(playerid, COLOR_AQUA, "You have dropped your {00AA00}%s{33CCFF}.", GetWeaponNameEx(weaponid));
    return 1;
}

CMD:grabgun(playerid, params[])
{
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to pickup weapons.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }

    for (new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
    {
        if (!IsValidDynamicObject(i) || !IsPlayerInRangeOfDynamicObject(playerid, i, 2.0) || Streamer_GetExtraInt(i, E_OBJECT_TYPE) != E_OBJECT_WEAPON)
            continue;

        if (Streamer_GetExtraInt(i, E_OBJECT_FACTION) >= 0 && PlayerData[playerid][pFaction] != Streamer_GetExtraInt(i, E_OBJECT_FACTION))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This weapon belongs to a specific faction. You may not pick it up.");
        }

        new weaponid = Streamer_GetExtraInt(i, E_OBJECT_WEAPONID);

        GivePlayerWeaponEx(playerid, weaponid);
        DestroyDynamicObject(i);

        ShowActionBubble(playerid, "* %s picks up a %s from the ground.", GetRPName(playerid), GetWeaponNameEx(weaponid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have picked up a {00AA00}%s{33CCFF}.", GetWeaponNameEx(weaponid));
        return 1;
    }
    new targetid = GetClosestPlayer(playerid);
    if (IsPlayerConnected(targetid) && PlayerData[targetid][pInjured] && IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        if (GetPlayerFaction(targetid) == FACTION_HITMAN && GetPlayerFaction(playerid) != FACTION_HITMAN)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot steal weapon from this player.");
        }
        new weaponid = strval(params);
        if (weaponid && PlayerHasWeapon(targetid, weaponid, true))
        {
            if (PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)])
            {
                return SendClientMessage(playerid, COLOR_GREY, "You already have a weapon in this slot.");
            }
            if (weaponid > 34)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You cannot steal this weapon.");
            }
            if ((PlayerData[playerid][pFaction] == -1 && PlayerData[targetid][pFaction] != -1) ||
               (PlayerData[playerid][pFaction] != -1 && PlayerData[targetid][pFaction] == -1))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You cannot steal this weapon.");
            }
            RemovePlayerWeapon(targetid, weaponid);
            GivePlayerWeaponEx(playerid, weaponid);
            SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s has stole the %s from %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
            return 1;
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s's Weapons _______", GetRPName(targetid));

            for (new i = 0; i < 13; i ++)
            {
                new weapon, ammo;

                GetPlayerWeaponData(targetid, i, weapon, ammo);

                if (weapon && PlayerHasWeapon(targetid, weapon, true))
                {
                    SendClientMessageEx(playerid, COLOR_GREY2, "-> %i %s",weapon, GetWeaponNameEx(weapon));
                }
            }
            SendUsageHeader(playerid, "grabgun", "[weaponid]");
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any dropped weapons.");
    return 1;
}
