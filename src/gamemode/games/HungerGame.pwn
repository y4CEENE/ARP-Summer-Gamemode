/// @file      HungerGame.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-12-29 17:19:07 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define HUNGER_GAME_CASH_REWARD 20000
#define HUNGER_GAME_EVENT_TOKEN 0x8DA67E3A4
#define HUNGER_GAME_EVENT_START 3 // Calculated in minutes you have to change it (1 = 1 minute)

enum eHungerGameState
{
    HungerGameState_Configuration,
    HungerGameState_Published,
    HungerGameState_Started,
};

static eHungerGameState:HungerGameState = HungerGameState_Configuration;
static bool:InHungerGame[MAX_PLAYERS];
static HungerGamePlayers = 0;
static HungerGameBoxes[][ePos]


hook OnPlayerInit(playerid)
{
    InHungerGame[playerid] = false;
	return 1;
}

CMD:hgloot(playerid, params[])
{
    if (!InHungerGame[playerid])
    {
        return 0;
    }

    return 1;
}

CMD:hungergame(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /hungergame [create/cancel/goto]");
    }

    if (!strcmp(params, "cancel", true))
    {
        if(HungerGameState == HungerGameState_Configuration)
        {
            return SendErrorMessage(playerid, "There is no active hungergame event");
        }

        foreach (new i : Player)
        {
            if (InHungerGame[i])
            {
                InHungerGame[i] = false;
                DeletePVar(i, "EventToken");
                SetPlayerWeapons(i);
                SetPlayerToSpawn(i);
            }
        }
        HungerGamePlayers = 0;
        HungerGameState = HungerGameState_Configuration;
        SendClientMessageToAllEx(COLOR_RED, "%s has canceled the Hunger Game Event.", GetPlayerNameEx(playerid));
    }
    else if (!strcmp(params, "create", true))
    {

        if(HungerGameState == HungerGameState_Published)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't start another Hunger Game Event!");
        }

        if(HungerGameState == HungerGameState_Started)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The Hunger Game Event has already started!");
        }

        HungerGamePlayers = 0;
        HungerGameState = HungerGameState_Published;
        defer HungerGameAutoStart();
        SendClientMessageToAllEx(COLOR_GREEN, "The Hunger Game event is about to start in %d minute(s), join it by typing '/joinhungergame'", HUNGER_GAME_EVENT_START);
    }
    else if (!strcmp(params, "goto", true))
    {
        TeleportToCoords(playerid, 2199.84, 100.41, 86.25, 0.0, 0, 5000, true, false);
    }
    return 1;
}

timer HungerGameAutoStart[60000 * HUNGER_GAME_EVENT_START]()
{
    if(HungerGamePlayers < HUNGER_GAME_MINIMUM_PLAYERS)
    {
        foreach (new i : Player)
        {
            if (InHungerGame[i])
            {
                InHungerGame[i] = false;
                DeletePVar(i, "EventToken");
                SetPlayerWeapons(i);
                SetPlayerToSpawn(i);
            }
        }
        HungerGamePlayers = 0;
        HungerGameState = HungerGameState_Configuration;
        SendClientMessageToAll(COLOR_RED, "Sadly there were not enough players to start the Hunger Game Event :(");
    }
    else
    {
        HungerGameState = HungerGameState_Started;
        SendClientMessageToAll(COLOR_AQUA, "The Hunger Game Event has been started!");
    }
}

CMD:joingame(playerid, params[])
{
    if (PlayerData[playerid][pLevel] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only level 3+ can join events.");
    }

    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't do that at this moment!");

    }
    if(HungerGameState == HungerGameState_Started)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The Hunger Game event has already started, you can't join it now!");
    }

    if(HungerGameState != HungerGameState_Published)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There's no active Hunger Game Event!");
    }

    if(InHungerGame[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't join this, you're already in the event!");
    }

    AddPlayerToHungerGame(playerid);
    return 1;
}

stock AddPlayerToHungerGame(playerid)
{
    SavePlayerVariables(playerid);
    ResetPlayerWeapons(playerid);
    SetPVarInt(playerid, "EventToken", HUNGER_GAME_EVENT_TOKEN);

    HungerGamePlayers++; //Increase the players in the event
    InHungerGame[playerid] = true; //The player is now a hunger game Partecipant

    TeleportToCoords(playerid, 1473.2000, 1341.0000, 861.0000, 0.0, 0, 5000, true, false);
    SendClientMessage(playerid, COLOR_AQUA, "You have joined the hunger games as a participant. Please wait until the timer.");
}

hook OnPlayerHeartBeat(playerid)
{
    if (!InHungerGame[playerid])
    {
        return 1;
    }

    if(HungerGameState == HungerGameState_Started && HungerGamePlayers == 1) //Checking if there's 1 player remaining
    {
        HungerGamePlayers = 0;
        InHungerGame[playerid] = false;
        DeletePVar(playerid, "EventToken");
        HungerGameState = HungerGameState_Configuration;
        SetPlayerWeapons(playerid);
        SetPlayerToSpawn(playerid);

        GivePlayerCash(playerid, HUNGER_GAME_CASH_REWARD);
        SendClientMessageToAllEx(COLOR_AQUA, "Congratulations to %s for winning a round of Hunger Games!", GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You win %s as a hunger game event reward!", FormatCash(HUNGER_GAME_CASH_REWARD));
    }
    else if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1957.14, 1342.81, 15.37))
    {
        HungerGamePlayers--;
        InHungerGame[playerid] = false;
        DeletePVar(playerid, "EventToken");
        SetPlayerWeapons(playerid);
        SetPlayerToSpawn(playerid);
        SendClientMessage(playerid, COLOR_GREY, "You have been removed as a participant of hunger games for leaving out boundaries.");
        SendClientMessageToAllEx(COLOR_RED, "%s has been eliminated from the Hunger Game Event, Players Remaining: %d",
                                 GetPlayerNameEx(playerid), HungerGamePlayers);
    }
	return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken != HUNGER_GAME_EVENT_TOKEN)
    {
        return 1;
    }
    if(PlayerFallout[playerid])
    {
        FalloutPlayers--;
        PlayerFallout[playerid] = false;
        DeletePVar(playerid, "EventToken");
        SetPlayerWeapons(playerid);
        SetPlayerToSpawn(playerid);
        SendClientMessageToAllEx(COLOR_RED, "%s has been eliminated from the Hunger Game Event, Players Remaining: %d",
                                 GetPlayerNameEx(playerid), HungerGamePlayers);
    }
   	return 1;
}
