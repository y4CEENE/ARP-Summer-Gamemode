/// @file      Atm.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum e_ATM
{
    atmID,
    atmExists,
    Float:atmSpawn[4],
    atmInterior,
    atmWorld,
    atmObject,
    Text3D:atmText
};
new ATM[MAX_ATMS][e_ATM];
