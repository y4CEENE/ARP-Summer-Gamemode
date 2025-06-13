/// @file      Membership.pwn
/// @author    Khalil
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:members(playerid, params[])
{
    if (PlayerData[playerid][pGang] != -1)
    {
        callcmd::gmembers(playerid, params);
    }
    if (PlayerData[playerid][pFaction] != -1)
    {
        callcmd::fmembers(playerid, params);
    }
    return 1;
}

CMD:bk(playerid, params[])
{
    return callcmd::backup(playerid, params);
}

CMD:backup(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_MEDIC && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't a medic or law enforcer.");
    }
    if (PlayerData[playerid][pInjured])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot call for backup when you are dead.");
    }
    if (PlayerData[playerid][pCuffed])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while cuffed.");
    }
    if (PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command while tied.");
    }
    if (!PlayerData[playerid][pBackup])
    {
        PlayerData[playerid][pBackup] = 1;
    }
    else
    {
        PlayerData[playerid][pBackup] = 0;
    }


    foreach(new i : Player)
    {
        switch (GetPlayerFaction(i))
        {
            case FACTION_POLICE, FACTION_MEDIC, FACTION_FEDERAL, FACTION_ARMY, FACTION_GOVERNMENT:
            {
                if (PlayerData[playerid][pBackup])
                {
                    SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: %s %s is requesting backup in %s (marked on map).", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
                    SetPlayerMarkerForPlayer(i, playerid, (FactionInfo[PlayerData[playerid][pFaction]][fColor] & ~0xff) + 0xFF);
                }
                else
                {
                    SendClientMessageEx(i, COLOR_OLDSCHOOL, "* HQ: %s %s has cancelled their backup request.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), GetPlayerZoneName(playerid));
                    SetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
                }
            }
        }
    }

    return 1;
}

/*#define DIALOG_GANG_TEST 1000

CMD:gangtest(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1 || PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not rank 5+ in a gang.");
    }

    new message[1024];
    format(message, sizeof(message),
        "{FFFFFF}** How to test a new player to enter your gang **\n\n"
        "{FFFF00}# Part 1: Interview\n"
        "{FFFFFF}> - Ask for their name and surname.\n"
        "> - Ask about their age.\n"
        "> - Ask about their experience in gangs.\n"
        "> - Ask if they were in a gang before, and what rank they reached.\n"
        "> - Ask how they can benefit the gang if accepted.\n\n"
        "{FFFF00}# Part 2: Scene RP using /me and /do\n"
        "{FFFFFF}> - In this part, let them roleplay a scene based on your gang’s theme and location.\n"
        "(( Example: If you're in a bar, tell them to make a drink with /me and /do. Observe their actions and responses. ))\n\n"
        "{FFFF00}# Part 3: OOC Rules\n"
        "{FFFFFF}> - Ask them to list 3 RP rules.\n"
        "> - Ask them to list 3 turf rules."
    );

    ShowPlayerDialog(playerid, DIALOG_GANG_TEST, DIALOG_STYLE_MSGBOX, "Gang Entry Test", message, "Close", "");
    return 1;
}*/

CMD:gangpromotion(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_GANG_PROMOTION, DIALOG_STYLE_LIST, "Select Rank Promotion", "From R0 To R1\nFrom R1 To R2\nFrom R2 To R3\nFrom R3 To R4\nFrom R4 To R5\nFrom R5 To R6", 
        "View", "Close");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_GANG_PROMOTION && response)
    {
        new info[512];

        switch(listitem)
        {
            case 0: format(info, sizeof(info), "From R0 To R1:\n\n- 7 days in gang\n- Be active and progress\n- Deposit at least: 60g drugs / 50k cash in gang stash\n(Must be verified in room logs)");
            case 1: format(info, sizeof(info), "From R1 To R2:\n\n- Be active and progress\n- Be mature with 0 strikes or fails\n- Deposit at least: 90g drugs / 75k cash in gang stash\n(Must be verified in room logs)");
            case 2: format(info, sizeof(info), "From R2 To R3:\n\n- Be active and progress\n- Be mature with 0 strikes or fails\n- Responsible for member security during fights and scenes\n- Deposit at least: 130g drugs / 100k cash in gang stash\n(Must be verified in room logs)");
            case 3: format(info, sizeof(info), "From R3 To R4:\n\n- Be active and progress\n- Be mature with 0 strikes or fails\n- Organize members during fights and scenarios\n- Kidnap a rival gang member or LSPD/FBI agent, record interrogation\n- Deposit at least: 130g drugs / 100k cash in gang stash\n(Must be verified in room logs)");
            case 4: format(info, sizeof(info), "From R4 To R5:\n\n- Must complete all previous requirements\n- Leader must approve your application\n(If refused, stay as R4 and continue working)");
            case 5: format(info, sizeof(info), "From R5 To R6:\n\n- Must complete all previous requirements\n- Leader decides based on your activity and contribution");

        }

        ShowPlayerDialog(playerid, 103, DIALOG_STYLE_MSGBOX, "Promotion Details", info, "Close", "");
    }
    return 1;
}
