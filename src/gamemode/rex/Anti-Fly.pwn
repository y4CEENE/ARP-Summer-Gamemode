#include <YSI\y_hooks>

static AntiHackFlySpeedLimit = 200;
static PlayerFlyTicks[MAX_PLAYERS];

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
    
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        switch(anim_index)
        {
            case 958, 1538, 1539, 1543:
            {
                new
                    Float:z,
                    Float:vx,
                    Float:vy,
                    Float:vz;

                GetPlayerPos(playerid, z, z, z);
                GetPlayerVelocity(playerid, vx, vy, vz);

                if((z > 30.0) && (0.9 <= floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) <= 1.9))
                {
                    is_possibly_flying = true;
                }
            }
        }

    }

    if(!is_possibly_flying)
    {
        new AnimLib [30], AnimName [30];
        
        GetAnimationName (anim_index, AnimLib, sizeof (AnimLib), AnimName, sizeof (AnimName));

        if (speed > AntiHackFlySpeedLimit && strcmp (AnimLib, "SWIM", true) == 0 && strcmp (AnimName, "SWIM_crawl", true) == 0)
        {
            is_possibly_flying = true;
        }
    }

    if(is_possibly_flying)
    {
        if(IsAdmin(playerid) && IsAdminOnDuty(playerid))
        {
            return 1;
        }
        
        PlayerFlyTicks[playerid]++;

        if(PlayerFlyTicks[playerid] >= 3)
        {
	        KickPlayer(playerid, "Suspicion of fly", INVALID_PLAYER_ID);
        }
        else
        {
            SendAdminWarning(2, "[Anti-Cheat] Player: %s[%d], Ping: %d, Duty: %d, Speed: %.1f, Reason: Suspicion of fly.", GetPlayerNameEx(playerid), playerid, GetPlayerPing(playerid), IsAdminOnDuty(playerid, false), speed);
            Log("Rex/Anti-Fly.log", "[Anti-Cheat] Player: %s[%d], Ping: %d, Duty: %d, Speed: %.1f, Reason: Suspicion of fly.", GetPlayerNameEx(playerid), playerid, GetPlayerPing(playerid), IsAdminOnDuty(playerid, false), speed);        
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
