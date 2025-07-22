/// @file      General.Chat.pwn
/// @author    Khalil
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:g(playerid, params[])
{
    new title[80];

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /g [global chat]");
    }
    if (!enabledGlobal && !IsAdmin(playerid, JUNIOR_ADMIN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The global channel is disabled at the moment.");
    }
    if(PlayerData[playerid][pGlobalMuted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are muted from speaking in this channel. /unmute to unmute yourself.");
	}
    if (PlayerData[playerid][pToggleGlobal])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the global chat as you have it toggled.");
    }
    if (gettime() - PlayerData[playerid][pLastGlobal] < 3)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only speak in this channel every 3 seconds. Please wait %i more seconds.", 3 - (gettime() - PlayerData[playerid][pLastGlobal]));
    }
    new text[256];
    text = FilterChat(params);
    text[0] = toupper(text[0]);

    if ((!isnull(PlayerData[playerid][pCustomTitle]) && strcmp(PlayerData[playerid][pCustomTitle], "None", true) != 0) && PlayerData[playerid][pAdminHide] == 0)
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
        format(title, sizeof(title), "{%06x}%s{FFA500}", color >>> 8, PlayerData[playerid][pCustomTitle]);
    }
	else if(PlayerData[playerid][pAdmin] > 1 && PlayerData[playerid][pAdminHide] == 0) 
	{
	  format(title, sizeof(title), "%s", GetAdminRank(playerid));
	}
    else if (PlayerData[playerid][pHelper] > 0)
    {
       format(title, sizeof(title), "{33CCFF}%s{FFA500}", GetHelperRank(playerid));
    }
    else if (PlayerData[playerid][pFormerAdmin])
    {
        title = "{FF69B5}Former Admin{FFA500}";
    }
    else if (PlayerData[playerid][pDonator] > 0)
    {
        format(title, sizeof(title), "{D909D9}%s VIP{FFA500}", GetVIPRank(PlayerData[playerid][pDonator]));
    }
    else if (PlayerData[playerid][pLevel] >= 3)
    {
        format(title, sizeof(title), "Level %i", PlayerData[playerid][pLevel]);
    }
    else
    {
           title = "Newbie";
    }

    format(title, sizeof(title), "[%s] %s", ((IsMobile(playerid)) ? ("AD") : ("PC")), title);

    foreach(new i : Player)
    {
        if (!PlayerData[i][pToggleGlobal] && PlayerData[i][pLogged])
        {
            if (strlen(text) > MAX_SPLIT_LENGTH)
            {
                SendClientMessageEx(i, COLOR_GLOBAL, "(( {FFFFFF}%s %s{98FB98}: %.*s...))", title, GetRPName(playerid), MAX_SPLIT_LENGTH, text);
                SendClientMessageEx(i, COLOR_GLOBAL, "(( {FFFFFF}%s %s{98FB98}: ...%s ))", title, GetRPName(playerid), text[MAX_SPLIT_LENGTH]);
            }
            else
            {
                SendClientMessageEx(i, COLOR_GLOBAL, "(( {FFFFFF}%s %s{98FB98}: %s ))", title, GetRPName(playerid), text);
            }
        }
    }

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
 	{
 		PlayerData[playerid][pLastGlobal] = gettime();
 	}
    return 1;
}
