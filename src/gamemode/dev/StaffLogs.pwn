/// @file      StaffLogs.pwn
/// @author    Khalil
/// @date      Created at 2025-07-13 19:40:10
/// @copyright Copyright (c) 2025

CMD:kadminlogs(playerid, params[])
{
    if (!IsGodAdmin(playerid) && PlayerData[playerid][pAdminPersonnel] < 1)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if (strlen(params) < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /adminlogs [criteria (min 4 characters)]");
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, date, description FROM `log_admin` WHERE description like '%%%e%%' ORDER BY date DESC LIMIT 15", params);
    mysql_tquery(connectionID, queryBuffer, "OnShowAdminLogs", "i", playerid);
    return 1;
}

forward OnShowAdminLogs(playerid);
public OnShowAdminLogs(playerid)
{
    new rows = cache_get_row_count(connectionID);
    new description[250], date[24], strings[2048];
    strings = "Date\tDescription";
    for (new i = 0; i < rows; i ++)
    {
        cache_get_field_content(i, "description", description);
        cache_get_field_content(i, "date", date);
        format(strings, sizeof(strings), "%s\n%s\t%s",strings, date, description);
    }
    if (strlen(strings) > 0)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Admin Logs", strings, "Okay", "");
    }
}

CMD:kcookieslogs(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if (strlen(params) < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /cookieslogs [criteria (min 4 characters)]");
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, date, description FROM `log_givecookie` WHERE description like '%%%e%%' ORDER BY date DESC LIMIT 15", params);
    mysql_tquery(connectionID, queryBuffer, "OnShowCookiesLogs", "i", playerid);
    return 1;
}

forward OnShowCookiesLogs(playerid);
public OnShowCookiesLogs(playerid)
{
    new rows = cache_get_row_count(connectionID);
    new description[250], date[24], strings[2048];
    strings = "Date\tDescription";
    for (new i = 0; i < rows; i ++)
    {
        cache_get_field_content(i, "description", description);
        cache_get_field_content(i, "date", date);
        format(strings, sizeof(strings), "%s\n%s\t%s",strings, date, description);
    }
    if (strlen(strings) > 0)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Cookies Logs", strings, "Okay", "");
    }
}