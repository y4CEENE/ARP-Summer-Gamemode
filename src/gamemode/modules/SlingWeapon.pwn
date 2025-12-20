//TODO: Add sling support

//  CMD:ame(playerid, params[])
//  {
//      new activewep = GetPVarInt(playerid, "activesling");
//  	new message[100], string[128];
//  	if(sscanf(params, "s[100]", message))
//  	{
//  		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ame [action]");
//  		SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Set the action to OFF to remove the label.");
//  		return 1;
//  	}
//  	if(activewep > 0)
//  	{
//  	    SendClientMessageEx(playerid, COLOR_GREY, "  You have a weapon slung around your back, you can't use /ame.");
//  	    return 1;
//  	}
//  	if(strcmp(message, "off", true) == 0)
//  	{
//  	    SendClientMessageEx(playerid, COLOR_GREY, "  You have removed the description label.");
//  
//  	    DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
//  	    PlayerData[playerid][aMeStatus] =0;
//  	    return 1;
//  	}
//  	if(strlen(message) > 100) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too long, please reduce the length.");
//  	if(strlen(message) < 3) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too short, please increase the length.");
//  	if(PlayerData[playerid][aMeStatus] == 0)
//  	{
//  	    PlayerData[playerid][aMeStatus] =1;
//  
//  		format(string, sizeof(string), "* %s %s", GetPlayerNameEx(playerid), message);
//  		PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
//  		SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);		
//  		return 1;
//  	}
//  	else
//  	{
//  		format(string, sizeof(string), "* %s %s", GetPlayerNameEx(playerid), message);
//  		UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
//  		SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//  		return 1;
//  	}
//  }

publish SlingTimerGiveWeapon(playerid)
{
	if(GetPVarInt(playerid, "GiveWeaponTimer") > 0)
	{
		SetPVarInt(playerid, "GiveWeaponTimer", GetPVarInt(playerid, "GiveWeaponTimer")-1);
		SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);
	}
	return 1;
}
CMD:sling(playerid, params[])
{
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}

	if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!"); return 1; }

	new string[128], weaponchoice[32];
	if(sscanf(params, "s[32]", weaponchoice))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /sling [weapon]");
		SendClientMessageEx(playerid, COLOR_WHITE, "Avaliable options: spas12, shotgun, mp5, ak47, m4, sniper, rifle");
		return 1;
	}

	if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
	{
		format(string, sizeof(string), "   You must wait %d seconds before slinging another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
		SendClientMessageEx(playerid,COLOR_GREY,string);
		return 1;
	}

	new activewep;
	activewep = GetPVarInt(playerid, "activesling");

	if(activewep > 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "  You already have a weapon slung around your back.");
	    return 1;
	}

	new weapon, ammo;
	if(strcmp(weaponchoice, "shotgun", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][3] == 25 && PlayerData[playerid][pAGuns][3] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your Shotgun around your back. (use /unsling to retrieve the gun)");
			weapon = PlayerData[playerid][pWeapons][3];
			ammo = PlayerData[playerid][pGunsAmmo][3];
			format(string,sizeof(string), "* %s slings their Shotgun around their back, securing it to their body.", GetRPName(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10);
			SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

			if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has a shotgun slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has a shotgun slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	else if(strcmp(weaponchoice, "spas12", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][3] == 27 && PlayerData[playerid][pAGuns][3] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your SPAS12 around your back. (use /unsling to retrieve the gun)");
			weapon = PlayerData[playerid][pWeapons][3];
			ammo = PlayerData[playerid][pGunsAmmo][3];
			format(string,sizeof(string), "* %s slings their Combat Shotgun around their back, securing it to their body.", GetPlayerNameEx(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10);
			SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

            if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has a combat shotgun slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has a combat shotgun slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	else if(strcmp(weaponchoice, "mp5", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][4] == 29 && PlayerData[playerid][pAGuns][4] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your MP5 around your back. (use /unsling to retrieve the gun)");
			weapon = PlayerData[playerid][pWeapons][4];
			ammo = PlayerData[playerid][pGunsAmmo][4];
			format(string,sizeof(string), "* %s slings their MP5 around their back, securing it to their body.", GetRPName(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); 
			SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

            if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has an MP5 slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has an MP5 slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	else if(strcmp(weaponchoice, "ak47", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][5] == 30 && PlayerData[playerid][pAGuns][5] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your AK-47 around your back.");
			weapon = PlayerData[playerid][pWeapons][5];
			ammo = PlayerData[playerid][pGunsAmmo][5];
			format(string,sizeof(string), "* %s slings their AK-47 around their back, securing it to their body.", GetRPName(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10);  SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

            if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has an AK-47 slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has an AK-47 slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	else if(strcmp(weaponchoice, "m4", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][5] == 31 && PlayerData[playerid][pAGuns][5] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your M4 around your back. (use /unsling to retrieve the gun)");
			weapon = PlayerData[playerid][pWeapons][5];
			ammo = PlayerData[playerid][pGunsAmmo][5];
			format(string,sizeof(string), "* %s slings their M4 around their back, securing it to their body.", GetRPName(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10);  SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

            if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has an M4 slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has an M4 slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	else if(strcmp(weaponchoice, "rifle", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][6] == 33 && PlayerData[playerid][pAGuns][6] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your rifle around your back. (use /unsling to retrieve the gun)");
			weapon = PlayerData[playerid][pWeapons][6];
			ammo = PlayerData[playerid][pGunsAmmo][6];
			format(string,sizeof(string), "* %s slings their rifle around their back, securing it to their body.", GetRPName(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10);  SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

            if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has a rifle slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has a rifle slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	else if(strcmp(weaponchoice, "sniper", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerData[playerid][pWeapons][6] == 34 && PlayerData[playerid][pAGuns][6] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your sniper rifle around your back. (use /unsling to retrieve the gun)");
			weapon = PlayerData[playerid][pWeapons][6];
			ammo = PlayerData[playerid][pGunsAmmo][6];
			format(string,sizeof(string), "* %s slings their sniper rifle around their back, securing it to their body.", GetPlayerNameEx(playerid));
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
			SetPVarInt(playerid, "GiveWeaponTimer", 10);  SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);

            if(PlayerData[playerid][aMeStatus] == 0)
			{
				format(string,sizeof(string),"Has a sniper slung around their back (( %s ))",GetRPName(playerid));
				PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
				PlayerData[playerid][aMeStatus] =1;
			}
			else
			{
			    format(string,sizeof(string),"Has a sniper slung around their back (( %s ))",GetRPName(playerid));
				UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
			}
		}
	}
	if(weapon == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have that weapon.");
	SetPVarInt(playerid, "activesling", weapon);
	SetPVarInt(playerid, "activeslingammo", ammo);
	RemovePlayerWeapon(playerid, weapon);
	return 1;
}

CMD:unsling(playerid, params[])
{
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
	}
	if(GetPVarInt(playerid, "GiveWeaponTimer") >= 1) {

		new
			szMessage[59];

		format(szMessage, sizeof(szMessage), "   You must wait %d seconds before getting another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
		return SendClientMessageEx(playerid, COLOR_GREY, szMessage);
	}
	if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!"); return 1; }

	new activewep, ammo;
	activewep = GetPVarInt(playerid, "activesling");
	ammo = GetPVarInt(playerid, "activeslingammo");

	new weaponchoice[128];
	if(sscanf(params, "s[128]", weaponchoice))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /unsling [emote]");
		return 1;
	}

	if(activewep > 0)
	{
		new
			szWeapon[16],
			szMessage[128];

		GetWeaponName(activewep, szWeapon, sizeof(szWeapon));
		GivePlayerWeaponEx(playerid, activewep, true);

		if(isnull(weaponchoice))
		{
			format(szMessage, sizeof(szMessage), "You have unslung the %s from your back.", szWeapon);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
			format(szMessage, sizeof(szMessage), "* %s unslings a %s from their back.", GetRPName(playerid), szWeapon);
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, szMessage);
			DeletePVar(playerid, "activesling");
			DeletePVar(playerid, "activeslingammo");
		}
		else
		{
			format(szMessage, sizeof(szMessage), "You have unslung the %s from your back.", szWeapon);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
			format(szMessage, sizeof(szMessage), "* %s %s", GetRPName(playerid), weaponchoice);
			SendProximityMessage(playerid, 30.0, COLOR_PURPLE, szMessage);
			DeletePVar(playerid, "activesling");
			DeletePVar(playerid, "activeslingammo");
		}

		DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
		PlayerData[playerid][aMeStatus] =0;
	}
	return 1;
}
//  CMD:ado(playerid, params[])
//  {
//  	new activewep = GetPVarInt(playerid, "activesling");
//  	new message[100], string[180];
//  	if(sscanf(params, "s[100]", message))
//  	{
//  		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ado [action]");
//  		SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Set the action to OFF to remove the label.");
//  		return 1;
//  	}
//  	if(activewep > 0)
//  	{
//  	    SendClientMessageEx(playerid, COLOR_GREY, "  You have a weapon slung around your back, you can't use /ado.");
//  		return 1;
//  	}
//  	if(strcmp(message, "off", true) == 0)
//  	{
//  	    SendClientMessageEx(playerid, COLOR_GREY, "  You have removed the description label.");
//  
//  	    DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
//  	    PlayerData[playerid][aMeStatus] =0;
//  	    return 1;
//  	}
//  	if(strlen(message) > 100) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too long, please reduce the length.");
//  	if(strlen(message) < 3) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too short, please increase the length.");
//  	if(PlayerData[playerid][aMeStatus] == 0)
//  	{
//          PlayerData[playerid][aMeStatus] =1;
//  
//  		format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
//  		SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//  
//  		PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.7, 20.0, playerid);
//  		return 1;
//  	}
//  	else
//  	{
//  		format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
//  		SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//  
//  		UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
//  		return 1;
//  	}
//  }
