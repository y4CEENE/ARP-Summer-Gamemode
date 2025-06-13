
GetAdminName(playerid)
{
    new adminname[24];
    strcpy(adminname, GetRPName(playerid));
    if (PlayerData[playerid][pUndercover][0])
    {
        if (strcmp(PlayerData[playerid][pAdminName], "None", true))
        {
            strcpy(adminname, PlayerData[playerid][pAdminName]);
        }
    }
    return adminname;
}

#define MAX_GOD_ADMINS 10 

// Define a Static List of God Admins (UID-based for efficiency)
static const GodAdmins[MAX_GOD_ADMINS] = 
{
    6,   	// Yassine_Castellano ( 6 )
	1112,   // Khalil_Zoldyck (Added here)
    8,   	// Abdou_Berman ( 8 )
    0,   	// Reserved Slot
    0,   	// Reserved Slot
    0,   	// Reserved Slot
    0,   	// Reserved Slot
    0,   	// Reserved Slot
    0,   	// Reserved Slot
    0    	// Reserved Slot
};

// Function to Check if a UID is a God Admin (Optimized Loop)
stock bool:IsUIDGodAdmin(uid)
{
    for (new i = 0; i < MAX_GOD_ADMINS; i++)
    {
        if (GodAdmins[i] == uid) return true;
    }
    return false;
}

// Function to Check if a Player is a God Admin (Optimized)
forward bool:IsGodAdmin(playerid);
stock bool:IsGodAdmin(playerid)
{
    if (!PlayerData[playerid][pLogged] || PlayerData[playerid][pKicked])
        return false;

    return IsUIDGodAdmin(PlayerData[playerid][pID]);
}

GetAdminLvl(playerid)
{
    return PlayerData[playerid][pAdmin];
}

IsAdmin(playerid, level=1)
{
    return (GetAdminLvl(playerid) >= level)  || IsGodAdmin(playerid);
}

IsAdminOnDuty(playerid, ignore_highrank=true)
{
    if (ignore_highrank)
    {
        return (PlayerData[playerid][pAdminDuty] == 1 || IsAdmin(playerid, ADMIN_LVL_8));
    }
    return (PlayerData[playerid][pAdminDuty] == 1);
}

publish GetAdminLevel(playerid)
{
    return PlayerData[playerid][pAdmin];
}


SendAdminWarning(admin_level, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if (IsAdmin(i, admin_level) && PlayerData[i][pLogged])
            {
                SendClientMessageEx(i, COLOR_YELLOW, "[AdmWarning]{FFFF00} %s", text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (IsAdmin(i, admin_level) && PlayerData[i][pLogged])
            {
                SendClientMessageEx(i, COLOR_YELLOW, "[AdmWarning]{FFFF00} %s", str);
            }
        }

        #emit RETN
    }
    return 1;
}


GetStaffRank(playerid)
{
    new string[24];

    if (IsAdmin(playerid, ADMIN_LVL_2) && !PlayerData[playerid][pAdminHide])
    {
        switch (GetAdminLvl(playerid))
        {
            case 2: string = "Trial Admin";
            case 3: string = "Junior Admin";
            case 4: string = "General Admin";
            case 5: string = "Senior Admin";
            case 6: string = "Head Admin";
            case 7: string = "Lead Head Admin";
            case 8: string = "Executive Admin";
            case 9: string = "Assistant Management";
            case 10: string = "Management";
        }
        return string;
    }
    if (PlayerData[playerid][pHelper] > 0)
    {
        switch (PlayerData[playerid][pHelper])
        {
            case 1: string = "Junior Helper";
            case 2: string = "Senior Helper";
            case 3: string = "Ast Head Helper";
            case 4: string = "Head Helper";
            case 5: string = "Junior Advisor";
            case 6: string = "Senior Advisor";
            case 7: string = "Chief Advisor";
        }
    }
    else if (PlayerData[playerid][pFormerAdmin])
    {
        string = "Former Admin";
    }
    else
    {
        string = "Undercover Admin";
    }
    return string;
}

GetAdminRank(playerid)
{
    new string[24];

    switch (GetAdminLvl(playerid))
    {
        case 0:
        {
            if (PlayerData[playerid][pFormerAdmin])
                string = "Former Admin";
            else
                string = "None";
        }
        case 1: string = "Secret Admin";
        case 2: string = "Trial Admin";
        case 3: string = "Junior Admin";
        case 4: string = "General Admin";
        case 5: string = "Senior Admin";
        case 6: string = "Head Admin";
        case 7: string = "Lead Head Admin";
        case 8: string = "Executive Admin";
        case 9: string = "Assistant Management";
        case 10: string = "Management";


    }
    return string;
}
GetAdmCmdRank(playerid)
{
    new string[64];

    switch (GetAdminLvl(playerid))
    {
        case 1: string = "Secret Admin";
        case 2: string = "{00FF00}Trial Admin{FF6347}";
        case 3: string = "{00AA00}Junior Admin{FF6347}";
        case 4: string = "{FDEE00}General Admin{FF6347}";
        case 5: string = "{FFA500}Senior Admin{FF6347}";
        case 6: string = "{FF0000}Head Admin{FF6347}";
        case 7: string = "{298EFF}Lead Head Admin{FF6347}";
        case 8: string = "{298EFF}Executive Admin{FF6347}";
        case 9: string = "{B000FF}Asst Management{FF6347}";
        case 10: string = "{D909D9}Management{FF6347}";
    }
    return string;
}
GetAdminRank1(playerid)
{
    new string[24];

    switch (GetAdminLvl(playerid))
    {
        case 0:
        {
            if (PlayerData[playerid][pFormerAdmin])
                string = "Former Admin";
            else if (PlayerData[playerid][pDeveloper])
                string = "Developer";
            else
                string = "None";
        }
        case 1: string = "Secret Admin";
        case 2: string = "{00FF00}Trial Admin";
        case 3: string = "{00AA00}Junior Admin";
        case 4: string = "{00AA00}General Admin";
        case 5: string = "{FFA500}Senior Admin";
        case 6: string = "{FF0000}Head Admin";
        case 7: string = "{298EFF}Lead Head Admin";
        case 8: string = "{298EFF}Executive Admin";
        case 9: string = "{D909D9}Asst Management";
        case 10: string = "{D909D9}Management";
    }
    return string;
}

GetAdminDivision(playerid)
{
    new division[4];
    if (PlayerData[playerid][pAdminPersonnel])
    {
        division = "AP";
    }
    else if (PlayerData[playerid][pHumanResources])
    {
        division = "HR";
    }
    else if (PlayerData[playerid][pGameAffairs])
    {
        division = "GA";
    }
    else if (PlayerData[playerid][pWebDev])
    {
        division = "BM";
    }
    else if (PlayerData[playerid][pFactionMod])
    {
        division = "FM";
    }
    else if (PlayerData[playerid][pGangMod])
    {
        division = "GM";
    }
    else if (PlayerData[playerid][pBanAppealer])
    {
        division = "BA";
    }
    else if (PlayerData[playerid][pComplaintMod])
    {
        division = "CM";
    }
    else if (PlayerData[playerid][pHelperManager])
    {
        division = "HM";
    }
    else if (PlayerData[playerid][pDynamicAdmin])
    {
        division = "DA";
    }
    else if (PlayerData[playerid][pDeveloper])
    {
        division = "DEV";
    }
    else
    {
        division = "";
    }
    return division;
}


new const randFirstname[][] = {
    "Alex", "Blake", "Hayden", "Devin", "Jane", "John", "Austin", "Richy", "Richard", "Alexander",
    "Salem", "Daisy", "Janey", "Casey", "Orlando", "Jake", "Kevin", "Faze", "India", "Vene", "Demorgan", "Jazzy", "Dori", "Jess", "Linda",
    "Dave", "Jessica", "Masey", "Rose", "Romeo", "Juliet", "Ben", "Lenny", "Kayle", "Emily", "Tori", "Michael", "Mike", "Mikey", "Christian", "Josh", "Travis",
    "Dulles", "William", "Stephen", "Peter", "Quin", "Raze", "Morgan", "Oliver", "Madison", "Mark", "Robin", "Tyler", "Sophie", "Sophia", "Brianna", "Azure", "Steely", "Lee",
    "Ray", "Harry", "Ralph", "Anthony", "Alan", "Shawn", "Kanye", "Kane", "Stephanie", "Kimmy", "Kim" "Fox", "Bob", "Adore", "Lexi", "Rex", "Hex", "Xav", "Wally", "Stone", "Kate", "Katie", "Patrick", "James", "Thomas", "Hank",
    "George", "David", "Dori", "Dante", "Jordan", "Arnold" };
new const randLastname[][] = {
    "Craig", "Jones", "Johnson", "Kennedy", "Hinson", "Doe", "Silva", "Nigeria", "Branche", "Erickson", "Defolt", "Morgan",
    "Stalovsky", "Box", "Wards", "Sanders", "Williams", "Trump", "Nixon", "Jackson", "Houston", "Hilfiger", "Gucci", "Washington", "Clinton",
    "Cromwell", "Prime", "Connor", "ONeil", "Rose", "Ginger", "Dodge", "McKing", "Guerreo", "Jackson", "Cartel", "Devil", "Rolex", "Street", "Molintino",
    "Martin", "Stone", "Henderson", "Brady", "Wilkinson" }; // keep adding names if u want

getRandomRPName()
{
    new rand[2], name[60];
    rand[0] = random(sizeof(randFirstname));
    rand[1] = random(sizeof(randLastname));

    if (strcmp(randFirstname[rand[0]], randLastname[rand[1]], true) != 0)
    {
        format(name, sizeof(name), "%s_%s", randFirstname[rand[0]], randLastname[rand[1]]);
        if (strlen(name) < MAX_PLAYER_NAME)
        {
            return name;
        }
    }
    return getRandomRPName();
}

DB:OnUndercover(playerid, tog, name[], level, Float:hp, Float:armor)
{
    if (tog)
    {
        if (GetDBNumRows())
        {
            SendClientMessage(playerid, COLOR_GREY, "The name specified is taken already.");
        }
        else
        {
            DBLog("log_admin", "(undercover) %s (uid: %i) changed their name to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], name);
            SendClientMessageEx(playerid, COLOR_WHITE, "* You changed your name from %s to %s.", GetRPName(playerid), name);
            PlayerData[playerid][pUndercover][0] = 1;
            PlayerData[playerid][pUndercover][1] = PlayerData[playerid][pLevel];
            PlayerData[playerid][pUndercoverHP] = PlayerData[playerid][pHealth];
            PlayerData[playerid][pUndercoverAR] = PlayerData[playerid][pArmor];
            PlayerData[playerid][pLevel] = level;
            SetPlayerHealth(playerid, hp);
            SetScriptArmour(playerid, armor);
            SetPlayerName(playerid, name);
            PlayerData[playerid][pAdminHide] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "You are now hidden in /admins and your admin rank no longer shows in /a, /g or /o.");
        }
    }
    else
    {
        SetPlayerName(playerid, PlayerData[playerid][pUsername]);
        PlayerData[playerid][pUndercover][0] = 0;
        PlayerData[playerid][pLevel] = PlayerData[playerid][pUndercover][1];
        SetPlayerHealth(playerid, PlayerData[playerid][pUndercoverHP]);
        SetScriptArmour(playerid, PlayerData[playerid][pUndercoverAR]);
        PlayerData[playerid][pAdminHide] = 0;
        SendClientMessage(playerid, COLOR_AQUA, "You are no longer hidden as an administrator.");
    }
    return 1;
}

CMD:undercover(playerid, params[])
{
    new name[MAX_PLAYER_NAME], level, Float:armor;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pAdminPersonnel])
    {
        return SendUnauthorized(playerid);
    }

    if (PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Not Authorized / You need to be off duty to use this command.");
    }

    if (sscanf(params, "s[24]I(-1)", name, level))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /undercover [name | random | off] [level (optional)]");
    }

    if (level == -1)
    {
        level = random(29) + 1;
    }
    else if (level < 1 || level > 30)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Level must be between 1 and 30.");
    }

    if (PlayerData[playerid][pUndercover][0])
    {
        calldb::OnUndercover(playerid, 0, "", 0, 0.0, 0.0);
        SendClientMessageEx(playerid, COLOR_WHITE, "* You are no longer undercover.", GetRPName(playerid), name);
    }
    else if (!strcmp(name, "random", true))
    {
        strcpy(name, getRandomRPName());
        level = random(9) + 1;
        armor = float(random(50)+50);
        DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
        DBExecute("OnUndercover", "iisiff", playerid, 1, name, level, 100.0, armor);
    }
    else if (strfind(name, "_") != -1)
    {
        armor = float(random(50)+50);
        DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
        DBExecute("OnUndercover", "iisiff", playerid, 1, name, level, 100.0, armor);
    }
    else
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /undercover [Firstname_Lastname | random]");
    }
    return 1;
}


CMD:ah(playerid, params[])
{
	return callcmd::adminhelp(playerid, params);
}

CMD:ahelp(playerid, params[])
{
	return callcmd::adminhelp(playerid, params);
}

CMD:adminhelp(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1)
    {
        return SendUnauthorized(playerid);
    }

    new string[2048];
    format(string, sizeof(string), "{99CCFF}Secret Admin:{DDDDDD} /a, /clearchat, /skick, /sban, /sjail, /pinfo, /spec, /reports, /admins, /flag, /removeflag, /listflags, /check, /dm.\n");
    format(string, sizeof(string), "%s{99CCFF}Secret Admin:{DDDDDD} /ocheck, /oflag, /listflagged, /hhcheck, /kills, /shots, /damages, /vmute\n\n", string);

    if (PlayerData[playerid][pAdmin] >= 3)
    {
        format(string, sizeof(string), "%s{33FF33}Junior Admin:{DDDDDD} /aduty, /adm, /adminname, /kick, /ban, /warn, /slap, /ar, /tr, /rr, /cr, /setint, /setvw, /addjailtime.\n", string);
        format(string, sizeof(string), "%s{33FF33}Junior Admin:{DDDDDD} /setskin, /revive, /heject, /goto, /gethere, /gotocar, /getcar, /gotocoords, /gotoint, /listen, /jetpack, /sendto.\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 4)
    {
        format(string, sizeof(string), "%s{FFFF00}General Admin:{DDDDDD} /ban, /(o)getip, /iplookup, /prison, /sprison, /oprison, /release, /fine, /pfine, /ofine, /sethp, /setarmor, /mark, /gotomark.\n", string);
        format(string, sizeof(string), "%s{FFFF00}General Admin:{DDDDDD} /veh, /destroyveh, /respawncars, /broadcast, /fixveh, /healrange, /sethp, /setarmor, /mark.\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 5)
    {
        format(string, sizeof(string), "%s{FFA500}Senior Admin:{DDDDDD} /givegun, /setname, /setweather, /ban, /findban, /lockaccount, /unlockaccount.\n", string);
        format(string, sizeof(string), "%s{FFA500}Senior Admin:{DDDDDD} /explode, /event, /gplay, /gplayurl, /gstop, /sethpall, /setarmorall, /settime, /addtoevent, /eventkick.\n", string);
        format(string, sizeof(string), "%s{FFA500}Senior Admin:{DDDDDD} /adestroyboombox, /setbanktimer, /resetrobbery, /addtorobbery, /givepayday.\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 6)
    {
        format(string, sizeof(string), "%s{FF3333}Head Admin:{DDDDDD} /givemoney, /givecookie, /givecookieall, /saveaccounts.\n", string);
        format(string, sizeof(string), "%s{FF3333}Head Admin:{DDDDDD} /previewint, /nearest, /dynamichelp, /listassets.\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 7)
    {
        format(string, sizeof(string), "%s{00bbcc}Lead Head Admin:{DDDDDD} /makehelper, /omakehelper, /setmotd, /forceaduty.\n", string);
        format(string, sizeof(string), "%s{00bbcc}Lead Head Admin:{DDDDDD} /olisthelpers, /changelist, /fixplayerid, /giveachievement.\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 8)
    {
        format(string, sizeof(string), "%s{00FFFF}Executive Admin:{DDDDDD} /setmotd, /forceaduty, /rewards.\n", string);
        format(string, sizeof(string), "%s{00FFFF}Executive Admin:{DDDDDD} /olisthelpers, /sellinactive, /inactivecheck, /changelist, /fixplayerid, /giveachievement.\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 9)
    {
        format(string, sizeof(string), "%s{800080}Asst Management:{DDDDDD} /makeadmin, /makehelper, /createhouse, /createbiz, /createland, /adminstrike, /doublexp, /enddoublexp\n\n", string);
    }

    if (PlayerData[playerid][pAdmin] >= 10)
    {
        format(string, sizeof(string), "%s{D909D9}Management:{DDDDDD} /gmx, /lockserver, /serversetting, /setdamages, /adminstrike, /doublexp, /enddoublexp\n", string);
    }

    ShowPlayerDialog(playerid, DIALOG_ADMINHELP, DIALOG_STYLE_MSGBOX, "{FF0000}Admin Commands", string, "Close", "");
    return 1;
}

DB:ListAdmins(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME], lastlogin[24];
    new adminname[MAX_PLAYER_NAME], adminstring[64];
    new adminstrikes, adminlevel;
    static strings[4096];
    strings = "Name\tLast Login\tStrikes\tRank";

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "username", username);
        GetDBStringField(i, "lastlogin", lastlogin);
        GetDBStringField(i, "adminname", adminname);
        adminlevel   = GetDBIntField(i, "adminlevel");
        adminstrikes = GetDBIntField(i, "adminstrikes");
        switch (adminlevel)
        {
            case 1: adminstring = "Secret Admin";
            case 2: adminstring = "{00FF00}Trial Admin";
            case 3: adminstring = "{00AA00}Junior Admin";
            case 4: adminstring = "{00AA00}General Admin";
            case 5: adminstring = "{FFA500}Senior Admin";
            case 6: adminstring = "{FF0000}Head Admin";
            case 7: adminstring = "{298EFF}Lead Head Admin";
            case 8: adminstring = "{298EFF}Executive Admin";
            case 9: adminstring = "{D909D9}Asst Management";
            case 10: adminstring = "{D909D9}Management";
        }
        format(strings, sizeof(strings), "%s\n%s (%s)\t%s\t%d\t%s {ffffff}(%d)\n",
            strings, username, adminname, lastlogin, adminstrikes, adminstring, adminlevel);
        //SendClientMessageEx(playerid, COLOR_GREY2, "Level %i Admin %s - Last Seen: %s", GetDBIntField(i, "adminlevel"), username, lastlogin);
    }
    if (strlen(strings) > 0)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Admin Team", strings, "Okay", "");
    }
}

DB:OnAdminChangePassword(playerid, username[], password[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else
    {
        if (IsUIDGodAdmin(GetDBIntField(0, "uid")))
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot change password of this admin.");
            return;
        }
        new hashed[129];
        WP_Hash(hashed, sizeof(hashed), password);

        DBQuery("UPDATE "#TABLE_USERS" SET password = '%e' WHERE username = '%e'", hashed, username);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has changed %s's account password.",GetAdmCmdRank(playerid), GetRPName(playerid), username);
    }
}

DB:OnAdminVehiclesForRemoval(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "This player owns no vehicles.");
    }
    else
    {
        static string[1024];

        string = "#\tModel\tLocation";

        for (new i = 0; i < rows; i ++)
        {
            new
                vehicleid = GetVehicleLinkedID(GetDBIntField(i, "id"));

            if (vehicleid == INVALID_VEHICLE_ID)
            {
                format(string, sizeof(string), "%s\nn/a\t%s\t%s", string, GetVehicleNameByModel(GetDBIntField(i, "modelid")), (GetDBIntField(i, "interior")) ? ("Garage") : GetZoneName(GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z")));
            }
            else
            {
                format(string, sizeof(string), "%s\nID %i\t%s\t%s", string, vehicleid, GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
            }
        }

        PlayerData[playerid][pRemoveFrom] = targetid;
        Dialog_Show(playerid, DIALOG_REMOVEPVEH, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to remove.", string, "Select", "Cancel");
    }
}

DB:OnAdminListVehicles(playerid, targetid)
{
    new rows = GetDBNumRows();

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Vehicles _____", GetRPName(targetid));

    for (new i = 0; i < rows; i ++)
    {
        new
            vehicleid = GetVehicleLinkedID(GetDBIntField(i, "id"));

        if (vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "ID: n/a | Model: %s | Location: %s", GetVehicleNameByModel(GetDBIntField(i, "modelid")), (GetDBIntField(i, "interior")) ? ("Garage") : GetZoneName(GetDBFloatField(i, "pos_x"), GetDBFloatField(i, "pos_y"), GetDBFloatField(i, "pos_z")));
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "ID: %i | Model: %s | Location: %s", vehicleid, GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
        }
    }
}

DB:OnAdminOfflineDM(playerid, username[])
{
    if (GetDBNumRows() == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }

    if (!IsAdmin(playerid, GetDBIntField(0, "adminlevel")))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
    }

    new userid = GetDBIntField(0, "uid");
    new warns  = GetDBIntField(0, "warns");
    new userip[16];
    GetDBStringField(0, "ip", userip);

    warns++;

    if (warns < 3)
    {
        DBQuery("UPDATE "#TABLE_USERS" SET jailtype = 2, jailtime = %i, dmwarnings = %i,"\
            " weaponrestricted = %i, prisonedby = '%e', prisonreason = 'DM' WHERE uid = %i",
            warns * 3600, warns, warns * 4, GetPlayerNameEx(playerid), userid);

        LogPlayerPunishment(playerid, userid, userip,
            "DM", "%s was offline DM warned by %s %s. Prison: %i minutes. Weapon restriction: %i hours. DM (%i/3)",
            username, GetAdminRank(playerid), GetRPName(playerid), warns * 60, warns*4, warns);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was offline DM Warned & Prisoned for %i minutes by %s %s, reason: DM (%i/3)", username, warns * 60, GetAdmCmdRank(playerid), GetRPName(playerid), warns);
    }
    else
    {
        OfflineBanPlayer(userid, username, userip, "DM (3/3 warnings)");

        DBQuery("UPDATE "#TABLE_USERS" SET dmwarnings = 0 WHERE uid = %i", userid);

        LogPlayerPunishment(playerid, userid, userip,
            "DM", "%s was offline DM warned by %s %s. DM (3/3)",
            username, GetAdminRank(playerid), GetPlayerNameEx(playerid));
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was offline banned by %s %s, reason: DM (3/3 warnings)", username, GetAdmCmdRank(playerid), GetRPName(playerid));
    }
    return 1;
}

DB:OnAdminCheckNameHistory(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "This player has no namechange history recorded.");
    }
    else
    {
        new oldname[MAX_PLAYER_NAME], newname[MAX_PLAYER_NAME], changedby[MAX_PLAYER_NAME], date[24];

        SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Namechange History _____");

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "oldname", oldname);
            GetDBStringField(i, "newname", newname);
            GetDBStringField(i, "changedby", changedby);
            GetDBStringField(i, "date", date);

            SendClientMessageEx(playerid, COLOR_YELLOW, "[%s] %s has changed %s's name to %s.", date, changedby, oldname, newname);
        }
    }
}

DB:OnAdminListFlagsForRemoval(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "This player has no flags listed under their account.");
    }
    else
    {
        static string[4096], flaggedby[24], date[24], desc[128];

        string = "#\tFlagged by\tDate\tDescription";

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "flaggedby", flaggedby);
            GetDBStringField(i, "date", date);
            GetDBStringField(i, "description", desc);

            format(string, sizeof(string), "%s\n%i\t%s\t%s\t%s", string, i + 1, flaggedby, date, desc);
        }

        PlayerData[playerid][pRemoveFrom] = targetid;
        Dialog_Show(playerid, DIALOG_REMOVEFLAG, DIALOG_STYLE_TABLIST_HEADERS, "Choose a flag to remove.", string, "Select", "Cancel");
    }
}

DB:OnAdminCreateLocker(playerid, lockerid, factionid, Float:x, Float:y, Float:z, interior, world)
{
    LockerInfo[lockerid][lID] = GetDBInsertID();
    LockerInfo[lockerid][lExists] = 1;
    LockerInfo[lockerid][lFaction] = factionid;
    LockerInfo[lockerid][lPosX] = x;
    LockerInfo[lockerid][lPosY] = y;
    LockerInfo[lockerid][lPosZ] = z;
    LockerInfo[lockerid][lInterior] = interior;
    LockerInfo[lockerid][lWorld] = world;
    LockerInfo[lockerid][lIcon] = 1239;
    LockerInfo[lockerid][lLabel] = 1;

    //TODO: CHANGE SQL TOO PLS
    LockerInfo[lockerid][locKevlar] = { 1, 100 };
    LockerInfo[lockerid][locMedKit] = { 1, 50 };
    LockerInfo[lockerid][locNitestick] = { 0, 0 };
    LockerInfo[lockerid][locMace] = { 0, 0 };
    LockerInfo[lockerid][locDeagle] = { 1, 850 };
    LockerInfo[lockerid][locShotgun] = { 1, 1000 };
    LockerInfo[lockerid][locMP5] = { 1, 1500 };
    LockerInfo[lockerid][locM4] = { 1, 2500 };
    LockerInfo[lockerid][locSpas12] = { 1, 3500 };
    LockerInfo[lockerid][locSniper] = { 1, 5000 };
    LockerInfo[lockerid][locCamera] = { 0, 0 };
    LockerInfo[lockerid][locFireExt] = { 0, 0 };
    LockerInfo[lockerid][locPainKillers] = { 0, 0 };

    LockerInfo[lockerid][lText] = Text3D:INVALID_3DTEXT_ID;
    LockerInfo[lockerid][lPickup] = -1;

    ReloadLocker(lockerid);
    SendClientMessageEx(playerid, COLOR_GREEN, "* Locker %i created for %s.", lockerid, FactionInfo[factionid][fName]);
}

DB:OnAdminOfflineCheck(playerid, username[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else
    {
        // At first I didn't know how I was going to do this. But then I came up with a plan.
        // Load everything into an unused player slot, use DisplayStats as normal, then destroy the data.
        // This ensures that whenever I add a new thing to /stats for instance, I don't have to maintain
        // two stats functions, I can just call DisplayStats and let the work do itself.
        CallRemoteFunction("OnLoadPlayer", "ii", OFFLINE_PLAYER_ID, 0);
        DisplayStats(OFFLINE_PLAYER_ID, playerid);
    }
}

DB:OnAdminOfflineFlag(playerid, username[], desc[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else
    {
        DBQuery("INSERT INTO flags VALUES(null, %i, '%e', NOW(), '%e')", GetDBIntField(0, "uid"), GetPlayerNameEx(playerid), desc);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s offline flagged %s's account for '%s'.",GetAdmCmdRank(playerid), GetRPName(playerid), username, desc);
    }
}


DB:OnAdminCheckLastActive(playerid, username[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else
    {
        new
            date[40];

        GetDBStringFieldFromIndex(0, 0, date);
        SendClientMessageEx(playerid, COLOR_GREEN, "%s last logged in on the %s (server time).", username, date);
    }
}

DB:OnAdminSetHelperLevel(playerid, username[], level)
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else if ((!IsAdmin(playerid, ADMIN_LVL_8)) && GetDBIntFieldFromIndex(0, 0) > PlayerData[playerid][pHelper] && level < GetDBIntFieldFromIndex(0, 0))
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher helper level than you. They cannot be demoted.");
    }
    else
    {
        DBQuery("UPDATE "#TABLE_USERS" SET helperlevel = %i WHERE username = '%e'", level, username);

        SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has offline set %s's helper level to %i.",GetAdmCmdRank(playerid), GetRPName(playerid), username, level);
        DBLog("log_admin", "%s (uid: %i) has offline set %s's helper level to %i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, level);
    }
}

DB:OnAdminSetAdminLevel(playerid, username[], level)
{
    if (!GetDBNumRows())
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    if (!IsAdmin(playerid, GetDBIntFieldFromIndex(0, 0) + 1) && level < GetDBIntFieldFromIndex(0, 0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be demoted.");
    }
    DBQuery("UPDATE "#TABLE_USERS" SET adminlevel = %i WHERE username = '%e'", level, username);

    if (level == 0)
    {
        DBQuery("UPDATE "#TABLE_USERS" SET scripter = 0, gangmod = 0, banappealer = 0, factionmod = 0, helpermanager = 0, webdev = 0, dynamicadmin = 0, adminpersonnel = 0 WHERE username = '%e'", username);
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has offline set %s's admin level to %i.",GetAdmCmdRank(playerid), GetRPName(playerid), username, level);
    DBLog("log_admin", "%s (uid: %i) has offline set %s's admin level to %i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, level);
    return 1;
}

DB:OnAdminDeleteAccount(playerid, username[])
{
    if (!GetDBNumRows())
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }

    if (!IsAdmin(playerid, GetDBIntFieldFromIndex(0, 0) + 1))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. You cannot delete them.");
    }

    DBQuery("DELETE FROM "#TABLE_USERS" WHERE username = '%e'", username);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has deleted %s's account.", GetAdmCmdRank(playerid), GetPlayerNameEx(playerid), username);
    return 1;
}

DB:OnAdminListKills(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "That player hasn't killed, or has been killed, by anyone since they registered.");
    }
    else
    {
        new date[24], killer[24], target[24], reason[24];

        SendClientMessage(playerid, COLOR_NAVYBLUE, "________ Kills & Deaths ________");

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "date", date);
            GetDBStringField(i, "killer", killer);
            GetDBStringField(i, "target", target);
            GetDBStringField(i, "reason", reason);

            if (GetDBIntField(i, "killer_uid") == PlayerData[targetid][pID])
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "[%s] %s killed %s (%s)", date, killer, target, reason);
            }
            else if (GetDBIntField(i, "target_uid") == PlayerData[targetid][pID])
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "[%s] %s was killed by %s (%s)", date, target, killer, reason);
            }
        }
    }
}

DB:OnAdminListShots(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "That player hasn't registered any shots since they connected.");
    }
    else
    {
        new weaponid, hittype, timestamp, hit[48];

        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "___________ %i Last Shots ___________", rows);

        for (new i = 0; i < rows; i ++)
        {
            weaponid    = GetDBIntField(i, "weaponid");
            hittype     = GetDBIntField(i, "hittype");
            timestamp   = GetDBIntField(i, "timestamp");

            switch (hittype)
            {
                case BULLET_HIT_TYPE_PLAYER:
                    GetDBStringField(i, "hitplayer", hit);
                case BULLET_HIT_TYPE_VEHICLE:
                    format(hit, sizeof(hit), "Vehicle (ID %i)", GetDBIntField(i, "hitid"));
                default:
                    hit = "Missed";
            }

            SendClientMessageEx(playerid, COLOR_YELLOW, "[%i seconds ago] %s shot a %s and hit: %s", gettime() - timestamp, GetRPName(targetid), GetWeaponNameEx(weaponid), hit);
        }
    }
}


DB:OnAdminLockAccount(playerid, name[], reason[])
{
    if (!GetDBNumRows())
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The player '%s' specified doesn't exist.", name);
    }
    new locked     = GetDBIntField(0, "locked");
    new adminlevel = GetDBIntField(0, "adminlevel");
    new userid     = GetDBIntField(0, "uid");
    new username[MAX_PLAYER_NAME], userip[16];
    GetDBStringField(0, "username", username);
    GetDBStringField(0, "ip", userip);

    if (locked)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player's account is already locked. /unlockaccount to unlock it.");
    }

    if (!IsAdmin(playerid, adminlevel + 1))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be locked.");
    }

    DBQuery("UPDATE "#TABLE_USERS" SET locked = 1 WHERE username = '%e'", username);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has locked %s's account.",GetAdmCmdRank(playerid), GetRPName(playerid), username);
    DBLog("log_admin", "%s (uid: %i) locked %s's account. Reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, reason);

    LogPlayerPunishment(playerid, userid, userip,
        "LOCK", "%s was locked by %s %s. Reason: %s",
        username, GetAdminRank(playerid), GetPlayerNameEx(playerid), reason);
    return 1;
}

DB:OnAdminUnlockAccount(playerid, name[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist, or their account is not locked.");
    }
    else
    {
        new userid     = GetDBIntField(0, "uid");
        new username[MAX_PLAYER_NAME], userip[16];
        GetDBStringField(0, "username", username);
        GetDBStringField(0, "ip", userip);

        DBQuery("UPDATE "#TABLE_USERS" SET locked = 0 WHERE username = '%e'", username);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has unlocked %s's account.",GetAdmCmdRank(playerid), GetRPName(playerid), username);
        DBLog("log_admin", "%s (uid: %i) unlocked %s's account.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username);

        LogPlayerPunishment(playerid, userid, userip,
            "UNLOCK", "%s was unlocked by %s %s.",
            username, GetAdminRank(playerid), GetPlayerNameEx(playerid));
    }
}

DB:OnAdminChangeName(playerid, targetid, name[])
{
    if (GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The name specified is taken already.");
    }
    else
    {
        DBLog("log_admin", "%s (uid: %i) changed %s's (uid: %i) name to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], name);
        DBLog("log_namechanges", "%s (uid: %i) changed %s's (uid: %i) name to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], name);

        DBQuery("INSERT INTO log_namehistory VALUES(null, %i, '%e', '%e', '%e', NOW())", PlayerData[targetid][pID], GetPlayerNameEx(targetid), name, GetPlayerNameEx(playerid));

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has changed %s's name to %s.", GetAdmCmdRank(playerid),GetRPName(playerid), GetRPName(targetid), name);
        SendClientMessageEx(targetid, COLOR_WHITE, "%s changed your name from %s to %s.", GetRPName(playerid), GetRPName(targetid), name);

        Namechange(targetid, GetPlayerNameEx(targetid), name);
    }
}

DB:OnAdminOfflinePrison(playerid, username[], minutes, reason[])
{
    if (GetDBNumRows())
    {
        if (!IsAdmin(playerid, GetDBIntField(0, "adminlevel") + 1))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be prisoned.");
        }

        DBQuery("UPDATE "#TABLE_USERS" SET jailtype = 2, jailtime = %i, prisonedby = '%e', prisonreason = '%e' WHERE username = '%e'", minutes * 60, GetPlayerNameEx(playerid), reason, username);

        new uid = GetDBIntField(0, "uid");
        new ip[16];
        GetDBStringField(0, "ip", ip);

        LogPlayerPunishment(playerid, uid, ip,
            "PRISON", "%s was offline prisoned by %s %s for %i minutes. Reason: %s",
            username, GetAdminRank(playerid), GetRPName(playerid), minutes, reason);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was offline prisoned for %i minutes by %s %s, reason: %s", username, minutes, GetAdmCmdRank(playerid), GetRPName(playerid), reason);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "That player is not registered.");
    }

    return 1;
}

DB:OnAdminOfflineFine(playerid, username[], amount, reason[])
{
    if (GetDBNumRows())
    {
        if (!IsAdmin(playerid, GetDBIntFieldFromIndex(0, 0) + 1))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be fined.");
        }

        DBQuery("UPDATE "#TABLE_USERS" SET cash = cash - %i WHERE username = '%e'", amount, username);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was offline fined for %s by %s %s, reason: %s", username, FormatCash(amount), GetAdmCmdRank(playerid),GetRPName(playerid), reason);
        DBLog("log_admin", "%s (uid: %i) offline fined %s for $%i, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, amount, reason);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "That player is not registered.");
    }

    return 1;
}

CMD:givemoney(playerid, params[])
{
    new targetid, amount;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givemoney [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!(-50000000 <= amount <= 50000000))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under -$50,000,000 or above $50,000,000.");
    }

    GivePlayerCash(targetid, amount);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s to %s.", GetRPName(playerid), FormatCash(amount), GetRPName(targetid));
    DBLog("log_givemoney", "%s (uid: %i) has used /givemoney to give $%i to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    return 1;
}

CMD:givemoneyall(playerid, params[])
{
    new amount;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givemoneyall [amount]");
    }

    foreach(new targetid: Player)
    {
        if (!PlayerData[targetid][pLogged])
        {
            continue;
        }
        GivePlayerCash(targetid, amount);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s to %s.", GetRPName(playerid), FormatCash(amount), GetRPName(targetid));
        DBLog("log_givemoney", "%s (uid: %i) has used /givemoney to give $%i to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    return 1;
}


CMD:osetvip(playerid, params[])
{
    new username[MAX_PLAYER_NAME], level, time;

    if (!IsAdmin(playerid, ADMIN_LVL_10) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]iI(0)", username, level, time))
    {
        SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /osetvip [username] [level(0-3)] [days]");
        SendClientMessage(playerid, COLOR_GREY3, "List of ranks: (0) None (1) Silver (2) Gold (3) Legendary");
        return 1;
    }
    if (!(0 <= level <= 3))
    {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 3.");
    }
    if (!(1 <= time <= 365))
    {
            return SendClientMessage(playerid, COLOR_GREY, "The amount of days must range from 1 to 365.");
    }
    if (IsPlayerOnline(username))
    {
            return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /setvip instead.");
    }
    if (level == 0)
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's VIP package.", GetRPName(playerid), username);
        time = 0;
    }
    else if (time >= 30)
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {A028AD}%s{FF6347} VIP package to %s for %i months.", GetRPName(playerid), GetVIPRank(level), username, time / 30);
        time = gettime() + (time * 86400);
    }
    else
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {A028AD}%s{FF6347} VIP package to %s for %i days.", GetRPName(playerid), GetVIPRank(level), username, time);
        time = gettime() + (time * 86400);
    }
    DBQuery("UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE username = '%e'", level, time, username);

    return 1;
}

CMD:setvip(playerid, params[])
{
    //TODO: give vip drugs
    new targetid, rank, days, drugs = false, weed, cocaine, heroin, painkillers, seeds;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "uii", targetid, rank, days))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setvip [playerid] [rank] [days]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of ranks: (1) Silver (2) Gold (3) Legendary");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!(1 <= rank <= 3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
    }
    if (!(1 <= days <= 365))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount of days must range from 1 to 365.");
    }

    weed = GetPlayerCapacity(playerid, CAPACITY_WEED);
    cocaine = GetPlayerCapacity(playerid, CAPACITY_COCAINE);
    heroin = GetPlayerCapacity(playerid, CAPACITY_HEROIN);
    painkillers = GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS);
    seeds = GetPlayerCapacity(playerid, CAPACITY_SEEDS);

    if (drugs)
    {
        PlayerData[targetid][pWeed] = weed;
        PlayerData[targetid][pCocaine] = cocaine;
        PlayerData[targetid][pHeroin] = heroin;
        PlayerData[targetid][pPainkillers] = painkillers;
        PlayerData[targetid][pSeeds] = seeds;
        PlayerData[targetid][pBoombox] = 1;
        PlayerData[targetid][pMP3Player] = 1;
        SendClientMessageEx(targetid, COLOR_VIP, "%s %s has given you a full load of drugs with your %s VIP Package", GetAdminRank(playerid), GetRPName(playerid), GetVIPRank(rank));
    }

    GivePlayerVIP(targetid, rank, days);

    if (days >= 30)
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {D909D9}%s{FF6347} VIP package to %s for %i months.", GetRPName(playerid), GetVIPRank(rank), GetRPName(targetid), days / 30);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have given %s a {D909D9}%s{33CCFF} VIP package for %i months.", GetRPName(targetid), GetVIPRank(rank), days / 30);
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s has given you a {D909D9}%s{33CCFF} VIP package for %i months.", GetRPName(playerid), GetVIPRank(rank), days / 30);
    }
    else
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {D909D9}%s{FF6347} VIP package to %s for %i days.", GetRPName(playerid), GetVIPRank(rank), GetRPName(targetid), days);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have given %s a {D909D9}%s{33CCFF} VIP package for %i days.", GetRPName(targetid), GetVIPRank(rank), days);
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s has given you a {D909D9}%s{33CCFF} VIP package for %i days.", GetRPName(playerid), GetVIPRank(rank), days);
    }

    DBLog("log_vip", "%s (uid: %i) has given %s (uid: %i) a %s VIP package for %i days.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetVIPRank(rank), days);
    return 1;
}

CMD:removevip(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_9))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removevip [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!PlayerData[targetid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player doesn't have a VIP subscription which you can remove.");
    }



    DBLog("log_vip", "%s (uid: %i) has removed %s's (uid: %i) %s VIP package.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetVIPRank(PlayerData[targetid][pDonator]));

    PlayerData[targetid][pDonator] = 0;
    PlayerData[targetid][pVIPTime] = 0;
    PlayerData[targetid][pVIPColor] = 0;
    PlayerData[targetid][pSecondJob] = JOB_NONE;

    DBQuery("UPDATE "#TABLE_USERS" SET vippackage = 0, viptime = 0 WHERE uid = %i", PlayerData[targetid][pID]);


    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has revoked %s's VIP subscription.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has revoked your VIP subscription.", GetRPName(playerid));
    return 1;
}


CMD:forcepayday(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s", "confirm"))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcepayday [confirm] (gives everyone a paycheck)");
    }
    foreach(new i : Player)
    {
        SendPaycheck(i);
    }

    return 1;
}

CMD:setpassword(playerid, params[])
{
    new username[MAX_PLAYER_NAME], password[128];

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]s[128]", username, password))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setpassword [username] [new password]");
    }
    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. You can't change their password.");
    }

    DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminChangePassword", "iss", playerid, username, password);

    return 1;
}
CMD:setadmin(playerid, params[])
{
    return callcmd::makeadmin(playerid, params);
}

CMD:makeadmin(playerid, params[])
{
    new targetid, level;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pAdminPersonnel])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "ui", targetid, level))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /makeadmin [playerid] [level]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!(0 <= level <= 10))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 10.");
    }
    if (PlayerData[playerid][pAdminPersonnel] && !IsAdmin(playerid, level + 1))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Level cannot be higher than your admin level.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid) + 1))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be demoted.");
    }

    if (level <= 1 && PlayerData[targetid][pAdminDuty])
    {
        SetPlayerName(targetid, PlayerData[targetid][pUsername]);

        PlayerData[targetid][pAdminDuty] = 0;
    }

    PlayerData[targetid][pAdmin] = level;
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s (%i).", GetRPName(playerid), GetRPName(targetid), GetAdminRank(targetid), level);

    DBQuery("UPDATE "#TABLE_USERS" SET adminlevel = %i WHERE uid = %i", level, PlayerData[targetid][pID]);


    if (level == 0)
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's administrator powers.", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your administrator powers.", GetRPName(playerid));
        PlayerData[targetid][pDeveloper] = 0;
        PlayerData[targetid][pFactionMod] = 0;
        PlayerData[targetid][pWebDev] = 0;
        PlayerData[targetid][pBanAppealer] = 0;
        PlayerData[targetid][pGangMod] = 0;
        PlayerData[targetid][pHelperManager] = 0;
        PlayerData[targetid][pDynamicAdmin] = 0;
        PlayerData[targetid][pAdminPersonnel] = 0;
        DBQuery("UPDATE "#TABLE_USERS" SET removeddate = '%e', scripter = 0, gangmod = 0, banappealer = 0, factionmod = 0, webdev = 0, helpermanager = 0, dynamicadmin = 0, adminpersonnel = 0 WHERE uid = %i", GetDateTime(), PlayerData[targetid][pID]);

    }
    else
    {
        DBQuery("UPDATE "#TABLE_USERS" SET addeddate = '%e' WHERE uid = %i", GetDateTime(), PlayerData[playerid][pID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have set %s's admin level to {FF6347}%s{33CCFF} (%i).", GetRPName(targetid), GetAdminRank(targetid), level);
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has set your admin level to {FF6347}%s{33CCFF} (%i).", GetRPName(playerid), GetAdminRank(targetid), level);
    }

    DBLog("log_makeadmin", "%s (uid: %i) set %s's (uid: %i) admin level to %i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], level);
    return 1;
}


CMD:omakeadmin(playerid, params[])
{
    new username[MAX_PLAYER_NAME], level;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pAdminPersonnel])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]i", username, level))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /omakeadmin [username] [level]");
    }
    if (!(0 <= level <= 6))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 6.");
    }
    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /makeadmin instead.");
    }

    DBFormat("SELECT adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminSetAdminLevel", "isi", playerid, username, level);

    return 1;
}

CMD:sethelper(playerid, params[])
{
    return callcmd::makehelper(playerid, params);
}
CMD:makehelper(playerid, params[])
{
    new targetid, level;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && PlayerData[playerid][pHelper] < 7 && !PlayerData[playerid][pHelperManager])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "ui", targetid, level))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /makehelper [playerid] [level]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!(0 <= level <= 7))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 7.");
    }
    if ((!IsAdmin(playerid, ADMIN_LVL_8)) && PlayerData[targetid][pHelper] > PlayerData[playerid][pHelper] && level < PlayerData[targetid][pHelper])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher helper level than you. They cannot be demoted.");
    }

    if (level == 0)
    {

        if (PlayerData[targetid][pAcceptedHelp])
        {
            callcmd::return(targetid, "\1");
        }
    }

    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a level %i helper.", GetRPName(playerid), GetRPName(targetid), level);
    PlayerData[targetid][pHelper] = level;

    DBQuery("UPDATE "#TABLE_USERS" SET helperlevel = %i WHERE uid = %i", level, PlayerData[targetid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {00AA00}%s{33CCFF} (%i).", GetRPName(targetid), GetHelperRank(targetid), level);
    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {00AA00}%s{33CCFF} (%i).", GetRPName(playerid), GetHelperRank(targetid), level);

    DBLog("log_makehelper", "%s (uid: %i) set %s's (uid: %i) helper level to %i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], level);
    return 1;
}

CMD:omakehelper(playerid, params[])
{
    new username[MAX_PLAYER_NAME], level;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && PlayerData[playerid][pHelper] < 7 && !PlayerData[playerid][pHelperManager])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]i", username, level))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /omakehelper [username] [level]");
    }
    if (!(0 <= level <= 4))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid level. Valid levels range from 0 to 4.");
    }
    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /makehelper instead.");
    }

    DBFormat("SELECT helperlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminSetHelperLevel", "isi", playerid, username, level);

    return 1;
}


CMD:olisthelpers(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_8) && PlayerData[playerid][pHelper] < 3 && !PlayerData[playerid][pHelperManager])
    {
        return SendUnauthorized(playerid);
    }

    DBQueryWithCallback("SELECT username, lastlogin, helperlevel FROM "#TABLE_USERS" WHERE helperlevel > 0 ORDER BY lastlogin DESC", "ListHelpers", "i", playerid);
    return 1;
}

CMD:givegun(playerid, params[])
{
    new targetid, weaponid;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "ui", targetid, weaponid))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givegun [playerid] [weaponid]");
        SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
        SendClientMessage(playerid, COLOR_SYNTAX, "1: Brass Knuckles 2: Golf Club 3: Nite Stick 4: Knife 5: Baseball Bat 6: Shovel 7: Pool Cue 8: Katana 9: Chainsaw");
        SendClientMessage(playerid, COLOR_SYNTAX, "10: Purple Dildo 11: Small White Vibrator 12: Large White Vibrator 13: Silver Vibrator 14: Flowers 15: Cane 16: Frag Grenade");
        SendClientMessage(playerid, COLOR_SYNTAX, "17: Tear Gas 18: Molotov Cocktail 19: Vehicle Missile 20: Hydra Flare 21: Jetpack 22: 9mm 23: Silenced 9mm 24: Desert Eagle");
        SendClientMessage(playerid, COLOR_SYNTAX, "26: Sawnoff Shotgun 27: Combat Shotgun 28: Micro SMG (Mac 10) 29: SMG (MP5) 30: AK-47 31: M4 32: Tec9 33: Rifle");
        SendClientMessage(playerid, COLOR_SYNTAX, "25: Shotgun 34: Sniper Rifle 35: Rocket Launcher 36: HS Rocket Launcher 37: Flamethrower 38: Minigun 39: Satchel Charge");
        SendClientMessage(playerid, COLOR_SYNTAX, "40: Detonator 41: Spraycan 42: Fire Extinguisher 43: Camera 44: Nightvision Goggles 45: Infared Goggles 46: Parachute");
        SendClientMessage(playerid, COLOR_SYNTAX, "_______________________________________");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
    if (!(1 <= weaponid <= 46))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon.");
    }

    if (weaponid == 38 && !IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The minigun was disabled due to abuse.");
    }

    if (PlayerHasWeapon(targetid, weaponid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player already have this weapon.");
    }
    GivePlayerWeaponEx(targetid, weaponid);

    SendClientMessageEx(targetid, COLOR_AQUA, "You have received a {00AA00}%s{33CCFF} from %s.", GetWeaponNameEx(weaponid), GetRPName(playerid));
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a %s to %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));

    DBLog("log_givegun", "%s (uid: %i) gives a %s to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetWeaponNameEx(weaponid), GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    return 1;
}


CMD:settime(playerid, params[])
{
    new hour;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", hour))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settime [hour]");
    }
    if (!(0 <= hour <= 23))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The hour must range from 0 to 23.");
    }

    gWorldTime = hour;

    SetWorldTime(hour);
    SendClientMessageToAllEx(COLOR_GREY2, "Time of day changed to %i hours.", hour);
    return 1;
}

CMD:setstat(playerid, params[])
{
    new targetid, option[24], param[32], value;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[24]S()[32]", targetid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [option]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Gender, Age, Cash, Bank, Level, Respect, UpgradePoints, Hours, Warnings");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: SpawnHealth, SpawnArmor, FightStyle, Accent, Cookies, Phone, Crimes, Arrested");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: WantedLevel, Materials, Weed, Cocaine, Heroin, Painkillers, Cigars, PrivateRadio");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Channel, Spraycans, Boombox, Phonebook, Paycheck, CarLicense, GunLicense, Seeds, Chems");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: InventoryUpgrade, AddictUpgrade, TraderUpgrade, AssetUpgrade, LaborUpgrade");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Notoriety, MP3Player, Job, MuriaticAcid, BakingSoda, Watch, GPS, GasCan, Condom");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: DMWarnings, WeaponRestricted, FishingSkill, ArmsDealerSkill, FarmerSkill");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: MechanicSkill, LawyerSkill, DetectiveSkill, SmugglerSkill, DrugDealerSkill");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: ForkliftSkill, CarjackerSkill, PizzaSkill, TruckerSkill, HookerSkill, RobberySkill");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "List of options: Bombs, FirstAid, PoliceScanner, Bodykits, Diamonds, Marriage, Skates, RankPoints");
        return 1;
    }

    if (!strcmp(option, "rankpoints", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [rankpoints] [value]");
        }
        if (value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0.");
        }

        ResetPlayerRankPoints(targetid);
        GivePlayerRankPoints(targetid, value);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's rank points to %i.", GetRPName(targetid), value);
    }
    if (!strcmp(option, "gender", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gender] [male | female | shemale]");
        }
        if (!strcmp(param, "male", true))
        {
            PlayerData[targetid][pGender] = PlayerGender_Male;
        }
        else if (!strcmp(param, "female", true))
        {
            PlayerData[targetid][pGender] = PlayerGender_Female;
        }
        else if (!strcmp(param, "shemale", true))
        {
            PlayerData[targetid][pGender] = PlayerGender_Shemale;
        }
        DBQuery("UPDATE "#TABLE_USERS" SET gender = %i WHERE uid = %i", _:PlayerData[targetid][pGender], PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gender to %s.", GetRPName(targetid), GetPlayerGenderStr(targetid));
    }
    else if (!strcmp(option, "condom", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [condom] [value]");
        }
        if (!(0 <= value <= 128))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 128.");
        }
        PlayerData[playerid][pCondom] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET condom = %i WHERE uid = %i", PlayerData[playerid][pCondom], PlayerData[playerid][pID]);

        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's condom number to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "notoriety", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [notoriety] [value]");
        }
        if (!(0 <= value <= 20000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 20,000.");
        }
        PlayerData[playerid][pNotoriety] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET notoriety = %i WHERE uid = %i", PlayerData[playerid][pNotoriety], PlayerData[playerid][pID]);

        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's notoriety to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "age", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [age] [value]");
        }
        if (!(MIN_PLAYER_AGE <= value <= MAX_PLAYER_AGE))
        {
            return SendClientMessageEx(playerid, COLOR_GREY3, "The value specified can't be under %i or above %i.", MIN_PLAYER_AGE, MAX_PLAYER_AGE);
        }
        PlayerData[targetid][pAge] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET age = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's age to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "cash", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cash] [value]");
        }
        if (!(-50000000 <= value <= 50000000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under -$50,000,000 or above $50,000,000.");
        }

        PlayerData[targetid][pCash] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cash to $%i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET cash = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "bank", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bank] [value]");
        }
        if (!(-50000000 <= value <= 50000000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under -$50,000,000 or above $50,000,000.");
        }

        PlayerData[targetid][pBank] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's bank money to $%i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "level", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [level] [value]");
        }
        if (!(1 <= value <= 128))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 1 or above 128.");
        }

        PlayerData[targetid][pLevel] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's level to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET level = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "respect", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [respect] [value]");
        }
        if (!(0 <= value <= 2000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 2,000.");
        }

        PlayerData[targetid][pEXP] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's respect points to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET exp = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "upgradepoints", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [upgradepoints] [value]");
        }
        if (!(0 <= value <= 2000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 2,000.");
        }

        PlayerData[targetid][pUpgradePoints] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's upgrade points to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET upgradepoints = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "hours", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [hours] [value]");
        }
        if (!(0 <= value <= 2000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 2,000.");
        }

        PlayerData[targetid][pHours] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's playing hours to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET hours = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "warnings", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [warnings] [value]");
        }
        if (!(0 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 3.");
        }
        SetPlayerWarnings(targetid, value);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's warnings to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "spawnhealth", true))
    {
        new Float:amount;

        if (sscanf(param, "f", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [spawnhealth] [value]");
        }
        if (!(1 <= value <= 255))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 1 or above 255.");
        }

        PlayerData[targetid][pSpawnHealth] = amount;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's spawn health to %.1f.", GetRPName(targetid), amount);

        DBQuery("UPDATE "#TABLE_USERS" SET spawnhealth = '%f' WHERE uid = %i", amount, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "spawnarmor", true))
    {
        new Float:amount;

        if (sscanf(param, "f", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [spawnarmor] [value]");
        }
        if (!(1 <= value <= 255))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 1 or above 255.");
        }

        PlayerData[targetid][pSpawnArmor] = amount;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's spawn armor to %.1f.", GetRPName(targetid), amount);

        DBQuery("UPDATE "#TABLE_USERS" SET spawnarmor = '%f' WHERE uid = %i", amount, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "fightstyle", true))
    {
        if (isnull(param))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [fightstyle] [option]");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Normal, Boxing, Kungfu, Kneehead, Grabkick, Elbow");
            return 1;
        }
        if (!strcmp(param, "normal", true))
        {
            PlayerData[targetid][pFightStyle] = FIGHT_STYLE_NORMAL;

            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Normal.", GetRPName(targetid));
            SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

            DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);

        }
        else if (!strcmp(param, "boxing", true))
        {
            PlayerData[targetid][pFightStyle] = FIGHT_STYLE_BOXING;

            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Boxing.", GetRPName(targetid));
            SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

            DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);

        }
        else if (!strcmp(param, "kungfu", true))
        {
            PlayerData[targetid][pFightStyle] = FIGHT_STYLE_KUNGFU;

            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Kung Fu.", GetRPName(targetid));
            SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

            DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);

        }
        else if (!strcmp(param, "kneehead", true))
        {
            PlayerData[targetid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;

            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Kneehead.", GetRPName(targetid));
            SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

            DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);

        }
        else if (!strcmp(param, "grabkick", true))
        {
            PlayerData[targetid][pFightStyle] = FIGHT_STYLE_GRABKICK;

            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Grabkick.", GetRPName(targetid));
            SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

            DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);

        }
        else if (!strcmp(param, "elbow", true))
        {
            PlayerData[targetid][pFightStyle] = FIGHT_STYLE_ELBOW;

            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fight style to Elbow.", GetRPName(targetid));
            SetPlayerFightingStyle(targetid, PlayerData[targetid][pFightStyle]);

            DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[targetid][pFightStyle], PlayerData[targetid][pID]);

        }
    }
    else if (!strcmp(option, "accent", true))
    {
        new accent[16];

        if (sscanf(param, "s[16]", accent))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [accent] [text]");
        }

        strcpy(PlayerData[targetid][pAccent], accent, 16);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's accent to '%s'.", GetRPName(targetid), accent);

        DBQuery("UPDATE "#TABLE_USERS" SET accent = '%e' WHERE uid = %i", accent, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "cookies", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cookies] [value]");
        }
        if (!(0 <= value <= 10000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 10,000.");
        }
        SetPlayerCookies(playerid, value);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cookies to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "phone", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [phone] [number]");
        }
        if (IsSpecialNumber(value) && value != PhoneNumber_None)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
        }
        if (!(-999999999 <= value <= 999999999))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under -999,999,999 or above 999,999,999.");
        }

        if (value == 0)
        {
            PlayerData[targetid][pPhone] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's phone number to 0.", GetRPName(targetid));
            DBQuery("UPDATE "#TABLE_USERS" SET phone = 0 WHERE uid = %i", PlayerData[targetid][pID]);
        }
        else
        {
            DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE phone = %i", value);
            DBExecute("OnAdminSetPhoneNumber", "iii", playerid, targetid, value);
            return 1;
        }
    }
    else if (!strcmp(option, "crimes", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [crimes] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pCrimes] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET crimes = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's commited crimes to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "arrested", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [arrested] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pArrested] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET arrested = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's arrested count to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "wantedlevel", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [wantedlevel] [value]");
        }
        if (!(0 <= value <= 6))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 6.");
        }
        PlayerData[targetid][pWantedLevel] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's wanted level to %i.", GetRPName(targetid), value);

    }
    else if (!strcmp(option, "materials", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [materials] [value]");
        }
        if (!(0 <= value <= 50000000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 50,000,000.");
        }
        PlayerData[targetid][pMaterials] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's materials to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "weed", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [weed] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pWeed] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's weed to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "cocaine", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cocaine] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pCocaine] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cocaine to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "seeds", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [seeds] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pSeeds] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's seeds to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "chems", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [chems] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pChemicals] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's chems to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "heroin", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [heroin] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pHeroin] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's Heroin to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "painkillers", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [painkillers] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pPainkillers] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's painkillers to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "cigars", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [cigars] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pCigars] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's cigars to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "privateradio", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [privateradio] [0/1]");
        }
        PlayerData[targetid][pPrivateRadio] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET walkietalkie = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's private radio to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "channel", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [channel] [value]");
        }
        if (!(-10000000 <= value <= 10000000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under -10,000,000 or above 10,000,000.");
        }
        PlayerData[targetid][pChannel] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET channel = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        CallRemoteFunction("OnRadioFrequencyChanged", "ii", targetid, PlayerData[targetid][pChannel] );
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's radio channel to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "spraycans", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [spraycans] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pSpraycans] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's spraycans to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "boombox", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [boombox] [0/1]");
        }

        if ((value == 0) && PlayerData[targetid][pBoomboxPlaced])
        {
            DestroyBoombox(targetid);
        }

        PlayerData[targetid][pBoombox] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's boombox to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET boombox = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "phonebook", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [phonebook] [0/1]");
        }
        if (value)
        {
            GivePlayerPhonebook(playerid);
        }
        else
        {
            RemovePlayerPhonebook(playerid);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's phonebook to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "paycheck", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [paycheck] [value]");
        }
        if (!(0 <= value <= 10000000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above $10,000,000.");
        }
        PlayerData[targetid][pPaycheck] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's paycheck to $%i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET paycheck = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "carlicense", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [carlicense] [0/1]");
        }

        if (value)
        {
            GivePlayerLicense(targetid, PlayerLicense_Car);
        }
        else
        {
            RemovePlayerLicense(targetid, PlayerLicense_Car);
        }

        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's car license to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "gunlicense", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gunlicense] [0/1]");
        }

        if (value)
        {
            GivePlayerLicense(targetid, PlayerLicense_Gun);
        }
        else
        {
            RemovePlayerLicense(targetid, PlayerLicense_Gun);
        }

        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gun license to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "job", true))
    {
        if (sscanf(param, "i", value))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [job] [value (-1 = none)]");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (0) Pizzaman (1) Courier (2) Fisherman (3) Bodyguard (4) Arms Dealer (5) Mechanic (6) Miner");
            SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (7) Sweeper (8) Taxi Driver (9) Drug Dealer (10) Lawyer (11) Detective (12) Thief (13) Garbage Man (14) Farmer");
            return 1;
        }
        if (!(-1 <= value <= 14))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid job.");
        }

        PlayerData[targetid][pJob] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's job to %s.", GetRPName(targetid), GetJobName(value));

        DBQuery("UPDATE "#TABLE_USERS" SET job = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "inventoryupgrade", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [inventoryupgrade] [value]");
        }
        if (!(0 <= value <= 5))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 5.");
        }

        PlayerData[targetid][pInventoryUpgrade] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's inventory upgrade to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET inventoryupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "addictupgrade", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [addictupgrade] [value]");
        }
        if (!(0 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 3.");
        }

        PlayerData[targetid][pAddictUpgrade] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's addict upgrade to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET addictupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "traderupgrade", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [traderupgrade] [value]");
        }
        if (!(0 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 3.");
        }

        PlayerData[targetid][pTraderUpgrade] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's trader upgrade to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET traderupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "assetupgrade", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [assetupgrade] [value]");
        }
        if (!(0 <= value <= 4))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 4.");
        }

        PlayerData[targetid][pAssetUpgrade] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's asset upgrade to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET assetupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "laborupgrade", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [laborupgrade] [value]");
        }
        if (!(0 <= value <= 5))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 5.");
        }

        PlayerData[targetid][pLaborUpgrade] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's labor upgrade to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET laborupgrade = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "mp3player", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [mp3player] [0/1]");
        }

        PlayerData[targetid][pMP3Player] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's MP3 player to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET mp3player = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "muriaticacid", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [muriaticacid] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pMuriaticAcid] = value;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's muriatic acid to %i.", GetRPName(targetid), value);

        DBQuery("UPDATE "#TABLE_USERS" SET muriaticacid = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "bakingsoda", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bakingsoda] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pBakingSoda] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET bakingsoda = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's baking soda to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "dmwarnings", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [dmwarnings] [value]");
        }
        if (!(0 <= value <= 4))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The value must range from 0 to 4.");
        }
        PlayerData[targetid][pDMWarnings] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET dmwarnings = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's DM warnings to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "weaponrestricted", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [weaponrestricted] [hours]");
        }
        if (!(0 <= value <= 1000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 1,000.");
        }
        PlayerData[targetid][pWeaponRestricted] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET weaponrestricted = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's weapon restriction to %i hours.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "watch", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [watch] [0/1]");
        }
        PlayerData[targetid][pWatch] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET watch = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's watch to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "gps", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gps] [0/1]");
        }
        PlayerData[targetid][pGPS] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET gps = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's GPS to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "gascan", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [gascan] [value]");
        }
        if (!(0 <= value <= 1000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 1,000.");
        }
        PlayerData[targetid][pGasCan] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's gas can to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "smugglerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [smugglerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pSmugglerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET smugglerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's courier skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "fishingskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [fishingskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pFishingSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET fishingskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's fishing skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "armsdealerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [armsdealerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pWeaponSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET weaponskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's weapon skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "mechanicskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [mechanicskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pMechanicSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET mechanicskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's mechanic skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "lawyerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [lawyerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pLawyerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET lawyerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's lawyer skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "detectiveskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [detectiveskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pDetectiveSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET detectiveskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's detective skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "drugdealerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [drugdealerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pDrugDealerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET drugdealerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's drugdealer skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "farmerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [farmerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pFarmerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET farmerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's farmer skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "forkliftskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [forkliftskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pForkliftSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET forkliftskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's forklift skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "carjackerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [carjackerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pCarJackerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET carjackerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's car jacker skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "craftskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [craftskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pCraftSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET craftskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's craft skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "pizzaskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [pizzaskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pPizzaSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET pizzaskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's pizza skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "truckerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [truckerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pTruckerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET truckerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's trucker skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "hookerskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [hookerskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pHookerSkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET hookerskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's hooker skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "robberyskill", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [robberyskill] [value]");
        }
        if (!(0 <= value <= 100000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 100,000.");
        }
        PlayerData[targetid][pRobberySkill] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET robberyskill = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's robbery skill to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "bombs", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bombs] [value]");
        }
        if (!(0 <= value <= 1000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 1,000.");
        }
        PlayerData[targetid][pBombs] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's bombs to %i.", GetRPName(targetid), value);

    }
    else if (!strcmp(option, "firstaid", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [firstaid] [value]");
        }
        if (!(0 <= value <= 1000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 1,000.");
        }
        PlayerData[targetid][pFirstAid] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's first aid kits to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "policescanner", true))
    {
        if (sscanf(param, "i", value) || !(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [policescanner] [0/1]");
        }
        PlayerData[targetid][pPoliceScanner] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET policescanner = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's police scanner to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "bodykits", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [bodykits] [value]");
        }
        if (!(0 <= value <= 1000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 1,000.");
        }
        PlayerData[targetid][pBodykits] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's bodykits to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "diamonds", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [diamonds] [value]");
        }
        if (!(0 <= value <= 10000))
        {
            return SendClientMessage(playerid, COLOR_GREY3, "The value specified can't be under 0 or above 10,000.");
        }
        PlayerData[targetid][pDiamonds] = value;
        DBQuery("UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", value, PlayerData[targetid][pID]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's diamonds to %i.", GetRPName(targetid), value);
    }
    else if (!strcmp(option, "marriage", true))
    {
        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [marriedto] [playerid(-1 to reset)]");
        }

        if (IsPlayerConnected(value))
        {
            PlayerData[targetid][pMarriedTo] = PlayerData[value][pID];
            strcpy(PlayerData[targetid][pMarriedName], GetPlayerNameEx(value), MAX_PLAYER_NAME);
            DBQuery("UPDATE "#TABLE_USERS" SET marriedto = %i WHERE uid = %i", PlayerData[value][pID], PlayerData[targetid][pID]);
            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's marriage to %s.", GetRPName(targetid), GetRPName(value));
        }
        else if (value == -1)
        {
            PlayerData[targetid][pMarriedTo] = -1;
            strcpy(PlayerData[targetid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
            DBQuery("UPDATE "#TABLE_USERS" SET marriedto = -1 WHERE uid = %i",  PlayerData[targetid][pID]);
            SendClientMessageEx(playerid, COLOR_WHITE, "You have reset %s's marriage.", GetRPName(targetid));
        }
    }
    else if (!strcmp(option, "skates", true))
    {
        if (sscanf(param, "i", value) || !(0<=value<=1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstat [playerid] [skates] [1/0]");
        }
        else
        {
            PlayerData[targetid][pSkates] = value;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's skates to %i.", GetRPName(targetid), value);

            DBQuery("UPDATE "#TABLE_USERS" SET rollerskates = %i WHERE uid = %i", value, PlayerData[targetid][pID]);

        }
    }
    else
    {
        return 1;
    }

    DBLog("log_setstat", "%s (uid: %i) set %s's (uid: %i) %s to %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], option, param);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s set %s's %s to %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), option, param);
    return 1;
}

CMD:deleteaccount(playerid, params[])
{
    new username[MAX_PLAYER_NAME];

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deleteaccount [username]");
    }
    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. You can't delete their account.");
    }

    DBFormat("SELECT adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminDeleteAccount", "is", playerid, username);

    return 1;
}

CMD:previewint(playerid, params[])
{
    new type, string[32];

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", type))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /previewint [1-%i]", sizeof(houseInteriors));
    }
    if (!(1 <= type <= sizeof(houseInteriors)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
    }

    type--;

    format(string, sizeof(string), "~w~%s", houseInteriors[type][intClass]);
    GameTextForPlayer(playerid, string, 5000, 1);

    SetPlayerPos(playerid, houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ]);
    SetPlayerFacingAngle(playerid, houseInteriors[type][intA]);
    SetPlayerInterior(playerid, houseInteriors[type][intID]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:nearest(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Nearest Items _______");

    if ((id = GetNearbyHouse(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of house ID %i.", id);
    }
    if ((id = GetNearbyGarage(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of garage ID %i.", id);
    }
    if ((id = GetNearbyBusiness(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of business ID %i.", id);
    }
    if ((id = GetNearbyEntrance(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of entrance ID %i.", id);
    }
    if ((id = GetNearbyLand(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of land ID %i.", id);
    }
    if ((id = GetNearbyTurf(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of turf ID %i.", id);
    }
    if ((id = GetNearbyLocker(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of locker ID %i.", id);
    }
    if ((id = GetNearbyLocation(playerid, 20.0)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of (location) %s [%i].", GetLocationName(id), id);
    }
    if ((id = GetNearbyAtm(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of atm ID %i", id);
    }
    if ((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of vehicle ID %i", id);
    }
    if ((id = GetNearbyGate(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of dynamic gate ID %i", id);
    }
    if ((id = GetNearbyImpound(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are in range of impound ID %i", id);
    }
    if ((id = GetInsideEntrance(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are inside of entrance ID %i", id);
    }
    if ((id = GetNearbyGraffiti(playerid)) >= 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "You are near of graffiti ID %i", id);
    }

    return 1;
}

CMD:dynamichelp(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    else if (isnull(params))
    {
        SendSyntaxMessage(playerid, "/dynamichelp (type)");
        SendClientMessage(playerid, COLOR_GREY, "Types: house, businesses, entrances, atms, lands, factions, gangs");
        SendClientMessage(playerid, COLOR_GREY, "Types: locations, points, turfs, fires, lockers, payphones, gangtags");
        return 1;
    }
    else if (!strcmp(params, "house", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "HOUSES:{DDDDDD} /createhouse, /edithouse, /removehouse, /gotohouse, /asellhouse, /removefurnitures.");
    }
    else if (!strcmp(params, "garages", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "GARAGES:{DDDDDD} /creategarage, /editgarage, /removegarage, /gotogarage, /asellgarage.");
    }
    else if (!strcmp(params, "businesses", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "BUSINESSES:{DDDDDD} /createbiz, /editbiz, /removebiz, /gotobiz, /asellbiz.");
    }
    else if (!strcmp(params, "entrances", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "ENTRANCES:{DDDDDD} /createentrance, /editentrance, /removeentrance, /gotoentrance.");
    }
    else if (!strcmp(params, "lands", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "LANDS:{DDDDDD} /createland, /removeland, /gotoland, /asellland, /removelandobjects.");
    }
    else if (!strcmp(params, "factions", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "FACTIONS:{DDDDDD} /createfaction, /editfaction, /removefaction, /switchfaction, /purgefaction.");
    }
    else if (!strcmp(params, "gangs", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "GANGS:{DDDDDD} /creategang, /editgang, /removegang, /gangstrike, /switchgang, /turfscaplimit, /setcooldown.");
        SendClientMessage(playerid, COLOR_GREEN, "GANGS:{DDDDDD} /purgegang, /createganghq, /removeganghq.");
    }
    else if (!strcmp(params, "points", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "POINTS:{DDDDDD} /createpoint, /editpoint, /removepoint, /gotopoint.");
    }
    else if (!strcmp(params, "turfs", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "TURFS:{DDDDDD} /createturf, /editturf, /removeturf, /gototurf.");
    }
    else if (!strcmp(params, "fires", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "FIRES:{DDDDDD} /randomfire, /killfire, /spawnfire.");
    }
    else if (!strcmp(params, "lockers", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "LOCKERS:{DDDDDD} /createlocker, /editlocker, /removelocker.");
    }
    else if (!strcmp(params, "locations", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "LOCATIONS:{DDDDDD} /createlocation, /editlocation, /removelocation.");
    }
    else if (!strcmp(params, "atms", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "ATMS:{DDDDDD} /createatm, /gotoatm, /editatm, /deleteatm.");
    }
    else if (!strcmp(params, "gangtags", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "Gang Tags:{DDDDDD} /creategangtag, /destroygangtag");
    }
    else if (!strcmp(params, "payphones", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "Payphones:{FFFFFF} /addpayphone, /gotopayphone, /editpayphone, /deletepayphone.");
    }
    return 1;
}


CMD:healnear(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_3))
    {
        if (!IsAdminOnDuty(playerid))
        {
            return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
        }

        new count;
        foreach(new i : Player)
        {
            if (IsPlayerNearPlayer(playerid, i, 12.0))
            {
                SetPlayerHealth(i, 100);
                SetScriptArmour(i, 100);
                count++;
            }
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "You have healed everyone (%d) nearby.", count);
    }
    return 1;
}

CMD:userid(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    new userid;
    if (sscanf(params, "i", userid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /userid [userid]");
    }
    DBFormat("SELECT username from "#TABLE_USERS" where uid=%i", userid);
    DBExecute("SearchUsernameByUserID", "i", playerid);
    return 1;
}

DB:SearchUsernameByUserID(playerid)
{
    if (GetDBNumRows() == 0)
    {
        SendClientMessageEx(playerid, COLOR_SYNTAX, "There is no player with this name.");
    }
    else
    {
        new username[MAX_PLAYER_NAME];
        GetDBStringField(0, "username", username);
        SendClientMessageEx(playerid, COLOR_SYNTAX, "The current username is %s.", username);
    }
    return 1;
}

CMD:serialnumber(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_2))
    {
        return 0;
    }
    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /serialnumber [targetid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
    }
    new serialnumber[32];
    serialnumber = GetPlayerSerialNumber(targetid);

    if (isnull(serialnumber))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Cannot get serial number.");
    }

    SendClientMessageEx(playerid, COLOR_ORANGE, "The serial number of %s is '%s'", GetPlayerNameEx(targetid), serialnumber);
    return 1;
}

GetPlayerSerialNumber(playerid)
{
    new serialnumber[32];
    serialnumber = FormatSerialNumber(PlayerData[playerid][pID], PlayerData[playerid][pRegDate]);
    return serialnumber;
}

FormatSerialNumber(uid, const regDate[])
{
    new serialnumber[32];
    if (strlen(regDate) > 18)
    {
        serialnumber[0] = regDate[0];
        serialnumber[1] = regDate[1];
        serialnumber[2] = regDate[2];
        serialnumber[3] = regDate[3];
        serialnumber[4] = regDate[5];
        serialnumber[5] = regDate[6];
        serialnumber[6] = regDate[8];
        serialnumber[7] = regDate[9];
        serialnumber[8] = regDate[11];
        serialnumber[9] = regDate[12];
        serialnumber[10] = regDate[14];
        serialnumber[11] = regDate[15];
        serialnumber[12] = regDate[17];
        serialnumber[13] = regDate[18];
        serialnumber[14] = 'X';
        serialnumber[15] = 0;
        format(serialnumber, sizeof(serialnumber), "%s%09d", serialnumber, uid);
    }
    else
    {
        serialnumber[0] = 0;
    }
    return serialnumber;
}

IsSpecialNumber(number)
{
    switch (number)
    {
        case PhoneNumber_None      : return true;
        case PhoneNumber_Emergency : return true;
        case PhoneNumber_Police    : return true;
        case PhoneNumber_Medic     : return true;
        case PhoneNumber_Taxi      : return true;
        case PhoneNumber_News      : return true;
        case PhoneNumber_Mechanic  : return true;
    }
    return false;
}

CMD:tip(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_8))
    {
        if (isnull(params))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /tip [message]");
        }
        SendClientMessageToAllEx(COLOR_GREEN, "TIP: {ffffff}%s", params);
    }
    return 1;
}

CMD:selldynamicsmanagement(playerid, params[])
{

    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendUnauthorized(playerid);
    }
    return  SendClientMessage(playerid, COLOR_GREY, "This command was disabled.");

    //new houses, garages, businesses;
    //for (new i = 0; i < MAX_HOUSES; i ++)
    //{
    //    if (HouseInfo[i][hExists])
    //    {
    //        SetHouseOwner(i, INVALID_PLAYER_ID);
    //        houses++;
    //    }
    //}
    //
    //for (new i = 0; i < MAX_GARAGES; i ++)
    //{
    //    if (GarageInfo[i][gExists])
    //    {
    //        SetGarageOwner(i, INVALID_PLAYER_ID);
    //        garages++;
    //    }
    //}
    //
    //for (new i = 0; i < MAX_BUSINESSES; i ++)
    //{
    //    if (BusinessInfo[i][bExists])
    //    {
    //        SetBusinessOwner(i, INVALID_PLAYER_ID);
    //        businesses++;
    //    }
    //}
    //
    //SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has sold all properties.", GetRPName(playerid));
    //SendClientMessageEx(playerid, COLOR_WHITE, "* You have sell %i houses, %i garages and %i businesses.", houses, garages, businesses);
    //return 1;
}



CMD:norevive(playerid, params[])
{
    return callcmd::nor(playerid, params);
}

CMD:revive(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /revive [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!RevivePlayer(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not injured.");
    }

    SendClientMessage(targetid, COLOR_YELLOW, "You have been revived by an admin!");

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has revived %s.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:bigears(playerid, params[])
{
    return callcmd::listen(playerid, params);
}

CMD:listen(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    if (!PlayerData[playerid][pListen])
    {
        PlayerData[playerid][pListen] = 1;
        SendClientMessage(playerid, COLOR_AQUA, "You are now listening to all IC & local OOC chats.");
    }
    else
    {
        PlayerData[playerid][pListen] = 0;
        SendClientMessage(playerid, COLOR_AQUA, "You are no longer listening to IC & local OOC chats.");
    }

    return 1;
}

CMD:sjail(playerid, params[])
{
    new targetid, minutes, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }

    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[128]", targetid, minutes, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sjail [playerid] [minutes] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be jailed.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (minutes < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes specified cannot be below zero.");
    }
    SetPlayerInJail(targetid, JailType_OOCJail, minutes * 60, reason, GetPlayerNameEx(playerid));

    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
        "JAIL", "%s was silently jailed by %s %s. Prison: %i minutes. Reason: %s",
        GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid), minutes, reason);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was jailed for %i minutes by an Admin, reason: %s", GetRPName(targetid), minutes, reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been jailed for %i minutes by an admin.", minutes);
    return 1;
}

CMD:pinfo(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pinfo [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    SendClientMessageEx(playerid, COLOR_GREY1, "(ID: %i) - (Name: %s) - (Ping: %i) - (FPS: %i) - (Packet Loss: %.1f%c)", targetid, GetRPName(targetid), GetPlayerPing(targetid), PlayerData[targetid][pFPS], NetStats_PacketLossPercent(targetid), '%');
    return 1;
}

CMD:admins(playerid, params[])
{
    if (!IsAdmin(playerid) && !PlayerData[playerid][pDeveloper])
    {
        return SendUnauthorized(playerid);
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_________ Admins Online _________");

    foreach(new i : Player)
    {
        if (IsAdmin(i) && !PlayerData[i][pUndercover][0] || IsAdmin(playerid, ADMIN_LVL_8) && PlayerData[i][pUndercover][0])
        {
            new division[5];
            strcpy(division, GetAdminDivision(i));
            if (strlen(division) < 1) division = "None";
            if (!strcmp(PlayerData[i][pAdminName], "None", true))
                SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s - Division: %s - Status: %s{C8C8C8} - Reports Handled: %i - Tabbed: %s", i, GetAdminRank(i), PlayerData[i][pUsername], division, (PlayerData[i][pAdminDuty]) ? ("{00AA00}On Duty") : ("Off Duty"), PlayerData[i][pReports], (IsPlayerAFK(i)) ? ("Yes") : ("No"));
            else
                SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s (%s) - Division: %s - Status: %s{C8C8C8} - Reports Handled: %i - Tabbed: %s", i, GetAdminRank(i), PlayerData[i][pUsername], PlayerData[i][pAdminName], division, (PlayerData[i][pAdminDuty]) ? ("{00AA00}On Duty") : ("Off Duty"), PlayerData[i][pReports], (IsPlayerAFK(i)) ? ("Yes") : ("No"));
        }
    }
    return 1;
}

CMD:ocheck(playerid, params[])
{
    new name[24];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ocheck [username]");
    }

    DBFormat("SELECT * FROM "#TABLE_USERS" WHERE username = '%e'", name);
    DBExecute("OnAdminOfflineCheck", "is", playerid, name);
    return 1;
}

CMD:hhcheck(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hhcheck [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (PlayerData[targetid][pHHCheck])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already being checked for health hacks.");
    }
    if (IsPlayerPaused(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't initiate this check on a tabbed player.");
    }

    GetPlayerHealth(targetid, PlayerData[targetid][pHealth]);

    PlayerData[targetid][pHHCheck] = 1;
    PlayerData[targetid][pHHTime] = 5;
    PlayerData[targetid][pHHRounded] = GetPlayerHealthEx(targetid);
    PlayerData[targetid][pHHCount] = 0;

    SetPlayerHealth(targetid, random(100) + 1);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has started the health hack check on %s.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:forcedeleteobject(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_8) || PlayerData[playerid][pDeveloper])
    {
        new mode[32];
        if (sscanf(params, "s[32]", mode))
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcedeleteobject [enable/disable]");
        if (!strcmp(mode, "enable", true))
        {
            PlayerData[playerid][pDeleteMode] = 1;
        }
        else if (!strcmp(mode, "disable", true))
        {
            PlayerData[playerid][pDeleteMode] = 0;
        }
        else
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcedeleteobject [enable/disable]");
        }
        SendClientMessageEx(playerid, COLOR_GREY, "Object deletetion mode was %sd (%i)", mode, PlayerData[playerid][pDeleteMode]);
    }
    return 1;
}

CMD:godshand(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_10))
    {
        new targetid;

        if (sscanf(params, "u", targetid))
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /godshand [playerid]");

        if (PlayerData[playerid][pGodshand] == 1)
        {
            SendClientMessage(playerid, COLOR_GREY, "Aww, that's sad as fuck.");
            PlayerData[targetid][pGodshand] = 0;
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "Granted it is.");
            PlayerData[targetid][pGodshand] = 1;
        }
        return 1;
    }
    return -1;
}

CMD:choke(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_6))
    {
        new targetid;
        if (sscanf(params, "u", targetid)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /choke [playerid] ");
        ApplyAnimation(targetid,"ped","gas_cwr",4.1,1,1,1,0,0,0);

        if (!IsAdmin(playerid, GetAdminLvl(targetid) + 1))
            return SendClientMessageEx(playerid, COLOR_GREY, "You cannot choke higher level administrators.");

        SendProximityMessage(targetid, 30.0, COLOR_PURPLE, "* %s bends over as he chokes by god's hand.", GetRPName(targetid));
    }
    else SendClientMessageEx(playerid, COLOR_GREY, "Your not authorized to use that command!");
    return 1;
}

CMD:kick(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /kick [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be kicked.");
    }

    KickPlayer(targetid,  reason, playerid);
    return 1;
}

CMD:skick(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skick [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be kicked.");
    }

    KickPlayer(targetid,  reason, playerid, BAN_VISIBILITY_ADMIN);
    return 1;
}

CMD:ban(playerid, params[])
{
    new targetid, duration, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
    if (sscanf(params, "uds[128]", targetid, duration, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ban [playerid] [duration in days] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (duration <= 0 || duration >= 365 * 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid duration value.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't ban yourself.");
    }

    BanPlayer(targetid, reason, playerid, BAN_VISIBILITY_ALL, duration);
    return 1;
}

CMD:sban(playerid, params[])
{
    new targetid, duration, reason[128];

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "uds[128]", targetid, duration, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sban [playerid] [duration in days] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
    }

    if (duration <= 0 || duration >= 365 * 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid duration value.");
    }
    BanPlayer(targetid, reason, playerid, BAN_VISIBILITY_ADMIN, duration);
    return 1;
}

CMD:dm(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dm [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be punished.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
    }

    PlayerData[targetid][pDMWarnings]++;

    if (PlayerData[targetid][pDMWarnings] < 3)
    {
        new minutes = PlayerData[targetid][pDMWarnings] * 60;
        PlayerData[targetid][pWeaponRestricted] = PlayerData[targetid][pDMWarnings] * 6;
        SetPlayerInJail(targetid, JailType_OOCPrison, minutes * 60, "DM", GetPlayerNameEx(playerid));

        LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
            "DM", "%s was DM warned by %s %s. Prison: %i minutes. Weapon restriction: %i hours. DM (%i/3)",
            GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid),
            minutes, PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pDMWarnings]);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was DM Warned & Prisoned for %i minutes by %s, reason: DM (%i/3)",
            GetRPName(targetid), minutes, GetRPName(playerid), PlayerData[targetid][pDMWarnings]);
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been admin prisoned for %i minutes, reason: DM.", minutes);
        SendClientMessageEx(targetid, COLOR_WHITE, "Your punishment is %i hours of weapon restriction and %i/3 DM warning.",
            PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pDMWarnings]);
    }
    else
    {
        LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
            "DM", "%s was DM warned by %s %s. DM (3/3)",
            GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid));

        PlayerData[targetid][pDMWarnings] = 0;
        BanPlayer(targetid, "DM (3/3 warnings)");
    }

    DBQuery("UPDATE "#TABLE_USERS" SET dmwarnings = %i, weaponrestricted = %i WHERE uid = %i",
        PlayerData[targetid][pDMWarnings], PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pID]);
    return 1;
}

CMD:sdm(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sdm [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be punished.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
    }

    PlayerData[targetid][pDMWarnings]++;

    if (PlayerData[targetid][pDMWarnings] < 6)
    {
        new minutes = PlayerData[targetid][pDMWarnings] * 60;
        PlayerData[targetid][pWeaponRestricted] = PlayerData[targetid][pDMWarnings] * 12;

        SetPlayerInJail(targetid, JailType_OOCPrison, minutes * 120, "DM", GetPlayerNameEx(playerid));

        LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
            "DM", "%s was silently DM warned by %s %s. Prison: %i minutes. Weapon restriction: %i hours. DM (%i/3)",
            GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid),
            minutes, PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pDMWarnings]);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was DM Warned & Prisoned for %i minutes by an Admin, reason: DM (%i/3)",
            GetRPName(targetid), minutes, PlayerData[targetid][pDMWarnings]);
        SendClientMessageEx(targetid, COLOR_WHITE, "You have been admin prisoned for %i minutes, reason: DM.", minutes);
        SendClientMessageEx(targetid, COLOR_WHITE, "Your punishment is %i hours of weapon restriction and %i/3 DM warning.",
            PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pDMWarnings]);
    }
    else
    {
        LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
            "DM", "%s was silently DM warned by %s %s. DM (3/3)",
            GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid));
        PlayerData[targetid][pDMWarnings] = 0;
        BanPlayer(targetid, "DM (3/3 warnings)", playerid, BAN_VISIBILITY_ADMIN);
    }
    DBQuery("UPDATE "#TABLE_USERS" SET dmwarnings = %i, weaponrestricted = %i WHERE uid = %i",
        PlayerData[targetid][pDMWarnings], PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pID]);
    return 1;
}

CMD:odm(playerid, params[])
{
    new name[MAX_PLAYER_NAME];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /odm [username]");
    }
    if (IsPlayerOnline(name))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /dm instead.");
    }

    DBFormat("SELECT uid, ip, adminlevel, dmwarnings FROM "#TABLE_USERS" WHERE username = '%e'", name);
    DBExecute("OnAdminOfflineDM", "is", playerid, name);
    return 1;
}

CMD:prison(playerid, params[])
{
    new targetid, minutes, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[128]", targetid, minutes, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /prison [playerid] [minutes] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be prisoned.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
    }
    if (minutes < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
    }
    SetPlayerInJail(targetid, JailType_OOCPrison, minutes * 60, reason, GetPlayerNameEx(playerid));

    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
        "PRISON", "%s was prisoned by %s %s for %i minutes. Reason: %s",
        GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid), minutes, reason);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for %i minutes by %s, reason: %s", GetRPName(targetid), minutes, GetRPName(playerid), reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been admin prisoned for %i minutes by %s.", minutes, GetRPName(playerid));
    return 1;
}

CMD:sprison(playerid, params[])
{
    new targetid, minutes, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[128]", targetid, minutes, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sprison [playerid] [minutes] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be prisoned.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
    }
    if (minutes < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
    }
    SetPlayerInJail(targetid, JailType_OOCPrison, minutes * 60, reason, GetPlayerNameEx(playerid));

    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
        "PRISON", "%s was silently prisoned by %s %s for %i minutes. Reason: %s",
        GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid), minutes, reason);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for %i minutes by an Admin, reason: %s",
        GetRPName(targetid), minutes, reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been admin prisoned for %i minutes by an admin.", minutes);
    return 1;
}

CMD:oprison(playerid, params[])
{
    new username[MAX_PLAYERS], minutes, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]is[128]", username, minutes, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /oprison [username] [minutes] [reason]");
    }
    if (minutes < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
    }
    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /prison instead.");
    }

    DBFormat("SELECT adminlevel, uid, ip FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminOfflinePrison", "isis", playerid, username, minutes, reason);
    return 1;
}

CMD:fine(playerid, params[])
{
    new targetid, amount, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[128]", targetid, amount, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fine [playerid] [amount] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be fined.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid amount.");
    }

    GivePlayerCash(targetid, -amount);

    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was fined %s by %s, reason: %s", GetRPName(targetid), FormatCash(amount), GetRPName(playerid), reason);
    DBLog("log_admin", "%s (uid: %i) fined %s (uid: %i) for $%i, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], amount, reason);
    return 1;
}

CMD:pfine(playerid, params[])
{
    new targetid, percent, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[128]", targetid, percent, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pfine [playerid] [percent] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!(1 <= percent <= 100))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The percentage value must be between 1 and 100.");
    }

    new amount = ((PlayerData[targetid][pCash] + PlayerData[targetid][pBank]) / 100) * percent;

    GivePlayerCash(targetid, -amount);

    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was fined %s by %s, reason: %s", GetRPName(targetid), FormatCash(amount), GetRPName(playerid), reason);
    DBLog("log_admin", "%s (uid: %i) fined %s (uid: %i) for $%i (%i percent), reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], amount, percent, reason);
    return 1;
}

CMD:ofine(playerid, params[])
{
    new username[MAX_PLAYERS], amount, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]is[128]", username, amount, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ofine [username] [amount] [reason]");
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid amount.");
    }
    if (IsPlayerOnline(username))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /fine instead.");
    }

    DBFormat("SELECT adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminOfflineFine", "isis", playerid, username, amount, reason);
    return 1;
}

ClearDeathList(playerid)
{
    for (new i = 0; i < 5; i ++)
    {
        SendDeathMessageToPlayer(playerid, 1001, 1001, 255);
    }
    return 1;
}

CMD:cleardm(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_8) || PlayerData[playerid][pAdminDuty])
    {
        ClearDeathList(playerid);
        SendClientMessage(playerid, COLOR_WHITE, "Death messages cleared.");
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You are either not authorized to use this command or not on admin duty.");
    }

    return 1;
}
CMD:aduty(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!PlayerData[playerid][pAdminDuty])
    {
        if (PlayerData[playerid][pUndercover][0])
        {
            calldb::OnUndercover(playerid, 0, "", 0, 0.0, 0.0);
        }
        SavePlayerVariables(playerid);
        ResetPlayerWeapons(playerid);

        SetPlayerHealth(playerid, 32767);
        SetScriptArmour(playerid, 0.0);

        SetPlayerSkin(playerid, ADMIN_SKIN);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s is now on admin duty.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_WHITE, "You are now on admin duty. Your stats will not be saved until you're off duty.");

        PlayerData[playerid][pAdminDuty] = 1;
        PlayerData[playerid][pTogglePhone] = 1;
        if (strcmp(PlayerData[playerid][pAdminName], "None", true) != 0)
        {
            SetPlayerName(playerid, PlayerData[playerid][pAdminName]);
        }
    }
    else
    {
        new savecheck = 0;

        if (PlayerData[playerid][pPaycheck] > 1)
        {
            savecheck = PlayerData[playerid][pPaycheck];
        }
        if (PlayerData[playerid][pNoDamage])
        {
            PlayerData[playerid][pNoDamage] = 0;
            SendClientMessage(playerid, COLOR_GREY, "Your god mode was turned off.");
        }

        ClearDeathList(playerid);
        DBFormat("SELECT * FROM "#TABLE_USERS" WHERE uid = %i", PlayerData[playerid][pID]);
        DBExecute("ProcessLogin", "i", playerid);
        PlayerData[playerid][pPaycheck] = savecheck;
    }

    return 1;
}

CMD:jail(playerid, params[])
{
    new targetid, minutes, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[128]", targetid, minutes, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /jail [playerid] [minutes] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be jailed.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /ojail.");
    }
    if (minutes < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
    }

    SetPlayerInJail(targetid, JailType_OOCJail, minutes * 60, reason, GetPlayerNameEx(playerid));

    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
        "JAIL", "%s was jailed by %s %s. Prison: %i minutes. Reason: %s",
        GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid), minutes, reason);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was jailed for %i minutes by %s, reason: %s",
        GetRPName(targetid), minutes, GetRPName(playerid), reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been admin jailed for %i minutes by %s.",
        minutes, GetRPName(playerid));
    return 1;
}

CMD:check(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /check [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }

    DisplayStats(targetid, playerid);
    return 1;
}

CMD:checkinventory(playerid, params[])
{
    return callcmd::checkinv(playerid, params);
}

CMD:checkinv(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checkinv [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }

    DisplayInventory(targetid, playerid);
    return 1;
}

CMD:slap(playerid, params[])
{
    new targetid, Float:height;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uF(5.0)", targetid, height))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /slap [playerid] [height (optional)]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsPlayerLoggedIn(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not spawned and therefore cannot be slapped.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be slapped.");
    }
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(targetid, x, y, z + height);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was slapped by %s %s.", GetRPName(targetid), GetAdmCmdRank(playerid), GetRPName(playerid));
    PlayerPlaySound(targetid, 1130, 0.0, 0.0, 0.0);

    return 1;
}


CMD:restrictweapon(playerid, params[])
{
    new targetid, hours, reason[48];
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uis[48]", targetid, hours, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /restrictweapon [playerid] [hours] [reason]");
    }
    if (!IsPlayerConnected(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (hours < 1 || hours > 24)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid hours max 24h.");
    }
    if (strlen(reason) < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid reason.");
    }
    PlayerData[targetid][pWeaponRestricted] = hours;

    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
        "WR", "%s was weapon restricted by %s %s for %i hours. Reason: %s",
        GetPlayerNameEx(targetid), GetAdminRank(playerid), GetPlayerNameEx(playerid),
        PlayerData[targetid][pWeaponRestricted], reason);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was weapon restricted for %i hours by %s. Reason: %s",
        GetRPName(targetid), PlayerData[targetid][pWeaponRestricted], GetRPName(playerid), reason);
    SendClientMessageEx(targetid, COLOR_WHITE, "Your punishment is %i hours of weapon restriction. Reason: %s",
        PlayerData[targetid][pWeaponRestricted], reason);
    return 1;
}

CMD:setadminname(playerid, params[])
{
    new name[MAX_PLAYER_NAME], targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && ! PlayerData[playerid][pAdminPersonnel])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "ds[24]", targetid, name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setadminname [targetid] [name]");
    }
    if (!strcmp(name, "rex", true))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot set this name");
    }
    if (!IsValidAdminName(name))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The name specified is not supported by the SA-MP client.");
    }

    strcpy(PlayerData[targetid][pAdminName], name, MAX_PLAYER_NAME);

    if (PlayerData[targetid][pAdminDuty])
    {
        SetPlayerName(targetid, name);
    }

    DBQuery("UPDATE "#TABLE_USERS" SET adminname = '%e' WHERE uid = %i", name, PlayerData[targetid][pID]);


    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s changed %s's administrator name to %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), name);
    return 1;
}

CMD:lastactive(playerid, params[])
{
    new username[24], specifiers[] = "%D of %M, %Y @ %k:%i";

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lastactive [username]");
    }

    DBFormat("SELECT DATE_FORMAT(lastlogin, '%e') FROM "#TABLE_USERS" WHERE username = '%e'", specifiers, username);
    DBExecute("OnAdminCheckLastActive", "is", playerid, username);

    return 1;
}

CMD:listjailed(playerid, params[])
{
    return callcmd::prisoners(playerid, params);
}

CMD:prisoners(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Jailed Players ______");

    foreach(new i : Player)
    {
        if (PlayerData[i][pJailType] != JailType_None)
        {
            SendClientMessageEx(playerid, COLOR_GREY1, "(ID: %i) %s - Status: %s - Reason: %s - Time: %i seconds",
                i, GetRPName(i), GetPlayerJailTypeStr(playerid), PlayerData[i][pJailReason], PlayerData[i][pJailTime]);
        }
    }

    return 1;
}

CMD:prisoninfo(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /prisoninfo [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (PlayerData[targetid][pJailType] != JailType_OOCPrison)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not in OOC prison.");
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "* %s was prisoned by %s, reason: %s (%i seconds left.) *", GetRPName(targetid), PlayerData[targetid][pJailedBy], PlayerData[targetid][pJailReason], PlayerData[targetid][pJailTime]);
    return 1;
}

CMD:relog(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /relog [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to relog.", GetRPName(playerid), GetRPName(targetid));
    SavePlayerVariables(targetid);
    ResetPlayer(targetid);

    PlayerData[targetid][pLogged] = 0;
    PlayerLogin(targetid);
    return 1;
}

CMD:setskin(playerid, params[])
{
    new targetid, skinid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "ui", targetid, skinid))
    {
        return SendSyntaxMessage(playerid, " /setskin [playerid] [skinid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
    }
    if (!(0 <= skinid <= 311) && !(25000 <= skinid <= 25165))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid skin specified.");
    }
    if (!IsPlayerLoggedIn(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has a higher admin level than you. You can't change their skin.");
    }

    SetScriptSkin(targetid, skinid);
    SendClientMessageEx(playerid, COLOR_GREY2, "%s's skin set to ID %i.", GetPlayerNameEx(targetid), skinid);
    return 1;
}


CMD:listguns(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listguns [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s's Weapons _______", GetRPName(targetid));

    for (new i = 0; i < 13; i ++)
    {
        new weapon, ammo;

        GetPlayerWeaponData(targetid, i, weapon, ammo);

        if (weapon)
        {
            if (!PlayerHasWeapon(targetid, weapon, true))
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "-> %s {FFD700}(Desynced){C8C8C8}", GetWeaponNameEx(weapon));
            }
            else
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "-> %s", GetWeaponNameEx(weapon));
            }
        }
    }

    return 1;
}

CMD:disarm(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /disarm [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    ResetPlayerWeaponsEx(targetid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disarmed %s.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:nrn(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nrn [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    //if (PlayerData[targetid][pLevel] > 3)
    //{
    //    return SendClientMessage(playerid, COLOR_GREY, "That player is level 3 or above and doesn't need a free namechange.");
    //}
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }

    Dialog_Show(targetid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "");
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to change their name for being Non-RP.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:release(playerid, params[])
{
    new targetid, reason[128];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /release [playerid] [reason]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (PlayerData[targetid][pJailType] == JailType_None)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not jailed.");
    }

    LogPlayerPunishment(playerid, PlayerData[targetid][pID], GetPlayerIP(targetid),
            "RELEASE", "%s was released from %d seconds %s by %s %s. Reason: %s",
            GetPlayerNameEx(targetid), PlayerData[targetid][pJailTime],
            GetPlayerJailTypeStr(targetid), GetAdminRank(playerid),
            GetPlayerNameEx(playerid), reason);
    PlayerData[targetid][pJailTime] = 1;
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was released from jail/prison by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);
    return 1;
}

CMD:sethp(playerid, params[])
{
    new targetid, Float:amount;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uf", targetid, amount))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sethp [playerid] [amount]");
        SendClientMessage(playerid, COLOR_SYNTAX, "Warning: Values above 255.0 may not work properly with the server-sided damage system.");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (amount < 1.0 && !IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't do this to an admin with a higher level than you.");
    }

    SetPlayerHealth(targetid, amount);
    SendClientMessageEx(playerid, COLOR_GREY2, "%s's health set to %.1f.", GetRPName(targetid), amount);
    return 1;
}

CMD:setarmor(playerid, params[])
{
    new targetid, Float:amount;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "uf", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setarmor [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    SetScriptArmour(targetid, amount);
    SendClientMessageEx(playerid, COLOR_GREY2, "%s's armor set to %.1f.", GetRPName(targetid), amount);
    return 1;
}

CMD:refilldrug(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_9))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /refilldrug [seeds | cocaine | chems]");
        SendClientMessage(playerid, COLOR_SYNTAX, "This command refills the specified drug to maximum value.");
        return 1;
    }

    if (!strcmp(params, "seeds", true))
    {
        gSeedsStock = 1000;
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has refilled the seeds in the drug den.", GetRPName(playerid));
    }
    else if (!strcmp(params, "cocaine", true))
    {
        gCocaineStock = 500;
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has refilled the cocaine in the cocaine house.", GetRPName(playerid));
    }
    else if (!strcmp(params, "chems", true))
    {
        gChemicalsStock = 250;
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has refilled the chems in the drug den.", GetRPName(playerid));
    }

    return 1;
}

CMD:god(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_8) || PlayerData[playerid][pAdminDuty])
    {
        if (!PlayerData[playerid][pNoDamage])
        {
            PlayerData[playerid][pNoDamage] = 1;
            SendClientMessage(playerid, COLOR_GREY, "You are now in GODMODE, you will no longer take damage from ANYTHING.");
        }
        else
        {
            PlayerData[playerid][pNoDamage] = 0;
            SendClientMessage(playerid, COLOR_GREY, "You've turned off GODMODE, you will now take damage normally.");
        }
        return 1;
    }
    return 0;
}

CMD:healrange(playerid, params[])
{
    new Float:radius;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "f", radius))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /healrange [radius]");
    }
    if (!(1.0 <= radius <= 50.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    foreach(new i : Player)
    {
        if (IsPlayerNearPlayer(i, playerid, radius))
        {
            if (!PlayerData[i][pAdminDuty])
            {
                SetPlayerHealth(i, 100.0);

                if (GetPlayerArmourEx(i) < 25.0)
                {
                    SetScriptArmour(i, 25.0);
                }
            }

            SendClientMessage(i, COLOR_WHITE, "An admin has healed everyone nearby.");
        }
    }

    return 1;
}

CMD:freezerange(playerid, params[])
{
    new Float:radius;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "f", radius))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /freezerange [radius]");
    }
    if (!(1.0 <= radius <= 50.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
    }

    foreach(new i : Player)
    {
        if (IsPlayerNearPlayer(i, playerid, radius))
        {
            if (!PlayerData[i][pAdminDuty])
            {
                TogglePlayerControllableEx(i, false);
            }

            SendClientMessage(i, COLOR_WHITE, "An admin has frozen everyone nearby.");
        }
    }

    return 1;
}

CMD:unfreezerange(playerid, params[])
{
    new Float:radius;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "f", radius))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unfreezerange [radius]");
    }
    if (!(1.0 <= radius <= 50.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
    }

    foreach(new i : Player)
    {
        if (IsPlayerNearPlayer(i, playerid, radius))
        {
            if (!PlayerData[i][pAdminDuty])
            {
                TogglePlayerControllableEx(i, true);
            }

            SendClientMessage(i, COLOR_WHITE, "An admin has unfrozen everyone nearby.");
        }
    }

    return 1;
}

CMD:revivenear(playerid, params[])
{
    return callcmd::reviverange(playerid, "12");
}

CMD:reviverange(playerid, params[])
{
    new Float:radius;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "f", radius))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /reviverange [radius]");
    }
    if (!(1.0 <= radius <= 50.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
    }

    foreach(new i : Player)
    {
        if (IsPlayerNearPlayer(i, playerid, radius) && PlayerData[i][pInjured])
        {
            RevivePlayer(i);
            SendClientMessage(i, COLOR_WHITE, "An admin has revived everyone nearby.");
        }
    }

    return 1;
}

CMD:setname(playerid, params[])
{
    new targetid, name[24];

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "us[24]", targetid, name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setname [playerid] [name]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (PlayerData[targetid][pAdminDuty] && strcmp(PlayerData[targetid][pAdminName], "None", true) != 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't change the name of a player on admin duty. They're using their admin name.");
    }
    if (!IsValidUsername(name))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The name specified is not supported by the SA-MP client.");
    }

    DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
    DBExecute("OnAdminChangeName", "iis", playerid, targetid, name);
    return 1;
}

CMD:explode(playerid, params[])
{
    new targetid, damage;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "ui", targetid, damage))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /explode [playerid] [damage(amount)]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendUnauthorized(playerid);
    }

    new
        Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(targetid, x, y, z);

    CreateExplosionForPlayer(targetid, x, y, z, 6, 20.0);
    AwardAchievement(targetid, ACH_AcmeDinamyte);
    SendClientMessageEx(playerid, COLOR_WHITE, "You exploded %s for their client only.", GetRPName(targetid));
    return 1;
}

CMD:lockaccount(playerid, params[])
{
    new username[MAX_PLAYER_NAME], reason[64];

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]s[64]", username, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lockaccount [username] [reason]");
    }
    if (isnull(reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lockaccount [username] [reason]");
    }

    DBFormat("SELECT locked, adminlevel, uid, username, ip FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnAdminLockAccount", "iss", playerid, username, reason);
    return 1;
}

CMD:unlockaccount(playerid, params[])
{
    new username[MAX_PLAYER_NAME];

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unlockaccount [username]");
    }

    DBFormat("SELECT uid, username, ip FROM "#TABLE_USERS" WHERE username = '%e' AND locked = 1", username);
    DBExecute("OnAdminUnlockAccount", "is", playerid, username);
    return 1;
}

CMD:sethpall(playerid, params[])
{
    new Float:amount;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "f", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sethpall [amount]");
    }
    if (amount < 1.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Health can't be under 1.0.");
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pAdminDuty] && !IsPlayerInEvent(i) && !PlayerData[i][pPaintball])
        {
            SetPlayerHealth(i, amount);
        }
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s set everyone's health to %.1f.", GetRPName(playerid), amount);
    return 1;
}

CMD:setarmorall(playerid, params[])
{
    new Float:amount;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "f", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setarmorall [amount]");
    }
    if (amount < 0.0 || amount > 150.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Armor can't be under 0.0 or above 150.0.");
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pAdminDuty] && !IsPlayerInEvent(i) && !PlayerData[i][pPaintball])
        {
            SetScriptArmour(i, amount);
        }
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s set everyone's armor to %.1f.", GetRPName(playerid), amount);
    return 1;
}

CMD:fws(playerid, params[])
{
    if (!PlayerData[playerid][pAdminDuty] && !IsAdmin(playerid, ADMIN_LVL_9))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (IsAdmin(playerid, ADMIN_LVL_5))
    {
        new targetid, reason[64];
        if (sscanf(params, "us[64]", targetid, reason))
        {
            SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /fws [playerid] [reason]");
            return 1;
        }
        GivePlayerFullWeaponSet(targetid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s gave a full weapon set to %s, reaason %s.", GetRPName(playerid), GetRPName(targetid), reason);
        SendClientMessageEx(targetid, COLOR_AQUA, "You have received a {00AA00}full weapon set{33CCFF} from %s.", GetRPName(playerid));
    }
    else
    {
        SendUnauthorized(playerid);
    }
    return 1;
}

CMD:listassets(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    new properties = 0;
    if ((3 <= strlen(params) <= 20) && IsValidUsername(params))
    {
        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Assets _____", GetNameWithSpace(params));
        foreach(new i : House)
        {
            if (HouseInfo[i][hExists] && !strcmp(HouseInfo[i][hOwner], params, true))
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "* {33CC33}House{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (gettime() - HouseInfo[i][hTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
                properties++;
            }
        }

        foreach(new i : Business)
        {
            if (BusinessInfo[i][bExists] && !strcmp(BusinessInfo[i][bOwner], params, true))
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "* {FFD700}Business{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]), (gettime() - BusinessInfo[i][bTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
                properties++;
            }
        }

        foreach(new i : Garage)
        {
            if (GarageInfo[i][gExists] && !strcmp(GarageInfo[i][gOwner], params, true))
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "* {004CFF}Garage{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]), (gettime() - GarageInfo[i][gTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
                properties++;
            }
        }

        foreach(new i : Land)
        {
            if (LandInfo[i][lExists] && !strcmp(LandInfo[i][lOwner], params, true))
            {
                SendClientMessageEx(playerid, COLOR_GREY2, "* {33CCFF}Land{C8C8C8} | ID: %i | Location: %s", i, GetZoneName(LandInfo[i][lHeightX], LandInfo[i][lHeightY], LandInfo[i][lHeightZ]));
                properties++;
            }
        }
        if (properties == 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Cannot find properties owned by '%s'.", params);
        }
        return 1;
    }

    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listassets [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Assets _____", GetRPName(targetid));

    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && IsHouseOwner(targetid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {33CC33}House{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (gettime() - HouseInfo[i][hTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
            properties++;
        }
    }

    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && IsBusinessOwner(targetid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {FFD700}Business{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]), (gettime() - BusinessInfo[i][bTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
            properties++;
        }
    }

    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && IsGarageOwner(targetid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {004CFF}Garage{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]), (gettime() - GarageInfo[i][gTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
            properties++;
        }
    }

    foreach(new i : Land)
    {
        if (LandInfo[i][lExists] && IsLandOwner(targetid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {33CCFF}Land{C8C8C8} | ID: %i | Location: %s", i, GetZoneName(LandInfo[i][lHeightX], LandInfo[i][lHeightY], LandInfo[i][lHeightZ]));
            properties++;
        }
    }

    if (properties == 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Cannot find properties owned by '%s'.", GetPlayerNameEx(targetid));
    }
    return 1;
}

CMD:oadmins(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pAdminPersonnel] && !PlayerData[playerid][pHumanResources])
    {
        return SendUnauthorized(playerid);
    }

    DBQueryWithCallback("SELECT username, lastlogin, adminlevel, adminstrikes, adminname FROM "#TABLE_USERS" WHERE adminlevel > 0 ORDER BY adminlevel DESC", "ListAdmins", "i", playerid);
    return 1;
}

CMD:sellinactive(playerid, params[])
{
    new houses, garages, businesses;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }

    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && HouseInfo[i][hOwnerID] > 0 && (gettime() - HouseInfo[i][hTimestamp]) > 2592000)
        {
            SetHouseOwner(i, INVALID_PLAYER_ID);
            houses++;
        }
    }

    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && GarageInfo[i][gOwnerID] > 0 && (gettime() - GarageInfo[i][gTimestamp]) > 2592000)
        {
            SetGarageOwner(i, INVALID_PLAYER_ID);
            garages++;
        }
    }

    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && BusinessInfo[i][bOwnerID] > 0 && (gettime() - BusinessInfo[i][bTimestamp]) > 2592000)
        {
            SetBusinessOwner(i, INVALID_PLAYER_ID);
            businesses++;
        }
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has sold all inactive properties.", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_WHITE, "* You have sold %i inactive houses, %i inactive garages and %i inactive businesses.", houses, garages, businesses);
    return 1;
}

CMD:inactivecheck(playerid, params[])
{
    new houses, garages, businesses;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }

    foreach(new i : House) if (HouseInfo[i][hExists] && HouseInfo[i][hOwnerID] > 0 && (gettime() - HouseInfo[i][hTimestamp]) > 2592000)
        houses++;
    foreach(new i : Garage) if (GarageInfo[i][gExists] && GarageInfo[i][gOwnerID] > 0 && (gettime() - GarageInfo[i][gTimestamp]) > 2592000)
        garages++;
    foreach(new i : Business) if (BusinessInfo[i][bExists] && BusinessInfo[i][bOwnerID] > 0 && (gettime() - BusinessInfo[i][bTimestamp]) > 2592000)
        businesses++;

    SendClientMessageEx(playerid, COLOR_WHITE, "* There are currently %i inactive houses, %i inactive garages and %i inactive businesses.", houses, garages, businesses);
    return 1;
}

CMD:setmotd(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_8) && !PlayerData[playerid][pHelperManager] && PlayerData[playerid][pHelper] < 7)
    {
        return SendUnauthorized(playerid);
    }
    new option[8], newval[128];
    if (sscanf(params, "s[8]s[128]", option, newval))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /setmotd [admin/helper/global] [text ('none' to reset)]");
    }
    if (strfind(newval, "|") != -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You may not include the '|' character in the MOTD.");
    }
    if (!strcmp(option, "global", true))
    {
        if (!IsAdmin(playerid, ADMIN_LVL_8)) return SendUnauthorized(playerid);
        if (!strcmp(newval, "none", true))
        {
            SetServerMOTD("");
            SendClientMessage(playerid, COLOR_WHITE, "* You have reset the Global MOTD text.");
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the global MOTD.", GetRPName(playerid));
        }
        else
        {
            SetServerMOTD(newval);
            SendClientMessageEx(playerid, COLOR_WHITE, "* You have changed the Global MOTD text to '%s'.", GetServerMOTD());
            SendAdminMessage(COLOR_YELLOW, "AdmCmd: %s has set the global MOTD to '%s'", GetRPName(playerid), GetServerMOTD());
        }
    }
    if (!strcmp(option, "admin", true))
    {
        if (!IsAdmin(playerid, ADMIN_LVL_8)) return SendUnauthorized(playerid);
        if (!strcmp(newval, "none", true))
        {
            SetAdminMOTD("");
            SendClientMessage(playerid, COLOR_WHITE, "* You have reset the Admin MOTD text.");
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the admin MOTD.", GetRPName(playerid));
        }
        else
        {
            SetAdminMOTD(newval);
            SendClientMessageEx(playerid, COLOR_WHITE, "* You have changed the Admin MOTD text to '%s'.", GetAdminMOTD());
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the admin MOTD to '%s'", GetRPName(playerid), GetAdminMOTD());
        }
    }
    if (!strcmp(option, "helper", true))
    {
        if (!strcmp(newval, "none", true))
        {
            SetHelperMOTD("");
            SendClientMessage(playerid, COLOR_WHITE, "* You have reset the Helper MOTD text.");
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the helper MOTD.", GetRPName(playerid));
        }
        else
        {
            SetHelperMOTD(newval);
            SendClientMessageEx(playerid, COLOR_WHITE, "* You have changed the Helper MOTD text to '%s'.", GetHelperMOTD());
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the helper MOTD to '%s'", GetRPName(playerid), GetHelperMOTD());
        }
    }
    return 1;
}

CMD:makeformeradmin(playerid, params[])
{
    new targetid, status;
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "ui", targetid, status) || !(0 <= status <= 1))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /makeformeradmin [playerid] [status (0/1)]");
        return 1;
    }
    PlayerData[targetid][pFormerAdmin] = status;

    DBQuery("UPDATE "#TABLE_USERS" SET FormerAdmin = %i WHERE uid = %i", PlayerData[targetid][pFormerAdmin], PlayerData[targetid][pID]);


    if (status)
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a Former Admin.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a Former Admin.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}Former Admin{33CCFF}.", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}Former Admin{33CCFF}.", GetRPName(playerid));
    }
    else
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's Former Admin status.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) Former Admin status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}Former Admin{33CCFF} status.", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}Former Admin{33CCFF} status.", GetRPName(playerid));
    }
    return 1;
}

CMD:setstaff(playerid, params[])
{
    new targetid, option[16], status;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[16]i", targetid, option, status) || !(0 <= status <= 1))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstaff [playerid] [option] [status (0/1)]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: FactionMod, GangMod, BanAppealer, AdminPersonnel, HelperManager, GameAffairs");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: DynamicAdmin, Scripter, ComplaintMod, HumanResources, BusinessMod");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!IsAdmin(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Target player must be an administrator!");
    }
    if (!strcmp(option, "businessmod", true))
    {
        PlayerData[targetid][pWebDev] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET webdev = %i WHERE uid = %i", PlayerData[targetid][pWebDev], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a business moderator.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a business moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}business moderator{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}business moderator{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's business moderator status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) business moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}business moderator{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}business moderator{33CCFF} status.", GetRPName(playerid));
        }
    }

    if (!strcmp(option, "factionmod", true))
    {
        PlayerData[targetid][pFactionMod] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET factionmod = %i WHERE uid = %i", PlayerData[targetid][pFactionMod], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a faction moderator.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a faction moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}faction moderator{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}faction moderator{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's faction moderator status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) faction moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}faction moderator{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}faction moderator{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "gangmod", true))
    {
        PlayerData[targetid][pGangMod] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET gangmod = %i WHERE uid = %i", PlayerData[targetid][pGangMod], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a gang moderator.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a gang moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}gang moderator{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}gang moderator{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's gang moderator status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) gang moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}gang moderator{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}gang moderator{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "banappealer", true))
    {
        PlayerData[targetid][pBanAppealer] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET banappealer = %i WHERE uid = %i", PlayerData[targetid][pBanAppealer], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a ban appealer.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a ban appealer.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}ban appealer{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}ban appealer{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's ban appealer status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) ban appealer status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}ban appealer{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}ban appealer{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "scripter", true))
    {
        if (!IsAdmin(playerid, ADMIN_LVL_10)) return SendClientMessage(playerid, COLOR_GREY, "You must be server management to set someone as a scripter.");
        PlayerData[targetid][pDeveloper] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET scripter = %i WHERE uid = %i", PlayerData[targetid][pDeveloper], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a developer.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a developer.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}developer{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}developer{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's developer status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) developer status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}developer{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}developer{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "helpermanager", true))
    {
        PlayerData[targetid][pHelperManager] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET helpermanager = %i WHERE uid = %i", PlayerData[targetid][pHelperManager], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a Helper Manager.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a Helper Manager.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}Helper Manager{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}Helper Manager{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's Helper Manager status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) Helper Manager status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}Helper Manager{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}HM{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "dynamicadmin", true))
    {
        PlayerData[targetid][pDynamicAdmin] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET dynamicadmin = %i WHERE uid = %i", PlayerData[targetid][pDynamicAdmin], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a dynamic admin.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a dynamic admin.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}dynamic admin{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}dynamic admin{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's dynamic admin status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) dynamic admin status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}dynamic admin{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}dynamic admin{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "adminpersonnel", true))
    {
        if (!IsAdmin(playerid, ADMIN_LVL_10)) return SendClientMessage(playerid, COLOR_GREY, "You must be server management to set someone as AP.");
        PlayerData[targetid][pAdminPersonnel] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET adminpersonnel = %i WHERE uid = %i", PlayerData[targetid][pAdminPersonnel], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s admin personnel.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) admin perosnnel.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s {FF6347}admin personnel{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you {FF6347}admin personnel{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's admin personnel status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) admin personnel status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}admin personnel{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}admin personnel{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "gameaffairs", true))
    {
        PlayerData[targetid][pGameAffairs] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET gameaffairs = %i WHERE uid = %i", PlayerData[targetid][pGameAffairs], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a part of the department of game affairs.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a part of the department of game affairs.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a part of the department of {FF6347}game affairs{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a part of the department of{FF6347}game affairs{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's game affairs status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) game affairs status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}game affairs{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}game affairs{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "humanresources", true))
    {
        PlayerData[targetid][pHumanResources] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET humanresources = %i WHERE uid = %i", PlayerData[targetid][pHumanResources], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a part of the human resources.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a part of the human resources.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a part of the {FF6347}human resources{33CCFF}.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a part of the {FF6347}human resources{33CCFF}.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's human resources status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) human resources status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}human resources{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}human resources{33CCFF} status.", GetRPName(playerid));
        }
    }
    else if (!strcmp(option, "complaintmod", true))
    {
        PlayerData[targetid][pComplaintMod] = status;

        DBQuery("UPDATE "#TABLE_USERS" SET complaintmod = %i WHERE uid = %i", PlayerData[targetid][pComplaintMod], PlayerData[targetid][pID]);


        if (status)
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a complaint moderator status.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has made %s (uid: %i) a complaint moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}complaint moderator{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}complaint moderator{33CCFF} status.", GetRPName(playerid));
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's complaint moderator.", GetRPName(playerid), GetRPName(targetid));
            DBLog("log_admin", "%s (uid: %i) has removed %s's (uid: %i) complaint moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}complaint moderator{33CCFF} status.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}complaint moderator{33CCFF} status.", GetRPName(playerid));
        }
    }

    return 1;
}

CMD:renamecmd(playerid, params[])
{
    new cmd[64], newcmd[64];
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[64]s[64]", cmd, newcmd))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /renamecmd [old] [new] (64 chars)");
    }
    if (PC_CommandExists(cmd))
    {
        PC_RenameCommand(cmd, newcmd);
        SendClientMessageEx(playerid, COLOR_AQUA, "You've renamed command %s to %s.", cmd, newcmd);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s renamed /%s to /%s", GetRPName(playerid), cmd, newcmd);
    }
    return 1;
}

CMD:createalias(playerid, params[])
{
    new cmd[64], alias[64];
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[64]s[64]", cmd, alias))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createalias [cmd] [newcmd] (64 chars)");
    }
    if (PC_CommandExists(cmd))
    {
        PC_RegAlias(cmd, alias);
        SendClientMessageEx(playerid, COLOR_AQUA, "You've created alias %s for %s.", alias, cmd);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s created a alias for /%s (/%s)", GetRPName(playerid), cmd, alias);
    }
    return 1;
}

CMD:deletecmd(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }

    return SendClientMessage(playerid, 0xAFAFAFAA, "This command was disabled.");

    // new oldcmd[64], confirm[64];
    // if (sscanf(params, "s[64]s[64]", oldcmd, confirm) || strcmp(confirm, "confirm", true))
    // {
    //     return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deletecmd [name] [confirm]");
    // }
    // if (PC_CommandExists(oldcmd))
    // {
    //  PC_DeleteCommand(oldcmd);
    // }
    // return 1;
}
CMD:forceaduty(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_8) && !PlayerData[playerid][pAdminPersonnel])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forceaduty [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsAdmin(targetid, ADMIN_LVL_2))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player needs to be at least a level 2 administrator.");
    }
    if (!IsAdmin(playerid, GetAdminLvl(targetid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be forced into admin duty.");
    }

    if (!PlayerData[targetid][pAdminDuty])
    {
        SendClientMessageEx(targetid, COLOR_WHITE, "%s has forced you to be on admin duty.", GetRPName(playerid));
    }
    else
    {
        SendClientMessageEx(targetid, COLOR_WHITE, "%s has forced you to be off admin duty.", GetRPName(playerid));
    }

    callcmd::aduty(targetid, "\1");
    return 1;
}


CMD:fixplayerid(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_8))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", targetid))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fixplayerid [playerid]");
        SendClientMessage(playerid, COLOR_SYNTAX, "Sometimes player IDs can become bugged causing sscanf to not identify that ID until server restart.");
        SendClientMessage(playerid, COLOR_SYNTAX, "(e.g. a command used upon a valid player ID saying the player is disconnected, invalid or offline.)");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        SSCANF_Leave(targetid);
    }
    else
    {
        SSCANF_Join(targetid, GetPlayerNameEx(targetid), IsPlayerNPC(targetid));
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "* Player ID %i has been fixed.", targetid);
    return 1;
}

CMD:saveaccounts(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }

    foreach(new i : Player)
    {
        SavePlayerVariables(i);
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has saved all player accounts.", GetRPName(playerid));
    return 1;
}

CMD:kickall(playerid, params[])
{
    if (IsGodAdmin(playerid))
    {
        if (isnull(params))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /kickall [reason]");
        }

        foreach(new i : Player)
        {
            KickPlayer(i, params);
        }
    }

    return 1;
}

CMD:givedoublexp(playerid, params[])
{
    new targetid, hours;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "ui", targetid, hours))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givedoublexp [playerid] [hours]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (hours < 1 && PlayerData[targetid][pDoubleXP] - hours < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player can't have under 0 hours of double XP.");
    }

    GivePlayerDoubleXP(targetid, hours);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %i hours of double XP to %s.", GetRPName(playerid), hours, GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_YELLOW, "%s has given you %i hours of double XP.", GetRPName(playerid), hours);

    return 1;
}
CMD:motd(playerid, params[])
{
    new motd[128];
    motd = GetServerMOTD();
    if (!isnull(motd))
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "* MOTD: %s", motd);
    }
    if (IsAdmin(playerid))
    {
        motd=GetAdminMOTD();
        if (!isnull(motd))
        {
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "* Admin MOTD: %s", motd);
        }
    }
    if (PlayerData[playerid][pHelper] > 0 || IsAdmin(playerid))
    {
        motd=GetHelperMOTD();
        if (!isnull(motd))
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "* Helper MOTD: %s", motd);
        }
    }
    if (PlayerData[playerid][pGang] >= 0 && strcmp(GangInfo[PlayerData[playerid][pGang]][gMOTD], "None", true) != 0)
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "* Gang MOTD: %s", GangInfo[PlayerData[playerid][pGang]][gMOTD]);
    }
    if (PlayerData[playerid][pFaction] >= 0 && strcmp(FactionInfo[PlayerData[playerid][pFaction]][fMOTD], "None", true) != 0)
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "* Faction MOTD: %s", FactionInfo[PlayerData[playerid][pFaction]][fMOTD]);
    }

    return 1;
}

CMD:namehistory(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /namehistory [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT * FROM log_namehistory WHERE uid = %i ORDER BY id DESC", PlayerData[targetid][pID]);
    DBExecute("OnAdminCheckNameHistory", "ii", playerid, targetid);

    return 1;
}

CMD:ahide(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_8))
    {
        return 0;
    }

    if (!PlayerData[playerid][pAdminHide])
    {
        PlayerData[playerid][pAdminHide] = 1;
        SendClientMessage(playerid, COLOR_AQUA, "You are now hidden in /admins and your admin rank no longer shows in /a, /g or /o.");
    }
    else
    {
        PlayerData[playerid][pAdminHide] = 0;
        SendClientMessage(playerid, COLOR_AQUA, "You are no longer hidden as an administrator.");
    }

    return 1;
}

CMD:settitle(playerid, params[])
{
    new targetid, option[14], param[128];
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[14]S()[128]", targetid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settitle [playerid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, Color");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid playerid.");
    }
    if (!strcmp(option, "name", true))
    {
        if (isnull(param) || strlen(params) > 32)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settitle [playerid] [name] [text ('none' to reset)]");
        }

        strcpy(PlayerData[targetid][pCustomTitle], param, 64);

        DBQuery("UPDATE "#TABLE_USERS" SET customtitle = '%e' WHERE uid = %i", param, PlayerData[targetid][pID]);


        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the customtitle of %s to '%s'.", GetRPName(playerid), GetRPName(targetid), param);
    }
    else if (!strcmp(option, "color", true))
    {
        new color;

        if (sscanf(param, "h", color))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settitle [playerid] [color] [0xRRGGBBAA]");
        }

        PlayerData[targetid][pCustomTColor] = color & ~0xff;

        DBQuery("UPDATE "#TABLE_USERS" SET customcolor = %i WHERE uid = %i", PlayerData[targetid][pCustomTColor], PlayerData[targetid][pID]);


        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of %s's title.", GetRPName(playerid), color >>> 8, GetRPName(targetid));
    }
    return 1;
}

CMD:changename(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 360.7130,176.3916,1008.3828))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the desk at city hall.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changename [new name]");
    }
    if (!(3 <= strlen(params) <= 20))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your name must range from 3 to 20 characters.");
    }
    if (strfind(params, "_") == -1 ||  params[strlen(params)-1] == '_')
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your name needs to contain at least one underscore.");
    }
    if (!IsValidUsername(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid characters. Your name may only contain letters and underscores.");
    }
    if (PlayerData[playerid][pCash] < PlayerData[playerid][pLevel] * LEVEL_COST)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need at least %s to change your name at your level.", FormatCash(PlayerData[playerid][pLevel] * LEVEL_COST));
    }
    if (PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't allowed to change your name while on admin duty,");
    }
    if (!isnull(PlayerData[playerid][pNameChange]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have already requested a namechange. Please wait for a response.");
    }

    PlayerData[playerid][pFreeNamechange] = 0;

    DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", params);
    DBExecute("OnPlayerAttemptNameChange", "is", playerid, params);
    return 1;
}

CMD:acceptname(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /acceptname [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerLoggedIn(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (isnull(PlayerData[targetid][pNameChange]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested a namechange.");
    }
    new cost = PlayerData[targetid][pLevel] * LEVEL_COST;
    if (PlayerData[targetid][pFreeNamechange] == 0 && PlayerData[targetid][pCash] < cost)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player can't afford the namechange.");
    }


    if (PlayerData[targetid][pFreeNamechange])
    {
        if (PlayerData[targetid][pFreeNamechange] == 2 && (GetPlayerFaction(targetid) == FACTION_HITMAN || GetPlayerFaction(targetid) == FACTION_FEDERAL))
        {
            GetPlayerName(targetid, PlayerData[targetid][pPassportName], MAX_PLAYER_NAME);

            PlayerData[targetid][pPassport] = 1;
            PlayerData[targetid][pPassportLevel] = PlayerData[targetid][pLevel];
            PlayerData[targetid][pPassportSkin] = PlayerData[targetid][pSkin];
            PlayerData[targetid][pPassportPhone] = PlayerData[targetid][pPhone];
            PlayerData[targetid][pLevel] = PlayerData[targetid][pChosenLevel];
            PlayerData[targetid][pSkin] = PlayerData[targetid][pChosenSkin];
            PlayerData[targetid][pPhone] = random(100000) + 899999;

            SetPlayerSkin(targetid, PlayerData[targetid][pSkin]);
            DBLog("log_faction", "%s (uid: %i) used the /passport command to change their name to %s, level to %i and skin to %i.", GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange], PlayerData[targetid][pLevel], PlayerData[targetid][pSkin]);

            DBQuery("UPDATE "#TABLE_USERS" SET level = %i, skin = %i, phone = %i, passport = 1,"\
                    " passportname = '%e', passportlevel = %i, passportskin = %i, passportphone = %i"\
                    " WHERE uid = %i", PlayerData[targetid][pLevel], PlayerData[targetid][pSkin],
                    PlayerData[targetid][pPhone], PlayerData[targetid][pPassportName], PlayerData[targetid][pPassportLevel],
                    PlayerData[targetid][pPassportSkin], PlayerData[targetid][pPassportPhone], PlayerData[targetid][pID]);

        }

        DBLog("log_admin", "%s (uid: %i) accepted %s's (uid: %i) free namechange to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange]);
        DBLog("log_namechanges", "%s (uid: %i) accepted %s's (uid: %i) free namechange to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange]);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has accepted %s's free namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange]);
        SendClientMessageEx(targetid, COLOR_YELLOW, "Your namechange request to %s was approved for free.", PlayerData[targetid][pNameChange]);

        if (!IsPlayerLoggedIn(targetid))
        {
            ShowLoginDlg(targetid);
        }

        if (PlayerData[targetid][pFreeNamechange] == 2)
        {
            SendClientMessage(targetid, COLOR_WHITE, "* You can use /passport again to return to your old name and stats.");
        }
    }
    else
    {
        DBLog("log_admin", "%s (uid: %i) accepted %s's (uid: %i) namechange to %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange], cost);
        DBLog("log_namechanges", "%s (uid: %i) accepted %s's (uid: %i) namechange to %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange], cost);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has accepted %s's namechange to %s for %s.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange], FormatCash(cost));
        SendClientMessageEx(targetid, COLOR_YELLOW, "Your namechange request to %s was approved for %s.", PlayerData[targetid][pNameChange], FormatCash(cost));

        GivePlayerCash(targetid, -cost);
        AddToTaxVault(cost);
    }

    DBQuery("INSERT INTO log_namehistory VALUES(null, %i, '%e', '%e', '%e', NOW())", PlayerData[targetid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pNameChange], GetPlayerNameEx(playerid));

    Namechange(targetid, GetPlayerNameEx(targetid), PlayerData[targetid][pNameChange]);
    PlayerData[targetid][pNameChange] = 0;
    PlayerData[targetid][pFreeNamechange] = 0;
    return 1;
}

CMD:denyname(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /denyname [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    //if (!PlayerData[targetid][pLogged])
    //{
    //    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    //}
    if (isnull(PlayerData[targetid][pNameChange]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested a namechange.");
    }

    if (PlayerData[targetid][pFreeNamechange] == 1)
    {
        if (!IsPlayerLoggedIn(targetid))
        {
            KickPlayer(targetid,  "Please reconnect with a proper roleplay name in the Firstname_Lastname format.");
            return 1;
        }
        Dialog_Show(targetid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
    }

    DBLog("log_admin", "%s (uid: %i) denied %s's (uid: %i) namechange to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange]);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has denied %s's namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange]);
    SendClientMessageEx(targetid, COLOR_LIGHTRED, "Your namechange request to %s was denied.", PlayerData[targetid][pNameChange]);
    PlayerData[targetid][pNameChange] = 0;
    PlayerData[targetid][pFreeNamechange] = 0;
    return 1;
}

CMD:namechanges(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Pending Namechanges ______");

    foreach(new i : Player)
    {
        if (!isnull(PlayerData[i][pNameChange]))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s requested a namechange to %s", i, GetRPName(i), PlayerData[i][pNameChange]);
        }
    }

    return 1;
}

CMD:adminstrike(playerid, params[])
{
    new targetid, reason[128];
    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pAdminPersonnel])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[128]", targetid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /adminstrike [playerid] [reason]");
    }
    PlayerData[targetid][pAdminStrike]++;
    DBQuery("UPDATE "#TABLE_USERS" SET adminstrikes = %i WHERE uid = %i", PlayerData[targetid][pAdminStrike], targetid);

    DBLog("log_strike", "%s (uid: %i) has admin striked player %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GetRPName(targetid), targetid);
    switch (PlayerData[targetid][pAdminStrike])
    {
        case 1: SendAdminMessage(COLOR_WHITE, "(( Admin News: %s{FFFFFF} has received their 1st strike, reason: %s ))", GetRPName(targetid), reason);
        case 2: SendAdminMessage(COLOR_WHITE, "(( Admin News: %s{FFFFFF} has received their 2nd strike, reason: %s ))", GetRPName(targetid), reason);
        case 3:
        {
            PlayerData[targetid][pAdmin] -= 1;
            PlayerData[targetid][pAdminStrike] = 0;
            SendClientMessage(targetid, COLOR_GREY, "The admin strike system works perfectly fine");
            GameTextForPlayer(targetid, "~r~DEMOTED", 5000, 1);
            DBQuery("UPDATE "#TABLE_USERS" SET adminlevel = %i, adminstrikes = %i WHERE uid = %i", GetAdminLvl(targetid), PlayerData[targetid][pAdminStrike], PlayerData[targetid][pID]);

            SendAdminMessage(COLOR_WHITE, "(( Admin News: %s{FFFFFF} has received their 3rd strike, reason: %s ))", GetRPName(targetid), reason);
        }
    }
    return 1;
}
