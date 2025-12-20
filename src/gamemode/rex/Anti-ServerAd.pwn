#include <YSI\y_hooks>

hook OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(strfind(cmdtext, "samp.", true) != -1 || strfind(cmdtext, "samp,", true) != -1 || strfind(cmdtext, "7199", true) != -1 || strfind(cmdtext, "91.", true) != -1 || strfind(cmdtext, "join my server", true) != -1)
    {
        new
            i_numcount,
            i_period,
            i_pos;

        while(cmdtext[i_pos]) 
        {
            if('0' <= cmdtext[i_pos] <= '9') i_numcount++;
            else if(cmdtext[i_pos] == '.') i_period++;
            i_pos++;
        }

        if(i_numcount >= 8 && i_period >= 3) 
        {
            new string[128];
            format(string,sizeof(string),"[REX] %s may be server advertising: '%s'.", GetPlayerNameEx(playerid),cmdtext);
            ABroadCast(COLOR_RED, string, 2);
            Log("Rex/Anti-ServerAd.log", string);
            return 0;
        }
    }
    return 1;
}

