#include <a_samp>
#include <foreach>
#include <Pawn.CMD>
#include <YSI_Coding\y_timers>
#include <YSI\y_hooks>

#define COLOR_GREY          0xAFAFAFFF

enum hhh
{
    pLogged,
    pId    
};
new PlayerData[MAX_PLAYERS][hhh];

main()
{}

hook OnPlayerConnect(playerid)
{
    PlayerData[playerid][pLogged] = true;
}
InSameTeam(playerid, targetid)
{
    return playerid != targetid;
}

Float:GetDistanceBetweenPlayers(iPlayerOne, iPlayerTwo)
{
	new
		Float: fPlayerPos[3];

	GetPlayerPos(iPlayerOne, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
	return GetPlayerDistanceFromPoint(iPlayerTwo, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
}

#include "gamemode/modules/NameTagSystem.pwn"

