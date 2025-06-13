#include <a_samp>
#include <streamer>

// ================ Mapping Include ================

// =================================================
#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
    CallRemoteFunction("OnRemoveBuildings", "i", playerid);
}
