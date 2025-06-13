/// @file      Payday.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static gPaycheck;
static PayCheckCode[MAX_PLAYERS];

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("Stand here to collect\nyour pay if you miss it.", COLOR_YELLOW, 1661.5, 970.42, 683.68, 10.0);
    gPaycheck = CreateDynamicPickup(1274, 1, 1661.5, 970.42, 683.68);
}

hook OnPlayerConnect(playerid)
{
    PayCheckCode[playerid] = 0;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
    if (pickupid == gPaycheck && PlayerData[playerid][pPaycheck] > 0 &&
        IsPlayerInRangeOfPoint(playerid, 5.0, 1661.5, 970.42, 683.68))
    {
        new string[20];
        format(string, sizeof(string), "~g~+$%i", PlayerData[playerid][pPaycheck]);
        GameTextForPlayer(playerid, string, 5000, 1);

        GivePlayerCash(playerid, PlayerData[playerid][pPaycheck]);
        PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);

        DBQuery("UPDATE "#TABLE_USERS" SET paycheck = 0 WHERE uid = %i", PlayerData[playerid][pID]);
        PlayerData[playerid][pPaycheck] = 0;
    }
}

publish LastAlertPayCheck(playerid)
{
    if (PayCheckCode[playerid] != 0)
    {
        ShowPlayerFooter(playerid, "~w~Type /signcheck");
        SendClientMessage(playerid, COLOR_WHITE, "You have one minute left before your paycheck code expires. Please type /signcheck to get your paycheck.");
        SetTimerEx("DestroyCheck", 60000, false, "i", playerid);
    }
}

publish DestroyCheck(playerid)
{
    if (PayCheckCode[playerid] != 0)
    {
        PayCheckCode[playerid] = 0;
        SendClientMessage(playerid, COLOR_WHITE, "Your paycheck code expired. Please remember to use /signcheck next time.");
    }
}

Dialog:DIALOG_PAYCHECK(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;
    new
        szMessage[150];
    if (strlen(inputtext) < 1)
    {
        format(szMessage, sizeof(szMessage), "You must enter the check code before signing.\n\nCheck code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
        Dialog_Show(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, "Sign check", szMessage, "Sign check","Cancel");
        return 1;
    }
    if (!IsNumeric(inputtext))
    {
        format(szMessage, sizeof(szMessage), "Wrong check code. The check code consists out of numbers only.\n\nCheck code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
        Dialog_Show(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, "Sign check", szMessage, "Sign check","Cancel");
        return 1;
    }
    if (strlen(inputtext) > 6 || (strlen(inputtext) > 0 && strlen(inputtext) < 6))
    {
        format(szMessage, sizeof(szMessage), "Wrong check code. The check code consists out of 6 digits.\n\nCheck code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
        Dialog_Show(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, "Sign check", szMessage, "Sign check","Cancel");
        return 1;
    }
    new code = strval(inputtext);
    if (code == PayCheckCode[playerid])
    {
        if (GetWantedLevel(playerid) < 6 && PlayerData[playerid][pCash] < 0)
        {
            GiveWantedLevel(playerid, 1);
            SendClientMessage(playerid, COLOR_WHITE, "You have recieved wanted star for not paying the tax to the government the police coming to arrest you.");
        }
        SendPaycheck(playerid);
        PayCheckCode[playerid] = 0;
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "Wrong check code.");
    }
    return 1;
}

hook OnNewHour(timestamp, hour)
{
    new budget;
    for (new i = 0; i < MAX_FACTIONS; i ++)
    {
        if (FactionInfo[i][fType] != FACTION_NONE)
        {
            budget += FactionInfo[i][fBudget] - GetTotalFactionPay(i);
        }
    }
    AddToTaxVault(-budget);

    foreach(new i : Player)
    {
        if (PlayerData[i][pLogged] && !PlayerData[i][pKicked])
        {
            if (GetAFKTime(i) > 900)
            {
                SendClientMessage(i, COLOR_LIGHTRED, "You didn't receive a paycheck this hour as you were AFK for more than 15 minutes.");
            }
            else if (PlayerData[i][pMinutes] < 25)
            {
                SendClientMessage(i, COLOR_LIGHTRED, "You are ineligible for a paycheck as you played less than 25 minutes this hour.");
            }
            else
            {
                new code = Random(100000, 999999);
                PayCheckCode[i] = code;

                SendClientMessage(i, COLOR_GREY,"_______________________________________________________________");
                SendClientMessage(i, COLOR_WHITE,"Information for tax on paychecks: {33CCFF}/taxhelp");
                SendClientMessage(i, COLOR_GREY,"_______________________________________________________________");
                SendClientMessage(i, COLOR_WHITE,"Sign the check to receive your paycheck.");
                SendClientMessage(i, COLOR_AQUA, "Type /signcheck");
                SendClientMessage(i, COLOR_WHITE,"You have 5 minutes to sign the check before it becomes invalid.");
                SendClientMessage(i, COLOR_GREY,"_______________________________________________________________");

                GameTextForPlayer(i, "~w~Type /signcheck", 2500, 1);
                SetTimerEx("LastAlertPayCheck", 240000, false, "i", i);
            }
            if (GetPlayerFaction(i) == FACTION_GOVERNMENT)
            {
                SendClientMessageEx(i, COLOR_YELLOW2, "%s were taken out of the tax vault for every faction's paycheck.", FormatCash(budget));
            }
        }
    }
}

SendPaycheck(playerid)
{
    // Paycheck amounts are temporary until a job system is put in place.

    PlayerData[playerid][pPaycheck] += min(PlayerData[playerid][pLevel], 21) * 250;
    new str[2000];
    new paycheck = PlayerData[playerid][pPaycheck];
    new interest, rate;
    new tax = (paycheck / 100) * GetTaxPercent();
    new rentCost = 0, rentHouseid = -1; // temp
    new total = paycheck - tax;

    // If the player is a VIP, adjust his interest rate accordingly.
    if (PlayerData[playerid][pDonator] == 0)
    {
        rate = 1;
    }
    if (PlayerData[playerid][pDonator] == 1)
    {
        rate = 3;
    }
    if (PlayerData[playerid][pDonator] == 2)
    {
        rate = 6;
    }
    if (PlayerData[playerid][pDonator] == 3)
    {
        rate = 8;
    }

    //Calculate the interest due.
    interest = (PlayerData[playerid][pBank] / 1000) * rate;

    //If the calculated interest is above $25000, then we need to shut that shit down and set the interest to $25,000 to avoid the previous exploit.
    if (interest > 25000)
    {
        interest = 25000;
    }

    total += interest;

    AppendFormat(str, sizeof(str), "_____________ Paycheck _______________\n");
    AppendFormat(str, sizeof(str), "Paycheck: {33CC33}+%s\n", FormatCash(paycheck));
    if (PlayerData[playerid][pFaction] >= 0 && FactionInfo[PlayerData[playerid][pFaction]][fPaycheck][PlayerData[playerid][pFactionRank]] > 0)
    {
        AppendFormat(str, sizeof(str), "Faction Pay: {33CC33}+%s\n", FormatCash(FactionInfo[PlayerData[playerid][pFaction]][fPaycheck][PlayerData[playerid][pFactionRank]]));
        total += FactionInfo[PlayerData[playerid][pFaction]][fPaycheck][PlayerData[playerid][pFactionRank]];
    }

    AppendFormat(str, sizeof(str), "Interest: {33CC33}+%s {C8C8C8}(rate: %.1f) (max: $25,000)\n", FormatCash(interest), floatdiv(float(rate), 10));
    AppendFormat(str, sizeof(str), "Income Tax: {FF6347}-%s {C8C8C8}(%i percent)\n", FormatCash(tax), GetTaxPercent());

    if (PlayerData[playerid][pRentingHouse])
    {
        foreach(new i : House)
        {
            if (HouseInfo[i][hExists] && HouseInfo[i][hID] == PlayerData[playerid][pRentingHouse] && HouseInfo[i][hRentPrice] > 0)
            {
                rentCost = HouseInfo[i][hRentPrice];
                rentHouseid = i;
                if (total >= rentCost || PlayerData[playerid][pBank] >= rentCost)
                {
                    if (total >= rentCost)
                    {
                        total -= rentCost;
                    }
                    else
                    {
                        PlayerData[playerid][pBank] -= rentCost;
                    }

                    AppendFormat(str, sizeof(str), "Rent Paid: {FF6347}-%s\n", FormatCash(rentCost));
                    HouseInfo[rentHouseid][hCash] += rentCost;

                    DBQuery("UPDATE houses SET cash = %i WHERE id = %i", HouseInfo[rentHouseid][hCash], HouseInfo[rentHouseid][hID]);
                }
                else
                {
                    rentCost = -1;
                    PlayerData[playerid][pRentingHouse] = 0;
                    SendClientMessage(playerid, COLOR_RED, "You couldn't afford to pay rent and were evicted as a result.");
                }
                break;
            }
        }
    }
    switch (PlayerData[playerid][pDonator])
    {
        case 1:
        {
            AppendFormat(str, sizeof(str), "VIP Bonus: $1,500\n");
            total+= 1500;
        }
        case 2:
        {
           AppendFormat(str, sizeof(str), "VIP Bonus: $2,000\n");
           total+= 2000;
        }
        case 3:
        {
           AppendFormat(str, sizeof(str), "VIP Bonus: $2,500\n");
           total+= 2500;
        }
    }

    if (PlayerData[playerid][pFaction] != -1)
    {
        new faction_payment =  1000 + PlayerData[playerid][pFactionRank] * 200;
        total += faction_payment;
        AppendFormat(str, sizeof(str), "Faction Payment: $%d\n", faction_payment);
    }
    AppendFormat(str, sizeof(str), "Old Balance: %s\n", FormatCash(PlayerData[playerid][pBank]));
    AppendFormat(str, sizeof(str), "______________________________________\n");
    AppendFormat(str, sizeof(str), "New Balance: %s", FormatCash(PlayerData[playerid][pBank] + total));

    SendClientMessageEx(playerid, COLOR_AQUA, "You have played %i/25 minutes this hour and earned your paycheck.", PlayerData[playerid][pMinutes]);
    ShowPlayerFooter(playerid, "~y~Payday ~w~ Paycheck");

    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Paycheck", str, "Okay", "");

    AddToTaxVault(tax);

    if (IsDoubleXPEnabled() || PlayerData[playerid][pDoubleXP] > 0)
        PlayerData[playerid][pEXP] += 2;
    else
        PlayerData[playerid][pEXP]++;

    if (PlayerData[playerid][pGang] >= 0)
    {
        GiveGangPoints(PlayerData[playerid][pGang], 1);
    }

    PlayerData[playerid][pHours]++;
    // GivePlayerCookies(playerid, 3);
    // SendClientMessageEx(playerid, COLOR_AQUA, "You've received {00aa00}'3 Cookies'{33CCFF} for playing 1 hour.");
    PlayerData[playerid][pBank] += total;
    GivePlayerRankPoints(playerid, 10 * PlayerData[playerid][pMinutes]);
    PlayerData[playerid][pMinutes] = 0;
    PlayerData[playerid][pPaycheck] = 0;
    // reward player (ToiletDuck)
    if (IsHourRewardEnabled())
    {

        switch (PlayerData[playerid][pHours])
        {
            case 2:
            {
                SendClientMessageEx(playerid, COLOR_LIGHTRED, "You may now possess/use weapons!");
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You have reached 2 Playing hours (/phrewards) to check all the Playing hours rewards!");

            }
            case 10:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 First aid Kit for spending 10 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /firstaid you can buy more from Tool Shop");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pFirstAid] += 10;
            }
            case 25:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 Cookies for spending 25 Hours of Time in Playing ");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /usecookies you can get more with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");

                GivePlayerCookies(playerid, 10); //rewardplay
            }
            case 50:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 5 Upgrade Points for spending 50 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pUpgradePoints] += 5;
            }
            case 100:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 50g Weed and Cocaine and 15,000 Materials for spending 100 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pWeed] += 50;
                PlayerData[playerid][pCocaine] += 50;
                PlayerData[playerid][pMaterials] += 15000;

            }
            case 150:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive $50,000 of Cash and 5 Exp Token for spending 150 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                GivePlayerCash(playerid, 50000);
                PlayerData[playerid][pEXP] += 5;
            }
            case 200:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 20 Cookies for spending 200 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /usecookies you can get more with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");

                GivePlayerCookies(playerid, 20);
            }
            case 250:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 7 Days Silver VIP for spending 250 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 1)
                {
                    new rank=1, days = 7;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 300:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 15 Days Silver VIP for spending 250 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 1)
                {
                    new rank=1, days = 15;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 350:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 50,000 Materials and 5 Exp Token for spending 350 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pMaterials] += 15000;
                PlayerData[playerid][pEXP] += 5;
            }
            case 400:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 5 Days Gold VIP for spending 400 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 2)
                {
                    new rank=2, days = 5;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 450:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 5 Exp Tokens, 15 First aid Kit for spending 450 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more XP with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                PlayerData[playerid][pEXP] += 5;
                PlayerData[playerid][pFirstAid] += 15;
            }
            case 500:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 Days Gold VIP for spending 500 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 2)
                {
                    new rank=2, days = 10;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 600:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 30 Cookies for spending 600 Hours of Time in Playing ");
                SendClientMessageEx(playerid, COLOR_YELLOW, " To use them Type /usecookies you can get more with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");

                GivePlayerCookies(playerid, 30); //rewardplay
            }
            case 700:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 15 Days Gold VIP for spending 700 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 2)
                {
                    new rank=2, days = 15;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 800:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 3 Days Legendary VIP for spending 800 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 3;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 900:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 7 Days Legendary VIP for spending 900 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 7;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 1000:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 10 Days Legendary VIP for spending 1000 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 10;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 1250:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 15 Days Legendary VIP for spending 1250 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 15;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 1500:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive Vehicle Huntley for spending 1500 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get more cars with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                {
                    new model = 579;
                    GivePlayerVehicle(playerid, model);
                }
            }
            case 1750:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 20 Days Legendary VIP for spending 1750 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 20;
                    GivePlayerVIP(playerid, rank, days);
                }
            }
            case 2000:
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                SendClientMessageEx(playerid, COLOR_GLOBAL, "* _-= %s Automate Playing Hours Reward =-_ *", GetServerName());
                SendClientMessageEx(playerid, COLOR_GLOBAL, " You receive 30 Days Legendary VIP for spending 2000 Hours of Time in Playing");
                SendClientMessageEx(playerid, COLOR_YELLOW, " you can get VIP LEVELS with donation from Server Management");
                SendClientMessageEx(playerid, COLOR_YELLOW, "_______________________________________________________________________");
                if (PlayerData[playerid][pDonator] < 3)
                {
                    new rank=3, days = 30;
                    GivePlayerVIP(playerid, rank, days);
                }
            }

        }
    }
    if (PlayerData[playerid][pHours] % 50 == 0)
    {
        if (PlayerData[playerid][pAge] == MAX_PLAYER_AGE)
            PlayerData[playerid][pAge] = MIN_PLAYER_AGE;
        else
            PlayerData[playerid][pAge]++;

        if (PlayerData[playerid][pGender] == PlayerGender_Male)
        {
            SendClientMessageToAllEx(COLOR_AQUA, "[Today's Birthday] %s have made it into another year and now he have %d years.", GetRPName(playerid), PlayerData[playerid][pAge]);
        }
        else
        {
            SendClientMessageToAllEx(COLOR_AQUA, "[Today's Birthday] %s have made it into another year and now she have %d years.", GetRPName(playerid), PlayerData[playerid][pAge]);
        }
    }
    if (PlayerData[playerid][pWeaponRestricted] > 0)
    {
        PlayerData[playerid][pWeaponRestricted]--;
    }
    if ((!IsDoubleXPEnabled()) && PlayerData[playerid][pDoubleXP] > 0)
    {
        PlayerData[playerid][pDoubleXP]--;

        if (PlayerData[playerid][pDoubleXP] > 0)
            SendClientMessageEx(playerid, COLOR_YELLOW, "Your double XP token expires in %i more hours.", PlayerData[playerid][pDoubleXP]);
        else
            SendClientMessage(playerid, COLOR_YELLOW, "Your double XP token has expired.");
    }

    if (PlayerData[playerid][pHours] >= 20)
    {
        AwardAchievement(playerid, ACH_Regular);
    }
    if (PlayerData[playerid][pHours] >= 40)
    {
        AwardAchievement(playerid, ACH_Addicted);
    }

    DBQuery("UPDATE "#TABLE_USERS" SET"\
        " minutes = 0, hours = hours + 1, paycheck = 0"\
        ", weaponrestricted = %i, doublexp = %i"\
        ", exp = %i, bank = %i"\
        ", age = %i, rentinghouse = %i"\
        " WHERE uid = %i",
        PlayerData[playerid][pWeaponRestricted], PlayerData[playerid][pDoubleXP],
        PlayerData[playerid][pEXP], PlayerData[playerid][pBank],
        PlayerData[playerid][pAge], PlayerData[playerid][pRentingHouse],
        PlayerData[playerid][pID]);
    IncreaseTotalHours();
    CallRemoteFunction("OnPlayerPayDay", "ii", playerid, total );

}


CMD:signcheck(playerid, params[])
{
    if (PayCheckCode[playerid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "There is no paycheck to sign. Please wait for the next paycheck.");

    new string[128];

    format(string, sizeof(string), "Check code: %d\n\nEnter your check code to receive your paycheck:", PayCheckCode[playerid]);
    Dialog_Show(playerid, DIALOG_PAYCHECK, DIALOG_STYLE_INPUT, "Sign check", string, "Sign check","Cancel");
    return 1;
}

CMD:givepayday(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_8))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /givepayday [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    SendPaycheck(targetid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced a payday for %s.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}
