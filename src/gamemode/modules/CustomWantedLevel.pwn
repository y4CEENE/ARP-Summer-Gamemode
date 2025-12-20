#include <YSI\y_hooks>

// Fix for mobile
static PlayerText:WantedLevelUI[MAX_PLAYERS][2];
static LastWantedLevel[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    WantedLevelUI[playerid][0] = CreatePlayerTextDraw(playerid, 493.0000, 100.099952, "]]]]]]");
    PlayerTextDrawLetterSize(playerid, WantedLevelUI[playerid][0], 0.600000, 2.000000);
    PlayerTextDrawAlignment(playerid, WantedLevelUI[playerid][0], 1);
    PlayerTextDrawColor(playerid, WantedLevelUI[playerid][0], 255);
    PlayerTextDrawSetShadow(playerid, WantedLevelUI[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, WantedLevelUI[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, WantedLevelUI[playerid][0], 255);
    PlayerTextDrawFont(playerid, WantedLevelUI[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, WantedLevelUI[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, WantedLevelUI[playerid][0], 0);

    WantedLevelUI[playerid][1] = CreatePlayerTextDraw(playerid, 612.0, 99.700141, "]]]]");
    PlayerTextDrawLetterSize(playerid, WantedLevelUI[playerid][1], 0.600000, 2.000000);
    PlayerTextDrawAlignment(playerid, WantedLevelUI[playerid][1], 3);
    PlayerTextDrawColor(playerid, WantedLevelUI[playerid][1], -1956378113);
    PlayerTextDrawSetShadow(playerid, WantedLevelUI[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, WantedLevelUI[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, WantedLevelUI[playerid][1], 255);
    PlayerTextDrawFont(playerid, WantedLevelUI[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, WantedLevelUI[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, WantedLevelUI[playerid][1], 0);
    LastWantedLevel[playerid] = 999;
    SetPlayerWantedLevel(playerid, 0);
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    // Old version: GetPlayerWantedLevel doesn't work in samp mobile
    // if(GetPlayerWantedLevel(playerid) != PlayerData[playerid][pWantedLevel])
    // {
    //     SetPlayerWantedLevel(playerid, PlayerData[playerid][pWantedLevel]); 
    // }
    new wantedlevel = PlayerData[playerid][pWantedLevel];
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
    {
        wantedlevel = 0;
    }

    if(LastWantedLevel[playerid] != wantedlevel)
    {
        LastWantedLevel[playerid] = wantedlevel;
        if(wantedlevel == 0)
        {
    		PlayerTextDrawHide(playerid, WantedLevelUI[playerid][0]);
    		PlayerTextDrawHide(playerid, WantedLevelUI[playerid][1]);
            return 1;
        }
        
        new stars[]="]]]]]]";// Using font 0 the char ']' will be displayed as a star
        new bgstars[14],fgstars[14];
        if(wantedlevel < 0)
        {
            wantedlevel=0;
        }
        else if(wantedlevel > 6)
        {
            wantedlevel=6;
        }
        strcpy(bgstars, stars, 7 - wantedlevel);
        strcpy(fgstars, stars, 1 + wantedlevel);
        PlayerTextDrawSetString(playerid, WantedLevelUI[playerid][0], bgstars);
        PlayerTextDrawSetString(playerid, WantedLevelUI[playerid][1], fgstars);
		PlayerTextDrawShow(playerid, WantedLevelUI[playerid][0]);
		PlayerTextDrawShow(playerid, WantedLevelUI[playerid][1]);
    }
    return 1;
}