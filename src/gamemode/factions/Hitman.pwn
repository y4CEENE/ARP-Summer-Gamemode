/// @file      Hitman.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

DB:OnHitmanPassport(playerid, name[], level, skinid)
{
    if (GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "That name is already taken, please choose another.");
    }
    else
    {
        strcpy(PlayerData[playerid][pNameChange], name, MAX_PLAYER_NAME);

        PlayerData[playerid][pFreeNamechange] = 2;
        PlayerData[playerid][pChosenLevel] = level;
        PlayerData[playerid][pChosenSkin] = skinid;

        SendClientMessageEx(playerid, COLOR_AQUA, "You have requested a namechange to {00AA00}%s{33CCFF} for free, please wait for admin approval.", name);
        SendClientMessageEx(playerid, COLOR_AQUA, "Once the namechange has been approved, you will receive your chosen name, level and skin.");

        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is requesting a namechange to %s. (/acceptname %i or /denyname %i)", GetRPName(playerid), playerid, name, playerid, playerid);
    }
}

Dialog:DIALOG_HITMANCLOTHES(playerid, response, listitem, inputtext[])
{
    if ((response) && PlayerData[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
    {
        new skinid;

        if (sscanf(inputtext, "i", skinid))
        {
            return Dialog_Show(playerid, DIALOG_HITMANCLOTHES, DIALOG_STYLE_INPUT, "Change clothes", "Please input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.com/wiki/Skins:All ))", "Submit", "Cancel");
        }
        if (!(1 <= skinid <= 311))
        {
            SendClientMessage(playerid, COLOR_GREY, "Invalid skin.");
            return Dialog_Show(playerid, DIALOG_HITMANCLOTHES, DIALOG_STYLE_INPUT, "Change clothes", "Please input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.com/wiki/Skins:All ))", "Submit", "Cancel");
        }

        SetScriptSkin(playerid, skinid);
        GameTextForPlayer(playerid, "~w~Clothes changed for free", 3000, 3);
    }
    return 1;
}

HandleContract(playerid, killerid)
{
    if (GetPlayerFaction(killerid) == FACTION_HITMAN && PlayerData[killerid][pContractTaken] == playerid)
    {
        new price = PlayerData[playerid][pContracted] / 2;

        SendClientMessageEx(killerid, COLOR_YELLOW, "You have completed your contract on %s and received %s.", GetRPName(playerid), FormatCash(price));
        SendClientMessageEx(playerid, COLOR_YELLOW, "You have been killed by a hitman and lost %s.", FormatCash(price));

        SendFactionMessage(PlayerData[killerid][pFaction], COLOR_YELLOW, "Contract: %s has successfully completed the contract on %s and gained %s.", GetRPName(killerid), GetRPName(playerid), FormatCash(price));

        GivePlayerCash(playerid, -price);
        GivePlayerCash(killerid, price);

        PlayerData[killerid][pContractTaken] = INVALID_PLAYER_ID;
        PlayerData[killerid][pCompletedHits]++;
        PlayerData[playerid][pContracted] = 0;
        PlayerData[playerid][pContractBy] = 0;

        DBQuery("UPDATE "#TABLE_USERS" SET contracted = 0, contractby = 'Nobody' WHERE uid = %i", PlayerData[playerid][pID]);

        DBQuery("UPDATE "#TABLE_USERS" SET completedhits = %i WHERE uid = %i", PlayerData[killerid][pCompletedHits], PlayerData[killerid][pID]);

        foreach(new i : Player)
        {
            if (PlayerData[i][pContractTaken] == playerid)
            {
                PlayerData[i][pContractTaken] = INVALID_PLAYER_ID;
            }
        }

        DBLog("log_contracts", "%s (uid: %i) successfully completed their hit on %s (uid: %i) for $%i.", GetRPName(killerid), PlayerData[killerid][pID], GetRPName(playerid), PlayerData[playerid][pID], price);
    }
    else if (PlayerData[playerid][pContractTaken] == killerid)
    {
        new price = PlayerData[killerid][pContracted];

        SendClientMessageEx(playerid, COLOR_YELLOW, "You have failed your contract on %s and lost %s.", GetRPName(playerid), FormatCash(price));
        SendClientMessageEx(killerid, COLOR_YELLOW, "You have killed a hitman chasing after you and received %s. The contract on your head has been removed.", FormatCash(price));
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_YELLOW, "Contract: %s has failed the contract on %s and lost %s.", GetRPName(playerid), GetRPName(killerid), FormatCash(price));

        GivePlayerCash(playerid, -price);
        GivePlayerCash(killerid, price);

        PlayerData[playerid][pContractTaken] = INVALID_PLAYER_ID;
        PlayerData[playerid][pFailedHits]++;
        PlayerData[killerid][pContracted] = 0;
        PlayerData[killerid][pContractBy] = 0;

        DBQuery("UPDATE "#TABLE_USERS" SET contracted = 0, contractby = 'Nobody' WHERE uid = %i", PlayerData[killerid][pID]);

        DBQuery("UPDATE "#TABLE_USERS" SET failedhits = %i WHERE uid = %i", PlayerData[playerid][pFailedHits], PlayerData[playerid][pID]);

        foreach(new i : Player)
        {
            if (PlayerData[i][pContractTaken] == killerid)
            {
                PlayerData[i][pContractTaken] = INVALID_PLAYER_ID;
            }
        }

        DBLog("log_contracts", "%s (uid: %i) failed their hit on %s (uid: %i) and lost $%i.", GetRPName(playerid), PlayerData[playerid][pID], GetRPName(killerid), PlayerData[killerid][pID], price);
    }
}

CMD:order(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a Hitman.");
    }
    if (!IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any of your faction lockers.");
    }

    Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Order weapons\nChange clothes", "Select", "Cancel");

    return 1;
}


CMD:execute(playerid, params[])
{
    if (PlayerData[playerid][pContractTaken])
    {
        if (PlayerData[playerid][pExecute] == 0)
        {
            PlayerData[playerid][pExecute] = 1;
        }
        else
        {
            PlayerData[playerid][pExecute] = 0;
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Hey nerd, it wont work, get that fucking hit first!");
    }

    return 1;
}
CMD:contract(playerid, params[])
{
    new targetid, amount, reason[64];

    if (sscanf(params, "iis[64]", targetid, amount, reason))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /contract [playerid] [amount] [reason]");
    }
    if (PlayerData[playerid][pLevel] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be at least level 5+ to contract players.");
    }
    if (GetPlayerFaction(playerid) == FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are a hitman and therefore can't contract other players.");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't contract yourself.");
    }
    if (PlayerData[targetid][pLevel] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only contract level 5+ players.");
    }
    if (!(2500 <= amount <= 500000))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The amount must range from $2500 to $500000.");
    }
    if (PlayerData[playerid][pCash] < amount)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (PlayerData[targetid][pContracted] + amount > 500000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player can't have more than $500000 on their head.");
    }

    foreach(new i : Player)
    {
        if (GetPlayerFaction(i) == FACTION_HITMAN)
        {
            SendClientMessageEx(i, COLOR_YELLOW, "* %s has contracted %s for $%i, reason: %s [/contracts]", GetRPName(playerid), GetRPName(targetid), amount, reason);
        }
    }

    GivePlayerCash(playerid, -amount);

    PlayerData[targetid][pContracted] += amount;
    GetPlayerName(playerid, PlayerData[targetid][pContractBy], MAX_PLAYER_NAME);

    DBQuery("UPDATE "#TABLE_USERS" SET contracted = %i, contractby = '%e' WHERE uid = %i", PlayerData[targetid][pContracted], PlayerData[targetid][pContractBy], PlayerData[targetid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "You have placed a contract on %s for $%i, reason: %s", GetRPName(targetid), amount, reason);
    SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s placed a contract on %s for $%i, reason: %s", GetRPName(playerid), GetRPName(targetid), amount, reason);
    DBLog("log_contracts", "%s (uid: %i) placed a contract on %s (uid: %i) for $%i, reason: %s", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], amount, reason);
    return 1;
}

CMD:noknife(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
    }
    if (PlayerData[playerid][pNoKnife])
    {
        PlayerData[playerid][pNoKnife] = 0;
        SendClientMessage(playerid, COLOR_AQUA, "You've enabled no knife mode, your armed weapon will never be a knife.");
    }
    else
    {
        PlayerData[playerid][pNoKnife] = 1; //TODO: toggle also headshot
        SendClientMessage(playerid, COLOR_AQUA, "You've disabled no knife mode, your armed weapon can be anything");
    }
    return 1;
}

CMD:contracts(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_HITMAN && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }

    SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Pending Contracts _______");

    foreach(new i : Player)
    {
        if (PlayerData[i][pContracted] > 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "ID: %i | Target: %s | Bounty price: %s | Last contracter: %s", i, GetRPName(i), FormatCash(PlayerData[i][pContracted]), PlayerData[i][pContractBy]);
        }
    }

    SendClientMessage(playerid, COLOR_YELLOW, "* Use /takehit [id] or /denyhit [id] to handle contracts.");
    return 1;
}

CMD:denyhit(playerid, params[])
{
    new targetid;

    if (GetPlayerFaction(playerid) != FACTION_HITMAN && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /denyhit [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pContracted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't been contracted.");
    }

    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has cancelled the contract on %s for $%i.", GetRPName(playerid), GetRPName(targetid), PlayerData[targetid][pContracted]);

    if (GetPlayerFaction(playerid) == FACTION_HITMAN)
    {
        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_YELLOW, "* Hitman %s has cancelled the contract on %s for %s. *", GetRPName(playerid), GetRPName(targetid), FormatCash(PlayerData[targetid][pContracted]));
    }

    PlayerData[targetid][pContracted] = 0;
    strcpy(PlayerData[targetid][pContractBy], "No-one", MAX_PLAYER_NAME);

    DBQuery("UPDATE "#TABLE_USERS" SET contracted = 0, contractby = 'No-one' WHERE uid = %i", PlayerData[targetid][pID]);

    return 1;
}

CMD:takehit(playerid, params[])
{
    new targetid;

    if (GetPlayerFaction(playerid) != FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /takehit [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (!PlayerData[targetid][pContracted])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't been contracted.");
    }
    if (PlayerData[targetid][pCash] + PlayerData[targetid][pBank] < PlayerData[targetid][pContracted] / 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player's total wealth is lower than the contract price. You can't put them in debt.");
    }

    PlayerData[playerid][pContractTaken] = targetid;
    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_YELLOW, "* Hitman %s has accepted the contract to kill %s for %s. *", GetRPName(playerid), GetRPName(targetid), FormatCash(PlayerData[targetid][pContracted]));
    SendClientMessageEx(playerid, COLOR_AQUA, "You have taken the hit. You will receive %s once you have assassinated {00AA00}%s{33CCFF}.", FormatCash(PlayerData[targetid][pContracted]), GetRPName(targetid));
    return 1;
}
CMD:profile(playerid, params[])
{
    new targetid;

    if (GetPlayerFaction(playerid) != FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /profile [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s _____", GetRPName(targetid));
    SendClientMessageEx(playerid, COLOR_GREY2, "Gender: %s", GetPlayerGenderStr(targetid));
    SendClientMessageEx(playerid, COLOR_GREY2, "Age: %i years old", PlayerData[targetid][pAge]);

    if (PlayerData[targetid][pFaction] != -1)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Faction: %s", FactionInfo[PlayerData[targetid][pFaction]][fName]);
        SendClientMessageEx(playerid, COLOR_GREY2, "Rank: %s (%i)", FactionRanks[PlayerData[targetid][pFaction]][PlayerData[targetid][pFactionRank]], PlayerData[targetid][pFactionRank]);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Faction: None");
    }

    if (PlayerData[targetid][pContracted] > 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Contract: %s", FormatCash(PlayerData[targetid][pContracted]));
        SendClientMessageEx(playerid, COLOR_GREY2, "Last Contracter: %s", PlayerData[targetid][pContractBy]);
    }

    SendClientMessageEx(playerid, COLOR_GREY2, "Completed Hits: %i", PlayerData[targetid][pCompletedHits]);
    SendClientMessageEx(playerid, COLOR_GREY2, "Failed Hits: %i", PlayerData[targetid][pFailedHits]);
    return 1;
}

CMD:armbomb(playerid, params[])
{
    return callcmd::plantbomb(playerid, params);
}

CMD:plantbomb(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
    }
    if (!PlayerData[playerid][pBombs])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any bombs.");
    }
    if (PlayerData[playerid][pPlantedBomb])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have planted a bomb already.");
    }
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't plant a bomb inside.");
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't plant a bomb while inside of a vehicle");
    }

    GetPlayerPos(playerid, PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ]);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);

    PlayerData[playerid][pPlantedBomb] = 1;
    PlayerData[playerid][pBombObject] = CreateDynamicObject(19602, PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ] - 1.0, 0.0, 0.0, 0.0);
    PlayerData[playerid][pBombs]--;

    DBQuery("UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", PlayerData[playerid][pBombs], PlayerData[playerid][pID]);


    SendClientMessage(playerid, COLOR_WHITE, "* Bomb has been planted, use /detonate to make it go BOOM!");
    return 1;
}

CMD:pickupbomb(playerid, params[])
{
    if (GetPlayerFaction(playerid) != FACTION_HITMAN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
    }
    if (!PlayerData[playerid][pPlantedBomb])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't planted a bomb which you can pickup.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of your planted bomb.");
    }

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
    DestroyDynamicObject(PlayerData[playerid][pBombObject]);

    PlayerData[playerid][pBombObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pPlantedBomb] = 0;
    PlayerData[playerid][pBombs]++;

    DBQuery("UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", PlayerData[playerid][pBombs], PlayerData[playerid][pID]);


    SendClientMessage(playerid, COLOR_WHITE, "* You have picked up your bomb.");
    return 1;
}

CMD:detonate(playerid, params[])
{
    if (!PlayerData[playerid][pPlantedBomb])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't planted a bomb which you can detonate.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 50.0, PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are too far away from your planted bomb.");
    }

    CreateExplosion(PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ], 0, 10.0);
    CreateExplosion(PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ], 0, 10.0);
    DestroyDynamicObject(PlayerData[playerid][pBombObject]);

    if (PlayerData[playerid][pContractTaken] != INVALID_PLAYER_ID && IsPlayerInRangeOfPoint(PlayerData[playerid][pContractTaken], 10.0, PlayerData[playerid][pBombX], PlayerData[playerid][pBombY], PlayerData[playerid][pBombZ]))
    {
        SetPlayerHealth(PlayerData[playerid][pContractTaken], 0.0);
        HandleContract(PlayerData[playerid][pContractTaken], playerid);
    }

    PlayerData[playerid][pBombObject] = INVALID_OBJECT_ID;
    PlayerData[playerid][pPlantedBomb] = 0;

    SendClientMessage(playerid, COLOR_WHITE, "* You have detonated your bomb!");
    return 1;
}

CMD:mole(playerid, params[]) // MADE BY THE ONE AND ONLY Hernandez!
{
    if (GetPlayerFaction(playerid) != FACTION_HITMAN && !IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /mole [text]");
        SendClientMessage(playerid, COLOR_YELLOW, "This command sends a SMS to the entire server. Abusing this command will result in heavy punishment.");
        return 1;
    }
    SendClientMessageToAllEx(COLOR_YELLOW, "* SMS from Satan: %s, Ph: 666 *", params);
    return 1;
}
