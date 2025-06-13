/// @file      Phone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

//TODO: Seperate payphone and phone and contactphone
#include "machines/Phonebook.pwn"
#include "machines/Payphone.pwn"
#include <YSI\y_hooks>

static SendMoneyTarget[MAX_PLAYERS];
static PhoneMusic[MAX_PLAYERS];

hook OnLoadPlayer(playerid, row)
{
    PhoneMusic[playerid] = GetDBIntField(row, "phone_music");
}

hook OnPlayerInit(playerid)
{
    PhoneMusic[playerid] = 0;
}

stock SetPlayerPhoneMusic(playerid, musicid)
{
    PhoneMusic[playerid] = musicid;
    DBQuery("UPDATE "#TABLE_USERS" SET phone_music = %i WHERE uid = %i", PhoneMusic[playerid], PlayerData[playerid][pID]);
}

stock GetPlayerPhoneMusic(playerid)
{
    return PhoneMusic[playerid];
}

IsPhoneBusy(number)
{
    new targetid = GetPhonePlayerID(number);

    return (targetid != INVALID_PLAYER_ID && PlayerData[targetid][pCalling] > 0);
}

GetPhonePlayerID(number)
{
    foreach (new i : Player)
    {
        if (PlayerData[i][pPhone] == number)
        {
            return i;
        }
    }

    return INVALID_PLAYER_ID;
}

IsCallIncoming(playerid)
{
    return PlayerData[playerid][pCalling] == 1 &&
           PlayerData[playerid][pCaller] != INVALID_PLAYER_ID &&
           PlayerData[playerid][pIsCaller] == false;
}


HangupCall(playerid)
{
    if (PlayerData[playerid][pCalling] > 0)
    {
        for (new i = 0; i < MAX_PAYPHONES; i ++)
        {
            if (IsValidPayphoneID(i) && Payphones[i][phCaller] == playerid)
            {
                Payphones[i][phCaller] = INVALID_PLAYER_ID;

                UpdatePayphoneText(i);
            }
        }
        if (PlayerData[playerid][pCaller] != INVALID_PLAYER_ID)
        {
            SetPlayerCellphoneAction(PlayerData[playerid][pCaller], false);

            SendInfoMessage(PlayerData[playerid][pCaller], "The other line has ended the call.");
            PlayerPlaySound(PlayerData[playerid][pCaller], 20601, 0.0, 0.0, 0.0);

            if (PlayerData[PlayerData[playerid][pCaller]][pPayphone] != -1)
            {
                ResetPayphone(PlayerData[playerid][pCaller]);
                ShowActionBubble(PlayerData[playerid][pCaller], "* %s hangs up the payphone.", GetRPName(PlayerData[playerid][pCaller]));
            }
            else
            {
                ShowActionBubble(PlayerData[playerid][pCaller], "* %s hangs up the phone and puts it in their pocket.", GetRPName(PlayerData[playerid][pCaller]));
            }

            PlayerData[PlayerData[playerid][pCaller]][pCalling] = 0;
            PlayerData[PlayerData[playerid][pCaller]][pCaller] = INVALID_PLAYER_ID;
            PlayerData[PlayerData[playerid][pCaller]][pIsCaller] = false;
        }
        SetPlayerCellphoneAction(playerid, false);
        PlayerPlaySound(playerid, 20601, 0.0, 0.0, 0.0);

        PlayerData[playerid][pCalling] = 0;
        PlayerData[playerid][pCaller] = INVALID_PLAYER_ID;
        PlayerData[playerid][pIsCaller] = false;

        if (PlayerData[playerid][pPayphone] != -1)
        {
            ResetPayphone(playerid);
            ShowActionBubble(playerid, "* %s hangs up the payphone.", GetRPName(playerid));
        }
        else
        {
            ShowActionBubble(playerid, "* %s hangs up the phone and puts it in their pocket.", GetRPName(playerid));
        }
    }
}

SendTextMessage(playerid, number, const text[])
{
    foreach (new i : Player)
    {
        if (number != 0 && PlayerData[i][pPhone] == number)
        {
            if (PlayerData[i][pTogglePhone])
            {
                return SendErrorMessage(playerid, "That player's phone is turned off.");
            }
            else
            {
                SendClientMessageEx(i, COLOR_YELLOW, "* Text from %i: %s", PlayerData[playerid][pPhone], text);
                SendClientMessageEx(playerid, COLOR_YELLOW, "* Text to %i: %s",  number, text);
                return 1;
            }
        }
    }
    return SendErrorMessage(playerid, "The specified number is not in service.");
}

CallNumber(playerid, number, payphone = -1)
{
    if (PlayerData[playerid][pCalling] > 0)
    {
        return SendErrorMessage(playerid, "You are already on a call.");
    }
    else if (PlayerData[playerid][pPhone] == number)
    {
        return SendErrorMessage(playerid, "You can't dial your own number.");
    }
    else
    {
        new targetid = GetPhonePlayerID(number);

        if (IsValidPayphoneID(payphone))
        {
            ShowActionBubble(playerid, "* %s inserts a coin and picks up the payphone.", GetRPName(playerid));
            AssignPayphone(playerid, payphone);
        }
        else
        {
            ShowActionBubble(playerid, "* %s takes out their phone and dials a number.", GetRPName(playerid));
        }

        if (IsPlayerConnected(targetid))
        {
            if (PlayerData[targetid][pTogglePhone])
            {
                return SendClientMessage(playerid, COLOR_GREY, "* The phone is switched off. The number would automatically forward to voicemail. *");
            }
            else if (PlayerData[targetid][pCalling] > 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "* The other line is currently busy. *");
            }
            else
            {
                PlayerData[playerid][pCalling] = 1;
                PlayerData[playerid][pCaller] = targetid;
                PlayerData[playerid][pIsCaller] = true;


                PlayerData[targetid][pCalling] = 1;
                PlayerData[targetid][pCaller] = playerid;
                PlayerData[playerid][pIsCaller] = false;

                if (IsValidPayphoneID(payphone))
                {
                    SendInfoMessage(targetid, "Payphone (%i) is attempting to call you (use /answer to answer).", Payphones[payphone][phNumber]);
                }
                else
                {
                    SendInfoMessage(targetid, "Number %i is attempting to call you (use /answer to answer).", PlayerData[playerid][pPhone]);
                }
                ShowActionBubble(targetid, "* %s's phone starts to ring.", GetRPName(targetid));
                HandlePhoneRing(targetid);
            }
        }
        else
        {
            new id = GetPhonePayphoneID(number);

            if (IsValidPayphoneID(id) && !Payphones[id][phOccupied])
            {
                CallPayphone(playerid, id);
            }
            else
            {
                SetTimerEx("OnPhoneResponse", 3000, false, "ii", playerid, number);
            }
            PlayerData[playerid][pCalling] = 1;
            PlayerData[playerid][pIsCaller] = true;
        }

        SetPlayerCellphoneAction(playerid, true);
        HandlePhoneDial(playerid);

        SendInfoMessage(playerid, "You have dialed number: %i. Please wait for a connection...", number);
        PlayerPlaySound(playerid, 16001, 0.0, 0.0, 0.0);
    }
    return 1;
}

OpenPhone(playerid)
{
    new strHead[128];
    if (PlayerData[playerid][pPhone] > 0)
    {
        format(strHead,sizeof(strHead),"{FFFFFF}Phone: %i",PlayerData[playerid][pPhone]);
        Dialog_Show(playerid, PhoneMenu, DIALOG_STYLE_LIST, strHead, "Call a number\nSend a message\nContact list\nMusic\nBank\nSettings", "Select", "Cancel");
    }
}

DB:OnLoadPayphones()
{
    new rows = GetDBNumRows();

    for (new i = 0; i < rows; i ++)
    {
        Payphones[i][phExists] = 1;
        Payphones[i][phID] = GetDBIntField(i, "phID");
        Payphones[i][phNumber] = GetDBIntField(i, "phNumber");
        Payphones[i][phX] = GetDBFloatField(i, "phX");
        Payphones[i][phY] = GetDBFloatField(i, "phY");
        Payphones[i][phZ] = GetDBFloatField(i, "phZ");
        Payphones[i][phA] = GetDBFloatField(i, "phA");
        Payphones[i][phInterior] = GetDBIntField(i, "phInterior");
        Payphones[i][phWorld] = GetDBIntField(i, "phWorld");
        Payphones[i][phCaller] = INVALID_PLAYER_ID;
        Payphones[i][phObject] = INVALID_OBJECT_ID;
        Payphones[i][phText] = INVALID_3DTEXT_ID;

        UpdatePayphone(i);
    }
}

publish HandlePhoneRing(playerid)
{
    return 1; // Disabled

    if (PlayerData[playerid][pCalling] != 1)
    {
        return 0;
    }
    PlayNearbySound(playerid, GetPhoneMusicId(PhoneMusic[playerid]));
    SetTimerEx("HandlePhoneRing", 4000, false, "i", playerid);
    return 1;
}

static GetPhoneMusicId(musicid)
{
    switch (musicid)
    {
        case 0: return 1076;
        case 1: return 1185;
        case 2: return 1062;
        case 3: return 1097;
        case 4: return 1187;
        case 5: return 1068;
        case 6: return 20600; // Doesn't work on mobile
        case 7: return 23000; // Doesn't work on mobile
        case 8: return 20804; // Doesn't work on mobile
        case 9: return 17801; // Doesn't work on mobile
        case 10: return 6001; // Doesn't work on mobile
        case 11: return 23600; // Doesn't work on mobile
    }
    return 1076;
}

publish HandlePhoneDial(playerid)
{
    if (PlayerData[playerid][pCalling] != 1)
    {
        return 0;
    }

    PlayerPlaySound(playerid, 16001, 0.0, 0.0, 0.0);
    SetTimerEx("HandlePhoneDial", 4000, false, "i", playerid);

    return 1;
}

publish OnPhoneResponse(playerid, number)
{
    if ((PlayerData[playerid][pPayphone] != -1 && GetClosestPayphone(playerid) != PlayerData[playerid][pPayphone]) || PlayerData[playerid][pTogglePhone] || !PlayerData[playerid][pCalling])
    {
        return 0;
    }

    switch (number)
    {
        case PhoneNumber_Emergency:
        {
            PlayerData[playerid][pCalling] = PhoneNumber_Emergency;
            PlayerData[playerid][pIsCaller] = true;
            ShowActionBubble(playerid, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
            SendClientMessageEx(playerid, COLOR_YELLOW, "Dispatch: %d, what is your emergency? Enter 'police' or 'medic'.",
                PhoneNumber_Emergency);
        }
        case PhoneNumber_Mechanic:
        {
            PlayerData[playerid][pCalling] = PhoneNumber_Mechanic;
            PlayerData[playerid][pIsCaller] = true;
            SendClientMessage(playerid, COLOR_LIGHTORANGE, "Dispatch: This is the mechanic hotline. Please explain your situation to us.");
        }
        case PhoneNumber_Taxi:
        {
            PlayerData[playerid][pCalling] = PhoneNumber_Taxi;
            PlayerData[playerid][pIsCaller] = true;
            SendClientMessage(playerid, COLOR_YELLOW, "(Phone) Taxi: Would you like to request a taxi? Say 'yes' or 'no'.");
        }
        case PhoneNumber_News:
        {
            PlayerData[playerid][pCalling] = PhoneNumber_News;
            PlayerData[playerid][pIsCaller] = true;
            SendClientMessage(playerid, COLOR_LIGHTORANGE, "Dispatch: This is the news hotline. Please explain your situation to us.");
        }
        default:
        {
            new targetid = GetPhonePlayerID(number);

            if (targetid == INVALID_PLAYER_ID)
            {
                SendClientMessage(playerid, COLOR_GREY, "* This cellphone number is currently not in service. *");
                HangupCall(playerid);
            }
            else if (IsPhoneBusy(number))
            {
                SendClientMessage(playerid, COLOR_GREY, "* You would hear a busy tone. *");
                HangupCall(playerid);
            }
        }
    }
    return 1;
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (PlayerData[playerid][pEdit] == EDIT_TYPE_PAYPHONE)
    {
        if (response == EDIT_RESPONSE_CANCEL)
        {
            UpdatePayphone(PlayerData[playerid][pEditID]);
        }
        else if (response == EDIT_RESPONSE_FINAL)
        {
            Payphones[PlayerData[playerid][pEditID]][phX] = x;
            Payphones[PlayerData[playerid][pEditID]][phY] = y;
            Payphones[PlayerData[playerid][pEditID]][phZ] = z;
            Payphones[PlayerData[playerid][pEditID]][phA] = rz;

            UpdatePayphone(PlayerData[playerid][pEditID]);
            SavePayphone(PlayerData[playerid][pEditID]);

            SendInfoMessage(playerid, "You have edited payphone ID: %i.", PlayerData[playerid][pEditID]);
        }
        PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
        PlayerData[playerid][pEditID] = -1;
    }
    return 1;
}

Dialog:PhoneCallPP(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new number, payphone = GetClosestPayphone(playerid);

        if (sscanf(inputtext, "i", number))
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "Please specify the number you would like to call:", "Call", "Cancel");
        }
        else if (PlayerData[playerid][pCalling] > 0)
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You are already on a call. Use {6688FF}/hangup{FFFFFF} to end it.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else if (PlayerData[playerid][pPhone] == number)
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You can't dial your own number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else if (number < 1)
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You have entered an invalid phone number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else if (IsValidPayphoneID(payphone) && number == Payphones[payphone][phNumber])
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You can't call this number as it belongs to this payphone.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else if (IsValidPayphoneID(payphone) && (Payphones[payphone][phOccupied] || Payphones[payphone][phCaller] != INVALID_PLAYER_ID))
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "This payphone is already in use.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else
        {
            CallNumber(playerid, number, payphone);
        }
    }
    return 1;
}

SetPlayerCellphoneAction(playerid, enable)
{
    if (PlayerData[playerid][pCuffed])
    {
        return 0;
    }
    else
    {
        if (enable)
        {
            if (VehicleHasDoors(GetPlayerVehicleID(playerid)))
            {
                ApplyAnimation(playerid, "CAR_CHAT", "carfone_in", 4.1, 0, 0, 0, 1, 0, 1);
            }
            else
            {
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
                SetPlayerAttachedObject(playerid, 5, 330, 6);
            }
        }
        else
        {
            if (VehicleHasDoors(GetPlayerVehicleID(playerid)))
            {
                ApplyAnimation(playerid, "CAR_CHAT", "carfone_out", 4.1, 0, 0, 0, 0, 0, 1);
            }
            else
            {
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
                RemovePlayerAttachedObject(playerid, 5);
            }
        }
    }
    return 1;
}

DB:OnPlayerSendTextMessage(playerid, number, msg[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The number you're trying to reach does not belong to any particular person.");
    }
    else if (GetDBIntFieldFromIndex(0, 1))
    {
        SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
    }
    else if (GetDBIntFieldFromIndex(0, 2))
    {
        SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
    }
    else
    {
        new
            username[MAX_PLAYER_NAME];

        GetDBStringFieldFromIndex(0, 0, username);

        DBQuery("INSERT INTO texts VALUES(null, %i, %i, '%e', NOW(), '%e')", PlayerData[playerid][pPhone], number, GetPlayerNameEx(playerid), msg);

        ShowActionBubble(playerid, "* %s takes out a cellphone and sends a message.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_YELLOW, "* SMS to %s (%i): %s *", username, number, msg);
        SendClientMessage(playerid, COLOR_WHITE, "The player who owns the number is offline, but will receive your text when they log in.");

        GivePlayerCash(playerid, -1);
        GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$1", 5000, 1);
    }
}

DB:OnAdminSetPhoneNumber(playerid, targetid, number)
{
    if (GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The number specified is already taken.");
    }
    else
    {
        PlayerData[targetid][pPhone] = number;
        SendClientMessageEx(playerid, COLOR_WHITE, "You have set %s's phone number to %i.", GetRPName(targetid), number);

        DBQuery("UPDATE "#TABLE_USERS" SET phone = %i WHERE uid = %i", number, PlayerData[targetid][pID]);

        DBLog("log_admin", "%s (uid: %i) set %s's (uid: %i) phone number to %i", GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID], number);
    }
}

Dialog:PhoneMusic(playerid, response, listitem, inputtext[])
{
    if (response && listitem > 0 && listitem < 6)
    {
        PlayNearbySound(playerid, GetPhoneMusicId(listitem));
        SetPlayerPhoneMusic(playerid, listitem);
        SendClientMessageEx(playerid, COLOR_GREY, "You have changed your current phone music.");
    }
    return 1;
}

Dialog:PhoneMenu(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "Please specify the number you would like to call:", "Call", "Cancel");
            }
            case 1:
            {
                Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Call", "Cancel");
            }
            case 2:
            {
                ListContacts(playerid);
            }
            case 3:
            {
                Dialog_Show(playerid, PhoneMusic, DIALOG_STYLE_LIST, "{6688ff}Phone Music",
                    "Default Ringtone\nMusical Ringtone 1\nMusical Ringtone 2\nMusical Ringtone 3\n"\
                    "Musical Ringtone 4\nMusical Ringtone 5", "Select", "Cancel");
            }
            case 4:
            {
                Dialog_Show(playerid, PhoneBank, DIALOG_STYLE_LIST, "{6688ff}Bank",
                    "Balance: %s\nSend money", "Select", "Cancel", FormatCash(PlayerData[playerid][pBank]));
            }
            case 5:
            {
                Dialog_Show(playerid, PhoneSettings, DIALOG_STYLE_LIST, "{6688FF}Phone Settings", "Power %s\nSound Off", "Select", "Cancel", (PlayerData[playerid][pTogglePhone]) ? ("Off") : ("On"));
            }
        }
    }
    return 1;
}

Dialog:PhoneBank(playerid, response, listitem, inputtext[])
{
    if (response && listitem == 1)
    {
        Dialog_Show(playerid, PhoneBankNumber, DIALOG_STYLE_INPUT, "{6688FF}Send money",
                    "Please specify the number you would like to send money to:", "Confirm", "Cancel");
    }
}

Dialog:PhoneBankNumber(playerid, response, listitem, inputtext[])
{
    if (response && !isnull(inputtext))
    {
        ShowSendMoneyDialog(playerid, strval(inputtext));
    }
}

ShowSendMoneyDialog(playerid, number)
{
    SendMoneyTarget[playerid] = number;
    Dialog_Show(playerid, PhoneBankCash, DIALOG_STYLE_INPUT, "{6688FF}Send money",
                "Please enter the amount of cash you like to send to %d (Maximum: $10,000):",
                "Send", "Cancel", SendMoneyTarget[playerid]);
}

Dialog:PhoneBankCash(playerid, response, listitem, inputtext[])
{
    if (response && !isnull(inputtext))
    {
        new cash = strval(inputtext);
        new fees = 25;
        if (cash < 1 || cash > 10000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid cash value.");
        }
        if (PlayerData[playerid][pBank] < cash)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough balance in your bank account.");
        }
        if (PlayerData[playerid][pBank] < cash + fees)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have enough balance in your bank account to pay the fees.");
        }
        new targetid = GetPhonePlayerID(SendMoneyTarget[playerid]);
        if (!IsPlayerConnected(targetid) || PlayerData[targetid][pTogglePhone])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Phone number is out of service.");
        }
        PlayerData[playerid][pBank] -= cash + fees;
        PlayerData[targetid][pBank] += cash;
        DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);
        DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[targetid][pBank], PlayerData[targetid][pID]);

        SendClientMessageEx(playerid, COLOR_GREEN, "You sent %s to %s and you have paid $%d for the fees.", FormatCash(cash), GetRPName(targetid), fees);
        SendClientMessageEx(targetid, COLOR_GREEN, "You have received %s from %s.", FormatCash(cash), GetRPName(playerid));
    }
    return 1;
}

Dialog:PhoneSettings(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                if (PlayerData[playerid][pTogglePhone] == 0)
                    PlayerData[playerid][pTogglePhone] = 1;
                else
                    PlayerData[playerid][pTogglePhone] = 0;
            }
            case 1:
            {
                PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
            }
        }
    }
    return 1;
}

Dialog:PhoneSMS(playerid, response, listitem, inputtext[])
{
    new number;

    if (response)
    {
        if (sscanf(inputtext, "i", number))
        {
            return Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Call", "Cancel");
        }
        else if (PlayerData[playerid][pPhone] == number)
        {
            return Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "You can't text your own number.\n\nPlease specify the number you would like to SMS:", "Call", "Cancel");
        }
        else if (number < 1)
        {
            return Dialog_Show(playerid, PhoneSMS, DIALOG_STYLE_INPUT, "{6688FF}SMS Number", "Please specify the number you would like to SMS:", "Call", "Cancel");
        }
        else
        {
            ShowSendSmsDialog(playerid, number);
        }
    }
    return 1;
}

ShowSendSmsDialog(playerid, number)
{
    new strHead[64];
    format(strHead, sizeof(strHead), "{6688FF}SMS to %i", number);
    PlayerData[playerid][pPhoneSMS] = number;
    Dialog_Show(playerid, PhoneSMStext, DIALOG_STYLE_INPUT, strHead, "Please type your message:", "Send", "Cancel");
}

Dialog:PhoneSMStext(playerid, response, listitem, inputtext[])
{
    new text[512];
    new number = PlayerData[playerid][pPhoneSMS];
    new strHead[64];
    if (response)
    {
        format(strHead, sizeof(strHead), "{6688FF}SMS to %i", number);

        if (sscanf(inputtext, "s[512]", text))
        {
            Dialog_Show(playerid, PhoneSMStext, DIALOG_STYLE_INPUT, strHead, "Please type your message:", "Send", "Cancel");
        }
        else
        {
            SendTextMessage(playerid, number, text);
        }
    }
    return 1;
}

Dialog:PhoneCall(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new number;

        if (sscanf(inputtext, "i", number))
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "Please specify the number you would like to call:", "Call", "Cancel");
        }
        else if (PlayerData[playerid][pCalling] > 0)
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You are already on a call. Use {6688FF}/hangup{FFFFFF} to end it.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else if (PlayerData[playerid][pPhone] == number)
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You can't dial your own number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else if (number < 1)
        {
            return Dialog_Show(playerid, PhoneCall, DIALOG_STYLE_INPUT, "{6688FF}Call Number", "You have entered an invalid phone number.\n\nPlease specify the number you would like to call:", "Call", "Cancel");
        }
        else
        {
            CallNumber(playerid, number);
        }
    }
    return 1;
}

DB:BuyNewPhone(playerid)
{
    PlayerData[playerid][pPhone] = GetDBIntField(0, "phone");
    ShowActionBubble(playerid, "* %s paid the shopkeeper and received a mobile phone.", GetRPName(playerid));
    SendClientMessageEx(playerid, COLOR_WHITE, "Mobile phone purchased. Your new phone number is %i.", PlayerData[playerid][pPhone]);
    return 1;
}

Dialog:DIALOG_UNREADTEXTS(playerid, response, listitem, inputtext[])
{
    DBQuery("DELETE FROM texts WHERE recipient_number = %i ORDER BY date DESC LIMIT 25", PlayerData[playerid][pPhone]);

    if (response)
    {
        callcmd::texts(playerid, "\1");
    }
    return 1;
}

DB:CountTexts(playerid)
{
    new rows = GetDBIntFieldFromIndex(0, 0);

    if (rows)
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "* You have %i unread text messages. (/texts)", rows);
    }
}

DB:ViewTexts(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "You have no more unread text messages to read.");
    }
    else
    {
        static listString[4096], sender[MAX_PLAYER_NAME], date[24], message[128];

        listString = "Texts sent to you while offline (recent first):\n";

        for (new i = 0; i < min(rows, 25); i ++)
        {
            GetDBStringField(i, "sender", sender);
            GetDBStringField(i, "date", date);
            GetDBStringField(i, "message", message);

            format(listString, sizeof(listString), "%s\n[%s] SMS from %s (%i): %s", listString, date, sender, GetDBIntField(i, "sender_number"), message);
        }

        if (rows > 25)
        {
            Dialog_Show(playerid, DIALOG_UNREADTEXTS, DIALOG_STYLE_MSGBOX, "Unread Texts", listString, "Next", "OK");
        }
        else
        {
            Dialog_Show(playerid, DIALOG_UNREADTEXTS, DIALOG_STYLE_MSGBOX, "Unread Texts", listString, "OK", "");
        }
    }
}

CMD:rt(playerid, params[])
{
    return callcmd::rsms(playerid, params);
}

CMD:rs(playerid, params[])
{
    return callcmd::rsms(playerid, params);
}

CMD:rsms(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rsms [text]");
    }
    if (PlayerData[playerid][pTextFrom] == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't received a text by anyone since you joined the server.");
    }
    if (PlayerData[playerid][pCash] < 25)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 25$ to send sms.");
    }
    if (PlayerData[PlayerData[playerid][pTextFrom]][pJailType] != JailType_None)
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
    }
    if (PlayerData[PlayerData[playerid][pTextFrom]][pTogglePhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }

    PlayerData[PlayerData[playerid][pTextFrom]][pTextFrom] = playerid;
    ShowActionBubble(playerid, "* %s takes out a cellphone and sends a message.", GetRPName(playerid));

    SendClientMessageEx(PlayerData[playerid][pTextFrom], COLOR_YELLOW, "SMS: %s, Sender: %s(%i)", params, GetRPName(playerid), PlayerData[playerid][pPhone]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: %s, Sender: %s(%i)", params, GetRPName(playerid), PlayerData[playerid][pPhone]);

    GivePlayerCash(playerid, -25);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$25", 5000, 1);
    return 1;
}

CMD:told(playerid, params[])
{
    return callcmd::sms(playerid, params);
}

CMD:sms(playerid, params[])
{
    new number, msg[128];

    if (sscanf(params, "is[128]", number, msg))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sms [number] [message]");
    }
    if (!PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
    }
    if (PlayerData[playerid][pCash] < 25)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 25$ to send sms.");
    }
    if (PlayerData[playerid][pTogglePhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
    }
    if (number == 0 || number == PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }

    foreach(new i : Player)
    {
        if (PlayerData[i][pPhone] == number)
        {
            if (PlayerData[i][pJailType] != JailType_None)
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
            }
            if (PlayerData[i][pTogglePhone])
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
            }

            ShowActionBubble(playerid, "* %s takes out his cellphone and sends a message.", GetRPName(playerid));

            if (strlen(msg) > MAX_SPLIT_LENGTH)
            {
                SendClientMessageEx(i, COLOR_YELLOW, "SMS: %.*s..., Received from: %s(%i)", MAX_SPLIT_LENGTH, msg, GetRPName(playerid), PlayerData[playerid][pPhone]);
                SendClientMessageEx(i, COLOR_YELLOW, "SMS: ...%s, Received from: %s(%i)", msg[MAX_SPLIT_LENGTH], GetRPName(playerid),PlayerData[playerid][pPhone]);

                SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: %.*s..., Sent to: %s(%i)", MAX_SPLIT_LENGTH, msg,  GetRPName(i),PlayerData[i][pPhone]);
                SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: ...%s, Sent to: %s(%i)", msg[MAX_SPLIT_LENGTH], GetRPName(i), PlayerData[i][pPhone]);
            }
            else
            {
                SendClientMessageEx(i, COLOR_YELLOW, "SMS: %s, Received from: %s(%i)", msg, GetRPName(playerid), PlayerData[playerid][pPhone]);
                SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: %s, Sent to: %s(%i)", msg, GetRPName(i), PlayerData[i][pPhone]);
            }

            if (PlayerData[i][pTextFrom] == INVALID_PLAYER_ID)
            {
                SendClientMessage(i, COLOR_WHITE, "* You can use '/rsms [message]' to reply to this text message.");
            }

            PlayerData[i][pTextFrom] = playerid;

            GivePlayerCash(playerid, -25);
            GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$25", 5000, 1);
            return 1;
        }
    }

    DBFormat("SELECT username, jailtype, togglephone FROM "#TABLE_USERS" WHERE phone = %i", number);
    DBExecute("OnPlayerSendTextMessage", "iis", playerid, number, msg);
    return 1;
}

CMD:texts(playerid, params[])
{
    if (!PlayerData[playerid][pPhone])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
    }

    DBFormat("SELECT * FROM texts WHERE recipient_number = %i ORDER BY date DESC", PlayerData[playerid][pPhone]);
    DBExecute("ViewTexts", "i", playerid);
    return 1;
}

CMD:h(playerid, params[])
{
    return callcmd::hangup(playerid, params);
}

CMD:hangup(playerid, params[])
{
    if (!PlayerData[playerid][pCalling])
    {
        return SendErrorMessage(playerid, "There are no calls to hangup.");
    }
    else
    {
        HangupCall(playerid);
        SendInfoMessage(playerid, "You have ended the call.");
    }
    return 1;
}

CMD:phone(playerid, params[])
{
    if (!PlayerData[playerid][pPhone])
    {
        return SendErrorMessage(playerid, "You don't have any phone setup.");
    }

    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED ||
        PlayerData[playerid][pTazedTime] > 0 ||
        PlayerData[playerid][pHospital] > 0 ||
        PlayerData[playerid][pInjured] > 0 ||
        PlayerData[playerid][pCuffed] > 0  ||
        IsPlayerLootingInRobbery(playerid) ||
        IsPlayerMining(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're currently unable to use phone at this moment.");
    }
    OpenPhone(playerid);
    ShowActionBubble(playerid, "* %s takes out their phone.", GetRPName(playerid));
    return 1;
}

CMD:answer(playerid, params[])
{
    if (!IsCallIncoming(playerid) && !IsPlayerNearRingingPayphone(playerid))
    {
        return SendErrorMessage(playerid, "There are no incoming calls to answer.");
    }
    else
    {
        new payphone = GetClosestPayphone(playerid);

        if (IsValidPayphoneID(payphone) && Payphones[payphone][phCaller] != INVALID_PLAYER_ID)
        {
            PlayerData[playerid][pCalling] = 2;
            PlayerData[playerid][pCaller] = Payphones[payphone][phCaller];

            PlayerData[Payphones[payphone][phCaller]][pCalling] = 2;
            PlayerData[Payphones[payphone][phCaller]][pCaller] = playerid;

            PlayerPlaySound(Payphones[payphone][phCaller], 20601, 0.0, 0.0, 0.0);
            AssignPayphone(playerid, payphone);

            SendInfoMessage(playerid, "You have answered the call. Use /hangup to hang up.");
            SendInfoMessage(PlayerData[playerid][pCaller], "The other line has picked up the call. Use /hangup to hang up.");
        }
        else
        {
            PlayerData[playerid][pCalling] = 2;
            PlayerData[PlayerData[playerid][pCaller]][pCalling] = 2;

            SendInfoMessage(playerid, "You have answered the call from %s. Use /hangup to hang up.", GetRPName(PlayerData[playerid][pCaller]));
            SendInfoMessage(PlayerData[playerid][pCaller], "The other line has picked up the call. Use /hangup to hang up.");
        }

        SetPlayerCellphoneAction(playerid, true);
        PlayerPlaySound(playerid, 20601, 0.0, 0.0, 0.0);
    }
    return 1;
}

CMD:call(playerid, params[])
{
    new nam1[64], payphone = GetClosestPayphone(playerid);

    if (!PlayerData[playerid][pPhone] && payphone == -1)
    {
        return SendErrorMessage(playerid, "You don't have any phone setup.");
    }
    else if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }
    else if (PlayerData[playerid][pTogglePhone] && payphone == -1)
    {
        return SendErrorMessage(playerid, "Your phone is turned off. Use /phone to turn it on.");
    }
    else if (sscanf(params, "s[64]", nam1))
    {
        SendSyntaxMessage(playerid, "/call [number/contact name]");
        SendClientMessageEx(playerid, COLOR_SYNTAX, "Special numbers: %d, %d(Mechanic), %d(Taxi), %d(News)",
           PhoneNumber_Emergency, PhoneNumber_Mechanic, PhoneNumber_Taxi, PhoneNumber_News);
        return 1;
    }
    else
    {
        if (IsNumeric(nam1) && strval(nam1) > 0)
        {
            new tmpNumber = strval(nam1);
            CallNumber(playerid, tmpNumber, payphone);
        }
        else
        {
            CallPhonebookContact(playerid, nam1);
        }
    }
    return 1;
}

CMD:pm(playerid, params[])
{
    new targetid, text[128];

    if (sscanf(params, "us[128]", targetid, text))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(pm) [playerid] [text]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't pm to yourself.");
    }
    if (PlayerData[playerid][pHours] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to play at least 3 hours+ to use this command");
    }
    if (PlayerData[targetid][pTogglePM])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming private messages.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }
    if (PlayerData[playerid][pCash] < 3000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need $3,000 to send private message.");
    }
    SendClientMessageEx(targetid, COLOR_GREEN, "(( PM from %s: %s ))", GetRPName(playerid), text);
    SendClientMessageEx(playerid, COLOR_GREEN, "(( PM to %s: %s ))", GetRPName(targetid), text);

    if (PlayerData[targetid][pWhisperFrom] == INVALID_PLAYER_ID)
    {
        SendClientMessage(targetid, COLOR_WHITE, "* You can use '/rpm [message]' to reply to this private message.");
    }

    GivePlayerCash(playerid, -3000);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$3,000", 5000, 1);
    PlayerData[targetid][pWhisperFrom] = playerid;
    return 1;
}

CMD:rpm(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rpm [text]");
    }
    if (PlayerData[playerid][pWhisperFrom] == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't been private messaged by anyone since you joined the server.");
    }
    if (PlayerData[PlayerData[playerid][pWhisperFrom]][pTogglePM])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming private messages.");
    }
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
    }
    if (PlayerData[playerid][pCash] < 3000)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need $3,000 to send private message.");
    }
    SendClientMessageEx(PlayerData[playerid][pWhisperFrom], COLOR_GREEN, "(( PM from %s: %s ))", GetRPName(playerid), params);
    SendClientMessageEx(playerid, COLOR_GREEN, "(( PM to %s: %s ))", GetRPName(PlayerData[playerid][pWhisperFrom]), params);
    GivePlayerCash(playerid, -3000);
    GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$3,000", 5000, 1);
    return 1;
}

CMD:speakerphone(playerid, params[])
{
    if (PlayerData[playerid][pPhone] != 0)
    {
        if (PlayerData[playerid][pSpeakerPhone] == 1)
        {
            PlayerData[playerid][pSpeakerPhone] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the speakerphone feature on your phone.");
        }
        else
        {
            PlayerData[playerid][pSpeakerPhone] = 1;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the speakerphone feature on your phone.");
        }
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a phone.");
    }
    return 1;
}

CMD:number(playerid, params[])
{
    return SendClientMessage(playerid, COLOR_GREY, "Command is disabled at the moment");

    new targetid;
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /number [playerid]");
    }
    if (!HasPhonebook(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a phonebook.");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }

    ShowActionBubble(playerid, "* %s takes out a cellphone and looks up a number.", GetRPName(playerid));

    if (PlayerData[targetid][pPhone] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This player doesn't have a phone.");
    }

    SendClientMessageEx(playerid, COLOR_GREY2, "* %s (%i)", GetRPName(targetid), PlayerData[targetid][pPhone]);
    return 1;
}

// TODO: use mysql definer 'GetNewRandomPhoneNumber' or check phonenumber existance
GetNewRandomPhoneNumber(min, max)
{
    if (max < min)
        return max + random(min - max);
    else
        return min + random(max - min);
}
