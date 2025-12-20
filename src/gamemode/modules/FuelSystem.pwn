#include <YSI_Coding\y_hooks>


// 5(lost) * 60(sec) * 15(min)
#define MAX_FUEL 4500
#define REFUEL_COST 50
#define REFUEL_VALUE 150

static VehicleFuel[MAX_VEHICLES];
static Float: VehicleSpeed[MAX_VEHICLES];

static Float: VehicleOldX[MAX_VEHICLES];
static Float: VehicleOldY[MAX_VEHICLES];
static Float: VehicleOldZ[MAX_VEHICLES];
static Float: RefuelPositions[][]={
    { 1944.3260, -1772.9254, 13.3906}, { 1938.4952, -1772.9254, 13.3828}, // IdleWood
    { 1004.0070,  -939.3102, 42.1797}, { 1004.0070,  -933.3102, 42.1797}, // LS Mulholland
    {  -90.5515, -1169.4578,  2.4079}, { -1609.7958, -2718.2048, 48.5391}, //LS
    {-2029.4968,   156.4366, 28.9498}, { -2408.7590,   976.0934, 45.4175}, //SF
    {-2243.9629, -2560.6477, 31.8841}, { -1676.6323,   414.0262,  6.9484}, //Between LS and SF
    { 2202.2349,  2474.3494, 10.5258}, {   614.9333,  1689.7418,  6.6968}, //LV
    {-1328.8250,  2677.2173, 49.7665}, {    70.3882,  1218.6783, 18.5165}, //LV
    { 2113.7390,   920.1079, 10.5255}, { -1327.7218,  2678.8723, 50.0625}, //LV
    {  656.4265,  -559.8610, 16.5015}, {   656.3797,  -570.4138, 16.5015}, //Dillimore
    {-1679.9440,   122.8056,  2.0530}, { -1672.9373,   117.4142,  0.6511}, //SF Boat
    {-1193.9413,    28.3232, 13.7137} //SF Airport
};

hook OnGameModeInit()
{
    for(new vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        VehicleFuel [vehicleid] = MAX_FUEL;
        VehicleSpeed[vehicleid] = 0.0;
        VehicleOldX [vehicleid] = 0.0;
        VehicleOldY [vehicleid] = 0.0;
        VehicleOldZ [vehicleid] = 0.0;
    }
    for(new index = 0; index < sizeof(RefuelPositions); index++)
    {
        CreateDynamicPickup(1650, 1, RefuelPositions[index][0], RefuelPositions[index][1], RefuelPositions[index][2]);
        CreateDynamic3DTextLabel("Refuel\nGaz Station", COLOR_YELLOW, RefuelPositions[index][0], RefuelPositions[index][1], RefuelPositions[index][2], 10.0);
    }
}

hook OnVehicleSpawn(vehicleid)
{
    VehicleSpeed[vehicleid] = 0.0;
}

hook OnVehicleDeath(vehicleid, killerid)
{
    VehicleSpeed[vehicleid] = 0.0;
}

task UpdateVehicleSpeed[1000]()
{
    for(new vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        VehicleSpeed[vehicleid] = 0.0;
    }
    foreach(new playerid: Player)
    {   
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid == 0)
        {
            continue;
        }
        if(GetPlayerVehicleSeat(playerid) != 0 && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        {
            continue;
        }

        if(IsBiciyle(playerid) || IsARentableCar(vehicleid) || IsJobCar(vehicleid) || (VehicleInfo[vehicleid][vFaction] > -1 && FactionInfo[VehicleInfo[vehicleid][vFaction]][fType] != FACTION_NONE))
        {
            continue;
        }

        new Float:pX,Float:pY,Float:pZ;
        GetVehiclePos(vehicleid,Float:pX,Float:pY,Float:pZ);
        VehicleSpeed[vehicleid] = floatsqroot( floatpower(floatabs(floatsub(pX, VehicleOldX[vehicleid])),2) + 
                                               floatpower(floatabs(floatsub(pY, VehicleOldY[vehicleid])),2) + 
                                               floatpower(floatabs(floatsub(pZ, VehicleOldZ[vehicleid])),2));

        VehicleSpeed[vehicleid] = floatround(VehicleSpeed[vehicleid] * 5000 / 1600);

        if(VehicleSpeed[vehicleid]<3 || VehicleSpeed[vehicleid]>300)
        {
            VehicleSpeed[vehicleid]=0;
        }

        VehicleOldX[vehicleid] = floatround(pX);
        VehicleOldY[vehicleid] = floatround(pY);
        VehicleOldZ[vehicleid] = floatround(pZ);


        // UPDATE FUEL
        new VehicleLostFuel;

        if(VehicleSpeed[vehicleid] < 10)
        {
            VehicleLostFuel = 0;
        }
        else if(VehicleSpeed[vehicleid] < 35)
        {
            VehicleLostFuel = 1;
        }
        else if(VehicleSpeed[vehicleid] < 70)
        {
            VehicleLostFuel = 2;
        }
        else if(VehicleSpeed[vehicleid] < 140)
        {
            VehicleLostFuel = 3;
        }
        else if(VehicleSpeed[vehicleid] < 180)
        {
            VehicleLostFuel = 4;
        }
        else
        {
            VehicleLostFuel = 5;
        }
        
        if(IsAtGasStation(playerid))
        {
            if(VehicleFuel[vehicleid] > MAX_FUEL)
            {
                VehicleFuel[vehicleid] = MAX_FUEL;
                SendClientMessage(playerid, COLOR_LIGHTBLUE, "This car can't be refueled because the tank is already full !");
            }
            else if(GetPlayerMoney(playerid) < REFUEL_COST)
            {
                SendClientMessage(playerid, COLOR_LIGHTBLUE, "You dont have money to refuel your car !");
            }
            else
            {
                GivePlayerCash(playerid, -REFUEL_COST);
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You paid $%d for the refuel! {6666AA}Thanks for the purchase!", REFUEL_COST);
                VehicleFuel[GetPlayerVehicleID(playerid)] = VehicleFuel[GetPlayerVehicleID(playerid)] + REFUEL_VALUE;
            }
        }
        else 
        {
            VehicleFuel[vehicleid] = VehicleFuel[vehicleid] - VehicleLostFuel;
            if (VehicleFuel[vehicleid] <= 0)
            {
                VehicleFuel[vehicleid] = 0;
                RemovePlayerFromVehicle(playerid);
                SendClientMessage(playerid, COLOR_LIGHTBLUE, " This car has no fuel !");
                continue;
            }
        }

        new fuel_indicator = (VehicleFuel[vehicleid] * 10) / MAX_FUEL;
        if(fuel_indicator < 0)
        {
            fuel_indicator = 0;
        }
        if(fuel_indicator > 10)
        {
            fuel_indicator = 10;
        }
        
        new indicator[128];
        if(PlayerData[playerid][pSpeedometer] == 2)
        {
            format(indicator, sizeof(indicator),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~MP/H: ~w~%0.0f ", VehicleSpeed[vehicleid] / 62.1371);
        }
        else
        {
            format(indicator, sizeof(indicator),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~KM/H: ~w~%0.0f ", VehicleSpeed[vehicleid]);
        }

        if(fuel_indicator > 0)
        {
            format(indicator, sizeof(indicator), "%s ~g~", indicator);
        }
        for(new i=0;i<fuel_indicator;i++)
        {
            format(indicator, sizeof(indicator), "%sI", indicator);
        }
        format(indicator, sizeof(indicator), "%s~l~", indicator);
        for(new i=fuel_indicator;i<10;i++)
        {
            format(indicator, sizeof(indicator), "%sI", indicator);
        }
        
        if(VehicleLostFuel > 0)
        {
            format(indicator, sizeof(indicator), "%s ~r~", indicator);
        }
        else
        {
            format(indicator, sizeof(indicator), "%s ", indicator);
        }
        for(new i=0;i<VehicleLostFuel;i++)
        {
            format(indicator, sizeof(indicator), "%sI", indicator);
        }
        format(indicator, sizeof(indicator), "%s~l~", indicator);
        for(new i=VehicleLostFuel;i<5;i++)
        {
            format(indicator, sizeof(indicator), "%sI", indicator);
        }
        GameTextForPlayer(playerid, indicator, 2500, 3);
    }

    return 1;
}


IsAtGasStation(playerid)
{
    for(new index = 0; index < sizeof(RefuelPositions); index++)
    {
        if(PlayerToPoint(6.0, playerid, RefuelPositions[index][0], RefuelPositions[index][1], RefuelPositions[index][2]))
        {
            return true;
        }
    }
    return false;
}

GetVehicleFuel(vehicleid)
{
    return VehicleFuel[vehicleid];
}

SetVehicleFuel(vehicleid, value)
{
    VehicleFuel[vehicleid] = value;
}

RefuelVehicle(vehicleid)
{
    VehicleFuel[vehicleid] = MAX_FUEL;
    return 1;
}

CMD:refuel(playerid, params[])
{
    return callcmd::gascan(playerid, params);
}
CMD:gascan(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), amount;

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");
	}
	if(!IsEngineVehicle(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which runs off gas.");
	}
	if(sscanf(params, "i", amount))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gascan [amount]");
	}
	if(amount < 1 || amount > PlayerData[playerid][pGasCan])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
	}
	if(VehicleFuel[vehicleid] + amount > 100)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't add that much gasoline to the vehicle.");
	}

	PlayerData[playerid][pGasCan] -= amount;
	VehicleFuel[vehicleid] += amount;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", PlayerData[playerid][pGasCan], PlayerData[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	ShowActionBubble(playerid, "* %s refills the %s's gas tank with %i liters of gasoline.", GetRPName(playerid), GetVehicleName(vehicleid), amount);
	return 1;
}


IsBiciyle(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
        {
        if(GetVehicleModel(GetPlayerVehicleID(playerid))== 481) return 1;
        else if(GetVehicleModel(GetPlayerVehicleID(playerid))== 509) return 1;
        else if(GetVehicleModel(GetPlayerVehicleID(playerid))== 510) return 1;
        else return 0;
        }
    return 1;
}

PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new Float:tempposx, Float:tempposy, Float:tempposz;
    GetPlayerPos(playerid, oldposx, oldposy, oldposz);
    tempposx = (oldposx -x);
    tempposy = (oldposy -y);
    tempposz = (oldposz -z);
    if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
    {
        return 1;
    }
    return 0;
}