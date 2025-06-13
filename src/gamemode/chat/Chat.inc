/// @file      Chat.inc
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

#include "chat/AdminChat.pwn"
#include "chat/AllianceChat.pwn"
#include "chat/ChatWithAdmin.chat.pwn"
#include "chat/CrewChat.pwn"
#include "chat/DepartmentChat.pwn"
#include "chat/DivisionChat.pwn"
#include "chat/FactionChat.pwn"
#include "chat/GangChat.pwn"
#include "chat/GeneralChat.pwn"
#include "chat/GovAnnouncementChat.pwn"
#include "chat/HelperChat.pwn"
#include "chat/Mute.pwn"
#include "chat/NewbieChat.pwn"
#include "chat/OocChat.pwn"
#include "chat/PrivateRadioChat.pwn"
#include "chat/RadioChat.pwn"
#include "chat/ReportChat.pwn"


IsPlayerChatActive(playerid)
{
    foreach(new i : Player)
    {
        if (chattingWith[playerid][i])
        {
            return 1;
        }
    }

    return 0;
}

CMD:f(playerid, params[])
{
    if (PlayerData[playerid][pFaction] != -1)
        callcmd::fc(playerid, params);
    else callcmd::gc(playerid, params);
}

SendAdminMessage(color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && IsAdmin(i))
            {
                SendClientMessage(i, color, text);
            }
        }

    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && IsAdmin(i))
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendHelperMessage(color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && PlayerData[i][pHelper] > 0)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && PlayerData[i][pHelper] > 0)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendTurfMessage(turfid, color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 3)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && GetNearbyTurf(i) == turfid && PlayerData[i][pToggleTurfs] == 0)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 3)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && GetNearbyTurf(i) == turfid && PlayerData[i][pToggleTurfs] == 0)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendStaffMessage(color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && (IsAdmin(i) || PlayerData[i][pHelper] > 0))
            {
                SendClientMessage(i, color, text);
            }
        }

    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && (IsAdmin(i) || PlayerData[i][pHelper] > 0))
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendClientMessageToAllEx(color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged])
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged])
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendProximityFadeMessage(playerid, Float:radius, const text[], color1, color2, color3, color4, color5)
{
    foreach(new i : Player)
    {
        if (IsPlayerNearPlayer(i, playerid, radius / 16))
        {
            SendClientMessage(i, color1, text);
        }
        else if (IsPlayerNearPlayer(i, playerid, radius / 8))
        {
            SendClientMessage(i, color2, text);
        }
        else if (IsPlayerNearPlayer(i, playerid, radius / 4))
        {
            SendClientMessage(i, color3, text);
        }
        else if (IsPlayerNearPlayer(i, playerid, radius / 2))
        {
            SendClientMessage(i, color4, text);
        }
        else if (IsPlayerNearPlayer(i, playerid, radius))
        {
            SendClientMessage(i, color5, text);
        }
        else if (PlayerData[i][pListen])
        {
            SendClientMessage(i, color5, text);
        }
    }
    return 1;
}
SendProximityMessage(playerid, Float:radius, color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 4)
    {
        foreach(new i : Player)
        {
            if (IsPlayerNearPlayer(i, playerid, radius) || PlayerData[i][pListen])
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 4)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (IsPlayerNearPlayer(i, playerid, radius) || PlayerData[i][pListen])
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendFactionMessage(factionid, color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 3)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && PlayerData[i][pFaction] == factionid)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 3)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && PlayerData[i][pFaction] == factionid)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendLawEnforcementMessage(color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && IsLawEnforcement(i))
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && IsLawEnforcement(i))
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendGangMessage(gangid, color, const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[192];

    if ((args = numargs()) <= 3)
    {
        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && PlayerData[i][pGang] == gangid)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 3)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        foreach(new i : Player)
        {
            if (PlayerData[i][pLogged] && PlayerData[i][pGang] == gangid)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendFMMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) &&  PlayerData[i][pLogged])
        {
            if (PlayerData[i][pFactionMod] >= 1 || PlayerData[i][pGameAffairs] || IsAdmin(i, ADMIN_LVL_7))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}

SendGMMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if (PlayerData[i][pGangMod] >= 1 || PlayerData[i][pGameAffairs] || IsAdmin(i, ADMIN_LVL_7))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}

SendHMMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if (PlayerData[i][pHelperManager] >= 1 || PlayerData[i][pGameAffairs] || IsAdmin(i, ADMIN_LVL_7))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}

SendAPMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if (PlayerData[i][pAdminPersonnel] >= 1 || IsAdmin(i, ADMIN_LVL_10))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}

SendWDMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if (PlayerData[i][pWebDev] >= 1 || IsAdmin(i, ADMIN_LVL_10))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}

SendDGAMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if (PlayerData[i][pGameAffairs] >= 1 || IsAdmin(i, ADMIN_LVL_10))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}

ABroadCast(hColor, szMessage[], iLevel)
{
    foreach(new i: Player)
    {
        if (IsAdmin(i, iLevel))
        {
            SendClientMessageEx(i, hColor, szMessage);
        }
    }
    return 1;
}

CMD:b(playerid, params[])
{
    new string[144];

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /b [local OOC]");
    }

    format(string, sizeof(string), "(( [%d] %s: %s ))", playerid, GetRPName(playerid), params);
    SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

    return 1;
}

CMD:s(playerid, params[])
{
    return callcmd::shout(playerid, params);
}

CMD:shout(playerid, params[])
{
    new
        string[144];

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /(s)hout [text]");
    }

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "(Shouts) %s!", params);
    format(string, sizeof(string), "%s shouts: %s!", GetRPName(playerid), params);
    SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

    foreach(new i : House)
    {
        if (IsPlayerInRangeOfPoint(playerid, 10.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]))
        {
            foreach(new p : Player)
            {
                if (IsPlayerInRangeOfPoint(p, 30.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]))
                {
                    if (GetPlayerVirtualWorld(p) == HouseInfo[i][hWorld])
                    {
                        format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                        SendClientMessage(p, COLOR_GREY1, string);
                    }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 20.0, HouseInfo[i][hIntX], HouseInfo[i][hIntY], HouseInfo[i][hIntZ]))
        {
            if (GetPlayerVirtualWorld(playerid) == HouseInfo[i][hWorld])
            {
                foreach(new p : Player)
                {
                    if (IsPlayerInRangeOfPoint(p, 15.0, HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]))
                    {
                        if (GetPlayerVirtualWorld(p) == 0)
                        {
                            format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                            SendClientMessage(p, COLOR_GREY1, string);
                        }
                    }
                }
            }
        }
    }
    foreach(new i : Business)
    {
        if (IsPlayerInRangeOfPoint(playerid, 10.0, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]))
        {
            foreach(new p : Player)
            {
                if (IsPlayerInRangeOfPoint(p, 30.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]))
                {
                    if (GetPlayerVirtualWorld(p) == BusinessInfo[i][bWorld])
                    {
                        format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                        SendClientMessage(p, COLOR_GREY1, string);
                    }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 20.0, BusinessInfo[i][bIntX], BusinessInfo[i][bIntY], BusinessInfo[i][bIntZ]))
        {
            if (GetPlayerVirtualWorld(playerid) == BusinessInfo[i][bWorld])
            {
                foreach(new p : Player)
                {
                    if (IsPlayerInRangeOfPoint(p, 15.0, BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]))
                    {
                        if (GetPlayerVirtualWorld(p) == 0)
                        {
                            format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                            SendClientMessage(p, COLOR_GREY1, string);
                        }
                    }
                }
            }
        }
    }
    foreach(new i : Entrance)
    {
        if (IsPlayerInRangeOfPoint(playerid, 10.0, EntranceInfo[i][ePosX], EntranceInfo[i][ePosY], EntranceInfo[i][ePosZ]))
        {
            foreach(new p : Player)
            {
                if (IsPlayerInRangeOfPoint(p, 30.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]))
                {
                    if (GetPlayerVirtualWorld(p) == EntranceInfo[i][eWorld])
                    {
                        format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                        SendClientMessage(p, COLOR_GREY1, string);
                    }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 20.0, EntranceInfo[i][eIntX], EntranceInfo[i][eIntY], EntranceInfo[i][eIntZ]))
        {
            if (GetPlayerVirtualWorld(playerid) == EntranceInfo[i][eWorld])
            {
                foreach(new p : Player)
                {
                    if (IsPlayerInRangeOfPoint(p, 15.0, EntranceInfo[i][ePosX], EntranceInfo[i][ePosY], EntranceInfo[i][ePosZ]))
                    {
                        if (GetPlayerVirtualWorld(p) == 0)
                        {
                            format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                            SendClientMessage(p, COLOR_GREY1, string);
                        }
                    }
                }
            }
        }
    }

    foreach(new i : Garage)
    {
        if (IsPlayerInRangeOfPoint(playerid, 10.0, GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]))
        {
            foreach(new p : Player)
            {
                if (IsPlayerInRangeOfPoint(playerid, 30.0, garageInteriors[GarageInfo[i][gType]][intVX], garageInteriors[GarageInfo[i][gType]][intVY], garageInteriors[GarageInfo[i][gType]][intVZ]))
                {
                    if (GetPlayerVirtualWorld(p) == GarageInfo[i][gWorld])
                    {
                        format(string, sizeof(string), "[OUTSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                        SendClientMessage(p, COLOR_GREY1, string);
                    }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 20.0, garageInteriors[GarageInfo[i][gType]][intVX], garageInteriors[GarageInfo[i][gType]][intVY], garageInteriors[GarageInfo[i][gType]][intVZ]))
        {
            if (GetPlayerVirtualWorld(playerid) == GarageInfo[i][gWorld])
            {
                foreach(new p : Player)
                {
                    if (IsPlayerInRangeOfPoint(p, 15.0, GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]))
                    {
                        if (GetPlayerVirtualWorld(p) == 0)
                        {
                            format(string, sizeof(string), "[INSIDE]: %s shouts: %s!", GetRPName(playerid), params);
                            SendClientMessage(p, COLOR_GREY1, string);
                        }
                    }
                }
            }
        }
    }

    return 1;
}

CMD:my(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /my [action]");
    }

    if (strlen(params) > MAX_SPLIT_LENGTH)
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s's %.*s...", GetRPName(playerid), MAX_SPLIT_LENGTH, params);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* ...%s", params[MAX_SPLIT_LENGTH]);
    }
    else
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s's %s", GetRPName(playerid), params);
    }

    return 1;
}

CMD:me(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /me [action]");
    }


    if (strlen(params) > MAX_SPLIT_LENGTH)
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.*s...", GetRPName(playerid), MAX_SPLIT_LENGTH, params);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* ...%s", params[MAX_SPLIT_LENGTH]);
    }
    else
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", GetRPName(playerid), params);
    }

    return 1;
}

CMD:ame(playerid, params[])
{
    new message[100], string[128];
    if (sscanf(params, "s[100]", message))
    {
        SendClientMessage(playerid, COLOR_GREY2, "Usage: /ame [action/off]");
        SendClientMessage(playerid, COLOR_GREY2, "HINT: You can use this command to show an action above your head.");
        SendClientMessage(playerid, COLOR_GREY2, "HINT: This is useful for areas with a lot of text or congestion and avoiding spam.");
        SendClientMessage(playerid, COLOR_GREY2, "HINT: You will not be able to see the bubble, but a message is sent with the text other players see above your head.");
        SendClientMessage(playerid, COLOR_GLOBAL, "NOTE: Don't abuse it or get a punishment.");
        return 1;
    }
    if (strcmp(message, "off", true) == 0)
    {
        SendClientMessage(playerid, COLOR_GREY2, "  You have removed the description label.");
        HidePlayerStatus(playerid);
        return 1;
    }

    if (strlen(message) > 64)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "  The action is too long, please reduce the length.");
    }
    else if (strlen(message) < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "  The action is too short, please increase the length.");
    }

    format(string, sizeof(string), "* %s %s", GetRPName(playerid), message);
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);
    ShowPlayerStatus(playerid, string);
    return 1;
}

publish ShowPlayerStatus(playerid, const text[])
{
    KillTimer(PlayerData[playerid][aMeTimer]);
    if (PlayerData[playerid][aMeStatus])
    {
        UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, text);
    }
    else
    {
        PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(text, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
    }
    PlayerData[playerid][aMeStatus] = true;
    PlayerData[playerid][aMeTimer]  = SetTimerEx("HidePlayerStatus", 10000, false, "i", playerid);
    return 1;
}

publish HidePlayerStatus(playerid)
{
    if (IsPlayerConnected(playerid) && PlayerData[playerid][aMeStatus])
    {
        DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
        PlayerData[playerid][aMeID] = INVALID_3DTEXT_ID;
        PlayerData[playerid][aMeStatus] =0;
        KillTimer(PlayerData[playerid][aMeTimer]);
    }
    return 1;
}

CMD:ado(playerid, params[])
{
    new message[100], string[180];
    if (sscanf(params, "s[100]", message))
    {
        SendClientMessage(playerid, COLOR_GREY2, "Usage: /ado [action/off]");
        SendClientMessage(playerid, COLOR_GREY2, "HINT: You can use this command to show an action above your head.");
        SendClientMessage(playerid, COLOR_GREY2, "HINT: This is useful for areas with a lot of text or congestion and avoiding spam.");
        SendClientMessage(playerid, COLOR_GREY2, "HINT: You will not be able to see the bubble, but a message is sent with the text other players see above your head.");
        SendClientMessage(playerid, COLOR_GLOBAL, "NOTE: Don't abuse it or get a punishment.");
        return 1;
    }
    if (strcmp(message, "off", true) == 0)
    {
        SendClientMessage(playerid, COLOR_GREY2, "  You have removed the description label.");
        HidePlayerStatus(playerid);
        return 1;
    }
    else if (strlen(message) > 64)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "  The action is too long, please reduce the length.");
    }
    else if (strlen(message) < 3)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "  The action is too short, please increase the length.");
    }

    format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, string);
    ShowPlayerStatus(playerid, string);
    return 1;
}

CMD:do(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /do [describe]");
    }

    if (strlen(params) > MAX_SPLIT_LENGTH)
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "*%.*s...", MAX_SPLIT_LENGTH, params);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* ...%s (( %s ))", params[MAX_SPLIT_LENGTH], GetRPName(playerid));
    }
    else
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, GetRPName(playerid));
    }

    SetPlayerBubbleText(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, GetRPName(playerid));
    return 1;
}
CMD:l(playerid, params[])
{
    return callcmd::low(playerid, params);
}

CMD:low(playerid, params[])
{
    new
        string[144];

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "Usage: /(l)ow [text]");
    }

//  SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "(Quietly) %s", params);
    format(string, sizeof(string), "%s quietly: %s", GetRPName(playerid), params);
    SendProximityFadeMessage(playerid, 5.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);

    return 1;
}


CMD:w(playerid, params[])
{
    return callcmd::whisper(playerid, params);
}

CMD:whisper(playerid, params[])
{
    new targetid, text[128];

    if (sscanf(params, "us[128]", targetid, text))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(w)hisper [playerid] [text]");
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!IsPlayerNearPlayer(playerid, targetid, 5.0) && (!IsAdminOnDuty(playerid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be near that player to whisper them.");
    }
    if (targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't whisper to yourself.");
    }
    if (PlayerData[targetid][pToggleWhisper])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming whispers.");
    }

    SendClientMessageEx(targetid, COLOR_YELLOW, "* Whisper from %s: %s *", GetRPName(playerid), text);
    SendClientMessageEx(playerid, COLOR_YELLOW, "* Whisper to %s: %s *", GetRPName(targetid), text);

    if (PlayerData[playerid][pBugged])
    {
        foreach(new i : Player)
        {
            if (GetPlayerFaction(i) == FACTION_FEDERAL)
            {
                SendClientMessageEx(i, 0x9ACD3200, "(bug) %s whispers: %s", GetRPName(playerid), text);
            }
        }
    }

    if (PlayerData[targetid][pWhisperFrom] == INVALID_PLAYER_ID)
    {
        SendClientMessage(targetid, COLOR_WHITE, "* You can use '/rw [message]' to reply to this whisper.");
    }

    PlayerData[targetid][pWhisperFrom] = playerid;
    return 1;
}
CMD:rw(playerid, params[])
{
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /rw [text]");
    }
    if (PlayerData[playerid][pWhisperFrom] == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't been whispered by anyone since you joined the server.");
    }
    if (!IsPlayerNearPlayer(playerid, PlayerData[playerid][pWhisperFrom], 5.0) && (!IsAdminOnDuty(playerid)))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be near that player to whisper them.");
    }

    SendClientMessageEx(PlayerData[playerid][pWhisperFrom], COLOR_YELLOW, "* Whisper from %s: %s *", GetRPName(playerid), params);
    SendClientMessageEx(playerid, COLOR_YELLOW, "* Whisper to %s: %s *", GetRPName(PlayerData[playerid][pWhisperFrom]), params);
    return 1;
}

CMD:cw(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), string[180];

    if (IsAMotorBike(vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in a bike.");
    }

    foreach(new i : Player)
    {
        if (IsPlayerInAnyVehicle(playerid))
        {
            if (IsPlayerInVehicle(i, vehicleid))
            {
                if (isnull(params))
                {
                    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /cw [in vehicle text]");
                }
                format(string, sizeof(string), "%s whispers: %s", GetRPName(playerid), params);
                SendProximityFadeMessage(i, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
            }
        }
    }
    return 1;
}

CMD:broadcast(playerid, params[])
{
    new style, text[128];

    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }
    if (sscanf(params, "is[128]", style, text))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /broadcast [style (0-6)] [text]");
    }
    if (!(0 <= style <= 6))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid style.");
    }
    if (style == 2)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Style 2 only disappears after death and is therefore disabled.");
    }
    if (!IsValidGameText(text))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid text format.");
    }

    GameTextForAll(text, 6000, style);
    return 1;
}


CMD:cc(playerid, params[])
{
    if (IsAdmin(playerid, ADMIN_LVL_9))
    {
        for (new j; j < 96; j++)
        {
            SendClientMessageToAllEx(-1, " " );
        }
        SendClientMessageToAllEx(0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );

        SendAdminMessage(0x1692B8FF, "Chat was cleared by admin %s", GetPlayerNameEx(playerid));
        SendClientMessageToAllEx(0x1692B8FF, "     {d909d9}>>> {FFFFFF}%s{d909d9} <<<",GetServerWebsite() );
        SendClientMessageToAllEx(0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );
    }
    return 1;
}

CMD:clear(playerid, params[])
{
    for ( new j; j < 96; j++ )
    {
        SendClientMessageEx(playerid, -1, " " );
    }
    SendClientMessageEx(playerid, 0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );
    SendClientMessageEx(playerid, 0x1692B8FF, "     {d909d9}>>> {FFFFFF}%s{d909d9} <<<",GetServerWebsite() );
    SendClientMessageEx(playerid, 0x1692B8FF, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" );
    return 1;
}

CMD:togooc(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    if (!enabledOOC)
    {
        enabledOOC = 1;
        SendClientMessageToAllEx(COLOR_WHITE, "(( Administrator %s enabled the OOC channel. ))", GetRPName(playerid));
    }
    else
    {
        enabledOOC = 0;
        SendClientMessageToAllEx(COLOR_WHITE, "(( Administrator %s disabled the OOC channel. ))", GetRPName(playerid));
    }
    return 1;
}

CMD:tognewbie(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    if (!enabledNewbie)
    {
        enabledNewbie = 1;
        SendClientMessageToAllEx(COLOR_NEWBIE, "* Administrator %s enabled the newbie channel.", GetRPName(playerid));
    }
    else
    {
        enabledNewbie = 0;
        SendClientMessageToAllEx(COLOR_NEWBIE, "* Administrator %s disabled the newbie channel.", GetRPName(playerid));
    }
    return 1;
}

CMD:togglobal(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    if (!enabledGlobal)
    {
        enabledGlobal = 1;
        SendClientMessageToAllEx(COLOR_GLOBAL, "(( Administrator %s enabled the global channel. ))", GetRPName(playerid));
    }
    else
    {
        enabledGlobal = 0;
        SendClientMessageToAllEx(COLOR_GLOBAL, "(( Administrator %s disabled the global channel. ))", GetRPName(playerid));
    }
    return 1;
}

CMD:togreports(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_4))
    {
        return SendUnauthorized(playerid);
    }

    if (!enabledReports)
    {
        enabledReports = 1;
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has enabled the report channel.", GetRPName(playerid));
    }
    else
    {
        enabledReports = 0;
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disabled the report channel.", GetRPName(playerid));
    }
    return 1;
}
