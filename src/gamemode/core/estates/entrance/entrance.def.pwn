
enum eEnum
{
	eExists,
	eID,
	eOwnerID,
	eOwner[MAX_PLAYER_NAME],
	eName[40],
	eIcon,
	eLocked,
	Float:eRadius,
	Float:ePosX,
	Float:ePosY,
	Float:ePosZ,
	Float:ePosA,
	Float:eIntX,
	Float:eIntY,
	Float:eIntZ,
	Float:eIntA,
	eInterior,
	eWorld,
	eOutsideInt,
	eOutsideVW,
	eAdminLevel,
	eFaction,
	eGang,
	eVIP,
	eVehicles,
	eFreeze,
	ePassword[64],
	eLabel,
	eType,
	eMapIcon,
	ePickup,
	eMapIconID,
	Text3D:eText,
	eColor
};


enum entranceEnum
{
	eShortName[32],
	eName[32],
	eVIP,
	eInterior,
 	eWorld,
 	eMapIcon,
 	eFreeze,
	Float:ePosX,
	Float:ePosY,
	Float:ePosZ,
	Float:ePosA,
	Float:eIntX,
	Float:eIntY,
	Float:eIntZ,
	Float:eIntA
};

new const staticEntrances[][entranceEnum] =
{
	{"county","County General"               , 0,  1,   1, 22, true,  2034.2003, -1402.1976, 17.2951, 180.0000, -2330.0376,   111.4688,  -5.3942, 270.0000},
	{"allsaints","All Saints Hospital"       , 0,  1,   2, 22, true,  1172.5100, -1325.3057, 15.4045, 270.0000, -2330.0376,   111.4688,  -5.3942, 270.0000},
	{"sfmd","San Fierro Medical Center"      , 0,  1,   5, 22, true,  -2665.217,   639.8689, 14.4531, 180.0000, -2330.0376,   111.4688,  -5.3942, 270.0000},
//	{"C&C Bank"                              , 0,  5,   3, 52, true,  1465.1348, -1010.5063, 26.8438, 180.0000,  1667.3536,  -995.3700, 683.6913, 0.0000},
	{"bank","C&C Bank"                       , 0,  5,   3, 52, true,   597.2520, -1249.2743, 18.2951,  13.5273,  1667.3536,  -995.3700,  683.6913,   0.0000},
	{"cityhall","City Hall"                  , 0,  3,   4, 35, false, 1479.2853, -1817.7679, 13.5579,   0.0000,   390.1344,   173.7334, 1008.3828,  90.0000},
	{"pd","Police Department"                , 0,  2,   5, 30, true,  1553.5737, -1675.7596, 16.1963,  90.0000,  1553.2065, -1674.0422, 2110.5356, 270.0000},
	{"sfpd","San Fierro Police Department"   , 0,  2,   6, 30, true, -1605.5079,   710.5154, 13.8672,   0.0000,  1553.2065, -1674.0422, 2110.5356, 270.0000},
	{"drivelicense","Licensing department"   , 0,  3,   6, 55, false, 1219.2590, -1812.1093, 16.5938, 180.0000, -2029.7135,  -119.2240, 1035.1719,   0.0000},
	{"vip","LS VIP Lounge"                   , 1,  3,   7, 59, true,  1308.8757, -1367.2715, 13.5256, 270.0000,  1994.06506,-1280.1887, 2697.0375,   0.0000},
	{"vip","SF VIP Lounge"                   , 1,  3,  77, 59, true, -1549.5186,  1171.9185,  7.1875,  90.0000,  1994.06506,-1280.1887, 2697.0375,   0.0000},
	{"drugden","Drug den"                    , 0,  5,   8, 23, false, 2160.9736, -1700.7681, 15.0859, 225.0000,   318.6025,  1114.9443, 1083.8828,   0.0000},
	{"chemlab","Chemicals Lab"               , 0, 17, 108, 23, false, 1765.2086, -2048.8926, 14.0429, 270.0000,  -959.6251,  1956.1638,    9.0000, 164.2435},
	{"drugfactory","Drug Factory"            , 0,  1, 109, 24, false,  418.1150, -1729.0800,  9.3040,   5.3560,  2204.5300,  1551.5600, 1008.6700, 271.7180},
	{"cracklab","Crack Lab"                  , 0,  5,   9, 23, false, 2351.9138, -1170.1725, 28.0507,   0.0000,  2352.3337, -1180.9257, 1027.9766,  90.0000},
	{"heisenbergs","Heisenberg's trailer"    , 0,  2,  10, 37, false,  -65.0972, -1574.3820,  2.6107, 180.0000,     1.6362,    -3.0563,  999.4284,  90.0000},
	{"fbi","FBI headquarters"                , 0,  1,  11, 30, true,   330.6662, -1509.9915, 36.0391, 225.0000,  -501.1844,   286.8678, 2001.0950,   0.0000},
	{"casino","Los Santos Casino"            , 0, 10,   0, 25, true,  1459.4089, -1010.0882, 26.8438, 180.0000,  2018.2132,  1017.7788,  996.8750,  90.0000},
	{"pigpen","The Pig Pen"                  , 0,  2,   0, 21, true,  2421.2798, -1219.6715, 25.5349, 165.9197,  1204.7922,   -13.2587, 1000.9219,   0.0000},
	//entrances that can't be found on /locate must have empty shortname and placed under this line
	{"","C&C Bank"                           , 0,  5,   3,  0, true,  593.67970, -1250.6511, 18.2459,  20.9024, 1667.3536, -995.3700, 683.6913, 0.0000},
	{"","C&C Bank\nBack entrance"            , 0,  5,   3,  0, true,  608.73630, -1278.8478, 16.2613, 291.8263, 1678.3589,-971.6281,683.6875,90.0000},
	{"","Los Santos Casino"                  , 0, 10,   0,  0, true,  1465.2338, -1010.4012, 26.8438, 180.0000, 2018.2132, 1017.7788, 996.8750, 90.0000},
	{"","Los Santos Casino\nBack entrance"   , 0, 10,   0,  0, true,  1426.6139,  -967.8503, 37.4279,   0.0000, 1963.9006,972.6248,994.4688,24.7575}

//	{"Rodeo Bank",           5,  13, 52, true,  593.5599, -1250.8365, 18.2484, 20.0000,   1667.3536, -995.3700, 683.6913, 0.0000}
};