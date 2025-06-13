/// @file      GangVoteSystem.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-20 21:31:29 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static GangVote_Question[MAX_GANGS][128];
static GangVote_Answers[MAX_GANGS][5][128];
static GangVote_AnswersCount[MAX_GANGS][5];
static GangVote_Voted[MAX_GANGS][MAX_PLAYERS];
static GangVote_CanVote[MAX_GANGS];

hook OnGameModeInit()
{
    for (new i = 0; i < MAX_GANGS; i++)
    {
        GangVote_CanVote[i] = false;
        GangVote_Question[i][0] = 0;
        GangVote_Answers[i][0][0] = 0;
        GangVote_Answers[i][1][0] = 0;
        GangVote_Answers[i][2][0] = 0;
        GangVote_Answers[i][3][0] = 0;
        GangVote_Answers[i][4][0] = 0;
    }
    return 1;
}

hook OnPlayerInit(playerid)
{
    for (new i = 0; i < MAX_GANGS; i++)
    {
        GangVote_Voted[i][playerid] = false;
    }
    return 1;
}

ShowCreateGVoteDialog(playerid)
{
    new gangid = PlayerData[playerid][pGang];
    new menu[512];
    format(menu, sizeof(menu), "Question: %s\nAdd Answer\nClear Answers\nPublish", GangVote_Question[gangid]);
    new count = 0;
    for (new i=0;i<5;i++)
    {
        if (!isnull(GangVote_Answers[gangid][i]))
        {
            count++;
            format(menu, sizeof(menu), "%s\n Answer %d: %s", menu, count, GangVote_Answers[gangid][i]);
        }
    }

    Dialog_Show(playerid, GVoteSystemMenu, DIALOG_STYLE_LIST, "Create vote", menu, "Select", "Cancel");
}

CMD:creategvote(playerid, params[])
{
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang.");
    }
    if (PlayerData[playerid][pGangRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be R4+ to create a gang vote.");
    }
    ShowCreateGVoteDialog(playerid);
    return 1;
}

CMD:endgvote(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];
    if (gangid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang.");
    }
    if (PlayerData[playerid][pGangRank] < 4)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to be R4+ to end a gang vote.");
    }
    GangVote_CanVote[gangid] = false;
    foreach(new targetid: Player)
    {
        if (PlayerData[targetid][pLogged] && gangid == PlayerData[playerid][pGang])
        {
            SendClientMessageEx(targetid, COLOR_AQUA, " *** Vote Ended ***");
            SendClientMessageEx(targetid, COLOR_GREEN, "Question:{FFFFFF} %s", GangVote_Question[gangid]);

            for (new i=0, count=0;i<5;i++)
            {
                if (!isnull(GangVote_Answers[gangid][i]))
                {
                    count++;
                    SendClientMessageEx(targetid, COLOR_GREEN, "Answer %d:{FFFFFF} %s (%d votes)", count,
                        GangVote_Answers[gangid][i], GangVote_AnswersCount[gangid][i]);
                }
            }
        }
    }
    return 1;
}

CMD:gvote(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];
    if (gangid == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a gang.");
    }
    if (!GangVote_CanVote[gangid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no gang vote for the moment.");
    }
    if (GangVote_Voted[gangid][playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already voted.");
    }
    new title[128],menu[512];

    menu[0] = 0;

    format(title, sizeof(title), "Question: %s", GangVote_Question[gangid]);

    new count = 0;
    for (new i=0;i<5;i++)
    {
        if (!isnull(GangVote_Answers[gangid][i]))
        {
            count++;
            format(menu, sizeof(menu), "%s\n Answer %d: %s", menu, count, GangVote_Answers[gangid][i]);
        }
    }

    Dialog_Show(playerid, GVoteSystemPlayerVote, DIALOG_STYLE_LIST, title, menu, "Vote", "Cancel");
    return 1;
}

Dialog:GVoteSystemPlayerVote(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (0 <= listitem <= 4)
        {
            new gangid = PlayerData[playerid][pGang];
            if (gangid == -1)
                return 1;
            GangVote_Voted[gangid][playerid] = true;
            GangVote_AnswersCount[gangid][listitem]++;
            SendClientMessageEx(playerid, COLOR_GREY, "Thank's for voting. Your vote: %s", GangVote_Answers[gangid][listitem]);
        }
    }
    return 1;
}
Dialog:GVoteSystemEditQuestion(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new gangid = PlayerData[playerid][pGang];
        if (gangid == -1)
            return 1;
        format(GangVote_Question[gangid], 128, inputtext);
    }
    ShowCreateGVoteDialog(playerid);
    return 1;
}
Dialog:GVoteSystemAddAnswer(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new gangid = PlayerData[playerid][pGang];
        if (gangid == -1)
            return 1;
        for (new i=0;i<5;i++)
        {
            if (isnull(GangVote_Answers[gangid][i]))
            {
                format(GangVote_Answers[gangid][i], 128, inputtext);
                break;
            }
        }
    }
    ShowCreateGVoteDialog(playerid);
    return 1;
}

Dialog:GVoteSystemMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }

    new gangid = PlayerData[playerid][pGang];
    if (gangid == -1)
        return 1;

    switch (listitem)
    {
        case 0:
        {
            // Edit Question
            Dialog_Show(playerid, GVoteSystemEditQuestion, DIALOG_STYLE_INPUT, "Create vote", "Enter vote question", "Ok", "Cancel");
        }
        case 1:
        {
            new next = -1;
            for (new i=0;i<5;i++)
            {
                if (isnull(GangVote_Answers[gangid][i]))
                {
                    next = i;
                    break;
                }
            }

            if (next == -1)
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't add more answers.");
                ShowCreateGVoteDialog(playerid);
                return 1;
            }
            // Add Answer
            Dialog_Show(playerid, GVoteSystemAddAnswer, DIALOG_STYLE_INPUT, "Create vote", "Enter vote answer", "Ok", "Cancel");
        }
        case 2:
        {
            // Clear Answers
            GangVote_Answers[gangid][0][0] = 0;
            GangVote_Answers[gangid][1][0] = 0;
            GangVote_Answers[gangid][2][0] = 0;
            GangVote_Answers[gangid][3][0] = 0;
            GangVote_Answers[gangid][4][0] = 0;
            ShowCreateGVoteDialog(playerid);
        }
        case 3:
        {
            // Publish
            new l = 0;
            for (new i=0;i<5;i++)
            {
                if (!isnull(GangVote_Answers[gangid][i]))
                {
                    l++;
                }
            }
            if (l<2)
            {
                SendClientMessageEx(playerid, COLOR_AQUA, "A vote must have at least 2 answers");
                ShowCreateGVoteDialog(playerid);
                return 1;
            }
            foreach(new targetid: Player)
            {
                if (PlayerData[targetid][pLogged])
                {
                    SendClientMessageEx(targetid, COLOR_AQUA, " *** Vote ***");
                    SendClientMessageEx(targetid, COLOR_GREEN, "Question:{FFFFFF} %s", GangVote_Question[gangid]);

                    for (new i=0, count=0;i<5;i++)
                    {
                        if (!isnull(GangVote_Answers[gangid][i]))
                        {
                            count++;
                            SendClientMessageEx(targetid, COLOR_GREEN, "Answer %d:{FFFFFF} %s", count, GangVote_Answers[gangid][i]);
                        }
                    }
                    SendClientMessageEx(targetid, COLOR_AQUA, "Use /gvote to vote");
                }
            }

            for (new idx=0;idx<5;idx++)
            {
                GangVote_AnswersCount[gangid][idx] = 0;
            }
            for (new idx=0;idx<MAX_PLAYERS;idx++)
            {
                GangVote_Voted[gangid][idx] = false;
            }
            GangVote_CanVote[gangid] = true;
        }
        default:
        {
            if ( 0 <= listitem - 4 < 4)
            {
                GangVote_Answers[gangid][listitem - 4][0] = 0;
                Dialog_Show(playerid, GVoteSystemAddAnswer, DIALOG_STYLE_INPUT, "Create vote", "Enter vote answer", "Ok", "Cancel");
            }
        }

    }

    return 1;
}
