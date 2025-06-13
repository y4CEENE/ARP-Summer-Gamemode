/// @file      CaseFiles.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-12
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Lottery System <Shane-Roberts>

#include <YSI\y_hooks>

#define MAX_CASEFILE_INFO_LEN 256
static CasefileName[MAX_PLAYERS][MAX_PLAYER_NAME];
static CasefileInfo[MAX_PLAYERS][MAX_CASEFILE_INFO_LEN];

hook OnPlayerInit(playerid)
{
    CasefileInfo[playerid][0] = EOS;
}

CMD:casefiles(playerid, params[])
{
    RCHECK(GetPlayerFaction(playerid) == FACTION_FEDERAL, "Only FBI can use case files");
    if (isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "You can also search: /casefiles [partial name]");
        DBFormat("SELECT * FROM casefiles WHERE active = 1 AND faction = '%d'",
                 PlayerData[playerid][pFaction]);
    }
    else
    {
        DBFormat("SELECT * FROM casefiles WHERE suspect like '%%%e%%' and active = 1 AND faction = '%d'",
                 params, PlayerData[playerid][pFaction]);
    }
    DBExecute("OnCasefileList", "i", playerid);
    return 1;
}

CMD:casefile(playerid, params[])
{
    RCHECK(GetPlayerFaction(playerid) == FACTION_FEDERAL, "Only FBI can use case files");
    return ShowCasefileDialog(playerid);
}

CMD:closecasefile(playerid, params[])
{
    RCHECK(GetPlayerFaction(playerid) == FACTION_FEDERAL, "Only FBI can use case files");
    RCHECK(!isnull(params) || strlen(params) < 3, "USAGE: /closecasefile [partial name]");

    DBFormat("update casefiles set active = 0 WHERE suspect like '%%%e%%' and active = 1 AND faction = '%d'",
             params, PlayerData[playerid][pFaction]);
    DBExecute("CloseCaseFile", "iis", playerid, PlayerData[playerid][pFaction], params);
    return 1;
}

DB:CloseCaseFile(playerid, factionid, name[])
{
    new count = GetDBNumAffectedRows();
    if (count)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "You closed %i case file(s) related to your search '*%s*'", count, name);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY, "No case file found using your search '*%s*'", name);
    }
}

ShowCasefileDialog(playerid)
{
    new title[156], name[MAX_PLAYER_NAME];

    if (CasefileName[playerid][0])
        name = CasefileName[playerid];
    else
        name = "Nobody";

    new factionid = PlayerData[playerid][pFaction];
    format(title, sizeof(title), "{%06x}%s{FFFFFF} - Casefile",
           GetFactionColor(factionid), FactionInfo[factionid][fName]);
    Dialog_Show(playerid, CaseFile, DIALOG_STYLE_LIST, title, "Name: %s\nInformation\nSubmit",
                "Select", "Cancel", name);
    return 1;
}

Dialog:CaseFile(playerid, response, listitem, inputtext[])
{

    if (!response)
    {
        Dialog_Show(playerid, CaseFile_Quit, DIALOG_STYLE_MSGBOX, "Casefile - Cancel",
                    "Are you sure you would like to exit out of the casefile creation?\n"\
                    "(Note: This will reset all of your work)", "Yes", "No");
    }
    else if (listitem == 0 || (listitem == 2 && isnull(CasefileName[playerid])))
    {
        Dialog_Show(playerid, CaseFile_Name, DIALOG_STYLE_INPUT, "Casefile - Name", "Please enter the name of the suspect. (( Firstname_Lastname ))", "Select", "Cancel");
    }
    else if (listitem == 1 || (listitem == 2 && isnull(CasefileName[playerid])))
    {
        Dialog_Show(playerid, CaseFile_Info, DIALOG_STYLE_INPUT, "Casefile - Information", "Please enter a description of the casefile. (( Maximum 256 characters. ))", "Select", "Cancel");
    }
    else if (listitem == 2)
    {
        DBQuery("INSERT INTO casefiles (suspect, issuer, information, faction, active) "\
                "VALUES ('%e', '%e', '%e', %d, 1)",
                CasefileName[playerid], GetPlayerNameEx(playerid), CasefileInfo[playerid], PlayerData[playerid][pFaction]);
    }
    return 1;
}

Dialog:CaseFile_Name(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return ShowCasefileDialog(playerid);
    }

    if (inputtext[0] == EOS)
    {
        CasefileName[playerid][0] = EOS;
        return SendClientMessage(playerid, -1, "You have reset the casefile name.");
    }

    if (strlen(inputtext) > MAX_PLAYER_NAME)
    {
        return ShowCasefileDialog(playerid);
    }

    strcpy(CasefileName[playerid], DBEscape(inputtext));
    DBFormat("SELECT username FROM users WHERE username = '%e'", inputtext);
    DBExecute("OnCasefileName", "i", playerid);
    return 1;
}

DB:OnCasefileName(playerid)
{
    if (!IsPlayerConnected(playerid))
        return 1;

    if (GetDBNumRows() > 0)
    {
        ShowCasefileDialog(playerid);
    }
    else
    {
        CasefileName[playerid][0] = EOS;
        SendClientMessageEx(playerid, COLOR_WHITE, "This name does not exist.");
    }
    return 1;
}

Dialog:CaseFile_Info(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return ShowCasefileDialog(playerid);
    }

    new len = strlen(inputtext);

    if (len == 0)
    {
        CasefileInfo[playerid][0] = EOS;
        SendClientMessage(playerid, -1, "You have reset the casefile information.");
    }
    else if (len < MAX_CASEFILE_INFO_LEN)
    {
        strcpy(CasefileInfo[playerid], DBEscape(inputtext));
        ShowCasefileDialog(playerid);
    }
    return 1;
}

Dialog:CaseFile_Quit(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return ShowCasefileDialog(playerid);
    }
    CasefileName[playerid][0] = EOS;
    CasefileInfo[playerid][0] = EOS;
    return 1;
}

DB:OnCasefileList(playerid)
{
    if (!IsPlayerConnected(playerid))
        return 1;

    new rows = GetDBNumRows();
    RCHECK(rows, "Your faction does not have any casefiles.");

    new suspect[MAX_PLAYER_NAME];
    new issuer[MAX_PLAYER_NAME];
    new information[256];
    new suspectid;

    for(new i; i < rows; i++)
    {
        GetDBStringField(i, "suspect",     suspect);
        GetDBStringField(i, "issuer",      issuer);
        GetDBStringField(i, "information", information);

        suspectid = GetPlayerID(suspect);
        if (IsPlayerConnected(suspectid))
        {
            SendClientMessageEx(playerid, COLOR_GREEN, "%s (ID: %d) | Issuer: %s | Information: %s",
                                suspect, suspectid, issuer, information);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_GREY, "%s | Issuer: %s | Information: %s",
                                suspect, issuer, information);
        }
    }
    return 1;
}
