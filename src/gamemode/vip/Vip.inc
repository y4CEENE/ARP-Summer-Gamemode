CMD:viplist(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    new count = 0;
    foreach(new i : Player)
    {
        if (PlayerData[i][pDonator] > 0)
        {
            SendClientMessageEx(playerid, COLOR_GREY2,
                "[%03d] %s has a {D909D9}%s{C8C8C8} VIP subscription expires on %s.",
                i, GetRPName(i), GetVIPRank(PlayerData[i][pDonator]),
                TimestampToString(PlayerData[i][pVIPTime], 4));
            count++;
        }
    }
    if (count == 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "There is no online vip players");
    }
    return 1;
}

CMD:v(playerid, params[])
{
    return callcmd::vip(playerid, params);
}

CMD:vip(playerid, params[])
{
    if (!PlayerData[playerid][pDonator] && !IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
    }
    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(v)ip [vip chat]");
    }
    if (PlayerData[playerid][pToggleVIP])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't speak in the VIP chat as you have it toggled.");
    }

    foreach(new i : Player)
    {
        if (!PlayerData[i][pToggleVIP] && (PlayerData[i][pDonator] > 0 || IsAdmin(i, ADMIN_LVL_4)))
        {
            SendClientMessageEx(i, COLOR_VIP, "* %s VIP %s: %s *", GetVIPRank(PlayerData[playerid][pDonator]), GetRPName(playerid), params);
        }
    }

    return 1;
}


CMD:vipcolor(playerid, params[])
{
    if (!PlayerData[playerid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
    }

    if (PlayerData[playerid][pVIPColor])
    {
        PlayerData[playerid][pVIPColor] = 0;
        return SendClientMessage(playerid, COLOR_AQUA, "* You have disabled the VIP nametag color.");
    }

    foreach (new turfid : Turf)
    {
        if (IsValidTurfId(turfid) && IsActiveTurf(turfid) && IsPlayerInTurf(playerid, turfid))
        {
            return SendClientMessage(playerid, COLOR_AQUA, "You can't enable your VIP nametag color inside an active turf.");
        }
    }
    PlayerData[playerid][pVIPColor] = 1;
    return SendClientMessage(playerid, COLOR_AQUA, "* You have enabled the VIP nametag color.");
}

CMD:vipinvite(playerid, params[])
{
    new targetid;

    if (!PlayerData[playerid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
    }
    if ((PlayerData[playerid][pVIPTime] - gettime()) < 604800)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Your VIP subscription expires in less than 7 days. You can't do this now.");
    }

    if (sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vipinvite [playerid]");
        SendClientMessage(playerid, COLOR_SYNTAX, "This command grants a temporary VIP subscription which lasts one hour to a player of your choice.");

        if (PlayerData[playerid][pVIPCooldown] > gettime())
        {
            SendClientMessageEx(playerid, COLOR_SYNTAX, "You can only use this command once every 24 hours. You have %i hours left until you can use it again.", (PlayerData[playerid][pVIPCooldown] - gettime()) / 3600);
        }
        else
        {
            SendClientMessage(playerid, COLOR_SYNTAX, "You can only use this command once every 24 hours. You currently have no cooldown for this command.");
        }

        return 1;
    }
    if (PlayerData[playerid][pVIPCooldown] > gettime())
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You have already used this command today. Please wait another %i hours.", (PlayerData[playerid][pVIPCooldown] - gettime()) / 3600);
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
    }
    if (!PlayerData[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player hasn't logged in yet.");
    }
    if (PlayerData[targetid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_GREY, "That player already has a VIP subscription.");
    }

    PlayerData[playerid][pVIPCooldown] = gettime() + 86400;
    DBQuery("UPDATE "#TABLE_USERS" SET vipcooldown = %i WHERE uid = %i", PlayerData[playerid][pVIPCooldown], PlayerData[playerid][pID]);

    GivePlayerVIPInvitation(targetid, PlayerData[playerid][pDonator]);

    SendClientMessageEx(targetid, COLOR_AQUA, "* %s has given you a temporary three hour {D909D9}%s{33CCFF} VIP package.", GetRPName(playerid), GetVIPRank(PlayerData[targetid][pDonator]));
    SendClientMessageEx(playerid, COLOR_AQUA, "* You have given %s a temporary three hour {D909D9}%s{33CCFF} VIP package.", GetRPName(targetid), GetVIPRank(PlayerData[targetid][pDonator]));

    DBLog("log_vip", "%s VIP %s (uid: %i) has given %s (uid: %i) a temporary three hour package.", GetVIPRank(PlayerData[playerid][pDonator]), GetPlayerNameEx(playerid), PlayerData[playerid][pID], GetPlayerNameEx(targetid), PlayerData[targetid][pID]);
    return 1;
}

CMD:vipinfo(playerid, params[])
{
    if (!PlayerData[playerid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
    }

    SendClientMessageEx(playerid, COLOR_NAVYBLUE, "______ VIP Package ______");
    SendClientMessageEx(playerid, COLOR_GREY2, "Your {D909D9}%s{C8C8C8} VIP subscription expires on %s.", GetVIPRank(PlayerData[playerid][pDonator]), TimestampToString(PlayerData[playerid][pVIPTime], 4));

    if (PlayerData[playerid][pVIPCooldown] > gettime())
    {
        new time = PlayerData[playerid][pVIPCooldown] - gettime();

        if (time > 3600)
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "You will be able to use the /vipinvite command again in %i hours.", time / 3600);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_GREY2, "You will be able to use the /vipinvite command again in %i minutes.", time / 60);
        }
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREY2, "Your cooldown period for /vipinvite is over and you may use it again.");
    }

    return 1;
}

CMD:vipnumber(playerid, params[])
{
    new number;

    if (!PlayerData[playerid][pDonator])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a VIP subscription.");
    }
    if (sscanf(params, "i", number))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vipnumber [phone number]");
        SendClientMessage(playerid, COLOR_SYNTAX, "This command costs 50 diamonds and changes your phone number to your chosen one.");
        return 1;
    }
    if (PlayerData[playerid][pDiamonds] < 50)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need at least 50 diamonds for pay for this.");
    }
    if (number == 0 || IsSpecialNumber(number))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
    }

    DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE phone = %i", number);
    DBExecute("OnPlayerBuyPhoneNumber", "ii", playerid, number);
    return 1;
}

DB:OnPlayerBuyPhoneNumber(playerid, number)
{
    if (GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "The specified phone number is already taken.");
    }
    else
    {
        PlayerData[playerid][pPhone] = number;
        PlayerData[playerid][pDiamonds] -= 50;
        DBQuery("UPDATE "#TABLE_USERS" SET phone = %i, diamonds = %i WHERE uid = %i",
                number, PlayerData[playerid][pDiamonds], PlayerData[playerid][pID]);

        GameTextForPlayer(playerid, "~r~$50 diamonds", 5000, 1);

        SendClientMessageEx(playerid, COLOR_AQUA, "You paid 50 diamonds to change your phone number to %i.", number);
        DBLog("log_vip", "%s VIP %s (uid: %i) has purchased phone number: %i for 50 diamonds.",
                  GetVIPRank(PlayerData[playerid][pDonator]), GetPlayerNameEx(playerid), PlayerData[playerid][pID], number);
    }
}
