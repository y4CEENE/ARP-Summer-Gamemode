#define SERVER_CFG          "server.conf.json"
#define CONFIG_FILE_JOBS    "data/config/jobs.json"
#define CONFIG_FILE_MUSIC   "data/config/music.json"
#define CONFIG_FILE_ROBBERY "data/config/robbery.json"

static Node:ServerConfigNode;

static  host_name                  [256] = "Arabica RolePlay | Voice";
static  server_name                [256] = "ArabicaRolePlay";
static  server_shortname           [256] = "ARP";
static  server_website             [256] = "arabicarp.com";
static  server_discord             [256] = "discord.gg/arabicarp";
static  faction_discord            [256] = "discord.gg/factionsarabica";
static  gang_discord               [256] = "discord.gg/gangsarabica";
static  server_ucp                 [256] = "www.arabicarp.com/ucp";
static  server_shop                [256] = "www.arabicarp.com/shop";

GetServerConfig(const key[], &Node:output)
{
    return JSON_GetObject(ServerConfigNode, key, output);
}

LoadServerConfig()
{
    new error = JSON_ParseFile(SERVER_CFG, ServerConfigNode);
    if(error)
    {
        printf("Faild to load '"#SERVER_CFG"', error: %d", error);
        return 0;
    }
    //JSON_ToggleGC(ServerConfigNode, false); //Ensure ServerConfigNode not deleted after leaving scope

    new Node:serverInfo;
    error = JSON_GetObject(ServerConfigNode, "server_info", serverInfo);
    if(error)
    {
        printf("Faild to get 'server_info' object from '"#SERVER_CFG"', error: %d", error);
        return 0;
    }

    if (JSON_GetString(serverInfo, "hostname", host_name))
    {
        printf("Faild to get 'hostname' from 'server_info' object");
        return 0;
    }
    if (JSON_GetString(serverInfo, "name", server_name))
    {
        printf("Faild to get 'name' from 'server_info' object");
        return 0;
    }
    if (JSON_GetString(serverInfo, "shortname", server_shortname))
    {
        printf("Faild to get 'shortname' from 'server_info' object");
        return 0;
    }

    new Node:jobs;
    error = JSON_ParseFile(CONFIG_FILE_JOBS, jobs);
    if(error)
    {
        printf("Faild to load '"#CONFIG_FILE_JOBS"', error: %d", error);
        return 0;
    }
    JSON_SetObject(ServerConfigNode, "jobs", jobs);

    new Node:music;
    error = JSON_ParseFile(CONFIG_FILE_MUSIC, music);
    if(error)
    {
        printf("Faild to load '"#CONFIG_FILE_MUSIC"', error: %d", error);
        return 0;
    }
    JSON_SetObject(ServerConfigNode, "music", music);

    new Node:robbery;
    error = JSON_ParseFile(CONFIG_FILE_ROBBERY, robbery);
    if(error)
    {
        printf("Faild to load '"#CONFIG_FILE_ROBBERY"', error: %d", error);
        return 0;
    }
    JSON_SetObject(ServerConfigNode, "robbery", robbery);

    JSON_GetString(serverInfo, "website",         server_website);
    JSON_GetString(serverInfo, "discord",         server_discord);
    JSON_GetString(serverInfo, "discord_faction", faction_discord);
    JSON_GetString(serverInfo, "discord_gang",    gang_discord);
    JSON_GetString(serverInfo, "ucp",             server_ucp);
    JSON_GetString(serverInfo, "shop",            server_shop);
    return 1;
}

stock GetHostName               () { return host_name;        }
stock GetServerName             () { return server_name;      }
stock GetServerShortName        () { return server_shortname; }
stock GetServerWebsite          () { return server_website;   }
stock GetServerDiscord          () { return server_discord;   }
stock GetFactionDiscord         () { return faction_discord;  }
stock GetGangDiscord            () { return gang_discord;     }
stock GetServerUCP              () { return server_ucp;       }
stock GetServerShop             () { return server_shop;      }
