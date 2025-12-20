#include <YSI\y_hooks>

stock GiftBox(playerid)
{
    new randgift = Random(1, 100);

    if(randgift >= 1 && randgift <= 90)
    {
        new gift = Random(1, 7);

        switch(gift)
        {
            case 1:
            {
                GivePlayerWeaponEx(playerid, 24);
                GivePlayerWeaponEx(playerid, 31);
                GivePlayerWeaponEx(playerid, 34);
                GivePlayerWeaponEx(playerid, 29);
                SendClientMessage(playerid, COLOR_GREY2, " Congratulations! - You won Full Weapon Set");
            }
            case 2:
            {
                PlayerData[playerid][pFirstAid]++;
                SendClientMessageEx(playerid, COLOR_GREY2, "Congratulations, you have won a first aid kit!");
            }
            case 3:
            {
                PlayerData[playerid][pMaterials] += 2000;
                SendClientMessageEx(playerid, COLOR_GREY2, "Congratulations, you have won 2,000 materials!");
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case 4:
            {
                PlayerData[playerid][pWeed] += 50;
                SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won 50 grams of weed!");
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET weed = %i WHERE uid = %i", PlayerData[playerid][pWeed], PlayerData[playerid][pID]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case 5:
            {
                PlayerData[playerid][pCocaine] += 25;
                SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won 25 grams of crack!");
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET cocaine = %i WHERE uid = %i", PlayerData[playerid][pCocaine], PlayerData[playerid][pID]);
                mysql_tquery(connectionID, queryBuffer);
            }
            case 6:
            {
                GivePlayerCash(playerid, 20000);
                SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won $20,000!");
            }
        }
    }
    else if(randgift > 90 && randgift <= 99)
    {
        new gift = Random(1, 5);
        if(gift == 1)
        {
            GivePlayerCash(playerid, 15000);
            SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won $15000!");
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward $15000, enjoy!", GetPlayerNameEx(playerid));
        }
        else if(gift == 2)
        {
            PlayerData[playerid][pMaterials] += 15000;
            SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won 15,000 materials!");
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward 15,000 materials, enjoy!", GetPlayerNameEx(playerid));
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET materials = %i WHERE uid = %i", PlayerData[playerid][pMaterials], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
        }
        else if(gift == 3)
        {
            PlayerData[playerid][pUpgradePoints] += 10;
            SendClientMessageEx(playerid, COLOR_GREY, " Congratulations, you have won 10 upgrade points!");
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward 10 upgrade points, enjoy!", GetPlayerNameEx(playerid));
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_USERS" SET upgradepoints = %i WHERE uid = %i", PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
        }
        else if(gift == 4)
        {
            GivePlayerCash(playerid, 50000);
            SendClientMessageEx(playerid, COLOR_GREY, " Congratulations, you have won a $50,000!");
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward $50,000, enjoy!", GetPlayerNameEx(playerid));
        }
    }
    else if(randgift > 99 && randgift <= 100)
    {
        new gift = Random(1, 4);
        /*if(gift == 1 && PlayerData[playerid][pVIPPackage] <= 2)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won 5 days of Diamond VIP!");
            SendClientMessageEx(playerid, COLOR_GREY, " Note: This rare reward may take up to 48 hours to be rewarded.");
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Giftbox', NOW(), 'Diamond VIP')", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            SendAdminMessage(COLOR_YELLOW, "{AA3333}AdmWarning{FFFF00}: %s has just won one month of {D909D9}Diamond VIP{FFFF00} from giftbox.", GetPlayerNameEx(playerid));
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward 5 days of Diamond VIP, enjoy!", GetPlayerNameEx(playerid));
        }
        if(gift == 1)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won a free house!");
            SendClientMessageEx(playerid, COLOR_GREY, " Note: This rare reward may take up to 48 hours to be rewarded.");
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Giftbox', NOW(), 'Free House')", PlayerData[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            SendAdminMessage(COLOR_YELLOW, "{AA3333}AdmWarning{FFFF00}: %s has just won a free house from giftbox.", GetPlayerNameEx(playerid));
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward a free house, enjoy!", GetPlayerNameEx(playerid));
        }
        else */
        if(gift == 2)
        {
            GivePlayerCash(playerid, 100000);
            SendClientMessageEx(playerid, COLOR_GREY, "Congratulations, you have won $100,000!");
            SendAdminMessage(COLOR_YELLOW, "{AA3333}AdmWarning{FFFF00}:%s has just won $100,000 from the giftbox.", GetPlayerNameEx(playerid));
            SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "* %s was just given a reward $100,000, enjoy!", GetPlayerNameEx(playerid));
        }
    }
	return 1;
}


hook OnNewHour(timestamp, hour)
{
    if(hour != 20)
    {
        return 1;
    }

    foreach(new i:Player)
    {
        if(PlayerData[i][pLogged] && (PlayerData[i][pAdmin] || PlayerData[i][pHelper]) && PlayerData[i][pLevel] > 3)
        {
            GiftBox(i);
        }
    }
    return 1;
}

CMD:forceautogift(playerid, params[])
{
    if(!IsGodAdmin(playerid))
    {
        return 0;
    }
    
    foreach(new i:Player)
    {
        if(PlayerData[i][pLogged] && (PlayerData[i][pAdmin] || PlayerData[i][pHelper]) && PlayerData[i][pLevel] > 3)
        {
            GiftBox(i);
        }
    }
    return 1;
}