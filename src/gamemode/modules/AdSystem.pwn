/// @file      AdSystem.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-07-21 11:54:37 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MAX_AD_LENGHT 128
enum AdEnum
{
    AdMsg[MAX_AD_LENGHT],
    AdOwner[MAX_PLAYER_NAME],
    AdPhone
};
static LastAds[5][AdEnum];
static AdIndex;
static TotalAds;
static LastAdTime;
hook OnGameModeInit()
{
    AdIndex=0;
    TotalAds=0;
    LastAdTime=0;
    return 1;
}

CMD:advertise(playerid, params[])
{
    return callcmd::ad(playerid, params);
}

CMD:ad(playerid, params[])
{
    if (IsAdMuted(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are muted from submitting advertisements. /report for an unmute.");
    }

    if (!PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a mobile phone. You need a phone so people can contact you.");
    }
    if (PlayerData[playerid][pTogglePhone] == 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can not /ad while your phone is turned off");
    }
    if (PlayerData[playerid][pHours] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to play at least 2 hours in order to post an advertisement.");
    }
    if (gettime() - LastAdTime < 59)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Advertisements can only be posted every 1 minute.");
    }
    if (PlayerData[playerid][pJailTime] > 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't use advertisements while in jail.");
    }
    if (isnull(params))
    {
        return SendUsageHeader(playerid, "ad", "[message]");
    }
    if (strlen(params) < 15)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Advertisement is too short. Minimal ad can have 15 characters.");
    }
    if (strlen(params) > MAX_AD_LENGHT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Advertisement is too long.");
    }

    new businessid = GetInsideBusiness(playerid), price = strlen(params) * 25;

    if ((PlayerData[playerid][pDonator] == 0) && (businessid == -1 || BusinessInfo[businessid][bType] != 5))
    {
        if (GetClosestBusiness(playerid, BUSINESS_AGENCY) == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no advertisement agencies in town.");
        }
        businessid = GetClosestBusiness(playerid, BUSINESS_AGENCY);
    }
    if (PlayerData[playerid][pDonator] < 3 && PlayerData[playerid][pCash] < price)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need %s in order to place the advertisement. You can't afford that.", FormatCash(price));
    }
    if (PlayerData[playerid][pDonator] == 3)
    {
        SendClientMessage(playerid, COLOR_VIP, "VIP Perk: Your advertisement was posted free of charge!");
    }
    else
    {
        new string[20];
        format(string, sizeof(string), "~r~-$%i", price);
        GameTextForPlayer(playerid, string, 5000, 1);

        GivePlayerCash(playerid, -price);

        if (businessid >= 0)
        {
            PerformBusinessPurchase(playerid, businessid, price);
        }
    }
    LastAdTime = gettime();
    strcpy(LastAds[AdIndex][AdMsg], params, 128);
    strcpy(LastAds[AdIndex][AdOwner], GetRPName(playerid), MAX_PLAYER_NAME);
    LastAds[AdIndex][AdPhone] = PlayerData[playerid][pPhone];
    if (PlayerData[playerid][pDonator] > 0)
    {
        SendClientMessageToAllEx(0x8DC540FF, " Advertisement: %s {8DC540}, Contact %s (%i)", params, GetRPName(playerid), PlayerData[playerid][pPhone]);
    }
    else
    {
        SendClientMessageToAllEx(0x00AA00FF, " Advertisement: %s {00AA00}, Contact %s (%i)", params, GetRPName(playerid), PlayerData[playerid][pPhone]);
    }

    AdIndex = (AdIndex + 1) % sizeof(LastAds);
    if (TotalAds < sizeof(LastAds))
    {
        TotalAds++;
    }
    return 1;
}



CMD:resetadtimer(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    LastAdTime = 0;
    SendClientMessage(playerid, COLOR_GREY, "Advertisement timer reset.");
    return 1;
}

CMD:ads(playerid, params[])
{
    if (TotalAds == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no advertisement available for the moment.");
    }
    new string[1280], line[1280];
    string = "";

    for (new idx = 0 ; idx < TotalAds ; idx++)
    {
        new i = (TotalAds - 1 + AdIndex - idx) % TotalAds;

        format(line, sizeof(line), "%s\t%s\t%i", LastAds[i][AdMsg], LastAds[i][AdOwner], LastAds[i][AdPhone]);

        if (string[0] == 0)
        {
            strcpy(string, line, sizeof(line));
        }
        else
        {
            format(string, sizeof(string), "%s\n%s", string, line);
        }

    }
    format(line, sizeof(line), "Advertisement\tName\tPhone\n%s", string);
    strcpy(string, line, sizeof(line));


    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Advertisements", string, "OK", "Cancel");
    return 1;
}

CMD:darkweb(playerid, params[]) return callcmd::dw(playerid, params);
CMD:dw(playerid, params[])
{
    if (IsAdMuted(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are muted from submitting advertisements. /report for an unmute.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /darkweb(dw) [text]");
    }
    if (!PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a mobile phone. You need a phone so people can contact you.");
    }
    if (PlayerData[playerid][pHours] < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to play at least 2 hours in order to post an advertisement.");
    }
    if (PlayerData[playerid][pTogglePhone] == 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can not /ad while your phone is turned off");
    }
    if (PlayerData[playerid][pJailTime] > 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't use DarkWeb while in jail.");
    }
    if (gettime() - LastAdTime < 59)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Advertisements can only be posted every 1 minute.");
    }

    new businessid = GetInsideBusiness(playerid), price = strlen(params) * 30;

    if ((PlayerData[playerid][pDonator] == 0) && (businessid == -1 || BusinessInfo[businessid][bType] != 5))
    {
        if (GetClosestBusiness(playerid, BUSINESS_AGENCY) == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There are no advertisement agencies in town.");
        }
        businessid = GetClosestBusiness(playerid, BUSINESS_AGENCY);
    }

    new string[20];
    format(string, sizeof(string), "~r~-$%i", price);
    GameTextForPlayer(playerid, string, 5000, 1);
    GivePlayerCash(playerid, -price);

    LastAdTime = gettime();
    if (businessid >= 0)
    {
        PerformBusinessPurchase(playerid, businessid, price);
    }

    SendAdminWarning(2, "%s[%i] has just write %s in dark web.", GetRPName(playerid), playerid, params);
    SendClientMessageToAllEx(COLOR_RED, "DarkWeb:{FFFFFF} %s, Contact (%i)", params, PlayerData[playerid][pPhone]);
    return 1;
}
