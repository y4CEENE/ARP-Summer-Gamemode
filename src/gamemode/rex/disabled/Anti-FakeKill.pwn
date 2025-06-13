/// @file      Anti-FakeKill.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-11
/// @copyright Copyright (c) 2023

// Based on: Anti fake kill by Rogue 2018/3/25
// Bug packets sended can be fake we cannot rely on killerid neither on playerid we need to rely on packet sender

#include <YSI\y_hooks>


enum FakeKillReason
{
    FKR_InvalidReason,
    FKR_FakeReason,
    FKR_JustDied,
    FKR_JustSpawned,
    FKR_FootRamming,
    FKR_FarRamming,
    FKR_FootHeloBlade,
    FKR_CarHeloBlade,
    FKR_DirectKill
};

enum eFakeKill
{
    FK_JustSpawned,
    FK_JustDamaged,
    FK_JustDied
};

static FakeKill[MAX_PLAYERS][eFakeKill];

hook OnPlayerInit(playerid)
{
    FakeKill[playerid][FK_JustSpawned]  = 0;
    FakeKill[playerid][FK_JustDamaged]  = 0;
    FakeKill[playerid][FK_JustDied]     = 0;
}

stock FakeKillReasonToString(FakeKillReason:reason)
{
    new result[32];
    switch (reason)
    {
        case FKR_InvalidReason: result = "Invalid reason";
        case FKR_FakeReason:    result = "Fake reason";
        case FKR_JustDied:      result = "Just died";
        case FKR_JustSpawned:   result = "Just spawned";
        case FKR_FootRamming:   result = "Foot ramming";
        case FKR_FarRamming:    result = "Far ramming";
        case FKR_FootHeloBlade: result = "On foot helicopter blade";
        case FKR_CarHeloBlade:  result = "In car helicopter blade";
        case FKR_DirectKill:    result = "Direct kill";
        default:                result = "Unkown";
    }
    return result;
}

static bool:IsValidKillReason(reason)
{
    switch (reason)
    {
        case 0..18, 22..46, 49..51, 53, 54, 200, 201, 255: return true;
    }
    return false;
}

static bool:IsSelfDeathReason(reason)
{
    switch(reason)
    {
        case 53: return true;  // Drowned
        case 54: return true;  // Splat
        case 255: return true; // Suicide
    }
    return false;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (!IsValidKillReason(reason))
    {
        CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_FakeReason);
        return 1;
    }

    if (IsPlayerConnected(killerid) && !IsPlayerImmune(playerid))
    {
        if (IsSelfDeathReason(reason))
        {
            CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_InvalidReason);
            return 1;
        }

        if (JustDied(playerid))
        {
            CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_JustDied);
            return 1;
        }

        if (JustStateSpawned(playerid))
        {
            CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_JustSpawned);
            return 1;
        }

        if (reason == WEAPON_VEHICLE)
        {
            if (GetPlayerState(killerid) != PLAYER_STATE_DRIVER)
            {
                CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_FootRamming);
                return 1;
            }

            new vehicleid = GetPlayerVehicleID(killerid);
            if (!IsPlayerNearPlayer(playerid, killerid, 5.0) && !IsAPlane(vehicleid) && !IsAnHelicopter(vehicleid))
            {
                CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_FarRamming);
                return 1;
            }
        }

        if (reason == 50) // Helicopter Blades
        {
            if (GetPlayerState(killerid) != PLAYER_STATE_DRIVER)
            {
                CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_FootHeloBlade);
                return 1;
            }
            if (!IsAnHelicopter(GetPlayerVehicleID(killerid)))
            {
                CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_CarHeloBlade);
                return 1;
            }
        }

        if (!JustDamaged(playerid))
        {
            CallLocalFunction("OnPlayerFakeKill", "iiii", playerid, killerid, reason, _:FKR_DirectKill);
            return 1;
        }
    }
    FakeKill[playerid][FK_JustDied]    = gettime();
    FakeKill[playerid][FK_JustSpawned] = 0;
    FakeKill[playerid][FK_JustDamaged] = 0;
    return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if (damagedid != INVALID_PLAYER_ID && IsPlayerConnected(damagedid))
    {
        FakeKill[damagedid][FK_JustDamaged] = gettime();
    }
    return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if (issuerid != INVALID_PLAYER_ID && IsPlayerConnected(issuerid))
    {
        FakeKill[playerid][FK_JustDamaged] = gettime();
    }
    return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    switch(hittype)
    {
        case BULLET_HIT_TYPE_PLAYER:
        {
            FakeKill[hitid][FK_JustDamaged] = gettime();
        }
        case BULLET_HIT_TYPE_VEHICLE:
        {
            foreach(new i: Player)
            {
                if (GetPlayerVehicleID(i) == hitid)
                {
                    FakeKill[i][FK_JustDamaged] = gettime();
                }
            }
        }
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    FakeKill[playerid][FK_JustSpawned] = gettime();
    return 1;
}

stock JustDamaged(playerid, lastSeconds = 3)
{
    return gettime() - FakeKill[playerid][FK_JustDamaged] < lastSeconds;
}

stock JustDied(playerid, lastSeconds = 3)
{
    return gettime() - FakeKill[playerid][FK_JustDied] < lastSeconds;
}

stock JustStateSpawned(playerid, lastSeconds = 3)
{
    return gettime() - FakeKill[playerid][FK_JustSpawned] < lastSeconds;
}

hook OnPlayerFakeKill(playerid, spoofedid, spoofedReason, FakeKillReason:fakeType)
{
    if (IsPlayerConnected(spoofedid))
    {
        new reason[64];
        format(reason, sizeof(reason), "Fake killing [%d] %s: %s", playerid,
               GetPlayerNameEx(playerid), FakeKillReasonToString(fakeType));
        KickPlayer(spoofedid, reason);
    }
    return 1;
}
