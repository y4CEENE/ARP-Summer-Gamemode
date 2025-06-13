/// @file      Gang.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum gaEnum
{
    gSetup,
    gIsMafia,
    gName[32],
    gMOTD[128],
    gLeaderUID,
    gLeader[MAX_PLAYER_NAME],
    gColor,
    gCount,
    gStrikes,
    gLevel,
    gPoints,
    gTurfTokens,
    Float:gStashX,
    Float:gStashY,
    Float:gStashZ,
    gStashInterior,
    gStashWorld,
    gCash,
    gMaterials,
    gWeed,
    gCocaine,
    gHeroin,
    gPainkillers,
    gSkins[MAX_GANG_SKINS],
    gWeapons[14],
    gWeaponRanks[14],
    gVestRank,
    gArmsDealer,
    gDrugDealer,
    Float:gArmsX,
    Float:gArmsY,
    Float:gArmsZ,
    Float:gArmsA,
    Float:gDrugX,
    Float:gDrugY,
    Float:gDrugZ,
    Float:gDrugA,
    gArmsWorld,
    gDrugWorld,
    gDrugWeed,
    gDrugCocaine,
    gDrugHeroin,
    gArmsMaterials,
    gArmsPrices[12],
    gDrugPrices[3],
    Text3D:gText[3],
    gPickup,
    gActors[2],
    gAlliance,
    gMatLevel,
    gGunLevel,
    gInvCooldown,
    gRankingPoints
};
new GangInfo[MAX_GANGS][gaEnum];
new GangRanks[MAX_GANGS][7][32];
new GangCrews[MAX_GANGS][MAX_GANG_CREWS][32];
new Text3D:fRepfamtext[MAX_PLAYERS];
