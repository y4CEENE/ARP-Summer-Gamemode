#define SERVER_CFG   "server.cfg"

static  host_name                  [256] = "ArabicaRolePlay | Voice";
static  server_name                [256] = "ArabicaRolePlay";
static  server_website             [256] = "arabica-rp.web.app";
static  server_discord             [256] = "https://discord.gg/arabicarp";
static  faction_discord            [256] = "discord.gg";
static  gang_discord               [256] = "discord.gg";
static  server_ucp                 [256] = "arabica-rp.web.app";
static  server_shop                [256] = "arabica-rp.web.app/shop";
static  server_music_url           [256] = "example.net/music";
static  server_fetch_url           [256] = "example.net/music";
static  vip_music_url              [256] = "example.net/music";
static  intro_music_url            [256] = "http://music.theroleplay.com/gtav.mp3";
static  geoip_mainfile             [256] = "geoip.db";
static  geoip_city                 [256] = "geoip_city.db";
static  server_stats_update_time   [256] = "5";
static  server_stats_write_to_file [256] = "false";
static  discord_channel_id         [256] = "";

INIGetKey(line[])
{
    new keyRes[64];
    keyRes[0] = 0;
    if(strfind(line , "=" , true) == -1) return keyRes;
    strmid(keyRes , line , 0 , strfind(line , "=" , true) , sizeof(keyRes));
    return keyRes;
}

INIGetValue(line[])
{
    new valRes[156];
    valRes[0]=0;
    if(strfind(line , "=" , true) == -1) return valRes;
    strmid(valRes , line , strfind(line , "=" , true)+1 , strlen(line) , sizeof(valRes));
    //new ln = strlen(valRes)-1;
    //if(ln>0)
    //{
    //    if(valRes[ln-1] == 10)
    //    {
    //        valRes[ln-1] = 0;
    //    }
    //}
    return valRes;
}

LoadServerConfig()
{
    if(!fexist(SERVER_CFG))
    {
        printf("File not found 'scriptfiles/"#SERVER_CFG"'");
        return 0;
    }

    new File: file = fopen(SERVER_CFG, io_read);
    if(!file)
    {
        printf("Cannot open 'scriptfiles/"#SERVER_CFG"'");
        return 0;
    } 
    new key[ 256 ] , val[ 256 ];
    new data[ 256 ];
    while (fread(file , data , sizeof(data)))
    {
        key = INIGetKey(data);

        if(strcmp(key , "host_name"                  , true) == 0) { val = INIGetValue(data); strmid(host_name                  , val, 0, strlen(val)-1, 255); }
        //if(strcmp(key , "server_name"                , true) == 0) { val = INIGetValue(data); strmid(server_name                , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_website"             , true) == 0) { val = INIGetValue(data); strmid(server_website             , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_discord"             , true) == 0) { val = INIGetValue(data); strmid(server_discord             , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "faction_discord"             , true) == 0) { val = INIGetValue(data); strmid(faction_discord             , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "gang_discord"             , true) == 0) { val = INIGetValue(data); strmid(gang_discord             , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_ucp"                 , true) == 0) { val = INIGetValue(data); strmid(server_ucp                 , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_shop"                , true) == 0) { val = INIGetValue(data); strmid(server_shop                , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_music_url"           , true) == 0) { val = INIGetValue(data); strmid(server_music_url           , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_fetch_url"           , true) == 0) { val = INIGetValue(data); strmid(server_fetch_url           , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "vip_music_url"              , true) == 0) { val = INIGetValue(data); strmid(vip_music_url              , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "intro_music_url"            , true) == 0) { val = INIGetValue(data); strmid(intro_music_url            , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "geoip_mainfile"             , true) == 0) { val = INIGetValue(data); strmid(geoip_mainfile             , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_stats_update_time"   , true) == 0) { val = INIGetValue(data); strmid(server_stats_update_time   , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "server_stats_write_to_file" , true) == 0) { val = INIGetValue(data); strmid(server_stats_write_to_file , val, 0, strlen(val)-1, 255); }
        if(strcmp(key , "discord_channel_id"         , true) == 0) { val = INIGetValue(data); strmid(discord_channel_id         , val, 0, strlen(val)-1, 255); }
    }
    fclose(file);
    return 1;
}

stock GetHostName               () { return host_name                ; }
stock GetServerName             () { return server_name                ; }
stock GetServerWebsite          () { return server_website             ; }
stock GetServerDiscord          () { return server_discord             ; }
stock GetFactionDiscord         () { return faction_discord            ; }
stock GetGangDiscord            () { return gang_discord               ; }
stock GetServerUCP              () { return server_ucp                 ; }
stock GetServerShop             () { return server_shop                ; }
stock GetServerMusicUrl         () { return server_music_url           ; }
stock GetServerFetchUrl         () { return server_fetch_url           ; }
stock GetVipMusicUrl            () { return vip_music_url              ; }
stock GetIntroMusicUrl          () { return intro_music_url            ; }
stock GetGeoIPMainFile          () { return geoip_mainfile             ; }
stock GetGeoIPCity              () { return geoip_city                 ; }
stock GetServerStatsUpdateTime  () { return server_stats_update_time   ; }
stock GetServerStatsWriteToFile () { return server_stats_write_to_file ; }
stock GetDiscordChannelID       () { return discord_channel_id         ; }