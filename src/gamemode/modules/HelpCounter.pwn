/// @file      HelpCounter.pwn
/// @author    Khalil
/// @date      Created at 2024-05-07
/// @copyright Copyright (c) 2024

#include <YSI\y_hooks>

static Text:HelpsTD[2];
static bool:IsHelpCounterVisible[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    IsHelpCounterVisible[playerid] = false;
}

hook OnLoadGameMode(timestamp)
{
    // Helps Textdraw
    HelpsTD[0] = TextDrawCreate(494.000000, 313.000000, "ld_chat:badchat");
    TextDrawFont(HelpsTD[0], 4);
    TextDrawLetterSize(HelpsTD[0], 0.600000, 2.000000);
    TextDrawTextSize(HelpsTD[0], -15.500000, 17.000000);
    TextDrawSetOutline(HelpsTD[0], 1);
    TextDrawSetShadow(HelpsTD[0], 0);
    TextDrawAlignment(HelpsTD[0], 1);
    TextDrawColor(HelpsTD[0], -1);
    TextDrawBackgroundColor(HelpsTD[0], 255);
    TextDrawBoxColor(HelpsTD[0], 50);
    TextDrawUseBox(HelpsTD[0], 1);
    TextDrawSetProportional(HelpsTD[0], 1);
    TextDrawSetSelectable(HelpsTD[0], 0);

    HelpsTD[1] = TextDrawCreate(500.000000, 320.000000, "0_Helps");
    TextDrawFont(HelpsTD[1], 2);
    TextDrawLetterSize(HelpsTD[1], 0.408333, 1.750000);
    TextDrawTextSize(HelpsTD[1], 503.000000, 17.000000);
    TextDrawSetOutline(HelpsTD[1], 1);
    TextDrawSetShadow(HelpsTD[1], 0);
    TextDrawAlignment(HelpsTD[1], 1);
    TextDrawColor(HelpsTD[1], 16711805);
    TextDrawBackgroundColor(HelpsTD[1], 255);
    TextDrawBoxColor(HelpsTD[1], 50);
    TextDrawUseBox(HelpsTD[1], 0);
    TextDrawSetProportional(HelpsTD[1], 1);
    TextDrawSetSelectable(HelpsTD[1], 0);
}

hook OnPlayerSpawn(playerid)
{
   if (PlayerData[playerid][pHelper] > 0)
    {
        TextDrawShowForPlayer(playerid, HelpsTD[0]);
        TextDrawShowForPlayer(playerid, HelpsTD[1]);
        IsHelpCounterVisible[playerid] = true;
    }
    else
    {
        TextDrawHideForPlayer(playerid, HelpsTD[0]);
        TextDrawHideForPlayer(playerid, HelpsTD[1]);
    }
}

hook OnServerHeartBeat(timestamp)
{
    new counter = 0;
    foreach (new i : Player)
    {
        if (!isnull(PlayerData[i][pHelpRequest]))
        {
            counter++;
        }
    }

    new helpstds[128];
    format(helpstds, sizeof(helpstds), "%i_Helps", counter);
    TextDrawSetString(HelpsTD[1], helpstds);
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (IsHelpCounterVisible[playerid] && PlayerData[playerid][pHelper] == 0)
    {
        TextDrawHideForPlayer(playerid, HelpsTD[0]);
        TextDrawHideForPlayer(playerid, HelpsTD[1]);
        IsHelpCounterVisible[playerid] = false;
    }
}
