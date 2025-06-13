/// @file      Property.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


enum PropertyType
{
    PropertyType_Unknown,
    PropertyType_Vehicle,
    PropertyType_House,
    PropertyType_Land,
    PropertyType_Garage,
    PropertyType_Entrance,
};

enum KeyAccess
{
    KeyAccess_None             =   0,
    KeyAccess_Doors            =   1,
    KeyAccess_TakeFromStorage  =   2,
    KeyAccess_PutInStorage     =   4,
    KeyAccess_Edit             =   8,
    KeyAccess_Sell             =  16,
    KeyAccess_TauntStorage     =  32,
};

enum {
    KeyRole_Unauthorized = KeyAccess_None,
    KeyRole_Owner        = KeyAccess_Doors | KeyAccess_Edit | KeyAccess_PutInStorage | KeyAccess_TakeFromStorage | KeyAccess_Sell,
    KeyRole_Editor       = KeyAccess_Doors | KeyAccess_Edit | KeyAccess_PutInStorage,
    KeyRole_Member       = KeyAccess_Doors | KeyAccess_PutInStorage | KeyAccess_TakeFromStorage,
    KeyRole_Tenant       = KeyAccess_Doors | KeyAccess_TauntStorage,
    KeyRole_Visitor      = KeyAccess_Doors,
};
