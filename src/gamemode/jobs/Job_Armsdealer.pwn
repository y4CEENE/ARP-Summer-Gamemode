/// @file      Job_Armsdealer.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static MatRun_Qty = 250;
static MatRun_Cost = 100;
static MatRun_QtyPerLevel = 50;
static MatRun_VIP3Bonus = 250;
static MatRun_Notoriety = 10;
static MatRun_IllegalPoints = 80;

hook OnLoadGameMode(timestamp)
{
    new Node:job;
    new Node:armsdealer;
    if (!GetServerConfig("jobs", job) && !JSON_GetObject(job, "armsdealer", armsdealer))
    {
        JSON_GetInt(armsdealer, "matrun_qty",            MatRun_Qty);
        JSON_GetInt(armsdealer, "matrun_cost",           MatRun_Cost);
        JSON_GetInt(armsdealer, "matrun_qty_per_level",  MatRun_QtyPerLevel);
        JSON_GetInt(armsdealer, "matrun_vip3_bonus",     MatRun_VIP3Bonus);
        JSON_GetInt(armsdealer, "matrun_notoriety",      MatRun_Notoriety);
        JSON_GetInt(armsdealer, "matrun_illegal_points", MatRun_IllegalPoints);
    }
}

IsMafiaWeapon(weaponid)
{
    switch (weaponid)
    {
        case  8: return true; // Katana
        case 24: return true; // Desert Eagle
        case 29: return true; // MP5
        case 30: return true; // AK-47
        case 31: return true; // M4
        case 27: return true; // Combat Shotgun
        case 34: return true; // Sniper Rifle
    }
    return false;
}

GetNearbyMaterialFactory(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 2173.2129, -2264.1548, 13.3467))
    {
        return 1;
    }
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 2288.0918, -1105.6555, 37.9766))
    {
        return 2;
    }
    if (IsPlayerInRangeOfPoint(playerid, 20.0, 29.0318,-1399.3555,1.7680))
    {
        return 3;
    }
    if (IsPlayerInRangeOfPoint(playerid, 30.0, -1368.1206, -203.7393, 14.1484) ||
        IsPlayerInRangeOfPoint(playerid, 30.0,   310.8307, 2033.6459, 17.6406) ||
        IsPlayerInRangeOfPoint(playerid, 30.0,   401.2192, 2502.6482, 16.4844) ||
        IsPlayerInRangeOfPoint(playerid, 30.0,  1582.8756, 1356.8186, 10.8556) ||
        IsPlayerInRangeOfPoint(playerid, 30.0,  1574.8552, 1505.5690, 10.8361))
    {
        return 4;
    }
    return -1;
}

hook OnPlayerReachCheckpoint(playerid, type, flag)
{
    if (type != CHECKPOINT_MATS || PlayerData[playerid][pSmuggleMats] <= 0)
        return 1;

    new mf = GetNearbyMaterialFactory(playerid);
    if (mf == -1 || PlayerData[playerid][pSmuggleMats] != mf)
        return 1;

    if (gettime() - PlayerData[playerid][pSmuggleTime] < 20 && !IsAdmin(playerid, ADMIN_LVL_3) && !PlayerData[playerid][pKicked])
    {
        PlayerData[playerid][pACWarns]++;

        if (PlayerData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport matrunning (time: %i).", GetRPName(playerid), playerid, gettime() - PlayerData[playerid][pSmuggleTime]);
        }
        else
        {
            BanPlayer(playerid, "Teleport matrun");
        }
    }

    new mats = MatRun_Qty;
    if (PlayerData[playerid][pSmuggleMats] == 4)
    {
        mats = MatRun_Qty * 3;
    }
    mats += MatRun_QtyPerLevel * GetJobLevel(playerid,JOB_FORKLIFT);

    if (PlayerData[playerid][pDonator] >= 3)
    {
        mats += MatRun_VIP3Bonus;
    }

    if (PlayerData[playerid][pMaterials] + mats > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
    }

    if (PlayerData[playerid][pDonator] >= 3)
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "You've earned %d more materials for being a {D909D9}Legendary VIP", MatRun_VIP3Bonus);
    }

    if (PlayerData[playerid][pGang] >= 0)
    {
        GiveGangPoints(PlayerData[playerid][pGang], 1);
    }

    if (IsPlayerInAnyVehicle(playerid))
    {
        PlayerData[playerid][pDedication] = 0;
    }

    if (PlayerData[playerid][pDedication])
    {
        AwardAchievement(playerid, ACH_Dedication);
    }
    PlayerData[playerid][pMaterials] += mats;
    SendClientMessageEx(playerid, COLOR_AQUA, "You have dropped off your load and collected %d materials from the depot.", mats);

    PlayerData[playerid][pSmuggleMats] = 0;
    GiveNotoriety(playerid, MatRun_Notoriety);
    GivePlayerRankPointIllegalJob(playerid, MatRun_IllegalPoints);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have gained 10 notoriety for matrials smuggling, you now have %d.", PlayerData[playerid][pNotoriety]);
    DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
    return 1;
}

CMD:getmats(playerid, params[])
{
    return callcmd::smugglemats(playerid, params);
}

CMD:smugglemats(playerid, params[])
{
    if (!PlayerHasJob(playerid, JOB_ARMSDEALER) && !PlayerHasJob(playerid, JOB_CRAFTMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a craft man or arms Dealer.");
    }
    if (!IsPlayerInRangeOfPoint(playerid,  3.0, 1423.4292, -1319.1487, 13.5547) &&
        !IsPlayerInRangeOfPoint(playerid,  3.0, 2393.4885, -2008.5726, 13.3467) &&
        !IsPlayerInRangeOfPoint(playerid, 20.0,  714.5344, -1565.1694,  1.7680) &&
        !IsPlayerInRangeOfPoint(playerid, 20.0, 2112.3240, -2432.8130, 13.5469))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any materials pickup.");
    }
    if (PlayerHasActiveCheckpoint(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must cancel your active checkpoint first. /cancelcp to cancel it.");
    }
    if (PlayerData[playerid][pCash] < MatRun_Cost)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need at least %s in cash to smuggle materials.", FormatCash(MatRun_Cost));
    }
    new materialFactory = 1;
    if (IsPlayerInRangeOfPoint(playerid,  3.0, 1421.6913, -1318.4719, 13.5547)) { materialFactory = 1; }
    else if (IsPlayerInRangeOfPoint(playerid,  3.0, 2393.4885, -2008.5726, 13.3467)) { materialFactory = 2; }
    else if (IsPlayerInRangeOfPoint(playerid, 20.0,  714.5344, -1565.1694,  1.7680)) { materialFactory = 3; }
    else if (IsPlayerInRangeOfPoint(playerid, 20.0, 2112.3240, -2432.8130, 13.5469)) { materialFactory = 4; }

    new mats = (materialFactory == 4) ? MatRun_Qty * 3 : MatRun_Qty;
    mats += MatRun_QtyPerLevel * GetJobLevel(playerid, JOB_FORKLIFT);
    if (PlayerData[playerid][pDonator] >= 3)
    {
        mats += MatRun_VIP3Bonus;
    }

    if (PlayerData[playerid][pMaterials] + mats > GetPlayerCapacity(playerid, CAPACITY_MATERIALS))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You currently have %i/%i materials. You can't carry anymore until you upgrade your inventory skill.", PlayerData[playerid][pMaterials], GetPlayerCapacity(playerid, CAPACITY_MATERIALS));
    }

    PlayerData[playerid][pSmuggleTime] = gettime();
    PlayerData[playerid][pSmuggleMats] = materialFactory;

    GivePlayerCash(playerid, -MatRun_Cost);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You paid %s for a load of materials. Smuggle them to the depot to get materials.", FormatCash(MatRun_Cost));
    switch (materialFactory)
    {
        case 1: SetActiveCheckpoint(playerid, CHECKPOINT_MATS, 2173.2129, -2264.1548, 13.3467, 3.0);
        case 2: SetActiveCheckpoint(playerid, CHECKPOINT_MATS, 2288.0918, -1105.6555, 37.9766, 3.0);
        case 3: SetActiveCheckpoint(playerid, CHECKPOINT_MATS, 29.0318,-1399.3555,1.7680, 20.0);
        case 4:
        {
            // get random checkpoint
            new rand = random(5);
            switch (rand)
            {
                case 0: { SetActiveCheckpoint(playerid, CHECKPOINT_MATS, -1368.1206, -203.7393, 14.1484, 30.0); }
                case 1: { SetActiveCheckpoint(playerid, CHECKPOINT_MATS,   310.8307, 2033.6459, 17.6406, 30.0); }
                case 2: { SetActiveCheckpoint(playerid, CHECKPOINT_MATS,   401.2192, 2502.6482, 16.4844, 30.0); }
                case 3: { SetActiveCheckpoint(playerid, CHECKPOINT_MATS,  1582.8756, 1356.8186, 10.8556, 30.0); }
                case 4: { SetActiveCheckpoint(playerid, CHECKPOINT_MATS,  1574.8552, 1505.5690, 10.8361, 30.0); }
            }
        }
    }
    return 1;
}

stock SendWeaponsCraftingCost(playerid)
{
    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_______ Weapons Crafting _______");

    if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 1)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Level 1: Bat [200], Shovel [200], Dildo [50], Flowers [50], Cane [200]");
        SendClientMessage(playerid, COLOR_WHITE, "Level 1: 9mm [1500], Sdpistol [2250], Shotgun [2500]");
        if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 2)
        {
            SendClientMessage(playerid, COLOR_WHITE, "Level 2: Uzi [3500], Rifle [8000]");
            if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 3)
            {
                SendClientMessage(playerid, COLOR_WHITE, "Level 3: PoolCue [200], AK-47 [5000], Tec-9 [4500], Deagle [5000]");
                if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 4)
                {
                    SendClientMessage(playerid, COLOR_WHITE, "Level 4: GolfClub [200], MP5 [5000], M4 [6000]");
                }
            }
        }
    }
    if (GetJobLevel(playerid, JOB_ARMSDEALER) >= 5 || PlayerData[playerid][pDonator] >= 3)
    {
        if (PlayerData[playerid][pDonator] >= 3)
        {
            SendClientMessage(playerid, COLOR_VIP, "(VIP){FFFFFF} Level 5: Katana [15000], Spas12 [10000], Sniper [10000]");
        }
        else
        {
            SendClientMessage(playerid, COLOR_WHITE, "Level 5: Katana [20000], Sniper [12000]");
        }
    }
}

CMD:sellgun(playerid, params[])
{
    new targetid, weapon[10], price;

    if (!PlayerHasJob(playerid, JOB_ARMSDEALER) && PlayerData[playerid][pDonator] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Arms Dealer.");
    }
    if (PlayerData[playerid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are either weapon restricted or you are less than level %d. You can't buy stuff here.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons from within a vehicle.");
    }
    if (sscanf(params, "us[10]I(0)", targetid, weapon, price))
    {
        SendWeaponsCraftingCost(playerid);
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellgun [playerid] [name] [price]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
    }
    if (gettime() - PlayerData[playerid][pLastSell] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use this command at the moment.");
    }
    if (price < 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $0.");
    }

    static weaponargs[][eCraftWeaponArgs] = {
        {/*Level*/ 1, "Bat",         5},
        {/*Level*/ 1, "Shovel",      6},
        {/*Level*/ 1, "Dildo",      10},
        {/*Level*/ 1, "Flowers",    14},
        {/*Level*/ 1, "Cane",       15},
        {/*Level*/ 1, "9mm",        22},
        {/*Level*/ 1, "Sdpistol",   23},
        {/*Level*/ 1, "Shotgun",    25},

        {/*Level*/ 2, "Uzi",        28},
        {/*Level*/ 2, "Rifle",      33},

        {/*Level*/ 3, "PoolCue",     7},
        {/*Level*/ 3, "AK-47",      30},
        {/*Level*/ 3, "Tec-9",      32},

        {/*Level*/ 3, "Deagle",     24},
        {/*Level*/ 4, "GolfClub",    2},
        {/*Level*/ 4, "MP5",        29},
        {/*Level*/ 4, "M4",         31},

        {/*Level*/ 5, "Katana",      8},
        {/*Level*/ 5, "Spas12",     27},
        {/*Level*/ 5, "Sniper",     34}
    };

    for (new i=0;i<sizeof(weaponargs);i++)
    {
        if (!strcmp(weapon, weaponargs[i][cwa_Name], true))
        {
            if (GetJobLevel(playerid, JOB_ARMSDEALER) < weaponargs[i][cwa_Level] && PlayerData[playerid][pDonator] != 3)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Your skill level is not high enough to craft this weapon.");
            }
            new weaponid = weaponargs[i][cwa_WeaponID];
            new cost = GetCraftWeaponPrice(playerid, weaponid);

            if (cost == -1)
            {
                return SendClientMessageEx(playerid, COLOR_AQUA, "You cannot craft this weapon {FF6347}%s{33CCFF}.", GetWeaponNameEx(weaponid));
            }
            if (IsMafiaWeapon(weaponid) && PlayerData[playerid][pDonator] != 3)
            {
                if (PlayerData[playerid][pGang] == -1 || !GangInfo[PlayerData[playerid][pGang]][gIsMafia])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Only mafia can craft this weapons.");
                }
            }
            if (PlayerData[playerid][pMaterials] < cost)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You don't have enough materials to craft this weapon.");
            }
            if (PlayerHasWeapon(targetid, weaponid))
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player has this weapon already.");
            }

            if (targetid == playerid)
            {
                SellWeapon(playerid, targetid, weaponid);
            }
            else if (price < 1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
            }
            else
            {
                PlayerData[playerid][pLastSell] = gettime();
                PlayerData[targetid][pSellOffer] = playerid;
                PlayerData[targetid][pSellType] = ITEM_SELLGUN;
                PlayerData[targetid][pSellExtra] = weaponid;
                PlayerData[targetid][pSellPrice] = price;

                SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you a %s for $%i. (/accept weapon)", GetRPName(playerid), GetWeaponNameEx(weaponid), price);
                SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s a %s for $%i.", GetRPName(targetid), GetWeaponNameEx(weaponid), price);
            }
        }
    }

    if (PlayerData[playerid][pGang] == -1 && GetPlayerFaction(playerid) != FACTION_HITMAN && GetPlayerFaction(playerid) != FACTION_TERRORIST)
    {
        GivePlayerRankPoints(playerid, -20);
    }
    else
    {
        GivePlayerRankPoints(playerid, 20);
    }
    return 1;
}

CMD:sellmats(playerid,params[])
{
    new targetid, amount, price;
    if (!PlayerHasJob(playerid, JOB_ARMSDEALER) && !PlayerHasJob(playerid, JOB_CRAFTMAN))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Craft Man or Arms Dealer.");
    }

    if (sscanf(params, "iii", targetid, amount, price))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sellmats [playerid] [amount] [price]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (amount < 1 || amount > PlayerData[playerid][pMaterials])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }
    if (price < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
    }

    PlayerData[playerid][pLastSell]  = gettime();
    PlayerData[targetid][pSellOffer] = playerid;
    PlayerData[targetid][pSellType]  = ITEM_MATERIALS;
    PlayerData[targetid][pSellExtra] = amount;
    PlayerData[targetid][pSellPrice] = price;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i materials for $%i. (/accept item)", GetRPName(playerid), amount, price);
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i materials for $%i.", GetRPName(targetid), amount, price);
    return 1;
}
