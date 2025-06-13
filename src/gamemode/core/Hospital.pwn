/// @file      Hospital.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

//TODO: move hospital player data here (add Player state to manage injured, hospitalized, ...)

static HospitalTime[MAX_PLAYERS];
static HospitalType[MAX_PLAYERS];

static const Float:SpawnBolnica[ 3 ][ 3 ] = {
    { -2272.7239, 98.7313, -4.6833 },
    { -2272.9255, 101.8626, -4.6833 },
    { -2272.8877, 105.0981, -4.6833 }
};

stock GetPlayerHospital(playerid)
{
    return HospitalType[playerid];
}

hook OnPlayerInit(playerid)
{
    HospitalTime[playerid] = 0;
}

hook OnPlayerReset(playerid)
{
    if (PlayerData[playerid][pHospital])
    {
        GameTextForPlayer(playerid, " ", 100, 3);

        PlayerData[playerid][pHospital] = 0;
        HospitalTime[playerid] = 0;
    }
}

SetPlayerInHospital(playerid, time = 15, type = -1)
{
    HospitalType[playerid] = (type == -1) ? (random(2) + 1) : (type);
    HospitalTime[playerid] = time;
    PlayerData[playerid][pHospital] = 1;

    TogglePlayerControllableEx(playerid, 0);
    GameTextForPlayer(playerid, "~w~Recovering...", 1500, 3);
    new rand = random( sizeof( SpawnBolnica ) );
    SetPlayerVirtualWorld(playerid, 75);
    SetPlayerPos( playerid, SpawnBolnica[ rand ][ 0 ], SpawnBolnica[ rand ][ 1 ], SpawnBolnica[ rand ][ 2 ] );
    SetPlayerFacingAngle( playerid, 90.000 );
    ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.1, 1, 0, 0, 0, 0);
    //ApplyAnimation( playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0 );
    SetPlayerCameraPos(playerid, -2280.1226, 105.9459, -3.6012);
    SetPlayerCameraLookAt(playerid, -2279.2388, 105.4819, -3.9212);
}

GetHospitalName(type)
{
    new hospital[32];
    switch (type)
    {
        case HOSPITAL_ALLSAINTS:  strcat(hospital, "All Saints General");
        case HOSPITAL_COUNTY:     strcat(hospital, "County General");
        case HOSPITAL_FMDHQ:      strcat(hospital, "FMD HQ");
        case HOSPITAL_VIPLOUNGE:  strcat(hospital, "VIP Lounge");
        case HOSPITAL_SAN_FIERRO: strcat(hospital, "Saint Fierro");
        default:                  strcat(hospital, "None");
    }
    return hospital;
}

CMD:forcehospital(playerid, params[])
{
    return callcmd::heject(playerid, params);
}

CMD:heject(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /heject [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pHospital])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not in hospital.");
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s ejected %s from the hospital.", GetRPName(playerid), GetRPName(targetid));

    HospitalTime[targetid] = 1;
    SendClientMessage(targetid, COLOR_YELLOW, "You have been ejected from hospital by an admin!");
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (PlayerData[playerid][pHospital] && HospitalTime[playerid])
    {
        HospitalTime[playerid]--;

        if (HospitalTime[playerid] == 0)
        {
            if (PlayerData[playerid][pInsurance] > 0)
            {
                AwardAchievement(playerid, ACH_Obamacare);
            }

            SetFreezePos(playerid, -2297.6084,111.1512,-5.3336);//hospitalspawn
            SetPlayerFacingAngle(playerid, 89.7591);
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, GetPlayerHospital(playerid));
            SetCameraBehindPlayer(playerid);
            ClearAnimations(playerid, 1);
            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);

            if (!(GetPlayerFaction(playerid) == FACTION_POLICE || GetPlayerFaction(playerid) == FACTION_MEDIC))
            {
                GivePlayerCash(playerid, -500);
                GameTextForPlayer(playerid, "~w~Discharged~n~~r~-$500", 5000, 1);
            }

            SetPlayerDrunkLevel(playerid, 0);

            if (PlayerData[playerid][pDelivered])
            {
                if (GetPlayerFaction(playerid) == FACTION_POLICE || GetPlayerFaction(playerid) == FACTION_MEDIC)
                    SendClientMessage(playerid, COLOR_DOCTOR, "You have not been billed for your stay. You also keep all of your weapons!");
                else
                    SendClientMessage(playerid, COLOR_DOCTOR, "You have been billed $500 for your stay. You also keep all of your weapons!");

                PlayerData[playerid][pDelivered] = 0;
            }
            else
            {
                if (GetPlayerFaction(playerid) == FACTION_POLICE || GetPlayerFaction(playerid) == FACTION_MEDIC)
                    SendClientMessage(playerid, COLOR_DOCTOR, "You have not been billed for your stay. Your weapons have been confiscated by staff.");
                else
                    SendClientMessage(playerid, COLOR_DOCTOR, "You have been billed $500 for your stay. Your weapons have been confiscated by staff.");

                SendClientMessage(playerid, COLOR_LIGHTRED, "(( You have lost 30 minutes of your memory. ))");
                ClearAnimations(playerid, 1);
                ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);

            }
            new hospital[32];
            hospital = GetHospitalName(GetPlayerHospital(playerid));
            if (GetWantedLevel(playerid) > 0)
            {
                foreach(new x : Player)
                {
                    if (IsLawEnforcement(x))
                    {
                        SendClientMessageEx(x, COLOR_YELLOW, "LSFMD: Wanted suspect %s[%i] was last spotted at the %s hospital!", GetRPName(playerid), playerid, hospital);
                    }
                }
            }
            SetPlayerHealth(playerid, PlayerData[playerid][pSpawnHealth]);
            SetScriptArmour(playerid, PlayerData[playerid][pSpawnArmor]);
            ClearAnimations(playerid, 1);
            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);

            PlayerData[playerid][pHospital] = 0;
            HospitalTime[playerid] = 0;
        }
        else
        {
            GameTextForPlayer(playerid, "~w~Recovering...", 1500, 3);
            //SetPlayerDrunkLevel(playerid, 50000);
        }
    }

}

CMD:buyinsurance(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2323.3250,110.9966,-5.3942))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any of the hospitals.");
    }
    if (PlayerData[playerid][pCash] < 2000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford insurance.");
    }

    switch (GetPlayerVirtualWorld(playerid))
    {
        case HOSPITAL_COUNTY:
        {
            if (PlayerData[playerid][pInsurance] == HOSPITAL_COUNTY)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You are already insured at this hospital.");
            }

            GivePlayerCash(playerid, -2000);
            GameTextForPlayer(playerid, "~r~-$2000", 5000, 1);
            SendClientMessage(playerid, COLOR_AQUA, "You paid $2000 for insurance at {FF8282}County General{33CCFF}. You will now spawn here after death.");

            DBQuery("UPDATE "#TABLE_USERS" SET insurance = %i WHERE uid = %i", HOSPITAL_COUNTY, PlayerData[playerid][pID]);


            PlayerData[playerid][pInsurance] = HOSPITAL_COUNTY;
        }
        case HOSPITAL_ALLSAINTS:
        {
            if (PlayerData[playerid][pInsurance] == HOSPITAL_ALLSAINTS)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You are already insured at this hospital.");
            }

            GivePlayerCash(playerid, -2000);
            GameTextForPlayer(playerid, "~r~-$2000", 5000, 1);
            SendClientMessage(playerid, COLOR_AQUA, "You paid $2000 for insurance at {FF8282}All Saints Hospital{33CCFF}. You will now spawn here after death.");

            DBQuery("UPDATE "#TABLE_USERS" SET insurance = %i WHERE uid = %i", HOSPITAL_ALLSAINTS, PlayerData[playerid][pID]);


            PlayerData[playerid][pInsurance] = HOSPITAL_ALLSAINTS;
        }
        case HOSPITAL_SAN_FIERRO:
        {
            if (PlayerData[playerid][pInsurance] == HOSPITAL_SAN_FIERRO)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You are already insured at this hospital.");
            }

            GivePlayerCash(playerid, -4000);
            GameTextForPlayer(playerid, "~r~-$4000", 5000, 1);
            SendClientMessage(playerid, COLOR_AQUA, "You paid $4000 for insurance at {FF8282}San Fierro Medic Center{33CCFF}. You will now spawn here after death.");

            DBQuery("UPDATE "#TABLE_USERS" SET insurance = %i WHERE uid = %i", HOSPITAL_SAN_FIERRO, PlayerData[playerid][pID]);


            PlayerData[playerid][pInsurance] = HOSPITAL_SAN_FIERRO;
        }
    }

    return 1;
}

CMD:takecall(playerid, params[])
{
    new targetid, Float:x, Float:y, Float:z;

    if (!PlayerHasJob(playerid, JOB_MECHANIC) && !PlayerHasJob(playerid, JOB_TAXIDRIVER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command unless you're a Mechanic or Taxi Driver.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /takecall [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    if (PlayerHasJob(playerid, JOB_MECHANIC) && PlayerData[targetid][pMechanicCall] > 0)
    {
        if (GetPlayerInterior(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is currently unreachable.");
        }

        PlayerData[targetid][pMechanicCall] = 0;

        GetPlayerPos(targetid, x, y, z);
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 5.0);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's mechanic call. Their location was marked on your map.", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s has accepted your mechanic call. Please wait patiently until they arrive.", GetRPName(playerid));
    }
    else if (PlayerHasJob(playerid, JOB_TAXIDRIVER) && PlayerData[targetid][pTaxiCall] > 0)
    {
        if (GetPlayerInterior(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player is currently unreachable.");
        }

        PlayerData[targetid][pTaxiCall] = 0;

        GetPlayerPos(targetid, x, y, z);
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 5.0);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's taxi call. Their location was marked on your map.", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s has accepted your taxi call. Please wait patiently until they arrive.", GetRPName(playerid));
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "That player has no calls which can be taken.");
    }

    return 1;
}

CMD:listcallers(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____ Emergency Calls _____");

    foreach(new i : Player)
    {
        if ((PlayerData[i][pEmergencyCall] > 0) && ((PlayerData[i][pEmergencyType] == FACTION_MEDIC && GetPlayerFaction(playerid) == FACTION_MEDIC) || (PlayerData[i][pEmergencyType] == FACTION_POLICE && IsLawEnforcement(playerid))))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* %s[%i] - Expiry: %i seconds - Emergency: %s", GetRPName(i), i, PlayerData[i][pEmergencyCall], PlayerData[i][pEmergency]);
        }
    }

    return 1;
}

CMD:trackcall(playerid, params[])
{
    new targetid, Float:x, Float:y, Float:z;

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /trackcall [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pEmergencyCall])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "That player hasn't called %d recently or their call expired.", PhoneNumber_Emergency);
    }
    if (!GetPlayerPosEx(targetid, x, y, z))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is currently unreachable.");
    }

    //PlayerData[targetid][pEmergencyCall] = 0;

    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 5.0);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's emergency call. Their location was marked on your map.", GetRPName(targetid));

    if (PlayerData[targetid][pEmergencyCall] == FACTION_MEDIC)
    {
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s has accepted your emergency call. Please wait patiently until they arrive.", GetRPName(playerid));
    }

    return 1;
}

CMD:kill(playerid,params[])
{
    if (!IsPlayerConnected(playerid)         || PlayerData[playerid][pInjured] > 0 ||
        PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed]  > 0 ||
        IsDueling(playerid)                  || IsHunted(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    SetPlayerHealth(playerid, 0.0);
    new string[256];
    format(string, sizeof(string),"** %s breaks his back doing the limbo and dies.",GetRPName(playerid));
    return SendProximityFadeMessage(playerid, 20.0, string, 0xA187E3ff, 0xA187E3ff, 0xA187E3ff, 0xA187E3ff, 0xA187E3ff);
}
