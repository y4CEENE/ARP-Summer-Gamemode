/// @file      LogsStaff.pwn
/// @author    Khalil
/// @date      Created at 2025-04-10 12:23:10
/// @copyright Copyright (c) 2025

CMD:adminlogs(playerid, params[])
{
    if (!IsGodAdmin(playerid) && PlayerData[playerid][pAdminPersonnel] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (strlen(params) < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /adminlogs [criteria (min 4 characters)]");
    }
    DBFormat("SELECT id, date, description FROM `log_admin` WHERE description like '%%%e%%' ORDER BY date DESC LIMIT 15", params);
    DBExecute("OnShowAdminLogs", "i", playerid);
    return 1;
}

DB:OnShowAdminLogs(playerid)
{
    new rows = GetDBNumRows();
    new description[250], date[24], strings[2048];
    strings = "Date\tDescription";
    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "description", description);
        GetDBStringField(i, "date", date);
        format(strings, sizeof(strings), "%s\n%s\t%s",strings, date, description);
    }
    if (strlen(strings) > 0)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Admin Logs", strings, "Okay", "");
    }
}

CMD:cookieslogs(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (strlen(params) < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /cookieslogs [criteria (min 4 characters)]");
    }
    DBFormat("SELECT id, date, description FROM `log_givecookie` WHERE description like '%%%e%%' ORDER BY date DESC LIMIT 15", params);
    DBExecute("OnShowCookiesLogs", "i", playerid);
    return 1;
}

DB:OnShowCookiesLogs(playerid)
{
    new rows = GetDBNumRows();
    new description[250], date[24], strings[2048];
    strings = "Date\tDescription";
    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "description", description);
        GetDBStringField(i, "date", date);
        format(strings, sizeof(strings), "%s\n%s\t%s",strings, date, description);
    }
    if (strlen(strings) > 0)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Cookies Logs", strings, "Okay", "");
    }
}