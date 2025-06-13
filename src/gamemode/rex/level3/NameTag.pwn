#include <YSI\y_hooks>

static AntiNameTagEnabled = 1;
static AntiNameTagDrawLimit = 30;

hook OnTwoPlayersHeartBeat(playerid, targetid)
{
    if (AntiNameTagEnabled)
    {
        if (targetid == playerid)
        {
            return 1;
        }

        if (IsAdminOnDuty(playerid, false) || IsAdminOnDuty(targetid, false))
        {
            ShowPlayerNameTagForPlayer(playerid, targetid, true);
        }
        else if (IsPlayerNearPlayer(playerid, targetid, AntiNameTagDrawLimit) && !IsPlayerWearingMask(targetid))
        {
            ShowPlayerNameTagForPlayer(playerid, targetid, true);
        }
        else
        {
            ShowPlayerNameTagForPlayer(playerid, targetid, false);
        }
    }
    return 1;
}

CMD:obscurent(playerid, params[])
{
    new status;

    if (!IsGodAdmin(playerid))
    {
        return SendUnauthorized(playerid);
    }

    if (sscanf(params, "i", status) || !(0 <= status <= 1))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /obscurent [0/1]");
    }

    if (!status)
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has disabled nametags obfuscation.", GetRPName(playerid));
    }
    else
    {
        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has enabled nametags obfuscation.", GetRPName(playerid));
    }

    AntiNameTagEnabled = status;
    return 1;
}


GetNameTagMaxDrawDistance()
{
    return AntiNameTagDrawLimit;
}

SetNameTagMaxDrawDistance(value)
{
    AntiNameTagDrawLimit = value;
}
