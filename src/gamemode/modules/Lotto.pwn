/// @file      Lotto.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-12
/// @copyright Copyright (c) 2023

// Based on Next Generation Gaming, Lottery System <Faskis>

#include <YSI\y_hooks>

#define MAX_PLAYER_LOTTOS 5
static NbLottos[MAX_PLAYERS];
static LottoNumbers[MAX_PLAYERS][MAX_PLAYER_LOTTOS];
static WinningLottos[MAX_PLAYERS];


hook OnPlayerLoaded(playerid, row)
{
    DBFormat("SELECT * FROM `lotto` WHERE `uid` = %d LIMIT 5", PlayerData[playerid][pID]);
    DBExecute("LoadLottoTicket", "i", playerid);
}

DB:LoadLottoTicket(playerid)
{
    new rows = GetDBNumRows();
    NbLottos[playerid] = 0;
	for (new i; i < MAX_PLAYER_LOTTOS; i++)
	{
		LottoNumbers[playerid][i] = i < rows ? GetDBIntField(i, "number") : 0;
        if (LottoNumbers[playerid][i] > 0)
            NbLottos[playerid]++;
	}
	return 1;
}

publish Lotto(number)
{
	new TotalWinners = 0, TotalWiningLottos = 0;
	SendClientMessageToAllEx(COLOR_WHITE, "Lottery News: Today the winning number has fallen on... %d!.", number);

	foreach(new i: Player)
	{
        WinningLottos[i] = 0;
		if (NbLottos[i] <= 0)
        {
            SendClientMessageEx(i, COLOR_GREY, "You did not participate in this drawing.");
        }
        else
		{
			for (new t = 0; t < 5; t++)
			{
				if (LottoNumbers[i][t] == number)
				{
					WinningLottos[i]++;
				}
				LottoNumbers[i][t] = 0;
			}
            if (WinningLottos[i] == 0)
            {
                SendClientMessageEx(i, COLOR_GREY, "Sorry your lottery tickets have not been selected this drawing.");
            }
            else
            {
                TotalWinners++;
				TotalWiningLottos += WinningLottos[i];
            }
	        DBQuery("DELETE FROM `lotto` WHERE `uid` = %i", PlayerData[i][pID]);
			NbLottos[i] = 0;
		}
	}
    new jackpot = GetLottoJackpot();
    if (TotalWinners > 0)
    {
        foreach(new i: Player)
        {
            if (WinningLottos[i])
            {
                new prize = (WinningLottos[i] * jackpot) / TotalWiningLottos;
                SendClientMessageToAllEx(COLOR_WHITE, "Lottery News: %s has won the Jackpot of %s with their lottery ticket.", GetPlayerNameEx(i), FormatCash(prize));
                SendClientMessageEx(i, COLOR_YELLOW, "* You have won %s with your lottery ticket - congratulations!", FormatCash(prize));
                GivePlayerCash(i, prize);
            }
        }

    }

	if (TotalWinners > 0)
	{
	    jackpot = 10000;
        SetLottoTicketsSold(0);
        SetLottoJackpot(jackpot);
		SendClientMessageToAllEx(COLOR_WHITE, "Lottery News: The new Jackpot has been started with $%s.", FormatNumber(jackpot));
	}
	else
	{
        SendClientMessageToAllEx(COLOR_WHITE, "Lottery News: The Jackpot has been raised to $%s.", FormatNumber(jackpot));
	}
    new h, m;
    gettime(h, m);
    if (m >= 30)
        h = (h + 1 == 24) ? 0 : h + 1;
    SendClientMessageToAllEx(COLOR_WHITE, "Lottery News: Next drawing is at %i:30, you can get a lottery ticket at any 24/7.", h);
	return 1;
}

hook OnNewMinute(timestamp)
{
    new h, m;
    gettime(h, m);

    if (m == 30)
    {
		SendClientMessageToAllEx(COLOR_WHITE, "Lottery News: We have started the Lottery Election.");
		Lotto(Random(1, 300));
    }
}

Dialog:LottoMenu(playerid, response, listitem, inputtext[])
{
    if (!response)
        return 1;

    new lotto = strval(inputtext);
    if (lotto < 1 || lotto > 300)
    {
        Dialog_Show(playerid, LottoMenu, DIALOG_STYLE_INPUT, "Lottery Ticket Selection",
                    "Please enter a Lotto Number:\n Not below 1 or above 300.", "Buy", "Cancel" );
        return 1;
    }

    RCHECK(NbLottos[playerid] < 5, "You can only buy up to 5 tickets.");
    new businessid = GetInsideBusiness(playerid);
    RCHECK(businessid != -1, "You are not inside any business.");

    for (new i = 0; i < 5; i++)
    {
        if (LottoNumbers[playerid][i] == 0)
        {
            LottoNumbers[playerid][i] = lotto;
            break;
        }
    }
	DBQuery("INSERT INTO `lotto` (`uid` ,`number`) VALUES ('%d', '%d')", PlayerData[playerid][pID], lotto);
  	NbLottos[playerid]++;
    AddToLottoJackpot(500);
    SetLottoTicketsSold(GetLottoTicketsSold() + 1);
    GivePlayerCash(playerid, -500);
    PerformBusinessPurchase(playerid, businessid, 500);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You bought a Lottery Ticket with number: %d.", lotto);
    return 1;
}

CMD:lotto(playerid, params[])
{
    new h, m;
    gettime(h, m);
    if (m >= 30)
        h = (h + 1 == 24) ? 0 : h + 1;
    if (NbLottos[playerid] > 0)
    {
        new content[64];
        content = "My Lotto tickets";
        for (new i = 0; i < 5; i++)
        {
            if (LottoNumbers[playerid][i] != 0)
            {
                AppendFormat(content, sizeof(content), ", %s", LottoNumbers[playerid][i]);
            }
        }
	    SendClientMessageEx(playerid, COLOR_WHITE, content);
    }
	SendClientMessageEx(playerid, COLOR_WHITE, "Next drawing is at %i:30, tickets sold %i, and total Jackpot is %s.",
                        h, GetLottoTicketsSold(), FormatCash(GetLottoJackpot()));
    return 1;
}

CMD:forcelotto(playerid, params[])
{
	new confirm[64], prize, number;
	RCHECK(IsGodAdmin(playerid), "You don't have access to this command.");
    RCHECK(!sscanf(params, "s[64]i(0)i(0)", confirm, prize, number), "USAGE: /forcelotto confirm [additional prize] [number]");
    RCHECK(!strcmp(confirm, "confirm", true), "USAGE: /forcelotto confirm [additional prize] [number]");
    RCHECK(0 <= number <= 300, "Invalid number. Must be between 0 and 300 (0 for random).");

    if (prize != 0)
    {
        SendAdminWarning(2, "%s has forced the lottery with a special prize %s.", GetPlayerNameEx(playerid), FormatCash(prize));
    }
    else
    {
        SendAdminWarning(2, "%s has forced the lottery.", GetPlayerNameEx(playerid));
    }
    AddToLottoJackpot(prize);
    if (number == 0)
    {
		Lotto(Random(1, 300));
    }
    else
    {
    	Lotto(number);
    }
	return 1;
}

stock CountTickets(playerid)
{
	new query[80];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT * FROM `lotto` WHERE `uid` = %i", PlayerData[playerid][pID]);
	mysql_tquery(MainPipeline, query, "CountAmount", "i", playerid);
	return 1;
}
