#include <YSI\y_hooks>

static MiningTime[MAX_PLAYERS];
static MiningRock[MAX_PLAYERS];

IsPlayerMining(playerid)
{
    return (MiningTime[playerid] > 0);
}

hook OnPlayerInit(playerid)
{
	MiningTime[playerid] = 0;
	MiningRock[playerid] = 0;
    return 1;
}

hook OnPlayerReset(playerid)
{
	if(MiningTime[playerid] > 0)
	{
	    ClearAnimations(playerid, 1);
	}
	MiningTime[playerid] = 0;
	MiningRock[playerid] = 0;

    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if(MiningTime[playerid] > 0)
    {
        MiningTime[playerid]--;

        if(MiningTime[playerid] <= 0)
        {
            if(IsPlayerInMiningArea(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !PlayerData[playerid][pTazedTime] && !PlayerData[playerid][pCuffed])
            {
                new number = random(10) + 1;

                PlayerData[playerid][pCP] = CHECKPOINT_MINING;

                SetPlayerAttachedObject(playerid, 9, 3929, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

                ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
                SetPlayerCheckpoint(playerid, 1278.0778, -1267.9661, 12.5413, 2.0);

                if(1 <= number <= 5)
                {
                    MiningRock[playerid] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "You have dug up an ordinary stone. Drop it off at the marker.");
                }
                else if(number == 6 && !PlayerData[playerid][pRareTime])
                {
                    SendClientMessage(playerid, COLOR_AQUA, "Woah, this looks oddly weird to find in the middle of a city, lets show it to the boss.");
                    MiningRock[playerid] = 3;
                }
                else
                {
                    MiningRock[playerid] = 2;
                    SendClientMessage(playerid, COLOR_AQUA, "You have dug up a quality stone. Drop it off at the marker.");
                }
            }
            else
            {
                RemovePlayerAttachedObject(playerid, 9);
                ClearAnimations(playerid, 1);
            }
        }
    }
    return 1;
}

hook OnPlayerClearCheckPoint(playerid)
{
	MiningTime[playerid] = 0;
	MiningRock[playerid] = 0;
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerData[playerid][pCP] == CHECKPOINT_MINING)
    {
        new cost, string[20];

        if(MiningRock[playerid] == 1) 
        {
            cost = 300 + random(50);
        }
        else if(MiningRock[playerid] == 2)
        {
            cost = 250 + random(50);
        }
        else if(MiningRock[playerid] == 3)
        {
            new rock = random(552);
            switch(rock)
            {
                case 0..250:
                {
                    cost = 595 + random(50);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Bam, a great stone indeed, the fact you can find stuff in this dump makes me wonder whether theres a diamond hidden in there somewhere.");
                }
                case 251..380:
                {
                    cost = 695 + random(200);
                    SendClientMessage(playerid, COLOR_WHITE, "Looks like a ruby, awesome. I'll be sending this Mining Enterprises immediately.");
                }
                case 381..400:
                {
                    cost = 759 + random(500);
                    AwardAchievement(playerid, ACH_Diamond);
                    SendClientMessage(playerid, COLOR_WHITE, "BINGO!, It's a freakin' diamond, we're going to be damn rich!");
                    SendClientMessage(playerid, COLOR_WHITE, "Boss: You know what? since you found it, you should get to keep it.");
                    PlayerData[playerid][pDiamonds] ++;
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", PlayerData[playerid][pDiamonds], PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                case 401..552:
                {
                    cost = 657 + random(500);
                    SendClientMessage(playerid, COLOR_WHITE, "Looks like you've found a sapphire, damn good job. Let's go for that diamond!");
                }
            }
            PlayerData[playerid][pRareTime] = 3600;
            
            SendClientMessage(playerid, COLOR_GREY, "A cooldown for 60 minutes (of playtime) has been applied. Until then you can't find anymore rare stones.");
        }

        if(PlayerData[playerid][pLaborUpgrade] > 0)
        {
            cost += percent(cost, PlayerData[playerid][pLaborUpgrade]);
        }

        AddToPaycheck(playerid, cost);
        GivePlayerRankPointLegalJob(playerid, 20);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have earned {00AA00}$%i{33CCFF} on your paycheck for your mined rock.", cost);
        ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);

        format(string, sizeof(string), "~g~+$%i", cost);
        GameTextForPlayer(playerid, string, 5000, 1);

        MiningRock[playerid] = 0;
        PlayerData[playerid][pCP] = CHECKPOINT_NONE;

        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        RemovePlayerAttachedObject(playerid, 9);

        DisablePlayerCheckpoint(playerid);
    }
    return 1;
}

CMD:mine(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_MINER))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Miner.");
	}
	if(MiningTime[playerid] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are mining already. Wait until you are done.");
	}
	if(MiningRock[playerid] > 0 && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to drop off your current rock first.");
	}
	if(!IsPlayerInMiningArea(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the mining area.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot in order to use this command.");
	}

    GameTextForPlayer(playerid, "~w~Mining...", 6000, 3);
    ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.1, 1, 0, 0, 0, 0, 1);

	DisablePlayerCheckpoint(playerid);
	SetPlayerAttachedObject(playerid, 9, 337, 6);

	MiningTime[playerid] = 6;
	return 1;
}
