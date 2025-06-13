/// @file      Payphone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum {
    PhoneNumber_None      = 0,
    PhoneNumber_Emergency = 911,
    PhoneNumber_Police    = 912,
    PhoneNumber_Medic     = 913,
    PhoneNumber_Taxi      = 6324,
    PhoneNumber_News      = 6397,
    PhoneNumber_Mechanic  = 8294,
};

enum e_Payphones {
    phID,
    phExists,
    phNumber,
    phOccupied,
    phCaller,
    Float:phX,
    Float:phY,
    Float:phZ,
    Float:phA,
    phInterior,
    phWorld,
    phObject,
    Text3D:phText
};

new Payphones[MAX_PAYPHONES][e_Payphones];
