#include <YSI\y_hooks>

forward OnPlayerEquipVest(playerid);

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Kevlar Vest\ntype /buyvest to buy vest.", COLOR_YELLOW, 2184.183837, 890.348083, -12.143171, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
    CreateDynamic3DTextLabel("Kevlar Vest\ntype /buyvest to buy vest.", COLOR_YELLOW, 1180.040527, 2975.610839, 1006.115966, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
    CreateDynamic3DTextLabel("Kevlar Vest\ntype /buyvest to buy vest.", COLOR_YELLOW, 1803.639526, -1644.932373, 1117.140136, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
    CreateDynamicPickup(1242, 1, 2184.183837, 890.348083, -12.143171);
    CreateDynamicPickup(1242, 1, 1180.040527, 2975.610839, 1006.115966);
    CreateDynamicPickup(1242, 1, 1803.639526, -1644.932373, 1117.140136);
    return 1;
}

CMD:usevest(playerid, params[])
{
    if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SCM(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
    }
    if(PlayerData[playerid][pHurt])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to use vest. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
	}
    if (PlayerData[playerid][pArmor] >= 100)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
    }
    if(PlayerData[playerid][pVest] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no vest left.");
    }

    if(PlayerData[playerid][pEquipVest])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are already equipping a vest.");
    }

    new string[128];
    PlayerData[playerid][pVest]--;

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerData[playerid][pVest], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    format(string, sizeof(string), "* %s has takes off their vest, dropping it on the ground.", GetPlayerNameEx(playerid));
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);
    format(string, sizeof(string), "* %s picks up the vest equipping it to themselves.", GetPlayerNameEx(playerid));
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);

    SendClientMessageEx(playerid, COLOR_PURPLE, " Equipping your kevlar vest, this will take 10 seconds. Keep cover! ");

    PlayerData[playerid][pEquipVest] = 1;
    PlayerData[playerid][pEquipTimer] = SetTimerEx("OnPlayerEquipVest", 10000, 0, "d", playerid);

    GameTextForPlayer(playerid, "~g~Wearing Vest ~n~ ~r~10 seconds", 10000, 1);

    return 1;
}

CMD:buyvest(playerid, params[])
{
    if(PlayerData[playerid][pVest] >= 5)
    {
        return SCM(playerid, COLOR_SYNTAX, "You can't have more than 5 vests.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2184.183837, 890.348083, -12.143171) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1180.040527, 2975.610839, 1006.115966) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1803.639526, -1644.932373, 1117.140136))
        return SendClientMessage(playerid, COLOR_GREY, "You are not near at your faction locker range!");
    if(PlayerData[playerid][pCash] < 2000)
    {
        return SCM(playerid, COLOR_GREY, "You don't have enough money. You can't buy this.");
    }

    PlayerData[playerid][pVest] += 1;
    GivePlayerCash(playerid, -2000);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vest = %i WHERE uid = %i", PlayerData[playerid][pVest], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    new string[128];
    format(string, sizeof(string), "**%s paid $2000 and received a vest.", GetRPName(playerid));
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);

    SCM(playerid, COLOR_AQUA, "Vest purchased. Use /usevest to use it.");

    return 1;
}

public OnPlayerEquipVest(playerid)
{
    PlayerData[playerid][pArmor] = 150;
    SetPlayerArmour(playerid, PlayerData[playerid][pArmor]);

    GameTextForPlayer(playerid, "~g~Vest equipped!", 5000, 1);
    SendClientMessageEx(playerid, COLOR_AQUA, "You are now wearing your kevlar vest.");

    return 1;
}

