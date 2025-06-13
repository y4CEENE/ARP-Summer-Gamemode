/// @file      DiscordBot.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-10-08 18:50:03 +0100
/// @copyright Copyright (c) 2022



static DCC_Channel:IG_Admin_Announcement;
static ConnectedToDiscord=0;

GetDiscordChannelID()
{
    return "895772517485117480"; //TODO: add it to config file
}

hook OnGameModeInit()
{
    IG_Admin_Announcement = DCC_FindChannelById(GetDiscordChannelID());
    if (IG_Admin_Announcement)
    {
        new string[128];
        format(string,sizeof string,"Server succesfully started");
        DCC_SendChannelMessage(IG_Admin_Announcement, string);
        ConnectedToDiscord=1;
    }
    return 1;
}


publish DCC_OnMessageCreate(DCC_Message:message)
{
    if (ConnectedToDiscord)
    {
        new realMsg[100];
        DCC_GetMessageContent(message, realMsg, 100);
        new bool:IsBot;
        new DCC_Channel:channel;
        DCC_GetMessageChannel(message, channel);
        new DCC_User:author;
        DCC_GetMessageAuthor(message, author);
        DCC_IsUserBot(author, IsBot);
        if (channel == IG_Admin_Announcement && !IsBot) //!IsBot will block BOT's message in game
        {
            new user_name[32 + 1], str[152];
            DCC_GetUserName(author, user_name, 32);
            format(str,sizeof(str), "{8a6cd1}[DISCORD] {aa1bb5}%s: {ffffff}%s",user_name, realMsg);
            SendClientMessageToAll(-1, str);
        }
    }
    return 1;
}


public OnDiscordCommandPerformed(DCC_User:user, DCC_Channel:channel, cmdtext[], success)
{
    if (ConnectedToDiscord)
    {
        if (!success)
        {

            DCC_SendChannelMessage(channel, "This command does not exist!");
        }
    }
    return 1;
}


BCMD:gmx(user, channel, params[])
{
    if (ConnectedToDiscord && channel == IG_Admin_Announcement)
    {
        new user_name[32 + 1];
        DCC_GetUserName(user, user_name, 32);

        if (!PerformServerRestart(INVALID_PLAYER_ID, user_name))
        {
            DCC_SendChannelMessage(channel, "Server restart already called. You can't cancel it.");
        }
    }
    return 1;
}

DiscordSendMessage(msg[])
{
    if (ConnectedToDiscord)
    {
        DCC_SendChannelMessage(IG_Admin_Announcement, msg);
    }
}
