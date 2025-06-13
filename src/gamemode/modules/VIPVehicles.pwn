/// @file      VIPVehicles.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-05-06 20:27:49 +0200
/// @copyright Copyright (c) 2022


#include <YSI\y_hooks>

static VIPVehicles[50];

hook OnGameModeInit()
{
    // Vip Vehicles
    VIPVehicles[0] = AddStaticVehicleEx(411,-4365.93212891,839.28680420,986.18029785,0.00000000,-1,-1,180); //Infernus
    VIPVehicles[1] = AddStaticVehicleEx(429,-4370.52832031,840.57843018,986.13031006,0.00000000,-1,-1,180); //Banshee
    VIPVehicles[2] = AddStaticVehicleEx(451,-4374.41894531,840.36810303,986.14465332,0.00000000,-1,-1,180); //Turismo
    VIPVehicles[3] = AddStaticVehicleEx(541,-4378.48046875,840.84783936,986.08032227,0.00000000,-1,-1,180); //Bullet
    VIPVehicles[4] = AddStaticVehicleEx(559,-4382.43701172,840.60235596,986.13439941,0.00000000,-1,-1,180); //Jester
    VIPVehicles[5] = AddStaticVehicleEx(560,-4386.68066406,841.29382324,986.18530273,0.00000000,-1,-1,180); //Sultan
    VIPVehicles[6] = AddStaticVehicleEx(603,-4390.54345703,841.60748291,986.38299561,0.00000000,-1,-1,180); //Phoenix
    VIPVehicles[7] = AddStaticVehicleEx(480,-4394.61035156,841.88873291,986.23028564,0.00000000,-1,-1,180); //Comet
    VIPVehicles[8] = AddStaticVehicleEx(506,-4399.16455078,842.31146240,986.17242432,0.00000000,-1,-1,180); //Super GT
    VIPVehicles[9] = AddStaticVehicleEx(587,-4402.89990234,842.34979248,986.19030762,0.00000000,-1,-1,180); //Euros
    VIPVehicles[10] = AddStaticVehicleEx(411,-4407.21337891,842.98492432,986.18029785,0.00000000,-1,-1,180); //Infernus
    VIPVehicles[11] = AddStaticVehicleEx(429,-4410.96923828,843.07391357,986.13031006,0.00000000,-1,-1,180); //Banshee
    VIPVehicles[12] = AddStaticVehicleEx(451,-4415.64257812,843.46972656,986.14465332,0.00000000,-1,-1,180); //Turismo
    VIPVehicles[13] = AddStaticVehicleEx(541,-4419.40478516,843.48645020,986.08032227,0.00000000,-1,-1,180); //Bullet
    VIPVehicles[14] = AddStaticVehicleEx(559,-4423.40332031,843.19854736,986.13439941,0.00000000,-1,-1,180); //Jester
    VIPVehicles[15] = AddStaticVehicleEx(560,-4427.88232422,843.82849121,986.18530273,0.00000000,-1,-1,180); //Sultan
    VIPVehicles[16] = AddStaticVehicleEx(603,-4431.95849609,844.09509277,986.38299561,0.00000000,-1,-1,180); //Phoenix
    VIPVehicles[17] = AddStaticVehicleEx(480,-4436.15429688,844.76721191,986.23028564,0.00000000,-1,-1,180); //Comet
    VIPVehicles[18] = AddStaticVehicleEx(506,-4441.21337891,850.94598389,986.17242432,270.00000000,-1,-1,180); //Super GT
    VIPVehicles[19] = AddStaticVehicleEx(587,-4441.05224609,854.70550537,986.19030762,270.00000000,-1,-1,180); //Euros
    VIPVehicles[20] = AddStaticVehicleEx(521,-4418.77490234,858.65576172,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[21] = AddStaticVehicleEx(521,-4414.77441406,858.50390625,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[22] = AddStaticVehicleEx(521,-4410.77441406,858.35253906,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[23] = AddStaticVehicleEx(521,-4406.30957031,857.78234863,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[24] = AddStaticVehicleEx(521,-4394.11425781,856.77416992,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[25] = AddStaticVehicleEx(521,-4390.35644531,856.70147705,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[26] = AddStaticVehicleEx(521,-4386.21923828,856.22369385,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[27] = AddStaticVehicleEx(521,-4382.18164062,855.81323242,986.04071045,180.00000000,-1,-1,180); //FCR-900
    VIPVehicles[28] = AddStaticVehicleEx(521,-4417.77832031,876.99304199,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[29] = AddStaticVehicleEx(521,-4414.06494141,876.46301270,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[30] = AddStaticVehicleEx(521,-4409.78320312,876.41296387,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[31] = AddStaticVehicleEx(521,-4405.26074219,876.33081055,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[32] = AddStaticVehicleEx(521,-4393.28417969,875.69360352,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[33] = AddStaticVehicleEx(521,-4389.04248047,875.41735840,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[34] = AddStaticVehicleEx(521,-4385.04980469,875.21435547,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[35] = AddStaticVehicleEx(521,-4381.05761719,875.00488281,986.04071045,0.00000000,-1,-1,180); //FCR-900
    VIPVehicles[36] = AddStaticVehicleEx(411,-4407.94287109,891.34375000,986.18029785,180.00000000,-1,-1,180); //Infernus
    VIPVehicles[37] = AddStaticVehicleEx(411,-4403.66748047,891.17761230,986.18029785,180.00000000,-1,-1,180); //Infernus
    VIPVehicles[38] = AddStaticVehicleEx(411,-4399.91601562,891.28747559,986.18029785,180.00000000,-1,-1,180); //Infernus
    VIPVehicles[39] = AddStaticVehicleEx(411,-4395.91601562,891.31347656,986.18029785,180.00000000,-1,-1,180); //Infernus
    VIPVehicles[40] = AddStaticVehicleEx(451,-4391.23242188,891.03985596,986.14465332,180.00000000,-1,-1,180); //Turismo
    VIPVehicles[41] = AddStaticVehicleEx(451,-4387.48339844,891.00421143,986.14465332,180.00000000,-1,-1,180); //Turismo
    VIPVehicles[42] = AddStaticVehicleEx(451,-4383.49218750,890.44665527,986.14465332,180.00000000,-1,-1,180); //Turismo
    VIPVehicles[43] = AddStaticVehicleEx(429,-4374.92187500,890.17211914,986.13031006,180.00000000,-1,-1,180); //Banshee
    VIPVehicles[44] = AddStaticVehicleEx(429,-4370.80273438,889.91503906,986.13031006,180.00000000,-1,-1,180); //Banshee
    VIPVehicles[45] = AddStaticVehicleEx(429,-4379.33349609,890.09112549,986.13031006,180.00000000,-1,-1,180); //Banshee
    VIPVehicles[46] = AddStaticVehicleEx(560,-4366.63867188,889.44537354,986.18530273,180.00000000,-1,-1,180); //Sultan
    VIPVehicles[47] = AddStaticVehicleEx(560,-4358.66015625,888.96386719,986.18530273,180.00000000,-1,-1,180); //Sultan
    VIPVehicles[48] = AddStaticVehicleEx(560,-4354.67675781,888.44500732,986.18530273,180.00000000,-1,-1,180); //Sultan
    VIPVehicles[49] = AddStaticVehicleEx(560,-4362.83789062,889.30908203,986.18530273,180.00000000,-1,-1,180); //Sultan
    return 1;
}


stock RespawnVipVehicles()
{
    for (new i = 0; i < sizeof(VIPVehicles); i++)
    {
        new vehicleid = VIPVehicles[i];
        if (!IsVehicleOccupied(vehicleid))
        {
            SetVehicleVirtualWorld(vehicleid, 0);
            LinkVehicleToInterior(vehicleid, 0);
            SetVehicleToRespawn(vehicleid);
        }
    }

    foreach (new vehicleid: Vehicle)
    {
        if (VehicleInfo[vehicleid][vVIP] > 0 &&  !IsVehicleOccupied(vehicleid))
        {
            SetVehicleVirtualWorld(vehicleid, 0);
            LinkVehicleToInterior(vehicleid, 0);
            SetVehicleToRespawn(vehicleid);
        }
    }
}
