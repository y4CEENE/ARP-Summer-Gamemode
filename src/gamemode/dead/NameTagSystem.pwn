/// @file      NameTagSystem.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-04-15 14:13:01 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>
//TODO: UNUSED

#define MINIMAP_DISPLAY_NONE 0
#define MINIMAP_DISPLAY_TAB  1
#define MINIMAP_DISPLAY_TEAM 2
#define MINIMAP_DISPLAY_NEAR 3
#define MINIMAP_DISPLAY_ALL  4

#define MINIMAP_BLINKING_DISABLED 0
#define MINIMAP_BLINKING_ENABLED  1
#define MINIMAP_BLINKING_VISIBLE  2
#define MINIMAP_BLINKING_HIDDEN   3

#define MINIMAP_DEFAULT_COLOR 0xFFFFFF00
#define MINIMAP_NEAR_MAX_DISTANCE 250.0

static PlayerColor[MAX_PLAYERS];
static MiniMapDisplayType[MAX_PLAYERS];
static BlinkingState[MAX_PLAYERS];


#define INVALID_COLOR 0

hook OnGameModeInit()
{
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
}

hook OnPlayerInit(playerid)
{
    defer SetupPlayerOnMiniMap(playerid);
}

timer SetupPlayerOnMiniMap[500](playerid)
{
    SetPlayerTeam(playerid, NO_TEAM);
    HidePlayerOnMiniMap(playerid);
}

HidePlayerOnMiniMap(playerid)
{
    BlinkingState[playerid] = MINIMAP_BLINKING_DISABLED;
    MiniMapDisplayType[playerid] = MINIMAP_DISPLAY_NONE;
    PlayerColor[playerid] = MINIMAP_DEFAULT_COLOR;
    SetPlayerColor(playerid, PlayerColor[playerid]);
}

EnableBlinkingOnMiniMap(playerid)
{
    BlinkingState[playerid] = MINIMAP_BLINKING_ENABLED;
}

DisableBlinkingOnMiniMap(playerid)
{
    BlinkingState[playerid] = MINIMAP_BLINKING_DISABLED;
}


MarkPlayerOnMiniMapForAll(playerid, color)
{
    PlayerColor[playerid] = color;
    BlinkingState[playerid] = MINIMAP_BLINKING_DISABLED;
    SetPlayerColor(playerid, (PlayerColor[playerid] & ~0xFF) + 0xFF);
    MiniMapDisplayType[playerid] = MINIMAP_DISPLAY_ALL;
}

MarkPlayerOnTab(playerid, color)
{
    PlayerColor[playerid] = color;
    BlinkingState[playerid] = MINIMAP_BLINKING_DISABLED;
    MiniMapDisplayType[playerid] = MINIMAP_DISPLAY_TAB;
    SetPlayerColor(playerid, PlayerColor[playerid] & ~0xFF);
    foreach(new id : Player)
    {
        SetPlayerMarkerForPlayer(id, playerid, PlayerColor[playerid] & ~0xFF);
    }
}

MarkPlayerOnMiniMapForNearest(playerid, color)
{
    PlayerColor[playerid] = color;
    BlinkingState[playerid] = MINIMAP_BLINKING_DISABLED;
    MiniMapDisplayType[playerid] = MINIMAP_DISPLAY_NEAR;
    SetPlayerColor(playerid, MINIMAP_DEFAULT_COLOR);

    foreach(new id : Player)
    {
        if (GetDistanceBetweenPlayers(id, playerid) < MINIMAP_NEAR_MAX_DISTANCE)
        {
            SetPlayerMarkerForPlayer(id, playerid, (PlayerColor[playerid] & ~0xFF) + 0xFF);
        }
        else
        {
            SetPlayerMarkerForPlayer(id, playerid, (PlayerColor[playerid] & ~0xFF));
        }
    }
}

MarkPlayerOnMiniMapForTeam(playerid, color)
{
    PlayerColor[playerid] = color;
    BlinkingState[playerid] = MINIMAP_BLINKING_DISABLED;
    MiniMapDisplayType[playerid] = MINIMAP_DISPLAY_TEAM;

    SetPlayerColor(playerid, MINIMAP_DEFAULT_COLOR);

    foreach(new id : Player)
    {
        if (PlayerData[id][pLogged]  && (InSameTeam(playerid, id) || GetDistanceBetweenPlayers(id, playerid) < MINIMAP_NEAR_MAX_DISTANCE))
        {
            SetPlayerMarkerForPlayer(id, playerid, (PlayerColor[playerid] & ~0xFF) + 0xFF);
        }
        else
        {
            SetPlayerMarkerForPlayer(id, playerid, MINIMAP_DEFAULT_COLOR);
        }
    }

}

CMD:minimap(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return 0;
    }
    if (!isnull(params))
    {
        if (strcmp("hide", params, true) == 0)
        {
            HidePlayerOnMiniMap(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "hide");
        }
        else if (strcmp("near", params, true) == 0)
        {
            MarkPlayerOnMiniMapForNearest(playerid, 0xFF0000FF);
            return SendClientMessage(playerid, COLOR_GREY, "near");
        }
        else if (strcmp("tab", params, true) == 0)
        {
            MarkPlayerOnTab(playerid, 0xFF0000FF);
            return SendClientMessage(playerid, COLOR_GREY, "tab");
        }
        else if (strcmp("team", params, true) == 0)
        {
            MarkPlayerOnMiniMapForTeam(playerid, 0x00FF00FF);
            return SendClientMessage(playerid, COLOR_GREY, "team");
        }
        else if (strcmp("all", params, true) == 0)
        {
            MarkPlayerOnMiniMapForAll(playerid, 0x0000FFFF);
            return SendClientMessage(playerid, COLOR_GREY, "all");
        }
        else if (strcmp("blink", params, true) == 0)
        {
            EnableBlinkingOnMiniMap(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "blink");
        }
        else if (strcmp("noblink", params, true) == 0)
        {
            DisableBlinkingOnMiniMap(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "noblink");
        }
    }
    return SendClientMessage(playerid, COLOR_GREY, "USAGE: /minimap [hide/tab/near/team/all]");
}



task SyncNameTagColors[1000]()
{
    foreach(new playerid : Player)
    {
        if (!PlayerData[playerid][pLogged])
        {
            continue;
        }

        if (BlinkingState[playerid] != MINIMAP_BLINKING_DISABLED)
        {
            if (BlinkingState[playerid] == MINIMAP_BLINKING_VISIBLE || BlinkingState[playerid] == MINIMAP_BLINKING_ENABLED)
            {
                BlinkingState[playerid] = MINIMAP_BLINKING_HIDDEN;
            }
            else
            {
                BlinkingState[playerid] = MINIMAP_BLINKING_VISIBLE;
            }
        }

        foreach(new targetid : Player)
        {
            if (PlayerData[targetid][pLogged])
            {
                if (MiniMapDisplayType[targetid] == MINIMAP_DISPLAY_TEAM)
                {
                    if (InSameTeam(playerid, targetid) || GetDistanceBetweenPlayers(playerid, targetid) < MINIMAP_NEAR_MAX_DISTANCE)
                    {
                        if (BlinkingState[targetid] == MINIMAP_BLINKING_HIDDEN)
                        {
                            SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[targetid] & ~0xFF));
                        }
                        else
                        {
                            SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[targetid] & ~0xFF) + 0xFF);
                        }
                    }
                    else
                    {
                        SetPlayerMarkerForPlayer(playerid, targetid, MINIMAP_DEFAULT_COLOR);
                    }
                }
                else if (MiniMapDisplayType[targetid] == MINIMAP_DISPLAY_TAB)
                {
                    SetPlayerMarkerForPlayer(playerid, targetid, PlayerColor[targetid] & ~0xFF);
                }
                else if (MiniMapDisplayType[targetid] == MINIMAP_DISPLAY_ALL)
                {
                    if (BlinkingState[targetid] == MINIMAP_BLINKING_HIDDEN)
                    {
                        SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[targetid] & ~0xFF));
                    }
                    else
                    {
                        SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[targetid] & ~0xFF) + 0xFF);
                    }
                }
                else if (MiniMapDisplayType[targetid] == MINIMAP_DISPLAY_NEAR)
                {
                    if (GetDistanceBetweenPlayers(playerid, targetid) < MINIMAP_NEAR_MAX_DISTANCE)
                    {
                        if (BlinkingState[targetid] == MINIMAP_BLINKING_HIDDEN)
                        {
                            SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[targetid] & ~0xFF));
                        }
                        else
                        {
                            SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[targetid] & ~0xFF) + 0xFF);
                        }
                    }
                    else
                    {
                        SetPlayerMarkerForPlayer(playerid, targetid, (PlayerColor[playerid] & ~0xFF));
                    }
                }
                else
                {
                    //NONE
                    SetPlayerMarkerForPlayer(playerid, targetid, MINIMAP_DEFAULT_COLOR);
                }

            }
            else
            {
                SetPlayerMarkerForPlayer(playerid, targetid, MINIMAP_DEFAULT_COLOR);
            }
        }
    }
}
