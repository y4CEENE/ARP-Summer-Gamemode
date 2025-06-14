#include <a_samp>
#include <core>
#include <float>
#include <sampvoice>
#include <Pawn.CMD>

#define LOCAL_CHAT_KEY     0x42
#define GLOBAL_CHAT_KEY    0x50
#define CHANNEL_CHAT_KEY   0x4E
#define MAX_CHANNELS      99999

#pragma tabsize 0

#define COLOR_AQUA 0x00FFFFFF

main() {}

static GlobalVoiceStatus[MAX_PLAYERS];
static PlayerChannelStatus[MAX_PLAYERS];
static PlayerChannel[MAX_PLAYERS];
static SV_GSTREAM:ChannelStreams[MAX_CHANNELS];

static SV_GSTREAM:gstream;
static SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
	if (keyid == LOCAL_CHAT_KEY && lstream[playerid] && !SvHasSpeakerInStream(lstream[playerid], playerid))
	{ 
		SvAttachSpeakerToStream(lstream[playerid], playerid);
	}
	if (keyid == GLOBAL_CHAT_KEY && gstream) 
	{
		if(CallRemoteFunction("GetAdminLevel", "d",playerid) != 0 && !SvHasSpeakerInStream(gstream, playerid))
		{
			SvAttachSpeakerToStream(gstream, playerid);
		}
	}
    
	if(PlayerChannel[playerid] > 0)
	{
		if (keyid == CHANNEL_CHAT_KEY && ChannelStreams[PlayerChannel[playerid]]  && !SvHasSpeakerInStream(ChannelStreams[PlayerChannel[playerid]], playerid)) 
		{
			SvAttachSpeakerToStream(ChannelStreams[PlayerChannel[playerid]], playerid);
            PlayerChannelStatus[playerid] = true;
		}
	}
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid) 
{
	if (keyid == LOCAL_CHAT_KEY && lstream[playerid]) 
	{
		SvDetachSpeakerFromStream(lstream[playerid], playerid);
	}

	if (keyid == GLOBAL_CHAT_KEY && gstream) 
	{
		SvDetachSpeakerFromStream(gstream, playerid);
	}
	if(PlayerChannel[playerid] > 0)
	{
		if (keyid == CHANNEL_CHAT_KEY && ChannelStreams[PlayerChannel[playerid]]) 
		{
			SvDetachSpeakerFromStream(ChannelStreams[PlayerChannel[playerid]], playerid);
            PlayerChannelStatus[playerid] = false;
		}
	}
}

public OnPlayerConnect(playerid)
{
	GlobalVoiceStatus[playerid] = false;
    PlayerChannelStatus[playerid] = false;
	PlayerChannel[playerid] = 0;
	lstream[playerid] = 0;

	if (!SvGetVersion(playerid)) 
    {
        return SendClientMessage(playerid, -1, "Cannot get VoiceChat Version");
    }
	
	if (!SvHasMicro(playerid)) 
    {
        return SendClientMessage(playerid, -1, "You don't have voice chat");
    }

	lstream[playerid] = SvCreateDLStreamAtPlayer(25.0, SV_INFINITY, playerid, 0xff0000ff, "L");
	
	if (lstream[playerid] != 0)
    { 
        // red color
		SendClientMessage(playerid, -1, "Voice chat is on");
		if (gstream) 
        {
            SvAttachListenerToStream(gstream, playerid);
        }
		SvAddKey(playerid, LOCAL_CHAT_KEY);
		SvAddKey(playerid, CHANNEL_CHAT_KEY);
	}

	return 1;	
}

public OnPlayerDisconnect(playerid, reason)
{
	if (lstream[playerid]) 
	{
		SvDeleteStream(lstream[playerid]);
		lstream[playerid] = SV_NULL;
	}

	return 1;
}

public OnGameModeInit()
{
	SvDebug(SV_FALSE);
	gstream = SvCreateGStream(0xffff0000, "G"); // blue color
	
	new radioid[32];

	for(new i=0;i<sizeof(ChannelStreams);i++)
	{
		format(radioid, sizeof(radioid), "R%d", i);
		ChannelStreams[i] = SvCreateGStream(0xFF00FFFF, radioid);
	}
	return 1;	
}

public OnGameModeExit()
{
    SvDetachAllListenersFromStream(gstream);
	SvDeleteStream(gstream);
	
	for(new i=0;i<sizeof(ChannelStreams);i++)
	{
        SvDetachAllListenersFromStream(ChannelStreams[i]);
		SvDeleteStream(ChannelStreams[i]);
	}
    for(new playerid=0;playerid<MAX_PLAYERS;playerid++)
    {
        SvRemoveAllKeys(playerid);
        
        if (lstream[playerid]) 
        {
            SvDeleteStream(lstream[playerid]);
            lstream[playerid] = SV_NULL;
        }
    }
    return 1;
}

CMD:prvoice(playerid, params[])
{
    if(PlayerChannel[playerid] == 0)
    {
        return SendClientMessage(playerid, -1, "Radio is turned off");
    }

    if (!ChannelStreams[PlayerChannel[playerid]]) 
    {
        return SendClientMessage(playerid, -1, "Internal error cannot connect to radio voice chat.");
    }
    if(PlayerChannelStatus[playerid])
    {
        SendClientMessage(playerid, -1, "* [Private Radio]: Mic off *");
        SvDetachSpeakerFromStream(ChannelStreams[PlayerChannel[playerid]], playerid);
        PlayerChannelStatus[playerid] = false;
    }
    else
    {
        SendClientMessage(playerid, -1, "* [Private Radio]: Mic on *");
        SvAttachSpeakerToStream(ChannelStreams[PlayerChannel[playerid]], playerid);
        PlayerChannelStatus[playerid] = true;
    }
    return 1;
}
CMD:gvoice(playerid, params[])
{
	if(CallRemoteFunction("GetAdminLevel", "d",playerid) == 0)
	{
	    return SendClientMessage(playerid, -1, "You are not authorized to use this command!");
	}

	if(GlobalVoiceStatus[playerid])
	{
		return SendClientMessage(playerid, -1, "You already registered to global voice chat.");	
	}
	
	SendClientMessage(playerid, -1, "You can now use global voice chat.");
	
	GlobalVoiceStatus[playerid] = true;
	
	SvAddKey(playerid, GLOBAL_CHAT_KEY);

	return 1;
}

forward OnRadioFrequencyChange(playerid, newchannel);
public OnRadioFrequencyChange(playerid, newchannel)
{
	if(lstream[playerid] == 0)
	{
		return 1; // MIC NOT AVAILABLE
	}
	new oldchannel = PlayerChannel[playerid];

	if(oldchannel != 0)
	{
        SvDetachSpeakerFromStream(ChannelStreams[PlayerChannel[playerid]], playerid);
		SvDetachListenerFromStream(ChannelStreams[oldchannel], playerid);
        PlayerChannelStatus[playerid] = false;
	}
	
	new string[128];

	if(newchannel > 0 && newchannel < MAX_CHANNELS)
	{
		if(ChannelStreams[newchannel])
		{
			PlayerChannel[playerid] = newchannel;
        	SvAttachListenerToStream(ChannelStreams[newchannel], playerid);
			format(string, sizeof(string), "Connected to voice channel %d KHz. Use N key or /prvoice to speak.", newchannel);
			SendClientMessage(playerid, -1, string);
		}
		else
		{
			format(string, sizeof(string), "Could not connect to voice channel %d KHz.", newchannel);
			SendClientMessage(playerid, -1, string);
		}
		
		return 1;
	}
	PlayerChannel[playerid] = 0;
	format(string, sizeof(string), "Failed to connect to channel (value must be in [1..%d]).", MAX_CHANNELS);
	SendClientMessage(playerid, -1, string);
	return 1;
}
