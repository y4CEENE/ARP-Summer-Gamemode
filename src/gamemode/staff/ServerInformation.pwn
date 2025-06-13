
DB:ListChanges(playerid)
{
    new rows = GetDBNumRows();
    new text[128];

    SendClientMessage(playerid, COLOR_NAVYBLUE, "________ Changes List ________");

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "text", text);
        SendClientMessageEx(playerid, COLOR_GREY1, "Slot %i -> %s", GetDBIntField(i, "slot"), text);
    }
}

CMD:updates(playerid,params[])
{
    DBQueryWithCallback("SELECT * FROM changes ORDER BY slot", "ListChanges", "i", playerid);
    return 1;
}

CMD:changelist(playerid, params[])
{
    new slot, option[10], param[64];

    if (!IsAdmin(playerid, ADMIN_LVL_8) && !PlayerData[playerid][pDeveloper])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[10]S()[64]", option, param))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changelist [view | edit | clear]");
    }
    if (!strcmp(option, "view", true))
    {
        DBQueryWithCallback("SELECT * FROM changes ORDER BY slot", "ListChanges", "i", playerid);
    }
    else if (!strcmp(option, "edit", true))
    {
        if (sscanf(param, "is[64]", slot, param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changelist [edit] [slot (1-10)] [text]");
        }
        if (!(1 <= slot <= 10))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
        }
        DBQuery("INSERT INTO changes VALUES(%i, '%e') ON DUPLICATE KEY UPDATE text = '%e'", slot, param, param);
        SendClientMessageEx(playerid, COLOR_AQUA, "* Change text for slot %i changed to '%s'.", slot, param);
    }
    else if (!strcmp(option, "clear", true))
    {
        if (sscanf(param, "i", slot))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changelist [clear] [slot (1-10)]");
        }
        if (!(1 <= slot <= 10))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
        }
        DBQuery("DELETE FROM changes WHERE slot = %i", slot);
        SendClientMessageEx(playerid, COLOR_AQUA, "* Change text for slot %i cleared.", slot);
    }

    return 1;
}

CMD:info(playerid, params[])
{
    return callcmd::information(playerid, params);
}

CMD:information(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Server Information _____");
    SendClientMessageEx(playerid, COLOR_GREY2, "Website: %s", GetServerWebsite());
    SendClientMessageEx(playerid, COLOR_GREY2, "Discord: %s", GetServerDiscord());
    SendClientMessageEx(playerid, COLOR_GREY2, "Gang discord: %s", GetGangDiscord());
    SendClientMessageEx(playerid, COLOR_GREY2, "Faction discord: %s", GetFactionDiscord());
    //SendClientMessageEx(playerid, COLOR_GREY2, "UCP: %s", GetServerUCP());
    //SendClientMessageEx(playerid, COLOR_GREY2, "Donate: %s", GetServerShop());
    return 1;
}
