/// @file      GtaVWasted.pwn
/// @author    Namroud
/// @date      Created at 2023-09-12
/// @copyright Copyright (c) 2023

#include <YSI\y_hooks>

static Text:WastedText[7];

stock ShowGtaVWasted(playerid)
{
    StopAudioStreamForPlayer(playerid);
    PlayAudioStreamForPlayer(playerid, "http://arabicarp.com/wp-content/music/wasted.wav");
    for (new i = 0; i < sizeof(WastedText); i++)
    {
        TextDrawShowForPlayer(playerid, WastedText[i]);
    }
    return 1;
}

stock HideGtaVWasted(playerid)
{
    StopAudioStreamForPlayer(playerid);
    for (new i = 0; i < sizeof(WastedText); i++)
    {
        TextDrawHideForPlayer(playerid, WastedText[i]);
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (IsPlayerConnected(playerid) && PlayerData[playerid][pLogged])
    {
        ShowGtaVWasted(playerid);
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    HideGtaVWasted(playerid);
    return 1;
}

hook OnGameModeInit()
{
    WastedText[0] = TextDrawCreate(-31.0, 0.0, "_");
    TextDrawBackgroundColor(WastedText[0], 0x000000FF);
    TextDrawFont(WastedText[0], 1);
    TextDrawLetterSize(WastedText[0], 0.5, 55.0);
    TextDrawColor(WastedText[0], 0xFFFFFFFF);
    TextDrawSetOutline(WastedText[0], 0);
    TextDrawSetProportional(WastedText[0], true);
    TextDrawSetShadow(WastedText[0], 1);
    TextDrawUseBox(WastedText[0], true);
    TextDrawBoxColor(WastedText[0], 0x0000005A);
    TextDrawTextSize(WastedText[0], 664.0, 0.0);
    TextDrawSetSelectable(WastedText[0], 0);
    WastedText[1] = TextDrawCreate(106.0, 182.0, "_");
    TextDrawBackgroundColor(WastedText[1], 0x000000FF);
    TextDrawFont(WastedText[1], 1);
    TextDrawLetterSize(WastedText[1], 0.5, 8.4999);
    TextDrawColor(WastedText[1], 0xFFFFFFFF);
    TextDrawSetOutline(WastedText[1], 0);
    TextDrawSetProportional(WastedText[1], true);
    TextDrawSetShadow(WastedText[1], 1);
    TextDrawUseBox(WastedText[1], true);
    TextDrawBoxColor(WastedText[1], 0x00000032);
    TextDrawTextSize(WastedText[1], 553.0, 0.0);
    TextDrawSetSelectable(WastedText[1], 0);
    WastedText[2] = TextDrawCreate(1.0, 182.0, "_");
    TextDrawBackgroundColor(WastedText[2], 0x000000FF);
    TextDrawFont(WastedText[2], 1);
    TextDrawLetterSize(WastedText[2], 0.5, 8.4999);
    TextDrawColor(WastedText[2], 0xFFFFFFFF);
    TextDrawSetOutline(WastedText[2], 0);
    TextDrawSetProportional(WastedText[2], true);
    TextDrawSetShadow(WastedText[2], 1);
    TextDrawUseBox(WastedText[2], true);
    TextDrawBoxColor(WastedText[2], 0x00000028);
    TextDrawTextSize(WastedText[2], 102.0, 0.0);
    TextDrawSetSelectable(WastedText[2], 0);
    WastedText[3] = TextDrawCreate(651.0, 182.0, "_");
    TextDrawBackgroundColor(WastedText[3], 0x000000FF);
    TextDrawFont(WastedText[3], 1);
    TextDrawLetterSize(WastedText[3], 0.5, 8.4999);
    TextDrawColor(WastedText[3], 0xFFFFFFFF);
    TextDrawSetOutline(WastedText[3], 0);
    TextDrawSetProportional(WastedText[3], true);
    TextDrawSetShadow(WastedText[3], 1);
    TextDrawUseBox(WastedText[3], true);
    TextDrawBoxColor(WastedText[3], 0x00000028);
    TextDrawTextSize(WastedText[3], 553.0, 0.0);
    TextDrawSetSelectable(WastedText[3], 0);
    WastedText[4] = TextDrawCreate(651.0, -59.0, "_");
    TextDrawBackgroundColor(WastedText[4], 0x000000FF);
    TextDrawFont(WastedText[4], 1);
    TextDrawLetterSize(WastedText[4], 0.5, 8.4999);
    TextDrawColor(WastedText[4], 0xFFFFFFFF);
    TextDrawSetOutline(WastedText[4], 0);
    TextDrawSetProportional(WastedText[4], true);
    TextDrawSetShadow(WastedText[4], 1);
    TextDrawUseBox(WastedText[4], true);
    TextDrawBoxColor(WastedText[4], 0x00000028);
    TextDrawTextSize(WastedText[4], -35.0, 0.0);
    TextDrawSetSelectable(WastedText[4], 0);
    WastedText[5] = TextDrawCreate(651.0, 422.0, "_");
    TextDrawBackgroundColor(WastedText[5], 0x000000FF);
    TextDrawFont(WastedText[5], 1);
    TextDrawLetterSize(WastedText[5], 0.5, 8.4999);
    TextDrawColor(WastedText[5], 0xFFFFFFFF);
    TextDrawSetOutline(WastedText[5], 0);
    TextDrawSetProportional(WastedText[5], true);
    TextDrawSetShadow(WastedText[5], 1);
    TextDrawUseBox(WastedText[5], true);
    TextDrawBoxColor(WastedText[5], 0x00000028);
    TextDrawTextSize(WastedText[5], -35.0, 0.0);
    TextDrawSetSelectable(WastedText[5], 0);
    WastedText[6] = TextDrawCreate(255.0, 202.0, "wasted");
    TextDrawBackgroundColor(WastedText[6], 0x00000000);
    TextDrawFont(WastedText[6], 3);
    TextDrawLetterSize(WastedText[6], 1.0399, 3.2999);
    TextDrawColor(WastedText[6], 0xFF0000FF);
    TextDrawSetOutline(WastedText[6], 1);
    TextDrawSetProportional(WastedText[6], true);
    TextDrawSetSelectable(WastedText[6], 0);
    return 1;
}
