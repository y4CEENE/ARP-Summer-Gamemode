/// @file      PirateShip.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

#define EVENT_TOKEN_PIRATE_SHIP 0x49ADF

static enum PirateShipState
{
    PSS_Idle,
    PSS_Waiting,
    PSS_Started,
    PSS_Stopping
};

static enum ePirateShip
{
    PirateShipState:PS_State,
    PS_PlayersCount,
    PS_StartTimer,
    PS_MoveTimer,
    PS_AngleUpdate,
    PS_AngleMovement,
    bool:PS_AngleDecrement,
    bool:PS_CanMove,
    bool:PS_MoveUp,
    PS_PirateArea,
    STREAMER_TAG_3D_TEXT_LABEL:PS_JoinText
};

static PirateShipState:sPirateShip[ePirateShip];
static bool:sInPirateShip[MAX_PLAYERS];

static const Float:cPirateJoinPos[Point4D] = { 1376.6722, -128.7566, 26.4127, 214.9392 };
static const Float:cPirateExitPos[Point4D] = { 1374.6167, -129.0237, 26.4127,  36.3936 };

// PirateShip object
static sPirateShipObject;
static sPirateShipAttachement;
static const Float:cPirateShipOrigin[2][Point4D] = {
    {1384.0331, -142.1840, 57.1300, 40.0},
    {1390.5167, -136.2200, 42.7034, -50.0}
};

static const cPlayerSpawnPos[][Point4D] = {
    {1368.3156,-157.4080,41.0},
    {1367.7076,-156.7162,41.0},
    {1367.0004,-156.1516,41.0},
    {1366.5372,-155.3416,41.0},
    {1365.8599,-154.7898,41.0},
    {1366.0726,-153.8185,38.8073},
    {1366.2477,-154.5297,41.0},
    {1367.1639,-154.9416,38.8022},
    {1367.8494,-155.9007,38.8022},
    {1368.4381,-156.6313,38.8022},
    {1369.5812,-156.3377,38.8022},
    {1368.9663,-155.7623,38.8022},
    {1368.2111,-155.2064,38.8022},
    {1367.6128,-154.4204,38.8022},
    {1367.3668,-153.4461,38.8073},
    {1367.3884,-152.7107,38.8073},
    {1367.9076,-153.5258,38.8073},
    {1368.6387,-154.1646,38.8073},
    {1368.9137,-154.4801,38.8022},
    {1369.2083,-155.1617,38.8022},
    {1369.8506,-155.7930,38.8022},
    {1370.7736,-155.3378,38.8022},
    {1370.1151,-154.5368,38.8022},
    {1369.4979,-153.6514,38.8073},
    {1368.9086,-152.8132,38.8073},
    {1368.1691,-152.1746,38.8073},
    {1368.9674,-151.5208,38.8073},
    {1369.5686,-152.4011,38.8073},
    {1370.4342,-153.3024,38.8073},
    {1370.8665,-154.1247,38.8073},
    {1371.5293,-154.6986,38.8022},
    {1372.0619,-154.2571,38.8022},
    {1371.7343,-153.4149,38.8073},
    {1371.2455,-152.7113,38.8073},
    {1370.9978,-151.9384,38.8022},
    {1370.1422,-151.6086,38.8073},
    {1369.8403,-150.7298,38.8073},
    {1377.4641,-149.3647,38.8073},
    {1377.2501,-148.4664,38.8073},
    {1376.4216,-147.5100,38.8073},
    {1375.4967,-147.0543,38.8073},
    {1375.6320,-145.8949,37.7709},
    {1376.4155,-146.4493,37.7709},
    {1376.9457,-147.3245,37.7709},
    {1377.2776,-148.1663,38.8073},
    {1378.1124,-148.4439,37.7709},
    {1378.6742,-148.0090,37.7709},
    {1378.3854,-147.0647,37.7709},
    {1377.7249,-146.2822,37.7709},
    {1377.0049,-145.7251,37.7709},
    {1376.3148,-145.1906,37.7709}
};

hook OnGameModeInit()
{
    sPirateShip[PS_State] = PSS_Idle;
    sPirateShip[PS_PlayersCount] = 0;
    sPirateShip[PS_StartTimer] = 0;
    sPirateShip[PS_PirateArea] = CreateDynamicRectangle(1323.112670, -183.252929, 1448.739501, -90.425178);
    sPirateShip[PS_JoinText] = CreateDynamic3DTextLabel("", 0xFFFFFFF, cPirateJoinPos[P4_PosX], cPirateJoinPos[P4_PosY], cPirateJoinPos[P4_PosZ], 15.0);

    // Create PirateShip
    sPirateShipObject = CreateDynamicObject(3502, cPirateShipOrigin[0][P4_PosX], cPirateShipOrigin[0][P4_PosY], cPirateShipOrigin[0][P4_PosZ], 0.00, 0.00, cPirateShipOrigin[0][P4_Angle]);
    sPirateShipAttachement = CreateDynamicObject(8493, cPirateShipOrigin[1][P4_PosX], cPirateShipOrigin[1][P4_PosY], cPirateShipOrigin[1][P4_PosZ], 0.00, 0.00, cPirateShipOrigin[1][P4_Angle]);
    AttachDynamicObjectToObject(sPirateShipAttachement, sPirateShipObject, 9.33, 0.0, -8.07, 0.0, 0.0, 270.0);
}

hook OnPlayerInit(playerid)
{
    sInPirateShip[playerid] = false;
}

CMD:pirateshipreset(playerid, params[])
{
    if (IsGodAdmin(playerid))
    {
        if (IsDynamicObjectMoving(sPirateShipObject))
        {
            StopDynamicObject(sPirateShipObject);
        }
        MoveDynamicObject(sPirateShipObject, cPirateShipOrigin[0][P4_PosX], cPirateShipOrigin[0][P4_PosY], cPirateShipOrigin[0][P4_PosZ], 0.1, 0.0, 0.0, 40.0);
        sPirateShip[PS_State] = PSS_Idle;
        return 1;
    }
    return 0;
}

CMD:pirateship(playerid, params[])
{
    if (sInPirateShip[playerid])
    {
        return LeavePirateShip(playerid);
    }
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, cPirateJoinPos[P4_PosX], cPirateJoinPos[P4_PosY], cPirateJoinPos[P4_PosZ]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, cPirateJoinPos[P4_PosX], cPirateJoinPos[P4_PosY], cPirateJoinPos[P4_PosZ], 5.0);
        }
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not at the ride entrance");
    }
    RCHECK(!IsPlayerInEvent(playerid), "You cannot do that for the moment.");
    RCHECK(sPirateShip[PS_State] != PSS_Started,  "The ride has already started");
    RCHECK(sPirateShip[PS_State] != PSS_Stopping, "The ride has already started");
    RCHECK(sPirateShip[PS_PlayersCount] < sizeof(cPlayerSpawnPos), "The race is full, try again next time!");

    if (sPirateShip[PS_PlayersCount] == 0)
    {
        sPirateShip[PS_StartTimer] = gettime() + 30;
        sPirateShip[PS_State] = PSS_Waiting;
    }
    sInPirateShip[playerid] = true;

    SetPlayerPos(playerid, cPirateExitPos[P4_PosX], cPirateExitPos[P4_PosY], cPirateExitPos[P4_PosZ]);
    SetPlayerFacingAngle(playerid, cPirateExitPos[P4_Angle]);
    SavePlayerVariables(playerid);
    SetPVarInt(playerid, "EventToken", EVENT_TOKEN_PIRATE_SHIP);

    new idx = sPirateShip[PS_PlayersCount];
    TeleportToCoords(playerid, cPlayerSpawnPos[idx][P4_PosX], cPlayerSpawnPos[idx][P4_PosY],
                     cPlayerSpawnPos[idx][P4_PosZ], cPlayerSpawnPos[idx][P4_Angle], 0, 0, true, false);
    SetPlayerHealth(playerid, 1000.0);
    sPirateShip[PS_PlayersCount]++;
    return SendClientMessage(playerid, 0xFFFFFFFF, "Type /pirateship again to leave the ship, if you don't move you won't fall");
}

hook OnServerHeartBeat(timestamp)
{
    UpdatePirateLabel();

    if (sPirateShip[PS_State] != PSS_Waiting || sPirateShip[PS_PlayersCount] <= 0)
        return 1;

    new timeLeft = sPirateShip[PS_StartTimer] - gettime();
    if (timeLeft > 0)
    {
        new string[66];
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Pirate Ship~n~Starting in %d seconds", timeLeft);
        foreach (new playerid : Player)
        {
            if (sInPirateShip[playerid])
            {
                if (timeLeft <= 3)
                {
                    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
                }
                GameTextForPlayer(playerid, string, 1100, 3);
            }
        }
    }
    else
    {
        sPirateShip[PS_State] = PSS_Started;
        KillTimer(sPirateShip[PS_MoveTimer]);
        sPirateShip[PS_MoveTimer] = SetTimer("MovePirateShip", 1000, false);
    }
    return 1;
}

publish MovePirateShip()
{
    if (sPirateShip[PS_State] != PSS_Started)
    {
        return;
    }
    if (IsDynamicObjectMoving(sPirateShipObject))
    {
        StopDynamicObject(sPirateShipObject);
    }
    new Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ;
    GetDynamicObjectPos(sPirateShipObject, X, Y, Z);
    GetDynamicObjectRot(sPirateShipObject, RX, RY, RZ);

    if (sPirateShip[PS_MoveUp])
    {
        MoveDynamicObject(sPirateShipObject, X, Y, Z - 0.1, 0.1 - (sPirateShip[PS_AngleMovement] * 0.01), 0.0, 10.0 * sPirateShip[PS_AngleMovement], 40.0);
        sPirateShip[PS_MoveUp] = false;
    }
    else
    {
        MoveDynamicObject(sPirateShipObject, X, Y, Z + 0.1, 0.1 - (sPirateShip[PS_AngleMovement] * 0.01), 0.0, -10.0 * sPirateShip[PS_AngleMovement], 40.0);
        sPirateShip[PS_MoveUp] = true;
    }

    if (sPirateShip[PS_AngleMovement] >= 6)
    {
        sPirateShip[PS_AngleDecrement] = true;
    }

    if (sPirateShip[PS_AngleUpdate] == 3)
    {
        if (sPirateShip[PS_AngleDecrement])
        {
            sPirateShip[PS_AngleMovement]--;
        }
        else
        {
            sPirateShip[PS_AngleMovement]++;
        }
        sPirateShip[PS_AngleUpdate] = 0;
    }
    else
    {
        sPirateShip[PS_AngleUpdate]++;
    }

    if (sPirateShip[PS_AngleDecrement] && sPirateShip[PS_AngleMovement] < 0)
    {
        MoveDynamicObject(sPirateShipObject, cPirateShipOrigin[0][P4_PosX], cPirateShipOrigin[0][P4_PosY], cPirateShipOrigin[0][P4_PosZ], 0.1, 0.0, 0.0, 40.0);
        sPirateShip[PS_State] = PSS_Stopping;
    }
}

hook OnDynamicObjectMoved(objectid)
{
    if (objectid == sPirateShipObject)
    {
        if (IsDynamicObjectMoving(sPirateShipObject))
            StopDynamicObject(sPirateShipObject);

        if (sPirateShip[PS_State] == PSS_Stopping)
        {
            StopPirateShipRide();
        }
        else
        {
            new Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ;
            GetDynamicObjectPos(sPirateShipObject, X, Y, Z);
            GetDynamicObjectRot(sPirateShipObject, RX, RY, RZ);
            if (sPirateShip[PS_CanMove])
            {
                MoveDynamicObject(sPirateShipObject, X, Y, RY < 0.0 ? Z + 0.1 : Z - 0.1, 0.01, 0.0, 0.0, 40.0);
                KillTimer(sPirateShip[PS_MoveTimer]);
                sPirateShip[PS_MoveTimer] = SetTimer("MovePirateShip", 1000, false);
                sPirateShip[PS_CanMove]   = false;
            }
            else
            {
                MoveDynamicObject(sPirateShipObject, X, Y, RY < 0.0 ? Z + 0.1 : Z - 0.1, 0.1, 0.0, RY < 0 ? RY - 3.0 : RY + 3.0, 40.0);
                sPirateShip[PS_CanMove] = true;
            }
        }
    }
    return 1;
}

hook OP_LeaveDynamicArea(playerid, areaid)
{
    if (sInPirateShip[playerid] && areaid == sPirateShip[PS_PirateArea])
    {
        LeavePirateShip(playerid);
    }
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken == EVENT_TOKEN_PIRATE_SHIP)
    {
        LeavePirateShip(playerid);
    }
}

static LeavePirateShip(playerid)
{
    sInPirateShip[playerid] = false;
    if (sPirateShip[PS_PlayersCount] > 0)
    {
        sPirateShip[PS_PlayersCount]--;
    }

    DeletePVar(playerid, "EventToken");
    SetPlayerToSpawn(playerid);
    return 1;
}

static StopPirateShipRide()
{
    foreach (new playerid : Player)
    {
        if (sInPirateShip[playerid])
        {
            LeavePirateShip(playerid);
        }
    }
    sPirateShip[PS_PlayersCount] = 0;
    sPirateShip[PS_State] = PSS_Idle;

    KillTimer(sPirateShip[PS_StartTimer]);
    KillTimer(sPirateShip[PS_MoveTimer]);

    sPirateShip[PS_AngleUpdate] = 0;
    sPirateShip[PS_AngleMovement] = 0;
    sPirateShip[PS_AngleDecrement] = false;
    sPirateShip[PS_CanMove] = false;
    sPirateShip[PS_MoveUp] = false;
}


stock UpdatePirateLabel()
{
    new string[256];
    if (sPirateShip[PS_State] == PSS_Started || sPirateShip[PS_State] == PSS_Stopping)
    {
        format(string, sizeof(string), "{FFFF00}Ride in progress!\nParticipants: {FF0000}%d", sPirateShip[PS_PlayersCount]);
    }
    else if (sPirateShip[PS_PlayersCount] == 0)
    {
        format(string, sizeof(string), "{FFFF00}Type {FF0000}/pirateship {FFFF00}to join in!\nWaiting for at least 1 participant");
    }
    else
    {
        format(string, sizeof(string), "{FFFF00}Type {FF0000}/pirateship {FFFF00}to join in!\nParticipants: {FF0000}%d\nRide Starts: %d", sPirateShip[PS_PlayersCount], sPirateShip[PS_StartTimer] - gettime());
    }
    UpdateDynamic3DTextLabelText(sPirateShip[PS_JoinText], 0xFFFFFFFF, string);
}

hook OnPlayerDisconnect(playerid)
{
    if (sInPirateShip[playerid] && sPirateShip[PS_PlayersCount] > 0)
    {
        sPirateShip[PS_PlayersCount]--;
    }
}
