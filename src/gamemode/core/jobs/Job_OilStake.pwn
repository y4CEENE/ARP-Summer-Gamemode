#include <a_samp>
#include <float>
#include <YSI\y_hooks>
//#include "core\jobs.def.pwn"

static IsOilstaking[MAX_PLAYERS];
static HasOilStakeCount[MAX_PLAYERS];
static OilStakePoint[MAX_PLAYERS];
static CarryingOil[MAX_PLAYERS];
static bool:UsedLoadOil[MAX_PLAYERS];
static TakeOilCount[MAX_PLAYERS];
new OilVehicle[MAX_PLAYERS];

#define OIL_OBJECT 3633
#define MAX_BARRELS 4
#define INVALID_OIL_VEHICLE -1

new Float:OilDeliveryCoords[3][3] = {
    {61.696861, 1219.670288, 18.846584}, // LV
    {61.696861, 1219.670288, 18.846584},  // OFF
    {61.696861, 1219.670288, 18.846584}  // OFF
};

new OilObjects[MAX_VEHICLES][MAX_BARRELS];

new Float:BarrelAttachOffsets[MAX_BARRELS][4] =
{
    {0.0, -1.2, 0.2, 0.0},
    {0.0, -1.2, 0.2, 0.0},
    {0.0, -1.2, 0.2, 0.0},
    {0.0, -1.2, 0.2, 0.0}
};

stock CleanupOilFromVehicle(vehicleid)
{
    if (vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;

    for (new i = 0; i < MAX_BARRELS; i++)
    {
        if (OilObjects[vehicleid][i] != 0)
        {
            DestroyDynamicObject(OilObjects[vehicleid][i]);
            OilObjects[vehicleid][i] = 0;
        }
    }
    return 1;
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Type /oilstake\nto start delivering", COLOR_YELLOW, 566.152221, 1320.542846, 10.035233, 20.0);
    CreateDynamic3DTextLabel("Type /loadoil\nto loading oil", COLOR_YELLOW, 576.359436, 1314.908203, 10.376722, 20.0);
    CreateDynamicPickup(1239, 1, 576.359436, 1314.908203, 10.376722);

    for (new v = 0; v < MAX_VEHICLES; v++)
        for (new b = 0; b < MAX_BARRELS; b++)
            OilObjects[v][b] = 0;

    return 1;
}

hook OnPlayerInit(playerid)
{
    IsOilstaking[playerid] = 0;
    HasOilStakeCount[playerid] = 0;
    OilStakePoint[playerid] = -1;
    CarryingOil[playerid] = 0;
    UsedLoadOil[playerid] = false;
    TakeOilCount[playerid] = 0;
    OilVehicle[playerid] = INVALID_OIL_VEHICLE;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (OilVehicle[playerid] != INVALID_OIL_VEHICLE)
    {
        CleanupOilFromVehicle(OilVehicle[playerid]);
        OilVehicle[playerid] = INVALID_OIL_VEHICLE;
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    CleanupOilFromVehicle(vehicleid);
    return 1;
}

CMD:oilstake(playerid, params[])
{
    if (IsOilstaking[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You already started the oil stake job!");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 566.152221, 1320.542846, 10.035233))
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the oil stake man.");

    if (!PlayerHasJob(playerid, JOB_OILEXPORTER))
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not in the oil stake job.");

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, COLOR_GREY, "You must be on foot to start this job.");

    IsOilstaking[playerid] = 1;
    HasOilStakeCount[playerid] = 0;
    CarryingOil[playerid] = 0;
    UsedLoadOil[playerid] = false;
    TakeOilCount[playerid] = 0;
    OilVehicle[playerid] = INVALID_OIL_VEHICLE;

    SendClientMessage(playerid, COLOR_AQUA, "You started the Oil Stake job! Go to your vehicle and use /loadoil.");
    return 1;
}

CMD:loadoil(playerid, params[])
{
    if (!IsOilstaking[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You have to start the Oil Stake job. Use /oilstake first.");

    if (UsedLoadOil[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You can only load oil once per job session.");

    if (!PlayerHasJob(playerid, JOB_OILEXPORTER))
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not in the oil stake job.");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 576.359436, 1314.908203, 10.376722))
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the loading oil.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");

    CleanupOilFromVehicle(vehicleid);

    for (new i = 0; i < MAX_BARRELS; i++)
    {
        OilObjects[vehicleid][i] = CreateDynamicObject(OIL_OBJECT, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachDynamicObjectToVehicle(OilObjects[vehicleid][i], vehicleid,
            BarrelAttachOffsets[i][0],
            BarrelAttachOffsets[i][1],
            BarrelAttachOffsets[i][2],
            0.0, 0.0, BarrelAttachOffsets[i][3]);
    }

    HasOilStakeCount[playerid] = MAX_BARRELS;
    UsedLoadOil[playerid] = true;
    OilVehicle[playerid] = vehicleid;

    new rand = random(sizeof(OilDeliveryCoords));
    OilStakePoint[playerid] = rand;

    SetPlayerCheckpoint(playerid,
        OilDeliveryCoords[rand][0],
        OilDeliveryCoords[rand][1],
        OilDeliveryCoords[rand][2], 3.5);

    SendClientMessage(playerid, COLOR_AQUA, "Oil loaded in your trunk. Drive to the checkpoint.");
    GameTextForPlayer(playerid, "~g~Oil Loaded", 3000, 3);
    return 1;
}

CMD:takeoil(playerid, params[])
{
    if (!IsOilstaking[playerid] || HasOilStakeCount[playerid] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "You have no oil stake loaded.");

    if (TakeOilCount[playerid] >= 4)
        return SendClientMessage(playerid, COLOR_GREY, "You already took 4 oil barrels. Job complete.");

    if (!PlayerHasJob(playerid, JOB_OILEXPORTER))
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not in the oil stake job.");

    if (CarryingOil[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are already carrying the oil stake.");

    if (IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GREY, "Exit your vehicle first.");

    if (!IsPlayerInRangeOfPoint(playerid, 6.0,
        OilDeliveryCoords[OilStakePoint[playerid]][0],
        OilDeliveryCoords[OilStakePoint[playerid]][1],
        OilDeliveryCoords[OilStakePoint[playerid]][2]))
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the delivery checkpoint.");

    new vehicleid = GetNearbyVehicle(playerid);
    if (vehicleid == INVALID_VEHICLE_ID || !IsPlayerInRangeOfBoot(playerid, vehicleid))
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the trunk.");

    for (new i = 0; i < MAX_BARRELS; i++)
    {
        if (OilObjects[vehicleid][i] != 0)
        {
            DestroyDynamicObject(OilObjects[vehicleid][i]);
            OilObjects[vehicleid][i] = 0;
            break;
        }
    }

    HasOilStakeCount[playerid]--;
    CarryingOil[playerid] = 1;
    TakeOilCount[playerid]++;
    DisablePlayerCheckpoint(playerid);

    SetPlayerAttachedObject(playerid, 9, 3632, 6, 0.0, 0.3, 0.0, 0.0, 90.0, 0.0);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 1, 1, 0, 0, 1);

    SendClientMessage(playerid, COLOR_AQUA, "You picked up the oil stake. Type /dropoil to deliver it.");
    return 1;
}

CMD:dropoil(playerid, params[])
{
    if (!CarryingOil[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are not carrying any oil stake.");

    if (!PlayerHasJob(playerid, JOB_OILEXPORTER))
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not in the oil stake job.");

    RemovePlayerAttachedObject(playerid, 9);
    ClearAnimations(playerid);

    CarryingOil[playerid] = 0;

    if (HasOilStakeCount[playerid] == 0 || TakeOilCount[playerid] >= 4)
    {
        if (OilVehicle[playerid] != INVALID_OIL_VEHICLE)
        {
            CleanupOilFromVehicle(OilVehicle[playerid]);
            OilVehicle[playerid] = INVALID_OIL_VEHICLE;
        }

        IsOilstaking[playerid] = 0;
        OilStakePoint[playerid] = -1;
        UsedLoadOil[playerid] = false;
        TakeOilCount[playerid] = 0;
        ClearAnimations(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have delivered all oil barrels. Job complete.");
    }

    new reward = random(2000) + 5000;
    GivePlayerCash(playerid, reward);

    SendClientMessageEx(playerid, COLOR_AQUA, "You delivered the oil stake and you got $%i.",reward);
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (IsOilstaking[playerid] && OilStakePoint[playerid] != -1)
    {
        SendClientMessage(playerid, COLOR_AQUA, "Now go behind the trunk and use /takeoil to drop the oil.");
    }
    return 1;
}
