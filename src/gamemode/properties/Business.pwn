/// @file      Business.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022


enum bizInts
{
    intName[32],
    intID,
    Float:intX,
    Float:intY,
    Float:intZ,
    Float:intA
};

new const bizInteriorArray[][bizInts] =
{
    {"24/7 (version 1)",        17, -25.9733, -187.8952, 1003.5468, 0.0000},
    {"24/7 (version 2)",        10, 6.0159, -31.0345, 1003.5493, 0.0000},
    {"24/7 (version 3)",        18, -30.9967, -91.4492, 1003.5468, 0.0000},
    {"24/7 (version 4)",        16, -25.9416, -140.6656, 1003.5468, 0.0000},
    {"24/7 (version 5)",        4,  -27.3069, -30.8341, 1003.5573, 0.0000},
    {"24/7 (version 6)",        6,  -27.4368, -57.4361, 1003.5468, 0.0000},
    {"Ammunation (version 1)",  7,  315.7398, -143.1958, 999.6016, 0.0000},
    {"Ammunation (version 2)",  1,  285.3190, -41.1576, 1001.5156, 0.0000},
    {"Ammunation (version 3)",  4,  285.7825, -85.9860, 1001.5228, 0.0000},
    {"Ammunation (version 4)",  6,  296.7723, -111.6399, 1001.5156, 0.0000},
    {"Ammunation (version 5)",  6,  316.2890, -169.7619, 999.6010, 0.0000},
    {"Binco",                   15, 207.6329, -110.7673, 1005.1328, 0.0000},
    {"Pro-Laps",                3,  206.9459, -139.5319, 1003.5078, 0.0000},
    {"Didier Sachs",            14, 204.2969, -168.3488, 1000.5233, 0.0000},
    {"Victim",                  5,  226.7738, -8.2257, 1002.2108, 90.0000},
    {"Zip",                     18, 161.3670, -96.4953, 1001.8046, 0.0000},
    {"SubUrban",                1,  203.7149, -50.2200, 1001.8046, 0.0000},
    {"Betting (version 1)",     3,  834.1848, 7.3453, 1004.1870, 90.0000},
    {"Betting (version 2)",     1,  -2170.3428, 640.7771, 1052.3817, 0.0000},
    {"Donut Shop",              17, 377.0733, -193.0574, 1000.6400, 0.0000},
    {"Burger Shot",             10, 363.1346, -74.8441, 1001.5078, 315.0000},
    {"Pizza Stack",             5,  372.3019, -133.1221, 1001.4921, 0.0000},
    {"Cluckin' Bell",           9,  364.8536, -11.1400, 1001.8516, 0.0000},
    {"Marco's Bistro",          1,  -795.0334, 489.8574, 1376.1953, 0.0000},
    {"Cafeteria",               4,  459.7685, -88.6637, 999.5547, 90.0000},
    {"Barber Shop",             3,  418.5545, -83.9392, 1001.8046, 0.0000},
    {"Tattoo Shop",             3,  -204.4362, -43.8119, 1002.2733, 0.0000},
    {"Ganton Gym",              5,  772.2800, -4.7154, 1000.7288, 0.0000},
    {"Las Venturas Gym",        7,  773.8508, -78.3952, 1000.6621, 0.0000},
    {"San Fierro Gym",          6,  774.1206, -49.9538, 1000.5858, 0.0000},
    {"Sex Shop",                3,  -100.3628, -24.4456, 1000.7188, 0.0000},
    {"RC Shop",                 6,  -2240.3610, 128.2816, 1035.4210, 270.0000},
    {"Four Dragons Casino",     10, 2018.2132, 1017.7788, 996.8750, 90.0000},
    {"Caligulas Casino",        1,  2234.0485, 1714.1568, 1012.3596, 180.0000},
    {"Red Sands Casino",        12, 1133.1075, -15.3114, 1000.6796, 0.0000},
    {"Alhambra",                17, 493.3728, -23.9953, 1000.6796, 0.0000},
    {"Pig Pen",                 2,  1204.7922, -13.2587, 1000.9218, 0.0000},
    {"Big Spread Ranch",        3,  1212.1400, -26.3005, 1000.9531, 180.0000},
    {"Ten Green Bottles",       11, 501.9559, -67.9867, 998.7578, 180.0000},
    {"Lil' Probe Inn",          18, -228.7570, 1401.2421, 27.7656, 270.0000},
    {"Warehouse",               18, 1307.0178, 4.1193, 1001.0289, 90.0000}
};


Dialog:DIALOG_BUY(playerid, response, listitem, inputtext[])
{
    if (response && listitem >=0)
    {
        new businessid = GetInsideBusiness(playerid);
        if (businessid == -1)
        {
            return 1;
        }

        if (BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
        {
            new
                string[128];

            format(string, sizeof(string), "%s's %s [%i products]", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

            if (listitem == 0)
            {
                ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_CLOTHES, "Clothes Shop", clothesShopSkins, sizeof(clothesShopSkins));
            }
            else if (listitem > 0)
            {
                PlayerData[playerid][pCategory] = listitem - 1;
                ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
            }
        }
        else if (BusinessInfo[businessid][bType] == BUSINESS_GYM)
        {
            switch (listitem)
            {
                case 0:
                {
                    if (PlayerData[playerid][pFightStyle] == FIGHT_STYLE_NORMAL)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You already have this fighting style.");
                    }

                    PlayerData[playerid][pFightStyle] = FIGHT_STYLE_NORMAL;
                    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);

                    DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[playerid][pFightStyle], PlayerData[playerid][pID]);

                    SendClientMessage(playerid, COLOR_WHITE, "You have chosen the normal fighting style.");
                }
                case 1:
                {
                    new price = 4725;

                    if (PlayerData[playerid][pCash] < price)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
                    }
                    if (PlayerData[playerid][pFightStyle] == FIGHT_STYLE_BOXING)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You already have this fighting style.");
                    }

                    if (PlayerData[playerid][pTraderUpgrade] > 0)
                    {
                        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
                        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
                    }

                    GivePlayerCash(playerid, -price);


                    PerformBusinessPurchase(playerid, businessid, price);

                    PlayerData[playerid][pFightStyle] = FIGHT_STYLE_BOXING;
                    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);


                    DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[playerid][pFightStyle], PlayerData[playerid][pID]);

                    SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased the Boxing fighting style for $%i.", price);
                }
                case 2:
                {
                    new price = 7650;

                    if (PlayerData[playerid][pCash] < price)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
                    }
                    if (PlayerData[playerid][pFightStyle] == FIGHT_STYLE_KUNGFU)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You already have this fighting style.");
                    }

                    if (PlayerData[playerid][pTraderUpgrade] > 0)
                    {
                        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
                        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
                    }

                    GivePlayerCash(playerid, -price);

                    PlayerData[playerid][pFightStyle] = FIGHT_STYLE_KUNGFU;
                    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);

                    PerformBusinessPurchase(playerid, businessid, price);
                    DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[playerid][pFightStyle], PlayerData[playerid][pID]);

                    SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased the Kung-Fu fighting style for $%i.", price);
                }
                case 3:
                {
                    new price = 9275;

                    if (PlayerData[playerid][pCash] < price)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
                    }
                    if (PlayerData[playerid][pFightStyle] == FIGHT_STYLE_KNEEHEAD)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You already have this fighting style.");
                    }

                    if (PlayerData[playerid][pTraderUpgrade] > 0)
                    {
                        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
                        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
                    }

                    GivePlayerCash(playerid, -price);

                    PlayerData[playerid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;
                    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);

                    PerformBusinessPurchase(playerid, businessid, price);
                    DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[playerid][pFightStyle], PlayerData[playerid][pID]);

                    SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased the Kneehead fighting style for $%i.", price);
                }
                case 4:
                {
                    new price = 1250;

                    if (PlayerData[playerid][pCash] < price)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
                    }
                    if (PlayerData[playerid][pFightStyle] == FIGHT_STYLE_GRABKICK)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You already have this fighting style.");
                    }

                    if (PlayerData[playerid][pTraderUpgrade] > 0)
                    {
                        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
                        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
                    }

                    GivePlayerCash(playerid, -price);

                    PlayerData[playerid][pFightStyle] = FIGHT_STYLE_GRABKICK;
                    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);

                    PerformBusinessPurchase(playerid, businessid, price);
                    DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[playerid][pFightStyle], PlayerData[playerid][pID]);

                    SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased the Grabkick fighting style for $%i.", price);
                }
                case 5:
                {
                    new price = 2950;

                    if (PlayerData[playerid][pCash] < price)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
                    }
                    if (PlayerData[playerid][pFightStyle] == FIGHT_STYLE_ELBOW)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You already have this fighting style.");
                    }

                    if (PlayerData[playerid][pTraderUpgrade] > 0)
                    {
                        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
                        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
                    }

                    GivePlayerCash(playerid, -price);

                    PlayerData[playerid][pFightStyle] = FIGHT_STYLE_ELBOW;
                    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);

                    PerformBusinessPurchase(playerid, businessid, price);

                    DBQuery("UPDATE "#TABLE_USERS" SET fightstyle = %i WHERE uid = %i", PlayerData[playerid][pFightStyle], PlayerData[playerid][pID]);

                    SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased the Elbow fighting style for $%i.", price);
                }
            }
        }
    }
    return 1;
}

Dialog:DIALOG_BIZINTERIOR(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new businessid = PlayerData[playerid][pSelected];

        foreach(new i : Player)
        {
            if (GetInsideBusiness(i) == businessid)
            {
                SetPlayerPos(i, bizInteriorArray[listitem][intX], bizInteriorArray[listitem][intY], bizInteriorArray[listitem][intZ]);
                SetPlayerFacingAngle(i, bizInteriorArray[listitem][intA]);
                SetPlayerInterior(i, bizInteriorArray[listitem][intID]);
                SetCameraBehindPlayer(i);
            }
        }

        BusinessInfo[businessid][bIntX] = bizInteriorArray[listitem][intX];
        BusinessInfo[businessid][bIntY] = bizInteriorArray[listitem][intY];
        BusinessInfo[businessid][bIntZ] = bizInteriorArray[listitem][intZ];
        BusinessInfo[businessid][bIntA] = bizInteriorArray[listitem][intA];
        BusinessInfo[businessid][bInterior] = bizInteriorArray[listitem][intID];

        DBQuery("UPDATE businesses SET int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bID]);

        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "You've changed the interior of business %i to %s.", businessid, bizInteriorArray[listitem][intName]);
    }
    return 1;
}

DB:OnLoadBusinesses()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_BUSINESSES; i ++)
    {
        GetDBStringField(i, "owner", BusinessInfo[i][bOwner], MAX_PLAYER_NAME);
        GetDBStringField(i, "name",     BusinessInfo[i][bName], MAX_BUSINESSES_NAME);
        GetDBStringField(i, "message",  BusinessInfo[i][bMessage], 128);

        BusinessInfo[i][bID] = GetDBIntField(i, "id");
        BusinessInfo[i][bOwnerID] = GetDBIntField(i, "ownerid");
        BusinessInfo[i][bType] = GetDBIntField(i, "type");
        BusinessInfo[i][bDealerShipType] = GetDBIntField(i, "dealershiptype");
        BusinessInfo[i][bPrice] = GetDBIntField(i, "price");
        BusinessInfo[i][bEntryFee] = GetDBIntField(i, "entryfee");
        BusinessInfo[i][bLocked] = GetDBIntField(i, "locked");
        BusinessInfo[i][bTimestamp] = GetDBIntField(i, "timestamp");
        BusinessInfo[i][bPosX] = GetDBFloatField(i, "pos_x");
        BusinessInfo[i][bPosY] = GetDBFloatField(i, "pos_y");
        BusinessInfo[i][bPosZ] = GetDBFloatField(i, "pos_z");
        BusinessInfo[i][bPosA] = GetDBFloatField(i, "pos_a");
        BusinessInfo[i][bIntX] = GetDBFloatField(i, "int_x");
        BusinessInfo[i][bIntY] = GetDBFloatField(i, "int_y");
        BusinessInfo[i][bIntZ] = GetDBFloatField(i, "int_z");
        BusinessInfo[i][bIntA] = GetDBFloatField(i, "int_a");
        BusinessInfo[i][cVehicle][0] = GetDBFloatField(i, "cVehicleX");
        BusinessInfo[i][cVehicle][1] = GetDBFloatField(i, "cVehicleY");
        BusinessInfo[i][cVehicle][2] = GetDBFloatField(i, "cVehicleZ");
        BusinessInfo[i][cVehicle][3] = GetDBFloatField(i, "cVehicleA");
        BusinessInfo[i][bInterior] = GetDBIntField(i, "interior");
        BusinessInfo[i][bWorld] = GetDBIntField(i, "world");
        BusinessInfo[i][bOutsideInt] = GetDBIntField(i, "outsideint");
        BusinessInfo[i][bOutsideVW] = GetDBIntField(i, "outsidevw");
        BusinessInfo[i][bCash] = GetDBIntField(i, "cash");
        BusinessInfo[i][bProducts] = GetDBIntField(i, "products");
        BusinessInfo[i][bMaterials] = GetDBIntField(i, "materials");
        BusinessInfo[i][bDisplayMapIcon] = GetDBIntField(i, "displaymapicon");
        BusinessInfo[i][bText] = Text3D:INVALID_3DTEXT_ID;
        BusinessInfo[i][bPickup] = -1;
        BusinessInfo[i][bMapIcon] = -1;
        BusinessInfo[i][bExists] = 1;
        Iter_Add(Business, i);

        ReloadBusiness(i);
    }

    printf("[Script] %i businesses loaded.", rows);
}

stock PerformBusinessPurchase(playerid, businessid, price, materials = 0)
{
    if (BusinessInfo[businessid][bProducts] > 0 && BusinessInfo[businessid][bOwnerID] != PlayerData[playerid][pID])
    {
        BusinessInfo[businessid][bCash] += price;
        BusinessInfo[businessid][bMaterials] += materials;
        BusinessInfo[businessid][bProducts]--;

        DBQuery("UPDATE businesses SET cash = %i, materials = %i, products = %i WHERE id = %i",
                BusinessInfo[businessid][bCash], BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
    }
}

IsValidCompanyID(id)
{
    return (id >= 0 && id < MAX_BUSINESSES) && BusinessInfo[id][bExists];
}


IsVehicleSpawnSetup(company)
{
    return (BusinessInfo[company][cVehicle][0] != 0.0 && BusinessInfo[company][cVehicle][1] != 0.0 && BusinessInfo[company][cVehicle][2] != 0.0);
}


TryEnterBusiness(playerid, id)
{
    if (BusinessInfo[id][bLocked])
    {
        ShowPlayerFooter(playerid, "~r~Closed");
        return 0;
    }
    new turfid = GetNearbyTurf(playerid);
    if (turfid >= 0 && IsActiveTurf(turfid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The business is closed due to gang war.");
    }

    if (IsBusinessOwner(playerid, id))
    {
        BusinessInfo[id][bTimestamp] = gettime();

        DBQuery("UPDATE businesses SET timestamp = %i WHERE id = %i", gettime(), BusinessInfo[id][bID]);

        ShowActionBubble(playerid, "* %s has entered their business.", GetRPName(playerid));
    }
    else
    {
        if (BusinessInfo[id][bEntryFee] > 0)
        {
            if (PlayerData[playerid][pCash] < BusinessInfo[id][bEntryFee])
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to pay the entry fee. You may not enter.");
            }
            new string[24];
            format(string, sizeof(string), "~r~-$%i", BusinessInfo[id][bEntryFee]);
            GameTextForPlayer(playerid, string, 5000, 1);

            BusinessInfo[id][bCash] += BusinessInfo[id][bEntryFee];
            GivePlayerCash(playerid, -BusinessInfo[id][bEntryFee]);

            DBQuery("UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[id][bCash], BusinessInfo[id][bID]);
        }

        ShowActionBubble(playerid, "* %s has entered the business.", GetRPName(playerid));

        switch (BusinessInfo[id][bType])
        {
            case BUSINESS_STORE, BUSINESS_GUNSHOP, BUSINESS_CLOTHES, BUSINESS_RESTAURANT, BUSINESS_BARCLUB:
                SendClientMessageEx(playerid, COLOR_GREEN, "Welcome to %s's %s [%i products]. /buy to purchase from this business.", BusinessInfo[id][bOwner], bizInteriors[BusinessInfo[id][bType]][intType], BusinessInfo[id][bProducts]);
            case BUSINESS_GYM:
                SendClientMessageEx(playerid, COLOR_GREEN, "Welcome to %s's %s. /buy to purchase a fighting style.", BusinessInfo[id][bOwner], bizInteriors[BusinessInfo[id][bType]][intType]);
            case BUSINESS_AGENCY:
                SendClientMessageEx(playerid, COLOR_GREEN, "Welcome to %s's %s. /(ad)vertise to make an advertisement.", BusinessInfo[id][bOwner], bizInteriors[BusinessInfo[id][bType]][intType]);
        }
    }
    DisplayBizMessage(playerid,id);
    PlayerData[playerid][pLastEnter] = gettime();
    SetFreezePos(playerid, BusinessInfo[id][bIntX], BusinessInfo[id][bIntY], BusinessInfo[id][bIntZ]);
    SetPlayerFacingAngle(playerid, BusinessInfo[id][bIntA]);
    SetPlayerInterior(playerid, BusinessInfo[id][bInterior]);
    SetPlayerVirtualWorld(playerid, BusinessInfo[id][bWorld]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

Dialog:DIALOG_BUSINESSMENU(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new string[256];
        new title[50];
        new id;
        new businessid = GetNearbyBusinessEx(playerid);// GetInsideBusiness(playerid);

        if (businessid == -1)
        {
            return 1;
        }

        switch (listitem)
        {
            case 0:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
                format(string,sizeof(string), "Value \t%s \n Type \t%s \n Location \t%s \n Active \t%s \n Status \t%s\n", FormatCash(BusinessInfo[businessid][bPrice]), bizInteriors[BusinessInfo[businessid][bType]][intType],
                GetZoneName(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]), (gettime() - BusinessInfo[businessid][bTimestamp] > 2592000) ? ("{FF6347}No{C8C8C8}") : ("Yes"),
                (BusinessInfo[businessid][bLocked]) ? ("{FF0000}Closed{FFFFFF}") : ("{00FF00}Opened{FFFFFF}"));
                format(string,sizeof(string),"%s Vault \t%s \n Entry Fee \t%s \n Products \t%i \n Materials \t%i",string, FormatCash(BusinessInfo[businessid][bCash]), FormatCash(BusinessInfo[businessid][bEntryFee]), BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bMaterials]);
                Dialog_Show(playerid, DIALOG_BUSINESSMENU_I, DIALOG_STYLE_TABLIST, title, string, "Cancel", "");
            }
            case 1:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
                Dialog_Show(playerid, DIALOG_BIZ_NAME, DIALOG_STYLE_INPUT, title, "Enter new business name:", "Ok", "Cancel");
            }
            case 2:
            {
                Dialog_Show(playerid, DIALOG_BMESSAGE, DIALOG_STYLE_INPUT, "Business Menu - Change Message", "Enter new message below for your business.", "Confirm", "Return");
            }
            case 3:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}", businessid);
                Dialog_Show(playerid, DIALOG_BIZ_FEE, DIALOG_STYLE_INPUT, title, "Enter new entry fee:", "Ok", "Cancel");
            }
            case 4:
            {
                if ((id = GetNearbyBusinessEx(playerid)) >= 0 && IsBusinessOwner(playerid, id))
                {
                    if (!BusinessInfo[id][bLocked])
                    {
                        BusinessInfo[id][bLocked] = 1;

                        GameTextForPlayer(playerid, "~r~Business locked", 3000, 6);
                        ShowActionBubble(playerid, "* %s locks their business door.", GetRPName(playerid));
                    }
                    else
                    {
                        BusinessInfo[id][bLocked] = 0;

                        GameTextForPlayer(playerid, "~g~Business unlocked", 3000, 6);
                        ShowActionBubble(playerid, "* %s unlocks their business door.", GetRPName(playerid));
                    }

                    PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

                    DBQuery("UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[id][bLocked], BusinessInfo[id][bID]);

                    return 1;
                }
            }
            case 5:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
                format(string, sizeof(string),"\n Vault: %s \nEnter the amount of money you want to deposit:" ,FormatCash(BusinessInfo[businessid][bCash]));
                Dialog_Show(playerid, DIALOG_BIZ_DEPOSIT, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
            }
            case 6:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
                format(string, sizeof(string),"\n Vault: %s \nEnter the amount of money you want to withdraw:" ,FormatCash(BusinessInfo[businessid][bCash]));
                Dialog_Show(playerid, DIALOG_BIZ_WITHDRAW, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
            }
            case 7:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
                format(string, sizeof(string),"\n Materials: %i \nEnter the amount of materials you want to deposit:" ,BusinessInfo[businessid][bMaterials]);
                Dialog_Show(playerid, DIALOG_BIZ_DEPOSIT_MATS, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
            }
            case 8:
            {
                format(title, sizeof(title), "{4169e1}Business ID %i{FFFFFF}",businessid);
                format(string, sizeof(string),"\n Materials: %i \nEnter the amount of materials you want to withdraw:" ,BusinessInfo[businessid][bMaterials]);
                Dialog_Show(playerid, DIALOG_BIZ_WITHDRAW_MATS, DIALOG_STYLE_INPUT, title,string , "Ok", "Cancel");
            }
        }
    }
    return 1;
}
Dialog:DIALOG_BMESSAGE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new businessid = GetInsideBusiness(playerid);
        if (businessid == -1)
        {
            return 1;
        }
        new string28[150];

        format(BusinessInfo[businessid][bMessage], 128, inputtext);
        format(string28,sizeof(string28), "You have set your business message to %s.", inputtext);
        SendClientMessage(playerid, COLOR_AQUA, string28);

        DBQuery("UPDATE businesses SET message = '%e' WHERE id = %i", BusinessInfo[businessid][bMessage], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
    }
    return 1;
}

Dialog:DIALOG_BUSINESSMENU_I(playerid, response, listitem, inputtext[])
{}

Dialog:DIALOG_BIZ_NAME(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new businessid = GetInsideBusiness(playerid);
        if (businessid == -1)
        {
            return SendClientMessage(playerid,COLOR_SYNTAX,"You can only use this command inside your business.");
        }
        if (5 <= strlen(inputtext) <= MAX_BUSINESSES_NAME)
        {
            strcpy(BusinessInfo[businessid][bName], inputtext, MAX_BUSINESSES_NAME);
            //format(,"%s");
            DBQuery("UPDATE businesses SET name = '%e' WHERE id = %i", inputtext, BusinessInfo[businessid][bID]);

            SendClientMessageEx(playerid,COLOR_SYNTAX,"Business Name of (%i) changed to: %s",BusinessInfo[businessid][bID],inputtext);
            ReloadBusiness(businessid);
        }
        else
        {
            SendClientMessage(playerid,COLOR_SYNTAX,"Unvalid Business Name length.");
        }
    }
    return 1;
}

Dialog:DIALOG_BIZ_FEE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        callcmd::entryfee(playerid,inputtext);
    }
}

Dialog:DIALOG_BIZ_WITHDRAW(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        callcmd::bwithdraw(playerid, inputtext);
    }
}

Dialog:DIALOG_BIZ_DEPOSIT(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        callcmd::bdeposit(playerid, inputtext);
    }
}

Dialog:DIALOG_BIZ_WITHDRAW_MATS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        callcmd::bwithdrawmats(playerid, inputtext);
    }
}

Dialog:DIALOG_BIZ_DEPOSIT_MATS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        callcmd::bdepositmats(playerid, inputtext);
    }
}

Store:Menu_GunStore(playerid, response, itemid, modelid, price, amount, itemname[])
{
    if (!response)
    {
        return 1;
    }
    new businessid = GetInsideBusiness(playerid);
    if (businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_GUNSHOP)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any gunstore.");
    }
    if (!PlayerHasLicense(playerid, PlayerLicense_Gun))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a gun license, you may request that on our forums");
    }
    if (PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to purchase %s.", FormatCash(price),itemname);
    }
    switch (itemid)
    {
        case 1:
        {
            if (PlayerHasWeapon(playerid, 22))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
            }
            GivePlayerWeaponEx(playerid, 22);
        }
        case 2:
        {
            if (PlayerHasWeapon(playerid, 25))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
            }
            GivePlayerWeaponEx(playerid, 25);
        }
        case 3:
        {
            if (PlayerHasWeapon(playerid, 33))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
            }
            GivePlayerWeaponEx(playerid, 33);
        }
        case 4:
        {
            SetScriptArmour(playerid, 50.0);
        }
        case 5:
        {
            SetScriptArmour(playerid, 75.0);
        }
    }

    if (PlayerData[playerid][pTraderUpgrade] > 0)
    {
        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of %s to $%i.", PlayerData[playerid][pTraderUpgrade],itemname, price);
    }
    GivePlayerCash(playerid, -price);

    PerformBusinessPurchase(playerid, businessid, price);

    ShowActionBubble(playerid, "* %s paid $%i to the shopkeeper and received a %s.", GetRPName(playerid), price, itemname);
    SendClientMessageEx(playerid, COLOR_WHITE, "%s purchased.", itemname);

    if (itemid < 4)
    {
        AwardAchievement(playerid, ACH_IllegalWeapon);
    }
    return 1;
}
Store:Menu_ToolShop(playerid, response, itemid, modelid, price, amount, itemname[])
{
    if (!response) return 1;
    new businessid = GetInsideBusiness(playerid);
    if (businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_TOOLSHOP)
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any toolshop.");
    //First aid kit\t500 materials\nBody repair kit\t1000 materials\nPolice scanner\t2000 materials
    if (PlayerData[playerid][pMaterials] < price)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have %i materials to buy %s.",price,itemname);
    }
    switch (itemid)
    {
        case 1:
        {
            if (PlayerData[playerid][pFirstAid] + 1 > 20)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 20 first aid kits.");
            }
            PlayerData[playerid][pFirstAid]++;
            DBQuery("UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /firstaid to in order to use a first aid kit.");
        }
        case 2:
        {
            if (PlayerData[playerid][pBodykits] + 1 > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 10 bodywork kits.");
            }
            PlayerData[playerid][pBodykits]++;
            DBQuery("UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /bodykit in a vehicle to repair its bodywork and health.");
        }
        case 3:
        {
            if (PlayerData[playerid][pPoliceScanner])
            {
                return SendClientMessage(playerid, COLOR_GREY, "You already have this item.");
            }
            PlayerData[playerid][pPoliceScanner] = 1;
            DBQuery("UPDATE "#TABLE_USERS" SET policescanner = 1 WHERE uid = %i", PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /scanner to listen to emergency and department chats.");
        }
        case 4:
        {
            if (PlayerData[playerid][pHelmet])
            {
                return SendClientMessage(playerid, COLOR_GREY, "You already have this item.");
            }
            PlayerData[playerid][pHelmet] = 1;
            DBQuery("UPDATE "#TABLE_USERS" SET helmet = %d WHERE uid = %i", PlayerData[playerid][pHelmet], PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_GREEN, "Helmet purchased. /helmet to use it.");

        }
        case 5: //pCrowbar
        {
            if (PlayerData[playerid][pVehicleCMD] == 1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 vehicle command.");
            }
            PlayerData[playerid][pCrowbar] = 1;
            DBQuery("UPDATE "#TABLE_USERS" SET crowbar = %i WHERE uid = %i", PlayerData[playerid][pCrowbar], PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use '/breakcuffs' to break cuffs from anybody's hand.");
        }
        case 6:
        {
            if (PlayerData[playerid][pHouseAlarm] > 1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 house alarm.");
            }
            PlayerData[playerid][pHouseAlarm]++;
            DBQuery("UPDATE "#TABLE_USERS" SET housealarm = %i WHERE uid = %i", PlayerData[playerid][pHouseAlarm], PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /usehousealarm in your house to install the alarm.");
        }
        /*case 7: //pVehicleCMD
        {
            if (PlayerData[playerid][pVehicleCMD] == 1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 vehicle command.");
            }
            PlayerData[playerid][pVehicleCMD] = 1;
            DBQuery("UPDATE "#TABLE_USERS" SET vehiclecmd = %i WHERE uid = %i", PlayerData[playerid][pVehicleCMD], PlayerData[playerid][pID]);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Press '2' while you are driving an vehicle to activate.");
        }*/
    }
    PlayerData[playerid][pMaterials] -= price;
    DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);

    PerformBusinessPurchase(playerid, businessid, 0, price);
    ShowActionBubble(playerid, "* %s exchanged %i materials to the shopkeeper and received a %s.", GetRPName(playerid), price,itemname);
    return 1;
}

Store:Menu_Bar(playerid, response, itemid, modelid, price, amount, itemname[])
{
    if (!response) return 1;
    new businessid = GetInsideBusiness(playerid);
    if (businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_BARCLUB)
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any bar.");
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have $%i to buy %s.", price, itemname);
    }
    switch (itemid)
    {
        case 1:
        {
            GivePlayerHealth(playerid, 10.0);
        }
        case 2:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
        }
        case 3:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
        }
        case 4:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
        }
        case 5:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
        }
    }

    if (PlayerData[playerid][pTraderUpgrade] > 0)
    {
        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
    }

    GivePlayerCash(playerid, -price);


    PerformBusinessPurchase(playerid, businessid, price);

    ShowActionBubble(playerid, "* %s paid $%i to the shopkeeper and received a %s.", GetRPName(playerid), price,itemname);
    return 1;
}
Store:Menu_Restaurant(playerid, response, itemid, modelid, price, amount, itemname[])
{
    if (!response) return 1;
    new businessid = GetInsideBusiness(playerid);
    if (businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_RESTAURANT)
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any restaurant.");
    if (PlayerData[playerid][pCash] < price)
        return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to purchase %s.", FormatCash(price),itemname);

    switch (itemid)
    {
        case 1:
        {
            GivePlayerHealth(playerid, 10.0);
        }
        case 2:
        {
            GivePlayerHealth(playerid, 15.0);
        }
        case 3:
        {
            GivePlayerHealth(playerid, 20.0);
        }
        case 4:
        {
            GivePlayerHealth(playerid, 20.0);
        }
        case 5:
        {
            GivePlayerHealth(playerid, 30.0);
        }
        case 6:
        {
            GivePlayerHealth(playerid, 30.0);
        }
        case 7:
        {
            GivePlayerHealth(playerid, 35.0);
        }
        case 8:
        {
            GivePlayerHealth(playerid, 45.0);
        }
        case 9:
        {
            GivePlayerHealth(playerid, 55.0);
        }
    }
    if (PlayerData[playerid][pTraderUpgrade] > 0)
    {
        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
    }

    GivePlayerCash(playerid, -price);

    PerformBusinessPurchase(playerid, businessid, price);


    ShowActionBubble(playerid, "* %s paid $%i to the shopkeeper and received %s.", GetRPName(playerid), price,itemname);
    return 1;
}

Store:Menu_Market(playerid, response, itemid, modelid, price, amount, itemname[])
{
    if (!response) return 1;
    new businessid = GetInsideBusiness(playerid);
    if (businessid == -1 || BusinessInfo[businessid][bType] != BUSINESS_STORE)
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any 24/7 store.");
    if (PlayerData[playerid][pCash] < price)
        return SendClientMessageEx(playerid, COLOR_GREY, "You need %s to purchase %s.", FormatCash(price),itemname);
    switch (itemid)
    {
        case 1:
        {
            DBQuery("UPDATE "#TABLE_USERS" SET phone = %i WHERE uid = %i", GetNewRandomPhoneNumber(100000, 999999), PlayerData[playerid][pID]);
            //DBQuery("UPDATE "#TABLE_USERS" SET phone = GetNewRandomPhoneNumber(100000, 999999) WHERE uid = %i", PlayerData[playerid][pID]);
            DBFormat("SELECT phone from users WHERE uid = %i", PlayerData[playerid][pID]);
            DBExecute("BuyNewPhone", "i", playerid);
        }
        case 2:
        {
            if (PlayerData[playerid][pPrivateRadio])
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a Portable Radio already.");
            }

            PlayerData[playerid][pPrivateRadio] = 1;

            DBQuery("UPDATE users SET walkietalkie = 1 WHERE uid = %i", PlayerData[playerid][pID]);


            SendClientMessage(playerid, COLOR_WHITE, "** Portable Radio purchased. Use /pr to speak and /setfreq to change the frequency.");
        }
        case 3:
        {
            if (PlayerData[playerid][pCigars] + amount > 20)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 cigars.");
            }

            PlayerData[playerid][pCigars] += amount;

            DBQuery("UPDATE users SET cigars = %i WHERE uid = %i", PlayerData[playerid][pCigars], PlayerData[playerid][pID]);


            SendClientMessageEx(playerid, COLOR_WHITE, "** %i cigars purchased. Use /usecigar to smoke a cigar.", amount);
        }
        case 4:
        {
            if (PlayerData[playerid][pSpraycans] + amount > 20)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 spraycans.");
            }

            PlayerData[playerid][pSpraycans] += amount;

            DBQuery("UPDATE users SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);


            SendClientMessageEx(playerid, COLOR_WHITE, "** %i spraycans purchased. Use /colorcar and /paintcar in a vehicle to use them.", amount);
        }
        case 5:
        {
            if (HasPhonebook(playerid))
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a phonebook already.");
            }

            GivePlayerPhonebook(playerid);
            SendClientMessage(playerid, COLOR_WHITE, "** Phonebook purchased. Use /phonebook to lookup a player's number.");
        }
        case 6:
        {
            GivePlayerWeaponEx(playerid, 43);

            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s paid $%i to the shopkeeper and received a camera.", GetRPName(playerid), price);
            SendClientMessage(playerid, COLOR_WHITE, "** Camera purchased.");
        }
        case 7:
        {
            if (PlayerData[playerid][pMP3Player])
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have an MP3 player already.");
            }

            PlayerData[playerid][pMP3Player] = 1;

            DBQuery("UPDATE users SET mp3player = 1 WHERE uid = %i", PlayerData[playerid][pID]);


            SendClientMessage(playerid, COLOR_WHITE, "** MP3 player purchased. Use /mp3 for a list of options.");
        }
        case 8:
        {
            if (PlayerData[playerid][pFishingRod])
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a fishing rod already.");
            }

            PlayerData[playerid][pFishingRod] = 1;

            DBQuery("UPDATE users SET fishingrod = 1 WHERE uid = %i", PlayerData[playerid][pID]);


            SendClientMessage(playerid, COLOR_WHITE, "** Fishing rod purchased. Use /fish at the pier or in a boat to begin fishing.");
        }
        case 9:
        {
            if (PlayerData[playerid][pFishingBait] + amount >= 20)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 pieces of bait.");
            }

            PlayerData[playerid][pFishingBait] += amount;

            DBQuery("UPDATE users SET fishingbait = %i WHERE uid = %i", PlayerData[playerid][pFishingBait], PlayerData[playerid][pID]);


            SendClientMessageEx(playerid, COLOR_WHITE, "** %i fish baits purchased. Bait increases the odds of catching bigger fish.", amount);
        }
        case 10:
        {
            if (PlayerData[playerid][pMuriaticAcid] + amount > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 bottles of muriatic acid.");
            }

            PlayerData[playerid][pMuriaticAcid] += amount;

            DBQuery("UPDATE users SET muriaticacid = %i WHERE uid = %i", PlayerData[playerid][pMuriaticAcid], PlayerData[playerid][pID]);


            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s paid $%i to the shopkeeper and received a bottle of muriatic acid.", GetRPName(playerid), price);
            SendClientMessageEx(playerid, COLOR_WHITE, "** %i muriatic acid bottles purchased.", amount);
        }
        case 11:
        {
            if (PlayerData[playerid][pBakingSoda] + amount > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 bottles of baking soda.");
            }

            PlayerData[playerid][pBakingSoda] += amount;

            DBQuery("UPDATE users SET bakingsoda = %i WHERE uid = %i", PlayerData[playerid][pBakingSoda], PlayerData[playerid][pID]);


            SendClientMessageEx(playerid, COLOR_WHITE, "** %i baking soda bottles purchased.", amount);
        }
        case 12:
        {
            if (PlayerData[playerid][pWatch])
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a pocket watch already.");
            }

            PlayerData[playerid][pWatch] = 1;

            DBQuery("UPDATE users SET watch = 1 WHERE uid = %i", PlayerData[playerid][pID]);


            SendClientMessage(playerid, COLOR_WHITE, "** Pocket watch purchased. Use /watch to toggle it.");
        }
        case 13:
        {
            if (PlayerData[playerid][pGPS])
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You have a GPS already.");
            }

            PlayerData[playerid][pGPS] = 1;

            DBQuery("UPDATE users SET gps = 1 WHERE uid = %i", PlayerData[playerid][pID]);


            SendClientMessage(playerid, COLOR_WHITE, "** GPS purchased. Use /gps to toggle it.");
        }
        case 14:
        {
            if (PlayerData[playerid][pGasCan] + amount > GetPlayerCapacity(playerid, CAPACITY_GASCAN))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than %i liters of gas.", GetPlayerCapacity(playerid, CAPACITY_GASCAN));
            }

            PlayerData[playerid][pGasCan] += amount;

            DBQuery("UPDATE users SET gascan = %i WHERE uid = %i", PlayerData[playerid][pGasCan], PlayerData[playerid][pID]);


            SendClientMessageEx(playerid, COLOR_WHITE, "** %i gas cans purchased. Use /gascan in a vehicle to refill its fuel.", amount);
        }
        case 15:
        {
            if (PlayerData[playerid][pRope] + amount > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 ropes.");
            }

            PlayerData[playerid][pRope] += amount;

            DBQuery("UPDATE users SET rope = %i WHERE uid = %i", PlayerData[playerid][pRope], PlayerData[playerid][pID]);


            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s paid $%i to the shopkeeper and received 2 ropes.", GetRPName(playerid), price);
            SendClientMessageEx(playerid, COLOR_WHITE, "%i ropes purchased. Use /tie to tie people in your vehicle.", amount);
        }
        case 16:
        {
            if (PlayerData[playerid][pBlindfold] + amount > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 10 blindfolds.");
            }

            PlayerData[playerid][pBlindfold] += amount;

            DBQuery("UPDATE users SET blindfold = %i WHERE uid = %i", PlayerData[playerid][pBlindfold], PlayerData[playerid][pID]);


            SendClientMessageEx(playerid, COLOR_WHITE, "%i blindfolds purchased. Use /blindfold to blindfold people in your vehicle.", amount);
        }
        case 17:
        {
            if (PlayerData[playerid][pCondom] + amount > 20)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[ERROR]{ffffff} You can't have more than 20 condoms.");
            }

            PlayerData[playerid][pCondom] += amount;

            DBQuery("UPDATE users SET condom = %i WHERE uid = %i", PlayerData[playerid][pCondom], PlayerData[playerid][pID]);
            SendClientMessageEx(playerid, COLOR_WHITE, "%i condom(s) purchased. Next time when you have sex you will not got STD.", amount);
        }
        case 18:
        {
            //TODO: perform biz purchase
            return Dialog_Show(playerid, LottoMenu, DIALOG_STYLE_INPUT, "Lottery Ticket Selection", "Please enter a Lotto Number!", "Buy", "Cancel" );
        }

    }
    GivePlayerCash(playerid, -price);

    PerformBusinessPurchase(playerid, businessid, price);
    return 1;
}
GetClosestBusiness(playerid, type)
{
    new
        Float:distance[2] = {99999.0, 0.0},
        index = -1;

    foreach(new i : Business)
    {
        if ((BusinessInfo[i][bExists] && BusinessInfo[i][bType] == type) && (BusinessInfo[i][bOutsideInt] == 0 && BusinessInfo[i][bOutsideVW] == 0))
        {
            distance[1] = GetPlayerDistanceFromPoint(playerid, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]);

            if (distance[0] > distance[1])
            {
                distance[0] = distance[1];
                index = i;
            }
        }
    }

    return index;
}

GetNearbyBusinessEx(playerid)
{
    return GetNearbyBusiness(playerid) == -1 ? GetInsideBusiness(playerid) : GetNearbyBusiness(playerid);
}

GetNearbyBusiness(playerid, Float:radius = 2.0)
{
    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && IsPlayerInRangeOfPoint(playerid, radius, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]) && GetPlayerInterior(playerid) == BusinessInfo[i][bOutsideInt] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bOutsideVW])
        {
            return i;
        }
    }

    return -1;
}

GetInsideBusiness(playerid)
{
    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && IsPlayerInRangeOfPoint(playerid, 100.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]) && GetPlayerInterior(playerid) == BusinessInfo[i][bInterior] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bWorld])
        {
            return i;
        }
    }

    return -1;
}


SetBusinessOwner(businessid, playerid)
{
    if (playerid == INVALID_PLAYER_ID)
    {
        strcpy(BusinessInfo[businessid][bOwner], "Nobody", MAX_PLAYER_NAME);
        BusinessInfo[businessid][bOwnerID] = 0;
    }
    else
    {
        GetPlayerName(playerid, BusinessInfo[businessid][bOwner], MAX_PLAYER_NAME);
        BusinessInfo[businessid][bOwnerID] = PlayerData[playerid][pID];
    }

    BusinessInfo[businessid][bTimestamp] = gettime();
    DBQuery("UPDATE businesses SET timestamp = %i, ownerid = %i, owner = '%e' WHERE id = %i", BusinessInfo[businessid][bTimestamp], BusinessInfo[businessid][bOwnerID], BusinessInfo[businessid][bOwner], BusinessInfo[businessid][bID]);
    ReloadBusiness(businessid);
}
OfflineSetBusinessOwner(aplayerid, businessid,username[])
{

    DBFormat("SELECT * FROM "#TABLE_USERS" WHERE username = '%e'", username);
    DBExecute("OnOChangeBizOwnerGotUsers", "ii",aplayerid,businessid);

}

DB:OnOChangeBizOwnerGotUsers(playerid,businessid)
{
    new rows = GetDBNumRows();
    if (rows)
    {
        GetDBStringField(0, "username", BusinessInfo[businessid][bOwner], MAX_PLAYER_NAME);

        BusinessInfo[businessid][bOwnerID] = GetDBIntField(0, "uid");
        BusinessInfo[businessid][bTimestamp] = gettime();

        DBQuery("UPDATE businesses SET timestamp = %i, ownerid = %i, owner = '%e' WHERE id = %i", BusinessInfo[businessid][bTimestamp], BusinessInfo[businessid][bOwnerID], BusinessInfo[businessid][bOwner], BusinessInfo[businessid][bID]);

        DBLog("log_property", "%s (uid: %i) has edited business id owner to (id: %s).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], BusinessInfo[businessid][bOwner]);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of business %i to %s.", businessid, BusinessInfo[businessid][bOwner]);

        ReloadBusiness(businessid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Unvalid username.");
    }
}
/*
GetBusinessDefaultPickup(business)
{
    switch (BusinessInfo[business][bType])
    {
        case BUSINESS_STORE: return 1274;
        case BUSINESS_CLOTHES: return 1275;
        case BUSINESS_RESTAURANT: return 19094;
        case BUSINESS_TOOLSHOP: return 1274;
        case BUSINESS_AGENCY: return 1274;
        case BUSINESS_BARCLUB:
        {
            new rnd = random(4);
            if (rnd == 0) return 1486;
            if (rnd == 1) return 1543;
            if (rnd == 2) return 1544;
            if (rnd == 3) return 1951;
        }
        case BUSINESS_GYM: return 1318;
        default: return 1274;
    }
    return 1318;
}*/

ReloadBusiness(businessid)
{
    if (BusinessInfo[businessid][bExists])
    {
        new
            string[300];

        DestroyDynamic3DTextLabel(BusinessInfo[businessid][bText]);
        DestroyDynamicPickup(BusinessInfo[businessid][bPickup]);
        if (BusinessInfo[businessid][bMapIcon] != -1)
            DestroyDynamicMapIcon(BusinessInfo[businessid][bMapIcon]);

        if (BusinessInfo[businessid][bOwnerID] == 0)
        {
            format(string, sizeof(string), "{AAC4E5}%s (ID %i)\n{FFFFFF}\nType: {AAC4E5}%s\n{FFFFFF}Entry Fee: $%i\nPrice: {FFFFFF}%s\n%s",BusinessInfo[businessid][bName], businessid, bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bEntryFee], FormatCash(BusinessInfo[businessid][bPrice]), (BusinessInfo[businessid][bLocked]) ? ("{FFFF00}Closed") : ("{00AA00}Opened"));
        }
        else
        {
            format(string, sizeof(string), "{AAC4E5}%s (ID %i)\n{FFFFFF}Owner: %s\nType: {AAC4E5}%s\n{FFFFFF}Entry Fee: $%i\n%s", BusinessInfo[businessid][bName], businessid, BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bEntryFee], (BusinessInfo[businessid][bLocked]) ? ("{FFFF00}Closed") : ("{00AA00}Opened"));
        }

        BusinessInfo[businessid][bText] = CreateDynamic3DTextLabel(string, COLOR_GREY1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ] + 0.4, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, BusinessInfo[businessid][bOutsideVW], BusinessInfo[businessid][bOutsideInt], -1 , 10.0);
        BusinessInfo[businessid][bPickup] = CreateDynamicPickup(1272, 1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt]);
        //BusinessInfo[businessid][bPickup] = CreateDynamicPickup(GetBusinessDefaultPickup(businessid), 1, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt]);

        if (BusinessInfo[businessid][bDisplayMapIcon])
        {
            switch (BusinessInfo[businessid][bType])
            {
                case BUSINESS_DEALERSHIP:   BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 55, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_STORE:        BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 17, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_GUNSHOP:      BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 6, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_CLOTHES:      BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 45, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_RESTAURANT:   BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 10, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_GYM:          BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 54, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_AGENCY:       BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 58, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_BARCLUB:      BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 49, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
                case BUSINESS_TOOLSHOP:     BusinessInfo[businessid][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], 11, 0, .worldid = BusinessInfo[businessid][bOutsideVW], .interiorid = BusinessInfo[businessid][bOutsideInt], .style = MAPICON_GLOBAL);
            }
        }
    }
}

IsBusinessOwner(playerid, businessid)
{
    return (BusinessInfo[businessid][bOwnerID] == PlayerData[playerid][pID]);
}


GetBusinessTypeStr(type)
{
    new string[MAX_BUSINESSES_NAME];
    switch (type)
    {
        case BUSINESS_STORE:{
            format(string,sizeof(string), "24/7");
        }
        case BUSINESS_GUNSHOP:{
            format(string ,sizeof(string), "Gunstore");
        }
        case BUSINESS_CLOTHES:{
            format(string ,sizeof(string), "Clothes Store");
        }
        case BUSINESS_GYM:{
            format(string ,sizeof(string), "Gym");
        }
        case BUSINESS_RESTAURANT:{
            format(string ,sizeof(string), "Restaurant");
        }
        case BUSINESS_AGENCY:{
            format(string ,sizeof(string), "AdStore");
        }
        case BUSINESS_BARCLUB:{
            format(string ,sizeof(string), "BarClub");
        }
        case BUSINESS_TOOLSHOP:{
            format(string ,sizeof(string), "ToolShop");
        }
        case BUSINESS_DEALERSHIP:{
            format(string ,sizeof(string), "Dealership");
        }
        default:{
            format(string ,sizeof(string), "N/A");
        }
    }
    return string;
}

DB:OnAdminCreateBusiness(playerid, businessid, type, Float:x, Float:y, Float:z, Float:angle)
{
    strcpy(BusinessInfo[businessid][bOwner], "Nobody", MAX_PLAYER_NAME);

    BusinessInfo[businessid][bExists] = 1;
    BusinessInfo[businessid][bID] = GetDBInsertID();
    BusinessInfo[businessid][bOwnerID] = 0;
    BusinessInfo[businessid][bName] = GetBusinessTypeStr(type);
    //format(BusinessInfo[businessid][bMessage],sizeof(BusinessInfo[businessid][bMessage]),"Welcome, please use /buy to buy products!");
    BusinessInfo[businessid][bDealerShipType] = 0;
    BusinessInfo[businessid][bType] = type;
    BusinessInfo[businessid][bPrice] = bizInteriors[type][intPrice];
    BusinessInfo[businessid][bEntryFee] = 0;
    BusinessInfo[businessid][bLocked] = 0;
    BusinessInfo[businessid][bPosX] = x;
    BusinessInfo[businessid][bPosY] = y;
    BusinessInfo[businessid][bPosZ] = z;
    BusinessInfo[businessid][bPosA] = angle;
    BusinessInfo[businessid][bIntX] = bizInteriors[type][intX];
    BusinessInfo[businessid][bIntY] = bizInteriors[type][intY];
    BusinessInfo[businessid][bIntZ] = bizInteriors[type][intZ];
    BusinessInfo[businessid][bIntA] = bizInteriors[type][intA];
    BusinessInfo[businessid][bInterior] = bizInteriors[type][intID];
    BusinessInfo[businessid][bWorld] = BusinessInfo[businessid][bID] + 3000000;
    BusinessInfo[businessid][bOutsideInt] = GetPlayerInterior(playerid);
    BusinessInfo[businessid][bOutsideVW] = GetPlayerVirtualWorld(playerid);
    BusinessInfo[businessid][bCash] = 0;
    BusinessInfo[businessid][bProducts] = 500;
    BusinessInfo[businessid][bMaterials] = 0;
    BusinessInfo[businessid][bText] = Text3D:INVALID_3DTEXT_ID;
    BusinessInfo[businessid][bPickup] = -1;
    BusinessInfo[businessid][bMapIcon] = -1;
    BusinessInfo[businessid][bDisplayMapIcon] = 0;
    Iter_Add(Business, businessid);

    DBQuery("UPDATE businesses SET world = %i WHERE id = %i", BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);


    ReloadBusiness(businessid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created a business id %i, type %i.",GetAdmCmdRank(playerid), GetRPName(playerid), businessid, BusinessInfo[businessid][bType]);
    SendClientMessageEx(playerid, COLOR_GREEN, "* Business %i created successfully.", businessid);
}
new PlayerText:BizMessageText[MAX_PLAYERS];

DisplayBizMessage(playerid,businessid)
{
    PlayerTextDrawSetString(playerid, BizMessageText[playerid], BusinessInfo[businessid][bMessage]); // <<< Update the text to show the vehicle health
    PlayerTextDrawShow(playerid, BizMessageText[playerid]);
    defer HideBizMessage(playerid);
}

timer HideBizMessage[10000](playerid)
{
    PlayerTextDrawHide(playerid,BizMessageText[playerid]);
}

InitBizMessage(playerid)
{
    BizMessageText[playerid] = CreatePlayerTextDraw(playerid, 131.599975, 340.100830, "Welcome,$_please_use_/buy_to_buy_products!");
    PlayerTextDrawLetterSize(playerid, BizMessageText[playerid], 0.208500, 0.974376);
    PlayerTextDrawAlignment(playerid, BizMessageText[playerid], 1);
    PlayerTextDrawColor(playerid, BizMessageText[playerid], -1);
    PlayerTextDrawSetShadow(playerid, BizMessageText[playerid], 0);
    PlayerTextDrawSetOutline(playerid, BizMessageText[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, BizMessageText[playerid], 255);
    PlayerTextDrawFont(playerid, BizMessageText[playerid], 2);
    PlayerTextDrawSetProportional(playerid, BizMessageText[playerid], 1);
    PlayerTextDrawSetShadow(playerid, BizMessageText[playerid], 0);
}

CMD:createbiz(playerid, params[])
{
    new type, Float:x, Float:y, Float:z, Float:a;

    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", type))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createbiz [type]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: (1) 24/7 (2) Gun Shop (3) Clothes Shop (4) Gym (5) Restaurant (6) Ad Agency (7) Club/Bar (8) Tool Shop (9) Dealership");
        return 1;
    }
    if (!(1 <= type <= sizeof(bizInteriors)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
    }
    if (GetNearbyBusiness(playerid) >= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is a business in range. Find somewhere else to create this one.");
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    type--;

    for (new i = 0; i < MAX_BUSINESSES; i ++)
    {
        if (!BusinessInfo[i][bExists])
        {
            DBFormat("INSERT INTO businesses (name,message,type,dealershiptype, price, pos_x, pos_y, pos_z, pos_a, int_x, int_y, int_z, int_a, interior, outsideint, outsidevw) VALUES('%e','Welcome, please use /buy to buy products.',%i, 0, %i, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', %i, %i, %i)", GetBusinessTypeStr(type), type, bizInteriors[type][intPrice], x, y, z, a - 180.0,
                bizInteriors[type][intX], bizInteriors[type][intY], bizInteriors[type][intZ], bizInteriors[type][intA], bizInteriors[type][intID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            DBExecute("OnAdminCreateBusiness", "iiiffff", playerid, i, type, x, y, z, a);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Business slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:editbiz(playerid, params[])
{
    new businessid, option[20], param[32];

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[20]S()[32]", businessid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Entrance, Exit, Interior, World, Type, Owner, Price, EntryFee, Products, Materials, Locked, Vehspawn, DisplayMapIcon, dstype");
        return 1;
    }
    if (!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
    }

    if (!strcmp(option, "dstype", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [dstype] [car/boat/plane]");
        }
        if (!strcmp(param, "car", true))
        {
            BusinessInfo[businessid][bDealerShipType] = DSCars;
        }
        else if (!strcmp(param, "boat", true))
        {
            BusinessInfo[businessid][bDealerShipType] = DSBoats;
        }
        else if (!strcmp(param, "plane", true))
        {
            BusinessInfo[businessid][bDealerShipType] = DSPlanes;
        }
        else
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [dstype] [car/boat/plane]");
        }

        DBQuery("UPDATE businesses SET dealershiptype = %i WHERE id = %i", BusinessInfo[businessid][bDealerShipType], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map dealership type of business %i to %s.", businessid, param);
    }
    else if (!strcmp(option, "displaymapicon", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [displaymapicon] [true/false]");
        }
        if (!strcmp(param, "true", true))
        {
            BusinessInfo[businessid][bDisplayMapIcon] = 1;
        }
        else if (!strcmp(param, "false", true))
        {
            BusinessInfo[businessid][bDisplayMapIcon] = 0;
        }
        else
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [displaymapicon] [true/false]");
        }

        DBQuery("UPDATE businesses SET displaymapicon = %i WHERE id = %i", BusinessInfo[businessid][bDisplayMapIcon], BusinessInfo[businessid][bID]);

        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the map icon state of business %i to %s.", businessid, param);
    }
    else if (!strcmp(option, "entrance", true))
    {
        GetPlayerPos(playerid, BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ]);
        GetPlayerFacingAngle(playerid, BusinessInfo[businessid][bPosA]);

        BusinessInfo[businessid][bOutsideInt] = GetPlayerInterior(playerid);
        BusinessInfo[businessid][bOutsideVW] = GetPlayerVirtualWorld(playerid);

        DBQuery("UPDATE businesses SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', outsideint = %i, outsidevw = %i WHERE id = %i", BusinessInfo[businessid][bPosX], BusinessInfo[businessid][bPosY], BusinessInfo[businessid][bPosZ], BusinessInfo[businessid][bPosA], BusinessInfo[businessid][bOutsideInt], BusinessInfo[businessid][bOutsideVW], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entrance of business %i.", businessid);
    }
    else if (!strcmp(option, "vehspawn", true))
    {
        GetPlayerPos(playerid, BusinessInfo[businessid][cVehicle][0], BusinessInfo[businessid][cVehicle][1], BusinessInfo[businessid][cVehicle][2]);
        GetPlayerFacingAngle(playerid, BusinessInfo[businessid][cVehicle][3]);
        DBQuery("UPDATE `businesses` SET `cVehicleX` = %.4f, `cVehicleY` = %.4f, `cVehicleZ` = %.4f, `cVehicleA` = %.4f WHERE id = %i",
            BusinessInfo[businessid][cVehicle][0],BusinessInfo[businessid][cVehicle][1],BusinessInfo[businessid][cVehicle][2],BusinessInfo[businessid][cVehicle][3], BusinessInfo[businessid][bID]);
        SendAdminMessage(COLOR_RED, "Admin: %s has edited the vehicle spawn of business %i.", GetRPName(playerid), businessid);
    }
    else if (!strcmp(option, "exit", true))
    {
        new type = -1;

        for (new i = 0; i < sizeof(bizInteriors); i ++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 100.0, bizInteriors[i][intX], bizInteriors[i][intY], bizInteriors[i][intZ]))
            {
                type = i;
            }
        }

        GetPlayerPos(playerid, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ]);
        GetPlayerFacingAngle(playerid, BusinessInfo[businessid][bIntA]);

        BusinessInfo[businessid][bInterior] = GetPlayerInterior(playerid);
        BusinessInfo[businessid][bType] = type;

        DBQuery("UPDATE businesses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i WHERE id = %i", type, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the exit of business %i.", businessid);
    }
    else if (!strcmp(option, "interior", true))
    {
        new string[1024];

        for (new i = 0; i < sizeof(bizInteriorArray); i ++)
        {
            format(string, sizeof(string), "%s\n%s", string, bizInteriorArray[i][intName]);
        }

        PlayerData[playerid][pSelected] = businessid;
        Dialog_Show(playerid, DIALOG_BIZINTERIOR, DIALOG_STYLE_LIST, "Choose an interior to set for this business.", string, "Select", "Cancel");
    }
    else if (!strcmp(option, "world", true))
    {
        new worldid;

        if (sscanf(param, "i", worldid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [world] [vw]");
        }

        BusinessInfo[businessid][bWorld] = worldid;

        DBQuery("UPDATE businesses SET world = %i WHERE id = %i", BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the virtual world of business %i to %i.", businessid, worldid);
    }
    else if (!strcmp(option, "type", true))
    {
        new type;

        if (sscanf(param, "i", type))
        {
            SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [type] [value (1-%i)]", sizeof(bizInteriors));
            SendClientMessage(playerid, COLOR_SYNTAX, "List of options: (1) 24/7 (2) Gun Shop (3) Clothes Shop (4) Gym (5) Restaurant (6) Ad Agency (7) Club/Bar (8) Tool Shop");
            return 1;
        }
        if (!(1 <= type <= sizeof(bizInteriors)))
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
        DBQuery("UPDATE businesses SET type = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type-1, BusinessInfo[businessid][bIntX], BusinessInfo[businessid][bIntY], BusinessInfo[businessid][bIntZ], BusinessInfo[businessid][bIntA], BusinessInfo[businessid][bInterior], BusinessInfo[businessid][bWorld], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the type of business %i to %i.", businessid, type);
    }
    else if (!strcmp(option, "owner", true))
    {
        new targetid;

        if (sscanf(param, "u", targetid))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [owner] [playerid]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (!PlayerData[targetid][pLogged])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
        }

        SetBusinessOwner(businessid, targetid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the owner of business %i to %s.", businessid, GetRPName(targetid));
        DBLog("log_property", "%s (uid: %i) has edited business id owner to (id: %s).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid));

    }
    else if (!strcmp(option, "price", true))
    {
        new price;

        if (sscanf(param, "i", price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [price] [value]");
        }
        if (price < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
        }

        BusinessInfo[businessid][bPrice] = price;

        DBQuery("UPDATE businesses SET price = %i WHERE id = %i", BusinessInfo[businessid][bPrice], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the price of business %i to $%i.", businessid, price);
    }
    else if (!strcmp(option, "entryfee", true))
    {
        new price;

        if (sscanf(param, "i", price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [entryfee] [value]");
        }
        if (price < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
        }

        BusinessInfo[businessid][bEntryFee] = price;

        DBQuery("UPDATE businesses SET entryfee = %i WHERE id = %i", BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the entry fee of business %i to $%i.", businessid, price);
    }
    else if (!strcmp(option, "products", true))
    {
        new amount;

        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [products] [value]");
        }

        BusinessInfo[businessid][bProducts] = amount;

        DBQuery("UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the products amount of business %i to %i.", businessid, amount);
    }
    else if (!strcmp(option, "materials", true))
    {
        new amount;

        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [materials] [value]");
        }

        BusinessInfo[businessid][bMaterials] = amount;

        DBQuery("UPDATE businesses SET materials = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the materials amount of business %i to %i.", businessid, amount);
    }
    else if (!strcmp(option, "locked", true))
    {
        new locked;

        if (sscanf(param, "i", locked) || !(0 <= locked <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editbiz [businessid] [locked] [0/1]");
        }

        BusinessInfo[businessid][bLocked] = locked;

        DBQuery("UPDATE businesses SET locked = %i WHERE id = %i", BusinessInfo[businessid][bLocked], BusinessInfo[businessid][bID]);


        ReloadBusiness(businessid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of business %i to %i.", businessid, locked);
    }

    return 1;
}

CMD:removebiz(playerid, params[])
{
    new businessid;

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", businessid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removebiz [businessid]");
    }
    if (!(0 <= businessid < MAX_HOUSES) || !BusinessInfo[businessid][bExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
    }

    ClearProducts(businessid);
    DestroyDynamic3DTextLabel(BusinessInfo[businessid][bText]);
    DestroyDynamicPickup(BusinessInfo[businessid][bPickup]);
    if (BusinessInfo[businessid][bDisplayMapIcon])
        DestroyDynamicMapIcon(BusinessInfo[businessid][bMapIcon]);

    DBQuery("DELETE FROM businesses WHERE id = %i", BusinessInfo[businessid][bID]);


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

    if (!IsAdmin(playerid, ADMIN_LVL_9) && !PlayerData[playerid][pDynamicAdmin] && !PlayerData[playerid][pWebDev])
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[20]S()[32]", businessid, username))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ochangebizowner [businessid] [username]");
        return 1;
    }
    if (!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid business id.");
    }

    OfflineSetBusinessOwner(playerid,businessid,username);
    return 1;
}
CMD:gotobiz(playerid, params[])
{
    new businessid;

    if (!IsAdmin(playerid, ADMIN_LVL_6) && !PlayerData[playerid][pWebDev])
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", businessid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotobiz [businessid]");
    }
    if (!(0 <= businessid < MAX_HOUSES) || !BusinessInfo[businessid][bExists])
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
    if ((businessid = GetNearbyBusiness(playerid)) == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no business in range. You must be near a business.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buybiz [confirm]");
    }
    if (BusinessInfo[businessid][bOwnerID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This business already has an owner.");
    }
    if (PlayerData[playerid][pCash] < BusinessInfo[businessid][bPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this business.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) >= GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i businesses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
    }

    SetBusinessOwner(businessid, playerid);
    GivePlayerCash(playerid, -BusinessInfo[businessid][bPrice]);

    SendClientMessageEx(playerid, COLOR_GREEN, "You paid $%i for this %s. /bizhelp for a list of commands.", BusinessInfo[businessid][bPrice], bizInteriors[BusinessInfo[businessid][bType]][intType]);
    DBLog("log_property", "%s (uid: %i) purchased %s (id: %i) for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], BusinessInfo[businessid][bPrice]);
    return 1;
}

CMD:bwithdraw(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid), amount;

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bwithdraw [amount] (%s available)", FormatCash(BusinessInfo[businessid][bCash]));
    }
    if (amount < 1 || amount > BusinessInfo[businessid][bCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }

    BusinessInfo[businessid][bCash] -= amount;
    GivePlayerCash(playerid, amount);

    DBQuery("UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %s from the business vault. There is now %s remaining.", FormatCash(amount), FormatCash(BusinessInfo[businessid][bCash]));
    return 1;
}

CMD:bdeposit(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid), amount;

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bdeposit [amount] (%s available)", FormatCash(BusinessInfo[businessid][bCash]));
    }
    if (amount < 1 || amount > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }
    if (PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
    }

    BusinessInfo[businessid][bCash] += amount;
    GivePlayerCash(playerid, -amount);

    DBQuery("UPDATE businesses SET cash = %i WHERE id = %i", BusinessInfo[businessid][bCash], BusinessInfo[businessid][bID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %s in the business vault. There is now %s available.", FormatCash(amount), FormatCash(BusinessInfo[businessid][bCash]));
    return 1;
}

CMD:bwithdrawmats(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid), amount;

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
    }
    if (BusinessInfo[businessid][bType] != BUSINESS_TOOLSHOP)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command can only be used in tool shops.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bwithdrawmats [amount] (%i available)", BusinessInfo[businessid][bMaterials]);
    }
    if (amount < 1 || amount > BusinessInfo[businessid][bMaterials])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }
    if (PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
    }

    BusinessInfo[businessid][bMaterials] -= amount;
    PlayerData[playerid][pMaterials] += amount;

    DBQuery("UPDATE businesses SET materials = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bID]);


    DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i materials from the business vault. There is now %i remaining.", amount, BusinessInfo[businessid][bMaterials]);
    return 1;
}

CMD:bdepositmats(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid), amount;

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any business of yours.");
    }
    if (BusinessInfo[businessid][bType] != BUSINESS_TOOLSHOP)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command can only be used in tool shops.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /bdepositmats [amount] (%i available)", BusinessInfo[businessid][bMaterials]);
    }
    if (amount < 1 || amount > PlayerData[playerid][pMaterials])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }

    BusinessInfo[businessid][bMaterials] += amount;
    PlayerData[playerid][pMaterials] -= amount;

    DBQuery("UPDATE businesses SET materials = %i WHERE id = %i", BusinessInfo[businessid][bMaterials], BusinessInfo[businessid][bID]);


    DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i materials in the business vault. There is now %i available.", amount, BusinessInfo[businessid][bMaterials]);
    return 1;
}

CMD:sellbiz(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid), targetid, amount;

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellbiz [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell to yourself.");
    }
    if (amount < 1)
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

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmybiz [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "This command sells your business back to the state. You will receive %s back.", FormatCash(percent(BusinessInfo[businessid][bPrice], 75)));
        return 1;
    }

    SetBusinessOwner(businessid, INVALID_PLAYER_ID);
    GivePlayerCash(playerid, percent(BusinessInfo[businessid][bPrice], 75));

    SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your business to the state and received %s back.", FormatCash(percent(BusinessInfo[businessid][bPrice], 75)));
    DBLog("log_property", "%s (uid: %i) sold their %s business (id: %i) to the state for %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], percent(BusinessInfo[businessid][bPrice], 75));
    return 1;
}

CMD:biz(playerid, params[])
{
    return callcmd::bizmenu(playerid, params);
}

CMD:bizmenu(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid);

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
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


IsPlayerAtFoodPlace(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 12.0, 1174.0956, -936.1318, 42.8307) || IsPlayerInRangeOfPoint(playerid, 12.0, 1514.9395, -1031.0515, 23.7966) || IsPlayerInRangeOfPoint(playerid, 12.0, 1202.5309, -1275.9502, 13.3616) || IsPlayerInRangeOfPoint(playerid, 12.0, 1418.1516, -1721.0294, 13.5469))
    {
        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 12.0, 339.2676, -1771.2668, 5.1687) || IsPlayerInRangeOfPoint(playerid, 12.0, 1023.6545, -1332.1298, 13.3842) || IsPlayerInRangeOfPoint(playerid, 12.0, 1189.3583, -1706.9924, 13.5755) || IsPlayerInRangeOfPoint(playerid, 12.0, 2083.0374, -1760.8845, 13.5625))
    {
        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 12.0, 2264.8145, -1309.9031, 23.9844))
    {
        return 1;
    }
    return 0;
}

CMD:buy(playerid, params[])
{
    if ( IsPlayerInAnyVehicle( playerid ) )
        return SendClientMessage( playerid, COLOR_GREY, "You cant purchase from a vehicle." );
    if (IsPlayerAtFoodPlace(playerid))
    {
        Dialog_Show(playerid, DIALOG_FOOD, DIALOG_STYLE_LIST, "Select an item",
            "Sprunk ($50)\nCigar($35)\nHot Dog($25)\nRope ($20)\nChocolate($15)", "Buy", "Cancel");
    }

    if (PlayerData[playerid][pNotoriety] >= 10000)
        return SendClientMessageEx(playerid, COLOR_GREY, "You're way too notorious dude, I'm not doing business with a well known criminal. Get outta here fool!");

    new businessid = GetInsideBusiness(playerid), title[64];

    if (businessid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any business where you can buy stuff.");
    }

    format(title, sizeof(title), "%s's %s [%i products]", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

    switch (BusinessInfo[businessid][bType])
    {
        case BUSINESS_DEALERSHIP:
        {
            PlayerData[playerid][pDealership] = 0;
            ShowDealerShipInterface(playerid);
        }
        case BUSINESS_STORE:
        {
        //                             ID   model     name              price                 max stack
            MenuStore_AddItem(playerid, 1,  18874,  "Mobile Phone",     600);
            MenuStore_AddItem(playerid, 2,  330,    "Portable Radio",   5000);
            MenuStore_AddItem(playerid, 3,  19625,  "Cigarette",        25,     "", 0.0, true,   20);
            MenuStore_AddItem(playerid, 4,  365,    "Spraycan",         80,     "", 0.0, true,   20);
            MenuStore_AddItem(playerid, 5,  1718,   "Phonebook",        250);
            MenuStore_AddItem(playerid, 6,  367,    "Camera",           300);
            MenuStore_AddItem(playerid, 7,  19617,  "MP3 Player",       5000);
            MenuStore_AddItem(playerid, 8,  18632,  "Fishing Rod",      1000);
            MenuStore_AddItem(playerid, 9,  19063,  "Fish bait",        100,    "", 0.0, true,   20);
            MenuStore_AddItem(playerid, 10, 19823,  "Muriatic Acid",    1500,   "", 0.0, true,   10);
            MenuStore_AddItem(playerid, 11, 2709,   "Baking Soda",      1200,   "", 0.0, true,   10);
            MenuStore_AddItem(playerid, 12, 19039,  "Pocket Watch",     1000);
            MenuStore_AddItem(playerid, 13, 19167,  "GPS System",       10000);
            MenuStore_AddItem(playerid, 14, 1650,   "Gasoline Can",     500,    "", 0.0, true,   20);
            MenuStore_AddItem(playerid, 15, 19088,  "Rope",             100,    "", 0.0, true,   10);
            MenuStore_AddItem(playerid, 16, 18912,  "Blindfold",        1000,   "", 0.0, true,   10);
            MenuStore_AddItem(playerid, 17, 322,    "Condom",           20,     "", 0.0, true,   20);
            MenuStore_Show(playerid, Menu_Market, "24/7 Supermarket");
        }
        case BUSINESS_GUNSHOP:
        {
            MenuStore_AddItem(playerid, 1,  346,    "9mm pistol",       1500);
            MenuStore_AddItem(playerid, 2,  349,    "Shotgun",          6000,  "", 0, true,1, 0.0,0.0,70.0,2.2);
            MenuStore_AddItem(playerid, 3,  357,    "Country rifle",    24000, "", 0, true,1, 0.0,0.0,70.0,2.2);
            MenuStore_AddItem(playerid, 4,  1242,   "Light armor",      3000);
            MenuStore_AddItem(playerid, 5,  19515,  "Medium Armor",     6000,  "", 0, true,1, 0.0,270.0,0.0,1.0);
            MenuStore_Show(playerid, Menu_GunStore, "GunStore");
        }
        case BUSINESS_CLOTHES:
        {
            if (PlayerData[playerid][pLevel] < 3)
            {
                SendClientMessage(playerid, COLOR_GREY, "You need to be level 3+ to buy clothes.");
            }
            else
            {
                Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Clothes ($1000)\nGlasses ($500)\nBandanas & masks ($375)\nHats & caps ($240)\nMisc clothing ($500)", "Select", "Cancel");
            }
        }
        case BUSINESS_GYM:
        {
            Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, title, "Normal (Free)\nBoxing ($4725)\nKung Fu ($7650)\nKneehead ($9275)\nGrabkick ($1250)\nElbow ($2950)", "Select", "Cancel");
        }
        case BUSINESS_RESTAURANT:
        {
            MenuStore_AddItem(playerid, 1,  19570,  "Water",                              30);
            MenuStore_AddItem(playerid, 2,  2601,   "Sprunk",                             50);
            MenuStore_AddItem(playerid, 3,  2769,   "Club sandwich",                      80);
            MenuStore_AddItem(playerid, 4,  2218,   "A tray of pizza",                    90, "", 0, true,1, 0.0,0.0,210.0,2.2);
            MenuStore_AddItem(playerid, 5,  2219,   "Tray with lots of food",            100, "", 0, true,1, 0.0,0.0,230.0,2.2);
            MenuStore_AddItem(playerid, 6,  2221,   "Tray with coffee and two muffins",  100, "", 0, true,1, 315.0,0.0,0.0,1);
            MenuStore_AddItem(playerid, 7,  2703,   "Hamburger",                         120, "", 0, true,1, 0.0,0.0,100.0,1.0);
            MenuStore_AddItem(playerid, 8,  2768,   "Cluckin bell burger",               125);
            MenuStore_AddItem(playerid, 9,  2814,   "Pizza",                             200, "", 0, true,1, 90.0,180.0, 0.0,1.0);
            MenuStore_Show(playerid, Menu_Restaurant, "Restaurant");
        }
        case BUSINESS_BARCLUB:
        {
            MenuStore_AddItem(playerid, 1,  19570,  "Water",     50);
            MenuStore_AddItem(playerid, 2,  2601,   "Sprunk",    80);
            MenuStore_AddItem(playerid, 3,  1544,   "Beer",     100);
            MenuStore_AddItem(playerid, 4,  1520,   "Wine",     500);
            MenuStore_AddItem(playerid, 5,  1512,   "Whiskey", 1000);
            MenuStore_Show(playerid, Menu_Bar, "Bar");
        }
        case BUSINESS_TOOLSHOP:
        {
            MenuStore_AddItem(playerid, 1,  11736,  "First aid kit",     500, "", 0, true,1, 90.0, 0.0, 0.0,1.0);
            MenuStore_AddItem(playerid, 2,  19921,  "Body repair kit",  1000, "", 0, true,1, 45.0,45.0, 0.0,1.5);
            MenuStore_AddItem(playerid, 3,  3031,   "Police scanner",   5000);
            MenuStore_AddItem(playerid, 4,  18977,  "Helmet",            500, "", 0, true,1, 0.0,0.0, 90.0,1.0);
            MenuStore_AddItem(playerid, 5,  18634,  "Crowbar",          5000, "", 0, true,1, 0.0,0.0, 90.0,1.0);
            MenuStore_AddItem(playerid, 6,  1615,   "House Alarm",     50000, "", 0, true,1, 0.0,0.0, 270.0,1.0);

            //MenuStore_AddItem(playerid, 7,    1512,   "Vehicle command",  5000);
            MenuStore_Show(playerid, Menu_ToolShop, "Tool Shop","Mat ");
        }

    }

    return 1;
}


CMD:entryfee(playerid, params[])
{
    new businessid = GetNearbyBusinessEx(playerid), amount;

    if (businessid == -1 || !IsBusinessOwner(playerid, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any business of yours.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /entryfee [amount]");
    }
    if (amount < 0 || amount > 300)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The entry fee can't be below $0 or above $300.");
    }

    BusinessInfo[businessid][bEntryFee] = amount;

    DBQuery("UPDATE businesses SET entryfee = %i WHERE id = %i", BusinessInfo[businessid][bEntryFee], BusinessInfo[businessid][bID]);


    ReloadBusiness(businessid);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have set the entry fee to $%i.", amount);
    return 1;
}


Dialog:DIALOG_FOOD(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem == 0) //Sprunk
        {
            GivePlayerCash(playerid, -50);
            GivePlayerHealth(playerid, 25.0);
            ShowActionBubble(playerid, "* %s pays $50 to the vendor and receives a can of sprunk.", GetRPName(playerid));
        }
        else if (listitem == 1) //Burger
        {
            GivePlayerCash(playerid, -15);
            GivePlayerHealth(playerid, 10.0);
            ShowActionBubble(playerid, "* %s pays $15 to the vendor and receives a piece of burger.", GetRPName(playerid));
        }
        else if (listitem == 2) //Cigar
        {
            GivePlayerCash(playerid, -35);
            PlayerData[playerid][pCigars]++;
            ShowActionBubble(playerid, "* %s pays $35 to the vendor and receives a piece of cigar.", GetRPName(playerid));
        }
        else if (listitem == 3) //Hot dog
        {
            GivePlayerCash(playerid, -25);
            GivePlayerHealth(playerid, 17.0);
            ShowActionBubble(playerid, "* %s pays $25 to the vendor and receives a piece of hot dog.", GetRPName(playerid));
        }
        else if (listitem == 4) //Rope
        {
            GivePlayerCash(playerid, -20);
            PlayerData[playerid][pRope] += 2;
            ShowActionBubble(playerid, "* %s pays $20 to the vendor and receives 2 ropes.", GetRPName(playerid));
        }
        else if (listitem == 5) //Chocolate
        {
            GivePlayerCash(playerid, -15);
            GivePlayerHealth(playerid, 12.0);
            ShowActionBubble(playerid, "* %s pays $15 to the vendor and receives a bar of chocolate.", GetRPName(playerid));
        }
    }
    return 1;
}
