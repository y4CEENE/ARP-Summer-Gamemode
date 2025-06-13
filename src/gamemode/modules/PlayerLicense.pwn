/// @file      PlayerLicense.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-05-22 12:59:36 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>
//TODO: Add a boat license exam
//TODO: Add a plane license exam

static PlayerLicenseInfo[MAX_PLAYERS][PlayerLicense];

stock PlayerHasLicense(playerid, PlayerLicense:license)
{
    return ((PlayerLicenseInfo[playerid][license] != -1) &&
            (gettime() > PlayerLicenseInfo[playerid][license]));
}

stock GivePlayerLicense(playerid, PlayerLicense:license)
{
    switch (license)
    {
        case PlayerLicense_Gun: DBQuery("UPDATE "#TABLE_USERS" set gunlicense = 0 where uid = %i", PlayerData[playerid][pID]);
        case PlayerLicense_Car: DBQuery("UPDATE "#TABLE_USERS" set carlicense = 0 where uid = %i", PlayerData[playerid][pID]);
        case PlayerLicense_Boat: DBQuery("UPDATE "#TABLE_USERS" set boatlicense = 0 where uid = %i", PlayerData[playerid][pID]);
        case PlayerLicense_Plane: DBQuery("UPDATE "#TABLE_USERS" set planelicense = 0 where uid = %i", PlayerData[playerid][pID]);
        default: return 0;
    }
    PlayerLicenseInfo[playerid][license] = 0;
    return 1;
}

stock RemovePlayerLicense(playerid, PlayerLicense:license, minutes = -1)
{
    if (PlayerLicenseInfo[playerid][license] == -1)
    {
        return 1;
    }
    new now = gettime();
    new end = -1;
    if (minutes != -1)
    {
        if (PlayerLicenseInfo[playerid][license] < now)
        {
            end = now + 60 * minutes;
        }
        else
        {
            end = PlayerLicenseInfo[playerid][license] + 60 * minutes;
        }
    }

    switch (license)
    {
        case PlayerLicense_Gun: DBQuery("UPDATE "#TABLE_USERS" set gunlicense = %i where uid = %i", end, PlayerData[playerid][pID]);
        case PlayerLicense_Car: DBQuery("UPDATE "#TABLE_USERS" set carlicense = %i where uid = %i", end, PlayerData[playerid][pID]);
        case PlayerLicense_Boat: DBQuery("UPDATE "#TABLE_USERS" set boatlicense = %i where uid = %i", end, PlayerData[playerid][pID]);
        case PlayerLicense_Plane: DBQuery("UPDATE "#TABLE_USERS" set planelicense = %i where uid = %i", end, PlayerData[playerid][pID]);
        default: return 0;
    }
    PlayerLicenseInfo[playerid][license] = end;
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    PlayerLicenseInfo[playerid][PlayerLicense_Gun]   = GetDBIntField(row, "gunlicense");
    PlayerLicenseInfo[playerid][PlayerLicense_Car]   = GetDBIntField(row, "carlicense");
    PlayerLicenseInfo[playerid][PlayerLicense_Boat]  = GetDBIntField(row, "boatlicense");
    PlayerLicenseInfo[playerid][PlayerLicense_Plane] = GetDBIntField(row, "planelicense");
    return 1;
}

CMD:removegunlicense(playerid, params[])
{
    new targetid;
    if (IsLawEnforcement(playerid))
    {
        if (sscanf(params, "d", targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Usage: /removegunlicense [playerid]");
        }
        if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
        }
        RemovePlayerLicense(playerid, PlayerLicense_Gun, 60);

        SendClientMessageEx(playerid, COLOR_AQUA, "You revoked %s's gun license for 60 minutes.", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "Officer %s has revoked your gun license for 60 minutes.", GetRPName(playerid));
    }
    else return SendUnauthorized(playerid);
    return 1;
}

CMD:givegunlicense(playerid, params[])
{
    new targetid;

    if (IsLawEnforcement(playerid))
    {
        if (sscanf(params, "d", targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Usage: /givegunlicense [playerid]");
        }
        if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
        }
        GivePlayerLicense(targetid, PlayerLicense_Gun);

        SendClientMessageEx(playerid, COLOR_AQUA, "You've give gun license to %s", GetRPName(targetid));
        SendClientMessageEx(targetid, COLOR_AQUA, "Officer %s has approved your gun license request", GetRPName(playerid));
    }
    else return SendUnautorizedChat(playerid);
    return 1;
}
