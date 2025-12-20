#include <YSI\y_hooks>

hook OnPlayerCommandReceived(playerid, cmdtext[])
{
    if (ContainsServerAd(cmdtext))
    {
        new string[128];
        format(string,sizeof(string),"[REX] %s may be server advertising: '%s'.", GetPlayerNameEx(playerid),cmdtext);
        ABroadCast(COLOR_RED, string, 2);
        Log("logs/Rex/Anti-ServerAd.log", string);
        return 0;
    }
    return 1;
}

hook OnPlayerText(playerid, text[])
{
    if (ContainsServerAd(text))
    {
        new string[128];
        format(string,sizeof(string),"[REX] %s may be server advertising: '%s'.", GetPlayerNameEx(playerid), text);
        ABroadCast(COLOR_RED, string, 2);
        Log("logs/Rex/Anti-ServerAd.log", string);
        return 0;
    }
    return 1;
}

stock ContainsServerAd(const text[])
{
    static reserved[][15] = {
        "samp.",
        "samp,",
        "7199",
        "7777",
        "7770",
        "newlife",
        "new life",
        "join my server"
    };
    for (new i = 0; i < sizeof(reserved); i++)
    {
        if (strfind(text, reserved[i], true) != -1)
        {
            return true;
        }
    }

	new numCount, periods, colons;

    for (new i = 0; text[i]; i++)
    {
		if('0' <= text[i] <= '9') numCount++;
		else if(text[i] == '.')   periods++;
		else if(text[i] == ':')   colons++;
	}
	return numCount >= 7 && periods >= 3 && colons >= 1;
}
