/// @file      Business.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum
{
    BUSINESS_STORE,
    BUSINESS_GUNSHOP,
    BUSINESS_CLOTHES,
    BUSINESS_GYM,
    BUSINESS_RESTAURANT,
    BUSINESS_AGENCY,
    BUSINESS_BARCLUB,
    BUSINESS_TOOLSHOP,
    BUSINESS_DEALERSHIP
};

enum bEnum
{
    bExists,
    bName[MAX_BUSINESSES_NAME],
    bMessage[128],
    bID,
    bOwnerID,
    bOwner[MAX_PLAYER_NAME],
    bType,
    bDealerShipType,
    bPrice,
    bEntryFee,
    bLocked,
    bItemPrices[21],
    Float:cVehicle[4],
    bTimestamp,
    Float:bPosX,
    Float:bPosY,
    Float:bPosZ,
    Float:bPosA,
    Float:bIntX,
    Float:bIntY,
    Float:bIntZ,
    Float:bIntA,
    bInterior,
    bWorld,
    bOutsideInt,
    bOutsideVW,
    bCash,
    bProducts,
    bMaterials,
    bPickup,
    bDisplayMapIcon,
    bMapIcon,
    Text3D:bText,
    Float: GasPumpPosX[2],
    Float: GasPumpPosY[2],
    Float: GasPumpPosZ[2],
    Float: GasPumpAngle[2],
    Float: GasPumpCapacity[2],
    Float: GasPumpGallons[2],
    GasPumpObjectID[2],
    Text3D: GasPumpInfoTextID[2],
    Text3D: GasPumpSaleTextID[2],
    Float: GasPumpSaleGallons[2],
    Float: GasPumpSalePrice[2],
    GasPumpTimer[2],
    GasPumpVehicleID[2]
};

new BusinessInfo[MAX_BUSINESSES][bEnum];

enum{
    DSCars,
    DSBoats,
    DSPlanes
}


enum bizInt
{
    intType[24],
    intPrice,
    intID,
    Float:intX,
    Float:intY,
    Float:intZ,
    Float:intA
};

new const bizInteriors[][bizInt] =
{
    {"Supermarket",           2500000, 6, -27.4377, -57.6114, 1003.5469, 0.0000},
    {"Gun Shop",              2500000, 6,  316.2873, -169.6470, 999.6010, 0.0000},
    {"Clothes Shop",          1500000, 14, 204.3860, -168.4586, 1000.5234, 0.0000},
    {"Gym",                   1500000, 5,  772.4077, -4.7408, 1000.7291, 0.0000},
    {"Restaurant",            1000000, 10, 363.3276, -74.6505, 1001.5078, 315.0000},
    {"Advertisement Agency",  2500000, 3,  834.1517, 7.4096, 1004.1870, 90.0000},
    {"Club/Bar",              1000000, 11, 501.8694, -68.0046, 998.7578, 179.6117},
    {"Tool Shop",             2500000, 6, -2240.6992, 128.3009, 1035.4141, 270.0000},
    {"Dealership",          100000000, 3,  1494.4321, 1304.0353, 1093.2891, 0.0000}
};
