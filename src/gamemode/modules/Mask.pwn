#include <YSI\y_hooks>

new MaskedPlayer[MAX_PLAYERS];

hook OnLoadPlayer(playerid, row)
{
	MaskOff(playerid);
    return 1;
}

hook OnPlayerReset(playerid)
{
    if(MaskedPlayer[playerid])
    {
	    MaskOff(playerid);
    }
    return 1;
}

hook OnPlayerDeath(playerid)
{
    if(MaskedPlayer[playerid])
    {
	    MaskOff(playerid);
    }
    return 1;
}

stock IsPlayerWearingMask(playerid)
{
    return MaskedPlayer[playerid];
}
MaskOff(playerid)
{
    if(MaskedPlayer[playerid] == 0)
    {
        return;
    }

    foreach(new i : Player)
    {
        ShowPlayerNameTagForPlayer(i, playerid, 1);
    }
    
    if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
    {
        RemovePlayerAttachedObject(playerid, 9);
    }
    MaskedPlayer[playerid] = 0;
}

hook OnPlayerHeartBeat(playerid)
{
    if(!IsPlayerInSF(playerid) && MaskedPlayer[playerid])
    {
        callcmd::mask(playerid, " ");
    }
    return 1;
}
CMD:mask(playerid, params[])
{
	//new rand = Random(500, 900);
	//if(!PlayerData[playerid][pMask])
	//{
	//    return SCM(playerid, COLOR_SYNTAX, "You don't have a Mask.");
	//}

	if(MaskedPlayer[playerid] == 0)
	{
        if(!IsPlayerInSF(playerid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can use the mask only in San Fierro.");
        }
        if(!IsPlayerIdle(playerid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
        }

        if(IsAdminOnDuty(playerid, false))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this while on admin duty.");
        }

		foreach(new i : Player)
		{
			ShowPlayerNameTagForPlayer(i, playerid, 0);
		}
		MaskedPlayer[playerid] = 1;

		SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} %s puts on his/her mask.", GetRPName(playerid));
		ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);
		SetPlayerAttachedObject(playerid, 9, 19801, 2, 0.091000, 0.012000, -0.000000, 0.099999, 87.799957, 179.500015, 1.345999, 1.523000, 1.270001, 0, 0);
	}
	else
	{
	    MaskOff(playerid);
     	SendProximityMessage(playerid, 20.0, COLOR_GREY, "**{C2A2DA} Stranger takes off his/her mask.");
     	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0);
	}
	return 1;
}

CMD:masked(playerid, params[])
{
    if(!IsAdmin(playerid, 2))
    {
	    return SendClientErrorUnauthorizedCmd(playerid);
    }
    new targetid;
    new string[128], name[MAX_PLAYER_NAME+1];

    if(isnull(params))
    {   
        foreach(new i : Player)
        {
            if(IsPlayerConnected(i) && MaskedPlayer[i])
            {
                GetPlayerName(i, name, sizeof(name));
                format(string, sizeof(string),"%s[Masked] %s (%d)\n", string, name, i);
            }
        }
        SendClientMessage(playerid, COLOR_GREY, string);
    }
    else if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /masked [targetid]");
    }
    else
    {
        if(!IsPlayerConnected(targetid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid playerid.");
        }
        
        GetPlayerName(targetid, name, sizeof(name));

        if(MaskedPlayer[targetid])
        {
            SendClientMessageEx(playerid, COLOR_GREY,"[Masked] %s (%d)", name, targetid);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_GREY,"[Not Masked] %s (%d)", name, targetid);
        }
    }
	return 1;
}
