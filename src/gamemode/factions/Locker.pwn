/// @file      Locker.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

/*
gotolocker **
fpark **
factionkick
switchfaction **
editfaction
purgefaction **
"/factionpay" and "/faction edit" are the same
*/

CMD:createlocker(playerid, params[])
{
    new factionid, Float:x, Float:y, Float:z;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", factionid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createlocker [factionid]");
    }
    if (!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
    }

    GetPlayerPos(playerid, x, y, z);

    for (new i = 0; i < MAX_LOCKERS; i ++)
    {
        if (!LockerInfo[i][lExists])
        {
            DBFormat("INSERT INTO factionlockers (factionid, pos_x, pos_y, pos_z, interior, world) VALUES(%i, '%f', '%f', '%f', %i, %i)", factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            DBExecute("OnAdminCreateLocker", "iiifffii", playerid, i, factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Locker slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:editlocker(playerid, params[])
{
    new lockerid, option[32], param[32];

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[32]S()[32]", lockerid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [option]");
        SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Position, FactionID, Icon, Label, Weapons");
        return 1;
    }
    if (!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
    }
    if (!strcmp(option, "position", true))
    {
        GetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
        LockerInfo[lockerid][lInterior] = GetPlayerInterior(playerid);
        LockerInfo[lockerid][lWorld] = GetPlayerVirtualWorld(playerid);

        DBQuery("UPDATE factionlockers SET pos_x = '%f', pos_y = '%f', pos_z = '%f', interior = %i, world = %i WHERE id = %i", LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], LockerInfo[lockerid][lInterior], LockerInfo[lockerid][lWorld], LockerInfo[lockerid][lID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You have moved locker %i to your position.", lockerid);
        ReloadLocker(lockerid);
    }
    else if (!strcmp(option, "factionid", true))
    {
        new value;
        if (sscanf(param, "i", value))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /editlocker [%i] [%s] [value]", lockerid, option);
        }
        LockerInfo[lockerid][lFaction] = value;
        DBQuery("UPDATE factionlockers SET factionid = %i WHERE id = %i", LockerInfo[lockerid][lFaction], LockerInfo[lockerid][lID]);

        SendClientMessageEx(playerid, COLOR_AQUA, "* You set locker %i's faction to %i.", lockerid, value);
        ReloadLocker(lockerid);
    }
    else if (!strcmp(option, "icon", true))
    {
        new iconid;

        if (sscanf(param, "i", iconid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [icon] [iconid (19300 = hide)]");
        }
        if (!IsValidModel(iconid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID.");
        }

        LockerInfo[lockerid][lIcon] = iconid;

        DBQuery("UPDATE factionlockers SET iconid = %i WHERE id = %i", LockerInfo[lockerid][lIcon], LockerInfo[lockerid][lID]);

        ReloadLocker(lockerid);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You've changed the pickup icon model of locker %i to %i.", lockerid, iconid);
    }
    else if (!strcmp(option, "label", true))
    {
        new status;

        if (sscanf(param, "i", status) || !(0 <= status <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [label] [0/1]");
        }

        LockerInfo[lockerid][lLabel] = status;

        DBQuery("UPDATE factionlockers SET label = %i WHERE id = %i", LockerInfo[lockerid][lLabel], LockerInfo[lockerid][lID]);

        ReloadLocker(lockerid);

        if (status)
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've enabled the 3D text label for locker %i.", lockerid);
        else
            SendClientMessageEx(playerid, COLOR_AQUA, "* You've disabled the 3D text label for locker %i.", lockerid);
    }
    else if (!strcmp(option, "weapons", true))
    {
        if (FactionInfo[LockerInfo[lockerid][lFaction]][fType] == FACTION_HITMAN)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Weapons for hitman agency lockers cannot be edited in-game.");
        }
        new inputtext[24], opt2[8], amount;
        if (sscanf(param, "s[24]s[8]i", inputtext, opt2, amount))
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /editlocker [lockerid] [weapons] [weaponname] [option] [amount]");
            SendClientMessage(playerid, COLOR_GREEN, "Weapon Name: Kevlar, Medkit, Nitestick, Mace, Deagle, Shotgun, M4, MP5, Spas12, Sniper, Camera, FireExt, Painkillers");
            SendClientMessage(playerid, COLOR_YELLOW, "Options: Allow, Price");
            SendClientMessage(playerid, COLOR_ORANGE, "Amount: Price (amount), Allow (1 or 0)");
            return 1;
        }
        if (!strcmp(opt2, "allow", true))
        {
            if (!(0 <= amount <= 1)) return SendClientMessage(playerid, COLOR_GREY, "Amount can be 1 or 0");
            if (!strcmp(inputtext, "Kevlar", true))
            {
                LockerInfo[lockerid][locKevlar][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_kevlar = %i WHERE id = %i", LockerInfo[lockerid][locKevlar][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Medkit", true))
            {
                LockerInfo[lockerid][locMedKit][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_medkit = %i WHERE id = %i", LockerInfo[lockerid][locMedKit][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Nitestick", true))
            {
                LockerInfo[lockerid][locNitestick][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_nitestick = %i WHERE id = %i", LockerInfo[lockerid][locNitestick][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Mace", true))
            {
                LockerInfo[lockerid][locMace][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_mace = %i WHERE id = %i", LockerInfo[lockerid][locMace][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Deagle", true))
            {
                LockerInfo[lockerid][locDeagle][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_deagle = %i WHERE id = %i", LockerInfo[lockerid][locDeagle][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Shotgun", true))
            {
                LockerInfo[lockerid][locShotgun][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_shotgun = %i WHERE id = %i", LockerInfo[lockerid][locShotgun][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "MP5", true))
            {
                LockerInfo[lockerid][locMP5][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_mp5 = %i WHERE id = %i", LockerInfo[lockerid][locMP5][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "M4", true))
            {
                LockerInfo[lockerid][locM4][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_m4 = %i WHERE id = %i", LockerInfo[lockerid][locM4][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Spas12", true))
            {
                LockerInfo[lockerid][locSpas12][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_spas12 = %i WHERE id = %i", LockerInfo[lockerid][locSpas12][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Sniper", true))
            {
                LockerInfo[lockerid][locSniper][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_sniper = %i WHERE id = %i", LockerInfo[lockerid][locSniper][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Camera", true))
            {
                LockerInfo[lockerid][locCamera][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_camera = %i WHERE id = %i", LockerInfo[lockerid][locCamera][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "FireExt", true))
            {
                LockerInfo[lockerid][locFireExt][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_fire_extinguisher = %i WHERE id = %i", LockerInfo[lockerid][locFireExt][0], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Painkillers", true))
            {
                LockerInfo[lockerid][locPainKillers][0] = amount;
                DBQuery("UPDATE factionlockers SET weapon_painkillers = %i WHERE id = %i", LockerInfo[lockerid][locPainKillers][0], LockerInfo[lockerid][lID]);
            }
            SendClientMessageEx(playerid, COLOR_GREY, "Locker %i's %s status set to %i", lockerid, inputtext, amount);
        }
        else if (!strcmp(opt2, "price", true))
        {
            if (!strcmp(inputtext, "Kevlar", true))
            {
                LockerInfo[lockerid][locKevlar][1] = amount;
                DBQuery("UPDATE factionlockers SET price_kevlar = %i WHERE id = %i", LockerInfo[lockerid][locKevlar], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Medkit", true))
            {
                LockerInfo[lockerid][locMedKit][1] = amount;
                DBQuery("UPDATE factionlockers SET price_medkit = %i WHERE id = %i", LockerInfo[lockerid][locMedKit], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Nitestick", true))
            {
                LockerInfo[lockerid][locNitestick][1] = amount;
                DBQuery("UPDATE factionlockers SET price_nitestick = %i WHERE id = %i", LockerInfo[lockerid][locNitestick][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Mace", true))
            {
                LockerInfo[lockerid][locMace][1] = amount;
                DBQuery("UPDATE factionlockers SET price_mace = %i WHERE id = %i", LockerInfo[lockerid][locMace][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Deagle", true))
            {
                LockerInfo[lockerid][locDeagle][1] = amount;
                DBQuery("UPDATE factionlockers SET price_deagle = %i WHERE id = %i", LockerInfo[lockerid][locDeagle][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Shotgun", true))
            {
                LockerInfo[lockerid][locShotgun][1] = amount;
                DBQuery("UPDATE factionlockers SET price_shotgun = %i WHERE id = %i", LockerInfo[lockerid][locShotgun][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "MP5", true))
            {
                LockerInfo[lockerid][locMP5][1] = amount;
                DBQuery("UPDATE factionlockers SET price_mp5 = %i WHERE id = %i", LockerInfo[lockerid][locMP5][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "M4", true))
            {
                LockerInfo[lockerid][locM4][1] = amount;
                DBQuery("UPDATE factionlockers SET price_m4 = %i WHERE id = %i", LockerInfo[lockerid][locM4][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Spas12", true))
            {
                LockerInfo[lockerid][locSpas12][1] = amount;
                DBQuery("UPDATE factionlockers SET price_spas12 = %i WHERE id = %i", LockerInfo[lockerid][locSpas12][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Sniper", true))
            {
                LockerInfo[lockerid][locSniper][1] = amount;
                DBQuery("UPDATE factionlockers SET price_sniper = %i WHERE id = %i", LockerInfo[lockerid][locSniper][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Camera", true))
            {
                LockerInfo[lockerid][locCamera][1] = amount;
                DBQuery("UPDATE factionlockers SET price_camera = %i WHERE id = %i", LockerInfo[lockerid][locCamera][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "FireExt", true))
            {
                LockerInfo[lockerid][locFireExt][1] = amount;
                DBQuery("UPDATE factionlockers SET price_fire_extinguisher = %i WHERE id = %i", LockerInfo[lockerid][locFireExt][1], LockerInfo[lockerid][lID]);
            }
            else if (!strcmp(inputtext, "Painkillers", true))
            {
                LockerInfo[lockerid][locPainKillers][1] = amount;
                DBQuery("UPDATE factionlockers SET price_painkillers = %i WHERE id = %i", LockerInfo[lockerid][locPainKillers][1], LockerInfo[lockerid][lID]);
            }
            SendClientMessageEx(playerid, COLOR_GREY, "Locker %i's %s price set to %i", lockerid, inputtext, amount);
        }
    }
    return 1;
}

CMD:removelocker(playerid, params[])
{
    new lockerid;
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "i", lockerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removelocker [lockerid]");
    }
    if (!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
    }

    DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
    DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);

    DBQuery("DELETE FROM factionlockers WHERE id = %i", LockerInfo[lockerid][lID]);

    LockerInfo[lockerid][lExists] = 0;
    LockerInfo[lockerid][lID] = 0;

    SendClientMessageEx(playerid, COLOR_AQUA, "* You have removed locker %i.", lockerid);
    return 1;
}

CMD:gotolocker(playerid, params[])
{
    new lockerid;

    if (!PlayerData[playerid][pFactionMod] && !IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }
    if (!PlayerData[playerid][pAdminDuty] && !IsGodAdmin(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", lockerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotolocker [lockerid]");
    }
    if (!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
    SetPlayerInterior(playerid, LockerInfo[lockerid][lInterior]);
    SetPlayerVirtualWorld(playerid, LockerInfo[lockerid][lWorld]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:locker(playerid, params[])
{
    if (PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
    }
    if (!IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of any of your faction lockers.");
    }

    switch (FactionInfo[PlayerData[playerid][pFaction]][fType])
    {
        case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY:
        {
            Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Toggle duty\nEquipment\nUniforms\nClothing", "Select", "Cancel");
        }
        case FACTION_MEDIC:
        {
            Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Toggle duty\nEquipment\nUniforms", "Select", "Cancel");
        }
        case FACTION_GOVERNMENT, FACTION_NEWS:
        {
            Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "Locker", "Equipment\nUniforms", "Select", "Cancel");
        }
    }

    return 1;
}

GetNearbyLocker(playerid)
{
    for (new i = 0; i < MAX_LOCKERS; i ++)
    {
        if (LockerInfo[i][lExists] && IsPlayerNearPoint(playerid, 3.0, LockerInfo[i][lPosX], LockerInfo[i][lPosY], LockerInfo[i][lPosZ], LockerInfo[i][lInterior], LockerInfo[i][lWorld]))
        {
            return i;
        }
    }

    return -1;
}

ReloadLockers(factionid)
{
    for (new i = 0; i < MAX_LOCKERS; i ++)
    {
        if (LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
        {
            ReloadLocker(i);
        }
    }
}

ReloadLocker(lockerid)
{
    if (LockerInfo[lockerid][lExists])
    {
        DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
        DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);
        if (LockerInfo[lockerid][lLabel])
        {
            new string[128];
            if (FactionInfo[LockerInfo[lockerid][lFaction]][fType] == FACTION_HITMAN)
                format(string, sizeof(string), "%s\nBlack market access\n/order to access black market.", FactionInfo[LockerInfo[lockerid][lFaction]][fName]);
            else format(string, sizeof(string), "%s\nLocker access\n/locker to access locker.", FactionInfo[LockerInfo[lockerid][lFaction]][fName]);
            LockerInfo[lockerid][lText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], 10.0, .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
        }
        LockerInfo[lockerid][lPickup] = CreateDynamicPickup(LockerInfo[lockerid][lIcon], 1, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
    }
}


Dialog:DIALOG_FACTIONLOCKER(playerid, response, listitem, inputtext[])
{
    if ((response) && PlayerData[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
    {
        switch (FactionInfo[PlayerData[playerid][pFaction]][fType])
        {
            case FACTION_POLICE, FACTION_MEDIC, FACTION_FEDERAL, FACTION_ARMY:
            {
                if (listitem == 0) // Toggle duty
                {
                    if (!PlayerData[playerid][pDuty])
                    {
                        if (IsLawEnforcement(playerid))
                        {
                            ShowActionBubble(playerid, "* %s clocks in and grabs their police issued equipment from the locker.", GetRPName(playerid));
                            SendClientMessage(playerid, COLOR_AQUA, "* You clocked in and grabs your police issued equipment from the locker.");
                        }
                        else if (FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_MEDIC)
                        {
                            ShowActionBubble(playerid, "* %s clocks in and grabs their medical supplies from the locker.", GetRPName(playerid));
                            SendClientMessage(playerid, COLOR_AQUA, "* You clocked in and grabs your medical supplies from the locker.");
                        }

                        PlayerData[playerid][pDuty] = 1;

                        SetPlayerHealth(playerid, 100.0);
                        SetScriptArmour(playerid, 100.0);
                    }
                    else
                    {
                        PlayerData[playerid][pDuty] = 0;
                        ResetPlayerWeaponsEx(playerid);

                        SetScriptArmour(playerid, 0.0);
                        ShowActionBubble(playerid, "* %s clocks out and puts their equipment back in the locker.", GetRPName(playerid));
                        SendClientMessage(playerid, COLOR_AQUA, "* You clocked out and put your equipment back in the locker.");
                    }
                }
                else if (listitem == 1) // Equipment
                {
                    if (!PlayerHasLicense(playerid, PlayerLicense_Gun))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use your faction equipment as you don't have a gun license.");
                    }
                    ShowDialogToPlayer(playerid, DIALOG_FACTIONEQUIPMENT);
                    /*if (IsLawEnforcement(playerid))
                    {
                        Dialog_Show(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nNitestick\nSpraycan\nDesert Eagle\nShotgun\nMP5\nM4\nSPAS-12\nSniper Rifle", "Select", "Cancel");
                    }
                    else
                    {
                        Dialog_Show(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nFire Extinguisher\nDesert Eagle\nPainkillers", "Select", "Cancel");
                    }*/
                }
                else if (listitem == 2) // Uniforms
                {
                    if (!GetFactionSkinCount(PlayerData[playerid][pFaction]))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "There are no uniforms setup for your faction.");
                    }
                    if (PlayerData[playerid][pClothes] >= 0)
                    {
                        PlayerData[playerid][pSkin] = PlayerData[playerid][pClothes];
                        PlayerData[playerid][pClothes] = -1;

                        DBQuery("UPDATE "#TABLE_USERS" SET skin = %i, clothes = -1 WHERE uid = %i", PlayerData[playerid][pSkin], PlayerData[playerid][pID]);

                        SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
                        ShowActionBubble(playerid, "* %s switches back to their old outfit.", GetRPName(playerid));
                    }
                    else
                    {
                        PlayerData[playerid][pSkinSelected] = -1;
                        Dialog_Show(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press {00AA00}>> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
                    }
                }
                else if (listitem == 3 && FactionInfo[PlayerData[playerid][pFaction]][fType] != FACTION_MEDIC)
                {
                    ShowCopClothingMenu(playerid);
                }
            }
            case FACTION_GOVERNMENT, FACTION_NEWS:
            {
                if (!PlayerHasLicense(playerid, PlayerLicense_Gun))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You cannot use your faction equipment as you don't have a gun license.");
                }
                if (listitem == 0) // Equipment
                {
                    ShowDialogToPlayer(playerid, DIALOG_FACTIONEQUIPMENT);
                    /*if (FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_GOVERNMENT)
                    {
                        Dialog_Show(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nDesert Eagle\nShotgun\nMP5\nM4\nSPAS-12", "Select", "Cancel");
                    }
                    else
                    {
                        Dialog_Show(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Kevlar Vest\nMedkit\nCamera", "Select", "Cancel");
                    }*/
                }
                else if (listitem == 1) // Uniforms
                {
                    if (!GetFactionSkinCount(PlayerData[playerid][pFaction]))
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "There are no uniforms setup for your faction.");
                    }
                    if (PlayerData[playerid][pClothes] >= 0)
                    {
                        PlayerData[playerid][pSkin] = PlayerData[playerid][pClothes];
                        PlayerData[playerid][pClothes] = -1;

                        DBQuery("UPDATE "#TABLE_USERS" SET skin = %i, clothes = -1 WHERE uid = %i", PlayerData[playerid][pSkin], PlayerData[playerid][pID]);

                        ShowActionBubble(playerid, "* %s switches back to their old outfit.", GetRPName(playerid));
                    }
                    else
                    {
                        PlayerData[playerid][pSkinSelected] = -1;
                        Dialog_Show(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press {00AA00}>> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
                    }
                }
            }
            case FACTION_HITMAN:
            {
                if (!PlayerHasLicense(playerid, PlayerLicense_Gun))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You cannot use your faction equipment as you don't have a gun license.");
                }
                if (listitem == 0) // Order weapons
                {
                    Dialog_Show(playerid, DIALOG_FACTIONEQUIPMENT, DIALOG_STYLE_LIST, "Order weapons", "Kevlar Vest ($100)\nKnife ($100)\nShotgun ($150)\nDesert Eagle ($200)\nMP5 ($250)\nM4 ($600)\nSniper rifle ($1,000)\nBomb ($2,500)", "Order", "Cancel");
                }
                else if (listitem == 1) // Change clothes
                {
                    Dialog_Show(playerid, DIALOG_HITMANCLOTHES, DIALOG_STYLE_INPUT, "Change clothes", "Please input the ID of the skin you wish to purchase.\n(( List of skins: http://wiki.sa-mp.com/wiki/Skins:All ))", "Submit", "Cancel");
                }
            }
        }
    }
    return 1;
}


Dialog:DIALOG_FACTIONEQUIPMENT(playerid, response, listitem, inputtext[])
{
    if ((response) && PlayerData[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
    {
        switch (FactionInfo[PlayerData[playerid][pFaction]][fType])
        {
            /*case FACTION_POLICE, FACTION_FEDERAL, FACTION_ARMY:
            {
                switch (listitem)
                {
                    case 0:
                    {
                        SetScriptArmour(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
                    }
                    case 1:
                    {
                        SetPlayerHealth(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
                    }
                    case 2:
                    {
                        GivePlayerWeaponEx(playerid, 3);
                        ShowActionBubble(playerid, "* %s grabs a nitestick from the locker.", GetRPName(playerid));
                    }
                    case 3:
                    {
                        GivePlayerWeaponEx(playerid, 41);
                        ShowActionBubble(playerid, "* %s grabs a can of pepper spray from the locker.", GetRPName(playerid));
                    }
                    case 4:
                    {
                        GivePlayerWeaponEx(playerid, 24);
                        ShowActionBubble(playerid, "* %s grabs a Desert Eagle from the locker.", GetRPName(playerid));
                    }
                    case 5:
                    {
                        GivePlayerWeaponEx(playerid, 25);
                        ShowActionBubble(playerid, "* %s grabs a Shotgun from the locker.", GetRPName(playerid));
                    }
                    case 6:
                    {
                        GivePlayerWeaponEx(playerid, 29);
                        ShowActionBubble(playerid, "* %s grabs an MP5 from the locker.", GetRPName(playerid));
                    }
                    case 7:
                    {
                        GivePlayerWeaponEx(playerid, 31);
                        ShowActionBubble(playerid, "* %s grabs an M4 from the locker.", GetRPName(playerid));
                    }
                    case 8:
                    {
                        GivePlayerWeaponEx(playerid, 27);
                        ShowActionBubble(playerid, "* %s grabs a SPAS-12 from the locker.", GetRPName(playerid));
                    }
                    case 9:
                    {
                        GivePlayerWeaponEx(playerid, 34);
                        ShowActionBubble(playerid, "* %s grabs a Sniper Rifle from the locker.", GetRPName(playerid));
                    }
                }
            }
            case FACTION_MEDIC:
            {
                switch (listitem)
                {
                    case 0:
                    {
                        SetScriptArmour(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
                    }
                    case 1:
                    {
                        SetPlayerHealth(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
                    }
                    case 2:
                    {
                        GivePlayerWeaponEx(playerid, 42);
                        ShowActionBubble(playerid, "* %s grabs a fire extinguisher from the locker.", GetRPName(playerid));
                    }
                    case 3:
                    {
                        GivePlayerWeaponEx(playerid, 24);
                        ShowActionBubble(playerid, "* %s grabs a Desert Eagle from the locker.", GetRPName(playerid));
                    }
                    case 4:
                    {
                        PlayerData[playerid][pPainkillers] = 5;
                        ShowActionBubble(playerid, "* %s grabs a five pack of painkillers from the locker.", GetRPName(playerid));

                        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);
                    }
                }
            }
            case FACTION_GOVERNMENT:
            {
                switch (listitem)
                {
                    case 0:
                    {
                        SetScriptArmour(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
                    }
                    case 1:
                    {
                        SetPlayerHealth(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
                    }
                    case 2:
                    {
                        GivePlayerWeaponEx(playerid, 24);
                        ShowActionBubble(playerid, "* %s grabs a Desert Eagle from the locker.", GetRPName(playerid));
                    }
                    case 3:
                    {
                        GivePlayerWeaponEx(playerid, 25);
                        ShowActionBubble(playerid, "* %s grabs a Shotgun from the locker.", GetRPName(playerid));
                    }
                    case 4:
                    {
                        GivePlayerWeaponEx(playerid, 29);
                        ShowActionBubble(playerid, "* %s grabs an MP5 from the locker.", GetRPName(playerid));
                    }
                    case 5:
                    {
                        GivePlayerWeaponEx(playerid, 31);
                        ShowActionBubble(playerid, "* %s grabs an M4 from the locker.", GetRPName(playerid));
                    }
                    case 6:
                    {
                        GivePlayerWeaponEx(playerid, 27);
                        ShowActionBubble(playerid, "* %s grabs a SPAS-12 from the locker.", GetRPName(playerid));
                    }
                    case 7:
                    {
                        GivePlayerWeaponEx(playerid, 34);
                        ShowActionBubble(playerid, "* %s grabs a Sniper Rifle from the locker.", GetRPName(playerid));
                    }
                }
            }
            case FACTION_NEWS:
            {
                switch (listitem)
                {
                    case 0:
                    {
                        SetScriptArmour(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a kevlar vest from the locker and puts it on.", GetRPName(playerid));
                    }
                    case 1:
                    {
                        SetPlayerHealth(playerid, 100.0);
                        ShowActionBubble(playerid, "* %s grabs a medkit from the locker and opens it.", GetRPName(playerid));
                    }
                    case 2:
                    {
                        GivePlayerWeaponEx(playerid, 43);
                        ShowActionBubble(playerid, "* %s grabs a digital camera from the locker.", GetRPName(playerid));
                    }
                }
            }*/
            case FACTION_HITMAN:
            {
                switch (listitem)
                {
                    case 0:
                    {
                        if (PlayerData[playerid][pCash] < 100)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerCash(playerid, -100);
                        SetScriptArmour(playerid, 100.0);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a kevlar vest for $100.");
                        GameTextForPlayer(playerid, "~r~-$100", 5000, 1);
                    }
                    case 1:
                    {
                        if (PlayerData[playerid][pCash] < 100)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerWeaponEx(playerid, 4);
                        GivePlayerCash(playerid, -100);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a knife for $100.");
                        GameTextForPlayer(playerid, "~r~-$100", 5000, 1);
                    }
                    case 2:
                    {
                        if (PlayerData[playerid][pCash] < 150)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerWeaponEx(playerid, 25);
                        GivePlayerCash(playerid, -150);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a shotgun for $150.");
                        GameTextForPlayer(playerid, "~r~-$150", 5000, 1);
                    }
                    case 3:
                    {
                        if (PlayerData[playerid][pCash] < 200)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerWeaponEx(playerid, 24);
                        GivePlayerCash(playerid, -200);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a Desert Eagle for $200.");
                        GameTextForPlayer(playerid, "~r~-$200", 5000, 1);
                    }
                    case 4:
                    {
                        if (PlayerData[playerid][pCash] < 250)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerWeaponEx(playerid, 29);
                        GivePlayerCash(playerid, -250);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered an MP5 for $250.");
                        GameTextForPlayer(playerid, "~r~-$250", 5000, 1);
                    }
                    case 5:
                    {
                        if (PlayerData[playerid][pCash] < 600)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerWeaponEx(playerid, 31);
                        GivePlayerCash(playerid, -600);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered an M4 for $600.");
                        GameTextForPlayer(playerid, "~r~-$600", 5000, 1);
                    }
                    case 6:
                    {
                        if (PlayerData[playerid][pCash] < 1000)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }

                        GivePlayerWeaponEx(playerid, 34);
                        GivePlayerCash(playerid, -1000);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a sniper rifle for $1,000.");
                        GameTextForPlayer(playerid, "~r~-$1000", 5000, 1);
                    }
                    case 7:
                    {
                        if (PlayerData[playerid][pFactionRank]<4)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You need to be rank 4 to order a bomb.");
                        }
                        if (PlayerData[playerid][pCash] < 2500)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                        }
                        if (PlayerData[playerid][pBombs] > 3)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "You have more than 3 bombs. You can't buy anymore.");
                        }

                        PlayerData[playerid][pBombs]++;
                        GivePlayerCash(playerid, -2500);

                        DBQuery("UPDATE "#TABLE_USERS" SET bombs = %i WHERE uid = %i", PlayerData[playerid][pBombs], PlayerData[playerid][pID]);

                        SendClientMessageEx(playerid, COLOR_AQUA, "* You ordered a bomb for $2,500. /plantbomb to place the bomb.");
                        GameTextForPlayer(playerid, "~r~-$2500", 5000, 1);
                    }
                }
            }
            default:
            {
                new amount, weapon, locker = GetNearbyLocker(playerid);
                if (strfind(inputtext, "Kevlar Vest", true) != -1)
                {
                    amount = LockerInfo[locker][locKevlar][1];
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    SetScriptArmour(playerid, 100.0);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a kevlar vest for $%i.", amount);
                }
                else if (strfind(inputtext, "Medkit", true) != -1)
                {
                    amount = LockerInfo[locker][locMedKit][1];
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    SetPlayerHealth(playerid, 100.0);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a medkit for $%i.", amount);
                }
                else if (strfind(inputtext, "Nitestick", true) != -1)
                {
                    amount = LockerInfo[locker][locNitestick][1]; weapon = 3;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Mace", true) != -1)
                {
                    amount = LockerInfo[locker][locMace][1]; weapon = 41;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Deagle", true) != -1)
                {
                    amount = LockerInfo[locker][locDeagle][1]; weapon = 24;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Shotgun", true) != -1)
                {
                    amount = LockerInfo[locker][locShotgun][1]; weapon = 25;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "MP5", true) != -1)
                {
                    amount = LockerInfo[locker][locMP5][1]; weapon = 29;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "M4", true) != -1)
                {
                    amount = LockerInfo[locker][locM4][1]; weapon = 31;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "SPAS-12", true) != -1)
                {
                    amount = LockerInfo[locker][locSpas12][1]; weapon = 27;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Sniper", true) != -1)
                {
                    amount = LockerInfo[locker][locSniper][1]; weapon = 34;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Camera", true) != -1)
                {
                    amount = LockerInfo[locker][locCamera][1]; weapon = 43;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Fire Extinguisher", true) != -1)
                {
                    amount = LockerInfo[locker][locFireExt][1]; weapon = 42;
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    GivePlayerWeaponEx(playerid, weapon);
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received a %s for $%i.", GetWeaponNameEx(weapon), amount);
                }
                else if (strfind(inputtext, "Painkillers", true) != -1)
                {
                    amount = LockerInfo[locker][locPainKillers][1];
                    if (PlayerData[playerid][pCash] < amount)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't afford this weapon.");
                    }

                    PlayerData[playerid][pPainkillers] = 20;
                    GivePlayerCash(playerid, -amount);

                    SendClientMessageEx(playerid, COLOR_AQUA, "* You received painkillers for $%i.", amount);
                }
            }
        }
    }
    return 1;
}

Dialog:DIALOG_FACTIONSKINS(playerid, response, listitem, inputtext[])
{
    if (PlayerData[playerid][pFaction] >= 0 && IsPlayerInRangeOfLocker(playerid, PlayerData[playerid][pFaction]))
    {
        if (response)
        {
            new index = PlayerData[playerid][pSkinSelected] + 1;

            if (index >= MAX_FACTION_SKINS)
            {
                // When the player is shown the dialog for the first time, their skin isn't changed until they click >> Next.
                SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
                PlayerData[playerid][pSkinSelected] = -1;
            }
            else
            {
                // Find the next skin in the array.
                for (new i = index; i < MAX_FACTION_SKINS; i ++)
                {
                    if (FactionInfo[PlayerData[playerid][pFaction]][fSkins][i] != 0)
                    {
                        SetPlayerSkin(playerid, FactionInfo[PlayerData[playerid][pFaction]][fSkins][i]);
                        PlayerData[playerid][pSkinSelected] = i;
                        break;
                    }
                }

                if (index == PlayerData[playerid][pSkinSelected] + 1)
                {
                    // Looks like there was no skin found. So, we'll go back to the very first valid skin in the skin array.
                    for (new i = 0; i < MAX_FACTION_SKINS; i ++)
                    {
                        if (FactionInfo[PlayerData[playerid][pFaction]][fSkins][i] != 0)
                        {
                            SetPlayerSkin(playerid, FactionInfo[PlayerData[playerid][pFaction]][fSkins][i]);
                            PlayerData[playerid][pSkinSelected] = i;
                            break;
                        }
                    }
                }
            }

            Dialog_Show(playerid, DIALOG_FACTIONSKINS, DIALOG_STYLE_MSGBOX, "Uniform selection", "Press {00AA00}>> Next{A9C4E4} to browse through available uniforms.", ">> Next", "Confirm");
        }
        else
        {
            PlayerData[playerid][pClothes] = PlayerData[playerid][pSkin];
            PlayerData[playerid][pSkin] = GetPlayerSkin(playerid);
            PlayerData[playerid][pSkinSelected] = -1;

            DBQuery("UPDATE "#TABLE_USERS" SET skin = %i, clothes = %i WHERE uid = %i", PlayerData[playerid][pSkin], PlayerData[playerid][pClothes], PlayerData[playerid][pID]);

            ShowActionBubble(playerid, "* %s takes a uniform out of the locker and puts it on.", GetRPName(playerid));
        }
    }
    return 1;
}
