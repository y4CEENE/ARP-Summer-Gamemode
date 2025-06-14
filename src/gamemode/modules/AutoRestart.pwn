#include <YSI\y_hooks>

hook OnNewMinute(timestamp)
{
    new h, m, s;
    gettime(h, m, s);

    if(h == 4 && m == 50)
    {
        SendClientMessageToAllEx(COLOR_RED, "%s will restart server after 10 minutes!", SERVER_ANTICHEAT);
    }

    if(h == 5 && m == 00)
    {
        PerformServerRestart(INVALID_PLAYER_ID, SERVER_ANTICHEAT);
    }
    
    return 1;
}
