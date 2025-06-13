/// @file      Jobs.inc
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

#include "jobs/Job_Armsdealer.pwn"
#include "jobs/Job_Bartender.pwn"
#include "jobs/Job_Brinks.pwn"
#include "jobs/Job_Butcher.pwn"
//#include "jobs/Job_Construction.pwn"
#include "jobs/Job_CraftMan.pwn"
#include "jobs/Job_DrugDealer.pwn"
#include "jobs/Job_DrugSmuggler.pwn"
#include "jobs/Job_Farmer.pwn"
#include "jobs/Job_Fisherman.pwn"
#include "jobs/Job_Forklift.pwn"
#include "jobs/Job_GarbageMan.pwn"
#include "jobs/Job_Hooker.pwn"
#include "jobs/Job_Lawyer.pwn"
#include "jobs/Job_Lumberjack.pwn"
#include "jobs/Job_Mechanic.pwn"
#include "jobs/Job_Milker.pwn"
#include "jobs/Job_Miner.pwn"
#include "jobs/Job_PizzaMan.pwn"
//#include "jobs/Job_Recycle.pwn"
#include "jobs/Job_ScubaDiver.pwn"
#include "jobs/Job_Sweeper.pwn"
#include "jobs/Job_TaxiDriver.pwn"
#include "jobs/Job_Trucker.pwn"

#include <YSI\y_hooks>

static QuitJobSlot[MAX_PLAYERS];

hook OnLoadGameMode(timestamp)
{
    new string[320];
    for (new i = 0; i < sizeof(jobLocations); i ++)
    {
        format(string, sizeof string, "{33CCFF}Job Point ({FFFFFF}ID: %i{33CCFF})\n\nName: {FFFFFF}%s\n{33CCFF}Press {FFFFFF}N{33CCFF} or type {FFFFFF}/join {33CCFF}\nto obtain the job.", i, jobLocations[i][jobName]);
        CreateDynamic3DTextLabel(string, COLOR_YELLOW, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 10.0, .testlos = 1, .streamdistance = 10.0);
        CreateDynamicMapIcon(jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 56, 0, .style = MAPICON_GLOBAL);
        jobLocations[i][jobActorID] = CreateActor(jobLocations[i][jobActor], jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], jobLocations[i][actorangle]);
    }
    return 1;
}

Dialog:JobQuitConfirm(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (QuitJobSlot[playerid] == 1)
        {
            DBQuery("UPDATE "#TABLE_USERS" SET job = -1 WHERE uid = %i", PlayerData[playerid][pID]);
            RemovePlayerFromVehicle(playerid);
            PlayerData[playerid][pJob] = JOB_NONE;
            SendClientMessageEx(playerid, COLOR_AQUA, "You have quit your job as a {00AA00}%s{33CCFF}.", GetJobName(PlayerData[playerid][pJob]));
        }
        else if (QuitJobSlot[playerid] == 2)
        {
            DBQuery("UPDATE "#TABLE_USERS" SET secondjob = -1 WHERE uid = %i", PlayerData[playerid][pID]);
            RemovePlayerFromVehicle(playerid);
            PlayerData[playerid][pSecondJob] = JOB_NONE;
            SendClientMessageEx(playerid, COLOR_AQUA, "You have quit your secondary job as a {00AA00}%s{33CCFF}.", GetJobName(PlayerData[playerid][pSecondJob]));
        }
    }
}

Dialog:JobJoinConfirm(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new idx=0;
        for (new i = 0; i < sizeof(jobLocations); i ++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 3.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
            {
                idx=i;
            }
        }

        if (PlayerData[playerid][pJob] != JOB_NONE &&
            (GetMaxPlayerJobs(playerid) >= 2) &&
            PlayerData[playerid][pSecondJob] == JOB_NONE)
        {
            DBQuery("UPDATE "#TABLE_USERS" SET secondjob = %i WHERE uid = %i", jobLocations[idx][jobID], PlayerData[playerid][pID]);
            PlayerData[playerid][pSecondJob] = jobLocations[idx][jobID];
            SendClientMessageEx(playerid, COLOR_WHITE, "You are now a {FF0000}%s{ffffff}. Use /jobhelp for a list of commands related to your new job.", jobLocations[idx][jobName]);
            ApplyActorAnimation(jobLocations[idx][jobActorID], "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1);
        }
        else if ( PlayerData[playerid][pJob] == JOB_NONE )
        {

            DBQuery("UPDATE "#TABLE_USERS" SET job = %i WHERE uid = %i", jobLocations[idx][jobID], PlayerData[playerid][pID]);
            PlayerData[playerid][pJob] = jobLocations[idx][jobID];
            SendClientMessageEx(playerid, COLOR_WHITE, "You are now a {ffff00}%s{ffffff}. Use /jobhelp for a list of commands related to your new job.", jobLocations[idx][jobName]);
            ApplyActorAnimation(jobLocations[idx][jobActorID], "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1);
        }
        AwardAchievement(playerid, ACH_FinallyAJob);
    }
}

GetJobHelp(jobid)
{
    new string[152];
    for (new i=0;i<sizeof(jobLocations);i++)
    {
        if (jobLocations[i][jobID] == jobid)
        {
            if (!isnull(jobLocations[i][jobHelp]))
            {
                format(string,sizeof(string),"** JOB ** %s.",jobLocations[i][jobHelp]);
            }
            return string;
        }
    }
    return string;
}

GetJobName(jobid)
{
    new name[32];

    for (new i = 0; i < sizeof(jobLocations); i ++)
    {
        if (jobid == jobLocations[i][jobID])
        {
            strcat(name, jobLocations[i][jobName]);
            return name;
        }
    }
    name = "None";
    return name;
}

PlayerHasJob(playerid, job)
{
    return (PlayerData[playerid][pJob] == job || PlayerData[playerid][pSecondJob] == job);
}

GetMaxPlayerJobs(playerid)
{
    if (PlayerData[playerid][pDonator] >= 2 || PlayerData[playerid][pLevel] >= 25)
    {
        return 2;
    }
    return 1;
}

IncreaseJobSkill(playerid, jobid)
{
    if (IsDoubleXPEnabled() || PlayerData[playerid][pDoubleXP] > 0)
    {
        GiveJobSkill(playerid, jobid);
    }

    GiveJobSkill(playerid, jobid);
}

IsJobCar(vehicleid)
{
    return (GetCarJobType(vehicleid) != JOB_NONE);
}

OnJobVehicleRespawn(vehicleid)
{
    new jobid = GetCarJobType(vehicleid);
    switch (jobid)
    {
        case JOB_LUMBERJACK:
        {
            OnLumberJackVehicleRespawned(vehicleid);
        }
    }
}

GetCarJobType(vehicleid)
{
    if (vehicleid == INVALID_VEHICLE_ID)
        return JOB_NONE;

    if (IsForkliftVehicle(vehicleid))
        return JOB_FORKLIFT;
    if (IsMechanicVehicle(vehicleid))
        return JOB_MECHANIC;
    if (IsGarbageManVehicle(vehicleid))
        return JOB_GARBAGEMAN;
    if (IsTruckerVehicle(vehicleid))
        return JOB_TRUCKER;
    if (IsLumberjackVehicle(vehicleid))
        return JOB_LUMBERJACK;
    if (IsSweepingVehicle(vehicleid))
        return JOB_SWEEPER;
    if (IsPizzaJobVehicle(vehicleid))
        return JOB_PIZZAMAN;
    if (IsTaxiJobVehicle(vehicleid))
        return JOB_TAXIDRIVER;
    if (IsBrinksVehicle(vehicleid))
        return JOB_BRINKS;

    return VehicleInfo[vehicleid][vJob];
}

CanEnterJobCar(playerid,vehicleid)
{
    if (GetVehicleModel(vehicleid) == 515 && GetJobLevel(playerid, JOB_TRUCKER)<5)
        return false;
    if (GetCarJobType(vehicleid)==JOB_SWEEPER)
        return true;
    return (PlayerHasJob(playerid, GetCarJobType(vehicleid)) && IsJobCar(vehicleid));
}

ShowSkillsDialog(playerid)
{
    new strmechanic[64], strdrugsmuggler[64], strdrugdealer[64], strarmsdealer[64], strdetective[64], strlawyer[64],
    strforklift[64], strcraftman[64], strpizza[64], strtrucker[64], strhooker[64], strfisher[64], strcarjacker[64],
    strrobbery[64], strfarmer[64],string[2048];

    if (GetJobLevel(playerid, JOB_MECHANIC) < 5)
    {
        if (PlayerData[playerid][pMechanicSkill] < 50)
        {
            format(strmechanic, sizeof(strmechanic), "Fix %i more vehicles to level up.", 50 - PlayerData[playerid][pMechanicSkill]);
        }
        else if (PlayerData[playerid][pMechanicSkill] < 100)
        {
            format(strmechanic, sizeof(strmechanic), "Fix %i more vehicles to level up.", 100 - PlayerData[playerid][pMechanicSkill]);
        }
        else if (PlayerData[playerid][pMechanicSkill] < 200)
        {
            format(strmechanic, sizeof(strmechanic), "Fix %i more vehicles to level up.", 200 - PlayerData[playerid][pMechanicSkill]);
        }
        else if (PlayerData[playerid][pMechanicSkill] < 400)
        {
            format(strmechanic, sizeof(strmechanic), "Fix %i more vehicles to level up.", 400 - PlayerData[playerid][pMechanicSkill]);
        }
    }
    else
    {
        format(strmechanic, sizeof(strmechanic), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_DRUGSMUGGLER) < 5)
    {
        if (PlayerData[playerid][pSmugglerSkill] < 50)
        {
            format(strdrugsmuggler, sizeof(strdrugsmuggler), "Smuggle %i more packages to level up.", 50 - PlayerData[playerid][pSmugglerSkill]);
        }
        else if (PlayerData[playerid][pSmugglerSkill] < 100)
        {
            format(strdrugsmuggler, sizeof(strdrugsmuggler), "Smuggle %i more packages to level up.", 100 - PlayerData[playerid][pSmugglerSkill]);
        }
        else if (PlayerData[playerid][pSmugglerSkill] < 200)
        {
            format(strdrugsmuggler, sizeof(strdrugsmuggler), "Smuggle %i more packages to level up.", 200 - PlayerData[playerid][pSmugglerSkill]);
        }
        else if (PlayerData[playerid][pSmugglerSkill] < 400)
        {
            format(strdrugsmuggler, sizeof(strdrugsmuggler), "Smuggle %i more packages to level up.", 400 - PlayerData[playerid][pSmugglerSkill]);
        }
    }
    else
    {
        format(strdrugsmuggler, sizeof(strdrugsmuggler), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_DRUGDEALER) < 5)
    {
        if (PlayerData[playerid][pDrugDealerSkill] < 50)
        {
            format(strdrugdealer, sizeof(strdrugdealer), "Sell %i more drugs to level up.", 50 - PlayerData[playerid][pDrugDealerSkill]);
        }
        else if (PlayerData[playerid][pDrugDealerSkill] < 100)
        {
            format(strdrugdealer, sizeof(strdrugdealer), "Sell %i more drugs to level up.", 100 - PlayerData[playerid][pDrugDealerSkill]);
        }
        else if (PlayerData[playerid][pDrugDealerSkill] < 200)
        {
            format(strdrugdealer, sizeof(strdrugdealer), "Sell %i more drugs to level up.", 200 - PlayerData[playerid][pDrugDealerSkill]);
        }
        else if (PlayerData[playerid][pDrugDealerSkill] < 400)
        {
            format(strdrugdealer, sizeof(strdrugdealer), "Sell %i more drugs to level up.", 400 - PlayerData[playerid][pDrugDealerSkill]);
        }
    }
    else
    {
        format(strdrugdealer, sizeof(strdrugdealer), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_ARMSDEALER) < 5)
    {
        if (PlayerData[playerid][pWeaponSkill] < 50)
        {
            format(strarmsdealer, sizeof(strarmsdealer), "Sell %i more weapons to level up.", 50 - PlayerData[playerid][pWeaponSkill]);
        }
        else if (PlayerData[playerid][pWeaponSkill] < 100)
        {
            format(strarmsdealer, sizeof(strarmsdealer), "Sell %i more weapons to level up.", 100 - PlayerData[playerid][pWeaponSkill]);
        }
        else if (PlayerData[playerid][pWeaponSkill] < 200)
        {
            format(strarmsdealer, sizeof(strarmsdealer), "Sell %i more weapons to level up.", 200 - PlayerData[playerid][pWeaponSkill]);
        }
        else if (PlayerData[playerid][pWeaponSkill] < 400)
        {
            format(strarmsdealer, sizeof(strarmsdealer), "Sell %i more weapons to level up.", 400 - PlayerData[playerid][pWeaponSkill]);
        }
    }
    else
    {
        format(strarmsdealer, sizeof(strarmsdealer), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_DETECTIVE) < 5)
    {
        if (PlayerData[playerid][pDetectiveSkill] < 50)
        {
            format(strdetective, sizeof(strdetective), "Find %i more people to level up.", 50 - PlayerData[playerid][pDetectiveSkill]);
        }
        else if (PlayerData[playerid][pDetectiveSkill] < 100)
        {
            format(strdetective, sizeof(strdetective), "Find %i more people to level up.", 100 - PlayerData[playerid][pDetectiveSkill]);
        }
        else if (PlayerData[playerid][pDetectiveSkill] < 200)
        {
            format(strdetective, sizeof(strdetective), "You need to find %i more people to level up.", 200 - PlayerData[playerid][pDetectiveSkill]);
        }
        else if (PlayerData[playerid][pDetectiveSkill] < 400)
        {
            format(strdetective, sizeof(strdetective), "Find %i more people to level up.", 400 - PlayerData[playerid][pDetectiveSkill]);
        }
    }
    else
    {
        format(strdetective, sizeof(strdetective), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_LAWYER) < 5)
    {
        if (PlayerData[playerid][pLawyerSkill] < 50)
        {
            format(strlawyer, sizeof(strlawyer), "Defend %i more clients to level up.", 50 - PlayerData[playerid][pLawyerSkill]);
        }
        else if (PlayerData[playerid][pLawyerSkill] < 100)
        {
            format(strlawyer, sizeof(strlawyer), "Defend %i more clients to level up.", 100 - PlayerData[playerid][pLawyerSkill]);
        }
        else if (PlayerData[playerid][pLawyerSkill] < 200)
        {
            format(strlawyer, sizeof(strlawyer), "Defend %i more clients to level up.", 200 - PlayerData[playerid][pLawyerSkill]);
        }
        else if (PlayerData[playerid][pLawyerSkill] < 400)
        {
            format(strlawyer, sizeof(strlawyer), "Defend %i more clients to level up.", 400 - PlayerData[playerid][pLawyerSkill]);
        }
    }
    else
    {
        format(strlawyer, sizeof(strlawyer), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_FORKLIFT) < 5)
    {
        if (PlayerData[playerid][pForkliftSkill] < 50)
        {
            format(strforklift, sizeof(strforklift), "Deliver %i more to level up.", 50 - PlayerData[playerid][pForkliftSkill]);
        }
        else if (PlayerData[playerid][pForkliftSkill] < 100)
        {
            format(strforklift, sizeof(strforklift), "Deliver %i more to level up.", 100 - PlayerData[playerid][pForkliftSkill]);
        }
        else if (PlayerData[playerid][pForkliftSkill] < 200)
        {
            format(strforklift, sizeof(strforklift), "Deliver %i more to level up.", 200 - PlayerData[playerid][pForkliftSkill]);
        }
        else if (PlayerData[playerid][pForkliftSkill] < 400)
        {
            format(strforklift, sizeof(strforklift), "Deliver %i more to level up.", 400 - PlayerData[playerid][pForkliftSkill]);
        }
    }
    else
    {
        format(strforklift, sizeof(strforklift), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_CRAFTMAN) < 5)
    {
        if (PlayerData[playerid][pCraftSkill] < 50)
        {
            format(strcraftman, sizeof(strcraftman), "Craft %i more to level up.", 50 - PlayerData[playerid][pCraftSkill]);
        }
        else if (PlayerData[playerid][pCraftSkill] < 100)
        {
            format(strcraftman, sizeof(strcraftman), "Craft %i more to level up.", 100 - PlayerData[playerid][pCraftSkill]);
        }
        else if (PlayerData[playerid][pCraftSkill] < 200)
        {
            format(strcraftman, sizeof(strcraftman), "Craft %i more to level up.", 200 - PlayerData[playerid][pCraftSkill]);
        }
        else if (PlayerData[playerid][pCraftSkill] < 400)
        {
            format(strcraftman, sizeof(strcraftman), "Craft %i more to level up.", 400 - PlayerData[playerid][pCraftSkill]);
        }
    }
    else
    {
        format(strcraftman, sizeof(strcraftman), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_PIZZAMAN) < 5)
    {
        if (PlayerData[playerid][pPizzaSkill] < 50)
        {
            format(strpizza, sizeof(strpizza), "Deliver %i more pizza to level up.", 50 - PlayerData[playerid][pPizzaSkill]);
        }
        else if (PlayerData[playerid][pPizzaSkill] < 100)
        {
            format(strpizza, sizeof(strpizza), "Deliver %i more pizza to level up.", 100 - PlayerData[playerid][pPizzaSkill]);
        }
        else if (PlayerData[playerid][pPizzaSkill] < 200)
        {
            format(strpizza, sizeof(strpizza), "Deliver %i more pizza to level up.", 200 - PlayerData[playerid][pPizzaSkill]);
        }
        else if (PlayerData[playerid][pPizzaSkill] < 400)
        {
            format(strpizza, sizeof(strpizza), "Deliver %i more pizza to level up.", 400 - PlayerData[playerid][pPizzaSkill]);
        }
    }
    else
    {
        format(strpizza, sizeof(strpizza), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_TRUCKER) < 10)
    {
        if (PlayerData[playerid][pTruckerSkill] < 50)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 50 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 100)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 100 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 200)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 200 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 400)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 400 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 450)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 450 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 500)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 500 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 600)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 600 - PlayerData[playerid][pTruckerSkill]);
        }
        else if (PlayerData[playerid][pTruckerSkill] < 800)
        {
            format(strtrucker, sizeof(strtrucker), "Deliver %i more shipments to level up.", 800 - PlayerData[playerid][pTruckerSkill]);
        }
    }
    else
    {
        format(strtrucker, sizeof(strtrucker), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_HOOKER) < 5)
    {
        if (PlayerData[playerid][pHookerSkill] < 50)
        {
            format(strhooker, sizeof(strhooker), "Have sex %i to level up.", 50 - PlayerData[playerid][pHookerSkill]);
        }
        else if (PlayerData[playerid][pHookerSkill] < 100)
        {
            format(strhooker, sizeof(strhooker), "Have sex %i to level up.", 100 - PlayerData[playerid][pHookerSkill]);
        }
        else if (PlayerData[playerid][pHookerSkill] < 200)
        {
            format(strhooker, sizeof(strhooker), "Have sex %i to level up.", 200 - PlayerData[playerid][pHookerSkill]);
        }
        else if (PlayerData[playerid][pHookerSkill] < 400)
        {
            format(strhooker, sizeof(strhooker), "Have sex %i to level up.", 400 - PlayerData[playerid][pHookerSkill]);
        }
    }
    else
    {
        format(strhooker, sizeof(strhooker), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_FISHERMAN) < 5)
    {
        if (PlayerData[playerid][pFishingSkill] < 50)
        {
            format(strfisher, sizeof(strfisher), "Catch %i more fish to level up.", 50 - PlayerData[playerid][pFishingSkill]);
        }
        else if (PlayerData[playerid][pFishingSkill] < 100)
        {
            format(strfisher, sizeof(strfisher), "Catch %i more fish to level up.", 100 - PlayerData[playerid][pFishingSkill]);
        }
        else if (PlayerData[playerid][pFishingSkill] < 200)
        {
            format(strfisher, sizeof(strfisher), "Catch %i more fish to level up.", 200 - PlayerData[playerid][pFishingSkill]);
        }
        else if (PlayerData[playerid][pFishingSkill] < 400)
        {
            format(strfisher, sizeof(strfisher), "Catch %i more fish to level up.", 400 - PlayerData[playerid][pFishingSkill]);
        }
    }
    else
    {
        format(strfisher, sizeof(strfisher), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_FARMER) < 5)
    {
        if (PlayerData[playerid][pFarmerSkill] < 50)
        {
            format(strfarmer, sizeof(strfarmer), "Harvest %i more to level up.", 50 - PlayerData[playerid][pFarmerSkill]);
        }
        else if (PlayerData[playerid][pFarmerSkill] < 100)
        {
            format(strfarmer, sizeof(strfarmer), "Harvest %i more to level up.", 100 - PlayerData[playerid][pFarmerSkill]);
        }
        else if (PlayerData[playerid][pFarmerSkill] < 200)
        {
            format(strfarmer, sizeof(strfarmer), "Harvest %i more to level up.", 200 - PlayerData[playerid][pFarmerSkill]);
        }
        else if (PlayerData[playerid][pFarmerSkill] < 400)
        {
            format(strfarmer, sizeof(strfarmer), "Harvest %i more to level up.", 400 - PlayerData[playerid][pFarmerSkill]);
        }
    }
    else
    {
        format(strfarmer, sizeof(strfarmer), "You have reached the maximum skill level for this job.");
    }

    if (GetJobLevel(playerid, JOB_CARJACKER) < 5)
    {
        if (PlayerData[playerid][pCarJackerSkill] < 50)
        {
            format(strcarjacker, sizeof(strcarjacker), "Drop %i more cars to level up.", 50 - PlayerData[playerid][pCarJackerSkill]);
        }
        else if (PlayerData[playerid][pCarJackerSkill] < 100)
        {
            format(strcarjacker, sizeof(strcarjacker), "Drop %i more cars to level up.", 100 - PlayerData[playerid][pCarJackerSkill]);
        }
        else if (PlayerData[playerid][pCarJackerSkill] < 200)
        {
            format(strcarjacker, sizeof(strcarjacker), "Drop %i more cars to level up.", 200 - PlayerData[playerid][pCarJackerSkill]);
        }
        else if (PlayerData[playerid][pCarJackerSkill] < 400)
        {
            format(strcarjacker, sizeof(strcarjacker), "Drop %i more cars to level up.", 400 - PlayerData[playerid][pCarJackerSkill]);
        }
    }
    else
    {
        format(strcarjacker, sizeof(strcarjacker), "You have reached the maximum skill level for this activity.");
    }

    if (GetJobLevel(playerid, JOB_ROBBERY) < 5)
    {
        if (PlayerData[playerid][pRobberySkill] < 50)
        {
            format(strrobbery, sizeof(strrobbery), "Picklock cars or rob %i more to level up.", 50 - PlayerData[playerid][pRobberySkill]);
        }
        else if (PlayerData[playerid][pRobberySkill] < 100)
        {
            format(strrobbery, sizeof(strrobbery), "Picklock cars or rob %i more to level up.", 100 - PlayerData[playerid][pRobberySkill]);
        }
        else if (PlayerData[playerid][pRobberySkill] < 200)
        {
            format(strrobbery, sizeof(strrobbery), "Picklock cars or rob %i more to level up.", 200 - PlayerData[playerid][pRobberySkill]);
        }
        else if (PlayerData[playerid][pRobberySkill] < 400)
        {
            format(strrobbery, sizeof(strrobbery), "Picklock cars or rob %i more to level up.", 400 - PlayerData[playerid][pRobberySkill]);
        }
    }
    else
    {
        format(strrobbery, sizeof(strrobbery), "You have reached the maximum skill level for this activity.");
    }

    format(string, sizeof(string),
                                    "Mechanic\t{ffff00}Level: %d\t%s\n\
                                    Drug Smuggler\t{ffff00}Level: %d\t%s\n\
                                    Drug Dealer\t{ffff00}Level: %d\t%s\n\
                                    Arms Dealer\t{ffff00}Level: %d\t%s\n\
                                    Detective\t{ffff00}Level: %d\t%s\n\
                                    Lawyer\t{ffff00}Level: %d\t%s\n\
                                    Forklift\t{ffff00}Level: %d\t%s\n\
                                    Craft\t{ffff00}Level: %d\t%s\n\
                                    Pizza\t{ffff00}Level: %d\t%s\n\
                                    Trucker\t{ffff00}Level: %d\t%s\n",
                                    GetJobLevel(playerid, JOB_MECHANIC)     , strmechanic,
                                    GetJobLevel(playerid, JOB_DRUGSMUGGLER) , strdrugsmuggler,
                                    GetJobLevel(playerid, JOB_DRUGDEALER)   , strdrugdealer,
                                    GetJobLevel(playerid, JOB_ARMSDEALER)   , strarmsdealer,
                                    GetJobLevel(playerid, JOB_DETECTIVE)    , strdetective,
                                    GetJobLevel(playerid, JOB_LAWYER)       , strlawyer,
                                    GetJobLevel(playerid, JOB_FORKLIFT)     , strforklift,
                                    GetJobLevel(playerid, JOB_CRAFTMAN)     , strcraftman,
                                    GetJobLevel(playerid, JOB_PIZZAMAN)     , strpizza,
                                    GetJobLevel(playerid, JOB_TRUCKER)      , strtrucker);
    format(string, sizeof(string),
                                    "%sHooker\t{ffff00}Level: %d\t%s\n\
                                    Fishing\t{ffff00}Level: %d\t%s\n\
                                    Farmer\t{ffff00}Level: %d\t%s\n\
                                    Car Jacker\t{ffff00}Level: %d\t%s\n\
                                    Robbery\t{ffff00}Level: %d\t%s",
                                    string,
                                    GetJobLevel(playerid, JOB_HOOKER)       , strhooker,
                                    GetJobLevel(playerid, JOB_FISHERMAN)    , strfisher,
                                    GetJobLevel(playerid, JOB_FARMER)       , strfarmer,
                                    GetJobLevel(playerid, JOB_CARJACKER)    , strcarjacker,
                                    GetJobLevel(playerid, JOB_ROBBERY)      , strrobbery);
    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST, "My skills", string, "Close", "");
    return 1;
}


GiveJobSkill(playerid, jobid)
{
    new level = GetJobLevel(playerid, jobid);

    switch (jobid)
    {
        case JOB_PIZZAMAN:
        {
            PlayerData[playerid][pPizzaSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET pizzaskill = pizzaskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your PizzaJob skill level is now %i/5. You will earn more money now on delivery.", level + 1);
            }
        }
        case JOB_TRUCKER:
        {
            PlayerData[playerid][pTruckerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET truckerskill = truckerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your trucker skill level is now %i/10. You will deliver more products and earn more money now.", level + 1);
            }
        }
        case JOB_FISHERMAN:
        {
            PlayerData[playerid][pFishingSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET fishingskill = fishingskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your fishing skill level is now %i/5. You will catch bigger fish and your cooldowns are reduced.", level + 1);
            }
        }
        case JOB_ARMSDEALER:
        {
            PlayerData[playerid][pWeaponSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET weaponskill = weaponskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your weapons dealer skill level is now %i/5. You have unlocked more weapons.", level + 1);
            }
        }

        case JOB_MECHANIC:
        {
            PlayerData[playerid][pMechanicSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET mechanicskill = mechanicskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your mechanic skill level is now %i/5.", level + 1);
            }
        }
        case JOB_DRUGDEALER:
        {
            PlayerData[playerid][pDrugDealerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET drugdealerskill = drugdealerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your drug dealer skill level is now %i/5. You will have more drugs now.", level + 1);
            }
        }
        case JOB_DRUGSMUGGLER:
        {
            PlayerData[playerid][pSmugglerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET smugglerskill = smugglerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your smuggler skill level is now %i/5. You will earn more money now.", level + 1);
            }
        }
        case JOB_LAWYER:
        {
            PlayerData[playerid][pLawyerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET lawyerskill = lawyerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your lawyer skill level is now %i/5. Your cooldown times are reduced and you can free people for more time.", level + 1);
            }
        }
        case JOB_DETECTIVE:
        {
            PlayerData[playerid][pDetectiveSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET detectiveskill = detectiveskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your detective skill level is now %i/5. Your cooldown times are now reduced.", level + 1);
            }
        }
        case JOB_FARMER:
        {
            PlayerData[playerid][pFarmerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET farmerskill = farmerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your farmer skill level is now %i/5. Now, you will earn more money.", level + 1);
            }
        }
        case JOB_HOOKER:
        {
            PlayerData[playerid][pHookerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET hookerskill = hookerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your hooker skill level is now %i/5. You have less change to catch STD.", level + 1);
            }
        }
        case JOB_CRAFTMAN:
        {
            PlayerData[playerid][pCraftSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET craftskill = craftskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your craft skill level is now %i/5. Your cooldown times are now reduced.", level + 1);
            }
        }
        case JOB_FORKLIFT:
        {
            PlayerData[playerid][pForkliftSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET forkliftskill = forkliftskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your forklift skill level is now %i/5. You will earn more money and get more materials from factory.", level + 1);
            }
        }
        case JOB_CARJACKER:
        {
            PlayerData[playerid][pCarJackerSkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET carjackerskill = carjackerskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your car jacker skill level is now %i/5. You will earn more money when you drop a car.", level + 1);
            }
        }
        case JOB_ROBBERY:
        {
            PlayerData[playerid][pRobberySkill]++;

            DBQuery("UPDATE "#TABLE_USERS" SET robberyskill = robberyskill + 1 WHERE uid = %i", PlayerData[playerid][pID]);


            if (GetJobLevel(playerid, jobid) != level)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "Your robbery skill level is now %i/5. Now, you will picklock fast.", level + 1);
            }
        }
    }

    if (GetJobLevel(playerid, jobid) != level && GetJobLevel(playerid, jobid) == 5)
    {
        AwardAchievement(playerid, ACH_Experienced);
    }
}

GetJobLevel(playerid, jobid)
{
    new skill;
    switch (jobid)
    {
        case JOB_PIZZAMAN:      { skill = PlayerData[playerid][pPizzaSkill]; }
        case JOB_TRUCKER:       { skill = PlayerData[playerid][pTruckerSkill]; }
        case JOB_FISHERMAN:     { skill = PlayerData[playerid][pFishingSkill]; }
        case JOB_ARMSDEALER:    { skill = PlayerData[playerid][pWeaponSkill]; }
        case JOB_MECHANIC:      { skill = PlayerData[playerid][pMechanicSkill]; }
        //case JOB_MINER:       { skill = PlayerData[playerid][]; }
        //case JOB_TAXIDRIVER:  { skill = PlayerData[playerid][pPizzaSkill]; }
        case JOB_DRUGDEALER:    { skill = PlayerData[playerid][pDrugDealerSkill]; }
        case JOB_DRUGSMUGGLER:  { skill = PlayerData[playerid][pSmugglerSkill]; }
        case JOB_LAWYER:        { skill = PlayerData[playerid][pLawyerSkill]; }
        case JOB_DETECTIVE:     { skill = PlayerData[playerid][pDetectiveSkill]; }
        //case JOB_GARBAGEMAN:  { skill = PlayerData[playerid][]; }
        case JOB_FARMER:        { skill = PlayerData[playerid][pFarmerSkill]; }
        case JOB_HOOKER:        { skill = PlayerData[playerid][pHookerSkill]; }
        case JOB_CRAFTMAN:      { skill = PlayerData[playerid][pCraftSkill]; }
        case JOB_FORKLIFT:      { skill = PlayerData[playerid][pForkliftSkill]; }
        case JOB_CARJACKER:     { skill = PlayerData[playerid][pCarJackerSkill]; }
        case JOB_ROBBERY:       { skill = PlayerData[playerid][pRobberySkill]; }

    }

    if (0 <= skill <= 49)
    {
        return 1;
    }
    else if (50 <= skill <= 99)
    {
        return 2;
    }
    else if (100 <= skill <= 199)
    {
        return 3;
    }
    else if (200 <= skill <= 399)
    {
        return 4;
    }
    else
    {
        if (jobid == JOB_TRUCKER)
        {
            if (400 <= skill <= 449)
            {
                return 6;
            }
            else if (450 <= skill <= 499)
            {
                return 7;
            }
            else if (500 <= skill <= 599)
            {
                return 8;
            }
            else if (600 <= skill <= 799)
            {
                return 9;
            }
            else if (skill >= 799)
            {
                return 10;
            }
        }
        else if (skill >= 399)
        {
            return 5;
        }
    }

    return 1;
}

TryJoinJob(playerid, jobid)
{
    new string[140];
    if (PlayerData[playerid][pJob] != JOB_NONE)
    {
        if (GetMaxPlayerJobs(playerid) >= 2)
        {
            if (PlayerData[playerid][pSecondJob] != JOB_NONE)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You have two jobs already. Please quit one of them before getting another one.");
            }
            if (PlayerData[playerid][pJob] == jobid)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You have this job already.");
            }
            format(string, sizeof(string), "Are you sure to become a {FBBC05}%s{FFFFFF}.", GetJobName(jobid));
            Dialog_Show(playerid, JobJoinConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "You have a job already. Please quit your current job before getting another one.");
        }

        return 1;
    }
    format(string, sizeof(string), "Are you sure to become a {FBBC05}%s{FFFFFF}.", GetJobName(jobid));
    Dialog_Show(playerid, JobJoinConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
    return 1;
}

CMD:asellbiz(playerid, params[])
{
    new businessid;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", businessid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /asellbiz [businessid]");
    }
    if (!(0 <= businessid < MAX_BUSINESSES) || !BusinessInfo[businessid][bExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid business.");
    }

    SetBusinessOwner(businessid, INVALID_PLAYER_ID);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have admin sold business %i.", businessid);
    return 1;
}

CMD:join(playerid, params[])
{
    for (new i = 0; i < sizeof(jobLocations); i ++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
        {
            return TryJoinJob(playerid, jobLocations[i][jobID]);
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any job icon.");
    return 1;
}

CMD:quitjob(playerid, params[])
{
    new slot=1;

    if (PlayerData[playerid][pLevel] >= 25 || PlayerData[playerid][pDonator] >= 2)
    {
        if (sscanf(params, "i", slot))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /quitjob [1/2]");
        }
    }

    QuitJobSlot[playerid] = slot;
    new string[140];

    switch (slot)
    {
        case 2:
        {
            // Second job
            if (PlayerData[playerid][pSecondJob] == JOB_NONE)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have a job in this slot which you can quit.");
            }

            format(string, sizeof(string), "Are you sure to quit the job {FBBC05}%s{FFFFFF}.", GetJobName(PlayerData[playerid][pSecondJob]));
            Dialog_Show(playerid, JobQuitConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");

        }
        default:
        {
            // First job
            if (PlayerData[playerid][pJob] == JOB_NONE)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have a job which you can quit.");
            }

            format(string, sizeof(string), "Are you sure to quit the job {FBBC05}%s{FFFFFF}.", GetJobName(PlayerData[playerid][pJob]));
            Dialog_Show(playerid, JobQuitConfirm, DIALOG_STYLE_MSGBOX, "Job recruiter", string, "Yes", "No");
        }
    }

    return 1;
}


CMD:jobhelp(playerid, params[])
{
    if (PlayerData[playerid][pJob] == JOB_NONE && PlayerData[playerid][pSecondJob] == JOB_NONE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no job and therefore no job commands to view.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "__________________ Job Help __________________");
    SendClientMessage(playerid, COLOR_WHITE, "** JOB HELP ** type a command for more information.");
    if (PlayerData[playerid][pJob] != JOB_NONE)
        SendClientMessage(playerid, COLOR_GREY, GetJobHelp(PlayerData[playerid][pJob]));
    if (PlayerData[playerid][pSecondJob] != JOB_NONE)
        SendClientMessage(playerid, COLOR_GREY, GetJobHelp(PlayerData[playerid][pSecondJob]));
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys)
{
    if (!(newkeys & KEY_NO))
        return 1;

    for (new i = 0; i < sizeof(jobLocations); i ++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]))
        {
            return TryJoinJob(playerid, jobLocations[i][jobID]);
        }
    }
    return 1;
}
