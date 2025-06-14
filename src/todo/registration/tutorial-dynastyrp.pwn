
static Text:TutTxtDraw[54];


ShowTutorialGUI(playerid)
{
    for(new t = 0; t < 11; t++)
    {
        TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
    }
}

HideTutorialGUI(playerid)
{
    for(new t = 0; t < 54; t++)
    {
        TextDrawHideForPlayer(giveplayerid, TutTxtDraw[t]);
    }
}

InitLoginGUI()
{
    TutTxtDraw[0] = TextDrawCreate(487.000000, 303.000000, "'");
	TextDrawBackgroundColor(TutTxtDraw[0], 255);
	TextDrawFont(TutTxtDraw[0], 2);
	TextDrawLetterSize(TutTxtDraw[0], 0.000000, 12.800003);
	TextDrawColor(TutTxtDraw[0], -1061109505);
	TextDrawSetOutline(TutTxtDraw[0], 0);
	TextDrawSetProportional(TutTxtDraw[0], 1);
	TextDrawSetShadow(TutTxtDraw[0], 1);
	TextDrawUseBox(TutTxtDraw[0], 1);
	TextDrawBoxColor(TutTxtDraw[0], 170);
	TextDrawTextSize(TutTxtDraw[0], 146.000000, 45.000000);

	TutTxtDraw[1] = TextDrawCreate(487.000000, 303.000000, "'");
	TextDrawBackgroundColor(TutTxtDraw[1], 255);
	TextDrawFont(TutTxtDraw[1], 1);
	TextDrawLetterSize(TutTxtDraw[1], 0.000000, -1.000000);
	TextDrawColor(TutTxtDraw[1], -1);
	TextDrawSetOutline(TutTxtDraw[1], 0);
	TextDrawSetProportional(TutTxtDraw[1], 1);
	TextDrawSetShadow(TutTxtDraw[1], 1);
	TextDrawUseBox(TutTxtDraw[1], 1);
	TextDrawBoxColor(TutTxtDraw[1], 255);
	TextDrawTextSize(TutTxtDraw[1], 146.000000, -2.000000);

	TutTxtDraw[2] = TextDrawCreate(487.000000, 427.000000, "'");
	TextDrawBackgroundColor(TutTxtDraw[2], 255);
	TextDrawFont(TutTxtDraw[2], 1);
	TextDrawLetterSize(TutTxtDraw[2], 0.000000, -1.000000);
	TextDrawColor(TutTxtDraw[2], -1);
	TextDrawSetOutline(TutTxtDraw[2], 0);
	TextDrawSetProportional(TutTxtDraw[2], 1);
	TextDrawSetShadow(TutTxtDraw[2], 1);
	TextDrawUseBox(TutTxtDraw[2], 1);
	TextDrawBoxColor(TutTxtDraw[2], 255);
	TextDrawTextSize(TutTxtDraw[2], 146.000000, -2.000000);

	TutTxtDraw[3] = TextDrawCreate(147.000000, 299.000000, "'");
	TextDrawBackgroundColor(TutTxtDraw[3], 255);
	TextDrawFont(TutTxtDraw[3], 1);
	TextDrawLetterSize(TutTxtDraw[3], 0.000000, 13.600002);
	TextDrawColor(TutTxtDraw[3], -1);
	TextDrawSetOutline(TutTxtDraw[3], 0);
	TextDrawSetProportional(TutTxtDraw[3], 1);
	TextDrawSetShadow(TutTxtDraw[3], 1);
	TextDrawUseBox(TutTxtDraw[3], 1);
	TextDrawBoxColor(TutTxtDraw[3], 255);
	TextDrawTextSize(TutTxtDraw[3], 146.000000, 28.000000);

	TutTxtDraw[4] = TextDrawCreate(487.000000, 299.000000, "'");
	TextDrawBackgroundColor(TutTxtDraw[4], 255);
	TextDrawFont(TutTxtDraw[4], 1);
	TextDrawLetterSize(TutTxtDraw[4], 0.000000, 13.600002);
	TextDrawColor(TutTxtDraw[4], -1);
	TextDrawSetOutline(TutTxtDraw[4], 0);
	TextDrawSetProportional(TutTxtDraw[4], 1);
	TextDrawSetShadow(TutTxtDraw[4], 1);
	TextDrawUseBox(TutTxtDraw[4], 1);
	TextDrawBoxColor(TutTxtDraw[4], 255);
	TextDrawTextSize(TutTxtDraw[4], 486.000000, 34.000000);

	TutTxtDraw[5] = TextDrawCreate(165.000000, 301.000000, "Dynasty Roleplay Tutorial");
	TextDrawBackgroundColor(TutTxtDraw[5], 255);
	TextDrawFont(TutTxtDraw[5], 2);
	TextDrawLetterSize(TutTxtDraw[5], 0.500000, 2.200000);
	TextDrawColor(TutTxtDraw[5], COLOR_NEWS);
	TextDrawSetOutline(TutTxtDraw[5], 0);
	TextDrawSetProportional(TutTxtDraw[5], 1);
	TextDrawSetShadow(TutTxtDraw[5], 3);


	//
	// FIRST TUTORIAL TEXT
	//

	TutTxtDraw[6] = TextDrawCreate(166.000000, 331.000000, "Welcome to Dynasty Roleplay. This is a roleplay server, which means that you take on");
	TextDrawBackgroundColor(TutTxtDraw[6], 255);
	TextDrawFont(TutTxtDraw[6], 1);
	TextDrawLetterSize(TutTxtDraw[6], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[6], -1);
	TextDrawSetOutline(TutTxtDraw[6], 0);
	TextDrawSetProportional(TutTxtDraw[6], 1);
	TextDrawSetShadow(TutTxtDraw[6], 2);

	TutTxtDraw[7] = TextDrawCreate(166.000000, 344.000000, "a role and play a character. Be it a crook, an officer of the law or just a regular citizen.");
	TextDrawBackgroundColor(TutTxtDraw[7], 255);
	TextDrawFont(TutTxtDraw[7], 1);
	TextDrawLetterSize(TutTxtDraw[7], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[7], -1);
	TextDrawSetOutline(TutTxtDraw[7], 0);
	TextDrawSetProportional(TutTxtDraw[7], 1);
	TextDrawSetShadow(TutTxtDraw[7], 2);

	TutTxtDraw[8] = TextDrawCreate(166.000000, 368.000000, "This also means that there is a difference between you as player and your character.");
	TextDrawBackgroundColor(TutTxtDraw[8], 255);
	TextDrawFont(TutTxtDraw[8], 1);
	TextDrawLetterSize(TutTxtDraw[8], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[8], -1);
	TextDrawSetOutline(TutTxtDraw[8], 0);
	TextDrawSetProportional(TutTxtDraw[8], 1);
	TextDrawSetShadow(TutTxtDraw[8], 2);

	TutTxtDraw[9] = TextDrawCreate(166.000000, 381.000000, "We refer to this as OOC (out of character) and IC (in character). This is something");
	TextDrawBackgroundColor(TutTxtDraw[9], 255);
	TextDrawFont(TutTxtDraw[9], 1);
	TextDrawLetterSize(TutTxtDraw[9], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[9], -1);
	TextDrawSetOutline(TutTxtDraw[9], 0);
	TextDrawSetProportional(TutTxtDraw[9], 1);
	TextDrawSetShadow(TutTxtDraw[9], 2);

	TutTxtDraw[10] = TextDrawCreate(166.000000, 394.000000, "that is an essential part of the server, therefore we keep them separate.");
	TextDrawBackgroundColor(TutTxtDraw[10], 255);
	TextDrawFont(TutTxtDraw[10], 1);
	TextDrawLetterSize(TutTxtDraw[10], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[10], -1);
	TextDrawSetOutline(TutTxtDraw[10], 0);
	TextDrawSetProportional(TutTxtDraw[10], 1);
	TextDrawSetShadow(TutTxtDraw[10], 2);

	//
	// SECOND TUTORIAL TEXT
	//

	TutTxtDraw[11] = TextDrawCreate(166.000000, 331.000000, "There are many ways to earn money and there are many jobs available throughout");
	TextDrawBackgroundColor(TutTxtDraw[11], 255);
	TextDrawFont(TutTxtDraw[11], 1);
	TextDrawLetterSize(TutTxtDraw[11], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[11], -1);
	TextDrawSetOutline(TutTxtDraw[11], 0);
	TextDrawSetProportional(TutTxtDraw[11], 1);
	TextDrawSetShadow(TutTxtDraw[11], 2);

	TutTxtDraw[12] = TextDrawCreate(166.000000, 344.000000, "the city. We recommend that you try Trucker or Pizza Boy Job first to earn some");
	TextDrawBackgroundColor(TutTxtDraw[12], 255);
	TextDrawFont(TutTxtDraw[12], 1);
	TextDrawLetterSize(TutTxtDraw[12], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[12], -1);
	TextDrawSetOutline(TutTxtDraw[12], 0);
	TextDrawSetProportional(TutTxtDraw[12], 1);
	TextDrawSetShadow(TutTxtDraw[12], 2);

	TutTxtDraw[13] = TextDrawCreate(166.000000, 357.000000, "starting cash. You can find a job with the ~r~/findjob ~w~command.");
	TextDrawBackgroundColor(TutTxtDraw[13], 255);
	TextDrawFont(TutTxtDraw[13], 1);
	TextDrawLetterSize(TutTxtDraw[13], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[13], -1);
	TextDrawSetOutline(TutTxtDraw[13], 0);
	TextDrawSetProportional(TutTxtDraw[13], 1);
	TextDrawSetShadow(TutTxtDraw[13], 2);

	TutTxtDraw[14] = TextDrawCreate(166.000000, 381.000000, "You can also use the ~r~/jobhelp ~w~command to get more information about the jobs.");
	TextDrawBackgroundColor(TutTxtDraw[14], 255);
	TextDrawFont(TutTxtDraw[14], 1);
	TextDrawLetterSize(TutTxtDraw[14], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[14], -1);
	TextDrawSetOutline(TutTxtDraw[14], 0);
	TextDrawSetProportional(TutTxtDraw[14], 1);
	TextDrawSetShadow(TutTxtDraw[14], 2);

	TutTxtDraw[15] = TextDrawCreate(166.000000, 394.000000, "You can ~r~/withdraw ~w~and ~r~/deposit ~w~at the bank whenever you wish.");
	TextDrawBackgroundColor(TutTxtDraw[15], 255);
	TextDrawFont(TutTxtDraw[15], 1);
	TextDrawLetterSize(TutTxtDraw[15], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[15], -1);
	TextDrawSetOutline(TutTxtDraw[15], 0);
	TextDrawSetProportional(TutTxtDraw[15], 1);
	TextDrawSetShadow(TutTxtDraw[15], 2);

	//
	// THIRD TUTORIAL TEXT
	//

	TutTxtDraw[16] = TextDrawCreate(166.000000, 331.000000, "There are several law enforcement agencies such as the ~b~LSPD ~w~and the ~b~FBI~w~, who enforce");
	TextDrawBackgroundColor(TutTxtDraw[16], 255);
	TextDrawFont(TutTxtDraw[16], 1);
	TextDrawLetterSize(TutTxtDraw[16], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[16], -1);
	TextDrawSetOutline(TutTxtDraw[16], 0);
	TextDrawSetProportional(TutTxtDraw[16], 1);
	TextDrawSetShadow(TutTxtDraw[16], 2);

	TutTxtDraw[17] = TextDrawCreate(166.000000, 344.000000, "the law. They will arrest you if you break the law. If you cause a lot of trouble then");
	TextDrawBackgroundColor(TutTxtDraw[17], 255);
	TextDrawFont(TutTxtDraw[17], 1);
	TextDrawLetterSize(TutTxtDraw[17], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[17], -1);
	TextDrawSetOutline(TutTxtDraw[17], 0);
	TextDrawSetProportional(TutTxtDraw[17], 1);
	TextDrawSetShadow(TutTxtDraw[17], 2);

	TutTxtDraw[18] = TextDrawCreate(166.000000, 357.000000, "you could be marked as one of the most wanted suspects. Which will mark you ~r~red");
	TextDrawBackgroundColor(TutTxtDraw[18], 255);
	TextDrawFont(TutTxtDraw[18], 1);
	TextDrawLetterSize(TutTxtDraw[18], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[18], -1);
	TextDrawSetOutline(TutTxtDraw[18], 0);
	TextDrawSetProportional(TutTxtDraw[18], 1);
	TextDrawSetShadow(TutTxtDraw[18], 2);

	TutTxtDraw[19] = TextDrawCreate(166.000000, 371.000000, "on the radar/map. If you're caught as the most wanted suspect, then you will be");
	TextDrawBackgroundColor(TutTxtDraw[19], 255);
	TextDrawFont(TutTxtDraw[19], 1);
	TextDrawLetterSize(TutTxtDraw[19], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[19], -1);
	TextDrawSetOutline(TutTxtDraw[19], 0);
	TextDrawSetProportional(TutTxtDraw[19], 1);
	TextDrawSetShadow(TutTxtDraw[19], 2);

	TutTxtDraw[20] = TextDrawCreate(166.000000, 385.000000, "sent to prison for 30 minutes. If you can't do the time, then don't do the crime.");
	TextDrawBackgroundColor(TutTxtDraw[20], 255);
	TextDrawFont(TutTxtDraw[20], 1);
	TextDrawLetterSize(TutTxtDraw[20], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[20], -1);
	TextDrawSetOutline(TutTxtDraw[20], 0);
	TextDrawSetProportional(TutTxtDraw[20], 1);
	TextDrawSetShadow(TutTxtDraw[20], 2);

	TutTxtDraw[21] = TextDrawCreate(166.000000, 398.000000, "You can also join these factions. Just contact them in-game (blue names).");
	TextDrawBackgroundColor(TutTxtDraw[21], 255);
	TextDrawFont(TutTxtDraw[21], 1);
	TextDrawLetterSize(TutTxtDraw[21], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[21], -1);
	TextDrawSetOutline(TutTxtDraw[21], 0);
	TextDrawSetProportional(TutTxtDraw[21], 1);
	TextDrawSetShadow(TutTxtDraw[21], 2);

	//
	// FOURTH TUTORIAL TEXT
	//

	TutTxtDraw[22] = TextDrawCreate(166.000000, 331.000000, "If you get injured then you can either ~r~/accept death ~w~or you can ~r~/service ems ~w~and wait");
	TextDrawBackgroundColor(TutTxtDraw[22], 255);
	TextDrawFont(TutTxtDraw[22], 1);
	TextDrawLetterSize(TutTxtDraw[22], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[22], -1);
	TextDrawSetOutline(TutTxtDraw[22], 0);
	TextDrawSetProportional(TutTxtDraw[22], 1);
	TextDrawSetShadow(TutTxtDraw[22], 2);

	TutTxtDraw[23] = TextDrawCreate(166.000000, 344.000000, "for an ambulance of the LSFMD to arrive. This will allow you to keep your weapons.");
	TextDrawBackgroundColor(TutTxtDraw[23], 255);
	TextDrawFont(TutTxtDraw[23], 1);
	TextDrawLetterSize(TutTxtDraw[23], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[23], -1);
	TextDrawSetOutline(TutTxtDraw[23], 0);
	TextDrawSetProportional(TutTxtDraw[23], 1);
	TextDrawSetShadow(TutTxtDraw[23], 2);

	TutTxtDraw[24] = TextDrawCreate(166.000000, 357.000000, "You can also join the LSFMD faction by contacting them in-game (pink names) or");
	TextDrawBackgroundColor(TutTxtDraw[24], 255);
	TextDrawFont(TutTxtDraw[24], 1);
	TextDrawLetterSize(TutTxtDraw[24], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[24], -1);
	TextDrawSetOutline(TutTxtDraw[24], 0);
	TextDrawSetProportional(TutTxtDraw[24], 1);
	TextDrawSetShadow(TutTxtDraw[24], 2);

	TutTxtDraw[25] = TextDrawCreate(166.000000, 371.000000, "by applying to join on the forum, which can be found at ~g~"WEBSITE);
	TextDrawBackgroundColor(TutTxtDraw[25], 255);
	TextDrawFont(TutTxtDraw[25], 1);
	TextDrawLetterSize(TutTxtDraw[25], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[25], -1);
	TextDrawSetOutline(TutTxtDraw[25], 0);
	TextDrawSetProportional(TutTxtDraw[25], 1);
	TextDrawSetShadow(TutTxtDraw[25], 2);

	TutTxtDraw[26] = TextDrawCreate(166.000000, 394.000000, "You can also visit one of the hospitals to ~r~/heal ~w~if you get a disease.");
	TextDrawBackgroundColor(TutTxtDraw[26], 255);
	TextDrawFont(TutTxtDraw[26], 1);
	TextDrawLetterSize(TutTxtDraw[26], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[26], -1);
	TextDrawSetOutline(TutTxtDraw[26], 0);
	TextDrawSetProportional(TutTxtDraw[26], 1);
	TextDrawSetShadow(TutTxtDraw[26], 2);

	//
	// FIFTH TUTORIAL TEXT
	//

	TutTxtDraw[27] = TextDrawCreate(166.000000, 331.000000, "There are also ~r~/families ~w~which are basically criminal groups. There are street gangs and");
	TextDrawBackgroundColor(TutTxtDraw[27], 255);
	TextDrawFont(TutTxtDraw[27], 1);
	TextDrawLetterSize(TutTxtDraw[27], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[27], -1);
	TextDrawSetOutline(TutTxtDraw[27], 0);
	TextDrawSetProportional(TutTxtDraw[27], 1);
	TextDrawSetShadow(TutTxtDraw[27], 2);

	TutTxtDraw[28] = TextDrawCreate(166.000000, 344.000000, "then there is organized crime (the mafia). We recommend that you're careful around");
	TextDrawBackgroundColor(TutTxtDraw[28], 255);
	TextDrawFont(TutTxtDraw[28], 1);
	TextDrawLetterSize(TutTxtDraw[28], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[28], -1);
	TextDrawSetOutline(TutTxtDraw[28], 0);
	TextDrawSetProportional(TutTxtDraw[28], 1);
	TextDrawSetShadow(TutTxtDraw[28], 2);

	TutTxtDraw[29] = TextDrawCreate(166.000000, 357.000000, "them. They also fight over several territories known as ~r~/points and also /turfs~w~.");
	TextDrawBackgroundColor(TutTxtDraw[29], 255);
	TextDrawFont(TutTxtDraw[29], 1);
	TextDrawLetterSize(TutTxtDraw[29], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[29], -1);
	TextDrawSetOutline(TutTxtDraw[29], 0);
	TextDrawSetProportional(TutTxtDraw[29], 1);
	TextDrawSetShadow(TutTxtDraw[29], 2);

	TutTxtDraw[30] = TextDrawCreate(166.000000, 381.000000, "You can join a family by approaching them in-game. They can usually be found at their");
	TextDrawBackgroundColor(TutTxtDraw[30], 255);
	TextDrawFont(TutTxtDraw[30], 1);
	TextDrawLetterSize(TutTxtDraw[30], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[30], -1);
	TextDrawSetOutline(TutTxtDraw[30], 0);
	TextDrawSetProportional(TutTxtDraw[30], 1);
	TextDrawSetShadow(TutTxtDraw[30], 2);

	TutTxtDraw[31] = TextDrawCreate(166.000000, 394.000000, "respective headquarters (fronts). Which can be clubs, restaurants, bars etc.");
	TextDrawBackgroundColor(TutTxtDraw[31], 255);
	TextDrawFont(TutTxtDraw[31], 1);
	TextDrawLetterSize(TutTxtDraw[31], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[31], -1);
	TextDrawSetOutline(TutTxtDraw[31], 0);
	TextDrawSetProportional(TutTxtDraw[31], 1);
	TextDrawSetShadow(TutTxtDraw[31], 2);

	//
	// SIXTH TUTORIAL TEXT
	//

	TutTxtDraw[32] = TextDrawCreate(166.000000, 331.000000, "You can smuggle materials packages to get materials, which then allows you to make");
	TextDrawBackgroundColor(TutTxtDraw[32], 255);
	TextDrawFont(TutTxtDraw[32], 1);
	TextDrawLetterSize(TutTxtDraw[32], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[32], -1);
	TextDrawSetOutline(TutTxtDraw[32], 0);
	TextDrawSetProportional(TutTxtDraw[32], 1);
	TextDrawSetShadow(TutTxtDraw[32], 2);

	TutTxtDraw[33] = TextDrawCreate(166.000000, 344.000000, "several items (including weapons). You need the Arms Dealer or Craftsman job for this.");
	TextDrawBackgroundColor(TutTxtDraw[33], 255);
	TextDrawFont(TutTxtDraw[33], 1);
	TextDrawLetterSize(TutTxtDraw[33], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[33], -1);
	TextDrawSetOutline(TutTxtDraw[33], 0);
	TextDrawSetProportional(TutTxtDraw[33], 1);
	TextDrawSetShadow(TutTxtDraw[33], 2);

	TutTxtDraw[34] = TextDrawCreate(166.000000, 357.000000, "You will be able to ~r~/getmats ~w~at one of the material pickups and then deliver it to one of");
	TextDrawBackgroundColor(TutTxtDraw[34], 255);
	TextDrawFont(TutTxtDraw[34], 1);
	TextDrawLetterSize(TutTxtDraw[34], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[34], -1);
	TextDrawSetOutline(TutTxtDraw[34], 0);
	TextDrawSetProportional(TutTxtDraw[34], 1);
	TextDrawSetShadow(TutTxtDraw[34], 2);

	TutTxtDraw[35] = TextDrawCreate(166.000000, 371.000000, "the material factories. Then you can either ~r~/sellgun ~w~or ~r~/craft ~w~something.");
	TextDrawBackgroundColor(TutTxtDraw[35], 255);
	TextDrawFont(TutTxtDraw[35], 1);
	TextDrawLetterSize(TutTxtDraw[35], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[35], -1);
	TextDrawSetOutline(TutTxtDraw[35], 0);
	TextDrawSetProportional(TutTxtDraw[35], 1);
	TextDrawSetShadow(TutTxtDraw[35], 2);

	TutTxtDraw[36] = TextDrawCreate(166.000000, 391.000000, "You can get more information about this with the ~r~/jobhelp ~w~command.");
	TextDrawBackgroundColor(TutTxtDraw[36], 255);
	TextDrawFont(TutTxtDraw[36], 1);
	TextDrawLetterSize(TutTxtDraw[36], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[36], -1);
	TextDrawSetOutline(TutTxtDraw[36], 0);
	TextDrawSetProportional(TutTxtDraw[36], 1);
	TextDrawSetShadow(TutTxtDraw[36], 2);

	//
	// SEVENTH TUTORIAL TEXT
	//

	TutTxtDraw[37] = TextDrawCreate(166.000000, 331.000000, "You can also smuggle drugs from Blueberry into Los Santos. This requires you to have");
	TextDrawBackgroundColor(TutTxtDraw[37], 255);
	TextDrawFont(TutTxtDraw[37], 1);
	TextDrawLetterSize(TutTxtDraw[37], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[37], -1);
	TextDrawSetOutline(TutTxtDraw[37], 0);
	TextDrawSetProportional(TutTxtDraw[37], 1);
	TextDrawSetShadow(TutTxtDraw[37], 2);

	TutTxtDraw[38] = TextDrawCreate(166.000000, 344.000000, "the Drug Smuggler Job. You can then ~r~/getcrate ~w~and smuggle crack or pot.");
	TextDrawBackgroundColor(TutTxtDraw[38], 255);
	TextDrawFont(TutTxtDraw[38], 1);
	TextDrawLetterSize(TutTxtDraw[38], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[38], -1);
	TextDrawSetOutline(TutTxtDraw[38], 0);
	TextDrawSetProportional(TutTxtDraw[38], 1);
	TextDrawSetShadow(TutTxtDraw[38], 2);

	TutTxtDraw[39] = TextDrawCreate(166.000000, 367.000000, "You can also sell and grow drugs with the Drug Dealer Job. You will be able to:");
	TextDrawBackgroundColor(TutTxtDraw[39], 255);
	TextDrawFont(TutTxtDraw[39], 1);
	TextDrawLetterSize(TutTxtDraw[39], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[39], -1);
	TextDrawSetOutline(TutTxtDraw[39], 0);
	TextDrawSetProportional(TutTxtDraw[39], 1);
	TextDrawSetShadow(TutTxtDraw[39], 2);

	TutTxtDraw[40] = TextDrawCreate(166.000000, 381.000000, "- ~r~/sellpot ~w~and ~r~/sellcrack");
	TextDrawBackgroundColor(TutTxtDraw[40], 255);
	TextDrawFont(TutTxtDraw[40], 1);
	TextDrawLetterSize(TutTxtDraw[40], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[40], -1);
	TextDrawSetOutline(TutTxtDraw[40], 0);
	TextDrawSetProportional(TutTxtDraw[40], 1);
	TextDrawSetShadow(TutTxtDraw[40], 2);

	TutTxtDraw[41] = TextDrawCreate(166.000000, 394.000000, "- ~r~/plantweed ~w~anywhere and grow weed");
	TextDrawBackgroundColor(TutTxtDraw[41], 255);
	TextDrawFont(TutTxtDraw[41], 1);
	TextDrawLetterSize(TutTxtDraw[41], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[41], -1);
	TextDrawSetOutline(TutTxtDraw[41], 0);
	TextDrawSetProportional(TutTxtDraw[41], 1);
	TextDrawSetShadow(TutTxtDraw[41], 2);

	//
	// EIGHT TUTORIAL TEXT
	//

	TutTxtDraw[42] = TextDrawCreate(166.000000, 331.000000, "This is a car dealership. There are several throughout the city where you can purchase");
	TextDrawBackgroundColor(TutTxtDraw[42], 255);
	TextDrawFont(TutTxtDraw[42], 1);
	TextDrawLetterSize(TutTxtDraw[42], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[42], -1);
	TextDrawSetOutline(TutTxtDraw[42], 0);
	TextDrawSetProportional(TutTxtDraw[42], 1);
	TextDrawSetShadow(TutTxtDraw[42], 2);

	TutTxtDraw[43] = TextDrawCreate(166.000000, 344.000000, "your own personal vehicle with lock. You can own up to 5 vehicles as a regular player,");
	TextDrawBackgroundColor(TutTxtDraw[43], 255);
	TextDrawFont(TutTxtDraw[43], 1);
	TextDrawLetterSize(TutTxtDraw[43], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[43], -1);
	TextDrawSetOutline(TutTxtDraw[43], 0);
	TextDrawSetProportional(TutTxtDraw[43], 1);
	TextDrawSetShadow(TutTxtDraw[43], 2);

	TutTxtDraw[44] = TextDrawCreate(166.000000, 357.000000, "and have one spawned at a time. The modifications on personal vehicles will save.");
	TextDrawBackgroundColor(TutTxtDraw[44], 255);
	TextDrawFont(TutTxtDraw[44], 1);
	TextDrawLetterSize(TutTxtDraw[44], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[44], -1);
	TextDrawSetOutline(TutTxtDraw[44], 0);
	TextDrawSetProportional(TutTxtDraw[44], 1);
	TextDrawSetShadow(TutTxtDraw[44], 2);

	TutTxtDraw[45] = TextDrawCreate(166.000000, 371.000000, "See ~r~/carhelp ~w~for more information");
	TextDrawBackgroundColor(TutTxtDraw[45], 255);
	TextDrawFont(TutTxtDraw[45], 1);
	TextDrawLetterSize(TutTxtDraw[45], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[45], -1);
	TextDrawSetOutline(TutTxtDraw[45], 0);
	TextDrawSetProportional(TutTxtDraw[45], 1);
	TextDrawSetShadow(TutTxtDraw[45], 2);

	TutTxtDraw[46] = TextDrawCreate(166.000000, 385.000000, "And this is a house. If you own a house then you can store several items inside.");
	TextDrawBackgroundColor(TutTxtDraw[46], 255);
	TextDrawFont(TutTxtDraw[46], 1);
	TextDrawLetterSize(TutTxtDraw[46], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[46], -1);
	TextDrawSetOutline(TutTxtDraw[46], 0);
	TextDrawSetProportional(TutTxtDraw[46], 1);
	TextDrawSetShadow(TutTxtDraw[46], 2);

	TutTxtDraw[47] = TextDrawCreate(166.000000, 397.000000, "You can also rent a house. See ~r~/househelp ~w~and ~r~/renthelp ~w~for more information.");
	TextDrawBackgroundColor(TutTxtDraw[47], 255);
	TextDrawFont(TutTxtDraw[47], 1);
	TextDrawLetterSize(TutTxtDraw[47], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[47], -1);
	TextDrawSetOutline(TutTxtDraw[47], 0);
	TextDrawSetProportional(TutTxtDraw[47], 1);
	TextDrawSetShadow(TutTxtDraw[47], 2);

	//
	// NINTH TUTORIAL TEXT
	//

	TutTxtDraw[48] = TextDrawCreate(166.000000, 331.000000, "We are sure you want to get to playing already, so the tutorial is almost done!");
	TextDrawBackgroundColor(TutTxtDraw[48], 255);
	TextDrawFont(TutTxtDraw[48], 1);
	TextDrawLetterSize(TutTxtDraw[48], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[48], -1);
	TextDrawSetOutline(TutTxtDraw[48], 0);
	TextDrawSetProportional(TutTxtDraw[48], 1);
	TextDrawSetShadow(TutTxtDraw[48], 2);

	TutTxtDraw[49] = TextDrawCreate(166.000000, 344.000000, "- This is a 24/7 store. You can ~r~/buy ~w~several items (i.e. a phone) inside.");
	TextDrawBackgroundColor(TutTxtDraw[49], 255);
	TextDrawFont(TutTxtDraw[49], 1);
	TextDrawLetterSize(TutTxtDraw[49], 0.209999, 1.399999);
	TextDrawColor(TutTxtDraw[49], -1);
	TextDrawSetOutline(TutTxtDraw[49], 0);
	TextDrawSetProportional(TutTxtDraw[49], 1);
	TextDrawSetShadow(TutTxtDraw[49], 2);

	TutTxtDraw[50] = TextDrawCreate(166.000000, 357.000000, "- This is a clothing store. You can ~r~/buyclothes ~w~to get a different skin or");
	TextDrawBackgroundColor(TutTxtDraw[50], 255);
	TextDrawFont(TutTxtDraw[50], 1);
	TextDrawLetterSize(TutTxtDraw[50], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[50], -1);
	TextDrawSetOutline(TutTxtDraw[50], 0);
	TextDrawSetProportional(TutTxtDraw[50], 1);
	TextDrawSetShadow(TutTxtDraw[50], 2);

	TutTxtDraw[51] = TextDrawCreate(172.000000, 371.000000, "~r~/buytoys ~w~to get some accessories for your character.");
	TextDrawBackgroundColor(TutTxtDraw[51], 255);
	TextDrawFont(TutTxtDraw[51], 1);
	TextDrawLetterSize(TutTxtDraw[51], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[51], -1);
	TextDrawSetOutline(TutTxtDraw[51], 0);
	TextDrawSetProportional(TutTxtDraw[51], 1);
	TextDrawSetShadow(TutTxtDraw[51], 2);

	TutTxtDraw[52] = TextDrawCreate(166.000000, 384.000000, "- Remember to check out ~r~/rules ~w~and ~r~/help~w~.");
	TextDrawBackgroundColor(TutTxtDraw[48], 255);
	TextDrawFont(TutTxtDraw[52], 1);
	TextDrawLetterSize(TutTxtDraw[52], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[52], -1);
	TextDrawSetOutline(TutTxtDraw[52], 0);
	TextDrawSetProportional(TutTxtDraw[52], 1);
	TextDrawSetShadow(TutTxtDraw[52], 2);

	TutTxtDraw[53] = TextDrawCreate(166.000000, 398.000000, "- Your weapons will be restricted for the first 2 playing hours.");
	TextDrawBackgroundColor(TutTxtDraw[53], 255);
	TextDrawFont(TutTxtDraw[53], 1);
	TextDrawLetterSize(TutTxtDraw[53], 0.209998, 1.399999);
	TextDrawColor(TutTxtDraw[53], -1);
	TextDrawSetOutline(TutTxtDraw[48], 0);
	TextDrawSetProportional(TutTxtDraw[48], 1);
	TextDrawSetShadow(TutTxtDraw[48], 2);

}


			HideMainMenuGUI(playerid);
			PlayerPlaySound(playerid,SOUND_OFF,2050.1995, 1344.5500, 13.2378); //Music Off

			SetPlayerPos(playerid, 2212.61, -1730.57, -80.0);
			SetPlayerCameraPos(playerid, 2208.67, -1733.71, 27.48);
			SetPlayerCameraLookAt(playerid, 2225.25, -1723.1, 13.56);
			TogglePlayerControllable(playerid, false);
			SetPVarInt(playerid, "IsFrozen", 1);

			for(new t = 0; t < 11; t++)
			{
				TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
			}

			TutorialProgress[playerid] = 1;

			SetTimerEx("TutorialProgression", 14500, 0, "d", playerid);

            
		for(new t = 0; t < 54; t++)
		{
			TextDrawHideForPlayer(giveplayerid, TutTxtDraw[t]);
		}


//------------------------------------------------------------------------------------------------------------//
	// Tutorial text draws                                                                                        //
	//------------------------------------------------------------------------------------------------------------//
	


forward TutorialProgression(playerid);
public TutorialProgression(playerid)
{
	Streamer_Update(playerid);

	if(TutorialProgress[playerid] == 1)
	{
		SetPlayerPos(playerid, 2224.411865, -2649.862060, -30.544359);
		SetPlayerCameraPos(playerid, 2268.519531, -2611.522460, 31.097387);
		SetPlayerCameraLookAt(playerid, 2224.411865, -2649.862060, 13.407735);
		TogglePlayerControllable(playerid,0);

		for(new t = 6; t < 11; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 11; t < 15; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

        TutorialProgress[playerid] = 2;

		SetTimerEx("TutorialProgression", 12000, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 2)
	{
		SetPlayerPos(playerid, 1466.24, -1023.05, -80.0);
		SetPlayerCameraPos(playerid, 1502.28, -1044.47, 31.19);
		SetPlayerCameraLookAt(playerid, 1466.24, -1023.05, 23.83);
		TogglePlayerControllable(playerid,0);

		TextDrawShowForPlayer(playerid, TutTxtDraw[15]);

		TutorialProgress[playerid] = 3;

		SetTimerEx("TutorialProgression", 8500, 0, "d", playerid);

	}
	else if(TutorialProgress[playerid] == 3)
	{
		SetPlayerPos(playerid, 1504.23, -1700.17, -80.0);
		SetPlayerCameraPos(playerid, 1500.21, -1691.75, 38.38);
		SetPlayerCameraLookAt(playerid, 1541.46, -1676.17, 13.55);
		TogglePlayerControllable(playerid,0);

		for(new t = 11; t < 16; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 16; t < 22; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

		TutorialProgress[playerid] = 4;

		SetTimerEx("TutorialProgression", 14000, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 4)
	{
		SetPlayerPos(playerid, 1201.12, -1324, -80.0);
		SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
		SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);
		TogglePlayerControllable(playerid,0);

		for(new t = 16; t < 22; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 22; t < 27; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

		TutorialProgress[playerid] = 5;

		SetTimerEx("TutorialProgression", 12500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 5)
	{
		SetPlayerPos(playerid, 2489.09, -1669.88, -80.0);
		SetPlayerCameraPos(playerid, 2459.82, -1652.68, 26.45);
		SetPlayerCameraLookAt(playerid, 2489.09, -1669.88, 13.34);
		TogglePlayerControllable(playerid,0);

		for(new t = 22; t < 27; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 27; t < 32; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

		TutorialProgress[playerid] = 6;

		SetTimerEx("TutorialProgression", 12500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 6)
	{
		SetPlayerPos(playerid, 2172.315185, -2263.781250, -60.0);
		SetPlayerCameraPos(playerid, 2206.363769, -2262.568359, 24.240808);
		SetPlayerCameraLookAt(playerid, 2172.315185, -2263.781250, 13.335824);
		TogglePlayerControllable(playerid,0);

		for(new t = 27; t < 32; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 32; t < 37; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

		TutorialProgress[playerid] = 7;

		SetTimerEx("TutorialProgression", 13500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 7)
	{
		SetPlayerPos(playerid, 2351.542724, -1169.992797, -22.303030);
		SetPlayerCameraPos(playerid, 2335.889404, -1148.501586, 34.610519);
		SetPlayerCameraLookAt(playerid, 2351.542724, -1169.992797, 28.041967);
		TogglePlayerControllable(playerid,0);

		for(new t = 32; t < 37; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 37; t < 42; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

		TutorialProgress[playerid] = 8;

		SetTimerEx("TutorialProgression", 10500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 8)
	{
		SetPlayerPos(playerid, 2128.194091, -1132.911865, -14.425248);
		SetPlayerCameraPos(playerid, 2116.651123, -1103.233642, 37.885963);
		SetPlayerCameraLookAt(playerid, 2128.194091, -1132.911865, 25.567047);
		TogglePlayerControllable(playerid,0);

		for(new t = 37; t < 42; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		for(new t = 42; t < 46; t++)
		{
			TextDrawShowForPlayer(playerid, TutTxtDraw[t]);
		}

		TutorialProgress[playerid] = 9;

		SetTimerEx("TutorialProgression", 13500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 9)
	{
		SetPlayerPos(playerid, 2523.063232, -1679.484375, -17.811601);
		SetPlayerCameraPos(playerid, 2508.055908, -1676.983154, 18.012311);
		SetPlayerCameraLookAt(playerid, 2523.063232, -1679.484375, 15.496999);
		TogglePlayerControllable(playerid,0);

		TextDrawShowForPlayer(playerid, TutTxtDraw[46]);
		TextDrawShowForPlayer(playerid, TutTxtDraw[47]);

		TutorialProgress[playerid] = 10;

		SetTimerEx("TutorialProgression", 10500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 10)
	{
		SetPlayerPos(playerid, 1315.601806, -898.753417, -4.157680);
		SetPlayerCameraPos(playerid, 1315.780151, -927.116638, 48.019481);
		SetPlayerCameraLookAt(playerid, 1315.601806, -898.753417, 39.578125);
		TogglePlayerControllable(playerid,0);

		for(new t = 42; t < 48; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}
		TextDrawShowForPlayer(playerid, TutTxtDraw[48]);
		TextDrawShowForPlayer(playerid, TutTxtDraw[49]);

		TutorialProgress[playerid] = 11;

		SetTimerEx("TutorialProgression", 10500, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 11)
	{
		SetPlayerPos(playerid, 2243.374023, -1664.780517, -38.467826);
		SetPlayerCameraPos(playerid, 2239.001953, -1645.624145, 22.123142);
		SetPlayerCameraLookAt(playerid, 2243.374023, -1664.780517, 15.476562);
		TogglePlayerControllable(playerid,0);

		TextDrawShowForPlayer(playerid, TutTxtDraw[50]);
		TextDrawShowForPlayer(playerid, TutTxtDraw[51]);

		TutorialProgress[playerid] = 12;

		SetTimerEx("TutorialProgression", 10000, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 12)
	{
		SetPlayerPos(playerid, 1970.506103, -1201.447143, -25.074676);
    	SetPlayerCameraPos(playerid, 2022.083740, -1308.260620, 80.478797);
    	SetPlayerCameraLookAt(playerid, 1970.506103, -1201.447143, 25.596593);
		TogglePlayerControllable(playerid,0);

		TextDrawShowForPlayer(playerid, TutTxtDraw[52]);
		TextDrawShowForPlayer(playerid, TutTxtDraw[53]);

		TutorialProgress[playerid] = 13;

		SetTimerEx("TutorialProgression", 7000, 0, "d", playerid);
	}
	else if(TutorialProgress[playerid] == 13)
	{
	    DeletePVar(playerid, "IsFrozen");
		for(new t = 0; t < 54; t++)
		{
			TextDrawHideForPlayer(playerid, TutTxtDraw[t]);
		}

		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 1773.459350, -1942.273437, 13.569922);
		SetPlayerFacingAngle(playerid, 329.64);
		SetCameraBehindPlayer(playerid);

		InsideTut[playerid] = 0;
		DeletePVar(playerid, "MedicBill");
		SetPlayerColor(playerid,TEAM_HIT_COLOR);
		PlayerInfo[playerid][pTut] = 1;

		PlayerInfo[playerid][pSkin] = 299;
		SetPlayerSkin(playerid, 299);
		
		PlayerInfo[playerid][pFormer] = 0;
		PlayerInfo[playerid][pOS] = 0;
		PlayerInfo[playerid][pVintage] = 0;
		PlayerInfo[playerid][pFamed] = 0;

		ClearChatbox(playerid);
		new string[128];
		format(string, sizeof(string), "Welcome to Dynasty Roleplay, %s.", GetPlayerNameEx(playerid));
		SendClientMessage(playerid, COLOR_NEWS, string);

		format(string, sizeof(string), "~w~Welcome~n~~y~%s", GetPlayerNameEx(playerid));
		GameTextForPlayer(playerid, string, 5000, 1);

		SendClientMessage(playerid, COLOR_YELLOW, "If you have any further questions, please use /newb. You can also /report if you see any rule-breakers.");


		new motdstring[128];
		format(motdstring, sizeof(motdstring), "{FFA500}News:{FFFFFF} %s", GlobalMOTD);
		SendClientMessage(playerid, COLOR_WHITE, motdstring);
		
		format(string, sizeof(string), "> {FFA500} %s {FFFF00} has just spawned on Dynasty Roleplay for the first time!", GetPlayerNameEx(playerid));
	    foreach(Player, i)
	    {
	       if(PlayerInfo[i][pAdmin] >= 1 || PlayerInfo[i][pHelper] >= 1 || PlayerInfo[i][pLevel] >= 1)
	       {
			   SendClientMessageEx(i, COLOR_YELLOW, string);
           }
        }
        
        RefundPlayer(playerid);
        
        WelcomePlayer(playerid);
        
        ShowPlayerDialogEx(playerid, DIALOG_NEWBWELCOME, DIALOG_STYLE_MSGBOX, "{FFFFFF}Welcome to {FFA500}Dynasty Roleplay", "Would you like one of our Senior Helpers to give you a tour of the server?", "Yes", "No");

		TutorialProgress[playerid] = 0;
		TogglePlayerControllable(playerid, true);
	}
}    