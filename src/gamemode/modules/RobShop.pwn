#include <YSI\y_hooks>

// Configuration
#define ROBBERY_ACTOR_SKIN 17

#define ROBBERY_ACTOR_X 1296.3601
#define ROBBERY_ACTOR_Y -1878.7622
#define ROBBERY_ACTOR_Z 13.6341
#define ROBBERY_ACTOR_ANGLE 0.0

#define ROBBERY_COOLDOWN 		(14 * 60 * 60) 					// 14 hours

#define ROBBERY_AIM_TIME		3000 	// 3 seconds aiming required
#define REWARD_INTERVAL 		2000   // 2 seconds between rewards

#define REWARD_MIN 				2000
#define REWARD_MAX 				4000

#define MAX_REWARD_MIN 			50000
#define MAX_REWARD_MAX 			75000


static gRobberyActor;
static bool:gRobberyInProgress = false;
static gRobberyPlayer = INVALID_PLAYER_ID;
static gRobberyTimer = -1;
static gRewardTotal;
static gMaxReward;
static gAimCheckTimer[MAX_PLAYERS] = {-1, ...};
static gLastRobberyTime = 0;


hook OnGameModeInit()
{
    // Create robbery actor
    gRobberyActor = CreateActor(ROBBERY_ACTOR_SKIN, ROBBERY_ACTOR_X, ROBBERY_ACTOR_Y, ROBBERY_ACTOR_Z, ROBBERY_ACTOR_ANGLE);
    ApplyActorAnimation(gRobberyActor, "DEALER", "", 4.0, 1, 0, 0, 1, 0);
    return 1;
}


hook OnPlayerConnect(playerid)
{

    if(gAimCheckTimer[playerid] != -1) KillTimer(gAimCheckTimer[playerid]);
    gAimCheckTimer[playerid] = -1;
    return 1;
}


StartRobbery(playerid)
{
    if(gRobberyInProgress) return 0;


    new currentTime = gettime();
    if(currentTime - gLastRobberyTime < ROBBERY_COOLDOWN)
    {
        new timeLeft = ROBBERY_COOLDOWN - (currentTime - gLastRobberyTime);
        new hours = floatround(timeLeft / 3600.0, floatround_floor);
        new minutes = floatround((timeLeft % 3600) / 60.0, floatround_floor);

        SendClientMessage(playerid, COLOR_GREY, "This store was recently robbed!");
        SendClientMessageEx(playerid, COLOR_GREY, "Come back in %d hours and %d minutes", hours, minutes);
        return 0;
    }

    gRobberyInProgress = true;
    gRobberyPlayer = playerid;
    gRewardTotal = 0;
    gMaxReward = random(MAX_REWARD_MAX - MAX_REWARD_MIN) + MAX_REWARD_MIN;

    ApplyActorAnimation(gRobberyActor, "PED", "handsup", 4.1, 0, 0, 1, 1, 0);

    gRobberyTimer = SetTimerEx("GiveRobberyReward", REWARD_INTERVAL, true, "i", playerid);

    new initialReward = random(REWARD_MAX - REWARD_MIN) + REWARD_MIN;
    GivePlayerCash(playerid, initialReward);
    gRewardTotal += initialReward;

    SendClientMessage(playerid, 0x00FF00FF, "Robbery in progress! Keep aiming at the cashier.");
    return 1;
}

StopRobbery(bool:completed)
{
    if(!gRobberyInProgress) return 0;

    if(gRobberyTimer != -1) KillTimer(gRobberyTimer);
    gRobberyTimer = -1;

    ClearActorAnimations(gRobberyActor);
    ApplyActorAnimation(gRobberyActor, "PED", "cower", 4.0, 1, 0, 0, 1, 0);

    if(completed)
    {
        new finalMessage[128];
        format(finalMessage, sizeof(finalMessage), "Robbery completed! You got $%d", gRewardTotal);
        SendClientMessage(gRobberyPlayer, COLOR_AQUA, finalMessage);
        SetPlayerWantedLevel(gRobberyPlayer, 2);
    }
    else
    {
        SetPlayerWantedLevel(gRobberyPlayer, 2);
        SendClientMessage(gRobberyPlayer, COLOR_GREY, "Robbery failed! You stopped aiming.");
    }

    gRobberyInProgress = false;
    gLastRobberyTime = gettime();
    gRobberyPlayer = INVALID_PLAYER_ID;
    return 1;
}

forward GiveRobberyReward(playerid);
public GiveRobberyReward(playerid)
{
    if(!gRobberyInProgress || playerid != gRobberyPlayer) return 0;

    new weapon = GetPlayerWeapon(playerid);
    if(weapon != 24 && weapon != 25 && weapon != 30 && weapon != 31)
    {
        StopRobbery(false);
        return 0;
    }

    new amount = random(REWARD_MAX - REWARD_MIN) + REWARD_MIN;
    GivePlayerMoney(playerid, amount);
    gRewardTotal += amount;

    if(gRewardTotal >= gMaxReward)
    {
        StopRobbery(true);
    }
    return 1;
}

#define KEY_HANDBRAKE     (128)
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_HANDBRAKE) && !(oldkeys & KEY_HANDBRAKE))
    {
        if(gRobberyInProgress)
        {
            SendClientMessage(playerid, COLOR_GREY, "Robbery: Someone is already robbing this store!");
            return 1;
        }

        new weapon = GetPlayerWeapon(playerid);
        if(weapon != 24 && weapon != 25 && weapon != 30 && weapon != 31) return 1;

        if(gAimCheckTimer[playerid] != -1)
        {
            KillTimer(gAimCheckTimer[playerid]);
            gAimCheckTimer[playerid] = -1;
        }

        if(IsPlayerAimingAtActor(playerid, gRobberyActor))
        {
            gAimCheckTimer[playerid] = SetTimerEx("CheckAimingDuration", ROBBERY_AIM_TIME, false, "i", playerid);
            SendClientMessage(playerid, COLOR_AQUA, "Keep aiming for 3 seconds to start robbery...");
        }
    }
    else if((oldkeys & KEY_HANDBRAKE) && !(newkeys & KEY_HANDBRAKE))
    {
        if(gAimCheckTimer[playerid] != -1)
        {
            KillTimer(gAimCheckTimer[playerid]);
            gAimCheckTimer[playerid] = -1;
            SendClientMessage(playerid, COLOR_RED, "Robbery canceled: You stopped aiming!");
        }
    }
    return 1;
}

forward CheckAimingDuration(playerid);
public CheckAimingDuration(playerid)
{
    gAimCheckTimer[playerid] = -1;

	if(gRobberyInProgress)
    {
        SendClientMessage(playerid, COLOR_GREY, "Robbery: Someone started robbing just before you!");
        return;
    }

    new weapon = GetPlayerWeapon(playerid);
    if(weapon != 24 && weapon != 25 && weapon != 30 && weapon != 31)
    {
        SendClientMessage(playerid, COLOR_GREY, "You need a powerful weapon to rob (Shotgun, Deagle, M4, AK-47)!");
        return;
    }

    if(IsPlayerAimingAtActor(playerid, gRobberyActor))
    {
        StartRobbery(playerid);
    }
}

stock IsPlayerAimingAtActor(playerid, actorid)
{
    new Float:x, Float:y, Float:z;
    GetActorPos(actorid, x, y, z);
    return IsPlayerAimingAt(playerid, x, y, z, 2.0);
}

stock IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
    new Float:camera_x, Float:camera_y, Float:camera_z;
    new Float:vector_x, Float:vector_y, Float:vector_z;

    GetPlayerCameraPos(playerid, camera_x, camera_y, camera_z);
    GetPlayerCameraFrontVector(playerid, vector_x, vector_y, vector_z);

    new Float:dx = x - camera_x;
    new Float:dy = y - camera_y;
    new Float:dz = z - camera_z;

    new Float:distance = (dy * vector_z - dz * vector_y) * (dy * vector_z - dz * vector_y) +
                         (dz * vector_x - dx * vector_z) * (dz * vector_x - dx * vector_z) +
                         (dx * vector_y - dy * vector_x) * (dx * vector_y - dy * vector_x);

    distance = floatsqroot(distance) / floatsqroot(vector_x*vector_x + vector_y*vector_y + vector_z*vector_z);

    return (distance <= radius);
}

// DEBUG COMMAND
CMD:tproys(playerid){
	SetPlayerPos(playerid, 1291.407958, -1862.370361, 14.216876);
	GivePlayerWeapon(playerid, 31, 400);
	return 1;
}
