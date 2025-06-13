/// @file      PlayerAccent.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-04-05 14:12:43 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerAccents [][16] = {
    "None",
    "Algeria",
    "Tunisia",
    "Egypt",
    "Bahrain",
    "Comoros",
    "Djibouti",
    "Iraq",
    "Jordan",
    "Kuwait",
    "Lebanon",
    "Libya",
    "Mauritania",
    "Morocco",
    "Oman",
    "Palestine",
    "Qatar",
    "Saudi",
    "Somalia",
    "Sudan",
    "Syria",
    "Emirates",
    "Yemen",
    "France",
    "Dutch",
    "English",
    "American",
    "British",
    "Chinese",
    "Korean",
    "Japanese",
    "Asian",
    "Canadian",
    "Russian",
    "Ukrainian",
    "German",
    "French",
    "Portuguese",
    "Polish",
    "Turkish",
    "Arabic",
    "Australian",
    "Southern",
    "Estonian",
    "Latvian",
    "Jamaican",
    "Mexican",
    "Spanish",
    "Romanian",
    "Italian",
    "Gangsta",
    "Greek",
    "Serbian",
    "Balkin",
    "Danish",
    "Scottish",
    "Irish",
    "Indian",
    "Norwegian",
    "Swedish",
    "Finnish",
    "Hungarian",
    "Bulgarian",
    "Pakistani",
    "Cuban",
    "Slavic",
    "Indonesian",
    "Filipino",
    "Hawaiian",
    "Somalian",
    "Armenian",
    "Persian",
    "Vietnamese",
    "Slovenian",
    "Kiwi",
    "Brazilian",
    "Georgian"
};

static _ListAccents[1024];

hook OnGameModeInit()
{
    _ListAccents[0] = 0;
    strcat(_ListAccents, PlayerAccents[0]);
    for (new i = 1 ; i < sizeof(PlayerAccents) ; i++)
        format(_ListAccents, sizeof(_ListAccents), "%s\n%s", _ListAccents, PlayerAccents[i]);
    return 1;
}

stock getAccentList()
{
    return _ListAccents;
}
stock getAccentName(accentid)
{
    return PlayerAccents[accentid];
}

CMD:customaccent(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "/customaccent [accent]");
    }
    strcpy(PlayerData[playerid][pAccent], params, 16);
    SendClientMessageEx(playerid, COLOR_WHITE, "You set your accent to '%s'.", PlayerData[playerid][pAccent]);

    DBQuery("UPDATE "#TABLE_USERS" SET accent = '%e' WHERE uid = %i", PlayerData[playerid][pAccent], PlayerData[playerid][pID]);


    return 1;
}

CMD:accent(playerid, params[])
{
    return Dialog_Show(playerid, ChangeAccent, DIALOG_STYLE_LIST, "Accent", getAccentList(), "Select", "<<");
}

Dialog:ChangeAccent(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        PlayerData[playerid][pAccent] = getAccentName(listitem);
        SendClientMessageEx(playerid, COLOR_WHITE, "You set your accent to '%s'.", PlayerData[playerid][pAccent]);

        DBQuery("UPDATE "#TABLE_USERS" SET accent = '%e' WHERE uid = %i", PlayerData[playerid][pAccent], PlayerData[playerid][pID]);

    }
    return 1;
}
