/// @file      Anti-Fly.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-04-15 15:13:52 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static AntiHackFlySpeedLimit = 200;
static PlayerFlyTicks[MAX_PLAYERS];

enum eSafeSwimmingArea
{
    Float:SSA_MinX,
    Float:SSA_MinY,
    Float:SSA_MinZ,
    Float:SSA_MaxX,
    Float:SSA_MaxY,
    Float:SSA_MaxZ
};

static SafeSwimmingArea[][eSafeSwimmingArea] = {
    //Credits go to Larceny : http://forum.sa-mp.com/member.php?u=243
    /* Las Venturas */
    {  2044.6000,  1206.3580, -200.0, 2192.9840, 1376.5520,   10.0 },
    {  2048.5040,  1063.2390, -200.0, 2185.1740, 1202.4900,   10.0 },
    {  2204.6980,  1426.8370, -200.0, 2204.6980, 1430.7050,   10.0 },
    {  2032.8850,  1852.3250, -200.0, 2114.8870, 1991.5750,   12.0 },
    {  2517.0860,  2316.4930, -200.0, 2606.8970, 2420.9300,   22.0 },
    {  2507.7683,  1548.6178, -200.0, 2554.5996, 1588.9154,   15.0 },
    { -1419.5576,  1981.6162, -200.0, -457.1841, 2834.4104,   50.0 },
    /* San Fierro */
    { -2043.6280,  -980.9415, -200.0, -1973.5610, -724.0283,  32.0 },
    { -2753.9120,  -522.3632, -200.0, -2665.0710, -380.3444,   5.0 },
    /* Los Santos */
    {  1219.8640, -2435.8810, -200.0, 1292.1180, -2325.344,   15.0 },
    {  1923.3880, -1223.9240, -200.0, 2010.8540, -1168.656,   22.0 },
    {  1269.3010,  -837.0452, -200.0, 1314.9350, -781.7769,   90.0 },
    {  1087.3953,  -682.6734, -200.0, 1102.3138, -663.0043,  113.0 },
    {  1268.6118,  -784.2910, -200.0, 1291.8774, -764.6104, 1085.0 },
    {   172.0000, -1249.0000, -200.0,  238.0000, -1160.000,   85.0 } //swimming pools
};

IsInsideSwimingArea(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for (new i = 0; i < sizeof(SafeSwimmingArea); i++)
    {
        if (SafeSwimmingArea[i][SSA_MinX] <= x <= SafeSwimmingArea[i][SSA_MaxX] &&
            SafeSwimmingArea[i][SSA_MinY] <= y <= SafeSwimmingArea[i][SSA_MaxY] &&
            SafeSwimmingArea[i][SSA_MinZ] <= z <= SafeSwimmingArea[i][SSA_MaxZ])
        {
            return true;
        }
    }
    return false;
}

hook OnPlayerInit(playerid)
{
    PlayerFlyTicks[playerid] = 0;
    return 1;
}

hook OnPlayerUpdate(playerid)
{
    new anim_index = GetPlayerAnimationIndex(playerid);
    new Float:speed = GetPlayerSpeed(playerid);
    new is_possibly_flying = false;

    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        switch (anim_index)
        {
            case 1538, 1539, 1543:
            {
                new Float:z;
                GetPlayerPos(playerid, z, z, z);
                if (z >= 15.0 && !IsInsideSwimingArea(playerid))
                {
                    is_possibly_flying = true;
                }

            }
        }

        if (!is_possibly_flying)
        {
            switch (anim_index)
            {
                case 958, 1538, 1539, 1543:
                {
                    new Float:z, Float:vx, Float:vy, Float:vz;
                    GetPlayerPos(playerid, z, z, z);
                    GetPlayerVelocity(playerid, vx, vy, vz);

                    if ((z > 30.0) && (0.9 <= floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) <= 1.9))
                    {
                        is_possibly_flying = true;
                    }
                }
            }
        }
    }

    if (!is_possibly_flying)
    {
        new AnimLib [30], AnimName [30];

        GetAnimationName (anim_index, AnimLib, sizeof (AnimLib), AnimName, sizeof (AnimName));

        if (speed > AntiHackFlySpeedLimit && strcmp (AnimLib, "SWIM", true) == 0 && strcmp (AnimName, "SWIM_crawl", true) == 0)
        {
            is_possibly_flying = true;
        }
    }

    if (is_possibly_flying)
    {
        if (IsAdmin(playerid) && IsAdminOnDuty(playerid))
        {
            return 1;
        }

        PlayerFlyTicks[playerid]++;

        if (PlayerFlyTicks[playerid] >= 3)
        {
            KickPlayer(playerid, "Suspicion of fly", INVALID_PLAYER_ID);
        }
        else
        {
            SendAdminWarning(2, "[Anti-Cheat] Player: %s[%d], Ping: %d, Duty: %d, Speed: %.1f, Reason: Suspicion of fly.", GetPlayerNameEx(playerid), playerid, GetPlayerPing(playerid), IsAdminOnDuty(playerid, false), speed);
            Log("logs/Rex/Anti-Fly.log", "[Anti-Cheat] Player: %s[%d], Ping: %d, Duty: %d, Speed: %.1f, Reason: Suspicion of fly.", GetPlayerNameEx(playerid), playerid, GetPlayerPing(playerid), IsAdminOnDuty(playerid, false), speed);
        }
    }
    return 1;
}

GetFlySpeedLimit()
{
    return AntiHackFlySpeedLimit;
}

SetFlySpeedLimit(value)
{
    AntiHackFlySpeedLimit = value;
}
