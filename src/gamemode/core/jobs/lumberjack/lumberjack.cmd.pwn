
CMD:log(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_LUMBERJACK))
	{
		SendClientMessage(playerid, COLOR_GREY, "   You're not a Lumberjack!");
		return 1;
	}

	if(IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't use this command in a vehicle.");
    
	if(isnull(params)) 
		return SendClientMessage(playerid, 0xE88732FF, "USAGE: {FFFFFF}/log [load/take/takefromcar/takefromtree/sell]");
    
    if(!strcmp(params, "load", true)) {
        // loading to a bobcat
        if(!CarryingLog[playerid]) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not carrying a log.");
		
        new vehicleid = GetNearbyVehicle(playerid);
		
        if(GetCarJobType(vehicleid)!=JOB_LUMBERJACK) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a lumberjack vehicle.");
		
        new Float: x, Float: y, Float: z;
    	GetVehicleBoot(vehicleid, x, y, z);

    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a lumberjack vehicle.");
            
    	if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't load any more logs to this vehicle.");

    	for(new i; i < LOG_LIMIT; i++)
    	{
    	    if(!IsValidDynamicObject(LogObjects[vehicleid][i]))
    	    {
    	        LogObjects[vehicleid][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    			AttachDynamicObjectToVehicle(LogObjects[vehicleid][i], vehicleid, LogAttachOffsets[i][0], LogAttachOffsets[i][1], LogAttachOffsets[i][2], 0.0, 0.0, LogAttachOffsets[i][3]);
    			break;
    	    }
    	}
    	
    	Streamer_Update(playerid);
    	Player_RemoveLog(playerid);
    	SendClientMessage(playerid, 0x3498DBFF, "LUMBERJACK: {FFFFFF}Loaded a log.");
    	// done
    }else if(!strcmp(params, "take")) {
        // taking from ground
        if(CarryingLog[playerid]) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're already carrying a log.");
		new id = GetClosestLog(playerid);
		if(id == -1) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a log.");
		LogData[id][logSeconds] = 1;
		RemoveLog(id);

		
		Player_GiveLog(playerid);
		SendClientMessage(playerid, 0x3498DBFF, "LUMBERJACK: {FFFFFF}You've taken a log from ground.");
		// done
    }else if(!strcmp(params, "takefromcar")) {
        // taking from a bobcat
        if(CarryingLog[playerid]) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're already carrying a log.");
        new id = GetNearbyVehicle(playerid);
		if(GetVehicleModel(id) != 422) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a lumberjack vehicle.");
		new Float: x, Float: y, Float: z;
    	GetVehicleBoot(id, x, y, z);
    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a  lumberjack vehicle's back.");
    	if(Vehicle_LogCount(id) < 1) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This vehicle doesn't have any logs.");
    	for(new i = (LOG_LIMIT - 1); i >= 0; i--)
    	{
    	    if(IsValidDynamicObject(LogObjects[id][i]))
    	    {
    	        DestroyDynamicObject(LogObjects[id][i]);
    	        LogObjects[id][i] = -1;
    			break;
    	    }
    	}

    	Streamer_Update(playerid);
    	Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "LUMBERJACK: {FFFFFF}You've taken a log from the vehicle.");
        // done
    }else if(!strcmp(params, "takefromtree")) {
		// taking from a cut tree
		if(CarryingLog[playerid]) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're already carrying a log.");
        new id = GetClosestTree(playerid);
        if(id == -1)
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a tree.");
        if(lumberjackTrees[id][treeSeconds] < 1) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This tree isn't cut.");
        if(lumberjackTrees[id][treeLogs] < 1) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This tree doesn't have any logs.");
        lumberjackTrees[id][treeLogs]--;
        Tree_UpdateLogLabel(id);
        
        Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "LUMBERJACK: {FFFFFF}You've taken a log from the cut tree.");
        // done
    }else if(!strcmp(params, "sell")) {
        // selling a log
        if(!CarryingLog[playerid]) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not carrying a log.");

		if(!IsPlayerNearALogBuyer(playerid)) 
            return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near a Log Buyer.");

		Player_RemoveLog(playerid);
		GivePlayerCash(playerid, LOG_PRICE);
        GivePlayerRankPoints(playerid, 30);

		new string[64];
		format(string, sizeof(string), "LUMBERJACK: {FFFFFF}Sold a log for {2ECC71}$%d.", LOG_PRICE);
    	SendClientMessage(playerid, 0x3498DBFF, string);
        // done
    }

	return 1;
}
