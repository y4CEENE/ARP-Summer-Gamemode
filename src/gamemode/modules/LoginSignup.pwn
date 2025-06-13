/// @file      LoginSignup.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-05-24 14:45:17 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define REGISTRATION_VIRTUAL_WORLD 70707

static TutStep[MAX_PLAYERS];
static Text:MainMenuTextDraw[15];
static Text:WelcomeTextDraw;
static RegisterHashedPassword[MAX_PLAYERS][129];
static PasswordChanged[MAX_PLAYERS];

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

hook OnPlayerInit(playerid)
{
    PasswordChanged[playerid] = 0;
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
    KillTimer(PlayerData[playerid][pIntroKickTimer]);
    PlayerData[playerid][pIntroKickTimer] = SetTimerEx("IntroKick", 60800, false, "i", playerid);
    return 1;
}


ShowAccountCreationDlg(playerid)
{
    new string[4096];
    format(string, sizeof(string), "Name\t%s\n\
        Gender\t%s\n\
        Age\t%d\n\
        Accent\t%s\n\
        Complete",
        GetPlayerNameEx(playerid),
        GetPlayerGenderStr(playerid),
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
    Dialog_Show(playerid, DIALOG_AGE,DIALOG_STYLE_INPUT,"{00FF00}Account Registration", "Enter the age of your character [%i-%i]", "Okay", "Cancel", MIN_PLAYER_AGE, MAX_PLAYER_AGE);
    return 1;
}

ShowRegisterReferralDlg(playerid)
{
    Dialog_Show(playerid, DIALOG_REFERRAL, DIALOG_STYLE_INPUT, "Have you been referred here by anyone?", "Please enter the name of the player who referred you here:\n(You can click on 'Skip' if you haven't been referred by anyone.)", "Submit", "Skip");
    return 1;
}

ReferralCheck(playerid)
{
    DBFormat("SELECT username, ip FROM "#TABLE_USERS" WHERE uid = %i", PlayerData[playerid][pReferralUID]);
    DBExecute("ReferrerReward", "i", playerid);

}

DB:BanLookup(playerid)
{
    new rows = GetDBNumRows();

    if (rows)
    {
        new adminname[MAX_PLAYER_NAME], username[MAX_PLAYER_NAME];
        new userip[16], date[24], end[24], reason[128], durationstr[32];
        new duration = GetDBIntField(0, "duration");
        new msg[512];
        new adminmsg[128];

        GetDBStringField(0, "username", username);
        GetDBStringField(0, "userip", userip);
        GetDBStringField(0, "adminname", adminname);
        GetDBStringField(0, "reason", reason);
        GetDBStringField(0, "date", date);
        GetDBStringField(0, "end", end);
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
            DBFormat("SELECT uid, login_nb_fails, TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) as login_diff_min FROM "#TABLE_USERS" WHERE username = '%e'", GetPlayerNameEx(playerid));
            DBExecute("AccountLookup", "i", playerid);

        }
    }
}

DB:AccountLookup(playerid)
{
    new rows = GetDBNumRows();

    if (rows)
    {
        if (GetDBIntField(0, "login_nb_fails") >= 5 &&
           GetDBIntField(0, "login_diff_min") < 5)
        {
            KickPlayer(playerid, "Fail to login. Your account is locked try to login after 5min.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
        }
        else
        {
            new uid = GetDBIntField(0, "uid");
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

DB:RegisterAccount(playerid)
{
    new id = GetDBInsertID();

    DBFormat("SELECT * FROM "#TABLE_USERS" WHERE uid = %i", id);
    DBExecute("ProcessLogin", "i", playerid);

}

DB:OnUpdatePartner(playerid)
{
    if (GetDBNumRows())
    {
        GetDBStringField(0, "username", PlayerData[playerid][pMarriedName], MAX_PLAYER_NAME);
    }
}

hook OnLoadPlayer(playerid, row)
{
    if (PlayerData[playerid][pAdminDuty])
    {
        ResetPlayerWeaponsEx(playerid);
    }
    new date[64], string[128];
    GetDBStringField(row, "login_date", date, 32);
    GetDBStringField(row, "regdate", PlayerData[playerid][pRegDate], 32);
    GetDBStringField(row, "accent", PlayerData[playerid][pAccent], 16);
    GetDBStringField(row, "adminname", PlayerData[playerid][pAdminName], MAX_PLAYER_NAME);
    GetDBStringField(row, "contractby", PlayerData[playerid][pContractBy], MAX_PLAYER_NAME);
    GetDBStringField(row, "prisonedby", PlayerData[playerid][pJailedBy], MAX_PLAYER_NAME);
    GetDBStringField(row, "prisonreason", PlayerData[playerid][pJailReason], 128);
    GetDBStringField(row, "passportname", PlayerData[playerid][pPassportName], MAX_PLAYER_NAME);
    GetDBStringField(row, "customtitle", PlayerData[playerid][pCustomTitle], 64);
    PlayerData[playerid][pCustomTColor] = GetDBIntField(row, "customcolor");
    PlayerData[playerid][pID] = GetDBIntField(row, "uid");
    PlayerData[playerid][pSetup] = GetDBIntField(row, "setup");
    PlayerData[playerid][pGender] = PlayerGender:GetDBIntField(row, "gender");
    PlayerData[playerid][pAge] = GetDBIntField(row, "age");
    PlayerData[playerid][pSkin] = GetDBIntField(row, "skin");
    PlayerData[playerid][pPosX] = GetDBFloatField(row, "pos_x");
    PlayerData[playerid][pPosY] = GetDBFloatField(row, "pos_y");
    PlayerData[playerid][pPosZ] = GetDBFloatField(row, "pos_z");
    PlayerData[playerid][pPosA] = GetDBFloatField(row, "pos_a");
    PlayerData[playerid][pInterior] = GetDBIntField(row, "interior");
    PlayerData[playerid][pWorld] = GetDBIntField(row, "world");
    PlayerData[playerid][pCash] = GetDBIntField(row, "cash");
    PlayerData[playerid][pBank] = GetDBIntField(row, "bank");
    PlayerData[playerid][pPaycheck] = GetDBIntField(row, "paycheck");
    PlayerData[playerid][pLevel] = GetDBIntField(row, "level");
    PlayerData[playerid][pChatstyle] = GetDBIntField(row, "chatstyle");
    PlayerData[playerid][pVehicleCMD] = GetDBIntField(row, "vehiclecmd");//pVehicleCMD
    PlayerData[playerid][pCrowbar] = GetDBIntField(row, "crowbar");
    PlayerData[playerid][pAdminStrike] = GetDBIntField(row, "adminstrike");
    PlayerData[playerid][pDJ] = GetDBIntField(row, "dj");
    PlayerData[playerid][pHouseAlarm] = GetDBIntField(row, "housealarm");
    PlayerData[playerid][pvLock] = GetDBIntField(row, "vehlock");
    PlayerData[playerid][pEXP] = GetDBIntField(row, "exp");
    PlayerData[playerid][pMinutes] = GetDBIntField(row, "minutes");
    PlayerData[playerid][pHours] = GetDBIntField(row, "hours");
    PlayerData[playerid][pHelmet] = GetDBIntField(row, "helmet");
    PlayerData[playerid][pAdmin] = GetDBIntField(row, "adminlevel");
    PlayerData[playerid][pHelper] = GetDBIntField(row, "helperlevel");
    PlayerData[playerid][pHealth] = GetDBFloatField(row, "health");
    PlayerData[playerid][pArmor] = GetDBFloatField(row, "armor");
    PlayerData[playerid][pUpgradePoints] = GetDBIntField(row, "upgradepoints");
    PlayerData[playerid][pInjured] = GetDBIntField(row, "injured");
    PlayerData[playerid][pHospital] = GetDBIntField(row, "hospital");
    PlayerData[playerid][pSpawnHealth] = GetDBFloatField(row, "spawnhealth");
    PlayerData[playerid][pSpawnArmor] = GetDBFloatField(row, "spawnarmor");
    PlayerData[playerid][pJailType] = JailType:GetDBIntField(row, "jailtype");
    PlayerData[playerid][pJailTime] = GetDBIntField(row, "jailtime");
    PlayerData[playerid][pToggleVehCam] = GetDBIntField(row, "togglevehicle");
    PlayerData[playerid][pFightStyle] = GetDBIntField(row, "fightstyle");
    PlayerData[playerid][pPhone] = GetDBIntField(row, "phone");
    PlayerData[playerid][pJob] = GetDBIntField(row, "job");
    PlayerData[playerid][pSecondJob] = GetDBIntField(row, "secondjob");
    PlayerData[playerid][pCrimes] = GetDBIntField(row, "crimes");
    PlayerData[playerid][pArrested] = GetDBIntField(row, "arrested");
    PlayerData[playerid][pWantedLevel] = GetDBIntField(row, "wantedlevel");
    PlayerData[playerid][pNotoriety] = GetDBIntField(row, "notoriety");
    PlayerData[playerid][pMaterials] = GetDBIntField(row, "materials");
    PlayerData[playerid][pGlassItem] = GetDBIntField(row, "glassitem");
	PlayerData[playerid][pMetalItem] = GetDBIntField(row, "metalitem");
	PlayerData[playerid][pRubberItem] = GetDBIntField(row, "rubberitem");
	PlayerData[playerid][pIronItem] = GetDBIntField(row, "ironitem");
	PlayerData[playerid][pPlasticItem] = GetDBIntField(row, "plasticitem");
    PlayerData[playerid][pWeed] = GetDBIntField(row, "weed");
    PlayerData[playerid][pCocaine] = GetDBIntField(row, "cocaine");
    PlayerData[playerid][pHeroin] = GetDBIntField(row, "heroin");
    PlayerData[playerid][pPainkillers] = GetDBIntField(row, "painkillers");
    PlayerData[playerid][pSeeds] = GetDBIntField(row, "seeds");
    PlayerData[playerid][pChemicals] = GetDBIntField(row, "chemicals");
    PlayerData[playerid][pMuriaticAcid] = GetDBIntField(row, "muriaticacid");
    PlayerData[playerid][pBakingSoda] = GetDBIntField(row, "bakingsoda");
    PlayerData[playerid][pCigars] = GetDBIntField(row, "cigars");
    PlayerData[playerid][pPrivateRadio] = GetDBIntField(row, "walkietalkie");
    PlayerData[playerid][pChannel] = GetDBIntField(row, "channel");
    PlayerData[playerid][pRentingHouse] = GetDBIntField(row, "rentinghouse");
    PlayerData[playerid][pSpraycans] = GetDBIntField(row, "spraycans");
    PlayerData[playerid][pBoombox] = GetDBIntField(row, "boombox");
    PlayerData[playerid][pMP3Player] = GetDBIntField(row, "mp3player");
    PlayerData[playerid][pFishingRod] = GetDBIntField(row, "fishingrod");
    PlayerData[playerid][pFishingBait] = GetDBIntField(row, "fishingbait");
    PlayerData[playerid][pFishWeight] = GetDBIntField(row, "fishweight");
    PlayerData[playerid][pComponents] = GetDBIntField(row, "components");
    PlayerData[playerid][pSweep] = GetDBIntField(row, "sweep");
    PlayerData[playerid][pSweepLeft] = GetDBIntField(row, "sweepleft");
    PlayerData[playerid][pRccam] = GetDBIntField(row, "rccam");
    PlayerData[playerid][pCondom] = GetDBIntField(row, "condom");

    PlayerData[playerid][pMechanicSkill] = GetDBIntField(row, "mechanicskill");
    PlayerData[playerid][pSmugglerSkill] = GetDBIntField(row, "smugglerskill");
    PlayerData[playerid][pWeaponSkill] = GetDBIntField(row, "weaponskill");
    PlayerData[playerid][pDrugDealerSkill] = GetDBIntField(row, "drugdealerskill");
    PlayerData[playerid][pFarmerSkill] = GetDBIntField(row, "farmerskill");
    PlayerData[playerid][pDetectiveSkill] = GetDBIntField(row, "detectiveskill");
    PlayerData[playerid][pLawyerSkill] = GetDBIntField(row, "lawyerskill");
    PlayerData[playerid][pForkliftSkill] = GetDBIntField(row, "forkliftskill");
    PlayerData[playerid][pCarJackerSkill] = GetDBIntField(row, "carjackerskill");
    PlayerData[playerid][pCraftSkill] = GetDBIntField(row, "craftskill");
    PlayerData[playerid][pPizzaSkill] = GetDBIntField(row, "pizzaskill");
    PlayerData[playerid][pTruckerSkill] = GetDBIntField(row, "truckerskill");
    PlayerData[playerid][pHookerSkill] = GetDBIntField(row, "hookerskill");
    PlayerData[playerid][pRobberySkill] = GetDBIntField(row, "robberyskill");
    PlayerData[playerid][pFishingSkill] = GetDBIntField(row, "fishingskill");

    PlayerData[playerid][pToggleTextdraws] = GetDBIntField(row, "toggletextdraws");
    PlayerData[playerid][pToggleOOC] = GetDBIntField(row, "toggleooc");
    PlayerData[playerid][pTogglePhone] = GetDBIntField(row, "togglephone");
    PlayerData[playerid][pToggleAdmin] = GetDBIntField(row, "toggleadmin");
    PlayerData[playerid][pToggleHelper] = GetDBIntField(row, "togglehelper");
    PlayerData[playerid][pTogglePoints] = GetDBIntField(row, "togglepoints");
    PlayerData[playerid][pToggleTurfs] = GetDBIntField(row, "toggleturfs");
    PlayerData[playerid][pToggleNewbie] = GetDBIntField(row, "togglenewbie");
    PlayerData[playerid][pTogglePR] = GetDBIntField(row, "togglewt");
    PlayerData[playerid][pToggleRadio] = GetDBIntField(row, "toggleradio");
    PlayerData[playerid][pToggleVIP] = GetDBIntField(row, "togglevip");
    PlayerData[playerid][pToggleMusic] = GetDBIntField(row, "togglemusic");
    PlayerData[playerid][pToggleFaction] = GetDBIntField(row, "togglefaction");
    PlayerData[playerid][pToggleNews] = GetDBIntField(row, "togglenews");
    PlayerData[playerid][pToggleGlobal] = GetDBIntField(row, "toggleglobal");
    PlayerData[playerid][pToggleCam] = GetDBIntField(row, "togglecam");
    PlayerData[playerid][pToggleHUD] = GetDBIntField(row, "togglehud");
    PlayerData[playerid][pToggleReports] = GetDBIntField(row, "togglereports");
    PlayerData[playerid][pToggleWhisper] = GetDBIntField(row, "togglewhisper");
    PlayerData[playerid][pToggleBug] = GetDBIntField(row, "togglebug");
    PlayerData[playerid][pDonator] = GetDBIntField(row, "vippackage");
    PlayerData[playerid][pVIPTime] = GetDBIntField(row, "viptime");
    PlayerData[playerid][pVIPCooldown] = GetDBIntField(row, "vipcooldown");
    PlayerData[playerid][pSpawnSelect] = GetDBIntField(row, "spawntype");
    PlayerData[playerid][pSpawnHouse] = GetDBIntField(row, "spawnhouse");
    PlayerData[playerid][pWhitelist] = GetDBIntField(row, "whitelist");


    for (new i, wepid[64]; i < 13; i++)
    {
        format(wepid, sizeof(wepid), "weapon_%d", i);
        PlayerData[playerid][pWeapons][i] = GetDBIntField(row, wepid);
    }
    for (new i, ammoid[64]; i < 13; i++)
    {
        format(ammoid, sizeof(ammoid), "ammo_%d", i);
        PlayerData[playerid][pAmmo][i] = GetDBIntField(row, ammoid);
    }


    PlayerData[playerid][pFaction] = GetDBIntField(row, "faction");
    PlayerData[playerid][pFactionRank] = GetDBIntField(row, "factionrank");
    PlayerData[playerid][pFactionLeader] = GetDBIntField(row, "factionleader");
    PlayerData[playerid][pGangLeader] = GetDBIntField(row, "gangleader");
    PlayerData[playerid][pGang] = GetDBIntField(row, "gang");
    PlayerData[playerid][pGangRank] = GetDBIntField(row, "gangrank");
    PlayerData[playerid][pDivision] = GetDBIntField(row, "division");
    PlayerData[playerid][pCrew] = GetDBIntField(row, "crew");
    PlayerData[playerid][pContracted] = GetDBIntField(row, "contracted");
    PlayerData[playerid][pBombs] = GetDBIntField(row, "bombs");
    PlayerData[playerid][pCompletedHits] = GetDBIntField(row, "completedhits");
    PlayerData[playerid][pFailedHits] = GetDBIntField(row, "failedhits");
    PlayerData[playerid][pReports] = GetDBIntField(row, "reports");
    PlayerData[playerid][pNewbies] = GetDBIntField(row, "newbies");
    PlayerData[playerid][pHelpRequests] = GetDBIntField(row, "helprequests");
    PlayerData[playerid][pSpeedometer] = GetDBIntField(row, "speedometer");
    PlayerData[playerid][pWebDev] = GetDBIntField(row, "webdev");
    PlayerData[playerid][pFactionMod] = GetDBIntField(row, "factionmod");
    PlayerData[playerid][pGangMod] = GetDBIntField(row, "gangmod");
    PlayerData[playerid][pBanAppealer] = GetDBIntField(row, "banappealer");
    PlayerData[playerid][pFormerAdmin] = GetDBIntField(row, "FormerAdmin");
    PlayerData[playerid][pDeveloper] = GetDBIntField(row, "scripter");
    PlayerData[playerid][pHelperManager] = GetDBIntField(row, "helpermanager");
    PlayerData[playerid][pDynamicAdmin] = GetDBIntField(row, "dynamicadmin");
    PlayerData[playerid][pAdminPersonnel] = GetDBIntField(row, "adminpersonnel");
    PlayerData[playerid][pHumanResources] = GetDBIntField(row, "humanresources");
    PlayerData[playerid][pComplaintMod] = GetDBIntField(row, "complaintmod");
    PlayerData[playerid][pInventoryUpgrade] = GetDBIntField(row, "inventoryupgrade");
    PlayerData[playerid][pAddictUpgrade] = GetDBIntField(row, "addictupgrade");
    PlayerData[playerid][pTraderUpgrade] = GetDBIntField(row, "traderupgrade");
    PlayerData[playerid][pAssetUpgrade] = GetDBIntField(row, "assetupgrade");
    PlayerData[playerid][pLaborUpgrade] = GetDBIntField(row, "laborupgrade");
    PlayerData[playerid][pDMWarnings] = GetDBIntField(row, "dmwarnings");
    PlayerData[playerid][pWeaponRestricted] = GetDBIntField(row, "weaponrestricted");
    PlayerData[playerid][pReferralUID] = GetDBIntField(row, "referral_uid");
    PlayerData[playerid][pWatch] = GetDBIntField(row, "watch");
    PlayerData[playerid][pGPS] = GetDBIntField(row, "gps");
    PlayerData[playerid][pClothes] = GetDBIntField(row, "clothes");
    PlayerData[playerid][pShowLands] = GetDBIntField(row, "showlands");
    PlayerData[playerid][pShowTurfs] = GetDBIntField(row, "showturfs");
    PlayerData[playerid][pWatchOn] = GetDBIntField(row, "watchon");
    PlayerData[playerid][pGPSOn] = GetDBIntField(row, "gpson");
    PlayerData[playerid][pDoubleXP] = GetDBIntField(row, "doublexp");
    PlayerData[playerid][pDetectiveCooldown] = GetDBIntField(row, "detectivecooldown");
    PlayerData[playerid][pThiefCooldown] = GetDBIntField(row, "thiefcooldown");
    PlayerData[playerid][pCocaineCooldown] = GetDBIntField(row, "cocainecooldown");
    PlayerData[playerid][pGasCan] = GetDBIntField(row, "gascan");
    PlayerData[playerid][pDuty] = GetDBIntField(row, "duty");
    PlayerData[playerid][pBandana] = 0; //GetDBIntField(row, "bandana");
    PlayerData[playerid][pPassport] = GetDBIntField(row, "passport");
    PlayerData[playerid][pPassportLevel] = GetDBIntField(row, "passportlevel");
    PlayerData[playerid][pPassportSkin] = GetDBIntField(row, "passportskin");
    PlayerData[playerid][pPassportPhone] = GetDBIntField(row, "passportphone");
    PlayerData[playerid][pAdminHide] = GetDBIntField(row, "adminhide");
    PlayerData[playerid][pInsurance] = GetDBIntField(row, "insurance");
    PlayerData[playerid][pRope] = GetDBIntField(row, "rope");
    PlayerData[playerid][pTotalPatients] = GetDBIntField(row, "totalpatients");
    PlayerData[playerid][pTotalFires] = GetDBIntField(row, "totalfires");
    PasswordChanged[playerid] = GetDBIntField(row, "passwordchanged");
    PlayerData[playerid][pFirstAid] = GetDBIntField(row, "firstaid");
    PlayerData[playerid][pPoliceScanner] = GetDBIntField(row, "policescanner");
    PlayerData[playerid][pBodykits] = GetDBIntField(row, "bodykits");
    PlayerData[playerid][pScannerOn] = GetDBIntField(row, "scanneron");
    PlayerData[playerid][pBlindfold] = GetDBIntField(row, "blindfold");
    PlayerData[playerid][pBugged] = GetDBIntField(row, "bugged");
    GetDBStringField(row, "buggedby", PlayerData[playerid][pBuggedBy], MAX_PLAYER_NAME);
    PlayerData[playerid][pRareTime] = GetDBIntField(row, "rarecooldown");
    PlayerData[playerid][pDiamonds] = GetDBIntField(row, "diamonds");
    PlayerData[playerid][pSkates] = GetDBIntField(row, "rollerskates");
    PlayerData[playerid][pMarriedTo] = GetDBIntField(row, "marriedto");

    if (PlayerData[playerid][pMarriedTo] != -1)
    {
        DBFormat("SELECT username FROM "#TABLE_USERS" WHERE uid = %i", PlayerData[playerid][pMarriedTo]);
        DBExecute("OnUpdatePartner", "i", playerid);

    }
    else
    {
        strcpy(PlayerData[playerid][pMarriedName], "Nobody", MAX_PLAYER_NAME);
    }
    PlayerData[playerid][pLogged] = 1;
    PlayerData[playerid][pACTime] = gettime() + 5;

    if (IsPlayerConnected(playerid))
    {
        CallLocalFunction("OnLoadUser", "ii", playerid, 0); // row=0
    }

    if (!PlayerData[playerid][pAdminDuty])
    {
        ClearChat(playerid);
    }
    if (!PlayerData[playerid][pToggleTextdraws])
    {
        RefreshPlayerTextdraws(playerid);
    }

    if (GetDBIntField(0, "refercount") > 0)
    {
        new count = GetDBIntField(0, "refercount");
        SendClientMessageEx(playerid, COLOR_GREEN, "%i players who you've referred reached level 3. Therefore you received %i cookies!", count, count * 10);
        DBQuery("UPDATE "#TABLE_USERS" SET refercount = 0 WHERE uid = %i", PlayerData[playerid][pID]);
    }

    if (!PlayerData[playerid][pSetup])
    {
        if (!PlayerData[playerid][pAdminDuty] && !PlayerData[playerid][pToggleCam])
        {
            PlayerData[playerid][pLoginCamera] = 1;
        }
        else
        {
            PlayerData[playerid][pLoginCamera] = 0;
        }

        if (PlayerData[playerid][pShowTurfs])
        {
            ShowTurfsOnMap(playerid, true);
        }
        if (PlayerData[playerid][pShowLands])
        {
            ShowLandsOnMap(playerid, true);
        }

        if (!PlayerData[playerid][pAdminDuty] && playerid != OFFLINE_PLAYER_ID)
        {
            DBQuery("UPDATE "#TABLE_USERS" SET lastlogin = NOW(), ip = '%e' WHERE uid = %i", GetPlayerIP(playerid), PlayerData[playerid][pID]);


            DBFormat("SELECT id FROM flags WHERE uid = %i", PlayerData[playerid][pID]);
            DBExecute("CountFlags", "i", playerid);

            DBFormat("SELECT * FROM clothing WHERE uid = %i", PlayerData[playerid][pID]);
            DBExecute("LoadClothing", "i", playerid);

            if (!PlayerData[playerid][pTogglePhone])
            {
                DBFormat("SELECT COUNT(*) FROM texts WHERE recipient_number = %i", PlayerData[playerid][pPhone]);
                DBExecute("CountTexts", "i", playerid);
            }
        }

        foreach(new i: Vehicle)
        {
            if (IsVehicleOwner(playerid, i) && VehicleInfo[i][vTimer] >= 0)
            {
                KillTimer(VehicleInfo[i][vTimer]);
                VehicleInfo[i][vTimer] = -1;
            }
        }


        if (PlayerData[playerid][pAdminDuty])
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
            if (IsAdmin(playerid))
            {
                motd=GetAdminMOTD();
                if (!isnull(motd))
                {
                    SendClientMessageEx(playerid, 0xE65A5AAA, "Admin Motd: %s", motd);
                }
            }

            if (PlayerData[playerid][pHelper] > 0)
            {
                motd=GetHelperMOTD();
                if (!isnull(motd))
                {
                    SendClientMessageEx(playerid, COLOR_AQUA, "Helper Motd: %s", motd);
                }
            }

            if (PlayerData[playerid][pFaction] >= 0 && strcmp(FactionInfo[PlayerData[playerid][pFaction]][fMOTD], "None", true) != 0)
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "Faction Motd: %s", FactionInfo[PlayerData[playerid][pFaction]][fMOTD]);
            }

            if (PlayerData[playerid][pGang] >= 0 && strcmp(GangInfo[PlayerData[playerid][pGang]][gMOTD], "None", true) != 0)
            {
                SendClientMessageEx(playerid, COLOR_YELLOW, "Gang MOTD: %s", GangInfo[PlayerData[playerid][pGang]][gMOTD]);
            }

            motd=GetServerMOTD();
            if (!isnull(motd))
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "Global Motd: %s", motd);
            }

            format(string, sizeof(string), "~w~Welcome ~n~~y~   %s", GetPlayerNameEx(playerid));
            GameTextForPlayer(playerid, string, 5000, 1);

            /*if (IsAdmin(playerid) && !PlayerData[playerid][pAdminHide])
            {
                SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has logged in.", GetAdmCmdRank(playerid), GetRPName(playerid));
            }
            if (PlayerData[playerid][pGang] >= 0)
            {
                SendGangMessage(PlayerData[playerid][pGang], COLOR_AQUA, "(( %s %s has logged in. ))", GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]], GetRPName(playerid));
            }
            if (PlayerData[playerid][pFaction] >= 0)
            {
                SendFactionMessage(PlayerData[playerid][pFaction], COLOR_FACTIONCHAT, "(( %s %s has logged in. ))", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid));
            }

            if (IsAdmin(playerid))
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {FF6347}level %i %s{FFFFFF}.", GetServerName(), GetAdminLvl(playerid), GetAdminRank(playerid));
            }
            else if (PlayerData[playerid][pHelper] > 0)
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {33CCFF}%s{FFFFFF}.", GetServerName(), GetHelperRank(playerid));
            }
            else if (PlayerData[playerid][pDonator] > 0)
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {D909D9}%s VIP{FFFFFF}.", GetServerName(), GetVIPRank(PlayerData[playerid][pDonator]));
            }
            else if (PlayerData[playerid][pLevel] >= 2)
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {AFAFAF}level %i player{FFFFFF}.", GetServerName(), PlayerData[playerid][pLevel]);
            }
            else
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "%s: You have logged in as a {AFAFAF}level 1 newbie{FFFFFF}.", GetServerName());
            }

            SendClientMessageEx(playerid, COLOR_NAVYBLUE, "Your last login was on the %s (server time).", GetDateTime());
            */

            StopAudioStreamForPlayer(playerid);
        }

        if (PlayerData[playerid][pFaction] >= 0 && FactionInfo[PlayerData[playerid][pFaction]][fType] == FACTION_NONE)
        {
            SetPlayerFaction(playerid, -1);
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "You were either kicked from the faction while offline or it was deleted.");
        }
        if (PlayerData[playerid][pGang] >= 0 && !GangInfo[PlayerData[playerid][pGang]][gSetup])
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "You have either been kicked from the gang while offline or it was deleted.");
            PlayerData[playerid][pGang] = -1;
            PlayerData[playerid][pGangRank] = 0;

            DBQuery("UPDATE "#TABLE_USERS" SET gang = -1, gangrank = 0 WHERE uid = %i", PlayerData[playerid][pID]);

        }
        if (PasswordChanged[playerid] == 0)
        {
            Dialog_Show(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT,
                "Change password",
                "Please change your password for security purposes\nEnter your new password below:",
                "Submit", "Cancel");
        }

    }
    //SetPlayerToSpawn(playerid);
    DisplayDashboard(playerid);
    return 1;
}

DB:ProcessLogin(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        PlayerData[playerid][pLoginTries]++;

        DBFormat("UPDATE "#TABLE_USERS" SET login_nb_fails = login_nb_fails + 1, login_last_fail = NOW() WHERE username = '%e'", GetPlayerNameEx(playerid));
        DBExecute("OnLoginFailUpdated", "i", playerid);
    }
    else
    {
        DBQuery("UPDATE "#TABLE_USERS" SET login_nb_fails = 0 WHERE username = '%e'", GetPlayerNameEx(playerid));


        if (GetDBIntField(0, "locked"))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* This account is currently locked. Post an administrative request to have it lifted.");
            new string[128];
            format(string, sizeof(string), "%s tried to login with a locked account.", GetPlayerNameEx(playerid));
            KickPlayer(playerid, string);
        }
        else if (IsWhiteListEnabled() && !GetDBIntField(0, "whitelist"))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* This account is not whitelisted. Post an administrative request to have it lifted.");
            new string[128], regdate[32];
            GetDBStringField(0, "regdate", regdate, 32);
            format(string, sizeof(string), "Account '%s' not whitelisted.", FormatSerialNumber(GetDBIntField(0, "uid"), regdate));
            KickPlayer(playerid, string, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
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

DB:ReferralCheck(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "The player specified doesn't exist.");
        ShowRegisterReferralDlg(playerid);
    }
    else
    {
        new username[MAX_PLAYER_NAME], ip[16];

        GetDBStringField(0, "username", username);
        GetDBStringField(0, "ip", ip);

        if (!strcmp(GetPlayerIP(playerid), ip))
        {
            SendClientMessage(playerid, COLOR_GREY, "This account is listed under your own IP address. You can't refer yourself.");
            ShowRegisterReferralDlg(playerid);
        }
        else
        {

            DBQuery("UPDATE "#TABLE_USERS" SET referral_uid = %i WHERE uid = %i", GetDBIntField(0, "uid"), PlayerData[playerid][pID]);


            PlayerData[playerid][pSetup] = 0;

            SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);

            SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
            SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);
            SetPlayerVirtualWorld(playerid, 0);
            SetCameraBehindPlayer(playerid);
            StopAudioStreamForPlayer(playerid);
            TogglePlayerControllableEx(playerid, 1);
            RevivePlayer(playerid);

            DBQuery("UPDATE "#TABLE_USERS" SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i", _:PlayerData[playerid][pGender], PlayerData[playerid][pAge], PlayerData[playerid][pSkin], PlayerData[playerid][pID]);


            PlayerData[playerid][pReferralUID] = GetDBIntField(0, "uid");
            SendClientMessageEx(playerid, COLOR_YELLOW, "You have chosen %s as your referral. This player will be rewarded once you reach level 3.", username);
            //SendClientMessage(playerid, COLOR_YELLOW, "That's all the information we need right now. The tutorial will start in just a moment.");

            CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
        }
    }

}

hook OnPlayerFirstTimeSpawn(playerid)
{
    StopAudioStreamForPlayer(playerid);
    if (!IsWhiteListEnabled() || PlayerData[playerid][pWhitelist])
    {
        SendStaffMessage(COLOR_YELLOW, "OnPlayerSpawn: %s[%d] has just spawned on %s for the first time!", GetRPName(playerid), playerid, GetServerName());

        DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
        fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;

        SendClientMessageEx(playerid, COLOR_WHITE, "Welcome to {00aa00}%s{FFFFFF}. Make sure to visit our %s for news and updates.", GetServerWebsite());
        SendClientMessage(playerid, COLOR_WHITE, "Use the {FFFF90}/locate{FFFFFF} command to point to locations of jobs, businesses, and common places.");

        SendClientMessage(playerid, COLOR_AQUA, "You need a driver's license, the DMV has been marked on your map. Navigate to the marker to begin your drivers test.");
        SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1219.2590, -1812.1093, 16.5938, 3.0);

        AwardAchievement(playerid, ACH_AtTheEnd);
        Dialog_Show(playerid, OnSpawnRequestHelper, DIALOG_STYLE_MSGBOX, "Helper request", "Did you need a helper?\n He can explain the rules, show you the city\n and help you to find your first job!", "Yes", "No");
    }
    else
    {
        SavePlayerVariables(playerid);
        SendClientMessageEx(playerid, COLOR_WHITE, "Welcome to {00aa00}%s{FFFFFF}.", GetServerWebsite());
        SendClientMessageEx(playerid, COLOR_GREEN, "You need to request a whitelist for your account in our discord.");
        SendClientMessageEx(playerid, COLOR_GREEN, "Take a screenshot then create a ticket in our discord and join it.");
        SendClientMessageEx(playerid, COLOR_WHITE, "Serial number: %s | Username: %s | Time: %s", GetPlayerSerialNumber(playerid), GetPlayerNameEx(playerid), GetDateTime());
        new string[128];
        format(string, sizeof(string), "Account '%s' not whitelisted.", GetPlayerSerialNumber(playerid));
        KickPlayer(playerid, string, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
    }
    return 1;
}

Dialog:OnSpawnRequestHelper(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        return callcmd::helpme(playerid, "Player has just spawned and need help");
    }
    return 1;
}

DB:ReferrerReward(playerid)
{
    new rows = GetDBNumRows();

    if (rows)
    {
        new username[MAX_PLAYER_NAME], ip[16], referralid = INVALID_PLAYER_ID;

        GetDBStringField(0, "username", username);
        GetDBStringField(0, "ip", ip);

        // Add a log entry for this referral.
        DBLog("log_referrals", "%s (uid: %i) (IP: %s) has received 10 cookies for referring %s (uid: %i) (IP: %s).", username, PlayerData[playerid][pReferralUID], ip, GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerIP(playerid));

        // Check to see if any of the players online match the player's referral UID.
        foreach(new i : Player)
        {
            if (i != playerid && PlayerData[i][pLogged] && PlayerData[i][pID] == PlayerData[playerid][pReferralUID])
            {
                referralid = i;
                break;
            }
        }

        // Referrer is online.
        if (referralid != INVALID_PLAYER_ID && strcmp(GetPlayerIP(referralid), GetPlayerIP(playerid)) != 0)
        {
            GivePlayerCookies(referralid, 10);

            SendClientMessage(referralid, COLOR_GREEN, "A player who you've referred reached level 3. Therefore you received 10 cookies!");
            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s (IP: %s) earned 10 cookies for referring %s (IP: %s).", GetRPName(referralid), GetPlayerIP(referralid), GetRPName(playerid), GetPlayerIP(playerid));
        }
        else
        {
            // Referrer is offline. Let's give them their cookies and increment refercount which sends them an alert on login!
            DBQuery("UPDATE "#TABLE_USERS" SET cookies = cookies + 10, refercount = refercount + 1 WHERE uid = %i AND ip != '%e'", PlayerData[playerid][pReferralUID], GetPlayerIP(playerid));

        }

        // Finally, remove the player's link to the referrer as the prize has been given.
        DBQuery("UPDATE "#TABLE_USERS" SET referral_uid = 0 WHERE uid = %i", PlayerData[playerid][pID]);

    }
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (isnull(inputtext))
        {
            ShowRegisterDlg(playerid);
            return 1;
        }
        new length = strlen(inputtext);
        if (length < 4 || length > 128)
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* Please choose a password containing at between 4 and 128 characters.");
            ShowRegisterDlg(playerid);
            return 1;
        }
        if (IsCommonPassword(inputtext))
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "* This a very common password please choose another one.");
            ShowRegisterDlg(playerid);
            return 1;
        }

        WP_Hash(RegisterHashedPassword[playerid], 129, inputtext);
        Dialog_Show(playerid, DIALOG_CONFIRMPASS, DIALOG_STYLE_PASSWORD,
            "Confirm password",
            "Please repeat your account password for verification:",
            "Submit", "Back");
    }
    else
    {
        KickPlayer(playerid, "Failed to register", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
    }
    return 1;
}

AddPlayerToDatabase(playerid, const hashedPassword[])
{
    IncreaseTotalRegistered();
    DBFormat("INSERT INTO "#TABLE_USERS" "\
        " (username, password, regdate, lastlogin, ip, passwordchanged, gender, age)"\
        " VALUES('%e', '%e', NOW(), NOW(), '%e', 1, %d, %d)",
        GetPlayerNameEx(playerid),
        hashedPassword,
        GetPlayerIP(playerid),
        _:PlayerData[playerid][pGender],
        PlayerData[playerid][pAge]);
    DBExecute("RegisterAccount", "i", playerid);
}

Dialog:DIALOG_CONFIRMPASS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new
            password[129];

        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, DIALOG_CONFIRMPASS, DIALOG_STYLE_PASSWORD,
                        "Confirm password",
                        "Please repeat your account password for verification:",
                        "Submit", "Back");
        }

        WP_Hash(password, sizeof(password), inputtext);

        if (!strcmp(RegisterHashedPassword[playerid], password))
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
    if (!response)
    {
        ShowLoginDlg(playerid);
    }
    if (response)
    {
        new specifiers[] = "%D of %M, %Y @ %k:%i";
        new password[129];

        if (isnull(inputtext))
        {
            ShowLoginDlg(playerid);
            return 1;
        }

        WP_Hash(password, sizeof(password), inputtext);

        DBFormat("SELECT *, DATE_FORMAT(lastlogin, '%e') AS login_date FROM "#TABLE_USERS" WHERE username = '%e' AND password = '%e' and (login_nb_fails < 5  or TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) > 5)", specifiers, GetPlayerNameEx(playerid), password);
        DBExecute("ProcessLogin", "i", playerid);

    }
    else
    {
        KickPlayer(playerid, "Failed to login", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
    }
    return 1;
}
DB:OnLoginFailUpdated(playerid)
{
    DBFormat("SELECT uid, login_nb_fails, TIMESTAMPDIFF(MINUTE, login_last_fail, NOW()) as login_diff_min FROM "#TABLE_USERS" WHERE username = '%e'", GetPlayerNameEx(playerid));
    DBExecute("CheckLoginSpam", "i", playerid);

    return 1;
}
DB:CheckLoginSpam(playerid)
{

    if (GetDBIntField(0, "login_nb_fails") >= 5 &&
        GetDBIntField(0, "login_diff_min") < 5)
    {
        KickPlayer(playerid, "Fail to login. Your account is locked try to login after 5min.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
    }
    else if (PlayerData[playerid][pLoginTries] < 3)
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

    if (response)
    {
        PlayerData[playerid][pGender] = PlayerGender_Male;
        PlayerData[playerid][pSkin] = 299;
    }
    else
    {
        PlayerData[playerid][pGender] = PlayerGender_Female;
        PlayerData[playerid][pSkin] = 69;
    }

    SendClientMessageEx(playerid, COLOR_YELLOW,
        "Your character is a %s. Now you need to choose the age of your character.",
        GetPlayerGenderStr(playerid));
    ShowRegisterAgeDlg(playerid);

    return 1;
}

Dialog:DIALOG_AGE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new age = strval(inputtext);

        if (!(MIN_PLAYER_AGE <= age <= MAX_PLAYER_AGE))
        {
            ShowRegisterAgeDlg(playerid);
            SendClientMessageEx(playerid, COLOR_GREY, "You may only enter a number from %i to %i. Please try again.", MIN_PLAYER_AGE, MAX_PLAYER_AGE);
            return 1;
        }
        PlayerData[playerid][pAge] = age;
        PlayerData[playerid][pReferralUID] = 0;
        AddPlayerToDatabase(playerid, RegisterHashedPassword[playerid]);
    }
    else
    {
        ShowRegisterAgeDlg(playerid);
    }
    return 1;
}

Dialog:DIALOG_REFERRAL(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (isnull(inputtext) || strlen(inputtext) > 24)
        {
            return ShowRegisterReferralDlg(playerid);
        }
        if (!strcmp(inputtext, GetPlayerNameEx(playerid)))
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't put down your own name as a referral.");
            return ShowRegisterReferralDlg(playerid);
        }

        DBFormat("SELECT username, ip, uid FROM "#TABLE_USERS" WHERE username = '%e'", inputtext);
        DBExecute("ReferralCheck", "i", playerid);

    }
    return 1;
}

Dialog:ACCOUNT_CREATION(playerid, response, listitem, inputtext[])
{
    if (!response) return ShowAccountCreationDlg(playerid);
    switch (listitem)
    {
        case 0: return ShowAccountCreationDlg(playerid);
        case 1: return ShowRegisterGenderDlg(playerid);
        case 2: return ShowRegisterAgeDlg(playerid);
        case 3:
        {
            return Dialog_Show(playerid, RegisterAccent, DIALOG_STYLE_LIST, "Accent", getAccentList(), "Select", "<<");
        }

        case 4:
        {
            if (PlayerData[playerid][pGender] == PlayerGender_Unspecified)
            {
                SendClientMessage(playerid, COLOR_YELLOW, "Please pick a gender.");
                return ShowAccountCreationDlg(playerid);
            }
            if (PlayerData[playerid][pAge] == 0)
            {
                SendClientMessage(playerid, COLOR_GREY, "You must choose a age to complete");
                return ShowAccountCreationDlg(playerid);
            }

            PlayerData[playerid][pSetup] = 0;

            SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
            SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
            SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);
            RevivePlayer(playerid);

            SetPlayerVirtualWorld(playerid, 0);
            SetCameraBehindPlayer(playerid);
            StopAudioStreamForPlayer(playerid);
            TogglePlayerControllableEx(playerid, 1);

            DBQuery("UPDATE "#TABLE_USERS" SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i",
                _:PlayerData[playerid][pGender],
                PlayerData[playerid][pAge],
                PlayerData[playerid][pSkin],
                PlayerData[playerid][pID]);

            CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
            return 1;
        }
    }
    return 1;
}

Dialog:RegisterAccent(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        PlayerData[playerid][pAccent] = getAccentName(listitem);
    }
    return ShowAccountCreationDlg(playerid);
}

ClearChatbox(playerid)
{
    for (new i = 0; i < 50; i++)
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
    if (response || !response)
    {
        if (!IsPlayerInTutorial(playerid))
        {
            return 1;
        }

        switch (TutStep[playerid])
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
                if (PlayerData[playerid][pSetup])
                {
                    PlayerData[playerid][pSetup] = 0;
                    DBQuery("UPDATE "#TABLE_USERS" SET setup = 0 WHERE uid = %i", PlayerData[playerid][pID]);


                    CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
                }
                else
                {
                    //He was forced by admin
                    StopAudioStreamForPlayer(playerid);
                    DestroyDynamic3DTextLabel(fRepfamtext[playerid]);
                    fRepfamtext[playerid] = Text3D:INVALID_3DTEXT_ID;
                    SetActiveCheckpoint(playerid, CHECKPOINT_MISC, 1219.2590, -1812.1093, 16.5938, 3.0);
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

publish ShowRandomCamera(playerid)
{
    if (PlayerData[playerid][pLogged] == 0)
    {
        switch (random(2))
        {
            case 0:
            {
                InterpolateCameraPos(playerid, 1534.284423, -1312.871093, 513.042114, 1561.539794, -1314.386108, 16.426090, 25000);
                InterpolateCameraLookAt(playerid, 1534.702758, -1312.993041, 508.061126, 1558.089111, -1313.615966, 19.961624, 10000);
            }
            case 1:
            {
                InterpolateCameraPos(playerid, 1402.380126, -1216.866333, 350.959869, 1660.696655, -1303.045410, 74.042839, 7000);
                InterpolateCameraLookAt(playerid, 1404.336425, -1219.865234, 347.469909, 1657.485961, -1304.525756, 77.578369, 7000);
            }
        }
    }
}

publish ShowMainMenuCamera(playerid)
{
    PlayLoginMusic(playerid);
    ClearChat(playerid);

    ShowRandomCamera(playerid);
    DBFormat("SELECT * FROM "#TABLE_BANS" WHERE (username = '%e') and (isbanned = true) order by id DESC limit 1;", GetPlayerNameEx(playerid));
    DBExecute("BanLookup", "i", playerid);
}


PlayerLogin(playerid)
{
    if (PlayerData[playerid][pLogged] || PlayerData[playerid][pKicked])
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
publish TutorialTimer(playerid, stage)
{
    //new string[2048];
    if (PlayerData[playerid][pLogged] && IsPlayerInTutorial(playerid))
    {

        switch (stage)
        {
            case 11:
            {
                PlayerData[playerid][pSetup] = 0;
                SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
                SetPlayerPos(playerid, NewbSpawnPos[0], NewbSpawnPos[1], NewbSpawnPos[2]);
                SetPlayerFacingAngle(playerid, NewbSpawnPos[3]);
                RevivePlayer(playerid);

                SetPlayerVirtualWorld(playerid, 0);
                SetCameraBehindPlayer(playerid);
                StopAudioStreamForPlayer(playerid);
                TogglePlayerControllableEx(playerid, 1);
                DBQuery("UPDATE "#TABLE_USERS" SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i",
                    _:PlayerData[playerid][pGender],
                    PlayerData[playerid][pAge],
                    PlayerData[playerid][pSkin],
                    PlayerData[playerid][pID]);

                CallRemoteFunction("OnPlayerFirstTimeSpawn", "d", playerid);
            }
        }
    }
}


CMD:skiptut(playerid, params[])
{
    new targetid;

    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /skiptut [playerid]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsPlayerInTutorial(targetid))
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
    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /forcetut [playerid]");
    }
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has forced %s to watch the server tutorial", GetRPName(playerid), GetRPName(targetid));
    SendClientMessageEx(targetid, COLOR_LIGHTRED, "Administrator %s has forced you to rewatch the server tutorial.", GetRPName(playerid));

    StartTutorial(targetid);
    return 1;
}

ShowMainMenuGUI(playerid)
{
    new string[22];
    format(string, sizeof(string), "Players online: %d", Iter_Count(Player));
    TextDrawSetString(MainMenuTextDraw[11], string);
    TextDrawSetString(MainMenuTextDraw[8], GetServerMOTD());

    for (new i = 0; i < 14; i++)
    {
        TextDrawShowForPlayer(playerid, MainMenuTextDraw[i]);
    }

    TextDrawShowForPlayer(playerid, WelcomeTextDraw);
    return 1;
}

HideMainMenuGUI(playerid)
{
    for (new i = 0; i < 14; i++)
    {
        TextDrawHideForPlayer(playerid, MainMenuTextDraw[i]);
    }

    TextDrawHideForPlayer(playerid, WelcomeTextDraw);
    return 1;
}

InitLoginGUI()
{
    // NEW MainMenuTextDraw
    MainMenuTextDraw[0] = TextDrawCreate(641.531494, 40.000000, "usebox");
    TextDrawLetterSize(MainMenuTextDraw[0], 0.000000, 11.544445);
    TextDrawTextSize(MainMenuTextDraw[0], -2.000000, 0.000000);
    TextDrawAlignment(MainMenuTextDraw[0], 1);
    TextDrawColor(MainMenuTextDraw[0], 0);
    TextDrawUseBox(MainMenuTextDraw[0], true);
    TextDrawBoxColor(MainMenuTextDraw[0], 102);
    TextDrawSetShadow(MainMenuTextDraw[0], 0);
    TextDrawSetOutline(MainMenuTextDraw[0], 0);
    TextDrawFont(MainMenuTextDraw[0], 0);

    MainMenuTextDraw[1] = TextDrawCreate(660.272338, 47.000000, "usebox");
    TextDrawLetterSize(MainMenuTextDraw[1], 0.041698, -0.919443);
    TextDrawTextSize(MainMenuTextDraw[1], -2.000000, 0.000000);
    TextDrawAlignment(MainMenuTextDraw[1], 1);
    TextDrawColor(MainMenuTextDraw[1], 0);
    TextDrawUseBox(MainMenuTextDraw[1], true);
    TextDrawBoxColor(MainMenuTextDraw[1], 102);
    TextDrawSetShadow(MainMenuTextDraw[1], 0);
    TextDrawSetOutline(MainMenuTextDraw[1], 0);
    TextDrawFont(MainMenuTextDraw[1], 0);

    MainMenuTextDraw[2] = TextDrawCreate(641.531494, 139.166656, "usebox");
    TextDrawLetterSize(MainMenuTextDraw[2], 0.000000, -0.057406);
    TextDrawTextSize(MainMenuTextDraw[2], -2.000000, 0.000000);
    TextDrawAlignment(MainMenuTextDraw[2], 1);
    TextDrawColor(MainMenuTextDraw[2], 0);
    TextDrawUseBox(MainMenuTextDraw[2], true);
    TextDrawBoxColor(MainMenuTextDraw[2], 102);
    TextDrawSetShadow(MainMenuTextDraw[2], 0);
    TextDrawSetOutline(MainMenuTextDraw[2], 0);
    TextDrawFont(MainMenuTextDraw[2], 0);

    MainMenuTextDraw[3] = TextDrawCreate(249.252960, 62.416679, "Arabica Roleplay");
    TextDrawLetterSize(MainMenuTextDraw[3], 0.578843, 3.670834);
    TextDrawAlignment(MainMenuTextDraw[3], 1);
    TextDrawColor(MainMenuTextDraw[3], -5963521);
    TextDrawSetShadow(MainMenuTextDraw[3], 0);
    TextDrawSetOutline(MainMenuTextDraw[3], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[3], 51);
    TextDrawFont(MainMenuTextDraw[3], 3);
    TextDrawSetProportional(MainMenuTextDraw[3], 1);

    MainMenuTextDraw[4] = TextDrawCreate(278.301361, 95.083305, SERVER_REVISION);
    TextDrawLetterSize(MainMenuTextDraw[4], 0.407833, 2.824997);
    TextDrawTextSize(MainMenuTextDraw[4], 203.806701, 93.333343);
    TextDrawAlignment(MainMenuTextDraw[4], 1);
    TextDrawColor(MainMenuTextDraw[4], -1);
    //TextDrawUseBox(MainMenuTextDraw[4], true);
    TextDrawBoxColor(MainMenuTextDraw[4], 0);
    TextDrawSetShadow(MainMenuTextDraw[4], 0);
    TextDrawSetOutline(MainMenuTextDraw[4], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[4], 51);
    TextDrawFont(MainMenuTextDraw[4], 2);
    TextDrawSetProportional(MainMenuTextDraw[4], 1);

    MainMenuTextDraw[5] = TextDrawCreate(641.531494, 297.833312, "usebox");
    TextDrawLetterSize(MainMenuTextDraw[5], 0.000000, 16.470375);
    TextDrawTextSize(MainMenuTextDraw[5], -2.000000, 0.000000);
    TextDrawAlignment(MainMenuTextDraw[5], 1);
    TextDrawColor(MainMenuTextDraw[5], 0);
    TextDrawUseBox(MainMenuTextDraw[5], true);
    TextDrawBoxColor(MainMenuTextDraw[5], 102);
    TextDrawSetShadow(MainMenuTextDraw[5], 0);
    TextDrawSetOutline(MainMenuTextDraw[5], 0);
    TextDrawFont(MainMenuTextDraw[5], 0);

    MainMenuTextDraw[6] = TextDrawCreate(641.531494, 306.000000, "usebox");
    TextDrawLetterSize(MainMenuTextDraw[6], 0.003746, -0.232409);
    TextDrawTextSize(MainMenuTextDraw[6], -2.000000, 0.000000);
    TextDrawAlignment(MainMenuTextDraw[6], 1);
    TextDrawColor(MainMenuTextDraw[6], 0);
    TextDrawUseBox(MainMenuTextDraw[6], true);
    TextDrawBoxColor(MainMenuTextDraw[6], 102);
    TextDrawSetShadow(MainMenuTextDraw[6], 0);
    TextDrawSetOutline(MainMenuTextDraw[6], 0);
    TextDrawFont(MainMenuTextDraw[6], 0);

    MainMenuTextDraw[7] = TextDrawCreate(28.579757, 326.083343, "News:");
    TextDrawLetterSize(MainMenuTextDraw[7], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[7], 1);
    TextDrawColor(MainMenuTextDraw[7], -5963521);
    TextDrawSetShadow(MainMenuTextDraw[7], 0);
    TextDrawSetOutline(MainMenuTextDraw[7], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[7], 51);
    TextDrawFont(MainMenuTextDraw[7], 1);
    TextDrawSetProportional(MainMenuTextDraw[7], 1);

    MainMenuTextDraw[8] = TextDrawCreate(81.285598, 326.083374, "ServerMOTD");
    TextDrawLetterSize(MainMenuTextDraw[8], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[8], 1);
    TextDrawColor(MainMenuTextDraw[8], -1);
    TextDrawSetShadow(MainMenuTextDraw[8], 0);
    TextDrawSetOutline(MainMenuTextDraw[8], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[8], 51);
    TextDrawFont(MainMenuTextDraw[8], 1);
    TextDrawSetProportional(MainMenuTextDraw[8], 1);

    MainMenuTextDraw[9] = TextDrawCreate(73.557861, 393.166656, "Website:");
    TextDrawLetterSize(MainMenuTextDraw[9], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[9], 1);
    TextDrawColor(MainMenuTextDraw[9], -5963521);
    TextDrawSetShadow(MainMenuTextDraw[9], 0);
    TextDrawSetOutline(MainMenuTextDraw[9], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[9], 51);
    TextDrawFont(MainMenuTextDraw[9], 1);
    TextDrawSetProportional(MainMenuTextDraw[9], 1);

    MainMenuTextDraw[10] = TextDrawCreate(143.367507, 394.333343, GetServerWebsite());
    TextDrawLetterSize(MainMenuTextDraw[10], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[10], 1);
    TextDrawColor(MainMenuTextDraw[10], -1);
    TextDrawSetShadow(MainMenuTextDraw[10], 0);
    TextDrawSetOutline(MainMenuTextDraw[10], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[10], 51);
    TextDrawFont(MainMenuTextDraw[10], 1);
    TextDrawSetProportional(MainMenuTextDraw[10], 1);

    MainMenuTextDraw[11] = TextDrawCreate(235.666152, 359.333374, "Players Online:");
    TextDrawLetterSize(MainMenuTextDraw[11], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[11], 1);
    TextDrawColor(MainMenuTextDraw[11], -5963521);
    TextDrawSetShadow(MainMenuTextDraw[11], 0);
    TextDrawSetOutline(MainMenuTextDraw[11], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[11], 51);
    TextDrawFont(MainMenuTextDraw[11], 1);
    TextDrawSetProportional(MainMenuTextDraw[11], 1);

    MainMenuTextDraw[12] = TextDrawCreate(345.300231, 393.749969, "Discord:");
    TextDrawLetterSize(MainMenuTextDraw[12], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[12], 1);
    TextDrawColor(MainMenuTextDraw[12], -5963521);
    TextDrawSetShadow(MainMenuTextDraw[12], 0);
    TextDrawSetOutline(MainMenuTextDraw[12], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[12], 51);
    TextDrawFont(MainMenuTextDraw[12], 1);
    TextDrawSetProportional(MainMenuTextDraw[12], 1);

    MainMenuTextDraw[13] = TextDrawCreate(414.172668, 394.333374, GetServerDiscord());
    TextDrawLetterSize(MainMenuTextDraw[13], 0.449999, 1.600000);
    TextDrawAlignment(MainMenuTextDraw[13], 1);
    TextDrawColor(MainMenuTextDraw[13], -1);
    TextDrawSetShadow(MainMenuTextDraw[13], 0);
    TextDrawSetOutline(MainMenuTextDraw[13], 1);
    TextDrawBackgroundColor(MainMenuTextDraw[13], 51);
    TextDrawFont(MainMenuTextDraw[13], 1);
    TextDrawSetProportional(MainMenuTextDraw[13], 1);

    new welcomeMsg[128];
    format(welcomeMsg, sizeof(welcomeMsg), "Welcome to ~g~%s~w~!", GetServerName());
    WelcomeTextDraw = TextDrawCreate(327.496246, 153.999984, welcomeMsg);
    TextDrawLetterSize(WelcomeTextDraw, 0.449999, 1.600000);
    TextDrawAlignment(WelcomeTextDraw, 2);
    TextDrawColor(WelcomeTextDraw, -1);
    TextDrawSetShadow(WelcomeTextDraw, 0);
    TextDrawSetOutline(WelcomeTextDraw, 1);
    TextDrawBackgroundColor(WelcomeTextDraw, 255);
    TextDrawFont(WelcomeTextDraw, 3);
    TextDrawSetProportional(WelcomeTextDraw, 1);
}

hook OnPlayerRequestClass(playerid, classid)
{
    if (PlayerData[playerid][pKicked]) return 0;
    SetPlayerToSpawn(playerid);
    return 1;
}

publish IntroKick(playerid)
{
    if (IsPlayerConnected(playerid) && !PlayerData[playerid][pLogged] && !IsPlayerLoggedIn(playerid))
    {
        KickPlayer(playerid, "Login timeout", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
    }
}

stock IsCommonPassword(const password[])
{
    static Top2023Passwords[][15] = {
        "password", "123456", "123456789", "guest", "qwerty", "12345678", "111111", "12345", "col123456",
        "123123", "1234567", "1234", "1234567890", "000000", "555555", "666666", "123321", "654321",
        "7777777", "123", "D1lakiss", "777777", "110110jp", "1111", "987654321", "121212", "Gizli",
        "abc123", "112233", "azerty", "159753", "1q2w3e4r", "54321", "pass@123", "222222", "qwertyuiop",
        "qwerty123", "qazwsx", "vip", "asdasd", "123qwe", "123654", "iloveyou", "a1b2c3", "999999",
        "Groupd2013", "1q2w3e", "usr", "Liman1000", "1111111", "333333", "123123123", "9136668099",
        "11111111", "1qaz2wsx", "password1", "mar20lt", "987654321", "gfhjkm", "159357", "abcd1234",
        "131313", "789456", "luzit2000", "aaaaaa", "zxcvbnm", "asdfghjkl", "1234qwer", "88888888", "dragon",
        "987654", "888888", "qwe123", "football", "3601", "asdfgh", "master", "samsung", "12345678910",
        "killer", "1237895", "1234561", "12344321", "daniel", "000000", "444444", "101010", "fuckyou",
        "qazwsxedc", "789456123", "super123", "qwer1234", "123456789a", "823477aA", "147258369", "unknown",
        "98765", "q1w2e3r4", "232323", "102030", "12341234", "147258", "shadow", "123456a", "87654321",
        "10203", "pokemon", "princess", "azertyuiop", "thomas", "baseball", "monkey", "jordan", "michael",
        "love", "1111111111", "11223344", "123456789", "asdf1234", "147852", "252525", "11111", "loulou",
        "111222", "superman", "qweasdzxc", "soccer", "qqqqqq", "123abc", "computer", "qweasd", "zxcvbn",
        "sunshine", "1234554321", "asd123", "marina", "lol123", "a123456", "Password", "123789", "jordan23",
        "jessica", "212121", "7654321", "googledummy", "qwerty1", "123654789", "naruto", "Indya123",
        "internet", "doudou", "anmol123", "55555", "andrea", "anthony", "martin", "basketball", "nicole",
        "xxxxxx", "1qazxsw2", "charlie", "12345qwert", "zzzzzz", "q1w2e3", "147852369", "hello", "welcome",
        "marseille", "456123", "secret", "matrix", "zaq12wsx", "password123", "qwertyu", "hunter", "freedom",
        "999999999", "eminem", "junior", "696969", "andrew", "michelle", "wow12345", "juventus", "batman",
        "justin", "12qwaszx", "Pass@123", "passw0rd", "soleil", "nikita", "Password1", "qweqwe", "nicolas",
        "robert", "starwars", "liverpool", "5555555", "bonjour", "test"
    };

    for (new i = 0; i < sizeof(Top2023Passwords); i++)
    {
        if (!strcmp(Top2023Passwords[i], password, true))
        {
            return true;
        }
    }
    return false;
}
