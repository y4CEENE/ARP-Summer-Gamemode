/// @file      BlindFold.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022



static Text:Blind;

hook OnGameModeInit()
{
    //------------------------------------------//
    Blind = TextDrawCreate(641.199951, 1.500000, "usebox");
    TextDrawLetterSize(Blind, 0.000000, 49.378147);
    TextDrawTextSize(Blind, -2.000000, 0.000000);
    TextDrawAlignment(Blind, 3);
    TextDrawColor(Blind, -1);
    TextDrawUseBox(Blind, true);
    TextDrawBoxColor(Blind, 255);
    TextDrawSetShadow(Blind, 0);
    TextDrawSetOutline(Blind, 0);
    TextDrawBackgroundColor(Blind, 255);
    TextDrawFont(Blind, 1);
}

hook OnPlayerSpawn(playerid)
{
    TextDrawHideForPlayer(playerid, Blind);
}


CMD:blindfold(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /blindfold [playerid]");
    }
    if (PlayerData[playerid][pBlindfold] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have any blindfolds left.");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't blindfold yourself.");
    }
    if (!PlayerData[targetid][pTied] && !PlayerData[targetid][pCuffed] )
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is not tied or cuffed.");
    }
    if (PlayerData[targetid][pBlinded])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is already blindfolded.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to blindfold anyone. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    PlayerData[playerid][pBlindfold]--;

    DBQuery("UPDATE "#TABLE_USERS" SET blindfold = %i WHERE uid = %i", PlayerData[playerid][pBlindfold], PlayerData[playerid][pID]);


    TextDrawShowForPlayer(targetid, Blind);
    GameTextForPlayer(targetid, "~r~Blindfolded", 3000, 3);
    ShowActionBubble(playerid, "* %s blindfolds %s with a piece of rag.", GetRPName(playerid), GetRPName(targetid));

    PlayerData[targetid][pBlinded] = 1;
    return 1;
}

CMD:removeblindfold(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeblindfold [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    if (targetid == playerid && PlayerData[playerid][pTied])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't remove your own blindfold while tied.");
    }
    if (!PlayerData[targetid][pBlinded])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player is not blindfolded.");
    }
    if (PlayerData[playerid][pHurt])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You're too hurt to remove anyone's blindfold. Please wait %i seconds before trying again.", PlayerData[playerid][pHurt]);
    }

    TextDrawHideForPlayer(targetid, Blind);
    ShowActionBubble(playerid, "* %s removes the blindfold from %s.", GetRPName(playerid), GetRPName(targetid));

    PlayerData[targetid][pBlinded] = 0;
    return 1;
}
