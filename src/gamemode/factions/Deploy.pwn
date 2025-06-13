/// @file      Deploy.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 20:17:56 +0200
/// @copyright Copyright (c) 2022


enum
{
    DEPLOY_SPIKESTRIP,
    DEPLOY_CONE,
    DEPLOY_ROADBLOCK,
    DEPLOY_BARREL,
    DEPLOY_FLARE
};

enum dEnum
{
    dExists,
    dType,
    Float:dPosX,
    Float:dPosY,
    Float:dPosZ,
    Float:dPosA,
    dObject
};
static DeployInfo[MAX_DEPLOYABLES][dEnum];

static const deployableItems[][] =
{
    {"Spikestrip"},
    {"Traffic cone"},
    {"Roadblock"},
    {"Barrel"},
    {"Smoke flare"}
};

DeployObject(type, Float:x, Float:y, Float:z, Float:angle)
{
    for (new i = 0; i < MAX_DEPLOYABLES; i ++)
    {
        if (!DeployInfo[i][dExists])
        {
            DeployInfo[i][dExists] = 1;
            DeployInfo[i][dType] = type;
            DeployInfo[i][dPosX] = x;
            DeployInfo[i][dPosY] = y;
            DeployInfo[i][dPosZ] = z;
            DeployInfo[i][dPosA] = angle;

            if (type == DEPLOY_SPIKESTRIP)
            {
                DeployInfo[i][dObject] = CreateDynamicObject(2899, x + 1.0 * floatsin(-angle, degrees), y + 1.0 * floatcos(-angle, degrees), z - 0.9, 0.0, 0.0, angle + 90.0);
            }
            else if (type == DEPLOY_CONE)
            {
                DeployInfo[i][dObject] = CreateDynamicObject(1238, x + 1.0 * floatsin(-angle, degrees), y + 1.0 * floatcos(-angle, degrees), z - 0.7, 0.0, 0.0, angle);
            }
            else if (type == DEPLOY_ROADBLOCK)
            {
                DeployInfo[i][dObject] = CreateDynamicObject(981, x + 3.0 * floatsin(-angle, degrees), y + 3.0 * floatcos(-angle, degrees), z, 0.0, 0.0, angle);
            }
            else if (type == DEPLOY_BARREL)
            {
                DeployInfo[i][dObject] = CreateDynamicObject(1237, x + 1.0 * floatsin(-angle, degrees), y + 1.0 * floatcos(-angle, degrees), z - 1.0, 0.0, 0.0, angle);
            }
            else if (type == DEPLOY_FLARE)
            {
                DeployInfo[i][dObject] = CreateDynamicObject(18728, x, y, z - 1.4, 0.0, 0.0, angle);
            }

            return i;
        }
    }

    return -1;
}

CMD:deploy(playerid, params[])
{
    new type[12], type_id = -1, Float:x, Float:y, Float:z, Float:a;

    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }
    if (PlayerData[playerid][pFactionRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't R4+.");
    }
    if (sscanf(params, "s[12]", type))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deploy [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Spikestrip, Cone, Roadblock, Barrel, Flare");
        return 1;
    }
    if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while being in a vehicle");
    }
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't deploy objects inside.");
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    if (!strcmp(type, "spikestrip", true))
    {
        type_id = DEPLOY_SPIKESTRIP;
    }
    else if (!strcmp(type, "cone", true))
    {
        type_id = DEPLOY_CONE;
    }
    else if (!strcmp(type, "roadblock", true))
    {
        type_id = DEPLOY_ROADBLOCK;
    }
    else if (!strcmp(type, "barrel", true))
    {
        type_id = DEPLOY_BARREL;
    }
    else if (!strcmp(type, "flare", true))
    {
        type_id = DEPLOY_FLARE;
    }

    if (type_id == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid type.");
    }
    if (DeployObject(type_id, x, y, z, a) == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The deployable objects pool is full. Try deleting some first.");
    }

    if (IsLawEnforcement(playerid))
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has deployed a %s in %s.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), deployableItems[type_id], GetZoneName(x, y, z));
    else
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_DOCTOR, "* HQ: %s %s has deployed a %s in %s.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), deployableItems[type_id], GetZoneName(x, y, z));

    return 1;
}

CMD:undeployall(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }

    for (new i = 0; i < MAX_DEPLOYABLES; i ++)
    {
        if (DeployInfo[i][dExists])
        {
            DestroyDynamicObject(DeployInfo[i][dObject]);
            DeployInfo[i][dExists] = 0;
            DeployInfo[i][dType] = -1;
        }
    }
    SendFactionMessage(PlayerData[playerid][pFaction], (IsLawEnforcement(playerid)) ? (COLOR_OLDSCHOOL) : (COLOR_DOCTOR), "* HQ: %s %s has removed all deployed objects.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
    return 1;
}

CMD:undeploy(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }

    for (new i = 0; i < MAX_DEPLOYABLES; i ++)
    {
        if (DeployInfo[i][dExists])
        {
            new Float:range;

            if (DeployInfo[i][dType] == DEPLOY_SPIKESTRIP || DeployInfo[i][dType] == DEPLOY_BARREL || DeployInfo[i][dType] == DEPLOY_FLARE || DeployInfo[i][dType] == DEPLOY_CONE)
            {
                range = 2.0;
            }
            else if (DeployInfo[i][dType] == DEPLOY_ROADBLOCK)
            {
                range = 5.0;
            }

            if (IsPlayerInRangeOfPoint(playerid, range, DeployInfo[i][dPosX], DeployInfo[i][dPosY], DeployInfo[i][dPosZ]))
            {
                SendFactionMessage(PlayerData[playerid][pFaction], (IsLawEnforcement(playerid)) ? (COLOR_OLDSCHOOL) : (COLOR_DOCTOR), "* HQ: %s %s has removed a %s in %s.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), deployableItems[DeployInfo[i][dType]], GetZoneName(DeployInfo[i][dPosX], DeployInfo[i][dPosY], DeployInfo[i][dPosZ]));
                DestroyDynamicObject(DeployInfo[i][dObject]);

                DeployInfo[i][dExists] = 0;
                DeployInfo[i][dType] = -1;
                return 1;
            }
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any deployed objects.");
    return 1;
}
