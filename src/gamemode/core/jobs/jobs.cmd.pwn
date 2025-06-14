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

CMD:join(playerid, params[])
{
	for(new i = 0; i < sizeof(jobLocations); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
	    {
			new string[140];
	        if(PlayerData[playerid][pJob] != JOB_NONE)
	        {
	            if(PlayerData[playerid][pDonator] >= 2 || PlayerData[playerid][pLevel] >= 25)
	        	{
	        	    if(PlayerData[playerid][pSecondJob] != JOB_NONE)
	        	    {
	        	        return SendClientMessage(playerid, COLOR_GREY, "You have two jobs already. Please quit one of them before getting another one.");
	        	    }
	        	    if(PlayerData[playerid][pJob] == jobLocations[i][jobID])
	        	    {
	        	        return SendClientMessage(playerid, COLOR_GREY, "You have this job already.");
	        	    }
					format(string, sizeof(string), "Are you sure to become a {FBBC05}%s{FFFFFF}.", jobLocations[i][jobName]);
					Dialog_Show(playerid, JobJoinConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
	            }
	            else
	            {
	            	SendClientMessage(playerid, COLOR_GREY, "You have a job already. Please quit your current job before getting another one.");
				}

				return 1;
			}
			
			format(string, sizeof(string), "Are you sure to become a {FBBC05}%s{FFFFFF}.", jobLocations[i][jobName]);
			Dialog_Show(playerid, JobJoinConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
            return 1;

		}

	}
	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any job icon.");
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
			if(PlayerData[playerid][pSecondJob] == JOB_NONE)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have a job in this slot which you can quit.");
			}

			format(string, sizeof(string), "Are you sure to quit the job {FBBC05}%s{FFFFFF}.", GetJobName(PlayerData[playerid][pSecondJob]));
			Dialog_Show(playerid, JobQuitConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
			
		}
		default:
		{
			// First job
			if(PlayerData[playerid][pJob] == JOB_NONE)
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
