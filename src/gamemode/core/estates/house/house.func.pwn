
GetHouseStashCapacity(houseid, item)
{
	return houseStashCapacities[HouseInfo[houseid][hLevel] - 1][item];
}

GetHouseTenantCapacity(houseid)
{
	switch(HouseInfo[houseid][hLevel])
	{
	    case 1: return  5;
	    case 2: return 10;
	    case 3: return 15;
	    case 4: return 20;
	    case 5: return 25;
		case 6: return 30;
	}

	return 0;
}

GetHouseFurnitureCapacity(houseid)
{
	switch(HouseInfo[houseid][hLevel])
	{
	    case 1: return  50;
	    case 2: return  80;
	    case 3: return 110;
	    case 4: return 140;
	    case 5: return 170;
	    case 6: return 200;
	}

	return 0;
}

GetRandomHouse(playerid) // For pizzaboy job.
{
	new index, houseIDs[MAX_HOUSES] = {-1, ...};

	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && HouseInfo[i][hOutsideInt] == 0 && HouseInfo[i][hOutsideVW] == 0)
	    {
	        if(300.0 <= GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]) <= 1200.0)
	        {
	            if(HouseInfo[i][hDelivery])
	            {
	        		houseIDs[index++] = i;
				}
			}
		}
	}

	if(index == 0)
	{
	    return -1;
	}

	return houseIDs[random(index)];
}

GetNearbyHouseEx(playerid)
{
	return GetNearbyHouse(playerid) == -1 ? GetInsideHouse(playerid) : GetNearbyHouse(playerid);
}

GetFurnitureHouse(playerid)
{
	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i) && IsPlayerInRangeOfPoint(playerid, 15.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hOutsideInt] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hOutsideVW])
	    {
	        return i;
		}
	}

	return -1;
}

GetNearbyHouse(playerid)
{
	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hOutsideInt] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hOutsideVW])
	    {
	        return i;
		}
	}

	return -1;
}

GetInsideHouse(playerid)
{
	foreach(new i : House)
	{
	    if(HouseInfo[i][hExists] && IsPlayerInRangeOfPoint(playerid, 100.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]) && GetPlayerInterior(playerid) == HouseInfo[i][hInterior] && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hWorld])
	    {
	        return i;
		}
	}

	return -1;
}

SetHouseOwner(houseid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(HouseInfo[houseid][hOwner], "Nobody", MAX_PLAYER_NAME);
	    HouseInfo[houseid][hOwnerID] = 0;
	}
	else
	{
	    GetPlayerName(playerid, HouseInfo[houseid][hOwner], MAX_PLAYER_NAME);
	    HouseInfo[houseid][hOwnerID] = PlayerData[playerid][pID];
	}

	HouseInfo[houseid][hTimestamp] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", HouseInfo[houseid][hTimestamp], HouseInfo[houseid][hOwnerID], HouseInfo[houseid][hOwner], HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadHouse(houseid);
}

CountPlayerHouses(playerid)
{
	new count = 0;

	for(new i = 0; i < MAX_HOUSES; i++){

		if(HouseInfo[i][hExists])
		{
			if(IsHouseOwner(playerid, i))
			{
				count++;
			}
		}
	}

	return count;
}


ReloadHouse(houseid)
{
    if (HouseInfo[houseid][hExists])
    {
        new string[268];
        new type[16];

        DestroyDynamic3DTextLabel(HouseInfo[houseid][hText]);
        DestroyDynamicPickup(HouseInfo[houseid][hPickup]);

        if (HouseInfo[houseid][hType] == -1)
        {
            type = "Other";
        }
        else
        {
            strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
        }

        if (HouseInfo[houseid][hOwnerID] == 0)
        {
            format(string, sizeof(string), "{AAC4E5}[HOUSE FOR SALE] ({FFFFFF}ID %i{AAC4E5})\n{FFFFFF}Class: {AAC4E5}%s\n{FFFFFF}House Level: {AAC4E5}%i\n{FFFFFF}Price: {AAC4E5}%s", houseid, type, HouseInfo[houseid][hLevel], FormatCash(HouseInfo[houseid][hPrice]));
            HouseInfo[houseid][hPickup] = CreateDynamicPickup(1273, 1, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
        }
        else
        {
            if (HouseInfo[houseid][hRentPrice] > 0)
            {
                format(string, sizeof(string), "{AAC4E5}[HOUSE] ({FFFFFF}ID %i{AAC4E5})\n{FFFFFF}Owner: {AAC4E5}%s\n{FFFFFF}Class: {AAC4E5}%s\n{FFFFFF}Rent: {AAC4E5}$%i\n{FFFFFF}House Level: {AAC4E5}%i", houseid, HouseInfo[houseid][hOwner], type, HouseInfo[houseid][hRentPrice], HouseInfo[houseid][hLevel]);
            }
            else
            {
                format(string, sizeof(string), "{AAC4E5}[HOUSE] ({FFFFFF}ID %i{AAC4E5})\n{FFFFFF}Owner: {AAC4E5}%s\n{FFFFFF}Class: {AAC4E5}%s\n{FFFFFF}House Level: {AAC4E5}%i", houseid, HouseInfo[houseid][hOwner], type, HouseInfo[houseid][hLevel]);
            }
            HouseInfo[houseid][hPickup] = CreateDynamicPickup(19522, 1, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], .worldid = HouseInfo[houseid][hOutsideVW], .interiorid = HouseInfo[houseid][hOutsideInt]);
        }

        HouseInfo[houseid][hText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]+0.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, HouseInfo[houseid][hOutsideVW], HouseInfo[houseid][hOutsideInt], -1 , 10.0);
        //HouseInfo[houseid][hMapIcon] = CreateDynamicMapIcon(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 31, 1, -1, -1, -1, 100.0);
    }
}


HasFurniturePerms(playerid, houseid)
{
	return IsHouseOwner(playerid, houseid) || PlayerData[playerid][pFurniturePerms] == houseid;
}
IsValidFurnitureID(id)
{
	return (id >= 0 && id < MAX_FURNITURE) && Furniture[id][fExists];
}
IsValidHouseID(id)
{
	return (id >= 0 && id < MAX_HOUSES) && HouseInfo[id][hExists];
}
IsHouseOwner(playerid, houseid)
{
    if(houseid == -1)
    {
        return false;
    }
    return (HouseInfo[houseid][hOwnerID] == PlayerData[playerid][pID]);
}

PreviewFurniture(playerid, index)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	x += 2.0 * floatsin(-angle, degrees);
	y += 2.0 * floatcos(-angle, degrees);

	if (IsValidDynamicObject(gPreviewFurniture[playerid]))
	{
	    DestroyDynamicObject(gPreviewFurniture[playerid]);
	}

    PlayerData[playerid][pPreviewIndex] = index;
	gPreviewFurniture[playerid] = CreateDynamicObject(g_FurnitureList[index][e_ModelID], x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

	EditDynamicObjectEx(playerid, EDIT_TYPE_PREVIEW, gPreviewFurniture[playerid]);
	SendInfoMessage(playerid, "Press ESC to cancel. Click the disk icon to save changes.");
	return 1;
}


ShowFurniturePreviewer(playerid)
{
    new
		models[MAX_SELECTION_MENU_ITEMS] = {-1, ...},
		index;

	PlayerData[playerid][pPreviewIndex] = -1;

	for(new i = 0; i < sizeof(g_FurnitureList); i ++)
	{
	    if (g_FurnitureList[i][e_ModelCategory] == PlayerData[playerid][pSelected])
	    {
	        if(PlayerData[playerid][pPreviewIndex] == -1)
	        {
	            PlayerData[playerid][pPreviewIndex] = i;
			}

	        models[index++] = g_FurnitureList[i][e_ModelID];
	    }
	}
	ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_FURNITURE, "House Furniture", models, index);
	return 0;
}

UpdateFurniture(furniture)
{
	if (!IsValidFurnitureID(furniture))
	{
	    return 0;
	}
	DestroyDynamicObject(Furniture[furniture][fObject]);
	Furniture[furniture][fObject] = CreateDynamicObject(Furniture[furniture][fModel], Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], Furniture[furniture][fSpawn][3], Furniture[furniture][fSpawn][4], Furniture[furniture][fSpawn][5], Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
	Streamer_SetExtraInt(Furniture[furniture][fObject], E_OBJECT_EXTRA_ID, Furniture[furniture][fID]);
	for(new i = 0; i != 3; i ++)
	{
		if(MaterialIDs[Furniture[furniture][fMaterial][i]][ModelID] != 0)
		{
		    SetDynamicObjectMaterial(Furniture[furniture][fObject], i, MaterialIDs[Furniture[furniture][fMaterial][i]][ModelID], MaterialIDs[Furniture[furniture][fMaterial][i]][TxdName], MaterialIDs[Furniture[furniture][fMaterial][i]][TextureName], MaterialColors[Furniture[furniture][fMatColour][i]][ColorHex]);
		}
		else if(Furniture[furniture][fMatColour][i] != 0)
		{
		    SetDynamicObjectMaterial(Furniture[furniture][fObject], i, -1, MaterialIDs[Furniture[furniture][fMaterial][i]][TxdName], MaterialIDs[Furniture[furniture][fMaterial][i]][TextureName], MaterialColors[Furniture[furniture][fMatColour][i]][ColorHex]);
		}
	}
	UpdateFurnitureText(furniture);
	return 1;
}

UpdateFurnitureText(furniture)
{
	new
		string[64];

	if (!IsValidFurnitureID(furniture))
	{
	    return 0;
	}
	DestroyDynamic3DTextLabel(Furniture[furniture][fText]);

	if (Furniture[furniture][fEdit])
	{
	    format(string, sizeof(string), "ID: {00FF00}%i{FFFFFF}\n/edit, /delete.", furniture);

		Furniture[furniture][fText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
	}
	else
	{
	    if (Furniture[furniture][fModel] == 2332)
		{
		    if (Furniture[furniture][fSafeOpen])
		    {
		        Furniture[furniture][fText] = CreateDynamic3DTextLabel("Status: {00FF00}Opened{AFAFAF}\nPress Y to use safe", COLOR_GREY, Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
		    }
		    else
		    {
		    	Furniture[furniture][fText] = CreateDynamic3DTextLabel("Status: {FF5030}Closed{AFAFAF}\nPress Y to use safe", COLOR_GREY, Furniture[furniture][fSpawn][0], Furniture[furniture][fSpawn][1], Furniture[furniture][fSpawn][2], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Furniture[furniture][fWorld], Furniture[furniture][fInterior]);
			}
		}
		else
		{
		    Furniture[furniture][fText] = INVALID_3DTEXT_ID;
		}
	}

	return 1;
}

SaveFurniture(furniture)
{
	if (!IsValidFurnitureID(furniture)) return 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE rp_furniture SET fModel = %i, fX = %.4f, fY = %.4f, fZ = %.4f, fRX = %.4f, fRY = %.4f, fRZ = %.4f, fInterior = %i, fWorld = %i, fCode = %i, fMoney = %i, Mat1 = %i, Mat2 = %i, Mat3 = %i, MatColor1 = %i, MatColor2 = %i, MatColor3 = %i WHERE fID = %i",
	    Furniture[furniture][fModel],
	    Furniture[furniture][fSpawn][0],
	    Furniture[furniture][fSpawn][1],
	    Furniture[furniture][fSpawn][2],
	    Furniture[furniture][fSpawn][3],
	    Furniture[furniture][fSpawn][4],
	    Furniture[furniture][fSpawn][5],
	    Furniture[furniture][fInterior],
	    Furniture[furniture][fWorld],
	    Furniture[furniture][fCode],
	    Furniture[furniture][fMoney],
	    Furniture[furniture][fMaterial][0],
	    Furniture[furniture][fMaterial][1],
	    Furniture[furniture][fMaterial][2],
	    Furniture[furniture][fMatColour][0],
	    Furniture[furniture][fMatColour][1],
	    Furniture[furniture][fMatColour][2],
	    Furniture[furniture][fID]
	);
	return mysql_tquery(connectionID, queryBuffer);
//	return printf(queryBuffer);
}

DeleteFurniture(furniture)
{
    if (!IsValidFurnitureID(furniture))
	{
		return 0;
	}

	DestroyDynamicObject(Furniture[furniture][fObject]);
	DestroyDynamic3DTextLabel(Furniture[furniture][fText]);

	format(queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_furniture WHERE fID = %i", Furniture[furniture][fID]);
	mysql_tquery(connectionID, queryBuffer);

	Furniture[furniture][fID] = 0;
	Furniture[furniture][fExists] = 0;
	Furniture[furniture][fObject] = INVALID_OBJECT_ID;
	Furniture[furniture][fText] = INVALID_3DTEXT_ID;
	return 1;
}

ShowFurnitureCategories(playerid)
{
    new string[192];

	for (new i = 0; i < sizeof(g_FurnitureTypes); i ++) {
 		strcat(string, g_FurnitureTypes[i]);
   		strcat(string, "\n");
   	}
    Dialog_Show(playerid, BuyFurniture, DIALOG_STYLE_LIST, "{FFFFFF}Select category", string, "Select", "Cancel");
}

SetFurnitureEditMode(house, enable)
{
    HouseInfo[house][hEdit] = enable;

	for (new i = 0; i < MAX_FURNITURE; i ++)
	{
 		if (Furniture[i][fExists] && Furniture[i][fHouseID] == HouseInfo[house][hID])
   		{
     		Furniture[i][fEdit] = enable;
			UpdateFurnitureText(i);
 		}
	}
}
GetNextFurnitureID()
{
	for (new i = 0; i < MAX_FURNITURE; i ++)
	{
	    if (!Furniture[i][fExists])
	    {
	        return i;
		}
	}
	return -1;
}

AddFurniture(house, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, interior, worldid)
{
	new
	    id = GetNextFurnitureID();

	if (id != -1)
	{
		Furniture[id][fExists] = 1;
		Furniture[id][fHouseID] = HouseInfo[house][hID];
		Furniture[id][fEdit] = HouseInfo[house][hEdit];
		Furniture[id][fModel] = modelid;
		Furniture[id][fSpawn][0] = x;
		Furniture[id][fSpawn][1] = y;
		Furniture[id][fSpawn][2] = z;
		Furniture[id][fSpawn][3] = rx;
		Furniture[id][fSpawn][4] = ry;
		Furniture[id][fSpawn][5] = rz;
		Furniture[id][fInterior] = interior;
		Furniture[id][fWorld] = worldid;
		Furniture[id][fCode] = 0;
		Furniture[id][fMoney] = 0;
        Furniture[id][fSafeOpen] = 0;
        Furniture[id][fDoorOpen] = 0;
		Furniture[id][fObject] = INVALID_OBJECT_ID;
		Furniture[id][fText] = INVALID_3DTEXT_ID;

		for(new i = 0; i != 3; i ++)
		{
		    Furniture[id][fMaterial][i] = 0;
		    Furniture[id][fMatColour][i] = 0;
		}

		UpdateFurniture(id);

		format(queryBuffer, sizeof(queryBuffer), "INSERT INTO rp_furniture (fHouseID) VALUES(%i)", Furniture[id][fHouseID]);
		mysql_tquery(connectionID, queryBuffer, "OnFurnitureAdded", "i", id);
	}
	return id;
}
forward OnFurnitureAdded(furniture);
public OnFurnitureAdded(furniture)
{
    Furniture[furniture][fID] = cache_insert_id(connectionID);

    SaveFurniture(furniture);
}


FurnitureChange(playerid, furnid, index, list, status = 1) // 1 for mat, 2 for color
{
    new model, txd[24], texture[24], color;
	switch(status)
	{
	    case 1:
	    {
	        SendClientMessage(playerid, -1, "Furniture texture has been updated.");
	        Furniture[furnid][fMaterial][index] = list;
	        SetDynamicObjectMaterial(Furniture[furnid][fObject], index, MaterialIDs[ Furniture[furnid][fMaterial][index] ][ModelID], MaterialIDs[ Furniture[furnid][fMaterial][index] ][TxdName], MaterialIDs[ Furniture[furnid][fMaterial][index] ][TextureName], MaterialColors[ Furniture[furnid][fMatColour][index] ][ColorHex]);
			SaveFurniture(furnid);
		}
	    case 2:
	    {
	        if(Furniture[furnid][fMaterial][index] == 0)
	        {
	            Furniture[furnid][fMatColour][index] = list;
	            SetDynamicObjectMaterial(Furniture[furnid][fObject], index, -1, MaterialIDs[ Furniture[furnid][fMaterial][index] ][TxdName], MaterialIDs[ Furniture[furnid][fMaterial][index] ][TextureName], MaterialColors[ Furniture[furnid][fMatColour][index] ][ColorHex]);
                SaveFurniture(furnid);
			}
            else
            {
		        SendClientMessage(playerid, -1, "Furniture color has been updated.");
		        Furniture[furnid][fMatColour][index] = list;
		    	GetDynamicObjectMaterial(Furniture[furnid][fObject], index, model, txd, texture, color);
				SetDynamicObjectMaterial(Furniture[furnid][fObject], index, model, txd, texture, MaterialColors[ Furniture[furnid][fMatColour][index] ][ColorHex]);
	            SaveFurniture(furnid);
            }
		}
	}
	return 1;
}
Dialog:HouseFurniture(playerid, response, listitem, inputtext[])
{
    new
		house = PlayerData[playerid][pHouse];

    if(!GetInsideHouse(playerid) && !GetFurnitureHouse(playerid)) return SendErrorMessage(playerid, "You are not nearby or in a house that you own.");

	if (!IsValidHouseID(house) || !IsHouseOwner(playerid, house))
	{
        return 0;
	}
	if (response)
	{
	    switch (listitem)
	    {
		    case 0: // Buy furniture
		    {
		        ShowFurnitureCategories(playerid);
		    }
		    case 1: // Edit furniture
		    {
		        if (HouseInfo[house][hEdit])
		        {
					PlayerData[playerid][pHouseEdit] = -1;

					SetFurnitureEditMode(house, false);
		            SendInfoMessage(playerid, "You are no longer editing your furniture.");
				}
				else
				{
				    if (PlayerData[playerid][pHouseEdit] != -1)
				    {
				        SetFurnitureEditMode(PlayerData[playerid][pHouseEdit], false);
				    }
				    PlayerData[playerid][pHouseEdit] = house;

				    SetFurnitureEditMode(house, true);
					SendInfoMessage(playerid, "You are now in edition mode. Use /cancel to stop editing.");
				}
			}
		}
	}
	return 1;
}

//case DIALOG_HOUSERENT:
//{
//	if(response)
//	{
forward OnPlayerRentHouse(playerid, houseid);
public OnPlayerRentHouse(playerid, houseid)
{
	if(cache_get_row_int(0, 0) >= GetHouseTenantCapacity(houseid))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "This house has reached its limit of %i tenants.", GetHouseTenantCapacity(houseid));
	}
	else
	{
	 //   Dialog_Show(HouseInfo[houseid][hOwner], DIALOG_HOUSERENT, DIALOG_STYLE_MSGBOX, "House Rent", "%s is trying to rent a room in your house, do you accept it?", "Accept", "Decline");
	//	SendClientMessage(playerid, COLOR_GREY, "Your renting deal has been sent to the owner, please wait.");
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rentinghouse = %i WHERE uid = %i", HouseInfo[houseid][hID], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		PlayerData[playerid][pRentingHouse] = HouseInfo[houseid][hID];
		SendClientMessageEx(playerid, COLOR_GREEN, "You are now renting at %s's house. You will pay %s every paycheck.", HouseInfo[houseid][hOwner], FormatCash(HouseInfo[houseid][hRentPrice]));
	}
}

forward OnAdminCreateHouse(playerid, houseid, type, Float:x, Float:y, Float:z, Float:angle);
public OnAdminCreateHouse(playerid, houseid, type, Float:x, Float:y, Float:z, Float:angle)
{
	strcpy(HouseInfo[houseid][hOwner], "Nobody", MAX_PLAYER_NAME);

	HouseInfo[houseid][hExists] = 1;
	HouseInfo[houseid][hID] = cache_insert_id(connectionID);
	HouseInfo[houseid][hOwnerID] = 0;
	HouseInfo[houseid][hType] = type;
	HouseInfo[houseid][hPrice] = houseInteriors[type][intPrice];
	HouseInfo[houseid][hRentPrice] = 0;
	HouseInfo[houseid][hLevel] = 1;
	HouseInfo[houseid][hLocked] = 0;
	HouseInfo[houseid][hPosX] = x;
	HouseInfo[houseid][hPosY] = y;
	HouseInfo[houseid][hPosZ] = z;
	HouseInfo[houseid][hPosA] = angle;
	HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
	HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
	HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
	HouseInfo[houseid][hIntA] = houseInteriors[type][intA];
	HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
	HouseInfo[houseid][hWorld] = HouseInfo[houseid][hID] + 1000000;
	HouseInfo[houseid][hOutsideInt] = GetPlayerInterior(playerid);
	HouseInfo[houseid][hOutsideVW] = GetPlayerVirtualWorld(playerid);
	HouseInfo[houseid][hCash] = 0;
	HouseInfo[houseid][hMaterials] = 0;
	HouseInfo[houseid][hWeed] = 0;
	HouseInfo[houseid][hCocaine] = 0;
	HouseInfo[houseid][hHeroin] = 0;
	HouseInfo[houseid][hPainkillers] = 0;
	HouseInfo[houseid][hLabels] = 0;
	HouseInfo[houseid][hText] = Text3D:INVALID_3DTEXT_ID;
	HouseInfo[houseid][hPickup] = -1;
	HouseInfo[houseid][hDelivery] = 1;
	HouseInfo[houseid][hLights] = 1;
	Iter_Add(House, houseid);

	for(new i = 0; i < 10; i ++)
	{
	    HouseInfo[houseid][hWeapons][i] = 0;
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET world = %i WHERE id = %i", HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadHouse(houseid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created house id %i, type %i.",GetAdmCmdRank(playerid), GetRPName(playerid), houseid, HouseInfo[houseid][hType]);
	SendClientMessageEx(playerid, COLOR_GREEN, "* House %i created successfully.", houseid);
}


forward OnLoadFurniture();
public OnLoadFurniture()
{
    new
	    rows = cache_get_row_count(connectionID);

	for (new i = 0; i < rows; i ++)
	{
	    Furniture[i][fExists] = 1;
	    Furniture[i][fID] = cache_get_field_content_int(i, "fID");

	    Furniture[i][fHouseID] = cache_get_field_content_int(i, "fHouseID");
	    Furniture[i][fModel] = cache_get_field_content_int(i, "fModel");
	    Furniture[i][fSpawn][0] = cache_get_field_content_float(i, "fX");
	    Furniture[i][fSpawn][1] = cache_get_field_content_float(i, "fY");
	    Furniture[i][fSpawn][2] = cache_get_field_content_float(i, "fZ");
	    Furniture[i][fSpawn][3] = cache_get_field_content_float(i, "fRX");
	    Furniture[i][fSpawn][4] = cache_get_field_content_float(i, "fRY");
	    Furniture[i][fSpawn][5] = cache_get_field_content_float(i, "fRZ");
        Furniture[i][fInterior] = cache_get_field_content_int(i, "fInterior");
        Furniture[i][fWorld] = cache_get_field_content_int(i, "fWorld");
        Furniture[i][fCode] = cache_get_field_content_int(i, "fCode");
        Furniture[i][fMoney] = cache_get_field_content_int(i, "fMoney");

        Furniture[i][fMaterial][0] = cache_get_field_content_int(i, "Mat1");
        Furniture[i][fMaterial][1] = cache_get_field_content_int(i, "Mat2");
        Furniture[i][fMaterial][2] = cache_get_field_content_int(i, "Mat3");
        Furniture[i][fMatColour][0] = cache_get_field_content_int(i, "MatColor1");
        Furniture[i][fMatColour][1] = cache_get_field_content_int(i, "MatColor2");
        Furniture[i][fMatColour][2] = cache_get_field_content_int(i, "MatColor3");

        Furniture[i][fObject] = INVALID_OBJECT_ID;
        Furniture[i][fText] = INVALID_3DTEXT_ID;
        UpdateFurniture(i);
	}
	printf("(SQL) %i furniture loaded.", rows);
}

Dialog:DIALOG_HOUSEINTERIORS(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new houseid = GetNearbyHouseEx(playerid);

        if(houseid >= 0 && IsHouseOwner(playerid, houseid))
        {
            SetPlayerPos(playerid, houseInteriors[listitem][intX], houseInteriors[listitem][intY], houseInteriors[listitem][intZ]);
            SetPlayerFacingAngle(playerid, houseInteriors[listitem][intA]);
            SetPlayerInterior(playerid, houseInteriors[listitem][intID]);
            SetCameraBehindPlayer(playerid);

            PlayerData[playerid][pPreviewHouse] = houseid;
            PlayerData[playerid][pPreviewType] = listitem;
            PlayerData[playerid][pPreviewTime] = 60;

            SendClientMessageEx(playerid, COLOR_AQUA, "This {FF6347}%s{33CCFF} interior costs %s. You have 60 seconds to look around and make up your mind.", houseInteriors[listitem][intClass], FormatCash(houseInteriors[listitem][intPrice]));
            SendClientMessageEx(playerid, COLOR_AQUA, "Use /confirmupgrade if you wish to upgrade to this interior. Use /cancelupgrade to cancel preview mode.");
        }
    }
    return 1;
}

Dialog:DIALOG_LOCATEHOUSE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        foreach(new i : House)
        {
			if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
			{
			    SetPlayerCheckpoint(playerid, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ], 2.5);
				SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to your house.");
				PlayerData[playerid][pCP] = CHECKPOINT_MISC;
			}
		}
	}
	return 1;
}

DeleteFurnitureObject(objectid)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
    	new Text3D:textid = Text3D:Streamer_GetExtraInt(objectid, E_OBJECT_3DTEXT_ID);

        if(IsValidDynamic3DTextLabel(textid))
        {
            DestroyDynamic3DTextLabel(textid);
        }

        DestroyDynamicObject(objectid);
	}
}

RemoveAllFurniture(houseid)
{
    if(HouseInfo[houseid][hExists])
	{
		for (new i = 0; i < MAX_FURNITURE; i ++)
		{
			if (Furniture[i][fExists] && Furniture[i][fHouseID] == HouseInfo[houseid][hID])
			{
	    		DeleteFurnitureObject(Furniture[i][fObject]);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}

RemoveFurniture(objectid)
{
    if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
 		new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteFurnitureObject(objectid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM rp_furniture WHERE id = %i", id);
	    mysql_tquery(connectionID, queryBuffer);
	}
}

DisplayPlayerHousesList(playerid,target[])
{
    new targetid,useid=true;
	if(sscanf(target, "i", targetid))
		useid=false;
	else if(targetid>MAX_PLAYERS)
		return SendClientMessage(playerid,COLOR_GREY, "Unvalid player id.");

    new housestring[1064], type[16];
    housestring = "ID\tOwner\tHouse Type - Locations\tStatus";
	
    foreach(new i : House)
    {
		new displayrow=false;
		if(!HouseInfo[i][hExists])
			continue;
        if(HouseInfo[i][hType] == -1)
        {
            type = "Other";
        }
        else
        {
            strcpy(type, houseInteriors[HouseInfo[i][hType]][intClass]);
        }
		if(useid){
			displayrow = IsHouseOwner(targetid, i);
        }else 
		{
			displayrow = (strcmp(HouseInfo[i][hOwner], target, true)==0) || (!strcmp(target,"all",true,4));	
		}
		if(displayrow)
			format(housestring, sizeof(housestring), "%s\n%d\t%s\t%s - %s\t%s",housestring, i,  HouseInfo[i][hOwner],type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (HouseInfo[i][hLocked]) ? ("Locked") : ("Unlocked"));
    }
    if(strlen(housestring) > 0)
    {
		Dialog_Show(playerid, PlayerHousesList, DIALOG_STYLE_TABLIST_HEADERS, "Houses list", housestring, "Preview","Close");
    }
	return 1;
}
Dialog:PlayerHousesList(playerid, response, listitem, inputtext[])
{
	
	if (response)
	{
		new houseid;    
		new type[16];
		
		if(sscanf(inputtext,"i",houseid))
		{
			return SendClientMessage(playerid,COLOR_RED,"Can't parse house id contact an admin to fix that.");
		}
		//SendClientMessageEx(playerid,COLOR_RED,"Selected value: '%s', Parsed value: %i", inputtext, houseid);
		
		if(HouseInfo[houseid][hType] == -1)
        {
            type = "Other";
        }
        else
        {
            strcpy(type, houseInteriors[HouseInfo[houseid][hType]][intClass]);
        }
		//SendClientMessage(playerid,COLOR_RED,"Step 1");
		new liststr[1024];
		format(
			liststr, 
		sizeof(liststr),
		"hID\t %i \nOwner\t %s \nType\t %s \nPrice\t $ %i \nRentPrice\t %i \nLevel\t %i \nLocked\t %s \nAlarm\t %i \nCash\t %i \nMaterials\t %i \nWeed\t %i \nCocaine\t %i \nHeroin\t %i \nPainkillers\t %i \nDelivery\t %s   \nLights\t %s \nWeapon slot 0\t %s \nWeapon slot 1\t %s \nWeapon slot 2\t %s \nWeapon slot 3\t %s \nWeapon slot 4\t %s \nWeapon slot 5\t %s \nWeapon slot 6\t %s \nWeapon slot 7\t %s \nWeapon slot 8\t %s \nWeapon slot 9\t %s",
			HouseInfo[houseid][hID],
			HouseInfo[houseid][hOwner],
			type,
			HouseInfo[houseid][hPrice],
			HouseInfo[houseid][hRentPrice],
			HouseInfo[houseid][hLevel],
			HouseInfo[houseid][hLocked]?("Closed"):("Open"),
			HouseInfo[houseid][hAlarm],
			HouseInfo[houseid][hCash],
			HouseInfo[houseid][hMaterials],
			HouseInfo[houseid][hWeed],
			HouseInfo[houseid][hCocaine],
			HouseInfo[houseid][hHeroin],
			HouseInfo[houseid][hPainkillers],
			HouseInfo[houseid][hDelivery]?("Enabled"):("Disabled"),
			HouseInfo[houseid][hLights]?("On"):("Off"),
			HouseInfo[houseid][hWeapons][0] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][0]):("None"),
			HouseInfo[houseid][hWeapons][1] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][1]):("None"),
			HouseInfo[houseid][hWeapons][2] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][2]):("None"),
			HouseInfo[houseid][hWeapons][3] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][3]):("None"),
			HouseInfo[houseid][hWeapons][4] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][4]):("None"),
			HouseInfo[houseid][hWeapons][5] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][5]):("None"),
			HouseInfo[houseid][hWeapons][6] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][6]):("None"),
			HouseInfo[houseid][hWeapons][7] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][7]):("None"),
			HouseInfo[houseid][hWeapons][8] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][8]):("None"),
			HouseInfo[houseid][hWeapons][9] ? GetWeaponNameEx(HouseInfo[houseid][hWeapons][9]):("None")
		);
		//SendClientMessage(playerid,COLOR_RED,"Step2");
		Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST, "House status", liststr, "Ok", "");
	}
	return 1;
}
Dialog:BuyFurniture(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new houseid = GetInsideHouse(playerid);    
        if(houseid == -1)
        {
            houseid = GetFurnitureHouse(playerid);
        }

        if(houseid>=0)
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) AS furnitureCount FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);
            mysql_tquery(connectionID, queryBuffer, "CheckHouseFurnitures", "iii", playerid, houseid, listitem);
        }
	}
	return 1;
}

publish CheckHouseFurnitures(playerid, houseid, listitem)
{
    if(cache_get_row_int(0, 0) >= GetHouseFurnitureCapacity(houseid))
    {
        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]{ffffff} Your house is only allowed up to %i furniture at its current level.", GetHouseFurnitureCapacity(houseid));
    }
    else
    {
		PlayerData[playerid][pSelected] = listitem;
		ShowFurniturePreviewer(playerid);
    }
    return 1;
}

Dialog:FurnEditConfirm(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new furnitureid = GetPVarInt(playerid, "FurnID");

		switch(listitem)
		{
			case 0: EditDynamicObjectEx(playerid, EDIT_TYPE_FURNITURE, Furniture[furnitureid][fObject], furnitureid);
			case 1: ListTexture(playerid);
			case 2: 
			{//duplicate
				//search model index in available object
				new index = -1;
				for(new i = 0; i < sizeof(g_FurnitureList); i ++)
				{
					if (g_FurnitureList[i][e_ModelID] == Furniture[furnitureid][fModel])
					{
						index = i;
						break;
					}
				}
				if(index == -1)
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You cannot duplicate this object. It not used any more.");
				}
				PreviewFurniture(playerid, index);
			}
			case 3: DeleteFurniture(furnitureid);
		}
	}
	return 1;
}

OfflineSetHouseOwner(aplayerid, houseid, username[])
{
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM "#TABLE_USERS" WHERE username = '%s'", username);
    mysql_tquery(connectionID, queryBuffer, "OnOChangeHouseOwnerGotUsers", "ii",aplayerid,houseid);
}
forward OnOChangeHouseOwnerGotUsers(playerid,houseid);
public OnOChangeHouseOwnerGotUsers(playerid,houseid)
{
	new rows = cache_get_row_count(connectionID);
    if(rows)
    {
        cache_get_field_content(0, "username", HouseInfo[houseid][hOwner], connectionID, MAX_PLAYER_NAME);        

        HouseInfo[houseid][hOwnerID] = cache_get_field_content_int(0, "uid");
        HouseInfo[houseid][hTimestamp] = gettime();

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET timestamp = %i, ownerid = %i, owner = '%s' WHERE id = %i", HouseInfo[houseid][hTimestamp], HouseInfo[houseid][hOwnerID], HouseInfo[houseid][hOwner], HouseInfo[houseid][hID]);
        mysql_tquery(connectionID, queryBuffer);
        Log_Write("log_property", "%s (uid: %i) has edited house id owner to (id: %s).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hOwner]);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of house %i to %s.", houseid, HouseInfo[houseid][hOwner]);

		ReloadHouse(houseid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Unvalid username.");
    }
}