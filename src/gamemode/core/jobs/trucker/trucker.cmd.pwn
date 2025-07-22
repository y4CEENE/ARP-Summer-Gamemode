CMD:canceltruck(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_TRUCKER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a trucker.");
	}
	CancelTruckDelivery(playerid);
	return SendClientMessage(playerid, COLOR_GREY, "You have canceled the goods delivery.");
}

CMD:loadtruck(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_TRUCKER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a trucker.");
	}
	if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
		return SendClientMessage(playerid, COLOR_AQUA, "Trucker: Make sure you dont have any checkpoint. Use /kcp to clear current checkpoints.");
	}
	//TODO CHECK BIG TRUCK TRAIL AND ID
	if(!((truckerVehicles[0] <= GetPlayerVehicleID(playerid) <= truckerVehicles[29]) &&  GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a valid truck.");
	}
	if(truckersGoods[GetTruckIndex(playerid)][pGoodType] != tNone)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Truck already have goods in. Use /canceltruck to cancel delivery.");
	}
	if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)) && GetVehicleModel(GetPlayerVehicleID(playerid)) == 515){
		return SendClientMessage(playerid, COLOR_GREY, "Trailer is not attached to vehicle.");
	}
	SetPlayerCheckpoint(playerid, 2197.1211, -2660.5928, 13.5469, 5.0);
    PlayerData[playerid][pCP] = CHECKPOINT_TRUCKDELIVERY;
	return 1;
}

CMD:delivertruck(playerid, params[])
{
	new businessid, truckidx;
	if(!PlayerHasJob(playerid, JOB_TRUCKER))
	{
		CancelTruckDelivery(playerid);
		return SendClientMessage(playerid, COLOR_AQUA, "Trucker: Delivery canceled as you are not a trucker.");
	}
	if(GetJobLevel(playerid,JOB_TRUCKER)<5)
	{
		return SendClientMessage(playerid, COLOR_AQUA, "Trucker: You can't use this command as you are not a master trucker.");	
	}
	if(!(truckerVehicles[0] <= GetPlayerVehicleID(playerid)<= truckerVehicles[29] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
	{
		CancelTruckDelivery(playerid);
	    return SendClientMessage(playerid, COLOR_GREY, "Delivery canceled as you are not driving a valid truck.");
	}
	truckidx = GetTruckIndex(playerid);
	if(truckersGoods[truckidx][pGoodType] == tNone)
	{
		CancelTruckDelivery(playerid);
	    return SendClientMessage(playerid, COLOR_GREY, "You have no shipment loaded which you can deliver.");
	}
	if((businessid = GetNearbyBusiness(playerid, 7.0)) == -1 || !IsValidBizGoods(businessid, truckersGoods[truckidx][pGoodType]))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of a business which accepts this type of load.");
	}

	if(gettime() - PlayerData[playerid][pLastLoad] < 20 && PlayerData[playerid][pAdmin] < JUNIOR_ADMIN && !PlayerData[playerid][pKicked])
    {
        PlayerData[playerid][pACWarns]++;

        if(PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport delivering (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerData[playerid][pLastLoad]);
		}
		else
		{
		    BanPlayer(playerid, "Teleport delivering");
		}
    }

	BusinessInfo[businessid][bProducts] += (GetJobLevel(playerid, JOB_TRUCKER) * 2) + 10;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	mysql_tquery(connectionID, queryBuffer);
	DisablePlayerCheckpoint(playerid);
	truckersGoods[truckidx][pGoodType] = tNone;
	PlayerData[playerid][pCP] = CHECKPOINT_TRUCKDELIVERY;
	SetPlayerCheckpoint(playerid, 2224.3040,-2635.5708,13.4350, 5);
	SendClientMessage(playerid, COLOR_AQUA, "Trucker: You delivered the goods return back to dock to get your paid.");
	return 1;
}


CMD:tcheck(playerid,params[])
{
	new truckid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if((truckid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!((truckerVehicles[0] <= truckid <= truckerVehicles[29])))
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can check only trucks.");
	}
	
	new truckindex=-1;
	for(new i=0;i<30;i++){
		if( truckid == truckerVehicles[i])
		{
			truckindex=i;
			break;
		}
	}
	if(truckindex == -1){
		return SendClientMessage(playerid, COLOR_RED, "There is an internal error contact Khalil_Zoldyck to fix that.");
	}
	
	new TruckerGoodsType:goodtype = truckersGoods[truckindex][pGoodType];
	if(goodtype == tNone)
		return SendClientMessageEx(playerid, COLOR_YELLOW3, "The trucker TR%d is empty.", truckid);

	new Float:DeliveryKm, string[128], str[1024];
	
	// Work out the Distance in KM Between Depot's
	new Float:PosXa, Float:PosYa, Float:PosZa;
	new Float:DPosXa, Float:DPosYa, Float:DPosZa;
	GetPlayerPos(playerid, PosXa, PosYa, PosZa);
	DPosXa = truckersGoods[truckindex][pTDPosX];
	DPosYa = truckersGoods[truckindex][pTDPosY];
	DPosZa = truckersGoods[truckindex][pTDPosZ];
	DeliveryKm = GetDistanceBetweenPoints(PosXa, PosYa, PosZa, DPosXa, DPosYa, DPosZa);
	DeliveryKm = floatdiv(DeliveryKm, 100);
	new bid=truckersGoods[truckindex][pBizID];
	
	format(string,sizeof(string),"Delivery Destination: %s's %s\n", BusinessInfo[bid][bOwner], bizInteriors[BusinessInfo[bid][bType]][intType]);
	strcat(str, string);
	format(string,sizeof(string),"Delivery Goods: %s\n", GoodsTypeString[goodtype]);
	strcat(str, string);
	format(string,sizeof(string),"Estimated Distance Remaining: %.2f Km\n\n", DeliveryKm);
	strcat(str, string);
	strcat(str, "{FF0000}A marker has been set to the Delivery Location on your GPS.\n");
	//strcat(str, "{FFFFFF}Deliver the goods with minimal damage and do not get caught speeding.\n\n");
	//strcat(str, "Use /unloadtrailer to unload your goods when you have reached the destination.");
	Dialog_Show(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}Delivery Information", str, "Ok", "Cancel");	
	
	return 1;
}

CMD:deliveryinfo(playerid, params[])
{
	new truckid = GetPlayerVehicleID(playerid);
	if(!((truckerVehicles[0] <= truckid <= truckerVehicles[29]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
	{
		return SendClientMessage(playerid, COLOR_GREY, "Trucker: You need to use truck to check delivery info.");
	}
	new truckindex = GetTruckIndex(playerid);
	new TruckerGoodsType:goodtype = truckersGoods[truckindex][pGoodType];
	if(goodtype == tNone)
		return SendClientMessageEx(playerid, COLOR_YELLOW3, "Trucker: The trucker TR%d is empty.", truckid);

	new Float:DeliveryKm, string[128], str[1024];
	
	// Work out the Distance in KM Between Depot's
	new Float:PosXa, Float:PosYa, Float:PosZa;
	new Float:DPosXa, Float:DPosYa, Float:DPosZa;
	GetPlayerPos(playerid, PosXa, PosYa, PosZa);
	DPosXa = truckersGoods[truckindex][pTDPosX];
	DPosYa = truckersGoods[truckindex][pTDPosY];
	DPosZa = truckersGoods[truckindex][pTDPosZ];
	DeliveryKm = GetDistanceBetweenPoints(PosXa, PosYa, PosZa, DPosXa, DPosYa, DPosZa);
	DeliveryKm = floatdiv(DeliveryKm, 100);
	new bid=truckersGoods[truckindex][pBizID];
	
	format(string,sizeof(string),"Delivery Destination: %s's %s\n", BusinessInfo[bid][bOwner], bizInteriors[BusinessInfo[bid][bType]][intType]);
	strcat(str, string);
	format(string,sizeof(string),"Delivery Goods: %s\n", GoodsTypeString[goodtype]);
	strcat(str, string);
	format(string,sizeof(string),"Estimated Distance Remaining: %.2f Km\n\n", DeliveryKm);
	strcat(str, string);
	strcat(str, "{FF0000}A marker has been set to the Delivery Location on your GPS.\n");
	//strcat(str, "{FFFFFF}Deliver the goods with minimal damage and do not get caught speeding.\n\n");
	//strcat(str, "Use /unloadtrailer to unload your goods when you have reached the destination.");
	Dialog_Show(playerid, 1, DIALOG_STYLE_MSGBOX, "{FFFFFF}Delivery Information", str, "Ok", "Cancel");	
	   
	return 1;
}
