#include <YSI\y_hooks>

#define BRINKS_RESPAWN 1000

enum BrinksVehicleEnim
{
    BrinksVehicle_ID,
    BrinksVehicle_LastDriver,
    BrinksVehicle_DropState,
    Float:BrinksVehicle_DropX,
    Float:BrinksVehicle_DropY,
    Float:BrinksVehicle_DropZ,
    BrinksVehicle_DropPickUp,
    Text3D:BrinksVehicle_DropLabel
};
static BrinksVehicles[14][BrinksVehicleEnim];
static BrinksDeliveringTime[MAX_PLAYERS];
static BrinksDeliveryDestination[MAX_PLAYERS];
static BrinksWorkinHours[][2] = {
    {11,14},
    {19,23}
};


IsBrinksVehicle(vehicleid)
{
    return (BrinksVehicles [0][BrinksVehicle_ID] <= vehicleid <= BrinksVehicles[sizeof(BrinksVehicles) - 1][BrinksVehicle_ID]);
}

IsInBrinksWorkingHours()
{
	new h,m;
    gettime(h, m);

    for(new i=0;i<sizeof(BrinksWorkinHours);i++)
    {
        if(BrinksWorkinHours[i][0] <= h <= BrinksWorkinHours[i][1])
        {
            return 1;
        }
    }
    return 0;
}
hook OnLoadGameMode(timestamp)
{

 	CreateDynamicPickup(1239, 23, -1494.9773, 832.5115, 7.3840, -1); //Brinks LoadCash
	CreateDynamic3DTextLabel("{FFFF00}Brinks Job \nType /loadcash", -1, -1494.9773, 832.5115, 7.3840, 20.0); //Brinks LoadCash

    CreateDynamicObject(8314, -1490.75842, 836.09485, 6.17455,   0.00000, 0.00000, 15.71862);
    CreateDynamicObject(16337, -1494.69226, 827.44843, 6.15745,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(8313, -1435.70569, 841.17358, 9.11423,   0.00000, 0.00000, 270.00000);


	//Brinks Vehicles
	BrinksVehicles[0][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1458.7394,837.7384,7.3141,134.7363,1,2, BRINKS_RESPAWN);
	BrinksVehicles[1][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1464.8541,837.6013,7.3144,141.5355,1,2, BRINKS_RESPAWN);
	BrinksVehicles[2][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1470.2930,837.9598,7.2622,141.5518,1,2, BRINKS_RESPAWN);
	BrinksVehicles[3][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1476.1294,838.9541,7.2625,137.6163,1,2, BRINKS_RESPAWN);
	BrinksVehicles[4][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1482.6418,838.2371,7.3123,140.5707,1,2, BRINKS_RESPAWN);
	BrinksVehicles[5][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1488.0460,838.5881,7.3109,135.7824,1,2, BRINKS_RESPAWN);
	BrinksVehicles[6][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1452.6678,837.4558,7.3121,139.1217,1,2, BRINKS_RESPAWN);
	BrinksVehicles[7][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1451.9321,827.8773,7.3111,27.4358,1,2, BRINKS_RESPAWN);
	BrinksVehicles[8][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1457.2500,828.2690,7.3228,26.3303,1,2, BRINKS_RESPAWN);
	BrinksVehicles[9][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1462.2325,828.0310,7.3140,30.2593,1,2, BRINKS_RESPAWN);
	BrinksVehicles[10][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1467.9229,827.9155,7.3103,30.9733,1,2, BRINKS_RESPAWN);
	BrinksVehicles[11][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1473.2793,828.3884,7.2629,33.7368,1,2, BRINKS_RESPAWN);
	BrinksVehicles[12][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1478.8438,828.0593,7.2613,32.3325,1,2, BRINKS_RESPAWN);
	BrinksVehicles[13][BrinksVehicle_ID] = AddStaticVehicleEx(428,-1484.4058,827.6866,7.3083,22.2092,1,2, BRINKS_RESPAWN);
    
    for(new i=0;i<sizeof(BrinksVehicles);i++)
    {
        BrinksVehicles[i][BrinksVehicle_LastDriver] = INVALID_PLAYER_ID;
        BrinksVehicles[i][BrinksVehicle_DropState] = 0;
		SetVehicleHealth(BrinksVehicles[i][BrinksVehicle_ID], 5000);
    }
    return 1;
}

hook OnPlayerInit(playerid)
{
    BrinksDeliveryDestination[playerid] = 0;
    BrinksDeliveringTime[playerid] = 0;
    return 1;
}

hook OnPlayerClearCheckPoint(playerid)
{
    if(BrinksDeliveryDestination[playerid])
    {
        BrinksDeliveryDestination[playerid] = 0;
    }
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(!ispassenger && PlayerHasJob(playerid, JOB_BRINKS) && IsBrinksVehicle(vehicleid))
	{   
        for(new i=0;i<sizeof(BrinksVehicles);i++)
        {
            if(BrinksVehicles[i][BrinksVehicle_ID] == vehicleid)
            {
                BrinksVehicles[i][BrinksVehicle_LastDriver] = playerid;                
            }
        }
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(!IsPlayerConnected(killerid) || playerid == killerid)
    {
        return 1;
    }

    if(!PlayerHasJob(playerid, JOB_BRINKS))
	{
	    return 1;
	}

    if(BrinksDeliveryDestination[playerid] < 10)
    {
        return 1;
    }

    new vehicleid = INVALID_VEHICLE_ID;
    new vehicleidx;
    for(new i=0;i<sizeof(BrinksVehicles);i++)
    {
        if(BrinksVehicles[i][BrinksVehicle_LastDriver]  == playerid)
        {
            vehicleid = BrinksVehicles[i][BrinksVehicle_ID];
            vehicleidx = i;
            break;
        }
    }
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return 1;
    }

    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);
    if(!IsPlayerNearPoint(playerid, 20, x, y, z))
    {
        return 1;
    }

    if(BrinksDeliveryDestination[playerid]==11)
    {
        GivePlayerCash(playerid, -30000);
        SendClientMessage(playerid, COLOR_RED, "You failed to secure the money and you lost $30,000.");
        BrinksVehicles[vehicleidx][BrinksVehicle_DropState] = 1;
    }
    else if(BrinksDeliveryDestination[playerid]==12)
    {
        BrinksVehicles[vehicleidx][BrinksVehicle_DropState] = 2;
        GivePlayerCash(playerid, -50000);
        SendClientMessage(playerid, COLOR_RED, "You failed to secure the money and you lost $50,000.");
    }
    else
    {
        BrinksVehicles[vehicleidx][BrinksVehicle_DropState] = 0;
    }

    if(BrinksVehicles[vehicleidx][BrinksVehicle_DropState])
    {

        GetPlayerPos(playerid, x, y, z);
        BrinksVehicles[vehicleidx][BrinksVehicle_DropX] = x;
        BrinksVehicles[vehicleidx][BrinksVehicle_DropY] = y;
        BrinksVehicles[vehicleidx][BrinksVehicle_DropZ] = z;
        BrinksVehicles[vehicleidx][BrinksVehicle_DropPickUp] = CreateDynamicPickup(1239, 23, x, y, z, -1); //Brinks RobCash
        BrinksVehicles[vehicleidx][BrinksVehicle_DropLabel]  = CreateDynamic3DTextLabel("{FFFF00}Brinks Money \nType /robcash to steal money", -1, x, y, z, 20.0); //Brinks RobCash
        
		GiveNotoriety(killerid, 2000);
        PlayerData[killerid][pWantedLevel] = 6;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = 6 WHERE uid = %i", PlayerData[killerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        SendClientMessage(killerid, COLOR_RED, "Cops are now looking for you for killing onduty Brinks worker(+2,000 Notoriety)");
    }

    return 1;
}

CMD:securecash(playerid, params[])
{
    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only cops can secure the cash.");
    }
    
    
    for(new i=0;i<sizeof(BrinksVehicles);i++)
    {
        if(BrinksVehicles[i][BrinksVehicle_DropState] && IsPlayerNearPoint(playerid, 2, BrinksVehicles[i][BrinksVehicle_DropX], BrinksVehicles[i][BrinksVehicle_DropY], BrinksVehicles[i][BrinksVehicle_DropZ]))
        {
            switch(BrinksVehicles[i][BrinksVehicle_DropState])
            {
                case 1:
                {
                    GivePlayerCash(playerid, 15000);
                    SendClientMessage(playerid, COLOR_AQUA, "You earned $15,000 from the securing the cash.");
                }
                case 2:
                {
                    GivePlayerCash(playerid, 25000);
                    SendClientMessage(playerid, COLOR_AQUA, "You earned $25,000 from the securing the cash.");
                }
            }

            BrinksVehicles[i][BrinksVehicle_DropState] = 0;
                
            if (IsValidDynamicPickup(BrinksVehicles[i][BrinksVehicle_DropPickUp]))
                DestroyDynamicPickup(BrinksVehicles[i][BrinksVehicle_DropPickUp]);

            if (IsValidDynamic3DTextLabel(BrinksVehicles[i][BrinksVehicle_DropLabel]))
                DestroyDynamic3DTextLabel(BrinksVehicles[i][BrinksVehicle_DropLabel]);

            BrinksVehicles[i][BrinksVehicle_DropPickUp] = 0;
            BrinksVehicles[i][BrinksVehicle_DropLabel]  = INVALID_3DTEXT_ID;
            break;
        }
    }

    return 1;
}

CMD:robcash(playerid, params[])
{
    if(IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot rob cash as a cop use /securecash instead.");
    }

    for(new i=0;i<sizeof(BrinksVehicles);i++)
    {
        if(BrinksVehicles[i][BrinksVehicle_DropState] && IsPlayerNearPoint(playerid, 2, BrinksVehicles[i][BrinksVehicle_DropX], BrinksVehicles[i][BrinksVehicle_DropY], BrinksVehicles[i][BrinksVehicle_DropZ]))
        {
            switch(BrinksVehicles[i][BrinksVehicle_DropState])
            {
                case 1:
                {
                    GivePlayerCash(playerid, 25000);
		            GiveNotoriety(playerid, 3000);
                    PlayerData[playerid][pWantedLevel] = 6;
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = 6 WHERE uid = %i", PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    SendClientMessage(playerid, COLOR_RED, "You robbed $25,000 from the SecuriCar. Cops are now looking for you (+3,000 Notoriety).");
                }
                case 2:
                {
                    GivePlayerCash(playerid, 45000);
		            GiveNotoriety(playerid, 4000);
                    PlayerData[playerid][pWantedLevel] = 6;
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET wantedlevel = 6 WHERE uid = %i", PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    SendClientMessage(playerid, COLOR_RED, "You robbed $45,000 from the SecuriCar. Cops are now looking for you (+4,000 Notoriety).");
                }
            }

            BrinksVehicles[i][BrinksVehicle_DropState] = 0;
                
            if (IsValidDynamicPickup(BrinksVehicles[i][BrinksVehicle_DropPickUp]))
                DestroyDynamicPickup(BrinksVehicles[i][BrinksVehicle_DropPickUp]);

            if (IsValidDynamic3DTextLabel(BrinksVehicles[i][BrinksVehicle_DropLabel]))
                DestroyDynamic3DTextLabel(BrinksVehicles[i][BrinksVehicle_DropLabel]);

            BrinksVehicles[i][BrinksVehicle_DropPickUp] = 0;
            BrinksVehicles[i][BrinksVehicle_DropLabel]  = INVALID_3DTEXT_ID;
            break;
        }
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    if(!IsBrinksVehicle(vehicleid))
    {
        return 1;
    }

    for(new i=0;i<sizeof(BrinksVehicles);i++)
    {
        if(BrinksVehicles[i][BrinksVehicle_ID] == vehicleid)
        {
            if (IsValidDynamicPickup(BrinksVehicles[i][BrinksVehicle_DropPickUp]))
                DestroyDynamicPickup(BrinksVehicles[i][BrinksVehicle_DropPickUp]);

            if (IsValidDynamic3DTextLabel(BrinksVehicles[i][BrinksVehicle_DropLabel]))
                DestroyDynamic3DTextLabel(BrinksVehicles[i][BrinksVehicle_DropLabel]);
            
            BrinksVehicles[i][BrinksVehicle_DropPickUp] = 0;
            BrinksVehicles[i][BrinksVehicle_DropLabel]  = INVALID_3DTEXT_ID;
            BrinksVehicles[i][BrinksVehicle_DropState] = 0;

		    SetVehicleHealth(BrinksVehicles[i][BrinksVehicle_ID], 5000);            
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    for(new i=0;i<sizeof(BrinksVehicles);i++)
    {
        if(BrinksVehicles[i][BrinksVehicle_LastDriver] == playerid)
        {
            BrinksVehicles[i][BrinksVehicle_LastDriver] = INVALID_PLAYER_ID;
        }
    }
    return 1;
}

Dialog:BrinksTarget(playerid, response, listitem, inputtext[])
{
    BrinksDeliveringTime[playerid] = gettime();
    if(response)
    {
        BrinksDeliveryDestination[playerid] = 1;
        PlayerData[playerid][pCP] = CHECKPOINT_BRINKS;
        SetPlayerCheckpoint(playerid,2300.0862, -16.5616, 26.4844, 5);
        GameTextForPlayer(playerid, "~w~Waypoint set ~r~Palomino Creek Bank", 5000, 1);
    }
    else
    {
        BrinksDeliveryDestination[playerid] = 2;
        PlayerData[playerid][pCP] = CHECKPOINT_BRINKS;
        SetPlayerCheckpoint(playerid, 597.2949, -1305.2061, 14.1084, 5);
        GameTextForPlayer(playerid, "~w~Waypoint set ~r~Los Santos Bank", 5000, 1);
    }
    return 1;
}

CMD:loadcash(playerid, params[])
{
    if(!PlayerHasJob(playerid, JOB_BRINKS))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a brinks worker.");
	}

    if(!IsInBrinksWorkingHours())
    {
        new string[128];
        string="Brinks is closed. Working Hours";
        for(new i=0;i<sizeof(BrinksWorkinHours);i++)
        {
            format(string, sizeof(string), "%s, %i:00 => %i:00",string, BrinksWorkinHours[i][0], BrinksWorkinHours[i][1]);
        }
        return SendClientMessage(playerid, COLOR_GREY, string);
    }

    if(PlayerData[playerid][pCP] != CHECKPOINT_NONE)
	{
		return SendClientMessage(playerid, COLOR_AQUA, "Make sure you dont have any checkpoint. Use /kcp to clear current checkpoints.");
	}

	new vehicleid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsBrinksVehicle(vehicleid))
    {
	    return SendClientMessage(playerid, COLOR_GREY, "You're not driving a Securicar from the loading point!");
    }

    BrinksDeliveryDestination[playerid] = 0;
    PlayerData[playerid][pCP] = CHECKPOINT_BRINKS;
    SetPlayerCheckpoint(playerid, -1494.9773, 832.5115, 7.3840, 5);
    GameTextForPlayer(playerid, "~r~[Brinks]~n~~y~Start by following the checkpoint at your radar", 5000, 4);            
	return 1;
}

publish LoadingBrinksCar(playerid)
{
    if(BrinksDeliveryDestination[playerid] && IsBrinksVehicle(GetPlayerVehicleID(playerid)))
    {
        BrinksDeliveryDestination[playerid]+=10;
        TogglePlayerControllableEx(playerid, 1);
        PlayerData[playerid][pCP] = CHECKPOINT_BRINKS;
        SetPlayerCheckpoint(playerid,-1496.6418, 835.0526, 7.3840, 5);
        GameTextForPlayer(playerid, "~w~Waypoint set ~r~San Fierro Bank", 5000, 1);
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* You have successfuly loaded your truck with cash, deliver it to San Fierro Bank!");
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerData[playerid][pCP] == CHECKPOINT_BRINKS)
	{
        new vehicleid = GetPlayerVehicleID(playerid);

        if(!IsBrinksVehicle(vehicleid))
        {
            
            PlayerData[playerid][pCP] = CHECKPOINT_NONE;
            DisablePlayerCheckpoint(playerid);
            return SendClientMessage(playerid, COLOR_GREY, "You must be inside a Securicar from Mulholland Bank!");
        }

        if(IsPlayerInRangeOfPoint(playerid, 10, 2300.0862, -16.5616, 26.4844) || IsPlayerInRangeOfPoint(playerid, 10, 597.2949, -1305.2061, 14.1084))
        {
            DisablePlayerCheckpoint(playerid);
            TogglePlayerControllableEx(playerid, 0);
            SetTimerEx("LoadingBrinksCar", 10000, false, "i", playerid);
            GameTextForPlayer(playerid, "~g~Loading cash...", 5000, 1);
        }
        else if(BrinksDeliveryDestination[playerid] == 0 && IsPlayerInRangeOfPoint(playerid, 10, -1494.9773, 832.5115, 7.3840))
        {
            Dialog_Show(playerid, BrinksTarget, DIALOG_STYLE_MSGBOX, "Select your destination:", "- Palomino Creek Bank (Reward: $30K)\n - Los Santos Bank (Reward: $50k)", "Palomino", "LS Bank");
        }
        else if(BrinksDeliveryDestination[playerid] > 10 && IsPlayerInRangeOfPoint(playerid, 10, -1496.6418, 835.0526, 7.3840))
        {
            PlayerData[playerid][pCP] = CHECKPOINT_NONE;
            DisablePlayerCheckpoint(playerid);
            SetVehicleToRespawn(vehicleid);

            if(gettime() - BrinksDeliveringTime[playerid] < 250)
            {
                GivePlayerCash(playerid, -30000);
                SendClientMessageEx(playerid, COLOR_AQUA, "You was fined $30,000 for suspicion of teleport.");
                return 1;
            }

            new randmoney = Random(25000, 70000);
            
            if(BrinksDeliveryDestination[playerid] == 12)
            {
                randmoney += 20000;
            }
            
            AddToPaycheck(playerid, randmoney);
            GivePlayerRankPointLegalJob(playerid, 500);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have successfully delivered the cash and earned {00AA00}%s{33CCFF} on your paycheck for your work.", FormatCash(randmoney));
            PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
        }
    }
    return 1;
}
