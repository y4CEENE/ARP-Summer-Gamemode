/// @file      VehicleInfo.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum vEnum
{
    vID,
    vOwnerID,
    vOwner[MAX_PLAYER_NAME],
    vModel,
    vPrice,
    vType,
    vPlate[32],
    vTickets,
    gv_iLoadMax,
    pvImpounded,
    vLocked,
    Float:vHealth,
    Float:vPosX,
    Float:vPosY,
    Float:vPosZ,
    Float:vPosA,
    vColor1,
    vColor2,
    vPaintjob,
    vInterior,
    vWorld,
    vNeon,
    vNeonEnabled,
    vTrunk,
    vAlarm,
    vCorp,
    vMods[14],
    vCash,
    vMaterials,
    vWeed,
    vCocaine,
    vHeroin,
    vPainkillers,
    vWeapons[5],
    vGang,
    vFaction,
    vFGDivision,
    vVIP,
    vJob,
    vRespawnDelay,
    vObjects[2],
    vTimer,
    vRank,
    carImpounded,
    carImpoundPrice,
    bool:vForSale,
    vForSalePrice,
    Text3D:vForSaleLabel,
    Float:vMileage,
};

new adminVehicle[MAX_VEHICLES];
new CarWindows[MAX_VEHICLES] = 0;
new IsPlayerSteppingInVehicle[MAX_PLAYERS] = -1;
new seatbelt[MAX_PLAYERS];
new testVehicles[5];
new Text3D:DonatorCallSign[MAX_VEHICLES] = {Text3D:INVALID_3DTEXT_ID, ...};
new Text3D:vehicleCallsign[MAX_VEHICLES] = {Text3D:INVALID_3DTEXT_ID, ...};
new vehicleColors[MAX_VEHICLES][2];
new VehicleInfo[MAX_VEHICLES][vEnum];
new vehicleSiren[MAX_VEHICLES] = {INVALID_OBJECT_ID, ...};
new vehicleStream[MAX_VEHICLES][128];
new pObj[MAX_PLAYERS];
