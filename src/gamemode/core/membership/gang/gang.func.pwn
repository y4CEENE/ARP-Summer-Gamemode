
Dialog:DIALOG_GANGSTASH(playerid, response, listitem, inputtext[])
{
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if(response)
    {
        switch(listitem)
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
                if(!GetGangSkinCount(PlayerData[playerid][pGang]))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "There are no skins setup for your gang.");
                }

                PlayerData[playerid][pSkinSelected] = -1;
                Dialog_Show(playerid, DIALOG_GANGSKINS, DIALOG_STYLE_MSGBOX, "Skin selection", "Press {00AA00}>> Next{A9C4E4} to browse through available gang skins.", ">> Next", "Confirm");
            }
            case 4:
            {
                ShowGangClothingMenu(playerid);
            }
            
            case 5:
            {
                if(PlayerData[playerid][pGangRank] < 5)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 5+ to craft weapons.");
                }

                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCRAFT);
            }
            case 6:
            {
                PlayerData[playerid][pSelected] = ITEM_MATERIALS;
                ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
            }
            case 7:
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
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gVestRank])
                {
                    return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least rank %i+ to craft kevlar vests.", GangInfo[PlayerData[playerid][pGang]][gVestRank]);
                }
				if(GangInfo[PlayerData[playerid][pGang]][gMaterials] < 200)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "There aren't enough materials in the safe for kevlar vests.");
				}
				if(GetPlayerArmourEx(playerid) >= 100)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You have a full vest already.");
				}

				GangInfo[PlayerData[playerid][pGang]][gMaterials] -= 200;
				SetScriptArmour(playerid, 100.0);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMaterials], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s takes a kevlar vest from the gang stash.", GetRPName(playerid));
				SendClientMessage(playerid, COLOR_AQUA, "You crafted a kevlar vest using 200 materials from the safe.");
                Log_Write("log_gang", "%s (uid: %i) crafts a kevlar vest using 200 materials from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);

			}
			case 1:
			{
			    if(PlayerData[playerid][pGangRank] < 6)
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
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }

    if(response)
    {
        GangInfo[PlayerData[playerid][pGang]][gVestRank] = listitem;
        SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Kevlar vests{33CCFF} to rank %i+.", listitem);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_vest = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
        mysql_tquery(connectionID, queryBuffer);
	}

	ShowDialogToPlayer(playerid, DIALOG_GANGSTASHVEST);
	return 1;
}
Dialog:DIALOG_GANGSTASHWEAPONS1(playerid, response, listitem, inputtext[])
{
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }
    if(response)
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
  	if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
    }
    if(response)
    {
		if(listitem == 0)
		{
		    if(PlayerData[playerid][pGangRank] < 0)
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "You cannot withdraw weapons.");
            }
            if(PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
			{
				return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
			}

		    switch(PlayerData[playerid][pSelected])
		    {
		        case GANGWEAPON_9MM:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_9MM])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 22))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM]--;
		            GivePlayerWeaponEx(playerid, 22);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_9mm = weapon_9mm - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a 9mm from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a 9mm from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
                case GANGWEAPON_SDPISTOL:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SDPISTOL])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 23))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL]--;
		            GivePlayerWeaponEx(playerid, 23);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_sdpistol = weapon_sdpistol - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a silenced pistol from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a silenced pistol from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_DEAGLE:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_DEAGLE])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 24))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE]--;
		            GivePlayerWeaponEx(playerid, 24);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_deagle = weapon_deagle - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a Desert Eagle from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a Desert Eagle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_SHOTGUN:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SHOTGUN])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 25))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN]--;
		            GivePlayerWeaponEx(playerid, 25);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_shotgun = weapon_shotgun - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a shotgun from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a shotgun from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
                case GANGWEAPON_TEC9:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_TEC9])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 32))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9]--;
		            GivePlayerWeaponEx(playerid, 32);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_tec9 = weapon_tec9 - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a Tec-9 from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a Tec-9 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_UZI:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_UZI])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 28))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI]--;
		            GivePlayerWeaponEx(playerid, 28);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_uzi = weapon_uzi - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a Micro Uzi from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a Micro Uzi from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_MP5:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_MP5])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 29))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5]--;
		            GivePlayerWeaponEx(playerid, 29);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_mp5 = weapon_mp5 - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws an MP5 from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws an MP5 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_AK47:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_AK47])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 30))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47]--;
		            GivePlayerWeaponEx(playerid, 30);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_ak47 = weapon_ak47 - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws an AK-47 from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws an AK-47 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_RIFLE:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_RIFLE])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 33))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE]--;
		            GivePlayerWeaponEx(playerid, 33);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_rifle = weapon_rifle - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a rifle from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a rifle from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_M4:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_M4])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 31))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4]--;
		            GivePlayerWeaponEx(playerid, 31);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_m4 = weapon_m4 - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a M4 from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a M4 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_SPAS12:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SPAS12])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 27))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12]--;
		            GivePlayerWeaponEx(playerid, 27);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_spas12 = weapon_spas12 - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a spas12 from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a spas12 from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_SNIPER:
		        {
		            if(PlayerData[playerid][pGangRank] < GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SNIPER])
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "Your rank isn't high enough to withdraw this weapon.");
					}
		            if(GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER] <= 0)
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "The gang stash doesn't have any of this weapon left.");
		            }
		            if(PlayerHasWeapon(playerid, 34))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You have this weapon already.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER]--;
		            GivePlayerWeaponEx(playerid, 34);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_sniper = weapon_sniper - 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s withdraws a sniper from the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) withdraws a sniper from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
			}
		}
		else if(listitem == 1)
        {
            if(IsLawEnforcement(playerid))
			{
		    	return SendClientMessage(playerid, COLOR_GREY, "Law enforcement is prohibited from storing weapons.");
			}
            if(GetPlayerHealthEx(playerid) < 60)
			{
			    return SendClientMessage(playerid, COLOR_GREY, "You can't store weapons as your health is below 60.");
			}

            switch(PlayerData[playerid][pSelected])
		    {
		        case GANGWEAPON_9MM:
		        {
		            if(!PlayerHasWeapon(playerid, 22))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_9MM]++;
		            RemovePlayerWeapon(playerid, 22);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_9mm = weapon_9mm + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a 9mm in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a 9mm in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
                case GANGWEAPON_SDPISTOL:
		        {
		            if(!PlayerHasWeapon(playerid, 23))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SDPISTOL]++;
		            RemovePlayerWeapon(playerid, 23);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_sdpistol = weapon_sdpistol + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a silenced pistol in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a silenced pistol in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_DEAGLE:
		        {
		            if(!PlayerHasWeapon(playerid, 24))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_DEAGLE]++;
		            RemovePlayerWeapon(playerid, 24);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_deagle = weapon_deagle + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a Desert Eagle in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a Desert Eagle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_SHOTGUN:
		        {
		            if(!PlayerHasWeapon(playerid, 25))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SHOTGUN]++;
		            RemovePlayerWeapon(playerid, 25);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_shotgun = weapon_shotgun + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a shotgun in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a shotgun in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_M4,GANGWEAPON_SPAS12,GANGWEAPON_SNIPER:
				{
					return SendClientMessage(playerid, COLOR_GREY, "You can't store this weapon.");
				}
				//case GANGWEAPON_SPAS12:
		        //{
		        //    if(!PlayerHasWeapon(playerid, 27))
		        //    {
		        //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
				//	}
				//
		        //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SPAS12]++;
		        //    RemovePlayerWeapon(playerid, 27);
				//
		        //    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_spas12 = weapon_spas12 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		        //    mysql_tquery(connectionID, queryBuffer);
				//
		        //    ShowActionBubble(playerid, "* %s deposits a SPAS-12 in the gang stash.", GetRPName(playerid));
		        //    Log_Write("log_gang", "%s (uid: %i) deposits a SPAS-12 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				//}
				//case GANGWEAPON_SAWNOFF:
		        //{
		        //    if(!PlayerHasWeapon(playerid, 26))
		        //    {
		        //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
				//	}
				//
		        //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SAWNOFF]++;
		        //    RemovePlayerWeapon(playerid, 26);
				//
		        //    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_sawnoff = weapon_sawnoff + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		        //    mysql_tquery(connectionID, queryBuffer);
				//
		        //    ShowActionBubble(playerid, "* %s deposits a sawnoff shotgun in the gang stash.", GetRPName(playerid));
		        //    Log_Write("log_gang", "%s (uid: %i) deposits a sawnoff shotgun in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				//}
                case GANGWEAPON_TEC9:
		        {
		            if(!PlayerHasWeapon(playerid, 32))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_TEC9]++;
		            RemovePlayerWeapon(playerid, 32);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_tec9 = weapon_tec9 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a Tec-9 in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a Tec-9 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_UZI:
		        {
		            if(!PlayerHasWeapon(playerid, 28))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_UZI]++;
		            RemovePlayerWeapon(playerid, 28);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_uzi = weapon_uzi + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a Micro Uzi in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a Micro Uzi in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_MP5:
		        {
		            if(!PlayerHasWeapon(playerid, 29))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MP5]++;
		            RemovePlayerWeapon(playerid, 29);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_mp5 = weapon_mp5 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits an MP5 in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits an MP5 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				case GANGWEAPON_AK47:
		        {
		            if(!PlayerHasWeapon(playerid, 30))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_AK47]++;
		            RemovePlayerWeapon(playerid, 30);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_ak47 = weapon_ak47 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits an AK-47 in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits an AK-47 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				//case GANGWEAPON_M4:
		        //{
		        //    if(!PlayerHasWeapon(playerid, 31))
		        //    {
		        //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
				//	}
				//
		        //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_M4]++;
		        //    RemovePlayerWeapon(playerid, 31);
				//
		        //    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_m4 = weapon_m4 + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		        //    mysql_tquery(connectionID, queryBuffer);
				//
		        //    ShowActionBubble(playerid, "* %s deposits an M4 in the gang stash.", GetRPName(playerid));
		        //    Log_Write("log_gang", "%s (uid: %i) deposits an M4 in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				//}
				case GANGWEAPON_RIFLE:
		        {
		            if(!PlayerHasWeapon(playerid, 33))
		            {
		                return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
					}

		            GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_RIFLE]++;
		            RemovePlayerWeapon(playerid, 33);

		            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_rifle = weapon_rifle + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		            mysql_tquery(connectionID, queryBuffer);

		            ShowActionBubble(playerid, "* %s deposits a rifle in the gang stash.", GetRPName(playerid));
		            Log_Write("log_gang", "%s (uid: %i) deposits a rifle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				}
				//		case GANGWEAPON_SNIPER:
		        //{
		        //    if(!PlayerHasWeapon(playerid, 34))
		        //    {
		        //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
				//	}
				//
		        //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_SNIPER]++;
		        //    RemovePlayerWeapon(playerid, 34);
				//
		        //    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_sniper = weapon_sniper + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		        //    mysql_tquery(connectionID, queryBuffer);
				//
		        //    ShowActionBubble(playerid, "* %s deposits a sniper rifle in the gang stash.", GetRPName(playerid));
		        //    Log_Write("log_gang", "%s (uid: %i) deposits a sniper rifle in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				//}
				//case GANGWEAPON_MOLOTOV:
		        //{
		        //    if(!PlayerHasWeapon(playerid, 18))
		        //    {
		        //        return SendClientMessage(playerid, COLOR_GREY, "You don't have this weapon.");
				//	}
				//
		        //    GangInfo[PlayerData[playerid][pGang]][gWeapons][GANGWEAPON_MOLOTOV]++;
		        //    RemovePlayerWeapon(playerid, 18);
				//
		        //    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weapon_molotov = weapon_molotov + 1 WHERE id = %i", PlayerData[playerid][pGang]);
		        //    mysql_tquery(connectionID, queryBuffer);
				//
		        //    ShowActionBubble(playerid, "* %s deposits a molotov in the gang stash.", GetRPName(playerid));
		        //    Log_Write("log_gang", "%s (uid: %i) deposits a molotov in the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
				//}
			}
		}
		else if(listitem == 2)
		{
		    if(PlayerData[playerid][pGangRank] < 6)
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
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
	}

    if(response)
    {
        switch(PlayerData[playerid][pSelected])
        {
            case GANGWEAPON_9MM:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_9MM] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}9mm{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_9mm = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_SDPISTOL:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SDPISTOL] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Silenced pistol{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_9mm = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_DEAGLE:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_DEAGLE] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Desert Eagle{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_deagle = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_SHOTGUN:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SHOTGUN] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Shotgun{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_shotgun = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
    		case GANGWEAPON_TEC9:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_TEC9] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Tec-9{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_tec9 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_UZI:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_UZI] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Micro Uzi{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_uzi = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_MP5:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_MP5] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}MP5{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_mp5 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_AK47:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_AK47] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}AK-47{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_ak47 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_RIFLE:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_RIFLE] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Rifle{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_rifle = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_M4:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_M4] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}M4{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_m4 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_SPAS12:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SPAS12] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Spas12{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_spas12 = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case GANGWEAPON_SNIPER:
            {
                GangInfo[PlayerData[playerid][pGang]][gWeaponRanks][GANGWEAPON_SNIPER] = listitem;
                SendClientMessageEx(playerid, COLOR_AQUA, "You have set the rank restriction for {FF6347}Sniper{33CCFF} to rank %i+.", listitem);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET rank_sniper = %i WHERE id = %i", listitem, PlayerData[playerid][pGang]);
                mysql_tquery(connectionID, queryBuffer);
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
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
	}

    if(response)
    {
        switch(listitem)
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
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
	}

    if(response)
    {
        if(listitem == 0)
        {
            if(PlayerData[playerid][pGangRank] < 2)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 2+ in order to withdraw drugs.");
            }

            ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
        }
        else if(listitem == 1)
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
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 3)
    {
        return 1;
	}

	if(response)
	{
	    new amount;

	    if(sscanf(inputtext, "i", amount))
	    {
	        return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
		}

		switch(PlayerData[playerid][pSelected])
		{
		    case ITEM_WEED:
		    {
		        if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gWeed])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				if(PlayerData[playerid][pWeed] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				GangInfo[PlayerData[playerid][pGang]][gWeed] -= amount;
				PlayerData[playerid][pWeed] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weed = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gWeed], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s withdraws some weed from the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i grams of weed from the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) withdraws %i grams of weed from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_COCAINE:
		    {
		        if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gCocaine])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				if(PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i crack. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				GangInfo[PlayerData[playerid][pGang]][gCocaine] -= amount;
				PlayerData[playerid][pCocaine] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET cocaine = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCocaine], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s withdraws some crack from the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i grams of crack from the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) withdraws %i grams of crack from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
            case ITEM_HEROIN:
		    {
		        if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gHeroin])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				if(PlayerData[playerid][pHeroin] + amount > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				GangInfo[PlayerData[playerid][pGang]][gHeroin] -= amount;
				PlayerData[playerid][pHeroin] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET heroin = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gHeroin], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s withdraws some Heroin from the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i grams of Heroin from the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) withdraws %i grams of Heroin from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_PAINKILLERS:
		    {
		        if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gPainkillers])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				if(PlayerData[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				GangInfo[PlayerData[playerid][pGang]][gPainkillers] -= amount;
				PlayerData[playerid][pPainkillers] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET painkillers = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPainkillers], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s withdraws some painkillers from the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i painkillers from the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) withdraws %i painkillers from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_MATERIALS:
		    {
		        if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gMaterials])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}
				if(PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				GangInfo[PlayerData[playerid][pGang]][gMaterials] -= amount;
				PlayerData[playerid][pMaterials] += amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMaterials], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s withdraws some materials from the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %i materials from the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) withdraws %i materials from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_CASH:
		    {
		        if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gCash])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
				}

				GangInfo[PlayerData[playerid][pGang]][gCash] -= amount;
				GivePlayerCash(playerid, amount);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCash], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s withdraws some cash from the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have withdrawn %s from the gang stash.", FormatCash(amount));
				Log_Write("log_gang", "%s (uid: %i) withdraws $%i from the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
		}
	}
	else
	{
	    if(PlayerData[playerid][pSelected] == ITEM_MATERIALS) {
	        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
		} else if(PlayerData[playerid][pSelected] == ITEM_CASH) {
			ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
		} else {
		    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
		}
	}
	return 1;
}
Dialog:DIALOG_GANGDEPOSIT(playerid, response, listitem, inputtext[])
{
    if(PlayerData[playerid][pGang] == -1)
    {
        return 1;
	}

	if(response)
	{
	    new amount;

	    if(sscanf(inputtext, "i", amount))
	    {
	        return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
		}

		switch(PlayerData[playerid][pSelected])
		{
		    case ITEM_WEED:
		    {
		        if(amount < 1 || amount > PlayerData[playerid][pWeed])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gWeed] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i grams of weed.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				GangInfo[PlayerData[playerid][pGang]][gWeed] += amount;
				PlayerData[playerid][pWeed] -= amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET weed = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gWeed], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s deposits some weed in the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i grams of weed in the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) deposits %i grams of weed in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_COCAINE:
		    {
		        if(amount < 1 || amount > PlayerData[playerid][pCocaine])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gCocaine] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i grams of crack.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				GangInfo[PlayerData[playerid][pGang]][gCocaine] += amount;
				PlayerData[playerid][pCocaine] -= amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET cocaine = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCocaine], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s deposits some crack in the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i grams of crack in the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) deposits %i grams of crack in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
            case ITEM_HEROIN:
		    {
		        if(amount < 1 || amount > PlayerData[playerid][pHeroin])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gHeroin] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i grams of heroin.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				GangInfo[PlayerData[playerid][pGang]][gHeroin] += amount;
				PlayerData[playerid][pHeroin] -= amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET heroin = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gHeroin], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s deposits some Heroin in the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i grams of Heroin in the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) deposits %i grams of Heroin in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_PAINKILLERS:
		    {
		        if(amount < 1 || amount > PlayerData[playerid][pPainkillers])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gPainkillers] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i painkillers.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				GangInfo[PlayerData[playerid][pGang]][gPainkillers] += amount;
				PlayerData[playerid][pPainkillers] -= amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET painkillers = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPainkillers], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s deposits some painkillers in the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i painkillers in the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) deposits %i painkillers in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_MATERIALS:
		    {
		        if(amount < 1 || amount > PlayerData[playerid][pMaterials])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gMaterials] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than %i materials.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS));
				    return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				GangInfo[PlayerData[playerid][pGang]][gMaterials] += amount;
				PlayerData[playerid][pMaterials] -= amount;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMaterials], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s deposits some materials in the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i materials in the gang stash.", amount);
				Log_Write("log_gang", "%s (uid: %i) deposits %i materials in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
			case ITEM_CASH:
		    {
		        if(amount < 1 || amount > PlayerData[playerid][pCash])
		        {
		            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
		            return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gCash] + amount > GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "The gang stash can't contain more than $%i.", GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH));
					return ShowDialogToPlayer(playerid, DIALOG_GANGDEPOSIT);
				}

				GangInfo[PlayerData[playerid][pGang]][gCash] += amount;
				GivePlayerCash(playerid, -amount);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gCash], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				ShowActionBubble(playerid, "* %s deposits some cash in the gang stash.", GetRPName(playerid));
				SendClientMessageEx(playerid, COLOR_AQUA, "* You have deposited %i in the gang stash.", FormatCash(amount));
				Log_Write("log_gang", "%s (uid: %i) deposited $%i in the gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount);
			}
		}
	}
	else
	{
		if(PlayerData[playerid][pSelected] == ITEM_MATERIALS) {
	        ShowDialogToPlayer(playerid, DIALOG_GANGSTASHMATS);
		} else if(PlayerData[playerid][pSelected] == ITEM_CASH) {
			ShowDialogToPlayer(playerid, DIALOG_GANGSTASHCASH);
		} else {
		    ShowDialogToPlayer(playerid, DIALOG_GANGSTASHDRUGS2);
		}
	}
	return 1;
}

stock AddWeaponToGangStash(gangid, weaponid, qty=1)
{
	switch(weaponid) {
		case 22: 
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_9MM] = GangInfo[gangid][gWeapons][GANGWEAPON_9MM]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_9mm = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_9MM], gangid);
		} 
		case 23:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL] = GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_sdpistol = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL], gangid);
		}
		case 24:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] = GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_deagle = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE], gangid);
		}
		case 25:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN] = GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_shotgun = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN], gangid);
		}
		case 32:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_TEC9] = GangInfo[gangid][gWeapons][GANGWEAPON_TEC9]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_tec9 = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_TEC9], gangid);
		}
		case 28:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_UZI] = GangInfo[gangid][gWeapons][GANGWEAPON_UZI]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_uzi = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_UZI], gangid);
		}
		case 29:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_MP5] = GangInfo[gangid][gWeapons][GANGWEAPON_MP5]  + qty;	
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_mp5 = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_AK47], gangid);
		}
		case 30:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_AK47] = GangInfo[gangid][gWeapons][GANGWEAPON_AK47]  + qty;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_ak47 = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_AK47], gangid);
		}
		case 33:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE] = GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE]  + qty ;	
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_rifle = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE], gangid);
		}
		case 31:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_M4] = GangInfo[gangid][gWeapons][GANGWEAPON_M4]  + qty;	
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_m4 = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_M4], gangid);
		}
		case 27:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12] = GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12]  + qty;	
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_spas12 = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SPAS12], gangid);
		}
		case 34:
		{
			GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER] = GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER]  +  qty;	
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET materials = %i, weapon_sniper = %i WHERE id = %i", 
				GangInfo[gangid][gMaterials], GangInfo[gangid][gWeapons][GANGWEAPON_SNIPER], gangid);
		}
		default: return 0;
	}
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

Dialog:DIALOG_GANGSTASHCRAFT(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		new weaponid = 0;
		switch(listitem)
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
		if(weaponid == 0 || cost < 0)
		{
			return 1;
		}

		if(GangInfo[gangid][gMaterials] < cost)
		{
			return SendClientMessage(playerid, COLOR_GREY, "There aren't enough materials in the safe.");
		}

		GangInfo[gangid][gMaterials] -= cost;
		if(AddWeaponToGangStash(gangid, weaponid))
		{
			ShowActionBubble(playerid, "* %s crafts %s and stores it to the gang stash.", GetRPName(playerid), GetWeaponNameEx(weaponid));
			SendClientMessageEx(playerid, COLOR_AQUA, "You used %d materials from your gang stash to craft an %s.", cost, GetWeaponNameEx(weaponid));
			Log_Write("log_gang", "%s (uid: %i) crafts an %s using %d materials from the %s (id: %i) gang stash.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], 
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
    if(response)
    {
        if(listitem == 0)
		{
		    if(PlayerData[playerid][pGangRank] < 6)
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 6+ in order to withdraw materials.");
            }

			ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
		}
		else if(listitem == 1)
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
    if(response)
    {
        if(listitem == 0)
		{
		    if(PlayerData[playerid][pGangRank] < 6)
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 6+ in order to withdraw cash.");
            }

			ShowDialogToPlayer(playerid, DIALOG_GANGWITHDRAW);
		}
		else if(listitem == 1)
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
    if(PlayerData[playerid][pGang] >= 0)
    {
        if(response)
        {
			new index = PlayerData[playerid][pSkinSelected] + 1;

			if(index >= MAX_GANG_SKINS)
			{
			    // When the player is shown the dialog for the first time, their skin isn't chnaged until they click >> Next.
			    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
			    PlayerData[playerid][pSkinSelected] = -1;
			}
			else
			{
			    // Find the next skin in the array.
				for(new i = index; i < MAX_GANG_SKINS; i ++)
				{
				    if(GangInfo[PlayerData[playerid][pGang]][gSkins][i] != 0)
				    {
				        SetPlayerSkin(playerid, GangInfo[PlayerData[playerid][pGang]][gSkins][i]);
				        PlayerData[playerid][pSkinSelected] = i;
				        break;
			        }
                }

                if(index == PlayerData[playerid][pSkinSelected] + 1)
                {
                    // Looks like there was no skin found. So, we'll go back to the very first valid skin in the skin array.
                    for(new i = 0; i < MAX_GANG_SKINS; i ++)
					{
				    	if(GangInfo[PlayerData[playerid][pGang]][gSkins][i] != 0)
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
    if(response)
    {
        new count, garageid;

        foreach(new i: Vehicle)
	 	{
	 	    if((VehicleInfo[i][vID] > 0 && VehicleInfo[i][vGang] == PlayerData[playerid][pGang]) && (count++ == listitem))
	 	    {
                PlayerData[playerid][pCP] = CHECKPOINT_MISC;

	            if((garageid = GetVehicleGarage(i)) >= 0)
	            {
	                SetPlayerCheckpoint(playerid, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
	                SendClientMessageEx(playerid, COLOR_YELLOW, "This %s is located in a garage. Checkpoint marked at the garage's location.", GetVehicleName(i));
	            }
	            else
	            {
	                new
	                    Float:x,
	                    Float:y,
	                    Float:z;

	                GetVehiclePos(i, x, y, z);
	                SetPlayerCheckpoint(playerid, x, y, z, 3.0);
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
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
    }

    if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
				}
				if(PlayerData[playerid][pCash] < 50000)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You need $50,000 on hand to purchase this upgrade.");
				}
				if(GangInfo[PlayerData[playerid][pGang]][gDrugDealer])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Your gang already has this upgrade.");
				}

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

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET drugdealer = 1, drug_x = 0.0, drug_y = 0.0, drug_z = 0.0, drugweed = 0, drugcocaine = 0, drugHeroin = 0, weed_price = 500, cocaine_price = 1000, heroin_price = 1500, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				GivePlayerCash(playerid, -50000);
				SendClientMessage(playerid, COLOR_AQUA, "You have spent 500 GP & $50,000 on an {00AA00}NPC drug dealer{33CCFF}. '/gang npc' to edit your drug dealer.");
				Log_Write("log_gang", "%s (uid: %i) spent 500 GP & $50000 on an NPC drug dealer for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
			}
			case 1:
            {
                if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
				}
				if(PlayerData[playerid][pCash] < 50000)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You need $50,000 on hand to purchase this upgrade.");
				}
				if(GangInfo[PlayerData[playerid][pGang]][gArmsDealer])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "Your gang already has this upgrade.");
				}

				GangInfo[PlayerData[playerid][pGang]][gArmsDealer] = 1;
				GangInfo[PlayerData[playerid][pGang]][gArmsX] = 0.0;
				GangInfo[PlayerData[playerid][pGang]][gArmsY] = 0.0;
				GangInfo[PlayerData[playerid][pGang]][gArmsZ] = 0.0;
				GangInfo[PlayerData[playerid][pGang]][gArmsMaterials] = 0;
				GangInfo[PlayerData[playerid][pGang]][gPoints] -= 500;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsdealer = 1, arms_x = 0.0, arms_y = 0.0, arms_z = 0.0, armsmaterials = 0, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				GivePlayerCash(playerid, -50000);
				SendClientMessage(playerid, COLOR_AQUA, "You have spent 500 GP & $50,000 on an {00AA00}NPC arms dealer{33CCFF}. '/gang npc' to edit your arms dealer.");
				Log_Write("log_gang", "%s (uid: %i) spent 500 GP & $50000 on an NPC arm dealer for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
			}
			case 2:
			{
			    if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 400)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
				}
				if(PlayerData[playerid][pCash] < 75000)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You need $75,000 on hand to purchase this upgrade.");
				}

				GivePlayerCash(playerid, -75000);
				GiveGangPoints(PlayerData[playerid][pGang], -400);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Gang point redemption', NOW(), 'Duel arena')", PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				SendClientMessage(playerid, COLOR_AQUA, "You have spent 400 GP & $75,000 on a {00AA00}Duel arena{33CCFF}. /report for an admin to set it up.");
				SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a duel arena for their gang.", GetRPName(playerid), playerid);
			}
            case 3:
			{
			    if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 4500)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
				}
				if(PlayerData[playerid][pCash] < 100000)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You need $100,000 on hand to purchase this upgrade.");
				}

				GivePlayerCash(playerid, -100000);
				GiveGangPoints(PlayerData[playerid][pGang], -4500);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Gang point redemption', NOW(), 'Gang mapping (up to 50 objects)')", PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				SendClientMessage(playerid, COLOR_AQUA, "You have spent 4500 GP & $100,000 on {00AA00}Mapping{33CCFF}. /report for an admin to set it up.");
				SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for mapping for their gang.", GetRPName(playerid), playerid);
			}
			case 4:
			{
			    if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 5000)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
				}
				if(PlayerData[playerid][pCash] < 100000)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You need $100,000 on hand to purchase this upgrade.");
				}

				GivePlayerCash(playerid, -100000);
				GiveGangPoints(PlayerData[playerid][pGang], -5000);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Gang point redemption', NOW(), 'Custom gang interior')", PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				SendClientMessage(playerid, COLOR_AQUA, "You have spent 5000 GP & $100,000 on {00AA00}Custom gang interior{33CCFF}. /report for an admin to set it up.");
				SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has a pending flag for a custom gang interior.", GetRPName(playerid), playerid);
			}
			case 5:
			{
			    new cashNeeded = 100000 + (50000*GangInfo[PlayerData[playerid][pGang]][gMatLevel]);
				new pointsNeeded = 1500 + (500*GangInfo[PlayerData[playerid][pGang]][gMatLevel]);
			    if(GangInfo[PlayerData[playerid][pGang]][gPoints] < pointsNeeded)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
			    }
			    if(PlayerData[playerid][pCash] < cashNeeded)
				{
    				return SendClientMessageEx(playerid, COLOR_GREY, "You need $%i on hand to purchase this upgrade.", cashNeeded);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gMatLevel] + 1 > 3)
				{
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang's materials upgrade is already maxed out. (3/3)");
				}

				GangInfo[PlayerData[playerid][pGang]][gMatLevel]++;
				GangInfo[PlayerData[playerid][pGang]][gPoints] -= pointsNeeded;
				GivePlayerCash(playerid, -cashNeeded);
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET matlevel = %i, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gMatLevel], GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				SendClientMessageEx(playerid, COLOR_GREEN, "You have spent %i GP & $%i for materials upgrade %i/3", pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gMatLevel]);
				SendClientMessageEx(playerid, COLOR_GREEN, "Your gang will now receive %i materials from each material-class turf captured.", (10000+(5000*GangInfo[PlayerData[playerid][pGang]][gMatLevel])));

                Log_Write("log_gang", "%s (uid: %i) spent %i GP & $%i for gang level %i/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gMatLevel], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
			}
			case 6:
			{
			    new cashNeeded = 40000 + (20000 * GangInfo[PlayerData[playerid][pGang]][gGunLevel]);
				new pointsNeeded = 1500 + (250*GangInfo[PlayerData[playerid][pGang]][gGunLevel]);
				if(GangInfo[PlayerData[playerid][pGang]][gPoints] < pointsNeeded)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
			    }
			    if(PlayerData[playerid][pCash] < cashNeeded)
				{
    				return SendClientMessageEx(playerid, COLOR_GREY, "You need $%i on hand to purchase this upgrade.", cashNeeded);
				}
				if(GangInfo[PlayerData[playerid][pGang]][gGunLevel] + 1 > 5)
				{
                    return SendClientMessage(playerid, COLOR_GREY, "Your gang's gun upgrade is already maxed out. (5/5");
				}

				GangInfo[PlayerData[playerid][pGang]][gGunLevel]++;
				GangInfo[PlayerData[playerid][pGang]][gPoints] -= pointsNeeded;
				GivePlayerCash(playerid, -cashNeeded);
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET gunlevel = %i, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gGunLevel], GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
				mysql_tquery(connectionID, queryBuffer);

				SendClientMessageEx(playerid, COLOR_GREEN, "You have spent %i GP & $%i for guns upgrade %i/5", pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gGunLevel]);
				SendClientMessageEx(playerid, COLOR_GREEN, "Your gang will now receive %i guns from each weapon-class turf captured.", (10+GangInfo[PlayerData[playerid][pGang]][gGunLevel]));


				Log_Write("log_gang", "%s (uid: %i) spent %i GP & $%i for gang level %i/5 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], pointsNeeded, cashNeeded, GangInfo[PlayerData[playerid][pGang]][gGunLevel], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
			}
			case 7:
			{
			    switch(GangInfo[PlayerData[playerid][pGang]][gLevel])
			    {
			        case 1:
			        {
			            if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 6000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
						}
						if(PlayerData[playerid][pCash] < 75000)
						{
						    return SendClientMessage(playerid, COLOR_GREY, "You need $75,000 on hand to purchase this upgrade.");
						}

						GangInfo[PlayerData[playerid][pGang]][gLevel] = 2;
						GangInfo[PlayerData[playerid][pGang]][gPoints] -= 6000;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET level = 2, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						GivePlayerCash(playerid, -75000);
						ReloadGang(PlayerData[playerid][pGang]);

						SendClientMessageEx(playerid, COLOR_GREEN, "You have spent 6000 GP & $75,000 for gang level 2/3. Your gang can now have %i members & %i gang vehicles.", GetGangMemberLimit(PlayerData[playerid][pGang]), GetGangVehicleLimit(PlayerData[playerid][pGang]));
						SendClientMessage(playerid, COLOR_GREEN, "Your capacity for items in your gang stash has also been increased. Access your gang stash to learn more!");

						Log_Write("log_gang", "%s (uid: %i) spent 6000 GP & $75000 for gang level 2/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
					}
					case 2:
			        {
			            if(GangInfo[PlayerData[playerid][pGang]][gPoints] < 12000)
		                {
		                    return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have enough points.");
						}
						if(PlayerData[playerid][pCash] < 100000)
						{
						    return SendClientMessage(playerid, COLOR_GREY, "You need $100,000 on hand to purchase this upgrade.");
						}

						GangInfo[PlayerData[playerid][pGang]][gLevel] = 3;
						GangInfo[PlayerData[playerid][pGang]][gPoints] -= 12000;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET level = 3, points = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gPoints], PlayerData[playerid][pGang]);
						mysql_tquery(connectionID, queryBuffer);

						GivePlayerCash(playerid, -100000);
						ReloadGang(PlayerData[playerid][pGang]);

						SendClientMessageEx(playerid, COLOR_GREEN, "You have spent 12000 GP & $100,000 for gang level 3/3. Your gang can now have %i members & %i gang vehicles.", GetGangMemberLimit(PlayerData[playerid][pGang]), GetGangVehicleLimit(PlayerData[playerid][pGang]));
						SendClientMessage(playerid, COLOR_GREEN, "Your capacity for items in your gang stash has also been increased. Access your gang stash to learn more!");

						Log_Write("log_gang", "%s (uid: %i) spent 12000 GP & $100000 for gang level 3/3 for %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[PlayerData[playerid][pGang]][gName], PlayerData[playerid][pGang]);
					}
				}
			}
        }
    }
    return 1;
}
Dialog:DIALOG_GANGARMSPRICES(playerid, response, listitem, inputtext[])
{
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return 1;
    }

    if(response)
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
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return 1;
    }

    if(response)
    {
        new amount;

        if(sscanf(inputtext, "i", amount))
        {
            return Dialog_Show(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item", "Submit", "Back");
		}
		if(amount < 0)
		{
		    SendClientMessage(playerid, COLOR_GREY, "The amount can't be below $0.");
		    return Dialog_Show(playerid, DIALOG_GANGARMSPRICE, DIALOG_STYLE_INPUT, "Arms dealer | Prices", "Enter the new price for this item", "Submit", "Back");
		}

		GangInfo[PlayerData[playerid][pGang]][gArmsPrices][PlayerData[playerid][pSelected]] = amount;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsprice_%i = %i WHERE id = %i", PlayerData[playerid][pSelected] + 1, amount, PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);

		if(PlayerData[playerid][pSelected] == 0) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Micro Uzi{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 1) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Tec-9{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 2) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}MP5{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 3) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Desert Eagle{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 4) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Molotov{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 5) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}AK-47{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 6) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}M4{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 7) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Sniper{33CCFF} to $%i.", amount);
        } else if(PlayerData[playerid][pSelected] == 8) {
		    SendClientMessageEx(playerid, COLOR_AQUA, "You have set the price of {00AA00}Sawnoff Shotgun{33CCFF} to $%i.", amount);
        }
    }

    ShowDialogToPlayer(playerid, DIALOG_GANGARMSPRICES);
    return 1;
}
Dialog:DIALOG_GANGARMSDEALER(playerid, response, listitem, inputtext[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerData[playerid][pDealerGang]][gArmsX], GangInfo[PlayerData[playerid][pDealerGang]][gArmsY], GangInfo[PlayerData[playerid][pDealerGang]][gArmsZ]))
    {
        return 1;
	}

	if(response)
	{
	    if(listitem == 0)
	    {
			ShowDialogToPlayer(playerid, DIALOG_GANGARMSWEAPONS);
		}
		else if(listitem == 1)
		{
		    if(PlayerData[playerid][pGang] != PlayerData[playerid][pDealerGang])
		    {
		        return SendClientMessage(playerid, COLOR_GREY, "This arms dealer doesn't belong to your gang.");
		    }
		    if(PlayerData[playerid][pGangRank] < 6)
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
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[PlayerData[playerid][pDealerGang]][gArmsX], GangInfo[PlayerData[playerid][pDealerGang]][gArmsY], GangInfo[PlayerData[playerid][pDealerGang]][gArmsZ]))
    {
        return 1;
	}

	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 500)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 500;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 28);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a micro uzi.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}micro uzi{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 1:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 500)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 500;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 32);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a Tec-9.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}Tec-9{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 2:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 1000)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 1000;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 29);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received an MP5.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased an {00AA00}MP5{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 3:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 2000)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 2000;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 24);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a Desert Eagle.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}Desert Eagle{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 4:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 5000)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 5000;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 18);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a molotov.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}molotov{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 5:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 3000)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 3000;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 30);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received an AK-47.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased an {00AA00}AK-47{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 6:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 4000)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 4000;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 31);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received an M4.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased an {00AA00}M4{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 7:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 6500)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 6500;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

	            GivePlayerCash(playerid, -GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            GivePlayerWeaponEx(playerid, 34);

	            ShowActionBubble(playerid, "* %s paid $%i to the arms dealer and received a sniper.", GetRPName(playerid), GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	            SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a {00AA00}sniper{33CCFF} for $%i.", GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem]);
	        }
	        case 8:
	        {
	            if(GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] < 3000)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "This gang's arms dealer doesn't have enough materials for this weapon.");
				}
				if(PlayerData[playerid][pCash] < GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem])
				{
				    return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase this weapon.");
	            }

	            GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials] -= 3000;
	            GangInfo[PlayerData[playerid][pDealerGang]][gCash] += GangInfo[PlayerData[playerid][pDealerGang]][gArmsPrices][listitem];

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i, cash = %i WHERE id = %i", GangInfo[PlayerData[playerid][pDealerGang]][gArmsMaterials], GangInfo[PlayerData[playerid][pDealerGang]][gCash], PlayerData[playerid][pDealerGang]);
	            mysql_tquery(connectionID, queryBuffer);

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
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
	}

	if(response)
	{
	    switch(listitem)
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
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
	}

	if(response)
	{
	    new amount;

	    if(sscanf(inputtext, "i", amount))
	    {
	        return ShowDialogToPlayer(playerid, GangStashDepositMats);
		}
		if(amount < 1 || amount > PlayerData[playerid][pMaterials])
		{
		    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	        return ShowDialogToPlayer(playerid, GangStashDepositMats);
	    }

	    GangInfo[PlayerData[playerid][pGang]][gArmsMaterials] += amount;
	    PlayerData[playerid][pMaterials] -= amount;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials], PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "You have deposited %i materials in your arms dealer NPC.", amount);
	}

	ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
	return 1;
}
Dialog:GangStashWithdrawMats(playerid, response, listitem, inputtext[])
{
    if(PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 6)
    {
        return 1;
	}

	if(response)
	{
	    new amount;

	    if(sscanf(inputtext, "i", amount))
	    {
	        return ShowDialogToPlayer(playerid, GangStashWithdrawMats);
		}
		if(amount < 1 || amount > GangInfo[PlayerData[playerid][pGang]][gArmsMaterials])
		{
		    SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	        return ShowDialogToPlayer(playerid, GangStashWithdrawMats);
	    }

	    GangInfo[PlayerData[playerid][pGang]][gArmsMaterials] -= amount;
	    PlayerData[playerid][pMaterials] += amount;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GANGS" SET armsmaterials = %i WHERE id = %i", GangInfo[PlayerData[playerid][pGang]][gArmsMaterials], PlayerData[playerid][pGang]);
		mysql_tquery(connectionID, queryBuffer);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_AQUA, "You have withdrawn %i materials from your arms dealer NPC.", amount);
	}

	ShowDialogToPlayer(playerid, DIALOG_GANGARMSEDIT);
	return 1;
}

publish OnGangInformation(playerid)
{
	new rows = cache_get_row_count(connectionID);

	if(rows)
	{
		new count, total;


		GetGangTurfsCount(PlayerData[playerid][pGang], count, total);

		SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ %s ______", GangInfo[PlayerData[playerid][pGang]][gName]);
		SendClientMessageEx(playerid, COLOR_GREY2, "Leader: %s - Level: %i/3 - Strikes: %i/3 - Members: %i/%i - Vehicles: %i/%i", GangInfo[PlayerData[playerid][pGang]][gLeader], GangInfo[PlayerData[playerid][pGang]][gLevel], GangInfo[PlayerData[playerid][pGang]][gStrikes], cache_get_row_int(0, 0), GetGangMemberLimit(PlayerData[playerid][pGang]), GetGangVehicles(PlayerData[playerid][pGang]), GetGangVehicleLimit(PlayerData[playerid][pGang]));
		SendClientMessageEx(playerid, COLOR_GREY2, "Gang Points: %s GP - Turf Tokens: %s - Cash: $%s/$%s - Materials: %s/%s", FormatNumber(GangInfo[PlayerData[playerid][pGang]][gPoints]), FormatNumber(GangInfo[PlayerData[playerid][pGang]][gTurfTokens]), FormatNumber(GangInfo[PlayerData[playerid][pGang]][gCash]), FormatNumber(GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_CASH)),
			FormatNumber(GangInfo[PlayerData[playerid][pGang]][gMaterials]), FormatNumber(GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_MATERIALS)));
		SendClientMessageEx(playerid, COLOR_GREY2, "Turfs: %i/%i - Weed: %i/%ig - Crack: %i/%ig - Heroin: %i/%ig - Painkillers: %i/%i", count, total, GangInfo[PlayerData[playerid][pGang]][gWeed], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_WEED), GangInfo[PlayerData[playerid][pGang]][gCocaine], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_COCAINE), GangInfo[PlayerData[playerid][pGang]][gHeroin], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_HEROIN),
		GangInfo[PlayerData[playerid][pGang]][gPainkillers], GetGangStashCapacity(PlayerData[playerid][pGang], STASH_CAPACITY_PAINKILLERS));
	}
	return 1;
}