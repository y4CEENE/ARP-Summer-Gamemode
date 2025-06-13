/// @file      Fbi.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:listbugs(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a federal agent.");
        return 1;
    }

    SendClientMessage(playerid, COLOR_GREEN, "Online Bugged players:");
    foreach(new i : Player)
    {
        if (PlayerData[i][pBugged])
        {
            //SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Placed by: %s - Location: %s", GetRPName(i), PlayerData[i][pBuggedBy], GetPlayerZoneName(i));
            SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Placed by: %s", GetRPName(i), PlayerData[i][pBuggedBy]);
        }
    }
    return 1;
}

CMD:olistbugs(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
    {
        SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a federal agent.");
        return 1;
    }

    DBFormat("SELECT username,buggedby FROM "#TABLE_USERS" WHERE bugged = 1");
    DBExecute("OnPlayerSelectAllBugged", "i", playerid);

    return 1;
}

DB:OnPlayerSelectAllBugged(playerid)
{
    new rows = GetDBNumRows();
    new username[MAX_PLAYER_NAME],
        buggedby[MAX_PLAYER_NAME];

    SendClientMessage(playerid, COLOR_GREEN, "All Bugged players:");

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "username", username);
        GetDBStringField(i, "buggedby", buggedby);
        SendClientMessageEx(playerid, COLOR_GREY, "Name: %s - Placed by: %s", username, buggedby);
    }
}
CMD:bug(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a federal agent.");
    }
    if (!PlayerData[playerid][pToggleBug])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Enable the bug channel first! (/tog bugged)");
    }
    new
        targetid;

    if (sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, COLOR_WHITE, "USAGE: /bug [playerid]");
    }
    if (PlayerData[targetid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't place bugs on admins.");
    }
    if (PlayerData[targetid][pBugged] == 1)
    {
        PlayerData[targetid][pBugged] = 0;
        DBQuery("UPDATE "#TABLE_USERS" SET bugged = 0, buggedby='' WHERE uid = %i", PlayerData[targetid][pID]);

        SendClientMessageEx(playerid, COLOR_GREY, "The bug on %s has been disabled.", GetRPName(targetid));
    }
    else if (IsPlayerNearPlayer(playerid, targetid, 4.0))
    {
        PlayerData[targetid][pBugged] = 1;
        strcpy(PlayerData[targetid][pBuggedBy], GetRPName(playerid),MAX_PLAYER_NAME);
        SendClientMessageEx(playerid, COLOR_GREY ,"You have placed a bug on %s.",GetRPName(targetid));

        DBQuery("UPDATE "#TABLE_USERS" SET bugged = 1, buggedby='%e' WHERE uid = %i", PlayerData[targetid][pBuggedBy], PlayerData[targetid][pID]);

    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You need to be closer to that person.");
        return 1;
    }

    return 1;
}
CMD:clearbugs (playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
    {
        return SendClientMessage(playerid, COLOR_GREY, "[!] You are not a federal agent.");
    }

    if (PlayerData[playerid][pFactionRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "[!] You are not a allowed to use this command.");
    }

    foreach(new i : Player)
    {
        PlayerData[i][pBugged] = 0;
    }


    DBQuery("UPDATE "#TABLE_USERS" SET bugged = 0, buggedby=''");


    SendClientMessage(playerid, COLOR_GREY, "All bugs has been cleared.");

    return 1;
}

// Terrorist

#define KNIFE_PRICE 5000
#define BOMB_PRICE 5000

CMD:getknife(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2160.1054, 646.5540, 1057.5860))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of terrorist locker.");
    }
    if (PlayerData[playerid][pFactionRank] < 4)
    {
        return SendUnauthorized(playerid);
    }
    if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a Terrorist.");
    }
    if (PlayerData[playerid][pCash] < KNIFE_PRICE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to get a knife.");
    }

	GivePlayerWeaponEx(playerid, 4);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a knife for $5000..");

    return 1;
}

CMD:getbomb(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2160.1054, 646.5540, 1057.5860))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of terrorist locker.");
    }
    if (PlayerData[playerid][pFactionRank] < 4)
    {
        return SendUnauthorized(playerid);
    }
    if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a Terrorist.");
    }
    if (PlayerData[playerid][pBombs] > 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have more than 3 bombs. You can't buy anymore.");
    }
    if (PlayerData[playerid][pCash] < BOMB_PRICE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to get a bomb.");
    }  
	PlayerData[playerid][pBombs]++;
	SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a bomb for $5000. /plantbomb to place the bomb.");

    return 1;
}

CMD:notoriety(playerid, params[])
{

    if (GetPlayerFaction(playerid) != FACTION_FEDERAL && !PlayerHasJob(playerid, JOB_LAWYER))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a lawyer or a federal agent.");
    }

    SendClientMessageEx(playerid, COLOR_BLUE, "Listing notorious suspects...");

    foreach(new i : Player)
    {
        if (PlayerData[i][pNotoriety] >= 4000)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "%s - Notoriety Level: %d", GetPlayerNameEx(i), PlayerData[i][pNotoriety]);
        }
    }

    return 1;
}

CMD:sweep(playerid, params[])
{

    if (PlayerData[playerid][pSweep] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a bug sweep!");

    if (PlayerData[playerid][pSweepLeft] <= 0)
    {
        PlayerData[playerid][pSweep]--;
        PlayerData[playerid][pSweepLeft] = 3;
        return SendClientMessage(playerid, COLOR_GREY, "Your Bug Sweeper has ran out of batteries!");
    }

    new giveplayerid;

    if (sscanf(params, "u", giveplayerid))
        return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sweep [playerid/partofname]");



    if (!IsPlayerNearPlayer(playerid, giveplayerid, 4.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be close to the person.");
    }

    PlayerData[playerid][pSweepLeft]--;
    DBQuery("UPDATE "#TABLE_USERS" SET sweep = %i, sweepleft = %i WHERE uid = %i", PlayerData[playerid][pSweep], PlayerData[playerid][pSweepLeft], PlayerData[playerid][pID]);


    SendNearbyMessage(playerid, 30.0, COLOR_AQUA, "* %s sweeps a large wand around %s's body...", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));

    if (PlayerData[giveplayerid][pBugged] <= 0)
    {
        return SendNearbyMessage(playerid, 30.0, COLOR_GREEN, "Nothing happens.");
    }

    PlayerData[giveplayerid][pBugged] = 0;
    SendNearbyMessage(playerid, 30.0, COLOR_YELLOW, "* A small spark is seen as the bug on %s shorts out.", GetPlayerNameEx(giveplayerid));

    foreach(new i : Player)
    {
        if (GetPlayerFaction(i) == FACTION_FEDERAL)
        {
            SendClientMessageEx(i, 0x9ACD3200, "(bug) %s says [radio]: *static*", GetRPName(giveplayerid));
        }
    }
    return 1;
}
