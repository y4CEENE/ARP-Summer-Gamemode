/// @file      Phonebook.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-09-01 16:31:49 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MAX_LISTED_NUMBERS          50

static Phonebook[MAX_PLAYERS];
static PhonebookPage[MAX_PLAYERS];
static PhoneListedItems[MAX_PLAYERS][100];
static PhoneTargetName[MAX_PLAYERS][MAX_PLAYER_NAME];
static PhonebookSelected[MAX_PLAYERS];

hook OnLoadPlayer(playerid, row)
{
    Phonebook[playerid] = GetDBIntField(row, "phonebook");
}

hook OnPlayerInit(playerid)
{
    Phonebook[playerid] = 0;
}

HasPhonebook(playerid)
{
    return Phonebook[playerid] != 0;
}

GivePlayerPhonebook(playerid)
{
    Phonebook[playerid] = 1;
    DBQuery("UPDATE "#TABLE_USERS" SET phonebook = %i WHERE uid = %i", Phonebook[playerid], PlayerData[playerid][pID]);
}

RemovePlayerPhonebook(playerid)
{
    Phonebook[playerid] = 0;
    DBQuery("UPDATE "#TABLE_USERS" SET phonebook = %i WHERE uid = %i", Phonebook[playerid], PlayerData[playerid][pID]);
}

CallPhonebookContact(playerid, const name[])
{
    DBFormat("SELECT Name, Number FROM rp_contacts WHERE Name LIKE '%%%e%%' and PlayerID = %i", name, PlayerData[playerid][pID]);
    DBExecute("OnPlayerCallContact", "d", playerid);
}

DB:OnPlayerCallContact(playerid)
{
    if (!GetDBNumRows())
    {
        return SendErrorMessage(playerid, "You don't have that name in your contacts");
    }
    else
    {
        CallNumber(playerid, GetDBIntField(0, "Number"));
    }
    return 1;
}

Dialog:AddContactNumber(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new number;
        if (sscanf(inputtext, "i", number))
        {
            return Dialog_Show(playerid, AddContactNumber, DIALOG_STYLE_INPUT, "{FFFFFF}Contact number", "Please input the number for the contact '%s':", "Submit", "Cancel", PhoneTargetName[playerid]);
        }
        else if (number < 1)
        {
            return Dialog_Show(playerid, AddContactNumber, DIALOG_STYLE_INPUT, "{FFFFFF}Contact number", "You have entered an invalid number.\n\nPlease input the number for the contact '%s':", "Submit", "Cancel", PhoneTargetName[playerid]);
        }
        else
        {
            DBFormat("INSERT INTO rp_contacts (PlayerID, Name, Number) VALUES (%i, '%e', %i)", PlayerData[playerid][pID], PhoneTargetName[playerid], number);
            DBExecute("OnContactsChanged", "i", playerid);
            SendInfoMessage(playerid, "You have added a contact: %s (%i).", PhoneTargetName[playerid], number);
        }
    }
    return 1;
}

DB:OnContactsChanged(playerid)
{
    ListContacts(playerid);
}

ListContacts(playerid)
{
    PhonebookPage[playerid] = 1;
    DBFormat("SELECT * FROM rp_contacts where Playerid = %i ORDER BY Name ASC LIMIT %i, %i",
                PlayerData[playerid][pID], 0, MAX_LISTED_NUMBERS);
    DBExecute("OnPlayerListContacts", "i", playerid);
}

DB:OnPlayerListContacts(playerid)
{
    new rows = GetDBNumRows();

    static string[MAX_LISTED_NUMBERS * 32], name[MAX_PLAYER_NAME];

    string = "Name\tNumber";
    strcat(string, "\n{16BDE3}+ Add Contact{FFFFFF}");

    for (new i = 0; i < rows; i ++)
    {
        GetDBStringField(i, "Name", name);
        new index = ((PhonebookPage[playerid] - 1) * MAX_LISTED_NUMBERS) + (i + 1);
        format(string, sizeof(string), "%s\n(%02d) %s\t%i", string, index, name, GetDBIntField(i, "Number"));
        PhoneListedItems[playerid][i] = GetDBIntField(i, "ID");
    }

    if (PhonebookPage[playerid] > 1)
    {
        strcat(string, "\n{FF6347}<< Go back{FFFFFF}");
    }
    if (rows == MAX_LISTED_NUMBERS)
    {
        strcat(string, "\n{00AA00}>> Next page{FFFFFF}");
    }
    Dialog_Show(playerid, Contacts, DIALOG_STYLE_TABLIST_HEADERS, "Phonebook directory", string, "Select", "Close");
}

Dialog:Contacts(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!strcmp(inputtext, "+ Add Contact", true))
        {
            Dialog_Show(playerid, AddContactName, DIALOG_STYLE_INPUT, "{FFFFFF}Add contact", "Please input the name of the contact to add below:", "Submit", "Cancel");
            return 1;
        }
        else if (!strcmp(inputtext, ">> Next page", true))
        {
            PhonebookPage[playerid]++;
        }
        else if (!strcmp(inputtext, "<< Go back", true) && PhonebookPage[playerid] > 1)
        {
            PhonebookPage[playerid]--;
        }
        else
        {
            PhonebookSelected[playerid] = PhoneListedItems[playerid][--listitem];
            Dialog_Show(playerid, ContactOptions, DIALOG_STYLE_LIST, "{FFFFFF}Contact options", "Call contact\nText Message\nSend money\nDelete contact", "Select", "Cancel");
            return 1;
        }
        DBFormat("SELECT * FROM rp_contacts where Playerid = %i ORDER BY Name ASC LIMIT %i, %i",
            PlayerData[playerid][pID], (PhonebookPage[playerid] - 1) * MAX_LISTED_NUMBERS, MAX_LISTED_NUMBERS);
        DBExecute("OnPlayerListContacts", "i", playerid);
    }
    return 1;
}

Dialog:AddContactName(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, AddContactName, DIALOG_STYLE_INPUT, "{FFFFFF}Add contact", "Please input the name of the contact to add below:", "Submit", "Cancel");
        }
        else if (strlen(inputtext) > 24)
        {
            return Dialog_Show(playerid, AddContactName, DIALOG_STYLE_INPUT, "{FFFFFF}Add contact", "The contact name must be below 24 characters.\n\nPlease input the name of the contact to add below:", "Submit", "Cancel");
        }
        else
        {
            strcpy(PhoneTargetName[playerid], inputtext, MAX_PLAYER_NAME);
            Dialog_Show(playerid, AddContactNumber, DIALOG_STYLE_INPUT, "{FFFFFF}Contact number", "Please input the number for the contact '%s':", "Submit", "Cancel", PhoneTargetName[playerid]);
        }
    }
    else
    {
        ListContacts(playerid);
    }
    return 1;
}

Dialog:ContactOptions(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                DBFormat("SELECT Name, Number FROM rp_contacts WHERE ID = %i", PhonebookSelected[playerid]);
                DBExecute("OnPlayerCallContact", "i", playerid);
            }
            case 1:
            {
                DBFormat("SELECT Name, Number FROM rp_contacts WHERE ID = %i", PhonebookSelected[playerid]);
                DBExecute("OnPlayerTextContact", "i", playerid);
            }
            case 2:
            {
                DBFormat("SELECT Name, Number FROM rp_contacts WHERE ID = %i", PhonebookSelected[playerid]);
                DBExecute("OnPlayerSendMoney", "i", playerid);
            }
            case 3:
            {
                DBFormat("DELETE FROM rp_contacts WHERE ID = %i", PhonebookSelected[playerid]);
                DBExecute("OnContactsChanged", "i", playerid);
                SendInfoMessage(playerid, "You have deleted the selected contact.");
            }
        }
    }
    else
    {
        ListContacts(playerid);
    }
    return 1;
}

DB:OnPlayerSendMoney(playerid)
{
    if (GetDBNumRows())
    {
        ShowSendMoneyDialog(playerid, GetDBIntField(0, "Number"));
    }
}

DB:OnPlayerTextContact(playerid)
{
    if (GetDBNumRows())
    {
        ShowSendSmsDialog(playerid, GetDBIntField(0, "Number"));
    }
}
