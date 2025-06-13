//                                                                               |
//     You can change/edit the colours of the messages shown to a player,        |
//             but please keep the credits and leave the code as it is           |
//                                                                               |
//                 This Filterscript has been created by:                        |
//                                                                               |
//                                                                               |
//						 _____           _     _                                 |
//						|  __ \         | |   (_)                                |
//						| |  | |_ __ ___| |__  _ _ __                            |
//						| |  | | '__/ _ \ '_ \| | '_ \                           |
//						| |__| | | |  __/ |_) | | | | |                          |
//						|_____/|_|  \___|_.__/|_|_| |_|                          |
//                                                                               |
//                                   © 2012                                      |
//                                                                               |
//                                                                               |
//_______________________________________________________________________________|


#define FILTERSCRIPT
#include <a_samp>
//================================================================================================================================================
//====================================DEFINES=(you can change the values of you want to===========================================================
//================================================================================================================================================
#define DIALOG_STARTGAMBLE	1893    //	DialogID of the dialog shown when a player types /gamble
#define DIALOG_STOPGAMBLE	1894    //  DialogID of the dialog shown when a player types /stopgamble
#define GAMBLE_WAGER		600       //  Amount of money a player has to pay whenever he spins the slot machine (wager)
#define REWARD_DOUBLEBAR	99999     //  Amount of money a player recieves when he has 3x the double goldbars (Should be highest value)
#define REWARD_BAR			88888     //  Amount of money a player recieves when he has 3x the single goldbar
#define REWARD_BELL			77777     //  Amount of money a player recieves when he has 3x the gold bell
#define REWARD_CHERRY		66666     //  Amount of money a player recieves when he has 3x the cherry
#define REWARD_GRAPES		55555     //  Amount of money a player recieves when he has 3x the grapes
#define REWARD_SIXTYNINE	44444     //  Amount of money a player recieves when he has 3x the 69 (Should be lowest value)
//================================================================================================================================================
//=================================END OF DEFINES=================================================================================================
//================================================================================================================================================
//--------------------------------------------Do not change any of the values below!--------------------------------------------------------------
new LeftSpinner;
new MiddleSpinner;
new RightSpinner;
new GamblingMachine;
new Float:ZOff = 0.0005;
new PreSpinTimer;
new SymbolSL,SymbolSM,SymbolSR;
new Float:pX, Float:pY, Float:pZ;
new Text3D:GambleLabel[22];
new Float:Rotations[18] = {0.0, 20.0, 40.0, 60.0, 80.0, 100.0, 120.0, 140.0, 160.0, 180.0, 200.0, 220.0, 240.0, 260.0, 280.0, 300.0, 320.0, 340.0};
new ResultIDsLeft[18] = {2, 3, 1, 4, 6, 5, 6, 5, 4, 3, 4, 1, 6, 5, 3, 5, 4, 6};
new ResultIDsMiddle[18] = {3, 4, 6, 5, 2, 4, 5, 6, 4, 1, 5, 3, 6, 1, 6, 3, 4, 5};
new ResultIDsRight[18] = {5, 6, 3, 4, 5, 4, 3, 5, 6, 1, 2, 6, 4, 3, 5, 1, 4, 6};
new ResultNames[][] =
{
	"ld_slot:bar1_o",
	"ld_slot:bar2_o",
	"ld_slot:r_69",
	"ld_slot:bell",
	"ld_slot:grapes",
	"ld_slot:cherry"
};
new bool:IsGambling[MAX_PLAYERS];
new bool:movedup = false;
new bool:IsSpinning[MAX_PLAYERS] = false;
new Float:BanditLocs[12][4] =
{
	{1963.4816,1037.0576,992.4745}, // Red dragon casino slot machine 01
	{1966.1621,1037.6616,992.4688}, // Red dragon casino slot machine 02
	{1963.2148,1044.1675,992.4688}, // Red dragon casino slot machine 03
	{1961.1277,1042.8229,992.4688}, // Red dragon casino slot machine 04
	{1956.7949,1047.2064,992.4688}, // Red dragon casino slot machine 05
	{1958.1881,1049.2173,992.4688}, // Red dragon casino slot machine 06
	{1966.0974,998.0917,992.4688},	// Red dragon casino slot machine 07
	{1963.6577,998.6782,992.4688},	// Red dragon casino slot machine 08
	{1961.1344,992.8139,992.4688},	// Red dragon casino slot machine 09
	{1963.5104,991.0811,992.4688},	// Red dragon casino slot machine 10
	{1958.3256,986.2510,992.4688},	// Red dragon casino slot machine 11
	{1956.9016,988.4763,992.4688}	// Red dragon casino slot machine 12
};

enum tDraws
{
    Text:Textdraw0,
	Text:Textdraw1,
	Text:Textdraw2,
	Text:Textdraw3,
	Text:Textdraw4,
	Text:Textdraw5,
	Text:Textdraw6,
	Text:Textdraw7,
	Text:Textdraw8,
	Text:Textdraw9,
	Text:Textdraw10,
	Text:Textdraw11,
	Text:Textdraw12,
	Text:Textdraw13,
	Text:Textdraw14,
	Text:Textdraw15,
	Text:Textdraw16,
	Text:Textdraw17,
	Text:Textdraw18,
	Text:Textdraw19,
	Text:Textdraw20,
	Text:Textdraw21,
	Text:Textdraw22,
	Text:Textdraw23,
	Text:Textdraw24,
	Text:Textdraw25,
	Text:Textdraw26,
	Text:Textdraw27,
	Text:Textdraw28,
	Text:Textdraw29,
	Text:Textdraw30,
	Text:Textdraw31,
	Text:Textdraw32,
	Text:Textdraw33,
	Text:Textdraw34,
	Text:Textdraw35,
	Text:Textdraw36,
	Text:Textdraw37,
	TotalWon,
	TotalPaid,
	TotalTotal
}
new PlayerEnum[MAX_PLAYERS][tDraws];

forward SpinSpinners(playerid);
forward Prespin(playerid);
forward GiveResult(playerid);
forward SetPlayerWonPaid(playerid);

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("SlotMachines 1.0 by Drebin ©2012");
	print("--------------------------------------\n");
	GamblingMachine = CreateObject(2325, 2236.6172, 1600.9479, 1000.6591 ,   0.00, 0.00, -90.00);
    for(new i = 0; i < sizeof(BanditLocs); i++)
    {
        GambleLabel[i] = Create3DTextLabel("Slot Machine\n type {0087FF}/gamble {FFFFFF}to\nstart gambling!", 0xFFFFFFFF, BanditLocs[i][0], BanditLocs[i][1], BanditLocs[i][2], 4.0, 0, 0);
    }
	return 1;
}

public OnFilterScriptExit()
{
	DestroyObject(GamblingMachine);
	for(new i = 0; i < sizeof(BanditLocs); i++)
    {
        Delete3DTextLabel(GambleLabel[i]);
    }
	return 1;
}
#endif
public OnPlayerConnect(playerid)
{
    PlayerEnum[playerid][TotalWon] = 0;
	PlayerEnum[playerid][TotalPaid] = 0;
	PlayerEnum[playerid][TotalTotal] = 0;
    LeftSpinner = CreatePlayerObject(playerid, 2347, 2236.6072, 1601.0479, 1000.6791,   5.00, 0.00, -90.00);
	MiddleSpinner = CreatePlayerObject(playerid, 2348, 2236.6072, 1600.9279, 1000.6791,   5.00, 0.00, -90.00);
	RightSpinner = CreatePlayerObject(playerid, 2349, 2236.6072, 1600.8079, 1000.6791,   5.00, 0.00, -90.00);
    new doublebar[16], bar[16], bell[16], cherry[16], grapes[16], sixtynine[16], wager[16];
	format(doublebar,sizeof(doublebar),"= $%i",REWARD_DOUBLEBAR);
	format(bar,sizeof(bar),"= $%i",REWARD_BAR);
	format(bell,sizeof(bell),"= $%i",REWARD_BELL);
	format(cherry,sizeof(cherry),"= $%i",REWARD_CHERRY);
	format(grapes,sizeof(grapes),"= $%i",REWARD_GRAPES);
	format(sixtynine,sizeof(sixtynine),"= $%i",REWARD_SIXTYNINE);
	format(wager,sizeof(wager),"~y~Wager = $%i", GAMBLE_WAGER);
    PlayerEnum[playerid][Textdraw0] = TextDrawCreate(563.000000, 163.000000, "~n~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw0], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw0], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw0], 0.500000, 17.700006);
	TextDrawColor(PlayerEnum[playerid][Textdraw0], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw0], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw0], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw0], 22.000000, 140.000000);

	PlayerEnum[playerid][Textdraw1] = TextDrawCreate(319.000000, 326.000000, "~n~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw1], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw1], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw1], 2.250000, 10.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw1], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw1], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw1], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw1], -22.000000, 340.000000);

	PlayerEnum[playerid][Textdraw2] = TextDrawCreate(179.000000, 329.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw2], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw2], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw2], 0.460000, -1.500000);
	TextDrawColor(PlayerEnum[playerid][Textdraw2], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw2], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw2], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw2], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw2], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw2], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw2], 90.000000, 69.000000);

	PlayerEnum[playerid][Textdraw3] = TextDrawCreate(274.000000, 329.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw3], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw3], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw3], 0.460000, -1.500000);
	TextDrawColor(PlayerEnum[playerid][Textdraw3], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw3], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw3], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw3], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw3], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw3], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw3], 90.000000, 69.000000);

	PlayerEnum[playerid][Textdraw4] = TextDrawCreate(369.000000, 329.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw4], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw4], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw4], 0.460000, -1.500000);
	TextDrawColor(PlayerEnum[playerid][Textdraw4], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw4], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw4], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw4], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw4], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw4], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw4], 90.000000, 69.000000);

	PlayerEnum[playerid][Textdraw5] = TextDrawCreate(206.000000, 381.000000, "YOU WON!");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw5], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw5], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw5], 1.100000, 4.099998);
	TextDrawColor(PlayerEnum[playerid][Textdraw5], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw5], 1);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw5], 1);

	PlayerEnum[playerid][Textdraw6] = TextDrawCreate(493.000000, 169.000000, "ld_slot:bar2_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw6], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw6], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw6], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw6], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw6], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw6], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw6], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw6], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw6], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw6], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw7] = TextDrawCreate(518.000000, 169.000000, "ld_slot:bar2_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw7], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw7], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw7], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw7], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw7], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw7], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw7], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw7], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw7], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw7], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw8] = TextDrawCreate(543.000000, 169.000000, "ld_slot:bar2_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw8], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw8], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw8], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw8], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw8], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw8], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw8], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw8], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw8], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw8], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw9] = TextDrawCreate(493.000000, 186.000000, "ld_slot:bar1_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw9], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw9], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw9], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw9], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw9], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw9], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw9], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw9], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw9], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw9], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw10] = TextDrawCreate(518.000000, 186.000000, "ld_slot:bar1_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw10], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw10], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw10], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw10], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw10], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw10], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw10], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw10], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw10], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw10], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw11] = TextDrawCreate(543.000000, 186.000000, "ld_slot:bar1_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw11], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw11], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw11], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw11], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw11], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw11], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw11], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw11], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw11], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw11], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw12] = TextDrawCreate(493.000000, 203.000000, "ld_slot:bell");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw12], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw12], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw12], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw12], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw12], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw12], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw12], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw12], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw12], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw12], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw13] = TextDrawCreate(518.000000, 203.000000, "ld_slot:bell");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw13], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw13], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw13], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw13], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw13], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw13], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw13], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw13], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw13], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw13], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw14] = TextDrawCreate(543.000000, 203.000000, "ld_slot:bell");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw14], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw14], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw14], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw14], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw14], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw14], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw14], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw14], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw14], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw14], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw15] = TextDrawCreate(493.000000, 220.000000, "ld_slot:cherry");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw15], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw15], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw15], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw15], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw15], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw15], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw15], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw15], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw15], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw15], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw16] = TextDrawCreate(518.000000, 220.000000, "ld_slot:cherry");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw16], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw16], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw16], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw16], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw16], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw16], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw16], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw16], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw16], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw16], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw17] = TextDrawCreate(543.000000, 220.000000, "ld_slot:cherry");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw17], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw17], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw17], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw17], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw17], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw17], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw17], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw17], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw17], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw17], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw18] = TextDrawCreate(493.000000, 237.000000, "ld_slot:grapes");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw18], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw18], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw18], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw18], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw18], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw18], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw18], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw18], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw18], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw18], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw19] = TextDrawCreate(518.000000, 237.000000, "ld_slot:grapes");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw19], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw19], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw19], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw19], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw19], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw19], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw19], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw19], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw19], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw19], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw20] = TextDrawCreate(543.000000, 237.000000, "ld_slot:grapes");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw20], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw20], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw20], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw20], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw20], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw20], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw20], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw20], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw20], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw20], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw21] = TextDrawCreate(493.000000, 255.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw21], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw21], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw21], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw21], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw21], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw21], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw21], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw21], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw21], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw21], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw22] = TextDrawCreate(518.000000, 255.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw22], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw22], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw22], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw22], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw22], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw22], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw22], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw22], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw22], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw22], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw23] = TextDrawCreate(543.000000, 255.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw23], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw23], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw23], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw23], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw23], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw23], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw23], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw23], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw23], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw23], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw24] = TextDrawCreate(573.000000, 253.000000, sixtynine);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw24], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw24], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw24], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw24], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw24], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw24], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw24], 1);

	PlayerEnum[playerid][Textdraw25] = TextDrawCreate(573.000000, 236.000000, grapes);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw25], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw25], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw25], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw25], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw25], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw25], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw25], 1);

	PlayerEnum[playerid][Textdraw26] = TextDrawCreate(573.000000, 219.000000, cherry);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw26], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw26], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw26], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw26], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw26], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw26], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw26], 1);

	PlayerEnum[playerid][Textdraw27] = TextDrawCreate(573.000000, 202.000000, bell);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw27], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw27], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw27], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw27], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw27], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw27], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw27], 1);

	PlayerEnum[playerid][Textdraw28] = TextDrawCreate(573.000000, 185.000000, bar);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw28], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw28], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw28], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw28], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw28], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw28], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw28], 1);

	PlayerEnum[playerid][Textdraw29] = TextDrawCreate(573.000000, 168.000000, doublebar);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw29], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw29], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw29], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw29], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw29], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw29], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw29], 1);

	PlayerEnum[playerid][Textdraw30] = TextDrawCreate(496.000000, 281.000000, wager);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw30], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw30], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw30], 0.439999, 2.800000);
	TextDrawColor(PlayerEnum[playerid][Textdraw30], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw30], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw30], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw30], 1);
	
	PlayerEnum[playerid][Textdraw31] = TextDrawCreate(563.000000, 327.000000, "~n~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw31], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw31], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw31], 0.500000, 10.700002);
	TextDrawColor(PlayerEnum[playerid][Textdraw31], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw31], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw31], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw31], 22.000000, 140.000000);

	PlayerEnum[playerid][Textdraw32] = TextDrawCreate(629.000000, 342.000000, "~w~won:   ~g~$0");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw32], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw32], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw32], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw32], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw32], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw32], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw32], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw32], 1);

	PlayerEnum[playerid][Textdraw33] = TextDrawCreate(629.000000, 352.000000, "-------------------------");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw33], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw33], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw33], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw33], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw33], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw33], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw33], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw33], 1);

	PlayerEnum[playerid][Textdraw34] = TextDrawCreate(629.000000, 363.000000, "~w~total:    ~y~$0");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw34], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw34], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw34], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw34], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw34], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw34], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw34], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw34], 1);

	PlayerEnum[playerid][Textdraw35] = TextDrawCreate(629.000000, 328.000000, "~w~paid:    ~r~$0");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw35], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw35], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw35], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw35], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw35], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw35], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw35], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw35], 1);

	PlayerEnum[playerid][Textdraw36] = TextDrawCreate(631.000000, 408.000000, "~w~Stop: ~b~/stopgamble");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw36], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw36], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw36], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw36], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw36], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw36], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw36], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw36], 1);

	PlayerEnum[playerid][Textdraw37] = TextDrawCreate(585.000000, 394.000000, "~w~Spin: ~b~~k~~VEHICLE_ENTER_EXIT~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw37], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw37], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw37], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw37], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw37], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw37], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw37], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw37], 1);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/gamble", true))
    {
        for(new i = 0; i<sizeof(BanditLocs); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid,1.0,BanditLocs[i][0],BanditLocs[i][1], BanditLocs[i][2]))
            {
		        if(IsGambling[playerid] == false) //If player isn't gambling
		        {
					ShowPlayerDialog(playerid,DIALOG_STARTGAMBLE,DIALOG_STYLE_MSGBOX,"Start Gambling","Do you really want to start gambling?","Yes","No");
                    return 1;
				}else return SendClientMessage(playerid,0xFF0000FF,"You can't use this command now since you are already gambling!");
   			}
			else if(!IsPlayerInRangeOfPoint(playerid,1.0,BanditLocs[i][0],BanditLocs[i][1], BanditLocs[i][2]) && i == sizeof(BanditLocs) - 1)
		 	{
		 		SendClientMessage(playerid,0xFF0000FF,"You can't use this command now since you're not close enough to any slot machine.");
			}
		}
        return 1;
    }
    if(!strcmp(cmdtext, "/stopgamble", true))
    {
        if(IsGambling[playerid] == true)
        {
            if(IsSpinning[playerid] == false)
            {
            	ShowPlayerDialog(playerid,DIALOG_STOPGAMBLE,DIALOG_STYLE_MSGBOX,"Stop Gambling","Do you really want to stop gambling?","Yes","No");
			}else return SendClientMessage(playerid,0xFF0000FF,"You can't stop now since the slot machine is still running. Please wait unti it's finished.");
		}else return SendClientMessage(playerid,0xFF0000FF,"You can't use this command now since you're currently not gambling");
        return 1;
    }
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)) //If player presses ENTER
    {
        if(IsGambling[playerid] == true)
        {
            if(IsSpinning[playerid] == false)
            {
	            if(GetPlayerMoney(playerid) >= GAMBLE_WAGER)
	            {
	                PlayerEnum[playerid][TotalPaid] = PlayerEnum[playerid][TotalPaid] + GAMBLE_WAGER;
	                CallRemoteFunction("GivePlayerCash","ii", playerid,GAMBLE_WAGER - GAMBLE_WAGER*2);
	                IsSpinning[playerid] = true;
			        PreSpinTimer = SetTimer("Prespin", 100, true);
			        SetTimer("SpinSpinners", 3000, false);
			        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw2]);
					TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw3]);
					TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw4]);
					TextDrawHideForPlayer(playerid, PlayerEnum[playerid][Textdraw5]);
					if(GetPlayerMoney(playerid) < GAMBLE_WAGER)
					{
					    new wager[16];
						format(wager,sizeof(wager),"~r~Wager = $%i", GAMBLE_WAGER);
						TextDrawSetString(PlayerEnum[playerid][Textdraw30],wager);
					}
					else
					{
					    new wager[16];
						format(wager,sizeof(wager),"~y~Wager = $%i", GAMBLE_WAGER);
						TextDrawSetString(PlayerEnum[playerid][Textdraw30],wager);
					}
					new doublebar[16], bar[16], bell[16], cherry[16], grapes[16], sixtynine[16];
					format(doublebar,sizeof(doublebar),"= $%i",REWARD_DOUBLEBAR);
					format(bar,sizeof(bar),"= $%i",REWARD_BAR);
					format(bell,sizeof(bell),"= $%i",REWARD_BELL);
					format(cherry,sizeof(cherry),"= $%i",REWARD_CHERRY);
					format(grapes,sizeof(grapes),"= $%i",REWARD_GRAPES);
					format(sixtynine,sizeof(sixtynine),"= $%i",REWARD_SIXTYNINE);
					TextDrawSetString(PlayerEnum[playerid][Textdraw29],doublebar);
					TextDrawSetString(PlayerEnum[playerid][Textdraw28],bar);
					TextDrawSetString(PlayerEnum[playerid][Textdraw24],sixtynine);
					TextDrawSetString(PlayerEnum[playerid][Textdraw27],bell);
					TextDrawSetString(PlayerEnum[playerid][Textdraw25],grapes);
					TextDrawSetString(PlayerEnum[playerid][Textdraw26],cherry);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw29]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw28]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw24]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw27]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw25]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw26]);
					SetPlayerWonPaid(playerid);
				}
				else return SendClientMessage(playerid,0xFF0000FF,"You can not gamble anymore, you don't have enough money to pay the wager!");
			}else return SendClientMessage(playerid,0xFF0000FF,"You can't spin again yet, the machine is still running. Wait until the draw is finished.");
		}
    }
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
		case DIALOG_STARTGAMBLE:
		{
		    if(response) //If player pressed the first ("Yes") button
		    {
		        if(GetPlayerMoney(playerid) >= GAMBLE_WAGER)
		        {
			        IsGambling[playerid] = true;
			        PlayerEnum[playerid][TotalPaid] = 0;
			        PlayerEnum[playerid][TotalWon] = 0;
			        PlayerEnum[playerid][TotalTotal] = 0;
			        TogglePlayerControllable(playerid,0);
			        GetPlayerPos(playerid,pX,pY,pZ);
			        SetPlayerPos(playerid,2221.9514,1619.6721,1006.1836);
			        SetPlayerCameraPos(playerid,2235.9072, 1600.9279, 1000.8791);
			        SetPlayerCameraLookAt(playerid,2236.6072, 1600.9279, 1000.6791);
			        SetPlayerWonPaid(playerid);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw0]); //black box side
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw1]); //Black box bottom
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw6]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw7]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw8]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw9]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw10]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw11]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw12]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw13]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw14]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw15]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw16]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw17]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw18]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw19]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw20]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw21]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw22]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw23]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw24]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw25]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw26]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw27]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw28]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw29]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw30]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw31]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw32]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw33]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw34]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw35]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw36]);
			        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw37]);
			    }
			    else
			    {
			        SendClientMessage(playerid,0xFF0000FF,"You do not have enough money to pay the wager. You can not gamble right now.");
			    }
	        	return 1;
		    }
		}
		case DIALOG_STOPGAMBLE:
		{
		    if(response) //If player pressed the first ("Yes") button
		    {
		        IsGambling[playerid] = false;
		        TogglePlayerControllable(playerid,1);
		        SetPlayerPos(playerid,pX,pY,pZ);
		        SetCameraBehindPlayer(playerid);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw0]); //black box side
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw1]); //Black box bottom
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw2]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw3]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw4]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw5]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw6]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw7]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw8]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw9]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw10]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw11]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw12]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw13]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw14]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw15]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw16]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw17]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw18]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw19]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw20]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw21]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw22]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw23]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw24]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw25]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw26]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw27]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw28]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw29]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw30]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw31]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw32]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw33]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw34]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw35]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw36]);
		        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw37]);
	        	return 1;
		    }
		}
	}
	return 1;
}

public Prespin(playerid)
{
	new Float:rxL, Float:ryL, Float:rzL;
	new Float:rxM, Float:ryM, Float:rzM;
	new Float:rxR, Float:ryR, Float:rzR;
	GetPlayerObjectRot(playerid,LeftSpinner,rxL, ryL, rzL);
	GetPlayerObjectRot(playerid,LeftSpinner,rxM, ryM, rzM);
	GetPlayerObjectRot(playerid,LeftSpinner,rxR, ryR, rzR);
    if(movedup == false)
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  + ZOff,0.01,rxL + 120.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791  + ZOff,0.01,rxM + 120.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  + ZOff,0.01,rxR + 120.0, 0.00,-90.0);
		movedup = true;
	}
	else
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  - ZOff,0.01,rxL + 120.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791   - ZOff,0.01,rxM + 120.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  - ZOff,0.01,rxR + 120.0, 0.00,-90.0);
		movedup = false;
	}
	return 1;
}

public SpinSpinners(playerid)
{
	KillTimer(PreSpinTimer);
	new RandSL = random(sizeof(Rotations));
	new RandSM = random(sizeof(Rotations));
	new RandSR = random(sizeof(Rotations));
	if(movedup == false)
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  + ZOff,0.1,Rotations[RandSL] + 5.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791  + ZOff,0.1,Rotations[RandSM] + 5.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  + ZOff,0.1,Rotations[RandSR] + 5.0, 0.00,-90.0);
	}
	else
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  - ZOff,0.1,Rotations[RandSL] + 5.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791  - ZOff,0.1,Rotations[RandSM] + 5.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  - ZOff,0.1,Rotations[RandSR]+ 5.0, 0.00,-90.0);
	}
	SymbolSL = ResultIDsLeft[RandSL];
	SymbolSM = ResultIDsMiddle[RandSM];
	SymbolSR = ResultIDsRight[RandSR];
	GiveResult(playerid);
	return 1;
}

public GiveResult(playerid)
{
    IsSpinning[playerid] = false;
	TextDrawSetString(PlayerEnum[playerid][Textdraw2],ResultNames[SymbolSL - 1]);
	TextDrawSetString(PlayerEnum[playerid][Textdraw3],ResultNames[SymbolSM - 1]);
	TextDrawSetString(PlayerEnum[playerid][Textdraw4],ResultNames[SymbolSR - 1]);
	TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw2]); //Left result
	TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw3]); //Middle result
	TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw4]); //Right result
	if(SymbolSL == SymbolSM && SymbolSM == SymbolSR && SymbolSL == SymbolSR) //If all the symbols are the same
	{
		TextDrawShowForPlayer(playerid, PlayerEnum[playerid][Textdraw5]);
		if(SymbolSL == 1) //If the first symbol (thus the other two too) is Symbol ID 1 (goldbar)
		{
		    new doublebar[16];
		    format(doublebar,sizeof(doublebar),"= ~r~~h~$%i",REWARD_DOUBLEBAR);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw29],doublebar);
            CallRemoteFunction("GivePlayerCash","ii", playerid,REWARD_DOUBLEBAR);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_DOUBLEBAR;
            PlayerPlaySound(playerid,5461,0,0,0);
		}
		else if(SymbolSL == 2)
		{
		    new bar[16];
		    format(bar,sizeof(bar),"= ~r~~h~$%i",REWARD_BAR);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw28],bar);
            CallRemoteFunction("GivePlayerCash","ii", playerid,REWARD_BAR);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_BAR;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else if(SymbolSL == 3)
		{
		    new sixtynine[16];
		    format(sixtynine,sizeof(sixtynine),"= ~r~~h~$%i",REWARD_SIXTYNINE);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw24],sixtynine);
            CallRemoteFunction("GivePlayerCash","ii", playerid,REWARD_SIXTYNINE);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_SIXTYNINE;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else if(SymbolSL == 4)
		{
		    new bell[16];
		    format(bell,sizeof(bell),"= ~r~~h~$%i",REWARD_BELL);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw27],bell);
            CallRemoteFunction("GivePlayerCash","ii", playerid,REWARD_BELL);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_BELL;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else if(SymbolSL == 5)
		{
		    new grapes[16];
		    format(grapes,sizeof(grapes),"= ~r~~h~$%i",REWARD_GRAPES);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw25],grapes);
            CallRemoteFunction("GivePlayerCash","ii", playerid,REWARD_GRAPES);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_GRAPES;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else
		{
		    new cherry[16];
		    format(cherry,sizeof(cherry),"= ~r~~h~$%i",REWARD_CHERRY);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw26],cherry);
		    CallRemoteFunction("GivePlayerCash","ii", playerid,REWARD_CHERRY);
		    PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_CHERRY;
		    PlayerPlaySound(playerid,5448,0,0,0);
		}
	}
	SetPlayerWonPaid(playerid);
}

public SetPlayerWonPaid(playerid)
{
	new PaidString[32], WonString[32], TotalString[32];
	PlayerEnum[playerid][TotalTotal] = PlayerEnum[playerid][TotalWon] - PlayerEnum[playerid][TotalPaid];
	format(PaidString,sizeof(PaidString),"~w~paid:    ~r~$%i",PlayerEnum[playerid][TotalPaid]);
    format(WonString,sizeof(WonString),"~w~won:   ~g~$%i",PlayerEnum[playerid][TotalWon]);
    if(PlayerEnum[playerid][TotalTotal] > 0)
    {
        format(TotalString,sizeof(TotalString),"~w~total:    ~g~+$%i",PlayerEnum[playerid][TotalTotal]);
    }
    else if(PlayerEnum[playerid][TotalTotal] == 0)
    {
        format(TotalString,sizeof(TotalString),"~w~total:    ~y~$%i",PlayerEnum[playerid][TotalTotal]);
    }
    else if(PlayerEnum[playerid][TotalTotal] < 0)
    {
        format(TotalString,sizeof(TotalString),"~w~total:    ~r~$%i",PlayerEnum[playerid][TotalTotal]);
    }
    TextDrawSetString(PlayerEnum[playerid][Textdraw32],WonString);
    TextDrawSetString(PlayerEnum[playerid][Textdraw34],TotalString);
    TextDrawSetString(PlayerEnum[playerid][Textdraw35],PaidString);
    TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw32]);
    TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw34]);
    TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw35]);
	return 1;
}
