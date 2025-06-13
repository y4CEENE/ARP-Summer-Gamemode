#include <YSI\y_hooks>

static InventoryDrop[MAX_PLAYERS];

DisplayInventory(playerid, targetid = INVALID_PLAYER_ID)
{
    if (targetid == INVALID_PLAYER_ID)
    {
        targetid = playerid;
    }

    SendClientMessageEx(targetid, COLOR_DARKGREEN, "___________________________________________________________________________________");

    SendClientMessageEx(targetid, COLOR_WHITE, "{008080}Inventory of: {FFFFFF}%s {008080}| Time: {FFFFFF}%s", GetPlayerNameEx(playerid), GetDateTime(0));
    SendClientMessageEx(targetid, COLOR_WHITE, "Weed: %i/%ig | Cocaine: %i/%ig | Heroin: %i/%ig | Painkillers: %i/%i | Seeds: %i/%i",
        PlayerData[playerid][pWeed],        GetPlayerCapacity(playerid, CAPACITY_WEED),
        PlayerData[playerid][pCocaine],     GetPlayerCapacity(playerid, CAPACITY_COCAINE),
        PlayerData[playerid][pHeroin],        GetPlayerCapacity(playerid, CAPACITY_HEROIN),
        PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS),
        PlayerData[playerid][pSeeds],       GetPlayerCapacity(playerid, CAPACITY_SEEDS));
    SendClientMessageEx(targetid, COLOR_WHITE, "{008080}Materials: %s/%s | Chemicals: %i/%ig | Muriatic acid: %i/10 | Baking soda: %i/3",
        FormatNumber(PlayerData[playerid][pMaterials]), FormatNumber(GetPlayerCapacity(playerid, CAPACITY_MATERIALS)),
        PlayerData[playerid][pChemicals], GetPlayerCapacity(playerid, CAPACITY_CHEMICALS),
        PlayerData[playerid][pMuriaticAcid], PlayerData[playerid][pBakingSoda]);
    SendClientMessageEx(targetid, COLOR_WHITE, "Fish bait: %i/20 | Fishing rod: %s | Boombox: %s | MP3 player: %s | Phonebook: %s",
        PlayerData[playerid][pFishingBait],
        (PlayerData[playerid][pFishingRod]) ? ("Yes") : ("No"),
        (PlayerData[playerid][pBoombox   ]) ? ("Yes") : ("No"),
        (PlayerData[playerid][pMP3Player ]) ? ("Yes") : ("No"),
        (HasPhonebook(playerid)           ) ? ("Yes") : ("No"));
    SendClientMessageEx(targetid, COLOR_WHITE, "{008080}Drivers license: %s | Cigars: %s | Spraycans: %i/20 | Bombs: %i/3",
        (PlayerHasLicense(playerid, PlayerLicense_Car)) ? ("Yes") : ("No"),
        FormatNumber(PlayerData[playerid][pCigars]),
        PlayerData[playerid][pSpraycans],
        PlayerData[playerid][pBombs]);
    SendClientMessageEx(targetid, COLOR_WHITE, "First aid kits: %i/20 | Private Radio: %s | Mobile phone: %s | Police scanner: %s",
        PlayerData[playerid][pFirstAid],
        (PlayerData[playerid][pPrivateRadio ]) ? ("Yes") : ("No"),
        (PlayerData[playerid][pPhone        ]) ? ("Yes") : ("No"),
        (PlayerData[playerid][pPoliceScanner]) ? ("Yes") : ("No"));
    SendClientMessageEx(targetid, COLOR_WHITE, "{008080}Gasoline: %i/%iL | Bodykits: %i/10 | Rope: %i/10 | Watch: %s | GPS: %s",
        PlayerData[playerid][pGasCan], GetPlayerCapacity(playerid, CAPACITY_GASCAN),
        PlayerData[playerid][pBodykits],
        PlayerData[playerid][pRope],
        (PlayerData[playerid][pWatch]) ? ("Yes") : ("No"),
        (PlayerData[playerid][pGPS  ]) ? ("Yes") : ("No"));
    SendClientMessageEx(targetid, COLOR_WHITE, "Diamond: %s | Skates: %s | Crowbar: %i/5",
        FormatNumber(PlayerData[playerid][pDiamonds]),
        (PlayerData[playerid][pSkates]) ? ("Yes") : ("No"),
        PlayerData[playerid][pCrowbar]);
    SendClientMessageEx(targetid, COLOR_DARKGREEN, "___________________________________________________________________________________");
    return 1;
}

CMD:oldinv(playerid, params[])
{
    DisplayInventory(playerid);
    return 1;
}

CMD:guninv(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ My Weapons _____");

    for (new i = 0; i < 13; i ++)
    {
        if (PlayerData[playerid][pWeapons][i] > 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s", PlayerData[playerid][pWeapons][i], GetWeaponNameEx(PlayerData[playerid][pWeapons][i]));
        }
    }

    return 1;
}

CMD:drop(playerid, params[])
{
    //TODO: Drop specific amount of items
    new content[256];
    content="Item\tQty\nWeapons\t ";
    if (PlayerData[playerid][pMaterials] > 0)
        format(content, sizeof(content), "%s\nMaterials\t%s", content, FormatNumber(PlayerData[playerid][pMaterials]));
    if (PlayerData[playerid][pSeeds] > 0)
        format(content, sizeof(content), "%s\nSeeds\t%s", content, FormatNumber(PlayerData[playerid][pSeeds]));
    if (PlayerData[playerid][pWeed] > 0)
        format(content, sizeof(content), "%s\nWeed\t%s", content, FormatNumber(PlayerData[playerid][pWeed]));
    if (PlayerData[playerid][pCocaine] > 0)
        format(content, sizeof(content), "%s\nCocaine\t%s", content, FormatNumber(PlayerData[playerid][pCocaine]));
    if (PlayerData[playerid][pChemicals] > 0)
        format(content, sizeof(content), "%s\nChemicals\t%s", content, FormatNumber(PlayerData[playerid][pChemicals]));
    if (PlayerData[playerid][pHeroin] > 0)
        format(content, sizeof(content), "%s\nHeroin\t%s", content, FormatNumber(PlayerData[playerid][pHeroin]));
    if (PlayerData[playerid][pPainkillers] > 0)
        format(content, sizeof(content), "%s\nPainkillers\t%s", content, FormatNumber(PlayerData[playerid][pPainkillers]));
    if (PlayerData[playerid][pCigars] > 0)
        format(content, sizeof(content), "%s\nCigars\t%s", content, FormatNumber(PlayerData[playerid][pCigars]));
    if (PlayerData[playerid][pSpraycans] > 0)
        format(content, sizeof(content), "%s\nSpraycans\t%s", content, FormatNumber(PlayerData[playerid][pSpraycans]));
    if (PlayerHasLicense(playerid, PlayerLicense_Car))
        format(content, sizeof(content), "%s\nCar license\t ", content);
    if (PlayerHasLicense(playerid, PlayerLicense_Gun))
        format(content, sizeof(content), "%s\nGun license\t ", content);

    Dialog_Show(playerid, DropItem, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Select item to drop", content, "Drop", "Cancel");
    return 1;
}

Dialog:DropItem(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new params[][12] = {
        "Weapons", "Materials", "Seeds", "Weed", "Cocaine", "Chemicals", "Heroin",
        "Painkillers", "Cigars", "Spraycans", "Car license", "Gun license"
    };
    for (new idx = 0; idx < sizeof(params); idx++)
    {
        if (!strcmp(params[idx], inputtext, true))
        {
            InventoryDrop[playerid] = idx;
            Dialog_Show(playerid, DropItemConfirmation, DIALOG_STYLE_MSGBOX, "{FFFFFF}Dropping item", "Are you sure you want to drop your %s?", "Drop", "Cancel", inputtext);
            return 1;
        }
    }
    return 1;
}

Dialog:DropItemConfirmation(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    switch (InventoryDrop[playerid])
    {
        case 0: // Weapons
        {
            ResetPlayerWeaponsEx(playerid);
            ShowActionBubble(playerid, "* %s throws away their weapons.", GetRPName(playerid));
        }
        case 1: // Materials
        {
            PlayerData[playerid][pMaterials] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET materials = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their materials.", GetRPName(playerid));
        }
        case 2: // Weed
        {
            PlayerData[playerid][pWeed] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET weed = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their weed.", GetRPName(playerid));
        }
        case 3: // Cocaine
        {
            PlayerData[playerid][pCocaine] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET cocaine = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their cocaine.", GetRPName(playerid));
        }
        case 4: // Heroin
        {
            PlayerData[playerid][pHeroin] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET heroin = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their Heroin.", GetRPName(playerid));
        }
        case 5: // Painkillers
        {
            PlayerData[playerid][pPainkillers] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET painkillers = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their painkillers.", GetRPName(playerid));
        }
        case 6: // Cigars
        {
            PlayerData[playerid][pCigars] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET cigars = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their cigars.", GetRPName(playerid));
        }
        case 7: // Spraycans
        {
            PlayerData[playerid][pSpraycans] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET spraycans = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their spraycanss.", GetRPName(playerid));
        }
        case 8: // Seeds
        {
            PlayerData[playerid][pSeeds] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET seeds = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their seeds.", GetRPName(playerid));
        }
        case 9: // Chemicals
        {
            PlayerData[playerid][pChemicals] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET chemicals = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            ShowActionBubble(playerid, "* %s throws away their chems.", GetRPName(playerid));
        }
        case 10: // Carlicense
        {
            RemovePlayerLicense(playerid, PlayerLicense_Car);
            ShowActionBubble(playerid, "* %s rips up their drivers license.", GetRPName(playerid));
        }
        case 11: // Gunlicense
        {
            RemovePlayerLicense(playerid, PlayerLicense_Gun);
            ShowActionBubble(playerid, "* %s rips up their gun license.", GetRPName(playerid));
        }
    }
    return 1;
}

// New Inv

#define MAX_INVENTORY               20

// [ INVENTORY BY Saad & Tooba ] //
new Text:INVNAME[6];
new Text:INVINFO[11];
new Text:NAMETD[MAX_INVENTORY];
new Text:INDEXTD[MAX_INVENTORY];
new Text:MODELTD[MAX_INVENTORY];
new Text:AMOUNTTD[MAX_INVENTORY];
new BukaInven[MAX_PLAYERS];

enum inventoryData
{
	invExists,
	invItem[32 char],
	invModel,
	invAmount,
	invTotalQuantity
};

new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
enum e_InventoryItems
{
	e_InventoryItem[32], //Nama item
	e_InventoryModel, //Object item
	e_InventoryTotal
};

//Bach Katzid item Walakin khas Saad & Tooba i wariwk kfx
new const g_aInventoryItems[][e_InventoryItems] =
{
	{"Money", 1212, 1},
	//{"Dirty Cash", 1580, 4},
	{"Phone", 19513, 4},
	{"Radio", 330, 4},
	//{"Food", 2703, 4},
	//{"Drink", 2647, 4},
	//{"Mask", 18914, 2},
	{"Laptop", 19893, 4},
	{"Ammo", 2061, 4},
	{"GPS", 18874, 2},
	//{"Medkit", 11748, 2},
	//{"Repair Kit", 920, 2},
	{"Robbery", 2680, 2},
	{"Cocaine", 1575, 1},
	{"Weed", 702, 1},
	{"Heroin", 1579, 1},
	{"Bocket", 1672, 1},
	{"Iron", 2491, 1},
	{"Rubber", 1626, 1},
	{"Metal", 3071, 1},
	{"Plastic", 19587, 1},
	{"Materials", 1448, 1}
};

hook OnGameModeInit()
{
    INVNAME[0] = TextDrawCreate(118.000000, 96.000000, "LD_SPAC:white");
	TextDrawFont(INVNAME[0], 4);
	TextDrawLetterSize(INVNAME[0], 0.600000, 2.000000);
	TextDrawTextSize(INVNAME[0], 213.000000, 253.000000);
	TextDrawSetOutline(INVNAME[0], 1);
	TextDrawSetShadow(INVNAME[0], 0);
	TextDrawAlignment(INVNAME[0], 1);
	TextDrawColor(INVNAME[0], 690964479);
	TextDrawBackgroundColor(INVNAME[0], 255);
	TextDrawBoxColor(INVNAME[0], 50);
	TextDrawUseBox(INVNAME[0], 1);
	TextDrawSetProportional(INVNAME[0], 1);
	TextDrawSetSelectable(INVNAME[0], 0);

	INVNAME[1] = TextDrawCreate(125.000000, 115.000000, "LD_SPAC:white");
	TextDrawFont(INVNAME[1], 4);
	TextDrawLetterSize(INVNAME[1], 0.600000, 2.000000);
	TextDrawTextSize(INVNAME[1], 199.000000, 3.000000);
	TextDrawSetOutline(INVNAME[1], 1);
	TextDrawSetShadow(INVNAME[1], 0);
	TextDrawAlignment(INVNAME[1], 1);
	TextDrawColor(INVNAME[1], 255);
	TextDrawBackgroundColor(INVNAME[1], 255);
	TextDrawBoxColor(INVNAME[1], 50);
	TextDrawUseBox(INVNAME[1], 1);
	TextDrawSetProportional(INVNAME[1], 1);
	TextDrawSetSelectable(INVNAME[1], 0);

	INVNAME[2] = TextDrawCreate(126.000000, 115.000000, "LD_SPAC:white");
	TextDrawFont(INVNAME[2], 4);
	TextDrawLetterSize(INVNAME[2], 0.600000, 2.000000);
	TextDrawTextSize(INVNAME[2], 165.000000, 3.000000);
	TextDrawSetOutline(INVNAME[2], 1);
	TextDrawSetShadow(INVNAME[2], 0);
	TextDrawAlignment(INVNAME[2], 1);
	TextDrawColor(INVNAME[2], -16776961);
	TextDrawBackgroundColor(INVNAME[2], 255);
	TextDrawBoxColor(INVNAME[2], 50);
	TextDrawUseBox(INVNAME[2], 1);
	TextDrawSetProportional(INVNAME[2], 1);
	TextDrawSetSelectable(INVNAME[2], 0);

	INVNAME[3] = TextDrawCreate(126.000000, 105.000000, "Mr_Tooba");
	TextDrawFont(INVNAME[3], 1);
	TextDrawLetterSize(INVNAME[3], 0.140000, 0.898000);
	TextDrawTextSize(INVNAME[3], 400.000000, 17.000000);
	TextDrawSetOutline(INVNAME[3], 0);
	TextDrawSetShadow(INVNAME[3], 0);
	TextDrawAlignment(INVNAME[3], 1);
	TextDrawColor(INVNAME[3], -1);
	TextDrawBackgroundColor(INVNAME[3], 255);
	TextDrawBoxColor(INVNAME[3], 50);
	TextDrawUseBox(INVNAME[3], 0);
	TextDrawSetProportional(INVNAME[3], 1);
	TextDrawSetSelectable(INVNAME[3], 0);

	INVNAME[4] = TextDrawCreate(324.000000, 105.000000, "100/300");
	TextDrawFont(INVNAME[4], 1);
	TextDrawLetterSize(INVNAME[4], 0.140000, 0.699000);
	TextDrawTextSize(INVNAME[4], 400.000000, 17.000000);
	TextDrawSetOutline(INVNAME[4], 0);
	TextDrawSetShadow(INVNAME[4], 0);
	TextDrawAlignment(INVNAME[4], 3);
	TextDrawColor(INVNAME[4], -1);
	TextDrawBackgroundColor(INVNAME[4], 255);
	TextDrawBoxColor(INVNAME[4], 50);
	TextDrawUseBox(INVNAME[4], 0);
	TextDrawSetProportional(INVNAME[4], 1);
	TextDrawSetSelectable(INVNAME[4], 0);

	INVNAME[5] = TextDrawCreate(294.000000, 104.000000, "AMP");
	TextDrawFont(INVNAME[5], 1);
	TextDrawLetterSize(INVNAME[5], 0.140000, 0.898000);
	TextDrawTextSize(INVNAME[5], 400.000000, 17.000000);
	TextDrawSetOutline(INVNAME[5], 0);
	TextDrawSetShadow(INVNAME[5], 0);
	TextDrawAlignment(INVNAME[5], 1);
	TextDrawColor(INVNAME[5], -1);
	TextDrawBackgroundColor(INVNAME[5], 255);
	TextDrawBoxColor(INVNAME[5], 50);
	TextDrawUseBox(INVNAME[5], 0);
	TextDrawSetProportional(INVNAME[5], 1);
	TextDrawSetSelectable(INVNAME[5], 0);

	INVINFO[0] = TextDrawCreate(347.000000, 168.000000, "LD_SPAC:white");
	TextDrawFont(INVINFO[0], 4);
	TextDrawLetterSize(INVINFO[0], 0.600000, 2.000000);
	TextDrawTextSize(INVINFO[0], 55.000000, 117.000000);
	TextDrawSetOutline(INVINFO[0], 1);
	TextDrawSetShadow(INVINFO[0], 0);
	TextDrawAlignment(INVINFO[0], 1);
	TextDrawColor(INVINFO[0], 690964479);
	TextDrawBackgroundColor(INVINFO[0], 255);
	TextDrawBoxColor(INVINFO[0], 50);
	TextDrawUseBox(INVINFO[0], 1);
	TextDrawSetProportional(INVINFO[0], 1);
	TextDrawSetSelectable(INVINFO[0], 0);

	INVINFO[1] = TextDrawCreate(352.000000, 174.000000, "LD_SPAC:white");
	TextDrawFont(INVINFO[1], 4);
	TextDrawLetterSize(INVINFO[1], 0.600000, 2.000000);
	TextDrawTextSize(INVINFO[1], 45.000000, 18.000000);
	TextDrawSetOutline(INVINFO[1], 1);
	TextDrawSetShadow(INVINFO[1], 0);
	TextDrawAlignment(INVINFO[1], 1);
	TextDrawColor(INVINFO[1], -16776961);
	TextDrawBackgroundColor(INVINFO[1], 255);
	TextDrawBoxColor(INVINFO[1], 50);
	TextDrawUseBox(INVINFO[1], 1);
	TextDrawSetProportional(INVINFO[1], 1);
	TextDrawSetSelectable(INVINFO[1], 1);

	INVINFO[2] = TextDrawCreate(352.000000, 195.000000, "LD_SPAC:white");
	TextDrawFont(INVINFO[2], 4);
	TextDrawLetterSize(INVINFO[2], 0.600000, 2.000000);
	TextDrawTextSize(INVINFO[2], 45.000000, 18.000000);
	TextDrawSetOutline(INVINFO[2], 1);
	TextDrawSetShadow(INVINFO[2], 0);
	TextDrawAlignment(INVINFO[2], 1);
	TextDrawColor(INVINFO[2], -16776961);
	TextDrawBackgroundColor(INVINFO[2], 255);
	TextDrawBoxColor(INVINFO[2], 50);
	TextDrawUseBox(INVINFO[2], 1);
	TextDrawSetProportional(INVINFO[2], 1);
	TextDrawSetSelectable(INVINFO[2], 1);

	INVINFO[3] = TextDrawCreate(352.000000, 216.000000, "LD_SPAC:white");
	TextDrawFont(INVINFO[3], 4);
	TextDrawLetterSize(INVINFO[3], 0.600000, 2.000000);
	TextDrawTextSize(INVINFO[3], 45.000000, 18.000000);
	TextDrawSetOutline(INVINFO[3], 1);
	TextDrawSetShadow(INVINFO[3], 0);
	TextDrawAlignment(INVINFO[3], 1);
	TextDrawColor(INVINFO[3], -16776961);
	TextDrawBackgroundColor(INVINFO[3], 255);
	TextDrawBoxColor(INVINFO[3], 50);
	TextDrawUseBox(INVINFO[3], 1);
	TextDrawSetProportional(INVINFO[3], 1);
	TextDrawSetSelectable(INVINFO[3], 1);

	INVINFO[4] = TextDrawCreate(352.000000, 237.000000, "LD_SPAC:white");
	TextDrawFont(INVINFO[4], 4);
	TextDrawLetterSize(INVINFO[4], 0.600000, 2.000000);
	TextDrawTextSize(INVINFO[4], 45.000000, 18.000000);
	TextDrawSetOutline(INVINFO[4], 1);
	TextDrawSetShadow(INVINFO[4], 0);
	TextDrawAlignment(INVINFO[4], 1);
	TextDrawColor(INVINFO[4], -16776961);
	TextDrawBackgroundColor(INVINFO[4], 255);
	TextDrawBoxColor(INVINFO[4], 50);
	TextDrawUseBox(INVINFO[4], 1);
	TextDrawSetProportional(INVINFO[4], 1);
	TextDrawSetSelectable(INVINFO[4], 1);

	INVINFO[5] = TextDrawCreate(352.000000, 258.000000, "LD_SPAC:white");
	TextDrawFont(INVINFO[5], 4);
	TextDrawLetterSize(INVINFO[5], 0.600000, 2.000000);
	TextDrawTextSize(INVINFO[5], 45.000000, 18.000000);
	TextDrawSetOutline(INVINFO[5], 1);
	TextDrawSetShadow(INVINFO[5], 0);
	TextDrawAlignment(INVINFO[5], 1);
	TextDrawColor(INVINFO[5], -16776961);
	TextDrawBackgroundColor(INVINFO[5], 255);
	TextDrawBoxColor(INVINFO[5], 50);
	TextDrawUseBox(INVINFO[5], 1);
	TextDrawSetProportional(INVINFO[5], 1);
	TextDrawSetSelectable(INVINFO[5], 1);

	INVINFO[6] = TextDrawCreate(375.000000, 179.000000, "Amount");
	TextDrawFont(INVINFO[6], 1);
	TextDrawLetterSize(INVINFO[6], 0.150000, 0.898000);
	TextDrawTextSize(INVINFO[6], 400.000000, 17.000000);
	TextDrawSetOutline(INVINFO[6], 0);
	TextDrawSetShadow(INVINFO[6], 0);
	TextDrawAlignment(INVINFO[6], 2);
	TextDrawColor(INVINFO[6], -1);
	TextDrawBackgroundColor(INVINFO[6], 255);
	TextDrawBoxColor(INVINFO[6], 50);
	TextDrawUseBox(INVINFO[6], 0);
	TextDrawSetProportional(INVINFO[6], 1);
	TextDrawSetSelectable(INVINFO[6], 0);

	INVINFO[7] = TextDrawCreate(375.000000, 199.000000, "Use");
	TextDrawFont(INVINFO[7], 1);
	TextDrawLetterSize(INVINFO[7], 0.150000, 0.898000);
	TextDrawTextSize(INVINFO[7], 400.000000, 17.000000);
	TextDrawSetOutline(INVINFO[7], 0);
	TextDrawSetShadow(INVINFO[7], 0);
	TextDrawAlignment(INVINFO[7], 2);
	TextDrawColor(INVINFO[7], -1);
	TextDrawBackgroundColor(INVINFO[7], 255);
	TextDrawBoxColor(INVINFO[7], 50);
	TextDrawUseBox(INVINFO[7], 0);
	TextDrawSetProportional(INVINFO[7], 1);
	TextDrawSetSelectable(INVINFO[7], 0);

	INVINFO[8] = TextDrawCreate(375.000000, 220.000000, "Give");
	TextDrawFont(INVINFO[8], 1);
	TextDrawLetterSize(INVINFO[8], 0.150000, 0.898000);
	TextDrawTextSize(INVINFO[8], 400.000000, 17.000000);
	TextDrawSetOutline(INVINFO[8], 0);
	TextDrawSetShadow(INVINFO[8], 0);
	TextDrawAlignment(INVINFO[8], 2);
	TextDrawColor(INVINFO[8], -1);
	TextDrawBackgroundColor(INVINFO[8], 255);
	TextDrawBoxColor(INVINFO[8], 50);
	TextDrawUseBox(INVINFO[8], 0);
	TextDrawSetProportional(INVINFO[8], 1);
	TextDrawSetSelectable(INVINFO[8], 0);

	INVINFO[9] = TextDrawCreate(375.000000, 242.000000, "Drop");
	TextDrawFont(INVINFO[9], 1);
	TextDrawLetterSize(INVINFO[9], 0.150000, 0.898000);
	TextDrawTextSize(INVINFO[9], 400.000000, 17.000000);
	TextDrawSetOutline(INVINFO[9], 0);
	TextDrawSetShadow(INVINFO[9], 0);
	TextDrawAlignment(INVINFO[9], 2);
	TextDrawColor(INVINFO[9], -1);
	TextDrawBackgroundColor(INVINFO[9], 255);
	TextDrawBoxColor(INVINFO[9], 50);
	TextDrawUseBox(INVINFO[9], 0);
	TextDrawSetProportional(INVINFO[9], 1);
	TextDrawSetSelectable(INVINFO[9], 0);

	INVINFO[10] = TextDrawCreate(375.000000, 263.000000, "Exit");
	TextDrawFont(INVINFO[10], 1);
	TextDrawLetterSize(INVINFO[10], 0.150000, 0.898000);
	TextDrawTextSize(INVINFO[10], 400.000000, 17.000000);
	TextDrawSetOutline(INVINFO[10], 0);
	TextDrawSetShadow(INVINFO[10], 0);
	TextDrawAlignment(INVINFO[10], 2);
	TextDrawColor(INVINFO[10], -1);
	TextDrawBackgroundColor(INVINFO[10], 255);
	TextDrawBoxColor(INVINFO[10], 50);
	TextDrawUseBox(INVINFO[10], 0);
	TextDrawSetProportional(INVINFO[10], 1);
	TextDrawSetSelectable(INVINFO[10], 0);

	INDEXTD[0] = TextDrawCreate(125.000000, 120.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[0], 4);
	TextDrawLetterSize(INDEXTD[0], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[0], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[0], 3);
	TextDrawSetShadow(INDEXTD[0], 3);
	TextDrawAlignment(INDEXTD[0], 1);
	TextDrawColor(INDEXTD[0], 859394047);
	TextDrawBackgroundColor(INDEXTD[0], 255);
	TextDrawBoxColor(INDEXTD[0], 50);
	TextDrawUseBox(INDEXTD[0], 0);
	TextDrawSetProportional(INDEXTD[0], 1);
	TextDrawSetSelectable(INDEXTD[0], 0);

	INDEXTD[1] = TextDrawCreate(165.000000, 120.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[1], 4);
	TextDrawLetterSize(INDEXTD[1], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[1], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[1], 3);
	TextDrawSetShadow(INDEXTD[1], 3);
	TextDrawAlignment(INDEXTD[1], 1);
	TextDrawColor(INDEXTD[1], 859394047);
	TextDrawBackgroundColor(INDEXTD[1], 255);
	TextDrawBoxColor(INDEXTD[1], 50);
	TextDrawUseBox(INDEXTD[1], 0);
	TextDrawSetProportional(INDEXTD[1], 1);
	TextDrawSetSelectable(INDEXTD[1], 0);

	INDEXTD[2] = TextDrawCreate(205.000000, 120.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[2], 4);
	TextDrawLetterSize(INDEXTD[2], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[2], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[2], 3);
	TextDrawSetShadow(INDEXTD[2], 3);
	TextDrawAlignment(INDEXTD[2], 1);
	TextDrawColor(INDEXTD[2], 859394047);
	TextDrawBackgroundColor(INDEXTD[2], 255);
	TextDrawBoxColor(INDEXTD[2], 50);
	TextDrawUseBox(INDEXTD[2], 0);
	TextDrawSetProportional(INDEXTD[2], 1);
	TextDrawSetSelectable(INDEXTD[2], 0);

	INDEXTD[3] = TextDrawCreate(245.000000, 120.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[3], 4);
	TextDrawLetterSize(INDEXTD[3], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[3], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[3], 3);
	TextDrawSetShadow(INDEXTD[3], 3);
	TextDrawAlignment(INDEXTD[3], 1);
	TextDrawColor(INDEXTD[3], 859394047);
	TextDrawBackgroundColor(INDEXTD[3], 255);
	TextDrawBoxColor(INDEXTD[3], 50);
	TextDrawUseBox(INDEXTD[3], 0);
	TextDrawSetProportional(INDEXTD[3], 1);
	TextDrawSetSelectable(INDEXTD[3], 0);

	INDEXTD[4] = TextDrawCreate(285.000000, 120.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[4], 4);
	TextDrawLetterSize(INDEXTD[4], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[4], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[4], 3);
	TextDrawSetShadow(INDEXTD[4], 3);
	TextDrawAlignment(INDEXTD[4], 1);
	TextDrawColor(INDEXTD[4], 859394047);
	TextDrawBackgroundColor(INDEXTD[4], 255);
	TextDrawBoxColor(INDEXTD[4], 50);
	TextDrawUseBox(INDEXTD[4], 0);
	TextDrawSetProportional(INDEXTD[4], 1);
	TextDrawSetSelectable(INDEXTD[4], 0);

	INDEXTD[5] = TextDrawCreate(125.000000, 176.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[5], 4);
	TextDrawLetterSize(INDEXTD[5], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[5], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[5], 3);
	TextDrawSetShadow(INDEXTD[5], 3);
	TextDrawAlignment(INDEXTD[5], 1);
	TextDrawColor(INDEXTD[5], 859394047);
	TextDrawBackgroundColor(INDEXTD[5], 255);
	TextDrawBoxColor(INDEXTD[5], 50);
	TextDrawUseBox(INDEXTD[5], 0);
	TextDrawSetProportional(INDEXTD[5], 1);
	TextDrawSetSelectable(INDEXTD[5], 0);

	INDEXTD[6] = TextDrawCreate(165.000000, 176.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[6], 4);
	TextDrawLetterSize(INDEXTD[6], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[6], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[6], 3);
	TextDrawSetShadow(INDEXTD[6], 3);
	TextDrawAlignment(INDEXTD[6], 1);
	TextDrawColor(INDEXTD[6], 859394047);
	TextDrawBackgroundColor(INDEXTD[6], 255);
	TextDrawBoxColor(INDEXTD[6], 50);
	TextDrawUseBox(INDEXTD[6], 0);
	TextDrawSetProportional(INDEXTD[6], 1);
	TextDrawSetSelectable(INDEXTD[6], 0);

	INDEXTD[7] = TextDrawCreate(205.000000, 176.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[7], 4);
	TextDrawLetterSize(INDEXTD[7], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[7], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[7], 3);
	TextDrawSetShadow(INDEXTD[7], 3);
	TextDrawAlignment(INDEXTD[7], 1);
	TextDrawColor(INDEXTD[7], 859394047);
	TextDrawBackgroundColor(INDEXTD[7], 255);
	TextDrawBoxColor(INDEXTD[7], 50);
	TextDrawUseBox(INDEXTD[7], 0);
	TextDrawSetProportional(INDEXTD[7], 1);
	TextDrawSetSelectable(INDEXTD[7], 0);

	INDEXTD[8] = TextDrawCreate(245.000000, 176.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[8], 4);
	TextDrawLetterSize(INDEXTD[8], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[8], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[8], 3);
	TextDrawSetShadow(INDEXTD[8], 3);
	TextDrawAlignment(INDEXTD[8], 1);
	TextDrawColor(INDEXTD[8], 859394047);
	TextDrawBackgroundColor(INDEXTD[8], 255);
	TextDrawBoxColor(INDEXTD[8], 50);
	TextDrawUseBox(INDEXTD[8], 0);
	TextDrawSetProportional(INDEXTD[8], 1);
	TextDrawSetSelectable(INDEXTD[8], 0);

	INDEXTD[9] = TextDrawCreate(285.000000, 176.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[9], 4);
	TextDrawLetterSize(INDEXTD[9], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[9], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[9], 3);
	TextDrawSetShadow(INDEXTD[9], 3);
	TextDrawAlignment(INDEXTD[9], 1);
	TextDrawColor(INDEXTD[9], 859394047);
	TextDrawBackgroundColor(INDEXTD[9], 255);
	TextDrawBoxColor(INDEXTD[9], 50);
	TextDrawUseBox(INDEXTD[9], 0);
	TextDrawSetProportional(INDEXTD[9], 1);
	TextDrawSetSelectable(INDEXTD[9], 0);

	INDEXTD[10] = TextDrawCreate(125.000000, 232.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[10], 4);
	TextDrawLetterSize(INDEXTD[10], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[10], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[10], 3);
	TextDrawSetShadow(INDEXTD[10], 3);
	TextDrawAlignment(INDEXTD[10], 1);
	TextDrawColor(INDEXTD[10], 859394047);
	TextDrawBackgroundColor(INDEXTD[10], 255);
	TextDrawBoxColor(INDEXTD[10], 50);
	TextDrawUseBox(INDEXTD[10], 0);
	TextDrawSetProportional(INDEXTD[10], 1);
	TextDrawSetSelectable(INDEXTD[10], 0);

	INDEXTD[11] = TextDrawCreate(165.000000, 232.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[11], 4);
	TextDrawLetterSize(INDEXTD[11], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[11], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[11], 3);
	TextDrawSetShadow(INDEXTD[11], 3);
	TextDrawAlignment(INDEXTD[11], 1);
	TextDrawColor(INDEXTD[11], 859394047);
	TextDrawBackgroundColor(INDEXTD[11], 255);
	TextDrawBoxColor(INDEXTD[11], 50);
	TextDrawUseBox(INDEXTD[11], 0);
	TextDrawSetProportional(INDEXTD[11], 1);
	TextDrawSetSelectable(INDEXTD[11], 0);

	INDEXTD[12] = TextDrawCreate(205.000000, 232.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[12], 4);
	TextDrawLetterSize(INDEXTD[12], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[12], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[12], 3);
	TextDrawSetShadow(INDEXTD[12], 3);
	TextDrawAlignment(INDEXTD[12], 1);
	TextDrawColor(INDEXTD[12], 859394047);
	TextDrawBackgroundColor(INDEXTD[12], 255);
	TextDrawBoxColor(INDEXTD[12], 50);
	TextDrawUseBox(INDEXTD[12], 0);
	TextDrawSetProportional(INDEXTD[12], 1);
	TextDrawSetSelectable(INDEXTD[12], 0);

	INDEXTD[13] = TextDrawCreate(245.000000, 232.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[13], 4);
	TextDrawLetterSize(INDEXTD[13], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[13], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[13], 3);
	TextDrawSetShadow(INDEXTD[13], 3);
	TextDrawAlignment(INDEXTD[13], 1);
	TextDrawColor(INDEXTD[13], 859394047);
	TextDrawBackgroundColor(INDEXTD[13], 255);
	TextDrawBoxColor(INDEXTD[13], 50);
	TextDrawUseBox(INDEXTD[13], 0);
	TextDrawSetProportional(INDEXTD[13], 1);
	TextDrawSetSelectable(INDEXTD[13], 0);

	INDEXTD[14] = TextDrawCreate(285.000000, 232.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[14], 4);
	TextDrawLetterSize(INDEXTD[14], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[14], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[14], 3);
	TextDrawSetShadow(INDEXTD[14], 3);
	TextDrawAlignment(INDEXTD[14], 1);
	TextDrawColor(INDEXTD[14], 859394047);
	TextDrawBackgroundColor(INDEXTD[14], 255);
	TextDrawBoxColor(INDEXTD[14], 50);
	TextDrawUseBox(INDEXTD[14], 0);
	TextDrawSetProportional(INDEXTD[14], 1);
	TextDrawSetSelectable(INDEXTD[14], 0);

	INDEXTD[15] = TextDrawCreate(125.000000, 288.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[15], 4);
	TextDrawLetterSize(INDEXTD[15], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[15], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[15], 3);
	TextDrawSetShadow(INDEXTD[15], 3);
	TextDrawAlignment(INDEXTD[15], 1);
	TextDrawColor(INDEXTD[15], 859394047);
	TextDrawBackgroundColor(INDEXTD[15], 255);
	TextDrawBoxColor(INDEXTD[15], 50);
	TextDrawUseBox(INDEXTD[15], 0);
	TextDrawSetProportional(INDEXTD[15], 1);
	TextDrawSetSelectable(INDEXTD[15], 0);

	INDEXTD[16] = TextDrawCreate(165.000000, 288.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[16], 4);
	TextDrawLetterSize(INDEXTD[16], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[16], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[16], 3);
	TextDrawSetShadow(INDEXTD[16], 3);
	TextDrawAlignment(INDEXTD[16], 1);
	TextDrawColor(INDEXTD[16], 859394047);
	TextDrawBackgroundColor(INDEXTD[16], 255);
	TextDrawBoxColor(INDEXTD[16], 50);
	TextDrawUseBox(INDEXTD[16], 0);
	TextDrawSetProportional(INDEXTD[16], 1);
	TextDrawSetSelectable(INDEXTD[16], 0);

	INDEXTD[17] = TextDrawCreate(205.000000, 288.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[17], 4);
	TextDrawLetterSize(INDEXTD[17], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[17], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[17], 3);
	TextDrawSetShadow(INDEXTD[17], 3);
	TextDrawAlignment(INDEXTD[17], 1);
	TextDrawColor(INDEXTD[17], 859394047);
	TextDrawBackgroundColor(INDEXTD[17], 255);
	TextDrawBoxColor(INDEXTD[17], 50);
	TextDrawUseBox(INDEXTD[17], 0);
	TextDrawSetProportional(INDEXTD[17], 1);
	TextDrawSetSelectable(INDEXTD[17], 0);

	INDEXTD[18] = TextDrawCreate(245.000000, 288.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[18], 4);
	TextDrawLetterSize(INDEXTD[18], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[18], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[18], 3);
	TextDrawSetShadow(INDEXTD[18], 3);
	TextDrawAlignment(INDEXTD[18], 1);
	TextDrawColor(INDEXTD[18], 859394047);
	TextDrawBackgroundColor(INDEXTD[18], 255);
	TextDrawBoxColor(INDEXTD[18], 50);
	TextDrawUseBox(INDEXTD[18], 0);
	TextDrawSetProportional(INDEXTD[18], 1);
	TextDrawSetSelectable(INDEXTD[18], 0);

	INDEXTD[19] = TextDrawCreate(285.000000, 288.000000, "LD_SPAC:white");
	TextDrawFont(INDEXTD[19], 4);
	TextDrawLetterSize(INDEXTD[19], 0.600000, 2.000000);
	TextDrawTextSize(INDEXTD[19], 39.000000, 51.000000);
	TextDrawSetOutline(INDEXTD[19], 3);
	TextDrawSetShadow(INDEXTD[19], 3);
	TextDrawAlignment(INDEXTD[19], 1);
	TextDrawColor(INDEXTD[19], 859394047);
	TextDrawBackgroundColor(INDEXTD[19], 255);
	TextDrawBoxColor(INDEXTD[19], 50);
	TextDrawUseBox(INDEXTD[19], 0);
	TextDrawSetProportional(INDEXTD[19], 1);
	TextDrawSetSelectable(INDEXTD[19], 0);

    NAMETD[0] = TextDrawCreate(128.000000, 121.000000, "Test");
	TextDrawFont(NAMETD[0], 1);
	TextDrawLetterSize(NAMETD[0], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[0], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[0], 0);
	TextDrawSetShadow(NAMETD[0], 0);
	TextDrawAlignment(NAMETD[0], 1);
	TextDrawColor(NAMETD[0], -1);
	TextDrawBackgroundColor(NAMETD[0], 255);
	TextDrawBoxColor(NAMETD[0], 50);
	TextDrawUseBox(NAMETD[0], 0);
	TextDrawSetProportional(NAMETD[0], 1);
	TextDrawSetSelectable(NAMETD[0], 0);

	NAMETD[1] = TextDrawCreate(168.000000, 121.000000, "Test");
	TextDrawFont(NAMETD[1], 1);
	TextDrawLetterSize(NAMETD[1], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[1], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[1], 0);
	TextDrawSetShadow(NAMETD[1], 0);
	TextDrawAlignment(NAMETD[1], 1);
	TextDrawColor(NAMETD[1], -1);
	TextDrawBackgroundColor(NAMETD[1], 255);
	TextDrawBoxColor(NAMETD[1], 50);
	TextDrawUseBox(NAMETD[1], 0);
	TextDrawSetProportional(NAMETD[1], 1);
	TextDrawSetSelectable(NAMETD[1], 0);

	NAMETD[2] = TextDrawCreate(208.000000, 121.000000, "Test");
	TextDrawFont(NAMETD[2], 1);
	TextDrawLetterSize(NAMETD[2], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[2], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[2], 0);
	TextDrawSetShadow(NAMETD[2], 0);
	TextDrawAlignment(NAMETD[2], 1);
	TextDrawColor(NAMETD[2], -1);
	TextDrawBackgroundColor(NAMETD[2], 255);
	TextDrawBoxColor(NAMETD[2], 50);
	TextDrawUseBox(NAMETD[2], 0);
	TextDrawSetProportional(NAMETD[2], 1);
	TextDrawSetSelectable(NAMETD[2], 0);

	NAMETD[3] = TextDrawCreate(248.000000, 121.000000, "Test");
	TextDrawFont(NAMETD[3], 1);
	TextDrawLetterSize(NAMETD[3], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[3], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[3], 0);
	TextDrawSetShadow(NAMETD[3], 0);
	TextDrawAlignment(NAMETD[3], 1);
	TextDrawColor(NAMETD[3], -1);
	TextDrawBackgroundColor(NAMETD[3], 255);
	TextDrawBoxColor(NAMETD[3], 50);
	TextDrawUseBox(NAMETD[3], 0);
	TextDrawSetProportional(NAMETD[3], 1);
	TextDrawSetSelectable(NAMETD[3], 0);

	NAMETD[4] = TextDrawCreate(287.000000, 121.000000, "Test");
	TextDrawFont(NAMETD[4], 1);
	TextDrawLetterSize(NAMETD[4], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[4], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[4], 0);
	TextDrawSetShadow(NAMETD[4], 0);
	TextDrawAlignment(NAMETD[4], 1);
	TextDrawColor(NAMETD[4], -1);
	TextDrawBackgroundColor(NAMETD[4], 255);
	TextDrawBoxColor(NAMETD[4], 50);
	TextDrawUseBox(NAMETD[4], 0);
	TextDrawSetProportional(NAMETD[4], 1);
	TextDrawSetSelectable(NAMETD[4], 0);

	NAMETD[5] = TextDrawCreate(128.000000, 176.000000, "Test");
	TextDrawFont(NAMETD[5], 1);
	TextDrawLetterSize(NAMETD[5], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[5], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[5], 0);
	TextDrawSetShadow(NAMETD[5], 0);
	TextDrawAlignment(NAMETD[5], 1);
	TextDrawColor(NAMETD[5], -1);
	TextDrawBackgroundColor(NAMETD[5], 255);
	TextDrawBoxColor(NAMETD[5], 50);
	TextDrawUseBox(NAMETD[5], 0);
	TextDrawSetProportional(NAMETD[5], 1);
	TextDrawSetSelectable(NAMETD[5], 0);

	NAMETD[6] = TextDrawCreate(168.000000, 176.000000, "Test");
	TextDrawFont(NAMETD[6], 1);
	TextDrawLetterSize(NAMETD[6], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[6], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[6], 0);
	TextDrawSetShadow(NAMETD[6], 0);
	TextDrawAlignment(NAMETD[6], 1);
	TextDrawColor(NAMETD[6], -1);
	TextDrawBackgroundColor(NAMETD[6], 255);
	TextDrawBoxColor(NAMETD[6], 50);
	TextDrawUseBox(NAMETD[6], 0);
	TextDrawSetProportional(NAMETD[6], 1);
	TextDrawSetSelectable(NAMETD[6], 0);

	NAMETD[7] = TextDrawCreate(208.000000, 176.000000, "Test");
	TextDrawFont(NAMETD[7], 1);
	TextDrawLetterSize(NAMETD[7], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[7], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[7], 0);
	TextDrawSetShadow(NAMETD[7], 0);
	TextDrawAlignment(NAMETD[7], 1);
	TextDrawColor(NAMETD[7], -1);
	TextDrawBackgroundColor(NAMETD[7], 255);
	TextDrawBoxColor(NAMETD[7], 50);
	TextDrawUseBox(NAMETD[7], 0);
	TextDrawSetProportional(NAMETD[7], 1);
	TextDrawSetSelectable(NAMETD[7], 0);

	NAMETD[8] = TextDrawCreate(248.000000, 176.000000, "Test");
	TextDrawFont(NAMETD[8], 1);
	TextDrawLetterSize(NAMETD[8], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[8], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[8], 0);
	TextDrawSetShadow(NAMETD[8], 0);
	TextDrawAlignment(NAMETD[8], 1);
	TextDrawColor(NAMETD[8], -1);
	TextDrawBackgroundColor(NAMETD[8], 255);
	TextDrawBoxColor(NAMETD[8], 50);
	TextDrawUseBox(NAMETD[8], 0);
	TextDrawSetProportional(NAMETD[8], 1);
	TextDrawSetSelectable(NAMETD[8], 0);

	NAMETD[9] = TextDrawCreate(287.000000, 176.000000, "Test");
	TextDrawFont(NAMETD[9], 1);
	TextDrawLetterSize(NAMETD[9], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[9], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[9], 0);
	TextDrawSetShadow(NAMETD[9], 0);
	TextDrawAlignment(NAMETD[9], 1);
	TextDrawColor(NAMETD[9], -1);
	TextDrawBackgroundColor(NAMETD[9], 255);
	TextDrawBoxColor(NAMETD[9], 50);
	TextDrawUseBox(NAMETD[9], 0);
	TextDrawSetProportional(NAMETD[9], 1);
	TextDrawSetSelectable(NAMETD[9], 0);

	NAMETD[10] = TextDrawCreate(128.000000, 232.000000, "Test");
	TextDrawFont(NAMETD[10], 1);
	TextDrawLetterSize(NAMETD[10], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[10], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[10], 0);
	TextDrawSetShadow(NAMETD[10], 0);
	TextDrawAlignment(NAMETD[10], 1);
	TextDrawColor(NAMETD[10], -1);
	TextDrawBackgroundColor(NAMETD[10], 255);
	TextDrawBoxColor(NAMETD[10], 50);
	TextDrawUseBox(NAMETD[10], 0);
	TextDrawSetProportional(NAMETD[10], 1);
	TextDrawSetSelectable(NAMETD[10], 0);

	NAMETD[11] = TextDrawCreate(168.000000, 232.000000, "Test");
	TextDrawFont(NAMETD[11], 1);
	TextDrawLetterSize(NAMETD[11], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[11], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[11], 0);
	TextDrawSetShadow(NAMETD[11], 0);
	TextDrawAlignment(NAMETD[11], 1);
	TextDrawColor(NAMETD[11], -1);
	TextDrawBackgroundColor(NAMETD[11], 255);
	TextDrawBoxColor(NAMETD[11], 50);
	TextDrawUseBox(NAMETD[11], 0);
	TextDrawSetProportional(NAMETD[11], 1);
	TextDrawSetSelectable(NAMETD[11], 0);

	NAMETD[12] = TextDrawCreate(287.000000, 232.000000, "Test");
	TextDrawFont(NAMETD[12], 1);
	TextDrawLetterSize(NAMETD[12], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[12], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[12], 0);
	TextDrawSetShadow(NAMETD[12], 0);
	TextDrawAlignment(NAMETD[12], 1);
	TextDrawColor(NAMETD[12], -1);
	TextDrawBackgroundColor(NAMETD[12], 255);
	TextDrawBoxColor(NAMETD[12], 50);
	TextDrawUseBox(NAMETD[12], 0);
	TextDrawSetProportional(NAMETD[12], 1);
	TextDrawSetSelectable(NAMETD[12], 0);

	NAMETD[13] = TextDrawCreate(248.000000, 232.000000, "Test");
	TextDrawFont(NAMETD[13], 1);
	TextDrawLetterSize(NAMETD[13], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[13], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[13], 0);
	TextDrawSetShadow(NAMETD[13], 0);
	TextDrawAlignment(NAMETD[13], 1);
	TextDrawColor(NAMETD[13], -1);
	TextDrawBackgroundColor(NAMETD[13], 255);
	TextDrawBoxColor(NAMETD[13], 50);
	TextDrawUseBox(NAMETD[13], 0);
	TextDrawSetProportional(NAMETD[13], 1);
	TextDrawSetSelectable(NAMETD[13], 0);

	NAMETD[14] = TextDrawCreate(208.000000, 232.000000, "Test");
	TextDrawFont(NAMETD[14], 1);
	TextDrawLetterSize(NAMETD[14], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[14], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[14], 0);
	TextDrawSetShadow(NAMETD[14], 0);
	TextDrawAlignment(NAMETD[14], 1);
	TextDrawColor(NAMETD[14], -1);
	TextDrawBackgroundColor(NAMETD[14], 255);
	TextDrawBoxColor(NAMETD[14], 50);
	TextDrawUseBox(NAMETD[14], 0);
	TextDrawSetProportional(NAMETD[14], 1);
	TextDrawSetSelectable(NAMETD[14], 0);

	NAMETD[15] = TextDrawCreate(128.000000, 287.000000, "Test");
	TextDrawFont(NAMETD[15], 1);
	TextDrawLetterSize(NAMETD[15], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[15], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[15], 0);
	TextDrawSetShadow(NAMETD[15], 0);
	TextDrawAlignment(NAMETD[15], 1);
	TextDrawColor(NAMETD[15], -1);
	TextDrawBackgroundColor(NAMETD[15], 255);
	TextDrawBoxColor(NAMETD[15], 50);
	TextDrawUseBox(NAMETD[15], 0);
	TextDrawSetProportional(NAMETD[15], 1);
	TextDrawSetSelectable(NAMETD[15], 0);

	NAMETD[16] = TextDrawCreate(168.000000, 287.000000, "Test");
	TextDrawFont(NAMETD[16], 1);
	TextDrawLetterSize(NAMETD[16], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[16], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[16], 0);
	TextDrawSetShadow(NAMETD[16], 0);
	TextDrawAlignment(NAMETD[16], 1);
	TextDrawColor(NAMETD[16], -1);
	TextDrawBackgroundColor(NAMETD[16], 255);
	TextDrawBoxColor(NAMETD[16], 50);
	TextDrawUseBox(NAMETD[16], 0);
	TextDrawSetProportional(NAMETD[16], 1);
	TextDrawSetSelectable(NAMETD[16], 0);

	NAMETD[17] = TextDrawCreate(208.000000, 287.000000, "Test");
	TextDrawFont(NAMETD[17], 1);
	TextDrawLetterSize(NAMETD[17], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[17], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[17], 0);
	TextDrawSetShadow(NAMETD[17], 0);
	TextDrawAlignment(NAMETD[17], 1);
	TextDrawColor(NAMETD[17], -1);
	TextDrawBackgroundColor(NAMETD[17], 255);
	TextDrawBoxColor(NAMETD[17], 50);
	TextDrawUseBox(NAMETD[17], 0);
	TextDrawSetProportional(NAMETD[17], 1);
	TextDrawSetSelectable(NAMETD[17], 0);

	NAMETD[18] = TextDrawCreate(248.000000, 287.000000, "Test");
	TextDrawFont(NAMETD[18], 1);
	TextDrawLetterSize(NAMETD[18], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[18], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[18], 0);
	TextDrawSetShadow(NAMETD[18], 0);
	TextDrawAlignment(NAMETD[18], 1);
	TextDrawColor(NAMETD[18], -1);
	TextDrawBackgroundColor(NAMETD[18], 255);
	TextDrawBoxColor(NAMETD[18], 50);
	TextDrawUseBox(NAMETD[18], 0);
	TextDrawSetProportional(NAMETD[18], 1);
	TextDrawSetSelectable(NAMETD[18], 0);

	NAMETD[19] = TextDrawCreate(287.000000, 287.000000, "Test");
	TextDrawFont(NAMETD[19], 1);
	TextDrawLetterSize(NAMETD[19], 0.128000, 0.699000);
	TextDrawTextSize(NAMETD[19], 400.000000, 17.000000);
	TextDrawSetOutline(NAMETD[19], 0);
	TextDrawSetShadow(NAMETD[19], 0);
	TextDrawAlignment(NAMETD[19], 1);
	TextDrawColor(NAMETD[19], -1);
	TextDrawBackgroundColor(NAMETD[19], 255);
	TextDrawBoxColor(NAMETD[19], 50);
	TextDrawUseBox(NAMETD[19], 0);
	TextDrawSetProportional(NAMETD[19], 1);
	TextDrawSetSelectable(NAMETD[19], 0);

	MODELTD[0] = TextDrawCreate(129.000000, 129.000000, "Preview_Model");
	TextDrawFont(MODELTD[0], 5);
	TextDrawLetterSize(MODELTD[0], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[0], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[0], 0);
	TextDrawSetShadow(MODELTD[0], 0);
	TextDrawAlignment(MODELTD[0], 1);
	TextDrawColor(MODELTD[0], -1);
	TextDrawBackgroundColor(MODELTD[0], 0);
	TextDrawBoxColor(MODELTD[0], 255);
	TextDrawUseBox(MODELTD[0], 0);
	TextDrawSetProportional(MODELTD[0], 1);
	TextDrawSetSelectable(MODELTD[0], 1);
	TextDrawSetPreviewModel(MODELTD[0], 1212);
	TextDrawSetPreviewRot(MODELTD[0], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[0], 1, 1);

	MODELTD[1] = TextDrawCreate(169.000000, 129.000000, "Preview_Model");
	TextDrawFont(MODELTD[1], 5);
	TextDrawLetterSize(MODELTD[1], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[1], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[1], 0);
	TextDrawSetShadow(MODELTD[1], 0);
	TextDrawAlignment(MODELTD[1], 1);
	TextDrawColor(MODELTD[1], -1);
	TextDrawBackgroundColor(MODELTD[1], 0);
	TextDrawBoxColor(MODELTD[1], 255);
	TextDrawUseBox(MODELTD[1], 0);
	TextDrawSetProportional(MODELTD[1], 1);
	TextDrawSetSelectable(MODELTD[1], 1);
	TextDrawSetPreviewModel(MODELTD[1], 1212);
	TextDrawSetPreviewRot(MODELTD[1], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[1], 1, 1);

	MODELTD[2] = TextDrawCreate(209.000000, 129.000000, "Preview_Model");
	TextDrawFont(MODELTD[2], 5);
	TextDrawLetterSize(MODELTD[2], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[2], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[2], 0);
	TextDrawSetShadow(MODELTD[2], 0);
	TextDrawAlignment(MODELTD[2], 1);
	TextDrawColor(MODELTD[2], -1);
	TextDrawBackgroundColor(MODELTD[2], 0);
	TextDrawBoxColor(MODELTD[2], 255);
	TextDrawUseBox(MODELTD[2], 0);
	TextDrawSetProportional(MODELTD[2], 1);
	TextDrawSetSelectable(MODELTD[2], 1);
	TextDrawSetPreviewModel(MODELTD[2], 1212);
	TextDrawSetPreviewRot(MODELTD[2], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[2], 1, 1);

	MODELTD[3] = TextDrawCreate(249.000000, 129.000000, "Preview_Model");
	TextDrawFont(MODELTD[3], 5);
	TextDrawLetterSize(MODELTD[3], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[3], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[3], 0);
	TextDrawSetShadow(MODELTD[3], 0);
	TextDrawAlignment(MODELTD[3], 1);
	TextDrawColor(MODELTD[3], -1);
	TextDrawBackgroundColor(MODELTD[3], 0);
	TextDrawBoxColor(MODELTD[3], 255);
	TextDrawUseBox(MODELTD[3], 0);
	TextDrawSetProportional(MODELTD[3], 1);
	TextDrawSetSelectable(MODELTD[3], 1);
	TextDrawSetPreviewModel(MODELTD[3], 1212);
	TextDrawSetPreviewRot(MODELTD[3], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[3], 1, 1);

	MODELTD[4] = TextDrawCreate(289.000000, 129.000000, "Preview_Model");
	TextDrawFont(MODELTD[4], 5);
	TextDrawLetterSize(MODELTD[4], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[4], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[4], 0);
	TextDrawSetShadow(MODELTD[4], 0);
	TextDrawAlignment(MODELTD[4], 1);
	TextDrawColor(MODELTD[4], -1);
	TextDrawBackgroundColor(MODELTD[4], 0);
	TextDrawBoxColor(MODELTD[4], 255);
	TextDrawUseBox(MODELTD[4], 0);
	TextDrawSetProportional(MODELTD[4], 1);
	TextDrawSetSelectable(MODELTD[4], 1);
	TextDrawSetPreviewModel(MODELTD[4], 1212);
	TextDrawSetPreviewRot(MODELTD[4], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[4], 1, 1);

	MODELTD[5] = TextDrawCreate(129.000000, 185.000000, "Preview_Model");
	TextDrawFont(MODELTD[5], 5);
	TextDrawLetterSize(MODELTD[5], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[5], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[5], 0);
	TextDrawSetShadow(MODELTD[5], 0);
	TextDrawAlignment(MODELTD[5], 1);
	TextDrawColor(MODELTD[5], -1);
	TextDrawBackgroundColor(MODELTD[5], 0);
	TextDrawBoxColor(MODELTD[5], 255);
	TextDrawUseBox(MODELTD[5], 0);
	TextDrawSetProportional(MODELTD[5], 1);
	TextDrawSetSelectable(MODELTD[5], 1);
	TextDrawSetPreviewModel(MODELTD[5], 1212);
	TextDrawSetPreviewRot(MODELTD[5], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[5], 1, 1);

	MODELTD[6] = TextDrawCreate(169.000000, 185.000000, "Preview_Model");
	TextDrawFont(MODELTD[6], 5);
	TextDrawLetterSize(MODELTD[6], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[6], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[6], 0);
	TextDrawSetShadow(MODELTD[6], 0);
	TextDrawAlignment(MODELTD[6], 1);
	TextDrawColor(MODELTD[6], -1);
	TextDrawBackgroundColor(MODELTD[6], 0);
	TextDrawBoxColor(MODELTD[6], 255);
	TextDrawUseBox(MODELTD[6], 0);
	TextDrawSetProportional(MODELTD[6], 1);
	TextDrawSetSelectable(MODELTD[6], 1);
	TextDrawSetPreviewModel(MODELTD[6], 1212);
	TextDrawSetPreviewRot(MODELTD[6], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[6], 1, 1);

	MODELTD[7] = TextDrawCreate(209.000000, 185.000000, "Preview_Model");
	TextDrawFont(MODELTD[7], 5);
	TextDrawLetterSize(MODELTD[7], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[7], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[7], 0);
	TextDrawSetShadow(MODELTD[7], 0);
	TextDrawAlignment(MODELTD[7], 1);
	TextDrawColor(MODELTD[7], -1);
	TextDrawBackgroundColor(MODELTD[7], 0);
	TextDrawBoxColor(MODELTD[7], 255);
	TextDrawUseBox(MODELTD[7], 0);
	TextDrawSetProportional(MODELTD[7], 1);
	TextDrawSetSelectable(MODELTD[7], 1);
	TextDrawSetPreviewModel(MODELTD[7], 1212);
	TextDrawSetPreviewRot(MODELTD[7], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[7], 1, 1);

	MODELTD[8] = TextDrawCreate(249.000000, 185.000000, "Preview_Model");
	TextDrawFont(MODELTD[8], 5);
	TextDrawLetterSize(MODELTD[8], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[8], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[8], 0);
	TextDrawSetShadow(MODELTD[8], 0);
	TextDrawAlignment(MODELTD[8], 1);
	TextDrawColor(MODELTD[8], -1);
	TextDrawBackgroundColor(MODELTD[8], 0);
	TextDrawBoxColor(MODELTD[8], 255);
	TextDrawUseBox(MODELTD[8], 0);
	TextDrawSetProportional(MODELTD[8], 1);
	TextDrawSetSelectable(MODELTD[8], 1);
	TextDrawSetPreviewModel(MODELTD[8], 1212);
	TextDrawSetPreviewRot(MODELTD[8], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[8], 1, 1);

	MODELTD[9] = TextDrawCreate(289.000000, 185.000000, "Preview_Model");
	TextDrawFont(MODELTD[9], 5);
	TextDrawLetterSize(MODELTD[9], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[9], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[9], 0);
	TextDrawSetShadow(MODELTD[9], 0);
	TextDrawAlignment(MODELTD[9], 1);
	TextDrawColor(MODELTD[9], -1);
	TextDrawBackgroundColor(MODELTD[9], 0);
	TextDrawBoxColor(MODELTD[9], 255);
	TextDrawUseBox(MODELTD[9], 0);
	TextDrawSetProportional(MODELTD[9], 1);
	TextDrawSetSelectable(MODELTD[9], 1);
	TextDrawSetPreviewModel(MODELTD[9], 1212);
	TextDrawSetPreviewRot(MODELTD[9], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[9], 1, 1);

	MODELTD[10] = TextDrawCreate(129.000000, 241.000000, "Preview_Model");
	TextDrawFont(MODELTD[10], 5);
	TextDrawLetterSize(MODELTD[10], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[10], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[10], 0);
	TextDrawSetShadow(MODELTD[10], 0);
	TextDrawAlignment(MODELTD[10], 1);
	TextDrawColor(MODELTD[10], -1);
	TextDrawBackgroundColor(MODELTD[10], 0);
	TextDrawBoxColor(MODELTD[10], 255);
	TextDrawUseBox(MODELTD[10], 0);
	TextDrawSetProportional(MODELTD[10], 1);
	TextDrawSetSelectable(MODELTD[10], 1);
	TextDrawSetPreviewModel(MODELTD[10], 1212);
	TextDrawSetPreviewRot(MODELTD[10], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[10], 1, 1);

	MODELTD[11] = TextDrawCreate(169.000000, 241.000000, "Preview_Model");
	TextDrawFont(MODELTD[11], 5);
	TextDrawLetterSize(MODELTD[11], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[11], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[11], 0);
	TextDrawSetShadow(MODELTD[11], 0);
	TextDrawAlignment(MODELTD[11], 1);
	TextDrawColor(MODELTD[11], -1);
	TextDrawBackgroundColor(MODELTD[11], 0);
	TextDrawBoxColor(MODELTD[11], 255);
	TextDrawUseBox(MODELTD[11], 0);
	TextDrawSetProportional(MODELTD[11], 1);
	TextDrawSetSelectable(MODELTD[11], 1);
	TextDrawSetPreviewModel(MODELTD[11], 1212);
	TextDrawSetPreviewRot(MODELTD[11], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[11], 1, 1);

	MODELTD[12] = TextDrawCreate(209.000000, 241.000000, "Preview_Model");
	TextDrawFont(MODELTD[12], 5);
	TextDrawLetterSize(MODELTD[12], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[12], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[12], 0);
	TextDrawSetShadow(MODELTD[12], 0);
	TextDrawAlignment(MODELTD[12], 1);
	TextDrawColor(MODELTD[12], -1);
	TextDrawBackgroundColor(MODELTD[12], 0);
	TextDrawBoxColor(MODELTD[12], 255);
	TextDrawUseBox(MODELTD[12], 0);
	TextDrawSetProportional(MODELTD[12], 1);
	TextDrawSetSelectable(MODELTD[12], 1);
	TextDrawSetPreviewModel(MODELTD[12], 1212);
	TextDrawSetPreviewRot(MODELTD[12], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[12], 1, 1);

	MODELTD[13] = TextDrawCreate(249.000000, 241.000000, "Preview_Model");
	TextDrawFont(MODELTD[13], 5);
	TextDrawLetterSize(MODELTD[13], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[13], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[13], 0);
	TextDrawSetShadow(MODELTD[13], 0);
	TextDrawAlignment(MODELTD[13], 1);
	TextDrawColor(MODELTD[13], -1);
	TextDrawBackgroundColor(MODELTD[13], 0);
	TextDrawBoxColor(MODELTD[13], 255);
	TextDrawUseBox(MODELTD[13], 0);
	TextDrawSetProportional(MODELTD[13], 1);
	TextDrawSetSelectable(MODELTD[13], 1);
	TextDrawSetPreviewModel(MODELTD[13], 1212);
	TextDrawSetPreviewRot(MODELTD[13], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[13], 1, 1);

	MODELTD[14] = TextDrawCreate(288.000000, 241.000000, "Preview_Model");
	TextDrawFont(MODELTD[14], 5);
	TextDrawLetterSize(MODELTD[14], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[14], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[14], 0);
	TextDrawSetShadow(MODELTD[14], 0);
	TextDrawAlignment(MODELTD[14], 1);
	TextDrawColor(MODELTD[14], -1);
	TextDrawBackgroundColor(MODELTD[14], 0);
	TextDrawBoxColor(MODELTD[14], 255);
	TextDrawUseBox(MODELTD[14], 0);
	TextDrawSetProportional(MODELTD[14], 1);
	TextDrawSetSelectable(MODELTD[14], 1);
	TextDrawSetPreviewModel(MODELTD[14], 1212);
	TextDrawSetPreviewRot(MODELTD[14], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[14], 1, 1);

	MODELTD[15] = TextDrawCreate(129.000000, 297.000000, "Preview_Model");
	TextDrawFont(MODELTD[15], 5);
	TextDrawLetterSize(MODELTD[15], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[15], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[15], 0);
	TextDrawSetShadow(MODELTD[15], 0);
	TextDrawAlignment(MODELTD[15], 1);
	TextDrawColor(MODELTD[15], -1);
	TextDrawBackgroundColor(MODELTD[15], 0);
	TextDrawBoxColor(MODELTD[15], 255);
	TextDrawUseBox(MODELTD[15], 0);
	TextDrawSetProportional(MODELTD[15], 1);
	TextDrawSetSelectable(MODELTD[15], 1);
	TextDrawSetPreviewModel(MODELTD[15], 1212);
	TextDrawSetPreviewRot(MODELTD[15], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[15], 1, 1);

	MODELTD[16] = TextDrawCreate(169.000000, 297.000000, "Preview_Model");
	TextDrawFont(MODELTD[16], 5);
	TextDrawLetterSize(MODELTD[16], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[16], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[16], 0);
	TextDrawSetShadow(MODELTD[16], 0);
	TextDrawAlignment(MODELTD[16], 1);
	TextDrawColor(MODELTD[16], -1);
	TextDrawBackgroundColor(MODELTD[16], 0);
	TextDrawBoxColor(MODELTD[16], 255);
	TextDrawUseBox(MODELTD[16], 0);
	TextDrawSetProportional(MODELTD[16], 1);
	TextDrawSetSelectable(MODELTD[16], 1);
	TextDrawSetPreviewModel(MODELTD[16], 1212);
	TextDrawSetPreviewRot(MODELTD[16], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[16], 1, 1);

	MODELTD[17] = TextDrawCreate(209.000000, 297.000000, "Preview_Model");
	TextDrawFont(MODELTD[17], 5);
	TextDrawLetterSize(MODELTD[17], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[17], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[17], 0);
	TextDrawSetShadow(MODELTD[17], 0);
	TextDrawAlignment(MODELTD[17], 1);
	TextDrawColor(MODELTD[17], -1);
	TextDrawBackgroundColor(MODELTD[17], 0);
	TextDrawBoxColor(MODELTD[17], 255);
	TextDrawUseBox(MODELTD[17], 0);
	TextDrawSetProportional(MODELTD[17], 1);
	TextDrawSetSelectable(MODELTD[17], 1);
	TextDrawSetPreviewModel(MODELTD[17], 1212);
	TextDrawSetPreviewRot(MODELTD[17], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[17], 1, 1);

	MODELTD[18] = TextDrawCreate(249.000000, 297.000000, "Preview_Model");
	TextDrawFont(MODELTD[18], 5);
	TextDrawLetterSize(MODELTD[18], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[18], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[18], 0);
	TextDrawSetShadow(MODELTD[18], 0);
	TextDrawAlignment(MODELTD[18], 1);
	TextDrawColor(MODELTD[18], -1);
	TextDrawBackgroundColor(MODELTD[18], 0);
	TextDrawBoxColor(MODELTD[18], 255);
	TextDrawUseBox(MODELTD[18], 0);
	TextDrawSetProportional(MODELTD[18], 1);
	TextDrawSetSelectable(MODELTD[18], 1);
	TextDrawSetPreviewModel(MODELTD[18], 1212);
	TextDrawSetPreviewRot(MODELTD[18], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[18], 1, 1);

	MODELTD[19] = TextDrawCreate(289.000000, 297.000000, "Preview_Model");
	TextDrawFont(MODELTD[19], 5);
	TextDrawLetterSize(MODELTD[19], 0.600000, 2.000000);
	TextDrawTextSize(MODELTD[19], 30.000000, 35.000000);
	TextDrawSetOutline(MODELTD[19], 0);
	TextDrawSetShadow(MODELTD[19], 0);
	TextDrawAlignment(MODELTD[19], 1);
	TextDrawColor(MODELTD[19], -1);
	TextDrawBackgroundColor(MODELTD[19], 0);
	TextDrawBoxColor(MODELTD[19], 255);
	TextDrawUseBox(MODELTD[19], 0);
	TextDrawSetProportional(MODELTD[19], 1);
	TextDrawSetSelectable(MODELTD[19], 1);
	TextDrawSetPreviewModel(MODELTD[19], 1212);
	TextDrawSetPreviewRot(MODELTD[19], 0.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetPreviewVehCol(MODELTD[19], 1, 1);

	AMOUNTTD[0] = TextDrawCreate(126.000000, 162.000000, "10000x");
	TextDrawFont(AMOUNTTD[0], 1);
	TextDrawLetterSize(AMOUNTTD[0], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[0], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[0], 0);
	TextDrawSetShadow(AMOUNTTD[0], 0);
	TextDrawAlignment(AMOUNTTD[0], 1);
	TextDrawColor(AMOUNTTD[0], -1);
	TextDrawBackgroundColor(AMOUNTTD[0], 255);
	TextDrawBoxColor(AMOUNTTD[0], 50);
	TextDrawUseBox(AMOUNTTD[0], 0);
	TextDrawSetProportional(AMOUNTTD[0], 1);
	TextDrawSetSelectable(AMOUNTTD[0], 0);

	AMOUNTTD[1] = TextDrawCreate(166.000000, 162.000000, "10000x");
	TextDrawFont(AMOUNTTD[1], 1);
	TextDrawLetterSize(AMOUNTTD[1], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[1], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[1], 0);
	TextDrawSetShadow(AMOUNTTD[1], 0);
	TextDrawAlignment(AMOUNTTD[1], 1);
	TextDrawColor(AMOUNTTD[1], -1);
	TextDrawBackgroundColor(AMOUNTTD[1], 255);
	TextDrawBoxColor(AMOUNTTD[1], 50);
	TextDrawUseBox(AMOUNTTD[1], 0);
	TextDrawSetProportional(AMOUNTTD[1], 1);
	TextDrawSetSelectable(AMOUNTTD[1], 0);

	AMOUNTTD[2] = TextDrawCreate(206.000000, 162.000000, "10000x");
	TextDrawFont(AMOUNTTD[2], 1);
	TextDrawLetterSize(AMOUNTTD[2], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[2], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[2], 0);
	TextDrawSetShadow(AMOUNTTD[2], 0);
	TextDrawAlignment(AMOUNTTD[2], 1);
	TextDrawColor(AMOUNTTD[2], -1);
	TextDrawBackgroundColor(AMOUNTTD[2], 255);
	TextDrawBoxColor(AMOUNTTD[2], 50);
	TextDrawUseBox(AMOUNTTD[2], 0);
	TextDrawSetProportional(AMOUNTTD[2], 1);
	TextDrawSetSelectable(AMOUNTTD[2], 0);

	AMOUNTTD[3] = TextDrawCreate(246.000000, 162.000000, "10000x");
	TextDrawFont(AMOUNTTD[3], 1);
	TextDrawLetterSize(AMOUNTTD[3], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[3], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[3], 0);
	TextDrawSetShadow(AMOUNTTD[3], 0);
	TextDrawAlignment(AMOUNTTD[3], 1);
	TextDrawColor(AMOUNTTD[3], -1);
	TextDrawBackgroundColor(AMOUNTTD[3], 255);
	TextDrawBoxColor(AMOUNTTD[3], 50);
	TextDrawUseBox(AMOUNTTD[3], 0);
	TextDrawSetProportional(AMOUNTTD[3], 1);
	TextDrawSetSelectable(AMOUNTTD[3], 0);

	AMOUNTTD[4] = TextDrawCreate(286.000000, 162.000000, "10000x");
	TextDrawFont(AMOUNTTD[4], 1);
	TextDrawLetterSize(AMOUNTTD[4], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[4], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[4], 0);
	TextDrawSetShadow(AMOUNTTD[4], 0);
	TextDrawAlignment(AMOUNTTD[4], 1);
	TextDrawColor(AMOUNTTD[4], -1);
	TextDrawBackgroundColor(AMOUNTTD[4], 255);
	TextDrawBoxColor(AMOUNTTD[4], 50);
	TextDrawUseBox(AMOUNTTD[4], 0);
	TextDrawSetProportional(AMOUNTTD[4], 1);
	TextDrawSetSelectable(AMOUNTTD[4], 0);

	AMOUNTTD[5] = TextDrawCreate(126.000000, 218.000000, "10000x");
	TextDrawFont(AMOUNTTD[5], 1);
	TextDrawLetterSize(AMOUNTTD[5], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[5], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[5], 0);
	TextDrawSetShadow(AMOUNTTD[5], 0);
	TextDrawAlignment(AMOUNTTD[5], 1);
	TextDrawColor(AMOUNTTD[5], -1);
	TextDrawBackgroundColor(AMOUNTTD[5], 255);
	TextDrawBoxColor(AMOUNTTD[5], 50);
	TextDrawUseBox(AMOUNTTD[5], 0);
	TextDrawSetProportional(AMOUNTTD[5], 1);
	TextDrawSetSelectable(AMOUNTTD[5], 0);

	AMOUNTTD[6] = TextDrawCreate(166.000000, 218.000000, "10000x");
	TextDrawFont(AMOUNTTD[6], 1);
	TextDrawLetterSize(AMOUNTTD[6], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[6], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[6], 0);
	TextDrawSetShadow(AMOUNTTD[6], 0);
	TextDrawAlignment(AMOUNTTD[6], 1);
	TextDrawColor(AMOUNTTD[6], -1);
	TextDrawBackgroundColor(AMOUNTTD[6], 255);
	TextDrawBoxColor(AMOUNTTD[6], 50);
	TextDrawUseBox(AMOUNTTD[6], 0);
	TextDrawSetProportional(AMOUNTTD[6], 1);
	TextDrawSetSelectable(AMOUNTTD[6], 0);

	AMOUNTTD[7] = TextDrawCreate(206.000000, 218.000000, "10000x");
	TextDrawFont(AMOUNTTD[7], 1);
	TextDrawLetterSize(AMOUNTTD[7], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[7], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[7], 0);
	TextDrawSetShadow(AMOUNTTD[7], 0);
	TextDrawAlignment(AMOUNTTD[7], 1);
	TextDrawColor(AMOUNTTD[7], -1);
	TextDrawBackgroundColor(AMOUNTTD[7], 255);
	TextDrawBoxColor(AMOUNTTD[7], 50);
	TextDrawUseBox(AMOUNTTD[7], 0);
	TextDrawSetProportional(AMOUNTTD[7], 1);
	TextDrawSetSelectable(AMOUNTTD[7], 0);

	AMOUNTTD[8] = TextDrawCreate(246.000000, 218.000000, "10000x");
	TextDrawFont(AMOUNTTD[8], 1);
	TextDrawLetterSize(AMOUNTTD[8], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[8], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[8], 0);
	TextDrawSetShadow(AMOUNTTD[8], 0);
	TextDrawAlignment(AMOUNTTD[8], 1);
	TextDrawColor(AMOUNTTD[8], -1);
	TextDrawBackgroundColor(AMOUNTTD[8], 255);
	TextDrawBoxColor(AMOUNTTD[8], 50);
	TextDrawUseBox(AMOUNTTD[8], 0);
	TextDrawSetProportional(AMOUNTTD[8], 1);
	TextDrawSetSelectable(AMOUNTTD[8], 0);

	AMOUNTTD[9] = TextDrawCreate(286.000000, 218.000000, "10000x");
	TextDrawFont(AMOUNTTD[9], 1);
	TextDrawLetterSize(AMOUNTTD[9], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[9], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[9], 0);
	TextDrawSetShadow(AMOUNTTD[9], 0);
	TextDrawAlignment(AMOUNTTD[9], 1);
	TextDrawColor(AMOUNTTD[9], -1);
	TextDrawBackgroundColor(AMOUNTTD[9], 255);
	TextDrawBoxColor(AMOUNTTD[9], 50);
	TextDrawUseBox(AMOUNTTD[9], 0);
	TextDrawSetProportional(AMOUNTTD[9], 1);
	TextDrawSetSelectable(AMOUNTTD[9], 0);

	AMOUNTTD[10] = TextDrawCreate(126.000000, 274.000000, "10000x");
	TextDrawFont(AMOUNTTD[10], 1);
	TextDrawLetterSize(AMOUNTTD[10], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[10], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[10], 0);
	TextDrawSetShadow(AMOUNTTD[10], 0);
	TextDrawAlignment(AMOUNTTD[10], 1);
	TextDrawColor(AMOUNTTD[10], -1);
	TextDrawBackgroundColor(AMOUNTTD[10], 255);
	TextDrawBoxColor(AMOUNTTD[10], 50);
	TextDrawUseBox(AMOUNTTD[10], 0);
	TextDrawSetProportional(AMOUNTTD[10], 1);
	TextDrawSetSelectable(AMOUNTTD[10], 0);

	AMOUNTTD[11] = TextDrawCreate(166.000000, 274.000000, "10000x");
	TextDrawFont(AMOUNTTD[11], 1);
	TextDrawLetterSize(AMOUNTTD[11], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[11], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[11], 0);
	TextDrawSetShadow(AMOUNTTD[11], 0);
	TextDrawAlignment(AMOUNTTD[11], 1);
	TextDrawColor(AMOUNTTD[11], -1);
	TextDrawBackgroundColor(AMOUNTTD[11], 255);
	TextDrawBoxColor(AMOUNTTD[11], 50);
	TextDrawUseBox(AMOUNTTD[11], 0);
	TextDrawSetProportional(AMOUNTTD[11], 1);
	TextDrawSetSelectable(AMOUNTTD[11], 0);

	AMOUNTTD[12] = TextDrawCreate(206.000000, 274.000000, "10000x");
	TextDrawFont(AMOUNTTD[12], 1);
	TextDrawLetterSize(AMOUNTTD[12], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[12], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[12], 0);
	TextDrawSetShadow(AMOUNTTD[12], 0);
	TextDrawAlignment(AMOUNTTD[12], 1);
	TextDrawColor(AMOUNTTD[12], -1);
	TextDrawBackgroundColor(AMOUNTTD[12], 255);
	TextDrawBoxColor(AMOUNTTD[12], 50);
	TextDrawUseBox(AMOUNTTD[12], 0);
	TextDrawSetProportional(AMOUNTTD[12], 1);
	TextDrawSetSelectable(AMOUNTTD[12], 0);

	AMOUNTTD[13] = TextDrawCreate(246.000000, 274.000000, "10000x");
	TextDrawFont(AMOUNTTD[13], 1);
	TextDrawLetterSize(AMOUNTTD[13], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[13], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[13], 0);
	TextDrawSetShadow(AMOUNTTD[13], 0);
	TextDrawAlignment(AMOUNTTD[13], 1);
	TextDrawColor(AMOUNTTD[13], -1);
	TextDrawBackgroundColor(AMOUNTTD[13], 255);
	TextDrawBoxColor(AMOUNTTD[13], 50);
	TextDrawUseBox(AMOUNTTD[13], 0);
	TextDrawSetProportional(AMOUNTTD[13], 1);
	TextDrawSetSelectable(AMOUNTTD[13], 0);

	AMOUNTTD[14] = TextDrawCreate(286.000000, 275.000000, "10000x");
	TextDrawFont(AMOUNTTD[14], 1);
	TextDrawLetterSize(AMOUNTTD[14], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[14], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[14], 0);
	TextDrawSetShadow(AMOUNTTD[14], 0);
	TextDrawAlignment(AMOUNTTD[14], 1);
	TextDrawColor(AMOUNTTD[14], -1);
	TextDrawBackgroundColor(AMOUNTTD[14], 255);
	TextDrawBoxColor(AMOUNTTD[14], 50);
	TextDrawUseBox(AMOUNTTD[14], 0);
	TextDrawSetProportional(AMOUNTTD[14], 1);
	TextDrawSetSelectable(AMOUNTTD[14], 0);

	AMOUNTTD[15] = TextDrawCreate(126.000000, 330.000000, "10000x");
	TextDrawFont(AMOUNTTD[15], 1);
	TextDrawLetterSize(AMOUNTTD[15], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[15], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[15], 0);
	TextDrawSetShadow(AMOUNTTD[15], 0);
	TextDrawAlignment(AMOUNTTD[15], 1);
	TextDrawColor(AMOUNTTD[15], -1);
	TextDrawBackgroundColor(AMOUNTTD[15], 255);
	TextDrawBoxColor(AMOUNTTD[15], 50);
	TextDrawUseBox(AMOUNTTD[15], 0);
	TextDrawSetProportional(AMOUNTTD[15], 1);
	TextDrawSetSelectable(AMOUNTTD[15], 0);

	AMOUNTTD[16] = TextDrawCreate(166.000000, 330.000000, "10000x");
	TextDrawFont(AMOUNTTD[16], 1);
	TextDrawLetterSize(AMOUNTTD[16], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[16], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[16], 0);
	TextDrawSetShadow(AMOUNTTD[16], 0);
	TextDrawAlignment(AMOUNTTD[16], 1);
	TextDrawColor(AMOUNTTD[16], -1);
	TextDrawBackgroundColor(AMOUNTTD[16], 255);
	TextDrawBoxColor(AMOUNTTD[16], 50);
	TextDrawUseBox(AMOUNTTD[16], 0);
	TextDrawSetProportional(AMOUNTTD[16], 1);
	TextDrawSetSelectable(AMOUNTTD[16], 0);

	AMOUNTTD[17] = TextDrawCreate(206.000000, 330.000000, "10000x");
	TextDrawFont(AMOUNTTD[17], 1);
	TextDrawLetterSize(AMOUNTTD[17], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[17], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[17], 0);
	TextDrawSetShadow(AMOUNTTD[17], 0);
	TextDrawAlignment(AMOUNTTD[17], 1);
	TextDrawColor(AMOUNTTD[17], -1);
	TextDrawBackgroundColor(AMOUNTTD[17], 255);
	TextDrawBoxColor(AMOUNTTD[17], 50);
	TextDrawUseBox(AMOUNTTD[17], 0);
	TextDrawSetProportional(AMOUNTTD[17], 1);
	TextDrawSetSelectable(AMOUNTTD[17], 0);

	AMOUNTTD[18] = TextDrawCreate(247.000000, 330.000000, "10000x");
	TextDrawFont(AMOUNTTD[18], 1);
	TextDrawLetterSize(AMOUNTTD[18], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[18], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[18], 0);
	TextDrawSetShadow(AMOUNTTD[18], 0);
	TextDrawAlignment(AMOUNTTD[18], 1);
	TextDrawColor(AMOUNTTD[18], -1);
	TextDrawBackgroundColor(AMOUNTTD[18], 255);
	TextDrawBoxColor(AMOUNTTD[18], 50);
	TextDrawUseBox(AMOUNTTD[18], 0);
	TextDrawSetProportional(AMOUNTTD[18], 1);
	TextDrawSetSelectable(AMOUNTTD[18], 0);

	AMOUNTTD[19] = TextDrawCreate(286.000000, 330.000000, "10000x");
	TextDrawFont(AMOUNTTD[19], 1);
	TextDrawLetterSize(AMOUNTTD[19], 0.119000, 0.597998);
	TextDrawTextSize(AMOUNTTD[19], 400.000000, 17.000000);
	TextDrawSetOutline(AMOUNTTD[19], 0);
	TextDrawSetShadow(AMOUNTTD[19], 0);
	TextDrawAlignment(AMOUNTTD[19], 1);
	TextDrawColor(AMOUNTTD[19], -1);
	TextDrawBackgroundColor(AMOUNTTD[19], 255);
	TextDrawBoxColor(AMOUNTTD[19], 50);
	TextDrawUseBox(AMOUNTTD[19], 0);
	TextDrawSetProportional(AMOUNTTD[19], 1);
	TextDrawSetSelectable(AMOUNTTD[19], 0);
    return 1;
}

new g_player_listitem[MAX_PLAYERS][96];
#define GetPlayerListitemValue(%0,%1) 		g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) 	g_player_listitem[%0][%1] = %2

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_AMOUNT)
	{
		if (response)
		{
			new str[125];

			PlayerData[playerid][pGiveAmount] = strval(inputtext);
			format(str, sizeof(str), "%d", strval(inputtext));
			TextDrawSetString(INVINFO[6], str);
		}
	}
 	if(dialogid == DIALOG_GIVE)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			new itemid = PlayerData[playerid][pSelectItem];
			new value = PlayerData[playerid][pGiveAmount];
			//new  otherid

			CallLocalFunction("OnPlayerGiveInvItem", "ddds[128]d", playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
    return 1;
}

CMD:inv(playerid, params[])
{
    Inventory_Show(playerid);
    return 1;
}

stock Inventory_Clear(playerid)
{
	static
	    string[64];

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
			InventoryData[playerid][i][invAmount] = 0;
		}
	}
	return 1;
}

stock Inventory_GetItemID(playerid, item[])
{
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

stock Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= 20)
		return -1;

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

stock Inventory_Items(playerid)
{
    new count;

    for(new i = 0; i < MAX_INVENTORY; i++) if (InventoryData[playerid][i][invExists])
	{
        count++;
	}
	return count;
}

stock Inventory_Count(playerid, item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return InventoryData[playerid][itemid][invAmount];

	return 0;
}

stock PlayerHasItem(playerid, item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

stock Inventory_Set(playerid, item[], model, amount, totalquantity)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
		Inventory_Addset(playerid, item, model, amount, totalquantity);

	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantity(playerid, item, amount, totalquantity);

	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);

	return 1;
}

stock Inventory_SetQuantity(playerid, item[], quantity, totalquantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    InventoryData[playerid][itemid][invAmount] = quantity;
	    InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
	}
	return 1;
}

stock Inventory_Remove(playerid, item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
		    new totalquantity = g_aInventoryItems[i][e_InventoryTotal];
		    if (InventoryData[playerid][itemid][invAmount] > 0 && InventoryData[playerid][itemid][invTotalQuantity] > 0)
		    {
		        InventoryData[playerid][itemid][invAmount] -= quantity;
		        InventoryData[playerid][itemid][invTotalQuantity] -= totalquantity;
			}
			if (quantity == -1 || InventoryData[playerid][itemid][invTotalQuantity] < 1 || totalquantity == -1 || InventoryData[playerid][itemid][invAmount] < 1)
			{
			    InventoryData[playerid][itemid][invExists] = false;
			    InventoryData[playerid][itemid][invModel] = 0;
			    InventoryData[playerid][itemid][invAmount] = 0;
			    InventoryData[playerid][itemid][invTotalQuantity] = 0;
			}
			else if (quantity != -1 && InventoryData[playerid][itemid][invAmount] > 0 && totalquantity != -1 && InventoryData[playerid][itemid][invTotalQuantity] > 0)
			{
			    InventoryData[playerid][itemid][invAmount] = quantity;
			    InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
			}
		}
		return 1;
	}
	return 0;
}
stock Inventory_Addset(playerid, item[], model, amount = 1, totalquantity)
{
	new itemid = Inventory_GetItemID(playerid, item);
	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);
	    if (itemid != -1)
	    {
	   		InventoryData[playerid][itemid][invExists] = true;
		    InventoryData[playerid][itemid][invModel] = model;
			InventoryData[playerid][itemid][invAmount] = amount;
			InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;

		    strpack(InventoryData[playerid][itemid][invItem], item, 32 char);
		    return itemid;
		}
		return -1;
	}
	else
	{
		InventoryData[playerid][itemid][invAmount] += amount;
		InventoryData[playerid][itemid][invTotalQuantity] += totalquantity;
	}
	return itemid;
}

stock Inventory_Add(playerid, item[], model, quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);

	    if (itemid != -1)
	    {
         	for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
			{
			    new totalquantity = g_aInventoryItems[i][e_InventoryTotal];
     	 	  	InventoryData[playerid][itemid][invExists] = true;
		        InventoryData[playerid][itemid][invModel] = model;
				InventoryData[playerid][itemid][invAmount] = model;
				InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
		        return itemid;
			}
		}
		return -1;
	}
	return itemid;
}

stock Inventory_Close(playerid)
{
	if(BukaInven[playerid] == 0)
		return SCM(playerid, COLOR_SYNTAX, "You Have Not Opened Inventory.");

	CancelSelectTextDraw(playerid);
	PlayerData[playerid][pSelectItem] = -1;
	PlayerData[playerid][pGiveAmount] = 0;
	BukaInven[playerid] = 0;
	for(new a = 0; a < 6; a++)
	{
		TextDrawHideForPlayer(playerid, INVNAME[a]);
	}
	for(new a = 0; a < 11; a++)
	{
		TextDrawHideForPlayer(playerid, INVINFO[a]);
	}
	TextDrawSetString(INVINFO[6], "Amount");
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		TextDrawHideForPlayer(playerid, NAMETD[i]);
		TextDrawHideForPlayer(playerid, INDEXTD[i]);
		TextDrawColor(INDEXTD[i], 859394047);
		TextDrawHideForPlayer(playerid, MODELTD[i]);
		TextDrawHideForPlayer(playerid, AMOUNTTD[i]);
	}
	return 1;
}

stock Inventory_Show(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	new str[256], string[256], totalall, quantitybar;
	format(str,1000,"%s", GetRPName(playerid));
	TextDrawSetString(INVNAME[3], str);
	BarangMasuk(playerid);
	BukaInven[playerid] = 1;
	PlayerPlaySound(playerid, 1039, 0,0,0);
	SelectTextDraw(playerid, 0xFFA500FF);
	for(new a = 0; a < 6; a++)
	{
		TextDrawShowForPlayer(playerid, INVNAME[a]);
	}
	for(new a = 0; a < 11; a++)
	{
		TextDrawShowForPlayer(playerid, INVINFO[a]);
	}
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    TextDrawShowForPlayer(playerid, INDEXTD[i]);
		TextDrawShowForPlayer(playerid, AMOUNTTD[i]);
		totalall += InventoryData[playerid][i][invTotalQuantity];
		format(str, sizeof(str), "%.1f/850.0", float(totalall));
		TextDrawSetString(INVNAME[4], str);
		quantitybar = totalall * 199/850;
	  	TextDrawTextSize(INVNAME[2], quantitybar, 3.0);
	  	TextDrawShowForPlayer(playerid, INVNAME[2]);
		if(InventoryData[playerid][i][invExists])
		{
			TextDrawShowForPlayer(playerid, NAMETD[i]);
			TextDrawSetPreviewModel(MODELTD[i], InventoryData[playerid][i][invModel]);
			//sesuakian dengan object item kalian
			if(InventoryData[playerid][i][invModel] == 18867)
			{
				TextDrawSetPreviewRot(MODELTD[i], -254.000000, 0.000000, 0.000000, 2.779998);
			}
			else if(InventoryData[playerid][i][invModel] == 16776)
			{
				TextDrawSetPreviewRot(MODELTD[i], 0.000000, 0.000000, -85.000000, 1.000000);
			}
			else if(InventoryData[playerid][i][invModel] == 1581)
			{
				TextDrawSetPreviewRot(MODELTD[i], 0.000000, 0.000000, -180.000000, 1.000000);
			}
			TextDrawShowForPlayer(playerid, MODELTD[i]);
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			TextDrawSetString(NAMETD[i], str);
			format(str, sizeof(str), "%dx", InventoryData[playerid][i][invAmount]);
			TextDrawSetString(AMOUNTTD[i], str);
		}
		else
		{
			TextDrawHideForPlayer(playerid, AMOUNTTD[i]);
		}
	}
	return 1;
}

#define SCMf 	SendClientMessageFormatted // SendClientMessage with string formats

SendClientMessageFormatted(playerid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    SCM(playerid, color, text);
	}
	else
	{
		while(--args >= 3)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4

		SCM(playerid, color, str);

		#emit RETN
	}
	return 1;
}

CMD:useweed(playerid) return callcmd::usedrug(playerid, "weed");
CMD:usecocaine(playerid) return callcmd::usedrug(playerid, "cocaine");
CMD:useheroin(playerid) return callcmd::usedrug(playerid, "heroin");

forward OnPlayerUseItem(playerid, itemid, name[], value);
public OnPlayerUseItem(playerid, itemid, name[], value)
{
	if(!strcmp(name, "Money"))
	{
	    SCMf(playerid, -1, "MONEY Kn %i", PlayerData[playerid][pCash]);
	    Inventory_Update(playerid);
	    Inventory_Close(playerid);
	}
	/*else if(!strcmp(name, "Dirty Cash"))
	{
	    SCM(playerid, COLOR_SYNTAX, "You can't use this item");
	}*/
	else if(!strcmp(name, "Phone"))
	{
    	Inventory_Close(playerid);
    	callcmd::phone(playerid, "\1");
	}
	else if(!strcmp(name, "GPS"))
	{
	    ShowDialogToPlayer(playerid, DIALOG_LOCATE);
	    //ShowItemBox(playerid, "GPS", "USE", 18874, 3);
	    Inventory_Update(playerid);
	    Inventory_Close(playerid);
	}
	/*else if(!strcmp(name, "GASCAN"))
	{
        new vehicleid = GetPlayerVehicleID(playerid);

        if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        {
		    return SCM(playerid, COLOR_SYNTAX, "You are not driving any vehicle of yours.");
		}
		if(!IsVehicleOwner(playerid, vehicleid) && PlayerData[playerid][pVehicleKeys] != vehicleid)
		{
		    return SCM(playerid, COLOR_SYNTAX, "You can't refuel this vehicle as it doesn't belong to you.");
		}

        PlayerPlaySound(playerid, 36401, 0.0, 0.0, 0.0);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);

        PlayerData[playerid][pGasCan] -= 1;
        vehicleFuel[vehicleid] += 20;

        DBQuery("UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", PlayerData[playerid][pGasCan], PlayerData[playerid][pID]);

	    //ShowItemBox(playerid, "GASCAN", "USE", 1650, 3);
	    Inventory_Update(playerid);
	    Inventory_Close(playerid);
	}*/
	else if(!strcmp(name, "Radio"))
	{
		Inventory_Close(playerid);
		callcmd::setfreq(playerid, "\1");
	}
	/*else if(!strcmp(name, "Food"))
	{
		callcmd::eat(playerid, "\1");
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Drink"))
	{
	    callcmd::drink(playerid, "water");
		Inventory_Close(playerid);
	}*/
	/*else if(!strcmp(name, "Bandage"))
	{
	    callcmd::use(playerid, "medkit");
		Inventory_Close(playerid);
	}*/
	/*else if(!strcmp(name, "RepairKit"))
	{
	    callcmd::use(playerid, "repairkit");
		Inventory_Close(playerid);
	}*/
	/*else if(!strcmp(name, "Mask"))
	{
	    callcmd::mask(playerid, "\1");
		Inventory_Close(playerid);
	}*/
	else if(!strcmp(name, "Cocaine"))
	{
	    callcmd::usecocaine(playerid);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Weed"))
	{
	    callcmd::useweed(playerid);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Heroin"))
	{
	    callcmd::useheroin(playerid);
		Inventory_Close(playerid);
	}
    return 1;
}

stock BarangMasuk(playerid)
{
	Inventory_Set(playerid, "Money", 1212, PlayerData[playerid][pCash], PlayerData[playerid][pCash]);
	//Inventory_Set(playerid, "Dirty Cash", 1580, PlayerData[playerid][pDirtyCash], PlayerData[playerid][pDirtyCash]);
	Inventory_Set(playerid, "Phone", 19513, PlayerData[playerid][pPhone], PlayerData[playerid][pPhone]);
	Inventory_Set(playerid, "Radio", 330, PlayerData[playerid][pPrivateRadio], PlayerData[playerid][pPrivateRadio]);
    //Inventory_Set(playerid, "Mask", 18914, MaskedPlayer[playerid], MaskedPlayer[playerid]);
	//Inventory_Set(playerid, "Food", 2703, PlayerData[playerid][pFood], PlayerData[playerid][pFood]);
	Inventory_Set(playerid, "GPS", 18874, PlayerData[playerid][pGPS], PlayerData[playerid][pGPS]);
	//Inventory_Set(playerid, "Drink", 2647, PlayerData[playerid][pDrink], PlayerData[playerid][pDrink]);
	Inventory_Set(playerid, "Cocaine", 1575, PlayerData[playerid][pCocaine], PlayerData[playerid][pCocaine]);
	Inventory_Set(playerid, "Weed", 702, PlayerData[playerid][pWeed], PlayerData[playerid][pWeed]);
	Inventory_Set(playerid, "Heroin", 1579, PlayerData[playerid][pHeroin], PlayerData[playerid][pHeroin]);
	Inventory_Set(playerid, "Bocket", 1672, PlayerData[playerid][pBocket], PlayerData[playerid][pBocket]);
	Inventory_Set(playerid, "Iron", 2491, PlayerData[playerid][pIronItem], PlayerData[playerid][pIronItem]);
	Inventory_Set(playerid, "Rubber", 1626, PlayerData[playerid][pRubberItem], PlayerData[playerid][pRubberItem]);
	Inventory_Set(playerid, "Metal", 3071, PlayerData[playerid][pMetalItem], PlayerData[playerid][pMetalItem]);
	Inventory_Set(playerid, "Plastic", 19587, PlayerData[playerid][pPlasticItem], PlayerData[playerid][pPlasticItem]);
	Inventory_Set(playerid, "Materials", 1448, PlayerData[playerid][pMaterials], PlayerData[playerid][pMaterials]);
	Inventory_Update(playerid);
}

stock Inventory_Update(playerid)
{
	new str[256], string[256], totalall;
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    totalall += InventoryData[playerid][i][invTotalQuantity];
		format(str, sizeof(str), "%.1f/850.0", float(totalall));
		TextDrawSetString(INVNAME[2], str);
		if(InventoryData[playerid][i][invExists])
		{
			//sesuakian dengan object item kalian
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			TextDrawSetString(NAMETD[i], str);
			format(str, sizeof(str), "%d", InventoryData[playerid][i][invAmount]);
			TextDrawSetString(AMOUNTTD[i], str);
		}
		else
		{
			TextDrawHideForPlayer(playerid, AMOUNTTD[i]);
			TextDrawHideForPlayer(playerid, MODELTD[i]);
			TextDrawHideForPlayer(playerid, NAMETD[i]);
		}
	}
}

stock MenuStore_SelectRow2(playerid, row)
{
	PlayerData[playerid][pSelectItem] = row;
    TextDrawHideForPlayer(playerid, INDEXTD[row]);
	TextDrawColor(INDEXTD[row], -7232257);
	TextDrawShowForPlayer(playerid, INDEXTD[row]);
	SelectTextDraw(playerid, 0x8B0000);
}

stock MenuStore_UnselectRow2(playerid)
{
	if(PlayerData[playerid][pSelectItem] != -1)
	{
		new row = PlayerData[playerid][pSelectItem];
		TextDrawHideForPlayer(playerid, INDEXTD[row]);
		TextDrawColor(INDEXTD[row], 859394047);
		TextDrawShowForPlayer(playerid, INDEXTD[row]);
	}
	PlayerData[playerid][pSelectItem] = -1;
}

forward OnPlayerGiveInvItem(playerid, userid, itemid, name[], value);
public OnPlayerGiveInvItem(playerid, userid, itemid, name[], value)
{
    new string[64];
    new str[64];

	if(Inventory_Count(playerid, string) < PlayerData[playerid][pGiveAmount])
		return SCM(playerid, COLOR_SYNTAX, "Error: You don't have this item amount");

	if(!strcmp(name, "Money AMP", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Money AMP", str, 1212, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(userid, "Money AMP", str, 1212, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pCash] -= value;
		PlayerData[userid][pCash] += value;
	}
	/*else if(!strcmp(name, "Dirty Cash", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Dirty Cash", str, 1580, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(userid, "Dirty Cash", str, 1580, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pDirtyCash] -= value;
		PlayerData[userid][pDirtyCash] += value;
	}*/
    else if(!strcmp(name, "GPS", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "GPS", str, 18874, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "GPS", str, 18874, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pGPS] -= value;
		PlayerData[userid][pGPS] += value;
	}
	else if(!strcmp(name, "GASCAN", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "GASCAN", str, 1650, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "GASCAN", str, 1650, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pGasCan] -= value;
		PlayerData[userid][pGasCan] += value;
	}
	else if(!strcmp(name, "Phone", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Phone AMP", str, 18870, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Phone AMP", str, 18870, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pPhone] -= value;
		PlayerData[userid][pPhone] += value;
	}
	/*else if(!strcmp(name, "Mask", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Mask", str, 18914, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Mask", str, 18914, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pMask] -= value;
		PlayerData[userid][pMask] += value;
	}*/
	else if(!strcmp(name, "Cocaine", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pCocaine] -= value;
		PlayerData[userid][pCocaine] += value;
	}
	else if(!strcmp(name, "Weed", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pWeed] -= value;
		PlayerData[userid][pWeed] += value;
	}
	else if(!strcmp(name, "Heroin", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pHeroin] -= value;
		PlayerData[userid][pHeroin] += value;
	}
	else if(!strcmp(name, "Bocket", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pBocket] -= value;
		PlayerData[userid][pBocket] += value;
	}
	else if(!strcmp(name, "Iron", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pIronItem] -= value;
		PlayerData[userid][pIronItem] += value;
	}
	else if(!strcmp(name, "Rubber", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pRubberItem] -= value;
		PlayerData[userid][pRubberItem] += value;
	}
	else if(!strcmp(name, "Metal", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pMetalItem] -= value;
		PlayerData[userid][pMetalItem] += value;
	}
	else if(!strcmp(name, "Plastic", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pPlasticItem] -= value;
		PlayerData[userid][pPlasticItem] += value;
	}
	else if(!strcmp(name, "Materials", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Crack", str, 11748, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pMaterials] -= value;
		PlayerData[userid][pMaterials] += value;
	}
	else if(!strcmp(name, "Radio", true))
	{
		format(str, sizeof(str), "Removed_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Radio AMP", str, 18874, 2);

		format(str, sizeof(str), "Received_%dx", PlayerData[playerid][pGiveAmount]);
		//ShowItemBox(playerid, "Radio AMP", str, 18874, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4, 0, 0, 0, 0, 0, 1);

        PlayerData[playerid][pPrivateRadio] -= value;
		PlayerData[userid][pPrivateRadio] += value;
	}
	return Inventory_Close(playerid);
}

NearPlayer(playerid, targetid, Float:radius)
{
    static
        Float:fX,
        Float:fY,
        Float:fZ;

    GetPlayerPos(targetid, fX, fY, fZ);

    return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    for(new i = 0; i < MAX_INVENTORY; i++)
     {
        if(clickedid == MODELTD[i])
		{
			if(InventoryData[playerid][i][invExists])
			{
			    MenuStore_UnselectRow2(playerid);
				MenuStore_SelectRow2(playerid, i);
			    new name[48];
            	strunpack(name, InventoryData[playerid][PlayerData[playerid][pSelectItem]][invItem]);
			}
		}
	}
    if(clickedid == INVINFO[2])
	{
		new id = PlayerData[playerid][pSelectItem];

		if(id == -1)
		{
		    SCM(playerid, COLOR_SYNTAX, "[Inventory] There are no items in the slot");
		}
		else
		{
			new string[64];
		    strunpack(string, InventoryData[playerid][id][invItem]);

		    if(!PlayerHasItem(playerid, string))
		    {
		   		SCM(playerid, COLOR_SYNTAX, "[Inventory] You Don't Own These Items");
                Inventory_Show(playerid);
			}
			else
			{
				CallLocalFunction("OnPlayerUseItem", "dds", playerid, id, string);
			}
		}
	}
    else if(clickedid == INVINFO[5])
	{
		Inventory_Close(playerid);
	}
	else if(clickedid == INVINFO[4])
	{
		SCM(playerid, COLOR_SYNTAX, "This Dialog In Progress");
	}
    else if(clickedid == INVINFO[3])
	{
		new str[1024], id = PlayerData[playerid][pSelectItem], count = 0;

		if(id == -1)
		{
			SCM(playerid, COLOR_SYNTAX, "[Inventory] Select The Item Befor");
		}
		else
		{
		    if (PlayerData[playerid][pGiveAmount] < 1)
				return SCM(playerid, COLOR_SYNTAX, "[Inventory] Type The Amount");

            foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
			    format(str, sizeof(str), "%s Pocket - %i", str, GetRPName(i), i);
				SetPlayerListitemValue(playerid, count++, i);
			}
			if(!count) SCM(playerid, COLOR_SYNTAX, "No-one Near You!");
			else ShowPlayerDialog(playerid, DIALOG_GIVE, DIALOG_STYLE_LIST, "Arabica - Inventory", str, "Yes", "No");
		}
	}
	else if(clickedid == INVINFO[1])
	{
		ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Inventory - Amount", "Amount:", "Yes", "No");
	}
 	if(clickedid == Text:INVALID_TEXT_DRAW && !PlayerData[playerid][pLogged])
	{
		SelectTextDraw(playerid, COLOR_LIGHTBLUE);
	}
    return 1;
}