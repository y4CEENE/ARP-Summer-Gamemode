/// @file      AutoRestart.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-01-23 14:49:34 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

static AutoRestartEnabled = false;

hook OnNewMinute(timestamp)
{
    if (AutoRestartEnabled)
    {
        new h, m, s;
        gettime(h, m, s);

        if (h == 4 && m == 50)
        {
            SendClientMessageToAllEx(COLOR_RED, "%s will restart server after 10 minutes!", SERVER_ANTICHEAT);
        }

        if (h == 5 && m == 00)
        {
            PerformServerRestart(INVALID_PLAYER_ID, SERVER_ANTICHEAT);
        }
    }

    return 1;
}
