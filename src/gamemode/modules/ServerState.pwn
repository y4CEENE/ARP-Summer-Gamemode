#include <YSI\y_hooks>

#define TABLE_SERVER_STATE     "server_state"

static gCharity = 0;
static gWeather = 1;
static MaxTurfCap = 1;
static gGangInviteCooldown=0;
static gTax = 15, gTaxVault = 0, gNewsVault = 0;
static gDoubleXP = 0, gVPNState = 1, gHourReward = 0;
static gServerMOTD[128], gAdminMOTD[128], gHelperMOTD[128];
static gStateIsUpToDate=true;

SetAntiCheatState(s)
{
    gAnticheat = (s!=0);
    gStateIsUpToDate = false;
}

SetMaxTurfCap(value)
{
    MaxTurfCap = value;
    gStateIsUpToDate = false;
}
GetMaxTurfCap()
{
    return MaxTurfCap;
}
SetServerMOTD(motd[])
{
    strcpy(gServerMOTD, motd, sizeof(gServerMOTD));
    gStateIsUpToDate = false;
}

SetAdminMOTD(motd[])
{
    strcpy(gAdminMOTD, motd, sizeof(gAdminMOTD));
    gStateIsUpToDate = false;
}

SetHelperMOTD(motd[])
{
    strcpy(gHelperMOTD, motd, sizeof(gHelperMOTD));
    gStateIsUpToDate = false;
}

GetServerMOTD()
{
    return gServerMOTD;
}

GetAdminMOTD()
{
    return gAdminMOTD;
}

GetHelperMOTD()
{
    return gHelperMOTD;
}

SetDoubleXPState(s)
{
    gDoubleXP = (s!=0);
    gStateIsUpToDate = false;
    if(gDoubleXP)
    {
        new hostname[256];
        format(hostname, sizeof(hostname), "%s | Double XP!", GetHostName());
        SetServerHostName(hostname);
    }
    else
    {
        SetServerHostName(GetHostName());
    }
}

IsDoubleXPEnabled()
{
    return gDoubleXP;
}

SetHourRewardState(s)
{
    gHourReward = (s!=0);
    gStateIsUpToDate = false;
}

IsHourRewardEnabled()
{
    return gHourReward;
}

SetVPNState(s)
{
    gVPNState = s;
    gStateIsUpToDate = false;
}

IsVPNCheckEnabled()
{
    return (gVPNState != 0);
}

AddToNewsVault(amount)
{
    gNewsVault += amount;
    gStateIsUpToDate = false;
}

GetNewsVault()
{
    return gNewsVault;
}

AddToTaxVault(amount)
{
    gTaxVault += amount;
    gStateIsUpToDate = false;
}

GetTaxVault()
{
    return gTaxVault;
}

SetTaxPercent(value)
{
    if(0 < value <= 75)
    {
        gTax = value;
        gStateIsUpToDate = false;
    }
}

GetTaxPercent()
{
    return gTax;
}

SetGangInviteCooldown(value)
{
    gGangInviteCooldown=value;
    gStateIsUpToDate = false;
}

GetGangInviteCooldown()
{
    return gGangInviteCooldown;
}

SetDBWeatherID(value)
{
    gWeather = value;
    gStateIsUpToDate = false;
}

GetDBWeatherID()
{
    return gWeather;
}

AddToCharity(value)
{
    if(value > 0)
    {
        gCharity = value;
        gStateIsUpToDate = false;
    }
}

GetCharity()
{
    return gCharity;
}

hook OnLoadGameMode()
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "select * from "#TABLE_SERVER_STATE);
    mysql_tquery(connectionID, queryBuffer, "OnLoadServerState");
    return 1;
}
publish OnLoadServerState()
{
    gCharity             = cache_get_field_content_int(0, "charity");
    gWeather             = cache_get_field_content_int(0, "weather");
    gAnticheat           = cache_get_field_content_int(0, "anticheat");
    MaxTurfCap           = cache_get_field_content_int(0, "max_turf_cap");
    gGangInviteCooldown  = cache_get_field_content_int(0, "gang_invite_cooldown");
    gTax                 = cache_get_field_content_int(0, "tax");
    gTaxVault            = cache_get_field_content_int(0, "taxvault");
    gNewsVault           = cache_get_field_content_int(0, "newsvault");
    gDoubleXP            = cache_get_field_content_int(0, "doublexp");
    gVPNState            = cache_get_field_content_int(0, "vpn_state");
    gHourReward          = cache_get_field_content_int(0, "hour_reward");

    cache_get_field_content(0, "server_motd", gServerMOTD);
    cache_get_field_content(0, "admin_motd", gAdminMOTD);
    cache_get_field_content(0, "helper_motd", gHelperMOTD);
    nextWeather=GetDBWeatherID();
	autoWeather();

    SetDoubleXPState(gDoubleXP); // Force update hostname
}

hook OnServerBeacon(timestamp)
{
    if(!gStateIsUpToDate)
    {
        gStateIsUpToDate = true;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_SERVER_STATE" SET \
        charity=%i, weather=%i, anticheat=%i, max_turf_cap=%i, gang_invite_cooldown=%i, tax=%i, taxvault=%i, \
        newsvault=%i, doublexp=%i, vpn_state=%i, hour_reward=%i, server_motd='%e', admin_motd='%e', helper_motd='%e'", 
        gCharity, gWeather, gAnticheat, MaxTurfCap, gGangInviteCooldown, gTax, gTaxVault, 
        gNewsVault, gDoubleXP, gVPNState, gHourReward, gServerMOTD, gAdminMOTD, gHelperMOTD);
        mysql_tquery(connectionID, queryBuffer);
    }
    return 1;
}

CMD:doublexp(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= MANAGEMENT)
	{
        SendClientMessage(playerid, COLOR_GREY, "Check the new command /rewards");
	}
	return 1;
}

CMD:enddoublexp(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= MANAGEMENT)
	{
	    SendClientMessage(playerid, COLOR_GREY, "Check the new command /rewards");
	}
	return 1;
}

CMD:rewards(playerid, params[])
{
	if(!IsAdmin(playerid, 10))
	{
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    new option[14], s = -1;
	if(sscanf(params, "s[14]i()", option, s))
    {
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rewards [doublexp/hour_reward] [1/0]");
	    return SendClientMessageEx(playerid, COLOR_WHITE, "Current double XP state: %i, Current hour reward state: %i, ", IsDoubleXPEnabled(), IsHourRewardEnabled());
    }
	
    if(!strcmp(option, "doublexp", true))
	{
        if(s == -1)
        {
        }
        else 
        {
            SetDoubleXPState(s != 0);
            if(IsDoubleXPEnabled())
            {
                SendClientMessageToAllEx(COLOR_AQUA, "* %s enabled happy hours. You will now get double xp for playing in the server.", GetRPName(playerid));
            }
            else
            {
	            SendAdminWarning(2, "%s has disabled double XP.", GetPlayerNameEx(playerid));
            }
        }
    }    
    else if(!strcmp(option, "hour_reward", true))
	{
        if(s == -1)
        {
	        SendClientMessageEx(playerid, COLOR_WHITE, "Current hour reward state: %i", IsHourRewardEnabled());
        }
        else 
        {
            SetHourRewardState(s != 0);
            if(IsHourRewardEnabled())
            {
                SendClientMessageToAllEx(COLOR_AQUA, "* %s enabled happy hours. You will now get random gifts at signcheck.", GetRPName(playerid));
            }
            else
            {
	            SendAdminWarning(2, "%s has disabled hour reward.", GetPlayerNameEx(playerid));
            }
        }
    }
    else
    {
	    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rewards [doublexp/hour_reward] [1/0]");
    }
    return 1;
}


CMD:anticheat(playerid, params[])
{
	new s;

	if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "i", s) || !(0 <= s <= 1))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /anticheat [0/1]");
	}

	if(s) 
    {
		SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: You has enabled the server anticheat.");
	}
    else
    {
		SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: You has disabled the server anticheat.");
	}

	SetAntiCheatState(s);
	return 1;
}

