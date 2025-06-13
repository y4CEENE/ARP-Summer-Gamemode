/// @file      Annoncement.pwn
/// @author    Khalil
/// @date      Created at 2025-04-07 00:05:44
/// @copyright Copyright (c) 2025

new Text:ANN[3];

hook OnGameModeInit()
{
    ANN[0] = TextDrawCreate(321.000000, 139.000000, "_");
	TextDrawFont(ANN[0], 1);
	TextDrawLetterSize(ANN[0], 0.600000, 8.949996);
	TextDrawTextSize(ANN[0], 298.500000, 748.500000);
	TextDrawSetOutline(ANN[0], 1);
	TextDrawSetShadow(ANN[0], 0);
	TextDrawAlignment(ANN[0], 2);
	TextDrawColor(ANN[0], -1);
	TextDrawBackgroundColor(ANN[0], 255);
	TextDrawBoxColor(ANN[0], 180);
	TextDrawUseBox(ANN[0], 1);
	TextDrawSetProportional(ANN[0], 1);
	TextDrawSetSelectable(ANN[0], 0);

	ANN[1] = TextDrawCreate(319.000000, 146.000000, "Announcement");
	TextDrawFont(ANN[1], 3);
	TextDrawLetterSize(ANN[1], 0.737499, 4.099997);
	TextDrawTextSize(ANN[1], 400.000000, 17.000000);
	TextDrawSetOutline(ANN[1], 0);
	TextDrawSetShadow(ANN[1], 0);
	TextDrawAlignment(ANN[1], 2);
	TextDrawColor(ANN[1], -2686721);
	TextDrawBackgroundColor(ANN[1], 255);
	TextDrawBoxColor(ANN[1], 50);
	TextDrawUseBox(ANN[1], 0);
	TextDrawSetProportional(ANN[1], 1);
	TextDrawSetSelectable(ANN[1], 0);

	ANN[2] = TextDrawCreate(319.000000, 187.000000, ""); // text
	TextDrawFont(ANN[2], 1);
	TextDrawLetterSize(ANN[2], 0.233332, 2.000000);
	TextDrawTextSize(ANN[2], 400.000000, 505.000000);
	TextDrawSetOutline(ANN[2], 0);
	TextDrawSetShadow(ANN[2], 0);
	TextDrawAlignment(ANN[2], 2);
	TextDrawColor(ANN[2], -1);
	TextDrawBackgroundColor(ANN[2], 255);
	TextDrawBoxColor(ANN[2], 50);
	TextDrawUseBox(ANN[2], 0);
	TextDrawSetProportional(ANN[2], 1);
	TextDrawSetSelectable(ANN[2], 0);
    return 1;
}

forward ANNHIDE(playerid);
public ANNHIDE(playerid)
{
	for(new i = 0; i < 3; i ++)
	{
		TextDrawHideForPlayer(playerid, ANN[i]);
	}
    return 1;
}

CMD:ann(playerid, params[])
{
	new text[128];
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
	if(sscanf(params, "s[128]", text))
	{
	    return SCM(playerid, COLOR_GREY, "Usage: /ann [text]");
	}
	foreach(new i : Player)
	{
		TextDrawSetString(ANN[2], text);
		for(new f = 0; f < 3; f ++)
		{
			TextDrawShowForPlayer(i, ANN[f]);
		}

		SetTimerEx("ANNHIDE", 5000, false, "i", i);
		PlayerPlaySound(i,1150,0.0,0.0,0.0);
	}
	return 1;
}