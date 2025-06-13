/// @file      BreakIn.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-02-16 11:23:11 +0100
/// @copyright Copyright (c) 2023

#include <YSI\y_hooks>

static Text3D:LockText[MAX_PLAYERS];
static Float:LockHealth[MAX_PLAYERS];
static LockBreak[MAX_PLAYERS];
static LockTimer[MAX_PLAYERS];
static LockAnimation[MAX_PLAYERS];

hook OnPlayerReset(playerid)
{
    CancelBreakIn(playerid);
}

stock IsVehicleBeingPicked(vehicleid)
{
    foreach(new i : Player)
    {
        if (LockBreak[i] == vehicleid)
        {
            return 1;
        }
    }
    return 0;
}

publish DestroyLockText(playerid)
{
    if (IsValidDynamic3DTextLabel(LockText[playerid]))
    {
        DestroyDynamic3DTextLabel(LockText[playerid]);
        LockText[playerid] = Text3D:INVALID_3DTEXT_ID;
    }
}

stock CancelBreakIn(playerid)
{
    if (LockBreak[playerid] != INVALID_VEHICLE_ID)
    {
        new
            damage[4];

        SetVehicleParams(LockBreak[playerid], VEHICLE_ALARM, false);
        GetVehicleDamageStatus(LockBreak[playerid], damage[0], damage[1], damage[2], damage[3]);
        UpdateVehicleDamageStatus(LockBreak[playerid], damage[0], 0, damage[2], damage[3]);

        DestroyDynamic3DTextLabel(LockText[playerid]);
        KillTimer(LockTimer[playerid]);

        LockText[playerid] = Text3D:INVALID_3DTEXT_ID;
        LockBreak[playerid] = INVALID_VEHICLE_ID;
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (LockBreak[playerid] != INVALID_VEHICLE_ID)
    {
        CancelBreakIn(playerid);
    }
}

hook OnPlayerInit(playerid)
{
    LockText[playerid] = Text3D:INVALID_3DTEXT_ID;
    LockBreak[playerid] = INVALID_VEHICLE_ID;
    LockAnimation[playerid] = 0;
    LockTimer[playerid] = 0;
}

hook OnPlayerUpdate(playerid)
{
    if (PlayerData[playerid][pKicked])
        return 0;

    if (!PlayerData[playerid][pLogged])
        return 1;

    new index = GetPlayerAnimationIndex(playerid);
    if (LockAnimation[playerid] == index)
        return 1;

    LockAnimation[playerid] = index;

    if (LockBreak[playerid] == INVALID_VEHICLE_ID)
        return 1;

    new vehicleid = LockBreak[playerid];

    if (!IsValidVehicle(vehicleid) || VehicleInfo[vehicleid][vOwnerID] == 0)
    {
        CancelBreakIn(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as it despawned.");
    }

    if (GetNearbyVehicle(playerid) != vehicleid)
    {
        CancelBreakIn(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as you left its location.");
    }

    if (VehicleInfo[vehicleid][vLocked] == 0)
    {
        CancelBreakIn(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as it was unlocked.");
    }

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        CancelBreakIn(playerid);
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer breaking into this vehicle as you aren't onfoot.");
    }

    switch (index)
    {
        case 17..19, 1545..1547, 312..314, 1136..1138, 472..474, 482..484, 494..496, 504..505, 1165:
        {
            if (!IsValidVehicle(vehicleid))
            {
                return 1;
            }
            if (!IsPlayerAtVehicleDoor(playerid, vehicleid, VehicleDoorType_Driver) &&
                !IsPlayerAtVehicleDoor(playerid, vehicleid, VehicleDoorType_Passenger))
            {
                return 1;
            }

            new damage[4];
            GetVehicleDamageStatus(vehicleid, damage[0], damage[1], damage[2], damage[3]);

            if (2 <= GetPlayerWeapon(playerid) <= 9)
                LockHealth[playerid] -= 20.0;
            else
                LockHealth[playerid] -= 10.0;

            if (LockHealth[playerid] <= 0)
            {
                VehicleInfo[vehicleid][vLocked] = 0;

                SetVehicleParams(vehicleid, VEHICLE_DOORS, false);
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

                GameTextForPlayer(playerid, "~g~Vehicle unlocked!", 3000, 6);
                ShowActionBubble(playerid, "* %s successfully kicked down the door of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));

                CancelBreakIn(playerid);
                UpdateVehicleDamageStatus(vehicleid, damage[0], 262144, damage[2], damage[3]);
            }
            else
            {
                new Float:x, Float:y, Float:z;
                new garageid = GetVehicleGarage(vehicleid);

                if (!IsVehicleParamOn(vehicleid, VEHICLE_ALARM))
                {
                    if (VehicleInfo[vehicleid][vAlarm] > 0)
                    {
                        foreach(new i : Player)
                        {
                            if (IsVehicleOwner(i, vehicleid))
                            {
                                SendClientMessageEx(i, COLOR_YELLOW, "* SMS from OnStar: The alarm was activated on your %s located in %s, Ph: 999 *", GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
                            }

                            if (GetPlayerFaction(i) == FACTION_POLICE)
                            {
                                if (VehicleInfo[vehicleid][vAlarm] == 2)
                                {
                                    SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: The alarm was activated on %s's %s in %s. *", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
                                }
                                else if (VehicleInfo[vehicleid][vAlarm] == 3)
                                {
                                    if (!PlayerHasActiveCheckpoint(playerid))
                                    {
                                        if (garageid >= 0)
                                        {
                                            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, GarageInfo[garageid][gPosX], GarageInfo[garageid][gPosY], GarageInfo[garageid][gPosZ], 3.0);
                                        }
                                        else
                                        {
                                            GetVehiclePos(vehicleid, x, y, z);
                                            SetActiveCheckpoint(playerid, CHECKPOINT_MISC, x, y, z, 3.0);
                                        }
                                    }
                                    SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: The alarm was activated on %s's %s in %s (marked on map). *", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
                                }
                            }
                        }
                    }
                    SetVehicleParams(vehicleid, VEHICLE_ALARM, true);
                }

                GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, x, y, z);
                UpdateVehicleDamageStatus(vehicleid, damage[0], 131072, damage[2], damage[3]);

                new string[10];
                format(string, sizeof(string), "%.0f HP", LockHealth[playerid]);
                if (LockText[playerid] == Text3D:INVALID_3DTEXT_ID)
                {
                    if (IsPlayerAtVehicleDoor(playerid, LockBreak[playerid], VehicleDoorType_Driver))
                    {
                        LockText[playerid] = CreateDynamic3DTextLabel(string, COLOR_GREEN, -x * 2, y + 0.25, z, 5.0, .attachedvehicle = vehicleid);
                    }
                    else if (IsPlayerAtVehicleDoor(playerid, LockBreak[playerid], VehicleDoorType_Passenger))
                    {
                        LockText[playerid] = CreateDynamic3DTextLabel(string, COLOR_GREEN, x * 2, y + 0.25, z, 5.0, .attachedvehicle = vehicleid);
                    }
                }
                else
                {
                    UpdateDynamic3DTextLabelText(LockText[playerid], COLOR_GREEN, string);
                }

                KillTimer(LockTimer[playerid]);
                LockTimer[playerid] = SetTimerEx("DestroyLockText", 5000, false, "i", playerid);
            }
        }
    }
    return 1;
}

CMD:picklock(playerid, params[])
{
    callcmd::breakin(playerid, params);
}

CMD:breakin(playerid, params[])
{
    //TODO: breakin bikes
    new vehicleid = GetNearbyVehicle(playerid);

    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
    }
    if (vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any vehicle.");
    }
    if (VehicleInfo[vehicleid][vOwnerID] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You may only break into a player owned vehicle.");
    }
    if (VehicleInfo[vehicleid][vLocked] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is unlocked. Therefore you can't break into it.");
    }
    if (LockBreak[playerid] == vehicleid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already attempting to break into this vehicle.");
    }
    /*if (!VehicleHasDoors(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle cannot be broken into.");
    }*/
    if (IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Why would you want to break into your own vehicle?");
    }
    if (IsVehicleBeingPicked(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is already being broken into by someone else.");
    }

    LockBreak[playerid] = vehicleid;
    LockHealth[playerid] = 1000.0;

    SendClientMessage(playerid, COLOR_AQUA, "You have started the {FF6347}break-in{33CCFF} process. Start hitting the driver or passenger side door to break it down.");
    SendClientMessage(playerid, COLOR_AQUA, "You can use your fists for this job, however melee weapons are preferred and gets the job done faster.");
    return 1;
}
