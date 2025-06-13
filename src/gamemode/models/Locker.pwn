/// @file      Locker.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum lkEnum
{
    lID,
    lExists,
    lFaction,
    Float:lPosX,
    Float:lPosY,
    Float:lPosZ,
    lInterior,
    lWorld,
    lLabel,
    lIcon,
    locKevlar[2],
    locMedKit[2],
    locNitestick[2],
    locMace[2],
    locDeagle[2],
    locShotgun[2],
    locMP5[2],
    locM4[2],
    locSpas12[2],
    locSniper[2],
    locCamera[2],
    locFireExt[2],
    locPainKillers[2],
    Text3D:lText,
    lPickup
};

new LockerInfo[MAX_LOCKERS][lkEnum];
