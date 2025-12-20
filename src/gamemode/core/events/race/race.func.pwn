Dialog:DIALOG_RACE(playerid, response, listitem, inputtext[])
{
	switch(listitem)
	{
			case 0:CreateRaceVehicle(playerid,541);
			case 1:CreateRaceVehicle(playerid,451);
			case 2:CreateRaceVehicle(playerid,560);
			case 3:CreateRaceVehicle(playerid,602);
			case 4:CreateRaceVehicle(playerid,494);
			case 5:CreateRaceVehicle(playerid,495);
			case 6:CreateRaceVehicle(playerid,405);
	}
}

CreateRaceVehicle(playerid,vehicleid)
{
	new Float:pX,Float:pY,Float:pZ,Float:pw;
	GetPlayerPos(playerid, pX,pY,pZ);
	GetPlayerFacingAngle(playerid, pw);
	RaceVehicles[playerid] = CreateVehicle(vehicleid, pX, pY, pZ, pw, 0, 0, 0);
	PutPlayerInVehicle(playerid, RaceVehicles[playerid], 0);
	FREEZE_PLAYER[playerid] = SetTimerEx("RaceOnPlayerFreezed",10000,0,"i",playerid);
	SendClientMessage(playerid,COLOR_GREEN,"You've 10 seconds to set your vehicle position.");
	return 1;
}

forward RaceOnPlayerFreezed(playerid);
public RaceOnPlayerFreezed(playerid)
{
	SendClientMessage(playerid,COLOR_GREEN,"You're freezed now! Please wait other member to join the race.");
	KillTimer(FREEZE_PLAYER[playerid]);
	TogglePlayerControllableEx(playerid, 0);
	return 1;
}

OnPlayerEnterCP(playerid)
{
	for(new i = RACE_CP[playerid]; i <= TOTAL_RACE_CP ; i++)
	{
		if(RACE_CP[playerid] == TOTAL_RACE_CP )
		{
			new cashAmount = Cash[random(5)];
			new string[128];
		    format(string,sizeof(string),"Congratulation %s has completed the race at First Position and won %d",GetName(playerid),cashAmount);
			SendClientMessageToAll(COLOR_YELLOW,string);
			GivePlayerCash(playerid,cashAmount);
		    RACE_STARTED = 0;
			RACE_EVENT_ACTIVE = 0;
			foreach(new a : Player)
			{
				if(PLAYER_IN_RACE[a])
				{
					PLAYER_IN_RACE[a] = 0;
					RACE_CP[a] = 0;
					DisablePlayerRaceCheckpoint(a);
					PlayerData[a][pCP] = CHECKPOINT_NONE;
					SetPlayerWeapons(a);
					SetPlayerToSpawn(a);
					if(RaceVehicles[a])
						DestroyVehicleEx(RaceVehicles[a]);
				}
			}
			PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
			break;
		}
		else
		{
			new string[128];
			format(string,sizeof(string),"~y~You've successfully ~n~~r~captured %d checkpoints ~n~~b~Total CP (%d | 14) ",RACE_CP[playerid],RACE_CP[playerid]);
  			GameTextForPlayer(playerid,string,1000,5);
			DisablePlayerRaceCheckpoint(playerid);
 			SetPlayerRaceCheckpoint(playerid,1,Rx[i],Ry[i],Rz[i],0.0,0.0,0.0,CP_SIZE);
			PlayerData[playerid][pCP]=CHECKPOINT_RACE;
			PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
   			RACE_CP[playerid]++;
   			GetTopRacer();
			break;
		}
	}
	return 1;
}

GetName(playerid)
{
	new JName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,JName,MAX_PLAYER_NAME);
	return JName;
}

GetTopRacer()
{
	new string[128],TOP_RACER;
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE[i])
		{
		    if(RACE_CP[i] > TOP_RACER)
		    {
		        TOP_RACER = RACE_CP[i];
				format(string,sizeof(string),"%s is now leading the race by capturing %d checkpoints",GetName(i),RACE_CP[i]);
				SendMessageToAllRacers(COLOR_GREEN,string);
			}
		}
	}
}

SendMessageToAllRacers(Color,string[])
{
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE[i])
		{
   			SendClientMessage(i,Color,string);
		}
	}
}

forward OnPlayerRaceCountDown();
public OnPlayerRaceCountDown()
{
	new string[128];
	RACE_COUNT_DOWN -- ;
	if(RACE_COUNT_DOWN <= 1)
	{
 		format(string, sizeof(string), "~r~RACE IS~n~~b~STARTED~n~~r~Lets~y~Go");
	    KillTimer(RACE_TIMER);
		foreach(new i : Player)
		{
			if(PLAYER_IN_RACE[i])
			{
	  			TogglePlayerControllableEx(i, 1);
		    	GameTextForPlayer(i,string,2000,3);
				PlayerPlaySound(i, 4203, 0.0, 0.0, 0.0);
			}
		}
	}
    format(string, sizeof(string), "~r~RACE IS GOING~n~~n~~y~TO~n~Start In~n~~r~%d ~y~~n~seconds.",RACE_COUNT_DOWN);
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE[i])
		{
	    	GameTextForPlayer(i,string,1000,3);
			PlayerPlaySound(i, 4203, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

TOTAL_PLAYER_IN_RACE()
{
	new count;
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE[i])
		{
			count++;
		}
	}
	return count;
}