/// @file      NewbieChat.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:n(playerid, params[])
{
    return callcmd::newbie(playerid, params);
}

CMD:newb(playerid, params[])
{
    return callcmd::newbie(playerid, params);
}

CMD:newbie(playerid, params[])
{

    if (!enabledNewbie && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The newbie channel is disabled at the moment.");
    }
    if (IsNewbieMuted(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are muted from speaking in this channel. /unmute to unmute yourself.");
    }
    if (gettime() - PlayerData[playerid][pLastNewbie] < 30)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only speak in this channel every 30 seconds. Please wait %i more seconds.", 30 - (gettime() - PlayerData[playerid][pLastNewbie]));
    }
    if (PlayerData[playerid][pToggleNewbie])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the newbie chat as you have it toggled.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /newb [question/answer]");
    }
    SendNewbieChatMessage(playerid, FilterChat(params));
    PlayerData[playerid][pNewbies] ++;
    DBQuery("UPDATE "#TABLE_USERS" SET newbies = %i WHERE uid = %i", PlayerData[playerid][pNewbies], PlayerData[playerid][pID]);
    return 1;
}

SendNewbieChatMessage(playerid, text[])
{
    new string[64];
    if ((!isnull(PlayerData[playerid][pCustomTitle]) && strcmp(PlayerData[playerid][pCustomTitle], "None", true) != 0 && strcmp(PlayerData[playerid][pCustomTitle], "NULL", true) != 0) && PlayerData[playerid][pAdminHide] == 0)
    {
        new color;
        if (PlayerData[playerid][pCustomTColor] == -1 || PlayerData[playerid][pCustomTColor] == -256)
        {
            color = 0xC8C8C8FF;
        }
        else
        {
            color = PlayerData[playerid][pCustomTColor];
        }
        format(string, sizeof(string), "{%06x}%s{7DAEFF} %s", color >>> 8, PlayerData[playerid][pCustomTitle], GetRPName(playerid));
    }
    else if (IsAdmin(playerid, ADMIN_LVL_2) && PlayerData[playerid][pAdminHide] == 0)
    {
        format(string, sizeof(string), "{FF6347}%s{7DAEFF} %s", GetAdminRank(playerid), GetRPName(playerid));
    }
    else if (PlayerData[playerid][pHelper] > 0)
    {
        format(string, sizeof(string), "%s %s", GetHelperRank(playerid), GetRPName(playerid));
    }
    else if (PlayerData[playerid][pFormerAdmin])
    {
        format(string, sizeof(string), "{FF69B5}Former Admin{7DAEFF} %s", GetRPName(playerid));
    }
    else if (PlayerData[playerid][pDonator] > 0)
    {
        format(string, sizeof(string), "{D909D9}%s VIP{7DAEFF} %s", GetVIPRank(PlayerData[playerid][pDonator]), GetRPName(playerid));
    }
    else if (PlayerData[playerid][pLevel] > 1)
    {
        format(string, sizeof(string), "Player %s", GetRPName(playerid));
    }
    else if (PlayerData[playerid][pHours] > 250)
    {
        format(string, sizeof(string), SERVER_SHORT_NAME " Veteran: %s", GetRPName(playerid));
    }
    else
    {
        format(string, sizeof(string), "Newbie %s", GetRPName(playerid));
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pToggleNewbie] && PlayerData[i][pLogged])
        {
            if (strlen(text) > MAX_SPLIT_LENGTH)
            {
                SendClientMessageEx(i, COLOR_NEWBIE, "* %s: %.*s...", string, MAX_SPLIT_LENGTH, text);
                SendClientMessageEx(i, COLOR_NEWBIE, "* %s: ...%s", string, text[MAX_SPLIT_LENGTH]);
            }
            else
            {
                SendClientMessageEx(i, COLOR_NEWBIE, "* %s: %s", string, text);
            }
        }
    }

    if (!IsAdmin(playerid, ADMIN_LVL_3) && PlayerData[playerid][pHelper] == 0)
    {
        PlayerData[playerid][pLastNewbie] = gettime();
    }
}
