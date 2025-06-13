/// @file      PrivateRadioChat.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:pr(playerid, params[])
{
    if (!PlayerData[playerid][pPrivateRadio])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a private radio.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pr [private radio]");
    }
    if (!PlayerData[playerid][pChannel])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your private radio is not tuned into any channel. /setfreq to set frequency.");
    }
    if (PlayerData[playerid][pTogglePR])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in your private radio as you have it toggled.");
    }
    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use /pr while dead.");
    }
    if (PlayerData[playerid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed");
    }
    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pPrivateRadio] && PlayerData[i][pChannel] == PlayerData[playerid][pChannel] && !PlayerData[i][pTogglePR] && PlayerData[i][pLogged])
        {
            if (strlen(params) > MAX_SPLIT_LENGTH)
            {
                SendClientMessageEx(i, COLOR_PRIVATERADIO, "** Radio %i Khz ** %s: %.*s... *", PlayerData[playerid][pChannel], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
                SendClientMessageEx(i, COLOR_PRIVATERADIO, "** Radio %i Khz ** %s: ...%s *", PlayerData[playerid][pChannel], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
            }
            else
            {
                SendClientMessageEx(i, COLOR_PRIVATERADIO, "** Radio %i Khz ** %s: %s *", PlayerData[playerid][pChannel], GetRPName(playerid), params);
            }
        }
    }

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "(radio) %s", params);
    if (PlayerData[playerid][pBugged])
    {
        foreach(new i : Player)
        {
            if (GetPlayerFaction(i) == FACTION_FEDERAL)
            {
                SendClientMessageEx(i, 0x9ACD3200, "(bug) %s says [radio]: %s", GetRPName(playerid), params);
            }
        }
    }
    ShowActionBubble(playerid, "* %s speaks into their private radio.", GetRPName(playerid));
    return 1;
}
