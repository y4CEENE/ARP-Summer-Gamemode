CMD:myangle(playerid, params[])
{
    new myString[128], Float:a;
    GetPlayerFacingAngle(playerid, a);

    format(myString, sizeof(myString), "Your angle is: %0.2f", a);
    SendClientMessage(playerid, 0xFFFFFFFF, myString);

    new myString2[128], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    format(myString2, sizeof(myString), "Your position is: %f, %f, %f", x, y, z);
    SendClientMessage(playerid, 0xFFFFFFFF, myString2);
    return 1;
}
