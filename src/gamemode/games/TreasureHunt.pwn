/// @file      TreasureHunt.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-02-17 18:46:54 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

// Treasure hunts
// TREASURE_HUNT_ENABLED

static iHuntLocation;
static iHuntPickup;
static Text3D: lHunt;
static Float: fTreasureHuntLS[][3] = {
    {1960.2137, -2217.3774, 15.9568},
    {2187.6745, -2243.6426, 15.8091},
    {2238.0894, -2277.6880, 13.3484},
    {2214.2674, -2661.5982, 13.8590},
    {2399.8716, -2577.5525, 16.3010},
    {2754.2329, -2435.6841, 13.7978},
    {2608.6619, -2225.5957, 13.1711},
    {2401.7324, -2126.1890, 13.3471},
    {2377.8865, -2015.6016, 14.6299},
    {2630.8958, -2117.9302, 13.3478},
    {2581.2290, -2202.6245, -0.2264},
    {2448.8958, -1973.9634, 13.1430},
    {2782.5544, -2018.8511, 13.7336},
    {2756.4746, -1753.5061, 43.9728},
    {2400.2161, -1549.9372, 27.9584},
    {2411.7003, -1335.8571, 24.8646},
    {2505.5430, -1244.3645, 35.3138},
    {2695.1636, -1196.2046, 69.6141},
    {2810.5736, -1087.6971, 30.6525},
    {2571.0117,  -866.7877, 82.7926},
    {2282.4705, -1113.7874, 37.9675},
    {2174.4790, -1082.6249, 35.3070},
    {2130.2095, -1201.4202, 27.7235},
    {2335.0769, -1242.5529, 22.3985},
    {2428.8052, -1672.0643, 13.6064},
    {2296.4006, -1695.6879, 13.2777},
    {2298.9163, -1785.3341, 13.5463},
    {2461.3967, -1776.8645, 13.3584},
    {2271.5842, -1937.5630, 13.5235},
    {2159.2417, -1931.6499, 15.6527},
    {2152.0684, -1733.1386, 16.8497},
    {2167.8940, -1611.0094, 14.1252},
    {2225.5757, -1344.3237, 23.7299},
    {2167.9429, -1497.1779, 23.7488},
    {2244.4006, -1433.5320, 24.6658},
    {2040.6584, -1776.5822, 13.1276},
    {2069.7941, -1558.2106, 13.2282},
    {1965.1936, -1658.4733, 15.5631},
    {1886.8010, -1587.8002, 28.6428},
    {1880.7976, -1862.1460, 13.3198},
    {1883.1997, -1984.3091, 13.1506},
    {1907.8893, -2101.5386, 13.2411},
    {1680.7874, -1984.1715, 21.7433},
    {1576.5447, -1527.9924, 13.1573},
    {1519.8601, -1424.1885, 30.7527},
    {1528.2839, -1215.7174, 19.7297},
    {1428.0549, -1087.8138, 17.3509},
    {1211.4437,  -984.5481, 43.0729},
    {1212.8967, -1104.6381, 24.7840},
    {1144.7075, -1179.5328, 31.5684},
    { 985.8716, -1272.4037, 14.6482},
    {1044.5817,  -900.2691, 42.1471},
    {1047.7111, -1011.5649, 42.3537},
    { 815.8367, -1096.8662, 25.3871},
    { 699.7662, -1352.4313, 28.7605},
    { 555.5969, -1271.6664, 17.0126},
    { 484.1330, -1499.8173, 20.4901},
    { 659.7523, -1547.1627, 15.0274},
    { 728.7440, -1702.7544, 0.7895},
    { 664.8303, -1869.6808, 5.0026},
    { 234.6915, -1824.0728, 3.5287},
    {1165.8484, -1883.2074, 13.3700},
    {1191.8359, -1662.8718, 13.2907},
    {1129.7522, -1488.9156, 22.3066},
    {1373.5583, -1666.4768, 13.6744},
    {1621.5256, -1857.7988, 13.1420}
};
enum eTreasureQA
{
    TQA_Question[64],
    TQA_Answers[256],
    TQA_CorrectAnswer,
};

new TreasureQA[][eTreasureQA] = {
    {
        /*Max*Answer*Length********************************/
        "Subtract 457 from 832",
        "A. 57\n"\
        "B. 375\n"\
        "C. 376\n"\
        "D. 970",
        1
    },
    {
        "Solve : 200 - 96 / 4",
        "A. 105\n"\
        "B. 176\n"\
        "C. 26\n"\
        "D. 16",
        1
    },
    {
        "Simplify :150 / (6 + 3 x 8) - 5",
        "A. 2\n"\
        "B. 5\n"\
        "C. 0\n"\
        "D. None of these",
        2
    },
    {
        "10001 - 101 = ?",
        "A. 1001\n"\
        "B. 990\n"\
        "C. 9990\n"\
        "D. 9900",
        3
    },
    {
        "How many countries in arab world?",
        "A. 20\n"\
        "B. 21\n"\
        "C. 22\n"\
        "D. 23",
        2
    },
    {
        "Where is the dead sea?",
        "Jordan\n"\
        "Palestine\n"\
        "All the answer are correct",
        2
    },
    {
        "What is Nordo's popular song?",
        "3arbouch\n"\
        "Ya 3arraf\n"\
        "Ma Nabni\n"\
        "El Wa7ch Kleni",
        0
    },
    {
        "When was the physicist Albert Einstein born?",
        "December 25th, 2011\n"\
        "March 14th, 1879\n"\
        "April 18th, 1955\n"\
        "January 4th, 1804",
        1
    },
    {
        "What symbol is used for hashtags on Facebook?",
        "#\n"\
        "$\n"\
        "*\n"\
        "&",
        0
    },
    {
        "What was the date the server opened? (EU timezone)",
        "January 14th\n"\
        "January 16rd\n"\
        "January 28th\n"\
        "January 29th",
        3
    },
    {
        "Who is the producer of the game GTA?",
        "Ubisoft\n"\
        "Eidos\n"\
        "E-Arts\n"\
        "Rockstar",
        3
    },
    {
        "Which company developed the iPhone?",
        "Grapefruit\n"\
        "Orange\n"\
        "Apple\n"\
        "BlackBerry",
        2
    },
    {
        "What is the best rapper in arabic world?",
        "Mohamed Ramadan\n"\
        "Balti\n"\
        "Muslim\n"\
        "Mok Saib",
        1
    },
    {
        "Where Altair in Assassin's Creed was born?",
        "Jerusalem\n"\
        "Masyaf\n"\
        "Rome\n"\
        "Sapienza",
        1
    }
};

CMD:gotohuntpos(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_4) && IsAdminOnDuty(playerid))
    {
        SetPlayerPos(playerid, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2]);
        SendClientMessage(playerid, COLOR_WHITE, "You have teleported to the treasure hunt location.");
    }
    return 1;
}

CMD:resethuntpos(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_4) && IsAdminOnDuty(playerid))
    {
        SetRandomHuntPos();
        SendClientMessage(playerid, COLOR_WHITE, "You have reset the treasure hunt location.");
    }
    return 1;
}

hook OnNewHour(timestamp, hour)
{
    SetRandomHuntPos();
    return 1;
}

stock SetRandomHuntPos()
{
    iHuntLocation = random(sizeof(fTreasureHuntLS));

    DestroyDynamicPickup(iHuntPickup);
    DestroyDynamic3DTextLabel(lHunt);
    iHuntPickup = CreateDynamicPickup(1279, 1, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2], 0);
    lHunt = CreateDynamic3DTextLabel("Treasure Hunt\nEnter the pickup!\n/huntanswer", COLOR_YELLOW,
                fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2] + 0.5, 20.0,
                INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
    SendClientMessageToAllEx(COLOR_GREEN, "Treasure hunt has been moved to a new place find it to get your prize!");
    return 1;
}

stock AskHuntQuestion(playerid)
{
    if (!IsPlayerConnected(playerid))
        return 0;


    SendClientMessage(playerid, COLOR_WHITE, "To unlock the prize, you must answer a question. If you get the answer wrong, the treasure will be moved before you have a chance to try again.");
    new questionid = random(sizeof(TreasureQA));
    SetPVarInt(playerid, "HuntQ", questionid);
    Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST,
                TreasureQA[questionid][TQA_Question],
                TreasureQA[questionid][TQA_Answers], "OK", "Cancel");

    return 1;
}

Dialog:TreasureHuntQuestion(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        if (!IsPlayerNearPoint(playerid, 5.0, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2], 0, 0))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "You are not near a hunt treasure.");
        }

        if (TreasureQA[GetPVarInt(playerid, "HuntQ")][TQA_CorrectAnswer] == listitem)
        {
            //Winner
            Dialog_Show(playerid, TreasureHuntPrize, DIALOG_STYLE_LIST, "Treasure Hunt Prize Selection",
                "80 Weed & 40 Cocaine\n"\
                "10,000 materials\n"\
                "M4 + Desert Eagle\n"\
                "2 respect point", "OK", "Cancel");
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "TREASURE HUNT: Wrong answer treasure was hidden in another place!");
        }
        SetRandomHuntPos();
    }
    else if (response)
    {
        DeletePVar(playerid, "fT");
    }
    return 1;
}

Dialog:TreasureHuntPrize(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        switch (listitem)
        {
            case 0:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: 80 Weed & 40 Cocaine");
                SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got 80 Weed & 40 Cocaine.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got 80 Weed & 40 Cocaine.", GetPlayerNameEx(playerid));
                PlayerData[playerid][pWeed] += 80;
                PlayerData[playerid][pCocaine] += 40;

                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got 80 Weed & 40 Cocaine.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
            case 1:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: 10,000 materials");
                SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got 10,000 materials.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got 10,000 materials.", GetPlayerNameEx(playerid));
                PlayerData[playerid][pMaterials] += 10000;

                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got 10,000 materials.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
            case 2:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: M4 + Deagle");
                SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got a M4 + Deagle.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got a M4 + Deagle.", GetPlayerNameEx(playerid));
                GivePlayerWeaponEx(playerid, 24);
                GivePlayerWeaponEx(playerid, 31);

                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got a M4 + Deagle.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
            case 3:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: 2 respect point");
                SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got 2 respect point.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got 2 respect point.", GetPlayerNameEx(playerid));
                PlayerData[playerid][pEXP] += 2;

                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got 2 respect point.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
        }
    }
    return 1;
}

hook OnGameModeInit(playerid)
{
    SetRandomHuntPos();
    return 1;
}

hook OnPlayerPickUpPickup(playerid, pickupid)
{
    if (iHuntPickup == pickupid && GetPVarInt(playerid, "fT") == 0 && !IsAdminOnDuty(playerid, false))
    {
        AskHuntQuestion(playerid);
        SetPVarInt(playerid, "fT", 1);
    }
    return 1;
}

CMD:huntanswer(playerid, params[])
{
    if (!IsPlayerNearPoint(playerid, 5.0, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2], 0, 0))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "You are not near a hunt treasure.");
    }
    AskHuntQuestion(playerid);
    return 1;
}
