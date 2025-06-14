#include <YSI\y_hooks>


static MinButcherRate=6000;
static MaxButcherRate=8000;
static IsPlayerButcher[MAX_PLAYERS];
static ButcherTask[MAX_PLAYERS];
static LastSkin[MAX_PLAYERS];
enum ButcherEnum
{
    Butcher_Message[128],
    Butcher_TakeMeat,
    Butcher_AnimType,
    Float:Butcher_X,
    Float:Butcher_Y,
    Float:Butcher_Z
};
static ButcherData[][ButcherEnum]={
    {"~r~[BUTCHER]~n~~y~Start chopping by following the checkpoint at your radar", 1, 0, 958.7614, 2143.0593, 1011.0195},
    {"~r~[BUTCHER]~n~~y~Drop the meat in the conveyor belt", 0, 1, 942.3610, 2117.8982, 1011.0303},
    {"~r~[BUTCHER]~n~~y~Cut the meat", 1, 0, 943.5791, 2127.7429, 1011.0234},
    {"~r~[BUTCHER]~n~~y~Drop the meat in the conveyor belt", 0, 1, 942.1101, 2153.7458, 1011.0234},
    {"~r~[BUTCHER]~n~~y~Cut the meat", 1, 0, 943.7243, 2162.4519, 1011.0234},
    {"~r~[BUTCHER]~n~~y~Drop the meat in the fridge", 0, 1, 933.9705, 2174.5549, 1011.0234}
};

hook OnRemoveBuildings(playerid)
{
	RemoveBuildingForPlayer(playerid, 3744, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2165.2969, -2317.5000, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2193.2578, -2286.2891, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 5304, 2197.1875, -2325.5391, 27.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 5126, 2197.1875, -2325.5391, 27.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2165.2969, -2317.5000, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2193.2578, -2286.2891, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3630, 2227.3828, -2274.7891, 15.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2234.1094, -2269.5469, 16.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2234.1250, -2269.5703, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2142.9141, -2256.3359, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2144.2969, -2258.1484, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 5262, 2152.7109, -2256.7813, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2158.0078, -2257.2656, 16.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2140.3828, -2254.1016, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2150.6641, -2251.5547, 12.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2150.2813, -2250.8516, 12.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2150.6953, -2252.9141, 16.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2149.8125, -2253.3672, 16.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2153.7734, -2253.0859, 14.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2154.5078, -2254.4766, 14.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2158.5703, -2251.0156, 15.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2158.0469, -2250.5078, 15.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2249.1875, -2281.2266, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2249.1719, -2281.2031, 16.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3630, 2261.6016, -2270.0313, 15.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2240.6094, -2266.6719, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2240.5938, -2266.6563, 16.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2245.1172, -2260.7031, 15.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2243.7344, -2258.8906, 15.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 3564, 2262.2813, -2259.2891, 14.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3576, 2253.5469, -2253.9375, 15.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2246.7031, -2251.8906, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2241.2031, -2256.6563, 15.3359, 0.25);

	return 1;
}

hook OnGameModeInit()
{
    CreateDynamicObject(12936, -2387.48901, 150.50081, 21.06816,   0.00000, 0.00000, 31.69128);
    CreateDynamicObject(19833, 954.27618, 2142.23218, 1010.01740,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19833, 963.89032, 2144.97925, 1010.01740,   0.00000, 0.00000, 320.85016);
    CreateDynamicObject(19833, 961.34167, 2144.57666, 1010.01740,   0.00000, 0.00000, 20.00000);
    CreateDynamicObject(19833, 963.49524, 2141.65430, 1010.01740,   0.00000, 0.00000, 218.19470);
    CreateDynamicObject(19833, 958.82953, 2143.95752, 1010.01740,   0.00000, 0.00000, 320.85016);
    CreateDynamicObject(19833, 960.17603, 2141.39404, 1010.01740,   0.00000, 0.00000, 30.00000);
    CreateDynamicObject(19833, 954.20563, 2145.10815, 1010.01740,   0.00000, 0.00000, 40.48597);
    CreateDynamicObject(19833, 957.53229, 2141.90088, 1010.01740,   0.00000, 0.00000, 320.85016);
    CreateDynamicObject(19833, 956.46771, 2145.02515, 1010.01740,   0.00000, 0.00000, 50.00000);
    CreateDynamicObject(19560, 941.44537, 2177.80835, 1011.13715,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 941.84161, 2177.49365, 1011.13727,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 940.97919, 2177.50439, 1011.13721,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 940.60004, 2177.74707, 1011.13715,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 940.39325, 2177.50854, 1011.13715,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 942.39270, 2177.83667, 1011.13696,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 942.33826, 2177.51172, 1011.13708,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 942.90375, 2177.77832, 1011.13696,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 943.39545, 2177.52368, 1011.13702,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2806, 942.33466, 2164.52783, 1011.21643,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 942.66266, 2172.26929, 1011.15015,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 942.11426, 2172.30298, 1011.15015,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2806, 942.45416, 2163.26685, 1011.14966,   0.00000, 0.00000, 267.38721);
    CreateDynamicObject(2806, 942.48340, 2161.89795, 1011.14966,   0.00000, 0.00000, 60.47434);
    CreateDynamicObject(2803, 938.44189, 2139.86279, 1010.73010,   0.00000, 0.00000, 166.53645);
    CreateDynamicObject(2803, 936.19629, 2139.61035, 1010.73010,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2803, 937.37756, 2139.68774, 1010.73010,   0.00000, 0.00000, 70.81435);
    CreateDynamicObject(2803, 948.19263, 2139.74927, 1010.63159,   0.00000, 0.00000, 240.00000);
    CreateDynamicObject(2803, 945.68689, 2139.68408, 1010.63159,   0.00000, 0.00000, 120.00000);
    CreateDynamicObject(2803, 946.93109, 2139.64746, 1010.63159,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2804, 942.95758, 2164.07349, 1011.15027,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2804, 942.02100, 2162.64819, 1011.15039,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2905, 944.91315, 2105.35791, 1006.52039,   0.00000, 0.00000, 16.00469);
    CreateDynamicObject(2906, 943.32172, 2105.38257, 1006.52045,   0.00000, 0.00000, 3.08209);
    CreateDynamicObject(2907, 946.08978, 2105.48291, 1006.52032,   0.00000, 0.00000, 333.82172);
    CreateDynamicObject(2905, 952.72424, 2104.28882, 1006.52032,   0.00000, 0.00000, 10.52465);
    CreateDynamicObject(2906, 954.78796, 2105.41089, 1006.51880,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2908, 953.57245, 2105.23462, 1006.51740,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19583, 943.77142, 2177.80054, 1011.15692,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19583, 942.63013, 2177.48999, 1011.15662,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(19583, 953.31342, 2106.23706, 1006.54010,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19583, 934.67419, 2134.51050, 1011.17200,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19583, 934.89502, 2137.22290, 1011.18402,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19583, 934.48218, 2171.22852, 1011.17139,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2589, 962.34998, 2121.09033, 1016.35480,   0.00000, 0.00000, 60.00000);
    CreateDynamicObject(2589, 962.34998, 2124.07739, 1016.35480,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2589, 956.00000, 211.00000, 1016.35480,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2589, 962.34998, 2118.08569, 1016.35480,   0.00000, 0.00000, 120.00000);
    CreateDynamicObject(2589, 962.34998, 2127.08154, 1016.35480,   0.00000, 0.00000, 290.00000);
    CreateDynamicObject(2589, 962.34998, 2136.08691, 1016.35480,   0.00000, 0.00000, 10.00000);
    CreateDynamicObject(2589, 962.34998, 2133.09204, 1016.35480,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2590, 955.86829, 2129.92432, 1016.17743,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2589, 956.00000, 2133.00000, 1016.35480,   0.00000, 0.00000, 340.00000);
    CreateDynamicObject(2589, 956.00000, 2136.00000, 1016.35480,   0.00000, 0.00000, 270.00000);
    CreateDynamicObject(2589, 956.00000, 2127.00000, 1016.35480,   0.00000, 0.00000, 30.00000);
    CreateDynamicObject(2589, 956.00000, 2124.00000, 1016.35480,   0.00000, 0.00000, 190.00000);
    CreateDynamicObject(2589, 955.99048, 2121.01758, 1016.35480,   0.00000, 0.00000, 150.00000);
    CreateDynamicObject(2589, 955.99048, 2118.01758, 1016.35480,   0.00000, 0.00000, 70.00000);
    CreateDynamicObject(2589, 942.66101, 2124.08496, 1011.10565,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(936, 942.67310, 2128.44336, 1010.62817,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(936, 942.67767, 2126.54297, 1010.62817,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(937, 932.85028, 2124.76318, 1010.50000,   0.00000, 0.00000, 270.00000);
    CreateDynamicObject(936, 932.83667, 2122.76123, 1010.50000,   0.00000, 0.00000, 270.00000);
    CreateDynamicObject(941, 933.68433, 2126.44751, 1010.50000,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(952, 936.96527, 2115.22363, 1011.13013,   0.00000, 0.00000, 270.00000);
    CreateDynamicObject(934, 951.27203, 2124.52588, 1011.23657,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2451, 932.97827, 2144.66406, 1010.01971,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2451, 933.00983, 2142.62012, 1010.01971,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1994, 933.00000, 2176.08618, 1010.02032,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1995, 933.00000, 2177.08276, 1010.02032,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1995, 933.00000, 2174.74170, 1010.02032,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1994, 933.00000, 2173.74585, 1010.02032,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19560, 932.98004, 2176.98291, 1010.88538,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 933.01831, 2173.68237, 1010.88538,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 932.96008, 2174.30322, 1010.88538,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 933.04810, 2174.74878, 1010.88538,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 933.01776, 2176.05200, 1010.88538,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19560, 932.91425, 2176.44458, 1010.88538,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18720, 959.15448, 2135.27222, 1015.35498,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18671, 958.54553, 2137.63257, 1010.32245,   0.00000, 0.00000, 0.00000);
	CreateDynamicLabeledPickup(COLOR_AQUA, "[BUTCHER]\nUse /butcher to be a butcher\n or to cancel butcher", 960.9384, 2099.7666, 1011.0251, 1, -1, 1274, 50.0);

	return 1;
}


CMD:butcher(playerid)
{
    
    if(!PlayerHasJob(playerid, JOB_BUTCHER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a butcher.");
	}
    if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
		return SendClientMessage(playerid, COLOR_AQUA, "Make sure you dont have any checkpoint. Use /kcp to clear current checkpoints.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 960.9384, 2099.7666, 1011.0251)) 
    {
		return SendClientMessage(playerid, COLOR_YELLOW, "You're not near in the Butcher Pickup");
	}

	if(IsPlayerButcher[playerid])
	{
		IsPlayerButcher[playerid] = false;
        PlayerData[playerid][pCP] = CHECKPOINT_NONE;
        DisablePlayerCheckpoint(playerid);

		SetPlayerSpecialAction(playerid, 0);
		ClearAnimations(playerid, 1);
        
		SetPlayerSkin(playerid, LastSkin[playerid]);
		LastSkin[playerid] = -1;
		RemovePlayerAttachedObject(playerid, 9);
		RemovePlayerAttachedObject(playerid, 8);
		GameTextForPlayer(playerid, "~r~[BUTCHER SHOP]~n~~y~Thank you for your service! Comeback again!", 5000, 3);
	}
	else if(!IsPlayerButcher[playerid])
	{
        IsPlayerButcher[playerid] = true;
		LastSkin[playerid] = GetPlayerSkin(playerid);

        SetPlayerSkin(playerid, 168);
		SetPlayerAttachedObject(playerid, 8, 335, 6, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.7290, 0xFFFFFFFF, 0xFFFFFFFF);

        ButcherTask[playerid] = 0;
        SetButcherTaskCheckpoint(playerid);
	}
	return 1;
}

hook OnPlayerInit(playerid)
{
	IsPlayerButcher[playerid] = false;
	LastSkin[playerid] = -1;
	return 1;
}

hook OnPlayerClearCheckPoint(playerid)
{
    if(IsPlayerButcher[playerid])
    {
        if(LastSkin[playerid] != -1)
        {
		    SetPlayerSkin(playerid, LastSkin[playerid]);
        }
        IsPlayerButcher[playerid] = false;
        LastSkin[playerid] = -1;
		SetPlayerSpecialAction(playerid, 0);
		ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 9);
		RemovePlayerAttachedObject(playerid, 8);
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(!IsPlayerButcher[playerid])
    {
        return 1;
    }
	if(PlayerData[playerid][pCP] == CHECKPOINT_BUTCHER && ButcherTask[playerid] < sizeof(ButcherData))
	{
        if(ButcherTask[playerid] < 0)
        {
            return 1;
        }
        
        PlayerData[playerid][pCP] = CHECKPOINT_NONE;        
        DisablePlayerCheckpoint(playerid);

        if(ButcherData[ButcherTask[playerid]][Butcher_TakeMeat])
        {
            ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 0, 0, 1);
            SetTimerEx("GetMeatTimer", 10000, false, "i", playerid);
            GameTextForPlayer(playerid, "~w~Cutting the Meat....", 5000, 4);
        }
        else
        {
            ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
            SetTimerEx("GetMeatTimer", 1000, false, "i", playerid);
            GameTextForPlayer(playerid, "~w~Placing the Meat....", 5000, 4);
        }
	}
	return 1;
}


publish GetMeatTimer(playerid)
{
    if(ButcherTask[playerid] + 1 == sizeof(ButcherData))
    {
        new randmoney = Random(MinButcherRate, MaxButcherRate);
        SetPlayerSpecialAction(playerid, 0);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 9);
        AddToPaycheck(playerid, randmoney);
        GivePlayerRankPointLegalJob(playerid, 150);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} on your paycheck for your work.", randmoney);
        ButcherTask[playerid] = -1;
    }
    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
    ButcherTask[playerid]++;
    SetButcherTaskCheckpoint(playerid);
	return 1;
}

SetButcherTaskCheckpoint(playerid)
{
    new Float:x = ButcherData[ButcherTask[playerid]][Butcher_X];
    new Float:y = ButcherData[ButcherTask[playerid]][Butcher_Y];
    new Float:z = ButcherData[ButcherTask[playerid]][Butcher_Z];

    PlayerData[playerid][pCP] = CHECKPOINT_BUTCHER;
    SetPlayerCheckpoint(playerid, x, y, z, 2.0);
    GameTextForPlayer(playerid, ButcherData[ButcherTask[playerid]][Butcher_Message], 5000, 3);

    ClearAnimations(playerid, 1);
    if(ButcherTask[playerid] > 0 && ButcherData[ButcherTask[playerid]-1][Butcher_TakeMeat])
    {
        SetPlayerSpecialAction(playerid, 25);
        SetPlayerAttachedObject(playerid, 9, 2806, 1, 0.0860, 0.3440, 0.0000, -93.8999, 93.4999, 0.0000, 0.4909, 0.6929, 0.8539, 0xFFFFFFFF, 0xFFFFFFFF);
    }
    else
    {	
        SetPlayerSpecialAction(playerid, 0);
        RemovePlayerAttachedObject(playerid, 9);
    }
}