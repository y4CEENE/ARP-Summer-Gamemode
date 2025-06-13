/// @file      AllianceChat.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

CMD:ally(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ally [Alliance chat]");
    }
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
    }
    if (GangInfo[gangid][gAlliance] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your gang isn't a part of an alliance.");
    }
    if (PlayerData[playerid][pToggleGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the alliance chat as you have gang chat toggled.");
    }
    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot speak in /ally while dead.");
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
        if ((PlayerData[i][pGang] == PlayerData[playerid][pGang] || PlayerData[i][pGang] == GangInfo[gangid][gAlliance])  && !PlayerData[i][pToggleGang])
        {
            if (strlen(params) > MAX_SPLIT_LENGTH)
            {
                SendClientMessageEx(i, COLOR_GREEN, "* [Alliance] %s %s: %.*s... *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
                SendClientMessageEx(i, COLOR_GREEN, "* [Alliance] %s %s: ...%s *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
            }
            else
            {
                SendClientMessageEx(i, COLOR_GREEN, "* [Alliance] %s %s: %s *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), params);
            }
        }
    }

    return 1;
}
