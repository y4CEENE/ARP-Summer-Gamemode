/// @file      MainParking.pwn
/// @author    ARP
/// @date      Created at 2021-03-31 15:18:30 +0100
/// @copyright Copyright (c) 2022

#include <YSI_Coding\y_hooks>

static Float:ParkingGetCarPosition[][] = {{1232.1295, -1308.2200, 13.5124}, {-2035.0459, 307.3203, 35.6635}, {1626.1976,-1137.2291,23.9063}};
static Float:ParkingSpawnPosition [][] = {{1230.8282, -1299.5665, 13.0709}, {-2029.4335, 290.6786, 35.1635}, {1626.2640,-1128.4218,23.6218}};


static ParkingSpawnTimer=0;

hook OnGameModeInit()
{
    for(new index=0;index<sizeof(ParkingGetCarPosition);index++)
    {
        CreateDynamicPickup(1239, 23, ParkingGetCarPosition[index][0], ParkingGetCarPosition[index][1], ParkingGetCarPosition[index][2], -1);
        CreateDynamic3DTextLabel("Type /getmycar\n to get your car here\nFees: $500", COLOR_YELLOW, ParkingGetCarPosition[index][0], ParkingGetCarPosition[index][1], ParkingGetCarPosition[index][2] + 0.5, 4.0);    
    }
}

GetNearestParkingID(playerid)
{
    for(new index=0;index<sizeof(ParkingGetCarPosition);index++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, ParkingGetCarPosition[index][0], ParkingGetCarPosition[index][1], ParkingGetCarPosition[index][2]))
        {
            return index;
        }
    }
    return -1;
}

CMD:getmycar(playerid, params[])
{
    if(PlayerData[playerid][pAdminDuty] == 1)
    {
       return SendClientMessage(playerid,COLOR_WHITE, "You can't use this command while on-duty as admin.");
    }

    if(GetNearestParkingID(playerid) == -1)
    {
        return SendClientMessage(playerid, COLOR_WHITE, "You are not in a parking.");
    }

    if(ParkingSpawnTimer>0)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You need to wait %dsec before spawning a car.", ParkingSpawnTimer);
    }

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer, "db_OnMainParkingMenu", "i",  playerid);
    return 1;
}


DB:OnMainParkingMenu(playerid)
{
	new rows = cache_get_row_count(connectionID);

    if(!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "You own no vehicles which you can spawn.");
    }
    else
    {
        new string[1024], vehicleid;

        string = "Model\tStatus\tLocation\tTickets";

        for(new i = 0; i < rows; i ++)
        {
            if(cache_get_field_content_int(i, "carImpounded")) 
            {
                format(string, sizeof(string), "%s\n[#%i] %s\t{FF6347}Impounded{FFFFFF}\t%s\t%s", 
                    string,
                    i + 1,
                    GetVehicleNameByModel(cache_get_field_content_int(i, "modelid")),
                    (cache_get_field_content_int(i, "world")) ? ("Garage") : (GetZoneName(cache_get_field_content_float(i, "pos_x"), cache_get_field_content_float(i, "pos_y"), cache_get_field_content_float(i, "pos_z"))),
                    FormatCash(cache_get_field_content_int(i, "tickets") + cache_get_field_content_int(i, "carImpoundPrice")));
            }
            else if((vehicleid = GetVehicleLinkedID(cache_get_field_content_int(i, "id"))) != INVALID_VEHICLE_ID)
            {
                format(string, sizeof(string), "%s\n[#%i] %s\t{00AA00}Spawned{FFFFFF}\t%s\t%s",
                    string,
                    i + 1,
                    GetVehicleNameByModel(GetVehicleModel(vehicleid)),
                    GetVehicleZoneName(vehicleid),
                    FormatCash(cache_get_field_content_int(i, "tickets")));
            }
            else
            {
                format(string, sizeof(string), "%s\n[#%i] %s\t{FF6347}Despawned{FFFFFF}\t%s\t%s",
                    string,
                    i + 1,
                    GetVehicleNameByModel(cache_get_field_content_int(i, "modelid")),
                    (cache_get_field_content_int(i, "world")) ? ("Garage") : (GetZoneName(cache_get_field_content_float(i, "pos_x"), cache_get_field_content_float(i, "pos_y"), cache_get_field_content_float(i, "pos_z"))),
                    FormatCash(cache_get_field_content_int(i, "tickets")));
            }
        }
        Dialog_Show(playerid, MainParkingResponse, DIALOG_STYLE_TABLIST_HEADERS, "Choose a vehicle to (de)spawn.", string, "Select", "Cancel");
    }
    return 1;
}

Dialog:MainParkingResponse(playerid, response, listitem, inputtext[])
{
    if(response && listitem != -1)
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id,carImpounded FROM vehicles WHERE ownerid = %i LIMIT %i, 1", PlayerData[playerid][pID], listitem);
        mysql_tquery(connectionID, queryBuffer, "OnMainParkingUseCar", "i", playerid);
	}
	return 1;
}


forward OnMainParkingUseCar(playerid);
public OnMainParkingUseCar(playerid)
{
	new vehicleid = GetVehicleLinkedID(cache_get_field_content_int(0, "id"));
    
    if(cache_get_field_content_int(0, "carImpounded"))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is impounded. You must pay the tickets in DMV.");
    }

    if(ParkingSpawnTimer>0)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You need to wait %dsec before spawning a car.", ParkingSpawnTimer);
    }

	if(vehicleid != INVALID_VEHICLE_ID)
	{
        if(IsVehicleBeingPicked(vehicleid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle is being broken into!");
        }
        else
        {
           DespawnVehicle(vehicleid);
		}
	}
	
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM vehicles WHERE id = %i AND ownerid = %i", cache_get_field_content_int(0, "id"), PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer, "OnParkingSpawnVehicle", "ii", playerid, false);
    return 1;
}


forward OnParkingSpawnVehicle(playerid, parked);
public OnParkingSpawnVehicle(playerid, parked)
{
	if(!cache_get_row_count(connectionID))
	{
	    SendClientMessage(playerid, COLOR_GREY, "The slot specified contains no valid vehicle which you can spawn.");
	}
	else
	{
        if(ParkingSpawnTimer>0)
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "You need to wait %dsec before spawning a car.", ParkingSpawnTimer);
        }
        ParkingSpawnTimer = 10;

	    if(GetVehicleLinkedID(cache_get_field_content_int(0, "id")) != INVALID_VEHICLE_ID)
     	{
      		return SendClientMessage(playerid, COLOR_GREY, "This vehicle is spawned already. /findcar to track it.");
	    }

	    if(GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES && PlayerData[playerid][pDonator] < 3)//vipveh
	    {
	        return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
	    }
        
        if(GetPlayerCash(playerid) < 500)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need $500 to get your car.");
        }

        GivePlayerCash(playerid, -500);
        
        SendClientMessage(playerid, COLOR_AQUA, "You paid $500 to get your car. You have 30 seconds to get your car.");
	    
        new
			modelid = cache_get_field_content_int(0, "modelid"),
			Float:x = cache_get_field_content_float(0, "pos_x"),
			Float:y = cache_get_field_content_float(0, "pos_y"),
			Float:z = cache_get_field_content_float(0, "pos_z"),
			Float:a = cache_get_field_content_float(0, "pos_a"),
			color1 = cache_get_field_content_int(0, "color1"),
			color2 = cache_get_field_content_int(0, "color2"),
			vehicleid;

        new parkingid = GetNearestParkingID(playerid);

        if(parkingid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Internal Error! Cannot get parking id.");
        }

		vehicleid = CreateVehicle(modelid, ParkingSpawnPosition[parkingid][0], ParkingSpawnPosition[parkingid][1], ParkingSpawnPosition[parkingid][2], 270.0000, color1, color2, -1);

		if(vehicleid != INVALID_VEHICLE_ID)
		{
		    ResetVehicle(vehicleid);

		    cache_get_field_content(0, "owner", VehicleInfo[vehicleid][vOwner], connectionID, MAX_PLAYER_NAME);
		    cache_get_field_content(0, "plate", VehicleInfo[vehicleid][vPlate], connectionID, 32);
		    VehicleInfo[vehicleid][vID] = cache_get_field_content_int(0, "id");
		    VehicleInfo[vehicleid][vOwnerID] = cache_get_field_content_int(0, "ownerid");
		    VehicleInfo[vehicleid][vPrice] = cache_get_field_content_int(0, "price");
		    VehicleInfo[vehicleid][vTickets] = cache_get_field_content_int(0, "tickets");
		    VehicleInfo[vehicleid][vLocked] = cache_get_field_content_int(0, "locked");
		    VehicleInfo[vehicleid][vHealth] = 1000.0;
		    VehicleInfo[vehicleid][vPaintjob] = cache_get_field_content_int(0, "paintjob");
		    VehicleInfo[vehicleid][vInterior] = cache_get_field_content_int(0, "interior");
	        VehicleInfo[vehicleid][vWorld] = cache_get_field_content_int(0, "world");
	        VehicleInfo[vehicleid][vNeon] = cache_get_field_content_int(0, "neon");
	        VehicleInfo[vehicleid][vNeonEnabled] = cache_get_field_content_int(0, "neonenabled");
	        VehicleInfo[vehicleid][vTrunk] = cache_get_field_content_int(0, "trunk");
	        VehicleInfo[vehicleid][vAlarm] = cache_get_field_content_int(0, "alarm");
	        VehicleInfo[vehicleid][vMods][0] = cache_get_field_content_int(0, "mod_1");
	        VehicleInfo[vehicleid][vMods][1] = cache_get_field_content_int(0, "mod_2");
	        VehicleInfo[vehicleid][vMods][2] = cache_get_field_content_int(0, "mod_3");
	        VehicleInfo[vehicleid][vMods][3] = cache_get_field_content_int(0, "mod_4");
	        VehicleInfo[vehicleid][vMods][4] = cache_get_field_content_int(0, "mod_5");
	        VehicleInfo[vehicleid][vMods][5] = cache_get_field_content_int(0, "mod_6");
	        VehicleInfo[vehicleid][vMods][6] = cache_get_field_content_int(0, "mod_7");
	        VehicleInfo[vehicleid][vMods][7] = cache_get_field_content_int(0, "mod_8");
	        VehicleInfo[vehicleid][vMods][8] = cache_get_field_content_int(0, "mod_9");
	        VehicleInfo[vehicleid][vMods][9] = cache_get_field_content_int(0, "mod_10");
	        VehicleInfo[vehicleid][vMods][10] = cache_get_field_content_int(0, "mod_11");
	        VehicleInfo[vehicleid][vMods][11] = cache_get_field_content_int(0, "mod_12");
	        VehicleInfo[vehicleid][vMods][12] = cache_get_field_content_int(0, "mod_13");
	        VehicleInfo[vehicleid][vMods][13] = cache_get_field_content_int(0, "mod_14");
	        VehicleInfo[vehicleid][vCash] = cache_get_field_content_int(0, "cash");
	        VehicleInfo[vehicleid][vMaterials] = cache_get_field_content_int(0, "materials");
	        VehicleInfo[vehicleid][vWeed] = cache_get_field_content_int(0, "weed");
	        VehicleInfo[vehicleid][vCocaine] = cache_get_field_content_int(0, "cocaine");
	        VehicleInfo[vehicleid][vHeroin] = cache_get_field_content_int(0, "heroin");
	        VehicleInfo[vehicleid][vPainkillers] = cache_get_field_content_int(0, "painkillers");
	        VehicleInfo[vehicleid][vWeapons][0] = cache_get_field_content_int(0, "weapon_1");
	        VehicleInfo[vehicleid][vWeapons][1] = cache_get_field_content_int(0, "weapon_2");
	        VehicleInfo[vehicleid][vWeapons][2] = cache_get_field_content_int(0, "weapon_3");
	        VehicleInfo[vehicleid][vWeapons][3] = cache_get_field_content_int(0, "weapon_4");
	        VehicleInfo[vehicleid][vWeapons][4] = cache_get_field_content_int(0, "weapon_5");
	        VehicleInfo[vehicleid][vGang] = -1;
	        VehicleInfo[vehicleid][vFaction] = -1;
	        VehicleInfo[vehicleid][vFGDivision] = -1;
	        VehicleInfo[vehicleid][vJob] = JOB_NONE;
	        VehicleInfo[vehicleid][vRespawnDelay] = -1;
	        VehicleInfo[vehicleid][vModel] = modelid;
		    VehicleInfo[vehicleid][vPosX] = x;
		    VehicleInfo[vehicleid][vPosY] = y;
		    VehicleInfo[vehicleid][vPosZ] = z;
		    VehicleInfo[vehicleid][vPosA] = a;
		    VehicleInfo[vehicleid][vColor1] = color1;
		    VehicleInfo[vehicleid][vColor2] = color2;
		    VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;
		    VehicleInfo[vehicleid][vTimer] = -1;
		    VehicleInfo[vehicleid][vRank] = 0;
		    VehicleInfo[vehicleid][carImpounded] = cache_get_field_content_int(0, "carImpounded");
		    VehicleInfo[vehicleid][carImpoundPrice] = cache_get_field_content_int(0, "carImpoundPrice");
            RefuelVehicle(vehicleid);
			adminVehicle{vehicleid} = false;

			VehicleInfo[vehicleid][vForSale] = bool:cache_get_field_content_int(0, "forsale");
			VehicleInfo[vehicleid][vForSalePrice] = cache_get_field_content_int(0, "forsaleprice");

			VehicleInfo[vehicleid][vMileage] = cache_get_field_content_float(0, "mileage");

			if(VehicleInfo[vehicleid][vForSale])
			{
				new forsale[264];
				format(forsale, sizeof(forsale), "FOR SALE\n%s - %s\nPh: %i.", GetVehicleName(vehicleid), FormatCash(VehicleInfo[vehicleid][vForSalePrice]), PlayerData[playerid][pPhone]);
                VehicleInfo[vehicleid][vForSaleLabel] = CreateDynamic3DTextLabel(forsale, COLOR_GREY2, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, vehicleid, 1, -1, 0, -1, 30.0);
 			}
            SetVehicleToRespawn(vehicleid);
			ReloadVehicle(vehicleid);


		    
	    }
        
	}

	return 1;
}

static VehicleParkingRespawnTimer[MAX_VEHICLES];

hook OnVehicleSpawn(vehicleid)
{
    VehicleParkingRespawnTimer[vehicleid] = 0;
    return 1;
}
hook OnServerHeartBeat(timestamp)
{
    if(ParkingSpawnTimer>0)
    {
        ParkingSpawnTimer--;
    }
}

hook OnServerBeacon(timestamp)
{
    new Float:x;
    new Float:y;
    new Float:z;

    for(new vehicleid=0;vehicleid<MAX_VEHICLES;vehicleid++)
    {
        if(!IsValidVehicle(vehicleid))
        {
            continue;
        }

        GetVehiclePos(vehicleid, x, y, z);

        new isCarNearParking = false;
        for(new index=0;index<sizeof(ParkingSpawnPosition);index++)
        {
            if(IsPointInRangeOfPoint(x, y, z, 30.0, ParkingSpawnPosition[index][0], ParkingSpawnPosition[index][1], ParkingSpawnPosition[index][2]))
            {
                isCarNearParking = true;
            }
        }

        if( !isCarNearParking || IsVehicleOccupied(vehicleid) || adminVehicle{vehicleid} || IsARentableCar(vehicleid))
        {
            VehicleParkingRespawnTimer[vehicleid] = 0;
            continue;
        }
        

        VehicleParkingRespawnTimer[vehicleid]++;

        if(VehicleParkingRespawnTimer[vehicleid] > 3)
        {
            VehicleParkingRespawnTimer[vehicleid] = 0;

            if(VehicleInfo[vehicleid][vOwnerID]>0)
            {
                new playerid = GetVehicleOwnerID(vehicleid);

                if(IsPlayerConnected(playerid))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You vehicle has been auto parked for leaving it near parking.");
                }
                DespawnVehicle(vehicleid);
            }
            else
            {
                SetVehicleToRespawn(vehicleid);
            }
        }
    }
    return 1;
}
