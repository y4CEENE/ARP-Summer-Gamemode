/// @file      PrisonInfo.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


new const Float:cellPositions[][] =
{
    {1205.69995117, -1328.09997559, 797.00000000, 1205.699951, -1326.500000, 797.000000},
    {1205.69995117, -1331.30004883, 797.00000000, 1205.699951, -1329.700073, 797.000000},
    {1205.69995117, -1331.30004883, 800.50000000, 1205.699951, -1329.700073, 800.500000},
    {1205.69995117, -1328.09997559, 800.50000000, 1205.699951, -1326.500000, 800.500000},
    {1215.30004883, -1328.09997559, 797.00000000, 1215.300048, -1326.500000, 797.000000},
    {1215.30004883, -1331.30004883, 797.00000000, 1215.300048, -1329.700073, 797.000000},
    {1215.30004883, -1331.30004883, 800.50000000, 1215.300048, -1329.700073, 800.500000},
    {1215.30004883, -1328.09997559, 800.50000000, 1215.300048, -1326.500000, 800.500000},
    {1215.30004883, -1334.50000000, 797.00000000, 1215.300048, -1332.900024, 797.000000},
    {1215.29980469, -1337.69921875, 797.00000000, 1215.299804, -1336.099243, 797.000000},
    {1215.30004883, -1340.90002441, 797.00000000, 1215.300048, -1339.300048, 797.000000},
    {1215.30004883, -1340.90002441, 800.50000000, 1215.300048, -1339.300048, 800.500000},
    {1215.30004883, -1337.69995117, 800.50000000, 1215.300048, -1336.099975, 800.500000},
    {1215.30004883, -1334.50000000, 800.50000000, 1215.300048, -1332.900024, 800.500000},
    {1205.69995117, -1334.50000000, 800.50000000, 1205.699951, -1332.900024, 800.500000},
    {1205.69995117, -1337.69995117, 800.50000000, 1205.699951, -1336.099975, 800.500000},
    {1205.69995117, -1340.90002441, 800.50000000, 1205.699951, -1339.300048, 800.500000},
    {1205.69995117, -1334.50000000, 797.00000000, 1205.699951, -1332.900024, 797.000000},
    {1205.69995117, -1337.69995117, 797.00000000, 1205.699951, -1336.099975, 797.000000},
    {1205.69995117, -1340.90002441, 797.00000000, 1205.699951, -1339.300048, 797.000000},
    {1215.30004883, -1344.09997559, 800.50000000, 1215.300048, -1342.500000, 800.500000},
    {1215.30004883, -1344.09997559, 797.00000000, 1215.300048, -1342.500000, 797.000000},
    {1205.69995117, -1344.09997559, 800.50000000, 1205.699951, -1342.500000, 800.500000},
    {1205.69995117, -1344.09997559, 797.00000000, 1205.699951, -1342.500000, 797.000000}
};

new const Float:cellSpawns[][] =
{
    {2013.1333, -2032.6598, 868.2566, 270.0000},
    {2019.1366, -2023.2676, 868.2566, 180.0000},
    {2028.5752, -2041.0040, 868.2516,   0.0000},
    {2031.9421, -2023.6248, 868.2516, 180.0000}
};

new const Float:AdminPrisonFloat[18][3] = {
    {215.664749, 1806.403198, 1618.534423},
    {211.635513, 1806.531005, 1618.534423},
    {207.159301, 1806.923339, 1618.535888},
    {201.544662, 1806.452758, 1618.535888},
    {197.230133, 1806.381225, 1618.535888},
    {193.142883, 1806.796752, 1618.535888},
    {215.664749, 1806.403198, 1614.260375},
    {211.635513, 1806.531005, 1614.260375},
    {207.159301, 1806.923339, 1614.260375},
    {201.544662, 1806.452758, 1614.260375},
    {197.230133, 1806.381225, 1614.260375},
    {193.142883, 1806.796752, 1614.260375},
    {215.664749, 1806.403198, 1609.985473},
    {211.635513, 1806.531005, 1609.985473},
    {207.159301, 1806.923339, 1609.985473},
    {201.544662, 1806.452758, 1609.985473},
    {197.230133, 1806.381225, 1609.985473},
    {193.142883, 1806.796752, 1609.985473}
};

new const Float:arrestPoints[][] =
{
    { 1229.3544, -1311.8627, 796.7859}, // PD interior
    { 1528.5728, -1677.8324,   5.8906}, // PD garage
    { 1564.6931, -1662.1338,  28.3956}, // PD roof
    {  310.3752, -1515.3691,  24.9219}, // FBI garage
    { 1382.0898, -1393.6364, -33.7034}, // army garage
    { 2755.8171, -2515.4490,  13.6398}, // army hq
    {-1605.5806,   674.8765,  -5.2422}, // sfpd garage
    { 1153.9830, 2974.9168, 1003.4802}  // precinct
};

GetPlayerJailTypeStr(playerid)
{
    new jailtype[32];
    switch (PlayerData[playerid][pJailType])
    {
        case JailType_None:      jailtype = "None";
        case JailType_OOCJail:   jailtype = "OOC jail";
        case JailType_OOCPrison: jailtype = "OOC prison";
        case JailType_ICPrison:  jailtype = "IC prison";
        default:                 jailtype = "Unknown";
    }
    return jailtype;
}

SpawnPlayerInJail(playerid)
{
    if (PlayerData[playerid][pJailType] != JailType_None)
    {
        ResetPlayerWeaponsEx(playerid);
        ResetPlayer(playerid);
    }

    if (PlayerData[playerid][pJailType] == JailType_OOCJail) // OOC jail
    {
        new rand = random(sizeof(AdminPrisonFloat));
        SetFreezePos(playerid, AdminPrisonFloat[rand][0], AdminPrisonFloat[rand][1], AdminPrisonFloat[rand][2]);

        SetPlayerFacingAngle(playerid, 0.0000);
        SetPlayerInterior(playerid, 69);
        SetPlayerVirtualWorld(playerid, 99999);
        SetCameraBehindPlayer(playerid);
    }
    else if (PlayerData[playerid][pJailType] == JailType_OOCPrison) // OOC prison
    {
        new rand = random(sizeof(AdminPrisonFloat));
        SetFreezePos(playerid, AdminPrisonFloat[rand][0], AdminPrisonFloat[rand][1], AdminPrisonFloat[rand][2]);
        SetPlayerFacingAngle(playerid, 36.0000);
        SetPlayerInterior(playerid, 69);
        SetPlayerVirtualWorld(playerid, 99999);
        SetCameraBehindPlayer(playerid);
    }
    else if (PlayerData[playerid][pJailType] == JailType_ICPrison) // IC prison
    {
        new index = random(sizeof(cellSpawns));

        SetFreezePos(playerid, cellSpawns[index][0], cellSpawns[index][1], cellSpawns[index][2]);
        SetPlayerFacingAngle(playerid, cellSpawns[index][3]);
        SetPlayerInterior(playerid, 2);
        SetPlayerVirtualWorld(playerid, GetStaticEntranceWorld("Police department"));
        SetCameraBehindPlayer(playerid);
    }
}

SetPlayerInJail(playerid, JailType:type, time, const reason[], const jailedBy[] = SERVER_ANTICHEAT)
{
    PlayerData[playerid][pJailType] = type;
    PlayerData[playerid][pJailTime] = time;
    strcpy(PlayerData[playerid][pJailedBy], jailedBy, MAX_PLAYER_NAME);
    strcpy(PlayerData[playerid][pJailReason], reason, 128);

    SpawnPlayerInJail(playerid);

    DBFormat("UPDATE "#TABLE_USERS" SET "\
        "jailtype = %d, jailtime = %d"\
        ", prisonedby = '%e', prisonreason = '%e'",
      _:PlayerData[playerid][pJailType],
        PlayerData[playerid][pJailTime],
        PlayerData[playerid][pJailedBy],
        PlayerData[playerid][pJailReason]);

    if (PlayerData[playerid][pJailType] == JailType_ICPrison)
    {
        PlayerData[playerid][pWantedLevel] = 0;
        PlayerData[playerid][pNotoriety] = 0;
        PlayerData[playerid][pArrested]++;
        DBContinueFormat(", wantedlevel = 0, notoriety = 0, arrested = %i", PlayerData[playerid][pArrested]);
    }

    DBContinueFormat(" WHERE uid = %i", PlayerData[playerid][pID]);
    DBExecute();

    if (PlayerData[playerid][pJailType] == JailType_ICPrison)
    {
        DBQuery("UPDATE criminals SET served = 1 WHERE player = '%e';", GetPlayerNameEx(playerid));
        DBQuery("DELETE FROM charges WHERE uid = %i", PlayerData[playerid][pID]);
    }
    new str[64];
    format(str, sizeof(str), "~w~Welcome to~n~~r~%s", GetPlayerJailTypeStr(playerid));
    GameTextForPlayer(playerid, str, 5000, 3);
}
