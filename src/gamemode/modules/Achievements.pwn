#include <YSI\y_hooks>

enum AchievementID
{
    ACH_FirstWheels,
    ACH_WorkingClass,
    ACH_LegalDriver,
    ACH_MeetingPeople,
    ACH_Regular,
    ACH_Addicted,
    ACH_FiveStars,
    ACH_TopTier,
    ACH_DressUp,
    ACH_DirtyDeeds,
    ACH_Dedication,
    ACH_Obamacare,
    ACH_HighRoller,
    ACH_ImRich,
    ACH_Benefits,
    ACH_Experienced,
    ACH_HighTimes,
    ACH_PartyHard,
    ACH_FlashMob,
    ACH_CookieJar,
    ACH_Diamond,
    ACH_AcmeDinamyte,
    ACH_BlackHole,
    ACH_IllegalWeapon,
    ACH_Fitness,
    ACH_AtTheEnd,
    ACH_FinallyAJob,
    ACH_HomeSweetHome,
    ACH_ADirtyMind,
    ACH_YouAreAHooker
};

enum achievementEnum
{
	aName[24],
	aDescription[64]
};

static const AchievementInfo[AchievementID][achievementEnum] =
{
    { "First wheels",    "Purchase a vehicle for the first time."},
    { "Working class",   "Earn $20,000 on your paycheck."},
    { "Legal driver",    "Acquire your drivers license at the DMV."},
    { "Meeting people",  "Shake a hand for the first time."},
    { "Regular",         "Play a total of 20 playing hours."},
    { "Addicted",        "Play a total of 40 playing hours."},
    { "Five stars",      "Achieve level 5 on your account."},
    { "Top tier",        "Achieve level 10 on your account."},
    { "Dress up",        "Attach up to 5 clothing items at once."},
    { "Dirty deeds",     "Complete a drug deal with someone."},
    { "Dedication",      "Complete an entire matrun onfoot."},
    { "Obamacare",       "Spawn at a hospital while insured."},
    { "High roller",     "Earn $500,000 in total money."},
    { "I'm rich!",       "Spend $500,000 in total money."},
    { "Benefits",        "Fully - a perk for the first time."},
    { "Experienced",     "Fully maximize your skill level for any job."},
    { "High times",      "Get stoned for the first time."},
    { "Party hard",      "Buy alcohol at a bar and get drunk."},
    { "Flash mob",       "Dance with five other people at once."},
    { "Cookie jar",      "Earn a total of five cookies."},
    { "Diamond!",        "Mine a diamond."},
    { "Acme Dinamyte",   "Get Exploded by an Admin."},
    { "A black Hole",    "Get Admin Killed."},
    { "Illegal Weapon",  "Buy a Weapon in the Ammunation."},
    { "Fitness",         "Train yourself in a Gym."},
    { "At the End",      "Finish your Tutorial."},
    { "Finally, A Job",  "Get your First Job."},
    { "Home Sweet Home", "Buy Your First House."},
    { "A Dirty Mind",    "Wanking."},
    { "You're a hooker", "Make a Blowjob"}
};

static PlayerAchivements[MAX_PLAYERS][128];
static PlayerText:PlayerAchivementsText[MAX_PLAYERS][4];


hook OnLoadPlayer(playerid, row)
{
    new ach[128];
    cache_get_field_content(row, "achivements", ach);
    format(PlayerAchivements[playerid], 128, "%s", ach);
    return 1;
}

SetAchievement(playerid, AchievementID:achievementid)
{
    new index = _:achievementid;
    new len = strlen(PlayerAchivements[playerid]);

    if( len <= index)
    {
        for(;len<index;len++)
        {
            PlayerAchivements[playerid][len] = '0';
        }
        PlayerAchivements[playerid][index] = '1';
        PlayerAchivements[playerid][index+1] = '\0';
    }
    else if(PlayerAchivements[playerid][index] == '0')
    {
        PlayerAchivements[playerid][index] = '1';
    }
    else
    {
        return false;
    }
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET achivements = '%s' WHERE uid = %i", PlayerAchivements[playerid], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    return true;
}

GetPlayerTotalAchievements(playerid)
{
    new count = 0;
    for(new idx=0;PlayerAchivements[playerid][idx]!='\0';idx++)
    {
        if(PlayerAchivements[playerid][idx] == '1')
        {
            count++;
        }
    }
    return count;
}

AwardAchievement(playerid, AchievementID:achievementid)
{
    if(SetAchievement(playerid, achievementid))
    {
        new count = GetPlayerTotalAchievements(playerid);
        new string[128];
        format(string, sizeof(string), "~g~~h~~h~%s~n~~w~(%i/%i unlocked)", AchievementInfo[achievementid][aName], count, sizeof(AchievementInfo));
        PlayerTextDrawSetString(playerid, PlayerAchivementsText[playerid][3], string);

        for(new i = 0; i < 4; i ++)
        {
            PlayerTextDrawShow(playerid, PlayerAchivementsText[playerid][i]);
        }

        if(count == sizeof(AchievementInfo))
        {
            SendClientMessageToAllEx(COLOR_GREEN, "Congratulations to %s for completeting the achievement challenge, they've received 50 cookies.", GetRPName(playerid));
            SendClientMessage(playerid, COLOR_AQUA, "Well done! You have completed all achievements and received 50 cookies.");
            GivePlayerCookies(playerid, 50);
        }

        SetTimerEx("HideAchievementTextdraw", 10000, false, "i", playerid);
    }
	return 0;
}

publish HideAchievementTextdraw(playerid)
{
	for(new i = 0; i < 4; i ++)
	{
	    PlayerTextDrawHide(playerid, PlayerAchivementsText[playerid][i]);
	}
}

hook OnPlayerInit(playerid)
{
    PlayerAchivements[playerid][0] = '\0';
	// Achievements
	PlayerAchivementsText[playerid][0] = CreatePlayerTextDraw(playerid, 502.000000, 110.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerAchivementsText[playerid][0], 255);
	PlayerTextDrawFont(playerid, PlayerAchivementsText[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerAchivementsText[playerid][0], 0.500000, 4.500000);
	PlayerTextDrawColor(playerid, PlayerAchivementsText[playerid][0], -1);
	PlayerTextDrawSetOutline(playerid, PlayerAchivementsText[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerAchivementsText[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerAchivementsText[playerid][0], 1);
	PlayerTextDrawUseBox(playerid, PlayerAchivementsText[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, PlayerAchivementsText[playerid][0], 102);
	PlayerTextDrawTextSize(playerid, PlayerAchivementsText[playerid][0], 611.000000, 0.000000);

	PlayerAchivementsText[playerid][1] = CreatePlayerTextDraw(playerid, 502.000000, 116.000000, "LD_DRV:gold");
	PlayerTextDrawBackgroundColor(playerid, PlayerAchivementsText[playerid][1], 255);
	PlayerTextDrawFont(playerid, PlayerAchivementsText[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PlayerAchivementsText[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerAchivementsText[playerid][1], -1);
	PlayerTextDrawSetOutline(playerid, PlayerAchivementsText[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerAchivementsText[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerAchivementsText[playerid][1], 1);
	PlayerTextDrawUseBox(playerid, PlayerAchivementsText[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, PlayerAchivementsText[playerid][1], 255);
	PlayerTextDrawTextSize(playerid, PlayerAchivementsText[playerid][1], 31.000000, 33.000000);

	PlayerAchivementsText[playerid][2] = CreatePlayerTextDraw(playerid, 499.000000, 99.000000, "Achievements");
	PlayerTextDrawBackgroundColor(playerid, PlayerAchivementsText[playerid][2], 255);
	PlayerTextDrawFont(playerid, PlayerAchivementsText[playerid][2], 0);
	PlayerTextDrawLetterSize(playerid, PlayerAchivementsText[playerid][2], 0.409999, 1.700000);
	PlayerTextDrawColor(playerid, PlayerAchivementsText[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid, PlayerAchivementsText[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerAchivementsText[playerid][2], 1);

	PlayerAchivementsText[playerid][3] = CreatePlayerTextDraw(playerid, 539.000000, 121.000000, "~g~~h~~h~First wheels");
	PlayerTextDrawBackgroundColor(playerid, PlayerAchivementsText[playerid][3], 255);
	PlayerTextDrawFont(playerid, PlayerAchivementsText[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, PlayerAchivementsText[playerid][3], 0.230000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerAchivementsText[playerid][3], -1);
	PlayerTextDrawSetOutline(playerid, PlayerAchivementsText[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerAchivementsText[playerid][3], 1);
    return 1;
}

CMD:achievements(playerid, params[])
{
    static string[2048];
    string = "Name\tDescription\tStatus";

    new len = strlen(PlayerAchivements[playerid]);
    new count = 0;

    for(new i = 0; i < sizeof(AchievementInfo); i++)
    {
        new AchievementID:achid = AchievementID:i;
        if(i < len && PlayerAchivements[playerid][i] == '1')
        {
            count++;
            format(string, sizeof(string), "%s\n%s\t%s\t{00AA00}Unlocked{FFFFFF}", string, AchievementInfo[achid][aName], AchievementInfo[achid][aDescription]);
        }
        else
        {
            format(string, sizeof(string), "%s\n%s\t%s\t{ED6464}Locked{FFFFFF}", string, AchievementInfo[achid][aName], AchievementInfo[achid][aDescription]);
        }
    }

    new title[64];
    format(title, sizeof(title), "Achievements (%i/%i unlocked)", count, sizeof(AchievementInfo));

    Dialog_Show(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, title, string, "OK", "");
	return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if(GetPlayerSpecialAction(playerid) < 5)
    {
        return 1;
    }
    if(GetPlayerSpecialAction(playerid) > 8)
    {
        return 1;
    }
    new count = 0;
    foreach(new targetid:Player)
    {
        if(targetid == playerid)
        {
            continue;
        }
        if(GetPlayerSpecialAction(playerid) < 5)
        {
            continue;
        }
        if(GetPlayerSpecialAction(playerid) > 8)
        {
            continue;
        }
        count++;
    }
    if(count >= 5)
    {
	    AwardAchievement(playerid, ACH_FlashMob);
    }
    return 1;
}

//  CMD:giveachievement(playerid, params[])
//  {
//  	new targetid, name[32];
//  
//  	if(PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
//  	{
//  	    return SendClientErrorUnauthorizedCmd(playerid);
//  	}
//      if(sscanf(params, "us[32]", targetid, name))
//  	{
//  	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /giveachievement [playerid] [name]");
//  	}
//  	if(!IsPlayerConnected(targetid))
//  	{
//  	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
//  	}
//  	if(!PlayerData[targetid][pLogged])
//  	{
//  	    return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
//  	}
//  
//  	if(!AwardAchievement(targetid, name))
//  	{
//  	    SendClientMessage(playerid, COLOR_GREY, "Invalid achievement.");
//  	}
//  	else
//  	{
//  	    SendClientMessageEx(targetid, COLOR_AQUA, "%s has awarded you with the {FF6347}%s{33CCFF} achievement.", GetRPName(playerid), name);
//  	    SendClientMessageEx(playerid, COLOR_AQUA, "You have awarded %s with the {FF6347}%s{33CCFF} achievement.", GetRPName(targetid), name);
//  	}
//  
//  	return 1;
//  }