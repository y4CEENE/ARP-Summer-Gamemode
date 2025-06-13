#include <YSI\y_hooks>
// Based on 'VSync v0.03 wrote by RIDE2DAY'

// ================================== [DEFINITIONS] ================================== //
#if !defined isodd
    #define isodd(%1)            ((%1) & 1)
#endif

#define NEON_LIGHT_RED           18647
#define NEON_LIGHT_BLUE          18648
#define NEON_LIGHT_GREEN         18649
#define NEON_LIGHT_YELLOW        18650
#define NEON_LIGHT_PINK          18651
#define NEON_LIGHT_WHITE         18652

#define MAX_VEHICLE_NUMBERPLATE  32
#define INVALID_PAINTJOB_ID      3


forward OnVehicleCreated(vehicleid);
forward OnVehicleChangePaintjob(playerid, vehicleid, paintjobid);


// ================================== [VARIABLES] ================================== //
enum ePlayerVehicleSync {
    PVSync_Tick,
    PVSync_PaySprayTick,
    PVSync_PaintjobID,
    PVSync_BuyingPaintjob,
    PVSync_InsideModShop,
};
static VSyncPlayer[MAX_PLAYERS][ePlayerVehicleSync];

enum VSync_VehicleParams
{
    VEHICLE_TYPE_ENGINE,
    VEHICLE_TYPE_LIGHTS,
    VEHICLE_TYPE_ALARM,
    VEHICLE_TYPE_DOORS,
    VEHICLE_TYPE_BONNET,
    VEHICLE_TYPE_BOOT,
    VEHICLE_TYPE_OBJECTIVE
}

enum VSync_Internal_Data
{
    Float:VSync_OldHP,
    VSync_Color1,
    VSync_Color2,
    VSync_OrgCol1,
    VSync_OrgCol2,
    VSync_Paintjob,
    VSync_Interior,
    VSync_NumberP[MAX_VEHICLE_NUMBERPLATE],
    VSync_Siren,
    VSync_Stereo,
    VSync_Bumpers[2],
    VSync_Bullbars[2],
    VSync_Neon[2]
}
static VehicleSyncData[MAX_VEHICLES][VSync_Internal_Data];

static const DefaultVehicleColors[MAX_VEHICLES_MODELS][19] = {
    {16,4,1,123,1,113,1,101,1,75,1,62,1,40,1,36,1},                 // Landstalker
    {16,41,41,47,47,52,52,66,66,74,74,87,87,91,91,113,113},         // Bravura
    {16,10,10,13,13,22,22,30,30,39,39,90,90,98,98,110,110},         // Buffalo
    {16,36,1,37,1,30,1,28,1,25,1,40,1,101,1,113,1},                 // Linerunner
    {16,113,39,119,50,123,92,109,100,101,101,95,105,83,110,66,25},     // Perennial
    {16,11,1,24,1,36,1,40,1,75,1,91,1,123,1,4,1},                     // Sentinel
    {2,1,1},                                                         // Dumper
    {2,3,1},                                                         // Firetruck
    {2,26,26},                                                         // Trashmaster
    {2,1,1},                                                         // Stretch
    {16,4,1,9,1,10,1,25,1,36,1,40,1,45,1,84,1},                     // Manana
    {16,12,1,64,1,123,1,116,1,112,1,106,1,80,1,75,1},                 // Infernus
    {16,9,1,10,8,11,1,25,8,27,1,29,8,30,1,37,8},                     // Voodoo
    {16,87,1,88,1,91,1,105,1,109,1,119,1,4,1,25,1},                 // Pony
    {16,25,1,28,1,43,1,67,1,72,1,9,1,95,1,24,1},                     // Mule
    {16,20,1,25,1,36,1,40,1,62,1,75,1,92,1,0,1},                     // Cheetah
    {2,1,3},                                                         // Ambulance
    {2,0,0},                                                         // Leviathan
    {16,119,119,117,227,114,114,108,108,95,95,81,81,61,61,41,41},     // Moonbeam
    {16,45,75,47,76,33,75,13,76,54,75,69,76,59,75,87,76},             // Esperanto
    {2,6,1},                                                         // Taxi
    {16,4,1,13,1,25,1,30,1,36,1,40,1,75,1,95,1},                     // Washington
    {14,96,25,97,25,101,25,111,31,113,36,83,57,67,59},                 // Bobcat
    {12,1,16,1,56,1,17,1,53,1,5,1,35},                                 // Mr Whoopee
    {16,1,0,2,2,3,2,3,6,6,16,15,30,24,53,35,61},                     // BF Injection
    {2,43,0},                                                         // Hunter
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Premier
    {2,0,1},                                                         // Enforcer
    {2,4,75},                                                         // Securicar
    {16,12,12,13,13,14,14,1,2,2,1,1,3,3,1,10,10},                     // Banshee
    {2,46,26},                                                         // Predator
    {16,71,59,75,59,92,72,47,74,55,83,59,83,71,87,82,87},             // Bus
    {2,43,0},                                                         // Rhino
    {2,43,0},                                                         // Barracks
    {14,1,1,12,12,2,2,6,6,4,4,46,46,53,53},                         // Hotknife
    {2,1,1},                                                         // Trailer 1
    {14,83,1,87,1,92,1,95,1,109,1,119,45,11,1},                     // Previon
    {16,54,7,79,7,87,7,95,16,98,20,105,20,123,20,125,21},             // Coach
    {2,6,76},                                                         // Cabbie
    {16,57,8,8,17,43,21,54,38,67,8,37,78,65,79,25,78},                 // Stallion
    {16,34,34,32,32,20,20,110,110,66,66,84,84,118,118,121,121},     // Rumpo
    {16,2,96,79,42,82,54,67,86,126,96,70,96,110,54,67,98},             // RC Bandit
    {16,0,0,11,105,25,109,36,0,40,36,75,36,0,36,0,109},             // Romero
    {16,4,1,20,1,24,1,25,1,36,1,40,1,54,1,84,1},                     // Packer
    {12,32,36,32,42,32,53,32,66,32,14,32,32},                         // Monster
    {16,34,34,35,35,37,37,39,39,41,41,43,43,45,45,47,47},             // Admiral
    {0},                                                             // Squalo
    {2,75,2},                                                         // Seasparrow
    {2,3,6},                                                         // Pizzaboy
    {2,1,74},                                                         // Tram
    {2,1,1},                                                         // Trailer 2
    {16,123,123,125,125,36,36,16,16,18,18,46,46,61,61,75,75},         // Turismo
    {16,1,3,1,5,1,16,1,22,1,35,1,44,1,53,1,57},                     // Speeder
    {2,56,56},                                                         // Reefer
    {2,26,26},                                                         // Tropic
    {16,84,15,84,58,84,31,32,74,43,31,1,31,77,31,32,74},             // Flatbed
    {16,84,63,91,63,102,65,105,72,110,93,121,93,12,95,23,1},         // Yankee
    {16,58,1,2,1,63,1,18,1,32,1,45,1,13,1,34,1},                     // Caddy
    {16,91,1,101,1,109,1,113,1,4,1,25,1,30,1,36,1},                 // Solair
    {16,26,26,28,28,44,44,51,51,57,57,72,72,106,106,112,112},         // Berkley's RC Van
    {16,1,3,1,9,1,18,1,30,17,23,46,23,46,32,57,34},                 // Skimmer
    {16,36,1,37,1,43,1,53,1,61,1,75,1,79,1,88,1},                     // PCJ-600
    {16,12,12,13,13,14,14,1,2,2,1,1,3,3,1,10,10},                     // Faggio
    {16,79,79,84,84,7,7,11,11,19,19,22,22,36,36,53,53},             // Freeway
    {2,14,75},                                                         // RC Baron
    {2,14,75},                                                         // RC Raider
    {16,67,76,68,76,78,76,2,76,16,76,18,76,25,76,45,88},             // Glendale
    {16,51,1,58,8,60,1,68,8,2,1,13,8,22,1,36,8},                     // Oceanic
    {8,6,6,46,46,53,53,3,3},                                         // Sanchez
    {2,1,3},                                                         // Sparrow
    {2,43,0},                                                         // Patriot
    {16,120,117,103,111,120,114,74,91,120,112,74,83,120,113,66,71}, // Quad
    {4,56,15,56,53},                                                 // Coastguard
    {4,56,15,56,53},                                                 // Dinghy
    {16,97,1,81,1,105,1,110,1,91,1,74,1,84,1,83,1},                 // Hermes
    {16,2,39,9,39,17,1,21,1,33,0,37,0,41,29,56,29},                 // Sabre
    {16,6,7,7,6,1,6,89,91,119,117,103,102,77,87,71,77},             // Rustler
    {16,92,1,94,1,101,1,121,1,0,1,22,1,36,1,75,1},                     // ZR-350
    {16,72,1,66,1,59,1,45,1,40,1,39,1,35,1,20,1},                     // Walton
    {16,27,36,59,36,60,35,55,41,54,31,49,23,45,32,40,29},             // Regina
    {14,73,45,12,12,2,2,6,6,4,4,46,46,53,53},                         // Comet
    {16,1,1,3,3,6,6,46,46,65,9,14,1,12,9,26,1},                     // BMX
    {16,41,41,48,48,52,52,64,64,71,71,85,85,10,10,62,62},             // Burrito
    {0},                                                             // Camper
    {8,12,35,50,32,40,26,66,36},                                     // Marquis
    {14,1,73,1,74,1,75,1,76,1,77,1,78,1,79},                         // Baggage
    {2,1,1},                                                         // Dozer
    {16,26,14,29,42,26,57,54,29,26,3,3,29,12,39,74,35},             // Maverick
    {4,2,26,2,29},                                                     // News Chopper
    {12,13,118,14,123,120,123,112,120,84,110,76,102},                 // Rancher
    {2,0,0},                                                         // FBI Rancher
    {12,40,65,71,72,52,66,64,72,30,72,60,72},                         // Virgo
    {16,30,26,77,26,81,27,24,55,28,56,49,59,52,69,71,107},             // Greenwood
    {2,36,13},                                                         // Jetmax
    {16,36,117,36,13,42,30,42,33,54,36,75,79,92,101,98,109},         // Hotring
    {16,123,124,119,122,118,117,116,115,114,108,101,106,88,99,5,6}, // Sandking
    {16,74,72,66,72,53,56,37,19,22,22,20,20,9,14,0,0},                 // Blista Compact
    {2,0,1},                                                         // Police Maverick
    {16,11,123,13,120,20,117,24,112,27,107,36,105,37,107,43,93},     // Boxville
    {16,109,25,109,32,112,32,10,32,30,44,32,52,84,66,84,69},         // Benson
    {16,75,84,40,84,40,110,28,119,25,119,21,119,13,119,4,119},         // Mesa
    {2,14,75},                                                         // RC Goblin
    {16,7,94,36,88,51,75,53,75,58,67,75,67,75,61,79,62},             // Hotring Racer A
    {16,83,66,87,74,87,75,98,83,101,100,103,101,117,116,123,36},     // Hotring Racer B
    {16,51,39,57,38,45,29,34,9,65,9,14,1,12,9,26,1},                 // Bloodring Banger
    {12,13,118,14,123,120,123,112,120,84,110,76,102},                 // Rancher Lure
    {10,3,3,6,6,7,7,52,52,76,76},                                     // Super GT
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Elegant
    {2,1,1},                                                         // Journey
    {16,7,1,74,1,61,1,16,1,25,1,30,1,36,1,53,1},                     // Bike
    {16,43,43,46,46,39,39,28,28,16,16,6,6,5,5,2,2},                 // Mountain Bike
    {16,3,90,4,90,7,68,8,66,12,60,27,97,34,51,37,51},                 // Beagle
    {16,17,39,15,123,32,112,45,88,52,71,57,67,61,96,96,96},         // Cropdust
    {16,38,51,21,36,21,34,30,34,54,34,55,20,48,18,51,6},             // Stunt
    {16,10,1,25,1,28,1,36,1,40,1,54,1,75,1,113,1},                     // Tanker
    {16,13,76,24,77,63,78,42,76,54,77,39,78,11,76,62,77},             // Roadtrain
    {16,116,1,119,1,122,1,4,1,9,1,24,1,27,1,36,1},                     // Nebula
    {16,37,36,36,36,40,36,43,41,47,41,51,72,54,75,55,84},             // Majestic
    {16,2,39,9,39,17,1,21,1,33,0,37,0,41,29,56,29},                 // Buccaneer
    {2,1,1},                                                         // Shamal
    {0},                                                             // Hydra
    {16,74,74,75,13,87,118,92,3,115,118,25,118,36,0,118,118},         // FCR-900
    {16,3,3,3,8,6,25,7,79,8,82,36,105,39,106,51,118},                 // NRG-500
    {0},                                                             // HPV1000
    {0},                                                             // Cement Truck
    {14,1,1,17,20,18,20,22,30,36,43,44,51,52,54},                     // Tow Truck
    {16,2,39,9,39,17,1,21,1,33,0,37,0,41,29,56,29},                 // Fortune
    {16,52,1,53,1,66,1,75,1,76,1,81,1,95,1,109,1},                     // Cadrona
    {0},                                                             // FBI Truck
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Willard
    {16,110,1,111,1,112,1,114,1,119,1,122,1,4,1,13,1},                 // Forklift
    {12,2,35,36,2,51,53,91,2,11,22,40,35},                             // Tractor
    {0},                                                             // Combine
    {16,73,1,74,1,75,1,77,1,79,1,83,1,84,1,91,1},                     // Feltzer
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Remington
    {16,3,1,28,1,31,1,55,1,66,1,97,1,123,1,118,1},                     // Slamvan
    {16,9,1,12,1,26,96,30,96,32,1,37,1,57,96,71,96},                 // Blade
    {2,1,1},                                                         // Freight
    {2,1,1},                                                         // Streak
    {14,96,67,86,70,79,74,70,86,61,98,75,75,75,91},                 // Vortex
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Vincent
    {16,51,1,58,8,60,1,68,8,2,1,13,8,22,1,36,8},                     // Bullet
    {16,13,118,24,118,31,93,32,92,45,92,113,92,119,113,122,113},     // Clover
    {16,76,8,32,8,43,8,67,8,11,11,8,90,2,2,83,13},                     // Sadler
    {2,3,1},                                                         // Firetruck LA
    {16,50,1,47,1,44,96,40,96,39,1,30,1,28,96,9,96},                 // Hustler
    {16,62,37,78,38,2,62,3,87,2,78,113,78,119,62,7,78},             // Intruder
    {16,122,1,123,1,125,1,10,1,24,1,37,1,55,1,66,1},                 // Primo
    {2,1,1},                                                         // Cargobob
    {16,74,39,72,39,75,39,79,39,83,36,84,36,89,35,91,35},             // Tampa
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Sunrise
    {16,67,1,72,1,75,1,83,1,91,1,101,1,109,1,20,1},                 // Merit
    {6,56,56,49,49,26,124},                                         // Utility
    {16,38,9,55,23,61,74,71,87,91,87,98,114,102,119,111,3},         // Nevada
    {16,53,32,15,32,45,32,34,30,65,32,14,32,12,32,43,32},             // Yosemite
    {16,51,1,58,1,60,1,68,1,2,1,13,1,22,1,36,1},                     // Windsor
    {2,1,1},                                                         // Monster A
    {2,1,1},                                                         // Monster B
    {16,112,1,116,1,117,1,24,1,30,1,35,1,36,1,40,1},                 // Uranus
    {16,51,1,58,8,60,1,68,8,2,1,13,8,22,1,36,8},                     // Jester
    {16,52,39,9,39,17,1,21,1,33,0,37,0,41,29,56,29},                 // Sultan
    {16,57,8,8,17,43,21,54,38,67,8,37,78,65,79,25,78},                 // Stratum
    {16,36,1,35,1,17,1,11,1,116,1,113,1,101,1,92,1},                 // Elegy
    {2,1,6},                                                         // Raindance
    {0},                                                             // RC Tiger
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Flash
    {16,109,1,30,8,95,1,84,8,83,1,72,8,71,1,52,8},                     // Tahoma
    {16,97,96,88,64,90,96,93,64,97,96,99,81,102,114,114,1},         // Savanna
    {16,2,39,9,39,17,1,21,1,33,0,37,0,41,29,56,29},                 // Bandito
    {2,1,1},                                                         // Freight Flat
    {2,1,1},                                                         // Streak Carriage
    {12,2,35,36,2,51,53,91,2,11,22,40,35},                             // Kart
    {16,94,1,101,1,116,1,117,1,4,1,25,1,30,1,37,1},                 // Mower
    {16,91,38,115,43,85,6,79,7,78,8,77,18,79,18,86,24},             // Duneride
    {2,26,26},                                                         // Sweeper
    {16,12,1,19,96,31,64,25,96,38,1,51,96,57,1,66,96},                 // Broadway
    {16,67,1,68,96,72,1,74,8,75,96,76,8,79,1,84,96},                 // Tornado
    {12,1,3,8,7,8,10,8,16,23,31,40,44},                             // AT-400
    {2,1,1},                                                         // DFT-30
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Huntley
    {18,92,92,81,81,67,67,66,66,61,61,53,53,51,51,47,47,43,43},     // Stafford
    {16,54,1,58,1,66,1,72,1,75,1,87,1,101,1,36,1},                     // BF-400
    {16,41,10,41,20,49,11,56,123,110,113,112,116,114,118,119,101},     // Newsvan
    {2,1,1},                                                         // Tug
    {2,1,1},                                                         // Trailer 3
    {16,37,37,42,42,53,53,62,62,7,7,10,10,11,11,15,15},             // Emperor
    {16,119,1,122,1,8,1,10,1,13,1,25,1,27,1,32,1},                     // Wayfarer
    {16,36,1,40,1,43,1,53,1,72,1,75,1,95,1,101,1},                     // Euros
    {2,1,1},                                                         // Hotdog
    {16,37,37,31,31,23,23,22,22,7,7,124,124,114,114,112,112},         // Club
    {0},                                                             // Freight Carriage
    {2,1,1},                                                         // Trailer 3
    {2,1,1},                                                         // Andromada
    {16,51,1,58,8,60,1,68,8,2,1,13,8,22,1,36,8},                     // Dodo
    {0},                                                             // RC Cam
    {2,112,20},                                                     // Launch
    {2,0,1},                                                         // Police Car (LSPD)
    {2,0,1},                                                         // Police Car (SFPD)
    {2,0,1},                                                         // Police Car (LVPD)
    {2,0,1},                                                         // Police Ranger
    {16,81,8,32,8,43,8,67,8,11,11,8,90,2,2,83,13},                     // Picador
    {2,1,1},                                                         // S.W.A.T. Van
    {16,58,1,69,1,75,77,18,1,32,1,45,45,13,1,34,1},                 // Alpha
    {16,58,1,69,1,75,77,18,1,32,1,45,45,13,1,34,1},                 // Phoenix
    {16,67,76,68,76,78,76,2,76,16,76,18,76,25,76,45,88},             // Glendale shit
    {16,61,8,32,8,43,8,67,8,11,11,8,90,2,2,83,13},                     // Sadler shit
    {0},                                                             // Luggage Trailer A
    {0},                                                             // Luggage Trailer B
    {2,1,1},                                                         // Stair Trailer
    {2,36,36},                                                         // Boxville 2
    {0},                                                             // Farm Plow
    {0}                                                             // Utility Trailer
};

// ================================== [HOOKED FUNCTIONS] ================================== //
stock VSync_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{
    // Check vehicle's model ID.
    if (!(400 <= modelid <= 611))
    {
        return INVALID_VEHICLE_ID;
    }

    // Add siren to the Firetruck (ladder variant), by default it's disabled.
    if (modelid == 544)
    {
        addsiren = 1;
    }

    // Generate random colors (if it proceeds)
    if ((color1 == -1 || color2 == -1) && DefaultVehicleColors[modelid - 400][0] != 0)
    {

        new rand_col = random(DefaultVehicleColors[modelid - 400][0]) + 1;

        if (!isodd(rand_col))
        {
            rand_col--;
        }

        if (color1 == -1)
        {
            color1 = DefaultVehicleColors[modelid - 400][rand_col];
        }

        if (color2 == -1)
        {
            color2 = DefaultVehicleColors[modelid - 400][rand_col + 1];
        }
    }

    new vehicleid = CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren);

    // Check vehicle's ID (to avoid using INVALID_VEHICLE_ID as array index).
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        VehicleSyncData[vehicleid][VSync_OldHP]  = 1000.0;
        VehicleSyncData[vehicleid][VSync_Color1] = color1;
        VehicleSyncData[vehicleid][VSync_Color2] = color2;

        VehicleSyncData[vehicleid][VSync_OrgCol1] = color1;
        VehicleSyncData[vehicleid][VSync_OrgCol2] = color2;

        VehicleSyncData[vehicleid][VSync_Paintjob] = INVALID_PAINTJOB_ID;
        VehicleSyncData[vehicleid][VSync_Interior] = 0;

        VehicleSyncData[vehicleid][VSync_Siren] = addsiren;

        VehicleSyncData[vehicleid][VSync_Stereo] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][1] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][1] = 0;

        strcpy(VehicleSyncData[vehicleid][VSync_NumberP], "XYZSR998", MAX_VEHICLE_NUMBERPLATE);

        CallLocalFunction("OnVehicleCreated", "i", vehicleid);
    }
    return vehicleid;
}
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle VSync_CreateVehicle

stock VSync_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2)
{
    // Check vehicle's model ID.
    if (!(400 <= modelid <= 611))
    {
        return INVALID_VEHICLE_ID;
    }

    // Generate random colors (if it proceeds)
    if ((color1 == -1 || color2 == -1) && DefaultVehicleColors[modelid - 400][0] != 0)
    {
        new rand_col = random(DefaultVehicleColors[modelid - 400][0]) + 1;

        if (!isodd(rand_col))
        {
            rand_col--;
        }

        if (color1 == -1)
        {
            color1 = DefaultVehicleColors[modelid - 400][rand_col];
        }

        if (color2 == -1)
        {
            color2 = DefaultVehicleColors[modelid - 400][rand_col + 1];
        }
    }

    new vehicleid = AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2);

    // Check vehicle's ID (to avoid using INVALID_VEHICLE_ID as array index).
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        VehicleSyncData[vehicleid][VSync_OldHP]  = 1000.0;
        VehicleSyncData[vehicleid][VSync_Color1] = color1;
        VehicleSyncData[vehicleid][VSync_Color2] = color2;

        VehicleSyncData[vehicleid][VSync_OrgCol1] = color1;
        VehicleSyncData[vehicleid][VSync_OrgCol2] = color2;

        VehicleSyncData[vehicleid][VSync_Paintjob] = INVALID_PAINTJOB_ID;
        VehicleSyncData[vehicleid][VSync_Interior] = 0;

        VehicleSyncData[vehicleid][VSync_Siren] = 0;

        VehicleSyncData[vehicleid][VSync_Stereo] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][1] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][1] = 0;

        strcpy(VehicleSyncData[vehicleid][VSync_NumberP], "XYZSR998", MAX_VEHICLE_NUMBERPLATE);

        CallLocalFunction("OnVehicleCreated", "i", vehicleid);
    }
    return vehicleid;
}
#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle VSync_AddStaticVehicle

stock VSync_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{
    // Check vehicle's model ID.
    if (!(400 <= modelid <= 611))
    {
        return INVALID_VEHICLE_ID;
    }

    // Add siren to the Firetruck (ladder variant), by default it's disabled.
    if (modelid == 544)
    {
        addsiren = 1;
    }

    // Generate random colors (if it proceeds)
    if ((color1 == -1 || color2 == -1) && DefaultVehicleColors[modelid - 400][0] != 0)
    {
        new rand_col = random(DefaultVehicleColors[modelid - 400][0]) + 1;

        if (!isodd(rand_col))
        {
            rand_col--;
        }

        if (isodd(rand_col))
        {
            rand_col--;
        }

        if (color1 == -1)
        {
            color1 = DefaultVehicleColors[modelid - 400][rand_col];
        }

        if (color2 == -1)
        {
            color2 = DefaultVehicleColors[modelid - 400][rand_col + 1];
        }
    }

    new vehicleid = AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren);

    // Check vehicle's ID (to avoid using INVALID_VEHICLE_ID as array index).
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        VehicleSyncData[vehicleid][VSync_OldHP]  = 1000.0;
        VehicleSyncData[vehicleid][VSync_Color1] = color1;
        VehicleSyncData[vehicleid][VSync_Color2] = color2;

        VehicleSyncData[vehicleid][VSync_OrgCol1] = color1;
        VehicleSyncData[vehicleid][VSync_OrgCol2] = color2;

        VehicleSyncData[vehicleid][VSync_Paintjob] = INVALID_PAINTJOB_ID;
        VehicleSyncData[vehicleid][VSync_Interior] = 0;

        VehicleSyncData[vehicleid][VSync_Siren] = addsiren;

        VehicleSyncData[vehicleid][VSync_Stereo] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][1] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][1] = 0;

        strcpy(VehicleSyncData[vehicleid][VSync_NumberP], "XYZSR998", MAX_VEHICLE_NUMBERPLATE);

        CallLocalFunction("OnVehicleCreated", "i", vehicleid);
    }
    return vehicleid;
}
#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx VSync_AddStaticVehicleEx

stock VSync_SetVehicleNumberPlate(vehicleid, numberplate[])
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        strcpy(VehicleSyncData[vehicleid][VSync_NumberP], numberplate, MAX_VEHICLE_NUMBERPLATE);
        return SetVehicleNumberPlate(vehicleid, numberplate);
    }
    return 0;
}
#if defined _ALS_SetVehicleNumberPlate
    #undef SetVehicleNumberPlate
#else
    #define _ALS_SetVehicleNumberPlate
#endif
#define SetVehicleNumberPlate VSync_SetVehicleNumberPlate

stock VSync_LinkVehicleToInterior(vehicleid, interior)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        VehicleSyncData[vehicleid][VSync_Interior] = interior;
        return LinkVehicleToInterior(vehicleid, interior);
    }
    return 0;
}
#if defined _ALS_LinkVehicleToInterior
    #undef LinkVehicleToInterior
#else
    #define _ALS_LinkVehicleToInterior
#endif
#define LinkVehicleToInterior VSync_LinkVehicleToInterior

stock VSync_ChangeVehicleColor(vehicleid, color1, color2)
{
    new modelid = GetVehicleModel(vehicleid);

    if (!(400 <= modelid <= 611))
    {
        return 0;
    }

    // Generate random colors (if it proceeds)
    if ((color1 == -1 || color2 == -1) && DefaultVehicleColors[modelid - 400][0] != 0)
    {
        new rand_col = random(DefaultVehicleColors[modelid - 400][0]) + 1;

        if (!isodd(rand_col))
        {
            rand_col--;
        }

        if (color1 == -1)
        {
            color1 = DefaultVehicleColors[modelid - 400][rand_col];
        }

        if (color2 == -1)
        {
            color2 = DefaultVehicleColors[modelid - 400][rand_col + 1];
        }
    }

    VehicleSyncData[vehicleid][VSync_Color1] = color1;
    VehicleSyncData[vehicleid][VSync_Color2] = color2;

    return ChangeVehicleColor(vehicleid, VehicleSyncData[vehicleid][VSync_Color1], VehicleSyncData[vehicleid][VSync_Color2]);
}
#if defined _ALS_ChangeVehicleColor
    #undef ChangeVehicleColor
#else
    #define _ALS_ChangeVehicleColor
#endif
#define ChangeVehicleColor VSync_ChangeVehicleColor

stock VSync_ChangeVehiclePaintjob(vehicleid, paintjobid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        VehicleSyncData[vehicleid][VSync_Paintjob] = paintjobid;
        ChangeVehiclePaintjob(vehicleid, VehicleSyncData[vehicleid][VSync_Paintjob]);
        ChangeVehicleColor(vehicleid, VehicleSyncData[vehicleid][VSync_Color1], VehicleSyncData[vehicleid][VSync_Color2]);
        return 1;
    }
    return 1;
}
#if defined _ALS_ChangeVehiclePaintjob
    #undef ChangeVehiclePaintjob
#else
    #define _ALS_ChangeVehiclePaintjob
#endif
#define ChangeVehiclePaintjob VSync_ChangeVehiclePaintjob

stock VSync_AddVehicleComponent(vehicleid, componentid)
{
    new modelid = GetVehicleModel(vehicleid);

    if (!modelid || !IsVehicleUpgrade(vehicleid, componentid))
    {
        return 0;
    }

    switch (GetVehicleComponentType(componentid))
    {
        case CARMODTYPE_STEREO:
        {
            VehicleSyncData[vehicleid][VSync_Stereo] = componentid;
        }
        case CARMODTYPE_FRONT_BUMPER:
        {
            VehicleSyncData[vehicleid][VSync_Bumpers][0] = componentid;
        }
        case CARMODTYPE_REAR_BUMPER:
        {
            VehicleSyncData[vehicleid][VSync_Bumpers][1] = componentid;
        }
        case CARMODTYPE_FRONT_BULLBAR:
        {
            VehicleSyncData[vehicleid][VSync_Bullbars][0] = componentid;
        }
        case CARMODTYPE_REAR_BULLBAR:
        {
            VehicleSyncData[vehicleid][VSync_Bullbars][1] = componentid;
        }
    }
    return AddVehicleComponent(vehicleid, componentid);
}
#if defined _ALS_AddVehicleComponent
    #undef AddVehicleComponent
#else
    #define _ALS_AddVehicleComponent
#endif
#define AddVehicleComponent VSync_AddVehicleComponent

stock VSync_RemoveVehicleComponent(vehicleid, componentid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        switch (GetVehicleComponentType(componentid))
        {
            case CARMODTYPE_STEREO:
            {
                VehicleSyncData[vehicleid][VSync_Stereo] = 0;
            }
            case CARMODTYPE_FRONT_BUMPER:
            {
                VehicleSyncData[vehicleid][VSync_Bumpers][0] = 0;
            }
            case CARMODTYPE_REAR_BUMPER:
            {
                VehicleSyncData[vehicleid][VSync_Bumpers][1] = 0;
            }
            case CARMODTYPE_FRONT_BULLBAR:
            {
                VehicleSyncData[vehicleid][VSync_Bullbars][0] = 0;
            }
            case CARMODTYPE_REAR_BULLBAR:
            {
                VehicleSyncData[vehicleid][VSync_Bullbars][1] = 0;
            }
        }
        return RemoveVehicleComponent(vehicleid, componentid);
    }
    return 0;
}
#if defined _ALS_RemoveVehicleComponent
    #undef RemoveVehicleComponent
#else
    #define _ALS_RemoveVehicleComponent
#endif
#define RemoveVehicleComponent VSync_RemoveVehicleComponent

stock VSync_DestroyVehicle(vehicleid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        SetVehicleNeonLights(vehicleid, false);

        VehicleSyncData[vehicleid][VSync_Stereo] = 0;

        VehicleSyncData[vehicleid][VSync_Bumpers][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bumpers][1] = 0;

        VehicleSyncData[vehicleid][VSync_Bullbars][0] = 0;
        VehicleSyncData[vehicleid][VSync_Bullbars][1] = 0;

        return DestroyVehicle(vehicleid);
    }
    return 0;
}
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle VSync_DestroyVehicle

stock VSync_GetVehicleComponentInSlot(vehicleid, slot)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        switch (slot)
        {
            case CARMODTYPE_STEREO:
            {
                return VehicleSyncData[vehicleid][VSync_Stereo];
            }
            case CARMODTYPE_FRONT_BUMPER:
            {
                return VehicleSyncData[vehicleid][VSync_Bumpers][0];
            }
            case CARMODTYPE_REAR_BUMPER:
            {
                return VehicleSyncData[vehicleid][VSync_Bumpers][1];
            }
            case CARMODTYPE_FRONT_BULLBAR:
            {
                return VehicleSyncData[vehicleid][VSync_Bullbars][0];
            }
            case CARMODTYPE_REAR_BULLBAR:
            {
                return VehicleSyncData[vehicleid][VSync_Bullbars][1];
            }
        }
        return GetVehicleComponentInSlot(vehicleid, slot);
    }
    return 0;
}
#if defined _ALS_GetVehicleComponentInSlot
    #undef GetVehicleComponentInSlot
#else
    #define _ALS_GetVehicleComponentInSlot
#endif
#define GetVehicleComponentInSlot VSync_GetVehicleComponentInSlot

// ================================== [HOOKED CALLBACKS] ================================== //
hook OnPlayerConnect(playerid)
{
    VSyncPlayer[playerid][PVSync_InsideModShop] = false;
    VSyncPlayer[playerid][PVSync_BuyingPaintjob] = false;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerUpdate(playerid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new Float:hp;
        GetVehicleHealth(vehicleid, hp);

        if (hp == 1000.0 && VehicleSyncData[vehicleid][VSync_OldHP] < hp &&
           (gettime() - VSyncPlayer[playerid][PVSync_PaySprayTick]) >= 1)
        {
            VSyncPlayer[playerid][PVSync_PaySprayTick] = gettime();

            if (IsPlayerInsidePaySpray(playerid))
            {
                ChangeVehicleColor(vehicleid, VehicleSyncData[vehicleid][VSync_Color1], VehicleSyncData[vehicleid][VSync_Color2]);
                CallLocalFunction("OnVehicleRespray", "dddd", playerid, vehicleid, VehicleSyncData[vehicleid][VSync_Color1], VehicleSyncData[vehicleid][VSync_Color2]);
            }
        }
        VehicleSyncData[vehicleid][VSync_OldHP] = hp;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (IsKeyReleased(KEY_SPRINT, newkeys, oldkeys))
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER &&
            VSyncPlayer[playerid][PVSync_BuyingPaintjob] &&
            GetTickCount() - VSyncPlayer[playerid][PVSync_Tick] > 50 &&
            GetPlayerMoney(playerid) >= 500)
        {
            new vehicleid = GetPlayerVehicleID(playerid);

            VSyncPlayer[playerid][PVSync_BuyingPaintjob] = false;
            new paintjob = VSyncPlayer[playerid][PVSync_PaintjobID];
            VehicleSyncData[vehicleid][VSync_Paintjob] = paintjob;

            CallLocalFunction("OnVehicleChangePaintjob", "ddd", playerid, vehicleid, paintjob);
        }
    }
    else if (IsKeyReleased(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && VSyncPlayer[playerid][PVSync_BuyingPaintjob])
        {
            VSyncPlayer[playerid][PVSync_BuyingPaintjob] = false;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnEnterExitModShop(playerid, enterexit, interiorid)
{
    VSyncPlayer[playerid][PVSync_InsideModShop]  = enterexit; // 1 if the player entered or 0 if they exited
    new vehicleid = GetPlayerVehicleID(playerid);
    new max_passengers = GetVehicleSeats(vehicleid);
    new count_passengers;

    new newVW = 0;
    if (VSyncPlayer[playerid][PVSync_InsideModShop])
        newVW = playerid + 1;

    SetVehicleVirtualWorld(vehicleid, newVW);

    for (new x = 0, t = GetPlayerPoolSize(); x <= t; x++)
    {
        if (IsPlayerConnected(x) && GetPlayerVehicleID(x) == vehicleid)
        {
            count_passengers++;
            SetPlayerVirtualWorld(x, newVW);
            if (count_passengers >= max_passengers)
            {
                break;
            }
        }
    }
    return 1;
}

hook OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    if (paintjobid <= 2 && paintjobid != VehicleSyncData[vehicleid][VSync_Paintjob])
    {
        VSyncPlayer[playerid][PVSync_Tick] = GetTickCount();
        VSyncPlayer[playerid][PVSync_PaintjobID] = paintjobid;
        VSyncPlayer[playerid][PVSync_BuyingPaintjob] = true;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    if (VSyncPlayer[playerid][PVSync_InsideModShop] ||
        (color1 == VehicleSyncData[vehicleid][VSync_Color1] &&
         color2 == VehicleSyncData[vehicleid][VSync_Color2] &&
         !IsPlayerInsidePaySpray(playerid)))
    {
        return Y_HOOKS_BREAK_RETURN_0;
    }

    VehicleSyncData[vehicleid][VSync_Color1] = color1;
    VehicleSyncData[vehicleid][VSync_Color2] = color2;

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnVehicleSpawn(vehicleid)
{
    VehicleSyncData[vehicleid][VSync_Paintjob] = 3;

    VehicleSyncData[vehicleid][VSync_Stereo] = 0;
    VehicleSyncData[vehicleid][VSync_Bumpers][0] = 0;
    VehicleSyncData[vehicleid][VSync_Bumpers][1] = 0;
    VehicleSyncData[vehicleid][VSync_Bullbars][0] = 0;
    VehicleSyncData[vehicleid][VSync_Bullbars][1] = 0;

    ChangeVehicleColor(vehicleid, VehicleSyncData[vehicleid][VSync_OrgCol1], VehicleSyncData[vehicleid][VSync_OrgCol2]);
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnVehicleMod(playerid, vehicleid, componentid)
{
    new modelid = GetVehicleModel(vehicleid);

    if (!IsVehicleUpgrade(modelid, componentid))
    {
        return Y_HOOKS_BREAK_RETURN_0;
    }

    switch (GetVehicleComponentType(componentid))
    {
        case CARMODTYPE_STEREO:
        {
            VehicleSyncData[vehicleid][VSync_Stereo] = componentid;
        }
        case CARMODTYPE_FRONT_BUMPER:
        {
            VehicleSyncData[vehicleid][VSync_Bumpers][0] = componentid;
        }
        case CARMODTYPE_REAR_BUMPER:
        {
            VehicleSyncData[vehicleid][VSync_Bumpers][1] = componentid;
        }
        case CARMODTYPE_FRONT_BULLBAR:
        {
            VehicleSyncData[vehicleid][VSync_Bullbars][0] = componentid;
        }
        case CARMODTYPE_REAR_BULLBAR:
        {
            VehicleSyncData[vehicleid][VSync_Bullbars][1] = componentid;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}


// ================================== [NEW FUNCTIONS] ================================== //

stock GetVehicleColor(vehicleid, &color1, &color2)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        color1 = VehicleSyncData[vehicleid][VSync_Color1];
        color2 = VehicleSyncData[vehicleid][VSync_Color2];
        return 1;
    }
    return 0;
}

stock GetVehiclePaintJob(vehicleid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        return VehicleSyncData[vehicleid][VSync_Paintjob];
    }
    return -1;
}

stock GetVehicleNumberPlate(vehicleid, dest[], len = sizeof(dest))
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        strcpy(dest, VehicleSyncData[vehicleid][VSync_NumberP], len);
    }
    return strlen(dest);
}

stock GetVehicleInterior(vehicleid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        return VehicleSyncData[vehicleid][VSync_Interior];
    }
    return 0;
}

stock GetVehicleSiren(vehicleid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
    {
        return VehicleSyncData[vehicleid][VSync_Siren];
    }
    return 0;
}

stock SetVehicleNeonLights(vehicleid, bool:enable = true, color = NEON_LIGHT_RED)
{
    if (!IsValidVehicle(vehicleid))
    {
        return 0;
    }
    new idx = GetVehicleModel(vehicleid) - 400;

    if (0 <= idx <= 211)
    {
        for (new x = 0; x < 2; x++)
        {
            #if defined _streamer_included
                if (IsValidDynamicObject(VehicleSyncData[vehicleid][VSync_Neon][x]))
                {
                    DestroyDynamicObject(VehicleSyncData[vehicleid][VSync_Neon][x]);
                }
            #else
                if (IsValidObject(VehicleSyncData[vehicleid][VSync_Neon][x]))
                {
                    DestroyObject(VehicleSyncData[vehicleid][VSync_Neon][x]);
                }
            #endif
        }

        if ((NEON_LIGHT_RED <= color <= NEON_LIGHT_WHITE) && enable)
        {
            new Float:x, Float:y, Float:z;
            GetVehicleNeonOffset(vehicleid, x, y, z);
            #if defined _streamer_included
                VehicleSyncData[vehicleid][VSync_Neon][0] = CreateDynamicObject(color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                VehicleSyncData[vehicleid][VSync_Neon][1] = CreateDynamicObject(color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

                AttachDynamicObjectToVehicle(VehicleSyncData[vehicleid][VSync_Neon][0], vehicleid, x, y, z, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(VehicleSyncData[vehicleid][VSync_Neon][1], vehicleid,-x, y, z, 0.0, 0.0, 0.0);
            #else
                VehicleSyncData[vehicleid][VSync_Neon][0] = CreateObject(color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                VehicleSyncData[vehicleid][VSync_Neon][1] = CreateObject(color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

                AttachObjectToVehicle(VehicleSyncData[vehicleid][VSync_Neon][0], vehicleid, x, y, z, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(VehicleSyncData[vehicleid][VSync_Neon][1], vehicleid,-x, y, z, 0.0, 0.0, 0.0);
            #endif
        }
        return 1;
    }
    return 0;
}

stock GetVehicleNeonLightsState(vehicleid)
{
    if (1 <= vehicleid <= MAX_VEHICLES)
     {
        #if defined _streamer_included
            if (IsValidDynamicObject(VehicleSyncData[vehicleid][VSync_Neon][0]) && IsValidDynamicObject(VehicleSyncData[vehicleid][VSync_Neon][1]))
            {
                return 1;
            }
        #else
            if (IsValidObject(VehicleSyncData[vehicleid][VSync_Neon][0]) && IsValidObject(VehicleSyncData[vehicleid][VSync_Neon][1]))
            {
                return 1;
            }
        #endif
    }
    return 0;
}
