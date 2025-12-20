#include <YSI\y_hooks>

static VoteQuestion[128];
static VoteAnswers[5][128];
static VoteAnswersCount[5];
static PlayerVoted[MAX_PLAYERS];
static CanVote;

hook OnGameModeInit()
{
    CanVote = false;
    VoteQuestion[0] = 0;
    VoteAnswers[0][0] = 0;
    VoteAnswers[1][0] = 0;
    VoteAnswers[2][0] = 0;
    VoteAnswers[3][0] = 0;
    VoteAnswers[4][0] = 0;
    return 1;
}

hook OnPlayerInit(playerid)
{
    PlayerVoted[playerid] = false;
    return 1;
}

ShowCreateVoteDialog(playerid)
{
    new menu[512];
    format(menu, sizeof(menu), "Question: %s\nAdd Answer\nClear Answers\nPublish", VoteQuestion);
    new count = 0;
    for(new i=0;i<5;i++)
    {
        if(!isnull(VoteAnswers[i]))
        {
            count++;
            format(menu, sizeof(menu), "%s\n Answer %d: %s", menu, count, VoteAnswers[i]);
        }
    }

    Dialog_Show(playerid, VoteSystemMenu, DIALOG_STYLE_LIST, "Create vote", menu, "Select", "Cancel");
}

CMD:createvote(playerid, params[])
{
    if(IsAdmin(playerid))
    {
        ShowCreateVoteDialog(playerid);
    }
    return 1;
}
CMD:endvote(playerid, params[])
{
    if(IsAdmin(playerid))
    {
        CanVote = false;
        foreach(new targetid: Player)
        {
            if(PlayerData[targetid][pLogged])
            {
                SendClientMessageEx(targetid, COLOR_AQUA, " *** Vote Ended ***");
                SendClientMessageEx(targetid, COLOR_GREEN, "Question:{FFFFFF} %s", VoteQuestion);
                
                for(new i=0, count=0;i<5;i++)
                {
                    if(!isnull(VoteAnswers[i]))
                    {
                        count++;
                        SendClientMessageEx(targetid, COLOR_GREEN, "Answer %d:{FFFFFF} %s (%d votes)", count, VoteAnswers[i], VoteAnswersCount[i]);
                    }
                }
            }
        }
    }
    return 1;
}

CMD:vote(playerid, params[])
{
    if(!CanVote)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no vote for the moment.");
    }
    if(PlayerVoted[playerid])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already voted.");
    }
    new title[128],menu[512];
    
    menu[0] = 0;
    
    format(title, sizeof(title), "Question: %s", VoteQuestion);

    new count = 0;
    for(new i=0;i<5;i++)
    {
        if(!isnull(VoteAnswers[i]))
        {
            count++;
            format(menu, sizeof(menu), "%s\n Answer %d: %s", menu, count, VoteAnswers[i]);
        }
    }

    Dialog_Show(playerid, VoteSystemPlayerVote, DIALOG_STYLE_LIST, title, menu, "Vote", "Cancel");
    return 1;
}

Dialog:VoteSystemPlayerVote(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(0 <= listitem <= 4)
        {
            PlayerVoted[playerid] = true;
            VoteAnswersCount[listitem] ++;
            SendClientMessageEx(playerid, COLOR_GREY, "Thank's for voting. Your vote: %s", VoteAnswers[listitem]);
        }
    }
    return 1;
}
Dialog:VoteSystemEditQuestion(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        format(VoteQuestion, sizeof(VoteQuestion), inputtext);
    }
    ShowCreateVoteDialog(playerid);
    return 1;
}
Dialog:VoteSystemAddAnswer(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        for(new i=0;i<5;i++)
        {
            if(isnull(VoteAnswers[i]))
            {
                format(VoteAnswers[i], 128, inputtext);
                break;
            }
        }
    }
    ShowCreateVoteDialog(playerid);
    return 1;
}

Dialog:VoteSystemMenu(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    switch(listitem)
    {
        case 0:
        {
            // Edit Question
            Dialog_Show(playerid, VoteSystemEditQuestion, DIALOG_STYLE_INPUT, "Create vote", "Enter vote question", "Ok", "Cancel");
        }
        case 1:
        {
            new next = -1;
            for(new i=0;i<5;i++)
            {
                if(isnull(VoteAnswers[i]))
                {
                    next = i;
                    break;
                }
            }
            if(next == -1)
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't add more answers.");
                ShowCreateVoteDialog(playerid);
                return 1;
            }
            // Add Answer
            Dialog_Show(playerid, VoteSystemAddAnswer, DIALOG_STYLE_INPUT, "Create vote", "Enter vote answer", "Ok", "Cancel");
        }
        case 2:
        {
            // Clear Answers
            VoteAnswers[0][0] = 0;
            VoteAnswers[1][0] = 0;
            VoteAnswers[2][0] = 0;
            VoteAnswers[3][0] = 0;
            VoteAnswers[4][0] = 0;
            ShowCreateVoteDialog(playerid);
        }
        case 3:
        {
            // Publish
            new l = 0;
            for(new i=0;i<5;i++)
            {
                if(!isnull(VoteAnswers[i]))
                {
                    l++;
                }
            }
            if(l<2)
            {
                SendClientMessageEx(playerid, COLOR_AQUA, "A vote must have at least 2 answers");
                ShowCreateVoteDialog(playerid);
                return 1;
            }
            foreach(new targetid: Player)
            {
                if(PlayerData[targetid][pLogged])
                {
                    SendClientMessageEx(targetid, COLOR_AQUA, " *** Vote ***");
                    SendClientMessageEx(targetid, COLOR_GREEN, "Question:{FFFFFF} %s", VoteQuestion);
                    
                    for(new i=0, count=0;i<5;i++)
                    {
                        if(!isnull(VoteAnswers[i]))
                        {
                            count++;
                            SendClientMessageEx(targetid, COLOR_GREEN, "Answer %d:{FFFFFF} %s", count, VoteAnswers[i]);
                        }
                    }
                    SendClientMessageEx(targetid, COLOR_AQUA, "Use /vote to vote");
                }
            }
    
            for(new idx=0;idx<5;idx++)
            {
                VoteAnswersCount[idx] = 0;
            }
            for(new idx=0;idx<MAX_PLAYERS;idx++)
            {
                PlayerVoted[idx] = false;
            }
            CanVote = true;
        }
        default:
        {
            if( 0 <= listitem - 4 < 4)
            {
                VoteAnswers[listitem - 4][0] = 0;
                Dialog_Show(playerid, VoteSystemAddAnswer, DIALOG_STYLE_INPUT, "Create vote", "Enter vote answer", "Ok", "Cancel");
            }
        }

    }

    return 1;
}