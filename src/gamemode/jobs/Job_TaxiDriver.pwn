/// @file      Job_TaxiDriver.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-07-02 13:34:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static Taxi_Vehicles[4];
static Taxi_LastFare[MAX_PLAYERS];
static Taxi_Fare[MAX_PLAYERS];
static Taxi_Passenger[MAX_PLAYERS];
static Taxi_Bill[MAX_PLAYERS];
static Taxi_Time[MAX_PLAYERS];

static Taxi_Cooldown = 15;
static Taxi_MaxFare  = 500;

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "taxi_driver", config))
    {
        JSON_GetInt(config, "fare_cooldown_seconds", Taxi_Cooldown);
        JSON_GetInt(config, "max_fare",              Taxi_MaxFare);
    }

    Taxi_Vehicles[0] = AddStaticVehicleEx(420, 1775.6141, -1860.0100, 13.2745, 269.2006, 6, 1, 300); // taxi 1
    Taxi_Vehicles[1] = AddStaticVehicleEx(420, 1763.0121, -1860.0037, 13.2723, 271.2998, 6, 1, 300); // taxi 2
    Taxi_Vehicles[2] = AddStaticVehicleEx(420, 1748.9358, -1859.9502, 13.2721, 270.3943, 6, 1, 300); // taxi 3
    Taxi_Vehicles[3] = AddStaticVehicleEx(420, 1734.6754, -1859.9305, 13.2740, 270.5646, 6, 1, 300); // taxi 4
    return 1;
}

hook OnPlayerInit(playerid)
{
    Taxi_Fare[playerid]      = 0;
    Taxi_Bill[playerid]      = 0;
    Taxi_Time[playerid]      = 0;
    Taxi_LastFare[playerid]  = 0;
    Taxi_Passenger[playerid] = INVALID_PLAYER_ID;
}

IsTaxiJobVehicle(vehicleid)
{
    return (Taxi_Vehicles[0] <= vehicleid <= Taxi_Vehicles[sizeof(Taxi_Vehicles) - 1]);
}

IsTaxiDriverOnDuty(playerid)
{
    return Taxi_Fare[playerid] > 0;
}

CMD:setfare(playerid, params[])
{
    new amount;

    if (!PlayerHasJob(playerid, JOB_TAXIDRIVER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Taxi Driver.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setfare [amount]");
    }
    if (!(0 <= amount <= Taxi_MaxFare))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The fare must range between $0 and %s.", FormatCash(Taxi_MaxFare));
    }
    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 420 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 438)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a taxi type vehicle.");
    }
    if (gettime() - Taxi_LastFare[playerid] < 50)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only speak in this channel every 50 seconds. Please wait %i more seconds.", 50 - (gettime() - Taxi_LastFare[playerid]));
    }
    if (amount == 0)
    {
        if (Taxi_Fare[playerid] == 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The fare is already set to zero.");
        }

        Taxi_Fare[playerid] = 0;
        SendClientMessage(playerid, COLOR_YELLOW, "* You have set the fare to $0 and went off duty.");
    }
    else
    {
        if (Taxi_Fare[playerid] == amount)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The fare is already set to this amount.");
        }
        Taxi_LastFare[playerid] = gettime();
        Taxi_Fare[playerid] = amount;
        SendClientMessageToAllEx(COLOR_YELLOW, "* Taxi driver %s is now on duty, fare: $%i. /call taxi for a ride.", GetRPName(playerid), amount);
    }
    return 1;
}

CancelTaxiRide(playerid) // playerid is the driver of the taxi.
{
    new passengerid = Taxi_Passenger[playerid];
    new bill        = Taxi_Bill[playerid];
    new earned      = Taxi_Bill[playerid];
    new string[20];

    if (PlayerData[playerid][pLaborUpgrade] != 0)
    {
        earned += percent(earned, PlayerData[playerid][pLaborUpgrade]);
    }

    SendClientMessageEx(passengerid, COLOR_AQUA, "This ride costed you {FF6347}$%i{33CCFF}.", bill);
    SendClientMessageEx(playerid, COLOR_AQUA, "You earned {00AA00}$%i{33CCFF} for this ride.", earned);

    format(string, sizeof(string), "~r~-$%i", bill);
    GameTextForPlayer(passengerid, string, 5000, 1);

    format(string, sizeof(string), "~g~+$%i", earned);
    GameTextForPlayer(playerid, string, 5000, 1);

    GivePlayerCash(passengerid, -bill);
    AddToPaycheck(playerid, earned);

    Taxi_Passenger[playerid] = INVALID_PLAYER_ID;
    Taxi_Bill[playerid] = 0;
    Taxi_Time[playerid] = 0;
}

hook OnPlayerHeartBeat(playerid)
{
    new passangerid = Taxi_Passenger[playerid];
    if (passangerid != INVALID_PLAYER_ID)
    {
        if ((GetVehicleModel(GetPlayerVehicleID(playerid)) != 420 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 438) ||
            !IsPlayerInVehicle(passangerid, GetPlayerVehicleID(playerid)) ||
            Taxi_Fare[playerid] == 0 ||
            PlayerData[passangerid][pCash] < Taxi_Bill[playerid])
        {
            CancelTaxiRide(playerid);
        }
        else
        {
            Taxi_Time[playerid]++;
            if (Taxi_Time[playerid] >= Taxi_Cooldown)
            {
                Taxi_Time[playerid] = 0;
                Taxi_Bill[playerid] += Taxi_Fare[playerid];
            }
            new string[64];
            format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~g~Taxi Meter:~w~ $%i", Taxi_Bill[playerid]);
            GameTextForPlayer(playerid, string, 3000, 3);
        }
    }
}

hook OnPlayerDisconnect(playerid)
{
    foreach(new i : Player)
    {
        if (Taxi_Passenger[i] == playerid)
        {
            CancelTaxiRide(i);
        }
    }
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate != PLAYER_STATE_PASSENGER || oldstate == PLAYER_STATE_DRIVER)
    {
        return 1;
    }
    new vehicleid    = GetPlayerVehicleID(playerid);
    new vehicleModel = GetVehicleModel(vehicleid);
    if (vehicleModel != 420 && vehicleModel != 438)
    {
        return 1;
    }

    new driverid = GetVehicleDriver(vehicleid);
    if (IsPlayerConnected(driverid) && Taxi_Fare[driverid] > 0 && Taxi_Passenger[driverid] == INVALID_PLAYER_ID)
    {
        if (PlayerData[playerid][pCash] < Taxi_Fare[driverid])
        {
            RemovePlayerFromVehicle(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "You can't afford to pay the fare. Therefore you can't ride this taxi.");
        }

        Taxi_Passenger[driverid] = playerid;
        Taxi_Bill[driverid] = Taxi_Fare[driverid];
        Taxi_Time[driverid] = 0;

        ShowActionBubble(playerid, "* %s enters %s's taxi cab.", GetRPName(playerid), GetRPName(driverid));
        SendClientMessageEx(playerid, COLOR_YELLOW, "You will be charged the fare price of {FF6347}%s{33CCFF} every %i seconds during your ride.",
                            FormatCash(Taxi_Fare[driverid]), Taxi_Cooldown);
        SendClientMessageEx(driverid, COLOR_AQUA, "*%s has entered your taxi. You will earn {00AA00}%s{33CCFF} every %i seconds during the ride.",
                            GetRPName(playerid), FormatCash(Taxi_Fare[driverid]), Taxi_Cooldown);
    }
    return 1;
}
