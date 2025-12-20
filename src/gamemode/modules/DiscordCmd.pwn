#include <YSI\y_hooks>
#include <discord-connector>
#include <discord-cmd>

static DCC_Channel:DutyChannel;
static DCC_Guild:ServerGuildID;


hook OnGameModeInit() {
    DutyChannel = DCC_FindChannelById("1435331061331525703");
    ServerGuildID = DCC_FindGuildById("1431206459332366378");
}

DCMD:dutytime(user, channel, params[])
{
    new name[128];
    if (channel != DutyChannel)
    {
        return 1;
    }
    
    if(sscanf(params, "s", name))
    {
        return DCC_SendChannelMessage(channel, "> USAGE: !dutytime [username]");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
        "SELECT uid, skin, hours, admin_duty_time, adminname, reports, lastlogin FROM "#TABLE_USERS" WHERE username = '%e'", 
        name
    );
    
    mysql_tquery(connectionID, queryBuffer, "DiscordCheckingStats", "s", name);
    return 1;
}

forward DiscordCheckingStats(username[]);
public DiscordCheckingStats(username[])
{
    new rows = cache_get_row_count(connectionID);
    if (rows == 0)
    {
        DCC_SendChannelMessage(DutyChannel, "The player specified doesn't exist.");
    }
    else
    {
        new string[1028], skinurl[1028], adminname[MAX_PLAYER_NAME], reportsStr[32], lastLogin[128];
        new skin  = cache_get_field_content_int(0, "skin");
        new hours = cache_get_field_content_int(0, "hours");
        new adminDutyTime = cache_get_field_content_int(0, "admin_duty_time");
        new reports = cache_get_field_content_int(0, "reports");
        cache_get_field_content(0, "adminname", adminname, connectionID, MAX_PLAYER_NAME);
        cache_get_field_content(0, "lastlogin", lastLogin, connectionID, 128);

        new dutySeconds = adminDutyTime;
        new dutyHours = dutySeconds / 3600;
        dutySeconds -= dutyHours * 3600;
        new dutyMinutes = dutySeconds / 60;
        dutySeconds -= dutyMinutes * 60;

        format(reportsStr, sizeof(reportsStr), "%s", FormatNumber(reports));

        format(string, sizeof(string), "**Admin Name:** %s\n**Admin Skin:** %i\n**Playing Hours:** %i\n**Reports:** %s\n**Duty Time:** %i hours, %i minutes, %i seconds\n**Last Login:** %s",
               adminname, skin, hours, reportsStr, dutyHours, dutyMinutes, dutySeconds, lastLogin);
        
        if (skin <= 0) {
            format(skinurl, sizeof(skinurl), "https://assets.open.mp/assets/images/skins/default.png");
        } else {
            format(skinurl, sizeof(skinurl), "https://assets.open.mp/assets/images/skins/%i.png", skin);
        }

        SendDiscordProfile(DutyChannel, 0xff0000, "Admins Duty Time ", string, skinurl);
    }
    return 1;
}

SendDiscordProfile(DCC_Channel:channel, color, const title[], const message[], const skin[])
{
    new DCC_Embed:embed= DCC_CreateEmbed(title);
    DCC_SetEmbedColor(embed, color);
    DCC_SetEmbedDescription(embed, message);
    DCC_SetEmbedThumbnail(embed, skin);

    if (DCC_SendChannelEmbedMessage(channel, embed) != 1) {
        printf("Error sending Discord embed message.");
        return 0;
    }

    return 1;
}