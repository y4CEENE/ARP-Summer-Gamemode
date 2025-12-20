#include "core\estates\biz\Dealership.pwn"


CMD:createbiz(playerid, params[])
{
	new type, Float:x, Float:y, Float:z, Float:a;

    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", type))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createbiz [type]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: (1) 24/7 (2) Gun Shop (3) Clothes Shop (4) Gym (5) Restaurant (6) Ad Agency (7) Club/Bar (8) Tool Shop (9) Dealership");
	    return 1;
	}
	if(!(1 <= type <= sizeof(bizInteriors)))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
	}
	if(GetNearbyBusiness(playerid) >= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is a business in range. Find somewhere else to create this one.");
	}

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	type--;

 	for(new i = 0; i < MAX_BUSINESSES; i ++)
	{
	    if(!BusinessInfo[i][bExists])
	    {
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO businesses (name,message,type,dealershiptype, price, pos_x, pos_y, pos_z, pos_a, int_x, int_y, int_z, int_a, interior, outsideint, outsidevw) VALUES('%e','Welcome, please use /buy to buy products.',%i, 0, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, %i)", GenerateBusinessName(type), type, bizInteriors[type][intPrice], x, y, z, a - 180.0,
				bizInteriors[type][intX], bizInteriors[type][intY], bizInteriors[type][intZ], bizInteriors[type][intA], bizInteriors[type][intID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateBusiness", "iiiffff", playerid, i, type, x, y, z, a);
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "Business slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:editbiz(playerid, params[])
{
	new businessid, option[20], param[32];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[20]S()[32]", businessid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Entrance, Exit, Interior, World, Type, Owner, Price, EntryFee, Products, Materials, Locked, Vehspawn, DisplayMapIcon, dstype");
	    return 1;
	}
	if(!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
	}
	
	if(!strcmp(option, "dstype", true))
	{
		if(isnull(param)){
			return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [dstype] [car/boat/plane]");
		}
		if(!strcmp(param, "car", true))
		{
			BusinessInfo[businessid][bDealerShipType] = DSCars;
		}else if(!strcmp(param, "boat", true))
		{
			BusinessInfo[businessid][bDealerShipType] = DSBoats;
		}else if(!strcmp(param, "plane", true))
		{
			BusinessInfo[businessid][bDealerShipType] = DSPlanes;
		}else{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [dstype] [car/boat/plane]");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET dealershiptype = %i WHERE id = %i", BusinessInfo[businessid][bDealerShipType], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map dealership type of business %i to %s.", businessid, param);
	}else if(!strcmp(option, "displaymapicon", true))
	{
		if(isnull(param)){
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [displaymapicon] [true/false]");
		}
		if(!strcmp(param, "true", true))
		{
			BusinessInfo[businessid][bDisplayMapIcon] = 1;
		}else if(!strcmp(param, "false", true))
		{
			BusinessInfo[businessid][bDisplayMapIcon] = 0;
		}else{
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [displaymapicon] [true/false]");
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET displaymapicon = %i WHERE id = %i", BusinessInfo[businessid][bDisplayMapIcon], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map icon state of business %i to %s.", businessid, param);
	}
	else if(!strcmp(option, "entrance", true))
	{
	    GetPlayerPos(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]);
	    GetPlayerFacingAngle(playerid, BusinessInfo[businessid][bPosA]);

	    BusinessInfo[businessid][bOutsideInt] = GetPlayerInterior(playerid);
	    BusinessInfo[businessid][bOutsideVW] = GetPlayerVirtualWorld(playerid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], BusinessInfo[businessid][bPosA], BusinessInfo[businessid][bOutsideInt], BusinessInfo[businessid][bOutsideVW], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entrance of business %i.", businessid);
	}
	else if(!strcmp(option, "vehspawn", true))
	{
		GetPlayerPos(playerid, BusinessInfo[businessid][cVehicle][0], BusinessInfo[businessid][cVehicle][1], BusinessInfo[businessid][cVehicle][2]);
		GetPlayerFacingAngle(playerid, BusinessInfo[businessid][cVehicle][3]);
		format(queryBuffer, sizeof(queryBuffer), "UPDATE `businesses` SET `cVehicleX` = %.4f, `cVehicleY` = %.4f, `cVehicleZ` = %.4f, `cVehicleA` = %.4f WHERE id = %i",
		BusinessInfo[businessid][cVehicle][0],BusinessInfo[businessid][cVehicle][1],BusinessInfo[businessid][cVehicle][2],BusinessInfo[businessid][cVehicle][3], BusinessInfo[businessid][bID]);
		mysql_tquery(connectionID, queryBuffer);
		SendAdminMessage(COLOR_RED, "Admin: %s has edited the vehicle spawn of business %i.", GetRPName(playerid), businessid);
	}
	else if(!strcmp(option, "exit", true))
	{
	    new type = -1;

	    for(new i = 0; i < sizeof(bizInteriors); i ++)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 100.0, bizInteriors[i][intX], bizInteriors[i][intY], bizInteriors[i][intZ]))
	        {
	            type = i;
			}
	    }

	    GetPlayerPos(playerid, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ]);
	    GetPlayerFacingAngle(playerid, BusinessInfo[businessid][bIntA]);

	    BusinessInfo[businessid][bInterior] = GetPlayerInterior(playerid);
		BusinessInfo[businessid][bType] = type;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", type, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the exit of business %i.", businessid);
	}
	else if(!strcmp(option, "interior", true))
	{
		new string[1024];

		for(new i = 0; i < sizeof(bizInteriorArray); i ++)
		{
		    format(string, sizeof(string), "%s\n%s", string, bizInteriorArray[i][intName]);
	    }

	    PlayerData[playerid][pSelected] = businessid;
	    Dialog_Show(playerid, DIALOG_BIZINTERIOR, DIALOG_STYLE_LIST, "Choose an interior to set for this business.", string, "Select", "Cancel");
	}
	else if(!strcmp(option, "world", true))
	{
	    new worldid;

	    if(sscanf(param, "i", worldid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [world] [vw]");
		}

		BusinessInfo[businessid][bWorld] = worldid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET world = %i WHERE id = %i", BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the virtual world of business %i to %i.", businessid, worldid);
	}
	else if(!strcmp(option, "type", true))
	{
	    new type;

	    if(sscanf(param, "i", type))
	    {
	        SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [type] [value (1-%i)]", sizeof(bizInteriors));
	        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: (1) 24/7 (2) Gun Shop (3) Clothes Shop (4) Gym (5) Restaurant (6) Ad Agency (7) Club/Bar (8) Tool Shop");
	        return 1;
		}
		if(!(1 <= type <= sizeof(bizInteriors)))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
		}

		BusinessInfo[businessid][bType] = type-1;
		BusinessInfo[businessid][bInterior] = bizInteriors[type][intID];
		BusinessInfo[businessid][bIntX] = bizInteriors[type][intX];
		BusinessInfo[businessid][bIntY] = bizInteriors[type][intY];
		BusinessInfo[businessid][bIntZ] = bizInteriors[type][intZ];
		BusinessInfo[businessid][bIntA] = bizInteriors[type][intA];
        ClearProducts(businessid);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type-1, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the type of business %i to %i.", businessid, type);
	}
	else if(!strcmp(option, "owner", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [owner] [playerid]");
		}
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
		if(!PlayerData[targetid][pLogged])
		{
		    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
		}

        SetBusinessOwner(businessid, targetid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of business %i to %s.", businessid, GetRPName(targetid));
		Log_Write("log_property", "%s (uid: %i) has edited business id owner to (id: %s).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid));

	}
	else if(!strcmp(option, "price", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [price] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
		}

		BusinessInfo[businessid][bPrice] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET price = %i WHERE id = %i", BusinessInfo[businessid][bPrice], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the price of business %i to $%i.", businessid, price);
	}
	else if(!strcmp(option, "entryfee", true))
	{
	    new price;

	    if(sscanf(param, "i", price))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [entryfee] [value]");
		}
		if(price < 0)
		{
		    return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
		}

		BusinessInfo[businessid][bEntryFee] = price;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET entryfee = %i WHERE id = %i", BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entry fee of business %i to $%i.", businessid, price);
	}
	else if(!strcmp(option, "products", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [products] [value]");
		}

		BusinessInfo[businessid][bProducts] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the products amount of business %i to %i.", businessid, amount);
	}
	else if(!strcmp(option, "materials", true))
	{
	    new amount;

	    if(sscanf(param, "i", amount))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [materials] [value]");
		}

		BusinessInfo[businessid][bMaterials] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET materials = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the materials amount of business %i to %i.", businessid, amount);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [locked] [0/1]");
		}

		BusinessInfo[businessid][bLocked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[businessid][bLocked], BusinessInfo[businessid][bID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadBusiness(businessid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of business %i to %i.", businessid, locked);
	}

	return 1;
}

CMD:removebiz(playerid, params[])
{
	new businessid;

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removebiz [businessid]");
	}
	if(!(0 <= businessid < MAX_HOUSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
	}

    ClearProducts(businessid);
	DestroyDynamic3DTextLabel(BusinessInfo[businessid][bText]);
	DestroyDynamicPickup(BusinessInfo[businessid][bPickup]);
	if(BusinessInfo[businessid][bDisplayMapIcon])
		DestroyDynamicMapIcon(BusinessInfo[businessid][bMapIcon]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM businesses WHERE id = %i", BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	BusinessInfo[businessid][bExists] = 0;
	BusinessInfo[businessid][bID] = 0;
	BusinessInfo[businessid][bOwnerID] = 0;
	Iter_Remove(Business, businessid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has removed business id %i.", GetRPName(playerid), businessid);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed business %i.", businessid);
	return 1;
}

CMD:ochangebizowner(playerid, params[])
{
    new businessid, username[32];

	if(PlayerData[playerid][pAdmin] < ASST_MANAGEMENT && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[20]S()[32]", businessid, username))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ochangebizowner [businessid] [username]");
	    return 1;
	}
	if(!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid business id.");
	}
	
    OfflineSetBusinessOwner(playerid,businessid,username);    
    return 1;
}
CMD:gotobiz(playerid, params[])
{
	new businessid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN && !PlayerData[playerid][pWebDev])
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", businessid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotobiz [businessid]");
	}
	if(!(0 <= businessid < MAX_HOUSES) || !BusinessInfo[businessid][bExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
	}

	GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

	SetPlayerPos(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]);
	SetPlayerFacingAngle(playerid, BusinessInfo[businessid][bPosA]);
	SetPlayerInterior(playerid, BusinessInfo[businessid][bOutsideInt]);
	SetPlayerVirtualWorld(playerid, BusinessInfo[businessid][bOutsideVW]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

CMD:bizhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** BUSINESS HELP ** type a command for more information.");
	SendClientMessage(playerid, COLOR_GREY, "** BUSINESS ** /buybiz /sellbiz /sellmybiz /lock /entryfee ");
	SendClientMessage(playerid, COLOR_GREY, "** BUSINESS ** /bizmenu /bwithdraw /bdeposit /bdepositmats /bwithdrawmats /bname");
	return 1;
}

CMD:buybiz(playerid, params[])
{
	//return SendClientMessage(playerid, COLOR_GREY, "This command has been disabled, if you want to buy a business you must request it on our forums");
	new businessid;
	if((businessid = GetNearbyBusiness(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no business in range. You must be near a business.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buybiz [confirm]");
	}
	if(BusinessInfo[businessid][bOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This business already has an owner.");
	}
	if(PlayerData[playerid][pCash] < BusinessInfo[businessid][bPrice])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this business.");
	}
    if(GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) >= GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES))
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i businesses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
	}

	SetBusinessOwner(businessid, playerid);
	GivePlayerCash(playerid, -BusinessInfo[businessid][bPrice]);

	SendClientMessageEx(playerid, COLOR_GREEN, "You paid $%i for this %s. /bizhelp for a list of commands.", BusinessInfo[businessid][bPrice], bizInteriors[BusinessInfo[businessid][bType]][intType]);
    Log_Write("log_property", "%s (uid: %i) purchased %s (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], BusinessInfo[businessid][bPrice]);
	return 1;
}

CMD:bwithdraw(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bwithdraw [amount] (%s available)", FormatCash(BusinessInfo[businessid][bCash]));
	}
	if(amount < 1 || amount > BusinessInfo[businessid][bCash])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}

	BusinessInfo[businessid][bCash] -= amount;
	GivePlayerCash(playerid, amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %s from the business vault. There is now %s remaining.", FormatCash(amount), FormatCash(BusinessInfo[businessid][bCash]));
	return 1;
}

CMD:bdeposit(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bdeposit [amount] (%s available)", FormatCash(BusinessInfo[businessid][bCash]));
	}
	if(amount < 1 || amount > PlayerData[playerid][pCash])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(PlayerData[playerid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
	}

	BusinessInfo[businessid][bCash] += amount;
	GivePlayerCash(playerid, -amount);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %s in the business vault. There is now %s available.", FormatCash(amount), FormatCash(BusinessInfo[businessid][bCash]));
	return 1;
}

CMD:bwithdrawmats(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
	}
	if(BusinessInfo[businessid][bType] != BUSINESS_TOOLSHOP)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command can only be used in tool shops.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bwithdrawmats [amount] (%i available)", BusinessInfo[businessid][bMaterials]);
	}
	if(amount < 1 || amount > BusinessInfo[businessid][bMaterials])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
	}

	BusinessInfo[businessid][bMaterials] -= amount;
	PlayerData[playerid][pMaterials] += amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET materials = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i materials from the business vault. There is now %i remaining.", amount, BusinessInfo[businessid][bMaterials]);
	return 1;
}

CMD:bdepositmats(playerid, params[])
{
	new businessid = GetInsideBusiness(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
	}
	if(BusinessInfo[businessid][bType] != BUSINESS_TOOLSHOP)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command can only be used in tool shops.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bdepositmats [amount] (%i available)", BusinessInfo[businessid][bMaterials]);
	}
	if(amount < 1 || amount > PlayerData[playerid][pMaterials])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}

	BusinessInfo[businessid][bMaterials] += amount;
	PlayerData[playerid][pMaterials] -= amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET materials = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i materials in the business vault. There is now %i available.", amount, BusinessInfo[businessid][bMaterials]);
	return 1;
}

CMD:sellbiz(playerid, params[])
{
	new businessid = GetNearbyBusinessEx(playerid), targetid, amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
	}
	if(sscanf(params, "ui", targetid, amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellbiz [playerid] [amount]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
	}
	if(amount < 1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
	}

	PlayerData[targetid][pBizOffer] = playerid;
	PlayerData[targetid][pBizOffered] = businessid;
	PlayerData[targetid][pBizPrice] = amount;

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their business for %s (/accept business).", GetRPName(playerid), FormatCash(amount));
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your business for %s.", GetRPName(targetid), FormatCash(amount));
	return 1;
}

CMD:sellmybiz(playerid, params[])
{
	new businessid = GetNearbyBusinessEx(playerid);

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmybiz [confirm]");
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your business back to the state. You will receive %s back.", FormatCash(percent(BusinessInfo[businessid][bPrice], 75)));
	    return 1;
	}

	SetBusinessOwner(businessid, INVALID_PLAYER_ID);
	GivePlayerCash(playerid, percent(BusinessInfo[businessid][bPrice], 75));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your business to the state and received %s back.", FormatCash(percent(BusinessInfo[businessid][bPrice], 75)));
    Log_Write("log_property", "%s (uid: %i) sold their %s business (id: %i) to the state for %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], percent(BusinessInfo[businessid][bPrice], 75));
	return 1;
}

CMD:biz(playerid, params[])
{
    return callcmd::bizmenu(playerid, params);
}

CMD:bizmenu(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid);

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
	}
	
	new string[256];
	new title[50];

    format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
	format(string,sizeof(string), " Informations\n Change Name\n Change message\n Change entry fees\n %s\n Deposit money\n Withdraw money\n Deposit materials\n Withdraw marterials",(BusinessInfo[businessid][bLocked]) ? ("Open the business") : ("Close the business"));
	Dialog_Show(playerid, DIALOG_BUSINESSMENU, DIALOG_STYLE_LIST, title, string, "Ok", "Cancel"); 
	
	return 1;
}


CMD:buy(playerid, params[])
{
	if( IsPlayerInAnyVehicle( playerid ) ) 
		return SendClientMessage( playerid, COLOR_GREY, "You cant purchase from a vehicle." );
	if(IsPlayerAtFoodPlace(playerid))
    	return ShowDialogToPlayer(playerid, DIALOG_FOOD);
 	
	if(PlayerData[playerid][pNotoriety] >= 10000)
		return SendClientMessageEx(playerid, COLOR_GREY, "You're way too notorious dude, I'm not doing business with a well known criminal. Get outta here fool!");
	
	new businessid = GetInsideBusiness(playerid), title[64];

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any business where you can buy stuff.");
	}

	format(title, sizeof(title), "%s's %s [%i products]", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

	switch(BusinessInfo[businessid][bType])
	{
	    case BUSINESS_DEALERSHIP:
	    {
            PlayerData[playerid][pDealership] = 0;
			ShowDealerShipInterface(playerid);
		}
	    case BUSINESS_STORE:
	    {
		//						       ID   model     name              price				  max stack
			MenuStore_AddItem(playerid, 1, 	18874, 	"Mobile Phone",		600);
			MenuStore_AddItem(playerid, 2, 	330, 	"Portable Radio",	5000);
			MenuStore_AddItem(playerid, 3, 	19625, 	"Cigarette",		25,		"", 0.0, true,	 20);
			MenuStore_AddItem(playerid, 4, 	365, 	"Spraycan", 		80,		"", 0.0, true,	 20);
			MenuStore_AddItem(playerid, 5, 	1718,	"Phonebook",		250);
			MenuStore_AddItem(playerid, 6, 	367, 	"Camera", 			300);
			MenuStore_AddItem(playerid, 7, 	19617, 	"MP3 Player",		5000);
			MenuStore_AddItem(playerid, 8, 	18632, 	"Fishing Rod",		1000);
			MenuStore_AddItem(playerid, 9, 	19063, 	"Fish bait", 		100,	"", 0.0, true,	 20);
			MenuStore_AddItem(playerid, 10,	19823, 	"Muriatic Acid", 	1500,	"", 0.0, true,	 10);
			MenuStore_AddItem(playerid, 11, 2709, 	"Baking Soda", 		1200,	"", 0.0, true,	 10);
			MenuStore_AddItem(playerid, 12, 19039, 	"Pocket Watch", 	1000);
			MenuStore_AddItem(playerid, 13, 19167, 	"GPS System", 		10000);
			MenuStore_AddItem(playerid, 14, 1650, 	"Gasoline Can", 	500,	"", 0.0, true,	 20);
			MenuStore_AddItem(playerid, 15, 19088, 	"Rope",		 		100,	"", 0.0, true,	 10);
			MenuStore_AddItem(playerid, 16, 18912, 	"Blindfold", 		1000,	"", 0.0, true,	 10);
			MenuStore_AddItem(playerid, 17,	322, 	"Condom", 		    20,		"", 0.0, true,	 20);
			MenuStore_Show(playerid, Menu_Market, "24/7 Supermarket");
	        /*Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Mobile phone ($600)\nPrivate radio ($300)\nCigars ($500)\nSpraycans ($100)\nCamera ($200)\nMP3 player ($50)\nFishing rod ($50)\nFish bait ($300)\nMuriatic acid ($300)\nBaking soda ($30)\nPocket watch ($600)\nGPS system ($150)\nGasoline can ($70)\nRope ($40)\nBoombox ($300)\nBlindfold rag($30)\nPhonebook($250)", "Select", "Cancel");*/
		}
		case BUSINESS_GUNSHOP:
		{
			MenuStore_AddItem(playerid, 1, 	346, 	"9mm pistol",		1500);
			MenuStore_AddItem(playerid, 2, 	349, 	"Shotgun",			6000,  "", 0, true,1, 0.0,0.0,70.0,2.2);
			MenuStore_AddItem(playerid, 3, 	357, 	"Country rifle",	24000, "", 0, true,1, 0.0,0.0,70.0,2.2);
			MenuStore_AddItem(playerid, 4, 	1242, 	"Light armor", 		3000);
			MenuStore_AddItem(playerid, 5, 	19515,	"Medium Armor",		6000,  "", 0, true,1, 0.0,270.0,0.0,1.0);
			MenuStore_Show(playerid, Menu_GunStore, "GunStore");
		    //Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "9mm pistol ($15000)\nShotgun ($25000)\nRifle ($40000)\nLight armor ($15000)\nMedium Armor($25000)", "Select", "Cancel");
		}
		case BUSINESS_CLOTHES:
		{
		    Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Clothes ($1000)\nGlasses ($500)\nBandanas & masks ($375)\nHats & caps ($240)\nMisc clothing ($500)", "Select", "Cancel");
		}
		case BUSINESS_GYM:
		{
		    Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Normal (Free)\nBoxing ($4725)\nKung Fu ($7650)\nKneehead ($9275)\nGrabkick ($1250)\nElbow ($2950)", "Select", "Cancel");
		}
		case BUSINESS_RESTAURANT:
		{ 
			MenuStore_AddItem(playerid, 1, 	19570, 	"Water",							  30);
			MenuStore_AddItem(playerid, 2, 	2601, 	"Sprunk",							  50);
			MenuStore_AddItem(playerid, 3, 	2769,	"Club sandwich",					  80);
			MenuStore_AddItem(playerid, 4, 	2218, 	"A tray of pizza",					  90, "", 0, true,1, 0.0,0.0,210.0,2.2);
			MenuStore_AddItem(playerid, 5, 	2219,	"Tray with lots of food",			 100, "", 0, true,1, 0.0,0.0,230.0,2.2);
			MenuStore_AddItem(playerid, 6, 	2221,	"Tray with coffee and two muffins",	 100, "", 0, true,1, 315.0,0.0,0.0,1);
			MenuStore_AddItem(playerid, 7, 	2703, 	"Hamburger", 						 120, "", 0, true,1, 0.0,0.0,100.0,1.0);
			MenuStore_AddItem(playerid, 8, 	2768,	"Cluckin bell burger",				 125);
			MenuStore_AddItem(playerid, 9, 	2814,	"Pizza",							 200, "", 0, true,1, 90.0,180.0, 0.0,1.0);
			MenuStore_Show(playerid, Menu_Restaurant, "Restaurant");
		    //Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Water ($10)\nSprunk ($30)\nFrench fries ($40)\nHamburger ($40)\nCheeseburger ($50)\nMac & cheese ($60)\nClub sandwich ($70)\nFish & chips ($80)\nPan pizza ($110)", "Select", "Cancel");
		}
		case BUSINESS_BARCLUB:
		{
			MenuStore_AddItem(playerid, 1, 	19570, 	"Water",	 50);
			MenuStore_AddItem(playerid, 2, 	2601, 	"Sprunk",	 80);
			MenuStore_AddItem(playerid, 3, 	1544,	"Beer",		100);
			MenuStore_AddItem(playerid, 4, 	1520, 	"Wine",		500);
			MenuStore_AddItem(playerid, 5, 	1512,	"Whiskey", 1000);
			MenuStore_Show(playerid, Menu_Bar, "Bar");
		    //Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Water ($10)\nSprunk ($30)\nBeer ($45)\nWine ($300)\nWhiskey ($500)", "Select", "Cancel");
		}
		case BUSINESS_TOOLSHOP:
		{
			MenuStore_AddItem(playerid, 1, 	11736, 	"First aid kit",	 500, "", 0, true,1, 90.0, 0.0, 0.0,1.0);
			MenuStore_AddItem(playerid, 2, 	19921, 	"Body repair kit",	1000, "", 0, true,1, 45.0,45.0, 0.0,1.5);
			MenuStore_AddItem(playerid, 3, 	3031,	"Police scanner",	5000);
			MenuStore_AddItem(playerid, 4, 	1074, 	"Rimkit",			1500, "", 0, true,1, 0.0,0.0, 90.0,1.0);
			MenuStore_AddItem(playerid, 5, 	18977,	"Helmet",			 500, "", 0, true,1, 0.0,0.0, 90.0,1.0);
			MenuStore_AddItem(playerid, 6, 	18634,	"Crowbar",			5000, "", 0, true,1, 0.0,0.0, 90.0,1.0);
			MenuStore_AddItem(playerid, 7, 	1615,	"House Alarm",	   50000, "", 0, true,1, 0.0,0.0, 270.0,1.0);			

			//MenuStore_AddItem(playerid, 8, 	1512,	"Vehicle command",	5000);
			MenuStore_Show(playerid, Menu_ToolShop, "Tool Shop","Mat ");
		    //Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST_HEADERS, title, "Item\tCost\nFirst aid kit\t1000 materials\nBody repair kit\t10000 materials\nPolice scanner\t5000 materials\nRimkit\t4000 materials\nHelmet\t500 materials\nHouse Alarm\t2500 materials\nAuto Vehicle CMD\t4500 materials\nCrowbar\t2500 Materials", "Select", "Cancel");
		}

	}

	return 1;
}


CMD:entryfee(playerid, params[])
{
	new businessid = GetNearbyBusinessEx(playerid), amount;

	if(businessid == -1 || !IsBusinessOwner(playerid, businessid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /entryfee [amount]");
	}
	if(amount < 0 || amount > 300)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The entry fee can't be below $0 or above $300.");
	}

	BusinessInfo[businessid][bEntryFee] = amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET entryfee = %i WHERE id = %i", BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBusiness(businessid);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the entry fee to $%i.", amount);
	return 1;
}

