/// @file      PaintBall.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

new const Float:paintballTSpawns[][] =
{ // TDM Arena
    //   X         Y        Z          R
    {1303.8156, 1.8952, 1001.0244, 146.4729}, // Team 1
    {1260.6339, -66.3295, 1002.4949, 318.4712} // Team 2
};
new const Float:paintballDSpawns[][] =
{ // Deagle Arena
    //   X         Y        Z          R
    {1299.0728, 2103.4670, 11.0234, 10.4824},
    {1298.5331, 2196.3188, 11.0234, 2.9623},
    {1397.0685, 2101.0967, 11.0234, 260.1884},
    {1315.7385, 2206.4363, 16.8045, 205.3078},
    {1388.1871, 2206.5242, 16.7969, 267.3483},
    {1407.4728, 2140.1846, 17.6797, 195.9077},
    {1411.0127, 2107.6167, 12.0156, 172.0940},
    {1399.2078, 2206.6550, 12.0156, 213.8402},
    {1301.0807, 2212.7083, 12.0156, 92.1932}
};
new const Float:paintballSSpawns[][] =
{ // Sniper Arena
    //   X         Y        Z          R
    {-2233.8169, -1743.4373, 480.8561, 37.9961},
    //{-2386.9824, -1841.8787, 441.4585, 356.9490},
    {-2351.9800, -1714.6760, 479.6617, 27.9689},
    {-2344.3889, -1703.7188, 483.6255, 326.3146},
    {-2425.2998, -1623.8129, 524.8774, 212.5245}
};
new const Float:paintballFSpawns[][] =
{// FFA Arena
    //   X         Y        Z          R
    {1291.2968, -0.1334, 1001.0228, 180.0000},
    {1304.6259, -28.7442, 1001.0326, 90.0000},
    {1260.6687, -0.6802, 1001.0234, 180.0000},
    {1251.9862, -26.3548, 1001.0340, 270.0000},
    {1278.8584, -44.1545, 1001.0236, 0.0000},
    {1256.5944, -61.9047, 1002.4999, 0.0000},
    {1297.3204, -61.4144, 1002.4980, 0.0000}
};
new area_paintball[2];
new zone_paintball[2];

hook OnPlayerReset(playerid)
{
    if (PlayerData[playerid][pPaintball] > 0)
    {
        ResetPlayerWeapons(playerid);
        PlayerData[playerid][pPaintball] = 0;
        PlayerData[playerid][pPaintballTeam] = -1;
    }
    return 1;
}

hook OnPlayerInit(playerid)
{
    // Paintball
    zone_paintball[0] = GangZoneCreateEx(1287.0806, 2055.0513, 1487.7770, 2275.3984);
    area_paintball[0] = CreateDynamicRectangle(1287.0806, 2055.0513, 1487.7770, 2275.3984);
    // Sniper
    zone_paintball[1] = GangZoneCreateEx(-2591.2288, -1814.2455, -2178.9082, -1394.5500);
    area_paintball[1] = CreateDynamicRectangle(-2591.2288, -1814.2455, -2178.9082, -1394.5500);
    return 1;
}

hook OP_LeaveDynamicArea(playerid, areaid)
{
    if (gettime() - PlayerData[playerid][pLastDeath] > 10 && (areaid == area_paintball[0] || areaid == area_paintball[1]))
    {
        if (PlayerData[playerid][pPaintball] == 3 || PlayerData[playerid][pPaintball] == 4)
        {
            SendClientMessage(playerid, COLOR_RED, "You were poisoned to death for leaving the arena. (Use /exit)");
            SetPlayerHealth(playerid, 0.0);
        }
    }
    return 1;
}

Dialog:DIALOG_PAINTBALL(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        ShowActionBubble(playerid, "* %s has entered the paintball arena.", GetRPName(playerid));
        SetPlayerInPaintball(playerid, listitem+1);

        foreach(new i : Player)
        {
            if (PlayerData[playerid][pPaintball] == PlayerData[i][pPaintball])
            {
                SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s has entered the paintball arena. ))", GetRPName(playerid));
            }
        }
    }
    return 1;
}

SetPlayerInPaintball(playerid, type)
{
    if (PlayerData[playerid][pPaintball] == 0)
    {
        SavePlayerVariables(playerid);
        ResetPlayerWeapons(playerid);
    }
    if (type == 1)
    {
        new rand = random(sizeof(paintballFSpawns));
        SetPlayerPos(playerid, paintballFSpawns[rand][0], paintballFSpawns[rand][1], paintballFSpawns[rand][2]);
        SetPlayerFacingAngle(playerid, paintballFSpawns[rand][3]);
        SetPlayerInterior(playerid, 18);
        SetPlayerVirtualWorld(playerid, 1000);
        SetCameraBehindPlayer(playerid);

        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 100.0);

        GivePlayerWeaponEx(playerid, 24, true);
        GivePlayerWeaponEx(playerid, 27, true);
        GivePlayerWeaponEx(playerid, 29, true);
        GivePlayerWeaponEx(playerid, 31, true);
        GivePlayerWeaponEx(playerid, 34, true);

        PlayerData[playerid][pPaintball] = 1;
    }
    else if (type == 2)
    {
        SetPlayerPos(playerid, paintballTSpawns[pbNext][0], paintballTSpawns[pbNext][1], paintballTSpawns[pbNext][2]);
        SetPlayerFacingAngle(playerid, paintballTSpawns[pbNext][3]);
        SetPlayerInterior(playerid, 18);
        SetPlayerVirtualWorld(playerid, 1001);
        SetCameraBehindPlayer(playerid);

        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 100.0);

        GivePlayerWeaponEx(playerid, 24, true);
        GivePlayerWeaponEx(playerid, 27, true);
        GivePlayerWeaponEx(playerid, 29, true);
        GivePlayerWeaponEx(playerid, 31, true);
        GivePlayerWeaponEx(playerid, 34, true);

        PlayerData[playerid][pPaintball] = 2;
        PlayerData[playerid][pPaintballTeam] = pbNext;
        if (!pbNext)
        {
            pbNext = 1;
        }
        else
        {
            pbNext = 0;
        }
    }
    else if (type == 3)
    {
        new rand = random(sizeof(paintballDSpawns));
        SetPlayerPos(playerid, paintballDSpawns[rand][0], paintballDSpawns[rand][1], paintballDSpawns[rand][2]);
        SetPlayerFacingAngle(playerid, paintballDSpawns[rand][3]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 1000);
        SetCameraBehindPlayer(playerid);

        GangZoneShowForPlayer(playerid, zone_paintball[0], 0xFFFF0096);

        SetPlayerHealth(playerid, 25.0);
        SetPlayerArmour(playerid, 0.0);

        GivePlayerWeaponEx(playerid, 24, true);

        PlayerData[playerid][pPaintball] = 3;
    }
    else if (type == 4)
    {
        new rand = random(sizeof(paintballSSpawns));
        SetPlayerPos(playerid, paintballSSpawns[rand][0], paintballSSpawns[rand][1], paintballSSpawns[rand][2]);
        SetPlayerFacingAngle(playerid, paintballSSpawns[rand][3]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 1001);
        SetCameraBehindPlayer(playerid);

        GangZoneShowForPlayer(playerid, zone_paintball[1], 0xFFFF0096);

        SetPlayerHealth(playerid, 38.0);
        SetPlayerArmour(playerid, 0.0);

        GivePlayerWeaponEx(playerid, 34, true);

        PlayerData[playerid][pPaintball] = 4;
    }
}
CMD:paintball(playerid,params[])
{
    if (PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || IsDueling(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    if (IsPlayerInRangeOfPoint(playerid, 3.0, 1311.7522,-1367.2715,13.53) ||
       IsPlayerInRangeOfPoint(playerid, 3.0, -1549.7334,1165.4608,7.1875))
    {
        if (PlayerData[playerid][pAcceptedHelp])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can not enter the paintball arena while on helper duty!");
        }
        if (PlayerData[playerid][pWeaponRestricted] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are restricted from weapons and therefore can't join paintball.");
        }
        ShowDialogToPlayer(playerid, DIALOG_PAINTBALL);
    }
    else
        return SendClientMessage(playerid, COLOR_GREY, "You are not near paintball!");
    return 1;
}

CMD:quitpaintball(playerid, params[])
{
    return callcmd::exitpaintball(playerid, params);
}
CMD:exitpaintball(playerid,params[])
{
    if (PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || IsDueling(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    if (PlayerData[playerid][pPaintball] > 0)
    {
        foreach(new i : Player)
        {
            if (PlayerData[playerid][pPaintball] == PlayerData[i][pPaintball])
            {
                SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s has left the paintball arena. ))", GetRPName(playerid));
            }
        }

        ResetPlayerWeapons(playerid);
        SetPlayerArmedWeapon(playerid, 0);
        PlayerData[playerid][pPaintball] = 0;
        PlayerData[playerid][pPaintballTeam] = -1;
        GangZoneHideForPlayer(playerid, zone_paintball[0]);
        GangZoneHideForPlayer(playerid, zone_paintball[1]);
        SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
        SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);
        SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
        SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
        SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
        SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
        SetPlayerWeapons(playerid);
    }
    return 1;
}

GetArenaPlayers(arena)
{
    new players;
    foreach(new i : Player)
    {
        if (PlayerData[i][pPaintball] == arena)
        {
            players++;
        }
    }
    return players;
}
