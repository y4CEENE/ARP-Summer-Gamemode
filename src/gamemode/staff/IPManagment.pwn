#include <YSI\y_hooks>

//TODO: Get IP country (Ref. MaxMind, GeoIP)
//TODO: Ban/Unban country
//TODO: Kick player banned country (check history of this file)

CMD:ip(playerid, params[])
{
    return callcmd::getip(playerid, params);
}

CMD:getip(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getip [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, ADMIN_LVL_10) && IsAdmin(targetid, ADMIN_LVL_2))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command on another administrator");
    }
    new  ip[24];
    GetPlayerIp(targetid, ip, sizeof(ip));
    return SendClientMessageEx(playerid, COLOR_WHITE, "* %s[%i]'s IP: %s *", GetRPName(targetid), targetid, ip);
}

CMD:bancountry(playerid, params[])
{

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bancountry [country_name]");
    }
    DBQuery("INSERT INTO banned_countries VALUES(null, '%e', NOW(), '%e')", GetPlayerNameEx(playerid), params);
    SendAdminWarning(2, "%s has banned the country '%s'", GetPlayerNameEx(playerid), params);
    return 1;
}

CMD:unbancountry(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bancountry [country_name]");
    }

    DBQuery("DELETE FROM banned_countries where country = '%e'", params);

    SendAdminWarning(2, "%s has unbanned the country '%s'", params);
    return 1;
}

CMD:ogetip(playerid, params[])
{
    new name[MAX_PLAYER_NAME];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ogetip [username]");
    }

    DBFormat("SELECT username, ip, adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", name);
    DBExecute("OnOfflineGetIP", "i", playerid);


    return 1;
}

CMD:iplookup(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAnIP(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /iplookup [ip address]");
    }

    DBFormat("SELECT username, lastlogin FROM "#TABLE_USERS" WHERE ip = '%e' ORDER BY lastlogin DESC", params);
    DBExecute("OnTraceIP", "i", playerid);


    return 1;
}

DB:OnOfflineGetIP(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "The username specified is not registered.");
    }
    else
    {
        new username[MAX_PLAYER_NAME], ip[16];


        GetDBStringField(0, "username", username);
        GetDBStringField(0, "ip", ip);

        if (!IsAdmin(playerid, GetDBIntField(0, "adminlevel") + 1))
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot check the IP of this admin");
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "* %s's IP: %s *", username, ip);
        }

    }
}

DB:OnTraceIP(playerid)
{
    new rows = GetDBNumRows();

    if (rows)
    {
        new username[24], date[24];

        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "___________ %i Results Found ___________", rows);

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "username", username);
            GetDBStringField(i, "lastlogin", date);

            SendClientMessageEx(playerid, COLOR_GREY2, "Name: %s - Last Seen: %s", username, date);
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "This IP address is not associated with any accounts.");
    }
}
