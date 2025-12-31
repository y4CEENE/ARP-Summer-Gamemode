#include <YSI\y_hooks>

enum ptEnum
{
	pExists,
	pName[32],
	pCapturedBy[MAX_PLAYER_NAME],
	pCapturedGang,
	pType,
	pProfits,
	pTime,
	Float:pPointX,
	Float:pPointY,
	Float:pPointZ,
	Float:pMinX,
	Float:pMinY,
	Float:pMaxX,
	Float:pMaxY,
	pGangZone,
	pArea,
	pPointInterior,
	pPointWorld,
	pCaptureTime,
	pCapturer,
	Text3D:pText,
	pPickup
};

static PointInfo[MAX_POINTS][ptEnum];

/*ShowFindPointDlg(playerid)
{
    new string[34 * MAX_POINTS];
    for(new x = 0; x < MAX_POINTS; x++)
    {
        if(PointInfo[x][pExists]) 
        {
            strcat(string, PointInfo[x][pName]);
            strcat(string, "\n");
        }
    }

    if(strlen(string) > 2)
    {
        Dialog_Show(playerid, DIALOG_LOCATEPOINTS, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
    }
    else 
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "GPS - Signal Lost", "Unable to locate any new locations.", "Cancel", "");
    }
    return 1;
}*/

GetNearbyPoint(playerid, Float:radius = 3.0)
{
    for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && IsPlayerInRangeOfPoint(playerid, radius, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]) && GetPlayerInterior(playerid) == PointInfo[i][pPointInterior] && GetPlayerVirtualWorld(playerid) == PointInfo[i][pPointWorld])
		{
		    return i;
		}
	}

	return -1;
}

GangCapturingPoints(gang)
{
	new capCount = 0;
	for(new x = 0; x < MAX_POINTS; x++)
	{
		if(PointInfo[x][pExists] && PointInfo[x][pCapturer] != INVALID_PLAYER_ID && PointInfo[x][pTime] == 0)
		{
  			if(PlayerData[PointInfo[x][pCapturer]][pGang] == gang)
  			{
          		capCount++;
  			}
		}
	}
	return capCount;
}
ReloadPoint(pointid)
{
    if (PointInfo[pointid][pExists])
    {
        new string[128], name[32];

        DestroyDynamic3DTextLabel(PointInfo[pointid][pText]);
        DestroyDynamicPickup(PointInfo[pointid][pPickup]);

        if (PointInfo[pointid][pCapturedGang] >= 0)
        {
            format(name, sizeof(name), "%s", GangInfo[PointInfo[pointid][pCapturedGang]][gName]);
        }
        else
        {
            format(name, sizeof(name), "None");
        }

        if (PointInfo[pointid][pTime] > 0)
            format(string, sizeof(string), "%s\nOwned by: %s\nAvailable in %i hours.", PointInfo[pointid][pName], name, PointInfo[pointid][pTime]);
        else
            format(string, sizeof(string), "%s\nOwned by: %s\nAvailable to capture!", PointInfo[pointid][pName], name);

        PointInfo[pointid][pText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], 10.0, .worldid = PointInfo[pointid][pPointWorld], .interiorid = PointInfo[pointid][pPointInterior]);
        PointInfo[pointid][pPickup] = CreateDynamicPickup(1239, 1, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], .worldid = PointInfo[pointid][pPointWorld], .interiorid = PointInfo[pointid][pPointInterior]);
    }
}

ClearGangPoints(gangid)
{
	for(new i = 0; i < MAX_POINTS; i ++)
	{
		if(PointInfo[i][pExists] && PointInfo[i][pCapturedGang] == gangid)
		{
		    PointInfo[i][pCapturedGang] = -1;
		}
	}
    return 1;
}

forward UpdatePoint();
public UpdatePoint()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
    
        if (!IsPlayerConnected(i)) continue;

        if(PlayerData[i][pCapturingPoint] >= 0)
        {
            PlayerData[i][pCaptureTime]--;

            if(PlayerData[i][pCaptureTime] <= 0)
            {
                new Float:x, Float:y, Float:z;

                GetPlayerPos(i, x, y, z);

                if(PointInfo[PlayerData[i][pCapturingPoint]][pTime] == 0 && PlayerData[i][pPointX] == x && PlayerData[i][pPointY] == y && PlayerData[i][pPointZ] == z)
                {
                    SendClientMessageToAllEx(COLOR_YELLOW, "Point wars: %s attempted to capture %s for %s. It will be theirs in 15 minutes.", GetPlayerNameEx(i), PointInfo[PlayerData[i][pCapturingPoint]][pName], GangInfo[PlayerData[i][pGang]][gName]);

                    PointInfo[PlayerData[i][pCapturingPoint]][pCaptureTime] = 15;
                    PointInfo[PlayerData[i][pCapturingPoint]][pCapturer] = i;
                }
                else
                {
                    SendClientMessage(i, COLOR_GREY, "You moved from your position and therefore failed to capture.");
                }

                PlayerData[i][pCapturingPoint] = -1;
                PlayerData[i][pCaptureTime] = 0;
            }
        }
        if(PlayerData[i][pGang] >= 0 && !PlayerData[i][pBandana])
        {
            new pointid;
            if((pointid = GetNearbyPoint(i, 30.0)) >= 0 && PointInfo[pointid][pTime] == 0 && PointInfo[pointid][pCapturer] != INVALID_PLAYER_ID)
            {
                new color;
                if(GangInfo[PlayerData[i][pGang]][gColor] == -1 || GangInfo[PlayerData[i][pGang]][gColor] == -256)
                {
                    color = 0xC8C8C8FF;
                }
                else
                {
                    color = GangInfo[PlayerData[i][pGang]][gColor];
                }
                PlayerData[i][pBandana] = 1;
                SendClientMessage(i, COLOR_WHITE, "Your bandana was enabled automatically as you entered a point in an active war.");
                new stringa[120];
                format(stringa, sizeof(stringa), "{%06x}%s", color >>> 8, GangInfo[PlayerData[i][pGang]][gName]);
                fRepfamtext[i] = CreateDynamic3DTextLabel(stringa, COLOR_WHITE, 0.0, 0.0, -0.3, 20.0, .attachedplayer = i, .testlos = 1);
            }
        }
    }
    
    return 1;
}

hook OnGameModeInit()
{
    SetTimer("UpdatePoint", 1000, true);
}

hook OnNewHour(timestamp, hour)
{
    for(new i = 0; i < MAX_POINTS; i ++)
	{
        if(PointInfo[i][pExists])
        {
            if(PointInfo[i][pTime] > 0)
            {
                PointInfo[i][pTime]--;
                ReloadPoint(i);
            }

            if(!PointInfo[i][pTime])
            {
                SendClientMessageToAllEx(COLOR_YELLOW, "Point wars: %s is now available to capture.", PointInfo[i][pName]);
                PointInfo[i][pCapturedGang] = -1;
            }

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET time = %i, capturedgang = %i WHERE id = %i", PointInfo[i][pTime], PointInfo[i][pCapturedGang], i);
            mysql_tquery(connectionID, queryBuffer);
        }
    }

    return 1;
}

hook OnNewMinute(timestamp)
{
    for(new i = 0; i < MAX_POINTS; i ++)
    {
        if(PointInfo[i][pExists] && PointInfo[i][pCapturer] != INVALID_PLAYER_ID && PointInfo[i][pCaptureTime] > 0)
        {
            if(PlayerData[PointInfo[i][pCapturer]][pGang] == -1)// || PlayerData[PointInfo[i][pCapturer]][pGangRank] < 5)
            {
                PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
                PointInfo[i][pCaptureTime] = 0;
            }
            else
            {
                PointInfo[i][pCaptureTime]--;

                if(PointInfo[i][pCaptureTime] <= 0)
                {
                    GiveGangPoints(PlayerData[PointInfo[i][pCapturer]][pGang], 50);

                    GetPlayerName(PointInfo[i][pCapturer], PointInfo[i][pCapturedBy], MAX_PLAYER_NAME);
                    PointInfo[i][pCapturedGang] = PlayerData[PointInfo[i][pCapturer]][pGang];

                    GangInfo[PointInfo[i][pCapturedGang]][gCash] += PointInfo[i][pProfits];
                    SendClientMessageToAllEx(COLOR_YELLOW, "Point wars: %s has successfully captured %s for %s.", GetRPName(PointInfo[i][pCapturer]), PointInfo[i][pName], GangInfo[PointInfo[i][pCapturedGang]][gName]);
                    SendGangMessage(PointInfo[i][pCapturedGang], COLOR_YELLOW, "Your gang has earned $%i, 50 GP for successfully capturing this point.", PointInfo[i][pProfits]);

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PointInfo[i][pCapturedGang]][gCash], PointInfo[i][pCapturedGang]);
                    mysql_tquery(connectionID, queryBuffer);

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedby = '%s', capturedgang = %i, profits = 0, time = 20 WHERE id = %i", PointInfo[i][pCapturedBy], PointInfo[i][pCapturedGang], i);
                    mysql_tquery(connectionID, queryBuffer);

                    PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
                    PointInfo[i][pCaptureTime] = 0;
                    PointInfo[i][pProfits] = 0;
                    PointInfo[i][pTime] = 20;

                    ReloadPoint(i);
                }
            }
        }
    }    

    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && PointInfo[i][pCaptureTime] > 0 && PointInfo[i][pCapturer] == playerid)
	    {
	        SendProximityMessage(i, 20.0, COLOR_RED, "(( %s disconnected and therefore failed to capture the point. ))", GetRPName(playerid));

	        PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
	        PointInfo[i][pCaptureTime] = 0;
	    }
	}
    return 1;
}

publish OnLoadPoints()
{
    new rows = cache_get_row_count(connectionID);

    for(new i = 0; i < rows && i < MAX_POINTS; i ++)
    {
        new pointid = cache_get_field_content_int(i, "id");

        cache_get_field_content(i, "name", PointInfo[pointid][pName], connectionID, 32);
        cache_get_field_content(i, "capturedby", PointInfo[pointid][pCapturedBy], connectionID, MAX_PLAYER_NAME);

        PointInfo[pointid][pCapturedGang] = cache_get_field_content_int(i, "capturedgang");
        PointInfo[pointid][pType] = cache_get_field_content_int(i, "type");
        PointInfo[pointid][pProfits] = cache_get_field_content_int(i, "profits");
        PointInfo[pointid][pTime] = cache_get_field_content_int(i, "time");
        PointInfo[pointid][pPointX] = cache_get_field_content_float(i, "point_x");
        PointInfo[pointid][pPointY] = cache_get_field_content_float(i, "point_y");
        PointInfo[pointid][pPointZ] = cache_get_field_content_float(i, "point_z");
        PointInfo[pointid][pPointInterior] = cache_get_field_content_int(i, "pointinterior");
        PointInfo[pointid][pPointWorld] = cache_get_field_content_int(i, "pointworld");
        PointInfo[pointid][pCaptureTime] = 0;
        PointInfo[pointid][pCapturer] = INVALID_PLAYER_ID;
        PointInfo[pointid][pText] = Text3D:INVALID_3DTEXT_ID;
        PointInfo[pointid][pPickup] = -1;
        PointInfo[pointid][pExists] = 1;

        if(PointInfo[pointid][pCapturedGang] >= 0 && !GangInfo[PointInfo[pointid][pCapturedGang]][gSetup])
        {
            PointInfo[pointid][pCapturedGang] = -1;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedgang = -1 WHERE id = %i", pointid);
            mysql_tquery(connectionID, queryBuffer);
        }

        ReloadPoint(pointid);
    }

    printf("[Script] %i points loaded.", rows);
    return 1;
}

Dialog:DIALOG_LOCATEPOINTS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    for(new i = 0; i < MAX_POINTS; i ++)
	    {
	        if(strfind(PointInfo[i][pName], inputtext) != -1)
	        {
		   	 	PlayerData[playerid][pCP] = CHECKPOINT_MISC;
		    	SetPlayerCheckpoint(playerid, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ], 3.0);
		    	SendClientMessageEx(playerid, COLOR_WHITE, "* Checkpoint marked at the location of %s.", PointInfo[i][pName]);
		    	break;
			}
		}
	}
	return 1;
}

CMD:createpoint(playerid, params[])
{
    new type, name[32];

    if(PlayerData[playerid][pAdmin] < 9 && !PlayerData[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "[!] You are not authorized to use this command.");
	}
	if(sscanf(params, "is[32]", type, name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createpoint [type] [name]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (1) Drug factory (2) Drug den (3) Crack house (4) Auto export (5) Fuel");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (6) Mat pickup 1 (7) Mat pickup 2 (8) Mat factory 1 (9) Mat factory 2");
	    return 1;
	}
	if(!(0 <= type <= 9))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}

	for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(!PointInfo[i][pExists])
	    {
			GetPlayerPos(playerid, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]);

	        strcpy(PointInfo[i][pName], name, 32);
	        strcpy(PointInfo[i][pCapturedBy], "No-one", MAX_PLAYER_NAME);

	        PointInfo[i][pExists] = 1;
	        PointInfo[i][pType] = type;
	        PointInfo[i][pProfits] = 0;
	        PointInfo[i][pCapturedGang] = -1;
	        PointInfo[i][pTime] = 20;
	        PointInfo[i][pPointInterior] = GetPlayerInterior(playerid);
	        PointInfo[i][pPointWorld] = GetPlayerVirtualWorld(playerid);
	        PointInfo[i][pCaptureTime] = 0;
        	PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
	        PointInfo[i][pText] = Text3D:INVALID_3DTEXT_ID;
	        PointInfo[i][pPickup] = -1;

	        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO points (id, name, type, point_x, point_y, point_z, pointinterior, pointworld) VALUES(%i, '%e', %i, '%f', '%f', '%f', %i, %i)", i, name, type, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ], PointInfo[i][pPointInterior], PointInfo[i][pPointWorld]);
	        mysql_tquery(connectionID, queryBuffer);

	        ReloadPoint(i);

	        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has created point {F7A763}%s{FF6347}.", GetRPName(playerid), name);
	        SendClientMessageEx(playerid, COLOR_AQUA, "You have created point {F7A763}%s{33CCFF}. /editpoint %i to edit this point.", name, i);
	        return 1;
		}
	}

	return 1;
}

CMD:gotopoint(playerid, params[])
{
	new pointid;

	if(PlayerData[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "[!] You are not authorized to use this command.");
	}
	if(sscanf(params, "i", pointid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotopoint [pointid]");
	}
	if(!(0 <= pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid point.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:editpoint(playerid, params[])
{
	new pointid, option[14], param[32];

	if(PlayerData[playerid][pAdmin] < 9 && !PlayerData[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "[!] You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[32]", pointid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [option]");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, Location, CapturedBy, Gang, Type, Profits, Time");
	    return 1;
	}
	if(!(0 <= pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid point.");
	}

 	if(!strcmp(option, "name", true))
    {
        if(isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [name] [text]");
		}

		strcpy(PointInfo[pointid][pName], param, 32);
		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET name = '%e' WHERE id = %i", PointInfo[pointid][pName], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the name of point %i to %s.", GetRPName(playerid), pointid, param);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the name of point %i to {F7A763}%s{33CCFF}.", pointid, param);
	}
	else if(!strcmp(option, "location", true))
    {
		GetPlayerPos(playerid, PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ]);
		PointInfo[pointid][pPointInterior] = GetPlayerInterior(playerid);
		PointInfo[pointid][pPointWorld] = GetPlayerVirtualWorld(playerid);
		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET point_x = '%f', point_y = '%f', point_z = '%f', pointinterior = %i, pointworld = %i WHERE id = %i", PointInfo[pointid][pPointX], PointInfo[pointid][pPointY], PointInfo[pointid][pPointZ], PointInfo[pointid][pPointInterior], PointInfo[pointid][pPointWorld], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has moved the location of point %i.", GetRPName(playerid), pointid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have moved the location of point %i.", pointid);
	}
	else if(!strcmp(option, "capturedby", true))
    {
        if(isnull(param) || strlen(params) > 24)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [capturedby] [name]");
		}

		strcpy(PointInfo[pointid][pCapturedBy], param, MAX_PLAYER_NAME);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedby = '%e' WHERE id = %i", PointInfo[pointid][pCapturedBy], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the capturer of point %i to %s.", GetRPName(playerid), pointid, param);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the capturer of point %i to {F7A763}%s{33CCFF}.", pointid, param);
	}
	else if(!strcmp(option, "gang", true))
    {
        new gangid;

        if(sscanf(param, "i", gangid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [gang] [gangid (-1 = none)]");
		}
		if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		}

		PointInfo[pointid][pCapturedGang] = gangid;
		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedgang = %i WHERE id = %i", PointInfo[pointid][pCapturedGang], pointid);
		mysql_tquery(connectionID, queryBuffer);

		if(gangid == -1)
		{
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the capturing gang of point %i.", GetRPName(playerid), pointid);
			SendClientMessageEx(playerid, COLOR_AQUA, "You have reset the capturing gang of point %i.", pointid);
		}
		else
		{
			SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the capturing gang of point %i to %s.", GetRPName(playerid), pointid, GangInfo[gangid][gName]);
			SendClientMessageEx(playerid, COLOR_AQUA, "You have set the capturing gang of point %i to {00AA00}%s{33CCFF}.", pointid, GangInfo[gangid][gName]);
		}
	}
	else if(!strcmp(option, "type", true))
    {
        new type;

        if(sscanf(param, "i", type))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [type] [value]");
           	SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (1) Drug factory (2) Drug den (3) Crack house (4) Auto export (5) Fuel");
			SendClientMessage(playerid, COLOR_SYNTAX, "List of types: (6) Mat pickup 1 (7) Mat pickup 2 (8) Mat factory 1 (9) Mat factory 2");
            return 1;
		}
		if(!(0 <= type <= 9))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

		PointInfo[pointid][pType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET type = %i WHERE id = %i", PointInfo[pointid][pType], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the type of point %i to %i.", GetRPName(playerid), pointid, type);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the type of point %i to %i.", pointid, type);
	}
    else if(!strcmp(option, "profits", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [profits] [value]");
		}

		PointInfo[pointid][pProfits] = value;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET profits = %i WHERE id = %i", PointInfo[pointid][pProfits], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the profits of point %i to $%i.", GetRPName(playerid), pointid, value);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the profits of point %i to $%i.", pointid, value);
	}
	else if(!strcmp(option, "time", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editpoint [pointid] [time] [hours (0-24)]");
		}
		if(!(0 <= value <= 24))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The amount of hours must range from 0 to 24.");
		}

		PointInfo[pointid][pTime] = value;

		if(PointInfo[pointid][pTime] == 0)
		{
		    SendClientMessageToAllEx(COLOR_YELLOW, "Point wars: %s is now available to capture.", PointInfo[pointid][pName]);
		}
		else
		{
		    PointInfo[pointid][pCapturer] = INVALID_PLAYER_ID;
		    PointInfo[pointid][pCaptureTime] = 0;
		}

		ReloadPoint(pointid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET time = %i WHERE id = %i", PointInfo[pointid][pTime], pointid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the time of point %i to %i hours.", GetRPName(playerid), pointid, value);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the time of point %i to %i hours.", pointid, value);
	}

	return 1;
}

CMD:removepoint(playerid, params[])
{
	new pointid;

	if(PlayerData[playerid][pAdmin] < 9 && !PlayerData[playerid][pGangMod])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "[!] You are not authorized to use this command.");
	}
	if(sscanf(params, "i", pointid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removepoint [pointid]");
	}
	if(!(0 <= pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid point.");
	}

	DestroyDynamic3DTextLabel(PointInfo[pointid][pText]);
	DestroyDynamicPickup(PointInfo[pointid][pPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM points WHERE id = %i", pointid);
	mysql_tquery(connectionID, queryBuffer);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has deleted point %s.", GetRPName(playerid), PointInfo[pointid][pName]);
	SendClientMessageEx(playerid, COLOR_AQUA, "You have deleted point {F7A763}%s{33CCFF}.", PointInfo[pointid][pName]);

	PointInfo[pointid][pExists] = 0;
	PointInfo[pointid][pCapturedGang] = -1;
	PointInfo[pointid][pTime] = 0;
	return 1;
}

CMD:pointscaplimit(playerid, params[])
{
	new amount;
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && PlayerData[playerid][pGangMod] < 1)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /pointscaplimit [amount]");
	}
    if(0 > amount > MAX_POINTS)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Amount must be above 0 and less then %i.", MAX_POINTS);
    }
    SetMaxPointCap(amount);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the max active point capture limit for gangs to %i.", GetRPName(playerid), amount);


	return 1;
}

CMD:capture(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 4)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not rank 4+ in any gang at the moment.");
	}
	if(PlayerData[playerid][pCapturingPoint] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are already attempting to capture the point.");
	}
	if(GangClaimingTurfs(PlayerData[playerid][pGang]) >= GetMaxTurfCap())
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're gang is already claiming %i turfs.", GetMaxTurfCap());
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't capture a point while injured.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
	}
    if(GangCapturingPoints(PlayerData[playerid][pGang]) >= GetMaxPointCap())
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're gang is already capturing %i points.", GetMaxPointCap());
	}
	for(new i = 0; i < MAX_POINTS; i ++)
	{
	    if(PointInfo[i][pExists] && IsPlayerInRangeOfPoint(playerid, 1.0, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]) && GetPlayerInterior(playerid) == PointInfo[i][pPointInterior] && GetPlayerVirtualWorld(playerid) == PointInfo[i][pPointWorld])
		{
			if(PointInfo[i][pTime] > 0)
			{
			    return SendClientMessage(playerid, COLOR_GREY, "This point is not available to capture yet.");
		    }
		    if(PointInfo[i][pCapturer] == playerid)
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "This point is already being captured by you.");
		    }
		    if(PointInfo[i][pCapturer] != INVALID_PLAYER_ID && PlayerData[PointInfo[i][pCapturer]][pGang] == PlayerData[playerid][pGang])
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "This point is already being captured by your gang.");
			}

		    foreach(new x : Player)
		    {
		        if(PlayerData[x][pCapturingPoint] == i && PlayerData[x][pCaptureTime] > 0)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "Someone else is already attempting to capture. Please wait until they're done.");
				}
			}

		    PlayerData[playerid][pCapturingPoint] = i;
		    PlayerData[playerid][pCaptureTime] = 10;

			GetPlayerPos(playerid, PlayerData[playerid][pPointX], PlayerData[playerid][pPointY], PlayerData[playerid][pPointZ]);
		    SendProximityMessage(playerid, 20.0, COLOR_RED, "(( %s is attempting to capture %s. ))", GetRPName(playerid), PointInfo[i][pName]);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any points.");
	return 1;
}

CMD:pointinfo(playerid, params[])
{
	new
		iCount,
		szMessage[128];

	SendClientMessage(playerid, COLOR_ORANGE, "Point Info:");
	for(new i; i < MAX_POINTS; i++) 
    {
		if(PointInfo[i][pExists]) 
        {
		    if(PointInfo[i][pCapturer] != INVALID_PLAYER_ID)  
            {
				if(PointInfo[i][pCaptureTime] == 1) 
                {
					format(szMessage, sizeof(szMessage), "* %s | Capper: %s | Gang: %s | Time left: Less than 1 minute", PointInfo[i][pName], GetRPName(PointInfo[i][pCapturer]), GangInfo[PlayerData[PointInfo[i][pCapturer]][pGang]][gName]);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					iCount++;
				}
                else 
                {
					format(szMessage, sizeof(szMessage), "* %s | Capper: %s | Gang: %s | Time left: %d minutes", PointInfo[i][pName], GetRPName(PointInfo[i][pCapturer]), GangInfo[PlayerData[PointInfo[i][pCapturer]][pGang]][gName], PointInfo[i][pCaptureTime]);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					iCount++;
				}
			}
		}
	}
	if(iCount == 0)
    {
		return SendClientMessage(playerid, COLOR_GREY, "No gang has attempted to capture a point at this time.");
    }
	return 1;
}

CMD:points(playerid, params[])
{
    new name[32], pointid, color = -1;

    if(sscanf(params, "i", pointid))
    {
        SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");

        for(new i = 0; i < MAX_POINTS; i++)
        {
            if(PointInfo[i][pExists])
            {
                if(PointInfo[i][pCapturedGang] >= 0)
                {
                    color = GangInfo[PointInfo[i][pCapturedGang]][gColor];
                    strcpy(name, GangInfo[PointInfo[i][pCapturedGang]][gName]);
                }
                else
                {
                    color = -1;
                    strcpy(name, "None");
                }
                SendClientMessageEx(playerid, COLOR_GREY, 
                    "ID: %i | Name: %s | Owner: {%06x}%s{AFAFAF} | Captured by: %s | Profits: %s | Time: %ih",
                    i, PointInfo[i][pName], color >>> 8, name, PointInfo[i][pCapturedBy], FormatNumber(PointInfo[i][pProfits]), PointInfo[i][pTime]
                );
            }
        }

        SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /points [pointid]");
        return 1;
    }

    if(!(0 <= pointid && pointid < MAX_POINTS) || !PointInfo[pointid][pExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid point.");
    }

    if(PointInfo[pointid][pCapturedGang] >= 0)
    {
        color = GangInfo[PointInfo[pointid][pCapturedGang]][gColor];
        strcpy(name, GangInfo[PointInfo[pointid][pCapturedGang]][gName]);
    }
    else
    {
        color = -1;
        strcpy(name, "None");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s ($%i) _____", PointInfo[pointid][pName], PointInfo[pointid][pProfits]);
    SendClientMessageEx(playerid, COLOR_WHITE, "* This point captured by %s for {%06x}%s{FFFFFF} will be available in %i hours.", 
        PointInfo[pointid][pCapturedBy], color >>> 8, name, PointInfo[pointid][pTime]
    );

    if(PointInfo[pointid][pCapturer] != INVALID_PLAYER_ID)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "* This point is being captured by %s and will be theirs in %i minutes.", 
            GetRPName(PointInfo[pointid][pCapturer]), PointInfo[pointid][pCaptureTime]
        );
    }
    return 1;
}