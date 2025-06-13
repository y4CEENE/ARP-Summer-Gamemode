/// @file      GangManagement.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-02-26 21:45:17 +0100
/// @copyright Copyright (c) 2023

CMD:gotoganghq(playerid, params[])
{
    new gangid;
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }

    if (sscanf(params, "i", gangid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoganghq [gangid]");
    }

    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }

    new entranceid = GetGangHQ(gangid);
    if (entranceid == -1)
    {
        SendClientMessage(playerid, COLOR_GREY, "This gang doesn't have an HQ.");
    }
    else
    {
        GotoEntrance(playerid, entranceid);
    }
    return 1;
}

CMD:removeganghq(playerid, params[])
{
    new gangid;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }

    if (sscanf(params, "i", gangid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeganghq [gangid]");
    }

    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }

    new entranceid = GetGangHQ(gangid);
    if (entranceid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This gang doesn't have an HQ.");
    }

    RemoveEntrance(entranceid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed the HQ of gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have removed the HQ of gang  {F7A763}%s{FF6347}.", GangInfo[gangid][gName]);
    DBLog("log_gang", "%s (uid: %i) has removed the HQ of gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
    return 1;
}

CMD:purgegang(playerid, params[])
{
    new gangid;
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", gangid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /purgegang [gangid]");
    }
    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }
    foreach(new i : Player)
    {
        if (PlayerData[i][pGang] == gangid)
        {
            SendClientMessageEx(i, COLOR_LIGHTRED, "The gang you were apart of has been deleted by an administrator.");
            PlayerData[i][pGang] = -1;
            PlayerData[i][pGangRank] = 0;
        }
    }
    DBQuery("UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE gang = %i", gangid);

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has purged gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have purged the gang {F7A763}%s{FF6347}.", GangInfo[gangid][gName]);
    DBLog("log_gang", "%s (uid: %i) has purged the gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
    GangInfo[gangid][gCount] = 0;
    return 1;
}

CMD:removegang(playerid, params[])
{
    new gangid;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", gangid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removegang [gangid]");
    }
    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }

    RemoveGang(gangid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has deleted gang %s.", GetRPName(playerid), GangInfo[gangid][gName]);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have permanently deleted the {F7A763}%s{FF6347} gang slot.", GangInfo[gangid][gName]);
    DBLog("log_gang", "%s (uid: %i) has removed gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
    return 1;
}

CMD:creategang(playerid, params[])
{
    new name[32];

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[32]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /creategang [name]");
    }

    for (new i = 0; i < MAX_GANGS; i ++)
    {
        if (!GangInfo[i][gSetup])
        {
            SetupGang(i, name);

            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has setup gang {F7A763}%s{FF6347} in slot ID %i.", GetRPName(playerid), name, i);
            SendClientMessageEx(playerid, COLOR_WHITE, "* This gang's ID is %i. /editgang to edit.", i);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Gang slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:editgang(playerid, params[])
{
    new gangid, option[14], param[128];

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[14]S()[128]", gangid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, MOTD, Leader, Level, Color, Points, TurfTokens, RankName, Skin, Strikes, RankingPoints, Mafia");
        return 1;
    }
    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }

    if (!strcmp(option, "rankingpoints", true))
    {
        new value;

        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [rankingpoints] [value]");
        }
        if (value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid ranking point value.");
        }

        GangInfo[gangid][gRankingPoints] = value;

        DBQuery("UPDATE "#TABLE_GANGS" SET rankingpoints = %i WHERE id = %i", GangInfo[gangid][gRankingPoints], gangid);


        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the ranking points of gang ID %i to %i.", GetRPName(playerid), gangid, value);
    }
    if (!strcmp(option, "name", true))
    {
        if (isnull(param) || strlen(params) > 32)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [name] [text]");
        }

        strcpy(GangInfo[gangid][gName], param, 32);

        DBQuery("UPDATE "#TABLE_GANGS" SET name = '%e' WHERE id = %i", param, gangid);


        ReloadGang(gangid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the name of gang ID %i to '%s'.", GetRPName(playerid), gangid, param);
    }
    else if (!strcmp(option, "motd", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [motd] [text]");
        }

        strcpy(GangInfo[gangid][gMOTD], param, 128);

        DBQuery("UPDATE "#TABLE_GANGS" SET motd = '%e' WHERE id = %i", param, gangid);


        ReloadGang(gangid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has adjusted the MOTD of gang ID %i.", GetRPName(playerid), gangid);
    }
    else if (!strcmp(option, "leader", true))
    {
        new leaderid;

        if (sscanf(param, "d", leaderid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [leader] [leaderid]");
            SendClientMessage(playerid, COLOR_SYNTAX, "  This updates the text for the leader's name in /gangs and prevent players from kicking him.");
            SendClientMessage(playerid, COLOR_SYNTAX, "  To remove the leader use id -1");
            return 1;
        }
        if (leaderid == -1)
        {
            DBQuery("UPDATE "#TABLE_GANGS" SET leaderid = 0 WHERE id = %i", gangid);

            strcpy(GangInfo[gangid][gLeader], "No-one", MAX_PLAYER_NAME);
            GangInfo[gangid][gLeaderUID] = 0;
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has removed the leader of the gang %s[%i].", GetRPName(playerid), playerid, GangInfo[gangid][gName], gangid);
            DBLog("log_gang", "%s (uid: %i) has removed the leader of gang %s (id: %i).",
                GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
        }
        else
        {
            GetPlayerName(leaderid, GangInfo[gangid][gLeader], MAX_PLAYER_NAME);
            GangInfo[gangid][gLeaderUID] = PlayerData[leaderid][pID];
            DBQuery("UPDATE "#TABLE_GANGS" SET leaderid = %d WHERE id = %i", PlayerData[leaderid][pID], gangid);


            PlayerData[leaderid][pGang] = gangid;
            PlayerData[leaderid][pGangRank] = 6;
            PlayerData[leaderid][pCrew] = -1;

            SendClientMessageEx(leaderid, COLOR_AQUA, "%s has made you the leader of {00AA00}%s{33CCFF}.", GetRPName(playerid), GangInfo[gangid][gName]);

            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has set %s[%i] the leader of the gang %s[%i].", GetRPName(playerid), playerid, GetRPName(leaderid), leaderid, GangInfo[gangid][gName], gangid);
            DBLog("log_gang", "%s (uid: %i) has set %s's (uid: %i) the leader of gang %s (id: %i).",
                GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(leaderid), PlayerData[leaderid][pID], GangInfo[gangid][gName], gangid);
        }
    }
    else if (!strcmp(option, "level", true))
    {
        new value;

        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [level] [value (1-3)]");
        }
        if (!(1 <= value <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid level.");
        }

        GangInfo[gangid][gLevel] = value;

        DBQuery("UPDATE "#TABLE_GANGS" SET level = %i WHERE id = %i", GangInfo[gangid][gLevel], gangid);


        ReloadGang(gangid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the level of gang ID %i to %i/3.", GetRPName(playerid), gangid, value);
    }
    else if (!strcmp(option, "mafia", true))
    {
        new value;

        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [mafia] [value (0-1)]");
        }
        if (!(0 <= value <= 1))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value (must be 0 or 1).");
        }

        GangInfo[gangid][gIsMafia] = value;

        DBQuery("UPDATE "#TABLE_GANGS" SET is_mafia = %i WHERE id = %i", GangInfo[gangid][gIsMafia], gangid);


        ReloadGang(gangid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the mafia value of gang ID %i to %i.", GetRPName(playerid), gangid, value);
    }
    else if (!strcmp(option, "color", true))
    {
        new color;

        if (sscanf(param, "h", color))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [color] [0xRRGGBBAA]");
        }

        GangInfo[gangid][gColor] = color & ~0xff;

        DBQuery("UPDATE "#TABLE_GANGS" SET color = %i WHERE id = %i", GangInfo[gangid][gColor], gangid);


        foreach(new i : Turf)
        {
            if (IsTurfCapturedByGang(i, gangid))
            {
                ReloadTurf(i);
            }
        }

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of gang ID %i.", GetRPName(playerid), color >>> 8, gangid);
    }
    else if (!strcmp(option, "points", true))
    {
        new value;

        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [points] [value]");
        }

        GangInfo[gangid][gPoints] = value;

        DBQuery("UPDATE "#TABLE_GANGS" SET points = %i WHERE id = %i", GangInfo[gangid][gPoints], gangid);


        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the gang points of gang ID %i to %i.", GetRPName(playerid), gangid, value);
    }
    else if (!strcmp(option, "turftokens", true))
    {
        new value;

        if (sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [turftokens] [value]");
        }

        GangInfo[gangid][gTurfTokens] = value;

        DBQuery("UPDATE "#TABLE_GANGS" SET turftokens = %i WHERE id = %i", GangInfo[gangid][gTurfTokens], gangid);


        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the turf tokens of gang ID %i to %i.", GetRPName(playerid), gangid, value);
    }
    else if (!strcmp(option, "rankname", true))
    {
        new rankid, rank[32];

        if (sscanf(param, "is[32]", rankid, rank))
        {
            SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Rank Names ______");

            for (new i = 0; i < 7; i ++)
            {
                if (isnull(GangRanks[gangid][i]))
                    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
                else
                    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: %s", i, GangRanks[gangid][i]);
            }

            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [rankname] [slot (0-6)] [name]");
        }
        if (!(0 <= rankid <= 6))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
        }

        strcpy(GangRanks[gangid][rankid], rank, 32);

        DBQuery("INSERT INTO gangranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", gangid, rankid, rank, rank);

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set rank %i's name of gang ID %i to '%s'.", GetRPName(playerid), rankid, gangid, rank);
    }
    else if (!strcmp(option, "skin", true))
    {
        new slot, skinid;

        if (sscanf(param, "ii", slot, skinid))
        {
            SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Gang Skins ______");

            for (new i = 0; i < MAX_GANG_SKINS; i ++)
            {
                if (GangInfo[gangid][gSkins][i] == 0)
                    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
                else
                    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, GangInfo[gangid][gSkins][i]);
            }

            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [skin] [slot (1-%i)] [skinid]", MAX_GANG_SKINS);
        }
        if (!(1 <= slot <= MAX_GANG_SKINS))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
        }
        slot--;
        if (skinid == 0 && GangInfo[gangid][gSkins][slot] != -1)
        {
            GangInfo[gangid][gSkins][slot] = skinid;
            DBQuery("DELETE FROM gangskins WHERE id=%i and slot = %i", gangid, slot);
            return SendClientMessageEx(playerid, COLOR_WHITE, "* You have removed the skin in slot %i.", slot + 1);
        }
        if (!(1 <= skinid <= 311))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid skin.");
        }

        GangInfo[gangid][gSkins][slot] = skinid;

        DBQuery("INSERT INTO gangskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", gangid, slot, skinid, skinid);

        SendClientMessageEx(playerid, COLOR_WHITE, "* You have set the skin in slot %i to ID %i.", slot + 1, skinid);
    }
    else if (!strcmp(option, "strikes", true))
    {
        new amount;

        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [strikes] [amount]");
        }
        if (!(0 <= amount <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The amount must range from 0 to 3.");
        }

        GangInfo[gangid][gStrikes] = amount;

        DBQuery("UPDATE "#TABLE_GANGS" SET strikes = %i WHERE id = %i", amount, gangid);


        ReloadGang(gangid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the strikes of gang ID %i to %i.", GetRPName(playerid), gangid, amount);
    }
    else if (!strcmp(option, "alliance", true))
    {
        new allyid;

        if (sscanf(param, "i", allyid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editgang [gangid] [alliance] [gangid]");
        }

        if (allyid == -1)
        {
            if (GangInfo[gangid][gAlliance] >= 0)
            {
                DBQuery("UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", GangInfo[gangid][gAlliance]);

                GangInfo[GangInfo[gangid][gAlliance]][gAlliance] = -1;
            }

            GangInfo[gangid][gAlliance] = -1;

            DBQuery("UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", gangid);


            ReloadGang(gangid);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the alliance of gang ID %i.", GetRPName(playerid), gangid);
        }
        else
        {
            if (!(0 <= allyid < MAX_GANGS) || GangInfo[allyid][gSetup] == 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
            }

            GangInfo[gangid][gAlliance] = allyid;
            GangInfo[allyid][gAlliance] = gangid;

            DBQuery("UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", allyid, gangid);
            DBQuery("UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", gangid, allyid);

            ReloadGang(gangid);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the alliance of gang ID %i to gang %i.", GetRPName(playerid), gangid, allyid);
        }
    }
    return 1;
}

CMD:createganghq(playerid, params[])
{
    new gangid, type;
    new Float:x, Float:y, Float:z, Float:a;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }
    if (GetNearbyEntrance(playerid) >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is an entrance in range. Find somewhere else to create this one.");
    }
    if (sscanf(params, "ii", gangid, type))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createganghq [gangid] [type]");
    }

    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }

    if (GetGangHQ(gangid) != -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This gang alreaddy have an HQ.");
    }
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new interior = 15;
    new world = 35000 + gangid;
    new Float:ix, Float:iy, Float:iz, Float:ia;

    switch (type)
    {
        case 0:
        {
            ix =  2214.47;
            iy = -1150.37;
            iz =  1025.80;
            ia =   269.49;
        }
        case 1:
        {
            ix = 2258.23;
            iy =  800.60;
            iz = 1420.55;
            ia =  240.00;
        }
        default:
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid type expected 0 or 1.");
        }
    }

    for (new i = 0; i < MAX_ENTRANCES; i ++)
    {
        if (!EntranceInfo[i][eExists])
        {
            DBFormat("INSERT INTO entrances "\
                "(name, pos_x, pos_y, pos_z, pos_a, outsideint, outsidevw, gang, int_x, int_y, int_z, int_a, interior, world) "\
                "VALUES('%e', '%f', '%f', '%f', '%f', %i, %i, %i, '%f', '%f', '%f', '%f', %i, %i)",
                GangInfo[gangid][gName], x, y, z, a - 180.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid),
                gangid, ix, iy, iz, ia, interior, world);
            DBExecute("OnAdminCreateGangHQ", "iiiffffffffii", playerid, i, gangid, x, y, z, a, ix, iy, iz, ia, interior, world);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Entrance slots are currently full. Ask developers to increase the internal limit.");

    return 1;
}

CMD:setcooldown(playerid, params[])
{
    new option[12], amount;
    if (!IsAdmin(playerid, ADMIN_LVL_9) && PlayerData[playerid][pGangMod] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[12]i", option, amount))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /setcooldown [ganginvite] [minutes]");
    }
    if (!strcmp(option, "ganginvite", true))
    {
        if (-1 > amount > GetGangInviteCooldown())
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "Amount must be above -1 and less then %i", GetGangInviteCooldown());
        }
        SetGangInviteCooldown(amount);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the invite cooldown for gangs to %i.", GetRPName(playerid), amount);
    }
    return 1;
}

CMD:turfscaplimit(playerid, params[])
{
    new amount;
    if (!IsAdmin(playerid, ADMIN_LVL_9) && PlayerData[playerid][pGangMod] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /turfscaplimit [amount]");
    }
    if (0 > amount > MAX_TURFS)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Amount must be above 0 and less then %i.", MAX_TURFS);
    }
    SetMaxTurfCap(amount);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the max active turf claim limit for gangs to %i.", GetRPName(playerid), amount);


    return 1;
}

CMD:ganglogs(playerid, params[])
{
    if (!IsGodAdmin(playerid) && PlayerData[playerid][pGangMod] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (strlen(params) < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /ganglogs [criteria (min 4 characters)]");
    }
    DBFormat("SELECT id, date, description FROM `log_gang` WHERE description like '%%%e%%' ORDER BY date DESC LIMIT 15", params);
    DBExecute("OnShowGangLogs", "i", playerid);
    return 1;
}

DB:OnShowGangLogs(playerid)
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
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Gang Logs", strings, "Okay", "");
    }
}



CMD:gangstrike(playerid, params[])
{
    new gangid, reason[128], color;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[128]", gangid, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gangstrike [gangid] [reason]");
    }
    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }
    if (GangInfo[gangid][gStrikes] >= 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This gang already has 3 strikes.");
    }

    GangInfo[gangid][gStrikes]++;

    DBQuery("UPDATE "#TABLE_GANGS" SET strikes = %i WHERE id = %i", GangInfo[gangid][gStrikes], gangid);

    DBLog("log_gang", "%s (uid: %i) has striked gang %s (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
    if (GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
    {
        color = 0xC8C8C8FF;
    }
    else
    {
        color = GangInfo[gangid][gColor];
    }
    switch (GangInfo[gangid][gStrikes])
    {
        case 1: SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has received their 1st strike, reason: %s ))", color >>> 8, GangInfo[gangid][gName], reason);
        case 2: SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has received their 2nd strike, reason: %s ))", color >>> 8, GangInfo[gangid][gName], reason);
        case 3: SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has received their 3rd strike, reason: %s ))", color >>> 8, GangInfo[gangid][gName], reason);
    }

    return 1;
}

CMD:switchgang(playerid, params[])
{
    new targetid, gangid, rankid;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "uiI(-1)", targetid, gangid, rankid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /switchgang[playerid] [gangid (-1 = none)] [rank (optional)]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }
    if ((gangid != -1 && !(-1 <= rankid <= 6)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
    }

    if (gangid == -1)
    {
        if (PlayerData[targetid][pGang] > 0)
        {
            GangInfo[PlayerData[targetid][pGang]][gCount]--;
        }
        PlayerData[targetid][pGang] = -1;
        PlayerData[targetid][pGangRank] = 0;
        PlayerData[targetid][pCrew] = -1;

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed you from your gang.", GetRPName(playerid));
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s from their gang.", GetRPName(playerid), GetRPName(targetid));
    }
    else
    {
        if (PlayerData[targetid][pGang] > 0)
        {
            GangInfo[PlayerData[targetid][pGang]][gCount]--;
        }
        GangInfo[gangid][gCount]++;

        if (rankid == -1)
        {
            rankid = 6;
        }
        PlayerData[targetid][pGang] = gangid;
        PlayerData[targetid][pGangRank] = rankid;
        PlayerData[targetid][pCrew] = -1;
        SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {00AA00}%s{33CCFF} in %s.", GetRPName(playerid), GangRanks[gangid][rankid], GangInfo[gangid][gName]);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a %s in %s.", GetRPName(playerid), GetRPName(targetid), GangRanks[gangid][rankid], GangInfo[gangid][gName]);
    }
    DBQuery("UPDATE "#TABLE_USERS" SET gang = %i, gangrank = %i, crew = -1 WHERE uid = %i", gangid, rankid, PlayerData[targetid][pID]);
    return 1;
}
