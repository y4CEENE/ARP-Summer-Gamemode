/// @file      Notification.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-06-05 18:25:10 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

enum NotificationType {
    NotificationType_Info,
    NotificationType_Warn,
    NotificationType_Success,
    NotificationType_Danger
};

static PlayerText:NotificationBackground[MAX_PLAYERS];
static PlayerText:NotificationText[MAX_PLAYERS];
static PlayerText:NotificationIcon[MAX_PLAYERS];
static NotificationTimer[MAX_PLAYERS];


hook OnPlayerConnect(playerid)
{
    NotificationTimer[playerid] = -1;
	NotificationBackground[playerid] = CreatePlayerTextDraw(playerid, 231.000000, 24.000000, "_");
	PlayerTextDrawFont(playerid, NotificationBackground[playerid], 1);
	PlayerTextDrawLetterSize(playerid, NotificationBackground[playerid], 0.600000, 1.399999);
	PlayerTextDrawTextSize(playerid, NotificationBackground[playerid], 407.500000, 13.500000);
	PlayerTextDrawSetOutline(playerid, NotificationBackground[playerid], 1);
	PlayerTextDrawSetShadow(playerid, NotificationBackground[playerid], 0);
	PlayerTextDrawAlignment(playerid, NotificationBackground[playerid], 1);
	PlayerTextDrawColor(playerid, NotificationBackground[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, NotificationBackground[playerid], 255);
	PlayerTextDrawBoxColor(playerid, NotificationBackground[playerid], 0x229AABFF);
	PlayerTextDrawUseBox(playerid, NotificationBackground[playerid], 1);
	PlayerTextDrawSetProportional(playerid, NotificationBackground[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, NotificationBackground[playerid], 0);

	NotificationText[playerid] = CreatePlayerTextDraw(playerid, 319.000000, 25.000000, "Green zone");
	PlayerTextDrawFont(playerid, NotificationText[playerid], 2);
	PlayerTextDrawLetterSize(playerid, NotificationText[playerid], 0.158344, 1.049999);
	PlayerTextDrawTextSize(playerid, NotificationText[playerid], 406.500000, 173.000000);
	PlayerTextDrawSetOutline(playerid, NotificationText[playerid], 0);
	PlayerTextDrawSetShadow(playerid, NotificationText[playerid], 0);
	PlayerTextDrawAlignment(playerid, NotificationText[playerid], 2);
	PlayerTextDrawColor(playerid, NotificationText[playerid], 0x0D9AE9FF);
	PlayerTextDrawBackgroundColor(playerid, NotificationText[playerid], 255);
	PlayerTextDrawBoxColor(playerid, NotificationText[playerid], 0x09293EFF);
	PlayerTextDrawUseBox(playerid, NotificationText[playerid], 1);
	PlayerTextDrawSetProportional(playerid, NotificationText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, NotificationText[playerid], 0);

	NotificationIcon[playerid] = CreatePlayerTextDraw(playerid, 232.000000, 24.000000, "HUD:arrow");
	PlayerTextDrawFont(playerid, NotificationIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, NotificationIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, NotificationIcon[playerid], 11.000000, 11.000000);
	PlayerTextDrawSetOutline(playerid, NotificationIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, NotificationIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, NotificationIcon[playerid], 1);
	PlayerTextDrawColor(playerid, NotificationIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, NotificationIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, NotificationIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, NotificationIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, NotificationIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, NotificationIcon[playerid], 0);

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (NotificationTimer[playerid] >= 0)
    {
        KillTimer(NotificationTimer[playerid]);
        NotificationTimer[playerid] = -1;
    }
	PlayerTextDrawDestroy(playerid, NotificationBackground[playerid]);
	PlayerTextDrawDestroy(playerid, NotificationText[playerid]);
	PlayerTextDrawDestroy(playerid, NotificationIcon[playerid]);
	return 1;
}

stock ShowNotification(playerid, const text[], NotificationType:type, const icon[] = "_")
{
    PlayerTextDrawSetString(playerid, NotificationText[playerid], text);
    PlayerTextDrawSetString(playerid, NotificationIcon[playerid], icon);

    switch(type)
    {
        case NotificationType_Info: // blue
        {
	        PlayerTextDrawBoxColor(playerid, NotificationBackground[playerid], 0x229AABFF);
        	PlayerTextDrawColor(playerid, NotificationText[playerid], 0x0D9AE9FF);
	        PlayerTextDrawBoxColor(playerid, NotificationText[playerid], 0x09293EFF);
        }
        case NotificationType_Warn: // orange
        {
	        PlayerTextDrawBoxColor(playerid, NotificationBackground[playerid], 0xEFAC20FF);
        	PlayerTextDrawColor(playerid, NotificationText[playerid], 0xD2691EFF);
	        PlayerTextDrawBoxColor(playerid, NotificationText[playerid], 0xFFC752FF);
        }
        case NotificationType_Success: // green
        {
	        PlayerTextDrawBoxColor(playerid, NotificationBackground[playerid], 0x2EAA65FF);
        	PlayerTextDrawColor(playerid, NotificationText[playerid], 0x2EAA65FF);
	        PlayerTextDrawBoxColor(playerid, NotificationText[playerid], 0x79FFB6FF);
        }
        case NotificationType_Danger: // red
        {
	        PlayerTextDrawBoxColor(playerid, NotificationBackground[playerid], 0xC80114FF);
        	PlayerTextDrawColor(playerid, NotificationText[playerid], 0xFFFFFFFF);
	        PlayerTextDrawBoxColor(playerid, NotificationText[playerid], 0xE42328FF);
        }
    }
    if (NotificationTimer[playerid] >= 0)
    {
        KillTimer(NotificationTimer[playerid]);
    }
    NotificationTimer[playerid] = SetTimerEx("HideNotification", 5000, false, "i", playerid);

    PlayerTextDrawShow(playerid, NotificationBackground[playerid]);
    PlayerTextDrawShow(playerid, NotificationText[playerid]);
    PlayerTextDrawShow(playerid, NotificationIcon[playerid]);
	return 0;
}

forward HideNotification(playerid);
public HideNotification(playerid)
{
    NotificationTimer[playerid] = -1;
    PlayerTextDrawHide(playerid, NotificationBackground[playerid]);
    PlayerTextDrawHide(playerid, NotificationText[playerid]);
    PlayerTextDrawHide(playerid, NotificationIcon[playerid]);
    return 1;
}
