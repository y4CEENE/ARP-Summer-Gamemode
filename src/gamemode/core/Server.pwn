/// @file      Server.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

stock LoadDatabase()
{
    new Node:mysqlConfig;
    GetServerConfig("mysql", mysqlConfig);
    new mysqlHostname[128];
    new mysqlUsername[128];
    new mysqlPassword[128];
    new mysqlDatabase[128];
    new bool:autoReconnect;
    new poolSize;
    new port;
    if (JSON_GetString(mysqlConfig, "hostname",       mysqlHostname)) { err("Cannot get mysql key 'hostname'");       return 0; }
    if (JSON_GetString(mysqlConfig, "username",       mysqlUsername)) { err("Cannot get mysql key 'username'");       return 0; }
    if (JSON_GetString(mysqlConfig, "password",       mysqlPassword)) { err("Cannot get mysql key 'password'");       return 0; }
    if (JSON_GetString(mysqlConfig, "database",       mysqlDatabase)) { err("Cannot get mysql key 'database'");       return 0; }
    if (JSON_GetInt   (mysqlConfig, "port",           port))          { err("Cannot get mysql key 'port'");           return 0; }
    if (JSON_GetInt   (mysqlConfig, "pool_size",      poolSize))      { err("Cannot get mysql key 'pool_size'");      return 0; }
    if (JSON_GetBool  (mysqlConfig, "auto_reconnect", autoReconnect)) { err("Cannot get mysql key 'auto_reconnect'"); return 0; }
    if (!DBConnect(mysqlHostname, mysqlUsername, mysqlPassword, mysqlDatabase, port, poolSize, autoReconnect))
    {
        return 0;
    }
    return 1;
}

hook OnGameModeInit()
{
    printf("Using SAMP_INCLUDES_VERSION: %d", SAMP_INCLUDES_VERSION);

    new hour, minute, second, timestamp;
    timestamp = gettime(hour, minute, second);

    if (!LoadServerConfig())
    {
        SendRconCommand("exit");
        return 0;
    }

 // Default values, don't touch them
    SetGameModeText("Loading...");
    new weburl[256];
    format(weburl, sizeof(weburl), "weburl %s", GetServerWebsite());
    SendRconCommand(weburl);
    printf( "%s is loading...", GetServerName());

    if (!LoadDatabase())
    {
        SendRconCommand("exit");
        return 0;
    }

    //spawn vehicles
    CreateVehicle(421, 1559.9244, -2338.5549, 13.3744, 89.7600, -1, -1, 100);
    CreateVehicle(421, 1559.9818, -2331.9814, 13.3744, 89.7600, -1, -1, 100);
    CreateVehicle(436, 1559.8101, -2335.2644, 13.2537, 89.5200, -1, -1, 100);
    CreateVehicle(576, 1560.0779, -2328.6450, 13.1204, 89.7600, -1, -1, 100);
    CreateVehicle(576, 1559.9822, -2325.3567, 13.1204, 90.1800, -1, -1, 100);
    CreateVehicle(576, 1560.1245, -2321.9968, 13.1204, 90.1800, -1, -1, 100);
    CreateVehicle(576, 1560.3719, -2318.7837, 13.1204, 90.1800, -1, -1, 100);
    CreateVehicle(576, 1560.3429, -2315.4192, 13.1204, 90.1800, -1, -1, 100);
    CreateVehicle(576, 1560.3474, -2312.2234, 13.1204, 90.1800, -1, -1, 100);


    for (new i = 0; i < MAX_VEHICLES; i ++)
    {
        ResetVehicle(i);
    }

    DBQuery("TRUNCATE TABLE shots");
    DBQueryWithCallback("SELECT * FROM houses", "OnLoadHouses");
    DBQueryWithCallback("SELECT * FROM garages", "OnLoadGarages");
    DBQueryWithCallback("SELECT * FROM businesses", "OnLoadBusinesses");
    DBQueryWithCallback("SELECT * FROM entrances", "OnLoadEntrances");
    DBQueryWithCallback("SELECT * FROM factions", "OnLoadFactions");
    DBQueryWithCallback("SELECT * FROM factionranks", "OnLoadFactionRanks");
    DBQueryWithCallback("SELECT * FROM factionskins", "OnLoadFactionSkins");
    DBQueryWithCallback("SELECT * FROM factionpay", "OnLoadFactionPay");
    DBQueryWithCallback("SELECT * FROM divisions", "OnLoadFactionDivisions");
    DBQueryWithCallback("SELECT * FROM lands", "OnLoadLands");
    DBQueryWithCallback("SELECT * FROM landobjects ORDER BY landid ASC", "OnLoadLandObjects");
    DBQueryWithCallback("SELECT * FROM vehicles WHERE ownerid = 0", "OnLoadVehicles");
    DBQueryWithCallback("select *, (select count(*) from users where users.gang=gangs.id) as count, COALESCE((select username from users where users.uid=gangs.leaderid), 'No-One') as leader from gangs", "OnLoadGangs");
    DBQueryWithCallback("SELECT * FROM gangranks", "OnLoadGangRanks");
    DBQueryWithCallback("SELECT * FROM gangskins", "OnLoadGangSkins");
    DBQueryWithCallback("SELECT * FROM turfs", "OnLoadTurfs");
    DBQueryWithCallback("SELECT * FROM factionlockers", "OnLoadLockers");
    DBQueryWithCallback("SELECT * FROM locations", "OnLoadLocations");
    DBQueryWithCallback("SELECT * FROM crews", "OnLoadCrews");
    DBQueryWithCallback("SELECT * FROM rp_atms", "OnLoadAtms");
    DBQueryWithCallback("SELECT * FROM rp_dealercars", "OnLoadDealershipCars");
    DBQueryWithCallback("SELECT * FROM rp_payphones", "OnLoadPayphones");
    DBQueryWithCallback("SELECT * FROM rp_gundamages", "OnLoadGunDamages");
    DBQueryWithCallback("UPDATE "#TABLE_USERS" SET vippackage = 0, viptime = 0 WHERE viptime < UNIX_TIMESTAMP()", "OnSyncRemoveVip");
    CallRemoteFunction("OnLoadDatabase", "i", timestamp);

    gettime(.hour = gWorldTime);
    SetWorldTime(gWorldTime);

    // Timers
    SetTimer("SecondTimer", 1000, true);
    SetTimer("InjuredTimer", 5000, true);
    SetTimerEx("RandomFire", 5400000, true, "i", 1);
    SetTimer("OnPlayerUpdateEx", 1000, true);

    EnableStuntBonusForAll(0);
    DisableInteriorEnterExits();
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 1000);
    Streamer_TickRate(100);
    SetNameTagDrawDistance(30.0);
    ManualVehicleEngineAndLights();

    RefreshTime();
    ResetRobbery();
    LoadPickupsAndText();
    LoadGatesAndCells();

    // Driving test vehicles
    testVehicles[0] = AddStaticVehicleEx(445, 1280.5974, -1795.9840, 13.2733, 180.0000, 1, 1, 10); // test car 1
    testVehicles[1] = AddStaticVehicleEx(445, 1276.2882, -1796.0579, 13.2776,181.8796, 1, 1, 10); // test car 2
    testVehicles[2] = AddStaticVehicleEx(445, 1271.8486, -1796.2174, 13.2694,182.5803, 1, 1, 10); // test car 3
    testVehicles[3] = AddStaticVehicleEx(445, 1267.1357, -1796.2031, 13.2980,181.5889, 1, 1, 10); // test car 4
    testVehicles[4] = AddStaticVehicleEx(445, 1262.5736, -1796.3016, 13.3016,180.8420, 1, 1, 10); // test car 5

    CallRemoteFunction("OnLoadGameMode", "i", timestamp); // seconds since epoc


    UsePlayerPedAnims();


    printf("           _____  _____  _   _ ________   _________ ");
    printf("     /\\   |  __ \\|  __ \\| \\ | |  ____\\ \\ / /__   __|");
    printf("    /  \\  | |__) | |__) |  \\| | |__   \\ V /   | |   ");
    printf("   / /\\ \\ |  _  /|  ___/| . ` |  __|   > <    | |   ");
    printf("  / ____ \\| | \\ \\| |    | |\\  | |____ / . \\   | |   ");
    printf(" /_/    \\_\\_|  \\_\\_|    |_| \\_|______/_/ \\_\\  |_|   ");
    printf("                 ______                             ");
    printf("                |______|                            ");
    printf("                                                      ");

    printf("____________________________________________________");
    printf("| arp_prod by Khalil                                |");
    printf("| Gamemode loaded successfully.                     |");
    printf("____________________________________________________");
    for (new o; o < CountDynamicObjects(); o++)
    {
        if (IsValidDynamicObject(o))
        {
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, o, E_STREAMER_DRAW_DISTANCE, 900.0);
        }
    }
    new count;
    for (new i = 0; i < MAX_OBJECTS; i ++)
    {
        if (IsValidObject(i)) count++;
    }
    printf("[Script] %i objects loaded.", count);
    SetGameModeText(SERVER_SHORT_NAME"-"SERVER_REVISION);

    return 1;
}

hook OnGameModeExit()
{
    DBDisconnect();
    return 1;
}

publish SecondTimer()
{
    new hour, minute, string[128];
    gettime(hour, minute);

    if ((gGMX) && GetNbPendingDBQueries() == 0)
    {
        SendRconCommand("exit");
    }

    foreach(new i : Player)
    {
        //SetPlayerTime(i, hour, minute);

        if (PlayerData[i][pLogged] && !PlayerData[i][pKicked])
        {

            if (GetPlayerSurfingVehicleID(i) != INVALID_PLAYER_ID && GetPlayerState(i) == PLAYER_STATE_ONFOOT && !IsSurfVehicle(GetPlayerSurfingVehicleID(i)) && !PlayerData[i][pAdminDuty] && GetVehicleSpeed(GetPlayerSurfingVehicleID(i)) > 40)
            {
                new Float:x, Float:y, Float:z;
                SendProximityMessage(i, 20.0, COLOR_PURPLE, "* %s slipped off the top of the vehicle.", GetRPName(i));
                GetPlayerPos(i, x, y, z);
                SetPlayerPos(i, x + 1, y, z + 3.0);
                ApplyAnimation(i, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 0, 0);
            }
            if (PlayerData[i][pSpeedTime] > 0)
            {
                PlayerData[i][pSpeedTime]--;
            }
            if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_DRINK_BEER || GetPlayerSpecialAction(i) == SPECIAL_ACTION_DRINK_WINE)
            {
                if (GetPlayerDrunkLevel(i) > 7000)
                {
                    AwardAchievement(i, ACH_PartyHard);
                }
            }
            if (PlayerData[i][pRepairTime] > 0)
            {
                PlayerData[i][pRepairTime]--;

                if (PlayerData[i][pRepairTime] <= 0)
                {
                    if (GetPlayerState(i) == PLAYER_STATE_DRIVER)
                    {
                        new vehicleid = GetPlayerVehicleID(i);

                        foreach(new e : Player)
                        {
                            if (IsPlayerInVehicle(e, vehicleid))
                            {
                                SetCameraBehindPlayer(e);
                            }
                        }

                        SetVehiclePos(vehicleid, g_RepairShops[PlayerData[i][pRepairShop]][7], g_RepairShops[PlayerData[i][pRepairShop]][8], g_RepairShops[PlayerData[i][pRepairShop]][9]);
                        SetVehicleZAngle(vehicleid, g_RepairShops[PlayerData[i][pRepairShop]][10]);
                        SetCameraBehindPlayer(i);

                        RepairVehicle(vehicleid);
                        GameTextForPlayer(i, "~g~Vehicle Repaired", 5000, 1);
                        TogglePlayerControllableEx(i, 1);
                    }

                    PlayerData[i][pRepairShop] = -1;
                }
            }

            if (!PlayerData[i][pToggleTextdraws])
            {
                if (PlayerData[i][pGPSOn])
                {
                    new zonename[256];
                    format(zonename,sizeof(zonename),"%s", GetPlayerZoneName(i));
                    if (strcmp(zonename,"Interior")!=0)
                        PlayerTextDrawSetString(i, PlayerData[i][pGPSText], zonename);
                    else PlayerTextDrawSetString(i, PlayerData[i][pGPSText], "");
                }
            }

            if (NetStats_PacketLossPercent(i) > 20.0 && gettime() - PlayerData[i][pLastDesync] > 120)
            {
                GameTextForPlayer(i, "You are desynced. Please relog once you see this message.", 10000, 6);
                PlayerData[i][pLastDesync] = gettime();
            }
            if (IsPlayerInTutorial(i))
            {
                TogglePlayerControllableEx(i, 0);
            }
            if (PlayerData[i][pAwaitingClothing])
            {
                SetPlayerClothing(i);
            }
            if (PlayerData[i][pDraggedBy] != INVALID_PLAYER_ID)
            {
                TeleportToPlayer(i, PlayerData[i][pDraggedBy]);
            }
            if (PlayerData[i][pDonator] > 0 && gettime() > PlayerData[i][pVIPTime])
            {
                PlayerData[i][pDonator] = 0;
                PlayerData[i][pVIPTime] = 0;
                PlayerData[i][pSecondJob] = -1;

                DBQuery("UPDATE "#TABLE_USERS" SET vippackage = 0, viptime = 0, secondjob = -1 WHERE uid = %i", PlayerData[i][pID]);

                SendClientMessage(i, COLOR_LIGHTRED, "Your VIP subscription has expired. You are no longer a VIP.");
            }
            if (GetMaxPlayerJobs(i) < 2 && PlayerData[i][pSecondJob] != JOB_NONE)
            {
                DBQuery("UPDATE "#TABLE_USERS" SET secondjob = -1 WHERE uid = %i", PlayerData[i][pID]);

                PlayerData[i][pSecondJob] = JOB_NONE;
                SendClientMessage(i, COLOR_LIGHTRED, "Your second job has been removed as you aren't a Gold+ VIP or level25+.");
            }
            if (PlayerData[i][pHHCheck])
            {
                if (PlayerData[i][pHHTime] > 0)
                {
                    new health = GetPlayerHealthEx(i);

                    if (health == PlayerData[i][pHHRounded])
                    {
                        PlayerData[i][pHHCount]++;
                    }

                    SetPlayerHealth(i, random(100) + 1);

                    PlayerData[i][pHHTime]--;
                    PlayerData[i][pHHRounded] = health;
                }
                else
                {
                    if (IsPlayerPaused(i))
                    {
                        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] failed the health hack check as they tabbed.", GetRPName(i), i);
                    }
                    else if (PlayerData[i][pHHCount] > 0)
                    {
                        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly health hacking with a %i percent chance.", GetRPName(i), i, PlayerData[i][pHHCount] * 20);
                    }
                    else
                    {
                        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] does not appear to be health hacking.", GetRPName(i), i);
                    }

                    if (NetStats_PacketLossPercent(i) > 10.0)
                    {
                        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is desynced and has a packet loss of %.1f percent.", GetRPName(i), i, NetStats_PacketLossPercent(i));
                    }

                    SetPlayerHealth(i, PlayerData[i][pHealth]);
                    PlayerData[i][pHHCheck] = 0;
                }
            }
            if (PlayerData[i][pReceivingAid] && !PlayerData[i][pHHCheck])
            {
                new
                    Float:health;

                GetPlayerHealth(i, health);

                if ((health + 1.0) > 100.0)
                {
                    SetPlayerHealth(i, 100.0);
                    PlayerData[i][pReceivingAid] = 0;
                    RevivePlayer(i);
                }
                else
                {
                    SetPlayerHealth(i, health + 1.0);
                }
            }
            if (PlayerData[i][pInjured] )
            {
                new vehicleid = GetPlayerVehicleID(i);

                if (IsPlayerInAnyVehicle(i) && !(VehicleInfo[vehicleid][vFaction] > -1 && FactionInfo[VehicleInfo[vehicleid][vFaction]][fType] == FACTION_MEDIC))
                {
                    new
                        Float:x,
                        Float:y,
                        Float:z;
                    GetPlayerPos(i, x, y, z);
                    SetPlayerPos(i, x, y, z + 0.5);
                    ClearAnimations(i);
                }
            }
            if (PlayerData[i][pTazedTime] > 0)
            {
                PlayerData[i][pTazedTime]--;

                if (!PlayerData[i][pTazedTime])
                {
                    ClearAnimations(i, 1);

                    if (!PlayerData[i][pCuffed])
                    {
                        TogglePlayerControllableEx(i, 1);
                    }
                }
            }
            if (PlayerData[i][pFishTime] > 0)
            {
                PlayerData[i][pFishTime]--;

                if (!IsPlayerAtFishingPlace(i))
                {
                    ClearAnimations(i, 1);
                    RemovePlayerAttachedObject(i, 9);
                    PlayerData[i][pFishTime] = 0;
                }
                else if (PlayerData[i][pFishTime] <= 0 && IsPlayerAtFishingPlace(i))
                {
                    new rand = Random(1, 100);

                    if (1 <= rand <= 20)
                    {
                        SendClientMessage(i, COLOR_GREY, "You reeled in your line and caught nothing...");
                    }
                    else if (21 <= rand <= 30)
                    {
                        new amount = 50 + random(100);

                        SendClientMessageEx(i, COLOR_AQUA, "You reeled in your line and caught a used wallet with {00AA00}$%i{33CCFF} inside.", amount);
                        GivePlayerCash(i, amount);
                    }
                    else if (98 <= rand <= 99)
                    {
                        new amount = random(2000) + 1000;

                        SendClientMessageEx(i, COLOR_AQUA, "You reeled in your line and caught a rare 18th century coin valued at {00AA00}$%i{33CCFF}!", amount);
                        GivePlayerCash(i, amount);
                    }
                    else
                    {
                        new weight, level = GetJobLevel(i, JOB_FISHERMAN);

                        if (PlayerData[i][pUsedBait])
                        {
                            weight = random(40) + (level * 10);
                        }
                        else
                        {
                            weight = random(15) + (level * 10);
                        }

                        SendClientMessageEx(i, COLOR_AQUA, "You reeled in your line and caught an Anchovy weighing %i g!", weight);
                        PlayerData[i][pFishWeight] += weight;

                        DBQuery("UPDATE "#TABLE_USERS" SET fishweight = %i WHERE uid = %i", PlayerData[i][pFishWeight], PlayerData[i][pID]);

                        IncreaseJobSkill(i, JOB_FISHERMAN);

                        if (PlayerData[i][pFishWeight] >= 1500)
                        {
                            SendClientMessage(i, COLOR_YELLOW, "You have too much fish. You can continue fishing once you sell your load.");
                        }
                    }

                    ClearAnimations(i, 1);
                    RemovePlayerAttachedObject(i, 9);
                }
            }
            if (PlayerData[i][pJailType] != JailType_None)
            {
                PlayerData[i][pJailTime]--;

                if (PlayerData[i][pJailTime] <= 0)
                {
                    ResetPlayerWeaponsEx(i);

                    SendClientMessage(i, COLOR_GREY2, "Your jail sentence has expired.");
                    SetPlayerPos(i, 1544.4407, -1675.5522, 13.5584);
                    SetPlayerFacingAngle(i, 90.0000);
                    SetPlayerInterior(i, 0);
                    SetPlayerVirtualWorld(i, 0);
                    SetCameraBehindPlayer(i);

                    PlayerData[i][pJailType] = JailType_None;
                    PlayerData[i][pJailTime] = 0;
                }
            }
            if (PlayerData[i][pEditType] > 0 && IsValidDynamicObject(PlayerData[i][pEditObject]) && !IsPlayerInRangeOfDynamicObject(i, PlayerData[i][pEditObject], 50.0))
            {
                if (PlayerData[i][pEditType] == EDIT_LAND_OBJECT)
                {
                    ReloadLandObject(PlayerData[i][pEditObject], LandInfo[PlayerData[i][pObjectLand]][lLabels]);
                    SendClientMessage(i, COLOR_GREY2, "You left the editing area. Editing mode has been disabled.");
                }
                else if (PlayerData[i][pEditType] == EDIT_LAND_OBJECT_PREVIEW)
                {
                    SendClientMessage(i, COLOR_GREY2, "You left the editing area. Furniture previewing cancelled.");
                    DestroyDynamicObject(PlayerData[i][pEditObject]);
                }

                CancelEdit(i);

                PlayerData[i][pEditType] = 0;
                PlayerData[i][pEditObject] = INVALID_OBJECT_ID;
            }

            if (PlayerData[i][pMuted] > 0)
            {
                PlayerData[i][pMuted]--;

                if (PlayerData[i][pMuted] <= 0)
                {
                    SendClientMessage(i, COLOR_GREY, "You are no longer muted.");
                }
            }
            if (PlayerData[i][pSpamTime] > 0)
            {
                PlayerData[i][pSpamTime]--;
            }
            if (PlayerData[i][pVehicleCount] > 0)
            {
                PlayerData[i][pVehicleCount]--;
            }
            if (PlayerData[i][pMechanicCall] > 0)
            {
                PlayerData[i][pMechanicCall]--;
            }
            if (PlayerData[i][pTaxiCall] > 0)
            {
                PlayerData[i][pTaxiCall]--;
            }
            if (PlayerData[i][pEmergencyCall] > 0)
            {
                PlayerData[i][pEmergencyCall]--;
            }
            if (PlayerData[i][pDetectiveCooldown] > 0)
            {
                PlayerData[i][pDetectiveCooldown]--;
            }
            if (PlayerData[i][pThiefCooldown] > 0)
            {
                PlayerData[i][pThiefCooldown]--;
            }
            if (PlayerData[i][pCocaineCooldown] > 0)
            {
                PlayerData[i][pCocaineCooldown]--;
            }
            if (PlayerData[i][pRapidFire] > 0)
            {
                PlayerData[i][pRapidFire]--;
            }
            if (PlayerData[i][pGodmode] > 0)
            {
                PlayerData[i][pGodmode]--;
            }
            if (PlayerData[i][pPreviewHouse] >= 0)
            {
                PlayerData[i][pPreviewTime]--;

                if (PlayerData[i][pPreviewTime] <= 0 && GetPlayerInterior(i) == houseInteriors[PlayerData[i][pPreviewType]][intID])
                {
                    SetPlayerPos(i, HouseInfo[PlayerData[i][pPreviewHouse]][hIntX], HouseInfo[PlayerData[i][pPreviewHouse]][hIntY], HouseInfo[PlayerData[i][pPreviewHouse]][hIntZ]);
                    SetPlayerFacingAngle(i, HouseInfo[PlayerData[i][pPreviewHouse]][hIntA]);
                    SetPlayerInterior(i, HouseInfo[PlayerData[i][pPreviewHouse]][hInterior]);
                    SetPlayerVirtualWorld(i, HouseInfo[PlayerData[i][pPreviewHouse]][hWorld]);
                    SetCameraBehindPlayer(i);

                    PlayerData[i][pPreviewHouse] = -1;
                    PlayerData[i][pPreviewType] = 0;
                    PlayerData[i][pPreviewTime] = 0;

                    SendClientMessage(i, COLOR_WHITE, "You are no longer previewing the interior as the time period ran out.");
                }
            }

            if (PlayerData[i][pDrugsUsed] >= 4)
            {
                PlayerData[i][pDrugsTime]--;

                if (PlayerData[i][pDrugsTime] <= 0)
                {
                    SendClientMessage(i, COLOR_GREY, "You are no longer stoned.");
                    SetPlayerWeather(i, GetDBWeatherID());

                    SetPlayerTime(i, gWorldTime, 0);
                    SetPlayerDrunkLevel(i, 500);

                    PlayerData[i][pDrugsUsed] = 0;
                    PlayerData[i][pDrugsTime] = 0;
                }
                else
                {
                    SetPlayerWeather(i, -66);
                    SetPlayerTime(i, 12, 0);
                    SetPlayerDrunkLevel(i, 40000);
                }
            }
            if (PlayerData[i][pPoisonTime] > 0)
            {
                new Float:health;
                GetPlayerHealth(i, health);
                SetPlayerHealth(i, health - 3.0 < 1.0 ? 1.0 : health - 3.0);
                PlayerData[i][pPoisonTime]--;
            }
        }
    }

    for (new i = 0; i < MAX_ACTORS; i ++)
    {
        if (IsValidActor(i))
        {
            new
                Float:x,
                Float:y,
                Float:z;
            GetActorPos(i, x, y, z);
            SetActorPos(i, x, y, z);
        }
    }

    format(string, sizeof(string), "Chemicals\nStock: %i\nPrice: $60/gram\n/getchems [amount]", gChemicalsStock);
    UpdateDynamic3DTextLabelText(gChemicalsStockText, COLOR_YELLOW, string);
    format(string, sizeof(string), "Weed seeds\nStock: %i\nPrice: $60/seed\n/getseeds [amount]", gSeedsStock);
    UpdateDynamic3DTextLabelText(gSeedsStockText, COLOR_YELLOW, string);
    format(string, sizeof(string), "Cocaine\nStock: %i\nPrice: $60/gram\n/getcocaine [amount]", gCocaineStock);
    UpdateDynamic3DTextLabelText(gCocaineText, COLOR_YELLOW, string);
}

hook OnServerHeartBeat(timestamp)
{
    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged] && !PlayerData[i][pKicked])
        {
            CallRemoteFunction("OnPlayerHeartBeat", "i", i);

            foreach(new j : Player)
            {
                if (PlayerData[j][pLogged] && !PlayerData[j][pKicked])
                {
                    CallRemoteFunction("OnTwoPlayersHeartBeat", "ii", i, j);
                }
            }

            if (IsAntiCheatEnabled() &&
                PlayerData[i][pLogged] &&
                !IsPlayerInTutorial(i) &&
                !PlayerData[i][pKicked] &&
                (gettime() > PlayerData[i][pACTime]) &&
                !IsAdminOnDuty(i, false) &&
                !IsPlayerInEvent(i))
            {
                CallRemoteFunction("OnPlayerAntiCheatCheck", "i", i);
            }
        }
    }
    return 1;
}

hook OnNewMinute(timestamp)
{
    RefreshTime();

    if (GetGangInviteCooldown())
    {
        for (new x = 0; x < MAX_GANGS; x++)
        {
            if (GangInfo[x][gInvCooldown] > 0)
            {
                GangInfo[x][gInvCooldown]--;
            }
        }
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged] && !IsPlayerAFK(i))
        {
            //new amount = 35 * min(PlayerData[i][pLevel], 21);
            //AddToPaycheck(i, amount);

            PlayerData[i][pMinutes]++;
        }
    }


    for (new i = 0; i < MAX_REPORTS; i ++)
    {
        if (ReportInfo[i][rExists] && ReportInfo[i][rTime] > 0)
        {
            ReportInfo[i][rTime]--;

            if (ReportInfo[i][rTime] <= 0 && ReportInfo[i][rAccepted] == 0)
            {
                SendClientMessage(ReportInfo[i][rReporter], COLOR_GREY, "Your report has expired. You can make an admin request on our discord if you still need help.");
                ReportInfo[i][rExists] = 0;
            }
        }
    }
    return 1;
}

hook OnNewHour(timestamp, hour)
{
    SendClientMessageToAllEx(COLOR_WHITE, "%s: The time is now {AFAFAF}%02d:00{FFFFFF}.", GetServerName(), hour);

    switch (hour)
    {
        case 0, 4, 8, 12, 16, 18:
        {
            for (new i = 0; i < MAX_GANGS; i ++)
            {
                if (GangInfo[i][gSetup] && GangInfo[i][gTurfTokens] < 10)
                {
                    GangInfo[i][gTurfTokens]++;

                    DBQuery("UPDATE "#TABLE_GANGS" SET turftokens = turftokens + 1 WHERE id = %i", i);
                }
            }

            for (new i = 0; i < MAX_FACTIONS; i ++)
            {
                if ((FactionInfo[i][fType] == FACTION_POLICE || FactionInfo[i][fType] == FACTION_FEDERAL || FactionInfo[i][fType] == FACTION_ARMY) && FactionInfo[i][fTurfTokens] < 3)
                {
                    FactionInfo[i][fTurfTokens]++;

                    DBQuery("UPDATE "#TABLE_FACTIONS" SET turftokens = turftokens + 1 WHERE id = %i", i);
                }
            }
        }
    }

    SetWorldTime(hour);
    gWorldTime = hour;
    gCharityHealth = 0;
    gCharityArmor = 0;
    return 1;
}

publish FinishServerShutdown()
{
    foreach(new i : Player)
    {
        Kick(i);
    }
    SendRconCommand("exit");
    return 1;
}


LoadPickupsAndText()//TODO: move it
{
    for (new i = 0; i < sizeof(g_RepairShops); i ++)
    {
        CreateDynamicMapIcon(g_RepairShops[i][0], g_RepairShops[i][1], g_RepairShops[i][2], 63, 0, .worldid = 0, .interiorid = 0);
        CreateDynamicPickup(1239, 1, g_RepairShops[i][0], g_RepairShops[i][1], g_RepairShops[i][2]);
        CreateDynamic3DTextLabel("{ffff00}Repair Shop\n{ffffff}Cost: $500\n/enter to repair your vehicle.", COLOR_GREY, g_RepairShops[i][0], g_RepairShops[i][1], g_RepairShops[i][2], 20.0);
    }

    CreateDynamic3DTextLabel("Press Y to use weights", COLOR_GREY, 772.4859, 5.3462, 999.9802, 10.0);
    CreateDynamic3DTextLabel("Press Y to use treadmill", COLOR_GREY, 773.5106, -2.8392, 1000.1479, 10.0);

    // Materials pickup 1
    CreateDynamic3DTextLabel("Materials pickup 1\nCost: $50\n/getmats to begin.", COLOR_YELLOW, 1423.4292,-1319.1487,13.5547, 20.0);
    CreateDynamic3DTextLabel("Materials pickup 2\nCost: $50\n/getmats to begin.", COLOR_YELLOW, 2393.4885, -2008.5726, 13.3467, 20.0);
    // boat run
    CreateDynamic3DTextLabel("Marina Materiasl Depot\nCost: $50\n/getmats to begin.", COLOR_YELLOW, 714.5344, -1565.1694, 1.76807, 40.0);
    CreateDynamicPickup(1318, 1, 714.5344, -1565.1694, 1.7680);

    // plane run
    CreateDynamic3DTextLabel("LSI Materials Depot\nCost: $50\n/getmats to begin.", COLOR_YELLOW, 2112.3240,-2432.8130,13.5469, 40.0);
    CreateDynamicPickup(1318, 1, 2112.3240, -2432.8130, 13.5469);

    //Lumberjack
    CreateDynamic3DTextLabel("{DDFF00}Oak {FFFFFF}tree\n{C1C1C1}To get started, go to the tree",COLOR_WHITE,-1931.063354,-2360.959228,30.820381+0.6,4.0);
    CreateDynamic3DTextLabel("{DDFF00}Oak {FFFFFF}tree\n{C1C1C1}To get started, go to the tree",COLOR_WHITE,-1914.466308,-2369.007685,29.804220+0.6,4.0);
    CreateDynamic3DTextLabel("{DDFF00}Oak {FFFFFF}tree\n{C1C1C1}To get started, go to the tree",COLOR_WHITE,-1903.706787,-2361.488769,31.170394+0.6,4.0);
    CreateDynamic3DTextLabel("{DDFF00}Spruce {FFFFFF}tree\n{C1C1C1}To get started, go to the tree",COLOR_WHITE,-1934.799438,-2243.597412,65.4831+0.6,4.0);
    CreateDynamic3DTextLabel("{DDFF00}Spruce {FFFFFF}tree\n{C1C1C1}To get started, go to the tree",COLOR_WHITE,-1917.573364,-2251.707519,65.8043+0.6,4.0);
    CreateDynamic3DTextLabel("[SIDE JOB]\nLumberjack Job\n Location: Angel Pine",COLOR_YELLOW,-1991.550659, -2389.910644, 30.625000+0.6,4.0);

    // Hospital exit
    CreateDynamic3DTextLabel("(( /exit ))", COLOR_GREY2, -2330.0376,111.4688,-5.3942, 20.0);
    CreateDynamic3DTextLabel("(( /exit ))", COLOR_GREY2, 1595.2653,-1688.3323,5.8906, 20.0, .worldid = 32);

    // /healme
    CreateDynamicPickup(1240, 23, -2299.6079, 123.6063, -5.3468);
    CreateDynamic3DTextLabel("/healme \nTo cure your disease",COLOR_LIGHTRED,-2299.6079,123.6063,-5.3468+0.6,4.0);

    CreateDynamic3DTextLabel("County General\nCost: $2000\n/buyinsurance to spawn here.", COLOR_DOCTOR, -2323.3250,110.9966,-5.3942, 10.0, .worldid = HOSPITAL_COUNTY);
    CreateDynamicPickup(1240, 1, -2323.3250,110.9966,-5.3942, .worldid = HOSPITAL_COUNTY);

    CreateDynamic3DTextLabel("San Fierro Medic Center\nCost: $4000\n/buyinsurance to spawn here.", COLOR_DOCTOR, -2323.3250,110.9966,-5.3942, 10.0, .worldid = HOSPITAL_SAN_FIERRO);
    CreateDynamicPickup(1240, 1, -2323.3250,110.9966,-5.3942, .worldid = HOSPITAL_SAN_FIERRO);

    CreateDynamic3DTextLabel("All Saints Hospital\nCost: $2000\n/buyinsurance to spawn here.", COLOR_DOCTOR, -2323.3250,110.9966,-5.3942, 10.0, .worldid = HOSPITAL_ALLSAINTS);
    CreateDynamicPickup(1240, 1, -2323.3250,110.9966,-5.3942, .worldid = HOSPITAL_ALLSAINTS);

    CreateDynamic3DTextLabel("Loading dock\n/load and pick a load\nto begin delivery.", COLOR_YELLOW, 1766.9261,-2048.9807,13.8355, 10.0);
    CreateDynamicPickup(1239, 1, 1766.9261,-2048.9807,13.8355);

    CreateDynamic3DTextLabel("Garbage Pickup\n/garbage\nto begin delivery.", COLOR_YELLOW, 2404.9758, -2070.3882, 13.5469, 10.0);
    CreateDynamicPickup(1239, 1, 2404.9758, -2070.3882, 13.5469);



    CreateDynamic3DTextLabel("Drivers test\nCost: $500\n/taketest to begin.", COLOR_YELLOW, -2033.2953, -117.4508, 1035.1719, 10.0);
    CreateDynamicPickup(1239, 1, -2033.2953, -117.4508, 1035.1719);

    // Milker
	CreateDynamic3DTextLabel("Milker Job\ntype /buybocket to buy a bocket.", COLOR_YELLOW, 1034.360595, -281.772613, 73.998100, 10.0);
	CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1067.486083, -304.230407, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1066.052612, -299.234252, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1063.673095, -295.457275, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1071.917480, -295.437622, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1075.167724, -302.154174, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1079.390014, -309.615386, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1081.445556, -304.313812, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1071.877929, -308.532379, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1068.574829, -313.870330, 74.008110, 3.0);
    CreateDynamic3DTextLabel("Milker Job\ntype /milk to start the milking.", COLOR_YELLOW, 1062.901489, -308.476959, 74.008110, 3.0);
	CreateDynamic3DTextLabel("Milkman\ntype /sellmilk to sell your milk.",   COLOR_YELLOW, 1082.199340, -365.259033, 74.074180, 10.0);

    /*// Recycle
	CreateDynamic3DTextLabel("Recycle Job\nPress N to start working.", COLOR_YELLOW, -2075.657226, -2438.935058, 30.625000, 5.0);*/

    // BodyCams
    CreateDynamic3DTextLabel("use /watchbodycams\nto watch the officers", COLOR_YELLOW, 3960.052734, 1011.483886, 734.651489, 5.0);
	CreateDynamicPickup(1253, 23, 3960.052734, 1011.483886, 734.651489);

    //SF Paintball
    CreateDynamic3DTextLabel("Paintball arena\n/paintball to play paintball!", COLOR_YELLOW, -1549.7334,1165.4608,7.1875, 10.0);
    CreateDynamicPickup(1254, 1, -1549.7334,1165.4608,7.1875);

    //Ls Paintball
    CreateDynamic3DTextLabel("Paintball arena\n/paintball to play paintball!", COLOR_YELLOW, 1311.7522,-1367.2715,13.53, 10.0);
    CreateDynamicPickup(1254, 1, 1311.7522,-1367.2715,13.53);

    CreateDynamic3DTextLabel("Name changes\nCost: $5000/level\n/changename to request one.", COLOR_YELLOW, 360.7130,176.3916,1008.3828, 10.0);
    CreateDynamicPickup(1239, 1, 360.7130,176.3916,1008.3828);

    CreateDynamic3DTextLabel("Ticket Pay\n/paytickets to pay your vehicle tickets.", COLOR_YELLOW, 1186.8889,-1795.3860,13.5703, 10.0);
    CreateDynamicPickup(1239, 1, 1186.8889,-1795.3860,13.5703);

    CreateDynamic3DTextLabel("Drug smuggling\nCost: $100\n/getcrate to begin smuggling.", COLOR_YELLOW, 2205.9263,1581.7888,999.9827, 10.0);
    CreateDynamicPickup(1279, 1, 2205.9263,1581.7888,999.9827);

    CreateDynamic3DTextLabel("Heroin cookoff\nRequires chems\n/cookheroin to begin cooking.", COLOR_YELLOW, 1.2179, 2.8095, 999.4284, 10.0, .interiorid = 2, .worldid = 10);
    CreateDynamicPickup(1577, 1, 1.2179, 2.8095, 999.4284, .interiorid = 2, .worldid = 10);

    gChemicalsStockText = CreateDynamic3DTextLabel("Chems\nStock: 100\n/getchems [amount]", COLOR_YELLOW, -942.1650,1847.1581,5.0051, 10.0);
    CreateDynamicPickup(1577, 1, -942.1650, 1847.1581, 5.0051);

    gSeedsStockText = CreateDynamic3DTextLabel("Weed seeds\nStock: 100\n/getseeds [amount]", COLOR_YELLOW, 321.8347, 1117.1797, 1083.8828, 10.0);
    CreateDynamicPickup(1578, 1, 321.8347, 1117.1797, 1083.8828);

    gCocaineText = CreateDynamic3DTextLabel("Cocaine\nStock: 100\n/getcocaine [amount]", COLOR_YELLOW, 2342.7766, -1187.0839, 1027.9766, 10.0);
    CreateDynamicPickup(1575, 1, 2342.7766, -1187.0839, 1027.9766);

//  CreateDynamic3DTextLabel("/clothes\nto change your skin.", COLOR_YELLOW, 1826.3379, -1308.8324, 1131.7552, 15.0);

    gParachutes[0] = CreateDynamicPickup(371, 1, 1542.9038, -1353.0352, 329.4744); // Star tower
    gParachutes[1] = CreateDynamicPickup(371, 1, 315.9415, 1010.6052, 1953.0031); // Andromada interior
    // Hospital garage doors

    CreateDynamicObject(10149, 1150.004394, -1345.316284, 14.201147, 0.000000, 0.000000, 270.000000);
    CreateDynamicObject(10149, 2007.520874, -1408.116088, 16.992187, 0.000000, 0.000000, 0.000000);
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 1140.5344, -1326.5345, 13.6328, 10.0);
    CreateDynamicPickup(1240, 1, 1140.5344, -1326.5345, 13.6328);
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 2007.6256, -1410.2455, 16.9922, 10.0);
    CreateDynamicPickup(1240, 1, 2007.6256, -1410.2455, 16.9922);
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, -2684.1162, 626.1478, 14.0291, 10.0);
    CreateDynamicPickup(1240, 1, -2684.1162, 626.1478, 14.0291);
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, -2664.0845, 638.4924, 66.0938, 10.0);
    CreateDynamicPickup(1240, 1, -2664.0845, 638.4924, 66.0938);

    CreateDynamicPickup(1240, 1, 1161.8879,-1358.6638,31.3811); // allsaints roof
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 1161.8879,-1358.6638,31.3811, 10.0);
    CreateDynamicPickup(1240, 1, 2070.4307,-1422.8580,48.3315); // county roof
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 2070.4307,-1422.8580,48.331, 10.0);
    CreateDynamicPickup(1240, 1, 1510.7773,-2151.7322,13.7483); // fmd hq
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 1510.7773,-2151.7322,13.7483, 10.0);
    CreateDynamicPickup(1240, 1, 1480.4819,-2166.9712,35.2578); // hq roof
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 1480.4819,-2166.9712,35.2578, 10.0);
    CreateDynamicPickup(1240, 1, 1539.1060,-2167.2058,35.2578); // hq roof 2
    CreateDynamic3DTextLabel("/deliverpatient\nto drop off a patient.", COLOR_DOCTOR, 1539.1060,-2167.2058,35.2578, 10.0);


    new string[430];
    for (new i = 0; i < sizeof(staticEntrances); i ++)
    {
        format(string, sizeof(string), "{afafaf}[{33CCFF}%s{afafaf}]\nPress '{ff0000}y{afafaf}' to enter.", staticEntrances[i][eName]);

        CreateDynamicPickup(19132, 1, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ]);
        CreateDynamic3DTextLabel(string, COLOR_GREY1, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ], 10.0);

        if (staticEntrances[i][eMapIcon])
        {
            CreateDynamicMapIcon(staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ], staticEntrances[i][eMapIcon], 0);
        }
    }

    for (new i = 0; i < sizeof(arrestPoints); i ++)
    {
        CreateDynamic3DTextLabel("/arrest\nto arrest a suspect.", COLOR_YELLOW, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2], 7.0);
        CreateDynamicPickup(1247, 1, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2]);
    }

    CreateDynamicLabeledPickup(COLOR_AQUA, "Use /sellmycar to sell\nyour vehicle to the dealership.",
                               1442.0000, -2447.5000, 13.6000, 0, 0, 1274, 50.0);
    CreateDynamicLabeledPickup(COLOR_AQUA, "nUse /sellmycar to sell\nyour vehicle to the dealership.",
                                213.0000, -1936.9008,  1.0000, 0, 0, 1274, 50.0);
    CreateDynamicLabeledPickup(COLOR_AQUA, "Use /sellmycar to sell\nyour vehicle to the dealership.",
                                557.4300, -1282.8500, 17.2500, 0, 0, 1274, 50.0);
}

hook OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
    SendAdminMessage(0xFF6347FF, "AdmCmd: A MySQL error occurred (error %i). Details written to mysql_error.txt.", errorid);
}
