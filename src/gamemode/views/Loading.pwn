#include <YSI\y_hooks>

static PlayerText:LoadingObjects0[MAX_PLAYERS];
static PlayerText:LoadingObjects1[MAX_PLAYERS];
static PlayerText:LoadingObjects2[MAX_PLAYERS];
static PlayerText:LoadingObjects3[MAX_PLAYERS];
static PlayerText:LoadingObjects4[MAX_PLAYERS];
static PlayerText:LoadingObjects5[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    LoadingObjects0[playerid] = CreatePlayerTextDraw(playerid, 219.267944, 377.416687, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, LoadingObjects0[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, LoadingObjects0[playerid], 205.212310, 58.333312);
    PlayerTextDrawAlignment(playerid, LoadingObjects0[playerid], 1);
    PlayerTextDrawColor(playerid, LoadingObjects0[playerid], -2139062017);
    PlayerTextDrawSetShadow(playerid, LoadingObjects0[playerid], 0);
    PlayerTextDrawSetOutline(playerid, LoadingObjects0[playerid], 0);
    PlayerTextDrawFont(playerid, LoadingObjects0[playerid], 4);

    LoadingObjects1[playerid] = CreatePlayerTextDraw(playerid, 424.011718, 382.666687, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, LoadingObjects1[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, LoadingObjects1[playerid], -204.743774, -5.250000);
    PlayerTextDrawAlignment(playerid, LoadingObjects1[playerid], 1);
    PlayerTextDrawColor(playerid, LoadingObjects1[playerid], -1);
    PlayerTextDrawSetShadow(playerid, LoadingObjects1[playerid], 0);
    PlayerTextDrawSetOutline(playerid, LoadingObjects1[playerid], 0);
    PlayerTextDrawFont(playerid, LoadingObjects1[playerid], 4);

    LoadingObjects2[playerid] = CreatePlayerTextDraw(playerid, 424.011718, 378.000000, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, LoadingObjects2[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, LoadingObjects2[playerid], -4.216674, 57.750000);
    PlayerTextDrawAlignment(playerid, LoadingObjects2[playerid], 1);
    PlayerTextDrawColor(playerid, LoadingObjects2[playerid], -1);
    PlayerTextDrawSetShadow(playerid, LoadingObjects2[playerid], 0);
    PlayerTextDrawSetOutline(playerid, LoadingObjects2[playerid], 0);
    PlayerTextDrawFont(playerid, LoadingObjects2[playerid], 4);

    LoadingObjects3[playerid] = CreatePlayerTextDraw(playerid, 218.799423, 377.416687, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, LoadingObjects3[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, LoadingObjects3[playerid], 4.685211, 58.333312);
    PlayerTextDrawAlignment(playerid, LoadingObjects3[playerid], 1);
    PlayerTextDrawColor(playerid, LoadingObjects3[playerid], -1);
    PlayerTextDrawSetShadow(playerid, LoadingObjects3[playerid], 0);
    PlayerTextDrawSetOutline(playerid, LoadingObjects3[playerid], 0);
    PlayerTextDrawFont(playerid, LoadingObjects3[playerid], 4);

    LoadingObjects4[playerid] = CreatePlayerTextDraw(playerid, 424.011718, 429.333312, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, LoadingObjects4[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, LoadingObjects4[playerid], -204.275253, 6.416687);
    PlayerTextDrawAlignment(playerid, LoadingObjects4[playerid], 1);
    PlayerTextDrawColor(playerid, LoadingObjects4[playerid], -1);
    PlayerTextDrawSetShadow(playerid, LoadingObjects4[playerid], 0);
    PlayerTextDrawSetOutline(playerid, LoadingObjects4[playerid], 0);
    PlayerTextDrawFont(playerid, LoadingObjects4[playerid], 4);

    LoadingObjects5[playerid] = CreatePlayerTextDraw(playerid, 230.043624, 398.416717, "Loading Objects...");
    PlayerTextDrawLetterSize(playerid, LoadingObjects5[playerid], 0.449999, 1.600000);
    PlayerTextDrawAlignment(playerid, LoadingObjects5[playerid], 1);
    PlayerTextDrawColor(playerid, LoadingObjects5[playerid], 255);
    PlayerTextDrawSetShadow(playerid, LoadingObjects5[playerid], 0);
    PlayerTextDrawSetOutline(playerid, LoadingObjects5[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, LoadingObjects5[playerid], 51);
    PlayerTextDrawFont(playerid, LoadingObjects5[playerid], 2);
    PlayerTextDrawSetProportional(playerid, LoadingObjects5[playerid], 1);
    return 1;
}

hook OnPlayerInit(playerid)
{
    HideFreezeTextdraw(playerid);
    return 1;
}

ShowFreezeTextdraw(playerid)
{
    PlayerTextDrawShow(playerid, LoadingObjects0[playerid]);
    PlayerTextDrawShow(playerid, LoadingObjects1[playerid]);
    PlayerTextDrawShow(playerid, LoadingObjects2[playerid]);
    PlayerTextDrawShow(playerid, LoadingObjects3[playerid]);
    PlayerTextDrawShow(playerid, LoadingObjects4[playerid]);
    PlayerTextDrawShow(playerid, LoadingObjects5[playerid]);

    return 1;
}

HideFreezeTextdraw(playerid)
{
    PlayerTextDrawHide(playerid, LoadingObjects0[playerid]);
    PlayerTextDrawHide(playerid, LoadingObjects1[playerid]);
    PlayerTextDrawHide(playerid, LoadingObjects2[playerid]);
    PlayerTextDrawHide(playerid, LoadingObjects3[playerid]);
    PlayerTextDrawHide(playerid, LoadingObjects4[playerid]);
    PlayerTextDrawHide(playerid, LoadingObjects5[playerid]);
    return 1;
}

SetFreezePos(playerid, Float:x, Float:y, Float:z)
{
    if (PlayerData[playerid][pFreezeTimer] >= 0)
    {
        KillTimer(PlayerData[playerid][pFreezeTimer]);
    }

    PlayerData[playerid][pFreezeTimer] = SetTimerEx("UnfreezePlayer", 3000, false, "i", playerid);
    SetPlayerPos(playerid, x, y, z);

    TogglePlayerControllableEx(playerid, false);
    //GameTextForPlayer(playerid, "~w~Loading objects...", 3000, 3);
    ShowFreezeTextdraw(playerid);
}

publish UnfreezePlayer(playerid)
{
    TogglePlayerControllableEx(playerid, 1);
    PlayerData[playerid][pFreezeTimer] = -1;
    HideFreezeTextdraw(playerid);
}
