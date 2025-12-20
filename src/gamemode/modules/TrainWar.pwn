/*
	Train War
	Scripted By Tr0Y
	Mapping Trains by Tr0Y
	Mapping Covers by Ahmed_Del_Ray

	Latest Change
	- temporary fix train claim pos Country Side
	- check if boxville that entered the checkpoint
	(if boxville loaded with crates even if train is not active player can enter only in this situation)
	- boxville locked antil train war is active
	
	Bugs
	- Warning: vehicle 211 was not deleted (caused by samp client)
	
*/

#include <YSI\y_hooks>

#define MAX_TRAIN_BOXES  	60
#define TRAIN_ACTIVE_RANGE 	65.0
#define CLAIM_RADIUS 		20.0

#define JEFFERSON_TRAIN     0
#define UNITY_STATION_TRAIN 1
#define COUNTRY_SIDE_TRAIN  2

new bool:TrainClaimed[MAX_GANGS];

new JeffersonTrainDecors[27];
new UnitStationDecor[14];
new CountrySideDecors[12];

enum E_TRAIN_SPAWN {
	Location[64],
    Float:tX,
    Float:tY,
    Float:tZ,
    Float:tAngle
};

new const TrainSpawns[3][E_TRAIN_SPAWN] = {
    {"Jefferson", 2285.1418, -1099.7854, 26.8906, 0.8999},
    {"Unity Station", 1664.4771, -1953.8595, 13.5469, 269.7586},
    {"Country Side", 2165.0991, -673.2902, 50.9088, 321.3553}
};

enum E_TRAINBOX {
    tbObjectID,
    bool:tbLooted,
    Float:tbX,
    Float:tbY,
    Float:tbZ
};
new TrainBox[MAX_TRAIN_BOXES][E_TRAINBOX];

enum E_BOX_CONFIG {
    boxModel,
    Float:boxX,
    Float:boxY,
    Float:boxZ,
    Float:boxRX,
    Float:boxRY,
    Float:boxRZ,
    boxGroup
};

static const g_TrainBoxConfig[][E_BOX_CONFIG] = {
    {964, 2285.8898, -1137.7692, 27.2938, 0.0, 0.0, -32.7, JEFFERSON_TRAIN},
    {964, 2284.8798, -1137.2941, 28.1638, 0.0, 0.0, -1.2, JEFFERSON_TRAIN},
    {964, 2284.2868, -1137.4320, 27.2537, 0.0, 0.0, -1.2, JEFFERSON_TRAIN},
    {964, 2284.3251, -1130.7855, 27.3285, 0.0, 0.0, -3.0, JEFFERSON_TRAIN},
    {964, 2285.6940, -1130.8577, 27.3385, 0.0, 0.0, 87.8, JEFFERSON_TRAIN},
    {964, 2285.1420, -1130.7827, 28.3086, 0.0, 0.0, -7.6, JEFFERSON_TRAIN},
    {964, 2287.4699, -1144.6508, 25.7394, 0.0, 0.0, 140.5, JEFFERSON_TRAIN},
    {964, 2285.1381, -1142.7303, 27.2494, 0.0, 0.0, 140.5, JEFFERSON_TRAIN},
    {964, 2285.0046, -1140.6971, 27.2594, 0.0, 0.0, 49.3, JEFFERSON_TRAIN},
    {964, 2284.7055, -1141.6423, 28.1494, 0.0, 0.0, 94.2, JEFFERSON_TRAIN},
    {964, 2285.0273, -1122.3609, 27.3671, 0.0, 0.0, -6.9, JEFFERSON_TRAIN},
    {964, 2285.2663, -1120.4152, 27.3671, 0.0, 0.0, -6.9, JEFFERSON_TRAIN},
    {964, 2285.2663, -1120.4152, 28.3271, 0.0, 0.0, -135.1, JEFFERSON_TRAIN},
    {964, 2284.8828, -1117.2833, 27.3871, 0.0, 0.0, -37.2, JEFFERSON_TRAIN},
    {964, 2285.4301, -1115.6678, 27.4271, 0.0, 0.0, 56.1, JEFFERSON_TRAIN},
    {964, 2285.7145, -1113.9324, 27.4271, 0.0, 0.0, 56.1, JEFFERSON_TRAIN},
    {964, 2284.6733, -1158.1496, 28.4671, 0.0, 0.0, 23.8, JEFFERSON_TRAIN},
    {964, 2284.7258, -1155.7438, 28.4671, 0.0, 0.0, 53.0, JEFFERSON_TRAIN},
    {964, 2285.0427, -1153.2929, 28.4671, 0.0, 0.0, 115.7, JEFFERSON_TRAIN},
    {964, 2285.5473, -1114.7087, 28.3470, 0.0, 0.0, 79.3, JEFFERSON_TRAIN},

    {964, 1676.1788, -1953.6381, 13.9940, 0.0, 0.0, 57.5999, UNITY_STATION_TRAIN},
    {964, 1677.8940, -1954.1459, 13.9940, 0.0, 0.0, -75.3000, UNITY_STATION_TRAIN},
    {964, 1677.0083, -1954.1437, 14.9040, 0.0, 0.0, -28.4000, UNITY_STATION_TRAIN},
    {964, 1680.8533, -1953.5736, 13.9940, 0.0, 0.0, 40.9999, UNITY_STATION_TRAIN},
    {964, 1683.3159, -1953.6330, 13.9940, 0.0, 0.0, -69.9000, UNITY_STATION_TRAIN},
    {964, 1685.9331, -1953.6550, 13.9940, 0.0, 0.0, -158.8999, UNITY_STATION_TRAIN},
    {964, 1690.2896, -1953.5668, 13.9940, 0.0, 0.0, -89.7999, UNITY_STATION_TRAIN},
    {964, 1705.7681, -1953.3927, 13.9940, 0.0, 0.0, 22.5000, UNITY_STATION_TRAIN},
    {964, 1707.5928, -1953.8686, 13.9940, 0.0, 0.0, 178.4000, UNITY_STATION_TRAIN},
    {964, 1706.8483, -1953.7215, 14.9340, 0.0, 0.0, -51.8999, UNITY_STATION_TRAIN},
    {964, 1712.7169, -1953.7412, 13.9940, 0.0, 0.0, -89.5999, UNITY_STATION_TRAIN},
    {964, 1724.8760, -1953.8964, 13.9940, 0.0, 0.0, 92.5001, UNITY_STATION_TRAIN},
    {964, 1726.6644, -1953.8149, 13.9940, 0.0, 0.0, 178.3001, UNITY_STATION_TRAIN},
    {964, 1725.9249, -1953.7930, 14.9440, 0.0, 0.0, 178.3001, UNITY_STATION_TRAIN},
    {964, 1693.5366, -1953.5969, 14.0040, 0.0, 0.0, -89.7999, UNITY_STATION_TRAIN},
    {964, 1719.1635, -1953.9426, 16.0540, 0.0, 0.0, -147.6998, UNITY_STATION_TRAIN},
    {964, 1699.5913, -1953.5151, 15.9840, 0.0, 0.0, -157.5998, UNITY_STATION_TRAIN},
    {964, 1693.4589, -1951.0372, 13.1040, 0.0, 0.0, 178.6999, UNITY_STATION_TRAIN},
    {964, 1688.7193, -1953.3415, 13.9940, 0.0, 0.0, 178.4000, UNITY_STATION_TRAIN},
    {964, 1689.3330, -1953.4355, 14.9240, 0.0, 0.0, 133.5000, UNITY_STATION_TRAIN},

    {964, 2166.1430, -681.3180, 50.7551, 7.1999, 0.0000, 52.9000, COUNTRY_SIDE_TRAIN},
    {964, 2156.4770, -674.0073, 52.3265, -4.6000, 0.0000, -128.3999, COUNTRY_SIDE_TRAIN},
    {964, 2155.0876, -673.2248, 52.4873, 0.0999, -6.7000, 150.6000, COUNTRY_SIDE_TRAIN},
    {964, 2155.7148, -673.5773, 53.3895, 0.0999, -6.7000, 150.6000, COUNTRY_SIDE_TRAIN},
    {964, 2153.9838, -672.0313, 52.6727, 5.5999, 0.0000, 52.2000, COUNTRY_SIDE_TRAIN},
    {964, 2149.1667, -668.4203, 53.5844, 8.1999, 0.0000, 52.2000, COUNTRY_SIDE_TRAIN},
    {964, 2151.1757, -669.9796, 53.1470, -0.6000, -7.1999, 142.9000, COUNTRY_SIDE_TRAIN},
    {964, 2151.2702, -670.0592, 54.1291, -2.3000, -7.1999, -165.5999, COUNTRY_SIDE_TRAIN},
    {964, 2139.5500, -660.9587, 55.3388, 8.1999, 0.0000, 52.9000, COUNTRY_SIDE_TRAIN},
    {964, 2136.7480, -658.7955, 56.0112, -8.3999, 0.0000, -129.7999, COUNTRY_SIDE_TRAIN},
    {964, 2135.5317, -657.7807, 56.2351, -2.4999, -7.4999, 145.7000, COUNTRY_SIDE_TRAIN},
    {964, 2136.1545, -658.5012, 56.9880, -2.4999, -7.4999, 137.4000, COUNTRY_SIDE_TRAIN},
    {964, 2125.6464, -649.5454, 58.1045, -8.3999, 0.0000, -129.7999, COUNTRY_SIDE_TRAIN},
    {964, 2126.9658, -650.6504, 57.8497, -1.0000, -7.8999, 143.1000, COUNTRY_SIDE_TRAIN},
    {964, 2126.3081, -650.2798, 58.8995, -1.5000, -7.8999, 139.2999, COUNTRY_SIDE_TRAIN},
    {964, 2128.1342, -652.9951, 57.5345, 7.9999, -0.2999, 53.7000, COUNTRY_SIDE_TRAIN},
    {964, 2132.5244, -656.2187, 56.6983, 7.9999, -0.2999, 53.7000, COUNTRY_SIDE_TRAIN},
    {964, 2131.0705, -653.5253, 57.1344, 7.9999, -0.2999, 51.0000, COUNTRY_SIDE_TRAIN},
    {964, 2130.8354, -654.0231, 58.0625, 8.1999, -5.9999, 82.8000, COUNTRY_SIDE_TRAIN},
    {964, 2130.3586, -654.6275, 57.1066, 7.9999, -0.2999, 53.7000, COUNTRY_SIDE_TRAIN}
};

enum E_REWARD_TYPE {
    REWARD_CASH,
    REWARD_MATS,
    REWARD_WEED,
    REWARD_HEROIN,
    REWARD_COCAINE,
    REWARD_DEAGLE,
    REWARD_AK47,
    REWARD_TEC,
    REWARD_UZI
};

static SecureBoxVilleCheckpoint;

stock InitTrainBoxesForGroup(spawnGroup) {
    new boxesCreated = 0;
    for(new i = 0; i < sizeof(g_TrainBoxConfig); i++) {
        if(g_TrainBoxConfig[i][boxGroup] == spawnGroup) {
            CreateTrainBox(i, g_TrainBoxConfig[i][boxModel], g_TrainBoxConfig[i][boxX], g_TrainBoxConfig[i][boxY], g_TrainBoxConfig[i][boxZ], g_TrainBoxConfig[i][boxRX], g_TrainBoxConfig[i][boxRY], g_TrainBoxConfig[i][boxRZ]);
            boxesCreated++;
        }
    }
    return boxesCreated;
}

stock CreateTrainBox(index, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    TrainBox[index][tbObjectID] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz);
    TrainBox[index][tbLooted] = false;
    TrainBox[index][tbX] = x;
    TrainBox[index][tbY] = y;
    TrainBox[index][tbZ] = z;
}

stock GiveRandomTrainReward(gangid, rewards[E_REWARD_TYPE]) {
    new reward = random(9);
    switch (reward) {
        case REWARD_CASH: {
            new amount = Random(300000, 200000);
            GangInfo[gangid][gCash] += amount;
            rewards[REWARD_CASH] += amount;
        }
        case REWARD_MATS: {
            new amount = Random(250000, 200000);
            GangInfo[gangid][gMaterials] += amount;
            rewards[REWARD_MATS] += amount;
        }
        case REWARD_WEED: {
            new amount = Random(20, 20);
            GangInfo[gangid][gWeed] += amount;
            rewards[REWARD_WEED] += amount;
        }
        case REWARD_HEROIN: {
            new amount = Random(10, 20);
            GangInfo[gangid][gMeth] += amount;
            rewards[REWARD_HEROIN] += amount;
        }
        case REWARD_COCAINE: {
            new amount = Random(10, 10);
            GangInfo[gangid][gCocaine] += amount;
            rewards[REWARD_COCAINE] += amount;
        }
        case REWARD_DEAGLE: {
            new amount = Random(1, 4);
            GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] += amount;
            rewards[REWARD_DEAGLE] += amount;
        }
        case REWARD_AK47: {
            new amount = Random(5, 10);
            GangInfo[gangid][gWeapons][GANGWEAPON_AK47] += amount;
            rewards[REWARD_AK47] += amount;
        }
        case REWARD_TEC: {
            new amount = Random(10, 20);
            GangInfo[gangid][gWeapons][GANGWEAPON_TEC9] += amount;
            rewards[REWARD_TEC] += amount;
        }
        case REWARD_UZI: {
            new amount = Random(30, 40);
            GangInfo[gangid][gWeapons][GANGWEAPON_UZI] += amount;
            rewards[REWARD_UZI] += amount;
        }
    }
    return reward;
}

forward SpawnTrain(station);
public SpawnTrain(station) {
    if (TrainData[Active]) return 1;

    TrainData[Vehicle] = AddStaticVehicleEx(537, TrainSpawns[station][tX], TrainSpawns[station][tY], TrainSpawns[station][tZ], TrainSpawns[station][tAngle], 0, 0, -1, 0);
    TrainData[Active] = true;
    TrainData[Location] = station;
    TrainData[ClaimedBy] = EOS;

    for (new g = 0; g < MAX_GANGS; g++)
        TrainClaimed[g] = false;

    for (new i = 0; i < MAX_TRAIN_BOXES; i++)
        TrainBox[i][tbLooted] = false;

    SendClientMessageToAllEx(COLOR_AQUA, "(( News: A train has broken down at {FF0000}%s{33CCFF} loaded with crates ))", TrainSpawns[station][Location]);

    switch (station) {
        case JEFFERSON_TRAIN: {
            InitMapJefferson();
            InitTrainBoxesForGroup(JEFFERSON_TRAIN);
        }
        case UNITY_STATION_TRAIN: {
            InitMapUnity();
            InitTrainBoxesForGroup(UNITY_STATION_TRAIN);
        }
        case COUNTRY_SIDE_TRAIN: {
            InitMapCountry();
            InitTrainBoxesForGroup(COUNTRY_SIDE_TRAIN);
        }
    }
    return 1;
}

CMD:traininfo(playerid) // still didnt finish it
{
	new Float:tx, Float:ty, Float:tz;
    if (IsValidVehicle(TrainData[Vehicle]))
        GetVehiclePos(TrainData[Vehicle], tx, ty, tz);
    else {
        tx = TrainSpawns[TrainData[Location]][tX]; ty = TrainSpawns[TrainData[Location]][tY]; tz = TrainSpawns[TrainData[Location]][tZ];
    }
    
	if(IsPlayerInRangeOfPoint(playerid, TRAIN_ACTIVE_RANGE, tx, ty, tz))
	{
		if(TrainData[Active])
		{
            if(TrainData[LEOClaimed])
			{
                SendClientMessageEx(playerid, COLOR_GREY, "Train claimed by %s Time: %d", TrainData[ClaimedBy], TrainData[LEOTimer]);
			}
			//for (new g = 0; g < MAX_GANGS; g++)
			//else if(TrainClaimed[g])
			//{
                //SendClientMessageEx(playerid, COLOR_GREY, "Train claimed by %s for %s", TrainData[ClaimedBy], TrainData[ClaimedBy][PlayerData[pGang[gName]]]);
			//}
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "You are not in any active train range.");
	}
	return 1;
}

CMD:claimtrain(playerid, params[]) {
    if(PlayerData[playerid][pGang] == -1 && !IsLawEnforcement(playerid))
	{
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a gang or apart of law enforcement.");
    }

    new Float:tx, Float:ty, Float:tz;
    if (IsValidVehicle(TrainData[Vehicle]))
        GetVehiclePos(TrainData[Vehicle], tx, ty, tz);
    else
        tx = TrainSpawns[TrainData[Location]][tX], ty = TrainSpawns[TrainData[Location]][tY], tz = TrainSpawns[TrainData[Location]][tZ];
        
    //if (!IsPlayerInRangeOfPoint(playerid, CLAIM_RADIUS, tx, ty, tz - 10))
    //Pinned by Tr0Y: Tempory fix for Train Claim Country Side
    if(TrainData[Location] == 2 ? !IsPlayerInRangeOfPoint(playerid, CLAIM_RADIUS, 2180.5342, -692.0450, 51.3591 - 10) : !IsPlayerInRangeOfPoint(playerid, CLAIM_RADIUS, tx, ty, tz - 10))
        return SendClientMessage(playerid, COLOR_GREY, "You must be near the train to claim it!");

    if (!TrainData[Active])
        return SendClientMessage(playerid, COLOR_GREY, "There is no active train to claim!");

    if (PlayerData[playerid][pInjured])
        return SendClientMessage(playerid, COLOR_GREY, "You can't claim a train while injured.");

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, COLOR_GREY, "You must be on foot to claim the train.");

    new gangid = PlayerData[playerid][pGang];

    if (IsLawEnforcement(playerid) && gangid >= 0)
        return SendClientMessage(playerid, COLOR_GREY, "You cannot claim the train as both LEO and a gang member.");
        
    if(GetBoxes() - GetLootedBoxes() == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY, "The train is fully looted.");
	}
	
    new count;
    foreach (new i : Player) {
        if (i != playerid && IsPlayerInRangeOfPoint(i, TRAIN_ACTIVE_RANGE, tx, ty, tz) && !PlayerData[i][pInjured] && !PlayerData[i][pAdminDuty] && !PlayerData[i][pAcceptedHelp] && !IsPlayerAFK(i) && GetPlayerState(i) != PLAYER_STATE_SPECTATING) {
            if (PlayerData[i][pGang] != -1 && PlayerData[i][pGang] != gangid && !IsPlayerGangAlliance(i, playerid)) {
                if (++count >= 1)
                    return SendClientMessage(playerid, COLOR_GREY, "You must eliminate all enemy gang members near the train first.");
            }
			else if(IsLawEnforcement(playerid) && IsLawEnforcement(i))
            {
            	return SendClientMessage(playerid, COLOR_GREY, "You must eliminate all LEO in this turf before you can claim train.");
            }
        }
    }

    new owner = -1;
    for (new g = 0; g < MAX_GANGS; g++)
        if (TrainClaimed[g])
            owner = g;

    if (IsLawEnforcement(playerid))
	{
        if(TrainData[LEOClaimed]) return SendClientMessage(playerid, COLOR_GREY, "Train arleady is secured by an LEO faction.");

        TrainData[LEOTimer] = 10;
        TrainData[LEOClaimed] = true;
        GetPlayerName(playerid, TrainData[ClaimedBy], MAX_PLAYER_NAME);
        SendClientMessageToAllEx(COLOR_YELLOW, "Train War: Law enforcement has taken back the train! Gangs have 10 minutes to reclaim it before it's leave.");
        return 1;
    }

    if (gangid == -1)
	{
        return SendClientMessage(playerid, COLOR_GREY, "You are not part of any gang at the moment.");
	}
    if (TrainData[LEOClaimed])
	{
        TrainData[LEOTimer] = -1;
        TrainData[LEOClaimed] = false;
    }

    if (owner == -1)
	{
        TrainClaimed[gangid] = true;
    }
	else if (owner != gangid)
	{
        TrainClaimed[owner] = false;
        TrainClaimed[gangid] = true;
        GetPlayerName(playerid, TrainData[ClaimedBy], MAX_PLAYER_NAME);
    }
	else
	{
        return SendClientMessage(playerid, COLOR_GREY, "The train is already claimed by your gang!");
    }

    new string[128];
    format(string, sizeof(string), "Train War: %s has claimed the train for %s, %d crates remaining.", GetRPName(playerid), GangInfo[gangid][gName], (GetBoxes() - GetLootedBoxes()));
    SendClientMessageToAllEx(COLOR_YELLOW, string);
    return 1;
}

CMD:loottrainbox(playerid, params[]) {
	if (!IsPlayerIdle(playerid)) {
	    return SendClientMessage(playerid, COLOR_GREY, "You can't loot any train crate right now.");
	}

    if (!TrainData[Active]) {
		return SendClientMessage(playerid, COLOR_GREY, "there is no train active.");
	}

    new gangid = PlayerData[playerid][pGang];
    if (gangid < 0) {
		return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}

    if (!TrainClaimed[gangid]) {
 		return SendClientMessage(playerid, COLOR_GREY, "Your gang must claim the train first!");
 	}

    if (PlayerData[playerid][pCarryingBox]) {
 		return SendClientMessage(playerid, COLOR_GREY, "You already carry a crate.");
 	}

    for (new i = 0; i < MAX_TRAIN_BOXES; i++) {
        if (!TrainBox[i][tbLooted]) {
            if (IsPlayerInRangeOfPoint(playerid, 2.0, TrainBox[i][tbX], TrainBox[i][tbY], TrainBox[i][tbZ])) {
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

                if (TrainBox[i][tbObjectID] != INVALID_OBJECT_ID) {
                    DestroyDynamicObject(TrainBox[i][tbObjectID]);
                    TrainBox[i][tbObjectID] = INVALID_OBJECT_ID;
                }

                TrainBox[i][tbLooted] = true;

                SetPlayerAttachedObject(playerid, 9, 964, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

                PlayerData[playerid][pCarryingBox] = true;
                SendClientMessage(playerid, -1, "You picked up a train crate, deliver it to your gang boxville!");

				if(GetBoxes() - GetLootedBoxes() == 0) {
	    			foreach(new ui : Player) {
				        if(PlayerData[ui][pGang] != -1 || IsLawEnforcement(ui))
						{
				             SendClientMessage(ui, COLOR_YELLOW, "The train has been fully looted! It will leave in 15 seconds.");
				        }
				    }
                    SetTimer("EndTrainEvent", 15000, false);
				}
                return 1;
            }
        }
    }
    return SendClientMessage(playerid, COLOR_GREY, "You are not near any crate to pickup.");
}

CMD:loadtrainbox(playerid, params[]) {
    if (!PlayerData[playerid][pCarryingBox]) {
		return SendClientMessage(playerid, COLOR_GREY, "You are not carrying any crate!");
	}

    new gangid = PlayerData[playerid][pGang];
    if (gangid == -1) {
		return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
 	}

    if (!IsValidVehicle(GangBoxville[gangid][gbVehicle])) {
		return SendClientMessage(playerid, COLOR_GREY, "Your gang has no Boxville available, contact GangMod!");
 	}

    new Float:bx, Float:by, Float:bz;
    GetVehiclePos(GangBoxville[gangid][gbVehicle], bx, by, bz);

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, bx, by, bz)) {
		return SendClientMessage(playerid, COLOR_GREY, "You must be near your gang boxville to load the box!");
	}

    PlayerData[playerid][pCarryingBox] = false;
    RemovePlayerAttachedObject(playerid, 9);
    ClearAnimations(playerid, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

    GangBoxville[gangid][CrateLoaded]++;
    return 1;
}

forward EndTrainEvent();
public EndTrainEvent() {
    if (!TrainData[Active]) return 1;
    TrainData[Active] = false;
    TrainData[Location] = -1;
    TrainData[ClaimedBy] = EOS;
    TrainData[LEOTimer] = -1;
    TrainData[LEOClaimed] = false;

    if (IsValidVehicle(TrainData[Vehicle])) {
        DestroyVehicle(TrainData[Vehicle]);
        TrainData[Vehicle] = 0;
    }

    for (new i = 0; i < sizeof(g_TrainBoxConfig); i++) {
        if (TrainBox[i][tbObjectID] != INVALID_OBJECT_ID) {
            DestroyDynamicObject(TrainBox[i][tbObjectID]);
            TrainBox[i][tbObjectID] = INVALID_OBJECT_ID;
        }
        TrainBox[i][tbLooted] = false;
        TrainBox[i][tbX] = 0.0;
        TrainBox[i][tbY] = 0.0;
        TrainBox[i][tbZ] = 0.0;
    }

    for (new i = 0; i < sizeof(JeffersonTrainDecors); i++) {
        if (IsValidDynamicObject(JeffersonTrainDecors[i]))
            DestroyDynamicObject(JeffersonTrainDecors[i]);
    }

    for (new i = 0; i < sizeof(UnitStationDecor); i++) {
        if (IsValidDynamicObject(UnitStationDecor[i]))
            DestroyDynamicObject(UnitStationDecor[i]);
    }

    for (new i = 0; i < sizeof(CountrySideDecors); i++) {
        if (IsValidDynamicObject(CountrySideDecors[i]))
            DestroyDynamicObject(CountrySideDecors[i]);
    }

    foreach(new i : Player) {
        if(PlayerData[i][pCarryingBox]) {
            RemovePlayerAttachedObject(i, 9);
            ClearAnimations(i, 1);
            PlayerData[i][pCarryingBox] = false;
        }
    }

    for (new g = 0; g < MAX_GANGS; g++) {
        if (GangBoxville[g][CrateLoaded] > 0) {
            foreach(new pid : Player) {
                if (PlayerData[pid][pGang] == g) {
                    SendClientMessage(pid, COLOR_YELLOW, "You're gang boxville has loaded some crates go to secure them.");
                }
            }
        }
    }

    for (new g = 0; g < MAX_GANGS; g++)
        TrainClaimed[g] = false;

    return 1;
}

forward RobTrainSecondTimer();
public RobTrainSecondTimer()
{
	if (TrainData[Active])
	{
		new Float:tx, Float:ty, Float:tz;
	    if (IsValidVehicle(TrainData[Vehicle]))
	        GetVehiclePos(TrainData[Vehicle], tx, ty, tz);
	    else {
	        tx = TrainSpawns[TrainData[Location]][tX]; ty = TrainSpawns[TrainData[Location]][tY]; tz = TrainSpawns[TrainData[Location]][tZ];
	    }
	    
   		foreach(new i : Player)
  		{
    		if (IsPlayerInRangeOfPoint(i, TRAIN_ACTIVE_RANGE, tx, ty, tz))
			{
				if(PlayerData[i][pGang] >= 0 && !PlayerData[i][pBandana])
				{
				    if(GangInfo[PlayerData[i][pGang]][gIsMafia]) return 0;

		   			new color;
			 		if(GangInfo[PlayerData[i][pGang]][gColor] == -1 || GangInfo[PlayerData[i][pGang]][gColor] == -256) {
						color = 0xC8C8C8FF;
					} else {
		   				color = GangInfo[PlayerData[i][pGang]][gColor];
					}
					PlayerData[i][pBandana] = 1;
					SendClientMessage(i, COLOR_WHITE, "Your bandana was enabled automatically as you entered an active train war.");
					new stringa[120];
					format(stringa, sizeof(stringa), "{%06x}%s", color >>> 8, GangInfo[PlayerData[i][pGang]][gName]);
					fRepfamtext[i] = CreateDynamic3DTextLabel(stringa, COLOR_WHITE, 0.0, 0.0, -0.3, 20.0, .attachedplayer = i, .testlos = 1);
    			}
			}
		}
	}
	return 1;
}

forward RespawnBoxville(playerid); // sometimes bugged
public RespawnBoxville(playerid) {
    new rows, fields;
    cache_get_data(rows, fields);
    if (!rows)
        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have a boxville in the database, contact GangMod.");

    new gangid = PlayerData[playerid][pGang];

    new modelid = cache_get_field_content_int(0, "modelid");
    new color1 = cache_get_field_content_int(0, "color1");
    new color2 = cache_get_field_content_int(0, "color2");

    GangBoxville[gangid][gbX] = cache_get_field_content_float(0, "x");
    GangBoxville[gangid][gbY] = cache_get_field_content_float(0, "y");
    GangBoxville[gangid][gbZ] = cache_get_field_content_float(0, "z");
    GangBoxville[gangid][gbA] = cache_get_field_content_float(0, "angle");

    if (IsValidVehicle(GangBoxville[gangid][gbVehicle]))
        DestroyVehicle(GangBoxville[gangid][gbVehicle]);

    GangBoxville[gangid][gbVehicle] = CreateVehicle(modelid, GangBoxville[gangid][gbX], GangBoxville[gangid][gbY], GangBoxville[gangid][gbZ], GangBoxville[gangid][gbA],color1, color2, -1);

	new label[64], color = GangInfo[gangid][gColor];
	format(label, sizeof label, "{%06x}%s's\nBoxville", color >>> 8, GangInfo[gangid][gName]);
	CreateDynamic3DTextLabel(label,-1,0.0, 0.0, 0.0,20.0,INVALID_PLAYER_ID, GangBoxville[gangid][gbVehicle], 1);
    return 1;
}

hook OnGameModeInit() {
	TrainData[SpawnTimes][0] = Random(16, 18);
 	TrainData[SpawnTimes][1] = Random(20, 23);
}

hook OnPlayerConnect(playerid) {
    RemovePlayerAttachedObject(playerid, 9);
    PlayerData[playerid][pCarryingBox] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	new Float:posX, Float:posY, Float:posZ;
	GetPlayerPos(playerid, posX, posY, posZ);

	if (PlayerData[playerid][pCarryingBox]) {
	    PlayerData[playerid][pCarryingBox] = false;
        for (new i = 0; i < MAX_TRAIN_BOXES; i++) {
    		if (TrainBox[i][tbObjectID] == 0) {
				CreateTrainBox(i, 964, posX, posY, posZ - 1, 0.0, 0.0, 0.0);
			    break;
			}
  		}
	}

	RemovePlayerAttachedObject(playerid, 9);
	PlayerData[playerid][pCarryingBox] = false;
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(vehicleid == TrainData[Vehicle]) {
		ClearAnimations(playerid);
  		return 1;
	}

	for(new g = 0; g < MAX_GANGS; g++) {
		if(GangBoxville[g][gbVehicle] == vehicleid) {
		    if (!TrainData[Active]) {
				if(PlayerData[playerid][pGang] == g) {
		  			if(GangBoxville[g][CrateLoaded] > 0) {
						if(ispassenger == 0) {
							SecureBoxVilleCheckpoint = SetPlayerCheckpoint(playerid, 2447.4141, -1977.5803, 13.5469, 6.0);
		    				SendClientMessage(playerid, COLOR_YELLOW, "Go to the checkpoint to secure looted crates.");
						}
					}
				}
			}
		}
	}
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
	for(new g = 0; g < MAX_GANGS; g++) {
		if(GangBoxville[g][gbVehicle] == vehicleid) {
			if(PlayerData[playerid][pGang] == g) {
			    if(SecureBoxVilleCheckpoint) {
					DisablePlayerCheckpoint(playerid);
				}
			}
		}
	}
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    
    if (SecureBoxVilleCheckpoint) {
	    new gangid = PlayerData[playerid][pGang];
	    if (gangid == -1) return 1;
	    
     	if (vehicleid != GangBoxville[gangid][gbVehicle])
		{
      		SendClientMessage(playerid, COLOR_GREY, "You must be in your gang boxville to secure the crates!");
	        return 1;
	    }
    
	    if (GangBoxville[gangid][Securing])
	    	return SendClientMessage(playerid, COLOR_GREY, "Arleady secured by one of you're gang members");

	    if (GangBoxville[gangid][CrateLoaded] > 0) {
	        GangBoxville[gangid][Securing] = true;

	        new crates = GangBoxville[gangid][CrateLoaded];
	        new rewards[E_REWARD_TYPE];

	        for (new c = 0; c < crates; c++) {
	            GiveRandomTrainReward(gangid, rewards);
	        }

	        new str[512];
	        format(str, sizeof(str), "{006400}Train Robbery Rewards:\n\n");

	        if (rewards[REWARD_CASH] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ ${00FF00}%d {FFFFFF}Cash\n", str, rewards[REWARD_CASH]);

	        if (rewards[REWARD_MATS] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}Materials\n", str, rewards[REWARD_MATS]);

	        if (rewards[REWARD_WEED] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}Weed\n", str, rewards[REWARD_WEED]);

	        if (rewards[REWARD_HEROIN] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}Heroin\n", str, rewards[REWARD_HEROIN]);

	        if (rewards[REWARD_COCAINE] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}Cocaine\n", str, rewards[REWARD_COCAINE]);

	        if (rewards[REWARD_DEAGLE] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}Desert Eagles\n", str, rewards[REWARD_DEAGLE]);

	        if (rewards[REWARD_AK47] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}AK-47s\n", str, rewards[REWARD_AK47]);

	        if (rewards[REWARD_TEC] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}TEC-9s\n", str, rewards[REWARD_TEC]);

	        if (rewards[REWARD_UZI] > 0)
	            format(str, sizeof(str), "%s{FFFFFF}+ {00FF00}%d {FFFFFF}UZIs\n", str, rewards[REWARD_UZI]);

	        Dialog_Show(playerid, TRAIN_REWARD, DIALOG_STYLE_MSGBOX, "Train Loot Secured!", str, "Ok", "");

	        foreach (new i : Player) {
         		if (PlayerData[i][pGang] == gangid) {
             		SendClientMessageEx(i, COLOR_YELLOW, "Your gang has secured %d crates delivered by %s, rewards have been added to the gang stash.", crates, GetRPName(playerid));
           		}
	        }

	        GangBoxville[gangid][CrateLoaded] = 0;
	        DisablePlayerCheckpoint(playerid);
	        GangBoxville[gangid][Securing] = false;

         	new query[128];
		    format(query, sizeof query, "SELECT id FROM gangs_boxville WHERE gang_id=%d LIMIT 1", gangid);
		    mysql_tquery(connectionID, query, "RespawnBoxville", "d", playerid);
	    }
	}
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if ((newkeys & KEY_NO) && !(oldkeys & KEY_NO)) {
        if (TrainData[Active] && PlayerData[playerid][pGang] != -1) {
            AttemptLootBox(playerid);
        }
    }
    return 1;
}

AttemptLootBox(playerid) {
    if (!IsPlayerIdle(playerid))
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");

    if (!TrainData[Active]) return 1;

    new gangid = PlayerData[playerid][pGang];
    if (gangid < 0 || !TrainClaimed[gangid]) return 1;

    if (PlayerData[playerid][pCarryingBox])
        return SendClientMessage(playerid, COLOR_GREY, "You already carry a crate.");

    new bool:nearBox = false;

    for (new i = 0; i < MAX_TRAIN_BOXES; i++) {
        if (!TrainBox[i][tbLooted] && IsPlayerInRangeOfPoint(playerid, 2.0, TrainBox[i][tbX], TrainBox[i][tbY], TrainBox[i][tbZ])) {
            nearBox = true;

            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

            if (TrainBox[i][tbObjectID] != INVALID_OBJECT_ID) {
                DestroyDynamicObject(TrainBox[i][tbObjectID]);
                TrainBox[i][tbObjectID] = INVALID_OBJECT_ID;
            }

            TrainBox[i][tbLooted] = true;
            SetPlayerAttachedObject(playerid, 9, 964, 1, 0.243, 0.324, 0.012, -17.2, 20.7, 9.8, 0.58, 0.618, 0.677);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

            PlayerData[playerid][pCarryingBox] = true;
            SendClientMessage(playerid, -1, "You picked up a train crate, deliver it to your gang boxville!");

            if (GetBoxes() - GetLootedBoxes() == 0)
			{
	            foreach(new ui : Player)
				{
					if(PlayerData[ui][pGang] != -1 || IsLawEnforcement(ui))
					{
	    				SendClientMessage(ui, COLOR_YELLOW, "The train has been fully looted! It will leave in 15 seconds.");
	    			}
	                SetTimer("EndTrainEvent", 15000, false);
	            }
            }
            break;
        }
    }

    if (!nearBox) return 1;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
	new Float:posX, Float:posY, Float:posZ;
	GetPlayerPos(playerid, posX, posY, posZ);

	if (PlayerData[playerid][pCarryingBox]) {
	    PlayerData[playerid][pCarryingBox] = false;
        for (new i = 0; i < MAX_TRAIN_BOXES; i++) {
    		if (TrainBox[i][tbObjectID] == 0) {
            	CreateTrainBox(i, 964, posX, posY, posZ - 1, 0.0, 0.0, 0.0);
			    break;
			}
  		}
	}

	RemovePlayerAttachedObject(playerid, 9);
	PlayerData[playerid][pCarryingBox] = false;
    return 1;
}

hook OnNewHour(timestamp, hour) {
    if(hour == 0) {
        TrainData[SpawnTimes][0] = Random(16, 18);
        TrainData[SpawnTimes][1] = Random(20, 23);
    }
    if(hour == TrainData[SpawnTimes][0] || hour == TrainData[SpawnTimes][1]) {
        if(!TrainData[Active]) {
            new station = random(3);
            SpawnTrain(station);
        }
    }
    return 1;
}

hook OnNewMinute(timestamp)
{
    if(TrainData[Active])
	{
        if(TrainData[LEOClaimed])
		{
            TrainData[LEOTimer]--;
            if(TrainData[LEOTimer] == 0)
			{
                LEOTrainEndTimer();
			}
		}

	}
    return 1;
}

InitMapJefferson() {
	JeffersonTrainDecors[0] = CreateDynamicObject(2991, 2284.6733, -1153.5281, 27.7940, 0.0, 0.0, -90.0);
	JeffersonTrainDecors[1] = CreateDynamicObject(2991, 2284.6596, -1157.5390, 27.7940, 0.0, 0.0, -89.9);
	JeffersonTrainDecors[2] = CreateDynamicObject(3577, 2292.849609, -1128.923706, 26.267333, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[3] = CreateDynamicObject(3577, 2289.897460, -1137.742675, 26.188581, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[4] = CreateDynamicObject(1271, 2296.598144, -1133.357177, 26.208112, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[5] = CreateDynamicObject(1271, 2295.837402, -1133.357177, 26.208112, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[6] = CreateDynamicObject(1271, 2296.197753, -1133.357177, 26.938129, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[7] = CreateDynamicObject(1271, 2297.519042, -1137.179565, 26.198114, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[8] = CreateDynamicObject(1271, 2298.560058, -1137.179565, 26.888130, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[9] = CreateDynamicObject(1271, 2299.040527, -1137.179565, 26.198114, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[10] = CreateDynamicObject(1271, 2298.289794, -1137.179565, 26.198114, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[11] = CreateDynamicObject(1271, 2297.809326, -1137.179565, 26.888130, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[12] = CreateDynamicObject(1440, 2294.972900, -1124.843505, 26.396026, -0.099999, 0.000000, -67.400054, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[13] = CreateDynamicObject(1372, 2293.351074, -1121.734252, 25.993373, 0.000000, 0.000000, 1.499994, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[14] = CreateDynamicObject(1370, 2294.209716, -1122.757690, 26.343656, 0.000000, 0.000000, -82.399993, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[15] = CreateDynamicObject(2905, 2294.624511, -1137.592773, 25.844154, -0.799998, -16.700002, 0.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[16] = CreateDynamicObject(2907, 2298.326171, -1139.924560, 25.924980, -0.899999, -22.199995, -1.799999, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[17] = CreateDynamicObject(3577, 2295.997070, -1142.189453, 26.379713, 0.000000, 0.000000, 80.200012, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[18] = CreateDynamicObject(1299, 2290.632324, -1115.576293, 26.338441, 0.000000, 0.000000, 7.000000, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[19] = CreateDynamicObject(1427, 2294.172119, -1146.115844, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[20] = CreateDynamicObject(1427, 2294.124267, -1147.976562, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[21] = CreateDynamicObject(1427, 2294.016357, -1152.206176, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[22] = CreateDynamicObject(1427, 2293.956054, -1154.526245, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[23] = CreateDynamicObject(1427, 2281.517089, -1154.202392, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[24] = CreateDynamicObject(1427, 2281.603271, -1150.771118, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[25] = CreateDynamicObject(1427, 2281.723144, -1146.121093, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
	JeffersonTrainDecors[26] = CreateDynamicObject(1427, 2281.768310, -1144.300292, 26.355625, 0.000000, 0.000000, -91.499954, -1, -1, -1, 300.00, 300.00);
    return 1;
}

InitMapUnity() {
    UnitStationDecor[0] = CreateDynamicObject(3066, 1699.2498, -1953.5393, 15.0558, 0.0000, 0.0000, -91.7999);
	UnitStationDecor[1] = CreateDynamicObject(3066, 1718.4718, -1953.8426, 15.0558, 0.0000, 0.0000, -90.6999);
	UnitStationDecor[2] = CreateDynamicObject(3576, 1712.513183, -1943.320068, 14.066292, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[3] = CreateDynamicObject(18257, 1699.518676, -1975.227661, 13.087186, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[4] = CreateDynamicObject(944, 1706.344238, -1949.616088, 13.797185, 0.000000, 0.000000, -90.099983, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[5] = CreateDynamicObject(944, 1700.158935, -1945.444335, 13.397178, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[6] = CreateDynamicObject(944, 1703.259033, -1945.444335, 13.397178, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[7] = CreateDynamicObject(944, 1701.647583, -1945.444335, 14.837185, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[8] = CreateDynamicObject(1237, 1699.749633, -1962.554565, 13.127187, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[9] = CreateDynamicObject(944, 1689.625732, -1945.444335, 13.397178, 0.000000, -0.000002, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[10] = CreateDynamicObject(944, 1692.725830, -1945.444335, 13.397178, 0.000000, -0.000002, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[11] = CreateDynamicObject(944, 1691.114379, -1945.444335, 14.837185, 0.000000, -0.000002, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[12] = CreateDynamicObject(1237, 1699.823730, -1949.842407, 13.117187, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	UnitStationDecor[13] = CreateDynamicObject(944, 1705.970214, -1963.330932, 13.997190, 0.000000, 0.000000, 87.399925, -1, -1, -1, 300.00, 300.00);
}

InitMapCountry() {
	CountrySideDecors[0] = CreateDynamicObject(3066, 2161.7253, -677.7718, 52.5601, 7.5999, 0.6000, 51.8000);
	CountrySideDecors[1] = CreateDynamicObject(3066, 2144.6982, -665.0643, 55.5719, 8.8999, 0.6000, 53.5000);
	CountrySideDecors[6] = CreateDynamicObject(1265, 2187.389892, -685.624694, 47.691223, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	CountrySideDecors[7] = CreateDynamicObject(1265, 2188.280761, -685.624694, 47.691223, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	CountrySideDecors[8] = CreateDynamicObject(1265, 2188.280761, -686.175231, 47.691223, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	CountrySideDecors[9] = CreateDynamicObject(1265, 2187.610107, -686.555603, 47.691223, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	CountrySideDecors[10] = CreateDynamicObject(944, 2161.274658, -683.234924, 51.168636, 0.000000, 31.300018, 62.100017, -1, -1, -1, 300.00, 300.00);
	CountrySideDecors[11] = CreateDynamicObject(944, 2152.536376, -661.521362, 53.329792, 7.199999, -8.699997, 49.899997, -1, -1, -1, 300.00, 300.00);
}

GetBoxes() {
    if (TrainData[Location] == -1) return 0;

    new count = 0;
    for(new i = 0; i < sizeof(g_TrainBoxConfig); i++) {
        if(g_TrainBoxConfig[i][boxGroup] == TrainData[Location] &&
           TrainBox[i][tbObjectID] != INVALID_OBJECT_ID) {
            count++;
        }
    }
    return count;
}

GetLootedBoxes() {
    if (TrainData[Location] == -1) return 0;

    new count = 0;
    for(new i = 0; i < sizeof(g_TrainBoxConfig); i++) {
        if(g_TrainBoxConfig[i][boxGroup] == TrainData[Location] &&
           TrainBox[i][tbObjectID] != INVALID_OBJECT_ID &&
           TrainBox[i][tbLooted]) {
            count++;
        }
    }
    return count;
}

forward LEOTrainEndTimer();
public LEOTrainEndTimer() {
    if (!TrainData[Active]) return 1;

	SendClientMessageToAllEx(COLOR_YELLOW, "Train War: Law enforcement has successfully secured the train.");
	SendClientMessageToAllEx(COLOR_YELLOW, "The train will depart the station in 15 seconds.");
	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i))
	    {
	        GivePlayerCash(i, 30000);
	        SendClientMessage(i, COLOR_YELLOW, "All law enforcement have been awarded $30,000 for securing the train.");
	    }
	}
	
    SetTimer("EndTrainEvent", 15000, false);
    TrainData[LEOTimer] = -1;
    TrainData[LEOClaimed] = false;
    return 1;
}

CMD:spawntrain(playerid, params[]) {
    new station;
    if(!IsAdmin(playerid, HEAD_ADMIN) && !PlayerData[playerid][pGangMod]) {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    if(sscanf(params, "d", station)) {
        SendClientMessage(playerid, COLOR_GREY, "USAGE: /spawntrain [station]");
        SendClientMessage(playerid, -1, "Stations: 0: Jefferson , 1: Unity Station , 2: Country Side");
        return 1;
    }

    if(station < 0 || station > 2) {
        SendClientMessage(playerid, COLOR_GREY, "Invalid station use one from this stations");
        SendClientMessage(playerid, -1, "Stations: 0: Jefferson , 1: Unity Station , 2: Country Side");
        return 1;
    }

    if(TrainData[Active]) {
        SendClientMessage(playerid, COLOR_GREY, "A train is already active.");
        return 1;
    }

    new stationName[32];
    format(stationName, sizeof(stationName), TrainSpawns[station][Location]);

    SpawnTrain(station);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has force-spawned a train at %s.", GetRPName(playerid), stationName);
    return 1;
}

CMD:endtrain(playerid, params[]) {
    if(!IsAdmin(playerid, HEAD_ADMIN) && !PlayerData[playerid][pGangMod]) {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    if(!TrainData[Active]) {
        SendClientMessage(playerid, COLOR_GREY, "There no train active to end.");
        return 1;
    }

    EndTrainEvent();
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has force-end train war.", GetRPName(playerid));
    return 1;
}

CMD:settrainspawn(playerid, params[]) {
    new firstHour, secondHour;
    if(!IsAdmin(playerid, HEAD_ADMIN) && !PlayerData[playerid][pGangMod]) {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    if(sscanf(params, "dd", firstHour, secondHour)) {
        SendClientMessage(playerid, COLOR_GREY, "USAGE: /settrainspawn [first_hour] [second_hour]");
        return 1;
    }

    if(firstHour < 1 || firstHour > 23) {
        SendClientMessage(playerid, COLOR_GREY, "Hours must be between 1 and 23.");
        return 1;
    }

    if(secondHour < 1 || secondHour > 23) {
        SendClientMessage(playerid, COLOR_GREY, "Hours hour must be between 1 and 23.");
        return 1;
    }

    if(firstHour == secondHour) {
        SendClientMessage(playerid, COLOR_GREY, "Train hours cannot be the same.");
        return 1;
    }

    TrainData[SpawnTimes][0] = firstHour;
    TrainData[SpawnTimes][1] = secondHour;
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has set train spawn times to %d:00 and %d:00.", GetRPName(playerid), firstHour, secondHour);
    return 1;
}
//DEBUG
CMD:debugtime(playerid) {
	SendClientMessageEx(playerid, -1, "spawn one in %d", TrainData[SpawnTimes][0]);
	SendClientMessageEx(playerid, -1, "spawn two in %d", TrainData[SpawnTimes][1]);
	return 1;
}
