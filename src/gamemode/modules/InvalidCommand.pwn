#include <YSI\y_hooks>

// - Unknown command error messages
static Text:UnknowCmdTextDraw[4];

hook OnGameModeInit()
{
    // Unknown command error messages
	UnknowCmdTextDraw[0] = TextDrawCreate(26.000000, 260.000000, "Unknown Command");
	TextDrawBackgroundColor(UnknowCmdTextDraw[0], 255);
	TextDrawFont(UnknowCmdTextDraw[0], 2);
	TextDrawLetterSize(UnknowCmdTextDraw[0], 0.160000, 1.000000);
	TextDrawColor(UnknowCmdTextDraw[0], -16776961);
	TextDrawSetOutline(UnknowCmdTextDraw[0], 0);
	TextDrawSetProportional(UnknowCmdTextDraw[0], 1);
	TextDrawSetShadow(UnknowCmdTextDraw[0], 1);
	TextDrawSetSelectable(UnknowCmdTextDraw[0], 0);

	UnknowCmdTextDraw[1] = TextDrawCreate(26.000000, 269.000000, "/help - /newb - /helpme");
	TextDrawBackgroundColor(UnknowCmdTextDraw[1], 255);
	TextDrawFont(UnknowCmdTextDraw[1], 2);
	TextDrawLetterSize(UnknowCmdTextDraw[1], 0.150000, 0.900000);
	TextDrawColor(UnknowCmdTextDraw[1], 0x33CCFFAA);
	TextDrawSetOutline(UnknowCmdTextDraw[1], 0);
	TextDrawSetProportional(UnknowCmdTextDraw[1], 1);
	TextDrawSetShadow(UnknowCmdTextDraw[1], 1);
	TextDrawSetSelectable(UnknowCmdTextDraw[1], 0);

	UnknowCmdTextDraw[2] = TextDrawCreate(167.000000, 261.000000, "New Textdraw");
	TextDrawBackgroundColor(UnknowCmdTextDraw[2], 255);
	TextDrawFont(UnknowCmdTextDraw[2], 1);
	TextDrawLetterSize(UnknowCmdTextDraw[2], 0.000000, 1.000000);
	TextDrawColor(UnknowCmdTextDraw[2], -1);
	TextDrawSetOutline(UnknowCmdTextDraw[2], 0);
	TextDrawSetProportional(UnknowCmdTextDraw[2], 1);
	TextDrawSetShadow(UnknowCmdTextDraw[2], 1);
	TextDrawUseBox(UnknowCmdTextDraw[2], 1);
	TextDrawBoxColor(UnknowCmdTextDraw[2], 96);
	TextDrawTextSize(UnknowCmdTextDraw[2], -3.000000, 0.000000);
	TextDrawSetSelectable(UnknowCmdTextDraw[2], 0);

	UnknowCmdTextDraw[3] = TextDrawCreate(7.000000, 258.000000, "?");
	TextDrawBackgroundColor(UnknowCmdTextDraw[3], 255);
	TextDrawFont(UnknowCmdTextDraw[3], 2);
	TextDrawLetterSize(UnknowCmdTextDraw[3], 0.620000, 2.499999);
	TextDrawColor(UnknowCmdTextDraw[3], 0xFF0606FF);
	TextDrawSetOutline(UnknowCmdTextDraw[3], 0);
	TextDrawSetProportional(UnknowCmdTextDraw[3], 1);
	TextDrawSetShadow(UnknowCmdTextDraw[3], 1);
	TextDrawSetSelectable(UnknowCmdTextDraw[3], 0);
}

DisplayUnknownCmdDialog(playerid)
{
    TextDrawShowForPlayer(playerid, UnknowCmdTextDraw[0]);
    TextDrawShowForPlayer(playerid, UnknowCmdTextDraw[1]);
    TextDrawShowForPlayer(playerid, UnknowCmdTextDraw[2]);
    TextDrawShowForPlayer(playerid, UnknowCmdTextDraw[3]);
    SetTimerEx("HideUnknownCommandTextDraw", 5000, false, "i", playerid);
}

forward HideUnknownCommandTextDraw(playerid);
public HideUnknownCommandTextDraw(playerid)
{
	TextDrawHideForPlayer(playerid, UnknowCmdTextDraw[0]);
	TextDrawHideForPlayer(playerid, UnknowCmdTextDraw[1]);
	TextDrawHideForPlayer(playerid, UnknowCmdTextDraw[2]);
	TextDrawHideForPlayer(playerid, UnknowCmdTextDraw[3]);
    return 1;
}


public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(result == -1)
	{
    	DisplayUnknownCmdDialog(playerid);
	 	PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
	}

	return 1;
}