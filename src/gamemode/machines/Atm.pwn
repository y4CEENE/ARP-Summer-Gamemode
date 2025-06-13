/// @file      Atm.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022

enum atmEnum
{
    Float:atmX,
    Float:atmY,
    Float:atmZ,
    Float:atmA
};

static const atmMachines[][atmEnum] =
{
    {2228.394775, -1714.255126, 13.158315, 270.000000},
    {1928.599975, -1779.941650, 13.136871, 90.000000},
//    {1493.294677, -1772.306640, 18.385747, 180.000000},
    {1102.299438, -1438.380981, 15.396868, 90.000000},
    {563.902526, -1293.948730, 16.858232, 180.000000},
    {2233.269042, -1158.040527, 25.540679, 270.000000},
    {827.125183, -1345.751220, 13.182147, 270.000000},
    {827.125183, -1346.811157, 13.182147, 270.000000},
    {1093.036621, 29.262479, 1000.309509, 0.000000},
    {-14.377381, -180.600250, 1003.186889, 180.000000},
    {9.334012, -31.044189, 1003.159179, 270.000000},
    {-24.413511, -91.806381, 1003.126708, 180.000000},
    {-21.125793, -140.438766, 1003.166564, 180.000000},
    {-24.290849, -57.946674, 1003.176574, 180.000000}
};

DB:OnLoadAtms()
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_ATMS; i ++)
    {
        ATM[i][atmExists] = 1;
        ATM[i][atmID] = GetDBIntField(i, "atmID");
        ATM[i][atmSpawn][0] = GetDBFloatField(i, "atmX");
        ATM[i][atmSpawn][1] = GetDBFloatField(i, "atmY");
        ATM[i][atmSpawn][2] = GetDBFloatField(i, "atmZ");
        ATM[i][atmSpawn][3] = GetDBFloatField(i, "atmA");
        ATM[i][atmInterior] = GetDBIntField(i, "atmInterior");
        ATM[i][atmWorld] = GetDBIntField(i, "atmWorld");
        ATM[i][atmObject] = INVALID_OBJECT_ID;
        ATM[i][atmText] = INVALID_3DTEXT_ID;
        UpdateATM(i);
    }
    printf("[Script] %i atms loaded", (rows < MAX_ATMS) ? (rows) : (MAX_ATMS));
}

AddATMMachine(Float:x, Float:y, Float:z, Float:angle, interior, world)
{
    new
        id = GetNextATMID();

    if (id != -1)
    {
        ATM[id][atmExists] = 1;
        ATM[id][atmSpawn][0] = x;
        ATM[id][atmSpawn][1] = y;
        ATM[id][atmSpawn][2] = z;
        ATM[id][atmSpawn][3] = angle;
        ATM[id][atmInterior] = interior;
        ATM[id][atmWorld] = world;
        ATM[id][atmObject] = INVALID_OBJECT_ID;
        ATM[id][atmText] = INVALID_3DTEXT_ID;

        UpdateATM(id);

        DBFormat("INSERT INTO rp_atms (atmInterior) VALUES(%i)", interior);
        DBExecute("OnATMAdded", "i", id);
    }
    return id;
}
IsValidATMID(id)
{
    return (id >= 0 && id < MAX_ATMS) && ATM[id][atmExists];
}
GetNextATMID()
{
    for (new i = 0; i < MAX_ATMS; i ++)
    {
        if (!ATM[i][atmExists])
        {
            return i;
        }
    }
    return -1;
}

SaveATM(id)
{
    if (!ATM[id][atmExists]) return 0;

    DBQuery("UPDATE rp_atms SET atmX = %.4f, atmY = %.4f, atmZ = %.4f, atmA = %.4f, atmInterior = %i, atmWorld = %i WHERE atmID = %i",
        ATM[id][atmSpawn][0],
        ATM[id][atmSpawn][1],
        ATM[id][atmSpawn][2],
        ATM[id][atmSpawn][3],
        ATM[id][atmInterior],
        ATM[id][atmWorld],
        ATM[id][atmID]
    );
    return 1;
}

UpdateATM(id)
{
    if (!ATM[id][atmExists])
    {
        return 0;
    }
    DestroyDynamic3DTextLabel(ATM[id][atmText]);
    DestroyDynamicObject(ATM[id][atmObject]);
    ATM[id][atmObject] = CreateDynamicObject(19324, ATM[id][atmSpawn][0], ATM[id][atmSpawn][1], ATM[id][atmSpawn][2], 0.0, 0.0, ATM[id][atmSpawn][3], ATM[id][atmWorld], ATM[id][atmInterior]);
    ATM[id][atmText] = CreateDynamic3DTextLabel("ATM machine\n/atm to operate.", COLOR_YELLOW, ATM[id][atmSpawn][0], ATM[id][atmSpawn][1], ATM[id][atmSpawn][2] + 0.9, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATM[id][atmWorld], ATM[id][atmInterior]);
    return 1;
}

Dialog:DIALOG_ATM(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            ShowDialogToPlayer(playerid, DIALOG_ATMDEPOSIT);
        }
        else
        {
            ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
        }
    }
    return 1;
}
Dialog:DIALOG_ATMDEPOSIT(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new amount, fee;

        if (sscanf(inputtext, "i", amount))
        {
            return ShowDialogToPlayer(playerid, DIALOG_ATM);
        }
        if (amount < 1 || amount > PlayerData[playerid][pCash])
        {
            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount. Please try again.");
            ShowDialogToPlayer(playerid, DIALOG_ATMDEPOSIT);
            return 1;
        }
        if (amount > 1000000)
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't deposit more than $1,000,000 at a time.");
            ShowDialogToPlayer(playerid, DIALOG_ATMDEPOSIT);
            return 1;
        }

        PlayerData[playerid][pBank] += amount;
        GivePlayerCash(playerid, -amount);

        if (PlayerData[playerid][pDonator] == 0)
        {
            fee = percent(amount, 3);

            PlayerData[playerid][pBank] -= fee;
           // AddToTaxVault(fee);
        }

        DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);

        ShowActionBubble(playerid, "* %s presses a button and deposits some cash into the ATM.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have deposited %s into your account. Your new balance is %s.", FormatCash(amount), FormatCash(PlayerData[playerid][pBank]));

        if (fee)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "A 3 percent convenience fee of %s was deducted from your bank account.", FormatCash(fee));
            AddToTaxVault(fee);
        }
        else if (PlayerData[playerid][pDonator] > 0)
        {
            SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You do not pay the 3 percent convenience fee as you are a VIP!");
        }
    }
    return 1;
}
Dialog:DIALOG_ATMWITHDRAW(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new amount, fee;

        if (sscanf(inputtext, "i", amount))
        {
            return ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
        }
        if (amount < 1 || amount > PlayerData[playerid][pBank])
        {
            SendClientMessage(playerid, COLOR_GREY, "Insufficient amount. Please try again.");
            ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
            return 1;
        }
        if (amount > 1000000)
        {
            SendClientMessage(playerid, COLOR_GREY, "You can't withdraw more than $1,000,000 at a time.");
            ShowDialogToPlayer(playerid, DIALOG_ATMWITHDRAW);
            return 1;
        }

        PlayerData[playerid][pBank] -= amount;
        GivePlayerCash(playerid, amount);

        if (PlayerData[playerid][pDonator] == 0)
        {
            fee = percent(amount, 3);

            PlayerData[playerid][pBank] -= fee;
        }

        DBQuery("UPDATE "#TABLE_USERS" SET bank = %i WHERE uid = %i", PlayerData[playerid][pBank], PlayerData[playerid][pID]);

        ShowActionBubble(playerid, "* %s presses a button and withdraws some cash from the ATM.", GetRPName(playerid));
        SendClientMessageEx(playerid, COLOR_AQUA, "You have withdrawn %s from your account. Your new balance is %s.", FormatCash(amount), FormatCash(PlayerData[playerid][pBank]));

        if (fee)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "A 3 percent convenience fee of %s was deducted from your bank account.", FormatCash(fee));
            AddToTaxVault(fee);
        }
        else if (PlayerData[playerid][pDonator] > 0)
        {
            SendClientMessage(playerid, COLOR_VIP, "VIP Perk: You do not pay the 3 percent convenience fee as you are a VIP!");
        }
    }
    return 1;
}

DB:OnATMAdded(id)
{
    ATM[id][atmID] = GetDBInsertID();

    SaveATM(id);
}

hook OnGameModeInit()
{
    for (new i = 0; i < sizeof(atmMachines); i ++)
    {
        CreateDynamicObject(19324, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ], 0.0, 0.0, atmMachines[i][atmA]);
        CreateDynamic3DTextLabel("ATM machine\n/atm to operate.", COLOR_YELLOW, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ] + 0.4, 10.0);
    }
    return 1;
}

GetNearbyAtm(playerid)
{
    for (new i = 0; i < MAX_ATMS; i ++)
    {
        if (ATM[i][atmExists] && IsPlayerNearPoint(playerid, 2.0, ATM[i][atmSpawn][0], ATM[i][atmSpawn][1], ATM[i][atmSpawn][2], ATM[i][atmInterior], ATM[i][atmWorld]))
        {
            return i;
        }
    }
    return -1;
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (PlayerData[playerid][pEdit] == EDIT_TYPE_ATM)
    {
        if (response == EDIT_RESPONSE_CANCEL)
        {
            UpdateATM(PlayerData[playerid][pEditID]);
        }
        else if (response == EDIT_RESPONSE_FINAL)
        {
            ATM[PlayerData[playerid][pEditID]][atmSpawn][0] = x;
            ATM[PlayerData[playerid][pEditID]][atmSpawn][1] = y;
            ATM[PlayerData[playerid][pEditID]][atmSpawn][2] = z;
            ATM[PlayerData[playerid][pEditID]][atmSpawn][3] = rz;

            UpdateATM(PlayerData[playerid][pEditID]);
            SaveATM(PlayerData[playerid][pEditID]);

            SendInfoMessage(playerid, "You have edited ATM machine ID: %i.", PlayerData[playerid][pEditID]);
        }
        PlayerData[playerid][pEdit] = EDIT_TYPE_NONE;
        PlayerData[playerid][pEditID] = -1;
    }
    return 1;
}


CMD:atm(playerid, params[])
{
    for (new i = 0; i < sizeof(atmMachines); i ++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ]))
        {
            ShowDialogToPlayer(playerid, DIALOG_ATM);
            return 1;
        }
    }
    if (GetNearbyAtm(playerid) >= 0)
    {
        ShowDialogToPlayer(playerid, DIALOG_ATM);
        return 1;
    }

    SendClientMessage(playerid, COLOR_GREY, "You are not in range of any ATM machines.");
    return 1;
}


CMD:createatm(playerid, params[])
{
    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else if (GetNearbyAtm(playerid) != -1)
    {
        return SendErrorMessage(playerid, "There is another ATM nearby.");
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

        id = AddATMMachine(x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

        if (id == -1)
        {
            return SendErrorMessage(playerid, "There are no available ATM slots.");
        }
        else
        {
            EditDynamicObjectEx(playerid, EDIT_TYPE_ATM, ATM[id][atmObject], id);
            SendInfoMessage(playerid, "You have added ATM machine %i (/editatm).", id);
        }
    }
    return 1;
}

CMD:gotoatm(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendUnauthorized(playerid);
    }

    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }

    if (sscanf(params, "i", id))
    {
        return SendSyntaxMessage(playerid, "/gotoatm (machine ID)");
    }
    else if (!IsValidATMID(id))
    {
        return SendErrorMessage(playerid, "You have specified an invalid ATM machine.");
    }
    else
    {
        TeleportToCoords(playerid, ATM[id][atmSpawn][0], ATM[id][atmSpawn][1], ATM[id][atmSpawn][2], ATM[id][atmSpawn][3], ATM[id][atmInterior], ATM[id][atmWorld]);
        SendInfoMessage(playerid, "You have teleported to ATM machine %i.", id);
    }
    return 1;
}

CMD:editatm(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else if (sscanf(params, "i", id))
    {
        return SendSyntaxMessage(playerid, "/editatm (machine ID)");
    }
    else if (!IsValidATMID(id))
    {
        return SendErrorMessage(playerid, "You have specified an invalid ATM machine.");
    }
    else
    {
        EditDynamicObjectEx(playerid, EDIT_TYPE_ATM, ATM[id][atmObject], id);
        SendInfoMessage(playerid, "Click on the disk icon to save changes.");
    }
    return 1;
}

CMD:deleteatm(playerid, params[])
{
    new id;

    if (!IsAdmin(playerid, ADMIN_LVL_5))
    {
        return SendErrorMessage(playerid, "You are not privileged to use this command.");
    }
    else if (sscanf(params, "i", id))
    {
        return SendSyntaxMessage(playerid, "/deleteatm (machine ID)");
    }
    else if (!IsValidATMID(id))
    {
        return SendErrorMessage(playerid, "You have specified an invalid ATM machine.");
    }
    else
    {
        DestroyDynamic3DTextLabel(ATM[id][atmText]);
        DestroyDynamicObject(ATM[id][atmObject]);

        DBQuery("DELETE FROM rp_atms WHERE `atmID` = %i", ATM[id][atmID]);

        ATM[id][atmExists] = 0;
        SendInfoMessage(playerid, "You have deleted ATM %i.", id);
    }
    return 1;
}
