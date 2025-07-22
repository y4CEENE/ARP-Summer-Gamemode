
CMD:countdown(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    SetTimer("Count_Five",   1000, 0);
    SetTimer("Count_Four",   2000, 0);
    SetTimer("Count_Three",  3000, 0);
    SetTimer("Count_Two",    4000, 0);
    SetTimer("Count_One",    5000, 0);
    SetTimer("Count_GoGoGo", 6000, 0);
    return 1;
}

publish Count_Five()
{
    return GameTextForAll("5", 1000, 6);
}

publish Count_Four()
{

    return GameTextForAll("4", 1000, 6);
}

publish Count_Three()
{
    return GameTextForAll("3", 1000, 6);
}

publish Count_Two()
{
    return GameTextForAll("2", 1000, 6);
}

publish Count_One()
{
    return GameTextForAll("1", 1000, 6);
}

publish Count_GoGoGo()
{
    return GameTextForAll("Go!", 1000, 6);
}
