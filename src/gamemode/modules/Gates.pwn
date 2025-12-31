#include <YSI\y_hooks>

#define MAX_GATES 120
// TODO:
//   - Replace useless message Dyuze, 
//   - Add edit position call back
//   - add to /nearest
//   - change PlayerData[playerid][pEditGate] and PlayerData[playerid][pEditType] to the correct one
//   - search for gateData enum values in all projet and move them here (gateTime, ...)

enum gateData {
	gateID,
	gateExists,
	gateOpened,
	gateModel,
	Float:gateSpeed,
	Float:gateRadius,
	gateTime,
	Float:gatePos[6],
	gateInterior,
	gateWorld,
	Float:gateMove[6],
	gateLinkID,
	gateFaction,
	gatePass[32],
	gateTimer,
	gateObject
};

static GateData[MAX_GATES][gateData];

hook OnGameModeInit(timestamp)
{
	for(new i=0;i<MAX_GATES;i++)
	{
		GateData[i][gateExists] = 0;
	}
	return 1;
}

GetGateByObjectID(objectid)
{
	for(new i=0;i<MAX_GATES;i++)
	{
		if(GateData[i][gateExists] && GateData[i][gateObject] == objectid)
		{
			return i;
		}
	}
	return -1;
}

hook OnLoadDatabase(timestamp)
{
    mysql_tquery(connectionID, "SELECT * FROM `gates`", "Gate_Load", "");

	return 1;
}

stock GetNearbyGate(playerid)
{
    for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && IsPlayerInRangeOfPoint(playerid, GateData[i][gateRadius], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2]))
	{
		if (GetPlayerInterior(playerid) == GateData[i][gateInterior] && GetPlayerVirtualWorld(playerid) == GateData[i][gateWorld])
			return i;
	}
	return -1;
}


stock GetGateByID(sqlid)
{
	for (new i = 0; i != MAX_GATES; i ++)
	{
		if (GateData[i][gateExists] && GateData[i][gateID] == sqlid)
		{
	    	return i;
		}
	}
	return -1;
}

stock Gate_Operate(gateid)
{
	if (gateid != -1 && GateData[gateid][gateExists])
	{
	    new id = -1;

		if (!GateData[gateid][gateOpened])
		{
		    GateData[gateid][gateOpened] = true;
		    MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gateMove][0], GateData[gateid][gateMove][1], 
				GateData[gateid][gateMove][2], GateData[gateid][gateSpeed], GateData[gateid][gateMove][3], 
				GateData[gateid][gateMove][4], GateData[gateid][gateMove][5]);

            if (GateData[gateid][gateTime] > 0)
			{
				GateData[gateid][gateTimer] = SetTimerEx("CloseGate", GateData[gateid][gateTime], false, "ddfffffff", 
					gateid, GateData[gateid][gateLinkID], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], 
					GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3], 
					GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);
			}
			
			if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
			{
			    GateData[id][gateOpened] = true;
			    MoveDynamicObject(GateData[id][gateObject], GateData[id][gateMove][0], GateData[id][gateMove][1], 
					GateData[id][gateMove][2], GateData[id][gateSpeed], GateData[id][gateMove][3], 
					GateData[id][gateMove][4], GateData[id][gateMove][5]);
			}
		}
		else if (GateData[gateid][gateOpened])
		{
		    GateData[gateid][gateOpened] = false;
		    MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], 
				GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3], 
				GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);

            if (GateData[gateid][gateTime] > 0) {
				KillTimer(GateData[gateid][gateTimer]);
		    }
			if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
			{
			    GateData[id][gateOpened] = false;
			    MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], 
					GateData[id][gatePos][2], GateData[id][gateSpeed], GateData[id][gatePos][3], 
					GateData[id][gatePos][4], GateData[id][gatePos][5]);
			}
		}
	}
	return 1;
}

stock Gate_Create(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_GATES; i ++) if (!GateData[i][gateExists])
		{
		    GateData[i][gateExists] = true;
			GateData[i][gateModel] = 980;
			GateData[i][gateSpeed] = 3.0;
			GateData[i][gateRadius] = 5.0;
			GateData[i][gateOpened] = 0;
			GateData[i][gateTime] = 0;

			GateData[i][gatePos][0] = x + (3.0 * floatsin(-angle, degrees));
			GateData[i][gatePos][1] = y + (3.0 * floatcos(-angle, degrees));
			GateData[i][gatePos][2] = z;
			GateData[i][gatePos][3] = 0.0;
			GateData[i][gatePos][4] = 0.0;
			GateData[i][gatePos][5] = angle;

			GateData[i][gateMove][0] = x + (3.0 * floatsin(-angle, degrees));
			GateData[i][gateMove][1] = y + (3.0 * floatcos(-angle, degrees));
			GateData[i][gateMove][2] = z - 10.0;
			GateData[i][gateMove][3] = -1000.0;
			GateData[i][gateMove][4] = -1000.0;
			GateData[i][gateMove][5] = -1000.0;

            GateData[i][gateInterior] = GetPlayerInterior(playerid);
            GateData[i][gateWorld] = GetPlayerVirtualWorld(playerid);

            GateData[i][gateLinkID] = -1;
            GateData[i][gateFaction] = -1;

            GateData[i][gatePass][0] = '\0';
            GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);

			mysql_tquery(connectionID, "INSERT INTO `gates` (`gateModel`) VALUES(980)", "OnGateCreated", "d", i);
			return i;
		}
	}
	return -1;
}

stock Gate_Delete(gateid)
{
	if (gateid != -1 && GateData[gateid][gateExists])
	{
		new
		    query[64];

		format(query, sizeof(query), "DELETE FROM `gates` WHERE `gateID` = '%d'", GateData[gateid][gateID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(GateData[gateid][gateObject]))
		    DestroyDynamicObject(GateData[gateid][gateObject]);

		for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && GateData[i][gateLinkID] == GateData[gateid][gateID]) {
		    GateData[i][gateLinkID] = -1;
		    Gate_Save(i);
		}
		if (GateData[gateid][gateOpened] && GateData[gateid][gateTime] > 0) {
		    KillTimer(GateData[gateid][gateTimer]);
		}
	    GateData[gateid][gateExists] = false;
	    GateData[gateid][gateID] = 0;
	    GateData[gateid][gateOpened] = 0;
	}
	return 1;
}

stock Gate_Save(gateid)
{
	new
	    query[768];

	format(query, sizeof(query), "UPDATE `gates` SET `gateModel` = '%d', `gateSpeed` = '%.4f', `gateRadius` = '%.4f', `gateTime` = '%d', `gateX` = '%.4f', `gateY` = '%.4f', `gateZ` = '%.4f', `gateRX` = '%.4f', `gateRY` = '%.4f', `gateRZ` = '%.4f', `gateInterior` = '%d', `gateWorld` = '%d', `gateMoveX` = '%.4f', `gateMoveY` = '%.4f', `gateMoveZ` = '%.4f', `gateMoveRX` = '%.4f', `gateMoveRY` = '%.4f', `gateMoveRZ` = '%.4f', `gateLinkID` = '%d', `gateFaction` = '%d', `gatePass` = '%s', `gateFaction` = '%s' WHERE `gateID` = '%d'",
	    GateData[gateid][gateModel],
	    GateData[gateid][gateSpeed],
	    GateData[gateid][gateRadius],
	    GateData[gateid][gateTime],
	    GateData[gateid][gatePos][0],
	    GateData[gateid][gatePos][1],
	    GateData[gateid][gatePos][2],
	    GateData[gateid][gatePos][3],
	    GateData[gateid][gatePos][4],
	    GateData[gateid][gatePos][5],
	    GateData[gateid][gateInterior],
	    GateData[gateid][gateWorld],
	    GateData[gateid][gateMove][0],
	    GateData[gateid][gateMove][1],
	    GateData[gateid][gateMove][2],
	    GateData[gateid][gateMove][3],
	    GateData[gateid][gateMove][4],
	    GateData[gateid][gateMove][5],
	    GateData[gateid][gateLinkID],
	    GateData[gateid][gateFaction],
	    MySqlEscape(GateData[gateid][gatePass]),
	    GateData[gateid][gateID]
	);
	return mysql_tquery(connectionID, query);
}


publish OnGateCreated(gateid)
{
	if (gateid == -1 || !GateData[gateid][gateExists])
	    return 0;

	GateData[gateid][gateID] = cache_insert_id(connectionID);
	Gate_Save(gateid);

	return 1;
}

publish CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new id = -1;

	if (GateData[gateid][gateExists] && GateData[gateid][gateOpened])
 	{
	 	MoveDynamicObject(GateData[gateid][gateObject], fX, fY, fZ, speed, fRotX, fRotY, fRotZ);

	 	if ((id = GetGateByID(linkid)) != -1)
            MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], speed, GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);

		GateData[id][gateOpened] = 0;
		return 1;
	}
	return 0;
}

publish Gate_Load()
{
    new rows, fields;

	cache_get_data(rows, fields, connectionID);

	for (new i = 0; i < rows; i ++) if (i < MAX_GATES)
	{
	    GateData[i][gateExists] = true;
	    GateData[i][gateOpened] = false;

	    GateData[i][gateID] = cache_get_field_content_int(i, "gateID");
	    GateData[i][gateModel] = cache_get_field_content_int(i, "gateModel");
	    GateData[i][gateSpeed] = cache_get_field_content_float(i, "gateSpeed");
	    GateData[i][gateRadius] = cache_get_field_content_float(i, "gateRadius");
	    GateData[i][gateTime] = cache_get_field_content_int(i, "gateTime");
	    GateData[i][gateInterior] = cache_get_field_content_int(i, "gateInterior");
	    GateData[i][gateWorld] = cache_get_field_content_int(i, "gateWorld");

	    GateData[i][gatePos][0] = cache_get_field_content_float(i, "gateX");
	    GateData[i][gatePos][1] = cache_get_field_content_float(i, "gateY");
	    GateData[i][gatePos][2] = cache_get_field_content_float(i, "gateZ");
	    GateData[i][gatePos][3] = cache_get_field_content_float(i, "gateRX");
	    GateData[i][gatePos][4] = cache_get_field_content_float(i, "gateRY");
	    GateData[i][gatePos][5] = cache_get_field_content_float(i, "gateRZ");

        GateData[i][gateMove][0] = cache_get_field_content_float(i, "gateMoveX");
	    GateData[i][gateMove][1] = cache_get_field_content_float(i, "gateMoveY");
	    GateData[i][gateMove][2] = cache_get_field_content_float(i, "gateMoveZ");
	    GateData[i][gateMove][3] = cache_get_field_content_float(i, "gateMoveRX");
	    GateData[i][gateMove][4] = cache_get_field_content_float(i, "gateMoveRY");
	    GateData[i][gateMove][5] = cache_get_field_content_float(i, "gateMoveRZ");

        GateData[i][gateLinkID] = cache_get_field_content_int(i, "gateLinkID");
	    GateData[i][gateFaction] = cache_get_field_content_int(i, "gateFaction");

	    cache_get_field_content(i, "gatePass", GateData[i][gatePass], connectionID, 32);

	    GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
	}
	return 1;
}


Dialog:GatePass(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new id = GetNearbyGate(playerid);

        if (id == -1)
		{
            return 0;
		}

        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
        }

        if (strcmp(inputtext, GateData[id][gatePass]) != 0)
        {
			return Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Error: Incorrect password specified.\n\nPlease enter the password for this gate below:", "Submit", "Cancel");
        }

        Gate_Operate(id);
    }
	return 1;
}


CMD:creategate(playerid, params[])
{
	if(!IsAdmin(playerid, 5))
	{
		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	new id = Gate_Create(playerid);

	if (id == -1)
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "The server has reached the limit for gates.");
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully created gate ID: %d.", id);
	return 1;
}

stock ToggleGate(playerid, id)
{
    if (id != -1)
    {
        if (strlen(GateData[id][gatePass]))
        {
            Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
        }
        else
        {
            if (GateData[id][gateFaction] != -1 && PlayerData[playerid][pFaction] != GateData[id][gateFaction])
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "You can't open this gate/door.");
            }

            Gate_Operate(id);

            switch (GateData[id][gateOpened])
            {
                case 0:
                {
                    ShowActionBubble(playerid, "* %s uses their card to close the gate/door.", GetRPName(playerid));
                }
                case 1:
                {
                    ShowActionBubble(playerid, "* %s uses their card to open the gate/door.", GetRPName(playerid));
                }
            }
        }
    }
    return 1;
}


CMD:gotogate(playerid, params[])
{
	new gateid;

	if(!IsAdmin(playerid, 5))
	{
		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if(!IsAdminOnDuty(playerid, 5))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", gateid))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /gotogate [gateid]");
	}
	if(!(0 <= gateid < MAX_GATES) || !GateData[gateid][gateExists])
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid gate.");
	}
	
	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, 
		GateData[gateid][gatePos][0] - (2.5 * floatsin(-GateData[gateid][gatePos][3], degrees)), 
		GateData[gateid][gatePos][1] - (2.5 * floatcos(-GateData[gateid][gatePos][3], degrees)), 
		GateData[gateid][gatePos][2]);

	SetPlayerInterior(playerid, GateData[gateid][gateInterior]);
	SetPlayerVirtualWorld(playerid, GateData[gateid][gateWorld]);
	SetCameraBehindPlayer(playerid);
	return 1;
}


CMD:destroygate(playerid, params[])
{
	new id = 0;

	if(!IsAdmin(playerid, 5))
	{
		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if (sscanf(params, "d", id))
    {
	    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /destroygate [gate id]");
    }

	if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
    {
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");
    }

	Gate_Delete(id);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully destroyed gate ID: %d.", id);
	return 1;
}

CMD:editgate(playerid, params[])
{
	new id, type[24], string[128];

	if(!IsAdmin(playerid, 5))
	{
		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [name]");
	    SendClientMessage(playerid, COLOR_ORANGE, "Names:{FFFFFF} location, speed, radius, time, model, pos, move, pass, linkid, faction, gang");
		return 1;
	}

	if((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
    {
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");
    }

    if (!strcmp(type, "location", true))
	{
		new Float:x, Float:y, Float:z, Float:angle;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);

		GateData[id][gatePos][0] = x;
		GateData[id][gatePos][1] = y;
		GateData[id][gatePos][2] = z;
		GateData[id][gatePos][3] = 0.0;
		GateData[id][gatePos][4] = 0.0;
		GateData[id][gatePos][5] = angle;

		SetDynamicObjectPos(GateData[id][gateObject], x, y, z);
		SetDynamicObjectRot(GateData[id][gateObject], 0.0, 0.0, angle);

		GateData[id][gateOpened] = false;

		Gate_Save(id);
		SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the position of gate ID: %d.", GetRPName(playerid), id);
		return 1;
	}
	else if (!strcmp(type, "speed", true))
	{
	    new Float:speed;

		if (sscanf(string, "f", speed))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [speed] [move speed]");
		}

		if (speed < 0.0 || speed > 20.0)
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "The specified speed can't be below 0 or above 20.");
		}

        GateData[id][gateSpeed] = speed;

		Gate_Save(id);
		SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the speed of gate ID: %d to %.2f.", GetRPName(playerid), id, speed);
		return 1;
	}
	else if (!strcmp(type, "radius", true))
	{
	    new Float:radius;

		if (sscanf(string, "f", radius))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [radius] [open radius]");
		}

		if (radius < 0.0 || radius > 20.0)
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "The specified radius can't be below 0 or above 20.");
		}

        GateData[id][gateRadius] = radius;

		Gate_Save(id);
		SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the radius of gate ID: %d to %.2f.", GetRPName(playerid), id, radius);
		return 1;
	}
	else if (!strcmp(type, "time", true))
	{
	    new time;

		if (sscanf(string, "d", time))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [time] [close time] (0 to disable)");
		}

		if (time < 0 || time > 60000)
		{
		    return SendClientMessageEx(playerid, COLOR_SYNTAX, "The specified time can't be 0 or above 60,000 ms.");
		}

        GateData[id][gateTime] = time;

		Gate_Save(id);
		SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the close time of gate ID: %d to %d.", GetRPName(playerid), id, time);
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    new model;

		if (sscanf(string, "d", model))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [model] [gate model]");
		}

		//if (!IsValidObjectModel(model))
		//{
		//    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid object model.");
		//}

        GateData[id][gateModel] = model;

		DestroyDynamicObject(GateData[id][gateObject]);
		GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], 
			GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], 
			GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

		Gate_Save(id);
		SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the model of gate ID: %d to %d.", GetRPName(playerid), id, model);
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
		PlayerData[playerid][pEditType] = EDIT_GATE_OBJECT;
		PlayerData[playerid][pEditObject] = GateData[id][gateObject];
	   	EditDynamicObject(playerid, GateData[id][gateObject]);

		SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the position of gate ID: %d.", id);
		return 1;
	}
	else if (!strcmp(type, "move", true))
	{
		PlayerData[playerid][pEditType] = EDIT_GATE_MOVE;
		PlayerData[playerid][pEditObject] = GateData[id][gateObject];
	   	EditDynamicObject(playerid, GateData[id][gateObject]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the moving position of gate ID: %d.", id);
		return 1;
	}
	else if (!strcmp(type, "linkid", true))
	{
	    new linkid = -1;

		if (sscanf(string, "d", linkid))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [linkid] [gate link] (-1 for none)");
		}

        if ((linkid < -1 || linkid >= MAX_GATES) || (linkid != -1 && !GateData[linkid][gateExists]))
		{
	    	return SendClientMessageEx(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");
		}

        GateData[id][gateLinkID] = (linkid == -1) ? (-1) : (GateData[linkid][gateID]);
		Gate_Save(id);

		if (id == -1)
		{
			SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to no gate.", GetRPName(playerid), id);
		}
		else
		{
		    SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to ID: %d.", GetRPName(playerid), id, linkid);
		}

		return 1;
	}
	else if (!strcmp(type, "faction", true))
	{
	    new factionid = 0;

		if (sscanf(string, "d", factionid))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [faction] [gate faction] (-1 for none)");
		}

		if(!(1 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
		{
			return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid faction.");
		}


        GateData[id][gateFaction] = factionid;
		Gate_Save(id);

		if (factionid == -1)
		{
			SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to no faction.", GetRPName(playerid), id);
		}
		else
		{
		    SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to \"%s\".", GetRPName(playerid), id, FactionInfo[factionid][fName]);
		}

		return 1;
	}
	else if (!strcmp(type, "pass", true))
	{
	    new pass[32];

		if (sscanf(string, "s[32]", pass))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [pass] [gate password] (Use 'none' to disable)");
		}
			
		if (!strcmp(pass, "none", true))
		{
			GateData[id][gatePass][0] = 0;
		}
		else 
		{
			format(GateData[id][gatePass], 32, pass);
		}

		Gate_Save(id);
		SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the password of gate ID: %d to %s.", GetRPName(playerid), id, pass);
		return 1;
	}
	return 1;
}
stock RedrawGate(gateid)
{
	DestroyDynamicObject(GateData[gateid][gateObject]);
	GateData[gateid][gateObject] =  CreateDynamicObject(GateData[gateid][gateModel], 
		GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2], 
		GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5],
		GateData[gateid][gateWorld], GateData[gateid][gateInterior]);
}

stock UpdateGateMovingPosition(gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	GateData[gateid][gateMove][0] = x;
	GateData[gateid][gateMove][1] = y;
	GateData[gateid][gateMove][2] = z;
	GateData[gateid][gateMove][3] = rx;
	GateData[gateid][gateMove][4] = ry;
	GateData[gateid][gateMove][5] = rz;
 	GateData[gateid][gateOpened] = false;
	
	RedrawGate(gateid);

	Gate_Save(gateid);
}

stock UpdateGatePosition(gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	GateData[gateid][gatePos][0] = x;
	GateData[gateid][gatePos][1] = y;
	GateData[gateid][gatePos][2] = z;
	GateData[gateid][gatePos][3] = rx;
	GateData[gateid][gatePos][4] = ry;
	GateData[gateid][gatePos][5] = rz;
 	GateData[gateid][gateOpened] = false;	 

	DestroyDynamicObject(GateData[gateid][gateObject]);
	GateData[gateid][gateObject] =  CreateDynamicObject(GateData[gateid][gateModel], 
		GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2], 
		GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5],
		GateData[gateid][gateWorld], GateData[gateid][gateInterior]);

	Gate_Save(gateid);
}


/*
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)

		else if (PlayerData[playerid][pEditGate] != -1 && GateData[PlayerData[playerid][pEditGate]][gateExists])
	    {
	        switch (PlayerData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = PlayerData[playerid][pEditGate];
					UpdateGatePosition(id, x,y,z,rx,ry,rz);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the position of gate ID: %d.", id);
				}
				case 2:
	            {
	                new id = PlayerData[playerid][pEditGate];
					UpdateGateMovingPosition(id, x,y,z,rx,ry,rz);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the moving position of gate ID: %d.", id);
				}
			}



 	if((gettime() - PlayerData[playerid][pLastPress]) >= 1)
	{
		if(newkeys & KEY_YES)
		{
			if(!EnterCheck(playerid)) ExitCheck(playerid);

			new id = GetNearbyGate(playerid);
			if (id != -1)
			{
				if (strlen(GateData[id][gatePass]))
				{
                    Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
				}
				else
				{
					if (GateData[id][gateFaction] != -1 && PlayerData[playerid][pFaction] != GetFactionByID(GateData[id][gateFaction]))
                    {
						return SendClientMessageEx(playerid, COLOR_SYNTAX, "You can't open this gate/door.");
                    }

					Gate_Operate(id);

					switch (GateData[id][gateOpened])
					{
						case 0:
                        {
							SendClientMessageEx(playerid, COLOR_SYNTAX, "You have closed the gate/door!");
                        }
						case 1:
                        {
							SendClientMessageEx(playerid, COLOR_SYNTAX, "You have opened the gate/door!");
                        }
					}
				}
			}
			PlayerData[playerid][pLastPress] = gettime(); // Prevents spamming. Sometimes keys get messed up and register twice.
		}
*/
