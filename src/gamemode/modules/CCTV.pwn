/// @file      CCTV.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-01-17 14:00:33 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

//update fbi help

#define MAX_CCTVS                   100
#define MAX_CCTVMENUS               10  // This number should be MAX_CCTVS divided by 10

//Menus:
static Menu:CCTVMenu[MAX_CCTVMENUS];
static MenuType[MAX_CCTVMENUS];
static TotalMenus = 0;
static PlayerMenu[MAX_PLAYERS];
enum LP
{
    Float:LX,
    Float:LY,
    Float:LZ,
    Float:LA,
    LInterior,
    LWorld
}
static LastPos[MAX_PLAYERS][LP];
static KeyTimer[MAX_PLAYERS];

//CameraInfo
static TotalCCTVS;
static CameraName[MAX_CCTVS][32];
static Float:CCTVLA[MAX_PLAYERS][3];  //CCTV LookAt
static Float:CCTVLAO[MAX_CCTVS][3];
static Float:CCTVRadius[MAX_PLAYERS]; //CCTV Radius
static Float:CCTVDegree[MAX_PLAYERS] = 0.0;
static Float:CCTVCP[MAX_CCTVS][4]; //CCTV CameraPos
static CurrentCCTV[MAX_PLAYERS] = -1;
static Text:CCTVMainTextDraw;


publish CheckKeyPress(playerid)
{
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
    if (CurrentCCTV[playerid] > -1 && PlayerMenu[playerid] == -1)
    {
        if (leftright == KEY_RIGHT)
        {
            if (keys == KEY_SPRINT)
            {
                CCTVDegree[playerid] = (CCTVDegree[playerid] - 2.0);
            }
            else
            {
                CCTVDegree[playerid] = (CCTVDegree[playerid] - 0.5);
            }
            if (CCTVDegree[playerid] < 0)
            {
                CCTVDegree[playerid] = 359;
            }
            MovePlayerCCTV(playerid);

        }
        if (leftright == KEY_LEFT)
        {
            if (keys == KEY_SPRINT)
            {
                CCTVDegree[playerid] = (CCTVDegree[playerid] + 2.0);
            }
            else
            {
                CCTVDegree[playerid] = (CCTVDegree[playerid] + 0.5);
            }
            if (CCTVDegree[playerid] >= 360)
            {
                CCTVDegree[playerid] = 0;
            }
            MovePlayerCCTV(playerid);

        }
        if (updown == KEY_UP)
        {
            if (CCTVRadius[playerid] < 25)
            {
                if (keys == KEY_SPRINT)
                {
                    CCTVRadius[playerid] =  (CCTVRadius[playerid] + 0.5);
                    MovePlayerCCTV(playerid);
                }
                else
                {
                    CCTVRadius[playerid] =  (CCTVRadius[playerid] + 0.1);
                    MovePlayerCCTV(playerid);
                }
            }
        }
        if (updown == KEY_DOWN)
        {
            if (keys == KEY_SPRINT)
            {
                if (CCTVRadius[playerid] >= 0.6)
                {
                    CCTVRadius[playerid] =  (CCTVRadius[playerid] - 0.5);
                    MovePlayerCCTV(playerid);
                }
            }
            else
            {
                if (CCTVRadius[playerid] >= 0.2)
                {
                    CCTVRadius[playerid] =  (CCTVRadius[playerid] - 0.1);
                    MovePlayerCCTV(playerid);
                }
            }
        }
        if (keys == KEY_CROUCH)
        {
            SetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
            SetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
            SetPlayerInterior(playerid, LastPos[playerid][LInterior]);
            SetPlayerInterior(playerid, LastPos[playerid][LWorld]);
            TogglePlayerControllable(playerid, 1);
            KillTimer(KeyTimer[playerid]);
            SetCameraBehindPlayer(playerid);
            TextDrawHideForPlayer(playerid, CCTVMainTextDraw);
            CurrentCCTV[playerid] = -1;
        }
    }
    MovePlayerCCTV(playerid);
}

stock MovePlayerCCTV(playerid)
{
    CCTVLA[playerid][0] = CCTVLAO[CurrentCCTV[playerid]][0] + (floatmul(CCTVRadius[playerid], floatsin(-CCTVDegree[playerid], degrees)));
    CCTVLA[playerid][1] = CCTVLAO[CurrentCCTV[playerid]][1] + (floatmul(CCTVRadius[playerid], floatcos(-CCTVDegree[playerid], degrees)));
    SetPlayerCameraLookAt(playerid, CCTVLA[playerid][0], CCTVLA[playerid][1], CCTVLA[playerid][2]);
}

stock AddCCTV(name[], Float:x, Float:y, Float:z, Float:a)
{
    if (TotalCCTVS >= MAX_CCTVS) return 0;
    format(CameraName[TotalCCTVS], 32, "%s", name);
    CCTVCP[TotalCCTVS][0] = x;
    CCTVCP[TotalCCTVS][1] = y;
    CCTVCP[TotalCCTVS][2] = z;
    CCTVCP[TotalCCTVS][3] = a;
    CCTVLAO[TotalCCTVS][0] = x;
    CCTVLAO[TotalCCTVS][1] = y;
    CCTVLAO[TotalCCTVS][2] = z - 10;
    TotalCCTVS++;
    return TotalCCTVS-1;
}

SetPlayerToCCTVCamera(playerid, CCTV)
{
    if (CCTV >= TotalCCTVS)
    {
        SendClientMessage(playerid, 0xFF0000AA, "Invalid CCTV");
        return 1;
    }
    if (CurrentCCTV[playerid] == -1)
    {
        GetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
        GetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
        LastPos[playerid][LInterior] = GetPlayerInterior(playerid);
        LastPos[playerid][LWorld] = GetPlayerVirtualWorld(playerid);
    }
    else
    {
        KillTimer(KeyTimer[playerid]);
    }
    CurrentCCTV[playerid] = CCTV;
    TogglePlayerControllable(playerid, 0);
    //SetPlayerPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], (CCTVCP[CCTV][2]-50));
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], -100.0);
    SetPlayerCameraPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], CCTVCP[CCTV][2]);
    SetPlayerCameraLookAt(playerid, CCTVLAO[CCTV][0], (CCTVLAO[CCTV][1]+0.2), CCTVLAO[CCTV][2]);
    CCTVLA[playerid][0] = CCTVLAO[CCTV][0];
    CCTVLA[playerid][1] = CCTVLAO[CCTV][1]+0.2;
    CCTVLA[playerid][2] = CCTVLAO[CCTV][2];
    CCTVRadius[playerid] = 12.5;
    CCTVDegree[playerid] = CCTVCP[CCTV][3];
    MovePlayerCCTV(playerid);
    KeyTimer[playerid] = SetTimerEx("CheckKeyPress", 75, 1, "i", playerid);
    TextDrawShowForPlayer(playerid, CCTVMainTextDraw);
    return 1;
}

hook OnLoadGameMode(timestamp)
{
    // CCTV's (10 MAX)
    AddCCTV("LS Grovestreet", 2491.7839, -1666.6194, 46.3232, 0.0);
    AddCCTV("LS Downtown", 1102.6440, -837.8973, 122.7000, 180.0);
    AddCCTV("SF Wang Cars", -1952.4282,285.9786,57.7031, 90.0);
    AddCCTV("SF Airport", -1275.8070, 52.9402, 82.9162, 0.0);
    AddCCTV("SF Crossroad", -1899.0861,731.0627,65.2969, 90.0);
    AddCCTV("SF Tower", -1753.6606,884.7520,305.8750, 150.0);
    AddCCTV("LV The Strip 1", 2137.2390, 2143.8286, 30.6719, 270.0);
    AddCCTV("LV The Strip 2", 1971.7627, 1423.9323, 82.1563, 270.0);
    AddCCTV("Mount Chiliad", -2432.5852, -1620.1143, 546.8554, 270.0);
    AddCCTV("Sherman Dam", -702.9260, 1848.8094, 116.0507, 0.0);
    AddCCTV("Desert", 35.1291, 2245.0901, 146.6797, 310.0);
    AddCCTV("Query", 588.1079,889.4715,-14.9023, 270.0);
    AddCCTV("Mining", 1254.1508,-1265.7378,15.3707, 90.0);

    // Create menus
    new Count, Left = TotalCCTVS;
    for (new menu=0; menu<MAX_CCTVMENUS; menu++)
    {
        if (0 <= Left && Left <= 12)
        {
            CCTVMenu[menu] = CreateMenu("Choose Camera:", 1, 200, 100, 220);
            TotalMenus++;
            MenuType[menu] = 2;
            new tmp = Left;
            for (new i; i<tmp; i++)
            {
                AddMenuItem(CCTVMenu[menu], 0, CameraName[Count]);
                Count++;
                Left--;
            }
        }
        else
        {
            CCTVMenu[menu] = CreateMenu("Choose Camera:", 1, 200, 100, 220);
            TotalMenus++;
            MenuType[menu] = 1;
            for (new i; i<11; i++)
            {
                AddMenuItem(CCTVMenu[menu], 0, CameraName[Count]);
                Count++;
                Left--;
            }
            AddMenuItem(CCTVMenu[menu], 0, "Next");
        }
    }



    CCTVMainTextDraw = TextDrawCreate(160, 400, "~y~Keys:~n~Arrow-Keys: ~w~Move The Camera~n~~y~Sprint-Key: ~w~Speed Up~n~~y~Crouch-Key: ~w~Exit Camera");
    TextDrawLetterSize(CCTVMainTextDraw, 0.4, 0.9);
    TextDrawSetShadow(CCTVMainTextDraw, 0);
    TextDrawUseBox(CCTVMainTextDraw,1);
    TextDrawBoxColor(CCTVMainTextDraw,0x00000055);
    TextDrawTextSize(CCTVMainTextDraw, 380, 400);
    return 1;
}

hook OnPlayerInit(playerid)
{
    CurrentCCTV[playerid] = -1;
    return 1;
}

CMD:cctv(playerid, params[])
{
    if (!IsLawEnforcement(playerid))
    {
        return SCM(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");
    }

    if (PlayerData[playerid][pDuty] == 0)
    {
        return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }

    if (!IsPlayerNearMDC(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not close to a computer of the Police Department and are not in a vehicle equipped with a Mobile Data Computer.");
    }

    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use the computer for moment.");
    }

    if (isnull(params))
    {
        SCM(playerid, COLOR_SYNTAX, "Usage: /cctv [on/off]");
    }
    else if (!strcmp(params, "on", true))
    {
        PlayerMenu[playerid] = 0;
        TogglePlayerControllable(playerid, 0);
        ShowMenuForPlayer(CCTVMenu[0], playerid);
        SendClientMessageEx(playerid, COLOR_GREY, "Press <SPACE> to select camera or <ENTER> to exit.");
    }
    else if (!strcmp(params, "off", true))
    {
        if (CurrentCCTV[playerid] > -1)
        {
            SetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
            SetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
            SetPlayerInterior(playerid, LastPos[playerid][LInterior]);
            TogglePlayerControllable(playerid, 1);
            KillTimer(KeyTimer[playerid]);
            SetCameraBehindPlayer(playerid);
            TextDrawHideForPlayer(playerid, CCTVMainTextDraw);
            CurrentCCTV[playerid] = -1;
        }
    }
    return 1;
}

hook OnGameModeExit()
{
        // CCTV
    TextDrawHideForAll(CCTVMainTextDraw);
    TextDrawDestroy(CCTVMainTextDraw);
    for (new i; i<TotalMenus; i++)
    {
        DestroyMenu(CCTVMenu[i]);
    }
    return 1;
}

hook OnPlayerExitedMenu(playerid)
{
    // unfreeze the player when they exit a menu
    new Menu:Current = GetPlayerMenu(playerid);
    for (new menu; menu<TotalMenus; menu++)
    {
        if (Current == CCTVMenu[menu])
        {
            TogglePlayerControllable(playerid,1);
            return 1;
        }
    }
    return 1;
}
hook OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:Current = GetPlayerMenu(playerid);
    for (new menu; menu<TotalMenus; menu++)
    {

        if (Current == CCTVMenu[menu])
        {
            if (MenuType[PlayerMenu[playerid]] == 1)
            {
                if (row == 11)
                {
                    ShowMenuForPlayer(CCTVMenu[menu+1], playerid);
                    TogglePlayerControllable(playerid, 0);
                    PlayerMenu[playerid] = (menu+1);
                }
                else
                {
                    if (PlayerMenu[playerid] == 0)
                    {
                        SetPlayerToCCTVCamera(playerid, row);
                        PlayerMenu[playerid] = -1;
                    }
                    else
                    {
                        SetPlayerToCCTVCamera(playerid, ((PlayerMenu[playerid]*11)+row));
                        PlayerMenu[playerid] = -1;
                    }
                }
            }
            else
            {
                if (PlayerMenu[playerid] == 0)
                {
                    SetPlayerToCCTVCamera(playerid, row);
                    PlayerMenu[playerid] = -1;
                }
                else
                {
                    SetPlayerToCCTVCamera(playerid, ((PlayerMenu[playerid]*11)+row));
                    PlayerMenu[playerid] = -1;
                }
            }
        }
    }

    return 1;
}
