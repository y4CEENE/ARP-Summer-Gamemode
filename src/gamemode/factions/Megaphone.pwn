/// @file      Megaphone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-05-25
/// @copyright Copyright (c) 2023

enum eMegaphoneSounds
{
    MS_SoundId,
    MS_Description[64]
};

static MegaphoneSounds[][eMegaphoneSounds] = {
    // SOUND ID , DESCRIPTION: Based on Rehasher megaphone filterscript
    { 9605,  "Give up. You're surrounded!"},
    { 9612,  "We know you're in there!"},
    { 10200, "Hey you! Police. Stop!"},
    { 15800, "This is the Los Santos Police Department; Stay where you are!"},
    { 15801, "Freeze! Or we will open fire"},
    { 15802, "Go! Go! Go!"},
    { 34402, "Police! Don't move!"},
    { 34403, "Get outta the car with your hands in the air!"},
    { 15825, "LSPD. Stop right... are you insane? You'll kill us all!"}
};

Dialog:MegaPhoneMsg(playerid, response, listitem, inputtext[])
{
    if (response && strlen(inputtext) > 0)
    {
        SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s %s:o< %s]",
            FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]],
            GetRPName(playerid), inputtext);
    }
    return 1;
}

Dialog:MegaphoneMenu(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Cancel");
    }
    if (listitem == 0)
    {
        Dialog_Show(playerid, MegaPhoneMsg, DIALOG_STYLE_INPUT, "Megaphone",
                    "Please enter the message you want to transmit:\n"\
                    "You can also use: /m [your message]", "Transmit", "Cancel");
    }
    else if (0 <= listitem - 1 < sizeof(MegaphoneSounds))
    {
        PlayNearbySound(playerid, MegaphoneSounds[listitem - 1][MS_SoundId]);
        SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s %s:o< %s]",
            FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]],
            GetRPName(playerid), MegaphoneSounds[listitem - 1][MS_Description]);
    }
    return 1;
}

CMD:m(playerid, params[])
{
    return callcmd::megaphone(playerid, params);
}

CMD:megaphone(playerid, params[])
{
    if (PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
    }
    if (FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your faction is not authorized to use the megaphone.");
    }
    if (isnull(params))
    {
        new str[1024];
        str = "{FF9900}Custom message{FFFFFF}";
        for (new i = 0; i < sizeof(MegaphoneSounds); i++)
        {
            format(str, sizeof(str), "%s\n%s", str, MegaphoneSounds[i][MS_Description]);
        }
        Dialog_Show(playerid, MegaphoneMenu, DIALOG_STYLE_LIST, "Megaphone", str, "Play", "Cancel");
        return 1;
    }

    SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s %s:o< %s]", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), params);
    return 1;
}

Dialog:HmMegaPhoneMsg(playerid, response, listitem, inputtext[])
{
    if (response && strlen(inputtext) > 0)
    {
        SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s:o< %s]", GetRPName(playerid), inputtext);
    }
    return 1;
}

Dialog:HmMegaphoneMenu(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Cancel");
    }
    if (listitem == 0)
    {
        Dialog_Show(playerid, HmMegaPhoneMsg, DIALOG_STYLE_INPUT, "Megaphone",
                    "Please enter the message you want to transmit:\n"\
                    "You can also use: /hm [your message]", "Transmit", "Cancel");
    }
    else if (0 <= listitem - 1 < sizeof(MegaphoneSounds))
    {
        PlayNearbySound(playerid, MegaphoneSounds[listitem - 1][MS_SoundId]);
        SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s:o< %s]", GetRPName(playerid), MegaphoneSounds[listitem - 1][MS_Description]);
    }
    return 1;
}

CMD:hm(playerid, params[])
{
    if (PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
    }
    if (isnull(params))
    {
        new str[1024];
        str = "{FF9900}Custom message{FFFFFF}";
        for (new i = 0; i < sizeof(MegaphoneSounds); i++)
        {
            format(str, sizeof(str), "%s\n%s", str, MegaphoneSounds[i][MS_Description]);
        }
        Dialog_Show(playerid, HmMegaphoneMenu, DIALOG_STYLE_LIST, "Megaphone", str, "Play", "Cancel");
        return 1;
    }

    SendProximityMessage(playerid, 50.0, COLOR_YELLOW, "[%s:o< %s]", GetRPName(playerid), params);
    return 1;
}
