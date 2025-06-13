/// @file      all.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:taxhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREY, "The tax is currently set to {33CCFF}%i percent", GetTaxPercent());
    return 1;
}

CMD:stats(playerid, params[])
{
    DisplayStats(playerid);
    return 1;
}

CMD:networth(playerid, params[])
{
    PrintNetWorthPlayer(playerid);
    return 1;
}

CMD:lights(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");
    }
    if (!VehicleHasEngine(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no lights which can be turned on.");
    }

    if (!IsVehicleParamOn(vehicleid, VEHICLE_LIGHTS))
    {
        SetVehicleParams(vehicleid, VEHICLE_LIGHTS, true);
        ShowActionBubble(playerid, "* %s turns on the headlights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }
    else
    {
        SetVehicleParams(vehicleid, VEHICLE_LIGHTS, false);
        ShowActionBubble(playerid, "* %s turns off the headlights of the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
    }

    return 1;
}

CMD:resetupgrades(playerid, params[])
{
    if (strcmp(params, "confirm", true) != 0)
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /resetupgrades [confirm]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "This command resets all of your upgrades and give you back %i upgrade points.", (PlayerData[playerid][pLevel] - 1) * 2);
        return 1;
    }
    if (PlayerData[playerid][pLevel] == 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't level 2+.");
    }
    if (PlayerData[playerid][pInventoryUpgrade] == 0 && PlayerData[playerid][pTraderUpgrade] == 0 && PlayerData[playerid][pAddictUpgrade] == 0 && PlayerData[playerid][pAssetUpgrade] == 0 && PlayerData[playerid][pLaborUpgrade] == 0 && PlayerData[playerid][pSpawnHealth] == 50.0 && PlayerData[playerid][pSpawnArmor] == 0.0 && PlayerData[playerid][pUpgradePoints] == (PlayerData[playerid][pLevel] - 1) * 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't spent any upgrade points on upgrades. Therefore you can't reset them.");
    }
    if (GetPlayerAssetCount(playerid, LIMIT_HOUSES) > 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i houses at the moment. Please sell one of them before using this command.", GetPlayerAssetCount(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_HOUSES));
    }
    if (GetPlayerAssetCount(playerid, LIMIT_BUSINESSES) > 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i businesses at the moment. Please sell one of them before using this command.", GetPlayerAssetCount(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES));
    }
    if (GetPlayerAssetCount(playerid, LIMIT_GARAGES) > 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You own %i/%i garages at the moment. Please sell one of them before using this command.", GetPlayerAssetCount(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES));
    }

    DBFormat("SELECT COUNT(*) FROM vehicles WHERE ownerid = %i", PlayerData[playerid][pID]);
    DBExecute("OnPlayerAttemptResetUpgrades", "i", playerid);
    return 1;
}

CMD:upgrades(playerid, params[])
{
    return callcmd::myupgrades(playerid, params);
}

CMD:myupgrades(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's upgrades (%i points available) _____", GetRPName(playerid), PlayerData[playerid][pUpgradePoints]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Shealth: %.0f/100]{C8C8C8} You spawn with %.1f health at the hospital after death.", PlayerData[playerid][pSpawnHealth], PlayerData[playerid][pSpawnHealth]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Sarmor: %.0f/100]{C8C8C8} You spawn with %.1f armor at the hospital after death.", PlayerData[playerid][pSpawnArmor], PlayerData[playerid][pSpawnArmor]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Inventory: %i/5]{C8C8C8} This upgrade increases the capacity for your items. [/inv]", PlayerData[playerid][pInventoryUpgrade]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Trader: %i/3]{C8C8C8} You save an extra %i percent on all items purchased in businesses.", PlayerData[playerid][pTraderUpgrade], PlayerData[playerid][pTraderUpgrade] * 10);
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Addict: %i/3]{C8C8C8} You gain an extra %.1f health and armor when using drugs.", PlayerData[playerid][pAddictUpgrade], PlayerData[playerid][pAddictUpgrade] * 5.0);
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Asset: %i/4]{C8C8C8} You can own %i houses, %i businesses, %i garages & %i vehicles.", PlayerData[playerid][pAssetUpgrade], GetPlayerAssetLimit(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));
    SendClientMessageEx(playerid, COLOR_YELLOW, "[Labor: %i/5]{C8C8C8} You earn an extra %i percent cash to your paycheck when working.", PlayerData[playerid][pLaborUpgrade], PlayerData[playerid][pLaborUpgrade] * 2);
    return 1;
}

CMD:buylevel(playerid, params[])
{
    new exp  = (PlayerData[playerid][pLevel] * 4);
    new cost = (PlayerData[playerid][pLevel] + 1) * LEVEL_COST;
    new string[64];

    if (PlayerData[playerid][pEXP] < exp)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need %i more respect points in order to level up.", exp - PlayerData[playerid][pEXP]);
    }
    if (PlayerData[playerid][pCash] < cost)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You need to have at least %s on hand to buy your next level.", FormatCash(cost));
    }
    if (PlayerData[playerid][pPassport])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have an active passport. You can't level up at the moment.");
    }

    PlayerData[playerid][pEXP] -= exp;
    PlayerData[playerid][pCash] -= cost;
    PlayerData[playerid][pLevel]++;
    PlayerData[playerid][pUpgradePoints] += 2;

    if (PlayerData[playerid][pLevel] == 3 && PlayerData[playerid][pReferralUID] > 0)
    {
        ReferralCheck(playerid);
    }
    if (PlayerData[playerid][pLevel] >= 5)
    {
        AwardAchievement(playerid, ACH_FiveStars);
    }
    if (PlayerData[playerid][pLevel] >= 10)
    {
        AwardAchievement(playerid, ACH_TopTier);
    }

    format(string, sizeof(string), "~g~Level Up~n~~w~You are now level %i", PlayerData[playerid][pLevel]);
    GameTextForPlayer(playerid, string, 5000, 1);

    DBQuery("UPDATE "#TABLE_USERS" SET exp = exp - %i, cash = cash - %i, level = level + 1, upgradepoints = upgradepoints + 2 WHERE uid = %i", exp, cost, PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_GREEN, "You have moved up to level %i. This costed you %s.", PlayerData[playerid][pLevel], FormatCash(cost));
    SendClientMessageEx(playerid, COLOR_GREEN, "You now have %i upgrade points. Use /upgrade to learn more.", PlayerData[playerid][pUpgradePoints]);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    return 1;
}

CMD:samphelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GLOBAL, "_____________________[ SA:MP 0.3.7 R2 CLIENT ]_________________________");
    SendClientMessageEx(playerid, COLOR_GREY, "** CLIENT ** /interior /save /headmove /timestamp /dl");
    SendClientMessageEx(playerid, COLOR_GREY, "** CLIENT ** /pagesize /rs /fpslimit");
    return 1;
}

CMD:togglecam(playerid, params[])
{
    if (GetPVarInt(playerid,"used") == 1)
    {
        SetPVarInt(playerid,"used",0);
        SetCameraBehindPlayer(playerid);
        DestroyPlayerObject(playerid,pObj[playerid]);
    }
    return 1;
}

CMD:window(playerid, params[])
{
    if (InsideShamal[playerid] != INVALID_VEHICLE_ID)
    {
        if (GetPlayerInterior(playerid))
        {
            new Float: fSpecPos[6];

            GetPlayerPos(playerid, fSpecPos[0], fSpecPos[1], fSpecPos[2]);
            GetPlayerFacingAngle(playerid, fSpecPos[3]);
            GetPlayerHealth(playerid, fSpecPos[4]);
            GetPlayerArmour(playerid, fSpecPos[5]);

            SetPVarFloat(playerid, "air_Xpos", fSpecPos[0]);
            SetPVarFloat(playerid, "air_Ypos", fSpecPos[1]);
            SetPVarFloat(playerid, "air_Zpos", fSpecPos[2]);
            SetPVarFloat(playerid, "air_Rpos", fSpecPos[3]);
            SetPVarFloat(playerid, "air_HP", fSpecPos[4]);
            SetPVarFloat(playerid, "air_Arm", fSpecPos[5]);
            SetPVarInt(playerid, "InsideVeh_Interior", GetPlayerInterior(playerid));
            SetPVarInt(playerid, "InsideVeh_World", GetPlayerVirtualWorld(playerid));

            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectateVehicle(playerid, InsideShamal[playerid]);

            ShowActionBubble(playerid, "* %s glances out the window.", GetRPName(playerid));
        }
        else
        {
            SetPlayerInterior(playerid, GetPVarInt(playerid, "InsideVeh_Interior"));
            SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "InsideVeh_World"));
            TogglePlayerSpectating(playerid, 0);
        }
    }
    return 1;
}


CMD:tlaws(playerid, params[])
{
    SendClientMessage(playerid, COLOR_LIGHTRED, "Traffic Laws");
    SendClientMessage(playerid, COLOR_GLOBAL, "Drive on the RIGHT side of the road at all times.");
    SendClientMessage(playerid, COLOR_GLOBAL, "Yield to emergency vehicles.");
    SendClientMessage(playerid, COLOR_GLOBAL, "Move over and slow down for stopped emergency vehicles.");
    SendClientMessage(playerid, COLOR_GLOBAL, "Turn your headlights on at night (/lights).");
    SendClientMessage(playerid, COLOR_GLOBAL, "Wear your seatbelt or helmet (/seatbelt).");
    SendClientMessage(playerid, COLOR_GLOBAL, "Drive at speeds that are posted in /speedlaws");
    //SendClientMessage(playerid, COLOR_GLOBAL, "Traffic lights are synced RED=STOP YELLOW=SLOW DOWN GREEN=GO");
    //SendClientMessage(playerid, COLOR_GLOBAL, "Only follow traffic lights above a junction. (Marked with a solid white line)");
    SendClientMessage(playerid, COLOR_GLOBAL, "Remain at a safe distance from other vehicles when driving, atleast 3 car lengths");
    SendClientMessage(playerid, COLOR_GLOBAL, "Pedistrians always have the right of way, regardless of the situation.");
    SendClientMessage(playerid, COLOR_GLOBAL, "Drive how you would in real life, dont be a moron.");
    SendClientMessage(playerid, COLOR_GLOBAL, "If you fail at driving you will be jailed or fined.");
    return 1;
}

CMD:speedlaws(playerid, params[])
{
    SendClientMessage(playerid, COLOR_RED, "Speed Enforcement Laws");
    SendClientMessage(playerid, COLOR_GLOBAL, "50mph in Cities");
    SendClientMessage(playerid, COLOR_GLOBAL, "70mph on the County roads");
    SendClientMessage(playerid, COLOR_GLOBAL, "90mph on the Highways and Interstates");
    SendClientMessage(playerid, COLOR_GLOBAL, "Box trucks cannot exceed 50MPH.");
    SendClientMessage(playerid, COLOR_GLOBAL, "Any vehicles with 3 or more axles aren't allowed to go more than 55 mph. Regardless of roadway limits.");
    SendClientMessage(playerid, COLOR_GLOBAL, "[ THERE ARE POLICE AND SPEED CAMERAS THAT ENFORCE THESE LAWS ]");
    return 1;
}

//Reward play (ToiletDuck)
CMD:phrewards(playerid)
{
    if (!IsHourRewardEnabled())
    {
        return SendClientMessage(playerid, COLOR_GREY, "Hour reward is disabled");
    }

    new string[2300];
    strcat(string, "\t\t\t{FFA500}");
    strcat(string, GetServerName());
    strcat(string, " Auto Playing Hours Reward System");
    strcat(string, "\n\n{FF00FF}Information:{FFFFFF}");
    strcat(string, "\nHere some lists of Rewards that auto playing hours reward of the Server you will receive");
    strcat(string, "\n\n_______________________________________________________________");
    strcat(string, "\n  {FFA500}Playing Hours:\tRewards:{FFFFFF}");
    strcat(string, "\n  10 Playing Hours\t10 Frist Aid Kit");
    strcat(string, "\n  25 Playing Hours\t 10 Cookies");
    strcat(string, "\n  50 Playing Hours\t5 Upgrade Points");
    strcat(string, "\n  100 Playing Hours\t50g Weed and Cocaine and 15,000 Materials");
    strcat(string, "\n  150 Playing Hours\t$50,000 of Cash and 5 Exp");
    strcat(string, "\n  200 Playing Hours\t 20 Cookies");
    strcat(string, "\n  250 Playing Hours\t7 Days Silver VIP");
    strcat(string, "\n  300 Playing Hours\t15 Days Silver VIP");
    strcat(string, "\n  350 Playing Hours\t50,000 Materials and 5 Exp");
    strcat(string, "\n  400 Playing Hours\t5 Days Gold VIP");
    strcat(string, "\n  450 Playing Hours\t5 XP 15 First aid Kit");
    strcat(string, "\n  500 Playing Hours\t10 Days Gold VIP");
    strcat(string, "\n  600 Playing Hours\t 30 Cookies");
    strcat(string, "\n  700 Playing Hours\t15 Days Gold VIP");
    strcat(string, "\n  800 Playing Hours\t3 Days Legendary VIP");
    strcat(string, "\n  900 Playing Hours\t7 Days Legendary VIP");
    strcat(string, "\n  1000 Playing Hours\t10 Days Legendary VIP");
    strcat(string, "\n  1250 Playing Hours\t15 Days Legendary VIP");
    strcat(string, "\n  1500 Playing Hours\tSpecial Vehicle");
    strcat(string, "\n  1750 Playing Hours\t20 Days Legendary VIP");
    strcat(string, "\n  2000 Playing Hours\t30 Days Legendary VIP");
    strcat(string, "\n_______________________________________________________________");
    strcat(string, "\nEnjoy the game and Stay Active! Have fun - ");
    strcat(string, GetServerName());
    Dialog_Show(playerid, 0 , DIALOG_STYLE_MSGBOX, "Auto Playing Hours Reward Dialog Info", string, "Like", "");
    return 1;
}


CMD:setstyle(playerid, params[])
{
    new pickid;
    if (!PlayerData[playerid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_ADM, "ACCESS DENIED:{FFFFFF} You aren't a donator.");
    }

    if (sscanf(params, "i", pickid))
    {
        SendClientMessage(playerid, COLOR_WHITE, "Chat Styles: 0 1 2 3 4");
        SendClientMessage(playerid, COLOR_WHITE, "Chat Styles: 5 6 7");
        SendClientMessage(playerid, COLOR_GREEN, "USAGE: /setstyle 2 [StyleID]");
        return true;
    }

    if (pickid != -1 && pickid < 0 || pickid > 7)
    {
        return SendClientMessage(playerid, COLOR_ADM, "You specified an invalid chat.");
    }

    PlayerData[playerid][pChatstyle] = pickid;
    SavePlayerVariables(playerid);
    SendClientMessage(playerid, COLOR_YELLOW, "Enjoy your new chatstyle!");
    return 1;
}

CMD:helpwindow(playerid,params[])
{
    ShowDialogToPlayer(playerid, DIALOG_HELP);
    return 1;
}
CMD:help(playerid, params[])
{
    new title[64];
    format(title, sizeof(title), "{00aa00}%s {FFFFFF}| Commands", GetServerName());

    if (IsAdmin(playerid, ADMIN_LVL_3))
    {
        Dialog_Show(playerid, DIALOG_HELPCMD, DIALOG_STYLE_LIST, title,
                    "General Commands\nJob Commands\nGang Commands\nFaction Commands\nVIP Commands\n"\
                    "House Commands\nVehicle Commands\nBusiness Commands\nHelper Commands\nAdmin Commands", "Choose", "Close");
    }
    else if (PlayerData[playerid][pHelper] > 1)
    {
        Dialog_Show(playerid, DIALOG_HELPCMD, DIALOG_STYLE_LIST, title,
                    "General Commands\nJob Commands\nGang Commands\nFaction Commands\nVIP Commands\n"\
                    "House Commands\nVehicle Commands\nBusiness Commands\nHelper Commands", "Choose", "Close");
    }
    else
    {
        Dialog_Show(playerid, DIALOG_HELPCMD, DIALOG_STYLE_LIST, title,
                    "General Commands\nJob Commands\nGang Commands\nFaction Commands\nVIP Commands\n"\
                    "House Commands\nVehicle Commands\nBusiness Commands", "Choose", "Close");

    }

    return 1;
}

CMD:vehiclehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "________________ Vehicle Help ________________");
    SendClientMessage(playerid, COLOR_WHITE, "** VEHICLE HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /lights /hood /trunk /boot /buy /carstorage /park /lock /findcar, /setforsale, /cancelforsale");
    SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /vstash /neon /unmod /colorcar /paintcar /upgradevehicle /sellcar /sellmycar");
    SendClientMessage(playerid, COLOR_GREY, "** VEHICLE ** /givekeys /takekeys /setradio /paytickets /carinfo /gascan /breakin");
    return 1;
}

CMD:bankhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_NAVYBLUE, "__________________ Banking Help __________________");
    SendClientMessage(playerid, COLOR_WHITE, "** BANKING HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** BANKING ** /withdraw /deposit /wiretransfer /balance /robbank /robinvite /bombvault /robbers");
    return 1;
}

CMD:setspawn(playerid, params[])
{
    new spawn_id, optional;

    if (sscanf(params, "dI(-1)", spawn_id, optional))
    {
        SendClientMessage(playerid, COLOR_ADM, "USAGE:{FFFFFF} /setspawn [spawn_id] ");
        SendClientMessage(playerid, COLOR_DARKGREEN, "1. Last Position | 2. House | 4. Faction");
        return true;
    }

    switch ( spawn_id )
    {
        case 1:
        {
            PlayerData[playerid][pSpawnSelect] = 0;
            SendClientMessage(playerid, COLOR_GREY, "You will now spawn at your last position.");
            SavePlayerVariables(playerid);

        }
        case 2:
        {
            if (CountPlayerHouses(playerid) == 0)return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You don't own any houses.");

            if (optional == -1)
            {
                SendClientMessage(playerid, COLOR_ADM, "USAGE:{FFFFFF} /setspawn 2 [house id] ");
                SendClientMessage(playerid, COLOR_ADM, "You must specify your house ID by using /myassets to fetch the ID. ");
                return true;
            }

            if (optional < 0 || !HouseInfo[optional][hExists]) return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You specified an invalid house ID.");

            for (new i = 0; i < MAX_HOUSES; i++)
            {
                if (HouseInfo[optional][hExists])
                {
                    if (!IsHouseOwner(playerid, optional))
                    {
                        SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You don't own that house.");
                        return true;
                    }
                }
            }

            SendClientMessage(playerid, COLOR_GREY, "You will now spawn at your house.");
            PlayerData[playerid][pSpawnSelect] = 1;
            PlayerData[playerid][pSpawnHouse] = optional;
            SavePlayerVariables(playerid);
        }
        case 3:
        {
            if ( !PlayerData[playerid][pFaction] )return SendClientMessage(playerid, COLOR_ADM, "ERROR:{FFFFFF} You aren't in any faction.");

            SendClientMessage(playerid, COLOR_GREY, "You will now spawn at your faction spawn.");
            PlayerData[playerid][pSpawnSelect] = 2;
            PlayerData[playerid][pSpawnPrecinct] = 0;
            SavePlayerVariables(playerid);
        }
    }
    return true;
}

CMD:planthelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "** PLANT HELP ** type a command for more information.");
    SendClientMessage(playerid, COLOR_GREY, "** PLANT ** /plantweed /plantinfo /pickplant /seizeplant");
    return 1;
}


CMD:level(playerid, params[])
{
    new count, color;

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /level [level]");
    }

    if (IsNumeric(params))
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLevel] == strval(params))
            {
                if ((color = GetPlayerColor(i)) == 0xFFFFFF00)
                    color = 0xAAAAAAFF;

                SendClientMessageEx(playerid, COLOR_GREY3, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", i, color >>> 8, GetPlayerNameEx(i), PlayerData[i][pLevel], GetPlayerPing(i));
                count++;
            }
        }
        if (!count)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "There are no level %s players online.", params);
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Please use a numerical value!");
    }

    return 1;
}

CMD:id(playerid, params[])
{
    new count, color, name[MAX_PLAYER_NAME], targetid = strval(params);

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /id [playerid/partial name]");
    }

    if (IsNumeric(params))
    {
        if (IsPlayerConnected(targetid))
        {
            if ((color = GetPlayerColor(targetid)) == 0xFFFFFF00)
            {
                color = 0xAAAAAAFF;
            }

            GetPlayerName(targetid, name, sizeof(name));
            SendClientMessageEx(playerid, COLOR_GREY3, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", targetid, color >>> 8, name, PlayerData[targetid][pLevel], GetPlayerPing(targetid));
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }
    }
    else if (strlen(params) < 2)
    {
        SendClientMessage(playerid, COLOR_GREY, "Please input at least two characters to search.");
    }
    else
    {
        foreach(new i : Player)
        {
            GetPlayerName(i, name, sizeof(name));

            if (strfind(name, params, true) != -1)
            {
                if ((color = GetPlayerColor(i)) == 0xFFFFFF00)
                {
                    color = 0xAAAAAAFF;
                }

                SendClientMessageEx(playerid, COLOR_GREY3, "(ID: %i) {%06x}%s{AAAAAA} - (Level: %i) - (Ping: %i)", i, color >>> 8, name, PlayerData[i][pLevel], GetPlayerPing(i));
                count++;
            }
        }

        if (!count)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "No results found for \"%s\". Please narrow your search.", params);
        }
    }

    return 1;
}

CMD:pay(playerid, params[])
{
    new targetid, amount;

    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /pay [playerid] [amount]");
    }
    if (gettime() - PlayerData[playerid][pLastPay] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Please wait three seconds between each transaction.");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't pay yourself.");
    }
    if (amount < 1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must specify an amount above zero.");
    }
    if (amount > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have that much.");
    }
    if (amount > 100 && PlayerData[playerid][pLevel] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only pay up to $100 at a time as a level 1.");
    }
    if (amount > 100000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are only allowed to pay up to $100,000 at a time.");
    }
    if (PlayerData[playerid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
    }

    PlayerData[playerid][pLastPay] = gettime();

    GivePlayerCash(playerid, -amount);
    GivePlayerCash(targetid, amount);

    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);

    ShowActionBubble(playerid, "* %s takes out %s and gives it to %s.", GetRPName(playerid), FormatCash(amount), GetRPName(targetid));
    DBLog("log_give", "%s (uid: %i) (IP: %s) gives $%i to %s (uid: %i) (IP: %s)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid), amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID], GetPlayerIP(targetid));

    SendClientMessageEx(targetid, COLOR_AQUA, "You have been given {00AA00}%s{33CCFF} by %s.", FormatCash(amount), GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "You have given {FF6347}%s{33CCFF} to %s.", FormatCash(amount), GetRPName(targetid));

    if (!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
    {
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has given %s to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), FormatCash(amount), GetRPName(targetid), GetPlayerIP(targetid));
    }

    return 1;
}

CMD:give(playerid, params[])
{
    new targetid, option[14], param[32], amount;

    if (sscanf(params, "us[14]S()[32]", targetid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapon, Materials, Weed, Cocaine, heroin, Painkillers, Cigars, Spraycans");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: GasCan, Seeds, Chems, FirstAid, Bodykits, Diamonds");
        return 1;
    }

    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    if (!strcmp(option, "weapon", true))
    {
        new weaponid = GetScriptWeapon(playerid);

        if (!weaponid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You must be holding the weapon you're willing to give away.");
        }
        if (PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't give this weapon as you don't have it.");
        }
        if (PlayerData[targetid][pWeapons][GetWeaponSlot(weaponid)] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player already has a weapon in that slot.");
        }
        if (PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
        }
        if (PlayerData[playerid][pFaction] >= 0 && PlayerData[targetid][pFaction] != PlayerData[playerid][pFaction])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can only give away weapons to your own faction members.");
        }
        if (IsPlayerInAnyVehicle(playerid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command from inside a vehicle.");
        }
        if (IsPlayerInAnyVehicle(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons to players inside a vehicle.");
        }
        if (GetPlayerHealthEx(playerid) < 60)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't give weapons as your health is below 60.");
        }
        GivePlayerWeaponEx(targetid, weaponid);
        RemovePlayerWeapon(playerid, weaponid);

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you their %s.", GetRPName(playerid), GetWeaponNameEx(weaponid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %s your %s.", GetRPName(targetid), GetWeaponNameEx(weaponid));

        ShowActionBubble(playerid, "* %s passes over their %s to %s.", GetRPName(playerid), GetWeaponNameEx(weaponid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives their %s to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetWeaponNameEx(weaponid), GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "materials", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [materials] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pMaterials])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pMaterials] + amount > GetPlayerCapacity(targetid, CAPACITY_MATERIALS))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more materials.");
        }

        PlayerData[playerid][pMaterials] -= amount;
        PlayerData[targetid][pMaterials] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[targetid][pMaterials], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i materials.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i materials to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some materials to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i materials to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "weed", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [weed] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pWeed])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pWeed] + amount > GetPlayerCapacity(targetid, CAPACITY_WEED))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more weed.");
        }

        PlayerData[playerid][pWeed] -= amount;
        PlayerData[targetid][pWeed] += amount;
        DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[targetid][pWeed], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of weed.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of weed to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some weed to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i grams of weed to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "cocaine", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [cocaine] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pCocaine])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pCocaine] + amount > GetPlayerCapacity(targetid, CAPACITY_COCAINE))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more cocaine.");
        }
        PlayerData[playerid][pCocaine] -= amount;
        PlayerData[targetid][pCocaine] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[targetid][pCocaine], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of cocaine.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of cocaine to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some cocaine to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i grams of cocaine to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "heroin", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [heroin] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pHeroin])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pHeroin] + amount > GetPlayerCapacity(targetid, CAPACITY_HEROIN))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more heroin.");
        }
        PlayerData[playerid][pHeroin] -= amount;
        PlayerData[targetid][pHeroin] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[targetid][pHeroin], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of Heroin.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of Heroin to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some Heroin to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i grams of Heroin to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "painkillers", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [painkillers] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pPainkillers])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pPainkillers] + amount > GetPlayerCapacity(targetid, CAPACITY_PAINKILLERS))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more painkillers.");
        }

        PlayerData[playerid][pPainkillers] -= amount;
        PlayerData[targetid][pPainkillers] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[targetid][pPainkillers], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i painkillers.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i painkillers to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some painkillers to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i painkillers to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "cigars", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [cigars] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pCigars])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }

        PlayerData[playerid][pCigars] -= amount;
        PlayerData[targetid][pCigars] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", PlayerData[playerid][pCigars], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", PlayerData[targetid][pCigars], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i cigars.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i cigars to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some cigars to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i cigars to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "spraycans", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [spraycans] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pSpraycans])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }

        PlayerData[playerid][pSpraycans] -= amount;
        PlayerData[targetid][pSpraycans] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[targetid][pSpraycans], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i spraycans.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i spraycans to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some spraycans to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i spraycans to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "gascan", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [gascan] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pGasCan])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pGasCan] + amount > GetPlayerCapacity(targetid, CAPACITY_GASCAN))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have space for this item.");
        }
        PlayerData[playerid][pGasCan] -= amount;
        PlayerData[targetid][pGasCan] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", PlayerData[playerid][pGasCan], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET gascan = %i WHERE uid = %i", PlayerData[targetid][pGasCan], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i liters of gasoline.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i liters of gasoline to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some gasoline to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i liters of gasoline to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "seeds", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [seeds] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pSeeds])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pSeeds] + amount > GetPlayerCapacity(targetid, CAPACITY_SEEDS))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more seeds.");
        }

        PlayerData[playerid][pSeeds] -= amount;
        PlayerData[targetid][pSeeds] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[playerid][pSeeds], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET seeds = %i WHERE uid = %i", PlayerData[targetid][pSeeds], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i seeds.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i seeds to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some seeds to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i seeds to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "chems", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [chems] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pChemicals])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pChemicals] + amount > GetPlayerCapacity(targetid, CAPACITY_CHEMICALS))
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more chems.");
        }

        PlayerData[playerid][pChemicals] -= amount;
        PlayerData[targetid][pChemicals] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i WHERE uid = %i", PlayerData[playerid][pChemicals], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET chemicals = %i WHERE uid = %i", PlayerData[targetid][pChemicals], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i grams of chems.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i grams of chems to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some chems to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i grams of chems to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "firstaid", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [firstaid] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pFirstAid])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pFirstAid] + amount > 20)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more first aid kits.");
        }

        PlayerData[playerid][pFirstAid] -= amount;
        PlayerData[targetid][pFirstAid] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[targetid][pFirstAid], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i first aid kits.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i first aid kits to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some first aid kits to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i first aid kits to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "bodykits", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [bodykits] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pBodykits])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pBodykits] + amount > 10)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more bodykits.");
        }

        PlayerData[playerid][pBodykits] -= amount;
        PlayerData[targetid][pBodykits] += amount;

        DBQuery("UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);


        DBQuery("UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[targetid][pBodykits], PlayerData[targetid][pID]);


        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i bodywork kits.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i bodywork kits to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some bodywork kits to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i bodywork kits to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }
    else if (!strcmp(option, "diamonds", true))
    {
        if (sscanf(param, "i", amount))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /give [playerid] [diamonds] [amount]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pDiamonds])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (PlayerData[targetid][pDiamonds] + amount > 50)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player can't carry that much more diamonds.");
        }

        GivePlayerDiamonds(playerid, -amount);
        GivePlayerDiamonds(targetid, amount);

        SendClientMessageEx(targetid, COLOR_AQUA, "%s has given you %i diamonds.", GetRPName(playerid), amount);
        SendClientMessageEx(playerid, COLOR_AQUA, "You have given %i diamonds to %s.", amount, GetRPName(targetid));

        ShowActionBubble(playerid, "* %s gives some diamonds to %s.", GetRPName(playerid), GetRPName(targetid));
        DBLog("log_give", "%s (uid: %i) gives %i diamonds to %s (uid: %i)", GetPlayerNameEx(playerid), PlayerData[playerid][pID], amount, GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    }

    return 1;
}

CMD:sell(playerid, params[])
{
    new targetid, option[14], param[32], amount, price;

    if (sscanf(params, "us[14]S()[32]", targetid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Weapon, Materials, Weed, Cocaine, Heroin, Painkillers, Seeds, Chemicals, Skin, Diamonds");
        return 1;
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || IsPlayerInEvent(playerid) > 0 || PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (gettime() - PlayerData[playerid][pLastSell] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastSell]));
    }

    if (!strcmp(option, "skin", true))
    {
        if (sscanf(param, "i", price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] skin [price]");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }
        if (PlayerData[playerid][pFaction] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot sell skin as you are part of a faction.");
        }
        if (PlayerData[playerid][pGang] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot sell skin as you are part of a gang.");
        }
        if (PlayerData[playerid][pSkin] == PlayerData[targetid][pSkin])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player already has this skin.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_SKIN;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you their clothes for $%i. (/accept item)", GetRPName(playerid), price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your clothes for $%i.", GetRPName(targetid), price);
    }
    else if (!strcmp(option, "weapon", true))
    {
        new weaponid;

        if (sscanf(param, "ii", weaponid, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [weapon] [weaponid] [price] (/guninv for weapon IDs)");
        }
        if (!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have that weapon. /guninv for a list of your weapons.");
        }
        if (PlayerData[targetid][pWeapons][GetWeaponSlot(weaponid)] > 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player already has a weapon in that slot.");
        }
        if (PlayerData[targetid][pLevel] < MINIMAL_LEVEL_FOR_HAVING_GUNS || PlayerData[targetid][pWeaponRestricted] > 0)
        {
            return SendClientMessageEx(playerid, COLOR_GREY, "That player is either weapon restricted or played less than level %d.", MINIMAL_LEVEL_FOR_HAVING_GUNS);
        }
        if (PlayerData[playerid][pFaction] >= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons as a faction member.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }
        if (IsPlayerInAnyVehicle(playerid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons from inside a vehicle.");
        }
        if (IsPlayerInAnyVehicle(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons to players inside a vehicle.");
        }
        if (GetPlayerHealthEx(playerid) < 60)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't sell weapons as your health is below 60.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_WEAPON;
        PlayerData[targetid][pSellExtra] = weaponid;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you their %s for $%i. (/accept item)", GetRPName(playerid), GetWeaponNameEx(weaponid), price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %s for $%i.", GetRPName(targetid), GetWeaponNameEx(weaponid), price);
    }
    else if (!strcmp(option, "materials", true))
    {

        if (!PlayerHasJob(playerid, JOB_ARMSDEALER) && !PlayerHasJob(playerid, JOB_CRAFTMAN))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Craft Man or Arms Dealer.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [materials] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pMaterials])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_MATERIALS;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i materials for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i materials for $%i.", GetRPName(targetid), amount, price);
    }
    else if(!strcmp(option, "backpack", true))
	{
	    new size[6];
		if(sscanf(param, "ii", amount, price))
		{
  			SCM(playerid, COLOR_SYNTAX, "Usage: /sell [playerid] [backpack] [size] [price]");
  			SCM(playerid, COLOR_GREY, "** {FF0000}[NOTE}: Please note that the items inside the backpack will be deleted.");
  			return 1;
		}
		if(!PlayerData[playerid][pBackpack])
		{
		    return SCM(playerid, COLOR_SYNTAX, "You don't have a backpack.");
		}
		if(PlayerData[playerid][bpWearing])
		{
		    return SCM(playerid, COLOR_SYNTAX, "You can't sell your backpack while wearing it.");
		}
		if(amount != PlayerData[playerid][pBackpack])
		{
		    SCM(playerid, COLOR_SYNTAX, "Invalid backpack size.");
		    SCM(playerid, COLOR_SYNTAX, "Sizes: 1 - Small  |  2 - Medium  |  3 - large");
		    return 1;
		}
		if(price < 1)
		{
		    return SCM(playerid, COLOR_SYNTAX, "The price can't be below $1.");
		}

		PlayerData[playerid][pLastSell] = gettime();
		PlayerData[targetid][pSellOffer] = playerid;
		PlayerData[targetid][pSellType] = ITEM_BACKPACK;
		PlayerData[targetid][pSellExtra] = amount;
		PlayerData[targetid][pSellPrice] = price;
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
		SM(targetid, COLOR_AQUA, "** %s offered to sell you a %s backpack for $%i. (/accept item)", GetRPName(playerid), size, price);
		SM(playerid, COLOR_AQUA, "** You have offered to sell %s your %s backpack for $%i.", GetRPName(targetid), size, price);
	}
    else if (!strcmp(option, "weed", true))
    {
        if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [weed] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pWeed])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_WEED;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of weed for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of weed for $%i.", GetRPName(targetid), amount, price);
    }
    else if (!strcmp(option, "cocaine", true))
    {
        if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [cocaine] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pCocaine])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_COCAINE;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of cocaine for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of cocaine for $%i.", GetRPName(targetid), amount, price);
    }
    else if (!strcmp(option, "heroin", true))
    {
        if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [heroin] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pHeroin])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_HEROIN;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of heroin for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of heroin for $%i.", GetRPName(targetid), amount, price);
    }
    else if (!strcmp(option, "painkillers", true))
    {
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [painkillers] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pPainkillers])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_PAINKILLERS;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i painkillers for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i painkillers for $%i.", GetRPName(targetid), amount, price);
    }
    else if (!strcmp(option, "seeds", true))
    {
        if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [seeds] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pSeeds])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_SEEDS;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i seeds for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i seeds for $%i.", GetRPName(targetid), amount, price);
    }
    else if (!strcmp(option, "chems", true))
    {
        if (!PlayerHasJob(playerid, JOB_DRUGDEALER))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Drug Dealer.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [chems] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pChemicals])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $1.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_CHEMICALS;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i grams of chems for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i grams of chems for $%i.", GetRPName(targetid), amount, price);
    }
    else if (!strcmp(option, "diamonds", true))
    {
        if (!PlayerHasJob(playerid, JOB_MINER))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a Miner.");
        }
        if (sscanf(param, "ii", amount, price))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sell [playerid] [diamonds] [amount] [price]");
        }
        if (amount < 1 || amount > PlayerData[playerid][pDiamonds])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }
        if (price < 5000 || price > 10000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "The price can't be below $5,000 or above $10,000.");
        }

        PlayerData[playerid][pLastSell] = gettime();
        PlayerData[targetid][pSellOffer] = playerid;
        PlayerData[targetid][pSellType] = ITEM_DIAMONDS;
        PlayerData[targetid][pSellExtra] = amount;
        PlayerData[targetid][pSellPrice] = price;
        SendClientMessageEx(targetid, COLOR_AQUA, "* %s offered to sell you %i diamonds for $%i. (/accept item)", GetRPName(playerid), amount, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have offered to sell %s your %i diamonds for $%i.", GetRPName(targetid), amount, price);
    }
    return 1;
}

CMD:upgrade(playerid, params[])
{
    new string[512];
    format(string, sizeof(string), "Name\tLevel\n\
        Inventory\t{ffff00}Currently Skill Level %i/5\n\
        Addict\t{ffff00}Currently Skill Level is %i/3\n\
        Trader\t{ffff00}Currently Skill Level %i/4\n\
        Asset\t{ffff00}Currently Skill Level %i/4\n\
        Labor\t{ffff00}Currently Skill Level %i/5\n\
        Spawn Health\t{ffff00}Currently Spawn Health is %.1f/100\n\
        Spawn Armor\t{ffff00}Currently Spawn Armour is %.1f/100\n",
        PlayerData[playerid][pInventoryUpgrade],
        PlayerData[playerid][pAddictUpgrade],
        PlayerData[playerid][pTraderUpgrade],
        PlayerData[playerid][pAssetUpgrade],
        PlayerData[playerid][pLaborUpgrade],
        PlayerData[playerid][pSpawnHealth],
        PlayerData[playerid][pSpawnArmor]);
    Dialog_Show(playerid, DIALOG_NEWUPGRADEONE, DIALOG_STYLE_TABLIST_HEADERS, "Upgrade List", string, "Upgrade", "Close");
    return 1;
}

CMD:charity(playerid, params[])
{
    new option[10], param[64];

    if (PlayerData[playerid][pLevel] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot donate to charity if you're under level 5. /buylevel to level up.");
    }
    if (sscanf(params, "s[10]S()[64]", option, param))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /charity [info | health | armor | song]");
    }
    if (!strcmp(option, "info", true))
    {
        SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ Charity _______");
        SendClientMessage(playerid, COLOR_GREY3, "If you have at least $1,000 on hand you can donate to charity.");
        SendClientMessage(playerid, COLOR_GREY3, "You can donate to give health or armor for the entire server using '{FFD700}/charity health/armor{AAAAAA}'.");
        SendClientMessage(playerid, COLOR_GREY3, "You can also donate to globally play a song of your choice using '{FFD700}/charity song{AAAAAA}'.");
        SendClientMessage(playerid, COLOR_GREY3, "You can also donate your money the traditional way using '{FFD700}/charity [amount]{AAAAAA}'.");
        SendClientMessage(playerid, COLOR_GREY3, "Once the charity bank hits a milestone, some of it will be given back to the community!");
        SendClientMessageEx(playerid, COLOR_AQUA, "* %s has been donated to charity so far.", FormatCash(GetCharity()));
        return 1;
    }
    else if (!strcmp(option, "health", true))
    {
        if (PlayerData[playerid][pCash] < 50000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least $50,000 on hand for this option.");
        }
        if (gCharityHealth)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Players can only donate for this perk each hour. Try again after payday.");
        }

        foreach(new i : Player)
        {
            if (!PlayerData[i][pAdminDuty])
            {
                SetPlayerHealth(i, 150.0);
            }
        }

        AddToCharity(50000);
        gCharityHealth = 1;
        AddToTaxVault(50000);

        SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated $50,000 to heal everyone to 150 health!", GetRPName(playerid));
        GivePlayerCash(playerid, -50000);
    }
    else if (!strcmp(option, "armor", true))
    {
        if (PlayerData[playerid][pCash] < 50000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least $50,000 on hand for this option.");
        }
        if (gCharityArmor)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Players can only donate for this perk each hour. Try again after payday.");
        }

        foreach(new i : Player)
        {
            if (!PlayerData[i][pAdminDuty])
            {
                SetScriptArmour(i, 100.0);
            }
        }

        AddToCharity(50000);
        gCharityArmor = 1;
        AddToTaxVault(50000);

        SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated $50,000 to give full armor to everyone!", GetRPName(playerid));
        GivePlayerCash(playerid, -50000);
    }
    else if (!strcmp(option, "song", true))
    {
        if (isnull(param))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /charity [song] [songfolder/name.mp3]");
        }
        if (PlayerData[playerid][pCash] < 25000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least $25,000 on hand for this option.");
        }
        if (gettime() - gLastMusic < 300)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Music can only be played globally every 5 minutes.");
        }

        new url[144];
        format(url, sizeof(url), "http://%s/%s", GetServerMusicUrl(), param);

        foreach(new i : Player)
        {
            if (!PlayerData[i][pToggleMusic] && PlayerData[i][pStreamType] == MUSIC_NONE)
            {
                PlayAudioStreamForPlayer(i, url);
            }
        }
        gLastMusic = gettime();

        AddToCharity(25000);
        AddToTaxVault(25000);

        SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated $25,000 to play %s for the entire server!", GetRPName(playerid), param);
        GivePlayerCash(playerid, -25000);
    }
    else if (IsNumeric(option))
    {
        new amount = strval(option);

        if (amount < 1 || amount > PlayerData[playerid][pCash])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
        }

        AddToCharity(amount);
        AddToTaxVault(amount);

        GivePlayerCash(playerid, -amount);
        if (amount > 100000)
        {
            SendClientMessageToAllEx(COLOR_OLDSCHOOL, "Charity: %s has generously donated %s to charity!", GetRPName(playerid), FormatCash(amount));
        }
    }

    return 1;
}

CMD:myassets(playerid, params[])
{

    if (!PlayerData[playerid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not logged in yet.");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "_____ %s's Assets _____", GetRPName(playerid));

    foreach(new i : House)
    {
        if (HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {33CC33}House{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]), (gettime() - HouseInfo[i][hTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
        }
    }

    foreach(new i : Business)
    {
        if (BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {FFD700}Business{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]), (gettime() - BusinessInfo[i][bTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
        }
    }

    foreach(new i : Garage)
    {
        if (GarageInfo[i][gExists] && IsGarageOwner(playerid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {004CFF}Garage{C8C8C8} | ID: %i | Location: %s | Status: %s", i, GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]), (gettime() - GarageInfo[i][gTimestamp]) > 2592000 ? ("{FF6347}Inactive") : ("{00AA00}Active"));
        }
    }

    foreach(new i : Land)
    {
        if (LandInfo[i][lExists] && IsLandOwner(playerid, i))
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "* {33CCFF}Land{C8C8C8} | ID: %i | Location: %s", i, GetZoneName(LandInfo[i][lHeightX], LandInfo[i][lHeightY], LandInfo[i][lHeightZ]));
        }
    }

    return 1;
}

CMD:enter(playerid, params[])
{
    if (PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || IsDueling(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    else
    {
        EnterCheck(playerid);
    }

    return 1;
}

CMD:exit(playerid, params[])
{
    if (PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pCuffed] > 0 || IsDueling(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    else
    {
        ExitCheck(playerid);
    }

    return 1;
}

CMD:skills(playerid, params[])
{
    return callcmd::skill(playerid, params);
}
CMD:skill(playerid, params[])
{
    ShowSkillsDialog(playerid);
    return 1;
}
CMD:skillss(playerid, params[])
{
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skill [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Courier, Fishing, Bodyguard, ArmsDealer, Mechanic, DrugSmuggler, Lawyer, Detective, Thief");
        return 1;
    }
    if (!strcmp(params, "fishing", true))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "Your fishing skill level is %i/5.", GetJobLevel(playerid, JOB_FISHERMAN));

        if (GetJobLevel(playerid, JOB_FISHERMAN) < 5)
        {
            if (PlayerData[playerid][pFishingSkill] < 50)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 50 - PlayerData[playerid][pFishingSkill]);
            }
            else if (PlayerData[playerid][pFishingSkill] < 100)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 100 - PlayerData[playerid][pFishingSkill]);
            }
            else if (PlayerData[playerid][pFishingSkill] < 200)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 200 - PlayerData[playerid][pFishingSkill]);
            }
            else if (PlayerData[playerid][pFishingSkill] < 350)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to catch %i more fish in order to level up.", 350 - PlayerData[playerid][pFishingSkill]);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
        }
    }
    else if (!strcmp(params, "armsdealer", true))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "Your weapons dealer skill level is %i/5.", GetJobLevel(playerid, JOB_ARMSDEALER));

        if (GetJobLevel(playerid, JOB_ARMSDEALER) < 5)
        {
            if (PlayerData[playerid][pWeaponSkill] < 50)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 50 - PlayerData[playerid][pWeaponSkill]);
            }
            else if (PlayerData[playerid][pWeaponSkill] < 100)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 100 - PlayerData[playerid][pWeaponSkill]);
            }
            else if (PlayerData[playerid][pWeaponSkill] < 200)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 200 - PlayerData[playerid][pWeaponSkill]);
            }
            else if (PlayerData[playerid][pWeaponSkill] < 500)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to sell %i more weapons in order to level up.", 500 - PlayerData[playerid][pWeaponSkill]);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
        }
    }
    else if (!strcmp(params, "mechanic", true))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "Your mechanic skill level is %i/5.", GetJobLevel(playerid, JOB_MECHANIC));

        if (GetJobLevel(playerid, JOB_MECHANIC) < 5)
        {
            if (PlayerData[playerid][pMechanicSkill] < 25)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 25 - PlayerData[playerid][pMechanicSkill]);
            }
            else if (PlayerData[playerid][pMechanicSkill] < 50)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 50 - PlayerData[playerid][pMechanicSkill]);
            }
            else if (PlayerData[playerid][pMechanicSkill] < 100)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 100 - PlayerData[playerid][pMechanicSkill]);
            }
            else if (PlayerData[playerid][pMechanicSkill] < 200)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to fix %i more vehicles in order to level up.", 200 - PlayerData[playerid][pMechanicSkill]);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
        }
    }
    else if (!strcmp(params, "drugsmuggler", true))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "Your drug smuggler skill level is %i/5.", GetJobLevel(playerid, JOB_DRUGDEALER));

        if (GetJobLevel(playerid, JOB_DRUGDEALER) < 5)
        {
            if (PlayerData[playerid][pSmugglerSkill] < 25)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 25 - PlayerData[playerid][pSmugglerSkill]);
            }
            else if (PlayerData[playerid][pSmugglerSkill] < 50)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 50 - PlayerData[playerid][pSmugglerSkill]);
            }
            else if (PlayerData[playerid][pSmugglerSkill] < 75)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 75 - PlayerData[playerid][pSmugglerSkill]);
            }
            else if (PlayerData[playerid][pSmugglerSkill] < 100)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to smuggle %i more packages in order to level up.", 100 - PlayerData[playerid][pSmugglerSkill]);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
        }
    }
    else if (!strcmp(params, "lawyer", true))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "Your lawyer skill level is %i/5.", GetJobLevel(playerid, JOB_LAWYER));

        if (GetJobLevel(playerid, JOB_LAWYER) < 5)
        {
            if (PlayerData[playerid][pLawyerSkill] < 25)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 25 - PlayerData[playerid][pLawyerSkill]);
            }
            else if (PlayerData[playerid][pLawyerSkill] < 50)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 50 - PlayerData[playerid][pLawyerSkill]);
            }
            else if (PlayerData[playerid][pLawyerSkill] < 100)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 100 - PlayerData[playerid][pLawyerSkill]);
            }
            else if (PlayerData[playerid][pLawyerSkill] < 200)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to defend %i more clients in order to level up.", 200 - PlayerData[playerid][pLawyerSkill]);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
        }
    }
    else if (!strcmp(params, "detective", true))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "Your detective skill level is %i/5.", GetJobLevel(playerid, JOB_DETECTIVE));

        if (GetJobLevel(playerid, JOB_DETECTIVE) < 5)
        {
            if (PlayerData[playerid][pDetectiveSkill] < 50)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 50 - PlayerData[playerid][pDetectiveSkill]);
            }
            else if (PlayerData[playerid][pDetectiveSkill] < 100)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 100 - PlayerData[playerid][pDetectiveSkill]);
            }
            else if (PlayerData[playerid][pDetectiveSkill] < 200)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 200 - PlayerData[playerid][pDetectiveSkill]);
            }
            else if (PlayerData[playerid][pDetectiveSkill] < 400)
            {
                SendClientMessageEx(playerid, COLOR_GREEN, "You need to find %i more people in order to level up.", 400 - PlayerData[playerid][pDetectiveSkill]);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREEN, "You have reached the maximum skill level for this job.");
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skill [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Fishing, Bodyguard, ArmsDealer, Mechanic, DrugSmuggler, Lawyer, Detective");
    }

    return 1;
}

CMD:withdraw(playerid, params[])
{
    new amount;

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /withdraw [amount] ($%i available)", PlayerData[playerid][pBank]);
    }
    if (amount < 1 || amount > PlayerData[playerid][pBank])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }

    PlayerData[playerid][pBank] -= amount;
    GivePlayerCash(playerid, amount);

    DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "You have withdrawn {00AA00}%s{33CCFF} from your bank account. Your new balance is %s.", FormatCash(amount), FormatCash(PlayerData[playerid][pBank]));
    return 1;
}

CMD:deposit(playerid, params[])
{
    new amount;

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /deposit [amount]");
    }
    if (amount < 1 || amount > PlayerData[playerid][pCash])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }
    if (PlayerData[playerid][pAdminDuty])
    {
       return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
    }

    PlayerData[playerid][pBank] += amount;
    GivePlayerCash(playerid, -amount);

    DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "You have deposited {00AA00}%s{33CCFF} into your bank account. Your new balance is %s.", FormatCash(amount), FormatCash(PlayerData[playerid][pBank]));
    return 1;
}

CMD:wiretransfer(playerid, params[])
{
    new targetid, amount;

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }
    if (PlayerData[playerid][pLevel] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only use this command if you are level 2+.");
    }
    if (sscanf(params, "ui", targetid, amount))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /wiretransfer [playerid] [amount]");
    }
    if (!IsPlayerConnected(targetid) || !PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or hasn't logged in yet.");
    }
    if (amount < 1 || amount > PlayerData[playerid][pBank])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Insufficient amount.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't transfer funds to yourself.");
    }
    if (amount > 1000000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are only allowed to transfer up to $1,000,000 at a time.");
    }
    if (PlayerData[playerid][pAdminDuty])
    {
       return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while on admin duty");
    }

    PlayerData[targetid][pBank] += amount;
    PlayerData[playerid][pBank] -= amount;

    DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);


    DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[targetid][pBank], PlayerData[targetid][pID]);


    SendClientMessageEx(playerid, COLOR_AQUA, "You have transferred {00AA00}%s{33CCFF} to %s. Your new balance is %s.", FormatCash(amount), GetRPName(targetid), FormatCash(PlayerData[playerid][pBank]));
    SendClientMessageEx(targetid, COLOR_AQUA, "%s has transferred {00AA00}%s{33CCFF} to your bank account.", GetRPName(playerid), FormatCash(amount));
    DBLog("log_give", "%s (uid: %i) (IP: %s) transferred $%i to %s (uid: %i) (IP: %s)", GetRPName(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid), amount, GetRPName(targetid), PlayerData[targetid][pID], GetPlayerIP(targetid));

    if (!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
    {
        SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) has transferred %s to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), FormatCash(amount), GetRPName(targetid), GetPlayerIP(targetid));
    }

    return 1;
}

CMD:balance(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 1667.4260, -972.6691, 683.6873))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of the bank.");
    }

    SendClientMessageEx(playerid, COLOR_GREEN, "Your bank account balance is $%i.", PlayerData[playerid][pBank]);
    return 1;
}

CMD:settings(playerid, params[])
{
    return callcmd::toggle(playerid, params);
}

CMD:tog(playerid, params[])
{
    return callcmd::toggle(playerid, params);
}

RefreshPlayerTextdraws(playerid)
{
    if (!PlayerData[playerid][pToggleTextdraws])
    {
        if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
        {

            TextDrawHideForPlayer(playerid, TimeTD);
            PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
            PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
            PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);
        }
        else
        {
            if (PlayerData[playerid][pWatch] && PlayerData[playerid][pWatchOn])
            {
                TextDrawShowForPlayer(playerid, TimeTD);
            }
            if (PlayerData[playerid][pGPS] && PlayerData[playerid][pGPSOn])
            {
                PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);
            }
            if (!PlayerData[playerid][pToggleHUD])
            {
                PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
                PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
            }
        }
    }
}

CMD:toggle(playerid, params[])
{
    if (PlayerData[playerid][pLogged])
    {
        ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
    }
    return 1;
}

CMD:otoggle(playerid, params[])
{
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(tog)gle [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Textdraws, OOC, Global, Phone, Whisper, Bugged, Newbie, PrivateRadio, Radio, Streams, News");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: SpawnCam, HUD, Admin, Helper, VIP, Reports, Faction, Gang, PM, Points, Turfs");
        return 1;
    }
    if (!strcmp(params, "textdraws", true))
    {
        if (!PlayerData[playerid][pToggleTextdraws])
        {
            PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
            PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
            PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);



            TextDrawHideForPlayer(playerid, TimeTD);

            PlayerData[playerid][pToggleTextdraws] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Textdraws toggled. You will no longer see any textdraws.");
        }
        else
        {
            if (PlayerData[playerid][pGPSOn])
            {
                PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);
            }
            if (PlayerData[playerid][pWatchOn])
            {
                TextDrawShowForPlayer(playerid, TimeTD);
            }
            if (!PlayerData[playerid][pToggleHUD])
            {
                PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
                PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
            }


            PlayerData[playerid][pToggleTextdraws] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Textdraws enabled. You will now see textdraws again.");
        }
    }
    else if (!strcmp(params, "ooc", true))
    {
        if (!PlayerData[playerid][pToggleOOC])
        {
            PlayerData[playerid][pToggleOOC] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "OOC chat toggled. You will no longer see any messages in /o.");
        }
        else
        {
            PlayerData[playerid][pToggleOOC] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "OOC chat enabled. You will now see messages in /o again.");
        }
    }
    else if (!strcmp(params, "points", true))
    {
        if (!PlayerData[playerid][pTogglePoints])
        {
            PlayerData[playerid][pTogglePoints] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Points toggled. You will no longer see any point messages.");
        }
        else
        {
            PlayerData[playerid][pTogglePoints] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Points enabled. You will now see point messages.");
        }
    }
    else if (!strcmp(params, "turfs", true))
    {
        if (!PlayerData[playerid][pToggleTurfs])
        {
            PlayerData[playerid][pToggleTurfs] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Turfs toggled. You will no longer see any turf messages.");
        }
        else
        {
            PlayerData[playerid][pToggleTurfs] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Turfs enabled. You will now see turf messages.");
        }
    }
    else if (!strcmp(params, "global", true))
    {
        if (!PlayerData[playerid][pToggleGlobal])
        {
            PlayerData[playerid][pToggleGlobal] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Global chat toggled. You will no longer see any messages in /g.");
        }
        else
        {
            PlayerData[playerid][pToggleGlobal] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Global chat enabled. You can now speak to other players in /g.");
        }
    }
    else if (!strcmp(params, "phone", true))
    {
        if (!PlayerData[playerid][pTogglePhone])
        {
            if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't do this while in a call.");
            }

            PlayerData[playerid][pTogglePhone] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Phone toggled. You will no longer receive calls or texts.");
        }
        else
        {
            PlayerData[playerid][pTogglePhone] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Phone enabled. You can now receive calls and texts again.");
        }
    }
    else if (!strcmp(params, "whisper", true))
    {
        if (!PlayerData[playerid][pToggleWhisper])
        {
            PlayerData[playerid][pToggleWhisper] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Whispers toggled. You will no longer receive any whispers from players.");
        }
        else
        {
            PlayerData[playerid][pToggleWhisper] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Whispers enabled. You will now receive whispers from players again.");
        }
    }
    else if (!strcmp(params, "pm", true))
    {
        if (!PlayerData[playerid][pTogglePM])
        {
            PlayerData[playerid][pTogglePM] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "PM toggled. You will no longer receive any private message from players.");
        }
        else
        {
            PlayerData[playerid][pTogglePM] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "PM enabled. You will now receive private message from players again.");
        }
    }
    else if (!strcmp(params, "bugged", true))
    {
        if (GetPlayerFaction(playerid) != FACTION_FEDERAL)
            return SendClientMessage(playerid, COLOR_GREY, "You must be a federal agent to use the bug channel.");

        if (!PlayerData[playerid][pToggleBug])
        {
            PlayerData[playerid][pToggleBug] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Bug channel toggled. You will no longer receive any recordings from bugged players.");
        }
        else
        {
            PlayerData[playerid][pToggleBug] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Bug channel enabled. You will now receive recordings from bugged players again.");
        }
    }
    else if (!strcmp(params, "admin", true))
    {
        if (!IsAdmin(playerid) && !PlayerData[playerid][pDeveloper] && !PlayerData[playerid][pFormerAdmin])
        {
            return SendUnautorizedTogF(playerid);
        }

        if (!PlayerData[playerid][pToggleAdmin])
        {
            PlayerData[playerid][pToggleAdmin] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Admin chat toggled. You will no longer see any messages in admin chat.");
        }
        else
        {
            PlayerData[playerid][pToggleAdmin] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Admin chat enabled. You will now see messages in admin chat again.");
        }
    }
    else if (!strcmp(params, "reports", true))
    {
        if (!IsAdmin(playerid))
        {
            return SendUnautorizedTogF(playerid);
        }

        if (!PlayerData[playerid][pToggleReports])
        {
            PlayerData[playerid][pToggleReports] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Reports toggled. You will no longer see any incoming reports.");
        }
        else
        {
            PlayerData[playerid][pToggleReports] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Reports enabled. You will now see incoming reports again.");
        }
    }
    else if (!strcmp(params, "helper", true))
    {
        if (!PlayerData[playerid][pHelper])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not a helper and therefore cannot toggle this feature.");
        }

        if (!PlayerData[playerid][pToggleHelper])
        {
            PlayerData[playerid][pToggleHelper] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Helper chat toggled. You will no longer see any messages in helper chat.");
        }
        else
        {
            PlayerData[playerid][pToggleHelper] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Helper chat enabled. You will now see messages in helper chat again.");
        }
    }
    else if (!strcmp(params, "newbie", true))
    {
        if (!PlayerData[playerid][pToggleNewbie])
        {
            PlayerData[playerid][pToggleNewbie] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Newbie chat toggled. You will no longer see any messages in newbie chat.");
        }
        else
        {
            PlayerData[playerid][pToggleNewbie] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Newbie chat enabled. You will now see messages in newbie chat again.");
        }
    }
    else if (!strcmp(params, "privateradio", true))
    {
        if (!PlayerData[playerid][pPrivateRadio])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have a private radio.");
        }

        if (!PlayerData[playerid][pTogglePR])
        {
            PlayerData[playerid][pTogglePR] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Private radio toggled. You will no longer receive any messages on your private radio.");
        }
        else
        {
            PlayerData[playerid][pTogglePR] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Private radio enabled. You will now receive messages on your private radio again.");
        }
    }
    else if (!strcmp(params, "radio", true))
    {
        if (PlayerData[playerid][pFaction] == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction and therefore can't toggle your radio.");
        }

        if (!PlayerData[playerid][pToggleRadio])
        {
            PlayerData[playerid][pToggleRadio] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Radio chat toggled. You will no longer receive any messages on your radio.");
        }
        else
        {
            PlayerData[playerid][pToggleRadio] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Radio chat enabled. You will now receive messages on your radio again.");
        }
    }
    else if (!strcmp(params, "streams", true))
    {
        if (!PlayerData[playerid][pToggleMusic])
        {
            PlayerData[playerid][pToggleMusic] = 1;
            StopAudioStreamForPlayer(playerid);
            SendClientMessage(playerid, COLOR_AQUA, "Music streams toggled. You will no longer hear any music played locally & globally.");
        }
        else
        {
            PlayerData[playerid][pToggleMusic] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Music streams enabled. You will now hear music played locally & globally again.");
        }
    }
    else if (!strcmp(params, "vip", true))
    {
        if (!PlayerData[playerid][pDonator])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not a VIP member and therefore cannot toggle this feature.");
        }

        if (!PlayerData[playerid][pToggleVIP])
        {
            PlayerData[playerid][pToggleVIP] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "VIP chat toggled. You will no longer see any messages in VIP chat.");
        }
        else
        {
            PlayerData[playerid][pToggleVIP] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "VIP chat enabled. You will now see messages in VIP chat again.");
        }
    }
    else if (!strcmp(params, "faction", true))
    {
        if (PlayerData[playerid][pFaction] == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction and therefore can't toggle this chat.");
        }

        if (!PlayerData[playerid][pToggleFaction])
        {
            PlayerData[playerid][pToggleFaction] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Faction chat toggled. You will no longer see any messages in faction chat.");
        }
        else
        {
            PlayerData[playerid][pToggleFaction] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Faction chat enabled. You will now see messages in faction chat again.");
        }
    }
    else if (!strcmp(params, "gang", true))
    {
        if (PlayerData[playerid][pGang] == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not a gang member and therefore can't toggle this chat.");
        }

        if (!PlayerData[playerid][pToggleGang])
        {
            PlayerData[playerid][pToggleGang] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Gang chat toggled. You will no longer see any messages in gang chat.");
        }
        else
        {
            PlayerData[playerid][pToggleGang] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Gang chat enabled. You will now see messages in gang chat again.");
        }
    }
    else if (!strcmp(params, "news", true))
    {
        if (!PlayerData[playerid][pToggleNews])
        {
            PlayerData[playerid][pToggleNews] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "News chat toggled. You will no longer see any news broadcasts.");
        }
        else
        {
            PlayerData[playerid][pToggleNews] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "News chat enabled. You will now see news broadcasts again.");
        }
    }
    else if (!strcmp(params, "lands", true))
    {
        callcmd::showlands(playerid, "\1");
    }
    else if (!strcmp(params, "turfs", true))
    {
        callcmd::turfs(playerid, "\1");
    }
    else if (!strcmp(params, "spawncam", true))
    {
        if (!PlayerData[playerid][pToggleCam])
        {
            PlayerData[playerid][pToggleCam] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "Spawn camera toggled. You will no longer see the camera effects upon spawning.");
        }
        else
        {
            PlayerData[playerid][pToggleCam] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "Spawn camera enabled. You will now see the camera effects when you spawn again.");
        }
    }
    else if (!strcmp(params, "hud", true))
    {
        if (!PlayerData[playerid][pToggleHUD])
        {
            PlayerData[playerid][pToggleHUD] = 1;
            SendClientMessage(playerid, COLOR_AQUA, "HUD toggled. You will no longer see your health & armor indicators.");

            PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
            PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);

        }
        else
        {
            PlayerData[playerid][pToggleHUD] = 0;
            SendClientMessage(playerid, COLOR_AQUA, "HUD enabled. You will now see your health & armor indicators again.");

            PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
            PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(tog)gle [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: Textdraws, OOC, Global, Phone, Whisper, Bugged, Newbie, PrivateRadio, Radio, Streams, News");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: SpawnCam, HUD, Admin, Helper, VIP, Reports, Faction, Gang");
    }

    return 1;
}

CMD:changepass(playerid, params[])
{
    Dialog_Show(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "{00aa00}%s{FFFFFF} | Change password", "Please change your password for security purposes\nEnter your new password below:", "Submit", "Cancel", GetServerName());
    return 1;
}

CMD:frisk(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessageEx(playerid, COLOR_SYNTAX, "USAGE: /frisk [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot frisk yourself.");
    }

    if ((IsLawEnforcement(playerid) && PlayerData[targetid][pCuffed]) || GetPlayerAnimationIndex(targetid) == 1441)
    {
        FriskPlayer(playerid, targetid);
    }
    else
    {
        PlayerData[targetid][pFriskOffer] = playerid;

        SendClientMessageEx(targetid, COLOR_AQUA, "* %s is attempting to frisk you for illegal items. (/accept frisk)", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent a frisk offer to %s.", GetRPName(targetid));
    }

    return 1;
}

CMD:propose(playerid, params[])
{
    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /propose [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 3.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 2241.9761,-1362.9207,1500.9048))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in church.");
    }
    if (PlayerData[playerid][pCash] < 25000 || PlayerData[targetid][pCash] < 25000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You both need to have atleast $25,000 to have a wedding.");
    }
    if (PlayerData[playerid][pMarriedTo] != -1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're already married to %s.", PlayerData[playerid][pMarriedName]);
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't marry yourself faggot.");
    }
    PlayerData[targetid][pMarriageOffer] = playerid;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has asked you to marry them, Please be careful when chosing a partner, It will cost both parties $25,000. (/accept marriage)", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a proposal for marriage.", GetRPName(targetid));
    return 1;
}
CMD:divorce(playerid, params[])
{
    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /divorce [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 3.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (PlayerData[playerid][pMarriedTo] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't even married.");
    }
    if (PlayerData[playerid][pMarriedTo] != PlayerData[targetid][pID])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You aren't married to that person.");
    }
    PlayerData[targetid][pMarriageOffer] = playerid;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has asked you to divorce them (/accept divorce)", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a request for divorce.", GetRPName(targetid));
    return 1;
}

CMD:shakehand(playerid, params[])
{
    new targetid, type;

    if (sscanf(params, "ui", targetid, type))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /shakehand [playerid] [type (1-6)]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't shake your own hand.");
    }
    if (!(1 <= type <= 6))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid type. Valid types range from 1 to 6.");
    }

    PlayerData[targetid][pShakeOffer] = playerid;
    PlayerData[targetid][pShakeType] = type;

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has offered to shake your hand. (/accept handshake)", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have sent %s a handshake offer.", GetRPName(targetid));
    return 1;
}

CMD:grabskin(playerid, params[])
{
    if (PlayerData[playerid][pLevel] < 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only use this command if you are level 2+.");
    }

    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot do that for the moment.");
    }

    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be onfoot in order to pickup skin.");
    }

    new targetid = GetClosestPlayer(playerid);
    if (IsPlayerConnected(targetid) && PlayerData[targetid][pInjured] && IsPlayerNearPlayer(playerid, targetid, 5.0))
    {

        if ((PlayerData[playerid][pFaction] == -1 && PlayerData[targetid][pFaction] != -1) ||
            (PlayerData[playerid][pFaction] != -1 && PlayerData[targetid][pFaction] == -1))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You cannot take this clothes.");
        }
        SetScriptSkin(playerid, PlayerData[targetid][pSkin]);
        SetScriptSkin(targetid, (PlayerData[targetid][pGender] == PlayerGender_Male) ? 40 : 200);
        SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s has stole %s's clothes.", GetRPName(playerid), GetRPName(targetid));
        return 1;
    }
    return 1;
}

CMD:usecigar(playerid, params[])
{
    if (!PlayerData[playerid][pCigars])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any cigars left.");
    }

    PlayerData[playerid][pCigars]--;

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
    ShowActionBubble(playerid, "* %s lights up a cigar and starts to smoke it.", GetRPName(playerid));

    DBQuery("UPDATE "#TABLE_USERS" SET cigars = %i WHERE uid = %i", PlayerData[playerid][pCigars], PlayerData[playerid][pID]);

    return 1;
}
CMD:bloodtest(playerid, params[])
{
    if (!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
    }
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /showid [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself.");
    }
    if (gettime() - PlayerData[targetid][pLastDrug] < 180)
    {
        return SendClientMessageEx(playerid, COLOR_RED, "** Blood Test ** %s's blood containts toxic substance due to the use of drugs.", GetRPName(targetid));
    }
    else
    {
        return SendClientMessageEx(playerid, COLOR_GREEN, "** Blood Test ** %s's blood is clean.", GetRPName(targetid));
    }
}
CMD:usedrug(playerid, params[])
{
    if (gettime() - PlayerData[playerid][pLastDrug] < 10)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only consume drugs every 10 seconds. Please wait %i more seconds.", 10 - (gettime() - PlayerData[playerid][pLastDrug]));
    }
    if (PlayerData[playerid][pDrugsUsed] >= 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are stoned and therefore can't consume anymore drugs right now.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /usedrug [weed | cocaine | heroin | painkillers]");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to use drugs. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    if (!strcmp(params, "weed", true))
    {
        if (PlayerData[playerid][pWeed] < 2)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least two grams of weed.");
        }

        if (PlayerData[playerid][pAddictUpgrade] > 0)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra health.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0));
        }

        GivePlayerHealth(playerid, 20.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

        PlayerData[playerid][pWeed] -= 2;
        PlayerData[playerid][pDrugsUsed]++;
        PlayerData[playerid][pLastDrug] = gettime();

        if (PlayerData[playerid][pDrugsUsed] >= 4)
        {
            AwardAchievement(playerid, ACH_HighTimes);
            GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
            PlayerData[playerid][pDrugsTime] = 30;
        }

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
        ShowActionBubble(playerid, "* %s smokes two grams of weed.", GetRPName(playerid));

        DBQuery("UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);

    }
    else if (!strcmp(params, "cocaine", true))
    {
        if (PlayerData[playerid][pCocaine] < 2)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least two grams of cocaine.");
        }

        if (PlayerData[playerid][pAddictUpgrade] > 0)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra armor.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0));
        }

        GivePlayerArmour(playerid, 10.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

        PlayerData[playerid][pCocaine] -= 2;
        PlayerData[playerid][pDrugsUsed]++;
        PlayerData[playerid][pLastDrug] = gettime();

        if (PlayerData[playerid][pDrugsUsed] >= 4)
        {
            AwardAchievement(playerid, ACH_HighTimes);
            GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
            PlayerData[playerid][pDrugsTime] = 30;
        }

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
        ShowActionBubble(playerid, "* %s snorts two grams of cocaine.", GetRPName(playerid));

        DBQuery("UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);

    }
    else if (!strcmp(params, "heroin", true))
    {
        if (PlayerData[playerid][pHeroin] < 2)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need at least two grams of heroin.");
        }

        if (PlayerData[playerid][pAddictUpgrade] > 0)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f/%.1f extra health & armor.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0), (PlayerData[playerid][pAddictUpgrade] * 5.0));
        }

        GivePlayerHealth(playerid, 10.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));
        GivePlayerArmour(playerid, 10.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

        PlayerData[playerid][pHeroin] -= 2;
        PlayerData[playerid][pDrugsUsed] += 2;
        PlayerData[playerid][pLastDrug] = gettime();

        if (PlayerData[playerid][pDrugsUsed] >= 4)
        {
            AwardAchievement(playerid, ACH_HighTimes);
            GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
            PlayerData[playerid][pDrugsTime] = 30;
        }

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
        ShowActionBubble(playerid, "* %s smokes two grams of Heroin.", GetRPName(playerid));

        DBQuery("UPDATE "#TABLE_USERS" SET heroin = %i WHERE uid = %i", PlayerData[playerid][pHeroin], PlayerData[playerid][pID]);

    }
    else if (!strcmp(params, "painkillers", true))
    {
        if (PlayerData[playerid][pPainkillers] <= 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have any painkillers left.");
        }

        if (PlayerData[playerid][pAddictUpgrade] > 0)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW3, "Addict Perk: Your level %i/3 addict perk gave you %.1f extra health.", PlayerData[playerid][pAddictUpgrade], (PlayerData[playerid][pAddictUpgrade] * 5.0));
        }

        GivePlayerHealth(playerid, 30.0 + (PlayerData[playerid][pAddictUpgrade] * 5.0));

        PlayerData[playerid][pPainkillers] -= 1;
        PlayerData[playerid][pReceivingAid] = 1;
        PlayerData[playerid][pDrugsUsed] += 2;
        PlayerData[playerid][pLastDrug] = gettime();

        if (PlayerData[playerid][pDrugsUsed] >= 4)
        {
            AwardAchievement(playerid, ACH_HighTimes);
            GameTextForPlayer(playerid, "~p~shit... you stoned as hell duuuude...", 5000, 1);
            PlayerData[playerid][pDrugsTime] = 30;
        }

        ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0);
        ShowActionBubble(playerid, "* %s pops a painkiller in their mouth.", GetRPName(playerid));

        DBQuery("UPDATE "#TABLE_USERS" SET painkillers = %i WHERE uid = %i", PlayerData[playerid][pPainkillers], PlayerData[playerid][pID]);

    }

    return 1;
}

CMD:gps(playerid, params[])
{
    if (!PlayerData[playerid][pGPS])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a GPS. You can buy one at 24/7.");
    }

    if (!PlayerData[playerid][pGPSOn])
    {
        if (PlayerData[playerid][pToggleTextdraws])
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't turn on your GPS as you have textdraws toggled! (/toggle textdraws)");
        }

        PlayerData[playerid][pGPSOn] = 1;

        PlayerTextDrawSetString(playerid, PlayerData[playerid][pGPSText], "Loading...");
        PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);

        ShowActionBubble(playerid, "* %s turns on their GPS.", GetRPName(playerid));
    }
    else
    {
        PlayerData[playerid][pGPSOn] = 0;
        PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
        ShowActionBubble(playerid, "* %s turns off their GPS.", GetRPName(playerid));
    }

    return 1;
}

CMD:fixmyvw(playerid, params[])
{
    if (PlayerData[playerid][pPaintball] > 0 || IsPlayerInEvent(playerid) || PlayerData[playerid][pJailType] != JailType_None)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    if (GetPlayerVirtualWorld(playerid) > 0 && GetPlayerInterior(playerid) == 0)
    {
        SetPlayerVirtualWorld(playerid, 0);
        SendClientMessage(playerid, COLOR_GREY, "Your virtual world has been fixed.");
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Your virtual world is not bugged at the moment.");
    }

    return 1;
}

CMD:stuck(playerid, params[])
{
    if (PlayerData[playerid][pTazedTime] > 0 ||
        PlayerData[playerid][pInjured] > 0 ||
        PlayerData[playerid][pHospital] > 0 ||
        PlayerData[playerid][pCuffed] > 0 ||
        PlayerData[playerid][pTied] > 0 ||
        PlayerData[playerid][pAcceptedHelp] ||
        PlayerData[playerid][pFishTime] > 0 ||
        IsPlayerMining(playerid) ||
        IsPlayerLootingInRobbery(playerid) ||
        GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY ||
        IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (gettime() - PlayerData[playerid][pLastStuck] < 5)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command every 5 seconds. Please wait %i more seconds.", 5 - (gettime() - PlayerData[playerid][pLastStuck]));
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(playerid, x, y, z + 0.5);

    ClearAnimations(playerid);
    TogglePlayerControllableEx(playerid, 1);

    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0, 1);
    SendClientMessage(playerid, COLOR_GREY, "You are no longer stuck.");

    PlayerData[playerid][pLastStuck] = gettime();
    return 1;
}

CMD:tie(playerid, params[])
{
    new targetid;

    if (PlayerData[playerid][pJailType] != JailType_None)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie while you are in jail.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /tie [playerid]");
    }
    if (PlayerData[playerid][pRope] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any ropes left.");
    }
    if (targetid == playerid || !IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie yourself.");
    }
    if (PlayerData[targetid][pJailType] != JailType_None)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie this player when he is in jail.");
    }
    if (PlayerData[targetid][pPaintball])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't cuff this player when he is in paintball.");
    }
    if (PlayerData[targetid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already handcuffed.");
    }
    if (PlayerData[targetid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already tied. /untie to free them.");
    }
    if (PlayerData[targetid][pAcceptedHelp])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie a helper who is assisting someone.");
    }
    if (PlayerData[targetid][pAdminDuty])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't tie an on duty administrator.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to tie anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }
    if (IsPlayerInEvent(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't tie player while you are in an event.");
    }
    new bool:canHandcuff;

    if (PlayerData[targetid][pTazedTime] > 0)
        canHandcuff = true;

    if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_HANDSUP)
        canHandcuff = true;

    if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DUCK)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1441)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1151)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1150)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 960)
        canHandcuff = true;

    if (GetPlayerAnimationIndex(targetid) == 1701)
        canHandcuff = true;

    if (!canHandcuff)
    {
        return SendClientMessage(playerid, COLOR_ADM, "That player needs to be crouched, have their hands up or be on the floor.");
    }

    PlayerData[playerid][pRope]--;

    DBQuery("UPDATE "#TABLE_USERS" SET rope = %i WHERE uid = %i", PlayerData[playerid][pRope], PlayerData[playerid][pID]);


    GameTextForPlayer(targetid, "~r~Tied", 3000, 3);
    ShowActionBubble(playerid, "* %s ties %s with a rope.", GetRPName(playerid), GetRPName(targetid));

    TogglePlayerControllableEx(targetid, 0);
    PlayerData[targetid][pTied] = 1;
    return 1;
}

CMD:untie(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /untie [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't untie yourself.");
    }
    if (!PlayerData[targetid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not tied.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to untie anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    GameTextForPlayer(targetid, "~g~Untied", 3000, 3);
    ShowActionBubble(playerid, "* %s unties the rope from %s.", GetRPName(playerid), GetRPName(targetid));

    TogglePlayerControllableEx(targetid, 1);
    PlayerData[targetid][pTied] = 0;
    return 1;
}

CMD:firstaid(playerid, params[])
{
    return SendClientMessage(playerid, COLOR_GREY, "Command is disabled at the moment");

    if (PlayerData[playerid][pFirstAid] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any first aid kits.");
    }
    new targetid = playerid;
    if (!isnull(params) && sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /firstaid [targetid]");
    }
    if (targetid != playerid && (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }

    if (GetPlayerHealthEx(targetid) >= 100)
    {
        if (playerid == targetid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can only use a first aid kit if your health is below 100.");
        }
        else
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can only use a first aid kit if the player health is below 100.");
        }
    }

    if (PlayerData[targetid][pReceivingAid])
    {
        if (playerid == targetid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have already used a first aid kit.");
        }
        else
        {
            return SendClientMessage(playerid, COLOR_GREY, "This player has already received a first aid kit.");
        }
    }

    if (PlayerData[targetid][pInjured])
    {
        if (playerid == targetid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use first aid kit while injured.");
        }
        else if (GetPlayerHealthEx(targetid) < 80)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This player need to wait an ambulance or a medic.");
        }
    }

    PlayerData[playerid][pFirstAid]--;
    PlayerData[targetid][pReceivingAid] = 1;

    DBQuery("UPDATE "#TABLE_USERS" SET firstaid = %i WHERE uid = %i", PlayerData[playerid][pFirstAid], PlayerData[playerid][pID]);

    if (playerid == targetid)
    {
        ShowActionBubble(playerid, "* %s administers first aid to their self.", GetRPName(playerid));
    }
    else
    {
        ShowActionBubble(playerid, "* %s administers first aid to %s.", GetRPName(playerid), GetRPName(targetid));
    }
    SendClientMessage(targetid, COLOR_WHITE, "HINT: The first aid kit is in effect until your health is full.");
    return 1;
}

CMD:scanner(playerid, params[])
{
    if (!PlayerData[playerid][pPoliceScanner])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a police scanner.");
    }

    if (!PlayerData[playerid][pScannerOn])
    {
        PlayerData[playerid][pScannerOn] = 1;
        ShowActionBubble(playerid, "* %s turns on their police scanner.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_WHITE, "You will now hear messages from emergency and department chats.");
    }
    else
    {
        PlayerData[playerid][pScannerOn] = 0;
        ShowActionBubble(playerid, "* %s turns off their police scanner.", GetRPName(playerid));
    }

    return 1;
}

CMD:bodykit(playerid, params[])
{
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
    }
    if (PlayerData[playerid][pBodykits] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have no bodywork kits which you can use.");
    }
    if (gettime() - PlayerData[playerid][pLastRepair] < 60)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can only repair a vehicle every 60 seconds. Please wait %i more seconds.", 60 - (gettime() - PlayerData[playerid][pLastRepair]));
    }

    PlayerData[playerid][pBodykits]--;
    PlayerData[playerid][pLastRepair] = gettime();

    DBQuery("UPDATE "#TABLE_USERS" SET bodykits = %i WHERE uid = %i", PlayerData[playerid][pBodykits], PlayerData[playerid][pID]);


    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    RepairVehicle(GetPlayerVehicleID(playerid));
    ShowActionBubble(playerid, "* %s repairs the health and bodywork on their vehicle.", GetRPName(playerid));
    return 1;
}

Dialog:DIALOG_RULES(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on cheats & unfair advantage", "All types of cheating, hacking, and unfair advantages are prohibited on this server", "Close", "");
            case 1: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on exploits", "Any and all exploits, such as QS, CS, NJ, script exploits, etc.\nIS STRICLY PROHIBITED!", "Close", "");
            case 2: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on advertisments", "Advertising anything other than in-game entities/items is prohibited", "Close", "");
            case 3: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on death-match", "Deathmatching is when you kill another player for an invalid (non-RP) reason.\nThis is strictly prohibited on this server", "Close", "");
            case 4: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on spawn-killing", "Spawn-killing is similar to deathmatch, with worse punishments.\nDo not kill anyone that has just spawned!", "Close", "");
            case 5: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on revenge-killing", "Killing a player because you got killed by them is not allowed!\nThis rule is expected to be followed during turfs.", "Close", "");
            case 6: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on car raming", "Ramming player without a valid in character reason is not allowed\nThis includes car-parking", "Close", "");
            case 7: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on heli-blading", "Heli-blading people is not allowed.", "Close", "");
            case 8: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on meta-gaming", "Using out of character information for in character purposes is not allowed.", "Close", "");
            case 9: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on money-farming", "Money-farming is when you create new accounts to leech spawn money\nThis will always result in a permanant ban.", "Close", "");
            case 10: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on lying to admins", "Intentionally lying to an administrator is not allowed.", "Close", "");
            case 11: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on robbery", "You can only rob the same player ONCE in 24 hours.\nPlease follow regulations regarding max. robbery, etc (available at %s)", "Close", "", GetServerWebsite());
            case 12: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{FFFF00}Policy on scamming", "Donation scams are prohibited\nPlease follow regulations regarding max. scamming, etc (available at %s)", "Close", "", GetServerWebsite());
            case 13: Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Full list of rules", "{FFFFFF}Please visit {00aa00} %s {FFFFFF} for a complete list of rules.", "Close", "", GetServerWebsite());
        }
    }
    return 1;
}

CMD:showrules(playerid, params[])
{
    new giveplayerid;
    if (!IsAdmin(playerid) && PlayerData[playerid][pHelper] < 2)
    {
        return SendUnauthorized(playerid);
    }

    if (sscanf(params,"i",giveplayerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "/showrules [playerid]");
    }
    if (!IsPlayerConnected(giveplayerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not connected");
    }
    return callcmd::rules(giveplayerid, params);
}

CMD:rules(playerid, params[])
{
    return Dialog_Show(playerid, DIALOG_RULES, DIALOG_STYLE_LIST, "List of Server Rules", "No third-party modifications such as cheats\nNo exploiting\nNo non-RP advertisements\nNo death-match\nNo spawn-killing\nNo revenge-killing\nNo non-RP car raming.\nNo heli-blading\nNo meta-gaming\nNo money farming\nNo lying to administrators\nRobbery Policy\nScamming Policy\nList of all rules may be available at %s", "Close", "", GetServerWebsite());
}

CMD:fpm(playerid, params[])
{

    if (!firstperson[playerid])
    {
        firstperson[playerid] = 1;
        new iObjectID = CreateDynamicObjectEx(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        SetPVarInt(playerid, "FP_OBJ", iObjectID);
        AttachObjectToPlayer(iObjectID, playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
        AttachCameraToObject(playerid, iObjectID);
    }
    else
    {

        firstperson[playerid] = 0;
        DestroyObject(GetPVarInt(playerid, "FP_OBJ"));
        DeletePVar(playerid, "FP_OBJ");
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}

CMD:cursor(playerid, params)
{
    SelectTextDraw(playerid, -1);
    return 1;
}
