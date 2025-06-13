/// @file      Gang.inc
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-05-27 11:41:04 +0100
/// @copyright Copyright (c) 2022

#include "gang/Turf.pwn"
#include "gang/Membership.pwn"
#include "gang/GangManagement.pwn"

#include <YSI\y_hooks>

hook OnGameModeInit()
{
    // For Mafia
    CreateDynamicPickup(1239, 1, -1020.692993, -715.588500, 32.007812);
    CreateDynamic3DTextLabel("Craft table\ntype /gsellgun to sell a weapon.", COLOR_YELLOW, -1020.692993, -715.588500, 32.007812, 10.0);
    // For Grove
	CreateDynamicPickup(1239, 1, 2490.970458, -1668.314819, 3003.500000);
    CreateDynamic3DTextLabel("Craft table\ntype /gsellgun to sell a weapon.", COLOR_YELLOW, 2490.970458, -1668.314819, 3003.500000, 5.0);
	// For Ballas
	CreateDynamicPickup(1239, 1, 2267.837890, -1668.380737, 3003.500000);
    CreateDynamic3DTextLabel("Craft table\ntype /gsellgun to sell a weapon.", COLOR_YELLOW, 2267.837890, -1668.380737, 3003.500000, 5.0);
	// For Vagos
	CreateDynamicPickup(1239, 1, 2333.931640, -1668.372680, 3003.500000);
    CreateDynamic3DTextLabel("Craft table\ntype /gsellgun to sell a weapon.", COLOR_YELLOW, 2333.931640, -1668.372680, 3003.500000, 5.0);
	// For Varios
	CreateDynamicPickup(1239, 1, 2402.145263, -1668.372314, 3003.500000);
    CreateDynamic3DTextLabel("Craft table\ntype /gsellgun to sell a weapon.", COLOR_YELLOW, 2402.145263, -1668.372314, 3003.500000, 5.0);
}

GetGangColor(gangid)
{
    return (GangInfo[gangid][gColor] >>> 8);
}

IsGangLeader(playerid, gangid)
{
    return  IsPlayerConnected(playerid) && IsPlayerLoggedIn(playerid) &&
            (PlayerData[playerid][pGang] >= 0) &&
            (PlayerData[playerid][pID] == GangInfo[gangid][gLeaderUID]);
}

publish GetPlayerGangId(playerid)
{
    return PlayerData[playerid][pGang];
}

Dialog:DIALOG_GANGSTASH(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHWEAPONS1);
            }
            case 1:
            {
                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHVEST);
            }
            case 2:
            {
                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS1);
            }
            case 3:
            {
                if (!GetGangSkinCount(PlayerData[playerid][pGang]))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "There are no skins setup for your gang.");
                }

                PlayerData[playerid][pSkinSelected] = -1;
                Dialog_Show(playerid, DIALOG_GANGSKINS, DIALOG_STYLE_MSGBOX, "Skin selection", "Press {00AA00}>> Next{A9C4E4} to browse through available gang skins.", ">> Next", "Confirm");
            }
            case 4:
            {
                if (PlayerData[playerid][pGangRank] < 5)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 5+ to craft weapons.");
                }

                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCRAFT);
            }
            case 5:
            {
                PlayerData[playerid][pSelected] = ITEM_MATERIALS;
                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
            }
            case 6:
            {
                PlayerData[playerid][pSelected] = ITEM_CASH;
                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
            }
        }
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHVEST(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gVestRank])
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least rank %i+ to craft kevlar vests.", GangInfo[PlayerData[playerid][pGang]][gVestRank]);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gMaterials] < 200)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "There aren't enough materials in the safe for kevlar vests.");
                }
                if (GetPlayerArmourEx(playerid) >= 100)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You have a full vest already.");
                }

                GangInfo[PlayerData[playerid][pGang]][gMaterials] -= 200;
                SetScriptArmour(playerid, 100.0);

                DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMaterials], PlayerData[playerid][pGang]);


                ShowActionBubble(playerid, "* %s takes a kevlar vest from the gang stash.", GetRPName(playerid));
                SendClientMessage(playerid, COLOR_AQUA, "You crafted a kevlar vest using 200 materials from the safe.");
                DBLog("log_gang", "%s (uid: %i) crafts a kevlar vest using 200 materials from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);

            }
            case 1:
            {
                if (PlayerData[playerid][pGangRank] < 6)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to change the vest rank.");
                }

                Dialog_Show(playerid, DIALOG_GANGSTASHVESTRANK, DIALOG_STYLE_LIST, "Choose a rank to restrict vests to:", "R0+\nR1+\nR2+\nR3+\nR4+\nR5+\nR6", "Select", "Back");
            }
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHVESTRANK(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        GangInfo[PlayerData[playerid][pGang]][gVestRank] = listitem;
        SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Kevlar vests{33CCFF} to rank %i+.", listitem);

        DBQuery("UPDATE "#TABLE_GANGS" SET rank_vest = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

    }

    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHVEST);
    return 1;
}
Dialog:DIALOG_GANGSTASHWEAPONS1(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }
    if (response)
    {
        PlayerData[playerid][pSelected] = listitem;
        Dialog_Show(playerid, DIALOG_GANGSTASHWEAPONS2, DIALOG_STYLE_LIST, "Gang stash | Weapons", "Withdraw\nDeposit\nChange Rank", "Select", "Back");
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHWEAPONS2(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }
    if (response)
    {
        if (listitem == 0)
        {
            if (PlayerData[playerid][pGangRank] < 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You cannot withdraw weapons.");
            }
            if (PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
            }

            switch (PlayerData[playerid][pSelected])
            {
                case GANGWEAPON_9MM:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_9MM])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 22))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM]--;
                    GivePlayerWeaponEx(playerid, 22);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_9mm = weapon_9mm - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a 9mm from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a 9mm from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_SDPISTOL:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SDPISTOL])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 23))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL]--;
                    GivePlayerWeaponEx(playerid, 23);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_sdpistol = weapon_sdpistol - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a silenced pistol from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a silenced pistol from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_DEAGLE:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_DEAGLE])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 24))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE]--;
                    GivePlayerWeaponEx(playerid, 24);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_deagle = weapon_deagle - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a Desert Eagle from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a Desert Eagle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_SHOTGUN:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SHOTGUN])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 25))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN]--;
                    GivePlayerWeaponEx(playerid, 25);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_shotgun = weapon_shotgun - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a shotgun from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a shotgun from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_TEC9:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_TEC9])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 32))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9]--;
                    GivePlayerWeaponEx(playerid, 32);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_tec9 = weapon_tec9 - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a Tec-9 from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a Tec-9 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_UZI:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_UZI])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 28))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI]--;
                    GivePlayerWeaponEx(playerid, 28);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_uzi = weapon_uzi - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a Micro Uzi from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a Micro Uzi from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_MP5:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_MP5])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 29))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5]--;
                    GivePlayerWeaponEx(playerid, 29);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_mp5 = weapon_mp5 - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws an MP5 from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws an MP5 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_AK47:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_AK47])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 30))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47]--;
                    GivePlayerWeaponEx(playerid, 30);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_ak47 = weapon_ak47 - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws an AK-47 from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws an AK-47 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_RIFLE:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_RIFLE])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 33))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE]--;
                    GivePlayerWeaponEx(playerid, 33);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_rifle = weapon_rifle - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a rifle from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a rifle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_M4:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_M4])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 31))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4]--;
                    GivePlayerWeaponEx(playerid, 31);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_m4 = weapon_m4 - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a M4 from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a M4 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_SPAS12:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SPAS12])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 27))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12]--;
                    GivePlayerWeaponEx(playerid, 27);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_spas12 = weapon_spas12 - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a spas12 from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a spas12 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_SNIPER:
                {
                    if (PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SNIPER])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
                    }
                    if (GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER] <= 0)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
                    }
                    if (PlayerHasWeapon(playerid, 34))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER]--;
                    GivePlayerWeaponEx(playerid, 34);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_sniper = weapon_sniper - 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s withdraws a sniper from the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) withdraws a sniper from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
            }
        }
        else if (listitem == 1)
        {
            if (IsLawEnforcement(playerid))
            {
                return SendClientMessage(playerid, COLOR_GREY, "Law enforcement is prohibited from storing weapons.");
            }
            if (GetPlayerHealthEx(playerid) < 60)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't store weapons as your health is below 60.");
            }

            switch (PlayerData[playerid][pSelected])
            {
                case GANGWEAPON_9MM:
                {
                    if (!PlayerHasWeapon(playerid, 22))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM]++;
                    RemovePlayerWeapon(playerid, 22);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_9mm = weapon_9mm + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a 9mm in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a 9mm in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_SDPISTOL:
                {
                    if (!PlayerHasWeapon(playerid, 23))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL]++;
                    RemovePlayerWeapon(playerid, 23);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_sdpistol = weapon_sdpistol + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a silenced pistol in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a silenced pistol in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_DEAGLE:
                {
                    if (!PlayerHasWeapon(playerid, 24))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE]++;
                    RemovePlayerWeapon(playerid, 24);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_deagle = weapon_deagle + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a Desert Eagle in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a Desert Eagle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_SHOTGUN:
                {
                    if (!PlayerHasWeapon(playerid, 25))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN]++;
                    RemovePlayerWeapon(playerid, 25);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_shotgun = weapon_shotgun + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a shotgun in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a shotgun in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_M4,GANGWEAPON_SPAS12,GANGWEAPON_SNIPER:
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't store this weapon.");
                }
                //case GANGWEAPON_SPAS12:
                //{
                //    if (!PlayerHasWeapon(playerid, 27))
                //    {
                //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                //  }
                //
                //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12]++;
                //    RemovePlayerWeapon(playerid, 27);
                //
                //    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_spas12 = weapon_spas12 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
                //
                //    ShowActionBubble(playerid, "* %s deposits a SPAS-12 in the gang stash.", GetRPName(playerid));
                //    DBLog("log_gang", "%s (uid: %i) deposits a SPAS-12 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                //}
                //case GANGWEAPON_SAWNOFF:
                //{
                //    if (!PlayerHasWeapon(playerid, 26))
                //    {
                //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                //  }
                //
                //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SAWNOFF]++;
                //    RemovePlayerWeapon(playerid, 26);
                //
                //    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_sawnoff = weapon_sawnoff + 1 WHERE id = %i", PlayerData[playerid][pGang]);
                //
                //    ShowActionBubble(playerid, "* %s deposits a sawnoff shotgun in the gang stash.", GetRPName(playerid));
                //    DBLog("log_gang", "%s (uid: %i) deposits a sawnoff shotgun in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                //}
                case GANGWEAPON_TEC9:
                {
                    if (!PlayerHasWeapon(playerid, 32))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9]++;
                    RemovePlayerWeapon(playerid, 32);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_tec9 = weapon_tec9 + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a Tec-9 in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a Tec-9 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_UZI:
                {
                    if (!PlayerHasWeapon(playerid, 28))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI]++;
                    RemovePlayerWeapon(playerid, 28);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_uzi = weapon_uzi + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a Micro Uzi in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a Micro Uzi in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_MP5:
                {
                    if (!PlayerHasWeapon(playerid, 29))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5]++;
                    RemovePlayerWeapon(playerid, 29);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_mp5 = weapon_mp5 + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits an MP5 in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits an MP5 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                case GANGWEAPON_AK47:
                {
                    if (!PlayerHasWeapon(playerid, 30))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47]++;
                    RemovePlayerWeapon(playerid, 30);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_ak47 = weapon_ak47 + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits an AK-47 in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits an AK-47 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                //case GANGWEAPON_M4:
                //{
                //    if (!PlayerHasWeapon(playerid, 31))
                //    {
                //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                //  }
                //
                //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4]++;
                //    RemovePlayerWeapon(playerid, 31);
                //
                //    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_m4 = weapon_m4 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
                //
                //    ShowActionBubble(playerid, "* %s deposits an M4 in the gang stash.", GetRPName(playerid));
                //    DBLog("log_gang", "%s (uid: %i) deposits an M4 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                //}
                case GANGWEAPON_RIFLE:
                {
                    if (!PlayerHasWeapon(playerid, 33))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                    }

                    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE]++;
                    RemovePlayerWeapon(playerid, 33);

                    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_rifle = weapon_rifle + 1 WHERE id = %i", PlayerData[playerid][pGang]);


                    ShowActionBubble(playerid, "* %s deposits a rifle in the gang stash.", GetRPName(playerid));
                    DBLog("log_gang", "%s (uid: %i) deposits a rifle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                }
                //      case GANGWEAPON_SNIPER:
                //{
                //    if (!PlayerHasWeapon(playerid, 34))
                //    {
                //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                //  }
                //
                //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER]++;
                //    RemovePlayerWeapon(playerid, 34);
                //
                //    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_sniper = weapon_sniper + 1 WHERE id = %i", PlayerData[playerid][pGang]);
                //
                //    ShowActionBubble(playerid, "* %s deposits a sniper rifle in the gang stash.", GetRPName(playerid));
                //    DBLog("log_gang", "%s (uid: %i) deposits a sniper rifle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                //}
                //case GANGWEAPON_MOLOTOV:
                //{
                //    if (!PlayerHasWeapon(playerid, 18))
                //    {
                //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
                //  }
                //
                //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MOLOTOV]++;
                //    RemovePlayerWeapon(playerid, 18);
                //
                //    DBQuery("UPDATE "#TABLE_GANGS" SET weapon_molotov = weapon_molotov + 1 WHERE id = %i", PlayerData[playerid][pGang]);
                //
                //    ShowActionBubble(playerid, "* %s deposits a molotov in the gang stash.", GetRPName(playerid));
                //    DBLog("log_gang", "%s (uid: %i) deposits a molotov in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                //}
            }
        }
        else if (listitem == 2)
        {
            if (PlayerData[playerid][pGangRank] < 6)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to edit weapon ranks.");
            }

            Dialog_Show(playerid, GangStashWeaponRank, DIALOG_STYLE_LIST, "Choose a rank to restrict withdrawals to:", "R0+\nR1+\nR2+\nR3+\nR4+\nR5+\nR6", "Select", "Back");
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHWEAPONS1);
    }
    return 1;
}
Dialog:GangStashWeaponRank(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        switch (PlayerData[playerid][pSelected])
        {
            case GANGWEAPON_9MM:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_9MM] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}9mm{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_9mm = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_SDPISTOL:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SDPISTOL] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Silenced pistol{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_9mm = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_DEAGLE:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_DEAGLE] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Desert Eagle{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_deagle = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_SHOTGUN:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SHOTGUN] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Shotgun{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_shotgun = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_TEC9:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_TEC9] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Tec-9{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_tec9 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_UZI:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_UZI] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Micro Uzi{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_uzi = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_MP5:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_MP5] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}MP5{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_mp5 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_AK47:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_AK47] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}AK-47{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_ak47 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_RIFLE:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_RIFLE] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Rifle{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_rifle = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_M4:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_M4] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}M4{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_m4 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_SPAS12:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SPAS12] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Spas12{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_spas12 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
            case GANGWEAPON_SNIPER:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SNIPER] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Sniper{33CCFF} to rank %i+.", listitem);

                DBQuery("UPDATE "#TABLE_GANGS" SET rank_sniper = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);

            }
        }

        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHWEAPONS1);
    }
    else
    {
        Dialog_Show(playerid, DIALOG_GANGSTASHWEAPONS2, DIALOG_STYLE_LIST, "Gang stash | Weapons", "Withdraw\nDeposit\nChange Rank", "Select", "Back");
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHDRUGS1(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0: PlayerData[playerid][pSelected] = ITEM_WEED;
            case 1: PlayerData[playerid][pSelected] = ITEM_COCAINE;
            case 2: PlayerData[playerid][pSelected] = ITEM_HEROIN;
            case 3: PlayerData[playerid][pSelected] = ITEM_PAINKILLERS;
        }

        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHDRUGS2(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        if (listitem == 0)
        {
            if (PlayerData[playerid][pGangRank] < 2)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 2+ in order to withdraw drugs.");
            }

            ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
        }
        else if (listitem == 1)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS1);
    }
    return 1;
}
Dialog:DIALOG_GANGWITHDRAW(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 3)
    {
        return 1;
    }

    if (response)
    {
        new amount;

        if (sscanf(inputtext, "i", amount))
        {
            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
        }

        switch (PlayerData[playerid][pSelected])
        {
            case ITEM_WEED:
            {
                if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gWeed])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }
                if (PlayerData[playerid][pWeed] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }

                GangInfo[PlayerData[playerid][pGang]][gWeed] -= amount;
                PlayerData[playerid][pWeed] += amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET weed = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gWeed], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s withdraws some weed from the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i grams of weed from the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) withdraws %i grams of weed from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_COCAINE:
            {
                if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gCocaine])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }
                if (PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }

                GangInfo[PlayerData[playerid][pGang]][gCocaine] -= amount;
                PlayerData[playerid][pCocaine] += amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET cocaine = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCocaine], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s withdraws some cocaine from the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i grams of cocaine from the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) withdraws %i grams of cocaine from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_HEROIN:
            {
                if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gHeroin])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }
                if (PlayerData[playerid][pHeroin] + amount > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }

                GangInfo[PlayerData[playerid][pGang]][gHeroin] -= amount;
                PlayerData[playerid][pHeroin] += amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET heroin = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gHeroin], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s withdraws some Heroin from the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i grams of Heroin from the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) withdraws %i grams of Heroin from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_PAINKILLERS:
            {
                if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gPainkillers])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }
                if (PlayerData[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }

                GangInfo[PlayerData[playerid][pGang]][gPainkillers] -= amount;
                PlayerData[playerid][pPainkillers] += amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET painkillers = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPainkillers], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s withdraws some painkillers from the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i painkillers from the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) withdraws %i painkillers from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_MATERIALS:
            {
                if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gMaterials])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }
                if (PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }

                GangInfo[PlayerData[playerid][pGang]][gMaterials] -= amount;
                PlayerData[playerid][pMaterials] += amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMaterials], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s withdraws some materials from the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i materials from the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) withdraws %i materials from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_CASH:
            {
                if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gCash])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
                }

                GangInfo[PlayerData[playerid][pGang]][gCash] -= amount;
                GivePlayerCash(playerid, amount);

                DBQuery("UPDATE "#TABLE_GANGS" SET cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCash], PlayerData[playerid][pGang]);


                ShowActionBubble(playerid, "* %s withdraws some cash from the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %s from the gang stash.", FormatCash(amount));
                DBLog("log_gang", "%s (uid: %i) withdraws $%i from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
        }
    }
    else
    {
        if (PlayerData[playerid][pSelected] == ITEM_MATERIALS)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
        }
        else if (PlayerData[playerid][pSelected] == ITEM_CASH)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
        }
        else
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
        }
    }
    return 1;
}
Dialog:DIALOG_GANGDEPOSIT(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if (response)
    {
        new amount;

        if (sscanf(inputtext, "i", amount))
        {
            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
        }

        switch (PlayerData[playerid][pSelected])
        {
            case ITEM_WEED:
            {
                if (amount < 1 || amount > PlayerData[playerid][pWeed])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gWeed] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i grams of weed.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }

                GangInfo[PlayerData[playerid][pGang]][gWeed] += amount;
                PlayerData[playerid][pWeed] -= amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET weed = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gWeed], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s deposits some weed in the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i grams of weed in the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) deposits %i grams of weed in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_COCAINE:
            {
                if (amount < 1 || amount > PlayerData[playerid][pCocaine])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gCocaine] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i grams of cocaine.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }

                GangInfo[PlayerData[playerid][pGang]][gCocaine] += amount;
                PlayerData[playerid][pCocaine] -= amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET cocaine = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCocaine], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s deposits some cocaine in the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i grams of cocaine in the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) deposits %i grams of cocaine in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_HEROIN:
            {
                if (amount < 1 || amount > PlayerData[playerid][pHeroin])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gHeroin] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i grams of heroin.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }

                GangInfo[PlayerData[playerid][pGang]][gHeroin] += amount;
                PlayerData[playerid][pHeroin] -= amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET heroin = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gHeroin], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s deposits some Heroin in the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i grams of Heroin in the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) deposits %i grams of Heroin in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_PAINKILLERS:
            {
                if (amount < 1 || amount > PlayerData[playerid][pPainkillers])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gPainkillers] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i painkillers.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }

                GangInfo[PlayerData[playerid][pGang]][gPainkillers] += amount;
                PlayerData[playerid][pPainkillers] -= amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET painkillers = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPainkillers], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s deposits some painkillers in the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i painkillers in the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) deposits %i painkillers in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_MATERIALS:
            {
                if (amount < 1 || amount > PlayerData[playerid][pMaterials])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gMaterials] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i materials.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }

                GangInfo[PlayerData[playerid][pGang]][gMaterials] += amount;
                PlayerData[playerid][pMaterials] -= amount;

                DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMaterials], PlayerData[playerid][pGang]);


                DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


                ShowActionBubble(playerid, "* %s deposits some materials in the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i materials in the gang stash.", amount);
                DBLog("log_gang", "%s (uid: %i) deposits %i materials in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
            case ITEM_CASH:
            {
                if (amount < 1 || amount > PlayerData[playerid][pCash])
                {
                    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gCash] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH))
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than $%i.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH));
                    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
                }

                GangInfo[PlayerData[playerid][pGang]][gCash] += amount;
                GivePlayerCash(playerid, -amount);

                DBQuery("UPDATE "#TABLE_GANGS" SET cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCash], PlayerData[playerid][pGang]);


                ShowActionBubble(playerid, "* %s deposits some cash in the gang stash.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i in the gang stash.", FormatCash(amount));
                DBLog("log_gang", "%s (uid: %i) deposited $%i in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
            }
        }
    }
    else
    {
        if (PlayerData[playerid][pSelected] == ITEM_MATERIALS)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
        }
        else if (PlayerData[playerid][pSelected] == ITEM_CASH)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
        }
        else
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
        }
    }
    return 1;
}

stock AddWeaponToGangStash(gangid, weaponid, qty=1)
{
    switch (weaponid)
    {
        case 22:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_9MM] = GangInfo[gangid][gWeapons][GANGWEAPON_9MM]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_9mm = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_9MM], gangid);
        }
        case 23:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL] = GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_sdpistol = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL], gangid);
        }
        case 24:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] = GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_deagle = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE], gangid);
        }
        case 25:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN] = GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_shotgun = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN], gangid);
        }
        case 32:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_TEC9] = GangInfo[gangid][gWeapons][GANGWEAPON_TEC9]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_tec9 = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_TEC9], gangid);
        }
        case 28:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_UZI] = GangInfo[gangid][gWeapons][GANGWEAPON_UZI]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_uzi = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_UZI], gangid);
        }
        case 29:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_MP5] = GangInfo[gangid][gWeapons][GANGWEAPON_MP5]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_mp5 = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_AK47], gangid);
        }
        case 30:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_AK47] = GangInfo[gangid][gWeapons][GANGWEAPON_AK47]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_ak47 = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_AK47], gangid);
        }
        case 33:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE] = GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE]  + qty ;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_rifle = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE], gangid);
        }
        case 31:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_M4] = GangInfo[gangid][gWeapons][GANGWEAPON_M4]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_m4 = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_M4], gangid);
        }
        case 27:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12] = GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12]  + qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_spas12 = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12], gangid);
        }
        case 34:
        {
            GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER] = GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER]  +  qty;
            DBQuery("UPDATE "#TABLE_GANGS" SET materials = %i, weapon_sniper = %i WHERE id = %i",
                GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER], gangid);
        }
        default: return 0;
    }
    return 1;
}

Dialog:DIALOG_GANGSTASHCRAFT(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new weaponid = 0;
        switch (listitem)
        {
            case 0: weaponid = 22; // 9mm
            case 1: weaponid = 23; // Silenced 9mm
            case 2: weaponid = 25; // Shotgun
            case 3: weaponid = 28; // Micro SMG/Uzi
            case 4: weaponid = 32; // Tec-9
            case 5: weaponid = 33; // Country Rifle
        }
        new cost = GetGStashCraftWeaponPrice(weaponid);
        new gangid = PlayerData[playerid][pGang];
        if (weaponid == 0 || cost < 0)
        {
            return 1;
        }

        if (GangInfo[gangid][gMaterials] < cost)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There aren't enough materials in the safe.");
        }

        GangInfo[gangid][gMaterials] -= cost;
        if (AddWeaponToGangStash(gangid, weaponid))
        {
            ShowActionBubble(playerid, "* %s crafts %s and stores it to the gang stash.", GetRPName(playerid), GetWeaponNameEx(weaponid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You used %d materials from your gang stash to craft an %s.", cost, GetWeaponNameEx(weaponid));
            DBLog("log_gang", "%s (uid: %i) crafts an %s using %d materials from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID],
                GetWeaponNameEx(weaponid), cost, GangInfo[gangid][gName], gangid);
            ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCRAFT);
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHMATS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            if (PlayerData[playerid][pGangRank] < 6)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 6+ in order to withdraw materials.");
            }

            ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
        }
        else if (listitem == 1)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    }
    return 1;
}
Dialog:DIALOG_GANGSTASHCASH(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            if (PlayerData[playerid][pGangRank] < 6)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 6+ in order to withdraw cash.");
            }

            ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
        }
        else if (listitem == 1)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    }
    return 1;
}
Dialog:DIALOG_GANGSKINS(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] >= 0)
    {
        if (response)
        {
            new index = PlayerData[playerid][pSkinSelected] + 1;

            if (index >= MAX_GANG_SKINS)
            {
                // When the player is shown the dialog for the first time, their skin isn't chnaged until they click >> Next.
                SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
                PlayerData[playerid][pSkinSelected] = -1;
            }
            else
            {
                // Find the next skin in the array.
                for (new i = index; i < MAX_GANG_SKINS; i ++)
                {
                    if (GangInfo[PlayerData[playerid][pGang]][gSkins][i] != 0)
                    {
                        SetPlayerSkin(playerid, GangInfo[PlayerData[playerid][pGang]][gSkins][i]);
                        PlayerData[playerid][pSkinSelected] = i;
                        break;
                    }
                }

                if (index == PlayerData[playerid][pSkinSelected] + 1)
                {
                    // Looks like there was no skin found. So, we'll go back to the very first valid skin in the skin array.
                    for (new i = 0; i < MAX_GANG_SKINS; i ++)
                    {
                        if (GangInfo[PlayerData[playerid][pGang]][gSkins][i] != 0)
                        {
                            SetPlayerSkin(playerid, GangInfo[PlayerData[playerid][pGang]][gSkins][i]);
                            PlayerData[playerid][pSkinSelected] = i;
                            break;
                        }
                    }
                }
            }

            Dialog_Show(playerid, DIALOG_GANGSKINS, DIALOG_STYLE_MSGBOX, "Skin selection", "Press {00AA00}>> Next{A9C4E4} to browse through available gang skins.", ">> Next", "Confirm");
        }
        else
        {
            PlayerData[playerid][pSkinSelected] = -1;

            SetScriptSkin(playerid, GetPlayerSkin(playerid));
            ShowActionBubble(playerid, "* %s changes their clothes.", GetRPName(playerid));
        }
    }
    return 1;
}
Dialog:DIALOG_GANGFINDCAR(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new count, garageid;

        foreach(new i: Vehicle)
        {
            if ((VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerData[playerid][pGang]) && (count++ == listitem))
            {
                if ((garageid = GetVehicleGarage(i)) >= 0)
                {
                    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "This %s is located in a garage. Checkpoint marked at the garage's location.", GetVehicleName(i));
                }
                else
                {
                    new Float:x, Float:y, Float:z;
                    GetVehiclePos(i, x, y, z);
                    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 3.0);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "This %s is located in %s. Checkpoint marked at the location.", GetVehicleName(i), GetZoneName(x, y, z));
                }
                return 1;
            }
        }
    }
    return 1;
}
Dialog:DIALOG_GANGPOINTSHOP(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < 50000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You need $50,000 on hand to purchase this upgrade.");
                }
                if (GangInfo[PlayerData[playerid][pGang]][gDrugDealer])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang already has this upgrade.");
                }
                //TODO: NPC Drug dealer
                GangInfo[PlayerData[playerid][pGang]][gDrugDealer] = 1;
                GangInfo[PlayerData[playerid][pGang]][gDrugX] = 0.0;
                GangInfo[PlayerData[playerid][pGang]][gDrugY] = 0.0;
                GangInfo[PlayerData[playerid][pGang]][gDrugZ] = 0.0;
                GangInfo[PlayerData[playerid][pGang]][gDrugWeed] = 0;
                GangInfo[PlayerData[playerid][pGang]][gDrugHeroin] = 0;
                GangInfo[PlayerData[playerid][pGang]][gDrugCocaine] = 0;
                GangInfo[PlayerData[playerid][pGang]][gDrugPrices][0] = 500;
                GangInfo[PlayerData[playerid][pGang]][gDrugPrices][1] = 1000;
                GangInfo[PlayerData[playerid][pGang]][gDrugPrices][2] = 1500;
                GangInfo[PlayerData[playerid][pGang]][gPoints] -= 500;

                DBQuery("UPDATE "#TABLE_GANGS" SET drugdealer = 1, drug_x = 0.0, drug_y = 0.0, drug_z = 0.0, drugweed = 0, drugcocaine = 0, drugheroin = 0, weed_price = 500, cocaine_price = 1000, heroin_price = 1500, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
                GivePlayerCash(playerid, -50000);
                SendClientMessage(playerid, COLOR_AQUA, "You have spent 500 GP & $50,000 on an {00AA00}NPC drug dealer{33CCFF}. '/gang npc' to edit your drug dealer.");
                DBLog("log_gang", "%s (uid: %i) spent 500 GP & $50000 on an NPC drug dealer for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
            }
            case 1:
            {
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < 50000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You need $50,000 on hand to purchase this upgrade.");
                }
                if (GangInfo[PlayerData[playerid][pGang]][gArmsDealer])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang already has this upgrade.");
                }

                GangInfo[PlayerData[playerid][pGang]][gArmsDealer] = 1;
                GangInfo[PlayerData[playerid][pGang]][gArmsX] = 0.0;
                GangInfo[PlayerData[playerid][pGang]][gArmsY] = 0.0;
                GangInfo[PlayerData[playerid][pGang]][gArmsZ] = 0.0;
                GangInfo[PlayerData[playerid][pGang]][gArmsMaterials] = 0;
                GangInfo[PlayerData[playerid][pGang]][gPoints] -= 500;

                DBQuery("UPDATE "#TABLE_GANGS" SET armsdealer = 1, arms_x = 0.0, arms_y = 0.0, arms_z = 0.0, armsmaterials = 0, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);


                GivePlayerCash(playerid, -50000);
                SendClientMessage(playerid, COLOR_AQUA, "You have spent 500 GP & $50,000 on an {00AA00}NPC arms dealer{33CCFF}. '/gang npc' to edit your arms dealer.");
                DBLog("log_gang", "%s (uid: %i) spent 500 GP & $50000 on an NPC arm dealer for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
            }
            case 2:
            {
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 400)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < 75000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You need $75,000 on hand to purchase this upgrade.");
                }

                GivePlayerCash(playerid, -75000);
                GiveGangPoints(PlayerData[playerid][pGang], -400);

                DBQuery("INSERT INTO flags VALUES(null, %i, 'Gang point redemption', NOW(), 'Duel arena')", PlayerData[playerid][pID]);


                SendClientMessage(playerid, COLOR_AQUA, "You have spent 400 GP & $75,000 on a {00AA00}Duel arena{33CCFF}. /report for an admin to set it up.");
                SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a duel arena for their gang.", GetRPName(playerid), playerid);
            }
            case 3:
            {
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 4500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < 100000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You need $100,000 on hand to purchase this upgrade.");
                }

                GivePlayerCash(playerid, -100000);
                GiveGangPoints(PlayerData[playerid][pGang], -4500);

                DBQuery("INSERT INTO flags VALUES(null, %i, 'Gang point redemption', NOW(), 'Gang mapping (up to 50 objects)')", PlayerData[playerid][pID]);


                SendClientMessage(playerid, COLOR_AQUA, "You have spent 4500 GP & $100,000 on {00AA00}Mapping{33CCFF}. /report for an admin to set it up.");
                SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for mapping for their gang.", GetRPName(playerid), playerid);
            }
            case 4:
            {
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 5000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < 100000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You need $100,000 on hand to purchase this upgrade.");
                }

                GivePlayerCash(playerid, -100000);
                GiveGangPoints(PlayerData[playerid][pGang], -5000);

                DBQuery("INSERT INTO flags VALUES(null, %i, 'Gang point redemption', NOW(), 'Custom gang interior')", PlayerData[playerid][pID]);


                SendClientMessage(playerid, COLOR_AQUA, "You have spent 5000 GP & $100,000 on {00AA00}Custom gang interior{33CCFF}. /report for an admin to set it up.");
                SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a custom gang interior.", GetRPName(playerid), playerid);
            }
            case 5:
            {
                new cashNeeded = 100000 + (50000*GangInfo[PlayerData[playerid][pGang]][gMatLevel]);
                new pointsNeeded = 1500 + (500*GangInfo[PlayerData[playerid][pGang]][gMatLevel]);
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < pointsNeeded)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < cashNeeded)
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You need $%i on hand to purchase this upgrade.", cashNeeded);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gMatLevel] + 1 > 3)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang's materials upgrade is already maxed out. (3/3)");
                }

                GangInfo[PlayerData[playerid][pGang]][gMatLevel]++;
                GangInfo[PlayerData[playerid][pGang]][gPoints] -= pointsNeeded;
                GivePlayerCash(playerid, -cashNeeded);
                DBQuery("UPDATE "#TABLE_GANGS" SET matlevel = %i, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMatLevel], GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);


                SendClientMessageEx(playerid, COLOR_GREEN, "You have spent %i GP & $%i for materials upgrade %i/3", pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gMatLevel]);
                SendClientMessageEx(playerid, COLOR_GREEN, "Your gang will now receive %i materials from each material-class turf captured.", (10000+(5000*GangInfo[PlayerData[playerid][pGang]][gMatLevel])));

                DBLog("log_gang", "%s (uid: %i) spent %i GP & $%i for gang level %i/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gMatLevel], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
            }
            case 6:
            {
                new cashNeeded = 40000 + (20000 * GangInfo[PlayerData[playerid][pGang]][gGunLevel]);
                new pointsNeeded = 1500 + (250*GangInfo[PlayerData[playerid][pGang]][gGunLevel]);
                if (GangInfo[PlayerData[playerid][pGang]][gPoints] < pointsNeeded)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                }
                if (PlayerData[playerid][pCash] < cashNeeded)
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You need $%i on hand to purchase this upgrade.", cashNeeded);
                }
                if (GangInfo[PlayerData[playerid][pGang]][gGunLevel] + 1 > 5)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang's gun upgrade is already maxed out. (5/5");
                }

                GangInfo[PlayerData[playerid][pGang]][gGunLevel]++;
                GangInfo[PlayerData[playerid][pGang]][gPoints] -= pointsNeeded;
                GivePlayerCash(playerid, -cashNeeded);
                DBQuery("UPDATE "#TABLE_GANGS" SET gunlevel = %i, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gGunLevel], GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);


                SendClientMessageEx(playerid, COLOR_GREEN, "You have spent %i GP & $%i for guns upgrade %i/5", pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gGunLevel]);
                SendClientMessageEx(playerid, COLOR_GREEN, "Your gang will now receive %i guns from each weapon-class turf captured.", (10+GangInfo[PlayerData[playerid][pGang]][gGunLevel]));


                DBLog("log_gang", "%s (uid: %i) spent %i GP & $%i for gang level %i/5 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gGunLevel], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
            }
            case 7:
            {
                switch (GangInfo[PlayerData[playerid][pGang]][gLevel])
                {
                    case 1:
                    {
                        if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 6000)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                        }
                        if (PlayerData[playerid][pCash] < 75000)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You need $75,000 on hand to purchase this upgrade.");
                        }

                        GangInfo[PlayerData[playerid][pGang]][gLevel] = 2;
                        GangInfo[PlayerData[playerid][pGang]][gPoints] -= 6000;

                        DBQuery("UPDATE "#TABLE_GANGS" SET level = 2, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);


                        GivePlayerCash(playerid, -75000);
                        ReloadGang(PlayerData[playerid][pGang]);

                        SendClientMessageEx(playerid, COLOR_GREEN, "You have spent 6000 GP & $75,000 for gang level 2/3. Your gang can now have %i members & %i gang vehicles.", GetGangMemberLimit(PlayerData[playerid][pGang]), GetGangVehicleLimit(PlayerData[playerid][pGang]));
                        SendClientMessage(playerid, COLOR_GREEN, "Your capacity for items in your gang stash has also been increased. Access your gang stash to learn more!");

                        DBLog("log_gang", "%s (uid: %i) spent 6000 GP & $75000 for gang level 2/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                    }
                    case 2:
                    {
                        if (GangInfo[PlayerData[playerid][pGang]][gPoints] < 12000)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
                        }
                        if (PlayerData[playerid][pCash] < 100000)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You need $100,000 on hand to purchase this upgrade.");
                        }

                        GangInfo[PlayerData[playerid][pGang]][gLevel] = 3;
                        GangInfo[PlayerData[playerid][pGang]][gPoints] -= 12000;

                        DBQuery("UPDATE "#TABLE_GANGS" SET level = 3, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);


                        GivePlayerCash(playerid, -100000);
                        ReloadGang(PlayerData[playerid][pGang]);

                        SendClientMessageEx(playerid, COLOR_GREEN, "You have spent 12000 GP & $100,000 for gang level 3/3. Your gang can now have %i members & %i gang vehicles.", GetGangMemberLimit(PlayerData[playerid][pGang]), GetGangVehicleLimit(PlayerData[playerid][pGang]));
                        SendClientMessage(playerid, COLOR_GREEN, "Your capacity for items in your gang stash has also been increased. Access your gang stash to learn more!");

                        DBLog("log_gang", "%s (uid: %i) spent 12000 GP & $100000 for gang level 3/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
                    }
                }
            }
        }
    }
    return 1;
}
Dialog:DIALOG_GANGARMSPRICES(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return 1;
    }

    if (response)
    {
        PlayerData[playerid][pSelected] = listitem;
        Dialog_Show(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item:", "Submit", "Back");
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
    }
    return 1;
}
Dialog:DIALOG_GANGARMSPRICE(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return 1;
    }

    if (response)
    {
        new amount;

        if (sscanf(inputtext, "i", amount))
        {
            return Dialog_Show(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item", "Submit", "Back");
        }
        if (amount < 0)
        {
            SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $0.");
            return Dialog_Show(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item", "Submit", "Back");
        }

        GangInfo[PlayerData[playerid][pGang]][gArmsPrices][PlayerData[playerid][pSelected]] = amount;

        DBQuery("UPDATE "#TABLE_GANGS" SET armsprice_%i = %i WHERE id = %i", PlayerData[playerid][pSelected] + 1, amount, PlayerData[playerid][pGang]);


        if (PlayerData[playerid][pSelected] == 0)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Micro Uzi{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 1)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Tec-9{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 2)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}MP5{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 3)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Desert Eagle{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 4)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Molotov{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 5)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}AK-47{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 6)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}M4{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 7)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Sniper{33CCFF} to $%i.", amount);
        }
        else if (PlayerData[playerid][pSelected] == 8)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Sawnoff Shotgun{33CCFF} to $%i.", amount);
        }
    }

    ShowDialogToPlayer(playerid, DIALOG_GANGARMSPRICES);
    return 1;
}
Dialog:DIALOG_GANGARMSDEALER(playerid, response, listitem, inputtext[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerData[playerid][pDealerGang]][gArmsX], GangInfo[PlayerData[playerid][pDealerGang]][gArmsY], GangInfo[PlayerData[playerid][pDealerGang]][gArmsZ]))
    {
        return 1;
    }

    if (response)
    {
        if (listitem == 0)
        {
            ShowDialogToPlayer(playerid, DIALOG_GANGARMSWEAPONS);
        }
        else if (listitem == 1)
        {
            if (PlayerData[playerid][pGang] != PlayerData[playerid][pDealerGang])
            {
                return SendClientMessage(playerid, COLOR_GREY, "This arms dealer doesn't belong to your gang.");
            }
            if (PlayerData[playerid][pGangRank] < 6)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You need to be rank 6+ in order to edit.");
            }

            ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
        }
    }
    return 1;
}
Dialog:DIALOG_GANGARMSWEAPONS(playerid, response, listitem, inputtext[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerData[playerid][pDealerGang]][gArmsX], GangInfo[PlayerData[playerid][pDealerGang]][gArmsY], GangInfo[PlayerData[playerid][pDealerGang]][gArmsZ]))
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 500;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 28);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a micro uzi.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}micro uzi{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 1:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 500;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 32);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a Tec-9.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}Tec-9{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 2:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 1000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 1000;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 29);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received an MP5.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased an {00AA00}MP5{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 3:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 2000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 2000;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 24);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a Desert Eagle.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}Desert Eagle{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 4:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 5000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 5000;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 18);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a molotov.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}molotov{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 5:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 3000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 3000;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 30);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received an AK-47.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased an {00AA00}AK-47{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 6:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 4000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 4000;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 31);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received an M4.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased an {00AA00}M4{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 7:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 6500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 6500;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 34);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a sniper.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}sniper{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
            case 8:
            {
                if (GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 3000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
                }
                if (PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
                }

                GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 3000;
                GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

                DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);


                GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                GivePlayerWeaponEx(playerid, 26);

                ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a sawnoff shotgun.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}sawnoff shotgun{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
            }
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEALER);
    }
    return 1;
}

Dialog:DIALOG_GANGARMSEDIT(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
    }

    if (response)
    {
        switch (listitem)
        {
            case 0: ShowDialogToPlayer(playerid, DIALOG_GANGARMSPRICES);
            case 1: ShowDialogToPlayer(playerid, GangStashDepositMats);
            case 2: ShowDialogToPlayer(playerid, GangStashWithdrawMats);
        }
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_GANGARMSDEALER);
    }
    return 1;
}
Dialog:GangStashDepositMats(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
    }

    if (response)
    {
        new amount;

        if (sscanf(inputtext, "i", amount))
        {
            return ShowDialogToPlayer(playerid, GangStashDepositMats);
        }
        if (amount < 1 || amount > PlayerData[playerid][pMaterials])
        {
            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
            return ShowDialogToPlayer(playerid, GangStashDepositMats);
        }

        GangInfo[PlayerData[playerid][pGang]][gArmsMaterials] += amount;
        PlayerData[playerid][pMaterials] -= amount;

        DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials], PlayerData[playerid][pGang]);


        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "You have deposited %i materials in your arms dealer NPC.", amount);
    }

    ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
    return 1;
}
Dialog:GangStashWithdrawMats(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
    }

    if (response)
    {
        new amount;

        if (sscanf(inputtext, "i", amount))
        {
            return ShowDialogToPlayer(playerid, GangStashWithdrawMats);
        }
        if (amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gArmsMaterials])
        {
            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
            return ShowDialogToPlayer(playerid, GangStashWithdrawMats);
        }

        GangInfo[PlayerData[playerid][pGang]][gArmsMaterials] -= amount;
        PlayerData[playerid][pMaterials] += amount;

        DBQuery("UPDATE "#TABLE_GANGS" SET armsmaterials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials], PlayerData[playerid][pGang]);


        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


        SendClientMessageEx(playerid, COLOR_AQUA, "You have withdrawn %i materials from your arms dealer NPC.", amount);
    }

    ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
    return 1;
}

DB:OnGangInformation(playerid)
{
    new rows = GetDBNumRows();

    if (rows)
    {
        new count, total;


        GetGangTurfsCount(PlayerData[playerid][pGang], count, total);

        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ %s ______", GangInfo[PlayerData[playerid][pGang]][gName]);
        SendClientMessageEx(playerid, COLOR_GREY2, "Leader: %s - Level: %i/3 - Strikes: %i/3 - Members: %i/%i - Vehicles: %i/%i", GangInfo[PlayerData[playerid][pGang]][gLeader], GangInfo[PlayerData[playerid][pGang]][gLevel], GangInfo[PlayerData[playerid][pGang]][gStrikes], GetDBIntFieldFromIndex(0, 0), GetGangMemberLimit(PlayerData[playerid][pGang]), GetGangVehicles(PlayerData[playerid][pGang]), GetGangVehicleLimit(PlayerData[playerid][pGang]));
        SendClientMessageEx(playerid, COLOR_GREY2, "Gang Points: %s GP - Turf Tokens: %s - Cash: $%s/$%s - Materials: %s/%s",
                            FormatNumber(GangInfo[PlayerData[playerid][pGang]][gPoints]), FormatNumber(GangInfo[PlayerData[playerid][pGang]][gTurfTokens]),
                            FormatNumber(GangInfo[PlayerData[playerid][pGang]][gCash]),   FormatNumber(GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH)),
                            FormatNumber(GangInfo[PlayerData[playerid][pGang]][gMaterials]), FormatNumber(GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS)));
        SendClientMessageEx(playerid, COLOR_GREY2, "Turfs: %i/%i - Weed: %i/%ig - Cocaine: %i/%ig - Heroin: %i/%ig - Painkillers: %i/%i",
                            count, total, GangInfo[PlayerData[playerid][pGang]][gWeed], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED),
                            GangInfo[PlayerData[playerid][pGang]][gCocaine],     GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE),
                            GangInfo[PlayerData[playerid][pGang]][gHeroin],      GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN),
                            GangInfo[PlayerData[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
    }
    return 1;
}
SetupGang(gangid, name[])
{
    strcpy(GangInfo[gangid][gName], name, 32);
    strcpy(GangInfo[gangid][gMOTD], "None", 128);
    strcpy(GangInfo[gangid][gLeader], "No-one", MAX_PLAYER_NAME);

    GangInfo[gangid][gSetup] = 1;
    GangInfo[gangid][gIsMafia] = 0;
    GangInfo[gangid][gLeaderUID] = 0;
    GangInfo[gangid][gColor] = 0xFFFFFF00;
    GangInfo[gangid][gStrikes] = 0;
    GangInfo[gangid][gLevel] = 1;
    GangInfo[gangid][gPoints] = 0;
    GangInfo[gangid][gTurfTokens] = 0;
    GangInfo[gangid][gStashX] = 0.0;
    GangInfo[gangid][gStashY] = 0.0;
    GangInfo[gangid][gStashZ] = 0.0;
    GangInfo[gangid][gStashInterior] = 0;
    GangInfo[gangid][gStashWorld] = 0;
    GangInfo[gangid][gCash] = 0;
    GangInfo[gangid][gMaterials] = 0;
    GangInfo[gangid][gWeed] = 0;
    GangInfo[gangid][gCocaine] = 0;
    GangInfo[gangid][gHeroin] = 0;
    GangInfo[gangid][gPainkillers] = 0;
    GangInfo[gangid][gArmsDealer] = 0;
    GangInfo[gangid][gDrugDealer] = 0;
    GangInfo[gangid][gArmsX] = 0.0;
    GangInfo[gangid][gArmsY] = 0.0;
    GangInfo[gangid][gArmsZ] = 0.0;
    GangInfo[gangid][gDrugX] = 0.0;
    GangInfo[gangid][gDrugY] = 0.0;
    GangInfo[gangid][gDrugZ] = 0.0;
    GangInfo[gangid][gArmsWorld] = 0;
    GangInfo[gangid][gDrugWorld] = 0;
    GangInfo[gangid][gDrugWeed] = 0;
    GangInfo[gangid][gDrugCocaine] = 0;
    GangInfo[gangid][gDrugHeroin] = 0;
    GangInfo[gangid][gArmsMaterials] = 0;
    GangInfo[gangid][gAlliance] = -1;
    GangInfo[gangid][gPickup] = -1;
    GangInfo[gangid][gActors][0] = INVALID_ACTOR_ID;
    GangInfo[gangid][gActors][1] = INVALID_ACTOR_ID;
    GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][1] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][2] = Text3D:INVALID_3DTEXT_ID;

    GangInfo[gangid][gWeaponRanks][GANGWEAPON_9MM] = 1;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_SDPISTOL] = 1;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_DEAGLE] = 2;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_SHOTGUN] = 1;
//  GangInfo[gangid][gWeaponRanks][GANGWEAPON_SPAS12] = 4;
//  GangInfo[gangid][gWeaponRanks][GANGWEAPON_SAWNOFF] = 4;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_TEC9] = 1;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_UZI] = 1;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_MP5] = 2;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_AK47] = 3;
//  GangInfo[gangid][gWeaponRanks][GANGWEAPON_M4] = 4;
    GangInfo[gangid][gWeaponRanks][GANGWEAPON_RIFLE] = 2;
//  GangInfo[gangid][gWeaponRanks][GANGWEAPON_SNIPER] = 5;
//  GangInfo[gangid][gWeaponRanks][GANGWEAPON_MOLOTOV] = 5;

    for (new i = 0; i < 7; i ++)
    {
        strcpy(GangRanks[gangid][i], "Unspecified", 32);
    }

    for (new i = 0; i < 12; i ++)
    {
        if (i < 3)
        {
            GangInfo[gangid][gDrugPrices][i] = 0;
        }

        GangInfo[gangid][gArmsPrices][i] = 0;
    }

    for (new i = 0; i < MAX_GANG_SKINS; i ++)
    {
        GangInfo[gangid][gSkins][i] = 0;
    }

    DBQuery("INSERT INTO gangs (id, name) VALUES(%i, '%e')", gangid, name);
}

ReloadGang(gangid)
{
    if (GangInfo[gangid][gSetup])
    {
        new string[128], color;

        DestroyDynamic3DTextLabel(GangInfo[gangid][gText][0]);
        DestroyDynamic3DTextLabel(GangInfo[gangid][gText][1]);
        DestroyDynamic3DTextLabel(GangInfo[gangid][gText][2]);

        DestroyDynamicPickup(GangInfo[gangid][gPickup]);
        DestroyActor(GangInfo[gangid][gActors][0]);
        DestroyActor(GangInfo[gangid][gActors][1]);

        if (GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
        {
            color = 0xC8C8C8FF;
        }
        else if (GangInfo[gangid][gIsMafia])
        {
            color = 0x3F3F3FFF;
        }
        else
        {
            color = GangInfo[gangid][gColor];
        }
        if (GangInfo[gangid][gStashX] != 0.0 && GangInfo[gangid][gStashY] != 0.0 && GangInfo[gangid][gStashZ] != 0.0)
        {
            format(string, sizeof(string), "{%06x}%s Locker{C8C8C8}\nLevel %i ", color >>> 8, GangInfo[gangid][gName], GangInfo[gangid][gLevel]);

            GangInfo[gangid][gText][0] = CreateDynamic3DTextLabel(string, COLOR_ORANGE, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], 10.0, .worldid = GangInfo[gangid][gStashWorld], .interiorid = GangInfo[gangid][gStashInterior]);
            GangInfo[gangid][gPickup] = CreateDynamicPickup(1239, 1, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], .worldid = GangInfo[gangid][gStashWorld], .interiorid = GangInfo[gangid][gStashInterior]);
        }
    }
}
GiveGangPoints(gangid, amount)
{
    if (GangInfo[gangid][gSetup])
    {
        GangInfo[gangid][gPoints] = GangInfo[gangid][gPoints] + amount;

        DBQuery("UPDATE "#TABLE_GANGS" SET points = %i WHERE id = %i", GangInfo[gangid][gPoints], gangid);
    }
}

RemoveGang(gangid)
{
    if (GangInfo[gangid][gAlliance] >= 0)
    {
        DBQuery("UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", gangid);

        GangInfo[GangInfo[gangid][gAlliance]][gAlliance] = -1;
    }
    foreach(new i : Player)
    {
        if (PlayerData[i][pGang] == gangid)
        {
            SendClientMessageEx(i, COLOR_LIGHTRED, "The gang you were apart of has been deleted by an administrator.");
            PlayerData[i][pGang] = -1;
            PlayerData[i][pGangRank] = 0;
        }
    }
    for (new i = 0; i < MAX_GANG_CREWS; i ++)
    {
        GangCrews[gangid][i][0] = 0;
    }

    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][0]);
    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][1]);
    DestroyDynamic3DTextLabel(GangInfo[gangid][gText][2]);
    DestroyDynamicPickup(GangInfo[gangid][gPickup]);
    DestroyActor(GangInfo[gangid][gActors][0]);
    DestroyActor(GangInfo[gangid][gActors][1]);

    GangInfo[gangid][gSetup] = 0;
    GangInfo[gangid][gIsMafia] = 0;
    GangInfo[gangid][gName] = 0;
    GangInfo[gangid][gMOTD] = 0;
    GangInfo[gangid][gLeaderUID] = 0;
    GangInfo[gangid][gLeader] = 0;
    GangInfo[gangid][gColor] = 0;
    GangInfo[gangid][gStrikes] = 0;
    GangInfo[gangid][gLevel] = 0;
    GangInfo[gangid][gPoints] = 0;
    GangInfo[gangid][gTurfTokens] = 0;
    GangInfo[gangid][gStashX] = 0.0;
    GangInfo[gangid][gStashY] = 0.0;
    GangInfo[gangid][gStashZ] = 0.0;
    GangInfo[gangid][gStashInterior] = 0;
    GangInfo[gangid][gStashWorld] = 0;
    GangInfo[gangid][gCash] = 0;
    GangInfo[gangid][gMaterials] = 0;
    GangInfo[gangid][gWeed] = 0;
    GangInfo[gangid][gCocaine] = 0;
    GangInfo[gangid][gHeroin] = 0;
    GangInfo[gangid][gPainkillers] = 0;
    GangInfo[gangid][gArmsDealer] = 0;
    GangInfo[gangid][gDrugDealer] = 0;
    GangInfo[gangid][gArmsX] = 0.0;
    GangInfo[gangid][gArmsY] = 0.0;
    GangInfo[gangid][gArmsZ] = 0.0;
    GangInfo[gangid][gDrugX] = 0.0;
    GangInfo[gangid][gDrugY] = 0.0;
    GangInfo[gangid][gDrugZ] = 0.0;
    GangInfo[gangid][gArmsWorld] = 0;
    GangInfo[gangid][gDrugWorld] = 0;
    GangInfo[gangid][gDrugWeed] = 0;
    GangInfo[gangid][gDrugCocaine] = 0;
    GangInfo[gangid][gDrugHeroin] = 0;
    GangInfo[gangid][gArmsMaterials] = 0;
    GangInfo[gangid][gPickup] = -1;
    GangInfo[gangid][gActors][0] = INVALID_ACTOR_ID;
    GangInfo[gangid][gActors][1] = INVALID_ACTOR_ID;
    GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][1] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gText][2] = Text3D:INVALID_3DTEXT_ID;
    GangInfo[gangid][gAlliance] = -1;

    for (new i = 0; i < 7; i ++)
    {
        strcpy(GangRanks[gangid][i], "Unspecified", 32);
    }

    for (new i = 0; i < 14; i ++)
    {
        GangInfo[gangid][gWeapons][i] = 0;
    }

    for (new i = 0; i < MAX_GANG_SKINS; i ++)
    {
        GangInfo[gangid][gSkins][i] = 0;
    }

    ClearGangTurfs(gangid);

    for (new i = 0 ; i < MAX_VEHICLES ; i++)
    {
        if (VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == gangid)
        {
            DBQuery("DELETE FROM vehicles WHERE id = %i", VehicleInfo[i][vID]);

            DespawnVehicle(i, false);
        }
    }

    DBQuery("DELETE FROM gangs WHERE id = %i", gangid);

    DBQuery("DELETE FROM gangranks WHERE id = %i", gangid);

    DBQuery("DELETE FROM gangskins WHERE id = %i", gangid);

    DBQuery("DELETE FROM crews WHERE id = %i", gangid);

    DBQuery("UPDATE points SET capturedgang = -1 WHERE capturedgang = %i", gangid);

    DBQuery("UPDATE turfs SET capturedgang = -1 WHERE capturedgang = %i", gangid);

    DBQuery("UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE gang = %i", gangid);
}


GetGangMemberLimit(gangid)
{
    switch (GangInfo[gangid][gLevel])
    {
        case 1: return 30; // 30;
        case 2: return 30; // 60;
        case 3: return 30; // 80;
    }

    return 0;
}

GetGangSkinCount(gangid)
{
    new count;

    for (new i = 0; i < MAX_GANG_SKINS; i ++)
    {
        if (GangInfo[gangid][gSkins][i] != 0)
        {
            count++;
        }
    }

    return count;
}

GetGangHQ(gangid)
{
    foreach(new i : Entrance)
    {
        if (EntranceInfo[i][eExists] &&  EntranceInfo[i][eGang] == gangid &&  EntranceInfo[i][eWorld] == 35000 + gangid)
        {
            return i;
        }
    }

    return -1;
}

DB:OnLoadGangs()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_GANGS; i ++)
    {
        new gangid = GetDBIntField(i, "id");

        GetDBStringField(i, "name", GangInfo[gangid][gName], 32);
        GetDBStringField(i, "motd", GangInfo[gangid][gMOTD], 128);
        GetDBStringField(i, "leader", GangInfo[gangid][gLeader], MAX_PLAYER_NAME);

        GangInfo[gangid][gIsMafia] = GetDBIntField(i, "is_mafia");
        GangInfo[gangid][gLeaderUID] = GetDBIntField(i, "leaderid");
        GangInfo[gangid][gCount] = GetDBIntField(i, "count");
        GangInfo[gangid][gColor] = GetDBIntField(i, "color");
        GangInfo[gangid][gStrikes] = GetDBIntField(i, "strikes");
        GangInfo[gangid][gLevel] = GetDBIntField(i, "level");
        GangInfo[gangid][gPoints] = GetDBIntField(i, "points");
        GangInfo[gangid][gTurfTokens] = GetDBIntField(i, "turftokens");
        GangInfo[gangid][gStashX] = GetDBFloatField(i, "stash_x");
        GangInfo[gangid][gStashY] = GetDBFloatField(i, "stash_y");
        GangInfo[gangid][gStashZ] = GetDBFloatField(i, "stash_z");
        GangInfo[gangid][gStashInterior] = GetDBIntField(i, "stashinterior");
        GangInfo[gangid][gStashWorld] = GetDBIntField(i, "stashworld");
        GangInfo[gangid][gCash] = GetDBIntField(i, "cash");
        GangInfo[gangid][gMaterials] = GetDBIntField(i, "materials");
        GangInfo[gangid][gWeed] = GetDBIntField(i, "weed");
        GangInfo[gangid][gCocaine] = GetDBIntField(i, "cocaine");
        GangInfo[gangid][gHeroin] = GetDBIntField(i, "heroin");
        GangInfo[gangid][gPainkillers] = GetDBIntField(i, "painkillers");
        GangInfo[gangid][gAlliance] = GetDBIntField (i, "alliance");
        GangInfo[gangid][gMatLevel] = GetDBIntField (i, "matlevel");
        GangInfo[gangid][gGunLevel] = GetDBIntField (i, "gunlevel");
        GangInfo[gangid][gRankingPoints] = GetDBIntField (i, "rankingpoints");

        // Gang stash weapons
        GangInfo[gangid][gWeapons][GANGWEAPON_9MM] = GetDBIntField(i, "weapon_9mm");
        GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL] = GetDBIntField(i, "weapon_sdpistol");
        GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] = GetDBIntField(i, "weapon_deagle");
        GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN] = GetDBIntField(i, "weapon_shotgun");
        GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12] = GetDBIntField(i, "weapon_spas12");
    //    GangInfo[gangid][gWeapons][GANGWEAPON_SAWNOFF] = GetDBIntField(i, "weapon_sawnoff");
        GangInfo[gangid][gWeapons][GANGWEAPON_TEC9] = GetDBIntField(i, "weapon_tec9");
        GangInfo[gangid][gWeapons][GANGWEAPON_UZI] = GetDBIntField(i, "weapon_uzi");
        GangInfo[gangid][gWeapons][GANGWEAPON_MP5] = GetDBIntField(i, "weapon_mp5");
        GangInfo[gangid][gWeapons][GANGWEAPON_AK47] = GetDBIntField(i, "weapon_ak47");
        GangInfo[gangid][gWeapons][GANGWEAPON_M4] = GetDBIntField(i, "weapon_m4");
        GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE] = GetDBIntField(i, "weapon_rifle");
        GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER] = GetDBIntField(i, "weapon_sniper");
        //  GangInfo[gangid][gWeapons][GANGWEAPON_MOLOTOV] = GetDBIntField(i, "weapon_molotov");

        // Gang stash weapon ranks (01/07/2017)
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_9MM] = GetDBIntField(i, "rank_9mm");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_SDPISTOL] = GetDBIntField(i, "rank_sdpistol");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_DEAGLE] = GetDBIntField(i, "rank_deagle");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_SHOTGUN] = GetDBIntField(i, "rank_shotgun");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_SPAS12] = GetDBIntField(i, "rank_spas12");
        // GangInfo[gangid][gWeaponRanks][GANGWEAPON_SAWNOFF] = GetDBIntField(i, "rank_sawnoff");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_TEC9] = GetDBIntField(i, "rank_tec9");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_UZI] = GetDBIntField(i, "rank_uzi");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_MP5] = GetDBIntField(i, "rank_mp5");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_AK47] = GetDBIntField(i, "rank_ak47");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_M4] = GetDBIntField(i, "rank_m4");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_RIFLE] = GetDBIntField(i, "rank_rifle");
        GangInfo[gangid][gWeaponRanks][GANGWEAPON_SNIPER] = GetDBIntField(i, "rank_sniper");
    //     GangInfo[gangid][gWeaponRanks][GANGWEAPON_MOLOTOV] = GetDBIntField(i, "rank_molotov");
        GangInfo[gangid][gVestRank] = GetDBIntField(i, "rank_vest");

        // Gang arms & drug dealer
        GangInfo[gangid][gArmsDealer] = GetDBIntField(i, "armsdealer");
        GangInfo[gangid][gDrugDealer] = GetDBIntField(i, "drugdealer");
        GangInfo[gangid][gArmsX] = GetDBFloatField(i, "arms_x");
        GangInfo[gangid][gArmsY] = GetDBFloatField(i, "arms_y");
        GangInfo[gangid][gArmsZ] = GetDBFloatField(i, "arms_z");
        GangInfo[gangid][gArmsA] = GetDBFloatField(i, "arms_a");
        GangInfo[gangid][gDrugX] = GetDBFloatField(i, "drug_x");
        GangInfo[gangid][gDrugY] = GetDBFloatField(i, "drug_y");
        GangInfo[gangid][gDrugZ] = GetDBFloatField(i, "drug_z");
        GangInfo[gangid][gDrugA] = GetDBFloatField(i, "drug_a");
        GangInfo[gangid][gArmsWorld] = GetDBIntField(i, "armsworld");
        GangInfo[gangid][gDrugWorld] = GetDBIntField(i, "drugworld");
        GangInfo[gangid][gDrugWeed] = GetDBIntField(i, "drugweed");
        GangInfo[gangid][gDrugCocaine] = GetDBIntField(i, "drugcocaine");
        GangInfo[gangid][gDrugHeroin] = GetDBIntField(i, "drugheroin");
        GangInfo[gangid][gArmsMaterials] = GetDBIntField(i, "armsmaterials");
        GangInfo[gangid][gArmsPrices][0] = GetDBIntField(i, "armsprice_1");
        GangInfo[gangid][gArmsPrices][1] = GetDBIntField(i, "armsprice_2");
        GangInfo[gangid][gArmsPrices][2] = GetDBIntField(i, "armsprice_3");
        GangInfo[gangid][gArmsPrices][3] = GetDBIntField(i, "armsprice_4");
        GangInfo[gangid][gArmsPrices][4] = GetDBIntField(i, "armsprice_5");
        GangInfo[gangid][gArmsPrices][5] = GetDBIntField(i, "armsprice_6");
        GangInfo[gangid][gArmsPrices][6] = GetDBIntField(i, "armsprice_7");
        GangInfo[gangid][gArmsPrices][7] = GetDBIntField(i, "armsprice_8");
        GangInfo[gangid][gArmsPrices][8] = GetDBIntField(i, "armsprice_9");
        GangInfo[gangid][gArmsPrices][9] = GetDBIntField(i, "armsprice_10");
        GangInfo[gangid][gArmsPrices][10] = GetDBIntField(i, "armsprice_11");
        GangInfo[gangid][gArmsPrices][11] = GetDBIntField(i, "armsprice_12");
        GangInfo[gangid][gDrugPrices][0] = GetDBIntField(i, "weed_price");
        GangInfo[gangid][gDrugPrices][1] = GetDBIntField(i, "cocaine_price");
        GangInfo[gangid][gDrugPrices][2] = GetDBIntField(i, "heroin_price");

        GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
        GangInfo[gangid][gText][1] = Text3D:INVALID_3DTEXT_ID;
        GangInfo[gangid][gText][2] = Text3D:INVALID_3DTEXT_ID;
        GangInfo[gangid][gActors][0] = INVALID_ACTOR_ID;
        GangInfo[gangid][gActors][1] = INVALID_ACTOR_ID;
        GangInfo[gangid][gPickup] = -1;
        GangInfo[gangid][gSetup] = 1;


        ReloadGang(gangid);
    }

    printf("[Script] %i gangs loaded.", rows);
}

DB:OnLoadGangRanks()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < MAX_GANGS; i ++)
    {
        for (new r = 0; r < 7; r ++)
        {
            strcpy(GangRanks[i][r], "Unspecified", 32);
        }
    }

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "name", GangRanks[GetDBIntField(i, "id")][GetDBIntField(i, "rank")], 32);
    }
}

DB:OnLoadGangSkins()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows; i ++)
    {
        GangInfo[GetDBIntField(i, "id")][gSkins][GetDBIntField(i, "slot")] = GetDBIntField(i, "skinid");
    }
}

DB:OnLoadLockers()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_LOCKERS; i ++)
    {
        LockerInfo[i][lID] = GetDBIntField(i, "id");
        LockerInfo[i][lFaction] = GetDBIntField(i, "factionid");
        LockerInfo[i][lPosX] = GetDBFloatField(i, "pos_x");
        LockerInfo[i][lPosY] = GetDBFloatField(i, "pos_y");
        LockerInfo[i][lPosZ] = GetDBFloatField(i, "pos_z");
        LockerInfo[i][lInterior] = GetDBIntField(i, "interior");
        LockerInfo[i][lWorld] = GetDBIntField(i, "world");
        LockerInfo[i][lIcon] = GetDBIntField(i, "iconid");
        LockerInfo[i][lLabel] = GetDBIntField(i, "label");

        LockerInfo[i][locKevlar][0] = GetDBIntField(i, "weapon_kevlar");
        LockerInfo[i][locMedKit][0] = GetDBIntField(i, "weapon_medkit");
        LockerInfo[i][locNitestick][0] = GetDBIntField(i, "weapon_nitestick");
        LockerInfo[i][locMace][0] = GetDBIntField(i, "weapon_mace");
        LockerInfo[i][locDeagle][0] = GetDBIntField(i, "weapon_deagle");
        LockerInfo[i][locShotgun][0] = GetDBIntField(i, "weapon_shotgun");
        LockerInfo[i][locMP5][0] = GetDBIntField(i, "weapon_mp5");
        LockerInfo[i][locM4][0] = GetDBIntField(i, "weapon_m4");
        LockerInfo[i][locSpas12][0] = GetDBIntField(i, "weapon_spas12");
        LockerInfo[i][locSniper][0] = GetDBIntField(i, "weapon_sniper");
        LockerInfo[i][locCamera][0] = GetDBIntField(i, "weapon_camera");
        LockerInfo[i][locFireExt][0] = GetDBIntField(i, "weapon_fire_extinguisher");
        LockerInfo[i][locPainKillers][0] = GetDBIntField(i, "weapon_painkillers");

        LockerInfo[i][locKevlar][1] = GetDBIntField(i, "price_kevlar");
        LockerInfo[i][locMedKit][1] = GetDBIntField(i, "price_medkit");
        LockerInfo[i][locNitestick][1] = GetDBIntField(i, "price_nitestick");
        LockerInfo[i][locMace][1] = GetDBIntField(i, "price_mace");
        LockerInfo[i][locDeagle][1] = GetDBIntField(i, "price_deagle");
        LockerInfo[i][locShotgun][1] = GetDBIntField(i, "price_shotgun");
        LockerInfo[i][locMP5][1] = GetDBIntField(i, "price_mp5");
        LockerInfo[i][locM4][1] = GetDBIntField(i, "price_m4");
        LockerInfo[i][locSpas12][1] = GetDBIntField(i, "price_spas12");
        LockerInfo[i][locSniper][1] = GetDBIntField(i, "price_sniper");
        LockerInfo[i][locCamera][1] = GetDBIntField(i, "price_camera");
        LockerInfo[i][locFireExt][1] = GetDBIntField(i, "price_fire_extinguisher");
        LockerInfo[i][locPainKillers][1] = GetDBIntField(i, "price_painkillers");

        LockerInfo[i][lText] = Text3D:INVALID_3DTEXT_ID;
        LockerInfo[i][lPickup] = -1;
        LockerInfo[i][lExists] = 1;

        ReloadLocker(i);
    }
}

DB:GangRoster(playerid)
{
    new rows = GetDBNumRows();

    new username[MAX_PLAYER_NAME], date[24];

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Gang Roster _____");

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "username", username);
        GetDBStringField(i, "lastlogin", date);

        SendClientMessageEx(playerid, COLOR_GREY2, "[%i] %s %s - Last Seen: %s - Points: %d", GetDBIntField(i, "gangrank"), GangRanks[PlayerData[playerid][pGang]][GetDBIntField(i, "gangrank")], username, date, GetDBIntField(i, "membership_rankingpoints"));
    }
}

DB:OnPlayerOfflineKickGang(playerid, username[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else if (GetDBIntFieldFromIndex(0, 1) != PlayerData[playerid][pGang])
    {
        SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
    }
    else if (PlayerData[playerid][pGang] >= 0 && GetDBIntFieldFromIndex(0, 0) == GangInfo[PlayerData[playerid][pGang]][gLeaderUID])
    {
        SendClientMessage(playerid, COLOR_GREY, "You cannot kick gang leader.");
    }
    else if (GetDBIntFieldFromIndex(0, 2) > PlayerData[playerid][pGangRank])
    {
        SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
    }
    else
    {
        new uid = GetDBIntFieldFromIndex(0, 0), gangid = GetDBIntFieldFromIndex(0, 1), rankid = GetDBIntFieldFromIndex(0, 2);

        DBLog("log_gang", "%s (uid: %i)  offlinekicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, uid, GangInfo[gangid][gName], gangid, GangRanks[gangid][rankid], rankid);
        //("log_gang", PlayerData[playerid][pGang], "%s (uid: %i)  offlinekicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, uid, GangInfo[gangid][gName], gangid, GangRanks[gangid][rankid], rankid);
        DBQuery("UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE uid = %i", uid);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have offline kicked %s from your gang.", username);
    }
}


DB:OnPlayerOfflineRankGang(playerid, username[], newrank)
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
    }
    else if (GetDBIntFieldFromIndex(0, 1) != PlayerData[playerid][pGang])
    {
        SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
    }
    else if (GetDBIntFieldFromIndex(0, 2) > PlayerData[playerid][pGangRank])
    {
        SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
    }
    else
    {
        new uid = GetDBIntFieldFromIndex(0, 0), gangid = GetDBIntFieldFromIndex(0, 1), rankid = GetDBIntFieldFromIndex(0, 2);

        DBQuery("UPDATE "#TABLE_USERS" SET gangrank = %i WHERE uid = %i", newrank, uid);

        DBLog("log_gang", "%s (uid: %i) has offline set %s's (uid: %i) rank in %s (id: %i) to %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], username, uid, GangInfo[gangid][gName], gangid, GangRanks[gangid][rankid], rankid);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have offline set %s's rank to {00AA00}%s{33CCFF} (%i).", username, GangRanks[gangid][newrank], newrank);

    }
}

DB:OnPlayerAttemptInviteGang(playerid, targetid)
{
    if (GetDBIntFieldFromIndex(0, 0) >= GetGangMemberLimit(PlayerData[playerid][pGang]))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Your gang can't have more than %i members at its level.", GetGangMemberLimit(PlayerData[playerid][pGang]));
    }
    else
    {
        PlayerData[targetid][pGangOffer] = playerid;
        PlayerData[targetid][pGangOffered] = PlayerData[playerid][pGang];

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has invited you to join {00AA00}%s{33CCFF} (/accept gang).", GetRPName(playerid), GangInfo[PlayerData[playerid][pGang]][gName]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have invited %s to join your gang.", GetRPName(targetid));
    }
}

static const gangStashCapacities[][] = {
    // Cash      Mats  Weed    C     M     P    W
    {1000000,  250000, 1000, 1000, 1000,  50,  50},
    {2000000,  500000, 2000, 2000, 2000, 100, 100},
    {3000000, 1000000, 3000, 3000, 3000, 250, 200}
};

GetGangStashCapacity(gangid, item)
{
    return gangStashCapacities[GangInfo[gangid][gLevel] - 1][item];
}

CMD:gbk(playerid, params[])
{
    return callcmd::gbackup(playerid, params);
}

CMD:gbackup(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
    }
    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot call for backup when you are dead.");
    }
    if (PlayerData[playerid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
    }
    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
    }
    if (!PlayerData[playerid][pBackup])
    {
        PlayerData[playerid][pBackup] = 1;
    }
    else
    {
        PlayerData[playerid][pBackup] = 0;
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pGang] == PlayerData[playerid][pGang])
        {
            if (PlayerData[playerid][pBackup])
            {
                SendClientMessageEx(i, COLOR_AQUA, "* %s %s is requesting backup in %s (marked on map). *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
                SetPlayerMarkerForPlayer(i, playerid, (GangInfo[PlayerData[playerid][pGang]][gColor] & ~0xff) + 0xFF);
            }
            else
            {
                SendClientMessageEx(i, COLOR_AQUA, "* %s %s has cancelled their backup request. *", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
                SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
            }
        }
    }

    return 1;
}

CMD:gmembers(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____________ Members Online _____________");
    new string[256], color = GangInfo[PlayerData[playerid][pGang]][gColor];
    foreach(new i : Player)
    {
        if (PlayerData[i][pGang] == PlayerData[playerid][pGang] && !PlayerData[i][pAdminHide])
        {
            format(string, sizeof(string), "(%i) %s {%06x}%s{FFFFFF}", PlayerData[i][pGangRank], GangRanks[PlayerData[i][pGang]][PlayerData[i][pGangRank]], color >>> 8, GetRPName(i));
            if (PlayerData[i][pCrew] >= 0)
            {
                format(string, sizeof(string), "%s | Crew: %s", string, GangCrews[PlayerData[i][pGang]][PlayerData[i][pCrew]]);
            }
            if (PlayerData[i][pGangLeader])
            {
                format(string, sizeof(string), "%s | {06FF00}Leader{FFFFFF}", string);
            }
            format(string, sizeof(string), "%s | Location: %s", string, GetPlayerZoneName(i));
            if (IsPlayerAFK(i))
            {
                format(string, sizeof(string), "%s | {FFA500}AFK{FFFFFF} (%d secs)", string, GetAFKTime(i));
            }
            format(string, sizeof(string), "%s | Points: %d", string, GetPlayerCommitRankPoints(i));
            SendClientMessage(playerid, COLOR_WHITE, string);
        }
    }

    return 1;
}

CMD:ganglocker(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    new gangid, option[32];
    if (sscanf(params, "ds[32]", gangid, option)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ganglocker [gangid] [remove/place/goto]");
    if (!strcmp(option, "place", true))
    {
        GetPlayerPos(playerid, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ]);
        GangInfo[gangid][gStashInterior] = GetPlayerInterior(playerid);
        GangInfo[gangid][gStashWorld] = GetPlayerVirtualWorld(playerid);
        DBQuery("UPDATE "#TABLE_GANGS" SET stash_x = '%f', stash_y = '%f', stash_z = '%f', stashinterior = %i, stashworld = %i WHERE id = %i", GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], GangInfo[gangid][gStashInterior], GangInfo[gangid][gStashWorld], gangid);

        ReloadGang(gangid);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have moved %s's locker to your currently position.", GangInfo[gangid][gName]);
    }
    else if (!strcmp(option, "remove", true))
    {
        DestroyDynamic3DTextLabel(GangInfo[gangid][gText][0]);
        DestroyDynamicPickup(GangInfo[gangid][gPickup]);
        GangInfo[gangid][gText][0] = Text3D:INVALID_3DTEXT_ID;
        DBQuery("UPDATE "#TABLE_GANGS" SET stash_x = 0, stash_y = 0, stash_z = 0, stashinterior = 1, stashworld = 1 WHERE id = %i", gangid);

        ReloadGang(gangid);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s's locker.", GangInfo[gangid][gName]);
    }
    else if (!strcmp(option, "goto", true))
    {
        TeleportToCoords(playerid, GangInfo[gangid][gStashX], GangInfo[gangid][gStashY], GangInfo[gangid][gStashZ], 0.0, GangInfo[gangid][gStashInterior], GangInfo[gangid][gStashWorld]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have been teleported tp %s's locker.", GangInfo[gangid][gName]);
    }
    return 1;
}

CMD:gang(playerid, params[])
{
    new targetid, option[16], param[128];

    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
    }
    if (sscanf(params, "s[16]S()[128]", option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Invite, Kick, Rank, Roster, Online, Quit, Offlinekick, Leadership");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: MOTD, Stash, Stats, Turfs, Rankname, Upgrade, War, Alliance");
        return 1;
    }
    if (!strcmp(option, "invite", true))
    {
        if (PlayerData[playerid][pGangRank] < 5)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");
        }
        if (sscanf(param, "u", targetid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [invite] [playerid]");
        }
        if (GangInfo[PlayerData[playerid][pGang]][gInvCooldown] > 0 && GetGangInviteCooldown())
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You're gang is currently on a invite cooldown. Please wait %i minutes before the next invite.", GangInfo[PlayerData[playerid][pGang]][gInvCooldown]);
        }
        if (GangClaimingTurfs(PlayerData[playerid][pGang]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can not use invite if your gang is attending a turf or point.");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (PlayerData[targetid][pGang] != -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of a gang.");
        }

        if (PlayerData[targetid][pFaction] != -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is apart of a faction and therefore can't join a gang.");
        }

        DBFormat("SELECT COUNT(*) FROM "#TABLE_USERS" WHERE gang = %i", PlayerData[playerid][pGang]);
        DBExecute("OnPlayerAttemptInviteGang", "ii", playerid, targetid);
    }
    else if (!strcmp(option, "skin", true))
    {
        if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
        {
            return SendUnauthorized(playerid);
        }
        new slot, skinid, gangid = PlayerData[playerid][pGang];
        if (PlayerData[playerid][pGangRank] < 6)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6 to use this command.");
        }
        if (sscanf(param, "ii", slot, skinid))
        {

            SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Gang Skins ______");

            for (new i = 0; i < MAX_GANG_SKINS; i ++)
            {
                if (GangInfo[gangid][gSkins][i] == 0)
                    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: (none)", i + 1);
                else
                    SendClientMessageEx(playerid, COLOR_GREY2, "Skin %i: %i", i + 1, GangInfo[gangid][gSkins][i]);
            }

            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /gang [skin] [slot (1-%i)] [skinid]", MAX_GANG_SKINS);
        }
        new forbidSkin[35] =
        {
            0, 71, 74, 264, 265, 266, 267, 274, 275, 276,
            277, 278, 279, 280, 281, 282, 283, 284, 285,
            286, 287, 288, 300, 301, 302, 306, 307, 308,
            309, 310, 311
        };


        if (!(1 <= slot <= MAX_GANG_SKINS))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
        }
        if (!(1 <= skinid <= 311))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid skin.");
        }
        for (new i = 0; i < sizeof forbidSkin; i++)
        {
            if (skinid == forbidSkin[i])
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't select this skin.");
            }
        }
        slot--;

        GangInfo[gangid][gSkins][slot] = skinid;

        DBQuery("INSERT INTO gangskins VALUES(%i, %i, %i) ON DUPLICATE KEY UPDATE skinid = %i", gangid, slot, skinid, skinid);

        SendClientMessageEx(playerid, COLOR_WHITE, "* You have set the skin in slot %i to ID %i.", slot + 1, skinid);
    }
    else if (!strcmp(option, "kick", true))
    {
        if (!PlayerData[playerid][pGangLeader])
		{
			return SendNoPermission(playerid);
		}
        if (sscanf(param, "u", targetid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [kick] [playerid]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
        }
        if (PlayerData[targetid][pGangRank] > PlayerData[playerid][pGangRank])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
        }

        if (IsGangLeader(targetid, PlayerData[playerid][pGang]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot kick this person.");
        }

        DBLog("log_gang", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang], GangRanks[PlayerData[targetid][pGang]][PlayerData[targetid][pGangRank]], PlayerData[targetid][pGangRank]);

        GangInfo[PlayerData[targetid][pGang]][gCount]--;

        PlayerData[targetid][pGang] = -1;
        PlayerData[targetid][pGangRank] = 0;
        DestroyDynamic3DTextLabel(fRepfamtext[targetid]);
        fRepfamtext[targetid] = Text3D:INVALID_3DTEXT_ID;
        DBQuery("UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has kicked you from the gang.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have kicked %s from your gang.", GetRPName(targetid));
    }
    else if (!strcmp(option, "rank", true))
    {
        new rankid;

        if (!PlayerData[playerid][pGangLeader])
		{
			return SendNoPermission(playerid);
		}
        if (sscanf(param, "ui", targetid, rankid))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /gang [rank] [playerid] [rankid (0-6)]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (rankid < 0 || rankid > PlayerData[playerid][pGangRank])
        {
            return SendClientMessage(playerid, COLOR_GREY, "The rank specified is either invalid or higher than your rank.");
        }
        if (PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
        }
        if (PlayerData[targetid][pGangRank] > PlayerData[playerid][pGangRank])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has a higher rank than you.");
        }

        PlayerData[targetid][pGangRank] = rankid;

        DBQuery("UPDATE "#TABLE_USERS" SET gangrank = %i WHERE uid = %i", rankid, PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has set your rank to {00AA00}%s{33CCFF} (%i).", GetRPName(playerid), GangRanks[PlayerData[playerid][pGang]][rankid], rankid);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have set %s's rank to {00AA00}%s{33CCFF} (%i).", GetRPName(targetid), GangRanks[PlayerData[playerid][pGang]][rankid], rankid);
        DBLog("log_gang", "%s (uid: %i) has set %s's (uid: %i) rank in %s (id: %i) to %s (%i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang], GangRanks[PlayerData[playerid][pGang]][rankid], rankid);
    }
    else if (!strcmp(option, "leadership", true))
    {
        if (!PlayerData[playerid][pGangMod])
        {
            return SendNoPermission(playerid);
        }
        if (sscanf(param, "u", targetid))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [leadership] [playerid]");
            SendClientMessage(playerid, COLOR_SYNTAX, "This command grants or revokes a fellow gang member's leadership flags.");
            return 1;
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if(PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your Gang.");
        }

        if (!PlayerData[targetid][pGangLeader])
        {
            PlayerData[targetid][pGangLeader] = 1;

            SendClientMessageEx(targetid, COLOR_AQUA, "%s has {00AA00}granted{33CCFF} you the leadership flags to the gang.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You have {00AA00}granted{33CCFF} %s the leadership flags to your gang.", GetRPName(targetid));
            DBLog("log_gang", "%s (uid: %i) granted leadership flags to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
        }
        else
        {
            PlayerData[targetid][pGangLeader] = 0;

            SendClientMessageEx(targetid, COLOR_AQUA, "%s has {FF6347}revoked{33CCFF} your leadership flags to the gang.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_AQUA, "You have {FF6347}revoked{33CCFF} %s's leadership flags to your gang.", GetRPName(targetid));
            DBLog("log_gang", "%s (uid: %i) revoked leadership flags from %s (uid: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
        }

        DBQuery("UPDATE "#TABLE_USERS" SET gangleader = %i WHERE uid = %i", PlayerData[targetid][pGangLeader], PlayerData[targetid][pID]);
	}
    else if (!strcmp(option, "stash", true))
    {
        SendClientMessage(playerid, COLOR_GREY, "This command was removed, Contact an admin to place your locker.");
    }
    else if (!strcmp(option, "turfs", true))
    {
        ListGangTurfs(playerid);
    }
    else if (!strcmp(option, "stats", true))
    {
        DBFormat("SELECT COUNT(*) FROM "#TABLE_USERS" WHERE gang = %i", PlayerData[playerid][pGang]);
        DBExecute("OnGangInformation", "i", playerid);
    }
    else if (!strcmp(option, "roster", true))
    {
        DBFormat("SELECT username, lastlogin, gangrank,membership_rankingpoints FROM "#TABLE_USERS" WHERE gang = %i ORDER BY gangrank DESC", PlayerData[playerid][pGang]);
        DBExecute("GangRoster", "i", playerid);
    }
    else if (!strcmp(option, "online", true))
    {
        callcmd::gmembers(playerid, "\1");
    }
    else if (!strcmp(option, "quit", true))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Command disabled.");
    }
    else if (!strcmp(option, "offlinekick", true))
    {
        new username[MAX_PLAYER_NAME];

        if (!PlayerData[playerid][pGangLeader])
		{
			return SendNoPermission(playerid);
		}
        if (sscanf(param, "s[24]", username))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [offlinekick] [username]");
        }
        if (IsPlayerOnline(username))
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use '/gang kick' instead.");
        }

        DBFormat("SELECT uid, gang, gangrank FROM "#TABLE_USERS" WHERE username = '%e'", username);
        DBExecute("OnPlayerOfflineKickGang", "is", playerid, username);
    }
    else if (!strcmp(option, "offlinerank", true))
    {
        new username[MAX_PLAYER_NAME], newrank;

        if (!PlayerData[playerid][pGangLeader])
		{
			return SendNoPermission(playerid);
		}
        if (sscanf(param, "s[24]i", username, newrank))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [offlinerank] [username] [rankid (0-6)]");
        }
        if (IsPlayerOnline(username))
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is already online and logged in. Use '/gang rank' instead.");
        }
        if (newrank < 0 || newrank > PlayerData[playerid][pGangRank])
        {
            return SendClientMessage(playerid, COLOR_GREY, "The rank specified is either invalid or higher than your rank.");
        }

        DBFormat("SELECT uid, gang, gangrank FROM "#TABLE_USERS" WHERE username = '%e'", username);
        DBExecute("OnPlayerOfflineRankGang", "isi", playerid, username, newrank);
    }
    else if (!strcmp(option, "motd", true))
    {
        if (PlayerData[playerid][pGangRank] < 6)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
        }
        if (isnull(param))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [motd] [text]");
            SendClientMessageEx(playerid, COLOR_SYNTAX, "Current MOTD: %s", GangInfo[PlayerData[playerid][pGang]][gMOTD]);
            return 1;
        }

        strcpy(GangInfo[PlayerData[playerid][pGang]][gMOTD], param, 128);

        DBQuery("UPDATE "#TABLE_GANGS" SET motd = '%e' WHERE id = %i", param, PlayerData[playerid][pGang]);


        ReloadGang(PlayerData[playerid][pGang]);
        SendClientMessage(playerid, COLOR_AQUA, "You have changed the MOTD for your gang.");
    }
    else if (!strcmp(option, "rankname", true))
    {
        new rankid, rank[32];

        if (PlayerData[playerid][pGangRank] < 6)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
        }
        if (sscanf(param, "is[32]", rankid, rank))
        {
            SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Rank Names ______");

            for (new i = 0; i < 7; i ++)
            {
                if (isnull(GangRanks[PlayerData[playerid][pGang]][i]))
                    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: (empty)", i);
                else
                    SendClientMessageEx(playerid, COLOR_GREY2, "Rank %i: %s", i, GangRanks[PlayerData[playerid][pGang]][i]);
            }

            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [rankname] [slot (0-6)] [name]");
        }
        if (!(0 <= rankid <= 6))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid rank.");
        }

        strcpy(GangRanks[PlayerData[playerid][pGang]][rankid], rank, 32);

        DBQuery("INSERT INTO gangranks VALUES(%i, %i, '%e') ON DUPLICATE KEY UPDATE name = '%e'", PlayerData[playerid][pGang], rankid, rank, rank);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have set the name of rank %i to {00AA00}%s{33CCFF}.", rankid, rank);
    }
    else if (!strcmp(option, "upgrade", true))
    {
        if (PlayerData[playerid][pGangRank] < 6)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 6+ to use this command.");
        }

        new
            title[48],
            string[1024] = "Perk\tDescription\tCost";

        strcat(string, "\nDrug dealer\tAn NPC which sells individually stocked drugs\t{F7A763}500 GP {FFFFFF}+{00AA00} $50,000");
        strcat(string, "\nArms dealer\tAn NPC which sells individually stocked weapons\t{F7A763}500 GP {FFFFFF}+{00AA00} $50,000");
        strcat(string, "\nDuel arena\tAn OOC 1v1 duel arena for your gang.\t{F7A763}400 GP {FFFFFF}+{00AA00} $75,000");
        strcat(string, "\nMapping\tUp to 50 mapped objects for your gang.\t{F7A763}4500 GP {FFFFFF}+{00AA00} $100,000");
        strcat(string, "\nInterior\tCustom interior exclusively for your gang.\t{F7A763}5000 GP {FFFFFF}+{00AA00} $100,000");
        // gang and mat s0ns
        format(string, sizeof string, "%s\nMaterials level up\tReceive more materials from successfully captured turfs.\t{F7A763}%s GP {FFFFFF}+{00AA00} $%s", string, FormatNumber(1500 + (500*GangInfo[PlayerData[playerid][pGang]][gMatLevel])), FormatNumber(100000 + (50000*GangInfo[PlayerData[playerid][pGang]][gMatLevel])));
        format(string, sizeof string, "%s\nGun level up\tReceive more guns from successfully captured turfs.\t{F7A763} %s GP {FFFFFF}+{00AA00} $%s", string, FormatNumber(1500 + (250*GangInfo[PlayerData[playerid][pGang]][gGunLevel])), FormatNumber(40000 + (20000 * GangInfo[PlayerData[playerid][pGang]][gGunLevel])));

        if (GangInfo[PlayerData[playerid][pGang]][gLevel] == 1)
        {
            strcat(string, "\nLevel Up\tAdvance your gang's level to 2/3.\t{F7A763}6000 GP {FFFFFF}+{00AA00} $75,000");
        }
        else if (GangInfo[PlayerData[playerid][pGang]][gLevel] == 2)
        {
            strcat(string, "\nLevel Up\tAdvance your gang's level to 3/3.\t{F7A763}12000 GP {FFFFFF}+{00AA00} $100,000");
        }

        format(title, sizeof(title), "Gang upgrades (Your gang has %i GP.)", GangInfo[PlayerData[playerid][pGang]][gPoints]);
        Dialog_Show(playerid, DIALOG_GANGPOINTSHOP, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Select", "Cancel");
    }
    else if (!strcmp(option, "alliance", true))
    {
        new gangid = PlayerData[playerid][pGang];

        if (!PlayerData[playerid][pGangLeader])
		{
			return SendNoPermission(playerid);
		}
        if (sscanf(param, "u", targetid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gang [alliance] [playerid]");
        }
        if (GangInfo[gangid][gAlliance] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You're already in an alliance, end it first! (/endalliance)");
        }
        if (PlayerData[targetid][pGangRank] < 6)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player you're offering to ally with must be R6 in their gang!");
        }
        if (PlayerData[targetid][pGang] == gangid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot form an alliance with your own gang!");
        }

        if (GangInfo[gangid][gAlliance] == -1)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You've offered to form a gang alliance with %s.", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "%s has offered to form an alliance with your gang. (/accept alliance)", GetRPName(playerid));
            PlayerData[targetid][pAllianceOffer] = playerid;
        }
    }

    return 1;
}

CMD:gstash(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }
    if (!(IsPlayerInRangeOfPoint(playerid, 5.0, GangInfo[PlayerData[playerid][pGang]][gStashX], GangInfo[PlayerData[playerid][pGang]][gStashY], GangInfo[PlayerData[playerid][pGang]][gStashZ]) && GetPlayerVirtualWorld(playerid) == GangInfo[PlayerData[playerid][pGang]][gStashWorld]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your gang stash.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to open the stash. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
    ShowDialogToPlayer(playerid, DIALOG_GANGSTASH);
    return 1;
}

CMD:repfam(playerid, params[])
{
    callcmd::bandana(playerid, params);
}

CMD:bandana(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }
    if (PlayerData[playerid][pBackup])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Your bandana is enabled as you are requesting backup. (/backup to turn it off).");
    }
    if (!PlayerData[playerid][pBandana])
    {
        if (IsPlayerInEvent(playerid) || PlayerData[playerid][pPaintballTeam] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can not put on your bandana on while in a event or paintball match.");
        }
        SetPlayerBandana(playerid, true);
        SendClientMessage(playerid, COLOR_AQUA, "You have enabled your bandana. Your nametag color has been set to your gang color.");
    }
    else
    {
        SetPlayerBandana(playerid, false);
        SendClientMessage(playerid, COLOR_AQUA, "You have disabled your bandana. Your nametag color was reset back to normal.");
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pGang] == PlayerData[playerid][pGang])
        {
            if (PlayerData[playerid][pBandana])
            {
                SetPlayerMarkerForPlayer(i, playerid, (GangInfo[PlayerData[playerid][pGang]][gColor] & ~0xff) + 0xFF);
            }
            else
            {
                SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
            }
        }
    }
    return 1;
}

CMD:gpark(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), id = VehicleInfo[vehicleid][vID];

    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in any gang at the moment.");
    }
    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any of your gang vehicles.");
    }
    if (VehicleInfo[vehicleid][vGang] != PlayerData[playerid][pGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't park this vehicle as it doesn't belong to your gang.");
    }
    if (IsPlayerInRangeOfPoint(playerid, 20.0, 1233.1134,-1304.1257,13.5124))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't park your vehicle here.");
    }

    new Float:health;
    GetVehicleHealth(vehicleid, health);
    if (health < 600.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is too damaged to /gpark.");
    }
    // Save the vehicle's information.
    GetVehiclePos(vehicleid, VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ]);
    GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][vPosA]);

    VehicleInfo[vehicleid][vInterior] = GetPlayerInterior(playerid);
    VehicleInfo[vehicleid][vWorld] = GetPlayerVirtualWorld(playerid);

    SendClientMessage(playerid, COLOR_AQUA, "* Gang vehicle parked. It will now spawn here.");

    // Update the database record with the new information, then despawn the vehicle.
    DBQuery("UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vID]);


    SaveVehicleModifications(vehicleid);
    DespawnVehicle(vehicleid, false);

    // Finally, we reload the vehicle from the database.
    DBFormat("SELECT * FROM vehicles WHERE id = %i", id);
    DBExecute("OnLoadVehicles", "i", -1);

    return 1;
}

CMD:gtrackcar(playerid, params[])
{
    return callcmd::gfindcar(playerid, params);
}

CMD:gfindcar(playerid, params[])
{
    new string[512], count;

    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }

    string = "#\tModel\tLocation";

    foreach(new i: Vehicle)
    {
        if (VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerData[playerid][pGang])
        {
            format(string, sizeof(string), "%s\n%i\t%s\t%s", string, count + 1, GetVehicleName(i), GetVehicleZoneName(i));
            count++;
        }
    }

    if (!count)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your gang has no vehicles which you can track.");
    }

    Dialog_Show(playerid, DIALOG_GANGFINDCAR, DIALOG_STYLE_TABLIST_HEADERS, "Gang vehicles", string, "Track", "Cancel");
    return 1;
}

CMD:grespawncars(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in any gang at the moment.");
    }

    foreach(new i: Vehicle)
    {
        if (VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerData[playerid][pGang] && !IsVehicleOccupied(i))
        {
            SetVehicleToRespawn(i);
        }
    }

    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has respawned their gang vehicles.", GetRPName(playerid), playerid);
    SendClientMessage(playerid, COLOR_YELLOW, "You have respawned all of your unoccupied gang vehicles.");
    return 1;
}

CMD:gsellcar(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in any gang at the moment.");
    }
    if (!IsGangLeader(playerid, PlayerData[playerid][pGang]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only gang leader can sell gang cars.");
    }
    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any of your gang vehicles.");
    }
    if (VehicleInfo[vehicleid][vGang] != PlayerData[playerid][pGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell this vehicle as it doesn't belong to your gang.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 8.0, 542.0433, -1293.5909, 17.2422))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the Grotti car dealership.");
    }
    if (strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gsellcar [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "This command permanently deletes your gang vehicle. You will receive %s back.", FormatCash(percent(VehicleInfo[vehicleid][vPrice], 75)));
        return 1;
    }

    GivePlayerCash(playerid, percent(VehicleInfo[vehicleid][vPrice], 75));

    SendClientMessageEx(playerid, COLOR_GREEN, "You have sold your %s to the dealership and received %s back.", GetVehicleName(vehicleid), FormatCash(percent(VehicleInfo[vehicleid][vPrice], 75)));
    DBLog("log_gang", "%s (uid: %i) sold their gang owned %s (id: %i) to the dealership for $%i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], percent(VehicleInfo[vehicleid][vPrice], 75));

    DBQuery("DELETE FROM vehicles WHERE id = %i", VehicleInfo[vehicleid][vID]);

    DespawnVehicle(vehicleid, false);
    return 1;
}
CMD:ganghelp(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a gang member.");
    }

    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** GANG HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** GANG ** /f /gang /gstash /gbackup /bandana /capture /claim /reclaim /turfinfo /gspray");
    SendClientMessage(playerid, COLOR_GREY, "** GANG ** /gbuyvehicle /gpark /gfindcar /grespawncars /gsellcar /gunmod /lock /endalliance");
    SendClientMessage(playerid, COLOR_GREY, "** CREW ** /managecrew /crew /locateganghq");
    return 1;
}

CMD:locateganghq(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have a checkpoint use /kcp to clear it.");
    }

    new entranceid = GetGangHQ(PlayerData[playerid][pGang]);
    if (entranceid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have an HQ.");
    }

    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, EntranceInfo[entranceid][ePosX], EntranceInfo[entranceid][ePosY], EntranceInfo[entranceid][ePosZ], 2.5);
    SendClientMessage(playerid, COLOR_GREEN, "Waypoint set to your gang hq");
    return 1;
}

CMD:families(playerid, params[])
{
    return callcmd::gangs(playerid, params);
}

CMD:gangs(playerid, params[])
{
    new gangid;

    if (sscanf(params, "i", gangid))
    {
        SendClientMessage(playerid, COLOR_NAVYBLUE, "___________________ Gangs ___________________");

        for (new i = 0; i < MAX_GANGS; i ++)
        {
            if (GangInfo[i][gSetup])
            {
                OnPlayerListGangs(playerid, i, GangInfo[i][gCount]);
            }
        }
        return 1;
    }
    if (PlayerData[playerid][pGang] != gangid && !IsAdmin(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can view only your gang members.");
    }
    if (!(0 <= gangid < MAX_GANGS) || !GangInfo[gangid][gSetup])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gang.");
    }
    if (GangInfo[gangid][gAlliance] != -1)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Leader: %s - Strikes: %i/3 - Alliance: %s", GangInfo[gangid][gName], GangInfo[gangid][gLeader], GangInfo[gangid][gStrikes], GangInfo[GangInfo[gangid][gAlliance]][gName]);
    }
    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Members Online _____");

    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged] && PlayerData[i][pGang] == gangid)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "(%i) %s %s", PlayerData[i][pGangRank], GangRanks[gangid][PlayerData[i][pGangRank]], GetRPName(i));
        }
    }

    return 1;
}

IsPlayerGangAlliance(playerid, targetid)
{
    if (PlayerData[playerid][pGang] >= 0 && PlayerData[targetid][pGang] >= 0)
    {
        return (PlayerData[playerid][pGang] == GangInfo[PlayerData[targetid][pGang]][gAlliance]);
    }
    return false;
}

CMD:capture(playerid, params[])
{
    return callcmd::claim(playerid, params);
}

CMD:endalliance(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];

    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be in a gang to use this command");
    }

    new allyid = GangInfo[gangid][gAlliance];
    new color, color2;

    if (isnull(params) || strcmp(params, "confirm", true) != 0)
    {
       return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /endalliance [confirm]");
    }
    if (PlayerData[playerid][pGangRank] < 6)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be rank 6 to use this command.");
    }
    if (GangInfo[gangid][gAlliance] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your gang isn't currently in an alliance.");
    }

    SendClientMessageEx(playerid, COLOR_YELLOW, "You just ended your alliance with %s.", GangInfo[gangid][gName]);

    if (GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
    {
        color = 0xC8C8C8FF;
    }
    else
    {
        color = GangInfo[gangid][gColor];
    }
    if (GangInfo[allyid][gColor] == -1 || GangInfo[allyid][gColor] == -256)
    {
        color2 = 0xC8C8C8FF;
    }
    else
    {
        color2 = GangInfo[allyid][gColor];
    }

    SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has ended their alliance with {%06x}%s{FFFFFF} ))", color >>> 8, GangInfo[gangid][gName], color2 >>> 8, GangInfo[allyid][gName]);

    DBQuery("UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", gangid);


    DBQuery("UPDATE "#TABLE_GANGS" SET alliance = -1 WHERE id = %i", allyid);


    GangInfo[allyid][gAlliance] = -1;
    GangInfo[gangid][gAlliance] = -1;

    return 1;
}


publish OnPlayerListGangs(playerid, gangid, members)
{
    new color, color2, gangname[32], allyname[32];
    new alliance = GangInfo[gangid][gAlliance];

    if (GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
    {
        color = 0xC8C8C8FF;
    }
    else
    {
        color = GangInfo[gangid][gColor];
    }

    if (GangInfo[gangid][gIsMafia])
    {
        color = 0x3F3F3FFF;
        format(gangname, sizeof(gangname), "[Mafia] %s", GangInfo[gangid][gName]);
    }
    else
    {
        format(gangname, sizeof(gangname), "%s", GangInfo[gangid][gName]);
    }

    if (alliance >= 0)
    {

        strcpy(allyname, GangInfo[alliance][gName]);

        if (GangInfo[alliance][gColor] == -1 || GangInfo[alliance][gColor] == -256)
        {
            color2 = 0xC8C8C8FF;
        }
        else if (GangInfo[gangid][gIsMafia])
        {
            color = 0x3F3F3FFF;
        }
        else
        {
            color2 = GangInfo[alliance][gColor];
        }
        SendClientMessageEx(playerid, 0xC8C8C8AA, "(Id %i) {%06x}%s{C8C8C8} | Leader: %s | Members: %i/%i | Strikes: %i/3 | Points: %d | Ally: {%06x}%s{C8C8C8}", gangid, color >>> 8, gangname, GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes], GangInfo[gangid][gPoints], color2 >>> 8, allyname);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "(Id %i) {%06x}%s{C8C8C8} | Leader: %s | Members: %i/%i | Strikes: %i/3 | Points: %d", gangid, color >>> 8, gangname, GangInfo[gangid][gLeader], members, GetGangMemberLimit(gangid), GangInfo[gangid][gStrikes], GangInfo[gangid][gPoints]);
    }
}

CMD:gl(playerid, params[])
{

    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }

    if (PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to R5+ to speak in this chat.");
    }

    if (isnull(params))
    {
        return SendUsageHeader(playerid, "gl", "[gang leaders chat]");
    }

    if (PlayerData[playerid][pToggleGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the gang chat as you have it toggled.");
    }

    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot speak in /gl while dead.");
    }

    if (PlayerData[playerid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
    }

    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
    }

    new gangid = PlayerData[playerid][pGang];
    new string[128];
    new rank = PlayerData[playerid][pGangRank];

    format(string, sizeof(string), "[{%06x}%s{FFFFFF}] %s (%d) %s: {800080}%s", GangInfo[gangid][gColor] >>> 8, GangInfo[gangid][gName], GangRanks[gangid][rank], rank, GetPlayerNameEx(playerid), params);

    SetPlayerChatBubble(playerid, string, COLOR_WHITE, 15.0,5000);

    foreach(new i : Player)
    {
        if (!PlayerData[playerid][pToggleGang] && ((PlayerData[i][pGang] != -1 && PlayerData[i][pGangRank] >= 5) || (PlayerData[i][pGangMod])))
        {
            SendClientMessage(i, COLOR_WHITE, string);
        }
    }
    return 1;
}

CMD:gsellgun(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang at the moment.");
    }

    if (!PlayerData[playerid][pGangLeader])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need gang leadership to craft weapons.");
    }

    if(!IsPlayerInRangeOfPoint(playerid, 3.0,  2490.970458, -1668.314819, 3003.500000) && !IsPlayerInRangeOfPoint(playerid, 3.0,  2402.145263, -1668.372314, 3003.500000) && !IsPlayerInRangeOfPoint(playerid, 3.0,  2267.837890, -1668.380737, 3003.500000) && !IsPlayerInRangeOfPoint(playerid, 3.0,  2333.931640, -1668.372680, 3003.500000))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the craft table.");
	}

    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons from within a vehicle.");
    }
    if (gettime() - PlayerData[playerid][pLastSell] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
    }
    new targetid, weapon[10], qty, price;
    if (sscanf(params, "us[10]ii", targetid, weapon, qty, price))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "[Usage]: /gsellgun [playerid] [weapon_name] [quantity] [price]");
        SendWeaponsCraftingCost(playerid);
        return 1;
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot craft this weapons to your gang by yourself.");
    }
    if (qty <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid quantity.");
    }
    if (qty > 20)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Max quantity 20.");
    }
    if (price < 750)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $750.");
    }

    static weaponargs[][eCraftWeaponArgs] = {
        {/*Level*/ 1, "9mm",        22},
        {/*Level*/ 1, "Sdpistol",   23},
        {/*Level*/ 1, "Shotgun",    25},
        {/*Level*/ 2, "Uzi",        28},
        {/*Level*/ 2, "Rifle",      33},
        {/*Level*/ 3, "AK-47",      30},
        {/*Level*/ 3, "Tec-9",      32},
        {/*Level*/ 3, "Deagle",     24},
        {/*Level*/ 4, "MP5",        29},
        {/*Level*/ 4, "M4",         31},
        {/*Level*/ 5, "Spas12",     27},
        {/*Level*/ 5, "Sniper",     34}
    };

    for (new i=0;i<sizeof(weaponargs);i++)
    {
        if (!strcmp(weapon, weaponargs[i][cwa_Name], true))
        {
            if (GetJobLevel(playerid, JOB_ARMSDEALER) < weaponargs[i][cwa_Level])
            {
                return SendClientMessage(playerid, COLOR_GREY, "Your skill level is not high enough to craft this weapon.");
            }
            new weaponid = weaponargs[i][cwa_WeaponID];
            new unitcost = GetCraftWeaponPrice(playerid, weaponid);
            new cost = unitcost * qty;

            if (unitcost == -1)
            {
                return SendClientMessageEx(playerid, COLOR_AQUA, "You cannot craft this weapon {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
            }
            if (PlayerData[playerid][pMaterials] < cost)
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You need %s materials to craft this weapons.", FormatNumber(cost));
            }

            PlayerData[playerid][pLastSell]     = gettime();
            PlayerData[targetid][pSellOffer]    = playerid;
            PlayerData[targetid][pSellType]     = ITEM_GSELLGUN;
            PlayerData[targetid][pSellExtra]    = weaponid;
            PlayerData[targetid][pSellPrice]    = price;
            PlayerData[targetid][pSellQuantity] = qty;

            SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %d %s for $%i. (/accept gangweapons)", GetRPName(playerid), qty, GetWeaponNameEx(weaponid), price);
            SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %d %s to %s for $%i.", qty, GetWeaponNameEx(weaponid), GetRPName(targetid), price);
            break;
        }
    }
    return 1;
}

CMD:mafiaannouncement(playerid, params[]) // mafia annoucement chat
{
    RCHECK(PlayerData[playerid][pGang] != -1, "You are not a gang member.");
    RCHECK(GangInfo[PlayerData[playerid][pGang]][gIsMafia], "You are not a mafia member.");
    RCHECK(PlayerData[playerid][pGangRank] >= 5, "You need to be at least rank 5+ to use this command.");

    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /mafiaannouncement [text]");
        SendClientMessage(playerid, COLOR_YELLOW, "This command sends a SMS to the entire server. Abusing this command will result in heavy punishment.");
        return 1;
    }
    SendClientMessageToAllEx(COLOR_GREY5, "* Dark Web: %s, From Black Mafia *", params);
    SendAdminWarning(2, "%s[%i] has just write %s in dark web.", GetRPName(playerid), playerid, params);
    return 1;
}

// Crew System
DB:OnLoadCrews()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < MAX_GANGS; i ++)
    {
        for (new r = 0; r < MAX_GANG_CREWS; r ++)
        {
            GangCrews[i][r][0] = 0;
        }
    }

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "name", GangCrews[GetDBIntField(i, "id")][GetDBIntField(i, "crewid")], 32);
    }
    printf("[Script] %i crews loaded", rows);
}

CMD:managecrew(playerid, params[])
{
    new targetid, crewid, option[10], param[32];

    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
    }
    if (sscanf(params, "s[10]S()[32]", option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /managecrew [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Create, Remove, List, Assign, Kick");
        return 1;
    }
    if (!strcmp(option, "create", true))
    {
        if (PlayerData[playerid][pGangRank] < 5)
        {
            return SendNoPermission(playerid);
        }
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [create] [name]");
        }

        for (new i = 0; i < MAX_GANG_CREWS; i ++)
        {
            if (isnull(GangCrews[PlayerData[playerid][pGang]][i]))
            {
                strcpy(GangCrews[PlayerData[playerid][pGang]][i], param, 32);
                SendClientMessageEx(playerid, COLOR_AQUA, "You have created crew {FFA763}%s{33CCFF}. The ID of this crew is %i.", param, i);

                DBQuery("INSERT INTO crews VALUES(%i, %i, '%e')", PlayerData[playerid][pGang], i, param);
                return 1;
            }
        }

        SendClientMessageEx(playerid, COLOR_GREY, "Your gang can only have up to %i crews.", MAX_GANG_CREWS);
    }
    else if (!strcmp(option, "remove", true))
    {
        if (PlayerData[playerid][pGangRank] < 5)
        {
            return SendNoPermission(playerid);
        }
        if (sscanf(param, "i", crewid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [remove] [crewid]");
        }
        if (!(0 <= crewid < MAX_GANG_CREWS) || isnull(GangCrews[PlayerData[playerid][pGang]][crewid]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid crew ID.");
        }

        foreach(new i : Player)
        {
            if (PlayerData[i][pGang] == PlayerData[playerid][pGang] && PlayerData[i][pCrew] == crewid)
            {
                PlayerData[i][pCrew] = -1;
                SendClientMessage(i, COLOR_LIGHTRED, "The crew you were apart of has been deleted by the gang owner.");
            }
        }

        SendClientMessageEx(playerid, COLOR_AQUA, "You have deleted crew {F7A763}%s{33CCFF} (%i).", GangCrews[PlayerData[playerid][pGang]][crewid], crewid);
        GangCrews[PlayerData[playerid][pGang]][crewid][0] = 0;

        DBQuery("DELETE FROM crews WHERE id = %i AND crewid = %i", PlayerData[playerid][pGang], crewid);

        DBQuery("UPDATE "#TABLE_USERS" SET crew = -1 WHERE gang = %i", PlayerData[playerid][pGang]);

    }
    else if (!strcmp(option, "list", true))
    {
        SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Crews List _____");

        for (new i = 0; i < MAX_GANG_CREWS; i ++)
        {
            if (isnull(GangCrews[PlayerData[playerid][pGang]][i]))
            {
                SendClientMessageEx(playerid, COLOR_GREY1, "ID: %i | Name: Empty Slot", i);
            }
            else
            {
                SendClientMessageEx(playerid, COLOR_GREY1, "ID: %i | Name: %s", i, GangCrews[PlayerData[playerid][pGang]][i]);
            }
        }
    }
    else if (!strcmp(option, "assign", true))
    {
        if (PlayerData[playerid][pGangRank] < 5)
        {
            return SendNoPermission(playerid);
        }
        if (sscanf(param, "ui", targetid, crewid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [assign] [playerid] [crewid]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
        }
        if (!(0 <= crewid < MAX_GANG_CREWS) || isnull(GangCrews[PlayerData[playerid][pGang]][crewid]))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid crew ID.");
        }
        if (PlayerData[targetid][pCrew] == crewid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of that crew.");
        }
        if (PlayerData[targetid][pCrew] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is already apart of another crew.");
        }

        PlayerData[targetid][pCrew] = crewid;

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has assigned you to the {F7A763}%s{33CCFF} crew.", GetRPName(playerid), GangCrews[PlayerData[playerid][pGang]][crewid]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have assigned %s to the {F7A763}%s{33CCFF} crew.", GetRPName(targetid), GangCrews[PlayerData[playerid][pGang]][crewid]);

        DBQuery("UPDATE "#TABLE_USERS" SET crew = %i WHERE uid = %i", crewid, PlayerData[targetid][pID]);

    }
    else if (!strcmp(option, "kick", true))
    {
        if (PlayerData[playerid][pGangRank] < 5)
        {
            return SendNoPermission(playerid);
        }
        if (sscanf(param, "u", targetid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /crew [kick] [playerid]");
        }
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
        if (PlayerData[targetid][pGang] != PlayerData[playerid][pGang])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of your gang.");
        }
        if (PlayerData[targetid][pCrew] == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is not apart of any crew.");
        }

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has removed you from the {F7A763}%s{33CCFF} crew.", GetRPName(playerid), GangCrews[PlayerData[playerid][pGang]][PlayerData[targetid][pCrew]]);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have removed %s from the {F7A763}%s{33CCFF} crew.", GetRPName(targetid), GangCrews[PlayerData[playerid][pGang]][PlayerData[targetid][pCrew]]);

        DBQuery("UPDATE "#TABLE_USERS" SET crew = -1 WHERE uid = %i", PlayerData[targetid][pID]);


        PlayerData[targetid][pCrew] = -1;
    }

    return 1;
}
