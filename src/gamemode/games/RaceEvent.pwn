/// @file      RaceEvent.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

//============================= Race Varaibles ======================================//
static Float:CP_SIZE = 10.0;
static RACE_STARTED;
static RACE_ADMIN_ID;
static RACE_CP[MAX_PLAYERS];
static PLAYER_IN_RACE[MAX_PLAYERS];
static CREATING_RACE_CHECKPOINTS;
static CP_COUNTER;
static Float:Rx[100] , Float:Ry[100] , Float:Rz[100];
static RACE_COUNT_DOWN , RACE_TIMER;
static RACE_EVENT_ACTIVE;
static FREEZE_PLAYER[MAX_PLAYERS];
static RaceVehicles[MAX_PLAYERS];
static RACE_CREATED;
static TOTAL_RACE_CP;
static Cash[] = {50000,100000,80000,90000,70000};

hook OnPlayerInit(playerid)
{
    PLAYER_IN_RACE[playerid] = 0;
    RACE_CP[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (RACE_ADMIN_ID == playerid && CREATING_RACE_CHECKPOINTS == 1 &&   RACE_CREATED == 0)
    {
        CREATING_RACE_CHECKPOINTS = 0;
        RACE_ADMIN_ID = -1;
    }
    if (PLAYER_IN_RACE[playerid])
    {
        PLAYER_IN_RACE[playerid] = 0;
        RACE_CP[playerid] = 0;
        KillTimer(FREEZE_PLAYER[playerid]);
        CancelActiveCheckpoint(playerid);
        if (RaceVehicles[playerid])
            DestroyVehicleEx(RaceVehicles[playerid]);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_FIRE) && CREATING_RACE_CHECKPOINTS == 1 && RACE_ADMIN_ID == playerid && CP_COUNTER <= TOTAL_RACE_CP)
    {
        new Float: X , Float: Y , Float: Z;
        for (new i = CP_COUNTER; i <= TOTAL_RACE_CP ; i++)
        {
                if (CP_COUNTER == TOTAL_RACE_CP)
                {
                    GetPlayerPos(playerid,X,Y,Z);
                    Rx[i]= X , Ry[i] = Y , Rz[i] = Z;
                    RACE_CREATED = 1;
                    CP_COUNTER = 0;
                    CREATING_RACE_CHECKPOINTS = 0;
                    RACE_ADMIN_ID = -1;
                    SendClientMessage(playerid,COLOR_GREEN,"Congratz You've successfully created Race checkpoints.");
                    break;
                }
                else
                {
                    GetPlayerPos(playerid,X,Y,Z);
                    Rx[i]= X , Ry[i] = Y , Rz[i] = Z;
                    break;
                }
        }
        new string[128];
        format(string, sizeof(string), "~r~RACE CHECKPOINT~n~~n~~y~ID %d~n~successfully created~n~~r~Total CP ~y~~n~(%d / %d).",CP_COUNTER,CP_COUNTER,TOTAL_RACE_CP);
        GameTextForPlayer(playerid,string,1500,3);
        CP_COUNTER++;
    }
    return 1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_RACE)
        return 1;
    if (PLAYER_IN_RACE[playerid] &&
        RACE_STARTED == 1 &&
        RACE_EVENT_ACTIVE == 1 &&
        IsPlayerInAnyVehicle(playerid) &&
        RACE_COUNT_DOWN <= 1)
    {
        for (new i = RACE_CP[playerid]; i <= TOTAL_RACE_CP ; i++)
        {
            if (RACE_CP[playerid] == TOTAL_RACE_CP )
            {
                new cashAmount = Cash[random(5)];
                new string[128];
                format(string,sizeof(string),"Congratulation %s has completed the race at First Position and won %d",GetName(playerid),cashAmount);
                SendClientMessageToAll(COLOR_YELLOW,string);
                GivePlayerCash(playerid,cashAmount);
                RACE_STARTED = 0;
                RACE_EVENT_ACTIVE = 0;
                foreach(new a : Player)
                {
                    if (PLAYER_IN_RACE[a])
                    {
                        PLAYER_IN_RACE[a] = 0;
                        RACE_CP[a] = 0;
                        CancelActiveCheckpoint(a);
                        SetPlayerWeapons(a);
                        SetPlayerToSpawn(a);
                        if (RaceVehicles[a])
                            DestroyVehicleEx(RaceVehicles[a]);
                    }
                }
                PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
                break;
            }
            else
            {
                new string[128];
                format(string,sizeof(string),"~y~You've successfully ~n~~r~captured %d checkpoints ~n~~b~Total CP (%d | 14) ",RACE_CP[playerid],RACE_CP[playerid]);
                GameTextForPlayer(playerid,string,1000,5);
                SetActiveRaceCheckpoint(playerid, CHECKPOINT_RACE, Rx[i], Ry[i], Rz[i], CP_SIZE); //TODO: use type = 1
                PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
                RACE_CP[playerid]++;
                GetTopRacer();
                break;
            }
        }
    }


    return 1;
}

Dialog:DIALOG_RACE(playerid, response, listitem, inputtext[])
{
    switch (listitem)
    {
            case 0:CreateRaceVehicle(playerid,541);
            case 1:CreateRaceVehicle(playerid,451);
            case 2:CreateRaceVehicle(playerid,560);
            case 3:CreateRaceVehicle(playerid,602);
            case 4:CreateRaceVehicle(playerid,494);
            case 5:CreateRaceVehicle(playerid,495);
            case 6:CreateRaceVehicle(playerid,405);
    }
}

CreateRaceVehicle(playerid,vehicleid)
{
    new Float:pX,Float:pY,Float:pZ,Float:pw;
    GetPlayerPos(playerid, pX,pY,pZ);
    GetPlayerFacingAngle(playerid, pw);
    RaceVehicles[playerid] = CreateVehicle(vehicleid, pX, pY, pZ, pw, 0, 0, 0);
    PutPlayerInVehicle(playerid, RaceVehicles[playerid], 0);
    FREEZE_PLAYER[playerid] = SetTimerEx("RaceOnPlayerFreezed",10000,0,"i",playerid);
    SendClientMessage(playerid,COLOR_GREEN,"You've 10 seconds to set your vehicle position.");
    return 1;
}

publish RaceOnPlayerFreezed(playerid)
{
    SendClientMessage(playerid,COLOR_GREEN,"You're freezed now! Please wait other member to join the race.");
    KillTimer(FREEZE_PLAYER[playerid]);
    TogglePlayerControllableEx(playerid, 0);
    return 1;
}

GetName(playerid)
{
    new JName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,JName,MAX_PLAYER_NAME);
    return JName;
}

GetTopRacer()
{
    new string[128],TOP_RACER;
    foreach(new i : Player)
    {
        if (PLAYER_IN_RACE[i])
        {
            if (RACE_CP[i] > TOP_RACER)
            {
                TOP_RACER = RACE_CP[i];
                format(string,sizeof(string),"%s is now leading the race by capturing %d checkpoints",GetName(i),RACE_CP[i]);
                SendMessageToAllRacers(COLOR_GREEN,string);
            }
        }
    }
}

SendMessageToAllRacers(Color,string[])
{
    foreach(new i : Player)
    {
        if (PLAYER_IN_RACE[i])
        {
            SendClientMessage(i,Color,string);
        }
    }
}

publish OnPlayerRaceCountDown()
{
    new string[128];
    RACE_COUNT_DOWN -- ;
    if (RACE_COUNT_DOWN <= 1)
    {
        format(string, sizeof(string), "~r~RACE IS~n~~b~STARTED~n~~r~Lets~y~Go");
        KillTimer(RACE_TIMER);
        foreach(new i : Player)
        {
            if (PLAYER_IN_RACE[i])
            {
                TogglePlayerControllableEx(i, 1);
                GameTextForPlayer(i,string,2000,3);
                PlayerPlaySound(i, 4203, 0.0, 0.0, 0.0);
            }
        }
    }
    format(string, sizeof(string), "~r~RACE IS GOING~n~~n~~y~TO~n~Start In~n~~r~%d ~y~~n~seconds.",RACE_COUNT_DOWN);
    foreach(new i : Player)
    {
        if (PLAYER_IN_RACE[i])
        {
            GameTextForPlayer(i,string,1000,3);
            PlayerPlaySound(i, 4203, 0.0, 0.0, 0.0);
        }
    }
    return 1;
}

TOTAL_PLAYER_IN_RACE()
{
    new count;
    foreach(new i : Player)
    {
        if (PLAYER_IN_RACE[i])
        {
            count++;
        }
    }
    return count;
}


CMD:racehelp(playerid)
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    SendClientMessage(playerid,COLOR_YELLOW,"** RACE SYSTEM : /createrace /enableraceevent /startrace   /endrace /deleterace /joinrace /topracer");
    return 1;
}

CMD:deleterace(playerid)
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (CREATING_RACE_CHECKPOINTS == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Some budy is already make race at a moment.");
    if (RACE_STARTED == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Please let the race finish first.");
    CREATING_RACE_CHECKPOINTS = 0;
    CP_COUNTER = 0;
    RACE_STARTED = 0;
    RACE_ADMIN_ID = -1;
    SendClientMessage(playerid,COLOR_GREEN,"You've successfully delete the race.");
    return 1;
}

CMD:createrace(playerid,params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (CREATING_RACE_CHECKPOINTS == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Some budy is already make race at a moment.");
    if (RACE_STARTED == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Please let the race finish first.");
    if (sscanf(params,"i",TOTAL_RACE_CP))return SendClientMessage(playerid,COLOR_GREEN,"/createrace [Checkpoints 1-99]");
    if (0  > TOTAL_RACE_CP > 100)return SendClientMessage(playerid,COLOR_GREEN,"Checkpoint Must be greater than 0 and less than 100");
    RACE_ADMIN_ID = playerid;
    CREATING_RACE_CHECKPOINTS = 1;
    CP_COUNTER = 0;
    SendClientMessage(playerid,COLOR_GREEN,"You've to press Fire Key to create checkpoints.");
    return 1;
}

CMD:enableraceevent(playerid)
{
    new string[128];
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (RACE_CREATED == 0)return SendClientMessage(playerid,COLOR_GREEN,"You need to create checkpoint to start the race.");
    if (RACE_STARTED == 1)return SendClientMessage(playerid,COLOR_GREEN,"Race is already enabled .");
    RACE_STARTED = 1;
    format(string,sizeof(string),"Admin %s started race event type /joinrace to join race.",GetName(playerid));
    SendClientMessageToAll(COLOR_YELLOW,string);
    SendClientMessage(playerid,COLOR_GREEN," You've successfully turn on the race event /startrace to start the race.");
    return 1;
}

CMD:endrace(playerid)
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }   if (RACE_STARTED == 0)return SendClientMessage(playerid,COLOR_GREY,"There is no race going on at moment.");
    RACE_STARTED = 0;
    RACE_EVENT_ACTIVE = 0;
    foreach(new i : Player)
    {
        if (PLAYER_IN_RACE[i])
        {
            PLAYER_IN_RACE[i] = 0;
            RACE_CP[i] = 0;
            CancelActiveCheckpoint(i);
            TogglePlayerControllableEx(i, 1);
            if (RaceVehicles[i])
                DestroyVehicleEx(RaceVehicles[i]);
            SetPlayerWeapons(i);
            SetPlayerToSpawn(i);
        }
    }
    KillTimer(RACE_TIMER);
    SendClientMessage(playerid,COLOR_GREEN,"You've successfully stop the race.");
    return 1;
}

CMD:startrace(playerid)
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (RACE_STARTED == 0)return SendClientMessage(playerid,COLOR_GREEN,"There is no race going on at moment.");
    if (RACE_EVENT_ACTIVE == 1)return SendClientMessage(playerid,COLOR_GREEN,"Race event is already going on at moment.");
    RACE_EVENT_ACTIVE = 1;
    RACE_COUNT_DOWN = 15;
    SendClientMessage(playerid,COLOR_GREEN,"You've successfully started the race event.");
    RACE_TIMER = SetTimer("OnPlayerRaceCountDown",1000,1);
    return 1;
}

CMD:joinrace(playerid,params[])
{
    if (RACE_EVENT_ACTIVE == 1)return SendClientMessage(playerid,COLOR_GREY,"You're late try next time.");
    new string[128];
    if (RACE_STARTED == 1)
    {
        PLAYER_IN_RACE[playerid] = 1;
        RACE_CP[playerid] = 0;
        SavePlayerVariables(playerid);
        ResetPlayerWeapons(playerid);
        SetPlayerPos(playerid,Rx[0],Ry[0],Rz[0]);
        SetActiveRaceCheckpoint(playerid, CHECKPOINT_RACE, Rx[0], Ry[0], Rz[0], CP_SIZE); //TODO: use type = 1
        Dialog_Show(playerid, DIALOG_RACE, DIALOG_STYLE_LIST, "Race Cars Menu", "Bullet\nTurismo\nSultan\nAlpha\nHotring\nSandking\nSentinel","Spawn" ,"Close");
        SendClientMessage(playerid,COLOR_GREEN,"You've successfully join the race event.");
        SendClientMessage(playerid,COLOR_GREEN,"Please wait some seconds let other racers join the race.");
        format(string,sizeof(string),"Total number of players in race %d.",TOTAL_PLAYER_IN_RACE());
        SendClientMessageToAll(-1,string);
    }
    return 1;
}

CMD:leaverace(playerid,params[])
{
    if (!PLAYER_IN_RACE[playerid])return SendClientMessage(playerid,COLOR_GREEN,"You didn't join any race yet.");
    PLAYER_IN_RACE[playerid] = 0;
    RACE_CP[playerid] = 0;
    CancelActiveCheckpoint(playerid);
    SetPlayerWeapons(playerid);
    SetPlayerToSpawn(playerid);
    TogglePlayerControllableEx(playerid, 1);
    if (RaceVehicles[playerid])
        DestroyVehicleEx(RaceVehicles[playerid]);
    SendClientMessage(playerid,COLOR_GREEN,"You've successfully left the race event.");
    return 1;
}

CMD:topracer(playerid)
{
    GetTopRacer();
    return 1;
}
