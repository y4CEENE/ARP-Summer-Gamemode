/// @file      KartRace.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

#define EVENT_TOKEN_KART_RACE 0x4628ABC

static cNbKartRaceLaps = 1;
static Float:cKartOrigin[Point4D] = { 1550.7883, 17.4276, 24.1364 };
static cSpawnPos[][Point4D] = {
    { 1564.0096, 17.0714, 23.4963, 190.0000 },
    { 1561.8234, 16.5486, 23.4963, 190.0000 },
    { 1559.8829, 15.9347, 23.4963, 189.9975 },
    { 1557.9028, 15.3099, 23.4963, 189.9975 },
    { 1555.6203, 14.5345, 23.4963, 189.9975 },
    { 1564.2979, 19.8998, 23.4477, 192.3600 },
    { 1562.3704, 19.3897, 23.4478, 192.7268 },
    { 1560.6278, 19.0925, 23.4476, 195.8536 },
    { 1558.5475, 18.3385, 23.4480, 192.6586 },
    { 1556.8177, 18.3449, 23.4465, 193.2574 },
    { 1554.8568, 17.8215, 23.4380, 193.6009 },
    { 1553.8881, 21.1286, 23.4269, 193.5916 },
    { 1555.5220, 21.0739, 23.4345, 190.0444 },
    { 1556.8367, 22.0668, 23.4380, 188.4365 },
    { 1558.2001, 23.5059, 23.4429, 190.4256 },
    { 1559.6775, 24.1726, 23.4476, 184.8009 },
    { 1561.3840, 24.0859, 23.4478, 187.2630 },
    { 1562.7532, 25.0298, 23.4478, 180.4760 },
    { 1562.5829, 27.7668, 23.4478, 191.7696 },
    { 1560.8351, 26.3097, 23.4477, 199.6867 },
    { 1558.8903, 26.1727, 23.4481, 192.8379 },
    { 1557.2906, 27.3436, 23.4350, 198.5173 },
    { 1557.4248, 27.2700, 23.4438, 202.0928 },
    { 1555.8507, 25.5446, 23.4348, 187.7344 },
    { 1553.8242, 25.1185, 23.4291, 188.0691 },
    { 1551.3418, 24.6591, 23.4239, 195.6346 },
    { 1550.6317, 27.2813, 23.4237, 194.9919 },
    { 1552.1284, 28.1989, 23.4274, 192.2468 },
    { 1554.1768, 28.7966, 23.4343, 192.7393 },
    { 1555.8494, 28.9580, 23.4385, 188.9234 },
    { 1557.7314, 29.7238, 23.4478, 194.9809 },
    { 1559.2167, 30.2656, 23.4477, 195.7509 },
    { 1561.0835, 30.4947, 23.4479, 203.4948 },
    { 1563.6442, 31.1704, 23.4479, 175.8033 }
};
static cKartCP[][Point4D] = {
    { 1561.1425,   -0.6959, 22.2056 },
    { 1560.0236,  -63.4405, 20.2049 },
    { 1541.8403, -161.8614, 15.2990 },
    { 1448.9148, -211.3230,  8.8160 },
    { 1367.7023, -211.0382,  6.6549 },
    { 1302.9319, -181.8514, 23.0594 },
    { 1261.6588, -151.0969, 37.4276 },
    { 1219.6796, -106.5497, 39.0666 },
    { 1164.2017,  -70.1262, 29.1771 },
    { 1067.8438,  -63.6197, 20.4266 },
    {  968.9000,  -86.8389, 19.0257 },
    {  889.7670,  -88.6949, 23.1655 },
    {  829.8240, -106.7988, 24.3264 },
    {  771.7855, -137.4116, 20.1231 },
    {  722.7872, -174.7025, 20.1587 },
    {  649.4225, -196.4490, 10.9428 },
    {  586.3651, -200.5624, 12.3490 },
    {  529.7865, -209.4404, 15.3095 },
    {  486.7947, -250.3996, 10.1345 },
    {  435.4356, -297.3609,  5.9730 },
    {  379.3389, -319.6147, 12.8056 },
    {  314.3939, -365.6910,  8.8709 }
};

static enum eKartStatus
{
    KS_Waiting,
    KS_Starting,
    KS_Active
};
static enum eKartRace
{
    eKartStatus:KR_Status, // 0 = Waiting for more players | 1 = Starting | 2 = Active/In Progress
    KR_Count,    // Racer Count
    KR_Starting, // Countdown for race to start
    KR_Left,     // Time KR_Left till race ends
    KR_Place     // Used to determine KR_Place within race.
};
static sKartRace[eKartRace];
static Text3D:sKartJoinText;
static sKartCooldown[MAX_PLAYERS];
static sPlayerKartCar[MAX_PLAYERS];
static sPlayerCheckpoint[MAX_PLAYERS];
static sPlayerLap[MAX_PLAYERS];

static sMinimumPlayers = 3;


hook OnGameModeInit()
{
    sKartJoinText = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/kart {FFFF00}to join in!", COLOR_GREY,
        cKartOrigin[P4_PosX], cKartOrigin[P4_PosY], cKartOrigin[P4_PosZ], 15.0);
}

hook OnPlayerInit(playerid)
{
    sPlayerLap[playerid] = 0;
    sKartCooldown[playerid] = 0;
    sPlayerKartCar[playerid] = 0;
    sPlayerCheckpoint[playerid] = 0;
}

stock UpdateKartLabel()
{
    new string[256];
    if (sKartRace[KR_Status] == KS_Active)
    {
        format(string, sizeof(string), "{FFFF00}Race in progress!\nRacers: {FF0000}%d\nTime KR_Left: %d seconds",
               sKartRace[KR_Count], sKartRace[KR_Left]-gettime());
    }
    else
    {
        format(string, sizeof(string), "{FFFF00}Type {FF0000}/kart {FFFF00}to join in!\nRacers: {FF0000}%d",
               sKartRace[KR_Count]);
    }
    UpdateDynamic3DTextLabelText(sKartJoinText, COLOR_GREY, string);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (sPlayerKartCar[playerid])
    {
        if (newstate == PLAYER_STATE_ONFOOT)
        {
            LeaveKart(playerid);
            SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
        }
    }
    return 1;
}

LeaveKart(playerid)
{
    if (sPlayerKartCar[playerid])
    {
        CancelActiveCheckpoint(playerid);
        DestroyVehicle(sPlayerKartCar[playerid]);
        sPlayerKartCar[playerid] = 0;
        sPlayerCheckpoint[playerid] = 0;
        sPlayerLap[playerid] = 0;
        if (sKartRace[KR_Count] > 0)
        {
            sKartRace[KR_Count]--;
        }
        DeletePVar(playerid, "EventToken");
        SetPlayerToSpawn(playerid);
        UpdateKartLabel();
        SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (sPlayerKartCar[playerid] && sKartRace[KR_Count] > 0)
    {
        sKartRace[KR_Count]--;
    }
}

CMD:kartplayers(playerid, params[])
{
    RCHECK(IsAdmin(playerid, ADMIN_LVL_3), "You are not authorized!");
    new count;
    if (sscanf(params, "d", count) || count < 1)
    {
        return SendClientMessage(playerid, -1, "USAGE: /kartplayers [minimum_players]");
    }
    sMinimumPlayers = count;
    SendClientMessageEx(playerid, -1, "Kart Count set to: %d", sMinimumPlayers);
    return 1;
}

CMD:kart(playerid, params[])
{
    if (sPlayerKartCar[playerid])
    {
        return LeaveKart(playerid);
    }

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, cKartOrigin[P4_PosX], cKartOrigin[P4_PosY], cKartOrigin[P4_PosZ]))
    {
        if (!PlayerHasActiveCheckpoint(playerid))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, cKartOrigin[P4_PosX], cKartOrigin[P4_PosY], cKartOrigin[P4_PosZ], 5.0);
        }
        return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the Kart entrance!");
    }
    RCHECK(!IsPlayerInEvent(playerid), "You cannot do that for the moment.");
    RCHECK(sKartRace[KR_Status] != KS_Active, "The race has already started");
    RCHECK(sKartRace[KR_Count] < sizeof(cSpawnPos), "The race is full, try again next time!");

    if (gettime() < sKartCooldown[playerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Please wait %d seconds before joining another race!", sKartCooldown[playerid] - gettime());
    }

    SavePlayerVariables(playerid);
    SetPVarInt(playerid, "EventToken", EVENT_TOKEN_KART_RACE);

    sPlayerKartCar[playerid] = CreateVehicle(571, cSpawnPos[sKartRace[KR_Count]][P4_PosX],
        cSpawnPos[sKartRace[KR_Count]][P4_PosY], cSpawnPos[sKartRace[KR_Count]][P4_PosZ],
        cSpawnPos[sKartRace[KR_Count]][P4_Angle], random(10), random(10), 15);

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(sPlayerKartCar[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(sPlayerKartCar[playerid], VEHICLE_PARAMS_ON, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
    //LinkVehicleToInterior(sPlayerKartCar[playerid], 7); //TODO: use Interior?
    SetVehicleVirtualWorld(sPlayerKartCar[playerid], 7);


    SetPlayerSkin(playerid, 22);
    SetPlayerVirtualWorld(playerid, 7);
    //SetPlayerInterior(playerid, 7); //TODO: use Interior?
    PutPlayerInVehicle(playerid, sPlayerKartCar[playerid], 0);
    TogglePlayerControllable(playerid, 0);

    sKartRace[KR_Count]++;
    UpdateKartLabel();
    SendClientMessage(playerid, 0xFFFFFFFF, "Type /kart again to leave the race");
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (sPlayerKartCar[playerid])
    {
        if (sKartRace[KR_Status] == KS_Waiting)
        {
            GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Waiting for more racers..", 1100, 3);
        }
        else if (sKartRace[KR_Status] == KS_Starting)
        {
            new string[64];
            format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Race Starting in %d seconds", sKartRace[KR_Starting]);
            if (sKartRace[KR_Starting] <= 3)
            {
                PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
            }
            GameTextForPlayer(playerid, string, 1100, 3);
        }
        else if (sKartRace[KR_Status] == KS_Active)
        {
            new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(sPlayerKartCar[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
            if (engine != VEHICLE_PARAMS_ON)
            {
                SetVehicleParamsEx(sPlayerKartCar[playerid], VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
            }
        }
    }
}

hook OnServerHeartBeat(timestamp)
{
    if (sKartRace[KR_Status] == KS_Starting)
    {
        if (--sKartRace[KR_Starting] <= 0)
        {
            sKartRace[KR_Status] = KS_Active;
            sKartRace[KR_Left] = gettime() + 240;

            foreach (new playerid : Player)
            {
                if (sPlayerKartCar[playerid])
                {
                    new engine, lights, alarm, doors, bonnet, boot, objective;
                    GetVehicleParamsEx(sPlayerKartCar[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
                    SetVehicleParamsEx(sPlayerKartCar[playerid], VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);

                    sPlayerCheckpoint[playerid] = 0;
                    SetActiveCheckpoint(playerid, CHECKPOINT_KARTRACE, cKartCP[0][P4_PosX], cKartCP[0][P4_PosY], cKartCP[0][P4_PosZ], 5.0);

                    TogglePlayerControllable(playerid, 1);
                    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
                    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~GO!", 2000, 3);
                }
            }
        }
        return 1;
    }
    else if (sKartRace[KR_Status] == KS_Active)
    {
        if (sKartRace[KR_Left] - gettime() <= 0 || sKartRace[KR_Count] == 0)
        {
            foreach (new playerid : Player)
            {
                if (sPlayerKartCar[playerid])
                {
                    LeaveKart(playerid);
                }
            }
            sKartRace[KR_Status]   = KS_Waiting;
            sKartRace[KR_Count]    = 0;
            sKartRace[KR_Starting] = 0;
            sKartRace[KR_Left]     = 0;
            sKartRace[KR_Place]    = 0;
            UpdateKartLabel();
        }
        else
        {
            UpdateKartLabel();
        }
    }
    if (sKartRace[KR_Count] >= sMinimumPlayers && sKartRace[KR_Status] == KS_Waiting)
    {
        sKartRace[KR_Status] = KS_Starting;
        sKartRace[KR_Starting] = 15;
        return 1;
    }
    if (sKartRace[KR_Count] < 1 && sKartRace[KR_Status] == KS_Starting)
    {
        sKartRace[KR_Status] = KS_Waiting;
        return 1;
    }
    return 1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_KARTRACE)
        return 1;

    if (sPlayerKartCar[playerid])
    {
        new cp = sPlayerCheckpoint[playerid], string[128];
        if (!IsPlayerInRangeOfPoint(playerid, 10.0, cKartCP[cp][P4_PosX], cKartCP[cp][P4_PosY], cKartCP[cp][P4_PosZ]))
        {
            return 1;
        }
        else if (cp == (sizeof(cKartCP) - 1))
        {
            SetActiveCheckpoint(playerid, CHECKPOINT_KARTRACE, cKartCP[0][P4_PosX], cKartCP[0][P4_PosY], cKartCP[0][P4_PosZ], 5.0);
            sPlayerCheckpoint[playerid] = 0;
            sPlayerLap[playerid]++;

            if (sPlayerLap[playerid] == cNbKartRaceLaps - 1)
            {
                GameTextForPlayer(playerid, "~r~Final Lap!", 1100, 3);
            }
            else if (sPlayerLap[playerid] == cNbKartRaceLaps)
            {
                sKartRace[KR_Place]++;
                if (sKartRace[KR_Place] > 3)
                {
                    SendClientMessageEx(playerid, -1, "You came in %dth place, better luck next time!", sKartRace[KR_Place]);
                }
                if (sKartRace[KR_Place] < 4)
                {
                    foreach (new targetid : Player)
                    {
                        if (sPlayerKartCar[targetid] || IsPlayerInRangeOfPoint(targetid, 15.0, cKartOrigin[P4_PosX], cKartOrigin[P4_PosY], cKartOrigin[P4_PosZ]))
                        {
                            format(string, sizeof(string), "** [KARTRACE] %s has come in", GetPlayerNameEx(playerid), sKartRace[KR_Place]);
                            if (sKartRace[KR_Place] == 1) strcat(string, " 1st place!");
                            if (sKartRace[KR_Place] == 2) strcat(string, " 2nd place!");
                            if (sKartRace[KR_Place] == 3) strcat(string, " 3rd place!");
                            SendClientMessageEx(targetid, -1, string);
                        }
                    }
                }
                sKartCooldown[playerid] = gettime() + 60;
                LeaveKart(playerid);
            }
        }
        else
        {
            cp++;
            sPlayerCheckpoint[playerid] = cp;
            PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
            SetActiveCheckpoint(playerid, CHECKPOINT_KARTRACE, cKartCP[cp][P4_PosX], cKartCP[cp][P4_PosY], cKartCP[cp][P4_PosZ], 5.0);
        }
    }
    return 1;
}
