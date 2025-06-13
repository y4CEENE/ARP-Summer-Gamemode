
CMD:accept(playerid, params[])
{
    if (IsAlphaNum(params))
    {
        new callback[64];
        new arg[64];
        ToLower(arg, params);
        format(callback, sizeof(callback), "accept_%s", arg);
        if (CallRemoteFunction(callback, "i", playerid))
        {
            return true;
        }
    }
    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /accept [option]");
    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: House, Garage, Business, Land, Death, Vest, Vehicle");
    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Faction, Gang, Ticket, Live, Marriage, Neutralize");
    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Item, Frisk, Handshake, Weapon, Lawyer, Dicebet");
    SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Invite, Robbery, Duel, Alliance, Craft, Drink");
    return true;
}

Accept:house(playerid)
{
    new offeredby = PlayerData[playerid][pHouseOffer];
    new houseid = PlayerData[playerid][pHouseOffered];
    new price = PlayerData[playerid][pHousePrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a house.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (!IsHouseOwner(offeredby, houseid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this house.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's house.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_HOUSES) >= GetPlayerAssetLimit(playerid, LIMIT_HOUSES))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i houses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
    }

    SetHouseOwner(houseid, playerid);

    GivePlayerCash(offeredby, price);
    GivePlayerCash(playerid, -price);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's house offer and paid %s for their house.", GetRPName(offeredby), FormatCash(price));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your house offer and paid %s for your house.", GetRPName(playerid), FormatCash(price));
    DBLog("log_property", "%s (uid: %i) (IP: %s) sold their house (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), HouseInfo[houseid][hID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

    PlayerPlaySound(playerid, 182, 0.0, 0.0, 0.0); // mission passed theme / property bought
    PlayerData[playerid][pHouseOffer] = INVALID_PLAYER_ID;
    AwardAchievement(playerid, ACH_HomeSweetHome);
    return 1;
}

Accept:garage(playerid)
{
    new offeredby = PlayerData[playerid][pGarageOffer];
    new garageid = PlayerData[playerid][pGarageOffered];
    new price = PlayerData[playerid][pGaragePrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a garage.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (!IsGarageOwner(offeredby, garageid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this garage.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's garage.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_GARAGES) >= GetPlayerAssetLimit(playerid, LIMIT_GARAGES))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i garages. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
    }

    SetGarageOwner(garageid, playerid);

    GivePlayerCash(offeredby, price);
    GivePlayerCash(playerid, -price);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's garage offer and paid %s for their garage.", GetRPName(offeredby), FormatCash(price));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your garage offer and paid %s for your garage.", GetRPName(playerid), FormatCash(price));
    DBLog("log_property", "%s (uid: %i) (IP: %s) sold their %s garage (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), garageInteriors[GarageInfo[garageid][gType]][intName], GarageInfo[garageid][gID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

    PlayerData[playerid][pGarageOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:business(playerid)
{
    new offeredby = PlayerData[playerid][pBizOffer];
    new businessid = PlayerData[playerid][pBizOffered];
    new price = PlayerData[playerid][pBizPrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a business.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (!IsBusinessOwner(offeredby, businessid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this business.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's business.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) >= GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently own %i/%i businesses. You can't own anymore unless you upgrade your asset perk.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
    }

    SetBusinessOwner(businessid, playerid);

    GivePlayerCash(offeredby, price);
    GivePlayerCash(playerid, -price);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's business offer and paid %s for their %s.", GetRPName(offeredby), FormatCash(price), bizInteriors[BusinessInfo[businessid][bType]][intType]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your business offer and paid %s for your %s.", GetRPName(playerid), FormatCash(price), bizInteriors[BusinessInfo[businessid][bType]][intType]);
    DBLog("log_property", "%s (uid: %i) (IP: %s) sold their %s business (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), bizInteriors[BusinessInfo[businessid][bType]][intType], BusinessInfo[businessid][bID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

    PlayerData[playerid][pBizOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:land(playerid)
{
    new offeredby = PlayerData[playerid][pLandOffer];
    new landid = PlayerData[playerid][pLandOffered];
    new price = PlayerData[playerid][pLandPrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a land.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (!IsLandOwner(offeredby, landid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this land.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's land.");
    }

    SetLandOwner(landid, playerid);

    GivePlayerCash(offeredby, price);
    GivePlayerCash(playerid, -price);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's land offer and paid %s for their land.", GetRPName(offeredby), FormatCash(price));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your land offer and paid %s for your land.", GetRPName(playerid), FormatCash(price));
    DBLog("log_property", "%s (uid: %i) (IP: %s) sold their land (id: %i) for $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerIP(offeredby), LandInfo[landid][lID], price, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

    PlayerData[playerid][pLandOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:death(playerid)
{
    if (PlayerData[playerid][pInjured] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not injured and can't accept your death.");
    }
    if (gettime() - PlayerData[playerid][pInjured] < 15)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %d seconds to accept your death.", 15 - (gettime() - PlayerData[playerid][pInjured]));
    }

    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You cannot accept death while you are in an ambulance");
    }

    if (IsPlayerConnected(PlayerData[playerid][pAcceptedEMS]))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You cannot accept death. An ambulance is on the way to get you.");
    }

    SendClientMessage(playerid, COLOR_GREY, "You have given up and accepted your fate.");

    SetPlayerHealth(playerid, 0.0);
    return 1;
}

Accept:vehicle(playerid)
{
    new offeredby = PlayerData[playerid][pCarOffer];
    new vehicleid = PlayerData[playerid][pCarOffered];
    new price = PlayerData[playerid][pCarPrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a vehicle.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (!IsVehicleOwner(offeredby, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player no longer is the owner of this vehicle.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to buy this player's vehicle.");
    }
    if (GetSpawnedVehicles(playerid) >= MAX_SPAWNED_VEHICLES)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't have more than %i vehicles spawned at a time.", MAX_SPAWNED_VEHICLES);
    }

    DBFormat("SELECT COUNT(*) FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
    DBExecute("OnPlayerAttemptBuyVehicleEx", "iiii", playerid, offeredby, vehicleid, price);

    PlayerData[playerid][pCarOffer] = INVALID_PLAYER_ID;
    AwardAchievement(playerid, ACH_FirstWheels);
    return 1;
}

Accept:faction(playerid)
{
    if (PlayerData[playerid][pLevel] < 3 )
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be level 3+ to join a faction.");
    }
    new offeredby = PlayerData[playerid][pFactionOffer];
    new factionid = PlayerData[playerid][pFactionOffered];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invites to a faction.");
    }
    if (PlayerData[offeredby][pFaction] != factionid || !PlayerData[offeredby][pFactionLeader])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is no longer allowed to invite you.");
    }

    SetPlayerFaction(playerid, factionid, 0);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's faction offer to join {00AA00}%s{33CCFF}.", GetRPName(offeredby), FactionInfo[factionid][fName]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your faction offer and is now apart of your faction.", GetRPName(playerid));

    DBLog("log_faction", "%s (uid: %i) has invited %s (uid: %i) to %s (id: %i).", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID], FactionInfo[factionid][fName], factionid);
    PlayerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:gang(playerid)
{
    if (PlayerData[playerid][pHours] < 2 )
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to play at least 2 hours to join a gang.");
    }
    new offeredby = PlayerData[playerid][pGangOffer];
    new gangid = PlayerData[playerid][pGangOffered];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invites to a gang.");
    }
    if (PlayerData[offeredby][pGang] != gangid || PlayerData[offeredby][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is no longer allowed to invite you.");
    }

    GangInfo[gangid][gCount]++;

    PlayerData[playerid][pGang] = gangid;
    PlayerData[playerid][pGangRank] = 0;
    PlayerData[playerid][pCrew] = -1;

    ResetPlayerCommitRankPoints(playerid);

    DBQuery("UPDATE "#TABLE_USERS" SET gang = %i, gangrank = 0, crew = -1 WHERE uid = %i", gangid, PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's gang offer to join {00AA00}%s{33CCFF}.", GetRPName(offeredby), GangInfo[gangid][gName]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s accepted your gang offer and is now apart of your gang.", GetRPName(playerid));
    if (GetGangInviteCooldown())
    {
        GangInfo[gangid][gInvCooldown] = GetGangInviteCooldown();
        SendClientMessageEx(offeredby, COLOR_GREEN, "A invite cooldown has been placed on your gang. You cannot invite anyone for the next %i minutes!", GangInfo[gangid][gInvCooldown]);
    }
    DBLog("log_gang", "%s (uid: %i) has invited %s (uid: %i) to %s (id: %i).", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID], GangInfo[gangid][gName], gangid);
    PlayerData[playerid][pGangOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:frisk(playerid)
{
    new offeredby = PlayerData[playerid][pFriskOffer];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers to be frisked.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }

    FriskPlayer(offeredby, playerid);
    PlayerData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:sex(playerid)
{
    OnAcceptSex(playerid);
    return 1;
}

Accept:live(playerid)
{
    new offeredby = PlayerData[playerid][pLiveOffer];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a live interview.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID || PlayerData[offeredby][pCallLine] != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You or the offerer can't be on a phone call during a live interview.");
    }

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's live interview offer. Speak in IC chat to begin the interview!", GetRPName(offeredby));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your live interview offer. Speak in IC chat to begin the interview!", GetRPName(playerid));
    DBLog("log_faction", "%s (uid: %i) has started a live interview with %s (uid: %i)", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetPlayerNameEx(playerid), PlayerData[playerid][pID]);

    PlayerData[playerid][pLiveBroadcast] = offeredby;
    PlayerData[offeredby][pLiveBroadcast] = playerid;
    PlayerData[playerid][pLiveOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:handshake(playerid)
{
    new offeredby = PlayerData[playerid][pShakeOffer];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a handshake.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }

    ClearAnimations(playerid);
    ClearAnimations(offeredby);

    SetPlayerToFacePlayer(playerid, offeredby);
    SetPlayerToFacePlayer(offeredby, playerid);

    switch (PlayerData[playerid][pShakeType])
    {
        case 1:
        {
            ApplyAnimation(playerid,  "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
            ApplyAnimation(offeredby, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
        }
        case 2:
        {
            ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
            ApplyAnimation(offeredby, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
        }
        case 3:
        {
            ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
            ApplyAnimation(offeredby, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
        }
        case 4:
        {
            ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
            ApplyAnimation(offeredby, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
        }
        case 5:
        {
            ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
            ApplyAnimation(offeredby, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
        }
        case 6:
        {
            ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
            ApplyAnimation(offeredby, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0);
        }
    }

    AwardAchievement(playerid, ACH_MeetingPeople);
    AwardAchievement(offeredby, ACH_MeetingPeople);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's handshake offer.", GetRPName(offeredby));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your handshake offer.", GetRPName(playerid));

    PlayerData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:item(playerid)
{
    new offeredby = PlayerData[playerid][pSellOffer];
    new type = PlayerData[playerid][pSellType];
    new amount = PlayerData[playerid][pSellExtra];
    new price = PlayerData[playerid][pSellPrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for an item.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to accept the offer.");
    }

    switch (type)
    {
        case ITEM_SKIN:
        {
            if (PlayerData[PlayerData[playerid][pSellOffer]][pFaction] >= 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You cannot buy skin from this player.");
            }
            if (PlayerData[PlayerData[playerid][pSellOffer]][pGang] >= 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You cannot buy skin from this player.");
            }
            if (PlayerData[playerid][pSkin] == PlayerData[offeredby][pSkin])
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player already has this skin.");
            }

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            SetScriptSkin(playerid, PlayerData[offeredby][pSkin]);
            SetScriptSkin(offeredby, (PlayerData[offeredby][pGender] == PlayerGender_Female) ? 40 : 200);

            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased new outfit from %s for %s.", GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your outfit for %s.", GetRPName(playerid), FormatCash(price));
        }
        case ITEM_WEAPON:
        {
            new weaponid = PlayerData[playerid][pSellExtra];

            if (!PlayerHasWeapon(offeredby, weaponid))
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            GivePlayerRankPointIllegalJob(offeredby, 20);

            GivePlayerWeaponEx(playerid, weaponid);
            RemovePlayerWeapon(offeredby, weaponid);

            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %s's %s for %s.", GetRPName(offeredby), GetWeaponNameEx(weaponid), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %s for %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %s to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], GetWeaponNameEx(weaponid), GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);
            GiveNotoriety(playerid, 20);
            GiveNotoriety(offeredby, 20);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_MATERIALS:
        {
            if (PlayerData[offeredby][pMaterials] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pMaterials] + amount > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
            }

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pMaterials] += amount;
            PlayerData[offeredby][pMaterials] -= amount;
            DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[offeredby][pMaterials], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i materials from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i materials for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i materials to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);

            GivePlayerRankPointIllegalJob(offeredby, price*amount/400000);

            GiveNotoriety(playerid, 20);
            GiveNotoriety(offeredby, 20);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for trafficking, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_BACKPACK:
			{
			    new size[6];
			    if(PlayerData[offeredby][pBackpack] != amount)
			    {
			        return SCM(playerid, COLOR_SYNTAX, "The player who initiated the offer no longer has that item.");
			    }
			    if(PlayerData[playerid][bpWearing])
			    {
			        return SCM(playerid, COLOR_SYNTAX, "You cannot accept this offer as you are still wearing your backpack.");
				}
				if(PlayerData[offeredby][bpWearing])
				{
				    return SCM(playerid, COLOR_SYNTAX, "The player who initiated the offer is still wearing their backpack.");
				}

			    GivePlayerCash(playerid, -price);
			    GivePlayerCash(offeredby, price);

			    PlayerData[playerid][pBackpack] = amount;
				SavePlayerVariables(playerid);
				ResetBackpack(offeredby);
				if(amount == 1)
				{
				    format(size, sizeof(size), "small");
				}
				if(amount == 2)
				{
				    format(size, sizeof(size), "medium");
				}
				if(amount == 3)
				{
				    format(size, sizeof(size), "large");
				}
			    SM(playerid, COLOR_AQUA, "** You have purchased a %s backpack from %s for $%i.", size, GetRPName(offeredby), price);
			    SM(offeredby, COLOR_AQUA, "** %s has purchased your %s backpack for $%i.", GetRPName(playerid), size, price);
			    DBLog("log_give", "%s (uid: %i) has sold their %i backpack to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], size, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

                TurfTaxCheck(offeredby, price);

			    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
			}
        case ITEM_WEED:
        {
            if (PlayerData[offeredby][pWeed] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pWeed] + amount > GetPlayerCapacity(playerid, CAPACITY_WEED))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i weed. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pWeed], GetPlayerCapacity(playerid, CAPACITY_WEED));
            }

            AwardAchievement(playerid, ACH_DirtyDeeds);
            AwardAchievement(offeredby, ACH_DirtyDeeds);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pWeed] += amount;
            PlayerData[offeredby][pWeed] -= amount;
            DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[offeredby][pWeed], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of weed from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of weed for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i grams of weed to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);

            GiveNotoriety(playerid, 20);
            GiveNotoriety(offeredby, 20);
            GivePlayerRankPointIllegalJob(offeredby, price*amount/350);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_COCAINE:
        {
            if (PlayerData[offeredby][pCocaine] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pCocaine] + amount > GetPlayerCapacity(playerid, CAPACITY_COCAINE))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i cocaine. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pCocaine], GetPlayerCapacity(playerid, CAPACITY_COCAINE));
            }

            AwardAchievement(playerid, ACH_DirtyDeeds);
            AwardAchievement(offeredby, ACH_DirtyDeeds);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pCocaine] += amount;
            PlayerData[offeredby][pCocaine] -= amount;

            IncreaseJobSkill(offeredby, JOB_DRUGDEALER);

            DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[offeredby][pCocaine], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of cocaine from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of cocaine for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i grams of cocaine to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);
            GivePlayerRankPointIllegalJob(offeredby, price*amount/250);

            GiveNotoriety(playerid, 20);
            GiveNotoriety(offeredby, 20);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_HEROIN:
        {
            if (PlayerData[offeredby][pHeroin] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pHeroin] + amount > GetPlayerCapacity(playerid, CAPACITY_HEROIN))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i Heroin. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pHeroin], GetPlayerCapacity(playerid, CAPACITY_HEROIN));
            }

            AwardAchievement(playerid, ACH_DirtyDeeds);
            AwardAchievement(offeredby, ACH_DirtyDeeds);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pHeroin] += amount;
            PlayerData[offeredby][pHeroin] -= amount;

            IncreaseJobSkill(offeredby, JOB_DRUGDEALER);

            DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[offeredby][pHeroin], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of Heroin from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of Heroin for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i grams of Heroin to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);

            GiveNotoriety(playerid, 20);
            GiveNotoriety(offeredby, 20);
            GivePlayerRankPointIllegalJob(offeredby, price*amount/200);

            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 20 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_PAINKILLERS:
        {
            if (PlayerData[offeredby][pPainkillers] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pPainkillers] + amount > GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i painkillers. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pPainkillers], GetPlayerCapacity(playerid, CAPACITY_PAINKILLERS));
            }

            AwardAchievement(playerid, ACH_DirtyDeeds);
            AwardAchievement(offeredby, ACH_DirtyDeeds);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pPainkillers] += amount;
            PlayerData[offeredby][pPainkillers] -= amount;

            DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[offeredby][pPainkillers], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i painkillers from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i painkillers for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i painkillers to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);
            GivePlayerRankPointLegalJob(offeredby, 50);

            TurfTaxCheck(offeredby, price);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_SEEDS:
        {
            if (PlayerData[offeredby][pSeeds] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pSeeds] + amount > GetPlayerCapacity(playerid, CAPACITY_SEEDS))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i seeds. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pSeeds], GetPlayerCapacity(playerid, CAPACITY_SEEDS));
            }

            AwardAchievement(playerid, ACH_DirtyDeeds);
            AwardAchievement(offeredby, ACH_DirtyDeeds);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pSeeds] += amount;
            PlayerData[offeredby][pSeeds] -= amount;

            IncreaseJobSkill(offeredby, JOB_DRUGDEALER);
            GivePlayerRankPointIllegalJob(offeredby, price*amount/400);


            DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[offeredby][pSeeds], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i seeds from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i seeds for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i seeds to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);

            GiveNotoriety(playerid, 5);
            GiveNotoriety(offeredby, 5);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_CHEMICALS:
        {
            if (PlayerData[offeredby][pChemicals] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }
            if (PlayerData[playerid][pChemicals] + amount > GetPlayerCapacity(playerid, CAPACITY_CHEMICALS))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i chems. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pChemicals], GetPlayerCapacity(playerid, CAPACITY_CHEMICALS));
            }

            AwardAchievement(playerid, ACH_DirtyDeeds);
            AwardAchievement(offeredby, ACH_DirtyDeeds);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pChemicals] += amount;
            PlayerData[offeredby][pChemicals] -= amount;

            IncreaseJobSkill(offeredby, JOB_DRUGDEALER);

            DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i WHERE uid = %i", PlayerData[playerid][pChemicals], PlayerData[playerid][pID]);


            DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i WHERE uid = %i", PlayerData[offeredby][pChemicals], PlayerData[offeredby][pID]);


            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i grams of chems from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i grams of chems for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i grams of chems to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            TurfTaxCheck(offeredby, price);

            GivePlayerRankPointIllegalJob(playerid, price * amount / 400);

            GiveNotoriety(playerid, 5);
            GiveNotoriety(offeredby, 5);
            SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[playerid][pNotoriety]);
            SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained 5 notoriety for drug dealing, you now have %d.", PlayerData[offeredby][pNotoriety]);

            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
        case ITEM_DIAMONDS:
        {
            if (PlayerData[offeredby][pDiamonds] < amount)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer no longer has that item.");
            }

            AwardAchievement(offeredby, ACH_ProMiner);

            GivePlayerCash(playerid, -price);
            GivePlayerCash(offeredby, price);

            PlayerData[playerid][pDiamonds] += amount;
            PlayerData[offeredby][pDiamonds] -= amount;

            DBQuery("UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", PlayerData[playerid][pDiamonds], PlayerData[playerid][pID]);
            DBQuery("UPDATE "#TABLE_USERS" SET diamonds = %i WHERE uid = %i", PlayerData[offeredby][pDiamonds], PlayerData[offeredby][pID]);

            SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i diamonds from %s for %s.", amount, GetRPName(offeredby), FormatCash(price));
            SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i diamonds for %s.", GetRPName(playerid), amount, FormatCash(price));
            DBLog("log_give", "%s (uid: %i) has sold their %i diamonds to %s (uid: %i) for $%i.", GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], amount, GetPlayerNameEx(playerid), PlayerData[playerid][pID], price);

            GivePlayerRankPointLegalJob(playerid, price * amount / 400);
            PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
        }
    }
    return 1;
}

Accept:weapon(playerid)
{
    if (PlayerData[playerid][pSellOffer] == INVALID_PLAYER_ID || PlayerData[playerid][pSellType] != ITEM_SELLGUN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a weapon.");
    }
    if (PlayerData[playerid][pCash] < PlayerData[playerid][pSellPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase the weapon.");
    }
    if (PlayerHasWeapon(playerid, PlayerData[playerid][pSellExtra]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have this weapon.");
    }
    SellWeapon(PlayerData[playerid][pSellOffer], playerid, PlayerData[playerid][pSellExtra], PlayerData[playerid][pSellPrice]);
    GivePlayerRankPointIllegalJob(PlayerData[playerid][pSellOffer], 20);

    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:gangweapons(playerid)
{
    if (PlayerData[playerid][pSellOffer] == INVALID_PLAYER_ID || PlayerData[playerid][pSellType] != ITEM_GSELLGUN)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for a weapon.");
    }
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang.");
    }

    new gangid    = PlayerData[playerid][pGang];
    new offeredby = PlayerData[playerid][pSellOffer];
    new weaponid  = PlayerData[playerid][pSellExtra];
    new qty       = PlayerData[playerid][pSellQuantity];
    new price     = PlayerData[playerid][pSellPrice];
    new unitcost  = GetCraftWeaponPrice(playerid, weaponid);
    new cost      = unitcost * qty;

    new noto      = qty * 100;

    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to purchase the weapon.");
    }

    if (unitcost == -1)
    {
        return SendClientMessageEx(playerid, COLOR_AQUA, "Trader cannot craft this weapon {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
    }
    if (PlayerData[offeredby][pMaterials] < cost)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Trader can't sell these weapons.");
    }

    if (!AddWeaponToGangStash(gangid, weaponid, qty))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Trader can't sell these weapons.");
    }

    GivePlayerMaterials(offeredby, -cost);
    GivePlayerCash(playerid, -price);
    GivePlayerCash(offeredby,  price);
    GiveNotoriety(playerid, noto);
    GiveNotoriety(offeredby, noto);
    GivePlayerRankPointIllegalJob(offeredby, 200);

    SendClientMessageEx(playerid, COLOR_AQUA, "You have gained %d notoriety for gang weapons dealing, you now have %d.", noto, PlayerData[playerid][pNotoriety]);
    SendClientMessageEx(offeredby, COLOR_AQUA, "You have gained %d notoriety for gang weapons dealing, you now have %d.", noto, PlayerData[offeredby][pNotoriety]);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have purchased %i %s from %s for %s. You can find them in your gang stash.", qty, GetWeaponNameEx(weaponid), GetRPName(offeredby), FormatCash(price));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has purchased your %i %s for %s.", GetRPName(playerid), qty, GetWeaponNameEx(weaponid), FormatCash(price));
    DBLog("log_give", "%s (uid: %i) has sold %i %s to %s (uid: %i) for $%i for gang %s (id: %i).",
        GetPlayerNameEx(offeredby), PlayerData[offeredby][pID], qty, GetWeaponNameEx(weaponid),
        GetPlayerNameEx(playerid), PlayerData[playerid][pID], price, GangInfo[gangid][gName], gangid);

    PlayerData[playerid][pSellOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:lawyer(playerid)
{
    new offeredby = PlayerData[playerid][pDefendOffer];
    new price = PlayerData[playerid][pDefendPrice];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers from a lawyer.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (PlayerData[playerid][pCash] < price)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to accept the offer.");
    }
    if (GetWantedLevel(playerid) == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are no longer wanted. You can't accept this offer anymore.");
    }
    if (IsPlayerInBankRobbery(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't be defended while in bank robbery.");
    }

    GiveWantedLevel(playerid, -1);
    GivePlayerRankPointLegalJob(offeredby, 80);


    GivePlayerCash(playerid, -price);
    GivePlayerCash(offeredby, price);

    DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = %i WHERE uid = %i", GetWantedLevel(playerid), PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's offer to reduce your wanted level for %s.", GetRPName(offeredby), FormatCash(price));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your offer to reduce their wanted level for %s.", GetRPName(playerid), FormatCash(price));

    IncreaseJobSkill(offeredby, JOB_LAWYER);
    PlayerData[playerid][pDefendOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:dicebet(playerid)
{
    new offeredby = PlayerData[playerid][pDiceOffer],
        amount = PlayerData[playerid][pDiceBet];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any offers for dice betting.");
    }
    if (!IsPlayerNearPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player who initiated the offer is out of range.");
    }
    if (PlayerData[playerid][pCash] < amount)
    {
        PlayerPlaySound(playerid, 5406, 0.0, 0.0, 0.0); // Sorry sir you do not have enough funds.
        PlayerPlaySound(offeredby, 5405, 0.0, 0.0, 0.0); // Sir doesn't have sufficient money to back another bet.
        return SendClientMessage(playerid, COLOR_GREY, "You can't afford to accept this bet.");
    }
    if (PlayerData[offeredby][pCash] < amount)
    {
        PlayerPlaySound(offeredby, 5406, 0.0, 0.0, 0.0); // Sorry sir you do not have enough funds.
        PlayerPlaySound(playerid, 5405, 0.0, 0.0, 0.0); // Sir doesn't have sufficient money to back another bet.
        return SendClientMessage(playerid, COLOR_GREY, "That player can't afford to accept this bet.");
    }

    new rand[2];

    if (PlayerData[playerid][pDiceRigged])
    {
        rand[0] = 4 + random(3);
        rand[1] = random(3) + 1;
    }
    else
    {
        for (new x = 0; x < random(50)*random(50)+30; x++)
        {
            rand[0] = random(6) + 1;
        }
        for (new x = 0; x < random(50)*random(50)+30; x++)
        {
            rand[1] = random(6) + 1;
        }
    }

    SendProximityMessage(offeredby, 20.0, COLOR_WHITE, "* %s rolls a dice which lands on the number %i.", GetRPName(offeredby), rand[0]);
    SendProximityMessage(playerid, 20.0, COLOR_WHITE, "* %s rolls a dice which lands on the number %i.", GetRPName(playerid), rand[1]);

    if (rand[0] > rand[1])
    {

        GivePlayerCash(offeredby, amount);
        GivePlayerCash(playerid, -amount);
        PlayerPlaySound(offeredby, 5448, 0.0, 0.0, 0.0); // You win!

        SendClientMessageEx(offeredby, COLOR_AQUA, "* You have won $%s from your dice bet with %s.", FormatCash(amount), GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_RED, "* You have lost $%s from your dice bet with %s.", FormatCash(amount), GetRPName(offeredby));

        if (amount > 10000 && !strcmp(GetPlayerIP(offeredby), GetPlayerIP(playerid)))
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) won a $%i dice bet against %s (IP: %s).", GetRPName(offeredby), GetPlayerIP(offeredby), amount, GetRPName(playerid), GetPlayerIP(playerid));
        }
        DBLog("log_dicebet", "%s (uid: %i) won a dice bet against %s (uid: %i) for $%i.", GetRPName(offeredby), PlayerData[offeredby][pID], GetRPName(playerid), PlayerData[playerid][pID], amount);
    }
    else if (rand[0] == rand[1])
    {
        SendClientMessageEx(offeredby, COLOR_AQUA, "* The bet of %s was a tie. You kept your money as a result!", FormatCash(amount));
        SendClientMessageEx(playerid, COLOR_AQUA, "* The bet of %s was a tie. You kept your money as a result!", FormatCash(amount));
    }
    else
    {
        GivePlayerCash(offeredby, -amount);
        GivePlayerCash(playerid, amount);
        PlayerPlaySound(playerid, 5450, 0.0, 0.0, 0.0); // Congratulations sir!

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have won $%s from your dice bet with %s.", FormatCash(amount), GetRPName(offeredby));
        SendClientMessageEx(offeredby, COLOR_RED, "* You have lost $%s from your dice bet with %s.", FormatCash(amount), GetRPName(playerid));

        if (amount > 10000 && !strcmp(GetPlayerIP(offeredby), GetPlayerIP(playerid)))
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) won a $%i dice bet against %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount, GetRPName(offeredby), GetPlayerIP(offeredby));
        }
        DBLog("log_dicebet", "%s (uid: %i) won a dice bet against %s (uid: %i) for $%i.", GetRPName(playerid), PlayerData[playerid][pID], GetRPName(offeredby), PlayerData[offeredby][pID], amount);
    }

    PlayerData[playerid][pDiceOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:invite(playerid)
{
    new offeredby = PlayerData[playerid][pInviteOffer];
    new houseid = PlayerData[playerid][pInviteHouse];

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received any invitations to a house.");
    }

    SetActiveCheckpoint(playerid, CHECKPOINT_HOUSE, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 3.0);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have accepted %s's invitation to their house.", GetRPName(offeredby));
    SendClientMessageEx(offeredby, COLOR_AQUA, "* %s has accepted your invitation to your house.", GetRPName(playerid));

    PlayerData[playerid][pInviteOffer] = INVALID_PLAYER_ID;
    return 1;
}

Accept:alliance(playerid)
{
    new offeredby = PlayerData[playerid][pAllianceOffer], color, color2;

    if (offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't been offered an alliance.");
    }
    if (offeredby == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't accept offers from yourself.");
    }

    new gangid = PlayerData[playerid][pGang], allyid = PlayerData[offeredby][pGang];

    SendClientMessageEx(offeredby, COLOR_AQUA, "%s has accepted your offer to form a gang alliance.", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "You've accepted the offer from %s to form a gang alliance.", GetRPName(offeredby));

    GangInfo[gangid][gAlliance] = allyid;
    GangInfo[allyid][gAlliance] = gangid;
    PlayerData[playerid][pAllianceOffer] = INVALID_PLAYER_ID;

    DBQuery("UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", allyid, gangid);
    DBQuery("UPDATE "#TABLE_GANGS" SET alliance = %i WHERE id = %i", gangid, allyid);

    if (GangInfo[gangid][gColor] == -1 || GangInfo[gangid][gColor] == -256)
    {
        color = 0xC8C8C8FF;
    }
    else
    {
        color = GangInfo[gangid][gColor];
    }

    if (GangInfo[allyid][gColor] == -1 || GangInfo[allyid][gColor] == -256)
    {
        color2 = 0xC8C8C8FF;
    }
    else
    {
        color2 = GangInfo[allyid][gColor];
    }

    SendClientMessageToAllEx(COLOR_WHITE, "(( Gang News: {%06x}%s{FFFFFF} has formed an alliance with {%06x}%s{FFFFFF} ))", color >>> 8, GangInfo[gangid][gName], color2 >>> 8, GangInfo[allyid][gName]);
    return 1;
}

Accept:marriage(playerid)
{
    new id, offeredby = PlayerData[playerid][pMarriageOffer];
    if ((id = GetInsideBusiness(playerid)) == -1 || BusinessInfo[id][bType] != BUSINESS_RESTAURANT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be at a restaurant to commence a wedding.");
    }
    if (!IsPlayerConnected(offeredby) || !IsPlayerNearPlayer(playerid, offeredby, 15.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't in range of anyone who has offered to marry you.");
    }
    if (PlayerData[playerid][pCash] < 25000 || PlayerData[offeredby][pCash] < 25000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You both need to have $25,000 in hand to commence a wedding.");
    }

    GivePlayerCash(playerid, -25000);
    GivePlayerCash(offeredby, -25000);
    BusinessInfo[id][bCash] += 50000;

    SendClientMessageToAllEx(COLOR_WHITE, "Lovebirds %s and %s have just tied the knott! Congratulations to them on getting married.", GetRPName(offeredby), GetRPName(playerid));

    PlayerData[playerid][pMarriedTo] = PlayerData[offeredby][pID];
    PlayerData[offeredby][pMarriedTo] = PlayerData[playerid][pID];

    DBQuery("UPDATE "#TABLE_USERS" SET marriedto = %i WHERE uid = %i", PlayerData[playerid][pMarriedTo], PlayerData[playerid][pID]);
    DBQuery("UPDATE "#TABLE_USERS" SET marriedto = %i WHERE uid = %i", PlayerData[offeredby][pMarriedTo], PlayerData[offeredby][pID]);

    strcpy(PlayerData[playerid][pMarriedName], GetPlayerNameEx(offeredby), MAX_PLAYER_NAME);
    strcpy(PlayerData[offeredby][pMarriedName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);

    PlayerData[playerid][pMarriageOffer] = INVALID_PLAYER_ID;

    PlayerPlaySound(playerid, 50004, 0.0, 0.0, 0.0); // You're My World Now !
    PlayerPlaySound(offeredby, 50004, 0.0, 0.0, 0.0); // You're My World Now !
    return 1;
}

Accept:divorce(playerid)
{
    new offeredby = PlayerData[playerid][pMarriageOffer];
    if (!IsPlayerConnected(offeredby) || !IsPlayerNearPlayer(playerid, offeredby, 15.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't in range of anyone who has offered to divorce you.");
    }
    if (PlayerData[playerid][pMarriedTo] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't even married ya naab.");
    }
    if (PlayerData[playerid][pMarriedTo] != PlayerData[offeredby][pID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That isn't the person you're married to.");
    }

    PlayerData[playerid][pMarriedTo] = -1;
    PlayerData[offeredby][pMarriedTo] = -1;

    DBQuery("UPDATE "#TABLE_USERS" SET marriedto = -1 WHERE uid = %i", PlayerData[playerid][pID]);
    DBQuery("UPDATE "#TABLE_USERS" SET marriedto = -1 WHERE uid = %i", PlayerData[offeredby][pID]);

    strcpy(PlayerData[playerid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
    strcpy(PlayerData[offeredby][pMarriedName], "Nobody", MAX_PLAYER_NAME);

    PlayerData[playerid][pMarriageOffer] = INVALID_PLAYER_ID;
    PlayerPlaySound(playerid, 669, 0.0, 0.0, 0.0); // girlfriend date failed music (''fuck you I won't do what you tell me'')
    PlayerPlaySound(offeredby, 669, 0.0, 0.0, 0.0); // girlfriend date failed music (''fuck you I won't do what you tell me'')
    return 1;
}

Accept:neutralize(playerid)
{
    AcceptNeutralize(playerid);
}
