/// @file      Job_Recycle.pwn
/// @author    Khalil
/// @date      Created at 2025-04-06 22:00:10
/// @copyright Copyright (c) 2025

// This Part Sent To Job_Trucker.pwn
/*hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_RECYCLE)
        return 1;
    TogglePlayerControllable(playerid, 0);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
	GameTextForPlayer(playerid, "~w~Getting box...", 5000, 3);
	SetTimerEx("RecycleCheck", 5000, false, "i", playerid);

    if (type != CHECKPOINT_RECYCLE2)
        return 1;
    new str[2000], coordsstring[286];
	new amount1 = 5 + random(7);
	new amount2 = 2 + random(5);
	new amount3 = 10 + random(3);
	new amount4 = 5 + random(2);
	new amount5 = 6 + random(8);
	new amount6 = 1000 + random(400);
	
	PlayerData[playerid][pGlassItem] += amount1;
	PlayerData[playerid][pMetalItem] += amount2;
	PlayerData[playerid][pRubberItem] += amount3;
	PlayerData[playerid][pIronItem] += amount4;
	PlayerData[playerid][pPlasticItem] += amount5;
	GivePlayerCash(playerid, amount6);

	ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);

	ShowPlayerFooter(playerid, "~y~Recycle~n~~w~earned");
	format(coordsstring, sizeof(coordsstring), "_____________ Box Items _______________\n");
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Glass: {33CC33}+%i\n", PlayerData[playerid][pGlassItem]);
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Metal: {33CC33}+%i\n", PlayerData[playerid][pMetalItem]);
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Rubber: {33CC33}+%i\n", PlayerData[playerid][pRubberItem]);
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Iron: {33CC33}+%i\n", PlayerData[playerid][pIronItem]);
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Plastic: {33CC33}+%i\n", PlayerData[playerid][pPlasticItem]);
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Money: {33CC33}+%i\n", PlayerData[playerid][pCash]);
	strcat(str, coordsstring);
	format(coordsstring, sizeof(coordsstring), "______________________________________\n");
	strcat(str, coordsstring);
	ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Recycle Earned", str, "Okay", "");
	//PlayerData[playerid][pCP] = CHECKPOINT_NONE;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
	DBQuery("UPDATE "#TABLE_USERS" SET glassitem = %i, metalitem = %i, rubberitem = %i, ironitem = %i, plasticitem = %i where uid = %d", PlayerData[playerid][pGlassItem], PlayerData[playerid][pMetalItem], PlayerData[playerid][pRubberItem], PlayerData[playerid][pIronItem], PlayerData[playerid][pPlasticItem], PlayerData[playerid][pID]);
	DisablePlayerCheckpoint(playerid);
    return 1;
}*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PlayerHasJob(playerid, JOB_RECYCLE))
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, -2075.657226, -2438.935058, 30.625000))
		{
			//DisablePlayerCheckpoint(playerid);
			switch(random(3))
			{
				case 0: SetActiveCheckpoint(playerid, CHECKPOINT_RECYCLE, -2059.883544, -2443.421386, 30.625000, 2.0);
				case 1: SetActiveCheckpoint(playerid, CHECKPOINT_RECYCLE, -2065.359619, -2431.621093, 30.625000, 2.0);
				case 2: SetActiveCheckpoint(playerid, CHECKPOINT_RECYCLE, -2077.679443, -2423.071777, 30.625000, 2.0);
			}
			//PlayerData[playerid][pCP] = CHECKPOINT_RECYCLE;
		}
	}
    return 1;
}

// Recycle

forward RecycleCheck(playerid);
public RecycleCheck(playerid)
{
	//PlayerData[playerid][pCP] = CHECKPOINT_RECYCLE2;
	TogglePlayerControllable(playerid, 1);
	SendClientMessage(playerid, COLOR_AQUA, "Drop it to the checkpoint");
	SetActiveCheckpoint(playerid, CHECKPOINT_RECYCLE2, -2116.918701, -2413.947753, 31.226562, 2.0);
    return 1;
}