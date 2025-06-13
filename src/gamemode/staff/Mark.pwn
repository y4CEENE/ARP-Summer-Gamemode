#include <YSI\y_hooks>

enum mEnum
{
    Float:mPosX,
    Float:mPosY,
    Float:mPosZ,
    Float:mPosA,
    mInterior,
    mWorld
};

static MarkedPositions[MAX_PLAYERS][3][mEnum];

hook OnPlayerInit(playerid)
{
    for (new i = 0; i < 3; i ++)
    {
        MarkedPositions[playerid][i][mPosX] = 0.0;
        MarkedPositions[playerid][i][mPosY] = 0.0;
        MarkedPositions[playerid][i][mPosZ] = 0.0;
    }
}

CMD:mark(playerid, params[])
{
    new slot;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", slot))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /mark [slot (1-3)]");
    }
    if (!(1 <= slot <= 3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
    }

    slot--;

    GetPlayerPos(playerid, MarkedPositions[playerid][slot][mPosX], MarkedPositions[playerid][slot][mPosY], MarkedPositions[playerid][slot][mPosZ]);
    GetPlayerFacingAngle(playerid, MarkedPositions[playerid][slot][mPosA]);

    MarkedPositions[playerid][slot][mInterior] = GetPlayerInterior(playerid);
    MarkedPositions[playerid][slot][mWorld] = GetPlayerVirtualWorld(playerid);

    SendClientMessageEx(playerid, COLOR_AQUA, "* Position saved in slot %i.", slot + 1);
    return 1;
}

CMD:gotomark(playerid, params[])
{
    new slot;

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    if (sscanf(params, "i", slot))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotomark [slot (1-3)]");
    }

    if (!(1 <= slot <= 3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid slot.");
    }
    if (MarkedPositions[playerid][slot-1][mPosX] == 0.0 && MarkedPositions[playerid][slot-1][mPosY] == 0.0 && MarkedPositions[playerid][slot-1][mPosZ] == 0.0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no position in the slot selected.");
    }

    slot--;

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, MarkedPositions[playerid][slot][mPosX], MarkedPositions[playerid][slot][mPosY], MarkedPositions[playerid][slot][mPosZ]);
    SetPlayerFacingAngle(playerid, MarkedPositions[playerid][slot][mPosA]);
    SetPlayerInterior(playerid, MarkedPositions[playerid][slot][mInterior]);
    SetPlayerVirtualWorld(playerid, MarkedPositions[playerid][slot][mWorld]);
    SetCameraBehindPlayer(playerid);

    return 1;
}
