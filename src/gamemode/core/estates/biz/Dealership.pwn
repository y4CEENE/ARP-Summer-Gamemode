#include <YSI\y_hooks>
enum e_Dealership
{
	dcID,
	dcExists,
	dcCompany,
	dcModel,
	dcPrice,
	dcMaxSpeed[12],
	dcDoors[12],
	dcType[12]
};

//---- DealerShip
enum dsCoords{
	Float:dsPosX[2],
	Float:dsPosY[2],
	Float:dsPosZ[2],
	Float:dsPosA[2],
	dsInterior,
	dsWorld
};
static PlayerText: DSBox;
static PlayerText: DSModel;
static PlayerText: DSName;
static PlayerText: DSPrice;
static PlayerText: DSMaxSpeed;
static PlayerText: DSDoors;
static PlayerText: DSType;
static PlayerText: DSTest;
static PlayerText: DSBuy;
static PlayerText: DSCancel;
static PlayerText: DSPrev;
static PlayerText: DSNext;
static DSTimer[MAX_PLAYERS];
static DealerID[MAX_PLAYERS], VehicleDealer[MAX_PLAYERS], InDealer[MAX_PLAYERS],DSMenuEnabled[MAX_PLAYERS], Float:DSAngle[MAX_PLAYERS], DealerShipCarIndex[MAX_PLAYERS];
static DealershipCars[MAX_DEALERSHIP_CARS][e_Dealership];

IsInDealership(playerid)
{
    return (InDealer[playerid] != 0);
}

IsAtDealership(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 542.646179, -1290.295654, 17.242237) || IsPlayerInRangeOfPoint(playerid, 3.0, 1985.7753,-2068.1091,13.3803) || IsPlayerInRangeOfPoint(playerid, 3.0, 2131.8059,-1150.8885,24.1078))
	{
	    return 1;
	}
	return 0;
}

forward OnDealershipCarAdded(id);
public OnDealershipCarAdded(id)
{
	DealershipCars[id][dcID] = cache_insert_id(connectionID);

	SaveDealershipCar(id);
}
forward OnLoadDealershipCars();
public OnLoadDealershipCars()
{
    new
	    rows = cache_get_row_count(connectionID);

	for (new i = 0; i < rows; i ++)
	{
	    DealershipCars[i][dcExists] = 1;
	    DealershipCars[i][dcID] = cache_get_field_content_int(i, "ID");
	    DealershipCars[i][dcCompany] = cache_get_field_content_int(i, "Company");
	    DealershipCars[i][dcModel] = cache_get_field_content_int(i, "Model");
	    DealershipCars[i][dcPrice] = cache_get_field_content_int(i, "Price");		
		
	    cache_get_field_content(i, "maxspeed", DealershipCars[i][dcMaxSpeed], connectionID, 12);
		cache_get_field_content(i, "type", DealershipCars[i][dcType], connectionID, 12);
		cache_get_field_content(i, "doors", DealershipCars[i][dcDoors], connectionID, 12);
		
	}
}


stock GetDealerShipCarsIndex(company,index)
{
	for(new i = 0; i < sizeof(DealershipCars); i ++)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			models[index++] = DealershipCars[i][dcModel];
		}
	}
}
PurchaseVehicle(playerid)
{
	new item = PlayerData[playerid][pSelected];
    if(!PlayerCanAfford(playerid, DealershipCars[item][dcPrice]))
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't purchase this. You don't have enough money for it.");
    }
    else
    {
        new
            string[128];
		//DealershipCars[i][dcCompany] == BusinessInfo[company][bID])
		format(string, sizeof(string), "{FFD700}Confirmation:\nAre you sure you want to purchase this %s for {00AA00}$%i{FFD700}?", 
		GetVehicleNameByModel(DealershipCars[PlayerData[playerid][pSelected]][dcModel]), DealershipCars[PlayerData[playerid][pSelected]][dcPrice]);
		Dialog_Show(playerid, DIALOG_BUYVEHICLE2, DIALOG_STYLE_MSGBOX, "Purchase confirmation", string, "Yes", "No");
	}
}

ShowVehicleSelectionMenu(playerid, type)
{
	new
	    models[MAX_SELECTION_MENU_ITEMS] = {-1, ...},
	    index, company = GetInsideBusiness(playerid);

	for(new i = 0; i < sizeof(DealershipCars); i ++)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			models[index++] = DealershipCars[i][dcModel];
		}
	}
	ShowPlayerSelectionMenu(playerid, type, "Buy a Vehicle", models, index);
}

forward OnPlayerAttemptBuyVehicle(playerid, index);
public OnPlayerAttemptBuyVehicle(playerid, index)
{
    if(index < 0)
    {
        return;
    }

	new count = cache_get_row_int(0, 0);
    
	if(count >= GetPlayerAssetLimit(playerid, LIMIT_VEHICLES))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i vehicles. You can't own anymore unless you upgrade your asset perk.", count, GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
	}
	else
	{
	    new string[20];
        if(PlayerData[playerid][pCash] < DealershipCars[index][dcPrice])
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this vehicle.");
        }
        else if(GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES)
	    {
	        SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
	    }
		else 
        {
            new Float:x = BusinessInfo[PlayerData[playerid][pDealershipMenu]][cVehicle][0];
            new Float:y = BusinessInfo[PlayerData[playerid][pDealershipMenu]][cVehicle][1];
            new Float:z = BusinessInfo[PlayerData[playerid][pDealershipMenu]][cVehicle][2];
            new Float:a = BusinessInfo[PlayerData[playerid][pDealershipMenu]][cVehicle][3];
            new modelid = DealershipCars[index][dcModel];
            new price   = DealershipCars[index][dcPrice];

            format(string, 32, "%c%c%c %i", Random('A', 'Z'), Random('A', 'Z'), Random('A', 'Z'), Random(100, 999));
            new querry[960];
            if(PlayerData[playerid][pDealership] == 1)
            {
                new gangid = PlayerData[playerid][pGang];
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (modelid, pos_x, pos_y, pos_z, pos_a, price, plate, color1, color2, gangid, respawndelay) VALUES(%i, '%f', '%f', '%f', '%f', %i, '%s', %i, %i, %i, %i)", 
                modelid, x, y, z, a, price, mysql_escaped(string), 1, 1, gangid, 600);   
                mysql_tquery(connectionID, queryBuffer);
	            mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE id = LAST_INSERT_ID()", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, 0);

                SendClientMessageEx(playerid, COLOR_GREEN, "Gang vehicle %s purchased for $%i. /gfindcar to locate the vehicle.", GetVehicleName(modelid), price);
                Log_Write("log_property", "%s (uid: %i) purchased a %s for $%i for his gang %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(modelid), price, GangInfo[gangid][gName]);
                
            }
            else
            {
                strcat(querry,"INSERT INTO vehicles (ownerid, owner, modelid, price, plate, pos_x, pos_y, pos_z, pos_a)");
                strcat(querry," VALUES(%i, '%s', %i, %i, '%s', '%f', '%f', '%f', '%f')");
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), querry, PlayerData[playerid][pID], GetPlayerNameEx(playerid), modelid, price, mysql_escaped(string), x, y, z, a);
                mysql_tquery(connectionID, queryBuffer);
                
                SendClientMessageEx(playerid, COLOR_GREEN, "%s purchased for $%i. /carstorage to spawn this vehicle.", GetVehicleName(modelid), price);
                Log_Write("log_property", "%s (uid: %i) purchased a %s for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(modelid), price);
                AwardAchievement(playerid, ACH_FirstWheels);
            }
            GivePlayerCash(playerid, -price);
            format(string, sizeof(string), "~r~-$%i", price);
            GameTextForPlayer(playerid, string, 5000, 1);
        }
	}
}

InitDealerShip(playerid)
{
	InDealer[playerid] = 0;
	DSMenuEnabled[playerid]=0;
    DSBox = CreatePlayerTextDraw(playerid, 608.476196, 300.553314, "usebox");
	PlayerTextDrawLetterSize(playerid, DSBox, 0.000000, 13.767779);//dont change it
	PlayerTextDrawTextSize(playerid, DSBox, 470, 0.000000);
	PlayerTextDrawAlignment(playerid, DSBox, 1);
	PlayerTextDrawColor(playerid, DSBox, 0);
	PlayerTextDrawUseBox(playerid, DSBox, true);
	PlayerTextDrawBoxColor(playerid, DSBox, 102);
	PlayerTextDrawSetShadow(playerid, DSBox, 0);
	PlayerTextDrawSetOutline(playerid, DSBox, 0);
	PlayerTextDrawFont(playerid, DSBox, 0);
	
	DSModel = CreatePlayerTextDraw(playerid, 500.0, 240.0, "_");
	PlayerTextDrawFont(playerid, DSModel, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawUseBox(playerid, DSModel, 1);
	PlayerTextDrawBoxColor(playerid, DSModel, 0);
	PlayerTextDrawBackgroundColor(playerid, DSModel, 0);
	PlayerTextDrawTextSize(playerid, DSModel, 80.0, 80.0);
	PlayerTextDrawSetPreviewModel(playerid, DSModel, 411);
	PlayerTextDrawSetPreviewRot(playerid, DSModel, 0.0, 0.0, -20.0, 1.0);
	PlayerTextDrawSetPreviewVehCol(playerid, DSModel, 1, 1);
	PlayerTextDrawSetSelectable(playerid, DSModel, 1);

	DSName = CreatePlayerTextDraw(playerid, 478.142883, 308.906647, "Name: Infernus");
	PlayerTextDrawLetterSize(playerid, DSName, 0.323523, 0.913066);
	PlayerTextDrawAlignment(playerid, DSName, 1);
	PlayerTextDrawColor(playerid, DSName, -1);
	PlayerTextDrawSetShadow(playerid, DSName, 0);
	PlayerTextDrawSetOutline(playerid, DSName, 1);
	PlayerTextDrawBackgroundColor(playerid, DSName, 51);
	PlayerTextDrawFont(playerid, DSName, 1);
	PlayerTextDrawSetProportional(playerid, DSName, 1);

	DSPrice = CreatePlayerTextDraw(playerid, 478.142883, 323.839996, "Price: $999999");
	PlayerTextDrawLetterSize(playerid, DSPrice, 0.323523, 0.911306);
	PlayerTextDrawAlignment(playerid, DSPrice, 1);
	PlayerTextDrawColor(playerid, DSPrice, -1);
	PlayerTextDrawSetShadow(playerid, DSPrice, 0);
	PlayerTextDrawSetOutline(playerid, DSPrice, 1);
	PlayerTextDrawBackgroundColor(playerid, DSPrice, 51);
	PlayerTextDrawFont(playerid, DSPrice, 1);
	PlayerTextDrawSetProportional(playerid, DSPrice, 1);

	DSMaxSpeed = CreatePlayerTextDraw(playerid, 478.142883, 338.773345, "Max speed: 3 Km");
	PlayerTextDrawLetterSize(playerid, DSMaxSpeed, 0.323523, 0.911306);
	PlayerTextDrawAlignment(playerid, DSMaxSpeed, 1);
	PlayerTextDrawColor(playerid, DSMaxSpeed, -1);
	PlayerTextDrawSetShadow(playerid, DSMaxSpeed, 0);
	PlayerTextDrawSetOutline(playerid, DSMaxSpeed, 1);
	PlayerTextDrawBackgroundColor(playerid, DSMaxSpeed, 51);
	PlayerTextDrawFont(playerid, DSMaxSpeed, 1);
	PlayerTextDrawSetProportional(playerid, DSMaxSpeed, 1);
	
	DSDoors = CreatePlayerTextDraw(playerid, 478.142883, 353.706665, "Doors: 2");
	PlayerTextDrawLetterSize(playerid, DSDoors, 0.323523, 0.911306);
	PlayerTextDrawAlignment(playerid, DSDoors, 1);
	PlayerTextDrawColor(playerid, DSDoors, -1);
	PlayerTextDrawSetShadow(playerid, DSDoors, 0);
	PlayerTextDrawSetOutline(playerid, DSDoors, 1);
	PlayerTextDrawBackgroundColor(playerid, DSDoors, 51);
	PlayerTextDrawFont(playerid, DSDoors, 1);
	PlayerTextDrawSetProportional(playerid, DSDoors, 1);
	
	DSType = CreatePlayerTextDraw(playerid, 478.142883, 368.640014, "Type: Sport");
	PlayerTextDrawLetterSize(playerid, DSType, 0.323523, 0.911306);
	PlayerTextDrawAlignment(playerid, DSType, 1);
	PlayerTextDrawColor(playerid, DSType, -1);
	PlayerTextDrawSetShadow(playerid, DSType, 0);
	PlayerTextDrawSetOutline(playerid, DSType, 1);
	PlayerTextDrawBackgroundColor(playerid, DSType, 51);
	PlayerTextDrawFont(playerid, DSType, 1);
	PlayerTextDrawSetProportional(playerid, DSType, 1);
	
	

	DSTest = CreatePlayerTextDraw(playerid, 510.190063, 391.679901, "Test Drive");
	PlayerTextDrawLetterSize(playerid, DSTest, 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, DSTest, 582.094909, 76.800003);
	PlayerTextDrawAlignment(playerid, DSTest, 1);
	PlayerTextDrawColor(playerid, DSTest, -1);
	PlayerTextDrawSetShadow(playerid, DSTest, 0);
	PlayerTextDrawSetOutline(playerid, DSTest, 1);
	PlayerTextDrawBackgroundColor(playerid, DSTest, 51);
	PlayerTextDrawFont(playerid, DSTest, 1);
	PlayerTextDrawSetProportional(playerid, DSTest, 1);
	PlayerTextDrawSetSelectable(playerid, DSTest, 1);

	/*DSInfo = CreatePlayerTextDraw(playerid, 524.428344, 370.906524, "More info");
	PlayerTextDrawLetterSize(playerid, DSInfo, 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, DSInfo, 579.808349, 37.546718);
	PlayerTextDrawAlignment(playerid, DSInfo, 1);
	PlayerTextDrawColor(playerid, DSInfo, -1);
	PlayerTextDrawSetShadow(playerid, DSInfo, 0);
	PlayerTextDrawSetOutline(playerid, DSInfo, 1);
	PlayerTextDrawBackgroundColor(playerid, DSInfo, 51);
	PlayerTextDrawFont(playerid, DSInfo, 1);
	PlayerTextDrawSetProportional(playerid, DSInfo, 1);
	PlayerTextDrawSetSelectable(playerid, DSInfo, 1);*/

	DSBuy = CreatePlayerTextDraw(playerid, 480.142883, 410.026672, "Buy");
	PlayerTextDrawLetterSize(playerid, DSBuy, 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, DSBuy, 524.952209, 62.720016);
	PlayerTextDrawAlignment(playerid, DSBuy, 1);
	PlayerTextDrawColor(playerid, DSBuy, -1);
	PlayerTextDrawSetShadow(playerid, DSBuy, 0);
	PlayerTextDrawSetOutline(playerid, DSBuy, 1);
	PlayerTextDrawBackgroundColor(playerid, DSBuy, 51);
	PlayerTextDrawFont(playerid, DSBuy, 1);
	PlayerTextDrawSetProportional(playerid, DSBuy, 1);
	PlayerTextDrawSetSelectable(playerid, DSBuy, 1);

	DSCancel = CreatePlayerTextDraw(playerid, 568.095031, 410.319763, "Cancel");
	PlayerTextDrawLetterSize(playerid, DSCancel, 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, DSCancel, 601.523193, 62.720012);
	PlayerTextDrawAlignment(playerid, DSCancel, 1);
	PlayerTextDrawColor(playerid, DSCancel, -1);
	PlayerTextDrawSetShadow(playerid, DSCancel, 0);
	PlayerTextDrawSetOutline(playerid, DSCancel, 1);
	PlayerTextDrawBackgroundColor(playerid, DSCancel, 51);
	PlayerTextDrawFont(playerid, DSCancel, 1);
	PlayerTextDrawSetProportional(playerid, DSCancel, 1);
	PlayerTextDrawSetSelectable(playerid, DSCancel, 1);

	DSPrev = CreatePlayerTextDraw(playerid, 476.952209, 280.986450, "<");
	PlayerTextDrawLetterSize(playerid, DSPrev, 0.365427, 1.636640);
	PlayerTextDrawTextSize(playerid, DSPrev, 512.761840, 79.360008);
	PlayerTextDrawAlignment(playerid, DSPrev, 1);
	PlayerTextDrawColor(playerid, DSPrev, -1);
	PlayerTextDrawSetShadow(playerid, DSPrev, 0);
	PlayerTextDrawSetOutline(playerid, DSPrev, 1);
	PlayerTextDrawBackgroundColor(playerid, DSPrev, 51);
	PlayerTextDrawFont(playerid, DSPrev, 2);
	PlayerTextDrawSetProportional(playerid, DSPrev, 1);
	PlayerTextDrawSetSelectable(playerid, DSPrev, 1);

	DSNext = CreatePlayerTextDraw(playerid, 593.380737, 280.986450, ">");
	PlayerTextDrawLetterSize(playerid, DSNext, 0.365427, 1.636640);
	PlayerTextDrawTextSize(playerid, DSNext, 603.429077, 37.546680);
	PlayerTextDrawAlignment(playerid, DSNext, 1);
	PlayerTextDrawColor(playerid, DSNext, -1);
	PlayerTextDrawSetShadow(playerid, DSNext, 0);
	PlayerTextDrawSetOutline(playerid, DSNext, 1);
	PlayerTextDrawBackgroundColor(playerid, DSNext, 51);
	PlayerTextDrawFont(playerid, DSNext, 2);
	PlayerTextDrawSetProportional(playerid, DSNext, 1);
	PlayerTextDrawSetSelectable(playerid, DSNext, 1);

}

HideDSTD(playerid)
{
    PlayerTextDrawHide(playerid,DSModel);
    PlayerTextDrawHide(playerid,DSName);
	PlayerTextDrawHide(playerid,DSPrice);
	PlayerTextDrawHide(playerid,DSMaxSpeed);
	PlayerTextDrawHide(playerid,DSDoors);
	PlayerTextDrawHide(playerid,DSType);
	PlayerTextDrawHide(playerid,DSBox);
	PlayerTextDrawHide(playerid,DSTest);
	PlayerTextDrawHide(playerid,DSBuy);
	PlayerTextDrawHide(playerid,DSCancel);
	PlayerTextDrawHide(playerid,DSPrev);
	PlayerTextDrawHide(playerid,DSNext);
}

Dialog:DealerList(playerid, response, listitem, inputtext[])
{
    new
		company = PlayerData[playerid][pCompany];

	if (!IsValidCompanyID(company))
	{
        return 0;
	}
	if (response)
	{
	    if (listitem == 0)
	    {
	        if (!IsVehicleSpawnSetup(company))
			{
		    	return SendErrorMessage(playerid, "The vehicle spawn point is not setup.");
			}
			else
			{
                Dialog_Show(playerid, DealerAdd, DIALOG_STYLE_INPUT, "{FFFFFF}Add Vehicle", "Please enter the model ID or name of the vehicle to add:", "Submit", "Back");
			}
	  	}
        else if(listitem == 1)
        {
            Dialog_Show(playerid, DealerEditDSType, DIALOG_STYLE_LIST, "{FFFFFF}Edit dealership type", "Car\nBoat\nPlane", "Select", "Back");
        }
		else if(listitem == 2)
        {
            Dialog_Show(playerid, DealerEditSpawn, DIALOG_STYLE_LIST, "{FFFFFF}Dealership vehicle spawn point", "Set to current position\nGoto", "Select", "Back");
        }
		else
		{

		    PlayerData[playerid][pSelected] = gListedItems[playerid][listitem - 3];
            new vehid = PlayerData[playerid][pSelected];
            
		    Dialog_Show(playerid, DealerEdit, DIALOG_STYLE_LIST, "{FFFFFF}Edit vehicle", "Price: %s\nDelete Vehicle\nType: %s\nMaxspeed: %s\nNb doors: %s", "Select", "Back", FormatCash(DealershipCars[vehid][dcPrice]), DealershipCars[vehid][dcType], DealershipCars[vehid][dcMaxSpeed], DealershipCars[vehid][dcDoors]);
		}

	}
	return 1;
}

Dialog:DealerEditSpawn(playerid, response, listitem, inputtext[])
{
    new company = PlayerData[playerid][pCompany];
    if(response)
    {
        if(listitem==0)
        {
            GetPlayerPos(playerid, BusinessInfo[company][cVehicle][0], BusinessInfo[company][cVehicle][1], BusinessInfo[company][cVehicle][2]);
            GetPlayerFacingAngle(playerid, BusinessInfo[company][cVehicle][3]);
            format(queryBuffer, sizeof(queryBuffer), "UPDATE `businesses` SET `cVehicleX` = %.4f, `cVehicleY` = %.4f, `cVehicleZ` = %.4f, `cVehicleA` = %.4f WHERE id = %i",
            BusinessInfo[company][cVehicle][0],BusinessInfo[company][cVehicle][1],BusinessInfo[company][cVehicle][2],BusinessInfo[company][cVehicle][3], BusinessInfo[company][bID]);
            mysql_tquery(connectionID, queryBuffer);
            SendAdminMessage(COLOR_RED, "Admin: %s has edited the vehicle spawn of business %i.", GetRPName(playerid), company);
            ShowDealershipEditMenu(playerid, company);
        }
        else
        {
            TeleportToCoords(playerid, BusinessInfo[company][cVehicle][0], BusinessInfo[company][cVehicle][1], BusinessInfo[company][cVehicle][2], BusinessInfo[company][cVehicle][3], 0, 0);
        }
    }
    else
    {
        ShowDealershipEditMenu(playerid, company);
    }
    return 1;
}
Dialog:DealerEditDSType(playerid, response, listitem, inputtext[])
{
    new company = PlayerData[playerid][pCompany];

    if(response)
    {
        switch(listitem)
        {
            case 0: BusinessInfo[company][bDealerShipType] = DSCars;
            case 1: BusinessInfo[company][bDealerShipType] = DSBoats;
            case 2: BusinessInfo[company][bDealerShipType] = DSPlanes;
            default: return 1;
        }
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET dealershiptype = %i WHERE id = %i", BusinessInfo[company][bDealerShipType], BusinessInfo[company][bID]);
        mysql_tquery(connectionID, queryBuffer);

        ReloadBusiness(company);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map dealership type of business %i to %s.", company, inputtext);
    }	
    ShowDealershipEditMenu(playerid, company);    
    return 1;
}
Dialog:DealerEdit(playerid, response, listitem, inputtext[])
{
    new
		company = PlayerData[playerid][pCompany];

	if (!IsValidCompanyID(company))
	{
        return 0;
	}
	if (response)
	{
        new vehicleid = PlayerData[playerid][pSelected];

	    switch (listitem)
	    {
	        case 0:
	        {
	            Dialog_Show(playerid, DealerPrice, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle price", "The current price for this vehicle is %s.\n\nPlease input the new price for this vehicle below.", "Submit", "Cancel", FormatCash(DealershipCars[vehicleid][dcPrice]));
	        }
	        case 1:
	        {
				format(queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_dealercars WHERE ID = %i", DealershipCars[vehicleid][dcID]);
				mysql_tquery(connectionID, queryBuffer);

                DealershipCars[vehicleid][dcExists] = 0;
                SendInfoMessage(playerid, "You have deleted a vehicle: %s.", GetVehicleName(DealershipCars[vehicleid][dcModel]));

				ShowDealershipEditMenu(playerid, company);
    		}
            case 2:
            {
                Dialog_Show(playerid, DealerType, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle type", "The current type for this vehicle is %s(It's for indication only).\n\nPlease input the new type for this vehicle below.", "Submit", "Cancel", DealershipCars[vehicleid][dcType]);                
            }
            case 3:
            {
                Dialog_Show(playerid, DealerMaxSpeed, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle max speed", "The current max speed for this vehicle is %s(It's for indication only).\n\nPlease input the new max speed for this vehicle below.", "Submit", "Cancel", DealershipCars[vehicleid][dcMaxSpeed]);
            }
            case 4:
            {
                Dialog_Show(playerid, DealerDoors, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle number of doors", "The current number of doors for this vehicle is %s(It's for indication only).\n\nPlease input the new number of doors for this vehicle below.", "Submit", "Cancel", DealershipCars[vehicleid][dcDoors]);
            }
	    }
	}
	else
	{
	    ShowDealershipEditMenu(playerid, company);
	}
	return 1;
}

Dialog:DealerType(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new vehicleid = PlayerData[playerid][pSelected];
        strcpy(DealershipCars[vehicleid][dcType], inputtext, 12);
		SaveDealershipCar(vehicleid);
        SendInfoMessage(playerid, "You have set the Type to '%s' for vehicle: %s.", DealershipCars[vehicleid][dcType], GetVehicleName(DealershipCars[vehicleid][dcModel]));
    }
	ShowDealershipEditMenu(playerid, PlayerData[playerid][pCompany]);
    return 1;
}

Dialog:DealerMaxSpeed(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new vehicleid = PlayerData[playerid][pSelected];
        strcpy(DealershipCars[vehicleid][dcMaxSpeed], inputtext, 12);
		SaveDealershipCar(vehicleid);
        SendInfoMessage(playerid, "You have set the MaxSpeed to '%s' for vehicle: %s.", DealershipCars[vehicleid][dcMaxSpeed], GetVehicleName(DealershipCars[vehicleid][dcModel]));
    }
	ShowDealershipEditMenu(playerid, PlayerData[playerid][pCompany]);
    return 1;
}

Dialog:DealerDoors(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new vehicleid = PlayerData[playerid][pSelected];
        strcpy(DealershipCars[vehicleid][dcDoors], inputtext, 12);
		SaveDealershipCar(vehicleid);
        SendInfoMessage(playerid, "You have set the Doors to '%s' for vehicle: %s.", DealershipCars[vehicleid][dcDoors], GetVehicleName(DealershipCars[vehicleid][dcModel]));
    }
	ShowDealershipEditMenu(playerid, PlayerData[playerid][pCompany]);
    return 1;
}

Dialog:DealerPrice(playerid, response, listitem, inputtext[])
{
    new
		company = PlayerData[playerid][pCompany];

	if (!IsValidCompanyID(company))
	{
        return 0;
	}
	if (response)
	{
	    new vehicle = PlayerData[playerid][pSelected], amount;

	    if (sscanf(inputtext, "i", amount))
		{
		    return Dialog_Show(playerid, DealerPrice, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle price", "The current price for this vehicle is %s.\n\nPlease input the new price for this vehicle below.", "Submit", "Cancel", FormatCash(DealershipCars[vehicle][dcPrice]));
		}
		else if (amount < 0)
		{
		    return Dialog_Show(playerid, DealerPrice, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle price", "The current price for this vehicle is %s.\n\nPlease input the new price for this vehicle below.", "Submit", "Cancel", FormatCash(DealershipCars[vehicle][dcPrice]));
		}
		else
		{
		    DealershipCars[vehicle][dcPrice] = amount;
			SaveDealershipCar(vehicle);

			SendInfoMessage(playerid, "You have set the price to %s for vehicle: %s.", FormatCash(amount), GetVehicleName(DealershipCars[vehicle][dcModel]));
			ShowDealershipEditMenu(playerid, company);
		}
	}
	return 1;
}
GetFirstDealershipCar(company)
{
	for (new i = 0; i < MAX_DEALERSHIP_CARS; i ++)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			return i;
		}
	}
	return -1;
}

GetNextDealershipCar(company,index)
{
	if(index < 0 || index >= MAX_DEALERSHIP_CARS)
		return -1;
	if(company < 0 || company >= MAX_BUSINESSES)
		return -1;
		
	for (new i = index + 1; i < MAX_DEALERSHIP_CARS; i ++)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			return i;
		}
	}
	for (new i = 0; i <= index; i ++)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			return i;
		}
	}
	return -1;
}
GetPreviousDealershipCar(company,index)
{
	if(index < 0 || index >= MAX_DEALERSHIP_CARS)
		return -1;
		
	for (new i = index - 1; i >= 0; i --)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			return i;
		}
	}
	for (new i = MAX_DEALERSHIP_CARS - 1; i >= index; i --)
	{
		if (DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] > 0 && DealershipCars[i][dcExists])
		{
			return i;
		}
	}
	
	return -1;
}
stock ShowDealershipPreviewMenu(playerid, company)
{
	if (IsValidCompanyID(company) && BusinessInfo[company][bType] == BUSINESS_DEALERSHIP)
	{
	    new index = GetFirstDealershipCar(company);

	    if (index == -1)
		{
			return 0;
	    }
	    else
	    {
	        PlayerData[playerid][pDealershipMenu] = company;
	        PlayerData[playerid][pDealershipIndex] = index;
			ShowVehicleSelectionMenu(playerid, MODEL_SELECTION_VEHICLES);
	    }
	}
	return 1;
}
ShowDealerShipInterface(playerid)
{
	new string[128];
	
	if(PlayerData[playerid][pLevel] < 3) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: You need to be level 3 or higher.");
	if(PlayerData[playerid][pWantedLevel] > 0) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: Please surrender, and then come back!");
	//if(FindCSlot(playerid) == -1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: You already have 5 vehicles, sell one first!");
	//if(!IsPlayerNearPoint(playerid,3.0,2131.7759,-1150.5256,24.1473)) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: You're not near the dealership!");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: Please exit the vehicle!");
	//if(SpawnedCars(playerid) >= 1 && GetVIPRankEx(PlayerData[playerid][pDonator]) == 0) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: Please park your car!");
	//if(SpawnedCars(playerid) >= 2 && GetVIPRankEx(PlayerData[playerid][pDonator]) == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFCC}Error: Please park one of your car!");
	
	new businessid = GetInsideBusiness(playerid);

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside dealership business.");
	}
	if (!(IsValidCompanyID(businessid) && BusinessInfo[businessid][bType] == BUSINESS_DEALERSHIP))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside dealership business.");
	}
	SavePlayerVariables(playerid);
	
	DSMenuEnabled[playerid]=1;
	new index = GetFirstDealershipCar(businessid);
    if(index == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no vehicle to sell.");
    }
	DealerShipCarIndex[playerid] = index;
    TogglePlayerControllableEx(playerid, 0);
	SetPlayerVirtualWorld(playerid,playerid+1);
	SetPlayerInterior(playerid,0);
	if(BusinessInfo[businessid][bDealerShipType]==DSPlanes)
	{
		SetPlayerPos(playerid,1473.1616, -2484.8308, 25.1850);
		SetPlayerCameraPos(playerid, 1473.1616, -2484.8308, 32.1850);
		SetPlayerCameraLookAt(playerid, 1442.4185,-2450.6677,14.2778);
		VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 1442.4185, -2450.6677, 14.2778, DSAngle[playerid],1,1,-1);
	}else if(BusinessInfo[businessid][bDealerShipType]==DSBoats)
	{
		SetPlayerPos(playerid,251.1871,-1953.0526, 6.9579);		
		SetPlayerCameraPos(playerid, 251.1871, -1953.0526, 10.9579);
		SetPlayerCameraLookAt(playerid, 229.9136,-1937.0924, 0);
		VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 229.9136, -1937.0924, 0, DSAngle[playerid],1,1,-1);
	}else {
		SetPlayerPos(playerid,2116.8875,-1117.0388,25.2993);
		SetPlayerCameraPos(playerid,2120.9109,-1120.2133,25.3292);
		SetPlayerCameraLookAt(playerid,2124.9263,-1130.8911,25.2097);
		VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 2124.9263, -1130.8911, 25.2097, DSAngle[playerid],1,1,-1);
	}
	DealerID[playerid] = businessid;
	DSAngle[playerid] = 0;    	
	SetVehicleVirtualWorld(VehicleDealer[playerid],playerid+1);
	
	SelectTextDraw(playerid, 0xFF0000FF);
	PlayerTextDrawShow(playerid,DSBox);
	PlayerTextDrawShow(playerid,DSTest);
	PlayerTextDrawShow(playerid,DSBuy);
	PlayerTextDrawShow(playerid,DSCancel);
	PlayerTextDrawShow(playerid,DSPrev);
	PlayerTextDrawShow(playerid,DSNext);

    PlayerTextDrawSetPreviewModel(playerid, DSModel, DealershipCars[index][dcModel]);
	PlayerTextDrawSetPreviewRot(playerid, DSModel, 0.0, 0.0, DSAngle[playerid], 1.0);
	PlayerTextDrawShow(playerid,DSModel);
	
	format(string,sizeof(string),"Name: ~y~%s", GetVehicleNameByModel(DealershipCars[index][dcModel]));
	PlayerTextDrawSetString(playerid,DSName,string);
	PlayerTextDrawShow(playerid,DSName);

	format(string,sizeof(string),"Price: ~y~%s",FormatCash(DealershipCars[index][dcPrice]));
	PlayerTextDrawSetString(playerid,DSPrice,string);
	PlayerTextDrawShow(playerid,DSPrice);

	format(string,sizeof(string),"Max Speed: ~y~%s Km", DealershipCars[index][dcMaxSpeed]);
	PlayerTextDrawSetString(playerid,DSMaxSpeed,string);
	PlayerTextDrawShow(playerid,DSMaxSpeed);
	
	format(string,sizeof(string),"Doors: ~y~%s", DealershipCars[index][dcDoors]);
	PlayerTextDrawSetString(playerid,DSDoors,string);
	PlayerTextDrawShow(playerid,DSDoors);
	
	format(string,sizeof(string),"Type: ~y~%s",DealershipCars[index][dcType]);
	PlayerTextDrawSetString(playerid,DSType,string);
	PlayerTextDrawShow(playerid,DSType);
	
	InDealer[playerid] = 1;
	return 1;
}
forward CancelTDrive(playerid);
public CancelTDrive(playerid)
{
	SendClientMessage(playerid,COLOR_WHITE,"{F3FF02}Your test drive time has expired!");
	SetPlayerWeapons(playerid);
	SetPlayerToSpawn(playerid);
	DestroyVehicle(VehicleDealer[playerid]);
	InDealer[playerid] = 0;
}
hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new string[128];
	
    if(playertextid == DSPrev)
    {
		DestroyVehicle(VehicleDealer[playerid]);
		
		new index = GetPreviousDealershipCar(DealerID[playerid],DealerShipCarIndex[playerid]);
        if(index == -1)
        {
            return 1;
        }
		DealerShipCarIndex[playerid] = index;

		if(BusinessInfo[DealerID[playerid]][bDealerShipType]==DSPlanes)
			VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 1442.4185, -2450.6677, 14.2778, DSAngle[playerid],1,1,-1);
		else if(BusinessInfo[DealerID[playerid]][bDealerShipType]==DSBoats)
			VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 229.9136, -1937.0924, 0, DSAngle[playerid],1,1,-1);
		else VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 2124.9263, -1130.8911, 25.2097, DSAngle[playerid],1,1,-1);

		SetVehicleVirtualWorld(VehicleDealer[playerid],playerid+1);

		SelectTextDraw(playerid, 0xFF0000FF);
		PlayerTextDrawShow(playerid,DSBox);
		PlayerTextDrawShow(playerid,DSTest);
		PlayerTextDrawShow(playerid,DSBuy);
		PlayerTextDrawShow(playerid,DSCancel);
		PlayerTextDrawShow(playerid,DSPrev);
		PlayerTextDrawShow(playerid,DSNext);

	    PlayerTextDrawSetPreviewModel(playerid, DSModel, DealershipCars[index][dcModel]);
		PlayerTextDrawShow(playerid,DSModel);

		format(string,sizeof(string),"Name: ~y~%s", GetVehicleNameByModel(DealershipCars[index][dcModel]));
		PlayerTextDrawSetString(playerid,DSName,string);
		PlayerTextDrawShow(playerid,DSName);

		format(string,sizeof(string),"Price: ~y~%s",FormatCash(DealershipCars[index][dcPrice]));
		PlayerTextDrawSetString(playerid,DSPrice,string);
		PlayerTextDrawShow(playerid,DSPrice);
	
	    format(string,sizeof(string),"Max Speed: ~y~%s Km", DealershipCars[index][dcMaxSpeed]);
		PlayerTextDrawSetString(playerid,DSMaxSpeed,string);
		PlayerTextDrawShow(playerid,DSMaxSpeed);
		
		format(string,sizeof(string),"Doors: ~y~%s", DealershipCars[index][dcDoors]);
		PlayerTextDrawSetString(playerid,DSDoors,string);
		PlayerTextDrawShow(playerid,DSDoors);
		
		format(string,sizeof(string),"Type: ~y~%s",DealershipCars[index][dcType]);
		PlayerTextDrawSetString(playerid,DSType,string);
		PlayerTextDrawShow(playerid,DSType);
		
		
    }
	if(playertextid == DSNext)
    {
		DestroyVehicle(VehicleDealer[playerid]);
		new index = GetNextDealershipCar(DealerID[playerid],DealerShipCarIndex[playerid]);
        if(index == -1)
        {
            return 1;
        }
		DealerShipCarIndex[playerid] = index;

		if(BusinessInfo[DealerID[playerid]][bDealerShipType]==DSPlanes)
			VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 1442.4185, -2450.6677, 14.2778, DSAngle[playerid],1,1,-1);
		else if(BusinessInfo[DealerID[playerid]][bDealerShipType]==DSBoats)
			VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 229.9136, -1937.0924, 0, DSAngle[playerid],1,1,-1);
		else VehicleDealer[playerid] = CreateVehicle(DealershipCars[index][dcModel], 2124.9263, -1130.8911, 25.2097, DSAngle[playerid],1,1,-1);

		SetVehicleVirtualWorld(VehicleDealer[playerid],playerid+1);

		SelectTextDraw(playerid, 0xFF0000FF);
		PlayerTextDrawShow(playerid,DSBox);
		PlayerTextDrawShow(playerid,DSTest);
		PlayerTextDrawShow(playerid,DSBuy);
		PlayerTextDrawShow(playerid,DSCancel);
		PlayerTextDrawShow(playerid,DSPrev);
		PlayerTextDrawShow(playerid,DSNext);

	    PlayerTextDrawSetPreviewModel(playerid, DSModel, DealershipCars[index][dcModel]);
		PlayerTextDrawShow(playerid,DSModel);

		format(string,sizeof(string),"Name: ~y~%s", GetVehicleNameByModel(DealershipCars[index][dcModel]));
		PlayerTextDrawSetString(playerid,DSName,string);
		PlayerTextDrawShow(playerid,DSName);

		format(string,sizeof(string),"Price: ~y~%s",FormatCash(DealershipCars[index][dcPrice]));
		PlayerTextDrawSetString(playerid,DSPrice,string);
		PlayerTextDrawShow(playerid,DSPrice);

	    format(string,sizeof(string),"Max Speed: ~y~%s Km", DealershipCars[index][dcMaxSpeed]);
		PlayerTextDrawSetString(playerid,DSMaxSpeed,string);
		PlayerTextDrawShow(playerid,DSMaxSpeed);
		
		format(string,sizeof(string),"Doors: ~y~%s", DealershipCars[index][dcDoors]);
		PlayerTextDrawSetString(playerid,DSDoors,string);
		PlayerTextDrawShow(playerid,DSDoors);
		
		format(string,sizeof(string),"Type: ~y~%s",DealershipCars[index][dcType]);
		PlayerTextDrawSetString(playerid,DSType,string);
		PlayerTextDrawShow(playerid,DSType);


    }

    if(playertextid == DSModel)
    {
        if(DealerShipCarIndex[playerid] == -1)
        {
            return 1;
        }
		if(DSAngle[playerid] == 330.0)
        {
            DSAngle[playerid] = -30.0;
        }
		DSAngle[playerid] += 30.0;
		
        PlayerTextDrawSetPreviewModel(playerid, DSModel, DealershipCars[DealerShipCarIndex[playerid]][dcModel]);
		PlayerTextDrawSetPreviewRot(playerid, DSModel, 0.0, 0.0, DSAngle[playerid], 1.0);
		PlayerTextDrawShow(playerid,DSModel);
		
		SetVehicleZAngle(VehicleDealer[playerid],DSAngle[playerid]);
    }
    if(playertextid == DSTest)
    {
		DSMenuEnabled[playerid]=0;
        new engine,lights,alarm,doors,bonnet,boot,objective;

		GetVehicleParamsEx(VehicleDealer[playerid],engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(VehicleDealer[playerid],1,lights,alarm,doors,bonnet,boot,objective);
		if(BusinessInfo[DealerID[playerid]][bDealerShipType]==DSPlanes)
		{
			SetVehiclePos(VehicleDealer[playerid], 2013.6168, -2493.8154, 14.4745);
			SetVehicleZAngle(VehicleDealer[playerid], 90.0000);
		}else if(BusinessInfo[DealerID[playerid]][bDealerShipType]==DSBoats){
			SetVehiclePos(VehicleDealer[playerid], 93.8194, -1928.0391, 0.0000);
			SetVehicleZAngle(VehicleDealer[playerid], 180.0000);
		}else{
			SetVehiclePos(VehicleDealer[playerid],1694.9312,-785.2761,54.3741);
			SetVehicleZAngle(VehicleDealer[playerid],348.5435);
		}

		TogglePlayerControllableEx(playerid, 1);
		SetCameraBehindPlayer(playerid);

		PutPlayerInVehicle(playerid,VehicleDealer[playerid],0);
		SendClientMessage(playerid,COLOR_WHITE,"You have 30 seconds to test your car, have fun!");
		DSTimer[playerid] = SetTimerEx("CancelTDrive", 30 * 1000, 0, "d", playerid);
		
		CancelSelectTextDraw(playerid);
		HideDSTD(playerid);
    }
    if(playertextid == DSCancel)
    {
		DSMenuEnabled[playerid]=0;	
    	DestroyVehicle(VehicleDealer[playerid]);
		TogglePlayerControllableEx(playerid, 1);
		SetPlayerWeapons(playerid);
		SetPlayerToSpawn(playerid);
		CancelSelectTextDraw(playerid);
		HideDSTD(playerid);
		InDealer[playerid] = 0;
		DealerShipCarIndex[playerid] = -1;
    }
    if(playertextid == DSBuy)
    {
        if(DealerShipCarIndex[playerid]==-1)
        {
            return 1;
        }
		DSMenuEnabled[playerid]=0;	
		DestroyVehicle(VehicleDealer[playerid]);
		TogglePlayerControllableEx(playerid, 1);
		SetPlayerWeapons(playerid);
		SetPlayerToSpawn(playerid);
		PlayerData[playerid][pDealershipMenu] = DealerID[playerid];
		OnPlayerAttemptBuyVehicle(playerid, DealerShipCarIndex[playerid]);		
		CancelSelectTextDraw(playerid);
		HideDSTD(playerid);
		InDealer[playerid] = 0;
		DealerShipCarIndex[playerid] = -1;
    }
    return 1;
}

GetNextDealershipCarID()
{
    for (new i = 0; i < MAX_DEALERSHIP_CARS; i ++)
	{
	    if (!DealershipCars[i][dcExists])
	    {
	        return i;
		}
	}
	return -1;
}
ClearProducts(company)
{
	switch (BusinessInfo[company][bType])
	{
		case BUSINESS_DEALERSHIP:
		{
		    for (new i = 0; i < MAX_DEALERSHIP_CARS; i ++)
		    {
		        if (DealershipCars[i][dcExists] && DealershipCars[i][dcCompany] == BusinessInfo[company][bID])
		        {
		            DealershipCars[i][dcExists] = 0;
				}
		    }
		    format(queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_dealercars WHERE Company = %i", BusinessInfo[company][bID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
}
SaveDealershipCar(id)
{
	static
	    queryString[128];

	if (!DealershipCars[id][dcExists]) return 0;

	format(queryString, sizeof(queryString), "UPDATE rp_dealercars SET Model = %i, Price = %i, maxspeed='%s', type = '%s',doors='%s'  WHERE ID = %i", DealershipCars[id][dcModel], DealershipCars[id][dcPrice], DealershipCars[id][dcMaxSpeed], DealershipCars[id][dcType], DealershipCars[id][dcDoors],DealershipCars[id][dcID]);
	return mysql_tquery(connectionID, queryString);
}

IsVehicleInDealership(company, model)
{
	if (!IsValidCompanyID(company) || BusinessInfo[company][bType] != BUSINESS_DEALERSHIP)
	{
	    return 0;
	}
 	for (new i = 0; i < MAX_DEALERSHIP_CARS; i ++)
  	{
   		if (DealershipCars[i][dcExists] && DealershipCars[i][dcCompany] == BusinessInfo[company][bID] && DealershipCars[i][dcModel] == model)
		{
  			return 1;
		}
	}
	return 0;
}

AddVehicleToDealership(company, model, price)
{
	if (!IsValidCompanyID(company) || BusinessInfo[company][bType] != BUSINESS_DEALERSHIP)
	{
	    return -1;
	}

 	new
	 	id = GetNextDealershipCarID();

	if (id != -1)
	{
 		DealershipCars[id][dcExists] = 1;
  		DealershipCars[id][dcCompany] = BusinessInfo[company][bID];
    	DealershipCars[id][dcModel] = model;
	   	DealershipCars[id][dcPrice] = price;
		strcpy(DealershipCars[id][dcMaxSpeed],"N/A");
		strcpy(DealershipCars[id][dcType], "N/A");
		strcpy(DealershipCars[id][dcDoors], "2");
		format(queryBuffer, sizeof(queryBuffer), "INSERT INTO rp_dealercars (Company) VALUES(%i)", DealershipCars[id][dcCompany]);
		mysql_tquery(connectionID, queryBuffer, "OnDealershipCarAdded", "i", id);
	}
	return id;
}


Dialog:DealerAdd(playerid, response, listitem, inputtext[])
{
	new
		company = PlayerData[playerid][pCompany];

	if (!IsValidCompanyID(company))
	{
		return 0;
	}
	if (response)
	{
		new model[32], modelid;

		if (sscanf(inputtext, "s[32]", model))
		{
			return Dialog_Show(playerid, DealerAdd, DIALOG_STYLE_INPUT, "{FFFFFF}Add Vehicle", "Please enter the model ID or name of the vehicle to add:", "Submit", "Back");
		}
		else if (!(modelid = GetVehicleModelByName(model)))
		{
			return SendErrorMessage(playerid, "The specified model doesn't exist.");
		}
		else if (IsVehicleInDealership(company, modelid))
		{
			return SendErrorMessage(playerid, "This vehicle is already sold at this dealership.");
		}
		else
		{
			PlayerData[playerid][pSelected] = modelid;
			Dialog_Show(playerid, CarPrice, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle price", "Please input the price to set for '%s' below.", "Submit", "Cancel", GetVehicleName(modelid));
		}
	}
	return 1;
}

Dialog:CarPrice(playerid, response, listitem, inputtext[])
{
	new
		company = PlayerData[playerid][pCompany];

	if (!IsValidCompanyID(company))
	{
		return 0;
	}
	if (response)
	{
		new amount, modelid = PlayerData[playerid][pSelected];

		if (sscanf(inputtext, "i", amount))
		{
			return Dialog_Show(playerid, CarPrice, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle price", "Please input the price to set for '%s' below.", "Submit", "Cancel", GetVehicleName(modelid));
		}
		else if (amount < 1)
		{
			return Dialog_Show(playerid, CarPrice, DIALOG_STYLE_INPUT, "{FFFFFF}Vehicle price", "The price must be above $0.\n\nPlease input the price to set for '%s' below.", "Submit", "Cancel", GetVehicleName(modelid));
		}
		else
		{
			new
				id = AddVehicleToDealership(company, modelid, amount);

			if (id == -1)
			{
				return SendErrorMessage(playerid, "There are no available dealership car slots.");
			}
			else
			{
				SendInfoMessage(playerid, "You have added a %s to company %i.", GetVehicleName(modelid), company);
				ShowDealershipEditMenu(playerid, company);
			}
		}
	}
	return 1;
}
hook OP_ClickTextDraw(playerid, Text:clickedid) {
    if(clickedid == INVALID_TEXT_DRAW){
		if(DSMenuEnabled[playerid])
		{
			DestroyVehicle(VehicleDealer[playerid]);
			TogglePlayerControllableEx(playerid, 1);
			SetPlayerWeapons(playerid);
			SetPlayerToSpawn(playerid);
			CancelSelectTextDraw(playerid);
			HideDSTD(playerid);
			InDealer[playerid] = 0;
			DSMenuEnabled[playerid] = 0;
			DealerShipCarIndex[playerid] = -1;
			KillTimer(DSTimer[playerid]);
		}
		return 1; // block any invalid textdraws.
	}
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(InDealer[playerid])
	{
		DestroyVehicle(VehicleDealer[playerid]);		
		DealerShipCarIndex[playerid] = -1;
	}
    return 1;
}

ShowDealershipEditMenu(playerid, company)
{
	static string[3072];

	if (BusinessInfo[company][bType] != BUSINESS_DEALERSHIP)
	{
	    return 0;
	}
	else
	{
	    new index = 0;

	    string = "Add Vehicle\nDealership type\nSpawn position";

	    for (new i = 0; i < MAX_DEALERSHIP_CARS; i ++)
    	{
	        if (DealershipCars[i][dcExists] && DealershipCars[i][dcCompany] == BusinessInfo[company][bID])
	        {
    	        format(string, sizeof(string), "%s\n%s (price: %s)", string, GetVehicleName(DealershipCars[i][dcModel]), FormatCash(DealershipCars[i][dcPrice]));
				gListedItems[playerid][index++] = i;
	    	}
	    }
	    PlayerData[playerid][pCompany] = company;
    	Dialog_Show(playerid, DealerList, DIALOG_STYLE_LIST, "{FFFFFF}Dealership cars", string, "Select", "Back");
	}
	return 1;
}


//---- DealerShip
CMD:gbuycar(playerid,params[])
{
    return callcmd::gbuyvehicle(playerid,params);
}

CMD:gbuyvehicle(playerid,params[])
{
    new gangid = PlayerData[playerid][pGang];

	if(gangid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
    if(PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
    }

	new businessid = GetInsideBusiness(playerid);

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any business where you can buy stuff.");
	}
	
    if(BusinessInfo[businessid][bType] != BUSINESS_DEALERSHIP)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in dealership business.");
    }
    new limitveh = GetGangVehicleLimit(gangid);
    new count = 0;
    foreach(new i: Vehicle)
	{
	    if(VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == gangid)
	    {
	        count++;
		}
	}

    if(count >= limitveh)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You have reached the limit (%i) of cars for your gang.", limitveh);
    }

    PlayerData[playerid][pDealership] = 1;
	ShowDealerShipInterface(playerid);

	return 1;
}

CMD:editdealership(playerid, params[])
{
	new company;

	if (PlayerData[playerid][pAdmin] < 5)
	{
		return SendErrorMessage(playerid, "You are not privileged to use this command.");
	}
	else if (sscanf(params, "i", company))
	{
		return SendSyntaxMessage(playerid, "/editdealership (business ID)");
	}
	else if (!IsValidCompanyID(company))
	{
		return SendErrorMessage(playerid, "You have specified an invalid company.");
	}
	else if (BusinessInfo[company][bType] != BUSINESS_DEALERSHIP)
	{
		return SendErrorMessage(playerid, "You can only edit dealership businesses.");
	}
	else
	{
		ShowDealershipEditMenu(playerid, company);
	}
	return 1;
}

CMD:editdscarprop(playerid,params[])
{	
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	new vehid,param[12],value[12];
	if(sscanf(params, "is[12]s[12]", vehid,param,value))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "USAGE: /editdscarprop [dcvehid] [type/maxspeed/doors] [value]");
	}		
	if (!DealershipCars[vehid][dcExists]) return SendClientMessage(playerid, COLOR_GREY, "Vehicle id doesnt exist in any dealership.");

	new queryString[256];
	if(!strcmp(param, "maxspeed", true)){
		DealershipCars[vehid][dcMaxSpeed] = value;
		format(queryString, sizeof(queryString), "UPDATE rp_dealercars SET maxspeed='%s' WHERE ID = %i", DealershipCars[vehid][dcMaxSpeed], DealershipCars[vehid][dcID]);
		mysql_tquery(connectionID, queryString);
		return SendClientMessageEx(playerid, COLOR_GREY, "MaxSpeed changed to %s",value);
	}else if(!strcmp(param, "type", true)){
		DealershipCars[vehid][dcType] = value;
		format(queryString, sizeof(queryString), "UPDATE rp_dealercars SET type = '%s' WHERE ID = %i", DealershipCars[vehid][dcType], DealershipCars[vehid][dcID]);
		mysql_tquery(connectionID, queryString);
		return SendClientMessageEx(playerid, COLOR_GREY, "Type changed to %s",value);
	}else if(!strcmp(param, "doors", true)){
		DealershipCars[vehid][dcDoors] = value;	
		format(queryString, sizeof(queryString), "UPDATE rp_dealercars SET doors='%s'  WHERE ID = %i", DealershipCars[vehid][dcDoors], DealershipCars[vehid][dcID]);
		mysql_tquery(connectionID, queryString);
		return SendClientMessageEx(playerid, COLOR_GREY, "Number of doors changed to %s",value);
	}
	return SendClientMessage(playerid, COLOR_GREY, "USAGE: /editdscarprop [dcvehid] [type/maxspeed/doors] [value]");
}

CMD:checkdscarprops(playerid,params[])
{	
    if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	new vehid;
	if(sscanf(params, "i", vehid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "USAGE: /checkdscarprops [dcvehid]");
	}		
	if (!DealershipCars[vehid][dcExists]) return SendClientMessage(playerid, COLOR_GREY, "Vehicle id doesnt exist in any dealership.");
	new company=-1;
	for(new i=0;i<MAX_BUSINESSES;i++)
	{
		if(DealershipCars[vehid][dcCompany] == BusinessInfo[i][bID] && BusinessInfo[i][bExists])
		{
			company = i;
			break;
		}
	}
	if(company == -1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "Company doesnt exist.");
	}
	return SendClientMessageEx(playerid, COLOR_GREY, "DBid: %i, Vehid: %i, Bizid: %i, Model: %i, Price: %i, MaxSpeed: %s, Doors: %s, Type: %s", DealershipCars[vehid][dcID], vehid, company,
	DealershipCars[vehid][dcModel],DealershipCars[vehid][dcPrice],DealershipCars[vehid][dcMaxSpeed],DealershipCars[vehid][dcDoors],DealershipCars[vehid][dcType]);
}


