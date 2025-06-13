/// @file      Gym.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-07-08 17:32:34 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum
{
    WORKOUT_NONE,
    WORKOUT_DUMBELLS,
    WORKOUT_TREADMILL
};

static GymWorkout[MAX_PLAYERS];
static GymWeight[MAX_PLAYERS];
static GymReps[MAX_PLAYERS];
static GymSpeedLevel[MAX_PLAYERS];
static GymDistanceRan[MAX_PLAYERS];
static GymWorkoutTime[MAX_PLAYERS];

static GymFitness[MAX_PLAYERS];
static GymMembership[MAX_PLAYERS];

static GymWorkoutTimer[MAX_PLAYERS];
static GymWeightsObj[MAX_PLAYERS][2];

static PlayerText:GymPlayerText[MAX_PLAYERS][5];
static PlayerBar:GymBar[MAX_PLAYERS];


hook OnPlayerInit(playerid)
{
    GymWorkout[playerid] = WORKOUT_NONE;
    GymWeight[playerid] = 0;
    GymReps[playerid] = 0;
    GymSpeedLevel[playerid] = 0;
    GymDistanceRan[playerid] = 0;
    GymWorkoutTime[playerid] = 0;
    GymFitness[playerid] = 0;
    GymMembership[playerid] = 0;

    GymBar[playerid] = CreatePlayerProgressBar(playerid, 556.000000, 130.000000, 57.000000, 4.699999, COLOR_SAMP, 100.0000, 0);

    GymPlayerText[playerid][0] = CreatePlayerTextDraw(playerid, 484.000000, 123.000000, "Power");
    PlayerTextDrawBackgroundColor(playerid, GymPlayerText[playerid][0], 255);
    PlayerTextDrawFont(playerid, GymPlayerText[playerid][0], 2);
    PlayerTextDrawLetterSize(playerid, GymPlayerText[playerid][0], 0.360000, 1.700000);
    PlayerTextDrawColor(playerid, GymPlayerText[playerid][0], -1429936641);
    PlayerTextDrawSetOutline(playerid, GymPlayerText[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, GymPlayerText[playerid][0], 1);

    GymPlayerText[playerid][1] = CreatePlayerTextDraw(playerid, 497.000000, 139.000000, "Reps");
    PlayerTextDrawBackgroundColor(playerid, GymPlayerText[playerid][1], 255);
    PlayerTextDrawFont(playerid, GymPlayerText[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, GymPlayerText[playerid][1], 0.360000, 1.700000);
    PlayerTextDrawColor(playerid, GymPlayerText[playerid][1], -1429936641);
    PlayerTextDrawSetOutline(playerid, GymPlayerText[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, GymPlayerText[playerid][1], 1);

    GymPlayerText[playerid][2] = CreatePlayerTextDraw(playerid, 608.000000, 139.000000, "0");
    PlayerTextDrawAlignment(playerid, GymPlayerText[playerid][2], 3);
    PlayerTextDrawBackgroundColor(playerid, GymPlayerText[playerid][2], 255);
    PlayerTextDrawFont(playerid, GymPlayerText[playerid][2], 2);
    PlayerTextDrawLetterSize(playerid, GymPlayerText[playerid][2], 0.360000, 1.700000);
    PlayerTextDrawColor(playerid, GymPlayerText[playerid][2], -1429936641);
    PlayerTextDrawSetOutline(playerid, GymPlayerText[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, GymPlayerText[playerid][2], 1);

    GymPlayerText[playerid][3] = CreatePlayerTextDraw(playerid, 469.000000, 156.000000, "Distance");
    PlayerTextDrawBackgroundColor(playerid, GymPlayerText[playerid][3], 255);
    PlayerTextDrawFont(playerid, GymPlayerText[playerid][3], 2);
    PlayerTextDrawLetterSize(playerid, GymPlayerText[playerid][3], 0.360000, 1.700000);
    PlayerTextDrawColor(playerid, GymPlayerText[playerid][3], -1429936641);
    PlayerTextDrawSetOutline(playerid, GymPlayerText[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, GymPlayerText[playerid][3], 1);

    GymPlayerText[playerid][4] = CreatePlayerTextDraw(playerid, 608.000000, 156.000000, "0");
    PlayerTextDrawAlignment(playerid, GymPlayerText[playerid][4], 3);
    PlayerTextDrawBackgroundColor(playerid, GymPlayerText[playerid][4], 255);
    PlayerTextDrawFont(playerid, GymPlayerText[playerid][4], 2);
    PlayerTextDrawLetterSize(playerid, GymPlayerText[playerid][4], 0.360000, 1.700000);
    PlayerTextDrawColor(playerid, GymPlayerText[playerid][4], -1429936641);
    PlayerTextDrawSetOutline(playerid, GymPlayerText[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, GymPlayerText[playerid][4], 1);

    return 1;
}


Dialog:Treadmill(playerid, response, listitem, inputtext[])
{
    if ((response) && IsPlayerInRangeOfPoint(playerid, 3.0, 773.5131, -2.1218, 1000.8479))
    {
        GymSpeedLevel[playerid] = listitem + 1;
        GymWorkoutTimer[playerid] = SetTimerEx("DecreasePower", 150, true, "i", playerid);

        ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_geton", 4.1, 0, 0, 0, 1, 0, 1);
        SetTimerEx("BeginWorkout", 2000, false, "ii", playerid, WORKOUT_TREADMILL);
    }
    else
    {
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}

Dialog:LiftWeights(playerid, response, listitem, inputtext[])
{
    if ((response) && IsPlayerInRangeOfPoint(playerid, 3.0, 771.7793, 5.4092, 1000.7802))
    {
        GymWeight[playerid] = (listitem + 2) * 10;
        GymWorkoutTimer[playerid] = SetTimerEx("DecreasePower", 200, true, "i", playerid);

        ApplyAnimation(playerid, "Freeweights", "gym_free_pickup", 4.1, 0, 0, 0, 0, 0, 1);
        SetTimerEx("BeginWorkout", 2500, false, "ii", playerid, WORKOUT_DUMBELLS);
    }
    else
    {
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}

publish BeginWorkout(playerid, type)
{
    PlayerTextDrawSetString(playerid, GymPlayerText[playerid][2], "0");
    PlayerTextDrawSetString(playerid, GymPlayerText[playerid][4], "0");

    switch (type)
    {
        case WORKOUT_DUMBELLS:
        {
            PlayerTextDrawSetString(playerid, GymPlayerText[playerid][1], "Reps");
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][0]);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][1]);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][2]);

            GymWeightsObj[playerid][0] = SetAttachedObject(playerid, 3072, 5, 0.0, 0.0, 0.0);
            GymWeightsObj[playerid][1] = SetAttachedObject(playerid, 3071, 6, 0.0, 0.0, 0.0);

            ShowPlayerProgressBar(playerid, GymBar[playerid]);
            SetPlayerProgressBarValue(playerid, GymBar[playerid], 0.0);
        }
        case WORKOUT_TREADMILL:
        {
            PlayerTextDrawSetString(playerid, GymPlayerText[playerid][1], "Level");
            PlayerTextDrawFormatString(playerid, GymPlayerText[playerid][2], "%i", GymSpeedLevel[playerid]);

            ShowPlayerProgressBar(playerid, GymBar[playerid]);
            SetPlayerProgressBarValue(playerid, GymBar[playerid], 50.0);

            PlayerPlaySound(playerid, 17801, 0.0, 0.0, 0.0);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][0]);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][1]);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][2]);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][3]);
            PlayerTextDrawShow(playerid, GymPlayerText[playerid][4]);
        }
    }
    GymWorkout[playerid] = type;
    GymDistanceRan[playerid] = 0;
    GymReps[playerid] = 0;
    AwardAchievement(playerid, ACH_Fitness);

    return TogglePlayerControllableEx(playerid, 0);
}

publish DecreasePower(playerid)
{
    new
        Float:value = GetPlayerProgressBarValue(playerid, GymBar[playerid]);

    switch (GymWorkout[playerid])
    {
        case WORKOUT_DUMBELLS:
        {
            if (value > 0.0)
            {
                SetPlayerProgressBarValue(playerid, GymBar[playerid], value - 3.0);
            }
        }
        case WORKOUT_TREADMILL:
        {
            if (value > 0.0)
            {
                SetPlayerProgressBarValue(playerid, GymBar[playerid], value - (GymSpeedLevel[playerid] + 8));
            }
            else
            {
                StopWorkout(playerid);
                ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_falloff", 4.1, 0, 0, 0, 0, 0, 1);
            }
        }
    }
}


StopWorkout(playerid)
{
    if (GymWorkout[playerid] != WORKOUT_NONE)
    {
        HidePlayerProgressBar(playerid, GymBar[playerid]);
        PlayerTextDrawHide(playerid, GymPlayerText[playerid][0]);
        PlayerTextDrawHide(playerid, GymPlayerText[playerid][1]);
        PlayerTextDrawHide(playerid, GymPlayerText[playerid][2]);
        PlayerTextDrawHide(playerid, GymPlayerText[playerid][3]);
        PlayerTextDrawHide(playerid, GymPlayerText[playerid][4]);

        SetCameraBehindPlayer(playerid);
        TogglePlayerControllableEx(playerid, 1);

        KillTimer(GymWorkoutTimer[playerid]);

        switch (GymWorkout[playerid])
        {
            case WORKOUT_DUMBELLS:
            {
                GymWeight[playerid] = 0;
                GymReps[playerid] = 0;

                PlayerPlaySound(playerid, 17807, 0.0, 0.0, 0.0);

                RemovePlayerAttachedObject(playerid, GymWeightsObj[playerid][0]);
                RemovePlayerAttachedObject(playerid, GymWeightsObj[playerid][1]);
            }
            case WORKOUT_TREADMILL:
            {
                GymSpeedLevel[playerid] = 0;
                GymDistanceRan[playerid] = 0;

                PlayerPlaySound(playerid, 17808, 0.0, 0.0, 0.0);
            }
        }
        GymWorkout[playerid] = WORKOUT_NONE;
    }
    GymWeight[playerid] = 0;
    GymReps[playerid] = 0;
    GymSpeedLevel[playerid] = 0;
    GymDistanceRan[playerid] = 0;
    GymWorkoutTime[playerid] = 0;
    GymFitness[playerid] = 0;

    return 1;
}
AddFitnessForPlayer(playerid)
{
    if (GymFitness[playerid] < 100)
    {
        GymFitness[playerid]++;
    }
}
WorkoutUpdate(playerid)
{
    if (GymWorkout[playerid] != WORKOUT_NONE)
    {
        new
            Float:value = GetPlayerProgressBarValue(playerid, GymBar[playerid]);

        switch (GymWorkout[playerid])
        {
            case WORKOUT_DUMBELLS:
            {
                switch (GymWeight[playerid])
                {
                    case 20..60:
                    {
                        ApplyAnimation(playerid, "Freeweights", "gym_free_A", 4.1, 0, 0, 0, 0, 0, 1);
                    }
                    case 70..110:
                    {
                        ApplyAnimation(playerid, "Freeweights", "gym_free_B", 4.1, 0, 0, 0, 0, 0, 1);
                    }
                }
                if (value < 90.0)
                {
                    AddPowerToMeter(playerid);
                }
                else
                {
                    GymReps[playerid]++;


                    if (GymFitness[playerid] < 100 && (GymReps[playerid] % ((120 - GymWeight[playerid]) / 5)) == 0)
                    {
                        AddFitnessForPlayer(playerid);
                    }
                    SetPlayerProgressBarValue(playerid, GymBar[playerid], 0.0);
                    PlayerTextDrawFormatString(playerid, GymPlayerText[playerid][2], "%i", GymReps[playerid]);

                    ApplyAnimation(playerid, "Freeweights", "gym_free_down", 4.1, 0, 0, 0, 0, 0, 1);
                    ApplyAnimation(playerid, "Freeweights", "gym_free_down", 4.1, 0, 0, 0, 0, 0, 1);

                    if (GymReps[playerid] == 50 && !GymMembership[playerid])
                    {
                        GymWorkoutTime[playerid] = gettime() + 43200;
                        StopWorkout(playerid);

                        SendInfoMessage(playerid, "You have reached your limit for today!");
                        ApplyAnimation(playerid, "Freeweights", "gym_free_putdown", 4.1, 0, 0, 0, 0, 0, 1);
                    }
                }
            }
            case WORKOUT_TREADMILL:
            {
                GymDistanceRan[playerid] = GymDistanceRan[playerid] + 1;


                SetPlayerProgressBarValue(playerid, GymBar[playerid], value + (GymSpeedLevel[playerid] + 12));
                PlayerTextDrawFormatString(playerid, GymPlayerText[playerid][4], "%i", GymDistanceRan[playerid]);

                if (GymFitness[playerid] < 100 && (GymDistanceRan[playerid] % 100) == 0)
                {
                    AddFitnessForPlayer(playerid);
                }
                if (GymDistanceRan[playerid] == 200 && !GymMembership[playerid])
                {
                    GymWorkoutTime[playerid] = gettime() + 43200;
                    StopWorkout(playerid);

                    SendInfoMessage(playerid, "You have reached your limit for today!");
                    ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_getoff", 4.1, 0, 0, 0, 0, 0, 1);
                }
            }
        }
    }
    return 1;
}

AddPowerToMeter(playerid)
{
    new
        Float:value = GetPlayerProgressBarValue(playerid, GymBar[playerid]);

    switch (GymWeight[playerid])
    {
        case 20: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 22.0);
        case 30: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 20.5);
        case 40: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 19.0);
        case 50: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 18.0);
        case 60: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 16.0);
        case 70: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 14.0);
        case 80: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 12.0);
        case 90: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 10.0);
        case 100: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 8.0);
        case 110: SetPlayerProgressBarValue(playerid, GymBar[playerid], value + 6.0);
    }
}
IsWeightsInUse(playerid)
{
    foreach (new i : Player)
    {
        if (GymWorkout[i] == WORKOUT_DUMBELLS && IsPlayerNearPlayer(i, playerid, 10.0))
        {
            return 1;
        }
    }
    return 0;
}
IsPlayerNearGymEquipment(playerid)
{
    return (IsPlayerInRangeOfPoint(playerid, 2.0, 771.7793, 5.4092, 1000.7802) || IsPlayerInRangeOfPoint(playerid, 2.0, 773.5131, -2.1218, 1000.8479));
}

GymCheck(playerid)
{
    new company = GetInsideBusiness(playerid);

    if (company == -1 || BusinessInfo[company][bType] != BUSINESS_GYM)
    {
        return 0;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 2.0, 771.7793, 5.4092, 1000.7802))
    {
        if (!GymWorkout[playerid])
        {
            if (GymWorkoutTime[playerid] > gettime())
            {
                SendErrorMessage(playerid, "You have reached your limit for the day.");
            }
            else if (IsWeightsInUse(playerid))
            {
                SendErrorMessage(playerid, "The weights are already being used.");
            }
            else if (GymWeight[playerid])
            {
                SendErrorMessage(playerid, "Please wait before using this command.");
            }
            else
            {
                SetPlayerPos(playerid, 771.7793, 5.4092, 1000.7802);
                SetPlayerFacingAngle(playerid, 270.0000);

                SetPlayerCameraPos(playerid, 775.425048, 5.364191, 1001.295227);
                SetPlayerCameraLookAt(playerid, 772.279235, 5.403525, 1000.780212);

                Dialog_Show(playerid, LiftWeights, DIALOG_STYLE_LIST, "{FFFFFF}Select weight", "20 lbs\n30 lbs\n40 lbs\n50 lbs\n60 lbs\n70 lbs\n80 lbs\n90 lbs\n100 lbs\n110 lbs", "Begin", "Cancel");
            }
        }
        else
        {
            StopWorkout(playerid);
            ApplyAnimation(playerid, "Freeweights", "gym_free_putdown", 4.1, 0, 0, 0, 0, 0, 1);
        }
        return 1;
    }
    else if (IsPlayerInRangeOfPoint(playerid, 2.0, 773.5131, -2.1218, 1000.8479))
    {
        if (!GymWorkout[playerid])
        {
            if (GymWorkoutTime[playerid] > gettime())
            {
                SendErrorMessage(playerid, "You have reached your limit for the day.");
            }
            else if (IsTreadmillInUse(playerid))
            {
                SendErrorMessage(playerid, "The treadmill is already being used.");
            }
            else if (GymSpeedLevel[playerid])
            {
                SendErrorMessage(playerid, "Please wait before using this command.");
            }
            else
            {
                SetPlayerPos(playerid, 773.4777, -1.3239, 1000.7260);
                SetPlayerFacingAngle(playerid, 180.0000);

                SetPlayerCameraPos(playerid, 774.571166, -6.172124, 1001.582763);
                SetPlayerCameraLookAt(playerid, 773.482116, -3.338384, 1000.847900);

                Dialog_Show(playerid, Treadmill, DIALOG_STYLE_LIST, "{FFFFFF}Select level", "Level 1 (slowest)\nLevel 2\nLevel 3\nLevel 4\nLevel 5\nLevel 6\nLevel 7\nLevel 8\nLevel 9\nLevel 10 (fastest)", "Begin", "Cancel");
            }
        }
        else
        {
            StopWorkout(playerid);
            ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_getoff", 4.1, 0, 0, 0, 0, 0, 1);
        }
        return 1;
    }
    return 0;
}

IsTreadmillInUse(playerid)
{
    foreach (new i : Player)
    {
        if (GymWorkout[i] == WORKOUT_TREADMILL && IsPlayerNearPlayer(i, playerid, 10.0))
        {
            return 1;
        }
    }
    return 0;
}

hook OnPlayerHeartBeat(playerid)
{
    if (GymWorkout[playerid] != WORKOUT_NONE)
    {
        new index = GetPlayerAnimationIndex(playerid);

        switch (GymWorkout[playerid])
        {
            case WORKOUT_DUMBELLS:
            {
                if (index < 570 || index > 577)
                {
                    ApplyAnimation(playerid, "Freeweights", "gym_free_loop", 4.1, 1, 0, 0, 0, 0, 1);
                }
            }
            case WORKOUT_TREADMILL:
            {
                if (index < 662 || index > 665)
                {
                    switch (GymSpeedLevel[playerid])
                    {
                        case 1..3:
                        {
                            ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_walk", 4.1, 1, 0, 0, 0, 0, 1);
                        }
                        case 4..6:
                        {
                            ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_jog", 4.1, 1, 0, 0, 0, 0, 1);
                        }
                        case 7..10:
                        {
                            ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_sprint", 4.1, 1, 0, 0, 0, 0, 1);
                        }
                    }
                }
            }
        }
    }
    return 1;
}
