/// @file      Music.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


#define MAX_MP3_LINKS 100
#define MAX_VIP_LINKS 100

enum
{
    MUSIC_NONE,
    MUSIC_MP3PLAYER,
    MUSIC_BOOMBOX,
    MUSIC_VEHICLE
};

#include "modules/Sorciere.pwn"
#include <YSI\y_hooks>

enum MusicLink {
    MusicLink_Category[64],
    MusicLink_Name[64],
    MusicLink_Url[256],
    bool:MusicLink_Exist
};
static Mp3Links[MAX_MP3_LINKS][MusicLink];
static VipLinks[MAX_VIP_LINKS][MusicLink];
static IntroMusicUrl[256];
static GlobalMusicHostUrl[256];
static VipMusicHostUrl[256];

GetIntroMusicUrl()
{
    return IntroMusicUrl;
}

GetServerMusicUrl()
{
    return GlobalMusicHostUrl;
}

GetVipMusicUrl()
{
    return VipMusicHostUrl;
}

DestroyBoombox(playerid)
{
    if (PlayerData[playerid][pBoomboxPlaced])
    {
        DestroyDynamicObject(PlayerData[playerid][pBoomboxObject]);
        DestroyDynamic3DTextLabel(PlayerData[playerid][pBoomboxText]);

        PlayerData[playerid][pBoomboxObject] = INVALID_OBJECT_ID;
        PlayerData[playerid][pBoomboxText] = Text3D:INVALID_3DTEXT_ID;
        PlayerData[playerid][pBoomboxPlaced] = 0;
        PlayerData[playerid][pBoomboxURL] = 0;
    }
}

GetNearbyBoombox(playerid)
{
    foreach(new i : Player)
    {
        if (PlayerData[i][pBoomboxPlaced] && IsPlayerInRangeOfDynamicObject(playerid, PlayerData[i][pBoomboxObject], 30.0))
        {
            return i;
        }
    }

    return INVALID_PLAYER_ID;
}

stock ShowCreateRadioStation(playerid)
{
    Dialog_Show(playerid, DIALOG_ADDSTATION, DIALOG_STYLE_INPUT, "Radio Station Manager", "Enter the link of the station you'd like to add", "Add", "Cancel");
}

ShowMP3Player(playerid)
{
    Dialog_Show(playerid, MP3PLAYER, DIALOG_STYLE_LIST, "MP3 player", "Custom URL\nUploaded Music\nRadio Stations\nStop Music\nVIP Music", "Select", "Cancel");
}

ShowMP3RadioStations(playerid)
{
    Dialog_Show(playerid, MP3RADIO, DIALOG_STYLE_LIST, "Radio Stations", "Browse Genres\nSearch by Name", "Select", "Back");
}

ShowMP3RadioStationsGenres(playerid)
{

    DBFormat("SELECT DISTINCT genre FROM radiostations ORDER BY genre");
    DBExecute("RadioListGenres", "i", playerid);

}

/*ShowMP3RadioStationsSubGenres(playerid)
{
    for (new i = 0; i < sizeof(radioGenreList); i ++)
    {
        if (!strcmp(radioGenreList[i][rGenre], PlayerData[playerid][pGenre]))
        {
            format(string, sizeof(string), "%s\n%s", string, radioGenreList[i][rSubgenre]);
        }
    }

    Dialog_Show(playerid, MP3RADIOSUBGENRES, DIALOG_STYLE_LIST, "Choose a subgenre to browse stations in.", string, "Select", "Back");
}*/

ShowMP3RadioStationSearchResult(playerid)
{
    new page = (PlayerData[playerid][pPage] - 1) * MAX_LISTED_STATIONS;
    if (page < 0)
    {
        page = 0;
    }
    if (PlayerData[playerid][pSearch])
    {
        DBFormat("SELECT name FROM radiostations WHERE name LIKE '%%%e%%' OR subgenre LIKE '%%%e%%' ORDER BY name LIMIT %i, %i", PlayerData[playerid][pGenre], PlayerData[playerid][pGenre], page, MAX_LISTED_STATIONS);
        DBExecute("RadioListStations", "i", playerid);

    }
    else
    {
        DBFormat("SELECT name FROM radiostations WHERE genre = '%e' ORDER BY name LIMIT %i, %i", PlayerData[playerid][pGenre], page, MAX_LISTED_STATIONS);
        DBExecute("RadioListStations", "i", playerid);

    }
}

ShowMP3RadioStationSearch(playerid)
{
    Dialog_Show(playerid, MP3RADIOSEARCH, DIALOG_STYLE_INPUT, "Search by Name", "Enter the full or partial name of the radio station:", "Submit", "Back");
}

//ShowMP3RadioStationAPISearch(playerid)
//{
//    Dialog_Show(playerid, MP3APISEARCH, DIALOG_STYLE_INPUT, "Search by Name", "Enter the full or partial name of the radio station:", "Submit", "Back");
//}

Dialog:MP3PLAYER(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                Dialog_Show(playerid, MP3URL, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to play:", "Submit", "Back");
            }
            case 1:
            {
                Dialog_Show(playerid, MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
            }
            case 2:
            {
                if (!IsDBConnected())
                {
                    return SendClientMessage(playerid, COLOR_GREY, "The radio station database is currently unavailable.");
                }

                ShowMP3RadioStations(playerid);
            }
             case 3:
              {
                switch (PlayerData[playerid][pMusicType])
                {
                    case MUSIC_MP3PLAYER:
                    {
                        SetMusicStream(MUSIC_MP3PLAYER, playerid, "");
                        ShowActionBubble(playerid, "* %s turns off their MP3 player.", GetRPName(playerid));
                    }
                    case MUSIC_BOOMBOX:
                    {
                        SetMusicStream(MUSIC_BOOMBOX, playerid, "");
                        ShowActionBubble(playerid, "* %s turns off their boombox.", GetRPName(playerid));
                    }
                    case MUSIC_VEHICLE:
                    {
                        if (IsPlayerInAnyVehicle(playerid))
                        {
                            SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), "");
                            ShowActionBubble(playerid, "* %s turns off the radio in the vehicle.", GetRPName(playerid));
                        }
                    }
                }
            }
            case 4:
            {
                 if (PlayerData[playerid][pDonator] < 1)
                 {
                     return SendClientMessage(playerid, COLOR_GREY, "You must be a VIP to use this option");
                 }
                 Dialog_Show(playerid, DIALOG_VIPMUSIC, DIALOG_STYLE_INPUT, "VIP Uploaded Music", "Please enter the name of the .mp3 file to play:", "Submit", "Back");
            }
        }
    }
    return 1;
}
Dialog:MP3MUSIC(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new url[128];

        if (isnull(inputtext) || strfind(inputtext, ".mp3", true) == -1)
        {
            return Dialog_Show(playerid, MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
        }

        for (new i = 0, l = strlen(inputtext); i < l; i ++)
        {
            switch (inputtext[i])
            {
                case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '\'', ' ':
                {
                    continue;
                }
                default:
                {
                    SendClientMessage(playerid, COLOR_GREY, "The name of the .mp3 contains invalid characters, please try again.");
                    return Dialog_Show(playerid, MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
                }
            }
        }

        format(url, sizeof(url), "http://%s/%s", GetServerMusicUrl(), inputtext);

        switch (PlayerData[playerid][pMusicType])
        {
            case MUSIC_MP3PLAYER:
            {
                SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
                ShowActionBubble(playerid, "* %s changes the song on their MP3 player.", GetRPName(playerid));
            }
            case MUSIC_BOOMBOX:
            {
                SetMusicStream(MUSIC_BOOMBOX, playerid, url);
                ShowActionBubble(playerid, "* %s changes the song on their boombox.", GetRPName(playerid));
            }
            case MUSIC_VEHICLE:
            {
                if (IsPlayerInAnyVehicle(playerid))
                {
                    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
                    ShowActionBubble(playerid, "* %s changes the song on the radio.", GetRPName(playerid));
                }
            }
        }

        SendClientMessageEx(playerid, COLOR_AQUA, "You have started the playback of {00AA00}%s{33CCFF}.", inputtext);
    }
    else
    {
        ShowMP3Player(playerid);
    }
    return 1;
}
Dialog:DIALOG_VIPMUSIC(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new url[128];

        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, DIALOG_VIPMUSIC, DIALOG_STYLE_INPUT, "VIP Uploaded Music", "Please enter the name of the .mp3 file to play:", "Submit", "Back");
        }

        for (new i = 0, l = strlen(inputtext); i < l; i ++)
        {
            switch (inputtext[i])
            {
                case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '\'', ' ':
                {
                    continue;
                }
                default:
                {
                    SendClientMessage(playerid, COLOR_GREY, "The name of the .mp3 contains invalid characters, please try again.");
                    return Dialog_Show(playerid, DIALOG_VIPMUSIC, DIALOG_STYLE_INPUT, "VIP Uploaded Music", "Please enter the name of the .mp3 file to play:", "Submit", "Back");
                }
            }
        }

        format(url, sizeof(url), "http://%s/%d/%s", GetVipMusicUrl(), PlayerData[playerid][pID], inputtext);
        switch (PlayerData[playerid][pMusicType])
        {
            case MUSIC_MP3PLAYER:
            {
                SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
                ShowActionBubble(playerid, "* %s changes the song on their MP3 player.", GetRPName(playerid));
            }
            case MUSIC_BOOMBOX:
            {
                SetMusicStream(MUSIC_BOOMBOX, playerid, url);
                ShowActionBubble(playerid, "* %s changes the song on their boombox.", GetRPName(playerid));
            }
            case MUSIC_VEHICLE:
            {
                if (IsPlayerInAnyVehicle(playerid))
                {
                    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
                    ShowActionBubble(playerid, "* %s changes the song on the radio.", GetRPName(playerid));
                }
            }
        }

        SendClientMessageEx(playerid, COLOR_AQUA, "You have started the playback of {00AA00}%s{33CCFF}.", inputtext);
    }
    else
    {
        ShowMP3Player(playerid);
    }
    return 1;
}
Dialog:MP3URL(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, MP3URL, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to play:", "Submit", "Back");
        }
        if (strfind(inputtext, ".mp3", true) == -1)
        {
            return Dialog_Show(playerid, MP3URL, DIALOG_STYLE_INPUT, "Custom URL", ".MP3 Links only! Please enter another URL", "Submit", "Back");
        }

        switch (PlayerData[playerid][pMusicType])
        {
            case MUSIC_MP3PLAYER:
            {
                SetMusicStream(MUSIC_MP3PLAYER, playerid, inputtext);
                ShowActionBubble(playerid, "* %s changes the song on their MP3 player.", GetRPName(playerid));
            }
            case MUSIC_BOOMBOX:
            {
                SetMusicStream(MUSIC_BOOMBOX, playerid, inputtext);
                ShowActionBubble(playerid, "* %s changes the song on their boombox.", GetRPName(playerid));
            }
            case MUSIC_VEHICLE:
            {
                if (IsPlayerInAnyVehicle(playerid))
                {
                    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), inputtext);
                    ShowActionBubble(playerid, "* %s changes the song on the radio.", GetRPName(playerid));
                }
            }
        }
    }
    else
    {
        ShowMP3Player(playerid);
    }
    return 1;
}
Dialog:MP3RADIO(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                ShowMP3RadioStationsGenres(playerid);
            }
            case 1:
            {
                ShowMP3RadioStationSearch(playerid);
            }
            //case 2:
            //{
            //    ShowMP3RadioStationAPISearch(playerid);
            //}
        }
    }
    else
    {
        ShowMP3Player(playerid);
    }
    return 1;
}
Dialog:MP3RADIOGENRES(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        strcpy(PlayerData[playerid][pGenre], inputtext, 32);
        PlayerData[playerid][pPage] = 1;
        ShowMP3RadioStationSearchResult(playerid);
        //ShowMP3RadioStationsSubGenres(playerid);
    }
    else
    {
        ShowMP3RadioStations(playerid);
    }
    return 1;
}
/*Dialog:MP3RADIOSUBGENRES(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        PlayerData[playerid][pPage] = 1;
        PlayerData[playerid][pSearch] = 0;

        strcpy(PlayerData[playerid][pSubgenre], inputtext, 32);
        if (!PlayerData[playerid][pStationEdit])
        {
            ShowMP3RadioStationSearchResult(playerid);
        }
        else
        {

            ShowDialogToPlayer(playerid, DIALOG_ADDSTATION);
        }
    }
    else
    {
        ShowMP3RadioStationsGenres(playerid);
    }
    return 1;
}*/
Dialog:MP3RADIORESULTS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!strcmp(inputtext, ">> Next page", true))
        {
            PlayerData[playerid][pPage]++;
            ShowMP3RadioStationSearchResult(playerid);
        }
        else if (!strcmp(inputtext, "<< Go back", true) && PlayerData[playerid][pPage] > 1)
        {
            PlayerData[playerid][pPage]--;
            ShowMP3RadioStationSearchResult(playerid);
        }
        else
        {
            listitem = ((PlayerData[playerid][pPage] - 1) * MAX_LISTED_STATIONS) + listitem;
            if (listitem < 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Cannot find radio signal.");
            }
            if (PlayerData[playerid][pSearch])
            {
                DBFormat("SELECT name, url FROM radiostations WHERE name LIKE '%%%e%%' OR subgenre LIKE '%%%e%%' ORDER BY name LIMIT %i, 1", PlayerData[playerid][pGenre], PlayerData[playerid][pGenre], listitem);
                DBExecute("RadioPlayStation", "i", playerid);

            }
            else
            {
                DBFormat("SELECT name, url FROM radiostations WHERE genre = '%e' ORDER BY name LIMIT %i, 1", PlayerData[playerid][pGenre], listitem);
                DBExecute("RadioPlayStation", "i", playerid);

            }
        }
    }
    else
    {
        if (PlayerData[playerid][pSearch])
        {
            ShowMP3RadioStationSearch(playerid);
        }
        else
        {
            //ShowMP3RadioStationsSubGenres(playerid);
            ShowMP3RadioStationsGenres(playerid);
        }
    }
    return 1;
}
Dialog:MP3RADIOSEARCH(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (strlen(inputtext) < 3)
        {
            SendClientMessage(playerid, COLOR_GREY, "Your search query must contain 3 characters or more.");
            ShowMP3RadioStationSearch(playerid);
            return 1;
        }

        PlayerData[playerid][pPage] = 1;
        PlayerData[playerid][pSearch] = 1;

        strcpy(PlayerData[playerid][pGenre], inputtext, 32);
        ShowMP3RadioStationSearchResult(playerid);
    }
    else
    {
        ShowMP3RadioStations(playerid);
    }
    return 1;
}

DB:RadioListGenres(playerid)
{
    new rows = GetDBNumRows();

    if ((!rows) && PlayerData[playerid][pSearch] && PlayerData[playerid][pPage] == 1)
    {
        SendClientMessage(playerid, COLOR_GREY, "No results found.");
        ShowMP3RadioStationSearch(playerid);
    }
    else if (rows)
    {
        new string[4096];
        new genre[32] = "n/a";


        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "genre", genre);
            strcat(string, genre);
            strcat(string, "\n");
        }

        Dialog_Show(playerid, MP3RADIOGENRES, DIALOG_STYLE_LIST, "Choose a genre to browse stations in.", string, "Select", "Back");
    }

}

DB:RadioListStations(playerid)
{
    new rows = GetDBNumRows();

    if ((!rows) && PlayerData[playerid][pSearch] && PlayerData[playerid][pPage] == 1)
    {
        SendClientMessage(playerid, COLOR_GREY, "No results found.");
        ShowMP3RadioStationSearch(playerid);
    }
    else if (rows)
    {
        static string[MAX_LISTED_STATIONS * 64], name[128];

        string[0] = 0;

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "name", name);
            if (i)
                format(string, sizeof(string), "%s\n%s", string, name);
            else
                format(string, sizeof(string), "%s", name);
        }

        if (PlayerData[playerid][pPage] > 1)
        {
            strcat(string, "\n{FF6347}<< Go back{FFFFFF}");
        }
        if (rows == MAX_LISTED_STATIONS)
        {
            strcat(string, "\n{00AA00}>> Next page{FFFFFF}");
        }

        Dialog_Show(playerid, MP3RADIORESULTS, DIALOG_STYLE_LIST, "Results", string, "Play", "Back");
    }
}


DB:RadioPlayStation(playerid)
{
    if (GetDBNumRows())
    {
        new name[128], url[128];

        GetDBStringField(0, "name", name);
        GetDBStringField(0, "url", url);

        switch (PlayerData[playerid][pMusicType])
        {
            case MUSIC_MP3PLAYER:
            {
                ShowActionBubble(playerid, "* %s changes the radio station on their MP3 player.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "You are now tuned in to {00AA00}%s{33CCFF}.", name);
                SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
            }
            case MUSIC_BOOMBOX:
            {
                ShowActionBubble(playerid, "* %s changes the radio station on their boombox.", GetRPName(playerid));
                SendClientMessageEx(playerid, COLOR_AQUA, "Your boombox is now tuned in to {00AA00}%s{33CCFF}.", name);
                SetMusicStream(MUSIC_BOOMBOX, playerid, url);
            }
            case MUSIC_VEHICLE:
            {
                if (IsPlayerInAnyVehicle(playerid))
                {
                    ShowActionBubble(playerid, "* %s changes the radio station in their vehicle.", GetRPName(playerid));
                    SendClientMessageEx(playerid, COLOR_AQUA, "Your radio is now tuned in to {00AA00}%s{33CCFF}.", name);
                    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
                }
            }
        }
    }
}

CMD:boombox(playerid, params[])
{
    new option[10], param[128];
    if (!PlayerData[playerid][pBoombox])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no boombox and therefore can't use this command.");
    }
    if (sscanf(params, "s[10]S()[128]", option, param))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /boombox [place | pickup | play]");
    }
    if (IsPlayerInEvent(playerid) || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
    }

    if (!strcmp(option, "place", true))
    {
        if (PlayerData[playerid][pBoomboxPlaced])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have placed down a boombox already.");
        }
        if (GetNearbyBoombox(playerid) != INVALID_PLAYER_ID)
        {
            return SendClientMessage(playerid, COLOR_GREY, "There is already a boombox nearby. Place this one somewhere else.");
        }

        new
            Float:x,
            Float:y,
            Float:z,
            Float:a,
            string[128];

        format(string, sizeof(string), "{FFFF00}Boombox placed by:\n{FF0000}%s{FFFF00}\n/boombox for more options.", GetPlayerNameEx(playerid));

        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        PlayerData[playerid][pBoomboxPlaced] = 1;
        PlayerData[playerid][pBoomboxObject] = CreateDynamicObject(2102, x, y, z - 1.0, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        PlayerData[playerid][pBoomboxText] = CreateDynamic3DTextLabel(string, COLOR_LIGHTORANGE, x, y, z - 0.8, 10.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid));
        PlayerData[playerid][pBoomboxURL] = 0;

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        ShowActionBubble(playerid, "* %s places a boombox on the ground.", GetRPName(playerid));
    }
    else if (!strcmp(option, "pickup", true))
    {
        if (!PlayerData[playerid][pBoomboxPlaced])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have not placed down a boombox.");
        }
        if (!IsPlayerInRangeOfDynamicObject(playerid, PlayerData[playerid][pBoomboxObject], 3.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your boombox.");
        }

        ShowActionBubble(playerid, "* %s picks up their boombox and switches it off.", GetRPName(playerid));
        DestroyBoombox(playerid);
    }
    else if (!strcmp(option, "play", true))
    {
        if (!PlayerData[playerid][pBoomboxPlaced])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have not placed down a boombox.");
        }
        if (!IsPlayerInRangeOfDynamicObject(playerid, PlayerData[playerid][pBoomboxObject], 3.0))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your boombox.");
        }

        PlayerData[playerid][pMusicType] = MUSIC_BOOMBOX;
        ShowMP3Player(playerid);
    }

    return 1;
}

CMD:mp3(playerid, params[])
{
    if (!PlayerData[playerid][pMP3Player])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have an MP3 player.");
    }

    PlayerData[playerid][pMusicType] = MUSIC_MP3PLAYER;
    ShowMP3Player(playerid);
    return 1;
}

CMD:setradio(playerid, params[])
{
    if (!IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any vehicle.");
    }

    PlayerData[playerid][pMusicType] = MUSIC_VEHICLE;
    ShowMP3Player(playerid);
    return 1;
}

PlayLoginMusic(playerid)
{
    PlayAudioStreamForPlayer(playerid, "https://c.top4top.io/m_3383tx41b1.mp3");
    return 1;
}

Dialog:DIALOG_ADDSTATION(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new name;
        DBQuery("INSERT INTO radiostations VALUES ('%e', '%e', '%e', '%e')", name, inputtext, PlayerData[playerid][pSubgenre], PlayerData[playerid][pGenre]);
        PlayerData[playerid][pStationEdit] = 0;
    }
    return 1;
}

publish HTTP_OnMusicFetchResponse(index, response_code, data[])
{
    if (response_code == 200)
    {
        new
            buffer[2048],
            string[288],
            count,
            start,
            pos;

        strcpy(buffer, data);

        while ((pos = strfind(buffer, "<br/>")) != -1)
        {
            strdel(buffer, pos, pos + 5);

            if (++count == 8)
            {
                strmid(string, buffer, start, pos);
                SendClientMessage(index, COLOR_YELLOW, string);

                start = pos;
                count = 0;
            }
            else
            {
                if ((strlen(buffer) - pos) < 6)
                {
                    strmid(string, buffer, start, pos);
                    SendClientMessage(index, COLOR_YELLOW, string);
                    break;
                }

                strins(buffer, ", ", pos);
            }
        }
    }
    else
    {
        SendClientMessageEx(index, COLOR_RED, "The music database is currently not available. (error %i)", response_code);
    }
}

SetMusicStream(type, extraid, url[])
{
    switch (type)
    {
        case MUSIC_MP3PLAYER:
        {
            if (isnull(url) && PlayerData[extraid][pStreamType] == type)
            {
                StopAudioStreamForPlayer(extraid);
                PlayerData[extraid][pStreamType] = MUSIC_NONE;
            }
            else
            {
                PlayAudioStreamForPlayer(extraid, url);
                PlayerData[extraid][pStreamType] = type;
            }
        }
        case MUSIC_BOOMBOX:
        {
            foreach(new i : Player)
            {
                if (PlayerData[i][pBoomboxListen] == extraid)
                {
                    if (isnull(url) && PlayerData[i][pStreamType] == type)
                    {
                        StopAudioStreamForPlayer(i);
                        PlayerData[i][pStreamType] = MUSIC_NONE;
                    }
                    else if (PlayerData[i][pStreamType] == MUSIC_NONE || PlayerData[i][pStreamType] == MUSIC_BOOMBOX)
                    {
                        PlayAudioStreamForPlayer(i, url);
                        PlayerData[i][pStreamType] = type;
                    }
                }
            }

            strcpy(PlayerData[extraid][pBoomboxURL], url, 128);
        }
        case MUSIC_VEHICLE:
        {
            foreach(new i : Player)
            {
                if (IsPlayerInVehicle(i, extraid))
                {
                    if (isnull(url) && PlayerData[i][pStreamType] == type)
                    {
                        StopAudioStreamForPlayer(i);
                        PlayerData[i][pStreamType] = MUSIC_NONE;
                    }
                    else if (PlayerData[i][pStreamType] == MUSIC_NONE || PlayerData[i][pStreamType] == MUSIC_VEHICLE)
                    {
                        PlayAudioStreamForPlayer(i, url);
                        PlayerData[i][pStreamType] = type;
                    }
                }
            }

            strcpy(vehicleStream[extraid], url, 128);
        }
    }
}


CMD:adestroyboombox(playerid, params[])
{
    new boomboxid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if ((boomboxid = GetNearbyBoombox(playerid)) == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no boombox in range.");
    }

    SendClientMessageEx(playerid, COLOR_AQUA, "You have destroyed {00AA00}%s{33CCFF}'s boombox.", GetRPName(boomboxid));
    DestroyBoombox(boomboxid);

    return 1;
}

CMD:vipmusic(playerid, params[])
{
    if (PlayerData[playerid][pDonator] < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be a donator to use this command!");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vipmusic [songname.mp3]");
    }
    if (gettime() - gLastMusic < 300)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Music can only be played globally every 5 minutes.");
    }
    new url[144];
    format(url, sizeof(url), "http://%s/%i/%s", GetVipMusicUrl(), PlayerData[playerid][pID], params);
    foreach(new i : Player)
    {
        if (!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
        {
            PlayAudioStreamForPlayer(i, url);
        }
    }
    SendClientMessageToAllEx(COLOR_VIP, "VIP Music: %s VIP %s has started the global playback of %s from their music folder!", GetVIPRank(PlayerData[playerid][pDonator]), GetRPName(playerid), params);
    gLastMusic = gettime();
    return 1;
}

CMD:music(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "_____________________ List of Music _____________________");
    HTTP(playerid, HTTP_GET, GetServerMusicUrl(), "", "HTTP_OnMusicFetchResponse");
    return 1;
}

CMD:stopmusic(playerid, params[])
{
    SendClientMessage(playerid, COLOR_YELLOW, "You have stopped all active audio streams playing for yourself.");
    PlayerData[playerid][pStreamType] = MUSIC_NONE;
    StopAudioStreamForPlayer(playerid);
    return 1;
}

CMD:gplay(playerid, params[])
{
    new url[144];

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gplay [songfolder/name.mp3]");
    }

    format(url, sizeof(url), "http://%s/%s", GetServerMusicUrl(), params);

    foreach(new i : Player)
    {
        if (!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
        {
            PlayAudioStreamForPlayer(i, url);
            SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of %s.", GetRPName(playerid), params);
            SendClientMessageEx(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
        }
    }

    return 1;
}

CMD:gplayurl(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_5) && !PlayerData[playerid][pDJ])
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gplayurl [link]");
    }
    if (strfind(params, ".php", true) != -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "No .php links allowed!");
    }
    foreach(new i : Player)
    {
        if (!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
        {
            PlayAudioStreamForPlayer(i, params);
            SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has started the global playback of a custom URL.", GetRPName(playerid));
            SendClientMessageEx(i, COLOR_YELLOW, "Use /stopmusic to stop playback and '/toggle streams' to disable global playback.");
        }
    }
    return 1;
}
CMD:gstop(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_5) && !PlayerData[playerid][pDJ])
    {
        return SendUnauthorized(playerid);
    }

    foreach(new i: Player)
    {
        if (!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
        {
            StopAudioStreamForPlayer(i);
            SendClientMessageEx(i, COLOR_LIGHTRED, "AdmCmd: %s has stopped all active audio streams.", GetRPName(playerid));
        }
    }

    return 1;
}
CMD:makedj(playerid, params[])
{
    new targetid, rank;
    if (!IsAdmin(playerid, ADMIN_LVL_5) && PlayerData[playerid][pDJ] != 2)
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "dd", targetid, rank))
    {
        SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /makedj [playerid] [rank]");
        SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} 0 = None, 1 = DJ, 2 = Leader DJ");
    }
    if (!(0 <= rank <= 3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank specified.");
    }
    if (PlayerData[targetid][pLogged])
    {
        if (rank == 0)
        {
            (playerid, COLOR_AQUA, "You've removed %s's DJ rank", GetRPName(targetid));
            SendClientMessageEx(targetid, COLOR_AQUA, "Your DJ rank was removed by %s", GetRPName(playerid));
            PlayerData[targetid][pDJ] = 0;
            DBQuery("UPDATE "#TABLE_USERS" SET dj = %i WHERE uid = %i", PlayerData[targetid][pDJ], PlayerData[targetid][pID]);

        }
        else
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have made %s a rank %d DJ", GetRPName(targetid), rank);
            SendClientMessageEx(targetid, COLOR_AQUA, "You have been made rank %d DJ by %s", rank, GetRPName(playerid));
            PlayerData[targetid][pDJ] = rank;
            DBQuery("UPDATE "#TABLE_USERS" SET dj = %i WHERE uid = %i", PlayerData[targetid][pDJ], PlayerData[targetid][pID]);

        }
    }
    return 1;
}

stock PlayBoombox(playerid, boomboxid)
{
    if (PlayerData[playerid][pStreamType] == MUSIC_NONE)
    {
        PlayerData[playerid][pBoomboxListen] = boomboxid;
        PlayerData[playerid][pStreamType] = MUSIC_BOOMBOX;
        PlayAudioStreamForPlayer(playerid, PlayerData[boomboxid][pBoomboxURL]);
    }
    return 1;
}

stock StopBoombox(playerid)
{
    if (PlayerData[playerid][pStreamType] == MUSIC_BOOMBOX)
    {
        PlayerData[playerid][pBoomboxListen] = INVALID_PLAYER_ID;
        PlayerData[playerid][pStreamType] = MUSIC_NONE;
        StopAudioStreamForPlayer(playerid);
    }
    return 1;
}

hook OnLoadGameMode(timestamp)
{
    new Node:music;
    new error = GetServerConfig("music", music);
    if (error != 0)
    {
        err("Missing valid 'music' object in server config", _i("error", error));
    }
    else
    {
        new Node:mp3;
        new Node:vip;
        new length;
        if (JSON_GetString(music, "intro", IntroMusicUrl))
        {
            err("Missing valid 'intro' url in 'music'");
        }
        if (JSON_GetString(music, "global_server", GlobalMusicHostUrl))
        {
            err("Missing valid 'global_server' url in 'music'");
        }
        if (JSON_GetString(music, "vip_server", VipMusicHostUrl))
        {
            err("Missing valid 'vip_server' url in 'music'");
        }
        if (!JSON_GetArray(music, "mp3", mp3))
        {
            JSON_ArrayLength(mp3, length);
            for (new i = 0; i < length && i < MAX_MP3_LINKS; i++)
            {
                new Node:item;
                if (JSON_ArrayObject(mp3, i, item))
                {
                    err("Invalid object in mp3 music", _i("index", i));
                }
                else  if (JSON_GetString(item, "category", Mp3Links[i][MusicLink_Category]))
                {
                    err("Missing valid category for mp3 music", _i("index", i));
                }
                else if (JSON_GetString(item, "name", Mp3Links[i][MusicLink_Name]))
                {
                    err("Missing valid name for mp3 music", _i("index", i));
                }
                else if (JSON_GetString(item, "url", Mp3Links[i][MusicLink_Url]))
                {
                    err("Missing valid url for mp3 music", _i("index", i));
                }
                else
                {
                    Mp3Links[i][MusicLink_Exist] = true;
                }
            }
            if (MAX_MP3_LINKS < length)
            {
                err("Max mp3 links reached", _i("MAX_MP3_LINKS", MAX_MP3_LINKS), _i("length", length));
            }
        }
        if (!JSON_GetArray(music, "vip", vip))
        {
            JSON_ArrayLength(vip, length);
            for (new i = 0; i < length && i < MAX_VIP_LINKS; i++)
            {
                new Node:item;
                if (JSON_ArrayObject(vip, i, item))
                {
                    err("Invalid object in mp3 music", _i("index", i));
                }
                else if (JSON_GetString(item, "category", VipLinks[i][MusicLink_Category]))
                {
                    err("Missing valid category for vip music", _i("index", i));
                }
                else if (JSON_GetString(item, "name", VipLinks[i][MusicLink_Name]))
                {
                    err("Missing valid name for vip music", _i("index", i));
                }
                else if (JSON_GetString(item, "url", VipLinks[i][MusicLink_Url]))
                {
                    err("Missing valid url for vip music", _i("index", i));
                }
                else
                {
                    VipLinks[i][MusicLink_Exist] = true;
                }
            }
            if (MAX_VIP_LINKS < length)
            {
                err("Max vip links reached", _i("MAX_VIP_LINKS", MAX_VIP_LINKS), _i("length", length));
            }
        }
    }
}

hook OnPlayerHeartBeat(playerid)
{
    if (PlayerData[playerid][pToggleMusic])
    {
        return StopBoombox(playerid);
    }

    new boomboxid = GetNearbyBoombox(playerid);

    if (boomboxid == INVALID_PLAYER_ID)
    {
        return StopBoombox(playerid);
    }

    if (PlayerData[playerid][pBoomboxListen] == boomboxid)
    {
        return 1;
    }
    StopBoombox(playerid);
    PlayBoombox(playerid, boomboxid);
    return 1;
}

hook OnPlayerInit(playerid)
{
    PlayerData[playerid][pBoomboxPlaced] = 0;
    PlayerData[playerid][pBoomboxObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pBoomboxListen] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid)
{
    if (PlayerData[playerid][pBoomboxPlaced])
    {
        DestroyBoombox(playerid);
    }
}
