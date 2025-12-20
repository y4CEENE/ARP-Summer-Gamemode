#include <YSI\y_hooks>

#define REGISTRATION_VIRTUAL_WORLD 70707

static TutStep[MAX_PLAYERS];

enum ePlayerLoginState
{
    PLS_NewConnection,
    PLS_EnteringLoginPassword,
    PLS_RegisterPassword,
    PLS_RegisterGender,
    PLS_RegisterAge,
    PLS_RegisterAccent,
    PLS_RegisterTutorial,
    PLS_Logged
};

static ePlayerLoginState:PlayerLoginState[MAX_PLAYERS];

hook OnGameModeInit()
{
    InitLoginGUI();
    return 1;
}

hook OnPlayerConnect(playerid)
{
    PlayerLoginState[playerid] = PLS_NewConnection;
    PlayerData[playerid][pLogged] = 0;
    TutStep[playerid] = 0;
    new username[MAX_PLAYER_NAME];
    new changed = false;
    GetPlayerName(playerid, username, MAX_PLAYER_NAME);
    for (new i=0;username[i];i++)
    {
        if (username[i] == ' ')
        {
            username[i] = '_';
            changed = true;
        }
    }
    
    if (changed)
    {
        SetPlayerName(playerid, username);
    }

    if (!IsValidUsername(GetPlayerNameEx(playerid)))
    {
        KickPlayer(playerid, "Invalid role play name (i.e. John_Smith)", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
        return 1;
    }

    
    CallRemoteFunction("OnRemoveBuildings", "i", playerid);
    CallRemoteFunction("OnPlayerInit", "i", playerid);

	Streamer_ToggleIdleUpdate(playerid, true);
	GetPlayerName(playerid, PlayerData[playerid][pUsername], MAX_PLAYER_NAME);

    SetSpawnInfo(playerid, 0, 299,  1970.506103, -1201.447143, -25.074676, 1.0, -1, -1, -1, -1, -1, -1);
    SpawnPlayer(playerid); // The player doesn't actually spawn before logging in, this is just to get rid of the annoying "<<", ">>" and "Spawn" buttons.
    TogglePlayerControllable(playerid, 0);
    SetPlayerVirtualWorld(playerid, 482153 + playerid);
    //SetTimerEx("Login", 1000, 0, "d", playerid);
    
    return 1;
}

IsPlayerInTutorial(playerid)
{
    return TutStep[playerid] > 0;
}

ShowLoginDlg(playerid)
{
    new string[4096];
    format(string, sizeof(string), "{afafaf}Welcome back {00aa00}%s.\n\n{afafaf}Enter your account password below to login:",GetPlayerNameEx(playerid));
    Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FFFF00}Login Authentication", string, "Login", "");
    SendClientMessage(playerid, COLOR_OLDSCHOOL, "[SERVER]{ffffff} You have 60 seconds to login otherwise you will be kicked from the server.");
    PlayerData[playerid][pIntroKickTimer] = SetTimerEx("IntroKick", 60800, false, "i", playerid);
    return 1;
}


ShowAccountCreationDlg(playerid)
{
    new string[4096];
    new genderstring[12];
    switch(PlayerData[playerid][pGender])
    {
        case 1: genderstring = "Male";
        case 2: genderstring = "Female";
        default: genderstring = "Unspecified";
    }
    format(string, sizeof(string), "Name\t%s\n\
        Gender\t%s\n\
        Age\t%d\n\
        Accent\t%s\n\
        Complete",
        GetPlayerNameEx(playerid),
        genderstring,
        PlayerData[playerid][pAge],
        PlayerData[playerid][pAccent],
        PlayerData[playerid][pSkin]);
    Dialog_Show(playerid, ACCOUNT_CREATION, DIALOG_STYLE_TABLIST, "{00FF00}Account Registration", string, "Select", "");
    return 1;
}

ShowRegisterDlg(playerid)
{
    Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{00FF00}Account Registration", "Welcome to %s\n\nEnter your password of choice below to register:", "Register", "", GetServerName());
    return 1;
}

ShowRegisterGenderDlg(playerid)
{
    SetPlayerPos(playerid, 766.50, -1684.32, -6.86);
    SetPlayerCameraPos(playerid, 751.93, -1673.95, 16.01);
    SetPlayerCameraLookAt(playerid, 699.55, -1628.93, 5.88);
    Dialog_Show(playerid, DIALOG_GENDER, DIALOG_STYLE_MSGBOX, "{00FF00}Account Registration", "{FFFFFF}What do you want your character's gender to be?", "Male", "Female");
    SetPlayerVirtualWorld(playerid, REGISTRATION_VIRTUAL_WORLD);
    return 1;
}

ShowRegisterAgeDlg(playerid)
{
    Dialog_Show(playerid, DIALOG_AGE,DIALOG_STYLE_INPUT,"{00FF00}Account Registration", "Enter the age of your character [10-99]", "Okay", "Cancel");
    return 1;
}

ShowRegisterReferralDlg(playerid)
{
    Dialog_Show(playerid, DIALOG_REFERRAL, DIALOG_STYLE_INPUT, "Have you been referred here by anyone?", "Please enter the name of the player who referred you here:\n(You can click on 'Skip' if you haven't been referred by anyone.)", "Submit", "Skip");
    return 1;
}

ReferralCheck(playerid)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, ip FROM "#TABLE_USERS" WHERE uid = %i", PlayerData[playerid][pReferralUID]);
	mysql_tquery(connectionID, queryBuffer, "db_THREAD_REWARD_REFERRER", "i", playerid);
}

DB:THREAD_LOOKUP_BANS(playerid)
{
    new rows = cache_get_row_count(connectionID);

    if(rows)
    {
        new bannedby[24], date[24], end[24], reason[128];

        cache_get_field_content(0, "bannedby", bannedby);
        cache_get_field_content(0, "date", date);
        cache_get_field_content(0, "end", end);
        cache_get_field_content(0, "reason", reason);

        GameTextForPlayer(playerid, "~r~You are banned!", 999999, 3);
        TextDrawHideForPlayer(playerid, welcomenew);
        if(cache_get_field_content_int(0, "duration") == PERMANENT_BAN_DURATION)
            SendClientMessageEx(playerid, COLOR_YELLOW, "You are permanently banned from this server.");
        else
            SendClientMessageEx(playerid, COLOR_YELLOW, "You are banned from this server. You can appeal your ban at our discord.");

        SendClientMessageEx(playerid, COLOR_LIGHTRED, "Admin: %s", bannedby);
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "Date: %s", date);
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ends in: %s", end);
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "Reason: %s", reason);

        KickPlayer(playerid, reason, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
    }
    else
    {
        if(CheckIPBan(GetPlayerIP(playerid)) == 1)
        {
            new string[128];
            format(string, sizeof(string), "IP (%s) is banned", GetPlayerIP(playerid));
            KickPlayer(playerid, string, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
        }
        else
        {
            ShowMainMenuGUI(playerid);
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, login_nb_fails, TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) as login_diff_min FROM "#TABLE_USERS" WHERE username = '%s'", GetPlayerNameEx(playerid));
            mysql_tquery(connectionID, queryBuffer, "db_THREAD_LOOKUP_ACCOUNT", "i", playerid);
        }
    }
}
DB:THREAD_LOOKUP_ACCOUNT(playerid)
{
    new rows = cache_get_row_count(connectionID);

    if(rows)
    {
        if(cache_get_field_content_int(0, "login_nb_fails") >= 5 && 
           cache_get_field_content_int(0, "login_diff_min") < 5)
        {
            KickPlayer(playerid, "Fail to login. Your account is locked try to login after 5min.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
        }
        else
        {
            ShowLoginDlg(playerid);
        }
    }
    else
    {
        if(strfind(GetPlayerNameEx(playerid), "_") == -1)
        {
            Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "");
        }
        else
        {
            ShowRegisterDlg(playerid);
        }
    }
}
DB:THREAD_ACCOUNT_REGISTER(playerid)
{
    new id = cache_insert_id(connectionID);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM "#TABLE_USERS" WHERE uid = %i", id);
    mysql_tquery(connectionID, queryBuffer, "db_THREAD_PROCESS_LOGIN", "i", playerid);
}

hook OnLoadPlayer(playerid, row)
{
    if(PlayerData[playerid][pAdminDuty])
    {
        ResetPlayerWeaponsEx(playerid);
    }
    new date[64], string[128];
    cache_get_field_content(row, "login_date", date, connectionID, 32);
    cache_get_field_content(row, "regdate", PlayerData[playerid][pRegDate], connectionID, 32);
    cache_get_field_content(row, "accent", PlayerData[playerid][pAccent], connectionID, 16);
    cache_get_field_content(row, "adminname", PlayerData[playerid][pAdminName], connectionID, MAX_PLAYER_NAME);
    cache_get_field_content(row, "contractby", PlayerData[playerid][pContractBy], connectionID, MAX_PLAYER_NAME);
    cache_get_field_content(row, "prisonedby", PlayerData[playerid][pPrisonedBy], connectionID, MAX_PLAYER_NAME);
    cache_get_field_content(row, "prisonreason", PlayerData[playerid][pPrisonReason], connectionID, 128);
    cache_get_field_content(row, "passportname", PlayerData[playerid][pPassportName], connectionID, MAX_PLAYER_NAME);
    cache_get_field_content(row, "customtitle", PlayerData[playerid][pCustomTitle], connectionID, 64);
    PlayerData[playerid][pCustomTColor] = cache_get_field_content_int(row, "customcolor");
    PlayerData[playerid][pID] = cache_get_field_content_int(row, "uid");
    PlayerData[playerid][pSetup] = cache_get_field_content_int(row, "setup");
    PlayerData[playerid][pGender] = cache_get_field_content_int(row, "gender");
    PlayerData[playerid][pAge] = cache_get_field_content_int(row, "age");
    PlayerData[playerid][pSkin] = cache_get_field_content_int(row, "skin");
    PlayerData[playerid][pCameraX] = cache_get_field_content_float(row, "camera_x");
    PlayerData[playerid][pCameraY] = cache_get_field_content_float(row, "camera_y");
    PlayerData[playerid][pCameraZ] = cache_get_field_content_float(row, "camera_z");
    PlayerData[playerid][pPosX] = cache_get_field_content_float(row, "pos_x");
    PlayerData[playerid][pPosY] = cache_get_field_content_float(row, "pos_y");
    PlayerData[playerid][pPosZ] = cache_get_field_content_float(row, "pos_z");
    PlayerData[playerid][pPosA] = cache_get_field_content_float(row, "pos_a");
    PlayerData[playerid][pInterior] = cache_get_field_content_int(row, "interior");
    PlayerData[playerid][pWorld] = cache_get_field_content_int(row, "world");
    PlayerData[playerid][pCash] = cache_get_field_content_int(row, "cash");
    PlayerData[playerid][pBank] = cache_get_field_content_int(row, "bank");
    PlayerData[playerid][pPaycheck] = cache_get_field_content_int(row, "paycheck");
    PlayerData[playerid][pLevel] = cache_get_field_content_int(row, "level");
    PlayerData[playerid][pChatstyle] = cache_get_field_content_int(row, "chatstyle");
    PlayerData[playerid][pVehicleCMD] = cache_get_field_content_int(row, "vehiclecmd");//pVehicleCMD
    PlayerData[playerid][pCrowbar] = cache_get_field_content_int(row, "crowbar");
    PlayerData[playerid][pAdminStrike] = cache_get_field_content_int(row, "adminstrike");
    PlayerData[playerid][pDJ] = cache_get_field_content_int(row, "dj");
    PlayerData[playerid][pHouseAlarm] = cache_get_field_content_int(row, "housealarm");
    PlayerData[playerid][pvLock] = cache_get_field_content_int(row, "vehlock");
    PlayerData[playerid][pGraphic] = cache_get_field_content_int(row, "graphic");
    PlayerData[playerid][pGunLicense] = cache_get_field_content_int(row, "gunlicense");
    PlayerData[playerid][pEXP] = cache_get_field_content_int(row, "exp");
    PlayerData[playerid][pMinutes] = cache_get_field_content_int(row, "minutes");
    PlayerData[playerid][pHours] = cache_get_field_content_int(row, "hours");
    PlayerData[playerid][pHelmet] = cache_get_field_content_int(row, "helmet");
    PlayerData[playerid][pAdmin] = cache_get_field_content_int(row, "adminlevel");
    PlayerData[playerid][pHelper] = cache_get_field_content_int(row, "helperlevel");
    PlayerData[playerid][pHealth] = cache_get_field_content_float(row, "health");
    PlayerData[playerid][pArmor] = cache_get_field_content_float(row, "armor");
    PlayerData[playerid][pUpgradePoints] = cache_get_field_content_int(row, "upgradepoints");
    PlayerData[playerid][pWarnings] = cache_get_field_content_int(row, "warnings");
    PlayerData[playerid][pInjured] = cache_get_field_content_int(row, "injured");
    PlayerData[playerid][pHospital] = cache_get_field_content_int(row, "hospital");
    PlayerData[playerid][pSpawnHealth] = cache_get_field_content_float(row, "spawnhealth");
    PlayerData[playerid][pSpawnArmor] = cache_get_field_content_float(row, "spawnarmor");
    PlayerData[playerid][pJailType] = cache_get_field_content_int(row, "jailtype");
    PlayerData[playerid][pJailTime] = cache_get_field_content_int(row, "jailtime");
    PlayerData[playerid][pNewbieMuted] = cache_get_field_content_int(row, "newbiemuted");
    PlayerData[playerid][pHelpMuted] = cache_get_field_content_int(row, "helpmuted");
    PlayerData[playerid][pAdMuted] = cache_get_field_content_int(row, "admuted");
    PlayerData[playerid][pLiveMuted] = cache_get_field_content_int(row, "livemuted");
    PlayerData[playerid][pToggleVehCam] = cache_get_field_content_int(row, "togglevehicle");
    PlayerData[playerid][pGlobalMuted] = cache_get_field_content_int(row, "globalmuted");
    PlayerData[playerid][pReportMuted] = cache_get_field_content_int(row, "reportmuted");
    PlayerData[playerid][pReportWarns] = cache_get_field_content_int(row, "reportwarns");
    PlayerData[playerid][pFightStyle] = cache_get_field_content_int(row, "fightstyle");
    PlayerData[playerid][pPhone] = cache_get_field_content_int(row, "phone");
    PlayerData[playerid][pJob] = cache_get_field_content_int(row, "job");
    PlayerData[playerid][pSecondJob] = cache_get_field_content_int(row, "secondjob");
    PlayerData[playerid][pCrimes] = cache_get_field_content_int(row, "crimes");
    PlayerData[playerid][pArrested] = cache_get_field_content_int(row, "arrested");
    PlayerData[playerid][pWantedLevel] = cache_get_field_content_int(row, "wantedlevel");
    PlayerData[playerid][pNotoriety] = cache_get_field_content_int(row, "notoriety");		
    PlayerData[playerid][pMaterials] = cache_get_field_content_int(row, "materials");
    PlayerData[playerid][pWeed] = cache_get_field_content_int(row, "weed");
    PlayerData[playerid][pCocaine] = cache_get_field_content_int(row, "cocaine");
    PlayerData[playerid][pHeroin] = cache_get_field_content_int(row, "heroin");
    PlayerData[playerid][pPainkillers] = cache_get_field_content_int(row, "painkillers");
    PlayerData[playerid][pSeeds] = cache_get_field_content_int(row, "seeds");
    PlayerData[playerid][pEphedrine] = cache_get_field_content_int(row, "ephedrine");
    PlayerData[playerid][pMuriaticAcid] = cache_get_field_content_int(row, "muriaticacid");
    PlayerData[playerid][pBakingSoda] = cache_get_field_content_int(row, "bakingsoda");
    PlayerData[playerid][pCigars] = cache_get_field_content_int(row, "cigars");
    PlayerData[playerid][pPrivateRadio] = cache_get_field_content_int(row, "walkietalkie");
    PlayerData[playerid][pChannel] = cache_get_field_content_int(row, "channel");
    PlayerData[playerid][pRentingHouse] = cache_get_field_content_int(row, "rentinghouse");
    PlayerData[playerid][pSpraycans] = cache_get_field_content_int(row, "spraycans");
    PlayerData[playerid][pBoombox] = cache_get_field_content_int(row, "boombox");
    PlayerData[playerid][pMP3Player] = cache_get_field_content_int(row, "mp3player");
    PlayerData[playerid][pPhonebook] = cache_get_field_content_int(row, "phonebook");
    PlayerData[playerid][pFishingRod] = cache_get_field_content_int(row, "fishingrod");
    PlayerData[playerid][pFishingBait] = cache_get_field_content_int(row, "fishingbait");
    PlayerData[playerid][pFishWeight] = cache_get_field_content_int(row, "fishweight");
    PlayerData[playerid][pComponents] = cache_get_field_content_int(row, "components");
    PlayerData[playerid][pSweep] = cache_get_field_content_int(row, "sweep");
    PlayerData[playerid][pSweepLeft] = cache_get_field_content_int(row, "sweepleft");
    PlayerData[playerid][pRccam] = cache_get_field_content_int(row, "rccam");
    PlayerData[playerid][pCondom] = cache_get_field_content_int(row, "condom");
    
    PlayerData[playerid][pMechanicSkill] = cache_get_field_content_int(row, "mechanicskill");
    PlayerData[playerid][pSmugglerSkill] = cache_get_field_content_int(row, "smugglerskill");
    PlayerData[playerid][pWeaponSkill] = cache_get_field_content_int(row, "weaponskill");
    PlayerData[playerid][pDrugDealerSkill] = cache_get_field_content_int(row, "drugdealerskill");
    PlayerData[playerid][pFarmerSkill] = cache_get_field_content_int(row, "farmerskill");
    PlayerData[playerid][pDetectiveSkill] = cache_get_field_content_int(row, "detectiveskill");
    PlayerData[playerid][pLawyerSkill] = cache_get_field_content_int(row, "lawyerskill");
    PlayerData[playerid][pForkliftSkill] = cache_get_field_content_int(row, "forkliftskill");
    PlayerData[playerid][pCarJackerSkill] = cache_get_field_content_int(row, "carjackerskill");
    PlayerData[playerid][pCraftSkill] = cache_get_field_content_int(row, "craftskill");
    PlayerData[playerid][pPizzaSkill] = cache_get_field_content_int(row, "pizzaskill");
    PlayerData[playerid][pTruckerSkill] = cache_get_field_content_int(row, "truckerskill");
    PlayerData[playerid][pHookerSkill] = cache_get_field_content_int(row, "hookerskill");
    PlayerData[playerid][pRobberySkill] = cache_get_field_content_int(row, "robberyskill");
    PlayerData[playerid][pFishingSkill] = cache_get_field_content_int(row, "fishingskill");
    
    PlayerData[playerid][pToggleTextdraws] = cache_get_field_content_int(row, "toggletextdraws");
    PlayerData[playerid][pToggleOOC] = cache_get_field_content_int(row, "toggleooc");
    PlayerData[playerid][pTogglePhone] = cache_get_field_content_int(row, "togglephone");
    PlayerData[playerid][pToggleAdmin] = cache_get_field_content_int(row, "toggleadmin");
    PlayerData[playerid][pToggleHelper] = cache_get_field_content_int(row, "togglehelper");
    PlayerData[playerid][pTogglePoints] = cache_get_field_content_int(row, "togglepoints");
    PlayerData[playerid][pToggleTurfs] = cache_get_field_content_int(row, "toggleturfs");
    PlayerData[playerid][pToggleNewbie] = cache_get_field_content_int(row, "togglenewbie");
    PlayerData[playerid][pTogglePR] = cache_get_field_content_int(row, "togglewt");
    PlayerData[playerid][pToggleRadio] = cache_get_field_content_int(row, "toggleradio");
    PlayerData[playerid][pToggleVIP] = cache_get_field_content_int(row, "togglevip");
    PlayerData[playerid][pToggleMusic] = cache_get_field_content_int(row, "togglemusic");
    PlayerData[playerid][pToggleFaction] = cache_get_field_content_int(row, "togglefaction");
    PlayerData[playerid][pToggleNews] = cache_get_field_content_int(row, "togglenews");
    PlayerData[playerid][pToggleGlobal] = cache_get_field_content_int(row, "toggleglobal");
    PlayerData[playerid][pToggleCam] = cache_get_field_content_int(row, "togglecam");
    PlayerData[playerid][pToggleHUD] = cache_get_field_content_int(row, "togglehud");
    PlayerData[playerid][pToggleReports] = cache_get_field_content_int(row, "togglereports");
    PlayerData[playerid][pToggleWhisper] = cache_get_field_content_int(row, "togglewhisper");
    PlayerData[playerid][pToggleBug] = cache_get_field_content_int(row, "togglebug");
    PlayerData[playerid][pCarLicense] = cache_get_field_content_int(row, "carlicense");
    PlayerData[playerid][pDonator] = cache_get_field_content_int(row, "vippackage");
    PlayerData[playerid][pVIPTime] = cache_get_field_content_int(row, "viptime");
    PlayerData[playerid][pVIPCooldown] = cache_get_field_content_int(row, "vipcooldown");
    PlayerData[playerid][pSpawnSelect] = cache_get_field_content_int(row, "spawntype");
    PlayerData[playerid][pSpawnHouse] = cache_get_field_content_int(row, "spawnhouse");
    PlayerData[playerid][pAdminDutyTime] = cache_get_field_content_int(row, "admin_duty_time");


    for(new i, wepid[64]; i < 13; i++)
    {
        format(wepid, sizeof(wepid), "weapon_%d", i);
        PlayerData[playerid][pWeapons][i] = cache_get_field_content_int(row, wepid);
    }
    for(new i, ammoid[64]; i < 13; i++)
    {
        format(ammoid, sizeof(ammoid), "ammo_%d", i);
        PlayerData[playerid][pAmmo][i] = cache_get_field_content_int(row, ammoid);
    }


    PlayerData[playerid][pFaction] = cache_get_field_content_int(row, "faction");
    PlayerData[playerid][pFactionRank] = cache_get_field_content_int(row, "factionrank");
    PlayerData[playerid][pFactionLeader] = cache_get_field_content_int(row, "factionleader");
    PlayerData[playerid][pGang] = cache_get_field_content_int(row, "gang");
    PlayerData[playerid][pGangRank] = cache_get_field_content_int(row, "gangrank");
    PlayerData[playerid][pDivision] = cache_get_field_content_int(row, "division");
    PlayerData[playerid][pCrew] = cache_get_field_content_int(row, "crew");
    PlayerData[playerid][pContracted] = cache_get_field_content_int(row, "contracted");
    PlayerData[playerid][pBombs] = cache_get_field_content_int(row, "bombs");
    PlayerData[playerid][pCompletedHits] = cache_get_field_content_int(row, "completedhits");
    PlayerData[playerid][pFailedHits] = cache_get_field_content_int(row, "failedhits");
    PlayerData[playerid][pReports] = cache_get_field_content_int(row, "reports");
    PlayerData[playerid][pNewbies] = cache_get_field_content_int(row, "newbies");
    PlayerData[playerid][pHelpRequests] = cache_get_field_content_int(row, "helprequests");
    PlayerData[playerid][pSpeedometer] = cache_get_field_content_int(row, "speedometer");
    PlayerData[playerid][pWebDev] = cache_get_field_content_int(row, "webdev");
    PlayerData[playerid][pFactionMod] = cache_get_field_content_int(row, "factionmod");
    PlayerData[playerid][pGangMod] = cache_get_field_content_int(row, "gangmod");
    PlayerData[playerid][pBanAppealer] = cache_get_field_content_int(row, "banappealer");
    PlayerData[playerid][pFormerAdmin] = cache_get_field_content_int(row, "FormerAdmin");
    PlayerData[playerid][pDeveloper] = cache_get_field_content_int(row, "scripter");
    PlayerData[playerid][pHelperManager] = cache_get_field_content_int(row, "helpermanager");
    PlayerData[playerid][pDynamicAdmin] = cache_get_field_content_int(row, "dynamicadmin");
    PlayerData[playerid][pAdminPersonnel] = cache_get_field_content_int(row, "adminpersonnel");
    PlayerData[playerid][pHumanResources] = cache_get_field_content_int(row, "humanresources");
    PlayerData[playerid][pComplaintMod] = cache_get_field_content_int(row, "complaintmod");
    PlayerData[playerid][pWeedPlanted] = cache_get_field_content_int(row, "weedplanted");
    PlayerData[playerid][pWeedTime] = cache_get_field_content_int(row, "weedtime");
    PlayerData[playerid][pWeedGrams] = cache_get_field_content_int(row, "weedgrams");
    PlayerData[playerid][pWeedX] = cache_get_field_content_float(row, "weed_x");
    PlayerData[playerid][pWeedY] = cache_get_field_content_float(row, "weed_y");
    PlayerData[playerid][pWeedZ] = cache_get_field_content_float(row, "weed_z");
    PlayerData[playerid][pWeedA] = cache_get_field_content_float(row, "weed_a");
    PlayerData[playerid][pInventoryUpgrade] = cache_get_field_content_int(row, "inventoryupgrade");
    PlayerData[playerid][pAddictUpgrade] = cache_get_field_content_int(row, "addictupgrade");
    PlayerData[playerid][pTraderUpgrade] = cache_get_field_content_int(row, "traderupgrade");
    PlayerData[playerid][pAssetUpgrade] = cache_get_field_content_int(row, "assetupgrade");
    PlayerData[playerid][pLaborUpgrade] = cache_get_field_content_int(row, "laborupgrade");
    PlayerData[playerid][pDMWarnings] = cache_get_field_content_int(row, "dmwarnings");
    PlayerData[playerid][pWeaponRestricted] = cache_get_field_content_int(row, "weaponrestricted");
    PlayerData[playerid][pReferralUID] = cache_get_field_content_int(row, "referral_uid");
    PlayerData[playerid][pWatch] = cache_get_field_content_int(row, "watch");
    PlayerData[playerid][pGPS] = cache_get_field_content_int(row, "gps");
    PlayerData[playerid][pClothes] = cache_get_field_content_int(row, "clothes");
    PlayerData[playerid][pShowLands] = cache_get_field_content_int(row, "showlands");
    PlayerData[playerid][pShowTurfs] = cache_get_field_content_int(row, "showturfs");
    PlayerData[playerid][pWatchOn] = cache_get_field_content_int(row, "watchon");
    PlayerData[playerid][pGPSOn] = cache_get_field_content_int(row, "gpson");
    PlayerData[playerid][pDoubleXP] = cache_get_field_content_int(row, "doublexp");
    PlayerData[playerid][pDetectiveCooldown] = cache_get_field_content_int(row, "detectivecooldown");
    PlayerData[playerid][pThiefCooldown] = cache_get_field_content_int(row, "thiefcooldown");
    PlayerData[playerid][pCocaineCooldown] = cache_get_field_content_int(row, "crackcooldown");
    PlayerData[playerid][pGasCan] = cache_get_field_content_int(row, "gascan");
    PlayerData[playerid][pDuty] = cache_get_field_content_int(row, "duty");
    PlayerData[playerid][pBandana] = 0; //cache_get_field_content_int(row, "bandana");
    PlayerData[playerid][pPassport] = cache_get_field_content_int(row, "passport");
    PlayerData[playerid][pPassportLevel] = cache_get_field_content_int(row, "passportlevel");
    PlayerData[playerid][pPassportSkin] = cache_get_field_content_int(row, "passportskin");
    PlayerData[playerid][pPassportPhone] = cache_get_field_content_int(row, "passportphone");
    PlayerData[playerid][pNewbieMuteTime] = cache_get_field_content_int(row, "newbiemutetime");
    PlayerData[playerid][pReportMuteTime] = cache_get_field_content_int(row, "reportmutetime");
    PlayerData[playerid][pGlobalMuteTime] = cache_get_field_content_int(row, "globalmutetime");
    PlayerData[playerid][pAdminHide] = cache_get_field_content_int(row, "adminhide");
    PlayerData[playerid][pInsurance] = cache_get_field_content_int(row, "insurance");
    PlayerData[playerid][pRope] = cache_get_field_content_int(row, "rope");
    PlayerData[playerid][pTotalPatients] = cache_get_field_content_int(row, "totalpatients");
    PlayerData[playerid][pTotalFires] = cache_get_field_content_int(row, "totalfires");
    PlayerData[playerid][pPasswordChanged] = cache_get_field_content_int(row, "passwordchanged");
    PlayerData[playerid][pFirstAid] = cache_get_field_content_int(row, "firstaid");
    PlayerData[playerid][pPoliceScanner] = cache_get_field_content_int(row, "policescanner");
    PlayerData[playerid][pBodykits] = cache_get_field_content_int(row, "bodykits");
    PlayerData[playerid][pRimkits] = cache_get_field_content_int(row, "rimkits");
    PlayerData[playerid][pScannerOn] = cache_get_field_content_int(row, "scanneron");
    PlayerData[playerid][pBlindfold] = cache_get_field_content_int(row, "blindfold");

    new tempkey = cache_get_field_content_int(row, "landkeys");

    if(tempkey > 0)
    {
        new landArrayIndex = tempkey - 1;

        if(landArrayIndex >= 0 && landArrayIndex < MAX_LANDS && LandInfo[landArrayIndex][lExists])
        {
            PlayerData[playerid][pLandPerms] = landArrayIndex;
            printf("[DEBUG] Player %s loaded land permissions for array index %d", GetPlayerNameEx(playerid), landArrayIndex);
        }
        else
        {
            PlayerData[playerid][pLandPerms] = -1;
            printf("[DEBUG] Player %s had invalid land permission index %d", GetPlayerNameEx(playerid), landArrayIndex);
        }
    }
    else
    {
        PlayerData[playerid][pLandPerms] = -1;
    }
    PlayerData[playerid][pBugged] = cache_get_field_content_int(row, "bugged");
    cache_get_field_content(row, "buggedby", PlayerData[playerid][pBuggedBy], connectionID, MAX_PLAYER_NAME);
    PlayerData[playerid][pRareTime] = cache_get_field_content_int(row, "rarecooldown");
    PlayerData[playerid][pDiamonds] = cache_get_field_content_int(row, "diamonds");
    PlayerData[playerid][pSkates] = cache_get_field_content_int(row, "rollerskates");
    PlayerData[playerid][pMarriedTo] = cache_get_field_content_int(row, "marriedto");

    if(PlayerData[playerid][pMarriedTo] != -1)
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username FROM "#TABLE_USERS" WHERE uid = %i", PlayerData[playerid][pMarriedTo]);
        mysql_tquery(connectionID, queryBuffer, "OnUpdatePartner", "i", playerid);
    }
    else
    {
        strcpy(PlayerData[playerid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
    }
    PlayerData[playerid][pLogged] = 1;
    PlayerData[playerid][pACTime] = gettime() + 5;

    if(IsPlayerConnected(playerid))
    {
        CallLocalFunction("OnLoadUser", "ii", playerid, 0); // row=0
    }

    if(!PlayerData[playerid][pAdminDuty])
    {
        ClearChat(playerid);
    }
    if(!PlayerData[playerid][pToggleTextdraws])
    {
        RefreshPlayerTextdraws(playerid);
    }

    if(cache_get_field_content_int(0, "refercount") > 0)
    {
        new
            count = cache_get_field_content_int(0, "refercount");

        SendClientMessageEx(playerid, COLOR_GREEN, "%i players who you've referred reached level 3. Therefore you received %i cookies!", count, count * 10);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET refercount = 0 WHERE uid = %i", PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
    }

    if(!PlayerData[playerid][pSetup])
    {
        if(!PlayerData[playerid][pAdminDuty] && !PlayerData[playerid][pToggleCam])
        {
            PlayerData[playerid][pLoginCamera] = 1;
        }
        else
        {
            PlayerData[playerid][pLoginCamera] = 0;
        }

        if(PlayerData[playerid][pWeedPlanted] && PlayerData[playerid][pWeedObject] == INVALID_OBJECT_ID)
        {
            PlayerData[playerid][pWeedObject] = CreateDynamicObject(3409, PlayerData[playerid][pWeedX], PlayerData[playerid][pWeedY], PlayerData[playerid][pWeedZ] - 1.8, 0.0, 0.0, PlayerData[playerid][pWeedA]);
        }
        if(PlayerData[playerid][pShowTurfs])
        {
            ShowTurfsOnMap(playerid, true);
        }
        if(PlayerData[playerid][pShowLands])
        {
            ShowLandsOnMap(playerid, true);
        }

        if(!PlayerData[playerid][pAdminDuty])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET lastlogin = NOW(), ip = '%s' WHERE uid = %i", GetPlayerIP(playerid), PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id FROM flags WHERE uid = %i", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_FLAGS, playerid);

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM clothing WHERE uid = %i", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_CLOTHING, playerid);

            if(!PlayerData[playerid][pTogglePhone])
            {
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM texts WHERE recipient_number = %i", PlayerData[playerid][pPhone]);
                mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_TEXTS, playerid);
            }
        }

        foreach(new i: Vehicle)
        {
            if(IsVehicleOwner(playerid, i) && VehicleInfo[i][vTimer] >= 0)
            {
                KillTimer(VehicleInfo[i][vTimer]);
                VehicleInfo[i][vTimer] = -1;
            }
        }


        if(PlayerData[playerid][pAdminDuty])
        {
            PlayerData[playerid][pAdminDuty] = 0;
            SetPlayerName(playerid, PlayerData[playerid][pUsername]);
            SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s is no longer on admin duty.", GetAdmCmdRank(playerid),GetRPName(playerid));
            SendClientMessage(playerid, COLOR_WHITE, "You are no longer on admin duty. Your account's statistics have been preserved.");
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "SERVER: Welcome %s", GetPlayerNameEx(playerid));
            new motd[128];
            if(PlayerData[playerid][pAdmin] > 0)
            {
                motd=GetAdminMOTD();
                if(!isnull(motd))
                {
                    SendClientMessageEx(playerid, 0xE65A5AAA, "Admin Motd: %s", motd);
                }
            }

            if(PlayerData[playerid][pHelper] > 0)
            {
                motd=GetHelperMOTD();
                if(!isnull(motd))
                {
                    SendClientMessageEx(playerid, COLOR_AQUA, "Helper Motd: %s", motd);
                }
            }

            if(PlayerData[playerid][pFaction] >= 0 && strcmp(FactionInfo[PlayerData[playerid][pFaction]][fMOTD], "None", true) != 0)
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "Faction Motd: %s", FactionInfo[PlayerData[playerid][pFaction]][fMOTD]);
            }

            if(PlayerData[playerid][pGang] >= 0 && strcmp(GangInfo[PlayerData[playerid][pGang]][gMOTD], "None", true) != 0)
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "Gang MOTD: %s", GangInfo[PlayerData[playerid][pGang]][gMOTD]);
            }

            motd=GetServerMOTD();
            if(!isnull(motd))
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "Global Motd: %s", motd);
            }

            format(string, sizeof(string), "~w~Welcome ~n~~y~   %s", GetPlayerNameEx(playerid));
            GameTextForPlayer(playerid, string, 5000, 1);

            /*if(PlayerData[playerid][pAdmin] && !PlayerData[playerid][pAdminHide])
            {
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has logged in.", GetAdmCmdRank(playerid), GetRPName(playerid));
            }
            if(PlayerData[playerid][pGang] >= 0)
            {
                SendGangMessage(PlayerData[playerid][pGang], COLOR_AQUA, "(( %s %s has logged in. ))", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid));
            }
            if(PlayerData[playerid][pFaction] >= 0)
            {
                SendFactionMessage(PlayerData[playerid][pFaction], COLOR_FACTIONCHAT, "(( %s %s has logged in. ))", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
            }

            if(PlayerData[playerid][pAdmin] > 0) {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {FF6347}level %i %s{FFFFFF}.", GetServerName(), PlayerData[playerid][pAdmin], GetAdminRank(playerid));
            } else if(PlayerData[playerid][pHelper] > 0) {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {33CCFF}%s{FFFFFF}.", GetServerName(), GetHelperRank(playerid));
            } else if(PlayerData[playerid][pDonator] > 0) {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {D909D9}%s VIP{FFFFFF}.", GetServerName(), GetVIPRank(PlayerData[playerid][pDonator]));
            } else if(PlayerData[playerid][pLevel] >= 2) {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {AFAFAF}level %i player{FFFFFF}.", GetServerName(), PlayerData[playerid][pLevel]);
            } else {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {AFAFAF}level 1 newbie{FFFFFF}.", GetServerName());
            }

            SendClientMessageEx(playerid, COLOR_NAVYBLUE, "Your last login was on the %s (server time).", GetDateTime());
            */

            StopAudioStreamForPlayer(playerid);
        }

        if(PlayerData[playerid][pFaction] >= 0 && FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_NONE)
        {
            SetPlayerFaction(playerid, -1);
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "You were either kicked from the faction while offline or it was deleted.");
        }
        if(PlayerData[playerid][pGang] >= 0 && !GangInfo[PlayerData[playerid][pGang]][gSetup])
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "You have either been kicked from the gang while offline or it was deleted.");
            PlayerData[playerid][pGang] = -1;
            PlayerData[playerid][pGangRank] = 0;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
        }
        if(PlayerData[playerid][pPasswordChanged] == 0)
        {
            Dialog_Show(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "{00aa00}%s{FFFFFF} | Change password", "Please change your password for security purposes\nEnter your new password below:", "Submit", "Cancel", GetServerName());
        }

    }
    //SetPlayerToSpawn(playerid);
    DisplayDashboard(playerid);
    return 1;
}

DB:THREAD_PROCESS_LOGIN(playerid)
{    
    new rows = cache_get_row_count(connectionID);
    
    if(!rows)
    {
        PlayerData[playerid][pLoginTries]++;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET login_nb_fails = login_nb_fails + 1, login_last_fail = NOW() WHERE username = '%s'", GetPlayerNameEx(playerid));
        mysql_tquery(connectionID, queryBuffer, "db_OnLoginFailUpdated", "i", playerid);
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET login_nb_fails = 0 WHERE username = '%s'", GetPlayerNameEx(playerid));
        mysql_tquery(connectionID, queryBuffer);
        
        if(cache_get_field_content_int(0, "locked"))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* This account is currently locked. Post an administrative request to have it lifted.");
            new string[128];
            format(string, sizeof(string), "%s tried to login with a locked account.", GetPlayerNameEx(playerid));
            KickPlayer(playerid, string);
        }
        else
        {
            KillTimer(PlayerData[playerid][pIntroKickTimer]);
            HideMainMenuGUI(playerid);
            
            CallRemoteFunction("OnLoadPlayer", "ii", playerid, 0);
            CallRemoteFunction("OnPlayerLoaded", "i", playerid);        
        }
    }
}

DB:THREAD_CHECK_REFERRAL(playerid)
{
    new rows = cache_get_row_count(connectionID);

    if(!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
        ShowRegisterReferralDlg(playerid);
    }
    else
    {
        new username[MAX_PLAYER_NAME], ip[16];

        cache_get_field_content(0, "username", username);
        cache_get_field_content(0, "ip", ip);

        if(!strcmp(GetPlayerIP(playerid), ip))
        {
            SendClientMessage(playerid, COLOR_GREY, "This account is listed under your own IP address. You can't refer yourself.");
            ShowRegisterReferralDlg(playerid);
        }
        else
        {

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET referral_uid = %i WHERE uid = %i", cache_get_field_content_int(0, "uid"), PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);

            PlayerData[playerid][pSetup] = 0;

            SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);

            SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
            SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);
            SetPlayerVirtualWorld(playerid, 0);
            SetCameraBehindPlayer(playerid);
            StopAudioStreamForPlayer(playerid);
            TogglePlayerControllableEx(playerid, 1);

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i", PlayerData[playerid][pGender], PlayerData[playerid][pAge], PlayerData[playerid][pSkin], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);

            PlayerData[playerid][pReferralUID] = cache_get_field_content_int(0, "uid");
            SendClientMessageEx(playerid, COLOR_YELLOW, "You have chosen %s as your referral. This player will be rewarded once you reach level 3.", username);
            //SendClientMessage(playerid, COLOR_YELLOW, "That's all the information we need right now. The tutorial will start in just a moment.");
            
            CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
        }
    }

}

hook OnPlayerFirstTimeSpawn(playerid)
{
    StopAudioStreamForPlayer(playerid);
    
    PlayerData[playerid][pInjured] = 0;
	SetPlayerHealth(playerid, 100.0);

    SendStaffMessage(COLOR_YELLOW, "OnPlayerSpawn: %s[%d] has just spawned on %s for the first time!", GetRPName(playerid), playerid, GetServerName());
    
    DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
    fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
    
    SendClientMessageEx(playerid, COLOR_WHITE, "Welcome to {00aa00}%s{FFFFFF}. Make sure to visit our %s for news and updates.", GetServerWebsite());
    SendClientMessage(playerid, COLOR_WHITE, "Use the {FFFF90}/locate{FFFFFF} command to point to locations of jobs, businesses, and common places.");
    
    SendClientMessage(playerid, COLOR_AQUA, "You need a driver's license, the DMV has been marked on your map. Navigate to the marker to begin your drivers test.");
    PlayerData[playerid][pCP] = CHECKPOINT_MISC;
    SetPlayerCheckpoint(playerid, 1219.2590, -1812.1093, 16.5938, 3.0);

    AwardAchievement(playerid, ACH_AtTheEnd);
    Dialog_Show(playerid, OnSpawnRequestHelper, DIALOG_STYLE_MSGBOX, "Helper request", "Did you need a helper?\n He can explain the rules, show you the city\n and help you to find your first job!", "Yes", "No");
    return 1;
}

Dialog:OnSpawnRequestHelper(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        return callcmd::helpme(playerid, "Player has just spawned and need help");
    }
    return 1;
}

DB:THREAD_REWARD_REFERRER(playerid)
{
    new rows = cache_get_row_count(connectionID);

    if(rows)
    {
        new username[MAX_PLAYER_NAME], ip[16], referralid = INVALID_PLAYER_ID;

        cache_get_field_content(0, "username", username);
        cache_get_field_content(0, "ip", ip);

        // Add a log entry for this referral.
        Log_Write("log_referrals", "%s (uid: %i) (IP: %s) has received 10 cookies for referring %s (uid: %i) (IP: %s).", username, PlayerData[playerid][pReferralUID], ip, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

        // Check to see if any of the players online match the player's referral UID.
        foreach(new i : Player)
        {
            if(i != playerid && PlayerData[i][pLogged] && PlayerData[i][pID] == PlayerData[playerid][pReferralUID])
            {
                referralid = i;
                break;
            }
        }

        // Referrer is online.
        if(referralid != INVALID_PLAYER_ID && strcmp(GetPlayerIP(referralid), GetPlayerIP(playerid)) != 0)
        {
            GivePlayerCookies(referralid, 10);

            SendClientMessage(referralid, COLOR_GREEN, "A player who you've referred reached level 3. Therefore you received 10 cookies!");
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) earned 10 cookies for referring %s (IP: %s).", GetRPName(referralid), GetPlayerIP(referralid), GetRPName(playerid), GetPlayerIP(playerid));
        }
        else
        {
            // Referrer is offline. Let's give them their cookies and increment refercount which sends them an alert on login!
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cookies = cookies + 10, refercount = refercount + 1 WHERE uid = %i AND ip != '%s'", PlayerData[playerid][pReferralUID], GetPlayerIP(playerid));
            mysql_tquery(connectionID, queryBuffer);
        }

        // Finally, remove the player's link to the referrer as the prize has been given.
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET referral_uid = 0 WHERE uid = %i", PlayerData[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);
    }
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(isnull(inputtext))
        {
            ShowRegisterDlg(playerid);
            return 1;
		}
        if(strlen(inputtext) < 4)
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* Please choose a password containing at least 4 characters.");
            ShowRegisterDlg(playerid);
            return 1;
        }

        WP_Hash(PlayerData[playerid][pPassword], 129, inputtext);
        new str[128];
        format(str, sizeof(str), "%s - Confirm Pass", GetServerName());
        Dialog_Show(playerid, DIALOG_CONFIRMPASS, DIALOG_STYLE_PASSWORD, str, "Please repeat your account password for verification:", "Submit", "Back");
	}
	else
	{
	    KickPlayer(playerid, "Failed to register", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
	}
	return 1;
}

AddPlayerToDatabase(playerid)
{
    IncreaseTotalRegistered();

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO "#TABLE_USERS" (username, password, regdate, lastlogin, ip, passwordchanged, gender, age) VALUES('%s', '%s', NOW(), NOW(), '%s', 1, %d, %d)", GetPlayerNameEx(playerid), PlayerData[playerid][pPassword], GetPlayerIP(playerid), PlayerData[playerid][pGender], PlayerData[playerid][pAge]);
    mysql_tquery(connectionID, queryBuffer, "db_THREAD_ACCOUNT_REGISTER", "i", playerid);
}

Dialog:DIALOG_CONFIRMPASS(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new
			password[129];

        if(isnull(inputtext))
        {
            new str[128];
            format(str, sizeof(str), "%s - Confirm Pass", GetServerName());
            return Dialog_Show(playerid, DIALOG_CONFIRMPASS, DIALOG_STYLE_PASSWORD, str, "Please repeat your account password for verification:", "Submit", "Back", GetServerName());
		}

		WP_Hash(password, sizeof(password), inputtext);

		if(!strcmp(PlayerData[playerid][pPassword], password))
		{
		    ShowRegisterGenderDlg(playerid);
		}
		else
		{
            ShowRegisterDlg(playerid);
		    SendClientMessage(playerid, COLOR_LIGHTRED, "* Your repeated password does not match your chosen password. Please try again.");
		}
    }
    else
    {
        ShowRegisterDlg(playerid);
    }
    return 1;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
	    ShowLoginDlg(playerid);
	}
    if(response)
    {
        new
            specifiers[] = "%D of %M, %Y @ %k:%i",
            password[129];

		if(isnull(inputtext))
		{
		    ShowLoginDlg(playerid);
		    return 1;
		}

		WP_Hash(password, sizeof(password), inputtext);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT *, DATE_FORMAT(lastlogin, '%s') AS login_date FROM "#TABLE_USERS" WHERE username = '%s' AND password = '%s' and (login_nb_fails < 5  or TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) > 5)", specifiers, GetPlayerNameEx(playerid), password);
    	mysql_tquery(connectionID, queryBuffer, "db_THREAD_PROCESS_LOGIN", "i", playerid);
    }
    else
    {
		KickPlayer(playerid, "Failed to login", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
	}
	return 1;
}
DB:OnLoginFailUpdated(playerid)
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, login_nb_fails, TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) as login_diff_min FROM "#TABLE_USERS" WHERE username = '%s'", GetPlayerNameEx(playerid));
    mysql_tquery(connectionID, queryBuffer, "db_CheckLoginSpam", "i", playerid);
    return 1;
}
DB:CheckLoginSpam(playerid)
{
    
    if(cache_get_field_content_int(0, "login_nb_fails") >= 5 && 
        cache_get_field_content_int(0, "login_diff_min") < 5)
    {
        KickPlayer(playerid, "Fail to login. Your account is locked try to login after 5min.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
    }
    else if(PlayerData[playerid][pLoginTries] < 3)
    {
        ShowLoginDlg(playerid);
        SendClientMessageEx(playerid, COLOR_ORANGE, "[WARNING]{ffffff} Submited password is incorrect, you have %i attempts left.", 3 - PlayerData[playerid][pLoginTries]);
    }
    else
    {
        KickPlayer(playerid, "Unable to Login", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
    }
    return 1;
}
Dialog:DIALOG_GENDER(playerid, response, listitem, inputtext[])
{

    if(response)
    {
        PlayerData[playerid][pGender] = 1;
        PlayerData[playerid][pSkin] = 299;
        SendClientMessage(playerid, COLOR_YELLOW, "Your character is a Male. Now you need to choose the age of your character.");
    }
    else
    {
        PlayerData[playerid][pGender] = 2;
        PlayerData[playerid][pSkin] = 69;
        SendClientMessage(playerid, COLOR_YELLOW, "Your character is a Female. Now you need to choose the age of your character.");
    }
    
    ShowRegisterAgeDlg(playerid);

	return 1;
}

Dialog:DIALOG_AGE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new age = strval(inputtext);

		if(!(10 <= age <= 99))
		{
		    ShowRegisterAgeDlg(playerid);
		    SendClientMessage(playerid, COLOR_GREY, "You may only enter a number from 10 to 99. Please try again.");
		    return 1;
        }

        PlayerData[playerid][pAge] = age;
        PlayerData[playerid][pReferralUID] = 0;
        
        AddPlayerToDatabase(playerid);        
    }
    else
    {
        ShowRegisterAgeDlg(playerid);
	}
	return 1;
}

Dialog:DIALOG_REFERRAL(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(isnull(inputtext) || strlen(inputtext) > 24)
        {
            return ShowRegisterReferralDlg(playerid);
		}
		if(!strcmp(inputtext, GetPlayerNameEx(playerid)))
		{
		    SendClientMessage(playerid, COLOR_GREY, "You can't put down your own name as a referral.");
		    return ShowRegisterReferralDlg(playerid);
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, ip, uid FROM "#TABLE_USERS" WHERE username = '%e'", inputtext);
		mysql_tquery(connectionID, queryBuffer, "db_THREAD_CHECK_REFERRAL", "i", playerid);
    }
	return 1;
}

Dialog:ACCOUNT_CREATION(playerid, response, listitem, inputtext[])
{
	if(!response) return ShowAccountCreationDlg(playerid);
	switch(listitem)
	{
		case 0: return ShowAccountCreationDlg(playerid);
		case 1: return ShowRegisterGenderDlg(playerid);
		case 2: return ShowRegisterAgeDlg(playerid);
		case 3:
		{
			szMiscArray[0] = 0;
			strcat(szMiscArray,
			"None\n" \
			"English\n" \
			"American\n" \
			"British\n" \
			"Chinese\n" \
			"Korean\n" \
			"Japanese\n" \
			"Asian\n" \
			"Canadian\n" \
			"Australian\n" \
			"Southern\n" \
			"Russian\n" \
			"Ukrainian\n" \
			"German\n" \
			"French\n" \
			"Portuguese\n" \
			"Polish\n");
			
			strcat(szMiscArray,
			"Estonian\n" \
			"Latvian\n" \
			"Dutch\n" \
			"Jamaican\n" \
			"Turkish\n" \
			"Mexican\n" \
			"Spanish\n" \
			"Arabic\n" \
			"Israeli\n" \
			"Romanian\n" \
			"Italian\n" \
			"Gangsta\n" \
			"Greek\n" \
			"Serbian\n" \
			"Balkin\n" \
			"Danish\n" \
			"Scottish\n" \
			"Irish\n");
			
			strcat(szMiscArray,
			"Indian\n" \
			"Norwegian\n" \
			"Swedish\n" \
			"Finnish\n" \
			"Hungarian\n" \
			"Bulgarian\n" \
			"Pakistani\n" \
			"Cuban\n" \
			"Slavic\n" \
			"Indonesian\n" \
			"Filipino\n" \
			"Hawaiian\n");
			
			strcat(szMiscArray,
			"Somalian\n" \
			"Armenian\n" \
			"Persian\n" \
			"Vietnamese\n" \
			"Slovenian\n" \
			"Kiwi\n" \
			"Brazilian\n" \
			"Georgian");
			return Dialog_Show(playerid, DIALOG_REGISTER_ACCENT, DIALOG_STYLE_LIST, "Accent", szMiscArray, "Select", "<<");
		}

		case 4:
		{
			if(PlayerData[playerid][pGender] == 0)
			{
				SendClientMessage(playerid, COLOR_YELLOW, "Please pick a gender.");
				return ShowAccountCreationDlg(playerid);
			}
			if(PlayerData[playerid][pAge] == 0)
			{
			    SendClientMessage(playerid, COLOR_GREY, "You must choose a age to complete");
			    ShowAccountCreationDlg(playerid);
			}
		   	PlayerData[playerid][pSetup] = 0;

            SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
		    SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
		    SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);

		    SetPlayerVirtualWorld(playerid, 0);
		    SetCameraBehindPlayer(playerid);
		    StopAudioStreamForPlayer(playerid);
		    TogglePlayerControllableEx(playerid, 1);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i", PlayerData[playerid][pGender], PlayerData[playerid][pAge], PlayerData[playerid][pSkin], PlayerData[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
			
            CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
            return 1;
		}
	}
	return 1;
}

Dialog:DIALOG_REGISTER_ACCENT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0: strcpy(PlayerData[playerid][pAccent], "None", 16);
			case 1: strcpy(PlayerData[playerid][pAccent], "English", 16);
			case 2: strcpy(PlayerData[playerid][pAccent], "American", 16);
			case 3: strcpy(PlayerData[playerid][pAccent], "British", 16);
			case 4: strcpy(PlayerData[playerid][pAccent], "Chinese", 16);
			case 5: strcpy(PlayerData[playerid][pAccent], "Korean", 16);
			case 6: strcpy(PlayerData[playerid][pAccent], "Japanese", 16);
			case 7: strcpy(PlayerData[playerid][pAccent], "Asian", 16);
			case 8: strcpy(PlayerData[playerid][pAccent], "Canadian", 16);
			case 9: strcpy(PlayerData[playerid][pAccent], "Australian", 16);
			case 10: strcpy(PlayerData[playerid][pAccent], "Southern", 16);
			case 11: strcpy(PlayerData[playerid][pAccent], "Russian", 16);
			case 12: strcpy(PlayerData[playerid][pAccent], "Ukrainian", 16);
			case 13: strcpy(PlayerData[playerid][pAccent], "German", 16);
			case 14: strcpy(PlayerData[playerid][pAccent], "French", 16);
			case 15: strcpy(PlayerData[playerid][pAccent], "Portuguese", 16);
			case 16: strcpy(PlayerData[playerid][pAccent], "Polish", 16);
			case 17: strcpy(PlayerData[playerid][pAccent], "Estonian", 16);
			case 18: strcpy(PlayerData[playerid][pAccent], "Latvian", 16);
			case 19: strcpy(PlayerData[playerid][pAccent], "Dutch", 16);
			case 20: strcpy(PlayerData[playerid][pAccent], "Jamaican", 16);
			case 21: strcpy(PlayerData[playerid][pAccent], "Turkish", 16);
			case 22: strcpy(PlayerData[playerid][pAccent], "Mexican", 16);
			case 23: strcpy(PlayerData[playerid][pAccent], "Spanish", 16);
			case 24: strcpy(PlayerData[playerid][pAccent], "Arabic", 16);
			case 25: strcpy(PlayerData[playerid][pAccent], "Israeli", 16);
			case 26: strcpy(PlayerData[playerid][pAccent], "Romanian", 16);
			case 27: strcpy(PlayerData[playerid][pAccent], "Italian", 16);
			case 28: strcpy(PlayerData[playerid][pAccent], "Gangsta", 16);
			case 29: strcpy(PlayerData[playerid][pAccent], "Greek", 16);
			case 30: strcpy(PlayerData[playerid][pAccent], "Serbian", 16);
			case 31: strcpy(PlayerData[playerid][pAccent], "Balkin", 16);
			case 32: strcpy(PlayerData[playerid][pAccent], "Danish", 16);
			case 33: strcpy(PlayerData[playerid][pAccent], "Scottish", 16);
			case 34: strcpy(PlayerData[playerid][pAccent], "Irish", 16);
			case 35: strcpy(PlayerData[playerid][pAccent], "Indian", 16);
			case 36: strcpy(PlayerData[playerid][pAccent], "Norwegian", 16);
			case 37: strcpy(PlayerData[playerid][pAccent], "Swedish", 16);
			case 38: strcpy(PlayerData[playerid][pAccent], "Finnish", 16);
			case 39: strcpy(PlayerData[playerid][pAccent], "Hungarian", 16);
			case 40: strcpy(PlayerData[playerid][pAccent], "Bulgarian", 16);
			case 41: strcpy(PlayerData[playerid][pAccent], "Pakistani", 16);
			case 42: strcpy(PlayerData[playerid][pAccent], "Cuban", 16);
			case 43: strcpy(PlayerData[playerid][pAccent], "Slavic", 16);
			case 44: strcpy(PlayerData[playerid][pAccent], "Indonesian", 16);
			case 45: strcpy(PlayerData[playerid][pAccent], "Filipino", 16);
			case 46: strcpy(PlayerData[playerid][pAccent], "Hawaiian", 16);
			case 47: strcpy(PlayerData[playerid][pAccent], "Somalian", 16);
			case 48: strcpy(PlayerData[playerid][pAccent], "Armenian", 16);
			case 49: strcpy(PlayerData[playerid][pAccent], "Persian", 16);
			case 50: strcpy(PlayerData[playerid][pAccent], "Vietnamese", 16);
			case 51: strcpy(PlayerData[playerid][pAccent], "Slovenian", 16);
			case 52: strcpy(PlayerData[playerid][pAccent], "Kiwi", 16);
			case 53: strcpy(PlayerData[playerid][pAccent], "Brazilian", 16);
			case 54: strcpy(PlayerData[playerid][pAccent], "Georgian", 16);
			default: SendClientMessage(playerid, COLOR_GREY, "Invalid accent. Valid types range from 0 to 53.");
		}

	}
	return ShowAccountCreationDlg(playerid);
}

ClearChatbox(playerid)
{
	for(new i = 0; i < 50; i++)
	{
		SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}
StartTutorial(playerid)
{
    TutStep[playerid] = 1;
    new tstr[1024];
    strcat(tstr, "Welcome to ");
    strcat(tstr,  GetServerName());
    strcat(tstr, "!\n Thanks for choosing us as your Roleplay Destination, we hope you enjoy your stay!\n");
    strcat(tstr, "This tutorial will guide you through the basic steps of the server.\n");
    strcat(tstr, "Please enjoy this short introduction to get to know ");
    strcat(tstr, GetServerName());
    strcat(tstr, " on a personal level.\n");
    strcat(tstr, "{FF8000}Press next to continue.");
    InterpolateCameraPos(playerid, -37.715755, -2101.054931, 121.661994, 3031.810302, -638.207458, 196.425064, 12000);
    InterpolateCameraLookAt(playerid, -33.558185, -2098.420898, 120.781112, 3028.381103, -641.794555, 195.814514, 12000);
    Dialog_Show(playerid,DIALOG_SHOW_TUTORIAL,DIALOG_STYLE_MSGBOX,"{33CCFF}Tutorial", tstr, "Next", "");
    SetPlayerVirtualWorld(playerid, 0);
    TogglePlayerControllableEx(playerid, 0);
    return 1;
}

Dialog:DIALOG_SHOW_TUTORIAL(playerid, response, listitem, inputtext[])
{
	if(response || !response)
	{
		if(!IsPlayerInTutorial(playerid))
		{
			return 1;
		}

		switch(TutStep[playerid])
		{
			case 1:
			{
			    new str[1024];
	            ClearChatbox(playerid);

				TutStep[playerid] = 2;

	            InterpolateCameraPos(playerid, 3022.353027, -640.721740, 193.414672, 1227.661254, -1835.082397, 25.913717, 12000);
				InterpolateCameraLookAt(playerid, 3019.046142, -644.348388, 192.459640, 1226.208251, -1830.758422, 23.866357, 12000);
				SetPlayerPos(playerid, 1223.7166,-1851.4952,8.3894);
				strcat(str, "{FFFFFF}You're about to see our Department of Motor Vehicles. This is where you'll obtain your drivers license.\n");
				strcat(str, "While you may drive without a license, it is recommended that you obtain one, else LSPD will be after you!\n");
				strcat(str, "Once you've obtained your drivers license, it's time to get a job! We have many great jobs to offer.\n");
				strcat(str, "If you're looking for a decent starting job, try out our courier job, garbage man job, or miner job!\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - Driver License", str, "Next", "");
			}
			case 2:
			{
			    new str[1024];
			    ClearChatbox(playerid);

				TutStep[playerid] = 3;

				InterpolateCameraPos(playerid, 1244.807250, -1896.417480, 62.970653, 1320.417602, -1480.743286, 78.601524, 5000);
				InterpolateCameraLookAt(playerid, 1243.523193, -1892.262817, 60.502914, 1318.168212, -1476.724731, 76.654434, 5000);
				SetPlayerPos(playerid, 1310.9757,-1445.2444,-27.2783);
				strcat(str, "{FFFFFF}This is the market area, the most common hangout on "); 
                strcat(str, GetServerName());
                strcat(str, "\n");
				strcat(str, "You'll be starting out as a level 1 newbie with no upgrades. You'll need to level up with respect points.\n");
				strcat(str, "For every hour you play, you'll gain 1 respect point. You earn this on your paycheck.\n");
				strcat(str, "Paychecks will be given out once every hour when the time hits xx:00.\n");
				strcat(str, "~As a new player, your inventory is severely limited. You'll need to upgrade it with upgrade points.\n");
				strcat(str, "You'll also start out with a 2 hour weapon restriction to avoid deathmatching.\n");
                strcat(str, "We believe that our upgrades system gives the players an incentive to play and work hard.\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - Hanging out", str, "Next", "");
			}
			case 3:
			{
			    new str[1024];
			    ClearChatbox(playerid);

				TutStep[playerid] = 4;

				InterpolateCameraPos(playerid, 1320.417602, -1480.743408, 78.601516, 1482.683227, -1628.944824, 44.981044, 5000);
				InterpolateCameraLookAt(playerid, 1317.750488, -1476.783447, 77.116455, 1486.893188, -1631.457153, 43.999187, 5000);
				SetPlayerPos(playerid, 1493.3798,-1668.6997,-15.7351);
				strcat(str, "{FFFFFF}");
                strcat(str, GetServerName());
                strcat(str, " has many great factions to offer.\n");
				strcat(str, "You're currently looking at the Los Santos Police Department.\n");
				strcat(str, "Factions are legal organizations, each with their own unique roles.\n");
                strcat(str, "Whether it be enforcing the law, saving lives, or reporting the news.\n");
                strcat(str, "You can apply to become a faction member on ");
                strcat(str, GetServerWebsite());
                strcat(str, ".\n");
                strcat(str, "Being in a faction is quite fun and can lead to some good cash and perks for you!\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - Factions", str, "Next", "");
			}
			case 4:
			{
			    new str[1024];
			    ClearChatbox(playerid);

				TutStep[playerid] = 5;

				InterpolateCameraPos(playerid, 1477.633544, -1627.411010, 50.594058, 2446.644531, -1661.652465, 29.177988, 7000);
				InterpolateCameraLookAt(playerid, 1481.815795, -1629.860473, 49.365783, 2451.346191, -1662.243896, 27.582590, 7000);

				SetPlayerPos(playerid, 2467.3708,-1666.0961,7.8903);


				strcat(str, "{FFFFFF}Doing things the legal way isnt your type? We've got you covered\n");
				strcat(str, "Here on ");
                strcat(str,  GetServerName());
                strcat(str, " we have an amazing gang system with many unique features!\n");
				strcat(str, "Gangs are illegal organizations you may join by roleplaying with the higher ranks.\n");
				strcat(str, "Gangs offer many different types of roleplay, from street gangs to mafias & cartels.\n");
				strcat(str, "Grab yourself a gun and roleplay your way into a gang!\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - Gangs", str, "Next", "");
			}
			case 5:
			{
			    new str[1024];
			    ClearChatbox(playerid);

				TutStep[playerid] = 6;

				InterpolateCameraPos(playerid, 2426.551025, -1659.479614, 44.816139, 2097.071533, -1293.159912, 29.785530, 7000);
				InterpolateCameraLookAt(playerid, 2431.008300, -1659.783935, 42.571231, 2095.802246, -1288.467041, 28.616756, 7000);

				SetPlayerPos(playerid, 2093.6177,-1302.5441,4.6590);


				strcat(str, "{FFFFFF}Want your own piece of real estate? We've got you covered!\n");
				strcat(str, "Here on ");
                strcat(str, GetServerName());
                strcat(str, " we offer a wide variety of property types you may own.\n");
				strcat(str, "Buying your own house will allow you to customize the interior and store your goodies!\n");
				strcat(str, "Buying a garage will allow you to keep your car from being stolen, repair it, and upgrade it!\n");
                strcat(str, "Buying your own business is an excellent source of income! There are many different types!\n");
                strcat(str, "Lands are quite special. You can own your own piece of the map!\n");
                strcat(str, "Owning a land allows you to place walls and other objects, and customize your piece of land.\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - Properties", str, "Next", "");
			}
			case 6:
			{
			    new str[1024];
			    ClearChatbox(playerid);

				TutStep[playerid] = 7;

				InterpolateCameraPos(playerid, 2100.492675, -1313.117553, 40.094261, 2214.083496, -1122.290161, 34.281135, 7000);
				InterpolateCameraLookAt(playerid, 2099.261718, -1308.616088, 38.299301, 2214.811767, -1127.109375, 33.165603, 7000);

				SetPlayerPos(playerid, 2216.8718,-1122.6305,4.1262);


				strcat(str, "{FFFFFF}Being a roleplay server, we do have rules, but we promise they're not too bad!\n");
				strcat(str, "1.) No deathmatching, e.g. killing without a proper reason. Don't ruin it for everyone else.\n");
				strcat(str, "2.) No powergaming. Powergaming is commiting unrealistic acts and forcing actions upon others.\n");
				strcat(str, "3.) No hacking/cheating. We have zero tolerance for people who use cheats. Permanent ban.\n");
				strcat(str, "4.) No exploiting. If you find a bug that gives you an unfair advantage, report it on the forums.\n");
				//strcat(str, "5.) No metagaming. Metagaming is mixing OOC information in character.\n");
                strcat(str, "Please join us on ");
                strcat(str, GetServerWebsite());
                strcat(str, " for a complete list of our rules!\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - Rules", str, "Next", "");
			}
			case 7:
			{
			    new str[1024];
			    ClearChatbox(playerid);

				TutStep[playerid] = 8;

				InterpolateCameraPos(playerid, 2219.225830, -1129.354248, 40.080249, 1765.863159, -1268.650512, 123.706245, 5500);
				InterpolateCameraLookAt(playerid, 2219.667968, -1134.274780, 39.310207, 1760.993774, -1269.778442, 123.835456, 5500);
				strcat(str, "{FFFFFF}Thanks for taking the time to read our tutorial, we greatly appreciate it.\n");
				strcat(str, "We know you'll have tons of fun here, and meet many great people.\n");
				strcat(str, "So get out there! Get a job and buy yourself some property! Make a name for yourself!\n");
				strcat(str, "{FF8000}Press next to continue.");
				Dialog_Show(playerid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - The end", str, "Next", "");
			}
			case 8:
			{
                if(PlayerData[playerid][pSetup])
                {
                    PlayerData[playerid][pSetup] = 0;
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET setup = 0 WHERE uid = %i", PlayerData[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    
                    CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
                }
                else
                {
                    //He was forced by admin
                    StopAudioStreamForPlayer(playerid);
                    DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
                    fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
                    PlayerData[playerid][pCP] = CHECKPOINT_MISC;
                    SetPlayerCheckpoint(playerid, 1219.2590, -1812.1093, 16.5938, 3.0);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Welcome to {00aa00}%s{FFFFFF}. Make sure to visit %s for news and updates.", GetServerName(), GetServerWebsite());
                    SendClientMessage(playerid, COLOR_WHITE, "Use the {FFFF90}/locate{FFFFFF} command to point to locations of jobs, businesses, and common places.");
                    SendClientMessage(playerid, COLOR_AQUA, "You need a driver's license, the DMV has been marked on your map. Navigate to the marker to begin your drivers test.");

                }
                
                TutStep[playerid] = 0;

                SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
                SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
                SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);

                SetPlayerVirtualWorld(playerid, 0);
                SetCameraBehindPlayer(playerid);
                StopAudioStreamForPlayer(playerid);
                TogglePlayerControllableEx(playerid, 1);
			}
		}
	}
	return 1;
}

/*forward ShowMainMenuCamera(playerid);
public ShowMainMenuCamera(playerid)
{
    PlayLoginMusic(playerid);
    ClearChat(playerid);

    ShowRandomCamera(playerid);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT *,(date + interval duration day) as end, ((date + interval duration day) > now()) as active FROM users_bans WHERE (username = '%e' OR ip = '%e' OR ip LIKE '%e') and ((date + interval duration day) > now() || duration = 0)", GetPlayerNameEx(playerid), GetPlayerIP(playerid), GetPlayerIPRange(playerid));
	mysql_tquery(connectionID, queryBuffer, "db_THREAD_LOOKUP_BANS", "i", playerid);
}*/

forward BanLookup(playerid);
public BanLookup(playerid)
{
    new rows = cache_get_row_count(connectionID);

    if (rows)
    {
        new adminname[MAX_PLAYER_NAME], username[MAX_PLAYER_NAME];
        new userip[16], date[24], end[24], reason[128], durationstr[32];
        new duration = cache_get_field_content_int(0, "duration");
        new msg[512];
        new adminmsg[128];

        cache_get_field_content(0, "username", username);
        cache_get_field_content(0, "userip", userip);
        cache_get_field_content(0, "adminname", adminname);
        cache_get_field_content(0, "reason", reason);
        cache_get_field_content(0, "date", date);
        cache_get_field_content(0, "end", end);
        durationstr = FormatBanDuration(duration);

        GameTextForPlayer(playerid, "~r~You are banned!", 999999, 3);

        if (duration == PERMANENT_BAN_DURATION)
        {
            format(msg, sizeof(msg),
                "{808080}Player name: {FFFFFF}%s\t"\
                "{808080}Player IP: {FFFFFF}%s\n"\
                "{808080}Banned by: {FFFFFF}%s\t"\
                "{808080}Duration: {FFFFFF}%s\n"\
                "{808080}Date: {FFFFFF}%s\n"\
                "{808080}Ban reason: {FFFFFF}%s",
                username,
                userip,
                adminname,
                durationstr,
                date,
                reason);
        }
        else
        {
            format(msg, sizeof(msg),
                "{808080}Player name: {FFFFFF}%s\t"\
                "{808080}Player IP: {FFFFFF}%s\n"\
                "{808080}Banned by: {FFFFFF}%s\t"\
                "{808080}Duration: {FFFFFF}%s\n"\
                "{808080}Date: {FFFFFF}%s\t"\
                "{808080}End: {FFFFFF}%s\n"\
                "{808080}Ban reason: {FFFFFF}%s",
                username,
                userip,
                adminname,
                durationstr,
                date,
                end,
                reason);
        }
        format(adminmsg, sizeof(adminmsg), "%s tries to login with banned account. Duration: %s, Reason: %s", username, durationstr, reason);
        LoginKickBannedPlayer(playerid, msg, adminmsg);
    }
    else
    {
        if (CheckIPBan(GetPlayerIP(playerid)))
        {
            new string[128];
            format(string, sizeof(string), "IP (%s) is banned", GetPlayerIP(playerid));
            KickPlayer(playerid, string, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
        }
        else
        {
            ShowMainMenuGUI(playerid);
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid, login_nb_fails, TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) as login_diff_min FROM "#TABLE_USERS" WHERE username = '%e'", GetPlayerNameEx(playerid));
            mysql_tquery(connectionID, queryBuffer, "AccountLookup", "i", playerid);

        }
    }
}

forward AccountLookup(playerid);
public AccountLookup(playerid)
{
    new rows = cache_get_row_count(connectionID);

    if (rows)
    {
        if (cache_get_field_content_int(0, "login_nb_fails") >= 5 &&
           cache_get_field_content_int(0, "login_diff_min") < 5)
        {
            KickPlayer(playerid, "Fail to login. Your account is locked try to login after 5min.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
        }
        else
        {
            new uid = cache_get_field_content_int(0, "uid");
            foreach (new targetid : Player)
            {
                if (playerid != targetid && PlayerData[targetid][pLogged] && PlayerData[targetid][pID] == uid)
                {
                    KickPlayer(playerid, "Fail to login. You are already online.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
                    return 1;
                }
            }
            ShowLoginDlg(playerid);
        }
    }
    else
    {
        if (strfind(GetPlayerNameEx(playerid), "_") == -1)
        {
            Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "");
        }
        else
        {
            ShowRegisterDlg(playerid);
        }
    }
    return 1;
}

forward ShowMainMenuCamera(playerid);
public ShowMainMenuCamera(playerid)
{
    PlayLoginMusic(playerid);
    ClearChat(playerid);

    ShowRandomCamera(playerid);
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users_bans WHERE (username = '%e') AND (permanent=1 OR duration=0 OR end > NOW()) ORDER BY id DESC LIMIT 1;", GetPlayerNameEx(playerid));
    mysql_tquery(connectionID, queryBuffer, "BanLookup", "i", playerid);
}

PlayerLogin(playerid)
{
    if(PlayerData[playerid][pKicked]) return 0;
    
    if(PlayerData[playerid][pLogged])
    {
        return 0;
    }

    ClearChat(playerid);

    TogglePlayerSpectating(playerid, 1);
    SetPlayerColor(playerid, 0xFFFFFF00);
    SetPlayerTeam(playerid, NO_TEAM);

    // Due to a SA-MP bug, you can't apply camera coordinates directly after enabling spectator mode (to hide HUD).
    // In this case we'll use a timer to defer this action.

    SetTimerEx("ShowMainMenuCamera", 400, false, "i", playerid);

	return 1;
}

// ---------------------------------------

forward TutorialTimer(playerid, stage);
public TutorialTimer(playerid, stage)
{
	//new string[2048];
	if(PlayerData[playerid][pLogged] && IsPlayerInTutorial(playerid))
	{

		switch(stage)
		{
			case 11:
			{
			   	PlayerData[playerid][pSetup] = 0;
                SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
			    SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
			    SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);

			    SetPlayerVirtualWorld(playerid, 0);
			    SetCameraBehindPlayer(playerid);
			    StopAudioStreamForPlayer(playerid);
			    TogglePlayerControllableEx(playerid, 1);
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i", PlayerData[playerid][pGender], PlayerData[playerid][pAge], PlayerData[playerid][pSkin], PlayerData[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

                
                CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
			}
		}
	}
}

CMD:skiptut(playerid, params[])
{
	new targetid;

	if(PlayerData[playerid][pAdmin] < JUNIOR_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skiptut [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(!IsPlayerInTutorial(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "That player isn't currently watching the tutorial.");
	}

    new str[1024];
    ClearChatbox(targetid);

    TutStep[targetid] = 8;

    InterpolateCameraPos(targetid, 2219.225830, -1129.354248, 40.080249, 1765.863159, -1268.650512, 123.706245, 5500);
    InterpolateCameraLookAt(targetid, 2219.667968, -1134.274780, 39.310207, 1760.993774, -1269.778442, 123.835456, 5500);
    strcat(str, "{FFFFFF}Thanks for taking the time to read our tutorial, we greatly appreciate it.\n");
    strcat(str, "We know you'll have tons of fun here, and meet many great people.\n");
    strcat(str, "So get out there! Get a job and buy yourself some property! Make a name for yourself!\n");
    strcat(str, "{FF8000}Press next to continue.");
    Dialog_Show(targetid, DIALOG_SHOW_TUTORIAL, DIALOG_STYLE_MSGBOX, "{33CCFF}Tutorial - The end", str, "Next", "");

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s forced %s out of the tutorial.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}

CMD:forcetut(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < SENIOR_ADMIN)
	{
		return SendClientErrorUnauthorizedCmd(playerid);
	}
	new targetid;

	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcetut [playerid]");
	}
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to watch the server tutorial", GetRPName(playerid), GetRPName(targetid));
	SendClientMessageEx(targetid, COLOR_LIGHTRED, "Administrator %s has forced you to rewatch the server tutorial.", GetRPName(playerid));
    
	StartTutorial(targetid);
  	return 1;
}


static Text:MainMenuTxtdraw[14];


ShowMainMenuGUI(playerid) {
	new string[22];

 	format(string, sizeof(string), "Players online: %d", Iter_Count(Player));
  	TextDrawSetString(MainMenuTxtdraw[11], string);
  	TextDrawSetString(MainMenuTxtdraw[8], GetServerMOTD());

	for(new i = 0; i < 14; i++) {
		TextDrawShowForPlayer(playerid, MainMenuTxtdraw[i]);
	}

	return 1;
}

HideMainMenuGUI(playerid) 
{

	for(new i = 0; i < 14; i++) {
		TextDrawHideForPlayer(playerid, MainMenuTxtdraw[i]);
	}

	return 1;
}

InitLoginGUI()
{
	// NEW MainMenuTxtdraw
	MainMenuTxtdraw[0] = TextDrawCreate(641.531494, 40.000000, "usebox");
	TextDrawLetterSize(MainMenuTxtdraw[0], 0.000000, 11.544445);
	TextDrawTextSize(MainMenuTxtdraw[0], -2.000000, 0.000000);
	TextDrawAlignment(MainMenuTxtdraw[0], 1);
	TextDrawColor(MainMenuTxtdraw[0], 0);
	TextDrawUseBox(MainMenuTxtdraw[0], true);
	TextDrawBoxColor(MainMenuTxtdraw[0], 102);
	TextDrawSetShadow(MainMenuTxtdraw[0], 0);
	TextDrawSetOutline(MainMenuTxtdraw[0], 0);
	TextDrawFont(MainMenuTxtdraw[0], 0);

	MainMenuTxtdraw[1] = TextDrawCreate(660.272338, 47.000000, "usebox");
	TextDrawLetterSize(MainMenuTxtdraw[1], 0.041698, -0.919443);
	TextDrawTextSize(MainMenuTxtdraw[1], -2.000000, 0.000000);
	TextDrawAlignment(MainMenuTxtdraw[1], 1);
	TextDrawColor(MainMenuTxtdraw[1], 0);
	TextDrawUseBox(MainMenuTxtdraw[1], true);
	TextDrawBoxColor(MainMenuTxtdraw[1], 102);
	TextDrawSetShadow(MainMenuTxtdraw[1], 0);
	TextDrawSetOutline(MainMenuTxtdraw[1], 0);
	TextDrawFont(MainMenuTxtdraw[1], 0);

	MainMenuTxtdraw[2] = TextDrawCreate(641.531494, 139.166656, "usebox");
	TextDrawLetterSize(MainMenuTxtdraw[2], 0.000000, -0.057406);
	TextDrawTextSize(MainMenuTxtdraw[2], -2.000000, 0.000000);
	TextDrawAlignment(MainMenuTxtdraw[2], 1);
	TextDrawColor(MainMenuTxtdraw[2], 0);
	TextDrawUseBox(MainMenuTxtdraw[2], true);
	TextDrawBoxColor(MainMenuTxtdraw[2], 102);
	TextDrawSetShadow(MainMenuTxtdraw[2], 0);
	TextDrawSetOutline(MainMenuTxtdraw[2], 0);
	TextDrawFont(MainMenuTxtdraw[2], 0);

	MainMenuTxtdraw[3] = TextDrawCreate(249.252960, 62.416679, "Arabica Roleplay");
	TextDrawLetterSize(MainMenuTxtdraw[3], 0.578843, 3.670834);
	TextDrawAlignment(MainMenuTxtdraw[3], 1);
	TextDrawColor(MainMenuTxtdraw[3], -5963521);
	TextDrawSetShadow(MainMenuTxtdraw[3], 0);
	TextDrawSetOutline(MainMenuTxtdraw[3], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[3], 51);
	TextDrawFont(MainMenuTxtdraw[3], 3);
	TextDrawSetProportional(MainMenuTxtdraw[3], 1);

	MainMenuTxtdraw[4] = TextDrawCreate(278.301361, 95.083305, SERVER_REVISION);
	TextDrawLetterSize(MainMenuTxtdraw[4], 0.407833, 2.824997);
	TextDrawTextSize(MainMenuTxtdraw[4], 203.806701, 93.333343);
	TextDrawAlignment(MainMenuTxtdraw[4], 1);
	TextDrawColor(MainMenuTxtdraw[4], -1);
	//TextDrawUseBox(MainMenuTxtdraw[4], true);
	TextDrawBoxColor(MainMenuTxtdraw[4], 0);
	TextDrawSetShadow(MainMenuTxtdraw[4], 0);
	TextDrawSetOutline(MainMenuTxtdraw[4], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[4], 51);
	TextDrawFont(MainMenuTxtdraw[4], 2);
	TextDrawSetProportional(MainMenuTxtdraw[4], 1);

	MainMenuTxtdraw[5] = TextDrawCreate(641.531494, 297.833312, "usebox");
	TextDrawLetterSize(MainMenuTxtdraw[5], 0.000000, 16.470375);
	TextDrawTextSize(MainMenuTxtdraw[5], -2.000000, 0.000000);
	TextDrawAlignment(MainMenuTxtdraw[5], 1);
	TextDrawColor(MainMenuTxtdraw[5], 0);
	TextDrawUseBox(MainMenuTxtdraw[5], true);
	TextDrawBoxColor(MainMenuTxtdraw[5], 102);
	TextDrawSetShadow(MainMenuTxtdraw[5], 0);
	TextDrawSetOutline(MainMenuTxtdraw[5], 0);
	TextDrawFont(MainMenuTxtdraw[5], 0);

	MainMenuTxtdraw[6] = TextDrawCreate(641.531494, 306.000000, "usebox");
	TextDrawLetterSize(MainMenuTxtdraw[6], 0.003746, -0.232409);
	TextDrawTextSize(MainMenuTxtdraw[6], -2.000000, 0.000000);
	TextDrawAlignment(MainMenuTxtdraw[6], 1);
	TextDrawColor(MainMenuTxtdraw[6], 0);
	TextDrawUseBox(MainMenuTxtdraw[6], true);
	TextDrawBoxColor(MainMenuTxtdraw[6], 102);
	TextDrawSetShadow(MainMenuTxtdraw[6], 0);
	TextDrawSetOutline(MainMenuTxtdraw[6], 0);
	TextDrawFont(MainMenuTxtdraw[6], 0);

	MainMenuTxtdraw[7] = TextDrawCreate(28.579757, 326.083343, "News:");
	TextDrawLetterSize(MainMenuTxtdraw[7], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[7], 1);
	TextDrawColor(MainMenuTxtdraw[7], -5963521);
	TextDrawSetShadow(MainMenuTxtdraw[7], 0);
	TextDrawSetOutline(MainMenuTxtdraw[7], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[7], 51);
	TextDrawFont(MainMenuTxtdraw[7], 1);
	TextDrawSetProportional(MainMenuTxtdraw[7], 1);
	
	MainMenuTxtdraw[8] = TextDrawCreate(81.285598, 326.083374, "ServerMOTD");
	TextDrawLetterSize(MainMenuTxtdraw[8], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[8], 1);
	TextDrawColor(MainMenuTxtdraw[8], -1);
	TextDrawSetShadow(MainMenuTxtdraw[8], 0);
	TextDrawSetOutline(MainMenuTxtdraw[8], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[8], 51);
	TextDrawFont(MainMenuTxtdraw[8], 1);
	TextDrawSetProportional(MainMenuTxtdraw[8], 1);

	MainMenuTxtdraw[9] = TextDrawCreate(73.557861, 393.166656, "Website:");
	TextDrawLetterSize(MainMenuTxtdraw[9], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[9], 1);
	TextDrawColor(MainMenuTxtdraw[9], -5963521);
	TextDrawSetShadow(MainMenuTxtdraw[9], 0);
	TextDrawSetOutline(MainMenuTxtdraw[9], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[9], 51);
	TextDrawFont(MainMenuTxtdraw[9], 1);
	TextDrawSetProportional(MainMenuTxtdraw[9], 1);

	MainMenuTxtdraw[10] = TextDrawCreate(143.367507, 394.333343, "arabicarp.com");
	TextDrawLetterSize(MainMenuTxtdraw[10], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[10], 1);
	TextDrawColor(MainMenuTxtdraw[10], -1);
	TextDrawSetShadow(MainMenuTxtdraw[10], 0);
	TextDrawSetOutline(MainMenuTxtdraw[10], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[10], 51);
	TextDrawFont(MainMenuTxtdraw[10], 1);
	TextDrawSetProportional(MainMenuTxtdraw[10], 1);

	MainMenuTxtdraw[11] = TextDrawCreate(235.666152, 359.333374, "Players Online:");
	TextDrawLetterSize(MainMenuTxtdraw[11], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[11], 1);
	TextDrawColor(MainMenuTxtdraw[11], -5963521);
	TextDrawSetShadow(MainMenuTxtdraw[11], 0);
	TextDrawSetOutline(MainMenuTxtdraw[11], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[11], 51);
	TextDrawFont(MainMenuTxtdraw[11], 1);
	TextDrawSetProportional(MainMenuTxtdraw[11], 1);

	MainMenuTxtdraw[12] = TextDrawCreate(345.300231, 393.749969, "Discord:");
	TextDrawLetterSize(MainMenuTxtdraw[12], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[12], 1);
	TextDrawColor(MainMenuTxtdraw[12], -5963521);
	TextDrawSetShadow(MainMenuTxtdraw[12], 0);
	TextDrawSetOutline(MainMenuTxtdraw[12], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[12], 51);
	TextDrawFont(MainMenuTxtdraw[12], 1);
	TextDrawSetProportional(MainMenuTxtdraw[12], 1);

	MainMenuTxtdraw[13] = TextDrawCreate(414.172668, 394.333374, GetServerDiscord());
	TextDrawLetterSize(MainMenuTxtdraw[13], 0.449999, 1.600000);
	TextDrawAlignment(MainMenuTxtdraw[13], 1);
	TextDrawColor(MainMenuTxtdraw[13], -1);
	TextDrawSetShadow(MainMenuTxtdraw[13], 0);
	TextDrawSetOutline(MainMenuTxtdraw[13], 1);
	TextDrawBackgroundColor(MainMenuTxtdraw[13], 51);
	TextDrawFont(MainMenuTxtdraw[13], 1);
	TextDrawSetProportional(MainMenuTxtdraw[13], 1);
}


hook OnPlayerRequestClass(playerid, classid)
{
    if(PlayerData[playerid][pKicked]) return 0;
    SetPlayerToSpawn(playerid);
    return 1;
}