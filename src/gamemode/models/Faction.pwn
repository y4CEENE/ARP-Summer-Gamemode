/// @file      Faction.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum
{
    FACTION_NONE,
    FACTION_POLICE,
    FACTION_MEDIC,
    FACTION_NEWS,
    FACTION_GOVERNMENT,
    FACTION_HITMAN,
    FACTION_FEDERAL,
    FACTION_ARMY,
    FACTION_TERRORIST
};

new const factionTypes[][] =
{
    {"Civilian"},
    {"Law enforcement"},
    {"Medical & fire"},
    {"News agency"},
    {"Government"},
    {"Hitman agency"},
    {"Federal police"},
    {"Armed Forces"}
};

enum fEnum
{
    fName[48],
    fShortName[24],
    fMOTD[128],
    fLeader[MAX_PLAYER_NAME],
    fType,
    fColor,
    fRankCount,
    fBudget,
    g_iLockerStock,
    fSkins[MAX_FACTION_SKINS],
    fPaycheck[MAX_FACTION_RANKS],
    fTurfTokens,
    Text3D:fText,
    fPickup,
    fCount
};

new FactionInfo[MAX_FACTIONS][fEnum];
new FactionRanks[MAX_FACTIONS][MAX_FACTION_RANKS][32];
new FactionDivisions[MAX_FACTIONS][MAX_FACTION_DIVISIONS][32];
