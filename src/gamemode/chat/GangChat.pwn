/// @file      GangChat.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

CMD:gc(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /f [gang chat]");
    }
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
    }
    if (PlayerData[playerid][pToggleGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the gang chat as you have it toggled.");
    }
    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot speak in /r while dead.");
    }
    if (PlayerData[playerid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
    }
    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
    }

    foreach(new i : Player)
    {
        new crew[40];
        if (PlayerData[playerid][pCrew] >= 0)
        {
            format(crew, sizeof(crew), " (%s)", GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]]);
        }
        else
        {
            crew = "";
        }
        if (PlayerData[i][pGang] == PlayerData[playerid][pGang] && !PlayerData[i][pToggleGang])
        {
            if (strlen(params) > MAX_SPLIT_LENGTH)
            {
                SendClientMessageEx(i, COLOR_AQUA, "* [%i] %s%s %s: %.*s... *", PlayerData[playerid][pGangRank], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], crew, GetRPName(playerid), MAX_SPLIT_LENGTH, params);
                SendClientMessageEx(i, COLOR_AQUA, "* [%i] %s%s %s: ...%s *", PlayerData[playerid][pGangRank], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], crew, GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
            }
            else
            {
                SendClientMessageEx(i, COLOR_AQUA, "* [%i] %s%s %s: %s *", PlayerData[playerid][pGangRank], GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], crew, GetRPName(playerid), params);
            }
        }
    }

    return 1;
}
