



#define ANTI_HACK_DISABLED 0
#define ANTI_HACK_NONE     1
#define ANTI_HACK_INFO     2
#define ANTI_HACK_KICK     3
#define ANTI_HACK_BAN      4

static ReactionName[][20] = {"{FF0000}Disabled", "{0000FF}None", "{0000FF}Info", "{FF7F27}Kick", "{007F00}Ban"};

static SelectedAntiHackMenu[MAX_PLAYERS];
enum eAntiHack
{
    ahName[64],
    ahState
};

static AntiHackConfig[][eAntiHack] = {
 { "Anti-BotSpawn"        , ANTI_HACK_KICK },
 { "Anti-DialogSpoffing"  , ANTI_HACK_INFO },
 { "Anti-Fly"             , ANTI_HACK_KICK },
 { "Anti-NameTag"         , ANTI_HACK_NONE },
 { "Anti-Proxy"           , ANTI_HACK_KICK },
 { "Anti-RapidFire"       , ANTI_HACK_INFO },
 { "Anti-ServerAd"        , ANTI_HACK_INFO },
 { "Anti-TeleportHack"    , ANTI_HACK_INFO }
};

ShowAntiHackMainMenu(playerid)
{
    new menu[512];

    menu = "Anti-cheat\tState";


    for (new i=0;i<sizeof(AntiHackConfig);i++)
    {
        format(menu, sizeof(menu), "%s\n%s\t%s", menu, AntiHackConfig[i][ahName] , ReactionName[AntiHackConfig[i][ahState]]);
    }

    Dialog_Show(playerid, AntiHackSettings, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Anti-Hack Settings", menu, "Select", "Cancel");
}

ShowAntiHackConfig(playerid, antihackid)
{

    new title[128];
    format(title, sizeof(title), "{FFFFFF}Anti-Hack Settings::%s", AntiHackConfig[antihackid][ahName]);
    new menu[128];

    format(menu, sizeof(menu), "{FFFFFF}Parameter\tValue\nState:\t%s{FFFFFF}", ReactionName[AntiHackConfig[antihackid][ahState]]);

    switch (antihackid)
    {
        case 0: //Anti-BotSpawn
        {
            format(menu, sizeof(menu), "%s\nMaximum connection per ip:\t%d", menu, GetMaximumConnectionPerIP());
        }
        case 1: //Anti-DialogSpoffing
        {

        }
        case 2: //Anti-Fly
        {
            format(menu, sizeof(menu), "%s\nFly speed limit:\t%d", menu, GetFlySpeedLimit());
        }
        case 3: //Anti-NameTag
        {
            format(menu, sizeof(menu), "%s\nNameTag maximum draw distance:\t%d", menu, GetNameTagMaxDrawDistance());
        }
        case 4: //Anti-Proxy
        {

        }
        case 5: //Anti-RapidFire
        {
            format(menu, sizeof(menu), "%s\nMinimum delay between fire(ms):\t%d", menu, GetMinimumFireDelay());
        }
        case 6: //Anti-ServerAd
        {

        }
        case 7: //Anti-TeleportHack
        {

        }
    }
    Dialog_Show(playerid, AntiHackListConfig, DIALOG_STYLE_TABLIST_HEADERS, title, "State", "Select", "Cancel");
    return 1;
}

CMD:antihack(playerid, params[])
{
    if (!IsGodAdmin(playerid))
    {
        return 0;
    }

    ShowAntiHackMainMenu(playerid);

    return 1;
}

Dialog:AntiHackSettings(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        return 1;
    }

    if (!(0 <= listitem <sizeof(AntiHackConfig)))
    {
        return 1;
    }
    SelectedAntiHackMenu[playerid] = listitem;
    ShowAntiHackConfig(playerid, listitem);

    return 1;
}

Dialog:AntiHackListConfig(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
        ShowAntiHackMainMenu(playerid);
        return 1;
    }

    new title[128];

    if (listitem == 0)
    {
        format(title, sizeof(title), "Enter new state of %s", AntiHackConfig[SelectedAntiHackMenu[playerid]][ahName]);
        Dialog_Show(playerid, AntiHackStateChange, DIALOG_STYLE_LIST, title, "Disable\nNone\nInfo\nKick\nBan", "Select", "Cancel");
    }

    if (listitem == 1)
    {
        format(title, sizeof(title), "{FFFFFF}Anti-Hack::%s", AntiHackConfig[SelectedAntiHackMenu[playerid]][ahName]);

        switch (SelectedAntiHackMenu[playerid])
        {
            case 0: //Anti-BotSpawn
            {
                Dialog_Show(playerid, AntiHackParameterChange, DIALOG_STYLE_INPUT, title, "Enter the maximum connection per IP:\n Current value: %d\n Default value: 4", "OK", "Back", GetMaximumConnectionPerIP());
            }
            case 1: //Anti-DialogSpoffing
            {

            }
            case 2: //Anti-Fly
            {
                Dialog_Show(playerid, AntiHackParameterChange, DIALOG_STYLE_INPUT, title, "Enter the fly speed limit:\n Current value: %d\n Default value: 200", "OK", "Back", GetFlySpeedLimit());
            }
            case 3: //Anti-NameTag
            {
                Dialog_Show(playerid, AntiHackParameterChange, DIALOG_STYLE_INPUT, title, "Enter NameTag drawing distance limit:\n Current value: %d\n Default value: 30", "OK", "Back", GetNameTagMaxDrawDistance());
            }
            case 4: //Anti-Proxy
            {

            }
            case 5: //Anti-RapidFire
            {
                Dialog_Show(playerid, AntiHackParameterChange, DIALOG_STYLE_INPUT, title, "Enter minimum delay between fire in ms:\n Current value: %d\n Default value: 25ms", "OK", "Back", GetMinimumFireDelay());
            }
            case 6: //Anti-ServerAd
            {

            }
            case 7: //Anti-TeleportHack
            {

            }
        }
    }
    return 1;
}

Dialog:AntiHackStateChange(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (0 <= listitem <=4)
        {
            AntiHackConfig[SelectedAntiHackMenu[playerid]][ahState] = listitem;
        }
    }
    ShowAntiHackConfig(playerid, SelectedAntiHackMenu[playerid]);
    return 1;
}

Dialog:AntiHackParameterChange(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new value = strval(inputtext);

        switch (SelectedAntiHackMenu[playerid])
        {
            case 0: //Anti-BotSpawn
            {
                SetMaximumConnectionPerIP(value);
            }
            case 1: //Anti-DialogSpoffing
            {

            }
            case 2: //Anti-Fly
            {
                SetFlySpeedLimit(value);
            }
            case 3: //Anti-NameTag
            {
                SetNameTagMaxDrawDistance(value);
            }
            case 4: //Anti-Proxy
            {

            }
            case 5: //Anti-RapidFire
            {
                SetMinimumFireDelay(value);
            }
            case 6: //Anti-ServerAd
            {

            }
            case 7: //Anti-TeleportHack
            {

            }
        }
    }
    ShowAntiHackConfig(playerid, SelectedAntiHackMenu[playerid]);
    return 1;
}
