/// @file      Quiz.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-06-04 16:18:53 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum eQuizType {
    QuizType_ShortAnswer,
    QuizType_MultipleChoice,
};

static QuizQuestion[128];
static QuizHint[128];
static eQuizType:QuizType;
static QuizShortAnswer[64];
static QuizChoiceAnswer;
static QuizChoices[5][64];
static bool:QuizPublished;
static PlayerQuizData[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    PlayerQuizData[playerid] = -1;
    return 1;
}

hook OnGameModeInit()
{
    ResetQuiz();
    return 1;
}

stock ResetQuiz()
{
    QuizQuestion[0] = EOS;
    QuizHint[0] = EOS;
    QuizType = QuizType_ShortAnswer;
    QuizShortAnswer[0] = EOS;
    QuizChoiceAnswer = -1;
    for (new i = 0; i < sizeof(QuizChoices); i++)
    {
        QuizChoices[i][0] = EOS;
    }
    QuizPublished = false;
}

stock QuizTypeToString(eQuizType:type)
{
    new string[20];
    switch (type)
    {
        case QuizType_ShortAnswer:    string = "Short answer";
        case QuizType_MultipleChoice: string = "Multiple choice";
        default: string = "Unknown";
    }
    return string;
}

stock GetQuizAnswerStr()
{
    new answer[64];
    answer[0] = EOS;
    if (QuizType == QuizType_MultipleChoice)
    {
        if (0 <= QuizChoiceAnswer < sizeof(QuizChoices))
        {
            strcpy(answer, QuizChoices[QuizChoiceAnswer]);
        }
    }
    else
    {
        strcpy(answer, QuizShortAnswer);
    }
    return answer;
}

stock ShowDialogQuizSetup(playerid)
{
    new string[1024];
    format(string, sizeof(string),
        "Question: \t%s"\
        "\nHint: \t%s"\
        "\nType: \t%s"\
        "\nAnswer: \t%s",
        QuizQuestion,
        QuizHint,
        QuizTypeToString(QuizType),
        GetQuizAnswerStr());

    if (QuizPublished)
    {
        format(string, sizeof(string), "%s\nEnd", string);
    }
    else
    {
        format(string, sizeof(string), "%s\nPublish", string);
    }

    if (QuizType == QuizType_MultipleChoice)
    {
        new count = 0;
        for (new i = 0; i < sizeof(QuizChoices); i++)
        {
            if (!isnull(QuizChoices[i]))
            {
                count ++;
                format(string, sizeof(string), "%s\nChoice %d: \t%s", string, count, QuizChoices[i]);
            }
        }
        if (count < sizeof(QuizChoices))
        {
            format(string, sizeof(string), "%s\nAdd choice", string);
        }
        if (count > 0)
        {
            format(string, sizeof(string), "%s\nClear choices", string);
        }
    }
    Dialog_Show(playerid, QuizSetup, DIALOG_STYLE_LIST, "Quiz::Setup", string, "Select", "Cancel");
}

Dialog:QuizSetupQuestion(playerid, response, listitem, inputtext[])
{
    if (response && strlen(inputtext) > 3)
        strcpy(QuizQuestion, inputtext, sizeof(QuizQuestion));
    ShowDialogQuizSetup(playerid);
}

Dialog:QuizSetupHint(playerid, response, listitem, inputtext[])
{
    if (response && strlen(inputtext) > 3)
        strcpy(QuizHint, inputtext, sizeof(QuizHint));
    ShowDialogQuizSetup(playerid);
}

Dialog:QuizSetupShortAnswer(playerid, response, listitem, inputtext[])
{
    if (response && strlen(inputtext) > 3)
        strcpy(QuizShortAnswer, inputtext, sizeof(QuizShortAnswer));
    ShowDialogQuizSetup(playerid);
}

Dialog:QuizSetupChoiceAnswer(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new index;
        new count = 0;
        for (index = 0; index < sizeof(QuizChoices) && count < listitem; index++)
        {
            if (!isnull(QuizChoices[index]))
            {
                count++;
            }
        }
        QuizChoiceAnswer = index;
    }
    ShowDialogQuizSetup(playerid);
}

Dialog:QuizSetupEditChoice(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        strcpy(QuizChoices[PlayerQuizData[playerid]], inputtext);
    }
    ShowDialogQuizSetup(playerid);
    return 1;
}

Dialog:QuizSetupNewChoice(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        for (new i = 0; i < sizeof(QuizChoices); i++)
        {
            if (isnull(QuizChoices[i]))
            {
                strcpy(QuizChoices[i], inputtext);
                break;
            }
        }
    }
    ShowDialogQuizSetup(playerid);
}

Dialog:QuizSetup(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    if (QuizPublished && listitem != 1 && listitem != 4)
    {
        return 1;
    }
    switch(listitem)
    {
        case 0: // Question
        {
            Dialog_Show(playerid, QuizSetupQuestion, DIALOG_STYLE_INPUT, "Quiz::Question",
                "Please input the quiz question.\nCurrent value: %s\n - Length: between 3 and 128 characters",
                "Ok", "Cancel", QuizQuestion);
        }
        case 1: // Hint
        {
            Dialog_Show(playerid, QuizSetupHint, DIALOG_STYLE_INPUT, "Quiz::Hint",
                "Please input the quiz hint.\nCurrent value: %s\n - Length: between 3 and 128 characters",
                "Ok", "Cancel", QuizHint);
        }
        case 2: // Type
        {
            if (QuizType == QuizType_MultipleChoice)
            {
                QuizType = QuizType_ShortAnswer;
            }
            else
            {
                QuizType = QuizType_MultipleChoice;
            }
            ShowDialogQuizSetup(playerid);
        }
        case 3: // Answer
        {
            if (QuizType == QuizType_ShortAnswer)
            {
                Dialog_Show(playerid, QuizSetupShortAnswer, DIALOG_STYLE_INPUT, "Quiz::Answer",
                    "Please input the quiz answer.\nCurrent value: %s\n - Length: between 3 and 64 characters",
                    "Ok", "Cancel", QuizShortAnswer);
            }
            else
            {
                new string[512];
                new count = 0;
                for (new i = 0; i < sizeof(QuizChoices); i++)
                {
                    if (!isnull(QuizChoices[i]))
                    {
                        count ++;
                        format(string, sizeof(string), "%s\nChoice %d: \t%s", string, count, QuizChoices[i]);
                    }
                }
                if (count <= 1)
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "You need to add at least 2 choices to select the correct answer.");
                    ShowDialogQuizSetup(playerid);
                }
                else
                {
                    Dialog_Show(playerid, QuizSetupChoiceAnswer, DIALOG_STYLE_LIST, "Quiz::Select the correct answer", string, "Ok", "Cancel");
                }
            }

        }
        case 4: // Publish
        {
            if (QuizPublished)
            {
                SendClientMessageToAllEx(COLOR_RETIRED, "The quiz was ended by %s, answer: %s", GetRPName(playerid), GetQuizAnswerStr());
                ResetQuiz();
            }
            else
            {
                if (isnull(QuizQuestion))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Missing quiz question!");
                }
                new answer[64];
                answer = GetQuizAnswerStr();
                if (isnull(answer))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Missing quiz answer!");
                }

                QuizPublished = true;
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has started a quiz.", GetRPName(playerid));
                SendClientMessageToAllEx(COLOR_RETIRED, "QUIZ: %s (/quiz to answer)", QuizQuestion);
            }
        }
        default:
        {
            new index = listitem - 5;
            new count = 0;
            new i;
            for (i = 0; i < sizeof(QuizChoices); i++)
            {
                if (!isnull(QuizChoices[i]))
                {
                    count ++;
                }
            }
            if ( index < count)
            {
                PlayerQuizData[playerid] = i;
                Dialog_Show(playerid, QuizSetupEditChoice, DIALOG_STYLE_INPUT, "Quiz::NewChoice",
                    "Current value: %s\nPlease input the new quiz choice value:", "Ok", "Cancel", QuizChoices[i]);
            }
            else if (index == count)
            {
                if (count < sizeof(QuizChoices))
                {
                    Dialog_Show(playerid, QuizSetupNewChoice, DIALOG_STYLE_INPUT, "Quiz::NewChoice", "Please input a quiz choice:", "Ok", "Cancel");
                }
                else
                {
                    for (new idx = 0; idx < sizeof(QuizChoices); idx++)
                        QuizChoices[idx][0] = EOS;
                    ShowDialogQuizSetup(playerid);
                }
            }
            else if (index == count + 1)
            {
                for (new idx = 0; idx < sizeof(QuizChoices); idx++)
                    QuizChoices[idx][0] = EOS;
                ShowDialogQuizSetup(playerid);
            }
        }
    }

    return 1;
}

CMD:quiz(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_3))
    {
        ShowDialogQuizSetup(playerid);
        return 1;
    }

    if (!QuizPublished)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no active quiz!");
    }

    if (QuizType == QuizType_MultipleChoice)
    {
        if (!isnull(QuizHint))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Quiz hint: %s", QuizHint);
        }

        new string[512];
        new count = 0;
        for (new i = 0; i < sizeof(QuizChoices); i++)
        {
            if (!isnull(QuizChoices[i]))
            {
                count ++;
                format(string, sizeof(string), "%s\nChoice %d: \t%s", string, count, QuizChoices[i]);
            }
        }
        new title[140];
        format(title, sizeof(title), "Quiz::%s", QuizQuestion);
        Dialog_Show(playerid, QuizChoiceAnswer, DIALOG_STYLE_LIST, title, string, "Select", "Cancel");
    }
    else
    {
        new hint[80];
        if (!isnull(QuizHint))
        {
            format(hint, sizeof(hint), "Hint: %s", QuizHint);
        }
        else
        {
            hint[0] = EOS;
        }
        Dialog_Show(playerid, QuizShortAnswer, DIALOG_STYLE_INPUT, "Quiz", "Question: %s\n%s", "Ok", "Cancel", QuizQuestion, hint);
    }
    return 1;
}

Dialog:QuizChoiceAnswer(playerid, response, listitem, inputtext[])
{
    if (!response || !QuizPublished)
    {
        return 1;
    }
    new count;
    for (new i = 0; i < sizeof(QuizChoices); i++)
    {
        if (!isnull(QuizChoices[i]))
        {
            if (count == listitem && i == QuizChoiceAnswer)
            {
                // Correct answer
                SendClientMessageToAllEx(COLOR_RETIRED, "%s has answered the quiz correctly. answer: %s", GetRPName(playerid), GetQuizAnswerStr());
                ResetQuiz();
                return 1;
            }
            count ++;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "Sorry bud, that ain't the right answer.");
    return 1;
}

Dialog:QuizShortAnswer(playerid, response, listitem, inputtext[])
{
    if (!response || !QuizPublished)
    {
        return 1;
    }
    if (!strcmp(QuizShortAnswer, inputtext, true))
    {
        // Correct answer
        SendClientMessageToAllEx(COLOR_RETIRED, "%s has answered the quiz correctly. answer: %s", GetRPName(playerid), GetQuizAnswerStr());
        ResetQuiz();
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "Sorry bud, that ain't the right answer.");
    }
    return 1;
}
