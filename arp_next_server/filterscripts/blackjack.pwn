#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <easyDialog>


new DeckTextdrw[53][] = {
"LD_CARD:cdback", // CARD BACK
"LD_CARD:cd1c", // A Clubs - 0
"LD_CARD:cd2c", // 2 Clubs - 1
"LD_CARD:cd3c", // 3 Clubs - 2
"LD_CARD:cd4c", // 4 Clubs - 3
"LD_CARD:cd5c", // 5 Clubs - 4
"LD_CARD:cd6c", // 6 Clubs - 5
"LD_CARD:cd7c", // 7 Clubs - 6
"LD_CARD:cd8c", // 8 Clubs - 7
"LD_CARD:cd9c", // 9 Clubs - 8
"LD_CARD:cd10c", // 10 Clubs - 9
"LD_CARD:cd11c", // J Clubs - 10
"LD_CARD:cd12c", // Q Clubs - 11
"LD_CARD:cd13c", // K Clubs - 12
"LD_CARD:cd1d", // A Diamonds - 13
"LD_CARD:cd2d", // 2 Diamonds - 14
"LD_CARD:cd3d", // 3 Diamonds - 15
"LD_CARD:cd4d", // 4 Diamonds - 16
"LD_CARD:cd5d", // 5 Diamonds - 17
"LD_CARD:cd6d", // 6 Diamonds - 18
"LD_CARD:cd7d", // 7 Diamonds - 19
"LD_CARD:cd8d", // 8 Diamonds - 20
"LD_CARD:cd9d", // 9 Diamonds - 21
"LD_CARD:cd10d", // 10 Diamonds - 22
"LD_CARD:cd11d", // J Diamonds - 23
"LD_CARD:cd12d", // Q Diamonds - 24
"LD_CARD:cd13d", // K Diamonds - 25
"LD_CARD:cd1h", // A Heats - 26
"LD_CARD:cd2h", // 2 Heats - 27
"LD_CARD:cd3h", // 3 Heats - 28
"LD_CARD:cd4h", // 4 Heats - 29
"LD_CARD:cd5h", // 5 Heats - 30
"LD_CARD:cd6h", // 6 Heats - 31
"LD_CARD:cd7h", // 7 Heats - 32
"LD_CARD:cd8h", // 8 Heats - 33
"LD_CARD:cd9h", // 9 Heats - 34
"LD_CARD:cd10h", // 10 Heats - 35
"LD_CARD:cd11h", // J Heats - 36
"LD_CARD:cd12h", // Q Heats - 37
"LD_CARD:cd13h", // K Heats - 38
"LD_CARD:cd1s", // A Spades - 39
"LD_CARD:cd2s", // 2 Spades - 40
"LD_CARD:cd3s", // 3 Spades - 41
"LD_CARD:cd4s", // 4 Spades - 42
"LD_CARD:cd5s", // 5 Spades - 43
"LD_CARD:cd6s", // 6 Spades - 44
"LD_CARD:cd7s", // 7 Spades - 45
"LD_CARD:cd8s", // 8 Spades - 46
"LD_CARD:cd9s", // 9 Spades - 47
"LD_CARD:cd10s", // 10 Spades - 48
"LD_CARD:cd11s", // J Spades - 49
"LD_CARD:cd12s", // Q Spades - 50
"LD_CARD:cd13s" // K Spades - 51
};
#define MAX_TABLES 4
enum BlackJackTable{
	Float:tPosX,
	Float:tPosY,
	Float:tPosZ,
	Float:tCamPosX,
	Float:tCamPosY,
	Float:tCamPosZ,
}

new tables[MAX_TABLES][BlackJackTable]= {
	{1960.1224, 1015.7247, 992.8798, 1957.6804, 1016.6092, 993.4836},
	{1960.2734, 1020.1624, 992.8798, 1957.8314, 1021.0469, 993.4836},
	{1962.4597, 1015.6651, 992.8798, 1964.7915, 1014.1629, 993.4836},
	{1962.4266, 1020.1703, 992.8798, 1964.7584, 1021.6725, 993.4836}
};
new Text3D:blackJackLabels[MAX_TABLES];

enum TablePlayer{
    tDealer,
    tPlayer0
}

new DeckCards[MAX_PLAYERS][52];
new DeckPointer;
new HandCards[MAX_PLAYERS][TablePlayer][5];//1 -> player; 0 -> dealer
new BetAmount[MAX_PLAYERS];
new DoubleBet[MAX_PLAYERS];
new BJMenuEnabled[MAX_PLAYERS];
new BlackJackDrawCashTimer[MAX_PLAYERS];
new PlayerText:GUI[MAX_PLAYERS][27];

public OnFilterScriptInit()
{
    print("\n");
    print("========================================");
    printf("Casino Games: Blackjack %s");
    print("Developed By: Mike Z0diac");
    print("========================================");
    print("\n");
	for(new i = 0; i < sizeof(tables); i++)
    {
        blackJackLabels[i] = Create3DTextLabel("BlackJack game\n type {0087FF}/blackjack {FFFFFF}to play!", 0xFFFFFFFF, tables[i][tPosX], tables[i][tPosY], tables[i][tPosZ], 4.0, 0, 0);
		 
    }
    return 1;
}
ShuffleDeck(playerid)
{
    // SFX
    //GlobalPlaySound(5600, PokerTable[tableid][pkrX], PokerTable[tableid][pkrY], PokerTable[tableid][pkrZ]);

    // Order the deck
    for(new i = 0; i < 52; i++) {
        DeckCards[playerid][i] = i;
    }
    
    // Randomize the array (AKA Shuffle Algorithm)
    new rand, tmp, i;
    for(i = 52; i > 1; i--) {
        rand = random(52) % i;
        tmp = DeckCards[playerid][rand];
        DeckCards[playerid][rand] = DeckCards[playerid][i-1];
        DeckCards[playerid][i-1] = tmp;
    }
    DeckPointer = 0;
    for(i=0;i<5;i++)
    {
        HandCards[playerid][tPlayer0][i] = -1;
        HandCards[playerid][tDealer][i] = -1;
    }
}
HitCard(playerid,TablePlayer:tablePlayer)
{
    new i = 0;
    while(i < 5 && HandCards[playerid][tablePlayer][i] != -1)
        i++;
    if(i==5)
        return false;
    if(DeckPointer < 52){
        HandCards[playerid][tablePlayer][i] = DeckCards[playerid][DeckPointer];
        DeckPointer++;
        return true;
    }
    return false;
}
StartBlackJack(playerid)
{
    PlayerTextDrawHide(playerid,GUI[playerid][12]);
	DoubleBet[playerid]=0;
    ShuffleDeck(playerid);
    HitCard(playerid,tPlayer0);
    HitCard(playerid,tPlayer0);
    HitCard(playerid,tDealer);
    DrawCards(playerid);
}
DrawCards(playerid)
{
    //cards
    for(new i=0;i<10;i++)
    {
        if(i<5)
            PlayerTextDrawSetString(playerid, GUI[playerid][i] , DeckTextdrw[HandCards[playerid][tDealer][i]+ 1] );
        else PlayerTextDrawSetString(playerid, GUI[playerid][i] , DeckTextdrw[HandCards[playerid][tPlayer0][i-5] + 1]);
        PlayerTextDrawShow(playerid, GUI[playerid][i]);
    }
    //score
    new score[16];
    format(score,sizeof(score),"~b~%i", CalculateBlackJackScore(playerid,tDealer));
    //TextDrawSetString(GUI[playerid][10],score);
    PlayerTextDrawSetString(playerid,GUI[playerid][15],score);
	PlayerTextDrawShow(playerid,GUI[playerid][15]);
	
	
    format(score,sizeof(score),"~b~%i", CalculateBlackJackScore(playerid,tPlayer0));
    //TextDrawSetString(GUI[playerid][11],score);
	PlayerTextDrawSetString(playerid,GUI[playerid][17],score);
	PlayerTextDrawShow(playerid,GUI[playerid][17]);
}

CalculateBlackJackScore(playerid,TablePlayer:tablePlayer)
{
    new score = 0;
    new ace = false;
    for(new i = 0;i<5;i++)
    {
        if(HandCards[playerid][tablePlayer][i] == -1)
            continue;
        if(HandCards[playerid][tablePlayer][i] % 13 == 0)//ace
        {
            ace = true;
            score += 1;
        }
        else if(HandCards[playerid][tablePlayer][i] % 13 >= 10)//J, Q, K
            score += 10;
        else score += 1 + (HandCards[playerid][tablePlayer][i] % 13);        
    }
    if(ace && score + 10 <= 21)
        score += 10;
    return score;
}
InitBlackJack(playerid)
{
	new i=0;
    for(new y = 140; y < 140 + 2 * 150; y += 150){
        for(new x = 200; x < 200 + 5 * 66; x += 66)
        {
            GUI[playerid][i] = CreatePlayerTextDraw(playerid, x, y, "LD_CARD:cdback");
            PlayerTextDrawAlignment(playerid, GUI[playerid][i], 2);
            PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 255);
            PlayerTextDrawFont(playerid, GUI[playerid][i], 4);
            PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.500000, 1.000000);
            PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
            PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 0);
            PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
            PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 1);
            PlayerTextDrawUseBox(playerid, GUI[playerid][i], 1);
            PlayerTextDrawBoxColor(playerid, GUI[playerid][i], 255);
            PlayerTextDrawTextSize(playerid, GUI[playerid][i], 55.000000, 77.000000);
            i++;
        }
    }
    GUI[playerid][i] = CreatePlayerTextDraw(playerid, 325.000000, 110.000000, "~y~Dealer");
    PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 255);
    PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
    PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
    PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
    PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 0);
    PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
    PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 1);
    i++;

    GUI[playerid][i] = CreatePlayerTextDraw(playerid, 325.000000, 260.000000, "~y~Player");
    PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 255);
    PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
    PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
    PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
    PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 0);
    PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
    PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 1);
    i++;
    
    GUI[playerid][i] = CreatePlayerTextDraw(playerid, 310.000000, 380.000000, "YOU WON!");
    PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 255);
    PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
    PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 1.100000, 4.099998);
    PlayerTextDrawColor(playerid, GUI[playerid][i], 1694458980);
    PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
    PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
    i++;
	
	
    GUI[playerid][i] = CreatePlayerTextDraw(playerid, 16.0, 291.0, "usebox");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.000000, 15.197387);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 183, 0.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], 0);
	PlayerTextDrawUseBox(playerid, GUI[playerid][i], true);
	PlayerTextDrawBoxColor(playerid, GUI[playerid][i], 255);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 0);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 0);
    i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 25.000000, 300.000000, "Dealer's score");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 25.000000, 320.000000, "~b~0");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 25.000000, 340.000000, "Your score");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 25.000000, 360.000000, "~b~0");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 25.000000, 380.000000, "Total wager");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 25.000000, 400.000000, "~g~$0");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.439999, 2.800000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 2);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
    GUI[playerid][i] = CreatePlayerTextDraw(playerid, 558.000000, 325.000000, "usebox");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.000000, 11.197387);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 680, 0.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], 0);
	PlayerTextDrawUseBox(playerid, GUI[playerid][i], true);
	PlayerTextDrawBoxColor(playerid, GUI[playerid][i], 255);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 0);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 0);
    i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 568.000000, 330.000000, "Place bet");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.323523, 0.913066);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 650.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetSelectable(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 568.000000, 350.000000, "Hit");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 602.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetSelectable(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 568.000000, 370.000000, "Stand");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 602.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetSelectable(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 568.000000, 390.000000, "Double");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 602.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetSelectable(playerid, GUI[playerid][i], 1);
	i++;
	
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 568.000000, 410.000000, "Cancel");
	PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.323523, 0.911306);
	PlayerTextDrawTextSize(playerid, GUI[playerid][i], 602.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, GUI[playerid][i], 1);
	PlayerTextDrawColor(playerid, GUI[playerid][i], -1);
	PlayerTextDrawSetShadow(playerid, GUI[playerid][i], 0);
	PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
	PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 51);
	PlayerTextDrawFont(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	PlayerTextDrawSetSelectable(playerid, GUI[playerid][i], 1);
	i++;
	
	GUI[playerid][i] = CreatePlayerTextDraw(playerid, 530.000000, 77.000000, "$00000000");
    PlayerTextDrawBackgroundColor(playerid, GUI[playerid][i], 0x000000ff);
    PlayerTextDrawFont(playerid, GUI[playerid][i], 3);
    PlayerTextDrawLetterSize(playerid, GUI[playerid][i], 0.539999, 2.299999);
    PlayerTextDrawColor(playerid, GUI[playerid][i], 0x2F5A26FF);
    PlayerTextDrawSetOutline(playerid, GUI[playerid][i], 1);
    PlayerTextDrawSetProportional(playerid, GUI[playerid][i], 1);
	i++;
	
	BJMenuEnabled[playerid]=false;
}
forward BlackJackDrawCash(playerid);
public BlackJackDrawCash(playerid)
{
	new string[128];
    format(string, sizeof(string), "$%08d", CallRemoteFunction("GetPlayerCash","i",playerid));
	PlayerTextDrawSetString(playerid,GUI[playerid][26],string);
	PlayerTextDrawShow(playerid, GUI[playerid][26]);
    return 1;
}
ShowBlackJackGUI(playerid,tableid)
{
	new j=0;
	new HiddenItems[]={12,22,23,24};
	for(new i=0;i < 27;i++)
	{
		if(j<sizeof(HiddenItems))
		{
			if(HiddenItems[j] == i)
			{
				PlayerTextDrawHide(playerid, GUI[playerid][i]);
				j++;
				continue;
			}
		}
		PlayerTextDrawShow(playerid, GUI[playerid][i]);
	}
	SelectTextDraw(playerid, 0x00FF00FF);
	TogglePlayerControllable(playerid,0);
	SetPlayerCameraPos(playerid, tables[tableid][tCamPosX], tables[tableid][tCamPosY], tables[tableid][tCamPosZ]);
	SetPlayerCameraLookAt(playerid, tables[tableid][tPosX], tables[tableid][tPosY], tables[tableid][tPosZ]);
	BlackJackDrawCash(playerid);
	BlackJackDrawCashTimer[playerid] = SetTimerEx("BlackJackDrawCash", 2000, true, "i", playerid);
}
CancelBlackJack(playerid)
{
	CancelSelectTextDraw(playerid);
	KillTimer(BlackJackDrawCashTimer[playerid]);
	for(new i=0;i < 27;i++)
		PlayerTextDrawHide(playerid, GUI[playerid][i]);
		
	
	TogglePlayerControllable(playerid,1);
	SetCameraBehindPlayer(playerid);
	BJMenuEnabled[playerid]=false;
}
EndBlackJack(playerid)
{    
    new player0score = CalculateBlackJackScore(playerid,tPlayer0);
    HitCard(playerid,tDealer);
    if(player0score<=21)
    {
        while(CalculateBlackJackScore(playerid,tDealer)<=16 && HandCards[playerid][tDealer][4] == -1)
        {
            HitCard(playerid,tDealer);
        }
    }

    new dealerscore = CalculateBlackJackScore(playerid,tDealer);
    new result;
    if(player0score == dealerscore)
        result = 0;
    else if(player0score > 21 && dealerscore > 21)
        result = 0;
    else if(player0score > 21)
        result = -1;
    else if(dealerscore > 21)
        result = 1;
    else if(dealerscore > player0score)
        result = -1;
    else result = 1;
	new _betamount = BetAmount[playerid] + DoubleBet[playerid] * BetAmount[playerid];
	new string[20];
    switch(result){
        case -1: {
			format(string,sizeof(string),"~r~Lose");// %s",FormatNumber(_betamount));		
            PlayerTextDrawSetString(playerid, GUI[playerid][12],string);
            //{5817, !"Casino Man", !"Sorry sir, dealer wins!"},
            //{5818, !"Casino Man", !"Dealer wins!"},
            //{5819, !"Casino Man", !"House wins"},
            new soundIDs[]={5817,5818,5819};
            new soundidx = random(sizeof(soundIDs));
            PlayerPlaySound(playerid, soundIDs[soundidx], 0, 0, 0);
        }
        case 0:{
            PlayerTextDrawSetString(playerid, GUI[playerid][12],"~y~Push");
            //{5815, !"Casino Man", !"Push."},
            //{5816, !"Casino Man", !"No winner."},
            new soundIDs[]={5815,5816};
            new soundidx = random(sizeof(soundIDs));
            PlayerPlaySound(playerid, soundIDs[soundidx], 0, 0, 0);
			CallRemoteFunction("GivePlayerCash","ii", playerid, _betamount);

        }
        case 1:{
		
			format(string,sizeof(string),"~g~Won");// %s",FormatNumber(_betamount));
            PlayerTextDrawSetString(playerid, GUI[playerid][12],string);
            //{5847, !"Casino Man", !"You win!"},
            //{5848, !"Casino Man", !"You win sir, well played"},
            //{5849, !"Casino Man", !"Sir is lucky today"},
            new soundIDs[]={5847,5848,5849};
            new soundidx = random(sizeof(soundIDs));
            PlayerPlaySound(playerid, soundIDs[soundidx], 0, 0, 0);
			CallRemoteFunction("GivePlayerCash","ii", playerid, 2 * _betamount);
        }
    }
    PlayerTextDrawShow(playerid,GUI[playerid][12]);
	PlayerTextDrawShow(playerid, GUI[playerid][21]);
	PlayerTextDrawHide(playerid, GUI[playerid][22]);
	PlayerTextDrawHide(playerid, GUI[playerid][23]);
	PlayerTextDrawHide(playerid, GUI[playerid][24]);
	BlackJackDrawCash(playerid);
}
Dialog:SetBlackJackBet(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new val;
		if(sscanf(inputtext, "i", val))
		{
			return SendClientMessage(playerid,0xFF0000FF,"Wager value must be between $1 and $1,000");			
		}
		else if(val<1 || val > 1000)
		{
			return SendClientMessage(playerid,0xFF0000FF,"Wager value must be between $1 and $1,000");
		}else if(CallRemoteFunction("PlayerCanAfford","ii",playerid,val)==0){
			//{5823, !"Casino Man", !"I'm sorry sir, you don't have the funds"},
			//{5824, !"Casino Man", !"You do not have enough to cover your bet sir"},
			new soundIDs[]={5823,5824};
			new soundidx = random(sizeof(soundIDs));
			PlayerPlaySound(playerid, soundIDs[soundidx], 0, 0, 0);
			return SendClientMessage(playerid,0xFF0000FF,"You dont have this amount of money!");
		}else {
		StartBlackJack(playerid);
		PlayerTextDrawHide(playerid, GUI[playerid][21]);
		PlayerTextDrawShow(playerid, GUI[playerid][22]);
		PlayerTextDrawShow(playerid, GUI[playerid][23]);
		PlayerTextDrawShow(playerid, GUI[playerid][24]);
		BetAmount[playerid] = val;
		new string[16];
		format(string,sizeof(string),"~g~$%i", val);
		PlayerTextDrawSetString(playerid,GUI[playerid][19],string);
		PlayerTextDrawShow(playerid,GUI[playerid][19]);
		CallRemoteFunction("GivePlayerCash","ii", playerid, - val);
		BlackJackDrawCash(playerid);
		if(CalculateBlackJackScore(playerid,tPlayer0) == 21)
			EndBlackJack(playerid);
		}
	}

	return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	//Place bet
	//Hit
	//Stand
	//Double
	//Cancel
    if(playertextid == GUI[playerid][21])
    {
			Dialog_Show(playerid, SetBlackJackBet, DIALOG_STYLE_INPUT, "{FFFFFF}Place bet","Enter total wager(between 1 and 1000):", "Start", "Cancel");
	}else if(playertextid == GUI[playerid][22])
	{		
		PlayerTextDrawHide(playerid, GUI[playerid][24]);
		HitCard(playerid,tPlayer0);
		if(CalculateBlackJackScore(playerid,tPlayer0)>=21 || HandCards[playerid][tPlayer0][4] != -1)
		{
			EndBlackJack(playerid);
		}
		DrawCards(playerid);
	}else if(playertextid == GUI[playerid][23])
	{
		EndBlackJack(playerid);
		DrawCards(playerid);
	}else if(playertextid == GUI[playerid][24])
	{
		if(CallRemoteFunction("PlayerCanAfford","ii",playerid,BetAmount[playerid])==0){
			//{5823, !"Casino Man", !"I'm sorry sir, you don't have the funds"},
			//{5824, !"Casino Man", !"You do not have enough to cover your bet sir"},
			new soundIDs[]={5823,5824};
			new soundidx = random(sizeof(soundIDs));
			PlayerPlaySound(playerid, soundIDs[soundidx], 0, 0, 0);
			SendClientMessage(playerid,0xFF0000FF,"You dont have this amount of money!");
			return;
		}
		DoubleBet[playerid]=1;
		new value =  -(BetAmount[playerid]);
		CallRemoteFunction("GivePlayerCash","ii", playerid, value);
		
		HitCard(playerid,tPlayer0);
		EndBlackJack(playerid);
		DrawCards(playerid);
	}else if(playertextid == GUI[playerid][25]){
		//cancel
		CancelBlackJack(playerid);
	}
}
public OnPlayerConnect(playerid)
{
    InitBlackJack(playerid);
}
GetNearbyBlackJackTable(playerid, Float:radius=2.0)
{
	
	for(new i = 0; i < sizeof(tables); i++)
    {
		if(IsPlayerInRangeOfPoint(playerid, radius, tables[i][tPosX], tables[i][tPosY], tables[i][tPosZ]))
			return i;		 
    }
	return -1;
}
CMD:blackjack(playerid,params[])
{
	new tableid = GetNearbyBlackJackTable(playerid);
	if(tableid == -1)
	{
		SendClientMessage(playerid,0xAFAFAFFF,"You are not near any blackjack table.");
	}
	DeckPointer = 0;
    for(new i=0;i<5;i++)
    {
        HandCards[playerid][tPlayer0][i] = -1;
        HandCards[playerid][tDealer][i] = -1;
    }
	BJMenuEnabled[playerid]=true;
	DrawCards(playerid);
	ShowBlackJackGUI(playerid,tableid);
    new soundIDs[]={5400,5401};
    new soundidx = random(sizeof(soundIDs));
    PlayerPlaySound(playerid, soundIDs[soundidx], 0, 0, 0);
    return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid) {
    if(_:clickedid == _:INVALID_TEXT_DRAW){
		if(BJMenuEnabled[playerid])
		{
			CancelBlackJack(playerid);
		}
		return; // block any invalid textdraws.
	}
}
/*CMD:debugsound(playerid, params[]) // DEBUG ONLY
{
    PlayerPlaySound(playerid, strval(params), 0.0, 0.0, 0.0);
}

CMD:startblackjack(playerid,params[])
{    
    StartBlackJack(playerid);
    return 1;
}
CMD:bjstand(playerid,params[])
{
    EndBlackJack(playerid);
    DrawCards(playerid);
    return 1;
}

CMD:bjdouble(playerid,params[])
{
    HitCard(playerid,tPlayer0);
    EndBlackJack(playerid);
    DrawCards(playerid);
    return 1;
}


CMD:bjhit(playerid,params[])
{
    HitCard(playerid,tPlayer0);
    if(CalculateBlackJackScore(playerid,tPlayer0)>=21)
    {
        EndBlackJack(playerid);
    }
    DrawCards(playerid);

    return 1;
}*/