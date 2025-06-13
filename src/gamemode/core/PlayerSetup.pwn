/// @file      PlayerSetup.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

hook OnRemoveBuildings(playerid)
{

    //GarbageMan
    RemoveBuildingForPlayer(playerid, 1412, 2415.8672, -2145.4375, 13.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 1412, 2421.1406, -2145.3438, 13.7500, 0.25);

    //Trucker
    RemoveBuildingForPlayer(playerid, 3709, 2206.3125, -2616.4688, 17.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 3744, 2205.1563, -2582.7891, 14.8125, 0.25);
    RemoveBuildingForPlayer(playerid, 3623, 2206.3125, -2616.4688, 17.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 3574, 2205.1563, -2582.7891, 14.8125, 0.25);
    RemoveBuildingForPlayer(playerid, 3744, 2262.8359, -2638.7734, 14.8125, 0.25);
    RemoveBuildingForPlayer(playerid, 3574, 2262.8359, -2638.7734, 14.8125, 0.25);

    //Drek's house
    RemoveBuildingForPlayer(playerid, 1261, 1715.7109, -780.3281, 68.3984, 0.25);
    RemoveBuildingForPlayer(playerid, 1267, 1715.7109, -780.3281, 68.3984, 0.25);
    RemoveBuildingForPlayer(playerid, 617, 1724.1172, -746.0234, 50.4922, 0.25);


    /////////////aerodrom nikola tesla
    RemoveBuildingForPlayer(playerid, 1215, 1586.210, -2325.562, 13.023, 0.250);
    RemoveBuildingForPlayer(playerid, 4992, 1654.539, -2286.804, 13.320, 0.250);
    RemoveBuildingForPlayer(playerid, 712, 1568.578, -2364.148, 21.648, 0.250);
    RemoveBuildingForPlayer(playerid, 620, 1569.312, -2342.109, 11.296, 0.250);
    RemoveBuildingForPlayer(playerid, 1226, 1570.679, -2323.421, 16.312, 0.250);


    // ---------------------------< Mechanic > ------------------------------ //
    RemoveBuildingForPlayer(playerid, 5516, 1977.8359, -1569.0469, 19.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 5634, 1931.3125, -1574.8438, 16.4609, 0.25);
    RemoveBuildingForPlayer(playerid, 1524, 1959.3984, -1577.7578, 13.7578, 0.25);
    RemoveBuildingForPlayer(playerid, 714, 2007.6094, -1556.6563, 12.5938, 0.25);
    RemoveBuildingForPlayer(playerid, 1308, 1943.8672, -1602.8047, 12.7813, 0.25);
    RemoveBuildingForPlayer(playerid, 5630, 1928.4922, -1575.9688, 20.5547, 0.25);
    RemoveBuildingForPlayer(playerid, 1307, 1931.7422, -1569.8828, 12.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 700, 1942.5625, -1599.2969, 12.9922, 0.25);
    RemoveBuildingForPlayer(playerid, 620, 1954.3594, -1603.6406, 12.5000, 0.25);
    RemoveBuildingForPlayer(playerid, 645, 1976.1719, -1600.1797, 12.1953, 0.25);
    RemoveBuildingForPlayer(playerid, 5475, 1977.8359, -1569.0469, 19.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 620, 1987.1172, -1618.2578, 12.5000, 0.25);
    RemoveBuildingForPlayer(playerid, 1307, 1983.3359, -1557.6797, 12.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 700, 2021.3359, -1599.2969, 12.9922, 0.25);
    RemoveBuildingForPlayer(playerid, 1264, 2019.5313, -1597.0000, 13.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 5422, 2071.4766, -1831.4219, 14.5625, 0.25);
    RemoveBuildingForPlayer(playerid, 11327, -2026.9141, 129.4063, 30.4531, 0.25);
    RemoveBuildingForPlayer(playerid, 11319, -1904.5313, 277.8984, 42.9531, 0.25);



    // House objects
    RemoveBuildingForPlayer(playerid, 14862, 245.5547, 300.8594, 998.8359, 0.25); // int 1
    RemoveBuildingForPlayer(playerid, 1740, 243.8828, 301.9766, 998.2344, 0.25);
    RemoveBuildingForPlayer(playerid, 14861, 245.7578, 302.2344, 998.5469, 0.25);
    RemoveBuildingForPlayer(playerid, 14860, 246.5156, 301.5859, 1000.0000, 0.25);
    RemoveBuildingForPlayer(playerid, 14864, 246.1875, 303.1094, 998.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 1734, 246.7109, 303.8750, 1002.1172, 0.25);
    RemoveBuildingForPlayer(playerid, 14863, 246.9844, 303.5781, 998.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 2103, 248.4063, 300.5625, 999.3047, 0.25);
    RemoveBuildingForPlayer(playerid, 2088, 248.4922, 304.3516, 998.2266, 0.25);
    RemoveBuildingForPlayer(playerid, 1741, 248.4844, 306.1250, 998.1406, 0.25);
    RemoveBuildingForPlayer(playerid, 1741, 248.8672, 301.9609, 998.1406, 0.25);
    RemoveBuildingForPlayer(playerid, 1744, 250.1016, 301.9609, 999.4531, 0.25);
    RemoveBuildingForPlayer(playerid, 1744, 250.1016, 301.9609, 1000.1563, 0.25);
    /*RemoveBuildingForPlayer(playerid, 2251, 266.4531, 303.3672, 998.9844, 0.25); // int 2
    RemoveBuildingForPlayer(playerid, 14867, 270.2813, 302.5547, 999.6797, 0.25);
    RemoveBuildingForPlayer(playerid, 1720, 272.9063, 304.7891, 998.1641, 0.25);
    RemoveBuildingForPlayer(playerid, 14870, 273.1641, 303.1719, 1000.9141, 0.25);
    RemoveBuildingForPlayer(playerid, 2251, 273.9922, 303.3672, 998.9844, 0.25);
    RemoveBuildingForPlayer(playerid, 14868, 274.1328, 304.5078, 1001.1953, 0.25);
    RemoveBuildingForPlayer(playerid, 948, 266.5703, 306.4453, 998.1406, 0.25);
    RemoveBuildingForPlayer(playerid, 14866, 270.1172, 307.6094, 998.7578, 0.25);
    RemoveBuildingForPlayer(playerid, 14869, 273.8125, 305.0156, 998.9531, 0.25);*/
    RemoveBuildingForPlayer(playerid, 15039, 2232.3438, -1106.7422, 1049.7500, 0.25); //
    RemoveBuildingForPlayer(playerid, 15038, 2235.2891, -1108.1328, 1051.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 15035, 2205.9375, -1073.9922, 1049.4844, 0.25);
    RemoveBuildingForPlayer(playerid, 15028, 2263.1250, -1138.2422, 1049.8438, 0.25);
    RemoveBuildingForPlayer(playerid, 15026, 2264.9063, -1137.7656, 1051.3594, 0.25);
    RemoveBuildingForPlayer(playerid, 2123, 2312.9609, -1145.0703, 1050.3203, 0.25);
    RemoveBuildingForPlayer(playerid, 2123, 2314.2969, -1146.3125, 1050.3203, 0.25);
    RemoveBuildingForPlayer(playerid, 2123, 2315.4219, -1145.0703, 1050.3203, 0.25);
    RemoveBuildingForPlayer(playerid, 2086, 2314.2734, -1144.8984, 1050.0859, 0.25);
    RemoveBuildingForPlayer(playerid, 2123, 2314.2969, -1143.6250, 1050.3203, 0.25);
    RemoveBuildingForPlayer(playerid, 2281, 2318.7813, -1145.4609, 1054.5938, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1144.0859, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2335.3594, -1144.0703, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2135, 2336.3516, -1144.0781, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2305, 2337.3203, -1144.0781, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1143.1016, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2337.3203, -1143.0938, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 1703, 2322.2266, -1142.4766, 1049.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 1822, 2323.9297, -1142.2578, 1049.4844, 0.25);
    RemoveBuildingForPlayer(playerid, 1741, 2312.6484, -1140.7891, 1053.3750, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1142.1094, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1141.1172, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2079, 2334.4219, -1140.9688, 1050.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 1703, 2326.5234, -1140.5703, 1049.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2337.3203, -1142.1094, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2139, 2337.3125, -1141.1094, 1049.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 2088, 2338.4531, -1141.3672, 1053.2734, 0.25);
    RemoveBuildingForPlayer(playerid, 2270, 2340.2734, -1141.7109, 1054.5391, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1140.1328, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 1703, 2323.4375, -1139.5469, 1049.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 2079, 2333.3281, -1139.8672, 1050.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 2115, 2334.4297, -1139.6250, 1049.7109, 0.25);
    RemoveBuildingForPlayer(playerid, 2079, 2335.3672, -1139.8750, 1050.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 2303, 2337.3281, -1140.1172, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2090, 2309.5156, -1139.3438, 1053.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1139.1406, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2079, 2333.3281, -1138.8281, 1050.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 2079, 2335.3672, -1138.8359, 1050.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 2298, 2336.5391, -1138.7891, 1053.2813, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1138.1563, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2136, 2337.3281, -1138.1328, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2240, 2319.2500, -1137.8750, 1050.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2240, 2329.5000, -1137.8750, 1050.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1137.1641, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2079, 2334.4219, -1137.5859, 1050.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 2139, 2337.3125, -1137.1484, 1049.6641, 0.25);
    RemoveBuildingForPlayer(playerid, 2088, 2310.6641, -1136.3047, 1053.3672, 0.25);
    RemoveBuildingForPlayer(playerid, 2257, 2320.4141, -1134.6328, 1053.8281, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1136.1719, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2331.3359, -1135.1875, 1049.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 2254, 2328.1484, -1134.6172, 1054.0625, 0.25);
    RemoveBuildingForPlayer(playerid, 2281, 2335.2656, -1136.4063, 1054.7266, 0.25);
    RemoveBuildingForPlayer(playerid, 2106, 2336.5156, -1135.0156, 1053.8047, 0.25);
    RemoveBuildingForPlayer(playerid, 2271, 2337.8047, -1135.3516, 1054.7031, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2337.3203, -1136.1641, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2337.3203, -1135.1797, 1049.6719, 0.25);
    RemoveBuildingForPlayer(playerid, 2106, 2339.2031, -1135.0156, 1053.8047, 0.25);
    RemoveBuildingForPlayer(playerid, 1741, 2261.6953, -1223.0781, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2088, 2258.1406, -1220.5859, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 2090, 2258.5938, -1221.5469, 1048.0625, 0.25);
    RemoveBuildingForPlayer(playerid, 2528, 2254.4063, -1218.2734, 1048.0234, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2247.5547, -1213.9219, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2247.5547, -1212.9375, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2121, 2250.3047, -1213.9375, 1048.5234, 0.25);
    RemoveBuildingForPlayer(playerid, 2526, 2252.4297, -1215.4531, 1048.0391, 0.25);
    RemoveBuildingForPlayer(playerid, 2523, 2254.1953, -1215.4531, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2297, 2255.4219, -1213.5313, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2248, 2262.3906, -1215.5469, 1048.6094, 0.25);
    RemoveBuildingForPlayer(playerid, 1816, 2261.4141, -1213.4531, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 2249, 2247.2969, -1212.1641, 1049.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 2249, 2247.2969, -1208.8594, 1049.6250, 0.25);
    RemoveBuildingForPlayer(playerid, 2139, 2247.5625, -1211.9531, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 2136, 2247.5469, -1210.9688, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2303, 2247.5469, -1208.9844, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2138, 2247.5547, -1207.9766, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2305, 2247.5547, -1206.9922, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2109, 2250.2813, -1212.2500, 1048.4141, 0.25);
    RemoveBuildingForPlayer(playerid, 2121, 2249.2344, -1211.4531, 1048.5234, 0.25);
    RemoveBuildingForPlayer(playerid, 2121, 2250.3047, -1210.8984, 1048.5234, 0.25);
    RemoveBuildingForPlayer(playerid, 2135, 2248.5234, -1206.9922, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2319, 2250.3438, -1206.9609, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 1760, 2261.4609, -1212.0625, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 2126, 2258.1094, -1210.3750, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 15044, 2255.0938, -1209.7813, 1048.0313, 0.25);
    RemoveBuildingForPlayer(playerid, 2247, 2258.4766, -1209.7891, 1048.9922, 0.25);
    RemoveBuildingForPlayer(playerid, 2099, 2262.8047, -1208.4922, 1048.0156, 0.25);
    RemoveBuildingForPlayer(playerid, 2254, 2254.1172, -1206.5000, 1050.7578, 0.25);
    RemoveBuildingForPlayer(playerid, 2240, 2254.6328, -1207.2734, 1048.5625, 0.25);
    RemoveBuildingForPlayer(playerid, 2252, 2256.2109, -1206.1016, 1048.8281, 0.25);
    RemoveBuildingForPlayer(playerid, 2235, 2256.2188, -1206.8594, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 1760, 2257.6172, -1207.7266, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 2235, 2261.4297, -1206.2031, 1048.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 2252, 2262.1172, -1206.1016, 1048.8281, 0.25);
    /*RemoveBuildingForPlayer(playerid, 1734, 2452.0313, -1702.0234, 1015.9688, 0.25);
    RemoveBuildingForPlayer(playerid, 14742, 2451.9063, -1701.1875, 1014.8594, 0.25);
    RemoveBuildingForPlayer(playerid, 14741, 2447.4219, -1693.4531, 1012.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 14761, 2449.9609, -1690.8438, 1014.0547, 0.25);
    RemoveBuildingForPlayer(playerid, 2241, 2459.3828, -1691.4766, 1013.0078, 0.25);
    RemoveBuildingForPlayer(playerid, 14745, 2460.2422, -1695.1016, 1012.9453, 0.25);*/
    RemoveBuildingForPlayer(playerid, 2249, 2251.3594, -1218.1797, 1048.6953, 0.25);
    RemoveBuildingForPlayer(playerid, 15049, 2334.3281, -1139.5859, 1051.1953, 0.25);
    RemoveBuildingForPlayer(playerid, 15045, 2324.4297, -1143.3125, 1049.6016, 0.25);

    // Miner objects
    RemoveBuildingForPlayer(playerid, 5967, 1259.4375, -1246.8125, 17.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 5857, 1259.4375, -1246.8125, 17.1094, 0.25);

    return 1;
}

hook OnPlayerInit(playerid)
{
    InitDealerShip(playerid);
    InitBizMessage(playerid);
    PlayerData[playerid][pChatstyle] = 0;
    PlayerData[playerid][pInTurf] = 0;
    PlayerData[playerid][pCalling] = 0;
    PlayerData[playerid][pIsCaller] = false;
    InsideShamal[playerid]= INVALID_VEHICLE_ID;
    PlayerData[playerid][pSpeakerPhone] = 0;
    PlayerData[playerid][pDealership] = 0;
    PlayerData[playerid][pRepairShop] = -1;
    PlayerData[playerid][pRepairTime] = 0;
    PlayerData[playerid][pEditRack] = -1;
    PlayerData[playerid][pRangeBooth] = -1;
    PlayerData[playerid][pTargets] = 0;
    PlayerData[playerid][pTargetLevel] = 0;
    PlayerData[playerid][pToggleTP] = 0;

    seatbelt[playerid] = 0;

    if (IsPlayerNPC(playerid)) return 1;
    // Nametag
    chosednumber[playerid] = -1;

    SetPVarInt(playerid, "Mobile", 501);

    PlayerData[playerid][pRobHouse] = -1;
    GetPlayerName(playerid, PlayerData[playerid][pUsername], MAX_PLAYER_NAME);
    DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
    fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
    SendClientMessageEx(playerid, 0xA9C4E4FF, "Establishing connection to the {00aa00} %s {A9C4E4} please wait...", GetServerName());


    firstperson[playerid] = 0;
    PlayerData[playerid][pCarryCrate] = -1;

    // Default values are handled via MySQL. Don't assign default values here.

    PlayerData[playerid][pEditLandGraffiti] = -1;
    PlayerData[playerid][pID] = 0;
    PlayerData[playerid][pvLock] = 0;
    PlayerData[playerid][pKicked] = 0;
    PlayerData[playerid][pLoginTries] = 0;
    PlayerData[playerid][pSetup] = 0;
    PlayerData[playerid][pGender] = PlayerGender_Unspecified;
    PlayerData[playerid][pAge] = 0;
    PlayerData[playerid][pSkin] = 0;
    PlayerData[playerid][pPosX] = 0;
    PlayerData[playerid][pPosY] = 0;
    PlayerData[playerid][pPosZ] = 0;
    PlayerData[playerid][pPosA] = 0;
    PlayerData[playerid][pInterior] = 0;
    PlayerData[playerid][pWorld] = 0;
    PlayerData[playerid][pCash] = 5000;
    PlayerData[playerid][pBank] = 0;
    PlayerData[playerid][pPaycheck] = 0;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pEXP] = 0;
    PlayerData[playerid][pMinutes] = 0;
    PlayerData[playerid][pHours] = 0;
    PlayerData[playerid][pAdmin] = 0;
    PlayerData[playerid][pAdminName] = 0;
    PlayerData[playerid][pRegDate] = 0;
    PlayerData[playerid][pHelper] = 0;
    PlayerData[playerid][pHealth] = 100.0;
    PlayerData[playerid][pArmor] = 0.0;
    PlayerData[playerid][pUpgradePoints] = 0;
    PlayerData[playerid][pInjured] = 0;
    PlayerData[playerid][pSpawnHealth] = 50.0;
    PlayerData[playerid][pSpawnArmor] = 0;

    PlayerData[playerid][pJailType] = JailType_None;
    PlayerData[playerid][pJailTime] = 0;
    PlayerData[playerid][pFightStyle] = 0;
    PlayerData[playerid][pAccent] = 0;
    PlayerData[playerid][pPhone] = 0;
    PlayerData[playerid][pJob] = JOB_NONE;
    PlayerData[playerid][pSecondJob] = JOB_NONE;
    PlayerData[playerid][pCrimes] = 0;
    PlayerData[playerid][pArrested] = 0;
    PlayerData[playerid][pWantedLevel] = 0;
    PlayerData[playerid][pNotoriety] = 0;
    PlayerData[playerid][pMaterials] = 0;
    PlayerData[playerid][pGlassItem] = 0;
	PlayerData[playerid][pMetalItem] = 0;
	PlayerData[playerid][pRubberItem] = 0;
	PlayerData[playerid][pIronItem] = 0;
	PlayerData[playerid][pPlasticItem] = 0;
    PlayerData[playerid][pWeed] = 0;
    PlayerData[playerid][pCocaine] = 0;
    PlayerData[playerid][pHeroin] = 0;
    PlayerData[playerid][pPainkillers] = 0;
    PlayerData[playerid][pSeeds] = 0;
    PlayerData[playerid][pChemicals] = 0;
    PlayerData[playerid][pMuriaticAcid] = 0;
    PlayerData[playerid][pBakingSoda] = 0;
    PlayerData[playerid][pCigars] = 0;
    PlayerData[playerid][pPrivateRadio] = 0;
    PlayerData[playerid][pChannel] = 0;
    PlayerData[playerid][pRentingHouse] = 0;
    PlayerData[playerid][pBocketFull] = 0;
	PlayerData[playerid][pBocket] = 0;
    PlayerData[playerid][pSpraycans] = 0;
    PlayerData[playerid][pBoombox] = 0;
    PlayerData[playerid][pMP3Player] = 0;
    PlayerData[playerid][pFishingRod] = 0;
    PlayerData[playerid][pFishingBait] = 0;
    PlayerData[playerid][pFishWeight] = 0;
    PlayerData[playerid][pNetSize] = 0;
    PlayerData[playerid][pDolphinWeight] = 0;
    PlayerData[playerid][pDolphinCount] = 0;
    PlayerData[playerid][pCrabWeight] = 0;
    PlayerData[playerid][pCrabCount] = 0;
    PlayerData[playerid][pSharkWeight] = 0;
    PlayerData[playerid][pSharkCount] = 0;
    PlayerData[playerid][pComponents] = 0;
    PlayerData[playerid][pMechanicSkill] = 0;
    PlayerData[playerid][pSmugglerSkill] = 0;
    PlayerData[playerid][pWeaponSkill] = 0;
    PlayerData[playerid][pDrugDealerSkill] = 0;
    PlayerData[playerid][pFarmerSkill] = 0;
    PlayerData[playerid][pDetectiveSkill] = 0;
    PlayerData[playerid][pLawyerSkill] = 0;
    PlayerData[playerid][pForkliftSkill] = 0;
    PlayerData[playerid][pCarJackerSkill] = 0;
    PlayerData[playerid][pCraftSkill] = 0;
    PlayerData[playerid][pPizzaSkill] = 0;
    PlayerData[playerid][pTruckerSkill] = 0;
    PlayerData[playerid][pHookerSkill] = 0;
    PlayerData[playerid][pRobberySkill] = 0;
    PlayerData[playerid][pFishingSkill] = 0;
    PlayerData[playerid][pToggleTextdraws] = 0;
    PlayerData[playerid][pToggleOOC] = 0;
    PlayerData[playerid][pTogglePhone] = 0;
    PlayerData[playerid][pToggleAdmin] = 0;
    PlayerData[playerid][pToggleHelper] = 0;
    PlayerData[playerid][pTogglePoints] = 0;
    PlayerData[playerid][pToggleTurfs] = 0;
    PlayerData[playerid][pToggleNewbie] = 0;
    PlayerData[playerid][pTogglePR] = 0;
    PlayerData[playerid][pToggleRadio] = 0;
    PlayerData[playerid][pTogglePM] = 0;
    PlayerData[playerid][pToggleVIP] = 0;
    PlayerData[playerid][pToggleMusic] = 0;
    PlayerData[playerid][pToggleFaction] = 0;
    PlayerData[playerid][pToggleGang] = 0;
    PlayerData[playerid][pToggleNews] = 0;
    PlayerData[playerid][pToggleGlobal] = 0;
    PlayerData[playerid][pToggleCam] = 0;
    PlayerData[playerid][pDonator] = 0;
    PlayerData[playerid][pVIPTime] = 0;
    PlayerData[playerid][pVIPCooldown] = 0;
    PlayerData[playerid][pWeapons] = 0;
    PlayerData[playerid][pFaction] = 0;
    PlayerData[playerid][pFactionRank] = 0;
    PlayerData[playerid][pGang] = -1;
    PlayerData[playerid][pGangRank] = 0;
    PlayerData[playerid][pDivision] = 0;
    PlayerData[playerid][pRadar] = 0;
    PlayerData[playerid][pCrew] = 0;
    PlayerData[playerid][pContracted] = 0;
    PlayerData[playerid][pContractBy] = 0;
    PlayerData[playerid][pBombs] = 0;
    PlayerData[playerid][pCompletedHits] = 0;
    PlayerData[playerid][pFailedHits] = 0;
    PlayerData[playerid][pReports] = 0;
    PlayerData[playerid][pNewbies] = 0;
    PlayerData[playerid][pHelpRequests] = 0;
    PlayerData[playerid][pSpeedometer] = 0;
    PlayerData[playerid][pFactionMod] = 0;
    PlayerData[playerid][pWebDev] = 0;
    PlayerData[playerid][pGangMod] = 0;
    PlayerData[playerid][pBanAppealer] = 0;
    PlayerData[playerid][pHelperManager] = 0;
    PlayerData[playerid][pAdminPersonnel] = 0;
    PlayerData[playerid][pGameAffairs] = 0;
    PlayerData[playerid][pWebDev] = 0;
    PlayerData[playerid][pComplaintMod] = 0;
    PlayerData[playerid][pHumanResources] = 0;
    PlayerData[playerid][pHelperManager] = 0;
    PlayerData[playerid][pDeveloper] = 0;
    PlayerData[playerid][pInventoryUpgrade] = 0;
    PlayerData[playerid][pAddictUpgrade] = 0;
    PlayerData[playerid][pTraderUpgrade] = 0;
    PlayerData[playerid][pAssetUpgrade] = 0;

    PlayerData[playerid][pLastReport] = 0;
    PlayerData[playerid][pLastNewbie] = 0;
    PlayerData[playerid][pLastRequest] = 0;
    PlayerData[playerid][pLastPay] = 0;
    PlayerData[playerid][pLastRepair] = 0;
    PlayerData[playerid][pLastRefuel] = 0;
    PlayerData[playerid][pLastDrug] = 0;
    PlayerData[playerid][pLastSell] = 0;
    PlayerData[playerid][pLastEnter] = 0;
    PlayerData[playerid][pLastPress] = 0;
    PlayerData[playerid][pLastDeath] = 0;
    PlayerData[playerid][pLastDesync] = 0;
    PlayerData[playerid][pLastGlobal] = 0;
    PlayerData[playerid][pFPS] = 0;
    PlayerData[playerid][pDrunkLevel] = 0;
    PlayerData[playerid][pAdminDuty] = 0;
    PlayerData[playerid][pActiveReport] = -1;
    PlayerData[playerid][pListen] = 0;
    PlayerData[playerid][pPaintball] = 0;
    PlayerData[playerid][pPaintballTeam] = -1;
    PlayerData[playerid][pAwaitingClothing] = 0;
    PlayerData[playerid][pFreezeTimer] = -1;
    PlayerData[playerid][pNameChange][0] = 0;
    PlayerData[playerid][pHelpRequest][0] = 0;
    PlayerData[playerid][pAcceptedHelp] = 0;
    PlayerData[playerid][pHouseOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pGarageOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pBizOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pCarOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pGangOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pTicketOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pLiveOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pLiveBroadcast] = INVALID_PLAYER_ID;
    PlayerData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pLandOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pAllianceOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pWarOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pDefendOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pDiceOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pInviteOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pRobberyOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pEditType] = 0;
    PlayerData[playerid][pEditObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pLastStuck] = 0;
    PlayerData[playerid][pLastLoad] = 0;
    PlayerData[playerid][pLastBet] = 0;
    PlayerData[playerid][pLastShot] = 0;
    PlayerData[playerid][pFishTime] = 0;
    PlayerData[playerid][pUsedBait] = 0;
    PlayerData[playerid][pSmuggleMats] = 0;
    PlayerData[playerid][pSmuggleTime] = 0;
    PlayerData[playerid][pSmuggleDrugs] = 0;
    PlayerData[playerid][pRefuel] = INVALID_VEHICLE_ID;
    PlayerData[playerid][pCallLine] = INVALID_PLAYER_ID;
    PlayerData[playerid][pDrivingTest] = 0;
    PlayerData[playerid][pSpecialTag] = Text3D:INVALID_3DTEXT_ID;
    PlayerData[playerid][pTagType] = TAG_NONE;
    PlayerData[playerid][pVIPColor] = 0;
    PlayerData[playerid][pFaction] = -1;
    PlayerData[playerid][pFactionRank] = 0;
    PlayerData[playerid][pGang] = -1;
    PlayerData[playerid][pGangRank] = 0;
    PlayerData[playerid][pDuty] = 0;
    PlayerData[playerid][pBackup] = 0;
    PlayerData[playerid][pTazer] = 0;
    PlayerData[playerid][pTazedTime] = 0;
    PlayerData[playerid][pCuffed] = 0;
    PlayerData[playerid][pTied] = 0;
    PlayerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
    PlayerData[playerid][pSkinSelected] = -1;
    PlayerData[playerid][pReceivingAid] = 0;
    PlayerData[playerid][pDelivered] = 0;
    PlayerData[playerid][pPlantedBomb] = 0;
    PlayerData[playerid][pBombObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pContractTaken] = INVALID_PLAYER_ID;
    PlayerData[playerid][pSpamTime] = 0;
    PlayerData[playerid][pMuted] = 0;
    PlayerData[playerid][pShowLands] = 0;
    PlayerData[playerid][pShowTurfs] = 0;
    PlayerData[playerid][pStreamType] = MUSIC_NONE;
    PlayerData[playerid][pFreeNamechange] = 0;
    PlayerData[playerid][pCurrentVehicle] = 0;
    PlayerData[playerid][pVehicleCount] = 0;
    PlayerData[playerid][pACWarns] = 0;
    PlayerData[playerid][pACTime] = 0;
    PlayerData[playerid][pArmorTime] = 0;
    PlayerData[playerid][pDrugsUsed] = 0;
    PlayerData[playerid][pDrugsTime] = 0;
    PlayerData[playerid][pCondom] = 0;
    PlayerData[playerid][pBandana] = 0;
    PlayerData[playerid][pLoginCamera] = 0;
    PlayerData[playerid][pPoisonTime] = 0;
    PlayerData[playerid][pWatchOn] = 0;
    PlayerData[playerid][pGPSOn] = 0;
    PlayerData[playerid][pTextFrom] = INVALID_PLAYER_ID;
    PlayerData[playerid][pWhisperFrom] = INVALID_PLAYER_ID;
    PlayerData[playerid][pMechanicCall] = 0;
    PlayerData[playerid][pTaxiCall] = 0;
    PlayerData[playerid][pEmergencyCall] = 0;
    PlayerData[playerid][pFindTime] = 0;
    PlayerData[playerid][pFindPlayer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pRemoveFrom] = INVALID_PLAYER_ID;
    PlayerData[playerid][pSniper] = 0;
    PlayerData[playerid][pDropTime] = 0;
    PlayerData[playerid][pRapidFire] = 0;
    PlayerData[playerid][pGodmode] = 0;
    PlayerData[playerid][pGodmodeHP] = 100.0;
    PlayerData[playerid][pGodmodeAP] = 0.0;
    PlayerData[playerid][pPreviewHouse] = -1;
    PlayerData[playerid][pPreviewType] = 0;
    PlayerData[playerid][pPreviewTime] = 0;
    PlayerData[playerid][pDamageTimer] = -1;
    PlayerData[playerid][pHHCheck] = 0;
    PlayerData[playerid][pHHTime] = 0;
    PlayerData[playerid][pHHRounded] = 0;
    PlayerData[playerid][pHHCount] = 0;
    PlayerData[playerid][pNoDamage] = 0;
    PlayerData[playerid][pGovTimer] = 0;
    PlayerData[playerid][pGodshand] = 0;
    PlayerData[playerid][pUndercover][0] = 0;
    PlayerData[playerid][pUndercover][1] = 0;
    PlayerData[playerid][pUndercoverHP] = 0.0;
    PlayerData[playerid][pUndercoverAR] = 0.0;
    PlayerData[playerid][pHurt] = 0;
    PlayerData[playerid][pBugged] = 0;
    PlayerData[playerid][pBuggedBy] = 0;
    PlayerData[playerid][pSweep] = 0;
    PlayerData[playerid][pSweepLeft] = 0;
    PlayerData[playerid][pRccam] = 0;
    PlayerData[playerid][pSkates] = 0;
    PlayerData[playerid][pSkateObj] = 0;
    PlayerData[playerid][pSkating] = false;
    PlayerData[playerid][pRareTime] = 0;
    PlayerData[playerid][pDiamonds] = 0;
    PlayerData[playerid][pDeleteMode] = 0;
    PlayerData[playerid][pAdvertWarnings] = 0;
    PlayerData[playerid][pNoKnife] = 0;
    PlayerData[playerid][pExecute] = 0;
    PlayerData[playerid][pMarriedTo] = 0;
    PlayerData[playerid][pStationEdit] = 0;
    PlayerData[playerid][pBlindfold] = 0;
    PlayerData[playerid][pBlinded] = 0;
    PlayerData[playerid][pWhitelist] = 0;


    for (new i = 0; i < MAX_PLAYERS; i ++)
    {
        chattingWith[playerid][i] = false;
    }

    for (new i = 0; i < 13; i ++)
    {
        PlayerData[playerid][pWeapons][i] = 0;
        PlayerData[playerid][pTempWeapons][i] = 0;
    }

    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
    {
        ClothingInfo[playerid][i][cExists] = 0;
        ClothingInfo[playerid][i][cID] = 0;
        ClothingInfo[playerid][i][cName] = 0;
        ClothingInfo[playerid][i][cModel] = 0;
        ClothingInfo[playerid][i][cBone] = 0;
        ClothingInfo[playerid][i][cAttached] = 0;
        ClothingInfo[playerid][i][cAttachedIndex] = -1;
    }

    // Reset the player's client attributes.
    for (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i ++)
    {
        if (IsPlayerAttachedObjectSlotUsed(playerid, i))
        {
            RemovePlayerAttachedObject(playerid, i);
        }
    }

    ResetPlayerWeapons(playerid);
    StopAudioStreamForPlayer(playerid);

    // GPS
    PlayerData[playerid][pGPSText] = CreatePlayerTextDraw(playerid, 88.000000, 323.000000, "Loading...");
    PlayerTextDrawAlignment(playerid, PlayerData[playerid][pGPSText], 2);
    PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pGPSText], 255);
    PlayerTextDrawFont(playerid, PlayerData[playerid][pGPSText], 1);
    PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pGPSText], 0.260000, 1.300000);
    PlayerTextDrawColor(playerid, PlayerData[playerid][pGPSText], -1);
    PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pGPSText], 1);
    PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pGPSText], 1);

    // HP & armor
    if (IsMobile(playerid))
    {
        PlayerData[playerid][pArmorText] = CreatePlayerTextDraw(playerid, 538.000000, 80.500000, "100");
    }
    else
    {
        PlayerData[playerid][pArmorText] = CreatePlayerTextDraw(playerid, 577.000000, 43.500000, "100");
    }
    PlayerTextDrawAlignment(playerid, PlayerData[playerid][pArmorText], 2);
    PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pArmorText], 255);
    PlayerTextDrawFont(playerid, PlayerData[playerid][pArmorText], 2);
    PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pArmorText], 0.220000, 1.100000);
    PlayerTextDrawColor(playerid, PlayerData[playerid][pArmorText], -1);
    PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pArmorText], 1);
    PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pArmorText], 1);

    if (IsMobile(playerid))
    {
        PlayerData[playerid][pHealthText] = CreatePlayerTextDraw(playerid, 538.000000, 65.500000, "100");
    }
    else
    {
        PlayerData[playerid][pHealthText] = CreatePlayerTextDraw(playerid, 577.000000, 65.500000, "100");
    }
    PlayerTextDrawAlignment(playerid, PlayerData[playerid][pHealthText], 2);
    PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pHealthText], 255);
    PlayerTextDrawFont(playerid, PlayerData[playerid][pHealthText], 2);
    PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pHealthText], 0.220000, 1.100000);
    PlayerTextDrawColor(playerid, PlayerData[playerid][pHealthText], -1);
    PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pHealthText], 1);
    PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pHealthText], 1);


    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (IsPlayerNPC(playerid)) return 1;

    KillTimer(PlayerData[playerid][pIntroKickTimer]);

    InsideShamal[playerid] = INVALID_VEHICLE_ID;

    chosednumber[playerid] = -1;
    DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
    PlayerData[playerid][aMeStatus] = 0;
    if (PlayerData[playerid][pCalling] > 0)
    {
        HangupCall(playerid);
    }
    DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
    fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
    PlayerData[playerid][pCarryCrate] = -1;
    PlayerData[playerid][pRobHouse] = -1;

    foreach(new i : Player)
    {
        if (PlayerData[i][pHouseOffer] == playerid)
        {
            PlayerData[i][pHouseOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pGarageOffer] == playerid)
        {
            PlayerData[i][pGarageOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pBizOffer] == playerid)
        {
            PlayerData[i][pBizOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pCarOffer] == playerid)
        {
            PlayerData[i][pCarOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pFactionOffer] == playerid)
        {
            PlayerData[i][pFactionOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pGangOffer] == playerid)
        {
            PlayerData[i][pGangOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pFriskOffer] == playerid)
        {
            PlayerData[i][pFriskOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pTicketOffer] == playerid)
        {
            PlayerData[i][pTicketOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pLiveOffer] == playerid)
        {
            PlayerData[i][pLiveOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pLiveBroadcast] == playerid)
        {
            PlayerData[i][pLiveBroadcast] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pShakeOffer] == playerid)
        {
            PlayerData[i][pShakeOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pLandOffer] == playerid)
        {
            PlayerData[i][pLandOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pSellOffer] == playerid)
        {
            PlayerData[i][pSellOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pAllianceOffer] == playerid)
        {
            PlayerData[i][pSellOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[playerid][pGangOffer] == playerid)
        {
            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pDefendOffer] == playerid)
        {
            PlayerData[i][pDefendOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pDiceOffer] == playerid)
        {
            PlayerData[i][pDiceOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pInviteOffer] == playerid)
        {
            PlayerData[i][pInviteOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pRobberyOffer] == playerid)
        {
            PlayerData[i][pRobberyOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pMarriageOffer] == playerid)
        {
            PlayerData[i][pMarriageOffer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pTextFrom] == playerid)
        {
            PlayerData[i][pTextFrom] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pWhisperFrom] == playerid)
        {
            PlayerData[i][pWhisperFrom] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pFindPlayer] == playerid)
        {
            PlayerData[i][pFindPlayer] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pRemoveFrom] == playerid)
        {
            PlayerData[i][pRemoveFrom] = INVALID_PLAYER_ID;
        }
        if (chattingWith[i][playerid])
        {
            SendClientMessageEx(i, COLOR_YELLOW, "Your chat with %s (ID %i) has ended as they left the server.", GetRPName(playerid), playerid);
            chattingWith[i][playerid] = false;
        }
        if (PlayerData[i][pActiveReport] >= 0 && (ReportInfo[PlayerData[i][pActiveReport]][rHandledBy] == playerid || ReportInfo[PlayerData[i][pActiveReport]][rReporter] == playerid))
        {
            if (ReportInfo[PlayerData[i][pActiveReport]][rReporter] == playerid)
                SendClientMessage(i, COLOR_GREEN, "The player who made the report has left the server.");
            else if (ReportInfo[PlayerData[i][pActiveReport]][rHandledBy] == playerid)
                SendClientMessage(i, COLOR_GREEN, "The admin who accepted the report has left the server.");

            ReportInfo[PlayerData[i][pActiveReport]][rExists] = 0;
            PlayerData[i][pActiveReport] = -1;
        }
        if (PlayerData[i][pContractTaken] == playerid)
        {
            SendClientMessage(i, COLOR_YELLOW, "Your contract target has disconnected from the server.");
            PlayerData[i][pContractTaken] = INVALID_PLAYER_ID;
        }
        if (PlayerData[i][pDraggedBy] == playerid)
        {
            SendClientMessage(i, COLOR_AQUA, "The person dragging you has disconnected. You are free!");
            PlayerData[i][pDraggedBy] = INVALID_PLAYER_ID;
        }
    }

    if (PlayerData[playerid][pLogged] && GetPVarInt(playerid, "EventToken") == 0)
    {
        if (PlayerData[playerid][pUndercover][0])
        {
            calldb::OnUndercover(playerid, 0, "", 0, 0.0, 0.0);
        }
        if (PlayerData[playerid][pHurt])
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s possibly left the server while in a gunfight.", GetRPName(playerid));
            PlayerData[playerid][pInjured] = gettime();
        }
        SavePlayerVariables(playerid);

        if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0)
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s left the server while tazed or cuffed.", GetRPName(playerid));
            ResetPlayerWeaponsEx(playerid);

            DBQuery("UPDATE "#TABLE_USERS" SET jailtype = 2, jailtime = 9000, prisonedby = 'Server', prisonreason = 'Logging to avoid arrest' WHERE uid = %i", PlayerData[playerid][pID]);
        }
    }
    if (PlayerData[playerid][pActiveReport] >= 0)
    {
        callcmd::cr(playerid, "\1");
    }

    if (IsValidDynamicObject(PlayerData[playerid][pEditObject]))
    {
        DestroyDynamicObject(PlayerData[playerid][pEditObject]);
    }
    if (IsValidDynamic3DTextLabel(PlayerData[playerid][pSpecialTag]))
    {
        DestroyDynamic3DTextLabel(PlayerData[playerid][pSpecialTag]);
    }
    if (IsValidDynamicObject(PlayerData[playerid][pBombObject]))
    {
        DestroyDynamicObject(PlayerData[playerid][pBombObject]);
    }
    if (PlayerData[playerid][pAdminDuty])
    {
        SetPlayerName(playerid, PlayerData[playerid][pUsername]);
    }

    if (PlayerData[playerid][pLogged])
    {
        foreach(new i: Vehicle)
        {
            if (IsVehicleOwner(playerid, i) && VehicleInfo[i][vTimer] == -1)
            {
                VehicleInfo[i][vTimer] = SetTimerEx("DespawnTimer", 600000, false, "i", i);
            }
        }
    }
    for (new i = 0; i < MAX_REPORTS; i ++)
    {
        if (ReportInfo[i][rExists] && ReportInfo[i][rReporter] == playerid)
        {
            ReportInfo[i][rExists] = 0;
        }
    }

    switch (reason)
    {
        case 0: SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "%s has left the server. (Timeout)", GetRPName(playerid));
        case 1: SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "%s has left the server. (Leaving)", GetRPName(playerid));
        case 2: SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "%s has left the server. (Kicked)", GetRPName(playerid));
    }
    if (PlayerData[playerid][pGang] >= 0)
    {
        SendGangMessage(PlayerData[playerid][pGang], COLOR_AQUA, "(( %s has disconnected ))", GetRPName(playerid));
    }
    DBQuery("DELETE FROM shots WHERE (playerid = %i) OR (hitid = %i AND hittype = 1)", playerid, playerid);

    return 1;
}


public OnPlayerSpawn(playerid)
{

    if (PlayerData[playerid][pKicked]) return 0;

    if (PlayerLogin(playerid))
    {
        return 0;
    }

    if (InsideShamal[playerid] != INVALID_VEHICLE_ID)
    {
        SetPlayerPos(playerid, GetPVarFloat(playerid, "air_Xpos"), GetPVarFloat(playerid, "air_Ypos"), GetPVarFloat(playerid, "air_Zpos"));
        SetPlayerFacingAngle(playerid, GetPVarFloat(playerid, "air_Rpos"));

        DeletePVar(playerid, "air_Xpos");
        DeletePVar(playerid, "air_Ypos");
        DeletePVar(playerid, "air_Zpos");
        DeletePVar(playerid, "air_Rpos");
        DeletePVar(playerid, "air_HP");
        DeletePVar(playerid, "air_Arm");

        SetCameraBehindPlayer(playerid);
        SetPlayerVirtualWorld(playerid, InsideShamal[playerid]);
        return SetPlayerInterior(playerid, 1);
    }

    DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
    fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;

    if (PlayerData[playerid][pSetup])
    {
        StartTutorial(playerid);
    }
    else if (PlayerData[playerid][pJailTime] > 0)
    {
        SpawnPlayerInJail(playerid);

        if (PlayerData[playerid][pJailType] == JailType_OOCPrison)
        {
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "* You were placed in admin prison by %s, reason: %s", PlayerData[playerid][pJailedBy], PlayerData[playerid][pJailReason]);
        }
        else
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You haven't completed your jail sentence yet.");
        }
    }
    else if (PlayerData[playerid][pPaintball] > 0)
    {
        SetPlayerInPaintball(playerid, PlayerData[playerid][pPaintball]);
    }
    else
    {

        if (PlayerData[playerid][pInjured])
        {
            SetPlayerHealth(playerid, 100.0);
            SetPlayerArmour(playerid, 0.0);
            ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 0, 0, 0, 1, 0, 1);

            GameTextForPlayer(playerid, "~r~Injured~n~~w~/phone or~n~/accept death", 5000, 3);
            SendClientMessageEx(playerid, COLOR_DOCTOR, "You are injured and losing blood. /call %d for medical attention.", PhoneNumber_Emergency);
            SendClientMessage(playerid, COLOR_DOCTOR, "If you wish to accept your death and go to hospital use /accept death.");
        }
        else if (PlayerData[playerid][pHospital])
        {
            if (PlayerData[playerid][pInsurance] == 0)
                SetPlayerInHospital(playerid);
            else
                SetPlayerInHospital(playerid, .type = PlayerData[playerid][pInsurance]);

            ResetPlayerWeaponsEx(playerid);
        }
        else
        {

            SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
            SetScriptArmour(playerid, PlayerData[playerid][pArmor]);
        }

        if (!PlayerData[playerid][pHospital])
        {
            if (IsDueling(playerid))
            {
                EndDuel(playerid);
            }
            if (PlayerData[playerid][pInjured])
            {
                    if (PlayerData[playerid][pInterior] || PlayerData[playerid][pWorld])
                    {
                        SetTimerEx("StreamedCheck", 1000, false, "ifffii", playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ], PlayerData[playerid][pInterior], PlayerData[playerid][pWorld]);
                    }
                    SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
                    SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
                    SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
                    SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
                    SetPlayerWeapons(playerid);
                    SetCameraBehindPlayer(playerid);
            }
            else
            {
                switch (PlayerData[playerid][pSpawnSelect])
                {
                    case 0:
                    {
                        if (PlayerData[playerid][pInterior] || PlayerData[playerid][pWorld])
                        {
                            SetTimerEx("StreamedCheck", 1000, false, "ifffii", playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ], PlayerData[playerid][pInterior], PlayerData[playerid][pWorld]);
                        }
                        SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
                        SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
                        SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
                        SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
                        SetPlayerWeapons(playerid);
                        SetCameraBehindPlayer(playerid);
                    }
                    case 1:
                    {
                        new houseid = PlayerData[playerid][pSpawnHouse];
                        if (HouseInfo[houseid][hExists] && IsHouseOwner(playerid, houseid))
                        {
                            SetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
                            SetPlayerFacingAngle(playerid, HouseInfo[houseid][hPosA]);
                            SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
                            SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
                            SetPlayerWeapons(playerid);
                            SetCameraBehindPlayer(playerid);
                        }
                        else
                        {
                            SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
                            SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
                            SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
                            SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
                            SetPlayerWeapons(playerid);
                            SetCameraBehindPlayer(playerid);
                        }
                    }
                    case 2:
                    {
                        new factionid = PlayerData[playerid][pFaction];
                        if (factionid != -1)
                        {
                            for (new i = 0; i < MAX_LOCKERS; i ++)
                            {
                                if (LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
                                {
                                    SetPlayerPos(playerid, LockerInfo[i][lPosX], LockerInfo[i][lPosY], LockerInfo[i][lPosZ]);
                                    SetPlayerFacingAngle(playerid, 90.0);
                                    SetPlayerInterior(playerid, LockerInfo[playerid][lInterior]);
                                    SetPlayerVirtualWorld(playerid, LockerInfo[playerid][lWorld]);
                                    SetPlayerWeapons(playerid);
                                    SetCameraBehindPlayer(playerid);
                                }
                            }
                        }
                        else
                        {
                            SetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
                            SetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);
                            SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
                            SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
                            SetPlayerWeapons(playerid);
                            SetCameraBehindPlayer(playerid);
                        }
                    }
                }
            }
        }
    }

    if (PlayerData[playerid][pAdminDuty])
    {
        SetPlayerSkin(playerid, ADMIN_SKIN);
    }
    else if (PlayerData[playerid][pAcceptedHelp])
    {
        SetPlayerSkin(playerid, HELPER_SKIN);
    }
    else
    {
        SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
    }
    SetPlayerFightingStyle(playerid, PlayerData[playerid][pFightStyle]);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 998);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 998);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 998);
    SetPlayerClothing(playerid);
    RefreshPlayerTextdraws(playerid);

    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{

    if ((gettime() - PlayerData[playerid][pLastDeath]) < 2)
    {
        return 1;
    }

    if (GetPVarInt(playerid, "Mobile") != 501)
    {
        if (IsPlayerConnected(GetPVarInt(playerid, "Mobile")) && GetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile") == playerid)
        {
            SendClientMessage(GetPVarInt(playerid, "Mobile"),COLOR_GREY,"The phone line went dead...");
            if (GetPlayerSpecialAction(GetPVarInt(playerid, "Mobile")) == SPECIAL_ACTION_USECELLPHONE) SetPlayerSpecialAction(GetPVarInt(playerid, "Mobile"), SPECIAL_ACTION_STOPUSECELLPHONE);
            SetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile", 501);
        }
        SetPVarInt(playerid, "Mobile", 501);
    }
    foreach(new i : Player)
    {
        if (IsAdmin(i, ADMIN_LVL_6) || PlayerData[i][pAdminDuty])
        {
            if (PlayerData[playerid][pInjured] == 0)
            {
                SendDeathMessageToPlayer(i, killerid, playerid, reason);
            }
        }
    }

    if (IsAdmin(playerid) && IsAdminOnDuty(playerid, false) && IsPlayerConnected(killerid))
    {
        AwardAchievement(killerid, ACH_BlackHole);
    }

    if (PlayerData[playerid][pLogged])
    {
        if (IsPlayerInEvent(playerid))
        {
            CallRemoteFunction("OnEventPlayerDeath", "iiii", GetPVarInt(playerid, "EventToken"), playerid, killerid, reason);
        }
        else if (PlayerData[playerid][pPaintball] > 0)
        {
            foreach(new i : Player)
            {
                if (PlayerData[playerid][pPaintball] == PlayerData[i][pPaintball])
                {
                    if (killerid == INVALID_PLAYER_ID)
                        SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s died. ))", GetRPName(playerid));
                    else
                        SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s was killed by %s. ))", GetRPName(playerid), GetRPName(killerid));

                }
            }
        }
        else
        {
            if (killerid != INVALID_PLAYER_ID)
            {
                HandleContract(playerid, killerid);
            }

            if (GetWantedLevel(playerid) == 6 && PlayerData[playerid][pJailType] == JailType_None)
            {
                ArrestPlayer(playerid, "Most wanted");
            }

            if (!PlayerData[playerid][pAcceptedHelp] &&
                !PlayerData[playerid][pAdminDuty] &&
                PlayerData[playerid][pJailType] == JailType_None &&
                PlayerData[playerid][pPreviewHouse] == -1)
            {
                if (PlayerData[playerid][pInjured] == 0)
                {
                    if (IsPlayerConnected(killerid))
                    {
                        if (PlayerData[playerid][pAdminDuty] == 0 && PlayerData[killerid][pAdminDuty] == 0 )
                        {
                            if (IsLawEnforcement(playerid) && !IsLawEnforcement(killerid))
                            {
                                GiveNotoriety(killerid, 1000);
                                SendClientMessageEx(killerid, COLOR_AQUA, "You have gained 1000 notoriety for killing a law enforcement member, you now have %d.", PlayerData[killerid][pNotoriety]);
                            }
                            else if (GetPlayerFaction(playerid) == FACTION_GOVERNMENT && GetPlayerFaction(killerid) != FACTION_GOVERNMENT)
                            {
                                GiveNotoriety(killerid, 3000);
                                SendClientMessageEx(killerid, COLOR_AQUA, "You have gained 1000 notoriety for killing a government agent, you now have %d.", PlayerData[killerid][pNotoriety]);
                            }
                            else if (GetPlayerFaction(playerid) == FACTION_HITMAN)
                            {
                                GiveNotoriety(killerid, 500);
                                SendClientMessageEx(killerid, COLOR_AQUA, "You have gained 500 notoriety for killing a civil servant, you now have %d.", PlayerData[killerid][pNotoriety]);
                            }
                            else if (PlayerData[playerid][pBandana] && PlayerData[killerid][pBandana])
                            {
                                GiveNotoriety(killerid, 100);
                                SendClientMessageEx(killerid, COLOR_AQUA, "You have gained 100 notoriety for killing a rival gang member, you now have %d.", PlayerData[killerid][pNotoriety]);
                            }
                            else
                            {
                                GiveNotoriety(killerid, 200);
                                SendClientMessageEx(killerid, COLOR_AQUA, "You have gained 200 notoriety for killing a civilian, you now have %d.", PlayerData[killerid][pNotoriety]);
                            }
                        }
                    }
                    ResetPlayer(playerid);
                    PlayerData[playerid][pInjured] = gettime();
                    foreach(new i : Player)
                    {
                        if (GetPlayerFaction(i) == FACTION_MEDIC)
                        {
                            SendClientMessageEx(i, 0xEC004DFF,
                                                "Dispatch: {FFFFFF}Beacon (%i) %s [%i hp] is in need of immediate medical assistance.",
                                                playerid, GetRPName(playerid), GetPlayerHealthEx(playerid));
                        }
                    }
                }
                else
                {
                    GiveNotoriety(playerid, -5);
                    SendClientMessageEx(playerid, COLOR_AQUA, "You have lost -5 notoriety as you died, you now have %d.", PlayerData[playerid][pNotoriety]);

                    PlayerData[playerid][pInjured] = 0;
                    PlayerData[playerid][pHospital] = 1;
                    if (PlayerData[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
                    {
                        SendClientMessageEx(PlayerData[playerid][pAcceptedEMS], COLOR_YELLOW, "Your patient %s has bled out.", GetRPName(playerid));
                        PlayerData[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
                    }

                    if (PlayerData[playerid][pDraggedBy] != INVALID_PLAYER_ID)
                    {
                        PlayerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
                    }
                }
            }
            else
            {
                PlayerData[playerid][pHealth] = 32767.0;
            }

            if (killerid != INVALID_PLAYER_ID)
            {
                DBQuery("INSERT INTO kills VALUES(null, %i, %i, '%e', '%e', '%e', NOW())", PlayerData[killerid][pID], PlayerData[playerid][pID], GetPlayerNameEx(killerid), GetPlayerNameEx(playerid), GetDeathReason(reason));
            }

            GetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);

            PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
            PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
        }
    }



    if (reason == 50 && killerid != INVALID_PLAYER_ID)
    {
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] was helibladed by %s[%i].", GetRPName(playerid), playerid, GetRPName(killerid), killerid);
    }

    PlayerData[playerid][pLastDeath] = gettime();
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{

    IsPlayerSteppingInVehicle[playerid] = vehicleid;
    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
    {
        new Float:x;
        new Float:y;
        new Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z + 0.5);
        ClearAnimations(playerid);
    }

    if ((!ispassenger) && (PlayerData[playerid][pCuffed] || PlayerData[playerid][pTied] || PlayerData[playerid][pInjured]))
    {
        new Float:x;
        new Float:y;
        new Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z + 0.5);
        ClearAnimations(playerid);
    }

    if (!ispassenger)
    {
        if (IsJobCar(vehicleid) && !CanEnterJobCar(playerid,vehicleid))
        {
            if (GetVehicleModel(vehicleid) == 515)
                SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a master Trucker.");
            else
                SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a %s.",GetJobName(GetCarJobType(vehicleid)));
            ClearAnimations(playerid);
        }

        if ((testVehicles[0] <= vehicleid <= testVehicles[4]) && !PlayerData[playerid][pDrivingTest])
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not taking your drivers test.");
            ClearAnimations(playerid);
        }
        if (VehicleInfo[vehicleid][vFaction] != -1 && PlayerData[playerid][pFaction] != VehicleInfo[vehicleid][vFaction])
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as it doesn't belong to your faction.");
            ClearAnimations(playerid);
        }
        else if (VehicleInfo[vehicleid][vFaction] != -1 && VehicleInfo[vehicleid][vRank] > PlayerData[playerid][pFactionRank])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you aren't a rank %i in your faction.", VehicleInfo[vehicleid][vRank]);
            ClearAnimations(playerid);
        }
        else if (VehicleInfo[vehicleid][vFGDivision] != -1 && VehicleInfo[vehicleid][vFGDivision]!=PlayerData[playerid][pDivision])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you aren't %s in your faction.",
            FactionDivisions[PlayerData[playerid][pFaction]][VehicleInfo[vehicleid][vFGDivision]]);
            ClearAnimations(playerid);
        }
        if (VehicleInfo[vehicleid][vGang] >= 0 && PlayerData[playerid][pGang] != VehicleInfo[vehicleid][vGang])
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as it doesn't belong to your gang.");
            ClearAnimations(playerid);
        }
        else if (VehicleInfo[vehicleid][vGang] >= 0 && VehicleInfo[vehicleid][vRank] > PlayerData[playerid][pGangRank])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you aren't a rank %i in your gang.", VehicleInfo[vehicleid][vRank]);
            ClearAnimations(playerid);
        }
        if (VehicleInfo[vehicleid][vJob] >= 0 && PlayerData[playerid][pJob] != VehicleInfo[vehicleid][vJob])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a %s.", GetJobName(VehicleInfo[vehicleid][vJob]));
            ClearAnimations(playerid);
        }
        if (VehicleInfo[vehicleid][vVIP] > 0 && PlayerData[playerid][pDonator] < VehicleInfo[vehicleid][vVIP])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a %s VIP+.", GetVIPRank(VehicleInfo[vehicleid][vVIP]));
            ClearAnimations(playerid);
        }
    }
    seatbelt[playerid] = 0;
    return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{

    if (gParachutes[0] <= pickupid <= gParachutes[1])
    {
        GivePlayerWeaponEx(playerid, 46);
    }

    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if (!IsValidWeaponID(weaponid))
    {
        return 0;
    }
    if ((22 <= weaponid <= 36) && damagedid != INVALID_PLAYER_ID && !PlayerHasWeapon(playerid, weaponid, true) && !IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pKicked])
    {
        SendAdminWarning(2, "%s[%i] has a desynced %s (trying weapon sync).", GetRPName(playerid), playerid, GetWeaponNameEx(weaponid));
        ResetPlayerWeapons(playerid);
        SetPlayerWeapons(playerid);
        return 0;
    }

    if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
    {
        if (IsPlayerConnected(damagedid))
        {
            SendAdminWarning(2, "%s[%i] is giving damage to %s[%i] while in spectate mod", GetRPName(playerid), playerid, GetRPName(damagedid), damagedid);
        }
        else
        {
            SendAdminWarning(2, "%s[%i] is giving damage to INVALID_PLAYER_ID while in spectate mod", GetRPName(playerid), playerid);
        }
        return 0;
    }

    if ((damagedid != INVALID_PLAYER_ID && weaponid == 23) && ((IsLawEnforcement(playerid) || GetPlayerFaction(playerid) == FACTION_GOVERNMENT) && PlayerData[playerid][pTazer] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) && amount > 5.0)
    {
        if (PlayerData[damagedid][pAdminDuty])
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't taze an administrator currently on duty.");
            return 0;
        }
        if (PlayerData[damagedid][pAcceptedHelp])
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't taze a helper on duty.");
            return 0;
        }
        if (PlayerData[damagedid][pTazedTime])
        {
            return SendClientMessage(playerid, COLOR_GREY, "This player has already been tazed.");
        }
        if (!IsPlayerNearPlayer(playerid, damagedid, 10.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't taze that player. They are too far from you.");
        }
        if ((22 <= GetPlayerWeapon(damagedid) <= 38) && IsPlayerAiming(damagedid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Rush-tazing is forbidden. This means tazing a player who is aiming a gun at you.");
        }
        if (IsPlayerInAnyVehicle(damagedid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't taze a player who is in a vehicle.");
        }
        new turfid = GetNearbyTurf(damagedid);
        if (turfid != -1 && IsActiveTurf(turfid))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "You can't taze a player in active turf.");
        }

        PlayerData[damagedid][pTazedTime] = 10;
        TogglePlayerControllableEx(damagedid, 0);

        ApplyAnimation(damagedid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0);
        GameTextForPlayer(damagedid, "~r~Tazed", 5000, 3);

        ShowActionBubble(playerid, "* %s aims their tazer full of electricity at %s and stuns them.", GetRPName(playerid), GetRPName(damagedid));
        SendClientMessageEx(damagedid, COLOR_AQUA, "You've been {FF6347}stunned{33CCFF} with electricity by %s's tazer.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have stunned %s with electricity. They are disabled for 10 seconds.", GetRPName(damagedid));
        return 0;
    }

    if (PlayerData[playerid][pToggleHUD] && IsPlayerConnected(playerid))
    {
        new string[50];
        format(string, sizeof(string), "~g~%.0f damage.", amount);
        ShowDamageString(playerid, string);
    }

    if (damagedid != INVALID_PLAYER_ID && IsPlayerConnected(damagedid) && weaponid != -1)
    {
        AddDamages(playerid, damagedid, weaponid, bodypart, amount);
        DBQuery("INSERT INTO shots VALUES(null, %i, %i, %i, %i, '%e', '0.0', '0.0', '0.0', %i)", playerid, weaponid, BULLET_HIT_TYPE_PLAYER, damagedid, GetPlayerNameEx(damagedid), gettime());
    }

    if (!PlayerData[playerid][pNoKnife] && bodypart == 9 && GetPlayerState(playerid) != PLAYER_STATE_WASTED && GetPlayerFaction(playerid) == FACTION_HITMAN && IsPlayerIdle(playerid))
    {
        SetPlayerHealth(damagedid, 0);
        ShowPlayerFooter(playerid, "Headshot", 2000);
        ShowPlayerFooter(damagedid, "Headshot", 2000);
    }
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    if (IsPlayerPaused(playerid) && !PlayerData[playerid][pHurt])
    {
        if (IsInSameActiveTurf(playerid, issuerid))
        {
            return 1;
        }
        //TODO: Message Displayed when someone using knife try to kill someone and that one press escape
        GameTextForPlayer(issuerid, "That player is AFK!", 5000, 3);
        return 0;
    }
    if (PlayerData[playerid][pNoDamage])
    {
        return 0;
    }
    if (IsPlayerConnected(issuerid))
    {
        if (weaponid == 4 && PlayerHasWeapon(issuerid, 4) && IsPlayerNearPlayer(playerid, issuerid, 20.0) && amount > 100.0)
        {
            SetPlayerHealth(playerid, 0.0);
            HandleContract(playerid, issuerid);
        }

        if (PlayerData[playerid][pToggleHUD] == 0)
        {
            new string[50];
            format(string, sizeof(string), "~r~Damage: %s hit you for %.0f damage.", GetRPName(issuerid), amount);
            ShowDamageString(playerid, string);
        }
        if (IsValidDamageWeapon(weaponid) && GetWeaponDamage(weaponid) != 0.0 && PlayerData[issuerid][pTazer] == 0)
        {
            ProcessDamage(playerid, weaponid);
        }

    }
    PlayerData[playerid][pHurt] = 10;
    return 1;
}

public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
    if (PlayerData[playerid][pDeleteMode])
    {
        PlayerData[playerid][pSelected] = objectid;
        ShowDialogToPlayer(playerid, DIALOG_DELETEOBJECT);
    }

    return 1;
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if (weaponid < 0 || weaponid > 47)
    {
        return 0;// Anti-WeaponId change hack
    }
    if (hittype == BULLET_HIT_TYPE_PLAYER && !IsPlayerConnected(hitid))
    {
        return 0;
    }

    if (!CanPlayerShootWithWeapon(playerid, weaponid, hittype, hitid))
    {
        return 0;
    }

    if ((25 <= weaponid && weaponid <= 38) && hittype == BULLET_HIT_TYPE_VEHICLE && IsValidVehicle(hitid))
    {
        new driverid = GetVehicleDriver(hitid);

        if (IsPlayerConnected(driverid))
        {
            GivePlayerHealth(playerid, - GetWeaponDamage(weaponid) / 2.0);
        }
    }

    return 1;
}


public OnPlayerMenuResponse(playerid, extraid, response, listitem, modelid)
{
    switch (extraid)
    {
        case MODEL_SELECTION_CLOTHES:
        {
            if (response)
            {
                new
                    businessid = GetInsideBusiness(playerid);

                if (businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
                {
                    if (PlayerData[playerid][pDonator] == 0 && PlayerData[playerid][pCash] < 1000)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money. You can't buy new clothes.");
                    }
                    if ((PlayerData[playerid][pDonator] == 0 && GetPlayerFaction(playerid) != FACTION_POLICE && GetPlayerFaction(playerid) != FACTION_MEDIC) && (!(0 <= modelid <= 311) || (265 <= modelid <= 267) || (274 <= modelid <= 288) || (300 <= modelid <= 302) || (306 <= modelid <= 311)))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You are not allowed to use that skin as it is either invalid or faction reserved.");
                    }

                    if (PlayerData[playerid][pDonator] == 0)
                    {
                        new price = 1000;

                        if (PlayerData[playerid][pTraderUpgrade] > 0)
                        {
                            price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
                            SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
                        }

                        GivePlayerCash(playerid, -price);

                        PerformBusinessPurchase(playerid, businessid, price);

                        ShowActionBubble(playerid, "* %s paid %s to the shopkeeper and received a new set of clothes.", GetRPName(playerid), FormatCash(price));
                        SendClientMessageEx(playerid, COLOR_WHITE, "You've changed your clothes for $%i.", price);
                    }
                    else
                    {
                        SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You changed your clothes free of charge.");
                    }

                    SetScriptSkin(playerid, modelid);
                    SendClientMessageEx(playerid, -1, "%d", modelid);
                }
            }
        }
        case MODEL_SELECTION_CLOTHING:
        {
            if (response && listitem >=0)
            {
                new businessid = GetInsideBusiness(playerid);

                if (businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
                {
                    PreviewClothing(playerid, listitem + PlayerData[playerid][pClothingIndex]);
                }
            }
            else
            {
                ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
            }
        }
        case MODEL_SELECTION_COPCLOTHING:
        {
            if ((response) && IsLawEnforcement(playerid))
            {
                SetPlayerAttachedObject(playerid, 9, modelid, copClothing[listitem][cBone]);

                PlayerData[playerid][pEditType] = EDIT_COP_CLOTHING;
                PlayerData[playerid][pSelected] = listitem;

                SendClientMessageEx(playerid, COLOR_AQUA, "You have selected {FF6347}%s{33CCFF}. Use the editor to arrange your clothing and click the disk icon to save.", copClothing[listitem][cName]);
                EditAttachedObject(playerid, 9);
            }
        }
        case MODEL_SELECTION_VEHICLES:
        {
            if (response)
            {
                PlayerData[playerid][pSelected] = listitem;
                PurchaseVehicle(playerid);
            }
        }
        case MODEL_SELECTION_ADMIN_VEHICLES:
        {
            if (response)
            {
                new vehicleid = GivePlayerAdminVehicle(playerid, modelid, 1, 1);
                if (!IsValidVehicle(vehicleid))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Cannot spawn vehicle. The vehicle pool is currently full.");
                }
                else
                {
                    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s spawned a %s.", GetRPName(playerid), GetVehicleName(vehicleid));
                    SendClientMessageEx(playerid, COLOR_WHITE, "%s (ID %i) spawned. Use '/savevehicle %i' to save this vehicle to the database.", GetVehicleName(vehicleid), vehicleid, vehicleid);
                }
            }
        }
    }
    return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{

    if ((newinteriorid == 0) && IsPlayerInBankRobbery(playerid))
    {
        PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
    }

    /*if (PlayerData[playerid][pPreviewHouse] >= 0)
    {
        PlayerData[playerid][pPreviewHouse] = -1;
        PlayerData[playerid][pPreviewType] = 0;
        PlayerData[playerid][pPreviewTime] = 0;
        SendClientMessage(playerid, COLOR_GREY, "Preview cancelled. You left your house interior.");
    }*/

    return 1;
}

public OnPlayerUpdate(playerid)
{
    if (PlayerData[playerid][pKicked])
        return 0;

    if (!PlayerData[playerid][pLogged])
        return 1;

    if (GetPlayerWeapon(playerid)  == 38 &&  !IsAdmin(playerid, ADMIN_LVL_6)) // when they sync something which they should not!!!
    {
        RemovePlayerWeapon(playerid, 38);
        KickPlayer(playerid, "Using illegal weapon (Minigun)", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
    }
    if (GetPlayerWeapon(playerid)  == 35 &&  !IsAdmin(playerid, ADMIN_LVL_5)) // when they sync something which they should not!!!
    {
        RemovePlayerWeapon(playerid, 35);
        KickPlayer(playerid, "Using illegal weapon (Rocket Launcher)", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
    }
    if (GetPlayerWeapon(playerid)  == 36 &&  !IsAdmin(playerid, ADMIN_LVL_5)) // when they sync something which they should not!!!
    {
        RemovePlayerWeapon(playerid, 36);
        KickPlayer(playerid, "Using illegal weapon (HeatSteaker)", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
    }
    new weaponid = GetPlayerWeapon(playerid);
    { 
        if (weaponid &&  !IsAdmin(playerid, ADMIN_LVL_3))
        if (PlayerData[playerid][pLevel] < 2) // when they sync something which they should not!!!
        {
            ResetPlayerWeaponsEx(playerid);
            SavePlayerVariables(playerid);
            KickPlayer(playerid, "Weapon hacks", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
        }
    }
    new Float:CarHealth[MAX_PLAYERS];
    if (IsPlayerInAnyVehicle(playerid) == 1 && seatbelt[playerid] == 0)
    {
        new Float:TempCarHealth;
        GetVehicleHealth(GetPlayerVehicleID(playerid), TempCarHealth);
        new Float:Difference = floatsub(CarHealth[playerid], TempCarHealth);
        if ((floatcmp(CarHealth[playerid], TempCarHealth) == 1) && (floatcmp(Difference,100.0) == 1))
        {
            Difference = floatdiv(Difference, 10.0);
            new Float:OldHealth;
            GetPlayerHealth(playerid, OldHealth);
            SetPlayerHealth(playerid, floatsub(OldHealth, Difference));
        }
        CarHealth[playerid] = TempCarHealth;
    }
    else
    {
        CarHealth[playerid] = 0.0;
    }

    new vehicleid = GetPlayerVehicleID(playerid), string[128], drunkLevel = GetPlayerDrunkLevel(playerid);

    if (PlayerData[playerid][pCurrentVehicle] != vehicleid)
    {
        PlayerData[playerid][pCurrentVehicle] = vehicleid;
        PlayerData[playerid][pVehicleCount]++;

        if ((!IsABoat(vehicleid) && GetVehicleModel(vehicleid) != 539) && PlayerData[playerid][pVehicleCount] >= 4 && !IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pKicked])
        {
            BanPlayer(playerid, "Car warping");
            return 0;
        }
    }
    new keys, ud, lr;
    GetPlayerKeys(playerid, keys, ud, lr);

    if ((44 <= GetPlayerWeapon(playerid) <= 45) && keys & KEY_FIRE)
    {
        return 0;
    }

    if (!PlayerData[playerid][pToggleHUD] && !PlayerData[playerid][pToggleTextdraws] && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        new
            Float:health,
            Float:armour;

        GetPlayerHealth(playerid, health);
        GetPlayerArmour(playerid, armour);

        if (floatround(armour) > 0)
        {
            format(string, sizeof(string), "%.0f", armour);
            PlayerTextDrawSetString(playerid, PlayerData[playerid][pArmorText], string);
            PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
        }
        else
        {
            PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
        }

        format(string, sizeof(string), "%.0f", health);
        PlayerTextDrawSetString(playerid, PlayerData[playerid][pHealthText], string);
        PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);


    }

    if (GetPlayerWeapon(playerid) > 1 && PlayerData[playerid][pInjured])
    {
        SetPlayerArmedWeapon(playerid, 0);
    }
    if (PlayerData[playerid][pInjured])
    {
        format(string, sizeof(string), "(( Has been injured %d times, /damages %d for more information. ))",
            GetPlayerTotalDamages(playerid), playerid);
        SetPlayerChatBubble(playerid, string, COLOR_ADM, 30.0, 2000);
    }
    if (!drunkLevel)
    {
        SetPlayerDrunkLevel(playerid, 1000);
    }

    if (PlayerData[playerid][pDrunkLevel] != drunkLevel)
    {
        new value = PlayerData[playerid][pDrunkLevel] - drunkLevel;

        if (0 <= value <= 250)
        {
            PlayerData[playerid][pFPS] = value;
        }

        PlayerData[playerid][pDrunkLevel] = drunkLevel;
    }

    if (!GetPlayerInterior(playerid))
    {
        SetPlayerTime(playerid, gWorldTime, 0);
    }
    else
    {
        new garageid;

        if ((garageid = GetInsideGarage(playerid)) >= 0 && GarageInfo[garageid][gType] == 2)
            SetPlayerTime(playerid, 0, 0);
        else
            SetPlayerTime(playerid, 12, 0);
    }

    if ((keys & KEY_HANDBRAKE) && GetPlayerWeapon(playerid) == 34)
    {
        if (!PlayerData[playerid][pSniper])
        {
            for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
            {
                if (ClothingInfo[playerid][i][cAttached]) RemovePlayerAttachedObject(playerid, i);
            }

            PlayerData[playerid][pSniper] = 1;
        }
    }
    else if (PlayerData[playerid][pSniper])
    {
        SetPlayerClothing(playerid);
        PlayerData[playerid][pSniper] = 0;
    }
    if (PlayerData[playerid][pNoKnife] && GetPlayerWeapon(playerid) == 4)
    {
        SetPlayerArmedWeapon(playerid, 0);
    }
    return 1;
}


public OnPlayerText(playerid, text[])
{
    if (isnull(text))
    {
        return 0;
    }
    if (PlayerData[playerid][pLogged] && !PlayerData[playerid][pKicked])
    {
        text[0] = toupper(text[0]);
        if (IsPlayerInTutorial(playerid))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You are currently in the tutorial. Chatting is disabled.");
            return 0;
        }
        else if (PlayerData[playerid][pHospital])
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You are currently in the hospital. Chatting is disabled.");
            return 0;
        }
        else if (PlayerData[playerid][pMuted])
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You are currently muted. Chatting is disabled.");
            return 0;
        }
        else if (++PlayerData[playerid][pSpamTime] >= 4 && !IsAdmin(playerid, ADMIN_LVL_3))
        {
            PlayerData[playerid][pMuted] = 10;
            SendClientMessage(playerid, COLOR_YELLOW, "You've been temporarily muted by the server for ten seconds for spamming.");
            return 0;
        }
        else if (!IsAdmin(playerid, ADMIN_LVL_8) && CheckServerAd(text))
        {
            new string[128];
            format(string,sizeof(string),"{00aa00}AdmWarning{FFFF00}: %s (ID: %d) may be server advertising: '{00aa00}%s{FFFF00}'.", GetPlayerNameEx(playerid), playerid, text);
            SendAdminMessage(COLOR_YELLOW, string, 2);
            SendClientMessage(playerid, COLOR_GREY, "Your chat was blocked, you have automatically reported for server advertising.");
            if (++PlayerData[playerid][pAdvertWarnings] > MAX_ANTICHEAT_WARNINGS)
            {
                BanPlayer(playerid, "Server advertisement");
            }
            return 0;
        }
        else
        {
            new username[MAX_PLAYER_NAME];
            if (IsPlayerWearingMask(playerid))
                username = "Stranger";
            else
                username = GetRPName(playerid);

            new string[144];

            if (PlayerData[playerid][pCalling] > 1)
            {
                if (PlayerData[playerid][pCaller] != INVALID_PLAYER_ID)
                {

                    if (PlayerData[playerid][pSpeakerPhone])
                    {
                        SendNearbyMessage(playerid, 5.0, COLOR_YELLOW, "(SpeakerPhone) %s says: %s", username, text);
                    }
                    else
                    {
                        SendClientSplitMessageEx(playerid, COLOR_YELLOW, "(Phone) %s says: %s", GetRPName(playerid), text);
                    }

                    if (PlayerData[playerid][pPayphone] == -1)
                    {
                        if (PlayerData[PlayerData[playerid][pCaller]][pSpeakerPhone])
                        {
                            SendNearbyMessage(PlayerData[playerid][pCaller], 5.0, COLOR_YELLOW, "(SpeakerPhone) %s says: %s", username, text);
                        }
                        else
                        {
                            SendClientSplitMessageEx(PlayerData[playerid][pCaller], COLOR_YELLOW, "(Phone) %s says: %s", GetRPName(playerid), text);
                        }
                    }
                    else
                    {
                        if (PlayerData[PlayerData[playerid][pCaller]][pSpeakerPhone])
                        {
                            SendNearbyMessage(PlayerData[playerid][pCaller], 5.0, COLOR_YELLOW, "(SpeakerPhone) Unknown says: %s", text);
                        }
                        else
                        {
                            SendClientSplitMessageEx(PlayerData[playerid][pCaller], COLOR_YELLOW, "(Phone) Unknown says: %s", text);
                        }
                    }
                }
                else
                {
                    switch (PlayerData[playerid][pCalling])
                    {
                        case PhoneNumber_Emergency:
                        {
                            if (!strcmp(text, "Police", true))
                            {
                                SendClientMessage(playerid, COLOR_OLDSCHOOL, "Dispatch: This is the Los Santos Police Department. What is your emergency?");
                                PlayerData[playerid][pCalling] = PhoneNumber_Police;
                                PlayerData[playerid][pIsCaller] = true;
                            }
                            else if (!strcmp(text, "Medic", true))
                            {
                                SendClientMessage(playerid, COLOR_DOCTOR, "Dispatch: This is the Los Santos Fire & Medical Department. What is your emergency?");
                                PlayerData[playerid][pCalling] = 913;
                                PlayerData[playerid][pIsCaller] = true;
                            }
                            else
                            {
                                SendClientMessage(playerid, COLOR_YELLOW, "Dispatch: Sorry? I don't know what you mean... Enter 'police' or 'medic'.");
                            }
                        }
                        case PhoneNumber_Police:
                        {
                            foreach(new i : Player)
                            {
                                if (IsLawEnforcement(i))
                                {
                                    SendClientMessageEx(i, COLOR_OLDSCHOOL, "______ Emergency Hotline ______");
                                    SendClientMessageEx(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerData[playerid][pPhone]);
                                    SendClientMessageEx(i, COLOR_GREY2, "Location: %s", GetPlayerZoneName(playerid));
                                    SendClientMessageEx(i, COLOR_GREY2, "Emergency: %s", text);
                                    SendClientMessageEx(i, COLOR_WHITE, "* Use '/trackcall %i' to track the caller's location.", playerid);
                                }
                            }
                            strcpy(PlayerData[playerid][pEmergency], text, 128);
                            PlayerData[playerid][pEmergencyCall] = 120;
                            PlayerData[playerid][pEmergencyType] = FACTION_POLICE;
                            SendClientMessage(playerid, COLOR_OLDSCHOOL, "Dispatch: All units in the area have been notified. Thank you for your time.");
                            HangupCall(playerid);
                        }
                        case PhoneNumber_Medic:
                        {
                            foreach(new i : Player)
                            {
                                if (GetPlayerFaction(i) == FACTION_MEDIC)
                                {
                                    SendClientMessageEx(i, COLOR_DOCTOR, "______ Emergency Hotline ______");
                                    SendClientMessageEx(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerData[playerid][pPhone]);
                                    SendClientMessageEx(i, COLOR_GREY2, "Location: %s", GetPlayerZoneName(playerid));
                                    SendClientMessageEx(i, COLOR_GREY2, "Emergency: %s", text);
                                    SendClientMessageEx(i, COLOR_WHITE, "* Use '/trackcall %i' to track the caller's location.", playerid);
                                }
                            }
                            strcpy(PlayerData[playerid][pEmergency], text, 128);
                            PlayerData[playerid][pEmergencyCall] = 120;
                            PlayerData[playerid][pEmergencyType] = FACTION_MEDIC;
                            SendClientMessage(playerid, COLOR_DOCTOR, "Dispatch: All units in the area have been notified. Thank you for your time.");
                            HangupCall(playerid);
                        }
                        case PhoneNumber_News:
                        {
                            foreach(new i : Player)
                            {
                                if (GetPlayerFaction(i) == FACTION_NEWS)
                                {
                                    SendClientMessageEx(i, COLOR_NAVYBLUE, "______ News Hotline ______");
                                    SendClientMessageEx(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerData[playerid][pPhone]);
                                    SendClientMessageEx(i, COLOR_GREY2, "Message: %s", text);
                                }
                            }
                            SendClientMessage(playerid, COLOR_NAVYBLUE, "News Team: Thank you. We will get back to you shortly!");
                            HangupCall(playerid);
                        }
                        case PhoneNumber_Mechanic:
                        {
                            foreach(new i : Player)
                            {
                                if (PlayerHasJob(i, JOB_MECHANIC))
                                {
                                    SendClientMessageEx(i, COLOR_NAVYBLUE, "______ Mechanic Hotline ______");
                                    SendClientMessageEx(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerData[playerid][pPhone]);
                                    SendClientMessageEx(i, COLOR_GREY2, "Situation: %s", text);
                                    SendClientMessageEx(i, COLOR_WHITE, "* Use '/takecall %i' in order to take this call.", playerid);
                                }
                            }
                            PlayerData[playerid][pMechanicCall] = 60;
                            SendClientMessage(playerid, COLOR_LIGHTORANGE, "Dispatch: Thank you. We will alert all mechanics on duty.");
                            HangupCall(playerid);
                        }
                        case PhoneNumber_Taxi:
                        {
                            foreach(new i : Player)
                            {
                                if (PlayerHasJob(i, JOB_TAXIDRIVER))
                                {
                                    SendClientMessageEx(i, COLOR_NAVYBLUE, "______ Taxi Hotline ______");
                                    SendClientMessageEx(i, COLOR_GREY2, "Caller: %s, Number: %i", GetRPName(playerid), PlayerData[playerid][pPhone]);
                                    SendClientMessageEx(i, COLOR_GREY2, "Location: %s", text);
                                    SendClientMessageEx(i, COLOR_WHITE, "* Use '/takecall %i' in order to take this call.", playerid);
                                }
                            }
                            PlayerData[playerid][pTaxiCall] = 60;
                            SendClientMessage(playerid, COLOR_YELLOW, "Dispatch: Thank you. We will alert all taxi drivers on duty.");
                            HangupCall(playerid);
                        }
                    }
                }
            }
            else if (PlayerData[playerid][pLiveBroadcast] != INVALID_PLAYER_ID)
            {
                foreach(new i : Player)
                {
                    if (!PlayerData[i][pToggleNews])
                    {
                        if (GetPlayerFaction(playerid) == FACTION_NEWS)
                        {
                            SendClientMessageEx(i, COLOR_LIGHTGREEN, "Live Reporter %s: %s", GetRPName(playerid), text);
                        }
                        else
                        {
                            SendClientMessageEx(i, COLOR_LIGHTGREEN, "Live Guest %s: %s", GetRPName(playerid), text);
                        }
                    }
                }
            }
            else
            {
                new isAbreviation=false;
                for (new i=0;(i<sizeof(MeAbdreviations))&& (!isAbreviation);i++)
                {
                    if (!strcmp(MeAbdreviations[i][0],text,true))
                    {
                        callcmd::me(playerid,MeAbdreviations[i][1]);
                        isAbreviation=true;
                    }
                }
                for (new i=0;(i<sizeof(OOCAbdreviations))&&(!isAbreviation);i++)
                {
                    if (!strcmp(OOCAbdreviations[i][0],text,true))
                    {
                        callcmd::b(playerid,OOCAbdreviations[i][1]);
                        isAbreviation=true;
                    }
                }
                if ((IsAdmin(playerid) && IsAdminOnDuty(playerid, false)) || (PlayerData[playerid][pHelper] && PlayerData[playerid][pAcceptedHelp]))
                {
                    callcmd::b(playerid, text);
                }
                else if (!isAbreviation)
                {
                    if (IsPlayerInAnyVehicle(playerid) && !IsAMotorBike(GetPlayerVehicleID(playerid)) && CarWindows[GetPlayerVehicleID(playerid)] == 0)
                    {
                        foreach(new i : Player)
                        {
                            if (IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid) && !IsAMotorBike(GetPlayerVehicleID(playerid)))
                            {
                                SendClientMessageEx(i, COLOR_GREY1, "(Windows closed) %s says: %s", username, text);
                            }
                        }
                    }
                    else
                    {
                        if (strcmp(PlayerData[playerid][pAccent], "None", true))
                        {
                            format(string, sizeof(string), "(%s) %s says: %s", PlayerData[playerid][pAccent], username, text);
                        }
                        else
                        {
                            format(string, sizeof(string), "%s says: %s", username, text);
                        }
                        SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
                    }
                    PlayChatAnimation(playerid, strlen(text));
                }
            }
        }
    }

    return 0;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if (PlayerData[playerid][pKicked]) return 0;

    if (!PlayerData[playerid][pLogged])
    {
        SendClientMessage(playerid, COLOR_RED, "You cannot use commands if you're not logged in.");
        return 0;
    }
    if (isnull(params))
    {
        params[0] = EOS;
    }
    if (IsPlayerInTutorial(playerid))
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "* You are currently in the tutorial. Commands are disabled.");
        return 0;
    }
    if (GetPlayerState(playerid) == PLAYER_STATE_WASTED)
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "* You are currently dead. Commands are disabled.");
        return 0;
    }
    if (PlayerData[playerid][pMuted])
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "* You are currently muted. Commands are disabled.");
        return 0;
    }
    if (++PlayerData[playerid][pSpamTime] >= 4 && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        PlayerData[playerid][pMuted] = 10;
        SendClientMessage(playerid, COLOR_YELLOW, "You've been temporarily muted by the server for ten seconds due to flooding.");
        return 0;
    }
    if (!IsAdminOnDuty(playerid))
    {
        if (PlayerData[playerid][pTazedTime])
        {
            SendClientMessage(playerid, COLOR_YELLOW, "You've been temporarily tazed you cannot use commands.");
            return 0;
        }
        if (PlayerData[playerid][pCuffed])
        {
            SendClientMessage(playerid, COLOR_YELLOW, "You cannot use commands as you are cuffed.");
            return 0;
        }
        if (PlayerData[playerid][pHospital])
        {
            SendClientMessage(playerid, COLOR_YELLOW, "You cannot use commands as you are in the hospital.");
            return 0;
        }

        //  if (PlayerData[playerid][pInjured])
        //  {
        //      if (strcmp(cmd, "accept", true))
        //      {
        //          SendClientMessage(playerid, COLOR_YELLOW, "You cannot use commands as you are injured.");
        //          return 0;
        //      }
        //      if (isnull(params) || strcmp(params, "death", true))
        //      {
        //          SendClientMessage(playerid, COLOR_GREY, "Usage: /accept death");
        //          return 0;
        //      }
        //  }
    }
    if (!IsAdmin(playerid, ADMIN_LVL_8) && CheckServerAd(params))
    {
        new string[128];
        format(string,sizeof(string),"{00aa00}AdmWarning{FFFF00}: %s (ID: %d) may be server advertising: '{00aa00}/%s %s{FFFF00}'.", GetPlayerNameEx(playerid), playerid, cmd, params);
        SendAdminMessage(COLOR_YELLOW, string, 2);
        SendClientMessage(playerid, COLOR_GREY, "Your command was blocked, you have automatically reported for server advertising.");
        PlayerData[playerid][pAdvertWarnings] ++;
        return 0;
    }
    printf("[zcmd] [%s]:%s %s", GetPlayerNameEx(playerid), cmd, params);
    //DBLog("log_command", "[zcmd] [%s](uid: %d):%s %s.", GetPlayerNameEx(playerid), PlayerData[playerid][pID], cmd, params);

//  DBLog("log_chat", "[%s]:%s %s.", GetPlayerNameEx(playerid), cmd, params);

    /*if ((!IsAdmin(playerid, ADMIN_LVL_8)) && (!strcmp(cmd, "/ban", true, 3) || !strcmp(cmd, "/kick", true, 4) || !strcmp(cmd, "/sban", true, 4) || !strcmp(cmd, "/skick", true, 5) || !strcmp(cmd, "/permaban", true, 8) || !strcmp(cmd, "/getip", true, 5) || !strcmp(cmd, "/traceip", true, 7)))
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "* These commands cannot be used during beta testing.");
        return 0;
    }
    if ((!IsAdmin(playerid, ADMIN_LVL_6)) && (!strcmp(cmd, "/adminname")))
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "* These commands cannot be used during beta testing.");
        return 0;
    }*/
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new time = NetStats_GetConnectedTime(playerid);

    LumberJackPlayerKeyStateChange(playerid, newkeys);

    if (PlayerData[playerid][pSkating] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        SetPlayerArmedWeapon(playerid, 0);
        if (newkeys & KEY_HANDBRAKE)
        {
            PlayAnim(playerid, "SKATE","skate_sprint",4.1,1,1,1,1,1);
            if (!PlayerData[playerid][pSkateAct])
            {
                    PlayerData[playerid][pSkateAct] = true;
                    RemovePlayerAttachedObject(playerid, 5);
                    DestroyDynamicObject(PlayerData[playerid][pSkateObj]);
                    PlayerData[playerid][pSkateObj] = CreateDynamicObject(19878,0,0,0,0,0,0, .playerid = playerid);
                    AttachDynamicObjectToPlayer(PlayerData[playerid][pSkateObj], playerid, -0.2,0,-0.9,0,0,90);
            }
        }
        if (oldkeys & KEY_HANDBRAKE)
        {
            PlayAnim(playerid, "CARRY","crry_prtial",4.0,0,0,0,0,0);
            if (PlayerData[playerid][pSkateAct])
            {
                PlayerData[playerid][pSkateAct] = false;
                DestroyDynamicObject(PlayerData[playerid][pSkateObj]);
                RemovePlayerAttachedObject(playerid, 5);
                SetPlayerAttachedObject(playerid, 5,19878,6,-0.055999,0.013000,0.000000,-84.099983,0.000000,-106.099998,1.000000,1.000000,1.000000);
            }
        }
    }
    BarTenderKeyStateChanged(playerid, newkeys);

    if (newkeys & KEY_SPRINT)
    {
        WorkoutUpdate(playerid);
    }

    if ((time - PlayerData[playerid][pLastPress]) >= 400)
    {
        if (newkeys & KEY_YES)
        {
            if (PlayerData[playerid][pInjured] == 0 && PlayerData[playerid][pTazedTime] == 0 && PlayerData[playerid][pCuffed] == 0 && !IsDueling(playerid))
            {
                if (PlayerData[playerid][pHurt])
                    return SendClientMessageEx(playerid, COLOR_GREY, "You are too hurt to operate/enter anything. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);

                if (!EnterCheck(playerid) &&
                    !ExitCheck (playerid) &&
                    !DoorCheck (playerid) &&
                    !GateCheck (playerid) &&
                    IsPlayerNearGymEquipment(playerid))
                {
                    GymCheck(playerid);
                }
            }

            PlayerData[playerid][pLastPress] = time; // Prevents spamming. Sometimes keys get messed up and register twice.
        }
        else if (newkeys & KEY_NO)
        {
            /*if (!GateCheck(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                callcmd::engine(playerid, "\1");
            }*/
            PlayerData[playerid][pLastPress] = time; // Prevents spamming. Sometimes keys get messed up and register twice.
        }
    }

    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (PlayerData[playerid][pKicked]) return 0;
    IsPlayerSteppingInVehicle[playerid] = -1;

    if (newstate == PLAYER_STATE_DRIVER)
    {
        if (PlayerData[playerid][pToggleVehCam] == 1)
        {
            new p = GetPlayerVehicleID(playerid);
            if (IsAMotorBike(p) || IsAnHelicopter(p) || IsVehicleBajs(p) || IsAPlane(p) || IsABoat(p))
            {
                return 0;
            }
            else
            {
                pObj[playerid] = CreatePlayerObject(playerid,19300, 0.0000, -1282.9984, 10.1493, 0.0000, -1, -1, 100);
                AttachPlayerObjectToVehicle(playerid,pObj[playerid],p,-0.314999, -0.195000, 0.510000, 0.000000, 0.000000, 0.000000);
                AttachCameraToPlayerObject(playerid,pObj[playerid]);
                SetPVarInt(playerid,"used",1);
            }
        }

        new vehicleid = GetPlayerVehicleID(playerid);

        if (IsJobCar(vehicleid))
        {
            if (!CanEnterJobCar(playerid, vehicleid))
            {
                if (GetVehicleModel(vehicleid) == 515)
                    SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a Trucker.");
                else SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a %s.",GetJobName(GetCarJobType(vehicleid)));
                RemovePlayerFromVehicle(playerid);
            }
            else CallRemoteFunction("OnPlayerEnterJobCar", "iii", playerid, vehicleid, GetCarJobType(vehicleid));
        }


        if ((testVehicles[0] <= vehicleid <= testVehicles[4]) && !PlayerData[playerid][pDrivingTest])
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not taking your drivers test.");
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        if (VehicleInfo[vehicleid][vFaction] != -1 && PlayerData[playerid][pFaction] != VehicleInfo[vehicleid][vFaction])
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as it doesn't belong to your faction.");
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        else if (VehicleInfo[vehicleid][vFaction] != -1 && VehicleInfo[vehicleid][vRank] > PlayerData[playerid][pFactionRank])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you aren't a rank %i in your faction.", VehicleInfo[vehicleid][vRank]);
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        else if (VehicleInfo[vehicleid][vFGDivision] != -1 && VehicleInfo[vehicleid][vFGDivision]!=PlayerData[playerid][pDivision])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you aren't %s in your faction.", FactionDivisions[PlayerData[playerid][pFaction]][VehicleInfo[vehicleid][vFGDivision]]);
            RemovePlayerFromVehicle(playerid);
        }
        if (VehicleInfo[vehicleid][vGang] >= 0 && PlayerData[playerid][pGang] != VehicleInfo[vehicleid][vGang])
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot operate this vehicle as it doesn't belong to your gang.");
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        else if (VehicleInfo[vehicleid][vGang] >= 0 && VehicleInfo[vehicleid][vRank] > PlayerData[playerid][pGangRank])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you aren't a rank %i in your gang.", VehicleInfo[vehicleid][vRank]);
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        if (VehicleInfo[vehicleid][vJob] >= 0 && PlayerData[playerid][pJob] != VehicleInfo[vehicleid][vJob])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a %s.", GetJobName(VehicleInfo[vehicleid][vJob]));
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        if (VehicleInfo[vehicleid][vVIP] > 0 && PlayerData[playerid][pDonator] < VehicleInfo[vehicleid][vVIP])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as you are not a %s VIP+.", GetVIPRank(VehicleInfo[vehicleid][vVIP]));
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        if (VehicleInfo[vehicleid][vLocked])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You cannot operate this vehicle as it is locked.");
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        if (!VehicleHasEngine(vehicleid))
        {
            SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
        }
        else if (!IsVehicleParamOn(vehicleid, VEHICLE_ENGINE) && !IsABike(vehicleid))
        {
            if (testVehicles[0] <= vehicleid <= testVehicles[4])
            {
                PlayerData[playerid][pTestVehicle] = vehicleid;
                PlayerData[playerid][pTestCP] = 0;

                SetVehicleParams(vehicleid, VEHICLE_ENGINE, 1);
                SetActiveCheckpoint(playerid, CHECKPOINT_TEST, drivingTestCPs[PlayerData[playerid][pTestCP]][0], drivingTestCPs[PlayerData[playerid][pTestCP]][1], drivingTestCPs[PlayerData[playerid][pTestCP]][2], 3.0);
                SendClientMessage(playerid, COLOR_AQUA, "Drive through the checkpoints to proceed with the test. Try not to damage your vehicle.");
            }
            else
            {

                SetVehicleParams(vehicleid, VEHICLE_ENGINE, 1);
                //GameTextForPlayer(playerid, "~r~Engine Off~n~~w~/engine", 3000, 3);
              //  SendClientMessage(playerid, COLOR_YELLOW,"(( Note: use /togglecam to turn-off the 1st-person-view. ))");
                //SendClientMessage(playerid, COLOR_AQUA, "Your vehicle's engine is turned on, you can use /engine or Press 'N' to turn it off/on.");
            }
        }


        if (!PlayerHasLicense(playerid, PlayerLicense_Car) && !PlayerData[playerid][pDrivingTest] && !IsVehicleBajs(vehicleid))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "You are operating this vehicle without a license. Watch out for the cops!");
        }

        if (IsVehicleOwner(playerid, vehicleid) && VehicleInfo[vehicleid][vTickets] > 0)
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "This vehicle has %s in unpaid tickets. You can pay your tickets using /paytickets.", FormatCash(VehicleInfo[vehicleid][vTickets]));
        }

        SetPlayerArmedWeapon(playerid, 0);

        if (isnull(vehicleStream[vehicleid]))
        {
            SendClientMessage(playerid, COLOR_WHITE, "* Use {C8C8C8}/setradio{FFFFFF} to change the radio station in this vehicle.");
        }
    }
    else if (oldstate == PLAYER_STATE_DRIVER)
    {
        if (GetPVarInt(playerid,"used") == 1)
        {
            SetPVarInt(playerid,"used",0);
            SetCameraBehindPlayer(playerid);
            DestroyPlayerObject(playerid,pObj[playerid]);
        }
        if (PlayerData[playerid][pDrivingTest])
        {
            PlayerData[playerid][pDrivingTest] = 0;
            SetVehicleToRespawn(PlayerData[playerid][pTestVehicle]);
            SendClientMessage(playerid, COLOR_LIGHTRED, "* You have exited the vehicle and therefore failed the test.");
        }
    }
    else if (newstate == PLAYER_STATE_PASSENGER)
    {
        if (PlayerData[playerid][pWeapons][4] > 0)
            SetPlayerArmedWeapon(playerid, PlayerData[playerid][pWeapons][4]);
        else
            SetPlayerArmedWeapon(playerid, 0);

        switch (GetPlayerWeapon(playerid))
        {
            case 22, 23, 25, 28..33:
                SetPlayerArmedWeapon(playerid, GetScriptWeapon(playerid));
            default:
                SetPlayerArmedWeapon(playerid, 0);
        }
    }

    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if (!isnull(vehicleStream[vehicleid]) && PlayerData[playerid][pStreamType] == MUSIC_NONE && !PlayerData[playerid][pToggleMusic])
        {
            PlayerData[playerid][pStreamType] = MUSIC_VEHICLE;
            PlayAudioStreamForPlayer(playerid, vehicleStream[vehicleid]);
            SendClientMessage(playerid, COLOR_WHITE, "You are now tuned in to this vehicle's radio. /stopmusic to stop listening.");
        }

        PlayerData[playerid][pDedication] = 0;
    }
    else if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
    {
        if (PlayerData[playerid][pStreamType] == MUSIC_VEHICLE)
        {
            StopAudioStreamForPlayer(playerid);
            PlayerData[playerid][pStreamType] = MUSIC_NONE;
        }
    }

    return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if (!(-3.0 <= fScaleX <= 3.0)) fScaleX = fScaleX < -3.0 ? 0.0 : 3.0;
    if (!(-3.0 <= fScaleY <= 3.0)) fScaleY = fScaleY < -3.0 ? 0.0 : 3.0;
    if (!(-3.0 <= fScaleZ <= 3.0)) fScaleZ = fScaleZ < -3.0 ? 0.0 : 3.0;

    switch (PlayerData[playerid][pEditType])
    {
        case EDIT_CLOTHING_PREVIEW:
        {
            RemovePlayerAttachedObject(playerid, 9);

            if (response)
            {
                new businessid = GetInsideBusiness(playerid);

                if (businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
                {
                    if (PlayerData[playerid][pCash] < clothingArray[PlayerData[playerid][pSelected]][clothingPrice])
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You couldn't afford to purchase this item.");
                    }

                    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
                    {
                        if (!ClothingInfo[playerid][i][cExists])
                        {
                            ClothingInfo[playerid][i][cModel] = modelid;
                            ClothingInfo[playerid][i][cBone] = boneid;
                            ClothingInfo[playerid][i][cPosX] = fOffsetX;
                            ClothingInfo[playerid][i][cPosY] = fOffsetY;
                            ClothingInfo[playerid][i][cPosZ] = fOffsetZ;
                            ClothingInfo[playerid][i][cRotX] = fRotX;
                            ClothingInfo[playerid][i][cRotY] = fRotY;
                            ClothingInfo[playerid][i][cRotZ] = fRotZ;
                            ClothingInfo[playerid][i][cScaleX] = fScaleX;
                            ClothingInfo[playerid][i][cScaleY] = fScaleY;
                            ClothingInfo[playerid][i][cScaleZ] = fScaleZ;
                            DBFormat("INSERT INTO clothing VALUES(null, %i, '%e', %i, %i, 0, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", PlayerData[playerid][pID], clothingArray[PlayerData[playerid][pSelected]][clothingName], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
                            DBExecute("OnPlayerBuyClothingItem", "isiii", playerid, clothingArray[PlayerData[playerid][pSelected]][clothingName], clothingArray[PlayerData[playerid][pSelected]][clothingPrice], businessid, i);
                            return 1;
                        }
                    }

                    SendClientMessage(playerid, COLOR_GREY, "You have no more clothing slots available. Therefore you can't buy this.");
                }
            }
            else
            {
                if (PlayerData[playerid][pMenuType] == 0)
                    ShowClothingSelectionMenu(playerid);
                else
                    ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHING);
            }
        }
        case EDIT_CLOTHING:
        {
            new clothingid = PlayerData[playerid][pSelected];

            if (response)
            {
                ClothingInfo[playerid][clothingid][cPosX] = fOffsetX;
                ClothingInfo[playerid][clothingid][cPosY] = fOffsetY;
                ClothingInfo[playerid][clothingid][cPosZ] = fOffsetZ;
                ClothingInfo[playerid][clothingid][cRotX] = fRotX;
                ClothingInfo[playerid][clothingid][cRotY] = fRotY;
                ClothingInfo[playerid][clothingid][cRotZ] = fRotZ;
                ClothingInfo[playerid][clothingid][cScaleX] = fScaleX;
                ClothingInfo[playerid][clothingid][cScaleY] = fScaleY;
                ClothingInfo[playerid][clothingid][cScaleZ] = fScaleZ;
                DBQuery("UPDATE clothing SET pos_x = '%f', pos_y = '%f', pos_z = '%f', rot_x = '%f', rot_y = '%f', rot_z = '%f', scale_x = '%f', scale_y = '%f', scale_z = '%f' WHERE id = %i", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, ClothingInfo[playerid][clothingid][cID]);

                SendClientMessageEx(playerid, COLOR_GREY, "Changes saved.");
            }

            if (!ClothingInfo[playerid][clothingid][cAttached])
            {
                RemovePlayerAttachedObject(playerid, 9);
            }
            else
            {
                RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
                SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX], ClothingInfo[playerid][clothingid][cPosY], ClothingInfo[playerid][clothingid][cPosZ],
                    ClothingInfo[playerid][clothingid][cRotX], ClothingInfo[playerid][clothingid][cRotY], ClothingInfo[playerid][clothingid][cRotZ], ClothingInfo[playerid][clothingid][cScaleX], ClothingInfo[playerid][clothingid][cScaleY], ClothingInfo[playerid][clothingid][cScaleZ]);
            }
        }
        case EDIT_COP_CLOTHING:
        {
            RemovePlayerAttachedObject(playerid, 9);

            if (response)
            {
                for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
                {
                    if (!ClothingInfo[playerid][i][cExists])
                    {
                        ClothingInfo[playerid][i][cModel] = modelid;
                        ClothingInfo[playerid][i][cBone] = boneid;
                        ClothingInfo[playerid][i][cPosX] = fOffsetX;
                        ClothingInfo[playerid][i][cPosY] = fOffsetY;
                        ClothingInfo[playerid][i][cPosZ] = fOffsetZ;
                        ClothingInfo[playerid][i][cRotX] = fRotX;
                        ClothingInfo[playerid][i][cRotY] = fRotY;
                        ClothingInfo[playerid][i][cRotZ] = fRotZ;
                        ClothingInfo[playerid][i][cScaleX] = fScaleX;
                        ClothingInfo[playerid][i][cScaleY] = fScaleY;
                        ClothingInfo[playerid][i][cScaleZ] = fScaleZ;

                        DBFormat("INSERT INTO clothing VALUES(null, %i, '%e', %i, %i, 0, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')", PlayerData[playerid][pID], copClothing[PlayerData[playerid][pSelected]][cName], modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
                        DBExecute("OnPlayerAttachCopClothing", "isi", playerid, copClothing[PlayerData[playerid][pSelected]][cName], i);
                        return 1;
                    }
                }

                SendClientMessage(playerid, COLOR_GREY, "You have no more clothing slots available. Therefore you can't attach this.");
            }
            else
            {
                ShowCopClothingMenu(playerid);
            }
        }
    }

    return 1;
}

publish OnPlayerUpdateEx()
{
    foreach(new playerid : Player)
    {
        if (PlayerData[playerid][pKicked])
            continue;

        if (!PlayerData[playerid][pLogged])
            continue;

        new keys, ud, lr;

        GetPlayerKeys(playerid, keys, ud, lr);
        if (PlayerData[playerid][pHurt])
        {
            PlayerData[playerid][pHurt]--;
        }
        if (PlayerData[playerid][pGovTimer] > 0)
        {
            PlayerData[playerid][pGovTimer]--;
        }
        if (PlayerData[playerid][pRareTime] > 0)
        {
            PlayerData[playerid][pRareTime]--;
        }
        if (GetPlayerMoney(playerid) != PlayerData[playerid][pCash])
        {
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid, PlayerData[playerid][pCash]);
        }
        if (GetPlayerScore(playerid) != PlayerData[playerid][pLevel])
        {
            SetPlayerScore(playerid, PlayerData[playerid][pLevel]);
        }
        if (PlayerData[playerid][pInjured] && !IsPlayerInAnyVehicle(playerid) && PlayerData[playerid][pDraggedBy] == INVALID_PLAYER_ID)
        {
            ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 0, 0, 0, 1, 0, 1);
        }
    }
    return 1;
}

hook OnPlayerClearCheckpoint(playerid, type, flag)
{
    PlayerData[playerid][pSmuggleMats] = 0;
    PlayerData[playerid][pSmuggleDrugs] = 0;
    PlayerData[playerid][pGarbage] = 0;

    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        RemovePlayerAttachedObject(playerid, 9);
    }
}
