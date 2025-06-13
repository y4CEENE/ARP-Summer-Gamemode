/// @file      Checkpoint.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum
{
    CHECKPOINT_NONE = 0,
    CHECKPOINT_PIZZA,
    CHECKPOINT_TEST,
    CHECKPOINT_MINING,
    CHECKPOINT_MATS,
    CHECKPOINT_DRUGS,
    CHECKPOINT_HOUSE,
    CHECKPOINT_ROBBERY,
    CHECKPOINT_ROBBIZ,
    CHECKPOINT_ROBHOUSE,
    CHECKPOINT_ROBATM,
    CHECKPOINT_DROPCAR,
    CHECKPOINT_MISC,
    CHECKPOINT_GARBAGE,
    CHECKPOINT_FARMER,
    CHECKPOINT_HOUSEROB,
    CHECKPOINT_TRUCKDELIVERY,
    CHECKPOINT_FORKLIFT,
    CHECKPOINT_FISHER,
    CHECKPOINT_RACE,
    CHECKPOINT_MAKECIMENT,
    //CHECKPOINT_RECYCLE,
	//CHECKPOINT_RECYCLE2,
    CHECKPOINT_BUTCHER,
    CHECKPOINT_BRINKS,
    CHECKPOINT_KARTRACE
};

static CurrentCheckpointId[MAX_PLAYERS];
static CurrentCheckpointFlag[MAX_PLAYERS];

enum RaceCheckpointType {
    RaceCheckpointType_Normal,
    RaceCheckpointType_Finish,
    RaceCheckpointType_Nothing, // (ONLY THE CHECKPOINT WITHOUT ANYTHING ON IT),
    RaceCheckpointType_AirNormal,
    RaceCheckpointType_AirFinish,
    RaceCheckpointType_AirRotate,
    RaceCheckpointType_AirDisappear,
    RaceCheckpointType_AirDownAndUp,
    RaceCheckpointType_AirUpAndDown
};

stock SetActiveCheckpoint(playerid, id, Float:x, Float:y, Float:z, Float:size = 5.0, flag = 0)
{
    if (id == CHECKPOINT_NONE)
    {
        CancelActiveCheckpoint(playerid);
    }
    else
    {
        CurrentCheckpointId[playerid] = id;
        CurrentCheckpointFlag[playerid] = flag;
        SetPlayerCheckpoint(playerid, x, y, z, size);
        CallRemoteFunction("OnPlayerNewCheckpoint", "iii", playerid, id, flag);
    }
}

stock SetActiveRaceCheckpoint(playerid, id, Float:x, Float:y, Float:z, Float:size = 10.0, flag = 0,
        Float:nextx = 0.0, Float:nexty = 0.0, Float:nextz = 0.0, RaceCheckpointType:type = RaceCheckpointType_Nothing)
{
    if (id == CHECKPOINT_NONE)
    {
        CancelActiveCheckpoint(playerid);
    }
    else
    {
        CurrentCheckpointId[playerid] = id;
        CurrentCheckpointFlag[playerid] = flag;
        SetPlayerRaceCheckpoint(playerid, _:type, x, y, z, nextx, nexty, nextz, size);
        CallRemoteFunction("OnPlayerNewCheckpoint", "iii", playerid, id, flag);
    }
}

hook OP_EnterRaceCheckpoint(playerid)
{
    if (CurrentCheckpointId[playerid] != CHECKPOINT_NONE)
    {
        new id   = CurrentCheckpointId[playerid];
        new flag = CurrentCheckpointFlag[playerid];
        CurrentCheckpointId[playerid] = CHECKPOINT_NONE;
        CurrentCheckpointFlag[playerid] = 0;
        DisablePlayerRaceCheckpoint(playerid);
        CallRemoteFunction("OnPlayerReachCheckpoint", "iii", playerid, id, flag);
    }
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (CurrentCheckpointId[playerid] != CHECKPOINT_NONE)
    {
        new id   = CurrentCheckpointId[playerid];
        new flag = CurrentCheckpointFlag[playerid];
        CurrentCheckpointId[playerid] = CHECKPOINT_NONE;
        CurrentCheckpointFlag[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
        CallRemoteFunction("OnPlayerReachCheckpoint", "iii", playerid, id, flag);
    }
}

stock GetPlayerActiveCheckpoint(playerid)
{
    return CurrentCheckpointId[playerid];
}

stock GetPlayerActiveCheckpointFlag(playerid)
{
    return CurrentCheckpointFlag[playerid];
}

stock PlayerHasActiveCheckpoint(playerid)
{
    return GetPlayerActiveCheckpoint(playerid) != CHECKPOINT_NONE;
}

stock CancelActiveCheckpoint(playerid)
{
    new id   = CurrentCheckpointId[playerid];
    new flag = CurrentCheckpointFlag[playerid];
    CurrentCheckpointId[playerid] = CHECKPOINT_NONE;
    CurrentCheckpointFlag[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    DisablePlayerRaceCheckpoint(playerid);
    CallRemoteFunction("OnPlayerClearCheckpoint", "iii", playerid, id, flag);
}
