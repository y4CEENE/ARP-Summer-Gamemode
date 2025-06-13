/// @file      FallOut.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-12-29 17:19:07 +0100
/// @copyright Copyright (c) 2022

// FALLOUT EVENT CODED BY Flamehaze
#include <YSI\y_hooks>

#define FALLOUT_EVENT_START 3 // Calculated in minutes you have to change it (1 = 1 minute)
#define FALLOUT_CASH_REWARD 20000 // The money that the player wins, change it from there if you want
#define FALLOUT_MINIMUM_PLAYERS 2

#define FALLOUT_EVENT_TOKEN 0x4F65D13
#define MAX_PLATFORMS 91 //Number of platforms in the game

enum eFalloutState
{
    FalloutState_Configuration,
    FalloutState_Published,
    FalloutState_Started,
};

static eFalloutState:FalloutState = FalloutState_Configuration;
static PlatformObject[MAX_PLATFORMS]; //Platforms
static bool:PlayerFallout[MAX_PLAYERS]; //Player Variable that let us know if the player is inside the event or not
static FalloutPlayers = 0; //Global Variable to know how much players we have in the event, if < 1 the event will NOT start.

hook OnPlayerInit(playerid)
{
    PlayerFallout[playerid] = false; //Let's define that whenever a new player connects we set his Fallout variable to 0
}

hook OnPlayerDisconnect(playerid, reason)
{
    //If a Fallout Player leaves
    if(PlayerFallout[playerid])
    {
       FalloutPlayers--;
       SendClientMessageToAllEx(COLOR_RED, "%s has been eliminated from the Fallout Event (Disconnect)", GetPlayerNameEx(playerid));
    }
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken != FALLOUT_EVENT_TOKEN)
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
        SendClientMessageToAllEx(COLOR_RED, "%s has been eliminated from the Fallout Event (Died)", GetPlayerNameEx(playerid));
    }
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (!PlayerFallout[playerid])
    {
        return 1;
    }

    //If there is only 1 player remaining he's the winner
    if(FalloutState == FalloutState_Started && FalloutPlayers == 1) //Checking if there's 1 player remaining
    {
        FalloutPlayers = 0;
        PlayerFallout[playerid] = false;
        DeletePVar(playerid, "EventToken");
        DestroyPlatforms();
        FalloutState = FalloutState_Configuration;
        SetPlayerWeapons(playerid);
        SetPlayerToSpawn(playerid);

        GivePlayerCash(playerid, FALLOUT_CASH_REWARD);
        SendClientMessageToAllEx(COLOR_AQUA, "Congratz to %s for being the last man standing on the platform!", GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You win %s as a fallout event reward!", FormatCash(FALLOUT_CASH_REWARD));
    }
    else
    {
        new Float: px, Float: py, Float: pz;
        GetPlayerPos(playerid, px, py, pz);

        if(pz < 800) // Check who has fallen from the platform
        {
            FalloutPlayers--;
            PlayerFallout[playerid] = false;
            DeletePVar(playerid, "EventToken");
            SetPlayerWeapons(playerid);
            SetPlayerToSpawn(playerid);
            SendClientMessageToAllEx(COLOR_RED, "%s has been eliminated from the Fallout Event, Players Remaining: %d",
                                     GetPlayerNameEx(playerid), FalloutPlayers);
        }
    }
    return 1;
}

CMD:fallout(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /fallout [create/cancel/goto]");
    }

    if (!strcmp(params, "cancel", true))
    {
        if(FalloutState == FalloutState_Configuration)
        {
            return SendErrorMessage(playerid, "There is no active fallout event");
        }

        foreach (new i : Player)
        {
            if (PlayerFallout[i])
            {
                PlayerFallout[i] = false;
                DeletePVar(i, "EventToken");
                SetPlayerWeapons(i);
                SetPlayerToSpawn(i);
            }
        }
        DestroyPlatforms();
        FalloutPlayers = 0;
        FalloutState = FalloutState_Configuration;
        SendClientMessageToAllEx(COLOR_RED, "%s has canceled the Fallout Event.", GetPlayerNameEx(playerid));
    }
    else if (!strcmp(params, "create", true))
    {

        if(FalloutState == FalloutState_Published)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't start another Fallout Event!");
        }

        if(FalloutState == FalloutState_Started)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The Fallout Event has already started!");
        }

        DestroyPlatforms();
        CreatePlatforms();
        FalloutPlayers = 0;
        FalloutState = FalloutState_Published;
        defer FalloutAutoStart();
        SendClientMessageToAllEx(COLOR_GREEN, "The Fallout event is about to start in %d minute(s), join it by typing '/joinfallout'", FALLOUT_EVENT_START);
    }
    else if (!strcmp(params, "goto", true))
    {
        TeleportToCoords(playerid, 1473.2000, 1341.0000, 861.0000, 0.0, 0, 5000, true, false);
    }
    return 1;
}

CMD:joinfallout(playerid, params[])
{
    if (PlayerData[playerid][pLevel] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only level 3+ can join events.");
    }

    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't do that at this moment!");

    }
    if(FalloutState == FalloutState_Started)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The Fallout event has already started, you can't join it now!");
    }

    if(FalloutState != FalloutState_Published)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There's no active Fallout Event!");
    }

    if(PlayerFallout[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't join this, you're already in the event!");
    }

    AddPlayerToFallout(playerid);
    return 1;
}

AddPlayerToFallout(playerid)
{
    SavePlayerVariables(playerid);
    ResetPlayerWeapons(playerid);
    SetPVarInt(playerid, "EventToken", FALLOUT_EVENT_TOKEN);

    FalloutPlayers++; //Increase the players in the event
    PlayerFallout[playerid] = true; //The player is now a Fallout Partecipant

    TeleportToCoords(playerid, 1473.2000, 1341.0000, 861.0000, 0.0, 0, 5000, true, false);
    SendClientMessage(playerid, COLOR_AQUA, "You joined the Fallout Event! Just wait until the event starts!");
}

timer FalloutAutoStart[60000 * FALLOUT_EVENT_START]()
{
    if(FalloutPlayers < FALLOUT_MINIMUM_PLAYERS)
    {
        foreach (new i : Player)
        {
            if (PlayerFallout[i])
            {
                PlayerFallout[i] = false;
                DeletePVar(i, "EventToken");
                SetPlayerWeapons(i);
                SetPlayerToSpawn(i);
            }
        }
        FalloutPlayers = 0;
        DestroyPlatforms();
        FalloutState = FalloutState_Configuration;
        SendClientMessageToAll(COLOR_RED, "Sadly there were not enough players to start the Fallout Event :(");
    }
    else
    {
        FalloutState = FalloutState_Started;
        defer DestroyRandomPlatform();
        SendClientMessageToAll(COLOR_AQUA, "The Fallout Event has been started!");
    }
}

timer DestroyRandomPlatform[1000]()
{
    if(IsValidDynamicObject(PlatformObject[random(MAX_PLATFORMS)]))
    {
        DestroyDynamicObject(PlatformObject[random(MAX_PLATFORMS)]);
    }
    if (FalloutState == FalloutState_Started)
    {
        defer DestroyRandomPlatform();
    }
}

stock DestroyPlatforms()
{
    for(new idx = 0; idx < sizeof(PlatformObject); idx++)
    {
        if(IsValidDynamicObject(PlatformObject[idx]))
        {
            DestroyDynamicObject(PlatformObject[idx]);
        }
    }
}

stock CreatePlatforms()
{
    PlatformObject[0] = CreateDynamicObject(2932, 1491.84485, 1326.64197, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[1] = CreateDynamicObject(2932, 1488.72217, 1326.64160, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[2] = CreateDynamicObject(2934, 1488.72217, 1333.79651, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[3] = CreateDynamicObject(2935, 1488.72217, 1340.95142, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[4] = CreateDynamicObject(2932, 1488.72217, 1348.10632, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[5] = CreateDynamicObject(2934, 1488.72217, 1355.26123, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[6] = CreateDynamicObject(2935, 1488.72217, 1362.41614, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[7] = CreateDynamicObject(2934, 1485.60217, 1333.79651, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[8] = CreateDynamicObject(2935, 1485.60217, 1340.95142, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[9] = CreateDynamicObject(2932, 1485.60217, 1348.10632, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[10] = CreateDynamicObject(2934, 1485.60217, 1355.26123, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[11] = CreateDynamicObject(2932, 1485.60217, 1326.64160, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[12] = CreateDynamicObject(2935, 1485.60217, 1362.41614, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[13] = CreateDynamicObject(2934, 1482.47925, 1355.26526, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[14] = CreateDynamicObject(2932, 1482.53735, 1326.67883, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[15] = CreateDynamicObject(2934, 1482.47925, 1333.80054, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[16] = CreateDynamicObject(2935, 1482.47925, 1340.95544, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[17] = CreateDynamicObject(2932, 1482.47925, 1348.11035, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[18] = CreateDynamicObject(2935, 1482.47925, 1362.42017, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[19] = CreateDynamicObject(2935, 1479.35925, 1362.42017, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[20] = CreateDynamicObject(2934, 1479.35925, 1355.26526, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[21] = CreateDynamicObject(2932, 1479.35925, 1348.11035, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[22] = CreateDynamicObject(2935, 1479.35925, 1340.95544, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[23] = CreateDynamicObject(2934, 1479.35925, 1333.80054, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[24] = CreateDynamicObject(2932, 1479.35925, 1326.64563, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[25] = CreateDynamicObject(2932, 1473.11523, 1326.64673, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[26] = CreateDynamicObject(2932, 1476.23523, 1326.64673, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[27] = CreateDynamicObject(2934, 1476.23523, 1333.80164, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[28] = CreateDynamicObject(2935, 1473.11523, 1340.95654, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[29] = CreateDynamicObject(2935, 1476.23523, 1340.95654, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[30] = CreateDynamicObject(2932, 1476.23523, 1348.11145, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[31] = CreateDynamicObject(2932, 1473.11523, 1348.11145, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[32] = CreateDynamicObject(2934, 1473.11523, 1355.26636, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[33] = CreateDynamicObject(2934, 1476.23523, 1355.26636, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[34] = CreateDynamicObject(2935, 1476.23523, 1362.42126, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[35] = CreateDynamicObject(2935, 1473.11523, 1362.42126, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[36] = CreateDynamicObject(2932, 1469.99231, 1326.65076, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[37] = CreateDynamicObject(2934, 1469.99231, 1333.80566, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[38] = CreateDynamicObject(2934, 1473.11523, 1333.80164, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[39] = CreateDynamicObject(2935, 1469.99231, 1340.96057, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[40] = CreateDynamicObject(2932, 1469.99231, 1348.11548, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[41] = CreateDynamicObject(2934, 1469.99231, 1355.27039, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[42] = CreateDynamicObject(2935, 1469.99231, 1362.42529, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[43] = CreateDynamicObject(2934, 1466.86975, 1333.80359, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[44] = CreateDynamicObject(2932, 1466.86975, 1326.64868, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[45] = CreateDynamicObject(2932, 1463.74976, 1326.64868, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[46] = CreateDynamicObject(2934, 1463.74976, 1333.80359, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[47] = CreateDynamicObject(2935, 1466.86975, 1340.95850, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[48] = CreateDynamicObject(2935, 1463.74976, 1340.95850, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[49] = CreateDynamicObject(2932, 1466.86975, 1348.11340, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[50] = CreateDynamicObject(2932, 1463.74976, 1348.11340, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[51] = CreateDynamicObject(2934, 1466.86975, 1355.26831, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[52] = CreateDynamicObject(2934, 1463.74976, 1355.26831, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[53] = CreateDynamicObject(2935, 1466.86975, 1362.42322, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[54] = CreateDynamicObject(2935, 1463.74976, 1362.42322, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[55] = CreateDynamicObject(2934, 1460.62683, 1333.80762, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[56] = CreateDynamicObject(2932, 1460.68494, 1326.68591, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[57] = CreateDynamicObject(2935, 1460.62683, 1340.96252, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[58] = CreateDynamicObject(2932, 1460.62683, 1348.11743, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[59] = CreateDynamicObject(2934, 1460.62683, 1355.27234, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[60] = CreateDynamicObject(2935, 1460.62683, 1362.42725, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[61] = CreateDynamicObject(2935, 1457.50684, 1362.42725, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[62] = CreateDynamicObject(2934, 1457.50684, 1355.27234, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[63] = CreateDynamicObject(2932, 1457.50684, 1348.11743, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[64] = CreateDynamicObject(2935, 1457.50684, 1340.96252, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[65] = CreateDynamicObject(2934, 1457.50684, 1333.80762, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[66] = CreateDynamicObject(2932, 1457.50684, 1326.65271, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[67] = CreateDynamicObject(2932, 1454.38281, 1326.65381, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[68] = CreateDynamicObject(2934, 1454.38281, 1333.80872, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[69] = CreateDynamicObject(2935, 1454.38281, 1340.96362, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[70] = CreateDynamicObject(2932, 1454.38281, 1348.11853, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[71] = CreateDynamicObject(2934, 1454.38281, 1355.27344, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[72] = CreateDynamicObject(2935, 1454.38281, 1362.42834, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[73] = CreateDynamicObject(2934, 1451.26282, 1333.80872, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[74] = CreateDynamicObject(2935, 1451.26282, 1340.96362, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[75] = CreateDynamicObject(2932, 1451.26282, 1348.11853, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[76] = CreateDynamicObject(2934, 1451.26282, 1355.27344, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[77] = CreateDynamicObject(2935, 1451.26282, 1362.42834, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[78] = CreateDynamicObject(2935, 1448.13989, 1362.43237, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[79] = CreateDynamicObject(2934, 1448.13989, 1355.27747, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[80] = CreateDynamicObject(2932, 1448.13989, 1348.12256, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[81] = CreateDynamicObject(2935, 1448.13989, 1340.96765, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[82] = CreateDynamicObject(2934, 1448.13989, 1333.81274, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[83] = CreateDynamicObject(2932, 1451.26282, 1326.65381, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[84] = CreateDynamicObject(2932, 1448.13989, 1326.65784, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[85] = CreateDynamicObject(2932, 1491.84485, 1326.64197, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[86] = CreateDynamicObject(2934, 1491.84485, 1333.79688, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[87] = CreateDynamicObject(2935, 1491.84485, 1340.95178, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[88] = CreateDynamicObject(2932, 1491.84485, 1348.10669, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[89] = CreateDynamicObject(2934, 1491.84485, 1355.26160, 857.61951,   0.00000, 0.00000, 0.00000);
    PlatformObject[90] = CreateDynamicObject(2935, 1491.84485, 1362.41650, 857.61951,   0.00000, 0.00000, 0.00000);
}
