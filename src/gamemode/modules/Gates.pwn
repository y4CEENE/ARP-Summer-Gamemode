/// @file      Gates.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-01-13 22:46:16 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MAX_GATES 150

enum gateData {
    gateID,
    gateExists,
    gateOpened,
    gateModel,
    Float:gateSpeed,
    Float:gateRadius,
    gateTime,
    Float:gatePos[6],
    gateInterior,
    gateWorld,
    Float:gateMove[6],
    gateLinkID,
    gateFaction,
    gateGang,
    gatePass[32],
    gateTimer,
    gateObject
};

static GateData[MAX_GATES][gateData];

hook OnGameModeInit(timestamp)
{
    for (new i=0;i<MAX_GATES;i++)
    {
        GateData[i][gateExists] = 0;
    }
    return 1;
}

GetGateByObjectID(objectid)
{
    for (new i=0;i<MAX_GATES;i++)
    {
        if (GateData[i][gateExists] && GateData[i][gateObject] == objectid)
        {
            return i;
        }
    }
    return -1;
}

hook OnLoadDatabase(timestamp)
{
    DBQueryWithCallback("SELECT * FROM `gates`", "Gate_Load", "");

    return 1;
}

stock GetNearbyGate(playerid)
{
    for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && IsPlayerInRangeOfPoint(playerid, GateData[i][gateRadius], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2]))
    {
        if (GetPlayerInterior(playerid) == GateData[i][gateInterior] && GetPlayerVirtualWorld(playerid) == GateData[i][gateWorld])
            return i;
    }
    return -1;
}


stock GetGateByID(sqlid)
{
    for (new i = 0; i != MAX_GATES; i ++)
    {
        if (GateData[i][gateExists] && GateData[i][gateID] == sqlid)
        {
            return i;
        }
    }
    return -1;
}

stock Gate_Operate(gateid)
{
    if (gateid != -1 && GateData[gateid][gateExists])
    {
        new id = -1;

        if (!GateData[gateid][gateOpened])
        {
            GateData[gateid][gateOpened] = true;
            MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gateMove][0], GateData[gateid][gateMove][1],
                GateData[gateid][gateMove][2], GateData[gateid][gateSpeed], GateData[gateid][gateMove][3],
                GateData[gateid][gateMove][4], GateData[gateid][gateMove][5]);

            if (GateData[gateid][gateTime] > 0)
            {
                GateData[gateid][gateTimer] = SetTimerEx("CloseGate", GateData[gateid][gateTime], false, "ddfffffff",
                    gateid, GateData[gateid][gateLinkID], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1],
                    GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3],
                    GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);
            }

            if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
            {
                GateData[id][gateOpened] = true;
                MoveDynamicObject(GateData[id][gateObject], GateData[id][gateMove][0], GateData[id][gateMove][1],
                    GateData[id][gateMove][2], GateData[id][gateSpeed], GateData[id][gateMove][3],
                    GateData[id][gateMove][4], GateData[id][gateMove][5]);
            }
        }
        else if (GateData[gateid][gateOpened])
        {
            GateData[gateid][gateOpened] = false;
            MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1],
                GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3],
                GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);

            if (GateData[gateid][gateTime] > 0)
            {
                KillTimer(GateData[gateid][gateTimer]);
            }
            if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
            {
                GateData[id][gateOpened] = false;
                MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1],
                    GateData[id][gatePos][2], GateData[id][gateSpeed], GateData[id][gatePos][3],
                    GateData[id][gatePos][4], GateData[id][gatePos][5]);
            }
        }
    }
    return 1;
}

stock Gate_Create(playerid)
{
    new
        Float:x,
        Float:y,
        Float:z,
        Float:angle;

    if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
    {
        for (new i = 0; i < MAX_GATES; i ++) if (!GateData[i][gateExists])
        {
            GateData[i][gateExists] = true;
            GateData[i][gateModel] = 980;
            GateData[i][gateSpeed] = 3.0;
            GateData[i][gateRadius] = 5.0;
            GateData[i][gateOpened] = 0;
            GateData[i][gateTime] = 0;

            GateData[i][gatePos][0] = x + (3.0 * floatsin(-angle, degrees));
            GateData[i][gatePos][1] = y + (3.0 * floatcos(-angle, degrees));
            GateData[i][gatePos][2] = z;
            GateData[i][gatePos][3] = 0.0;
            GateData[i][gatePos][4] = 0.0;
            GateData[i][gatePos][5] = angle;

            GateData[i][gateMove][0] = x + (3.0 * floatsin(-angle, degrees));
            GateData[i][gateMove][1] = y + (3.0 * floatcos(-angle, degrees));
            GateData[i][gateMove][2] = z - 10.0;
            GateData[i][gateMove][3] = -1000.0;
            GateData[i][gateMove][4] = -1000.0;
            GateData[i][gateMove][5] = -1000.0;

            GateData[i][gateInterior] = GetPlayerInterior(playerid);
            GateData[i][gateWorld] = GetPlayerVirtualWorld(playerid);

            GateData[i][gateLinkID] = -1;
            GateData[i][gateFaction] = -1;
            GateData[i][gateGang] = -1;

            GateData[i][gatePass][0] = '\0';
            GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);

            DBQueryWithCallback("INSERT INTO `gates` (`gateModel`) VALUES(980)", "OnGateCreated", "d", i);
            return i;
        }
    }
    return -1;
}

stock Gate_Delete(gateid)
{
    if (gateid != -1 && GateData[gateid][gateExists])
    {
        DBQuery("DELETE FROM `gates` WHERE `gateID` = '%d'", GateData[gateid][gateID]);

        if (IsValidDynamicObject(GateData[gateid][gateObject]))
            DestroyDynamicObject(GateData[gateid][gateObject]);

        for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && GateData[i][gateLinkID] == GateData[gateid][gateID])
        {
            GateData[i][gateLinkID] = -1;
            Gate_Save(i);
        }
        if (GateData[gateid][gateOpened] && GateData[gateid][gateTime] > 0)
        {
            KillTimer(GateData[gateid][gateTimer]);
        }
        GateData[gateid][gateExists] = false;
        GateData[gateid][gateID] = 0;
        GateData[gateid][gateOpened] = 0;
    }
    return 1;
}

stock Gate_Save(gateid)
{
    DBQuery("UPDATE gates SET "\
            "gateModel = '%d',"\
            "gateSpeed = '%.4f',"\
            "gateRadius = '%.4f',"\
            "gateTime = '%d',"\
            "gateX = '%.4f', gateY = '%.4f', gateZ = '%.4f',"\
            "gateRX = '%.4f', gateRY = '%.4f', gateRZ = '%.4f',"\
            "gateInterior = '%d',"\
            "gateWorld = '%d',"\
            "gateMoveX = '%.4f', gateMoveY = '%.4f', gateMoveZ = '%.4f',"\
            "gateMoveRX = '%.4f', gateMoveRY = '%.4f', gateMoveRZ = '%.4f',"\
            "gateLinkID = '%d',"\
            "gateFaction = '%d',"\
            "gateGang = '%d',"\
            "gatePass = '%e' WHERE `gateID` = '%d'",
            GateData[gateid][gateModel],
            GateData[gateid][gateSpeed],
            GateData[gateid][gateRadius],
            GateData[gateid][gateTime],
            GateData[gateid][gatePos][0],
            GateData[gateid][gatePos][1],
            GateData[gateid][gatePos][2],
            GateData[gateid][gatePos][3],
            GateData[gateid][gatePos][4],
            GateData[gateid][gatePos][5],
            GateData[gateid][gateInterior],
            GateData[gateid][gateWorld],
            GateData[gateid][gateMove][0],
            GateData[gateid][gateMove][1],
            GateData[gateid][gateMove][2],
            GateData[gateid][gateMove][3],
            GateData[gateid][gateMove][4],
            GateData[gateid][gateMove][5],
            GateData[gateid][gateLinkID],
            GateData[gateid][gateFaction],
            GateData[gateid][gateGang],
            GateData[gateid][gatePass],
            GateData[gateid][gateID]);
    return 1;
}


DB:OnGateCreated(gateid)
{
    if (gateid == -1 || !GateData[gateid][gateExists])
        return 0;

    GateData[gateid][gateID] = GetDBInsertID();
    Gate_Save(gateid);

    return 1;
}

publish CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ)
{
    new id = -1;

    if (GateData[gateid][gateExists] && GateData[gateid][gateOpened])
    {
        MoveDynamicObject(GateData[gateid][gateObject], fX, fY, fZ, speed, fRotX, fRotY, fRotZ);

        if ((id = GetGateByID(linkid)) != -1)
            MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], speed, GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);

        GateData[id][gateOpened] = 0;
        return 1;
    }
    return 0;
}

DB:Gate_Load()
{
    new rows = GetDBNumRows();

    for (new i = 0; i < rows; i ++)
    {
        if (i < MAX_GATES)
        {
            GateData[i][gateExists] = true;
            GateData[i][gateOpened] = false;

            GateData[i][gateID]       = GetDBIntField(i, "gateID");
            GateData[i][gateModel]    = GetDBIntField(i, "gateModel");
            GateData[i][gateTime]     = GetDBIntField(i, "gateTime");
            GateData[i][gateInterior] = GetDBIntField(i, "gateInterior");
            GateData[i][gateWorld]    = GetDBIntField(i, "gateWorld");
            GateData[i][gateSpeed]    = GetDBFloatField(i, "gateSpeed");
            GateData[i][gateRadius]   = GetDBFloatField(i, "gateRadius");

            GateData[i][gatePos][0] = GetDBFloatField(i, "gateX");
            GateData[i][gatePos][1] = GetDBFloatField(i, "gateY");
            GateData[i][gatePos][2] = GetDBFloatField(i, "gateZ");
            GateData[i][gatePos][3] = GetDBFloatField(i, "gateRX");
            GateData[i][gatePos][4] = GetDBFloatField(i, "gateRY");
            GateData[i][gatePos][5] = GetDBFloatField(i, "gateRZ");

            GateData[i][gateMove][0] = GetDBFloatField(i, "gateMoveX");
            GateData[i][gateMove][1] = GetDBFloatField(i, "gateMoveY");
            GateData[i][gateMove][2] = GetDBFloatField(i, "gateMoveZ");
            GateData[i][gateMove][3] = GetDBFloatField(i, "gateMoveRX");
            GateData[i][gateMove][4] = GetDBFloatField(i, "gateMoveRY");
            GateData[i][gateMove][5] = GetDBFloatField(i, "gateMoveRZ");

            GateData[i][gateLinkID ] = GetDBIntField(i, "gateLinkID");
            GateData[i][gateFaction] = GetDBIntField(i, "gateFaction");
            GateData[i][gateGang   ] = GetDBIntField(i, "gateGang");

            GetDBStringField(i, "gatePass", GateData[i][gatePass], 32);

            GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
        }
    }
    return 1;
}


Dialog:GatePass(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new id = GetNearbyGate(playerid);

        if (id == -1)
        {
            return 0;
        }

        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
        }

        if (strcmp(inputtext, GateData[id][gatePass]) != 0)
        {
            return Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Error: Incorrect password specified.\n\nPlease enter the password for this gate below:", "Submit", "Cancel");
        }

        Gate_Operate(id);
    }
    return 1;
}


CMD:creategate(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_7))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    new id = Gate_Create(playerid);

    if (id == -1)
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "The server has reached the limit for gates.");
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully created gate ID: %d.", id);
    return 1;
}

stock ToggleGate(playerid, id)
{
    if (id != -1)
    {
        if (strlen(GateData[id][gatePass]))
        {
            Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT,  "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");
        }
        else
        {
            if (GateData[id][gateFaction] != -1 && PlayerData[playerid][pFaction] != GateData[id][gateFaction])
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "You can't open this gate/door.");
            }
            if (GateData[id][gateGang] != -1 && PlayerData[playerid][pGang] != GateData[id][gateGang])
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "You can't open this gate/door.");
            }

            Gate_Operate(id);

            switch (GateData[id][gateOpened])
            {
                case 0:
                {
                    SendClientMessage(playerid, COLOR_GREY, "You have closed the gate/door!");
                    SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s uses their card to close the gate/door.", GetRPName(playerid));
                }
                case 1:
                {
                    SendClientMessage(playerid, COLOR_GREY, "You have opened the gate/door!");
                    SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s uses their card to open the gate/door.", GetRPName(playerid));
                }
            }
        }
    }
    return 1;
}


CMD:gotogate(playerid, params[])
{
    new gateid;

    if (!IsAdmin(playerid, ADMIN_LVL_7))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }

    if (!IsAdminOnDuty(playerid, 5))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", gateid))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Usage: /gotogate [gateid]");
    }
    if (!(0 <= gateid < MAX_GATES) || !GateData[gateid][gateExists])
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid gate.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid,
        GateData[gateid][gatePos][0] - (2.5 * floatsin(-GateData[gateid][gatePos][3], degrees)),
        GateData[gateid][gatePos][1] - (2.5 * floatcos(-GateData[gateid][gatePos][3], degrees)),
        GateData[gateid][gatePos][2]);

    SetPlayerInterior(playerid, GateData[gateid][gateInterior]);
    SetPlayerVirtualWorld(playerid, GateData[gateid][gateWorld]);
    SetCameraBehindPlayer(playerid);
    return 1;
}


CMD:destroygate(playerid, params[])
{
    new id = 0;

    if (!IsAdmin(playerid, ADMIN_LVL_7))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "d", id))
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /destroygate [gate id]");
    }

    if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");
    }

    Gate_Delete(id);
    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully destroyed gate ID: %d.", id);
    return 1;
}

CMD:editgate(playerid, params[])
{
    new id, type[24], string[128];

    if (!IsAdmin(playerid, ADMIN_LVL_7))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "ds[24]S()[128]", id, type, string))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [name]");
        SendClientMessage(playerid, COLOR_ORANGE, "Names:{FFFFFF} location, speed, radius, time, model, pos, move, pass, linkid, faction, gang");
        return 1;
    }

    if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");
    }

    if (!strcmp(type, "location", true))
    {
        new Float:x, Float:y, Float:z, Float:angle;

        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        x += 3.0 * floatsin(-angle, degrees);
        y += 3.0 * floatcos(-angle, degrees);

        GateData[id][gatePos][0] = x;
        GateData[id][gatePos][1] = y;
        GateData[id][gatePos][2] = z;
        GateData[id][gatePos][3] = 0.0;
        GateData[id][gatePos][4] = 0.0;
        GateData[id][gatePos][5] = angle;

        SetDynamicObjectPos(GateData[id][gateObject], x, y, z);
        SetDynamicObjectRot(GateData[id][gateObject], 0.0, 0.0, angle);

        GateData[id][gateOpened] = false;

        Gate_Save(id);
        SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the position of gate ID: %d.", GetRPName(playerid), id);
        return 1;
    }
    else if (!strcmp(type, "speed", true))
    {
        new Float:speed;

        if (sscanf(string, "f", speed))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [speed] [move speed]");
        }

        if (speed < 0.0 || speed > 20.0)
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "The specified speed can't be below 0 or above 20.");
        }

        GateData[id][gateSpeed] = speed;

        Gate_Save(id);
        SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the speed of gate ID: %d to %.2f.", GetRPName(playerid), id, speed);
        return 1;
    }
    else if (!strcmp(type, "radius", true))
    {
        new Float:radius;

        if (sscanf(string, "f", radius))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [radius] [open radius]");
        }

        if (radius < 0.0 || radius > 20.0)
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "The specified radius can't be below 0 or above 20.");
        }

        GateData[id][gateRadius] = radius;

        Gate_Save(id);
        SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the radius of gate ID: %d to %.2f.", GetRPName(playerid), id, radius);
        return 1;
    }
    else if (!strcmp(type, "time", true))
    {
        new time;

        if (sscanf(string, "d", time))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [time] [close time] (0 to disable)");
        }

        if (time < 0 || time > 60000)
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "The specified time can't be 0 or above 60,000 ms.");
        }

        GateData[id][gateTime] = time;

        Gate_Save(id);
        SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the close time of gate ID: %d to %d.", GetRPName(playerid), id, time);
        return 1;
    }
    else if (!strcmp(type, "model", true))
    {
        new model;

        if (sscanf(string, "d", model))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [model] [gate model]");
        }

        //if (!IsValidObjectModel(model))
        //{
        //    return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid object model.");
        //}

        GateData[id][gateModel] = model;

        DestroyDynamicObject(GateData[id][gateObject]);
        GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0],
            GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4],
            GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

        Gate_Save(id);
        SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the model of gate ID: %d to %d.", GetRPName(playerid), id, model);
        return 1;
    }
    else if (!strcmp(type, "pos", true))
    {
        PlayerData[playerid][pEditType] = EDIT_GATE_OBJECT;
        PlayerData[playerid][pEditObject] = GateData[id][gateObject];
        EditDynamicObject(playerid, GateData[id][gateObject]);

        SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the position of gate ID: %d.", id);
        return 1;
    }
    else if (!strcmp(type, "move", true))
    {
        PlayerData[playerid][pEditType] = EDIT_GATE_MOVE;
        PlayerData[playerid][pEditObject] = GateData[id][gateObject];
        EditDynamicObject(playerid, GateData[id][gateObject]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You are now adjusting the moving position of gate ID: %d.", id);
        return 1;
    }
    else if (!strcmp(type, "linkid", true))
    {
        new linkid = -1;

        if (sscanf(string, "d", linkid))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [linkid] [gate link] (-1 for none)");
        }

        if ((linkid < -1 || linkid >= MAX_GATES) || (linkid != -1 && !GateData[linkid][gateExists]))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You have specified an invalid gate ID.");
        }

        GateData[id][gateLinkID] = (linkid == -1) ? (-1) : (GateData[linkid][gateID]);
        Gate_Save(id);

        if (id == -1)
        {
            SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to no gate.", GetRPName(playerid), id);
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to ID: %d.", GetRPName(playerid), id, linkid);
        }

        return 1;
    }
    else if (!strcmp(type, "faction", true))
    {
        new factionid = 0;

        if (sscanf(string, "d", factionid))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [faction] [gate faction] (-1 for none)");
        }

        if ((factionid != -1) && (!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "Invalid faction.");
        }


        GateData[id][gateFaction] = factionid;
        Gate_Save(id);

        if (factionid == -1)
        {
            SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to no faction.", GetRPName(playerid), id);
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the faction of gate ID: %d to \"%s\".", GetRPName(playerid), id, FactionInfo[factionid][fName]);
        }

        return 1;
    }
    else if (!strcmp(type, "gang", true))
    {
        new gangid = 0;

        if (sscanf(string, "d", gangid))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] gang [gangid] (-1 for none)");
        }

        if (!(-1 <= gangid < MAX_GANGS) || (gangid >= 0 && !GangInfo[gangid][gSetup]))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid gang.");
        }


        GateData[id][gateGang] = gangid;
        Gate_Save(id);

        if (gangid == -1)
        {
            SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the gang of gate ID: %d to no gang.", GetRPName(playerid), id);
        }
        else
        {
            SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the gang of gate ID: %d to \"%s\".", GetRPName(playerid), id, GangInfo[gangid][gName]);
        }

        return 1;
    }
    else if (!strcmp(type, "pass", true))
    {
        new pass[32];

        if (sscanf(string, "s[32]", pass))
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /editgate [id] [pass] [gate password] (Use 'none' to disable)");
        }

        if (!strcmp(pass, "none", true))
        {
            GateData[id][gatePass][0] = 0;
        }
        else
        {
            format(GateData[id][gatePass], 32, pass);
        }

        Gate_Save(id);
        SendAdminMessage(COLOR_LIGHTRED, "ACmd: %s has adjusted the password of gate ID: %d to %s.", GetRPName(playerid), id, pass);
        return 1;
    }
    return 1;
}
stock RedrawGate(gateid)
{
    DestroyDynamicObject(GateData[gateid][gateObject]);
    GateData[gateid][gateObject] =  CreateDynamicObject(GateData[gateid][gateModel],
        GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2],
        GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5],
        GateData[gateid][gateWorld], GateData[gateid][gateInterior]);
}

stock UpdateGateMovingPosition(gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    GateData[gateid][gateMove][0] = x;
    GateData[gateid][gateMove][1] = y;
    GateData[gateid][gateMove][2] = z;
    GateData[gateid][gateMove][3] = rx;
    GateData[gateid][gateMove][4] = ry;
    GateData[gateid][gateMove][5] = rz;
    GateData[gateid][gateOpened] = false;

    RedrawGate(gateid);

    Gate_Save(gateid);
}

stock UpdateGatePosition(gateid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    GateData[gateid][gatePos][0] = x;
    GateData[gateid][gatePos][1] = y;
    GateData[gateid][gatePos][2] = z;
    GateData[gateid][gatePos][3] = rx;
    GateData[gateid][gatePos][4] = ry;
    GateData[gateid][gatePos][5] = rz;
    GateData[gateid][gateOpened] = false;

    DestroyDynamicObject(GateData[gateid][gateObject]);
    GateData[gateid][gateObject] =  CreateDynamicObject(GateData[gateid][gateModel],
        GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2],
        GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5],
        GateData[gateid][gateWorld], GateData[gateid][gateInterior]);

    Gate_Save(gateid);
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    switch (PlayerData[playerid][pEditType])
    {
        case EDIT_GATE_OBJECT:
        {
            if (response != EDIT_RESPONSE_UPDATE)
            {
                new id = GetGateByObjectID(PlayerData[playerid][pEditObject]);

                if (response == EDIT_RESPONSE_FINAL)
                {
                    UpdateGatePosition(id, x,y,z,rx,ry,rz);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the position of gate ID: %d.", id);
                }
                else if (response == EDIT_RESPONSE_CANCEL)
                {
                    RedrawGate(id);
                }
                PlayerData[playerid][pEditType] = 0;
            }
        }
        case EDIT_GATE_MOVE:
        {
            if (response != EDIT_RESPONSE_UPDATE)
            {
                new id = GetGateByObjectID(PlayerData[playerid][pEditObject]);

                if (response == EDIT_RESPONSE_FINAL)
                {
                    UpdateGateMovingPosition(id, x,y,z,rx,ry,rz);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the moving position of gate ID: %d.", id);
                }
                else if (response == EDIT_RESPONSE_CANCEL)
                {
                    RedrawGate(id);
                }
                PlayerData[playerid][pEditType] = 0;
            }
        }
    }
    return 1;
}
