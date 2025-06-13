

hook OnGameModeInit()
{
    // Time textdraw
    TimeTD = TextDrawCreate(578.000000, 8.000000, "12:05AM");
    TextDrawAlignment(TimeTD, 2);
    TextDrawBackgroundColor(TimeTD, 255);
    TextDrawFont(TimeTD, 2);
    TextDrawLetterSize(TimeTD, 0.230000, 1.500000);
    TextDrawColor(TimeTD, -1);
    TextDrawSetOutline(TimeTD, 1);
    TextDrawSetProportional(TimeTD, 1);
    TextDrawSetSelectable(TimeTD, 0);
}

RefreshTime()
{
    new hour, minute, string[12];
    gettime(hour, minute);
    format(string, sizeof(string), "%02d:%02d", hour, minute);
    TextDrawSetString(TimeTD, string);
}

CMD:ww(playerid, params[])
{
    return callcmd::pw(playerid, params);
}

CMD:watch(playerid, params[])
{
    return callcmd::pw(playerid, params);
}

CMD:pw(playerid, params[])
{
    if (!PlayerData[playerid][pWatch])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a pocket watch. You can buy one at 24/7.");
    }

    if (!PlayerData[playerid][pWatchOn])
    {
        if (PlayerData[playerid][pToggleTextdraws])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't turn on your watch as you have textdraws toggled! (/toggle textdraws)");
        }

        PlayerData[playerid][pWatchOn] = 1;
        TextDrawShowForPlayer(playerid, TimeTD);
        ShowActionBubble(playerid, "* %s turns on their pocket watch.", GetRPName(playerid));
    }
    else
    {
        PlayerData[playerid][pWatchOn] = 0;
        TextDrawHideForPlayer(playerid, TimeTD);
        ShowActionBubble(playerid, "* %s turns off their pocket watch.", GetRPName(playerid));
    }

    return 1;
}

CMD:time(playerid, params[])
{
    new
        string[128],
        date[6];

    getdate(date[0], date[1], date[2]);
    gettime(date[3], date[4], date[5]);

    switch (date[1])
    {
        case 1: string = "January";
        case 2: string = "February";
        case 3: string = "March";
        case 4: string = "April";
        case 5: string = "May";
        case 6: string = "June";
        case 7: string = "July";
        case 8: string = "August";
        case 9: string = "September";
        case 10: string = "October";
        case 11: string = "November";
        case 12: string = "December";
    }

    format(string, sizeof(string), "~y~%s %02d, %i~n~~g~|~w~%02d:%02d:%02d~g~|", string, date[2], date[0], date[3], date[4], date[5]);

    if (PlayerData[playerid][pJailTime] > 0)
    {
        format(string, sizeof(string), "%s~n~~w~Jail Time: ~y~%i seconds", string, PlayerData[playerid][pJailTime]);
    }

    GameTextForPlayer(playerid, string, 5000, 1);
    SendClientMessageEx(playerid, COLOR_WHITE, "* Paychecks occur at every hour. The next paycheck is at %02d:00 which is in %i minutes.", date[3]+1, (60 - date[4]));
    return 1;
}
