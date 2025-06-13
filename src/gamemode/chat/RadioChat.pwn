/// @file      RadioChat.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


static VoiceType[MAX_PLAYERS];

enum
{
    VoiceType_Local,
    VoiceType_Radio,
    VoiceType_Faction,
    VoiceType_Gang,
    VoiceType_Global
};

CMD:r(playerid, params[])
{
    return callcmd::radio(playerid, params);
}

CMD:radio(playerid, params[])
{
    new factionid = PlayerData[playerid][pFaction];
    new factionrank = PlayerData[playerid][pFactionRank];

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(r)adio [faction radio]");
    }
    if (factionid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
    }
    if (PlayerData[playerid][pToggleRadio])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in your radio as you have it toggled.");
    }
    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /r if you're dead!");
    }
    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in /r while tied.");
    }
    foreach(new i : Player)
    {
        if (((PlayerData[i][pFaction] == factionid && !PlayerData[i][pToggleRadio]) || (PlayerData[i][pPoliceScanner] && PlayerData[i][pScannerOn] && IsEmergencyFaction(playerid))) && PlayerData[i][pLogged])
        {
            new color = (FactionInfo[factionid][fType] == FACTION_MEDIC) ? (COLOR_DOCTOR) : (COLOR_OLDSCHOOL);

            if (strlen(params) > MAX_SPLIT_LENGTH)
            {
                if (PlayerData[playerid][pDivision] == -1)
                {
                    SendClientMessageEx(i, color, "* %s %s: %.*s... *", FactionRanks[factionid][factionrank], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
                    SendClientMessageEx(i, color, "* %s %s: ...%s *", FactionRanks[factionid][factionrank], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
                }
                else
                {
                    SendClientMessageEx(i, color, "* [%s] %s %s: %.*s... *", FactionDivisions[factionid][PlayerData[playerid][pDivision]], FactionRanks[factionid][factionrank], GetRPName(playerid), MAX_SPLIT_LENGTH, params);
                    SendClientMessageEx(i, color, "* [%s] %s %s: ...%s *", FactionDivisions[factionid][PlayerData[playerid][pDivision]], FactionRanks[factionid][factionrank], GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
                }
            }
            else
            {
                if (PlayerData[playerid][pDivision] == -1)
                {
                    SendClientMessageEx(i, color, "* %s %s: %s *", FactionRanks[factionid][factionrank], GetRPName(playerid), params);
                }
                else
                {
                    SendClientMessageEx(i, color, "* [%s] %s %s: %s *", FactionDivisions[factionid][PlayerData[playerid][pDivision]], FactionRanks[factionid][factionrank], GetRPName(playerid), params);
                }
            }

            if ((PlayerData[i][pPoliceScanner] && PlayerData[i][pScannerOn]) && random(100) <= 3)
            {
                SendProximityMessage(i, 20.0, COLOR_PURPLE, "* %s's police scanner would shoot a spark and short out.", GetRPName(i));
                SendClientMessage(i, COLOR_GREY2, "Your police scanner shorted out and is now broken.");

                DBQuery("UPDATE "#TABLE_USERS" SET policescanner = 0, scanneron = 0 WHERE uid = %i", PlayerData[i][pID]);


                PlayerData[i][pPoliceScanner] = 0;
                PlayerData[i][pScannerOn] = 0;
            }
        }
    }

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "[Radio]: %s", params);

    return 1;
}


CMD:setfreq(playerid, params[])
{
    new channel;

    if (!PlayerData[playerid][pPrivateRadio])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a private radio.");
    }
    if (sscanf(params, "i", channel))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setfreq [freq]");
    }
    if (!(0 <= channel <= 99999))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The channel must range from 0 to 99999.");
    }

    PlayerData[playerid][pChannel] = channel;

    DBQuery("UPDATE "#TABLE_USERS" SET channel = %i WHERE uid = %i", channel, PlayerData[playerid][pID]);


    if (channel == 0)
    {
        SendClientMessage(playerid, COLOR_WHITE, "* You have set the channel to 0 and disabled your private radio.");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "* Channel set to %i Khz, use /pr to broadcast over this channel.", channel);
    }
    CallRemoteFunction("OnRadioFrequencyChanged", "ii", playerid, PlayerData[playerid][pChannel] );

    return 1;
}

CMD:voice(playerid, params[])
{
    new string[256];
    string = "Local voice chat\nRadio voice chat";

    if (PlayerData[playerid][pFaction] != -1)
        strcat(string, "\nFaction voice chat");

    if (PlayerData[playerid][pGang] != -1)
        strcat(string, "\nGang voice chat");

    if (GetAdminLevel(playerid) > 0)
        strcat(string, "\nGlobal voice chat");

    Dialog_Show(playerid, VoiceChat, DIALOG_STYLE_LIST, "Select the voice chat to use", string, "Choose", "Close");
    return 1;
}

Dialog:VoiceChat(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        new old = VoiceType[playerid];
        if (!strcmp(inputtext, "Global voice chat", true))
        {
            VoiceType[playerid] = VoiceType_Global;
        }
        else if (!strcmp(inputtext, "Gang voice chat", true))
        {
            VoiceType[playerid] = VoiceType_Gang;
        }
        else if (!strcmp(inputtext, "Faction voice chat", true))
        {
            VoiceType[playerid] = VoiceType_Faction;
        }
        else if (!strcmp(inputtext, "Radio voice chat", true))
        {
            VoiceType[playerid] = VoiceType_Radio;
        }
        else
        {
            VoiceType[playerid] = VoiceType_Local;
        }

        if (old != VoiceType[playerid])
            CallRemoteFunction("OnVoiceChatChanged", "iii", playerid, old, VoiceType[playerid]);
    }
    return 1;
}

publish GetRadioChannel(playerid)
{
    return PlayerData[playerid][pChannel];
}
