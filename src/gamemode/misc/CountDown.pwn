
CMD:countdown(playerid, params[])
{
    if(!IsAdmin(playerid, JUNIOR_ADMIN))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    if(!IsAdminOnDuty(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    SetTimer("Count_Three", 1000, 0);
    SetTimer("Count_Two", 2000, 0);
    SetTimer("Count_One", 3000, 0);
    SetTimer("Count_GoGoGo", 4000, 0);
	
	return 1;
}

publish Count_Three()
{
 	SendClientMessageToAllEx(COLOR_AQUA, "3");
	return 1;
}

publish Count_Two()
{
	SendClientMessageToAllEx(COLOR_AQUA, "2");
	return 1;
}

publish Count_One()
{
	SendClientMessageToAllEx(COLOR_AQUA, "1");
 	return 1;
}

publish Count_GoGoGo()
{
	SendClientMessageToAllEx(COLOR_AQUA, "Go!");
 	return 1;
}
