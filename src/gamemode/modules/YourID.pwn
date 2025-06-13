/// @file      YourID.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 13:59:08 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>


static Text:YourID;
static PlayerText:YourIDValue[MAX_PLAYERS];

hook OnGameModeInit()
{
    YourID = TextDrawCreate   (312.400268, 1.500000, "Id");
    TextDrawLetterSize        (YourID, 0.330112, 1.783867);
    TextDrawTextSize          (YourID, 136.000000, -0.029999);
    TextDrawAlignment         (YourID, 1);
    TextDrawColor             (YourID, -5963521);
    TextDrawSetShadow         (YourID, 0);
    TextDrawSetOutline        (YourID, 1);
    TextDrawBackgroundColor   (YourID, 255);
    TextDrawFont              (YourID, 2);
    TextDrawSetProportional   (YourID, 1);
}

hook OnPlayerInit(playerid)
{
    new temp[5];
    format(temp,5,"%i",playerid);
    YourIDValue[playerid] = CreatePlayerTextDraw(playerid, 331.800048, 3.899999, temp);
    PlayerTextDrawLetterSize      (playerid, YourIDValue[playerid], 0.392666, 1.380932);
    PlayerTextDrawTextSize        (playerid, YourIDValue[playerid], -4.000000, 0.000000);
    PlayerTextDrawAlignment       (playerid, YourIDValue[playerid], 1);
    PlayerTextDrawColor           (playerid, YourIDValue[playerid], -2139062017);
    PlayerTextDrawSetShadow       (playerid, YourIDValue[playerid], 0);
    PlayerTextDrawSetOutline      (playerid, YourIDValue[playerid], 1);
    PlayerTextDrawBackgroundColor (playerid, YourIDValue[playerid], 255);
    PlayerTextDrawFont            (playerid, YourIDValue[playerid], 3);
    PlayerTextDrawSetProportional (playerid, YourIDValue[playerid], 1);

    TextDrawShowForPlayer(playerid, YourID);
    PlayerTextDrawShow(playerid, YourIDValue[playerid]);
}
