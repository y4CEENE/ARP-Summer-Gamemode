/// @file      ShowDialog.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

enum
{
    DIALOG_NONE = 1,
    DIALOG_ATM,
    DIALOG_ATMDEPOSIT,
    DIALOG_ATMWITHDRAW,
    DIALOG_BUYCLOTHES,
    DIALOG_BUYCLOTHING,
    DIALOG_BUYCLOTHINGTYPE,
    DIALOG_BUYVEHICLENEW,
    DIALOG_DELETEOBJECT,
    DIALOG_FACTIONEQUIPMENT,
    DIALOG_FACTIONPAY1,
    DIALOG_GANGARMSDEALER,
    DIALOG_GANGARMSEDIT,
    DIALOG_GANGARMSPRICES,
    DIALOG_GANGARMSWEAPONS,
    DIALOG_GANGDEPOSIT,
    DIALOG_GANGSTASH,
    DIALOG_GANGSTASHCASH,
    DIALOG_GANGSTASHCRAFT,
    DIALOG_GANGSTASHDRUGS1,
    DIALOG_GANGSTASHDRUGS2,
    DIALOG_GANGSTASHMATS,
    DIALOG_GANGSTASHVEST,
    DIALOG_GANGSTASHWEAPONS1,
    DIALOG_GANGWITHDRAW,
    DIALOG_GANG_PROMOTION,
    DIALOG_HELP,
    DIALOG_LOCATE,
    DIALOG_PAINTBALL,
    DIALOG_POST_APPLICATION,
    DIALOG_SETTINGS,
    DIALOG_SETTINGS2,
    DIALOG_ADMINHELP,
    GangStashDepositMats,
    GangStashWithdrawMats,
    DIALOG_GIVE,
	DIALOG_AMOUNT
}

ShowDialogToPlayer(playerid, dialogid)
{
    new string[4096];

    switch (dialogid)
    {
        case DIALOG_SETTINGS2:
        {
            format(string, sizeof(string), "Info\tStatus\n" \
                "PM\t%s\n" \
                "VIP\t%s\n" \
                "Faction\t%s\n" \
                "Gang\t%s\n" \
                "Spawn Camera\t%s\n" \
                "HUD\t%s\n" \
                "Vehicle Camera\t%s\n" \
                "<< Back",
                (PlayerData[playerid][pTogglePM]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleVIP]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleFaction]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleGang]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleCam]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleHUD]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleVehCam] == 1) ? ("{ff0000}Off") : ("{00FF00}On"));
            Dialog_Show(playerid, DIALOG_SETTINGS2, DIALOG_STYLE_TABLIST_HEADERS, "Settings", string, "Tog", "Close");

        }
        case DIALOG_SETTINGS:
        {
            format(string, sizeof(string), "Info\tStatus\n" \
                "Textdraws\t%s\n" \
                "OOC\t%s\n" \
                "Global\t%s\n" \
                "Phone\t%s\n" \
                "Whisper\t%s\n" \
                "Newbie\t%s\n" \
                "PrivateRadio\t%s\n" \
                "Radio\t%s\n" \
                "Streams\t%s\n" \
                "News\t%s\n" \
                "Next >>",
                (PlayerData[playerid][pToggleTextdraws]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleOOC]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleGlobal]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pTogglePhone]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleWhisper]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleNewbie]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pTogglePR]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleRadio]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleMusic]== 1) ? ("{ff0000}Off") : ("{00FF00}On"),
                (PlayerData[playerid][pToggleNews]== 1) ? ("{ff0000}Off") : ("{00FF00}On"));
            Dialog_Show(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Settings", string, "Tog", "Close");
        }
        case DIALOG_POST_APPLICATION:
        {
            format(string, sizeof(string), "Name:\n\
                                            Date of Birth:\n\
                                            Are you male or female:\n\
                                            Where are you from:\n\
                                            Where do you currently live:\n\
                                            Experience((150 words)):\n\
                                            Why do you want to join((150 words)):\n");
            Dialog_Show(playerid, DIALOG_POST_APPLICATION, DIALOG_STYLE_LIST, "PD Application ((IC))", string, "Submit", "Cancel");
        }
        case DIALOG_HELP:
        {
            Dialog_Show(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "List of Commands", "Chat\nGeneral\nUpgrades\nOthers\nGang\nFaction\nVIP\nJob", "Select", "Close");
        }
        case DIALOG_BUYVEHICLENEW:
        {
            Dialog_Show(playerid, DIALOG_BUYVEHICLENEW, DIALOG_STYLE_LIST, "Vehicle Menu", "Browse as Model\nBrowse as List", "Select", "");
        }
        case DIALOG_ATM:
        {
            format(string, sizeof(string), "What would you like to do today? (Your account balance is %s.)", FormatCash(PlayerData[playerid][pBank]));
            Dialog_Show(playerid, DIALOG_ATM, DIALOG_STYLE_LIST, string, "Cash deposit\nCash withdraw", "Select", "Cancel");
        }
        case DIALOG_ATMDEPOSIT:
        {
            format(string, sizeof(string), "How much would you like to deposit? (Your account balance is %s.)", FormatCash(PlayerData[playerid][pBank]));
            Dialog_Show(playerid, DIALOG_ATMDEPOSIT, DIALOG_STYLE_INPUT, "ATM Deposit", string, "Select", "Cancel");
        }
        case DIALOG_ATMWITHDRAW:
        {
            format(string, sizeof(string), "How much would you like to withdraw? (Your account balance is %s.)", FormatCash(PlayerData[playerid][pBank]));
            Dialog_Show(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_INPUT, "ATM Withdraw", string, "Select", "Cancel");
        }
        case DIALOG_BUYCLOTHINGTYPE:
        {
            Dialog_Show(playerid, DIALOG_BUYCLOTHINGTYPE, DIALOG_STYLE_LIST, "Choose a browsing method.", "Browse by Model\nBrowse by List", "Select", "Back");
        }
        case DIALOG_BUYCLOTHING:
        {
            new index = -1;

            for (new i = 0; i < sizeof(clothingArray); i ++)
            {
                if (!strcmp(clothingArray[i][clothingType], clothingTypes[PlayerData[playerid][pCategory]]))
                {
                    if (index == -1)
                    {
                        index = i;
                    }

                    format(string, sizeof(string), "%s\n%s", string, clothingArray[i][clothingName]);
                }
            }

            PlayerData[playerid][pClothingIndex] = index;
            Dialog_Show(playerid, DIALOG_BUYCLOTHING, DIALOG_STYLE_LIST, "Choose an item in order to preview it.", string, "Select", "Back");
        }
        case DIALOG_BUYCLOTHES:
        {
            new businessid = GetInsideBusiness(playerid);

            if (businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
            {
                format(string, sizeof(string), "%s's %s [%i products]", BusinessInfo[businessid][bOwner], bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bProducts]);

                if (PlayerData[playerid][pDonator] > 0)
                {
                    Dialog_Show(playerid, DIALOG_BUYCLOTHES, DIALOG_STYLE_INPUT, string, "NOTE: New clothes are free for VIP members.\n\nPlease input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.com/wiki/Skins:All ))", "Submit", "Cancel");
                }
                else
                {
                    Dialog_Show(playerid, DIALOG_BUYCLOTHES, DIALOG_STYLE_INPUT, string, "NOTE: New clothes costs $2,000.\n\nPlease input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.com/wiki/Skins:All ))", "Submit", "Cancel");
                }
            }
        }

        case DIALOG_FACTIONPAY1:
        {
            string = "#\tRank\tPaycheck";

            for (new i = 0; i < FactionInfo[PlayerData[playerid][pFactionEdit]][fRankCount]; i ++)
            {
                format(string, sizeof(string), "%s\n%i\t%s\t{00AA00}%s{FFFFFF}", string, i, FactionRanks[PlayerData[playerid][pFactionEdit]][i], FormatCash(FactionInfo[PlayerData[playerid][pFactionEdit]][fPaycheck][i]));
            }
            new header[128];
            format(header, sizeof(header), "%s - {FFD700}$%i available/$%i budget", FactionInfo[PlayerData[playerid][pFactionEdit]][fName], FormatCash(FactionInfo[PlayerData[playerid][pFactionEdit]][fBudget] - GetTotalFactionPay(PlayerData[playerid][pFactionEdit])), FormatCash(FactionInfo[PlayerData[playerid][pFactionEdit]][fBudget]));
            Dialog_Show(playerid, DIALOG_FACTIONPAY1, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Change", "Cancel");
        }
        case DIALOG_GANGSTASH:
        {
            format(string, sizeof(string), "Weapons\nKevlar Vest\nDrugs\nClothes\nCrafting\nMaterials (%d/%d)\nCash ($%d/$%d)", GangInfo[PlayerData[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS), GangInfo[PlayerData[playerid][pGang]][gCash], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH));
            Dialog_Show(playerid, DIALOG_GANGSTASH, DIALOG_STYLE_LIST, "Gang Stash", string, "Select", "Cancel");
        }
        case DIALOG_GANGSTASHVEST:
        {
            format(string, sizeof(string), "Withdraw (R%i+)\nChange Rank", GangInfo[PlayerData[playerid][pGang]][gVestRank]);
            Dialog_Show(playerid, DIALOG_GANGSTASHVEST, DIALOG_STYLE_LIST, "Gang stash | Kevlar Vest (Costs 200 materials.)", string, "Select", "Back");
        }
        case DIALOG_GANGSTASHWEAPONS1:
        {
            new gangstring[1260];
            gangstring = "Amount\tName\tRank\t";
            format(gangstring, sizeof(gangstring), "%s\n\
                [%i]\t 9mm\t (R%i+)\n\
                [%i]\t Sdpistol\t (R%i+)\n\
                [%i]\t Deagle\t (R%i+)\n\
                [%i]\t Shotgun\t (R%i+)\n\
                [%i]\t Tec-9\t (R%i+)\n\
                [%i]\t Micro Uzi\t (R%i+)\n\
                [%i]\t MP5\t (R%i+)\n\
                [%i]\t AK-47\t (R%i+)\n\
                [%i]\t Rifle\t (R%i+)\n\
                [%i]\t M4\t (R%i+)\n\
                [%i]\t SPAS12\t (R%i+)\n\
                [%i]\t Sniper\t (R%i+)",
                gangstring,
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_9MM],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SDPISTOL],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_DEAGLE],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SHOTGUN],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_TEC9],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_UZI],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_MP5],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_AK47],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_RIFLE],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_M4],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SPAS12],
                GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER], GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SNIPER]);

            Dialog_Show(playerid, DIALOG_GANGSTASHWEAPONS1, DIALOG_STYLE_TABLIST_HEADERS, "Gang stash | Weapons", gangstring, "Select", "Back");
        }

        case DIALOG_GANGSTASHDRUGS1:
        {
            format(string, sizeof(string), "Weed (%i/%ig)\nCocaine (%i/%ig)\nHeroin (%i/%ig)\nPainkillers (%i/%i)",
                GangInfo[PlayerData[playerid][pGang]][gWeed],        GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED),
                GangInfo[PlayerData[playerid][pGang]][gCocaine],     GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE),
                GangInfo[PlayerData[playerid][pGang]][gHeroin],      GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN),
                GangInfo[PlayerData[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
            Dialog_Show(playerid, DIALOG_GANGSTASHDRUGS1, DIALOG_STYLE_LIST, "Gang stash | Drugs", string, "Select", "Back");
        }
        case DIALOG_GANGSTASHDRUGS2:
        {
            if (PlayerData[playerid][pSelected] == ITEM_WEED)
            {
                Dialog_Show(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang stash | Weed", "Withdraw\nDeposit", "Select", "Back");
            }
            else if (PlayerData[playerid][pSelected] == ITEM_COCAINE)
            {
                Dialog_Show(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang stash | Cocaine", "Withdraw\nDeposit", "Select", "Back");
            }
            else if (PlayerData[playerid][pSelected] == ITEM_HEROIN)
            {
                Dialog_Show(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang stash | Heroin", "Withdraw\nDeposit", "Select", "Back");
            }
            else if (PlayerData[playerid][pSelected] == ITEM_PAINKILLERS)
            {
                Dialog_Show(playerid, DIALOG_GANGSTASHDRUGS2, DIALOG_STYLE_LIST, "Gang stash | Painkillers", "Withdraw\nDeposit", "Select", "Back");
            }
        }
        case DIALOG_GANGSTASHCRAFT:
        {
            format(string, sizeof(string), "Gang stash | Crafting (Your safe has %i materials.)", GangInfo[PlayerData[playerid][pGang]][gMaterials]);
            Dialog_Show(playerid, DIALOG_GANGSTASHCRAFT, DIALOG_STYLE_TABLIST_HEADERS, string, "#\tWeapon\tCost\n1\t9mm\t750 materials\n2\tSdpistol\t1,000 materials\n3\tShotgun\t3,000 materials\n4\tMicro SMG\t4,500 materials\n5\tTec-9\t5,500 materials\n6\tRifle\t10,000 materials", "Craft", "Back");
        }
        case DIALOG_GANGSTASHMATS:
        {
            format(string, sizeof(string), "Withdraw (%i/%i)\nDeposit", GangInfo[PlayerData[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS));
            Dialog_Show(playerid, DIALOG_GANGSTASHMATS, DIALOG_STYLE_LIST, "Gang stash | Materials", string, "Select", "Back");
        }
        case DIALOG_GANGSTASHCASH:
        {
            format(string, sizeof(string), "Withdraw ($%i/$%i)\nDeposit", GangInfo[PlayerData[playerid][pGang]][gCash], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH));
            Dialog_Show(playerid, DIALOG_GANGSTASHCASH, DIALOG_STYLE_LIST, "Gang stash | Cash", string, "Select", "Back");
        }
        case DIALOG_GANGWITHDRAW:
        {
            if (PlayerData[playerid][pSelected] == ITEM_WEED)
            {
                format(string, sizeof(string), "How much weed would you like to withdraw? (The safe contains %i/%i grams.)", GangInfo[PlayerData[playerid][pGang]][gWeed], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_COCAINE)
            {
                format(string, sizeof(string), "How much cocaine would you like to withdraw? (The safe contains %i/%i grams.)", GangInfo[PlayerData[playerid][pGang]][gCocaine], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_HEROIN)
            {
                format(string, sizeof(string), "How much Heroin would you like to withdraw? (The safe contains %i/%i grams.)", GangInfo[PlayerData[playerid][pGang]][gHeroin], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_PAINKILLERS)
            {
                format(string, sizeof(string), "How much painkillers would you like to withdraw? (The safe contains %i/%i.)", GangInfo[PlayerData[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_MATERIALS)
            {
                format(string, sizeof(string), "How much materials would you like to withdraw? (The safe contains %i/%i.)", GangInfo[PlayerData[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_CASH)
            {
                format(string, sizeof(string), "How much cash would you like to withdraw? (The safe contains $%i/$%i.)", GangInfo[PlayerData[playerid][pGang]][gCash], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH));
            }
            Dialog_Show(playerid, DIALOG_GANGWITHDRAW, DIALOG_STYLE_INPUT, "Gang stash | Withdraw", string, "Submit", "Back");
        }
        case DIALOG_GANGDEPOSIT:
        {
            if (PlayerData[playerid][pSelected] == ITEM_WEED)
            {
                format(string, sizeof(string), "How much weed would you like to deposit? (The safe contains %i/%i grams.)", GangInfo[PlayerData[playerid][pGang]][gWeed], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_COCAINE)
            {
                format(string, sizeof(string), "How much cocaine would you like to deposit? (The safe contains %i/%i grams.)", GangInfo[PlayerData[playerid][pGang]][gCocaine], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_HEROIN)
            {
                format(string, sizeof(string), "How much Heroin would you like to deposit? (The safe contains %i/%i grams.)", GangInfo[PlayerData[playerid][pGang]][gHeroin], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_PAINKILLERS)
            {
                format(string, sizeof(string), "How much painkillers would you like to deposit? (The safe contains %i/%i.)", GangInfo[PlayerData[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_MATERIALS)
            {
                format(string, sizeof(string), "How much materials would you like to deposit? (The safe contains %i/%i.)", GangInfo[PlayerData[playerid][pGang]][gMaterials], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS));
            }
            else if (PlayerData[playerid][pSelected] == ITEM_CASH)
            {
                format(string, sizeof(string), "How much cash would you like to deposit? (The safe contains $%i/$%i.)", GangInfo[PlayerData[playerid][pGang]][gCash], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH));
            }
            Dialog_Show(playerid, DIALOG_GANGDEPOSIT, DIALOG_STYLE_INPUT, "Gang stash | Deposit", string, "Submit", "Back");
        }
        case DIALOG_GANGARMSPRICES:
        {

            format(string, sizeof(string), "#\tWeapon\tPrice\tCost\n1\tMicro Uzi\t$%i\t500 materials\n2\tTec-9\t$%i\t500 materials\n3\tMP5\t$%i\t1000 materials\n4\tDesert Eagle\t$%i\t2000 materials\n5\tMolotov\t$%i\t5000 materials\n6\tAK-47\t$%i\t3000 materials\n7\tM4\t$%i\t4000 materials\n8\tSniper\t$%i\t6500 materials\n9\tSawnoff Shotgun\t$%i\t3000 materials",
            GangInfo[PlayerData[playerid][pGang]][gArmsPrices][0], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][1], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][2], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][3], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][4], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][5], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][6], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][7], GangInfo[PlayerData[playerid][pGang]][gArmsPrices][8]);
            Dialog_Show(playerid, DIALOG_GANGARMSPRICES, DIALOG_STYLE_TABLIST_HEADERS, "Choose a weapon price to edit.", string, "Change", "Back");
        }
        case DIALOG_GANGARMSDEALER:
        {
            Dialog_Show(playerid, DIALOG_GANGARMSDEALER, DIALOG_STYLE_LIST, "Arms dealer", "Buy Guns\nEdit", "Select", "Cancel");
        }
        case DIALOG_GANGARMSWEAPONS:
        {
            new
                title[48];

            format(title, sizeof(title), "Gang arms dealer (Materials available: %i.)", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials]);

            format(string, sizeof(string), "#\tWeapon\tPrice\tCost\n1\tMicro Uzi\t$%i\t500 materials\n2\tTec-9\t$%i\t500 materials\n3\tMP5\t$%i\t1000 materials\n4\tDesert Eagle\t$%i\t2000 materials\n5\tMolotov\t$%i\t5000 materials\n6\tAK-47\t$%i\t3000 materials\n7\tM4\t$%i\t4000 materials\n8\tSniper\t$%i\t6500 materials\n9\tSawnoff Shotgun\t$%i\t3000 materials",
                GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][0], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][1], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][2], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][3], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][4], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][5], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][6], GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][7],
                GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][8]);
            Dialog_Show(playerid, DIALOG_GANGARMSWEAPONS, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Buy", "Back");
        }
        case DIALOG_GANGARMSEDIT:
        {
            format(string, sizeof(string), "Arms dealer (Materials available: %i.)", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials]);
            Dialog_Show(playerid, DIALOG_GANGARMSEDIT, DIALOG_STYLE_LIST, string, "Edit prices\nDeposit mats\nWithdraw mats", "Select", "Back");
        }
        case GangStashDepositMats:
        {
            format(string, sizeof(string), "How much materials would you like to deposit? (This arms dealer contains %i materials.)", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials]);
            Dialog_Show(playerid, GangStashDepositMats, DIALOG_STYLE_INPUT, "Arms dealer | Deposit", string, "Submit", "Back");
        }
        case GangStashWithdrawMats:
        {
            format(string, sizeof(string), "How much materials would you like to withdraw? (This arms dealer contains %i materials.)", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials]);
            Dialog_Show(playerid, GangStashWithdrawMats, DIALOG_STYLE_INPUT, "Arms dealer | Withdraw", string, "Submit", "Back");
        }
        case DIALOG_LOCATE:
        {
            Dialog_Show(playerid, DIALOG_LOCATE, DIALOG_STYLE_LIST, "GPS - Select Destination", "Job Locations\nNearest Businesses\nGeneral Locations\nFind Turfs\nMore Locations\nMy Houses\nMy Businesses", "Select", "Close");
        }
        case DIALOG_FACTIONEQUIPMENT:
        {
            new lockerid = GetNearbyLocker(playerid);
            string = "Weapon\tPrice\n";
            if (LockerInfo[lockerid][locKevlar][0])      { format(string, sizeof(string), "%sKevlar Vest\t$%i\n", string, LockerInfo[lockerid][locKevlar][1]); }
            if (LockerInfo[lockerid][locMedKit][0])      { format(string, sizeof(string), "%sMedkit\t$%i\n", string, LockerInfo[lockerid][locMedKit][1]); }
            if (LockerInfo[lockerid][locNitestick][0])   { format(string, sizeof(string), "%sNitestick\t$%i\n", string, LockerInfo[lockerid][locNitestick][1]); }
            if (LockerInfo[lockerid][locMace][0])        { format(string, sizeof(string), "%sMace\t$%i\n", string, LockerInfo[lockerid][locMace][1]); }
            if (LockerInfo[lockerid][locDeagle][0])      { format(string, sizeof(string), "%sDeagle\t$%i\n", string, LockerInfo[lockerid][locDeagle][1]); }
            if (LockerInfo[lockerid][locShotgun][0])     { format(string, sizeof(string), "%sShotgun\t$%i\n", string, LockerInfo[lockerid][locShotgun][1]); }
            if (LockerInfo[lockerid][locMP5][0])         { format(string, sizeof(string), "%sMP5\t$%i\n", string, LockerInfo[lockerid][locMP5][1]); }
            if (LockerInfo[lockerid][locM4][0])          { format(string, sizeof(string), "%sM4\t$%i\n", string, LockerInfo[lockerid][locM4][1]); }
            if (LockerInfo[lockerid][locSpas12][0])      { format(string, sizeof(string), "%sSPAS-12\t$%i\n", string, LockerInfo[lockerid][locSpas12][1]); }
            if (LockerInfo[lockerid][locSniper][0])      { format(string, sizeof(string), "%sSniper\t$%i\n", string, LockerInfo[lockerid][locSniper][1]); }
            if (LockerInfo[lockerid][locCamera][0])      { format(string, sizeof(string), "%sCamera\t$%i\n", string, LockerInfo[lockerid][locCamera][1]); }
            if (LockerInfo[lockerid][locFireExt][0])     { format(string, sizeof(string), "%sFire Extinguisher\t$%i\n", string, LockerInfo[lockerid][locFireExt][1]); }
            if (LockerInfo[lockerid][locPainKillers][0]) { format(string, sizeof(string), "%sPainkillers\t$%i\n", string, LockerInfo[lockerid][locPainKillers][1]); }
            Dialog_Show(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_TABLIST_HEADERS, "Locker", string, "Select", "Cancel");
        }
        case DIALOG_DELETEOBJECT:
        {
            format(string, sizeof(string), "Object %i selected\n{FFFFFF}Would you really like to {FF0000}delete{FFFFFF} it?", PlayerData[playerid][pSelected]);
            Dialog_Show(playerid, DIALOG_DELETEOBJECT, DIALOG_STYLE_MSGBOX, "Delete Mode - Dynamic Object Selected", string, "Yes", "No");
        }
        case DIALOG_PAINTBALL:
        {
            string =  "Name\tType\tCurrent Players\n";
            format(string, sizeof(string), "%sDeathmatch Arena\tFFA\t%i\n", string, GetArenaPlayers(1));
            format(string, sizeof(string), "%sTeam Deathmatch Arena\tTDM\t%i\n", string, GetArenaPlayers(2));
            format(string, sizeof(string), "%sDeagle Arena\t1Shot\t%i\n", string, GetArenaPlayers(3));
            format(string, sizeof(string), "%sSniper Arena\t1Shot\t%i\n", string, GetArenaPlayers(4));
            Dialog_Show(playerid, DIALOG_PAINTBALL, DIALOG_STYLE_TABLIST_HEADERS, "Paintball", string, "Select", "Cancel");
        }

    }

    return 1;
}
