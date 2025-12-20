

#include <a_samp>
#include <foreach>
#include <YSI\y_hooks>

#define DIALOG_HALLOWEEN    2000
#define DIALOG_HALLOWEEN2   2001
#define DIALOG_HALLOWEEN3   2002
#define DIALOG_HALLOWEENBUY 2003
#define INVALID_OBJECT -1


forward OnPlayerHalloween(playerid);

new Float:PumpkinPos[5][3] = {
    {86.8281, -55.4837, 0.6972},
    {76.5158, -57.3969, 0.7842},
    {66.7148, -46.8965, 0.6094},
    {55.0133, -49.2452, 0.6094},
    {52.9661, -38.0604, 0.8964}
};

new PumpkinObj[MAX_PLAYERS][5], Pumpkin[MAX_PLAYERS][5], Candy[MAX_PLAYERS],
    HalloweenBonus[MAX_PLAYERS], HalloweenAccStatus[MAX_PLAYERS][2], HalloweenAccessoriesBuyed[MAX_PLAYERS],
    HalloweenBuy[MAX_PLAYERS];

// ----------------------------------
// Init
// ----------------------------------


// ----------------------------------
// Player Events
// ----------------------------------

hook OnPlayerUpdate(playerid)
{
    OnPlayerHalloween(playerid);
    return 1;
}

stock SavePlayerCandy(playerid)
{
    new query[256];
    mysql_format(connectionID, query, sizeof(query), "UPDATE "#TABLE_USERS" SET candy = %i WHERE uid = %i", Candy[playerid], PlayerData[playerid][pID]);
    mysql_tquery(connectionID, query);
}

hook OnPlayerSpawn(playerid)
{
    for(new i = 0; i < 5; i++)
    {
        if(Pumpkin[playerid][i] == 0)
            PumpkinObj[playerid][i] = CreatePlayerObject(playerid, 19320, PumpkinPos[i][0], PumpkinPos[i][1], PumpkinPos[i][2], 0, 0, 0, 300.0);
        else
            PumpkinObj[playerid][i] = INVALID_OBJECT;
    }
}

// ----------------------------------
// Dialogs
// ----------------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_HALLOWEEN:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_HALLOWEEN2, DIALOG_STYLE_LIST, "SERVER: Candy Shop", "{FFC500}[+] How to obtain candies?{FFFFFF}\n1x level up - {FF5000}50 candies{FFFFFF}\nHalloween Accesories - {FF5000}100 candies{FFFFFF}\n1x Halloween Bonus - {FF5000}200 candies{FFFFFF}", "Select", "Exit");
                }
                case 1:
                {
                    if(HalloweenAccessoriesBuyed[playerid] == 1)
                    {
                        new string[256], string1[128], status[50];
                        if(HalloweenAccStatus[playerid][0] == 1) format(status, sizeof(status), "{FF5000}equiped{FFFFFF}");
                        else if(HalloweenAccStatus[playerid][0] == 0) format(status, sizeof(status), "{FF0000}unused{FFFFFF}");
                        format(string, sizeof(string), "Item Name\tStatus\n");
                        format(string1, sizeof(string1), "Witch Hat\t%s\n", status);
                        strcat(string, string1);
                        if(HalloweenAccStatus[playerid][1] == 1) format(status, sizeof(status), "{FF5000}equiped{FFFFFF}");
                        else if(HalloweenAccStatus[playerid][1] == 0) format(status, sizeof(status), "{FF0000}unused{FFFFFF}");
                        format(string1, sizeof(string1), "Parrot on Arm\t%s", status);
                        strcat(string, string1);
                        ShowPlayerDialog(playerid, DIALOG_HALLOWEEN3, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Halloween Accesories", string, "Select", "Cancel");
                    }
                    else {
                        return SendClientMessage(playerid, -1, "To access this menu, you need to purchase {FF5000}Halloween Accesories{FFFFFF} from shop.");
                    }
                }
                case 2:
                {
                    if(HalloweenBonus[playerid] >= 1)
                    {
                        new money = randomEx(150000, 1000);
                        GivePlayerCash(playerid, money);
                        new string[128];
                        format(string, sizeof(string), "(Halloween):{FFFFFF} Congratulations! You used one bonus and got $%s.", FormatNumber(money));
                        SendClientMessage(playerid, COLOR_ORANGE, string);
                        HalloweenBonus[playerid]--;
                    }
                    else return SendClientMessage(playerid, -1, "You don't have a Halloween Bonus to use. Purchase one from shop (/halloween > Candy Shop).");
                }
            }
        }
        case DIALOG_HALLOWEEN2:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: ShowPlayerDialog(playerid, 1010, DIALOG_STYLE_MSGBOX, "How to obtain candies?", "Do quests or use bonuses to earn candies.", "OK", "");
                case 1:
                {
                    if(Candy[playerid] >= 50)
                    {
                        HalloweenBuy[playerid] = 1;
                        ShowPlayerDialog(playerid, DIALOG_HALLOWEENBUY, DIALOG_STYLE_MSGBOX, "SERVER: Buy", "Buy 1x level up for {FF5000}50 candies{FFFFFF}?", "Yes", "No");
                    }
                    else SendClientMessage(playerid, COLOR_ORANGE, "You don't have 50 candies");
                }
                case 2:
                {
                    if(Candy[playerid] >= 100)
                    {
                        HalloweenBuy[playerid] = 2;
                        ShowPlayerDialog(playerid, DIALOG_HALLOWEENBUY, DIALOG_STYLE_MSGBOX, "SERVER: Buy", "Buy Halloween Accessories for {FF5000}100 candies{FFFFFF}?", "Yes", "No");
                    }
                    else SendClientMessage(playerid, COLOR_ORANGE, "You don't have 100 candies");
                }
                case 3:
                {
                    if(Candy[playerid] >= 200)
                    {
                        HalloweenBuy[playerid] = 3;
                        ShowPlayerDialog(playerid, DIALOG_HALLOWEENBUY, DIALOG_STYLE_MSGBOX, "SERVER: Buy", "Buy Halloween Bonus for {FF5000}200 candies{FFFFFF}?", "Yes", "No");
                    }
                    else SendClientMessage(playerid, COLOR_ORANGE, "You don't have 200 candies");
                }
            }
        }
        case DIALOG_HALLOWEEN3:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0:
                {
                    if(HalloweenAccStatus[playerid][0] == 0)
                    {
                        SetPlayerAttachedObject(playerid, 5, 19528, 2, 0.167425, -0.006185, -0.004779, 0.612963, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                        HalloweenAccStatus[playerid][0] = 1;
                    }
                    else return RemovePlayerAttachedObject(playerid, 5), HalloweenAccStatus[playerid][0] = 0;
                }
                case 1:
                {
                    if(HalloweenAccStatus[playerid][1] == 0)
                    {
                        SetPlayerAttachedObject(playerid, 0, 19079, 1, 0.328340, -0.051058, -0.147006, 0.000000, 0.000000, 0.000000, 0.584640, 0.560368, 0.655995);
                        HalloweenAccStatus[playerid][1] = 1;
                    }
                    else return RemovePlayerAttachedObject(playerid, 0), HalloweenAccStatus[playerid][1] = 0;
                }
            }
        }
        case DIALOG_HALLOWEENBUY:
        {
            if(!response) return 1;
            switch(HalloweenBuy[playerid])
            {
                case 1: Candy[playerid] -= 50, SetPlayerScore(playerid, GetPlayerScore(playerid)+1), SendClientMessage(playerid, COLOR_ORANGE, "(Halloween): You bought 1x level up for 50 candies.");
                case 2:
                {
                    if(HalloweenAccessoriesBuyed[playerid] == 0)
                    {
                        Candy[playerid] -= 100;
                        HalloweenAccessoriesBuyed[playerid] = 1;
                        SendClientMessage(playerid, COLOR_ORANGE, "(Halloween): You bought Halloween Accessories for 100 candies.");
                    }
                    else SendClientMessage(playerid, -1, "You already purchased this option!");
                }
                case 3: Candy[playerid] -= 200, HalloweenBonus[playerid]++, SendClientMessage(playerid, COLOR_ORANGE, "(Halloween): You bought 1x Halloween Bonus for 200 candies.");
            }
        }
    }
    return 1;
}

public OnPlayerHalloween(playerid)
{
    new string[128];

    if(GetPlayerQuestObjects(playerid) < 5)
    {
        for(new p = 0; p < 5; p++)
        {
            if(Pumpkin[playerid][p] == 0)
            {
                if(IsPlayerInRangeOfPoint(playerid, 2.5, PumpkinPos[p][0], PumpkinPos[p][1], PumpkinPos[p][2]))
                {
                    if(PumpkinObj[playerid][p] != INVALID_OBJECT) {
                        DestroyPlayerObject(playerid, PumpkinObj[playerid][p]);
                        PumpkinObj[playerid][p] = INVALID_OBJECT;
                    }

                    Pumpkin[playerid][p] = 1;

                    if(GetPlayerQuestObjects(playerid) == 5)
                    {
                        format(string, sizeof(string), "(Halloween Quest): %s found all pumpkins! Congrats!", GetPlayerName(playerid));
                        SendClientMessageToAll(COLOR_ORANGE, string);

                        new money = 100000 + random(1000);
                        new candy = randomEx(50, 200);
                        Candy[playerid] += candy;
                        GivePlayerCash(playerid, money);
                        SetPlayerScore(playerid, GetPlayerScore(playerid)+1);

                        format(string, sizeof(string), "(Halloween Quest): You won $%s, %d candies and 1x level up.", FormatNumber(money), candy);
                        SendClientMessage(playerid, COLOR_ORANGE, string);
                    }
                    else
                    {
                        new candy = randomEx(5, 25);
                        Candy[playerid] += candy;
                        format(string, sizeof(string), "(Halloween Quest): Pumpkin found (+%d candies)! Now %d/5 pumpkins.", candy, GetPlayerQuestObjects(playerid));
                        SendClientMessage(playerid, COLOR_ORANGE, string);
                    }
                }
            }
        }
    }
    return 1;
}

stock GetPlayerQuestObjects(playerid)
{
    new x;
    for(new i = 0; i < 5; i++) if(Pumpkin[playerid][i]) x++;
    return x;
}
stock randomEx(n1, n2) return n1 + random(n2-n1);

CMD:halloween(playerid, params[])
{
    new string[128];
    format(string, sizeof(string), "Candy Shop ({FF5000}%d candies{FFFFFF})\nHalloween Accesories\nHalloween Bonus", Candy[playerid]);
    ShowPlayerDialog(playerid, DIALOG_HALLOWEEN, DIALOG_STYLE_LIST, "SERVER: Halloween Menu", string, "Select", "Exit");
    return 1;
}
