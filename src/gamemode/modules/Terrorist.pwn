#include <YSI\y_hooks>

new Andromeda[MAX_PLAYERS];
new bool:AirstrikeImmune[MAX_PLAYERS];


stock Float: GetPointZPos(const Float: fX, const Float: fY, &Float: fZ = 0.0)
{
    if (!((-3000.0 < fX < 3000.0) && (-3000.0 < fY < 3000.0)))
    {
        return 0.0;
    }
    static File: s_hMap;
    if (!s_hMap)
    {
        s_hMap = fopen("SAfull.hmap", io_read);
        if (!s_hMap)
        {
            return 0.0;
        }
    }
    new afZ[1];
    fseek(s_hMap, ((6000 * (-floatround(fY, floatround_tozero) + 3000) + (floatround(fX, floatround_tozero) + 3000)) << 1));
    fblockread(s_hMap, afZ);
    return (fZ = ((afZ[0] >>> 16) * 0.01));
}

CMD:airstrike(playerid, params[])
{

    if(GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a terrorist.");
    }
    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command indoors.");
	}
    if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from within the vehicle.");
	}
 	if(PlayerData[playerid][pFactionRank] < 4)
 	{
 	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    {
        new Float:x, Float:y, Float:z, Float:zpos;
        GetPlayerPos(playerid, x, y, z);
        GetPointZPos(x, y, zpos);
        
        SetTimerEx("Airstrike", 5000, 0, "ifff", playerid, x, y, zpos);
        SendClientMessage(playerid, -1, "{FF0000}[AIRSTRIKE] {FFFFFF}Airstrike incoming in 5 seconds!");
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has used the Airstrike in %s.", GetRPName(playerid), playerid, GetPlayerZoneName(playerid));
    }
    return 1;
}

forward Airstrike(playerid, Float:x, Float:y, Float:z);
public Airstrike(playerid, Float:x, Float:y, Float:z)
{
    Andromeda[playerid] = CreateDynamicObject(14553, x - 200, y, z + 150, 0.000000, 0.000000, 90);
    new time = MoveDynamicObject(Andromeda[playerid], x + 200, y, z + 150, 50.0, 0, 0, 90);
    SetTimerEx("CreateAirstrikeExplosions", 4000, 0, "ifff", playerid, x, y, z);
    SetTimerEx("DestroyAndrom", time, 0, "i", playerid);
}

forward CreateAirstrikeExplosions(playerid, Float:x, Float:y, Float:z);
public CreateAirstrikeExplosions(playerid, Float:x, Float:y, Float:z)
{
    for(new i = -20; i <= 40; i += 1)
    {
        CreateExplosion(x + i, y, z, 7, 10.0);
        CreateExplosion(x + i, y + 3, z, 7, 10.0);
        CreateExplosion(x + i, y - 3, z, 7, 10.0);
        CreateExplosion(x + i, y + 6, z, 7, 10.0);
        CreateExplosion(x + i, y - 6, z, 7, 10.0);
    }
    
    for(new i = -20; i <= 40; i += 3)
    {
        CreateExplosion(x + i, y + 9, z, 6, 10.0);
        CreateExplosion(x + i, y - 9, z, 6, 10.0);
        CreateExplosion(x + i, y + 12, z, 6, 10.0);
        CreateExplosion(x + i, y - 12, z, 6, 10.0);
    }
    
    SendClientMessageToAllEx(COLOR_AQUA, "Breaking News: A massive explosion has been reported in %s! Multiple casualties confirmed.", GetPlayerZoneName(playerid));
    SendClientMessageToAll(COLOR_GREY1, "____________ Terrorist Organization Announcement ____________");
    SendClientMessageToAllEx(0xff0000ff, "Terroristt organization claims responsibility for the %s airstrike!", GetPlayerZoneName(playerid));
    SendClientMessageToAll(0xff0000ff, "We have demonstrated our power. This is only the beginning.");
    SendClientMessageToAll(0xff0000ff, "Meet our demands or face total destruction.");
    SendClientMessageToAll(0xff0000ff, "Your government cannot protect you. Surrender is your only option.");

    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(i, px, py, pz);
        new Float:distance = floatsqroot(floatpower(px - (x + 10), 2.0) + floatpower(py - y, 2.0));
        
        if(distance < 80.0)
        {
            SetPlayerHealth(i, 0);
            SetPlayerArmour(i, 0);
            SendClientMessage(i, -1, "{FF0000}[AIRSTRIKE] {FFFFFF}You were killed by an airstrike!");
            SetTimerEx("ForcePlayerDeath", 100, 0, "i", i);
        }
    }
    
    for(new v = 1; v < MAX_VEHICLES; v++)
    {
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(v, vx, vy, vz);
        if(vx == 0.0 && vy == 0.0 && vz == 0.0) continue;
        new Float:distance = floatsqroot(floatpower(vx - (x + 10), 2.0) + floatpower(vy - y, 2.0));
        
        if(distance < 80.0)
        {
            VehicleInfo[v][vHealth] = 0.0;
            SetVehicleHealth(v, 0.0);
        }
    }
}

forward ForcePlayerDeath(playerid);
public ForcePlayerDeath(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        SetPlayerHealth(playerid, 0);
    }
}

forward DestroyAndrom(playerid);
public DestroyAndrom(playerid)
{
    if (Andromeda[playerid] != INVALID_OBJECT_ID)
    {
        DestroyDynamicObject(Andromeda[playerid]);
        Andromeda[playerid] = INVALID_OBJECT_ID;
    }
}

hook OnGameModeInit()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        Andromeda[i] = INVALID_OBJECT_ID;
        AirstrikeImmune[i] = false;
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    Andromeda[playerid] = INVALID_OBJECT_ID;
    AirstrikeImmune[playerid] = false;
    return 1;
}

CMD:plantcarbomb(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a terrorist.");
    }
    if(PlayerData[playerid][pFactionRank] < 4)
 	{
 	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(!PlayerData[playerid][pBombs])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any bombs.");
    }
    if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You cannot create garages indoors.");
	}
    if(PlayerData[playerid][pVehicleBombPlanted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have already planted a car bomb.");
    }
    
    if(IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't plant a bomb while inside a vehicle.");
    }
    
    new vehicleid = GetClosestVehicle(playerid, 5);
    
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no vehicle near you.");
    }
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
    
    PlayerData[playerid][pVehicleBombObject] = CreateDynamicObject(19602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    AttachDynamicObjectToVehicle(PlayerData[playerid][pVehicleBombObject], vehicleid, 0.0, 0.0, -0.8, 0.0, 0.0, 0.0);
    
    PlayerData[playerid][pVehicleBombPlanted] = 1;
    PlayerData[playerid][pVehicleBombVehicleID] = vehicleid;
    PlayerData[playerid][pBombs]--;
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", PlayerData[playerid][pBombs], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    
    new string[128];
    format(string, sizeof(string), "* Car bomb planted on vehicle ID %d! Use /detonatecar to detonate it.", vehicleid);
    SendClientMessage(playerid, COLOR_WHITE, string);
    return 1;
}

CMD:pickupcarbomb(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a terrorist.");
    }   
    if(!PlayerData[playerid][pVehicleBombPlanted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't planted a car bomb.");
    }
    
    if(!IsPlayerInRangeOfVehicle(playerid, PlayerData[playerid][pVehicleBombVehicleID], 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near the vehicle with your bomb.");
    }
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
    
    DestroyDynamicObject(PlayerData[playerid][pVehicleBombObject]);
    
    PlayerData[playerid][pVehicleBombObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pVehicleBombPlanted] = 0;
    PlayerData[playerid][pVehicleBombVehicleID] = INVALID_VEHICLE_ID;
    PlayerData[playerid][pBombs]++;
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", PlayerData[playerid][pBombs], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    
    SendClientMessage(playerid, COLOR_WHITE, "* You have picked up your car bomb.");
    return 1;
}

CMD:detonatecar(playerid, params[])
{
    new Float:vehX, Float:vehY, Float:vehZ;
    
    if(GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a terrorist.");
    }
    if(!PlayerData[playerid][pVehicleBombPlanted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't planted a car bomb to detonate.");
    }
    
    GetVehiclePos(PlayerData[playerid][pVehicleBombVehicleID], vehX, vehY, vehZ);
    
    if(!IsPlayerInRangeOfPoint(playerid, 10.0, vehX, vehY, vehZ))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are too far away from the car bomb.");
    }
    
    CreateExplosion(vehX, vehY, vehZ, 7, 10.0);
    CreateExplosion(vehX, vehY, vehZ + 1.0, 7, 10.0);
    CreateExplosion(vehX + 2, vehY, vehZ, 7, 10.0);
    CreateExplosion(vehX - 2, vehY, vehZ, 7, 10.0);
    CreateExplosion(vehX, vehY + 2, vehZ, 7, 10.0);
    CreateExplosion(vehX, vehY - 2, vehZ, 7, 10.0);
    
    DestroyDynamicObject(PlayerData[playerid][pVehicleBombObject]);
    
    SetVehicleHealth(PlayerData[playerid][pVehicleBombVehicleID], 0.0);
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        
        if(IsPlayerInVehicle(i, PlayerData[playerid][pVehicleBombVehicleID]))
        {
            SetPlayerHealth(i, 0.0);
            SetPlayerArmour(i, 0.0);
            SendClientMessage(i, COLOR_RED, "* You were killed by a car bomb!");
            SetTimerEx("ForcePlayerDeath", 100, 0, "i", i);
            
            if(PlayerData[playerid][pContractTaken] == i)
            {
                HandleContract(i, playerid);
            }
            continue;
        }
        
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(i, px, py, pz);
        new Float:distance = floatsqroot(floatpower(px - vehX, 2.0) + floatpower(py - vehY, 2.0));
        
        if(distance < 15.0) // Kill radius
        {
            SetPlayerHealth(i, 0.0);
            SetPlayerArmour(i, 0.0);
            SendClientMessage(i, COLOR_RED, "* You were killed by a car bomb explosion!");
            SetTimerEx("ForcePlayerDeath", 100, 0, "i", i);
            
            if(PlayerData[playerid][pContractTaken] == i)
            {
                HandleContract(i, playerid);
            }
        }
    }
    
    PlayerData[playerid][pVehicleBombObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pVehicleBombPlanted] = 0;
    PlayerData[playerid][pVehicleBombVehicleID] = INVALID_VEHICLE_ID;
    
    SendClientMessage(playerid, COLOR_WHITE, "* You have detonated the car bomb! BOOM!");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][pVehicleBombPlanted])
    {
        DestroyDynamicObject(PlayerData[playerid][pVehicleBombObject]);
        PlayerData[playerid][pVehicleBombPlanted] = 0;
        PlayerData[playerid][pVehicleBombVehicleID] = INVALID_VEHICLE_ID;
    }
    return 1;
}

CMD:checkbomb(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a terrorist.");
    }
    if(!PlayerData[playerid][pVehicleBombPlanted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't planted a car bomb.");
    }
    
    new Float:x, Float:y, Float:z, string[128];
    GetVehiclePos(PlayerData[playerid][pVehicleBombVehicleID], x, y, z);
    SetPlayerCheckpoint(playerid, x, y, z, 5.0);
    format(string, sizeof(string), "* Your bomb is on vehicle ID %d. Checkpoint set.", PlayerData[playerid][pVehicleBombVehicleID]);
    SendClientMessage(playerid, COLOR_YELLOW, string);
    return 1;
}

CMD:getbomb(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a terrorist.");
    }
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -339.778625, 1293.604248, 6.690937))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the bomb pickup location.");
    }
    
    if(PlayerData[playerid][pFactionRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be rank 4 to order a bomb.");
    }
    
    if(PlayerData[playerid][pCash] < 2500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
    }
    
    if(PlayerData[playerid][pBombs] > 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have more than 3 bombs. You can't buy anymore.");
    }

    PlayerData[playerid][pBombs]++;
    GivePlayerCash(playerid, -2500);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", PlayerData[playerid][pBombs], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a bomb for $2,500. /plantcarbomb to place the bomb.");
    GameTextForPlayer(playerid, "~r~-$2500", 5000, 1);
    
    return 1;
}