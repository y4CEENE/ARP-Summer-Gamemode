#include <YSI\y_hooks>

hook OnLoadGameMode(timestamp)
{
    //Protection from water
	CreateDynamicObject(973,2275.0000000,-2646.0000000,13.4700000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(973,2275.0000000,-2634.0000000,13.4700000,0.0000000,0.0000000,90.0000000); //

    // Job vehicles
	truckerTrailers[0] = AddStaticVehicleEx(584, 2204.0000, -2570.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[1] = AddStaticVehicleEx(584, 2204.0000, -2577.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[2] = AddStaticVehicleEx(584, 2204.0000, -2584.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[3] = AddStaticVehicleEx(591, 2204.0000, -2591.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[4] = AddStaticVehicleEx(591, 2204.0000, -2598.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[5] = AddStaticVehicleEx(591, 2204.0000, -2605.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[6] = AddStaticVehicleEx(450, 2204.0000, -2612.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[7] = AddStaticVehicleEx(450, 2204.0000, -2619.0000, 14.2100, 270.6325, 1, 1, 300);
	truckerTrailers[8] = AddStaticVehicleEx(450, 2204.0000, -2626.0000, 14.2100, 270.6325, 1, 1, 300);
	
	truckerVehicles[0] = AddStaticVehicleEx(515, 2214.0000, -2570.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[1] = AddStaticVehicleEx(515, 2214.0000, -2577.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[2] = AddStaticVehicleEx(515, 2214.0000, -2584.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[3] = AddStaticVehicleEx(515, 2214.0000, -2591.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[4] = AddStaticVehicleEx(515, 2214.0000, -2598.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[5] = AddStaticVehicleEx(515, 2214.0000, -2605.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[6] = AddStaticVehicleEx(515, 2214.0000, -2612.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[7] = AddStaticVehicleEx(515, 2214.0000, -2619.0000, 14.5600, 266.5413, 24, 77, 300);
	truckerVehicles[8] = AddStaticVehicleEx(515, 2214.0000, -2626.0000, 14.5600, 266.5413, 24, 77, 300);	
	truckerVehicles[9] = AddStaticVehicleEx(499, 2199.8328, -2635.7996, 13.5371, 179.5872, 109, 32, 300); // Truck Benson 499
	truckerVehicles[10] = AddStaticVehicleEx(499, 2203.1555, -2635.6226, 13.5368, 176.9725, 10, 32, 300);  // Truck Benson 499
	truckerVehicles[11] = AddStaticVehicleEx(499, 2206.3535, -2635.7681, 13.5370, 177.6161, 112, 32, 300); // Truck Benson 499
	truckerVehicles[12] = AddStaticVehicleEx(499, 2210.6143, -2636.2859, 13.5361, 176.3115, 30, 44, 300);  // Truck Benson 499
	truckerVehicles[13] = AddStaticVehicleEx(456, 2269.7498, -2677.2861, 13.7463, 90.0000, 91, 63, 300); // Truck Yankee	456
	truckerVehicles[14] = AddStaticVehicleEx(456, 2269.7979, -2682.0850, 13.7374, 90.0000, 102, 65, 300); // Truck Yankee	456
	truckerVehicles[15] = AddStaticVehicleEx(456, 2269.7466, -2686.7996, 13.7285, 90.0000, 105, 72, 300); // Truck Yankee	456
	truckerVehicles[16] = AddStaticVehicleEx(456, 2269.4836, -2691.5762, 13.7215, 90.0000, 110, 93, 300); // Truck Yankee	456
	truckerVehicles[17] = AddStaticVehicleEx(456, 2269.5667, -2696.6912, 13.7195, 90.0000, 121, 93, 300); // Truck Yankee	456
	truckerVehicles[18] = AddStaticVehicleEx(456, 2263.5000, -2633.0000, 13.7700, 90.0000, 84, 63, 300); // Truck Yankee	456
	truckerVehicles[19] = AddStaticVehicleEx(456, 2263.5000, -2638.0000, 13.7700, 90.0000, 91, 63, 300); // Truck Yankee	456
	truckerVehicles[20] = AddStaticVehicleEx(456, 2263.5000, -2644.0000, 13.7700, 90.0000, 102, 65, 300); // Truck Yankee	456
	truckerVehicles[21] = AddStaticVehicleEx(456, 2263.5000, -2650.0000, 13.7700, 90.0000, 105, 72, 300); // Truck Yankee	456
	truckerVehicles[22] = AddStaticVehicleEx(414, 2257.3523, -2682.3057, 13.6433, 350.0000, 67, 1, 300); // Truck Mule	414
	truckerVehicles[23] = AddStaticVehicleEx(414, 2252.7095, -2681.8508, 13.6448, 350.0000, 72, 1, 300); // Truck Mule	414
	truckerVehicles[24] = AddStaticVehicleEx(414, 2247.4028, -2681.4333, 13.6454, 350.0000, 9, 1, 300); // Truck Mule	414
	truckerVehicles[25] = AddStaticVehicleEx(414, 2242.8108, -2681.2217, 13.6456, 350.0000, 95, 1, 300); // Truck Mule	414
	truckerVehicles[26] = AddStaticVehicleEx(414, 2238.7466, -2680.8579, 13.6434, 350.0000, 24, 1, 300); // Truck Mule	414
	truckerVehicles[27] = AddStaticVehicleEx(414, 2233.0193, -2680.2834, 13.6398, 350.0000, 25, 1, 300); // Truck Mule	414
	truckerVehicles[28] = AddStaticVehicleEx(414, 2228.7241, -2680.5317, 13.6357, 350.0000, 28, 1, 300); // Truck Mule	414
	truckerVehicles[29] = AddStaticVehicleEx(414, 2224.2751, -2680.6360, 13.6348, 350.0000, 43, 1, 300); // Truck Mule	414
    return 1;
}


IsValidBizGoods(bizid,TruckerGoodsType:goodtype){
	new TruckerGoodsType:srcgoodtype=goodtype;
	if(srcgoodtype>tLegalMat)
		srcgoodtype = tIllegalGoods;
	//SendClientMessageEx(0,COLOR_RED,"IsValidBizGoods biztype(%d) (%s)",BusinessInfo[bizid][bType],
	//GoodsTypeString[srcgoodtype]);
	
	switch(BusinessInfo[bizid][bType])
	{
		case BUSINESS_STORE:{
			return (srcgoodtype == tLegal24_7Items);
		}
		case BUSINESS_GUNSHOP:{
			return (srcgoodtype == tIllegalGoods);

		}
		case BUSINESS_CLOTHES:{
			return (srcgoodtype == tLegalClothing);
		}
		case BUSINESS_RESTAURANT:{
			return (srcgoodtype == tLegalFood);
		}
		case BUSINESS_BARCLUB:{
			return (srcgoodtype == tLegalFood);
		}
		case BUSINESS_GYM:{
			return (srcgoodtype == tLegalMat);
		}
		case BUSINESS_AGENCY:{
			return (srcgoodtype == tLegalMat);
		}
		case BUSINESS_TOOLSHOP:{
			return (srcgoodtype == tLegalMat) || (srcgoodtype==tIllegalGoods);
		}
	}
	return false ;
}
TruckerFindBiz(TruckerGoodsType:goodtype)
{
	new checkcount=0;
	new bizid;
	do{
		do{
			bizid = random(MAX_BUSINESSES);
		}while(!BusinessInfo[bizid][bExists]);
		
		checkcount++;
		
	}while(!(IsValidBizGoods(bizid,goodtype) && BusinessInfo[bizid][bProducts] < 1000) && (checkcount<30));
	
	if(checkcount==30)
	{
		return -1;
	}
	return bizid;

}
GetTruckIndex(playerid){
	
		for(new i=0;i<30;i++){
			if( GetPlayerVehicleID(playerid) == truckerVehicles[i])
			{
				return i;
			}
		}
		return -1;
}
CancelTruckDelivery(playerid)
{
	if((truckerVehicles[0] <= GetPlayerVehicleID(playerid) <= truckerVehicles[29]) &&  GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		truckersGoods[GetTruckIndex(playerid)][pGoodType] = tNone;
		
	DisablePlayerCheckpoint(playerid);
    PlayerData[playerid][pCP] = CHECKPOINT_NONE;	
}
Dialog:DIALOG_PICKLOAD_ILLEGAL(playerid, response, listitem, inputtext[])
{
	
    if(response)
    {
		new truckindex=GetTruckIndex(playerid);
		new deliverytype[12];
		
		
		new bizid=-1;
        switch(listitem)
		{
		    case 0:
		    {
				strcat(deliverytype, "Weapons");
		        truckersGoods[truckindex][pGoodType] = tIllegalWeapons;		
				PlayerData[playerid][pTruckerGoodType]=tIllegalWeapons;

				/*new PlayerBar:bar1 = CreatePlayerProgressBar(playerid, 310.0, 200.0, 50.0, 10.0, 0x11acFFFF, 10.0, BAR_DIRECTION_LEFT);*/
            }
            case 1:
		    {
				strcat(deliverytype, "Drugs");
				truckersGoods[truckindex][pGoodType] = tIllegalDrugs;	
				PlayerData[playerid][pTruckerGoodType]=tIllegalDrugs;
            }
            case 2:
		    {
				strcat(deliverytype, "Illegal materials");
				truckersGoods[truckindex][pGoodType] = tIllegalMaterials;
				PlayerData[playerid][pTruckerGoodType]=tIllegalMaterials;
            }
			default:
			{
				return SendClientMessage(playerid, COLOR_RED, "ERROR: Unknow menu item");
			}
    	}
		
		bizid = TruckerFindBiz(tIllegalGoods);
		if(bizid == -1){
			CancelTruckDelivery(playerid);
			return SendClientMessageEx(playerid, COLOR_AQUA, "There is no available stores that need goods of type %s.",deliverytype);
		}
		SendClientMessageEx(playerid, COLOR_AQUA, "Please wait a moment while the truck is being loaded with %s....",deliverytype);
		truckersGoods[truckindex][pBizID] =bizid;
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){
			truckersGoods[truckindex][pTrailerID] = GetVehicleTrailer(GetPlayerVehicleID(playerid));
		}else truckersGoods[truckindex][pTrailerID] = -1;
		truckersGoods[truckindex][pTDPosX]=BusinessInfo[bizid][bPosX];
		truckersGoods[truckindex][pTDPosY]=BusinessInfo[bizid][bPosY];
		truckersGoods[truckindex][pTDPosZ]=BusinessInfo[bizid][bPosZ];
		
		GameTextForPlayer(playerid, "Loading Goods....~n~Please wait.", 5000, 3);
		TogglePlayerControllableEx(playerid, 0);
		SetTimerEx("truckerwait", 5000, false, "i", playerid);
		DisablePlayerCheckpoint(playerid);
		
		PlayerData[playerid][pLastLoad] = gettime();
    }else{
		CancelTruckDelivery(playerid);
	}
    return 1;
}
Dialog:DIALOG_PICKLOAD_LEGAL(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		new truckindex = GetTruckIndex(playerid);
		new deliverytype[12];
		new TruckerGoodsType:goodtype;
		
        switch(listitem)
		{
		    case 0:{
				strcat(deliverytype, "Food & beverages");
		        goodtype = tLegalFood;
            }
            case 1:{
				strcat(deliverytype, "Clothing");
				goodtype = tLegalClothing;
            }
            case 2:{
				strcat(deliverytype, "Materials");
				goodtype = tLegalMat;
            }
			case 3:{
				strcat(deliverytype, "24/7 Items");
				goodtype = tLegal24_7Items;
            }
			default:{
				return SendClientMessage(playerid, COLOR_RED, "ERROR: Unknow menu item");
			}
    	}
		
		new bizid = TruckerFindBiz(goodtype);
		if(bizid == -1){
			CancelTruckDelivery(playerid);
			return SendClientMessageEx(playerid, COLOR_AQUA, "There is no available stores that need goods of type %s.",deliverytype);
		}SendClientMessageEx(playerid, COLOR_AQUA, "Please wait a moment while the truck is being loaded with %s....",deliverytype);
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){
			truckersGoods[truckindex][pTrailerID] = GetVehicleTrailer(GetPlayerVehicleID(playerid));
		}else truckersGoods[truckindex][pTrailerID] = -1;
		PlayerData[playerid][pTruckerGoodType]=goodtype;
		truckersGoods[truckindex][pGoodType]=goodtype;	
		truckersGoods[truckindex][pBizID] =bizid;
		truckersGoods[truckindex][pTDPosX]=BusinessInfo[bizid][bPosX];
		truckersGoods[truckindex][pTDPosY]=BusinessInfo[bizid][bPosY];
		truckersGoods[truckindex][pTDPosZ]=BusinessInfo[bizid][bPosZ];
		
		GameTextForPlayer(playerid, "Loading Goods....~n~Please wait.", 5000, 3);
		TogglePlayerControllableEx(playerid, 0);
		SetTimerEx("truckerwait", 5000, false, "i", playerid);
		DisablePlayerCheckpoint(playerid);
				
		PlayerData[playerid][pLastLoad] = gettime();
    }else{
		CancelTruckDelivery(playerid);
	}
    return 1;
}


Dialog:DIALOG_PICKLOAD(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(!PlayerHasJob(playerid, JOB_TRUCKER))
		{
			CancelTruckDelivery(playerid);
		    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a trucker.");
		}
		if(!((truckerVehicles[0] <= GetPlayerVehicleID(playerid) <= truckerVehicles[29]) &&  GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
		{
			CancelTruckDelivery(playerid);
			return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a valid truck.");
		}
		if(!IsPlayerInRangeOfPoint(playerid, 8.0, 2197.1211, -2660.5928, 13.5469))
		{
			CancelTruckDelivery(playerid);
			return SendClientMessage(playerid, COLOR_GREY, "You are not at the loading dock.");
		}

		switch(listitem)
		{
		    case 0:
		    {
		        Dialog_Show(playerid, DIALOG_PICKLOAD_LEGAL, DIALOG_STYLE_LIST, "Choose the load you want to deliver.", 
				"{00FF00}Food & beverages\n{00FF00}Clothing\n{00FF00}Materials\n{00FF00}24/7 Items", "Select", "Cancel");
            }
            case 1:
		    {
				Dialog_Show(playerid, DIALOG_PICKLOAD_ILLEGAL, DIALOG_STYLE_LIST, "Choose the load you want to deliver.", 
				"{FF0000}Weapons\n{FF0000}Drugs\n{FF0000}Illegal materials", "Select", "Cancel");
            }
		}

		PlayerData[playerid][pLastLoad] = gettime();
    }else{
		CancelTruckDelivery(playerid);
	}
    return 1;
}