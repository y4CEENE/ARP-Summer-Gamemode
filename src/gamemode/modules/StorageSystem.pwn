#include <YSI\y_hooks>

#define MAX_STORAGES 20
#define MAX_STORAGE_WEAPONS 10
#define INVALID_STORAGE_ID -1

enum eStorage
{
    Storage_Exist,
    Storage_ID,
    Storage_Name[50],
    Storage_Gang,
    Storage_Faction,
    Storage_Vip,
    Storage_Managerid,
    Storage_Locked,
    Float:Storage_PosX,
    Float:Storage_PosY,
    Float:Storage_PosZ,
    Storage_Interior,
    Storage_World,
    Storage_Materials,
    Storage_Cash,
    Storage_LimitMaterials,
    Storage_LimitCash,
    Storage_LimitDrugs,
    Storage_LimitWeaponSlots,
    Storage_Pot,
    Storage_Crack,
    Storage_Cocaine,
    Storage_Heroin,
    Storage_Chemicals,
    Storage_Weaponid[MAX_STORAGE_WEAPONS],
    Storage_Weaponqty[MAX_STORAGE_WEAPONS],
    Storage_Weaponrank[MAX_STORAGE_WEAPONS],
    Text3D:Storage_Label,
    Storage_Pickup
};

static Storages[MAX_STORAGES][eStorage];
static PlayerSelectedStorage[MAX_PLAYERS];
static PlayerStorageStartWeapon[MAX_PLAYERS];
static PlayerSelectedStorageItem[MAX_PLAYERS];


hook OnLoadDatabase(timestamp)
{
    mysql_tquery(connectionID, "SELECT * FROM storages", "OnLoadStorages");
    return 1;
}

publish OnLoadStorages()
{
    new rows = cache_get_row_count(connectionID);

    for(new i = 0; i < sizeof(Storages); i ++)
    {
        Storages[i][Storage_Exist] = false;
    }

    for (new i = 0; i < rows && i < sizeof(Storages); i ++)
	{
        Storages[i][Storage_Exist] = true;
		cache_get_field_content(i, "name", Storages[i][Storage_Name], connectionID, 50);
	    Storages[i][Storage_ID] = cache_get_field_content_int(i, "id");
        Storages[i][Storage_Gang] = cache_get_field_content_int(i, "gang");
        Storages[i][Storage_Faction] = cache_get_field_content_int(i, "faction");
        Storages[i][Storage_Vip] = cache_get_field_content_int(i, "vip");
        Storages[i][Storage_Managerid] = cache_get_field_content_int(i, "managerid");
        Storages[i][Storage_Locked] = cache_get_field_content_int(i, "locked");
        Storages[i][Storage_PosX] = cache_get_field_content_float(i, "pos_x");
        Storages[i][Storage_PosY] = cache_get_field_content_float(i, "pos_y");
        Storages[i][Storage_PosZ] = cache_get_field_content_float(i, "pos_z");
        Storages[i][Storage_Interior] = cache_get_field_content_int(i, "interior");
        Storages[i][Storage_World] = cache_get_field_content_int(i, "world");
        Storages[i][Storage_Materials] = cache_get_field_content_int(i, "materials");
        Storages[i][Storage_Cash] = cache_get_field_content_int(i, "cash");
        Storages[i][Storage_LimitMaterials] = cache_get_field_content_int(i, "limit_materials");
        Storages[i][Storage_LimitCash] = cache_get_field_content_int(i, "limit_cash");
        Storages[i][Storage_LimitDrugs] = cache_get_field_content_int(i, "limit_drugs");
        Storages[i][Storage_LimitWeaponSlots] = cache_get_field_content_int(i, "limit_weapon_slots");
        Storages[i][Storage_Pot] = cache_get_field_content_int(i, "pot");
        Storages[i][Storage_Crack] = cache_get_field_content_int(i, "crack");
        Storages[i][Storage_Cocaine] = cache_get_field_content_int(i, "cocaine");
        Storages[i][Storage_Heroin] = cache_get_field_content_int(i, "heroin");
        Storages[i][Storage_Chemicals] = cache_get_field_content_int(i, "Chemicals");
        Storages[i][Storage_Weaponid][0] = cache_get_field_content_int(i, "weaponid_0");
        Storages[i][Storage_Weaponqty][0] = cache_get_field_content_int(i, "weaponqty_0");
        Storages[i][Storage_Weaponrank][0] = cache_get_field_content_int(i, "weaponrank_0");
        Storages[i][Storage_Weaponid][1] = cache_get_field_content_int(i, "weaponid_1");
        Storages[i][Storage_Weaponqty][1] = cache_get_field_content_int(i, "weaponqty_1");
        Storages[i][Storage_Weaponrank][1] = cache_get_field_content_int(i, "weaponrank_1");
        Storages[i][Storage_Weaponid][2] = cache_get_field_content_int(i, "weaponid_2");
        Storages[i][Storage_Weaponqty][2] = cache_get_field_content_int(i, "weaponqty_2");
        Storages[i][Storage_Weaponrank][2] = cache_get_field_content_int(i, "weaponrank_2");
        Storages[i][Storage_Weaponid][3] = cache_get_field_content_int(i, "weaponid_3");
        Storages[i][Storage_Weaponqty][3] = cache_get_field_content_int(i, "weaponqty_3");
        Storages[i][Storage_Weaponrank][3] = cache_get_field_content_int(i, "weaponrank_3");
        Storages[i][Storage_Weaponid][4] = cache_get_field_content_int(i, "weaponid_4");
        Storages[i][Storage_Weaponqty][4] = cache_get_field_content_int(i, "weaponqty_4");
        Storages[i][Storage_Weaponrank][4] = cache_get_field_content_int(i, "weaponrank_4");
        Storages[i][Storage_Weaponid][5] = cache_get_field_content_int(i, "weaponid_5");
        Storages[i][Storage_Weaponqty][5] = cache_get_field_content_int(i, "weaponqty_5");
        Storages[i][Storage_Weaponrank][5] = cache_get_field_content_int(i, "weaponrank_5");
        Storages[i][Storage_Weaponid][6] = cache_get_field_content_int(i, "weaponid_6");
        Storages[i][Storage_Weaponqty][6] = cache_get_field_content_int(i, "weaponqty_6");
        Storages[i][Storage_Weaponrank][6] = cache_get_field_content_int(i, "weaponrank_6");
        Storages[i][Storage_Weaponid][7] = cache_get_field_content_int(i, "weaponid_7");
        Storages[i][Storage_Weaponqty][7] = cache_get_field_content_int(i, "weaponqty_7");
        Storages[i][Storage_Weaponrank][7] = cache_get_field_content_int(i, "weaponrank_7");
        Storages[i][Storage_Weaponid][8] = cache_get_field_content_int(i, "weaponid_8");
        Storages[i][Storage_Weaponqty][8] = cache_get_field_content_int(i, "weaponqty_8");
        Storages[i][Storage_Weaponrank][8] = cache_get_field_content_int(i, "weaponrank_8");
        Storages[i][Storage_Weaponid][9] = cache_get_field_content_int(i, "weaponid_9");
        Storages[i][Storage_Weaponqty][9] = cache_get_field_content_int(i, "weaponqty_9");
        Storages[i][Storage_Weaponrank][9] = cache_get_field_content_int(i, "weaponrank_9");
        ReloadStorage(i);
	}
}

GetNearestStorage(playerid)
{
    for(new i=0;i<sizeof(Storages);i++)
    {
        if(Storages[i][Storage_Exist])
        {
		    if (IsPlayerNearPoint(playerid, 10.0, Storages[i][Storage_PosX], Storages[i][Storage_PosY], Storages[i][Storage_PosZ], Storages[i][Storage_Interior], Storages[i][Storage_World]))
            {
                return i;
            }
        }
    }
    return INVALID_STORAGE_ID;
}

ReloadStorage(storageid)
{
    if(!Storages[storageid][Storage_Exist])
    {
        return 1;
    }
    new string[128];
    new Float:x  = Storages[storageid][Storage_PosX];
    new Float:y  = Storages[storageid][Storage_PosY];
    new Float:z  = Storages[storageid][Storage_PosZ];
    new vw       = Storages[storageid][Storage_World];
    new interior = Storages[storageid][Storage_Interior];
    DestroyDynamic3DTextLabel(Storages[storageid][Storage_Label]);
    DestroyDynamicPickup(Storages[storageid][Storage_Pickup]);
    
	format(string, sizeof(string), "{ffff00}[%s] (%i)\nUse /storage to search it.", Storages[storageid][Storage_Name], storageid);
    Storages[storageid][Storage_Label] = CreateDynamic3DTextLabel(string, COLOR_WHITE, x, y, z + 0.1, 10.0, .worldid = vw, .interiorid = interior);
    Storages[storageid][Storage_Pickup] = CreateDynamicPickup(19832, 1, x, y, z - 0.5, .worldid = vw, .interiorid = interior);

	return 1;
}

ShowStorageMainMenu(playerid, storageid)
{
    PlayerSelectedStorage[playerid] = storageid;

    new string[512];
    string = "Item\tStorage\n";
    PlayerStorageStartWeapon[playerid] = 0;

    if(Storages[storageid][Storage_LimitCash] > 0)
    {
        format(string, sizeof(string), "%s\n Cash\t%i/%i", string, Storages[storageid][Storage_Cash], Storages[storageid][Storage_LimitCash]);
        PlayerStorageStartWeapon[playerid]++;
    }

    if(Storages[storageid][Storage_LimitMaterials] > 0)
    {
        format(string, sizeof(string), "%s\n Materials\t%i/%i", string, Storages[storageid][Storage_Materials], Storages[storageid][Storage_LimitMaterials]);
        PlayerStorageStartWeapon[playerid]++;
    }
    if(Storages[storageid][Storage_LimitDrugs] > 0)
    {
        format(string, sizeof(string), "%s\n Pot\t%i/%i", string, Storages[storageid][Storage_Pot], Storages[storageid][Storage_LimitDrugs]);
        format(string, sizeof(string), "%s\n Crack\t%i/%i", string, Storages[storageid][Storage_Crack], Storages[storageid][Storage_LimitDrugs]);
        format(string, sizeof(string), "%s\n Cocaine\t%i/%i", string, Storages[storageid][Storage_Cocaine], Storages[storageid][Storage_LimitDrugs]);
        format(string, sizeof(string), "%s\n Heroin\t%i/%i", string, Storages[storageid][Storage_Heroin], Storages[storageid][Storage_LimitDrugs]);
        format(string, sizeof(string), "%s\n Chemicals\t%i/%i", string, Storages[storageid][Storage_Chemicals], Storages[storageid][Storage_LimitDrugs]);
        
        PlayerStorageStartWeapon[playerid] =  PlayerStorageStartWeapon[playerid] + 5;
    }
    if(Storages[storageid][Storage_LimitWeaponSlots] > 0)
    {
        for(new i=0; i<MAX_STORAGE_WEAPONS && i < Storages[storageid][Storage_LimitWeaponSlots]; i++)
        {
            if(Storages[storageid][Storage_Weaponid][i] <= 0 || Storages[storageid][Storage_Weaponqty][i] == 0)
            {
                Storages[storageid][Storage_Weaponid][i]  = 0;
                Storages[storageid][Storage_Weaponqty][i] = 0;
            }

            if(Storages[storageid][Storage_Gang] >= 0 || Storages[storageid][Storage_Faction] >= 0)
            {
                format(string, sizeof(string), "%s\n Weapon Slot %i [Rank %i]\t%s (Qty: %i)", string, i, Storages[storageid][Storage_Weaponrank][i], GetWeaponNameEx(Storages[storageid][Storage_Weaponid][i]), Storages[storageid][Storage_Weaponqty]);
            }
            else
            {
                format(string, sizeof(string), "%s\n Weapon Slot %i\t%s (Qty: %i)", string, i, GetWeaponNameEx(Storages[storageid][Storage_Weaponid][i]), Storages[storageid][Storage_Weaponqty][i]);
            }
        }
    }
    else
    {
        PlayerStorageStartWeapon[playerid] = -1;
    }
	Dialog_Show(playerid, StorageMainMenu, DIALOG_STYLE_TABLIST_HEADERS, "Storage", string, "Select", "Cancel");
    return 1;
}

Dialog:StorageMainMenu(playerid, response, listitem, inputtext[])
{
    if(!response || listitem < 0)
    {
        return 1;
    }
    PlayerSelectedStorageItem[playerid] = listitem;
    if(PlayerStorageStartWeapon[playerid] != -1 && listitem >= PlayerStorageStartWeapon[playerid] )
    {
        Dialog_Show(playerid, StorageOperation, DIALOG_STYLE_LIST, "Choose storage operation", "Deposit\nWithdraw\nSet rank", "Select", "Cancel");
    }
    else
    {
        Dialog_Show(playerid, StorageOperation, DIALOG_STYLE_LIST, "Choose storage operation", "Deposit\nWithdraw", "Select", "Cancel");
    }
    return 1;
}


Dialog:StorageOperation(playerid, response, listitem, inputtext[])
{
    if(!response || listitem < 0)
    {
        return 1;
    }
    new string[128];
    new storageid = PlayerSelectedStorage[playerid];
    new selecteditem = PlayerSelectedStorageItem[playerid];


    new index = 0;
    if(Storages[storageid][Storage_LimitCash] > 0)
    {
        if(index == selecteditem)
        {
            // Is Cash
            if(listitem == 1)
            {
                if(PlayerData[playerid][pID] == Storages[storageid][Storage_Managerid])
                {
                    format(string, sizeof(string), "Enter amount of cash to withdraw (Total: %s).", FormatCash(Storages[storageid][Storage_Cash]));
	                Dialog_Show(playerid, StorageCashWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");
                }
                else
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, " Only storage manager can withdraw cash.");
                }
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StorageCashDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of cash to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        index++;
    }
    if(Storages[storageid][Storage_LimitMaterials] > 0)
    {
        if(index == selecteditem)
        {
            // Is materials
            
            if(listitem == 1)
            {
                if(PlayerData[playerid][pID] == Storages[storageid][Storage_Managerid])
                {
                    format(string, sizeof(string), "Enter amount of materials to withdraw (Total: %s).", FormatNumber(Storages[storageid][Storage_Materials]));
	                Dialog_Show(playerid, StorageMaterialWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");
                }
                else
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, " Only storage manager can withdraw materials.");
                }
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StorageMaterialDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of materials to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        index++;
    }

    if(Storages[storageid][Storage_LimitDrugs] > 0)
    {
        if(selecteditem >= index && selecteditem <= index + 4 && PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid] && listitem == 1)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, " Only storage manager can withdraw drugs.");
        }
        if(index == selecteditem)
        {
            // Is Pot
            if(listitem == 1)
            {
                format(string, sizeof(string), "Enter amount of pot to withdraw (Total: %s).", FormatNumber(Storages[storageid][Storage_Pot]));
                Dialog_Show(playerid, StoragePotWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");                
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StoragePotDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of pot to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        else if(index + 1 == selecteditem)
        {
            // Is Crack
            if(listitem == 1)
            {
                format(string, sizeof(string), "Enter amount of crack to withdraw (Total: %s).", FormatNumber(Storages[storageid][Storage_Crack]));
                Dialog_Show(playerid, StorageCrackWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");                
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StorageCrackDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of crack to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        else if(index + 2 == selecteditem)
        {
            // Is Cocaine
            if(listitem == 1)
            {
                format(string, sizeof(string), "Enter amount of cocaine to withdraw (Total: %s).", FormatNumber(Storages[storageid][Storage_Cocaine]));
                Dialog_Show(playerid, StorageCocaineWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");                
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StorageCocaineDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of cocaine to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        else if(index + 3 == selecteditem)
        {
            // Is Heroin
            if(listitem == 1)
            {
                format(string, sizeof(string), "Enter amount of heroin to withdraw (Total: %s).", FormatNumber(Storages[storageid][Storage_Heroin]));
                Dialog_Show(playerid, StorageHeroinWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");                
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StorageHeroinDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of heroin to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        else if(index + 4 == selecteditem)
        {
            // Is Chemicals
            if(listitem == 1)
            {
                format(string, sizeof(string), "Enter amount of chemicals to withdraw (Total: %s).", FormatNumber(Storages[storageid][Storage_Chemicals]));
                Dialog_Show(playerid, StorageChemicalsWithdraw, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");                
            }
            else if(listitem == 0)
            {
	            Dialog_Show(playerid, StorageChemicalsDeposit, DIALOG_STYLE_INPUT, "Storage deposit", "Enter amount of chemicals to deposit.", "Select", "Cancel");
            }
            return 1;
        }
        index = index + 5;
    }

    if(Storages[storageid][Storage_LimitWeaponSlots] > 0)
    {
        new weaponslot = selecteditem - index;
        if(weaponslot < Storages[storageid][Storage_LimitWeaponSlots])
        {
            if(listitem == 1)
            {
                // Withdraw
                if(Storages[storageid][Storage_Gang] >= 0)
                {
                    if(Storages[storageid][Storage_Gang] != PlayerData[playerid][pGang])
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this storage.");
                    }
                    else if(Storages[storageid][Storage_Weaponrank][weaponslot] > PlayerData[playerid][pGangRank])
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be R%i+ to withdraw this weapon.", Storages[storageid][Storage_Weaponrank][weaponslot]);
                    }
                }

                if(Storages[storageid][Storage_Faction] >= 0)
                {
                    if(Storages[storageid][Storage_Faction] != PlayerData[playerid][pFaction])
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this storage.");
                    }
                    else if(Storages[storageid][Storage_Weaponrank][weaponslot] > PlayerData[playerid][pFactionRank])
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You need to be R%i+ to withdraw this weapon.", Storages[storageid][Storage_Weaponrank][weaponslot]);
                    }
                }
                if(Storages[storageid][Storage_Vip] > PlayerData[playerid][pDonator])
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You need to be VIP %s (Level %i) to use this storage.", GetVIPRankEx(Storages[storageid][Storage_Vip]), Storages[storageid][Storage_Vip]);
                }
                if(Storages[storageid][Storage_Weaponid][weaponslot] == 0 || Storages[storageid][Storage_Weaponqty][weaponslot] <= 0)
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "There is no weapon in this slot.");
                }
                
                if(PlayerHasWeapon(playerid, Storages[storageid][Storage_Weaponid][weaponslot]))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You already have this weapon.");
                }
                
                GivePlayerWeaponEx(playerid, Storages[storageid][Storage_Weaponid][weaponslot]);

                Storages[storageid][Storage_Weaponqty][weaponslot]--;
                if(Storages[storageid][Storage_Weaponqty][weaponslot] <= 0)
                {
                    Storages[storageid][Storage_Weaponqty][weaponslot] = 0;
                    Storages[storageid][Storage_Weaponid][weaponslot] = 0;
                }

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET weaponid_%i = %i, weaponqty_%i = %i WHERE id = %i", weaponslot, Storages[storageid][Storage_Weaponid][weaponslot], weaponslot, Storages[storageid][Storage_Weaponqty][weaponslot], Storages[storageid][Storage_ID]);
                mysql_tquery(connectionID, queryBuffer);
                return 1;
            }
            else if(listitem == 0)
            {
                //deposit
                if(Storages[storageid][Storage_Gang] >= 0)
                {
                    if(Storages[storageid][Storage_Gang] != PlayerData[playerid][pGang])
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this storage.");
                    }
                }

                if(Storages[storageid][Storage_Faction] >= 0)
                {
                    if(Storages[storageid][Storage_Faction] != PlayerData[playerid][pFaction])
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this storage.");
                    }
                }
                if(Storages[storageid][Storage_Vip] > PlayerData[playerid][pDonator])
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You need to be VIP %s (Level %i) to use this storage.", GetVIPRankEx(Storages[storageid][Storage_Vip]), Storages[storageid][Storage_Vip]);
                }

                new playerweaponid = GetPlayerWeapon(playerid);
                
                if(playerweaponid == 0 || !PlayerHasWeapon(playerid, playerweaponid))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have a weapon on your hands.");
                }

                if(Storages[storageid][Storage_Weaponid][weaponslot] == 0)
                {
                    Storages[storageid][Storage_Weaponid][weaponslot] = playerweaponid;
                    Storages[storageid][Storage_Weaponqty][weaponslot] = 1;
                }
                else  if(Storages[storageid][Storage_Weaponid][weaponslot] != playerweaponid)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You cannot deposit this weapon in this slot.");
                }
                else
                {
                    Storages[storageid][Storage_Weaponqty][weaponslot]++;
                }

	            RemovePlayerWeapon(playerid, playerweaponid);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET weaponid_%i = %i, weaponqty_%i = %i WHERE id = %i", weaponslot, Storages[storageid][Storage_Weaponid][weaponslot], weaponslot, Storages[storageid][Storage_Weaponqty][weaponslot], Storages[storageid][Storage_ID]);
                mysql_tquery(connectionID, queryBuffer);
                return 1;
            }
            else if(listitem == 2)
            {
                //Set Rank
                if(PlayerData[playerid][pID] == Storages[storageid][Storage_Managerid])
                {
                    PlayerStorageStartWeapon[playerid] = weaponslot;
                    format(string, sizeof(string), "Enter the new rank for weapon slot %i: ", weaponslot);
	                Dialog_Show(playerid, StorageWeaponSetRank, DIALOG_STYLE_INPUT, "Storage withdraw", string, "Select", "Cancel");
                }
                else
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, " Only storage manager can change ranks.");
                }
            }
            return 1;
        }

    }

    return 1;
}
Dialog:StorageWeaponSetRank(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] == Storages[storageid][Storage_Managerid])
    {
        new rank=0;
       	if(sscanf(inputtext, "i", rank) || !(0<=rank<=6))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "Invalid rank value must be between 0 and 6.");
        }
        new slot = PlayerStorageStartWeapon[playerid];

        Storages[storageid][Storage_Weaponrank][slot] = rank;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET weaponrank_%i = %i WHERE id = %i", slot,rank,  Storages[storageid][Storage_ID]);
        mysql_tquery(connectionID, queryBuffer);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have set weapon slot %i rank to %i of storage %i.", slot, rank, storageid);
    }
    else
    {
        return SendClientMessageEx(playerid, COLOR_GREY, " Only storage manager can change ranks.");
    }
    return 1;
}

Dialog:StorageCashWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new cash = 0;
    new storageid = PlayerSelectedStorage[playerid];

    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to withdraw cash.");
    }
	if(sscanf(inputtext, "i", cash))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of cash.");
    }
    if(cash >  Storages[storageid][Storage_Cash])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "This amount of cash is not available in this storage.");
    }

    GivePlayerCash(playerid, cash);
    Storages[storageid][Storage_Cash] -= cash;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET cash = %i WHERE id = %i", Storages[storageid][Storage_Cash], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have withdraw %s.", FormatCash(cash));
    return 1;
}
Dialog:StorageCashDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new cash = 0;
    new storageid = PlayerSelectedStorage[playerid];
	if(sscanf(inputtext, "i", cash))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of cash.");
    }
    if(PlayerData[playerid][pCash]<cash)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have this amount of cash.");
    }

    if(Storages[storageid][Storage_LimitCash] < Storages[storageid][Storage_Cash] + cash)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "There is no space for this amount of cash.");
    }

    GivePlayerCash(playerid, -cash);
    Storages[storageid][Storage_Cash] += cash;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET cash = %i WHERE id = %i", Storages[storageid][Storage_Cash], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have deposit %s.", FormatCash(cash));

    return 1;
}

Dialog:StorageMaterialWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to withdraw materials.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of materials.");
    }
    if(amount >  Storages[storageid][Storage_Materials])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "This amount of materials is not available in this storage.");
    }

    PlayerData[playerid][pMaterials] +=  amount;
    Storages[storageid][Storage_Materials] -= amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET materials = %i WHERE id = %i", Storages[storageid][Storage_Materials], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have withdraw %s materials.", FormatNumber(amount));

    return 1;
}

Dialog:StorageMaterialDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to deposit materials.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of materials.");
    }
    if(PlayerData[playerid][pMaterials]<amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have this amount of materials.");
    }
    if(Storages[storageid][Storage_LimitMaterials] < Storages[storageid][Storage_Materials] + amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "There is no space for this amount of materials.");
    }

    PlayerData[playerid][pMaterials] -=  amount;
    Storages[storageid][Storage_Materials] += amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET materials = %i WHERE id = %i", Storages[storageid][Storage_Materials], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have deposit %s materials.", FormatNumber(amount));

    return 1;
}
Dialog:StoragePotWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to withdraw pot.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of pot.");
    }
    if(amount >  Storages[storageid][Storage_Pot])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "This amount of pot is not available in this storage.");
    }

    PlayerData[playerid][pWeed] +=  amount;
    Storages[storageid][Storage_Pot] -= amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET pot = %i WHERE id = %i", Storages[storageid][Storage_Pot], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have withdraw %s pot.", FormatNumber(amount));

    return 1;
}
Dialog:StoragePotDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to deposit pots.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of pots.");
    }
    if(PlayerData[playerid][pWeed] < amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have this amount of pots.");
    }
    if(Storages[storageid][Storage_LimitDrugs] < Storages[storageid][Storage_Pot] + amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "There is no space for this amount of pots.");
    }

    PlayerData[playerid][pWeed] -=  amount;
    Storages[storageid][Storage_Pot] += amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET pot = %i WHERE id = %i", Storages[storageid][Storage_Pot], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have deposit %s pot.", FormatNumber(amount));

    return 1;
}
Dialog:StorageCrackWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to withdraw crack.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of crack.");
    }
    if(amount >  Storages[storageid][Storage_Crack])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "This amount of crack is not available in this storage.");
    }

    PlayerData[playerid][pCocaine] +=  amount;
    Storages[storageid][Storage_Crack] -= amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET crack = %i WHERE id = %i", Storages[storageid][Storage_Crack], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have withdraw %s crack.", FormatNumber(amount));
    return 1;
}
Dialog:StorageCrackDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to deposit cracks.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of cracks.");
    }
    if(PlayerData[playerid][pCocaine] < amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have this amount of cracks.");
    }
    if(Storages[storageid][Storage_LimitDrugs] < Storages[storageid][Storage_Crack] + amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "There is no space for this amount of cracks.");
    }

    PlayerData[playerid][pCocaine] -=  amount;
    Storages[storageid][Storage_Crack] += amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET crack = %i WHERE id = %i", Storages[storageid][Storage_Crack], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have deposit %s cracks.", FormatNumber(amount));
    return 1;
}
Dialog:StorageCocaineWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    return 1;
}
Dialog:StorageCocaineDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    return 1;
}
Dialog:StorageHeroinWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to withdraw heroin.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of heroin.");
    }
    if(amount >  Storages[storageid][Storage_Heroin])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "This amount of heroin is not available in this storage.");
    }

    PlayerData[playerid][pMeth] +=  amount;
    Storages[storageid][Storage_Heroin] -= amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET heroin = %i WHERE id = %i", Storages[storageid][Storage_Heroin], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have withdraw %s heroin.", FormatNumber(amount));
    return 1;
}
Dialog:StorageHeroinDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to deposit heroin.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of heroin.");
    }
    if(PlayerData[playerid][pMeth] < amount)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have this amount of heroin.");
    }
    if(Storages[storageid][Storage_LimitDrugs] < Storages[storageid][Storage_Heroin] + amount)
    {
        return SendClientMessageEx(playerid, COLOR_AQUA, "There is no space for this amount of heroin.");
    }

    PlayerData[playerid][pMeth] -=  amount;
    Storages[storageid][Storage_Heroin] += amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET heroin = %i WHERE id = %i", Storages[storageid][Storage_Heroin], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have deposit %s heroin.", FormatNumber(amount));
    return 1;
}
Dialog:StorageChemicalsWithdraw(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new amount = 0;
    new storageid = PlayerSelectedStorage[playerid];
    if(PlayerData[playerid][pID] != Storages[storageid][Storage_Managerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to withdraw chemicals.");
    }
	if(sscanf(inputtext, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount of chemicals.");
    }
    if(amount >  Storages[storageid][Storage_Chemicals])
    {
        return SendClientMessageEx(playerid, COLOR_AQUA, "This amount of chemicals is not available in this storage.");
    }

    PlayerData[playerid][pEphedrine] +=  amount;
    Storages[storageid][Storage_Chemicals] -= amount;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET chemicals = %i WHERE id = %i", Storages[storageid][Storage_Chemicals], Storages[storageid][Storage_ID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessageEx(playerid, COLOR_GREY, "You have withdraw %s chemicals.", FormatNumber(amount));
    return 1;
}
Dialog:StorageChemicalsDeposit(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    return 1;
}

CMD:storage(playerid, params[])
{
    new storageid = GetNearestStorage(playerid);

    if(storageid == INVALID_STORAGE_ID)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not near any storage.");
    }
    if(Storages[storageid][Storage_Managerid] != PlayerData[playerid][pID])
    {
        if(Storages[storageid][Storage_Gang] != -1 && Storages[storageid][Storage_Gang] != PlayerData[playerid][pGang])
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You need to be apart of a specific gang to use this storage.");
        }
        if(Storages[storageid][Storage_Faction] != -1 && Storages[storageid][Storage_Faction] != PlayerData[playerid][pFaction])
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You need to be apart of a specific faction to use this storage.");
        }
        if(Storages[storageid][Storage_Vip] != 0 && Storages[storageid][Storage_Vip] > PlayerData[playerid][pDonator])
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You need to be VIP %s (Level %i) to use this storage.", GetVIPRankEx(Storages[storageid][Storage_Vip]), Storages[storageid][Storage_Vip]);
        }
    }
    
    ShowStorageMainMenu(playerid, storageid);
    return 1;
}

CMD:createstorage(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if(isnull(params))
    {
        return SendUsageHeader(playerid, "createstorage", "[name]");
    }
    new storageid = -1;
    for(new i=0;i<sizeof(Storages);i++)
    {
        if(!Storages[i][Storage_Exist])
        {
            storageid = i;
            break;
        }
    }
    if(storageid == -1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "There is no available slots for storages.");
    }
    new Float:x, Float:y, Float:z;
    new vw = GetPlayerVirtualWorld(playerid);
    new interior = GetPlayerInterior(playerid);
    GetPlayerPosEx(playerid, x, y, z);
    strcpy(Storages[storageid][Storage_Name], params, 50);
    Storages[storageid][Storage_PosX] = x;
    Storages[storageid][Storage_PosY] = y;
    Storages[storageid][Storage_PosZ] = z;
    Storages[storageid][Storage_World] = vw;
    Storages[storageid][Storage_Interior] = interior;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO storages (name,pos_x,pos_y,pos_z,interior,world) VALUES('%e',%.4f,%.4f,%.4f,%i,%i)", params, x, y, z, interior, vw);
	mysql_tquery(connectionID, queryBuffer, "OnStorageAdded", "i", storageid);
    return 1;
}

publish OnStorageAdded(storageid)
{
    Storages[storageid][Storage_Exist] = true;
    Storages[storageid][Storage_ID] = cache_insert_id(connectionID);
    Storages[storageid][Storage_Gang] = -1;
    Storages[storageid][Storage_Faction] = -1;
    Storages[storageid][Storage_Vip] = 0;
    Storages[storageid][Storage_Managerid] = 1;
    Storages[storageid][Storage_Locked] = 0;
    Storages[storageid][Storage_Materials] = 0;
    Storages[storageid][Storage_Cash] = 0;
    Storages[storageid][Storage_LimitMaterials] = 300000;
    Storages[storageid][Storage_LimitCash] = 10000000;
    Storages[storageid][Storage_LimitDrugs] = 2000;
    Storages[storageid][Storage_LimitWeaponSlots] = MAX_STORAGE_WEAPONS;
    Storages[storageid][Storage_Pot] = 0;
    Storages[storageid][Storage_Crack] = 0;
    Storages[storageid][Storage_Cocaine] = 0;
    Storages[storageid][Storage_Heroin] = 0;
    Storages[storageid][Storage_Chemicals] = 0;
    
    for(new i=0;i<MAX_STORAGE_WEAPONS;i++)
    {
        Storages[storageid][Storage_Weaponid][i] = 0;
        Storages[storageid][Storage_Weaponqty][i] = 0;
        Storages[storageid][Storage_Weaponrank][i] = 0;
    }
    ReloadStorage(storageid);
    return 1;
}

CMD:editstorage(playerid, params[])
{
    new storageid, option[14], param[64];

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "is[14]S()[64]", storageid, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Location, Name, ManagerID, Faction, Gang, VIP");
		SendClientMessage(playerid, COLOR_SYNTAX, "List of options: MaxCash, MaxMaterials, MaxDrugs, MaxWeapons, Locked");
	    return 1;
	}
	if(!(0 <= storageid < sizeof(Storages)) || !Storages[storageid][Storage_Exist])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid storage.");
	}

	if(!strcmp(option, "location", true))
	{
        new Float:x, Float:y, Float:z;
        new vw = GetPlayerVirtualWorld(playerid);
        new interior = GetPlayerInterior(playerid);
        GetPlayerPosEx(playerid, x, y, z);
        strcpy(Storages[storageid][Storage_Name], params, 50);
        Storages[storageid][Storage_PosX] = x;
        Storages[storageid][Storage_PosY] = y;
        Storages[storageid][Storage_PosZ] = z;
        Storages[storageid][Storage_World] = vw;
        Storages[storageid][Storage_Interior] = interior;
        
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET pos_x = '%.4f', pos_y = '%.4f', pos_z = '%.4f', interior = %i, world = %i WHERE id = %i", x, y, z, interior, vw, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadStorage(storageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the location of storage %i.", storageid);
	}
	else if(!strcmp(option, "name", true))
	{
	    new name[50];

	    if(sscanf(param, "s[50]", name))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [name] [text]");
		}

		strcpy(Storages[storageid][Storage_Name], name, 50);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET name = '%e' WHERE id = %i", name, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

		ReloadStorage(storageid);
	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the name of storage %i to '%s'.", storageid, name);
	}
	else if(!strcmp(option, "managerid", true))
	{
	    new managerid;

	    if(sscanf(param, "i", managerid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [managerid] [db_id]");
		}
        Storages[storageid][Storage_Managerid] = managerid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET managerid = %i WHERE id = %i", managerid, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the manager id of storage %i to %i.", storageid, managerid);
	}
	else if(!strcmp(option, "gang", true))
	{
	    new gangid;

	    if(sscanf(param, "i", gangid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [gang] [id]");
		}
        
        if(!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
		{
		    return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
		}

        Storages[storageid][Storage_Gang] = gangid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET gang = %i WHERE id = %i", gangid, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the gang id of storage %i to %i.", storageid, gangid);
	}
	else if(!strcmp(option, "faction", true))
	{
	    new factionid;

	    if(sscanf(param, "i", factionid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [faction] [id]");
		}
	    if(!(-1 <= factionid < MAX_FACTIONS) || (factionid >= 0 && FactionInfo[factionid][fType] == FACTION_NONE))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction id.");
        }

        Storages[storageid][Storage_Faction] = factionid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET faction = %i WHERE id = %i", factionid, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the faction id of storage %i to %i.", storageid, factionid);
	}
	else if(!strcmp(option, "vip", true))
	{
	    new viprank;

	    if(sscanf(param, "i", viprank))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [vip] [level]");
		}
	    if(!(0 <= viprank <= 3))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid vip level.");
        }

        Storages[storageid][Storage_Vip] = viprank;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET vip = %i WHERE id = %i", viprank, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the vip level of storage %i to %i.", storageid, viprank);
	}
    else if(!strcmp(option, "locked", true))
	{
	    new locked;

	    if(sscanf(param, "i", locked) || !(0 <= locked <= 1))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [locked] [0/1]");
		}

		Storages[storageid][Storage_Locked] = locked;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET locked = %i WHERE id = %i", locked, Storages[storageid][Storage_ID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the lock state of storage %i to %i.", storageid, locked);
	}
    else if(!strcmp(option, "maxcash", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [maxcash] [value]");
        }
        if(value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
        }

        Storages[storageid][Storage_LimitCash] = value;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET limit_cash = %i WHERE id = %i", value, Storages[storageid][Storage_ID]);
        mysql_tquery(connectionID, queryBuffer);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the limit of cash of storage %i to %i.", storageid, value);
    }
    else if(!strcmp(option, "maxcash", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [maxcash] [value]");
        }
        if(value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
        }

        Storages[storageid][Storage_LimitCash] = value;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET limit_cash = %i WHERE id = %i", value, Storages[storageid][Storage_ID]);
        mysql_tquery(connectionID, queryBuffer);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the limit of cash of storage %i to %i.", storageid, value);
    }
    else if(!strcmp(option, "maxmaterials", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [maxmaterials] [value]");
        }
        if(value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
        }

        Storages[storageid][Storage_LimitMaterials] = value;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET limit_materials = %i WHERE id = %i", value, Storages[storageid][Storage_ID]);
        mysql_tquery(connectionID, queryBuffer);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the limit of materials of storage %i to %i.", storageid, value);
    }
    else if(!strcmp(option, "maxdrugs", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [maxdrugs] [value]");
        }
        if(value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
        }

        Storages[storageid][Storage_LimitDrugs] = value;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET limit_drugs = %i WHERE id = %i", value, Storages[storageid][Storage_ID]);
        mysql_tquery(connectionID, queryBuffer);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the limit of drugs of storage %i to %i.", storageid, value);
    }
    else if(!strcmp(option, "maxweapons", true))
    {
        new value;

        if(sscanf(param, "i", value))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editstorage [storageid] [maxweapons] [value]");
        }
        if(value < 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value.");
        }

        Storages[storageid][Storage_LimitWeaponSlots] = value;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE storages SET limit_weapon_slots = %i WHERE id = %i", value, Storages[storageid][Storage_ID]);
        mysql_tquery(connectionID, queryBuffer);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the limit of weapons slots of storage %i to %i.", storageid, value);
    }
    return 1;
}




CMD:removestorage(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    new storageid = -1; 
    if(sscanf(params, "i", storageid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removestorage [storageid]");
	    return 1;
	}
	if(!(0 <= storageid < sizeof(Storages)) || !Storages[storageid][Storage_Exist])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid storage.");
	}
    DestroyDynamic3DTextLabel(Storages[storageid][Storage_Label]);
    DestroyDynamicPickup(Storages[storageid][Storage_Pickup]);    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM `storages` WHERE `id` = '%d'", Storages[storageid][Storage_ID]);
	mysql_tquery(connectionID, queryBuffer);
	SendClientMessageEx(playerid, COLOR_AQUA, "Storage id %i is removed.", storageid);
    return 1;
}

CMD:gotostorage(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    
    new storageid = -1; 
    if(sscanf(params, "i", storageid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotostorage [storageid]");
	    return 1;
	}
	if(!(0 <= storageid < sizeof(Storages)) || !Storages[storageid][Storage_Exist])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid storage.");
	}
    new interiorid = Storages[storageid][Storage_Interior];
    new worldid = Storages[storageid][Storage_World];
    new Float:x = Storages[storageid][Storage_PosX];
    new Float:y = Storages[storageid][Storage_PosY];
    new Float:z = Storages[storageid][Storage_PosZ];
    new Float:angle;
    GetPlayerFacingAngle(playerid, angle);
    
    TeleportToCoords(playerid, x,y,z,angle,interiorid,worldid, true, false);
    return 1;
}