
CMD:reports(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "__________ Pending Reports __________");

	for(new i = 0; i < MAX_REPORTS; i ++)
	{
	    if(ReportInfo[i][rExists] && !ReportInfo[i][rAccepted])
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "[Report ID:{ff0000} %i{afafaf}] %s[%i] reports: %s", i, GetRPName(ReportInfo[i][rReporter]), ReportInfo[i][rReporter], ReportInfo[i][rText]);
		}
	}

	SendClientMessage(playerid, COLOR_YELLOW, "* Use /ar [rid] or /tr [rid] to handle these reports.");
	return 1;
}

CMD:rtnc(playerid, params[])
{
    new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rtnc [reportid] (Sends to newbie chat)");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid report ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The report specified is being handled by another admin.");
	}

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has sent report %i to newbie chat.", GetRPName(playerid), reportid);
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_GREEN, "%s has redirected your report to the newbie chat.", GetRPName(playerid));
    SendNewbieChatMessage(ReportInfo[reportid][rReporter], ReportInfo[reportid][rText]);
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:sth(playerid, params[])
{
    new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sth [reportid] (Sends to helpers)");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid report ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The report specified is being handled by another admin.");
	}

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has sent report %i to helpers.", GetRPName(playerid), reportid);
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_GREEN, "%s has redirected your report to all helpers online.", GetRPName(playerid));

    strcpy(PlayerData[ReportInfo[reportid][rReporter]][pHelpRequest], ReportInfo[reportid][rText], 128);
	SendHelperMessage(COLOR_AQUA, "* Help Request from %s[%i]: %s *", GetRPName(ReportInfo[reportid][rReporter]), ReportInfo[reportid][rReporter], ReportInfo[reportid][rText]);

	PlayerData[playerid][pLastRequest] = gettime();
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:ar(playerid, params[])
{
	new reportid, chat;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "iI(1)", reportid, chat))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ar [reportid] [chat (optional - 0/1)]");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid report ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The report specified is being handled by another admin.");
	}
	if(PlayerData[playerid][pActiveReport] >= 0)
	{
		callcmd::cr(playerid, params);
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has accepted report %i from %s.", GetAdmCmdRank(playerid), GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));

	if(chat)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You can use /rr to speak with the reporter and /cr to close the report.");
		SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_GREEN, "%s has accepted your report and is now reviewing it.", GetRPName(playerid));
		SendClientMessage(ReportInfo[reportid][rReporter], COLOR_GREEN, "You can use /rr to reply to the admin handling your report.");

		PlayerData[playerid][pActiveReport] = reportid;
		PlayerData[ReportInfo[reportid][rReporter]][pActiveReport] = reportid;

		ReportInfo[reportid][rHandledBy] = playerid;
		ReportInfo[reportid][rAccepted] = 1;
	}
	else
	{
	    SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s %s has accepted your report and is now reviewing it.",GetAdmCmdRank(playerid), GetRPName(playerid));
	    ReportInfo[reportid][rExists] = 0;
	}

	PlayerData[playerid][pReports]++;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET reports = %i WHERE uid = %i", PlayerData[playerid][pReports], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:tr(playerid, params[])
{
	new reportid, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "iS(N/A)[128]", reportid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /tr [reportid] [reason (optional)]");
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid report ID.");
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
    if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The report specified is being handled by another admin.");
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s, reason: %s", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]), reason);
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "* %s has trashed your report, reason: %s", GetRPName(playerid), reason);
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:tpr(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "iS(N/A)[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /tpr [playerid] [reason (optional)]");
	}
    if(!IsPlayerConnected(targetid))
    {
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid player ID.");
    }

    for(new reportid=0;reportid<sizeof(ReportInfo);reportid++)
    {
        if(ReportInfo[reportid][rExists] && ReportInfo[reportid][rReporter] == targetid && !ReportInfo[reportid][rAccepted])
        {
            ReportInfo[reportid][rExists] = 0;
        }
    }

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed all reports from %s, reason: %s", GetRPName(playerid), GetRPName(targetid), reason);
	SendClientMessageEx(targetid, COLOR_LIGHTRED, "* %s has trashed your reports, reason: %s", GetRPName(playerid), reason);
	return 1;
}

CMD:nro(playerid, params[])
{
	new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nro [reportid]");
 		SendClientMessage(playerid, COLOR_SYNTAX, "This command will clear a report for not being a rulebreaking offense.");
 		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This report is already being handled by another administrator.");
	}

 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as their report involves a non-rulebreaking offense.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as it involves a non-rulebreaking offense", GetRPName(playerid));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "Please visit our rules page at our website %s for a full list of rulebreaking offenses.", GetServerWebsite());
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:nao(playerid, params[])
{
	new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nao [reportid]");
   		SendClientMessage(playerid, COLOR_SYNTAX, "This command will clear a report if there isn't a high enough administrator online.");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This report is already being handled by another administrator.");
	}

  	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as there are no admins online to handle it.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as there no admins online with the authority to handle it.", GetRPName(playerid));
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:ic(playerid, params[])
{
	new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ic [reportid]");
   		SendClientMessage(playerid, COLOR_SYNTAX, "This command will clear a report for being an IC issue");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This report is already being handled by another administrator.");
	}

  	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as it is an in-character issue.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as it is an in-character issue.", GetRPName(playerid));
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:nor(playerid, params[])
{
	new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nor [reportid]");
   		SendClientMessage(playerid, COLOR_SYNTAX, "This command will clear a report if the reporters revive request is invalid.");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This report is already being handled by another administrator.");
	}

 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as their request for a revive is invalid.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as your request for a revive is invalid. (/phone > call > 911)", GetRPName(playerid));
	ReportInfo[reportid][rExists] = 0;
	return 1;
}

CMD:post(playerid, params[])
{
	new reportid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", reportid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /post [reportid]");
   		SendClientMessage(playerid, COLOR_SYNTAX, "This command will clear a report and notify the player to post an admin request.");
   		return 1;
	}
	if(!(0 <= reportid < MAX_REPORTS) || !ReportInfo[reportid][rExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There's not a report that currently exists with this ID.");
	}
	if(ReportInfo[reportid][rAccepted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This report is already being handled by another administrator.");
	}

 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has trashed report %i from %s as it needs to be handled on the forums.", GetRPName(playerid), reportid, GetRPName(ReportInfo[reportid][rReporter]));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "%s has trashed your report as your issue at hand must be handled on our forums.", GetRPName(playerid));
	SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_LIGHTRED, "Please visit our website %s in order to to resolve this issue.", GetServerWebsite());
	ReportInfo[reportid][rExists] = 0;
	return 1;
}


CMD:er(playerid, params[])
{
	return callcmd::cr(playerid, params);
}


CMD:rr(playerid, params[])
{
	new reportid = PlayerData[playerid][pActiveReport];

    if(reportid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no active report to reply to.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rr [reply text]");
	}

	if(ReportInfo[reportid][rReporter] == playerid)
	{
	    SendClientMessageEx(ReportInfo[reportid][rHandledBy], COLOR_YELLOW, "* Player %s (ID %i): %s *", GetRPName(playerid), playerid, params);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "* Reply to %s (ID %i): %s *", GetRPName(ReportInfo[reportid][rHandledBy]), ReportInfo[reportid][rHandledBy], params);
	}
	else
	{
	    SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_YELLOW, "* Admin %s (ID %i): %s *", GetRPName(playerid), playerid, params);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "* Reply to %s (ID %i): %s *", GetRPName(ReportInfo[reportid][rReporter]), ReportInfo[reportid][rReporter], params);
	}

	return 1;
}

CMD:cr(playerid, params[])
{
    new reportid = PlayerData[playerid][pActiveReport];

    if(reportid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no active report which you can close.");
	}

	if(ReportInfo[reportid][rReporter] == playerid)
	{
	    SendClientMessageEx(ReportInfo[reportid][rHandledBy], COLOR_YELLOW, "* Player %s has closed the report. *", GetRPName(playerid));
	    SendClientMessageEx(playerid, COLOR_GREEN, "You have closed the report and ended your conversation with the admin.");
	}
	else
	{
	    SendClientMessageEx(ReportInfo[reportid][rReporter], COLOR_YELLOW, "* Administrator %s has closed the report. *", GetRPName(playerid));
	    SendClientMessageEx(playerid, COLOR_GREEN, "You have closed the report and ended your conversation with the reporter.");
	}

	if(ReportInfo[reportid][rReporter] != INVALID_PLAYER_ID)
	{
		PlayerData[ReportInfo[reportid][rReporter]][pActiveReport] = -1;
	}
	if(ReportInfo[reportid][rHandledBy] != INVALID_PLAYER_ID)
	{
		PlayerData[ReportInfo[reportid][rHandledBy]][pActiveReport] = -1;
	}

	ReportInfo[reportid][rExists] = 0;
	ReportInfo[reportid][rAccepted] = 0;
	ReportInfo[reportid][rReporter] = INVALID_PLAYER_ID;
	ReportInfo[reportid][rHandledBy] = INVALID_PLAYER_ID;
	PlayerData[playerid][pActiveReport] = -1;

	return 1;
}


CMD:report(playerid, params[])
{
    if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /report [reason]");
	}
    if (IsAdmin(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot report as you are an administrator, use /a moron.");
    }
    if (!enabledReports)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The report channel is disabled at the moment.");
    }
	if(PlayerData[playerid][pReportMuted] > 0)
	{
	    if(PlayerData[playerid][pReportMuted] > 1000)
	        return SendClientMessageEx(playerid, COLOR_GREY, "You are indefinitely muted from submitting reports. /unmute to unmute yourself.");
	    else
	        return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from submitting reports. Your mute is lifted in %i hours.", PlayerData[playerid][pReportMuted]);
	}
    if (gettime() - PlayerData[playerid][pLastReport] < 120)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only submit one report every 120 seconds. Please wait %i more seconds.", 120 - (gettime() - PlayerData[playerid][pLastReport]));
    }
    if (PlayerData[playerid][pActiveReport] >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have an active report which needs to be closed first. Use /cr to close it.");
    }
    if (!AddReportToQueue(playerid, params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The report queue is currently full. Please try again later.");
    }

    SendClientMessage(playerid, COLOR_GREY, "Thank you for reporting, an admin will view it shortly, please be patient.");
    return 1;
}

//static PlayerReportType[MAX_PLAYERS][24];
//static PlayerReportSubject[MAX_PLAYERS][24];

/*
Dialog:DlgReportType(playerid, response, listitem, inputtext[])
{

	if (response && listitem>=0)
	{
		new title[128];
		strcpy(PlayerReportType[playerid], inputtext, 24);
		format(title, sizeof(title), "Report::%s", PlayerReportType[playerid]);
		switch(listitem)
		{
			case 0: Dialog_Show(playerid, DlgReportSubject, DIALOG_STYLE_LIST, title, "RVDN\nTK\nDM\nSK\nPG\nMG\nIC OOS\nLTA\nNRCR\nFAIL DRIVE\n0 VOL\nCOP BAITING\nNo RP behavior\nVDM\nFORCE RP\nRandom shooting\nLAST LIFE\nRandom pushing", "Select", "Cancel");
			case 1: Dialog_Show(playerid, DlgReportSubject, DIALOG_STYLE_LIST, title, "Speed hack\nHealth hack\nVehicle hack\nWeapon hack\nCar warping\nFakeKill Flood\nTrollboss\nFake Lags\nGod mod\nOther", "Select", "Cancel");
			case 2: Dialog_Show(playerid, DlgReportSubject, DIALOG_STYLE_LIST, title, "Falling from sky\nCannot move\nInterior issue\nLost stuff\nOther", "Select", "Cancel");
			case 3: Dialog_Show(playerid, DlgReportSubject, DIALOG_STYLE_LIST, title, "Bugged HQ\nRequest HQ move\nGang without stash\nGang without HQ\nOther request", "Select", "Cancel");
			case 4: Dialog_Show(playerid, DlgReportSubject, DIALOG_STYLE_LIST, title, "Bugged HQ\nRequest HQ move\nFaction without locker\nFaction without HQ\nOther request", "Select", "Cancel");
			case 5: Dialog_Show(playerid, DlgReportSubject, DIALOG_STYLE_LIST, title, "Power admin[Teleport]\nPower admin[Revive]\nPower admin[Weapon]\nOther report", "Select", "Cancel");
		}
	}
	return 1;
}

Dialog:DlgReportSubject(playerid, response, listitem, inputtext[])
{
	if (response && listitem >= 0)
	{
		new title[128];
		strcpy(PlayerReportSubject[playerid], inputtext, 24);
		format(title, sizeof(title), "Report::%s::%s", PlayerReportType[playerid], PlayerReportSubject[playerid]);
		Dialog_Show(playerid, DlgReportDetails, DIALOG_STYLE_INPUT, title, "Please enter the player name or write more details about your issue.", "Submit", "Cancel");
	}
	return 1;
}

Dialog:DlgReportDetails(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		if(isnull(inputtext) || strlen(inputtext) < 5)
		{
			new title[128];
			format(title, sizeof(title), "Report::%s::%s", PlayerReportType[playerid], PlayerReportSubject[playerid]);
			Dialog_Show(playerid, DlgReportDetails, DIALOG_STYLE_INPUT, title, "Please enter the player name or write more details about your issue.", "Submit", "Cancel");
		}
		else
		{
			new details[128];
			format(details, sizeof(details), "[%s::%s] %s", PlayerReportType[playerid], PlayerReportSubject[playerid], inputtext);
			if(!AddReportToQueue(playerid, details))
			{
				return SendClientMessage(playerid, COLOR_GREY, "The report queue is currently full. Please try again later.");
			}
			
			SendClientMessage(playerid, COLOR_GREY, "Thank you for reporting, an admin will view it shortly, please be patient.");
		}
	}
	return 1;
}*/