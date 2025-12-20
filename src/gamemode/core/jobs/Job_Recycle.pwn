#define RECYCLE_STAGE_NONE     0
#define RECYCLE_STAGE_PICKUP   1
#define RECYCLE_STAGE_DELIVER  2

#include <YSI\y_hooks>

CMD:recycle(playerid, params[])
{
    if(!PlayerHasJob(playerid, JOB_RECYCLE))
        return SendClientMessage(playerid, COLOR_GREY, "You are not a recycler!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1085.278930, -1679.165893, 14.371756) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1103.737426, -1679.169555, 14.371709) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1101.022216, -1665.741699, 14.582563) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1082.896606, -1665.740356, 14.582584) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1103.897094, -1672.897460, 14.470188) &&
        !IsPlayerInRangeOfPoint(playerid, 3.0, 1090.654052, -1672.906982, 14.470069))
        return SendClientMessage(playerid, COLOR_GREY, "You are not at the recycling start point!");

    if(PlayerData[playerid][pRecycleStage] != RECYCLE_STAGE_NONE)
        return SendClientMessage(playerid, COLOR_GREY, "You are already working on a recycle delivery!");

    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
    GameTextForPlayer(playerid, "~w~Getting box...", 5000, 3);

    PlayerData[playerid][pRecycleStage] = RECYCLE_STAGE_PICKUP;

    SetTimerEx("RecycleCheck", 5000, false, "i", playerid);
    return 1;
}

forward RecycleCheck(playerid);
public RecycleCheck(playerid)
{
    TogglePlayerControllable(playerid, 1);
    SendClientMessage(playerid, COLOR_AQUA, "Deliver the box to the marked checkpoint!");
    SetPlayerCheckpoint(playerid, 1133.243896, -1685.004272, 14.279967, 2.0);
    PlayerData[playerid][pRecycleStage] = RECYCLE_STAGE_DELIVER;
    return 1;
}

// ✅ FIXED CALLBACK NAME
hook OnPlayerEnterCheckpoint(playerid)
{
    if(PlayerData[playerid][pRecycleStage] == RECYCLE_STAGE_DELIVER)
    {
        new str[2000], coordsstring[286];
        new amount1 = 5 + random(7);
        new amount2 = 2 + random(5);
        new amount3 = 10 + random(3);
        new amount4 = 5 + random(2);
        new amount5 = 6 + random(8);
        new amount6 = 1000 + random(400);
        
        PlayerData[playerid][pGlassItem]   += amount1;
        PlayerData[playerid][pMetalItem]   += amount2;
        PlayerData[playerid][pRubberItem]  += amount3;
        PlayerData[playerid][pIronItem]    += amount4;
        PlayerData[playerid][pPlasticItem] += amount5;
        GivePlayerCash(playerid, amount6);

        ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);

        ShowPlayerFooter(playerid, "~y~Recycle~n~~w~earned");
        format(coordsstring, sizeof(coordsstring), "_____________ Box Items _______________\n");
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Glass: {33CC33}+%i\n", amount1);
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Metal: {33CC33}+%i\n", amount2);
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Rubber: {33CC33}+%i\n", amount3);
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Iron: {33CC33}+%i\n", amount4);
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Plastic: {33CC33}+%i\n", amount5);
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "{33CCFF}--> {FFFFFF}Money: {33CC33}+%i\n", amount6);
        strcat(str, coordsstring);
        format(coordsstring, sizeof(coordsstring), "______________________________________\n");
        strcat(str, coordsstring);
        ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Recycle Earned", str, "Okay", "");

        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        RemovePlayerAttachedObject(playerid, 9);

        new query[256];
        format(query, sizeof(query),
            "UPDATE "#TABLE_USERS" SET glassitem = %i, metalitem = %i, rubberitem = %i, ironitem = %i, plasticitem = %i WHERE uid = %d",
            PlayerData[playerid][pGlassItem],
            PlayerData[playerid][pMetalItem],
            PlayerData[playerid][pRubberItem],
            PlayerData[playerid][pIronItem],
            PlayerData[playerid][pPlasticItem],
            PlayerData[playerid][pID]
        );

        DisablePlayerCheckpoint(playerid);
        PlayerData[playerid][pRecycleStage] = RECYCLE_STAGE_NONE;
    }
    return 1;
}