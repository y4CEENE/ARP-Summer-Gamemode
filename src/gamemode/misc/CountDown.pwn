/// @file      CountDown.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-05-27 11:23:23 +0100
/// @copyright Copyright (c) 2022


CMD:countdown(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    SetTimer("Count_Three", 1000, 0);
    SetTimer("Count_Two", 2000, 0);
    SetTimer("Count_One", 3000, 0);
    SetTimer("Count_GoGoGo", 4000, 0);
    return 1;
}

publish Count_Three()
{
    return SendClientMessageToAllEx(COLOR_AQUA, "3");
}

publish Count_Two()
{
    return SendClientMessageToAllEx(COLOR_AQUA, "2");
}

publish Count_One()
{
    return SendClientMessageToAllEx(COLOR_AQUA, "1");
}

publish Count_GoGoGo()
{
    return SendClientMessageToAllEx(COLOR_AQUA, "Go!");
}
