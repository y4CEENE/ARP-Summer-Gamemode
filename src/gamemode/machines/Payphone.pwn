/// @file      Payphone.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-09-01 16:31:49 +0200
/// @copyright Copyright (c) 2022


GetPhonePayphoneID(number)
{
    for (new i = 0; i < MAX_PAYPHONES; i ++)
    {
        if (IsValidPayphoneID(i) && Payphones[i][phNumber] == number)
        {
            return i;
        }
    }

    return -1;
}

IsPlayerNearRingingPayphone(playerid)
{
    new payphone = GetClosestPayphone(playerid);

    return (IsValidPayphoneID(payphone) && Payphones[payphone][phCaller] != INVALID_PLAYER_ID);
}

GetClosestPayphone(playerid)
{
    for (new i = 0; i < MAX_PAYPHONES; i ++)
    {
        if (Payphones[i][phExists] && IsPlayerNearPoint(playerid, 2.0, Payphones[i][phX], Payphones[i][phY], Payphones[i][phZ], Payphones[i][phInterior], Payphones[i][phWorld]))
        {
            return i;
        }
    }
    return -1;
}

AddPayphone(Float:x, Float:y, Float:z, Float:angle, interior, world)
{
    new
        id = GetNextPayphoneID();

    if (id != -1)
    {
        Payphones[id][phExists] = 1;
        Payphones[id][phNumber] = Random(1000000, 9999999);
        Payphones[id][phOccupied] = 0;
        Payphones[id][phCaller] = INVALID_PLAYER_ID;
        Payphones[id][phX] = x;
        Payphones[id][phY] = y;
        Payphones[id][phZ] = z;
        Payphones[id][phA] = angle;
        Payphones[id][phInterior] = interior;
        Payphones[id][phWorld] = world;
        Payphones[id][phObject] = INVALID_OBJECT_ID;
        Payphones[id][phText] = INVALID_3DTEXT_ID;

        UpdatePayphone(id);

        DBFormat("INSERT INTO rp_payphones (phInterior) VALUES(%i)", interior);
        DBExecute("OnPayphoneAdded", "i", id);
    }
    return id;
}

DB:OnPayphoneAdded(id)
{
    Payphones[id][phID] = GetDBInsertID();

    SavePayphone(id);
}

SavePayphone(id)
{
    if (!Payphones[id][phExists]) return 0;

    DBQuery("UPDATE rp_payphones SET phNumber = %i, phX = %.4f, phY = %.4f, phZ = %.4f, phA = %.4f, phInterior = %i, phWorld = %i WHERE phID = %i",
        Payphones[id][phNumber],
        Payphones[id][phX],
        Payphones[id][phY],
        Payphones[id][phZ],
        Payphones[id][phA],
        Payphones[id][phInterior],
        Payphones[id][phWorld],
        Payphones[id][phID]
    );

    return 1;
}

IsValidPayphoneID(id)
{
    return (id >= 0 && id < MAX_PAYPHONES) && Payphones[id][phExists];
}
GetNextPayphoneID()
{
    for (new i = 0; i < MAX_PAYPHONES; i ++)
    {
        if (!Payphones[i][phExists])
        {
            return i;
        }
    }
    return -1;
}


ResetPayphone(playerid)
{
    if (PlayerData[playerid][pPayphone] != -1)
    {
        Payphones[PlayerData[playerid][pPayphone]][phOccupied] = 0;
        UpdatePayphoneText(PlayerData[playerid][pPayphone]);
    }
    PlayerData[playerid][pPayphone] = -1;
}

CMD:addpayphone(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else if (GetClosestPayphone(playerid) != -1)
    {
        return SendErrorMessage(playerid, "There is another payphone nearby.");
    }
    else
    {
        new
            Float:x,
            Float:y,
            Float:z,
            Float:angle,
            id = -1;

        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        x += 2.0 * floatsin(-angle, degrees);
        y += 2.0 * floatcos(-angle, degrees);

        id = AddPayphone(x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

        if (id == -1)
        {
            return SendErrorMessage(playerid, "There are no available payphone slots.");
        }
        else
        {
            EditDynamicObjectEx(playerid, EDIT_TYPE_PAYPHONE, Payphones[id][phObject], id);
            SendInfoMessage(playerid, "You have added payphone %i (/editpayphone).", id);
        }
    }
    return 1;
}

CMD:gotopayphone(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_3))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    new id;
    if (sscanf(params, "i", id))
    {
        return SendSyntaxMessage(playerid, "/gotopayphone (payphone ID)");
    }
    else if (!IsValidPayphoneID(id))
    {
        return SendErrorMessage(playerid, "You have specified an invalid payphone ID.");
    }
    else
    {
        TeleportToCoords(playerid, Payphones[id][phX], Payphones[id][phY], Payphones[id][phZ], Payphones[id][phA], Payphones[id][phInterior], Payphones[id][phWorld]);
        SendInfoMessage(playerid, "You have teleported to payphone %i.", id);
    }
    return 1;
}

CMD:editpayphone(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else if (sscanf(params, "i", id))
    {
        return SendSyntaxMessage(playerid, "/editpayphone (payphone ID)");
    }
    else if (!IsValidPayphoneID(id))
    {
        return SendErrorMessage(playerid, "You have specified an invalid payphone ID.");
    }
    else
    {
        EditDynamicObjectEx(playerid, EDIT_TYPE_PAYPHONE, Payphones[id][phObject], id);
        SendInfoMessage(playerid, "Click on the disk icon to save changes.");
    }
    return 1;
}

CMD:deletepayphone(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else if (sscanf(params, "i", id))
    {
        return SendSyntaxMessage(playerid, "/deletepayphone (payphone ID)");
    }
    else if (!IsValidPayphoneID(id))
    {
        return SendErrorMessage(playerid, "You have specified an invalid payphone ID.");
    }
    else
    {
        if (Payphones[id][phCaller] != INVALID_PLAYER_ID)
        {
            HangupCall(Payphones[id][phCaller]);
        }

        DestroyDynamic3DTextLabel(Payphones[id][phText]);
        DestroyDynamicObject(Payphones[id][phObject]);

        DBQuery("DELETE FROM rp_payphones WHERE `phID` = %i", Payphones[id][phID]);

        Payphones[id][phExists] = 0;
        SendInfoMessage(playerid, "You have deleted payphone %i.", id);
    }
    return 1;
}


CallPayphone(playerid, payphone)
{
    foreach (new i : Player)
    {
        if (IsPlayerNearPoint(i, 20.0, Payphones[payphone][phX], Payphones[payphone][phY], Payphones[payphone][phZ], Payphones[payphone][phInterior], Payphones[payphone][phWorld]))
        {
            SendClientMessage(i, COLOR_PURPLE, "* The payphone is ringing. (( /answer ))");
        }
    }

    Payphones[payphone][phCaller] = playerid;

    UpdatePayphoneText(payphone);
}

AssignPayphone(playerid, payphone)
{
    if (IsValidPayphoneID(payphone))
    {
        PlayerData[playerid][pPayphone] = payphone;

        Payphones[payphone][phOccupied] = true;
        Payphones[payphone][phCaller] = INVALID_PLAYER_ID;

        UpdatePayphoneText(payphone);
    }
}

UpdatePayphoneText(id)
{
    new
        string[64];

    if (!Payphones[id][phExists]) return 0;

    if (IsPlayerConnected(Payphones[id][phCaller]))
    {
        format(string, sizeof(string), "ID: %i\nNumber: %i\n{FF0000}Ringing (/answer)", id, Payphones[id][phNumber]);
    }
    else if (Payphones[id][phOccupied])
    {
        format(string, sizeof(string), "ID: %i\nNumber: %i\n{FF5030}Occupied", id, Payphones[id][phNumber]);
    }
    else
    {
        format(string, sizeof(string), "ID: %i\nNumber: %i\n{00ff00}Available (/call)", id, Payphones[id][phNumber]);
    }

    UpdateDynamic3DTextLabelText(Payphones[id][phText], COLOR_GREY, string);
    return 1;
}

UpdatePayphone(id)
{
    if (!Payphones[id][phExists]) return 0;

    DestroyDynamicObject(Payphones[id][phObject]);
    DestroyDynamic3DTextLabel(Payphones[id][phText]);

    Payphones[id][phObject] = CreateDynamicObject(1216, Payphones[id][phX], Payphones[id][phY], Payphones[id][phZ], 0.0, 0.0, Payphones[id][phA], Payphones[id][phWorld], Payphones[id][phInterior]);
    Payphones[id][phText] = CreateDynamic3DTextLabel("Payphone", COLOR_GREY, Payphones[id][phX], Payphones[id][phY], Payphones[id][phZ] + 0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Payphones[id][phWorld], Payphones[id][phInterior]);

    UpdatePayphoneText(id);
    return 1;
}
