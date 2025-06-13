/// @file      AdminWish.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-05-07 00:10:21 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum AdminWish
{
    AdminWish_FullWeaponSet,
    AdminWish_Weapon,
    AdminWish_TmpWeapon,
    AdminWish_HP,
    AdminWish_Armor,
    AdminWish_Revive,
    AdminWish_Money,
    AdminWish_Cookies,
    AdminWish_Jetpack,
    AdminWish_Vehicle,
    AdminWish_TmpVehicle,
    AdminWish_Skin,
    AdminWish_VIP,
    AdminWish_Payday,
    AdminWish_DoubleXP,
    AdminWish_Diamonds,
    AdminWish_Materials,
    AdminWish_Seeds,
    AdminWish_Weed,
    AdminWish_Cocaine,
    AdminWish_Heroin,
    AdminWish_Chems,
    AdminWish_FirstAid,
    AdminWish_Painkillers,
    AdminWish_Cigars,
    AdminWish_Beers,
    AdminWish_Bodykits,
    AdminWish_Spraycans,
    AdminWish_GasCan,

    AdminWish_Count
};

static WishString[512];

enum WishTargetType
{
    WishTargetType_PlayerId,
    WishTargetType_NearestPlayers,
    WishTargetType_AllPlayers,
    WishTargetType_Unknown
};

enum eAdminWish
{
    WishTargetType:AdminWish_TargetType,
    AdminWish_TargetID,
    AdminWish:AdminWish_Type,
    AdminWish_Param1,
    AdminWish_Param2
};
static AdminWishInfo[MAX_PLAYERS][eAdminWish];

stock AdminWishToString(AdminWish:wish)
{
    static AdminWishes[][20] = {
        "Full weapon set", "Weapon", "Temporary Weapon", "HP", "Armor", "Revive", "Money",
        "Cookies", "Jetpack", "Vehicle", "Temporary Vehicle", "Skin", "VIP", "Payday", "Double XP",
        "Diamonds", "Materials", "Seeds", "Weed", "Cocaine", "Heroin", "Chems", "FirstAid",
        "Painkillers", "Cigars", "Beers", "Bodykits", "Spraycans", "GasCan"
    };
    return AdminWishes[_:wish];
}

stock WishTypeToString(WishType:type)
{
    new result[20];
    switch (type)
    {
        case WishTargetType_Unknown:         result = "Unknown";
        case WishTargetType_Player:          result = "Player";
        case WishTargetType_NearestPlayers:  result = "Nearest players";
        case WishTargetType_AllPlayers:      result = "All players";
        default:                             result = "Unknown";
    }
    return result;
}

hook OnGameModeInit()
{
    format(WishString, sizeof(WishString), "%s", AdminWishToString(AdminWish:0));

    for (new i = 1; i < _:AdminWish_Count; i++)
    {
        format(WishString, sizeof(WishString), "%s\n%s",WishString, AdminWishToString(AdminWish:i));
    }
}

CMD:wish(playerid, params[])
{
    if (IsProductionServer() && !IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    AdminWishInfo[playerid][AdminWish_TargetType] = WishTargetType_Unknown;
    AdminWishInfo[playerid][AdminWish_TargetID]   = INVALID_PLAYER_ID;

    if (!isnull(params))
    {
        new targetid;
        if (!strcmp(params, "near", true) || !strcmp(params, "nearest", true))
        {
            AdminWishInfo[playerid][AdminWish_TargetType] = WishTargetType_NearestPlayers;
        }
        else if (!strcmp(params, "all", true))
        {
            AdminWishInfo[playerid][AdminWish_TargetType] = WishTargetType_AllPlayers;
        }
        else if (!sscanf(params, "u", targetid) && IsPlayerConnected(targetid))
        {
            AdminWishInfo[playerid][AdminWish_TargetType] = WishTargetType_PlayerId;
            AdminWishInfo[playerid][AdminWish_TargetID]   = targetid;
        }
        else
        {
            return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /wish [player / near / all]");
        }
    }

    Dialog_Show(playerid, AdminWish, DIALOG_STYLE_LIST, "Admin - What's your wish?", WishString, "Select", "Close");
    return 1;
}

Dialog:AdminWish(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        AdminWishInfo[playerid][AdminWish_Type] = AdminWish:listitem;
        if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_Unknown)
        {
            new title[64];
            format(title, sizeof(title),"Give '%s'?", inputtext);
            Dialog_Show(playerid, AdminWishTargetType, DIALOG_STYLE_LIST, title, "To a specific player\nTo nearest players\nTo all players", "Select", "Close");
        }
        else
        {
            ShowAdminWishParam1Dlg(playerid);
        }

    }
    return 1;
}

Dialog:AdminWishTargetType(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        AdminWishInfo[playerid][AdminWish_TargetType] = WishTargetType:listitem;
        if (listitem == 0)
        {
            new title[64];
            format(title, sizeof(title),"Who will get '%s'?", inputtext);
            Dialog_Show(playerid, AdminWishTargetID, DIALOG_STYLE_INPUT, title, "Please enter the player id or name:", "Ok", "Cancel");
        }
        else
        {
            ShowAdminWishParam1Dlg(playerid);
        }
    }
    return 1;
}

Dialog:AdminWishTargetID(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new targetid;
        if (sscanf(inputtext, "u", targetid) || !IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid player.");
        }
        AdminWishInfo[playerid][AdminWish_TargetID] = targetid;
        ShowAdminWishParam1Dlg(playerid);
    }
    return 1;
}

ShowAdminWishParam1Dlg(playerid)
{
    new AdminWish:wish = AdminWishInfo[playerid][AdminWish_Type];

    if (AdminWishNbParams(wish) == 0)
    {
        ShowAdminConfirmWishDlg(playerid);
        return;
    }
    new targetstr[32];
    format(targetstr, sizeof(targetstr), "%s", GetAdminWishTargetStr(playerid));
    if (wish == AdminWish_Vehicle || wish == AdminWish_TmpVehicle)
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the vehicle model name to give it to %s", "Ok", "Cancel", targetstr);
    }
    else if (wish == AdminWish_DoubleXP)
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the number of hours of double XP to give it to %s", "Ok", "Cancel", targetstr);
    }
    else if (wish == AdminWish_VIP)
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the VIP rank id to give it to %s", "Ok", "Cancel", targetstr);
    }
    else if (wish == AdminWish_Skin)
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the skin id to give it to %s", "Ok", "Cancel", targetstr);
    }
    else if (wish == AdminWish_HP)
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the new HP to set to %s", "Ok", "Cancel", targetstr);
    }
    else if (wish == AdminWish_Armor)
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the new armor to set to %s", "Ok", "Cancel", targetstr);
    }
    else
    {
        Dialog_Show(playerid, AdminWishParam1, DIALOG_STYLE_INPUT, "AdminWish", "Enter the amount of %s to give it to %s", "Ok", "Cancel", AdminWishToString(wish), targetstr);
    }
}

Dialog:AdminWishParam1(playerid, response, listitem, inputtext[])
{
    if (response && !isnull(inputtext))
    {
        new param1;
        new AdminWish:wish = AdminWishInfo[playerid][AdminWish_Type];
        if (wish == AdminWish_Vehicle || wish == AdminWish_TmpVehicle)
        {
            if ((param1 = GetVehicleModelByName(inputtext)) == 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle model.");
            }
        }
        else if (sscanf(inputtext, "d", param1))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value");
        }

        switch (wish)
        {
            case AdminWish_TmpWeapon, AdminWish_Weapon:
            {
                RCHECK(1 <= param1 <= 46, "Invalid weapon.");
                RCHECK(param1 == 38 && !IsAdmin(playerid, ADMIN_LVL_6), "The minigun was disabled due to abuse.");
            }
            case AdminWish_VIP:         RCHECK(0 <= param1 <= 3,     "Invalid VIP rank");
            case AdminWish_HP:          RCHECK(0 <= param1 <= 255,   "Invalid HP value");
            case AdminWish_Armor:       RCHECK(0 <= param1 <= 255,   "Invalid Armor value");
            case AdminWish_DoubleXP:    RCHECK(1 <= param1,          "Hours of double XP must be higher than zero.");
            case AdminWish_Skin:        RCHECK((0 <= param1 <= 311) || (25000 <= param1 <= 25165), "Invalid skin id");
            case AdminWish_Money:       RCHECK(-50000000 <= param1 <= 50000000, "The value specified can't be under -$50,000,000 or above $50,000,000");
            case AdminWish_Materials:   RCHECK(0 <= param1 <= 50000000, "The value specified can't be under 0 or above 50,000,000");
            case AdminWish_Seeds:       RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Weed:        RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Cocaine:     RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Heroin:      RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Chems:       RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Painkillers: RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Cigars:      RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Spraycans:   RCHECK(0 <= param1 <= 100000,   "The value specified can't be under 0 or above 100,000");
            case AdminWish_Diamonds:    RCHECK(0 <= param1 <= 10000,    "The value specified can't be under 0 or above 10,000");
            case AdminWish_Cookies:     RCHECK(0 <= param1 <= 10000,    "The value specified can't be under 0 or above 10,000");
            case AdminWish_FirstAid:    RCHECK(0 <= param1 <= 1000,     "The value specified can't be under 0 or above 1,000");
            case AdminWish_Bodykits:    RCHECK(0 <= param1 <= 1000,     "The value specified can't be under 0 or above 1,000");
            case AdminWish_GasCan:      RCHECK(0 <= param1 <= 1000,     "The value specified can't be under 0 or above 1,000");
        }
        AdminWishInfo[playerid][AdminWish_Param1] = param1;
        ShowAdminWishParam2Dlg(playerid);

    }
    return 1;
}

ShowAdminWishParam2Dlg(playerid)
{
    new AdminWish:wish = AdminWishInfo[playerid][AdminWish_Type];
    if (AdminWishNbParams(wish) <= 1)
    {
        ShowAdminConfirmWishDlg(playerid);
        return;
    }
    if (wish == AdminWish_VIP)
    {
        new targetstr[32];
        format(targetstr, sizeof(targetstr), "%s", GetAdminWishTargetStr(playerid));
        Dialog_Show(playerid, AdminWishParam2, DIALOG_STYLE_INPUT, "AdminWish",
                    "{FFFFFF}How many days you want to give {33CCFF}%s{FFFFFF} the {D909D9}%s{FFFFFF} VIP package?",
                    "Ok", "Cancel", targetstr, GetVIPRank(AdminWishInfo[playerid][AdminWish_Param1]));
    }
}

Dialog:AdminWishParam2(playerid, response, listitem, inputtext[])
{
    if (response && !isnull(inputtext))
    {
        new param2;
        if (sscanf(inputtext, "d", param2))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid value");
        }

        if (AdminWishInfo[playerid][AdminWish_Type] == AdminWish_VIP && (!(1 <= param2 <= 365)))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The amount of days must range from 1 to 365.");
        }

        AdminWishInfo[playerid][AdminWish_Param2] = param2;
        ShowAdminConfirmWishDlg(playerid);
    }
    return 1;
}

GiveWishToPlayer(adminid, playerid, AdminWish:wish, param1=0, param2=0)
{
    if (!AdminWishHasAccess(playerid, wish))
    {
        SendClientMessageEx(adminid, COLOR_GREY, "You are not authorized to give this wish.");
        return false;
    }
    if (!IsAdmin(adminid, GetAdminLvl(playerid)))
    {
        SendClientMessageEx(adminid, COLOR_GREY, "You can't give this wish to this player.");
        return false;
    }

    switch (wish)
    {
        // No params
        case AdminWish_FullWeaponSet:
        {
            GivePlayerFullWeaponSet(playerid);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s gave a full weapon set to %s.", GetRPName(adminid), GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You have received a {00AA00}full weapon set{33CCFF} from %s.", GetRPName(adminid));
        }
        case AdminWish_Revive:
        {
            if (!RevivePlayer(playerid))
            {
                SendClientMessage(playerid, COLOR_YELLOW, "You have been revived by an admin!");
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has revived %s.", GetRPName(adminid), GetRPName(playerid));
            }
            else
            {
                SendClientMessage(adminid, COLOR_GREY, "The player specified is not injured.");
                return false;
            }
        }
        case AdminWish_Jetpack:
        {
            GivePlayerJetpack(playerid);
            if (playerid != adminid)
            {
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has received a Jetpack from %s.", GetRPName(playerid), GetRPName(adminid));
            }
            switch (random(4))
            {
                case 0: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: The jetpack is part of an experiment conducted at the Area 69 facility.");
                case 1: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You stole this from Area 69 in that one single player mission. Remember?");
                case 2: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You probably don't need this anyway. All you admins seem to do is airbreak around the map.");
                case 3: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You probably aren't reading this anyway. Fuck you.");
            }
        }
        case AdminWish_Payday:
        {
            SendPaycheck(playerid);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced a payday for %s.", GetRPName(adminid), GetRPName(playerid));
        }

        // 2 Params
        case AdminWish_VIP:
        {
            new rank = param1;
            new days = param2;
            GivePlayerVIP(playerid, rank, days);

            if (days >= 30)
            {
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {D909D9}%s{FF6347} VIP package to %s for %i months.", GetRPName(adminid), GetVIPRank(rank), GetRPName(playerid), days / 30);
                SendClientMessageEx(adminid, COLOR_AQUA, "* You have given %s a {D909D9}%s{33CCFF} VIP package for %i months.", GetRPName(playerid), GetVIPRank(rank), days / 30);
                SendClientMessageEx(playerid, COLOR_AQUA, "* %s has given you a {D909D9}%s{33CCFF} VIP package for %i months.", GetRPName(adminid), GetVIPRank(rank), days / 30);
            }
            else
            {
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a {D909D9}%s{FF6347} VIP package to %s for %i days.", GetRPName(adminid), GetVIPRank(rank), GetRPName(playerid), days);
                SendClientMessageEx(adminid, COLOR_AQUA, "* You have given %s a {D909D9}%s{33CCFF} VIP package for %i days.", GetRPName(playerid), GetVIPRank(rank), days);
                SendClientMessageEx(playerid, COLOR_AQUA, "* %s has given you a {D909D9}%s{33CCFF} VIP package for %i days.", GetRPName(adminid), GetVIPRank(rank), days);
            }
            DBLog("log_vip", "%s (uid: %i) has given %s (uid: %i) a %s VIP package for %i days.", GetPlayerNameEx(adminid), PlayerData[adminid][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVIPRank(rank), days);
        }

        // 1 Params
        case AdminWish_Beers:
        {
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has received beers from %s.", GetRPName(playerid), GetRPName(adminid));
        }
        case AdminWish_Weapon:
        {
            GivePlayerWeaponEx(playerid, param1);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have received a {00AA00}%s{33CCFF} from %s.", GetWeaponNameEx(param1), GetRPName(adminid));
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a %s to %s.", GetRPName(adminid), GetWeaponNameEx(param1), GetRPName(playerid));
            DBLog("log_givegun", "%s (uid: %i) gives a %s to %s (uid: %i)", GetPlayerNameEx(adminid), PlayerData[adminid][pID], GetWeaponNameEx(param1), GetPlayerNameEx(playerid), PlayerData[playerid][pID]);
        }
        case AdminWish_TmpWeapon:
        {
            GivePlayerWeaponEx(playerid, param1, true);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have received a Temporary {00AA00}%s{33CCFF} from %s.", GetWeaponNameEx(param1), GetRPName(adminid));
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given a Temporary %s to %s.", GetRPName(adminid), GetWeaponNameEx(param1), GetRPName(playerid));
        }
        case AdminWish_HP:
        {
            SetPlayerHealth(playerid, param1);
            SendClientMessageEx(adminid, COLOR_GREY2, "%s's health set to %.1f.", GetRPName(playerid), param1);
        }
        case AdminWish_Armor:
        {
            SetScriptArmour(playerid, param1);
            SendClientMessageEx(adminid, COLOR_GREY2, "%s's armor set to %.1f.", GetRPName(playerid), param1);
        }
        case AdminWish_Vehicle:
        {
            new modelid = param1;
            GivePlayerVehicle(playerid, modelid);
            SendClientMessageEx(playerid, COLOR_AQUA, "%s has given you your own {00AA00}%s{33CCFF}. /carstorage to spawn it.", GetRPName(adminid), GetVehicleNameByModel(modelid));
            SendClientMessageEx(adminid, COLOR_AQUA, "You have given %s their own {00AA00}%s{33CCFF}.", GetRPName(playerid), GetVehicleNameByModel(modelid));
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s their own %s.", GetRPName(adminid), GetRPName(playerid), GetVehicleNameByModel(modelid));
            DBLog("log_admin", "%s (uid: %i) has given %s (uid: %i) their own %s.", GetPlayerNameEx(adminid), PlayerData[adminid][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleNameByModel(modelid));
        }
        case AdminWish_TmpVehicle:
        {
            new vehicleid = param1;
            if (IsValidVehicle(GivePlayerAdminVehicle(playerid, vehicleid)))
            {
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s spawned a %s for %s.", GetRPName(adminid), GetVehicleName(vehicleid), GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_WHITE, "%s (ID %i) spawned. Use '/savevehicle %i' to save this vehicle to the database.", GetVehicleName(vehicleid), vehicleid, vehicleid);
            }
            else
            {
                return false;
            }
        }
        case AdminWish_Skin:
        {
            SetScriptSkin(playerid, param1);
            SendClientMessageEx(playerid, COLOR_GREY2, "%s's skin set to [%i] %s.", GetPlayerNameEx(playerid), param1, GetSkinName(param1));
        }
        case AdminWish_DoubleXP:
        {
            GivePlayerDoubleXP(playerid, param1);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s %i hours of Double XP.", GetRPName(adminid), GetRPName(playerid), param1);
        }
        case AdminWish_Money:
        {
            GivePlayerCash(playerid, param1);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s to %s.", GetRPName(adminid), FormatCash(param1), GetRPName(playerid));
            DBLog("log_givemoney", "%s (uid: %i) has used /givemoney to give $%i to %s (uid: %i).",
                    GetPlayerNameEx(adminid), PlayerData[adminid][pID], param1, GetPlayerNameEx(playerid), PlayerData[playerid][pID]);
        }
        default:
        {
            switch (wish)
            {
                case AdminWish_Cookies:
                {
                    GivePlayerCookies(playerid, param1);
                    DBLog("log_givecookie", "%s (uid: %i) has given %i cookie to %s (uid: %i)",
                          GetPlayerNameEx(adminid), PlayerData[adminid][pID], param1, GetPlayerNameEx(playerid), PlayerData[playerid][pID]);
                }
                case AdminWish_Diamonds:       GivePlayerDiamonds(playerid, param1);
                case AdminWish_Materials:      PlayerData[playerid][pMaterials] += param1;
                case AdminWish_Seeds:          PlayerData[playerid][pSeeds] += param1;
                case AdminWish_Weed:           PlayerData[playerid][pWeed] += param1;
                case AdminWish_Cocaine:        PlayerData[playerid][pCocaine] += param1;
                case AdminWish_Heroin:         PlayerData[playerid][pHeroin] += param1;
                case AdminWish_Chems:          PlayerData[playerid][pChemicals] += param1;
                case AdminWish_FirstAid:       PlayerData[playerid][pFirstAid] += param1;
                case AdminWish_Painkillers:    PlayerData[playerid][pPainkillers] += param1;
                case AdminWish_Cigars:         PlayerData[playerid][pCigars] += param1;
                case AdminWish_Bodykits:       PlayerData[playerid][pBodykits] += param1;
                case AdminWish_Spraycans:      PlayerData[playerid][pSpraycans] += param1;
                case AdminWish_GasCan:         PlayerData[playerid][pGasCan] += param1;
            }
            SendClientMessageEx(playerid, COLOR_AQUA, "You have received {00AA00}%s %s{33CCFF} from %s.",
                                FormatNumber(param1), AdminWishToString(wish), GetRPName(adminid));
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s %s to %s.", GetRPName(adminid),
                             FormatNumber(param1), AdminWishToString(wish), GetRPName(playerid));
        }
    }
    return true;
}

stock GivePlayerFullWeaponSet(playerid)
{
    GivePlayerWeaponEx(playerid, 24);
    GivePlayerWeaponEx(playerid, 27);
    GivePlayerWeaponEx(playerid, 29);
    GivePlayerWeaponEx(playerid, 30);
    GivePlayerWeaponEx(playerid, 34);
}

stock GivePlayerAdminVehicle(playerid, modelid, color1=1, color2=1)
{
    new Float:x, Float:y, Float:z, Float:a, vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = AddStaticVehicleEx(modelid, x, y, z, a, color1, color2, -1);

    if (!IsValidVehicle(vehicleid))
    {
        return INVALID_VEHICLE_ID;
    }

    ResetVehicleObjects(vehicleid);

    adminVehicle[vehicleid] = true;
    RefuelVehicle(vehicleid);
    vehicleColors[vehicleid][0] = color1;
    vehicleColors[vehicleid][1] = color2;

    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleHealth(vehicleid, 1000.0);

    PutPlayerInVehicle(playerid, vehicleid, 0);
    return vehicleid;
}
stock GivePlayerVehicle(playerid, modelid, color1=1, color2=1)
{
    new Float:x, Float:y, Float:z, Float:a, plate[32];

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    format(plate, 32, "%c%c%c %i", Random('A', 'Z'), Random('A', 'Z'), Random('A', 'Z'), Random(100, 999));

    DBQuery("INSERT INTO vehicles"\
        " (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, plate, color1, color2, carImpounded)" \
        "VALUES(%i, '%e', %i, '%f', '%f', '%f', '%f', '%e', %i, %i, '0')",
        PlayerData[playerid][pID], GetPlayerNameEx(playerid), modelid,
        x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a, plate, color1, color2);
}

stock GivePlayerVIPInvitation(playerid, rank)
{
    PlayerData[playerid][pDonator] = rank;
    PlayerData[playerid][pVIPTime] = gettime() + 10800;
    DBQuery("UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i WHERE uid = %i", PlayerData[playerid][pDonator], PlayerData[playerid][pVIPTime], PlayerData[playerid][pID]);
}

stock GivePlayerVIP(playerid, rank, days)
{
    PlayerData[playerid][pDonator] = rank;
    PlayerData[playerid][pVIPTime] = gettime() + (days * 86400);
    PlayerData[playerid][pVIPCooldown] = 0;
    DBQuery("UPDATE "#TABLE_USERS" SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerData[playerid][pDonator], PlayerData[playerid][pVIPTime], PlayerData[playerid][pID]);
}

stock GivePlayerDoubleXP(playerid, hours)
{
    PlayerData[playerid][pDoubleXP] += hours;
    DBQuery("UPDATE "#TABLE_USERS" SET doublexp = %i WHERE uid = %i", PlayerData[playerid][pDoubleXP], PlayerData[playerid][pID]);
}

stock GivePlayerDiamonds(playerid, amount)
{
    PlayerData[playerid][pDiamonds] += amount;
    DBQuery("UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", PlayerData[playerid][pDiamonds], PlayerData[playerid][pID]);
}

stock RevivePlayer(playerid)
{
    if (PlayerData[playerid][pInjured])
    {
        PlayerData[playerid][pInjured] = 0;
        SetPlayerHealth(playerid, 100.0);
        ClearAnimations(playerid, 1);

        if (PlayerData[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
        {
            SendClientMessageEx(PlayerData[playerid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has somehow found the strength to get up.", GetRPName(playerid));
            PlayerData[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
        }
        return 1;
    }
    return 0;
}

stock AdminWishNbParams(AdminWish:wish)
{
    switch (wish)
    {
        // No params
        case AdminWish_FullWeaponSet:  return 0;
        case AdminWish_Revive:         return 0;
        case AdminWish_Jetpack:        return 0;
        case AdminWish_Payday:         return 0;
        case AdminWish_Beers:          return 0;

        // 2 Params
        case AdminWish_VIP:            return 2;

        // 1 Params
        case AdminWish_Weapon:         return 1;
        case AdminWish_TmpWeapon:      return 1;
        case AdminWish_HP:             return 1;
        case AdminWish_Armor:          return 1;
        case AdminWish_Money:          return 1;
        case AdminWish_Cookies:        return 1;
        case AdminWish_Vehicle:        return 1;
        case AdminWish_TmpVehicle:     return 1;
        case AdminWish_Skin:           return 1;
        case AdminWish_DoubleXP:       return 1;
        case AdminWish_Diamonds:       return 1;
        case AdminWish_Materials:      return 1;
        case AdminWish_Seeds:          return 1;
        case AdminWish_Weed:           return 1;
        case AdminWish_Cocaine:        return 1;
        case AdminWish_Heroin:         return 1;
        case AdminWish_Chems:          return 1;
        case AdminWish_FirstAid:       return 1;
        case AdminWish_Painkillers:    return 1;
        case AdminWish_Cigars:         return 1;
        case AdminWish_Bodykits:       return 1;
        case AdminWish_Spraycans:      return 1;
        case AdminWish_GasCan:         return 1;
    }
    return 0;
}

stock AdminWishHasAccess(playerid, AdminWish:wish)
{
    if (!IsAdminOnDuty(playerid))
    {
        return false;
    }

    switch (wish)
    {
        // No params
        case AdminWish_FullWeaponSet:   return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Revive:          return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Jetpack:         return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Payday:          return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Beers:           return IsAdmin(playerid, ADMIN_LVL_5);

        // 2 Params
        case AdminWish_VIP:             return IsGodAdmin(playerid);

        // 1 Params
        case AdminWish_Weapon:         return IsAdmin(playerid, ADMIN_LVL_2);
        case AdminWish_TmpWeapon:      return IsAdmin(playerid, ADMIN_LVL_2);
        case AdminWish_HP:             return IsAdmin(playerid, ADMIN_LVL_4);
        case AdminWish_Armor:          return IsAdmin(playerid, ADMIN_LVL_4);
        case AdminWish_Money:          return IsAdmin(playerid, ADMIN_LVL_6);
        case AdminWish_Cookies:        return IsGodAdmin(playerid);
        case AdminWish_Vehicle:        return IsAdmin(playerid, ADMIN_LVL_9) || PlayerData[playerid][pDynamicAdmin];
        case AdminWish_TmpVehicle:     return IsAdmin(playerid, ADMIN_LVL_4);
        case AdminWish_Skin:           return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_DoubleXP:       return IsAdmin(playerid, ADMIN_LVL_9) || PlayerData[playerid][pDynamicAdmin];
        case AdminWish_Diamonds:       return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Materials:      return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Seeds:          return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Weed:           return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Cocaine:        return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Heroin:         return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Chems:          return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_FirstAid:       return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Painkillers:    return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Cigars:         return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Bodykits:       return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_Spraycans:      return IsAdmin(playerid, ADMIN_LVL_5);
        case AdminWish_GasCan:         return IsAdmin(playerid, ADMIN_LVL_5);
    }
    return false;
}

stock GetAdminWishTargetStr(playerid)
{
    new target[32];
    if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_PlayerId)
    {
        GetPlayerName(AdminWishInfo[playerid][AdminWish_TargetID], target, 32);
    }
    else if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_NearestPlayers)
    {
        target = "nearest players";
    }
    else if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_AllPlayers)
    {
        target = "all players";
    }
    else
    {
        target = "unknown";
    }
    return target;
}

ShowAdminConfirmWishDlg(playerid)
{
    new string[512];
    new targetstr[32];
    new AdminWish:wish = AdminWishInfo[playerid][AdminWish_Type];
    new nbArgs = AdminWishNbParams(wish);
    targetstr = GetAdminWishTargetStr(playerid);

    switch (wish)
    {
        case AdminWish_Vehicle, AdminWish_TmpVehicle:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to give %s a {DB6C72}%s{FFFFFF}?",
                   targetstr, GetVehicleNameByModel(AdminWishInfo[playerid][AdminWish_Param1]));
        }
        case AdminWish_DoubleXP:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to give %s double XP for {82AAFF}%d hours{FFFFFF}?",
                   targetstr, AdminWishInfo[playerid][AdminWish_Param1]);
        }
        case AdminWish_VIP:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to give %s a {D909D9}%s{FFFFFF} VIP package for {82AAFF}%d days{FFFFFF}?", targetstr,
                   GetVIPRank(AdminWishInfo[playerid][AdminWish_Param1]),  AdminWishInfo[playerid][AdminWish_Param2]);
        }
        case AdminWish_HP:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to set the HP of %s to {82AAFF}%d{FFFFFF}?", targetstr,
                   AdminWishInfo[playerid][AdminWish_Param1]);
        }
        case AdminWish_Armor:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to set the armor of %s to {82AAFF}%d{FFFFFF}?", targetstr,
                   AdminWishInfo[playerid][AdminWish_Param1]);
        }
        case AdminWish_Skin:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to set the skin of %s to {82AAFF}[%d] %s{FFFFFF}?", targetstr,
                   AdminWishInfo[playerid][AdminWish_Param1], GetSkinName(AdminWishInfo[playerid][AdminWish_Param1]));
        }
        case AdminWish_Money:
        {
            format(string, sizeof(string), "{FFFFFF}Are you sure to give {82AAFF}%s{FFFFFF} to %s?",
                   FormatCash(AdminWishInfo[playerid][AdminWish_Param1]), targetstr);
        }
        default:
        {
            if (nbArgs == 0)
            {
                format(string, sizeof(string), "{FFFFFF}Are you sure to give %s {DB6C72}%s{FFFFFF}.", targetstr, AdminWishToString(wish));
            }
            else if (nbArgs == 1)
            {
                format(string, sizeof(string), "{FFFFFF}Are you sure to give %s {82AAFF}%d {DB6C72}%s{FFFFFF}?", targetstr,
                       AdminWishInfo[playerid][AdminWish_Param1],  AdminWishToString(wish));
            }
        }
    }
    Dialog_Show(playerid, AdminConfirmWish, DIALOG_STYLE_MSGBOX, "Wish confirmation", string, "Confirm", "Cancel");
}

Dialog:AdminConfirmWish(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_PlayerId)
    {
        GiveWishToPlayer(playerid,
            AdminWishInfo[playerid][AdminWish_TargetID],
            AdminWishInfo[playerid][AdminWish_Type],
            AdminWishInfo[playerid][AdminWish_Param1],
            AdminWishInfo[playerid][AdminWish_Param2]);
    }
    else if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_NearestPlayers)
    {
        if (!IsGodAdmin(playerid) && !IsAdmin(playerid, ADMIN_LVL_6))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized.");
        }
        foreach(new i : Player)
        {
            if (IsPlayerNearPlayer(i, playerid, 50.0) && IsPlayerLoggedIn(playerid))
            {
                GiveWishToPlayer(playerid,
                    i,
                    AdminWishInfo[playerid][AdminWish_Type],
                    AdminWishInfo[playerid][AdminWish_Param1],
                    AdminWishInfo[playerid][AdminWish_Param2]);
            }
        }
        SendClientMessage(playerid, COLOR_WHITE, "An admin has revived everyone nearby.");
    }
    else if (AdminWishInfo[playerid][AdminWish_TargetType] == WishTargetType_AllPlayers)
    {
        if (!IsGodAdmin(playerid))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized.");
        }

        foreach(new i : Player)
        {
            if (IsPlayerLoggedIn(playerid))
            {
                GiveWishToPlayer(playerid,
                    i,
                    AdminWishInfo[playerid][AdminWish_Type],
                    AdminWishInfo[playerid][AdminWish_Param1],
                    AdminWishInfo[playerid][AdminWish_Param2]);
            }
        }
        SendClientMessage(playerid, COLOR_WHITE, "An admin has revived everyone nearby.");
    }

    return 1;
}
