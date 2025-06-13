/// @file      Job_Trucker.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum TruckerGoodsType{
    tNone,
    tLegalGoods,
    tIllegalGoods,
    tLegalFood,
    tLegalClothing,
    tLegal24_7Items,
    tLegalMat,
    tIllegalWeapons,
    tIllegalDrugs,
    tIllegalMaterials
}
enum pTruckDepotInfo
{
    TruckerGoodsType:pGoodType,
    pBizID,
    pTrailerID,
    Float:pTDPosX,
    Float:pTDPosY,
    Float:pTDPosZ,
    pTDName[128],
    pTDLevel
}
static truckerVehicles[30];
static truckersGoods[30][pTruckDepotInfo];
static truckerTrailers[9];
static TruckerGoodsType:truckersGoodsType[MAX_PLAYERS];

static TruckerPaymentPerLevel = 150;
static TruckerRandomPayment   = 500;
static RegularTruckMaxPayment = 650;

static const GoodsTypeString[TruckerGoodsType][18]={
    "None",
    "Legal Goods",
    "Illegal Goods",
    "Legal Food",
    "Legal Clothing",
    "Legal 24/7 Items",
    "Legal Materials",
    "Illegal Weapons",
    "Illegal Drugs",
    "Illegal Materials"
};

stock IsTruckerVehicle(vehicleid)
{
    return (truckerVehicles[0] <= vehicleid <= truckerVehicles[sizeof(truckerVehicles) - 1]);
}

hook OnPlayerInit(playerid)
{
    truckersGoodsType[playerid] = tNone;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_TRUCKDELIVERY)
        return 1;

    new truckid = GetPlayerVehicleID(playerid);
    if (!((truckerVehicles[0] <= truckid <= truckerVehicles[29]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
    {
        CancelTruckDelivery(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "Trucker: Delivery canceled as you are not driving a valid truck.");
    }
    if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)) && GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Trailer is not attached to vehicle.");
    }
    new truckindex = GetTruckIndex(playerid);
    if (!PlayerHasJob(playerid, JOB_TRUCKER))
    {
        CancelTruckDelivery(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "Trucker: Delivery canceled as you are not a trucker.");
    }

    if (IsPlayerInRangeOfPoint(playerid, 5, 2197.1211, -2660.5928, 13.5469))
    {
        Dialog_Show(playerid, DIALOG_PICKLOAD, DIALOG_STYLE_LIST, "Choose the load you want to deliver.",
        "{00FF00}Legal goods {FFFFFF}(no risk but no bonuses)\n{FF0000}Illegal goods {FFFFFF}(Risk of getting caught but a bonus)", "Select", "Cancel");
    }
    else if (IsPlayerInRangeOfPoint(playerid, 5, 2224.3040,-2635.5708,13.4350))
    {
        if (truckersGoods[truckindex][pTrailerID] != GetVehicleTrailer(GetPlayerVehicleID(playerid)) && truckersGoods[truckindex][pTrailerID]!=-1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Trucker: Unvalid attached trailer.");
        }
        new vehicleid = GetPlayerVehicleID(playerid);
        new money = Random(0, TruckerRandomPayment) + GetJobLevel(playerid, JOB_TRUCKER) * TruckerPaymentPerLevel;
        if (GetVehicleModel(vehicleid) != 515 && money > RegularTruckMaxPayment)
            money = RegularTruckMaxPayment;
        SendClientMessageEx(playerid, COLOR_AQUA, "TRUCKER: You Delivered goods and you got $%d.",money);
        GivePlayerCash(playerid, money);
        PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
        CancelTruckDelivery(playerid);
        SetVehicleToRespawn(vehicleid);

        if (truckersGoods[truckindex][pTrailerID]!=-1)
        {
            SetVehicleToRespawn(truckersGoods[truckindex][pTrailerID]);
        }

        new joblevel = GetJobLevel(playerid, JOB_TRUCKER);
        if (joblevel>1)
        {
            switch (truckersGoodsType[playerid])
            {
                case tIllegalDrugs:
                {
                    GivePlayerRankPointIllegalJob(playerid, 60);
                    new qte = min(joblevel-1,3);
                    PlayerData[playerid][pCocaine] += qte;
                    PlayerData[playerid][pWeed] += qte;
                    PlayerData[playerid][pHeroin] += qte;
                    SendClientMessageEx(playerid, COLOR_RED, "TRUCKER: You got %d cocaine, %d weed, %d heroin as a gift.",qte,qte,qte);
                }
                case tIllegalMaterials:
                {
                    GivePlayerRankPointIllegalJob(playerid, 60);
                    PlayerData[playerid][pMaterials]+= min(50 * (joblevel - 1), 200);
                    SendClientMessageEx(playerid, COLOR_RED, "TRUCKER: You got %d materials as gift.",min(50 * (joblevel - 1), 200));
                }
                case tIllegalWeapons:
                {
                    GivePlayerRankPointIllegalJob(playerid, 60);
                    new dice=random(10);
                    if (joblevel==2 && dice<5)
                    {
                            GivePlayerWeaponEx(playerid, 25);//Shotgun
                            SendClientMessage(playerid, COLOR_RED, "TRUCKER: You got Shotgun as gift.");
                    }
                    if (joblevel==3)
                    {
                        if (dice<4)
                        {
                            GivePlayerWeaponEx(playerid, 25);
                            SendClientMessage(playerid, COLOR_RED, "TRUCKER: You got Shotgun as gift.");
                        }
                        else if (dice<6)
                        {
                            GivePlayerWeaponEx(playerid, 33);//rifle
                            SendClientMessage(playerid, COLOR_RED, "TRUCKER: You got Rifle as gift.");
                        }
                    }
                    else{
                        if (dice<4)
                        {
                            GivePlayerWeaponEx(playerid, 25);
                            SendClientMessage(playerid, COLOR_RED, "TRUCKER: You got Shotgun as gift.");
                        }
                        else if (dice<7)
                        {
                            GivePlayerWeaponEx(playerid, 33);
                            SendClientMessage(playerid, COLOR_RED, "TRUCKER: You got Rifle as gift.");
                        }
                        else if (dice<8)
                        {
                            GivePlayerWeaponEx(playerid, 24);//deagle
                            SendClientMessage(playerid, COLOR_RED, "TRUCKER: You got Desert Deagle as gift.");
                        }
                    }
                }
                default:
                {
                    GivePlayerRankPointLegalJob(playerid, 60);
                }
            }
        }
        IncreaseJobSkill(playerid, JOB_TRUCKER);
    }
    else if (IsPlayerInRangeOfPoint(playerid, 5,
                truckersGoods[truckindex][pTDPosX],
                truckersGoods[truckindex][pTDPosY],
                truckersGoods[truckindex][pTDPosZ]))
    {

        if (truckersGoods[truckindex][pTrailerID] != GetVehicleTrailer(GetPlayerVehicleID(playerid)) && truckersGoods[truckindex][pTrailerID]!=-1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Trucker: Unvalid attached trailer.");
        }

        SendClientMessage(playerid, COLOR_AQUA, "Trucker: You delivered the goods return back to dock to get your paid.");
        BusinessInfo[truckersGoods[truckindex][pBizID]][bProducts] += (GetJobLevel(playerid, JOB_TRUCKER) * 2) + 10;
        SetActiveCheckpoint(playerid, CHECKPOINT_TRUCKDELIVERY, 2224.3040,-2635.5708,13.4350, 5);
    }
    else
    {
        CancelTruckDelivery(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "Trucker: Delivery canceled as you are in an unvalid checkpoint.");
    }
    
    return 1;
}

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "trucker", config))
    {
        JSON_GetInt(config, "payment_per_level",         TruckerPaymentPerLevel);
        JSON_GetInt(config, "random_payment",            TruckerRandomPayment);
        JSON_GetInt(config, "regular_truck_max_payment", RegularTruckMaxPayment);
    }

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
    truckerVehicles[13] = AddStaticVehicleEx(456, 2269.7498, -2677.2861, 13.7463, 90.0000, 91, 63, 300); // Truck Yankee    456
    truckerVehicles[14] = AddStaticVehicleEx(456, 2269.7979, -2682.0850, 13.7374, 90.0000, 102, 65, 300); // Truck Yankee   456
    truckerVehicles[15] = AddStaticVehicleEx(456, 2269.7466, -2686.7996, 13.7285, 90.0000, 105, 72, 300); // Truck Yankee   456
    truckerVehicles[16] = AddStaticVehicleEx(456, 2269.4836, -2691.5762, 13.7215, 90.0000, 110, 93, 300); // Truck Yankee   456
    truckerVehicles[17] = AddStaticVehicleEx(456, 2269.5667, -2696.6912, 13.7195, 90.0000, 121, 93, 300); // Truck Yankee   456
    truckerVehicles[18] = AddStaticVehicleEx(456, 2263.5000, -2633.0000, 13.7700, 90.0000, 84, 63, 300); // Truck Yankee    456
    truckerVehicles[19] = AddStaticVehicleEx(456, 2263.5000, -2638.0000, 13.7700, 90.0000, 91, 63, 300); // Truck Yankee    456
    truckerVehicles[20] = AddStaticVehicleEx(456, 2263.5000, -2644.0000, 13.7700, 90.0000, 102, 65, 300); // Truck Yankee   456
    truckerVehicles[21] = AddStaticVehicleEx(456, 2263.5000, -2650.0000, 13.7700, 90.0000, 105, 72, 300); // Truck Yankee   456
    truckerVehicles[22] = AddStaticVehicleEx(414, 2257.3523, -2682.3057, 13.6433, 350.0000, 67, 1, 300); // Truck Mule  414
    truckerVehicles[23] = AddStaticVehicleEx(414, 2252.7095, -2681.8508, 13.6448, 350.0000, 72, 1, 300); // Truck Mule  414
    truckerVehicles[24] = AddStaticVehicleEx(414, 2247.4028, -2681.4333, 13.6454, 350.0000, 9, 1, 300); // Truck Mule   414
    truckerVehicles[25] = AddStaticVehicleEx(414, 2242.8108, -2681.2217, 13.6456, 350.0000, 95, 1, 300); // Truck Mule  414
    truckerVehicles[26] = AddStaticVehicleEx(414, 2238.7466, -2680.8579, 13.6434, 350.0000, 24, 1, 300); // Truck Mule  414
    truckerVehicles[27] = AddStaticVehicleEx(414, 2233.0193, -2680.2834, 13.6398, 350.0000, 25, 1, 300); // Truck Mule  414
    truckerVehicles[28] = AddStaticVehicleEx(414, 2228.7241, -2680.5317, 13.6357, 350.0000, 28, 1, 300); // Truck Mule  414
    truckerVehicles[29] = AddStaticVehicleEx(414, 2224.2751, -2680.6360, 13.6348, 350.0000, 43, 1, 300); // Truck Mule  414
    return 1;
}


IsValidBizGoods(bizid,TruckerGoodsType:goodtype)
{
    new TruckerGoodsType:srcgoodtype=goodtype;
    if (srcgoodtype>tLegalMat)
        srcgoodtype = tIllegalGoods;
    //SendClientMessageEx(0,COLOR_RED,"IsValidBizGoods biztype(%d) (%s)",BusinessInfo[bizid][bType],
    //GoodsTypeString[srcgoodtype]);

    switch (BusinessInfo[bizid][bType])
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
        }while (!BusinessInfo[bizid][bExists]);

        checkcount++;

    }while (!(IsValidBizGoods(bizid,goodtype) && BusinessInfo[bizid][bProducts] < 1000) && (checkcount<30));

    if (checkcount==30)
    {
        return -1;
    }
    return bizid;

}

GetTruckIndex(playerid)
{
    for (new i=0;i<30;i++)
    {
        if ( GetPlayerVehicleID(playerid) == truckerVehicles[i])
        {
            return i;
        }
    }
    return -1;
}

CancelTruckDelivery(playerid)
{
    if ((truckerVehicles[0] <= GetPlayerVehicleID(playerid) <= truckerVehicles[29]) &&  GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        truckersGoods[GetTruckIndex(playerid)][pGoodType] = tNone;
    CancelActiveCheckpoint(playerid);
}

Dialog:DIALOG_PICKLOAD_ILLEGAL(playerid, response, listitem, inputtext[])
{

    if (response)
    {
        new truckindex=GetTruckIndex(playerid);
        new deliverytype[12];


        new bizid=-1;
        switch (listitem)
        {
            case 0:
            {
                strcat(deliverytype, "Weapons");
                truckersGoods[truckindex][pGoodType] = tIllegalWeapons;
                truckersGoodsType[playerid]=tIllegalWeapons;

                /*new PlayerBar:bar1 = CreatePlayerProgressBar(playerid, 310.0, 200.0, 50.0, 10.0, 0x11acFFFF, 10.0, BAR_DIRECTION_LEFT);*/
            }
            case 1:
            {
                strcat(deliverytype, "Drugs");
                truckersGoods[truckindex][pGoodType] = tIllegalDrugs;
                truckersGoodsType[playerid]=tIllegalDrugs;
            }
            case 2:
            {
                strcat(deliverytype, "Illegal materials");
                truckersGoods[truckindex][pGoodType] = tIllegalMaterials;
                truckersGoodsType[playerid]=tIllegalMaterials;
            }
            default:
            {
                return SendClientMessage(playerid, COLOR_RED, "ERROR: Unknow menu item");
            }
        }

        bizid = TruckerFindBiz(tIllegalGoods);
        if (bizid == -1)
        {
            CancelTruckDelivery(playerid);
            return SendClientMessageEx(playerid, COLOR_AQUA, "There is no available stores that need goods of type %s.",deliverytype);
        }
        SendClientMessageEx(playerid, COLOR_AQUA, "Please wait a moment while the truck is being loaded with %s....",deliverytype);
        truckersGoods[truckindex][pBizID] =bizid;
        if (IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
        {
            truckersGoods[truckindex][pTrailerID] = GetVehicleTrailer(GetPlayerVehicleID(playerid));
        }
        else
        {
            truckersGoods[truckindex][pTrailerID] = -1;
        }
        truckersGoods[truckindex][pTDPosX]=BusinessInfo[bizid][bPosX];
        truckersGoods[truckindex][pTDPosY]=BusinessInfo[bizid][bPosY];
        truckersGoods[truckindex][pTDPosZ]=BusinessInfo[bizid][bPosZ];

        GameTextForPlayer(playerid, "Loading Goods....~n~Please wait.", 5000, 3);
        TogglePlayerControllableEx(playerid, 0);
        SetTimerEx("truckerwait", 5000, false, "i", playerid);
        CancelActiveCheckpoint(playerid);

        PlayerData[playerid][pLastLoad] = gettime();
    }
    else
    {
        CancelTruckDelivery(playerid);
    }
    return 1;
}

publish truckerwait(playerid)
{
    ShowPlayerFooter(playerid, "Truck was Loaded....~n~Deliver it to the destination business.");
    new truckindex = GetTruckIndex(playerid);
    if (truckindex == -1)
    {
        CancelTruckDelivery(playerid);
        SendClientMessageEx(playerid, COLOR_RED, "TRUCKER: Delivery canceled as you are not in a valid Truck");
    }
    else
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_TRUCKDELIVERY, truckersGoods[truckindex][pTDPosX], truckersGoods[truckindex][pTDPosY], truckersGoods[truckindex][pTDPosZ], 5.0);
        SendClientMessageEx(playerid, COLOR_AQUA, "The truck was loaded with %s, deliver it to the desitination business(%d)",GoodsTypeString[truckersGoods[truckindex][pGoodType]],truckersGoods[truckindex][pBizID]);
        TogglePlayerControllableEx(playerid, 1);
    }
}

Dialog:DIALOG_PICKLOAD_LEGAL(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new truckindex = GetTruckIndex(playerid);
        new deliverytype[12];
        new TruckerGoodsType:goodtype;

        switch (listitem)
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
        if (bizid == -1)
        {
            CancelTruckDelivery(playerid);
            return SendClientMessageEx(playerid, COLOR_AQUA, "There is no available stores that need goods of type %s.",deliverytype);
        }
        SendClientMessageEx(playerid, COLOR_AQUA, "Please wait a moment while the truck is being loaded with %s....",deliverytype);
        if (IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
        {
            truckersGoods[truckindex][pTrailerID] = GetVehicleTrailer(GetPlayerVehicleID(playerid));
        }
        else
        {
            truckersGoods[truckindex][pTrailerID] = -1;
        }
        truckersGoodsType[playerid]=goodtype;
        truckersGoods[truckindex][pGoodType]=goodtype;
        truckersGoods[truckindex][pBizID] =bizid;
        truckersGoods[truckindex][pTDPosX]=BusinessInfo[bizid][bPosX];
        truckersGoods[truckindex][pTDPosY]=BusinessInfo[bizid][bPosY];
        truckersGoods[truckindex][pTDPosZ]=BusinessInfo[bizid][bPosZ];

        GameTextForPlayer(playerid, "Loading Goods....~n~Please wait.", 5000, 3);
        TogglePlayerControllableEx(playerid, 0);
        SetTimerEx("truckerwait", 5000, false, "i", playerid);
        CancelActiveCheckpoint(playerid);

        PlayerData[playerid][pLastLoad] = gettime();
    }
    else
    {
        CancelTruckDelivery(playerid);
    }
    return 1;
}


Dialog:DIALOG_PICKLOAD(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!PlayerHasJob(playerid, JOB_TRUCKER))
        {
            CancelTruckDelivery(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a trucker.");
        }
        if (!((truckerVehicles[0] <= GetPlayerVehicleID(playerid) <= truckerVehicles[29]) &&  GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
        {
            CancelTruckDelivery(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a valid truck.");
        }
        if (!IsPlayerInRangeOfPoint(playerid, 8.0, 2197.1211, -2660.5928, 13.5469))
        {
            CancelTruckDelivery(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "You are not at the loading dock.");
        }

        switch (listitem)
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
    }
    else
    {
        CancelTruckDelivery(playerid);
    }
    return 1;
}

hook OnPlayerEnterJobCar(playerid, vehicleid, jobtype)
{
    if (jobtype != JOB_TRUCKER)
        return 1;

    new tIdx = GetTruckIndex(playerid);
    new TruckerGoodsType:goodtype = truckersGoods[tIdx][pGoodType];

    if (goodtype == tNone)
        SendClientMessageEx(playerid, COLOR_YELLOW3, "The trucker TR%d is loaded with %s.", vehicleid, GoodsTypeString[goodtype]);
    else if (goodtype > tLegalMat || goodtype == tIllegalGoods)
        SendClientMessageEx(playerid, COLOR_YELLOW3, "The trucker TR%d is loaded with {FF0000}%s{FFFF90}.", vehicleid, GoodsTypeString[goodtype]);
    else SendClientMessageEx(playerid, COLOR_YELLOW3, "The trucker TR%d is loaded with {00FF00}%s{FFFF90}.", vehicleid, GoodsTypeString[goodtype]);
    return 1;
}
CMD:canceltruck(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_TRUCKER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a trucker.");
    }
    CancelTruckDelivery(playerid);
    return SendClientMessage(playerid, COLOR_GREY, "You have canceled the goods delivery.");
}

CMD:loadtruck(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_TRUCKER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a trucker.");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_AQUA, "Trucker: Make sure you dont have any checkpoint. Use /kcp to clear current checkpoints.");
    }
    if (!((truckerVehicles[0] <= GetPlayerVehicleID(playerid) <= truckerVehicles[29]) &&  GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a valid truck.");
    }
    if (truckersGoods[GetTruckIndex(playerid)][pGoodType] != tNone)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Truck already have goods in. Use /canceltruck to cancel delivery.");
    }
    if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)) && GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Trailer is not attached to vehicle.");
    }
    SetActiveCheckpoint(playerid, CHECKPOINT_TRUCKDELIVERY, 2197.1211, -2660.5928, 13.5469, 5.0);
    return 1;
}

CMD:delivertruck(playerid, params[])
{
    new businessid, truckidx;
    if (!PlayerHasJob(playerid, JOB_TRUCKER))
    {
        CancelTruckDelivery(playerid);
        return SendClientMessage(playerid, COLOR_AQUA, "Trucker: Delivery canceled as you are not a trucker.");
    }
    if (GetJobLevel(playerid,JOB_TRUCKER)<5)
    {
        return SendClientMessage(playerid, COLOR_AQUA, "Trucker: You can't use this command as you are not a master trucker.");
    }
    if (!(truckerVehicles[0] <= GetPlayerVehicleID(playerid)<= truckerVehicles[29] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
    {
        CancelTruckDelivery(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "Delivery canceled as you are not driving a valid truck.");
    }
    truckidx = GetTruckIndex(playerid);
    if (truckersGoods[truckidx][pGoodType] == tNone)
    {
        CancelTruckDelivery(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "You have no shipment loaded which you can deliver.");
    }
    if ((businessid = GetNearbyBusiness(playerid, 7.0)) == -1 || !IsValidBizGoods(businessid, truckersGoods[truckidx][pGoodType]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of a business which accepts this type of load.");
    }

    if (gettime() - PlayerData[playerid][pLastLoad] < 20 && !IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pKicked])
    {
        PlayerData[playerid][pACWarns]++;

        if (PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport delivering (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerData[playerid][pLastLoad]);
        }
        else
        {
            BanPlayer(playerid, "Teleport delivering");
        }
    }

    BusinessInfo[businessid][bProducts] += (GetJobLevel(playerid, JOB_TRUCKER) * 2) + 10;

    DBQuery("UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);

    CancelActiveCheckpoint(playerid);
    truckersGoods[truckidx][pGoodType] = tNone;
    SetActiveCheckpoint(playerid, CHECKPOINT_TRUCKDELIVERY, 2224.3040,-2635.5708,13.4350, 5);
    SendClientMessage(playerid, COLOR_AQUA, "Trucker: You delivered the goods return back to dock to get your paid.");
    return 1;
}


CMD:tcheck(playerid,params[])
{
    new truckid;

    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if ((truckid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (!((truckerVehicles[0] <= truckid <= truckerVehicles[29])))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can check only trucks.");
    }

    new truckindex=-1;
    for (new i=0;i<30;i++)
    {
        if ( truckid == truckerVehicles[i])
        {
            truckindex=i;
            break;
        }
    }

    if (truckindex == -1)
    {
        return SendClientMessage(playerid, COLOR_RED, "There is an internal error contact Mike_Zodiac to fix that.");
    }

    new TruckerGoodsType:goodtype = truckersGoods[truckindex][pGoodType];
    if (goodtype == tNone)
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
    if (!((truckerVehicles[0] <= truckid <= truckerVehicles[29]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Trucker: You need to use truck to check delivery info.");
    }
    new truckindex = GetTruckIndex(playerid);
    new TruckerGoodsType:goodtype = truckersGoods[truckindex][pGoodType];
    if (goodtype == tNone)
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
