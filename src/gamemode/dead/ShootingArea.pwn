/// @file      ShootingArea.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


static g_BoothUsed[MAX_BOOTHS];
static g_BoothObject[MAX_BOOTHS] = {-1, ...};
static const Float:arrBoothPositions[MAX_BOOTHS][3] = {
    {300.5000, -138.5660, 1004.0625},
    {300.5000, -137.0286, 1004.0625},
    {300.5000, -135.5336, 1004.0625},
    {300.5000, -134.0436, 1004.0625},
    {300.5000, -132.5637, 1004.0625},
    {300.5000, -131.0782, 1004.0625},
    {300.5000, -129.5582, 1004.0625},
    {300.5000, -128.0786, 1004.0625}
};

stock Booth_GetPlayer(id)
{
    foreach (new i : Player)
    {
        if (PlayerData[i][pRangeBooth] == id)
        {
            return i;
        }
    }
    return INVALID_PLAYER_ID;
}

hook OnGameModeInit(playerid)
{
    for (new i = 0; i < sizeof(arrBoothPositions); i ++)
    {
        CreateDynamic3DTextLabel("[Shooting Range]\n{FFFFFF}Press 'F' to use this booth.", COLOR_AQUA, arrBoothPositions[i][0], arrBoothPositions[i][1], arrBoothPositions[i][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 7);
    }
}

hook OnPlayerReset(playerid)
{
    if (PlayerData[playerid][pRangeBooth] != -1)
        Booth_Leave(playerid);
}

GetCurrentPlayerBoothTarget(playerid)
{
    return g_BoothObject[PlayerData[playerid][pRangeBooth]];
}

Booth_Leave(playerid)
{
    if (PlayerData[playerid][pRangeBooth] != -1)
    {
        if (IsValidObject(g_BoothObject[PlayerData[playerid][pRangeBooth]]))
        {
            DestroyObject(g_BoothObject[PlayerData[playerid][pRangeBooth]]);

            g_BoothObject[PlayerData[playerid][pRangeBooth]] = -1;
        }
        ResetPlayerWeapons(playerid);
        SetPlayerWeapons(playerid);

        g_BoothUsed[PlayerData[playerid][pRangeBooth]] = false;

        PlayerData[playerid][pRangeBooth] = -1;
        PlayerData[playerid][pTargets] = 0;
        PlayerData[playerid][pTargetLevel] = 0;
    }
    return 1;
}

Booth_Refresh(playerid)
{
    new id = PlayerData[playerid][pRangeBooth];

    if (id == -1)
        return 0;

    if (IsValidObject(g_BoothObject[id]))
    {
        DestroyObject(g_BoothObject[id]);
    }
    g_BoothObject[id] = CreateDynamicObjectEx(1583, arrBoothPositions[id][0] - 15.0, arrBoothPositions[id][1] + 1.5, arrBoothPositions[id][2], 0.0, 0.0, 90.0);

    return MoveObject(g_BoothObject[id], arrBoothPositions[id][0] - 1.0, arrBoothPositions[id][1] + 1.5, arrBoothPositions[id][2], (!PlayerData[playerid][pTargetLevel]) ? (2.0) : (2.0 + (PlayerData[playerid][pTargetLevel] * 1.2)));
}

publish UpdateBooth(playerid, id)
{
    if (PlayerData[playerid][pRangeBooth] != id || !g_BoothUsed[id])
        return 0;

    if (PlayerData[playerid][pTargets] == 10)
    {
        PlayerData[playerid][pTargets] = 0;

        switch (PlayerData[playerid][pTargetLevel]++)
        {
            case 0:
            {
                ResetPlayerWeapons(playerid);

                GivePlayerWeapon(playerid, 25, 15000);
                SendInfoMessage(playerid, "You have advanced to the next level (1/5).");
            }
            case 1:
            {
                ResetPlayerWeapons(playerid);

                GivePlayerWeapon(playerid, 28, 15000);
                SendInfoMessage(playerid, "You have advanced to the next level (2/5).");
            }
            case 2:
            {
                ResetPlayerWeapons(playerid);

                GivePlayerWeapon(playerid, 29, 15000);
                SendInfoMessage(playerid, "You have advanced to the next level (3/5).");
            }
            case 3:
            {
                ResetPlayerWeapons(playerid);

                GivePlayerWeapon(playerid, 30, 15000);
                SendInfoMessage(playerid, "You have advanced to the next level (4/5).");
            }
            case 4:
            {
                ResetPlayerWeapons(playerid);

                GivePlayerWeapon(playerid, 27, 15000);
                SendInfoMessage(playerid, "You have advanced to the next level (5/5).");
            }
            case 5:
            {
                Booth_Leave(playerid);
                SendInfoMessage(playerid, "You have completed the shooting challenge!");
            }
        }
    }
    Booth_Refresh(playerid);
    return 1;
}


hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if ((weaponid >= 22 && weaponid <= 38) && hittype == BULLET_HIT_TYPE_OBJECT)
    {
        if (PlayerData[playerid][pRangeBooth] != -1 && hitid == GetCurrentPlayerBoothTarget(playerid))
        {
            PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);

            PlayerData[playerid][pTargets]++;
            DestroyObject(hitid);
            SendClientMessageEx(playerid, COLOR_GREEN, "~b~Targets:~w~ %d/10", PlayerData[playerid][pTargets]);
            SetTimerEx("UpdateBooth", 3000, false, "dd", playerid, PlayerData[playerid][pRangeBooth]);
        }
    }
}
