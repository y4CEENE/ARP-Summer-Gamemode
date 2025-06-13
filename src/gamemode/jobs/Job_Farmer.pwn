/// @file      Job_Farmer.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static FarmerPayment_Base = 50;
static FarmerPayment_TipPerLevel = 25;

static FarmerVehicles[19];
static Harvesting[MAX_PLAYERS];
static isharvesting[MAX_PLAYERS];


hook OnLoadGameMode(timestamp)
{
    // Farmer
    FarmerVehicles[0] = AddStaticVehicle(532,-322.2967,-1350.3434,10.5241,270.7830,0,0); // pos 1
    FarmerVehicles[1] = AddStaticVehicle(532,-322.6843,-1340.8116,10.3685,272.3377,0,0); // pos 2
    FarmerVehicles[2] = AddStaticVehicle(532,-323.0977,-1331.4840,10.4024,271.4319,0,0); // pos 3
    FarmerVehicles[3] = AddStaticVehicle(532,-323.1684,-1322.5546,10.4159,270.6801,0,0); // pos 4
    FarmerVehicles[4] = AddStaticVehicle(532,-322.1127,-1358.8835,10.8958,269.5284,0,0); // pos 5
    FarmerVehicles[5] = AddStaticVehicle(478,-368.9034,-1360.9902,21.7564,93.9769,1,1); // car1
    FarmerVehicles[6] = AddStaticVehicle(478,-369.6640,-1364.9237,21.9200,82.5297,1,1); // car2
    FarmerVehicles[7] = AddStaticVehicle(478,-370.0378,-1368.0313,22.0123,79.5341,1,1); // car3
    FarmerVehicles[8] = AddStaticVehicle(478,-370.0262,-1371.3488,22.0194,84.8406,1,1); // car4
    FarmerVehicles[9] = AddStaticVehicle(478,-368.7458,-1359.5483,21.7232,86.1116,1,1); // car5

    new Node:job;
    new Node:farmer;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "farmer", farmer))
    {
        JSON_GetInt(farmer, "payment_base",          FarmerPayment_Base);
        JSON_GetInt(farmer, "payment_tip_per_level", FarmerPayment_TipPerLevel);
    }
    return 1;
}

IsAFarmerCar(carid)
{
    for (new v = 0; v < sizeof(FarmerVehicles); v++)
    {
        if (carid == FarmerVehicles[v]) return 1;
    }
    if (VehicleInfo[carid][vJob] == JOB_FARMER) return 1;
    return 0;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_FARMER)
        return 1;

    isharvesting[playerid] = 1;
    // created by someone else, unable to find original author.
    if (IsPlayerInRangeOfPoint(playerid, 10, -309.0990,-1381.1797,10.7049))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -286.6838,-1366.6523,9.2448, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -286.6838,-1366.6523,9.2448))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -299.1016,-1345.1233,7.8737, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -299.1016,-1345.1233,7.8737))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -285.5391,-1314.0519,9.4996, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -285.5391,-1314.0519,9.4996))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -263.7585,-1322.7645,9.2727, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -263.7585,-1322.7645,9.2727))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -247.7353,-1312.8854,10.7708, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -247.7353,-1312.8854,10.7708))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -230.6390,-1326.7452,10.5278, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -230.6390,-1326.7452,10.5278))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -208.9200,-1312.6355,8.0123, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -208.9200,-1312.6355,8.0123))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -184.9501,-1314.5737,6.7411, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -184.9501,-1314.5737,6.7411))
    {
        SendClientMessage(playerid, COLOR_GREY, "FARMER: Well done! You got 15 More checkpoints to go.");
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -165.0671,-1340.6115,3.1610, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -165.0671,-1340.6115,3.1610))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -182.6981,-1357.5033,4.1997, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -182.6981,-1357.5033,4.1997))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -166.5868,-1381.2855,3.2646, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -166.5868,-1381.2855,3.2646))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -169.7452,-1395.7577,3.3153, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -169.7452,-1395.7577,3.3153))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -162.0952,-1412.2350,3.0394, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -162.0952,-1412.2350,3.0394))
    {
        SendClientMessage(playerid, COLOR_GREY, "FARMER: Well done! You got 10 More checkpoints to go.");
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -192.4460,-1407.2355,3.9017, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -192.4460,-1407.2355,3.9017))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -207.5008,-1421.8888,3.2155, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -207.5008,-1421.8888,3.2155))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -226.2545,-1411.9092,6.5599, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -226.2545,-1411.9092,6.5599))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -247.6317,-1427.6404,6.6805, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -247.6317,-1427.6404,6.6805))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -263.1941,-1420.1913,9.3854, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -263.1941,-1420.1913,9.3854))
    {
        SendClientMessage(playerid, COLOR_GREY, "FARMER: Well done! You got 5 More checkpoints to go.");
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -284.1987,-1431.4486,12.0138, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -284.1987,-1431.4486,12.0138))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -300.6557,-1424.9337,14.0705, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -300.6557,-1424.9337,14.0705))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -320.6297,-1431.7501,15.1514, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -320.6297,-1431.7501,15.1514))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -330.9842,-1410.7192,14.1269, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -330.9842,-1410.7192,14.1269))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -343.0883,-1369.3920,14.4816, 10);
    }
    if (IsPlayerInRangeOfPoint(playerid, 10, -343.0883,-1369.3920,14.4816))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new amount = FarmerPayment_Base + FarmerPayment_TipPerLevel * GetJobLevel(playerid,JOB_FARMER);
        SendClientMessageEx(playerid, COLOR_AQUA,"FARM: You've harvested the field and made $%i from selling the crops.", amount);
        PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
        SetVehicleToRespawn(vehicleid);
        Harvesting[playerid] = 0;
        AddToPaycheck(playerid, amount);
        IncreaseJobSkill(playerid,JOB_FARMER);
        GivePlayerRankPointLegalJob(playerid, 50);
    }
    return 1;
}


CMD:harvest(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_FARMER && PlayerData[playerid][pSecondJob] != JOB_FARMER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a Farmer!");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
    }
    new vehicleid = GetPlayerVehicleID(playerid);
    if (IsAFarmerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        isharvesting[playerid] = 1;
        GameTextForPlayer(playerid, "Proceed to the~n~Checkpoint", 5000, 3);
        SendClientMessage(playerid, COLOR_AQUA, "Follow the checkpoints to harvest the crops.");
        SetActiveCheckpoint(playerid, CHECKPOINT_FARMER, -309.0990,-1381.1797,10.7049, 10);
        Harvesting[playerid] = 1;
    }
    else return SendClientMessage(playerid, COLOR_GREY, "FARMER: You must be driving a farming vehicle!");
    return 1;
}

hook OnPlayerInit(playerid)
{
    isharvesting[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    isharvesting[playerid] = 0;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
    if (isharvesting[playerid] == 1)
    {
        SendClientMessage(playerid, COLOR_GREY, "You left your vehicle, you cannot complete the job.");
        CancelActiveCheckpoint(playerid);
        isharvesting[playerid] = 0;
    }
}
