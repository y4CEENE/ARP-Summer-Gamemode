/// @file      FactionVoteSystem.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-20 21:31:29 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static FactionVote_Question[MAX_FACTIONS][128];
static FactionVote_Answers[MAX_FACTIONS][5][128];
static FactionVote_AnswersCount[MAX_FACTIONS][5];
static FactionVote_Voted[MAX_FACTIONS][MAX_PLAYERS];
static FactionVote_CanVote[MAX_FACTIONS];

hook OnGameModeInit()
{
    for (new i = 0; i < MAX_FACTIONS; i++)
    {
        FactionVote_CanVote[i] = false;
        FactionVote_Question[i][0] = 0;
        FactionVote_Answers[i][0][0] = 0;
        FactionVote_Answers[i][1][0] = 0;
        FactionVote_Answers[i][2][0] = 0;
        FactionVote_Answers[i][3][0] = 0;
        FactionVote_Answers[i][4][0] = 0;
    }
    return 1;
}

hook OnPlayerInit(playerid)
{
    for (new i = 0; i < MAX_FACTIONS; i++)
    {
        FactionVote_Voted[i][playerid] = false;
    }
    return 1;
}

ShowCreateFVoteDialog(playerid)
{
    new factionid = PlayerData[playerid][pFaction];
    new menu[512];
    format(menu, sizeof(menu), "Question: %s\nAdd Answer\nClear Answers\nPublish", FactionVote_Question[factionid]);
    new count = 0;
    for (new i=0;i<5;i++)
    {
        if (!isnull(FactionVote_Answers[factionid][i]))
        {
            count++;
            format(menu, sizeof(menu), "%s\n Answer %d: %s", menu, count, FactionVote_Answers[factionid][i]);
        }
    }

    Dialog_Show(playerid, FVoteSystemMenu, DIALOG_STYLE_LIST, "Create vote", menu, "Select", "Cancel");
}

CMD:createfvote(playerid, params[])
{
    if (PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction.");
    }
    if (PlayerData[playerid][pFactionRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be R4+ to create a faction vote.");
    }
    ShowCreateFVoteDialog(playerid);
    return 1;
}

CMD:endfvote(playerid, params[])
{
    new factionid = PlayerData[playerid][pFaction];
    if (factionid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction.");
    }
    if (PlayerData[playerid][pFactionRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be R4+ to end a faction vote.");
    }
    FactionVote_CanVote[factionid] = false;
    foreach(new targetid: Player)
    {
        if (PlayerData[targetid][pLogged] && factionid == PlayerData[playerid][pFaction])
        {
            SendClientMessageEx(targetid, COLOR_AQUA, " *** Vote Ended ***");
            SendClientMessageEx(targetid, COLOR_GREEN, "Question:{FFFFFF} %s", FactionVote_Question[factionid]);

            for (new i=0, count=0;i<5;i++)
            {
                if (!isnull(FactionVote_Answers[factionid][i]))
                {
                    count++;
                    SendClientMessageEx(targetid, COLOR_GREEN, "Answer %d:{FFFFFF} %s (%d votes)", count,
                        FactionVote_Answers[factionid][i], FactionVote_AnswersCount[factionid][i]);
                }
            }
        }
    }
    return 1;
}

CMD:fvote(playerid, params[])
{
    new factionid = PlayerData[playerid][pFaction];
    if (factionid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction.");
    }
    if (!FactionVote_CanVote[factionid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no faction vote for the moment.");
    }
    if (FactionVote_Voted[factionid][playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already voted.");
    }
    new title[128],menu[512];

    menu[0] = 0;

    format(title, sizeof(title), "Question: %s", FactionVote_Question[factionid]);

    new count = 0;
    for (new i=0;i<5;i++)
    {
        if (!isnull(FactionVote_Answers[factionid][i]))
        {
            count++;
            format(menu, sizeof(menu), "%s\n Answer %d: %s", menu, count, FactionVote_Answers[factionid][i]);
        }
    }

    Dialog_Show(playerid, FVoteSystemPlayerVote, DIALOG_STYLE_LIST, title, menu, "Vote", "Cancel");
    return 1;
}

Dialog:FVoteSystemPlayerVote(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (0 <= listitem <= 4)
        {
            new factionid = PlayerData[playerid][pFaction];
            if (factionid == -1)
                return 1;
            FactionVote_Voted[factionid][playerid] = true;
            FactionVote_AnswersCount[factionid][listitem]++;
            SendClientMessageEx(playerid, COLOR_GREY, "Thank's for voting. Your vote: %s", FactionVote_Answers[factionid][listitem]);
        }
    }
    return 1;
}

Dialog:FVoteSystemEditQuestion(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new factionid = PlayerData[playerid][pFaction];
        if (factionid == -1)
            return 1;
        format(FactionVote_Question[factionid], 128, inputtext);
    }
    ShowCreateFVoteDialog(playerid);
    return 1;
}

Dialog:FVoteSystemAddAnswer(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new factionid = PlayerData[playerid][pFaction];
        if (factionid == -1)
            return 1;
        for (new i=0;i<5;i++)
        {
            if (isnull(FactionVote_Answers[factionid][i]))
            {
                format(FactionVote_Answers[factionid][i], 128, inputtext);
                break;
            }
        }
    }
    ShowCreateFVoteDialog(playerid);
    return 1;
}

Dialog:FVoteSystemMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }

    new factionid = PlayerData[playerid][pFaction];
    if (factionid == -1)
        return 1;

    switch (listitem)
    {
        case 0:
        {
            // Edit Question
            Dialog_Show(playerid, FVoteSystemEditQuestion, DIALOG_STYLE_INPUT, "Create vote", "Enter vote question", "Ok", "Cancel");
        }
        case 1:
        {
            new next = -1;
            for (new i=0;i<5;i++)
            {
                if (isnull(FactionVote_Answers[factionid][i]))
                {
                    next = i;
                    break;
                }
            }

            if (next == -1)
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't add more answers.");
                ShowCreateFVoteDialog(playerid);
                return 1;
            }
            // Add Answer
            Dialog_Show(playerid, FVoteSystemAddAnswer, DIALOG_STYLE_INPUT, "Create vote", "Enter vote answer", "Ok", "Cancel");
        }
        case 2:
        {
            // Clear Answers
            FactionVote_Answers[factionid][0][0] = 0;
            FactionVote_Answers[factionid][1][0] = 0;
            FactionVote_Answers[factionid][2][0] = 0;
            FactionVote_Answers[factionid][3][0] = 0;
            FactionVote_Answers[factionid][4][0] = 0;
            ShowCreateFVoteDialog(playerid);
        }
        case 3:
        {
            // Publish
            new l = 0;
            for (new i=0;i<5;i++)
            {
                if (!isnull(FactionVote_Answers[factionid][i]))
                {
                    l++;
                }
            }
            if (l<2)
            {
                SendClientMessageEx(playerid, COLOR_AQUA, "A vote must have at least 2 answers");
                ShowCreateFVoteDialog(playerid);
                return 1;
            }
            foreach(new targetid: Player)
            {
                if (PlayerData[targetid][pLogged])
                {
                    SendClientMessageEx(targetid, COLOR_AQUA, " *** Vote ***");
                    SendClientMessageEx(targetid, COLOR_GREEN, "Question:{FFFFFF} %s", FactionVote_Question[factionid]);

                    for (new i=0, count=0;i<5;i++)
                    {
                        if (!isnull(FactionVote_Answers[factionid][i]))
                        {
                            count++;
                            SendClientMessageEx(targetid, COLOR_GREEN, "Answer %d:{FFFFFF} %s", count, FactionVote_Answers[factionid][i]);
                        }
                    }
                    SendClientMessageEx(targetid, COLOR_AQUA, "Use /fvote to vote");
                }
            }

            for (new idx=0;idx<5;idx++)
            {
                FactionVote_AnswersCount[factionid][idx] = 0;
            }
            for (new idx=0;idx<MAX_PLAYERS;idx++)
            {
                FactionVote_Voted[factionid][idx] = false;
            }
            FactionVote_CanVote[factionid] = true;
        }
        default:
        {
            if ( 0 <= listitem - 4 < 4)
            {
                FactionVote_Answers[factionid][listitem - 4][0] = 0;
                Dialog_Show(playerid, FVoteSystemAddAnswer, DIALOG_STYLE_INPUT, "Create vote", "Enter vote answer", "Ok", "Cancel");
            }
        }

    }

    return 1;
}
