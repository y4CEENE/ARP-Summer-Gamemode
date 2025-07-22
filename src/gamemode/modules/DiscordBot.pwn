#include <YSI\y_hooks>

static DCC_Channel:SignatureChannel;
static DCC_Guild:ServerGuildID;


hook OnGameModeInit() {
    SignatureChannel = DCC_FindChannelById("1380360379934179399");
    ServerGuildID = DCC_FindGuildById("1267567121756455085");
}

DCMD:signature(user, channel, params[])
{
    new name[128];
    if (channel != SignatureChannel)
    {
        return 1;
    }
    
    if(sscanf(params, "s", name))
    {
        return DCC_SendChannelMessage(channel, "> USAGE: !signature [username]");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer),
        "SELECT uid, skin, hours, cash, level FROM "#TABLE_USERS" WHERE username = '%e'", 
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
        DCC_SendChannelMessage(SignatureChannel, "The player specified doesn't exist.");
    }
    else
    {
        new string[1028], skinurl[1028];
        new skin  = cache_get_field_content_int(0, "skin");
        new hours = cache_get_field_content_int(0, "hours");
        new cash  = cache_get_field_content_int(0, "cash");
        new level = cache_get_field_content_int(0, "level");

        format(string, sizeof(string), "**Player Name:** %s\n**Player Skin:** %i\n**Playing Hours:** %i\n**Player Cash:** %s\n**Player Level:** %i",
               username, skin, hours, FormatCash(cash), level);
        
        if (skin <= 0) {
            format(skinurl, sizeof(skinurl), "https://assets.open.mp/assets/images/skins/default.png");
        } else {
            format(skinurl, sizeof(skinurl), "https://assets.open.mp/assets/images/skins/%i.png", skin);
        }

        SendDiscordProfile(SignatureChannel, 0x33CCFF, "ArabicaRoleplay Signature", string, skinurl);
    }
    return 1;
}

SendDiscordProfile(DCC_Channel:channel, color, const title[], const message[], const skin[])
{
    new DCC_Embed:embed= DCC_CreateEmbed(title);
    DCC_SetEmbedColor(embed, color);
    DCC_SetEmbedDescription(embed, message);
    DCC_SetEmbedImage(embed, skin);

    if (DCC_SendChannelEmbedMessage(channel, embed) != 1) {
        printf("Error sending Discord embed message.");
        return 0;
    }

    return 1;
}