/// @file      Weather.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static nextWeather;

hook OnNewHour(timestamp, hour)
{
    ChangeWeather();
}

ChangeWeather(weather = -1)
{
    if (weather != -1)
        nextWeather = weather;

    SetWeather(nextWeather);
    SetDBWeatherID(nextWeather);
    switch (random(21))
    {
        case 0: nextWeather = 0;
        case 1: nextWeather = 1;
        case 2: nextWeather = 2;
        case 3: nextWeather = 3;
        case 4: nextWeather = 4;
        case 5: nextWeather = 5;
        case 6: nextWeather = 6;
        case 7: nextWeather = 7;
        case 8: nextWeather = 8;
        case 9: nextWeather = 9;
        case 10: nextWeather = 10;
        case 11: nextWeather = 11;
        case 12: nextWeather = 12;
        case 13: nextWeather = 13;
        case 14: nextWeather = 14;
        case 15: nextWeather = 15;
        case 16: nextWeather = 16;
        case 17: nextWeather = 17;
        case 18: nextWeather = 18;
        case 19: nextWeather = 19;
        case 20: nextWeather = 20;
    }
}

CMD:nextweather(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_NEWS)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a news reporter.");
    }
    if (nextWeather == 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
    }
    if (nextWeather == 1)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Moderate Sunny");
    }
    if (nextWeather == 2)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
    }
    if (nextWeather == 3)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny");
    }
    if (nextWeather == 4)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
    }
    if (nextWeather == 5)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
    }
    if (nextWeather == 6)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
    }
    if (nextWeather == 7)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
    }
    if (nextWeather == 8)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Rainy");
    }
    if (nextWeather == 9)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Foggy");
    }
    if (nextWeather == 10)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
    }
    if (nextWeather == 11)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
    }
    if (nextWeather == 12)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
    }
    if (nextWeather == 13)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
    }
    if (nextWeather == 14)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sunny Skies");
    }
    if (nextWeather == 15)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Cloudy");
    }
    if (nextWeather == 16)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Rainy");
    }
    if (nextWeather == 17)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
    }
    if (nextWeather == 18)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Extra Sunny");
    }
    if (nextWeather == 19)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Sandstorm");
    }
    if (nextWeather == 20)
    {
        SendClientMessage(playerid, COLOR_GREY, "Weather Forecast for the next hour, {FFFFFF}Foggy(greenish)");
    }
    return 1;
}

CMD:forceweather(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    ChangeWeather();
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced the weather to change.", GetRPName(playerid));
    return 1;
}

CMD:setweather(playerid, params[])
{
    new weatherid;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", weatherid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setweather [weatherid]");
    }

    SetDBWeatherID(weatherid);
    SetWeather(weatherid);
    SendClientMessageEx(playerid, COLOR_GREY2, "Weather changed to %i.", weatherid);
    return 1;
}
