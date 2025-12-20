#include <YSI\y_hooks>

hook OnLoadGameMode(timestamp)
{
    lumberjackVehicles[0] = AddStaticVehicleEx(422, 2559.4063, -834.9167, 84.9475, 158.3596, -1, -1, LJ_RESPAWN_CAR);
    lumberjackVehicles[1] = AddStaticVehicleEx(422, 2555.5278, -833.3437, 85.4854, 158.3596, -1, -1, LJ_RESPAWN_CAR);
    lumberjackVehicles[2] = AddStaticVehicleEx(422, 2563.5745, -836.7965, 84.2524, 158.3596, -1, -1, LJ_RESPAWN_CAR);
    lumberjackVehicles[3] = AddStaticVehicleEx(422, 2552.6494, -839.8227, 85.4792, 158.3596, -1, -1, LJ_RESPAWN_CAR);
    lumberjackVehicles[4] = AddStaticVehicleEx(422, 2556.4998, -841.4875, 84.9413, 158.3596, -1, -1, LJ_RESPAWN_CAR);
    lumberjackVehicles[5] = AddStaticVehicleEx(422, 2560.6362, -843.4612, 84.2461, 158.3596, -1, -1, LJ_RESPAWN_CAR);
    
    createTree(0, 2568.33203, -202.06619, 34.78978,   0.00000, 0.00000, 0.00000);
	createTree(1, 2553.46045, -202.01962, 33.73297,   0.00000, 0.00000, 0.00000);
	createTree(2, 2563.23438, -202.79549, 34.02590,   0.00000, 0.00000, 0.00000);
	createTree(3, 2558.91455, -206.07932, 33.02991,   0.00000, 0.00000, 0.00000);
	createTree(4, 2549.37378, -209.27513, 32.03183,   0.00000, 0.00000, 0.00000);
	createTree(5, 2550.83643, -213.64497, 31.13375,   0.00000, 0.00000, 0.00000);
	createTree(6, 2558.10083, -211.64549, 31.80146,   0.00000, 0.00000, 0.00000);
	createTree(7, 2544.07788, -209.96518, 31.57146,   0.00000, 0.00000, 0.00000);
	createTree(8, 2543.60815, -212.97000, 30.99224,   0.00000, 0.00000, 0.00000);
	createTree(9, 2530.71753, -209.25206, 30.36817,   0.00000, 0.00000, 0.00000);
	createTree(10, 2535.60034, -204.53218, 31.69071,   0.00000, 0.00000, 0.00000);
	createTree(11, 2537.39063, -213.20561, 30.33167,   0.00000, 0.00000, 0.00000);
	createTree(12, 2569.89429, -210.49519, 33.14504,   0.00000, 0.00000, 0.00000);
	createTree(13, 2565.75049, -223.80145, 31.43533,   0.00000, 0.00000, 0.00000);
	createTree(14, 2564.81860, -216.03369, 31.34235,   0.00000, 0.00000, 0.00000);
	createTree(15, 2572.29321, -217.26541, 32.07874,   0.00000, 0.00000, 0.00000);
	createTree(16, 2574.65649, -228.55649, 32.69022,   0.00000, 0.00000, 0.00000);
	createTree(17, 2582.89258, -220.05466, 33.36254,   0.00000, 0.00000, 0.00000);
	createTree(18, 2581.84302, -206.58842, 35.41304,   0.00000, 0.00000, 0.00000);
	createTree(19, 2586.11841, -208.82619, 35.43773,   0.00000, 0.00000, 0.00000);
	createTree(20, 2573.85156, -206.48630, 34.48411,   0.00000, 0.00000, 0.00000);
	createTree(21, 2581.80786, -231.35112, 33.61483,   0.00000, 0.00000, 0.00000);
	createTree(22, 2576.94824, -185.16162, 38.72237,   0.00000, 0.00000, 0.00000);
	createTree(23, 2567.54883, -186.27046, 38.10649,   0.00000, 0.00000, 0.00000);
	createTree(24, 2585.27466, -188.98058, 38.88435,   0.00000, 0.00000, 0.00000);
	createTree(25, 2569.08765, -193.81465, 36.66370,   0.00000, 0.00000, 0.00000);
	createTree(26, 2578.58960, -195.42400, 37.44604,   0.00000, 0.00000, 0.00000);
	createTree(27, 2588.59839, -197.69215, 38.14640,   0.00000, 0.00000, 0.00000);
	createTree(28, 2560.45215, -192.26299, 36.06314,   0.00000, 0.00000, 0.00000);
	createTree(29, 2559.50195, -181.46141, 38.22064,   0.00000, 0.00000, 0.00000);
	createTree(30, 2552.03052, -191.18196, 35.69247,   0.00000, 0.00000, 0.00000);
	createTree(31, 2550.97705, -177.30916, 38.24263,   0.00000, 0.00000, 0.00000);
	createTree(32, 2544.02612, -189.69902, 35.16412,   0.00000, 0.00000, 0.00000);
	createTree(33, 2544.87817, -198.75540, 33.63190,   0.00000, 0.00000, 0.00000);
	createTree(34, 2538.21167, -189.34392, 34.62656,   0.00000, 0.00000, 0.00000);
    return 1;
}

hook OnPlayerInit(playerid)
{
    CuttingTreeID[playerid] = -1;
    return 1;
}


Tree_UpdateLogLabel(id)
{
    //if(!Iter_Contains(Trees, id)) return 0;
    new label[96];
    
    if(lumberjackTrees[id][treeLogs] > 0) {
	    format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Logs: {F1C40F}%d\n{FFFFFF}Use {F1C40F}/log takefromtree {FFFFFF}to take a log.", id, lumberjackTrees[id][treeLogs]);
		UpdateDynamic3DTextLabelText(lumberjackTrees[id][treeLabel], 0xE74C3CFF, label);
	}else{
	    lumberjackTrees[id][treeTimer] = SetTimerEx("RespawnTree", 1000, true, "i", id);
	    
	    format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}%s", id, ConvertToMinutes(lumberjackTrees[id][treeSeconds]));
		UpdateDynamic3DTextLabelText(lumberjackTrees[id][treeLabel], 0xE74C3CFF, label);
	}
	
	return 1;
}

Player_ResetCutting(playerid)
{
	if(!IsPlayerConnected(playerid) || CuttingTreeID[playerid] == -1) return 0;
	new id = CuttingTreeID[playerid];
	lumberjackTrees[id][treeGettingCut] = false;
	if(lumberjackTrees[id][treeSeconds] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, lumberjackTrees[id][treeLabel], E_STREAMER_COLOR, 0x2ECC71FF);
	
	RemovePlayerAttachedObject(playerid, 9);
	ClearAnimations(playerid);
    TogglePlayerControllableEx(playerid, 1);
    CuttingTreeID[playerid] = -1;
    
	return 1;
}


OnLumberJackVehicleRespawned(vehicleid)
{
	for(new i = (LOG_LIMIT - 1); i >= 0; i--)
	{
		if(IsValidDynamicObject(LogObjects[vehicleid][i]))
		{
			DestroyDynamicObject(LogObjects[vehicleid][i]);
			LogObjects[vehicleid][i] = -1;
		}
	}
}

SetPlayerLookAt(playerid, Float:x, Float:y)
{
	// somewhere on samp forums, couldn't find the source
	new Float:Px, Float:Py, Float: Pa;
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	SetPlayerFacingAngle(playerid, Pa);
}

ConvertToMinutes(time)
{
    // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
    new string[15];//-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

createTree(treeid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    
    lumberjackTrees[treeid][treeX] = x;
    lumberjackTrees[treeid][treeY] = y;
    lumberjackTrees[treeid][treeZ] = z;
    lumberjackTrees[treeid][treeRX] = rx;
    lumberjackTrees[treeid][treeRY] = ry;
    lumberjackTrees[treeid][treeRZ] = rz;

    lumberjackTrees[treeid][treeLogs] = 5;
	lumberjackTrees[treeid][treeSeconds] = 0;
	lumberjackTrees[treeid][treeGettingCut] = false;
	lumberjackTrees[treeid][treeTimer] = -1;

    lumberjackTrees[treeid][treeObjID] = CreateDynamicObject(657, x, y, z, rx, ry, rz);

    new label[128];
    format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cut down.", treeid);
    lumberjackTrees[treeid][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, x, y, z + 1.5, 5.0);

}

GetClosestTree(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	for(new i=0;i<sizeof(lumberjackTrees);i++)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, lumberjackTrees[i][treeX], lumberjackTrees[i][treeY], lumberjackTrees[i][treeZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

forward RespawnTree(treeid);
public RespawnTree(treeid)
{
	new label[96];
	if(lumberjackTrees[treeid][treeSeconds] > 1) {
	    lumberjackTrees[treeid][treeSeconds]--;
	    
	    format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}%s", treeid, ConvertToMinutes(lumberjackTrees[treeid][treeSeconds]));
		UpdateDynamic3DTextLabelText(lumberjackTrees[treeid][treeLabel], 0xE74C3CFF, label);
	}else if(lumberjackTrees[treeid][treeSeconds] == 1) {
	    KillTimer(lumberjackTrees[treeid][treeTimer]);

	    lumberjackTrees[treeid][treeLogs] = 0;
	    lumberjackTrees[treeid][treeSeconds] = 0;
	    lumberjackTrees[treeid][treeTimer] = -1;
	    
	    SetDynamicObjectPos(lumberjackTrees[treeid][treeObjID], lumberjackTrees[treeid][treeX], lumberjackTrees[treeid][treeY], lumberjackTrees[treeid][treeZ]);
     	SetDynamicObjectRot(lumberjackTrees[treeid][treeObjID], lumberjackTrees[treeid][treeRX], lumberjackTrees[treeid][treeRY], lumberjackTrees[treeid][treeRZ]);
     	
     	format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cut down.", treeid);
     	UpdateDynamic3DTextLabelText(lumberjackTrees[treeid][treeLabel], 0x2ECC71FF, label);
	}
	
	return 1;
}


forward CutTree(playerid);
public CutTree(playerid)
{
    if(CuttingTreeID[playerid] != -1)
	{
	    new id = CuttingTreeID[playerid];
	    
		Player_ResetCutting(playerid);
		MoveDynamicObject(lumberjackTrees[id][treeObjID], 
				lumberjackTrees[id][treeX], 
				lumberjackTrees[id][treeY], 
				lumberjackTrees[id][treeZ] + 0.03, 
				0.025, 
				lumberjackTrees[id][treeRX], 
				lumberjackTrees[id][treeRY] - 80.0, 
				lumberjackTrees[id][treeRZ]);

		lumberjackTrees[id][treeLogs] = 5;
		lumberjackTrees[id][treeSeconds] = TREE_RESPAWN;
		SendClientMessageEx(playerid, COLOR_AQUA, "The tree (%d) is down.", id);
		Tree_UpdateLogLabel(id);
		
	} else SendClientMessageEx(playerid, COLOR_AQUA, "Player (%d) is not cutting any tree.", playerid);
	return 1;
}


LumberJackPlayerKeyStateChange(playerid, newkeys)
{
	if(PlayerHasJob(playerid, JOB_LUMBERJACK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(CarryingLog[playerid]) return Player_DropLog(playerid);
	    
	    if(CuttingTreeID[playerid] == -1)// && !CarryingLog[playerid])
	    {
		    new treeid = GetClosestTree(playerid);
		    
            if((treeid != -1) && (!lumberjackTrees[treeid][treeGettingCut]) && (lumberjackTrees[treeid][treeSeconds] < 1))
            {
                SetPlayerLookAt(playerid, lumberjackTrees[treeid][treeX], lumberjackTrees[treeid][treeY]);

                Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, lumberjackTrees[treeid][treeLabel], E_STREAMER_COLOR, 0xE74C3CFF);
                
                SetTimerEx("CutTree", CUTTING_TIME * 1000, false, "i", playerid);
                CuttingTreeID[playerid] = treeid;
                

                TogglePlayerControllableEx(playerid, 0);
				SetPlayerAttachedObject(playerid, 9, 341, 6);
                ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);
                lumberjackTrees[treeid][treeGettingCut] = true;
            }        
	    }
	}

	return 1;
}



Player_GiveLog(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
	CarryingLog[playerid] = true;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, ATTACH_INDEX, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
	
	SendClientMessage(playerid, 0x3498DBFF, "LUMBERJACK: {FFFFFF}You can press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to drop your log.");
	return 1;
}

Player_DropLog(playerid, death_drop = 0)
{
    if(!IsPlayerConnected(playerid) || !CarryingLog[playerid]) return 0;
    new id = Iter_Free(Logs);
    if(id != -1)
    {
        new Float: x, Float: y, Float: z, Float: a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, LogData[id][logDroppedBy], MAX_PLAYER_NAME);

		if(!death_drop)
		{
		    x += (1.0 * floatsin(-a, degrees));
			y += (1.0 * floatcos(-a, degrees));
			
			ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		}

		LogData[id][logSeconds] = LOG_LIFETIME;
		LogData[id][logObjID] = CreateDynamicObject(19793, x, y, z - 0.9, 0.0, 0.0, a);
		
		format(label, sizeof(label), "Log (%d)\n\n{FFFFFF}Dropped By {F1C40F}%s\n{FFFFFF}%s\nUse {F1C40F}/log take {FFFFFF}to take it.", id, LogData[id][logDroppedBy], ConvertToMinutes(LOG_LIFETIME));
		LogData[id][logLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, x, y, z - 0.7, 5.0, .testlos = 1);
		
		LogData[id][logTimer] = SetTimerEx("RemoveLog", 1000, true, "i", id);
		Iter_Add(Logs, id);
    }
    
    Player_RemoveLog(playerid);
	return 1;
}

Player_RemoveLog(playerid)
{
	if(!IsPlayerConnected(playerid) || !CarryingLog[playerid]) return 0;
	RemovePlayerAttachedObject(playerid, ATTACH_INDEX);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	CarryingLog[playerid] = false;
	return 1;
}

Vehicle_LogCount(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 0) return 0;
	new count;
	for(new i; i < LOG_LIMIT; i++) if(IsValidDynamicObject(LogObjects[vehicleid][i])) count++;
	return count;
}

stock Vehicle_RemoveLogs(vehicleid)
{
    if(GetVehicleModel(vehicleid) == 0) return 0;
    for(new i; i < LOG_LIMIT; i++)
	{
	    if(IsValidDynamicObject(LogObjects[vehicleid][i]))
	    {
	        DestroyDynamicObject(LogObjects[vehicleid][i]);
	        LogObjects[vehicleid][i] = -1;
	    }
	}
	
	return 1;
}


GetClosestLog(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist, Float: pos[3];
	foreach(new i : Logs)
	{
		GetDynamicObjectPos(LogData[i][logObjID], pos[0], pos[1], pos[2]);
	    tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}

	return id;
}

IsPlayerNearALogBuyer(playerid)
{
	for(new i=0;i<sizeof(jobLocations);i++)
	{
		if( jobLocations[i][jobID] == JOB_LUMBERJACK && 
			IsPlayerInRangeOfPoint(playerid, 2.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
			return 1;
	}
	return 0;
}


forward RemoveLog(id);
public RemoveLog(id)
{
	if(!Iter_Count(Logs, id)) return 1;
	
	if(LogData[id][logSeconds] > 1) {
	    LogData[id][logSeconds]--;

        new label[128];
	    format(label, sizeof(label), "Log (%d)\n\n{FFFFFF}Dropped By {F1C40F}%s\n{FFFFFF}%s\nUse {F1C40F}/log take {FFFFFF}to take it.", id, LogData[id][logDroppedBy], ConvertToMinutes(LogData[id][logSeconds]));
		UpdateDynamic3DTextLabelText(LogData[id][logLabel], 0xF1C40FFF, label);
	}else if(LogData[id][logSeconds] <= 1) {
	    KillTimer(LogData[id][logTimer]);
	    DestroyDynamicObject(LogData[id][logObjID]);
		DestroyDynamic3DTextLabel(LogData[id][logLabel]);
		
	    LogData[id][logTimer] = -1;
        LogData[id][logObjID] = -1;
        LogData[id][logLabel] = Text3D: -1;

		Iter_Remove(Logs, id);
	}
	
	return 1;
}