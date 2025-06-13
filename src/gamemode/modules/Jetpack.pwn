/// @file      Jetpack.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-04-12 14:01:13 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static PlayerJetpack[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    PlayerJetpack[playerid] = 0;
    return 1;
}

stock GivePlayerJetpack(playerid)
{
    PlayerJetpack[playerid] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    GameTextForPlayer(playerid, "~g~Jetpack", 3000, 3);
}

CMD:jetpackall(playerid, params[])
{
    if (IsGodAdmin(playerid))
    {
        foreach(new i : Player)
        {
            PlayerJetpack[i] = 1;
            SetPlayerSpecialAction(i, SPECIAL_ACTION_USEJETPACK);
            GameTextForPlayer(i, "~g~Jetpack", 3000, 3);
        }
    }
    return 1;
}

CMD:jetpack(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    PlayerJetpack[playerid] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    GameTextForPlayer(playerid, "~g~Jetpack", 3000, 3);

    switch (random(4))
    {
        case 0: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: The jetpack is part of an experiment conducted at the Area 69 facility.");
        case 1: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You stole this from Area 69 in that one single player mission. Remember?");
        case 2: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You probably don't need this anyway. All you admins seem to do is airbreak around the map.");
        case 3: SendClientMessage(playerid, COLOR_WHITE, "* Random Fact: You probably aren't reading this anyway. Fuck you.");
    }

    return 1;
}

hook OnPlayerAntiCheatCheck(playerid)
{
    // Jetpack
    if (!PlayerJetpack[playerid] && SPECIAL_ACTION_USEJETPACK == GetPlayerSpecialAction(playerid))
    {
        BanPlayer(playerid, "Jetpack");
        return 0;
    }
    return 1;
}
