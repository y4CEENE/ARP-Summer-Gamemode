/// @file      KeyRing.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-05-25 23:23:11 +0200
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MAX_KEYRING_ITEMS 10
#define INVALID_KEYRING_ID -1

enum eKeyRing {
    KeyRing_ID,
    KeyRing_OwnerID,
    KeyRing_PropertyID,
    PropertyType:KeyRing_PropertyType,
    KeyRing_AccessType,
    KeyRing_Expiry,
};

static KeyRing[MAX_PLAYERS][MAX_KEYRING_ITEMS][eKeyRing];

hook OnPlayerLoaded(playerid)
{
    DBFormat("SELECT * FROM keyring WHERE userid = %i", PlayerData[playerid][pID]);
    DBExecute("LoadPlayerKeyRing", "i", playerid);
    return 1;
}

DB:LoadPlayerKeyRing(playerid)
{
    new rows = GetDBNumRows();

    for (new idx = 0; idx < MAX_KEYRING_ITEMS; idx ++)
    {
        if (idx < rows)
        {
            KeyRing[playerid][idx][KeyRing_ID          ] = GetDBIntField(idx, "id");
            KeyRing[playerid][idx][KeyRing_OwnerID     ] = GetDBIntField(idx, "ownerid");
            KeyRing[playerid][idx][KeyRing_PropertyID  ] = GetDBIntField(idx, "propertyid");
            KeyRing[playerid][idx][KeyRing_PropertyType] = PropertyType:GetDBIntField(idx, "propertyType");
            KeyRing[playerid][idx][KeyRing_AccessType  ] = GetDBIntField(idx, "accessType");
            KeyRing[playerid][idx][KeyRing_Expiry      ] = GetDBIntField(idx, "expiry");
        }
        else
        {
            KeyRing[playerid][idx][KeyRing_ID] = INVALID_KEYRING_ID;
        }
    }
    return 1;
}

stock GetPlayerNbPropertyKeys(playerid)
{
    new c = 0;
    for (new idx = 0; idx < MAX_KEYRING_ITEMS; idx ++)
    {
        if (KeyRing[playerid][idx][KeyRing_ID] != INVALID_KEYRING_ID)
        {
            c++;
        }
    }
    return c;
}

stock GetPlayerPropertyKey(playerid, PropertyType:type, propertyid)
{
    new dbid = -1;
    new ownerdbid = -1;
    if (type == PropertyType_Vehicle && IsValidVehicle(propertyid))
    {
        if (IsVehicleOwner(playerid, propertyid))
            return KeyRole_Owner;

        if (VehicleInfo[propertyid][vGang] >= 0 && VehicleInfo[propertyid][vGang] == PlayerData[playerid][pGang])
        {
            if (IsGangLeader(playerid, PlayerData[playerid][pGang]))
            {
                return KeyRole_Owner;
            }
            else
            {
                return KeyRole_Visitor;
            }
        }
        dbid = VehicleInfo[propertyid][vID];
        ownerdbid = VehicleInfo[propertyid][vOwnerID];
    }
    else if (type == PropertyType_House && IsValidHouse(propertyid))
    {
        if (IsHouseOwner(playerid, propertyid))
            return KeyRole_Owner;

        if (PlayerData[playerid][pRentingHouse] == HouseInfo[propertyid][hID])
            return KeyRole_Tenant;

        dbid = HouseInfo[propertyid][hID];
        ownerdbid = HouseInfo[propertyid][hOwnerID];
    }
    else if (type == PropertyType_Land && IsValidLand(propertyid))
    {
        if (IsLandOwner(playerid, propertyid))
            return KeyRole_Owner;
        dbid = LandInfo[propertyid][lID];
        ownerdbid = LandInfo[propertyid][lOwnerID];
    }
    else if (type == PropertyType_Garage && IsValidGarage(propertyid))
    {
        if (IsGarageOwner(playerid, propertyid))
            return KeyRole_Owner;
        dbid = GarageInfo[propertyid][gID];
        ownerdbid = GarageInfo[propertyid][gOwnerID];
    }
    else if (type == PropertyType_Entrance && IsValidEntrance(propertyid))
    {
        if (IsEntranceOwner(playerid, propertyid))
            return KeyRole_Owner;
        dbid = EntranceInfo[propertyid][eID];
        ownerdbid = EntranceInfo[propertyid][eOwnerID];
    }
    if (dbid > 0 && ownerdbid > 0)
    {
        for (new idx = 0; idx < MAX_KEYRING_ITEMS; idx++)
        {
            if (KeyRing[playerid][idx][KeyRing_ID]           != INVALID_KEYRING_ID &&
                KeyRing[playerid][idx][KeyRing_PropertyType] == type &&
                KeyRing[playerid][idx][KeyRing_PropertyID  ] == dbid &&
                KeyRing[playerid][idx][KeyRing_OwnerID     ] == ownerdbid &&
                KeyRing[playerid][idx][KeyRing_Expiry      ] > gettime())
            {
                return KeyRing[playerid][idx][KeyRing_AccessType];
            }
        }
    }
    return KeyRole_Unauthorized;
}

stock PlayerHasPropertyAccess(playerid, PropertyType:type, propertyid, KeyAccess:accessType)
{
    return ((GetPlayerPropertyKey(playerid, type, propertyid) & _:accessType) == _:accessType);
}

stock GivePlayerPropertyAccess(playerid, owneruid, PropertyType:type, propertyid, access, expiry = 0)
{
    if (access == KeyRole_Owner)
        return false;

    if (!IsPlayerConnected(playerid) || PlayerData[playerid][pID] == owneruid)
        return false;

    new propertyDbId = GetPropertyDBId(type, propertyid);
    if (propertyDbId == -1)
        return false;

    new slot = -1;
    for (new idx = 0; idx < MAX_KEYRING_ITEMS; idx ++)
    {
        if (KeyRing[playerid][idx][KeyRing_ID] == INVALID_KEYRING_ID)
        {
            KeyRing[playerid][idx][KeyRing_OwnerID     ] = owneruid;
            KeyRing[playerid][idx][KeyRing_PropertyID  ] = propertyDbId;
            KeyRing[playerid][idx][KeyRing_PropertyType] = type;
            KeyRing[playerid][idx][KeyRing_AccessType  ] = access;
            KeyRing[playerid][idx][KeyRing_Expiry      ] = expiry;
            slot = idx;
            break;
        }
    }
    if (slot == -1)
    {
        return false;
    }

    DBFormat("INSERT INTO keyring (userid, ownerid, propertyid, propertyType, accessType, expiry)"\
            " VALUES (%d, %d, %d, %d, %d, %d)",
            PlayerData[playerid][pID], owneruid, propertyDbId, _:type, _:access, expiry);
    DBExecute("OnKeyringAdd", "ii", playerid, slot);
    return true;
}

stock UpdatePlayerPropertyAccess(playerid, owneruid, PropertyType:type, propertyid, access, expiry = 0)
{
    if (access == KeyRole_Owner)
        return false;
    if (!IsPlayerConnected(playerid) || PlayerData[playerid][pID] == owneruid)
        return false;

    new propertyDbId = GetPropertyDBId(type, propertyid);
    if (propertyDbId == -1)
        return false;

    new slot = -1;
    for (new idx = 0; idx < MAX_KEYRING_ITEMS; idx ++)
    {

        if (KeyRing[playerid][idx][KeyRing_ID] != INVALID_KEYRING_ID &&
            KeyRing[playerid][idx][KeyRing_PropertyID  ] == propertyDbId &&
            KeyRing[playerid][idx][KeyRing_OwnerID     ] == owneruid &&
            KeyRing[playerid][idx][KeyRing_PropertyType] == type)
        {
            KeyRing[playerid][idx][KeyRing_AccessType  ] = access;
            KeyRing[playerid][idx][KeyRing_Expiry      ] = expiry;
            slot = idx;
            break;
        }
    }
    if (slot == -1)
    {
        return false;
    }
    DBQuery("UPDATE keyring SET accessType=%i, expiry=%i where id=%i;", access, expiry, KeyRing[playerid][slot][KeyRing_ID]);
    return true;
}

DB:OnKeyringAdd(playerid, slot)
{
    KeyRing[playerid][slot][KeyRing_ID] = GetDBInsertID();
}

stock RemovePlayerPropertyAccess(playerid, PropertyType:type, propertyid)
{
    if (!IsPlayerConnected(playerid))
        return false;

    new propertyDbId = GetPropertyDBId(type, propertyid);
    if (propertyDbId == -1)
        return false;

    for (new idx = 0; idx < MAX_KEYRING_ITEMS; idx ++)
    {
        if (KeyRing[playerid][idx][KeyRing_PropertyID] == propertyid &&
            KeyRing[playerid][idx][KeyRing_PropertyType] == type)
        {
            KeyRing[playerid][idx][KeyRing_ID] = INVALID_KEYRING_ID;
        }
    }
    DBQuery("DELETE FROM keyring where userid = %d and propertyid = %d and propertyType = %d",
            PlayerData[playerid][pID], propertyid, _:type);
    return true;
}

stock OfflineRemovePropertyAccess(const username[], PropertyType:type, propertyid)
{
    new playerid = GetPlayerID(username);
    if (IsPlayerConnected(playerid))
        return RemovePlayerPropertyAccess(playerid, type, propertyid);

    DBQuery("DELETE FROM keyring where propertyid = %d and propertyType = %d and userid = (select uid from users where username='%e');",
            propertyid, _:type, username);
    return true;
}

stock GetPropertyDBId(PropertyType:type, propertyid)
{
    new propertyDbId = -1;
    switch (type)
    {
        case PropertyType_Vehicle:  if (0 <= propertyid < sizeof(VehicleInfo))  propertyDbId = VehicleInfo[propertyid][vID];
        case PropertyType_House:    if (0 <= propertyid < sizeof(HouseInfo))    propertyDbId = HouseInfo[propertyid][hID];
        case PropertyType_Land:     if (0 <= propertyid < sizeof(LandInfo))     propertyDbId = LandInfo[propertyid][lID];
        case PropertyType_Garage:   if (0 <= propertyid < sizeof(GarageInfo))   propertyDbId = GarageInfo[propertyid][gID];
        case PropertyType_Entrance: if (0 <= propertyid < sizeof(EntranceInfo)) propertyDbId = EntranceInfo[propertyid][eID];
    }
    return propertyDbId;
}
