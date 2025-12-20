/*
	InvalidCommand v2
	by Tr0Y

*/
#include <YSI\y_hooks>

static PlayerText:UnknowCmdTextDraw[MAX_PLAYERS][4];
static UnknowCmdTimer[MAX_PLAYERS];
static UnknowCmdAlpha[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    UnknowCmdTextDraw[playerid][0] = CreatePlayerTextDraw(playerid, 26.000000, 260.000000, "Unknown Command");
    PlayerTextDrawBackgroundColor(playerid, UnknowCmdTextDraw[playerid][0], 255);
    PlayerTextDrawFont(playerid, UnknowCmdTextDraw[playerid][0], 2);
    PlayerTextDrawLetterSize(playerid, UnknowCmdTextDraw[playerid][0], 0.160000, 1.000000);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][0], 0xFF000000);
    PlayerTextDrawSetOutline(playerid, UnknowCmdTextDraw[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, UnknowCmdTextDraw[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, UnknowCmdTextDraw[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, UnknowCmdTextDraw[playerid][0], 0);

    UnknowCmdTextDraw[playerid][1] = CreatePlayerTextDraw(playerid, 26.000000, 269.000000, "/help - /newb - /helpme");
    PlayerTextDrawBackgroundColor(playerid, UnknowCmdTextDraw[playerid][1], 255);
    PlayerTextDrawFont(playerid, UnknowCmdTextDraw[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, UnknowCmdTextDraw[playerid][1], 0.150000, 0.900000);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][1], 0x33CCFF00);
    PlayerTextDrawSetOutline(playerid, UnknowCmdTextDraw[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, UnknowCmdTextDraw[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, UnknowCmdTextDraw[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, UnknowCmdTextDraw[playerid][1], 0);

    UnknowCmdTextDraw[playerid][2] = CreatePlayerTextDraw(playerid, 167.000000, 261.000000, "New Textdraw");
    PlayerTextDrawBackgroundColor(playerid, UnknowCmdTextDraw[playerid][2], 255);
    PlayerTextDrawFont(playerid, UnknowCmdTextDraw[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, UnknowCmdTextDraw[playerid][2], 0.000000, 1.000000);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][2], 0xFFFFFF00);
    PlayerTextDrawSetOutline(playerid, UnknowCmdTextDraw[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, UnknowCmdTextDraw[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, UnknowCmdTextDraw[playerid][2], 1);
    PlayerTextDrawUseBox(playerid, UnknowCmdTextDraw[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, UnknowCmdTextDraw[playerid][2], 0x00000060);
    PlayerTextDrawTextSize(playerid, UnknowCmdTextDraw[playerid][2], -3.000000, 0.000000);
    PlayerTextDrawSetSelectable(playerid, UnknowCmdTextDraw[playerid][2], 0);

    UnknowCmdTextDraw[playerid][3] = CreatePlayerTextDraw(playerid, 7.000000, 258.000000, "?");
    PlayerTextDrawBackgroundColor(playerid, UnknowCmdTextDraw[playerid][3], 255);
    PlayerTextDrawFont(playerid, UnknowCmdTextDraw[playerid][3], 2);
    PlayerTextDrawLetterSize(playerid, UnknowCmdTextDraw[playerid][3], 0.620000, 2.499999);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][3], 0xFF060600);
    PlayerTextDrawSetOutline(playerid, UnknowCmdTextDraw[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, UnknowCmdTextDraw[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, UnknowCmdTextDraw[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, UnknowCmdTextDraw[playerid][3], 0);

    UnknowCmdAlpha[playerid] = 0;
    UnknowCmdTimer[playerid] = -1;

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(UnknowCmdTimer[playerid] != -1)
    {
        KillTimer(UnknowCmdTimer[playerid]);
        UnknowCmdTimer[playerid] = -1;
    }

    for(new i = 0; i < 4; i++)
    {
        if(UnknowCmdTextDraw[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(playerid, UnknowCmdTextDraw[playerid][i]);
            UnknowCmdTextDraw[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }

    return 1;
}

UpdateTextDrawAlpha(playerid, alpha)
{
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][0], (0xFF0000FF & 0xFFFFFF00) | alpha);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][1], (0x33CCFFFF & 0xFFFFFF00) | alpha);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][3], (0xFF0606FF & 0xFFFFFF00) | alpha);
    PlayerTextDrawColor(playerid, UnknowCmdTextDraw[playerid][2], (0xFFFFFFFF & 0xFFFFFF00) | alpha);

    for(new i = 0; i < 4; i++)
    {
        PlayerTextDrawShow(playerid, UnknowCmdTextDraw[playerid][i]);
    }
}

forward SmoothFadeTextDraw(playerid);
public SmoothFadeTextDraw(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        UnknowCmdTimer[playerid] = -1;
        return 0;
    }

    if(UnknowCmdAlpha[playerid] < 255)
    {
        UnknowCmdAlpha[playerid] += 15;
        if(UnknowCmdAlpha[playerid] > 255) UnknowCmdAlpha[playerid] = 255;

        UpdateTextDrawAlpha(playerid, UnknowCmdAlpha[playerid]);
        UnknowCmdTimer[playerid] = SetTimerEx("SmoothFadeTextDraw", 30, false, "i", playerid);
    }
    else
    {
        UnknowCmdTimer[playerid] = SetTimerEx("StartFadeOut", 3000, false, "i", playerid);
    }
    return 1;
}

forward StartFadeOut(playerid);
public StartFadeOut(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        UnknowCmdTimer[playerid] = -1;
        return 0;
    }

    UnknowCmdTimer[playerid] = SetTimerEx("SmoothFadeOut", 30, false, "i", playerid);
    return 1;
}

forward SmoothFadeOut(playerid);
public SmoothFadeOut(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        UnknowCmdTimer[playerid] = -1;
        return 0;
    }

    if(UnknowCmdAlpha[playerid] > 0)
    {
        UnknowCmdAlpha[playerid] -= 15;
        if(UnknowCmdAlpha[playerid] < 0) UnknowCmdAlpha[playerid] = 0;

        UpdateTextDrawAlpha(playerid, UnknowCmdAlpha[playerid]);
        UnknowCmdTimer[playerid] = SetTimerEx("SmoothFadeOut", 30, false, "i", playerid);
    }
    else
    {
        HideUnknownCommandTextDraw(playerid);
        UnknowCmdTimer[playerid] = -1;
    }
    return 1;
}

DisplayUnknownCmdDialog(playerid)
{
    if(UnknowCmdTimer[playerid] != -1)
    {
        KillTimer(UnknowCmdTimer[playerid]);
        UnknowCmdTimer[playerid] = -1;
    }

    UnknowCmdAlpha[playerid] = 0;
    UpdateTextDrawAlpha(playerid, 0);

    UnknowCmdTimer[playerid] = SetTimerEx("SmoothFadeTextDraw", 30, false, "i", playerid);

    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
}

HideUnknownCommandTextDraw(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    for(new i = 0; i < 4; i++)
    {
        if(UnknowCmdTextDraw[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, UnknowCmdTextDraw[playerid][i]);
        }
    }
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        DisplayUnknownCmdDialog(playerid);
    }
    return 1;
}