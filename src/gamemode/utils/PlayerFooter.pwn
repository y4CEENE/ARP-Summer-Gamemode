#include <YSI\y_hooks>

static PlayerText:playerfooter[MAX_PLAYERS];
static PlayerShowFooter[MAX_PLAYERS];
static PlayerFooterTimer[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    playerfooter[playerid] = CreatePlayerTextDraw(playerid, 327.333190, 432.417785, ".");
    PlayerTextDrawLetterSize(playerid, playerfooter[playerid], 0.220000, 1.276443);
    PlayerTextDrawTextSize(playerid, playerfooter[playerid], 0.000000, 831.000000);
    PlayerTextDrawAlignment(playerid, playerfooter[playerid], 2);
    PlayerTextDrawColor(playerid, playerfooter[playerid], -1);
    PlayerTextDrawUseBox(playerid, playerfooter[playerid], 1);
    PlayerTextDrawBoxColor(playerid, playerfooter[playerid], 153);
    PlayerTextDrawSetShadow(playerid, playerfooter[playerid], 0);
    PlayerTextDrawSetOutline(playerid, playerfooter[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, playerfooter[playerid], 255);
    PlayerTextDrawFont(playerid, playerfooter[playerid], 2);
    PlayerTextDrawSetProportional(playerid, playerfooter[playerid], 1);

    return 1;
}

hook OnPlayerInit(playerid)
{
    PlayerShowFooter[playerid] = 0;
    return 1;
}

ShowPlayerFooter(playerid, string[], time = 5000)
{
    if (PlayerShowFooter[playerid])
    {
        PlayerTextDrawHide(playerid, playerfooter[playerid]);
        KillTimer(PlayerFooterTimer[playerid]);
    }
    PlayerTextDrawSetString(playerid, playerfooter[playerid], string);
    PlayerTextDrawShow(playerid, playerfooter[playerid]);

    PlayerShowFooter[playerid] = true;
    PlayerFooterTimer[playerid] = SetTimerEx("HidePlayerFooter", time, false, "d", playerid);
    return 1;
}

publish HidePlayerFooter(playerid)
{

    if (!PlayerShowFooter[playerid])
        return 0;

    PlayerShowFooter[playerid] = false;
    return PlayerTextDrawHide(playerid, playerfooter[playerid]);
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (PlayerShowFooter[playerid])
        KillTimer(PlayerFooterTimer[playerid]);
    return 1;
}
