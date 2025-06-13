/// @file      Job_Forklift.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static ForkliftPayment_Base = 50;
static ForkliftPayment_TipPerLevel = 20;
static ForkliftPayment_MaxRandomTip = 10;

static ForkliftNOPTime[MAX_PLAYERS];
static ForkliftNOPTick[MAX_PLAYERS];
static forkliftVehicles[20];
static forkliftVehiclesAttachedObjects[20];

hook OnPlayerInit(playerid)
{
    ForkliftNOPTick[playerid] = 0;
    ForkliftNOPTime[playerid] = 0;
    return 1;
}

IsForkliftVehicle(vehicleid)
{
    return (forkliftVehicles[0] <= vehicleid <= forkliftVehicles[sizeof(forkliftVehicles) - 1]);
}

hook OnPlayerEnterJobCar(playerid, vehicleid, jobtype)
{
    if (jobtype == JOB_FORKLIFT)
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FORKLIFT, 2642.4553, -2138.4583, 13.5469);
    }
}

hook OnLoadGameMode(timestamp)
{
        //forklift
    CreateDynamicObject(1421, 2572.76270, -2114.40015, 13.48325,   0.00000, 0.00000, 88.60887);
    CreateDynamicObject(1421, 2571.35498, -2114.78052, 13.48330,   0.00000, 0.00000, 0.91300);
    CreateDynamicObject(1421, 2571.46802, -2113.75732, 13.48330,   0.00000, 0.00000, 0.91300);

    for (new i=0;i<sizeof(forkliftVehiclesAttachedObjects);i++)
    {
        forkliftVehiclesAttachedObjects[i]=-1;
    }
    forkliftVehicles[0] = AddStaticVehicleEx(530,2455.1477,-2119.6931,13.3103,1.3763,6,6,300); // Forklift  530
    forkliftVehicles[1] = AddStaticVehicleEx(530,2457.7871,-2119.7100,13.3152,358.2458,6,6,300); // Forklift    530
    forkliftVehicles[2] = AddStaticVehicleEx(530,2460.8132,-2119.7644,13.3181,355.1994,6,6,300); // Forklift    530
    forkliftVehicles[3] = AddStaticVehicleEx(530,2463.7651,-2119.8726,13.3184,357.0535,6,6,300); // Forklift    530
    forkliftVehicles[4] = AddStaticVehicleEx(530,2466.1633,-2119.8604,13.3184,357.4330,6,6,300); // Forklift    530
    forkliftVehicles[5] = AddStaticVehicleEx(530,2468.7246,-2119.8569,13.3145,  0.2573,6,6,300); // Forklift    530
    forkliftVehicles[6] = AddStaticVehicleEx(530,2471.0352,-2119.8208,13.3109,354.9529,6,6,300); // Forklift    530
    forkliftVehicles[7] = AddStaticVehicleEx(530,2473.6580,-2119.8733,13.3104,355.6479,6,6,300); // Forklift    530
    forkliftVehicles[8] = AddStaticVehicleEx(530,2476.2007,-2119.8804,13.3101,357.3682,6,6,300); // Forklift    530
    forkliftVehicles[9] = AddStaticVehicleEx(530,2478.8728,-2119.9060,13.3107,355.0261,6,6,300); // Forklift    530
    forkliftVehicles[10] = AddStaticVehicleEx(530,2482.0078,-2119.9050,13.3127,358.8703,6,6,300); // Forklift   530
    forkliftVehicles[11] = AddStaticVehicleEx(530,2484.8625,-2119.8733,13.3122,359.9700,6,6,300); // Forklift   530
    forkliftVehicles[12] = AddStaticVehicleEx(530,2487.1860,-2119.8420,13.3123,356.4454,6,6,300); // Forklift   530
    forkliftVehicles[13] = AddStaticVehicleEx(530,2505.7708,-2119.5823,13.3102,355.7766,6,6,300); // Forklift   530
    forkliftVehicles[14] = AddStaticVehicleEx(530,2508.5269,-2119.7148,13.3085,355.2477,6,6,300); // Forklift   530
    forkliftVehicles[15] = AddStaticVehicleEx(530,2511.7710,-2119.8342,13.3114,357.5549,6,6,300); // Forklift   530
    forkliftVehicles[16] = AddStaticVehicleEx(530,2515.0471,-2119.9265,13.3095,353.9868,6,6,300); // Forklift   530
    forkliftVehicles[17] = AddStaticVehicleEx(530,2517.9558,-2120.0652,13.3103,357.1204,6,6,300); // Forklift   530
    forkliftVehicles[18] = AddStaticVehicleEx(530,2520.3979,-2120.1245,13.3077,358.0684,6,6,300); // Forklift   530
    forkliftVehicles[19] = AddStaticVehicleEx(530,2522.7188,-2120.2078,13.3104,1.6939,6,6,300); // Forklift 530

    new Node:job;
    new Node:forklift;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "forklift", forklift))
    {
        JSON_GetInt(forklift, "payment_base",           ForkliftPayment_Base);
        JSON_GetInt(forklift, "payment_tip_per_level",  ForkliftPayment_TipPerLevel);
        JSON_GetInt(forklift, "payment_max_random_tip", ForkliftPayment_MaxRandomTip);
    }
    return 1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_FORKLIFT)
        return 1;

    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 530 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        CancelActiveCheckpoint(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "You need to be driving a Forklift.");
    }
    if (IsPlayerInRangeOfPoint(playerid, 5, 2642.4553,-2138.4583,13.5469))
    {
        SetActiveCheckpoint(playerid, CHECKPOINT_FORKLIFT, 2449.0776,-2090.1296,13.5469, 5);
        SendClientMessage(playerid, COLOR_AQUA, "FORKLIFT: You loaded a package. Deliver it to destination.");

        for (new i=0;i<sizeof(forkliftVehicles);i++)
        {

            if ((forkliftVehicles[i]==GetPlayerVehicleID(playerid)))
            {
                if (forkliftVehiclesAttachedObjects[i]!=-1)
                {
                    SendClientMessage(playerid, COLOR_AQUA, "FORKLIFT: Dropping old box.");
                }
                else
                {
                    forkliftVehiclesAttachedObjects[i] = CreateDynamicObjectEx(964, 0, 0.9, -0.12, 0, 0, 0);
                    AttachObjectToVehicle(forkliftVehiclesAttachedObjects[i], GetPlayerVehicleID(playerid), 0, 0.9, -0.12, 0, 0, 0);
                    ForkliftNOPTime[playerid] = gettime();
                }
                break;
            }
        }
    }
    if (IsPlayerInRangeOfPoint(playerid, 5, 2449.0776,-2090.1296,13.5469))
    {
        if (gettime() - 8 < ForkliftNOPTime[playerid])
        {
            ForkliftNOPTick[playerid]++;
            if (ForkliftNOPTick[playerid] > 3)
            {
                return BanPlayer(playerid, "Forklift Teleport");
            }
        }
        SetActiveCheckpoint(playerid, CHECKPOINT_FORKLIFT, 2642.4553,-2138.4583,13.5469, 5);

        new money = ForkliftPayment_Base;
        money += GetJobLevel(playerid, JOB_FORKLIFT) * ForkliftPayment_TipPerLevel;
        money += Random(0, ForkliftPayment_MaxRandomTip);
        GivePlayerCash(playerid,money);
        SendClientMessageEx(playerid, COLOR_AQUA, "FORKLIFT: You Delivered a package. And you got $%i.",money);

        for (new i=0;i<sizeof(forkliftVehicles);i++)
        {
            if ((forkliftVehicles[i]==GetPlayerVehicleID(playerid)) && (forkliftVehiclesAttachedObjects[i]!=-1))
            {
                DestroyObject(forkliftVehiclesAttachedObjects[i]);
                forkliftVehiclesAttachedObjects[i]=-1;
                break;
            }
        }
        IncreaseJobSkill(playerid, JOB_FORKLIFT);
        GivePlayerRankPointLegalJob(playerid, 20);

    }
    return 1;
}
