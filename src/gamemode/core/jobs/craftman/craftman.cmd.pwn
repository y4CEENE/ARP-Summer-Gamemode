#include <YSI\y_hooks>

//In seconds
#define CRAFT_TIMEOUT 120
enum craftEnum{
    ciNone,
    ciPocketwatch, 
    ciFirstaid, 
    ciCamera, 
    ciParachute, 
    ciGps,
    ciBodykits, 
    ciScrewdriver, 
    ciSmslog,
    ciRccam, 
    ciPoliceScanner, 
    ciBugsweep,
    ciCrowbar
};
new CraftOffer[MAX_PLAYERS];
new craftEnum:CraftId[MAX_PLAYERS];
new CraftMats[MAX_PLAYERS];
new CraftName[MAX_PLAYERS][50];
new CraftmanTime[MAX_PLAYERS];
new CraftSellPrice[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    CraftOffer[playerid] = 999;
    CraftId[playerid] = ciNone;
    CraftMats[playerid] = 0;
    CraftmanTime[playerid] = 0;
    return 1;
}


GivePlayerCraftItem(playerid,craftEnum:item)
{
    switch (item) {
        case ciPocketwatch:{//Done
            PlayerData[playerid][pWatch]++;			
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "/watch");

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET watch = 1 WHERE uid = %i", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
        }
        case ciFirstaid:{//Done
            if(PlayerData[playerid][pFirstAid] + 1 > 20)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 20 first aid kits.");
            }

            PlayerData[playerid][pFirstAid]++;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /firstaid to in order to use a first aid kit.");
        }
        case ciCamera:{//Done
            GivePlayerWeaponEx(playerid, 43);
        }
        case ciGps:{//Done
            if(PlayerData[playerid][pGPS])
            {
                return SendClientMessage(playerid, COLOR_GREY, "You already have this item.");
            }
            PlayerData[playerid][pGPS] = 1;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gps = 1 WHERE uid = %i", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "/gps");
        }
        case ciParachute:{//Done
            GivePlayerWeaponEx(playerid, 46);
        }
        case ciBodykits:{
            if(PlayerData[playerid][pBodykits] + 1 > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 10 bodywork kits.");
            }

            PlayerData[playerid][pBodykits]++;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            
            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /bodykit in a vehicle to repair its bodywork and health.");
        }
        case ciPoliceScanner:{
            if(PlayerData[playerid][pPoliceScanner] + 1 > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 10 police scanners.");
            }

            PlayerData[playerid][pPoliceScanner]++;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET policescanner = 1 WHERE uid = %i", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);

            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use /scanner to listen to emergency and department chats.");
        }
        case ciBugsweep:{
            PlayerData[playerid][pSweep]++;
            PlayerData[playerid][pSweepLeft] = 3;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET sweep = %i, sweepleft = %i WHERE uid = %i", PlayerData[playerid][pSweep], PlayerData[playerid][pSweepLeft], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "/sweep");
        }
        case ciRccam:{
            if(PlayerData[playerid][pPoliceScanner] + 1 > 10)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 10 rccam.");
            }
            PlayerData[playerid][pRccam]++;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET rccam = %i WHERE uid = %i", PlayerData[playerid][pRccam], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "/rccam");
        }
        case ciCrowbar:{
            if(PlayerData[playerid][pVehicleCMD] == 1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't carry more than 1 vehicle command.");
            }
            PlayerData[playerid][pCrowbar] = 1;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET crowbar = %i WHERE uid = %i", PlayerData[playerid][pRimkits], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);

            SendClientMessage(playerid, COLOR_WHITE, "HINT: Use '/breakcuffs' to break cuffs from anybody's hand.");
        }
        /*case ciScrewdriver:{
            PlayerData[playerid][pScrewdriver]++;
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "/sellgun");
        }            
        */
    }
    return 1;
}

AcceptCraft(playerid)
{
    new sellprice=0;//not used

    if(CraftOffer[playerid] >= 999)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   No-one offered you a Weapon!");
    }

    if(!IsPlayerConnected(CraftOffer[playerid]))
    {
        CraftOffer[playerid]=999;
        return SendClientMessage(playerid, COLOR_GREY, "   Craftman is no more online!");
    }
    
    if(PlayerData[CraftOffer[playerid]][pMaterials] < CraftMats[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
    }
    
    if(!IsPlayerNearPlayer(playerid, CraftOffer[playerid], 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be the near the player that is selling you the item!");
    }
    
    if(!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't accept a craft try again later.");
    }

    if(IsPlayerInAnyVehicle(playerid)) 
    {
        return SendClientMessage(playerid, COLOR_GREY, "Please exit the vehicle, before using this command.");
    }
    
    if(CraftSellPrice[playerid] > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to buy this item.");
    }

    GivePlayerCraftItem(playerid, CraftId[playerid]);

    SendClientMessageEx(CraftOffer[playerid], COLOR_GREY, "   You have craft a %s for %s.", CraftName[playerid], GetPlayerNameEx(playerid));
    PlayerPlaySound(CraftOffer[playerid], 1052, 0.0, 0.0, 0.0);

    SendClientMessageEx(playerid, COLOR_GREY, "   You have recieved a %s from %s.", CraftName[playerid], GetPlayerNameEx(CraftOffer[playerid]));
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    
    SendNearbyMessage(playerid, 30.0, COLOR_AQUA, "* %s created something from Materials, and hands it to %s.", GetPlayerNameEx(CraftOffer[playerid]), GetPlayerNameEx(playerid));
    
    Log_Write("log_give", "%s (uid: %i) has craft a %s to %s (uid: %i) for $%i.", 
        GetPlayerNameEx(CraftOffer[playerid] ), 
        PlayerData[CraftOffer[playerid] ][pID], 
        CraftName[playerid],
        GetPlayerNameEx(playerid), PlayerData[playerid][pID], sellprice);

    PlayerData[CraftOffer[playerid]][pMaterials] -= CraftMats[playerid];
	
    GivePlayerCash(playerid, -CraftSellPrice[playerid]);
	GivePlayerCash(CraftOffer[playerid], CraftSellPrice[playerid]);
    GiveJobSkill(CraftOffer[playerid], JOB_CRAFTMAN);
    CraftOffer[playerid] = 999;
    CraftId[playerid] = ciNone;
    CraftMats[playerid] = 0;
    return 1;
}

// IORP Script
CMD:craft(playerid, params[])
{
    if(PlayerData[playerid][pAdminDuty]) 
    {
        return SendClientMessage(playerid, COLOR_WHITE, "You can't use this command while on-duty as admin.");
    }
    if(!PlayerHasJob(playerid, JOB_CRAFTMAN)) 
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You're not a Craftsman!");
    }
    if(PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You can't make things while in jail or prison!");
    }

    new timeout = gettime() - CraftmanTime[playerid];
    new cooldown = CRAFT_TIMEOUT - 20 * (GetJobLevel(playerid, JOB_CRAFTMAN) - 1);
    if(timeout < cooldown)
    {
    	return SendClientMessageEx(playerid, COLOR_GREY, "   You must wait %d seconds before crafting again.", cooldown - timeout);
    }

    new targetid, choice[32], craftprice, sellprice, craftEnum:item;

    if(sscanf(params, "us[32]I(0)", targetid, choice, sellprice))
    {
        SendClientMessage(playerid, COLOR_GREEN, "________________________________________________");
        SendClientMessage(playerid, COLOR_YELLOW, "<< Available crafts >>");
        SendClientMessage(playerid, COLOR_GREY, "parachute(50), bodykit(250), camera(250), pocketwatch(500), firstaid(1000)");
        SendClientMessage(playerid, COLOR_GREY, "gps(1000), crowbar(1500), policescanner(5000), rccam(8000), bugsweep(10000)");
        //SendClientMessage(playerid, COLOR_GREY, "screwdriver(1000), smslog(2000)");
        SendClientMessage(playerid, COLOR_GREEN, "________________________________________________");
        SendClientMessage(playerid, COLOR_WHITE, "USAGE: /craft [playerid/partofname] [craftname] [price]");
        return 1;
    }

    if(!IsPlayerConnected(targetid)) 
    {
        SendClientMessage(playerid, COLOR_GREY, "Invalid player specified.");
        return 1;
    }

    if(PlayerData[targetid][pInjured])
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't craft whilst in Hospital.");
        return 1;
    }
    
    if(!IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        SendClientMessage(playerid, COLOR_GREY, "That player isn't near you.");
        return 1;
    }

    if(strcmp(choice, "pocketwatch", true) == 0)         { craftprice =   500; item = ciPocketwatch; }
    else if(strcmp(choice, "bodykit", true) == 0)        { craftprice =   250; item = ciBodykits; }
    else if(strcmp(choice, "firstaid", true) == 0)       { craftprice =  1000; item = ciFirstaid; }
    else if(strcmp(choice, "camera", true) == 0)         { craftprice =   250; item = ciCamera; }
    else if(strcmp(choice, "rccam", true) == 0)          { craftprice =  8000; item = ciRccam; }
    else if(strcmp(choice, "policescanner", true) == 0)  { craftprice =  5000; item = ciPoliceScanner; }
    else if(strcmp(choice, "gps", true) == 0)            { craftprice =  1000; item = ciGps; }
    else if(strcmp(choice, "bugsweep", true) == 0)       { craftprice = 10000; item = ciBugsweep; }
    else if(strcmp(choice, "parachute", true) == 0)      { craftprice =    50; item = ciParachute; }
    else if(strcmp(choice, "crowbar", true) == 0)        { craftprice =  1500; item = ciCrowbar; }
    //else if(strcmp(choice, "screwdriver", true) == 0)  { craftprice =  1000; item = ciScrewdriver; }
    //else if(strcmp(choice, "smslog", true) == 0)       { craftprice =  2000; item = ciSmslog; }
    else
    {
        return SendClientMessage(playerid, COLOR_GREY, "   Invalid Craft name!");
    }
    
    if(PlayerData[playerid][pMaterials] < craftprice)
    {
        return SendClientMessage(playerid,COLOR_GREY,"   Not enough Materials for that!");
    }

    if(targetid == playerid)
    {
        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        SendClientMessageEx(playerid, COLOR_AQUA, "   You have craft a %s for yourself.", choice);
		ShowActionBubble(playerid, "* %s created something from Materials, and hide it.", GetPlayerNameEx(playerid));

        PlayerData[playerid][pMaterials] -= craftprice;
        CraftmanTime[playerid] = gettime();
        GivePlayerCraftItem(playerid, item);
        return 1;
    }

    if( sellprice < 1 || sellprice > 100000)
    {
        return SendClientMessage(playerid,COLOR_GREY,"   Price must be between $1 and $100,000!");
    }
    
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You offered %s to buy a %s for $%i.", GetPlayerNameEx(targetid), choice, sellprice);
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "* Craftsman %s wants to sell you a %s for $%i, (type /accept craft) to buy.", GetPlayerNameEx(playerid), choice, sellprice);
    CraftOffer[targetid] = playerid;
    CraftId[targetid] = item;
    CraftMats[targetid] = craftprice;
    CraftSellPrice[targetid] = sellprice;
    CraftmanTime[playerid] = gettime();
    format(CraftName[targetid], 50, "%s", choice);
    
    return 1;
}

CMD:craftinventory(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "________________________________________________");
    SendClientMessage(playerid, COLOR_YELLOW, "<< Craft Inventory >>");        
    SendClientMessageEx(playerid, COLOR_GREY,  "Pocketwatch: %d Bodykit: %d", 
        PlayerData[playerid][pWatch], PlayerData[playerid][pBodykits]);
    SendClientMessageEx(playerid, COLOR_GREY, "Firstaid: %d    Rccam: %d", 
        PlayerData[playerid][pFirstAid], PlayerData[playerid][pRccam]);
    SendClientMessageEx(playerid, COLOR_GREY, "GPS: %d         Police Scanner: %d", 
        PlayerData[playerid][pGPS], PlayerData[playerid][pPoliceScanner]);
    SendClientMessageEx(playerid, COLOR_GREY, "Bug Sweep: %d   Crowbar: %d", 
        PlayerData[playerid][pSweep], PlayerData[playerid][pCrowbar]);
    return 1;
}

