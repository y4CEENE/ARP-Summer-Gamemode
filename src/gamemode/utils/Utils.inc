#include "utils/AcceptCmd.pwn"
#include "utils/PlayerFooter.pwn"
#include "utils/ServerConfig.pwn"
#include "utils/IniFile.pwn"

IsProductionServer()
{
    return (GetServerVarAsInt("port") == 7777);
}

Dialog:DIALOG_NONE(playerid, response, listitem, inputtext[])
{
    return 1;
}

IsValidUsername(username[])
{
    if (strcmp(username, "Mike_Zodiac", true)==0) return true;
    new arrForbiddenNames[][] = {
            "com1", "com2", "com3", "com4",
            "com5", "com6", "com7", "com8",
            "com9", "lpt4", "lpt5", "lpt6",
            "lpt7", "lpt8", "lpt9", "nul",
            "clock$", "aux", "prn", "con",
            "InvalidNick", "BannedPlayer",
            "rex", "Mike","Zodiac","Bot",
            "nlrp", "attack", "ddos", "staff",
            "new", "life"
        },
        iLength,
        i;

    iLength = strlen(username);

    while (i < sizeof(arrForbiddenNames))
    {
        if (strcmp(arrForbiddenNames[i++], username, true) == 0)
        {
            return 0;
        }
    }
    if (username[iLength - 1] == '_' || username[0] == '_' || strfind(username, "_", false) == -1)
    {
        return 0;
    }

    new namepart[32];
    new npidx = 0;
    for (new idx = 0; idx < iLength; idx ++)
    {
        if (username[idx] == '_')
        {
            namepart[npidx] = 0;
            npidx = 0;

            if (namepart[0] == 0)
            {
                return 0;
            }

            if (strval(namepart) != 0 || (namepart[0] == 48 && namepart[1] ==0))
            {
                return 0;
            }

            continue;
        }
        else if (!((48 <= username[idx] <= 57) || (65 <= username[idx] <= 90) || (97 <= username[idx] <= 122)))
        {
            return 0;
        }
        namepart[npidx] = username[idx];
        npidx++;
    }

    if (namepart[0] != 0)
    {
        namepart[npidx] = 0;
        if (strval(namepart) != 0 || (namepart[0] == 48 && namepart[1] == 0))
        {
            return 0;
        }
    }
    return 1;
}

IsValidAdminName(username[])
{
    new arrForbiddenNames[][] = {
            "com1", "com2", "com3", "com4",
            "com5", "com6", "com7", "com8",
            "com9", "lpt4", "lpt5", "lpt6",
            "lpt7", "lpt8", "lpt9", "nul",
            "clock$", "aux", "prn", "con",
            "InvalidNick", "BannedPlayer"
        },
        iLength,
        i;

    iLength = strlen(username);

    while (i < sizeof(arrForbiddenNames))
    {
        if (strcmp(arrForbiddenNames[i++], username, true) == 0)
        {
            return 0;
        }
    }
    if (username[iLength - 1] == '_' || username[0] == '_')
    {
        return 0;
    }

    if (strfind(username, "_", false) != -1)
    {
        return 0;
    }

    new namepart[32];
    new npidx = 0;
    for (new idx = 0; idx < iLength; idx ++)
    {
        if (username[idx] == '_')
        {
            namepart[npidx] = 0;
            npidx = 0;

            if (namepart[0] == 0)
            {
                return 0;
            }

            if (strval(namepart) != 0 || (namepart[0] == 48 && namepart[1] ==0))
            {
                return 0;
            }

            continue;
        }
        else if (!((48 <= username[idx] <= 57) || (65 <= username[idx] <= 90) || (97 <= username[idx] <= 122)))
        {
            return 0;
        }
        namepart[npidx] = username[idx];
        npidx++;
    }

    if (namepart[0] != 0)
    {
        namepart[npidx] = 0;
        if (strval(namepart) != 0 || (namepart[0] == 48 && namepart[1] == 0))
        {
            return 0;
        }
    }
    return 1;
}


DBLog(table[], const text[], {Float,_}:...)
{
    static sizeArgsInBytes, args, str[1024];

    if ((args = numargs()) <= 2)
    {
        DBQuery("INSERT INTO %e VALUES(null, NOW(), '%e')", table, text);
    }
    else
    {
        sizeArgsInBytes = (1 + args) * 4;
        while (--args >= 2)
        {
            #emit LCTRL     5
            #emit LOAD.alt  args
            #emit SHL.C.alt 2
            #emit ADD.C     12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S    text
        #emit PUSH.C    192
        #emit PUSH.C    str
        // Push the number of parameters passed (in bytes) to the function.
        #emit PUSH      sizeArgsInBytes
        #emit SYSREQ.C  format
        #emit LCTRL     5
        #emit SCTRL     4

        DBQuery("INSERT INTO %e VALUES(null, NOW(), '%e')", table, str);

        #emit RETN
    }
    return 1;
}
