/// @file      Festival.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include "games/festival/Balloon.pwn"
//#include "games/festival/BumperCar.pwn"//TODO: player cannot get inside vehicle
#include "games/festival/FerrisWheel.pwn"
#include "games/festival/Festival.map"
#include "games/festival/FSnacks.pwn"
#include "games/festival/PirateShip.pwn" //TODO: not moving
#include "games/festival/DropTower.pwn"
//#include "games/festival/ObservationTower.pwn"//TODO: fix otower platform not correctly moving
#include "games/festival/KartRace.pwn"
#include "games/festival/Maze.pwn"

#include <YSI\y_hooks>

static FestivalMusicUrl[256] = "";
static FestivalArea;
static MusicArea;
static Float:FestivalVertices[] = {
    1589.0, 118.0,
    1596.0, -6.0,
    1577.0, -52.0,
    1573.0, -127.0,
    1529.0, -180.0,
    1514.0, -202.0,
    1460.0, -220.0,
    1384.0, -222.0,
    1299.0, -94.0,
    1421.0, 20.0,
    1504.0, 85.0,
    1551.0, 108.0,
    1589.0, 118.0
};

hook OnGameModeInit()
{
    MusicArea = CreateDynamicSphere(592.84, -2085, 0, 330.0);
    FestivalArea = CreateDynamicPolygon(FestivalVertices, .worldid = 0);
}

hook OP_EnterDynamicArea(playerid, areaid)
{
    if (areaid == FestivalArea)
    {
        ResetPlayerWeapons(playerid);
        if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            SetVehicleToRespawn(GetPlayerVehicleID(playerid));
        }
    }
    else if (areaid == MusicArea && !isnull(FestivalMusicUrl))
    {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, FestivalMusicUrl, 1431, -74, 0, 400, 1);
    }
    return 1;
}

hook OP_LeaveDynamicArea(playerid, areaid)
{
    if (areaid == FestivalArea)
    {
        SetPlayerWeapons(playerid);
    }
    else if (areaid == MusicArea && !isnull(FestivalMusicUrl))
    {
        StopAudioStreamForPlayer(playerid);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (IsPlayerInDynamicArea(playerid, FestivalArea))
    {
        ResetPlayerWeapons(playerid);
    }
}

CMD:festival(playerid, params[])
{
    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1550.7883, 17.4276, 24.1364, 5.0);
    return 1;
}
