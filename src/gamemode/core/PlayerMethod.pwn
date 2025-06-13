/// @file      PlayerMethod.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


stock IsPlayerIdle(playerid)
{
    if (PlayerData[playerid][pTazedTime] || PlayerData[playerid][pCuffed] || PlayerData[playerid][pTied] || PlayerData[playerid][pJailTime])
    {
        return false;
    }

    if (PlayerData[playerid][pHurt] || PlayerData[playerid][pInjured] || PlayerData[playerid][pHospital])
    {
        return false;
    }

    if (IsPlayerInEvent(playerid) || PlayerData[playerid][pPaintball])
    {
        return false;
    }
    return true;
}

publish SetScriptPos(playerid, Float:x, Float:y, Float:z)
{
    SetPlayerPos(playerid, x, y, z);
}

publish SetScriptArmour(playerid, Float:amount)
{
    PlayerData[playerid][pACTime] = gettime() + 5;
    PlayerData[playerid][pArmorTime] = gettime() + 5;
    PlayerData[playerid][pArmor] = amount;
    return SetPlayerArmour(playerid, amount);
}

publish PlayerCanAfford(playerid, amount)
{
    return PlayerData[playerid][pCash] >= amount;
}

GivePlayerHealth(playerid, Float:amount)
{
    new Float:health;
    GetPlayerHealth(playerid, health);
    SetPlayerHealth(playerid, (health + amount > 100.0) ? (100.0) : (health + amount));
}

GivePlayerArmour(playerid, Float:amount)
{
    new Float:armor;
    GetPlayerArmour(playerid, armor);
    SetScriptArmour(playerid, (armor + amount > 100.0) ? (100.0) : (armor + amount));
}

publish SetScriptSkin(playerid, skinid)
{
    SetPlayerSkin(playerid, skinid);
    if (skinid != ADMIN_SKIN && skinid != HELPER_SKIN)
    {
        PlayerData[playerid][pSkin] = skinid;
        DBQuery("UPDATE "#TABLE_USERS" SET skin = %i WHERE uid = %i", PlayerData[playerid][pSkin], PlayerData[playerid][pID]);
    }
}

ResetPlayerWeaponsEx(playerid)
{
    ResetPlayerWeapons(playerid);
    SetPlayerArmedWeapon(playerid, 0);

    for (new i = 0; i < 13; i ++)
    {
        PlayerData[playerid][pWeapons][i] = 0;
        PlayerData[playerid][pTempWeapons][i] = 0;
        PlayerData[playerid][pAmmo][i] = 0;
    }

    PlayerData[playerid][pACTime] = gettime() + 2;
}

RemovePlayerWeapon(playerid, weaponid)
{
    // Reset the player's weapons.
    ResetPlayerWeapons(playerid);
    // Set the armed slot to zero.
    SetPlayerArmedWeapon(playerid, 0);
    // Set the weapon in the slot to zero.
    PlayerData[playerid][pACTime] = gettime() + 2;
    PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] = 0;
    PlayerData[playerid][pTempWeapons][GetWeaponSlot(weaponid)] = 0;
    PlayerData[playerid][pAmmo][GetWeaponSlot(weaponid)] = 0;
    // Set the player's weapons.
    SetPlayerWeapons(playerid);
    // Save them to prevent rollbacks.
    SavePlayerWeapons(playerid);
}

GivePlayerWeaponEx(playerid, weaponid, bool:temp = false)
{
    if (1 <= weaponid <= 46)
    {
        if (temp)
        {
            PlayerData[playerid][pTempWeapons][GetWeaponSlot(weaponid)] = weaponid;
            GivePlayerWeapon(playerid, weaponid, 29999);
        }
        else
        {
            PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] = weaponid;
            SetPlayerWeapons(playerid);
        }

        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            SetPlayerArmedWeapon(playerid, 0);
        }
        else if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
        {
            switch (weaponid)
            {
                case 22, 23, 25, 28..34:
                {
                    SetPlayerArmedWeapon(playerid, weaponid);
                }
                default:
                {
                    SetPlayerArmedWeapon(playerid, 0);
                }
            }
        }
        else
        {
            SetPlayerArmedWeapon(playerid, weaponid);
        }

        SavePlayerWeapons(playerid);

        PlayerData[playerid][pACTime] = gettime() + 2;
    }
}

GetScriptWeapon(playerid)
{
    new weaponid = GetPlayerWeapon(playerid);

    if (PlayerHasWeapon(playerid, weaponid))
    {
        return weaponid;
    }

    return 0;
}

PlayerHasWeapon(playerid, weaponid, bool:temp = false)
{
    switch (weaponid)
    {
        case 0, 2, 40, 46:
        {
            return 1;
        }
    }

    if (weaponid == 23 && (PlayerData[playerid][pTazer] || (IsLawEnforcement(playerid) || GetPlayerFaction(playerid) == FACTION_GOVERNMENT)))
    {
        return 1;
    }

    if ((temp) && PlayerData[playerid][pTempWeapons][GetWeaponSlot(weaponid)] == weaponid)
    {
        return 1;
    }

    return PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] == weaponid;
}

SetPlayerWeapons(playerid)
{
    if (!IsPlayerInEvent(playerid) && PlayerData[playerid][pPaintball] == 0 && !IsDueling(playerid))
    {
        new weaponid = GetPlayerWeapon(playerid);

        ResetPlayerWeapons(playerid);

        if (PlayerData[playerid][pJailType] || PlayerData[playerid][pWeaponRestricted])
        {
            return;
        }
        for (new i = 0; i < 13; i ++)
        {
            if (PlayerData[playerid][pWeapons][i] > 0)
            {
                if (i == 2 && PlayerData[playerid][pTazer])
                {
                    GivePlayerWeaponEx(playerid, 23, true);
                    continue;
                }

                if (16 <= PlayerData[playerid][pWeapons][i] <= 18)
                    GivePlayerWeapon(playerid, PlayerData[playerid][pWeapons][i], 1);
                else
                    GivePlayerWeapon(playerid, PlayerData[playerid][pWeapons][i], 29999);
            }
        }

        switch (GetPlayerState(playerid))
        {
            case PLAYER_STATE_DRIVER:
            {
                SetPlayerArmedWeapon(playerid, 0);
            }
            case PLAYER_STATE_PASSENGER:
            {
                switch (weaponid)
                {
                    case 22, 23, 25, 28..34:
                    {
                        SetPlayerArmedWeapon(playerid, weaponid);
                    }
                    default:
                    {
                        SetPlayerArmedWeapon(playerid, 0);
                    }
                }
            }
            default:
            {
                SetPlayerArmedWeapon(playerid, weaponid);
            }
        }
    }
}

publish GiveWeaponToPlayer(playerid, weaponid, bool:temp)
{
    GivePlayerWeaponEx(playerid, weaponid, temp);
}

stock WeaponLicenseToString(license)
{
    new weapLic[20];
    switch (license)
    {
        case 1:  weapLic = "Passed";
        case 2:  weapLic = "Permanent Passed";
        default: weapLic = "Not Passed";
    }

    return weapLic;
}

stock DriveLicenseToString(license)
{
    new driveLic[15];
    switch (license)
    {
        case 1:  driveLic = "Passed";
        default: driveLic = "Not Passed";
    }
    return driveLic;
}

GetPlayerZoneName(playerid)
{
    new zone[32], Float:x, Float:y, Float:z;

    GetPlayerPos(playerid, x, y, z);

    if (GetInsideHouse(playerid) >= 0)
        zone = "House";
    else if (GetInsideBusiness(playerid) >= 0)
        zone = "Business";
    else if (GetInsideGarage(playerid) >= 0)
        zone = "Garage";
    else if (GetPlayerInterior(playerid))
        zone = "Interior";
    else
        strcpy(zone, GetZoneName(x, y, z));

    return zone;
}

GetPlayerPosEx(playerid, &Float:x, &Float:y, &Float:z)
{
    new id;
    if (GetPlayerInterior(playerid))
    {
        if ((id = GetInsideHouse(playerid)) >= 0)
        {
            x = HouseInfo[id][hPosX];
            y = HouseInfo[id][hPosY];
            z = HouseInfo[id][hPosZ];
            return 1;
        }
        else if ((id = GetInsideBusiness(playerid)) >= 0)
        {
            x = BusinessInfo[id][bPosX];
            y = BusinessInfo[id][bPosY];
            z = BusinessInfo[id][bPosZ];
            return 1;
        }
        else if ((id = GetInsideGarage(playerid)) >= 0)
        {
            x = GarageInfo[id][gPosX];
            y = GarageInfo[id][gPosY];
            z = GarageInfo[id][gPosZ];
            return 1;
        }
        else if ((id = GetInsideEntrance(playerid)) >= 0)
        {
            x = EntranceInfo[id][ePosX];
            y = EntranceInfo[id][ePosY];
            z = EntranceInfo[id][ePosZ];
            return 1;
        }
        else if (GetPlayerInterior(playerid))
        {
            for (new i = 0; i < sizeof(staticEntrances); i ++)
            {
                if (IsPlayerInRangeOfPoint(playerid, 100.0, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ]))
                {
                    x = staticEntrances[i][ePosX];
                    y = staticEntrances[i][ePosY];
                    z = staticEntrances[i][ePosZ];
                    return 1;
                }
            }
        }
    }
    GetPlayerPos(playerid, x, y, z);
    return 1;
}

GetPlayerCapacity(playerid, item)
{
    switch (item)
    {
        case CAPACITY_MATERIALS:
        {
            return 50000 + (PlayerData[playerid][pInventoryUpgrade] * 10000);
        }
        case CAPACITY_WEED:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 50;
                case 1: return 75;
                case 2: return 100;
                case 3: return 125;
                case 4: return 150;
                case 5: return 200;
            }
        }
        case CAPACITY_COCAINE:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 25;
                case 1: return 50;
                case 2: return 75;
                case 3: return 100;
                case 4: return 125;
                case 5: return 150;
            }
        }
        case CAPACITY_HEROIN:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 20;
                case 1: return 40;
                case 2: return 60;
                case 3: return 80;
                case 4: return 100;
                case 5: return 150;
            }
        }
        case CAPACITY_PAINKILLERS:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 5;
                case 1: return 10;
                case 2: return 15;
                case 3: return 20;
                case 4: return 25;
                case 5: return 30;
            }
        }
        case CAPACITY_SEEDS:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 10;
                case 1: return 20;
                case 2: return 30;
                case 3: return 40;
                case 4: return 50;
                case 5: return 60;
            }
        }
        case CAPACITY_CHEMICALS:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 10;
                case 1: return 15;
                case 2: return 20;
                case 3: return 25;
                case 4: return 30;
                case 5: return 40;
            }
        }
        case CAPACITY_GASCAN:
        {
            switch (PlayerData[playerid][pInventoryUpgrade])
            {
                case 0: return 125;
                case 1: return 250;
                case 2: return 375;
                case 3: return 500;
                case 4: return 750;
                case 5: return 1000;
            }
        }
    }

    return 0;
}

GetPlayerAssetCount(playerid, type)
{
    new count;

    switch (type)
    {
        case LIMIT_HOUSES:
        {
            foreach(new i : House)
            {
                if (HouseInfo[i][hExists] && PlayerData[playerid][pID] == HouseInfo[i][hOwnerID])
                {
                    count++;
                }
            }
        }
        case LIMIT_BUSINESSES:
        {
            foreach(new i : Business)
            {
                if (BusinessInfo[i][bExists] && PlayerData[playerid][pID] == BusinessInfo[i][bOwnerID])
                {
                    count++;
                }
            }
        }
        case LIMIT_GARAGES:
        {
            foreach(new i : Garage)
            {
                if (GarageInfo[i][gExists] && PlayerData[playerid][pID] == GarageInfo[i][gOwnerID])
                {
                    count++;
                }
            }
        }
    }

    return count;
}

GetPlayerAssetLimit(playerid, type)
{
    switch (type)
    {
        case LIMIT_HOUSES:
        {
            switch (PlayerData[playerid][pDonator])
            {
                case 2: return 4;
                case 3: return 6;
            }

            switch (PlayerData[playerid][pAssetUpgrade])
            {
                case 0, 1: return 1;
                case 2, 3: return 2;
                case 4: return 3;
            }
        }
        case LIMIT_BUSINESSES:
        {
            switch (PlayerData[playerid][pAssetUpgrade])
            {
                case 0, 1: return 1;
                case 2, 3: return 2;
                case 4: return 3;
            }
        }
        case LIMIT_GARAGES:
        {
            switch (PlayerData[playerid][pAssetUpgrade])
            {
                case 0, 1: return 1;
                case 2, 3: return 2;
                case 4: return 3;
            }
        }
        case LIMIT_VEHICLES:
        {
            switch (PlayerData[playerid][pDonator])
            {
                case 1: return 10;
                case 2: return 15;
                case 3: return 20;
            }

            switch (PlayerData[playerid][pAssetUpgrade])
            {
                case 0: return 3;
                case 1: return 4;
                case 2: return 5;
                case 3: return 7;
                case 4: return 10;
            }
        }
    }

    return 0;
}

publish AddToPaycheck(playerid, amount)
{
    if (PlayerData[playerid][pLogged])
    {
        PlayerData[playerid][pPaycheck] = PlayerData[playerid][pPaycheck] + amount;

        if (PlayerData[playerid][pPaycheck] >= 20000)
        {
            AwardAchievement(playerid, ACH_WorkingClass);
        }

        if (!PlayerData[playerid][pAdminDuty])
        {
            DBQuery("UPDATE "#TABLE_USERS" SET paycheck = paycheck + %i WHERE uid = %i", amount, PlayerData[playerid][pID]);
            AddToTaxVault(-amount);
        }
    }
}

publish GetPlayerUID(playerid)
{
    return PlayerData[playerid][pID];
}

publish GetPlayerCash(playerid)
{
    return PlayerData[playerid][pCash];
}

publish PlayerHasCash(playerid, cash)
{
    return PlayerData[playerid][pCash] >= cash;
}

IsPlayerOnline(const name[], &id = INVALID_PLAYER_ID)
{
    foreach(new i : Player)
    {
        if (!strcmp(GetPlayerNameEx(i), name, true) && PlayerData[i][pLogged])
        {
            id = i;
            return 1;
        }
    }

    id = INVALID_PLAYER_ID;
    return 0;
}

stock GenderToString(gender)
{
    new sex[12];
    switch (PlayerGender:gender)
    {
        case PlayerGender_Male:   sex = "Male";
        case PlayerGender_Female: sex = "Female";
        case PlayerGender_Shemale: sex = "Shemale";
        default: sex = "Unspecified";
    }
    return sex;
}
stock GetPlayerGenderStr(playerid)
{
    new sex[12];
    switch (PlayerData[playerid][pGender])
    {
        case PlayerGender_Male:   sex = "Male";
        case PlayerGender_Female: sex = "Female";
        case PlayerGender_Shemale: sex = "Shemale";
        default: sex = "Unspecified";
    }
    return sex;
}

stock GetPlayerAgeStr(playerid)
{
    new age[7];
    format(age, sizeof(age), "%d", PlayerData[playerid][pAge]);
    return age;
}


publish GivePlayerCash(playerid, amount)
{
    if (PlayerData[playerid][pLogged])
    {
        PlayerData[playerid][pCash] = PlayerData[playerid][pCash] + amount;
        if (amount < 0)
        {
            DBQuery("UPDATE "#TABLE_USERS" SET cash = cash + %i, money_spent = money_spent + %i WHERE uid = %i",
                amount,
                -amount,
                PlayerData[playerid][pID]);

            DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE uid = %i AND money_spent >= 500000", PlayerData[playerid][pID]);
            DBExecute("OnPlayerCheckRich", "i", playerid);
        }
        else if (amount > 0)
        {
            DBQuery("UPDATE "#TABLE_USERS" SET cash = cash + %i, money_earned = money_earned + %i WHERE uid = %i",
                amount,
                amount,
                PlayerData[playerid][pID]);

            DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE uid = %i AND money_earned >= 500000", PlayerData[playerid][pID]);
            DBExecute("OnPlayerCheckHighRoller", "i", playerid);
        }
    }
    return 1;
}

publish GivePlayerMaterials(playerid, amount)
{
    if (PlayerData[playerid][pLogged])
    {
        PlayerData[playerid][pMaterials] = PlayerData[playerid][pMaterials] + amount;
        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
    }
    return 1;
}

IsLawEnforcement(playerid)
{
    return GetPlayerFaction(playerid) == FACTION_POLICE || GetPlayerFaction(playerid) == FACTION_FEDERAL || GetPlayerFaction(playerid) == FACTION_ARMY;
}

IsACop(playerid)
{
    return IsLawEnforcement(playerid);
}

publish IsPlayerLoggedIn(playerid)
{
    return PlayerData[playerid][pLogged];
}

publish IsPlayerScripter(playerid)
{
    return PlayerData[playerid][pDeveloper];
}

publish IsPlayerFormerAdmin(playerid)
{
    return PlayerData[playerid][pFormerAdmin];
}

publish IsPlayerInFaction(playerid, type)
{
    return GetPlayerFaction(playerid) == type;
}

publish GetPlayerData(playerid, pEnum:var)
{
    return PlayerData[playerid][var];
}

publish SetPlayerData(playerid, pEnum:var, amount)
{
    PlayerData[playerid][var] = amount;
}


FriskPlayer(playerid, targetid)
{
    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Items _____", GetRPName(targetid));
    //TODO: rework frisk

    if (PlayerData[targetid][pCash] < 100000)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Cash: $%i", PlayerData[targetid][pCash]);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY2, "Cash: $100000+");
    }

    if (PlayerData[targetid][pPhone])
    {
        SendClientMessage(playerid, COLOR_GREY2, "Mobile phone");
    }
    if (PlayerData[targetid][pPrivateRadio])
    {
        SendClientMessage(playerid, COLOR_GREY2, "Private radio");
    }
    if(PlayerData[targetid][pBackpack])
	{
	    SendClientMessage(playerid, COLOR_GREY2, "This player has a backpack, use /bpfrisk to frisk the backpack");
	}
    if (PlayerData[targetid][pBocketFull])
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "BocketFull (%i)", PlayerData[targetid][pBocketFull]);
    }
	if (PlayerData[targetid][pBocket])
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Bocket (%i)", PlayerData[targetid][pBocket]);
    }
    if (PlayerData[targetid][pSpraycans])
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Spraycans (%i)", PlayerData[targetid][pSpraycans]);
    }
    if (PlayerData[targetid][pBoombox])
    {
        SendClientMessage(playerid, COLOR_GREY2, "Boombox");
    }
    if (PlayerData[targetid][pMP3Player])
    {
        SendClientMessage(playerid, COLOR_GREY2, "MP3 player");
    }
    if (HasPhonebook(targetid))
    {
        SendClientMessage(playerid, COLOR_GREY2, "Phonebook");
    }
    if (PlayerData[targetid][pPoliceScanner])
    {
        SendClientMessage(playerid, COLOR_GREY2, "Police scanner");
    }
    if (PlayerData[targetid][pMaterials] > 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Materials (%i)", PlayerData[targetid][pMaterials]);
    }
    if (PlayerData[targetid][pFirstAid] > 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "First aid (%i)", PlayerData[targetid][pFirstAid]);
    }
    if (PlayerData[targetid][pBodykits] > 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Bodywork kits (%i)", PlayerData[targetid][pBodykits]);
    }
    if (PlayerData[targetid][pWeed])
    {
        SendClientMessageEx(playerid, COLOR_RED, "Weed (%ig)", PlayerData[targetid][pWeed]);
    }
    if (PlayerData[targetid][pCocaine])
    {
        SendClientMessageEx(playerid, COLOR_RED, "Cocaine (%ig)", PlayerData[targetid][pCocaine]);
    }
    if (PlayerData[targetid][pHeroin])
    {
        SendClientMessageEx(playerid, COLOR_RED, "Heroin (%ig)", PlayerData[targetid][pHeroin]);
    }
    if (PlayerData[targetid][pPainkillers])
    {
        SendClientMessageEx(playerid, COLOR_RED, "Painkillers (%i)", PlayerData[targetid][pPainkillers]);
    }
    if (PlayerData[targetid][pSeeds])
    {
        SendClientMessageEx(playerid, COLOR_RED, "Weed seeds (%i)", PlayerData[targetid][pSeeds]);
    }
    if (PlayerData[targetid][pChemicals])
    {
        SendClientMessageEx(playerid, COLOR_RED, "Chems (%i)", PlayerData[targetid][pChemicals]);
    }
    switch (PlayerData[targetid][pSmuggleDrugs])
    {
        case 1: SendClientMessageEx(playerid, COLOR_RED, "Seeds package");
        case 2: SendClientMessageEx(playerid, COLOR_RED, "Cocaine package");
        case 3: SendClientMessageEx(playerid, COLOR_RED, "Chems package");
    }

    for (new i = 0; i < 13; i ++)
    {
        if (PlayerData[targetid][pWeapons][i] > 0)
        {
            SendClientMessageEx(playerid, COLOR_RED, "%s", GetWeaponNameEx(PlayerData[targetid][pWeapons][i]));
        }
    }

    ShowActionBubble(playerid, "* %s searches for illegal items on %s.", GetRPName(playerid), GetRPName(targetid));
}

DisplayStats(playerid, targetid = INVALID_PLAYER_ID)
{
    if (targetid == INVALID_PLAYER_ID) targetid = playerid;
    new name[24];
    new faction[48];
    new facrank[32];
    new gang[32];
    new gangrank[32];
    new gangcrew[32];
    new division[32];
    new insurance[32];
    new Float:health;
    new Float:armor;
    new job[32];
    new secondjob[32];

    if (playerid == MAX_PLAYERS)
    {
        strcpy(name, PlayerData[playerid][pUsername]);
    }
    else
    {
        strcat(name, GetRPName(playerid));
    }

    insurance = GetHospitalName(PlayerData[playerid][pInsurance]);

    if (PlayerData[playerid][pFaction] >= 0)
    {
        if (!strcmp(FactionInfo[PlayerData[playerid][pFaction]][fShortName], "None", true))
        {
            strcpy(faction, FactionInfo[PlayerData[playerid][pFaction]][fName]);
        }
        else
        {
            strcpy(faction, FactionInfo[PlayerData[playerid][pFaction]][fShortName]);
        }

        format(facrank, sizeof(facrank), "%s (%i)", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], PlayerData[playerid][pFactionRank]);

        if (PlayerData[playerid][pDivision] >= 0)
        {
            strcpy(division, FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]]);
        }
        else
        {
            division = "None";
        }
    }
    else
    {
        faction = "None";
        facrank = "N/A";
        division = "None";
    }

    if (PlayerData[playerid][pGang] >= 0)
    {
        strcpy(gang, GangInfo[PlayerData[playerid][pGang]][gName]);
        format(gangrank, sizeof(gangrank), "%s (%i)", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], PlayerData[playerid][pGangRank]);
        if (PlayerData[playerid][pCrew] >= 0)
        {
            strcpy(gangcrew, GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]]);
        }
        else
        {
            gangcrew = "None";
        }
    }
    else
    {
        gang = "None";
        gangrank = "N/A";
        gangcrew = "None";
    }

    if (playerid == MAX_PLAYERS)
    {
        health = PlayerData[playerid][pHealth];
        armor = PlayerData[playerid][pArmor];
    }
    else
    {
        GetPlayerHealth(playerid, health);
        GetPlayerArmour(playerid, armor);
    }

    if (PlayerData[playerid][pJob] != JOB_NONE)
    {
        format(job, sizeof(job), "%s (%i)", GetJobName(PlayerData[playerid][pJob]), GetJobLevel(playerid, PlayerData[playerid][pJob]));
    }
    else
    {
        job = "None";
    }

    if (PlayerData[playerid][pSecondJob] != JOB_NONE)
    {
        format(secondjob, sizeof(secondjob), "%s (%i)", GetJobName(PlayerData[playerid][pSecondJob]), GetJobLevel(playerid, PlayerData[playerid][pSecondJob]));
    }
    else
    {
        secondjob = "None";
    }
    new totalwealth = PlayerData[playerid][pCash] + PlayerData[playerid][pBank];

    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && PlayerData[playerid][pID] == HouseInfo[i][hOwnerID])
        {
            totalwealth += HouseInfo[i][hCash];
        }
    }

    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && PlayerData[playerid][pID] == BusinessInfo[i][bOwnerID])
        {
            totalwealth += BusinessInfo[i][bCash];
        }
    }

    new title[256];
    format(title, sizeof(title), "{FF9900}%s - %s [%s]", GetDateTime(), name, GetPlayerSerialNumber(playerid));

    new content[4096];
    format(content, sizeof(content), "{FFFFFF}Level: {33CCFF}%i{FFFFFF} - XP: {33CCFF}%s/%s{FFFFFF}"\
                                     " - Next level cost: {33CCFF}%s{FFFFFF} - Hours: {33CCFF}%s{FFFFFF} - Double XP: {33CCFF}%i",
           PlayerData[playerid][pLevel], FormatNumber(PlayerData[playerid][pEXP]),
           FormatNumber((PlayerData[playerid][pLevel] * 4)), FormatCash((PlayerData[playerid][pLevel] + 1) * LEVEL_COST),
           FormatNumber(PlayerData[playerid][pHours]), PlayerData[playerid][pDoubleXP]);
    format(content, sizeof(content), "%s\n{FFFFFF}Age:{33CCFF} %i (%s) {FFFFFF}- Cookies:{33CCFF} %s {FFFFFF}- Phone:{33CCFF} %i {FFFFFF}- Radio:{33CCFF} %i Khz {FFFFFF}- Married To: {33CCFF}%s",
           content, PlayerData[playerid][pAge], GetPlayerGenderStr(playerid), FormatNumber(GetPlayerCookies(playerid)),
           PlayerData[playerid][pPhone], PlayerData[playerid][pChannel], PlayerData[playerid][pMarriedName]);
    format(content, sizeof(content), "%s\n{FFFFFF}Total Wealth:{33CCFF} %s (Cash %s, Bank %s) {FFFFFF}\nPaycheck:{33CCFF} %s (Playing Time: %i/60 min)",
           content, FormatCash(totalwealth), FormatCash(PlayerData[playerid][pCash]), FormatCash(PlayerData[playerid][pBank]),
           FormatCash(PlayerData[playerid][pPaycheck]), PlayerData[playerid][pMinutes]);

    format(content, sizeof(content), "%s\n\n{FFFFFF}Insured:{33CCFF} %s {FFFFFF}- HP:{33CCFF} %.0f (Spawn: %.0f) {FFFFFF}- Armor:{33CCFF} %.0f (Spawn: %.0f)",
           content, insurance, health, PlayerData[playerid][pSpawnHealth], armor, PlayerData[playerid][pSpawnArmor]);

    format(content, sizeof(content), "%s\n{FFFFFF}WantedLevel:{33CCFF} %d {FFFFFF}- Notoriety:{33CCFF} %s {FFFFFF}- Crimes:{33CCFF} %s {FFFFFF}- Arrests:{33CCFF} %s",
           content, GetWantedLevel(playerid), FormatNumber(PlayerData[playerid][pNotoriety]),
           FormatNumber(PlayerData[playerid][pCrimes]), FormatNumber(PlayerData[playerid][pArrested]));


    format(content, sizeof(content), "%s\n\n{FFFFFF}Jobs:{33CCFF} %s, %s", content, job, secondjob);
    if (PlayerData[playerid][pGang] >= 0 && PlayerData[playerid][pFaction] >= 0)
    {
        format(content, sizeof(content), "%s\n{FFFFFF}Membership:{00FF00} %s %s (Crew: %s) {FFFFFF}-{0000FF} %s %s (Division: %s)",
            content, gang, gangrank, gangcrew, faction, facrank, division);
    }
    else if (PlayerData[playerid][pGang] >= 0)
    {
        format(content, sizeof(content), "%s\n{FFFFFF}Membership:{00FF00} %s %s (Crew: %s)",
            content, gang, gangrank, gangcrew);
    }
    else if (PlayerData[playerid][pFaction] >= 0)
    {
        format(content, sizeof(content), "%s\n{FFFFFF}Membership:{0000FF} %s %s (Division: %s)",
            content, faction, facrank, division);
    }
    else
    {
        format(content, sizeof(content), "%s\n{FFFFFF}Membership:{C8C8C8} None", content);
    }
    format(content, sizeof(content), "%s\n{FFFFFF}Donator: %s ", content, GetVIPRankEx(PlayerData[playerid][pDonator]));
    if (PlayerData[playerid][pDonator])
    {
        format(content, sizeof(content), "%s\n{FFFFFF}- Exipry Date: {33CCFF}%s",
               content, TimestampToString(PlayerData[playerid][pVIPTime], 4));

        new time = PlayerData[playerid][pVIPCooldown] - gettime();
        if (time > 3600)
        {
            format(content, sizeof(content), "%s {FFFFFF}- Invite:{C8C8C8} available after %i hour(s).", time / 3600);
        }
        else if (time > 0)
        {
            format(content, sizeof(content), "%s {FFFFFF}- Invite:{C8C8C8} available after %i minute(s).", time / 60);
        }
        else
        {
            format(content, sizeof(content), "%s {FFFFFF}- Invite:{00FF00} Ready", content);
        }
    }

    format(content, sizeof(content), "%s\n\n{FFFFFF}Upgrade points:{33CCFF} %i {FFFFFF}- Drug Addict:{33CCFF} %i/3 {FFFFFF}- Trader Skill:{33CCFF} %i/3",
           content, PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pAddictUpgrade], PlayerData[playerid][pTraderUpgrade]);
    format(content, sizeof(content), "%s\n{FFFFFF}Asset Skill:{33CCFF} %i/4  {FFFFFF}- Labor Skill:{33CCFF} %i/5 {FFFFFF}- Inventory Skill:{33CCFF} %i/5",
           content, PlayerData[playerid][pAssetUpgrade], PlayerData[playerid][pLaborUpgrade], PlayerData[playerid][pInventoryUpgrade]);

    format(content, sizeof(content), "%s\n\n{FFFFFF}Warnings:{33CCFF} %i {FFFFFF}- DM Warns:{33CCFF} %i {FFFFFF}- Report warns:{33CCFF} %i {FFFFFF}- Weapon Restricted:{33CCFF} %i hours",
           content, GetPlayerWarnings(playerid), PlayerData[playerid][pDMWarnings],
           GetPlayerReportWarns(playerid), PlayerData[playerid][pWeaponRestricted]);
    if (IsAdmin(targetid) && playerid != MAX_PLAYERS)
    {
        new interior = (playerid == MAX_PLAYERS) ? (PlayerData[playerid][pInterior]) : (GetPlayerInterior(playerid));
        new vw = (playerid == MAX_PLAYERS) ? (PlayerData[playerid][pWorld]) : (GetPlayerVirtualWorld(playerid));
        new fps = (playerid == MAX_PLAYERS) ? (0) : (PlayerData[playerid][pFPS]);

        format(content, sizeof(content), "%s\n{FFFFFF}Interior:{33CCFF} %i {FFFFFF}- Virtual:{33CCFF} %i {FFFFFF}- FPS:{33CCFF} %i {FFFFFF}- AFK:{33CCFF} %s {FFFFFF}- Jail:{33CCFF} %s (%s sec)",
               content, interior, vw, fps, (playerid != MAX_PLAYERS && IsPlayerAFK(playerid) ? ("Yes") : ("No")),
               GetPlayerJailTypeStr(playerid), FormatNumber(PlayerData[playerid][pJailTime]));

        format(content, sizeof(content), "%s\n{FFFFFF}Reports:{33CCFF} %s {FFFFFF}- Help Requests:{33CCFF} %s {FFFFFF}- Newbie Replies:{33CCFF} %s",
               content, FormatNumber(PlayerData[playerid][pReports]), FormatNumber(PlayerData[playerid][pHelpRequests]),
               FormatNumber(PlayerData[playerid][pNewbies]));
    }
    else if (PlayerData[playerid][pJailType] != JailType_None)
    {
        format(content, sizeof(content), "%s\n{FFFFFF}Jail:{33CCFF} %s (%s sec)",
               content, GetPlayerJailTypeStr(playerid), FormatNumber(PlayerData[playerid][pJailTime]));
    }

    Dialog_Show(targetid, 0 , DIALOG_STYLE_MSGBOX, title, content, "Ok", "");
}

TeleportToVehicle(playerid, vehicleid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    TeleportToCoords(playerid, x + 1, y + 1, z + 1, a,
        GetVehicleInterior(vehicleid),
        GetVehicleVirtualWorld(vehicleid));
}

TeleportToPlayer(playerid, targetid, bool:vehicle = true)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(targetid, x, y, z);
    GetPlayerFacingAngle(targetid, a);
    new interior = GetPlayerInterior(targetid);
    TeleportToCoords(playerid, x + 1, y + 1, z, a, interior, GetPlayerVirtualWorld(targetid), (interior!=0), vehicle);
}

TeleportToCoords(playerid, Float:x, Float:y, Float:z, Float:angle, interiorid, worldid, bool:freeze = false, bool:vehicle = true)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if ((vehicle) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        foreach(new i : Player)
        {
            if (IsPlayerInVehicle(i, vehicleid))
            {
                SetPlayerInterior(i, interiorid);
                SetPlayerVirtualWorld(i, worldid);
            }
        }

        SetVehiclePos(vehicleid, x, y, z);
        SetVehicleZAngle(vehicleid, angle);
        SetVehicleVirtualWorld(vehicleid, worldid);
        LinkVehicleToInterior(vehicleid, interiorid);

        if (freeze)
        {
            SetTimerEx("VehicleUnfreeze", 3000, false, "iifffii", playerid, GetPlayerVehicleID(playerid), x, y, z, interiorid, worldid);
            ShowFreezeTextdraw(playerid);
            TogglePlayerControllableEx(playerid, 0);
        }
    }
    else
    {
        if (freeze)
        {
            SetFreezePos(playerid, x, y, z);
        }
        else
        {
            SetPlayerPos(playerid, x, y, z);
        }
        SetPlayerFacingAngle(playerid, angle);
        SetPlayerInterior(playerid, interiorid);
        SetPlayerVirtualWorld(playerid, worldid);
        SetCameraBehindPlayer(playerid);
    }

    new houseid;
    if ((houseid = GetInsideHouse(playerid)) >= 0)
    {
        if (HouseInfo[houseid][hLights] == 1)
        {
            TextDrawHideForPlayer(playerid, houseLights);
        }
        else
        {
            TextDrawShowForPlayer(playerid, houseLights);
        }
    }
}

ResetPlayer(playerid)
{
    if (IsPlayerInEvent(playerid))
    {
        EventKickPlayer(playerid);
        ResetPlayerWeapons(playerid);
    }
    if (PlayerData[playerid][pTazedTime] > 0)
    {
        ClearAnimations(playerid, 1);
        TogglePlayerControllableEx(playerid, 1);
    }
    if (PlayerData[playerid][pCuffed])
    {
        TogglePlayerControllableEx(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    }
    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    }
    if (PlayerData[playerid][pLiveBroadcast] != INVALID_PLAYER_ID)
    {
        PlayerData[PlayerData[playerid][pLiveBroadcast]][pLiveBroadcast] = INVALID_PLAYER_ID;
        PlayerData[playerid][pLiveBroadcast] = INVALID_PLAYER_ID;
    }
    if (PlayerData[playerid][pPlantedBomb])
    {
        DestroyDynamicObject(PlayerData[playerid][pBombObject]);
        PlayerData[playerid][pBombObject] = INVALID_OBJECT_ID;
        PlayerData[playerid][pPlantedBomb] = 0;
    }
    if (PlayerData[playerid][pFreezeTimer] >= 0)
    {
        KillTimer(PlayerData[playerid][pFreezeTimer]);
        TogglePlayerControllableEx(playerid, 1);
        PlayerData[playerid][pFreezeTimer] = -1;
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pDraggedBy] == playerid)
        {
            PlayerData[i][pDraggedBy] = INVALID_PLAYER_ID;
        }
    }
    StopWorkout(playerid);
    PlayerData[playerid][pInTurf] = -1;
    InsideShamal[playerid]= INVALID_VEHICLE_ID;
    PlayerData[playerid][pInjured] = 0;
    PlayerData[playerid][pAcceptedHelp] = 0;
    PlayerData[playerid][pChatstyle] = 0;
    PlayerData[playerid][pSpeedTime] = 0;
    PlayerData[playerid][pTazer] = 0;
    PlayerData[playerid][pTazedTime] = 0;
    PlayerData[playerid][pCuffed] = 0;
    PlayerData[playerid][pTied] = 0;
    PlayerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
    PlayerData[playerid][pDelivered] = 0;
    PlayerData[playerid][pContractTaken] = INVALID_PLAYER_ID;
    //PlayerData[playerid][pRecycle] = 0;
    PlayerData[playerid][pPoisonTime] = 0;
    PlayerData[playerid][pPreviewHouse] = -1;
    PlayerData[playerid][pPreviewType] = 0;
    PlayerData[playerid][pPreviewTime] = 0;
    PlayerData[playerid][pHHCheck] = 0;
    CancelActiveCheckpoint(playerid);
    PlayerData[playerid][pRepairShop] = -1;
    PlayerData[playerid][pRepairTime] = 0;
    RemovePlayerAttachedObject(playerid, 9);
    CallRemoteFunction("OnPlayerReset", "i", playerid);
}

Namechange(playerid, oldname[], newname[])
{
    if (!PlayerData[playerid][pUndercover][0])
    {
        foreach(new i : House)
        {
            if (HouseInfo[i][hExists] && !strcmp(HouseInfo[i][hOwner], oldname, false))
            {
                strcpy(HouseInfo[i][hOwner], newname, MAX_PLAYER_NAME);
                ReloadHouse(i);
            }
        }

        foreach(new i : Garage)
        {
            if (GarageInfo[i][gExists] && !strcmp(GarageInfo[i][gOwner], oldname, false))
            {
                strcpy(GarageInfo[i][gOwner], newname, MAX_PLAYER_NAME);
                ReloadGarage(i);
            }
        }

        foreach(new i : Business)
        {
            if (BusinessInfo[i][bExists] && !strcmp(BusinessInfo[i][bOwner], oldname, false))
            {
                strcpy(BusinessInfo[i][bOwner], newname, MAX_PLAYER_NAME);
                ReloadBusiness(i);
            }
        }

        foreach(new i : Land)
        {
            if (LandInfo[i][lExists] && !strcmp(LandInfo[i][lOwner], oldname, false))
            {
                strcpy(LandInfo[i][lOwner], newname, MAX_PLAYER_NAME);
                ReloadLand(i);
            }
        }

        foreach(new i: Vehicle)
        {
            if (VehicleInfo[i][vID] && !strcmp(VehicleInfo[i][vOwner], oldname, false))
            {
                strcpy(VehicleInfo[i][vOwner], newname, MAX_PLAYER_NAME);
            }
        }
        //TODO: fix doesn't correcly check username existance
        // Updating queries.
        DBQuery("UPDATE houses SET owner = '%e' WHERE owner = '%e'", newname, oldname);

        DBQuery("UPDATE garages SET owner = '%e' WHERE owner = '%e'", newname, oldname);

        DBQuery("UPDATE businesses SET owner = '%e' WHERE owner = '%e'", newname, oldname);

        DBQuery("UPDATE vehicles SET owner = '%e' WHERE owner = '%e'", newname, oldname);

        DBQuery("UPDATE lands SET owner = '%e' WHERE owner = '%e'", newname, oldname);

        DBQuery("UPDATE "#TABLE_USERS" SET username = '%e' WHERE uid = %i", newname, PlayerData[playerid][pID]);

        strcpy(PlayerData[playerid][pUsername], newname, MAX_PLAYER_NAME);

        SetPlayerName(playerid, newname);
        SavePlayerVariables(playerid);
    }
}


PrintNetWorthPlayer(playerid)
{
    new others = 0,
    assets = 0,
    pricevehicle = 0,
    pricehouse = 0,
    pricebiz = 0,
    priceland = 0,
    pricegarage = 0;
    new totalwealth = PlayerData[playerid][pCash] + PlayerData[playerid][pBank];

    foreach(new i : Vehicle)
    {
        if (PlayerData[playerid][pID] == VehicleInfo[i][vOwnerID])
        {
            //TODO: list stored vehicles
            assets += VehicleInfo[i][vPrice];
            pricevehicle += VehicleInfo[i][vPrice];
        }
    }
    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && PlayerData[playerid][pID] == HouseInfo[i][hOwnerID])
        {
            assets += HouseInfo[i][hPrice];
            pricehouse += HouseInfo[i][hPrice];
        }
    }
    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && PlayerData[playerid][pID] == BusinessInfo[i][bOwnerID])
        {
            assets += BusinessInfo[i][bPrice];
            pricebiz += BusinessInfo[i][bPrice];
        }
    }
    foreach(new i : Land)
    {
        if (LandInfo[i][lExists] && PlayerData[playerid][pID] == LandInfo[i][lOwnerID])
        {
            others += LandInfo[i][lPrice];
            priceland += LandInfo[i][lPrice];
        }
    }
    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && PlayerData[playerid][pID] == GarageInfo[i][gOwnerID])
        {
            others += GarageInfo[i][gPrice];
            pricegarage += GarageInfo[i][gPrice];
        }
    }
    new total = totalwealth + assets + others;

    new string[50];
    format(string, sizeof(string), "%s's net worth", GetPlayerNameEx(playerid));
    Dialog_Show(playerid, LocateHouse, DIALOG_STYLE_LIST, "Net Worth",
                "{FFFF00}Bank\t\t{FF6347}%s\n"\
                "{FFFF00}Property\t{ff6347}%s\n"\
                "{FFFFFF} |-> Spawned Vehicles\t{FF6347}%s\n"\
                "{FFFFFF} |-> Houses\t\t{FF6347}%s\n"\
                "{FFFFFF} |-> Businesses\t\t{FF6347}%s\n"\
                "{FFFF00}Others\t\t{FF6347}%s\n"\
                "{FFFFFF} |-> Lands\t\t{FF6347}%s\n"\
                "{FFFFFF} |-> Garages\t\t{FF6347}%s\n"\
                "{00FF00}Total Wealth\t\t %s\n"\
                "Ok", "Close",
                FormatCash(PlayerData[playerid][pBank]),
                FormatCash(assets),
                FormatCash(pricevehicle),
                FormatCash(pricehouse),
                FormatCash(pricebiz),
                FormatCash(others),
                FormatCash(priceland),
                FormatCash(pricegarage),
                FormatCash(total));
    return 1;
}


SetPlayerToSpawn(playerid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
    {
        SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][pSkin], PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ], PlayerData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating(playerid, 0);
    }
    else
    {
        if (IsPlayerInAnyVehicle(playerid))
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            SetPlayerPos(playerid, x, y, z + 5.0);
        }

        switch (GetPlayerState(playerid))
        {
            case PLAYER_STATE_NONE, PLAYER_STATE_WASTED:
            {
                SpawnPlayer(playerid);
            }
            default:
            {
                OnPlayerSpawn(playerid);
            }
        }
    }

    PlayerData[playerid][pACTime] = gettime() + 2;
}

SetPlayerToFacePlayer(playerid, targetid)
{
    new Float:px, Float:py, Float:pz;
    new Float:tx, Float:ty, Float:tz;
    GetPlayerPos(targetid, tx, ty, tz);
    GetPlayerPos(playerid, px, py, pz);
    SetPlayerFacingAngle(playerid, 180.0 - atan2(px - tx, py - ty));
}

publish SavePlayerVariables(playerid)
{
    if (PlayerData[playerid][pLogged] &&
        !PlayerData[playerid][pAdminDuty] &&
        !PlayerData[playerid][pAcceptedHelp] &&
        !PlayerData[playerid][pUndercover][0])
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING &&
            !IsPlayerInRangeOfPoint(playerid, 2.0, 0.0, 0.0, 0.0) &&
            !IsPlayerInEvent(playerid) && !IsDueling(playerid) &&
            PlayerData[playerid][pPaintball] == 0 &&
            !PlayerData[playerid][pAcceptedHelp] &&
            PlayerData[playerid][pPreviewHouse] == -1 &&
            !IsInDealership(playerid))
        {
            SavePlayerWeapons(playerid);
            GetPlayerPos(playerid, PlayerData[playerid][pPosX], PlayerData[playerid][pPosY], PlayerData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, PlayerData[playerid][pPosA]);

            if (!PlayerData[playerid][pHHCheck])
            {
                GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
                GetPlayerArmour(playerid, PlayerData[playerid][pArmor]);
            }

            PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
            PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
        }

        DBFormat("UPDATE "#TABLE_USERS" SET ");

        DBContinueFormat(
            "  pos_x = '%f', pos_y = '%f', pos_z = '%f'"\
            ", pos_a = '%f', interior = %i, world = %i",
            PlayerData[playerid][pPosX], PlayerData[playerid][pPosY    ], PlayerData[playerid][pPosZ ],
            PlayerData[playerid][pPosA], PlayerData[playerid][pInterior], PlayerData[playerid][pWorld]);

        DBContinueFormat(
            ", toggleooc = %i, toggleglobal = %i, togglenewbie = %i"\
            ", togglevip = %i, togglewhisper = %i, togglepm = %i"\
            ", togglefaction = %i, toggleradio = %i, togglebug = %i"\
            ", togglegang = %i, toggleturfs = %i, togglepoint = %i"\
            ", togglenews = %i, togglephone = %i, togglewt = %i"\
            ", toggleadmin = %i, togglereports = %i, togglehelper = %i"\
            ", togglemusic = %i, toggletextdraws = %i, togglehud = %i"\
            ", togglevehicle = %d, togglecam = %i",
            PlayerData[playerid][pToggleOOC    ], PlayerData[playerid][pToggleGlobal   ], PlayerData[playerid][pToggleNewbie],
            PlayerData[playerid][pToggleVIP    ], PlayerData[playerid][pToggleWhisper  ], PlayerData[playerid][pTogglePM    ],
            PlayerData[playerid][pToggleFaction], PlayerData[playerid][pToggleRadio    ], PlayerData[playerid][pToggleBug   ],
            PlayerData[playerid][pToggleGang   ], PlayerData[playerid][pToggleTurfs    ], PlayerData[playerid][pTogglePoints],
            PlayerData[playerid][pToggleNews   ], PlayerData[playerid][pTogglePhone    ], PlayerData[playerid][pTogglePR    ],
            PlayerData[playerid][pToggleAdmin  ], PlayerData[playerid][pToggleReports  ], PlayerData[playerid][pToggleHelper],
            PlayerData[playerid][pToggleMusic  ], PlayerData[playerid][pToggleTextdraws], PlayerData[playerid][pToggleHUD   ],
            PlayerData[playerid][pToggleVehCam ], PlayerData[playerid][pToggleCam      ]);

        DBContinueFormat(
            ", scanneron = %i, watchon = %i, gpson = %i"\
            ", adminhide = %i, bandana = %i, duty = %i"\
            ", showturfs = %i, showlands = %i",
            PlayerData[playerid][pScannerOn], PlayerData[playerid][pWatchOn  ], PlayerData[playerid][pGPSOn],
            PlayerData[playerid][pAdminHide], PlayerData[playerid][pBandana  ], PlayerData[playerid][pDuty],
            PlayerData[playerid][pShowTurfs], PlayerData[playerid][pShowLands]);

        DBContinueFormat(
            ", health = '%f', spawnhealth = '%f', injured = %i"\
            ", armor = '%f', spawnarmor = '%f', hospital = %i"\
            ", jailtype = %i, jailtime = %i, spawntype = %i"\
            ", spawnhouse = %i",
            PlayerData[playerid][pHealth  ], PlayerData[playerid][pSpawnHealth], PlayerData[playerid][pInjured],
            PlayerData[playerid][pArmor   ], PlayerData[playerid][pSpawnArmor ], PlayerData[playerid][pHospital],
          _:PlayerData[playerid][pJailType], PlayerData[playerid][pJailTime   ], PlayerData[playerid][pSpawnSelect],
            PlayerData[playerid][pSpawnHouse]);

        DBContinueFormat(
            ", weedgrams = %i, weed = %d, cocaine = %d"\
            ", heroin = %d, materials = %d, rope = %d"\
            ", bocketfull = %d, bocket = %d"\
            ", spraycans = %d, phonebook = %i, upgradepoints = %i",
            GetPlayerWeedGrams(playerid),     PlayerData[playerid][pWeed ],     PlayerData[playerid][pCocaine],
            PlayerData[playerid][pHeroin],      PlayerData[playerid][pMaterials], PlayerData[playerid][pRope],
            PlayerData[playerid][pBocketFull], PlayerData[playerid][pBocket],
            PlayerData[playerid][pSpraycans], HasPhonebook(playerid),           PlayerData[playerid][pUpgradePoints]);

        DBContinueFormat(
            ", pizzacooldown = %i, detectivecooldown = %i, rarecooldown = %i"\
            ", weedtime = %i, cocainecooldown = %i",
            GetPizzaCoolDown(playerid), PlayerData[playerid][pDetectiveCooldown], PlayerData[playerid][pRareTime],
            GetPlayerWeedTime(playerid), PlayerData[playerid][pCocaineCooldown]);

        DBContinueFormat(
            ", totalpatients = %i, totalfires = %i, minutes = %i",
            PlayerData[playerid][pTotalPatients ], PlayerData[playerid][pTotalFires], PlayerData[playerid][pMinutes]);

        DBContinueFormat(
            ", glassitem = %i, metalitem = '%i', rubberitem = %i"\
            ", ironitem = %i, plasticitem = %i",
            PlayerData[playerid][pGlassItem   ], PlayerData[playerid][pMetalItem], PlayerData[playerid][pRubberItem],
            PlayerData[playerid][pIronItem], PlayerData[playerid][pPlasticItem]);

        DBContinueFormat(
            ", backpack = %i, bpcash = %i, bpmaterials = '%i', bpWeed = %i"\
            ", bpCocaine = %i, bpHeroin = '%i', bppainkillers = %i",
            PlayerData[playerid][pBackpack], PlayerData[playerid][bpCash   ], PlayerData[playerid][bpMaterials], PlayerData[playerid][bpWeed],
            PlayerData[playerid][bpCocaine], PlayerData[playerid][bpHeroin], PlayerData[playerid][bpPainkillers]);

        DBContinueFormat(
            ", bugged = %i, buggedby = '%e', housealarm = %i"\
            ", chatstyle = %i, fightstyle = %i",
            PlayerData[playerid][pBugged   ], PlayerData[playerid][pBuggedBy], PlayerData[playerid][pHouseAlarm],
            PlayerData[playerid][pChatstyle], PlayerData[playerid][pFightStyle]);

        DBContinueFormat(" WHERE uid=%d", PlayerData[playerid][pID]);
        DBExecute();
    }
}

SavePlayerWeapons(playerid)
{
    if (PlayerData[playerid][pLogged] && !IsPlayerInEvent(playerid) && PlayerData[playerid][pPaintball] == 0 && !IsDueling(playerid))
    {
        // Saving weapons.
        DBQuery("UPDATE "#TABLE_USERS" SET " \
                    "weapon_0=%i,"\
                    "weapon_1=%i,"\
                    "weapon_2=%i,"\
                    "weapon_3=%i,"\
                    "weapon_4=%i,"\
                    "weapon_5=%i,"\
                    "weapon_6=%i,"\
                    "weapon_7=%i,"\
                    "weapon_8=%i,"\
                    "weapon_9=%i,"\
                    "weapon_10=%i,"\
                    "weapon_11=%i,"\
                    "weapon_12=%i,"\
                    "ammo_0=%i,"\
                    "ammo_1=%i,"\
                    "ammo_2=%i,"\
                    "ammo_3=%i,"\
                    "ammo_4=%i,"\
                    "ammo_5=%i,"\
                    "ammo_6=%i,"\
                    "ammo_7=%i,"\
                    "ammo_8=%i,"\
                    "ammo_9=%i,"\
                    "ammo_10=%i,"\
                    "ammo_11=%i,"\
                    "ammo_12=%i"\
                " WHERE uid=%i",
                PlayerData[playerid][pWeapons][0],
                PlayerData[playerid][pWeapons][1],
                PlayerData[playerid][pWeapons][2],
                PlayerData[playerid][pWeapons][3],
                PlayerData[playerid][pWeapons][4],
                PlayerData[playerid][pWeapons][5],
                PlayerData[playerid][pWeapons][6],
                PlayerData[playerid][pWeapons][7],
                PlayerData[playerid][pWeapons][8],
                PlayerData[playerid][pWeapons][9],
                PlayerData[playerid][pWeapons][10],
                PlayerData[playerid][pWeapons][11],
                PlayerData[playerid][pWeapons][12],
                PlayerData[playerid][pAmmo][0],
                PlayerData[playerid][pAmmo][1],
                PlayerData[playerid][pAmmo][2],
                PlayerData[playerid][pAmmo][3],
                PlayerData[playerid][pAmmo][4],
                PlayerData[playerid][pAmmo][5],
                PlayerData[playerid][pAmmo][6],
                PlayerData[playerid][pAmmo][7],
                PlayerData[playerid][pAmmo][8],
                PlayerData[playerid][pAmmo][9],
                PlayerData[playerid][pAmmo][10],
                PlayerData[playerid][pAmmo][11],
                PlayerData[playerid][pAmmo][12],
                PlayerData[playerid][pID]);
    }
}

DB:OnPlayerCheckRich(playerid)
{
    if (GetDBNumRows())
    {
        AwardAchievement(playerid, ACH_ImRich);
    }
}

DB:OnPlayerCheckHighRoller(playerid)
{
    if (GetDBNumRows())
    {
        AwardAchievement(playerid, ACH_HighRoller);
    }
}


DB:OnPlayerAttemptResetUpgrades(playerid)
{
    if (PlayerData[playerid][pDonator] == 0 && GetDBIntFieldFromIndex(0, 0) > 3)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i vehicle at the moment. Please sell one of them before using this command.", GetDBIntFieldFromIndex(0, 0), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
    }
    else
    {
        PlayerData[playerid][pUpgradePoints] = (PlayerData[playerid][pLevel] - 1) * 2;
        PlayerData[playerid][pInventoryUpgrade] = 0;
        PlayerData[playerid][pAddictUpgrade] = 0;
        PlayerData[playerid][pTraderUpgrade] = 0;
        PlayerData[playerid][pAssetUpgrade] = 0;
        PlayerData[playerid][pLaborUpgrade] = 0;
        PlayerData[playerid][pSpawnHealth] = 50.0;
        PlayerData[playerid][pSpawnArmor] = 0.0;

        DBQuery("UPDATE "#TABLE_USERS" SET upgradepoints = %i, inventoryupgrade = 0, addictupgrade = 0, traderupgrade = 0, assetupgrade = 0, laborupgrade = 0, spawnhealth = '50.0', spawnarmor = '0.0' WHERE uid = %i", PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);

        SendClientMessageEx(playerid, COLOR_GREEN, "You have reset your upgrade points. You now have %i upgrade points available.", PlayerData[playerid][pUpgradePoints]);
    }
}

DB:OnPlayerAttemptNameChange(playerid, name[])
{
    if (GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "That name is already taken, please choose another.");

        if (PlayerData[playerid][pFreeNamechange])
        {
            Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
        }
    }
    else
    {
        strcpy(PlayerData[playerid][pNameChange], name, MAX_PLAYER_NAME);

        if (PlayerData[playerid][pFreeNamechange])
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have requested a namechange to {00AA00}%s{33CCFF} for free, please wait for admin approval.", name);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_AQUA, "You have requested a namechange to {00AA00}%s{33CCFF} for %s, please wait for admin approval.", name, FormatCash(PlayerData[playerid][pLevel] * LEVEL_COST));
        }

        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is requesting a namechange to %s. (/acceptname %i or /denyname %i)", GetRPName(playerid), playerid, name, playerid, playerid);
    }
}
