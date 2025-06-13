/// @file      ServerShutdown.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022

PerformServerRestart(playerid, playername[])
{
    if (gGMX)
    {
        return 0;
    }

    gGMX = 1;

    foreach(new i : Player)
    {
        if (i != playerid)
        {
            if (PlayerData[i][pAdminDuty])
            {
                callcmd::aduty(i, "");
            }
            PlayerData[i][pHurt] = 0;
            TogglePlayerControllableEx(i, 0);
            SendClientMessageEx(i, COLOR_AQUA, "* %s has initated a server restart. You have been frozen.", playername);
        }

        SavePlayerVariables(i);
        GameTextForPlayer(i, "~w~Restarting server...", 100000, 3);
    }
    if (playerid != INVALID_PLAYER_ID)
    {
        SendClientMessage(playerid, COLOR_WHITE, "* The server will restart once all accounts have been saved.");
    }

    return 1;
}

CMD:gmx(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }

    if (strcmp(params, "confirm", true) == 0)
    {
        if (!PerformServerRestart(playerid, GetRPName(playerid)))
        {
            SendClientMessage(playerid, COLOR_GREY, "You have already called for a server restart. You can't cancel it.");
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gmx [confirm]");
        SendClientMessage(playerid, COLOR_SYNTAX, "This command save all player accounts and restarts the server.");

    }
    return 1;
}


CMD:shutdownserver(playerid, params[])
{
    if (IsGodAdmin(playerid))
    {

        if (strcmp(params, "confirm", true))
        {
            SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /shutdown [confirm]");
            SendClientMessage(playerid, COLOR_GREY3, "This command save all player accounts and shutsdown the server.");
            return 1;
        }
        if (gGMX)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have already called for a server shutdown. You can't cancel it.");
        }

        gGMX = 0;
        SetTimer("FinishServerShutdown", 5000, false);
        SendClientMessage(playerid, COLOR_GREY, "Server will shutdown in 5 seconds.");

        foreach(new i : Player)
        {
            TogglePlayerControllableEx(i, 0);
            SavePlayerVariables(i);
        }
    }
    return 1;
}

CMD:lockserver(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return 0;
    }

    if (isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /lockserver [password (0 to remove password)]");
    }

    new password[32];
    format(password, sizeof(password), "password %s", params);
    SendRconCommand(password);
    if (!strcmp(params, "0"))
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "You removed the server password.");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_RED, "You changed the server %s.", password);
    }
    return 1;
}
