
CMD:racehelp(playerid)
{
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	SendClientMessage(playerid,COLOR_YELLOW,"** RACE SYSTEM : /createrace /enableraceevent /startrace	/endrace /deleterace /joinrace /topracer");
	return 1;
}

CMD:deleterace(playerid)
{
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(CREATING_RACE_CHECKPOINTS == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Some budy is already make race at a moment.");
	if(RACE_STARTED == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Please let the race finish first.");
	CREATING_RACE_CHECKPOINTS = 0;
	CP_COUNTER = 0;
	RACE_STARTED = 0;
	RACE_ADMIN_ID = -1;
	SendClientMessage(playerid,COLOR_GREEN,"You've successfully delete the race.");
	return 1;
}

CMD:createrace(playerid,params[])
{
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(CREATING_RACE_CHECKPOINTS == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Some budy is already make race at a moment.");
	if(RACE_STARTED == 1)return SendClientMessage(playerid,COLOR_GREEN,"You can't make race right now! Please let the race finish first.");
	if(sscanf(params,"i",TOTAL_RACE_CP))return SendClientMessage(playerid,COLOR_GREEN,"/createrace [Checkpoints 1-99]");
	if(0  > TOTAL_RACE_CP > 100)return SendClientMessage(playerid,COLOR_GREEN,"Checkpoint Must be greater than 0 and less than 100");
	RACE_ADMIN_ID = playerid;
	CREATING_RACE_CHECKPOINTS = 1;
	CP_COUNTER = 0;
	SendClientMessage(playerid,COLOR_GREEN,"You've to press Fire Key to create checkpoints.");
	return 1;
}

CMD:enableraceevent(playerid)
{   	
	new string[128];
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(RACE_CREATED == 0)return SendClientMessage(playerid,COLOR_GREEN,"You need to create checkpoint to start the race.");
	if(RACE_STARTED == 1)return SendClientMessage(playerid,COLOR_GREEN,"Race is already enabled .");
	RACE_STARTED = 1;
	format(string,sizeof(string),"Admin %s started race event type /joinrace to join race.",GetName(playerid));
	SendClientMessageToAll(COLOR_YELLOW,string);
	SendClientMessage(playerid,COLOR_GREEN," You've successfully turn on the race event /startrace to start the race.");
	return 1;
}

CMD:endrace(playerid)
{
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}	if(RACE_STARTED == 0)return SendClientMessage(playerid,COLOR_GREY,"There is no race going on at moment.");
	RACE_STARTED = 0;
	RACE_EVENT_ACTIVE = 0;
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE[i])
		{
            PLAYER_IN_RACE[i] = 0;
			DisablePlayerRaceCheckpoint(i);
 			RACE_CP[i] = 0;
			PlayerData[i][pCP] = CHECKPOINT_NONE;
			TogglePlayerControllableEx(i, 1);
			if(RaceVehicles[i])
				DestroyVehicleEx(RaceVehicles[i]);
			SetPlayerWeapons(i);
			SetPlayerToSpawn(i);
		}
	}
 	KillTimer(RACE_TIMER);
	SendClientMessage(playerid,COLOR_GREEN,"You've successfully stop the race.");
	return 1;
}

CMD:startrace(playerid)
{
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(RACE_STARTED == 0)return SendClientMessage(playerid,COLOR_GREEN,"There is no race going on at moment.");
	if(RACE_EVENT_ACTIVE == 1)return SendClientMessage(playerid,COLOR_GREEN,"Race event is already going on at moment.");
	RACE_EVENT_ACTIVE = 1;
	RACE_COUNT_DOWN = 15;
	SendClientMessage(playerid,COLOR_GREEN,"You've successfully started the race event.");
	RACE_TIMER = SetTimer("OnPlayerRaceCountDown",1000,1);
	return 1;
}

CMD:joinrace(playerid,params[])
{
	if(RACE_EVENT_ACTIVE == 1)return SendClientMessage(playerid,COLOR_GREY,"You're late try next time.");
	new string[128];
	if(RACE_STARTED == 1)
	{
		PLAYER_IN_RACE[playerid] = 1;
		RACE_CP[playerid] = 0;
		SavePlayerVariables(playerid);
		ResetPlayerWeapons(playerid);
		SetPlayerPos(playerid,Rx[0],Ry[0],Rz[0]);
 		SetPlayerRaceCheckpoint(playerid,1,Rx[0],Ry[0],Rz[0],0.0,0.0,0.0,CP_SIZE);
		PlayerData[playerid][pCP] = CHECKPOINT_RACE;
		Dialog_Show(playerid, DIALOG_RACE, DIALOG_STYLE_LIST, "Race Cars Menu", "Bullet\nTurismo\nSultan\nAlpha\nHotring\nSandking\nSentinel","Spawn" ,"Close");
		SendClientMessage(playerid,COLOR_GREEN,"You've successfully join the race event.");
		SendClientMessage(playerid,COLOR_GREEN,"Please wait some seconds let other racers join the race.");
		format(string,sizeof(string),"Total number of players in race %d.",TOTAL_PLAYER_IN_RACE());
		SendClientMessageToAll(-1,string);
	}
	return 1;
}

CMD:leaverace(playerid,params[])
{
	if(!PLAYER_IN_RACE[playerid])return SendClientMessage(playerid,COLOR_GREEN,"You didn't join any race yet.");
	PLAYER_IN_RACE[playerid] = 0;
	RACE_CP[playerid] = 0;
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerWeapons(playerid);
	SetPlayerToSpawn(playerid);
	TogglePlayerControllableEx(playerid, 1);
	if(RaceVehicles[playerid])
		DestroyVehicleEx(RaceVehicles[playerid]);
	SendClientMessage(playerid,COLOR_GREEN,"You've successfully left the race event.");
	return 1;
}

CMD:topracer(playerid)
{
	GetTopRacer();
	return 1;
}