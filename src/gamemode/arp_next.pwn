/*  
===================================================
    📜 SCRIPT INFORMATION
===================================================
    ➤ Script Name  : Arabica RolePlay | Chapter 2
    ➤ Script Type  : SA-MP (San Andreas Multiplayer)  
    ➤ Version      : 5.5.7
    ➤ Author       : [ Khalil Zoldyck ]  
    ➤ Description  : 
        - Implements Many systems
        - Includes Voice Chat & Anti Ddos ...
        - Doors open/close with animations  
    ➤ Last Updated : [ 15/04/2025 ]  
===================================================
*/

// ---------------------------------------
// -------      SAMP includes      -------
// ---------------------------------------
#define  STREAMER_OBJECT_DD 250.0
#define  STREAMER_OBJECT_SD 250.0
#include <a_samp>
#include <crashdetect>
#include <a_mysql>
#include <foreach>
#define  ITER_NONE (cellmin) // Temporary fix for https://github.com/Misiur/YSI-Includes/issues/109
#include <MenuStore>
#include <progress2>
#include <sscanf2>
#include <json>
#include <logger>
#include <tp>
#include <selection>
#include <Pawn.CMD>
#include <dof2>
#include <streamer>
#include <flycam>
#include <YSI_Coding\y_timers>
#undef   SSCANF_Join
#undef   SSCANF_Leave
#define  INVALID_FLOOR (-1)
#include <vehicleFix>
#include <arabica-core>

// ---------------------------------------
// -------      Lib includes       -------
// ---------------------------------------
#include "samplib\samplib.inc"
#include "modules/EasyDB.pwn"
#include "modules/Notification.pwn"

// ---------------------------------------
// -------   Constants includes    -------
// ---------------------------------------
#include "const\Constants.inc"

// ---------------------------------------
// -------    Interface includes   -------
// ---------------------------------------
#include "rex/level1/DialogSpoffing.pwn"
#include "rex/level2/HealthHack.pwn"
#include "rex/level3/RudeWordsGuard.pwn"
#include <YSI\y_hooks>
DEFINE_HOOK_REPLACEMENT(OnPlayer, OP_);
DEFINE_HOOK_REPLACEMENT(OnPlayerSelection, OS_);

// ---------------------------------------
// -------     Model includes      -------
// ---------------------------------------
#include "models/Models.inc"

// ---------------------------------------
// -------      Core includes      -------
// ---------------------------------------
#include "modules/Music.pwn"
#include "core/ShowDialog.pwn"
#include "modules/Achievements.pwn"
#include "rex/BanSystem.pwn"
#include "core/AccountSettings.pwn"
#include "core/Checkpoint.pwn"
#include "core/Damage.pwn"
#include "core/DoorAndGate.pwn"
#include "core/Hospital.pwn"
#include "core/Location.pwn"
#include "core/PlayerMethod.pwn"
#include "core/PlayerSetup.pwn"
#include "core/Server.pwn"
#include "core/ServerShutdown.pwn"
#include "core/Weather.pwn"

// ---------------------------------------
// -------    Features includes    -------
// ---------------------------------------
#include "staff/Staff.inc"
#include "chat/Chat.inc"
#include "factions/Factions.inc"
#include "games/Games.inc"
#include "gang/Gang.inc"
#include "items/Items.inc"

#include "jobs/Jobs.inc"
#include "machines/Atm.pwn"
#include "machines/Sprunk.pwn"
#include "machines/Phone.pwn"
#include "properties/Properties.inc"

#include "utils/Utils.inc"
#include "views/Loading.pwn"
#include "views/Time.pwn"
#include "vip/Vip.inc"
#include "all.pwn"

// ---------------------------------------
// -------     Module includes     -------
// ---------------------------------------
#include "misc/Misc.inc"
#include "modules/Modules.inc"

// ---------------------------------------
// -------       Rex includes      -------
// ---------------------------------------
#include "rex/Rex.inc"

// ---------------------------------------
// -------     Mapping includes    -------
// ---------------------------------------
#include "mapping/Mapping.inc"

// ---------------------------------------
// -------          Main           -------
// ---------------------------------------
main()
{
    printf("[Script] Server Started");
}

CMD:credits(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_AQUA, "Arabica RolePlay is using %s game mode %s", SERVER_SHORT_NAME, SERVER_REVISION);

    SendClientMessageEx(playerid, COLOR_WHITE, " - Mike_Zodiac          : {8000FF}Scripting{FFFFFF}, {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Khalil Zoldyck       : {8000FF}Scripting{FFFFFF}, {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Jack                 : {8000FF}Scripting{FFFFFF}, {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Namroud              : {8000FF}Scripting{FFFFFF}, {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Mickey               : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Flamehaze            : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Rogue                : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Kye                  : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Faskis               : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Weponz               : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Shane-Roberts        : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - FoxHound             : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Rehasher             : {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Troy		   			: {8000FF}Scripting");
    SendClientMessageEx(playerid, COLOR_WHITE, " - PiZZA                : {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Eric_Lancer          : {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Frazix               : {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Hamden               : {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Azzolino_Paccioretti : {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - UnuAlex              : {FF0000}Mapping");
    SendClientMessageEx(playerid, COLOR_WHITE, " - Ali Eltrabelsi		: {FF0000}Mapping");
	SendClientMessageEx(playerid, COLOR_WHITE, " - Pirlo Castellano		: {FF0000}Mapping");
	SendClientMessageEx(playerid, COLOR_WHITE, " - Kelsy Moger		   	: {FF0000}Mapping");
	SendClientMessageEx(playerid, COLOR_WHITE, " - Houssem Zoldyck		: {FF0000}Mapping");
	SendClientMessageEx(playerid, COLOR_WHITE, " - Cristiano Zoldyck	: {FF0000}Mapping");

    return 1;
}

CMD:whoami(playerid,params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "I'm a script create by a developer named A B D A L M O E Z");
    SendClientMessage(playerid, COLOR_GREEN, "This script is edited by a developer named K H A L I L");
    SendClientMessage(playerid, COLOR_GREEN, "This script is orignally made for L A W L E S S - W O R L D - O F - R O L E - P L A Y");
    return 1;
}

//TODO: mysql alter table users add balloon_tickets int default 0;
//TODO: mysql alter table server_state add lotto_jackpot int default 0;
//TODO: mysql alter table server_state add lotto_tickets_sold int default 0;
// CREATE TABLE IF NOT EXISTS `lotto` (
//   `id` int(11) NOT NULL AUTO_INCREMENT,   test
//   `uid` int(11) NOT NULL,
//   `number` int(11) NOT NULL,
//   PRIMARY KEY (`id`) USING BTREE
// ) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
//TODO: mysql CREATE TABLE IF NOT EXISTS `sprunks` (`ID` INTEGER PRIMARY KEY, `PosX` FLOAT, `PosY` FLOAT, `PosZ` FLOAT, `PosR` FLOAT, `INTERIOR` INTEGER, `WORLD` INTEGER)
// CREATE TABLE IF NOT EXISTS `casefiles` (
//   `id` int(11) NOT NULL AUTO_INCREMENT,
//   `suspect` varchar(32) NOT NULL,
//   `issuer` varchar(32) NOT NULL,
//   `information` varchar(256) NOT NULL,
//   `faction` int(11) NOT NULL,
//   `active` int(11) NOT NULL,
//   PRIMARY KEY (`id`) USING BTREE
// ) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
// ALTER TABLE sprunks MODIFY COLUMN ID INT auto_increment;
//TODO: fix (maybe related to skate) AttachPlayerObjectToPlayer : removed in 0.3. I can only attach global objects.
//TODO: mysql alter table users add whitelist int default 0;
