// Color definitions (adjust to match your gamemode)
#define COLOR_INFO 0x3498DBFF
#define COLOR_ERROR 0xE74C3CFF

CMD:createproduct(playerid, params[])
{
	new string[128];
	
	if(PlayerData[playerid][pJobTime] > 0)
	{
		format(string, sizeof(string), "You must wait {999999}%d {FFFFFF}seconds before you can work again.", PlayerData[playerid][pJobTime]);
		return SendClientMessage(playerid, COLOR_ERROR, string);
	}
	
	if(PlayerData[playerid][pBladder] > 90) 
		return SendClientMessage(playerid, COLOR_INFO, "Your character is stressed. You cannot work.");
	
	if(PlayerData[playerid][pJob] == 6 || PlayerData[playerid][pJob2] == 6)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.79, -2148.05, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -244.14, -2146.05, 29.30)
		|| IsPlayerInRangeOfPoint(playerid, 2.0, -250.88, -2143.23, 29.32) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.74, -2141.65, 29.32))
		{
			new type;
			if(sscanf(params, "d", type)) 
				return SendClientMessage(playerid, COLOR_GREY, "USAGE: /createproduct [type] - 1.Food 2.Clothes 3.Equipment");
			
			if(type < 1 || type > 3) 
				return SendClientMessage(playerid, COLOR_ERROR, "Invalid type ID.");
			
			if(type == 1)
			{
				if(PlayerData[playerid][pActivityTime] > 5) 
					return SendClientMessage(playerid, COLOR_ERROR, "You still have an activity in progress!");
				if(PlayerData[playerid][pFood] < 40) 
					return SendClientMessage(playerid, COLOR_ERROR, "Not enough food! (Minimum: 40)");
				if(PlayerData[playerid][CarryProduct] != 0) 
					return SendClientMessage(playerid, COLOR_ERROR, "You are already carrying a product.");
				
				PlayerData[playerid][pFood] -= 40;
				
				TogglePlayerControllable(playerid, 0);
				SendClientMessage(playerid, COLOR_INFO, "You are producing food with 40 food materials!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				PlayerData[playerid][pProductingStatus] = 1;
				PlayerData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 1);
			}
			else if(type == 2)
			{
				if(PlayerData[playerid][pActivityTime] > 5) 
					return SendClientMessage(playerid, COLOR_ERROR, "You still have an activity in progress!");
				if(PlayerData[playerid][pMaterial] < 40) 
					return SendClientMessage(playerid, COLOR_ERROR, "Not enough material! (Required: 40)");
				if(PlayerData[playerid][CarryProduct] != 0) 
					return SendClientMessage(playerid, COLOR_ERROR, "You are already carrying a product.");
				
				PlayerData[playerid][pMaterial] -= 40;
				
				TogglePlayerControllable(playerid, 0);
				SendClientMessage(playerid, COLOR_INFO, "You are producing clothes with 40 materials!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				PlayerData[playerid][pProductingStatus] = 1;
				PlayerData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 2);
			}
			else if(type == 3)
			{
				if(PlayerData[playerid][pActivityTime] > 5) 
					return SendClientMessage(playerid, COLOR_ERROR, "You still have an activity in progress!");
				if(PlayerData[playerid][pMaterial] < 40) 
					return SendClientMessage(playerid, COLOR_ERROR, "Not enough material! (Required: 40)");
				if(PlayerData[playerid][pComponent] < 20) 
					return SendClientMessage(playerid, COLOR_ERROR, "Not enough components! (Required: 20)");
				if(PlayerData[playerid][CarryProduct] != 0) 
					return SendClientMessage(playerid, COLOR_ERROR, "You are already carrying a product.");
				
				PlayerData[playerid][pMaterial] -= 40;
				PlayerData[playerid][pComponent] -= 20;
				
				TogglePlayerControllable(playerid, 0);
				SendClientMessage(playerid, COLOR_INFO, "You are producing equipment with 40 materials and 20 components!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				PlayerData[playerid][pProductingStatus] = 1;
				PlayerData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 3);
				ShowPlayerProgressBar(playerid, PlayerData[playerid][activitybar]);
			}
		}
		else 
			return SendClientMessage(playerid, COLOR_ERROR, "You're not near the production warehouse.");
	}
	else 
		SendClientMessage(playerid, COLOR_ERROR, "You are not a production operator.");
	
	return 1;
}

function CreateProduct(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(PlayerData[playerid][pProductingStatus] != 1) return 0;
	if(PlayerData[playerid][pJob] == 6 || PlayerData[playerid][pJob2] == 6)
	{
		if(PlayerData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.79, -2148.05, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -244.14, -2146.05, 29.30)
			|| IsPlayerInRangeOfPoint(playerid, 2.0, -250.88, -2143.23, 29.32) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.74, -2141.65, 29.32))
			{
				if(type == 1)
				{
					SetPlayerAttachedObject(playerid, 9, 2453, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					PlayerData[playerid][CarryProduct] = 1;
					SendClientMessage(playerid, COLOR_INFO, "You have successfully created food materials. Use /sellproduct to sell them.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Food Created!");
					KillTimer(PlayerData[playerid][pProducting]);
					PlayerData[playerid][pActivityTime] = 0;
					PlayerData[playerid][pProductingStatus] = 0;
					PlayerData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else if(type == 2)
				{
					SetPlayerAttachedObject(playerid, 9, 2391, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					PlayerData[playerid][CarryProduct] = 2;
					SendClientMessage(playerid, COLOR_INFO, "You have successfully created clothes. Use /sellproduct to sell them.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Clothes Created!");
					KillTimer(PlayerData[playerid][pProducting]);
					PlayerData[playerid][pActivityTime] = 0;
					PlayerData[playerid][pProductingStatus] = 0;
					PlayerData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else if(type == 3)
				{
					SetPlayerAttachedObject(playerid, 9, 2912, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					PlayerData[playerid][CarryProduct] = 3;
					SendClientMessage(playerid, COLOR_INFO, "You have successfully created equipment. Use /sellproduct to sell it.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Equipment Created!");
					KillTimer(PlayerData[playerid][pProducting]);
					PlayerData[playerid][pActivityTime] = 0;
					PlayerData[playerid][pProductingStatus] = 0;
					PlayerData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else
				{
					KillTimer(PlayerData[playerid][pProducting]);
					PlayerData[playerid][pActivityTime] = 0;
					PlayerData[playerid][pProductingStatus] = 0;
					HidePlayerProgressBar(playerid, PlayerData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		}
		else if(PlayerData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.79, -2148.05, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -244.14, -2146.05, 29.30)
			|| IsPlayerInRangeOfPoint(playerid, 2.0, -250.88, -2143.23, 29.32) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.74, -2141.65, 29.32))
			{
				PlayerData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, PlayerData[playerid][activitybar], PlayerData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

CMD:sellproduct(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -279.67, -2148.42, 28.54)) 
		return SendClientMessage(playerid, COLOR_ERROR, "You are not near the warehouse.");
	
	if(PlayerData[playerid][CarryProduct] == 0) 
		return SendClientMessage(playerid, COLOR_ERROR, "You are not carrying any product.");
	
	new string[128];
	
	if(PlayerData[playerid][CarryProduct] == 1)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		PlayerData[playerid][CarryProduct] = 0;
		GivePlayerCash(playerid, 500);
		
		Product += 10;
		Server_MinMoney(500);
		
		format(string, sizeof(string), "You sold 10 food materials for {2ECC71}$500");
		SendClientMessage(playerid, COLOR_INFO, string);
		PlayerData[playerid][pJobTime] += 60;
	}
	else if(PlayerData[playerid][CarryProduct] == 2)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		PlayerData[playerid][CarryProduct] = 0;
		GivePlayerCash(playerid, 550);
		
		Product += 10;
		Server_MinMoney(550);
		
		format(string, sizeof(string), "You sold 10 clothes for {2ECC71}$550");
		SendClientMessage(playerid, COLOR_INFO, string);
		PlayerData[playerid][pJobTime] += 60;
	}
	else if(PlayerData[playerid][CarryProduct] == 3)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		PlayerData[playerid][CarryProduct] = 0;
		GivePlayerCash(playerid, 630);
		
		Product += 10;
		Server_MinMoney(630);
		
		format(string, sizeof(string), "You sold 10 equipment for {2ECC71}$630");
		SendClientMessage(playerid, COLOR_INFO, string);
		PlayerData[playerid][pJobTime] += 60;
	}
	return 1;
}