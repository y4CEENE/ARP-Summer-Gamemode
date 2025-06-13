
CMD:dev(playerid, params[])
{
    if (PlayerData[playerid][pDeveloper] || IsGodAdmin(playerid))
    {
        Dialog_Show(playerid, DevTest, DIALOG_STYLE_LIST, "Report",
            "Sound\nAnim\nHandsup", "Select", "Cancel");
        return 1;
    }
    return 0;
}

Dialog:DevTest(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: callcmd::testsound(playerid, "");
            case 1: callcmd::testanim(playerid, "");
            case 2: callcmd::testhandsup(playerid, "");
        }
    }
    return 1;
}

CMD:testsound(playerid, params[])
{
    if (PlayerData[playerid][pDeveloper] || IsGodAdmin(playerid))
    {
        new soundid;
        if (sscanf(params, "i", soundid))
        {
            SendClientMessage(playerid, COLOR_GREEN, "USAGE: /testsound [soundid]");
        }
        else
        {
            PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0);
        }
        return 1;
    }
    return 0;
}

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