enum TurfTypeEnum
{
	TurfType_Name[32],
	TurfType_Tax,
	TurfType_Cash,
	TurfType_Materials,
	TurfType_Weed,
	TurfType_Cocaine,
	TurfType_Heroin,
	TurfType_Weapon[5],
	TurfType_WeaponQty[5]
};

#define LOCKED_TURF_TYPE 0
new LastClaimGlobal = 0;
#define CLAIM_COOLDOWN 60

static TurfType[][TurfTypeEnum] = {
	{ "Locked", 				0, 0, 0, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Normal", 				0, 0, 0, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Sales tax", 				10, 0, 0, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Low Cash",				0,  50000, 0, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Medium Cash",			0, 100000, 0, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "High Cash",				0, 250000, 0, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Low Materials",			0, 0, 100000, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Medium Materials",		0, 0, 150000, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "High Materials",			0, 0, 300000, 0,0,0, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Low class weapons",     0, 0, 0, 0,0,0, {22,25,28,33,0}, {8,5,8,4,0}},
	{ "Medium class weapons",  0, 0, 0, 0,0,0, {24,29,30,0,0}, {5,5,5,0,0}},
	{ "High class Weapons",    0, 0, 0, 0,0,0, {27,31,34,0,0}, {4,8,5,0,0}},
	{ "Heavy weapons",         0, 0, 0, 0,0,0, {35,0,0,0,0},   {2,0,0,0,0}},
	{ "Low Drugs",				0, 0, 0, 50,30,30, {0,0,0,0,0},{0,0,0,0,0}},
	{ "Medium Drugs",			0, 0, 0, 100,50,50, {0,0,0,0,0},{0,0,0,0,0}},
	{ "High Drugs",				0, 0, 0, 150,100,100, {0,0,0,0,0},{0,0,0,0,0}}
};

enum tEnum
{
	tExists,
	tName[32],
	tCapturedBy[MAX_PLAYER_NAME],
	tCapturedGang,
	tType,
	tTime,
	Float:tMinX,
	Float:tMinY,
	Float:tMaxX,
	Float:tMaxY,
	Float:tHeight,
	Float:tHeightX,
	Float:tHeightY,
	Float:tHeightZ,
	tHeightVirtualWorld,
	tHeightInterior,
	tGangZone,
	tArea,
	tPickup,
	tCaptureTime,
	tCapturer,
	tCount,
	tBeingCaptured
};

static TurfInfo[MAX_TURFS][tEnum];
static PlayerKListTurfPageIdx[MAX_PLAYERS];


Dialog:DlgListTurfs(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ShowListTurfs(playerid, PlayerKListTurfPageIdx[playerid] + 1);
	}
	return 1;
}

Dialog:DIALOG_LOCATETURFS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    foreach(new i : Turf)
	    {
	        if(strfind(TurfInfo[i][tName], inputtext) != -1)
	        {
		   	 	PlayerData[playerid][pCP] = CHECKPOINT_MISC;
		    	SetPlayerCheckpoint(playerid, TurfInfo[i][tHeightX], TurfInfo[i][tHeightY], TurfInfo[i][tHeightZ], 3.0);
		    	SendClientMessageEx(playerid, COLOR_WHITE, "* Checkpoint marked at the location of %s.", TurfInfo[i][tName]);
		    	break;
			}
		}
	}
	return 1;
}

ShowListTurfs(playerid, page=0)
{
	new turfid, name[32], color, timeleft[80], title[40], string[2048];
	new total_turfs=0;
	new total_pages=1;
	PlayerKListTurfPageIdx[playerid] = page;
	string = "Name\tOwner\tPerk\tTime Left\t";

	for(turfid = 0; turfid < MAX_TURFS; turfid++)
	{
	    if(TurfInfo[turfid][tType] != LOCKED_TURF_TYPE && TurfInfo[turfid][tExists])
	    {
			total_turfs++;
			if(total_pages*MAX_TURFS_PER_PAGE < total_turfs)
			{
				total_pages++;
			}
			if(total_turfs < page*MAX_TURFS_PER_PAGE)
			{
				continue;
			}
			else if(total_turfs > (page+1)*MAX_TURFS_PER_PAGE)
			{
				continue;
			}

			if(TurfInfo[turfid][tCapturedGang] >= 0)
			{
    			strcpy(name, GangInfo[TurfInfo[turfid][tCapturedGang]][gName]);
				color = GangInfo[TurfInfo[turfid][tCapturedGang]][gColor];
			}
			else if(TurfInfo[turfid][tCapturedGang] == -5)
			{
				name = "Shutdown by The Police";
				color = 0x8D8DFF00;
			}
			else
			{
				color = COLOR_FACTIONCHAT;
				name = "None";
			}
			if(TurfInfo[turfid][tTime] > 0)
            {
                format(timeleft, sizeof(timeleft), "%d hours left", TurfInfo[turfid][tTime]);
            }
			else if(TurfInfo[turfid][tBeingCaptured])
            {
                new attackerid = TurfInfo[turfid][tCapturer];
                if(IsPlayerConnected(attackerid))                
                {
                    if(IsLawEnforcement(attackerid))
                    {
                        format(timeleft, sizeof(timeleft), "Attacked by {8D8DFF}Police{FFFFFF} (%imin left)", TurfInfo[turfid][tCaptureTime]);
                    }
                    else
                    {
                        new gangid = PlayerData[attackerid][pGang];
                        new gcolor = GangInfo[gangid][gColor];
                        format(timeleft, sizeof(timeleft), "Attacked by {%06x}%s{FFFFFF} (%imin left)", gcolor >>> 8, GangInfo[gangid][gName], TurfInfo[turfid][tCaptureTime]);
                    }
                }
                else
                {
                    format(timeleft, sizeof(timeleft), "Attacked by Unknown (%imin left)", TurfInfo[turfid][tCaptureTime]);  
                }
            }
			else 
            {
                format(timeleft, sizeof(timeleft), "Vulnerable");
            }

			format(string, sizeof(string), "%s\n{FFFFFF}%i- %s\t{%06x}%s{FFFFFF}\t%s\t%s\n",string,turfid,TurfInfo[turfid][tName],color >>> 8,name,TurfType[TurfInfo[turfid][tType]][TurfType_Name],timeleft);
		}
	}
	format(title, sizeof(title), "Turf list (Page %i of %i)", page+1, total_pages);
	if(page+1 == total_pages)
	{
    	Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Cancel", "");
	}
	else
	{
		Dialog_Show(playerid, DlgListTurfs, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Next", "Cancel");
	}
	return 1;
}

GetGangTurfsCount(gangid, &captured, &total)
{
    captured = 0;
    total = 0;
    foreach(new i : Turf)
    {
        if(TurfInfo[i][tExists])
        {
            if(TurfInfo[i][tCapturedGang] == gangid)
                captured++;
            else if(TurfInfo[i][tType] != LOCKED_TURF_TYPE)
                total++;
        }
    }
    return 1;
}

ClearGangTurfs(gangid)
{
 	foreach(new i : Turf)
	{
		if(TurfInfo[i][tExists] && TurfInfo[i][tCapturedGang] == gangid)
		{
		    TurfInfo[i][tCapturedGang] = -1;
		}
	}
    return 1;
}

IsTurfCapturedByGang(turfid, gangid)
{
    return (TurfInfo[turfid][tExists] && TurfInfo[turfid][tCapturedGang] == gangid);
}

IsValidTurfId(turfid)
{
    return 0 <= turfid < sizeof(TurfInfo) && TurfInfo[turfid][tExists];
}

IsActiveTurf(turfid)
{
    return (TurfInfo[turfid][tBeingCaptured] && TurfInfo[turfid][tTime] == 0);
}

GetNearbyTurfPoint(playerid)
{
	foreach(new i : Turf)
	{
		if	(TurfInfo[i][tExists] && 
			(IsPlayerNearPoint(playerid, 5.0, TurfInfo[i][tHeightX], TurfInfo[i][tHeightY], TurfInfo[i][tHeightZ])) && 
			(GetPlayerInterior(playerid) == TurfInfo[i][tHeightInterior] && GetPlayerVirtualWorld(playerid) ==  TurfInfo[i][tHeightVirtualWorld]))
		{
			return i;
		}
	}

	return -1;
}

GetNearbyTurf(playerid)
{
	//if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
	{
  		foreach(new i : Turf)
		{
			if(TurfInfo[i][tExists] && IsPlayerInDynamicArea(playerid, TurfInfo[i][tArea]))
			{
			    return i;
			}
		}
	}

	return -1;
}


ReloadTurf(turfid)
{
	if(TurfInfo[turfid][tExists])
	{
	    DestroyDynamicArea(TurfInfo[turfid][tArea]);
	    GangZoneDestroy(TurfInfo[turfid][tGangZone]);
		DestroyDynamicPickup(TurfInfo[turfid][tPickup]);
	    TurfInfo[turfid][tArea] = CreateDynamicRectangle(TurfInfo[turfid][tMinX], TurfInfo[turfid][tMinY], TurfInfo[turfid][tMaxX], TurfInfo[turfid][tMaxY]);
	    TurfInfo[turfid][tGangZone] = GangZoneCreateEx(TurfInfo[turfid][tMinX], TurfInfo[turfid][tMinY], TurfInfo[turfid][tMaxX], TurfInfo[turfid][tMaxY]);
	    TurfInfo[turfid][tPickup] = CreateDynamicPickup(1254, 1, TurfInfo[turfid][tHeightX], TurfInfo[turfid][tHeightY], TurfInfo[turfid][tHeightZ]);
		LastClaimGlobal = gettime();

     	foreach(new i : Player)
	    {
	        if(PlayerData[i][pShowTurfs])
	        {
	            ShowTurfsOnMap(i, true);
			}
		}
	}
}

GetTurfColor(turfid)
{
	if(TurfInfo[turfid][tCapturedGang] >= 0)
	{
	    return (GangInfo[TurfInfo[turfid][tCapturedGang]][gColor] & ~0xff) + 0xAA;
	}
	else if(TurfInfo[turfid][tCapturedGang] == -5)
	{
		return 0x8D8DFFAA;
	}

	return 0x000000AA;
}

ShowFindTurfDlg(playerid)
{
    new string[34 * MAX_TURFS];
    for(new x = 0; x < MAX_TURFS; x++)
    {
        if(TurfInfo[x][tExists]) 
        {
            strcat(string, TurfInfo[x][tName]);
            strcat(string, "\n");
        }
    }

    if(strlen(string) > 2)
    {
        Dialog_Show(playerid, DIALOG_LOCATETURFS, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
    }
    else 
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "GPS - Signal Lost", "Unable to locate any new locations.", "Cancel", "");
    }
    return 1;
}

 stock GetPlayerTurfZone(playerid)
{
	for(new i = 0; i < MAX_TURFS; i++) if(IsPlayerInDynamicArea(playerid, TurfInfo[i][tArea])) return i;
	return -1;
}

TurfTaxCheck(playerid, amount)
{
	new turfid = GetNearbyTurf(playerid);

	if(turfid >= 0 && TurfType[TurfInfo[turfid][tType]][TurfType_Tax] && TurfInfo[turfid][tCapturedGang] >= 0)
	{
	    if(!(PlayerData[playerid][pGang] >= 0 && PlayerData[playerid][pGang] == TurfInfo[turfid][tCapturedGang]))
	    {
		    amount = percent(amount, TurfType[TurfInfo[turfid][tType]][TurfType_Tax]);

		    SendClientMessageEx(playerid, COLOR_AQUA, "You have been taxed a 10 percent fee of {FF6347}$%i{33CCFF} for selling in %s's turf.", amount, GangInfo[TurfInfo[turfid][tCapturedGang]][gName]);
		    GivePlayerCash(playerid, -amount);

		    GangInfo[TurfInfo[turfid][tCapturedGang]][gCash] += amount;

		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET cash = %i WHERE id = %i", GangInfo[TurfInfo[turfid][tCapturedGang]][gCash], TurfInfo[turfid][tCapturedGang]);
	    	mysql_tquery(connectionID, queryBuffer);
		}
	}
}

stock GetTurfOwnerNameTextDraw(id)
{

    new turfname[128], name[32];

	if(TurfInfo[id][tCapturedGang] >= 0)
	{
		strcpy(name, GangInfo[TurfInfo[id][tCapturedGang]][gName]);
	}
	format(turfname, sizeof(turfname), "%s", name);
	return turfname;
}
GangClaimingTurfs(gang)
{
	new capCount = 0;
	for(new x = 0; x < MAX_TURFS; x++)
	{
		if(TurfInfo[x][tExists] && TurfInfo[x][tCapturer] != INVALID_PLAYER_ID && TurfInfo[x][tTime] == 0)
		{
			if(PlayerData[TurfInfo[x][tCapturer]][pGang] == gang)
			{
    			capCount++;
			}
		}
	}
	return capCount;
}


ListGangTurfs(playerid)
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");

    foreach(new i : Turf)
    {
        if(TurfInfo[i][tExists] && TurfInfo[i][tCapturedGang] == PlayerData[playerid][pGang])
        {
			SendClientMessageEx(playerid, COLOR_GREY2, "ID: %i | Name: %s | Captured by: %s | Perk: %s | Time left: %ih", i, TurfInfo[i][tName], TurfInfo[i][tCapturedBy], TurfType[TurfInfo[i][tType]][TurfType_Name], TurfInfo[i][tTime]);
        }
    }
    return 1;
}

ShowTurfsOnMap(playerid, enable)
{
 	foreach(new i : Turf)
	{
	    if(TurfInfo[i][tExists])
	    {
		    if(enable)
			{
			    GangZoneShowForPlayer(playerid, TurfInfo[i][tGangZone], GetTurfColor(i));

			    if(TurfInfo[i][tCapturer] == INVALID_PLAYER_ID)
			    {
                    GangZoneStopFlashForPlayer(playerid, TurfInfo[i][tGangZone]);
			    }
			    else
			    {
				    if(IsLawEnforcement(TurfInfo[i][tCapturer]))
				        GangZoneFlashForPlayer(playerid, TurfInfo[i][tGangZone], 0x8D8DFF00);
					else if(PlayerData[TurfInfo[i][tCapturer]][pGang] >= 0)
						GangZoneFlashForPlayer(playerid, TurfInfo[i][tGangZone], (GangInfo[PlayerData[TurfInfo[i][tCapturer]][pGang]][gColor] & ~0xff) + 0xAA);
				}
			}
			else
			{
		    	GangZoneHideForPlayer(playerid, TurfInfo[i][tGangZone]);
			}
		}
	}

	PlayerData[playerid][pShowTurfs] = enable;
}

IsInSameActiveTurf(playerid, targetid)
{
	foreach(new i : Turf)
	{
		if(TurfInfo[i][tExists] && TurfInfo[i][tCapturer] != INVALID_PLAYER_ID && IsPlayerInDynamicArea(playerid, TurfInfo[i][tArea]) && IsPlayerInDynamicArea(targetid, TurfInfo[i][tArea])) return true;
	}
	return false;
}

publish OnLoadTurfs()
{
    new rows = cache_get_row_count(connectionID);

    for(new i = 0; i < rows && i < MAX_TURFS; i ++)
    {
        new turfid = cache_get_field_content_int(i, "id");

        cache_get_field_content(i, "name", TurfInfo[turfid][tName], connectionID, 32);
        cache_get_field_content(i, "capturedby", TurfInfo[turfid][tCapturedBy], connectionID, MAX_PLAYER_NAME);

        TurfInfo[turfid][tCapturedGang] = cache_get_field_content_int(i, "capturedgang");
        TurfInfo[turfid][tType] = cache_get_field_content_int(i, "type");
        TurfInfo[turfid][tTime] = cache_get_field_content_int(i, "time");
        TurfInfo[turfid][tMinX] = cache_get_field_content_float(i, "min_x");
        TurfInfo[turfid][tMinY] = cache_get_field_content_float(i, "min_y");
        TurfInfo[turfid][tMaxX] = cache_get_field_content_float(i, "max_x");
        TurfInfo[turfid][tMaxY] = cache_get_field_content_float(i, "max_y");
        TurfInfo[turfid][tHeight] = cache_get_field_content_float(i, "height");
        TurfInfo[turfid][tHeightX] = cache_get_field_content_float(i, "heightx");
        TurfInfo[turfid][tHeightY] = cache_get_field_content_float(i, "heighty");
        TurfInfo[turfid][tHeightZ] = cache_get_field_content_float(i, "heightz");
        TurfInfo[turfid][tHeightInterior] = cache_get_field_content_int(i, "heightinterior");
        TurfInfo[turfid][tHeightVirtualWorld] = cache_get_field_content_int(i, "heightvirtualworld");
        TurfInfo[turfid][tCount] = cache_get_field_content_int(i, "count");
        TurfInfo[turfid][tGangZone] = -1;
        TurfInfo[turfid][tArea] = -1;
        TurfInfo[turfid][tPickup] = -1;
        TurfInfo[turfid][tCaptureTime] = 0;
        TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
        TurfInfo[turfid][tBeingCaptured] = false;
        TurfInfo[turfid][tExists] = 1;
        Iter_Add(Turf, turfid);

        ReloadTurf(turfid);
    }

    printf("[Script] %i turfs loaded.", rows);
    return 1;
}

publish OnAdminCreateTurf(playerid, turfid, name[], type, Float:minx, Float:miny, Float:maxx, Float:maxy, Float:height, Float:heightx, Float:heighty, Float:heightz)
{
	strcpy(TurfInfo[turfid][tName], name, 32);
	strcpy(TurfInfo[turfid][tCapturedBy], "No-one", MAX_PLAYER_NAME);

	TurfInfo[turfid][tExists] = 1;
	TurfInfo[turfid][tCapturedGang] = -1;
	TurfInfo[turfid][tBeingCaptured] = false;
	TurfInfo[turfid][tTime] = 24;
	TurfInfo[turfid][tType] = type;
	TurfInfo[turfid][tMinX] = minx;
	TurfInfo[turfid][tMinY] = miny;
	TurfInfo[turfid][tMaxX] = maxx;
	TurfInfo[turfid][tMaxY] = maxy;
	TurfInfo[turfid][tHeight] = height;
	TurfInfo[turfid][tGangZone] = -1;
	TurfInfo[turfid][tPickup] = -1;
	TurfInfo[turfid][tArea] = -1;
	TurfInfo[turfid][tCaptureTime] = 0;
	TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
	TurfInfo[turfid][tMinY] = miny;
	TurfInfo[turfid][tMaxX] = maxx;
	TurfInfo[turfid][tMaxY] = maxy;
	TurfInfo[turfid][tHeightX] = heightx;
	TurfInfo[turfid][tHeightY] = heighty;
	TurfInfo[turfid][tHeightZ] = heightz;
	TurfInfo[turfid][tHeightInterior] = GetPlayerInterior(playerid);
	TurfInfo[turfid][tHeightVirtualWorld] = GetPlayerVirtualWorld(playerid);
	Iter_Add(Turf, turfid);

	ReloadTurf(turfid);
	SendClientMessageEx(playerid, COLOR_GREEN, "* Turf %i created successfully.", turfid);
}

hook OnNewHour(timestamp, hour)
{
    foreach(new i : Turf)
    {
        if(TurfInfo[i][tExists])
        {
            if(TurfInfo[i][tTime] > 0)
            {
                TurfInfo[i][tTime]--;
                ReloadTurf(i);
            }

            if(!TurfInfo[i][tTime] && TurfInfo[i][tType] != LOCKED_TURF_TYPE)
            {
                SendTurfMessage(i, COLOR_YELLOW, "Turf wars: %s is now available to capture.", TurfInfo[i][tName]);
            }

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET time = %i WHERE id = %i", TurfInfo[i][tTime], i);
            mysql_tquery(connectionID, queryBuffer);
        }
    }

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
 	foreach(new i : Turf)
	{
	    if(TurfInfo[i][tExists] && TurfInfo[i][tCaptureTime] > 0 && TurfInfo[i][tCapturer] == playerid)
	    {
            new claimerid = INVALID_PLAYER_ID;
	        if(reason == 0)
			{
				if(PlayerData[playerid][pGang] >= 0)
		        {
                    new gangid = PlayerData[playerid][pGang];
                    foreach(new j:Player)
                    {
                        if(j!=playerid && PlayerData[j][pGang] == gangid && GetNearbyTurfPoint(j) == i)
                        {
                            claimerid = j;
                            break;
                        }
                    }
                    if(IsPlayerConnected(claimerid))
                    {
                        TurfInfo[i][tCapturer] = claimerid;
                        SendGangMessage(gangid, COLOR_YELLOW, "%s crashed while attempting to capture a turf.  %s is now claiming the turf.", GetRPName(playerid), GetRPName(claimerid));
                    }
                    else
                    {
                        GangInfo[gangid][gTurfTokens]++;
                        SendGangMessage(gangid, COLOR_YELLOW, "%s crashed while attempting to capture a turf. 1 turf token was refunded to your gang.", GetRPName(playerid));

                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET turftokens = turftokens + 1 WHERE id = %i", gangid);
                        mysql_tquery(connectionID, queryBuffer);
                    }
				}
				else if(PlayerData[playerid][pFaction] >= 0)
		        {
                    new factionid = PlayerData[playerid][pFaction];
                    foreach(new j:Player)
                    {
                        if(j!=playerid && PlayerData[j][pFaction] == factionid && GetNearbyTurfPoint(j) == i)
                        {
                            claimerid = j;
                            break;
                        }
                    }
                    if(IsPlayerConnected(claimerid))
                    {
                        TurfInfo[i][tCapturer] = claimerid;
                        SendFactionMessage(factionid, COLOR_YELLOW, "%s crashed while attempting to capture a turf. %s is now claiming the turf.", GetRPName(playerid), GetRPName(claimerid));
                    }
                    else
                    {
                        FactionInfo[factionid][fTurfTokens]++;
                        SendFactionMessage(factionid, COLOR_YELLOW, "%s crashed while attempting to capture a turf. 1 turf token was refunded to your faction.", GetRPName(playerid));

                        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET turftokens = turftokens + 1 WHERE id = %i", factionid);
                        mysql_tquery(connectionID, queryBuffer);
                    }

				}
			}
            if(IsPlayerConnected(claimerid))
            {
                SendTurfMessage(i, COLOR_RED, "(( %s disconnected and %s is now capturing the turf. ))", GetRPName(playerid), GetRPName(claimerid));
            }
	        else
            {
                SendTurfMessage(i, COLOR_RED, "(( %s disconnected and therefore failed to capture the turf. ))", GetRPName(playerid));
                TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
                TurfInfo[i][tCaptureTime] = 0;
                ReloadTurf(i);
            }
	    }
	}
    return 1;
}

hook OnNewMinute(timestamp)
{
    foreach(new i : Turf)
    {
        if(TurfInfo[i][tExists] && TurfInfo[i][tCapturer] != INVALID_PLAYER_ID && TurfInfo[i][tCaptureTime] > 0)
        {
            if(!IsLawEnforcement(TurfInfo[i][tCapturer]) && (PlayerData[TurfInfo[i][tCapturer]][pGang] == -1))
            {
                TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
                TurfInfo[i][tCaptureTime] = 0;
                ReloadTurf(i);
            }
            else
            {
                TurfInfo[i][tCaptureTime]--;

                if(TurfInfo[i][tCaptureTime] <= 0)
                {
                    GetPlayerName(TurfInfo[i][tCapturer], TurfInfo[i][tCapturedBy], MAX_PLAYER_NAME);

                    if(IsLawEnforcement(TurfInfo[i][tCapturer]))
                    {
                        SendClientMessageToAllEx(COLOR_YELLOW, "Turf wars: %s has been successfully claimed back by %s.", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]));
                        GetPlayerName(TurfInfo[i][tCapturer], TurfInfo[i][tCapturedBy], MAX_PLAYER_NAME);
                        TurfInfo[i][tBeingCaptured] = false;
                        TurfInfo[i][tCapturedGang] = -5;
                        SendTurfMessage(i, COLOR_YELLOW, "Turf wars: The police have succesfully shutdown %s.", TurfInfo[i][tName]);
                        for(new y = 0; y < MAX_FACTIONS; y++)
                        {
                            if(FactionInfo[y][fType] == FACTION_POLICE || FactionInfo[y][fType] == FACTION_FEDERAL || FactionInfo[y][fType] == FACTION_ARMY)
                            {
                                SendFactionMessage(y, COLOR_YELLOW, "TURFS: Your faction has successfully shutdown a turf, You have earned $5000.");
                                foreach(new x: Player)
                                {
                                    if(PlayerData[x][pFaction] == y)
                                    {
                                            GivePlayerCash(x, 5000);
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        new gangid = PlayerData[TurfInfo[i][tCapturer]][pGang];

                        TurfInfo[i][tCapturedGang] = gangid;
                        TurfInfo[i][tBeingCaptured] = false;
                        GiveGangPoints(gangid, 25);
                        SendClientMessageToAllEx(COLOR_YELLOW, "Turf wars: %s has been successfully claimed by %s for %s.", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]), GangInfo[gangid][gName]);

						new typeid = TurfInfo[i][tType];
						if(TurfType[typeid][TurfType_Tax])
						{
                        	SendGangMessage(gangid, COLOR_YELLOW, "Your gang will now receive %i percents of all sales in this turf.", TurfType[typeid][TurfType_Tax]);
						}
						if(TurfType[typeid][TurfType_Materials])
						{
							new limit = GetGangStashCapacity(gangid, STASH_CAPACITY_MATERIALS);
							new current = GangInfo[gangid][gMaterials];
							new amount = TurfType[typeid][TurfType_Materials];
							amount += (amount * GangInfo[gangid][gMatLevel]) / 10;// +10% per level
							
							GangInfo[gangid][gMaterials] = (current + amount) > limit ? limit : current + amount;
							SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %i materials in the stash for capturing this turf!", amount);

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
							mysql_tquery(connectionID, queryBuffer);
						}

						if(TurfType[typeid][TurfType_Weed])
						{
							new weed  = GangInfo[gangid][gWeed] + TurfType[typeid][TurfType_Weed];
							new limit = GetGangStashCapacity(gangid, STASH_CAPACITY_WEED);

							GangInfo[gangid][gWeed] = weed > limit ? limit : weed;
							
							SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %ig of weed in the stash for capturing this turf!", TurfType[typeid][TurfType_Weed]);

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weed = %i WHERE id = %i", GangInfo[gangid][gWeed], gangid);
							mysql_tquery(connectionID, queryBuffer);
						}

						if(TurfType[typeid][TurfType_Cocaine])
						{
							new cocaine = GangInfo[gangid][gCocaine] + TurfType[typeid][TurfType_Cocaine];
							new limit   = GetGangStashCapacity(gangid, STASH_CAPACITY_COCAINE);

							GangInfo[gangid][gCocaine] =  cocaine > limit ? limit : cocaine;
							
							SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %ig of cocaine in the stash for capturing this turf!", TurfType[typeid][TurfType_Cocaine]);

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET cocaine = %i WHERE id = %i", GangInfo[gangid][gCocaine], gangid);
							mysql_tquery(connectionID, queryBuffer);
						}

						if(TurfType[typeid][TurfType_Heroin])
						{
							new heroin = GangInfo[gangid][gHeroin] + TurfType[typeid][TurfType_Heroin];
							new limit  = GetGangStashCapacity(gangid, STASH_CAPACITY_HEROIN);

							GangInfo[gangid][gHeroin]    =  heroin  > limit  ? limit  : heroin;
							
							SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %ig of heroin in the stash for capturing this turf!", TurfType[typeid][TurfType_Heroin]);

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET heroin = %i WHERE id = %i", GangInfo[gangid][gHeroin], gangid);
							mysql_tquery(connectionID, queryBuffer);
						}
                        new weaponlimit = GetGangStashCapacity(gangid, STASH_CAPACITY_WEAPONS);
						new saveweapons = 0;
						for(new wid = 0 ; wid < 5 ; wid++)
						{
							new qty = TurfType[typeid][TurfType_WeaponQty][wid];
							new weaponid = TurfType[typeid][TurfType_Weapon][wid];

							if(weaponid && qty)
							{
								saveweapons = 1;
								new widx = -1;
								switch(weaponid)
								{
									case 22: { widx = GANGWEAPON_9MM; }
									case 23: { widx = GANGWEAPON_SDPISTOL; }
									case 24: { widx = GANGWEAPON_DEAGLE; }
									case 25: { widx = GANGWEAPON_SHOTGUN; }
									case 27: { widx = GANGWEAPON_SPAS12; }
									case 28: { widx = GANGWEAPON_UZI; }
									case 29: { widx = GANGWEAPON_MP5; }
									case 30: { widx = GANGWEAPON_AK47; }
									case 31: { widx = GANGWEAPON_M4; }
									case 32: { widx = GANGWEAPON_TEC9; }
									case 33: { widx = GANGWEAPON_RIFLE; }
									case 34: { widx = GANGWEAPON_SNIPER; }
									case 35: { SendGangMessage(gangid, COLOR_YELLOW, "Your gang doesn't earned %i of Rocket as it's not implemented yet!", qty); }
								}
								if(widx != -1)
								{
									GangInfo[gangid][gWeapons][widx] = (GangInfo[gangid][gWeapons][widx] + qty > weaponlimit) ? weaponlimit : GangInfo[gangid][gWeapons][widx] + qty;
									SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %i of %s in the stash!", qty, GetWeaponNameEx(weaponid)); 
								}
							}
						}

						if(saveweapons)
						{
							new pistol9mm = GangInfo[gangid][gWeapons][GANGWEAPON_9MM];
							new sdpistol = GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL];
							new deagle = GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE];
							new shotgun = GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN];
							new spas12 = GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12];
							new uzi = GangInfo[gangid][gWeapons][GANGWEAPON_UZI];
							new mp5 = GangInfo[gangid][gWeapons][GANGWEAPON_MP5];
							new ak47 = GangInfo[gangid][gWeapons][GANGWEAPON_AK47];
							new m4 = GangInfo[gangid][gWeapons][GANGWEAPON_M4];
							new tec9 = GangInfo[gangid][gWeapons][GANGWEAPON_TEC9];
							new rifle = GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE];
							new sniper = GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER];

							mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_9mm = %i, weapon_ak47 = %i, weapon_deagle = %i, weapon_m4 = %i, weapon_mp5 = %i, weapon_rifle = %i, weapon_sdpistol = %i, weapon_shotgun = %i, weapon_sniper = %i, weapon_spas12 = %i, weapon_tec9 = %i, weapon_uzi = %i WHERE id = %i", pistol9mm, ak47, deagle, m4, mp5, rifle, sdpistol, shotgun, sniper, spas12, tec9, uzi, gangid);
							mysql_tquery(connectionID, queryBuffer);							
						}
                    }
					
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedby = '%s', capturedgang = %i, time = 24 WHERE id = %i", TurfInfo[i][tCapturedBy], TurfInfo[i][tCapturedGang], i);
                    mysql_tquery(connectionID, queryBuffer);
					
					TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
                    TurfInfo[i][tCaptureTime] = 0;
                    TurfInfo[i][tTime] = 24;
					
					ReloadTurf(i);
                }
            }
        }
    }
    return 1;
}

CMD:turfinfo(playerid, params[])
{
	new turfid, name[32] = "None", color = -1;

	if((turfid = GetNearbyTurf(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any turfs.");
	}

	if(TurfInfo[turfid][tCapturedGang] >= 0)
	{
    	strcpy(name, GangInfo[TurfInfo[turfid][tCapturedGang]][gName]);
    	color = GangInfo[TurfInfo[turfid][tCapturedGang]][gColor];
	}

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s (%s) _____", TurfInfo[turfid][tName], TurfType[TurfInfo[turfid][tType]][TurfType_Name]);

	if(TurfInfo[turfid][tType] == LOCKED_TURF_TYPE)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "* This turf is owned by {%06x}%s{FFFFFF} and is not available to capture.", color >>> 8, name);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "* This turf captured by %s for {%06x}%s{FFFFFF} will be available in %i hours.", TurfInfo[turfid][tCapturedBy], color >>> 8, name, TurfInfo[turfid][tTime]);

    	if(TurfInfo[turfid][tCapturer] != INVALID_PLAYER_ID)
		{
	    	SendClientMessageEx(playerid, COLOR_WHITE, "* This turf is being captured by %s and will be theirs in %i minutes.", GetRPName(TurfInfo[turfid][tCapturer]), TurfInfo[turfid][tCaptureTime]);
		}
	}

	return 1;
}


CMD:showturfs(playerid, params[])
{
	if(!PlayerData[playerid][pShowTurfs])
	{
        	ShowTurfsOnMap(playerid, true);
        	SendClientMessage(playerid, COLOR_AQUA, "You will now see turfs on your mini-map.");
	}
	else
	{
        	ShowTurfsOnMap(playerid, false);
        	SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any turfs on your mini-map.");
	}

	return 1;
}

CMD:turfs(playerid, params[])
{
	ShowListTurfs(playerid, 0);
	return 1;
}

CMD:createturf(playerid, params[])
{
	new type, name[32];

    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[32]", type, name))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createturf [special type] [name]");
		new string[128], finalsend = 0;
		string = "List of types: ";
		for(new i=0; i<sizeof(TurfType);i++)
		{
			format(string, sizeof(string), "%s (%i) %s", string, i, TurfType[i][TurfType_Name]);
			finalsend = 1;
			if(i%5 == 0 && i != 0)
			{
				SendClientMessage(playerid, COLOR_SYNTAX, string);
				string = "List of types: ";
				finalsend = 0;
			}
		}
		if(finalsend)
		{
			SendClientMessage(playerid, COLOR_SYNTAX, string);
		}
	    return 1;
	}
	if(!(0 <= type < sizeof(TurfType)))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}
	if(GetNearbyTurf(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a turf in range. Find somewhere else to create this one.");
	}
	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot create turfs indoors.");
	}

	PlayerData[playerid][pTurfType] = type;
	PlayerData[playerid][pZoneType] = ZONETYPE_TURF;

	strcpy(PlayerData[playerid][pTurfName], name, 32);
	Dialog_Show(playerid, DIALOG_CREATEZONE, DIALOG_STYLE_MSGBOX, "Turf creation system", "You have entered turf creation mode. In order to create a turf you need\nto mark four points around the area you want your turf to be in, forming\na square. You must make a square or your outcome won't be as expected.\n\nPress {00AA00}Confirm{A9C4E4} to begin turf creation.", "Confirm", "Cancel");
	return 1;
}

CMD:turfcancel(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(PlayerData[playerid][pZoneCreation] != ZONETYPE_TURF)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not creating a turf at the moment.");
	}

	CancelZoneCreation(playerid);
	SendClientMessage(playerid, COLOR_LIGHTRED, "* Land creation cancelled.");
	return 1;
}

CMD:gototurf(playerid, params[])
{
	new turfid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", turfid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gototurf [turfid]");
	}
	if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid turf.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, TurfInfo[turfid][tHeightX], TurfInfo[turfid][tHeightY], TurfInfo[turfid][tHeightZ]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:removeturf(playerid, params[])
{
	new turfid;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", turfid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeturf [turfid]");
	}
	if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid turf.");
	}

	GangZoneDestroy(TurfInfo[turfid][tGangZone]);
	DestroyDynamicArea(TurfInfo[turfid][tArea]);
	DestroyDynamicPickup(TurfInfo[turfid][tPickup]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM turfs WHERE id = %i", turfid);
	mysql_tquery(connectionID, queryBuffer);

	TurfInfo[turfid][tExists] = 0;
	TurfInfo[turfid][tCapturedGang] = 0;
    TurfInfo[turfid][tType] = 0;
    Iter_Remove(Turf, turfid);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed turf %i.", turfid);
	return 1;
}

CMD:editturf(playerid, params[])
{
	new turfid, option[14], param[32];

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[14]S()[32]", turfid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [option]");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Name, CapturedBy, Gang, Type, Time, Count, Height");
	    return 1;
	}
	if(!(0 <= turfid < MAX_TURFS) || !TurfInfo[turfid][tExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid turf.");
	}

 	if(!strcmp(option, "name", true))
    {
        if(isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [name] [text]");
		}

		strcpy(TurfInfo[turfid][tName], param, 32);
		ReloadTurf(turfid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET name = '%e' WHERE id = %i", TurfInfo[turfid][tName], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the name of turf %i to %s.", GetRPName(playerid), turfid, param);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the name of turf %i to {F7A763}%s{33CCFF}.", turfid, param);
	}
	else if(!strcmp(option, "capturedby", true))
    {
        if(isnull(param) || strlen(params) > 24)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [capturedby] [name]");
		}

		strcpy(TurfInfo[turfid][tCapturedBy], param, MAX_PLAYER_NAME);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedby = '%e' WHERE id = %i", TurfInfo[turfid][tCapturedBy], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the capturer of turf %i to %s.", GetRPName(playerid), turfid, param);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the capturer of turf %i to {F7A763}%s{33CCFF}.", turfid, param);
	}

 	else if(!strcmp(option, "gang", true))
    {
        new gangid;

        if(sscanf(param, "i", gangid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [gang] [gangid (-1 = none)]");
		}
		if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		}

		TurfInfo[turfid][tCapturedGang] = gangid;
		ReloadTurf(turfid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedgang = %i WHERE id = %i", TurfInfo[turfid][tCapturedGang], turfid);
		mysql_tquery(connectionID, queryBuffer);

		if(gangid == -1)
		{
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset the capturing gang of turf %i.", GetRPName(playerid), turfid);
			SendClientMessageEx(playerid, COLOR_AQUA, "You have reset the capturing gang of turf %i.", turfid);
		}
		else
		{
			SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the capturing gang of turf %i to %s.", GetRPName(playerid), turfid, GangInfo[gangid][gName]);
			SendClientMessageEx(playerid, COLOR_AQUA, "You have set the capturing gang of turf %i to {00AA00}%s{33CCFF}.", turfid, GangInfo[gangid][gName]);
		}
	}
	else if(!strcmp(option, "type", true))
    {
        new type;

        if(sscanf(param, "i", type))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [type] [value]");
			new string[128], finalsend = 0;
			string = "List of types: ";
			for(new i=0; i<sizeof(TurfType);i++)
			{
				format(string, sizeof(string), "%s (%i) %s", string, i, TurfType[i][TurfType_Name]);
				finalsend = 1;
				if(i%5 == 0 && i != 0)
				{
					SendClientMessage(playerid, COLOR_SYNTAX, string);
					string = "List of types: ";
					finalsend = 0;
				}
			}
			if(finalsend)
			{
				SendClientMessage(playerid, COLOR_SYNTAX, string);
			}			
           	return 1;
		}
		if(!(0 <= type < sizeof(TurfType)))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

		TurfInfo[turfid][tType] = type;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET type = %i WHERE id = %i", TurfInfo[turfid][tType], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the type of turf %i to %i.", GetRPName(playerid), turfid, type);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the type of turf %i to %i.", turfid, type);
	}
	else if(!strcmp(option, "time", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [time] [hours (0-20)]");
		}
		if(!(0 <= value <= 20))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The amount of hours must range from 0 to 20.");
		}

		TurfInfo[turfid][tTime] = value;

		if(TurfInfo[turfid][tTime] == 0 && TurfInfo[turfid][tType] != LOCKED_TURF_TYPE)
		{
		    SendTurfMessage(turfid, COLOR_YELLOW, "Turf wars: %s is now available to capture.", TurfInfo[turfid][tName]);
		}
		else
		{
		    TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
		    TurfInfo[turfid][tCaptureTime] = 0;
		}

		ReloadTurf(turfid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET time = %i WHERE id = %i", TurfInfo[turfid][tTime], turfid);
		mysql_tquery(connectionID, queryBuffer);

		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the time of turf %i to %i hours.", GetRPName(playerid), turfid, value);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the time of turf %i to %i hours.", turfid, value);
	}
	else if(!strcmp(option, "count", true))
    {
        new count;
        if(sscanf(param, "i", count))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [count] [0-10]");
		}
		if(!(0 <= count <= 10))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The amount of members must range from 0 to 10.");
		}
		TurfInfo[turfid][tCount] = count;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET count = %i WHERE id = %i", TurfInfo[turfid][tCount], turfid);
		mysql_tquery(connectionID, queryBuffer);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set the count members of turf %i to %i.", GetRPName(playerid), turfid, count);
		SendClientMessageEx(playerid, COLOR_AQUA, "You have set the count members of turf %i to %i.", turfid, count);
	}
	else if(!strcmp(option, "height", true))
    {
        if(strcmp(param, "confirm", true))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editturf [turfid] [height] [confirm]");
		}
		GetPlayerPos(playerid, TurfInfo[turfid][tHeightX], TurfInfo[turfid][tHeightY], TurfInfo[turfid][tHeightZ]);
		TurfInfo[turfid][tHeightInterior] = GetPlayerInterior(playerid);
		TurfInfo[turfid][tHeightVirtualWorld] = GetPlayerVirtualWorld(playerid);		        
		
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET heightx = '%f', heighty = '%f',heightz = '%f',heightinterior = '%d',heightvirtualworld = '%d' WHERE id = %i", 
										TurfInfo[turfid][tHeightX], TurfInfo[turfid][tHeightY], TurfInfo[turfid][tHeightZ], TurfInfo[turfid][tHeightInterior], TurfInfo[turfid][tHeightVirtualWorld], turfid);
		mysql_tquery(connectionID, queryBuffer);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has change the turf height location of turf %i.", GetRPName(playerid), turfid);
		SendClientMessageEx(playerid, COLOR_AQUA, "You changed the turf height location of turf %i.", turfid);
	}
	return 1;
}


CMD:claim(playerid, params[])
{
	new turfid, count;
	new diff = gettime() - LastClaimGlobal;

	if (diff < CLAIM_COOLDOWN)
	{
	    new remaining = CLAIM_COOLDOWN - diff;
	    SendClientMessageEx(playerid, COLOR_GREY, "You must wait %d seconds before another turf can be claimed.", remaining);
	    return 1;
	}
    if((PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 4) && !IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not rank 4+ in a gang or apart of law enforcement.");
	}
	if((turfid = GetNearbyTurfPoint(playerid)) == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any turfs point which you can claim.");
	}
	if(IsLawEnforcement(playerid) && PlayerData[playerid][pGang] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're not allowed to claim turfs as a law enforcer and a gang member.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't claim a turf while injured.");
	}
	if(TurfInfo[turfid][tTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This turf is not yet available to claim.");
	}
	if(TurfInfo[turfid][tType] == LOCKED_TURF_TYPE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This is a locked turf and therefore cannot be claimed.");
	}
	if(TurfInfo[turfid][tCapturer] == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This turf is already being captured by you.");
	}
	if(!IsLawEnforcement(playerid) && GangClaimingTurfs(PlayerData[playerid][pGang]) >= GetMaxTurfCap())
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're gang is already claiming %i turfs.", GetMaxTurfCap());
	}
	if(!IsLawEnforcement(playerid) && TurfInfo[turfid][tCapturer] != INVALID_PLAYER_ID && PlayerData[TurfInfo[turfid][tCapturer]][pGang] == PlayerData[playerid][pGang])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This turf is already being claimed by your gang.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
	}
	/*if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't claim a turf inside an interior.");
	}*/

    new turfs_count = 0;

    for(new x = 0; x < MAX_TURFS; x++)
	{
		if(turfid != x && TurfInfo[x][tExists] && TurfInfo[x][tCapturer] != INVALID_PLAYER_ID && TurfInfo[x][tTime] == 0)
		{
			turfs_count++;
		}
	}

    if(turfs_count >= 1)
    {
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can't claim this turf as there is another ones under-attack.");
    }
    new capturerid = TurfInfo[turfid][tCapturer];

	if(capturerid != INVALID_PLAYER_ID && TurfInfo[turfid][tTime] == 0)
	{
		foreach(new i : Player)
		{
		    if(i != playerid && GetNearbyTurf(i) == turfid && !PlayerData[i][pInjured] && !PlayerData[i][pAdminDuty] && !PlayerData[i][pAcceptedHelp] && !IsPlayerAFK(i) && GetPlayerState(i) != PLAYER_STATE_SPECTATING)
 			{
                if(IsPlayerNearPoint(i, 50.0, TurfInfo[turfid][tHeightX], TurfInfo[turfid][tHeightY], TurfInfo[turfid][tHeightZ]))
                {
                    if(PlayerData[capturerid][pGang] >= 0 && PlayerData[i][pGang] == PlayerData[capturerid][pGang] && !IsPlayerGangAlliance(i, playerid))
                    { 
                        return SendClientMessage(playerid, COLOR_GREY, "You must eliminate all members of the attacking gang before you can claim this.");
                    }
                    else if(IsLawEnforcement(capturerid) && IsLawEnforcement(i))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You must eliminate all LEO in this turf before you can claim this.");
                    }

                }
			}
		}
	}

	if(PlayerData[playerid][pGang] >= 0)
	{
	    if(GangInfo[PlayerData[playerid][pGang]][gTurfTokens] <= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have any turf tokens left.");
		}
 	    foreach(new i : Player)
	    {
	        if(GetNearbyTurf(i) == turfid && PlayerData[i][pGang] == PlayerData[playerid][pGang])
	        {
	            count++;
			}
		}

		if(count < TurfInfo[turfid][tCount])
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "You need at least %d members of your gang in this turf to claim it.", TurfInfo[turfid][tCount]);
		}
		else
		{
			GangInfo[PlayerData[playerid][pGang]][gTurfTokens]--;
			SendClientMessageToAllEx(COLOR_YELLOW, "Turf wars: %s has attempted to claim %s for %s. It will be their turf in 10 minutes!", GetRPName(playerid), TurfInfo[turfid][tName], GangInfo[PlayerData[playerid][pGang]][gName]);
            TurfInfo[turfid][tBeingCaptured] = true;
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET turftokens = turftokens - 1 WHERE id = %i", PlayerData[playerid][pGang]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	else if(IsLawEnforcement(playerid) && PlayerData[playerid][pGang] == -1)
	{
	    if(FactionInfo[PlayerData[playerid][pFaction]][fTurfTokens] <= 0)
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "Your faction doesn't have any turf tokens left.");
		}

	    FactionInfo[PlayerData[playerid][pFaction]][fTurfTokens]--;
	    SendClientMessageToAllEx(COLOR_YELLOW, "Turf wars: %s has attempted to claim back %s. It will be their turf in 10 minutes!", GetRPName(playerid), TurfInfo[turfid][tName]);
        TurfInfo[turfid][tBeingCaptured] = true;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_FACTIONS" SET turftokens = turftokens - 1 WHERE id = %i", PlayerData[playerid][pFaction]);
		mysql_tquery(connectionID, queryBuffer);
	}

	TurfInfo[turfid][tCapturer] = playerid;
	TurfInfo[turfid][tCaptureTime] = 10;
	ReloadTurf(turfid);

	return 1;
}

CMD:reclaim(playerid, params[])
{
	new turfid;

    if(PlayerData[playerid][pGang] == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if((turfid = GetNearbyTurfPoint(playerid)) == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any turfs.");
	}
	if(IsLawEnforcement(playerid) && PlayerData[playerid][pGang] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're not allowed to claim turfs as a law enforcer and a gang member.");
	}
	if(PlayerData[playerid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't reclaim a turf while injured.");
	}
	if(TurfInfo[turfid][tCapturedGang] != PlayerData[playerid][pGang])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This turf does not belong to your gang. Therefore you can't reclaim it.");
	}
	if(TurfInfo[turfid][tType] == LOCKED_TURF_TYPE)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This is a locked turf and therefore cannot be claimed.");
	}
	if(TurfInfo[turfid][tCapturer] == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This turf is not being claimed by anyone. Therefore you can't reclaim it.");
	}

 	if(TurfInfo[turfid][tCapturer] != INVALID_PLAYER_ID && TurfInfo[turfid][tTime] == 0)
	{
		foreach(new i : Player)
		{
		    if(i != playerid && GetNearbyTurf(i) == turfid && !PlayerData[i][pInjured] && !PlayerData[i][pAdminDuty] && !PlayerData[i][pAcceptedHelp] && !IsPlayerAFK(i) && GetPlayerState(i) != PLAYER_STATE_SPECTATING)
 			{
			    if(PlayerData[TurfInfo[turfid][tCapturer]][pGang] >= 0 && PlayerData[i][pGang] == PlayerData[TurfInfo[turfid][tCapturer]][pGang] && PlayerData[i][pGang] != GangInfo[PlayerData[playerid][pGang]][gAlliance])
			    {
					return SendClientMessage(playerid, COLOR_GREY, "You must eliminate all members of the attacking gang before you can claim this.");
			    }
			    else if(IsLawEnforcement(TurfInfo[turfid][tCapturer]) && IsLawEnforcement(i))
			    {
      				return SendClientMessage(playerid, COLOR_GREY, "You must eliminate all LEO in this turf before you can claim this.");
			    }
			}
		}
	}

	SendTurfMessage(turfid, COLOR_YELLOW, "Turf wars: %s has reclaimed %s for %s and ended the turf war.", GetRPName(playerid), TurfInfo[turfid][tName], GangInfo[PlayerData[playerid][pGang]][gName]);
    TurfInfo[turfid][tBeingCaptured] = false;
	TurfInfo[turfid][tCapturer] = INVALID_PLAYER_ID;
	TurfInfo[turfid][tCaptureTime] = 0;
	ReloadTurf(turfid);

	return 1;
}