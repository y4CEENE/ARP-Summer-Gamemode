#include <YSI\y_hooks>

static Text:gReportStats[2];
static OldReportsCount = 0;

hook OnGameModeInit()
{
    gReportStats[0] = TextDrawCreate(500.000000, 290.000000, "0_Reports");
    TextDrawLetterSize(gReportStats[0], 0.400000, 1.600000);
    TextDrawAlignment(gReportStats[0], 1);
    TextDrawColor(gReportStats[0], 8388863);
    TextDrawSetShadow(gReportStats[0], 0);
    TextDrawSetOutline(gReportStats[0], 1);
    TextDrawBackgroundColor(gReportStats[0], 255);
    TextDrawFont(gReportStats[0], 2);
    TextDrawSetProportional(gReportStats[0], 1);

    gReportStats[1] = TextDrawCreate(470.000000, 285.000000, "LD_SHTR:ps1");
    TextDrawTextSize(gReportStats[1], 24.000000, 24.000000);
    TextDrawAlignment(gReportStats[1], 1);
    TextDrawColor(gReportStats[1], -1);
    TextDrawSetShadow(gReportStats[1], 0);
    TextDrawBackgroundColor(gReportStats[1], 255);
    TextDrawFont(gReportStats[1], 4);
    TextDrawSetProportional(gReportStats[1], 0);

    return 1;
}

hook OnPlayerLoaded(playerid)
{
    if(IsAdmin(playerid))
    {
	    TextDrawShowForPlayer(playerid, gReportStats[0]);
	    TextDrawShowForPlayer(playerid, gReportStats[1]);
    }
    return 1;
}

hook OnServerHeartBeat(timestamp)
{
    new count = 0;
    for(new x = 0; x < MAX_REPORTS; x ++)
	{
	    if(ReportInfo[x][rExists] && !ReportInfo[x][rAccepted])
	    {
            count++;
        }
    }
    if(count == OldReportsCount)
    {
        return 1;
    }

    new string[128];

    if(count >= 10)
    {
        format(string, sizeof(string), "~r~%i_Reports",count);
    }
    else if(count > 0)
    {
        format(string, sizeof(string), "~y~%i_Reports",count);
    }
    else
    {
        format(string, sizeof(string), "~g~%i_Reports",count);
    }

    TextDrawSetString(gReportStats[0], string);

    if(count == 0)
    {
    	TextDrawSetString(gReportStats[1], "LD_SHTR:ps1");
    }
    else if(count < 10 && (OldReportsCount >= 10 || OldReportsCount == 0))
    {
    	TextDrawSetString(gReportStats[1], "LD_SHTR:ps2");
    }
    else if(OldReportsCount < 10)
    {
    	TextDrawSetString(gReportStats[1], "LD_SHTR:ps3");
    }

    OldReportsCount = count;
    return 1;
}