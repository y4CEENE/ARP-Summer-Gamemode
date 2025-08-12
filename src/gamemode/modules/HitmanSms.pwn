#include <a_samp>
#include <sscanf2>


CMD:hsms(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
	}
 	if(PlayerData[playerid][pFactionRank] < 6)
 	{
 	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    new targetid, text[128];
	if(sscanf(params, "us[128]", targetid, text))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /(hsms) [playerid] [text]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
    if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't pm to yourself.");
	}
    new smsMsg[144];
    format(smsMsg, sizeof(smsMsg), "((SMS from Unknown)): %s", text);
    SendClientMessage(targetid, COLOR_LIGHTRED, smsMsg);

    new confMsg[144];
    format(confMsg, sizeof(confMsg), "(( SMS to %s: %s ))", GetRPName(targetid), text);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, confMsg);

    return 1;
}

CMD:hsend(playerid, params[])
{
    if(GetPlayerFaction(playerid) != FACTION_HITMAN)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
	}
	new number;

	if(sscanf(params, "i", number))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /hsend [number]");
	}
	if(!PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
	}
 	if(PlayerData[playerid][pFactionRank] < 6)
 	{
 	    return SendClientErrorUnauthorizedCmd(playerid);
	}
    if(PlayerData[playerid][pCash] < 500)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need 500$ to send sms.");
    }
	if(PlayerData[playerid][pTogglePhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
	}
	if(number == 0 || number == PlayerData[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
	}
	if(PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}

	foreach(new i : Player)
	{
	    if(PlayerData[i][pPhone] == number)
	    {
	        if(PlayerData[i][pJailType] > 0)
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
	        }
            if(GetPlayerFaction(playerid) != FACTION_HITMAN)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you're not a hitman.");
            }
	        if(PlayerData[i][pTogglePhone])
	        {
	            return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
			}

			if(PlayerData[i][pCP] != CHECKPOINT_NONE)
			{
				return SendClientMessage(playerid, COLOR_GREY, "This person is currently busy.");
			}
			
			ShowActionBubble(playerid, "* %s takes out his cellphone and sends a message.", GetRPName(playerid));
			
	        new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerCheckpoint(i, x, y, z, 2.5);
			PlayerData[playerid][pCP] = CHECKPOINT_MISC;
			SendClientMessageEx(i, COLOR_YELLOW, "SMS: New available GPS coordinates, Received from: Unknown");
			SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: New available GPS coordinates, Send to: %s(%i)", GetRPName(i), PlayerData[i][pPhone]);

	        GivePlayerCash(playerid, -500);
	        GameTextForPlayer(playerid, "~w~Text sent!~n~~r~-$500", 5000, 1);
	        return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "Cannot send SMS to %d.", number);
	return 1;
}