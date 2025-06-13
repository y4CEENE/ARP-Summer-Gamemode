/// @file      Coords.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022


CMD:angle(playerid, params[])
{
    new Float:a;
    GetPlayerFacingAngle(playerid, a);
    SendClientMessageEx(playerid, COLOR_WHITE, "Your facing angle is {00aa00}%f.", a);
    return 1;
}

CMD:coords(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    SendClientMessageEx(playerid, COLOR_GREY, "Your current position: X=%.4f, Y=%.4f, Z=%.4f, A=%.4f Int=%d, VW=%d",
                        x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    return 1;
}
