#include <YSI\y_hooks>

// Treasure hunts
// TREASURE_HUNT_ENABLED

static iHuntLocation;
static iHuntPickup;
static Text3D: lHunt;
static Float: fTreasureHuntLS[80][3] = {
        {1229.6487, 2656.6077, 10.8203},
        {723.9209, -1827.9728, -11.1979},
        {975.8365, -1553.5372, 21.5021},
        {2838.0945, -2355.9885, 42.7344},
        {2864.8975, -2125.0532, 5.9132},
        {2839.2737, -1333.6603, 11.1132},
        {305.7408, -1348.6904, 53.3819},
        {300.4908, -1343.3966, 60.0211},
        {567.0254, -1368.8667, 52.4344},
        {-574.8304, -1484.6580, 14.3438},
        {-1848.4028, -1708.3975, 41.1117},
        {-84.5177, -102.4145, 6.4844},
        {359.0852, -1401.2878, 20.4090},
        {-406.8927, -1448.9119, 50.9145},
        {2783.3496, -1246.1157, 62.2969},
        {2750.9673, -2261.2080, 42.2668},
        {2423.9233, -2283.6018, 42.4465},
        {2258.9204, -2458.7249, 42.1496},
        {1627.6660, -2286.4536, 94.1270},
        {680.0054, 824.4684, -42.9609},
        {-84.7650, -223.2539, 80.1250},
        {-1062.0853, -696.3816, 56.3359},
        {-744.2923, -796.8502, 152.1255},
        {-609.9691, -789.1779, 79.9550},
        {1019.3333, -301.4924, 77.3594},
        {2351.4570, -653.0359, 128.0547},
        {2751.4368, -2189.9272, 46.2275},
        {1498.1407, -1665.2388, 34.0469},
        {598.8820, -1266.4218, 64.1859},
        {1094.6667, -675.9512, 110.1484},
        {65.3320, -1820.0994, -57.3189},
        {302.2582, 1035.6158, 1104.5601},
        {-1094.6779, 606.7272, 1116.5078},
        {282.8992, 1088.2625, 5096.7534},
        {1094.1510, -2036.9094, 82.7574},
        {1786.7986, -1303.2233, 13.5532},
        {1956.6277, -1199.6770, 16.5859},
        {2216.9233, -1190.1036, 33.5313},
        {2708.2070, -2187.5305, 27.9262},
        {1846.2129, -1135.9796, 51.8616},
        {1986.8707, -1114.6799, 35.6250},
        {2179.1436, -2008.8317, 32.4801},
        {2216.3784, -2698.1467, 17.8828},
        {603.2033, -1628.5216, 28.0547},
        {660.7752, -1602.5293, 20.3269},
        {688.5105, -1607.3796, 22.0391},
        {1654.8735, -1638.1479, 83.7813},
        {1671.3395, -1344.6774, 158.4766},
        {1651.7982, -1271.9119, 167.5547},
        {1681.6056, -1223.9996, 167.5547},
        {1278.5238, -1697.4240, 39.4375},
        {1481.8771, -1790.1433, 156.7533},
        {1764.0298, -2286.3223, 26.7960},
        {2202.5444, -2330.3840, 33.7149},
        {2280.8369, -1952.3245, 21.2188},
        {2737.8037, -1760.2153, 44.1507},
        {2840.6848, -2538.9077, 18.2075},
        {2745.8557, -1689.5879, 30.6551},
        {2660.9539, -1458.9890, 79.3805},
        {2606.5115, -1299.3252, 81.1481},
        {1099.8422, -824.3608, 114.4477},
        {939.5084, -910.8499, 80.7187},
        {309.7915, -1146.1421, 92.0492},
        {-1412.3374, -23.8541, 6.0000},
        {-2483.6931, -1549.5001, 401.5734},
        {-2753.6919, -2000.8949, 40.9872},
        {-2712.7534, -344.6357, 54.4080},
        {-1026.7931, -705.2756, 135.5049},
        {2072.7185, -1000.6807, 58.9766},
        {919.1627, -1021.8905, 107.5781},
        {-84.5577, -223.3596, 80.1250},
        {2505.3049, -2640.7354, 13.8623},
        {1474.5920, -2287.0769, 42.4205},
        {2590.4080, -632.3589, 133.3495},
        {-534.0347, -102.9933, 63.2969},
        {323.5139, -1131.3894, 80.9141},
        {194.7249, -1230.7240, 76.0469},
        {226.2876, -1186.0181, 72.0313},
        {955.2682, -719.9095, 122.2109},
        {1334.1615, -650.9788, 108.2632}
};

CMD:gotohuntpos(playerid, params[])
{
    if(IsAdmin(playerid, 4) && IsAdminOnDuty(playerid))
    {
        SetPlayerPos(playerid, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2]);
        SendClientMessage(playerid, COLOR_WHITE, "You have teleported to the treasure hunt location.");
    }
    return 1;
}

CMD:resethuntpos(playerid, params[])
{
    if(IsAdmin(playerid, 4) && IsAdminOnDuty(playerid))
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

    DestroyPickup(iHuntPickup);
    DestroyDynamic3DTextLabel(lHunt);
    iHuntPickup = CreatePickup(1279, 1, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2], 0);
    lHunt = CreateDynamic3DTextLabel("Treasure Hunt\nEnter the pickup!", COLOR_YELLOW, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
    SendClientMessageToAllEx(COLOR_GREEN, "Treasure hunt has been moved to a new place find it to get your prize!");
    return 1;
}

stock AskHuntQuestion(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;
    

    SendClientMessage(playerid, COLOR_WHITE, "To unlock the prize, you must answer a question. If you get the answer wrong, the treasure will be moved before you have a chance to try again.");

    SetPVarInt(playerid, "HuntQ", random(10));
    switch(GetPVarInt(playerid, "HuntQ"))
    {
        case 0: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "What is the 'sizeof' function in Pawn?", "A stock function\nA forwarded function\nA macro which gets the size of a string\nThe name of a cereal", "OK", "Cancel");
                                                                                //Answer: 2
        case 1: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "Do you know a man named Miles Thorson?", "Yes, we're good friends\nHe kicked my dog\nNo, He's an imaginary character from The Mentalist\nI don't know him", "OK", "Cancel");
                                                                                //Answer: 2
        case 2: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "What is Nordo's popular song?", "3arbouch\nYa 3arraf\nMa Nabni\nEl Wa7ch Kleni", "OK", "Cancel");
                                                                                //Answer: 1
        case 3: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "When was the physicist Albert Einstein born?", "December 25th, 2011\nMarch 14th, 1879\nApril 18th, 1955\nJanuary 4th, 1804", "OK", "Cancel");
                                                                                //Answer: 1
        case 4: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "What symbol is used for hashtags on Facebook?", "#\n$\n*\n&", "OK", "Cancel");
                                                                                //Answer: 1
        case 5: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "What was the date the server opened? (EU timezone)", "January 14th\nJanuary 16rd\nJanuary 28th\nJanuary 29th", "OK", "Cancel");
                                                                                //Answer: 3
        case 6: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "Who is the producer of the game TombRaider?", "Ubisoft\nEidos\nE-Arts\nKonami", "OK", "Cancel");
                                                                                //Answer: 1
        case 7: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "Which company developed the iPhone?", "Grapefruit\nOrange\nApple\nBlackBerry", "OK", "Cancel");
                                                                                //Answer: 2
        case 8: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "What is the best rapper in arabic world?", "Mohamed Ramadan\nBalti\nMuslim\nMok Saib", "OK", "Cancel");
                                                                                //Answer: 1
        case 9: Dialog_Show(playerid, TreasureHuntQuestion, DIALOG_STYLE_LIST, "Where Altair in Assassin's Creed was born?", "Jerusalem\nMasyaf\nRome\nSapienza", "OK", "Cancel");
                                                                                //Answer: 1
    }

    return 1;
}

Dialog:TreasureHuntQuestion(playerid, response, listitem, inputtext[])
{
	if (response && listitem >= 0)
	{
        new answers[] = {2, 2, 1, 1, 1, 3, 1, 2, 1, 1};
                
        if(!IsPlayerNearPoint(playerid, 5.0, fTreasureHuntLS[iHuntLocation][0], fTreasureHuntLS[iHuntLocation][1], fTreasureHuntLS[iHuntLocation][2], 0, 0))
        {
            return SendClientMessage(playerid, COLOR_WHITE, "You are not near a hunt treasure.");
        }

        if(answers[GetPVarInt(playerid, "HuntQ")] == listitem)
        {
            //Winner
            Dialog_Show(playerid, TreasureHuntPrize, DIALOG_STYLE_LIST, "Treasure Hunt Prize Selection", "20 Weed & 10 Cocaine\n2,000 materials\nDesert Eagle\n1 respect point\n", "OK", "Cancel");
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "TREASURE HUNT: Wrong answer treasure was hidden in another place!");
        }
        SetRandomHuntPos();
    }
    return 1;
}

Dialog:TreasureHuntPrize(playerid, response, listitem, inputtext[])
{
	if (response && listitem >= 0)
	{
        switch(listitem)
        {
            case 0:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: 20 Weed & 10 Cocaine");
		        SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got 20 Weed & 10 Cocaine.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got 20 Weed & 10 Cocaine.", GetPlayerNameEx(playerid));
                PlayerData[playerid][pWeed] += 20;
                PlayerData[playerid][pCocaine] += 10;
                
                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got 20 Weed & 10 Cocaine.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
            case 1:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: 2,000 materials");
		        SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got 2,000 materials.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got 2,000 materials.", GetPlayerNameEx(playerid));
                PlayerData[playerid][pMaterials] += 2000;
                
                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got 2,000 materials.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
            case 2:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: Deagle");
		        SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got a Deagle.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got a Deagle.", GetPlayerNameEx(playerid));
                GivePlayerWeaponEx(playerid, 24);
                
                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got a Deagle.", GetPlayerNameEx(playerid));
                Log("logs/TreasureHunt.log", string);
            }
            case 3:
            {
                SendClientMessage(playerid, COLOR_YELLOW, "TREASURE HUNT PRIZE: 1 respect point");
		        SendAdminMessage(COLOR_ADM, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has just found a treasure package in the hunt and got 1 respect point.", GetPlayerNameEx(playerid), playerid);
                SendClientMessageToAllEx(COLOR_AQUA, "%s has just found a treasure package in the hunt and got 1 respect point.", GetPlayerNameEx(playerid));
                PlayerData[playerid][pEXP] += 1;
                
                new string[128];
                format(string, sizeof(string), "%s has just found a treasure package in the hunt and got 1 respect point.", GetPlayerNameEx(playerid));
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
    if(iHuntPickup == pickupid && GetPVarInt(playerid, "fT") == 0 && !IsAdminOnDuty(playerid, false))
    {
        AskHuntQuestion(playerid);
        SetPVarInt(playerid, "fT", 1);
    }
    return 1;
}