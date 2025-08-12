/*
Rob Casino v0.3 by Troy
Rob Casino Dev Logs:
	Mark players who were near the entrance when /robcasino starts.
	Allow /takemoney only for those players.
	Block random players from taking the loot.
	Reset the robber list when the heist ends.
	Enforce the 3-second cooldown.
	Removes Attachments
*/

#define MAX_ROBBERS 5
#define TOTAL_LOOT 500000
#define WANTED_LEVEL 6
#define DOOR_KICKS_REQUIRED 3

enum E_HEIST_DATA
{
    bool:hActive,
    bool:hDoorBreached,
    bool:hC4Planted,
    bool:hVaultOpen,
    hRobbers,
    hLootTaken,
    hDoorKicks,
    hC4Timer,
};
new HeistData[E_HEIST_DATA];

new bool:IsRobber[MAX_PLAYERS];
new LastTakeMoneyTime[MAX_PLAYERS];

new g_CazinoObject[8];

hook OnGameModeInit() {
	// Casino Mapping
    g_CazinoObject[0] = CreateObject(1569, 2147.0524, 1604.7028, 1005.1768, 0.0, 0.0, 0.0); // Main Door
    g_CazinoObject[1] = CreateObject(19997, 2142.8937, 1641.0688, 992.5847, 0.0, 0.0, -88.6);
    g_CazinoObject[2] = CreateObject(19799, 2143.1811, 1627.0026, 994.3052, 0.0, 0.0, 179.6); // Vault Door
    g_CazinoObject[3] = CreateObject(19997, 2144.2993, 1639.6926, 992.5847, 0.0, 0.0, -88.6);
    g_CazinoObject[4] = CreateObject(19997, 2144.2641, 1641.1239, 992.5847, 0.0, 0.0, -88.6);
    g_CazinoObject[5] = CreateObject(19997, 2142.8681, 1639.6577, 992.5847, 0.0, 0.0, -88.6);
    g_CazinoObject[6] = CreateObject(1550, 2142.8161, 1639.5217, 993.5619, 87.1, 152.4, -175.4); // Money Bag
    g_CazinoObject[7] = CreateObject(1550, 2144.2661, 1640.9354, 993.6366, 87.1, 152.4, -175.4); // Money Bag

    CreateDynamic3DTextLabel("Casino Entrance5\n/robcasino to start heist", COLOR_YELLOW, 2147.0524, 1604.7028, 1005.1768, 10.0);
    return 1;
}

CMD:robcasino(playerid)
{
    if (HeistData[hActive])
        return SendClientMessage(playerid, COLOR_GREY, "Heist already in progress!");

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 2147.0524, 1604.7028, 1005.1768))
        return SendClientMessage(playerid, COLOR_GREY, "You're not at the casino entrance!");

    new count = 0;
    new playersInRange[MAX_PLAYERS];

    foreach (new i : Player)
    {
        if (IsPlayerInRangeOfPoint(i, 8.0, 2147.0524, 1604.7028, 1005.1768))
        {
            playersInRange[count] = i;
            count++;
        }
    }

    if (count != 5)
        return SendClientMessage(playerid, COLOR_GREY, "You must have exactly 5 crew members to start the heist!");

    for (new j = 0; j < count; j++)
    {
        IsRobber[playersInRange[j]] = true;
    }

    HeistData[hActive] = true;
    HeistData[hRobbers] = count;

    for (new j = 0; j < count; j++)
    {
        new robberid = playersInRange[j];
        PlayerData[robberid][pWantedLevel] = 6;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),"UPDATE " # TABLE_USERS " SET wantedlevel = %i WHERE uid = %i",PlayerData[robberid][pWantedLevel], PlayerData[robberid][pID]);
        mysql_tquery(connectionID, queryBuffer);
    }

    return 1;
}


CMD:takemoney(playerid) {
    new string[64];
    
    if(!HeistData[hVaultOpen])
		return SendClientMessage(playerid,  COLOR_GREY, "Vault not open!");
    
    if(!IsPlayerInRangeOfPoint(playerid, 2.0, 2143.0, 1640.0, 993.0))
        return SendClientMessage(playerid,  COLOR_GREY, "Not near the money stash!");
        
    if (GetTickCount() - LastTakeMoneyTime[playerid] < 3000) // 3s
        return SendClientMessage(playerid, COLOR_GREY, "You must wait 3 seconds before taking money again!");
        
	if (!IsRobber[playerid])
    	return SendClientMessage(playerid, COLOR_GREY, "You are not part of the heist!");

    new amount = random(50000) + 25000;
    if(HeistData[hLootTaken] + amount > TOTAL_LOOT) {
        amount = TOTAL_LOOT - HeistData[hLootTaken];
    }

	GivePlayerCash(playerid, amount);
    HeistData[hLootTaken] += amount;
    
    SendClientMessageEx(playerid, COLOR_AQUA, "You have looted {00AA00}$%i{33CCFF}.", amount);
    SendClientMessageEx(playerid, COLOR_AQUA, "You can keep looting the box to get more money.");
    
 	format(string, sizeof(string), "~w~You looted ~g~+$%i~w~ from the box...", amount);
    GameTextForPlayer(playerid, string, 5000, 1);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 0, 0, 0, 0, 1);

    if(HeistData[hLootTaken] >= TOTAL_LOOT) {
        DestroyObject(g_CazinoObject[6]);
        DestroyObject(g_CazinoObject[7]);
    }

	if (HeistData[hLootTaken] >= TOTAL_LOOT)
	{
	    foreach (new i : Player)
	    {
	        if (IsRobber[i])
	        {
	            SendClientMessage(i, COLOR_RED, "The vault is empty! Run away");
	        }
	    }
	}
    
    LastTakeMoneyTime[playerid] = GetTickCount();
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if((newkeys & KEY_SECONDARY_ATTACK)) {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 2147.0524, 1604.7028, 1005.1768) && HeistData[hActive] && !HeistData[hDoorBreached]) {
            ApplyAnimation(playerid, "GANGS", "shake_carK", 4.1, 0, 0, 0, 0, 0);
            PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // Kick sound

            HeistData[hDoorKicks]++;

            new Float:rz;
            GetObjectRot(g_CazinoObject[0], rz, rz, rz);
            SetObjectRot(g_CazinoObject[0], 0.0, 0.0, rz + (HeistData[hDoorKicks] * -12.0));

            if(HeistData[hDoorKicks] >= DOOR_KICKS_REQUIRED) {
                SetTimerEx("FinalDoorBreak", 1000, false, "i", playerid);
                HeistData[hDoorBreached] = true;
            }
            else {
				new text[259];
				format(text, sizeof(text), "~r~DOOR KICKS: %d/%d", HeistData[hDoorKicks], DOOR_KICKS_REQUIRED);
                GameTextForPlayer(playerid, text, 1000, 3);
            }
            return 1;
        }

        // C4 Planting
        if(IsPlayerInRangeOfPoint(playerid, 2.0, 2143.1811, 1627.0026, 994.3052) && HeistData[hDoorBreached] && !HeistData[hC4Planted]) {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
            SendClientMessage(playerid, 0x00FF00AA, "Planting C4... (5 seconds)");
            HeistData[hC4Timer] = SetTimer("DetonateC4", 5000, false);
            HeistData[hC4Planted] = true;
            return 1;
        }
    }
    return 1;
}

forward FinalDoorBreak(playerid);
public FinalDoorBreak(playerid) {
    PlaySoundForAll(5203, 2147.0524, 1604.7028, 1005.1768); // Breaking sound
    PlayerPlaySound(playerid, 5203, 0.0, 0.0, 0.0);
    //SetObjectRot(g_CazinoObject[0], 0.0, 0.0, 25.0);
    //MoveObject(g_CazinoObject[0], 2147.0524, 1604.7028, 1005.1768, 0.5, 0.0, 0.0, 25.0);

    // Update instructions
    CreateDynamic3DTextLabel("PLANT C4 ON VAULT [F]", 0xFFFF00FF, 2143.1811, 1627.0026, 994.3052, 5.0);
}

forward DetonateC4();
public DetonateC4()
{
    DestroyObject(g_CazinoObject[2]);
    CreateExplosion(2143.1811, 1627.0026, 994.3052, 12, 5.0);
    
    HeistData[hVaultOpen] = true;

    CreateDynamic3DTextLabel("LOOT MONEY\n[/takemoney]", 0x00FF00FF, 2143.0, 1640.0, 993.0, 5.0);
    SendClientMessageToAllEx(COLOR_AQUA, "Breaking News: A robbery is currently taking place at the Marina Casino!");

    foreach (new i : Player)
    {
        if (IsRobber[i])
        {
            PlayerPlaySound(i, 5205, 0.0, 0.0, 0.0); // Vault alarm for player
            PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0); // Additional sound
            SetPlayerAttachedObject(i, 8, 19801, 2, 0.091000, 0.012000, 0.000000, 0.099999, 87.799957, 179.500015, 1.345999, 1.523000, 1.270001);
            SetPlayerAttachedObject(i, 9, 1550, 1, 0.116999, -0.170999, -0.016000, -3.099997, 87.800018, -179.400009, 0.602000, 0.640000, 0.625000);
            ApplyAnimation(i, "GOGGLES", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
        }
    }

    return 1;
}

forward HeistTimeExpire();
public HeistTimeExpire() {
    PlaySoundForAll(5206, 0.0, 0.0, 0.0); // Police sirens

    // Reset heist data
    ResetHeist();
}

PlaySoundForAll(soundid, Float:x, Float:y, Float:z) {
    foreach(new i : Player) {
        if(IsPlayerConnected(i)) {
            PlayerPlaySound(i, soundid, x, y, z);
        }
    }
}

ResetHeist() {
    HeistData[hActive] = false;
    HeistData[hDoorBreached] = false;
    
    if(HeistData[hC4Timer] != 0) {
	    KillTimer(HeistData[hC4Timer]);
	    HeistData[hC4Timer] = 0;
	}
    HeistData[hC4Planted] = false;
    
    HeistData[hVaultOpen] = false;
    HeistData[hLootTaken] = 0;

    DestroyObject(g_CazinoObject[0]);
    g_CazinoObject[0] = CreateObject(1569, 2147.0524, 1604.7028, 1005.1768, 0.0, 0.0, 0.0);
    HeistData[hDoorKicks] = 0;

    // Reset doors
    DestroyObject(g_CazinoObject[0]);
    g_CazinoObject[0] = CreateObject(1569, 2147.0524, 1604.7028, 1005.1768, 0.0, 0.0, 0.0);
    DestroyObject(g_CazinoObject[2]);
    g_CazinoObject[2] = CreateObject(19799, 2143.1811, 1627.0026, 994.3052, 0.0, 0.0, 179.6);

    // Reset money bags
    DestroyObject(g_CazinoObject[6]);
    DestroyObject(g_CazinoObject[7]);
    g_CazinoObject[6] = CreateObject(1550, 2142.8161, 1639.5217, 993.5619, 87.1, 152.4, -175.4);
    g_CazinoObject[7] = CreateObject(1550, 2144.2661, 1640.9354, 993.6366, 87.1, 152.4, -175.4);
    
    foreach (new i : Player)
	{
	    IsRobber[i] = false;
	}
}


hook OnPlayerDisconnect(playerid)
{
    if (IsRobber[playerid])
    {
        RemovePlayerAttachedObject(playerid, 8);
        RemovePlayerAttachedObject(playerid, 9);

        IsRobber[playerid] = false;
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (IsRobber[playerid])
    {
        RemovePlayerAttachedObject(playerid, 8); // Mask/Goggles
        RemovePlayerAttachedObject(playerid, 9); // Money Bag or other

        IsRobber[playerid] = false;
    }
    return 1;
}

public OnGameModeExit() {
    ResetHeist();
    for(new i = 0; i < sizeof(g_CazinoObject); i++) DestroyObject(g_CazinoObject[i]);
    return 1;
}


// For Test

CMD:go(playerid) {
	SetPlayerSkin(playerid, 217);
	GivePlayerWeapon(playerid, WEAPON_M4, 500);

    SetPlayerInterior(playerid, 1);
    SetPlayerPos(playerid, 2233.93, 1711.80, 1011.63);
    return 1;
}
