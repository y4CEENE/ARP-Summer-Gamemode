/// @file      PlayerIDCard.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-02-16 23:22:58 +0100
/// @copyright Copyright (c) 2022


#include <YSI\y_hooks>

static PlayerText:ShowID[MAX_PLAYERS][15];
static PlayerMarko[MAX_PLAYERS];
static PlayerMarkoTimer[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    ShowID[playerid][0] = CreatePlayerTextDraw(playerid, 539.000000, 131.000000, "_");
    PlayerTextDrawFont(playerid, ShowID[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][0], 0.600000, 13.000003);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][0], 340.500000, 187.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][0], 2);
    PlayerTextDrawColor(playerid, ShowID[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][0], 0xc6002dff);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][0], 0xc6002dff);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][0], 0);

    ShowID[playerid][1] = CreatePlayerTextDraw(playerid, 560.000000, 166.000000, "_");
    PlayerTextDrawFont(playerid, ShowID[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][1], 0.600000, 1.650002);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][1], 298.500000, 145.500000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][1], 2);
    PlayerTextDrawColor(playerid, ShowID[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][1], 0);

    ShowID[playerid][2] = CreatePlayerTextDraw(playerid, 494.000000, 168.000000, "Mike_Zodiac");
    PlayerTextDrawFont(playerid, ShowID[playerid][2], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][2], 0.250000, 1.000000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][2], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][2], 1);
    PlayerTextDrawColor(playerid, ShowID[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][2], 0);

    ShowID[playerid][3] = CreatePlayerTextDraw(playerid, 500.000000, 185.000000, "AGE");
    PlayerTextDrawFont(playerid, ShowID[playerid][3], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][3], 0.125000, 0.850000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][3], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][3], 1);
    PlayerTextDrawColor(playerid, ShowID[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][3], 0);

    ShowID[playerid][4] = CreatePlayerTextDraw(playerid, 559.000000, 185.000000, "GENDER");
    PlayerTextDrawFont(playerid, ShowID[playerid][4], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][4], 0.125000, 0.850000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][4], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][4], 3);
    PlayerTextDrawColor(playerid, ShowID[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][4], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][4], 0);

    ShowID[playerid][5] = CreatePlayerTextDraw(playerid, 598.000000, 129.000000, "GOVERNMENT OF SAN ANDREAS");
    PlayerTextDrawFont(playerid, ShowID[playerid][5], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][5], 0.133331, 0.850000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][5], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][5], 3);
    PlayerTextDrawColor(playerid, ShowID[playerid][5], 1433087999);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][5], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][5], 0);

    ShowID[playerid][6] = CreatePlayerTextDraw(playerid, 594.000000, 137.000000, "IDENTIFICATION CARD");
    PlayerTextDrawFont(playerid, ShowID[playerid][6], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][6], 0.166666, 1.299998);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][6], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][6], 3);
    PlayerTextDrawColor(playerid, ShowID[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][6], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][6], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][6], 0);

    ShowID[playerid][7] = CreatePlayerTextDraw(playerid, 560.000000, 226.000000, "_");
    PlayerTextDrawFont(playerid, ShowID[playerid][7], 1);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][7], 0.600000, -0.349996);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][7], 298.500000, 145.500000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][7], 2);
    PlayerTextDrawColor(playerid, ShowID[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][7], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][7], -1);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][7], 0);

    ShowID[playerid][8] = CreatePlayerTextDraw(playerid, 534.000000, 225.000000, "EXPIRES IN FEB 2026");
    PlayerTextDrawFont(playerid, ShowID[playerid][8], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][8], 0.125000, 0.850000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][8], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][8], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][8], 3);
    PlayerTextDrawColor(playerid, ShowID[playerid][8], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][8], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][8], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][8], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][8], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][8], 0);

    ShowID[playerid][9] = CreatePlayerTextDraw(playerid, 509.000000, 191.000000, "30");
    PlayerTextDrawFont(playerid, ShowID[playerid][9], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][9], 0.125000, 0.850000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][9], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][9], 3);
    PlayerTextDrawColor(playerid, ShowID[playerid][9], 0xa01d2aff);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][9], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][9], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][9], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][9], 0);

    ShowID[playerid][10] = CreatePlayerTextDraw(playerid, 543.000000, 191.000000, "MALE");
    PlayerTextDrawFont(playerid, ShowID[playerid][10], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][10], 0.125000, 0.850000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][10], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][10], 1);
    PlayerTextDrawColor(playerid, ShowID[playerid][10], 0xa01d2aff);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][10], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][10], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][10], 0);

    ShowID[playerid][11] = CreatePlayerTextDraw(playerid, 494.000000, 210.000000, "ID:");
    PlayerTextDrawFont(playerid, ShowID[playerid][11], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][11], 0.112498, 1.249997);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][11], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][11], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][11], 1);
    PlayerTextDrawColor(playerid, ShowID[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][11], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][11], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][11], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][11], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][11], 0);

    ShowID[playerid][12] = CreatePlayerTextDraw(playerid, 464.000000, 131.000000, "_");
    PlayerTextDrawFont(playerid, ShowID[playerid][12], 1);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][12], 0.600000, 10.300003);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][12], 298.500000, 37.500000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][12], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][12], 2);
    PlayerTextDrawColor(playerid, ShowID[playerid][12], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][12], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][12], -121);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][12], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][12], 0);

    ShowID[playerid][13] = CreatePlayerTextDraw(playerid, 408.000000, 91.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, ShowID[playerid][13], 5);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][13], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][13], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][13], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][13], 1);
    PlayerTextDrawColor(playerid, ShowID[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][13], 0);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][13], 0);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][13], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][13], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][13], 0);
    PlayerTextDrawSetPreviewModel(playerid, ShowID[playerid][13], 19163);
    PlayerTextDrawSetPreviewRot(playerid, ShowID[playerid][13], -10.000000, 0.000000, 1.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, ShowID[playerid][13], 1, 1);


    ShowID[playerid][14] = CreatePlayerTextDraw(playerid, 494.000000, 200.000000, "Licenses:");
    PlayerTextDrawFont(playerid, ShowID[playerid][14], 2);
    PlayerTextDrawLetterSize(playerid, ShowID[playerid][14], 0.112498, 1.249997);
    PlayerTextDrawTextSize(playerid, ShowID[playerid][14], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, ShowID[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, ShowID[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, ShowID[playerid][14], 1);
    PlayerTextDrawColor(playerid, ShowID[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, ShowID[playerid][14], 255);
    PlayerTextDrawBoxColor(playerid, ShowID[playerid][14], 50);
    PlayerTextDrawUseBox(playerid, ShowID[playerid][14], 0);
    PlayerTextDrawSetProportional(playerid, ShowID[playerid][14], 1);
    PlayerTextDrawSetSelectable(playerid, ShowID[playerid][14], 0);
}

CMD:showid(playerid, params[])
{
    new targetid;

    if (sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /showid [playerid]");
    }
    if (!IsPlayerConnected(targetid) || !IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected or out of range.");
    }
    ShowCitizenID(targetid, playerid);
    ShowActionBubble(playerid, "* %s shows their ID card to %s.", GetRPName(playerid), GetRPName(targetid));
    return 1;
}

stock Marko(playerid, time = 10000)
{
    if (PlayerMarko[playerid])
    {
        for (new i = 0; i < 14; i ++)
        {
            PlayerTextDrawHide(playerid, ShowID[playerid][i]);
        }
        KillTimer(PlayerMarkoTimer[playerid]);
    }
    for (new i = 0; i < 15; i ++)
    {
        PlayerTextDrawShow(playerid, ShowID[playerid][i]);
    }

    PlayerMarko[playerid] = true;
    PlayerMarkoTimer[playerid] = SetTimerEx("HidetheMarko", time, false, "d", playerid);
}

publish HidetheMarko(playerid)
{
    if (!PlayerMarko[playerid])
        return 0;

    PlayerMarko[playerid] = false;
    for (new i = 0; i < 15; i ++)
    {
        PlayerTextDrawHide(playerid, ShowID[playerid][i]);
    }
    return 1;
}

stock ShowCitizenID(playerid, citizenid)
{

    new value[36];
    // Name
    PlayerTextDrawSetString(playerid, ShowID[playerid][2], GetPlayerNameEx(citizenid));

    // Age
    format(value, sizeof(value), "%i", PlayerData[citizenid][pAge]);
    PlayerTextDrawSetString(playerid, ShowID[playerid][9], value);

    // Gender
    PlayerTextDrawSetString(playerid, ShowID[playerid][10], GetPlayerGenderStr(citizenid));

    // Licenses
    format(value, sizeof(value), "Licenses:_%s", GetPlayerLicensesStr(citizenid));
    PlayerTextDrawSetString(playerid, ShowID[playerid][14], value);

    // Id
    format(value, sizeof(value), "ID:_%s", GetPlayerSerialNumber(citizenid));
    PlayerTextDrawSetString(playerid, ShowID[playerid][11], value);

    // Skin
    PlayerTextDrawSetPreviewModel(playerid, ShowID[playerid][13], PlayerData[citizenid][pSkin]);

    Marko(playerid, 10000);
}

stock GetPlayerLicensesStr(playerid)
{

    new license[32];
    if (PlayerHasLicense(playerid, PlayerLicense_Gun))
    {
        format(license, sizeof(license), "Gun");
    }
    if (PlayerHasLicense(playerid, PlayerLicense_Car))
    {
        if (isnull(license))
        {
            format(license, sizeof(license), "Car");
        }
        else
        {
            format(license, sizeof(license), "%s,Car", license);
        }
    }
    if (isnull(license))
    {
        format(license, sizeof(license), "None");
    }
    return license;
}
