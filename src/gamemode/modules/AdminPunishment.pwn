
#include <YSI\y_hooks>

#define TABLE_PUNISHMENTS "users_punishment"

LogPlayerPunishment(adminid, player_uid, ip[], type[], const description[], {Float,_}:...)
{
    static sizeArgsInBytes, args, string[4096];
    new admin_uid  = IsPlayerConnected(adminid)?PlayerData[adminid][pID]:0;

    if (!strlen(description))
    {
        return 0;
    }

    if ((args = numargs()) > 5)
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 5)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    description
        #emit PUSH.C    4096
        #emit PUSH.C    string
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        DBQuery("INSERT INTO "#TABLE_PUNISHMENTS" (player_uid, player_ip, admin_uid, type, description) VALUES (%i, '%e', %i, '%e', '%e')",
                player_uid, ip, admin_uid, type, string);

        #emit RETN
    }
    else
    {
        DBQuery("INSERT INTO "#TABLE_PUNISHMENTS" (player_uid, player_ip, admin_uid, type, description) VALUES (%i, '%e', %i, '%e', '%e')",
                player_uid, ip, admin_uid, type, description);
    }
    return 1;
}

CMD:punlist(playerid, params[])
{
    new targetid;
    if (!IsAdmin(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /punlist [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
    }
    if (!IsPlayerLoggedIn(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Player is not loggedin.");
    }
    if (PlayerData[playerid][pAdmin] < PlayerData[targetid][pAdmin])
    {
        // Show empty punlist
        new title[64];
        format(title, sizeof(title), "Punishment history of %s", GetPlayerNameEx(targetid));
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, "Date\tType\tDescription", "Ok", "Cancel");
        return 1;
    }
    DBFormat("SELECT * FROM "#TABLE_PUNISHMENTS" WHERE player_uid = %i  ORDER BY date DESC", PlayerData[targetid][pID]);
    DBExecute("ShowPunList", "is", playerid, GetPlayerNameEx(targetid));
    return 1;
}

DB:ShowPunList(playerid, username[])
{
    new rows = GetDBNumRows();
    if (rows == 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "%s doesn't have any punishment.", username);
    }
    new date[24], type[32], description[128];
    static details[4096], title[64];
    details = "Date\tType\tDescription";
    for (new i=0;i<rows;i++)
    {
        GetDBStringField(i, "date", date);
        GetDBStringField(i, "type", type);
        GetDBStringField(i, "description", description);
        format(details, sizeof(details), "%s\n%s\t%s\t%s", details, date, type, description);
    }
    format(title, sizeof(title), "Punishment history of %s", username);
    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, details, "Ok", "Cancel");
    return 1;
}

CMD:opunlist(playerid, params[])
{
    new username[MAX_PLAYER_NAME];
    if (!IsAdmin(playerid, ADMIN_LVL_2))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Your not authorized to use that command!");
    }
    if (sscanf(params, "s[32]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /opunlist [username]");
    }

    DBFormat("SELECT p.* FROM "#TABLE_PUNISHMENTS" as p, "#TABLE_USERS" as u"\
             " WHERE p.player_uid = u.uid and u.username='%e' ORDER BY date DESC", username);
    DBExecute("ShowPunList", "is", playerid, username);
    return 1;
}
