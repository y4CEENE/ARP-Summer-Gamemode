// TODO: Filter on commands

static RudeWords[][] = {
    "3asba",
    "3os",
    "3osek",
    "3sba",
    "9a7ba",
    "9hba",
    "asba",
    "charmouta",
    "din",
    "dir",
    "karzet",
    "korza",
    "krztni",
    "kss",
    "lkorza",
    "manikek",
    "manyek",
    "mankik",
    "mankikk",
    "manikik",
    "manikikk",
    "manykek",
    "menikek",
    "menykek",
    "miboun",
    "mnayk",
    "mnaik",
    "mneyk",
    "naik",
    "nik",
    "nik",
    "nike",
    "niklk",
    "nikomek",
    "nikomk",
    "nikoomkk",
    "nkmk",
    "omk",
    "rabek",
    "rabk",
    "rabkom",
    "sorm",
    "sormek",
    "ta5ra",
    "ta7an",
    "tmanek",
    "tmanyek",
    "yfz",
    "zab",
    "zaber",
    "zabour",
    "zabrmkk",
    "zbi",
    "zbi",
    "zbour",
    "zby",
    "zby",
    "zbyy",
    "zbyyy",
    "zebi",
    "zebi",
    "zebii",
    "zebiii",
    "zebiiii",
    "zfy",
    "zok",
    "zokmk"
};

FilterChat(string[])
{
    new idx = 0;
    new line[256];
    strcpy(line, string, 256);

    if (line[0] == '/')
    {
        while (line[idx] != ' ' && line[idx] != '\0')
        {
            idx++;
        }

        if (line[idx] == '\0')
        {
            return line;
        }
        idx++;
    }
    new p,linelen;
    new word[32];

    linelen=strlen(line);

    for (new i=0;i < sizeof(RudeWords);i++)
    {
        format(word, sizeof(word), " %s ", RudeWords[i]);
        while ((p=strfind(line, word, true, idx)) != -1)
        {
            for (new j = 1 ; RudeWords[i][j] != '\0' ; j++)
            {
                line[p+j] = '*';
            }
        }

        if ((p=strfind(line, RudeWords[i], true, 0)) == 0)
        {
            for (new j = 1 ; RudeWords[i][j] != '\0' ; j++)
            {
                line[p+j] = '*';
            }
        }

        new lenword = strlen(RudeWords[i]);
        if (linelen >= lenword && (p=strfind(line, RudeWords[i], true, linelen - lenword)) != -1)
        {
            for (new j = 1 ; RudeWords[i][j] != '\0' ; j++)
            {
                line[p+j] = '*';
            }
        }

    }

    return line;
}

forward OnPlayerText(playerid, text[]);
public OnPlayerText(playerid, text[])
{
    if (isnull(text))
    {
        return 0;
    }
    return CallRemoteFunction("rex_OnPlayerText", "is", playerid, FilterChat(text));
}

forward rex_OnPlayerText(playerid, text[]);
#define OnPlayerText rex_OnPlayerText
