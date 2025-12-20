
#if !defined INVALID_HOUSE_ID
    #define INVALID_HOUSE_ID -1
#endif

#if !defined CHECK_RETURN
    #define CHECK_RETURN(%1,%2) if (%1) return SendClientMessage(playerid, COLOR_GREY, %2)
#endif


CMD:taxhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREY, "The tax is currently set to {33CCFF}%i percent", GetTaxPercent());
	return 1;
}
CMD:signcheck(playerid, params[])
{
	if(PayCheckCode[playerid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "There is no paycheck to sign. Please wait for the next paycheck.");

 	new string[128];

	format(string, sizeof(string), "Check code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
	Dialog_Show(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, "Sign check", string, "Sign check","Cancel");
    return 1;
}

CMD:skate(playerid,params[])
{
	if(!PlayerData[playerid][pSkates])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You do not own any skates.");
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(playerid, "CARRY","null",0,0,0,0,0,0,0);
	    ApplyAnimation(playerid, "SKATE","null",0,0,0,0,0,0,0);
	    ApplyAnimation(playerid, "CARRY","crry_prtial",4.0,0,0,0,0,0);
	    SetPlayerArmedWeapon(playerid,0);
        if(!PlayerData[playerid][pSkating])
		{
            PlayerData[playerid][pSkating] = true;
            DestroyDynamicObject(PlayerData[playerid][pSkateObj]);
            RemovePlayerAttachedObject(playerid, 5);
            SetPlayerAttachedObject(playerid, 5,19878,6,-0.055999,0.013000,0.000000,-84.099983,0.000000,-106.099998,1.000000,1.000000,1.000000);
            PlayerPlaySound(playerid,21000,0,0,0);
            SendClientMessage(playerid, COLOR_AQUA,"You have equiped your skating gear. Press RMB or Aim Key to skate.");
        }
		else
		{
			PlayerData[playerid][pSkating] = false;
            DestroyDynamicObject(PlayerData[playerid][pSkateObj]);
            RemovePlayerAttachedObject(playerid, 5);
            PlayerPlaySound(playerid,21000,0,0,0);
            SendClientMessage(playerid, COLOR_AQUA, "You are no longer skating.");
        }
	}
	else SendClientMessage(playerid, COLOR_GREY, "You must not be inside a vehicle.");
 	return 1;
}

CMD:b(playerid, params[])
{
	new string[144];
	
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /b [local OOC]");
	}

	format(string, sizeof(string), "(( [%d] %s: %s ))", playerid, GetRPName(playerid), params);
	SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

	return 1;
}

CMD:s(playerid, params[])
{
	return callcmd::shout(playerid, params);
}

CMD:shout(playerid, params[])
{
	new
	    string[144];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /(s)hout [text]");
	}

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "(Shouts) %s!", params);
	format(string, sizeof(string), "%s shouts: %s!", GetRPName(playerid), params);
	SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

	foreach(new i : House)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]))
		{
			foreach(new p : Player)
			{
				if(IsPlayerInRangeOfPoint(p, 30.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]))
				{
					if(GetPlayerVirtualWorld(p) == HouseInfo[i][hWorld])
					{
						format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	SendClientMessage(p, COLOR_GREY1, string);
			    	}
			    }
			}
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 20.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]))
	    {
	    	if(GetPlayerVirtualWorld(playerid) == HouseInfo[i][hWorld])
	    	{
		    	foreach(new p : Player)
				{
					if(IsPlayerInRangeOfPoint(p, 15.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]))
					{
						if(GetPlayerVirtualWorld(p) == 0)
					    {
					        format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	    SendClientMessage(p, COLOR_GREY1, string);
			    	    }
			    	}
			    }
			}
		}
	}
	foreach(new i : Business)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 10.0, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]))
		{
			foreach(new p : Player)
			{
				if(IsPlayerInRangeOfPoint(p, 30.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]))
				{
					if(GetPlayerVirtualWorld(p) == BusinessInfo[i][bWorld])
					{
						format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	SendClientMessage(p, COLOR_GREY1, string);
			    	}
			    }
			}
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 20.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]))
	    {
	    	if(GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bWorld])
	    	{
		    	foreach(new p : Player)
				{
					if(IsPlayerInRangeOfPoint(p, 15.0, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]))
					{
						if(GetPlayerVirtualWorld(p) == 0)
					    {
					        format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	    SendClientMessage(p, COLOR_GREY1, string);
			    	    }
			    	}
			    }
			}
		}
	}
	foreach(new i : Entrance)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, EntranceInfo[i][ePosX], EntranceInfo[i][ePosY], EntranceInfo[i][ePosZ]))
		{
			foreach(new p : Player)
			{
				if(IsPlayerInRangeOfPoint(p, 30.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]))
				{
					if(GetPlayerVirtualWorld(p) == EntranceInfo[i][eWorld])
					{
						format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	SendClientMessage(p, COLOR_GREY1, string);
			    	}
			    }
			}
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 20.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]))
	    {
	    	if(GetPlayerVirtualWorld(playerid) == EntranceInfo[i][eWorld])
	    	{
		    	foreach(new p : Player)
				{
					if(IsPlayerInRangeOfPoint(p, 15.0, EntranceInfo[i][ePosX], EntranceInfo[i][ePosY], EntranceInfo[i][ePosZ]))
					{
						if(GetPlayerVirtualWorld(p) == 0)
					    {
					        format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	    SendClientMessage(p, COLOR_GREY1, string);
			    	    }
			    	}
			    }
			}
		}
	}

	foreach(new i : Garage)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]))
		{
			foreach(new p : Player)
			{
				if(IsPlayerInRangeOfPoint(playerid, 30.0, garageInteriors[GarageInfo[i][gType]][intVX], garageInteriors[GarageInfo[i][gType]][intVY], garageInteriors[GarageInfo[i][gType]][intVZ]))
				{
					if(GetPlayerVirtualWorld(p) == GarageInfo[i][gWorld])
					{
						format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	SendClientMessage(p, COLOR_GREY1, string);
			    	}
			    }
			}
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 20.0, garageInteriors[GarageInfo[i][gType]][intVX], garageInteriors[GarageInfo[i][gType]][intVY], garageInteriors[GarageInfo[i][gType]][intVZ]))
	    {
	    	if(GetPlayerVirtualWorld(playerid) == GarageInfo[i][gWorld])
	    	{
		    	foreach(new p : Player)
				{
					if(IsPlayerInRangeOfPoint(p, 15.0, GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]))
					{
						if(GetPlayerVirtualWorld(p) == 0)
					    {
					        format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
			        	    SendClientMessage(p, COLOR_GREY1, string);
			    	    }
			    	}
			    }
			}
		}
	}

	return 1;
}

CMD:my(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /my [action]");
	}

	if(strlen(params) > MAX_SPLIT_LENGTH)
	{
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s's %.*s...", GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* ...%s", params[MAX_SPLIT_LENGTH]);
	}
	else
	{
    	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s's %s", GetRPName(playerid), params);
	}

	return 1;
}

CMD:me(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /me [action]");
	}


	if(strlen(params) > MAX_SPLIT_LENGTH)
	{
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.*s...", GetRPName(playerid), MAX_SPLIT_LENGTH, params);
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* ...%s", params[MAX_SPLIT_LENGTH]);
	}
	else
	{
    	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", GetRPName(playerid), params);
	}

	return 1;
}

CMD:ame(playerid, params[])
{
	new message[100], string[128];
	if(sscanf(params, "s[100]", message))
	{
		SendClientMessage(playerid, COLOR_GREY2, "Usage: /ame [action/off]");
 		SendClientMessage(playerid, COLOR_GREY2, "HINT: You can use this command to show an action above your head.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: This is useful for areas with a lot of text or congestion and avoiding spam.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: You will not be able to see the bubble, but a message is sent with the text other players see above your head.");
		SendClientMessage(playerid, COLOR_GLOBAL, "NOTE: Don't abuse it or get a punishment.");
		return 1;
	}
	if(strcmp(message, "off", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY2, "  You have removed the description label.");

	    DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
	    PlayerData[playerid][aMeStatus] =0;
	    return 1;
	}
	if(strlen(message) > 64) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too long, please reduce the length.");
	if(strlen(message) < 3) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too short, please increase the length.");

	if(PlayerData[playerid][aMeStatus] == 0)
	{
	    PlayerData[playerid][aMeStatus] =1;

		format(string, sizeof(string), "* %s %s", GetRPName(playerid), message);
		PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);
		return 1;
	}
	else
	{
		format(string, sizeof(string), "* %s %s", GetRPName(playerid), message);
		UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);
		return 1;
	}

}

CMD:ado(playerid, params[])
{
	new message[100], string[180];
	if(sscanf(params, "s[100]", message))
	{
		SendClientMessage(playerid, COLOR_GREY2, "Usage: /ado [action/off]");
  		SendClientMessage(playerid, COLOR_GREY2, "HINT: You can use this command to show an action above your head.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: This is useful for areas with a lot of text or congestion and avoiding spam.");
		SendClientMessage(playerid, COLOR_GREY2, "HINT: You will not be able to see the bubble, but a message is sent with the text other players see above your head.");
		SendClientMessage(playerid, COLOR_GLOBAL, "NOTE: Don't abuse it or get a punishment.");
		return 1;
	}
	if(strcmp(message, "off", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREY2, "  You have removed the description label.");

	    DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
	    PlayerData[playerid][aMeStatus] =0;
	    return 1;
	}
	if(strlen(message) > 64) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too long, please reduce the length.");
	if(strlen(message) < 3) return SendClientMessage(playerid, COLOR_GREY2, "  The action is too short, please increase the length.");
	if(PlayerData[playerid][aMeStatus] == 0)
	{
        PlayerData[playerid][aMeStatus] = 1;

		format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);

		PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
		return 1;
	}
	else
	{
		format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);

		UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
		return 1;
	}
}

CMD:do(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /do [describe]");
	}

	if(strlen(params) > MAX_SPLIT_LENGTH)
	{
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "*%.*s...", MAX_SPLIT_LENGTH, params);
		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* ...%s (( %s ))", params[MAX_SPLIT_LENGTH], GetRPName(playerid));
	}
	else
	{
    	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, GetRPName(playerid));
	}

	SetPlayerBubbleText(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, GetRPName(playerid));
	return 1;
}

CMD:stats(playerid, params[])
{
	DisplayStats(playerid);
	return 1;
}

CMD:net(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_FISHERMAN)){
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5, FisherNet[0], FisherNet[1], FisherNet[2]))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You're not at the Fishing Net Retailers, go to Santa Marina.");
	}

	if(isnull(params)){	
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /net [small/medium/large]");
		return SendClientMessage(playerid, COLOR_GREY, "Prices: Small - $200, Medium - $350, Large - 500$");
	}
	
	new newnetsize;
	if(strcmp(params, "small", true) == 0){
		newnetsize=1;
	}else if(strcmp(params, "medium", true) == 0){
		newnetsize=2;
	}else if(strcmp(params, "large", true) == 0){
		newnetsize=3;
	}else {
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /net [small/medium/large]");
		return SendClientMessage(playerid, COLOR_GREY, "Prices: Small - $200, Medium - $350, Large - 500$");
	}	
	new cost =  50 + 150 * newnetsize;
	newnetsize = newnetsize * 100;
	if(PlayerData[playerid][pNetSize]==newnetsize){
		return SendClientMessage(playerid, COLOR_GREY, "You already have this type of net.");
	}else if(PlayerData[playerid][pNetSize]>newnetsize){
		return SendClientMessage(playerid, COLOR_GREY, "You already have a more big net.");
	}
	
	if(PlayerData[playerid][pCash] < cost)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to buy that net.");
	}
	PlayerData[playerid][pCash] -= cost;
	PlayerData[playerid][pNetSize] = newnetsize;
	
	SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a %s fishing net for $%d.",params,cost);
	SendClientMessageEx(playerid, COLOR_AQUA, "You can carry roughly about %d kg of fish in your boat.",PlayerData[playerid][pNetSize]);
	
	return 1;
}


CMD:gofish(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_FISHERMAN)){
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
	}
	new Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);
	
	if(!(FisherZone[0] < x < FisherZone[2] && FisherZone[1] < y < FisherZone[3]))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not in deep enough water. (Los Santos South Coast)");
	}
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You already have a checkpoint. Use /kcp to remove it.");
	}
	if(PlayerData[playerid][pNetSize] <= PlayerData[playerid][pDolphinWeight] + PlayerData[playerid][pSharkWeight] + PlayerData[playerid][pCrabWeight]){
		return SendClientMessage(playerid, COLOR_GREY, "Your net is full.");
	}

	
	PlayerData[playerid][pCP] = CHECKPOINT_FISHER;
	x = Random(5000 + FisherZone[0],5000 + FisherZone[2]) - 5000;
	y = Random(5000 + FisherZone[1],5000 + FisherZone[3]) - 5000;
	SetPlayerRaceCheckpoint(playerid,2,x,y,0,0,0,0,10.0);
	return 1;
}

CMD:endfish(playerid, params[]){
	if(!PlayerHasJob(playerid, JOB_FISHERMAN)){
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
	}
	PlayerData[playerid][pCP] = CHECKPOINT_FISHER;
	SetPlayerRaceCheckpoint(playerid,2,724, -1510, 0,0,0,0,10.0);		
	return SendClientMessage(playerid, COLOR_AQUA, "Return to Santa Marina to get your paid.");	
}
CMD:networth(playerid, params[])
{
	PrintNetWorthPlayer(playerid);
	return 1;
}
CMD:l(playerid, params[])
{
	return callcmd::low(playerid, params);
}

CMD:low(playerid, params[])
{
	new
	    string[144];

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /(l)ow [text]");
	}

//	SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "(Quietly) %s", params);
	format(string, sizeof(string), "%s quietly: %s", GetRPName(playerid), params);
	SendProximityFadeMessage(playerid, 5.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

	return 1;
}

CMD:rpm(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rpm [text]");
	}
	if(PlayerData[playerid][pWhisperFrom] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You haven't been private messaged by anyone since you joined the server.");
	}
	if(PlayerData[PlayerData[playerid][pWhisperFrom]][pTogglePM])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming private messages.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}	
    if(PlayerData[playerid][pCash] < 25)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 25$ to send private message.");
    }
	SendClientMessageEx(PlayerData[playerid][pWhisperFrom], COLOR_GREEN, "(( PM from %s: %s ))", GetRPName(playerid), params);
	SendClientMessageEx(playerid, COLOR_GREEN, "(( PM to %s: %s ))", GetRPName(PlayerData[playerid][pWhisperFrom]), params);
    GivePlayerCash(playerid, -25);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$25", 5000, 1);
	return 1;
}
CMD:rw(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rw [text]");
	}
	if(PlayerData[playerid][pWhisperFrom] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You haven't been whispered by anyone since you joined the server.");
	}
	if(!IsPlayerNearPlayer(playerid, PlayerData[playerid][pWhisperFrom], 5.0) && (!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be near that player to whisper them.");
	}

	SendClientMessageEx(PlayerData[playerid][pWhisperFrom], COLOR_YELLOW, "* Whisper from %s: %s *", GetRPName(playerid), params);
	SendClientMessageEx(playerid, COLOR_YELLOW, "* Whisper to %s: %s *", GetRPName(PlayerData[playerid][pWhisperFrom]), params);
	return 1;
}
CMD:lights(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");
	}
	if(!IsEngineVehicle(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no lights which can be turned on.");
	}

	if(!IsVehicleParamOn(vehicleid, VEHICLE_LIGHTS))
	{
	    SetVehicleParams(vehicleid, VEHICLE_LIGHTS, true);
	    ShowActionBubble(playerid, "* %s turns on the headlights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    SetVehicleParams(vehicleid, VEHICLE_LIGHTS, false);
	    ShowActionBubble(playerid, "* %s turns off the headlights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:hood(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no hood.");
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in the passenger seat.");
	}

	if(!IsVehicleParamOn(vehicleid, VEHICLE_BONNET))
	{
	    SetVehicleParams(vehicleid, VEHICLE_BONNET, true);
	    ShowActionBubble(playerid, "* %s opens the hood of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    SetVehicleParams(vehicleid, VEHICLE_BONNET, false);
	    ShowActionBubble(playerid, "* %s closes the hood of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:trunk(playerid, params[])
{
	return callcmd::boot(playerid, params);
}

CMD:boot(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no boot.");
	}
    if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in the passenger seat.");
	}

	if(!IsVehicleParamOn(vehicleid, VEHICLE_BOOT))
	{
	    SetVehicleParams(vehicleid, VEHICLE_BOOT, true);
	    ShowActionBubble(playerid, "* %s opens the boot of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    SetVehicleParams(vehicleid, VEHICLE_BOOT, false);
	    ShowActionBubble(playerid, "* %s closes the boot of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:resetupgrades(playerid, params[])
{
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /resetupgrades [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command resets all of your upgrades and give you back %i upgrade points.", (PlayerData[playerid][pLevel] - 1) * 2);
	    return 1;
	}
	if(PlayerData[playerid][pLevel] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't level 2+.");
	}
	if(PlayerData[playerid][pInventoryUpgrade] == 0 && PlayerData[playerid][pTraderUpgrade] == 0 && PlayerData[playerid][pAddictUpgrade] == 0 && PlayerData[playerid][pAssetUpgrade] == 0 && PlayerData[playerid][pLaborUpgrade] == 0 && PlayerData[playerid][pSpawnHealth] == 50.0 && PlayerData[playerid][pSpawnArmor] == 0.0 && PlayerData[playerid][pUpgradePoints] == (PlayerData[playerid][pLevel] - 1) * 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You haven't spent any upgrade points on upgrades. Therefore you can't reset them.");
	}
	if(GetPlayerAssetCount(playerid, LIMIT_HOUSES) > 1)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i houses at the moment. Please sell one of them before using this command.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
	}
	if(GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) > 1)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i businesses at the moment. Please sell one of them before using this command.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
	}
    if(GetPlayerAssetCount(playerid, LIMIT_GARAGES) > 1)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i garages at the moment. Please sell one of them before using this command.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
 	mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptResetUpgrades", "i", playerid);
	return 1;
}

CMD:upgrades(playerid, params[])
{
	return callcmd::myupgrades(playerid, params);
}

CMD:myupgrades(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's upgrades (%i points available) _____", GetRPName(playerid), PlayerData[playerid][pUpgradePoints]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Shealth: %.0f/100]{C8C8C8} You spawn with %.1f health at the hospital after death.", PlayerData[playerid][pSpawnHealth], PlayerData[playerid][pSpawnHealth]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Sarmor: %.0f/100]{C8C8C8} You spawn with %.1f armor at the hospital after death.", PlayerData[playerid][pSpawnArmor], PlayerData[playerid][pSpawnArmor]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Inventory: %i/5]{C8C8C8} This upgrade increases the capacity for your items. [/inv]", PlayerData[playerid][pInventoryUpgrade]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Trader: %i/3]{C8C8C8} You save an extra %i percent on all items purchased in businesses.", PlayerData[playerid][pTraderUpgrade], PlayerData[playerid][pTraderUpgrade] * 10);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Addict: %i/3]{C8C8C8} You gain an extra %.1f health and armor when using drugs.", PlayerData[playerid][pAddictUpgrade], PlayerData[playerid][pAddictUpgrade] * 5.0);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Asset: %i/4]{C8C8C8} You can own %i houses, %i businesses, %i garages & %i vehicles.", PlayerData[playerid][pAssetUpgrade], GetPlayerAssetLimit(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Labor: %i/5]{C8C8C8} You earn an extra %i percent cash to your paycheck when working.", PlayerData[playerid][pLaborUpgrade], PlayerData[playerid][pLaborUpgrade] * 2);
	return 1;
}

CMD:buylevel(playerid, params[])
{
	new
		exp = (PlayerData[playerid][pLevel] * 4),
		cost = (PlayerData[playerid][pLevel] + 1) * 5000,
		string[64];

	if(PlayerData[playerid][pEXP] < exp)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need %i more respect points in order to level up.", exp - PlayerData[playerid][pEXP]);
	}
	if(PlayerData[playerid][pCash] < cost)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to have at least %s on hand to buy your next level.", FormatCash(cost));
	}
	if(PlayerData[playerid][pPassport])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have an active passport. You can't level up at the moment.");
	}

	PlayerData[playerid][pEXP] -= exp;
	PlayerData[playerid][pCash] -= cost;
	PlayerData[playerid][pLevel]++;
	PlayerData[playerid][pUpgradePoints] += 2;

	if(PlayerData[playerid][pLevel] == 3 && PlayerData[playerid][pReferralUID] > 0)
	{
	    ReferralCheck(playerid);
	}
	if(PlayerData[playerid][pLevel] >= 5)
	{
	    AwardAchievement(playerid, ACH_FiveStars);
	}
	if(PlayerData[playerid][pLevel] >= 10)
	{
	    AwardAchievement(playerid, ACH_TopTier);
	}

	format(string, sizeof(string), "~g~Level Up~n~~w~You are now level %i", PlayerData[playerid][pLevel]);
	GameTextForPlayer(playerid, string, 5000, 1);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET exp = exp - %i, cash = cash - %i, level = level + 1, upgradepoints = upgradepoints + 2 WHERE uid = %i", exp, cost, PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_GREEN, "You have moved up to level %i. This costed you %s.", PlayerData[playerid][pLevel], FormatCash(cost));
	SendClientMessageEx(playerid, COLOR_GREEN, "You now have %i upgrade points. Use /upgrade to learn more.", PlayerData[playerid][pUpgradePoints]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	return 1;
}

CMD:setforsale(playerid, params[])
{
	new askingprice, forsale[264], vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}

	if(VehicleInfo[vehicleid][vForSale]) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is already for sale.");
    if(!PlayerData[playerid][pPhone]) return SendClientMessage(playerid, COLOR_GREY, "You don't have any phone setup.");

	if(sscanf(params, "i", askingprice)) return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setforsale [price]");
	if(askingprice < 1 || askingprice > 50000000) return SendClientMessage(playerid, COLOR_GREY, "Price must be between $1 and $50,000,000.");

	VehicleInfo[vehicleid][vForSale] = true;
	VehicleInfo[vehicleid][vForSalePrice] = askingprice;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET forsale = 1, forsaleprice = %i WHERE id = %i",  askingprice, VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

    format(forsale, sizeof(forsale), "FOR SALE\n%s - %s\nPh: %i.", GetVehicleName(vehicleid), FormatCash(VehicleInfo[vehicleid][vForSalePrice]), PlayerData[playerid][pPhone]);
    VehicleInfo[vehicleid][vForSaleLabel] = CreateDynamic3DTextLabel(forsale, COLOR_GREY2, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, vehicleid, 1, -1, 0, -1, 30.0);

	SendClientMessageEx(playerid, COLOR_WHITE, "You have set your %s for sale with an asking price of $%s.", GetVehicleName(vehicleid), FormatCash(VehicleInfo[vehicleid][vForSalePrice]));
	return 1;
}

CMD:cancelforsale(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}

	if(!VehicleInfo[vehicleid][vForSale]) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is not for sale.");

	VehicleInfo[vehicleid][vForSale] = false;
	VehicleInfo[vehicleid][vForSalePrice] = 0;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET forsale = 0, forsaleprice = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][vForSaleLabel]);

	SendClientMessageEx(playerid, COLOR_WHITE, "You have cancelled the sale of your %s.", GetVehicleName(vehicleid));
	return true;
}

CMD:addpayphone(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (GetClosestPayphone(playerid) != -1)
	{
	    return SendErrorMessage(playerid, "There is another payphone nearby.");
	}
	else
	{
	    new
	        Float:x,
	        Float:y,
	        Float:z,
	        Float:angle,
			id = -1;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		x += 2.0 * floatsin(-angle, degrees);
		y += 2.0 * floatcos(-angle, degrees);

		id = AddPayphone(x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

		if (id == -1)
		{
		    return SendErrorMessage(playerid, "There are no available payphone slots.");
		}
		else
		{
		    EditDynamicObjectEx(playerid, EDIT_TYPE_PAYPHONE, Payphones[id][phObject], id);
		    SendInfoMessage(playerid, "You have added payphone %i (/editpayphone).", id);
		}
	}
	return 1;
}

CMD:gotopayphone(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	new id;
	if (sscanf(params, "i", id))
	{
	    return SendSyntaxMessage(playerid, "/gotopayphone (payphone ID)");
	}
	else if (!IsValidPayphoneID(id))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid payphone ID.");
	}
	else
	{
	    TeleportToCoords(playerid, Payphones[id][phX], Payphones[id][phY], Payphones[id][phZ], Payphones[id][phA], Payphones[id][phInterior], Payphones[id][phWorld]);
	    SendInfoMessage(playerid, "You have teleported to payphone %i.", id);
	}
	return 1;
}
CMD:setdamages(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 10)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else
	{
	    ShowWeaponDamageEditMenu(playerid);
	}
	return 1;
}
CMD:editpayphone(playerid, params[])
{
	new id;

	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", id))
	{
		return SendSyntaxMessage(playerid, "/editpayphone (payphone ID)");
	}
	else if (!IsValidPayphoneID(id))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid payphone ID.");
	}
	else
	{
    	EditDynamicObjectEx(playerid, EDIT_TYPE_PAYPHONE, Payphones[id][phObject], id);
		SendInfoMessage(playerid, "Click on the disk icon to save changes.");
	}
	return 1;
}

CMD:deletepayphone(playerid, params[])
{
	new id;

	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", id))
	{
	    return SendSyntaxMessage(playerid, "/deletepayphone (payphone ID)");
	}
	else if (!IsValidPayphoneID(id))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid payphone ID.");
	}
	else
	{
		if (Payphones[id][phCaller] != INVALID_PLAYER_ID)
		{
		    HangupCall(Payphones[id][phCaller]);
	    }

	    DestroyDynamic3DTextLabel(Payphones[id][phText]);
	    DestroyDynamicObject(Payphones[id][phObject]);

	    format(queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_payphones WHERE `phID` = %i", Payphones[id][phID]);
	    mysql_tquery(connectionID, queryBuffer);

		Payphones[id][phExists] = 0;
        SendInfoMessage(playerid, "You have deleted payphone %i.", id);
	}
	return 1;
}
CMD:tip(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] > 7)
	{
		if(isnull(params)) return SCM(playerid, COLOR_WHITE, "USAGE: /tip [message]");
		SendClientMessageToAllEx(COLOR_GREEN, "TIP: {ffffff}%s", params);
	}
	return 1;
}

CMD:jetpackall(playerid, params[])
{
	if(IsGodAdmin(playerid))
	{
	    foreach(new i : Player)
		{
		    PlayerData[i][pJetpack] = 1;
			SetPlayerSpecialAction(i, SPECIAL_ACTION_USEJETPACK);
			GameTextForPlayer(i, "~g~Jetpack", 3000, 3);
		}
	}
	return 1;
}


CMD:helmet(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(PlayerData[playerid][pHelmet] == 1)
	{
		if (HelmetEnabled[playerid] == 1)
		{
		    HelmetEnabled[playerid] = 0;
			ShowActionBubble(playerid, "{FF8000}* {C2A2DA}%s reaches for their helmet and takes it off.", GetPlayerNameEx(playerid));
			RemovePlayerAttachedObject(playerid, 3);
		}
		else if (HelmetEnabled[playerid] == 0)
		{
			if(IsAMotorBike(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
			    HelmetEnabled[playerid] = 1;
				ShowActionBubble(playerid, "{FF8000}* {C2A2DA}%s reaches for their helmet and puts it on.", GetPlayerNameEx(playerid));
				SetPlayerAttachedObject(playerid, 3, GetPlayerHelmet(playerid), 2, 0.101, -0.0, 0.0, 5.50, 84.60, 83.7, 1, 1, 1);
			}
			else return SendClientMessage(playerid, COLOR_GREY, "You must be in a bike to use this command");
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, "You dont have a helmet, buy one from a tool shop.");
	return 1;
}
//CMD:mmhelp(playerid, params[]) return callcmd::graphichelp(playerid, params);
CMD:graphichelp(playerid, params[])
{
	if(PlayerData[playerid][pGraphic] > 0)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "____________________________________________");
		if(PlayerData[playerid][pGraphic] == GRAPHICRANK_REGULAR)
		{
			SendClientMessage(playerid, COLOR_WHITE, "*1* Graphics Designer: /(g)raphic(c)hat /designers");
		}
		else if(PlayerData[playerid][pGraphic] == GRAPHICRANK_SENIOR)
		{
			SendClientMessage(playerid, COLOR_WHITE, "*2* Video Editor: /(g)raphic(c)hat /designers");
		}
		else if(PlayerData[playerid][pGraphic] == GRAPHICRANK_MANAGER)
		{
			SendClientMessage(playerid, COLOR_WHITE, "*3* Graphic Manager: /(g)raphic(c)hat /designers /makedesigner");
		}
	}
	else
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	return 1;
}


CMD:makedesigner(playerid, params[])
{
	if(PlayerData[playerid][pGraphic] < GRAPHICRANK_MANAGER && PlayerData[playerid][pAdmin] < MANAGEMENT) return SendClientErrorUnauthorizedCmd(playerid);
	new id, rank[24], str[128];
	if(sscanf(params, "us[24]", id, rank))
	{
		SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /makedesigner [playerid] [rank]");
		SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} 'None' 'Regular' 'Editor' or 'Manager'");
	}
	else
	{
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_GREY, "{FF0000}Error:{FFFFFF} That player isn't connected.");
		if(strcmp(rank, "none", true) == 0 || strcmp(rank, "regular", true) == 0 || strcmp(rank, "editor", true) == 0 || strcmp(rank, "manager", true) == 0)
		{
			if(strcmp(rank, "none", true) == 0)
			{
                SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has removed %s's status as a Designer.", GetRPName(playerid), GetRPName(id));
				SendClientMessage(id, COLOR_AQUA, "You are no longer a Designer.");
				PlayerData[id][pGraphic] = GRAPHICRANK_NONE;
				format(str, sizeof(str), "You removed %s from the Designer team.", GetRPName(id));
				SendClientMessage(playerid, COLOR_AQUA, str);
			//	if(PlayerData[playerid][pLevel] >= 2)PlayerData[id][pTag] = NTAG_PLAYER;
			//	else PlayerData[id][pTag] = NTAG_NEWBIE;
				return 1;
			}
			if(strcmp(rank, "regular", true) == 0)
			{
			//	PlayerData[id][pTag] = NTAG_GRAPHIC;
				PlayerData[id][pGraphic] = GRAPHICRANK_REGULAR;
				format(str, sizeof(str), "You have been given the status of a %s Designer.", rank);
				SendClientMessage(id, COLOR_AQUA, str);
				SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has been given the status of a %s Designer by %s", GetRPName(id), rank, GetRPName(playerid));
				format(str, sizeof(str), "You gave %s the status of a %s Designer.", GetRPName(id), rank);
				SendClientMessage(playerid, COLOR_AQUA, str);
			}
			if(strcmp(rank, "editor", true) == 0)
			{
			//	PlayerData[id][pTag] = NTAG_GRAPHIC;
				PlayerData[id][pGraphic] = GRAPHICRANK_SENIOR;
				format(str, sizeof(str), "You have been given the status of a %s Designer.", rank);
				SendClientMessage(id, COLOR_AQUA, str);
				SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has been given the status of a %s Designer by %s", GetRPName(id), rank, GetRPName(playerid));
				format(str, sizeof(str), "You gave %s the status of a %s Designer.", GetRPName(id), rank);
				SendClientMessage(playerid, COLOR_AQUA, str);
			}
			if(strcmp(rank, "manager", true) == 0)
			{
			//	PlayerData[id][pTag] = NTAG_MANAGERGRAPHIC;
				PlayerData[id][pGraphic] = GRAPHICRANK_MANAGER;
				format(str, sizeof(str), "You have been given the status of a %s Designer.", rank);
				SendClientMessage(id, COLOR_AQUA, str);
				SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has been given the status of a %s Designer by %s", GetRPName(id), rank, GetRPName(playerid));
				format(str, sizeof(str), "You gave %s the status of a %s Designer.", GetRPName(id), rank);
				SendClientMessage(playerid, COLOR_AQUA, str);
			}
		}
		else return SendClientMessage(playerid, COLOR_GREY, "Invalid rank specified.");
	}
	return 1;
}


CMD:windows(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be inside a vehicle to use this command.");
	}
	if(PlayerData[playerid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed");
	}
	if(PlayerData[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
	}
    if(!VehicleHasWindows(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have any windows.");
	}
	new driver, passenger, backleft, backright;
	GetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, backright);
	SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), !driver, !passenger, !backleft, !backright);
	if(CarWindows[vehicleid] == 0)
	{
	    CarWindows[vehicleid] = 1;
	    SendProximityMessage(playerid, 20.0, 0xFFA500FF, "*{C2A2DA} %s rolls down the vehicle windows of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));

 	}
	else
	{
	    CarWindows[vehicleid] = 0;
        SendProximityMessage(playerid, 20.0, 0xFFA500FF, "*{C2A2DA} %s rolls up the vehicle windows of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	return 1;
}


CMD:loaditem(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);
	if(PlayerData[playerid][pBugFix] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not handling any item.");
	}
	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no boot.");
	}
	if(!IsVehicleParamOn(vehicleid, VEHICLE_BOOT))
	{
		return SendClientMessage(playerid, COLOR_GREY, "The vehicle trunk is not open");
	}
	PlayerData[playerid][pCP] = CHECKPOINT_HOUSEROB;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
	SetPlayerCheckpoint(playerid, 1596.5035,-1552.3578,13.5879, 5.0);
	return 1;
}

CMD:respawnvipcars(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] >= SENIOR_ADMIN)
	{
		for(new i = 0; i < sizeof(VIPVehicles); i++)
		{
			if(!IsVehicleOccupied(VIPVehicles[i]))
			{
				SetVehicleVirtualWorld(VIPVehicles[i], 0);
				LinkVehicleToInterior(VIPVehicles[i], 0);
				SetVehicleToRespawn(VIPVehicles[i]);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You have respawned all unoccupied VIP Vehicles.");
	}
	return 1;
}
CMD:selldynamicsmanagement(playerid, params[])
{

	if(PlayerData[playerid][pAdmin] < MANAGEMENT)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	return  SendClientMessage(playerid, COLOR_GREY, "This command was disabled.");

	//new houses, garages, businesses;
	//for(new i = 0; i < MAX_HOUSES; i ++)
	//{
	//    if(HouseInfo[i][hExists])
	//    {
	//        SetHouseOwner(i, INVALID_PLAYER_ID);
	//        houses++;
	//    }
	//}
	//
	//for(new i = 0; i < MAX_GARAGES; i ++)
	//{
	//    if(GarageInfo[i][gExists])
	//    {
	//        SetGarageOwner(i, INVALID_PLAYER_ID);
	//        garages++;
	//    }
	//}
	//
	//for(new i = 0; i < MAX_BUSINESSES; i ++)
	//{
	//    if(BusinessInfo[i][bExists])
	//    {
	//        SetBusinessOwner(i, INVALID_PLAYER_ID);
	//        businesses++;
	//    }
	//}
	//
	//SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has sold all properties.", GetRPName(playerid));
	//SendClientMessageEx(playerid, COLOR_WHITE, "* You have sell %i houses, %i garages and %i businesses.", houses, garages, businesses);
	//return 1;
}

CMD:samphelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GLOBAL, "_____________________[ SA:MP 0.3.7 R2 CLIENT ]_________________________");
	SendClientMessageEx(playerid, COLOR_GREY, "** CLIENT ** /interior /save /headmove /timestamp /dl");
	SendClientMessageEx(playerid, COLOR_GREY, "** CLIENT ** /pagesize /rs /fpslimit");
	return 1;
}

CMD:togglecam(playerid, params[])
{
	if(GetPVarInt(playerid,"used") == 1)
	{
		SetPVarInt(playerid,"used",0);
		SetCameraBehindPlayer(playerid);
		DestroyPlayerObject(playerid,pObj[playerid]);
	}
	return 1;
}

CMD:window(playerid, params[])
{
//	new string[128];
    if(InsideShamal[playerid] != INVALID_VEHICLE_ID)
	{
        if (GetPlayerInterior(playerid))
		{
            new
                Float: fSpecPos[6];

            GetPlayerPos(playerid, fSpecPos[0], fSpecPos[1], fSpecPos[2]);
            GetPlayerFacingAngle(playerid, fSpecPos[3]);
            GetPlayerHealth(playerid, fSpecPos[4]);
            GetPlayerArmour(playerid, fSpecPos[5]);

            SetPVarFloat(playerid, "air_Xpos", fSpecPos[0]);
            SetPVarFloat(playerid, "air_Ypos", fSpecPos[1]);
            SetPVarFloat(playerid, "air_Zpos", fSpecPos[2]);
            SetPVarFloat(playerid, "air_Rpos", fSpecPos[3]);
            SetPVarFloat(playerid, "air_HP", fSpecPos[4]);
            SetPVarFloat(playerid, "air_Arm", fSpecPos[5]);

            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectateVehicle(playerid, InsideShamal[playerid]);

            ShowActionBubble(playerid, "* %s glances out the window.", GetRPName(playerid));
          //  SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
        }
        else TogglePlayerSpectating(playerid, 0);
    }
    return 1;
}
CMD:removegunlicense(playerid, params[])
{
	new targetid;
	if(IsLawEnforcement(playerid))
	{

		if(sscanf(params, "d", targetid))
		{
			return SendClientMessage(playerid, COLOR_GREY, "Usage: /removegunlicense [playerid]");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
		}
		PlayerData[targetid][pGunLicense] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gunlicense = %d WHERE uid = %i", PlayerData[targetid][pGunLicense], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		SendClientMessageEx(playerid, COLOR_AQUA, "You've set %s's gun license to %d", GetRPName(targetid), PlayerData[targetid][pGunLicense]);
		SendClientMessageEx(targetid, COLOR_AQUA, "Officer %s has revoked your gun license", GetRPName(playerid));

	}
	else return SendClientErrorUnauthorizedCmd(playerid);
	return 1;
}
CMD:givegunlicense(playerid, params[])
{
	new targetid;

	if(IsLawEnforcement(playerid))
	{
		if(sscanf(params, "d", targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Usage: /givegunlicense [playerid]");
 		}
		if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
		}
		PlayerData[targetid][pGunLicense] = 1;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gunlicense = %d WHERE uid = %i", PlayerData[targetid][pGunLicense], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		SendClientMessageEx(playerid, COLOR_AQUA, "You've set %s's gun license to %d", GetRPName(targetid), PlayerData[targetid][pGunLicense]);
		SendClientMessageEx(targetid, COLOR_AQUA, "Officer %s has approved your gun license request", GetRPName(playerid));

	}
	else return SendClientErrorUnautorizedChat(playerid);
	return 1;
}

CMD:forceweather(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	autoWeather();
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced the weather to change.", GetRPName(playerid));
	return 1;
}

CMD:seatbelt(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	{
        SendClientMessage(playerid, COLOR_WHITE, "You are not in a vehicle!");
        return 1;
    }
    if(IsPlayerInAnyVehicle(playerid) == 1 && seatbelt[playerid] == 0)
	{
        seatbelt[playerid] = 1;
        if(IsAMotorBike(GetPlayerVehicleID(playerid)))
		{
		    SetPlayerAttachedObject(playerid, 7, 18645, 2, 0.1, 0.02, 0.0, 0.0, 90.0, 90.0, 1.0, 1.0, 1.0);
            ShowActionBubble(playerid, "* %s reaches for their helmet, and puts it on.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have put on your helmet.");
        }
        else
		{
            ShowActionBubble(playerid, "* %s reaches for their seatbelt, and buckles it up.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have put on your seatbelt.");
        }

    }
    else if(IsPlayerInAnyVehicle(playerid) == 1 && seatbelt[playerid] == 1)
	{
        seatbelt[playerid] = 0;
		if(IsAMotorBike(GetPlayerVehicleID(playerid)))
		{
		    RemovePlayerAttachedObject(playerid, 7);
            ShowActionBubble(playerid, "* %s reaches for their helmet, and takes it off.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have taken off your helmet.");
        }
        else
		{
            ShowActionBubble(playerid, "* %s reaches for their seatbelt, and unbuckles it.", GetRPName(playerid));
			SendClientMessage(playerid, COLOR_WHITE, "You have taken off your seatbelt.");
        }
    }
    return 1;
}

CMD:checkbelt(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "i", giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /checkbelt [playerid]");

    if(GetPlayerState(giveplayerid) == PLAYER_STATE_ONFOOT)
	{
        SendClientMessage(playerid,COLOR_GREY,"That player is not in any vehicle!");
        return 1;
    }
    if(!IsPlayerConnected(giveplayerid) || !IsPlayerNearPlayer(playerid, giveplayerid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}

    new stext[4];
    if(seatbelt[giveplayerid] == 0)
	{
		stext = "off";
	}
    else
	{
		stext = "on";
	}
    if(IsAMotorBike(GetPlayerVehicleID(playerid)))
	{
        ShowActionBubble(playerid, "* %s looks at %s, checking to see if they are wearing a helmet.", GetRPName(playerid),GetRPName(giveplayerid));
        SendClientMessageEx(playerid,COLOR_WHITE, "%s's helmet is currently %s.", GetRPName(giveplayerid) , stext);
	}
	else
	{
    	ShowActionBubble(playerid, "* %s peers through the window at %s, checking to see if they are wearing a seatbelt.", GetRPName(playerid),GetRPName(giveplayerid));
    	SendClientMessageEx(playerid,COLOR_WHITE, "%s's seat belt is currently %s.", GetRPName(giveplayerid) , stext);
    }
    return 1;
}

CMD:checkmybelt(playerid, params[])
{
    if(seatbelt[playerid] == 1)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have your seatbelt on.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Your seatbelt is off.");
	}
	return 1;
}
CMD:vcode(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(PlayerData[playerid][pDonator] < 3)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You need a Legendary donator package to access use this command.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
	}
	if(isnull(params) || strlen(params) > 64)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /vcode [text ('none' to reset)]");
	}

	if(IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
		DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

		if(!strcmp(params, "none", true))
		{
			SendClientMessage(playerid, COLOR_WHITE, "* Car text removed from the vehicle.");
		}
	}

	if(strcmp(params, "none", true) != 0)
	{
		DonatorCallSign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_VIP, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
 		SendClientMessage(playerid, COLOR_WHITE, "* Car text attached. '/vcode none' to detach the Car text.");
	}

	return 1;
}

CMD:tlaws(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTRED, "Traffic Laws");
	SendClientMessage(playerid, COLOR_GLOBAL, "Drive on the RIGHT side of the road at all times.");
	SendClientMessage(playerid, COLOR_GLOBAL, "Yield to emergency vehicles.");
	SendClientMessage(playerid, COLOR_GLOBAL, "Move over and slow down for stopped emergency vehicles.");
	SendClientMessage(playerid, COLOR_GLOBAL, "Turn your headlights on at night (/lights).");
	SendClientMessage(playerid, COLOR_GLOBAL, "Wear your seatbelt or helmet (/seatbelt).");
	SendClientMessage(playerid, COLOR_GLOBAL, "Drive at speeds that are posted in /speedlaws");
	//SendClientMessage(playerid, COLOR_GLOBAL, "Traffic lights are synced RED=STOP YELLOW=SLOW DOWN GREEN=GO");
	//SendClientMessage(playerid, COLOR_GLOBAL, "Only follow traffic lights above a junction. (Marked with a solid white line)");
	SendClientMessage(playerid, COLOR_GLOBAL, "Remain at a safe distance from other vehicles when driving, atleast 3 car lengths");
	SendClientMessage(playerid, COLOR_GLOBAL, "Pedistrians always have the right of way, regardless of the situation.");
	SendClientMessage(playerid, COLOR_GLOBAL, "Drive how you would in real life, dont be a moron.");
	SendClientMessage(playerid, COLOR_GLOBAL, "If you fail at driving you will be jailed or fined.");
	return 1;
}

CMD:speedlaws(playerid, params[]) {
	SendClientMessage(playerid, COLOR_RED, "Speed Enforcement Laws");
	SendClientMessage(playerid, COLOR_GLOBAL, "50mph in Cities");
	SendClientMessage(playerid, COLOR_GLOBAL, "70mph on the County roads");
	SendClientMessage(playerid, COLOR_GLOBAL, "90mph on the Highways and Interstates");
	SendClientMessage(playerid, COLOR_GLOBAL, "Box trucks cannot exceed 50MPH.");
	SendClientMessage(playerid, COLOR_GLOBAL, "Any vehicles with 3 or more axles aren't allowed to go more than 55 mph. Regardless of roadway limits.");
	SendClientMessage(playerid, COLOR_GLOBAL, "[ THERE ARE POLICE AND SPEED CAMERAS THAT ENFORCE THESE LAWS ]");
	return 1;
}
//Reward play (ToiletDuck)
CMD:phrewards(playerid)
{
    if (IsHourRewardEnabled())
    {

        switch (PlayerData[playerid][pHours])
        {
            case 2:
            {
                SendClientMessageEx(playerid, COLOR_LIGHTRED, "You may now possess/use weapons!");
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You have reached 2 Playing hours (/phrewards) to check all the Playing hours rewards!");

            }
            case 10:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 First aid Kit for spending 10 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /firstaid you can buy more from Tool Shop");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pFirstAid] += 10;
            }
            case 25:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 Cookies for spending 25 Hours of Time in Playing ");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /usecookies you can get more with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");

                GivePlayerCookies(playerid, 10); //rewardplay
            }
            case 50:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 5 Upgrade Points for spending 50 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pUpgradePoints] += 5;
            }
            case 100:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 50g Weed and Cocaine and 15,000 Materials for spending 100 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pWeed] += 50;
                PlayerData[playerid][pCocaine] += 50;
                PlayerData[playerid][pMaterials] += 15000;

            }
            case 150:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive $50,000 of Cash and 5 Exp Token for spending 150 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                GivePlayerCash(playerid, 50000);
                PlayerData[playerid][pEXP] += 5;
            }
            case 200:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 20 Cookies for spending 200 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /usecookies you can get more with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");

                GivePlayerCookies(playerid, 20);
            }
            case 250:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 7 Days Silver VIP for spending 250 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 1)
                {
                    new rank=1, days = 7;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 300:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 15 Days Silver VIP for spending 250 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 1)
                {
                    new rank=1, days = 15;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 350:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 50,000 Materials and 5 Exp Token for spending 350 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pMaterials] += 15000;
                PlayerData[playerid][pEXP] += 5;
            }
            case 400:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 5 Days Gold VIP for spending 400 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 2)
                {
                    new rank=2, days = 5;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 450:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 5 Exp Tokens, 15 First aid Kit for spending 450 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pEXP] += 5;
                PlayerData[playerid][pFirstAid] += 15;
            }
            case 500:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 Days Gold VIP for spending 500 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 2)
                {
                    new rank=2, days = 10;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 600:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 30 Cookies for spending 600 Hours of Time in Playing ");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /usecookies you can get more with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");

                GivePlayerCookies(playerid, 30); //rewardplay
            }
            case 700:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 15 Days Gold VIP for spending 700 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 2)
                {
                    new rank=2, days = 15;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 800:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 3 Days Legendary VIP for spending 800 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 3;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 900:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 7 Days Legendary VIP for spending 900 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 7;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 1000:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 Days Legendary VIP for spending 1000 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 10;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 1250:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 15 Days Legendary VIP for spending 1250 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 15;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 1500:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive Vehicle Huntley for spending 1500 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more cars with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                {
                    new model = 579;
                    GivePlayerVehicle(playerid, model);
                }
            }
            case 1750:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 20 Days Legendary VIP for spending 1750 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 20;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 2000:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 30 Days Legendary VIP for spending 2000 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 30;
                    GivePlayerVIP(playerid, rank, days);
                }
            }

        }
    }
}

CMD:cw(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), string[180];

	if(IsAMotorBike(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in a bike.");
	}

	foreach(new i : Player)
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
		    if(IsPlayerInVehicle(i, vehicleid))
		    {
            	if(isnull(params))
				{
				    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /cw [in vehicle text]");
				}
				format(string, sizeof(string), "%s whispers: %s", GetRPName(playerid), params);
				SendProximityFadeMessage(i, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
			}
		}
	}
	return 1;
}

CMD:detach(playerid, params[])
{
	#pragma unused params

	new veh = GetPlayerVehicleID(playerid);

	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in a vehicle to do this.");
	if(!IsTrailerAttachedToVehicle(veh)) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have a trailer attached to your vehicle.");

	DetachTrailerFromVehicle(veh);
	SendClientMessageEx(playerid, COLOR_GREY, "Your trailer has been detached from your vehicle.");

	return 1;
}

CMD:speakerphone(playerid, params[])
{
    if(PlayerData[playerid][pPhone] != 0)
	{
        if(PlayerData[playerid][pSpeakerPhone] == 1)
		{
            PlayerData[playerid][pSpeakerPhone] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the speakerphone feature on your phone.");
        }
        else
		{
            PlayerData[playerid][pSpeakerPhone] = 1;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the speakerphone feature on your phone.");
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a phone.");
    }
    return 1;
}

CMD:setstyle(playerid, params[])
{
	new pickid;
	if(!PlayerData[playerid][pDonator])
		return SendClientMessage(playerid, COLOR_ADM, "ACCESS DENIED:{FFFFFF} You aren't a donator.");

	if(sscanf(params, "i", pickid)){
		SendClientMessage(playerid, COLOR_WHITE, "Chat Styles: 0 1 2 3 4");
		SendClientMessage(playerid, COLOR_WHITE, "Chat Styles: 5 6 7");
		SendClientMessage(playerid, COLOR_GREEN, "USAGE: /setstyle 2 [StyleID]");
		return true;
	}

	if(pickid != -1 && pickid < 0 || pickid > 7)
		return SendClientMessage(playerid, COLOR_ADM, "You specified an invalid chat.");

	PlayerData[playerid][pChatstyle] = pickid;
	SavePlayerVariables(playerid);
	SendClientMessage(playerid, COLOR_YELLOW, "Enjoy your new chatstyle!");
	return 1;
}

CMD:helpwindow(playerid,params[])
{
	ShowDialogToPlayer(playerid, DIALOG_HELP);
	return 1;
}
CMD:help(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] > 2)
		Dialog_Show(playerid, DIALOG_HELPCMD, DIALOG_STYLE_LIST, "{00aa00}%s {FFFFFF}| Commands", "General Commands\nJob Commands\nGang Commands\nFaction Commands\nVIP Commands\nHouse Commands\nVehicle Commands\nBusiness Commands\nHelper Commands\nAdmin Commands", "Choose", "Close", GetServerName());

	if(PlayerData[playerid][pHelper] > 1 && PlayerData[playerid][pAdmin] > 2)
		Dialog_Show(playerid, DIALOG_HELPCMD, DIALOG_STYLE_LIST, "{00aa00}%s {FFFFFF}| Commands", "General Commands\nJob Commands\nGang Commands\nFaction Commands\nVIP Commands\nHouse Commands\nVehicle Commands\nBusiness Commands\nHelper Commands", "Choose", "Close", GetServerName());
	else
		Dialog_Show(playerid, DIALOG_HELPCMD, DIALOG_STYLE_LIST, "{00aa00}%s {FFFFFF}| Commands", "General Commands\nJob Commands\nGang Commands\nFaction Commands\nVIP Commands\nHouse Commands\nVehicle Commands\nBusiness Commands", "Choose", "Close", GetServerName());
	return 1;
}

CMD:vehiclehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "________________ Vehicle Help ________________");
    SendClientMessage(playerid, COLOR_WHITE, "** VEHICLE HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /lights /hood /trunk /boot /buy /carstorage /park /lock /findcar, /setforsale, /cancelforsale");
    SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /vstash /neon /unmod /colorcar /paintcar /upgradevehicle /sellcar /sellmycar");
    SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /givekeys /takekeys /setradio /paytickets /carinfo /gascan /breakin");
    return 1;
}

CMD:bankhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_NAVYBLUE, "__________________ Banking Help __________________");
    SendClientMessage(playerid, COLOR_WHITE, "** BANKING HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** BANKING ** /withdraw /deposit /wiretransfer /balance /robbank /robinvite /bombvault /robbers");
	return 1;
}

CMD:viphelp(playerid, params[])
{
	if(!PlayerData[playerid][pDonator])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
	}
    SendClientMessage(playerid, COLOR_NAVYBLUE, "__________________ VIP Help __________________");
    SendClientMessage(playerid, COLOR_WHITE, "** VIP HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** VIP ** /locatelounge /(v)ip /vipinfo /viptag /vipcolor /vipinvite /vipnumber /vipmusic");
	
	if(PlayerData[playerid][pDonator] >= 2)
	{
    	SendClientMessage(playerid, COLOR_GREY, "** VIP ** /changeage /changegender /viplocker");
	}
	if(PlayerData[playerid][pDonator] == 3)
	{
	    SendClientMessage(playerid, COLOR_GREY, "** VIP ** /repair /nos /hyd /viprimkit /changeplates");
	}
	return 1;
}

CMD:setspawn(playerid, params[])
{
	new spawn_id, optional;

	if(sscanf(params, "dI(-1)", spawn_id, optional))
	{
		SendClientMessage(playerid, COLOR_ADM, "USAGE:{FFFFFF} /setspawn [spawn_id] ");
		SendClientMessage(playerid, COLOR_DARKGREEN, "1. Last Position | 2. House | 4. Faction");
		return true;
	}

	switch ( spawn_id )
	{
		case 1:
		{
			PlayerData[playerid][pSpawnSelect] = 0;
			SendClientMessage(playerid, COLOR_GREY, "You will now spawn at your last position.");
			SavePlayerVariables(playerid);

		}
		case 2:
		{
			if(CountPlayerHouses(playerid) == 0)return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You don't own any houses.");

			if(optional == -1){
				SendClientMessage(playerid, COLOR_ADM, "USAGE:{FFFFFF} /setspawn 2 [house id] ");
				SendClientMessage(playerid, COLOR_ADM, "You must specify your house ID by using /myassets to fetch the ID. ");
				return true;
			}

			if(optional < 0 || !HouseInfo[optional][hExists]) return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You specified an invalid house ID.");

			for(new i = 0; i < MAX_HOUSES; i++){
				if(HouseInfo[optional][hExists]){
					if(!IsHouseOwner(playerid, optional)){
						SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You don't own that house.");
						return true;
					}
				}
			}

			SendClientMessage(playerid, COLOR_GREY, "You will now spawn at your house.");
			PlayerData[playerid][pSpawnSelect] = 1;
			PlayerData[playerid][pSpawnHouse] = optional;
			SavePlayerVariables(playerid);
		}
		case 3:
		{
			if( !PlayerData[playerid][pFaction] )return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You aren't in any faction.");

			SendClientMessage(playerid, COLOR_GREY, "You will now spawn at your faction spawn.");
			PlayerData[playerid][pSpawnSelect] = 2;
			PlayerData[playerid][pSpawnPrecinct] = 0;
			SavePlayerVariables(playerid);
		}
	}
	return true;
}


CMD:landhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** LAND HELP ** type a command for more information.");
	SendClientMessage(playerid, COLOR_GREY, "** LAND ** /buyland /lock /door /landinfo /land /sellmyland /sellland /droplandkeys");
	SendClientMessage(playerid, COLOR_GREY, "** LAND ** /editlandobj /duplandobj /setlandobj /selllandobj /checklandobj");
    SendClientMessage(playerid, COLOR_GREY, "** LAND ** '/showlands' to show or hide lands on your mini-map.");
    return 1;
}

CMD:planthelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** PLANT HELP ** type a command for more information.");
	SendClientMessage(playerid, COLOR_GREY, "** PLANT ** /plantweed /plantinfo /pickplant /seizeplant");
    return 1;
}


CMD:na(playerid, params[]) return callcmd::nanswer(playerid, params);
CMD:nanswer(playerid, params[])
{
	if(PlayerData[playerid][pHelper] >= 1 || PlayerData[playerid][pAdmin] >= LEVEL_SECRET_ADMIN)
	{
	    new giveplayerid, string[300], answer[128], question[128];
		if(sscanf(params, "us[128]", giveplayerid, answer)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /nanswer (playerid) (answer)");
		if(GetPVarInt(giveplayerid, "SendQuestion") == 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player isn't asking");
		format(string, sizeof(string), "* Staff %s has answered your Question", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_AQUA, string);
		GetPVarString(giveplayerid, "Question", question, sizeof(question));
		foreach(new n: Player)
		{
		    if(!PlayerData[n][pToggleNewbie])
		    {
			    format(string, sizeof(string), "Question: %s: %s", GetRPName(giveplayerid), question);
			    SendClientMessageEx(n, COLOR_NEWBIE, string);
			    if(PlayerData[playerid][pHelper] == 1 && PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
			    {
					format(string, sizeof(string), "Answer: %s: %s", GetRPName(playerid), answer);
					PlayerData[playerid][pNewbies] ++;
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET newbies = %i WHERE uid = %i", PlayerData[playerid][pNewbies], PlayerData[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);
				}
				if(PlayerData[playerid][pHelper] >= 2 && PlayerData[playerid][pAdmin] < 1) format(string, sizeof(string), "Answer: %s: %s", GetRPName(playerid), answer);
				if(PlayerData[playerid][pAdmin] >= JUNIOR_ADMIN) format(string, sizeof(string), "Answer: %s: %s", GetRPName(playerid), answer);
				SendClientMessageEx(n, COLOR_NEWBIE, string);
			}
		}
		DeletePVar(giveplayerid, "SendQuestion");
		DeletePVar(giveplayerid, "Question");
		return 1;
	}
	else SendClientMessageEx(playerid, COLOR_AQUA, "You're not a Helper or an Admin!");
	return 1;

}
CMD:tn(playerid, params[]) return callcmd::trashnewb(playerid, params);
CMD:trashnewb(playerid, params[])
{
    if(PlayerData[playerid][pHelper] >= 1 || PlayerData[playerid][pAdmin] >= LEVEL_SECRET_ADMIN)
	{
	    new giveplayerid, string[128], reason[128];
		if(sscanf(params, "us[128]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /trashnewb (playerid) (text)");
		if(GetPVarInt(giveplayerid, "SendQuestion") == 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player isn't asking");
		format(string, sizeof(string), "* Staff %s has trashed your question. Reason: %s", GetRPName(playerid), reason);
		SendClientMessageEx(giveplayerid, COLOR_AQUA, string);
		format(string, sizeof(string), "* %s has trashed %s question. Reason: %s", GetRPName(playerid),GetRPName(giveplayerid), reason);
		SendQuestionToStaff(COLOR_AQUA, string);
		DeletePVar(giveplayerid, "SendQuestion");
		DeletePVar(giveplayerid, "Question");
		return 1;
	}
	else SendClientMessageEx(playerid, COLOR_AQUA, "You're not a Helper or an Admin!");
	return 1;
}
CMD:level(playerid, params[])
{
	new count, color;

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /level [level]");
	}

	if(IsNumeric(params))
	{
	    foreach(new i : Player)
	    {
	        if(PlayerData[i][pLevel] == strval(params))
	        {
	            if((color = GetPlayerColor(i)) == 0xFFFFFF00)
		        	color = 0xAAAAAAFF;

				SendClientMessageEx(playerid, COLOR_GREY3, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", i, color >>> 8, GetPlayerNameEx(i), PlayerData[i][pLevel], GetPlayerPing(i));
				count++;
			}
		}
		if(!count)
		{
  			SendClientMessageEx(playerid, COLOR_GREY, "There are no level %s players online.", params);
		}
   	}
   	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "Please use a numerical value!");
	}

	return 1;
}

CMD:id(playerid, params[])
{
	new count, color, name[MAX_PLAYER_NAME], targetid = strval(params);

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /id [playerid/partial name]");
	}

	if(IsNumeric(params))
	{
		if(IsPlayerConnected(targetid))
		{
		    if((color = GetPlayerColor(targetid)) == 0xFFFFFF00) {
		        color = 0xAAAAAAFF;
			}

		    GetPlayerName(targetid, name, sizeof(name));
		    SendClientMessageEx(playerid, COLOR_GREY3, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", targetid, color >>> 8, name, PlayerData[targetid][pLevel], GetPlayerPing(targetid));
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
	}
	else if(strlen(params) < 2)
	{
	    SendClientMessage(playerid, COLOR_GREY, "Please input at least two characters to search.");
	}
	else
	{
	    foreach(new i : Player)
	    {
	        GetPlayerName(i, name, sizeof(name));

	        if(strfind(name, params, true) != -1)
	        {
	            if((color = GetPlayerColor(i)) == 0xFFFFFF00) {
		        	color = 0xAAAAAAFF;
				}

	            SendClientMessageEx(playerid, COLOR_GREY3, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", i, color >>> 8, name, PlayerData[i][pLevel], GetPlayerPing(i));
	            count++;
			}
		}

		if(!count)
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "No results found for \"%s\". Please narrow your search.", params);
		}
	}

	return 1;
}

CMD:give(playerid, params[])
{
	new targetid, option[14], param[32], amount;

	if(sscanf(params, "us[14]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapon, Materials, Weed, Crack, heroin, Painkillers, Cigars, Spraycans");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: GasCan, Seeds, Chems, FirstAid, Bodykits, Rimkits, Diamonds");
	    return 1;
	}

	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(!strcmp(option, "weapon", true))
	{
	    new weaponid = GetScriptWeapon(playerid);

	    if(!weaponid)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You must be holding the weapon you're willing to give away.");
	    }
	    if(PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You can't give this weapon as you don't have it.");
		}
	    if(PlayerData[targetid][pWeapons][GetWeaponSlot(weaponid)] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player already has a weapon in that slot.");
	    }
	    if(PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
	    {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
	    }
	    if(PlayerData[playerid][pFaction] >= 0 && PlayerData[targetid][pFaction] != PlayerData[playerid][pFaction])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can only give away weapons to your own faction members.");
	    }
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from inside a vehicle.");
		}
		if(IsPlayerInAnyVehicle(targetid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons to players inside a vehicle.");
		}
		if(GetPlayerHealthEx(playerid) < 60)
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You can't give weapons as your health is below 60.");
		}
	    GivePlayerWeaponEx(targetid, weaponid);
	    RemovePlayerWeapon(playerid, weaponid);

	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you their %s.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have given %s your %s.", GetRPName(targetid), GetWeaponNameEx(weaponid));

	    ShowActionBubble(playerid, "* %s passes over their %s to %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives their %s to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetWeaponNameEx(weaponid), GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [materials] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pMaterials])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pMaterials] + amount > GetPlayerCapacity(targetid, CAPACITY_MATERIALS))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more materials.");
		}

		PlayerData[playerid][pMaterials] -= amount;
		PlayerData[targetid][pMaterials] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[targetid][pMaterials], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i materials.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i materials to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some materials to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i materials to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "weed", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [weed] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pWeed])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pWeed] + amount > GetPlayerCapacity(targetid, CAPACITY_WEED))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more weed.");
		}

		PlayerData[playerid][pWeed] -= amount;
		PlayerData[targetid][pWeed] += amount;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[targetid][pWeed], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of weed.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of weed to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some weed to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i grams of weed to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [crack] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pCocaine])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pCocaine] + amount > GetPlayerCapacity(targetid, CAPACITY_COCAINE))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more crack.");
		}
		PlayerData[playerid][pCocaine] -= amount;
		PlayerData[targetid][pCocaine] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[targetid][pCocaine], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of crack.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of crack to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some crack to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i grams of crack to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "heroin", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [heroin] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pHeroin])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pHeroin] + amount > GetPlayerCapacity(targetid, CAPACITY_HEROIN))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more heroin.");
		}
		PlayerData[playerid][pHeroin] -= amount;
		PlayerData[targetid][pHeroin] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[targetid][pHeroin], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of Heroin.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of Heroin to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some Heroin to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i grams of Heroin to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [painkillers] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pPainkillers])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pPainkillers] + amount > GetPlayerCapacity(targetid, CAPACITY_PAINKILLERS))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more painkillers.");
		}

		PlayerData[playerid][pPainkillers] -= amount;
		PlayerData[targetid][pPainkillers] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[targetid][pPainkillers], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i painkillers.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i painkillers to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some painkillers to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i painkillers to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "cigars", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [cigars] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pCigars])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}

		PlayerData[playerid][pCigars] -= amount;
		PlayerData[targetid][pCigars] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", PlayerData[playerid][pCigars], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", PlayerData[targetid][pCigars], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i cigars.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i cigars to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some cigars to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i cigars to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "spraycans", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [spraycans] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pSpraycans])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}

		PlayerData[playerid][pSpraycans] -= amount;
		PlayerData[targetid][pSpraycans] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[targetid][pSpraycans], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i spraycans.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i spraycans to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some spraycans to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i spraycans to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "gascan", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [gascan] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pGasCan])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
        if(PlayerData[targetid][pGasCan] + amount > GetPlayerCapacity(targetid, CAPACITY_GAZCAN))
        {
		    return SendClientMessage(playerid, COLOR_GREY, "You don't have space for this item.");
        }
		PlayerData[playerid][pGasCan] -= amount;
		PlayerData[targetid][pGasCan] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", PlayerData[playerid][pGasCan], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", PlayerData[targetid][pGasCan], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i liters of gasoline.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i liters of gasoline to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some gasoline to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i liters of gasoline to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "seeds", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [seeds] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pSeeds])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pSeeds] + amount > GetPlayerCapacity(targetid, CAPACITY_SEEDS))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more seeds.");
		}

		PlayerData[playerid][pSeeds] -= amount;
		PlayerData[targetid][pSeeds] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[targetid][pSeeds], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i seeds.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i seeds to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some seeds to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i seeds to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "chems", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [chems] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pEphedrine])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pEphedrine] + amount > GetPlayerCapacity(targetid, CAPACITY_EPHEDRINE))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more chems.");
		}

		PlayerData[playerid][pEphedrine] -= amount;
		PlayerData[targetid][pEphedrine] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = %i WHERE uid = %i", PlayerData[playerid][pEphedrine], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = %i WHERE uid = %i", PlayerData[targetid][pEphedrine], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of chems.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of chems to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some chems to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i grams of chems to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "firstaid", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [firstaid] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pFirstAid])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pFirstAid] + amount > 20)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more first aid kits.");
		}

		PlayerData[playerid][pFirstAid] -= amount;
		PlayerData[targetid][pFirstAid] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[targetid][pFirstAid], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i first aid kits.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i first aid kits to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some first aid kits to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i first aid kits to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "bodykits", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [bodykits] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pBodykits])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pBodykits] + amount > 10)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more bodykits.");
		}

		PlayerData[playerid][pBodykits] -= amount;
		PlayerData[targetid][pBodykits] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[targetid][pBodykits], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i bodywork kits.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i bodywork kits to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some bodywork kits to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i bodywork kits to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "rimkits", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [rimkits] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pRimkits])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pRimkits] + amount > 5)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more rimkits.");
		}

		PlayerData[playerid][pRimkits] -= amount;
		PlayerData[targetid][pRimkits] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rimkits = %i WHERE uid = %i", PlayerData[playerid][pRimkits], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rimkits = %i WHERE uid = %i", PlayerData[targetid][pRimkits], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i rimkits.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i rimkits to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some rimkits to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i rimkits to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "diamonds", true))
	{
	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [diamonds] [amount]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pDiamonds])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(PlayerData[targetid][pDiamonds] + amount > 5)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more diamonds.");
		}

		PlayerData[playerid][pDiamonds] -= amount;
		PlayerData[targetid][pDiamonds] += amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", PlayerData[playerid][pDiamonds], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", PlayerData[targetid][pDiamonds], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i diamonds.", GetRPName(playerid), amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i diamonds to %s.", amount, GetRPName(targetid));

		ShowActionBubble(playerid, "* %s gives some rimkits to %s.", GetRPName(playerid), GetRPName(targetid));
	    Log_Write("log_give", "%s (uid: %i) gives %i diamonds to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}

	return 1;
}

CMD:sellmats(playerid,params[])
{
	new targetid, amount, price;
	if(!PlayerHasJob(playerid, JOB_ARMSDEALER) && !PlayerHasJob(playerid, JOB_CRAFTMAN))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Craft Man or Arms Dealer.");
	}
	
	if(sscanf(params, "iii", targetid, amount, price))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmats [playerid] [amount] [price]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(amount < 1 || amount > PlayerData[playerid][pMaterials])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(price < 1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
	}

	PlayerData[playerid][pLastSell] = gettime();
	PlayerData[targetid][pSellOffer] = playerid;
	PlayerData[targetid][pSellType] = ITEM_MATERIALS;
	PlayerData[targetid][pSellExtra] = amount;
	PlayerData[targetid][pSellPrice] = price;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i materials for $%i. (/accept item)", GetRPName(playerid), amount, price);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i materials for $%i.", GetRPName(targetid), amount, price);
	return 1;
}
CMD:sell(playerid, params[])
{
	new targetid, option[14], param[32], amount, price;

	if(sscanf(params, "us[14]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapon, Materials, Weed, Crack, Heroin, Painkillers, Seeds, Ephedrine");
	    return 1;
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
    if(gettime() - PlayerData[playerid][pLastSell] < 10)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
	}

	if(!strcmp(option, "weapon", true))
	{
	    new weaponid;

		if(sscanf(param, "ii", weaponid, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [weapon] [weaponid] [price] (/guninv for weapon IDs)");
		}
	    if(!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You don't have that weapon. /guninv for a list of your weapons.");
		}
	    if(PlayerData[targetid][pWeapons][GetWeaponSlot(weaponid)] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player already has a weapon in that slot.");
	    }
	    if(PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
	    {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
	    }
	    if(PlayerData[playerid][pFaction] >= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons as a faction member.");
	    }
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}
		if(IsPlayerInAnyVehicle(playerid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons from inside a vehicle.");
		}
		if(IsPlayerInAnyVehicle(targetid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons to players inside a vehicle.");
		}
		if(GetPlayerHealthEx(playerid) < 60)
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons as your health is below 60.");
		}

        PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_WEAPON;
		PlayerData[targetid][pSellExtra] = weaponid;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you their %s for $%i. (/accept item)", GetRPName(playerid), GetWeaponNameEx(weaponid), price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %s for $%i.", GetRPName(targetid), GetWeaponNameEx(weaponid), price);
	}
	else if(!strcmp(option, "materials", true))
	{
		
		if(!PlayerHasJob(playerid, JOB_ARMSDEALER) && !PlayerHasJob(playerid, JOB_CRAFTMAN))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Craft Man or Arms Dealer.");
		}
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [materials] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pMaterials])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_MATERIALS;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i materials for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i materials for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "weed", true))
	{	
		if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
		}
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [weed] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pWeed])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_WEED;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of weed for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of weed for $%i.", GetRPName(targetid), amount, price);
	}
    else if(!strcmp(option, "crack", true))
	{
		if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
		}
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [crack] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pCocaine])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_COCAINE;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of crack for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of crack for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "heroin", true))
	{
		if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
		}
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [heroin] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pHeroin])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_HEROIN;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of heroin for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of heroin for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "painkillers", true))
	{
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [painkillers] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pPainkillers])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_PAINKILLERS;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i painkillers for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i painkillers for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "seeds", true))
	{
		if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
		}
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [seeds] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pSeeds])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_SEEDS;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;

		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i seeds for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i seeds for $%i.", GetRPName(targetid), amount, price);
	}
	else if(!strcmp(option, "chems", true))
	{
		if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
		}
		if(sscanf(param, "ii", amount, price))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [chems] [amount] [price]");
		}
		if(amount < 1 || amount > PlayerData[playerid][pEphedrine])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}
		if(price < 1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_EPHEDRINE;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;
		
		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of chems for $%i. (/accept item)", GetRPName(playerid), amount, price);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of chems for $%i.", GetRPName(targetid), amount, price);
	}

	return 1;
}



CMD:customaccent(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, COLOR_GREY, "/customaccent [accent]");
	}
	strcpy(PlayerData[playerid][pAccent], params, 16);
	SendClientMessageEx(playerid, COLOR_WHITE, "You set your accent to '%s'.", PlayerData[playerid][pAccent]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET accent = '%e' WHERE uid = %i", PlayerData[playerid][pAccent], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}
CMD:accent(playerid, params[])
{
	new type;

	if(sscanf(params, "i", type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /accent [type]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (0) None - (1) English - (2) American - (3) British - (4) Chinese - (5) Korean - (6) Japanese - (7) Asian");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (8) Canadian - (9) Australian - (10) Southern - (11) Russian - (12) Ukrainian - (13) German - (14) French");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (15) Portguese - (16) Polish - (17) Estonian - (18) Latvian - (19) Dutch - (20) Jamaican - (21) Turkish");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (22) Mexican - (23) Spanish - (24) Arabic - (25) Israeli - (26) Romanian - (27) Italian - (28) Gangsta");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (29) Greek - (30) Serbian - (31) Balkin - (32) Danish - (33) Scottish - (34) Irish - (35) Indian");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (36) Norwegian - (37) Swedish - (38) Finnish - (39) Hungarian - (40) Bulgarian - (41) Pakistani");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (42) Cuban - (43) Slavic - (44) Indonesian - (45) Filipino - (46) Hawaiian - (47) Somalian");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of accents: (48) Armenian - (49) Persian - (50) Vietnamese - (51) Slovenian - (52) Kiwi - (53) Brazilian - (54) Georgian");
		return 1;
	}

	switch(type)
	{
		case 0: strcpy(PlayerData[playerid][pAccent], "None", 16);
		case 1: strcpy(PlayerData[playerid][pAccent], "English", 16);
		case 2: strcpy(PlayerData[playerid][pAccent], "American", 16);
		case 3: strcpy(PlayerData[playerid][pAccent], "British", 16);
		case 4: strcpy(PlayerData[playerid][pAccent], "Chinese", 16);
		case 5: strcpy(PlayerData[playerid][pAccent], "Korean", 16);
		case 6: strcpy(PlayerData[playerid][pAccent], "Japanese", 16);
		case 7: strcpy(PlayerData[playerid][pAccent], "Asian", 16);
		case 8: strcpy(PlayerData[playerid][pAccent], "Canadian", 16);
		case 9: strcpy(PlayerData[playerid][pAccent], "Australian", 16);
		case 10: strcpy(PlayerData[playerid][pAccent], "Southern", 16);
		case 11: strcpy(PlayerData[playerid][pAccent], "Russian", 16);
		case 12: strcpy(PlayerData[playerid][pAccent], "Ukrainian", 16);
		case 13: strcpy(PlayerData[playerid][pAccent], "German", 16);
		case 14: strcpy(PlayerData[playerid][pAccent], "French", 16);
		case 15: strcpy(PlayerData[playerid][pAccent], "Portuguese", 16);
		case 16: strcpy(PlayerData[playerid][pAccent], "Polish", 16);
		case 17: strcpy(PlayerData[playerid][pAccent], "Estonian", 16);
		case 18: strcpy(PlayerData[playerid][pAccent], "Latvian", 16);
		case 19: strcpy(PlayerData[playerid][pAccent], "Dutch", 16);
		case 20: strcpy(PlayerData[playerid][pAccent], "Jamaican", 16);
		case 21: strcpy(PlayerData[playerid][pAccent], "Turkish", 16);
		case 22: strcpy(PlayerData[playerid][pAccent], "Mexican", 16);
		case 23: strcpy(PlayerData[playerid][pAccent], "Spanish", 16);
		case 24: strcpy(PlayerData[playerid][pAccent], "Arabic", 16);
		case 25: strcpy(PlayerData[playerid][pAccent], "Israeli", 16);
		case 26: strcpy(PlayerData[playerid][pAccent], "Romanian", 16);
		case 27: strcpy(PlayerData[playerid][pAccent], "Italian", 16);
		case 28: strcpy(PlayerData[playerid][pAccent], "Gangsta", 16);
		case 29: strcpy(PlayerData[playerid][pAccent], "Greek", 16);
		case 30: strcpy(PlayerData[playerid][pAccent], "Serbian", 16);
		case 31: strcpy(PlayerData[playerid][pAccent], "Balkin", 16);
		case 32: strcpy(PlayerData[playerid][pAccent], "Danish", 16);
		case 33: strcpy(PlayerData[playerid][pAccent], "Scottish", 16);
		case 34: strcpy(PlayerData[playerid][pAccent], "Irish", 16);
		case 35: strcpy(PlayerData[playerid][pAccent], "Indian", 16);
		case 36: strcpy(PlayerData[playerid][pAccent], "Norwegian", 16);
		case 37: strcpy(PlayerData[playerid][pAccent], "Swedish", 16);
		case 38: strcpy(PlayerData[playerid][pAccent], "Finnish", 16);
		case 39: strcpy(PlayerData[playerid][pAccent], "Hungarian", 16);
		case 40: strcpy(PlayerData[playerid][pAccent], "Bulgarian", 16);
		case 41: strcpy(PlayerData[playerid][pAccent], "Pakistani", 16);
		case 42: strcpy(PlayerData[playerid][pAccent], "Cuban", 16);
		case 43: strcpy(PlayerData[playerid][pAccent], "Slavic", 16);
		case 44: strcpy(PlayerData[playerid][pAccent], "Indonesian", 16);
		case 45: strcpy(PlayerData[playerid][pAccent], "Filipino", 16);
		case 46: strcpy(PlayerData[playerid][pAccent], "Hawaiian", 16);
		case 47: strcpy(PlayerData[playerid][pAccent], "Somalian", 16);
		case 48: strcpy(PlayerData[playerid][pAccent], "Armenian", 16);
		case 49: strcpy(PlayerData[playerid][pAccent], "Persian", 16);
		case 50: strcpy(PlayerData[playerid][pAccent], "Vietnamese", 16);
		case 51: strcpy(PlayerData[playerid][pAccent], "Slovenian", 16);
		case 52: strcpy(PlayerData[playerid][pAccent], "Kiwi", 16);
		case 53: strcpy(PlayerData[playerid][pAccent], "Brazilian", 16);
		case 54: strcpy(PlayerData[playerid][pAccent], "Georgian", 16);
		default: SendClientMessage(playerid, COLOR_GREY, "Invalid accent. Valid types range from 0 to 53.");
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "You set your accent to '%s'.", PlayerData[playerid][pAccent]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET accent = '%e' WHERE uid = %i", PlayerData[playerid][pAccent], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:dice(playerid, params[])
{
	SendProximityMessage(playerid, 20.0, COLOR_WHITE, "* %s rolls a dice which lands on the number %i.", GetRPName(playerid), random(6) + 1);
	return 1;
}

CMD:xdice(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "DICE CHEAT ON BY xXLordXx.");
	SendClientMessageEx(playerid, COLOR_GREEN, "Detecing player's dices....");
	return 1;
}

CMD:time(playerid, params[])
{
	new
	    string[128],
		date[6];

	getdate(date[0], date[1], date[2]);
	gettime(date[3], date[4], date[5]);

	switch(date[1])
	{
	    case 1: string = "January";
	    case 2: string = "February";
	    case 3: string = "March";
	    case 4: string = "April";
	    case 5: string = "May";
	    case 6: string = "June";
	    case 7: string = "July";
	    case 8: string = "August";
	    case 9: string = "September";
	    case 10: string = "October";
	    case 11: string = "November";
	    case 12: string = "December";
	}

	format(string, sizeof(string), "~y~%s %02d, %i~n~~g~|~w~%02d:%02d:%02d~g~|", string, date[2], date[0], date[3], date[4], date[5]);

	if(PlayerData[playerid][pJailTime] > 0)
	{
	    format(string, sizeof(string), "%s~n~~w~Jail Time: ~y~%i seconds", string, PlayerData[playerid][pJailTime]);
	}

	GameTextForPlayer(playerid, string, 5000, 1);
	SendClientMessageEx(playerid, COLOR_WHITE, "* Paychecks occur at every hour. The next paycheck is at %02d:00 which is in %i minutes.", date[3]+1, (60 - date[4]));
	return 1;
}


CMD:helpme(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /helpme [help request]");
	}
	if(PlayerData[playerid][pHelper] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are a helper and therefore can't use this command.");
	}
	if(PlayerData[playerid][pHelpMuted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are muted from submitting help requests.");
	}
	if(gettime() - PlayerData[playerid][pLastRequest] < 30)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only submit one help request every 30 seconds. Please wait %i more seconds.", 30 - (gettime() - PlayerData[playerid][pLastRequest]));
	}

	strcpy(PlayerData[playerid][pHelpRequest], params, 128);
	SendHelperMessage(COLOR_AQUA, "* Help Request from %s[%i]: %s *", GetRPName(playerid), playerid, params);

	PlayerData[playerid][pLastRequest] = gettime();
	SendClientMessage(playerid, COLOR_GREEN, "Your help request was sent to all helpers. Please wait for a response.");
	return 1;
}

forward GivePlayerMaterials(playerid, amount);
public GivePlayerMaterials(playerid, amount)
{
    if (PlayerData[playerid][pLogged])
    {
        PlayerData[playerid][pMaterials] = PlayerData[playerid][pMaterials] + amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
    return 1;
}

CMD:accept(playerid, params[])
{
	if(!strcmp(params, "drink", true))
	{
		AcceptDrink(playerid);
	}else if(!strcmp(params, "craft", true))
	{
		AcceptCraft(playerid);
	}else if(!strcmp(params, "carry", true))
	{
		AcceptCarry(playerid);
	}else if(!strcmp(params, "house", true))
	{
		new
		    offeredby = PlayerData[playerid][pHouseOffer],
		    houseid = PlayerData[playerid][pHouseOffered],
		    price = PlayerData[playerid][pHousePrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a house.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(!IsHouseOwner(offeredby, houseid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this house.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's house.");
	    }
	    if(GetPlayerAssetCount(playerid, LIMIT_HOUSES) >= GetPlayerAssetLimit(playerid, LIMIT_HOUSES))
		{
	    	return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i houses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
		}

	    SetHouseOwner(houseid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's house offer and paid %s for their house.", GetRPName(offeredby), FormatCash(price));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your house offer and paid %s for your house.", GetRPName(playerid), FormatCash(price));
	    Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their house (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), HouseInfo[houseid][hID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

	    PlayerData[playerid][pHouseOffer] = INVALID_PLAYER_ID;
        AwardAchievement(playerid, ACH_HomeSweetHome);
	}
	else if(!strcmp(params, "gangweapons", true))
	{
		if (PlayerData[playerid][pSellOffer] == INVALID_PLAYER_ID || PlayerData[playerid][pSellType] != ITEM_GSELLGUN)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a weapon.");
		}
		if (PlayerData[playerid][pGang] == -1)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang.");
		}

		new gangid    = PlayerData[playerid][pGang];
		new offeredby = PlayerData[playerid][pSellOffer];
		new weaponid  = PlayerData[playerid][pSellExtra];
		new qty       = PlayerData[playerid][pSellQuantity];
		new price     = PlayerData[playerid][pSellPrice];
		new unitcost  = GetCraftWeaponPrice(playerid, weaponid);
		new cost      = unitcost * qty;

		new noto      = qty * 100;

		if (PlayerData[playerid][pCash] < price)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase the weapon.");
		}

		if (unitcost == -1)
		{
			return SendClientMessageEx(playerid, COLOR_AQUA, "Trader cannot craft this weapon {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
		}
		if (PlayerData[offeredby][pMaterials] < cost)
		{
			return SendClientMessage(playerid, COLOR_GREY, "Trader can't sell these weapons.");
		}

		if (!AddWeaponToGangStash(gangid, weaponid, qty))
		{
			return SendClientMessage(playerid, COLOR_GREY, "Trader can't sell these weapons.");
		}

		GivePlayerMaterials(offeredby, -cost);
		GivePlayerCash(playerid, -price);
		GivePlayerCash(offeredby,  price);
		GiveNotoriety(playerid, noto);
		GiveNotoriety(offeredby, noto);
		GivePlayerRankPointIllegalJob(offeredby, 200);

		SendClientMessageEx(playerid, COLOR_AQUA, "You have gained %d notoriety for gang weapons dealing, you now have %d.", noto, PlayerData[playerid][pNotoriety]);
		SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained %d notoriety for gang weapons dealing, you now have %d.", noto, PlayerData[offeredby][pNotoriety]);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i %s from %s for %s. You can find them in your gang stash.", qty, GetWeaponNameEx(weaponid), GetRPName(offeredby), FormatCash(price));
		SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i %s for %s.", GetRPName(playerid), qty, GetWeaponNameEx(weaponid), FormatCash(price));
		Log_Write("log_give", "%s (uid: %i) has sold %i %s to %s (uid: %i) for $%i for gang %s (id: %i).",
			GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], qty, GetWeaponNameEx(weaponid),
			GetPlayerNameEx(playerid), PlayerData[playerid][pID], price, GangInfo[gangid][gName], gangid);

		PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "garage", true))
	{
		new
		    offeredby = PlayerData[playerid][pGarageOffer],
		    garageid = PlayerData[playerid][pGarageOffered],
		    price = PlayerData[playerid][pGaragePrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a garage.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(!IsGarageOwner(offeredby, garageid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this garage.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's garage.");
	    }
	    if(GetPlayerAssetCount(playerid, LIMIT_GARAGES) >= GetPlayerAssetLimit(playerid, LIMIT_GARAGES))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i garages. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
		}

	    SetGarageOwner(garageid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's garage offer and paid %s for their garage.", GetRPName(offeredby), FormatCash(price));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your garage offer and paid %s for your garage.", GetRPName(playerid), FormatCash(price));
        Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their %s garage (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

	    PlayerData[playerid][pGarageOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "business", true))
	{
		new
		    offeredby = PlayerData[playerid][pBizOffer],
		    businessid = PlayerData[playerid][pBizOffered],
		    price = PlayerData[playerid][pBizPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a business.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(!IsBusinessOwner(offeredby, businessid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this business.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's business.");
	    }
	    if(GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) >= GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES))
		{
	    	return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i businesses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
		}

	    SetBusinessOwner(businessid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's business offer and paid %s for their %s.", GetRPName(offeredby), FormatCash(price), bizInteriors[BusinessInfo[businessid][bType]][intType]);
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your business offer and paid %s for your %s.", GetRPName(playerid), FormatCash(price), bizInteriors[BusinessInfo[businessid][bType]][intType]);
        Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their %s business (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

	    PlayerData[playerid][pBizOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "land", true))
	{
		new
		    offeredby = PlayerData[playerid][pLandOffer],
		    landid = PlayerData[playerid][pLandOffered],
		    price = PlayerData[playerid][pLandPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a land.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(!IsLandOwner(offeredby, landid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this land.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's land.");
	    }

	    SetLandOwner(landid, playerid);

	    GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's land offer and paid %s for their land.", GetRPName(offeredby), FormatCash(price));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your land offer and paid %s for your land.", GetRPName(playerid), FormatCash(price));
	    Log_Write("log_property", "%s (uid: %i) (IP: %s) sold their land (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), LandInfo[landid][lID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

	    PlayerData[playerid][pLandOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "death", true))
	{
	    if(PlayerData[playerid][pInjured] == 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not injured and can't accept your death.");
	    }
		if(gettime() - PlayerData[playerid][pInjured] < 15)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %d seconds to accept your death.", 15 - (gettime() - PlayerData[playerid][pInjured]));
		}
		if (IsPlayerInAnyVehicle(playerid))
    	{
        	return SendClientMessageEx(playerid, COLOR_GREY, "You cannot accept death while you are in an ambulance");
    	}
		if (IsPlayerConnected(PlayerData[playerid][pAcceptedEMS]))
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You cannot accept death. An ambulance is on the way to get you.");
		}

	    SendClientMessage(playerid, COLOR_GREY, "You have given up and accepted your fate.");

	    DamagePlayer(playerid, 300, playerid, WEAPON_KNIFE, BODY_PART_UNKNOWN, false);
	}
	else if(!strcmp(params, "vest", true))
	{
		new
		    offeredby = PlayerData[playerid][pVestOffer],
		    price = PlayerData[playerid][pVestPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a vest.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy the vest.");
	    }

	    new Float:armor = 50.0 ;

		SetScriptArmour(playerid, armor);
		GivePlayerCash(offeredby, price);
	    GivePlayerCash(playerid, -price);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's vest and paid %s for %.1f armor points.", GetRPName(offeredby), FormatCash(price), armor);
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your vest offer and paid %s for %.1f armor points.", GetRPName(playerid), FormatCash(price), armor);

	    TurfTaxCheck(offeredby, price);
	    //IncreaseJobSkill(offeredby, JOB_BODYGUARD);

	    PlayerData[playerid][pVestOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "vehicle", true))
	{
		new
		    offeredby = PlayerData[playerid][pCarOffer],
		    vehicleid = PlayerData[playerid][pCarOffered],
		    price = PlayerData[playerid][pCarPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a vehicle.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(!IsVehicleOwner(offeredby, vehicleid))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this vehicle.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's vehicle.");
	    }
	    if(GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES)
    	{
   			return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
    	}

    	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
     	mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptBuyVehicleEx", "iiii", playerid, offeredby, vehicleid, price);

	    PlayerData[playerid][pCarOffer] = INVALID_PLAYER_ID;
        AwardAchievement(playerid, ACH_FirstWheels);
	}
	else if(!strcmp(params, "faction", true))
	{
	    if(PlayerData[playerid][pLevel] < 3 )
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need to be level 3+ to join a faction.");
	    }
		new
		    offeredby = PlayerData[playerid][pFactionOffer],
		    factionid = PlayerData[playerid][pFactionOffered];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invites to a faction.");
	    }
	    if(PlayerData[offeredby][pFaction] != factionid || !PlayerData[offeredby][pFactionLeader])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is no longer allowed to invite you.");
	    }

	    SetPlayerFaction(playerid, factionid, 0);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's faction offer to join {00AA00}%s{33CCFF}.", GetRPName(offeredby), FactionInfo[factionid][fName]);
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your faction offer and is now apart of your faction.", GetRPName(playerid));

		Log_Write("log_faction", "%s (uid: %i) has invited %s (uid: %i) to %s (id: %i).", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID], FactionInfo[factionid][fName], factionid);
	    PlayerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "gang", true))
	{
	    if(PlayerData[playerid][pLevel] < 3 )
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need to be level 3+ to join a gang.");
	    }
		new
		    offeredby = PlayerData[playerid][pGangOffer],
		    gangid = PlayerData[playerid][pGangOffered];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invites to a gang.");
	    }
	    if(PlayerData[offeredby][pGang] != gangid || PlayerData[offeredby][pGangRank] < 5)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is no longer allowed to invite you.");
	    }

        GangInfo[gangid][gCount]++;

	    PlayerData[playerid][pGang] = gangid;
	    PlayerData[playerid][pGangRank] = 0;
	    PlayerData[playerid][pCrew] = -1;
        
        ResetPlayerCommitRankPoints(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gang = %i, gangrank = 0, crew = -1 WHERE uid = %i", gangid, PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's gang offer to join {00AA00}%s{33CCFF}.", GetRPName(offeredby), GangInfo[gangid][gName]);
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your gang offer and is now apart of your gang.", GetRPName(playerid));
	    if(GetGangInviteCooldown())
	    {
	        GangInfo[gangid][gInvCooldown] = GetGangInviteCooldown();
	    	SendClientMessageEx(offeredby, COLOR_GREEN, "A invite cooldown has been placed on your gang. You cannot invite anyone for the next %i minutes!", GangInfo[gangid][gInvCooldown]);
        }
		Log_Write("log_gang", "%s (uid: %i) has invited %s (uid: %i) to %s (id: %i).", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
	    PlayerData[playerid][pGangOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "frisk", true))
	{
	    new offeredby = PlayerData[playerid][pFriskOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers to be frisked.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }

	    FriskPlayer(offeredby, playerid);
	    PlayerData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "ticket", true))
	{
		new
		    offeredby = PlayerData[playerid][pTicketOffer],
		    price = PlayerData[playerid][pTicketPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a ticket.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to pay this ticket.");
	    }

	    //GivePlayerCash(offeredby, price);

	    AddToTaxVault(price);
	    GivePlayerCash(playerid, -price);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have paid the %s ticket written by %s.", FormatCash(price), GetRPName(offeredby));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has paid the %s ticket which was written to them.", GetRPName(playerid), FormatCash(price));
        Log_Write("log_faction", "%s (uid: %i) has paid %s (uid: %i) a ticket for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], price);
		new query[516], year, month, day, hour, minute, second;
		getdate(year, month, day);
		gettime(hour,minute,second);
		new datum[64], timel[64];
		format(timel, sizeof(timel), "%d:%d:%d", hour, minute, second);
	 	format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
		format(query, sizeof(query), "INSERT INTO tickets(`player`, `officer`, `time`, `date`, `amount`, `reason`) VALUES ('%s','%s','%s','%s',%d,'%s')",
	    GetPlayerNameEx(playerid), GetPlayerNameEx(offeredby),
		timel,datum, price, PlayerData[playerid][pTicketReason]);
		mysql_tquery(connectionID, query);
	    PlayerData[playerid][pTicketOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "sex", true))
	{
		OnAcceptSex(playerid);    
	}
	else if(!strcmp(params, "live", true))
	{
	    new offeredby = PlayerData[playerid][pLiveOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a live interview.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID || PlayerData[offeredby][pCallLine] != INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You or the offerer can't be on a phone call during a live interview.");
	    }

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's live interview offer. Speak in IC chat to begin the interview!", GetRPName(offeredby));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your live interview offer. Speak in IC chat to begin the interview!", GetRPName(playerid));
        Log_Write("log_faction", "%s (uid: %i) has started a live interview with %s (uid: %i)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID]);

		PlayerData[playerid][pLiveBroadcast] = offeredby;
		PlayerData[offeredby][pLiveBroadcast] = playerid;
  		PlayerData[playerid][pLiveOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "handshake", true))
	{
	    new offeredby = PlayerData[playerid][pShakeOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a handshake.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }

	    ClearAnimations(playerid);
		ClearAnimations(offeredby);

		SetPlayerToFacePlayer(playerid, offeredby);
		SetPlayerToFacePlayer(offeredby, playerid);

		switch(PlayerData[playerid][pShakeType])
		{
		    case 1:
		    {
				ApplyAnimation(playerid,  "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 2:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 3:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 4:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 5:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(offeredby, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 6:
			{
			    ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
			    ApplyAnimation(offeredby, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
			}
	    }

        AwardAchievement(playerid, ACH_MeetingPeople);
        AwardAchievement(offeredby, ACH_MeetingPeople);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's handshake offer.", GetRPName(offeredby));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your handshake offer.", GetRPName(playerid));

  		PlayerData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "item", true))
	{
		new
		    offeredby = PlayerData[playerid][pSellOffer],
		    type = PlayerData[playerid][pSellType],
		    amount = PlayerData[playerid][pSellExtra],
		    price = PlayerData[playerid][pSellPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for an item.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to accept the offer.");
	    }

	    switch(type)
	    {
	        case ITEM_WEAPON:
			{
			    new weaponid = PlayerData[playerid][pSellExtra];

	            if(!PlayerHasWeapon(offeredby, weaponid))
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
	            }

	            GivePlayerCash(playerid, -price);
	            GivePlayerCash(offeredby, price);

                GivePlayerRankPointIllegalJob(offeredby, 20);

	            GivePlayerWeaponEx(playerid, weaponid);
	            RemovePlayerWeapon(offeredby, weaponid);

				SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %s's %s for %s.", GetRPName(offeredby), GetWeaponNameEx(weaponid), FormatCash(price));
				SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %s for %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), FormatCash(price));
				Log_Write("log_give", "%s (uid: %i) has sold their %s to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetWeaponNameEx(weaponid), GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

				TurfTaxCheck(offeredby, price);
				GiveNotoriety(playerid, 20);
				GiveNotoriety(offeredby, 20);	
				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[offeredby][pNotoriety]);

				PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_MATERIALS:
			{
			    if(PlayerData[offeredby][pMaterials] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pMaterials] += amount;
			    PlayerData[offeredby][pMaterials] -= amount;
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[offeredby][pMaterials], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i materials from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i materials for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i materials to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

                TurfTaxCheck(offeredby, price);

                GivePlayerRankPointIllegalJob(offeredby, price*amount/400000);

				GiveNotoriety(playerid, 20);
				GiveNotoriety(offeredby, 20);	
				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[offeredby][pNotoriety]);
			    
				PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_WEED:
			{
			    if(PlayerData[offeredby][pWeed] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][pWeed] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
				}

				AwardAchievement(playerid, ACH_DirtyDeeds);
				AwardAchievement(offeredby, ACH_DirtyDeeds);

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pWeed] += amount;
			    PlayerData[offeredby][pWeed] -= amount;
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[offeredby][pWeed], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of weed from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of weed for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i grams of weed to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

                TurfTaxCheck(offeredby, price);

				GiveNotoriety(playerid, 20);
				GiveNotoriety(offeredby, 20);	
                GivePlayerRankPointIllegalJob(offeredby, price*amount/350);
				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);
			    
			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_COCAINE:
			{
			    if(PlayerData[offeredby][pCocaine] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i crack. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				}

			    AwardAchievement(playerid, ACH_DirtyDeeds);
				AwardAchievement(offeredby, ACH_DirtyDeeds);

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pCocaine] += amount;
			    PlayerData[offeredby][pCocaine] -= amount;
				
				IncreaseJobSkill(offeredby, JOB_DRUGDEALER);
				
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[offeredby][pCocaine], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of crack from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of crack for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i grams of crack to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

			    TurfTaxCheck(offeredby, price);
                GivePlayerRankPointIllegalJob(offeredby, price*amount/250);

				GiveNotoriety(playerid, 20);
				GiveNotoriety(offeredby, 20);	
				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);
			    
			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_HEROIN:
			{
			    if(PlayerData[offeredby][pHeroin] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][pHeroin] + amount > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
				}

			    AwardAchievement(playerid, ACH_DirtyDeeds);
				AwardAchievement(offeredby, ACH_DirtyDeeds);

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pHeroin] += amount;
			    PlayerData[offeredby][pHeroin] -= amount;
				
				IncreaseJobSkill(offeredby, JOB_DRUGDEALER);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[offeredby][pHeroin], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of Heroin from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of Heroin for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i grams of Heroin to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

			    TurfTaxCheck(offeredby, price);

				GiveNotoriety(playerid, 20);
				GiveNotoriety(offeredby, 20);
                GivePlayerRankPointIllegalJob(offeredby, price*amount/200);

				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);
			    
			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_PAINKILLERS:
			{
			    if(PlayerData[offeredby][pPainkillers] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
				if(PlayerData[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				}

			    AwardAchievement(playerid, ACH_DirtyDeeds);
				AwardAchievement(offeredby, ACH_DirtyDeeds);

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pPainkillers] += amount;
			    PlayerData[offeredby][pPainkillers] -= amount;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[offeredby][pPainkillers], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i painkillers from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i painkillers for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i painkillers to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);
                GivePlayerRankPointLegalJob(offeredby, 50);

			    TurfTaxCheck(offeredby, price);

			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
			case ITEM_SEEDS:
			{
			    if(PlayerData[offeredby][pSeeds] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i seeds. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS));
				}

			    AwardAchievement(playerid, ACH_DirtyDeeds);
				AwardAchievement(offeredby, ACH_DirtyDeeds);

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pSeeds] += amount;
			    PlayerData[offeredby][pSeeds] -= amount;
				
				IncreaseJobSkill(offeredby, JOB_DRUGDEALER);
                GivePlayerRankPointIllegalJob(offeredby, price*amount/400);


			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[offeredby][pSeeds], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i seeds from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i seeds for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i seeds to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

			    TurfTaxCheck(offeredby, price);

				GiveNotoriety(playerid, 5);
				GiveNotoriety(offeredby, 5);	
				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);
			    
			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
            case ITEM_EPHEDRINE:
			{
			    if(PlayerData[offeredby][pEphedrine] < amount)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][pEphedrine] + amount > GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE))
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i chems. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pEphedrine], GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE));
				}

			    AwardAchievement(playerid, ACH_DirtyDeeds);
				AwardAchievement(offeredby, ACH_DirtyDeeds);

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pEphedrine] += amount;
			    PlayerData[offeredby][pEphedrine] -= amount;
				
				IncreaseJobSkill(offeredby, JOB_DRUGDEALER);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = %i WHERE uid = %i", PlayerData[playerid][pEphedrine], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = %i WHERE uid = %i", PlayerData[offeredby][pEphedrine], PlayerData[offeredby][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of chems from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
			    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of chems for %s.", GetRPName(playerid), amount, FormatCash(price));
			    Log_Write("log_give", "%s (uid: %i) has sold their %i grams of chems to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

			    TurfTaxCheck(offeredby, price);

                GivePlayerRankPointIllegalJob(playerid, price * amount / 400);

				GiveNotoriety(playerid, 5);
				GiveNotoriety(offeredby, 5);	
				SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
				SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);
			    
			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
		}
	}
	else if(!strcmp(params, "weapon", true))
	{
	    if(PlayerData[playerid][pSellOffer] == INVALID_PLAYER_ID || PlayerData[playerid][pSellType] != ITEM_SELLGUN)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a weapon.");
	    }
	    if(PlayerData[playerid][pCash] < PlayerData[playerid][pSellPrice])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase the weapon.");
	    }
		if(PlayerHasWeapon(playerid, PlayerData[playerid][pSellExtra]))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "You already have this weapon.");
		}
	    SellWeapon(PlayerData[playerid][pSellOffer], playerid, PlayerData[playerid][pSellExtra], PlayerData[playerid][pSellPrice]);
        GivePlayerRankPointIllegalJob(PlayerData[playerid][pSellOffer], 20);
		
		PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "lawyer", true))
	{
	    new
			offeredby = PlayerData[playerid][pDefendOffer],
			price = PlayerData[playerid][pDefendPrice];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers from a lawyer.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerData[playerid][pCash] < price)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to accept the offer.");
	    }
		if (IsPlayerInBankRobbery(playerid))
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can't be defended while in bank robbery.");
		}
	    if(!PlayerData[playerid][pWantedLevel])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are no longer wanted. You can't accept this offer anymore.");
	    }

		PlayerData[playerid][pWantedLevel]--;
        GivePlayerRankPointLegalJob(offeredby, 80);


	    GivePlayerCash(playerid, -price);
	    GivePlayerCash(offeredby, price);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = %i WHERE uid = %i", PlayerData[playerid][pWantedLevel], PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's offer to reduce your wanted level for %s.", GetRPName(offeredby), FormatCash(price));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your offer to reduce their wanted level for %s.", GetRPName(playerid), FormatCash(price));

		IncreaseJobSkill(offeredby, JOB_LAWYER);
	    PlayerData[playerid][pDefendOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "dicebet", true))
	{
	    new
			offeredby = PlayerData[playerid][pDiceOffer],
			amount = PlayerData[playerid][pDiceBet];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for dice betting.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(PlayerData[playerid][pCash] < amount)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to accept this bet.");
	    }
	    if(PlayerData[offeredby][pCash] < amount)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player can't afford to accept this bet.");
	    }

		new
			rand[2];

		if(PlayerData[playerid][pDiceRigged])
		{
		    rand[0] = 4 + random(3);
		    rand[1] = random(3) + 1;
		}
		else
		{
			for(new x = 0; x < random(50)*random(50)+30; x++)
			{
				rand[0] = random(6) + 1;
			}
			for(new x = 0; x < random(50)*random(50)+30; x++)
			{
				rand[1] = random(6) + 1;
			}
		}

		SendProximityMessage(offeredby, 20.0, COLOR_WHITE, "* %s rolls a dice which lands on the number %i.", GetRPName(offeredby), rand[0]);
		SendProximityMessage(playerid, 20.0, COLOR_WHITE, "* %s rolls a dice which lands on the number %i.", GetRPName(playerid), rand[1]);

		if(rand[0] > rand[1])
		{

		    GivePlayerCash(offeredby, amount);
		    GivePlayerCash(playerid, -amount);

		    SendClientMessageEx(offeredby, COLOR_AQUA, "* You have won $%s from your dice bet with %s.", FormatCash(amount), GetRPName(playerid));
		    SendClientMessageEx(playerid, COLOR_RED, "* You have lost $%s from your dice bet with %s.", FormatCash(amount), GetRPName(offeredby));

			if(amount > 10000 && !strcmp(GetPlayerIP(offeredby), GetPlayerIP(playerid)))
			{
				SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) won a $%i dice bet against %s (IP: %s).", GetRPName(offeredby), GetPlayerIP(offeredby), amount, GetRPName(playerid), GetPlayerIP(playerid));
			}
			Log_Write("log_dicebet", "%s (uid: %i) won a dice bet against %s (uid: %i) for $%i.", GetRPName(offeredby), PlayerData[offeredby][pID], GetRPName(playerid), PlayerData[playerid][pID], amount);
		}
		else if(rand[0] == rand[1])
		{
			SendClientMessageEx(offeredby, COLOR_AQUA, "* The bet of %s was a tie. You kept your money as a result!", FormatCash(amount));
		    SendClientMessageEx(playerid, COLOR_AQUA, "* The bet of %s was a tie. You kept your money as a result!", FormatCash(amount));
		}
		else
		{
		    GivePlayerCash(offeredby, -amount);
		    GivePlayerCash(playerid, amount);

		    SendClientMessageEx(playerid, COLOR_AQUA, "* You have won $%s from your dice bet with %s.", FormatCash(amount), GetRPName(offeredby));
		    SendClientMessageEx(offeredby, COLOR_RED, "* You have lost $%s from your dice bet with %s.", FormatCash(amount), GetRPName(playerid));

			if(amount > 10000 && !strcmp(GetPlayerIP(offeredby), GetPlayerIP(playerid)))
			{
				SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) won a $%i dice bet against %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount, GetRPName(offeredby), GetPlayerIP(offeredby));
			}
			Log_Write("log_dicebet", "%s (uid: %i) won a dice bet against %s (uid: %i) for $%i.", GetRPName(playerid), PlayerData[playerid][pID], GetRPName(offeredby), PlayerData[offeredby][pID], amount);
		}

	    PlayerData[playerid][pDiceOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "invite", true))
	{
	    new
			offeredby = PlayerData[playerid][pInviteOffer],
			houseid = PlayerData[playerid][pInviteHouse];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invitations to a house.");
	    }

		PlayerData[playerid][pCP] = CHECKPOINT_HOUSE;
		SetPlayerCheckpoint(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 3.0);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's invitation to their house.", GetRPName(offeredby));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your invitation to your house.", GetRPName(playerid));

	    PlayerData[playerid][pInviteOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "robbery", true))
	{
	    new offeredby = PlayerData[playerid][pRobberyOffer];

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invitations to a bank heist.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 5.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(RobberyInfo[rRobbers][0] != offeredby || RobberyInfo[rStarted])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "The robbery invite is no longer available.");
		}
		if(GetBankRobbers() >= MAX_BANK_ROBBERS)
		{
	    	return SendClientMessageEx(playerid, COLOR_GREY, "This bank robbery has reached its limit of %i robbers.", MAX_BANK_ROBBERS);
 		}

		AddToBankRobbery(playerid);
        GivePlayerRankPointIllegalJob(offeredby, 500);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's bank robbery invitation.", GetRPName(offeredby));
	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your bank robbery invitation.", GetRPName(playerid));

	    PlayerData[playerid][pRobberyOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "duel", true))
	{
	    new offeredby = PlayerData[playerid][pDuelOffer], entranceid = GetInsideEntrance(playerid);

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers to duel.");
	    }
	    if(!IsPlayerNearPlayer(playerid, offeredby, 15.0))
		{
	        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
	    }
	    if(entranceid == -1 || EntranceInfo[entranceid][eType] != 1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not in a duel arena.");
		}
		if(PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You are already participating in a duel at the moment.");
		}
		if(PlayerData[offeredby][pDueling] != INVALID_PLAYER_ID)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is in a duel at the moment.");
		}

		foreach(new i : Player)
		{
		    if(GetInsideEntrance(i) == entranceid && PlayerData[i][pDueling] != INVALID_PLAYER_ID)
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "There is a duel in progress already. Wait until the current one has ended.");
		    }
		}

		SavePlayerVariables(playerid);
		SavePlayerVariables(offeredby);

		ResetPlayerWeapons(playerid);
		ResetPlayerWeapons(offeredby);

		SetPlayerPos(playerid, 1370.3395, -15.4556, 1000.9219);
		SetPlayerPos(offeredby, 1414.4841, -15.1239, 1000.9253);
		SetPlayerFacingAngle(playerid, 270.0000);
		SetPlayerFacingAngle(offeredby, 90.0000);

		SetPlayerInterior(playerid, 1);
		SetPlayerInterior(offeredby, 1);
		SetPlayerVirtualWorld(playerid, EntranceInfo[entranceid][eWorld]);
		SetPlayerVirtualWorld(offeredby, EntranceInfo[entranceid][eWorld]);

		SetPlayerHealth(playerid, 100.0);
		SetPlayerArmour(playerid, 100.0);
		SetPlayerHealth(offeredby, 100.0);
		SetPlayerArmour(offeredby, 100.0);

		GivePlayerWeaponEx(playerid, 24, true);
		GivePlayerWeaponEx(playerid, 27, true);
		GivePlayerWeaponEx(playerid, 29, true);
		GivePlayerWeaponEx(playerid, 31, true);
		GivePlayerWeaponEx(playerid, 34, true);

		GivePlayerWeaponEx(offeredby, 24, true);
		GivePlayerWeaponEx(offeredby, 27, true);
		GivePlayerWeaponEx(offeredby, 29, true);
		GivePlayerWeaponEx(offeredby, 31, true);
		GivePlayerWeaponEx(offeredby, 34, true);

		GameTextForPlayer(playerid, "~r~Duel time!", 3000, 3);
		GameTextForPlayer(offeredby, "~r~Duel time!", 3000, 3);

		PlayerData[playerid][pDueling] = offeredby;
		PlayerData[offeredby][pDueling] = playerid;

	    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted the duel offer.", GetRPName(playerid));
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's duel offer.", GetRPName(offeredby));

	    PlayerData[playerid][pDuelOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "alliance", true))
	{
	    new offeredby = PlayerData[playerid][pAllianceOffer], color, color2;

	    if(offeredby == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You haven't been offered an alliance.");
	    }
		if(offeredby == playerid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can't accept offers from yourself.");
		}

		new gangid = PlayerData[playerid][pGang], allyid = PlayerData[offeredby][pGang];

	    SendClientMessageEx(offeredby, COLOR_AQUA, "%s has accepted your offer to form a gang alliance.", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You've accepted the offer from %s to form a gang alliance.", GetRPName(offeredby));

		GangInfo[gangid][gAlliance] = allyid;
		GangInfo[allyid][gAlliance] = gangid;
		PlayerData[playerid][pAllianceOffer] = INVALID_PLAYER_ID;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", allyid, gangid);
   		mysql_tquery(connectionID, queryBuffer);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", gangid, allyid);
		mysql_tquery(connectionID, queryBuffer);

		if(GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
		{
			color = 0xC8C8C8FF;
		}
		else
		{
		    color = GangInfo[gangid][gColor];
		}

		if(GangInfo[allyid][gColor] == -1 || GangInfo[allyid][gColor] == -256)
		{
		    color2 = 0xC8C8C8FF;
		}
		else
		{
		    color2 = GangInfo[allyid][gColor];
		}

		SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has formed an alliance with {%06x}%s{FFFFFF} ))", color >>> 8, GangInfo[gangid][gName], color2 >>> 8, GangInfo[allyid][gName]);
	}
	else if(!strcmp(params, "marriage", true))
	{
		new id, offeredby = PlayerData[playerid][pMarriageOffer];
	    if((id = GetInsideBusiness(playerid)) == -1 || BusinessInfo[id][bType] != BUSINESS_RESTAURANT)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be at a restaurant to commence a wedding.");
		}
		if(!IsPlayerConnected(offeredby) || !IsPlayerNearPlayer(playerid, offeredby, 15.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You aren't in range of anyone who has offered to marry you.");
		}
		if(PlayerData[playerid][pCash] < 25000 || PlayerData[offeredby][pCash] < 25000)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You both need to have $25,000 in hand to commence a wedding.");
		}

		GivePlayerCash(playerid, -25000);
		GivePlayerCash(offeredby, -25000);
		BusinessInfo[id][bCash] += 50000;

		SendClientMessageToAllEx(COLOR_WHITE, "Lovebirds %s and %s have just tied the knott! Congratulations to them on getting married.", GetRPName(offeredby), GetRPName(playerid));

		PlayerData[playerid][pMarriedTo] = PlayerData[offeredby][pID];
		PlayerData[offeredby][pMarriedTo] = PlayerData[playerid][pID];

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET marriedto = %i WHERE uid = %i", PlayerData[playerid][pMarriedTo], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET marriedto = %i WHERE uid = %i", PlayerData[offeredby][pMarriedTo], PlayerData[offeredby][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerData[playerid][pMarriedName], GetPlayerNameEx(offeredby), MAX_PLAYER_NAME);
		strcpy(PlayerData[offeredby][pMarriedName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);

		PlayerData[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "divorce", true))
	{
		new offeredby = PlayerData[playerid][pMarriageOffer];
		if(!IsPlayerConnected(offeredby) || !IsPlayerNearPlayer(playerid, offeredby, 15.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You aren't in range of anyone who has offered to divorce you.");
		}
		if(PlayerData[playerid][pMarriedTo] == -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You aren't even married ya naab.");
		}
		if(PlayerData[playerid][pMarriedTo] != PlayerData[offeredby][pID])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That isn't the person you're married to.");
		}

		PlayerData[playerid][pMarriedTo] = -1;
		PlayerData[offeredby][pMarriedTo] = -1;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET marriedto = -1 WHERE uid = %i", PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET marriedto = -1 WHERE uid = %i", PlayerData[offeredby][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerData[playerid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
		strcpy(PlayerData[offeredby][pMarriedName], "Nobody", MAX_PLAYER_NAME);

		PlayerData[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
	}
	else if(!strcmp(params, "neutralize", true))
    {
        AcceptNeutralize(playerid);
    }
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /accept [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: House, Garage, Business, Land, Death, Vest, Vehicle, Faction, Gang, Ticket, Live, Marriage, Neutralize");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Item, Frisk, Handshake, Weapon, Lawyer, Dicebet, Invite, Robbery, Duel, Alliance, Craft, Drink");
	}

	return 1;
}


CMD:togtp(playerid, params[])
{
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!PlayerData[playerid][pToggleTP])
    {
        SendClientMessage(playerid, COLOR_GREY, "Admin teleport disabled!");
		PlayerData[playerid][pToggleTP] = 1;
	}
	else
	{
        SendClientMessage(playerid, COLOR_GREY, "Admin teleport enabled!");
		PlayerData[playerid][pToggleTP] = 0;
	}
	return 1;
}


CMD:undercover(playerid, params[])
{
	new name[MAX_PLAYER_NAME], level, Float:ar;
    
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Not Authorized / You need to be off duty to use this command.");
    }

    if(sscanf(params, "s[24]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /undercover [name | random | off]");
    }
    if(PlayerData[playerid][pUndercover][0])
    {
        OnUndercover(playerid, 0, "", 0, 0.0, 0.0);
        SendClientMessageEx(playerid, COLOR_WHITE, "* You are no longer undercover.", GetRPName(playerid), name);
    }
    else if(!strcmp(name, "random", true)) {
        strcpy(name, getRandomRPName());
        level = random(9) + 1;
        ar = float(random(50)+50);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
        mysql_tquery(connectionID, queryBuffer, "OnUndercover", "iisiff", playerid, 1, name, level, 100.0, ar);
    }
    else if(strfind(name, "_") != -1) {
        //format(name, MAX_PLAYER_NAME, params);
        level = random(9) + 1;
        ar = float(random(50)+50);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
        mysql_tquery(connectionID, queryBuffer, "OnUndercover", "iisiff", playerid, 1, name, level, 100.0, ar);
    }
    else
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /undercover [Firstname_Lastname | random]");
    }

	
	return 1;
}


CMD:ah(playerid, params[])
{
	return callcmd::adminhelp(playerid, params);
}

CMD:ahelp(playerid, params[])
{
	return callcmd::adminhelp(playerid, params);
}

CMD:adminhelp(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(PlayerData[playerid][pAdmin] >= LEVEL_SECRET_ADMIN)
	{
		SendClientMessage(playerid, COLOR_GREY5, "SECRET ADMIN:{DDDDDD} /a, /clearchat, /skick, /sban, /sjail, /pinfo, /spec, /reports, /admins, /flag, /removeflag, /listflags, /check, /dm.");
		SendClientMessage(playerid, COLOR_GREY5, "SECRET ADMIN:{DDDDDD} /ocheck, /oflag, /listflagged, /hhcheck, /kills, /shots, /damages.");
	}
	if(PlayerData[playerid][pAdmin] >= JUNIOR_ADMIN)
	{
		SendClientMessage(playerid, 0x99CCFFFF, "JUNIOR ADMIN:{DDDDDD} /aduty, /adminname, /kick, /ban, /warn, /slap, /ar, /tr, /rr, /cr, /setint, /setvw.");
		SendClientMessage(playerid, 0x99CCFFFF, "JUNIOR ADMIN:{DDDDDD} /setskin, /revive, /heject, /goto, /gethere, /gotocar, /getcar, /gotocoords, /gotoint, /listen, /jetpack, /sendto.");
		SendClientMessage(playerid, 0x99CCFFFF, "JUNIOR ADMIN:{DDDDDD} /freeze, /unfreeze, /rwarn, /runmute, /nmute, /admute, /hmute, /gmute, /skiptut, /listguns, /disarm.");
		SendClientMessage(playerid, 0x99CCFFFF, "JUNIOR ADMIN:{DDDDDD} /jail, /listjailed, /lastactive, /checkinv, /afklist, /acceptname, /denyname, /namechanges, /nrn.");
		SendClientMessage(playerid, 0x99CCFFFF, "JUNIOR ADMIN:{DDDDDD} /prisoninfo, /relog, /rtnc, /sth, /nro, /nao, /nor, /post, /contracts, /denyhit, /(o)dm.");
	}
	if(PlayerData[playerid][pAdmin] >= GENERAL_ADMIN)
	{
	    SendClientMessage(playerid, COLOR_LIMEGREEN, "GENERAL ADMIN:{DDDDDD} /ban, /(o)getip, /iplookup");
		SendClientMessage(playerid, COLOR_LIMEGREEN, "GENERAL ADMIN:{DDDDDD} /prison, /sprison, /oprison, /release, /fine, /pfine, /ofine, /sethp, /setarmor, /mark, /gotomark.");
		SendClientMessage(playerid, COLOR_LIMEGREEN, "GENERAL ADMIN:{DDDDDD} /veh, /destroyveh, /respawncars, /broadcast, /fixveh, /healrange.");
		SendClientMessage(playerid, COLOR_LIMEGREEN, "GENERAL ADMIN:{DDDDDD} /resetadtimer, /baninfo, /banhistory, /togooc, /tognewbie, /togglobal, /listpvehs, /despawnpveh.");
		SendClientMessage(playerid, COLOR_LIMEGREEN, "GENERAL ADMIN:{DDDDDD} /aclearwanted, /removedm, /savevehicle, /editvehicle, /removevehicle, /vehicleinfo, /refilldrug.");
		SendClientMessage(playerid, COLOR_LIMEGREEN, "GENERAL ADMIN:{DDDDDD} /alock, /duel, /startchat, /invitechat, /kickchat, /endchat, /freezerange, /unfreezerange, /reviverange.");
	}
	if(PlayerData[playerid][pAdmin] >= SENIOR_ADMIN)
	{
		SendClientMessage(playerid, COLOR_LIGHTORANGE, "SENIOR ADMIN:{DDDDDD} /givegun, /setname, /setweather, /permaban, /oban, /unban, /unbanip, /banip, /lockaccount, /unlockaccount.");
		SendClientMessage(playerid, COLOR_LIGHTORANGE, "SENIOR ADMIN:{DDDDDD} /explode, /event, /gplay, /gplayurl, /gstop, /sethpall, /setarmorall, /settime, /addtoevent, /eventkick.");
	}
	if(PlayerData[playerid][pAdmin] >= HEAD_ADMIN)
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "HEAD ADMIN:{DDDDDD} /setstat, /givemoney, /givemoneyall, /givecookie, /givecookieall, /setvip, /osetvip, /saveaccounts.");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "HEAD ADMIN:{DDDDDD} /removevip, /deleteaccount, /doublexp, /previewint, /nearest, /dynamichelp, /listassets.");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "HEAD ADMIN:{DDDDDD} /adestroyboombox, /setbanktimer, /resetrobbery, /addtorobbery, /givepayday, /givepveh, /givedoublexp.");
	}
    if(PlayerData[playerid][pAdmin] >= GENERAL_MANAGER)
	{
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "G. MANAGER:{DDDDDD} /makeadmin, /makehelper, /omakeadmin, /omakehelper, /setmotd, /setstaff, /forceaduty, /setpassword.");
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "G. MANAGER:{DDDDDD} /olisthelpers, /gmx, /sellinactive, /inactivecheck, /changelist, /fixplayerid, /giveachievement.");
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "G. MANAGER:{DDDDDD} /settitle, /oadmins, /disablevpn, /landperms, /forcedeleteobject, /obscurent, /ovips.");
	}
	if(PlayerData[playerid][pAdmin] >= MANAGEMENT)
	{
		SendClientMessage(playerid, COLOR_VIP, "MANAGEMENT:{DDDDDD} /serversetting, /setdamages, /adminstrike, /doublexp, /enddoublexp");
	}

	return 1;
}

CMD:norevive(playerid, params[])
{
	return callcmd::nor(playerid, params);
}

CMD:bigears(playerid, params[])
{
	return callcmd::listen(playerid, params);
}

CMD:skick(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerData[playerid][pAdmin] < 2)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skick [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be kicked.");
	}
	if(gettime() - PlayerData[playerid][pLastKick] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /kick again.", 60 - (gettime() - PlayerData[playerid][pLastKick]));
	}

	PlayerData[playerid][pLastKick] = gettime();

    KickPlayer(targetid, reason, playerid, BAN_VISIBILITY_ADMIN);
	return 1;
}

CMD:sban(playerid, params[])
{
	new targetid, duration, reason[128];

	if(PlayerData[playerid][pAdmin] < 2)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "uds[128]", targetid, duration, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sban [playerid] [duration in days] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
	}
	if(duration <= 0 || duration >= 365 * 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid duration value.");
	}
	if(gettime() - PlayerData[playerid][pLastBan] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /ban again.", 60 - (gettime() - PlayerData[playerid][pLastBan]));
	}

	PlayerData[playerid][pLastBan] = gettime();

	BanPlayer(targetid, reason, playerid, BAN_VISIBILITY_ADMIN, duration);
	return 1;
}

CMD:sjail(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sjail [playerid] [minutes] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be jailed.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(minutes < 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes specified cannot be below zero.");
	}

    PlayerData[targetid][pJailType] = 1;
    PlayerData[targetid][pJailTime] = minutes * 60;

    ResetPlayerWeaponsEx(targetid);
	ResetPlayer(targetid);
	SetPlayerInJail(targetid);

	Log_Write("log_punishments", "%s (uid: %i) silently jailed %s (uid: %i) for %i minutes, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes, reason);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was jailed for %i minutes by an Admin, reason: %s", GetRPName(targetid), minutes, reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been jailed for %i minutes by an admin.", minutes);
    return 1;
}

CMD:pinfo(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pinfo [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	SendClientMessageEx(playerid, COLOR_GREY1, "(ID: %i) - (Name: %s) - (Ping: %i) - (FPS: %i) - (Packet Loss: %.1f%c)", targetid, GetRPName(targetid), GetPlayerPing(targetid), PlayerData[targetid][pFPS], NetStats_PacketLossPercent(targetid), '%');
	return 1;
}

CMD:admins(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1 && !PlayerData[playerid][pDeveloper])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_________ Admins Online _________");

	foreach(new i : Player)
	{
	    if(PlayerData[i][pAdmin] > 0 && !PlayerData[i][pUndercover][0] || PlayerData[playerid][pAdmin] >= GENERAL_MANAGER && PlayerData[i][pUndercover][0])
		{
			new division[5];
			strcpy(division, GetAdminDivision(i));
            if(strlen(division) < 1) division = "None";
			if(!strcmp(PlayerData[i][pAdminName], "None", true))
            	SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s - Division: %s - Status: %s{C8C8C8} - Reports Handled: %i - Tabbed: %s", i, GetAdminRank(i), PlayerData[i][pUsername], division, (PlayerData[i][pAdminDuty]) ? ("{00AA00}On Duty") : ("Off Duty"), PlayerData[i][pReports], (IsPlayerAFK(i)) ? ("Yes") : ("No"));
        	else
				SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s (%s) - Division: %s - Status: %s{C8C8C8} - Reports Handled: %i - Tabbed: %s", i, GetAdminRank(i), PlayerData[i][pUsername], PlayerData[i][pAdminName], division, (PlayerData[i][pAdminDuty]) ? ("{00AA00}On Duty") : ("Off Duty"), PlayerData[i][pReports], (IsPlayerAFK(i)) ? ("Yes") : ("No"));
		}
	}
	return 1;
}
CMD:checknewbies(playerid, params[])
{
	new targetid;
	if(!PlayerData[playerid][pAdmin] && PlayerData[playerid][pHelper] < 3)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checknewbies [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	SendClientMessageEx(playerid, COLOR_GREY, "Level %i Player %s has used newbie {00FF00}%s times.", PlayerData[targetid][pLevel], GetRPName(targetid), FormatNumber(PlayerData[targetid][pNewbies]));
	return 1;
}

CMD:helpers(playerid, params[])
{
	SendClientMessage(playerid, COLOR_NAVYBLUE, "_________ Helpers Online _________");

	foreach(new i : Player)
	{
	    if(PlayerData[i][pHelper] > 0 && !PlayerData[i][pPassport] && !PlayerData[i][pUndercover][0])
	    {
	        if(PlayerData[playerid][pAdmin] > 0 || PlayerData[playerid][pHelper] > 0)
	            SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s - Help Requests: %s - Newbies: %s", i, GetHelperRank(i), GetRPName(i), FormatNumber(PlayerData[i][pHelpRequests]), FormatNumber(PlayerData[i][pNewbies]));
	        else
				SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s %s", i, GetHelperRank(i), GetRPName(i));
		}
	}

	return 1;
}

CMD:flag(playerid, params[])
{
	new targetid, desc[128];

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[128]", targetid, desc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /flag [playerid] [description]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, '%s', NOW(), '%e')", PlayerData[targetid][pID], GetPlayerNameEx(playerid), desc);
	mysql_tquery(connectionID, queryBuffer);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s flagged %s's account for '%s'.", GetRPName(playerid), GetRPName(targetid), desc);
	return 1;
}

CMD:oflag(playerid, params[])
{
	new name[24], desc[128];

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]s[128]", name, desc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /oflag [username] [description]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineFlag", "iss", playerid, name, desc);
	return 1;
}

CMD:listflagged(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	mysql_tquery(connectionID, "SELECT b.username FROM flags a, "#TABLE_USERS" b WHERE a.uid = b.uid ORDER BY b.username", "OnQueryFinished", "ii", THREAD_LIST_FLAGGED, playerid);
	return 1;
}

CMD:ocheck(playerid, params[])
{
	new name[24];

	if(PlayerData[playerid][pAdmin] < 1 && !PlayerData[playerid][pHumanResources])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ocheck [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM "#TABLE_USERS" WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineCheck", "is", playerid, name);
	return 1;
}

CMD:removeflag(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeflag [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM flags WHERE uid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListFlagsForRemoval", "ii", playerid, targetid);
	return 1;
}

CMD:listflags(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listflags [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM flags WHERE uid = %i ORDER BY date DESC", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnListPlayerFlags", "ii", playerid, targetid);
	return 1;
}

CMD:hhcheck(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hhcheck [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pHHCheck])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already being checked for health hacks.");
	}
	if(IsPlayerPaused(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't initiate this check on a tabbed player.");
	}

	GetPlayerHealth(targetid, PlayerData[targetid][pHealth]);

	PlayerData[targetid][pHHCheck] = 1;
	PlayerData[targetid][pHHTime] = 5;
	PlayerData[targetid][pHHRounded] = GetPlayerHealthEx(targetid);
	PlayerData[targetid][pHHCount] = 0;

	SetPlayerHealth(targetid, random(100) + 1);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has started the health hack check on %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:quiz(playerid, params[])
{
	new option[10], param[32];
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    if(PlayerData[playerid][pAdmin] >= JUNIOR_ADMIN)
	    {
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /quiz [option]");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of Options: Create, End, Edit, Answer");
		}
		else
		{
		    //SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /quiz answer [text]");
		    strcpy(option, "answer");
		}
		return 1;
	}
 	if(!strcmp(option, "create", true))
	{
	    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN) return 1;
		if(isnull(quizQuestion))
	    {
			if(CreateQuiz == -1)
			{
	        	ShowDialogToPlayer(playerid, DIALOG_CREATEQUIZ);
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "There is already an on-going quiz!");
		}
		return 1;
	}
	else if(!strcmp(option, "end", true))
	{
	    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN) return 1;
	    if(!isnull(quizQuestion))
	    {
	        quizQuestion[0] = EOS;
            SendClientMessageToAllEx(COLOR_RETIRED, "The quiz was ended by %s, answer: %s", GetRPName(playerid), quizAnswer);
			quizAnswer[0] = EOS;
	    }
	    return 1;
	}
	else if(!strcmp(option, "edit", true))
	{
	    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN) return 1;
		if(strlen(param) > 0)
		{
		    strcpy(quizAnswer, param);
			SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s changed the quiz answer to %s.", GetRPName(playerid), quizAnswer);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /quiz edit [answer]");
		}
	}
	else if(!strcmp(option, "answer", true))
	{
		if(isnull(quizAnswer))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "There is no active quiz!");
		}
		if(!isnull(param))
		{
			if(!strcmp(quizAnswer, param, true))
			{
				SendClientMessageToAllEx(COLOR_RETIRED, "%s has answered the quiz correctly. answer: %s", GetRPName(playerid), quizAnswer);
		    	quizQuestion[0] = EOS;
	        	quizAnswer[0] = EOS;
			}
			else
			{
		    	SendClientMessage(playerid, COLOR_GREY, "Sorry bud, that ain't the right answer.");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /quiz answer [answer]");
		}
	}
	return 1;
}
CMD:forcedeleteobject(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] >= GENERAL_MANAGER || PlayerData[playerid][pDeveloper])
    {
        new mode[32];
        if(sscanf(params, "s[32]", mode))
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcedeleteobject [enable/disable]");
		if(!strcmp(mode, "enable", true))
		{
		    PlayerData[playerid][pDeleteMode] = 1;
		}
        else if(!strcmp(mode, "disable", true))
		{
		    PlayerData[playerid][pDeleteMode] = 0;
		}
		else
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcedeleteobject [enable/disable]");
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Object deletetion mode was %sd (%i)", mode, PlayerData[playerid][pDeleteMode]);
	}
	return 1;
}
CMD:godshand(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= MANAGEMENT)
	{
		new targetid;

		if(sscanf(params, "u", targetid))
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /godshand [playerid]");

		if(PlayerData[playerid][pGodshand] == 1)
		{
		    SendClientMessage(playerid, COLOR_GREY, "Aww, that's sad as fuck.");
			PlayerData[targetid][pGodshand] = 0;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "Granted it is.");
			PlayerData[targetid][pGodshand] = 1;
		}
		return 1;
	}
	return -1;
}
CMD:choke(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= JUNIOR_ADMIN)
	{
		new targetid;
		if(sscanf(params, "u", targetid)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /choke [playerid] ");
		ApplyAnimation(targetid,"ped","gas_cwr",4.1,1,1,1,0,0,0);

		if(PlayerData[playerid][pAdmin] <= PlayerData[targetid][pAdmin])
			return SendClientMessageEx(playerid, COLOR_GREY, "You cannot choke higher level administrators.");

		SendProximityMessage(targetid, 30.0, COLOR_PURPLE, "* %s bends over as he chokes by god's hand.", GetRPName(targetid));
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Your not authorized to use that command!");
	return 1;
}

CMD:kick(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /kick [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be kicked.");
	}
	if(gettime() - PlayerData[playerid][pLastKick] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /kick again.", 60 - (gettime() - PlayerData[playerid][pLastKick]));
	}

	PlayerData[playerid][pLastKick] = gettime();

    KickPlayer(targetid, reason, playerid);
	return 1;
}

CMD:ban(playerid, params[])
{
	new targetid, duration, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "uds[128]", targetid, duration, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ban [playerid] [duration in days] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(duration <= 0 || duration >= 365 * 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid duration value.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
	}
	if(targetid == playerid)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't ban yourself.");
	}
	if(gettime() - PlayerData[playerid][pLastBan] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /ban again.", 60 - (gettime() - PlayerData[playerid][pLastBan]));
	}

	PlayerData[playerid][pLastBan] = gettime();

	BanPlayer(targetid, reason, playerid, BAN_VISIBILITY_ALL, duration);
	return 1;
}

CMD:warn(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /warn [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be warned.");
	}
	if(gettime() - PlayerData[playerid][pLastWarn] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /warn again.", 60 - (gettime() - PlayerData[playerid][pLastWarn]));
	}

	PlayerData[targetid][pWarnings]++;
	
	PlayerData[playerid][pLastWarn] = gettime();
	
	Log_Write("log_punishments", "%s (uid: %i) warned %s (uid: %i), reason: %s (%i/3)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason, PlayerData[targetid][pWarnings]);

	if(PlayerData[targetid][pWarnings] < 3)
	{
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was warned by %s %s, reason: %s", GetRPName(targetid), GetAdmCmdRank(playerid),  GetRPName(playerid), reason);
	    SendClientMessageEx(targetid, COLOR_LIGHTRED, "%s %s has warned you, reason: %s", GetAdmCmdRank(playerid),  GetRPName(playerid), reason);
	}
	else
	{
	    PlayerData[targetid][pWarnings] = 0;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" set warnings=0 where uid=%i", PlayerData[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);
            
        format(reason, sizeof(reason), "%s (3/3 warnings)", reason);
    	BanPlayer(targetid, reason, playerid);
	}

	return 1;
}

CMD:check(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /check [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	DisplayStats(targetid, playerid);
	return 1;
}

CMD:checkinventory(playerid, params[])
{
    return callcmd::checkinv(playerid, params);
}

CMD:checkinv(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checkinv [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	DisplayInventory(targetid, playerid);
	return 1;
}

CMD:slap(playerid, params[])
{
    new targetid, Float:height;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "uF(5.0)", targetid, height))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /slap [playerid] [height (optional)]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawnedEx(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is not spawned and therefore cannot be slapped.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be slapped.");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);
	SetPlayerPos(targetid, x, y, z + height);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was slapped by %s %s.", GetRPName(targetid), GetAdmCmdRank(playerid), GetRPName(playerid));
	PlayerPlaySound(targetid, 1130, 0.0, 0.0, 0.0);

	return 1;
}

CMD:upgrade(playerid, params[])
{
	
	new string[512];
	format(string, sizeof(string), "Name\tLevel\n\
		Inventory\t{ffff00}Currently Skill Level %i/5\n\
		Addict\t{ffff00}Currently Skill Level is %i/3\n\
		Trader\t{ffff00}Currently Skill Level %i/4\n\
		Asset\t{ffff00}Currently Skill Level %i/4\n\
		Labor\t{ffff00}Currently Skill Level %i/5\n\
		Spawn Health\t{ffff00}Currently Spawn Health is %.1f/100\n\
		Spawn Armor\t{ffff00}Currently Spawn Armour is %.1f/100\n",
		PlayerData[playerid][pInventoryUpgrade],
		PlayerData[playerid][pAddictUpgrade],
		PlayerData[playerid][pTraderUpgrade],
		PlayerData[playerid][pAssetUpgrade],
		PlayerData[playerid][pLaborUpgrade],
		PlayerData[playerid][pSpawnHealth],
		PlayerData[playerid][pSpawnArmor]);
	Dialog_Show(playerid, DIALOG_NEWUPGRADEONE, DIALOG_STYLE_TABLIST_HEADERS, "Upgrade List", string, "Upgrade", "Close");
	return 1;
}

CMD:charity(playerid, params[])
{
	new option[10], param[64];

	if(PlayerData[playerid][pLevel] < 5)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot donate to charity if you're under level 5. /buylevel to level up.");
	}
	if(sscanf(params, "s[10]S()[64]", option, param))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /charity [info | health | armor | song]");
	}
	if(!strcmp(option, "info", true))
	{
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Charity _______");
		SendClientMessage(playerid, COLOR_GREY3, "If you have at least $1,000 on hand you can donate to charity.");
		SendClientMessage(playerid, COLOR_GREY3, "You can donate to give health or armor for the entire server using '{FFD700}/charity health/armor{AAAAAA}'.");
		SendClientMessage(playerid, COLOR_GREY3, "You can also donate to globally play a song of your choice using '{FFD700}/charity song{AAAAAA}'.");
		SendClientMessage(playerid, COLOR_GREY3, "You can also donate your money the traditional way using '{FFD700}/charity [amount]{AAAAAA}'.");
		SendClientMessage(playerid, COLOR_GREY3, "Once the charity bank hits a milestone, some of it will be given back to the community!");
		SendClientMessageEx(playerid, COLOR_AQUA, "* %s has been donated to charity so far.", FormatCash(GetCharity()));
		return 1;
	}
 	else if(!strcmp(option, "health", true))
	{
		if(PlayerData[playerid][pCash] < 150000)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You need at least $150,000 on hand for this option.");
		}
		if(gCharityHealth)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Players can only donate for this perk each hour. Try again after payday.");
		}

        foreach(new i : Player)
		{
		    if(!PlayerData[i][pAdminDuty])
		    {
				SetPlayerHealth(i, 150.0);
			}
		}

		AddToCharity(150000);
		gCharityHealth = 1;
		AddToTaxVault(150000);

		SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated $150,000 to heal everyone to 150 health!", GetRPName(playerid));
		GivePlayerCash(playerid, -150000);
	}
	else if(!strcmp(option, "armor", true))
	{
		if(PlayerData[playerid][pCash] < 200000)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You need at least $200,000 on hand for this option.");
		}
		if(gCharityArmor)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Players can only donate for this perk each hour. Try again after payday.");
		}

        foreach(new i : Player)
		{
		    if(!PlayerData[i][pAdminDuty])
		    {
				SetScriptArmour(i, 100.0);
			}
		}

		AddToCharity(200000);
		gCharityArmor = 1;
		AddToTaxVault(200000);

		SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated $200,000 to give full armor to everyone!", GetRPName(playerid));
		GivePlayerCash(playerid, -10000);
	}
  	else if(!strcmp(option, "song", true))
	{
	 	if(isnull(param))
 		{
		 	return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /charity [song] [songfolder/name.mp3]");
		}
		if(PlayerData[playerid][pCash] < 25000)
		{
  			return SendClientMessage(playerid, COLOR_GREY, "You need at least $25,000 on hand for this option.");
		}
		if(gettime() - gLastMusic < 300)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Music can only be played globally every 5 minutes.");
		}

		new
		    url[144];

		format(url, sizeof(url), "http://%s/%s", GetServerMusicUrl(), param);

		foreach(new i : Player)
		{
		    if(!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
		    {
				PlayAudioStreamForPlayer(i, url);
			}
		}
		gLastMusic = gettime();

		AddToCharity(25000);
		AddToTaxVault(25000);

		SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated $25,000 to play %s for the entire server!", GetRPName(playerid), param);
		GivePlayerCash(playerid, -25000);
	}
	else if(IsNumeric(option))
	{
	    new amount = strval(option);

		if(amount < 1 || amount > PlayerData[playerid][pCash])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		}

	    AddToCharity(amount);
	    AddToTaxVault(amount);

	    GivePlayerCash(playerid, -amount);
		if(amount > 100000)
		{
		    SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated %s to charity!", GetRPName(playerid), FormatCash(amount));
		}
	}

	return 1;
}

CMD:music(playerid, params[])
{
 	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____________________ List of Music _____________________");
    HTTP(playerid, HTTP_GET, GetServerMusicUrl(), "", "HTTP_OnMusicFetchResponse");
 	return 1;
}

CMD:stopmusic(playerid, params[])
{
	SendClientMessage(playerid, COLOR_YELLOW, "You have stopped all active audio streams playing for yourself.");
	PlayerData[playerid][pStreamType] = MUSIC_NONE;
	StopAudioStreamForPlayer(playerid);
	return 1;
}

CMD:gplay(playerid, params[])
{
	new url[144];

	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(isnull(params))
	{
	 	return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gplay [songfolder/name.mp3]");
	}

    format(url, sizeof(url), "http://%s/%s", GetServerMusicUrl(), params);

    foreach(new i : Player)
	{
	    if(!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
	    {
			PlayAudioStreamForPlayer(i, url);
			SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of %s.", GetRPName(playerid), params);
			SendClientMessageEx(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
		}
	}

	return 1;
}

CMD:gplayurl(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN && !PlayerData[playerid][pDJ])
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	 	return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gplayurl [link]");
	}
	if(strfind(params, ".php", true) != -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "No .php links allowed!");
	}
    foreach(new i : Player)
	{
	    if(!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
	    {
			PlayAudioStreamForPlayer(i, params);
			SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of a custom URL.", GetRPName(playerid));
			SendClientMessageEx(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
		}
	}
	return 1;
}
CMD:makedj(playerid, params[])
{
	new targetid, rank;
	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN && PlayerData[playerid][pDJ] != 2)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "dd", targetid, rank))
	{
		SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /makedj [playerid] [rank]");
		SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} 0 = None, 1 = DJ, 2 = Leader DJ");
	}
	if(!(0 <= rank <= 3))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid rank specified.");
	}
	if(PlayerData[targetid][pLogged])
	{
	    if(rank == 0)
	    {
        	(playerid, COLOR_AQUA, "You've removed %s's DJ rank", GetRPName(targetid));
			SendClientMessageEx(targetid, COLOR_AQUA, "Your DJ rank was removed by %s", GetRPName(playerid));
			PlayerData[targetid][pDJ] = 0;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET dj = %i WHERE uid = %i", PlayerData[targetid][pDJ], PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
		else
		{
	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a rank %d DJ", GetRPName(targetid), rank);
			SendClientMessageEx(targetid, COLOR_AQUA, "You have been made rank %d DJ by %s", rank, GetRPName(playerid));
			PlayerData[targetid][pDJ] = rank;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET dj = %i WHERE uid = %i", PlayerData[targetid][pDJ], PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	return 1;
}
CMD:gstop(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN && !PlayerData[playerid][pDJ])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

    foreach(new i: Player)
	{
	    if(!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
	    {
		    StopAudioStreamForPlayer(i);
			SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has stopped all active audio streams.", GetRPName(playerid));
		}
	}

	return 1;
}
CMD:sdm(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sdm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be punished.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
	}

	PlayerData[targetid][pDMWarnings]++;

	if(PlayerData[targetid][pDMWarnings] < 3)
	{
	    new minutes = PlayerData[targetid][pDMWarnings] * 30;

	    PlayerData[targetid][pJailType] = 2;
    	PlayerData[targetid][pJailTime] = PlayerData[targetid][pDMWarnings] * 1800;
    	PlayerData[targetid][pWeaponRestricted] = PlayerData[targetid][pDMWarnings] * 4;

		ResetPlayer(targetid);
		ResetPlayerWeapons(targetid);
		SetPlayerInJail(targetid);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was DM Warned & Prisoned for %i minutes by an Admin, reason: DM (%i/3)", GetRPName(targetid), minutes, PlayerData[targetid][pDMWarnings]);
		GetPlayerName(playerid, PlayerData[targetid][pPrisonedBy], MAX_PLAYER_NAME);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET prisonedby = '%e', prisonreason = 'DM' WHERE uid = %i", PlayerData[targetid][pPrisonedBy], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerData[targetid][pPrisonReason], "DM", 128);

		GameTextForPlayer(targetid, "~w~Welcome to~n~~r~admin jail", 5000, 3);
		SendClientMessageEx(targetid, COLOR_WHITE, "You have been admin prisoned for %i minutes, reason: DM.", minutes);
		SendClientMessageEx(targetid, COLOR_WHITE, "Your punishment is %i hours of weapon restriction and %i/5 DM warning.", PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pDMWarnings]);
		Log_Write("log_punishments", "%s (uid: %i) silent prisoned %s (uid: %i) for %i minutes, reason: SDM [/sdm]", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes);
	}
	else
	{
		PlayerData[targetid][pDMWarnings] = 0;
        //BanPlayer(targetid, "DM (3/3 warnings)", playerid, BAN_VISIBILITY_ADMIN);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET jailtype = %i, jailtime = %i, dmwarnings = %i, weaponrestricted = %i WHERE uid = %i", PlayerData[targetid][pJailType], PlayerData[targetid][pJailTime], PlayerData[targetid][pDMWarnings], PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:dm(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be punished.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
	}
	if(gettime() - PlayerData[playerid][pLastDM] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /dm again.", 60 - (gettime() - PlayerData[playerid][pLastDM]));
	}

	PlayerData[targetid][pDMWarnings]++;

	PlayerData[playerid][pLastDM] = gettime();

	if(PlayerData[targetid][pDMWarnings] < 3)
	{
	    new minutes = PlayerData[targetid][pDMWarnings] * 30;

	    PlayerData[targetid][pJailType] = 2;
    	PlayerData[targetid][pJailTime] = PlayerData[targetid][pDMWarnings] * 1800;
    	PlayerData[targetid][pWeaponRestricted] = PlayerData[targetid][pDMWarnings] * 4;

		ResetPlayer(targetid);
		ResetPlayerWeapons(targetid);
		SetPlayerInJail(targetid);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was DM Warned & Prisoned for %i minutes by %s, reason: DM (%i/3)", GetRPName(targetid), minutes, GetRPName(playerid), PlayerData[targetid][pDMWarnings]);
		GetPlayerName(playerid, PlayerData[targetid][pPrisonedBy], MAX_PLAYER_NAME);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET prisonedby = '%e', prisonreason = 'DM' WHERE uid = %i", PlayerData[targetid][pPrisonedBy], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		strcpy(PlayerData[targetid][pPrisonReason], "DM", 128);

		GameTextForPlayer(targetid, "~w~Welcome to~n~~r~admin jail", 5000, 3);
		SendClientMessageEx(targetid, COLOR_WHITE, "You have been admin prisoned for %i minutes, reason: DM.", minutes);
		SendClientMessageEx(targetid, COLOR_WHITE, "Your punishment is %i hours of weapon restriction and %i/5 DM warning.", PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pDMWarnings]);
		Log_Write("log_punishments", "%s (uid: %i) prisoned %s (uid: %i) for %i minutes, reason: DM [/dm]", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes);
	}
	else
	{
		PlayerData[targetid][pDMWarnings] = 0;
		//BanPlayer(targetid, "DM (3/3 warnings)");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET jailtype = %i, jailtime = %i, dmwarnings = %i, weaponrestricted = %i WHERE uid = %i", PlayerData[targetid][pJailType], PlayerData[targetid][pJailTime], PlayerData[targetid][pDMWarnings], PlayerData[targetid][pWeaponRestricted], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:cleardm(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= GENERAL_MANAGER || PlayerData[playerid][pAdminDuty])
	{
	    ClearDeathList(playerid);
	    SendClientMessage(playerid, COLOR_WHITE, "Death messages cleared.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are either not authorized to use this command or not on admin duty.");
	}

	return 1;
}

ClearDeathList(playerid)
{
	for(new i = 0; i < 5; i ++)
	{
		SendDeathMessageToPlayer(playerid, 1001, 1001, 255);
	}
	return 1;
}

CMD:setadminname(playerid, params[])
{
	new name[MAX_PLAYER_NAME], targetid;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && ! PlayerData[playerid][pAdminPersonnel])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "ds[24]", targetid, name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setadminname [targetid] [name]");
	}
	if(!IsValidAdminName(name))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The name specified is not supported by the SA-MP client.");
	}

	strcpy(PlayerData[targetid][pAdminName], name, MAX_PLAYER_NAME);

	if(PlayerData[targetid][pAdminDuty])
	{
	    SetPlayerName(targetid, name);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET adminname = '%e' WHERE uid = %i", name, PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s changed %s's administrator name to %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), name);
	return 1;
}

CMD:lastactive(playerid, params[])
{
	new username[24], specifiers[] = "%D of %M, %Y @ %k:%i";

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lastactive [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT DATE_FORMAT(lastlogin, '%s') FROM "#TABLE_USERS" WHERE username = '%e'", specifiers, username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckLastActive", "is", playerid, username);

	return 1;
}

CMD:listjailed(playerid, params[])
{
    return callcmd::prisoners(playerid, params);
}

CMD:prisoners(playerid, params[])
{
	new type[14];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Jailed Players ______");

	foreach(new i : Player)
	{
	    if(PlayerData[i][pJailType] > 0)
	    {
	        switch(PlayerData[i][pJailType])
	        {
	            case 1: type = "OOC jailed";
				case 2: type = "OOC prisoned";
				case 3: type = "IC prisoned";
			}

			SendClientMessageEx(playerid, COLOR_GREY1, "(ID: %i) %s - Status: %s - Reason: %s - Time: %i seconds", i, GetRPName(i), type, PlayerData[i][pPrisonReason], PlayerData[i][pJailTime]);
		}
	}

	return 1;
}

CMD:prisoninfo(playerid, params[])
{
    new targetid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /prisoninfo [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pJailType] != 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not in OOC prison.");
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "* %s was prisoned by %s, reason: %s (%i seconds left.) *", GetRPName(targetid), PlayerData[targetid][pPrisonedBy], PlayerData[targetid][pPrisonReason], PlayerData[targetid][pJailTime]);
	return 1;
}

CMD:relog(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /relog [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to relog.", GetRPName(playerid), GetRPName(targetid));
	SavePlayerVariables(targetid);
	ResetPlayer(targetid);

	PlayerData[targetid][pLogged] = 0;
    PlayerLogin(targetid);
	return 1;
}

CMD:setint(playerid, params[])
{
    new targetid, interiorid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, interiorid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setint [playerid] [int]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!(0 <= interiorid <= 100))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid interior. Valid interiors range from 0 to 100.");
	}

	SetPlayerInterior(targetid, interiorid);
	SendClientMessageEx(playerid, COLOR_GREY2, "%s's interior set to ID %i.", GetRPName(targetid), interiorid);
	return 1;
}

CMD:setvw(playerid, params[])
{
    new targetid, worldid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, worldid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setvw [playerid] [vw]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	SetPlayerVirtualWorld(targetid, worldid);
	SendClientMessageEx(playerid, COLOR_GREY2, "%s's virtual world set to ID %i.", GetRPName(targetid), worldid);
	return 1;
}

CMD:setskin(playerid, params[])
{
    new targetid, skinid;

    if(PlayerData[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, skinid))
	{
	    return SendSyntaxMessage(playerid, " /setskin [playerid] [skinid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
	}
	if(!(0 <= skinid <= 311) && !(25000 <= skinid <= 25165))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid skin specified.");
	}
	if(!IsPlayerSpawnedEx(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player has a higher admin level than you. You can't change their skin.");
	}

	SetScriptSkin(targetid, skinid);
	SendClientMessageEx(playerid, COLOR_GREY2, "%s's skin set to ID %i.", GetPlayerNameEx(targetid), skinid);
	return 1;
}

CMD:hrevive(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hrevive [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (PlayerData[targetid][pLevel] > 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only revive level 1 players.");
    }
    if (!RevivePlayer(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not injured.");
    }
    if (PlayerData[playerid][pAcceptedHelp])
    {
        SendClientMessage(targetid, COLOR_YELLOW, "You have been revived by a helper!");
        SendHelperMessage(COLOR_LIGHTRED, "HelperCmd: %s has revived %s (Level 1).", GetRPName(playerid), GetRPName(targetid));
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You need to accept a help to revive this new player.");
    }
    return 1;
}

CMD:forcehospital(playerid, params[])
{
	return callcmd::heject(playerid, params);
}

CMD:heject(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /heject [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pHospital])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is not in hospital.");
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s ejected %s from the hospital.", GetRPName(playerid), GetRPName(targetid));

	PlayerData[targetid][pHospitalTime] = 1;
	SendClientMessage(targetid, COLOR_YELLOW, "You have been ejected from hospital by an admin!");
	return 1;
}

CMD:goto(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	
	if(sscanf(params, "u", targetid))
	{
		if(PlayerData[playerid][pAdmin])
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /goto [playerid/location]");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of options: LS, SF, LV, Grove, Idlewood, Unity, Jefferson, Market, Airport, Bank");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Dealership, VIP, PB, DMV, Casino, Spawn, Allsaints, Casino");
		}
		else
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /goto [newb_playerid]");
		}
		return 1;
	}
	if(PlayerData[playerid][pAdmin] == 0)
	{
		// Only helper no admin
		if(PlayerData[targetid][pHelper] < 6)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You need to be helper level 6+ to use this command.");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(!IsPlayerSpawnedEx(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
		}
		if(PlayerData[targetid][pToggleTP] == 1)
		{
			return SendClientMessage(playerid, COLOR_GREY, "Target id has togged teleports");
		}
		if(PlayerData[targetid][pLevel] > 3)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You can teleport only to newbie players (level < 3).");
		}

		TeleportToPlayer(playerid, targetid);
		SendClientMessageEx(targetid, COLOR_LIGHTRED, "Helper %s has teleported to your position.", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to %s's position.", GetRPName(targetid));
		return 1;
	}
	if(!strcmp(params,"hooker",true)){
		format(params,7,"pigpen");
	}
	for(new i=0;i<sizeof(staticEntrances);i++)
	{
		if(isnull(staticEntrances[i][eShortName]))
			continue;
		if(!strcmp(params,staticEntrances[i][eShortName],true)){
			TeleportToCoords(playerid, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ], staticEntrances[i][ePosA], 0, 0);
			return SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to %s.",staticEntrances[i][eName]);
		}
	}
	for(new i=0;i<sizeof(jobLocations);i++)
	{
		if(isnull(jobLocations[i][jobShortName]))
			continue;
		if(!strcmp(params,jobLocations[i][jobShortName],true)){
			TeleportToCoords(playerid, jobLocations[i][jobX] + floatcos(jobLocations[i][actorangle], degrees), 
				jobLocations[i][jobY] + floatsin(jobLocations[i][actorangle], degrees), 
				jobLocations[i][jobZ], jobLocations[i][actorangle], 0, 0);
			return SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to %s job.",jobLocations[i][jobName]);
		}
	}

	for(new i=0;i<sizeof(gotoCoords);i++)
	{
		if(!strcmp(params, gotoCoords[i][egc_Param], true))
		{
			TeleportToCoords(playerid, gotoCoords[i][egc_X], gotoCoords[i][egc_Y], gotoCoords[i][egc_Z], gotoCoords[i][egc_A], gotoCoords[i][egc_Int], gotoCoords[i][egc_VW]);
			SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to %s.", gotoCoords[i][egc_Name]);
			return 1;
		}
	}

	if(!strcmp(params, "spawn", true))
	{
		TeleportToCoords(playerid,  NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2], NewbSpawnPos[3], 0, 0);
		SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to Spawn.");
		return 1;
	}

	if(!IsPlayerConnected(targetid))
	{
		return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawnedEx(targetid))
	{
		return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
	}
	if(PlayerData[targetid][pToggleTP] == 1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Target id has togged teleports");
	}

	TeleportToPlayer(playerid, targetid);
	SendClientMessageEx(targetid, COLOR_LIGHTRED, "%s %s has teleported to your position.", GetAdmCmdRank(playerid), GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to %s's position.", GetRPName(targetid));
	return 1;
}

CMD:gethere(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gethere [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawnedEx(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
	}
    if(PlayerData[targetid][pPaintball] > 0 && PlayerData[playerid][pPaintball] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently in the paintball arena.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't teleport an admin who has a higher admin level than you.");
	}
	/*if(IsPlayerInEvent(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently in the event.");
	}*/

	TeleportToPlayer(targetid, playerid);
	SendClientMessageEx(playerid, COLOR_GREY2, "Teleported %s to your position.", GetRPName(targetid));

	return 1;
}

CMD:gotocar(playerid, params[])
{
	new vehicleid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotocar [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle specified.");
	}

	TeleportToVehicle(playerid, vehicleid);
	SendClientMessageEx(playerid, COLOR_GREY2, "Teleported to vehicle ID %i.", vehicleid);
	return 1;
}

CMD:getcar(playerid, params[])
{
	new vehicleid, driverid;

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getcar [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle specified.");
	}
    if((driverid = GetVehicleDriver(vehicleid)) != INVALID_PLAYER_ID && PlayerData[driverid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't teleport the vehicle of an admin who has a higher admin level than you.");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 1, y + 1, z + 2.0);

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	SendClientMessageEx(playerid, COLOR_GREY2, "Teleported vehicle ID %i to your position.", vehicleid);
	return 1;
}
CMD:gotoco(playerid, params[])
{
    return callcmd::gotocoords(playerid, params);
}
CMD:gotocoords(playerid, params[])
{
	new Float:x, Float:y, Float:z, interiorid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "fffI(0)", x, y, z, interiorid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotocoords [x] [y] [z] [int (optional)]");
	}

	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interiorid);
	return 1;
}

CMD:gotoint(playerid, params[])
{
	static list[4096];

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	if(isnull(list))
	{
	    for(new i = 0; i < sizeof(interiorArray); i ++)
	    {
	        format(list, sizeof(list), "%s\n%s", list, interiorArray[i][intName]);
		}
	}

	Dialog_Show(playerid, DIALOG_INTERIORS, DIALOG_STYLE_LIST, "Choose an interior to teleport to.", list, "Select", "Cancel");
	return 1;
}

CMD:jetpack(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

    PlayerData[playerid][pJetpack] = 1;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	GameTextForPlayer(playerid, "~g~Jetpack", 3000, 3);

	switch(random(4))
	{
	    case 0: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: The jetpack is part of an experiment conducted at the Area 69 facility.");
	    case 1: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You stole this from Area 69 in that one single player mission. Remember?");
	    case 2: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You probably don't need this anyway. All you admins seem to do is airbreak around the map.");
	    case 3: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You probably aren't reading this anyway. Fuck you.");
	}

	return 1;
}

CMD:sendto(playerid, params[])
{
	new targetid, option[12], param[32];

    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[12]S()[32]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendto [playerid] [location]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Player, Vehicle, LS, SF, LV, Grove, Idlewood, Unity, Jefferson, Market, Bank");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Dealership, VIP, Paintball, DMV, Casino");
		return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!IsPlayerSpawnedEx(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is either not spawned, or spectating.");
	}
	if(PlayerData[targetid][pJailType])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player is in jail so you can't teleport them.");
	}
	if(PlayerData[targetid][pPaintball] > 0 && PlayerData[playerid][pPaintball] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently in the paintball arena.");
	}
	if(IsPlayerInEvent(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently in the event.");
	}
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && isnull(PlayerData[targetid][pHelpRequest]) && PlayerData[playerid][pAcceptedHelp] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't submitted a help request. Therefore you can't teleport them.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't teleport an admin who has a higher admin level than you.");
	}

	for(new i=0;i<sizeof(gotoCoords);i++)
	{
		if(!strcmp(option, gotoCoords[i][egc_Param], true))
		{
			TeleportToCoords(targetid, gotoCoords[i][egc_X], gotoCoords[i][egc_Y], gotoCoords[i][egc_Z], gotoCoords[i][egc_A], gotoCoords[i][egc_Int], gotoCoords[i][egc_VW]);
			SendClientMessageEx(playerid, COLOR_GREY2, "You have sent %s to %s.", GetRPName(targetid), gotoCoords[i][egc_Name]);
			SendClientMessageEx(targetid, COLOR_GREY2, "%s has sent you to %s.", GetRPName(playerid), gotoCoords[i][egc_Name]);
			return 1;
		}
	}
	if(!strcmp(option, "spawn", true))
	{
		TeleportToCoords(targetid,  NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2], NewbSpawnPos[3], 0, 0);
		SendClientMessageEx(playerid, COLOR_GREY2, "You have sent %s to Spawn.", GetRPName(targetid));
		SendClientMessageEx(targetid, COLOR_GREY2, "%s has sent you to Spawn.", GetRPName(playerid));
	}
	else if(!strcmp(option, "player", true))
    {
        new sendtargetid;

        if(PlayerData[playerid][pAdmin] < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Only level 2+ admins can do this.");
		}
        if(sscanf(param, "u", sendtargetid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendto [playerid] [player] [targetid]");
		}
		if(!IsPlayerConnected(sendtargetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The target specified is disconnected.");
		}
		if(!IsPlayerSpawnedEx(sendtargetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The target specified is either not spawned, or spectating.");
		}

		TeleportToPlayer(targetid, sendtargetid);

		SendClientMessageEx(playerid, COLOR_GREY2, "You have sent %s to %s's location.", GetRPName(targetid), GetRPName(sendtargetid));
		SendClientMessageEx(targetid, COLOR_GREY2, "%s has sent you to %s's location.", GetRPName(playerid), GetRPName(sendtargetid));
	}
	else if(!strcmp(option, "vehicle", true))
    {
        new vehicleid;

        if(PlayerData[playerid][pAdmin] < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Only level 2+ admins can do this.");
		}
        if(sscanf(param, "i", vehicleid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendto [playerid] [vehicle] [vehicleid]");
		}
		if(!IsValidVehicle(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle specified.");
		}

		TeleportToVehicle(targetid, vehicleid);

		SendClientMessageEx(playerid, COLOR_GREY2, "You have sent %s to vehicle ID %i.", GetRPName(targetid), vehicleid);
		SendClientMessageEx(targetid, COLOR_GREY2, "%s has sent you to vehicle ID %i.", GetRPName(playerid), vehicleid);
	}

	return 1;
}

CMD:listen(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}

	if(!PlayerData[playerid][pListen])
	{
		PlayerData[playerid][pListen] = 1;
	    SendClientMessage(playerid, COLOR_AQUA, "You are now listening to all IC & local OOC chats.");
	}
	else
	{
		PlayerData[playerid][pListen] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "You are no longer listening to IC & local OOC chats.");
	}

	return 1;
}

CMD:jail(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /jail [playerid] [minutes] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be jailed.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /ojail.");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
	}

    PlayerData[targetid][pJailType] = 1;
    PlayerData[targetid][pJailTime] = minutes * 60;

    ResetPlayerWeaponsEx(targetid);
	ResetPlayer(targetid);
	SetPlayerInJail(targetid);

	GetPlayerName(playerid, PlayerData[targetid][pPrisonedBy], MAX_PLAYER_NAME);
	strcpy(PlayerData[targetid][pPrisonReason], reason, 128);
    
    Log_Write("log_punishments", "%s (uid: %i) jailed %s (uid: %i) for %i minutes, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes, reason);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was jailed for %i minutes by %s, reason: %s", GetRPName(targetid), minutes, GetRPName(playerid), reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been admin jailed for %i minutes by %s.", minutes, GetRPName(playerid));
    return 1;
}

CMD:rwarn(playerid, params[])
{
	new targetid, reason[128];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rwarn [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pReportMuted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is muted from reports.");
	}

	PlayerData[targetid][pReportWarns]++;

	SendClientMessageEx(targetid, COLOR_LIGHTRED, "* %s issued you a report warning, reason: %s (%i/3)", GetRPName(playerid), reason, PlayerData[targetid][pReportWarns]);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was given a report warning by %s, reason: %s", GetRPName(targetid), GetRPName(playerid), reason);

	if(PlayerData[targetid][pReportWarns] >= 3)
	{
	    PlayerData[targetid][pReportMuted] = 12;
	    SendClientMessage(targetid, COLOR_LIGHTRED, "* You have been muted from reports for 12 playing hours.");
	}

	return 1;
}

CMD:sendhelp(playerid, params[])
{
    if (PlayerData[playerid][pHelper] < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only helpers can use this command.");
    }

    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendhelp [playerid]");
    }

    if (!IsPlayerConnected(targetid) || IsAdmin(targetid) || PlayerData[targetid][pHelper])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't send help to this player.");
    }
    SendHelperMessage(COLOR_AQUA, "* %s %s offer's a help to %s *", GetHelperRank(playerid), GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_AQUA, "* %s %s offer's you a help *", GetHelperRank(playerid), GetRPName(playerid));
    Dialog_Show(targetid, OnSpawnRequestHelper, DIALOG_STYLE_MSGBOX, "Helper request", "Did you need a helper?\n He can explain the rules, show you the city\n and help you to find your first job!", "Yes", "No");
    return 1;
}

CMD:runmute(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /runmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pReportMuted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is not muted from reports.");
	}

	PlayerData[targetid][pReportWarns] = 0;
	PlayerData[targetid][pReportMuted] = 0;

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from reports by %s.", GetRPName(targetid), GetRPName(playerid));
	SendClientMessageEx(targetid, COLOR_YELLOW, "Your report mute has been lifted by %s. Your report warnings were reset.", GetRPName(playerid));
	return 1;
}

CMD:nmute(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(!PlayerData[targetid][pNewbieMuted])
	{
	    PlayerData[targetid][pNewbieMuted] = 1;
		PlayerData[targetid][pNewbieMuteTime] = gettime() + 14400;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from newbie chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from newbie chat by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[targetid][pNewbieMuted] = 0;
		PlayerData[targetid][pNewbieMuteTime] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from newbie chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from newbie chat by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:hmute(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(!PlayerData[targetid][pHelpMuted])
	{
	    PlayerData[targetid][pHelpMuted] = 1;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from help requests by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from help requests by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[targetid][pHelpMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from help requests by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from help requests by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:admute(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && !PlayerData[playerid][pHelper])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /admute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(!PlayerData[targetid][pAdMuted])
	{
	    PlayerData[targetid][pAdMuted] = 1;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from advertisements by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from advertisements by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[targetid][pAdMuted] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from advertisements by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from advertisements by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:gmute(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(!PlayerData[targetid][pGlobalMuted])
	{
	    PlayerData[targetid][pGlobalMuted] = 1;
	    PlayerData[targetid][pGlobalMuteTime] = gettime() + 14400;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from global chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from global chat by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[targetid][pGlobalMuted] = 0;
	    PlayerData[targetid][pGlobalMuteTime] = 0;

	    SendStaffMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from global chat by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from global chat by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:rmute(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rmute [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(!PlayerData[targetid][pReportMuted])
	{
	    PlayerData[targetid][pReportMuted] = 99999;
        PlayerData[targetid][pReportMuteTime] = gettime() + 14400;

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was muted from submitting reports by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been muted from submitting reports by %s.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[targetid][pReportMuted] = 0;
		PlayerData[targetid][pReportMuteTime] = 0;

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was unmuted from submitting reports by %s.", GetRPName(targetid), GetRPName(playerid));
	    SendClientMessageEx(targetid, COLOR_WHITE, "You have been unmuted from submitting reports by %s.", GetRPName(playerid));
	}

	return 1;
}

CMD:userid(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    new userid;
    if (sscanf(params, "i", userid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /userid [userid]");
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username from "#TABLE_USERS" where uid=%i", userid);
    mysql_tquery(connectionID, queryBuffer, "SearchUsernameByUserID", "i", playerid);
    return 1;
}

forward SearchUsernameByUserID(playerid);
public SearchUsernameByUserID(playerid)
{
    if (cache_num_rows() == 0)
    {
        SendClientMessageEx(playerid, COLOR_SYNTAX, "There is no player with this ID.");
    }
    else
    {
        new username[MAX_PLAYER_NAME];
        cache_get_field_content(0, "username", username, sizeof(username));
        SendClientMessageEx(playerid, COLOR_SYNTAX, "The current username is %s.", username);
    }
    return 1;
}


CMD:nextweather(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a news reporter.");
	}
	if(nextWeather == 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
	}
	if(nextWeather == 1)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Moderate Sunny");
	}
	if(nextWeather == 2)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
	}
	if(nextWeather == 3)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny");
	}
	if(nextWeather == 4)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
	}
	if(nextWeather == 5)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
	}
	if(nextWeather == 6)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
	}
	if(nextWeather == 7)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
	}
	if(nextWeather == 8)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Rainy");
	}
	if(nextWeather == 9)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Foggy");
	}
	if(nextWeather == 10)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
	}
	if(nextWeather == 11)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
	}
	if(nextWeather == 12)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
	}
	if(nextWeather == 13)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
	}
	if(nextWeather == 14)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
	}
	if(nextWeather == 15)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
	}
	if(nextWeather == 16)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Rainy");
	}
	if(nextWeather == 17)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
	}
	if(nextWeather == 18)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
	}
	if(nextWeather == 19)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sandstorm");
	}
	if(nextWeather == 20)
	{
		SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Foggy(greenish)");
	}
	return 1;
}
CMD:freeze(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /freeze [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	TogglePlayerControllableEx(targetid, 0);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was frozen by %s.", GetRPName(targetid), GetRPName(playerid));
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unfreeze [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(PlayerData[targetid][pTazedTime])
	{
		ClearAnimations(targetid, 1);
		PlayerData[targetid][pTazedTime] = 0;
	}

	PlayerData[targetid][pTied] = 0;
	TogglePlayerControllableEx(targetid, 1);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s was unfrozen by %s.", GetRPName(targetid), GetRPName(playerid));
	return 1;
}


CMD:listguns(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listguns [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s's Weapons _______", GetRPName(targetid));

	for(new i = 0; i < 13; i ++)
	{
	    new
	        weapon,
	        ammo;

	    GetPlayerWeaponData(targetid, i, weapon, ammo);

	    if(weapon)
		{

			if(!PlayerHasWeapon(targetid, weapon, true)) {
		        SendClientMessageEx(playerid, COLOR_GREY2, "-> %s {FFD700}(Desynced){C8C8C8}", GetWeaponNameEx(weapon));
	    	} else {
            	SendClientMessageEx(playerid, COLOR_GREY2, "-> %s", GetWeaponNameEx(weapon));
			}
		}
	}

	return 1;
}

CMD:disarm(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /disarm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

 	ResetPlayerWeaponsEx(targetid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disarmed %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:nrn(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /nrn [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
/*	if(PlayerData[targetid][pLevel] > 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is level 3 or above and doesn't need a free namechange.");
	} */
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	Dialog_Show(targetid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "");
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to change their name for being Non-RP.", GetRPName(playerid), GetRPName(targetid));

	//new string[144]; // Declare the variable first

	//format(string, sizeof(string), "%s has accepted %s's name change to %s", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange]);
	//SendClientMessageToAll(COLOR_WHITE, string); // Optional: use the message
    //DCC_SendChannelMessage(NameLogs, string);
	return 1;
}


CMD:odm(playerid, params[])
{
	new name[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /odm [username]");
	}
    if(IsPlayerOnline(name))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /dm instead.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, ip, adminlevel, dmwarnings FROM "#TABLE_USERS" WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineDM", "is", playerid, name);
	return 1;
}

CMD:fine(playerid, params[])
{
	new targetid, amount, reason[128];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "uis[128]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fine [playerid] [amount] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be fined.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid amount.");
	}
	if(gettime() - PlayerData[playerid][pLastFine] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /fine again.", 60 - (gettime() - PlayerData[playerid][pLastFine]));
	}

	GivePlayerCash(targetid, -amount);

	PlayerData[playerid][pLastFine] = gettime();

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was fined %s by %s, reason: %s", GetRPName(targetid), FormatCash(amount), GetRPName(playerid), reason);
	Log_Write("log_admin", "%s (uid: %i) fined %s (uid: %i) for $%i, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], amount, reason);
	return 1;
}

CMD:pfine(playerid, params[])
{
	new targetid, percent, reason[128];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uis[128]", targetid, percent, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pfine [playerid] [percent] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(!(1 <= percent <= 100))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The percentage value must be between 1 and 100.");
	}
	if(gettime() - PlayerData[playerid][pLastFine] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /fine again.", 60 - (gettime() - PlayerData[playerid][pLastFine]));
	}

	new amount = ((PlayerData[targetid][pCash] + PlayerData[targetid][pBank]) / 100) * percent;

	GivePlayerCash(targetid, -amount);

	PlayerData[playerid][pLastFine] = gettime();

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was fined %s by %s, reason: %s", GetRPName(targetid), FormatCash(amount), GetRPName(playerid), reason);
	Log_Write("log_admin", "%s (uid: %i) fined %s (uid: %i) for $%i (%i percent), reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], amount, percent, reason);
	return 1;
}

CMD:ofine(playerid, params[])
{
	new username[MAX_PLAYERS], amount, reason[128];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "s[24]is[128]", username, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ofine [username] [amount] [reason]");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid amount.");
	}
	if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /fine instead.");
	}
	if(gettime() - PlayerData[playerid][pLastFine] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /fine again.", 60 - (gettime() - PlayerData[playerid][pLastFine]));
	}

	PlayerData[playerid][pLastFine] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineFine", "isis", playerid, username, amount, reason);
	return 1;
}

CMD:sethp(playerid, params[])
{
    new targetid, Float:amount;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if(sscanf(params, "uf", targetid, amount))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sethp [playerid] [amount]");
        SendClientMessage(playerid, COLOR_SYNTAX, "Warning: Values above 255.0 may not work properly with the server-sided damage system.");
        return 1;
    }
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if(amount < 1.0 && PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't do this to an admin with a higher level than you.");
    }

    if(amount == 0.0)
    {
        DamagePlayer(targetid, 300, playerid, WEAPON_KNIFE, BODY_PART_UNKNOWN, false);
    }

    SetPlayerHealth(targetid, amount);
    SendClientMessageEx(playerid, COLOR_GREY2, "%s's health set to %.1f.", GetRPName(targetid), amount);
    return 1;
}
CMD:kill(playerid,params[])
{
	//TODO: Player can't kill him self while he is a hunt
	if((!IsPlayerConnected(playerid)) || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pDueling] || PlayerData[playerid][pJailTime] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	DamagePlayer(playerid, 300, playerid, WEAPON_KNIFE, BODY_PART_UNKNOWN, false); 
	new string[256];
	format(string, sizeof(string),"** %s breaks his back doing the limbo and dies.",GetRPName(playerid));
	return SendProximityFadeMessage(playerid, 20.0, string, 0xA187E3ff, 0xA187E3ff, 0xA187E3ff, 0xA187E3ff, 0xA187E3ff);
}

CMD:setarmor(playerid, params[])
{
    new targetid, Float:amount;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uf", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setarmor [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	SetScriptArmour(targetid, amount);
	SendClientMessageEx(playerid, COLOR_GREY2, "%s's armor set to %.1f.", GetRPName(targetid), amount);
	return 1;
}

CMD:refilldrug(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /refilldrug [seeds | crack | chems]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "This command refills the specified drug to maximum value.");
	    return 1;
	}

	if(!strcmp(params, "seeds", true))
	{
	    gSeedsStock = 1000;
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has refilled the seeds in the drug den.", GetRPName(playerid));
	}
	else if(!strcmp(params, "crack", true))
	{
	    gCocaineStock = 500;
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has refilled the crack in the crack house.", GetRPName(playerid));
	}
	else if(!strcmp(params, "chems", true))
	{
	    gEphedrineStock = 250;
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has refilled the chems in the drug den.", GetRPName(playerid));
	}

	return 1;
}

CMD:togooc(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!enabledOOC)
	{
	    enabledOOC = 1;
	    SendClientMessageToAllEx(COLOR_WHITE, "(( Administrator %s enabled the OOC channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledOOC = 0;
	    SendClientMessageToAllEx(COLOR_WHITE, "(( Administrator %s disabled the OOC channel. ))", GetRPName(playerid));
	}
	return 1;
}

CMD:tognewbie(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!enabledNewbie)
	{
	    enabledNewbie = 1;
	    SendClientMessageToAllEx(COLOR_NEWBIE, "* Administrator %s enabled the newbie channel.", GetRPName(playerid));
	}
	else
	{
	    enabledNewbie = 0;
	    SendClientMessageToAllEx(COLOR_NEWBIE, "* Administrator %s disabled the newbie channel.", GetRPName(playerid));
	}
	return 1;
}
CMD:god(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= GENERAL_MANAGER || PlayerData[playerid][pAdminDuty])
	{
		if(!PlayerData[playerid][pNoDamage])
		{
			PlayerData[playerid][pNoDamage] = 1;
			SendClientMessage(playerid, COLOR_GREY, "You are now in GODMODE, you will no longer take damage from ANYTHING.");
		}
		else
		{
		    PlayerData[playerid][pNoDamage] = 0;
		    SendClientMessage(playerid, COLOR_GREY, "You've turned off GODMODE, you will now take damage normally.");
		}
	    return 1;
	}
	return 0;
}

CMD:togglobal(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!enabledGlobal)
	{
	    enabledGlobal = 1;
	    SendClientMessageToAllEx(COLOR_GLOBAL, "(( Administrator %s enabled the global channel. ))", GetRPName(playerid));
	}
	else
	{
	    enabledGlobal = 0;
	    SendClientMessageToAllEx(COLOR_GLOBAL, "(( Administrator %s disabled the global channel. ))", GetRPName(playerid));
	}
	return 1;
}

CMD:togreports(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(!enabledReports)
	{
	    enabledReports = 1;
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has enabled the report channel.", GetRPName(playerid));
	}
	else
	{
	    enabledReports = 0;
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disabled the report channel.", GetRPName(playerid));
	}
	return 1;
}

CMD:pvehicles(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:pcars(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:pvehs(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:listpvehs(playerid, params[])
{
    return callcmd::listpvehicles(playerid, params);
}

CMD:listpvehicles(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listpvehs [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, interior FROM vehicles WHERE ownerid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListVehicles", "ii", playerid, targetid);
	return 1;
}


CMD:removepcar(playerid, params[])
{
    return callcmd::removepveh(playerid, params);
}
CMD:removepvehicle(playerid, params[])
{
    return callcmd::removepveh(playerid, params);    
}
CMD:removepveh(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removepveh [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, modelid, pos_x, pos_y, pos_z, interior FROM vehicles WHERE ownerid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListVehiclesForRemoval", "ii", playerid, targetid);
	return 1;
}

CMD:despawnpvehicle(playerid, params[])
{
    return callcmd::despawnpveh(playerid, params);    
}
CMD:despawnpcar(playerid, params[])
{
    return callcmd::despawnpveh(playerid, params);    
}
CMD:despawnpveh(playerid, params[])
{
	new vehicleid;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /despawnpveh [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or not owned by any player.");
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "You have despawned %s's %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid));
	DespawnVehicle(vehicleid);
	return 1;
}

#define FIRST_VEHICLE_MODEL_ID          (400)
#define LAST_VEHICLE_MODEL_ID           (611)
#define MODEL_SELECTION_ADMIN_VEHICLES  8

ShowSpawnVehicleMenu(playerid, type)
{
    new models[MAX_SELECTION_MENU_ITEMS] = {-1, ...};
    new index = 0;

    for (new i = FIRST_VEHICLE_MODEL_ID; i <= LAST_VEHICLE_MODEL_ID; i ++)
    {
        models[index++] = i;
    }
    ShowPlayerSelectionMenu(playerid, type, "Spawn Vehicle", models, index);
}

CMD:gveh(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    ShowSpawnVehicleMenu(playerid, MODEL_SELECTION_ADMIN_VEHICLES);
    return 1;
}

CMD:veh(playerid, params[])
{
	new model[20], modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, vehicleid;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
	if(sscanf(params, "s[20]I(-1)I(-1)", model, color1, color2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /veh [modelid/name] [color1 (optional)] [color2 (optional)]");
	}
	if((modelid = GetVehicleModelByName(model)) == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle model.");
	}
	if(!(-1 <= color1 <= 255) || !(-1 <= color2 <= 255))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid color. Valid colors range from -1 to 255.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, -1);

	if(vehicleid == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Cannot spawn vehicle. The vehicle pool is currently full.");
	}

	ResetVehicleObjects(vehicleid);

	adminVehicle{vehicleid} = true;
	RefuelVehicle(vehicleid);
	vehicleColors[vehicleid][0] = color1;
	vehicleColors[vehicleid][1] = color2;

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	PutPlayerInVehicle(playerid, vehicleid, 0);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s spawned a %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_WHITE, "%s (ID %i) spawned. Use '/savevehicle %i' to save this vehicle to the database.", GetVehicleName(vehicleid), vehicleid, vehicleid);
	return 1;
}

CMD:savevehicle(playerid, params[])
{
	new vehicleid, gangid, factionid, delay, vip, Float:x, Float:y, Float:z, Float:a, plate[32];

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "iiiiI(0)", vehicleid, gangid, factionid, delay, vip))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /savevehicle [vehicleid] [gangid (-1 = none)] [faction (-1 = none)] [respawn delay (seconds)] [vip level (optional)]");
	    return 1;
	}
	if(!IsValidVehicle(vehicleid) || !adminVehicle{vehicleid})
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is either invalid or not an admin spawned vehicle.");
	}
	if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
	}
	if(!(-1 <= factionid < MAX_FACTIONS) || (factionid >= 0 && FactionInfo[factionid][fType] == FACTION_NONE))
    {
		return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
    }
	if(!(0 <= vip <= 3))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid vip.");
	}

    SendClientMessageEx(playerid, COLOR_WHITE, "%s saved. This vehicle will now spawn here from now on.", GetVehicleName(vehicleid));

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);

	format(plate, 32, "%c%c%c %i", Random('A', 'Z'), Random('A', 'Z'), Random('A', 'Z'), Random(100, 999));

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (modelid, pos_x, pos_y, pos_z, pos_a, plate, color1, color2, gangid, factionid, vippackage, respawndelay, interior, world) VALUES(%i, '%f', '%f', '%f', '%f', '%s', %i, %i, %i, %i, %i, %i, %i, %i)",
		GetVehicleModel(vehicleid), x, y, z, a, plate, vehicleColors[vehicleid][0], vehicleColors[vehicleid][1], gangid, factionid, vip, delay, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	mysql_tquery(connectionID, queryBuffer);
	mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, 0);

	adminVehicle{vehicleid} = false;
	DestroyVehicleEx(vehicleid);

	return 1;
}

CMD:editvehicle(playerid, params[])
{
	new vehicleid, option[14], param[32], value, Float:value2;

	if(PlayerData[playerid][pAdmin] < MANAGEMENT)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[14]S()[32]", vehicleid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Spawn, Price, Tickets, Locked, Plate, Color, Paintjob, Neon, Trunk, Health");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Gang, Faction, Job, VIP, Respawndelay, Siren, Rank, Type, Division");
	    return 1;
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
	}

	if(!strcmp(option, "spawn", true))
	{
	    new id = VehicleInfo[vehicleid][vID];

	    /*if(VehicleInfo[vehicleid][vFaction] >= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can't set the spawn of a faction vehicle indoors.");
	    }*/

	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
	    	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);
	    }
	    else
	    {
		    GetPlayerPos(playerid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
		    GetPlayerFacingAngle(playerid, VehicleInfo[vehicleid][vPosA]);
	    }

	    if(VehicleInfo[vehicleid][vGang] >= 0 || VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
	        VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);
	        SaveVehicleModifications(vehicleid);
	    }

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], id);
		mysql_tquery(connectionID, queryBuffer);

	 	SendClientMessageEx(playerid, COLOR_AQUA, "* You have moved the spawn point for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
	 	SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
	 	DespawnVehicle(vehicleid, false);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);


	}
	else if(!strcmp(option, "price", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [price] [value]");
		}

		VehicleInfo[vehicleid][vPrice] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET price = %i WHERE id = %i", VehicleInfo[vehicleid][vPrice], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the price of %s's %s (ID %i) to $%i.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
	    Log_Write("log_admin", "%s (uid: %i) has edited vehicle id %d price to $%d", GetPlayerNameEx(playerid), vehicleid, value);

	}

	else if(!strcmp(option, "mileage", true))
	{
		if(sscanf(param, "i", value2))
		{
		    return SendSyntaxMessage(playerid, " /editvehicle [vehicleid] [mileage] [value]");
		}

		VehicleInfo[vehicleid][vMileage] = value2;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mileage = %.2f WHERE id = %i", VehicleInfo[vehicleid][vMileage], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		if(value2 == 0)
		    SendClientMessageEx(playerid, COLOR_AQUA, "** Ju keni ristartuar kilometrazhin e vetures %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "** Ju keni edituar kilometrazhin e vetures %s (ID %i) n? (%i) KM.", GetVehicleName(vehicleid), vehicleid, value);
	}

	else if(!strcmp(option, "type", true))
	{
	    if(VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on a not player owned vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [type] [0/1]");
		}

		VehicleInfo[vehicleid][vType] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET type = %i WHERE id = %i", VehicleInfo[vehicleid][vType], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the type of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
	}
	else if(!strcmp(option, "tickets", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [tickets] [value]");
		}

		VehicleInfo[vehicleid][vTickets] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the tickets of %s's %s (ID %i) to $%i.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
	}
	else if(!strcmp(option, "locked", true))
	{
		if(sscanf(param, "i", value) || !(0 <= value <= 1))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [locked] [0/1]");
		}
		if(VehicleInfo[vehicleid][vFaction] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Faction vehicles can't be locked.");
		}

		VehicleInfo[vehicleid][vLocked] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[vehicleid][vLocked], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SetVehicleParams(vehicleid, VEHICLE_DOORS, value);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the locked state of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
	}

    else if(!strcmp(option, "color", true))
	{
	    new color1, color2;

		if(sscanf(param, "ii", color1, color2))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [color] [color 1] [color 2]");
		}
		if(!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The colors must range from 0 to 255.");
		}

		VehicleInfo[vehicleid][vColor1] = color1;
		VehicleInfo[vehicleid][vColor2] = color2;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		ChangeVehicleColor(vehicleid, color1, color2);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the colors of %s (ID %i) to %i, %i.", GetVehicleName(vehicleid), vehicleid, color1, color2);
	}
	else if(!strcmp(option, "paintjob", true))
	{
	    new paintjobid;

		if(sscanf(param, "i", paintjobid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [paintjobid] [value (-1 = none)]");
		}
		if(!(-1 <= paintjobid <= 5))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The paintjob must range from -1 to 5.");
		}
		if(VehicleInfo[vehicleid][vFaction] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You can't change the paintjob on a faction vehicle.");
		}

		VehicleInfo[vehicleid][vPaintjob] = paintjobid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", VehicleInfo[vehicleid][vPaintjob], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		ChangeVehiclePaintjob(vehicleid, paintjobid);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the paintjob of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, paintjobid);
	}
	else if(!strcmp(option, "impound", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
		}
		new paintjobid;
		if(sscanf(param, "i", paintjobid))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [impound] [-1 to reset]");
		    return 1;
		}

		VehicleInfo[vehicleid][carImpounded] = paintjobid;
		VehicleInfo[vehicleid][carImpoundPrice] = -1;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vehicles` SET `carImpounded` = '%i', `carImpoundPrice` = '100' WHERE `id` = '%i'", paintjobid, VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the neon type of %s's %s (ID %i) to %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, param);
	}
	else if(!strcmp(option, "neon", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
		}
		if(isnull(param))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [neon] [color]");
		    SendClientMessage(playerid, COLOR_SYNTAX, "List of colors: None, Red, Blue, Green, Yellow, Pink, White");
		    return 1;
		}

		if(!strcmp(param, "neon", true)) {
		    SetVehicleNeon(vehicleid, 0);
		} else if(!strcmp(param, "red", true)) {
			SetVehicleNeon(vehicleid, 18647);
		} else if(!strcmp(param, "blue", true)) {
			SetVehicleNeon(vehicleid, 18648);
		} else if(!strcmp(param, "green", true)) {
			SetVehicleNeon(vehicleid, 18649);
		} else if(!strcmp(param, "yellow", true)) {
			SetVehicleNeon(vehicleid, 18650);
		} else if(!strcmp(param, "pink", true)) {
			SetVehicleNeon(vehicleid, 18651);
		} else if(!strcmp(param, "white", true)) {
			SetVehicleNeon(vehicleid, 18652);
		} else {
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid color.");
		}

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the neon type of %s's %s (ID %i) to %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, param);
	}
	else if(!strcmp(option, "trunk", true))
	{
	    if(!VehicleInfo[vehicleid][vOwnerID])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value) || !(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [trunk] [level (0-3)]");
		}

		VehicleInfo[vehicleid][vTrunk] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the trunk of %s's %s (ID %i) to level %i/3.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), vehicleid, value);
	}
	else if(!strcmp(option, "health", true))
	{
	    new Float:amount;

		if(sscanf(param, "f", amount))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [health] [amount]");
		}
		if(!(300.0 <= amount <= 10000.0))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The health value must range from 300.0 to 10000.0.");
		}

		VehicleInfo[vehicleid][vHealth] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET health = '%f' WHERE id = %i", VehicleInfo[vehicleid][vHealth], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SetVehicleHealth(vehicleid, amount);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the health of %s (ID %i) to %.2f.", GetVehicleName(vehicleid), vehicleid, amount);
	}
	else if(!strcmp(option, "gang", true))
	{
	    new gangid;

        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", gangid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [gang] [gangid (-1 = none)]");
		}
		if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		}

		VehicleInfo[vehicleid][vGang] = gangid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET gangid = %i WHERE id = %i", VehicleInfo[vehicleid][vGang], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		if(gangid == -1)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You have reset the gang for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
			SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the gang of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GangInfo[gangid][gName], gangid);
	}
 	else if(!strcmp(option, "faction", true))
	{
	    new factionid;

        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", factionid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [faction] [id]");
	        return 1;
		}

		VehicleInfo[vehicleid][vFaction] = factionid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET factionid = %i WHERE id = %i", VehicleInfo[vehicleid][vFaction], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(factionid == -1)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the faction type for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the faction type of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, 
            FactionInfo[factionid][fName], factionid);
	}
 	else if(!strcmp(option, "division", true))
	{
	    new id;

        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", id))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [division] [id]");
		}
		if(!(-1 <= id < MAX_FACTION_DIVISIONS))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid id.");
		}
		if(id!=-1 && isnull(FactionDivisions[PlayerData[playerid][pFaction]][id]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid id.");
		}
		VehicleInfo[vehicleid][vFGDivision] = id;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET fgdivisionid = %i WHERE id = %i", VehicleInfo[vehicleid][vFGDivision], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(id == -1)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the faction division for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the faction division of %s (ID %i) to (%i).", GetVehicleName(vehicleid), vehicleid, id);
	}
	else if(!strcmp(option, "job", true))
	{
        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", value))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [job] [type]");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (-1) None (0) Pizzaman (1) Courier (2) Fisherman (3) Bodyguard (4) Arms Dealer (5) Mechanic");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of jobs: (6) Miner (7) Sweeper (8) Taxi Driver (9) Drug Dealer (10) Lawyer (11) Detective (12) Thief");
			return 1;
		}
		if(!(-1 <= value < JOB_SIZE))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid job.");
		}

		VehicleInfo[vehicleid][vJob] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET job = %i WHERE id = %i", VehicleInfo[vehicleid][vJob], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(value == JOB_NONE)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the job type for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the job type of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GetJobName(value), value);
	}
	else if(!strcmp(option, "vip", true))
	{
        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [vip] [level (0-3)]");
		}
		if(!(0 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid level.");
		}

		VehicleInfo[vehicleid][vVIP] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET vippackage = %i WHERE id = %i", VehicleInfo[vehicleid][vVIP], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(value == 0)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the VIP restriction for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the VIP restriction of %s (ID %i) to %s (%i).", GetVehicleName(vehicleid), vehicleid, GetVIPRank(value), value);
	}
    else if(!strcmp(option, "respawndelay", true))
	{
	    new id = VehicleInfo[vehicleid][vID];

	    if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [respawndelay] [seconds (-1 = none)]");
		}

	    VehicleInfo[vehicleid][vRespawnDelay] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET respawndelay = %i WHERE id = %i", VehicleInfo[vehicleid][vRespawnDelay], id);
		mysql_tquery(connectionID, queryBuffer);

	 	SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the respawn delay of %s (ID %i) to %i seconds.", GetVehicleName(vehicleid), vehicleid, value);
	 	SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
	 	DespawnVehicle(vehicleid, false);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);
	}
	else if(!strcmp(option, "siren", true))
	{
	    new id = VehicleInfo[vehicleid][vID];

	    if(VehicleInfo[vehicleid][vFaction] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option can only be adjusted on faction vehicles.");
		}
		if(sscanf(param, "i", value))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [siren] [1/0]");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET siren = %i WHERE id = %i", value, id);
		mysql_tquery(connectionID, queryBuffer);

	 	SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the siren of %s (ID %i) to %i.", GetVehicleName(vehicleid), vehicleid, value);
	 	SendClientMessage(playerid, COLOR_WHITE, "Note: The vehicle's ID may have changed in the mean time.");
	 	DespawnVehicle(vehicleid, false);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, -1);
	}
	else if(!strcmp(option, "rank", true))
	{
        if(VehicleInfo[vehicleid][vOwnerID] > 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This option cannot be adjusted on player owned vehicles.");
		}
	    if(sscanf(param, "i", value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editvehicle [vehicleid] [rank] [rank(0-12)]");
		}
		if(!(0 <= value <= 12))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
		}

		VehicleInfo[vehicleid][vRank] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET vehicles.rank = %i WHERE id = %i", VehicleInfo[vehicleid][vRank], VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

		if(value == 0)
		    SendClientMessageEx(playerid, COLOR_AQUA, "* You've reset the rank restriction for %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
		else
	    	SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the rank restriction of %s (ID %i) to %i (%i).", GetVehicleName(vehicleid), vehicleid, VehicleInfo[vehicleid][vRank], value);
	}

	return 1;
}

CMD:removevehicle(playerid, params[])
{
	new vehicleid;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removevehicle [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
	}

	if(VehicleInfo[vehicleid][vOwnerID]) {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have deleted %s's %s.", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid));
	} else {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have deleted %s (ID %i).", GetVehicleName(vehicleid), vehicleid);
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	DespawnVehicle(vehicleid, false);
	return 1;
}

CMD:vehicleinfo(playerid, params[])
{
	new vehicleid, neon[12], gang[32], Float:health;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vehicleinfo [vehicleid]");
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
	}

	GetVehicleHealth(vehicleid, health);

	switch(VehicleInfo[vehicleid][vNeon])
	{
	    case 18647: neon = "Red";
		case 18648: neon = "Blue";
		case 18649: neon = "Green";
		case 18650: neon = "Yellow";
		case 18651: neon = "Pink";
		case 18652: neon = "White";
		default: neon = "None";
	}

	if(VehicleInfo[vehicleid][vGang] >= 0)
	{
		strcat(gang, GangInfo[VehicleInfo[vehicleid][vGang]][gName]);
	}
	else
	{
	    gang = "None";
	}

	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s Stats _______", GetVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_GREY2, "Owner: %s - Value: %s - Tickets: %s - License Plate: %s", VehicleInfo[vehicleid][vOwner], FormatCash(VehicleInfo[vehicleid][vPrice]), FormatCash(VehicleInfo[vehicleid][vTickets]), VehicleInfo[vehicleid][vPlate]);
	SendClientMessageEx(playerid, COLOR_GREY2, "Neon: %s - Trunk Level: %i/3 - Alarm Level: %i/3 - Health: %.1f - Fuel: %i/100", neon, VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vAlarm], health, GetVehicleFuel(vehicleid));
	//SendClientMessageEx(playerid, COLOR_GREY2, "Gang: %s - Faction: %s - Rank: %i - Job Type: %s - Respawn Delay: %i seconds", gang, factionTypes[VehicleInfo[vehicleid][vFaction]], VehicleInfo[vehicleid][vRank], GetJobName(VehicleInfo[vehicleid][vJob]), VehicleInfo[vehicleid][vRespawnDelay]);
	return 1;
}

CMD:aclearwanted(playerid, params[])
{
    new targetid;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /aclearwanted [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pWantedLevel])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player has no active charges to clear.");
	}

	PlayerData[targetid][pWantedLevel] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(targetid, COLOR_WHITE, "Your crimes were cleared by %s.", GetRPName(playerid));
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has cleared %s's crimes and wanted level.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:removedm(playerid, params[])
{
    new targetid;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removedm [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pDMWarnings] && !PlayerData[targetid][pWeaponRestricted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't been punished for DM recently.");
	}

	PlayerData[targetid][pDMWarnings]--;
	PlayerData[targetid][pWeaponRestricted] = 0;

	if(PlayerData[targetid][pJailType] == 2)
	{
	    PlayerData[targetid][pJailType] = 0;
		PlayerData[targetid][pJailTime] = 0;

		SetPlayerPos(targetid, 1544.4407, -1675.5522, 13.5584);
		SetPlayerFacingAngle(targetid, 90.0000);
		SetPlayerInterior(targetid, 0);
		SetPlayerVirtualWorld(targetid, 0);
		SetCameraBehindPlayer(targetid);
		SetPlayerWeapons(targetid);
	}

	SendClientMessageEx(targetid, COLOR_AQUA, "* Your DM punishment has been reversed by %s.", GetRPName(playerid));
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reversed %s's DM punishment.", GetRPName(playerid), GetRPName(targetid));
	Log_Write("log_admin", "%s (uid: %i) reversed %s's (uid: %i) DM punishment.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET jailtype = 0, jailtime = 0, dmwarnings = %i, weaponrestricted = 0 WHERE uid = %i", PlayerData[targetid][pDMWarnings], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	return 1;
}

CMD:destroyveh(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	if(adminVehicle{vehicleid})
	{
	    DestroyVehicleEx(vehicleid);
	    adminVehicle{vehicleid} = false;
	    return SendClientMessage(playerid, COLOR_GREY, "Admin vehicle destroyed.");
	}

	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	    if(adminVehicle{i})
	    {
	        if(IsValidDynamicObject(vehicleSiren[i]))
			{
			    DestroyDynamicObject(vehicleSiren[i]);
			    vehicleSiren[i] = INVALID_OBJECT_ID;
			}

	        DestroyVehicleEx(i);
	        adminVehicle{i} = false;
		}
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s destroyed all admin spawned vehicles.", GetRPName(playerid));
	return 1;
}

CMD:respawncars(playerid, params[])
{
	new option[10], param[12];

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "s[10]S()[12]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /respawncars [job | faction | nearby | all]");
	}
	if(!strcmp(option, "job", true))
	{
		foreach(new i: Vehicle)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i})
		    {
		        if(IsJobCar(i))
		        {
	        		SetVehicleToRespawn(i);
				}
	 		}
		}

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied job vehicles.", GetRPName(playerid));
	}
	else if(!strcmp(option, "faction", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /respawncars [faction] [type]");
	        SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (1) Police (2) Medic (3) News (4) Government (5) Hitman (6) Federal");
	        return 1;
		}
		if(!(1 <= type <= 5))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid faction type.");
		}

		foreach(new i: Vehicle)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i} && VehicleInfo[i][vFaction] == type)
	    	{
				SetVehicleToRespawn(i);
			}
		}

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied {F7A763}%s{FF6347} vehicles.", GetRPName(playerid), factionTypes[type]);
	}
	else if(!strcmp(option, "nearby", true))
	{
		foreach(new i: Vehicle)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i} && IsVehicleStreamedIn(i, playerid))
		    {
				SetVehicleToRespawn(i);
			}
		}

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied vehicles in %s.", GetRPName(playerid), GetPlayerZoneName(playerid));
	}
	else if(!strcmp(option, "all", true))
	{
		foreach(new i: Vehicle)
		{
	    	if(!IsVehicleOccupied(i) && !adminVehicle{i})
		    {
				SetVehicleToRespawn(i);
			}
		}

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s respawned all unoccupied vehicles.", GetRPName(playerid));
	}

	return 1;
}

CMD:broadcast(playerid, params[])
{
	new style, text[128];

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[128]", style, text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /broadcast [style (0-6)] [text]");
	}
	if(!(0 <= style <= 6))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid style.");
	}
	if(style == 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Style 2 only disappears after death and is therefore disabled.");
	}

	GameTextForAll(text, 6000, style);
	return 1;
}

CMD:fixveh(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't fix a vehicle if you're not sitting in one.");
	}

	RepairVehicle(GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, COLOR_GREY, "Vehicle fixed.");
	return 1;
}

CMD:cc( playerid, params[], help) {

	if( PlayerData[ playerid ][ pAdmin ] >= ASST_MANAGEMENT)
	{
		for( new j; j < 96; j++ ) {
			SendClientMessageToAllEx( -1, " " );
		}
		SendClientMessageToAllEx( 0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );

 		SendAdminMessage( 0x1692B8FF, "Chat was cleared by admin %s", GetPlayerNameEx(playerid));
		SendClientMessageToAllEx( 0x1692B8FF, "     {d909d9}>>> {FFFFFF}%s{d909d9} <<<",GetHostName() );
		SendClientMessageToAllEx( 0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );
	}
	return 1;
}

CMD:clear(playerid, params[])
{
    for ( new j; j < 96; j++ )
    {
        SendClientMessageEx(playerid, -1, " " );
    }
    SendClientMessageEx(playerid, 0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );
    SendClientMessageEx(playerid, 0x1692B8FF, "     {d909d9}>>> {FFFFFF}%s{d909d9} <<<",GetHostName() );
    SendClientMessageEx(playerid, 0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );
    return 1;
}

CMD:healrange(playerid, params[])
{
	new Float:radius;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /healrange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	foreach(new i : Player)
	{
		if(IsPlayerNearPlayer(i, playerid, radius))
		{
		    if(!PlayerData[i][pAdminDuty])
		    {
			    SetPlayerHealth(i, 100.0);

			    if(GetPlayerArmourEx(i) < 25.0)
			    {
				    SetScriptArmour(i, 25.0);
				}
			}

		    SendClientMessage(i, COLOR_WHITE, "An admin has healed everyone nearby.");
		}
	}

	return 1;
}

CMD:freezerange(playerid, params[])
{
	new Float:radius;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /freezerange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerNearPlayer(i, playerid, radius))
		{
		    if(!PlayerData[i][pAdminDuty])
		    {
			    TogglePlayerControllableEx(i, false);
			}

		    SendClientMessage(i, COLOR_WHITE, "An admin has frozen everyone nearby.");
		}
	}

	return 1;
}

CMD:unfreezerange(playerid, params[])
{
	new Float:radius;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unfreezerange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerNearPlayer(i, playerid, radius))
		{
		    if(!PlayerData[i][pAdminDuty])
		    {
			    TogglePlayerControllableEx(i, true);
			}

		    SendClientMessage(i, COLOR_WHITE, "An admin has unfrozen everyone nearby.");
		}
	}

	return 1;
}

CMD:reviverange(playerid, params[])
{
	new Float:radius;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "f", radius))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /reviverange [radius]");
	}
	if(!(1.0 <= radius <= 50.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The radius can't be below 1.0 or above 50.0.");
	}

	foreach(new i : Player)
	{
		if(IsPlayerNearPlayer(i, playerid, radius) && PlayerData[i][pInjured])
		{
			PlayerData[i][pInjured] = 0;
			if(PlayerData[i][pAcceptedEMS] != INVALID_PLAYER_ID)
			{
			    SendClientMessageEx(PlayerData[i][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has somehow found the strength to get up.", GetRPName(i));
			    PlayerData[i][pAcceptedEMS] = INVALID_PLAYER_ID;
			}

			SetPlayerHealth(i, 100.0);
			ClearAnimations(i, 1);

		    SendClientMessage(i, COLOR_WHITE, "An admin has revived everyone nearby.");
		}
	}

	return 1;
}

CMD:shots(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /shots [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM shots WHERE playerid = %i ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListShots", "ii", playerid, targetid);
	return 1;
}

CMD:damages(playerid, params[])
{
	new playerb;

	if(sscanf(params, "u", playerb))return SendClientMessage(playerid, COLOR_ADM, "USAGE:{FFFFFF} /damages [playerid/PartofName]");
	if(!IsPlayerConnected(playerb))return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You have specified an invalid player.");
	if(PlayerData[playerid][pAdminDuty])
	{
		ReturnDamagesAdmin(playerb, playerid);
	}
	else{

		if(!IsPlayerNearPlayer(playerid, playerb, 5.0)) return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You must be closer to that player.");
		ReturnDamages(playerb, playerid);
	}
	return true;
}

CMD:adamages(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /damages [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT weaponid, playerid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListDamages", "ii", playerid, targetid);
	return 1;
}

CMD:kills(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /kills [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM kills WHERE killer_uid = %i OR target_uid = %i ORDER BY date DESC LIMIT 20", PlayerData[targetid][pID], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminListKills", "ii", playerid, targetid);
	return 1;
}

CMD:setname(playerid, params[])
{
	new targetid, name[24];

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[24]", targetid, name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setname [playerid] [name]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
 	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(PlayerData[targetid][pAdminDuty] && strcmp(PlayerData[targetid][pAdminName], "None", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't change the name of a player on admin duty. They're using their admin name.");
	}
	if(!IsValidUsername(name))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The name specified is not supported by the SA-MP client.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminChangeName", "iis", playerid, targetid, name);
	return 1;
}

CMD:explode(playerid, params[])
{
	new targetid, damage;

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "ui", targetid, damage))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /explode [playerid] [damage(amount)]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[playerid][pAdmin] < PlayerData[targetid][pAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	CreateExplosionForPlayer(targetid, x, y, z, 6, 20.0);
    AwardAchievement(targetid, ACH_AcmeDinamyte);    
	SendClientMessageEx(playerid, COLOR_WHITE, "You exploded %s for their client only.", GetRPName(targetid));
	return 1;
}

CMD:oban(playerid, params[])
{
	new username[MAX_PLAYERS], duration, reason[128];

	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "s[24]ds[128]", username, duration, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /oban [username] [duration in days] [reason]");
	}
	if(gettime() - PlayerData[playerid][pLastBan] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /ban again.", 60 - (gettime() - PlayerData[playerid][pLastBan]));
	}
    if(IsPlayerOnline(username))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use /ban instead.");
	}
	
	if(duration <= 0 || duration >= 365 * 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid duration value.");
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel, ip, uid FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OBanCheckPlayer", "isis", playerid, username, duration, reason);
	return 1;
}

CMD:permaban(playerid, params[])
{
	new targetid, reason[128];

 	if(PlayerData[playerid][pAdmin] < 8)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "us[128]", targetid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /permaban [playerid] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be banned.");
	}

    BanPlayerPermanent(targetid, reason, playerid);

	return 1;
}

CMD:baninfo(playerid, params[])
{
	new string[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN && !PlayerData[playerid][pBanAppealer])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", string))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /baninfo [username/ip]");
	}
 
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users_bans WHERE (username = '%e' OR ip = '%e') and ((date + interval duration day) > now() || duration = 0)", string, string);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckBan", "is", playerid, string);
	return 1;
}

CMD:banhistory(playerid, params[])
{
	new name[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN && !PlayerData[playerid][pBanAppealer] && !PlayerData[playerid][pHumanResources])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /banhistory [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT a.date, a.description FROM log_bans a, "#TABLE_USERS" b WHERE a.uid = b.uid AND b.username = '%e' ORDER BY a.date DESC", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckBanHistory", "is", playerid, name);

	return 1;
}

CMD:unban(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pBanAppealer])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unban [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT userid, duration, userip FROM users_bans WHERE username = '%e' AND ((date + interval duration day) > now())", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminUnbanUser", "is", playerid, username);
	return 1;
}

/*

// Old Methode 

CMD:unban(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pBanAppealer])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unban [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, duration, userip FROM users_bans WHERE username = '%e' and ((date + interval duration day) > now())", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminUnbanUser", "is", playerid, username);
	return 1;
}

*/

CMD:lockaccount(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lockaccount [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT locked, adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminLockAccount", "is", playerid, username);
	return 1;
}

CMD:unlockaccount(playerid, params[])
{
	new username[MAX_PLAYER_NAME];

	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", username))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unlockaccount [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e' AND locked = 1", username);
	mysql_tquery(connectionID, queryBuffer, "OnAdminUnlockAccount", "is", playerid, username);
	return 1;
}

CMD:sprison(playerid, params[])
{
	new targetid, minutes, reason[128];

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "uis[128]", targetid, minutes, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sprison [playerid] [minutes] [reason]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be prisoned.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet. You can wait until they login or use /oprison.");
	}
	if(minutes < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount of minutes cannot be below one. /unjail to release a player.");
	}
	if(gettime() - PlayerData[playerid][pLastPrison] < 60)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %i more seconds before using /prison again.", 60 - (gettime() - PlayerData[playerid][pLastPrison]));
	}

    PlayerData[targetid][pJailType] = 2;
    PlayerData[targetid][pJailTime] = minutes * 60;

    ResetPlayerWeaponsEx(targetid);
    ResetPlayer(targetid);
    SetPlayerInJail(targetid);

	PlayerData[playerid][pLastPrison] = gettime();

    Log_Write("log_punishments", "%s (uid: %i) silently prisoned %s (uid: %i) for %i minutes, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes, reason);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s was prisoned for %i minutes by an Admin, reason: %s", GetRPName(targetid), minutes, reason);
    SendClientMessageEx(targetid, COLOR_AQUA, "* You have been admin prisoned for %i minutes by an admin.", minutes);
    return 1;
}

CMD:sethpall(playerid, params[])
{
    new Float:amount;

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if(sscanf(params, "f", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sethpall [amount]");
    }
    if(amount < 1.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Health can't be under 1.0.");
    }

    foreach(new i : Player)
    {
        if(amount == 0.0)
        {
            DamagePlayer(i, 300, playerid, WEAPON_KNIFE, BODY_PART_UNKNOWN, false);
        }

        if(!PlayerData[i][pAdminDuty] && !IsPlayerInEvent(i) && !PlayerData[i][pPaintball] && PlayerData[i][pDueling] == INVALID_PLAYER_ID)
        {
            SetPlayerHealth(i, amount);
        }
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s set everyone's health to %.1f.", GetRPName(playerid), amount);
    return 1;
}

CMD:setarmorall(playerid, params[])
{
	new Float:amount;

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "f", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setarmorall [amount]");
	}
	if(amount < 0.0 || amount > 150.0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Armor can't be under 0.0 or above 150.0.");
	}

	foreach(new i : Player)
	{
	    if(!PlayerData[i][pAdminDuty] && !IsPlayerInEvent(i) && !PlayerData[i][pPaintball] && PlayerData[i][pDueling] == INVALID_PLAYER_ID)
	    {
		    SetScriptArmour(i, amount);
		}
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s set everyone's armor to %.1f.", GetRPName(playerid), amount);
	return 1;
}

stock GivePlayerFullWeaponSet(playerid)
{
    GivePlayerWeaponEx(playerid, 24);
    GivePlayerWeaponEx(playerid, 27);
    GivePlayerWeaponEx(playerid, 29);
    GivePlayerWeaponEx(playerid, 30);
    GivePlayerWeaponEx(playerid, 34);
}

CMD:fws(playerid, params[])
{
    if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < ASST_MANAGEMENT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(PlayerData[playerid][pAdmin] >= SENIOR_ADMIN)
    {
        new targetid, reason[64];
        if (sscanf(params, "us[64]", targetid, reason))
        {
            SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /fws [playerid] [reason]");
            return 1;
        }
        GivePlayerFullWeaponSet(targetid);
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s gave a full weapon set to %s, reaason %s.", GetRPName(playerid), GetRPName(targetid), reason);
        SendClientMessageEx(targetid, COLOR_AQUA, "You have received a {00AA00}full weapon set{33CCFF} from %s.", GetRPName(playerid));
    }
    else
    {
        SendClientErrorUnauthorizedCmd(playerid);
    }
    return 1;
}

CMD:healup(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 1)
	{
		 return SendClientMessage(playerid, COLOR_GREY, "You are not {D909D9}Legendary VIP.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 3090.76, 221.60, 1053.48))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not in the {D909D9}Legendary VIP{afafaf} Lounge");
	}
	SetScriptArmour(playerid, 100);
	SetPlayerHealth(playerid, 100);
	return 1;
}
CMD:getboombox(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not {D909D9}Legendary VIP.");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1988.5000, -1255.9500, 2690.8100))
	{
        return SendClientMessage(playerid, 0xAFAFAFAA, "You are not in the {D909D9}Legendary VIP{Afafaf} Lounge.");
	}
    if(!strcmp(params, "confirm", true))
	{
		PlayerData[playerid][pBoombox] = 1;
	    SendClientMessageEx(playerid, COLOR_WHITE, "You have earned a free {D909D9}Legendary VIP{FFFFFF} boombox.");

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET boombox = 1 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}


CMD:vweapons(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not {D909D9}Legendary VIP.");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 3093.50, 221.60, 1053.48))
	{
        return SendClientMessage(playerid, 0xAFAFAFAA, "You are not in the {D909D9}Legendary VIP{Afafaf} Lounge.");
	}
	GivePlayerWeaponEx(playerid, 12);
	GivePlayerWeaponEx(playerid, 24);
	GivePlayerWeaponEx(playerid, 25);
	GivePlayerWeaponEx(playerid, 27);
	GivePlayerWeaponEx(playerid, 31);
	GivePlayerWeaponEx(playerid, 34);
	SendClientMessageEx(playerid, COLOR_AQUA, "You have received a {00AA00}full weapon set{33CCFF} from your vip weapons.");
 	return 1;
}


CMD:myassets(playerid, params[])
{

	if(!PlayerData[playerid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not logged in yet.");
	}

	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Assets _____", GetRPName(playerid));

	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {33CC33}House{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (gettime() - HouseInfo[i][hTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
		}
	}

 	foreach(new i : Business)
	{
	    if(BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {FFD700}Business{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]), (gettime() - BusinessInfo[i][bTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
		}
	}

 	foreach(new i : Garage)
	{
	    if(GarageInfo[i][gExists] && IsGarageOwner(playerid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {004CFF}Garage{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]), (gettime() - GarageInfo[i][gTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
		}
	}

	foreach(new i : Land)
	{
	    if(LandInfo[i][lExists] && IsLandOwner(playerid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {33CCFF}Land{C8C8C8} | ID: %i | Location: %s", i, GetZoneName(LandInfo[i][lHeightX], LandInfo[i][lHeightY], LandInfo[i][lHeightZ]));
		}
	}

	return 1;
}
CMD:listassets(playerid, params[])
{
	new targetid;

    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /listassets [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}

	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Assets _____", GetRPName(targetid));

	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && IsHouseOwner(targetid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {33CC33}House{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (gettime() - HouseInfo[i][hTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
		}
	}

 	foreach(new i : Business)
	{
	    if(BusinessInfo[i][bExists] && IsBusinessOwner(targetid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {FFD700}Business{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]), (gettime() - BusinessInfo[i][bTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
		}
	}

 	foreach(new i : Garage)
	{
	    if(GarageInfo[i][gExists] && IsGarageOwner(targetid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {004CFF}Garage{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]), (gettime() - GarageInfo[i][gTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
		}
	}

	foreach(new i : Land)
	{
	    if(LandInfo[i][lExists] && IsLandOwner(targetid, i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* {33CCFF}Land{C8C8C8} | ID: %i | Location: %s", i, GetZoneName(LandInfo[i][lHeightX], LandInfo[i][lHeightY], LandInfo[i][lHeightZ]));
		}
	}

	return 1;
}

CMD:asellgarage(playerid, params[])
{
	new garageid;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", garageid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellgarage [garageid]");
	}
	if(!(0 <= garageid < MAX_GARAGES) || !GarageInfo[garageid][gExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid garage.");
	}

	SetGarageOwner(garageid, INVALID_PLAYER_ID);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold garage %i.", garageid);
	return 1;
}

CMD:asellland(playerid, params[])
{
	new landid;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellland [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
	}

	SetLandOwner(landid, INVALID_PLAYER_ID);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold land %i.", landid);
	return 1;
}

CMD:paintball(playerid,params[])
{
	if(PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(PlayerData[playerid][pLevel] == 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't level 2+.");
	}
	
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1311.7522,-1367.2715,13.53) || 
	   IsPlayerInRangeOfPoint(playerid, 3.0, -1549.7334,1165.4608,7.1875))
	{
		if(PlayerData[playerid][pAcceptedHelp])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You can not enter the paintball arena while on helper duty!");
	    }
	    if(PlayerData[playerid][pWeaponRestricted] > 0)
    	{
        	return SendClientMessage(playerid, COLOR_GREY, "You are restricted from weapons and therefore can't join paintball.");
    	}
	    ShowDialogToPlayer(playerid, DIALOG_PAINTBALL);
	}else 
		return SendClientMessage(playerid, COLOR_GREY, "You are not near paintball!");
	return 1;
}

CMD:quitpaintball(playerid, params[])
{
    return callcmd::exitpaintball(playerid, params);
}
CMD:exitpaintball(playerid,params[])
{
    if (PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    if (PlayerData[playerid][pPaintball] > 0)
    {
        foreach(new i : Player)
        {
            if (PlayerData[playerid][pPaintball] == PlayerData[i][pPaintball])
            {
                SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s has left the paintball arena. ))", GetRPName(playerid));
            }
        }

        ResetPlayerWeapons(playerid);
        SetPlayerArmedWeapon(playerid, 0);
        PlayerData[playerid][pPaintball] = 0;
        PlayerData[playerid][pPaintballTeam] = -1;
        GangZoneHideForPlayer(playerid, zone_paintball[0]);
        GangZoneHideForPlayer(playerid, zone_paintball[1]);
        SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
        SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);
        SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
        SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
        SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
        SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
        SetPlayerWeapons(playerid);
    }
    return 1;
}
CMD:enter(playerid, params[])
{
	if(PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	else
	{
		EnterCheck(playerid);
	}

	return 1;
}

CMD:exit(playerid, params[])
{
    if(PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	else
	{
		ExitCheck(playerid);
	}

	return 1;
}


CMD:lock(playerid, params[])
{
	new id, houseid = GetInsideHouse(playerid), landid = GetNearbyLand(playerid);

	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
    	if(IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
    	{
		   	if(houseid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
			{
			    if(!(IsHouseOwner(playerid, houseid) || PlayerData[playerid][pRentingHouse] == HouseInfo[houseid][hID] || PlayerData[playerid][pFurniturePerms] == houseid))
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "You don't have permission from the house owner to lock this door.");
			    }

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_locked FROM rp_furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		 		mysql_tquery(connectionID, queryBuffer, "OnPlayerLockFurnitureDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		    	return 1;
			}
			else if(landid >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[landid][lID])
			{
			    if(!(IsLandOwner(playerid, landid) || PlayerData[playerid][pLandPerms] == landid))
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "You don't have permission from the land owner to lock this door.");
			    }

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
				mysql_tquery(connectionID, queryBuffer, "OnPlayerLockLandDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    return 1;
			}
		}
	}

    if((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID && (IsVehicleOwner(playerid, id) || PlayerData[playerid][pVehicleKeys] == id || (VehicleInfo[id][vGang] >= 0 && VehicleInfo[id][vGang] == PlayerData[playerid][pGang])))
	{
	    if(!VehicleInfo[id][vLocked])
	    {
            new string[24];
			VehicleInfo[id][vLocked] = 1;
   		    format(string, sizeof(string), "~r~%s locked", GetVehicleName(id));
            GameTextForPlayer(playerid, string, 3000, 3);
			ShowActionBubble(playerid, "* %s locks their %s.", GetRPName(playerid), GetVehicleName(id));
		}
		else
		{
			VehicleInfo[id][vLocked] = 0;
            new string[24];
            format(string, sizeof(string), "~b~%s unlocked", GetVehicleName(id));
            GameTextForPlayer(playerid, string, 3000, 3);
			ShowActionBubble(playerid, "* %s unlocks their %s.", GetRPName(playerid), GetVehicleName(id));
		}

		SetVehicleParams(id, VEHICLE_DOORS, VehicleInfo[id][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[id][vLocked], VehicleInfo[id][vID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyHouseEx(playerid)) >= 0 && (IsHouseOwner(playerid, id) || PlayerData[playerid][pRentingHouse] == HouseInfo[id][hID] || PlayerData[playerid][pHouseKeys] == id))
	{
	    if(!HouseInfo[id][hLocked])
	    {
			HouseInfo[id][hLocked] = 1;

			GameTextForPlayer(playerid, "~r~House locked", 3000, 6);
			ShowActionBubble(playerid, "* %s locks their house door.", GetRPName(playerid));
		}
		else
		{
			HouseInfo[id][hLocked] = 0;

			GameTextForPlayer(playerid, "~g~House unlocked", 3000, 6);
			ShowActionBubble(playerid, "* %s unlocks their house door.", GetRPName(playerid));
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[id][hLocked], HouseInfo[id][hID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyGarageEx(playerid)) >= 0 && IsGarageOwner(playerid, id))
	{
	    if(!GarageInfo[id][gLocked])
	    {
			GarageInfo[id][gLocked] = 1;

			GameTextForPlayer(playerid, "~r~Garage locked", 3000, 6);
			ShowActionBubble(playerid, "* %s locks their garage door.", GetRPName(playerid));
		}
		else
		{
			GarageInfo[id][gLocked] = 0;

			GameTextForPlayer(playerid, "~g~Garage unlocked", 3000, 6);
			ShowActionBubble(playerid, "* %s unlocks their garage door.", GetRPName(playerid));
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[id][gLocked], GarageInfo[id][gID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyBusinessEx(playerid)) >= 0 && IsBusinessOwner(playerid, id))
	{
	    if(!BusinessInfo[id][bLocked])
	    {
			BusinessInfo[id][bLocked] = 1;

			GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
			ShowActionBubble(playerid, "* %s locks their business door.", GetRPName(playerid));
		}
		else
		{
			BusinessInfo[id][bLocked] = 0;

			GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
			ShowActionBubble(playerid, "* %s unlocks their business door.", GetRPName(playerid));
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyEntranceEx(playerid)) >= 0)
	{
	    new correct_pass;

	    if(!IsEntranceOwner(playerid, id) && strcmp(EntranceInfo[id][ePassword], "None", true) != 0)
		{
			if(isnull(params)) {
                return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /lock [password]");
			} else if(strcmp(params, EntranceInfo[id][ePassword]) != 0) {
			    return SendClientMessage(playerid, COLOR_GREY, "Incorrect password.");
			} else {
				correct_pass = true;
			}
	    }

	    if((correct_pass) || IsEntranceOwner(playerid, id))
	    {
		    if(!EntranceInfo[id][eLocked])
		    {
				EntranceInfo[id][eLocked] = 1;

				GameTextForPlayer(playerid, "~r~Entrance locked", 3000, 6);
				ShowActionBubble(playerid, "* %s locks their entrance door.", GetRPName(playerid));
			}
			else
			{
				EntranceInfo[id][eLocked] = 0;

				GameTextForPlayer(playerid, "~g~Entrance unlocked", 3000, 6);
				ShowActionBubble(playerid, "* %s unlocks their entrance door.", GetRPName(playerid));
			}

            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[id][eLocked], EntranceInfo[id][eID]);
			mysql_tquery(connectionID, queryBuffer);
		}

		return 1;
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not close to anything which you can lock.");

	return 1;
}

CMD:alock(playerid, params[])
{
	new id;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
    	if(IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
		{
		    if((id = GetInsideHouse(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[id][hID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_locked FROM rp_furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		 		mysql_tquery(connectionID, queryBuffer, "OnPlayerLockFurnitureDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		    	return 1;
			}
			else if((id = GetNearbyLand(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[id][lID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_locked FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
				mysql_tquery(connectionID, queryBuffer, "OnPlayerLockLandDoor", "ii", playerid, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    return 1;
			}
		}
	}

    if((id = GetNearbyVehicle(playerid)) != INVALID_VEHICLE_ID)
	{
	    if(!VehicleInfo[id][vLocked])
	    {
			VehicleInfo[id][vLocked] = 1;
			GameTextForPlayer(playerid, "~r~Vehicle locked", 3000, 6);
		}
		else
		{
			VehicleInfo[id][vLocked] = 0;
			GameTextForPlayer(playerid, "~g~Vehicle unlocked", 3000, 6);
		}

		SetVehicleParams(id, VEHICLE_DOORS, VehicleInfo[id][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET locked = %i WHERE id = %i", VehicleInfo[id][vLocked], VehicleInfo[id][vID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyHouseEx(playerid)) >= 0)
	{
	    if(!HouseInfo[id][hLocked])
	    {
			HouseInfo[id][hLocked] = 1;
			GameTextForPlayer(playerid, "~r~House locked", 3000, 6);
		}
		else
		{
			HouseInfo[id][hLocked] = 0;
			GameTextForPlayer(playerid, "~g~House unlocked", 3000, 6);
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[id][hLocked], HouseInfo[id][hID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyGarageEx(playerid)) >= 0)
	{
	    if(!GarageInfo[id][gLocked])
	    {
			GarageInfo[id][gLocked] = 1;
			GameTextForPlayer(playerid, "~r~Garage locked", 3000, 6);
		}
		else
		{
			GarageInfo[id][gLocked] = 0;
			GameTextForPlayer(playerid, "~g~Garage unlocked", 3000, 6);
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = %i WHERE id = %i", GarageInfo[id][gLocked], GarageInfo[id][gID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyBusinessEx(playerid)) >= 0)
	{
	    if(!BusinessInfo[id][bLocked])
	    {
			BusinessInfo[id][bLocked] = 1;
			GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
		}
		else
		{
			BusinessInfo[id][bLocked] = 0;
			GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
		}

		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}
	else if((id = GetNearbyEntranceEx(playerid)) >= 0)
	{
	    if(!EntranceInfo[id][eLocked])
	    {
			EntranceInfo[id][eLocked] = 1;
			GameTextForPlayer(playerid, "~r~Entrance locked", 3000, 6);
		}
		else
		{
			EntranceInfo[id][eLocked] = 0;
			GameTextForPlayer(playerid, "~g~Entrance unlocked", 3000, 6);
		}

        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE entrances SET locked = %i WHERE id = %i", EntranceInfo[id][eLocked], EntranceInfo[id][eID]);
		mysql_tquery(connectionID, queryBuffer);
		return 1;
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not close to anything which you can lock.");

	return 1;
}

// PunLogs

LogPlayerPunishment(adminid, player_uid, ip[], type[], const description[], {Float,_}:...)
{
    static sizeArgsInBytes, args, string[4096];
    new admin_uid  = IsPlayerConnected(adminid)?PlayerData[adminid][pID]:0;

    if (!strlen(description))
    {
        return 0;
    }

    if ((args = numargs()) > 5)
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 5)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    description
        #emit PUSH.C    4096
        #emit PUSH.C    string
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO users_punishment (player_uid, player_ip, admin_uid, type, description) VALUES (%i, '%e', %i, '%e', '%e')",
                player_uid, ip, admin_uid, type, string);

        #emit RETN
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO users_punishment (player_uid, player_ip, admin_uid, type, description) VALUES (%i, '%e', %i, '%e', '%e')",
                player_uid, ip, admin_uid, type, description);
    }
    return 1;
}

CMD:punlist(playerid, params[])
{
    new targetid;
    if (!IsAdmin(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /punlist [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player id.");
    }
    if (!IsPlayerLoggedIn(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Player is not loggedin.");
    }
    if (PlayerData[playerid][pAdmin] < PlayerData[targetid][pAdmin])
    {
        // Show empty punlist
        new title[64];
        format(title, sizeof(title), "Punishment history of %s", GetPlayerNameEx(targetid));
        ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, "Date\tType\tDescription", "Ok", "Cancel");
        return 1;
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users_punishment WHERE player_uid = %i  ORDER BY date DESC", PlayerData[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer, "ShowPunList", "is", playerid, GetPlayerNameEx(targetid));
    return 1;
}

forward ShowPunList(playerid, username[]);
public ShowPunList(playerid, username[])
{
    new rows = cache_get_row_count(connectionID);
    if (rows == 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "%s doesn't have any punishment.", username);
    }
    new date[24], type[32], description[128];
    static details[4096], title[64];
    details = "Date\tType\tDescription";
    for (new i=0;i<rows;i++)
    {
        cache_get_field_content(i, "date", date);
        cache_get_field_content(i, "type", type);
        cache_get_field_content(i, "description", description);
        format(details, sizeof(details), "%s\n%s\t%s\t%s", details, date, type, description);
    }
    format(title, sizeof(title), "Punishment history of %s", username);
    ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, details, "Ok", "Cancel");
    return 1;
}

CMD:opunlist(playerid, params[])
{
    new username[MAX_PLAYER_NAME];
    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if (sscanf(params, "s[32]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /opunlist [username]");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT p.* FROM users_punishment as p, users as u"\
             " WHERE p.player_uid = u.uid and u.username='%e' ORDER BY date DESC", username);
    mysql_tquery(connectionID, queryBuffer, "ShowPunList", "is", playerid, username);
    return 1;
}

CMD:ganglogs(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendClientMessage(playerid, COLOR_GREY3, "You do not have permission to use this command.");
    }

    new gangid = PlayerData[playerid][pGang];
    if(gangid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a gang.");
    }

    if(strlen(params) < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /ganglogs [criteria (min 4 characters)]");
    }
    new query[512];
	mysql_format(connectionID, query, sizeof(query),
		"SELECT id, date, description FROM `log_gang` WHERE gang = %d AND description LIKE '%%%s%%' ORDER BY date DESC LIMIT 15",
		gangid, params
    );

    mysql_tquery(connectionID, query, "OnShowGangLogs", "i", playerid);
    return 1;
}

forward OnShowGangLogs(playerid);
public OnShowGangLogs(playerid)
{
    new rows = cache_get_row_count(connectionID);
    if(rows == 0)
        return SendClientMessage(playerid, COLOR_GREY, "No gang logs found.");

    new logDesc[1024], date[64], dialogText[4096];
    dialogText = "Date\tDescription";

    for(new i = 0; i < rows; i++)
    {
        cache_get_field_content(i, "description", logDesc);
        cache_get_field_content(i, "date", date);
        format(dialogText, sizeof(dialogText), "%s\n%s\t%s", dialogText, date, logDesc);
    }

    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "Gang Logs", dialogText, "Okay", "");
    return 1;
}

CMD:oadmins(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pAdminPersonnel] && !PlayerData[playerid][pHumanResources])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	mysql_tquery(connectionID, "SELECT username, lastlogin, adminlevel, adminname FROM "#TABLE_USERS" WHERE adminlevel > 0 ORDER BY adminlevel DESC", "OnQueryFinished", "ii", THREAD_LIST_ADMINS, playerid);
	return 1;
}

CMD:ovips(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	mysql_tquery(connectionID, "SELECT username, lastlogin, vippackage, viptime FROM "#TABLE_USERS" WHERE vippackage > 0 ORDER BY vippackage DESC", "OnQueryFinished", "ii", THREAD_LIST_VIPS, playerid);
	return 1;
}

CMD:sellinactive(playerid, params[])
{
	new houses, garages, businesses;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && HouseInfo[i][hOwnerID] > 0 && (gettime() - HouseInfo[i][hTimestamp]) > 2592000)
	    {
	        SetHouseOwner(i, INVALID_PLAYER_ID);
	        houses++;
	    }
	}

 	foreach(new i : Garage)
	{
	    if(GarageInfo[i][gExists] && GarageInfo[i][gOwnerID] > 0 && (gettime() - GarageInfo[i][gTimestamp]) > 2592000)
	    {
	        SetGarageOwner(i, INVALID_PLAYER_ID);
	        garages++;
	    }
	}

 	foreach(new i : Business)
	{
	    if(BusinessInfo[i][bExists] && BusinessInfo[i][bOwnerID] > 0 && (gettime() - BusinessInfo[i][bTimestamp]) > 2592000)
	    {
	        SetBusinessOwner(i, INVALID_PLAYER_ID);
	        businesses++;
	    }
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has sold all inactive properties.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_WHITE, "* You have sold %i inactive houses, %i inactive garages and %i inactive businesses.", houses, garages, businesses);
	return 1;
}

CMD:inactivecheck(playerid, params[])
{
    new houses, garages, businesses;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	foreach(new i : House) if(HouseInfo[i][hExists] && HouseInfo[i][hOwnerID] > 0 && (gettime() - HouseInfo[i][hTimestamp]) > 2592000)
		houses++;
	foreach(new i : Garage) if(GarageInfo[i][gExists] && GarageInfo[i][gOwnerID] > 0 && (gettime() - GarageInfo[i][gTimestamp]) > 2592000)
		garages++;
	foreach(new i : Business) if(BusinessInfo[i][bExists] && BusinessInfo[i][bOwnerID] > 0 && (gettime() - BusinessInfo[i][bTimestamp]) > 2592000)
		businesses++;

	SendClientMessageEx(playerid, COLOR_WHITE, "* There are currently %i inactive houses, %i inactive garages and %i inactive businesses.", houses, garages, businesses);
	return 1;
}
CMD:setmotd(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER && !PlayerData[playerid][pHelperManager] && PlayerData[playerid][pHelper] < 4)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	new option[8], newval[128];
	if(sscanf(params, "s[8]s[128]", option, newval))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /setmotd [admin/helper/global] [text ('none' to reset)]");
	}
	if(strfind(newval, "|") != -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You may not include the '|' character in the MOTD.");
	}
	if(!strcmp(option, "global", true))
	{
	    if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER) return SendClientErrorUnauthorizedCmd(playerid);
 		if(!strcmp(newval, "none", true))
		{
            SetServerMOTD("");
	    	SendClientMessage(playerid, COLOR_WHITE, "* You have reset the Global MOTD text.");
	    	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the global MOTD.", GetRPName(playerid));
		}
		else
		{
            SetServerMOTD(newval);
	    	SendClientMessageEx(playerid, COLOR_WHITE, "* You have changed the Global MOTD text to '%s'.", GetServerMOTD());
	    	SendAdminMessage(COLOR_YELLOW, "AdmCmd: %s has set the global MOTD to '%s'", GetRPName(playerid), GetServerMOTD());
		}
	}
	if(!strcmp(option, "admin", true))
	{
	    if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER) return SendClientErrorUnauthorizedCmd(playerid);
 		if(!strcmp(newval, "none", true))
		{
            SetAdminMOTD("");
	    	SendClientMessage(playerid, COLOR_WHITE, "* You have reset the Admin MOTD text.");
      		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the admin MOTD.", GetRPName(playerid));
		}
		else
		{
            SetAdminMOTD(newval);
	    	SendClientMessageEx(playerid, COLOR_WHITE, "* You have changed the Admin MOTD text to '%s'.", GetAdminMOTD());
	    	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the admin MOTD to '%s'", GetRPName(playerid), GetAdminMOTD());
		}
	}
	if(!strcmp(option, "helper", true))
	{
 		if(!strcmp(newval, "none", true))
		{
	    	SetHelperMOTD("");
	    	SendClientMessage(playerid, COLOR_WHITE, "* You have reset the Helper MOTD text.");
	    	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the helper MOTD.", GetRPName(playerid));
		}
		else
		{
	    	SetHelperMOTD(newval);
	    	SendClientMessageEx(playerid, COLOR_WHITE, "* You have changed the Helper MOTD text to '%s'.", GetHelperMOTD());
	    	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the helper MOTD to '%s'", GetRPName(playerid), GetHelperMOTD());
		}
	}
	return 1;
}


CMD:makeformeradmin(playerid, params[])
{
	new targetid, status;
	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "ui", targetid, status) || !(0 <= status <= 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /makeformeradmin [playerid] [status (0/1)]");
		return 1;
	}
    PlayerData[targetid][pFormerAdmin] = status;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET FormerAdmin = %i WHERE uid = %i", PlayerData[targetid][pFormerAdmin], PlayerData[targetid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    if(status)
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a Former Admin.", GetRPName(playerid), GetRPName(targetid));
        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a Former Admin.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}Former Admin{33CCFF}.", GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}Former Admin{33CCFF}.", GetRPName(playerid));
	}
	else
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's Former Admin status.", GetRPName(playerid), GetRPName(targetid));
        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) Former Admin status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}Former Admin{33CCFF} status.", GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}Former Admin{33CCFF} status.", GetRPName(playerid));
	}
	return 1;
}

CMD:setstaff(playerid, params[])
{
	new targetid, option[16], status;

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[16]i", targetid, option, status) || !(0 <= status <= 1))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setstaff [playerid] [option] [status (0/1)]");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: FactionMod, GangMod, BanAppealer, AdminPersonnel, PublicRelations, GameAffairs");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: DynamicAdmin, Scripter, ComplaintMod, HumanResources, BusinessMod");
		return 1;
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(PlayerData[targetid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Target player must be an administrator!");
	}
	if(!strcmp(option, "businessmod", true))
	{
	    PlayerData[targetid][pWebDev] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET webdev = %i WHERE uid = %i", PlayerData[targetid][pWebDev], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a business moderator.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a business moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}business moderator{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}business moderator{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's business moderator status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) business moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}business moderator{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}business moderator{33CCFF} status.", GetRPName(playerid));
		}
	}

	if(!strcmp(option, "factionmod", true))
	{
	    PlayerData[targetid][pFactionMod] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET factionmod = %i WHERE uid = %i", PlayerData[targetid][pFactionMod], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a faction moderator.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a faction moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}faction moderator{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}faction moderator{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's faction moderator status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) faction moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}faction moderator{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}faction moderator{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "gangmod", true))
	{
	    PlayerData[targetid][pGangMod] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gangmod = %i WHERE uid = %i", PlayerData[targetid][pGangMod], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a gang moderator.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a gang moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}gang moderator{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}gang moderator{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's gang moderator status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) gang moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}gang moderator{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}gang moderator{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "banappealer", true))
	{
	    PlayerData[targetid][pBanAppealer] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET banappealer = %i WHERE uid = %i", PlayerData[targetid][pBanAppealer], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a ban appealer.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a ban appealer.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}ban appealer{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}ban appealer{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's ban appealer status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) ban appealer status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}ban appealer{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}ban appealer{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "scripter", true))
	{
	    if(PlayerData[playerid][pAdmin] < MANAGEMENT) return SendClientMessage(playerid, COLOR_GREY, "You must be server management to set someone as a scripter.");
	    PlayerData[targetid][pDeveloper] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET scripter = %i WHERE uid = %i", PlayerData[targetid][pDeveloper], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a developer.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a developer.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}developer{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}developer{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's developer status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) developer status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}developer{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}developer{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "publicrelations", true))
	{
	    PlayerData[targetid][pHelperManager] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET helpermanager = %i WHERE uid = %i", PlayerData[targetid][pHelperManager], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a Public Relations.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a Public Relations.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}Public Relations{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}Public Relations{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's Public Relations status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) Public Relations status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}Public Relations{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}PR{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "dynamicadmin", true))
	{
	    PlayerData[targetid][pDynamicAdmin] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET dynamicadmin = %i WHERE uid = %i", PlayerData[targetid][pDynamicAdmin], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a dynamic admin.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a dynamic admin.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}dynamic admin{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}dynamic admin{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's dynamic admin status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) dynamic admin status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}dynamic admin{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}dynamic admin{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "adminpersonnel", true))
	{
	    if(PlayerData[playerid][pAdmin] < MANAGEMENT) return SendClientMessage(playerid, COLOR_GREY, "You must be server management to set someone as AP.");
	    PlayerData[targetid][pAdminPersonnel] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET adminpersonnel = %i WHERE uid = %i", PlayerData[targetid][pAdminPersonnel], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s admin personnel.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) admin perosnnel.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s {FF6347}admin personnel{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you {FF6347}admin personnel{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's admin personnel status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) admin personnel status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}admin personnel{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}admin personnel{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "gameaffairs", true))
	{
	    PlayerData[targetid][pGameAffairs] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gameaffairs = %i WHERE uid = %i", PlayerData[targetid][pGameAffairs], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a part of the department of game affairs.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a part of the department of game affairs.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a part of the department of {FF6347}game affairs{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a part of the department of{FF6347}game affairs{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's game affairs status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) game affairs status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}game affairs{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}game affairs{33CCFF} status.", GetRPName(playerid));
		}
	}
    else if(!strcmp(option, "humanresources", true))
	{
	    PlayerData[targetid][pHumanResources] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET humanresources = %i WHERE uid = %i", PlayerData[targetid][pHumanResources], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a part of the human resources.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a part of the human resources.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a part of the {FF6347}human resources{33CCFF}.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a part of the {FF6347}human resources{33CCFF}.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's human resources status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) human resources status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}human resources{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}human resources{33CCFF} status.", GetRPName(playerid));
		}
	}
	else if(!strcmp(option, "complaintmod", true))
	{
	    PlayerData[targetid][pComplaintMod] = status;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET complaintmod = %i WHERE uid = %i", PlayerData[targetid][pComplaintMod], PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    if(status)
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has made %s a complaint moderator status.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has made %s (uid: %i) a complaint moderator status.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a {FF6347}complaint moderator{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has made you a {FF6347}complaint moderator{33CCFF} status.", GetRPName(playerid));
		}
		else
	    {
	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed %s's complaint moderator.", GetRPName(playerid), GetRPName(targetid));
	        Log_Write("log_admin", "%s (uid: %i) has removed %s's (uid: %i) complaint moderator.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's {FF6347}complaint moderator{33CCFF} status.", GetRPName(targetid));
		    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed your {FF6347}complaint moderator{33CCFF} status.", GetRPName(playerid));
		}
	}

	return 1;
}

CMD:renamecmd(playerid, params[])
{
    new cmd[64], newcmd[64];
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(sscanf(params, "s[64]s[64]", cmd, newcmd))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /renamecmd [old] [new] (64 chars)");
	}
	if(PC_CommandExists(cmd))
	{
	 	PC_RenameCommand(cmd, newcmd);
	 	SendClientMessageEx(playerid, COLOR_AQUA, "You've renamed command %s to %s.", cmd, newcmd);
	 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s renamed /%s to /%s", GetRPName(playerid), cmd, newcmd);
	}
	return 1;
}

CMD:createalias(playerid, params[])
{
	new cmd[64], alias[64];
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(sscanf(params, "s[64]s[64]", cmd, alias))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createalias [cmd] [newcmd] (64 chars)");
	}
	if(PC_CommandExists(cmd))
	{
     	PC_RegAlias(cmd, alias);
     	SendClientMessageEx(playerid, COLOR_AQUA, "You've created alias %s for %s.", alias, cmd);
	 	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s created a alias for /%s (/%s)", GetRPName(playerid), cmd, alias);
	}
	return 1;
}
CMD:deletecmd(playerid, params[])
{
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	return SendClientMessage(playerid, 0xAFAFAFAA, "This command was disabled.");

	// new oldcmd[64], confirm[64];
    // if(sscanf(params, "s[64]s[64]", oldcmd, confirm) || strcmp(confirm, "confirm", true))
    // {
    //     return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deletecmd [name] [confirm]");
	// }
	// if(PC_CommandExists(oldcmd))
	// {
	// 	PC_DeleteCommand(oldcmd);
	// }
	// return 1;
}

CMD:updates(playerid,params[])
{
	mysql_tquery(connectionID, "SELECT * FROM changes ORDER BY slot", "OnQueryFinished", "ii", THREAD_LIST_CHANGES, playerid);
	return 1;
}

CMD:changelist(playerid, params[])
{
	new slot, option[10], param[64];

    if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER && !PlayerData[playerid][pDeveloper])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[10]S()[64]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changelist [view | edit | clear]");
	}
	if(!strcmp(option, "view", true))
	{
	    mysql_tquery(connectionID, "SELECT * FROM changes ORDER BY slot", "OnQueryFinished", "ii", THREAD_LIST_CHANGES, playerid);
	}
	else if(!strcmp(option, "edit", true))
	{
	    if(sscanf(param, "is[64]", slot, param))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changelist [edit] [slot (1-10)] [text]");
		}
		if(!(1 <= slot <= 10))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO changes VALUES(%i, '%e') ON DUPLICATE KEY UPDATE text = '%e'", slot, param, param);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* Change text for slot %i changed to '%s'.", slot, param);
	}
	else if(!strcmp(option, "clear", true))
	{
	    if(sscanf(param, "i", slot))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changelist [clear] [slot (1-10)]");
		}
		if(!(1 <= slot <= 10))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM changes WHERE slot = %i", slot);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* Change text for slot %i cleared.", slot);
	}

	return 1;
}

CMD:forceaduty(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER && !PlayerData[playerid][pAdminPersonnel])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forceaduty [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] < LEVEL_TRIAL_ADMIN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player needs to be at least a level 2 administrator.");
	}
	if(PlayerData[targetid][pAdmin] > PlayerData[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified has a higher admin level than you. They cannot be forced into admin duty.");
	}

	if(!PlayerData[targetid][pAdminDuty])
	{
		SendClientMessageEx(targetid, COLOR_WHITE, "%s has forced you to be on admin duty.", GetRPName(playerid));
	}
	else
	{
	    SendClientMessageEx(targetid, COLOR_WHITE, "%s has forced you to be off admin duty.", GetRPName(playerid));
	}

	callcmd::aduty(targetid, "\1");
	return 1;
}

CMD:listhelp(playerid, params[])
{
    if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Help Requests _____");

	foreach(new i : Player)
	{
	    if(!isnull(PlayerData[i][pHelpRequest]))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* %s[%i] asks: %s", GetRPName(i), i, PlayerData[i][pHelpRequest]);
		}
	}

	SendClientMessage(playerid, COLOR_AQUA, "* Use /accepthelp [id] or /denyhelp [id] to handle help requests.");
	SendClientMessage(playerid, COLOR_AQUA, "* Use /answerhelp [id] [msg] to PM an answer without the need to teleport.");
	return 1;
}

CMD:ac(playerid, params[]) return callcmd::accepthelp(playerid, params);
CMD:accepthelp(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to leave the paintball arena first.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /accepthelp [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(isnull(PlayerData[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
	}


	if(!PlayerData[playerid][pAcceptedHelp])
	{
		SavePlayerVariables(playerid);
	}

	TeleportToPlayer(playerid, targetid, false);
	SetPlayerSkin(playerid, HELPER_SKIN);

	TogglePlayerControllableEx(targetid, 0);
	SetTimerEx("UnfreezeNewbie", 5000, false, "i", targetid);

	SetPlayerHealth(playerid, 32767);
	//SetScriptArmour(playerid, 0.0);

	PlayerData[playerid][pHelpRequests]++;
	PlayerData[playerid][pAcceptedHelp] = 1;
	PlayerData[targetid][pHelpRequest][0] = 0;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET helprequests = %i WHERE uid = %i", PlayerData[playerid][pHelpRequests], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has accepted %s's help request.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(playerid, COLOR_WHITE, "You accepted %s's help request and were sent to their position. /return to go back.", GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_GREEN, "%s has accepted your help request. They are now assisting you.", GetRPName(playerid));
	return 1;
}

CMD:denyhelp(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /denyhelp [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(isnull(PlayerData[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
	}

	PlayerData[targetid][pHelpRequest][0] = 0;

    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has denied %s's help request.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(playerid, COLOR_WHITE, "You denied %s's help request.", GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_LIGHTRED, "* %s has denied your help request.", GetRPName(playerid));
	return 1;
}

CMD:sta(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sta [playerid] (Sends /helpme to admins)");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(isnull(PlayerData[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
	}

    AddReportToQueue(targetid, PlayerData[targetid][pHelpRequest]);
    PlayerData[targetid][pHelpRequest][0] = 0;

    SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has sent %s's help request to all online admins.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(playerid, COLOR_WHITE, "You sent %s's help request to all online admins.", GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has sent your help request to all online admins.", GetRPName(playerid));
	return 1;
}

static HelperCar[MAX_PLAYERS];

stock GivePlayerAdminVehicle(playerid, modelid, color1=1, color2=1)
{
    new Float:x, Float:y, Float:z, Float:a, vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, -1);

    if (!IsValidVehicle(vehicleid))
    {
        return INVALID_VEHICLE_ID;
    }

    ResetVehicleObjects(vehicleid);

    adminVehicle[vehicleid] = true;
    RefuelVehicle(vehicleid);
    vehicleColors[vehicleid][0] = color1;
    vehicleColors[vehicleid][1] = color2;

    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleHealth(vehicleid, 1000.0);

    PutPlayerInVehicle(playerid, vehicleid, 0);
    return vehicleid;
}

hook OnPlayerConnect(playerid)
{
    HelperCar[playerid] = INVALID_VEHICLE_ID;
}

hook OnVehicleDeath(vehicleid, killerid)
{
    foreach(new playerid : Player)
    {
        if (HelperCar[playerid] != INVALID_VEHICLE_ID && HelperCar[playerid] == vehicleid)
        {
            HelperCar[playerid] = INVALID_VEHICLE_ID;
        }
    }
}

CMD:hcar(playerid, params[])
{
    new modelid, color1, color2, Float:x, Float:y, Float:z, Float:a, vehicleid;

	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if (!PlayerData[playerid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't accepted any help requests to spawn a vehicle.");
    }
    if(sscanf(params, "I(-1)I(-1)", color1, color2))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hcar [color1 (optional)] [color2 (optional)]");
    }

    // Force vehicle ID 405 only
    modelid = 405; // Sentinel

    if(!(-1 <= color1 <= 255) || !(-1 <= color2 <= 255))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid color. Valid colors range from -1 to 255.");
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, -1);

    if(vehicleid == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Cannot spawn vehicle. The vehicle pool is currently full.");
    }

    ResetVehicleObjects(vehicleid);

    adminVehicle{vehicleid} = true;
    RefuelVehicle(vehicleid);
    vehicleColors[vehicleid][0] = color1;
    vehicleColors[vehicleid][1] = color2;

    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    PutPlayerInVehicle(playerid, vehicleid, 0);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s spawned a helper vehicle (405).", GetRPName(playerid));
    return 1;
}

CMD:hlock(playerid, params[])
{
    if (!PlayerData[playerid][pHelper])
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if (!PlayerData[playerid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to accept a help to use this command");
    }

    new vehicleid = HelperCar[playerid];
    if (vehicleid != INVALID_VEHICLE_ID)
    {
        if (!VehicleInfo[vehicleid][vLocked])
        {
            VehicleInfo[vehicleid][vLocked] = 1;
            GameTextForPlayer(playerid, "~r~Vehicle locked", 3000, 6);
        }
        else
        {
            VehicleInfo[vehicleid][vLocked] = 0;
            GameTextForPlayer(playerid, "~g~Vehicle unlocked", 3000, 6);
        }

        SetVehicleParams(vehicleid, VEHICLE_DOORS, VehicleInfo[vehicleid][vLocked]);
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
    }
    return 1;
}

CMD:return(playerid, params[])
{
	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if (!PlayerData[playerid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't accepted any help requests.");
    }

    if (HelperCar[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicleEx(HelperCar[playerid]);
        HelperCar[playerid] = INVALID_VEHICLE_ID;
    }

    SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
    SetScriptArmour(playerid, PlayerData[playerid][pArmor]);

    SetFreezePos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
    SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
    SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
    SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
    SetCameraBehindPlayer(playerid);

    SendClientMessage(playerid, COLOR_WHITE, "You were returned to your previous position.");
    PlayerData[playerid][pAcceptedHelp] = 0;
    return 1;
}

CMD:answerhelp(playerid, params[])
{
	new targetid, msg[128];

	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[128]", targetid, msg))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /answerhelp [playerid] [message]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(isnull(PlayerData[targetid][pHelpRequest]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested any help since they connected.");
	}

	PlayerData[playerid][pHelpRequests]++;
	PlayerData[targetid][pHelpRequest][0] = 0;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET helprequests = %i WHERE uid = %i", PlayerData[playerid][pHelpRequests], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(strlen(msg) > MAX_SPLIT_LENGTH)
	{
		SendClientMessageEx(targetid, COLOR_YELLOW, "* Answer from %s: %.*s... *", GetRPName(playerid), MAX_SPLIT_LENGTH, msg);
		SendClientMessageEx(targetid, COLOR_YELLOW, "* Answer from %s: ...%s *", GetRPName(playerid), msg[MAX_SPLIT_LENGTH]);
	}
	else
	{
	    SendClientMessageEx(targetid, COLOR_YELLOW, "* Answer from %s: %s *", GetRPName(playerid), msg);
	}

	SendHelperMessage(COLOR_LIGHTRED, "Helper: %s has answered %s's help request.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:hh(playerid, params[])
{
	return callcmd::helperhelp(playerid, params);
}

CMD:hhelp(playerid, params[])
{
	return callcmd::helperhelp(playerid, params);
}

CMD:helperhelp(playerid, params[])
{
	if(PlayerData[playerid][pHelper] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(PlayerData[playerid][pHelper] >= 1)
	{
		SendClientMessage(playerid, COLOR_AQUA, "LEVEL 1:{DDDDDD} /hc, /listhelp, /accepthelp, /answerhelp, /denyhelp, /sta, /return.");
	}
    if(PlayerData[playerid][pHelper] >= 2)
	{
		SendClientMessage(playerid, COLOR_AQUA, "LEVEL 2:{DDDDDD} /nmute, /hmute, /gmute, /admute");
	}
    if(PlayerData[playerid][pHelper] >= 3)
	{
		SendClientMessage(playerid, COLOR_AQUA, "LEVEL 3:{DDDDDD} /olisthelpers, /checknewbie.");
	}
	if(PlayerData[playerid][pHelper] >= 4)
	{
		SendClientMessage(playerid, COLOR_AQUA, "LEVEL 4:{DDDDDD} /setmotd.");
	}

	return 1;
}

CMD:mark(playerid, params[])
{
	new slot;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", slot))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /mark [slot (1-3)]");
	}
	if(!(1 <= slot <= 3))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
	}

	slot--;

	GetPlayerPos(playerid, MarkedPositions[playerid][slot][mPosX], MarkedPositions[playerid][slot][mPosY], MarkedPositions[playerid][slot][mPosZ]);
	GetPlayerFacingAngle(playerid, MarkedPositions[playerid][slot][mPosA]);

	MarkedPositions[playerid][slot][mInterior] = GetPlayerInterior(playerid);
	MarkedPositions[playerid][slot][mWorld] = GetPlayerVirtualWorld(playerid);

	SendClientMessageEx(playerid, COLOR_AQUA, "* Position saved in slot %i.", slot + 1);
	return 1;
}

CMD:gotomark(playerid, params[])
{
	new slot;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", slot))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotomark [slot (1-3)]");
	}
	if(!(1 <= slot <= 3))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
	}
	if(MarkedPositions[playerid][slot-1][mPosX] == 0.0 && MarkedPositions[playerid][slot-1][mPosY] == 0.0 && MarkedPositions[playerid][slot-1][mPosZ] == 0.0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no position in the slot selected.");
	}

	slot--;

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, MarkedPositions[playerid][slot][mPosX], MarkedPositions[playerid][slot][mPosY], MarkedPositions[playerid][slot][mPosZ]);
	SetPlayerFacingAngle(playerid, MarkedPositions[playerid][slot][mPosA]);
	SetPlayerInterior(playerid, MarkedPositions[playerid][slot][mInterior]);
	SetPlayerVirtualWorld(playerid, MarkedPositions[playerid][slot][mWorld]);
	SetCameraBehindPlayer(playerid);

	return 1;
}

CMD:angle(playerid, params[])
{
	new Float:a;
	GetPlayerFacingAngle(playerid, a);
	SendClientMessageEx(playerid, COLOR_WHITE, "Your facing angle is {00aa00}%f.", a);
	return 1;
}

CMD:skills(playerid, params[])
{
    return callcmd::skill(playerid, params);
}

CMD:skill(playerid, params[])
{
	ShowSkillsDialog(playerid);
    return 1;
}
CMD:skillss(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skill [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Courier, Fishing, Bodyguard, ArmsDealer, Mechanic, DrugSmuggler, Lawyer, Detective, Thief");
	    return 1;
	}
	if(!strcmp(params, "fishing", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREEN, "Your fishing skill level is %i/5.", GetJobLevel(playerid, JOB_FISHERMAN));

	    if(GetJobLevel(playerid, JOB_FISHERMAN) < 5)
	    {
	        if(PlayerData[playerid][pFishingSkill] < 50) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 50 - PlayerData[playerid][pFishingSkill]);
	        } else if(PlayerData[playerid][pFishingSkill] < 100) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 100 - PlayerData[playerid][pFishingSkill]);
	        } else if(PlayerData[playerid][pFishingSkill] < 200) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 200 - PlayerData[playerid][pFishingSkill]);
            } else if(PlayerData[playerid][pFishingSkill] < 350) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 350 - PlayerData[playerid][pFishingSkill]);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
		}
	}
	else if(!strcmp(params, "armsdealer", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREEN, "Your weapons dealer skill level is %i/5.", GetJobLevel(playerid, JOB_ARMSDEALER));

	    if(GetJobLevel(playerid, JOB_ARMSDEALER) < 5)
	    {
	        if(PlayerData[playerid][pWeaponSkill] < 50) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 50 - PlayerData[playerid][pWeaponSkill]);
	        } else if(PlayerData[playerid][pWeaponSkill] < 100) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 100 - PlayerData[playerid][pWeaponSkill]);
	        } else if(PlayerData[playerid][pWeaponSkill] < 200) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 200 - PlayerData[playerid][pWeaponSkill]);
            } else if(PlayerData[playerid][pWeaponSkill] < 500) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 500 - PlayerData[playerid][pWeaponSkill]);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
		}
	}
	else if(!strcmp(params, "mechanic", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREEN, "Your mechanic skill level is %i/5.", GetJobLevel(playerid, JOB_MECHANIC));

	    if(GetJobLevel(playerid, JOB_MECHANIC) < 5)
	    {
	        if(PlayerData[playerid][pMechanicSkill] < 25) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 25 - PlayerData[playerid][pMechanicSkill]);
	        } else if(PlayerData[playerid][pMechanicSkill] < 50) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 50 - PlayerData[playerid][pMechanicSkill]);
	        } else if(PlayerData[playerid][pMechanicSkill] < 100) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 100 - PlayerData[playerid][pMechanicSkill]);
            } else if(PlayerData[playerid][pMechanicSkill] < 200) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 200 - PlayerData[playerid][pMechanicSkill]);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
		}
	}
	else if(!strcmp(params, "drugsmuggler", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREEN, "Your drug smuggler skill level is %i/5.", GetJobLevel(playerid, JOB_DRUGDEALER));

	    if(GetJobLevel(playerid, JOB_DRUGDEALER) < 5)
	    {
	        if(PlayerData[playerid][pSmugglerSkill] < 25) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 25 - PlayerData[playerid][pSmugglerSkill]);
	        } else if(PlayerData[playerid][pSmugglerSkill] < 50) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 50 - PlayerData[playerid][pSmugglerSkill]);
	        } else if(PlayerData[playerid][pSmugglerSkill] < 75) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 75 - PlayerData[playerid][pSmugglerSkill]);
            } else if(PlayerData[playerid][pSmugglerSkill] < 100) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 100 - PlayerData[playerid][pSmugglerSkill]);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
		}
	}
	else if(!strcmp(params, "lawyer", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREEN, "Your lawyer skill level is %i/5.", GetJobLevel(playerid, JOB_LAWYER));

	    if(GetJobLevel(playerid, JOB_LAWYER) < 5)
	    {
	        if(PlayerData[playerid][pLawyerSkill] < 25) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 25 - PlayerData[playerid][pLawyerSkill]);
	        } else if(PlayerData[playerid][pLawyerSkill] < 50) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 50 - PlayerData[playerid][pLawyerSkill]);
	        } else if(PlayerData[playerid][pLawyerSkill] < 100) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 100 - PlayerData[playerid][pLawyerSkill]);
            } else if(PlayerData[playerid][pLawyerSkill] < 200) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 200 - PlayerData[playerid][pLawyerSkill]);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
		}
	}
	else if(!strcmp(params, "detective", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREEN, "Your detective skill level is %i/5.", GetJobLevel(playerid, JOB_DETECTIVE));

	    if(GetJobLevel(playerid, JOB_DETECTIVE) < 5)
	    {
	        if(PlayerData[playerid][pDetectiveSkill] < 50) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 50 - PlayerData[playerid][pDetectiveSkill]);
	        } else if(PlayerData[playerid][pDetectiveSkill] < 100) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 100 - PlayerData[playerid][pDetectiveSkill]);
	        } else if(PlayerData[playerid][pDetectiveSkill] < 200) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 200 - PlayerData[playerid][pDetectiveSkill]);
            } else if(PlayerData[playerid][pDetectiveSkill] < 400) {
	        	SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 400 - PlayerData[playerid][pDetectiveSkill]);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skill [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Fishing, Bodyguard, ArmsDealer, Mechanic, DrugSmuggler, Lawyer, Detective");
	}

	return 1;
}
CMD:fish(playerid, params[])
{
	/*if(!PlayerHasJob(playerid, JOB_FISHERMAN))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
	}*/
	if(!PlayerData[playerid][pFishingRod])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a fishing rod. You need a fishing rod to fish!");
	}
	if(PlayerData[playerid][pFishTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are fishing already. Wait for your line to be reeled in first.");
	}
	if(PlayerData[playerid][pFishWeight] >= 1500)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have too much Anchovy and can't fish any longer.");
	}
	if(IsABoat(GetPlayerVehicleID(playerid)))
	{
	    //return SendClientMessage(playerid, COLOR_GREY, "You are not close to anywhere where you can fish.");
	}
	else if(!IsPlayerAtFishingPlace(playerid) && GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
	}

	ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 0, 0, 0, 1, 0, 1);

	SetPlayerAttachedObject(playerid, 9, 18632, 6, 0.112999, 0.024000, 0.000000, -172.999954, 28.499994, 0.000000);
	ShowActionBubble(playerid, "* %s reels the line of their fishing rod into the water.", GetRPName(playerid));
	PlayerData[playerid][pFishTime] = 6;

	if(PlayerData[playerid][pFishingBait] > 0)
	{
	    PlayerData[playerid][pFishingBait]--;
	    PlayerData[playerid][pUsedBait] = 1;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fishingbait = fishingbait - 1 WHERE uid = %i", PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		//SendClientMessage(playerid, COLOR_AQUA, "* You used one fish bait. Your odds of catching a bigger fish are increased!");
	}
	else
	{
	    PlayerData[playerid][pUsedBait] = 0;
	}

	return 1;
}


CMD:sellfish(playerid, params[])
{
	new businessid;

	/*if(!PlayerHasJob(playerid, JOB_FISHERMAN))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Fisherman.");
	}*/
	if((businessid = GetInsideBusiness(playerid)) == -1 || BusinessInfo[businessid][bType] != BUSINESS_STORE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any Supermarket business.");
	}
	if(!PlayerData[playerid][pFishWeight])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no Anchovy which you can sell.");
	}

	new amount = (PlayerData[playerid][pFishWeight] * 1) + random(300)+50;

    if(PlayerData[playerid][pLaborUpgrade] > 0)
	{
		amount += percent(amount, PlayerData[playerid][pLaborUpgrade]);
	}

	SendClientMessageEx(playerid, COLOR_AQUA, "* You earned {00AA00}$%i{33CCFF} for selling %i g of Anchovy.", amount, PlayerData[playerid][pFishWeight]);
	GivePlayerCash(playerid, amount);
    GivePlayerRankPointLegalJob(playerid, amount / 100);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET fishweight = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	PlayerData[playerid][pFishWeight] = 0;
	return 1;
}

CMD:myfish(playerid, params[])
{
	SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ My Fish _______");
	SendClientMessageEx(playerid, COLOR_GREY2, "* %i/1500 g of anchovy", PlayerData[playerid][pFishWeight]);
	if(PlayerHasJob(playerid, JOB_FISHERMAN))
	{
		SendClientMessageEx(playerid, COLOR_AQUA, "- %i Dolphin(s) weighing %i kg.", PlayerData[playerid][pDolphinCount], PlayerData[playerid][pDolphinWeight]);
		SendClientMessageEx(playerid, COLOR_AQUA, "- %i Shark(s) weighing %i kg.", PlayerData[playerid][pSharkCount], PlayerData[playerid][pSharkWeight]);
		SendClientMessageEx(playerid, COLOR_AQUA, "- %i Crab(s) weighing %i kg.", PlayerData[playerid][pCrabCount], PlayerData[playerid][pCrabWeight]);		
		SendClientMessageEx(playerid, COLOR_GREY, "You can hold up to %i kg of fish in your boat.", PlayerData[playerid][pNetSize]);
	}

	return 1;
}

//	CMD:sellvest(playerid, params[])
//	{
//		new targetid, amount;
//	
//		if(true)
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Bodyguard.");
//		}
//		if(sscanf(params, "ui", targetid, amount))
//		{
//		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellvest [playerid] [amount]");
//		}
//		if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
//		}
//		if(targetid == playerid)
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
//		}
//		if(amount < 500 || amount > 2500)
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "The amount specified must range between $500 and $2500.");
//		}
//		if(gettime() - PlayerData[playerid][pLastSell] < 10)
//		{
//		    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
//		}
//		if(GetPlayerArmourEx(targetid) >= 50.0)
//		{
//		    return SendClientMessage(playerid, COLOR_GREY, "That player already has a vest.");
//		}
//	
//		PlayerData[playerid][pLastSell] = gettime();
//		PlayerData[targetid][pVestOffer] = playerid;
//		PlayerData[targetid][pVestPrice] = amount;
//	
//		SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you a vest with %.1f points of armor for %s (/accept vest).", GetRPName(playerid), 50.0, FormatCash(amount));
//		SendClientMessageEx(playerid, COLOR_AQUA, "* You offered %s a vest with %.1f points of armor for %s.", GetRPName(targetid), 50.0, FormatCash(amount));
//		return 1;
//	}

CMD:smugglemats(playerid, params[])
{
    if(!PlayerHasJob(playerid, JOB_ARMSDEALER) && !PlayerHasJob(playerid, JOB_CRAFTMAN))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a craft man or arms Dealer.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1423.4292,-1319.1487,13.5547) && !IsPlayerInRangeOfPoint(playerid, 3.0, 2393.4885, -2008.5726, 13.3467) && !IsPlayerInRangeOfPoint(playerid, 20.0, 714.5344, -1565.1694, 1.7680) && !IsPlayerInRangeOfPoint(playerid, 20.0, 2112.3240,-2432.8130,13.5469))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any materials pickup.");
	}
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
	}
	if(PlayerData[playerid][pCash] < 50)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need at least $50 in cash to smuggle materials.");
	}
    if(PlayerData[playerid][pMaterials] + 250 > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
	}

	PlayerData[playerid][pCP] = CHECKPOINT_MATS;
	PlayerData[playerid][pSmuggleTime] = gettime();

	GivePlayerCash(playerid, -50);
	SendClientMessage(playerid, COLOR_AQUA, "* You paid $50 for a load of materials. Smuggle them to the depot to get materials.");

	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1421.6913, -1318.4719, 13.5547))
	{
		SetPlayerCheckpoint(playerid, 2173.2129, -2264.1548, 13.3467, 3.0);
		PlayerData[playerid][pSmuggleMats] = 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 2393.4885, -2008.5726, 13.3467))
	{
		SetPlayerCheckpoint(playerid, 2288.0918, -1105.6555, 37.9766, 3.0);
		PlayerData[playerid][pSmuggleMats] = 2;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 20.0, 714.5344, -1565.1694, 1.76807))
	{
		SetPlayerCheckpoint(playerid, 29.0318,-1399.3555,1.7680, 20.0);
		PlayerData[playerid][pSmuggleMats] = 3;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 20.0, 2112.3240, -2432.8130, 13.5469))
	{
		// get random checkpoint
		new rand = random(5);
		switch(rand)
		{
		    case 0: { SetPlayerCheckpoint(playerid, -1368.1206,-203.7393,14.1484, 30.0); }
		    case 1: { SetPlayerCheckpoint(playerid, 310.8307,2033.6459,17.6406, 30.0); }
		    case 2: { SetPlayerCheckpoint(playerid, 401.2192,2502.6482,16.4844, 30.0); }
		    case 3: { SetPlayerCheckpoint(playerid, 1582.8756,1356.8186,10.8556, 30.0); }
		    case 4: { SetPlayerCheckpoint(playerid, 1574.8552,1505.5690,10.8361, 30.0); }
		}
		PlayerData[playerid][pSmuggleMats] = 4;
	}

	return 1;
}

CMD:getmats(playerid, params[])
{
	return callcmd::smugglemats(playerid, params);
}

enum eCraftWeaponArgs
{
	cwa_Level,
	cwa_Name[10],
	cwa_WeaponID
};

CMD:sellgun(playerid, params[])
{
	new targetid, weapon[10], price;

    if(!PlayerHasJob(playerid, JOB_ARMSDEALER) && PlayerData[playerid][pDonator] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Arms Dealer.");
	}
	if(PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons from within a vehicle.");
	}
	if(sscanf(params, "us[10]I(0)", targetid, weapon, price))
	{
		SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ Weapons Crafting _______");

		if(GetJobLevel(playerid, JOB_ARMSDEALER) >= 1)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "Level 1: Bat [2000], Shovel [200], Dildo [50], Flowers [50], Cane [200]");
			SendClientMessage(playerid, COLOR_WHITE, "Level 1: 9mm [2000], Sdpistol [3000], Shotgun [3000]");
			if(GetJobLevel(playerid, JOB_ARMSDEALER) >= 2)
			{
				SendClientMessage(playerid, COLOR_WHITE, "Level 2: Uzi [3500], Rifle [12000]");
				if(GetJobLevel(playerid, JOB_ARMSDEALER) >= 3)
				{
					SendClientMessage(playerid, COLOR_WHITE, "Level 3: PoolCue [200], AK-47 [10000], Tec-9 [4500], Deagle [6000]");
					if(GetJobLevel(playerid, JOB_ARMSDEALER) >= 4)
					{
						SendClientMessage(playerid, COLOR_WHITE, "Level 4: GolfClub [200], MP5 [5000], M4 [15000]");
					} 
				}
			}
		}
		if(GetJobLevel(playerid, JOB_ARMSDEALER) >= 5 || PlayerData[playerid][pDonator] >= 3) 
		{
			if(PlayerData[playerid][pDonator] >= 3)
			{
				SendClientMessage(playerid, COLOR_VIP, "(VIP){FFFFFF} Level 5: Katana [15000], Spas12 [12000], Sniper [18000]");
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "Level 5: Katana [15000], Sniper [20000]");
			}
		}
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellgun [playerid] [name] [price]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
	if(gettime() - PlayerData[playerid][pLastSell] < 10)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
	}
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use this command at the moment.");
	}
	if(price < 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
	}

	static weaponargs[][eCraftWeaponArgs] = {
		{/*Level*/ 1, "Bat", 		 5},
		{/*Level*/ 1, "Shovel", 	 6},
		{/*Level*/ 1, "Dildo", 		10},
		{/*Level*/ 1, "Flowers", 	14},
		{/*Level*/ 1, "Cane", 		15},
		{/*Level*/ 1, "9mm", 		22},
		{/*Level*/ 1, "Sdpistol", 	23},
		{/*Level*/ 1, "Shotgun", 	25},
		
		{/*Level*/ 2, "Uzi", 		28},
		{/*Level*/ 2, "Rifle",	 	33},

		{/*Level*/ 3, "PoolCue", 	 7},
		{/*Level*/ 3, "AK-47", 		30},
		{/*Level*/ 3, "Tec-9",	 	32},
		
		{/*Level*/ 3, "Deagle",	 	24},
		{/*Level*/ 4, "GolfClub", 	 2},
		{/*Level*/ 4, "MP5",	 	29},
		{/*Level*/ 4, "M4",	 		31},

		{/*Level*/ 5, "Katana", 	 8},
		{/*Level*/ 5, "Spas12",	 	27},
		{/*Level*/ 5, "Sniper",		34}
	};

	for(new i=0;i<sizeof(weaponargs);i++)
	{
		if(!strcmp(weapon, weaponargs[i][cwa_Name], true))
		{
			if(GetJobLevel(playerid, JOB_ARMSDEALER) < weaponargs[i][cwa_Level])
			{
				return SendClientMessage(playerid, COLOR_GREY, "Your skill level is not high enough to craft this weapon.");
			}
			new weaponid = weaponargs[i][cwa_WeaponID];
			new cost = GetCraftWeaponPrice(playerid, weaponid);
			if(IsMafiaWeapon(weaponid) && PlayerData[playerid][pDonator] != 3)
			{
				if(PlayerData[playerid][pGang] == -1 || !GangInfo[PlayerData[playerid][pGang]][gIsMafia])
				{
					return SendClientMessage(playerid, COLOR_GREY, "Only mafia can craft this weapons.");
				}
			}
			if(PlayerData[playerid][pMaterials] < cost)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You don't have enough materials to craft this weapon.");
			}
			if(PlayerHasWeapon(targetid, weaponid))
			{
				return SendClientMessage(playerid, COLOR_GREY, "That player has this weapon already.");
			}

			if(targetid == playerid)
			{
				SellWeapon(playerid, targetid, weaponid);
			}
			else if(price < 1)
			{
				return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
			}
			else
			{
				PlayerData[playerid][pLastSell] = gettime();
				PlayerData[targetid][pSellOffer] = playerid;
				PlayerData[targetid][pSellType] = ITEM_SELLGUN;
				PlayerData[targetid][pSellExtra] = weaponid;
				PlayerData[targetid][pSellPrice] = price;

				SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you a %s for $%i. (/accept weapon)", GetRPName(playerid), GetWeaponNameEx(weaponid), price);
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s a %s for $%i.", GetRPName(targetid), GetWeaponNameEx(weaponid), price);
			}
		}
	}
    
    if(PlayerData[playerid][pGang] == -1 && GetPlayerFaction(playerid) != FACTION_HITMAN && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        GivePlayerRankPoints(playerid, -20);
    }
    else 
    {
        GivePlayerRankPoints(playerid, 20);
    }
	return 1;
}


CMD:repair(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:health;

	if(!PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must either be a mechanic, or a Legendary VIP to use this command.");
	}
	if(GetInsideGarage(playerid) >= 0)
	{
	    if(gettime() - PlayerData[playerid][pLastRepair] < 120 - 12 * GetJobLevel(playerid, JOB_MECHANIC) )
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", (120 - 12 * GetJobLevel(playerid, JOB_MECHANIC)) - (gettime() - PlayerData[playerid][pLastRepair]));
		}
		if(!vehicleid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
		}
		if(!IsEngineVehicle(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be repaired.");
		}

		GetVehicleHealth(vehicleid, health);

		if(health >= 1000.0)
		{
		    SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't need to be repaired.");
		}
		else
		{
			PlayerData[playerid][pLastRepair] = gettime();
			SetVehicleHealth(vehicleid, 1000.0);
            if(PlayerHasJob(playerid, JOB_MECHANIC))
            {
                GivePlayerRankPointLegalJob(playerid, 20);
            }
			ShowActionBubble(playerid, "* %s repairs the vehicle.", GetRPName(playerid));
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		}
	}
    else if(PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] < 3)
	{
		if(PlayerData[playerid][pDonator] < 3 && PlayerData[playerid][pComponents] <= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
		}
		if(gettime() - PlayerData[playerid][pLastRepair] < 20)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerData[playerid][pLastRepair]));
		}
		if(!vehicleid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
		}
		if(!IsEngineVehicle(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be repaired.");
		}

		GetVehicleHealth(vehicleid, health);

		if(health >= 1000.0)
		{
		    SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't need to be repaired.");
		}
		else
		{
			PlayerData[playerid][pComponents]--;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);
  			mysql_tquery(connectionID, queryBuffer);

			PlayerData[playerid][pLastRepair] = gettime();
			SetVehicleHealth(vehicleid, 1000.0);

			if(GetJobLevel(playerid, JOB_MECHANIC) == 5)
			{
			    RepairVehicle(vehicleid);
			    SendClientMessage(playerid, COLOR_WHITE, "You have repaired the health and bodywork on this vehicle..");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WHITE, "You have repaired this vehicle to maximum health.");
			}

            if(PlayerHasJob(playerid, JOB_MECHANIC))
            {
                GivePlayerRankPointLegalJob(playerid, 20);
            }
			ShowActionBubble(playerid, "* %s repairs the vehicle.", GetRPName(playerid));

			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			IncreaseJobSkill(playerid, JOB_MECHANIC);
		}
	}
 	else if(PlayerData[playerid][pDonator] == 3)
	{
		if(PlayerData[playerid][pDonator] < 3 && !PlayerData[playerid][pComponents])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
		}
		if(gettime() - PlayerData[playerid][pLastRepair] < 20)
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerData[playerid][pLastRepair]));
		}
		if(!vehicleid)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
		}
		if(!IsEngineVehicle(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be repaired.");
		}

		GetVehicleHealth(vehicleid, health);

		if(health >= 1000.0)
		{
		    SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't need to be repaired.");
		}
		else
		{
 			SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You repaired this vehicle free of charge.");

			PlayerData[playerid][pLastRepair] = gettime();

			SetVehicleHealth(vehicleid, 1000.0);
            
            if(PlayerHasJob(playerid, JOB_MECHANIC))
            {
                GivePlayerRankPointLegalJob(playerid, 20);
            }
			ShowActionBubble(playerid, "* %s repairs the vehicle.", GetRPName(playerid));

			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
   			IncreaseJobSkill(playerid, JOB_MECHANIC);
		}
	}
	return 1;
}

CMD:nos(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(!PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] != 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic.");
	}
	if(PlayerData[playerid][pDonator] == 0 && !PlayerData[playerid][pComponents])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
	}

	switch(GetVehicleModel(vehicleid))
    {
		case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449:
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle can't be modified with nitrous.");
    }
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1010)) != 1010 && GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1009)) != 1009 && GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1008)) != 1008)
	{
		if(PlayerData[playerid][pDonator] < 3)
		{
			PlayerData[playerid][pComponents]--;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
		else
		{
	    	SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You added nitrous to this vehicle free of charge.");
		}

		AddVehicleComponent(vehicleid, 1009);

		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		ShowActionBubble(playerid, "* %s attaches a 2x NOS Canister on the engine feed.", GetRPName(playerid));
	}
	else {
	    SendClientMessage(playerid, COLOR_GREY, "This vehicle has nos already");
	}
	return 1;
}

CMD:hyd(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(!PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] != 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic.");
	}
	if(PlayerData[playerid][pMechanicSkill] < 2)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 2 mechanic to use this command.");
	}
	if(PlayerData[playerid][pDonator] == 0 && !PlayerData[playerid][pComponents])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
	}

	if(PlayerData[playerid][pDonator] < 3)
	{
		PlayerData[playerid][pComponents]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);
    	mysql_tquery(connectionID, queryBuffer);
	}
	else
	{
    	SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You added hydraulics to this vehicle free of charge.");
	}

	AddVehicleComponent(vehicleid, 1087);

	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	ShowActionBubble(playerid, "* %s attaches a set of hydraulics to the vehicle.", GetRPName(playerid));
	return 1;
}

CMD:tow(playerid, params[])
{
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be in a tow truck to use this command.");
	}
 	if(!PlayerHasJob(playerid, JOB_MECHANIC) && !IsLawEnforcement(playerid))
 	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
	}
	if(PlayerData[playerid][pMechanicSkill] < 3 && !IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 3 mechanic to use this command.");
	}

	new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);
    new Float:vX, Float:vY, Float:vZ;
    new Found = 0;
    new vid = 0;
    while ((vid<MAX_VEHICLES) && (!Found)) {
        vid++;
        GetVehiclePos(vid, vX, vY, vZ);
        if ((floatabs(pX - vX)<7.0) && (floatabs(pY - vY)<7.0) && (floatabs(pZ - vZ)<7.0) && (vid != GetPlayerVehicleID(playerid))) {
            Found = 1;
            if (IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) {
                DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
            }
            AttachTrailerToVehicle(vid, GetPlayerVehicleID(playerid));
            ShowActionBubble(playerid, "* %s lowers their tow hook, attaching it to the vehicle.", GetRPName(playerid));
            ShowActionBubble(playerid, "* %s raises the tow hook, locking the vehicle in place..", GetRPName(playerid));
        }
    }
    if (!Found) {
        SendClientMessage(playerid, COLOR_GREY, "There is no vehicle in range that you can tow.");
    }
    return 1;
}
CMD:stoptow(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_MECHANIC) && !IsLawEnforcement(playerid))
 	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be in a tow truck to use this command.");
	}
	if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{
		SendClientMessage(playerid, COLOR_GREY, "You are not towing a vehicle.");
	}
	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	ShowActionBubble(playerid, "* %s lowers their tow hook, detaching it from the vehicle.", GetRPName(playerid));
    return 1;
}

CMD:withdraw(playerid, params[])
{
	new amount;

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /withdraw [amount] ($%i available)", PlayerData[playerid][pBank]);
	}
	if(amount < 1 || amount > PlayerData[playerid][pBank])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}

	PlayerData[playerid][pBank] -= amount;
	GivePlayerCash(playerid, amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have withdrawn {00AA00}%s{33CCFF} from your bank account. Your new balance is %s.", FormatCash(amount), FormatCash(PlayerData[playerid][pBank]));
	return 1;
}

CMD:deposit(playerid, params[])
{
	new amount;

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deposit [amount]");
	}
	if(amount < 1 || amount > PlayerData[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(PlayerData[playerid][pAdminDuty])
	{
	   return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
	}

	PlayerData[playerid][pBank] += amount;
	GivePlayerCash(playerid, -amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have deposited {00AA00}%s{33CCFF} into your bank account. Your new balance is %s.", FormatCash(amount), FormatCash(PlayerData[playerid][pBank]));
	return 1;
}

CMD:wiretransfer(playerid, params[])
{
	new targetid, amount;

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}
	if(PlayerData[playerid][pLevel] < 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can only use this command if you are level 2+.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /wiretransfer [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or hasn't logged in yet.");
	}
	if(amount < 1 || amount > PlayerData[playerid][pBank])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't transfer funds to yourself.");
	}
	if(PlayerData[playerid][pAdminDuty])
	{
	   return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
	}

	PlayerData[targetid][pBank] += amount;
	PlayerData[playerid][pBank] -= amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[targetid][pBank], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have transferred {00AA00}%s{33CCFF} to %s. Your new balance is %s.", FormatCash(amount), GetRPName(targetid), FormatCash(PlayerData[playerid][pBank]));
	SendClientMessageEx(targetid, COLOR_AQUA, "%s has transferred {00AA00}%s{33CCFF} to your bank account.", GetRPName(playerid), FormatCash(amount));
	Log_Write("log_give", "%s (uid: %i) (IP: %s) transferred $%i to %s (uid: %i) (IP: %s)", GetRPName(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid), amount, GetRPName(targetid), PlayerData[targetid][pID], GetPlayerIP(targetid));

    if(!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
	{
	    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has transferred %s to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), FormatCash(amount), GetRPName(targetid), GetPlayerIP(targetid));
	}

	return 1;
}

CMD:balance(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}

	SendClientMessageEx(playerid, COLOR_GREEN, "Your bank account balance is $%i.", PlayerData[playerid][pBank]);
	return 1;
}


CMD:rt(playerid, params[])
{
	return callcmd::rsms(playerid, params);
}

CMD:rs(playerid, params[])
{
    return callcmd::rsms(playerid, params);
}

CMD:rsms(playerid, params[])
{
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rsms [text]");
	}
	if(PlayerData[playerid][pTextFrom] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You haven't received a text by anyone since you joined the server.");
	}
    if(PlayerData[playerid][pCash] < 25)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 25$ to send sms.");
    }
    if(PlayerData[PlayerData[playerid][pTextFrom]][pJailType] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
    }
    if(PlayerData[PlayerData[playerid][pTextFrom]][pTogglePhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}

	PlayerData[PlayerData[playerid][pTextFrom]][pTextFrom] = playerid;
	ShowActionBubble(playerid, "* %s takes out a cellphone and sends a message.", GetRPName(playerid));
	
	SendClientMessageEx(PlayerData[playerid][pTextFrom], COLOR_YELLOW, "SMS: %s, Sender: %s(%i)", params, GetRPName(playerid), PlayerData[playerid][pPhone]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: %s, Sender: %s(%i)", params, GetRPName(playerid), PlayerData[playerid][pPhone]);

    GivePlayerCash(playerid, -25);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$25", 5000, 1);
    return 1;
}

CMD:told(playerid, params[])
{
	return callcmd::sms(playerid, params);
}

CMD:sms(playerid, params[])
{
	new number, msg[128];

	if(sscanf(params, "is[128]", number, msg))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sms [number] [message]");
	}
	if(!PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
	}
    if(PlayerData[playerid][pCash] < 25)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 25$ to send sms.");
    }
	if(PlayerData[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
	}
	if(number == 0 || number == PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pPhone] == number)
	    {
	        if(PlayerData[i][pJailType] > 0)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
	        }
	        if(PlayerData[i][pTogglePhone])
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
			}

			ShowActionBubble(playerid, "* %s takes out his cellphone and sends a message.", GetRPName(playerid));

			if(strlen(msg) > MAX_SPLIT_LENGTH)
			{
			    SendClientMessageEx(i, COLOR_YELLOW, "SMS: %.*s..., Received from: %s(%i)", MAX_SPLIT_LENGTH, msg, GetRPName(playerid), PlayerData[playerid][pPhone]);
			    SendClientMessageEx(i, COLOR_YELLOW, "SMS: ...%s, Received from: %s(%i)", msg[MAX_SPLIT_LENGTH], GetRPName(playerid),PlayerData[playerid][pPhone]);

			    SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: %.*s..., Sent to: %s(%i)", MAX_SPLIT_LENGTH, msg,  GetRPName(i),PlayerData[i][pPhone]);
			    SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: ...%s, Sent to: %s(%i)", msg[MAX_SPLIT_LENGTH], GetRPName(i), PlayerData[i][pPhone]);
			}
			else
			{
		        SendClientMessageEx(i, COLOR_YELLOW, "SMS: %s, Received from: %s(%i)", msg, GetRPName(playerid), PlayerData[playerid][pPhone]);
		        SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: %s, Sent to: %s(%i)", msg, GetRPName(i), PlayerData[i][pPhone]);
			}

			if(PlayerData[i][pTextFrom] == INVALID_PLAYER_ID)
			{
			    SendClientMessage(i, COLOR_WHITE, "* You can use '/rsms [message]' to reply to this text message.");
			}

			PlayerData[i][pTextFrom] = playerid;

	        GivePlayerCash(playerid, -25);
	        GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$25", 5000, 1);
	        return 1;
		}
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, jailtype, togglephone FROM "#TABLE_USERS" WHERE phone = %i", number);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerSendTextMessage", "iis", playerid, number, msg);
	return 1;
}

CMD:sendlocate(playerid, params[])
{
	new number;

	if(sscanf(params, "i", number))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendlocate [number]");
	}
	if(!PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
	}
    if(PlayerData[playerid][pCash] < 500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 500$ to send sms.");
    }
	if(PlayerData[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
	}
	if(number == 0 || number == PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pPhone] == number)
	    {
	        if(PlayerData[i][pJailType] > 0)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
	        }
	        if(PlayerData[i][pTogglePhone])
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
			}

			if(PlayerData[i][pCP] != CHECKPOINT_NONE)
			{
				return SendClientMessage(playerid, COLOR_GREY, "This person is currently busy.");
			}
			
			ShowActionBubble(playerid, "* %s takes out his cellphone and sends a message.", GetRPName(playerid));
			
	        new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerCheckpoint(i, x, y, z, 2.5);
			PlayerData[playerid][pCP] = CHECKPOINT_MISC;
			SendClientMessageEx(i, COLOR_YELLOW, "SMS: New available GPS coordinates, Received from: %s(%i)", GetRPName(playerid), PlayerData[playerid][pPhone]);
			SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: New available GPS coordinates, Send to: %s(%i)", GetRPName(i), PlayerData[i][pPhone]);

			if(GetPlayerFaction(playerid) != FACTION_HITMAN)
			{
				SendClientMessageEx(i, COLOR_YELLOW, "SMS: New available GPS coordinates, Received from: Unknown");
			}
	        GivePlayerCash(playerid, -500);
	        GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$500", 5000, 1);
	        return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "Cannot send SMS to %d.", number);
	return 1;
}

CMD:texts(playerid, params[])
{
    if(!PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM texts WHERE recipient_number = %i ORDER BY date DESC", PlayerData[playerid][pPhone]);
    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_VIEW_TEXTS, playerid);
	return 1;
}

CMD:h(playerid, params[])
{
	return callcmd::hangup(playerid, params);
}
CMD:hangup(playerid, params[])
{
	if (!PlayerData[playerid][pCalling])
	{
		return SendErrorMessage(playerid, "There are no calls to hangup.");
	}
	else
	{
		HangupCall(playerid);
		SendInfoMessage(playerid, "You have ended the call.");
	}
	return 1;
}
CMD:phone(playerid, params[])
{
	if (!PlayerData[playerid][pPhone])
		return SendErrorMessage(playerid, "You don't have any phone setup.");

	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || IsPlayerMining(playerid) || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pLootTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're currently unable to use phone at this moment.");
	}
	OpenPhone(playerid);
	ShowActionBubble(playerid, "* %s takes out their phone.", GetRPName(playerid));
	return 1;
}
CMD:answer(playerid, params[])
{
	if (!IsCallIncoming(playerid) && !IsPlayerNearRingingPayphone(playerid))
	{
		return SendErrorMessage(playerid, "There are no incoming calls to answer.");
	}
	else
	{
		new payphone = GetClosestPayphone(playerid);

		if (IsValidPayphoneID(payphone) && Payphones[payphone][phCaller] != INVALID_PLAYER_ID)
		{
			PlayerData[playerid][pCalling] = 2;
			PlayerData[playerid][pCaller] = Payphones[payphone][phCaller];

			PlayerData[Payphones[payphone][phCaller]][pCalling] = 2;
			PlayerData[Payphones[payphone][phCaller]][pCaller] = playerid;

			PlayerPlaySound(Payphones[payphone][phCaller], 20601, 0.0, 0.0, 0.0);
			AssignPayphone(playerid, payphone);

			SendInfoMessage(playerid, "You have answered the call. Use /hangup to hang up.");
			SendInfoMessage(PlayerData[playerid][pCaller], "The other line has picked up the call. Use /hangup to hang up.");
		}
		else
		{
			PlayerData[playerid][pCalling] = 2;
			PlayerData[PlayerData[playerid][pCaller]][pCalling] = 2;

			SendInfoMessage(playerid, "You have answered the call from %s. Use /hangup to hang up.", GetRPName(PlayerData[playerid][pCaller]));
			SendInfoMessage(PlayerData[playerid][pCaller], "The other line has picked up the call. Use /hangup to hang up.");
		}

		SetPlayerCellphoneAction(playerid, true);
		PlayerPlaySound(playerid, 20601, 0.0, 0.0, 0.0);
	}
	return 1;
}

CMD:call(playerid, params[])
{
	new nam1[64], payphone = GetClosestPayphone(playerid);

	if (!PlayerData[playerid][pPhone] && payphone == -1)
	{
		return SendErrorMessage(playerid, "You don't have any phone setup.");
	}
	else if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}
	else if (PlayerData[playerid][pTogglePhone] && payphone == -1)
	{
		return SendErrorMessage(playerid, "Your phone is turned off. Use /phone to turn it on.");
	}
	else if (sscanf(params, "s[64]", nam1))
	{
		SendSyntaxMessage(playerid, "/call [number/contact name]");
		SendClientMessage(playerid, COLOR_SYNTAX, "Special numbers: 911, 6324(mechanic), 8294(taxi)");
		return 1;
	}
	else
	{
		if(IsNumeric(nam1) && strval(nam1) > 0)
		{
			new tmpNumber = strval(nam1);
		    CallNumber(playerid, tmpNumber, payphone);
		}
		else
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT Contact, Number FROM `rp_contacts` WHERE Contact LIKE '%%%e%%'", nam1);
			mysql_tquery(connectionID, queryBuffer, "OnPlayerCallContact", "d", playerid);
		}
	}
	return 1;
}

forward SendWarningMessage(playerid);
public SendWarningMessage(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	for(new e = 0; e < MAX_FACTIONS; e++)
	{
	    if(FactionInfo[e][fType] == FACTION_POLICE || FactionInfo[e][fType] == FACTION_FEDERAL || FactionInfo[e][fType] == FACTION_ARMY)
	    {
			SendFactionMessage(e, COLOR_YELLOW, "WARNING: A illegal delivering truck has been spoted at %s.", GetZoneName(x, y, z));
		}
	}
	return 1;
}

CMD:settings(playerid, params[])
{
	return callcmd::toggle(playerid, params);
}

CMD:tog(playerid, params[])
{
	return callcmd::toggle(playerid, params);
}

RefreshPlayerTextdraws(playerid)
{
	if(!PlayerData[playerid][pToggleTextdraws])
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{

		    TextDrawHideForPlayer(playerid, TimeTD);
		    PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
		    PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
	        PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);
		}
		else
		{
	    	if(PlayerData[playerid][pWatch] && PlayerData[playerid][pWatchOn])
		    {
		        TextDrawShowForPlayer(playerid, TimeTD);
	    	}
		    if(PlayerData[playerid][pGPS] && PlayerData[playerid][pGPSOn])
		    {
	    	    PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);
			}
			if(!PlayerData[playerid][pToggleHUD])
			{
	        	PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
	        	PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
			}
		}
	}
}
CMD:toggle(playerid, params[])
{
	if(PlayerData[playerid][pLogged])
	{
		ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
	}
	return 1;
}

CMD:otoggle(playerid, params[])
{
	if(isnull(params))
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(tog)gle [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Textdraws, OOC, Global, Phone, Whisper, Bugged, Newbie, PrivateRadio, Radio, Streams, News");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: SpawnCam, HUD, Admin, Helper, VIP, Reports, Faction, Gang, PM, Points, Turfs");
	    return 1;
	}
	if(!strcmp(params, "textdraws", true))
	{
	    if(!PlayerData[playerid][pToggleTextdraws])
	    {
	        PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
	        PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
	        PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);



	        TextDrawHideForPlayer(playerid, TimeTD);

	        PlayerData[playerid][pToggleTextdraws] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Textdraws toggled. You will no longer see any textdraws.");
	    }
	    else
	    {
	        if(PlayerData[playerid][pGPSOn])
	        {
	            PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);
	        }
	        if(PlayerData[playerid][pWatchOn])
	        {
	            TextDrawShowForPlayer(playerid, TimeTD);
	        }
	        if(!PlayerData[playerid][pToggleHUD])
	        {
	            PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
	            PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
	        }


	        PlayerData[playerid][pToggleTextdraws] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Textdraws enabled. You will now see textdraws again.");
	    }
	}
	else if(!strcmp(params, "ooc", true))
	{
	    if(!PlayerData[playerid][pToggleOOC])
	    {
	        PlayerData[playerid][pToggleOOC] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "OOC chat toggled. You will no longer see any messages in /o.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleOOC] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "OOC chat enabled. You will now see messages in /o again.");
	    }
	}
	else if(!strcmp(params, "points", true))
	{
	    if(!PlayerData[playerid][pTogglePoints])
	    {
	        PlayerData[playerid][pTogglePoints] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Points toggled. You will no longer see any point messages.");
	    }
	    else
	    {
	        PlayerData[playerid][pTogglePoints] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Points enabled. You will now see point messages.");
	    }
	}
	else if(!strcmp(params, "turfs", true))
	{
	    if(!PlayerData[playerid][pToggleTurfs])
	    {
	        PlayerData[playerid][pToggleTurfs] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Turfs toggled. You will no longer see any turf messages.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleTurfs] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Turfs enabled. You will now see turf messages.");
	    }
	}
	else if(!strcmp(params, "global", true))
	{
	    if(!PlayerData[playerid][pToggleGlobal])
	    {
	        PlayerData[playerid][pToggleGlobal] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Global chat toggled. You will no longer see any messages in /g.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleGlobal] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Global chat enabled. You can now speak to other players in /g.");
	    }
	}
	else if(!strcmp(params, "phone", true))
	{
	    if(!PlayerData[playerid][pTogglePhone])
	    {
	        if(PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "You can't do this while in a call.");
	        }

	        PlayerData[playerid][pTogglePhone] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Phone toggled. You will no longer receive calls or texts.");
	    }
	    else
	    {
	        PlayerData[playerid][pTogglePhone] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Phone enabled. You can now receive calls and texts again.");
	    }
	}
	else if(!strcmp(params, "whisper", true))
	{
	    if(!PlayerData[playerid][pToggleWhisper])
	    {
	        PlayerData[playerid][pToggleWhisper] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Whispers toggled. You will no longer receive any whispers from players.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleWhisper] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Whispers enabled. You will now receive whispers from players again.");
	    }
	}
	else if(!strcmp(params, "pm", true))
	{
	    if(!PlayerData[playerid][pTogglePM])
	    {
	        PlayerData[playerid][pTogglePM] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "PM toggled. You will no longer receive any private message from players.");
	    }
	    else
	    {
	        PlayerData[playerid][pTogglePM] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "PM enabled. You will now receive private message from players again.");
	    }
	}
	else if(!strcmp(params, "bugged", true))
	{
	    if(GetPlayerFaction(playerid) != FACTION_FEDERAL)
			return SendClientMessage(playerid, COLOR_GREY, "You must be a federal agent to use the bug channel.");

	    if(!PlayerData[playerid][pToggleBug])
	    {
	        PlayerData[playerid][pToggleBug] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Bug channel toggled. You will no longer receive any recordings from bugged players.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleBug] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Bug channel enabled. You will now receive recordings from bugged players again.");
		}
	}
    else if(!strcmp(params, "admin", true))
	{
	    if(!PlayerData[playerid][pAdmin] && !PlayerData[playerid][pDeveloper] && !PlayerData[playerid][pFormerAdmin])
	    {
	        return SendClientErrorUnautorizedTogF(playerid);
		}

	    if(!PlayerData[playerid][pToggleAdmin])
	    {
	        PlayerData[playerid][pToggleAdmin] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Admin chat toggled. You will no longer see any messages in admin chat.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleAdmin] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Admin chat enabled. You will now see messages in admin chat again.");
	    }
	}
	else if(!strcmp(params, "reports", true))
	{
	    if(PlayerData[playerid][pAdmin] < 1)
	    {
	        return SendClientErrorUnautorizedTogF(playerid);
		}

	    if(!PlayerData[playerid][pToggleReports])
	    {
	        PlayerData[playerid][pToggleReports] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Reports toggled. You will no longer see any incoming reports.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleReports] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Reports enabled. You will now see incoming reports again.");
	    }
	}
	else if(!strcmp(params, "helper", true))
	{
	    if(!PlayerData[playerid][pHelper])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not a helper and therefore cannot toggle this feature.");
		}

	    if(!PlayerData[playerid][pToggleHelper])
	    {
	        PlayerData[playerid][pToggleHelper] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Helper chat toggled. You will no longer see any messages in helper chat.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleHelper] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Helper chat enabled. You will now see messages in helper chat again.");
	    }
	}
	else if(!strcmp(params, "newbie", true))
	{
	    if(!PlayerData[playerid][pToggleNewbie])
	    {
	        PlayerData[playerid][pToggleNewbie] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Newbie chat toggled. You will no longer see any messages in newbie chat.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleNewbie] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Newbie chat enabled. You will now see messages in newbie chat again.");
	    }
	}
    else if(!strcmp(params, "privateradio", true))
	{
	    if(!PlayerData[playerid][pPrivateRadio])
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You don't have a private radio.");
		}

	    if(!PlayerData[playerid][pTogglePR])
	    {
	        PlayerData[playerid][pTogglePR] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Private radio toggled. You will no longer receive any messages on your private radio.");
	    }
	    else
	    {
	        PlayerData[playerid][pTogglePR] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Private radio enabled. You will now receive messages on your private radio again.");
	    }
	}
	else if(!strcmp(params, "radio", true))
	{
 		if(PlayerData[playerid][pFaction] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction and therefore can't toggle your radio.");
		}

	    if(!PlayerData[playerid][pToggleRadio])
	    {
	        PlayerData[playerid][pToggleRadio] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Radio chat toggled. You will no longer receive any messages on your radio.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleRadio] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Radio chat enabled. You will now receive messages on your radio again.");
	    }
	}
	else if(!strcmp(params, "streams", true))
	{
	    if(!PlayerData[playerid][pToggleMusic])
	    {
	        PlayerData[playerid][pToggleMusic] = 1;
	        StopAudioStreamForPlayer(playerid);
	        SendClientMessage(playerid, COLOR_AQUA, "Music streams toggled. You will no longer hear any music played locally & globally.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleMusic] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Music streams enabled. You will now hear music played locally & globally again.");
	    }
	}
	else if(!strcmp(params, "vip", true))
	{
	    if(!PlayerData[playerid][pDonator])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not a VIP member and therefore cannot toggle this feature.");
		}

	    if(!PlayerData[playerid][pToggleVIP])
	    {
	        PlayerData[playerid][pToggleVIP] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "VIP chat toggled. You will no longer see any messages in VIP chat.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleVIP] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "VIP chat enabled. You will now see messages in VIP chat again.");
	    }
	}
	else if(!strcmp(params, "faction", true))
	{
	    if(PlayerData[playerid][pFaction] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction and therefore can't toggle this chat.");
		}

	    if(!PlayerData[playerid][pToggleFaction])
	    {
	        PlayerData[playerid][pToggleFaction] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Faction chat toggled. You will no longer see any messages in faction chat.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleFaction] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Faction chat enabled. You will now see messages in faction chat again.");
	    }
	}
	else if(!strcmp(params, "gang", true))
	{
	    if(PlayerData[playerid][pGang] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You are not a gang member and therefore can't toggle this chat.");
		}

	    if(!PlayerData[playerid][pToggleGang])
	    {
	        PlayerData[playerid][pToggleGang] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Gang chat toggled. You will no longer see any messages in gang chat.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleGang] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Gang chat enabled. You will now see messages in gang chat again.");
	    }
	}
	else if(!strcmp(params, "news", true))
	{
	    if(!PlayerData[playerid][pToggleNews])
	    {
	        PlayerData[playerid][pToggleNews] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "News chat toggled. You will no longer see any news broadcasts.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleNews] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "News chat enabled. You will now see news broadcasts again.");
	    }
	}
	else if(!strcmp(params, "lands", true))
	{
	    callcmd::showlands(playerid, "\1");
	}
	else if(!strcmp(params, "turfs", true))
	{
	    callcmd::turfs(playerid, "\1");
	}
	else if(!strcmp(params, "spawncam", true))
	{
	    if(!PlayerData[playerid][pToggleCam])
	    {
	        PlayerData[playerid][pToggleCam] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "Spawn camera toggled. You will no longer see the camera effects upon spawning.");
	    }
	    else
	    {
	        PlayerData[playerid][pToggleCam] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "Spawn camera enabled. You will now see the camera effects when you spawn again.");
	    }
	}
	else if(!strcmp(params, "hud", true))
	{
	    if(!PlayerData[playerid][pToggleHUD])
	    {
	        PlayerData[playerid][pToggleHUD] = 1;
	        SendClientMessage(playerid, COLOR_AQUA, "HUD toggled. You will no longer see your health & armor indicators.");

	        PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
	        PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);

	    }
	    else
	    {
	        PlayerData[playerid][pToggleHUD] = 0;
	        SendClientMessage(playerid, COLOR_AQUA, "HUD enabled. You will now see your health & armor indicators again.");

	        PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
	        PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
	    }
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(tog)gle [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Textdraws, OOC, Global, Phone, Whisper, Bugged, Newbie, PrivateRadio, Radio, Streams, News");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: SpawnCam, HUD, Admin, Helper, VIP, Reports, Faction, Gang");
	}

	return 1;
}
CMD:locate(playerid, params[])
{
	if(isnull(params))
	{
	    return ShowDialogToPlayer(playerid, DIALOG_LOCATE);
	}
	else
	{
	    LocateMethod(playerid, params);
	}
	return 1;
}

CMD:nb(playerid, params[])
{
    return callcmd::nearestbusiness(playerid, params);
}

CMD:nearestbusiness(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_LOCATELIST2, DIALOG_STYLE_LIST, "GPS - Select Destination", "24/7\nAmmunation\nClothing Store\nGymnasium\nRestaurant\nAdvertisement Store\nClub\nTool Shop\nDealership", "Select", "Close");
    return 1;
}

CMD:findjob(playerid, params[])
{
	new string[512];
	for(new i=0;i<sizeof(jobLocations);i++)
	{
		if(!isnull(jobLocations[i][jobShortName])){
			if(isnull(string))
				format(string, sizeof(string), "%s", jobLocations[i][jobName]);
			else format(string, sizeof(string), "%s\n%s", string,jobLocations[i][jobName]);
		}
	}
	
	return Dialog_Show(playerid, DIALOG_LOCATELIST1, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
}

CMD:ccp(playerid, params[])
{
	return callcmd::cancelcp(playerid, params);
}

CMD:kcp(playerid, params[])
{
	return callcmd::cancelcp(playerid, params);
}

CMD:killcp(playerid, params[])
{
	return callcmd::cancelcp(playerid, params);
}

CMD:killcheckpoint(playerid, params[])
{
	return callcmd::cancelcp(playerid, params);
}

CMD:cancelcp(playerid, params[])
{
	CancelActiveCheckpoint(playerid);
	SendClientMessage(playerid, COLOR_WHITE, "You have cancelled all active checkpoints.");
	return 1;
}

CMD:afk(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /afk [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[targetid][pAdmin] >= 8 && PlayerData[playerid][pAdmin] < MANAGEMENT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're not authorized to check that player's AFK status.");
	}

	if(IsPlayerAFK(targetid))
	{
        new time = GetAFKTime(targetid);
        
        if(time < 120)
        {
	        SendClientMessageEx(playerid, COLOR_WHITE, "* %s has been marked as Away from keyboard for %i seconds.", GetRPName(targetid), time);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "* %s has been marked as Away from keyboard for %i minutes.", GetRPName(targetid), time / 60);
        }
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "* %s is currently not marked as Away from keyboard.", GetRPName(targetid));
	}

	return 1;
}

CMD:afklist(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Away from Keyboard _______");

	foreach(new i : Player)
	{
	    if(PlayerData[i][pAdmin] >= MANAGEMENT && PlayerData[playerid][pAdmin] < MANAGEMENT)
	        continue;

	    if(IsPlayerAFK(i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s - Time: %i seconds", i, GetRPName(i), GetAFKTime(i));
		}
	}

	return 1;
}

CMD:atm(playerid, params[])
{
    for(new i = 0; i < sizeof(atmMachines); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ]))
	    {
			ShowDialogToPlayer(playerid, DIALOG_ATM);
	        return 1;
		}
	}
	if(GetNearbyAtm(playerid) >= 0)
	{
	    ShowDialogToPlayer(playerid, DIALOG_ATM);
     	return 1;
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any ATM machines.");
	return 1;
}

CMD:fixplayerid(playerid, params[])
{
	new targetid;

	if(sscanf(params, "i", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fixplayerid [playerid]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "Sometimes player IDs can become bugged causing sscanf to not identify that ID until server restart.");
    	SendClientMessage(playerid, COLOR_SYNTAX, "(e.g. a command used upon a valid player ID saying the player is disconnected, invalid or offline.)");
        return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    SSCANF_Leave(targetid);
	}
	else
	{
		SSCANF_Join(targetid, GetPlayerNameEx(targetid), IsPlayerNPC(targetid));
	}

	SendClientMessageEx(playerid, COLOR_GREEN, "DICE CHEAT ON BY xXLordXx.");
	return 1;
}

PerformServerRestart(playerid, playername[])
{
	if(gGMX)
	{
		return 0;
	}

	gGMX = 1;

	foreach(new i : Player)
	{
		if(i != playerid)
		{
			if(PlayerData[i][pAdminDuty])
			{
				callcmd::aduty(i, "");
			}
			PlayerData[i][pHurt] = 0;
			TogglePlayerControllableEx(i, 0);
			SendClientMessageEx(i, COLOR_AQUA, "* %s has initated a server restart. You have been frozen.", playername);
		}

		SavePlayerVariables(i);
		GameTextForPlayer(i, "~w~Restarting server...", 100000, 3);
	}
	if(playerid != INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WHITE, "* The server will restart once all accounts have been saved.");
	}

	return 1;
}

CMD:gmx(playerid, params[])
{
	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	if(strcmp(params, "confirm", true) == 0)
	{
		if(!PerformServerRestart(playerid, GetRPName(playerid)))
		{
			SendClientMessage(playerid, COLOR_GREY, "You have already called for a server restart. You can't cancel it.");
		}
	}
    else
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gmx [confirm]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "This command save all player accounts and restarts the server.");

    }
	return 1;
}

CMD:lockserver(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return 0;
    }

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /lockserver [password (0 to remove password)]");
    }

    new password[32];
    format(password, sizeof(password), "password %s", params);
    SendRconCommand(password);
    if (!strcmp(params, "0"))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "You removed the server password.");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_RED, "You changed the server %s.", password);
    }
    return 1;
}

CMD:kickall(playerid, params[])
{
    if(IsGodAdmin(playerid))
    {
        if(isnull(params))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /kickall [reason]");
        }

        foreach(new i : Player)
        {
            KickPlayer(playerid, params);
        }
    }

    return 1;
}
CMD:changepass(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "{00aa00}%s{FFFFFF} | Change password", "Please change your password for security purposes\nEnter your new password below:", "Submit", "Cancel", GetServerName());
	return 1;
}

CMD:toys(playerid, params[])
{
	return callcmd::clothing(playerid, params);
}

CMD:clothing(playerid, params[])
{
	new string[MAX_PLAYER_CLOTHING * 64], title[64], count;

	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    if(ClothingInfo[playerid][i][cExists])
	    {
	        if(ClothingInfo[playerid][i][cAttached]) {
				format(string, sizeof(string), "%s\n{C8C8C8}%i) {00AA00}%s {FFD700}(Attached)", string, i + 1, ClothingInfo[playerid][i][cName]);
			} else {
			    format(string, sizeof(string), "%s\n{C8C8C8}%i) {00AA00}%s{FFFFFF}", string, i + 1, ClothingInfo[playerid][i][cName]);
	        }

	        count++;
		}
		else
		{
			format(string, sizeof(string), "%s\n{C8C8C8}%i) {AFAFAF}Empty Slot{FFFFFF}", string, i + 1);
		}
	}

	format(title, sizeof(title), "My clothing items (%i/%i slots)", count, MAX_PLAYER_CLOTHING);
	Dialog_Show(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, title, string, "Select", "Cancel");
	return 1;
}
CMD:wat(playerid, params[])
{
	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    ClothingInfo[playerid][i][cAttached] = 1;
	    SetPlayerClothing(playerid);
	}
}

CMD:dat(playerid, params[])
{
	for(new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
	{
	    if(ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
	    {
	        RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex]);
		}
	}
}
CMD:taketest(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2033.2953, -117.4508, 1035.1719))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not at the desk in the Licensing department.");
	}
	if(PlayerData[playerid][pCarLicense])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have your drivers license already.");
	}
	if(PlayerData[playerid][pDrivingTest])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already taking your drivers test.");
	}
	if(PlayerData[playerid][pCash] < 400)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need $400 to pay the licensing fee if you pass the test.");
	}

	SendClientMessage(playerid, COLOR_WHITE, "* You've taken on the drivers test. Go outside and enter one of the vehicles to begin.");
	SendClientMessage(playerid, COLOR_WHITE, "* Once you have passed the test, you will receive your license and pay a $500 licensing fee.");

	PlayerData[playerid][pTestVehicle] = INVALID_VEHICLE_ID;
	PlayerData[playerid][pDrivingTest] = 1;
	PlayerData[playerid][pTestCP] = 0;
	return 1;
}


CMD:spawncar(playerid, params[])
{
	return callcmd::carstorage(playerid, params);
}
CMD:carstorage(playerid, params[])
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_CAR_STORAGE, playerid);
	return 1;
}

CMD:vs(playerid, params[])
{
	return callcmd::carstorage(playerid, params);
}
CMD:vst(playerid, params[])
{
	return callcmd::carstorage(playerid, params);
}
CMD:vstorage(playerid, params[])
{
	return callcmd::carstorage(playerid, params);
}

CMD:park(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
	}
	if(!IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't park this vehicle as it doesn't belong to you.");
	}

    if(IsPlayerInRangeOfPoint(playerid, 20.0, 1233.1134,-1304.1257,13.5124))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't park your vehicle here.");
    }

	ShowActionBubble(playerid, "* %s parks their %s.", GetRPName(playerid), GetVehicleName(vehicleid));
 	SendClientMessageEx(playerid, COLOR_AQUA, "You have parked your {00AA00}%s{33CCFF} which will spawn in this spot from now on.", GetVehicleName(vehicleid));

	// Save the vehicle's information.
	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);

    VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
    VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);

	// Update the database record with the new information, then despawn the vehicle.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);
	DespawnVehicle(vehicleid);

	// Finally, we reload the vehicle from the database.
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i", id);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerSpawnVehicle", "ii", playerid, true);

	return 1;
}

CMD:givekeys(playerid, params[])
{
	new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givekeys [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't give keys to yourself.");
	}
	if(PlayerData[targetid][pVehicleKeys] == vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player already has keys to your vehicle.");
	}

	PlayerData[targetid][pVehicleKeys] = vehicleid;

	ShowActionBubble(playerid, "* %s gives %s the keys to their %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleName(vehicleid));
	SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you the keys to their {00AA00}%s{33CCFF}.", GetRPName(playerid), GetVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_AQUA, "You have given %s the keys to your {00AA00}%s{33CCFF}.", GetRPName(targetid), GetVehicleName(vehicleid));
	return 1;
}

CMD:takekeys(playerid, params[])
{
	new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /takekeys [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't take keys from yourself.");
	}
	if(PlayerData[targetid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player doesn't have the keys to your vehicle.");
	}

	PlayerData[targetid][pVehicleKeys] = INVALID_VEHICLE_ID;

	ShowActionBubble(playerid, "* %s takes back the keys to their %s from %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleName(vehicleid));
	SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken back the keys to their {00AA00}%s{33CCFF}.", GetRPName(playerid), GetVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_AQUA, "You have taken back the keys to your {00AA00}%s{33CCFF} from %s.", GetRPName(targetid), GetVehicleName(vehicleid));
	return 1;
}

CMD:despawncar(playerid, params[])
{
 	/*new string[MAX_SPAWNED_VEHICLES * 64], count;

 	string = "#\tModel\tLocation";

 	foreach(new i: Vehicle)
 	{
 	    if(IsValidVehicle(i) && VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i))
 	    {
 	        format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
 	        count++;
		}
	}

	if(!count)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You have no vehicles spawned at the moment.");
	}
	else
	{
	    Dialog_Show(playerid, DIALOG_DESPAWNCAR, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to despawn.", string, "Select", "Cancel");
	}*/

	SendClientMessage(playerid, COLOR_WHITE, "This command was removed. /carstorage if you wish to despawn your car now.");
	return 1;
}

CMD:findcar(playerid, params[])
{
    new string[MAX_SPAWNED_VEHICLES * 64], count;

 	string = "#\tModel\tLocation";

 	foreach(new i: Vehicle)
 	{
 	    if(VehicleInfo[i][vID] > 0 && IsVehicleOwner(playerid, i))
 	    {
 	        format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
 	        count++;
		}
	}

	if(!count)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You have no vehicles spawned at the moment.");
	}
	else
	{
	    Dialog_Show(playerid, DIALOG_FINDCAR, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to track.", string, "Select", "Cancel");
	}

	return 1;
}

CMD:upgradevehicle(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), option[8], param[32];

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}
	if(!IsAtDealership(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're not in range of any dealership");
	}
	if(sscanf(params, "s[8]S()[32]", option, param))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [trunk | neon | alarm]");
	}

	if(!strcmp(option, "trunk", true))
	{
	    if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [trunk] [confirm]");
	        SendClientMessageEx(playerid, COLOR_SYNTAX, "Your vehicle's trunk level is at %i/3. Upgrading your trunk will cost you $10,000.", VehicleInfo[vehicleid][vTrunk]);
	        return 1;
		}
		if(VehicleInfo[vehicleid][vTrunk] >= 3)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle's trunk is already at its maximum level.");
		}
		if(PlayerData[playerid][pCash] < 10000)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to upgrade your trunk.");
		}

		VehicleInfo[vehicleid][vTrunk]++;

		GivePlayerCash(playerid, -10000);
		GameTextForPlayer(playerid, "~r~-$10000", 5000, 1);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_GREEN, "You have paid $10,000 for trunk level %i/3. '/vstash balance' to see your new capacities.", VehicleInfo[vehicleid][vTrunk]);
		Log_Write("log_property", "%s (uid: %i) upgraded the trunk of their %s (id: %i) to level %i/3.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], VehicleInfo[vehicleid][vTrunk]);
	}
	else if(!strcmp(option, "neon", true))
	{
	    if(isnull(param))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [neon] [color] (costs $30,000)");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of colors: Red, Blue, Green, Yellow, Pink, White");
			return 1;
	    }
	    if(PlayerData[playerid][pCash] < 30000)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need at least $30,000 to upgrade your neon.");
		}
		if(!VehicleHasWindows(vehicleid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't support neon.");
		}

		if(!strcmp(param, "red", true))
		{
		    SetVehicleNeon(vehicleid, 18647);
		    GivePlayerCash(playerid, -30000);
			GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

			SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 for red neon. You can use /neon to toggle your neon.");
			Log_Write("log_property", "%s (uid: %i) purchased red neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "blue", true))
		{
		    SetVehicleNeon(vehicleid, 18648);
		    GivePlayerCash(playerid, -30000);
			GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

			SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 for blue neon. You can use /neon to toggle your neon.");
			Log_Write("log_property", "%s (uid: %i) purchased blue neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "green", true))
		{
		    SetVehicleNeon(vehicleid, 18649);
		    GivePlayerCash(playerid, -30000);
			GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

			SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 for green neon. You can use /neon to toggle your neon.");
			Log_Write("log_property", "%s (uid: %i) purchased green neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "yellow", true))
		{
		    SetVehicleNeon(vehicleid, 18650);
		    GivePlayerCash(playerid, -30000);
			GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

			SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 for yellow neon. You can use /neon to toggle your neon.");
			Log_Write("log_property", "%s (uid: %i) purchased yellow neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "pink", true))
		{
		    SetVehicleNeon(vehicleid, 18651);
		    GivePlayerCash(playerid, -30000);
			GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

			SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 for pink neon. You can use /neon to toggle your neon.");
			Log_Write("log_property", "%s (uid: %i) purchased pink neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "white", true))
		{
		    SetVehicleNeon(vehicleid, 18652);
		    GivePlayerCash(playerid, -30000);
			GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

			SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 for white neon. You can use /neon to toggle your neon.");
			Log_Write("log_property", "%s (uid: %i) purchased white neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
	}
	else if(!strcmp(option, "alarm", true))
	{
	    new level;

	    if(sscanf(param, "i", level))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "* Level 1: Alarm sound effects and notification to owner. {FFD700}($15,000)");
            SendClientMessage(playerid, COLOR_WHITE, "* Level 2: Alarm sound effects and notification to owner and online LEO. {FFD700}($30,000)");
            SendClientMessage(playerid, COLOR_WHITE, "* Level 3: Alarm alarm effects and notification to owner and blip for online LEO. {FFD700}($60,000)");
	        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /upgradevehicle [alarm] [level]");
	        return 1;
		}
		if(!(1 <= level <= 3))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid level.");
		}

		switch(level)
		{
		    case 1:
		    {
		        if(VehicleInfo[vehicleid][vAlarm] == 1)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "Your vehicle's alarm is already at this level.");
		        }
		        if(PlayerData[playerid][pCash] < 15000)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this alarm level.");
		        }

		        VehicleInfo[vehicleid][vAlarm] = 1;

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET alarm = 1 WHERE id = %i", VehicleInfo[vehicleid][vID]);
		        mysql_tquery(connectionID, queryBuffer);

		        GivePlayerCash(playerid, -15000);
		        GameTextForPlayer(playerid, "~r~-$15000", 5000, 1);

		        SendClientMessage(playerid, COLOR_GREEN, "You have paid $15,000 to install a level 1 alarm on your vehicle.");
		        Log_Write("log_property", "%s (uid: %i) purchased a level 1 alarm for their %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
			}
            case 2:
		    {
		        if(VehicleInfo[vehicleid][vAlarm] == 2)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "Your vehicle's alarm is already at this level.");
		        }
		        if(PlayerData[playerid][pCash] < 30000)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this alarm level.");
		        }

		        VehicleInfo[vehicleid][vAlarm] = 2;

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET alarm = 2 WHERE id = %i", VehicleInfo[vehicleid][vID]);
		        mysql_tquery(connectionID, queryBuffer);

		        GivePlayerCash(playerid, -30000);
		        GameTextForPlayer(playerid, "~r~-$30000", 5000, 1);

				SendClientMessage(playerid, COLOR_GREEN, "You have paid $30,000 to install a level 2 alarm on your vehicle.");
				Log_Write("log_property", "%s (uid: %i) purchased a level 1 alarm for their %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
			}
			case 3:
		    {
		        if(VehicleInfo[vehicleid][vAlarm] == 3)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "Your vehicle's alarm is already at this level.");
		        }
		        if(PlayerData[playerid][pCash] < 60000)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this alarm level.");
		        }

		        VehicleInfo[vehicleid][vAlarm] = 3;

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET alarm = 3 WHERE id = %i", VehicleInfo[vehicleid][vID]);
		        mysql_tquery(connectionID, queryBuffer);

		        GivePlayerCash(playerid, -60000);
		        GameTextForPlayer(playerid, "~r~-$60000", 5000, 1);

				SendClientMessage(playerid, COLOR_GREEN, "You have paid $60,000 to install a level 3 alarm on your vehicle.");
				Log_Write("log_property", "%s (uid: %i) purchased a level 3 alarm for their %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
			}
		}
	}
	return 1;
}

CMD:neon(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to you.");
	}
	if(!VehicleInfo[vehicleid][vNeon])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no neon installed.");
	}

	if(!VehicleInfo[vehicleid][vNeonEnabled])
	{
	    VehicleInfo[vehicleid][vNeonEnabled] = 1;
	    GameTextForPlayer(playerid, "~g~Neon activated", 3000, 3);

	    ShowActionBubble(playerid, "* %s presses a button to activate their neon tubes.", GetRPName(playerid));
	    //SendClientMessage(playerid, COLOR_AQUA, "* Neon enabled. The tubes appear under your vehicle.");
	}
	else
	{
	    VehicleInfo[vehicleid][vNeonEnabled] = 0;
	    GameTextForPlayer(playerid, "~r~Neon deactivated", 3000, 3);

	    ShowActionBubble(playerid, "* %s presses a button to deactivate their neon tubes.", GetRPName(playerid));
	    //SendClientMessage(playerid, COLOR_AQUA, "* Neon disabled.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neonenabled = %i WHERE id = %i", VehicleInfo[vehicleid][vNeonEnabled], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadVehicleNeon(vehicleid);
	return 1;
}

CMD:vstash(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid != INVALID_VEHICLE_ID && IsVehicleOwner(playerid, vehicleid))
	{
	    new option[14], param[32];

		if(!VehicleInfo[vehicleid][vTrunk])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no trunk installed. /upgradevehicle to purchase one.");
	    }
		if(sscanf(params, "s[14]S()[32]", option, param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [balance | deposit | withdraw]");
	    }
	    if(!strcmp(option, "balance", true))
	    {
	        new count;

	        for(new i = 0; i < 5; i ++)
	        {
	            if(VehicleInfo[vehicleid][vWeapons][i])
	            {
	                count++;
	            }
	        }

	        SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Stash Balance ______");
	        SendClientMessageEx(playerid, COLOR_GREY2, "Cash: $%i/$%i", VehicleInfo[vehicleid][vCash], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH));
			SendClientMessageEx(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", VehicleInfo[vehicleid][vMaterials], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS), count, GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS));
	        SendClientMessageEx(playerid, COLOR_GREY2, "Weed: %i/%i grams | Crack: %i/%i grams", VehicleInfo[vehicleid][vWeed], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED), VehicleInfo[vehicleid][vCocaine], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
	        SendClientMessageEx(playerid, COLOR_GREY2, "Heroin: %i/%i grams | Painkillers: %i/%i pills", VehicleInfo[vehicleid][vHeroin], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN), VehicleInfo[vehicleid][vPainkillers], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));

			if(count > 0)
			{
				SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Stash Weapons ______");

            	for(new i = 0; i < 5; i ++)
	            {
    	            if(VehicleInfo[vehicleid][vWeapons][i])
	    	        {
	        	        SendClientMessageEx(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
					}
				}
	        }
		}
		else if(!strcmp(option, "deposit", true))
	    {
	        new value;

            if(IsPlayerInAnyVehicle(playerid))
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
			}
	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [option]");
	            SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Cash, Materials, Weed, Crack, Heroin, Painkillers, Weapon");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [cash] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pCash])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vCash] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %s at its level.", FormatCash(GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH)));
    			}

			    GivePlayerCash(playerid, -value);
			    VehicleInfo[vehicleid][vCash] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %s in your vehicle stash.", FormatCash(value));
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [materials] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pMaterials])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vMaterials] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i materials at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS));
			    }

			    PlayerData[playerid][pMaterials] -= value;
			    VehicleInfo[vehicleid][vMaterials] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %i materials in your vehicle stash.", value);
   			}
			else if(!strcmp(option, "weed", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [weed] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pWeed])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vWeed] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i grams of weed at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED));
			    }

			    PlayerData[playerid][pWeed] -= value;
			    VehicleInfo[vehicleid][vWeed] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weed = %i WHERE id = %i", VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of weed in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [crack] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pCocaine])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vCocaine] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i grams of crack at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
			    }

			    PlayerData[playerid][pCocaine] -= value;
			    VehicleInfo[vehicleid][vCocaine] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cocaine = %i WHERE id = %i", VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of crack in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "heroin", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [heroin] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pHeroin])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vHeroin] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i grams of heroin at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN));
			    }

			    PlayerData[playerid][pHeroin] -= value;
			    VehicleInfo[vehicleid][vHeroin] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET heroin = %i WHERE id = %i", VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %ig of Heroin in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [painkillers] [amount]");
				}
				if(value < 1 || value > PlayerData[playerid][pPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(VehicleInfo[vehicleid][vPainkillers] + value > GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle's stash can only hold up to %i painkillers at its level.", GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));
			    }

			    PlayerData[playerid][pPainkillers] -= value;
			    VehicleInfo[vehicleid][vPainkillers] += value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %i painkillers in your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new weaponid;

   			    if(sscanf(param, "i", weaponid))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
				}
				if(!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You don't have that weapon. /guninv for a list of your weapons.");
				}
				if(IsLawEnforcement(playerid))
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Law enforcement is prohibited from storing weapons.");
				}
				if(GetPlayerHealthEx(playerid) < 60)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't store weapons as your health is below 60.");
				}

				for(new i = 0; i < GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS); i ++)
				{
					if(!VehicleInfo[vehicleid][vWeapons][i])
   				    {
						VehicleInfo[vehicleid][vWeapons][i] = weaponid;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weapon_%i = %i WHERE id = %i", i + 1, VehicleInfo[vehicleid][vWeapons][i], VehicleInfo[vehicleid][vID]);
						mysql_tquery(connectionID, queryBuffer);

						RemovePlayerWeapon(playerid, weaponid);
						SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored a %s in slot %i of your vehicle stash.", GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]), i + 1);
						return 1;
					}
				}

				SendClientMessage(playerid, COLOR_GREY, "This vehicle has no more slots available for weapons.");
			}
		}
		else if(!strcmp(option, "withdraw", true))
	    {
	        new value;

            if(IsPlayerInAnyVehicle(playerid))
	    	{
	        	return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
			}
	        if(sscanf(param, "s[14]S()[32]", option, param))
	        {
	            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [option]");
	            SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Cash, Weed, Crack, Heroin, Painkillers, Weapon");
	            return 1;
	        }
	        if(!strcmp(option, "cash", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [cash] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vCash])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }

			    GivePlayerCash(playerid, value);
			    VehicleInfo[vehicleid][vCash] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cash = %i WHERE id = %i", VehicleInfo[vehicleid][vCash], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %s from your vehicle stash.", FormatCash(value));
			}
			else if(!strcmp(option, "materials", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [materials] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vMaterials])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				}

			    PlayerData[playerid][pMaterials] += value;
			    VehicleInfo[vehicleid][vMaterials] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET materials = %i WHERE id = %i", VehicleInfo[vehicleid][vMaterials], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %i materials from your vehicle stash.", value);
   			}
			else if(!strcmp(option, "weed", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [weed] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vWeed])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pWeed] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
				}

			    PlayerData[playerid][pWeed] += value;
			    VehicleInfo[vehicleid][vWeed] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weed = %i WHERE id = %i", VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of weed from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "crack", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [crack] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vCocaine])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pCocaine] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i crack. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				}

			    PlayerData[playerid][pCocaine] += value;
			    VehicleInfo[vehicleid][vCocaine] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cocaine = %i WHERE id = %i", VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of crack from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "heroin", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [heroin] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vHeroin])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pHeroin] + value > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
				}

			    PlayerData[playerid][pHeroin] += value;
			    VehicleInfo[vehicleid][vHeroin] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET heroin = %i WHERE id = %i", VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %ig of Heroin from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "painkillers", true))
			{
			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [painkillers] [amount]");
				}
				if(value < 1 || value > VehicleInfo[vehicleid][vPainkillers])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
			    }
			    if(PlayerData[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
			    {
			        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				}

			    PlayerData[playerid][pPainkillers] += value;
			    VehicleInfo[vehicleid][vPainkillers] -= value;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET painkillers = %i WHERE id = %i", VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %i painkillers from your vehicle stash.", value);
   			}
   			else if(!strcmp(option, "weapon", true))
   			{
   			    new slots = GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS);

   			    if(sscanf(param, "i", value))
			    {
			        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /vstash [withdraw] [weapon] [slot (1-%i)]", slots);
				}
				if(!(1 <= value <= slots))
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Invalid slot, or the slot specified is locked.");
   			    }
   			    if(!VehicleInfo[vehicleid][vWeapons][value-1])
   			    {
   			        return SendClientMessage(playerid, COLOR_GREY, "The slot specified contains no weapon which you can take.");
				}
                if(PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
				}

				GivePlayerWeaponEx(playerid, VehicleInfo[vehicleid][vWeapons][value-1]);
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken a %s from slot %i of your vehicle stash.", GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][value-1]), value);

				VehicleInfo[vehicleid][vWeapons][value-1] = 0;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weapon_%i = 0 WHERE id = %i", value, VehicleInfo[vehicleid][vID]);
				mysql_tquery(connectionID, queryBuffer);
			}
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle of yours.");
	}

	return 1;
}

CMD:unmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to you.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /unmod [color | paintjob | mods | neon]");
	}

	if(!strcmp(params, "color", true))
	{
	    VehicleInfo[vehicleid][vColor1] = 0;
	    VehicleInfo[vehicleid][vColor2] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = 0, color2 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehicleColor(vehicleid, 0, 0);
	    SendClientMessage(playerid, COLOR_WHITE, "* Vehicle color has been set back to default.");
	}
	else if(!strcmp(params, "paintjob", true))
	{
	    VehicleInfo[vehicleid][vPaintjob] = -1;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = -1 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehiclePaintjob(vehicleid, 3);
	    SendClientMessage(playerid, COLOR_WHITE, "* Vehicle paintjob has been set back to default.");
	}
	else if(!strcmp(params, "mods", true))
	{
	    for(new i = 0; i < 14; i ++)
	    {
	        if(VehicleInfo[vehicleid][vMods][i] >= 1000)
	        {
	            RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
	        }
	    }

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mod_1 = 0, mod_2 = 0, mod_3 = 0, mod_4 = 0, mod_5 = 0, mod_6 = 0, mod_7 = 0, mod_8 = 0, mod_9 = 0, mod_10 = 0, mod_11 = 0, mod_12 = 0, mod_13 = 0, mod_14 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessage(playerid, COLOR_WHITE, "* All vehicle modifications have been removed.");
	}
	else if(!strcmp(params, "neon", true))
	{
	    if(!VehicleInfo[vehicleid][vNeon])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no neon which you can remove.");
		}

		if(VehicleInfo[vehicleid][vNeonEnabled])
		{
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
		}

		VehicleInfo[vehicleid][vNeon] = 0;
		VehicleInfo[vehicleid][vNeonEnabled] = 0;
		VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neon = 0, neonenabled = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessage(playerid, COLOR_WHITE, "* Neon has been removed from vehicle.");
	}

	return 1;
}

CMD:gunmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle of yours.");
	}
	if(VehicleInfo[vehicleid][vGang] >= 0 && VehicleInfo[vehicleid][vGang] != PlayerData[playerid][pGang])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to your gang.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gunmod [color | paintjob | mods]");
	}

	if(!strcmp(params, "color", true))
	{
	    VehicleInfo[vehicleid][vColor1] = 0;
	    VehicleInfo[vehicleid][vColor2] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = 0, color2 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehicleColor(vehicleid, 0, 0);
	    SendClientMessage(playerid, COLOR_WHITE, "* Vehicle color has been set back to default.");
	}
	else if(!strcmp(params, "paintjob", true))
	{
	    VehicleInfo[vehicleid][vPaintjob] = -1;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = -1 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehiclePaintjob(vehicleid, 3);
	    SendClientMessage(playerid, COLOR_WHITE, "* Vehicle paintjob has been set back to default.");
	}
	else if(!strcmp(params, "mods", true))
	{
	    for(new i = 0; i < 14; i ++)
	    {
	        if(VehicleInfo[vehicleid][vMods][i] >= 1000)
	        {
	            RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
	        }
	    }

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mod_1 = 0, mod_2 = 0, mod_3 = 0, mod_4 = 0, mod_5 = 0, mod_6 = 0, mod_7 = 0, mod_8 = 0, mod_9 = 0, mod_10 = 0, mod_11 = 0, mod_12 = 0, mod_13 = 0, mod_14 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessage(playerid, COLOR_WHITE, "* All vehicle modifications have been removed.");
	}

	return 1;
}

CMD:colorcar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return SendClientMessage(playerid, COLOR_GREY, "You are not inside a vehicle.");

    new color1, color2;
    if(sscanf(params, "dd", color1, color2))
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /colorcar [color1] [color2]");

    if(color1 < 0 || color1 > 255 || color2 < 0 || color2 > 255)
        return SendClientMessage(playerid, COLOR_GREY, "Color values must be between 0 and 255.");

    if(PlayerData[playerid][pSpraycans] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any spraycans.");

    ChangeVehicleColor(vehicleid, color1, color2);
    PlayerData[playerid][pSpraycans]--;

    VehicleInfo[vehicleid][vColor1] = color1;
    VehicleInfo[vehicleid][vColor2] = color2;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %d, color2 = %d WHERE id = %d", color1, color2, VehicleInfo[vehicleid][vID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = %d WHERE uid = %d", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
    ShowActionBubble(playerid, "* %s uses a spraycan to paint the vehicle.", GetRPName(playerid));
    PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
    return 1;
}

CMD:paintcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), paintjobid;

	if(sscanf(params, "i", paintjobid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /paintcar [paintjobid (-1 = none)]");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not sitting inside any vehicle.");
	}
	if(VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid) && !PlayerHasJob(playerid, JOB_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't belong to you, therefore you can't respray it.");
	}
	if(VehicleInfo[vehicleid][vOwnerID] > 0 && !IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pMechanicSkill] < 5)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 5 mechanic to paint cars you dont own.");
	}
	if(!(-1 <= paintjobid <= 5))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The paintjob specified must range between -1 and 5.");
	}
	if(paintjobid == -1) paintjobid = 3;

	if(!PlayerHasJob(playerid, JOB_MECHANIC))
	{
		if(PlayerData[playerid][pSpraycans] <= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
		}
		if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
		{
		    VehicleInfo[vehicleid][vPaintjob] = paintjobid;

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		PlayerData[playerid][pSpraycans]--;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		ShowActionBubble(playerid, "* %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
		ChangeVehiclePaintjob(vehicleid, paintjobid);
		PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
		return 1;
	}
	if(PlayerHasJob(playerid, JOB_MECHANIC))
	{
		if(PlayerData[playerid][pMechanicSkill] < 5)
		{
			if(PlayerData[playerid][pSpraycans] <= 0)
			{
			    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
			}
			if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
			{
			    VehicleInfo[vehicleid][vPaintjob] = paintjobid;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
			    mysql_tquery(connectionID, queryBuffer);
			}
			PlayerData[playerid][pSpraycans]--;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			ShowActionBubble(playerid, "* %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
			SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i spraycans left.", PlayerData[playerid][pSpraycans]);
			ChangeVehiclePaintjob(vehicleid, paintjobid);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			return 1;
		}

		if(PlayerData[playerid][pComponents] <= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough components for this.");
		}

		if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
		{
		    VehicleInfo[vehicleid][vPaintjob] = paintjobid;

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
		    mysql_tquery(connectionID, queryBuffer);
		}
		PlayerData[playerid][pComponents]--;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
		ShowActionBubble(playerid, "* %s sprays the vehicle to a different color.", GetRPName(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "* Vehicle resprayed. You have %i components left.", PlayerData[playerid][pComponents]);
		ChangeVehiclePaintjob(vehicleid, paintjobid);
		PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
	    return 1;
	}
	return 1;
}

CMD:sellcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), targetid, amount;

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}


	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellcar [playerid] [amount]");
	}

	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
	}
	if(PlayerData[playerid][pCP] == CHECKPOINT_DROPCAR)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't sell your vehicle unless you cancel your car delivery. (/killcp)");
	}

	PlayerData[targetid][pCarOffer] = playerid;
	PlayerData[targetid][pCarOffered] = vehicleid;
	PlayerData[targetid][pCarPrice] = amount;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their %s for %s (/accept vehicle).", GetRPName(playerid), GetVehicleName(vehicleid), FormatCash(amount));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your %s for %s.", GetRPName(targetid), GetVehicleName(vehicleid), FormatCash(amount));
	return 1;
}

CMD:sellmycar(playerid, params[])
{
 	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 8.0, 542.0433, -1293.5909, 17.2422))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the Grotti car dealership.");
	}

	new price = percent(GetVehicleValue(vehicleid), 35);

	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmycar [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command permanently deletes your vehicle. You will receive %s back.", FormatCash(price));
	    return 1;
	}

	GivePlayerCash(playerid, price);

	SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your %s to the dealership and received %s back.", GetVehicleName(vehicleid), FormatCash(price));
    Log_Write("log_property", "%s (uid: %i) sold their %s (id: %i) to the dealership for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], price);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	DespawnVehicle(vehicleid, false);

	return 1;
}





CMD:setfreq(playerid, params[])
{
	new channel;

	if(!PlayerData[playerid][pPrivateRadio])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a private radio.");
	}
	if(sscanf(params, "i", channel))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setfreq [freq]");
	}
	if(!(0 <= channel <= 99999))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The channel must range from 0 to 99999.");
	}

	PlayerData[playerid][pChannel] = channel;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET channel = %i WHERE uid = %i", channel, PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	if(channel == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "* You have set the channel to 0 and disabled your private radio.");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "* Channel set to %i Khz, use /pr to broadcast over this channel.", channel);
	}
	CallRemoteFunction("OnRadioFrequencyChange", "ii", playerid, PlayerData[playerid][pChannel] );

	return 1;
}


CMD:managecrew(playerid, params[])
{
	new targetid, crewid, option[10], param[32];

	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /managecrew [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Create, Remove, List, Assign, Kick");
	    return 1;
	}
	if(!strcmp(option, "create", true))
	{
		if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(isnull(param))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [create] [name]");
		}

		for(new i = 0; i < MAX_GANG_CREWS; i ++)
		{
		    if(isnull(GangCrews[PlayerData[playerid][pGang]][i]))
		    {
		        strcpy(GangCrews[PlayerData[playerid][pGang]][i], param, 32);
		        SendClientMessageEx(playerid, COLOR_AQUA, "You have created crew {FFA763}%s{33CCFF}. The ID of this crew is %i.", param, i);

		        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO crews VALUES(%i, %i, '%e')", PlayerData[playerid][pGang], i, param);
		        mysql_tquery(connectionID, queryBuffer);
		        return 1;
			}
		}

		SendClientMessageEx(playerid, COLOR_GREY, "Your gang can only have up to %i crews.", MAX_GANG_CREWS);
	}
	else if(!strcmp(option, "remove", true))
	{
	    if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(sscanf(param, "i", crewid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [remove] [crewid]");
		}
		if(!(0 <= crewid < MAX_GANG_CREWS) || isnull(GangCrews[PlayerData[playerid][pGang]][crewid]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid crew ID.");
	    }

	    foreach(new i : Player)
	    {
	        if(PlayerData[i][pGang] == PlayerData[playerid][pGang] && PlayerData[i][pCrew] == crewid)
	        {
	            PlayerData[i][pCrew] = -1;
	            SendClientMessage(i, COLOR_LIGHTRED, "The crew you were apart of has been deleted by the gang owner.");
		    }
		}

		SendClientMessageEx(playerid, COLOR_AQUA, "You have deleted crew {F7A763}%s{33CCFF} (%i).", GangCrews[PlayerData[playerid][pGang]][crewid], crewid);
		GangCrews[PlayerData[playerid][pGang]][crewid][0] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM crews WHERE id = %i AND crewid = %i", PlayerData[playerid][pGang], crewid);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET crew = -1 WHERE gang = %i", PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "list", true))
	{
	    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Crews List _____");

	    for(new i = 0; i < MAX_GANG_CREWS; i ++)
	    {
	        if(isnull(GangCrews[PlayerData[playerid][pGang]][i]))
	        {
	            SendClientMessageEx(playerid, COLOR_GREY1, "ID: %i | Name: Empty Slot", i);
	        }
	        else
	        {
	            SendClientMessageEx(playerid, COLOR_GREY1, "ID: %i | Name: %s", i, GangCrews[PlayerData[playerid][pGang]][i]);
	        }
	    }
	}
	else if(!strcmp(option, "assign", true))
	{
	    if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(sscanf(param, "ui", targetid, crewid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [assign] [playerid] [crewid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
		{
			return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
		}
		if(!(0 <= crewid < MAX_GANG_CREWS) || isnull(GangCrews[PlayerData[playerid][pGang]][crewid]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid crew ID.");
	    }
	    if(PlayerData[targetid][pCrew] == crewid)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of that crew.");
	    }
	    if(PlayerData[targetid][pCrew] >= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of another crew.");
	    }

	    PlayerData[targetid][pCrew] = crewid;

	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has assigned you to the {F7A763}%s{33CCFF} crew.", GetRPName(playerid), GangCrews[PlayerData[playerid][pGang]][crewid]);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have assigned %s to the {F7A763}%s{33CCFF} crew.", GetRPName(targetid), GangCrews[PlayerData[playerid][pGang]][crewid]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET crew = %i WHERE uid = %i", crewid, PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "kick", true))
	{
	    if(PlayerData[playerid][pGangRank] < 5)
		{
		    return SendClientErrorNoPermission(playerid);
		}
		if(sscanf(param, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [kick] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
		{
			return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
		}
	    if(PlayerData[targetid][pCrew] == -1)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of any crew.");
	    }

	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed you from the {F7A763}%s{33CCFF} crew.", GetRPName(playerid), GangCrews[PlayerData[playerid][pGang]][PlayerData[targetid][pCrew]]);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s from the {F7A763}%s{33CCFF} crew.", GetRPName(targetid), GangCrews[PlayerData[playerid][pGang]][PlayerData[targetid][pCrew]]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET crew = -1 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

        PlayerData[targetid][pCrew] = -1;
	}

	return 1;
}


CMD:cells(playerid, params[])
{
	new status;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}

    for(new i = 0; i < sizeof(gPrisonCells); i ++)
	{
		if(!Streamer_GetExtraInt(gPrisonCells[i], E_OBJECT_OPENED))
		{
		    MoveDynamicObject(gPrisonCells[i], cellPositions[i][3], cellPositions[i][4], cellPositions[i][5], 2.0);
		    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 1);
		    status = true;
		}
		else
		{
		    MoveDynamicObject(gPrisonCells[i], cellPositions[i][0], cellPositions[i][1], cellPositions[i][2], 2.0);
		    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 0);
		    status = false;
		}
	}

	if(status)
		SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has opened all cells in the prison.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
	else
	    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has closed all cells in the prison.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));

	return 1;
}

CMD:cell(playerid, params[])
{
	if(!IsLawEnforcement(playerid))
	{
		return SendClientErrorUnautorizedCell(playerid);
	}

	for(new i = 0; i < sizeof(gPrisonCells); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, cellPositions[i][0], cellPositions[i][1], cellPositions[i][2]))
		{
			if(!Streamer_GetExtraInt(gPrisonCells[i], E_OBJECT_OPENED))
			{
			    ShowActionBubble(playerid, "* %s uses their key to open the cell door.", GetRPName(playerid));
			    MoveDynamicObject(gPrisonCells[i], cellPositions[i][3], cellPositions[i][4], cellPositions[i][5], 2.0);
			    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 1);
			}
			else
			{
			    ShowActionBubble(playerid, "* %s uses their key to close the cell door.", GetRPName(playerid));
			    MoveDynamicObject(gPrisonCells[i], cellPositions[i][0], cellPositions[i][1], cellPositions[i][2], 2.0);
			    Streamer_SetExtraInt(gPrisonCells[i], E_OBJECT_OPENED, 0);
			}

			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any prison cells.");
	return 1;
}

CMD:door(playerid, params[])
{
	if(!DoorCheck(playerid))
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any door which you can open.");
	}

	return 1;
}

CMD:gate(playerid, params[])
{
    new gateid = GetNearbyGate(playerid);

    if (gateid == -1)
    {
        return -1;
    }

    ToggleGate(playerid, gateid);
    return 1;
}

CMD:frisk(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /frisk [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
    if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot frisk yourself.");
	}

	if((IsLawEnforcement(playerid) && PlayerData[targetid][pCuffed]) || GetPlayerAnimationIndex(targetid) == 1441)
	{
	    FriskPlayer(playerid, targetid);
	}
	else
	{
	    PlayerData[targetid][pFriskOffer] = playerid;

	    SendClientMessageEx(targetid, COLOR_AQUA, "* %s is attempting to frisk you for illegal items. (/accept frisk)", GetRPName(playerid));
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent a frisk offer to %s.", GetRPName(targetid));
	}

	return 1;
}

CMD:propose(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /propose [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 3.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 2241.9761,-1362.9207,1500.9048))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in church.");
	}
	if(PlayerData[playerid][pCash] < 25000 || PlayerData[targetid][pCash] < 25000)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You both need to have atleast $25,000 to have a wedding.");
	}
	if(PlayerData[playerid][pMarriedTo] != -1)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're already married to %s.", PlayerData[playerid][pMarriedName]);
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't marry yourself faggot.");
	}
	PlayerData[targetid][pMarriageOffer] = playerid;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has asked you to marry them, Please be careful when chosing a partner, It will cost both parties $25,000. (/accept marriage)", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a proposal for marriage.", GetRPName(targetid));
	return 1;
}
CMD:divorce(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /divorce [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 3.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(PlayerData[playerid][pMarriedTo] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't even married.");
	}
	if(PlayerData[playerid][pMarriedTo] != PlayerData[targetid][pID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't married to that person.");
	}
	PlayerData[targetid][pMarriageOffer] = playerid;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has asked you to divorce them (/accept divorce)", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a request for divorce.", GetRPName(targetid));
	return 1;
}
CMD:saveaccounts(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	foreach(new i : Player)
	{
	    SavePlayerVariables(i);
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has saved all player accounts.", GetRPName(playerid));
	return 1;
}

CMD:adestroyboombox(playerid, params[])
{
	new boomboxid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if((boomboxid = GetNearbyBoombox(playerid)) == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no boombox in range.");
	}

	SendClientMessageEx(playerid, COLOR_AQUA, "You have destroyed {00AA00}%s{33CCFF}'s boombox.", GetRPName(boomboxid));
	DestroyBoombox(boomboxid);

	return 1;
}

CMD:setbanktimer(playerid, params[])
{
	new hours;

    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", hours))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setbanktimer [hours]");
	}
	if(hours < 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Hours can't be below 0.");
	}

	RobberyInfo[rTime] = hours;
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the bank robbery timer to %i hours.", GetRPName(playerid), hours);
	return 1;
}

CMD:resetrobbery(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	ResetRobbery();
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the active bank robbery.", GetRPName(playerid));
	return 1;
}

CMD:addtorobbery(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /addtorobbery [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!RobberyInfo[rPlanning] && !RobberyInfo[rStarted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no bank robbery in progress.");
	}
    if(GetBankRobbers() >= MAX_BANK_ROBBERS)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "There can't be more than %i bank robbers in this robbery.", MAX_BANK_ROBBERS);
 	}
 	if(IsPlayerInBankRobbery(targetid))
 	{
 	    return SendClientMessage(playerid, COLOR_GREY, "That player is already in the bank robbery.");
   	}

 	AddToBankRobbery(targetid);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has added %s to the bank robbery.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_AQUA, "%s has added you to the bank robbery.", GetRPName(playerid));
	return 1;
}

CMD:givepayday(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givepayday [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	SendPaycheck(targetid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced a payday for %s.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:givepveh(playerid, params[])
{
    return callcmd::givepvehicle(playerid, params);
}
CMD:givepcar(playerid, params[])
{
    return callcmd::givepvehicle(playerid, params);
}
CMD:givepvehicle(playerid, params[])
{
	new model[20], modelid, targetid, color1, color2, Float:x, Float:y, Float:z, Float:a, plate[32];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[20]ii", targetid, model, color1, color2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givepveh [playerid] [modelid/name] [color1] [color2]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if((modelid = GetVehicleModelByName(model)) == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle model.");
	}
	if(!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid color. Valid colors range from 0 to 255.");
	}

	GetPlayerPos(targetid, x, y, z);
	GetPlayerFacingAngle(targetid, a);
	format(plate, 32, "%c%c%c %i", Random('A', 'Z'), Random('A', 'Z'), Random('A', 'Z'), Random(100, 999));

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, plate, color1, color2, carImpounded) VALUES(%i, '%s', %i, '%f', '%f', '%f', '%f', '%s', %i, %i, '0')", PlayerData[targetid][pID], GetPlayerNameEx(targetid), modelid, x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a, mysql_escaped(plate), color1, color2);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you your own {00AA00}%s{33CCFF}. /carstorage to spawn it.", GetRPName(playerid), GetVehicleNameByModel(modelid));
	SendClientMessageEx(playerid, COLOR_AQUA, "You have given %s their own {00AA00}%s{33CCFF}.", GetRPName(targetid), GetVehicleNameByModel(modelid));

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s their own %s.", GetRPName(playerid), GetRPName(targetid), GetVehicleNameByModel(modelid));
	Log_Write("log_admin", "%s (uid: %i) has given %s (uid: %i) their own %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetVehicleNameByModel(modelid));
	return 1;
}

CMD:givedoublexp(playerid, params[])
{
	new targetid, hours;

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "ui", targetid, hours))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givedoublexp [playerid] [hours]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}
	if(hours < 1 && PlayerData[targetid][pDoubleXP] - hours < 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player can't have under 0 hours of double XP.");
	}

	PlayerData[targetid][pDoubleXP] += hours;

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %i hours of double XP to %s.", GetRPName(playerid), hours, GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_YELLOW, "%s has given you %i hours of double XP.", GetRPName(playerid), hours);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET doublexp = %i WHERE uid = %i", PlayerData[targetid][pDoubleXP], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

/*CMD:number(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /number [playerid]");
	}
	if(!PlayerData[playerid][pPhonebook])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a phonebook.");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

    ShowActionBubble(playerid, "* %s takes out a cellphone and looks up a number.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_GREY2, "* %s (%i)", GetRPName(targetid), PlayerData[targetid][pPhone]);
	return 1;
}*/

stock SendWeaponsCraftingCost(playerid)
{
    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ Weapons Crafting _______");

    if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 1)
    {
		SendClientMessage(playerid, COLOR_WHITE, "Level 1: Bat [200], Shovel [200], Dildo [50], Flowers [50], Cane [200]");
		SendClientMessage(playerid, COLOR_WHITE, "Level 1: 9mm [500], Sdpistol [750], Shotgun [2000]");
        if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 2)
        {
            SendClientMessage(playerid, COLOR_WHITE, "Level 2: Uzi [3500], Rifle [8000]");
            if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 3)
            {
                SendClientMessage(playerid, COLOR_WHITE, "Level 3: PoolCue [200], AK-47 [8000], Tec-9 [4500], Deagle [5000]");
                if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 4)
                {
                    SendClientMessage(playerid, COLOR_WHITE, "Level 4: GolfClub [200], MP5 [5000], M4 [10000]");
                }
            }
        }
    }
    if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 5 || PlayerData[playerid][pDonator] >= 3)
    {
        if (PlayerData[playerid][pDonator] >= 3)
        {
            SendClientMessage(playerid, COLOR_VIP, "(VIP){FFFFFF} Level 5: Katana [15000], Spas12 [10000], Sniper [10000]");
        }
        else
        {
            SendClientMessage(playerid, COLOR_WHITE, "Level 5: Katana [20000], Sniper [12000]");
        }
    }
}

CMD:gsellgun(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1 || !GangInfo[PlayerData[playerid][pGang]][gIsMafia])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Only mafia can use this command.");
	}

	// For Gangs Leaders Can Craft
    /*if (!PlayerData[playerid][pGangLeader])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need gang leadership to craft weapons.");
    }
    if(!IsPlayerInRangeOfPoint(playerid, 3.0,  2490.970458, -1668.314819, 3003.500000) && !IsPlayerInRangeOfPoint(playerid, 3.0,  2402.145263, -1668.372314, 3003.500000) && !IsPlayerInRangeOfPoint(playerid, 3.0,  2267.837890, -1668.380737, 3003.500000) && !IsPlayerInRangeOfPoint(playerid, 3.0,  2333.931640, -1668.372680, 3003.500000))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the craft table.");
	}*/

	if(!IsPlayerInRangeOfPoint(playerid, 4.0,  1332.7495, 1568.4010, 1030.9145))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the craft table.");
	}
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons from within a vehicle.");
    }
    if (gettime() - PlayerData[playerid][pLastSell] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
    }
    new targetid, weapon[10], qty, price;
    if (sscanf(params, "us[10]ii", targetid, weapon, qty, price))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "[Usage]: /gsellgun [playerid] [weapon_name] [quantity] [price]");
        SendWeaponsCraftingCost(playerid);
        return 1;
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot craft this weapons to your gang by yourself.");
    }
    if (qty <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid quantity.");
    }
    if (qty > 60)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Max quantity 20.");
    }
    if (price < 750)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $750.");
    }

    static weaponargs[][eCraftWeaponArgs] = {
        {/*Level*/ 1, "9mm",        22},
        {/*Level*/ 1, "Sdpistol",   23},
        {/*Level*/ 1, "Shotgun",    25},
        {/*Level*/ 2, "Uzi",        28},
        {/*Level*/ 2, "Rifle",      33},
        {/*Level*/ 3, "AK-47",      30},
        {/*Level*/ 3, "Tec-9",      32},
        {/*Level*/ 3, "Deagle",     24},
        {/*Level*/ 4, "MP5",        29},
        {/*Level*/ 4, "M4",         31},
        {/*Level*/ 5, "Spas12",     27},
        {/*Level*/ 5, "Sniper",     34}
    };

    for (new i=0;i<sizeof(weaponargs);i++)
    {
        if (!strcmp(weapon, weaponargs[i][cwa_Name], true))
        {
            if (GetJobLevel(playerid, JOB_ARMSDEALER) < weaponargs[i][cwa_Level])
            {
                return SendClientMessage(playerid, COLOR_GREY, "Your skill level is not high enough to craft this weapon.");
            }
            new weaponid = weaponargs[i][cwa_WeaponID];
            new unitcost = GetCraftWeaponPrice(playerid, weaponid);
            new cost = unitcost * qty;

            if (unitcost == -1)
            {
                return SendClientMessageEx(playerid, COLOR_AQUA, "You cannot craft this weapon {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
            }
            if (PlayerData[playerid][pMaterials] < cost)
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You need %s materials to craft this weapons.", FormatNumber(cost));
            }

            PlayerData[playerid][pLastSell]     = gettime();
            PlayerData[targetid][pSellOffer]    = playerid;
            PlayerData[targetid][pSellType]     = ITEM_GSELLGUN;
            PlayerData[targetid][pSellExtra]    = weaponid;
            PlayerData[targetid][pSellPrice]    = price;
            PlayerData[targetid][pSellQuantity] = qty;

            SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %d %s for $%i. (/accept gangweapons)", GetRPName(playerid), qty, GetWeaponNameEx(weaponid), price);
            SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %d %s to %s for $%i.", qty, GetWeaponNameEx(weaponid), GetRPName(targetid), price);
            break;
        }
    }
    return 1;
}

CMD:switchspeedo(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /switchspeedo [kmh/mph]");
	}
	if(!strcmp(params, "kmh", true))
	{
		PlayerData[playerid][pSpeedometer] = 1;
		SendClientMessage(playerid, COLOR_AQUA, "Your speedometer will now display speed as {00AA00}Kilometers per hour{33CCFF}.");

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET speedometer = 1 WHERE uid = %i", PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(params, "mph", true))
	{
		PlayerData[playerid][pSpeedometer] = 2;
		SendClientMessage(playerid, COLOR_AQUA, "Your speedometer will now display speed as {00AA00}Miles per hour{33CCFF}.");

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET speedometer = 2 WHERE uid = %i", PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

CMD:shakehand(playerid, params[])
{
	new targetid, type;

	if(sscanf(params, "ui", targetid, type))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /shakehand [playerid] [type (1-6)]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't shake your own hand.");
	}
	if(!(1 <= type <= 6))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type. Valid types range from 1 to 6.");
	}

	PlayerData[targetid][pShakeOffer] = playerid;
	PlayerData[targetid][pShakeType] = type;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has offered to shake your hand. (/accept handshake)", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a handshake offer.", GetRPName(targetid));
	return 1;
}

CMD:dropgun(playerid, params[])
{
	new weaponid = GetScriptWeapon(playerid), objectid, Float:x, Float:y, Float:z;

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to drop weapons.");
	}
	if(!weaponid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be holding the weapon you're willing to drop.");
	}
	if(PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell this weapon as you don't have it.");
	}
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(GetPlayerHealthEx(playerid) < 60)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't drop weapons as your health is below 60.");
	}

	GetPlayerPos(playerid, x, y, z);

	new weaponmodelid = GetWeaponModelID(weaponid);
	
	if(!weaponmodelid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Internal error: Cannot get weapon model id.");
	}
	objectid = CreateDynamicObject(weaponmodelid, x, y, z - 1.0, 93.7, 93.7, 120.0);
 	SetTimerEx("DestroyWeapon", 300000, false, "i", objectid);
	Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_WEAPON);
	Streamer_SetExtraInt(objectid, E_OBJECT_WEAPONID, weaponid);
	Streamer_SetExtraInt(objectid, E_OBJECT_FACTION, PlayerData[playerid][pFaction]);
	RemovePlayerWeapon(playerid, weaponid);



	ShowActionBubble(playerid, "* %s drops their %s on the ground.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	SendClientMessageEx(playerid, COLOR_AQUA, "You have dropped your {00AA00}%s{33CCFF}.", GetWeaponNameEx(weaponid));
	return 1;
}

CMD:grabgun(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to pickup weapons.");
	}
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	new turfid = GetNearbyTurf(playerid);
	if(turfid >= 0 && IsActiveTurf(turfid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't grab a player in an active turf.");
    }
    if(PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }

	for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
	    if(!IsValidDynamicObject(i) || !IsPlayerInRangeOfDynamicObject(playerid, i, 2.0) || Streamer_GetExtraInt(i, E_OBJECT_TYPE) != E_OBJECT_WEAPON)
			continue;

	    if(Streamer_GetExtraInt(i, E_OBJECT_FACTION) >= 0 && PlayerData[playerid][pFaction] != Streamer_GetExtraInt(i, E_OBJECT_FACTION))
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This weapon belongs to a specific faction. You may not pick it up.");
	    }

	    new weaponid = Streamer_GetExtraInt(i, E_OBJECT_WEAPONID);

	    GivePlayerWeaponEx(playerid, weaponid);
	    DestroyDynamicObject(i);

	    ShowActionBubble(playerid, "* %s picks up a %s from the ground.", GetRPName(playerid), GetWeaponNameEx(weaponid));
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have picked up a {00AA00}%s{33CCFF}.", GetWeaponNameEx(weaponid));
	    return 1;
	}
	new targetid = GetClosestPlayer(playerid);
	if(IsPlayerConnected(targetid) && PlayerData[targetid][pInjured] && IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
		if(GetPlayerFaction(targetid) == FACTION_HITMAN && GetPlayerFaction(playerid) != FACTION_HITMAN)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You cannot steal weapon from this player.");
		}
		new weaponid = strval(params);
		if(weaponid && PlayerHasWeapon(targetid, weaponid, true))
		{
			if(PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)])
			{
				return SendClientMessage(playerid, COLOR_GREY, "You already have a weapon in this slot.");
			}
			if(weaponid > 34)
			{
				return SendClientMessage(playerid, COLOR_GREY, "You cannot steal this weapon.");
			}
			if((PlayerData[playerid][pFaction] == -1 && PlayerData[targetid][pFaction] != -1) ||
			   (PlayerData[playerid][pFaction] != -1 && PlayerData[targetid][pFaction] == -1))
			{
				return SendClientMessage(playerid, COLOR_GREY, "You cannot steal this weapon.");
			}
			RemovePlayerWeapon(targetid, weaponid);
	    	GivePlayerWeaponEx(playerid, weaponid);
			SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s has stole the %s from %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s's Weapons _______", GetRPName(targetid));

			for(new i = 0; i < 13; i ++)
			{
				new weapon, ammo;

				GetPlayerWeaponData(targetid, i, weapon, ammo);

				if(weapon && PlayerHasWeapon(targetid, weapon, true))
				{
					SendClientMessageEx(playerid, COLOR_GREY2, "-> %i %s",weapon, GetWeaponNameEx(weapon));
				}
			}
			SendUsageHeader(playerid, "grabgun", "[weaponid]");
			return 1;
		}
	}
	
	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any dropped weapons.");
	return 1;
}

CMD:grabskin(playerid, params[])
{
    if (PlayerData[playerid][pLevel] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only use this command if you are level 2+.");
    }
	new turfid = GetNearbyTurf(playerid);
	if(turfid >= 0 && IsActiveTurf(turfid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't grab a player in an active turf.");
    }
    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot do that for the moment.");
    }

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to pickup skin.");
    }

    new targetid = GetClosestPlayer(playerid);
    if (IsPlayerConnected(targetid) && PlayerData[targetid][pInjured] && IsPlayerNearPlayer(playerid, targetid, 5.0))
    {

        if ((PlayerData[playerid][pFaction] == -1 && PlayerData[targetid][pFaction] != -1) ||
            (PlayerData[playerid][pFaction] != -1 && PlayerData[targetid][pFaction] == -1))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot take this clothes.");
        }
        SetScriptSkin(playerid, PlayerData[targetid][pSkin]);
        SetScriptSkin(targetid, (PlayerData[targetid][pGender] == 1) ? 40 : 200);
        SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s has stole %s's clothes.", GetRPName(playerid), GetRPName(targetid));
        return 1;
    }
    return 1;
}

CMD:createland(playerid, params[])
{
	new price;

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", price))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createland [price]");
	}
	if(price < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
	}
	if(GetNearbyLand(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a land in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot create lands indoors.");
	}

	PlayerData[playerid][pLandCost] = price;
	PlayerData[playerid][pZoneType] = ZONETYPE_LAND;
	Dialog_Show(playerid, DIALOG_CREATEZONE, DIALOG_STYLE_MSGBOX, "Land creation system", "You have entered land creation mode. In order to create a land you need\nto mark four points around the area you want your land to be in, forming\na square. You must make a square or your outcome won't be as expected.\n\nPress {00AA00}Confirm{A9C4E4} to begin land creation.", "Confirm", "Cancel");
	return 1;
}

CMD:confirm(playerid, params[])
{
	new Float:x, Float:y, Float:z;

    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pZoneCreation])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not creating any land or turf at the moment.");
	}

    if(PlayerData[playerid][pMinX] == 0.0)
	{
        GetPlayerPos(playerid, PlayerData[playerid][pMinX], y, z);
        PlayerData[playerid][pZonePickups][0] = CreateDynamicPickup(1239, 1, PlayerData[playerid][pMinX], y, z, .playerid = playerid);
		SendClientMessage(playerid, COLOR_WHITE, "* Boundary 1/4 set (min X).");
	}
	else if(PlayerData[playerid][pMinY] == 0.0)
	{
        GetPlayerPos(playerid, x, PlayerData[playerid][pMinY], z);
        PlayerData[playerid][pZonePickups][1] = CreateDynamicPickup(1239, 1, x, PlayerData[playerid][pMinY], z, .playerid = playerid);
        SendClientMessage(playerid, COLOR_WHITE, "* Boundary 2/4 set (min Y).");
	}
	else if(PlayerData[playerid][pMaxX] == 0.0)
	{
        GetPlayerPos(playerid, PlayerData[playerid][pMaxX], y, z);
        PlayerData[playerid][pZonePickups][2] = CreateDynamicPickup(1239, 1, PlayerData[playerid][pMaxX], y, z, .playerid = playerid);
        SendClientMessage(playerid, COLOR_WHITE, "* Boundary 3/4 set (max X).");
	}
	else if(PlayerData[playerid][pMaxY] == 0.0)
	{
        GetPlayerPos(playerid, x, PlayerData[playerid][pMaxY], z);
        SendClientMessage(playerid, COLOR_WHITE, "* Boundary 4/4 set (max Y).");

        PlayerData[playerid][pZonePickups][3] = CreateDynamicPickup(1239, 1, x, PlayerData[playerid][pMaxY], z, .playerid = playerid);
        PlayerData[playerid][pZoneID] = GangZoneCreate(PlayerData[playerid][pMinX], PlayerData[playerid][pMinY], PlayerData[playerid][pMaxX], PlayerData[playerid][pMaxY]);

        GangZoneShowForPlayer(playerid, PlayerData[playerid][pZoneID], COLOR_LAND);

        if(PlayerData[playerid][pZoneCreation] == ZONETYPE_LAND) {
	        Dialog_Show(playerid, DIALOG_CONFIRMZONE, DIALOG_STYLE_MSGBOX, "Land creation system", "You have set the four boundary points. The green zone on your mini-map\nrepresents the area of your land. You can choose to start over or complete\nthe creation of your land.\n\nWhat would you like to do now?", "Create", "Restart");
		} else if(PlayerData[playerid][pZoneCreation] == ZONETYPE_TURF) {
		}
	}else if(PlayerData[playerid][pZoneCreation] == ZONETYPE_TURF) {
	        GetPlayerPos(playerid, PlayerData[playerid][pTurfPointX], PlayerData[playerid][pTurfPointY], PlayerData[playerid][pTurfPointZ]);			
	        Dialog_Show(playerid, DIALOG_CONFIRMZONE, DIALOG_STYLE_MSGBOX, "Turf creation system", "You have set the four boundary points. The green zone on your mini-map\nrepresents the area of your turf. You can choose to start over or complete\nthe creation of your turf.\n\nWhat would you like to do now?", "Create", "Restart");	
	}

	return 1;
}

CMD:landcancel(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(PlayerData[playerid][pZoneCreation] != ZONETYPE_LAND)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not creating a land at the moment.");
	}

	CancelZoneCreation(playerid);
	SendClientMessage(playerid, COLOR_LIGHTRED, "* Land creation cancelled.");
	return 1;
}

CMD:gotoland(playerid, params[])
{
	new landid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }
	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoland [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:removelandobjects(playerid, params[])
{
	new landid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelandobjects [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
	}

	RemoveAllLandObjects(landid);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed all land objects for land %i.", landid);
	UpdateLandText(landid);
	return 1;
}

CMD:removeland(playerid, params[])
{
	new landid;

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", landid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeland [landid]");
	}
	if(!(0 <= landid < MAX_LANDS) || !LandInfo[landid][lExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid land.");
	}

	RemoveAllLandObjects(landid);

	GangZoneDestroy(LandInfo[landid][lGangZone]);
	DestroyDynamicArea(LandInfo[landid][lArea]);
	DestroyDynamic3DTextLabel(LandInfo[landid][lTextdraw]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM lands WHERE id = %i", LandInfo[landid][lID]);
	mysql_tquery(connectionID, queryBuffer);

	LandInfo[landid][lID] = 0;
	LandInfo[landid][lExists] = 0;
	LandInfo[landid][lOwnerID] = 0;
	Iter_Remove(Land, landid);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed land %i.", landid);

	Log_Write("log_land", "%s (uid: %i) has removed land (id: %i) land owner (%i).", GetRPName(playerid), PlayerData[playerid][pID], landid, PlayerData[LandInfo[landid][lOwner]][pID]);
	return 1;
}

CMD:buyland(playerid, params[])
{
	new landid = GetNearbyLand(playerid);

	if(landid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands.");
    }
    if(LandInfo[landid][lOwnerID] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This land is already owned.");
	}
    if(strcmp(params, "confirm", true))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /buyland [confirm] (This land costs %s.)", FormatCash(LandInfo[landid][lPrice]));
	}
	if(PlayerData[playerid][pCash] < LandInfo[landid][lPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this land.");
	}

    SetLandOwner(landid, playerid);
	GivePlayerCash(playerid, -LandInfo[landid][lPrice]);

	SendClientMessageEx(playerid, COLOR_GREEN, "You paid %s for this land! /landhelp to see the available commands for your land.", FormatCash(LandInfo[landid][lPrice]));
	Log_Write("log_property", "%s (uid: %i) purchased a land (id: %i) in %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], LandInfo[landid][lID], GetPlayerZoneName(playerid), LandInfo[landid][lPrice]);
	return 1;
}

CMD:sellland(playerid, params[])
{
	new landid = GetNearbyLand(playerid), targetid, amount;

    if(landid == -1 || !IsLandOwner(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands of yours.");
    }
    if(sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellland [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
	}

	PlayerData[targetid][pLandOffer] = playerid;
	PlayerData[targetid][pLandOffered] = landid;
	PlayerData[targetid][pLandPrice] = amount;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you to buy their land for %s. (/accept land)", GetRPName(playerid), FormatCash(amount));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You offered %s to buy your land for %s.", GetRPName(targetid), FormatCash(amount));
	return 1;
}

CMD:sellmyland(playerid, params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !IsLandOwner(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands of yours.");
    }
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmyland [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your land back to the state. You will receive %s back.", FormatCash(percent(LandInfo[landid][lPrice], 75)));
	    return 1;
	}

	SetLandOwner(landid, INVALID_PLAYER_ID);
	GivePlayerCash(playerid, percent(LandInfo[landid][lPrice], 75));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your land to the state and received %s back.", FormatCash(percent(LandInfo[landid][lPrice], 75)));
    Log_Write("log_property", "%s (uid: %i) sold their land (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], LandInfo[landid][lID], percent(LandInfo[landid][lPrice], 75));
	return 1;
}

CMD:landinfo(playerid, params[])
{
    new landid = GetNearbyLand(playerid);

	if(landid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands.");
    }

    if(!LandInfo[landid][lOwnerID])
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "* This land is currently not owned and is for sale, price: {00AA00}$%i{FFFFFF}.", LandInfo[landid][lPrice]);
	}
	else if(!IsLandOwner(playerid, landid))
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "* This land is owned by %s.", LandInfo[landid][lOwner]);
	}
	else
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
    	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LAND_INFORMATION, playerid);
	}

	return 1;
}
CMD:landperms(playerid, params[])
{
    new targetid, landid;

	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "ui", targetid, landid))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /landperms [playerid] [landid (-1 to remove)]");
	}
	if(MAX_LANDS > landid > -1)
	{
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you temporary access to land #%i's keys.", GetRPName(playerid), landid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have given temporary %s access to %i.", GetRPName(targetid), landid);
		PlayerData[targetid][pLandPerms] = landid;
	}
	else if(landid == -1)
	{
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken away your temporary land keys.", GetRPName(playerid));
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have taken %s's temporary land access.", GetRPName(targetid));
		PlayerData[targetid][pLandPerms] = -1;
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET landkeys = %i WHERE uid = %i",PlayerData[targetid][pLandPerms], PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:droplandkeys(playerid, params[])
{
    if(PlayerData[playerid][pLandPerms] > -1)
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "You have dropped land %i's keys.", PlayerData[playerid][pLandPerms]);
        PlayerData[playerid][pLandPerms] = -1;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET landkeys = -1 WHERE uid = %i", PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
    }
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "You don't have keys to a land.");
	}
	return 1;
}

CMD:land(playerid, params[])
{
	new landid = GetNearbyLand(playerid);

	if(landid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any lands of yours.");
    }
    if(!HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have permission to build in this land.");
	}

	ShowDialogToPlayer(playerid, DIALOG_LANDMENU);
	return 1;
}
CMD:setlandobj(playerid,params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }
	
	new axecontrol[10],objectid;
	new float:val;
	
	if(sscanf(params,"is[10]f",objectid,axecontrol,val))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setlandobj [objectid] [Z-RX-RY-RZ] [value]");
	}

	if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
	}
	if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
	}

	if(!strcmp(axecontrol,"z", true))
    {
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET pos_z = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
	}
    else if(!strcmp(axecontrol,"rx", true))
    {
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET rot_x = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
	}
    else if(!strcmp(axecontrol,"ry", true))
    {
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET rot_y = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
	}
    else if(!strcmp(axecontrol,"rz", true))
    {
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE landobjects SET rot_z = '%f' WHERE id = %i",val, Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
	}
	else
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setlandobj [objectid] [z-rx-ry-rz] [value]");
	}
	mysql_tquery(connectionID, queryBuffer);
	ReloadLandObject(objectid, LandInfo[landid][lLabels]);
	
	return SendClientMessageEx(playerid, COLOR_GREY, "The object %d has been updated.",objectid);	
}

CMD:checklandobj(playerid,params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }
	
	new objectid;

	if(sscanf(params, "i", objectid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checklandobj [objectid]");
	}
	if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
	}
	if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
	}
	PlayerData[playerid][pSelected] = objectid;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, modelid, pos_x,pos_y,pos_z,rot_x,rot_y,rot_z FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LANDOBJECT_INFO, playerid);
	return 1;
}

CMD:editlandobj(playerid,params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }
	
	new objectid;

	if(sscanf(params, "i", objectid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlandobj [objectid]");
	}
	if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
	}
	if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
	}

	PlayerData[playerid][pSelected] = objectid;
	if(Streamer_GetExtraInt(objectid, E_OBJECT_OPENED))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't edit your gate while it is opened.");
	}

	PlayerData[playerid][pEditType] = EDIT_LAND_OBJECT;
	PlayerData[playerid][pEditObject] = objectid;
	PlayerData[playerid][pObjectLand] = landid;

	EditDynamicObject(playerid, objectid);
	GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
	return 1;
}

CMD:duplandobj(playerid,params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }
	
	new objectid;

	if(sscanf(params, "i", objectid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /duplandobj [objectid]");
	}
	if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
	}
	if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
	}

	PlayerData[playerid][pSelected] = objectid;
	PlayerData[playerid][pObjectLand] = landid;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM landobjects WHERE landid = %i", LandInfo[landid][lID]);
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_DUPLICATE_LANDOBJ, playerid);
	return 1;
}

CMD:selllandobj(playerid,params[])
{
	new landid = GetNearbyLand(playerid);

    if(landid == -1 || !HasLandPerms(playerid, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near a land that you have access to it.");
    }
	
	new objectid;
	if(sscanf(params, "i", objectid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelandobj [objectid]");
	}
	if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_LAND)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. You can find out an object's ID by enabling labels.");
	}
	if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != LandInfo[landid][lID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Invalid object. This land object is not apart of your land.");
	}

	PlayerData[playerid][pSelected] = objectid;
	
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, price FROM landobjects WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
	mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_SELL_LANDOBJECT, playerid);
	return 1;
}

CMD:changename(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1396.207641,-4.224958,1000.853515))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the desk at city hall.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /changename [new name]");
	}
	if(!(3 <= strlen(params) <= 20))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your name must range from 3 to 20 characters.");
	}
	if(strfind(params, "_") == -1 ||  params[strlen(params)-1] == '_')
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your name needs to contain at least one underscore.");
	}
	if(!IsValidUsername(params))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid characters. Your name may only contain letters and underscores.");
	}
	if(PlayerData[playerid][pCash] < PlayerData[playerid][pLevel] * 7500)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need at least %s to change your name at your level.", FormatCash(PlayerData[playerid][pLevel] * 7500));
	}
	if(PlayerData[playerid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't allowed to change your name while on admin duty,");
	}
	if(!isnull(PlayerData[playerid][pNameChange]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have already requested a namechange. Please wait for a response.");
	}

    PlayerData[playerid][pFreeNamechange] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", params);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerAttemptNameChange", "is", playerid, params);
	return 1;
}

CMD:denyname(playerid, params[])
{
    new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /denyname [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	/*if(!PlayerData[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
	}*/
	if(isnull(PlayerData[targetid][pNameChange]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't requested a namechange.");
	}

	if(PlayerData[targetid][pFreeNamechange] == 1)
	{
	    if(!IsPlayerLoggedIn(targetid))
		{
            KickPlayer(targetid,  "Please reconnect with a proper roleplay name in the Firstname_Lastname format.");
			return 1;
		}
	    Dialog_Show(targetid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
	}

    Log_Write("log_admin", "%s (uid: %i) denied %s's (uid: %i) namechange to %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pNameChange]);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has denied %s's namechange to %s.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pNameChange]);
	SendClientMessageEx(targetid, COLOR_LIGHTRED, "Your namechange request to %s was denied.", PlayerData[targetid][pNameChange]);
	PlayerData[targetid][pNameChange] = 0;
	PlayerData[targetid][pFreeNamechange] = 0;
	return 1;
}

CMD:namechanges(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Pending Namechanges ______");

	foreach(new i : Player)
	{
	    if(!isnull(PlayerData[i][pNameChange]))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s requested a namechange to %s", i, GetRPName(i), PlayerData[i][pNameChange]);
		}
	}

	return 1;
}

CMD:paytickets(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), amount;
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1186.8889,-1795.3860,13.5703))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of ticket pay.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle of yours.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pVehicleKeys] != vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as this vehicle doesn't belong to you.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /paytickets [amount] (There is $%i in unpaid tickets.)", VehicleInfo[vehicleid][vTickets]);
	}
	if(amount < 1 || amount > PlayerData[playerid][pCash])
	{
		return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(amount > VehicleInfo[vehicleid][vTickets])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There isn't that much in unpaid tickets to pay.");
	}

    VehicleInfo[vehicleid][vTickets] -= amount;
	GivePlayerCash(playerid, -amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have paid %s in unpaid tickets. This vehicle now has %s left in unpaid tickets.", FormatCash(amount), FormatCash(VehicleInfo[vehicleid][vTickets]));
	return 1;
}

CMD:carinfo(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any vehicle of yours.");
	}

	new neon[12], Float:health;

	GetVehicleHealth(vehicleid, health);

	switch(VehicleInfo[vehicleid][vNeon])
	{
	    case 18647: neon = "Red";
		case 18648: neon = "Blue";
		case 18649: neon = "Green";
		case 18650: neon = "Yellow";
		case 18651: neon = "Pink";
		case 18652: neon = "White";
		default: neon = "None";
	}

	SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ %s Stats _______", GetVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_GREY2, "Owner: %s - Value: $%i - Tickets: $%i - License Plate: ", VehicleInfo[vehicleid][vOwner], GetVehicleValue(vehicleid), VehicleInfo[vehicleid][vTickets]);
	SendClientMessageEx(playerid, COLOR_GREY2, "Neon: %s - Trunk Level: %i/3 - Alarm Level: %i/3 - Health: %.1f - Fuel: %i/100", neon, VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vAlarm], health, GetVehicleFuel(vehicleid));
	return 1;
}

CMD:loadpack(playerid, params[])
{
	if(PlayerData[playerid][pSmuggleDrugs] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have any drug pack to load.");
	}
	new vehicleid = GetNearbyVehicle(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no boot.");
	}
	if(!IsVehicleParamOn(vehicleid, VEHICLE_BOOT))
	{
		return SendClientMessage(playerid, COLOR_GREY, "The vehicle trunk is not open");
	}
	switch(PlayerData[playerid][pSmuggleDrugs])
	{
	    case 1:
	    {
 			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, 9);
		    PlayerData[playerid][pSmuggleTime] = gettime();
		    PlayerData[playerid][pCP] = CHECKPOINT_DRUGS;
	        SetTimerEx("DrugDeliveryDetect", 8000, 0, "i", playerid);
		    SetPlayerCheckpoint(playerid, 2160.4971,-1700.8091,15.0859, 3.0);
		    SendClientMessage(playerid, COLOR_GREEN, "Item loaded, deliver it to your marker!");
	    }
	    case 2:
	    {
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, 9);
		    PlayerData[playerid][pSmuggleTime] = gettime();
		    PlayerData[playerid][pCP] = CHECKPOINT_DRUGS;
	        SetTimerEx("DrugDeliveryDetect", 8000, 0, "i", playerid);
		    SetPlayerCheckpoint(playerid, 2349.7727, -1169.6304, 28.0243, 3.0);
		    SendClientMessage(playerid, COLOR_GREEN, "Item loaded, deliver it to your marker!");
	    }
	    case 3:
	    {
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, 9);
		    PlayerData[playerid][pSmuggleTime] = gettime();
		    PlayerData[playerid][pCP] = CHECKPOINT_DRUGS;
	        SetTimerEx("DrugDeliveryDetect", 8000, 0, "i", playerid);
		    SetPlayerCheckpoint(playerid, 1765.2086, -2048.8926, 14.0429, 3.0);
		    SendClientMessage(playerid, COLOR_GREEN, "Item loaded, deliver it to your marker!");
	    }
	}
	return 1;
}
CMD:getcrate(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_DRUGSMUGGLER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Smuggler.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 2205.9263, 1581.7888, 999.9827))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the smuggle point.");
	}
	new amount = 100 / GetJobLevel(playerid, JOB_DRUGSMUGGLER);
	if(PlayerData[playerid][pCash] < amount)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money.");
	}
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
	}

	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getcrate [seeds | crack | chems]");
	}
	if(!strcmp(params, "seeds", true))
	{
	    if(gSeedsStock + 10 > 1000)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "The drug house can't hold anymore seeds. Therefore you can't smuggle them.");
	    }
 		SetPlayerAttachedObject(playerid, 9, 1578, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    PlayerData[playerid][pSmuggleDrugs] = 1;
	    GivePlayerCash(playerid, -amount);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have paid $%i for a package of {00AA00}marijuana seeds{33CCFF}. Load it to your vehicle's trunk (/loadpack).", amount);
	}
	else if(!strcmp(params, "crack", true))
	{
	    if(gCocaineStock + 10 > 500)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "The crack house can't hold anymore crack. Therefore you can't smuggle it.");
	    }
		SetPlayerAttachedObject(playerid, 9, 1575, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    PlayerData[playerid][pSmuggleDrugs] = 2;
	    GivePlayerCash(playerid, -amount);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have paid $%i for a package of {00AA00}crack{33CCFF}. Load it to your vehicle's trunk (/loadpack).", amount);
	}
	else if(!strcmp(params, "chems", true))
	{
	    if(gEphedrineStock + 10 > 250)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "The drug house can't hold anymore chems. Therefore you can't smuggle ir.");
	    }
		SetPlayerAttachedObject(playerid, 9, 1576, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    PlayerData[playerid][pSmuggleDrugs] = 3;
	    GivePlayerCash(playerid, -amount);
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have paid $%i for a package of {00AA00}Chems{33CCFF}. Load it to your vehicle's trunk (/loadpack).", amount);
	}
	return 1;
}


CMD:getseeds(playerid, params[])
{
	new amount, cost;

	if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang to use this command.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getseeds [amount]");
	}
	
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 321.8347, 1117.1797, 1083.8828))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not inside of the drug den.");
	}
	if(amount < 1 || amount > 10)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't buy less than 1 or more than 10 seeds at a time.");
	}
	if(amount > gSeedsStock)
	{
		return SendClientMessage(playerid, COLOR_GREY, "There aren't that many seeds left in stock.");
	}
	if(PlayerData[playerid][pCash] < (cost = amount * 60))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy that many seeds.");
	}
	if(PlayerData[playerid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i seeds. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS));
	}

	gSeedsStock -= amount;
	PlayerData[playerid][pSeeds] += amount;

	GivePlayerCash(playerid, -cost);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased %i marijuana seeds for {00AA00}$%i{33CCFF}. /planthelp for more help.", amount, cost);
	return 1;
}
CMD:getcrack(playerid, params[])
{
	new amount, cost;

	if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang to use this command.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getcrack [amount]");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2342.7766, -1187.0839, 1027.9766))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not inside of the crack house.");
	}
	if(amount < 1 || amount > 10)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't buy less than 1 or more than 10 grams at a time.");
	}
	if(amount > gCocaineStock)
	{
		return SendClientMessage(playerid, COLOR_GREY, "There isn't that much crack left in stock.");
	}
	if(PlayerData[playerid][pCash] < (cost = amount * 60))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy that many grams.");
	}
	if(PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i crack. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
	}

	gCocaineStock -= amount;
	PlayerData[playerid][pCocaine] += amount;

	GivePlayerCash(playerid, -cost);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased %i grams of crack for {00AA00}$%i{33CCFF}.", amount, cost);
	return 1;
}
CMD:getchems(playerid, params[])
{
	new amount, cost;

	if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getchems [amount]");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -942.1650, 1847.1581, 5.0051))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not inside of the Chems lab.");
	}
	if(amount < 1 || amount > 5)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't buy less than 1 or more than 5 grams at a time.");
	}
	if(amount > gEphedrineStock)
	{
		return SendClientMessage(playerid, COLOR_GREY, "There isn't that much chems left in stock.");
	}
	if(PlayerData[playerid][pCash] < (cost = amount * 60))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy that many grams.");
	}
	if(PlayerData[playerid][pEphedrine] + amount > GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i chems. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pEphedrine], GetPlayerCapacity(playerid, CAPACITY_EPHEDRINE));
	}

	gEphedrineStock -= amount;
	PlayerData[playerid][pEphedrine] += amount;

	GivePlayerCash(playerid, -cost);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = %i WHERE uid = %i", PlayerData[playerid][pEphedrine], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased %i grams of raw chems for {00AA00}$%i{33CCFF}.", amount, cost);
	return 1;
}

CMD:plantweed(playerid, params[])
{
	if(PlayerData[playerid][pWeedPlanted] == 1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You have 1 active weed plant already.");
	}
	if(PlayerData[playerid][pSeeds] < 10)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have enough seeds. You need at least 10 seeds in order to plant them.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't plant indoors.");
	}

	GetPlayerPos(playerid, PlayerData[playerid][pWeedX], PlayerData[playerid][pWeedY], PlayerData[playerid][pWeedZ]);
	GetPlayerFacingAngle(playerid, PlayerData[playerid][pWeedA]);

	PlayerData[playerid][pSeeds] -= 10;
	PlayerData[playerid][pWeedPlanted] = 1;
	PlayerData[playerid][pWeedTime] = 60;
	PlayerData[playerid][pWeedGrams] = 0;
	PlayerData[playerid][pWeedObject] = CreateDynamicObject(3409, PlayerData[playerid][pWeedX], PlayerData[playerid][pWeedY], PlayerData[playerid][pWeedZ] - 1.8, 0.0, 0.0, PlayerData[playerid][pWeedA]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = %i, weedplanted = 1, weedtime = %i, weedgrams = %i, weed_x = '%f', weed_y = '%f', weed_z = '%f', weed_a = '%f' WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pWeedTime], PlayerData[playerid][pWeedGrams], PlayerData[playerid][pWeedX], PlayerData[playerid][pWeedY], PlayerData[playerid][pWeedZ], PlayerData[playerid][pWeedA], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	ShowActionBubble(playerid, "* %s plants some seeds into the ground.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_GREEN, "You have planted a weed plant. Every two minutes your plant will grow one gram of weed.");
	SendClientMessage(playerid, COLOR_GREEN, "Your plant will be ready in 60 minutes. Be careful, as anyone who sees your plant can pick it!");
	return 1;
}

CMD:plantinfo(playerid, params[])
{
	foreach(new i : Player)
	{
	    if(PlayerData[i][pWeedPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerData[i][pWeedX], PlayerData[i][pWeedY], PlayerData[i][pWeedZ]))
	    {
	        ShowActionBubble(playerid, "* %s inspects the plant.", GetRPName(playerid));
	        SendClientMessageEx(playerid, COLOR_WHITE, "* This plant has so far grown %i grams of weed. It will be ready in %i/60 minutes.", PlayerData[i][pWeedGrams], PlayerData[i][pWeedTime]);
	        return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any plants.");
	return 1;
}
CMD:destroyplant(playerid, params[])
{
	if(IsLawEnforcement(playerid))
	{
	    if(PlayerData[playerid][pWeedPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerData[playerid][pWeedX], PlayerData[playerid][pWeedY], PlayerData[playerid][pWeedZ]))
	    {
	        PlayerData[playerid][pPickPlant] = playerid;
			DestroyWeedPlant(playerid);
			SendClientMessage(playerid, COLOR_GREY, "You've destroyed the plant, reward $738");
			GivePlayerCash(playerid, 738);
		}
	}
	else return SendClientMessage(playerid, COLOR_GREY, "You are not a cop");
	return 1;
}
CMD:pickplant(playerid, params[])
{
	if(IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cant pickup plants as a cop, use /destroyplant instead");
	}
    foreach(new i : Player)
	{
	    if(PlayerData[i][pWeedPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerData[i][pWeedX], PlayerData[i][pWeedY], PlayerData[i][pWeedZ]))
	    {
	        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "You need to be crouched in order to pick a plant.");
			}
			if(PlayerData[i][pWeedGrams] < 2)
			{
			    return SendClientMessage(playerid, COLOR_GREY, "This plant hasn't grown that much yet. Wait a little while first.");
			}
			if(PlayerData[playerid][pWeed] + PlayerData[i][pWeedGrams] > GetPlayerCapacity(playerid, CAPACITY_WEED))
			{
			    return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
			}

			PlayerData[playerid][pPickPlant] = i;
			PlayerData[playerid][pPickTime] = 5;
            GivePlayerRankPoints(playerid, 100);

			ShowActionBubble(playerid, "* %s crouches down and starts picking at the weed plant.", GetRPName(playerid));
		//	SendClientMessage(playerid, COLOR_WHITE, "* Allow up to five seconds for you to pick the plant.");
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any plants.");
	return 1;
}

CMD:seizeplant(playerid, params[])
{
    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}

    foreach(new i : Player)
	{
	    if(PlayerData[i][pWeedPlanted] && IsPlayerInRangeOfPoint(playerid, 3.0, PlayerData[i][pWeedX], PlayerData[i][pWeedY], PlayerData[i][pWeedZ]))
	    {
	        ShowActionBubble(playerid, "* %s seizes a weed plant weighing %i grams.", GetRPName(playerid), PlayerData[i][pWeedGrams]);
	        DestroyWeedPlant(i);
	        return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any plants.");
	return 1;
}

CMD:cookheroin(playerid, params[])
{
    if(!PlayerHasJob(playerid, JOB_DRUGDEALER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1.2179, 2.8095, 999.4284))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in Heisenberg's trailer. You can't use this command.");
	}
	if(!PlayerData[playerid][pCookHeroin])
	{
		if(!PlayerData[playerid][pEphedrine])
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You don't have any Chems which you could turn into Heroin.");
		}
	    if(!PlayerData[playerid][pMuriaticAcid])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need muriatic acid in order to cook Heroin. Go buy some at 24/7.");
		}

		PlayerData[playerid][pCookHeroin] = 1;
		PlayerData[playerid][pCookTime] = 15;
		PlayerData[playerid][pCookGrams] = 0;

		SendClientMessage(playerid, COLOR_GREEN, "You have started cooking Heroin. One gram of chems will turn into 2 grams of Heroin every 15 seconds.");
	    SendClientMessage(playerid, COLOR_GREEN, "Type the /cookheroin command again in order to stop cooking.");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_AQUA, "You have stopped cooking. You converted %i grams of chems into %i grams of Heroin.", PlayerData[playerid][pCookGrams] / 2, PlayerData[playerid][pCookGrams]);
	    ResetCooking(playerid);
	}
	return 1;
}

CMD:usecigar(playerid, params[])
{
	if(!PlayerData[playerid][pCigars])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have any cigars left.");
	}

	PlayerData[playerid][pCigars]--;

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	ShowActionBubble(playerid, "* %s lights up a cigar and starts to smoke it.", GetRPName(playerid));

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", PlayerData[playerid][pCigars], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}
CMD:bloodtest(playerid, params[])
{
	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /showid [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	/*if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}*/
    if(gettime() - PlayerData[targetid][pLastDrug] < 180)
	{
		return SendClientMessageEx(playerid, COLOR_RED, "** Blood Test ** %s's blood containts toxic substance due to the use of drugs.", GetRPName(targetid));
	}else {
		return SendClientMessageEx(playerid, COLOR_GREEN, "** Blood Test ** %s's blood is clean.", GetRPName(targetid));
	}
}
CMD:usedrug(playerid, params[])
{
    if(gettime() - PlayerData[playerid][pLastDrug] < 10)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only consume drugs every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastDrug]));
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(PlayerData[playerid][pDrugsUsed] >= 4)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are stoned and therefore can't consume anymore drugs right now.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /usedrug [weed | crack | heroin | painkillers]");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to use drugs. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}

	if(!strcmp(params, "weed", true))
	{
	    if(PlayerData[playerid][pWeed] < 2)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need at least two grams of weed.");
		}

        if(PlayerData[playerid][pAddictUpgrade] > 0)
	    {
			SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra health.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0));
	    }

		GivePlayerHealth(playerid, 20.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

		PlayerData[playerid][pWeed] -= 2;
		PlayerData[playerid][pDrugsUsed]++;
		PlayerData[playerid][pLastDrug] = gettime();

		if(PlayerData[playerid][pDrugsUsed] >= 4)
	    {
	        AwardAchievement(playerid, ACH_HighTimes);
	        GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
			PlayerData[playerid][pDrugsTime] = 30;
		}

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		ShowActionBubble(playerid, "* %s smokes two grams of weed.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(params, "crack", true))
	{
	    if(PlayerData[playerid][pCocaine] < 2)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need at least two grams of crack.");
		}

		if(PlayerData[playerid][pAddictUpgrade] > 0)
	    {
			SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra armor.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0));
	    }

		GivePlayerArmour(playerid, 10.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

		PlayerData[playerid][pCocaine] -= 2;
		PlayerData[playerid][pDrugsUsed]++;
		PlayerData[playerid][pLastDrug] = gettime();

		if(PlayerData[playerid][pDrugsUsed] >= 4)
	    {
	        AwardAchievement(playerid, ACH_HighTimes);
	        GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
			PlayerData[playerid][pDrugsTime] = 30;
		}

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		ShowActionBubble(playerid, "* %s snorts two grams of crack.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(params, "heroin", true))
	{
	    if(PlayerData[playerid][pHeroin] < 2)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You need at least two grams of heroin.");
		}

		if(PlayerData[playerid][pAddictUpgrade] > 0)
	    {
			SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f/%.1f extra health & armor.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0), (PlayerData[playerid][pAddictUpgrade] * 5.0));
	    }

		GivePlayerHealth(playerid, 10.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));
		GivePlayerArmour(playerid, 10.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

		PlayerData[playerid][pHeroin] -= 2;
		PlayerData[playerid][pDrugsUsed] += 2;
		PlayerData[playerid][pLastDrug] = gettime();

		if(PlayerData[playerid][pDrugsUsed] >= 4)
	    {
	        AwardAchievement(playerid, ACH_HighTimes);
	        GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
			PlayerData[playerid][pDrugsTime] = 30;
		}

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		ShowActionBubble(playerid, "* %s smokes two grams of Heroin.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
    else if(!strcmp(params, "painkillers", true))
	{
	    if(PlayerData[playerid][pPainkillers] <= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You don't have any painkillers left.");
		}

		if(PlayerData[playerid][pAddictUpgrade] > 0)
	    {
			SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra health.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0));
	    }

		GivePlayerHealth(playerid, 30.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

		PlayerData[playerid][pPainkillers] -= 1;
		PlayerData[playerid][pReceivingAid] = 1;
		PlayerData[playerid][pDrugsUsed] += 2;
		PlayerData[playerid][pLastDrug] = gettime();

		if(PlayerData[playerid][pDrugsUsed] >= 4)
	    {
	        AwardAchievement(playerid, ACH_HighTimes);
	        GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
	        PlayerData[playerid][pDrugsTime] = 30;
		}

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
		ShowActionBubble(playerid, "* %s pops a painkiller in their mouth.", GetRPName(playerid));

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

CMD:inv(playerid, params[])
{
	return callcmd::inventory(playerid, params);
}

CMD:inventory(playerid, params[])
{
	DisplayInventory(playerid);
	return 1;
}

CMD:drop(playerid, params[])
{
	new option[12], confirm[10];

	if(sscanf(params, "s[12]S()[10]", option, confirm))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /drop [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapons, Materials, Weed, Crack, Heroin, Painkillers, Cigars, Spraycans");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Seeds, Chems, CarLicense");
	    return 1;
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(!strcmp(option, "weapons", true))
	{
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /drop [weapons] [confirm]");
	    }

	    ResetPlayerWeaponsEx(playerid);
	    ShowActionBubble(playerid, "* %s throws away their weapons.", GetRPName(playerid));
	}
	else if(!strcmp(option, "materials", true))
	{
	    if(!PlayerData[playerid][pMaterials])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no materials which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [materials] [confirm] (You have %i materials.)", PlayerData[playerid][pMaterials]);
	    }

	    PlayerData[playerid][pMaterials] = 0;
	    ShowActionBubble(playerid, "* %s throws away their materials.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "weed", true))
	{
	    if(!PlayerData[playerid][pWeed])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no weed which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [weed] [confirm] (You have %i grams of weed.)", PlayerData[playerid][pWeed]);
	    }

	    PlayerData[playerid][pWeed] = 0;
	    ShowActionBubble(playerid, "* %s throws away their weed.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(!PlayerData[playerid][pCocaine])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no crack which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [crack] [confirm] (You have %i grams of crack.)", PlayerData[playerid][pCocaine]);
	    }

	    PlayerData[playerid][pCocaine] = 0;
	    ShowActionBubble(playerid, "* %s throws away their crack.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "Heroin", true))
	{
	    if(!PlayerData[playerid][pHeroin])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no Heroin which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [Heroin] [confirm] (You have %i grams of Heroin.)", PlayerData[playerid][pHeroin]);
	    }

	    PlayerData[playerid][pHeroin] = 0;
	    ShowActionBubble(playerid, "* %s throws away their Heroin.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(!PlayerData[playerid][pPainkillers])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no painkillers which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [crack] [confirm] (You have %i painkillers.)", PlayerData[playerid][pPainkillers]);
	    }

	    PlayerData[playerid][pPainkillers] = 0;
	    ShowActionBubble(playerid, "* %s throws away their painkillers.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "cigars", true))
	{
	    if(!PlayerData[playerid][pCigars])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no cigars which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [cigars] [confirm] (You have %i cigars.)", PlayerData[playerid][pCigars]);
	    }

	    PlayerData[playerid][pCigars] = 0;
	    ShowActionBubble(playerid, "* %s throws away their cigars.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cigars = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "spraycans", true))
	{
	    if(!PlayerData[playerid][pSpraycans])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no spraycans which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [spraycans] [confirm] (You have %i spraycans.)", PlayerData[playerid][pSpraycans]);
	    }

	    PlayerData[playerid][pSpraycans] = 0;
	    ShowActionBubble(playerid, "* %s throws away their spraycanss.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET spraycans = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "seeds", true))
	{
	    if(!PlayerData[playerid][pSeeds])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no seeds which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [seeds] [confirm] (You have %i seeds.)", PlayerData[playerid][pSeeds]);
	    }

	    PlayerData[playerid][pSeeds] = 0;
	    ShowActionBubble(playerid, "* %s throws away their seeds.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET seeds = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "chems", true))
	{
	    if(!PlayerData[playerid][pEphedrine])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no chems which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /drop [chems] [confirm] (You have %i grams of chems.)", PlayerData[playerid][pEphedrine]);
	    }

	    PlayerData[playerid][pEphedrine] = 0;
	    ShowActionBubble(playerid, "* %s throws away their chems.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET ephedrine = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "carlicense", true))
	{
	    if(!PlayerData[playerid][pCarLicense])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "You have no drivers license which you can throw away.");
		}
	    if(isnull(confirm) || strcmp(confirm, "confirm", true) != 0)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /drop [carlicense] [confirm] (This drops your drivers license.)");
	    }

	    PlayerData[playerid][pCarLicense] = 0;
	    ShowActionBubble(playerid, "* %s rips up their drivers license.", GetRPName(playerid));

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET carlicense = 0 WHERE uid = %i", PlayerData[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	return 1;
}

CMD:settitle(playerid, params[])
{
	new targetid, option[14], param[128];
	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[14]S()[128]", targetid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settitle [playerid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, Color");
		return 1;
	}
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid playerid.");
    }
	if(!strcmp(option, "name", true))
	{
	    if(isnull(param) || strlen(params) > 32)
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settitle [playerid] [name] [text ('none' to reset)]");
		}

		strcpy(PlayerData[targetid][pCustomTitle], param, 64);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET customtitle = '%e' WHERE uid = %i", param, PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the customtitle of %s to '%s'.", GetRPName(playerid), GetRPName(targetid), param);
	}
    else if(!strcmp(option, "color", true))
	{
	    new color;

	    if(sscanf(param, "h", color))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /settitle [playerid] [color] [0xRRGGBBAA]");
		}

		PlayerData[targetid][pCustomTColor] = color & ~0xff;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET customcolor = %i WHERE uid = %i", PlayerData[targetid][pCustomTColor], PlayerData[targetid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the {%06x}color{FF6347} of %s's title.", GetRPName(playerid), color >>> 8, GetRPName(targetid));
	}
	return 1;
}

CMD:showlands(playerid, params[])
{
	if(!PlayerData[playerid][pShowLands])
	{
        ShowLandsOnMap(playerid, true);
        SendClientMessage(playerid, COLOR_AQUA, "You will now see lands on your mini-map.");
	}
	else
	{
        ShowLandsOnMap(playerid, false);
        SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any lands on your mini-map.");
	}

	return 1;
}


CMD:guninv(playerid, params[])
{
	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ My Weapons _____");

	for(new i = 0; i < 13; i ++)
	{
     	if(PlayerData[playerid][pWeapons][i] > 0)
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s", PlayerData[playerid][pWeapons][i], GetWeaponNameEx(PlayerData[playerid][pWeapons][i]));
		}
	}

	return 1;
}

CMD:carhelp(playerid, params[])
{
	return callcmd::vehiclehelp(playerid, params);
}

CMD:eject(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /eject [playerid]");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected, or is not in your vehicle.");
	}

	RemovePlayerFromVehicle(targetid);
	ShowActionBubble(playerid, "* %s ejects %s from the vehicle.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:dicebetoff(playerid, params[])
{
	new targetid, amount;

	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1949.3925,1018.5336,992.4745))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the casino.");
	}
	if(PlayerData[playerid][pLevel] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least level 3+ in order to dice bet.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dicebet [playerid] [amount]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(PlayerData[targetid][pLevel] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player must be at least level 3+ to bet with them.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $1.");
	}
	if(PlayerData[playerid][pCash] < amount)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money to bet.");
	}
	if(gettime() - PlayerData[playerid][pLastBet] < 10)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastBet]));
	}

	PlayerData[targetid][pDiceOffer] = playerid;
	PlayerData[targetid][pDiceBet] = amount;
	PlayerData[targetid][pDiceRigged] = 0;
	PlayerData[playerid][pLastBet] = gettime();

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has initiated a dice bet with you for $%i (/accept dicebet).", GetRPName(playerid), amount);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have initiated a dice bet against %s for $%i.", GetRPName(targetid), amount);
	return 1;
}

CMD:dicebet(playerid, params[]) // Added to keep the economy in control. And to make people qq when they lose all their cash.
{
	new targetid, amount;

	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1949.3925,1018.5336,992.4745))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the casino.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dicebet [playerid] [amount]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(PlayerData[targetid][pLevel] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player must be at least level 3+ to bet with them.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $1.");
	}
	if(PlayerData[playerid][pCash] < amount)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money to bet.");
	}
	if(gettime() - PlayerData[playerid][pLastBet] < 10)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastBet]));
	}

	PlayerData[targetid][pDiceOffer] = playerid;
	PlayerData[targetid][pDiceBet] = amount;
	PlayerData[targetid][pDiceRigged] = 1;
	PlayerData[playerid][pLastBet] = gettime();

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has initiated a dice bet with you for $%i (/accept dicebet).", GetRPName(playerid), amount);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have initiated a dice bet against %s for $%i.", GetRPName(targetid), amount);
	SendClientMessage(playerid, COLOR_GREEN, "Dicebet chance inreased !!!.");
	return 1;
}



CMD:ww(playerid, params[])
{
	return callcmd::pw(playerid, params);
}

CMD:watch(playerid, params[])
{
	return callcmd::pw(playerid, params);
}

CMD:pw(playerid, params[])
{
	if(!PlayerData[playerid][pWatch])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a pocket watch. You can buy one at 24/7.");
	}

	if(!PlayerData[playerid][pWatchOn])
	{
	    if(PlayerData[playerid][pToggleTextdraws])
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You can't turn on your watch as you have textdraws toggled! (/toggle textdraws)");
		}

	    PlayerData[playerid][pWatchOn] = 1;
	    TextDrawShowForPlayer(playerid, TimeTD);
	    ShowActionBubble(playerid, "* %s turns on their pocket watch.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[playerid][pWatchOn] = 0;
	    TextDrawHideForPlayer(playerid, TimeTD);
	    ShowActionBubble(playerid, "* %s turns off their pocket watch.", GetRPName(playerid));
	}

	return 1;
}

CMD:gps(playerid, params[])
{
	if(!PlayerData[playerid][pGPS])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a GPS. You can buy one at 24/7.");
	}

	if(!PlayerData[playerid][pGPSOn])
	{
	    if(PlayerData[playerid][pToggleTextdraws])
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "You can't turn on your GPS as you have textdraws toggled! (/toggle textdraws)");
		}

	    PlayerData[playerid][pGPSOn] = 1;

	    PlayerTextDrawSetString(playerid, PlayerData[playerid][pGPSText], "Loading...");
	    PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);

	    ShowActionBubble(playerid, "* %s turns on their GPS.", GetRPName(playerid));
	}
	else
	{
	    PlayerData[playerid][pGPSOn] = 0;
	    PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
	    ShowActionBubble(playerid, "* %s turns off their GPS.", GetRPName(playerid));
	}

	return 1;
}

CMD:fixmyvw(playerid, params[])
{
	if(PlayerData[playerid][pPaintball] > 0 || IsPlayerInEvent(playerid) || PlayerData[playerid][pJailType] > 0 || PlayerData[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(GetPlayerVirtualWorld(playerid) > 0 && GetPlayerInterior(playerid) == 0)
	{
	    SetPlayerVirtualWorld(playerid, 0);
	    SendClientMessage(playerid, COLOR_GREY, "Your virtual world has been fixed.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "Your virtual world is not bugged at the moment.");
	}

	return 1;
}

CMD:stuck(playerid, params[])
{
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pAcceptedHelp] || IsPlayerMining(playerid) || PlayerData[playerid][pFishTime] > 0 || PlayerData[playerid][pLootTime] > 0 || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
    if(gettime() - PlayerData[playerid][pLastStuck] < 5)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerData[playerid][pLastStuck]));
	}

	new
	    Float:x,
    	Float:y,
    	Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z + 0.5);

	ClearAnimations(playerid);
	TogglePlayerControllableEx(playerid, 1);

	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
	SendClientMessage(playerid, COLOR_GREY, "You are no longer stuck.");

	PlayerData[playerid][pLastStuck] = gettime();
	return 1;
}


CMD:duel(playerid, params[])
{
	new target1, target2, Float:health, Float:armor, weapon1, weapon2;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uuffii", target1, target2, health, armor, weapon1, weapon2))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /duel [player1] [player2] [health] [armor] [weapon1] [weapon2]");
	}
	if(target1 == INVALID_PLAYER_ID || target2 == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid player specified.");
	}
	if(health < 1.0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Health can't be under 1.0.");
	}
	if(!(0 <= weapon1 <= 46) || !(0 <= weapon2 <= 46))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon. Valid weapon IDs range from 0 to 46.");
	}

	SavePlayerVariables(target1);
	SavePlayerVariables(target2);

	ResetPlayerWeapons(target1);
	ResetPlayerWeapons(target2);

	SetPlayerPos(target1, 1370.3395, -15.4556, 1000.9219);
	SetPlayerPos(target2, 1414.4841, -15.1239, 1000.9253);
	SetPlayerFacingAngle(target1, 270.0000);
	SetPlayerFacingAngle(target2, 90.0000);

	SetPlayerInterior(target1, 1);
	SetPlayerInterior(target2, 1);
	SetPlayerVirtualWorld(target1, 0);
	SetPlayerVirtualWorld(target2, 0);

	SetPlayerHealth(target1, health);
	SetPlayerArmour(target1, armor);
	SetPlayerHealth(target2, health);
	SetPlayerArmour(target2, armor);

	GivePlayerWeaponEx(target1, weapon1, true);
	GivePlayerWeaponEx(target1, weapon2, true);
	GivePlayerWeaponEx(target2, weapon1, true);
	GivePlayerWeaponEx(target2, weapon2, true);

	GameTextForPlayer(target1, "~r~Duel time!", 3000, 3);
	GameTextForPlayer(target2, "~r~Duel time!", 3000, 3);

	PlayerData[target1][pDueling] = target2;
	PlayerData[target2][pDueling] = target1;

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s and %s into a duel.", GetRPName(playerid), GetRPName(target1), GetRPName(target2));
	return 1;
}

CMD:mole(playerid, params[]) // MADE BY THE ONE AND ONLY Hernandez!
{
 	if(GetPlayerFaction(playerid) != FACTION_HITMAN && PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
 	{
  		return SendClientErrorUnauthorizedCmd(playerid);
 	}
 	if(isnull(params))
 	{
     	SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /mole [text]");
     	SendClientMessage(playerid, COLOR_YELLOW, "This command sends a SMS to the entire server. Abusing this command will result in heavy punishment.");
     	return 1;
 	}
	SendClientMessageToAllEx(COLOR_YELLOW, "* SMS from Satan: %s, Ph: 666 *", params);
 	return 1;
}

CMD:info(playerid, params[])
{
	return callcmd::information(playerid, params);
}

CMD:information(playerid, params[])
{
	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Server Information _____");
	//SendClientMessageEx(playerid, COLOR_GREY2, "Website: %s", GetServerWebsite());
	SendClientMessageEx(playerid, COLOR_GREY2, "Officiel Discord: https://discord.gg/arabicarp");
	SendClientMessageEx(playerid, COLOR_GREY2, "Faction discord: %s", GetFactionDiscord());
	SendClientMessageEx(playerid, COLOR_GREY2, "Gang discord: %s", GetGangDiscord());
	//SendClientMessageEx(playerid, COLOR_GREY2, "UCP: %s", GetServerUCP());
	//SendClientMessageEx(playerid, COLOR_GREY2, "Donate: %s", GetServerShop());
	return 1;
}

CMD:takecall(playerid, params[])
{
	new targetid, Float:x, Float:y, Float:z;

	if(!PlayerHasJob(playerid, JOB_MECHANIC) && !PlayerHasJob(playerid, JOB_TAXIDRIVER))
	{
     	return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic or Taxi Driver.");
	}
    if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /takecall [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	if(PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[targetid][pMechanicCall] > 0)
	{
		if(GetPlayerInterior(targetid))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "That player is currently unreachable.");
		}

		PlayerData[targetid][pMechanicCall] = 0;
		PlayerData[playerid][pCP] = CHECKPOINT_MISC;

		GetPlayerPos(targetid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 5.0);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's mechanic call. Their location was marked on your map.", GetRPName(targetid));
		SendClientMessageEx(targetid, COLOR_AQUA, "* %s has accepted your mechanic call. Please wait patiently until they arrive.", GetRPName(playerid));
	}
	else if(PlayerHasJob(playerid, JOB_TAXIDRIVER) && PlayerData[targetid][pTaxiCall] > 0)
	{
        if(GetPlayerInterior(targetid))
		{
	    	return SendClientMessage(playerid, COLOR_GREY, "That player is currently unreachable.");
		}

		PlayerData[targetid][pTaxiCall] = 0;
		PlayerData[playerid][pCP] = CHECKPOINT_MISC;

		GetPlayerPos(targetid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 5.0);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's taxi call. Their location was marked on your map.", GetRPName(targetid));
		SendClientMessageEx(targetid, COLOR_AQUA, "* %s has accepted your taxi call. Please wait patiently until they arrive.", GetRPName(playerid));
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "That player has no calls which can be taken.");
	}

	return 1;
}

CMD:listcallers(playerid, params[])
{
    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Emergency Calls _____");

	foreach(new i : Player)
	{
	    if((PlayerData[i][pEmergencyCall] > 0) && ((PlayerData[i][pEmergencyType] == FACTION_MEDIC && GetPlayerFaction(playerid) == FACTION_MEDIC) || (PlayerData[i][pEmergencyType] == FACTION_POLICE && IsLawEnforcement(playerid))))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "* %s[%i] - Expiry: %i seconds - Emergency: %s", GetRPName(i), i, PlayerData[i][pEmergencyCall], PlayerData[i][pEmergency]);
		}
	}

	return 1;
}

CMD:trackcall(playerid, params[])
{
	new targetid, Float:x, Float:y, Float:z;

	if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}
    if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /trackcall [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!PlayerData[targetid][pEmergencyCall])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't called 911 recently or their call expired.");
	}
	if(!GetPlayerPosEx(targetid, x, y, z))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is currently unreachable.");
	}

	//PlayerData[targetid][pEmergencyCall] = 0;
	PlayerData[playerid][pCP] = CHECKPOINT_MISC;

	SetPlayerCheckpoint(playerid, x, y, z, 5.0);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's emergency call. Their location was marked on your map.", GetRPName(targetid));

	if(PlayerData[targetid][pEmergencyCall] == FACTION_MEDIC)
	{
		SendClientMessageEx(targetid, COLOR_AQUA, "* %s has accepted your emergency call. Please wait patiently until they arrive.", GetRPName(playerid));
	}

	return 1;
}

CMD:robbiz(playerid, params[])
{
	new bizid;
	//if(IsPlayerAdmin(playerid)) // disabled for now
	{
		if(PlayerData[playerid][pRobbingBiz] >= 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You're already robbing a business.");
		}
		if (IsLawEnforcement(playerid))
		{
			return SendClientMessage(playerid, COLOR_GREY, "Law Enforcement Officials cannot rob a business.");
		}
		if((bizid = GetInsideBusiness(playerid)) == -1)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You aren't inside a business that you can rob.");
		}
		if(PlayerData[playerid][pLootTime] > 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "You are already looting a business.");
		}
		if(PlayerData[playerid][pRobCash] >= 10000)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Your pockets can't hold more than $10,000 of money!");
		}

		PlayerData[playerid][pRobbingBiz] = bizid;
		PlayerData[playerid][pLootTime] = 5;
		
		if(PlayerData[playerid][pWantedLevel] < 6)
			PlayerData[playerid][pWantedLevel]++;
			
		if(PlayerData[playerid][pWantedLevel] < 6)
			PlayerData[playerid][pWantedLevel]++;
			
		//SendClientMessageEx(playerid, COLOR_GREY, "You started robbery of biz %d, ploottime %d!", PlayerData[playerid][pRobbingBiz], PlayerData[playerid][pLootTime]);
	}/*else{
		    return SendClientMessage(playerid, COLOR_GREY, "Your are not an admin!");
	
	}*/
	return 1;
}
CMD:stoprobbery(playerid, params[])
{
    if(PlayerData[playerid][pRobbingBiz] < 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't actively robbing a business.");
	}
	if(GetInsideBusiness(playerid) != PlayerData[playerid][pRobbingBiz])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't inside the business you were robbing.");
	}
	ClearAnimations(playerid, 1);
	PlayerData[playerid][pRobbingBiz] = -1;
	PlayerData[playerid][pCP] = CHECKPOINT_ROBBERY;
    SendClientMessageEx(playerid, COLOR_AQUA, "You have robbed a total of %s. You need to get this cash immediately to the {FF6347}marker{33CCFF} before the cops catch you!", FormatCash(PlayerData[playerid][pRobCash]));
	SetPlayerCheckpoint(playerid, 1429.9939, 1066.9581, 9.8938, 3.0);
	return 1;
}
CMD:robbank(playerid, params[])
{
	new count;

	if(PlayerData[playerid][pLevel] < 7)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be at least level 7+ to use this command.");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 20.0, 1667.4260, -972.6691, 683.6873))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
	}
	if(RobberyInfo[rTime] > 0)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "The bank can be robbed again in %i hours. You can't rob it now.", RobberyInfo[rTime]);
	}
	if(RobberyInfo[rPlanning])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a bank robbery being planned already. Ask the leader to join.");
	}
	if(RobberyInfo[rStarted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't rob the bank as a robbery has already started.");
	}
	if(IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't rob the bank as a law enforcer. Ask your boss for a raise.");
	}

	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i) && !PlayerData[i][pAdminDuty])
	    {
	        count++;
		}
	}

	if(count < 10)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There needs to be at least 10+ LEO online in order to rob the bank.");
	}

    RobberyInfo[rRobbers][0] = playerid;
    RobberyInfo[rPlanning] = 1;

    PlayerData[playerid][pCP] = CHECKPOINT_MISC;
    SetPlayerCheckpoint(playerid, 1677.2610, -987.6659, 671.1152, 2.0);

    SendClientMessage(playerid, COLOR_AQUA, "You have setup a {FF6347}bank robbery{33CCFF}. You need to /robinvite at least 2 more people in order to begin the heist.");
	SendClientMessage(playerid, COLOR_AQUA, "After you've found two additional heisters, you can use /bombvault at the checkpoint to blow the vault.");
	return 1;
}

CMD:robinvite(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /robinvite [playerid]");
	}
	if(!(RobberyInfo[rPlanning] && RobberyInfo[rRobbers][0] == playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are currently not planning a bank robbery.");
	}
 	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(IsPlayerInBankRobbery(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already in the robbery with you.");
	}
	if(GetBankRobbers() >= MAX_BANK_ROBBERS)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i bank robbers in this robbery.", MAX_BANK_ROBBERS);
 	}
 	if(IsLawEnforcement(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't invite law enforcement to rob the bank.");
	}

	PlayerData[targetid][pRobberyOffer] = playerid;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has invited you to a bank robbery. (/accept robbery)", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have invited %s to join your bank robbery.", GetRPName(targetid));
	return 1;
}

CMD:bombvault(playerid, params[])
{
    if(RobberyInfo[rPlanning] == 0 && RobberyInfo[rRobbers][0] != playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are currently not planning a bank robbery.");
	}
	if(GetBankRobbers() < 3)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You need at least two other heisters in your robbery.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1677.2610, -987.6659, 671.1152))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the vault.");
	}
	if(IsValidDynamicObject(RobberyInfo[rObjects][1]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vault is already being bombed at the moment.");
	}

	RobberyInfo[rObjects][1] = CreateDynamicObject(1654, 1677.787475, -988.009765, 671.625366, 0.000000, 0.000000, 180.680709);

	ShowActionBubble(playerid, "* %s firmly plants an explosive on the vault door.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_WHITE, "* Bomb planted. Shoot at the bomb to blow that sumbitch' up!");
	return 1;
}

CMD:lootbox(playerid, params[])
{
	if(!IsPlayerInBankRobbery(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in an active bank robbery.");
	}
	if(!RobberyInfo[rStarted])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The bank robbery hasn't started yet.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2344, -994.6146, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2335, -998.6115, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1680.2344, -1002.5356, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1674.2708, -998.4954, 671.0032) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1674.2708, -994.5173, 671.0032))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the deposit boxes.");
	}
	if(PlayerData[playerid][pLootTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already looting a deposit box.");
	}
	if(PlayerData[playerid][pRobCash] >= 100000)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your pockets can't hold more than $100,000 of money!");
	}
	if(!IsPlayerInBankRobbery(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of this bank robbery.");
	}

	PlayerData[playerid][pLootTime] = 5;

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	GameTextForPlayer(playerid, "~w~Looting deposit box...", 5000, 3);
	return 1;
}

CMD:robbers(playerid, params[])
{
	if(!RobberyInfo[rStarted] && !IsPlayerInBankRobbery(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no bank robbery currently active.");
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Robbers Alive ______");

	foreach(new i : Player)
	{
	    if(IsPlayerInBankRobbery(i))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s {00AA00}(%s stolen)", i, GetRPName(i), FormatCash(PlayerData[i][pRobCash]));
		}
	}

	return 1;
}

CMD:motd(playerid, params[])
{
    new motd[128];
    motd = GetServerMOTD();
	if(!isnull(motd))
    {
		SendClientMessageEx(playerid, COLOR_YELLOW, "* MOTD: %s", motd);
    }
	if(PlayerData[playerid][pAdmin] > 0)
	{
	    motd=GetAdminMOTD();
        if(!isnull(motd))
        {
		    SendClientMessageEx(playerid, COLOR_LIGHTRED, "* Admin MOTD: %s", motd);
        }
	}
	if(PlayerData[playerid][pHelper] > 0 || PlayerData[playerid][pAdmin] > 0)
	{
        motd=GetHelperMOTD();
        if(!isnull(motd))
        {
		    SendClientMessageEx(playerid, COLOR_AQUA, "* Helper MOTD: %s", motd);
        }
	}
	if(PlayerData[playerid][pGang] >= 0 && strcmp(GangInfo[PlayerData[playerid][pGang]][gMOTD], "None", true) != 0)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "* Gang MOTD: %s", GangInfo[PlayerData[playerid][pGang]][gMOTD]);
	}
	if(PlayerData[playerid][pFaction] >= 0 && strcmp(FactionInfo[PlayerData[playerid][pFaction]][fMOTD], "None", true) != 0)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "* Faction MOTD: %s", FactionInfo[PlayerData[playerid][pFaction]][fMOTD]);
	}

	return 1;
} // LEONE - ERROR ALERT, STILL WORKING ON THIS.
CMD:createlocation(playerid, params[])
{
    new name[32], Float:x, Float:y, Float:z;
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if(sscanf(params, "s[32]", name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createlocation [name]");
		SendClientMessage(playerid, COLOR_WHITE, "* NOTE: The location will be created at the coordinates you are standing on.");
		return 1;
	}
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your virtual world & interior must be 0!");
	}
    GetPlayerPos(playerid, x, y, z);
    for(new i = 0; i < MAX_LOCATIONS; i ++)
	{
		if(!LocationInfo[i][locExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO locations VALUES(null, '%e', '%f', '%f', '%f')", name, x, y, z);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateLocation", "iisfff", playerid, i, name, x, y, z);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Location slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}
CMD:createatm(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (GetNearbyAtm(playerid) != -1)
	{
	    return SendErrorMessage(playerid, "There is another ATM nearby.");
	}
	else
	{
	    new
	        Float:x,
	        Float:y,
	        Float:z,
	        Float:angle,
			id = -1;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		x += 2.0 * floatsin(-angle, degrees);
		y += 2.0 * floatcos(-angle, degrees);

		id = AddATMMachine(x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

		if (id == -1)
		{
		    return SendErrorMessage(playerid, "There are no available ATM slots.");
		}
		else
		{
		    EditDynamicObjectEx(playerid, EDIT_TYPE_ATM, ATM[id][atmObject], id);
		    SendInfoMessage(playerid, "You have added ATM machine %i (/editatm).", id);
		}
	}
	return 1;
}

CMD:gotoatm(playerid, params[])
{
	new id;

    if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    
	if(!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin.");
    }

    if (sscanf(params, "i", id))
	{
	    return SendSyntaxMessage(playerid, "/gotoatm (machine ID)");
	}
	else if (!IsValidATMID(id))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid ATM machine.");
	}
	else
	{
	    TeleportToCoords(playerid, ATM[id][atmSpawn][0], ATM[id][atmSpawn][1], ATM[id][atmSpawn][2], ATM[id][atmSpawn][3], ATM[id][atmInterior], ATM[id][atmWorld]);
	    SendInfoMessage(playerid, "You have teleported to ATM machine %i.", id);
	}
	return 1;
}

CMD:editatm(playerid, params[])
{
	new id;

	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", id))
	{
		return SendSyntaxMessage(playerid, "/editatm (machine ID)");
	}
	else if (!IsValidATMID(id))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid ATM machine.");
	}
	else
	{
    	EditDynamicObjectEx(playerid, EDIT_TYPE_ATM, ATM[id][atmObject], id);
		SendInfoMessage(playerid, "Click on the disk icon to save changes.");
	}
	return 1;
}

CMD:deleteatm(playerid, params[])
{
	new id;

	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", id))
	{
	    return SendSyntaxMessage(playerid, "/deleteatm (machine ID)");
	}
	else if (!IsValidATMID(id))
	{
	    return SendErrorMessage(playerid, "You have specified an invalid ATM machine.");
	}
	else
	{
	    DestroyDynamic3DTextLabel(ATM[id][atmText]);
	    DestroyDynamicObject(ATM[id][atmObject]);

	    format(queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_atms WHERE `atmID` = %i", ATM[id][atmID]);
	    mysql_tquery(connectionID, queryBuffer);

		ATM[id][atmExists] = 0;
        SendInfoMessage(playerid, "You have deleted ATM %i.", id);
	}
	return 1;
}
CMD:removelocation(playerid, params[])
{
	new loc;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelocation [locationid]");
	}
	if(!(0 <= loc < MAX_LOCATIONS) || !LocationInfo[loc][locExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid location.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM locations WHERE id = %i", LocationInfo[loc][locID]);
	mysql_tquery(connectionID, queryBuffer);
	LocationInfo[loc][locName][0] = EOS;
	LocationInfo[loc][locExists] = false;
	LocationInfo[loc][locID] = 0;

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed location %i.", loc);
	return 1;
}

CMD:editland(playerid, params[])
{
	new landid, option[32], param[32];
	if(!IsGodAdmin(playerid)  && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[32]S()[32]", landid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editland [landid] [option]");
		SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Price, Level, Height, Owner, Seized");
		return 1;
	}
    if(!strcmp(option, "seized", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [0/1]", landid, option);
		}
		if(!(0<= value <= 1))
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Value cannot be less than 1 or more than 100M");
		}
		LandInfo[landid][lLabels] = 0;
	    LandInfo[landid][lSeized] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET seized = %i WHERE id = %i", value, LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);
		ReloadAllLandObjects(landid);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's seized to %i.", landid, value);		
	}
	else if(!strcmp(option, "price", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
		}
		if(!(1<= value <= 100000000))
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Value cannot be less than 1 or more than 100M");
		}
	    LandInfo[landid][lPrice] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET price = %i WHERE id = %i", value, LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's price to %i.", landid, value);
		ReloadLand(landid);
	}
	else if(!strcmp(option, "level", true))
	{
	    new value;
		if(sscanf(param, "i", value))
	    {
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
		}
		if(!(1 <= value <= 3))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Land levels cannot be below 0 or more than 3");
		}
	    LandInfo[landid][lLevel] = value;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET level = %i WHERE id = %i", value, LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's price to %i.", landid, value);
		ReloadLand(landid);
	}
	else if(!strcmp(option, "height", true))
	{
	    if(sscanf(param, "s", "confirm"))
	    {
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [confirm]", landid, option);
		}

		GetPlayerPos(playerid, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]);
 	  //  LandInfo[landid][lPickup] = zCoord[1]; We need this, land pickup, when you create a land at height it will create a pickup like house pickup.
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE lands SET heightx = %f, heighty = %f, heightz = %f WHERE id = %i", LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ], LandInfo[landid][lID]);
		mysql_tquery(connectionID, queryBuffer);
		SendClientMessageEx(playerid, COLOR_AQUA, "* You have land %i's (height) pos to your current height Pos (%f %f %f).", landid, LandInfo[landid][lHeightX], LandInfo[landid][lHeightY], LandInfo[landid][lHeightZ]);
		ReloadLand(landid);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;
		if(sscanf(param, "u", targetid))
	    {
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editland [%i] [%s] [value]", landid, option);
		}
	   	SetLandOwner(landid, targetid);

		SendClientMessageEx(playerid, COLOR_AQUA, "* You set land %i's owner to %s.", landid, GetRPName(targetid));
		ReloadLand(landid);
	}
	return 1;
}

CMD:namehistory(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /namehistory [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM log_namehistory WHERE uid = %i ORDER BY id DESC", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer, "OnAdminCheckNameHistory", "ii", playerid, targetid);

	return 1;
}


CMD:ahide(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return 0;
	}

	if(!PlayerData[playerid][pAdminHide])
	{
	    PlayerData[playerid][pAdminHide] = 1;
	    SendClientMessage(playerid, COLOR_AQUA, "You are now hidden in /admins and your admin rank no longer shows in /a, /g or /o.");
	}
	else
	{
	    PlayerData[playerid][pAdminHide] = 0;
	    SendClientMessage(playerid, COLOR_AQUA, "You are no longer hidden as an administrator.");
	}

	return 1;
}

CMD:picklock(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}
	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(VehicleInfo[vehicleid][vOwnerID] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You may only break into a player owned vehicle.");
	}
	if(VehicleInfo[vehicleid][vLocked] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle is unlocked. Therefore you can't break into it.");
	}
	if(PlayerData[playerid][pLockBreak] == vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already attempting to break into this vehicle.");
	}
	/*if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle cannot be broken into.");
	}*/
	if(IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Why would you want to break into your own vehicle?");
	}
	if(IsVehicleBeingPicked(vehicleid))
	{
 		return SendClientMessage(playerid, COLOR_GREY, "This vehicle is already being broken into by someone else.");
	}

	PlayerData[playerid][pLockBreak] = vehicleid;
	PlayerData[playerid][pLockHealth] = 1000.0;

	SendClientMessage(playerid, COLOR_AQUA, "You have started the {FF6347}break-in{33CCFF} process. Start hitting the driver or passenger side door to break it down.");
	SendClientMessage(playerid, COLOR_AQUA, "You can use your fists for this job, however melee weapons are preferred and gets the job done faster.");
	return 1;
}

CMD:breakcuffs(playerid, params[])
{
	return callcmd::picklockcuffs(playerid, params);
}
CMD:picklockcuffs(playerid, params[])
{
	static
		userid;

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_GREY, "Usage: /picklockcuffs [playerid/name]");

	if (PlayerData[playerid][pCrowbar] == 0)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a crowbar.");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendClientMessageEx(playerid, COLOR_GREY, "The specified player is disconnected or not near you.");

	if (!PlayerData[userid][pCuffed])
	    return SendClientMessageEx(playerid, COLOR_GREY, "The specified player is not cuffed.");

	if (userid == playerid)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can't pick your own handcuffs.");

	SetTimerEx("BreakCuffs", 3000, false, "dd", playerid, userid);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s attempts to pick the cuffs with a crowbar.", GetRPName(playerid));
	return 1;
}


CMD:dropcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(PlayerData[playerid][pThiefCooldown] > 0)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds before dropping off another car.", PlayerData[playerid][pThiefCooldown]);
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}
	if(IsVehicleOwner(playerid, vehicleid) || PlayerData[playerid][pVehicleKeys] == vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't drop off a vehicle that belongs to you.");
	}
	if(!GetVehicleCranePrice(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't worth anything. Therefore you can't sell it.");
	}
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have an active checkpoint already. /killcp to cancel it.");
	}
	if(VehicleInfo[vehicleid][vID] > 0 && IsPointInRangeOfPoint(VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], 600.0, 2695.8010, -2226.6643, 13.5501))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle is parked too close to the crane.");
	}

	if(!IsPlayerInRangeOfPoint(playerid, 300.0, 2695.8010, -2226.6643, 13.5501))
	{
	    PlayerData[playerid][pDropTime] = gettime();
	}

	PlayerData[playerid][pCP] = CHECKPOINT_DROPCAR;

	SendClientMessage(playerid, COLOR_AQUA, "Navigate to the {FF6347}checkpoint{33CCFF} at the crane to drop off your vehicle.");
	SetPlayerCheckpoint(playerid, 2695.8010, -2226.6643, 13.5501, 5.0);
	return 1;
}

CMD:carvalue(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be in a vehicle to use this command.");
	}
	if(IsVehicleOwner(playerid, vehicleid) || PlayerData[playerid][pVehicleKeys] == vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle belongs to you. It's not worth anything.");
	}
	if(!GetVehicleCranePrice(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't worth anything.");
	}

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Car Value _____");
	SendClientMessageEx(playerid, COLOR_GREY2, "Name: %s", GetVehicleName(vehicleid));

	if(GetVehicleCranePrice(vehicleid, false) == GetVehicleCranePrice(vehicleid))
	{
		SendClientMessageEx(playerid, COLOR_GREY2, "Value: {00AA00}$%i", GetVehicleCranePrice(vehicleid));
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY2, "Value: {00AA00}$%i", GetVehicleCranePrice(vehicleid, false));

	    if(VehicleInfo[vehicleid][vOwnerID] > 0)
	 	{
	 	    if(VehicleInfo[vehicleid][vNeon] != 0)
	 	    {
	 	        SendClientMessage(playerid, COLOR_GREY2, "Neon: {00AA00}+$1000");
			}
	 	    if(VehicleInfo[vehicleid][vAlarm] != 0)
	 	    {
	 	        SendClientMessageEx(playerid, COLOR_GREY2, "Alarm: {00AA00}+$%i", VehicleInfo[vehicleid][vAlarm] * 500);
			}
	 	    if(VehicleInfo[vehicleid][vTrunk] != 0)
	 	    {
			 	SendClientMessageEx(playerid, COLOR_GREY2, "Trunk: {00AA00}+$%i", VehicleInfo[vehicleid][vTrunk] * 250);
			}
		}

	    SendClientMessageEx(playerid, COLOR_GREY2, "Total Value: {00AA00}$%i", GetVehicleCranePrice(vehicleid));
	}

	return 1;
}

CMD:cracktrunk(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid);

	if(PlayerData[playerid][pCocaineCooldown] > 0)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds before cracking into another trunk.", PlayerData[playerid][pCocaineCooldown]);
	}
	if(vehicleid == INVALID_VEHICLE_ID || !IsPlayerInRangeOfBoot(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be close to a vehicle's trunk.");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from inside the vehicle.");
	}
	if(IsVehicleOwner(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't crack the trunk on your own vehicle.");
	}
	if(VehicleInfo[vehicleid][vOwnerID] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can only crack into a player owned vehicle's trunk.");
	}
	if(VehicleInfo[vehicleid][vLocked])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle is locked. /breakin to attempt to unlock it.");
	}
	if(PlayerData[playerid][pCocaineTrunk] != INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already cracking a trunk at the moment. Leave the area to cancel.");
	}
	PlayerData[playerid][pCocaineTrunk] = vehicleid;

	ShowActionBubble(playerid, "* %s begins to pry open the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_WHITE, "* This will take about %i seconds. Do not move during the process.", PlayerData[playerid][pCocaineTime]);
	return 1;
}

CMD:buyinsurance(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2323.3250,110.9966,-5.3942))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in any of the hospitals.");
	}
	if(PlayerData[playerid][pCash] < 2000)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford insurance.");
	}

	switch(GetPlayerVirtualWorld(playerid))
	{
	    case HOSPITAL_COUNTY:
	    {
	        if(PlayerData[playerid][pInsurance] == HOSPITAL_COUNTY)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "You are already insured at this hospital.");
	        }

	        GivePlayerCash(playerid, -2000);
	        GameTextForPlayer(playerid, "~r~-$2000", 5000, 1);
	        SendClientMessage(playerid, COLOR_AQUA, "You paid $2000 for insurance at {FF8282}County General{33CCFF}. You will now spawn here after death.");

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET insurance = %i WHERE uid = %i", HOSPITAL_COUNTY, PlayerData[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);

	        PlayerData[playerid][pInsurance] = HOSPITAL_COUNTY;
	    }
	    case HOSPITAL_ALLSAINTS:
	    {
	        if(PlayerData[playerid][pInsurance] == HOSPITAL_ALLSAINTS)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "You are already insured at this hospital.");
	        }

	        GivePlayerCash(playerid, -2000);
	        GameTextForPlayer(playerid, "~r~-$2000", 5000, 1);
	        SendClientMessage(playerid, COLOR_AQUA, "You paid $2000 for insurance at {FF8282}All Saints Hospital{33CCFF}. You will now spawn here after death.");

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET insurance = %i WHERE uid = %i", HOSPITAL_ALLSAINTS, PlayerData[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);

	        PlayerData[playerid][pInsurance] = HOSPITAL_ALLSAINTS;
	    }
	    case HOSPITAL_SAN_FIERRO:
	    {
	        if(PlayerData[playerid][pInsurance] == HOSPITAL_SAN_FIERRO)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "You are already insured at this hospital.");
	        }

	        GivePlayerCash(playerid, -4000);
	        GameTextForPlayer(playerid, "~r~-$4000", 5000, 1);
	        SendClientMessage(playerid, COLOR_AQUA, "You paid $4000 for insurance at {FF8282}San Fierro Medic Center{33CCFF}. You will now spawn here after death.");

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET insurance = %i WHERE uid = %i", HOSPITAL_SAN_FIERRO, PlayerData[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);

	        PlayerData[playerid][pInsurance] = HOSPITAL_SAN_FIERRO;
	    }
	}

	return 1;
}

CMD:tie(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /tie [playerid]");
    }
    if (PlayerData[playerid][pRope] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any ropes left.");
    }
    if (targetid == playerid || !IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie yourself.");
    }
    if (PlayerData[targetid][pPaintball])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't cuff this player when he is in paintball.");
    }
    if (PlayerData[targetid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already handcuffed.");
    }
    if (PlayerData[targetid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already tied. /untie to free them.");
    }
    if (PlayerData[targetid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie a helper who is assisting someone.");
    }
    if (PlayerData[targetid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie an on duty administrator.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to tie anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
    if (IsPlayerInEvent(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't tie player while you are in an event.");
    }
    new bool:canHandcuff;

    if (PlayerData[targetid][pTazedTime] > 0)
        canHandcuff = true;

    if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_HANDSUP)
        canHandcuff = true;

    if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DUCK)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1441)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1151)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1150)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 960)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1701)
        canHandcuff = true;

    if (!canHandcuff)
    {
        return SendClientMessage(playerid, COLOR_ADM, "That player needs to be crouched, have their hands up or be on the floor.");
    }

    PlayerData[playerid][pRope]--;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rope = %i WHERE uid = %i", PlayerData[playerid][pRope], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    GameTextForPlayer(targetid, "~r~Tied", 3000, 3);
    ShowActionBubble(playerid, "* %s ties %s with a rope.", GetRPName(playerid), GetRPName(targetid));

    TogglePlayerControllableEx(targetid, 0);
    PlayerData[targetid][pTied] = 1;
    return 1;
}

CMD:untie(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /untie [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't untie yourself.");
    }
    if (!PlayerData[targetid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not tied.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to untie anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    GameTextForPlayer(targetid, "~g~Untied", 3000, 3);
    ShowActionBubble(playerid, "* %s unties the rope from %s.", GetRPName(playerid), GetRPName(targetid));

    TogglePlayerControllableEx(targetid, 1);
    PlayerData[targetid][pTied] = 0;
    return 1;
}

CMD:blindfold(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /blindfold [playerid]");
	}
	if(PlayerData[playerid][pBlindfold] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have any blindfolds left.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't blindfold yourself.");
	}
	if(!PlayerData[targetid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is not tied.");
	}
	if(PlayerData[targetid][pBlinded])
	{
		return SendClientMessage(playerid, COLOR_GREY, "That player is already blindfolded.");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to blindfold anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}

	PlayerData[playerid][pBlindfold]--;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET blindfold = %i WHERE uid = %i", PlayerData[playerid][pBlindfold], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	TextDrawShowForPlayer(targetid, Blind);
	GameTextForPlayer(targetid, "~r~Blindfolded", 3000, 3);
	ShowActionBubble(playerid, "* %s blindfolds %s with a piece of rag.", GetRPName(playerid), GetRPName(targetid));

	PlayerData[targetid][pBlinded] = 1;
	return 1;
}

CMD:removeblindfold(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeblindfold [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid && PlayerData[playerid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't remove your own blindfold while tied.");
	}
	if(!PlayerData[targetid][pBlinded])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not blindfolded.");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to remove anyone's blindfold. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}

    TextDrawHideForPlayer(targetid, Blind);
	ShowActionBubble(playerid, "* %s removes the blindfold from %s.", GetRPName(playerid), GetRPName(targetid));

	PlayerData[targetid][pBlinded] = 0;
	return 1;
}

CMD:repaircar(playerid, params[])
{
	new entranceid = GetNearbyEntrance(playerid);

	if(entranceid == -1 || EntranceInfo[entranceid][eType] != 2)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't nearby any repairshops.");
	}
	if(EntranceInfo[entranceid][eAdminLevel] && PlayerData[playerid][pAdmin] < EntranceInfo[entranceid][eAdminLevel])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your administrator level is too low to repair here.");
	}
	if(EntranceInfo[entranceid][eFaction] >= 0 && PlayerData[playerid][pFaction] != EntranceInfo[entranceid][eFaction])
	{
    	return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific faction type.");
	}
	if(EntranceInfo[entranceid][eGang] >= 0 && EntranceInfo[entranceid][eGang] != PlayerData[playerid][pGang])
	{
    	return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific gang type.");
	}
	if(EntranceInfo[entranceid][eVIP] && PlayerData[playerid][pDonator] < EntranceInfo[entranceid][eVIP])
	{
    	return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a higher VIP level.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't driving a vehicle.");
	}
    RepairVehicle(GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, COLOR_GREY, "Your vehicle was repaired.");
	return 1;
}

CMD:offerduel(playerid, params[])
{
	new entranceid = GetInsideEntrance(playerid), targetid;

	if(entranceid == -1 || EntranceInfo[entranceid][eType] != 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of a duel arena.");
	}
	if(EntranceInfo[entranceid][eAdminLevel] && PlayerData[playerid][pAdmin] < EntranceInfo[entranceid][eAdminLevel])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Your administrator level is too low to initiate duels here.");
	}
	if(EntranceInfo[entranceid][eFaction] >= 0 && PlayerData[playerid][pFaction] != EntranceInfo[entranceid][eFaction])
	{
    	return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific faction type.");
	}
	if(EntranceInfo[entranceid][eGang] >= 0 && EntranceInfo[entranceid][eGang] != PlayerData[playerid][pGang])
	{
    	return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific gang type.");
	}
	if(EntranceInfo[entranceid][eVIP] && PlayerData[playerid][pDonator] < EntranceInfo[entranceid][eVIP])
	{
    	return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a higher VIP level.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /offerduel [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 15.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't offer to duel with yourself.");
	}
	if(PlayerData[targetid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already in a duel.");
	}

	PlayerData[targetid][pDuelOffer] = playerid;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s has offered you to duel with them. (/accept duel)", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a duel offer.", GetRPName(targetid));
	return 1;
}

CMD:confirmupgrade(playerid, params[])
{
    new houseid = PlayerData[playerid][pPreviewHouse], type = PlayerData[playerid][pPreviewType];
    if (houseid == INVALID_HOUSE_ID || !IsHouseOwner(playerid, houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't previewing a house interior at the moment.");
    }

	RCHECK(houseInteriors[type][intForDonnation] && !IsGodAdmin(playerid), 
    "This interior is available only for donation.");

    if (PlayerData[playerid][pCash] < houseInteriors[type][intPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to upgrade to this interior.");
    }

	foreach(new i : Player)
	{
	    if(GetInsideHouse(i) == houseid)
	    {
	        SetPlayerPos(i, houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ]);
	        SetPlayerFacingAngle(i, houseInteriors[type][intA]);
	        SetPlayerInterior(i, houseInteriors[type][intID]);
	        SetCameraBehindPlayer(i);
	    }
	}

	GivePlayerCash(playerid, -houseInteriors[type][intPrice]);

    HouseInfo[houseid][hType] = type;
    HouseInfo[houseid][hPrice] = houseInteriors[type][intPrice];
	HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
	HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
	HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
	HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
	HouseInfo[houseid][hIntA] = houseInteriors[type][intA];

    PlayerData[playerid][pPreviewHouse] = -1;
    PlayerData[playerid][pPreviewType] = 0;
    PlayerData[playerid][pPreviewTime] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET type = %i, price = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type, HouseInfo[houseid][hPrice], HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
    mysql_tquery(connectionID, queryBuffer);

    SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your house to this interior for $%i.", houseInteriors[type][intPrice]);
    Log_Write("log_property", "%s (uid: %i) upgraded their house interior (id: %i) to interior %i for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hID], type, houseInteriors[type][intPrice]);
	return 1;
}

CMD:cancelupgrade(playerid, params[])
{
	new houseid = PlayerData[playerid][pPreviewHouse];

	if(houseid == -1 || !IsHouseOwner(playerid, houseid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You aren't previewing a house interior at the moment.");
	}

	SetPlayerPos(playerid, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ]);
	SetPlayerFacingAngle(playerid, HouseInfo[houseid][hIntA]);
	SetPlayerInterior(playerid, HouseInfo[houseid][hInterior]);
	SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hWorld]);
	SetCameraBehindPlayer(playerid);

	PlayerData[playerid][pPreviewHouse] = -1;
    PlayerData[playerid][pPreviewType] = 0;
    PlayerData[playerid][pPreviewTime] = 0;

    SendClientMessage(playerid, COLOR_WHITE, "You have cancelled your interior upgrade. You were returned back to your old one.");
    return 1;
}


CMD:vipmusic(playerid, params[])
{
	if(PlayerData[playerid][pDonator] < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be a donator to use this command!");
	}
	if(isnull(params))
	{
	 	return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vipmusic [songname.mp3]");
	}
	if(gettime() - gLastMusic < 300)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Music can only be played globally every 5 minutes.");
	}
	new url[144];
	format(url, sizeof(url), "http://%s/%i/%s", GetVipMusicUrl(), PlayerData[playerid][pID], params);
	foreach(new i : Player)
	{
 		if(!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
   		{
			PlayAudioStreamForPlayer(i, url);
		}
	}
	SendClientMessageToAllEx(COLOR_VIP, "VIP Music: %s VIP %s has started the global playback of %s from their music folder!", GetVIPRank(PlayerData[playerid][pDonator]), GetRPName(playerid), params);
    gLastMusic = gettime();
	return 1;
}

CMD:garbage(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!PlayerHasJob(playerid, JOB_GARBAGEMAN))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a Garbage Man.");
	}

	if(!IsPlayerInRangeOfPoint(playerid, 8.0,  2404.9758, -2070.3882, 13.5469))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not at the starting point");
	}
	if(PlayerData[playerid][pGarbage] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're already doing a garbage run!");
	}
	if(GetVehicleModel(vehicleid) == 408 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{

		GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
		PlayerData[playerid][pGarbage] = 1;
		PlayerData[playerid][pCP] = CHECKPOINT_GARBAGE;
	 	SetPlayerCheckpoint(playerid, 2382.1963,-1937.9064,13.5469, 5.0);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You must be in a trashmaster vehicle as a driver");
	}
	return 1;
}


CMD:clearreports(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

	for(new i = 0; i < MAX_REPORTS; i ++)
	{
 		if(ReportInfo[i][rExists])
		{
			ReportInfo[i][rExists] = 0;
		}
	}
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has cleared all active reports.", GetRPName(playerid));
	return 1;
}

CMD:firstaid(playerid, params[])
{
	if(PlayerData[playerid][pFirstAid] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have any first aid kits.");
	}
	if(GetPlayerHealthEx(playerid) >= 100)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can only use a first aid kit if your health is below 100.");
	}
	if(PlayerData[playerid][pReceivingAid])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have already used a first aid kit.");
	}

	PlayerData[playerid][pFirstAid]--;
	PlayerData[playerid][pReceivingAid] = 1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	ShowActionBubble(playerid, "* %s administers first aid to their self.", GetRPName(playerid));
	SendClientMessage(playerid, COLOR_WHITE, "HINT: Your first aid kit is in effect until your health is full.");
	return 1;
}

CMD:scanner(playerid, params[])
{
	if(!PlayerData[playerid][pPoliceScanner])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a police scanner.");
	}

	if(!PlayerData[playerid][pScannerOn])
	{
	    PlayerData[playerid][pScannerOn] = 1;
	    ShowActionBubble(playerid, "* %s turns on their police scanner.", GetRPName(playerid));
	    SendClientMessage(playerid, COLOR_WHITE, "You will now hear messages from emergency and department chats.");
	}
	else
	{
	    PlayerData[playerid][pScannerOn] = 0;
	    ShowActionBubble(playerid, "* %s turns off their police scanner.", GetRPName(playerid));
	}

	return 1;
}

CMD:bodykit(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}
	if(PlayerData[playerid][pBodykits] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no bodywork kits which you can use.");
	}
	if(gettime() - PlayerData[playerid][pLastRepair] < 60)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 60 seconds. Please wait %i more seconds.", 60 - (gettime() - PlayerData[playerid][pLastRepair]));
	}

    PlayerData[playerid][pBodykits]--;
    PlayerData[playerid][pLastRepair] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	RepairVehicle(GetPlayerVehicleID(playerid));
	ShowActionBubble(playerid, "* %s repairs the health and bodywork on their vehicle.", GetRPName(playerid));
	return 1;
}

CMD:viprimkit(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}
	if(PlayerData[playerid][pDonator] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be a Legendary VIP to use this command.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pVehicleKeys] != vehicleid && !(VehicleInfo[vehicleid][vGang] >= 0 && PlayerData[playerid][pGang] == VehicleInfo[vehicleid][vGang]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't belong to you.");
	}
	if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in this type of vehicle.");
	}

	Dialog_Show(playerid, DIALOG_USERIMKIT, DIALOG_STYLE_LIST, "Choose which set of rims to install.", "Offroad\nShadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutter\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nAhab\nVirtual\nAccess", "Select", "Cancel");
	return 1;
}

CMD:rimkit(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}
	if(PlayerData[playerid][pRimkits] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have no rimkits which you can use.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pVehicleKeys] != vehicleid && !(VehicleInfo[vehicleid][vGang] >= 0 && PlayerData[playerid][pGang] == VehicleInfo[vehicleid][vGang]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't belong to you.");
	}
	if(!VehicleHasDoors(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in this type of vehicle.");
	}

	Dialog_Show(playerid, DIALOG_USERIMKIT, DIALOG_STYLE_LIST, "Choose which set of rims to install.", "Offroad\nShadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutter\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nAhab\nVirtual\nAccess", "Select", "Cancel");
	return 1;
}

CMD:shutdownserver(playerid, params[])
{
	if(IsGodAdmin(playerid))
	{

		if(strcmp(params, "confirm", true))
		{
			SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /shutdown [confirm]");
 			SendClientMessage(playerid, COLOR_GREY3, "This command save all player accounts and shutsdown the server.");
  			return 1;
		}
		if(gGMX)
		{
	 	  	return SendClientMessage(playerid, COLOR_GREY, "You have already called for a server shutdown. You can't cancel it.");
		}

  		gGMX = 0;
		SetTimer("FinishServerShutdown", 5000, false);
		SendClientMessage(playerid, COLOR_GREY, "Server will shutdown in 5 seconds.");

		foreach(new i : Player)
		{
		    TogglePlayerControllableEx(i, 0);
			SavePlayerVariables(i);
		}
	}
	return 1;
}

CMD:showrules(playerid, params[])
{
	new giveplayerid;
	if(!(PlayerData[playerid][pAdmin]>=1 || PlayerData[playerid][pHelper]>=2)) return SendClientErrorUnauthorizedCmd(playerid);

	if(sscanf(params,"i",giveplayerid)) return SendClientMessage(playerid, COLOR_GREY, "/showrules [playerid]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_GREY, "That player is not connected");
	return ShowDialogToPlayer(giveplayerid, DIALOG_RULES);
}

CMD:rules(playerid, params[])
{
	return ShowDialogToPlayer(playerid, DIALOG_RULES);
}

CMD:fpm(playerid, params[]) {

	if(!firstperson[playerid])
	{
		firstperson[playerid] = 1;
		new iObjectID = CreateDynamicObjectEx(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		SetPVarInt(playerid, "FP_OBJ", iObjectID);
        AttachObjectToPlayer(iObjectID, playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
        AttachCameraToObject(playerid, iObjectID);
	}
	else {

		firstperson[playerid] = 0;
		DestroyObject(GetPVarInt(playerid, "FP_OBJ"));
		DeletePVar(playerid, "FP_OBJ");
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}


/* Commands */


CMD:cursor(playerid, params) {
	SelectTextDraw(playerid, -1);
	return 1;
}

CMD:gundercover(playerid, params[])
{
	new name[MAX_PLAYER_NAME], level, Float:ar;
    
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}

    if(PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Not Authorized / You need to be off duty to use this command.");
    }

    if(sscanf(params, "s[24]", name))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gundercover [name | random | off]");
    }
    if(PlayerData[playerid][pUndercover][0])
    {
        OnUndercover(playerid, 0, "", 0, 0.0, 0.0);
        SendClientMessageEx(playerid, COLOR_WHITE, "* You are no longer undercover.", GetRPName(playerid), name);
    }
    else if(!strcmp(name, "random", true)) {
        strcpy(name, getRandomRPName());
        level = random(9) + 1;
        ar = float(random(50)+50);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
        mysql_tquery(connectionID, queryBuffer, "OnUndercover", "iisiff", playerid, 1, name, level, 100.0, ar);
    }
    else if(strfind(name, "_") != -1) {
        //format(name, MAX_PLAYER_NAME, params);
        level = random(9) + 1;
        ar = float(random(50)+50);
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", name);
        mysql_tquery(connectionID, queryBuffer, "OnUndercover", "iisiff", playerid, 1, name, level, 100.0, ar);
    }
    else
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gundercover [Firstname_Lastname | random]");
    }

	
	return 1;
}

