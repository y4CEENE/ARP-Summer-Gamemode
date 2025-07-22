///////////////////////////////////////////////////////////
/////////////////      Fight Club         /////////////////
///////////////////////////////////////////////////////////
//  Author: Khalil Zoldyck            2025-06-18         //
//                         (khalilcheher680@gmail.com)   //
//=======================================================//
//  Mapping: ChristianDodge                              //
///////////////////////////////////////////////////////////

//#if !defined MAIN_INIT
//    #error "Compiling from wrong script. (main.pwn)"
//#endif

#include <YSI\y_hooks>

/*----------: Defines :----------*/
#define FIGHT_CLUB_EVENT_TOKEN       0x153BC482
#define FIGHT_CLUB_INTERIOR_ID       15
#define FIGHT_CLUB_VIRTUAL_WORLD_ID  18

enum fightClubStateEnum
{
    STATE_FC_IDLE,
    STATE_FC_WAITING_FOR_PLAYERS,
    STATE_FC_FIGHTING,
};

enum fightInputEnum
{
    FC_INPUT_NUMBER_OF_FIGHTERS=0,
    FC_INPUT_PASSWORD,
    FC_INPUT_ENTRY_FEE,
    FC_INPUT_DURATION,
    FC_INPUT_HEALTH,
    FC_INPUT_ARMOR,
};

static Float:gfc_checkinPosition[3] = {427.1494, -1428.6058, 47.1388};
static Float:gfc_fightCoords[4][4] = {
    {437.9762,-1415.5065,47.1388, 070.0},      // Position 1
    {427.9632,-1411.8553,47.1388, 250.0},      // Position 2
    {432.8324,-1418.7694,47.1388, 353.0},      // Position 3
    {432.4088,-1408.5140,47.1388, 180.0}       // Position 4
};
static gfc_messages[][] = {
    "Enter the number of fighters that will partake in the fight (2-4 fighters total).",
    "Enter password",
    "Enter the entry fee to join this fight (from $5,000 to $500,000).",
    "Enter the duration you would like the fight to last for (from one minute to five minutes total).",
    "Enter the health each participant should have during the fight (from 1 to 100 health total).",
    "Enter the armor each participant should have during the fight (from 0 to 100 armor total)."
};

/*----------: Variables :----------*/

static gfc_players_id[4];
static gfc_config_fightersInField;
static gfc_config_nbOfFighters;
static gfc_config_password[25];
static gfc_config_entryFee;
static gfc_config_duration;
static gfc_config_health;
static gfc_config_armor;

static fightClubStateEnum:gfc_state_machine;
static gfc_state_totalMoney;
static gfc_state_joinTimer;
static gfc_state_durationTimer;
static gfc_state_ticks;

static gfc_player_numberOfFighters          [MAX_PLAYERS];
static gfc_player_password                  [MAX_PLAYERS][25];
static gfc_player_entryFee                  [MAX_PLAYERS];
static gfc_player_duration                  [MAX_PLAYERS];
static gfc_player_health                    [MAX_PLAYERS];
static gfc_player_armor                     [MAX_PLAYERS];
static gfc_player_selectedField             [MAX_PLAYERS];
static PlayerText:gfc_player_clockTextDraw  [MAX_PLAYERS];

/*----------: Functions :----------*/

IsPlayerInFight(playerid)
{
    for(new i=0;i<4;i++)
    {
        if(gfc_players_id[i] == playerid)
        {
            return true;
        }
    }
    return false;
}

GetFightWinner()
{
    for(new i=0;i<4;i++)
    {
        if(gfc_players_id[i] != -1)
        {
            return gfc_players_id[i];
        }
    }
    return -1;
}

AddPlayerToFight(playerid)
{
    if(IsPlayerInFight(playerid))
    {
        SendClientMessage(playerid, COLOR_GREY, "You already joined this fight!"); 
        return false;
    }
    if(gfc_state_machine != STATE_FC_WAITING_FOR_PLAYERS)
    {
        SendClientMessage(playerid, COLOR_GREY, "You cannot join fight at the moment!");
        return false;
    }
    if(gfc_config_fightersInField == gfc_config_nbOfFighters)
    {
        SendClientMessage(playerid, COLOR_GREY, "Stage is already fully!");
        return false;
    }
    if(PlayerData[playerid][pCash] < gfc_config_entryFee)
    {
        SendClientMessage(playerid, COLOR_GREY, "You don't have cash for this fight!"); 
        return false;
    }
    
    for(new i=0;i<4;i++)
    {
        if(gfc_players_id[i] == -1)
        {
            //Save player variables
            SavePlayerVariables(playerid);

            SetPVarInt(playerid, "EventToken", FIGHT_CLUB_EVENT_TOKEN);
            gfc_players_id[i] = playerid;
            gfc_config_fightersInField++;

            GivePlayerCash(playerid, - gfc_config_entryFee);
            gfc_state_totalMoney += gfc_config_entryFee;
            
            //Ensure guns removed
            ResetPlayerWeapons(playerid);
            SetPlayerHealth(playerid, gfc_config_health);
	        SetPlayerArmour(playerid, gfc_config_armor);
            TogglePlayerControllable(playerid, false);
            
            //spawn player in field            
            TeleportToCoords(playerid,
                            gfc_fightCoords[gfc_config_fightersInField][0], 
                            gfc_fightCoords[gfc_config_fightersInField][1], 
                            gfc_fightCoords[gfc_config_fightersInField][2], 
                            gfc_fightCoords[gfc_config_fightersInField][3], 
                            FIGHT_CLUB_INTERIOR_ID,
                            FIGHT_CLUB_VIRTUAL_WORLD_ID);
            
            if(gfc_config_fightersInField == gfc_config_nbOfFighters)
            {
                //Fight supposed to start now!
                KillTimer(gfc_state_joinTimer);
                SetTimerEx("FC_CountDown", 1000, false, "i", 3);
            }
            else
            {
                SendClientMessage(playerid, COLOR_AQUA, "Waiting fighters . . .");
            }

            return true;
        }
    }
    
    SendClientMessage(playerid, COLOR_GREY, "[FC] Cannot find a slot to spawn!"); 
    return false;
}

KickPlayerFromFight(playerid, refund=false)
{
    for(new i=0;i<4;i++)
    {
        if(gfc_players_id[i] == playerid)
        {
            gfc_players_id[i] = -1;
            gfc_config_fightersInField--;
            //restore player variables
            PlayerTextDrawHide(playerid,gfc_player_clockTextDraw[playerid]);
            TogglePlayerControllable(playerid, true);
            DeletePVar(playerid, "EventToken");
            SetPlayerWeapons(playerid);
            SetPlayerToSpawn(playerid);

            if(refund)
            {
                GivePlayerCash(playerid, gfc_config_entryFee);
                SendClientMessageEx(playerid, COLOR_AQUA, "You left the fight and you got back your money.");
                gfc_state_totalMoney -= gfc_config_entryFee;
                if(gfc_config_fightersInField == 1)
                {
                    for(new j=0;j<4;j++)
                    {
                        if(gfc_players_id[j] != -1)
                        {
                            KickPlayerFromFight(gfc_players_id[j], true);
                            break;
                        }
                    }
                }
            }
            else if(gfc_config_fightersInField == 0)
            {
                new 
                    total_win_cash = floatround(gfc_state_totalMoney * 0.9);
                SendClientMessageEx(playerid, COLOR_AQUA, "You've won the fight and earned $%i!", total_win_cash);
                GivePlayerCash(playerid, total_win_cash);
            }
            else
            {
                SendClientMessageEx(playerid, COLOR_AQUA, "You lost the fight!");

                if(gfc_config_fightersInField == 1 && gfc_state_machine == STATE_FC_FIGHTING)
                {
                    new 
                        winner_id      = GetFightWinner();
                    
                    if(winner_id == -1)
                    {
                        SendAdminMessage(COLOR_YELLOW, "[FC] No winner found for current fight!");
                        return;
                    }
                    KickPlayerFromFight(winner_id, false);
                }
            }
        }
    }
    if(gfc_config_fightersInField == 0)
    {
        gfc_state_machine = STATE_FC_IDLE;
    }
}

FC_ShowMainMenu(playerid)
{
    new 
        string[512],
        password[25];

    if(isnull(gfc_player_password[playerid]))
    {
        strcpy(password, "{F1C40F}None");
    }
    else strcpy(password, gfc_player_password[playerid]);
    
    format(string, sizeof(string), 
            "Number of fighters\t {F1C40F}%i\n"\
            "Password\t {CA360A}%s\n"\
            "Entry fee\t {2ECA70}$%i\n"\
            "Duration\t {F1C40F}%i minutes\n"\
            "Health\t {F1C40F}%i\n"\
            "Armor\t {F1C40F}%i\n"\
            "{9158B6}Begin fight!", 
           gfc_player_numberOfFighters[playerid], password, gfc_player_entryFee[playerid],
           gfc_player_duration[playerid], gfc_player_health[playerid], gfc_player_armor[playerid]);

    Dialog_Show(playerid, CheckinDialogResponse, DIALOG_STYLE_TABLIST, "{FFFFFF}                                        Fight club", string, "Select", "Cancel");
}

FC_SetPlayerParameter(playerid, fieldid, value[]) 
{
    new 
        numeric_value = strval(value); // value will be zero in case of password

    switch(fieldid)
    {
        case FC_INPUT_NUMBER_OF_FIGHTERS:
        {
            if(numeric_value < 2 || numeric_value > 4)
            {
                return false;
            }
            gfc_player_numberOfFighters[playerid]      = numeric_value;
            
        }
        case FC_INPUT_PASSWORD:
        {
            if(strlen(value) > 24)
            {
                return false;
            }
            strcpy(gfc_player_password[playerid], value, 24);

        }
        case FC_INPUT_ENTRY_FEE:
        {
            if(numeric_value < 5000 || numeric_value > 500000)
            {
                return false;
            }
            gfc_player_entryFee[playerid]              = numeric_value;
            
        }
        case FC_INPUT_DURATION:
        {
            if(numeric_value < 1 || numeric_value > 5)
            {
                return false;
            }
            gfc_player_duration[playerid]              = numeric_value;
            
        }
        case FC_INPUT_HEALTH:
        {
            if(numeric_value < 1 || numeric_value > 100)
            {
                return false;
            }
            gfc_player_health[playerid]                = numeric_value;
            
        }
        case FC_INPUT_ARMOR:
        {
            if(numeric_value < 0 || numeric_value > 100)
            {
                return false;
            }
            gfc_player_armor[playerid]                 = numeric_value;
            
        }
    }
    return true;
}

FC_UpdateTimeForPlayer(playerid)
{
    if(playerid != -1)
    {
        new 
            time = 60 * gfc_config_duration - gfc_state_ticks;

        if(gfc_state_ticks >= 60 * gfc_config_duration)
        {
            KickPlayerFromFight(playerid, true); // Refund player
        }
        else
        {     
            new 
                value[10];
            
            format(value, sizeof(value), "%02d:%02d", time / 60 , time % 60);
            PlayerTextDrawSetString(playerid, gfc_player_clockTextDraw[playerid], value);
        }
    }
}

/*----------: Hooks :----------*/

hook OnGameModeInit()
{
    gfc_state_machine = STATE_FC_IDLE;
    for(new i=0;i<4;i++)
    {
        gfc_players_id[i] = -1;
    }
    CreateDynamic3DTextLabel("Press the 'N' key to setup a fight.", COLOR_YELLOW, gfc_checkinPosition[0],gfc_checkinPosition[1],gfc_checkinPosition[2], 10.0, .worldid=FIGHT_CLUB_VIRTUAL_WORLD_ID,.interiorid=FIGHT_CLUB_INTERIOR_ID);
    
    //Mapping
	{
        new g_Object[278];
        g_Object[0] = CreateDynamicObject(1556, 422.7184, -1431.2779, 46.1081, 0.0000, 0.0000, 126.4000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //Gen_doorEXT18
        g_Object[1] = CreateDynamicObject(2601, 427.1510, -1418.3625, 46.4393, 0.0000, 0.0000, 140.5997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[2] = CreateDynamicObject(19444, 426.6604, -1430.4322, 47.8586, 0.0000, 0.0000, -55.2000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall084
        SetDynamicObjectMaterial(g_Object[2], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[3] = CreateDynamicObject(1300, 434.7727, -1402.5987, 46.4845, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bin1
        SetDynamicObjectMaterial(g_Object[3], 0, 16640, "a51", "scratchedmetal", 0x00000000);
        g_Object[4] = CreateDynamicObject(19836, 431.9283, -1409.6169, 46.1487, 0.0000, 0.0000, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[5] = CreateDynamicObject(11724, 425.2514, -1431.4720, 46.5988, 0.0000, 0.0000, 34.7000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //FireplaceSurround1
        SetDynamicObjectMaterial(g_Object[5], 0, 14581, "ab_mafiasuitea", "ab_walnut", 0x00000000);
        SetDynamicObjectMaterial(g_Object[5], 1, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
        g_Object[6] = CreateDynamicObject(11724, 427.9320, -1429.6164, 46.5988, 0.0000, 0.0000, 34.7000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //FireplaceSurround1
        SetDynamicObjectMaterial(g_Object[6], 0, 14581, "ab_mafiasuitea", "ab_walnut", 0x00000000);
        SetDynamicObjectMaterial(g_Object[6], 1, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
        g_Object[7] = CreateDynamicObject(18754, 373.5415, -1376.0262, 45.6388, 0.0000, 0.0000, 35.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //Base250mx250m1
        SetDynamicObjectMaterial(g_Object[7], 0, 4835, "airoads_las", "concretenewb256", 0xFFDCDCDC);
        g_Object[8] = CreateDynamicObject(19370, 430.1552, -1428.0008, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[8], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[9] = CreateDynamicObject(19370, 422.5661, -1433.2541, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[9], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[10] = CreateDynamicObject(2066, 424.1509, -1433.0593, 46.1166, 0.0000, 0.0000, -53.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[11] = CreateDynamicObject(1300, 419.6520, -1413.7873, 46.4845, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bin1
        SetDynamicObjectMaterial(g_Object[11], 0, 16640, "a51", "scratchedmetal", 0x00000000);
        g_Object[12] = CreateDynamicObject(19370, 432.3099, -1428.3498, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[12], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[13] = CreateDynamicObject(19370, 434.2134, -1430.9211, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[13], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[14] = CreateDynamicObject(19370, 435.4049, -1432.1771, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[15] = CreateDynamicObject(19370, 438.0260, -1436.0727, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[16] = CreateDynamicObject(19370, 439.9353, -1438.6527, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[17] = CreateDynamicObject(19370, 425.6412, -1435.2248, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[17], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[18] = CreateDynamicObject(19370, 427.5447, -1437.7967, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[19] = CreateDynamicObject(19370, 428.4251, -1438.9862, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[20] = CreateDynamicObject(19370, 430.3283, -1441.5577, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[21] = CreateDynamicObject(19370, 432.2319, -1444.1302, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[22] = CreateDynamicObject(19370, 438.0989, -1438.8227, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[23] = CreateDynamicObject(19370, 435.4598, -1440.6501, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[24] = CreateDynamicObject(19370, 432.8373, -1442.4664, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[25] = CreateDynamicObject(19370, 428.0408, -1429.6711, 49.4188, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[25], 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
        g_Object[26] = CreateDynamicObject(19370, 425.5273, -1431.3985, 49.4188, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[26], 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
        g_Object[27] = CreateDynamicObject(2949, 433.9179, -1430.2893, 46.1105, 0.0000, 0.0000, -143.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_lockeddoor
        g_Object[28] = CreateDynamicObject(2949, 432.8276, -1429.2768, 46.1105, 0.0000, 0.0000, 36.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_lockeddoor
        g_Object[29] = CreateDynamicObject(19370, 433.2488, -1431.8187, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[29], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[30] = CreateDynamicObject(19370, 430.6094, -1433.6450, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[30], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[31] = CreateDynamicObject(19370, 427.9783, -1435.4665, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[31], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[32] = CreateDynamicObject(19370, 425.3475, -1437.2882, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[32], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[33] = CreateDynamicObject(2332, 428.6397, -1434.5107, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[34] = CreateDynamicObject(2332, 427.9375, -1434.9892, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[35] = CreateDynamicObject(2332, 427.2355, -1435.4676, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[36] = CreateDynamicObject(1829, 429.1625, -1433.7712, 46.6067, 0.0000, 0.0000, -145.3999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //man_safenew
        g_Object[37] = CreateDynamicObject(2332, 430.0523, -1433.5454, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[38] = CreateDynamicObject(2332, 430.7543, -1433.0655, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[39] = CreateDynamicObject(2332, 431.4566, -1432.5870, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[40] = CreateDynamicObject(2332, 432.1589, -1432.1080, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[41] = CreateDynamicObject(2332, 432.8612, -1431.6291, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[42] = CreateDynamicObject(2332, 433.5632, -1431.1512, 46.6142, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[43] = CreateDynamicObject(2332, 433.5632, -1431.1512, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[44] = CreateDynamicObject(2332, 432.8611, -1431.6302, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[45] = CreateDynamicObject(2332, 432.1589, -1432.1090, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[46] = CreateDynamicObject(2332, 431.4570, -1432.5871, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[47] = CreateDynamicObject(2332, 430.7550, -1433.0655, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[48] = CreateDynamicObject(2332, 430.0531, -1433.5439, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[49] = CreateDynamicObject(2332, 429.3511, -1434.0228, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[50] = CreateDynamicObject(2332, 428.6492, -1434.5013, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[51] = CreateDynamicObject(2332, 427.9468, -1434.9798, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[52] = CreateDynamicObject(2332, 427.2449, -1435.4571, 47.5443, 0.0000, 0.0000, -145.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //KEV_SAFE
        g_Object[53] = CreateDynamicObject(19302, 431.4783, -1420.0821, 47.3749, 0.0000, 0.0000, -53.3997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //subbridge07
        g_Object[54] = CreateDynamicObject(2066, 424.4901, -1433.5177, 46.1166, 0.0000, 0.0000, -53.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[55] = CreateDynamicObject(2066, 425.1281, -1433.7760, 46.1166, 0.0000, 0.0000, 126.0998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[56] = CreateDynamicObject(2066, 425.1741, -1434.4416, 46.1166, 0.0000, 0.0000, -53.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[57] = CreateDynamicObject(2066, 425.5132, -1434.9001, 46.1166, 0.0000, 0.0000, -53.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[58] = CreateDynamicObject(2066, 425.8522, -1435.3586, 46.1166, 0.0000, 0.0000, -53.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[59] = CreateDynamicObject(2066, 432.3774, -1428.8293, 46.1166, 0.0000, 0.0000, 126.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[60] = CreateDynamicObject(2066, 432.0382, -1428.3702, 46.1166, 0.0000, 0.0000, 126.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[61] = CreateDynamicObject(2066, 431.6932, -1427.9044, 46.1166, 0.0000, 0.0000, 126.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_M_FILEING2
        g_Object[62] = CreateDynamicObject(19370, 437.3081, -1434.7485, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[63] = CreateDynamicObject(19370, 439.2117, -1437.3205, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        g_Object[64] = CreateDynamicObject(2949, 437.7449, -1435.1092, 46.1105, 0.0000, 0.0000, -143.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_lockeddoor
        g_Object[65] = CreateDynamicObject(1806, 425.4482, -1432.3823, 46.1300, 0.0000, 0.0000, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //MED_OFFICE_CHAIR
        g_Object[66] = CreateDynamicObject(1806, 428.8004, -1430.0102, 46.1300, 0.0000, 0.0000, 47.7999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //MED_OFFICE_CHAIR
        g_Object[67] = CreateDynamicObject(19370, 433.6401, -1420.4903, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[67], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[68] = CreateDynamicObject(19370, 436.2792, -1418.6627, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[68], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[69] = CreateDynamicObject(19370, 436.2792, -1418.6627, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[69], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[70] = CreateDynamicObject(19370, 433.6401, -1420.4903, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[70], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[71] = CreateDynamicObject(19370, 438.9186, -1416.8358, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[71], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[72] = CreateDynamicObject(19370, 438.9186, -1416.8358, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[72], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[73] = CreateDynamicObject(19384, 431.4731, -1420.1175, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall032
        SetDynamicObjectMaterial(g_Object[73], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[74] = CreateDynamicObject(19384, 431.4731, -1420.1175, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall032
        SetDynamicObjectMaterial(g_Object[74], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[75] = CreateDynamicObject(19370, 429.5773, -1417.5450, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[75], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[76] = CreateDynamicObject(19370, 429.5773, -1417.5450, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[76], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[77] = CreateDynamicObject(19370, 427.6679, -1414.9648, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[77], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[78] = CreateDynamicObject(19370, 427.6679, -1414.9648, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[78], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[79] = CreateDynamicObject(19370, 425.7643, -1412.3923, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[79], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[80] = CreateDynamicObject(19370, 425.7643, -1412.3923, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[80], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[81] = CreateDynamicObject(19370, 439.2590, -1414.7600, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[81], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[82] = CreateDynamicObject(19370, 439.2590, -1414.7600, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[82], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[83] = CreateDynamicObject(19370, 437.3554, -1412.1877, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[83], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[84] = CreateDynamicObject(19370, 437.3554, -1412.1877, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[84], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[85] = CreateDynamicObject(19370, 435.4461, -1409.6079, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[85], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[86] = CreateDynamicObject(19370, 435.4461, -1409.6079, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[86], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[87] = CreateDynamicObject(19370, 433.5426, -1407.0355, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[87], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[88] = CreateDynamicObject(19370, 433.5426, -1407.0355, 47.8586, 0.0000, 0.0000, -143.4998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[88], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[89] = CreateDynamicObject(19370, 431.3828, -1406.6562, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[89], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[90] = CreateDynamicObject(19370, 431.3828, -1406.6562, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[90], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[91] = CreateDynamicObject(19370, 428.7434, -1408.4836, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[91], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[92] = CreateDynamicObject(19370, 428.7434, -1408.4836, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[92], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[93] = CreateDynamicObject(19370, 426.1292, -1410.2939, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[93], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[94] = CreateDynamicObject(19370, 426.1292, -1410.2939, 47.8688, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[94], 0, 13659, "8bars", "Upt_Fence_Mesh", 0x00000000);
        g_Object[95] = CreateDynamicObject(1307, 431.0086, -1419.3929, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[95], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[96] = CreateDynamicObject(11729, 418.3215, -1424.7517, 46.1114, 0.0000, 0.0000, 126.3999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //GymLockerClosed1
        g_Object[97] = CreateDynamicObject(1307, 432.0277, -1420.7910, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[97], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[98] = CreateDynamicObject(1307, 429.6376, -1417.4969, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[98], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[99] = CreateDynamicObject(1307, 427.7261, -1414.9431, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[99], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[100] = CreateDynamicObject(1307, 425.8319, -1412.4123, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[100], 0, 10806, "airfence_sfse", "ws_leccyfncesign", 0x00000000);
        SetDynamicObjectMaterial(g_Object[100], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[101] = CreateDynamicObject(3819, 426.6806, -1405.5024, 46.9986, 0.0000, 0.0000, 124.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bleacher_SFSx
        SetDynamicObjectMaterial(g_Object[101], 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
        g_Object[102] = CreateDynamicObject(1307, 424.9306, -1411.1767, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[102], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[103] = CreateDynamicObject(1307, 426.1911, -1410.2572, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[103], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[104] = CreateDynamicObject(1307, 428.8356, -1408.4521, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[104], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[105] = CreateDynamicObject(1307, 431.4486, -1406.6207, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[105], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[106] = CreateDynamicObject(1307, 432.6777, -1405.8111, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[106], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[107] = CreateDynamicObject(1307, 433.5480, -1406.9708, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[107], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[108] = CreateDynamicObject(1307, 435.4688, -1409.6046, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[108], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[109] = CreateDynamicObject(1307, 437.3958, -1412.1955, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[109], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[110] = CreateDynamicObject(1307, 439.2697, -1414.7148, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[110], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[111] = CreateDynamicObject(1307, 440.1828, -1415.9665, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[111], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[112] = CreateDynamicObject(1307, 438.9685, -1416.8645, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[112], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[113] = CreateDynamicObject(1307, 436.3727, -1418.6341, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[113], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[114] = CreateDynamicObject(1307, 433.7019, -1420.4707, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[114], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[115] = CreateDynamicObject(1307, 432.4696, -1421.3448, 44.1254, 0.0000, 0.0000, -53.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //telgrphpoleall
        SetDynamicObjectMaterial(g_Object[115], 1, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[116] = CreateDynamicObject(19996, 432.4909, -1406.5288, 46.1010, 0.0000, 0.0000, -13.8001, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CutsceneFoldChair1
        SetDynamicObjectMaterial(g_Object[116], 0, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[117] = CreateDynamicObject(3819, 438.1018, -1421.8951, 46.9986, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bleacher_SFSx
        SetDynamicObjectMaterial(g_Object[117], 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
        g_Object[118] = CreateDynamicObject(3819, 424.5202, -1417.1391, 46.9986, 0.0000, 0.0000, -143.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bleacher_SFSx
        SetDynamicObjectMaterial(g_Object[118], 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
        g_Object[119] = CreateDynamicObject(19370, 423.6795, -1422.9012, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[119], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[120] = CreateDynamicObject(19383, 421.0541, -1424.7237, 47.8487, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall031
        SetDynamicObjectMaterial(g_Object[120], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[121] = CreateDynamicObject(19370, 428.0408, -1429.6711, 49.4188, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[121], 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
        g_Object[122] = CreateDynamicObject(19370, 425.5273, -1431.3985, 49.4188, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[122], 0, 10806, "airfence_sfse", "ws_griddyfence", 0x00000000);
        g_Object[123] = CreateDynamicObject(19370, 418.4255, -1426.5389, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[123], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[124] = CreateDynamicObject(19370, 417.9572, -1424.9162, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[124], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[125] = CreateDynamicObject(19370, 424.0260, -1420.8115, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[125], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[126] = CreateDynamicObject(19370, 422.1228, -1418.2395, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[126], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[127] = CreateDynamicObject(19370, 420.2192, -1415.6671, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[127], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[128] = CreateDynamicObject(19370, 418.3157, -1413.0942, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[128], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[129] = CreateDynamicObject(19370, 416.4064, -1410.5140, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[129], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[130] = CreateDynamicObject(19370, 416.0479, -1422.3365, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[130], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[131] = CreateDynamicObject(19370, 414.1444, -1419.7641, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[131], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[132] = CreateDynamicObject(19370, 412.2351, -1417.1850, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[132], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[133] = CreateDynamicObject(19370, 410.3258, -1414.6053, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[133], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[134] = CreateDynamicObject(19370, 415.1210, -1411.5426, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[134], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[135] = CreateDynamicObject(19370, 412.4985, -1413.3581, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[135], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[136] = CreateDynamicObject(19370, 409.8594, -1415.1849, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[136], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[137] = CreateDynamicObject(2630, 416.0848, -1420.2357, 46.1208, 0.0000, 0.0000, 126.7994, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bike
        g_Object[138] = CreateDynamicObject(2630, 416.8515, -1421.2607, 46.1208, 0.0000, 0.0000, 126.7994, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bike
        g_Object[139] = CreateDynamicObject(2630, 417.6300, -1422.3017, 46.1208, 0.0000, 0.0000, 126.7994, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bike
        g_Object[140] = CreateDynamicObject(2630, 418.4208, -1423.3586, 46.1208, 0.0000, 0.0000, 126.7994, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bike
        g_Object[141] = CreateDynamicObject(2630, 415.2637, -1419.1390, 46.1208, 0.0000, 0.0000, 126.7994, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bike
        g_Object[142] = CreateDynamicObject(2628, 422.4096, -1420.3911, 46.1296, 0.0000, 0.0000, -53.8997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench2
        g_Object[143] = CreateDynamicObject(2628, 421.6675, -1419.3730, 46.1296, 0.0000, 0.0000, -53.8997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench2
        g_Object[144] = CreateDynamicObject(2628, 420.8898, -1418.3072, 46.1296, 0.0000, 0.0000, -53.8997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench2
        g_Object[145] = CreateDynamicObject(2628, 420.0888, -1417.2082, 46.1296, 0.0000, 0.0000, -53.8997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench2
        g_Object[146] = CreateDynamicObject(2628, 419.2582, -1416.0692, 46.1296, 0.0000, 0.0000, -53.8997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench2
        g_Object[147] = CreateDynamicObject(2629, 418.4190, -1414.6966, 46.1310, 0.0000, 0.0000, -53.1999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench1
        g_Object[148] = CreateDynamicObject(2629, 417.3945, -1413.3271, 46.1310, 0.0000, 0.0000, -53.1999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench1
        g_Object[149] = CreateDynamicObject(2629, 416.3522, -1411.9337, 46.1310, 0.0000, 0.0000, -53.1999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_bench1
        g_Object[150] = CreateDynamicObject(2627, 422.9301, -1421.3343, 46.1166, 0.0000, 0.0000, -53.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_treadmill
        g_Object[151] = CreateDynamicObject(2627, 423.5173, -1422.1313, 46.1166, 0.0000, 0.0000, -53.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //gym_treadmill
        g_Object[152] = CreateDynamicObject(2894, 427.9515, -1429.5118, 47.1086, 0.0000, 0.0000, 38.7999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_rhymesbook
        g_Object[153] = CreateDynamicObject(11729, 418.8316, -1425.4438, 46.1114, 0.0000, 0.0000, 126.3999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //GymLockerClosed1
        g_Object[154] = CreateDynamicObject(1985, 414.1076, -1417.6717, 49.1795, 0.0000, 0.0000, -56.7000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //punchbagnu
        g_Object[155] = CreateDynamicObject(11746, 427.4656, -1429.6605, 47.1184, 90.0000, -127.9999, 90.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //DoorKey1
        g_Object[156] = CreateDynamicObject(1775, 421.4519, -1428.7209, 47.1360, 0.0000, 0.0000, 126.9000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_SPRUNK1
        g_Object[157] = CreateDynamicObject(1985, 413.1942, -1416.5384, 49.1795, 0.0000, 0.0000, -56.7000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //punchbagnu
        g_Object[158] = CreateDynamicObject(1985, 412.3370, -1415.2358, 49.1795, 0.0000, 0.0000, -56.7000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //punchbagnu
        g_Object[159] = CreateDynamicObject(19087, 413.1770, -1416.5410, 51.6287, 0.0000, 0.0000, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //Rope1
        g_Object[160] = CreateDynamicObject(19087, 414.0870, -1417.6816, 51.6287, 0.0000, 0.0000, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //Rope1
        g_Object[161] = CreateDynamicObject(19087, 412.3168, -1415.2403, 51.6287, 0.0000, 0.0000, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //Rope1
        g_Object[162] = CreateDynamicObject(2942, 429.2786, -1428.0668, 46.7737, 0.0000, 0.0000, -145.2998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_atm1
        g_Object[163] = CreateDynamicObject(956, 420.1882, -1427.1966, 46.4420, 0.0000, 0.0000, 126.3999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_EXT_CANDY
        g_Object[164] = CreateDynamicObject(2942, 426.2943, -1430.1330, 46.7737, 0.0000, 0.0000, -145.2998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_atm1
        g_Object[165] = CreateDynamicObject(2942, 430.4541, -1427.2526, 46.7737, 0.0000, 0.0000, -145.2998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_atm1
        g_Object[166] = CreateDynamicObject(19996, 432.5429, -1420.6079, 46.1010, 0.0000, 0.0000, 161.0997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CutsceneFoldChair1
        SetDynamicObjectMaterial(g_Object[166], 0, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[167] = CreateDynamicObject(1300, 418.7178, -1412.5250, 46.4845, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bin1
        SetDynamicObjectMaterial(g_Object[167], 0, 16640, "a51", "scratchedmetal", 0x00000000);
        g_Object[168] = CreateDynamicObject(1300, 433.8385, -1401.3360, 46.4845, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bin1
        SetDynamicObjectMaterial(g_Object[168], 0, 16640, "a51", "scratchedmetal", 0x00000000);
        g_Object[169] = CreateDynamicObject(1300, 444.3316, -1415.5183, 46.4845, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bin1
        SetDynamicObjectMaterial(g_Object[169], 0, 16640, "a51", "scratchedmetal", 0x00000000);
        g_Object[170] = CreateDynamicObject(2894, 425.3323, -1431.2967, 47.1086, 0.0000, 0.0000, -145.1000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_rhymesbook
        g_Object[171] = CreateDynamicObject(1300, 445.1882, -1416.6750, 46.4845, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bin1
        SetDynamicObjectMaterial(g_Object[171], 0, 16640, "a51", "scratchedmetal", 0x00000000);
        g_Object[172] = CreateDynamicObject(19370, 417.7810, -1409.6042, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[172], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[173] = CreateDynamicObject(19370, 420.4122, -1407.7829, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[173], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[174] = CreateDynamicObject(19370, 423.0513, -1405.9558, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[174], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[175] = CreateDynamicObject(19370, 425.6903, -1404.1290, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[175], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[176] = CreateDynamicObject(19370, 428.3294, -1402.3016, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[176], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[177] = CreateDynamicObject(19370, 430.9685, -1400.4742, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[177], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[178] = CreateDynamicObject(19370, 433.6076, -1398.6472, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[178], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[179] = CreateDynamicObject(19370, 423.6972, -1432.6739, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[179], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[180] = CreateDynamicObject(19370, 421.7939, -1430.1003, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[180], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[181] = CreateDynamicObject(19370, 419.8904, -1427.5290, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[181], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[182] = CreateDynamicObject(19003, 427.4595, -1423.4158, 49.5288, 0.0000, 0.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        SetDynamicObjectMaterial(g_Object[182], 1, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
        g_Object[183] = CreateDynamicObject(19370, 433.8778, -1400.2275, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[183], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[184] = CreateDynamicObject(19370, 435.7871, -1402.8077, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[184], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[185] = CreateDynamicObject(19370, 437.6964, -1405.3883, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[185], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[186] = CreateDynamicObject(19370, 439.6058, -1407.9692, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[186], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[187] = CreateDynamicObject(19370, 441.5154, -1410.5500, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[187], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[188] = CreateDynamicObject(19370, 443.4247, -1413.1308, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[188], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[189] = CreateDynamicObject(19370, 445.3341, -1415.7104, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[189], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[190] = CreateDynamicObject(19370, 447.2434, -1418.2904, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[190], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[191] = CreateDynamicObject(19370, 449.1528, -1420.8697, 47.8586, 0.0000, 0.0000, 36.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[191], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[192] = CreateDynamicObject(19370, 435.2781, -1429.5714, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[192], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[193] = CreateDynamicObject(19370, 437.9171, -1427.7434, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[193], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[194] = CreateDynamicObject(19370, 440.5559, -1425.9154, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[194], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[195] = CreateDynamicObject(19370, 443.1870, -1424.0937, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[195], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[196] = CreateDynamicObject(19370, 445.8179, -1422.2724, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[196], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[197] = CreateDynamicObject(19370, 448.4407, -1420.4565, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall018
        SetDynamicObjectMaterial(g_Object[197], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[198] = CreateDynamicObject(19003, 416.0052, -1407.0576, 49.5288, 0.0000, 0.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        SetDynamicObjectMaterial(g_Object[198], 1, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
        g_Object[199] = CreateDynamicObject(19003, 432.3802, -1395.5905, 49.5288, 0.0000, 0.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        SetDynamicObjectMaterial(g_Object[199], 1, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
        g_Object[200] = CreateDynamicObject(19003, 443.8344, -1411.9497, 49.5288, 0.0000, 0.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        SetDynamicObjectMaterial(g_Object[200], 1, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
        g_Object[201] = CreateDynamicObject(19003, 427.4767, -1423.4404, 46.0886, 0.0000, 180.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        g_Object[202] = CreateDynamicObject(19996, 425.7770, -1411.3707, 46.1010, 0.0000, 0.0000, 72.1996, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CutsceneFoldChair1
        SetDynamicObjectMaterial(g_Object[202], 0, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[203] = CreateDynamicObject(19003, 416.0451, -1407.1140, 46.0886, 0.0000, 180.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        g_Object[204] = CreateDynamicObject(19003, 432.2153, -1395.7921, 46.0886, 0.0000, 180.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        g_Object[205] = CreateDynamicObject(19003, 443.6181, -1412.0771, 46.0886, 0.0000, 180.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //LAOfficeFloors1
        g_Object[206] = CreateDynamicObject(19836, 439.2582, -1415.4270, 46.1487, 0.0000, 0.0000, -99.2995, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[207] = CreateDynamicObject(19836, 431.7882, -1420.0809, 46.1487, 0.0000, 0.0000, -152.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[208] = CreateDynamicObject(19836, 428.4353, -1413.5289, 46.1487, 0.0000, 0.0000, -93.7995, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[209] = CreateDynamicObject(19836, 434.8511, -1413.9549, 46.1487, 0.0000, 0.0000, -38.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[210] = CreateDynamicObject(19836, 432.2456, -1417.1728, 46.1487, 0.0000, 0.0000, -67.6996, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[211] = CreateDynamicObject(19836, 435.3085, -1418.0787, 46.1487, 0.0000, 0.0000, 143.2998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[212] = CreateDynamicObject(19836, 434.9909, -1414.0686, 46.1487, 0.0000, 0.0000, -38.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[213] = CreateDynamicObject(19836, 434.8298, -1414.0920, 46.1487, 0.0000, 0.0000, -38.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[214] = CreateDynamicObject(19836, 434.7055, -1413.9913, 46.1487, 0.0000, 0.0000, -38.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[215] = CreateDynamicObject(19836, 434.6408, -1414.1191, 46.1487, 0.0000, 0.0000, -38.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[216] = CreateDynamicObject(19836, 432.1235, -1417.2281, 46.1487, 0.0000, 0.0000, -38.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[217] = CreateDynamicObject(19836, 432.1271, -1417.0583, 46.1487, 0.0000, 0.0000, -91.1996, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[218] = CreateDynamicObject(19836, 432.2572, -1417.0611, 46.1487, 0.0000, 0.0000, -4.6999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[219] = CreateDynamicObject(19836, 432.1917, -1416.8945, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[220] = CreateDynamicObject(19836, 431.9826, -1409.5096, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[221] = CreateDynamicObject(19836, 431.8576, -1409.4437, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[222] = CreateDynamicObject(19836, 431.8013, -1409.5384, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[223] = CreateDynamicObject(19836, 431.6871, -1409.4066, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[224] = CreateDynamicObject(19836, 428.5650, -1413.5660, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[225] = CreateDynamicObject(19836, 428.5273, -1413.4282, 46.1487, 0.0000, 0.0000, -41.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[226] = CreateDynamicObject(19836, 428.3420, -1413.4121, 46.1487, 0.0000, 0.0000, -41.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[227] = CreateDynamicObject(19836, 435.2709, -1418.2218, 46.1487, 0.0000, 0.0000, -41.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[228] = CreateDynamicObject(19836, 435.4450, -1418.1745, 46.1487, 0.0000, 0.0000, 13.3999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[229] = CreateDynamicObject(19836, 439.2434, -1415.5157, 46.1487, 0.0000, 0.0000, -99.2995, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[230] = CreateDynamicObject(19836, 439.2275, -1415.6147, 46.1487, 0.0000, 0.0000, -99.2995, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[231] = CreateDynamicObject(19836, 439.3457, -1415.6339, 46.1487, 0.0000, 0.0000, -99.2995, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[232] = CreateDynamicObject(19836, 431.8338, -1412.4259, 46.1487, 0.0000, 0.0000, -125.8999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[233] = CreateDynamicObject(19836, 431.9309, -1412.4962, 46.1487, 0.0000, 0.0000, -90.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[234] = CreateDynamicObject(19836, 431.9288, -1412.6163, 46.1487, 0.0000, 0.0000, -90.9999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[235] = CreateDynamicObject(19836, 431.7889, -1412.6142, 46.1487, 0.0000, 0.0000, -116.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[236] = CreateDynamicObject(19836, 431.7218, -1412.4576, 46.1487, 0.0000, 0.0000, 87.1996, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //BloodPool1
        g_Object[237] = CreateDynamicObject(19996, 439.1903, -1415.7712, 46.1010, 0.0000, 0.0000, -103.1996, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CutsceneFoldChair1
        SetDynamicObjectMaterial(g_Object[237], 0, 16640, "a51", "Metal3_128", 0x00000000);
        g_Object[238] = CreateDynamicObject(3819, 439.1119, -1409.2983, 46.9986, 0.0000, 0.0000, 36.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //bleacher_SFSx
        SetDynamicObjectMaterial(g_Object[238], 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
        g_Object[239] = CreateDynamicObject(2006, 429.2200, -1433.1018, 46.6388, 0.0000, 0.0000, -55.3997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //cr_safe_dial
        g_Object[240] = CreateDynamicObject(19981, 432.6268, -1428.6235, 44.9081, 0.0000, 0.0000, 126.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //SAMPRoadSign34
        SetDynamicObjectMaterial(g_Object[240], 0, 19297, "matlights", "invisible", 0x00000000);
        SetDynamicObjectMaterial(g_Object[240], 1, 19297, "matlights", "invisible", 0x00000000);
        g_Object[241] = CreateDynamicObject(19981, 422.7713, -1423.6324, 44.9081, 0.0000, 0.0000, 34.7999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //SAMPRoadSign34
        SetDynamicObjectMaterial(g_Object[241], 0, 19297, "matlights", "invisible", 0x00000000);
        SetDynamicObjectMaterial(g_Object[241], 1, 19297, "matlights", "invisible", 0x00000000);
        g_Object[242] = CreateDynamicObject(19383, 425.2033, -1431.4338, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall031
        SetDynamicObjectMaterial(g_Object[242], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[243] = CreateDynamicObject(1490, 423.3554, -1423.2569, 46.6888, 0.0000, 0.0000, 124.5998, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //tag_01
        SetDynamicObjectMaterialText(g_Object[243], 0, "Fitness Room", OBJECT_MATERIAL_SIZE_256x128, "Arial", 14, 1, 0xFFFFFFFF, 0x00000000, 0);
        g_Object[244] = CreateDynamicObject(1490, 432.2611, -1428.0865, 46.6888, 0.0000, 0.0000, -143.4002, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //tag_01
        SetDynamicObjectMaterialText(g_Object[244], 0, "Employees Only", OBJECT_MATERIAL_SIZE_256x128, "Arial", 14, 1, 0xFFFFFFFF, 0x00000000, 0);
        g_Object[245] = CreateDynamicObject(2601, 421.9609, -1415.9527, 47.2491, 0.0000, 0.0000, -24.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[246] = CreateDynamicObject(19383, 427.8345, -1429.6125, 47.8586, 0.0000, 0.0000, -55.2999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //wall031
        SetDynamicObjectMaterial(g_Object[246], 0, 14415, "carter_block_2", "cd_wall1", 0x00000000);
        g_Object[247] = CreateDynamicObject(2601, 424.7510, -1407.3624, 46.7593, 0.0000, 0.0000, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[248] = CreateDynamicObject(2601, 430.2731, -1405.2823, 46.2793, 0.0000, 0.0000, -72.3000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[249] = CreateDynamicObject(2601, 437.1271, -1407.9449, 46.6091, 0.0000, 0.0000, -72.3000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[250] = CreateDynamicObject(2601, 441.6986, -1411.5140, 47.0792, 0.0000, 0.0000, 80.7997, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[251] = CreateDynamicObject(2601, 439.4216, -1422.6323, 47.2392, 0.0000, 0.0000, -177.1999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[252] = CreateDynamicObject(2601, 435.2177, -1422.8580, 46.5992, 0.0000, 0.0000, 123.4999, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //CJ_JUICE_CAN
        g_Object[253] = CreateDynamicObject(1491, 420.4490, -1425.1567, 46.1091, 0.0000, 0.0000, 35.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //Gen_doorINT01
        SetDynamicObjectMaterial(g_Object[253], 0, 14666, "genintintsex", "CJ_BLUE_DOOR", 0x00000000);
        g_Object[254] = CreateDynamicObject(1893, 420.3263, -1422.3891, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[255] = CreateDynamicObject(1893, 427.1383, -1424.6031, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[256] = CreateDynamicObject(1893, 430.4739, -1422.1352, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[257] = CreateDynamicObject(1893, 441.4787, -1413.9935, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[258] = CreateDynamicObject(1893, 423.7943, -1427.0754, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[259] = CreateDynamicObject(1893, 425.0896, -1407.5428, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[260] = CreateDynamicObject(1893, 417.8280, -1419.0129, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[261] = CreateDynamicObject(1893, 414.9132, -1415.0722, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[262] = CreateDynamicObject(1893, 427.0064, -1417.4459, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[263] = CreateDynamicObject(1893, 438.0273, -1409.2911, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[264] = CreateDynamicObject(1893, 424.5082, -1414.0698, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[265] = CreateDynamicObject(1893, 435.5289, -1405.9146, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[266] = CreateDynamicObject(1893, 421.5852, -1410.1357, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[267] = CreateDynamicObject(1893, 432.6224, -1401.9686, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[268] = CreateDynamicObject(1893, 427.2799, -1431.7873, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[269] = CreateDynamicObject(1893, 430.2059, -1429.6219, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[270] = CreateDynamicObject(1893, 433.9519, -1426.8504, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[271] = CreateDynamicObject(1893, 437.4646, -1424.2513, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[272] = CreateDynamicObject(1893, 440.7525, -1421.8176, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[273] = CreateDynamicObject(1893, 444.9566, -1418.7081, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[274] = CreateDynamicObject(1893, 428.3776, -1405.1098, 50.0886, 0.0000, 0.0000, -53.5000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //shoplight1
        g_Object[275] = CreateDynamicObject(2913, 417.5160, -1412.6776, 47.0487, 90.0000, 36.4999, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_bpress
        SetDynamicObjectMaterial(g_Object[275], 0, 2627, "genintint_gym", "weight1", 0x00000000);
        g_Object[276] = CreateDynamicObject(2913, 418.5450, -1414.0684, 47.0487, 90.0000, 36.4999, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_bpress
        SetDynamicObjectMaterial(g_Object[276], 0, 2627, "genintint_gym", "weight1", 0x00000000);
        g_Object[277] = CreateDynamicObject(2913, 416.4870, -1411.2868, 47.0487, 90.0000, 36.4999, 0.0000, FIGHT_CLUB_VIRTUAL_WORLD_ID, FIGHT_CLUB_INTERIOR_ID); //kmb_bpress
        SetDynamicObjectMaterial(g_Object[277], 0, 2627, "genintint_gym", "weight1", 0x00000000);
    }
    
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys)
{
    if((newkeys & KEY_NO) && IsPlayerInRangeOfPoint(playerid, 
                                                   1, 
                                                   gfc_checkinPosition[0], 
                                                   gfc_checkinPosition[1],
                                                   gfc_checkinPosition[2])) 
    {            
        if(!IsPlayerIdle(playerid)) // don't interract if a player is not idle
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't do that at this moment!");
        }
        switch(gfc_state_machine)
        {
            
            case STATE_FC_IDLE:
            {
                gfc_player_numberOfFighters[playerid] = 4;
                gfc_player_password[playerid][0] = 0;
                gfc_player_entryFee[playerid] = 5000;
                gfc_player_duration[playerid] = 3;
                gfc_player_health[playerid] = 100;
                gfc_player_armor[playerid] = 0;
                FC_ShowMainMenu(playerid);
            }
            case STATE_FC_WAITING_FOR_PLAYERS:
            {
                if(gfc_config_fightersInField == gfc_config_nbOfFighters)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't join this fight. Maximum number of fighters has been reached!");
                }
                else
                {          
                    new
                        string[256];

                    format(string, sizeof(string), "{FFFFFF}The entry fee for this fight is {2ECA70}%i{FFFFFF} $.\n Are you sure to join.", gfc_config_entryFee);
                    
                    return Dialog_Show(playerid, FC_JoinConfirmation, DIALOG_STYLE_MSGBOX, 
                                        "{FFFFFF}Fight club", string, "Yes", "No");
                }
            }                
            case STATE_FC_FIGHTING:
            {
                return SendClientMessage(playerid, COLOR_GREY, "There is already a fight. Wait it until finished!");
            }
        }
    }
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if(eventToken != FIGHT_CLUB_EVENT_TOKEN)
    {
        return 1;
    }
    if(playerid != -1 && IsPlayerInFight(playerid))
    {
        KickPlayerFromFight(playerid, false); // No refund for player
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    if(GetPVarInt(playerid, "EventToken") != FIGHT_CLUB_EVENT_TOKEN)
    {
        return 1;
    }
    if(IsPlayerInFight(playerid))
    {
        KickPlayerFromFight(playerid, true); // Refund player
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    if(GetPVarInt(playerid, "EventToken") != FIGHT_CLUB_EVENT_TOKEN)
    {
        return 1;
    }
    //TextDraw
	gfc_player_clockTextDraw[playerid] = CreatePlayerTextDraw(playerid, 558.000000, 107.000000, "00:00");
	PlayerTextDrawFont(playerid, gfc_player_clockTextDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, gfc_player_clockTextDraw[playerid], 0.358332, 2.749998);
	PlayerTextDrawTextSize(playerid, gfc_player_clockTextDraw[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, gfc_player_clockTextDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, gfc_player_clockTextDraw[playerid], 1);
	PlayerTextDrawAlignment(playerid, gfc_player_clockTextDraw[playerid], 2);
	PlayerTextDrawColor(playerid, gfc_player_clockTextDraw[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, gfc_player_clockTextDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, gfc_player_clockTextDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, gfc_player_clockTextDraw[playerid], 0);
	PlayerTextDrawSetProportional(playerid, gfc_player_clockTextDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, gfc_player_clockTextDraw[playerid], 0);

    return 1;
}

/*----------: Dialogs :----------*/

Dialog:FC_JoinConfirmation(playerid, response, listitem, inputtext[])
{
    
    if(response)
    {
        if(isnull(gfc_config_password))
        {
            AddPlayerToFight(playerid);
        }
        else
        {
            return Dialog_Show(playerid, FC_SubmittedPassword, DIALOG_STYLE_INPUT, 
                               "{FFFFFF}Fight club", "Enter fight password:", "Submit", "Back");
        }  
    }
    return 1;
}

Dialog:FC_SubmittedPassword(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }

    if(strcmp(gfc_config_password, inputtext) == 0)
    {
        AddPlayerToFight(playerid);
    }
    else 
    {
        return Dialog_Show(playerid, FC_SubmittedPassword, DIALOG_STYLE_INPUT, 
            "{FFFFFF}Fight club", "Enter fight password:", "Submit", "Back");
    }
    return 1;
}

Dialog:CheckinDialogResponse(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 0;
    }

    if(listitem == 6)
    {
        if(PlayerData[playerid][pCash] < gfc_player_entryFee[playerid])
        {
           return SendClientMessage(playerid, COLOR_GREY, "You don't have cash for this fight!"); 
        }

        if(gfc_state_machine == STATE_FC_IDLE)
        { 
            gfc_state_machine = STATE_FC_WAITING_FOR_PLAYERS;
            strcpy(gfc_config_password, gfc_player_password[playerid], 24);

            gfc_config_nbOfFighters         = gfc_player_numberOfFighters[playerid];
            gfc_config_entryFee             = gfc_player_entryFee[playerid];
            gfc_config_duration             = gfc_player_duration[playerid];
            gfc_config_health               = gfc_player_health[playerid];
            gfc_config_armor                = gfc_player_armor[playerid];
            for(new i=0;i<4;i++)
            {
                gfc_players_id[i] = -1;
            }
            gfc_config_fightersInField = 0;
            gfc_state_totalMoney = 0;
            gfc_state_joinTimer = SetTimer ("FC_JoinTimeOut", 45000, false);
            SendClientMessage(playerid, COLOR_GREY, "Fighters have 45 seconds to join!"); 
            AddPlayerToFight(playerid);
        }
        else 
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't create a fight there is one already created!"); 
        }
    }
    else
    {
        gfc_player_selectedField[playerid] = listitem;
        Dialog_Show(playerid, FightConfigChanged, DIALOG_STYLE_INPUT, "{FFFFFF}Fight club", gfc_messages[listitem], "Submit", "Back");
    }
    return 1;
}

Dialog:FightConfigChanged(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if( !FC_SetPlayerParameter(playerid,gfc_player_selectedField[playerid],inputtext) )
        {
            return Dialog_Show(playerid, FightConfigChanged, DIALOG_STYLE_INPUT, 
                "{FFFFFF}Fight club", gfc_messages[gfc_player_selectedField[playerid]], "Submit", "Back");
        }
    }
    FC_ShowMainMenu(playerid);
    return 1;
}

/*----------: Timers :----------*/

forward FC_Watch(count);
public FC_Watch(count)
{
    gfc_state_ticks++;
    
    for(new i=0;i<4;i++)
    {
        FC_UpdateTimeForPlayer(gfc_players_id[i]);
    }
    if(gfc_state_ticks >= 60 * gfc_config_duration)
    {
        KillTimer(gfc_state_durationTimer);
    }
}

forward FC_CountDown(count);
public FC_CountDown(count)
{
    if(count == 0)
    {
        gfc_state_machine = STATE_FC_FIGHTING;
        gfc_state_ticks = 0;
        gfc_state_durationTimer = SetTimer ("FC_Watch", 1000, true);
    }

    for(new i=0;i<4;i++)
    {
        if(gfc_players_id[i] != -1)
        {
            if(count == 0)
            {
                TogglePlayerControllable(gfc_players_id[i], true);
                GameTextForPlayer(gfc_players_id[i], "~g~Fight!", 2000, 3);
                PlayerPlaySound(gfc_players_id[i], 1057, 0.0, 0.0, 0.0);    
                FC_UpdateTimeForPlayer(gfc_players_id[i]);
                PlayerTextDrawShow(gfc_players_id[i],gfc_player_clockTextDraw[gfc_players_id[i]]);
            }
            else if(count > 0)
            {
                new
                    string[20];
                format(string, sizeof(string), "~r~%i", count);
                
                GameTextForPlayer(gfc_players_id[i], string, 1500, 3);
                PlayerPlaySound(gfc_players_id[i], 1056, 0.0, 0.0, 0.0);
            }
        }
    }

	count--;

	if(count >= 0)
	{
 		SetTimerEx("FC_CountDown", 1000, false, "i", count);
	}
}

forward FC_JoinTimeOut();
public FC_JoinTimeOut()
{
    
    for(new i=0;i<4;i++)
    {
        if(gfc_players_id[i] != -1)
        {
            SendClientMessage(gfc_players_id[i], COLOR_GREY, "Time out, Fight was cancel!");
            KickPlayerFromFight(gfc_players_id[i], true); // Refund player
        }
    }
    gfc_state_machine = STATE_FC_IDLE;
    return 1;
}

/*----------: Commands :----------*/

CMD:dumpfcstatus(playerid)
{
    if(IsGodAdmin(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GREEN, " ----- FIGHT CLUB STATES -----");
        SendClientMessageEx(playerid, COLOR_GREY, 
        "gfc_state_machine %i, gfc_state_totalMoney %i, gfc_config_fightersInField %i, gfc_config_nbOfFighters %i,",
        _:gfc_state_machine, gfc_state_totalMoney, gfc_config_fightersInField, gfc_config_nbOfFighters);

        SendClientMessageEx(playerid, COLOR_GREY, 
        "gfc_config_password %s, gfc_config_entryFee %i, gfc_config_duration %i, gfc_config_health %i,", 
        gfc_config_password, gfc_config_entryFee, gfc_config_duration, gfc_config_health);

        SendClientMessageEx(playerid, COLOR_GREY,
        "gfc_config_armor %i, gfc_state_joinTimer %i, Player1: %i, Player2:%i , Player3: %i ,  Player4: %i",
        gfc_config_armor, gfc_state_joinTimer, gfc_players_id[0], gfc_players_id[1], gfc_players_id[2], gfc_players_id[3]
        );
        return 1;
	}
    return 0;
}
