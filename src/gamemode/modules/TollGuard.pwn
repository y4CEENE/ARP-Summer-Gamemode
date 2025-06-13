/// @file      Toll Gurad.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2024-04-20
/// @copyright Copyright (c) 2024

#include <YSI\y_hooks>

// Toll Gurad System
new BorderA;
new BorderB;
new BorderC;
new BorderD;
new BorderE;
new BorderF;

forward Toll_GA();
forward Toll_GB();

public Toll_GA()
{
      DestroyDynamicObject( BorderC );
	  BorderA = CreateDynamicObject(968, 68.350845, -1529.320434, 4.620820, -8.999996, -89.199966, -91.999946, -1, -1, -1, 300.00, 300.00);
      BorderB = 0;
      return 1;
}
public Toll_GB()
{
      DestroyDynamicObject( BorderF );
      BorderD = CreateDynamicObject(968, 67.927520, -1538.493041, 4.899230, 0.400002, 88.300018, -90.999969, -1, -1, -1, 300.00, 300.00);
      BorderE = 0;
      return 1;
}

hook OnGameModeInit()
{
    // Toll Gurad system
    BorderA = CreateDynamicObject(968, 68.350845, -1529.320434, 4.620820, -8.999996, -89.199966, -91.999946, -1, -1, -1, 300.00, 300.00);
    BorderD = CreateDynamicObject(968, 67.927520, -1538.493041, 4.899230, 0.400002, 88.300018, -90.999969, -1, -1, -1, 300.00, 300.00);

    CreateDynamic3DTextLabel("Type /pass to open the toll gate\nCost: $3.000",COLOR_YELLOW, 68.275039,-1526.703491,4.855343,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Type /pass to open the toll gate\nCost: $3.000",COLOR_YELLOW, 67.885612,-1541.576293,5.024459,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
}

CMD:pass(playerid, params[])
{
	new tgcash=3000;
	if(PlayerData[playerid][pCash] < tgcash)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to pay for the toll");
	}
 	if (IsPlayerInRangeOfPoint(playerid, 7, 68.275039, -1526.703491, 4.855343))
	{
		if(BorderB == 1) { SCM(playerid, COLOR_GREY, "The toll is opened."); return 1; }
   		DestroyDynamicObject( BorderA );
 		BorderC = CreateDynamicObject(968, 68.350845, -1529.320434, 4.620820, -3.999995, 0.800032, -96.999946, -1, -1, -1, 300.00, 300.00);
 		SetTimerEx("Toll_G1", 5000, false, "i", playerid);
   		SendClientMessageEx(playerid, COLOR_WHITE,"{00AA00}Toll Guard: {FFFFFF}The toll is now open, you have 5 seconds to pass through it.");
		BorderB = 1;
		GivePlayerCash(playerid, -tgcash);
	}
	else if (IsPlayerInRangeOfPoint(playerid, 7, 67.885612, -1541.576293, 5.024459))
	{
		if(BorderE == 1) { SendClientMessage(playerid, COLOR_GREY, "The toll is opened."); return 1; }
   		DestroyDynamicObject( BorderD );
 		BorderF = CreateDynamicObject(968, 67.927520, -1538.493041, 4.899230, 0.400002, -1.699981, -90.999969, -1, -1, -1, 300.00, 300.00);
 		SetTimerEx("Toll_G2", 5000, false, "i", playerid);
   		SendClientMessageEx(playerid, COLOR_WHITE,"{00AA00}Toll Guard: {FFFFFF}The toll is now open, you have 5 seconds to pass through it.");
		BorderE = 1;
		GivePlayerCash(playerid, -tgcash);
	}
 	return 1;
}
