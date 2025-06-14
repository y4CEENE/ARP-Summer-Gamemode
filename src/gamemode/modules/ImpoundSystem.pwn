#include <YSI\y_hooks>

#define MAX_IMPOUND_LOTS            100
#define TABLE_IMPOUND        "impoundlots"

enum impoundData {
	impoundID,
	impoundExists,
	Float:impoundLot[3],
	Float:impoundRelease[4],
	Text3D:impoundText3D,
	impoundPickup
};

static ImpoundData[MAX_IMPOUND_LOTS][impoundData];

hook OnLoadGameMode(timestamp)
{    
    CreateDynamic3DTextLabel("DMV\n /dmvrelease to\nrelease your car.", COLOR_YELLOW, -2026.9712, -114.4729, 1035.1719, 10.0);
    CreateDynamicPickup(1239, 1, -2026.9712, -114.4729, 1035.1719);
    return 1;
}

hook OnLoadDatabase(timestamp)
{
    mysql_tquery(connectionID, "SELECT * FROM "#TABLE_IMPOUND, "db_Impound_Load", "");
    return 1;
}

DB:Impound_Load()
{
	static rows, fields;

	cache_get_data(rows, fields, connectionID);

	for (new i = 0; i < rows; i ++)
    {
        if (i < MAX_IMPOUND_LOTS)
        {
            ImpoundData[i][impoundExists] = true;
            ImpoundData[i][impoundID] = cache_get_field_content_int(i, "impoundID");
            ImpoundData[i][impoundLot][0] = cache_get_field_content_float(i, "impoundLotX");
            ImpoundData[i][impoundLot][1] = cache_get_field_content_float(i, "impoundLotY");
            ImpoundData[i][impoundLot][2] = cache_get_field_content_float(i, "impoundLotZ");
            ImpoundData[i][impoundRelease][0] = cache_get_field_content_float(i, "impoundReleaseX");
            ImpoundData[i][impoundRelease][1] = cache_get_field_content_float(i, "impoundReleaseY");
            ImpoundData[i][impoundRelease][2] = cache_get_field_content_float(i, "impoundReleaseZ");
            ImpoundData[i][impoundRelease][3] = cache_get_field_content_float(i, "impoundReleaseA");

            Impound_Refresh(i);
        }
    }
	return 1;
}

stock Impound_Refresh(impoundid)
{
	if (impoundid != -1 && ImpoundData[impoundid][impoundExists])
	{
		if (IsValidDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]))
        {
		    DestroyDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]);
        }

	    if (IsValidDynamicPickup(ImpoundData[impoundid][impoundPickup]))
        {
		    DestroyDynamicPickup(ImpoundData[impoundid][impoundPickup]);
        }

	    new string[64];
		format(string, sizeof(string), "[Impound %d]\n{FFFFFF}/impound to impound a vehicle.", impoundid);
        ImpoundData[impoundid][impoundText3D] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundData[impoundid][impoundLot][0], ImpoundData[impoundid][impoundLot][1], ImpoundData[impoundid][impoundLot][2], 20.0);
        ImpoundData[impoundid][impoundPickup] = CreateDynamicPickup(1239, 23, ImpoundData[impoundid][impoundLot][0], ImpoundData[impoundid][impoundLot][1], ImpoundData[impoundid][impoundLot][2]);
	}
	return 1;
}

stock Impound_Create(Float:x, Float:y, Float:z)
{
	for (new i = 0; i != MAX_IMPOUND_LOTS; i ++) if (!ImpoundData[i][impoundExists])
	{
	    ImpoundData[i][impoundExists] = true;
	    ImpoundData[i][impoundLot][0] = x;
	    ImpoundData[i][impoundLot][1] = y;
	    ImpoundData[i][impoundLot][2] = z;
	    ImpoundData[i][impoundRelease][0] = 0.0;
	    ImpoundData[i][impoundRelease][1] = 0.0;
	    ImpoundData[i][impoundRelease][2] = 0.0;

		mysql_tquery(connectionID, "INSERT INTO "#TABLE_IMPOUND" (impoundLotX) VALUES('0.0')", "db_OnImpoundCreated", "d", i);
		Impound_Refresh(i);

		return i;
	}
	return -1;
}

DB:OnImpoundCreated(impoundid)
{
	if (impoundid == -1 || !ImpoundData[impoundid][impoundExists])
    {
	    return 1;
    }

	ImpoundData[impoundid][impoundID] = cache_insert_id(connectionID);
	Impound_Save(impoundid);
	return 1;
}

stock Impound_Save(impoundid)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
        "UPDATE "#TABLE_IMPOUND" SET impoundLotX = '%.4f', impoundLotY = '%.4f', impoundLotZ = '%.4f',\
        impoundReleaseX = '%.4f', impoundReleaseY = '%.4f', impoundReleaseZ = '%.4f', impoundReleaseA = '%.4f'\
        WHERE impoundID = '%d'",
        ImpoundData[impoundid][impoundLot][0],
        ImpoundData[impoundid][impoundLot][1],
        ImpoundData[impoundid][impoundLot][2],
        ImpoundData[impoundid][impoundRelease][0],
        ImpoundData[impoundid][impoundRelease][1],
        ImpoundData[impoundid][impoundRelease][2],
        ImpoundData[impoundid][impoundRelease][3],
        ImpoundData[impoundid][impoundID]
	);
	return mysql_tquery(connectionID, queryBuffer);
}

stock Impound_Delete(impoundid)
{
	if (impoundid == -1 || !ImpoundData[impoundid][impoundExists])
    {
	    return 1;
    }


    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),  "DELETE FROM `"#TABLE_IMPOUND"` WHERE `impoundID` = '%d'", ImpoundData[impoundid][impoundID]);
    mysql_tquery(connectionID, queryBuffer);

    ImpoundData[impoundid][impoundExists] = false;
    ImpoundData[impoundid][impoundID] = 0;

    if (IsValidDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]))
    {
        DestroyDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]);
    }

    if (IsValidDynamicPickup(ImpoundData[impoundid][impoundPickup]))
    {
        DestroyDynamicPickup(ImpoundData[impoundid][impoundPickup]);
    }
	return 1;
}

stock GetNearbyImpound(playerid)
{
	for (new i = 0; i < MAX_IMPOUND_LOTS; i ++)
    {
        if (ImpoundData[i][impoundExists] && 
            IsPlayerInRangeOfPoint(playerid, 20.0, ImpoundData[i][impoundLot][0], ImpoundData[i][impoundLot][1], ImpoundData[i][impoundLot][2]))
        {
            return i;
        }
    }
	return -1;
}

CMD:createimpound(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

	if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
 		return SendErrorMessage(playerid, "You can only create impound lots outside interiors.");
    }

	new impoundid = -1, Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);

	impoundid = Impound_Create(x, y, z);

	if (impoundid == -1)
    {
	    SendErrorMessage(playerid, "The server has reached the limit for impound lots.");
    }
    else
    {
	    SendInfoMessage(playerid, "You have successfully created impound lot ID: %d.", impoundid);
    }

	return 1;
}

CMD:removeimpound(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    new impoundid;

	if (sscanf(params, "d", impoundid))
    {
	    return SendClientMessageEx(playerid, COLOR_GREY, "/destroyimpound [impound id]");
    }

	if ((impoundid < 0 || impoundid >= MAX_IMPOUND_LOTS) || !ImpoundData[impoundid][impoundExists])
    {
	    return SendErrorMessage(playerid, "You have specified an invalid impound lot ID.");
    }

	Impound_Delete(impoundid);
	SendInfoMessage(playerid, "You have successfully removed impound lot ID: %d.", impoundid);
	return 1;
}

CMD:gotoimpound(playerid, params[])
{
    if(!IsAdmin(playerid, 2))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

	new impoundid;
	if (sscanf(params, "d", impoundid))
 	{
	 	SendClientMessageEx(playerid, COLOR_GREY, "/gotoimpound [impoundid]");
		return 1;
	}

	if ((impoundid < 0 || impoundid >= MAX_IMPOUND_LOTS) || !ImpoundData[impoundid][impoundExists])
    {
	    return SendErrorMessage(playerid, "You have specified an invalid impound lot ID.");
    }

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, ImpoundData[impoundid][impoundLot][0], ImpoundData[impoundid][impoundLot][1], ImpoundData[impoundid][impoundLot][2]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:editimpound(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

	new impoundid, type[24];
	if (sscanf(params, "ds[24]", impoundid, type))
 	{
	 	SendClientMessageEx(playerid, COLOR_GREY, "/editimpound [impoundid] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, release");
		return 1;
	}

	if ((impoundid < 0 || impoundid >= MAX_IMPOUND_LOTS) || !ImpoundData[impoundid][impoundExists])
    {
	    return SendErrorMessage(playerid, "You have specified an invalid impound lot ID.");
    }

	if (!strcmp(type, "location", true))
	{
	    static Float:x, Float:y, Float:z;

	    GetPlayerPos(playerid, x, y, z);

		ImpoundData[impoundid][impoundLot][0] = x;
		ImpoundData[impoundid][impoundLot][1] = y;
		ImpoundData[impoundid][impoundLot][2] = z;

		Impound_Refresh(impoundid);
		Impound_Save(impoundid);

		SendAdminMessage(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of impound ID: %d.", GetRPName(playerid), impoundid);
	}
	else if (!strcmp(type, "release", true))
	{
	    static Float:x, Float:y, Float:z, Float:angle;

	    GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		ImpoundData[impoundid][impoundRelease][0] = x;
		ImpoundData[impoundid][impoundRelease][1] = y;
		ImpoundData[impoundid][impoundRelease][2] = z;
		ImpoundData[impoundid][impoundRelease][3] = angle;

		Impound_Save(impoundid);
		SendAdminMessage(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the release point of impound ID: %d.", GetRPName(playerid), impoundid);
	}
	return 1;
}

CMD:impound(playerid, params[])
{
	new price,
		impoundid = GetNearbyImpound(playerid),
		vehicleid = GetPlayerVehicleID(playerid);

    if (!PlayerHasJob(playerid, JOB_MECHANIC) && GetPlayerFaction(playerid) != FACTION_POLICE)
    {
		return SendErrorMessage(playerid, "You must be a police officer or mechanic.");
    }

    if (sscanf(params, "d", price))
    {
        return SendClientMessage(playerid, COLOR_GREY, "/impound [price]");
    }

	if (price < 1 || price > 1500)
    {
	    return SendErrorMessage(playerid, "The price can't be above $1,500 or below $1.");
    }

	if (GetVehicleModel(vehicleid) != 525)
    {
	    return SendErrorMessage(playerid, "You are not driving a tow truck.");
    }

	if (impoundid == -1)
    {
	    return SendErrorMessage(playerid, "You are not in range of any impound lot.");
    }

	if (!GetVehicleTrailer(vehicleid))
    {
	    return SendErrorMessage(playerid, "There is no vehicle hooked.");
    }

 	new	trailerid = GetVehicleTrailer(vehicleid);

	if (trailerid == -1)
    {
	    return SendErrorMessage(playerid, "You can't tow this vehicle.");
    }

	if(VehicleInfo[trailerid][carImpounded] == 1)
	{
	    return SendErrorMessage(playerid, "This vehicle is already impounded.");
	}
	if(!IsValidVehicle(trailerid) || !VehicleInfo[trailerid][vID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
	}
    if(!VehicleInfo[trailerid][vOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only impound player's owned vehicles.");
	}
	
	foreach(new i : Player)
	{
		if(GetPlayerFaction(i) == FACTION_POLICE || i == playerid)
		{
			if(GetPlayerFaction(playerid) == FACTION_POLICE)
			{
				SendClientMessageEx(i, COLOR_ROYALBLUE, "> Dispatch: %s %s has impounded a %s with %s unpaid tickets.", 
                   FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), 
                   GetVehicleName(trailerid), FormatCash(VehicleInfo[trailerid][vTickets]));
			}
			else
			{
				SendClientMessageEx(i, COLOR_ROYALBLUE, "> Dispatch: Mechanic %s has impounded a %s with %s unpaid tickets.", 
                    GetRPName(playerid), GetVehicleName(trailerid), FormatCash(VehicleInfo[trailerid][vTickets]));
			}
		}
	}

	VehicleInfo[trailerid][carImpounded] = 1;
	VehicleInfo[trailerid][carImpoundPrice] = price;

	AddToTaxVault(price);

 	VehicleInfo[trailerid][vPosX] = ImpoundData[impoundid][impoundRelease][0];
	VehicleInfo[trailerid][vPosY] = ImpoundData[impoundid][impoundRelease][1];
	VehicleInfo[trailerid][vPosZ] = ImpoundData[impoundid][impoundRelease][2];

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f',\
                                  pos_a = '%f', interior = %i, world = %i, carimpounded = 1, carimpoundprice = %i WHERE id = %i",
                                  VehicleInfo[trailerid][vPosX], VehicleInfo[trailerid][vPosY], VehicleInfo[trailerid][vPosZ],
                                  VehicleInfo[trailerid][vPosA], VehicleInfo[trailerid][vInterior], VehicleInfo[trailerid][vWorld],
                                  VehicleInfo[trailerid][carImpoundPrice], VehicleInfo[trailerid][vID]);
	mysql_tquery(connectionID, queryBuffer);

 	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
    DespawnVehicle(trailerid);
	return 1;
}

CMD:dmvrelease(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2026.9712, -114.4729, 1035.1719))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not at the desk in the Licensing Department.");
	}
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE ownerid = %i AND carimpounded = 1", PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer, "db_DMVRelease", "i", playerid);
	return 1;
}


DB:DMVRelease(playerid)
{
    new rows = cache_get_row_count(connectionID);

	if(!rows)
	{
		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You do not have any impounded vehicles.");
	}
    new impoundPrice, tickets;
	new string[2048];

	string = "Model\tTickets\tImpound Price\tTotal to pay";
	for(new i = 0; i < rows; i ++)
    {
        tickets = cache_get_field_content_int(i, "tickets");
        impoundPrice = cache_get_field_content_int(i, "carImpoundPrice");
                
		format(string, sizeof(string), "%s\n[#%i] %s\t{ff0000}%s{ffffff}\t{ff0000}%s{ffffff}\t{ff0000}%s{ffffff}",
            string,
            i + 1,
            GetVehicleNameByModel(cache_get_field_content_int(i, "modelid")),
            FormatCash(tickets),
            FormatCash(impoundPrice),
            FormatCash(tickets+impoundPrice));
    }
    
    Dialog_Show(playerid, DMVRelease, DIALOG_STYLE_TABLIST_HEADERS, "Impound Department", string, "Release", "Cancel");
	return 1;
}

Dialog:DMVRelease(playerid, response, listitem, inputtext[])
{
	if(response && listitem >= 0)
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE ownerid = %i AND carImpounded = 1 LIMIT %i, 1", PlayerData[playerid][pID], listitem);
		mysql_tquery(connectionID, queryBuffer, "db_OnPlayerDMVRelease", "i", playerid);
	}
	return 1;
}

DB:OnPlayerDMVRelease(playerid)
{
	new cash = cache_get_field_content_int(0, "tickets") + cache_get_field_content_int(0, "carImpoundPrice");

	if(PlayerData[playerid][pCash] < cash)
	{
		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You need %s to release this impounded vehicle.", FormatNumber(cash));
	}

    if(PlayerData[playerid][pWantedLevel] != 0)
    {
        foreach(new i : Player)
        {
            if(GetPlayerFaction(i) == FACTION_POLICE)
            {
                SendClientMessageEx(i, COLOR_ROYALBLUE, "> Dispatch: Wanted %s tried to release his %s from DMV.",
                    GetRPName(playerid), 
                    GetVehicleNameByModel(cache_get_field_content_int(0, "modelid")));                
            }
        }
        return SendClientMessageEx(playerid, COLOR_YELLOW, "The police has been warned that you are wanted, and are on their way.");
    }
	GivePlayerCash(playerid, -cash);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET carImpounded = '0', tickets = '0' WHERE id = %i", cache_get_field_content_int(0, "id"));
	mysql_tquery(connectionID, queryBuffer);
	SendClientMessageEx(playerid, COLOR_GREY, "You have paid %s to release your %s...", FormatCash(cash), GetVehicleNameByModel(cache_get_field_content_int(0, "modelid")));
	return 1;
}
