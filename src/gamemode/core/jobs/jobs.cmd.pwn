#include "core\jobs\lawyer\lawyer.cmd.pwn"
#include "core\jobs\miner\miner.cmd.pwn"
#include "core\jobs\trucker\trucker.cmd.pwn"
#include "core\jobs\mechanic\mechanic.cmd.pwn"
#include "core\jobs\craftman\craftman.cmd.pwn"
#include "core\jobs\hooker\hooker.cmd.pwn"
#include "core\jobs\bartender\bartender.cmd.pwn"
#include "core\jobs\lumberjack\lumberjack.cmd.pwn"

CMD:asellbiz(playerid, params[])
{
	new businessid;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellbiz [businessid]");
	}
	if(!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
	}

	SetBusinessOwner(businessid, INVALID_PLAYER_ID);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold business %i.", businessid);
	return 1;
}

GetMaxPlayerJobs(playerid)
{
    if (PlayerData[playerid][pDonator] >= 55 || PlayerData[playerid][pLevel] >= 25)
    {
        return 2;
    }
    return 1;
}

CMD:join(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1396.207641,-4.224958,1000.853515))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the desk at city hall.");
    }

    return Dialog_Show(playerid, JobDialog, DIALOG_STYLE_LIST, 
        "Job Center - Choose Your Career",
        "ID: 00\t{FF9900}Job Name:{FFFFFF} Pizzaman\n\
        ID: 01\t{FF9900}Job Name:{FFFFFF} Trucker\n\
        ID: 02\t{FF9900}Job Name:{FFFFFF} Fisherman\n\
        ID: 03\t{FF9900}Job Name:{FFFFFF} Arms Dealer\n\
        ID: 04\t{FF9900}Job Name:{FFFFFF} Mechanic\n\
        ID: 05\t{FF9900}Job Name:{FFFFFF} SF Mechanic\n\
        ID: 05\t{FF9900}Job Name:{FFFFFF} Drug Dealer\n\
        ID: 05\t{FF9900}Job Name:{FFFFFF} Drug Smuggler\n\
        ID: 06\t{FF9900}Job Name:{FFFFFF} Miner\n\
        ID: 07\t{FF9900}Job Name:{FFFFFF} Taxi Driver\n\
        ID: 08\t{FF9900}Job Name:{FFFFFF} Lawyer\n\
        ID: 09\t{FF9900}Job Name:{FFFFFF} Detective\n\
        ID: 10\t{FF9900}Job Name:{FFFFFF} Garbageman\n\
        ID: 11\t{FF9900}Job Name:{FFFFFF} Farmer\n\
        ID: 12\t{FF9900}Job Name:{FFFFFF} Hooker\n\
        ID: 13\t{FF9900}Job Name:{FFFFFF} Bartender\n\
        ID: 14\t{FF9900}Job Name:{FFFFFF} Craftman\n\
        ID: 15\t{FF9900}Job Name:{FFFFFF} Forklift\n\
        ID: 16\t{FF9900}Job Name:{FFFFFF} Lumberjack\n\
        ID: 17\t{FF9900}Job Name:{FFFFFF} Construction\n\
        ID: 18\t{FF9900}Job Name:{FFFFFF} Butcher\n\
        ID: 19\t{FF9900}Job Name:{FFFFFF} Brinks\n\
        ID: 20\t{FF9900}Job Name:{FFFFFF} Recycle\n\
        ID: 21\t{FF9900}Job Name:{FFFFFF} Milker",
        "Select", "Close");
}

// Map dialog list index to actual job constants
new const JobListMap[] =
{
    JOB_PIZZAMAN,
    JOB_TRUCKER,
    JOB_FISHERMAN,
    JOB_ARMSDEALER,
    JOB_MECHANIC,
    JOB_MECHANIC,
    JOB_DRUGDEALER,
	JOB_DRUGSMUGGLER,
    JOB_MINER,
    JOB_TAXIDRIVER,
    JOB_LAWYER,
    JOB_DETECTIVE,
    JOB_GARBAGEMAN,
    JOB_FARMER,
    JOB_HOOKER,
    JOB_BARTENDER,
    JOB_CRAFTMAN,
    JOB_FORKLIFT,
    JOB_LUMBERJACK,
    JOB_CONSTRUCTION,
    JOB_BUTCHER,
    JOB_BRINKS,
    JOB_RECYCLE,
    JOB_MILKER
};

Dialog:JobDialog(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem >= 0 && listitem < sizeof(JobListMap))
        {
            return TryJoinJob(playerid, JobListMap[listitem]); // Use mapped job ID
        }
        else
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid job selection.");
        }
    }
    return 1;
}

TryJoinJob(playerid, jobid)
{
    new query[140];

    // Already has both jobs?
    if (PlayerData[playerid][pJob] != JOB_NONE && 
        PlayerData[playerid][pSecondJob] != JOB_NONE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have two jobs. Please quit one before getting another.");
    }

    // Prevent duplicate job
    if (PlayerData[playerid][pJob] == jobid || PlayerData[playerid][pSecondJob] == jobid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have this job.");
    }

    // Assign first job if empty
    if (PlayerData[playerid][pJob] == JOB_NONE)
    {
        PlayerData[playerid][pJob] = jobid;
        format(query, sizeof(query), "UPDATE "#TABLE_USERS" SET job = %i WHERE uid = %i", jobid, PlayerData[playerid][pID]);
        mysql_tquery(connectionID, query);
    }
    // Assign second job if allowed and empty
    else if (GetMaxPlayerJobs(playerid) >= 2 && PlayerData[playerid][pSecondJob] == JOB_NONE)
    {
        PlayerData[playerid][pSecondJob] = jobid;
        format(query, sizeof(query), "UPDATE "#TABLE_USERS" SET secondjob = %i WHERE uid = %i", jobid, PlayerData[playerid][pID]);
        mysql_tquery(connectionID, query);
    }
    else
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot take another job until you quit one.");
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "You are now a {ffff00}%s{ffffff}. Use /jobhelp for a list of commands related to your new job.", GetJobName(jobid));
    return 1;
}

CMD:quitjob(playerid, params[])
{
	new slot=1;

	if(PlayerData[playerid][pLevel] >= 25 || PlayerData[playerid][pDonator] >= 2)
	{
		if(sscanf(params, "i", slot))
		{
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /quitjob [1/2]");
		}
	}

	QuitJobSlot[playerid] = slot;
	new string[140];

	switch(slot)
	{
		case 2:
		{
            // Second job
            if (PlayerData[playerid][pSecondJob] == JOB_NONE)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have a job in this slot which you can quit.");
            }

			format(string, sizeof(string), "Are you sure to quit the job {FBBC05}%s{FFFFFF}.", GetJobName(PlayerData[playerid][pSecondJob]));
			Dialog_Show(playerid, JobQuitConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
			
		}
		default:
		{
            // First job
            if (PlayerData[playerid][pJob] == JOB_NONE)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have a job which you can quit.");
            }
			
			format(string, sizeof(string), "Are you sure to quit the job {FBBC05}%s{FFFFFF}.", GetJobName(PlayerData[playerid][pJob]));
			Dialog_Show(playerid, JobQuitConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
		}
	}

	return 1;
}


CMD:jobhelp(playerid, params[])
{
	if(PlayerData[playerid][pJob] == JOB_NONE && PlayerData[playerid][pSecondJob] == JOB_NONE)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You have no job and therefore no job commands to view.");
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "__________________ Job Help __________________");
    SendClientMessage(playerid, COLOR_WHITE, "** JOB HELP ** type a command for more information.");
	if(PlayerData[playerid][pJob] != JOB_NONE)
		SendClientMessage(playerid, COLOR_GREY, GetJobHelp(PlayerData[playerid][pJob]));
	if(PlayerData[playerid][pSecondJob] != JOB_NONE)
 		SendClientMessage(playerid, COLOR_GREY, GetJobHelp(PlayerData[playerid][pSecondJob]));
	return 1;
}
