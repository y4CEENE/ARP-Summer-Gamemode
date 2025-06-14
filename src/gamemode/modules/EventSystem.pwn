#include <YSI\y_hooks>

// TODO: Anti Weapon hack, Anti Armor/Health hack
// TODO: enable /allhunt
// TODO: Event_TeamFire
// TODO: Event_Request
// TODO: Event_StartRequest
// TODO: Event_Heal
// TODO: EventType_Race
// TODO: EventType_FootRace

#define EVENT_TEAM_1 0
#define EVENT_TEAM_2 1

enum EventState
{
    EventState_Configuration,
    EventState_Published,
    EventState_Locked,
    EventState_Active, // (Fighting)
    EventState_Paused,
    EventState_Ended
};

enum EventType
{
    EventType_DeathMatch,
    EventType_TeamDeathMatch,
    EventType_Race,
    EventType_FootRace
};

enum EventWhiteList
{
    EventWhiteList_All,
    EventWhiteList_VIP,
    EventWhiteList_Gang,
    EventWhiteList_Faction,
    EventWhiteList_GangAndFaction
};

enum EventEnum
{
    Event_Advisor,
    EventState:Event_State,
    EventType:Event_Type,
    Event_JoinMessage[128],
    Event_TeamLimit,
    Event_TeamFire,
    Event_TeamCount[2],
    Event_TeamColor[2],
    Event_TeamSkin[2],
    Float: Event_TeamPosX[2],
    Float: Event_TeamPosY[2],
    Float: Event_TeamPosZ[2],
	Float: Event_TeamPosA[2],
    Event_Interior,
    Event_World,
    Float: Event_Health,
    Float: Event_Armor,
    Event_Weapons[5],
    Event_Time,
    Event_FootRace,
    Event_Players,
    Event_Request,
    Event_StartRequest,
    Event_Creator,
    Event_Staff[5],
    Event_JoinStaff,
    EventWhiteList:Event_WhiteList,
    Event_Heal
};

static EventTop5[2][5][MAX_PLAYER_NAME]; // Top five of each team
static EventPlayersPerPage = 10;
static Event[EventEnum]; 
static JoinedEvent[MAX_PLAYERS];
static EventSelectedPage[MAX_PLAYERS];
static EventSelectedPlayer[MAX_PLAYERS];
static EventTeam[MAX_PLAYERS];

hook OnGameModeInit()
{
    Event[Event_State] = EventState_Configuration;
    ResetEventConfig();
    return 1;
}

hook OnPlayerInit(playerid)
{
    JoinedEvent[playerid] = 0;
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if(eventToken == 1)
    {
        foreach(new i : Player)
        {
            if(killerid == INVALID_PLAYER_ID)
            {
                SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s died. ))", GetRPName(playerid));
            }
            else
            {
                SendClientMessageEx(i, COLOR_LIGHTORANGE, "(( %s was killed by %s. ))", GetRPName(playerid), GetRPName(killerid));
                SetScriptArmour(killerid, 100);
            }
        }
        EventKickPlayer(playerid);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    if(JoinedEvent[playerid])
    {
        Event[Event_TeamCount][EventTeam[playerid]]--;
    }

    for(new i; i < sizeof(Event[Event_Staff]); i++) 
    {
        if(Event[Event_Staff][i] == playerid)
        {
            Event[Event_Staff][i] = INVALID_PLAYER_ID;
            break;
        }
    }
    return 1;
}

hook OnServerHeartBeat(timestamp)
{
    if(Event[Event_State] == EventState_Active && Event[Event_Time] > 0)
    {
        Event[Event_Time]--;
        
        if(Event[Event_Time] == 0)
        {
            SendAdminWarning(2, "Event has been ended automatically time out.");
            EndEvent();
        }
    }
    return 1;
}

GetTeamColorHex(teamid)
{
    switch(Event[Event_TeamColor][teamid])
    {
        case  0: return 0x000000; // black
        case  1: return 0xFFFFFF; // white
        case  2: return 0x2641FE; // blue
        case  3: return 0xAA3333; // red
        case  4: return 0x33AA33; // green
        case  5: return 0xC2A2DA; // purple
        case  6: return 0xFFFF00; // yellow
        case  7: return 0x33CCFF; // lightblue
        case  8: return 0x2D6F00; // darkgreen
        case  9: return 0x0B006F; // darkblue
        case 10: return 0x525252; // darkgrey
        case 11: return 0xB46F00; // brown
        case 12: return 0x814F00; // darkbrown
        case 13: return 0x750A00; // darkred
        case 14: return 0xFF51F1; // pink
    }
    return 0xFFFFFF;
}

ResetEventConfig()
{
    Event[Event_Advisor]            = INVALID_PLAYER_ID;
    Event[Event_Type]               = EventType_DeathMatch;
    format(Event[Event_JoinMessage], sizeof(Event[Event_JoinMessage]), "Welcome to our event!");
    Event[Event_TeamLimit]          = 50;
    Event[Event_TeamFire]           = true;
    Event[Event_TeamCount][0]       = 0;
    Event[Event_TeamCount][1]       = 0;
    Event[Event_TeamColor][0]       = 2;
    Event[Event_TeamColor][1]       = 4;
    Event[Event_TeamSkin][0]        = 72;
    Event[Event_TeamSkin][1]        = 73;
    Event[Event_TeamPosX][0]        = 0.0;
    Event[Event_TeamPosX][1]        = 0.0;
    Event[Event_TeamPosY][0]        = 0.0;
    Event[Event_TeamPosY][1]        = 0.0;
    Event[Event_TeamPosZ][0]        = 0.0;
    Event[Event_TeamPosZ][1]        = 0.0;
    Event[Event_TeamPosA][0]        = 0.0;
    Event[Event_TeamPosA][1]        = 0.0;
    Event[Event_Interior]           = 0;
    Event[Event_World]              = 0;
    Event[Event_Health]             = 100.0;
    Event[Event_Armor]              = 100.0;
    Event[Event_Weapons][0]         = 0;
    Event[Event_Weapons][1]         = 0;
    Event[Event_Weapons][2]         = 0;
    Event[Event_Weapons][3]         = 0;
    Event[Event_Weapons][4]         = 0;
    Event[Event_Time]               = 0;
    Event[Event_FootRace]           = 0;
    Event[Event_Players]            = 0;
    Event[Event_Request]            = 0;
    Event[Event_StartRequest]       = 0;
    Event[Event_Creator]            = 0;
    Event[Event_Staff][0]           = INVALID_PLAYER_ID;
    Event[Event_Staff][1]           = INVALID_PLAYER_ID;
    Event[Event_Staff][2]           = INVALID_PLAYER_ID;
    Event[Event_Staff][3]           = INVALID_PLAYER_ID;
    Event[Event_Staff][4]           = INVALID_PLAYER_ID;
    Event[Event_JoinStaff]          = true;
    Event[Event_WhiteList]          = EventWhiteList_All;
    Event[Event_Heal]               = true;
    EventTop5[0][0][0]              = 0;
    EventTop5[0][1][0]              = 0;
    EventTop5[0][2][0]              = 0;
    EventTop5[0][3][0]              = 0;
    EventTop5[0][4][0]              = 0;
    EventTop5[1][0][0]              = 0;
    EventTop5[1][1][0]              = 0;
    EventTop5[1][2][0]              = 0;
    EventTop5[1][3][0]              = 0;
    EventTop5[1][4][0]              = 0;
}

IsPlayerInEvent(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        return (JoinedEvent[playerid] || (GetPVarInt(playerid, "EventToken") != 0));
    }
    return false;
}

HealPlayersInEvent()
{
    foreach(new playerid: Player)
    {
        if(IsPlayerInEvent(playerid))
        {
            SetPlayerHealth(playerid, Event[Event_Health]);
	        SetPlayerArmour(playerid, Event[Event_Armor]);
        }
    }
}

GetPlayerEventColor(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        if(JoinedEvent[playerid])
        {
            return GetTeamColorHex(EventTeam[playerid]) * 256 + 255;
        }
    }
    return 0;
}

IsEventStaff(playerid)
{
    for(new i=0;i<5;i++)
    {
        if (Event[Event_Staff][i] == playerid)
        {
            return true;
        }
    }
    return false;
}

GetTeamColorName(teamid)
{
    new name[32];
    switch(Event[Event_TeamColor][teamid])
    {
        case  0: name = "Black";
        case  1: name = "White";
        case  2: name = "Blue";
        case  3: name = "Red";
        case  4: name = "Green";
        case  5: name = "Purple";
        case  6: name = "Yellow";
        case  7: name = "Light blue";
        case  8: name = "Dark green";
        case  9: name = "Dark blue";
        case 10: name = "Dark grey";
        case 11: name = "Brown";
        case 12: name = "Dark brown";
        case 13: name = "Dark red";
        case 14: name = "Pink";
        default:
        {
            name = "Unknown";
        }
    }
    return name;
}

GetEventTypeName()
{
    new name[32];

    if(Event[Event_Type] == EventType:EventType_DeathMatch)
    {
        name = "Deathmatch";
    }
    else if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
    {
        name = "Team deathmatch";
    }
    else if(Event[Event_Type] == EventType:EventType_Race)
    {
        name = "Race (Not working)";
    }
    else
    {
        name = "Unknown";
    }
    return name;
}

GetEventWhiteListName()
{
    new name[32];
    
    if(Event[Event_WhiteList] == EventWhiteList:EventWhiteList_All)
    {
        name = "All";
    }
    else if(Event[Event_WhiteList] == EventWhiteList:EventWhiteList_VIP)
    {
        name = "VIP";
    }
    else if(Event[Event_WhiteList] == EventWhiteList:EventWhiteList_Gang)
    {
        name = "Gang";
    }
    else if(Event[Event_WhiteList] == EventWhiteList:EventWhiteList_Faction)
    {
        name = "Faction";
    }
    else if(Event[Event_WhiteList] == EventWhiteList:EventWhiteList_GangAndFaction)
    {
        name = "Gang and faction";
    }
    else
    {
        name = "Unknown";
    }
    return name;
}

LockEvent()
{
    Event[Event_State] = EventState_Locked;
    
	foreach(new i:Player)
	{
	    SendClientMessage(i, COLOR_AQUA, "The event was locked by an admin");
	}
}

CancelEvent()
{
    new kick_players = Event[Event_State] != EventState_Ended;
    Event[Event_State] = EventState_Configuration;
    
	foreach(new i:Player)
	{
        if(JoinedEvent[i])
        {
            if(kick_players)
            {
                EventKickPlayer(i);
                SendClientMessage(i, COLOR_AQUA, "The event was canceled by an admin");
            }
            else
            {
                JoinedEvent[i] = 0;
                Event[Event_TeamCount][EventTeam[i]]--;
            }
        }
	}
    ResetEventConfig();
}

EventKickPlayer(playerid)
{
    new position = Event[Event_TeamCount][EventTeam[playerid]];
    switch(position)
    {
        case 1..5: format(EventTop5[EventTeam[playerid]][position], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));
    }
	JoinedEvent[playerid] = 0;
    Event[Event_TeamCount][EventTeam[playerid]]--;
    DeletePVar(playerid, "EventToken");
	SetPlayerWeapons(playerid);
    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
	SetPlayerToSpawn(playerid);
	return 1;
}

IsEventCreator(playerid)
{
    return Event[Event_Creator] == PlayerData[playerid][pID];
}

PublishEvent(playerid)
{
    Event[Event_State] = EventState_Published;
    Event[Event_Creator] = PlayerData[playerid][pID];
    new msg[128];
    switch(Event[Event_WhiteList])
    {
        case EventWhiteList_Faction:        format(msg, sizeof(msg), "* [Faction %s] New event created by %s /joinevent to join. *", GetEventTypeName(), PlayerData[playerid][pAdminName]);
        case EventWhiteList_GangAndFaction: format(msg, sizeof(msg), "* [Faction and gang %s] New event created by %s /joinevent to join. *", GetEventTypeName(), PlayerData[playerid][pAdminName]);
        case EventWhiteList_Gang:           format(msg, sizeof(msg), "* [Gang %s] New event created by %s /joinevent to join. *", GetEventTypeName(), PlayerData[playerid][pAdminName]);
        case EventWhiteList_VIP:            format(msg, sizeof(msg), "* [VIP %s] New event created by %s /joinevent to join. *", GetEventTypeName(), PlayerData[playerid][pAdminName]);
        default:                            format(msg, sizeof(msg), "* [%s] New event created by %s /joinevent to join. *", GetEventTypeName(), PlayerData[playerid][pAdminName]);
    }

    
    
    for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
    {
        JoinedEvent[targetid] = 0;

        if(IsPlayerConnected(targetid))
        {
	        SendClientMessage(targetid, COLOR_AQUA, msg);
        }
    }
}

publish EventCount_Three()
{
    foreach(new i:Player)
	{
        if(JoinedEvent[i])
        {
	        SendClientMessage(i, COLOR_AQUA, "[Event] 3");
        }
	}
 	return 1;
}

publish EventCount_Two()
{
    foreach(new i:Player)
	{
        if(JoinedEvent[i])
        {
	        SendClientMessage(i, COLOR_AQUA, "[Event] 2");
        }
	}
 	return 1;
}

publish EventCount_One()
{
    foreach(new i:Player)
	{
        if(JoinedEvent[i])
        {
	        SendClientMessage(i, COLOR_AQUA, "[Event] 1");
        }
	}
 	return 1;
}

publish EventCount_GoGoGo()
{
    StartEvent();
	return 1;
}

StartEvent()
{
    Event[Event_State] = EventState_Active;
    
	foreach(new i:Player)
	{
        if(JoinedEvent[i])
        {
            if(Event[Event_Weapons][0]!=-1)
            {
                GivePlayerWeaponEx(i, Event[Event_Weapons][0], true);
            }
            if(Event[Event_Weapons][1]!=-1)
            {
                GivePlayerWeaponEx(i, Event[Event_Weapons][1], true);
            }
            if(Event[Event_Weapons][2]!=-1)
            {
                GivePlayerWeaponEx(i, Event[Event_Weapons][2], true);
            }
            if(Event[Event_Weapons][3]!=-1)
            {
                GivePlayerWeaponEx(i, Event[Event_Weapons][3], true);
            }
            if(Event[Event_Weapons][4]!=-1)
            {
                GivePlayerWeaponEx(i, Event[Event_Weapons][4], true);
            }
	        SendClientMessage(i, COLOR_AQUA, "[Event] Go Go Go !");
        }
	}
}


EndEvent()
{
    Event[Event_State] = EventState_Ended;
    foreach(new i:Player)
	{
        if(JoinedEvent[i])
        {
            EventKickPlayer(i);
	        SendClientMessage(i, COLOR_AQUA, "You was kicked from the event as the event ended.");
            JoinedEvent[i] = 1; // Top players
        }
    }
}

AddPlayerToEvent(playerid, teamid = -1)
{
    SavePlayerVariables(playerid);
    
    SetPVarInt(playerid, "EventToken", 1);
    PlayerData[playerid][pTazer] = 0;
	JoinedEvent[playerid] = 1;
	ResetPlayerWeapons(playerid);
    new targetteamid = 0;

    if(teamid == -1)
    {
        if((Event[Event_TeamCount][1] < Event[Event_TeamCount][0]) && (Event[Event_Type] == EventType_TeamDeathMatch))
        {
            targetteamid = 1;
        }
    }
    else
    {
        targetteamid = teamid;
    }
    
    EventTeam[playerid] = targetteamid;
    Event[Event_TeamCount][targetteamid]++;
    
    new Float:x = Event[Event_TeamPosX][targetteamid];
    new Float:y = Event[Event_TeamPosY][targetteamid];
    new Float:z = Event[Event_TeamPosZ][targetteamid];
    new Float:a = Event[Event_TeamPosA][targetteamid];

    TeleportToCoords(playerid, x, y, z, a, Event[Event_Interior], Event[Event_World], true, false);
    
    SetPlayerSkin(playerid, Event[Event_TeamSkin][targetteamid]);
	SetPlayerHealth(playerid,  Event[Event_Health]);
	SetPlayerArmour(playerid, Event[Event_Armor]);
    // COLOR IS SET AUTOMATICALLY
    SendClientMessageEx(playerid, COLOR_AQUA, "[Event] %s", Event[Event_JoinMessage]);
	GameTextForPlayer(playerid, "Event time!", 3000, 3);

    if(Event[Event_State] == EventState_Active)
    {
        if(Event[Event_Weapons][0]!=-1)
        {
            GivePlayerWeaponEx(playerid, Event[Event_Weapons][0], true);
        }
        if(Event[Event_Weapons][1]!=-1)
        {
            GivePlayerWeaponEx(playerid, Event[Event_Weapons][1], true);
        }
        if(Event[Event_Weapons][2]!=-1)
        {
            GivePlayerWeaponEx(playerid, Event[Event_Weapons][2], true);
        }
        if(Event[Event_Weapons][3]!=-1)
        {
            GivePlayerWeaponEx(playerid, Event[Event_Weapons][3], true);
        }
        if(Event[Event_Weapons][4]!=-1)
        {
            GivePlayerWeaponEx(playerid, Event[Event_Weapons][4], true);
        }
        SendClientMessage(playerid, COLOR_AQUA, "[Event] Go Go Go !");
    }

}

ShowEventPublishedDialog(playerid)
{
    if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
    {
        Dialog_Show(playerid, ActiveEventDlg, DIALOG_STYLE_LIST, "Event::Published", "Add player\nHeal all players\nTeam 1 players: %d\nTeam 2 players: %d\nLock event\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0], Event[Event_TeamCount][1]);
    }
    else
    {
        Dialog_Show(playerid, ActiveEventDlg, DIALOG_STYLE_LIST, "Event::Published", "Add player\nHeal all players\nPlayers: %d\nLock event\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0]);
    }
    return 1;
}

ShowEventLockedDialog(playerid)
{
    if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
    {
        Dialog_Show(playerid, ActiveEventDlg, DIALOG_STYLE_LIST, "Event::Published", "Add player\nHeal all players\nTeam 1 players: %d\nTeam 2 players: %d\nStart event\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0], Event[Event_TeamCount][1]);
    }
    else
    {
        Dialog_Show(playerid, ActiveEventDlg, DIALOG_STYLE_LIST, "Event::Published", "Add player\nHeal all players\nPlayers: %d\nStart event\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0]);
    }
    return 1;
}

ShowEventActiveDialog(playerid)
{
    if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
    {
        Dialog_Show(playerid, ActiveEventDlg, DIALOG_STYLE_LIST, "Event::Published", "Add player\nHeal all players\nTeam 1 players: %d\nTeam 2 players: %d\nEnd event\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0], Event[Event_TeamCount][1]);
    }
    else
    {
        Dialog_Show(playerid, ActiveEventDlg, DIALOG_STYLE_LIST, "Event::Published", "Add player\nHeal all players\nPlayers: %d\nEnd event\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0]);
    }
    return 1;
}

ShowEventEndedDialog(playerid)
{
    if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
    {
        Dialog_Show(playerid, EventEndDialog, DIALOG_STYLE_LIST, "Event::Published", "Team 1 top players: %d\nShow team 1 top 5\nTeam 2 top players: %d\nShow team 2 top 5\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0], Event[Event_TeamCount][1]);
    }
    else
    {
        Dialog_Show(playerid, EventEndDialog, DIALOG_STYLE_LIST, "Event::Published", "Top players: %d\nShow top 5\nCancel event", "Select", "Cancel", Event[Event_TeamCount][0]);
    }
    return 1;
}

Dialog:EventEndDialog(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    switch(listitem)
    {
        case 0:
        {
            ShowEventListPlayers(playerid, 0, 0);
        }
        case 1:
        {
            new string[256];
            for(new i=0;i<5;i++)
            {
                if(!isnull(EventTop5[0][i]))
                {
                    if(i==0)
                    {
                        format(string, sizeof(string), "Position %d: %s", i, EventTop5[0][i]);
                    }
                    else
                    {
                        format(string, sizeof(string), "%s\nPosition %d: %s", string, i, EventTop5[0][i]);
                    }
                }
            }
            if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Team 1 top 5", string, "Ok", "Cancel");
            }
            else
            {
                Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Top 5", string, "Ok", "Cancel");
            }
        }
        case 2:
        {
            if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                ShowEventListPlayers(playerid, 1, 0);
            }
            else
            {
                CancelEvent();
                SendAdminWarning(2, "The event was canceled by %s", GetPlayerNameEx(playerid));
            }
        }
        case 3:
        {
            new string[256];
            for(new i=0;i<5;i++)
            {
                if(!isnull(EventTop5[0][i]))
                {
                    if(i==0)
                    {
                        format(string, sizeof(string), "Position %d: %s", i, EventTop5[0][i]);
                    }
                    else
                    {
                        format(string, sizeof(string), "%s\nPosition %d: %s", string, i, EventTop5[0][i]);
                    }
                }
            }
            Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Team 2 top 5", string, "Ok", "Cancel");
        }
        case 4:
        {            
            CancelEvent();
            SendAdminWarning(2, "The event was canceled by %s", GetPlayerNameEx(playerid));
        }
    }
    return 1;
}

ShowEventListPlayers(playerid, teamid, page)
{
    new targetpage = page;
    new totalplayers = Event[Event_TeamCount][0];
    new totalpages = totalplayers / EventPlayersPerPage;
    if((totalpages) * EventPlayersPerPage < totalplayers)
    {
        totalpages += 1;
    }

    if(targetpage < 1)
    {
        targetpage = 0;
    }

    if(targetpage > totalpages)
    {
        targetpage = totalpages;
    }
    
    EventSelectedPage[playerid] = targetpage + teamid * 1000;
    
    new startidx = EventPlayersPerPage * targetpage;
    new menu[320];
    new idx = 0;
    menu[0] = 0;

    foreach(new targetid : Player)
    {
        if(JoinedEvent[targetid] && EventTeam[targetid] == teamid)
        {
            if(startidx <= idx < startidx + EventPlayersPerPage)
            {
                if(menu[0] == 0)
                {
                    format(menu, sizeof(menu), "[%03d] %s", targetid, GetPlayerNameEx(targetid));
                }
                else
                {
                    format(menu, sizeof(menu), "%s\n[%03d] %s",menu, targetid, GetPlayerNameEx(targetid));
                }
            }
            else if(idx >= startidx + EventPlayersPerPage)
            {
                break;
            }
            idx++;
        }
    }

    if(menu[0] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "[Event] Nothing to display.");
    }

    new title[128];
    format(title, sizeof(title), "Event::ListPlayers Page %d/%d", (targetpage + 1), totalpages);

    if(totalpages == targetpage)
    {
        Dialog_Show(playerid, EventListPlayers, DIALOG_STYLE_LIST, title, menu, "Select", "Cancel");
    }
    else
    {
        Dialog_Show(playerid, EventListPlayers, DIALOG_STYLE_LIST, title, menu, "Select", "Next");
    }
    return 1;
}

Dialog:EventListPlayers(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        new totalplayers = Event[Event_TeamCount][0];
        new totalpages = totalplayers / EventPlayersPerPage;
        if((totalpages) * EventPlayersPerPage < totalplayers)
        {
            totalpages += 1;
        }
        new selectedpage = EventSelectedPage[playerid] % 1000;
        if(totalpages <= selectedpage)
        {
            callcmd::event(playerid, inputtext);
        }
        else
        {
            new teamid = EventSelectedPage[playerid] / 1000;
            ShowEventListPlayers(playerid, teamid, selectedpage + 1);
        }
        return 1;
    }
    new string[64];
    format(string, sizeof(string), "%.*s", 3, inputtext[1]);
    new targetid = strval(string);
    EventSelectedPlayer[playerid] = targetid;
    format(string, sizeof(string), "Event::Player [%03d] %s", targetid, GetPlayerNameEx(targetid));

    Dialog_Show(playerid, EventSelectPlayer, DIALOG_STYLE_LIST, string, "Kick player\nHeal\nSwitch team", "Select", "Cancel", Event[Event_TeamCount][0]);

    return 1;
}

Dialog:EventSelectPlayer(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new targetid = EventSelectedPlayer[playerid];
        switch(listitem)
        {
            case 0:
            {
                if(JoinedEvent[targetid])
                {
                    EventKickPlayer(targetid);
                    SendClientMessageEx(playerid, COLOR_GREY, "{007ACC}[Event Info]{525252} [%03d]{FFFFFF} %s was kicked from event by %s", targetid, GetPlayerNameEx(targetid), GetPlayerNameEx(playerid));
                }
                else
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "{007ACC}[Event Info]{525252} [%03d]{FFFFFF} %s is not in the event", targetid, GetPlayerNameEx(targetid) );
                }
            }
            case 1:
            {
                SetPlayerHealth(targetid, Event[Event_Health]);
                SetPlayerArmour(targetid, Event[Event_Armor]);
                SendClientMessageEx(playerid, COLOR_GREY, "{007ACC}[Event Info]{525252} [%03d]{FFFFFF} %s was healed by %s", targetid, GetPlayerNameEx(targetid), GetPlayerNameEx(playerid));
            }
            case 2:
            {
                if(Event[Event_Type] == EventType:EventType_TeamDeathMatch && (Event[Event_State] == EventState_Locked || Event[Event_State] == EventState_Published))
                {
                    if(EventTeam[targetid] == 0)
                    {
                        Event[Event_TeamCount][0] --;
                        AddPlayerToEvent(playerid, 1);
                    }
                    else
                    {
                        Event[Event_TeamCount][1] --;
                        AddPlayerToEvent(playerid, 0);
                    }
                }
                else
                {
                    SendClientMessageEx(playerid, COLOR_GREY, "{007ACC}[Event Info]{525252} Cannot switch team members for the moment");
                }
            }
        }
    }

    new totalplayers = Event[Event_TeamCount][0];
    new totalpages = totalplayers / EventPlayersPerPage;
    if((totalpages) * EventPlayersPerPage < totalplayers)
    {
        totalpages += 1;
    }
    new selectedpage = EventSelectedPage[playerid] % 1000;
    if(totalpages <= selectedpage)
    {
        callcmd::event(playerid, inputtext);
    }
    else
    {
        new teamid = EventSelectedPage[playerid] / 1000;
        ShowEventListPlayers(playerid, teamid, selectedpage);
    }
    return 1;
}

Dialog:EventInvitePlayer(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new targetid = strval(inputtext);

    if(IsNumeric(inputtext))
	{
		if(IsPlayerConnected(targetid))
		{
            if(JoinedEvent[targetid])
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "[%d] %s already in the event.", targetid, GetPlayerNameEx(targetid));
            }

            if(IsAdminOnDuty(targetid, false))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "[%d] %s is onduty and he can't join the event.", targetid, GetPlayerNameEx(targetid));
            }
            
            if(IsEventStaff(targetid))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "[%d] %s is in event staff and he can't join.", targetid, GetPlayerNameEx(targetid));
            }

            AddPlayerToEvent(targetid);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
		}
	}
	else if(strlen(inputtext) < 2)
	{
	    SendClientMessage(playerid, COLOR_GREY, "Please input at least two characters to search.");
	}
    else
    {
        new count = 0;
        new name[32];
        foreach(new i : Player)
	    {
	        GetPlayerName(i, name, sizeof(name));

	        if(strfind(name, inputtext, true) != -1)
	        {
                targetid = i;
	            count++;
			}
		}

		if(!count)
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "No results found for \"%s\". Please narrow your search.", inputtext);
		}
        else if(count > 1)
        {
		    SendClientMessageEx(playerid, COLOR_GREY, "There is more than one player with \"%s\" in his name. Please narrow your search.", inputtext);
        }
        else
        {
            AddPlayerToEvent(targetid);
        }
    }
    return 1;
}
Dialog:ActiveEventDlg(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    new todo = 0;
    switch(listitem)
    {
        case 0:
        {
            Dialog_Show(playerid, EventInvitePlayer, DIALOG_STYLE_INPUT, "Event::Published", "Enter player id or part of name to invite:", "Ok", "Cancel");
        }
        case 1:
        {
            if(Event[Event_State] == EventState_Active && !Event[Event_Heal])
            {
                return SendClientMessage(playerid, COLOR_GREY, "Event heal is disabled.");
            }
            HealPlayersInEvent();
        }
        case 2:
        {
            ShowEventListPlayers(playerid, 0, 0);
        }
        case 3:
        {
            if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                ShowEventListPlayers(playerid, 1, 0);
            }
            else
            {
                todo = 1;
            }
        }
        case 4:
        {
            if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                todo = 1;
            }
            else
            {
                todo = 2;
            }
        }
        case 5:
        {
            
            if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                todo = 2;
            }
        }
    }

    if(todo == 1)
    {
        if(!IsEventCreator(playerid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Only event creator can change event state.");
        }
        switch(Event[Event_State])
        {
            case EventState_Published:  { LockEvent();  }
            case EventState_Locked:     
            { 
                SetTimer("EventCount_Three", 1000, 0);
                SetTimer("EventCount_Two", 2000, 0);
                SetTimer("EventCount_One", 3000, 0);
                SetTimer("EventCount_GoGoGo", 4000, 0);
            }
            case EventState_Active:     { EndEvent();   }
        }
        
    }
    else if(todo == 2)
    {
        SendAdminWarning(2, "The event was canceled by %s", GetPlayerNameEx(playerid));
        CancelEvent();
    }

    return 1;
}

ShowEventConfigurationDialog(playerid)
{
    new menu[1024];
    format(menu, sizeof(menu), "Parameter\tValue\n{007ACC}Type\t{C3C3C3}%s\n{007ACC}Join message\t{C3C3C3}%s\n{007ACC}Time in seconds (0 for infinite)\t{C3C3C3}%d\n{007ACC}Health\t{C3C3C3}%.2f\n{007ACC}Armor\t{C3C3C3}%.2f", GetEventTypeName(), Event[Event_JoinMessage], Event[Event_Time], Event[Event_Health], Event[Event_Armor]);
    
    for(new idx=0;idx<5;idx++)
    {
        if(Event[Event_Weapons][idx] == 0)
        {
            format(menu, sizeof(menu), "%s\n{007ACC}Weapon %d\t{C3C3C3}None", menu, idx);
        }
        else
        {
            format(menu, sizeof(menu), "%s\n{007ACC}Weapon %d\t{C3C3C3}%s", menu, idx, GetWeaponNameEx(Event[Event_Weapons][idx]));
        }
    }
    
    if(Event[Event_JoinStaff])
    {
        format(menu, sizeof(menu), "%s\n{007ACC}JoinStaff\t{00FF00}Enabled", menu);
    }
    else
    {
        format(menu, sizeof(menu), "%s\n{007ACC}JoinStaff\t{FF0000}Disabled", menu);        
    }

    format(menu, sizeof(menu), "%s\n{007ACC}Players limit\t{C3C3C3}%d", menu, Event[Event_TeamLimit]);

    if(Event[Event_Heal])
    {
        format(menu, sizeof(menu), "%s\n{007ACC}Heal:\t{00FF00}Enabled", menu);
    }
    else
    {
        format(menu, sizeof(menu), "%s\n{007ACC}Heal\t{FF0000}Disabled", menu);        
    }
    
    format(menu, sizeof(menu), "%s\n{007ACC}WhiteList\t{C3C3C3}%s", menu, GetEventWhiteListName());
    
    if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
    {
        format(menu, sizeof(menu), "%s\n{007ACC}Team 1 skin\t{C3C3C3}%d", menu, Event[Event_TeamSkin][0]);
        format(menu, sizeof(menu), "%s\n{007ACC}Team 2 skin\t{C3C3C3}%d", menu, Event[Event_TeamSkin][1]);
        if(Event[Event_TeamFire])
        {
            format(menu, sizeof(menu), "%s\n{007ACC}Team fire\t{00FF00}Enabled", menu);
        }
        else
        {
            format(menu, sizeof(menu), "%s\n{007ACC}Team fire\t{FF0000}Disabled", menu);
        }
        format(menu, sizeof(menu), "%s\n{007ACC}Team 1 color\t{%06x}%s", menu, GetTeamColorHex(0), GetTeamColorName(0));
        format(menu, sizeof(menu), "%s\n{007ACC}Team 2 color\t{%06x}%s", menu, GetTeamColorHex(1), GetTeamColorName(1));
        format(menu, sizeof(menu), "%s\n{007ACC}Team 1 spawn point\t ", menu);
        format(menu, sizeof(menu), "%s\n{007ACC}Team 2 spawn point\t ", menu);
    }
    else
    {
        format(menu, sizeof(menu), "%s\n{007ACC}Skin\t{C3C3C3}%d", menu, Event[Event_TeamSkin][0]);
        format(menu, sizeof(menu), "%s\n{007ACC}Spawn point\t ", menu);
    }

    format(menu, sizeof(menu), "%s\n{007ACC}Publish event\t ", menu);

	Dialog_Show(playerid, EventConfigurationDlg, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Event::Configuration", menu, "Select", "Cancel");
    return 1;
}

Dialog:EventConfigurationDlg(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }

    switch(listitem)
    {
        case 0:
        {
            new EventType:new_type = EventType:EventType_DeathMatch;
            if (Event[Event_Type] == EventType:EventType_DeathMatch)
            {
                new_type = EventType:EventType_TeamDeathMatch;
            }
            else if (Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                new_type = EventType:EventType_Race;
            }
            Event[Event_Type] = new_type;
            ShowEventConfigurationDialog(playerid);
        }
        case 1:
        {
            Dialog_Show(playerid, EventJoinMessage, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter join message:", "Ok", "Cancel");
        }
        case 2:
        {
            Dialog_Show(playerid, EventEditTime, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter event time (min: 0, max: 36000):\n 0 for infinite\nUnit: seconds", "Ok", "Cancel");
        }
        case 3:
        {
            Dialog_Show(playerid, EventEditHealth, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter health value (min: 1hp, max: 250hp):", "Ok", "Cancel");
        }
        case 4:
        {
            Dialog_Show(playerid, EventEditArmor, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter armor value (min: 1hp, max: 250hp):", "Ok", "Cancel");
        }
        case 5:
        {
            Dialog_Show(playerid, EventEditWeapon1, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter Weapon 1:", "Ok", "Cancel");
        }
        case 6:
        {
            Dialog_Show(playerid, EventEditWeapon2, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter Weapon 2:", "Ok", "Cancel");
        }
        case 7:
        {
            Dialog_Show(playerid, EventEditWeapon3, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter Weapon 3:", "Ok", "Cancel");
        }
        case 8:
        {
            Dialog_Show(playerid, EventEditWeapon4, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter Weapon 4:", "Ok", "Cancel");
        }
        case 9:
        {
            Dialog_Show(playerid, EventEditWeapon5, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter Weapon 5:", "Ok", "Cancel");
        }
        case 10:
        {
            if(Event[Event_JoinStaff])
            {
                Event[Event_JoinStaff] = 0;
            }
            else
            {
                Event[Event_JoinStaff] = 1;
            }
            ShowEventConfigurationDialog(playerid);
        }
        case 11:
        {
            Dialog_Show(playerid, EventEditPlayerLimit, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter player limit per team(min: 2, max: 100):", "Ok", "Cancel");
        }
        case 12:
        {
            if(Event[Event_Heal])
            {
                Event[Event_Heal] = 0;
            }
            else
            {
                Event[Event_Heal] = 1;
            }
            ShowEventConfigurationDialog(playerid);
        }
        case 13:
        {
            Dialog_Show(playerid, EventEditWhitelist, DIALOG_STYLE_LIST, "Event::Configuration Whitelist", "All players\nVIP\nGang\nFaction\nGang and faction", "Select", "Cancel");
        }
        case 14:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, EventEditTeam1Skin, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter team 1 skin id:", "Ok", "Cancel");
            }
            else
            {
                Dialog_Show(playerid, EventEditTeam1Skin, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter player skin id:", "Ok", "Cancel");
            }
        }
        case 15:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, EventEditTeam2Skin, DIALOG_STYLE_INPUT, "Event::Configuration", "Enter team 2 skin id:", "Ok", "Cancel");
            }
            else
            {
                Dialog_Show(playerid, EventEditSpawnPoint1, DIALOG_STYLE_LIST, "Event::Configuration Spawn point", "Set\nGoto", "Select", "Cancel");
            }
        } 
        case 16:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                if(Event[Event_TeamFire])
                {
                    Event[Event_TeamFire] = 0;
                }
                else
                {
                    Event[Event_TeamFire] = 1;
                }
                ShowEventConfigurationDialog(playerid);
            }
            else
            {
                if(Event[Event_State] != EventState_Configuration)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Cannot published event if it's not in event configuration.");
                }

                if(!( 1 <= Event[Event_Health] <= 250))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Unvalid health value (min: 1hp, max: 250hp).");
                }

                if(!( 1 <= Event[Event_Armor] <= 250))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Unvalid armor value (min: 1hp, max: 250hp).");
                }

                for(new i = 0 ; i < 4 ; i++)
                {
                    for(new j = i + 1 ; j < 5 ; j++)
                    {
                        if(Event[Event_Weapons][i] == Event[Event_Weapons][j] && Event[Event_Weapons][i] != 0)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Duplicated weapons");
                        }
                    }
                }

                if( !(2 <= Event[Event_TeamLimit] <= 100))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Max players must be between 2 and 100.");
                }

                if((Event[Event_TeamPosX][0] == 0.0) && (Event[Event_TeamPosY][0] == 0.0) && (Event[Event_TeamPosZ][0] == 0.0))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Spawn point is not set.");
                }

                PublishEvent(playerid);
            }
        }
        case 17:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, EventEditTeamColor1, DIALOG_STYLE_LIST, "Event::Configuration Team 1 color", "Black\nWhite\nBlue\nRed\nGreen\nPurple\nYellow\nLight blue\nDark green\nDark blue\nDark grey\nBrown\nDark brown\nDark red\nPink", "Select", "Cancel");
            }
        }
        case 18:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, EventEditTeamColor2, DIALOG_STYLE_LIST, "Event::Configuration Team 2 color", "Black\nWhite\nBlue\nRed\nGreen\nPurple\nYellow\nLight blue\nDark green\nDark blue\nDark grey\nBrown\nDark brown\nDark red\nPink", "Select", "Cancel");
            }
        }
        case 19:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, EventEditSpawnPoint1, DIALOG_STYLE_LIST, "Event::Configuration Team 1 spawn point", "Set\nGoto", "Select", "Cancel");
            }
        }
        case 20:
        {
            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                Dialog_Show(playerid, EventEditSpawnPoint2, DIALOG_STYLE_LIST, "Event::Configuration Team 2 spawn point", "Set\nGoto", "Select", "Cancel");
            }
        }
        case 21:
        {
            if(Event[Event_State] != EventState_Configuration)
            {
                return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Cannot published event if it's not in event configuration.");
            }

            if(Event[Event_Type] == EventType:EventType_TeamDeathMatch)
            {
                if(!( 1 <= Event[Event_Health] <= 250))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Unvalid health value (min: 1hp, max: 250hp).");
                }

                if(!( 1 <= Event[Event_Armor] <= 250))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Unvalid armor value (min: 1hp, max: 250hp).");
                }

                for(new i = 0 ; i < 4 ; i++)
                {
                    for(new j = i + 1 ; j < 5 ; j++)
                    {
                        if(Event[Event_Weapons][i] == Event[Event_Weapons][j] && Event[Event_Weapons][i] != 0)
                        {
                            return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Duplicated weapons");
                        }
                    }
                }

                if( !(2 <= Event[Event_TeamLimit] <= 100))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Max team players must be between 2 and 100.");
                }

                if(Event[Event_TeamColor][0] == Event[Event_TeamColor][1])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Both teams cannot have same color.");
                }

                if(Event[Event_TeamSkin][0] == Event[Event_TeamSkin][1])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Both teams cannot have same skin.");
                }
                
                if((Event[Event_TeamPosX][0] == 0.0) && (Event[Event_TeamPosY][0] == 0.0) && (Event[Event_TeamPosZ][0] == 0.0))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Spawn point for team 1 is not set.");
                }

                if((Event[Event_TeamPosX][1] == 0.0) && (Event[Event_TeamPosY][1] == 0.0) && (Event[Event_TeamPosZ][1] == 0.0))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Spawn point for team 2 is not set.");
                }

                if((Event[Event_TeamPosX][0] == Event[Event_TeamPosX][1]) && (Event[Event_TeamPosY][0] == Event[Event_TeamPosY][1]) && (Event[Event_TeamPosZ][0] == Event[Event_TeamPosZ][1]))
                {
                    return SendClientMessage(playerid, COLOR_GREY, "[Event::Error] Both teams cannot have same spawn point.");
                }



                PublishEvent(playerid);
            }
        }
    }
    return 1;
}

Dialog:EventEditSpawnPoint1(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(listitem == 0)
        {
            // SET
            GetPlayerPos(playerid, Event[Event_TeamPosX][0], Event[Event_TeamPosY][0], Event[Event_TeamPosZ][0]);
            GetPlayerFacingAngle(playerid, Event[Event_TeamPosA][0]);
            Event[Event_Interior] = GetPlayerInterior(playerid);
            Event[Event_World] = GetPlayerVirtualWorld(playerid);
        }
        else if(listitem == 1)
        {
            // GOTO
            new Float: x = Event[Event_TeamPosX][0];
            new Float: y = Event[Event_TeamPosY][0];
            new Float: z = Event[Event_TeamPosZ][0];
            new Float: a = Event[Event_TeamPosA][0];
            SetPlayerPos(playerid, x, y, z);
            SetPlayerFacingAngle(playerid, a);
            SetPlayerInterior(playerid, Event[Event_Interior]);
            SetPlayerVirtualWorld(playerid, Event[Event_World]);
            return 1;
        }
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditSpawnPoint2(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(listitem == 0)
        {
            // SET
            GetPlayerPos(playerid, Event[Event_TeamPosX][1], Event[Event_TeamPosY][1], Event[Event_TeamPosZ][1]);
            GetPlayerFacingAngle(playerid, Event[Event_TeamPosA][1]);
            Event[Event_Interior] = GetPlayerInterior(playerid);
            Event[Event_World] = GetPlayerVirtualWorld(playerid);
        }
        else if(listitem == 1)
        {
            // GOTO
            new Float: x = Event[Event_TeamPosX][1];
            new Float: y = Event[Event_TeamPosY][1];
            new Float: z = Event[Event_TeamPosZ][1];
            new Float: a = Event[Event_TeamPosA][1];
            SetPlayerPos(playerid, x, y, z);
            SetPlayerFacingAngle(playerid, a);
            SetPlayerInterior(playerid, Event[Event_Interior]);
            SetPlayerVirtualWorld(playerid, Event[Event_World]);
            return 1;
        }
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditTeamColor1(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        Event[Event_TeamColor][0] = listitem;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditTeamColor2(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        Event[Event_TeamColor][1] = listitem;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditTeam1Skin(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new skin = strval(inputtext);
        if(skin < 0)
        {
            skin = 0;
        }
        if(skin > 312)
        {
            skin = 312;
        }
        Event[Event_TeamSkin][0] = skin;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditTeam2Skin(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new skin = strval(inputtext);
        if(skin < 0)
        {
            skin = 0;
        }
        if(skin > 312)
        {
            skin = 312;
        }
        Event[Event_TeamSkin][1] = skin;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditWhitelist(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0: Event[Event_WhiteList] = EventWhiteList_All;
            case 1: Event[Event_WhiteList] = EventWhiteList_VIP;
            case 2: Event[Event_WhiteList] = EventWhiteList_Gang;
            case 3: Event[Event_WhiteList] = EventWhiteList_Faction;
            case 4: Event[Event_WhiteList] = EventWhiteList_GangAndFaction;
        }
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditPlayerLimit(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new limit = strval(inputtext);

        if(limit < 2)
        {
            limit = 2;
        }

        if(limit > 100)
        {
            limit = 100;
        }

        Event[Event_TeamLimit] = limit;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditWeapon1(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new weapon = strval(inputtext);

        if(weapon < 0)
        {
            weapon = 0;
        }

        if(weapon > 46)
        {
            weapon = 0;
        }

        Event[Event_Weapons][0] = weapon;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}
Dialog:EventEditWeapon2(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new weapon = strval(inputtext);

        if(weapon < 0)
        {
            weapon = 0;
        }

        if(weapon > 46)
        {
            weapon = 0;
        }

        Event[Event_Weapons][1] = weapon;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}
Dialog:EventEditWeapon3(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new weapon = strval(inputtext);

        if(weapon < 0)
        {
            weapon = 0;
        }

        if(weapon > 46)
        {
            weapon = 0;
        }

        Event[Event_Weapons][2] = weapon;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}
Dialog:EventEditWeapon4(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new weapon = strval(inputtext);

        if(weapon < 0)
        {
            weapon = 0;
        }

        if(weapon > 46)
        {
            weapon = 0;
        }

        Event[Event_Weapons][3] = weapon;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}
Dialog:EventEditWeapon5(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new weapon = strval(inputtext);

        if(weapon < 0)
        {
            weapon = 0;
        }

        if(weapon > 46)
        {
            weapon = 0;
        }

        Event[Event_Weapons][4] = weapon;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventJoinMessage(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        format(Event[Event_JoinMessage], sizeof(Event[Event_JoinMessage]), inputtext);
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditTime(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new time = strval(inputtext);

        if(time < 0)
        {
            time = 0;
        }

        if(time > 36000)
        {
            time = 36000;
        }
        
        Event[Event_Time] = time;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

Dialog:EventEditHealth(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new health = strval(inputtext);

        if(health < 1)
        {
            health = 1;
        }

        if(health > 250)
        {
            health = 250;
        }
        
        Event[Event_Health] = health;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}
Dialog:EventEditArmor(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new armor = strval(inputtext);

        if(armor < 1)
        {
            armor = 1;
        }

        if(armor > 250)
        {
            armor = 250;
        }
        
        Event[Event_Armor] = armor;
    }
    ShowEventConfigurationDialog(playerid);
    return 1;
}

CMD:event(playerid, params[])
{
    if(!IsAdmin(playerid, 5))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    
    switch(Event[Event_State])
    {
        case EventState_Configuration: ShowEventConfigurationDialog (playerid);
        case EventState_Published:     ShowEventPublishedDialog     (playerid);
        case EventState_Locked:        ShowEventLockedDialog        (playerid);
        case EventState_Active:        ShowEventActiveDialog        (playerid);
        case EventState_Ended:         ShowEventEndedDialog         (playerid);

    }
    
    return 1;
}

CMD:joinevent(playerid, params[])
{
    if(Event[Event_State] == EventState_Configuration || Event[Event_State] == EventState_Ended)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no event for the moment.");
    }
    else if(Event[Event_State] != EventState_Published)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There event is locked or started.");
    }

    if(PlayerData[playerid][pLevel] < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Only level 3+ can join events.");
    }

    if(JoinedEvent[playerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are already in the event.");
    }

    if(IsAdminOnDuty(playerid, false))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't join event as you are on admin duty.");
    }
    
    if(IsEventStaff(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You can't join event as you are in event staff.");
    }

    switch(Event[Event_WhiteList])
    {
        case EventWhiteList_VIP:
        {
	        if(!PlayerData[playerid][pDonator])
            {
                return SendClientMessage(playerid, COLOR_GREY, "Only VIP are allowed to join event.");
            }
        }
        case EventWhiteList_Gang:
        {
            if(PlayerData[playerid][pGang] == -1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Only gang members are allowed to join event.");
            }
        }
        case EventWhiteList_Faction:
        {
            if(GetPlayerFaction(playerid) == FACTION_NONE)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Only faction members are allowed to join event.");
            }
        }
        case EventWhiteList_GangAndFaction:
        {
            if(GetPlayerFaction(playerid) == FACTION_NONE && PlayerData[playerid][pGang] == -1)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Only gang and faction members are allowed to join event.");
            }
        }
    }
    AddPlayerToEvent(playerid);
    return 1;
}

CMD:eventhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    SendClientMessage(playerid, COLOR_GREY, "*** EVENT HELP *** type a command for more information");
    
    if(IsAdmin(playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE,"*** EVENT HELP *** /event /eventstaff /quiteventstaff /joinevent /quitevent");
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE,"*** EVENT HELP *** /joinevent /quitevent");
    }    
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
    
    return 1;
}

CMD:quitevent(playerid, params[])
{
    if(!JoinedEvent[playerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not in an event.");
    }
    EventKickPlayer(playerid);
    return 1;
}

CMD:eventstaff(playerid, params[])
{
    if(!IsAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }
    if(Event[Event_State] == EventState_Configuration || Event[Event_State] == EventState_Ended)
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is no event for the moment.");
    }
    if(!IsAdminOnDuty(playerid, false))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You're not on-duty as admin.");
    }

    if(IsEventStaff(playerid)) 
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are already in event staff.");
    }

    for(new i; i < sizeof(Event[Event_Staff]); i++) 
    {
        
        if(Event[Event_Staff][i] == INVALID_PLAYER_ID)
        {
            new Float: x = Event[Event_TeamPosX][0];
            new Float: y = Event[Event_TeamPosY][0];
            new Float: z = Event[Event_TeamPosZ][0];
            new Float: a = Event[Event_TeamPosA][0];
            SetPlayerPos(playerid, x, y, z);
            SetPlayerFacingAngle(playerid, a);
            SetPlayerInterior(playerid, Event[ Event_Interior ]);
            SetPlayerVirtualWorld(playerid, Event[ Event_World ]);
            SetPlayerHealth(playerid, 999999);
            Event[Event_Staff][i] = playerid;
            return SendClientMessage(playerid, COLOR_WHITE, "You have joined the event staff.");
        }
    }

    return SendClientMessageEx(playerid, COLOR_GREY, "Unable to join the event staff, max is %d.", sizeof(Event[Event_Staff]));
}

CMD:quiteventstaff(playerid, params[])
{
    if(!IsAdmin(playerid))
    {
        return SendClientErrorUnauthorizedCmd(playerid);
    }

    for(new i; i < sizeof(Event[Event_Staff]); i++) 
    {
        if(Event[Event_Staff][i] == playerid)
        {
            Event[Event_Staff][i] = INVALID_PLAYER_ID;
            SendToLs(playerid);
            return 1;
        }
    }
    return SendClientMessage(playerid, COLOR_GREY, "You are not in event staff.");
}