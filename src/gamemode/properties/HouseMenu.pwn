
#define MAX_RENT_PRICE 1000

static MinHouseLevelToUseStorage = 2;
static TargetGiveKeys[MAX_PLAYERS];
static RoleGiveKeys[MAX_PLAYERS];
static UsernameTakeKeys[MAX_PLAYERS][MAX_PLAYER_NAME];

CMD:house(playerid, params[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside any house of yours.");
    }

    if (GetPlayerPropertyKey(playerid, PropertyType_House, houseid) == KeyRole_Unauthorized)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have permission in this house.");
    }
    new doorState[25];
    if (HouseInfo[houseid][hLocked])
        doorState = "{FF0000}LOCKED{FFFFFF}";
    else
        doorState = "{00FF00}OPEN{FFFFFF}";

    new lightState[20];
    if (HouseInfo[houseid][hLights])
        lightState = "{00FF00}ON{FFFFFF}";
    else
        lightState = "{FF0000}OFF{FFFFFF}";

    if (PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        Dialog_Show(playerid, HouseMenu, DIALOG_STYLE_LIST, "House menu",
                    "Storage\nBuild\nLights - %s\nDoors - %s\nAccess\nSell House",
                    "Select", "Cancel", lightState, doorState);
    }
    else
    {
        Dialog_Show(playerid, HouseMenu, DIALOG_STYLE_LIST, "House menu",
                    "Storage\nBuild\nLights - %s\nDoors - %s",
                    "Select", "Cancel", lightState, doorState);
    }
    return 1;
}

Dialog:HouseMenu(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0: // Storage
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage) &&
                    !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to this house storage.");
                }
                if (HouseInfo[houseid][hLevel] < MinHouseLevelToUseStorage)
                {
                    return SendClientMessageEx(playerid, COLOR_GREEN, "You have to upgrade your house level to %i to unlocked the storage.", MinHouseLevelToUseStorage);
                }
                ShowHouseStorageMenu(playerid, houseid);
            }
            case 1: // Build
            {
                DBFormat("SELECT COUNT(*) FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);
                DBExecute("HouseBuildMenu", "ii", playerid, houseid);
            }
            case 2: // Lights
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Doors))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have open lights in this house.");
                }

                HouseInfo[houseid][hLights] = HouseInfo[houseid][hLights] ? 0 : 1;
                DBQuery("UPDATE houses SET lights = %i WHERE id = %i", HouseInfo[houseid][hLights], HouseInfo[houseid][hID]);

                foreach(new i : Player)
                {
                    if (GetInsideHouse(i) == houseid)
                    {
                        if (HouseInfo[houseid][hLights] == 1)
                        {
                            TextDrawHideForPlayer(i, houseLights);
                        }
                        else
                        {
                            TextDrawShowForPlayer(i, houseLights);
                        }
                    }
                }
            }
            case 3: // Doors
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Doors))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have open doors in this house.");
                }

                HouseInfo[houseid][hLocked] = HouseInfo[houseid][hLocked] ? 0 : 1;
                DBQuery("UPDATE houses SET locked = %i WHERE id = %i", HouseInfo[houseid][hLocked], HouseInfo[houseid][hID]);

                if (HouseInfo[houseid][hLocked])
                {
                    GameTextForPlayer(playerid, "~r~House locked", 3000, 6);
                    ShowActionBubble(playerid, "* %s locks their house door.", GetRPName(playerid));
                }
                else
                {
                    GameTextForPlayer(playerid, "~g~House unlocked", 3000, 6);
                    ShowActionBubble(playerid, "* %s unlocks their house door.", GetRPName(playerid));
                }
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
            }
            case 4: // Access
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to manage access this house.");
                }

                Dialog_Show(playerid, HouseAccessMenu, DIALOG_STYLE_LIST, "House menu",
                    "Keys\nTenants\nInvite player", "Select", "Cancel");
            }
            case 5: // Sell House
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to sell this house.");
                }

                Dialog_Show(playerid, HouseSell, DIALOG_STYLE_MSGBOX, "House menu",
                    "To who you want to sell your house?\n"\
                    "The state can give you %s for this house.",
                    "To player", "To state",
                    FormatCash(percent(HouseInfo[houseid][hPrice], 75)));
            }
        }
    }
    return 1;
}

Dialog:HouseSell(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        Dialog_Show(playerid, HouseSellSelectPlayer, DIALOG_STYLE_INPUT, "House::Keys", "Enter the player id or part of player name to sell him your house.", "Next", "Cancel");
    }
    else
    {
        new houseid = GetInsideHouse(playerid);
        if (houseid == INVALID_HOUSE_ID)
            return 1;

        Dialog_Show(playerid, HouseSellToState, DIALOG_STYLE_MSGBOX, "House menu",
            "Are you sure to sell your house to the {00FF00}State{FFFFFF} for {00FF00}%s{FFFFFF}?",
            "Sell", "Cancel",
            FormatCash(percent(HouseInfo[houseid][hPrice], 75)));
    }
    return 1;
}

Dialog:HouseSellSelectPlayer(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new targetid;
    if (sscanf(inputtext, "u", targetid) || !IsPlayerConnected(targetid) || targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid player id");
    }
    TargetGiveKeys[playerid] = targetid;

    Dialog_Show(playerid, HouseSellToPlayer, DIALOG_STYLE_INPUT, "House::Keys",
                "Enter the sell house price:", "Offer to player", "Cancel");
    return 1;
}

Dialog:HouseSellToPlayer(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new price = strval(inputtext);
    if (price < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must specify a price above zero.");
    }

    new targetid = TargetGiveKeys[playerid];
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Player is not online.");
    }

    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
        return 1;

    if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to sell this house.");
    }

    PlayerData[targetid][pHouseOffer] = playerid;
    PlayerData[targetid][pHouseOffered] = houseid;
    PlayerData[targetid][pHousePrice] = price;
    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered you their house for %s (/accept house).", GetRPName(playerid), FormatCash(price));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s to buy your house for %s.", GetRPName(targetid), FormatCash(price));
    return 1;
}

Dialog:HouseSellToState(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
        return 1;

    if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to sell this house.");
    }

    SetHouseOwner(houseid, INVALID_PLAYER_ID);
    GivePlayerCash(playerid, percent(HouseInfo[houseid][hPrice], 75));

    SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your house to the state and received %s back.", FormatCash(percent(HouseInfo[houseid][hPrice], 75)));
    DBLog("log_property", "%s (uid: %i) sold their house (id: %i) to the state for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hID], percent(HouseInfo[houseid][hPrice], 75));
    return 1;
}

DB:HouseBuildMenu(playerid, houseid)
{
    new alarmAction[24];
    if (HouseInfo[houseid][hAlarm])
        alarmAction = "{FF0000}Remove{FFFFFF}";
    else
        alarmAction = "{00FF00}Install{FFFFFF}";

    new labelState[26];
    if (HouseInfo[houseid][hLabels])
        labelState = "{00FF00}Visible{FFFFFF}";
    else
        labelState = "{FF0000}Invisible{FFFFFF}";

    Dialog_Show(playerid, HouseBuildMenu, DIALOG_STYLE_LIST, "House menu",
                "Buy furniture\nEdit furniture (%i/%i)\nLabels - %s\n"\
                "Sell all objects\nUpgrade house level (%i/6)\nUpgrade house interior\n%s house alarm",
                "Select", "Cancel",
                GetDBIntFieldFromIndex(0, 0),
                GetHouseFurnitureCapacity(HouseInfo[houseid][hLevel]),
                labelState, HouseInfo[houseid][hLevel], alarmAction);
}

Dialog:HouseBuildMenu(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);

    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0: // Buy furniture
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to edit furnitures in this house.");
                }
                DBFormat("SELECT COUNT(*) FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);
                DBExecute("CountHouseFurnitures", "i", playerid);
            }
            case 1: // Edit furniture
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to edit furnitures in this house.");
                }
                Dialog_Show(playerid, EditHouseObjectId, DIALOG_STYLE_INPUT, "Edit furniture", "Please enter the object ID of the object to edit:\nYou can find out the ID of objects by toggling labels in the menu.", "Submit", "Back");
            }
            case 2: // Toggle labels
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to edit furnitures in this house.");
                }

                SetHouseEditMode(houseid, HouseInfo[houseid][hLabels] ? 0 : 1);

                if (HouseInfo[houseid][hLabels])
                {
                    SendClientMessage(playerid, COLOR_AQUA, "You will now see labels appear above the furnitures in your house.");
                }
                else
                {
                    SendClientMessage(playerid, COLOR_AQUA, "You will no longer see any labels appear above your house furnitures.");
                }
            }
            case 3: // Sell all objects
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to sell all the furnitures in this house.");
                }

                Dialog_Show(playerid, ClearFurniture, DIALOG_STYLE_MSGBOX, "Clear furnitures",
                            "This option sells all the furnitures in your house. You will receive\n"\
                            "75 percent of the total cost of all your objects.\n\n"\
                            "Press {FF6347}Confirm{A9C4E4} to proceed with the operation.",
                            "Confirm", "Back");
            }
            case 4: // Upgrade house level
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to upgrade this house.");
                }

                new houseLevel = HouseInfo[houseid][hLevel];
                if (HouseInfo[houseid][hLevel] >= 6)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your house can't be upgraded any further.");
                }
                new string[255];
                format(string, sizeof(string), "You are about to upgrade your house to level %i/6.\n\n"\
                                               "This upgrade will cost you {00AA00}$100,000{A9C4E4} and"\
                                               " unlocks %i more\nobject slots for your house.\n\n"\
                                               "Are you sure you want to upgrade your house?",
                       houseLevel + 1, GetHouseFurnitureCapacity(houseLevel + 1) - GetHouseFurnitureCapacity(houseLevel));
                Dialog_Show(playerid, UpgradeHouseLevel, DIALOG_STYLE_MSGBOX, "Upgrade house", string, "Yes", "No");
            }
            case 5: // Upgrade house interior
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to upgrade this house.");
                }

                static interiors[sizeof(houseInteriors) * 64];
                if (isnull(interiors))
                {
                    interiors = "#\tClass\tPrice";

                    for (new i = 0; i < sizeof(houseInteriors); i ++)
                    {
                        format(interiors, sizeof(interiors), "%s\n%i\t%s\t{00AA00}$%i{FFFFFF}", interiors, i + 1, houseInteriors[i][intClass], houseInteriors[i][intPrice]);
                    }
                }
                Dialog_Show(playerid, HouseInteriors, DIALOG_STYLE_TABLIST_HEADERS, "Choose an interior to preview.", interiors, "Preview", "Cancel");
            }
            case 6: // House alarm
            {
                if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have access to upgrade this house.");
                }

                if (HouseInfo[houseid][hAlarm])
                {
                    HouseInfo[houseid][hAlarm] = 0;
                    PlayerData[playerid][pHouseAlarm] += 1;
                    DBQuery("UPDATE houses SET alarm = %i WHERE id = %i", HouseInfo[houseid][hAlarm], HouseInfo[houseid][hID]);
                    DBQuery("UPDATE "#TABLE_USERS" SET housealarm = %i WHERE uid = %i", PlayerData[playerid][pHouseAlarm], PlayerData[playerid][pID]);
                    SendClientMessage(playerid, COLOR_YELLOW, "You've sucessfully uninstalled your house alarm, now it's not anymore protected by the Police.");
                }
                else
                {
                    if (PlayerData[playerid][pHouseAlarm] == 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have a house alarm, you can buy one from a tool shop");
                    }
                    PlayerData[playerid][pHouseAlarm] -= 1;
                    HouseInfo[houseid][hAlarm] = 1;
                    SendClientMessage(playerid, COLOR_YELLOW, "You've sucessfully installed your house alarm, now it's legal protected by the Police.");
                    DBQuery("UPDATE houses SET alarm = %i WHERE id = %i", HouseInfo[houseid][hAlarm], HouseInfo[houseid][hID]);
                    DBQuery("UPDATE "#TABLE_USERS" SET housealarm = %i WHERE uid = %i", PlayerData[playerid][pHouseAlarm], PlayerData[playerid][pID]);
                }
            }
        }
    }
    return 1;
}

Dialog:HouseAccessMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
        return 1;

    if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to give the keys of this house.");
    }

    switch (listitem)
    {
        case 0: // Keys
        {
            DBFormat("SELECT (select username from "#TABLE_USERS" where uid=userid) as username, accessType, expiry"\
                        " from keyring"\
                        " where ownerid=%i and propertyid=%i and propertyType=%i;",
                        PlayerData[playerid][pID], HouseInfo[houseid][hID], _:PropertyType_House);
            DBExecute("ShowHouseKeysMenu", "ii", playerid, houseid);
        }
        case 1: // Tenants
        {
            DBFormat("SELECT username, lastlogin FROM "#TABLE_USERS" WHERE rentinghouse = %i ORDER BY lastlogin DESC", HouseInfo[houseid][hID]);
            DBExecute("HouseTenantsMenu", "ii", playerid, houseid);
        }
        case 2: // Invite player
        {
            Dialog_Show(playerid, HouseInvite, DIALOG_STYLE_INPUT, "House::Keys", "Enter the player id or part of player name to invite him to your house.", "Invite", "Cancel");
        }
    }
    return 1;
}

DB:HouseTenantsMenu(playerid, houseid)
{
    new rows = GetDBNumRows();
    new content[512];
    if (HouseInfo[houseid][hRentPrice] == 0)
    {
        content = "Rent\t{FF0000}Disabled{FFFFFF}";
    }
    else
    {
        format(content, sizeof(content), "Rent\t%s", FormatCash(HouseInfo[houseid][hRentPrice]));
    }

    if (rows > 0)
    {
        new username[MAX_PLAYER_NAME], date[24];
        format(content, sizeof(content), "%s\nEvict all\t ", content);
        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "username", username);
            GetDBStringField(i, "lastlogin", date);
            format(content, sizeof(content), "%s\n%s\tLast seen: %s", content, username, date);
        }
    }
    Dialog_Show(playerid, HouseTenantsMenu, DIALOG_STYLE_LIST, "House menu", content, "Select", "Cancel");
    return 1;
}

Dialog:HouseTenantsMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    switch (listitem)
    {
        case 0: // Set rent
        {
            Dialog_Show(playerid, HouseSetRent, DIALOG_STYLE_INPUT, "House::Keys",
                        "Enter the rent value for this house.\n"\
                        "The price must range between $0 and %s ('0' to disable).",
                        "Set rent", "Cancel", FormatCash(MAX_RENT_PRICE));
        }
        case 1: // Evict all
        {
            new houseid = GetInsideHouse(playerid);
            if (houseid == INVALID_HOUSE_ID)
                return 1;

            if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have access to give the keys of this house.");
            }

            foreach(new i : Player)
            {
                if (PlayerData[i][pLogged] && PlayerData[i][pRentingHouse] == HouseInfo[houseid][hID])
                {
                    PlayerData[i][pRentingHouse] = 0;
                    SendClientMessage(i, COLOR_RED, "You have been evicted from your home by the owner.");
                }
            }
            DBQuery("UPDATE "#TABLE_USERS" SET rentinghouse = 0 WHERE rentinghouse = %i", HouseInfo[houseid][hID]);
            SendClientMessage(playerid, COLOR_WHITE, "You have evicted all tenants from your home.");
        }
        default: // Evict Player
        {
            UsernameTakeKeys[playerid][0] = 0;
            strcat(UsernameTakeKeys[playerid], inputtext);
            Dialog_Show(playerid, HouseEvict, DIALOG_STYLE_MSGBOX, "House::Keys",
                        "Did you want to evict {00FF00}%s{000000} from your house.",
                        "Evict", "Cancel",
                        inputtext);
        }
    }
    return 1;
}

Dialog:HouseEvict(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
        return 1;

    if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to give the keys of this house.");
    }

    foreach(new i : Player)
    {
        if (!strcmp(GetPlayerNameEx(i), UsernameTakeKeys[playerid]) && PlayerData[i][pLogged])
        {
            PlayerData[i][pRentingHouse] = 0;
            SendClientMessage(i, COLOR_RED, "You have been evicted from your home by the owner.");
        }
    }
    DBQuery("UPDATE "#TABLE_USERS" SET rentinghouse = 0 WHERE username = '%e'", UsernameTakeKeys[playerid]);
    SendClientMessageEx(playerid, COLOR_WHITE, "You have evicted %s from your property.", UsernameTakeKeys[playerid]);
    return 1;
}

Dialog:HouseSetRent(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new price = strval(inputtext);
    if (MAX_RENT_PRICE < price < 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid price. The price must range between $0 and %s.", FormatCash(MAX_RENT_PRICE));
    }

    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
        return 1;

    if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to change the rent of this house.");
    }

    HouseInfo[houseid][hRentPrice] = price;
    DBQuery("UPDATE houses SET rentprice = %i WHERE id = %i", price, HouseInfo[houseid][hID]);
    ReloadHouse(houseid);

    if (price == 0)
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've have {FF0000}disabled{FFFFFF} the rent for this house.");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've set the rental price to %s.", FormatCash(price));
    }
    return 1;
}

Dialog:HouseInvite(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new targetid;
        if (sscanf(inputtext, "u", targetid) || !IsPlayerConnected(targetid) || targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid player id");
        }
        new houseid = GetInsideHouse(playerid);
        if (houseid == INVALID_HOUSE_ID)
            return 1;

        if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have access to invite someone to this house.");
        }

        PlayerData[targetid][pInviteOffer] = playerid;
        PlayerData[targetid][pInviteHouse] = houseid;
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s has offered you an invitation to their house in %s. (/accept invite)",
                            GetRPName(playerid), GetZoneName(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]));
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered %s an invitation to your house.", GetRPName(targetid));
    }
    return 1;
}

// Begin Section: House Storage

ShowHouseStorageMenu(playerid, houseid)
{
    new content[256];
    new weapons;
    for (new i = 0; i < MAX_HOUSE_WEAPONS_SLOTS; i ++)
    {
        if (HouseInfo[houseid][hWeapons][i])
        {
            weapons++;
        }
    }

    format(content, sizeof(content),
                "Cash\t%s/%s\n"\
                "Materials\t%s/%s\n"\
                "Weapons\t%i/%i\n"\
                "Weed\t%s/%s grams\n"\
                "Cocaine\t%s/%s grams\n"\
                "Heroin\t%s/%s grams\n"\
                "Painkillers\t%i/%i pills",
                FormatCash(HouseInfo[houseid][hCash]), FormatCash(GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH)),
                FormatNumber(HouseInfo[houseid][hMaterials]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS)),
                weapons, GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS),
                FormatNumber(HouseInfo[houseid][hWeed]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED)),
                FormatNumber(HouseInfo[houseid][hCocaine]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE)),
                FormatNumber(HouseInfo[houseid][hHeroin]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN)),
                HouseInfo[houseid][hPainkillers], GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS));
    Dialog_Show(playerid, HouseStorageMenu, DIALOG_STYLE_TABLIST, "House::Storage", content, "Select", "Cancel");
}

Dialog:HouseStorageMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }

    new houseid = GetInsideHouse(playerid);

    switch (listitem)
    {
        case 0: // Cash
        {
            new content[128];
            format(content, sizeof(content), "You have %s/%s in your house storage.",
                   FormatCash(HouseInfo[houseid][hCash]), FormatCash(GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH)));
            Dialog_Show(playerid, HouseCashOperation, DIALOG_STYLE_MSGBOX, "House::Storage", content, "Deposit", "Withdraw");
        }
        case 1: // Materials
        {
            new content[128];
            format(content, sizeof(content), "You have %s/%s materials in your house storage.",
                   FormatNumber(HouseInfo[houseid][hMaterials]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS)));
            Dialog_Show(playerid, HouseMatsOperation, DIALOG_STYLE_MSGBOX, "House::Storage", content, "Deposit", "Withdraw");
        }
        case 2: // Weapons
        {
            new content[128];
            content = "{00FF00}Store my weapon{FFFFFF}";
            for (new i = 0; i < 10; i ++)
            {
                if (HouseInfo[houseid][hWeapons][i])
                {
                    format(content, sizeof(content), "%s\n%s", content, GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]));
                }
            }
            Dialog_Show(playerid, HouseWeaponOperation, DIALOG_STYLE_LIST, "House::Storage", content, "Select", "Cancel");
        }
        case 3: // Weed
        {
            new content[128];
            format(content, sizeof(content), "You have %sg/%sg of weed in your house storage.",
                   FormatNumber(HouseInfo[houseid][hWeed]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED)));
            Dialog_Show(playerid, HouseWeedOperation, DIALOG_STYLE_MSGBOX, "House::Storage", content, "Deposit", "Withdraw");
        }
        case 4: // Cocaine
        {
            new content[128];
            format(content, sizeof(content), "You have %sg/%sg of cocaine in your house storage.",
                   FormatNumber(HouseInfo[houseid][hCocaine]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE)));
            Dialog_Show(playerid, HouseCocaineOperation, DIALOG_STYLE_MSGBOX, "House::Storage", content, "Deposit", "Withdraw");
        }
        case 5: // Heroin
        {
            new content[128];
            format(content, sizeof(content), "You have %sg/%sg of heroin in your house storage.",
                   FormatNumber(HouseInfo[houseid][hHeroin]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN)));
            Dialog_Show(playerid, HouseHeroinOperation, DIALOG_STYLE_MSGBOX, "House::Storage", content, "Deposit", "Withdraw");
        }
        case 6: // Painkillers
        {
            new content[128];
            format(content, sizeof(content), "You have %s/%s painkillers in your house storage.",
                   FormatNumber(HouseInfo[houseid][hPainkillers]), FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS)));
            Dialog_Show(playerid, HousePainKillerOperation, DIALOG_STYLE_MSGBOX, "House::Storage", content, "Deposit", "Withdraw");
        }
    }

    return 1;
}

Dialog:HouseCashOperation(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of cash that you want to deposit (Max: %s).",
               FormatCash(GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH) - HouseInfo[houseid][hCash]));
        Dialog_Show(playerid, HouseCashDeposit, DIALOG_STYLE_INPUT, "House::Storage", content, "Deposit", "Cancel");
    }
    else
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of cash that you want to withdraw (Max: %s).",
               FormatCash(HouseInfo[houseid][hCash]));
        Dialog_Show(playerid, HouseCashWithdraw, DIALOG_STYLE_INPUT, "House::Storage", content, "Withdraw", "Cancel");
    }
    return 1;
}

Dialog:HouseCashDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hCash] + value > GetHouseStashCapacity(houseid, STASH_CAPACITY_CASH))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    if (PlayerData[playerid][pCash] < value)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that amount of cash.");
    }
    GivePlayerCash(playerid, -value);
    HouseInfo[houseid][hCash] += value;
    DBQuery("UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %s in your house stash.", FormatCash(value));
    return 1;
}

Dialog:HouseCashWithdraw(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hCash] - value < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    GivePlayerCash(playerid, value);
    HouseInfo[houseid][hCash] -= value;
    DBQuery("UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %s from your house stash.", FormatCash(value));
    return 1;
}

Dialog:HouseMatsOperation(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of materials that you want to deposit (Max: %s).",
               FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS) - HouseInfo[houseid][hMaterials]));
        Dialog_Show(playerid, HouseMatsDeposit, DIALOG_STYLE_INPUT, "House::Storage", content, "Deposit", "Cancel");
    }
    else
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of materials that you want to withdraw (Max: %s).",
               FormatNumber(HouseInfo[houseid][hMaterials]));
        Dialog_Show(playerid, HouseMatsWithdraw, DIALOG_STYLE_INPUT, "House::Storage", content, "Withdraw", "Cancel");
    }
    return 1;
}

Dialog:HouseMatsDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hMaterials] + value > GetHouseStashCapacity(houseid, STASH_CAPACITY_MATERIALS))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }

    if (PlayerData[playerid][pMaterials] < value)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that amount of materials.");
    }

    GivePlayerMaterials(playerid, -value);
    HouseInfo[houseid][hMaterials] += value;
    DBQuery("UPDATE houses SET materials = %i WHERE id = %i", HouseInfo[houseid][hMaterials], HouseInfo[houseid][hID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %s materials in your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseMatsWithdraw(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hMaterials] - value < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    if (PlayerData[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
    }
    GivePlayerMaterials(playerid, value);
    HouseInfo[houseid][hMaterials] -= value;
    DBQuery("UPDATE houses SET materials = %i WHERE id = %i", HouseInfo[houseid][hMaterials], HouseInfo[houseid][hID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %s materials from your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseWeaponOperation(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }
    if (listitem == 0)
    {

        // Store
        if (IsLawEnforcement(playerid) || GetPlayerFaction(playerid) == FACTION_HITMAN)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Faction weapons cannot be stored.");
        }
        if (GetPlayerHealthEx(playerid) < 60)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't store weapons as your health is below 60.");
        }
        if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
        }

        new weaponid = GetPlayerWeapon(playerid);
        if (!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have a weapon in your hand.");
        }

        for (new i = 0; i < GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS); i ++)
        {
            if (!HouseInfo[houseid][hWeapons][i])
            {
                HouseInfo[houseid][hWeapons][i] = weaponid;
                DBQuery("UPDATE houses SET weapon_%i = %i WHERE id = %i", i + 1, HouseInfo[houseid][hWeapons][i], HouseInfo[houseid][hID]);
                RemovePlayerWeapon(playerid, weaponid);
                return SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored a %s in slot %i of your house storage.", GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]), i + 1);
            }
        }
        SendClientMessage(playerid, COLOR_GREY, "Your house storage has no more slots available for weapons.");
    }
    else
    {
        if (PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
        }
        if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
        }

        for (new i = 0; i < GetHouseStashCapacity(houseid, STASH_CAPACITY_WEAPONS); i ++)
        {
            new weaponName[24];
            weaponName = GetWeaponNameEx(HouseInfo[houseid][hWeapons][i]);
            if (HouseInfo[houseid][hWeapons][i] && !strcmp(inputtext, weaponName))
            {
                GivePlayerWeaponEx(playerid, HouseInfo[houseid][hWeapons][i]);
                HouseInfo[houseid][hWeapons][i] = 0;
                DBQuery("UPDATE houses SET weapon_%i = 0 WHERE id = %i", i + 1, HouseInfo[houseid][hID]);
                return SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken a %s from your house storage.", weaponName);
            }
        }
        SendClientMessage(playerid, COLOR_AQUA, "* Cannot find that weapon in your house storage.");
    }
    return 1;
}

Dialog:HouseWeedOperation(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of weed that you want to deposit (Max: %s).",
               FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED) - HouseInfo[houseid][hWeed]));
        Dialog_Show(playerid, HouseWeedDeposit, DIALOG_STYLE_INPUT, "House::Storage", content, "Deposit", "Cancel");
    }
    else
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of weed that you want to withdraw (Max: %s).",
               FormatNumber(HouseInfo[houseid][hWeed]));
        Dialog_Show(playerid, HouseWeedWithdraw, DIALOG_STYLE_INPUT, "House::Storage", content, "Withdraw", "Cancel");
    }
    return 1;
}

Dialog:HouseWeedDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hWeed] + value > GetHouseStashCapacity(houseid, STASH_CAPACITY_WEED))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    if (PlayerData[playerid][pWeed] < value)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that amount of weed.");
    }

    PlayerData[playerid][pWeed] -= value;
    HouseInfo[houseid][hWeed] += value;
    DBQuery("UPDATE houses SET weed = %i WHERE id = %i", HouseInfo[houseid][hWeed], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %sg of weed in your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseWeedWithdraw(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hWeed] - value < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }

    if (PlayerData[playerid][pWeed] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %ig/%ig weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
    }

    PlayerData[playerid][pWeed] += value;
    HouseInfo[houseid][hWeed] -= value;
    DBQuery("UPDATE houses SET weed = %i WHERE id = %i", HouseInfo[houseid][hWeed], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %sg of weed from your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseCocaineOperation(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of cocaine that you want to deposit (Max: %s).",
               FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE) - HouseInfo[houseid][hCocaine]));
        Dialog_Show(playerid, HouseCocaineDeposit, DIALOG_STYLE_INPUT, "House::Storage", content, "Deposit", "Cancel");
    }
    else
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of cocaine that you want to withdraw (Max: %s).",
               FormatNumber(HouseInfo[houseid][hCocaine]));
        Dialog_Show(playerid, HouseCocaineWithdraw, DIALOG_STYLE_INPUT, "House::Storage", content, "Withdraw", "Cancel");
    }
    return 1;
}

Dialog:HouseCocaineDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hCocaine] + value > GetHouseStashCapacity(houseid, STASH_CAPACITY_COCAINE))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    if (PlayerData[playerid][pCocaine] < value)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that amount of cocaine.");
    }
    PlayerData[playerid][pCocaine] -= value;
    HouseInfo[houseid][hCocaine] += value;
    DBQuery("UPDATE houses SET cocaine = %i WHERE id = %i", HouseInfo[houseid][hCocaine], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %sg of cocaine in your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseCocaineWithdraw(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hCocaine] - value < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }

    if (PlayerData[playerid][pCocaine] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %ig/%ig cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
    }

    PlayerData[playerid][pCocaine] += value;
    HouseInfo[houseid][hCocaine] -= value;
    DBQuery("UPDATE houses SET cocaine = %i WHERE id = %i", HouseInfo[houseid][hCocaine], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %sg of cocaine from your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseHeroinOperation(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of heroin that you want to deposit (Max: %s).",
               FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN) - HouseInfo[houseid][hHeroin]));
        Dialog_Show(playerid, HouseHeroinDeposit, DIALOG_STYLE_INPUT, "House::Storage", content, "Deposit", "Cancel");
    }
    else
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of heroin that you want to withdraw (Max: %s).",
               FormatNumber(HouseInfo[houseid][hHeroin]));
        Dialog_Show(playerid, HouseHeroinWithdraw, DIALOG_STYLE_INPUT, "House::Storage", content, "Withdraw", "Cancel");
    }
    return 1;
}

Dialog:HouseHeroinDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hHeroin] + value > GetHouseStashCapacity(houseid, STASH_CAPACITY_HEROIN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    if (PlayerData[playerid][pHeroin] < value)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that amount of heroin.");
    }
    PlayerData[playerid][pHeroin] -= value;
    HouseInfo[houseid][hHeroin] += value;
    DBQuery("UPDATE houses SET heroin = %i WHERE id = %i", HouseInfo[houseid][hHeroin], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %sg of heroin in your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HouseHeroinWithdraw(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hHeroin] - value < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }

    if (PlayerData[playerid][pHeroin] + value > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %ig/%ig heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
    }

    PlayerData[playerid][pHeroin] += value;
    HouseInfo[houseid][hHeroin] -= value;
    DBQuery("UPDATE houses SET heroin = %i WHERE id = %i", HouseInfo[houseid][hHeroin], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %sg of heroin from your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HousePainKillerOperation(playerid, response, listitem, inputtext[])
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID)
    {
        return 1;
    }

    if (response)
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of painkiller that you want to deposit (Max: %s).",
               FormatNumber(GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS) - HouseInfo[houseid][hPainkillers]));
        Dialog_Show(playerid, HousePainKillerDeposit, DIALOG_STYLE_INPUT, "House::Storage", content, "Deposit", "Cancel");
    }
    else
    {
        new content[128];
        format(content, sizeof(content), "Enter the amount of painkiller that you want to withdraw (Max: %s).",
               FormatNumber(HouseInfo[houseid][hPainkillers]));
        Dialog_Show(playerid, HousePainKillerWithdraw, DIALOG_STYLE_INPUT, "House::Storage", content, "Withdraw", "Cancel");
    }
    return 1;
}

Dialog:HousePainKillerDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_PutInStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to store items in this house.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hPainkillers] + value > GetHouseStashCapacity(houseid, STASH_CAPACITY_PAINKILLERS))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    if (PlayerData[playerid][pPainkillers] < value)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that amount of painkillers.");
    }
    PlayerData[playerid][pPainkillers] -= value;
    HouseInfo[houseid][hPainkillers] += value;
    DBQuery("UPDATE houses SET painkillers = %i WHERE id = %i", HouseInfo[houseid][hPainkillers], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have stored %s painkillers in your house stash.", FormatNumber(value));
    return 1;
}

Dialog:HousePainKillerWithdraw(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_TakeFromStorage))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to withdraw items from this house storage.");
    }

    new value = strval(inputtext);
    if (value <= 0 || HouseInfo[houseid][hPainkillers] - value < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }

    if (PlayerData[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
    }

    PlayerData[playerid][pPainkillers] += value;
    HouseInfo[houseid][hPainkillers] -= value;
    DBQuery("UPDATE houses SET painkillers = %i WHERE id = %i", HouseInfo[houseid][hPainkillers], HouseInfo[houseid][hID]);
    DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have taken %s painkillers from your house stash.", FormatNumber(value));
    return 1;
}
// End Section: House Storage

// Begin Section: Buy Furniture
DB:CountHouseFurnitures(playerid)
{
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to edit furnitures in this house.");
    }
    new capacity = GetHouseFurnitureCapacity(HouseInfo[houseid][hLevel]);
    if (GetDBIntFieldFromIndex(0, 0) >= capacity)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You are only allowed up to %i furnitures in this house.", capacity);
    }
    else
    {
        ShowFurnitureCategories(playerid);
    }
    return 1;
}
// End Section: Buy Furniture

// Begin Section: Edit Furniture
Dialog:EditHouseObjectId(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pEdit] == EDIT_TYPE_PREVIEW)
    {
        return SendErrorMessage(playerid, "You can't edit furniture while previewing.");
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to edit furnitures in this house.");
    }

    if (response)
    {
        new furnitureid = strval(inputtext);
        if (!IsValidFurnitureID(furnitureid))
        {
            return SendErrorMessage(playerid, "You have specified an invalid furniture ID.");
        }
        if (Furniture[furnitureid][fHouseId] != houseid)
        {
            return SendErrorMessage(playerid, "The specified ID belongs to another house.");
        }
        SetPVarInt(playerid, "FurnID", furnitureid);
        Dialog_Show(playerid, FurnEditConfirm, DIALOG_STYLE_LIST, "Furniture Edit", "Edit Position\nEdit Texture\nDuplicate Object\nDelete Object", "Select", "Cancel");
        SendInfoMessage(playerid, "You are now editing ID: %i. Click the disk icon to save changes.", furnitureid);
    }
    return 1;
}
// End Section: Edit Furniture

Dialog:ClearFurniture(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new houseid = GetInsideHouse(playerid);
        if (houseid != INVALID_HOUSE_ID)
        {
            DBFormat("SELECT * FROM rp_furniture WHERE fHouseID = %i", HouseInfo[houseid][hID]);
            DBExecute("ClearFurniture", "i", playerid);
        }
    }
    return 1;
}

DB:ClearFurniture(playerid)
{
    new rows = GetDBNumRows();
    if (!rows)
    {
        SendClientMessage(playerid, COLOR_RED, "[ERROR]{ffffff} Your home contains no furniture which can be sold.");
    }
    else
    {
        new price, houseid = GetInsideHouse(playerid);

        for (new i = 0; i < rows; i ++)
        {
            price += percent(GetDBIntField(i, "price"), 75);
        }

        RemoveAllFurniture(houseid);

        GivePlayerCash(playerid, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have sold a total of %i items and received $%i back.", rows, price);
    }
}

// Begin Section: House keys
DB:ShowHouseKeysMenu(playerid, houseid)
{
    new rows = GetDBNumRows();
    new content[256];
    new username[MAX_PLAYER_NAME];
    new role[32];

    content = "Username\tRole\tExpiry Date\n{00FF00}Give keys{FFFFFF}\t \t ";
    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "username", username);
        switch (GetDBIntField(i, "accessType"))
        {
            case KeyRole_Unauthorized: role = "Unauthorized";
            case KeyRole_Owner:        role = "Owner";
            case KeyRole_Editor:       role = "Editor";
            case KeyRole_Member:       role = "Member";
            case KeyRole_Tenant:       role = "Tenant";
            case KeyRole_Visitor:      role = "Visitor";
            default:                   role = "Unknown";
        }
        format(content, sizeof(content), "%s\n%s\t%s\t%s", content, username, role,
               TimestampToString(GetDBIntField(i, "expiry")));
    }
    Dialog_Show(playerid, HouseKeys, DIALOG_STYLE_TABLIST_HEADERS, "House::Keys", content, "Select", "Cancel");
}

Dialog:HouseKeys(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            Dialog_Show(playerid, HouseGivekeysPlayerInput, DIALOG_STYLE_INPUT, "House::Keys", "Enter the player id or part of player name to give them the keys.", "Next", "Cancel");
        }
        else
        {
            new content[128];
            UsernameTakeKeys[playerid][0] = 0;
            strcat(UsernameTakeKeys[playerid], inputtext);
            format(content, sizeof(content), "You are about to {FF0000}take{FFFFFF} the house keys from {FF0000}%s{FFFFFF}.", inputtext);
            Dialog_Show(playerid, HouseTakekeys, DIALOG_STYLE_MSGBOX, "House::Keys", content, "Take keys", "Cancel");
        }
    }
    return 1;
}

Dialog:HouseTakekeys(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new houseid = GetInsideHouse(playerid);
        if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have access to give keys in this house.");
        }
        if (OfflineRemovePropertyAccess(UsernameTakeKeys[playerid], PropertyType_House, HouseInfo[houseid][hID]))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You taked the house keys from '%s'.", UsernameTakeKeys[playerid]);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Failed to remove access for player '%s' to your house.", UsernameTakeKeys[playerid]);
        }
    }
    return 1;
}

Dialog:HouseGivekeysPlayerInput(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new targetid;
        if (sscanf(inputtext, "u", targetid) || !IsPlayerConnected(targetid) || targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid player id");
        }
        TargetGiveKeys[playerid] = targetid;
        Dialog_Show(playerid, HouseGivekeysRoleInput, DIALOG_STYLE_LIST, "House::Keys", "Visitor (Doors)\nMember (Doors, PutInStorage, TakeFromStorage)\nEditor (Doors, Edit, PutInStorage)", "Next", "Cancel");
    }
    return 1;
}

Dialog:HouseGivekeysRoleInput(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        RoleGiveKeys[playerid] = listitem;
        new button[40];
        format(button, sizeof(button), "Give keys to %s", GetPlayerNameEx(TargetGiveKeys[playerid]));
        Dialog_Show(playerid, HouseGivekeysDurationInput, DIALOG_STYLE_INPUT, "House::Keys",
                    "Enter the duration in days where %s can keep the %s keys:", "Give keys", "Cancel",
                    GetPlayerNameEx(TargetGiveKeys[playerid]), inputtext);
    }
    return 1;
}

Dialog:HouseGivekeysDurationInput(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;
    new days = strval(inputtext);
    if (days <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
    }
    new targetid = TargetGiveKeys[playerid];
    if (!IsPlayerConnected(targetid) || !IsPlayerLoggedIn(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player left the game.");
    }
    new houseid = GetInsideHouse(playerid);
    if (houseid == INVALID_HOUSE_ID || !PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Sell))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have access to give keys in this house.");
    }
    new accessType;
    switch (RoleGiveKeys[playerid])
    {
        case 0: accessType = KeyRole_Visitor;
        case 1: accessType = KeyRole_Member;
        case 2: accessType = KeyRole_Editor;
        default: return SendClientMessageEx(playerid, COLOR_GREY, "Unknown role index %i.", RoleGiveKeys[playerid]);
    }
    new expiry = gettime() + days * 24 * 3600;
    if (GetPlayerPropertyKey(targetid, PropertyType_House, houseid) > 0)
    {
        if (!UpdatePlayerPropertyAccess(targetid, PlayerData[playerid][pID], PropertyType_House, houseid, accessType, expiry))
        {
            return SendClientMessageEx(playerid, COLOR_AQUA, "Cannot give house keys to %s.", GetPlayerNameEx(targetid));
        }
    }
    else
    {
        if (!GivePlayerPropertyAccess(targetid, PlayerData[playerid][pID], PropertyType_House, houseid, accessType, expiry))
        {
            return SendClientMessageEx(playerid, COLOR_AQUA, "Cannot give house keys to %s.", GetPlayerNameEx(targetid));
        }
    }
    SendClientMessageEx(targetid, COLOR_AQUA, "You have received the keys of %s's house.", GetPlayerNameEx(playerid));
    return SendClientMessageEx(playerid, COLOR_AQUA, "You gived %s your house keys.", GetPlayerNameEx(targetid));
}

// End Section: House keys
Dialog:UpgradeHouseLevel(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new houseid = GetInsideHouse(playerid);
        if (houseid == INVALID_HOUSE_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not inside any house.");
        }

        if (!PlayerHasPropertyAccess(playerid, PropertyType_House, houseid, KeyAccess_Edit))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have permission to upgrade this house.");
        }

        new cost = (HouseInfo[houseid][hLevel] * 50000) + 50000;

        if (HouseInfo[houseid][hLevel] > 5)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Your house is already at the maximum level possible.");
        }
        if (PlayerData[playerid][pCash] < cost)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You need to have %s to upgrade your house level.", FormatCash(cost));
        }

        HouseInfo[houseid][hLevel]++;
        DBQuery("UPDATE houses SET level = level + 1 WHERE id = %i", HouseInfo[houseid][hID]);
        new string[32];
        format(string, sizeof(string), "~r~-$%i", cost);
        GameTextForPlayer(playerid, string, 5000, 1);
        GivePlayerCash(playerid, -cost);
        ReloadHouse(houseid);

        if (HouseInfo[houseid][hLevel] == MinHouseLevelToUseStorage)
        {
            SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your house to level %i/6. You unlocked your house storage!", HouseInfo[houseid][hLevel]);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your house to level %i/6. Your house storage capacity was increased.", HouseInfo[houseid][hLevel]);
        }

        SendClientMessageEx(playerid, COLOR_GREEN, "New tenant capacity: %i, New furniture capacity: %i.", GetHouseTenantCapacity(houseid), GetHouseFurnitureCapacity(houseid));
        DBLog("log_property", "%s (uid: %i) upgraded their house (id: %i) to level %i for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hID], HouseInfo[houseid][hLevel], cost);
    }
    return 1;
}

Dialog:FurnEditConfirm(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new furnitureid = GetPVarInt(playerid, "FurnID");

        switch (listitem)
        {
            case 0: EditDynamicObjectEx(playerid, EDIT_TYPE_FURNITURE, Furniture[furnitureid][fObject], furnitureid);
            case 1: ListTexture(playerid);
            case 2:
            {//duplicate
                //search model index in available object
                new index = -1;
                for (new i = 0; i < sizeof(g_FurnitureList); i ++)
                {
                    if (g_FurnitureList[i][e_ModelID] == Furniture[furnitureid][fModel])
                    {
                        index = i;
                        break;
                    }
                }
                if (index == -1)
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

CMD:confirmupgrade(playerid, params[])
{
    new houseid = PlayerData[playerid][pPreviewHouse], type = PlayerData[playerid][pPreviewType];
    if (houseid == INVALID_HOUSE_ID || !IsHouseOwner(playerid, houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't previewing a house interior at the moment.");
    }

    RCHECK(!houseInteriors[type][intForDonnation] || IsGodAdmin(playerid),
           "This interior is available only for donation.");

    if (PlayerData[playerid][pCash] < houseInteriors[type][intPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to upgrade to this interior.");
    }

    foreach(new i : Player)
    {
        if (GetInsideHouse(i) == houseid)
        {
            SetPlayerPos(i, houseInteriors[type][intX], houseInteriors[type][intY], houseInteriors[type][intZ]);
            SetPlayerFacingAngle(i, houseInteriors[type][intA]);
            SetPlayerInterior(i, houseInteriors[type][intID]);
            SetCameraBehindPlayer(i);
        }
    }

    GivePlayerCash(playerid, -houseInteriors[type][intPrice]);

    HouseInfo[houseid][hType] = type;
    HouseInfo[houseid][hPrice] = houseInteriors[type][intPrice];
    HouseInfo[houseid][hInterior] = houseInteriors[type][intID];
    HouseInfo[houseid][hIntX] = houseInteriors[type][intX];
    HouseInfo[houseid][hIntY] = houseInteriors[type][intY];
    HouseInfo[houseid][hIntZ] = houseInteriors[type][intZ];
    HouseInfo[houseid][hIntA] = houseInteriors[type][intA];

    PlayerData[playerid][pPreviewHouse] = INVALID_HOUSE_ID;
    PlayerData[playerid][pPreviewType] = 0;
    PlayerData[playerid][pPreviewTime] = 0;

    DBQuery("UPDATE houses SET type = %i, price = %i, int_x = '%f', int_y = '%f', int_z = '%f', int_a = '%f', interior = %i, world = %i WHERE id = %i", type, HouseInfo[houseid][hPrice], HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ], HouseInfo[houseid][hIntA], HouseInfo[houseid][hInterior], HouseInfo[houseid][hWorld], HouseInfo[houseid][hID]);


    SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your house to this interior for $%i.", houseInteriors[type][intPrice]);
    DBLog("log_property", "%s (uid: %i) upgraded their house interior (id: %i) to interior %i for $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], HouseInfo[houseid][hID], type, houseInteriors[type][intPrice]);
    return 1;
}

CMD:cancelupgrade(playerid, params[])
{
    new houseid = PlayerData[playerid][pPreviewHouse];
    if (houseid == INVALID_HOUSE_ID || !IsHouseOwner(playerid, houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't previewing a house interior at the moment.");
    }

    SetPlayerPos(playerid, HouseInfo[houseid][hIntX], HouseInfo[houseid][hIntY], HouseInfo[houseid][hIntZ]);
    SetPlayerFacingAngle(playerid, HouseInfo[houseid][hIntA]);
    SetPlayerInterior(playerid, HouseInfo[houseid][hInterior]);
    SetPlayerVirtualWorld(playerid, HouseInfo[houseid][hWorld]);
    SetCameraBehindPlayer(playerid);

    PlayerData[playerid][pPreviewHouse] = INVALID_HOUSE_ID;
    PlayerData[playerid][pPreviewType] = 0;
    PlayerData[playerid][pPreviewTime] = 0;

    SendClientMessage(playerid, COLOR_WHITE, "You have cancelled your interior upgrade. You were returned back to your old one.");
    return 1;
}
