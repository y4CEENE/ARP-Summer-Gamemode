#include <YSI\y_hooks>

static CarryOffer[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    CarryOffer[playerid] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid)
{
    if (CarryOffer[playerid] == playerid)
	{
		CarryOffer[playerid] = INVALID_PLAYER_ID;
	}
    return 1;
}

CMD:carry(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
    }
	if (PlayerData[playerid][pLevel] < 3)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be at least level 3+ to use this command.");
	}
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /carry [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't carry yourself.");
    }
    if (!PlayerData[targetid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not injured.");
    }
    if(IsPlayerInAnyVehicle(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command when player is in a vehicle use [/eject].");
    }

    CarryOffer[targetid] = playerid;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to carry you. (/accept carry)", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have requested to carry %s.", GetRPName(targetid));
    return 1;
}

CMD:stopcarry(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /stopcarry [targetid]");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't carry yourself.");
    }
    if (PlayerData[targetid][pDraggedBy] == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "targetid is not carryed.");
    }
    else {
        PlayerData[targetid][pDraggedBy] = INVALID_PLAYER_ID;
        SendClientMessageEx(playerid, COLOR_PURPLE, "* %s stops carrying %s.", GetRPName(targetid), GetRPName(playerid));
        ShowActionBubble(playerid, "* %s stops carrying %s.", GetRPName(targetid), GetRPName(playerid));
    }
    return 1;
}

AcceptCarry(playerid){
    new offeredby = CarryOffer[playerid];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There isn't any carry offers.");
    }
    if (!IsPlayerConnected(offeredby) || !IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }

    PlayerData[playerid][pDraggedBy] = offeredby;

    SendClientMessageEx(playerid, COLOR_PURPLE, "* %s carry onto %s and begins to carry them.", GetRPName(offeredby), GetRPName(playerid));
    ShowActionBubble(playerid, "* %s carry onto %s and begins to carry them.", GetRPName(offeredby), GetRPName(playerid));
    GameTextForPlayer(playerid, "~r~Being carryed...", 3000, 3);
    CarryOffer[playerid] = INVALID_PLAYER_ID;
    return 1;
}