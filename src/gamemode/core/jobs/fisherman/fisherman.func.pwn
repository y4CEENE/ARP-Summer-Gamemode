#include <YSI\y_hooks>

hook OnLoadGameMode(timestamp)
{
	new string[128];
    	//Fisher Net
	SetTimer("fishsPrices", 2000, true); 
	format(string, sizeof string, "{33CCFF}Type '/net' to purchase \n\n{33CCFF}A Fishing Net");	
	CreateDynamic3DTextLabel(string, COLOR_YELLOW, FisherNet[0], FisherNet[1], FisherNet[2], 10.0, .testlos = 1, .streamdistance = 10.0);
	CreateDynamicPickup(1239, 1, FisherNet[0], FisherNet[1], FisherNet[2]);
	
	//Fish biz door
	CreateDynamicObject(1522, 394.50470, -2052.61890, 6.80930,   0.00000, 0.00000, 270.00000);
    return 1;
    
}

forward fishsPrices(playerid, type);
public fishsPrices(){
	new string[512];
	new weatherscore = GetWeatherScore();
	new dolphinprice = FishPrices[0] * weatherscore;
	new sharkprice 	 = FishPrices[1] * weatherscore;
	new crabprice 	 = FishPrices[2] * weatherscore;
	format(string, sizeof(string), "Dolphin: $%d~n~Shark: $%d~n~Crab: $%d", dolphinprice, sharkprice,crabprice);
	
	foreach(new playerid : Player)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5, FisherNet[0], FisherNet[1], FisherNet[2]))
		{
			GameTextForPlayer(playerid, string, 5000, 3);
		}
	}
}
GetWeatherScore()
{
	switch(GetDBWeatherID())
	{
		case 0..7 : 	{ return 5;} 	 //Blue skies		
		case 8 : 		{ return 2;}	 //Stormy
		case 9 : 		{ return 3;}	 // Cloudy and foggy
		case 10 : 		{ return 5;}	 // Clear blue sky
		case 11 : 		{ return 3;}	 //Heatwave
		case 12..15 : 	{ return 3;}	 //Dull, colourless
		case 16 : 		{ return 3;}	 //Dull, cloudy ,rainy
		case 17..18 : 	{ return 3;}	 //Heatwave
		case 19 : 		{ return 1;}	 //Sandstorm
		case 20 : 		{ return 2;}	 //Foggy, Greenish
		case 21 : 		{ return 2;}	 //Very dark, gradiented skyline, purple
		case 22 : 		{ return 2;}	 //Very dark, gradiented skyline, purple
		case 23..26 : 	{ return 4;}	 //Pale orange
		case 27..29 : 	{ return 3;}	 //Fresh blue
		case 30..32 : 	{ return 2;}	 //Dark, cloudy, teal
		case 33 : 		{ return 2;}	 //Dark, cloudy, brown
		case 34 : 		{ return 5;}	 //Blue/purple, regular
		case 35 : 		{ return 3;}	 //Dull brown
		case 36..38 : 	{ return 4;}	 //Bright, foggy, orange
		case 39 : 		{ return 4;}	 //Very bright
		case 40..42 : 	{ return 3;}	 //Blue/purple cloudy
		case 43 : 		{ return 2;}	 //Toxic clouds
		case 44 : 		{ return 1;}	 //Black/white sky
		case 51..53 : 	{ return 3;}	 //Amazing draw distance
		case 700 : 		{ return 1;}	 //Stormy weather with pink sky and crystal water
		case 150 : 		{ return 1;}	 //Darkest weather ever
	}
	return 0;
	
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
		switch(PlayerData[playerid][pCP])
		{
			case CHECKPOINT_FISHER:
			{
				if(IsPlayerInRangeOfPoint(playerid, 20, 724, -1510, -0.22))
				{
					new weatherscore = GetWeatherScore();
					new dolphinprice = FishPrices[0] * weatherscore * PlayerData[playerid][pDolphinWeight];
					new sharkprice 	 = FishPrices[1] * weatherscore * PlayerData[playerid][pSharkWeight];
					new crabprice 	 = FishPrices[2] * weatherscore * PlayerData[playerid][pCrabWeight];
					PlayerData[playerid][pCP]=CHECKPOINT_NONE;
					DisablePlayerRaceCheckpoint(playerid);
					PlayerData[playerid][pCash] += dolphinprice + sharkprice + crabprice;
					PlayerData[playerid][pDolphinWeight]=0;
					PlayerData[playerid][pDolphinCount]=0;
					PlayerData[playerid][pSharkWeight]=0;
					PlayerData[playerid][pSharkCount]=0;
					PlayerData[playerid][pCrabWeight]=0;
					PlayerData[playerid][pCrabCount]=0;
					PlayerData[playerid][pNetSize]=0;
					if(PlayerData[playerid][pDolphinWeight])
						SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d kg of Dolphin for $%d.",PlayerData[playerid][pDolphinWeight],dolphinprice);
					if(PlayerData[playerid][pSharkWeight])
						SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d kg of Shark for $%d.",PlayerData[playerid][pSharkWeight],sharkprice);
					if(PlayerData[playerid][pCrabWeight])						
						SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d kg of Crab for $%d.",PlayerData[playerid][pCrabWeight],crabprice );
					SendClientMessageEx(playerid, COLOR_AQUA, "You sold all catched fishes and you got $%d.",crabprice + sharkprice + dolphinprice );
                    GivePlayerRankPointLegalJob(playerid, 500);
					IncreaseJobSkill(playerid, JOB_FISHERMAN);
				}else{
					
					GameTextForPlayer(playerid, "REELING IN FISH...~n~PLEASE WAIT.", 5000, 3);
					TogglePlayerControllableEx(playerid, 0);
					SetTimerEx("fisherwait", 5000, false, "i", playerid);
					DisablePlayerRaceCheckpoint(playerid);
				}
			}
			case CHECKPOINT_RACE:
			{
				if(PLAYER_IN_RACE[playerid] && RACE_STARTED == 1 && RACE_EVENT_ACTIVE == 1 && IsPlayerInAnyVehicle(playerid) && RACE_COUNT_DOWN <= 1)
				{
						OnPlayerEnterCP(playerid);
				}
			}
		}
		return 1;
}
forward fisherwait(playerid);
public fisherwait(playerid)
{	
	//ShowPlayerFooter(playerid, "Truck was Loaded....~n~Deliver it to the destination business.");
	TogglePlayerControllableEx(playerid, 1);
	new DolphinWeight 	= Random(1,40);
	new DolphinCount 	= Random(1,20);
	new SharkWeight 	= Random(1,20);
	new SharkCount 		= Random(1,20);
	new CrabWeight 		= Random(1,20);
	new CrabCount 		= Random(1,20);

	PlayerData[playerid][pDolphinWeight]+= DolphinWeight;
	PlayerData[playerid][pDolphinCount]	+= DolphinCount;
	PlayerData[playerid][pSharkWeight]	+= SharkWeight;
	PlayerData[playerid][pSharkCount]	+= SharkCount;
	PlayerData[playerid][pCrabWeight]	+= CrabWeight;
	PlayerData[playerid][pCrabCount]	+= CrabCount;
	
	SendClientMessageEx(playerid, COLOR_AQUA, "You catched %d Dolphin weighting %d Kg.",DolphinCount,DolphinWeight);
	SendClientMessageEx(playerid, COLOR_AQUA, "You catched %d Shark weighting %d Kg.",SharkCount,SharkWeight);
	SendClientMessageEx(playerid, COLOR_AQUA, "You catched %d Crab weighting %d Kg.",CrabCount,CrabWeight );
	
	if(PlayerData[playerid][pNetSize] <= PlayerData[playerid][pDolphinWeight] + PlayerData[playerid][pSharkWeight] + PlayerData[playerid][pCrabWeight])
	{
		PlayerData[playerid][pCP] = CHECKPOINT_FISHER;
		SetPlayerRaceCheckpoint(playerid,2,724, -1510, 0,0,0,0,10.0);		
		SendClientMessage(playerid, COLOR_AQUA, "You net is full now return to Santa Marina to get your paid.");		
	}else 
	{
	
		PlayerData[playerid][pCP] = CHECKPOINT_FISHER;
		new x = Random(5000 + FisherZone[0],5000 + FisherZone[2]) - 5000;
		new y = Random(5000 + FisherZone[1],5000 + FisherZone[3]) - 5000;
		SetPlayerRaceCheckpoint(playerid,2,x,y,0,0,0,0,10.0);
	}
}
