#include <YSI\y_hooks>

static PlayerText:DashboardUI[MAX_PLAYERS][36];

hook OnPlayerInit(playerid)
{
    // ensure no UI on dashboard
    DashboardUI[playerid][0] = CreatePlayerTextDraw(playerid, -0.399998, -0.737546, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][0], 649.000000, 480.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][0], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][0], 909721599);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][0], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][0], 0);

    DashboardUI[playerid][1] = CreatePlayerTextDraw(playerid, 509.000000, 1.587442, "box");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][1], 0.000000, 55.00000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][1], 641.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][1], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][1], 791754239);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][1], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][1], 0);

    DashboardUI[playerid][2] = CreatePlayerTextDraw(playerid, 527.500000, 0.000000, "");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][2], 90.000000, 90.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][2], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][2], -1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][2], 791754239);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][2], 5);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][2], 0);
    PlayerTextDrawSetPreviewModel(playerid, DashboardUI[playerid][2], 0);
    PlayerTextDrawSetPreviewRot(playerid, DashboardUI[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);

    DashboardUI[playerid][3] = CreatePlayerTextDraw(playerid, 575.000488, 96.914939, "Khalil_Zoldyck~n~22 Years~n~Male~n~Single");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][3], 0.301499, 0.921875);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][3], 2);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][3], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][3], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][3], 0);

    DashboardUI[playerid][4] = CreatePlayerTextDraw(playerid, 10.000000, 386.000000, "");//"00:00");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][4], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][4], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][4], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][4], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][4], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][4], 0);

    DashboardUI[playerid][5] = CreatePlayerTextDraw(playerid, 631.999328, 226.503662, "$10000000");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][5], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][5], 3);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][5], 626334719);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][5], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][5], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][5], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][5], 3);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][5], 0);

    DashboardUI[playerid][6] = CreatePlayerTextDraw(playerid, 504.333312, 142.431854, "1st-seperator");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][6], 0.000000, -0.150001);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][6], 640.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][6], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][6], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][6], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][6], 909655807);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][6], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][6], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][6], 0);

    DashboardUI[playerid][7] = CreatePlayerTextDraw(playerid, 493.500000, 220.000000, "2nd-seperator");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][7], 0.000000, -0.150001);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][7], 647.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][7], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][7], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][7], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][7], 909655807);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][7], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][7], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][7], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][7], 0);

    DashboardUI[playerid][8] = CreatePlayerTextDraw(playerid, 494.000000, 267.201049, "3rd-seperator");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][8], 0.000000, -0.150001);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][8], 648.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][8], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][8], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][8], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][8], 909655807);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][8], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][8], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][8], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][8], 0);

    DashboardUI[playerid][9] = CreatePlayerTextDraw(playerid, 495.000000, 369.000000, "4th-seperator");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][9], 0.000000, -0.150001);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][9], 649.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][9], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][9], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][9], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][9], 909655807);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][9], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][9], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][9], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][9], 0);

    DashboardUI[playerid][10] = CreatePlayerTextDraw(playerid, 515.333312, 150.000000, "BG-HP");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][10], 0.000000, 0.766664);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][10], 630.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][10], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][10], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][10], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][10], 1343173119);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][10], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][10], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][10], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][10], 0);

    DashboardUI[playerid][11] = CreatePlayerTextDraw(playerid, 515.333312, 150.000000, "PROGRESS-HP");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][11], 0.000000, 0.766664);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][11], 600.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][11], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][11], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][11], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][11], -134118657);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][11], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][11], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][11], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][11], 0);

    DashboardUI[playerid][12] = CreatePlayerTextDraw(playerid, 573.000000, 146.000000, "100");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][12], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][12], 2);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][12], 437853951);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][12], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][12], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][12], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][12], 0);

    DashboardUI[playerid][13] = CreatePlayerTextDraw(playerid, 515.333312, 168.000000, "BG-ARMOR");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][13], 0.000000, 0.766664);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][13], 630.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][13], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][13], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][13], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][13], 523981055);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][13], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][13], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][13], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][13], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][13], 0);

    DashboardUI[playerid][14] = CreatePlayerTextDraw(playerid, 515.333312, 168.000000, "PROGRESS-ARMOR");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][14], 0.000000, 0.766664);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][14], 600.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][14], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][14], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][14], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][14], -1326056705);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][14], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][14], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][14], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][14], 0);
    PlayerTextDrawSetSelectable(playerid, DashboardUI[playerid][14], true);

    DashboardUI[playerid][15] = CreatePlayerTextDraw(playerid, 574.000000, 164.000000, "100");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][15], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][15], 2);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][15], 437853951);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][15], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][15], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][15], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][15], 0);

    DashboardUI[playerid][16] = CreatePlayerTextDraw(playerid, 576.500000, 186.000000, "Level: 18");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][16], 0.307999, 1.258751);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][16], 2);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][16], -1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][16], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][16], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][16], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][16], 2);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][16], 0);

    DashboardUI[playerid][17] = CreatePlayerTextDraw(playerid, 515.333312, 204.000000, "BG-XP");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][17], 0.000000, 0.766664);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][17], 630.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][17], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][17], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][17], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][17], 1479743999);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][17], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][17], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][17], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][17], 0);

    DashboardUI[playerid][18] = CreatePlayerTextDraw(playerid, 515.333312, 204.000000, "PROGRESS-XP");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][18], 0.000000, 0.766664);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][18], 573.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][18], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][18], -1);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][18], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][18], -24311553);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][18], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][18], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][18], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][18], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][18], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][18], 0);

    DashboardUI[playerid][19] = CreatePlayerTextDraw(playerid, 574.400024, 200.000000, "43/80");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][19], 0.307999, 1.424998);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][19], 2);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][19], 437853951);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][19], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][19], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][19], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][19], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][19], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][19], 0);

    //DashboardUI[playerid][20] = CreatePlayerTextDraw(playerid, 515.333312, 280.000000, "box");
    //PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][20], 0.000000, 1.500000);
    //PlayerTextDrawTextSize(playerid, DashboardUI[playerid][20], 630.000000, 0.000000);
    //PlayerTextDrawAlignment(playerid, DashboardUI[playerid][20], 1);
    //PlayerTextDrawColor(playerid, DashboardUI[playerid][20], -630027777);
    //PlayerTextDrawUseBox(playerid, DashboardUI[playerid][20], 1);
    //PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][20], 1921637119);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][20], 0);
    //PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][20], 1);
    //PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][20], 255);
    //PlayerTextDrawFont(playerid, DashboardUI[playerid][20], 1);
    //PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][20], 1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][20], 0);

    //DashboardUI[playerid][21] = CreatePlayerTextDraw(playerid, 515.333312, 300.000000, "box");
    //PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][21], 0.000000, 1.500000);
    //PlayerTextDrawTextSize(playerid, DashboardUI[playerid][21], 630.000000, 0.000000);
    //PlayerTextDrawAlignment(playerid, DashboardUI[playerid][21], 1);
    //PlayerTextDrawColor(playerid, DashboardUI[playerid][21], -630027777);
    //PlayerTextDrawUseBox(playerid, DashboardUI[playerid][21], 1);
    //PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][21], 1921637119);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][21], 0);
    //PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][21], 1);
    //PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][21], 255);
    //PlayerTextDrawFont(playerid, DashboardUI[playerid][21], 1);
    //PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][21], 1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][21], 0);

    //DashboardUI[playerid][22] = CreatePlayerTextDraw(playerid, 515.333312, 320.000000, "box");
    //PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][22], 0.000000, 1.500000);
    //PlayerTextDrawTextSize(playerid, DashboardUI[playerid][22], 630.000000, 0.000000);
    //PlayerTextDrawAlignment(playerid, DashboardUI[playerid][22], 1);
    //PlayerTextDrawColor(playerid, DashboardUI[playerid][22], -630027777);
    //PlayerTextDrawUseBox(playerid, DashboardUI[playerid][22], 1);
    //PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][22], 1921637119);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][22], 0);
    //PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][22], 1);
    //PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][22], 255);
    //PlayerTextDrawFont(playerid, DashboardUI[playerid][22], 1);
    //PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][22], 1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][22], 0);

    DashboardUI[playerid][23] = CreatePlayerTextDraw(playerid, 515.333312, 340.000000, "box");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][23], 0.000000, 1.500000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][23], 630.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][23], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][23], -630027777);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][23], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][23], 1921637119);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][23], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][23], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][23], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][23], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][23], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][23], 0);

    //DashboardUI[playerid][24] = CreatePlayerTextDraw(playerid, 520.000000, 278.500000, "Estates");
    //PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][24], 0.351999, 1.600000);
    //PlayerTextDrawTextSize(playerid, DashboardUI[playerid][24], 630.000000, 4.0);    
    //PlayerTextDrawAlignment(playerid, DashboardUI[playerid][24], 1);
    //PlayerTextDrawColor(playerid, DashboardUI[playerid][24], -1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][24], 0);
    //PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][24], 0);
    //PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][24], 255);
    //PlayerTextDrawFont(playerid, DashboardUI[playerid][24], 1);
    //PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][24], 1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][24], 0);

    //DashboardUI[playerid][25] = CreatePlayerTextDraw(playerid, 520.000000, 298.000000, "Inventory");
    //PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][25], 0.400000, 1.600000);
    //PlayerTextDrawTextSize(playerid, DashboardUI[playerid][24], 630.000000, 4.000000);
    //PlayerTextDrawAlignment(playerid, DashboardUI[playerid][25], 1);
    //PlayerTextDrawColor(playerid, DashboardUI[playerid][25], -1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][25], 0);
    //PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][25], 0);
    //PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][25], 255);
    //PlayerTextDrawFont(playerid, DashboardUI[playerid][25], 1);
    //PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][25], 1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][25], 0);

    //DashboardUI[playerid][26] = CreatePlayerTextDraw(playerid, 520.000000, 318.000000, "My cars");
    //PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][26], 0.400000, 1.600000);
    //PlayerTextDrawTextSize(playerid, DashboardUI[playerid][26], 630.000000, 4.000000);
    //PlayerTextDrawAlignment(playerid, DashboardUI[playerid][26], 1);
    //PlayerTextDrawColor(playerid, DashboardUI[playerid][26], -1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][26], 0);
    //PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][26], 0);
    //PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][26], 255);
    //PlayerTextDrawFont(playerid, DashboardUI[playerid][26], 1);
    //PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][26], 1);
    //PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][26], 0);

    DashboardUI[playerid][27] = CreatePlayerTextDraw(playerid, 520.000000, 338.000000, "Achievements");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][27], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][27], 630.000000, 4.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][27], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][27], -1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][27], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][27], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][27], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][27], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][27], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][27], 0);
    PlayerTextDrawSetSelectable(playerid, DashboardUI[playerid][27], true);

    DashboardUI[playerid][28] = CreatePlayerTextDraw(playerid, 515.333312, 379.000000, "box");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][28], 0.000000, 1.999999);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][28], 630.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][28], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][28], -5963521);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][28], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][28], -5963521);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][28], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][28], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][28], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][28], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][28], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][28], 0);

    DashboardUI[playerid][29] = CreatePlayerTextDraw(playerid, 520.000000, 380.000000, "Start_game");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][29], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][29], 630.000000, 20.720016);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][29], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][29], 255);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][29], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][29], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][29], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][29], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][29], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][29], 0);
    PlayerTextDrawSetSelectable(playerid, DashboardUI[playerid][29], true);


    DashboardUI[playerid][30] = CreatePlayerTextDraw(playerid, 549.953430, 243.366577, "]]]]]]");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][30], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][30], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][30], 255);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][30], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][30], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][30], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][30], 0);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][30], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][30], 0);

    DashboardUI[playerid][31] = CreatePlayerTextDraw(playerid, 630.599853, 243.737014, "]]]]");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][31], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][31], 3);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][31], -1956378113);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][31], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][31], 1);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][31], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][31], 0);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][31], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][31], 0);

    DashboardUI[playerid][32] = CreatePlayerTextDraw(playerid, 35.666660, 120.725875, "box");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][32], 0.000000, 28.033342);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][32], 470.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][32], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][32], -2139062017);
    PlayerTextDrawUseBox(playerid, DashboardUI[playerid][32], 1);
    PlayerTextDrawBoxColor(playerid, DashboardUI[playerid][32], -1061109505);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][32], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][32], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][32], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][32], 1);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][32], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][32], 0);

    DashboardUI[playerid][33] = CreatePlayerTextDraw(playerid, 45.333343, 125.703674, "Server update notes:");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][33], 0.438333, 1.985775);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][33], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][33], -5963521);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][33], 1);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][33], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][33], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][33], 2);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][33], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][33], 1);

    DashboardUI[playerid][34] = CreatePlayerTextDraw(playerid, 62.666610, 153.496276, "Note:~n~-Welcome_to_our_new_server_Arabica_RolePlay.~n~_This_is__a__server__snapshot__the__official~n~_release_date_will_be_18_juin_2025.~n~-To_join__our__discord__use__this_invitation~n~_link:_discord.gg/arabica~n~~n~_If__you__need__further__information__you_can_~n~_contact_'Khalil_Zoldyck'.~n~Enjoy_your_game_;-)_!");
    PlayerTextDrawLetterSize(playerid, DashboardUI[playerid][34], 0.370333, 1.662222);
    PlayerTextDrawAlignment(playerid, DashboardUI[playerid][34], 1);
    PlayerTextDrawColor(playerid, DashboardUI[playerid][34], -1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][34], 0);
    PlayerTextDrawSetOutline(playerid, DashboardUI[playerid][34], 0);
    PlayerTextDrawBackgroundColor(playerid, DashboardUI[playerid][34], 255);
    PlayerTextDrawFont(playerid, DashboardUI[playerid][34], 2);
    PlayerTextDrawSetProportional(playerid, DashboardUI[playerid][34], 1);
    PlayerTextDrawSetShadow(playerid, DashboardUI[playerid][34], 0);
}

DisplayDashboard(playerid)
{
    new title[256];
    format(title,sizeof(title),"%s~n~%d years~n~%s~n~%s",
        PlayerData[playerid][pUsername], 
        PlayerData[playerid][pAge],
        (PlayerData[playerid][pGender]==1)?("Male"):("Female"),
        (PlayerData[playerid][pMarriedTo] == -1)?("Single"):("Maried")
        );
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][3], title);

    PlayerTextDrawSetPreviewModel(playerid, DashboardUI[playerid][2],PlayerData[playerid][pSkin]);

    new cash[20];
    format(cash,sizeof(cash),"$%08d",PlayerData[playerid][pCash]);
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][5], cash);

    new level[15];
    format(level,sizeof(level),"Level: %d",PlayerData[playerid][pLevel]);
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][16], level);

    //Display XP
    new Float:percentXP= float(PlayerData[playerid][pEXP]) / float(PlayerData[playerid][pLevel] * 4);
    new xpstr[20];
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][18], 515 + 115 * percentXP, 0.000000);
    format(xpstr,sizeof(xpstr),"%d/%d",PlayerData[playerid][pEXP] , (PlayerData[playerid][pLevel]*4));
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][19], xpstr);

    new stars[]="]]]]]]";// Using font 0 the char ']' will be displayed as a star
    new bgstars[14],fgstars[14];
    new wantedlevel = PlayerData[playerid][pWantedLevel];
    if(wantedlevel < 0)
    {
        wantedlevel=0;
    }
    else if(wantedlevel > 6)
    {
        wantedlevel=6;
    }
    strcpy(bgstars, stars, 7 - wantedlevel);
    strcpy(fgstars, stars, 1 + wantedlevel);
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][30], bgstars);
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][31], fgstars);

    //Display HP & Armor
	new Float:hp=PlayerData[playerid][pHealth], 
        Float:armor=PlayerData[playerid][pArmor];
    new hpstr[6],armorstr[6];
    format(hpstr,sizeof(hpstr),"%.0f",hp);
    format(armorstr,sizeof(armorstr),"%.0f",armor);
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][12], hpstr);
    PlayerTextDrawSetString(playerid, DashboardUI[playerid][15], armorstr);
    if(hp>100) hp=100;
    if(armor>100) armor=100;
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][11], 515 + 1.15 * hp, 0.000000);
    PlayerTextDrawTextSize(playerid, DashboardUI[playerid][14], 515 + 1.15 * armor, 0.000000);

    for(new i=0;i<=35;i++)
        PlayerTextDrawShow(playerid, DashboardUI[playerid][i]);
    
    if(hp==0)
        PlayerTextDrawHide(playerid, DashboardUI[playerid][11]);
    if(armor==0)
        PlayerTextDrawHide(playerid, DashboardUI[playerid][14]);
    if(percentXP==0)
        PlayerTextDrawHide(playerid, DashboardUI[playerid][18]);
    
	SelectTextDraw(playerid, 0xFF0000FF);	
}

HideDashboard(playerid)
{
    for(new i=0;i<=35;i++)
        PlayerTextDrawHide(playerid, DashboardUI[playerid][i]);
    CancelSelectTextDraw(playerid);
}


hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid==DashboardUI[playerid][29])
	{
		//Spawn
		SetPlayerToSpawn(playerid);
		CallRemoteFunction("OnRadioFrequencyChange", "ii", playerid, PlayerData[playerid][pChannel] );

		HideDashboard(playerid);		
	}
	if(playertextid==DashboardUI[playerid][27])
	{
        callcmd::achievements(playerid, "");
	}
    return 1;
}