/// @file      Location.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum locEnum
{
    locID,
    locName[32],
    bool:locExists,
    Float:locPosX,
    Float:locPosY,
    Float:locPosZ
};
static LocationInfo[MAX_LOCATIONS][locEnum];

Dialog:DIALOG_LOCATE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: // JOBS
            {
                new string[512];
                for (new i=0;i<sizeof(jobLocations);i++)
                {
                    if (!isnull(jobLocations[i][jobShortName]))
                    {
                        if (isnull(string))
                        {
                            format(string, sizeof(string), "%s",jobLocations[i][jobName]);
                        }
                        else
                        {
                            format(string, sizeof(string), "%s\n%s",string,jobLocations[i][jobName]);
                        }
                    }
                }
                Dialog_Show(playerid, DIALOG_LOCATELIST1, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
            }
            case 1: // STORES
            {
                Dialog_Show(playerid, DIALOG_LOCATELIST2, DIALOG_STYLE_LIST, "GPS - Select Destination", "24/7\nAmmunation\nClothing Store\nGymnasium\nRestaurant\nAdvertisement Store\nClub\nTool Shop\nDealership", "Select", "Close");
            }
            case 2: // GENERAL LOCATIONS
            {
                Dialog_Show(playerid, DIALOG_LOCATELIST3, DIALOG_STYLE_LIST, "GPS - Select Destination", "DMV\nBank\nPaintball\nCasino\nVIP\nDrug Factory\nMaterials Pickup 1\nMaterials Pickup 2\nMaterials Factory 1\nMaterials Factory 2\nHeisenbergs\nAirport Materials Depot\nMarina Materials Depot", "Select", "Close");
            }
            case 3: // Find Turfs
            {
                ShowFindTurfDlg(playerid);
            }
            case 4: // More locations
            {
                new string[MAX_LOCATIONS*34];
                for (new x = 0; x < MAX_LOCATIONS; x++)
                {
                    if (LocationInfo[x][locExists])
                    {
                        strcat(string, LocationInfo[x][locName]);
                        strcat(string, "\n");
                    }
                }
                if (strlen(string) > 2)
                {
                    Dialog_Show(playerid, DIALOG_LOCATELISTC, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
                }
                else
                {
                    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "GPS - Signal Lost", "Unable to locate any new locations.", "Cancel", "");
                }
            }
            case 5:
            {
                new housestring[1064], type[16];
                housestring = "House ID\tHouse Type\tHouse Locations\tStatus";
                foreach(new i : House)
                {
                    if (HouseInfo[i][hType] == -1)
                    {
                        type = "Other";
                    }
                    else
                    {
                        strcpy(type, houseInteriors[HouseInfo[i][hType]][intClass]);
                    }
                    if (HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
                    {
                        format(housestring, sizeof(housestring), "%s\n%d\t%s\t%s\t%s",housestring, i, type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (HouseInfo[i][hLocked]) ? ("Locked") : ("Unlocked"));
                    }
                    if (strlen(housestring) > 0)
                    {
                        Dialog_Show(playerid, LocateHouse, DIALOG_STYLE_TABLIST_HEADERS, "My House Location", housestring, "Locate", "Close");
                    }
                }
            }
            case 6:
            {
                new business[1064];
                business = "Business ID\tBusiness Type\tBusiness Locations\tStatus";
                foreach(new i : Business)
                {
                    if (BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
                    {
                        format(business, sizeof(business), "%s\n%d\t%s\t%s\t%s",business, i, bizInteriors[BusinessInfo[i][bType]][intType], GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]), (BusinessInfo[i][bLocked]) ? ("Locked") : ("Unlocked"));
                    }
                    if (strlen(business) > 0)
                    {
                        Dialog_Show(playerid, DIALOG_LOCATEBUSINESS, DIALOG_STYLE_TABLIST_HEADERS, "My Business Location", business, "Locate", "Close");
                    }
                }
            }
        }
    }
    return 1;
}
Dialog:DIALOG_LOCATEBUSINESS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new c = 0;
        foreach(new i : Business)
        {
            if (BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
            {
                if (c == listitem)
                {
                    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ], 2.5);
                    SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to your business");
                    break;
                }
                else c++;
            }
        }
    }
    return 1;
}
Dialog:DIALOG_LOCATELIST1(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, jobLocations[listitem][jobX], jobLocations[listitem][jobY], jobLocations[listitem][jobZ], 3.0);
        SendClientMessageEx(playerid, COLOR_WHITE, "* Checkpoint marked at the location of %s.",jobLocations[listitem][jobName]);
    }
    return 1;
}
Dialog:DIALOG_LOCATELIST2(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
                LocateMethod(playerid,"Supermarket");
            case 1:
                LocateMethod(playerid,"GunShop");
            case 2:
                LocateMethod(playerid,"ClothesShop");
            case 3:
                LocateMethod(playerid,"Gym");
            case 4:
                LocateMethod(playerid,"Restaurant");
            case 5:
                LocateMethod(playerid,"AdAgency");
            case 6:
                LocateMethod(playerid,"Club");
            case 7:
                LocateMethod(playerid,"ToolShop");
            case 8:
                LocateMethod(playerid,"Dealership");
        }
    }
    return 1;
}
Dialog:DIALOG_LOCATELIST3(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
                LocateMethod(playerid,"DMV");
            case 1:
                LocateMethod(playerid,"Bank");
            case 2:
                LocateMethod(playerid,"Paintball");
            case 3:
                LocateMethod(playerid,"Casino");
            case 4:
                LocateMethod(playerid,"VIP");
            case 5:
                LocateMethod(playerid,"Smuggledrugs");
            case 6:
                LocateMethod(playerid,"MatPickup1");
            case 7:
                LocateMethod(playerid,"MatPickup2");
            case 8:
                LocateMethod(playerid,"MatFactory1");
            case 9:
                LocateMethod(playerid,"MatFactory2");
            case 10:
                LocateMethod(playerid,"Heisenbergs");
            case 11:
                LocateMethod(playerid,"AirportDepot");
            case 12:
                LocateMethod(playerid,"MarinaDepot");
        }
    }
    return 1;
}
Dialog:DIALOG_LOCATELISTC(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        LocateMethod(playerid, inputtext);
    }
    return 1;
}

LocateMethod(playerid, params[])
{
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_GREY, "Null Error - failed to locate properly - contact a developer.");
        return 1;
    }
    if (!strcmp(params,"hooker",true))
    {
        format(params,7,"pigpen");
    }
    for (new i=0;i<sizeof(staticEntrances);i++)
    {
        if (isnull(staticEntrances[i][eShortName]))
            continue;
        if (!strcmp(params,staticEntrances[i][eShortName],true))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ], 3.0);
            return SendClientMessageEx(playerid, COLOR_WHITE, "* Checkpoint marked at the location of %s.",staticEntrances[i][eName]);
        }
    }
    for (new i=0;i<sizeof(jobLocations);i++)
    {
        if (isnull(jobLocations[i][jobShortName]))
            continue;
        if (!strcmp(params,jobLocations[i][jobShortName],true))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 3.0);
            return SendClientMessageEx(playerid, COLOR_WHITE, "* Checkpoint marked at the location of %s job.",jobLocations[i][jobName]);
        }
    }
    if (!strcmp(params, "dmv", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1219.2590, -1812.1093, 16.5938, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of DMV.");
    }
    else if (!strcmp(params, "dealership", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_DEALERSHIP);
        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest supermarket to you.");
    }
    else if (!strcmp(params, "boatdealer", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 154.2223, -1946.3030, 5.1920, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the boat dealership.");
    }
    else if (!strcmp(params, "airdealer", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1892.6315, -2328.6721, 13.5469, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the aircraft dealership.");
    }
    else if (!strcmp(params, "matpickup1", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1421.6913, -1318.4719, 13.5547, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the 1st materials pickup.");
    }
    else if (!strcmp(params, "matpickup2", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 2393.4885, -2008.5726, 13.3467, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the 2nd materials pickup.");
    }
    else if (!strcmp(params, "matfactory1", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 2173.2129, -2264.1548, 13.3467, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the 1st materials factory.");
    }
    else if (!strcmp(params, "matfactory2", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 2288.0918, -1105.6555, 37.9766, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the 2nd materials factory.");
    }
    else if (!strcmp(params, "aiportdepot", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 2112.3240, -2432.8130, 13.5469, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of LSI Materials Depot.");
    }
    else if (!strcmp(params, "marinadepot", true))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 714.5344, -1565.1694, 1.7680, 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of Marina materials depot.");
    }
    else if (!strcmp(params, "supermarket", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_STORE);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }

        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest supermarket to you.");
    }
    else if (!strcmp(params, "gunshop", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_GUNSHOP);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }

        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest gun shop to you.");
    }
    else if (!strcmp(params, "clothesshop", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_CLOTHES);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest clothes shop to you.");
    }
    else if (!strcmp(params, "gym", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_GYM);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest gym to you.");
    }
    else if (!strcmp(params, "restaurant", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_RESTAURANT);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest restaurant to you.");
    }
    else if (!strcmp(params, "adagency", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_AGENCY);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest advertisement agency to you.");
    }
    else if (!strcmp(params, "club", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_BARCLUB);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest club/bar to you.");
    }
    else if (!strcmp(params, "toolshop", true))
    {
        new businessid = GetClosestBusiness(playerid, BUSINESS_TOOLSHOP);

        if (businessid == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no businesses of this type to be found.");
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 3.0);
        SendClientMessage(playerid, COLOR_WHITE, "* Checkpoint marked at the location of the closest tool shop to you.");
    }

    else
    {
        for (new x = 0; x < MAX_LOCATIONS; x++)
        {
            if (!strcmp(params, LocationInfo[x][locName], true))
            {
                SetActiveCheckpoint(playerid, CHECKPOINT_MISC, LocationInfo[x][locPosX], LocationInfo[x][locPosY], LocationInfo[x][locPosZ], 3.0);
                SendClientMessageEx(playerid, COLOR_WHITE, "* Checkpoint marked at the location of %s", LocationInfo[x][locName]);
                break;
            }
            if (x == MAX_LOCATIONS - 1)
            {
                SendClientMessageEx(playerid, COLOR_SYNTAX, "Unable to locate '%s'. Contact an administrator!", params);
                break;
            }
        }
        /*SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /locate [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "Business Types: Supermarket, GunShop, ClothesShop, Gym, Restaurant, AdAgency, Club, ToolShop");
        SendClientMessage(playerid, COLOR_SYNTAX, "General Locations: DMV, Bank, Paintball, Casino, VIP, DrugFactory, MatPickup1, MatPickup2");
        SendClientMessage(playerid, COLOR_SYNTAX, "General Locations: Dealership, AirDealer, BoatDealer, MatFactory1, MatFactory2, Heisenbergs");
        SendClientMessage(playerid, COLOR_SYNTAX, "Scripted Jobs: Pizzaman, Courier, Fisherman, Bodyguard, ArmsDealer, Mechanic, Miner, Sweeper");
        SendClientMessage(playerid, COLOR_SYNTAX, "Scripted Jobs: TaxiDriver, DrugDealer, Lawyer, Detective, Thief");*/

    }
    return 1;
}

DB:OnLoadLocations()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_LOCATIONS; i ++)
    {
        GetDBStringField(i, "name", LocationInfo[i][locName], 64);

        LocationInfo[i][locID] = GetDBIntField(i, "id");
        LocationInfo[i][locPosX] = GetDBFloatField(i, "pos_x");
        LocationInfo[i][locPosY] = GetDBFloatField(i, "pos_y");
        LocationInfo[i][locPosZ] = GetDBFloatField(i, "pos_z");
        LocationInfo[i][locExists] = true;
    }
    printf("[Script] %i locations loaded", (rows < MAX_LOCATIONS) ? (rows) : (MAX_LOCATIONS));
}


GetNearbyLocation(playerid, Float:radii)
{
    for (new i = 0; i < MAX_LOCATIONS; i ++)
    {
        if (LocationInfo[i][locExists] && IsPlayerInRangeOfPoint(playerid, radii, LocationInfo[i][locPosX], LocationInfo[i][locPosY], LocationInfo[i][locPosZ]) && GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
        {
            return i;
        }
    }

    return -1;
}


DB:OnAdminCreateLocation(playerid, location, name[], Float:x, Float:y, Float:z)
{
    LocationInfo[location][locID] = GetDBInsertID();
    LocationInfo[location][locExists] = true;
    strcpy(LocationInfo[location][locName], name, 32);
    LocationInfo[location][locPosX] = x;
    LocationInfo[location][locPosY] = y;
    LocationInfo[location][locPosZ] = z;

    SendClientMessageEx(playerid, COLOR_GREEN, "* Location [%i] %s created at %.1f, %.1f, %.1f.", location, name, x, y, z);
}

stock GetLocationName(locationid)
{
    return LocationInfo[locationid][locName];
}

CMD:removelocation(playerid, params[])
{
    new loc;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", loc))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelocation [locationid]");
    }
    if (!(0 <= loc < MAX_LOCATIONS) || !LocationInfo[loc][locExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid location.");
    }

    DBQuery("DELETE FROM locations WHERE id = %i", LocationInfo[loc][locID]);
    LocationInfo[loc][locName][0] = EOS;
    LocationInfo[loc][locExists] = false;
    LocationInfo[loc][locID] = 0;

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed location %i.", loc);
    return 1;
}

CMD:createlocation(playerid, params[])
{
    new name[32], Float:x, Float:y, Float:z;
    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "s[32]", name))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createlocation [name]");
        SendClientMessage(playerid, COLOR_WHITE, "* NOTE: The location will be created at the coordinates you are standing on.");
        return 1;
    }
    if (GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your virtual world & interior must be 0!");
    }
    GetPlayerPos(playerid, x, y, z);
    for (new i = 0; i < MAX_LOCATIONS; i ++)
    {
        if (!LocationInfo[i][locExists])
        {
            DBFormat("INSERT INTO locations VALUES(null, '%e', '%f', '%f', '%f')", name, x, y, z);
            DBExecute("OnAdminCreateLocation", "iisfff", playerid, i, name, x, y, z);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Location slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:sendlocate(playerid, params[])
{
    new number;

    if (sscanf(params, "i", number))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sendlocate [number]");
    }
    if (!PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
    }
    if (PlayerData[playerid][pCash] < 500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 500$ to send sms.");
    }
    if (PlayerData[playerid][pTogglePhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
    }
    if (number == 0 || number == PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pPhone] == number)
        {
            if (PlayerData[i][pJailType] != JailType_None)
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
            }
            if (PlayerData[i][pTogglePhone])
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
            }

            if (PlayerHasActiveCheckpoint(i))
            {
                return SendClientMessage(playerid, COLOR_GREY, "This person is currently busy.");
            }

            ShowActionBubble(playerid, "* %s takes out his cellphone and sends a message.", GetRPName(playerid));

            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            SetActiveCheckpoint(i, CHECKPOINT_MISC, x, y, z, 2.5);
            SendClientMessageEx(i, COLOR_YELLOW, "SMS: New available GPS coordinates, Received from: %s(%i)", GetRPName(playerid), PlayerData[playerid][pPhone]);
            SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: New available GPS coordinates, Send to: %s(%i)", GetRPName(i), PlayerData[i][pPhone]);
            GivePlayerCash(playerid, -500);
            GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$500", 5000, 1);
            return 1;
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, "Cannot send SMS to %d.", number);
    return 1;
}

CMD:locate(playerid, params[])
{
    if (isnull(params))
    {
        return ShowDialogToPlayer(playerid, DIALOG_LOCATE);
    }
    else
    {
        LocateMethod(playerid, params);
    }
    return 1;
}

CMD:nb(playerid, params[])
{
    return callcmd::nearestbusiness(playerid, params);
}

CMD:nearestbusiness(playerid, params[])
{
    Dialog_Show(playerid, DIALOG_LOCATELIST2, DIALOG_STYLE_LIST, "GPS - Select Destination", "24/7\nAmmunation\nClothing Store\nGymnasium\nRestaurant\nAdvertisement Store\nClub\nTool Shop\nDealership", "Select", "Close");
    return 1;
}

CMD:findjob(playerid, params[])
{
    new string[512];
    for (new i=0;i<sizeof(jobLocations);i++)
    {
        if (!isnull(jobLocations[i][jobShortName]))
        {
            if (isnull(string))
                format(string, sizeof(string), "%s", jobLocations[i][jobName]);
            else format(string, sizeof(string), "%s\n%s", string,jobLocations[i][jobName]);
        }
    }

    return Dialog_Show(playerid, DIALOG_LOCATELIST1, DIALOG_STYLE_LIST, "GPS - Select Destination", string, "Select", "Close");
}

CMD:ccp(playerid, params[])
{
    return callcmd::cancelcp(playerid, params);
}

CMD:kcp(playerid, params[])
{
    return callcmd::cancelcp(playerid, params);
}

CMD:killcp(playerid, params[])
{
    return callcmd::cancelcp(playerid, params);
}

CMD:killcheckpoint(playerid, params[])
{
    return callcmd::cancelcp(playerid, params);
}

CMD:cancelcp(playerid, params[])
{
    CancelActiveCheckpoint(playerid);
    SendClientMessage(playerid, COLOR_WHITE, "You have cancelled all active checkpoints.");
    return 1;
}
