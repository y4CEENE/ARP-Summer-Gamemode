#include <YSI\y_hooks>

forward OnSmugglingStartComplete(playerid);

static IsSmuggling[MAX_PLAYERS];
static HasBox[MAX_PLAYERS];
static DeliveryPoint[MAX_PLAYERS]; // Store which delivery point was chosen


#define WEAPON_LIMIT 500 // Max stash amount per weapon

// Delivery points array (3 random spots)
new Float:DeliveryCoords[3][3] = {
    {1847.563476, -1793.491333, 13.546875}, // LS
    {1058.673095, 1260.676391, 10.820312},  // LV
    {-2129.125244, -188.421859, 35.320312}  // SF
};

hook OnPlayerInit(playerid)
{
    IsSmuggling[playerid] = 0;
    HasBox[playerid] = 0;
    DeliveryPoint[playerid] = -1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    // Nothing special needed here
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Type /smuggler\nto start smuggling", COLOR_YELLOW, 2813.949951, 857.018127, 10.757797, 10.0);
    CreateActor(28, 2813.949951, 857.018127, 10.757797, 183.92);
    return 1;
}

CMD:smuggler(playerid, params[])
{
    if(PlayerData[playerid][pGang] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not part of any gang.");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2813.949951, 857.018127, 10.757797))
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the smuggler man.");

	if(PlayerData[playerid][pLevel] == 5)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't level 5+.");
	}
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
        return SendClientMessage(playerid, COLOR_GREY, "You must be onfoot to start smuggling.");

    if (IsSmuggling[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are already smuggling.");

    // Start smuggling animation
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    GameTextForPlayer(playerid, "~w~Start smuggling...", 5000, 3);

    IsSmuggling[playerid] = 1;
    HasBox[playerid] = 0;
    DeliveryPoint[playerid] = -1;

    // Set a timer to clear animation and send vehicle message
    SetTimerEx("OnSmugglingStartComplete", 5000, false, "i", playerid); 
    return 1;
}

// Called after smuggling start animation finishes
public OnSmugglingStartComplete(playerid)
{
    ClearAnimations(playerid);
    SendClientMessage(playerid, COLOR_AQUA, "Go to your vehicle and type /loadbox to start the delivery.");
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
    SetPlayerAttachedObject(playerid, 9, 3014, 6);
    return 1;
}

// Load box command
CMD:loadbox(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);

    if (!IsSmuggling[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You are not smuggling.");

    if (HasBox[playerid])
        return SendClientMessage(playerid, COLOR_GREY, "You already have a box loaded.");

	if(vehicleid == INVALID_VEHICLE_ID || !IsPlayerInRangeOfBoot(playerid, vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You need to be close to a vehicle's trunk.");
	}
    if(GetVehicleModel(vehicleid) != 482)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only use this command on smuggler vehicle.");
    }
    if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}

    HasBox[playerid] = 1;

    // Choose random delivery point
    new rand = random(sizeof(DeliveryCoords));
    DeliveryPoint[playerid] = rand;

    ApplyAnimation(playerid, "CARRY", "pickup", 4.1, 0, 0, 0, 0, 0, 1);
    RemovePlayerAttachedObject(playerid, 9);

    // Set random delivery checkpoint
    SetPlayerCheckpoint(playerid,
        DeliveryCoords[rand][0],
        DeliveryCoords[rand][1],
        DeliveryCoords[rand][2], 2.5);

    SendClientMessage(playerid, COLOR_AQUA, "Box loaded! Deliver it to the delivery checkpoint.");
    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
    SendLawEnforcementMessage(COLOR_YELLOW, "HQ: All Units: %s has started smuggling to get the box of weapons!", GetPlayerNameEx(playerid));
    return 1;
}

// Enter checkpoint
hook OnPlayerEnterCheckpoint(playerid)
{
    if (!IsSmuggling[playerid] || !HasBox[playerid]) return 1;

    new gangid = PlayerData[playerid][pGang];
    if (gangid == -1) return 1;

    // Give reward to gang stash (random weapon)
    new randomWeapons[] = {22,23,24,25,27,28,29,30,31,32,33,34};
    new weaponid = randomWeapons[random(sizeof(randomWeapons))];
    new qty = random(6)+5; // 5-10 items

    new widx = -1;
    switch(weaponid)
    {
        case 22: widx = GANGWEAPON_9MM;
        case 23: widx = GANGWEAPON_SDPISTOL;
        case 24: widx = GANGWEAPON_DEAGLE;
        case 25: widx = GANGWEAPON_SHOTGUN;
        case 27: widx = GANGWEAPON_SPAS12;
        case 28: widx = GANGWEAPON_UZI;
        case 29: widx = GANGWEAPON_MP5;
        case 30: widx = GANGWEAPON_AK47;
        case 31: widx = GANGWEAPON_M4;
        case 32: widx = GANGWEAPON_TEC9;
        case 33: widx = GANGWEAPON_RIFLE;
        case 34: widx = GANGWEAPON_SNIPER;
        case 35: SendGangMessage(gangid, COLOR_YELLOW, "Your gang didn’t earn %i Rockets (not implemented)!", qty);
    }

    if(widx != -1)
    {
        GangInfo[gangid][gWeapons][widx] = (GangInfo[gangid][gWeapons][widx] + qty > WEAPON_LIMIT) ? WEAPON_LIMIT : GangInfo[gangid][gWeapons][widx] + qty;
        SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %i of %s in the stash!", qty, GetWeaponNameEx(weaponid)); 
    }

    GivePlayerCash(playerid, 5000);
    SendClientMessage(playerid, COLOR_GREEN, "You delivered the box and received $5000!");

    HasBox[playerid] = 0;
    IsSmuggling[playerid] = 0;
    DisablePlayerCheckpoint(playerid);

    return 1;
}

CMD:robbox(playerid, params[])
{
    if(IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot rob boxes as a cop.");
    }
    if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}

    new targetid = -1;

    // Find a player carrying a box (ignore distance)
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(i == playerid) continue;
        if(!IsPlayerConnected(i)) continue;
        if(!IsSmuggling[i] || !HasBox[i]) continue;

        targetid = i;
        break;
    }

    if(targetid == -1)
        return SendClientMessage(playerid, COLOR_GREY, "No player is carrying a box nearby.");

    // Ensure the target is near their vehicle trunk
    new vehicleid = GetNearbyVehicle(targetid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsPlayerInRangeOfBoot(targetid, vehicleid))
        return SendClientMessage(playerid, COLOR_GREY, "The target is not near their vehicle.");

    if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GREY, "You can't rob from inside a vehicle.");

    // Transfer the box
    HasBox[targetid] = 0;
    HasBox[playerid] = 1;
    DeliveryPoint[playerid] = DeliveryPoint[targetid];
    DeliveryPoint[targetid] = -1;

    SendClientMessage(playerid, COLOR_RED, "You successfully robbed the box!");
    SendClientMessage(targetid, COLOR_RED, "Your box has been stolen!");

    // Give reward to robber
    GivePlayerCash(playerid, 10000);
    SendClientMessage(playerid, COLOR_GREEN, "You earned $10,000 for stealing the box!");

    // Apply animation for the robber
    ApplyAnimation(playerid, "CARRY", "pickup", 4.1, 0, 0, 0, 0, 0, 1);

    // Set checkpoint for the robber
    SetPlayerCheckpoint(playerid,
        DeliveryCoords[DeliveryPoint[playerid]][0],
        DeliveryCoords[DeliveryPoint[playerid]][1],
        DeliveryCoords[DeliveryPoint[playerid]][2], 2.5);

    return 1;
}
