/// @file      GangTags.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-02-19 21:19:44 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

#define MAX_GRAFFITI_POINTS         200
#define TABLE_GRAFFITI              "graffiti"

static PlayerGraffiti[MAX_PLAYERS];
static PlayerGraffitiTime[MAX_PLAYERS];
static PlayerGraffitiText[MAX_PLAYERS][64];
static PlayerGraffitiEdit[MAX_PLAYERS];

static gang_tag_font[MAX_PLAYERS][50];
static gang_tag_chosen[MAX_PLAYERS];

enum graffitiData {
    graffitiID,
    graffitiExists,
    Float:graffitiPos[4],
    graffitiIcon,
    graffitiObject,
    graffitiColor,
    graffitiText[64],
    graffitiDefault,
    graffitiFont[50]
};

enum E_GRAFFITI_INFO
{
    Float:graffitiPosX,
    Float:graffitiPosY,
    Float:graffitiPosZ,
    Float:graffitiRotX,
    Float:graffitiRotY,
    Float:graffitiRotZ,
}

static GraffitiData[MAX_GRAFFITI_POINTS][graffitiData];

hook OnLoadDatabase(timestamp)
{
    DBQueryWithCallback("SELECT * FROM "#TABLE_GRAFFITI, "Graffiti_Load", "");
    return 1;
}

hook OnPlayerReset(playerid)
{
    PlayerGraffiti[playerid] = -1;
    PlayerGraffitiTime[playerid] = 0;
    return 1;
}

hook OnPlayerInit(playerid)
{
    PlayerGraffiti[playerid] = -1;
    PlayerGraffitiTime[playerid] = 0;
    PlayerGraffitiEdit[playerid] = -1;
    return 1;
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (response == EDIT_RESPONSE_FINAL)
    {
        new graffitiId = PlayerGraffitiEdit[playerid];
        if (graffitiId != -1 && GraffitiData[graffitiId][graffitiExists])
        {
            GraffitiData[graffitiId][graffitiPos][0] = x;
            GraffitiData[graffitiId][graffitiPos][1] = y;
            GraffitiData[graffitiId][graffitiPos][2] = z;
            GraffitiData[graffitiId][graffitiPos][3] = rz;
            if (GraffitiData[graffitiId][graffitiDefault])
            {
                GraffitiData[graffitiId][graffitiPos][3] = rz + 90.0;
            }
            else
            {
                GraffitiData[graffitiId][graffitiPos][3] = rz - 90.0;
            }

            Graffiti_Refresh(graffitiId);
            Graffiti_Save(graffitiId);
            PlayerGraffitiEdit[playerid] = -1;
        }
    }
    return 1;
}

Graffiti_Create(Float:x, Float:y, Float:z, Float:angle)
{
    for (new i = 0; i < MAX_GRAFFITI_POINTS; i ++)
    {
        if (!GraffitiData[i][graffitiExists])
        {
            GraffitiData[i][graffitiExists] = 1;
            GraffitiData[i][graffitiDefault] = 0;
            GraffitiData[i][graffitiPos][0] = x;
            GraffitiData[i][graffitiPos][1] = y;
            GraffitiData[i][graffitiPos][2] = z;
            GraffitiData[i][graffitiPos][3] = angle;
            GraffitiData[i][graffitiColor] = 0xFFFFFFFF;
            format(GraffitiData[i][graffitiText], 32, "Gang Tag");
            format(GraffitiData[i][graffitiFont], 50, "Arial");

            Graffiti_Refresh(i);
            DBQueryWithCallback("INSERT INTO "#TABLE_GRAFFITI" (graffitiColor) VALUES(0)", "OnGraffitiCreated", "d", i);
            return i;
        }
    }
    return -1;
}

DB:OnGraffitiCreated(id)
{
    GraffitiData[id][graffitiID] = GetDBInsertID();
    Graffiti_Save(id);
    return 1;
}

Graffiti_Refresh(id)
{
    if (id != -1 && GraffitiData[id][graffitiExists])
    {
        if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
        {
            DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);
        }
        new Float:x = GraffitiData[id][graffitiPos][0];
        new Float:y = GraffitiData[id][graffitiPos][1];
        new Float:z = GraffitiData[id][graffitiPos][2];
        new Float:a = GraffitiData[id][graffitiPos][3];
        GraffitiData[id][graffitiIcon] = CreateDynamicMapIcon(x, y, z, 23, 0, -1, -1, -1, 100.0, MAPICON_GLOBAL);

        if (GraffitiData[id][graffitiDefault])
        {
            if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
            {
                DestroyDynamicObject(GraffitiData[id][graffitiObject]);
            }
            GraffitiData[id][graffitiObject] = CreateDynamicObject(GraffitiData[id][graffitiDefault], x, y, z, 0.0, 0.0, a - 90.0);
        }
        else
        {
            if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
            {
                DestroyDynamicObject(GraffitiData[id][graffitiObject]);
            }
            GraffitiData[id][graffitiObject] = CreateDynamicObject(19482, x, y, z, 0.0, 0.0, a + 90.0);
            SetDynamicObjectMaterialText(GraffitiData[id][graffitiObject], 0, GraffitiData[id][graffitiText],
                                         OBJECT_MATERIAL_SIZE_256x128, GraffitiData[id][graffitiFont], 24, 1,
                                         GraffitiData[id][graffitiColor], 0, 0);
        }
    }
    return 1;
}

Graffiti_Save(id)
{
    DBQuery("UPDATE "#TABLE_GRAFFITI" SET graffitiX = '%.4f', graffitiY = '%.4f', graffitiZ = '%.4f', "\
            "graffitiAngle = '%.4f', graffitiDefault = '%d', graffitiColor = '%d', graffitiFont = '%e', "\
            "graffitiText = '%e' WHERE graffitiID = '%d'",
            GraffitiData[id][graffitiPos][0],
            GraffitiData[id][graffitiPos][1],
            GraffitiData[id][graffitiPos][2],
            GraffitiData[id][graffitiPos][3],
            GraffitiData[id][graffitiDefault],
            GraffitiData[id][graffitiColor],
            GraffitiData[id][graffitiFont],
            GraffitiData[id][graffitiText],
            GraffitiData[id][graffitiID]);
    return 1;
}

Graffiti_Delete(id)
{
    if (id != -1 && GraffitiData[id][graffitiExists])
    {
        if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
        {
            DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);
        }

        if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
        {
            DestroyDynamicObject(GraffitiData[id][graffitiObject]);
        }

        DBQuery("DELETE FROM "#TABLE_GRAFFITI" WHERE graffitiID = '%d'", GraffitiData[id][graffitiID]);


        GraffitiData[id][graffitiExists] = false;
        GraffitiData[id][graffitiText][0] = 0;
        GraffitiData[id][graffitiID] = 0;
    }
    return 1;
}

DB:Graffiti_Load()
{
    new rows = GetDBNumRows();

    for (new i = 0; i < rows; i ++)
    {
        if (i < MAX_GRAFFITI_POINTS)
        {
            GetDBStringField(i, "graffitiText", GraffitiData[i][graffitiText], 64);
            GetDBStringField(i, "graffitiFont", GraffitiData[i][graffitiFont], 50);

            GraffitiData[i][graffitiExists]  = 1;
            GraffitiData[i][graffitiID]      = GetDBIntField(i, "graffitiID");
            GraffitiData[i][graffitiPos][0]  = GetDBFloatField(i, "graffitiX");
            GraffitiData[i][graffitiPos][1]  = GetDBFloatField(i, "graffitiY");
            GraffitiData[i][graffitiPos][2]  = GetDBFloatField(i, "graffitiZ");
            GraffitiData[i][graffitiPos][3]  = GetDBFloatField(i, "graffitiAngle");
            GraffitiData[i][graffitiColor]   = GetDBIntField(i, "graffitiColor");
            GraffitiData[i][graffitiDefault] = GetDBIntField(i, "graffitiDefault");

            Graffiti_Refresh(i);
        }
    }
    return 1;
}

CMD:creategangtag(playerid, params[])
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendNoPermission(playerid);
    }

    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can only create graffiti points outside interiors.");
    }

    new id = -1, Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    id = Graffiti_Create(x, y, z, angle + 180.0);
    if (id == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "The server has reached the limit for graffiti points.");
    }

    EditDynamicObject(playerid, GraffitiData[id][graffitiObject]);

    PlayerGraffitiEdit[playerid] = id;
    SendClientMessageEx(playerid, COLOR_GREY, "You have successfully created graffiti ID: %d.", id);
    return 1;
}

CMD:removegangtag(playerid, params[])
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendNoPermission(playerid);
    }

    new id = 0;
    if (sscanf(params, "d", id))
    {
        return SendClientMessage(playerid, COLOR_GREY, "/removegraffiti [graffiti id]");
    }

    if ((id < 0 || id >= MAX_GRAFFITI_POINTS) || !GraffitiData[id][graffitiExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have specified an invalid graffiti ID.");
    }
    Graffiti_Delete(id);
    SendClientMessageEx(playerid, COLOR_GREY, "You have successfully removed graffiti ID: %d.", id);
    return 1;
}

CMD:editgangtag(playerid, params[])
{
    if (!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
        return SendNoPermission(playerid);
    }

    new id = GetNearbyGraffiti(playerid);
    if (id == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in range of an Gang Spray Tag point.");
    }

    EditDynamicObject(playerid, GraffitiData[id][graffitiObject]);
    PlayerGraffitiEdit[playerid] = id;
    return 1;
}


hook OnPlayerHeartBeat(playerid)
{
    if (PlayerGraffiti[playerid] != -1 && PlayerGraffitiTime[playerid] > 0)
    {
        if (GetNearbyGraffiti(playerid) != PlayerGraffiti[playerid])
        {
            PlayerGraffiti[playerid] = -1;
            PlayerGraffitiTime[playerid] = 0;
            return 1;
        }
        new gravffitiid = PlayerGraffiti[playerid];
        PlayerGraffitiTime[playerid]--;

        if (PlayerGraffitiTime[playerid] < 1)
        {

            if (gang_tag_chosen[playerid] != 0)
            {
                GraffitiData[gravffitiid][graffitiDefault] = gang_tag_chosen[playerid];
                gang_tag_chosen[playerid] = 0;

                Graffiti_Refresh(gravffitiid);
                Graffiti_Save(gravffitiid);

                ClearAnimations(playerid, 1);
                PlayerGraffiti[playerid] = -1;
                PlayerGraffitiTime[playerid] = 0;
                SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s puts their can of spray paint away.", GetRPName(playerid));
            }
            else
            {
                new str[64];
                strunpack(str, PlayerGraffitiText[playerid]);
                format(GraffitiData[gravffitiid][graffitiText], 64, str);
                format(GraffitiData[gravffitiid][graffitiFont], 50, "%s", gang_tag_font[playerid]);
                strreplace2(GraffitiData[gravffitiid][graffitiText], "(n)", "\n");
                GraffitiData[gravffitiid][graffitiDefault] = 0;
                GraffitiData[gravffitiid][graffitiColor] = GetGangColor(PlayerData[playerid][pGang]) | 0xFF000000; //ARGB

                Graffiti_Refresh(gravffitiid);
                Graffiti_Save(gravffitiid);

                ClearAnimations(playerid, 1);
                PlayerGraffiti[playerid] = -1;
                gang_tag_chosen[playerid] = 0;
                PlayerGraffitiTime[playerid] = 0;
                SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s puts their can of spray paint away.", GetRPName(playerid));
            }
        }

    }
    return 1;
}


GetNearbyGraffiti(playerid)
{
    for (new i = 0; i < sizeof(GraffitiData); i++)
    {
        if (GraffitiData[i][graffitiExists] && IsPlayerInRangeOfPoint(playerid, 4.0, GraffitiData[i][graffitiPos][0], GraffitiData[i][graffitiPos][1], GraffitiData[i][graffitiPos][2]))
        {
            return i;
        }
    }
    return -1;
}

IsSprayingInProgress(gangtagid)
{
    foreach (new i : Player)
    {
        if (PlayerGraffiti[i] == gangtagid && IsPlayerInRangeOfPoint(i, 5.0,
            GraffitiData[gangtagid][graffitiPos][0], GraffitiData[gangtagid][graffitiPos][1], GraffitiData[gangtagid][graffitiPos][2]))
        {
            return 1;
        }
    }
    return 0;
}

CMD:gotogangtag(playerid, params[])
{
    new gangtagid;

    if (!IsAdmin(playerid, ADMIN_LVL_6))
    {
        return SendUnauthorized(playerid);
    }
    if (!IsAdminOnDuty(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if (sscanf(params, "i", gangtagid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotogangtag [gangtagid]");
    }
    if (!(0 <= gangtagid < MAX_GRAFFITI_POINTS) || !GraffitiData[gangtagid][graffitiExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid gangtag.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, GraffitiData[gangtagid][graffitiPos][0], GraffitiData[gangtagid][graffitiPos][1], GraffitiData[gangtagid][graffitiPos][2]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:gspray(playerid, params[])
{
    new id = GetNearbyGraffiti(playerid);

    if (id == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near any graffiti point.");
    }
    if (IsSprayingInProgress(id))
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is another player spraying at this point already.");
    }
    if (PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
    }
    if (PlayerData[playerid][pGangRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 5 to tag a wall");
    }
    if (PlayerData[playerid][pSpraycans] <= 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
    }

    Dialog_Show(playerid, Graffiti_Type, DIALOG_STYLE_LIST, "Graffiti Style", "Default Gang Tags\nCustom Text", "Select", "Close");

    return 1;
}

Dialog:Graffiti_Type(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            Dialog_Show(playerid, Dialog_Tag_Default, DIALOG_STYLE_LIST, "Default Tag",
                        "Kilo Tray Ballas     \tPurple\n"\
                        "Temple Drive Ballas  \tPurple\n"\
                        "Front Yard Ballaz    \tPurple\n"\
                        "Rollin Heights Ballas\tPurple\n"\
                        "Temple Drive Ballas  \tPurple\n"\
                        "Seville BLVD Families\tGreen\n"\
                        "San Fiero Rifa       \tBlue\n"\
                        "Varrio Los Aztecas   \tOrange\n"\
                        "Varrio Los Aztecas   \tOrange\n"\
                        "Los Santos Vagos     \tOrange", "Select", "Cancel");
        }
        if (listitem == 1)
        {
            Dialog_Show(playerid, Dialog_Tag_Font, DIALOG_STYLE_LIST, "Chose a font!", "Arial\nDiploma\nCourier\nImpact\nPricedown\nDaredevil\nBombing\naaaiight! fat\nFrom Street Art\nGhang\nGraffogie\nGraphers Blog\nNosegrind Demo", "Select", "Cancel");
        }
    }
    return 1;
}

Dialog:Dialog_Tag_Default(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: { gang_tag_chosen[playerid] = 18662; }
            case 1: { gang_tag_chosen[playerid] = 1529;  }
            case 2: { gang_tag_chosen[playerid] = 18666; }
            case 3: { gang_tag_chosen[playerid] = 18667; }
            case 4: { gang_tag_chosen[playerid] = 18664; }
            case 5: { gang_tag_chosen[playerid] = 18660; }
            case 6: { gang_tag_chosen[playerid] = 18663; }
            case 7: { gang_tag_chosen[playerid] = 1531;  }
            case 8: { gang_tag_chosen[playerid] = 18661; }
            case 9: { gang_tag_chosen[playerid] = 18665; }
            default: return 1;
        }

        PlayerData[playerid][pSpraycans] -= 1;
        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);

        PlayerGraffiti[playerid] = GetNearbyGraffiti(playerid);
        PlayerGraffitiTime[playerid] = 15;
        PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
        SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
        SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
    }
    return 1;
}

Dialog:Dialog_Tag_Font(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        format(gang_tag_font[playerid], 50, inputtext);
        Dialog_Show(playerid, Graffiti_Text, DIALOG_STYLE_INPUT, "Graffiti Text", "Please enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters.", "Submit", "Cancel");
    }
    return 1;
}

Dialog:Graffiti_Text(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new id = GetNearbyGraffiti(playerid);

        if (id == -1)
            return 0;

        if (isnull(inputtext))
        {
            return Dialog_Show(playerid, Graffiti_Text, DIALOG_STYLE_INPUT, "Graffiti Text", "Please enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters.", "Submit", "Cancel");
        }
        if (strlen(inputtext) > 64)
        {
            return Dialog_Show(playerid, Graffiti_Text, DIALOG_STYLE_INPUT, "Graffiti Text", "Error: Your input can't exceed 64 characters.\n\nPlease enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters.", "Submit", "Cancel");
        }
        if (IsSprayingInProgress(id))
        {
            return SendClientMessage(playerid, COLOR_GREY, "There is another player spraying at this point already.");
        }

        PlayerData[playerid][pSpraycans] -= 1;
        DBQuery("UPDATE "#TABLE_USERS" SET spraycans = %i WHERE uid = %i", PlayerData[playerid][pSpraycans], PlayerData[playerid][pID]);

        PlayerGraffiti[playerid] = id;
        PlayerGraffitiTime[playerid] = 15;
        strpack(PlayerGraffitiText[playerid], inputtext, 64);

        PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
        SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
        SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
    }
    return 1;
}
