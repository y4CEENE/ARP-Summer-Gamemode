#include <a_samp>
#include <core>
#include <float>
#include <sampvoice>
#include <Pawn.CMD>

#include "../gamemode/const/Max.def"

#define CHAT_KEY     0x42 // Key B
#define MAX_CHANNELS      99999

#pragma tabsize 0

#define COLOR_AQUA 0x00FFFFFF

main() {}

enum
{
    VoiceType_Local,
    VoiceType_Radio,
    VoiceType_Faction,
    VoiceType_Gang,
    VoiceType_Global
};

static SpeakerChatType[MAX_PLAYERS];
static SpeakerChatId[MAX_PLAYERS];
static PlayerChannel[MAX_PLAYERS];
static SV_GSTREAM:ChannelStreams[MAX_CHANNELS];

static SV_GSTREAM:gstream;
static SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

new SV_GSTREAM:factionstream[MAX_FACTIONS] = { SV_NULL, ... };
new SV_GSTREAM:gangstream[MAX_GANGS] = { SV_NULL, ... };

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if (keyid == CHAT_KEY)
    {
        switch (SpeakerChatType[playerid])
        {
            case VoiceType_Local:
            {
                if (lstream[playerid] && !SvHasSpeakerInStream(lstream[playerid], playerid))
                    SvAttachSpeakerToStream(lstream[playerid], playerid);
            }
            case VoiceType_Radio:
            {
                if(SpeakerChatId[playerid] > 0 && SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                   ChannelStreams[SpeakerChatId[playerid]]  && !SvHasSpeakerInStream(ChannelStreams[SpeakerChatId[playerid]], playerid))
                {
                   SvAttachSpeakerToStream(ChannelStreams[SpeakerChatId[playerid]], playerid);
                }
            }
            case VoiceType_Faction:
            {
                if (SpeakerChatId[playerid] != -1 && SpeakerChatId[playerid] < sizeof(factionstream) &&
                    factionstream[SpeakerChatId[playerid]] && !SvHasSpeakerInStream(factionstream[SpeakerChatId[playerid]], playerid))
                {
                        SvAttachSpeakerToStream(factionstream[SpeakerChatId[playerid]], playerid);
                }
            }
            case VoiceType_Gang:
            {
                if (SpeakerChatId[playerid] != -1 && SpeakerChatId[playerid] < sizeof(gangstream) &&
                    gangstream[SpeakerChatId[playerid]] && !SvHasSpeakerInStream(gangstream[SpeakerChatId[playerid]], playerid))
                {
                        SvAttachSpeakerToStream(gangstream[SpeakerChatId[playerid]], playerid);
                }
            }
            case VoiceType_Global:
            {
                if (CallRemoteFunction("GetAdminLevel", "d",playerid) != 0 && gstream && !SvHasSpeakerInStream(gstream, playerid))
                {
                    SvAttachSpeakerToStream(gstream, playerid);
                }
            }
        }
    }
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if (keyid == CHAT_KEY)
    {
        switch (SpeakerChatType[playerid])
        {
            case VoiceType_Local:
            {
                if (lstream[playerid])
                    SvDetachSpeakerFromStream(lstream[playerid], playerid);
            }
            case VoiceType_Radio:
            {
                if (SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                    ChannelStreams[SpeakerChatId[playerid]])
                    SvDetachSpeakerFromStream(ChannelStreams[SpeakerChatId[playerid]], playerid);

            }
            case VoiceType_Faction:
            {
                if (SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                    factionstream[SpeakerChatId[playerid]])
                    SvDetachSpeakerFromStream(factionstream[SpeakerChatId[playerid]], playerid);
            }
            case VoiceType_Gang:
            {
                if (SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                    gangstream[SpeakerChatId[playerid]])
                    SvDetachSpeakerFromStream(gangstream[SpeakerChatId[playerid]], playerid);
            }
            case VoiceType_Global:
            {
                if (gstream)
                    SvDetachSpeakerFromStream(gstream, playerid);
            }
        }
    }
}

public OnPlayerConnect(playerid)
{
    PlayerChannel[playerid] = 0;
    lstream[playerid] = 0;
    SpeakerChatType[playerid] = 0;
    SpeakerChatId[playerid] = -1;

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
        SvAddKey(playerid, CHAT_KEY);
    }

    return 1;
}

forward OnPlayerLoaded(playerid, row);
public OnPlayerLoaded(playerid, row)
{
    FixChatId(playerid);
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

    for(new i=0;i<sizeof(gangstream);i++)
    {
        gangstream[i] = SvCreateGStream(0xffff0000, "Gang Radio");
    }

    for(new i=0;i<sizeof(factionstream);i++)
    {
        factionstream[i] = SvCreateGStream(0xffff0000, "Faction Radio");
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

    for(new i=0;i<sizeof(gangstream);i++)
    {
        SvDetachAllListenersFromStream(gangstream[i]);
        SvDeleteStream(gangstream[i]);
    }

    for(new i=0;i<sizeof(factionstream);i++)
    {
        SvDetachAllListenersFromStream(factionstream[i]);
        SvDeleteStream(factionstream[i]);
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

forward OnVoiceChatChanged(playerid, oldVoiceChat, newVoiceChat);
public OnVoiceChatChanged(playerid, oldVoiceChat, newVoiceChat)
{
    switch (SpeakerChatType[playerid])
    {
        case VoiceType_Local:
        {
            if (lstream[playerid])
                SvDetachSpeakerFromStream(lstream[playerid], playerid);
        }
        case VoiceType_Radio:
        {
            if (SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                ChannelStreams[SpeakerChatId[playerid]])
                SvDetachSpeakerFromStream(ChannelStreams[SpeakerChatId[playerid]], playerid);
        }
        case VoiceType_Faction:
        {
            if (SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                factionstream[SpeakerChatId[playerid]])
                SvDetachSpeakerFromStream(factionstream[SpeakerChatId[playerid]], playerid);
        }
        case VoiceType_Gang:
        {
            if (SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams) &&
                gangstream[SpeakerChatId[playerid]])
                SvDetachSpeakerFromStream(gangstream[SpeakerChatId[playerid]], playerid);
        }
        case VoiceType_Global:
        {
            if (gstream)
                SvDetachSpeakerFromStream(gstream, playerid);
        }
    }

    SpeakerChatType[playerid] = newVoiceChat;

    switch (newVoiceChat)
    {
        case VoiceType_Radio:
        {
            SpeakerChatId[playerid] = CallRemoteFunction("GetRadioChannel", "d", playerid);
        }
        case VoiceType_Faction:
        {
            SpeakerChatId[playerid] = CallRemoteFunction("GetPlayerFactionId", "d", playerid);
        }
        case VoiceType_Gang:
        {
            SpeakerChatId[playerid] = CallRemoteFunction("GetPlayerGangId", "d", playerid);
        }
    }
}

FixChatId(playerid)
{
    if(lstream[playerid] == 0)
    {
        return 1; // MIC NOT AVAILABLE
    }

    switch (SpeakerChatType[playerid])
    {
        case VoiceType_Radio:
        {
            new newId = CallRemoteFunction("GetRadioChannel", "d", playerid);
            if (SpeakerChatId[playerid] != newId && SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(ChannelStreams))
            {
                SvDetachSpeakerFromStream(ChannelStreams[SpeakerChatId[playerid]], playerid);
                SvDetachListenerFromStream(ChannelStreams[SpeakerChatId[playerid]], playerid);
            }

            if (newId > 0 && newId < sizeof(ChannelStreams))
            {
                SvAttachListenerToStream(ChannelStreams[newId], playerid);
            }

            SpeakerChatId[playerid] = newId;
        }
        case VoiceType_Faction:
        {
            new newId = CallRemoteFunction("GetPlayerFactionId", "d", playerid);
            if (SpeakerChatId[playerid] != newId && SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(factionstream))
            {
                SvDetachSpeakerFromStream(factionstream[SpeakerChatId[playerid]], playerid);
                SvDetachListenerFromStream(factionstream[SpeakerChatId[playerid]], playerid);
            }

            if (newId >= 0 && newId < sizeof(factionstream))
            {
                SvAttachListenerToStream(factionstream[newId], playerid);
            }

            SpeakerChatId[playerid] = newId;
        }
        case VoiceType_Gang:
        {
            new newId = CallRemoteFunction("GetPlayerGangId", "d", playerid);
            if (SpeakerChatId[playerid] != newId && SpeakerChatId[playerid] > 0 &&  SpeakerChatId[playerid] < sizeof(gangstream))
            {
                SvDetachSpeakerFromStream(gangstream[SpeakerChatId[playerid]], playerid);
                SvDetachListenerFromStream(gangstream[SpeakerChatId[playerid]], playerid);
            }

            if (newId >= 0 && newId < sizeof(gangstream))
            {
                SvAttachListenerToStream(gangstream[newId], playerid);
            }

            SpeakerChatId[playerid] = newId;
        }
    }
    return 1;
}

forward OnPlayerHeartBeat(playerid);
public OnPlayerHeartBeat(playerid)
{
    FixChatId(playerid);
}
