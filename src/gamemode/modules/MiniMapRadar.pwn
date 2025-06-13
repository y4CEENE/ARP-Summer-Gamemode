/// @file      MiniMapRadar.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-04-10 19:30:56 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>


hook OnGameModeInit(playerid)
{
    LimitPlayerMarkerRadius(50000.0);
    return 1;
}
CMD:radar(playerid, params[])
{
    if (PlayerData[playerid][pGang]==-1 && PlayerData[playerid][pFaction]== -1)
    {
        return SendUnauthorized(playerid);
    }
    PlayerData[playerid][pRadar] = (PlayerData[playerid][pRadar])?0:1;

    if (PlayerData[playerid][pRadar])
    {
        SendClientMessage(playerid, COLOR_GREY, "* Radar turned on");
    }
    else SendClientMessage(playerid, COLOR_GREY, "* Radar turned off");
    return 1;
}

hook OnTwoPlayersHeartBeat(playerid, targetid)
{
    new color = 0xFFFFFF00;
    new display_on_minimap = false;


    if (PlayerData[targetid][pFindPlayer] == playerid)
    {
        color = 0xF70000FF;
        display_on_minimap = true;
    }
    else if (IsHunted(playerid))
    {
        color = 0xFF69B5FF;
        display_on_minimap = true;
    }
    else if (IsPlayerInEvent(playerid))
    {
        color = GetPlayerEventColor(playerid);
        display_on_minimap = true;
    }
    else if (PlayerData[playerid][pPaintball] == 2)
    {
        color = (PlayerData[playerid][pPaintballTeam] == 1) ? (0x33CCFF00) : (0xFFFF9900);
        display_on_minimap = true;
    }
    else if (PlayerData[playerid][pJailType] == JailType_OOCPrison)
    {
        color = 0xAD7A2100;
        display_on_minimap = false;
    }
    else if (GetWantedLevel(playerid) == 6)
    {
        color = 0xFF000000;
        display_on_minimap = true;
    }
    else if (PlayerHasJob(playerid, JOB_TAXIDRIVER) && IsTaxiDriverOnDuty(playerid))
    {
        color = 0xF5DEB300;
        display_on_minimap = true;
    }
    else if (PlayerData[playerid][pDonator] > 0 && PlayerData[playerid][pVIPColor])
    {
        color = 0xFF00FF00;
        display_on_minimap = false;
    }

    #if defined zombiemode
        else if (GetPVarType(playerid, "pZombieBit"))
        {
            color = 0xFFCC0000;
            display_on_minimap = false;
        }
        else if (GetPVarType(playerid, "pIsZombie"))
        {
            color = 0x0BC43600;
            display_on_minimap = false;
        }
        else if (GetPVarType(playerid, "pEventZombie"))
        {
            color = 0x0BC43600;
            display_on_minimap = false;
        }
    #endif
    else if (IsPlayerNPC(playerid))
    {
        color = 0x00AA00AA;
        display_on_minimap = false;
    }
    else if (IsACop(playerid) && IsACop(targetid) && PlayerData[playerid][pBackup])
    {
        color = GetFactionColor(PlayerData[playerid][pFaction], true);
        display_on_minimap = true;
    }
    else
    {
        if (PlayerData[playerid][pGang] != -1)
        {
            if (PlayerData[playerid][pBackup] || PlayerData[playerid][pBandana])
            {
                color =  GangInfo[PlayerData[playerid][pGang]][gColor];
            }
        }
        if (PlayerData[playerid][pFaction] != -1)
        {
            if (PlayerData[playerid][pBackup] || PlayerData[playerid][pDuty])
            {
                color = GetFactionColor(PlayerData[playerid][pFaction], true);
            }
        }

        if (color != 0xFFFFFF00)
        {
            new target_in_team = (PlayerData[targetid][pGang]>=0 || IsACop(targetid));
            new player_in_team = (PlayerData[playerid][pGang]>=0 || IsACop(playerid));

            new in_same_team =  (PlayerData[playerid][pFaction] == PlayerData[targetid][pFaction] && PlayerData[playerid][pFaction] != -1) ||
                                (PlayerData[playerid][pGang] == PlayerData[targetid][pGang] && PlayerData[playerid][pGang] != -1);

            if (in_same_team && (PlayerData[playerid][pBackup] || PlayerData[targetid][pRadar]))
            {
                display_on_minimap = true;
            }
            else if (target_in_team && player_in_team && IsInSameActiveTurf(playerid, targetid))
            {
                display_on_minimap = true;
            }

        }
    }



    if (display_on_minimap && (GetPlayerInterior(targetid) == GetPlayerInterior(playerid)) && (GetPlayerVirtualWorld(targetid) == GetPlayerVirtualWorld(playerid)))
    {
        SetPlayerMarkerForPlayer(targetid, playerid, (color & ~0xFF) + 0xFF);
    }
    else
    {
        SetPlayerMarkerForPlayer(targetid, playerid, (color & ~0xFF));
    }

    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (PlayerData[playerid][pFindTime] > 0)
    {
        PlayerData[playerid][pFindTime]--;

        if (PlayerData[playerid][pFindTime] == 0)
        {
            PlayerData[playerid][pFindPlayer] = INVALID_PLAYER_ID;
        }
    }

    return 1;
}
