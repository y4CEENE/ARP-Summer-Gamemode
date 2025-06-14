#include <YSI\y_hooks>

new Text:PublicTD[2];

hook OnGameModeInit()
{
    
    PublicTD[0] = TextDrawCreate(328.000000, 374.000000, "Powered_by");
    TextDrawFont(PublicTD[0], 0);
    TextDrawLetterSize(PublicTD[0], 0.379166, 1.850000);
    TextDrawTextSize(PublicTD[0], 400.000000, 17.000000);
    TextDrawSetOutline(PublicTD[0], 1);
    TextDrawSetShadow(PublicTD[0], 0);
    TextDrawAlignment(PublicTD[0], 2);
    TextDrawColor(PublicTD[0], -1);
    TextDrawBackgroundColor(PublicTD[0], 100);
    TextDrawBoxColor(PublicTD[0], 50);
    TextDrawUseBox(PublicTD[0], 0);
    TextDrawSetProportional(PublicTD[0], 1);
    TextDrawSetSelectable(PublicTD[0], 0);

    PublicTD[1] = TextDrawCreate(342.000000, 388.000000, "Arabica");
    TextDrawFont(PublicTD[1], 3);
    TextDrawLetterSize(PublicTD[1], 0.366665, 1.750000);
    TextDrawTextSize(PublicTD[1], 400.000000, 17.000000);
    TextDrawSetOutline(PublicTD[1], 1);
    TextDrawSetShadow(PublicTD[1], 0);
    TextDrawAlignment(PublicTD[1], 2);
    TextDrawColor(PublicTD[1], 0xDABB3EAA);
    TextDrawBackgroundColor(PublicTD[1], 101);
    TextDrawBoxColor(PublicTD[1], 50);
    TextDrawUseBox(PublicTD[1], 0);
    TextDrawSetProportional(PublicTD[1], 1);
    TextDrawSetSelectable(PublicTD[1], 0);

    return 1;    
}


hook OnPlayerInit(playerid)
{
    TextDrawShowForPlayer(playerid, PublicTD[0]);
	TextDrawShowForPlayer(playerid, PublicTD[1]);
    return 1;
}