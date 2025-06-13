/// @file      Sorciere.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-09-16 14:50:55 +0200
/// @copyright Copyright (c) 2022


CMD:sorciere(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_6))
    {
        Dialog_Show(playerid, Sorciere, DIALOG_STYLE_LIST, "Sorciere::PlayAll",
                    "Arabica\nBahi\nBye\nCookies\nCoucou\nDmortdm\nEvent\n"\
                    "Holol\nJaw\nJaw2\nNo\nOh\nOk\nOups\nSmile\nTdm\nWait",
                    "Select", "Cancel");
        return 1;
    }
    return 0;
}

CMD:testsorciere(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_6))
    {
        Dialog_Show(playerid, TestSorciere, DIALOG_STYLE_LIST, "Sorciere::Test",
                    "Arabica\nBahi\nBye\nCookies\nCoucou\nDm or tdm\nEvent\n"\
                    "Holol\nJaw\nJaw2\nNo\nOh\nOk\nOups\nSmile\nTdm\nWait",
                    "Select", "Cancel");
        return 1;
    }
    return 0;
}

GetSorciereSoundUrl(index)
{
    new result[128];
    result[0] = 0;
    switch (index)
    {
        case  0: format(result, sizeof(result), "http://%s/music/so/arabica.wav", GetServerWebsite());
        case  1: format(result, sizeof(result), "http://%s/music/so/bahi.wav",    GetServerWebsite());
        case  2: format(result, sizeof(result), "http://%s/music/so/bye.wav",     GetServerWebsite());
        case  3: format(result, sizeof(result), "http://%s/music/so/cookies.wav", GetServerWebsite());
        case  4: format(result, sizeof(result), "http://%s/music/so/coucou.wav",  GetServerWebsite());
        case  5: format(result, sizeof(result), "http://%s/music/so/dmortdm.wav", GetServerWebsite());
        case  6: format(result, sizeof(result), "http://%s/music/so/event.wav",   GetServerWebsite());
        case  7: format(result, sizeof(result), "http://%s/music/so/holol.wav",   GetServerWebsite());
        case  8: format(result, sizeof(result), "http://%s/music/so/jaw.wav",     GetServerWebsite());
        case  9: format(result, sizeof(result), "http://%s/music/so/jaw2.wav",    GetServerWebsite());
        case 10: format(result, sizeof(result), "http://%s/music/so/no.wav",      GetServerWebsite());
        case 11: format(result, sizeof(result), "http://%s/music/so/oh.wav",      GetServerWebsite());
        case 12: format(result, sizeof(result), "http://%s/music/so/ok.wav",      GetServerWebsite());
        case 13: format(result, sizeof(result), "http://%s/music/so/oups.wav",    GetServerWebsite());
        case 14: format(result, sizeof(result), "http://%s/music/so/smile.wav",   GetServerWebsite());
        case 15: format(result, sizeof(result), "http://%s/music/so/tdm.wav",     GetServerWebsite());
        case 16: format(result, sizeof(result), "http://%s/music/so/wait.wav",    GetServerWebsite());
    }
    return result;
}

Dialog:Sorciere(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new url[128];
        url = GetSorciereSoundUrl(listitem);
        if (!isnull(url))
        {
            foreach(new i : Player)
            {
                if (!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
                {
                    PlayAudioStreamForPlayer(i, url);
                    if (IsAdmin(i))
                    {
                        SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of a custom URL.", GetRPName(playerid));
                    }
                    SendClientMessageEx(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
                }
            }
        }
    }
    return 1;
}

Dialog:TestSorciere(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new url[128];
        url = GetSorciereSoundUrl(listitem);
        if (!isnull(url))
        {
            PlayAudioStreamForPlayer(playerid, url);
        }
    }
    return 1;
}
