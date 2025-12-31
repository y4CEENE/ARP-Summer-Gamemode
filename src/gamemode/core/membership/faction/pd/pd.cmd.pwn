#include <YSI\y_hooks>

#define DIALOG_CHARGES 1000

static ChargeReasons[][] = {
    "Failure to Comply",
    "Aiding and Abetting",
    "Assault",
    "Attempted Murder",
    "Murder",
    "Bribery",
    "Grand Theft Auto",
    "Discharge of a fireams in public",
    "Distribution of illegal narcotics",
    "Distribution of illegal fireams",
    "Driving without a license",
    "Evading Arrest",
    "Fcc Violation",
    "Misuse of 911 hotline",
    "Impersonating a LEO",
    "Kidnapping",
    "Possession of illegal fireams",
    "Possession of illegal narcotics",
    "Reckless Driving",
    "Robbery",
    "Speeding",
    "Transporting of illegal goods",
    "Trepassing",
    "Vehicular Assault",
    "Brandishing a fireams in public",
    "Illegal shortcut",
    "Manufacture of illegal fireams",
    "Manufacture of illegal narcotics",
    "Destruction of public property",
    "Public endangerment",
    "Obstruction of justice",
    "Unlawful street racing",
    "Drawing in public"   
};

GetChargeList()
{
    new list[4096];
    for(new i = 0; i < sizeof(ChargeReasons); i++)
    {
        strcat(list, ChargeReasons[i]);
        strcat(list, "\n");
    }
    return list;
}

CMD:arrest(playerid, params[])
{
	new targetid, minutes, fine;

	if(!IsLawEnforcement(playerid)  && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /arrest [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't arrest yourself.");
	}
	if(!PlayerData[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not handcuffed.");
	}
	if(!PlayerData[targetid][pWantedLevel])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't arrest a player with no active charges. /charge to add them.");
	}

	for(new i = 0; i < sizeof(arrestPoints); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2]))
	    {
	        minutes = PlayerData[targetid][pWantedLevel] * 5;
	        fine = PlayerData[targetid][pWantedLevel] * 1000;
            new notorityfine = 0;
            if(PlayerData[targetid][pNotoriety] > 20000)
            {
                notorityfine = percent(PlayerData[targetid][pCash] + PlayerData[targetid][pBank], 25);
            }
            else if(PlayerData[targetid][pNotoriety] > 14000)
            {
                notorityfine = percent(PlayerData[targetid][pCash] + PlayerData[targetid][pBank], 20);
            }
            else if(PlayerData[targetid][pNotoriety] > 8000)
            {
                notorityfine = percent(PlayerData[targetid][pCash] + PlayerData[targetid][pBank], 15);
            }
            else if(PlayerData[targetid][pNotoriety] > 4000)
            {
                notorityfine = percent(PlayerData[targetid][pCash] + PlayerData[targetid][pBank], 10);
            }
            if(notorityfine > 10000)
            {
                notorityfine = 10000;
            }
            if(notorityfine > 0)
            {
                SendClientMessageEx(targetid, COLOR_VIP, "You was fined $%d for having %d notoriety.", notorityfine, PlayerData[targetid][pNotoriety]);
                fine += notorityfine;
            }

	        if(PlayerData[targetid][pDonator] == 1)
			{
	            SendClientMessageEx(targetid, COLOR_VIP, "VIP Perk: Your %i minutes of jail time has been reduced by 50 percent to %i minutes.", minutes, percent(minutes, 50));
	            minutes = percent(minutes, 50);
	        }
	        else if(PlayerData[targetid][pDonator] >= 2)
			{
	            SendClientMessageEx(targetid, COLOR_VIP, "VIP Perk: Your %i minutes of jail time has been reduced by 75 percent to %i minutes.", minutes, percent(minutes, 75));
	            minutes = percent(minutes, 25);
	        }

		    PlayerData[targetid][pJailType] = 3;
    		PlayerData[targetid][pJailTime] = minutes * 60;
			PlayerData[targetid][pWantedLevel] = 0;
			PlayerData[targetid][pNotoriety] = 0;
            PlayerData[targetid][pArrested]++;

		    ResetPlayerWeaponsEx(targetid);
			ResetPlayer(targetid);
			TogglePlayerControllableEx(targetid, 1);

			SetPlayerInJail(targetid);
			GivePlayerCash(targetid, -fine);
            GivePlayerCash(playerid, 500);
            GivePlayerRankPoints(playerid, 500);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = 0, arrested = %i WHERE uid = %i", PlayerData[targetid][pArrested], PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `criminals` SET `served` = 1 WHERE `player` = '%e';", GetPlayerNameEx(targetid));
			mysql_tquery(connectionID, queryBuffer);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageToAllEx(COLOR_LIGHTRED, "<< %s %s has completed their arrest. %s has been sent to jail for %i days. >>", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), minutes);
			//SendFactionMessage(PlayerData[playerid][pFaction], COLOR_ROYALBLUE, "* HQ: %s %s has arrested %s for %i minutes, fine: $%i.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), minutes, fine);
    		SendClientMessageEx(targetid, COLOR_AQUA, "* You've been arrested for %i minutes, fine: $%i.", minutes, fine);
    		Log_Write("log_faction", "%s (uid: %i) has arrested %s (uid: %i) for %i minutes, fine: $%i.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], minutes, fine);
    		return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "You are not in range of any arrest points.");
    return 1;
}

CMD:taser(playerid, params[])
{
    return callcmd::tazer(playerid, params);
}

CMD:tazer(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0 || IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (PlayerData[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command when you are weapon restricted.");
    }
    if (!PlayerData[playerid][pDuty])
    {
        return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You must be on duty before using /tazer.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to pull out your tazer. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
    if (!PlayerData[playerid][pTazer])
    {
        PlayerData[playerid][pTazer] = 1;
        ShowActionBubble(playerid, "* %s reaches for their tazer.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_PURPLE, "* %s reaches for their tazer.", GetRPName(playerid));
        pTazerReplace{playerid} = PlayerData[playerid][pWeapons][2];
        GivePlayerWeaponEx(playerid, 23);
        SetPlayerArmedWeapon(playerid, 23);
    }
    else
    {
        PlayerData[playerid][pTazer] = 0;
        RemovePlayerWeapon(playerid, 23);
        SetPlayerWeapons(playerid);
        GivePlayerWeaponEx(playerid, pTazerReplace{playerid});
        ShowActionBubble(playerid, "* %s puts their tazer back in their duty belt.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_PURPLE, "* %s puts their tazer back in their duty belt.", GetRPName(playerid));
        if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
            SetPlayerArmedWeapon(playerid, PlayerData[playerid][pWeapons][2]);
        }
    }

    return 1;
}

CMD:mir(playerid, params[])
{
	if(IsLawEnforcement(playerid))
	{
	    SetTimerEx("showMirandaRights", 1000, false, "ii", playerid, 1);
	}
	return 1;
}

CMD:swat(playerid, params[])
{
	if(!PlayerData[playerid][pLogged])return true;

	new factionid = PlayerData[playerid][pFaction];

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(!IsPlayerInRangeOfLocker(playerid, factionid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any of your faction lockers.");
	}
	if(!PlayerData[playerid][pDuty])return SendClientMessage(playerid, COLOR_ADM, "ACCESS DENIED:{FFFFFF} You must be on duty before SWATing up.");

	if(PlayerData[playerid][pSWATduty] == true)
	{
	    PlayerData[playerid][pSWATduty] = false;
		SendFactionMessage(factionid, COLOR_FACTIONCHAT, "* HQ: %s %s is now off tactical duty! *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
		PlayerData[playerid][pSWATduty] = true;
		SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
        GivePlayerHealth(playerid, 100);
		SetScriptArmour(playerid, 40);
	}
	else
	{
		SetPlayerSkin(playerid, 285);
		SetScriptArmour(playerid, 200);
		GivePlayerHealth(playerid, 100);
		SendFactionMessage(factionid, COLOR_FACTIONCHAT, "* HQ: %s %s is now ready for tactical duty! *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
		PlayerData[playerid][pSWATduty] = true;
	}
	return true;
}
CMD:cuff(playerid, params[])
{
	new targetid;

    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /cuff [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't cuff yourself.");
	}
	if(PlayerData[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already handcuffed.");
	}
	if(PlayerData[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't handcuff an injured player.");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to cuff anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}

	new
		bool:canHandcuff;

    if(PlayerData[targetid][pTazedTime] > 0)
		canHandcuff = true;

	if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_HANDSUP)
		canHandcuff = true;

	if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DUCK)
		canHandcuff = true;

	if(GetPlayerAnimationIndex(targetid) == 1441)
        canHandcuff = true;

	if(GetPlayerAnimationIndex(targetid) == 1151)
		canHandcuff = true;

	if(GetPlayerAnimationIndex(targetid) == 1150)
		canHandcuff = true;

	if(GetPlayerAnimationIndex(targetid) == 960)
		canHandcuff = true;

	if(GetPlayerAnimationIndex(targetid) == 1701)
		canHandcuff = true;

	if(!canHandcuff)
		return SendClientMessage(playerid, COLOR_ADM, "That player needs to be crouched, have their hands up or be on the floor.");

	PlayerData[targetid][pCuffed] = 1;
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
	SetPlayerAttachedObject(targetid, 9, 19418,6,-0.031999,0.024000,-0.024000,-7.900000,-32.000011,-72.299987,1.115998,1.322000,1.406000);

	TogglePlayerControllableEx(targetid, 0);

	ShowActionBubble(playerid, "* %s tightens a pair of handcuffs around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(playerid, COLOR_PURPLE, "* %s tightens a pair of handcuffs around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
	GameTextForPlayer(targetid, "~r~Cuffed", 3000, 3);
	return 1;
}

CMD:uncuff(playerid, params[])
{
	new targetid;

    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST && PlayerData[playerid][pAdminDuty] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /uncuff [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid && PlayerData[playerid][pAdminDuty] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't uncuff yourself.");
	}
	if(!PlayerData[targetid][pCuffed])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not handcuffed.");
	}
	if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to uncuff anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}

	PlayerData[targetid][pCuffed] = 0;
 	PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;

	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
	TogglePlayerControllableEx(targetid, 1);
	RemovePlayerAttachedObject(targetid, 9);
	ShowActionBubble(playerid, "* %s loosens the pair of handcuffs from around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(playerid, COLOR_PURPLE, "* %s loosens the pair of handcuffs from around %s's wrists.", GetRPName(playerid), GetRPName(targetid));
    GameTextForPlayer(targetid, "~g~Uncuffed", 3000, 3);
	return 1;
}
CMD:detain(playerid, params[])
{
	new targetid, vehicleid = GetPlayerVehicleID(playerid);

	if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /detain [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 15.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't detain yourself.");
	}
	if(!PlayerData[targetid][pCuffed] && !PlayerData[targetid][pTied])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is not handcuffed or tied.");
	}
	if(IsPlayerInAnyVehicle(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is already in a vehicle.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}

	for(new i = (GetVehicleSeatCount(vehicleid) == 4) ? 2 : 1; i < GetVehicleSeatCount(vehicleid); i ++)
	{
	    if(!IsSeatOccupied(vehicleid, i))
	    {
			PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;
			PlayerData[targetid][pVehicleCount] = 0;

	        TogglePlayerControllableEx(targetid, 0);
	        PutPlayerInVehicle(targetid, vehicleid, i);

			SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
			ShowActionBubble(playerid, "* %s throws %s into their vehicle.", GetRPName(playerid), GetRPName(targetid));
			return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "There are no unoccupied back seats left. Find another vehicle.");
	return 1;
}

CMD:charge(playerid, params[])
{
	new targetid;

	if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement or goverment.");
	}
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /charge [playerid]");
    }
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can't charge yourself.");
	}
	if(PlayerData[targetid][pWantedLevel] >= 6)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player is already at the maximum wanted level (6).");
	}
	if(GetPlayerFaction(targetid) == FACTION_FEDERAL && GetPlayerFaction(playerid) == FACTION_POLICE && GetPlayerFaction(playerid) == FACTION_ARMY)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player is in a faction of higher authority and therefore can't be charged.");
	}

    ShowPlayerDialog(playerid, DIALOG_CHARGES, DIALOG_STYLE_LIST, "Select Charge Reason", GetChargeList(), "Charge", "Cancel");
    SetPVarInt(playerid, "targetid", targetid);

    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CHARGES)
    {
        if(response)
        {
            new reason[128];
            new targetid = GetPVarInt(playerid, "targetid");
            format(reason, sizeof(reason), "%s", ChargeReasons[listitem]);

		    PlayerData[targetid][pWantedLevel]++;
		    PlayerData[targetid][pCrimes]++;
		
			new query[256];
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = %i WHERE uid = %i", PlayerData[targetid][pWantedLevel], PlayerData[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		    format(query, sizeof(query), "INSERT INTO charges VALUES(null, %i, '%e', NOW(), '%e')", PlayerData[targetid][pID], GetPlayerNameEx(playerid), reason);
		    new year, month, day, hour, minute, second;
		    getdate(year, month, day);
		    gettime(hour,minute,second);
		    new datum[64], time[64];
		    format(time, sizeof(time), "%d:%d:%d", hour, minute, second);
		    format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
			format(query, sizeof(query), "INSERT INTO tickets(`player`, `officer`, `time`, `date`, `amount`, `reason`) VALUES ('%s','%s','%s','%s',%d,'%s')",		        GetPlayerNameEx(targetid), GetPlayerNameEx(playerid), datum, time, reason);
		
		    foreach(new i : Player)
		    {
		        if (IsLawEnforcement(i))
		        {
		            SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: %s %s has charged %s with {FF6347}%s{9999FF}. *", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), reason);
		        }
		    }

		    SendClientMessageEx(targetid, COLOR_LIGHTRED, "* Officer %s has charged you with %s.", GetRPName(playerid), reason);
		    Log_Write("log_faction", "%s (uid: %i) has charged %s (uid: %i) with %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], reason);
        }
    }
}
CMD:su(playerid, params[])
{
	return callcmd::charge(playerid, params);
}

CMD:wanted(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && !PlayerHasJob(playerid, JOB_LAWYER) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement or a lawyer.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Wanted Players _____");

    foreach(new i : Player)
    {
        if (PlayerData[i][pWantedLevel] > 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "(ID: %i) %s - Wanted Level: %i", i, GetRPName(i), PlayerData[i][pWantedLevel]);
        }
    }

    return 1;
}

CMD:find(playerid, params[])
{
	new targetid;

    if(!PlayerHasJob(playerid, JOB_DETECTIVE) && GetPlayerFaction(playerid) != FACTION_POLICE &&  GetPlayerFaction(playerid) != FACTION_FEDERAL && GetPlayerFaction(playerid) != FACTION_ARMY && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Detective.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /find [playerid]");
	}
	if(PlayerData[playerid][pDetectiveCooldown] > 0)
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait %i more seconds to use this command again.", PlayerData[playerid][pDetectiveCooldown]);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
	}
	if(GetPlayerInterior(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This player is in an interior. You can't find them at the moment.");
	}
	if(PlayerData[targetid][pAdminDuty])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on an on duty administrator.");
	}
	if(PlayerData[targetid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player's phone is turned off. Therefore you can't find them.");
	}

	switch(GetJobLevel(playerid, JOB_DETECTIVE))
	{
	    case 1:
	    {
	        PlayerData[playerid][pFindTime] = 6;
	        PlayerData[playerid][pDetectiveCooldown] = 120;
		}
		case 2:
	    {
	        PlayerData[playerid][pFindTime] = 8;
	        PlayerData[playerid][pDetectiveCooldown] = 90;
		}
		case 3:
	    {
	        PlayerData[playerid][pFindTime] = 10;
	        PlayerData[playerid][pDetectiveCooldown] = 60;
		}
		case 4:
	    {
	        PlayerData[playerid][pFindTime] = 12;
	        PlayerData[playerid][pDetectiveCooldown] = 30;
		}
		case 5:
	    {
	        PlayerData[playerid][pFindTime] = 14;
	        PlayerData[playerid][pDetectiveCooldown] = 15;
		}
	}

    SetPlayerMarkerForPlayer(playerid, targetid, 0xF70000FF);

    ShowActionBubble(playerid, "* %s takes out a cellphone and begins to track someone.", GetRPName(playerid));
	SendClientMessageEx(playerid, COLOR_WHITE, "* %s's location marked on your radar. %i seconds remain until the marker disappears.", GetRPName(targetid), PlayerData[playerid][pFindTime]);

	IncreaseJobSkill(playerid, JOB_DETECTIVE);
	PlayerData[playerid][pFindPlayer] = targetid;
	return 1;
}
CMD:take(playerid, params[])
{
	new targetid, option[14];

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "us[14]", targetid, option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /take [playerid] [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapons, Weed, Crack, Heroin, Painkillers, CarLicense");
		return 1;
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(!PlayerData[targetid][pCuffed])
	{
		return SendClientMessage(playerid, COLOR_GREY, "The player specified is not cuffed.");
	}

	if(!strcmp(option, "weapons", true))
	{
	    ResetPlayerWeaponsEx(targetid);
	    ShowActionBubble(playerid, "* %s takes away %s's weapons.", GetRPName(playerid), GetRPName(targetid));

	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your weapons.", GetRPName(playerid));
        Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) weapons.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
	}
	else if(!strcmp(option, "weed", true))
	{
	    if(!PlayerData[targetid][pWeed])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player has no weed on them.");
		}

	    ShowActionBubble(playerid, "* %s takes away %s's weed.", GetRPName(playerid), GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i grams of weed.", GetRPName(playerid), PlayerData[targetid][pWeed]);
	    Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of weed.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pWeed]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerData[targetid][pWeed] = 0;
	}
	else if(!strcmp(option, "crack", true))
	{
	    if(!PlayerData[targetid][pCocaine])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player has no crack on them.");
		}

	    ShowActionBubble(playerid, "* %s takes away %s's crack.", GetRPName(playerid), GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i grams of crack.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of crack.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pCocaine]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerData[targetid][pCocaine] = 0;
	}
	else if(!strcmp(option, "heroin", true))
	{
	    if(!PlayerData[targetid][pHeroin])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player has no Heroin on them.");
		}

	    ShowActionBubble(playerid, "* %s takes away %s's Heroin.", GetRPName(playerid), GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i grams of Heroin.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i grams of Heroin.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pHeroin]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET heroin = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerData[targetid][pHeroin] = 0;
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    if(!PlayerData[targetid][pPainkillers])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player has no painkillers on them.");
		}

	    ShowActionBubble(playerid, "* %s takes away %s's painkillers.", GetRPName(playerid), GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your %i painkillers.", GetRPName(playerid), PlayerData[targetid][pWeed]);
        Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) %i painkillers.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], PlayerData[targetid][pPainkillers]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET painkillers = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerData[targetid][pPainkillers] = 0;
	}
	else if(!strcmp(option, "carlicense", true))
	{
	    if(!PlayerData[targetid][pCarLicense])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "That player has no driving license on them.");
		}

	    ShowActionBubble(playerid, "* %s takes away %s's drivers license.", GetRPName(playerid), GetRPName(targetid));
	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has taken your drivers license.", GetRPName(playerid));
	    Log_Write("log_faction", "%s (uid: %i) has taken %s's (uid: %i) drivers license.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET carlicense = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	    mysql_tquery(connectionID, queryBuffer);

	    PlayerData[targetid][pCarLicense] = 0;
	}

	return 1;
}
CMD:ticket(playerid, params[])
{
	new targetid, amount, reason[128];

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "uis[128]", targetid, amount, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ticket [playerid] [amount] [reason]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't ticket yourself.");
	}
	if(!(1000 <= amount <= 10000))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The ticket amount must range between $1000 and $10000.");
	}

	PlayerData[targetid][pTicketOffer] = playerid;
	PlayerData[targetid][pTicketPrice] = amount;
	format(PlayerData[targetid][pTicketReason], 128, reason);
    GivePlayerRankPoints(playerid, 50);

	SendClientMessageEx(targetid, COLOR_AQUA, "* %s writes you a %s ticket for %s. (/accept ticket)", GetRPName(playerid), FormatCash(amount), reason);
	SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered a %s ticket to %s for %s.", FormatCash(amount), GetRPName(targetid), reason);
	return 1;
}


CMD:ram(playerid, params[])
{
	new id;

	if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}

    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	{
    	if(IsValidDynamicObject(i) && IsPlayerInRangeOfDynamicObject(playerid, i, 2.5) && IsDoorObject(i))
		{
		    /*if((id = GetInsideHouse(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[id][hID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_opened FROM rp_furniture WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		 		mysql_tquery(connectionID, queryBuffer, "OnPlayerRamFurnitureDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
		    	return 1;
			}
			else if((id = GetNearbyLand(playerid)) >= 0 && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == LandInfo[id][lID])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT door_opened FROM landobjects WHERE id = %i", Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
				mysql_tquery(connectionID, queryBuffer, "OnPlayerRamLandDoor", "iii", playerid, i, Streamer_GetExtraInt(i, E_OBJECT_INDEX_ID));
			    return 1;
			}*/
		}
	}

	if((id = GetNearbyHouse(playerid)) >= 0)
	{
	    if(!HouseInfo[id][hLocked])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This house is unlocked. You don't need to ram the door.");
		}

		HouseInfo[id][hLocked] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET locked = 0 WHERE id = %i", HouseInfo[id][hID]);
		mysql_tquery(connectionID, queryBuffer);

		ShowActionBubble(playerid, "* %s rams down %s's house door.", GetRPName(playerid), HouseInfo[id][hOwner]);
	}
	else if((id = GetNearbyBusiness(playerid)) >= 0)
	{
	    if(!BusinessInfo[id][bLocked])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This business is unlocked. You don't need to ram the door.");
		}

		BusinessInfo[id][bLocked] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET locked = 0 WHERE id = %i", BusinessInfo[id][bID]);
		mysql_tquery(connectionID, queryBuffer);

		ShowActionBubble(playerid, "* %s rams down %s's business door.", GetRPName(playerid), BusinessInfo[id][bOwner]);
	}
	else if((id = GetNearbyGarage(playerid)) >= 0)
	{
	    if(!GarageInfo[id][gLocked])
	    {
	        return SendClientMessage(playerid, COLOR_GREY, "This garage is unlocked. You don't need to ram the door.");
		}

		GarageInfo[id][gLocked] = 0;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE garages SET locked = 0 WHERE id = %i", GarageInfo[id][gID]);
		mysql_tquery(connectionID, queryBuffer);

		ShowActionBubble(playerid, "* %s rams down %s's garage door.", GetRPName(playerid), GarageInfo[id][gOwner]);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any door which can be rammed.");
	}

	return 1;
}

CMD:clearwanted(playerid, params[])
{
    new targetid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /clearwanted [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't clear yourself.");
	}
	if(!PlayerData[targetid][pWantedLevel])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player has no active charges to clear.");
	}

	PlayerData[targetid][pWantedLevel] = 0;
    GivePlayerRankPoints(playerid, -100);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM charges WHERE uid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = 0 WHERE uid = %i", PlayerData[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);
	ShowActionBubble(playerid, "* %s calls in dispatch and asks for a warrant removal of %s.", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_WHITE, "* Your crimes were cleared by %s.", GetRPName(playerid));
	SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has cleared %s's charges and wanted level.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:vticket(playerid, params[])
{
 	new amount, vehicleid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vticket [amount]");
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
	}
	if(!(100 <= amount <= 500))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The amount must range from $100 to $500.");
	}
	if(VehicleInfo[vehicleid][vTickets] >= 2000)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has over $2000 in tickets. You can't add anymore.");
	}

	VehicleInfo[vehicleid][vTickets] += amount;
    GivePlayerRankPoints(playerid, 50);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);
	SendClientMessageEx(playerid, COLOR_YELLOW3, "* %s writes up a %s ticket and attaches it to the %s.", GetRPName(playerid), FormatCash(amount), GetVehicleName(vehicleid));

	ShowActionBubble(playerid, "* %s writes up a %s ticket and attaches it to the %s.", GetRPName(playerid), FormatCash(amount), GetVehicleName(vehicleid));
	Log_Write("log_faction", "%s (uid: %i) placed a ticket for $%i on %s's (uid: %i) %s (id: %i).", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
	return 1;
}
CMD:vcheck(playerid, params[])
{
 	new vehicleid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
	}
	
	if(VehicleInfo[vehicleid][vTickets])
		return SendClientMessageEx(playerid,COLOR_GREY,"** COMPUTER ** The %s(%i) owned by %s have a ticket of value $%i", GetVehicleName(vehicleid),vehicleid, VehicleInfo[vehicleid][vOwner],VehicleInfo[vehicleid][vTickets]);
	else return SendClientMessageEx(playerid,COLOR_GREY,"** COMPUTER ** The %s(%i) owned by %s have no ticket of value", GetVehicleName(vehicleid),vehicleid, VehicleInfo[vehicleid][vOwner]);
}
CMD:siren(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:x, Float:y, Float:z, Float:tmp;

    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
	}
	if(!VehicleHasWindows(vehicleid))
	{
 		return SendClientMessage(playerid, COLOR_GREY, "This vehicle cannot have a siren attached to it.");
	}

	if(!IsValidDynamicObject(vehicleSiren[vehicleid]))
	{
	    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, z, z, z);
		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, tmp);

		vehicleSiren[vehicleid] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(vehicleSiren[vehicleid], vehicleid, -x, y, z / 1.9, 0.0, 0.0, 0.0);

	    ShowActionBubble(playerid, "* %s places a detachable siren on the roof of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}
	else
	{
	    DestroyDynamicObject(vehicleSiren[vehicleid]);
	    vehicleSiren[vehicleid] = INVALID_OBJECT_ID;
	    ShowActionBubble(playerid, "* %s detaches the siren from the roof of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	}

	return 1;
}

CMD:callsign(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
	}
	if(isnull(params) || strlen(params) > 12)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /callsign [text ('none' to reset)]");
	}

	if(IsValidDynamic3DTextLabel(vehicleCallsign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(vehicleCallsign[vehicleid]);
		vehicleCallsign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

		if(!strcmp(params, "none", true))
		{
			SendClientMessage(playerid, COLOR_WHITE, "* Callsign removed from the vehicle.");
		}
	}

	if(strcmp(params, "none", true) != 0)
	{
		vehicleCallsign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_GREY2, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
 		SendClientMessage(playerid, COLOR_WHITE, "* Callsign attached. '/callsign none' to detach the callsign.");
	}

	return 1;
}

CMD:vfrisk(playerid, params[])
{
    new vehicleid;

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
	}

    new count;

    for(new i = 0; i < 5; i ++)
    {
        if(VehicleInfo[vehicleid][vWeapons][i])
        {
            count++;
        }
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Trunk Balance ______");
    SendClientMessageEx(playerid, COLOR_GREY2, "Cash: $%i/$%i", VehicleInfo[vehicleid][vCash], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_CASH));
	SendClientMessageEx(playerid, COLOR_GREY2, "Materials: %i/%i | Weapons: %i/%i", VehicleInfo[vehicleid][vMaterials], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_MATERIALS), count, GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEAPONS));
    SendClientMessageEx(playerid, COLOR_GREY2, "Weed: %i/%i grams | Crack: %i/%i grams", VehicleInfo[vehicleid][vWeed], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_WEED), VehicleInfo[vehicleid][vCocaine], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_COCAINE));
    SendClientMessageEx(playerid, COLOR_GREY2, "Heroin: %i/%i grams | Painkillers: %i/%i pills", VehicleInfo[vehicleid][vHeroin], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_HEROIN), VehicleInfo[vehicleid][vPainkillers], GetVehicleStashCapacity(vehicleid, STASH_CAPACITY_PAINKILLERS));

	if(count > 0)
	{
		SendClientMessage(playerid, COLOR_NAVYBLUE, "______ Trunk Weapons ______");

    	for(new i = 0; i < 5; i ++)
        {
            if(VehicleInfo[vehicleid][vWeapons][i])
	        {
    	        SendClientMessageEx(playerid, COLOR_GREY2, "[%i] Weapon: %s", i + 1, GetWeaponNameEx(VehicleInfo[vehicleid][vWeapons][i]));
			}
		}
    }

	ShowActionBubble(playerid, "* %s prys open the trunk of the %s and takes a look inside.", GetRPName(playerid), GetVehicleName(vehicleid));
	return 1;
}

CMD:vtake(playerid, params[])
{
    new vehicleid, option[14];

    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}
	if(sscanf(params, "s[14]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vtake [option]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapons, Weed, Crack, Heroin, Painkillers");
	    return 1;
	}
	if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle isn't owned by any particular person.");
	}

	if(!strcmp(option, "weapons", true))
	{
        VehicleInfo[vehicleid][vWeapons][0] = 0;
        VehicleInfo[vehicleid][vWeapons][1] = 0;
        VehicleInfo[vehicleid][vWeapons][2] = 0;
        VehicleInfo[vehicleid][vWeapons][3] = 0;
        VehicleInfo[vehicleid][vWeapons][4] = 0;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weapon_1 = 0, weapon_2 = 0, weapon_3 = 0, weapon_4 = 0, weapon_5 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        ShowActionBubble(playerid, "* %s takes the weapons from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessage(playerid, COLOR_AQUA, "You have taken the weapons from the trunk.");
		Log_Write("log_faction", "%s (uid: %i) has taken the weapons from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
	}
	else if(!strcmp(option, "weed", true))
	{
	    ShowActionBubble(playerid, "* %s takes the weed from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i grams of weed from the trunk.", VehicleInfo[vehicleid][vWeed]);
		Log_Write("log_faction", "%s (uid: %i) has taken the %i grams of weed from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vWeed], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET weed = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vWeed] = 0;
	}
	else if(!strcmp(option, "crack", true))
	{
	    ShowActionBubble(playerid, "* %s takes the crack from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i grams of crack from the trunk.", VehicleInfo[vehicleid][vCocaine]);
		Log_Write("log_faction", "%s (uid: %i) has taken the %i grams of crack from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vCocaine], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET cocaine = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vCocaine] = 0;
	}
	else if(!strcmp(option, "heroin", true))
	{
	    ShowActionBubble(playerid, "* %s takes the Heroin from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i grams of Heroin from the trunk.", VehicleInfo[vehicleid][vHeroin]);
		Log_Write("log_faction", "%s (uid: %i) has taken the %i grams of Heroin from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vHeroin], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET heroin = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vHeroin] = 0;
	}
	else if(!strcmp(option, "painkillers", true))
	{
	    ShowActionBubble(playerid, "* %s takes the painkillers from the trunk of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the %i painkillers from the trunk.", VehicleInfo[vehicleid][vPainkillers]);
		Log_Write("log_faction", "%s (uid: %i) has taken the %i painkillers from %s's (uid: %i) %s trunk (id: %i).", GetRPName(playerid), PlayerData[playerid][pID], VehicleInfo[vehicleid][vPainkillers], VehicleInfo[vehicleid][vOwner], VehicleInfo[vehicleid][vOwnerID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET painkillers = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
        mysql_tquery(connectionID, queryBuffer);

        VehicleInfo[vehicleid][vPainkillers] = 0;
	}
    else
    {
        return 1;
    }
    GivePlayerRankPoints(playerid, 50);
	return 1;
}

CMD:fingerprint(playerid, params[]) 
{
    new
        iTarget,
        szSex[7];

    if(!IsACop(playerid))
    {
        return SendClientErrorNoPermission(playerid);
    }
    
    if(sscanf(params, "u", iTarget))
    {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /fingerprint [playerid/partofname]");
    }

    if(!IsPlayerConnected(iTarget))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected.");
    }

    if(GetDistanceBetweenPlayers(iTarget, playerid) > 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
    }

    if(PlayerData[iTarget][pCrimes] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "IAFIS has found no matches for the scanned fingerprint.");
    }

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------");

    if(PlayerData[iTarget][pGender] == 0)
        szSex = "Male";
    else
        szSex = "Female";

    SendClientMessageEx(playerid, COLOR_WHITE, "Name: %s (age: %d, gender: %s)", GetPlayerNameEx(iTarget), PlayerData[iTarget][pAge], szSex);

    // if(PlayerData[iTarget][pHouse] != INVALID_HOUSE_ID) 
    // {
    //     new
    //         szZone[MAX_ZONE_NAME];
    // 
    //     Get2DPosZone(HouseInfo[PlayerData[iTarget][pHouse]][hExteriorX], HouseInfo[PlayerData[iTarget][pHouse]][hExteriorY], szZone, MAX_ZONE_NAME);
    //     SendClientMessageEx(playerid, COLOR_WHITE, "House: %d %s", PlayerData[iTarget][pHouse], szZone);
    // }
    // else if(PlayerData[iTarget][pHouse2] != INVALID_HOUSE_ID) 
    // {
    //     new
    //         szZone[MAX_ZONE_NAME];
    // 
    //     Get2DPosZone(HouseInfo[PlayerData[iTarget][pHouse2]][hExteriorX], HouseInfo[PlayerData[iTarget][pHouse2]][hExteriorY], szZone, MAX_ZONE_NAME);
    //     SendClientMessageEx(playerid, COLOR_WHITE, "House (2): %d %s", PlayerData[iTarget][pHouse2], szZone);
    // }

    SendClientMessageEx(playerid, COLOR_WHITE, "Job 1: %s, Job 2: %s", GetJobName(PlayerData[iTarget][pJob]), GetJobName(PlayerData[iTarget][pSecondJob]));
    SendClientMessageEx(playerid, COLOR_WHITE, "Prior convictions: %d", PlayerData[iTarget][pCrimes]);
    SendClientMessageEx(playerid, COLOR_WHITE, "Prior arrests: %d", PlayerData[iTarget][pArrested]);

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------");
    
    return 1;
}
