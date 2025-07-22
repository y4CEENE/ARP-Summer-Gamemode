
new GodAdmin[] =
{
    1,    // "Khalil_Zoldyck",
    2,    // "J4cky_Heath_Morgan",
    3,    // "Yassine_Castellano"
    1369, // "Escobar_Berman"
    11391 // Jasu_Avara
};



enum eGotoCoord {
	egc_Name[32],
	egc_Param[32],
	Float:egc_X,
	Float:egc_Y,
	Float:egc_Z,
	Float:egc_A,
	egc_Int,
	egc_VW
};

new gotoCoords[][eGotoCoord] = {
    { "Los Santos", "ls", 1544.4407, -1675.5522, 13.5584, 90.0000, 0, 0},
    { "San Fierro", "sf", -1421.5629, -288.9972, 14.1484, 135.0000, 0, 0},
    { "Las Venturas", "lv", 1670.6908, 1423.5240, 10.7811, 270.0000, 0, 0},
    { "Grove Street", "grove", 2497.8274, -1668.9033, 13.3438, 90.0000, 0, 0},
    { "Idlewood", "idlewood", 2090.0664, -1816.9071, 13.3904, 90.0000, 0, 0},
    { "Unity Station", "unity", 1782.2683, -1865.5726, 13.5725, 0.0000, 0, 0},
    { "Jefferson Motel", "jefferson", 2222.3438, -1164.5013, 25.7331, 0.0000, 0, 0},
    { "Market", "market", 818.1782, -1349.2217, 13.5260, 0.0000, 0, 0},
    { "LS airport", "airport", 1938.7185, -2370.6375, 13.5469, 0.0000, 0, 0},
    { "Mulholland bank", "bank", 1463.8929, -1026.6189, 23.8281, 180.0000, 0, 0},
    { "Grotti dealership", "dealership", 546.7000, -1281.5160, 17.2482, 180.0000, 0, 0},
    { "VIP lounge", "vip", 1310.2343,-1395.1676,13.2596, 90.0000, 0, 0},
    { "Paintball", "pb", 1310.4086,-1376.8483,13.6604, 315.0000, 0, 0},
    { "Paintball", "paintball", 1310.4086,-1376.8483,13.6604, 315.0000, 0, 0},
    { "DMV", "dmv", 1224.1537, -1824.5253, 13.5900, 180.0000, 0, 0},
    { "Casino", "casino", 1603.5885,-1170.0281,24.0781, 180.0000, 0, 0},
    { "All saints", "allsaints", 1189.5807, -1301.7474, 13.5584, 180.0000, 0, 0},
    { "County hospital", "county", 1999.4670, -1448.2010, 13.5601, 315.0000, 0, 0}
};