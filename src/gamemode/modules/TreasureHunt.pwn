#define MAX_SPIKESTRIPS 200

enum sInfo
{
	sCreated,
    Float:sX,
    Float:sY,
    Float:sZ,
    sObject,
};
new SpikeInfo[MAX_SPIKESTRIPS][sInfo];
new PlayerHitSpike[MAX_PLAYERS]; 

stock GetXYBehindPoint(Float:x, Float:y, &Float:x2, &Float:y2, Float:angle, Float:distance)
{
    x2 = x - (distance * floatsin(-angle, degrees));
	y2 = y - (distance * floatcos(-angle, degrees));
	return 1;
}

stock encode_tires(tires1, tires2, tires3, tires4)
{
	return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);
}

stock decode_tires(tires, &tire0, &tire1, &tire2, &tire3)
{
	tire0 = tires & 1;
	tire1 = (tires >> 1) & 1;
	tire2 = (tires >> 2) & 1;
	tire3 = (tires >> 3) & 1;
}

stock Createspike(Float:x, Float:y, Float:z, Float:Angle)
{
    for(new i = 0; i < sizeof(SpikeInfo); i++)
  	{
  	    if(SpikeInfo[i][sCreated] == 0)
  	    {
            SpikeInfo[i][sCreated] = 1;
            SpikeInfo[i][sX] = x;
            SpikeInfo[i][sY] = y;
            SpikeInfo[i][sZ] = z - 0.7;
            SpikeInfo[i][sObject] = CreateDynamicObject(2899, x, y, z - 0.88, 0, 0, Angle - 90);
			
	        return 1;
  	    }
  	}
  	return 0;
}

stock DeleteAllspike()
{
    for(new i = 0; i < sizeof(SpikeInfo); i++)
  	{
  	    if(SpikeInfo[i][sCreated] == 1)
  	    {
  	        SpikeInfo[i][sCreated] = 0;
            SpikeInfo[i][sX] = 0.0;
            SpikeInfo[i][sY] = 0.0;
            SpikeInfo[i][sZ] = 0.0;
            DestroyDynamicObject(SpikeInfo[i][sObject]);
  	    }
	}
    return 1;
}

stock DeleteClosestspike(playerid)
{
	new done;
    for(new i = 0; i < sizeof(SpikeInfo); i++)
  	{
  	    if(IsPlayerInRangeOfPoint(playerid, 2.0, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ]))
        {
  	        if(SpikeInfo[i][sCreated] == 1)
            {
                SpikeInfo[i][sCreated] = 0;
                SpikeInfo[i][sX] = 0.0;
                SpikeInfo[i][sY] = 0.0;
                SpikeInfo[i][sZ] = 0.0;
                DestroyDynamicObject(SpikeInfo[i][sObject]);
 				done = 1;
				SendClientMessage(playerid, COLOR_WHITE, "You have deleted this road spike!");
  	        }
  	    }
  	}
  	if(!done) SendClientMessage(playerid, COLOR_GREY, "You are not near a spike strip.");
    return 1;
}

stock destroyThisObject(objid) 
{
	DestroyDynamicObject(objid);
}

stock CheckPlayerInSpike(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new foundSpike = 0;
		for(new i = 0; i < sizeof(SpikeInfo); i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ]))
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					if(SpikeInfo[i][sCreated] == 1)
					{
						foundSpike = 1;
						
						if(PlayerHitSpike[playerid] == 0)
						{
							new panels, doors, lights, tires;
							new carid = GetPlayerVehicleID(playerid);
							GetVehicleDamageStatus(carid, panels, doors, lights, tires);
							
							tires = encode_tires(1, 1, 1, 1);
							
							UpdateVehicleDamageStatus(carid, panels, doors, lights, tires);
							
							SendClientMessage(playerid, COLOR_GREY, "Your tires have been popped by a spike strip!");
							PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
							
							PlayerHitSpike[playerid] = 1;
						}
						break;
					}
				}
			}
	  	}
	  	
	  	// Reset the flag when player is no longer near any spike
	  	if(!foundSpike)
	  	{
	  		PlayerHitSpike[playerid] = 0;
	  	}
	}
}

CMD:spike(playerid, params[])
{
	if(!IsLawEnforcement(playerid)  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		return SendClientMessage(playerid, COLOR_GREY, "You are not driving a vehicle.");
		
	new Float:X, Float:Y, Float:Z, Float:A, Float:Ang;

    GetPlayerPos(playerid, X, Y, Z);
    GetPlayerFacingAngle(playerid, A);

    new currentveh = GetPlayerVehicleID(playerid);
	new Float:vehx, Float:vehy, Float:vehz, Float:angle, Float:x2, Float:y2;

	GetVehiclePos(currentveh, vehx, vehy, vehz);
	GetVehicleDistanceFromPoint(currentveh, vehx, vehy, vehz);
	GetVehicleZAngle(currentveh, angle);
	GetVehicleZAngle(currentveh, Ang);
	GetXYBehindPoint(vehx, vehy, x2, y2, angle, 5);

    Createspike(x2, y2, vehz + 0.3, Ang);

    SendClientMessage(playerid, COLOR_WHITE, "You have dropped a spike strip!");
	return 1;
}

CMD:destroyspike(playerid, params[])
{
	if(!IsLawEnforcement(playerid)  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
		
	DeleteClosestspike(playerid);
	return 1;
}

CMD:destroyallspike(playerid, params[])
{
	if(!IsLawEnforcement(playerid)  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
		
	DeleteAllspike();
	SendClientMessage(playerid, COLOR_WHITE, "You have destroyed all road spikes!");
	return 1;
}