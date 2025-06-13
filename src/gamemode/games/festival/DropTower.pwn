/// @file      Tower.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

#define EVENT_TOKEN_DROP_TOWER 0x45AAFD

static Float:cTowerJoin[Point4D] = { 1420.0839, -79.6418, 26.4147,  40.2862 };
static Float:cTowerExit[Point4D] = { 1421.8177, -78.2212, 26.4147, 212.9111 };
static Float:cTowerOrigin[2][Point4D] = {
    {1413.34216, -76.74107, 27.49859, 40.0},
    {1419.97156, -71.32480, 27.49860, 40.0}
};

static enum eTowerStatus
{
    TS_Waiting,
    TS_Starting,
    TS_Active
};

static enum eDropTower
{
    DT_Count,//Racer Count
    eTowerStatus:DT_Status,// 0 = Waiting for more players | 1 = Starting | 2 = Active/In Progress
    DT_Starting,//Countdown for race to start
    DT_Place, //Used to determine DT_Place within race.
    DT_Object
};
static sDropTower[2][eDropTower];
static sPlayerDropTower[MAX_PLAYERS];
static STREAMER_TAG_3D_TEXT_LABEL:sTowerText;

hook OnGameModeInit()
{
    sTowerText = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/droptower {FFFF00}to join in!", 0xFFFFFFF, cTowerJoin[P4_PosX], cTowerJoin[P4_PosY], cTowerJoin[P4_PosZ], 15.0);
    sDropTower[0][DT_Object] = CreateDynamicObject(19075, cTowerOrigin[0][P4_PosX], cTowerOrigin[0][P4_PosY], cTowerOrigin[0][P4_PosZ],   0.00000, 0.00000, cTowerOrigin[0][P4_Angle]);
    sDropTower[1][DT_Object] = CreateDynamicObject(19075, cTowerOrigin[1][P4_PosX], cTowerOrigin[1][P4_PosY], cTowerOrigin[1][P4_PosZ],   0.00000, 0.00000, cTowerOrigin[1][P4_Angle]);
}

hook OnPlayerInit(playerid)
{
    sPlayerDropTower[playerid] = -1;
}

hook OnPlayerDisconnect(playerid)
{
    new towerid = sPlayerDropTower[playerid];
    if (towerid != -1 && sDropTower[towerid][DT_Count] > 0)
    {
        sDropTower[towerid][DT_Count]--;
    }
}

CMD:droptower(playerid, params[])
{
    if (sPlayerDropTower[playerid] != -1)
    {
        LeaveDropTower(playerid);
    }

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, cTowerJoin[P4_PosX], cTowerJoin[P4_PosY], cTowerJoin[P4_PosZ]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, cTowerJoin[P4_PosX], cTowerJoin[P4_PosY], cTowerJoin[P4_PosZ], 5.0);
        }
        return SendClientMessage(playerid, COLOR_GREY, "You are not near the Drop Tower area!");
    }

    for (new towerid = 0; towerid < sizeof(sDropTower); towerid++)
    {
        if (sDropTower[towerid][DT_Status] != TS_Active && sDropTower[towerid][DT_Count] <= 5)
        {
            SetPlayerPos(playerid, cTowerExit[P4_PosX], cTowerExit[P4_PosY], cTowerExit[P4_PosZ]);
            SetPlayerFacingAngle(playerid, cTowerExit[P4_Angle]);
            SavePlayerVariables(playerid);

            SetPlayerHealth(playerid, 1000.0);
            TeleportToCoords(playerid,  1413.2607+Random(1, 4),-76.6478,27.0455, 0.0, 0, 0, true, false);
            SetPVarInt(playerid, "EventToken", EVENT_TOKEN_DROP_TOWER);
            sPlayerDropTower[playerid] = towerid;
            sDropTower[towerid][DT_Count]++;

            if (sDropTower[towerid][DT_Status] == TS_Waiting)
            {
                sDropTower[towerid][DT_Status] = TS_Starting;
                sDropTower[towerid][DT_Starting] = 30;
                SetTimerEx("StartTower", 1000, false, "i", 0);
            }
            UpdateTowerLabels();
            return 1;
        }
    }

    return SendClientMessage(playerid, -1, "The Drop Towers are full, please try again later!");
}

publish StartTower(towerid)
{
    if (--sDropTower[towerid][DT_Starting] == 0)
    {
        sDropTower[towerid][DT_Starting] = 3;
        sDropTower[towerid][DT_Place]    = 0;
        sDropTower[towerid][DT_Status]   = TS_Active;
        MoveDynamicObject(sDropTower[towerid][DT_Object], cTowerOrigin[towerid][P4_PosX], cTowerOrigin[towerid][P4_PosY], 126.9711, 3);
        foreach (new playerid : Player)
        {
            if (sPlayerDropTower[playerid] == towerid)
            {
                GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~GO!", 2000, 3);
            }
        }
    }
    else
    {
        new string[66];
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Drop Tower~n~Starting in %d seconds", sDropTower[towerid][DT_Starting]);
        foreach (new playerid : Player)
        {
            if (sPlayerDropTower[playerid] == towerid)
            {
                if (sDropTower[towerid][DT_Starting] <= 3)
                {
                    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
                }
                GameTextForPlayer(playerid, string, 1100, 3);
            }
        }
        if (sDropTower[towerid][DT_Count])
        {
            SetTimerEx("StartTower", 1000, false, "i", towerid);
        }
        else
        {
            sDropTower[towerid][DT_Place]  = 0;
            sDropTower[towerid][DT_Status] = TS_Waiting;
        }
    }
}

publish MoveTower(towerid)
{
    if (sDropTower[towerid][DT_Place])
    {
        MoveDynamicObject(sDropTower[towerid][DT_Object], cTowerOrigin[towerid][P4_PosX], cTowerOrigin[towerid][P4_PosY], cTowerOrigin[towerid][P4_PosZ], 5);
        sDropTower[towerid][DT_Place]  = 0;
        sDropTower[towerid][DT_Status] = TS_Waiting;
    }
    else if (--sDropTower[towerid][DT_Starting] == 0)
    {
        MoveDynamicObject(sDropTower[towerid][DT_Object], cTowerOrigin[towerid][P4_PosX], cTowerOrigin[towerid][P4_PosY], 35.8, 30);
        sDropTower[towerid][DT_Place] = 1;
    }
    else
    {
        SetTimerEx("MoveTower", 1000, false, "i", towerid);
    }
    return 1;
}

hook OnDynamicObjectMoved(objectid)
{
    for (new towerid = 0; towerid < sizeof(sDropTower); towerid++)
    {
        if (objectid == sDropTower[towerid][DT_Object])
        {
            if (sDropTower[towerid][DT_Status] == TS_Waiting)
            {
                SetTimerEx("RemovePlayersFromDropTower", 1000, 0, "dd", 0, towerid);
            }
            else if (sDropTower[towerid][DT_Place] == 0)
            {
                sDropTower[towerid][DT_Starting] = 3;
                SetTimerEx("MoveTower", 3 * 1000, false, "i", towerid);
            }
            else if (sDropTower[towerid][DT_Place] == 1)
            {
                MoveTower(towerid);
            }
        }
    }
    return 1;
}

publish RemovePlayersFromDropTower()
{
    foreach (new playerid : Player)
    {
        LeaveDropTower(playerid);
    }
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken == EVENT_TOKEN_DROP_TOWER)
    {
        LeaveDropTower(playerid);
    }
}

static LeaveDropTower(playerid)
{
    new towerid = sPlayerDropTower[playerid];
    if (towerid != -1)
    {
        sPlayerDropTower[playerid] = -1;
        if (sDropTower[towerid][DT_Count] > 0)
        {
            sDropTower[towerid][DT_Count]--;
        }
        UpdateTowerLabels();
        DeletePVar(playerid, "EventToken");
        SendClientMessage(playerid, COLOR_GREY, "Thanks for riding!");
        SetPlayerToSpawn(playerid);
    }
    return 1;
}

stock UpdateTowerLabels()
{
    new string[256];
    format(string, sizeof(string), "{FFFF00}Type {FF0000}/droptower {FFFF00}to join in!\n"\
           "Participants\nTower 1: %d", sDropTower[0][DT_Count]);
    UpdateDynamic3DTextLabelText(sTowerText, COLOR_GREY, string);
}
