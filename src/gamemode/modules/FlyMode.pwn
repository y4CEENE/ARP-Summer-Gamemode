/// @file      FlyMode.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-05-08 21:55:42 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerText:FlyModeCoordsText[MAX_PLAYERS];

hook OnPlayerCameraUpdate(playerid, Float:oldx, Float:oldy, Float:oldz, olddir, Float:newx, Float:newy, Float:newz, newdir)
{
    new string[256];
    new Float:fVX, Float:fVY, Float:fVZ;
    GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
    format(string, sizeof(string), "X: %.4f, Y: %.4f, Z: %.4f, fVX: %.4f, fVY: %.4f, fVZ: %.4f,", newx, newy, newz, fVX, fVY, fVZ);
    PlayerTextDrawSetString(playerid, FlyModeCoordsText[playerid], string);
}

hook OnPlayerConnect(playerid)
{
    FlyModeCoordsText[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 335.000000, "X: , Y: , Z: , DIR: ");
    PlayerTextDrawAlignment      (playerid, FlyModeCoordsText[playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, FlyModeCoordsText[playerid], 255);
    PlayerTextDrawFont           (playerid, FlyModeCoordsText[playerid], 2);
    PlayerTextDrawLetterSize     (playerid, FlyModeCoordsText[playerid], 0.309997, 1.799999);
    PlayerTextDrawColor          (playerid, FlyModeCoordsText[playerid], -1);
    PlayerTextDrawSetOutline     (playerid, FlyModeCoordsText[playerid], 0);
    PlayerTextDrawSetProportional(playerid, FlyModeCoordsText[playerid], 1);
    PlayerTextDrawSetShadow      (playerid, FlyModeCoordsText[playerid], 1);
}

CMD:ibelieveicanfly(playerid, params[])
{
    if (!IsGodAdmin(playerid) && GetGraphicDesignerRank(playerid) < GRAPHICRANK_EDITOR)
    {
        return 0;
    }
    new option[10], param[12];
    if (sscanf(params, "s[10]S()[12]", option, param))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ibelieveicanfly [on | off | speed | text]");
    }

    if (!strcmp(option, "off", true))
    {
        PlayerTextDrawHide(playerid, FlyModeCoordsText[playerid]);
        SetPlayerCamera(playerid, 0);
        return callcmd::spec(playerid, "off");
    }
    else if (!strcmp(option, "on", true))
    {
        PlayerTextDrawShow(playerid, FlyModeCoordsText[playerid]);
        SetPlayerCamera(playerid, 1);
    }
    else if (!strcmp(option, "speed", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ibelieveicanfly speed [value]");
        }
        SetPlayerCameraSpeed(playerid, floatstr(param));
    }
    else if (!strcmp(option, "text", true))
    {
        if (!strcmp(param, "on", true))
        {
            PlayerTextDrawShow(playerid, FlyModeCoordsText[playerid]);
        }
        else if (!strcmp(param, "off", true))
        {
            PlayerTextDrawHide(playerid, FlyModeCoordsText[playerid]);
        }
        else
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ibelieveicanfly text [on | off]");
        }

    }
    return 1;
}
