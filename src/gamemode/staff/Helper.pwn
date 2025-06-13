
static HelperCar[MAX_PLAYERS];

Dialog:DIALOG_HELPCMD(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "Account: {C8C8C8}/stats, /buylevel, /b, /g, /me, /do, /(o)oc, /(s)hout, /(l)ow, /(w)hisper, /(n)ewbie.");
                SendClientMessage(playerid, COLOR_YELLOW, "Account: {C8C8C8}/pay, /id, /time, /report, /upgrade, /charity, /stopmusic, /joinevent, /quitevent, /setspawn.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/dice, /flipcoin, /accent, /helpers, /helpme, /accept, /activity, /skill, /quitjob.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/give, /sell, /toggle, /cancelcp, /afk, /(ad)vertise, /buy, /phone, /sms.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/clothing, /locate, /frisk, /contract, /number, /boombox, /switchspeedo, /stuck.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/shakehand, /dropgun, /grabgun, /usecookies, /usecigar, /usedrug, /showid.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/(inv)entory, /guninv, /changename, /drop, /eject, /dicebet, /gangs, /factions.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/calculate, /serverstats, /resetupgrades, /turfs, /lands, /watch, /gps, /fixmyvw.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/myupgrades, /unmute, /breakin, /achievements, /buyinsurance, /tie, /untie.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/househelp, /garagehelp, /bizhelp, /jobhelp, /animhelp, /vehiclehelp, /viphelp.");
                SendClientMessage(playerid, COLOR_YELLOW, "General: {C8C8C8}/bankhelp, /factionhelp, /ganghelp, /landhelp, /helperhelp, /breakcuffs");
                if (PlayerData[playerid][pBanAppealer])
                {
                    SendClientMessage(playerid, COLOR_NAVYBLUE,  "\n{FF6347}Ban Appealer Commands:{FFFFFF} /banip, /baninfo, /banhistory, /unbanip, /unban.");
                }
                if (PlayerData[playerid][pDeveloper])
                {
                    SendClientMessage(playerid, COLOR_NAVYBLUE, "\n{FF6347}Developer Commands:{FFFFFF} /changelist, /gmx, /renamecmd, /createalias");
                }
                if (PlayerData[playerid][pDynamicAdmin])
                {
                    SendClientMessage(playerid, COLOR_NAVYBLUE, "\n{FF6347}Dynamic Admin Commands:{FFFFFF} /dynamichelp, /setvip, /setstat.");
                }
                if (PlayerData[playerid][pAdminPersonnel])
                {
                    SendClientMessage(playerid, COLOR_NAVYBLUE, "\n{FF6347}Admin Personnel Commands:{FFFFFF} /setstaff, /oadmins, /makeadmin, /makeformeradmin, /forceaduty.");
                }
                if (PlayerData[playerid][pHumanResources])
                {
                    SendClientMessage(playerid, COLOR_NAVYBLUE, "\n{FF6347}Human Resources Commands:{FFFFFF} /banhistory, /oadmins, /ocheck.");
                }
                if (IsAdmin(playerid))
                {
                    SendClientMessage(playerid, COLOR_NAVYBLUE, "\n{FF6347}Administrative Commands:{FFFFFF} /a, /adminhelp.");
                }
            }
            case 1:
            {

                SendClientMessage(playerid, COLOR_GREY, GetJobHelp(PlayerData[playerid][pJob]));
                if (PlayerData[playerid][pSecondJob] != JOB_NONE)
                {
                    SendClientMessage(playerid, COLOR_GREY, GetJobHelp(PlayerData[playerid][pSecondJob]));
                }
            }
            case 2:
            {
                if (PlayerData[playerid][pGang] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a gang member.");
                }

                SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
                SendClientMessage(playerid, COLOR_WHITE, "** GANG HELP ** type a command for more information.");
                SendClientMessage(playerid, COLOR_GREY, "** GANG ** /f /gang /gstash /gbackup /bandana /capture /claim /reclaim /turfinfo /gspray");
                SendClientMessage(playerid, COLOR_GREY, "** GANG ** /gbuyvehicle /gpark /gfindcar /grespawncars /gsellcar /gunmod /lock /endalliance");
                SendClientMessage(playerid, COLOR_GREY, "** CREW ** /managecrew /crew");

            }
            case 3:
            {
                if (PlayerData[playerid][pFaction] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not apart of any faction.");
                }

                SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
                SendClientMessage(playerid, COLOR_WHITE, "** FACTION HELP ** type a command for more information.");
                SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /fc /d /(r)adio /div /faction /division /locker /showbadge /(m)egaphone");

                switch (FactionInfo[PlayerData[playerid][pFaction]][fType])
                {
                    case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY:
                    {
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /gate /door /cell /tazer /cuff /uncuff /drag /detain /charge /arrest");
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /wanted /frisk /take /ticket /gov /ram /deploy /undeploy /undeployall /backup");
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /mdc /clearwanted /siren /badge /vticket /vfrisk /vtake /seizeplant /mir /fpark");

                        if (FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_FEDERAL)
                            SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /listcallers /trackcall /cells /passport /callsign /bug /listbugs /tog bugged");
                        else
                            SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /listcallers /trackcall /cells /claim /callsign /fpark");
                    }
                    case FACTION_MEDIC:
                    {
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /heal /drag /stretcher /deliverpt /getpt /listpt /injuries /deploy /undeploy /undeployall");
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /badge /gov /backup /listcallers /trackcall /callsign /fpark");
                    }
                    case FACTION_NEWS:
                    {
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /news /live /endlive /liveban /badge /addeposit /adwithdraw /fpark");
                    }
                    case FACTION_GOVERNMENT:
                    {
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /gov /settax /factionpay /tazer /cuff /uncuff /detain /fpark");
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /backup /badge");
                    }
                    case FACTION_HITMAN:
                    {
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /contracts /takehit /profile /passport /plantbomb /pickupbomb /detonate");
                        SendClientMessage(playerid, COLOR_GREY, "** FACTION ** /hfind, /noknife, /hm /fpark");
                    }
                }
            }
            case 4:
            {
                if (!PlayerData[playerid][pDonator])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
                }

                SendClientMessage(playerid, COLOR_NAVYBLUE, "__________________ VIP Help __________________");
                SendClientMessage(playerid, COLOR_WHITE, "** VIP HELP ** type a command for more information.");
                SendClientMessage(playerid, COLOR_GREY, "** VIP ** /(v)ip /vipinfo /vipcolor /vipinvite /vipnumber /vipmusic");

                if (PlayerData[playerid][pDonator] == 3)
                {
                    SendClientMessage(playerid, COLOR_GREY, "** VIP ** /repair /nos /hyd");
                }
            }
            case 5:
            {
                SendClientMessage(playerid, COLOR_WHITE, "** HOUSE HELP ** type a command for more information.");
                SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /buyhouse /lock /stash /furniture /upgradehouse /sellhouse /sellmyhouse");
                SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /door /renthouse /unrent /setrent /tenants /evict /evictall /houseinfo");
                SendClientMessage(playerid, COLOR_GREY, "** HOUSE ** /houseinvite /hlights /installhousealarm (/iha), /uninstallhousealarm (/uha)");
            }
            case 6:
            {
                SendClientMessage(playerid, COLOR_WHITE, "** VEHICLE HELP ** type a command for more information.");
                SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /lights /hood /boot /buy /carstorage /park /lock /findcar");
                SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /vstash /neon /unmod /colorcar /paintcar /upgradevehicle /sellcar /sellmycar");
                SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /givekeys /takekeys /setradio /paytickets /carinfo /gascan /breakin");
            }
            case 7:
            {
                SendClientMessage(playerid, COLOR_WHITE, "** BUSINESS HELP ** type a command for more information.");
                SendClientMessage(playerid, COLOR_GREY, "** BUSINESS ** /buybiz /sellbiz /sellmybiz /lock /entryfee ");
                SendClientMessage(playerid, COLOR_GREY, "** BUSINESS ** /bizmenu /bwithdraw /bdeposit /bdepositmats /bwithdrawmats /bname");
            }
            case 8:
            {
                callcmd::hh(playerid, inputtext);
            }
            case 9:
            {
                callcmd::adminhelp(playerid, inputtext);
            }
        }
    }
    return 1;
}

DB:ListHelpers(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME], lastlogin[24];

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Helper Roster _______");

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "username", username);
        GetDBStringField(i, "lastlogin", lastlogin);

        switch (GetDBIntField(i, "helperlevel"))
        {
            case 1: SendClientMessageEx(playerid, COLOR_GREY2, "Junior Helper %s - Last Seen: %s", username, lastlogin);
            case 2: SendClientMessageEx(playerid, COLOR_GREY2, "Senior Helper %s - Last Seen: %s", username, lastlogin);
            case 3: SendClientMessageEx(playerid, COLOR_GREY2, "Ast. Head Helper %s - Last Seen: %s", username, lastlogin);
            case 4: SendClientMessageEx(playerid, COLOR_GREY2, "Head Helper %s - Last Seen: %s", username, lastlogin);
        }
    }
}

publish UnfreezeNewbie(playerid)
{
    TogglePlayerControllableEx(playerid, 1);
}

GetHelperRank(playerid)
{
    new string[24];

    switch (PlayerData[playerid][pHelper])
    {
        case 0: string = "None";
        case 1: string = "Junior Helper";
        case 2: string = "Senior Helper";
        case 3: string = "Ast Head Helper";
        case 4: string = "Head Helper";
        case 5: string = "Junior Advisor";
        case 6: string = "Senior Advisor";
        case 7: string = "Chief Advisor";
    }

    return string;
}

Dialog:DIALOG_NEWBWELCOME(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new count;
        foreach(new i : Player)
        {
            if (PlayerData[i][pHelper] > 0)
            {
                count++;
            }
        }
        if (count > 0)
        {
            new string[30];
            format(string, sizeof(string), "Show me around LS please, I am new.");
            strcpy(PlayerData[playerid][pHelpRequest], string, 128);
            SendHelperMessage(COLOR_AQUA, "* Help Request: New Player %s (ID:%d) is requesting a helper to show them around. *", GetRPName(playerid), playerid);

            PlayerData[playerid][pLastRequest] = gettime();
            SendClientMessage(playerid, COLOR_GREEN, "Your help request was sent to all helpers. Please wait for a response.");
        }
        else
        {
            Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{00aa00}"SERVER_SHORT_NAME"{FFFFFF} | Failed", "{FFFFFF}Unfortunately there are no members of the {33CCFF}helper team{FFFFFF} online :(.\nYou can also try /newb, This is where most of the community can help you with simple questions such as \"Where is the Bank\".\nYou can also checkout {00aa00} %s {FFFFFF} for beginner tutorials.", "Cancel", "", GetServerWebsite());
        }
    }
    return 1;
}

Dialog:DIALOG_HELP(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new sstring[2048];
        switch (listitem)
        {
            case 0: // JOBS
            {
                format(sstring, sizeof(sstring), "{FFFFFF}Chat: /stats, /b, /g, /me, /do, /(o)oc, /(s)hout, /(l)ow, /(w)hisper, /(n)ewbie.");
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{FFFFFF}Commands", sstring, "Ok","");
            }
            case 1: // STORES
            {
                format(sstring, sizeof(sstring), "{FFFFFF}General: /pay, /id, /time, /report, /upgrade, /charity, /stopmusic, /joinevent, /quitevent.");
                strcat(sstring, "\n{FFFFFF}General: /dice, /flipcoin, /accent, /helpers, /helpme, /accept, /properties, /skill, /quitjob.");
                strcat(sstring, "\n{FFFFFF}General: /give, /sell, /toggle, /cancelcp, /afk, /(ad)vertise, /buy, /phone, /sms.");
                strcat(sstring, "\n{FFFFFF}General: /clothing, /locate, /frisk, /contract, /number, /boombox, /switchspeedo, /stuck.");
                strcat(sstring, "\n{FFFFFF}General: /shakehand, /dropgun, /grabgun, /usecookies, /usecigar, /usedrug, /showid.");
                strcat(sstring, "\n{FFFFFF}General: /(inv)entory, /guninv, /loadammo, /drop, /eject, /dicebet, /gangs, /factions.");
                strcat(sstring, "\n{FFFFFF}General: /calculate, /serverstats, /turfs, /lands, /changename, /watch, /gps, /fixmyvw.");
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{FFFFFF}Commands", sstring, "Ok","");
            }
            case 2: // GENERAL LOCATIONS
            {
                format(sstring, sizeof(sstring), "{FFFFFF}UPGRADES: /resetupgrades, /myupgrades.");
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{FFFFFF}Commands", sstring, "Ok","");
            }
            case 3: // Find Points
            {
                format(sstring, sizeof(sstring), "{FFFFFF}Other: /househelp, /garagehelp, /bizhelp, /jobhelp, /animhelp, /vehiclehelp, /viphelp, /rankhelp.");
                strcat(sstring, "\n{FFFFFF}Other: /bankhelp, /factionhelp, /ganghelp, /landhelp, /helperhelp.");
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{FFFFFF}Commands", sstring, "Ok","");
            }
            case 4:
            {
                if (PlayerData[playerid][pGang] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a gang member.");
                }

                format(sstring, sizeof(sstring), "** GANG ** /f /gang /gstash /gbackup /bandana /capture /claim /reclaim /turfinfo\n");
                strcat(sstring, "** GANG ** /gbuyvehicle /gpark /gfindcar /grespawncars /gsellcar /gunmod /lock /endalliance /gspray\n");
                strcat(sstring, "** CREW ** /managecrew /crew\n");
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Help | Gang Commands", sstring, "Ok","");

            }//gang
            case 5:
            {
                if (PlayerData[playerid][pFaction] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not apart of any faction.");
                }

                format(sstring, sizeof(sstring), "** FACTION ** /fc /d /(r)adio /div /faction /division /locker /showbadge /(m)egaphone\n");

                switch (FactionInfo[PlayerData[playerid][pFaction]][fType])
                {
                    case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY:
                    {
                        strcat(sstring, "** FACTION ** /gate /door /cell /tazer /cuff /uncuff /drag /detain /charge /arrest\n");
                        strcat(sstring, "** FACTION ** /wanted /frisk /take /ticket /gov /ram /deploy /undeploy /undeployall /backup\n");
                        strcat(sstring, "** FACTION ** /mdc /clearwanted /siren /badge /vticket /vfrisk /vtake /seizeplant /mir\n");

                        if (FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_FEDERAL)
                            strcat(sstring, "** FACTION ** /listcallers /trackcall /cells /passport /callsign /bug /listbugs /tog bugged\n");
                        else
                            strcat(sstring, "** FACTION ** /listcallers /trackcall /cells /claim /callsign\n");
                    }
                    case FACTION_MEDIC:
                    {
                        strcat(sstring, "** FACTION ** /heal /drag /stretcher /deliverpt /getpt /listpt /injuries /deploy /undeploy /undeployall\n");
                        strcat(sstring, "** FACTION ** /badge /gov /backup /listcallers /trackcall /callsign\n");
                    }
                    case FACTION_NEWS:
                    {
                        format(sstring, sizeof(sstring), "** FACTION ** /news /live /endlive /liveban /badge /addeposit /adwithdraw\n");
                    }
                    case FACTION_GOVERNMENT:
                    {
                        strcat(sstring, "** FACTION ** /gov /settax /factionpay /tazer /cuff /uncuff /detain\n");
                        strcat(sstring, "** FACTION ** /backup /badge\n");
                    }
                    case FACTION_HITMAN:
                    {
                        strcat(sstring, "** FACTION ** /contracts /takehit /profile /passport /plantbomb /pickupbomb /detonate\n");
                        strcat(sstring, "** FACTION ** /hfind /noknife\n");
                    }
                }
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Help | Faction Commands", sstring, "Ok","");
            }//faction
            case 6:
            {
                if (!PlayerData[playerid][pDonator])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.\n");
                }
                format(sstring, sizeof(sstring), "** VIP ** /(v)ip /vipinfo /viptag /vipcolor /vipinvite /vipnumber /vipmusic\n");

                if (PlayerData[playerid][pDonator] == 3)
                {
                    strcat(sstring, "** VIP ** /repair /nos /hyd\n");
                }
                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Help | VIP Commands", sstring, "Ok","");

            }//vip
            case 7:
            {
                if (PlayerData[playerid][pJob] == JOB_NONE && PlayerData[playerid][pSecondJob] == JOB_NONE)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You have no job and therefore no job commands to view.");
                }

                format(sstring, sizeof(sstring),"%s\n", GetJobHelp(PlayerData[playerid][pJob]));

                if (PlayerData[playerid][pSecondJob] != JOB_NONE)
                {
                    strcat(sstring,GetJobHelp(PlayerData[playerid][pSecondJob]));
                    strcat(sstring,"\n");
                }

                Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Help | Job Commands", sstring, "Ok","");

            }//job
        }
    }
    return 1;
}

CMD:hrevive(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hrevive [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (PlayerData[targetid][pLevel] > 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only revive level 1 players.");
    }
    if (!RevivePlayer(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not injured.");
    }
    if (PlayerData[playerid][pAcceptedHelp])
    {
        SendClientMessage(targetid, COLOR_YELLOW, "You have been revived by a helper!");
        SendHelperMessage(COLOR_LIGHTRED, "HelperCmd: %s has revived %s (Level 1).", GetRPName(playerid), GetRPName(targetid));
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You need to accept a help to revive this new player.");
    }
    return 1;
}

CMD:listhelp(playerid, params[])
{
    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Help Requests _____");

    foreach(new i : Player)
    {
        if (!isnull(PlayerData[i][pHelpRequest]))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* %s[%i] asks: %s", GetRPName(i), i, PlayerData[i][pHelpRequest]);
        }
    }

    SendClientMessage(playerid, COLOR_AQUA, "* Use /accepthelp [id] or /denyhelp [id] to handle help requests.");
    SendClientMessage(playerid, COLOR_AQUA, "* Use /answerhelp [id] [msg] to PM an answer without the need to teleport.");
    return 1;
}

CMD:ac(playerid, params[]) return callcmd::accepthelp(playerid, params);
CMD:accepthelp(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to leave the paintball arena first.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /accepthelp [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (isnull(PlayerData[targetid][pHelpRequest]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
    }

    if (PlayerData[playerid][pPassport])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have an active passport. You can't accept help.");
    }

    if (!PlayerData[playerid][pAcceptedHelp])
    {
        SavePlayerVariables(playerid);
    }

    TeleportToPlayer(playerid, targetid, false);
    SetPlayerSkin(playerid, HELPER_SKIN);

    TogglePlayerControllableEx(targetid, 0);
    SetTimerEx("UnfreezeNewbie", 5000, false, "i", targetid);

    SetPlayerHealth(playerid, 32767);
    //SetScriptArmour(playerid, 0.0);

    PlayerData[playerid][pHelpRequests]++;
    PlayerData[playerid][pAcceptedHelp] = 1;
    PlayerData[targetid][pHelpRequest][0] = 0;

    DBQuery("UPDATE "#TABLE_USERS" SET helprequests = %i WHERE uid = %i", PlayerData[playerid][pHelpRequests], PlayerData[playerid][pID]);


    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has accepted %s's help request.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_WHITE, "You accepted %s's help request and were sent to their position. /return to go back.", GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_GREEN, "%s has accepted your help request. They are now assisting you.", GetRPName(playerid));
    return 1;
}

CMD:denyhelp(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /denyhelp [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (isnull(PlayerData[targetid][pHelpRequest]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
    }

    PlayerData[targetid][pHelpRequest][0] = 0;

    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has denied %s's help request.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_WHITE, "You denied %s's help request.", GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_LIGHTRED, "* %s has denied your help request.", GetRPName(playerid));
    return 1;
}

CMD:sta(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sta [playerid] (Sends /helpme to admins)");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (isnull(PlayerData[targetid][pHelpRequest]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
    }

    AddReportToQueue(targetid, PlayerData[targetid][pHelpRequest]);
    PlayerData[targetid][pHelpRequest][0] = 0;

    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has sent %s's help request to all online admins.", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_WHITE, "You sent %s's help request to all online admins.", GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has sent your help request to all online admins.", GetRPName(playerid));
    return 1;
}

CMD:return(playerid, params[])
{
    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (!PlayerData[playerid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't accepted any help requests.");
    }

    if (HelperCar[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicleEx(HelperCar[playerid]);
        HelperCar[playerid] = INVALID_VEHICLE_ID;
    }

    SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
    SetScriptArmour(playerid, PlayerData[playerid][pArmor]);

    SetFreezePos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
    SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
    SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
    SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
    SetCameraBehindPlayer(playerid);

    if (HelperCar[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicleEx(HelperCar[playerid]);
        HelperCar[playerid] = INVALID_VEHICLE_ID;
        SendClientMessage(playerid, COLOR_GREY, "Your helper car was destroyed.");
    }

    SendClientMessage(playerid, COLOR_WHITE, "You were returned to your previous position.");
    PlayerData[playerid][pAcceptedHelp] = 0;
    return 1;
}

CMD:answerhelp(playerid, params[])
{
    new targetid, msg[128];

    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "us[128]", targetid, msg))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /answerhelp [playerid] [message]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (isnull(PlayerData[targetid][pHelpRequest]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
    }

    PlayerData[playerid][pHelpRequests]++;
    PlayerData[targetid][pHelpRequest][0] = 0;

    DBQuery("UPDATE "#TABLE_USERS" SET helprequests = %i WHERE uid = %i", PlayerData[playerid][pHelpRequests], PlayerData[playerid][pID]);


    if (strlen(msg) > MAX_SPLIT_LENGTH)
    {
        SendClientMessageEx(targetid, COLOR_YELLOW, "* Answer from %s: %.*s... *", GetRPName(playerid), MAX_SPLIT_LENGTH, msg);
        SendClientMessageEx(targetid, COLOR_YELLOW, "* Answer from %s: ...%s *", GetRPName(playerid), msg[MAX_SPLIT_LENGTH]);
    }
    else
    {
        SendClientMessageEx(targetid, COLOR_YELLOW, "* Answer from %s: %s *", GetRPName(playerid), msg);
    }

    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has answered %s's help request.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

CMD:hh(playerid, params[])
{
    return callcmd::helperhelp(playerid, params);
}

CMD:hhelp(playerid, params[])
{
    return callcmd::helperhelp(playerid, params);
}

CMD:helperhelp(playerid, params[])
{
    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }

    if (PlayerData[playerid][pHelper] >= 1)
    {
        SendClientMessage(playerid, COLOR_AQUA, "LEVEL 1:{DDDDDD} /hc, /listhelp, /sendhelp, /accepthelp, /answerhelp, /denyhelp, /sta, /return.");
    }
    if (PlayerData[playerid][pHelper] >= 2)
    {
        SendClientMessage(playerid, COLOR_AQUA, "LEVEL 2:{DDDDDD} /nmute, /hmute, /gmute, /admute");
    }
    if (PlayerData[playerid][pHelper] >= 3)
    {
        SendClientMessage(playerid, COLOR_AQUA, "LEVEL 3:{DDDDDD} /olisthelpers, /checknewbie.");
    }
    if (PlayerData[playerid][pHelper] >= 4)
    {
        SendClientMessage(playerid, COLOR_AQUA, "LEVEL 4:{DDDDDD} /setmotd.");
    }

    return 1;
}

CMD:requesthelp(playerid, params[]) return callcmd::helpme(playerid, params);
CMD:gethelp(playerid, params[])     return callcmd::helpme(playerid, params);
CMD:helpme(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /helpme [help request]");
    }
    if (PlayerData[playerid][pHelper] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are a helper and therefore can't use this command.");
    }
    if (IsHelpMuted(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are muted from submitting help requests.");
    }
    if (gettime() - PlayerData[playerid][pLastRequest] < 30)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only submit one help request every 30 seconds. Please wait %i more seconds.", 30 - (gettime() - PlayerData[playerid][pLastRequest]));
    }

    strcpy(PlayerData[playerid][pHelpRequest], params, 128);
    SendHelperMessage(COLOR_AQUA, "* Help Request from %s[%i]: %s *", GetRPName(playerid), playerid, params);

    PlayerData[playerid][pLastRequest] = gettime();
    SendClientMessage(playerid, COLOR_GREEN, "Your help request was sent to all helpers. Please wait for a response.");
    return 1;
}

CMD:sendhelp(playerid, params[])
{
    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only helpers can use this command.");
    }

    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendhelp [playerid]");
    }

    if (!IsPlayerConnected(targetid) || IsAdmin(targetid) || PlayerData[targetid][pHelper])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't send help to this player.");
    }
    SendHelperMessage(COLOR_AQUA, "* %s %s offer's a help to %s *", GetHelperRank(playerid), GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_AQUA, "* %s %s offer's you a help *", GetHelperRank(playerid), GetRPName(playerid));
    Dialog_Show(targetid, OnSpawnRequestHelper, DIALOG_STYLE_MSGBOX, "Helper request", "Did you need a helper?\n He can explain the rules, show you the city\n and help you to find your first job!", "Yes", "No");
    return 1;
}

CMD:checknewbies(playerid, params[])
{
    new targetid;
    if (!IsAdmin(playerid) && PlayerData[playerid][pHelper] < 3)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checknewbies [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    SendClientMessageEx(playerid, COLOR_GREY, "Level %i Player %s has used newbie {00FF00}%s times.", PlayerData[targetid][pLevel], GetRPName(targetid), FormatNumber(PlayerData[targetid][pNewbies]));
    return 1;
}

CMD:helpers(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "_________ Helpers Online _________");

    foreach(new i : Player)
    {
        if (PlayerData[i][pHelper] > 0 && !PlayerData[i][pUndercover][0])
        {
            if (IsAdmin(playerid) || PlayerData[playerid][pHelper] > 0)
                SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s - Help Requests: %s - Newbies: %s", i, GetHelperRank(i), GetRPName(i), FormatNumber(PlayerData[i][pHelpRequests]), FormatNumber(PlayerData[i][pNewbies]));
            else
                SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s", i, GetHelperRank(i), GetRPName(i));
        }
    }

    return 1;
}

hook OnPlayerConnect(playerid)
{
    HelperCar[playerid] = INVALID_VEHICLE_ID;
}

hook OnVehicleDeath(vehicleid, killerid)
{
    foreach(new playerid : Player)
    {
        if (HelperCar[playerid] != INVALID_VEHICLE_ID && HelperCar[playerid] == vehicleid)
        {
            HelperCar[playerid] = INVALID_VEHICLE_ID;
        }
    }
}

CMD:hcar(playerid, params[])
{
    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendUnauthorized(playerid);
    }

    if (HelperCar[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicleEx(HelperCar[playerid]);
        HelperCar[playerid] = INVALID_VEHICLE_ID;
        SendClientMessage(playerid, COLOR_GREY, "Your helper car was destroyed.");
    }
    else if (PlayerData[playerid][pAcceptedHelp])
    {
        HelperCar[playerid] = GivePlayerAdminVehicle(playerid, 421);
        adminVehicle[HelperCar[playerid]] = false;
        SendHelperMessage(COLOR_YELLOW, "(( %s (ID:%d) spawned a helper car ))", GetRPName(playerid), playerid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You need to accept a help to spawn a helper car.");
    }
    return 1;
}

CMD:hlock(playerid, params[])
{
    if (!PlayerData[playerid][pHelper])
    {
        return SendUnauthorized(playerid);
    }
    if (!PlayerData[playerid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to accept a help to use this command");
    }

    new vehicleid = HelperCar[playerid];
    if (vehicleid != INVALID_VEHICLE_ID)
    {
        if (!VehicleInfo[vehicleid][vLocked])
        {
            VehicleInfo[vehicleid][vLocked] = 1;
            GameTextForPlayer(playerid, "~r~Vehicle locked", 3000, 6);
        }
        else
        {
            VehicleInfo[vehicleid][vLocked] = 0;
            GameTextForPlayer(playerid, "~g~Vehicle unlocked", 3000, 6);
        }

        SetVehicleParams(vehicleid, VEHICLE_DOORS, VehicleInfo[vehicleid][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
    }
    return 1;
}
