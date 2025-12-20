// Based on Next Generation Gaming, Festival <Shane-Roberts>

#include <YSI\y_hooks>

#define EVENT_TOKEN_BALLOON 0x41178

enum RideStatus
{
    RS_Waiting, // Waiting for more players
    RS_Starting,
    RS_Active, // In progress
    RS_Finishing
};

enum RideInfo
{
    RI_NbPlayers,//Racer Count
    RideStatus:RI_Status,// 0 = Waiting for more players | 1 = Starting | 2 = Active/In Progress
    RI_Starting,//Countdown for race to start
    RI_Left,//Time left till race ends
    RI_CurrentCheckpoint//Used to determine place within race.
};
static BalloonObject[2];
static BalloonInfo[2][RideInfo];
static BalloonTickets[MAX_PLAYERS];
static PlayerBalloon[MAX_PLAYERS];
static bActive;

static Float:BalloonOrigin[2][4] = {
    {1488.7391, 2.3967, 25.3880, 310.5066},
    {1504.3217, -17.2454, 25.2946, 40.3796}
};
static Float:BalloonSeats[2][3][3] = {
    {
        {1488.8054,3.1436,26.5342},
        {1489.4617,2.3942,26.5342},
        {1488.2523,2.0228,26.5342}
    },
    {
        {1504.1639,-16.4742,26.4408},
        {1505.0876,-17.3473,26.4408},
        {1503.9115,-17.5536,26.4408}
    }
};
static Float:BalloonPath[][3] = {
    {1554.0,8.0,100.0},
    {1574.0,-40.0,115.0},
    {1569.0,-94.0,115.0},
    {1558.0,-134.0,115.0},
    {1501.0,-195.0,115.0},
    {1457.0,-208.0,115.0},
    {1402.0,-208.0,115.0},
    {1360.0,-169.0,115.0},
    {1340.0,-129.0,115.0},
    {1342.0,-84.0,115.0},
    {1356.0,-52.0,115.0},
    {1397.0,-18.0,100.0},
    {1431.0,9.0,75.0},
    {1463.0,14.0,60.0}
};

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/balloon {FFFF00}to join in!\nCost: 5 cookies", 0xFFFFFFF, 1488.9030, -15.1005, 26.3947, 10.0);
    BalloonObject[0] = CreateDynamicObject(19335, BalloonOrigin[0][0], BalloonOrigin[0][1], BalloonOrigin[0][2], 0.0, 0.0,  BalloonOrigin[0][3]);
    BalloonObject[1] = CreateDynamicObject(19336, BalloonOrigin[1][0], BalloonOrigin[1][1], BalloonOrigin[1][2], 0.0, 0.0,  BalloonOrigin[0][3]);
}

hook OnPlayerInit(playerid)
{
    BalloonTickets[playerid] = 0;
    PlayerBalloon[playerid] = -1;
}

hook OnLoadPlayer(playerid, row)
{
    BalloonTickets[playerid] = cache_get_field_content_int(0, "balloon_tickets", connectionID);}

CMD:givetickets(playerid, params[])
{
    RCHECK(IsAdmin(playerid, 5), "You are not authorized to use this command!");
    new targetid, amount;
    if (sscanf(params, "ud", targetid, amount))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givetickets [playerid] [amount]");
    }
    BalloonTickets[targetid] += amount;
    new query[256];
    mysql_format(connectionID, query, sizeof(query), "UPDATE %s SET balloon_tickets = %i WHERE uid = %i", TABLE_USERS, BalloonTickets[targetid], PlayerData[targetid][pID]);
    mysql_tquery(connectionID, query);

    SendClientMessageEx(playerid, -1, "You have given %s %d balloon ride tickets.", GetPlayerNameEx(targetid), amount);
    SendClientMessageEx(targetid, -1, "%s has given you %d balloon ride tickets.", GetPlayerNameEx(playerid), amount);
    return 1;
}

CMD:balloon(playerid, params[])
{
    if (PlayerBalloon[playerid] != -1)
    {
        return LeaveBalloon(playerid);
    }
    RCHECK(IsPlayerIdle(playerid), "You cannot do that for the moment.");
    RCHECK(!IsPlayerInEvent(playerid), "You cannot do that for the moment.");
    RCHECK(IsPlayerInRangeOfPoint(playerid, 10.0, 1488.9030,-15.1005,26.394), "You are not near the Balloon Ride area!");

    if (BalloonTickets[playerid] <= 0)
    {
        new cookies = GetPlayerCookies(playerid);
        RCHECK(cookies >= 5, "You don't have enough cookies to purchase this item.");
        Dialog_Show(playerid, Balloon, DIALOG_STYLE_MSGBOX, "Purchase Balloon Ticket",
                    "Item: Balloon Ride Ticket\nYour Cookies: %s\nCost: {FFD700}5{A9C4E4}\nCookies Left: %s", "Purchase", "Cancel",
                    FormatNumber(cookies), FormatNumber(cookies - 5));
        return 1;
    }
    RideAirBalloon(playerid);
    return 1;
}

Dialog:Balloon(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }
    RCHECK(GetPlayerCookies(playerid) >= 5, "You don't have enough cookies to purchase this item.");
    GivePlayerCookies(playerid, -5);
    SendClientMessageEx(playerid, COLOR_AQUA, "You have purchased a Balloon Ride ticket for 5 cookies.");
    BalloonTickets[playerid]++;
    new query[256];
    mysql_format(connectionID, query, sizeof(query), "UPDATE %s SET balloon_tickets = %i WHERE uid = %i", TABLE_USERS, BalloonTickets[playerid], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, query);
    RideAirBalloon(playerid);
    return 1;
}

RideAirBalloon(playerid)
{
    new balloonid;
    if (BalloonInfo[0][RI_Status] != RS_Active && BalloonInfo[0][RI_NbPlayers] <= 5)
    {
        SavePlayerVariables(playerid);
        SetPVarInt(playerid, "EventToken", EVENT_TOKEN_BALLOON);
        new idx = BalloonInfo[0][RI_NbPlayers];
        TeleportToCoords(playerid, BalloonSeats[0][idx][0], BalloonSeats[0][idx][1], BalloonSeats[0][idx][2], 0.0, 0, 0, true, false);
        balloonid = 0;
        BalloonInfo[0][RI_NbPlayers]++;
    }
    else if (BalloonInfo[1][RI_Status] != RS_Active && BalloonInfo[1][RI_NbPlayers] <= 5)
    {
        SavePlayerVariables(playerid);
        SetPVarInt(playerid, "EventToken", EVENT_TOKEN_BALLOON);
        new idx = BalloonInfo[0][RI_NbPlayers];
        TeleportToCoords(playerid,  BalloonSeats[1][idx][0], BalloonSeats[1][idx][1], BalloonSeats[1][idx][2], 0.0, 0, 0, true, false);

        balloonid = 1;
        BalloonInfo[1][RI_NbPlayers]++;
    }
    else
    {
        return SendClientMessage(playerid, -1, "Balloon Rides are currently full, please try again later!");
    }

    SetPlayerHealth(playerid, 1000.0);
    PlayerBalloon[playerid] = balloonid;

    if (BalloonInfo[balloonid][RI_Status] == RS_Waiting)
    {
        if (!bActive)
        {
            bActive = 1;
            BalloonInfo[balloonid][RI_Status] = RS_Starting;
            BalloonInfo[balloonid][RI_Starting] = 30;
            SetTimerEx("StartBalloon", 1000, false, "d", balloonid);
        }
        else
        {
            BalloonInfo[balloonid][RI_Status] = RS_Finishing;
            SendClientMessage(playerid, -1, "There is currently an active balloon, this ride will begin once the other is done.");
        }
    }
    SendClientMessage(playerid, -1, "Please stay inside the balloon or you and your ticket will be removed.");
    return 1;
}

publish StartBalloon(balloonid)
{
    if (--BalloonInfo[balloonid][RI_Starting] == 0)
    {
        new cp = 0;
        BalloonInfo[balloonid][RI_Status] = RS_Active;
        BalloonInfo[balloonid][RI_CurrentCheckpoint] = cp;
        MoveDynamicObject(BalloonObject[balloonid], BalloonPath[cp][0], BalloonPath[cp][1], BalloonPath[cp][2], 5);

        foreach (new playerid : Player)
        {
            if (PlayerBalloon[playerid] == balloonid)
            {
                BalloonTickets[playerid]--;
                new query[256];
                mysql_format(connectionID, query, sizeof(query), "UPDATE %s SET balloon_tickets = %i WHERE uid = %i", TABLE_USERS, BalloonTickets[playerid], PlayerData[playerid][pID]);
                mysql_tquery(connectionID, query);
            }
        }
    }
    else
    {
        new string[69];
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Balloon Ride~n~starting in %d seconds", BalloonInfo[balloonid][RI_Starting]);
        foreach (new playerid : Player)
        {
            if (PlayerBalloon[playerid] == balloonid)
            {
                if (BalloonInfo[balloonid][RI_Starting] <= 3)
                {
                    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
                }
                GameTextForPlayer(playerid, string, 1100, 3);
            }
        }
        if (BalloonInfo[balloonid][RI_NbPlayers])
        {
            SetTimerEx("StartBalloon", 1000, false, "d", balloonid);
        }
        else
        {
            BalloonInfo[balloonid][RI_CurrentCheckpoint] = 0;
            BalloonInfo[balloonid][RI_Status] = RS_Waiting;
            bActive = 0;
            if (BalloonInfo[balloonid][RI_Status] == RS_Finishing)
            {
                BalloonInfo[balloonid][RI_Status] = RS_Starting;
                BalloonInfo[balloonid][RI_Starting] = 30;
                bActive = 1;
                SetTimerEx("StartBalloon", 1000, false, "d", balloonid);
            }
        }
    }
}

LeaveBalloon(playerid)
{
    if (PlayerBalloon[playerid] != -1)
    {
        new balloonid = PlayerBalloon[playerid];
        PlayerBalloon[playerid] = -1;
        if (BalloonInfo[balloonid][RI_NbPlayers] > 0)
        {
            BalloonInfo[balloonid][RI_NbPlayers]--;
        }
        TeleportToCoords(playerid,  1490.7323 + random(2), -17.8974, 26.3888, 0.0, 0, 0, true, false);
        SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for riding!");
        DeletePVar(playerid, "EventToken");
        SetPlayerToSpawn(playerid);
    }
    return 1;
}

hook OnEventPlayerDeath(eventToken, playerid, killerid, reason)
{
    if (eventToken == EVENT_TOKEN_BALLOON)
    {
        LeaveBalloon(playerid);
    }
}

publish EjectAllPlayersFromBalloon(balloonid)
{
    foreach (new playerid : Player)
    {
        if (PlayerBalloon[playerid] == balloonid)
        {
            LeaveBalloon(playerid);
        }
    }
}

hook OnDynamicObjectMoved(objectid)
{
    if (objectid == BalloonObject[0] || objectid == BalloonObject[1])
    {
        new balloonid = objectid == BalloonObject[1] ? 1 : 0;

        if (BalloonInfo[balloonid][RI_Status] == RS_Waiting)
        {
            SetTimerEx("EjectAllPlayersFromBalloon", 1000, 0, "d", balloonid);
            return 1;
        }

        new placeIdx = BalloonInfo[balloonid][RI_CurrentCheckpoint];
        if (placeIdx == sizeof(BalloonPath))
        {
            MoveDynamicObject(BalloonObject[balloonid], BalloonOrigin[balloonid][0], BalloonOrigin[balloonid][1], BalloonOrigin[balloonid][2], 5);
            BalloonInfo[balloonid][RI_Status] = RS_Waiting;
            bActive = 0;
            if (BalloonInfo[balloonid][RI_Status] == RS_Finishing)
            {
                BalloonInfo[balloonid][RI_Status] = RS_Starting;
                BalloonInfo[balloonid][RI_Starting] = 30;
                bActive = 1;
                SetTimerEx("StartBalloon", 1000, false, "d", balloonid);
            }
        }
        else
        {
            MoveDynamicObject(BalloonObject[balloonid], BalloonPath[placeIdx][0], BalloonPath[placeIdx][1], BalloonPath[placeIdx][2], 7);
        }

        foreach (new playerid : Player)
        {
            if (PlayerBalloon[playerid] == balloonid)
            {
                if (!placeIdx)
                {
                    if (!IsPlayerInRangeOfPoint(playerid, 10, BalloonPath[placeIdx][0], BalloonPath[placeIdx][1], BalloonPath[placeIdx][2]))
                    {
                        LeaveBalloon(playerid);
                    }
                }
                else
                {
                    if (!IsPlayerInRangeOfPoint(playerid, 10, BalloonPath[placeIdx-1][0], BalloonPath[placeIdx-1][1], BalloonPath[placeIdx-1][2]))
                    {
                        LeaveBalloon(playerid);
                    }
                }
            }
        }
        BalloonInfo[balloonid][RI_CurrentCheckpoint]++;
    }
    return 1;
}
