/// @file      MiniGame.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 13:53:28 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MINI_GAME_EVENT_TOKEN 5462
#define MINI_GAME_VIRTUAL_WORLD_ID 0

static PlayerMiniGameCount [MAX_PLAYERS];
static PlayerMiniGameClaim [MAX_PLAYERS];
static InMG[MAX_PLAYERS];


CMD:joinminigame(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1882.27, -1156.53, 24.78))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at any booth in Glen Park.");
    }
    if (InMG[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already in Minigame.");
    }

    SavePlayerVariables(playerid);
    SetPVarInt(playerid, "EventToken", MINI_GAME_EVENT_TOKEN);

    //Ensure guns removed
    PlayerData[playerid][pTazer] = 0;
    ResetPlayerWeapons(playerid);
    SetPlayerHealth(playerid, 255.0);
    SetPlayerArmour(playerid, 255.0);

    //spawn player to game
    TeleportToCoords(playerid,
                    332.6036,
                    1625.4906,
                    1042.5234,
                    90.0,
                    21,
                    MINI_GAME_VIRTUAL_WORLD_ID,
                    true /* freeze */);
    InMG[playerid] = 1;
    SendClientMessage(playerid, -1, "You have joined the Maze Minigame. You can exit the minigame at anytime (/exitminigame).");
    return 1;
}

CMD:exitminigame(playerid, params[])
{
    if (!InMG[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any minigame.");
    }

    TogglePlayerControllable(playerid, true);
    DeletePVar(playerid, "EventToken");
    SetPlayerWeapons(playerid);
    SetPlayerToSpawn(playerid);
    InMG[playerid] = 0;
    SendClientMessage(playerid, -1, "You have left the maze minigame.");
    return 1;
}

CMD:claimgift(playerid, params[])
{
    if (!InMG[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any booth.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, -27.7987,1626.9500,1026.5034))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the finishing point!");
    }
    if (!PlayerMiniGameClaim[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already received your prize! Comeback again next paycheck.");
    }

    InMG[playerid] = 0;
    TogglePlayerControllable(playerid, true);
    DeletePVar(playerid, "EventToken");
    SetPlayerWeapons(playerid);
    SetPlayerToSpawn(playerid);

    PlayerMiniGameClaim[playerid] = 0;
    PlayerMiniGameCount[playerid]++;
    DBQuery("UPDATE users SET minigame_claim = %i, minigame_count = %i WHERE uid = %i", PlayerMiniGameClaim[playerid], PlayerMiniGameCount[playerid], PlayerData[playerid][pID]);
    SendClientMessageToAllEx(COLOR_GREEN, "{AA3333}Congratulations to %s for passing the maze game and winning a random prize! They won %d rounds in a row!", GetPlayerNameEx(playerid), PlayerMiniGameCount[playerid]);

    new prize = random(7)+1;

    if (prize == 1)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: SPAS-12 & Deagle");
        GivePlayerWeaponEx(playerid, 24);
        GivePlayerWeaponEx(playerid, 27);
    }
    else if (prize == 2)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: Full-set weapon");
        GivePlayerWeaponEx(playerid, 24);
        GivePlayerWeaponEx(playerid, 27);
        GivePlayerWeaponEx(playerid, 29);
        GivePlayerWeaponEx(playerid, 31);
        GivePlayerWeaponEx(playerid, 34);
    }
    else if (prize == 3)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: $20,000");
        GivePlayerCash(playerid, 20000);
    }
    else if (prize == 4)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: 10,000 Materials");
        PlayerData[playerid][pMaterials] += 10000;
    }
    else if (prize == 5)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: $5,000 Cash and 2,500 Materials");
        PlayerData[playerid][pMaterials] += 2500;
        GivePlayerCash(playerid, 5000);
    }
    else if (prize == 6)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: Full Vest & Full Armor");
        SetPlayerHealth(playerid, 100);
        SetScriptArmour(playerid, 100);
    }
    else if (prize == 7)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "RANDOM PRIZE: 25 grams of weed & cocaine!");
        PlayerData[playerid][pCocaine] += 25;
        PlayerData[playerid][pWeed] += 25;
    }
    return 1;
}

hook OnLoadGameMode(timestamp)
{
    CreateDynamic3DTextLabel("{FFFF00}Maze Minigame\n/joinminigame", -1, 1882.27, -1156.53, 24.78, 20.0);
    CreateDynamic3DTextLabel("{FFFF00}You have reached the end of Maze Minigame\n\nYou can /claimgift or /exitminigame at anytime\n\nYou may exit with /exitminigame after doing so.", -1, -27.7987,1626.9500,1026.5034, 7.0);

    CreateDynamic3DTextLabel("{FFFF00}Next area\nPress 'Y' to go up", -1, 62.7540,1625.8625,1057.2513, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Next area\nPress 'Y' to go up", -1, 62.4150,1629.4210,1057.2513, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Next area\nPress 'Y' to go up", -1, 26.7361,1631.9501,1013.6207, 5.0);

    CreateDynamic3DTextLabel("{FFFF00}Fell down?\nPress 'Y' to go up", -1, 11.0897,1630.8412,1005.1062, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Fell down?\nPress 'Y' to go up", -1, 0.5273,1631.2433,1005.1062, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Fell down?\nPress 'Y' to go up", -1, -10.3871,1631.3064,1005.1062, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Fell down?\nPress 'Y' to go up", -1, -20.5898,1626.3257,1005.1062, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Fell down?\nPress 'Y' to go up", -1, -19.3437,1637.7467,1005.1062, 5.0);
    CreateDynamic3DTextLabel("{FFFF00}Fell down?\nPress 'Y' to go up", -1, -28.2381,1632.5438,1005.1062, 5.0);
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if (GetPVarInt(playerid, "MiniGameSong") == 0)
    {
        if (IsPlayerInRangeOfPoint(playerid, 40.0, 1893.38135, -1176.850708, 24.460311) && IsPlayerLoggedIn(playerid) && !IsPlayerInAnyVehicle(playerid))
        {
            PlayAudioStreamForPlayer(playerid, "http://arabicarp.com/wp-content/music/minigame-song.mp3");
            SetPVarInt(playerid, "MiniGameSong", 1);
        }
    }
    else if ( GetPVarInt(playerid, "MiniGameSong") == 1)
    {
        if (!IsPlayerInRangeOfPoint(playerid, 40.0, 1893.38135, -1176.850708, 24.460311) || !IsPlayerLoggedIn(playerid) || IsPlayerInAnyVehicle(playerid))
        {
            StopAudioStreamForPlayer(playerid);
            DeletePVar(playerid, "MiniGameSong");
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    if (GetPVarInt(playerid, "EventToken") != MINI_GAME_EVENT_TOKEN)
    {
        return 1;
    }
    DeletePVar(playerid, "EventToken");
    SetPlayerWeapons(playerid);
    SetPlayerToSpawn(playerid);
    InMG[playerid] = 0;
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken != MINI_GAME_EVENT_TOKEN)
    {
        return 1;
    }
    DeletePVar(playerid, "EventToken");
    SetPlayerWeapons(playerid);
    SetPlayerToSpawn(playerid);
    InMG[playerid] = 0;
    SendClientMessage(playerid, -1, "Gameover: You are kicked from the maze minigame as you died.");

    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (InMG[playerid] && IsKeyPress(KEY_YES, newkeys, oldkeys))
    {
        // DOOR 1- 2
        if ((IsPlayerInRangeOfPoint(playerid, 3.0, 62.7540,1625.8625,1057.2513)) ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, 62.4150,1629.4210,1057.2513)) ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, 26.7361,1631.9501,1013.6207)))
        {
            SetPlayerPos(playerid, 48.4128,1631.9667, 1067.2766);
        }

        // FELL DOWN
        if ((IsPlayerInRangeOfPoint(playerid, 3.0, 11.0897,1630.8412,1005.1062))  ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, 0.5273,1631.2433,1005.1062))   ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, -10.3871,1631.3064,1005.1062)) ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, -20.5898,1626.3257,1005.1062)) ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, -19.3437,1637.7467,1005.1062)) ||
           (IsPlayerInRangeOfPoint(playerid, 3.0, -28.2381,1632.5438,1005.1062)))
        {
            SetPlayerPos(playerid, 15.5405,1631.2135,1016.9194);
        }
    }
    return 1;
}

hook OnGameModeInit()
{
    MazeMiniGame_LoadMap();
    GlenPark_LoadMap();
    return 1;
}

hook OnPlayerInit(playerid)
{
    PlayerMiniGameCount[playerid] = 0;
    PlayerMiniGameClaim[playerid] = 0;
    InMG[playerid] = 0;
    return 1;
}

hook OnLoadPlayer(playerid, row)
{
    PlayerMiniGameClaim[playerid] = GetDBIntField(row, "minigame_claim");
    PlayerMiniGameCount[playerid] = GetDBIntField(row, "minigame_count");
    return 1;
}

hook OnPlayerPayDay(playerid, cash)
{
    PlayerMiniGameClaim[playerid] = 1;
    DBQuery("UPDATE users SET minigame_claim = %i WHERE uid = %i", PlayerMiniGameClaim[playerid], PlayerData[playerid][pID]);
    return 1;
}
hook OnRemoveBuildings(playerid)
{
    RemoveBuildingForPlayer(playerid, 645, 1906.6875, -1199.1406, 19.2656, 0.25);
    return 1;
}
MazeMiniGame_LoadMap()
{
    CreateDynamicObject(6391, 312.00851, 1628.52478, 1000.00000,   0.00000, 0.00000, 10.00000);
    CreateDynamicObject(7024, 294.19174, 1649.90686, 1040.99963,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(7024, 316.33530, 1596.19812, 1040.99963,   90.00000, 180.00000, 0.00000);
    CreateDynamicObject(7024, 351.01657, 1619.84509, 1040.99963,   90.00000, -90.00000, 0.00000);
    CreateDynamicObject(19358, 321.27402, 1615.45215, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 321.27399, 1618.66260, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 321.27399, 1621.86169, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 321.27399, 1625.06445, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 321.27399, 1628.26526, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 321.29251, 1631.47278, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 321.27399, 1634.67896, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 313.13300, 1615.45215, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 313.13300, 1618.66260, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 313.13300, 1621.86169, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 313.13300, 1625.06445, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 313.13300, 1628.26526, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 313.13300, 1631.47278, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 313.13300, 1634.67896, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(6391, 297.26822, 1624.90503, 1000.00000,   0.00000, 0.00000, 10.00000);
    CreateDynamicObject(1491, 321.27399, 1619.43994, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 321.27399, 1622.64185, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 321.27399, 1625.84473, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 321.27399, 1629.05042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 321.27399, 1632.25659, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 313.13589, 1619.43994, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 313.13589, 1622.64185, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 313.13589, 1625.84473, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 313.13589, 1629.05042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 313.13589, 1632.25659, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(19358, 320.89209, 1615.45215, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 320.89209, 1618.66260, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 320.89209, 1621.86169, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 320.89209, 1625.06445, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 320.89209, 1631.47278, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 320.89209, 1634.67896, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 312.75360, 1615.45215, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 312.75360, 1618.66260, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 312.75360, 1625.06445, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 312.75360, 1628.26526, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 312.75360, 1631.47278, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 312.75360, 1634.67896, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 308.07330, 1615.45215, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 308.07330, 1621.86169, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 308.07330, 1625.06445, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 308.07330, 1628.26526, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 308.07330, 1634.67896, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 308.07330, 1618.66260, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 308.07330, 1631.47278, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19358, 306.95642, 1615.03247, 1042.75684,   0.00000, 0.00000, 45.00000);
    CreateDynamicObject(19358, 304.68109, 1617.31140, 1042.75684,   0.00000, 0.00000, 45.00000);
    CreateDynamicObject(19388, 306.40585, 1620.31995, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 303.20529, 1620.31995, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 302.78326, 1619.19360, 1042.75684,   0.00000, 0.00000, 45.00000);
    CreateDynamicObject(1491, 307.14859, 1620.33875, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 308.07330, 1625.84473, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 308.07330, 1629.05042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(19388, 305.08521, 1622.01135, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 306.40591, 1623.69836, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 305.08521, 1625.38733, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 306.40591, 1626.95374, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 307.83676, 1628.64441, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 306.40591, 1630.32397, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 303.20529, 1630.32397, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 307.52350, 1635.90295, 1042.75684,   0.00000, 0.00000, -45.00000);
    CreateDynamicObject(19358, 305.25531, 1633.63110, 1042.75684,   0.00000, 0.00000, -45.00000);
    CreateDynamicObject(19358, 303.01010, 1631.38635, 1042.75684,   0.00000, 0.00000, -45.00000);
    CreateDynamicObject(19388, 305.08521, 1628.64868, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 303.20529, 1623.69836, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 303.20529, 1626.95374, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 301.69531, 1622.01135, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 301.69531, 1625.38733, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 301.69531, 1628.64868, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 300.02481, 1620.30042, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 300.02481, 1623.69836, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 300.02481, 1626.95374, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 300.02481, 1630.32397, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 301.69531, 1618.60852, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 301.69531, 1615.40662, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 301.69531, 1632.00769, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 301.69531, 1635.20203, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1618.60852, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1615.40662, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1622.01147, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1625.38733, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1628.64868, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1632.00769, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 298.51431, 1635.20203, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1491, 305.08521, 1622.78162, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 305.08521, 1626.16467, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 305.08521, 1629.43042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1622.78162, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1626.16467, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1629.43042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1632.79077, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1635.97400, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1619.39807, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 301.69531, 1616.17810, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1616.17810, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1619.39807, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1622.78162, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1626.16467, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1629.43042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1632.79077, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 298.51431, 1635.97400, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 308.07330, 1622.64185, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 303.94800, 1620.33875, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 300.80719, 1620.33875, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 307.14859, 1623.69836, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 303.94800, 1623.69836, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 300.80719, 1623.69836, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 307.14859, 1626.95374, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 303.94800, 1626.95374, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 300.80719, 1626.95374, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 307.14859, 1630.32397, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 303.94800, 1630.32397, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(1491, 300.80719, 1630.32397, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(19358, 296.86209, 1614.24377, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.65701, 1614.24377, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1617.58350, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1617.58350, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1620.30042, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 300.02481, 1620.30042, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1623.69836, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1626.95374, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1630.32397, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1636.18225, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 296.86209, 1633.62659, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1620.30042, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1623.69836, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1626.95374, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1630.32397, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1633.62659, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19358, 293.67740, 1636.18225, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, 292.11520, 1635.20203, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 292.11520, 1632.00769, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 292.11520, 1628.64868, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 292.11520, 1625.38733, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 292.11520, 1622.01147, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 292.11520, 1618.60852, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 292.11520, 1615.40662, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1491, 292.11520, 1635.97400, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 292.11520, 1632.79077, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 292.11520, 1629.43042, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 292.11520, 1626.16467, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 292.11520, 1622.78162, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 292.11520, 1619.39807, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1491, 292.11520, 1616.17810, 1041.00964,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(7024, 321.79999, 1622.18469, 1057.12463,   0.00000, 180.00000, 90.00000);
    CreateDynamicObject(19450, 291.65030, 1622.29199, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19450, 291.65030, 1624.65759, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19450, 291.65030, 1612.66077, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(7024, 339.20166, 1601.15564, 1052.73047,   -90.00000, 360.00000, 360.00000);
    CreateDynamicObject(6391, 266.14499, 1624.46729, 986.53192,   0.00000, 0.00000, 10.00000);
    CreateDynamicObject(6391, 233.81351, 1628.17871, 998.61908,   0.00000, 0.00000, 10.00000);
    CreateDynamicObject(19388, 300.13770, 1633.62659, 1042.75684,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1491, 300.80719, 1633.62659, 1041.00964,   0.00000, 0.00000, -180.00000);
    CreateDynamicObject(7024, 254.90602, 1596.66028, 1040.99963,   90.00000, 180.00000, 0.00000);
    CreateDynamicObject(6391, 233.89246, 1609.42908, 998.61908,   0.00000, 0.00000, 10.00000);
    CreateDynamicObject(7024, 211.25789, 1608.93469, 1046.53491,   90.00000, 180.00000, 360.00000);
    CreateDynamicObject(7024, 207.59261, 1627.65015, 1027.75635,   180.00000, 180.00000, 0.00000);
    CreateDynamicObject(7024, 201.92670, 1634.61328, 1037.17029,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(18771, 221.18721, 1626.62939, 1040.29871,   0.00000, 0.00000, 79.72020);
    CreateDynamicObject(19360, 217.59164, 1631.49915, 1049.74683,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19360, 220.71292, 1631.53149, 1049.74683,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19378, 214.53011, 1634.83875, 1065.40894,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19378, 217.98984, 1624.94666, 1078.00354,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(18986, 196.10110, 1626.86597, 1064.48499,   0.00000, 65.00000, 0.00000);
    CreateDynamicObject(19475, 183.76100, 1629.18665, 1060.15955,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19475, 189.75598, 1628.95898, 1105.41455,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(925, 280.01578, 1631.09619, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 281.82428, 1625.04639, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 272.76089, 1624.19250, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 265.42545, 1627.61365, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 277.23105, 1628.02112, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 267.79944, 1631.93884, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2912, 283.74283, 1627.98804, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 277.18954, 1625.04272, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 274.93640, 1629.79700, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 270.52301, 1626.71753, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 267.26385, 1624.14929, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 270.17535, 1622.58899, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(14411, 274.76212, 1615.32556, 1031.61450,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(14411, 283.66095, 1611.05798, 1037.82129,   0.00000, 0.00000, 270.83499);
    CreateDynamicObject(7024, 382.20480, 1648.53894, 1040.99963,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(0, 185.02890, 1628.50220, 1055.27478,   -360.00000, 0.00000, 0.00000);
    CreateDynamicObject(19360, 184.30780, 1627.03687, 1056.34058,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19360, 184.30780, 1626.87402, 1056.34058,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19360, 181.26910, 1630.05835, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 181.26910, 1633.24597, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 181.26910, 1626.88916, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 181.26910, 1623.72717, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 177.79620, 1633.25012, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(7024, 176.06114, 1645.92700, 1050.28442,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(7024, 155.36188, 1607.76257, 1050.28442,   90.00000, 180.00000, 360.00000);
    CreateDynamicObject(19360, 177.77930, 1627.01062, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 174.42940, 1630.20154, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 174.45779, 1633.35413, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 174.08820, 1623.89600, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 170.54829, 1623.92236, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.54800, 1623.90491, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.47180, 1627.14539, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 170.93919, 1630.22144, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.49750, 1633.36560, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.45370, 1630.12524, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.19930, 1627.14539, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.19930, 1630.30591, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.19930, 1633.46619, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.19933, 1636.66492, 1055.18762,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.19930, 1623.96582, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 167.19930, 1620.76587, 1055.18762,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(18982, 115.57170, 1627.70605, 1071.95911,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19360, 165.48610, 1629.76392, 1056.02954,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19450, 291.65030, 1637.62585, 1042.75684,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(14638, -24.73802, 1616.98340, 1075.74231,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(14411, 172.26656, 1620.62207, 1058.29016,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(18984, 115.58509, 1627.70605, 1061.06982,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(7024, 16.69246, 1613.35632, 988.42651,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(7024, 4.43380, 1649.04321, 988.42651,   0.00000, 90.00000, -90.00000);
    CreateDynamicObject(7024, 41.30133, 1631.68835, 988.42651,   0.00000, 90.00000, -180.00000);
    CreateDynamicObject(7024, 63.77179, 1638.54736, 999.98004,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18986, 26.61261, 1633.67249, 1010.04053,   0.00000, -10.00000, 50.00000);
    CreateDynamicObject(925, 23.80490, 1635.48572, 1043.96448,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 22.23878, 1635.55103, 1043.96448,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 27.34244, 1628.79175, 1029.89355,   0.00000, 0.00000, 88.13634);
    CreateDynamicObject(925, 26.91262, 1633.80518, 1027.57068,   0.00000, 0.00000, 120.34258);
    CreateDynamicObject(3361, 19.43383, 1630.00989, 1013.73706,   0.00000, 0.00000, 129.50954);
    CreateDynamicObject(14411, 19.37357, 1631.06226, 1012.72412,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19466, 12.46620, 1631.12598, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, 10.24190, 1631.12598, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, 5.76780, 1631.12598, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -6.01966, 1628.55310, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -7.65059, 1633.92480, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, 2.63141, 1633.87634, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -0.44589, 1630.02283, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(18983, 10.53550, 1631.23877, 963.26947,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(18985, -0.15900, 1631.23877, 963.26947,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(18984, -19.37330, 1637.33630, 963.26947,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(0, -10.15730, 1628.16443, 959.47913,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19466, -11.79099, 1629.14099, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(14411, -6.51545, 1617.19739, 1017.68707,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(14411, -17.71788, 1618.70776, 1017.68707,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(14411, -21.81364, 1621.25708, 1022.13074,   0.00000, 0.00000, 360.00000);
    CreateDynamicObject(970, -2.08290, 1615.81311, 1018.46002,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(970, -4.11940, 1613.49866, 1018.46002,   0.00000, 0.00000, 7.63623);
    CreateDynamicObject(970, -7.31807, 1613.93030, 1018.46002,   0.00000, 0.00000, 342.32477);
    CreateDynamicObject(970, -9.55829, 1615.84204, 1018.46002,   0.00000, 0.00000, 283.59344);
    CreateDynamicObject(19475, 183.76100, 1629.18665, 1060.15955,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(14416, 167.27719, 1626.20325, 1062.19128,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19360, 181.28040, 1621.84546, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 177.71780, 1621.69885, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19360, 176.03740, 1621.68359, 1057.69080,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(7024, 333.37411, 1648.33203, 1040.99963,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 279.76968, 1627.08398, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 281.58279, 1621.98193, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 279.07446, 1623.93677, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 277.63556, 1632.15869, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 275.73962, 1623.91345, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(925, 273.23380, 1631.88879, 1040.34155,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2912, 271.09628, 1632.65540, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 270.34946, 1629.89343, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 265.41827, 1631.54712, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2912, 268.24930, 1635.46472, 1040.35266,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1318, 221.41724, 1626.62817, 1050.92004,   180.00000, 0.00000, 0.00000);
    CreateDynamicObject(1318, 221.41721, 1626.63342, 1042.58704,   180.00000, 0.00000, 0.00000);
    CreateDynamicObject(19378, 214.53011, 1625.23486, 1065.40894,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19378, 217.98981, 1634.56128, 1078.00354,   0.00000, 90.00000, 0.00000);
    CreateDynamicObject(3378, 166.56931, 1620.97754, 1055.89697,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(7024, 216.45404, 1645.91626, 1034.37219,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 65.76060, 1626.36292, 1057.71912,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19388, 65.76060, 1629.34241, 1057.71912,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, 65.76060, 1623.96106, 1057.71912,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, 65.76060, 1631.72156, 1057.71912,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(8661, 65.76060, 1628.91663, 1069.27478,   90.00000, 0.00000, 90.00000);
    CreateDynamicObject(7024, 216.45404, 1645.91626, 1045.67480,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(7024, 154.72392, 1635.35242, 1037.17029,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19360, 165.48860, 1624.15283, 1056.02954,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19360, 165.48753, 1626.54382, 1056.02954,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19360, 165.48610, 1632.76025, 1056.02954,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(14823, 64.93920, 1626.18213, 1057.49353,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(14823, 64.93920, 1629.66248, 1057.49353,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1, 23.56070, 1630.22412, 1043.75342,   0.00000, 0.00000, 343.62689);
    CreateDynamicObject(18982, -10.68744, 1631.21558, 963.26947,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(7024, 32.38592, 1637.18933, 991.46558,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(925, 23.62883, 1627.26001, 1038.32910,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18813, 23.38776, 1631.39099, 1047.68152,   0.00000, 0.00000, 312.64331);
    CreateDynamicObject(925, 19.27892, 1631.33423, 1046.81970,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(925, 18.97719, 1631.41736, 1036.46350,   0.00000, 0.00000, 73.41552);
    CreateDynamicObject(18985, -20.13109, 1626.54431, 963.26947,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(18983, -28.95563, 1632.28503, 963.26947,   90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19466, -16.77315, 1631.60889, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -18.66618, 1635.51758, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -21.82474, 1638.37488, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -15.79502, 1638.09546, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19466, -21.64633, 1631.05591, 1015.92963,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(14411, -21.69805, 1618.67322, 1017.68707,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(970, -15.77500, 1614.75623, 1021.39673,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(970, -17.59002, 1612.13452, 1021.39673,   0.00000, 0.00000, 17.62822);
    CreateDynamicObject(970, -22.93852, 1614.86841, 1021.39673,   0.00000, 0.00000, 113.20811);
    CreateDynamicObject(970, -20.12251, 1612.46558, 1021.39673,   0.00000, 0.00000, 163.52959);
    CreateDynamicObject(970, -19.75490, 1625.17126, 1025.83948,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(970, -21.82462, 1628.28027, 1025.83948,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, -19.77834, 1626.13147, 1025.83948,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19388, -23.81050, 1627.02649, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -23.81050, 1629.43262, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -23.81050, 1624.62146, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -23.81050, 1623.04272, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19378, -28.51163, 1626.90051, 1028.77124,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(19431, -23.81050, 1622.64038, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19450, -28.58840, 1621.92273, 1027.08508,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19450, -28.52840, 1631.81299, 1027.08508,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19431, -23.81050, 1630.93958, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1630.93958, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1629.43262, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1624.62146, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1622.64038, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1623.04272, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1627.82678, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19431, -33.25600, 1626.22217, 1027.08508,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19378, -28.55893, 1626.86963, 1025.41748,   0.00000, 90.00000, 90.00000);
    CreateDynamicObject(1491, -23.80700, 1627.81274, 1025.32715,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(2207, -29.85489, 1625.97119, 1025.50391,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1671, -28.92649, 1625.88818, 1025.93628,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1671, -28.92650, 1627.68579, 1025.93628,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1714, -31.40260, 1626.92859, 1025.50317,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2253, -30.25336, 1626.13257, 1026.55005,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2240, -32.69304, 1631.24219, 1025.93933,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2240, -32.63187, 1622.45166, 1025.93933,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1726, -25.12254, 1622.55396, 1025.34338,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2240, -24.28907, 1622.15833, 1025.93933,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2240, -24.26741, 1631.37634, 1025.93933,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1726, -27.17850, 1631.20129, 1025.34338,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1726, -30.07750, 1631.20129, 1025.34338,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1726, -28.32310, 1622.55396, 1025.34338,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(3872, -29.42630, 1629.77576, 1023.63147,   0.00000, 0.00000, 252.75449);
    CreateDynamicObject(7024, 8.68111, 1633.55847, 991.46558,   0.00000, 0.00000, 0.00000);

    new tmp = CreateDynamicObject(11680, 182.63670, 1639.22229, 1057.65234,   0.00000, 0.00000, 110.14130);
    SetDynamicObjectMaterial(tmp, 0, 8661, "gnhotel1", "greyground256");
}

GlenPark_LoadMap()
{
    CreateDynamicObject(18759, 1902.31848, -1178.34290, 23.89430,   0.00000, -180.32001, -0.06000);
    CreateDynamicObject(14394, 1876.19849, -1167.71033, 23.01660,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1877.44019, -1174.81409, 24.35345,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1877.44019, -1181.27197, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1877.44019, -1187.67151, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1877.44019, -1194.11755, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1879.28796, -1199.95496, 24.35340,   0.00000, 0.00000, 36.29047);
    CreateDynamicObject(983, 1885.84937, -1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1891.36206, -1203.23645, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1897.76721, -1203.23645, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1904.15405, -1203.23645, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1910.55737, -1203.23645, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1916.91968, -1203.23743, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1922.00317, -1200.58167, 24.35340,   0.00000, 0.00000, -36.29050);
    CreateDynamicObject(983, 1925.24866, -1196.33411, 24.35340,   0.00000, 0.00000, -36.29050);
    CreateDynamicObject(983, 1879.97852, -1155.23047, 24.35340,   0.00000, 0.00000, 306.28363);
    CreateDynamicObject(19129, 1913.70398, -1166.58118, 16.34620,   0.00000, -90.00000, -90.00000);
    CreateDynamicObject(19129, 1891.69592, -1192.15491, 23.84445,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19129, 1891.64307, -1172.54187, 23.84445,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19129, 1924.46021, -1176.49988, 31.47200,   0.00000, -90.00000, 359.82349);
    CreateDynamicObject(19129, 1913.59705, -1186.58203, 16.34620,   0.00000, -90.00000, 90.00000);
    CreateDynamicObject(19129, 1903.72217, -1176.56519, 16.34620,   0.00000, -90.00000, 359.82346);
    CreateDynamicObject(19379, 1919.09253, -1181.81091, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(19379, 1908.77686, -1171.29285, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(19379, 1919.26196, -1171.29285, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(19379, 1919.06323, -1172.18445, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(19379, 1171.29285, -1181.81396, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(19379, 1908.77686, -1172.14197, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(19379, 1908.77686, -1172.18445, 26.28790,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(710, 1931.89844, -1171.50781, 33.55469,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19379, 1908.77686, -1181.81396, 26.28785,   0.00000, -90.00000, 0.00000);
    CreateDynamicObject(16770, 1891.14307, -1158.72229, 25.06620,   0.00000, 0.00000, 89.69699);
    CreateDynamicObject(2773, 1881.54919, -1157.72839, 24.31415,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1886.04968, -1157.65430, 24.31410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1884.56750, -1157.68457, 24.31410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1893.53333, -1157.49463, 24.35810,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1887.55396, -1157.62390, 24.31410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1889.03015, -1157.59241, 24.31410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1890.52563, -1157.56042, 24.33410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1892.04077, -1157.52808, 24.33410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1895.01135, -1157.46094, 24.35810,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1896.53430, -1157.42664, 24.35810,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1897.98828, -1157.40894, 24.37810,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2773, 1883.03687, -1157.71411, 24.31410,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1895.74280, -1158.34106, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1883.81433, -1158.59644, 24.08371,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1885.33923, -1158.56677, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1886.87146, -1158.53650, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1888.39697, -1158.50513, 24.08370,   0.00000, 0.00000, -0.06000);
    CreateDynamicObject(2599, 1889.79639, -1158.47351, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1891.32263, -1158.44165, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1892.68799, -1158.40857, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2599, 1894.31152, -1158.37524, 24.08370,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18761, 1904.41992, -1176.71521, 30.64897,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1927.04895, -1190.61987, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19129, 1915.12354, -1186.61133, 16.34620,   0.00000, -90.00000, 90.00000);
    CreateDynamicObject(19129, 1914.52734, -1166.55823, 16.34620,   0.00000, -90.00000, -90.00000);
    CreateDynamicObject(983, 1877.44019, -1160.43115, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1884.96643, -1203.23645, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1892.24988, -1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1898.66504, -1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1905.09778, 1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1905.08875, -1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1911.46094, -1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1917.82983, -1153.52148, 24.35340,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(983, 1922.85522, -1156.13965, 24.35340,   0.00000, 0.00000, 36.29050);
    CreateDynamicObject(983, 1879.85132, -1200.68018, 24.35340,   0.00000, 0.00000, 36.29050);
    CreateDynamicObject(983, 1925.38074, -1159.52783, 24.35340,   0.00000, 0.00000, 36.29050);
    CreateDynamicObject(983, 1927.04895, -1184.19800, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1927.04895, -1177.81726, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1927.04895, -1171.39697, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(983, 1927.04895, -1165.19006, 24.35340,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19076, 1476.99438, -1613.18542, 13.03107,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19054, 1478.88855, -1611.58569, 13.86010,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19055, 1475.72083, -1611.63062, 13.86010,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19056, 1475.68054, -1614.76990, 13.86010,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19057, 1478.87891, -1614.90808, 13.86010,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19076, 2227.75122, -1743.38354, 12.28249,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19121, 1874.61377, -1163.86682, 23.45691,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19122, 1874.61646, -1165.32300, 23.45690,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19123, 1874.61377, -1166.79199, 23.45690,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19123, 1874.61377, -1168.23096, 23.45690,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19124, 1874.61377, -1169.70654, 23.45690,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19124, 1874.61377, -1171.38977, 23.45690,   0.00000, 0.00000, 0.00000);
}
