/// @file      VIPLocker.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-02-21 22:58:31 +0100
/// @copyright Copyright (c) 2023

#include <YSI\y_hooks>

static VIPArmorPickup;
static VIPHealthPickup;

static const VipSkins[] = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
    38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55,
    56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73,
    75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92,
    93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
    109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123,
    124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138,
    139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153,
    154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168,
    169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183,
    184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198,
    199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213,
    214, 215, 216, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228,
    229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243,
    244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258,
    259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273,
    289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299
};

hook OnGameModeInit()
{
    CreateDynamicLabeledPickup(COLOR_YELLOW, "[VIP Locker]\n{FFFFFF}Type /viplocker to open the locker.\nType /clothes to change your clothes.\nType /getboombox to get free boombox.",
                               -2829.9160, 1064.0081, 2253.4204, .interior = -1, .vw = -1, .pickupid = 1239, .radius = 10.0);

    CreateDynamicLabeledPickup(COLOR_YELLOW, "[VIP Locker]\n{FFFFFF}Type /viplocker to open the locker.\nType /clothes to change your clothes.\nType /getboombox to get free boombox.",
                               1988.5000, -1255.9500, 2690.8100, .interior = 3, .vw = 7, .pickupid = 1239, .radius = 10.0);
    VIPHealthPickup = CreateDynamicPickup(1240, 1, 1988.5000, -1252.0000, 2690.8100, .worldid = 7, .interiorid = 3);
    VIPArmorPickup  = CreateDynamicPickup(1242, 1, 1988.5000, -1259.2000, 2690.8100, .worldid = 7, .interiorid = 3);
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
    if (PlayerData[playerid][pDonator] > 0)
    {
        new newValue = 0;
        switch (PlayerData[playerid][pDonator])
        {
            case 1: { newValue = 100; }
            case 2: { newValue = 125; }
            case 3: { newValue = 150; }
        }
        if (pickupid == VIPHealthPickup && GetPlayerHealthEx(playerid) < newValue)
        {
            SetPlayerHealth(playerid, newValue);
        }
        else if (pickupid == VIPArmorPickup && GetPlayerArmourEx(playerid) < newValue)
        {
            SetScriptArmour(playerid, newValue);
        }
    }
}

Dialog:Vip1GetWeapon(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: GivePlayerWeaponEx(playerid, 23); // Silenced 9mm
            case 1: GivePlayerWeaponEx(playerid, 25); // Shotgun
            case 2: GivePlayerWeaponEx(playerid, 28); // Micro SMG/Uzi
        }
    }
    return 1;
}

Dialog:Vip2GetWeapon(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: GivePlayerWeaponEx(playerid, 23); // Silenced 9mm
            case 1: GivePlayerWeaponEx(playerid, 25); // Shotgun
            case 2: GivePlayerWeaponEx(playerid, 28); // Micro SMG/Uzi

            case 3: GivePlayerWeaponEx(playerid, 24); // Desert Eagle
            case 4: GivePlayerWeaponEx(playerid, 29); // MP5
            case 5: GivePlayerWeaponEx(playerid, 33); // Country Rifle
            case 6: GivePlayerWeaponEx(playerid, 30); // AK-47
        }
    }
    return 1;
}

Dialog:Vip3GetWeapon(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:  // Full weapon set
            {
                GivePlayerFullWeaponSet(playerid);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have received a {00AA00}full weapon set{33CCFF} from your vip weapons.");
            }
            case 1: GivePlayerWeaponEx(playerid, 23); // Silenced 9mm
            case 2: GivePlayerWeaponEx(playerid, 25); // Shotgun
            case 3: GivePlayerWeaponEx(playerid, 28); // Micro SMG/Uzi

            case 4: GivePlayerWeaponEx(playerid, 24); // Desert Eagle
            case 5: GivePlayerWeaponEx(playerid, 29); // MP5
            case 6: GivePlayerWeaponEx(playerid, 33); // Country Rifle
            case 7: GivePlayerWeaponEx(playerid, 30); // AK-47

            case 8: GivePlayerWeaponEx(playerid, 8); // Katana
            case 9: GivePlayerWeaponEx(playerid, 31); // M4
            case 10: GivePlayerWeaponEx(playerid, 27); // Combat Shotgun
            case 11: GivePlayerWeaponEx(playerid, 34); // Sniper Rifle
        }
    }
    return 1;
}

hook OnPlayerMenuResponse(playerid, extraid, response, listitem, modelid)
{
    if (extraid != MODEL_SELECTION_VIPCLOTHES || !response || listitem < 0 || PlayerData[playerid][pDonator] == 0)
        return 1;

    SetScriptSkin(playerid, modelid);
    return SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You changed your clothes free of charge.");
}

Dialog:VipLocker(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: // Weapons
            {
                switch (PlayerData[playerid][pDonator])
                {
                    case 1: Dialog_Show(playerid, Vip1GetWeapon, DIALOG_STYLE_LIST, "SILVER VIP Locker",    "Silenced 9mm\nShotgun\nMicro SMG/Uzi", "Select", "Cancel");
                    case 2: Dialog_Show(playerid, Vip2GetWeapon, DIALOG_STYLE_LIST, "Gold VIP Locker",      "Silenced 9mm\nShotgun\nMicro SMG/Uzi\nDesert Eagle\nMP5\nCountry Rifle\nAK-47", "Select", "Cancel");
                    case 3: Dialog_Show(playerid, Vip3GetWeapon, DIALOG_STYLE_LIST, "Legendary VIP Locker", "Full weapon Set\nSilenced 9mm\nShotgun\nMicro SMG/Uzi\nDesert Eagle\nMP5\nCountry Rifle\nAK-47\nKatana\nM4\nCombat Shotgun\nSniper Rifle", "Select", "Cancel");
                }
            }
            case 1: // Heal up
            {
                new newValue = 0;
                switch (PlayerData[playerid][pDonator])
                {
                    case 1: { newValue = 100; }
                    case 2: { newValue = 125; }
                    case 3: { newValue = 150; }
                }
                if (GetPlayerArmourEx(playerid) < newValue)
                    SetScriptArmour(playerid, newValue);
                if (GetPlayerHealthEx(playerid) < newValue)
                    SetPlayerHealth(playerid, newValue);
            }
            case 2:
            {
                ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_VIPCLOTHES, "VIP Clothes", VipSkins, sizeof(VipSkins));
            }
            case 3:
            {
                PlayerData[playerid][pBoombox] = 1;
                DBQuery("UPDATE "#TABLE_USERS" SET boombox = 1 WHERE uid = %i", PlayerData[playerid][pID]);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have earned a free {D909D9}Legendary VIP{FFFFFF} boombox.");
            }
        }
    }
    return 1;

}


CMD:viplocker(playerid, params[])
{
    if (PlayerData[playerid][pDonator] < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need a donator package (Gold VIP+) to access this locker.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 4.0,  1988.5000, -1255.9500, 2690.8100) &&
        !IsPlayerInRangeOfPoint(playerid, 4.0, -2829.9160,  1064.0081, 2253.4204))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in the {D909D9}VIP{afafaf} Lounge [/locatelounge].");
    }
    switch (PlayerData[playerid][pDonator])
    {
        case 1: Dialog_Show(playerid, VipLocker, DIALOG_STYLE_LIST, "SILVER VIP Locker",    "Weapons\nHeal up\nClothes", "Select", "Cancel");
        case 2: Dialog_Show(playerid, VipLocker, DIALOG_STYLE_LIST, "Gold VIP Locker",      "Weapons\nHeal up\nClothes", "Select", "Cancel");
        case 3: Dialog_Show(playerid, VipLocker, DIALOG_STYLE_LIST, "Legendary VIP Locker", "Weapons\nHeal up\nClothes\nBoombox", "Select", "Cancel");
    }
    return 1;
}
