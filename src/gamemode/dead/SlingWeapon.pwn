/// @file      SlingWeapon.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-01-25 09:05:26 +0100
/// @copyright Copyright (c) 2022

//TODO: Add sling support

//  CMD:ame(playerid, params[])
//  {
//      new activewep = GetPVarInt(playerid, "activesling");
//      new message[100], string[128];
//      if (sscanf(params, "s[100]", message))
//      {
//          SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ame [action]");
//          SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Set the action to OFF to remove the label.");
//          return 1;
//      }
//      if (activewep > 0)
//      {
//          SendClientMessageEx(playerid, COLOR_GREY, "  You have a weapon slung around your back, you can't use /ame.");
//          return 1;
//      }
//      if (strcmp(message, "off", true) == 0)
//      {
//          SendClientMessageEx(playerid, COLOR_GREY, "  You have removed the description label.");
//
//          DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
//          PlayerData[playerid][aMeStatus] =0;
//          return 1;
//      }
//      if (strlen(message) > 100) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too long, please reduce the length.");
//      if (strlen(message) < 3) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too short, please increase the length.");
//      if (PlayerData[playerid][aMeStatus] == 0)
//      {
//          PlayerData[playerid][aMeStatus] =1;
//
//          format(string, sizeof(string), "* %s %s", GetPlayerNameEx(playerid), message);
//          PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.0, 20.0, playerid);
//          SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//          return 1;
//      }
//      else
//      {
//          format(string, sizeof(string), "* %s %s", GetPlayerNameEx(playerid), message);
//          UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
//          SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//          return 1;
//      }
//  }


enum eWeaponBackCoords
{
    WeaponBackCoords_Model,
    WeaponBackCoords_Bone,
    Float:WeaponBackCoords_PosX,
    Float:WeaponBackCoords_PosY,
    Float:WeaponBackCoords_PosZ,
    Float:WeaponBackCoords_RotX,
    Float:WeaponBackCoords_RotY,
    Float:WeaponBackCoords_RotZ,
    Float:WeaponBackCoords_ScaleX,
    Float:WeaponBackCoords_ScaleY,
    Float:WeaponBackCoords_ScaleZ,
};

///     <li><b><c>1</c></b> - spine</li>
///     <li><b><c>2</c></b> - head</li>
///     <li><b><c>3</c></b> - left upper arm</li>
///     <li><b><c>4</c></b> - right upper arm</li>
///     <li><b><c>5</c></b> - left hand</li>
///     <li><b><c>6</c></b> - right hand</li>
///     <li><b><c>7</c></b> - left thigh</li>
///     <li><b><c>8</c></b> - right thigh</li>
///     <li><b><c>9</c></b> - left foot</li>
///     <li><b><c>10</c></b> - right foot</li>
///     <li><b><c>11</c></b> - right calf</li>
///     <li><b><c>12</c></b> - left calf</li>
///     <li><b><c>13</c></b> - left forearm</li>
///     <li><b><c>14</c></b> - right forearm</li>
///     <li><b><c>15</c></b> - left clavicle (shoulder)</li>
///     <li><b><c>16</c></b> - right clavicle (shoulder)</li>
///     <li><b><c>17</c></b> - neck</li>
///     <li><b><c>18</c></b> - jaw </li>

//----
{ , 1672, 16, -0.110606, -0.054021, 0.036716, 215.687911, 354.659393, 90.000000, 1.000000, 1.000000, 1.000000 );    // Smoke grenade
{ , 331, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );         // Brassknuckle
{ , 335, 11, 0.142010, -0.100988, 0.055910, 76.125000, 75.876144, 1.143326, 1.000000, 1.000000, 1.000000 );     // Knife
{ , 339, 15, 0.088326, 0.066626, 0.148351, 191.990447, 341.412963, 0.000000, 1.000000, 1.000000, 1.000000 );        // Katana
{ , 342, 16, -0.110845, -0.041751, 0.087840, 55.051963, 84.884071, 247.221984, 1.000000, 1.000000, 1.000000 );  // Grenade
{ , 344, 15, 0.029351, -0.208807, -0.164047, 0.000000, 359.932037, 0.000000, 1.000000, 1.000000, 1.000000 );        // Molotov Cocktail
{ , 346, 8, -0.028010, -0.033822, 0.097883, 270.000000, 15.999426, 354.161499, 1.000000, 1.000000, 1.000000 );  // 9mm
{ , 348, 8, -0.040643, -0.048525, 0.085376, 270.000000, 8.253683, 0.000000, 1.000000, 1.000000, 1.000000 );     // Deagle
{ , 349, 16, 0.084126, 0.131737, 0.197423, 176.984542, 92.569320, 14.483574, 1.000000, 1.000000, 1.000000 );        // Shotgun
{ , 350, 16, 0.090676, 0.085271, -0.075131, 0.000000, 289.166870, 355.209869, 1.000000, 1.000000, 1.000000 );   // Sawnoff
{ , 351, 16, 0.100795, 0.057224, -0.082939, 180.000000, 243.483581, 180.000000, 1.000000, 1.000000, 1.000000 ); // Spas
{ , 352, 7, 0.138560, -0.033982, -0.047630, 281.671447, 276.618591, 4.068862, 1.000000, 1.000000, 1.000000 );   // Uzi
{ , 353, 7, 0.008329, -0.067031, -0.060214, 289.865051, 17.391622, 7.667663, 1.000000, 1.000000, 1.000000 );        // MP5
{ , 355, 1, -0.130044, -0.127836, 0.025491, 2.044970, 6.239807, 6.833646, 1.000000, 1.000000, 1.000000 );       // AK-47
{ , 356, 16, 0.019280, 0.118553, 0.396286, 70.920410, 274.673919, 253.978057, 1.000000, 1.000000, 1.000000 );   // M4
{ , 365, 12, 0.174919, -0.004211, -0.142508, 0.000000, 270.000000, 0.000000, 1.000000, 1.000000, 1.000000 );        // Spraycan
{ , 367, 1, 0.227036, 0.171111, -0.085516, 270.000000, 0.000000, 180.000000, 1.000000, 1.000000, 1.000000 );        // Camera
{ , 369, 2, 0.000000, 0.078037, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );         // Irgoggles
{ , 372, 7, 0.056180, -0.008887, -0.007959, 270.000000, 13.921591, 5.905599, 1.000000, 1.000000, 1.000000 );        // Tec-9
//----| uid      | int         | YES  |     | NULL    |                |
| name     | varchar(32) | YES  |     | NULL    |                |
| modelid  | smallint    | YES  |     | NULL    |                |
| boneid   | tinyint     | YES  |     | NULL    |                |
| attached | tinyint(1)  | YES  |     | NULL    |                |
| pos_x    | float       | YES  |     | NULL    |                |
| pos_y    | float       | YES  |     | NULL    |                |
| pos_z    | float       | YES  |     | NULL    |                |
| rot_x    | float       | YES  |     | NULL    |                |
| rot_y    | float       | YES  |     | NULL    |                |
| rot_z    | float       | YES  |     | NULL    |                |
| scale_x  | float       | YES  |     | NULL    |                |
| scale_y  | float       | YES  |     | NULL    |                |
| scale_z  | float       | YES  |     | NULL    |                |
+----------+-------------+------+-----+---------+----------------+

insert into clothing (uid, name, modelid, boneid, attached, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z)
values
(1, "gun_dildo1", 321, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "gun_dildo2", 322, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "gun_vibe1", 323, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "gun_vibe2", 324, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "A bouquet of red flowers", 325, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "gun_cane", 326, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Golf club", 333, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Baton", 334, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Bat", 336, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Shovel", 337, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Billiard cue stick", 338, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Chainsaw", 341, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Teargas", 343, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Silenced", 347, 8, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Rifle", 357, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Sniper", 358, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "RocketLauncher", 359, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "heatseek", 360, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Remote explosives", 363, 16, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "fire_ex", 366, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "nvgoggles", 368, 2, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0),
(1, "Parachute", 371, 7, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

static WeaponBackCoords[][eWeaponBackCoords] = {

                case 0:
                {
                    if (IsPlayerAttachedObjectSlotUsed(i, 0)) RemovePlayerAttachedObject(i, 0);
                    if (weps[a] == 1 && GetPlayerWeapon(i) != 1) SetPlayerAttachedObject( i, 0, 331, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
                }
                case 1:
                {
                    if (IsPlayerAttachedObjectSlotUsed(i, 1)) RemovePlayerAttachedObject(i, 1);
                    switch (weps[a])
                    {
                        case 4: if (GetPlayerWeapon(i) != 4) SetPlayerAttachedObject( i, 0, 335, 11, 0.142010, -0.100988, 0.055910, 76.125000, 75.876144, 1.143326, 1.000000, 1.000000, 1.000000 );
                        case 8: if (GetPlayerWeapon(i) != 8) SetPlayerAttachedObject( i, 1, 339, 15, 0.088326, 0.066626, 0.148351, 191.990447, 341.412963, 0.000000, 1.000000, 1.000000, 1.000000 );
                    }
                }
};
publish SlingTimerGiveWeapon(playerid)
{
    if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
    {
        SetPVarInt(playerid, "GiveWeaponTimer", GetPVarInt(playerid, "GiveWeaponTimer")-1);
        SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);
    }
    return 1;
}

SetWeaponOnBack(playerid, weaponid)
{
    if (IsPlayerAttachedObjectSlotUsed(playerid, 8))
    {
        RemovePlayerAttachedObject(playerid, 8);
    }

    SetPlayerAttachedObject( i, 0, 335, 11, 0.142010, -0.100988, 0.055910, 76.125000, 75.876144, 1.143326, 1.000000, 1.000000, 1.000000 );
}

CMD:sling(playerid, params[])
{
    if (!IsPlayerIdle(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }

    if (IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
    }


    if (GetPVarInt(playerid, "activesling") > 0)
    {
        new weaponid = GetPVarInt(playerid, "activesling");

        if (PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != 0)
        {
            return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot unsling the weapon. You already have a weapon in this slot!");
        }

        SendClientMessageEx(playerid, COLOR_WHITE, "You have unslung the %s from your back.", GetWeaponNameEx(weaponid));
        SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s unslings a %s from their back.", GetRPName(playerid), GetWeaponNameEx(weaponid));

        GivePlayerWeaponEx(playerid, weaponid, true);

        DeletePVar(playerid, "activesling");
        DeletePVar(playerid, "activeslingammo");
    }
    else
    {
        new weaponid;
        if (sscanf(params, "i", weaponid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /sling [weaponid] (/guninv for weapon IDs)");
        }

        if (!(1 <= weaponid <= 46) || PlayerData[playerid][pWeapons][GetWeaponSlot(weaponid)] != weaponid)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You don't have that weapon. /guninv for a list of your weapons.");
        }

        new ammo = PlayerData[playerid][pAmmo][3];
        SetPVarInt(playerid, "activesling", weaponid);
        SetPVarInt(playerid, "activeslingammo", ammo);

        SetTimerEx("SlingTimerGiveWeapon", 1000, false, "i", playerid);
        RemovePlayerWeapon(playerid, weapon);

        SendClientMessageEx(playerid, COLOR_AQUA, "You have slung your %s around your back. (use /sling to retrieve the gun)", GetWeaponNameEx(weaponid));
        SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s slings their %s around their back, securing it to their body.", GetRPName(playerid), GetWeaponNameEx(weaponid));
    }

    return 1;
}

CMD:unsling(playerid, params[])
{
    if (PlayerData[playerid][pTazedTime] > 0 || PlayerData[playerid][pInjured] > 0 || PlayerData[playerid][pHospital] > 0 || PlayerData[playerid][pCuffed] > 0 || PlayerData[playerid][pTied] > 0 || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pPaintball] > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");
    }
    if (GetPVarInt(playerid, "GiveWeaponTimer") >= 1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY,  "   You must wait %d seconds before getting another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
    }
    if (IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
        return 1;
    }

    new activewep, ammo;
    activewep = GetPVarInt(playerid, "activesling");
    ammo = GetPVarInt(playerid, "activeslingammo");

    new weaponchoice[128];
    if (sscanf(params, "s[128]", weaponchoice))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /unsling [emote]");
        return 1;
    }

    if (activewep > 0)
    {
        new szWeapon[16];

        GetWeaponName(activewep, szWeapon, sizeof(szWeapon));
        GivePlayerWeaponEx(playerid, activewep, true);

        if (isnull(weaponchoice))
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "You have unslung the %s from your back.", szWeapon);
            SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s unslings a %s from their back.", GetRPName(playerid), szWeapon);
            DeletePVar(playerid, "activesling");
            DeletePVar(playerid, "activeslingammo");
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "You have unslung the %s from your back.", szWeapon);
            SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s %s", GetRPName(playerid), weaponchoice);
            DeletePVar(playerid, "activesling");
            DeletePVar(playerid, "activeslingammo");
        }

        DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
        PlayerData[playerid][aMeStatus] =0;
    }
    return 1;
}
//  CMD:ado(playerid, params[])
//  {
//      new activewep = GetPVarInt(playerid, "activesling");
//      new message[100], string[180];
//      if (sscanf(params, "s[100]", message))
//      {
//          SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ado [action]");
//          SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Set the action to OFF to remove the label.");
//          return 1;
//      }
//      if (activewep > 0)
//      {
//          SendClientMessageEx(playerid, COLOR_GREY, "  You have a weapon slung around your back, you can't use /ado.");
//          return 1;
//      }
//      if (strcmp(message, "off", true) == 0)
//      {
//          SendClientMessageEx(playerid, COLOR_GREY, "  You have removed the description label.");
//
//          DestroyDynamic3DTextLabel(PlayerData[playerid][aMeID]);
//          PlayerData[playerid][aMeStatus] =0;
//          return 1;
//      }
//      if (strlen(message) > 100) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too long, please reduce the length.");
//      if (strlen(message) < 3) return SendClientMessageEx(playerid, COLOR_GREY, "  The action is too short, please increase the length.");
//      if (PlayerData[playerid][aMeStatus] == 0)
//      {
//          PlayerData[playerid][aMeStatus] =1;
//
//          format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
//          SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//
//          PlayerData[playerid][aMeID] = CreateDynamic3DTextLabel(string, COLOR_PURPLE, 0.0, 0.0, 0.7, 20.0, playerid);
//          return 1;
//      }
//      else
//      {
//          format(string, sizeof(string), "* %s (( %s ))", message, GetRPName(playerid));
//          SendProximityMessage(playerid, 30.0, COLOR_PURPLE, string);
//
//          UpdateDynamic3DTextLabelText(PlayerData[playerid][aMeID], COLOR_PURPLE, string);
//          return 1;
//      }
//  }
