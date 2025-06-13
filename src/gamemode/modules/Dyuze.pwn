/// @file      Dyuze.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-04-09 22:49:41 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerText:DyuzePlayerText[MAX_PLAYERS];
static DyuzeState[MAX_PLAYERS];
static DyuzeTimer[MAX_PLAYERS];


stock Dyuze(playerid, title[], string[], time = 5000)
{
    if (DyuzeState[playerid])
    {
        PlayerTextDrawHide(playerid, DyuzePlayerText[playerid]);
        KillTimer(DyuzeTimer[playerid]);
    }
    new string2[128];
    format(string2, sizeof(string2), "%s~n~_", title);
    PlayerTextDrawSetString(playerid, DyuzePlayerText[playerid], string2);
    PlayerTextDrawShow(playerid, DyuzePlayerText[playerid]);

    PlayerTextDrawSetString(playerid, DyuzePlayerText[playerid], string);
    PlayerTextDrawShow(playerid, DyuzePlayerText[playerid]);

    DyuzeState[playerid] = true;
    DyuzeTimer[playerid] = SetTimerEx("HidetheDyuze", time, false, "d", playerid);
}

publish HidetheDyuze(playerid)
{
    if (!DyuzeState[playerid])
        return 0;

    DyuzeState[playerid] = false;
    PlayerTextDrawHide(playerid, DyuzePlayerText[playerid]);
    return 1;
}

hook OnPlayerInit(playerid)
{
    DyuzePlayerText[playerid] = CreatePlayerTextDraw(playerid, 17.000000, 129.000000, "Alex Guitreez Turned On The Engine");
    PlayerTextDrawFont(playerid, DyuzePlayerText[playerid], 1);
    PlayerTextDrawLetterSize(playerid, DyuzePlayerText[playerid], 0.170833, 1.149997);
    PlayerTextDrawTextSize(playerid, DyuzePlayerText[playerid], 131.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, DyuzePlayerText[playerid], 1);
    PlayerTextDrawSetShadow(playerid, DyuzePlayerText[playerid], 0);
    PlayerTextDrawAlignment(playerid, DyuzePlayerText[playerid], 1);
    PlayerTextDrawColor(playerid, DyuzePlayerText[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, DyuzePlayerText[playerid], 255);
    PlayerTextDrawBoxColor(playerid, DyuzePlayerText[playerid], 50);
    PlayerTextDrawUseBox(playerid, DyuzePlayerText[playerid], 1);
    PlayerTextDrawSetProportional(playerid, DyuzePlayerText[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, DyuzePlayerText[playerid], 0);
    return 1;
}
