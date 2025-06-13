/// @file      Job_Mechanic.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static mechanicVehicles[10];

static Mec_MaxPlayerComps = 50;
static Mec_MaxCompsToBuy = 10;
static Mec_CompsPrice = 1200;
static Mec_CompsReductionPerLevel = 200;

IsMechanicVehicle(vehicleid)
{
    return (mechanicVehicles[0] <= vehicleid <= mechanicVehicles[sizeof(mechanicVehicles) - 1]);
}

IsPlayerAtMechanicComponent(playerid)
{
    return (IsPlayerInRangeOfPoint(playerid, 3.0, 1952.1062,-1558.4139,13.7161) ||
            IsPlayerInRangeOfPoint(playerid, 3.0, -2107.1096,-26.0882,35.3203));
}

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:config;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "mechanic", config))
    {
        JSON_GetInt(config, "max_player_comps",          Mec_MaxPlayerComps);
        JSON_GetInt(config, "max_comps_to_buy",          Mec_MaxCompsToBuy);
        JSON_GetInt(config, "comps_price",               Mec_CompsPrice);
        JSON_GetInt(config, "comps_reduction_per_level", Mec_CompsReductionPerLevel);
    }

    CreateDynamic3DTextLabel("Mechanic components\n/buycomps to purchase.", COLOR_YELLOW, -2107.1096,-26.0882,35.3203, 10.0);
    CreateDynamicPickup(1239, 1, -2107.1096,-26.0882,35.3203);
    CreateDynamic3DTextLabel("Mechanic components\n/buycomps to purchase.", COLOR_YELLOW, 1952.1062,-1558.4139,13.7161, 10.0);
    CreateDynamicPickup(1239, 1, 1952.1062,-1558.4139,13.7161);

    mechanicVehicles[0] = AddStaticVehicleEx(525, 2006.7156, -1597.4458, 13.4951, 90.31800, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[1] = AddStaticVehicleEx(525, 2006.7440, -1591.5389, 13.4949, 88.41020, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[2] = AddStaticVehicleEx(525, 1992.3689, -1588.7999, 13.5447, 269.5335, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[3] = AddStaticVehicleEx(525, 1992.2521, -1585.0267, 13.5464, 270.7720, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[4] = AddStaticVehicleEx(525, 1992.0063, -1581.3099, 13.5507, 268.0523, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[5] = AddStaticVehicleEx(525, 1966.5272, -1589.4178, 13.5988, 94.61080, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[6] = AddStaticVehicleEx(525, 1965.3048, -1584.7124, 13.5931, 91.62180, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[7] = AddStaticVehicleEx(525, 1929.5402, -1590.5438, 13.5605, 266.9044, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[8] = AddStaticVehicleEx(525, 1929.2091, -1586.3318, 13.5931, 268.8034, 1, 44, 300); // Mechanic Towtruck   525
    mechanicVehicles[9] = AddStaticVehicleEx(525, 1929.0546, -1582.3019, 13.5929, 271.7378, 1, 44, 300); // Mechanic Towtruck   525

    // --------------------------------< Mechanic > ------------------------------------------ //
    CreateDynamicObject(11387, 1938.19714, -1574.17957, 16.07544,   0.00000, 0.00000, -89.15997);
    CreateDynamicObject(11389, 1954.06860, -1564.53979, 15.85070,   0.00000, 0.00000, -449.10004);
    CreateDynamicObject(11391, 1945.76685, -1556.60034, 13.97530,   0.00000, 0.00000, -88.98000);
    CreateDynamicObject(5532, 1979.91541, -1576.38586, 20.66209,   0.00000, 0.00000, -88.38000);
    CreateDynamicObject(11326, 2019.61536, -1599.76355, 14.92121,   0.00000, 0.00000, -270.59991);
    CreateDynamicObject(923, 1954.61389, -1575.37744, 13.57085,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(923, 1954.68970, -1578.03662, 13.57085,   0.00000, 0.00000, -48.18000);
    CreateDynamicObject(923, 1961.86426, -1574.97534, 13.57085,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(922, 1970.68567, -1589.12769, 13.57559,   0.00000, 0.00000, 91.74000);
    CreateDynamicObject(925, 1970.03296, -1585.53931, 12.59574,   0.00000, 0.00000, -87.59999);
    CreateDynamicObject(17951, 1937.57910, -1560.28455, 14.43111,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(17951, 1958.03430, -1574.08643, 14.42060,   0.00000, 0.00000, 90.36003);
    CreateDynamicObject(17951, 1958.03455, -1574.06641, 15.11645,   0.00000, 0.00000, 90.36003);
    CreateDynamicObject(14826, 1989.33679, -1592.96106, 13.29721,   0.00000, 0.00000, 270.11993);
    CreateDynamicObject(14826, 1959.42993, -1605.15576, 13.29721,   0.00000, 0.00000, 470.28012);
    CreateDynamicObject(19425, 1978.87634, -1590.87891, 12.57487,   0.00000, 0.00000, 1.68000);
    CreateDynamicObject(19425, 1979.89893, -1590.86145, 12.57020,   0.00000, 0.00000, 1.68000);
    CreateDynamicObject(11326, 1963.69446, -1609.21631, 14.92121,   0.00000, 0.00000, -358.67990);
    CreateDynamicObject(2922, 1973.21143, -1600.57849, 13.97022,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2198, 1939.60779, -1567.92358, 12.70980,   0.00000, 0.00000, 90.60000);
    CreateDynamicObject(2186, 1940.73486, -1572.64490, 12.71051,   0.00000, 0.00000, -179.63998);
    CreateDynamicObject(2182, 1947.77332, -1571.76135, 12.70937,   0.00000, 0.00000, 181.68002);
    CreateDynamicObject(2181, 1939.32800, -1570.39026, 12.70823,   0.00000, 0.00000, 90.84000);
    CreateDynamicObject(2164, 1945.41162, -1573.21497, 12.70905,   0.00000, 0.00000, 180.59996);
    CreateDynamicObject(2165, 1947.75256, -1567.21411, 12.71034,   0.00000, 0.00000, -89.45999);
    CreateDynamicObject(1721, 1947.07275, -1568.03613, 12.71045,   0.00000, 0.00000, -89.27998);
    CreateDynamicObject(1721, 1946.66626, -1572.08289, 12.71045,   0.00000, 0.00000, -55.43998);
    CreateDynamicObject(1721, 1940.05396, -1570.04810, 12.71045,   0.00000, 0.00000, 91.74002);
    CreateDynamicObject(1721, 1941.14050, -1567.31104, 12.71045,   0.00000, 0.00000, 91.74002);
    CreateDynamicObject(1676, 1943.46484, -1586.30334, 14.30219,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1676, 1945.51257, -1586.30701, 14.30219,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1650, 1941.43677, -1586.11792, 13.21206,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1650, 1941.44873, -1586.27734, 13.21206,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1650, 1941.08105, -1586.18433, 13.21206,   0.00000, 0.00000, -30.78000);
    CreateDynamicObject(1650, 1947.24316, -1586.20044, 13.20952,   0.00000, 0.00000, 93.66002);
    CreateDynamicObject(1650, 1947.40405, -1586.19177, 13.20952,   0.00000, 0.00000, 93.66002);
    CreateDynamicObject(1650, 1947.56519, -1586.18311, 13.20952,   0.00000, 0.00000, 93.66002);
    CreateDynamicObject(1215, 1931.62671, -1602.51697, 13.01522,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1215, 1942.22290, -1604.50208, 13.01522,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1215, 2011.01172, -1602.47937, 13.00364,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1215, 2001.11780, -1604.30420, 13.00364,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(939, 1982.65649, -1607.75000, 13.11219,   0.00000, 0.00000, -88.92001);
    CreateDynamicObject(3576, 1955.79248, -1615.50574, 13.98947,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3576, 1953.09497, -1612.78406, 13.98947,   0.00000, 0.00000, 89.93998);
    CreateDynamicObject(19817, 1978.42810, -1605.43335, 11.77546,   0.00000, 0.00000, -180.35997);
    CreateDynamicObject(19899, 1974.00366, -1605.22058, 12.83894,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19907, 2002.75476, -1570.48083, 12.56207,   0.00000, 0.00000, 449.87997);
    CreateDynamicObject(19817, 2000.43469, -1572.70581, 12.64815,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19872, 1995.59875, -1572.85876, 10.84902,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11388, 1954.02051, -1564.49719, 19.41262,   0.00000, 0.00000, -89.03999);
    CreateDynamicObject(11393, 2017.67419, -1580.00183, 14.42911,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(14826, 2006.60181, -1574.19165, 13.37573,   0.00000, 0.00000, 467.81992);
    CreateDynamicObject(17951, 2008.61206, -1568.90906, 13.41685,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11391, 1998.15320, -1565.87292, 13.96399,   0.00000, 0.00000, -90.29996);
    CreateDynamicObject(11393, 1988.91077, -1568.45825, 14.12789,   0.00000, 0.00000, 268.07999);
    CreateDynamicObject(925, 1969.87012, -1583.18237, 12.59574,   0.00000, 0.00000, -87.59999);
    CreateDynamicObject(922, 1970.38574, -1579.39392, 13.57559,   0.00000, 0.00000, 91.74000);
    CreateDynamicObject(19817, 1965.90161, -1561.09741, 12.08665,   0.00000, 0.00000, 0.72000);
    CreateDynamicObject(17951, 1937.59912, -1560.28381, 15.19127,   0.00000, 0.00000, 0.36000);
    CreateDynamicObject(930, 2014.99951, -1582.80908, 13.16166,   0.00000, 0.00000, 27.12000);
    CreateDynamicObject(19872, 2017.20850, -1586.25916, 11.08814,   -4.62000, 0.48000, 86.70000);
    CreateDynamicObject(19545, 1932.58557, -1571.02380, 12.57320,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19545, 1947.60132, -1571.01697, 12.57320,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19545, 1962.62415, -1571.04993, 12.58735,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19545, 1979.12390, -1582.40906, 12.66414,   0.00000, 0.00000, 88.98003);
    CreateDynamicObject(19545, 1979.14209, -1594.69434, 12.61443,   0.00000, 0.00000, 90.35996);
    CreateDynamicObject(19377, 1985.49158, -1583.84290, 23.35495,   0.00000, 0.00000, -5.70000);
    CreateDynamicObject(19377, 1985.98157, -1579.05835, 23.35495,   0.00000, 0.00000, -5.70000);
    CreateDynamicObject(19377, 1985.98157, -1579.05835, 12.93738,   0.00000, 0.00000, -5.70000);
    CreateDynamicObject(19377, 1985.49158, -1583.84290, 12.95711,   0.00000, 0.00000, -5.70000);
    return 1;
}

CMD:buycomps(playerid, params[])
{
    new amount, price, cost = Mec_CompsPrice - (GetJobLevel(playerid, JOB_MECHANIC) * Mec_CompsReductionPerLevel);

    if (!PlayerHasJob(playerid, JOB_MECHANIC))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic.");
    }
    if (!IsPlayerAtMechanicComponent(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the component shop.");
    }
    if (sscanf(params, "i", amount))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /buycomps [amount]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "You are paying $%i per component at your current skill level.", cost);
        return 1;
    }
    if (!(1 <= amount <= Mec_MaxCompsToBuy))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "The amount must range between 1 and %i.", Mec_MaxCompsToBuy);
    }
    if (PlayerData[playerid][pComponents] + amount > Mec_MaxPlayerComps)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't carry more than %i components.", Mec_MaxPlayerComps);
    }
    price = amount * cost;
    if (PlayerData[playerid][pCash] < price)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You can't afford to purchase %i components for $%i.", amount, price);
    }
    else
    {
        PlayerData[playerid][pComponents] += amount;
        GivePlayerCash(playerid, -price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i components for $%i.", amount, price);
        DBQuery("UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);
    }
    return 1;
}

CMD:repair(playerid, params[])
{
    //TODO: use it only near the vehicle
    new vehicleid = GetNearbyVehicle(playerid), Float:health;

    if (!PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must either be a mechanic, or a Legendary VIP to use this command.");
    }
    if (GetInsideGarage(playerid) >= 0)
    {
        if (gettime() - PlayerData[playerid][pLastRepair] < 120 - 12 * GetJobLevel(playerid, JOB_MECHANIC) )
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", (120 - 12 * GetJobLevel(playerid, JOB_MECHANIC)) - (gettime() - PlayerData[playerid][pLastRepair]));
        }
        if (!vehicleid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
        }
        if (!VehicleHasEngine(vehicleid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be repaired.");
        }

        if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && VehicleHasDoors(vehicleid) && !IsVehicleParamOn(vehicleid, VEHICLE_BONNET))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to open the vehicle hood (/hood).");
        }
        GetVehicleHealth(vehicleid, health);

        if (health >= 1000.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't need to be repaired.");
        }
        else
        {
            PlayerData[playerid][pLastRepair] = gettime();
            SetVehicleHealth(vehicleid, 1000.0);
            if (PlayerHasJob(playerid, JOB_MECHANIC))
            {
                GivePlayerRankPointLegalJob(playerid, 20);
            }
            ShowActionBubble(playerid, "* %s repairs the vehicle.", GetRPName(playerid));
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        }
    }
    else if (PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] < 3)
    {
        if (PlayerData[playerid][pDonator] < 3 && PlayerData[playerid][pComponents] <= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
        }
        if (gettime() - PlayerData[playerid][pLastRepair] < 20)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerData[playerid][pLastRepair]));
        }
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to repair a vehicle.");
        }

        if (vehicleid == INVALID_VEHICLE_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not near any vehicle.");
        }
        if (!VehicleHasEngine(vehicleid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be repaired.");
        }
        if (VehicleHasDoors(vehicleid) && !IsVehicleParamOn(vehicleid, VEHICLE_BONNET))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to open the vehicle hood (/hood).");
        }

        GetVehicleHealth(vehicleid, health);

        if (health >= 1000.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't need to be repaired.");
        }
        else if (health < 400.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "The vehicle is too damaged to repair it.");
        }
        else
        {
            PlayerData[playerid][pComponents]--;

            DBQuery("UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);


            PlayerData[playerid][pLastRepair] = gettime();
            SetVehicleHealth(vehicleid, 1000.0);

            if (GetJobLevel(playerid, JOB_MECHANIC) == 5)
            {
                RepairVehicle(vehicleid);
                SendClientMessage(playerid, COLOR_WHITE, "You have repaired the health and bodywork on this vehicle..");
            }
            else
            {
                SendClientMessage(playerid, COLOR_WHITE, "You have repaired this vehicle to maximum health.");
            }

            if (PlayerHasJob(playerid, JOB_MECHANIC))
            {
                GivePlayerRankPointLegalJob(playerid, 20);
            }
            ShowActionBubble(playerid, "* %s repairs the vehicle.", GetRPName(playerid));

            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            IncreaseJobSkill(playerid, JOB_MECHANIC);
        }
    }
    else if (PlayerData[playerid][pDonator] == 3)
    {
        if (PlayerData[playerid][pDonator] < 3 && !PlayerData[playerid][pComponents])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
        }
        if (gettime() - PlayerData[playerid][pLastRepair] < 20)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerData[playerid][pLastRepair]));
        }
        if (!vehicleid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
        }
        if (!VehicleHasEngine(vehicleid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be repaired.");
        }
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to repair a vehicle.");
        }

        GetVehicleHealth(vehicleid, health);

        if (health >= 1000.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't need to be repaired.");
        }
        else if (health < 400.0)
        {
            SendClientMessage(playerid, COLOR_GREY, "The vehicle is too damaged to repair it.");
        }
        else
        {
            SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You repaired this vehicle free of charge.");

            PlayerData[playerid][pLastRepair] = gettime();

            SetVehicleHealth(vehicleid, 1000.0);
            RepairVehicle(vehicleid);

            if (PlayerHasJob(playerid, JOB_MECHANIC))
            {
                GivePlayerRankPointLegalJob(playerid, 20);
            }
            ShowActionBubble(playerid, "* %s repairs the vehicle.", GetRPName(playerid));

            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            IncreaseJobSkill(playerid, JOB_MECHANIC);
        }
    }
    return 1;
}

CMD:nos(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] != 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic.");
    }
    if (PlayerData[playerid][pDonator] == 0 && !PlayerData[playerid][pComponents])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
    }

    switch (GetVehicleModel(vehicleid))
    {
        case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449:
            return SendClientMessage(playerid, COLOR_GREY, "This vehicle can't be modified with nitrous.");
    }
    if (GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1010)) != 1010 &&
       GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1009)) != 1009 &&
       GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1008)) != 1008)
    {
        if (PlayerData[playerid][pDonator] < 3)
        {
            PlayerData[playerid][pComponents]--;

            DBQuery("UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);

        }
        else
        {
            SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You added nitrous to this vehicle free of charge.");
        }

        AddVehicleComponent(vehicleid, 1009);

        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        ShowActionBubble(playerid, "* %s attaches a 2x NOS Canister on the engine feed.", GetRPName(playerid));
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "This vehicle has nos already");
    }
    return 1;
}

CMD:hyd(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[playerid][pDonator] != 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic.");
    }
    if (PlayerData[playerid][pMechanicSkill] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 2 mechanic to use this command.");
    }
    if (PlayerData[playerid][pDonator] == 0 && !PlayerData[playerid][pComponents])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no components left.");
    }
    if (!vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not inside of any vehicle.");
    }

    if (PlayerData[playerid][pDonator] < 3)
    {
        PlayerData[playerid][pComponents]--;

        DBQuery("UPDATE "#TABLE_USERS" SET components = %i WHERE uid = %i", PlayerData[playerid][pComponents], PlayerData[playerid][pID]);

    }
    else
    {
        SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You added hydraulics to this vehicle free of charge.");
    }

    AddVehicleComponent(vehicleid, 1087);

    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    ShowActionBubble(playerid, "* %s attaches a set of hydraulics to the vehicle.", GetRPName(playerid));
    return 1;
}

CMD:tow(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (GetVehicleModel(vehicleid) != 525)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be in a tow truck to use this command.");
    }
    if (!PlayerHasJob(playerid, JOB_MECHANIC) && !IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
    }
    if (PlayerData[playerid][pMechanicSkill] < 3 && !IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be a skill level 3 mechanic to use this command.");
    }

    if (IsTrailerAttachedToVehicle(vehicleid))
    {
        DetachTrailerFromVehicle(vehicleid);
        ShowActionBubble(playerid, "* %s lowers their tow hook, detaching it from the vehicle.", GetRPName(playerid));
        return 1;
    }

    new Float:vX, Float:vY, Float:vZ;
    new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    foreach(new vid: Vehicle)
    {
        GetVehiclePos(vid, vX, vY, vZ);
        if (vid != vehicleid && IsPointInRangeOfPoint(vX, vY, vZ, 7.0, pX, pY, pZ) && !IsVehicleTowedToTrailer(vid))
        {
            AttachTrailerToVehicle(vid, vehicleid);
            ShowActionBubble(playerid, "* %s lowers their tow hook, attaching it to the vehicle.", GetRPName(playerid));
            ShowActionBubble(playerid, "* %s raises the tow hook, locking the vehicle in place..", GetRPName(playerid));
            return 1;
        }
    }
    return SendClientMessage(playerid, COLOR_GREY, "There is no vehicle in range that you can tow.");
}

CMD:repaircar(playerid, params[])
{
    new entranceid = GetNearbyEntrance(playerid);

    if (entranceid == -1 || EntranceInfo[entranceid][eType] != 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't nearby any repairshops.");
    }
    if (EntranceInfo[entranceid][eAdminLevel] && !IsAdmin(playerid, EntranceInfo[entranceid][eAdminLevel]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your administrator level is too low to repair here.");
    }
    if (EntranceInfo[entranceid][eFaction] >= 0 && PlayerData[playerid][pFaction] != EntranceInfo[entranceid][eFaction])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific faction type.");
    }
    if (EntranceInfo[entranceid][eGang] >= 0 && EntranceInfo[entranceid][eGang] != PlayerData[playerid][pGang])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a specific gang type.");
    }
    if (EntranceInfo[entranceid][eVIP] && PlayerData[playerid][pDonator] < EntranceInfo[entranceid][eVIP])
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command is restricted to a higher VIP level.");
    }
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't driving a vehicle.");
    }
    RepairVehicle(GetPlayerVehicleID(playerid));
    SendClientMessage(playerid, COLOR_GREY, "Your vehicle was repaired.");
    return 1;
}
