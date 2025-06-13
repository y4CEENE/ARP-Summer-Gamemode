/// @file      Damage.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum e_Damages
{
    damageTaken,
    damageWeapon,
    damageBodypart,
    damageArmor,
    damageTime,
    damageBy[90],
}
static PlayerText:Damage[MAX_PLAYERS];
static DamageData[MAX_PLAYERS][MAX_DAMAGES][e_Damages];
static totalDamages[MAX_PLAYERS];
static Float:WeaponDamages[47];


DB:OnLoadGunDamages()
{
    new rows = GetDBNumRows();
    new weaponid;

    for (new i = 0; i < rows; i ++)
    {
        weaponid = GetDBIntField(i, "Weapon");

        if (IsValidDamageWeapon(weaponid))
        {
            WeaponDamages[weaponid] = GetDBFloatField(i, "Damage");
        }
    }
}

Float:GetWeaponDamage(weaponid)
{
    if (IsValidDamageWeapon(weaponid))
        return WeaponDamages[weaponid];
    return 0.0;
}

stock GetPlayerTotalDamages(playerid)
{
    return totalDamages[playerid];
}

hook OnPlayerInit(playerid)
{
    for (new i = 0; i < MAX_DAMAGES; i++)
    {
        DamageData[playerid][i][damageTaken] = 0;
        DamageData[playerid][i][damageWeapon] = 0;
        DamageData[playerid][i][damageBy] = 0;
    }
    totalDamages[playerid] = 0;

    Damage[playerid] = CreatePlayerTextDraw(playerid, 198.000015, 382.874114, "Damage: You were shot by");
    PlayerTextDrawLetterSize(playerid, Damage[playerid], 0.213333, 1.110517);
    PlayerTextDrawAlignment(playerid, Damage[playerid], 1);
    PlayerTextDrawColor(playerid, Damage[playerid], -1);
    PlayerTextDrawSetShadow(playerid, Damage[playerid], 0);
    PlayerTextDrawSetOutline(playerid, Damage[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, Damage[playerid], 51);
    PlayerTextDrawFont(playerid, Damage[playerid], 1);
    PlayerTextDrawSetProportional(playerid, Damage[playerid], 1);
}

hook OnPlayerReset(playerid)
{
    totalDamages[playerid] = 0;
}

stock ClearDamages(playerid)
{
    for (new id = 0; id < MAX_DAMAGES; id++)
    {
        if (DamageData[playerid][id][damageTaken] != 0)
        {
            DamageData[playerid][id][damageTaken] = 0;
            DamageData[playerid][id][damageBodypart] = 0;
            DamageData[playerid][id][damageTime] = 0;
            DamageData[playerid][id][damageWeapon] = -1;
            DamageData[playerid][id][damageBy] = -1;
        }
    }

    totalDamages[playerid] = 0;
    PlayerData[playerid][pLegShot] = false;

    return true;
}

ReturnDamages(damaged, playerid)
{
    new str[400], longstr[2500], title[90], count = 0;

    format(title, sizeof(title), "%s", GetRPName(damaged));

    for (new id = 0; id < MAX_DAMAGES; id++)
    {
        if (DamageData[damaged][id][damageTaken] != 0)
        {
            count++;
        }
    }
    if (!count)
    {
        return Dialog_Show(playerid, 1, DIALOG_STYLE_LIST, title, "There are no damages to show.", ">>>", "");
    }
    else if (count > 0)
    {
        for (new id = 0; id < MAX_DAMAGES; id++)
        {
            if (DamageData[damaged][id][damageTaken] >= 1)
            {
                format(str, sizeof(str), "%d dmg from %s to %s (Kevlarhit: %d) %d s ago\n", DamageData[damaged][id][damageTaken], GetWeaponNameEx(DamageData[damaged][id][damageWeapon]), GetBodyPartName(DamageData[damaged][id][damageBodypart]), DamageData[damaged][id][damageArmor], gettime() - DamageData[damaged][id][damageTime]);
                strcat(longstr, str);
            }
        }
        Dialog_Show(playerid, 1, DIALOG_STYLE_LIST, title, longstr, ">>>", "");
    }
    return true;
}

ReturnDamagesAdmin(damaged, playerid)
{
    new str[400], longstr[2500], title[90], count = 0;

    format(title, sizeof(title), "%s", GetRPName(damaged));

    for (new id = 0; id < MAX_DAMAGES; id++)
    {
        if (DamageData[damaged][id][damageTaken] != 0) count++;
    }
    if (!count)return Dialog_Show(playerid, 1, DIALOG_STYLE_LIST, title, "There are no damages to show.", ">>>", "");
    else if (count > 0)
    {
        for (new id = 0; id < MAX_DAMAGES; id++)
        {
            if (DamageData[damaged][id][damageTaken] != 0)
            {
                format(str, sizeof(str), "{FF6346}(%s){FFFFFF} %d dmg from %s to %s (Kevlarhit: %d) %d s ago\n", DamageData[damaged][id][damageBy], DamageData[damaged][id][damageTaken], GetWeaponNameEx(DamageData[damaged][id][damageWeapon]), GetBodyPartName(DamageData[damaged][id][damageBodypart]), DamageData[damaged][id][damageArmor], gettime() - DamageData[damaged][id][damageTime]);
                strcat(longstr, str);
            }
        }
        Dialog_Show(playerid, 1, DIALOG_STYLE_LIST, title, longstr, ">>>", "");
    }
    return true;
}

ProcessDamage(playerid, weaponid)
{
    new
        Float:damage = WeaponDamages[weaponid],
        Float:health,
        Float:armor;

    if (damage != 0.0)
    {
        GetPlayerHealth(playerid, health);
        GetPlayerArmour(playerid, armor);

        if (armor >= damage)
        {
            armor -= damage;
        }
        else if (armor < damage)
        {
            health -= (damage - armor), armor = 0;
        }
        else if (health >= damage)
        {
            health -= damage;
        }
        else
        {
            health = 0;
        }

        SetPlayerHealth(playerid, health);
        SetPlayerArmour(playerid, armor);
    }
}
IsValidDamageWeapon(weaponid)
{
    if (!(0 <= weaponid <= 46))
        return false;

    switch (weaponid)
    {
        case 0, 19..21, WEAPON_DILDO..WEAPON_FLOWER, WEAPON_GRENADE..WEAPON_MOLTOV, WEAPON_ROCKETLAUNCHER..WEAPON_MINIGUN, WEAPON_SATCHEL..WEAPON_PARACHUTE:
            return false;
    }

    return true;
}

ShowWeaponDamageEditMenu(playerid)
{
    static
        string[512];

    string = "Weapon\tDamage";

    for (new i = 0; i < sizeof(WeaponDamages); i ++)
    {
        if (IsValidDamageWeapon(i))
        {
            if (WeaponDamages[i] != 0.0)
                format(string, sizeof(string), "%s\n%s\t%.1f%c", string, GetWeaponNameEx(i), WeaponDamages[i], '%');
            else
                format(string, sizeof(string), "%s\n%s\tDefault", string, GetWeaponNameEx(i));
        }
    }

    Dialog_Show(playerid, WeaponDamages, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Select Weapon", string, "Change", "Cancel");
}

SetWeaponDamage(weaponid, Float:damage) // Edited by Grime (09-27-2017)
{
    if (IsValidDamageWeapon(weaponid))
    {
        DBQuery("INSERT INTO rp_gundamages (Weapon, Damage) VALUES(%i, %.4f) ON DUPLICATE KEY UPDATE Damage = %.4f", weaponid, damage, damage);
        WeaponDamages[weaponid] = damage;
    }
}

AddDamages(playerid, issuerid, weaponid, bodypart, Float:amount)
{
    new id;

    totalDamages[playerid]++;

    for (new i = 0; i < MAX_DAMAGES; i++)
    {
        if (!DamageData[playerid][i][damageTaken])
        {
            id = i;
            break;
        }
    }

    new Float: Armour;
    GetPlayerArmour(playerid, Armour);

    if (Armour > 1 && bodypart == BODY_PART_CHEST)
    {
        DamageData[playerid][id][damageArmor] = 1;
    }
    else
    {
        DamageData[playerid][id][damageArmor] = 0;
    }

    DamageData[playerid][id][damageTaken] = floatround(amount, floatround_round);
    DamageData[playerid][id][damageWeapon] = weaponid;
    DamageData[playerid][id][damageBodypart] = bodypart;
    DamageData[playerid][id][damageTime] = gettime();
    format(DamageData[playerid][id][damageBy], 90, "%s", GetPlayerNameEx(issuerid));
    return true;
}


publish DestroyDamageTD(playerid)
{
    if (PlayerData[playerid][pDamageTimer] >= 0)
    {
        PlayerTextDrawHide(playerid, Damage[playerid]);
        PlayerData[playerid][pDamageTimer] = -1;
    }
}


Dialog:WeaponDamages(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new count;

        for (new i = 0; i < sizeof(WeaponDamages); i ++)
        {
            if (IsValidDamageWeapon(i))
            {
                if (count++ == listitem)
                {
                    PlayerData[playerid][pSelected] = i;
                    return Dialog_Show(playerid, SetDamage, DIALOG_STYLE_INPUT, "{FFFFFF}Set Damage", "Please enter the weapon damage to set for %s (use 0 for default).", "Submit", "Back", GetWeaponNameEx(PlayerData[playerid][pSelected]));
                }
            }
        }
    }
    return 1;
}

Dialog:SetDamage(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new Float:damage;

        if (sscanf(inputtext, "f", damage))
        {
            return Dialog_Show(playerid, SetDamage, DIALOG_STYLE_INPUT, "{FFFFFF}Set Damage", "Please enter the weapon damage to set for %s (use 0 for default).", "Submit", "Back", GetWeaponNameEx(PlayerData[playerid][pSelected]));
        }
        else if (damage < 0.0 || damage > 100.0)
        {
            return Dialog_Show(playerid, SetDamage, DIALOG_STYLE_INPUT, "{FFFFFF}Set Damage", "The specified damage can't be below 0 or above 100.\n\nPlease enter the weapon damage to set for %s (use 0 for default).", "Submit", "Back", GetWeaponNameEx(PlayerData[playerid][pSelected]));
        }
        else
        {
            new weaponid = PlayerData[playerid][pSelected];

            SetWeaponDamage(weaponid, damage);

            if (damage == 0.0)
            {
                SendAdminMessage(COLOR_ADM, "Admin: %s has set the damage for %s to default.", GetRPName(playerid), GetWeaponNameEx(weaponid));
            }
            else
            {
                SendAdminMessage(COLOR_ADM, "Admin: %s has set the damage for %s to %.1f.", GetRPName(playerid), GetWeaponNameEx(weaponid), damage);
            }
        }
    }
    else
    {
        ShowWeaponDamageEditMenu(playerid);
    }
    return 1;
}

ShowDamageString(playerid, const string[])
{
    PlayerTextDrawSetString(playerid, Damage[playerid], string);
    PlayerTextDrawShow(playerid, Damage[playerid]);
    PlayerPlaySound(playerid, 17802, 0.0, 0.0, 15.0);
    KillTimer(PlayerData[playerid][pDamageTimer]);
    PlayerData[playerid][pDamageTimer] = SetTimerEx("DestroyDamageTD", 1500, false, "i", playerid);
}


DB:OnAdminListDamages(playerid, targetid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "That player hasn't been damaged by anyone since they connected.");
    }
    else
    {
        SendClientMessage(playerid, COLOR_NAVYBLUE, "___________ Damage Received ___________");

        for (new i = 0; i < rows; i ++)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "[%i seconds ago] %s was shot by %s with a %s", gettime() - GetDBIntFieldFromIndex(i, 2), GetRPName(targetid), GetRPName(GetDBIntFieldFromIndex(i, 1)), GetWeaponNameEx(GetDBIntFieldFromIndex(i, 0)));
            //SendClientMessageEx(playerid, COLOR_GREY2, "(Weapon: %s) - (From: %s) - (Time: %i seconds ago)", GetWeaponNameEx(GetDBIntFieldFromIndex(i, 0)), GetRPName(GetDBIntFieldFromIndex(i, 1)), gettime() - GetDBIntFieldFromIndex(i, 2));
        }
    }
}

CMD:setdamages(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else
    {
        ShowWeaponDamageEditMenu(playerid);
    }
    return 1;
}

CMD:shots(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /shots [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT * FROM shots WHERE playerid = %i ORDER BY id DESC LIMIT 20", targetid);
    DBExecute("OnAdminListShots", "ii", playerid, targetid);
    return 1;
}
CMD:damages(playerid, params[])
{
    new playerb;

    if (sscanf(params, "u", playerb))return SendClientMessage(playerid, COLOR_ADM, "USAGE:{FFFFFF} /damages [playerid/PartofName]");
    if (!IsPlayerConnected(playerb))return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You have specified an invalid player.");
    if (PlayerData[playerid][pAdminDuty])
    {
        ReturnDamagesAdmin(playerb, playerid);
    }
    else{

        if (!IsPlayerNearPlayer(playerid, playerb, 5.0)) return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You must be closer to that player.");
        ReturnDamages(playerb, playerid);
    }
    return true;
}
CMD:adamages(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /damages [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT weaponid, playerid, timestamp FROM shots WHERE hitid = %i AND hittype = 1 ORDER BY id DESC LIMIT 20", targetid);
    DBExecute("OnAdminListDamages", "ii", playerid, targetid);
    return 1;
}

CMD:kills(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /kills [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    DBFormat("SELECT * FROM kills WHERE killer_uid = %i OR target_uid = %i ORDER BY date DESC LIMIT 20", PlayerData[targetid][pID], PlayerData[targetid][pID]);
    DBExecute("OnAdminListKills", "ii", playerid, targetid);
    return 1;
}
