#include <YSI\y_hooks>


ResetBackpack(playerid)
{
	if(PlayerData[playerid][pLogged] && !PlayerData[playerid][pAdminDuty])
	{
		PlayerData[playerid][pBackpack] = 0;
		PlayerData[playerid][bpCash] = 0;
		PlayerData[playerid][bpMaterials] = 0;
		PlayerData[playerid][bpWeed] = 0;
		PlayerData[playerid][bpCocaine] = 0;
		PlayerData[playerid][bpHeroin] = 0;
		PlayerData[playerid][bpPainkillers] = 0;
		PlayerData[playerid][bpWeapons][0] = 0;
		PlayerData[playerid][bpWeapons][1] = 0;
		PlayerData[playerid][bpWeapons][2] = 0;
		PlayerData[playerid][bpWeapons][3] = 0;
		PlayerData[playerid][bpWeapons][4] = 0;
		PlayerData[playerid][bpWeapons][5] = 0;
		PlayerData[playerid][bpWeapons][6] = 0;
		PlayerData[playerid][bpWeapons][7] = 0;
		PlayerData[playerid][bpWeapons][8] = 0;
		PlayerData[playerid][bpWeapons][9] = 0;
		PlayerData[playerid][bpWeapons][10] = 0;
		PlayerData[playerid][bpWeapons][11] = 0;
		PlayerData[playerid][bpWeapons][13] = 0;
		PlayerData[playerid][bpWeapons][14] = 0;
	}
	SavePlayerVariables(playerid);
}

GetBackpackCapacity(playerid, item)
{
	static const stashCapacities[][] = {
		// Cash   Mats    W     C    M    P   HP   PT   FMJ  WEP
	    {30000,   5000,   25,   25,  10,  5,  80,  60,  50,  4}, // Small
	    {55000,   10000,  50,   50,  25,  10, 100, 80,  60,  8}, // Medium
	    {120000,  25000,  100,  75,  50,  20, 125, 100, 70,  12} // Large
	};

	if(PlayerData[playerid][pBackpack] > 0)
	{
		return stashCapacities[PlayerData[playerid][pBackpack] - 1][item];
	}

	return 0;
}

CMD:givebackpack(playerid, params[])
{
	new targetid, size[10];
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "us[14]S()[32]", targetid, size))
	{
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /givebackpack [playerid] [size]");
	    SendClientMessageEx(playerid, COLOR_WHITE, "Sizes:   Small, Medium, Large");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessageEx(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!strcmp(size, "small", true))
	{
		PlayerData[targetid][pBackpack] = 1;
	    SendClientMessageEx(targetid, COLOR_WHITE, "** %s has given you a small backpack.", GetRPName(playerid));
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a small backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	if(!strcmp(size, "medium", true))
	{
		PlayerData[targetid][pBackpack] = 2;
	    SendClientMessageEx(targetid, COLOR_WHITE, "** %s has given you a medium backpack.", GetRPName(playerid));
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a medium backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	if(!strcmp(size, "large", true))
	{
		PlayerData[targetid][pBackpack] = 3;
	    SendClientMessageEx(targetid, COLOR_WHITE, "** %s has given you a large backpack.", GetRPName(playerid));
	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a large backpack.", GetRPName(playerid), GetRPName(targetid));
	}
	return 1;
}

GetHealth(playerid)
{
	new Float:health;
	GetPlayerHealth(playerid, health);
	return floatround(health);
}

GiveWeapon(playerid, weaponid, bool:temp = false)
{
    if(PlayerData[playerid][pWeaponRestricted]) return 1;
	if(1 <= weaponid <= 46)
	{
	    if(temp)
		{
			PlayerData[playerid][pTempWeapons][GetWeaponSlot(weaponid)] = weaponid;
			GivePlayerWeapon(playerid, weaponid, 500);
	    }
		else
		{
			PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] = weaponid;
			SetPlayerWeapons(playerid);
		}

		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    SetPlayerArmedWeapon(playerid, 0);
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			switch(weaponid)
			{
		    	case 22, 25, 28, 29, 30, 31, 32:
		    	{
		    	    SetPlayerArmedWeapon(playerid, weaponid);
			    }
			    default:
			    {
		    	    SetPlayerArmedWeapon(playerid, 0);
				}
			}
		}
		else
		{
		    SetPlayerArmedWeapon(playerid, weaponid);
		}

		SavePlayerWeapons(playerid);

		PlayerData[playerid][pACTime] = gettime() + 2;
	}
	return 1;
}

CMD:bp(playerid, params[]) { return callcmd::backpack(playerid, params); }
CMD:backpack(playerid, params[])
{
    if(PlayerData[playerid][pBackpack] != 0)
    {
		new option[14], param[32];
	 	if(sscanf(params, "s[14]S()[32]", option, param))
		{
	 		return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [wear | balance | deposit | withdraw]");
	 	}
		if(!strcmp(option, "wear", true))
		{
		    if(PlayerData[playerid][pPaintball] || IsPlayerInEvent(playerid))
			    {
		        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
			}
		    if(!PlayerData[playerid][bpWearing])
		    {
		        if(PlayerData[playerid][pBackpack] == 1)
		    	{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s wears his small backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				else if(PlayerData[playerid][pBackpack] == 2)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s wears his medium backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				else if(PlayerData[playerid][pBackpack] == 3)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s wears his large backpack on his back.", GetRPName(playerid));
					SetPlayerAttachedObject(playerid, 1, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
				}
    			PlayerData[playerid][bpWearing] = 1;
			}
			else
			{
		        if(PlayerData[playerid][pBackpack] == 1)
		    	{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s takes off his small backpack from his back.", GetRPName(playerid));
					PlayerData[playerid][bpWearing] = 0;
				}
				else if(PlayerData[playerid][pBackpack] == 2)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s takes off his medium backpack from his back.", GetRPName(playerid));
					PlayerData[playerid][bpWearing] = 0;
				}
				else if(PlayerData[playerid][pBackpack] == 3)
		  		{
					SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s takes off his large backpack from his back.", GetRPName(playerid));
					PlayerData[playerid][bpWearing] = 0;
				}
				RemovePlayerAttachedObject(playerid, 1);
				return 1;
			}
		}
		if(PlayerData[playerid][bpWearing])
		{
			if(!strcmp(option, "balance", true))
		 	{
    			new count;

				for(new i = 0; i < 15; i ++)
    			{
		        	if(PlayerData[playerid][bpWeapons][i])
          			{
            			count++;
          			}
       			}
				SendClientMessageEx(playerid, COLOR_GREY, "Backpack Balance:");
    			SendClientMessageEx(playerid, COLOR_GREY2, "(Cash: $%i/$%i)", PlayerData[playerid][bpCash], GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
				SendClientMessageEx(playerid, COLOR_GREY2, "(Materials: %i/%i) | (Weapons: %i/%i)", PlayerData[playerid][bpMaterials], GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS), count, GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS));
		        SendClientMessageEx(playerid, COLOR_GREY2, "(Weed: %i/%i grams) | (Cocaine: %i/%i grams)", PlayerData[playerid][bpWeed], GetBackpackCapacity(playerid, STASH_CAPACITY_WEED), PlayerData[playerid][bpCocaine], GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
		        SendClientMessageEx(playerid, COLOR_GREY2, "(Heroin: %i/%i grams) | (Painkillers: %i/%i pills)", PlayerData[playerid][bpHeroin], GetBackpackCapacity(playerid, STASH_CAPACITY_HEROIN), PlayerData[playerid][bpPainkillers], GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS));
				return 1;
			}
			else if(!strcmp(option, "deposit", true))
		 	{
				new value;

				if(sscanf(param, "s[14]S()[32]", option, param))
		  		{
		    		SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [option]");
		      		SendClientMessageEx(playerid, COLOR_WHITE, "Available options: Cash, Materials, Weed, Cocaine, Heroin, Painkillers, Weapon");
			        return 1;
		    	}
			    if(!strcmp(option, "cash", true))
				{
		  			if(sscanf(param, "i", value))
					{
						return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [cash] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pCash])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpCash] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_CASH))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Your backpack can only hold up to $%i at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
				    }

				    GivePlayerCash(playerid, -value);
				    PlayerData[playerid][bpCash] += value;

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored $%i in your backpack.", value);
				}
				else if(!strcmp(option, "materials", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [materials] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pMaterials])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpMaterials] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i materials at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS));
				    }

				    PlayerData[playerid][pMaterials] -= value;
				    PlayerData[playerid][bpMaterials] += value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);


				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored %i materials in your backpack.", value);
	   			}
				else if(!strcmp(option, "weed", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [weed] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pWeed])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpWeed] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_WEED))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of weed at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_WEED));
				    }

				    PlayerData[playerid][pWeed] -= value;
				    PlayerData[playerid][bpWeed] += value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored %ig of weed in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "cocaine", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [cocaine] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pCocaine])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpCocaine] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of cocaine at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
				    }

				    PlayerData[playerid][pCocaine] -= value;
				    PlayerData[playerid][bpCocaine] += value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored %ig of cocaine in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "heroin", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [heroin] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pHeroin])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpHeroin] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_HEROIN))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i grams of heroin at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_HEROIN));
				    }

				    PlayerData[playerid][pHeroin] -= value;
				    PlayerData[playerid][bpHeroin] += value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i",
                    PlayerData[playerid][pHeroin],
                    PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored %ig of heroin in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "painkillers", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [painkillers] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][pPainkillers])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpPainkillers] + value > GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Your backpack can only hold up to %i painkillers at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_PAINKILLERS));
				    }

				    PlayerData[playerid][pPainkillers] -= value;
				    PlayerData[playerid][bpPainkillers] += value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored %i painkillers in your backpack.", value);
	   			}
	   			else if(!strcmp(option, "weapon", true))
	   			{
	   			    new weaponid;

	   			    if(sscanf(param, "i", weaponid))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [deposit] [weapon] [weaponid] (/guninv for weapon IDs)");
					}
					if(!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
					}
					if(GetHealth(playerid) < 60)
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "You can't store weapons as your health is below 60.");
					}
					for(new i = 0; i < GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS); i ++)
					{
						if(!PlayerData[playerid][bpWeapons][i])
	   				    {
							PlayerData[playerid][bpWeapons][i] = weaponid;

							RemovePlayerWeapon(playerid, weaponid);
							SendClientMessageEx(playerid, COLOR_AQUA, "** You have stored a %s in slot %i of your backpack.", GetWeaponNameEx(PlayerData[playerid][bpWeapons][i]), i + 1);
							return 1;
						}
					}

					SendClientMessageEx(playerid, COLOR_SYNTAX, "This backpack has no more slots available for weapons.");
				}
			}
	        else if(!strcmp(option, "withdraw", true))
		    {
		        new value;

		        if(sscanf(param, "s[14]S()[32]", option, param))
		        {
		            SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [option]");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Available options: Cash, Weed, Cocaine, Heroin, Painkillers, Weapon");
		            return 1;
		        }
		        if(!strcmp(option, "cash", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [cash] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpCash])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }

				    GivePlayerCash(playerid, value);
				    PlayerData[playerid][bpCash] -= value;

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken $%i from your backpack.", value);
				}
				else if(!strcmp(option, "materials", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [materials] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpMaterials])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if (PlayerData[playerid][pMaterials] + value > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
                    {
                        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
                    }

				    PlayerData[playerid][pMaterials] += value;
				    PlayerData[playerid][bpMaterials] -= value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken %i materials from your backpack.", value);
	   			}
				else if(!strcmp(option, "weed", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [weed] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpWeed])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][pWeed] + value > GetPlayerCapacity(playerid, CAPACITY_WEED))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
					}

				    PlayerData[playerid][pWeed] += value;
				    PlayerData[playerid][bpWeed] -= value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken %ig of weed from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "cocaine", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [cocaine] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpCocaine])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][pCocaine] + value > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
					}

				    PlayerData[playerid][pCocaine] += value;
				    PlayerData[playerid][bpCocaine] -= value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken %ig of cocaine from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "heroin", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [heroin] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpHeroin])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][bpHeroin] + value > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
					}

				    PlayerData[playerid][pHeroin] += value;
				    PlayerData[playerid][bpHeroin] -= value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken %ig of heroin from your backpack.", value);
	   			}
	   			else if(!strcmp(option, "painkillers", true))
				{
				    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [painkillers] [amount]");
					}
					if(value < 1 || value > PlayerData[playerid][bpPainkillers])
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Insufficient amount.");
				    }
				    if(PlayerData[playerid][pPainkillers] + value > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
					}

				    PlayerData[playerid][pPainkillers] += value;
				    PlayerData[playerid][bpPainkillers] -= value;

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);

				    SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken %i painkillers from your backpack stash.", value);
	   			}
	   			else if(!strcmp(option, "weapon", true))
	   			{
	   			    new slots = GetBackpackCapacity(playerid, STASH_CAPACITY_WEAPONS);

	   			    if(sscanf(param, "i", value))
				    {
				        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /backpack [withdraw] [weapon] [slot (1-%i)]", slots);
					}
					if(!(1 <= value <= slots))
					{
					    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid slot, or the slot specified is locked.");
	   			    }
	   			    if(!PlayerData[playerid][bpWeapons][value-1])
	   			    {
	   			        return SendClientMessageEx(playerid, COLOR_SYNTAX, "The slot specified contains no weapon which you can take.");
					}

					GiveWeapon(playerid, PlayerData[playerid][bpWeapons][value-1]);
					SendClientMessageEx(playerid, COLOR_AQUA, "** You have taken a %s from slot %i of your backpack.", GetWeaponNameEx(PlayerData[playerid][bpWeapons][value-1]), value);

					PlayerData[playerid][bpWeapons][value-1] = 0;
				}
			}
		}
		else
		{
	 		return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must be wearing your backpack to use these commands.");
	 	}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not in possession of a backpack.");
	}
	return 1;
}