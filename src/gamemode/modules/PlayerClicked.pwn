/// @file      PlayerClicked.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022



hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new title[68], string[500], ip[32];
    GetPlayerIp(playerid, ip, 32);
    format(string, sizeof(string), "Report Player\nPrivate Message\n");
    if (IsAdmin(playerid))
    {
        format(string, sizeof(string), "%sKick Player\nBan Player\nSpectate Player\nBring Player\nGoto Player\nNewbie Mute Player\nFreeze Player\nUnfreeze Player\nSlap Player\nRevive Player\nCheck Player\nNon-Roleplay Name\nShow Rules\nCheck Player's Gun\nCheck Player's Vehicles\n{33CCFF}IP Address: {FFFFFF}%s", string, ip);
    }
    SetPVarInt(playerid, "pClickedID", clickedplayerid);
    format(title, sizeof(title), "{33CCFF}Player Control Panel {FFFFFF}(SELECTED: ID %d)", clickedplayerid);
    Dialog_Show(playerid, DIALOG_PCP,DIALOG_STYLE_LIST,title,string,"Select","Cancel");
    return 1;
}

Dialog:DIALOG_PM(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new targetid = GetPVarInt(playerid, "pClickedID");
        if (!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        }

        if (PlayerData[playerid][pHours] < 3)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to play at least 3 hours+ to use this command");
        }
        if (PlayerData[targetid][pTogglePM])
        {
            return SendClientMessage(playerid, COLOR_GREY, "That player has disabled incoming private messages.");
        }
        if (targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't pm yourself");
        }
        if (PlayerData[playerid][pCash] < 3000)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need $3,000 to send private message.");
        }
        SendClientMessageEx(targetid, COLOR_GREEN, "(( PM from %s: %s ))", GetRPName(playerid), inputtext);
        SendClientMessageEx(playerid, COLOR_GREEN, "(( PM to %s: %s ))", GetRPName(targetid), inputtext);
        GivePlayerCash(playerid, -3000);
        GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$3,000", 5000, 1);
        if (PlayerData[targetid][pWhisperFrom] == INVALID_PLAYER_ID)
        {
            SendClientMessage(targetid, COLOR_WHITE, "* You can use '/rpm [message]' to reply to this private message.");
        }
        PlayerData[targetid][pWhisperFrom] = playerid;
    }
    return 1;
}


Dialog:DIALOG_PCP(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new params[158], string[200];
        if (listitem == 0)
        {
            format(string,sizeof(string),"Please enter the reason why you wish to report this player:");
            Dialog_Show(playerid, DIALOG_PCP_REPORT, DIALOG_STYLE_INPUT, "{33CCFF}Player Control Panel :: Reporting", string, "Report", "Cancel");
        }
        if (listitem == 1)
        {
            Dialog_Show(playerid, DIALOG_PM, DIALOG_STYLE_INPUT, "Private Message", "Input your private message text:", "Send", "Cancel");
        }
        if (listitem == 2)
        {
            format(string,sizeof(string),"Please enter the reason why you wish to kick this player:");
            Dialog_Show(playerid, DIALOG_PCP_KICK, DIALOG_STYLE_INPUT, "{33CCFF}Player Control Panel :: Kicking", string, "Kick", "Cancel");
        }
        if (listitem == 3)
        {
            format(string,sizeof(string),"Please enter the time to ban this player for:");
            Dialog_Show(playerid, DIALOG_PCP_BAN1, DIALOG_STYLE_INPUT, "{33CCFF}Player Control Panel :: Banning", string, "Continue", "Cancel");
        }
        if (listitem == 4)
        {
            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::spec(playerid, params);
        }

        if (listitem == 5)
        {
            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::gethere(playerid, params);
        }
        if (listitem == 6)
        {
            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::goto(playerid, params);
        }
        if (listitem == 7)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::nmute(playerid, params);
        }
        if (listitem == 8)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::freeze(playerid, params);
        }
        if (listitem == 9)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::unfreeze(playerid, params);
        }
        if (listitem == 10)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::slap(playerid, params);
        }
        if (listitem == 11)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::revive(playerid, params);
        }
        if (listitem == 12)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::check(playerid, params);
        }
        if (listitem == 13)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::nrn(playerid, params);
        }
        if (listitem == 14)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::showrules(playerid, params);
        }

        if (listitem == 15)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::listguns(playerid, params);
        }
        if (listitem == 16)
        {

            format(params, sizeof(params), "%i", GetPVarInt(playerid, "pClickedID"));
            DeletePVar(playerid, "pClickedID");
            return callcmd::listpvehs(playerid, params);
        }
        if (listitem == 17)
        {
            DeletePVar(playerid, "pClickedID");
            return 1;
        }
    }
    else
    {
        DeletePVar(playerid, "pClickedID");
        return 1;
    }
    return 1;
}

Dialog:DIALOG_PCP_REPORT(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new params[158];
        format(params, sizeof(params), "%i %s", GetPVarInt(playerid, "pClickedID"), inputtext);
        DeletePVar(playerid, "pClickedID");
        return callcmd::report(playerid, params);
    }
    else
    {
        DeletePVar(playerid, "pClickedID");
        return 1;
    }

}
Dialog:DIALOG_PCP_KICK(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new params[158];
        format(params, sizeof(params), "%i %s", GetPVarInt(playerid, "pClickedID"), inputtext);
        DeletePVar(playerid, "pClickedID");
        return callcmd::kick(playerid, params);
    }
    else
    {
        DeletePVar(playerid, "pClickedID");
        return 1;
    }

}
Dialog:DIALOG_PCP_BAN1(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new string[128];
        SetPVarInt(playerid, "pBanTime", strval(inputtext));
        format(string,sizeof(string),"Please enter the reason why you wish to ban this player:");
        Dialog_Show(playerid, DIALOG_PCP_BAN2, DIALOG_STYLE_INPUT, "{33CCFF}Player Control Panel :: Banning", string, "Ban", "Cancel");
    }
    else
    {
        DeletePVar(playerid, "pClickedID");
        DeletePVar(playerid, "pBanTime");
    }
    return 1;
}
Dialog:DIALOG_PCP_BAN2(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new params[158];
        format(params, sizeof(params), "%i %i %s", GetPVarInt(playerid, "pClickedID"), GetPVarInt(playerid, "pBanTime"), inputtext);
        DeletePVar(playerid, "pClickedID");
        DeletePVar(playerid, "pBanTime");
        return callcmd::ban(playerid, params);
    }
    else
    {
        DeletePVar(playerid, "pClickedID");
        DeletePVar(playerid, "pBanTime");
        return 1;
    }

}
