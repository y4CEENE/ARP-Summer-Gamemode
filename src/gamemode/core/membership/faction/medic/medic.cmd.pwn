
CMD:heal(playerid, params[])
{
	new targetid, price;

    if(GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "ud", targetid, price))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /heal [playerid] [price]");
	}
    if(price < 100 || price > 500)
    {
        SendClientMessage(playerid, COLOR_GREY, "Healing price can't below $100 or above $500.");
        return 1;
    }
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't heal yourself.");
	}
	if(PlayerData[targetid][pReceivingAid])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player already has first aid effects.");
	}
    if(GetPlayerHealthEx(targetid) >= 100)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player doesn't need first aid.");
    }

	PlayerData[targetid][pReceivingAid] = 1;
    GivePlayerCash(targetid, -price);
	GivePlayerCash(playerid, price);
    GivePlayerRankPoints(playerid, 100);

	ShowActionBubble(playerid, "* %s administers first aid to %s.", GetRPName(playerid), GetRPName(targetid));

	SendClientMessageEx(targetid, COLOR_AQUA, "You have received first aid from %s for $%d. Your health will now regenerate until full.", GetRPName(playerid), price);
	SendClientMessageEx(playerid, COLOR_AQUA, "You have administered first aid to %s for $%d.", GetRPName(targetid), price);
	return 1;
}

CMD:stretcher(playerid, params[])
{
    new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stretcher [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 15.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(!PlayerData[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not injured.");
	}
	if(IsPlayerInAnyVehicle(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already in a vehicle.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && (VehicleInfo[vehicleid][vFaction] > -1 && FactionInfo[VehicleInfo[vehicleid][vFaction]][fType] != FACTION_MEDIC))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be driving an ambulance.");
	}

	for(new seat = 2; seat < GetVehicleSeatCount(vehicleid); seat ++)
	{
	    if(!IsSeatOccupied(vehicleid, seat))
	    {
	        PlayerData[targetid][pVehicleCount] = 0;

            ClearAnimations(targetid);
            TogglePlayerControllableEx(targetid, false);
            PutPlayerInVehicle(targetid, vehicleid, seat);
            SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* You were loaded by paramedic %s.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You loaded patient %s.", GetRPName(targetid));
			ShowActionBubble(playerid, "* %s places %s on a stretcher in the Ambulance.", GetRPName(playerid), GetRPName(targetid));
			return 1;
		}
	}
    
    if(!IsSeatOccupied(vehicleid, 1))
    {
        PlayerData[targetid][pVehicleCount] = 0;

        ClearAnimations(targetid);
        TogglePlayerControllableEx(targetid, false);
        PutPlayerInVehicle(targetid, vehicleid, 1);
        SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* You were loaded by paramedic %s.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You loaded patient %s.", GetRPName(targetid));
        ShowActionBubble(playerid, "* %s places %s on a stretcher in the Ambulance.", GetRPName(playerid), GetRPName(targetid));
        return 1;
    }

	SendClientMessage(playerid, COLOR_GREY, "There are no unoccupied seats left. Find another vehicle.");
	return 1;
}

CMD:deliverpatient(playerid, params[])
{
	new targetid, amount;
	
	if(GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deliverpatient [playerid]");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 2007.6256, -1410.2455, 16.9922) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1140.5344, -1326.5345, 13.6328) && !IsPlayerInRangeOfPoint(playerid, 5.0, 2070.4307, -1422.8580, 48.331) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1161.8879, -1358.6638, 31.3811)
	&& !IsPlayerInRangeOfPoint(playerid, 5.0, 1510.7773, -2151.7322, 13.7483) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1480.4819, -2166.9712, 35.2578) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1539.1060, -2167.2058, 35.2578)
    && !IsPlayerInRangeOfPoint(playerid, 5.0, -2684.1162, 626.1478, 14.0291) && !IsPlayerInRangeOfPoint(playerid, 5.0, -2664.0845,638.4924,66.0938))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any delivery points at the hospital.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 7.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(!PlayerData[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not injured.");
	}
	switch(PlayerData[playerid][pFactionRank])
	{
		case 0:{ amount = 1000;}
		case 1:{ amount = 1500;}
		case 2:{ amount = 2000;}
		default:{ amount = 3000;}
	}
	if(PlayerData[playerid][pLaborUpgrade] > 0)
	{
		amount += percent(amount, PlayerData[playerid][pLaborUpgrade]);
	}

    PlayerData[targetid][pInjured] = 0;
	PlayerData[targetid][pDelivered] = 0;
	PlayerData[playerid][pTotalPatients]++;

	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2007.6256, -1410.2455, 16.9922) || IsPlayerInRangeOfPoint(playerid, 5.0, 2070.4307,-1422.8580,48.331))
	{
	    SetPlayerVirtualWorld(targetid, HOSPITAL_COUNTY);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1147.3577, -1345.3729, 13.6328) || IsPlayerInRangeOfPoint(playerid, 5.0, 1161.1458,-1364.4767,26.6485))
	{
		SetPlayerVirtualWorld(targetid, HOSPITAL_ALLSAINTS);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, -2684.1162, 626.1478, 14.0291) || IsPlayerInRangeOfPoint(playerid, 5.0, -2664.0845,638.4924,66.0938))
	{
		SetPlayerVirtualWorld(targetid, HOSPITAL_SAN_FIERRO);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1510.7773,-2151.7322,13.7483) || IsPlayerInRangeOfPoint(playerid, 5.0, 1480.4819,-2166.9712,35.2578) || IsPlayerInRangeOfPoint(playerid, 5.0,  1539.1060,-2167.2058,35.2578))
	{
	    SetPlayerVirtualWorld(targetid, HOSPITAL_FMDHQ);
	}
    else
    {
        SetPlayerVirtualWorld(targetid, HOSPITAL_ALLSAINTS);
    }

	if(GetPlayerFaction(targetid) == FACTION_POLICE || GetPlayerFaction(targetid) == FACTION_MEDIC)
	{
        SendClientMessage(targetid, COLOR_DOCTOR, "You have not been billed for your stay. You also keep all of your weapons!");
    }
	else
	{
		SendClientMessage(targetid, COLOR_DOCTOR, "You have been billed $250 for your stay. You also keep all of your weapons!");
	}

    SetFreezePos(targetid, -2297.6084,111.1512,-5.3336);//hospitalspawn
	SetPlayerFacingAngle(targetid, 89.7591);
	SetPlayerInterior(targetid, 1);
	SetCameraBehindPlayer(targetid);
	ClearAnimations(targetid, 1);

	if(!(GetPlayerFaction(targetid) == FACTION_POLICE || GetPlayerFaction(targetid) == FACTION_MEDIC) || PlayerData[playerid][pHours] > 8)
	{
		GivePlayerCash(targetid, -250);
		GameTextForPlayer(targetid, "~w~Discharged~n~~r~-$250", 5000, 1);
	}

	SetPlayerDrunkLevel(targetid, 0);

	SetPlayerHealth(targetid, PlayerData[targetid][pSpawnHealth]);
	SetScriptArmour(targetid, PlayerData[targetid][pSpawnArmor]);
    PlayerData[targetid][pAcceptedEMS] = INVALID_PLAYER_ID;
	GivePlayerCash(playerid, amount);
    GivePlayerRankPoints(playerid, 500);
	SendClientMessageEx(playerid, COLOR_AQUA, "You have delivered %s to the hospital and earned {00AA00}$%i{33CCFF}.", GetRPName(targetid), amount);
	return 1;
}

CMD:listpt(playerid, params[])
{
	if(GetPlayerFaction(playerid) != FACTION_MEDIC)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
	    return 1;
	}
	SendClientMessage(playerid, COLOR_GREEN, "Injured - (/injuries):");
	new Float:pos[3];
	GetPlayerPosEx(playerid, pos[0], pos[1], pos[2]);
	
	foreach(new i : Player)
	{
		if(PlayerData[i][pInjured])
		{
		    new accepted[24];
		    if(IsPlayerConnected(PlayerData[i][pAcceptedEMS]))
		    {
				accepted = GetRPName(PlayerData[i][pAcceptedEMS]);
		    }
		    else
		    {
		        accepted = "None";
		    }
			new Float: distance = GetPlayerDistanceFromPoint(i, pos[0], pos[1], pos[2]);
		    SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Location: %s - Medic: %s - Distance: %.2fm", GetRPName(i), GetPlayerZoneName(i), accepted, distance);
		}
	}
	SendClientMessage(playerid, COLOR_AQUA, "Use /getpt [playerid] to track them!");
	return 1;
}
CMD:getpt(playerid, params[])
{
	if(GetPlayerFaction(playerid) == FACTION_MEDIC)
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /getpt [playerid]");
		}
		if(IsPlayerConnected(targetid))
		{
		    if(targetid == playerid)
		    {
		        SendClientMessage(playerid, COLOR_AQUA, "You can't accept your own Emergency Dispatch call!");
				return 1;
		    }
		    if(!PlayerData[targetid][pInjured])
		    {
		        SendClientMessage(playerid, COLOR_GREY, "That person is not injured!");
		        return 1;
		    }
			if(!IsPlayerConnected(PlayerData[targetid][pAcceptedEMS]))
			{
				if(PlayerData[targetid][pJailTime] > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on jailed players.");
				SendFactionMessage(PlayerData[playerid][pFaction], COLOR_DOCTOR, "EMS Driver %s has accepted the Emergency Dispatch call for %s.", GetRPName(playerid), GetRPName(targetid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted EMS Call from %s, you will see the marker until you have reached it.", GetRPName(targetid));
				SendClientMessageEx(targetid, COLOR_AQUA, "* EMS Driver %s has accepted your EMS Call; please be patient as they are on the way!", GetPlayerNameEx(playerid));
				PlayerData[targetid][pAcceptedEMS] = playerid;
				GameTextForPlayer(playerid, "~w~EMS Caller~n~~r~Go to the red marker.", 5000, 1);
                PlayerData[playerid][pCP] = CHECKPOINT_MISC;
                new Float:ppos[3];
				GetPlayerPosEx(targetid, ppos[0], ppos[1], ppos[2]);
	    		SetPlayerCheckpoint(playerid, ppos[0],ppos[1],ppos[2], 3.0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "Someone has already accepted that call!");
			}
		}
	}
	return 1;
}

CMD:loadpt(playerid, params[])
{
	return callcmd::stretcher(playerid, params);
}
CMD:deliverpt(playerid, params[])
{
	return callcmd::deliverpatient(playerid, params);
}
CMD:movept(playerid, params[])
{
	return callcmd::drag(playerid, params);
}
CMD:injuries(playerid, params[])
{
	new targetid;

    if(GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /injuries [playerid]");
	}
    if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT weaponid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerListInjuries", "ii", playerid, targetid);
	return 1;
}

CMD:randomfire(playerid, params[])
{
    if(!PlayerData[playerid][pFactionMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(IsFireActive())
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a fire active already. /killfire to kill it!");
	}

	new
	    Float:x,
	    Float:y,
	    Float:z;

	RandomFire(0);

	GetDynamicObjectPos(gFireObjects[0], x, y, z);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has started a random fire in %s.", GetRPName(playerid), GetZoneName(x, y, z));
	return 1;
}

CMD:killfire(playerid, params[])
{
    if(!PlayerData[playerid][pFactionMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsFireActive())
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is currently no fire active.");
	}

	for(new i = 0; i < MAX_FIRES; i ++)
	{
	    DestroyDynamicObject(gFireObjects[i]);
	    gFireObjects[i] = INVALID_OBJECT_ID;
	    gFireHealth[i] = 0.0;
	}

	gFires = 0;
	SendClientMessage(playerid, COLOR_GREY, "Active fire killed.");
	return 1;
}

CMD:spawnfire(playerid, params[])
{
	new Float:px, Float:py, Float:pz;

    if(!PlayerData[playerid][pFactionMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't create fires indoors.");
	}

	for(new x = 0; x < MAX_FIRES; x ++)
	{
	    if(gFireObjects[x] == INVALID_OBJECT_ID)
	    {
	        GetPlayerPos(playerid, px, py, pz);

	        if(!IsFireActive())
	        {
	            foreach(new i : Player)
	            {
	                if(GetPlayerFaction(i) == FACTION_MEDIC)
	                {
	            		PlayerData[i][pCP] = CHECKPOINT_MISC;
               			SetPlayerCheckpoint(i, px, py, pz, 3.0);
		   				SendClientMessageEx(i, COLOR_DOCTOR, "* All units, a fire has been reported in %s. Please head to the beacon on your map. *", GetZoneName(px, py, pz));
					}
	            }
	        }

	        gFireObjects[x] = CreateDynamicObject(18691, px, py, pz - 2.4, 0.0, 0.0, 0.0, .streamdistance = 50.0);
	        gFireHealth[x] = 50.0;
			gFires++;

			return SendClientMessage(playerid, COLOR_GREY, "Fire created!");
		}
	}

	SendClientMessageEx(playerid, COLOR_GREY, "You can't create anymore fires. The limit is %i fires.", MAX_FIRES);
	return 1;
}

