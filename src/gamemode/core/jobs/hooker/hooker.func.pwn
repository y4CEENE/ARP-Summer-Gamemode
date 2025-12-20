#include <YSI\y_hooks>

hook OnPlayerInit(playerid)
{
    SexOffer[playerid] = -1;
    SexPrice[playerid] = 0;
    SexLastTime[playerid] = 0;
    STD[playerid] = 0;
    STDTimerId[playerid]=0;
    return 1;
}

STDChance(hookerid, clientid){
    new idx = random(21);
    new lvl = GetJobLevel(hookerid, JOB_HOOKER);
    
    if(lvl < 5)
        STD[hookerid] = STDProbability[lvl - 1][idx];
    
    if(STD[hookerid] != 0)
        STD[clientid] = STD[hookerid];

    return STD[hookerid];
}

OnAcceptSex(playerid)
{
    new offeredby=SexOffer[playerid];
    SexOffer[playerid]=-1;

    if(offeredby == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "No one offered you sex.");
    }

    if(SexPrice[playerid] > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash!");
    }

    if(!PlayersCanHaveSex(playerid, offeredby))
        return 1;


    GivePlayerCash(offeredby, SexPrice[playerid]);
    GivePlayerCash(playerid, -SexPrice[playerid]);
    
    if(PlayerData[playerid][pCondom] > 0){
        PlayerData[playerid][pCondom]--;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET condom = %i WHERE uid = %i", PlayerData[playerid][pCondom], PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
        STD[offeredby] = 0;
        STD[playerid] = 0;
        SendClientMessage(offeredby, COLOR_DOCTOR, "* The player used a Condom.");
        SendClientMessage(playerid, COLOR_DOCTOR, "* You used a Condom.");
    } else STDChance(offeredby, playerid); 
    
    new Float:health;
    GetPlayerHealth(playerid, health);
    health += 10 * GetJobLevel(offeredby, JOB_HOOKER);
    if(health > 150) 
        health = 150;
    SetPlayerHealth(playerid, health);
    
    SendClientMessageEx(playerid, COLOR_AQUA, "* You got %d Health + %s while having Sex.", 10 * GetJobLevel(offeredby, JOB_HOOKER), STDName[STD[playerid]]);
    if(STD[playerid] == 0)
        SendClientMessageEx(offeredby, COLOR_GREEN, "* You haven't got a STI while having Sex.");
    else SendClientMessageEx(offeredby, COLOR_RED, "* You got %s because of the Sex.", STDName[STD[playerid]]);

    IncreaseJobSkill(offeredby, JOB_HOOKER);
    SendNearbyMessage(playerid, 15.0, COLOR_AQUA, "%s and %s are having sex.",GetRPName(playerid),GetRPName(offeredby));
    SendClientMessageEx(playerid, COLOR_AQUA, "* %s had sex with you. And you have earned $%d.", GetRPName(offeredby), SexPrice[playerid]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* You had sex with Hooker %s, for $%d.", GetRPName(playerid), SexPrice[playerid]);
    
    GiveNotoriety(playerid, 5);
	GiveNotoriety(offeredby, 5);	
    SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for prostitution, you now have %d.", PlayerData[playerid][pNotoriety]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 5 notoriety for prostitution, you now have %d.", PlayerData[offeredby][pNotoriety]);
    
    STDTimerId[offeredby] = SetTimerEx("STDTimer", 1000, true, "i", offeredby);
    STDTimerId[playerid] = SetTimerEx("STDTimer", 1000, true, "i", playerid);
    AwardAchievement(offeredby, ACH_YouAreAHooker);

    return 1;
}

forward STDTimer(playerid);
public STDTimer(playerid)
{

    new Float:health;
    GetPlayerHealth(playerid, health);    
    SetPlayerHealth(playerid, health - STD[playerid]);
    if(health - STD[playerid] <= 0) {
        STD[playerid] = 0;
        KillTimer(STDTimerId[playerid]);//Disable timer
    }
}

PlayersCanHaveSex(playerid, targetid)
{
    if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        return 0;
	}
	if(targetid == playerid)
	{
	    SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
        return 0;
	}
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid,x, y, z);
	if(!IsPlayerInRangeOfPoint(targetid,5,x,y,z)){
		SendClientMessage(playerid,-1,"This isn't near you.");
        return 0;
	}

	if(!IsPlayerInAnyVehicle(playerid) || !IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
	{
		SendClientMessage(playerid, COLOR_GREY, "   You or the other player must be in a Car together!");
		return 0;
	}

    return 1;
}