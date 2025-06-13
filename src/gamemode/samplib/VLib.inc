
#define MAX_VEHICLES_MODELS (212)
#define MAX_VEHICLE_NAME    (27)

#define VEHICLE_MODSHOP_NONE            (0)
#define VEHICLE_MODSHOP_TRANSFENDER     (1)
#define VEHICLE_MODSHOP_LOCOLOWCO       (2)
#define VEHICLE_MODSHOP_WHEELARCHANGELS (3)
#define FIRST_VEHICLE_MODEL_ID          (400)
#define LAST_VEHICLE_MODEL_ID           (611)

enum
{
    VEHICLE_ENGINE,
    VEHICLE_LIGHTS,
    VEHICLE_ALARM,
    VEHICLE_DOORS,
    VEHICLE_BONNET,
    VEHICLE_BOOT,
    VEHICLE_OBJECTIVE
};

enum VehicleDoorType
{
    VehicleDoorType_Driver,
    VehicleDoorType_Passenger
};

enum eVLib_VehicleInfo
{
    VLib_Name[MAX_VEHICLE_NAME],
    VLib_Seats,
    VLib_Windows,
    Float:VLib_Mass,
    VLib_DriveType,
    VLib_HasEngine,
    VLib_EngineType,
    VLib_MaxSpeed,
    VLib_ModShop,
    bool:VLib_Nitro,
    Float:VLib_NeonOffsetX,
    Float:VLib_NeonOffsetY,
    Float:VLib_NeonOffsetZ
};

static const VLib_VehicleInfo[MAX_VEHICLES_MODELS][eVLib_VehicleInfo] = {
    {"Landstalker",               4, 4,  1700.0, '4', 1, 'D', 159, 1, true,  -0.924996, 0.009998, -0.674996},
    {"Bravura",                   2, 2,  1300.0, 'F', 1, 'P', 148, 1, true,  -0.979999, 0.074997, -0.489998},
    {"Buffalo",                   2, 2,  1500.0, 'R', 1, 'P', 188, 1, true,  -1.034999, -0.029998, -0.579999},
    {"Linerunner",                2, 2,  3800.0, 'R', 1, 'D', 111, 0, true,  -0.884998, 1.834998, -1.099997},
    {"Perennial",                 4, 4,  1200.0, 'F', 1, 'P', 134, 0, true,  -0.839999, -0.064998, -0.419999},
    {"Sentinel",                  4, 4,  1600.0, 'R', 1, 'P', 165, 1, true,  -0.914999, 0.000000, -0.534999},
    {"Dumper",                    1, 1, 20000.0, 'R', 1, 'D', 111, 0, true,  -1.129999, 0.354999, -1.219998},
    {"Firetruck",                 2, 2,  6500.0, 'R', 1, 'D', 150, 0, true,  -1.214998, 0.125000, -0.759998},
    {"Trashmaster",               2, 2,  5500.0, 'R', 1, 'D', 101, 0, true,  -0.664999, 0.709999, -0.889998},
    {"Stretch",                   4, 4,  2200.0, 'R', 1, 'P', 159, 1, true,  -0.914999, -0.294999, -0.474999},
    {"Manana",                    2, 2,  1000.0, 'F', 1, 'P', 131, 1, true,  -0.879998, 0.000000, -0.389999},
    {"Infernus",                  2, 2,  1400.0, '4', 1, 'P', 223, 1, true,  -0.969999, 0.004999, -0.559997},
    {"Voodoo",                    2, 2,  1800.0, 'R', 1, 'P', 170, 2, true,  -0.994997, -0.154999, -0.569998},
    {"Pony",                      4, 4,  2600.0, 'R', 1, 'D', 111, 0, true,  -0.919999, -0.069999, -0.719999},
    {"Mule",                      2, 2,  3500.0, 'R', 1, 'D', 107, 0, true,  -0.759998, -0.469998, -0.524999},
    {"Cheetah",                   2, 2,  1200.0, 'R', 1, 'P', 194, 1, true,  -0.949998, -0.009998, -0.524999},
    {"Ambulance",                 4, 4,  2600.0, '4', 1, 'D', 155, 0, true,  -1.259999, -0.604999, -0.664999},
    {"Leviathan",                 2, 2, 15000.0, '4', 1, 'P', 143, 0, false, -2.255002, 0.859999, -0.124999},
    {"Moonbeam",                  4, 4,  2000.0, 'R', 1, 'D', 116, 1, true,  -1.004999, 0.089997, -0.829999},
    {"Esperanto",                 2, 2,  1800.0, 'R', 1, 'P', 150, 1, true,  -0.934997, -0.009998, -0.584999},
    {"Taxi",                      4, 4,  1450.0, 'F', 1, 'P', 146, 1, true,  -0.954999, -0.009998, -0.444999},
    {"Washington",                4, 2,  1850.0, 'R', 1, 'P', 155, 1, true,  -0.929997, -0.029998, -0.589999},
    {"Bobcat",                    2, 2,  1700.0, '4', 1, 'D', 141, 1, true,  -0.889998, 0.009998, -0.609999},
    {"Mr. Whoopee",               2, 2,  1700.0, 'R', 1, 'D', 100, 0, true,  -0.999997, 0.164995, -0.714999},
    {"BF Injection",              2, 0,  1200.0, 'R', 1, 'P', 137, 0, true,  -0.739997, 0.039999, -0.234999},
    {"Hunter",                    1, 1, 10000.0, '4', 1, 'P', 214, 0, false, -0.639998, 2.475008, -0.789999},
    {"Premier",                   4, 4,  1600.0, 'R', 1, 'P', 175, 1, true,  -0.969999, 0.000000, -0.464998},
    {"Enforcer",                  4, 4,  4000.0, 'R', 1, 'D', 167, 0, true,  -1.124999, -0.714999, -0.734999},
    {"Securicar",                 4, 2,  7000.0, 'R', 1, 'D', 158, 0, true,  -1.124999, 0.054999, -0.759998},
    {"Banshee",                   2, 2,  1400.0, 'R', 1, 'P', 203, 1, true,  -0.844999, 0.004999, -0.474999},
    {"Predator",                  1, 0,  2200.0, 'R', 1, 'P', 184, 0, false, 0.000000, 0.000000, 0.000000},
    {"Bus",                       7, 2,  5500.0, 'R', 1, 'D', 131, 0, true,  -1.304998, 2.300004, -0.714999},
    {"Rhino",                     1, 0, 25000.0, '4', 1, 'D',  95, 0, true,  0.000000, 0.000000, 0.000000},
    {"Barracks",                  2, 2, 10500.0, '4', 1, 'D', 112, 0, true,  -0.579999, 0.994997, -0.874997},
    {"Hotknife",                  2, 2,  1400.0, 'R', 1, 'P', 169, 0, true,  0.000000, 0.000000, 0.000000},
    {"Article Trailer",           0, 0,  3800.0, 'R', 0, 'D',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Previon",                   2, 2,  1400.0, 'F', 1, 'P', 150, 1, true,  -0.859999, -0.024999, -0.489998},
    {"Coach",                     7, 0,  9500.0, 'R', 1, 'D', 159, 0, true,  -1.314998, 2.245002, -0.724999},
    {"Cabbie",                    4, 4,  1750.0, 'R', 1, 'P', 144, 1, true,  -0.969999, -0.034999, -0.674996},
    {"Stallion",                  2, 2,  1600.0, 'R', 1, 'P', 170, 1, true,  -0.884998, 0.034999, -0.644999},
    {"Rumpo",                     4, 4,  2000.0, 'F', 1, 'P', 137, 0, true,  -0.914999, -0.045000, -0.899999},
    {"RC Bandit",                 1, 0,   100.0, '4', 0, 'E',  76, 0, true,  0.000000, 0.000000, 0.000000},
    {"Romero",                    2, 2,  2500.0, 'R', 1, 'P', 140, 1, true,  -1.004999, -0.074997, -0.604999},
    {"Packer",                    2, 2,  8000.0, 'R', 1, 'D', 127, 0, true,  -0.809997, 2.770015, -1.174998},
    {"Monster",                   2, 2,  5000.0, '4', 1, 'P', 111, 0, true,  -1.064998, 0.000000, 0.135000},
    {"Admiral",                   4, 4,  1650.0, 'F', 1, 'P', 165, 1, true,  -0.949998, 0.000000, -0.519999},
    {"Squallo",                   1, 0,  2200.0, 'R', 1, 'P', 240, 0, false, 0.000000, 0.000000, 0.000000},
    {"Seasparrow",                2, 2,  3000.0, '4', 1, 'P', 145, 0, false, -1.004999, 0.259999, -0.769999},
    {"Pizzaboy",                  1, 0,   350.0, 'R', 1, 'P', 190, 0, false, 0.000000, 0.000000, 0.000000},
    {"Tram",                      0, 0,  1900.0, 'R', 0, 'P', 185, 0, false, 0.000000, 0.000000, 0.000000},
    {"Article Trailer 2",         0, 0,  3800.0, 'R', 0, 'D',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Turismo",                   2, 2,  1400.0, '4', 1, 'P', 195, 1, true,  -0.984999, -0.194995, -0.519999},
    {"Speeder",                   1, 0,  2200.0, 'R', 1, 'P', 183, 0, false, 0.000000, 0.000000, 0.000000},
    {"Reefer",                    1, 0,  5000.0, 'R', 1, 'P',  57, 0, false, 0.000000, 0.000000, 0.000000},
    {"Tropic",                    1, 0,  2200.0, 'R', 1, 'P', 130, 0, false, 0.000000, 0.000000, 0.000000},
    {"Flatbed",                   2, 2,  8500.0, 'R', 1, 'D', 159, 0, true,  -0.579999, 0.979999, -0.859999},
    {"Yankee",                    2, 2,  4500.0, 'R', 1, 'D', 107, 0, true,  -0.764998, -0.179995, -0.464998},
    {"Caddy",                     2, 0,  1000.0, '4', 1, 'E',  96, 0, true,  0.000000, 0.000000, 0.000000},
    {"Solair",                    4, 4,  2000.0, 'R', 1, 'P', 159, 1, true,  -0.959999, -0.039999, -0.594999},
    {"Topfun Van (Berkley's RC)", 4, 4,  1900.0, 'R', 1, 'D', 137, 0, true,  -0.919999, -0.069999, -0.719999},
    {"Skimmer",                   2, 2,  5000.0, '4', 1, 'P', 135, 0, false, -1.399996, 0.554997, -1.819998},
    {"PCJ-600",                   2, 0,   500.0, 'R', 1, 'P', 207, 0, false, 0.000000, 0.000000, 0.000000},
    {"Faggio",                    2, 0,   350.0, 'R', 1, 'P', 190, 0, false, 0.000000, 0.000000, 0.000000},
    {"Freeway",                   2, 0,   800.0, 'R', 1, 'P', 210, 0, false, 0.000000, 0.000000, 0.000000},
    {"RC Baron",                  1, 0,   100.0, 'F', 0, 'P',  45, 0, true,  0.000000, 0.000000, 0.000000},
    {"RC Raider",                 1, 0,   100.0, '4', 0, 'P',  50, 0, true,  0.000000, 0.000000, 0.000000},
    {"Glendale",                  4, 4,  1600.0, 'R', 1, 'P', 148, 1, true,  -0.989997, -0.064998, -0.489998},
    {"Oceanic",                   4, 4,  1900.0, 'R', 1, 'P', 142, 1, true,  -0.989997, -0.044998, -0.484999},
    {"Sanchez",                   2, 0,   500.0, 'R', 1, 'P', 186, 0, false, 0.000000, 0.000000, 0.000000},
    {"Sparrow",                   2, 2,  2500.0, '4', 1, 'P', 145, 0, false, 0.000000, 0.000000, 0.000000},
    {"Patriot",                   4, 4,  2500.0, '4', 1, 'P', 158, 0, true,  -1.119999, -0.149995, -0.359999},
    {"Quad",                      2, 0,   400.0, '4', 1, 'P', 111, 0, true,  0.000000, 0.000000, 0.000000},
    {"Coastguard",                1, 0,  1200.0, 'R', 1, 'P', 125, 0, false, 0.000000, 0.000000, 0.000000},
    {"Dinghy",                    1, 0,   800.0, 'R', 1, 'P', 107, 0, false, 0.000000, 0.000000, 0.000000},
    {"Hermes",                    2, 2,  1950.0, 'F', 1, 'P', 150, 1, true,  -0.994997, -0.064998, -0.544999},
    {"Sabre",                     2, 2,  1700.0, 'R', 1, 'P', 175, 1, true,  -0.904999, -0.054999, -0.549996},
    {"Rustler",                   1, 1,  5000.0, '4', 1, 'P', 220, 0, false, 0.000000, 0.000000, 0.000000},
    {"ZR-350",                    2, 2,  1400.0, 'R', 1, 'P', 188, 1, true,  -0.979999, 0.019997, -0.514998},
    {"Walton",                    2, 2,  1850.0, '4', 1, 'D', 119, 1, true,  -0.804997, 0.064998, -0.519999},
    {"Regina",                    4, 4,  1500.0, 'F', 1, 'P', 141, 1, true,  -0.854999, 0.090000, -0.454997},
    {"Comet",                     2, 2,  1400.0, '4', 1, 'P', 186, 1, true,  -0.879998, 0.000000, -0.489998},
    {"BMX",                       1, 0,   100.0, 'R', 0, 'P',  97, 0, false, 0.000000, 0.000000, 0.000000},
    {"Burrito",                   4, 4,  1900.0, 'R', 1, 'P', 158, 0, true,  -0.989997, 0.000000, -0.759998},
    {"Camper",                    3, 3,  1900.0, 'R', 1, 'P', 124, 0, true,  -0.834999, -0.149995, -0.744997},
    {"Marquis",                   1, 0,  5000.0, 'R', 1, 'P',  64, 0, false, 0.000000, 0.000000, 0.000000},
    {"Baggage",                   1, 0,  1000.0, 'R', 1, 'E', 100, 0, true,  -0.629998, 0.164995, -0.374998},
    {"Dozer",                     1, 0, 10000.0, '4', 1, 'D',  65, 0, true,  0.000000, 0.000000, 0.000000},
    {"Maverick",                  4, 4,  5000.0, '4', 1, 'P', 181, 0, false, 0.000000, 0.000000, 0.000000},
    {"News Chopper",              2, 2,  3500.0, '4', 1, 'P', 170, 0, false, 0.000000, 0.000000, 0.000000},
    {"Rancher",                   2, 2,  2500.0, '4', 1, 'P', 141, 1, true,  -1.019999, 0.109999, -0.679997},
    {"FBI Rancher",               4, 4,  3500.0, '4', 1, 'P', 158, 0, true,  -1.054998, 0.125000, -0.604999},
    {"Virgo",                     2, 2,  1700.0, 'R', 1, 'P', 150, 1, true,  -0.874997, -0.009998, -0.569998},
    {"Greenwood",                 4, 4,  1600.0, 'R', 1, 'P', 142, 1, true,  -0.909999, 0.000000, -0.459998},
    {"Jetmax",                    1, 0,  3000.0, 'R', 1, 'P', 183, 0, false, 0.000000, 0.000000, 0.000000},
    {"Hotring Racer",             2, 2,  1600.0, 'R', 1, 'P', 217, 0, true,  -0.909999, -0.199999, -0.639998},
    {"Sandking",                  2, 2,  2000.0, '4', 1, 'P', 178, 0, true,  -1.024999, 0.184999, -0.809997},
    {"Blista Compact",            2, 2,  1000.0, 'F', 1, 'P', 164, 1, true,  -0.854999, 0.029998, -0.469998},
    {"Police Maverick",           4, 4,  4500.0, '4', 1, 'P', 190, 0, false, 0.000000, 0.000000, 0.000000},
    {"Boxville",                  4, 2,  5500.0, 'R', 1, 'D', 109, 0, true,  -1.149999, 0.269998, -0.654999},
    {"Benson",                    2, 2,  3500.0, 'R', 1, 'D', 124, 0, true,  -0.969999, -1.404996, -0.199999},
    {"Mesa",                      2, 2,  1300.0, '4', 1, 'D', 142, 1, true,  -0.969999, 0.189998, -0.574998},
    {"RC Goblin",                 1, 0,   100.0, '4', 0, 'P',  30, 0, true,  0.000000, 0.000000, 0.000000},
    {"Hotring Racer A",           2, 2,  1600.0, 'R', 1, 'P', 217, 0, true,  -0.909999, 0.029998, -0.639998},
    {"Hotring Racer B",           2, 2,  1600.0, 'R', 1, 'P', 217, 0, true,  -0.909999, -0.184999, -0.639998},
    {"Bloodring Banger",          2, 2,  2100.0, 'R', 1, 'P', 175, 0, true,  -0.989997, -0.059999, -0.494998},
    {"Rancher (Lure)",            2, 2,  2500.0, '4', 1, 'P', 141, 0, true,  -1.019999, 0.109999, -0.679997},
    {"Super GT",                  2, 2,  1400.0, 'R', 1, 'P', 181, 0, true,  -0.904999, -0.249999, -0.509998},
    {"Elegant",                   4, 4,  2200.0, 'R', 1, 'P', 167, 1, true,  -1.084998, -0.024999, -0.589999},
    {"Journey",                   2, 3,  3500.0, 'R', 1, 'D', 109, 0, true,  -1.334998, -0.424997, -0.979999},
    {"Bike",                      1, 0,   100.0, 'R', 0, 'P', 105, 0, false, 0.000000, 0.000000, 0.000000},
    {"Mountain Bike",             1, 0,   100.0, 'R', 0, 'P', 130, 0, false, 0.000000, 0.000000, 0.000000},
    {"Beagle",                    2, 2, 10000.0, '4', 1, 'P', 133, 0, false, 0.000000, 0.000000, 0.000000},
    {"Cropduster",                1, 1,  5000.0, '4', 1, 'P', 115, 0, false, 0.000000, 0.000000, 0.000000},
    {"Stuntplane",                1, 1,  5000.0, '4', 1, 'P', 151, 0, false, 0.000000, 0.000000, 0.000000},
    {"Tanker",                    2, 2,  3800.0, 'R', 1, 'D', 122, 0, true,  -0.969999, 1.669998, -1.174998},
    {"Roadtrain",                 2, 2,  5000.0, 'R', 1, 'D', 144, 0, true,  -1.454998, 0.439999, -1.854997},
    {"Nebula",                    4, 4,  1400.0, 'F', 1, 'P', 159, 1, true,  -0.989997, 0.024999, -0.584999},
    {"Majestic",                  2, 2,  1400.0, 'R', 1, 'P', 159, 1, true,  -0.959999, 0.004999, -0.554997},
    {"Buccaneer",                 2, 2,  1700.0, 'R', 1, 'P', 166, 1, true,  -1.049998, 0.109999, -0.439999},
    {"Shamal",                    1, 1, 15000.0, '4', 1, 'P', 272, 0, false, 0.000000, 0.000000, 0.000000},
    {"Hydra",                     1, 1,  9000.0, '4', 1, 'P', 272, 0, false, 0.000000, 0.000000, 0.000000},
    {"FCR-900",                   2, 0,   500.0, 'R', 1, 'P', 209, 0, false, 0.000000, 0.000000, 0.000000},
    {"NRG-500",                   2, 0,   400.0, 'R', 1, 'P', 209, 0, false, 0.000000, 0.000000, 0.000000},
    {"HPV1000",                   2, 0,   500.0, 'R', 1, 'P', 197, 0, false, 0.000000, 0.000000, 0.000000},
    {"Cement Truck",              2, 2,  5500.0, 'R', 1, 'D', 131, 0, true,  -0.689997, 1.489997, -1.319998},
    {"Towtruck",                  2, 2,  3500.0, 'R', 1, 'D', 162, 0, true,  -1.054998, 0.499998, -0.329997},
    {"Fortune",                   2, 2,  1700.0, 'R', 1, 'P', 159, 1, true,  -0.899999, 0.000000, -0.564997},
    {"Cadrona",                   2, 2,  1200.0, 'R', 1, 'P', 150, 1, true,  -0.944998, 0.154999, -0.419999},
    {"FBI Truck",                 2, 2,  4000.0, '4', 1, 'D', 178, 0, true,  -0.924996, 0.059999, -0.529999},
    {"Willard",                   4, 4,  1800.0, 'R', 1, 'P', 150, 1, true,  -0.934997, -0.109999, -0.429998},
    {"Forklift",                  1, 0,  1000.0, 'F', 1, 'E',  61, 0, true,  0.000000, 0.000000, 0.000000},
    {"Tractor",                   1, 0,  2000.0, 'R', 1, 'D',  71, 0, true,  -0.144997, 0.314999, -0.444999},
    {"Combine Harvester",         1, 1,  8500.0, '4', 1, 'D', 111, 0, true,  0.000000, 0.000000, 0.000000},
    {"Feltzer",                   2, 0,  1600.0, 'R', 1, 'P', 169, 1, true,  -0.924996, -0.034999, -0.479999},
    {"Remington",                 2, 2,  1800.0, 'R', 1, 'P', 170, 2, true,  -0.984999, 0.164995, -0.564997},
    {"Slamvan",                   2, 2,  1950.0, 'R', 1, 'P', 160, 2, true,  -1.069998, -0.034999, -0.569998},
    {"Blade",                     2, 0,  1500.0, 'R', 1, 'P', 175, 2, true,  -0.954999, -0.019997, -0.579999},
    {"Freight",                   7, 0,  5500.0, 'R', 1, 'D',   0, 0, false, 0.000000, 0.000000, 0.000000},
    {"Brown Streak",              7, 0,  5500.0, 'R', 0, 'D',   0, 0, false, 0.000000, 0.000000, 0.000000},
    {"Vortex",                    1, 0,  1900.0, 'R', 1, 'P', 101, 0, true,  -1.004999, -0.049998, -0.019997},
    {"Vincent",                   4, 4,  1800.0, 'F', 1, 'P', 150, 1, true,  -1.024999, -0.090000, -0.639998},
    {"Bullet",                    2, 2,  1200.0, 'R', 1, 'P', 205, 1, true,  -0.904999, 0.000000, -0.414999},
    {"Clover",                    2, 2,  1600.0, 'R', 1, 'P', 166, 1, true,  -0.894999, 0.014999, -0.539999},
    {"Sadler",                    2, 2,  1700.0, '4', 1, 'D', 152, 0, true,  -0.904999, 0.009998, -0.409999},
    {"Firetruck (Ladder)",        2, 2,  6500.0, 'R', 1, 'D', 150, 0, true,  -1.089998, 0.000000, -0.709999},
    {"Hustler",                   2, 2,  1700.0, 'R', 1, 'P', 148, 1, true,  -0.939997, -0.029998, -0.564997},
    {"Intruder",                  4, 4,  1800.0, 'R', 1, 'P', 150, 1, true,  -1.039999, -0.100000, -0.474999},
    {"Primo",                     4, 4,  1600.0, 'R', 1, 'P', 144, 1, true,  -0.884998, 0.059999, -0.479999},
    {"Cargobob",                  2, 2, 20000.0, '4', 1, 'P', 158, 0, false, -1.769997, 1.484997, -1.774996},
    {"Tampa",                     2, 2,  1700.0, 'R', 1, 'P', 155, 1, true,  -0.949998, 0.104997, -0.439999},
    {"Sunrise",                   4, 4,  1600.0, 'F', 1, 'P', 146, 1, true,  -1.089998, -0.059999, -0.554997},
    {"Merit",                     4, 4,  1800.0, 'R', 1, 'P', 159, 1, true,  -0.964999, 0.004999, -0.564997},
    {"Utility Van",               2, 2,  2600.0, 'R', 1, 'D', 122, 0, true,  -1.034999, 0.749997, -0.254999},
    {"Nevada",                    1, 0, 25000.0, '4', 1, 'P', 193, 0, false, 0.000000, 0.000000, 0.000000},
    {"Yosemite",                  2, 2,  3000.0, 'R', 1, 'P', 145, 0, true,  -1.109997, 0.009998, -0.534999},
    {"Windsor",                   2, 2,  1500.0, 'R', 1, 'P', 160, 1, true,  -0.754998, 0.000000, -0.464998},
    {"Monster A",                 2, 2,  5000.0, '4', 1, 'P', 111, 0, true,  -1.119999, 0.000000, 0.184999},
    {"Monster B",                 2, 2,  5000.0, '4', 1, 'P', 111, 0, true,  -1.129999, 0.044998, 0.074997},
    {"Uranus",                    2, 2,  1400.0, 'R', 1, 'P', 157, 3, true,  -0.894999, -0.089997, -0.374998},
    {"Jester",                    2, 2,  1500.0, 'F', 1, 'P', 179, 3, true,  -0.964999, 0.000000, -0.444999},
    {"Sultan",                    4, 4,  1400.0, '4', 1, 'P', 171, 3, true,  -1.004999, 0.054999, -0.414999},
    {"Stratum",                   4, 4,  1800.0, 'R', 1, 'P', 155, 3, true,  -0.919999, 0.129997, -0.574998},
    {"Elegy",                     2, 2,  1500.0, 'R', 1, 'P', 179, 3, true,  -0.909999, 0.119998, -0.404998},
    {"Raindance",                 2, 2, 10000.0, '4', 1, 'P', 160, 0, false, 0.000000, 0.000000, 0.000000},
    {"RC Tiger",                  1, 0,   100.0, '4', 0, 'E',  89, 0, true,  0.000000, 0.000000, 0.000000},
    {"Flash",                     2, 2,  1400.0, 'F', 1, 'P', 166, 3, true,  -0.824998, 0.000000, -0.414999},
    {"Tahoma",                    4, 4,  1800.0, 'R', 1, 'P', 161, 2, true,  -0.989997, -0.049998, -0.479999},
    {"Savanna",                   4, 2,  1500.0, 'R', 1, 'P', 175, 2, true,  -1.089998, 0.309998, -0.609999},
    {"Bandito",                   1, 0,  1000.0, 'R', 1, 'P', 148, 0, true,  -0.334998, 0.100000, -0.374998},
    {"Freight Flat Trailer",      0, 0,  5500.0, 'R', 0, 'D',   0, 0, false, 0.000000, 0.000000, 0.000000},
    {"Brown Streak Trailer",      0, 0,  5500.0, 'R', 0, 'D',   0, 0, false, 0.000000, 0.000000, 0.000000},
    {"Kart",                      1, 0,   300.0, 'R', 1, 'P',  94, 0, true,  0.000000, 0.000000, 0.000000},
    {"Mower",                     1, 0,   800.0, 'R', 1, 'P',  61, 0, true,  0.000000, 0.000000, 0.000000},
    {"Dune",                      2, 2, 10000.0, '4', 1, 'P', 111, 0, true,  0.000000, 0.000000, 0.000000},
    {"Sweeper",                   1, 2,   800.0, 'R', 1, 'P',  61, 0, true,  0.000000, 0.000000, 0.000000},
    {"Broadway",                  2, 0,  1700.0, 'R', 1, 'P', 159, 2, true,  -0.924996, 0.004999, -0.334998},
    {"Tornado",                   2, 2,  1700.0, 'R', 1, 'P', 159, 2, true,  -1.019999, -0.140000, -0.419999},
    {"AT-400",                    2, 0, 60000.0, '4', 1, 'P', 250, 0, false, 0.000000, 0.000000, 0.000000},
    {"DFT-30",                    2, 2,  5500.0, 'R', 1, 'D', 131, 0, true,  -1.429998, -0.649999, -0.879998},
    {"Huntley",                   4, 4,  2500.0, '4', 1, 'P', 159, 1, true,  -1.014999, 0.000000, -0.484999},
    {"Stafford",                  4, 4,  2200.0, 'R', 1, 'P', 154, 1, true,  -1.089998, 0.014999, -0.474999},
    {"BF-400",                    2, 0,   500.0, 'R', 1, 'P', 200, 0, false, 0.000000, 0.000000, 0.000000},
    {"Newsvan",                   4, 3,  1900.0, 'R', 1, 'D', 137, 0, true,  -0.984999, -0.194995, -0.709999},
    {"Tug",                       1, 2,   800.0, 'R', 1, 'P',  86, 0, true,  -0.674996, 0.259999, 0.129997},
    {"Petrol Trailer",            0, 0,  3800.0, 'R', 0, 'D',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Emperor",                   4, 4,  1800.0, 'R', 1, 'P', 154, 1, true,  -1.019999, -0.009998, -0.354999},
    {"Wayfarer",                  2, 0,   800.0, 'R', 1, 'P', 211, 0, false, 0.000000, 0.000000, 0.000000},
    {"Euros",                     2, 2,  1400.0, '4', 1, 'P', 166, 1, true,  -1.009999, -0.064998, -0.534999},
    {"Hotdog",                    2, 2,  5500.0, 'R', 1, 'D', 109, 0, true,  -1.374997, 0.000000, -0.664999},
    {"Club",                      2, 2,  1400.0, 'F', 1, 'P', 164, 1, true,  -0.909999, 0.000000, -0.359999},
    {"Freight Box Trailer",       0, 0,  5500.0, 'R', 0, 'D',   0, 0, false, 0.000000, 0.000000, 0.000000},
    {"Article Trailer 3",         0, 0,  3800.0, 'R', 0, 'D',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Andromada",                 7, 0, 40000.0, '4', 1, 'P', 266, 0, false, 0.000000, 0.000000, 0.000000},
    {"Dodo",                      2, 2,  5000.0, '4', 1, 'P', 135, 0, false, 0.000000, 0.000000, 0.000000},
    {"RC Cam",                    1, 0,   100.0, '4', 0, 'E',  62, 0, true,  0.000000, 0.000000, 0.000000},
    {"Launch",                    1, 0,  2200.0, 'R', 1, 'P', 118, 0, false, 0.000000, 0.000000, 0.000000},
    {"Police Car (LSPD)",         4, 4,  1600.0, 'R', 1, 'P', 177, 0, true,  -0.974999, 0.000000, -0.469998},
    {"Police Car (SFPD)",         4, 4,  1600.0, 'R', 1, 'P', 177, 0, true,  -0.969999, 0.000000, -0.464998},
    {"Police Car (LVPD)",         4, 4,  1600.0, 'R', 1, 'P', 177, 0, true,  -1.004999, -0.014999, -0.414999},
    {"Ranger",                    2, 2,  2500.0, '4', 1, 'D', 159, 0, true,  -1.019999, 0.115000, -0.684997},
    {"Picador",                   2, 2,  1600.0, 'R', 1, 'D', 152, 1, true,  -0.959999, 0.204998, -0.499998},
    {"S.W.A.T.",                  2, 0,  5000.0, '4', 1, 'D', 111, 0, true,  0.000000, 0.000000, 0.000000},
    {"Alpha",                     2, 2,  1500.0, 'R', 1, 'P', 171, 1, true,  -1.024999, 0.000000, -0.549996},
    {"Phoenix",                   2, 2,  1500.0, 'R', 1, 'P', 173, 1, true,  -0.954999, 0.034999, -0.629998},
    {"Glendale (destroyed)",      4, 4,  1600.0, 'R', 1, 'P', 148, 0, true,  -0.989997, -0.064998, -0.489998},
    {"Sadler (destroyed)",        2, 2,  1700.0, '4', 1, 'D', 152, 0, true,  -0.904999, 0.009998, -0.409999},
    {"Baggage Trailer A",         0, 0,  1000.0, 'R', 0, 'E',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Baggage Trailer B",         0, 0,  1000.0, 'R', 0, 'E',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Tug Stairs Trailer",        0, 0,  1000.0, 'R', 0, 'E',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Boxville (burglary)",       4, 2,  5500.0, 'R', 1, 'D', 109, 0, true,  -1.149999, 0.269998, -0.654999},
    {"Farm Trailer",              0, 0,   400.0, 'R', 0, 'E',   0, 0, true,  0.000000, 0.000000, 0.000000},
    {"Utility Trailer",           0, 0,  1000.0, 'R', 0, 'E',   0, 0, true,  0.000000, 0.000000, 0.000000}
};

enum SPEED_UNIT
{
    SPEED_UNIT_MPH, // miles per hour
    SPEED_UNIT_KMPH // kilometers per hour
};

#include "samplib/VLib_Components.inc"
#include "samplib/VLib_Sync.inc"

stock GetVehicleZoneName(vehicleid)
{
    new zone[32], Float:x, Float:y, Float:z;

    GetVehiclePos(vehicleid, x, y, z);

    if (GetVehicleVirtualWorld(vehicleid))
        zone = "Garage";
    else
        strcpy(zone, GetZoneName(x, y, z));

    return zone;
}

stock Float:GetVehicleMaxSpeed(vehicleid, SPEED_UNIT:unit=SPEED_UNIT_MPH)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        if (unit == SPEED_UNIT_MPH)
        {
            return VLib_VehicleInfo[modelid - 400][VLib_MaxSpeed] * 0.621371;
        }
        else
        {
            return VLib_VehicleInfo[modelid - 400][VLib_MaxSpeed];
        }
    }
    return 0;
}

stock Float:GetVehicleSpeed(vehicleid, SPEED_UNIT:unit=SPEED_UNIT_MPH)
{
    new Float:x, Float:y, Float:z;
    if (GetVehicleVelocity(vehicleid, x, y, z))
    {
        if (unit == SPEED_UNIT_MPH)
        {
            return floatsqroot((x * x) + (y * y) + (z * z)) * 181.5;
        }
        else
        {
            return floatsqroot((x * x) + (y * y) + (z * z)) * 136.666667;
        }
    }
    new Float:zero = 0.0;
    return zero;
}

stock IsPlayerInRangeOfVehicle(playerid, vehicleid, Float:Range)
{
    new Float:Pos[3];
    GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
    return IsPlayerInRangeOfPoint(playerid, Range, Pos[0], Pos[1], Pos[2]);
}

stock IsACruiser(vehicleid)
{
    switch (GetVehicleModel(vehicleid))
    {
        case 523, 427, 490, 528, 596..599, 601: return 1;
    }
    return 0;
}

stock IsABike(carid)
{
    switch (GetVehicleModel(carid))
    {
        case 481, 509, 510: return 1;
    }
    return 0;
}

stock IsAMotorBike(carid)
{
    switch (GetVehicleModel(carid))
    {
        case 481, 509, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471:  return 1;
    }
    return 0;
}

stock IsVehicleParamOn(vehicleid, param)
{
    new params[7];
    GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
    return params[param] == VEHICLE_PARAMS_ON;
}

stock SetVehicleParams(vehicleid, param, status)
{
    new params[7];

    GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
    params[param] = status;
    return SetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
}

stock GetVehicleSeats(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    return (IsVehicleModelID(modelid)?VLib_VehicleInfo[modelid - 400][VLib_Seats]:0);
}

stock IsSeatOccupied(vehicleid, seatid)
{
    foreach(new i : Player)
    {
        if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seatid)
        {
            return 1;
        }
    }
    return 0;
}

stock IsVehicleOccupied(vehicleid)
{
    foreach(new i : Player)
    {
        if (IsPlayerInVehicle(i, vehicleid) && GetPlayerState(i) == PLAYER_STATE_DRIVER)
        {
            return 1;
        }
    }
    return 0;
}

stock IsVehicleModelID(modelid)
{
    return (400 <= modelid <= 611);
}

stock GetVehicleNameByModel(modelid)
{
    new name[32];
    if (IsVehicleModelID(modelid))
    {
        strcat(name, VLib_VehicleInfo[modelid - 400][VLib_Name]);
    }
    else
    {
        name = "Unknown";
    }
    return name;
}

stock GetVehicleName(vehicleid)
{
    new name[32];
    name = GetVehicleNameByModel(GetVehicleModel(vehicleid));
    return name;
}

stock GetVehicleModelByName(const string[])
{
    new modelid = strval(string);

    if (IsVehicleModelID(modelid))
    {
        return modelid;
    }

    for (new i = 0; i < sizeof(VLib_VehicleInfo); i ++)
    {
        if (strfind(VLib_VehicleInfo[i][VLib_Name], string, true) != -1)
        {
            return i + 400;
        }
    }

    return 0;
}

stock GetVehicleDriver(vehicleid)
{
    foreach(new i : Player)
    {
        if (IsPlayerInVehicle(i, vehicleid) && GetPlayerState(i) == PLAYER_STATE_DRIVER)
        {
            return i;
        }
    }

    return INVALID_PLAYER_ID;
}

stock Float:GetPlayerDistanceFromVehicle(playerid, vehicleid)
{
    new Float: pos[3];
    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
    return GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);
}

stock GetClosestVehicle(playerid, exception = INVALID_VEHICLE_ID, Float: range = Float: 0x7F800000)
{
    new closestcar = INVALID_VEHICLE_ID;
    foreach(new vehicleid: Vehicle)
    {
        if (IsPlayerInRangeOfVehicle(playerid, vehicleid, range) && vehicleid != exception)
        {
            range = GetPlayerDistanceFromVehicle(playerid, vehicleid);
            closestcar = vehicleid;
        }
    }
    return closestcar;
}

stock GetVehicleCameraPos( vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0 )
{
    new Float:rot;
    GetVehicleZAngle( vehicleid, rot );
    rot = 360 - rot;
    GetVehiclePos( vehicleid, x, y, z );
    x = floatsin( rot, degrees ) * yoff + floatcos( rot, degrees ) * xoff + x;
    y = floatcos( rot, degrees ) * yoff - floatsin( rot, degrees ) * xoff + y;
    z = zoff + z;
}

stock VehicleHasWindows(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
        return (VLib_VehicleInfo[modelid - 400][VLib_Windows] > 0);
    return 0;
}

stock GetVehicleWindows(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        return VLib_VehicleInfo[modelid - 400][VLib_Windows];
    }
    return 0;
}

stock Float:GetVehicleMass(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        return VLib_VehicleInfo[modelid - 400][VLib_Mass];
    }
    return 0.0;
}

stock VehicleHasEngine(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    return (IsVehicleModelID(modelid) ? VLib_VehicleInfo[modelid - 400][VLib_HasEngine] : 0);
}

stock GetVehicleEngineType(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        if (modelid == 481 || modelid == 509 || modelid == 510) // Bikes
        {
            return 'H'; // Human-powered vehicle
        }
        else
        {
            return VLib_VehicleInfo[modelid - 400][VLib_EngineType];
        }
    }
    return 0;
}

stock GetVehicleDriveType(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        if (modelid == 481 || modelid == 509 || modelid == 510) // Bikes
        {
            return 'H'; // Human-powered vehicle
        }
        else
        {
            return VLib_VehicleInfo[modelid - 400][VLib_DriveType];
        }
    }
    return 0;
}

stock VehicleSupportsNeonLights(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    new idx = modelid - 400;

    if (0 <= idx <= 211)
    {
        if (VLib_VehicleInfo[idx][VLib_NeonOffsetX] == 0.0 &&
           VLib_VehicleInfo[idx][VLib_NeonOffsetY] == 0.0 &&
           VLib_VehicleInfo[idx][VLib_NeonOffsetZ] == 0.0)
        {
            return 0;
        }
        return 1;
    }
    return 0;
}

stock GetVehicleNeonOffset(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!IsValidVehicle(vehicleid))
    {
        x = 0.0;
        y = 0.0;
        z = 0.0;
        return 0;
    }
    new idx = GetVehicleModel(vehicleid) - 400;
    x = VLib_VehicleInfo[idx][VLib_NeonOffsetX];
    y = VLib_VehicleInfo[idx][VLib_NeonOffsetY];
    z = VLib_VehicleInfo[idx][VLib_NeonOffsetZ];
    return 1;
}

stock VehicleSupportsNitro(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        return VLib_VehicleInfo[modelid - 400][VLib_Nitro];
    }
    return 0;
}

stock GetVehiclePaintJobCount(vehicleid)
{
    return GetVehiclePaintJobCountByModel(GetVehicleModel(vehicleid));
}

stock GetVehiclePaintJobCountByModel(modelid)
{
    switch (modelid)
    {
        case 483: return 1;
        case 534: return 3;
        case 535: return 3;
        case 536: return 3;
        case 558: return 3;
        case 559: return 3;
        case 560: return 3;
        case 561: return 3;
        case 562: return 3;
        case 565: return 3;
        case 567: return 3;
        case 575: return 2;
        case 576: return 3;
    }
    return 0;
}

stock GetVehicleModShop(vehicleid)
{
    new modelid = GetVehicleModel(vehicleid);
    if (IsVehicleModelID(modelid))
    {
        return VLib_VehicleInfo[modelid - 400][VLib_ModShop];
    }
    return VEHICLE_MODSHOP_NONE;
}

stock IsPlayerInsidePaySpray(playerid)
{
    static const Float:payNSprayPos[][] =
    {
        { 2064.2842, -1831.4736, 13.5469},  // Idlewood
        {-2425.7822,  1022.1392, 50.3977},  // Juniper Hill
        {-1420.5195,  2584.2305, 55.8433},  // El Quebrados
        {  487.6401, -1739.9479, 11.1385},  // LS Santa Maria
        { 1024.8651, -1024.0870, 32.1016},  // LS Temple
        {-1904.7019,   284.5968, 41.0469},  // Wang Cars
        { 1975.2384,  2162.5088, 11.0703},  // LV Redsands
        { 2393.4456,  1491.5537, 10.5616},  // LV Unused (Pyramid)
        {  720.0854,  -457.8807, 16.3359},  // Dillimore
        {  -99.9417,  1117.9048, 19.7417}   // Fort Carson
    };

    if (GetPlayerInterior(playerid) == 0)
    {
        for (new index = sizeof(payNSprayPos) - 1; index >= 0; --index)
        {
            if (IsPlayerInRangeOfPoint(playerid, 7.5,
                payNSprayPos[index][0],
                payNSprayPos[index][1],
                payNSprayPos[index][2]))
            {
                return true;
            }
        }
    }
    return false;
}

// VehicleParamsEx toggle helpers
stock ToggleVehicleEngine(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (engine == VEHICLE_PARAMS_UNSET || engine == VEHICLE_PARAMS_OFF)
    {
        SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
    }
}

stock ToggleVehicleLights(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (lights == VEHICLE_PARAMS_UNSET || lights == VEHICLE_PARAMS_OFF)
    {
        SetVehicleParamsEx(vehicleid, engine,VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine,VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
    }
}

stock ToggleVehicleDoorsLocked(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (doors == VEHICLE_PARAMS_UNSET || doors == VEHICLE_PARAMS_OFF)
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm,VEHICLE_PARAMS_ON, bonnet, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm,VEHICLE_PARAMS_OFF, bonnet, boot, objective);
    }
}
stock ToggleVehicleHood(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (bonnet == VEHICLE_PARAMS_UNSET || bonnet == VEHICLE_PARAMS_OFF)
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors,VEHICLE_PARAMS_ON, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors,VEHICLE_PARAMS_OFF, boot, objective);
    }
}

stock ToggleVehicleTrunk(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (boot == VEHICLE_PARAMS_UNSET || boot == VEHICLE_PARAMS_OFF)
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet,VEHICLE_PARAMS_ON, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet,VEHICLE_PARAMS_OFF, objective);
    }
}

// VehicleParamsEx state setter helpers
stock SetVehicleEngineState(vehicleid, setstate)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (setstate)
    {
        SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
    }
}

stock SetVehicleLightsState(vehicleid, setstate)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (setstate)
    {
        SetVehicleParamsEx(vehicleid, engine,VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine,VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
    }
}
stock SetVehicleDoorsLockedState(vehicleid, setstate)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (setstate)
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm,VEHICLE_PARAMS_ON, bonnet, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm,VEHICLE_PARAMS_OFF, bonnet, boot, objective);
    }
}

stock SetVehicleHoodState(vehicleid, setstate)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (setstate)
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors,VEHICLE_PARAMS_ON, boot, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors,VEHICLE_PARAMS_OFF, boot, objective);
    }
}

stock SetVehicleTrunkState(vehicleid, setstate)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (setstate)
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet,VEHICLE_PARAMS_ON, objective);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet,VEHICLE_PARAMS_OFF, objective);
    }
}


stock GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff= 0.0, Float:yoff= 0.0, Float:zoff= 0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;
    GetVehiclePos(vehicleid, x, y, z);
    x = floatsin(rot, degrees) * yoff + floatcos(rot, degrees) * xoff + x;
    y = floatcos(rot, degrees) * yoff - floatsin(rot, degrees) * xoff + y;
    z = zoff + z;
}

stock IsPlayerAtVehicleDoor(playerid, vehicleid, VehicleDoorType:type)
{
    new Float:vx, Float:vy, Float:vz, Float:va;
    new Float:x, Float:y, Float:z, Float:a;

    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, z);

    if (type == VehicleDoorType_Driver)
    {
        GetVehicleRelativePos(vehicleid, vx, vy, vz, -x * 2, y, z);
    }
    else
    {
        GetVehicleRelativePos(vehicleid, vx, vy, vz, x * 2, y, z);
    }

    GetPlayerFacingAngle(playerid, a);
    GetVehicleZAngle(vehicleid, va);

    if (IsPlayerInRangeOfPoint(playerid, 1.0, vx, vy, vz))
    {
        return 1;
    }
    return 0;
}

stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (IsValidVehicle(vehicleid))
    {
        new Float:pos[7];
        GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
        GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
        GetVehicleZAngle(vehicleid, pos[6]);

        x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
        y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
        z = pos[5];
        return 1;
    }
    x = 0.0;
    y = 0.0;
    z = 0.0;
    return 0;
}

stock IsPlayerInRangeOfBoot(playerid, vehicleid)
{
    new Float:x, Float:y, Float:z;
    GetVehicleBoot(vehicleid, x, y, z);
    return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z);
}

stock IsAPlane(vehicleid)
{
    switch (GetVehicleModel(vehicleid))
    {
        case 460, 464, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: return 1;
    }
    return 0;
}

stock IsAnHelicopter(vehicleid)
{
    switch (GetVehicleModel(vehicleid))
    {
        case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: return 1;
    }

    return 0;
}

stock IsABoat(vehicleid)
{
    switch (GetVehicleModel(vehicleid))
    {
        case 430, 446, 452..454, 472, 473, 484, 493, 595: return 1;
    }

    return 0;
}

stock IsSurfVehicle(vehicleid)
{
    switch (GetVehicleModel(vehicleid))
    {
        case 406, 408, 422, 430, 432, 433, 441, 444, 446, 452..455, 460, 464, 470, 472, 473, 476, 478, 481, 484, 490, 493, 509..513, 519, 520, 528, 537, 538, 543, 553, 554, 556, 557, 569, 570, 577, 578, 590, 592..595, 600, 605, 607, 608: return 1;
    }

    return 0;
}

stock VehicleHasDoors(vehicleid)
{
    switch (GetVehicleModel(vehicleid))
    {
        case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475, 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536, 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609:
            return 1;
    }
    return 0;
}


stock bool:IsVehicleBajs(vehid)
{
    switch (GetVehicleModel(vehid))
    {
        case 481, 509, 510: return true;
    }
    return false;
}
