
Dialog:DIALOG_REMOVEFLAG(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new targetid = PlayerData[playerid][pRemoveFrom];

        if (targetid == INVALID_PLAYER_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player has disconnected. You can't remove their flags now.");
        }

        DBFormat("SELECT id, description FROM flags WHERE uid = %i LIMIT %i, 1", PlayerData[targetid][pID], listitem);
        DBExecute("OnVerifyRemoveFlag", "ii", playerid, targetid);
    }
    return 1;
}

DB:ListFlagged(playerid)
{
    new rows = GetDBNumRows();
    new flags[MAX_PLAYERS];
    new username[MAX_PLAYER_NAME];
    new targetid;

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Flagged Players _____");

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringFieldFromIndex(i, 0, username);

        if (IsPlayerOnline(username, targetid))
        {
            flags[targetid]++;
        }
    }

    foreach(new i : Player)
    {
        if (flags[i] > 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY3, "* %s[%i] has %i active flags.", GetRPName(i), i, flags[i]);
        }
    }
}

DB:CountFlags(playerid)
{
    new rows = GetDBNumRows();
    if (rows)
    {
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has %i pending flags. (/listflags %i)", GetRPName(playerid), playerid, rows, playerid);
    }
}

DB:OnListPlayerFlags(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "This player has no flags listed under their account.");
    }
    else
    {
        new flaggedby[24], date[24], desc[128];

        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_________ %s's Flags _________", GetRPName(targetid));

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "flaggedby", flaggedby);
            GetDBStringField(i, "date", date);
            GetDBStringField(i, "description", desc);

            SendClientMessageEx(playerid, COLOR_GREY2, "[%i][%s] %s (from: %s)", i + 1, date, desc, flaggedby);
        }
    }
}

DB:OnVerifyRemoveFlag(playerid, targetid)
{
    if (GetDBNumRows())
    {
        new
            desc[128];

        GetDBStringField(0, "description", desc);

        DBQuery("DELETE FROM flags WHERE id = %i", GetDBIntField(0, "id"));

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has removed %s's flag for '%s'.", GetAdmCmdRank(playerid), GetRPName(playerid), GetRPName(targetid), desc);
    }
}

CMD:listflags(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listflags [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT * FROM flags WHERE uid = %i ORDER BY date DESC", PlayerData[targetid][pID]);
    DBExecute("OnListPlayerFlags", "ii", playerid, targetid);
    return 1;
}

CMD:flag(playerid, params[])
{
    new targetid, desc[128];

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[128]", targetid, desc))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /flag [playerid] [description]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    DBQuery("INSERT INTO flags VALUES(null, %i, '%e', NOW(), '%e')", PlayerData[targetid][pID], GetPlayerNameEx(playerid), desc);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s flagged %s's account for '%s'.", GetRPName(playerid), GetRPName(targetid), desc);
    return 1;
}

CMD:oflag(playerid, params[])
{
    new name[24], desc[128];

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]s[128]", name, desc))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /oflag [username] [description]");
    }

    DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
    DBExecute("OnAdminOfflineFlag", "iss", playerid, name, desc);
    return 1;
}

CMD:listflagged(playerid, params[])
{
    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }

    DBQueryWithCallback("SELECT b.username FROM flags a, "#TABLE_USERS" b WHERE a.uid = b.uid ORDER BY b.username", "ListFlagged", "i", playerid);
    return 1;
}

CMD:removeflag(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeflag [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT * FROM flags WHERE uid = %i", PlayerData[targetid][pID]);
    DBExecute("OnAdminListFlagsForRemoval", "ii", playerid, targetid);
    return 1;
}
