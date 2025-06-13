/// @file      CarTuning.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-07-09 00:21:16 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

//TODO: not saved after park

static PlayerTunningVehicle[MAX_PLAYERS];
static PlayerTunningType[MAX_PLAYERS];
enum eTuneData {
    TuneData_String[256],
    TuneData_Comps[MAX_VEHICLES_COMPONENTS],
    TuneData_Count
};

static TuneData[MAX_VEHICLES_MODELS][MAX_CARMODTYPES][eTuneData];
static MainTuneData[MAX_VEHICLES_MODELS][256];
static TuneColorStr[3400];

hook OnGameModeInit()
{
    new count, comps[MAX_VEHICLES_COMPONENTS], name[64];

    for (new vid = 0 ; vid < MAX_VEHICLES_MODELS ; vid++ )
    {
        new modelid = vid + 400;
        if (GetVehiclePaintJobCountByModel(modelid) > 0)
        {
            MainTuneData[vid] = "Colors\nPaint jobs";
        }
        else
        {
            MainTuneData[vid] = "Colors";
        }
        for (new comptype = 0 ; comptype < MAX_CARMODTYPES ; comptype++)
        {
            format(TuneData[vid][comptype][TuneData_String], 256, "");
        }

        GetVehicleUpgradesByModel(modelid, comps, sizeof(comps), count);
        if (count == 0)
        {
            continue;
        }

        for (new i = 0; i < count ; i++)
        {
            new compid   = comps[i];
            new comptype = GetVehicleComponentType(compid);

            if (comptype == -1)
            {
                printf("Critical: Unknown 'type' of component '%d'", compid);
                continue;
            }
            GetVehicleComponentName(compid, name, sizeof(name));

            if (isnull(TuneData[vid][comptype][TuneData_String]))
            {
                format(TuneData[vid][comptype][TuneData_String], 256, "%s", name);
            }
            else
            {
                format(TuneData[vid][comptype][TuneData_String], 256, "%s\n%s", TuneData[vid][comptype][TuneData_String], name);
            }
            TuneData[vid][comptype][TuneData_Comps][TuneData[vid][comptype][TuneData_Count]] = compid;
            TuneData[vid][comptype][TuneData_Count]++;
        }

        for (new comptype = 0 ; comptype < MAX_CARMODTYPES ; comptype++)
        {
            if (TuneData[vid][comptype][TuneData_Count])
            {
                format(MainTuneData[vid], 256, "%s\n%s", MainTuneData[vid], GetVehicleComponentTypeName(comptype));
            }
        }
    }

    TuneColorStr = "";
    count = 0;
    while (count < 256)
    {
        for (new i=0; i <= 15; i++)
        {
            format(TuneColorStr, 3400, "%s {%06x}%03d ", TuneColorStr, i_VehHexColors[count] >>> 8, count);
            count++;
        }
        strcat(TuneColorStr, "\n");
    }

    CreateDynamicPickup(1098, 23,  1961.0951, -1565.8511,13.7161);
    CreateDynamic3DTextLabel("/tune \nTo modify/tune your vehicle",COLOR_YELLOW, 1961.0951, -1565.8511, 13.7161+0.6,4.0);
    CreateDynamicPickup(1098, 23, -2116.5244,   -31.1166,36.6732);
    CreateDynamic3DTextLabel("/tune \nTo modify/tune your vehicle",COLOR_YELLOW,-2116.5244,   -31.1166, 36.6732+0.6,4.0);
    return 1;
}

CMD:carmods(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!IsValidVehicle(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to drive a vehicle in order to check it.");
    }
    new count = 0;
    for (new i = 0; i < 14; i ++)
    {
        new mod = GetVehicleComponentInSlot(vehicleid, i);
        if (mod != 0)
        {
            new componentname[64];
            GetVehicleComponentName(mod, componentname, sizeof(componentname));
            SendClientMessageEx(playerid, COLOR_GREY, "Slot [%d] %s: %s (%d)", i, GetVehicleComponentTypeName(i), componentname, mod);
            count++;
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, "Total vehicle mods: %d", count);
    return 1;
}

CMD:tune(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 50.0,  1961.0951, -1565.8511,13.7161) &&
       !IsPlayerInRangeOfPoint(playerid, 50.0, -2116.5244,   -31.1166,36.6732))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at mechanic job.");
    }

    new vehicleid = GetPlayerVehicleID(playerid);

    if (!IsValidVehicle(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to drive your vehicle in order to tune it.");
    }

    if (!IsVehicleOwner(playerid, vehicleid) &&
       !(IsPlayerGangVehicle(playerid, vehicleid) && IsGangLeader(playerid, PlayerData[playerid][pGang])))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to drive your vehicle in order to tune it.");
    }

    PlayerTunningVehicle[playerid] = vehicleid;
    new vid = GetVehicleModel(vehicleid) - 400;
    return Dialog_Show(playerid, CarTuningMainMenu, DIALOG_STYLE_LIST, "CarTuningMenu", MainTuneData[vid], "Enter", "Close");
}

Dialog:CarTuningMainMenu(playerid, response, listitem, inputtext[])
{
    new vehicleid = PlayerTunningVehicle[playerid];

    if ((!response || listitem < 0) ||
        (vehicleid == INVALID_VEHICLE_ID) ||
        (vehicleid != INVALID_VEHICLE_ID && vehicleid != GetPlayerVehicleID(playerid)))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }

    new pos            = listitem - 1;
    new vid            = GetVehicleModel(vehicleid) - 400;
    new totalPaintJobs = GetVehiclePaintJobCount(vehicleid);

    if (listitem == 0)
    {
        return Dialog_Show(playerid, CarTuningColorType, DIALOG_STYLE_LIST, "CarTuning::Colors", "Primary color\nSecondary color", "OK", "Cancel");
    }
    else if (totalPaintJobs > 0)
    {
        if (listitem == 1)
        {
            new str[40];
            if (totalPaintJobs == 1)
                str = "Paint job 1";
            else if (totalPaintJobs == 2)
                str = "Paint job 1\nPaint job 2";
            else
                str = "Paint job 1\nPaint job 2\nPaint job 3";

            return Dialog_Show(playerid, CarTuningPaintJob, DIALOG_STYLE_LIST, "CarTuning::PaintJobs", str, "Enter", "Close");
        }
        pos--;
    }

    new comptype = -1;
    for (new idx = 0; idx < MAX_CARMODTYPES; idx++)
    {
        if (TuneData[vid][idx][TuneData_Count] == 0)
            continue;
        if (pos == 0)
        {
            comptype = idx;
            break;
        }
        pos--;
    }
    if (comptype==-1)
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }
    PlayerTunningType[playerid] = comptype;
    return Dialog_Show(playerid, CarTuningMod, DIALOG_STYLE_LIST, "Car Tuning Menu", TuneData[vid][comptype][TuneData_String], "Enter", "Close");
}

Dialog:CarTuningPaintJob(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid);

    if (!IsValidVehicle(vehicleid))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }

    if ( 0 <= listitem < GetVehiclePaintJobCount(vehicleid))
    {
        SetVehicleHealth(vehicleid, 1000);
        ChangeVehiclePaintjob(vehicleid, listitem);
        new col1, col2;
        GetVehicleColor(vehicleid, col1, col2);
        if (col1 == 0)
        {
            col1 = 1;// Color 0 doesn't display paintjob
        }
        ChangeVehicleColor(vehicleid, col1, col2);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        SendClientMessage(playerid, COLOR_AQUA,"[CarTunning] You have succesfully repaired your car");
    }
    PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

Dialog:CarTuningColorType(playerid, response, listitem, inputtext[])
{
    if (response && listitem == 0)
    {
        Dialog_Show(playerid, CarTuningPrimaryColor, DIALOG_STYLE_INPUT, "CarTuning::PrimaryColor", TuneColorStr, "OK", "Cancel");
    }
    else if (response && listitem == 1)
    {
        Dialog_Show(playerid, CarTuningSecondaryColor, DIALOG_STYLE_INPUT, "CarTuning::SecondaryColor", TuneColorStr, "OK", "Cancel");
    }
    else
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
    }
    return 1;
}

Dialog:CarTuningPrimaryColor(playerid, response, listitem, inputtext[])
{
    if (!response || isnull(inputtext))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }
    new newColor = strval(inputtext);
    if (newColor < 0 || newColor > 255)
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return SendClientMessage(playerid, COLOR_GREY, "Invalid color code");
    }
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any vehicle");
    }
    new col1, col2;
    GetVehicleColor(vehicleid, col1, col2);
    ChangeVehicleColor(vehicleid, newColor, col2);
    SetVehicleHealth(vehicleid, 1000);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid, COLOR_AQUA,"[CarTunning] You have succesfully repaired your car");
    return 1;
}

Dialog:CarTuningSecondaryColor(playerid, response, listitem, inputtext[])
{
    if (!response || isnull(inputtext))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }
    new newColor = strval(inputtext);
    if (newColor < 0 || newColor > 255)
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return SendClientMessage(playerid, COLOR_GREY, "Invalid color code");
    }
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any vehicle");
    }
    new col1, col2;
    GetVehicleColor(vehicleid, col1, col2);
    ChangeVehicleColor(vehicleid, col1, newColor);
    SetVehicleHealth(vehicleid, 1000);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid, COLOR_AQUA,"[CarTunning] You have succesfully repaired your car");
    return 1;
}

Dialog:CarTuningMod(playerid, response, listitem, inputtext[])
{
    new vehicleid = PlayerTunningVehicle[playerid];

    if ((!response || listitem < 0) ||
        (vehicleid == INVALID_VEHICLE_ID) ||
        (vehicleid != INVALID_VEHICLE_ID && vehicleid != GetPlayerVehicleID(playerid)))
    {
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
        return 1;
    }

    new modelid       = GetVehicleModel(vehicleid);
    new componenttype = PlayerTunningType[playerid];
    new componentid   = TuneData[modelid - 400][componenttype][TuneData_Comps][listitem];
    new componentname[64];
    GetVehicleComponentName(componentid, componentname, sizeof(componentname));

    if (AddVehicleComponent(vehicleid, componentid))
    {
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0); // *Add Vehicle component sound (transfender)*
        SendClientMessageEx(playerid, COLOR_AQUA, "[CarTunning] Component {00FF00}%s{FFFFFF} successfully added.", componentname);
        PlayerTunningVehicle[playerid] = INVALID_VEHICLE_ID;
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "[CarTunning] Cannot add Component {FF0000}%s{FFFFFF}.", componentname);
    }
    return 1;
}
