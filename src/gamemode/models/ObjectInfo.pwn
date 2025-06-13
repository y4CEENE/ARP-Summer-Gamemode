/// @file      ObjectInfo.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum {
    EDIT_TYPE_NONE,
    EDIT_TYPE_PREVIEW,
    EDIT_TYPE_FURNITURE,
    EDIT_TYPE_PAYPHONE,
    EDIT_TYPE_ATM
};

enum
{
    E_OBJECT_TYPE,
    E_OBJECT_INDEX_ID,
    E_OBJECT_EXTRA_ID,
    E_OBJECT_3DTEXT_ID,
    E_OBJECT_OPENED,
    E_OBJECT_WEAPONID,
    E_OBJECT_FACTION,
    E_OBJECT_X,
    E_OBJECT_Y,
    E_OBJECT_Z
};

enum
{
    E_OBJECT_FURNITURE,
    E_OBJECT_WEAPON,
    E_OBJECT_LAND
};

enum
{
    EDIT_CLOTHING_PREVIEW = 1,
    EDIT_CLOTHING,
    EDIT_LAND_OBJECT_PREVIEW,
    EDIT_LAND_OBJECT,
    EDIT_LAND_GATE_MOVE,
    EDIT_COP_CLOTHING,
    EDIT_GATE_OBJECT,
    EDIT_GATE_MOVE
};

new gPreviewFurniture[MAX_PLAYERS] = {-1, ...};

EditDynamicObjectEx(playerid, type, objectid, extraid = -1)
{
    PlayerData[playerid][pEdit] = type;
    PlayerData[playerid][pEditID] = extraid;

    return EditDynamicObject(playerid, objectid);
}

CancelObjectEdit(playerid)
{
    PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
    PlayerData[playerid][pEditID] = -1;

    return CancelEdit(playerid);
}

Dialog:DIALOG_DELETEOBJECT(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (IsValidDynamicObject(PlayerData[playerid][pSelected]))
        {
            new Text3D:textid = Text3D:Streamer_GetExtraInt(PlayerData[playerid][pSelected], E_OBJECT_3DTEXT_ID);
            if (IsValidDynamic3DTextLabel(textid))
            {
                DestroyDynamic3DTextLabel(textid);
            }
            DestroyDynamicObject(PlayerData[playerid][pSelected]);
            /*if (Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_LAND)
            {
                Iter_Remove(PlayerData[playerid][pSelected], LandObjects);
            }*/
            SendClientMessageEx(playerid, COLOR_AQUA, "You have successfully deleted object id %i.", PlayerData[playerid][pSelected]);
            new Float: x, Float: y, Float: z;
            GetPlayerPos(playerid, x, y, z);
            foreach(new i : Player)
            {
                if (IsPlayerInRangeOfPoint(i, 100.0, x, y ,z))
                {
                    Streamer_UpdateEx(i, x, y, z);
                }
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_AQUA, "Unable to destroy that object, ERROR #1: Not a valid streamer object.");
        }
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_AQUA, "You cancelled deleting object id %i.", PlayerData[playerid][pSelected]);
    }
    return 1;
}
