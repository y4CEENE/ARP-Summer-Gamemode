

enum gEnum
{
	gExists,
	gID,
	gOwnerID,
	gOwner[MAX_PLAYER_NAME],
	gType,
	gPrice,
	gLocked,
	gTimestamp,
	gFreeze,
	Float:gPosX,
	Float:gPosY,
	Float:gPosZ,
	Float:gPosA,
	Float:gExitX,
	Float:gExitY,
	Float:gExitZ,
	Float:gExitA,
	gWorld,
	gPickup,
	Text3D:gText
};


enum garageInt
{
	intName[16],
	intPrice,
	intID,
	Float:intPX,
	Float:intPY,
	Float:intPZ,
	Float:intPA,
	Float:intVX,
	Float:intVY,
	Float:intVZ,
	Float:intVA
};

new const garageInteriors[][garageInt] =
{
    {"Small", 	125000,  1,  1521.2797, -1639.7163, 1124.5045, 180.0000,  1516.8326, -1643.9105, 1124.3364, 180.0000},
	{"Medium", 	175000,  2,  1520.6278, -1639.7173, 1374.5045, 180.0000,  1514.9481, -1644.1083, 1374.3365, 180.0000},
	{"Large", 	350000,  3,  1672.8816, -2363.5818, 1535.4829, 90.0000,   1660.5437, -2362.9001, 1535.2944, 0.0000}
};