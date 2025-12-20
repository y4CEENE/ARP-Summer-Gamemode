#include <YSI\y_hooks>

static IsWorkingAirport[MAX_PLAYERS];
static HasBoxCount[MAX_PLAYERS];
static AirportDeliveryPoint[MAX_PLAYERS];
static CarryingBox[MAX_PLAYERS];
static TrailerVehicleID[MAX_PLAYERS];
static TotalBoxesLoaded[MAX_PLAYERS];

#define MAX_BOXES 6

new Float:AirplaneLocation[3] = {1614.420532, -2488.638916, 13.554687};

new Float:DeliveryCoords[3][3] = {
    {1959.1571, -2285.4966, 13.5469},
    {1942.4399, -2285.5991, 13.5469},
    {1925.7230, -2285.6992, 13.5469}
};

new BoxObjects[MAX_VEHICLES][MAX_BOXES];

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Airport Agency Job\nUse /getbox to load trailer", COLOR_YELLOW, 1614.420532, -2488.638916, 13.554687, 20.0);
    CreateDynamicObject(3663, 1614.420532, -2488.638916, 13.554687, 0.0, 0.0, 179.20);
    return 1;
}

hook OnPlayerInit(playerid)
{
    IsWorkingAirport[playerid] = 0;
    HasBoxCount[playerid] = 0;
    AirportDeliveryPoint[playerid] = -1;
    CarryingBox[playerid] = 0;
    TrailerVehicleID[playerid] = INVALID_VEHICLE_ID;
    TotalBoxesLoaded[playerid] = 0;
}

hook OnPlayerUpdate(playerid)
{
    if (CarryingBox[playerid])
    {
        new vehicleid = GetNearbyVehicle(playerid);
        if (vehicleid != INVALID_VEHICLE_ID)
        {
            if (GetVehicleModel(vehicleid) == 606)
            {
                if (IsPlayerInRangeOfBoot(playerid, vehicleid))
                {
                    RemovePlayerAttachedObject(playerid, 9);
                    ClearAnimations(playerid);

                    CarryingBox[playerid] = 0;
                    TotalBoxesLoaded[playerid]++;
                    TrailerVehicleID[playerid] = vehicleid;

                    BoxObjects[vehicleid][TotalBoxesLoaded[playerid] - 1] = 1;

                    SendClientMessageEx(playerid, COLOR_AQUA, "Box loaded into the trailer, Now you have %d loaded.", TotalBoxesLoaded[playerid]);

                    if (TotalBoxesLoaded[playerid] >= MAX_BOXES)
                    {
                        new rand = random(sizeof(DeliveryCoords));
                        AirportDeliveryPoint[playerid] = rand;

                        SetPlayerCheckpoint(playerid,
                            DeliveryCoords[rand][0],
                            DeliveryCoords[rand][1],
                            DeliveryCoords[rand][2], 5.0);

                        SendClientMessage(playerid, COLOR_AQUA, "All boxes loaded! Now drive the trailer to the marked checkpoint.");
                        GameTextForPlayer(playerid, "~g~All Boxes Loaded!", 3000, 3);
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                    }
                    else
                    {
                        SendClientMessage(playerid, COLOR_AQUA, "Go back to the airplane to get another box.");
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                    }
                }
            }
        }
    }
    return 1;
}

CMD:getbox(playerid, params[])
{
    if (CarryingBox[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are already carrying a box.");

    if (IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GREY, "You must be on foot to pick up boxes.");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, AirplaneLocation[0], AirplaneLocation[1], AirplaneLocation[2]))
        return SendClientMessage(playerid, COLOR_GREY, "You are not near the airplane to collect boxes.");

    if (TotalBoxesLoaded[playerid] >= MAX_BOXES)
        return SendClientMessage(playerid, COLOR_GREY, "You already loaded all boxes. Drive to the checkpoint!");

    IsWorkingAirport[playerid] = 1;
    CarryingBox[playerid] = 1;

    //SetPlayerAttachedObject(playerid, 9, 2912, 6, 0.3, 0.5, 0.0, 0.0, 90.0, 0.0);
    SetPlayerAttachedObject(playerid, 9, 2912, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    //ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

    SendClientMessage(playerid, COLOR_AQUA, "You picked up a box. Go to the baggage trailer to load it.");
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (IsWorkingAirport[playerid] && AirportDeliveryPoint[playerid] != -1)
    {
        if (TotalBoxesLoaded[playerid] >= MAX_BOXES)
        {
            new totalReward = random(10000) + 15000;
            GivePlayerCash(playerid, totalReward);

            if (TrailerVehicleID[playerid] != INVALID_VEHICLE_ID)
            {
                for (new i = 0; i < MAX_BOXES; i++)
                {
                    BoxObjects[TrailerVehicleID[playerid]][i] = 0;
                }
            }

            IsWorkingAirport[playerid] = 0;
            AirportDeliveryPoint[playerid] = -1;
            TrailerVehicleID[playerid] = INVALID_VEHICLE_ID;
            TotalBoxesLoaded[playerid] = 0;
            DisablePlayerCheckpoint(playerid);

            SendClientMessageEx(playerid, COLOR_AQUA, "Job complete! You delivered all boxes and earned $%i!", totalReward);
            GameTextForPlayer(playerid, "~g~Job Complete!", 3000, 3);
        }
    }
    return 1;
}

CMD:vehicleco(playerid, params[])
{
    new vehicleid;
    if (sscanf(params, "d", vehicleid))
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /vehicleco [vehicleid]");

    if (vehicleid < 1 || vehicleid >= MAX_VEHICLES)
        return SendClientMessage(playerid, COLOR_GREY, "Invalid vehicle ID.");

    new Float:x, Float:y, Float:z, Float:angle;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);

    SendClientMessageEx(playerid, COLOR_YELLOW, "Vehicle ID %d Position:", vehicleid);
    SendClientMessageEx(playerid, COLOR_AQUA, "X: %f, Y: %f, Z: %f, Angle: %f", x, y, z, angle);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Code: {%f, %f, %f}", x, y, z);
    
    return 1;
}