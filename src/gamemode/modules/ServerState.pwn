/// @file      ServerState.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-09-10 10:59:45 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define TABLE_SERVER_STATE     "server_state"

static gCharity = 0;
static gWeather = 1;
static gAnticheat = 1;
static MaxTurfCap = 1;
static gGangInviteCooldown=0;
static gTax = 15, gTaxVault = 0, gNewsVault = 0;
static gDoubleXP = 0, gVPNState = 1, gHourReward = 0;
static gServerMOTD[128], gAdminMOTD[128], gHelperMOTD[128];
static gStateIsUpToDate=true;
static gLottoJackpot = 0;
static gLottoTicketsSold = 0;

SetAntiCheatState(s)
{
    gAnticheat = (s!=0);
    gStateIsUpToDate = false;
}

IsAntiCheatEnabled()
{
    return gAnticheat;
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
    if (gDoubleXP)
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

stock SetTaxPercent(value)
{
    if (0 < value <= 75)
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
    if (value > 0)
    {
        gCharity = value;
        gStateIsUpToDate = false;
    }
}

GetCharity()
{
    return gCharity;
}

SetLottoJackpot(cash)
{
    if (cash != gLottoJackpot)
    {
        gLottoJackpot = cash;
        gStateIsUpToDate = false;
    }
}

GetLottoTicketsSold()
{
    return gLottoTicketsSold;
}

SetLottoTicketsSold(value)
{
    if (value != gLottoTicketsSold)
    {
        gLottoTicketsSold = value;
        gStateIsUpToDate = false;
    }
}

AddToLottoJackpot(cash)
{
    if (cash != 0)
    {
        gLottoJackpot += cash;
        gStateIsUpToDate = false;
    }
}

GetLottoJackpot()
{
    return gLottoJackpot;
}

hook OnLoadGameMode()
{
    DBQueryWithCallback("select * from "#TABLE_SERVER_STATE, "OnLoadServerState");
    return 1;
}

DB:OnLoadServerState()
{
    gCharity             = GetDBIntField(0, "charity");
    gWeather             = GetDBIntField(0, "weather");
    gAnticheat           = GetDBIntField(0, "anticheat");
    MaxTurfCap           = GetDBIntField(0, "max_turf_cap");
    gGangInviteCooldown  = GetDBIntField(0, "gang_invite_cooldown");
    gTax                 = GetDBIntField(0, "tax");
    gTaxVault            = GetDBIntField(0, "taxvault");
    gNewsVault           = GetDBIntField(0, "newsvault");
    gDoubleXP            = GetDBIntField(0, "doublexp");
    gVPNState            = GetDBIntField(0, "vpn_state");
    gHourReward          = GetDBIntField(0, "hour_reward");
    gLottoJackpot        = GetDBIntField(0, "lotto_jackpot");
    gLottoTicketsSold    = GetDBIntField(0, "lotto_tickets_sold");

    GetDBStringField(0, "server_motd", gServerMOTD);
    GetDBStringField(0, "admin_motd", gAdminMOTD);
    GetDBStringField(0, "helper_motd", gHelperMOTD);

    ChangeWeather(GetDBWeatherID());
    SetDoubleXPState(gDoubleXP); // Force update hostname
}

hook OnServerBeacon(timestamp)
{
    if (!gStateIsUpToDate)
    {
        gStateIsUpToDate = true;
        DBQuery("UPDATE "#TABLE_SERVER_STATE" SET \
        charity=%i, weather=%i, anticheat=%i, max_turf_cap=%i, gang_invite_cooldown=%i, tax=%i, taxvault=%i, \
        newsvault=%i, doublexp=%i, vpn_state=%i, hour_reward=%i, server_motd='%e', admin_motd='%e', helper_motd='%e',\
        lotto_jackpot=%i, lotto_tickets_sold=%i", gCharity, gWeather, gAnticheat, MaxTurfCap, gGangInviteCooldown, gTax, gTaxVault,
        gNewsVault, gDoubleXP, gVPNState, gHourReward, gServerMOTD, gAdminMOTD, gHelperMOTD,
        gLottoJackpot, gLottoTicketsSold);
    }
    return 1;
}

CMD:doublexp(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_10))
    {
        SendClientMessage(playerid, COLOR_GREY, "Check the new command /rewards");
    }
    return 1;
}

CMD:enddoublexp(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_10))
    {
        SendClientMessage(playerid, COLOR_GREY, "Check the new command /rewards");
    }
    return 1;
}

CMD:rewards(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendUnauthorized(playerid);
    }
    new option[14], s = -1;
    if (sscanf(params, "s[14]i()", option, s))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rewards [doublexp/hour_reward] [1/0]");
        return SendClientMessageEx(playerid, COLOR_WHITE, "Current double XP state: %i, Current hour reward state: %i, ", IsDoubleXPEnabled(), IsHourRewardEnabled());
    }

    if (!strcmp(option, "doublexp", true))
    {
        if (s == -1)
        {
        }
        else
        {
            SetDoubleXPState(s != 0);
            if (IsDoubleXPEnabled())
            {
                SendClientMessageToAllEx(COLOR_AQUA, "* %s enabled happy hours. You will now get double xp for playing in the server.", GetRPName(playerid));
            }
            else
            {
                SendAdminWarning(2, "%s has disabled double XP.", GetPlayerNameEx(playerid));
            }
        }
    }
    else if (!strcmp(option, "hour_reward", true))
    {
        if (s == -1)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "Current hour reward state: %i", IsHourRewardEnabled());
        }
        else
        {
            SetHourRewardState(s != 0);
            if (IsHourRewardEnabled())
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

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", s) || !(0 <= s <= 1))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /anticheat [0/1]");
    }

    if (s)
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
