/// @file      ObservationTower.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

#define EVENT_TOKEN_OBSERVATION_TOWER 0x458FABE

// TODO: multiple decks

static Float:cTowerJoin[Point4D] = { 1525.3893, -83.8848, 23.2147,  0.0 };
static Float:cTowerExit[Point4D] = { 1421.8177, -78.2212, 26.4147, 212.9111 };
static cTowerList[][ObjectInfo] = {
    { 19278, 1534.3413, -69.6056, -20.4836, 0.0, 0.0, 0.0 }
};

static cTowerObjs[][ObjectInfo] = {
    { 19278, 1534.3413, -69.6056, -20.4836,  0.0,   0.0, 0.0 },
    { 19278,    0.0000,   0.0000,  -6.4380,  0.0,   0.0, 0.0 },
    { 19278,    0.0000,   0.0000,  -3.1320,  0.0,   0.0, 0.0 },
    { 970,     -4.3013,  -3.2744,  46.9836,  0.0,   0.0, -53.0 },
    { 970,     -4.3013,  -3.2744,  43.6736,  0.0,   0.0, -53.0 },
    { 19325,   -1.7359,  -5.0149,  46.2469, 90.0,  70.0, 0.0 },
    { 19325,    2.0693,  -4.8495,  46.2469, 90.0, 115.0, 0.0 },
    { 19325,    4.8420,  -2.1255,  46.2469, 90.0, 154.0, 0.0 },
    { 19325,    5.1097,   1.6898,  46.2469, 90.0,  18.0, 0.0 },
    { 19325,    2.6875,   4.6824,  46.2469, 90.0,  60.0, 0.0 },
    { 19325,   -1.1153,   5.2857,  46.2469, 90.0, 102.0, 0.0 },
    { 19325,   -4.3434,   3.1905,  46.2469, 90.0, 144.0, 0.0 },
    { 19325,   -5.3405,  -0.5285,  46.2469, 90.0,   6.0, 0.0 }
};

static const Float:cPlayerSpawnCoords[5][Point4D] = {
    {1531.2751, -72.3726, 23.6487, 0.0},
    {1536.2238, -72.3415, 23.6487, 0.0},
    {1536.7957, -67.4150, 23.6487, 0.0},
    {1532.5234, -66.6518, 23.6487, 0.0},
    {1530.5852, -69.1646, 23.6487, 0.0}
};

static enum eTowerStatus
{
    TS_Waiting,
    TS_Starting,
    TS_Active
};
static enum eObservationTower
{
    eTowerStatus:OT_Status,   // 0 = Waiting for more players | 1 = Starting | 2 = Active/In Progress
    OT_Count,    // Racer Count
    OT_Starting, // Countdown for race to start
    OT_Place     // Used to determine OT_Place within race.
};
static sTowerObjs[sizeof(cTowerObjs)];
static sTowerList[sizeof(cTowerList)];
static sOTower[sizeof(cTowerList)][eObservationTower];
static sPlayerTower[MAX_PLAYERS];
static STREAMER_TAG_3D_TEXT_LABEL:sTowerJoinText;


hook OnGameModeInit()
{
    sTowerJoinText = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/otower {FFFF00}to join in!", 0xFFFFFFF, cTowerJoin[P4_PosX], cTowerJoin[P4_PosY], cTowerJoin[P4_PosZ], 15.0);

    for (new towerid = 0; towerid < sizeof(cTowerList); towerid++)
    {
        //TODO: Streamer Plugin: AttachDynamicObjectToObject: YSF plugin (a version having the AttachPlayerObjectToObject function) must be loaded to attach objects to objects.
        sTowerList[towerid] = CreateObject(19278, 1534.3413, -69.6056, -20.4836, 0.0, 0.0, 0.0);
        new obj = CreateObject(19278, 1534.34131, -69.60560, -26.92160, 0.0, 0.0, 0.0);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19278, 1534.34131, -69.60560, -23.61560, 0.0, 0.0, 0.0);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(970, 1530.04, -72.88, 26.50,   0.00, 0.00, -53.00);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(970, 1530.04, -72.88, 23.19,   0.00, 0.00, -53.00);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1532.60547, -74.62054, 25.76330, 90.0, 0.0, 70.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1536.41064, -74.45510, 25.76330, 90.0, 0.0, 115.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1539.18335, -71.73110, 25.76330, 90.0, 0.0, 154.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1539.45105, -67.91582, 25.76330, 90.0, 0.0, 18.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1537.02881, -64.92320, 25.76330, 90.0, 0.0, 60.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1533.22607, -64.31990, 25.76330, 90.0, 0.0, 102.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1529.99792, -66.41510, 25.76330, 90.0, 0.0, 144.00000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        obj = CreateObject(19325, 1529.00085, -70.13410, 25.76330, 90.0, 0.0, 6.0000);
        AttachObjectToObject(obj, sTowerList[towerid], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

        /*for (new i = 0; i < sizeof(cTowerObjs); i++) //TODO: use generic coords
        {
            sTowerObjs[i] = CreateDynamicObject(cTowerObjs[i][OI_Id], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToObject(sTowerObjs[i], sTowerList[towerid],
                cTowerObjs[i][OI_PosX], cTowerObjs[i][OI_PosY], cTowerObjs[i][OI_PosZ],
                cTowerObjs[i][OI_RotX], cTowerObjs[i][OI_RotY], cTowerObjs[i][OI_RotZ], 1);
        }*/
    }
}

hook OnPlayerInit(playerid)
{
    sPlayerTower[playerid] = -1;
}

hook OnPlayerDisconnect(playerid)
{
    new towerid = sPlayerTower[playerid];
    if (towerid != -1 && sOTower[towerid][OT_Count] > 0)
    {
        sOTower[towerid][OT_Count]--;
    }
}

CMD:otower(playerid, params[])
{
    if (sPlayerTower[playerid] != -1)
    {
        return LeaveObservationTower(playerid);
    }

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1525.3893,-83.8848,23.2147))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1525.3893,-83.8848,23.2147, 5.0);
        }
        return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the Observation Tower area!");
    }

    for (new towerid = 0; towerid < sizeof(sOTower); towerid++)
    {
        new nbPlayers = sOTower[towerid][OT_Count];
        if (sOTower[towerid][OT_Status] != TS_Active && nbPlayers <= 5)
        {
            SetPlayerPos(playerid, cTowerExit[P4_PosX], cTowerExit[P4_PosY], cTowerExit[P4_PosZ]);
            SetPlayerFacingAngle(playerid, cTowerExit[P4_Angle]);
            SavePlayerVariables(playerid);

            sPlayerTower[playerid] = towerid;
            SetPlayerHealth(playerid, 1000.0);
            SetPVarInt(playerid, "EventToken", EVENT_TOKEN_OBSERVATION_TOWER);
            TeleportToCoords(playerid, cPlayerSpawnCoords[nbPlayers][P4_PosX], cPlayerSpawnCoords[nbPlayers][P4_PosY],
                cPlayerSpawnCoords[nbPlayers][P4_PosZ], cPlayerSpawnCoords[nbPlayers][P4_Angle], 0, 0, true, false);
            sOTower[towerid][OT_Count]++;

            if (sOTower[towerid][OT_Status] == TS_Waiting)
            {
                sOTower[towerid][OT_Status]   = TS_Starting;
                sOTower[towerid][OT_Starting] = 30;
                SetTimerEx("StartOTower", 1000, false, "i", towerid);
            }
            UpdateObservationTowerLabel();
            return 1;
        }
    }
    return SendClientMessageEx(playerid, COLOR_GREY, "The Observation Tower is either full or in progress, please try again later!");
}

publish StartOTower(towerid)
{
    if (--sOTower[towerid][OT_Starting] == 0)
    {
        MoveObject(sTowerList[towerid], cTowerList[towerid][OI_PosX],
            cTowerList[towerid][OI_PosY], cTowerList[towerid][OI_PosZ] + 100.0, 2);
        sOTower[towerid][OT_Status] = TS_Active;
        sOTower[towerid][OT_Place] = 0;
        foreach (new playerid : Player)
        {
            if (sPlayerTower[playerid] == towerid)
            {
                GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~GO!", 2000, 3);
            }
        }
    }
    else
    {
        new string[66];
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Observation Tower~n~Starting in %d seconds", sOTower[towerid][OT_Starting]);
        foreach (new playerid : Player)
        {
            if (sPlayerTower[playerid] == towerid)
            {
                if (sOTower[towerid][OT_Starting] <= 3)
                {
                    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
                }
                GameTextForPlayer(playerid, string, 1100, 3);
            }
        }

        if (sOTower[towerid][OT_Count])
        {
            SetTimerEx("StartOTower", 1000, false, "i", towerid);
        }
        else
        {
            sOTower[towerid][OT_Place]  = 0;
            sOTower[towerid][OT_Status] = TS_Waiting;
        }
    }
}

hook OnDynamicObjectMoved(objectid)
{
    for (new towerid = 0; towerid < sizeof(sTowerList); towerid++)
    {
        if (objectid == sTowerList[towerid])
        {
            if (sOTower[towerid][OT_Status] == TS_Waiting)
            {
                SetTimerEx("RemovePlayersFromOTower", 1000, false, "i", towerid);
            }
            else if (sOTower[towerid][OT_Place] == 0)
            {
                sOTower[towerid][OT_Place] = 1;
                sOTower[towerid][OT_Starting] = 10;
                SetTimerEx("MoveOTower", 1000, false, "i", towerid);
            }
        }
    }
    return 1;
}


publish MoveOTower(towerid)
{
    if (sOTower[towerid][OT_Place] == 1)
    {
        if (--sOTower[towerid][OT_Starting] == 0)
        {
            MoveObject(sTowerList[towerid], cTowerList[towerid][OI_PosX],
                cTowerList[towerid][OI_PosY], cTowerList[towerid][OI_PosZ], 2);
            sOTower[towerid][OT_Place] = 0;
            sOTower[towerid][OT_Status] = TS_Waiting;
        }
        else
        {
            SetTimerEx("MoveOTower", 1000, false, "i", towerid);
        }
        return 1;
    }
    return 1;
}

static LeaveObservationTower(playerid)
{
    new towerid = sPlayerTower[playerid];
    if (towerid != -1)
    {
        sPlayerTower[playerid] = -1;
        if (sOTower[towerid][OT_Count] > 0)
        {
            sOTower[towerid][OT_Count]--;
        }
        UpdateObservationTowerLabel();
        DeletePVar(playerid, "EventToken");
        SendClientMessage(playerid, COLOR_GREY, "Thanks for riding!");
        SetPlayerToSpawn(playerid);
    }
    return 1;
}

publish RemovePlayersFromOTower(towerid)
{
    foreach (new playerid : Player)
    {
        if (sPlayerTower[playerid] == towerid)
        {
            LeaveObservationTower(playerid);
        }
    }
    return 1;
}

static UpdateObservationTowerLabel()
{
    new string[256];
    format(string, sizeof(string), "{FFFF00}Type {FF0000}/otower {FFFF00}\nto join in!\n"\
                                   "Participants: %d", sOTower[0][OT_Count]);
    UpdateDynamic3DTextLabelText(sTowerJoinText, 0xFFFFFFFF, string);
}
