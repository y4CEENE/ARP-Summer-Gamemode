/// @file      AdminChat.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:a(playerid, params[])
{
    if (!IsAdmin(playerid) && !PlayerData[playerid][pDeveloper] && !IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /a [admin chat]");
    }
    if (PlayerData[playerid][pToggleAdmin])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the admin chat as you have it toggled.");
    }
    params[0] = toupper(params[0]);

    foreach(new i : Player)
    {
        if (!PlayerData[i][pLogged])
        {
            continue;
        }
        if ((IsAdmin(i) || PlayerData[i][pDeveloper] || IsGodAdmin(i)) && !PlayerData[i][pToggleAdmin])
        {
            SendClientSplitMessageEx(i, COLOR_YELLOW, "* [%s %s{FFFF00}] %s: %s *",
                GetAdminDivision(playerid), GetAdminRank1(playerid), GetAdminName(playerid), params);
        }
    }
    return 1;
}

CMD:fa(playerid, params[])
{
    if (!IsAdmin(playerid) && !PlayerData[playerid][pFormerAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fa [Former Admin chat]");
    }
    if (PlayerData[playerid][pToggleAdmin])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the Former Admin chat as you have it toggled.");
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pLogged])
        {
            continue;
        }
        if ((IsAdmin(i) || PlayerData[i][pFormerAdmin]) && !PlayerData[i][pToggleAdmin])
        {
            SendClientSplitMessageEx(i, COLOR_RETIRED, "* [%s{FFFF00}] %s: %s *",
                GetAdminRank1(playerid), GetAdminName(playerid), params);
        }
    }
    return 1;
}

CMD:ha(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ha [head admin chat]");
    }
    if (PlayerData[playerid][pToggleAdmin])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the head administrator chat as you have admin chats toggled.");
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pLogged])
        {
            continue;
        }
        if ((IsAdmin(i, ADMIN_LVL_5)) && !PlayerData[i][pToggleAdmin])
        {
            SendClientSplitMessageEx(i, 0x5C80FFFF, "* [%s] %s: %s *",
                GetAdminRank(playerid), GetRPName(playerid), params);
        }
    }

    return 1;
}

CMD:e(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_8))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /e [Management chat]");
    }
    if (PlayerData[playerid][pToggleAdmin])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the executive chat as you have admin chats toggled.");
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pLogged])
        {
            continue;
        }
        if ((IsAdmin(i, ADMIN_LVL_6)) && !PlayerData[i][pToggleAdmin])
        {
            SendClientSplitMessageEx(i, 0xA077BFFF, "* [%s] %s: %s *",
                GetAdminRank(playerid), GetRPName(playerid), params);
        }
    }

    return 1;
}

CMD:ap(playerid, params[])
{
    if (PlayerData[playerid][pAdminPersonnel] || IsAdmin(playerid, ADMIN_LVL_10))
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            format(str, sizeof(str), "* [AP]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
            SendAPMessage(COLOR_AQUA, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(a)dmin(p)ersonnel [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}

CMD:dga(playerid, params[])
{
    if (PlayerData[playerid][pGameAffairs] >= 1 || IsAdmin(playerid, ADMIN_LVL_9))
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            format(str, sizeof(str), "* [DGA]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
            SendDGAMessage(COLOR_GLOBAL, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /dga [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}

CMD:wd(playerid, params[])
{
    if (PlayerData[playerid][pWebDev] >= 1 || IsAdmin(playerid, ADMIN_LVL_9))
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            format(str, sizeof(str), "* [WD]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
            SendWDMessage(COLOR_GLOBAL, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /dga [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}

CMD:fm(playerid, params[])
{
    if (PlayerData[playerid][pFactionMod] || PlayerData[playerid][pGameAffairs] || IsAdmin(playerid, ADMIN_LVL_9))
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            format(str, sizeof(str), "* [FM]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
            SendFMMessage(COLOR_BLUE, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(f)action(m)managment [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}
CMD:gm(playerid, params[])
{
    if (PlayerData[playerid][pGangMod] || PlayerData[playerid][pGameAffairs] || IsAdmin(playerid, ADMIN_LVL_9))
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            format(str, sizeof(str), "* [GM]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
            SendGMMessage(COLOR_GREEN, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(g)ang (m)managment [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}
CMD:hmc(playerid, params[])
{
    if (PlayerData[playerid][pHelperManager] || PlayerData[playerid][pGameAffairs] || IsAdmin(playerid, ADMIN_LVL_9))
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            format(str, sizeof(str), "* [HM]{FFFFFF} %s: %s *", GetRPName(playerid), msg);
            SendHMMessage(COLOR_AQUA, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(h)elper (m)managment [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}
