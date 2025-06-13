/// @file      BumperCars.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

#define EVENT_TOKEN_BUMPER_CARS 0x45544F

static PlayerBumperCar[MAX_PLAYERS];
static NbBumperCars;
static Float:gBumperOrigin[3] = {1493.4615,-33.9362,27.5266};
static Float:gBumperExit[4] = {1495.0763,-32.5579,27.5244,305.1577};
static gBumperSpawnPos[10][Point4D] = {
    {1509.0797,-64.9944,26.9080,329.6529},
    {1516.2323,-55.0962,26.9271,345.0430},
    {1520.049682, -41.101760, 27.553333,13.7316},
    {1508.8268,-29.9964,26.9196,123.8321},
    {1503.8162,-37.9906,26.9408,171.2591},
    {1497.4014,-48.4876,26.9138,76.2519},
    {1492.9607,-40.7950,26.9149,269.7835},
    {1505.6836,-32.8667,26.9330,275.1056},
    {1515.4636,-35.6011,26.9223,196.8903},
    {1514.7443,-48.7944,26.9353,136.1681}
};

hook OnPlayerConnect(playerid)
{
    PlayerBumperCar[playerid] = 0;
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/bumpercar {FFFF00}to join in!", 0xFFFFFFF, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2], 10.0);
}

CMD:bumpercar(playerid, params[])
{
    if (PlayerBumperCar[playerid])
    {
        LeaveBumper(playerid);
        return SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
    }

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2], 5.0);
        }
        return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the bumper cars area!");
    }
    RCHECK(!IsPlayerInEvent(playerid), "You cannot do that for the moment.");
    RCHECK(NbBumperCars <= 15, "The arena is full, please wait your turn!");

    SavePlayerVariables(playerid);
    SetPVarInt(playerid, "EventToken", EVENT_TOKEN_BUMPER_CARS);

	new rand = random(sizeof(gBumperSpawnPos));
	new veh  = CreateVehicle(539, gBumperSpawnPos[rand][P4_PosX], gBumperSpawnPos[rand][P4_PosY], gBumperSpawnPos[rand][P4_PosZ], gBumperSpawnPos[rand][P4_Angle], random(10), random(10), 15);
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
	PutPlayerInVehicle(playerid, veh, 0);
    SendClientMessageEx(playerid, 0xFFFFFFFF, "Type /bumpercar again to stop playing! %d", veh);
    NbBumperCars++;
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken == EVENT_TOKEN_BUMPER_CARS)
    {
        LeaveBumper(playerid);
    }
}

hook OnPlayerHeartBeat(playerid)
{
    if (PlayerBumperCar[playerid])
    {
        new Float:hp;
        new vehicleid = PlayerBumperCar[playerid];
        GetVehicleHealth(vehicleid, hp);
        if (hp < 500)
        {
            LeaveBumper(playerid);
            return SendClientMessage(playerid, 0xFFFFFFFF, "Too damaged to continue, thanks for playing!");
        }

        new engine,lights,alarm,doors,bonnet,boot,objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        if (engine != VEHICLE_PARAMS_ON)
        {
            SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
        }
    }
    return 1;
}

LeaveBumper(playerid)
{
    if (PlayerBumperCar[playerid])
    {
        DestroyVehicle(PlayerBumperCar[playerid]);
        PlayerBumperCar[playerid] = 0;
        if (NbBumperCars > 0)
        {
            NbBumperCars--;
        }
        DeletePVar(playerid, "EventToken");
        SetPlayerToSpawn(playerid);
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (PlayerBumperCar[playerid])
    {
        if (newstate == PLAYER_STATE_DRIVER)
        {
            SendAdminWarning(2, "%s[%i] is maybe teleporting to bumper car", GetRPName(playerid), playerid);
        }
        else if (newstate == PLAYER_STATE_ONFOOT)
        {
            LeaveBumper(playerid);
            SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
        }
    }
    return 1;
}
