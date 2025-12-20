new skladplants;
new startplant[MAX_PLAYERS],
    onplant[MAX_PLAYERS],
    prinesplant[MAX_PLAYERS],
    countplant[MAX_PLAYERS],
    inharvesterjob[MAX_PLAYERS],
    prinesplantEx[MAX_PLAYERS],
    countplantEx[MAX_PLAYERS],
    ExtraPlants[MAX_PLAYERS],
    harvesterskin[MAX_PLAYERS];


forward TimerGiveHarvester(playerid);
forward TimerGiveHarvesterEx(playerid);
stock StartHarvesting(playerid, bool:isWeed);

CMD:harvest(playerid, params[])
{

    if (!PlayerHasJob(playerid, JOB_MINER))
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not in the oil stake job.");

    if(IsPlayerInRangeOfPoint(playerid, 2, -1112.4697, -1636.8641, 76.3672))
    {
        if(inharvesterjob[playerid] == 0)
        {
            startplant[playerid] = 0;
            onplant[playerid] = 1;
            harvesterskin[playerid] = GetPlayerSkin(playerid);
            SetPlayerSkin(playerid, 158);
            SendClientMessage(playerid, COLOR_AQUA, "You got a job Harvester. Production site located near the flower of plant.");
            SendClientMessage(playerid, COLOR_AQUA, "Weeds plant pay higher, they are up the hill.");
            inharvesterjob[playerid] = 1;
            return 1;
        }
        else if(inharvesterjob[playerid] == 1)
        {
            new string[128];
            new money = 5000;

            if(PlayerData[playerid][pLaborUpgrade] > 0)
            {
                money += percent(money, PlayerData[playerid][pLaborUpgrade]);
            }

            startplant[playerid] = 0;
            onplant[playerid] = 0;
            prinesplant[playerid] = 0;
            countplant[playerid] = 0;
            prinesplantEx[playerid] = 0;
            countplantEx[playerid] = 0;
            ExtraPlants[playerid] = 0;

            SetPlayerSkin(playerid, harvesterskin[playerid]);
            AddToPaycheck(playerid, money);

            format(string, sizeof(string), "You earned $%d from your job, payment has been added to your paycheck.", money);
            SendClientMessage(playerid, COLOR_AQUA, string);

            GivePlayerCash(playerid, money);

            RemovePlayerAttachedObject(playerid, 3);
            RemovePlayerAttachedObject(playerid, 4);
            DisablePlayerCheckpoint(playerid);
            inharvesterjob[playerid] = 0;

            return 1;
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not in the harvester sidejob!");
    }
    return 1;
}

stock StartHarvesting(playerid, bool:isWeed)
{
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 5000, 1);
    GameTextForPlayer(playerid, "~w~Harvesting..", 5000, 6);
    startplant[playerid] = 1;

    if(isWeed)
    {
        SetTimerEx("TimerGiveHarvesterEx", 5000, false, "i", playerid);
    }
    else
    {
        SetTimerEx("TimerGiveHarvester", 5000, false, "i", playerid);
    }
}

public TimerGiveHarvester(playerid)
{
    RemovePlayerAttachedObject(playerid, 3);
    SendClientMessage(playerid, COLOR_AQUA, "You produced flower. Now, take them to the warehouse.");
    ApplyAnimation(playerid, "KNIFE", "IDLE_tired", 4.0, 1, 0, 0, 0, 5000, 1);
    SetPlayerAttachedObject(playerid, 1, 2901, 5, 0.101, 0.0, 0.0, 5.50, 90, 90, 1, 1);
    SetPlayerCheckpoint(playerid, -1115.8110, -1621.4474, 76.3739, 3.0);
    ClearAnimations(playerid);
    ExtraPlants[playerid] = 0;
    return 1;
}

public TimerGiveHarvesterEx(playerid)
{
    RemovePlayerAttachedObject(playerid, 3);
    SendClientMessage(playerid, COLOR_AQUA, "You produced marijuana. Now, take them to the warehouse.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
    ApplyAnimation(playerid, "KNIFE", "IDLE_tired", 4.1, 1, 0, 0, 0, 5000, 1);
    SetPlayerAttachedObject(playerid, 1, 2901, 5, 0.101, 0.0, 0.0, 5.50, 90, 90, 1, 1);
    SetPlayerCheckpoint(playerid, -1115.8110, -1621.4474, 76.3739, 3.0);
    ClearAnimations(playerid);
    ExtraPlants[playerid] = 1;
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(startplant[playerid] == 1)
    {
        new string[256];
        DisablePlayerCheckpoint(playerid);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        ApplyAnimation(playerid, "KNIFE", "IDLE_tired", 4.0, 1, 0, 0, 0, 5000, 1);
        startplant[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 1);
        SetPlayerAttachedObject(playerid, 3, 18634, 6, 0.078222, 0.000000, 0.110844, 298.897308, 264.126861, 193.350555, 1.0, 1.0, 1.0);
        
        if(ExtraPlants[playerid] == 1)
        {
            prinesplantEx[playerid] = 250 + random(300);
            countplantEx[playerid] += prinesplantEx[playerid];
            format(string, 256, "You brought {9ACD32}%d{FFFFFF} lb(s) marijuana plant.", prinesplantEx[playerid]);
            SendClientMessage(playerid, -1, string);
            format(string, 256, "+%d", prinesplantEx[playerid]);
            SetPlayerChatBubble(playerid, string, 0x00FF00FF, 20.0, 3000);
            skladplants += prinesplant[playerid];
            prinesplantEx[playerid] = 0;
        }
        else
        {
            prinesplant[playerid] = 750 + random(1000);
            countplant[playerid] += prinesplant[playerid];
            format(string, 256, "You brought {FFA500}%d{FFFFFF} lb(s) flower plant", prinesplant[playerid]);
            SendClientMessage(playerid, -1, string);
            format(string, 256, "+%d", prinesplant[playerid]);
            SetPlayerChatBubble(playerid, string, 0x00FF00FF, 20.0, 3000);
            skladplants += prinesplant[playerid];
            prinesplant[playerid] = 0;
        }

        format(string, 256, "{FF0606}Marijuana: {FFFFFF}%d", countplantEx[playerid]);
        SendClientMessage(playerid, -1, string);
        return 1;
    }

    return 0;
}

hook OnPlayerUpdate(playerid)
{
    	if(onplant[playerid] && !startplant[playerid] && !IsPlayerInAnyVehicle(playerid))
	{
		// Flower harvesting spots
		if(IsPlayerInRangeOfPoint(playerid, 1, -312.12, -1356.69, 9.03)
		|| IsPlayerInRangeOfPoint(playerid, 1, -313.70, -1358.28, 9.18)
		|| IsPlayerInRangeOfPoint(playerid, 1, -313.67, -1355.63, 9.09))
		{
			StartHarvesting(playerid, false);
		}

		// Weed harvesting spots
		if(IsPlayerInRangeOfPoint(playerid, 1, -992.3234, -1607.9264, 76.3672)
		|| IsPlayerInRangeOfPoint(playerid, 1, -991.8456, -1622.5966, 76.3672)
		|| IsPlayerInRangeOfPoint(playerid, 1, -990.8137, -1635.1368, 76.3672))
		{
			StartHarvesting(playerid, true);
		}
        return 0;
	}
        return 1;
}