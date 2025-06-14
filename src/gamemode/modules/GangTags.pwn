#include <YSI\y_hooks>
//TODO: /nearest
#define MAX_GRAFFITI_POINTS         200
#define TABLE_GRAFFITI              "graffiti"

static PlayerGraffiti[MAX_PLAYERS];
static PlayerGraffitiTime[MAX_PLAYERS];
static PlayerGraffitiText[MAX_PLAYERS][64 char];
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
	mysql_tquery(connectionID, "SELECT * FROM "#TABLE_GRAFFITI, "db_Graffiti_Load", "");
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
	if(response == EDIT_RESPONSE_FINAL)
	{
	    if (PlayerGraffitiEdit[playerid] != -1 && GraffitiData[PlayerGraffitiEdit[playerid]][graffitiExists])
	    {
			GraffitiData[PlayerGraffitiEdit[playerid]][graffitiPos][0] = x;
			GraffitiData[PlayerGraffitiEdit[playerid]][graffitiPos][1] = y;
			GraffitiData[PlayerGraffitiEdit[playerid]][graffitiPos][2] = z;
			GraffitiData[PlayerGraffitiEdit[playerid]][graffitiPos][3] = rz;

			Graffiti_Refresh(PlayerGraffitiEdit[playerid]);
			Graffiti_Save(PlayerGraffitiEdit[playerid]);
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
			GraffitiData[i][graffitiPos][0] = x;
			GraffitiData[i][graffitiPos][1] = y;
			GraffitiData[i][graffitiPos][2] = z;
			GraffitiData[i][graffitiPos][3] = angle - 90.0;
			GraffitiData[i][graffitiColor] = 0xFFFFFFFF;
			format(GraffitiData[i][graffitiText], 32, "Graffiti");

			Graffiti_Refresh(i);
			mysql_tquery(connectionID, "INSERT INTO "#TABLE_GRAFFITI" (graffitiColor) VALUES(0)", "db_OnGraffitiCreated", "d", i);

			return i;
		}
	}
	return -1;
}

DB:OnGraffitiCreated(id)
{
	GraffitiData[id][graffitiID] = cache_insert_id(connectionID);
	Graffiti_Save(id);
	return 1;
}

Graffiti_Refresh(id)
{
	if (id != -1 && GraffitiData[id][graffitiExists])
	{
		if(GraffitiData[id][graffitiDefault])
		{
 			if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
			{
				DestroyDynamicObject(GraffitiData[id][graffitiObject]);
			}
		 	GraffitiData[id][graffitiObject] = CreateDynamicObject(GraffitiData[id][graffitiDefault], GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 0.0, 0.0, GraffitiData[id][graffitiPos][3]);
		}
		else
		{
			if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
			{
			    DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);
			}

			if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
			{
				DestroyDynamicObject(GraffitiData[id][graffitiObject]);
			}

	        GraffitiData[id][graffitiIcon] = CreateDynamicMapIcon(GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 23, 0, -1, -1, -1, 100.0, MAPICON_GLOBAL);
			GraffitiData[id][graffitiObject] = CreateDynamicObject(19482, GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 0.0, 0.0, GraffitiData[id][graffitiPos][3]);

			SetDynamicObjectMaterial(GraffitiData[id][graffitiObject], 0, 0, "none", "none", 0);
			SetDynamicObjectMaterialText(GraffitiData[id][graffitiObject], 0, GraffitiData[id][graffitiText], OBJECT_MATERIAL_SIZE_256x128, GraffitiData[id][graffitiFont], 24, 1, GraffitiData[id][graffitiColor], 0, 0);	
		}
	}
	return 1;
}

Graffiti_Save(id)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "#TABLE_GRAFFITI" SET graffitiX = '%.4f', graffitiY = '%.4f',\
		graffitiZ = '%.4f', graffitiAngle = '%.4f', graffitiDefault = '%d', graffitiColor = '%d', graffitiFont = '%e', graffitiText = '%e' WHERE graffitiID = '%d'",
        GraffitiData[id][graffitiPos][0],
        GraffitiData[id][graffitiPos][1],
        GraffitiData[id][graffitiPos][2],
        GraffitiData[id][graffitiPos][3],
        GraffitiData[id][graffitiDefault],
		GraffitiData[id][graffitiColor],
  		MySqlEscape(GraffitiData[id][graffitiFont]),
		MySqlEscape(GraffitiData[id][graffitiText]),
		GraffitiData[id][graffitiID]);
	return mysql_tquery(connectionID, queryBuffer);
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

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM "#TABLE_GRAFFITI" WHERE graffitiID = '%d'", GraffitiData[id][graffitiID]);
		mysql_tquery(connectionID, queryBuffer);

		GraffitiData[id][graffitiExists] = false;
		GraffitiData[id][graffitiText][0] = 0;
		GraffitiData[id][graffitiID] = 0;
	}
	return 1;
}

DB:Graffiti_Load()
{
	new rows, fields;

	cache_get_data(rows, fields, connectionID);

	for (new i = 0; i < rows; i ++) if (i < MAX_GRAFFITI_POINTS)
	{
	    cache_get_field_content(i, "graffitiText", GraffitiData[i][graffitiText], connectionID, 64);

    	GraffitiData[i][graffitiExists] = 1;
	    GraffitiData[i][graffitiID] = cache_get_field_content_int(i, "graffitiID");
	    GraffitiData[i][graffitiPos][0] = cache_get_field_content_float(i, "graffitiX");
	    GraffitiData[i][graffitiPos][1] = cache_get_field_content_float(i, "graffitiY");
	    GraffitiData[i][graffitiPos][2] = cache_get_field_content_float(i, "graffitiZ");
	    GraffitiData[i][graffitiPos][3] = cache_get_field_content_float(i, "graffitiAngle");
	    GraffitiData[i][graffitiColor] = cache_get_field_content_int(i, "graffitiColor");

		Graffiti_Refresh(i);
	}
	return 1;
}

CMD:creategangtag(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
	    return SendClientErrorNoPermission(playerid);
	}

	if(GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	{
 		return SendClientMessage(playerid, COLOR_GREY, "You can only create graffiti points outside interiors.");
	}

	new id = -1, Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	id = Graffiti_Create(x, y, z, angle);

	if(id == -1)
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
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
	    return SendClientErrorNoPermission(playerid);
	}

	new id = 0;
	if(sscanf(params, "d", id))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "/removegraffiti [graffiti id]");
	}

	if((id < 0 || id >= MAX_GRAFFITI_POINTS) || !GraffitiData[id][graffitiExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You have specified an invalid graffiti ID.");
	}
	Graffiti_Delete(id);
	SendClientMessageEx(playerid, COLOR_GREY, "You have successfully removed graffiti ID: %d.", id);
	return 1;
}

CMD:editgangtag(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
    {
	    return SendClientErrorNoPermission(playerid);
	}

	new id = -1, Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	id = Graffiti_Nearest(playerid);

	if(id == -1)
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
		if (Graffiti_Nearest(playerid) != PlayerGraffiti[playerid])
		{
			PlayerGraffiti[playerid] = -1;
			PlayerGraffitiTime[playerid] = 0;
			return 1;
		}
		new gravffitiid = PlayerGraffiti[playerid];
		PlayerGraffitiTime[playerid]--;

		if (PlayerGraffitiTime[playerid] < 1)
		{

			if(gang_tag_chosen[playerid] != 0)
			{
				new Float:x, Float:y, Float:z, Float:a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				GraffitiData[gravffitiid][graffitiPos][3] = a + 90.0;
				GraffitiData[gravffitiid][graffitiDefault] = gang_tag_chosen[playerid];
				gang_tag_chosen[playerid] = 0;
				Graffiti_Refresh(gravffitiid);
				Graffiti_Save(gravffitiid);
				ClearAnimations(playerid, 1);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s puts their can of spray paint away.", GetRPName(playerid));
				PlayerGraffiti[playerid] = -1;
				PlayerGraffitiTime[playerid] = 0;
			}
			else
			{
				new str[500];
				new Float:x, Float:y, Float:z, Float:a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				strunpack(str, PlayerGraffitiText[playerid]);
				format(GraffitiData[gravffitiid][graffitiText], 64, str);
				format(GraffitiData[gravffitiid][graffitiFont], 50, "%s", gang_tag_font[playerid]);

				GraffitiData[gravffitiid][graffitiPos][3] = a - 90.0;
				strreplace2(GraffitiData[gravffitiid][graffitiText], "(n)", "\n");
				GraffitiData[gravffitiid][graffitiDefault] = 0;
				gang_tag_chosen[playerid] = 0;
				GraffitiData[gravffitiid][graffitiColor] = GangInfo[PlayerData[playerid][pGang]][gColor] | 0xFF;
				Graffiti_Refresh(gravffitiid);
				Graffiti_Save(gravffitiid);
				ClearAnimations(playerid, 1);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s puts their can of spray paint away.", GetRPName(playerid));
				PlayerGraffiti[playerid] = -1;
				PlayerGraffitiTime[playerid] = 0;
			}
		}
	
	}
	return 1;
}


Graffiti_Nearest(playerid)
{
	for(new i = 0; i < sizeof(GraffitiData); i++)
	{
		if(GraffitiData[i][graffitiExists] && IsPlayerInRangeOfPoint(playerid, 4.0, GraffitiData[i][graffitiPos][0], GraffitiData[i][graffitiPos][1], GraffitiData[i][graffitiPos][2]))
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
//OK

/*

static g_aGraffitiData[][E_GRAFFITI_INFO] = {
	{2081.867675, -1255.466430, 24.712007, -12.800003, 0.000000, 0.000000},
	{2268.340332, -1031.824707, 53.437198, 0.000000, 0.000000, 135.800155},
	{2652.655517, -1123.089355, 66.999664, 0.000000, 0.000000, 0.399999},
	{2652.727294, -1268.601074, 50.095500, 0.000000, 0.000000, 0.000000},
	{2441.024169, -1215.926757, 32.154163, 0.000000, 0.000000, -179.199768},
	{2352.000488, -1262.450927, 22.958444, 0.000000, 0.000000, 0.000000},
	{2195.268554, -1745.694580, 13.739686, 0.000000, 0.000000, -177.399734},
	{1868.005493, -2038.964843, 15.976880, 0.000000, 0.000000, 179.700088},
	{1832.987426, -2111.634033, 13.946876, 0.000000, 0.000000, 0.000000},
	{1862.723510, -2095.458007, 13.890580, 0.000000, 0.000000, 89.700012},
	{2097.205566, -1258.445434, 24.748823, -16.799999, 0.000000, 87.999984},
	{2135.333984, -1820.317871, 13.748497, 0.000000, 0.000000, 0.000000},
	{2171.669921, -1709.278564, 15.921793, -8.500000, 0.000000, 179.999969},
	{2112.414794, -1500.848632, 11.099428, 0.000000, 0.000000, -109.899978},
	{2129.287841, -1374.363769, 25.878126, 0.000000, 0.000000, 90.400009},
	{2110.260253, -1352.890625, 25.076538, 9.399998, -0.699999, -179.799743},
	{2052.904296, -1322.635498, 24.954380, 0.000000, 0.000000, 179.800018},
	{2159.781494, -1693.122314, 16.025939, 0.000000, 0.000000, -179.099990},
	{2146.816650, -1698.676025, 15.438446, 0.000000, 0.000000, 91.499877},
	{2175.154052, -1732.381713, 14.535001, 0.000000, 0.000000, -178.500061},
	{2231.739501, -1683.644775, 15.479531, 0.000000, 0.000000, -16.500001},
	{2121.155029, -1594.672729, 15.621557, 0.000000, 0.000000, 86.900100},
	{2123.272705, -1593.691284, 15.241566, 0.000000, 0.000000, -179.499893},
	{2112.329345, -1632.425170, 13.739908, 0.000000, -3.200001, -89.700065},
	{2081.344970, -1592.929809, 14.757192, 0.000000, 0.000000, 179.300003},
	{2073.782470, -1597.242553, 14.414111, 0.000000, 0.000000, 90.300033},
	{2031.132568, -1599.088867, 13.910934, 0.000000, 0.000000, -168.799987},
	{2478.406982, -1705.506347, 13.490673, 0.000000, 0.000000, 176.799804},
	{2478.767578, -1688.184936, 13.487812, 0.000000, 0.000000, -98.600006},
	{2520.675781, -1673.658447, 15.454930, 0.000000, 0.000000, 0.000000},
	{2534.723388, -1665.125732, 15.735736, 0.000000, 0.000000, -178.699966},
	{2431.231689, -1680.935424, 14.411346, 0.000000, 0.000000, -90.199958},
	{2398.518066, -1693.246948, 13.891834, 0.000000, 0.000000, 87.599990},
	{2377.614990, -1707.240112, 14.127936, 0.000000, 0.000000, 0.000000},
	{2440.530517, -1997.948486, 14.406878, 0.000000, 0.000000, 89.199966}, // Willowfield red wall
	{2459.481933, -1975.134521, 14.166885, 0.000000, 0.000000, 0.000000}, // Willowfield alley
	{2459.608642, -2043.951049, 11.091508, 0.000000, 0.000000, 88.000068}, // Willowfield sewer
	{1958.593139, -1742.345336, 13.856878, 0.000000, 0.000000, 90.700050}, // Idlegas [Artsy]
	{1951.642700, -1682.986083, 13.822822, 0.000000, 0.000000, 0.000000}, // North of Idlegas [Artsy],
	{1991.694580, -1683.518676, 13.636877, 0.000000, 0.000000, 178.599838}, // West 4-1-5 [Artsy],
	{2135.621582, -1258.083496, 24.192192, 0.000000, 0.000000, 90.099929} // Jefferson Alley [Fireworks]
};
hook OnLoadGameMode(timestamp)
{
	for (new i = 0; i < sizeof(g_aGraffitiData); i++)
	{ //18666
		GraffitiData[i][graffitiObject] = CreateDynamicObject(18666, g_aGraffitiData[i][graffitiPosX], g_aGraffitiData[i][graffitiPosY], g_aGraffitiData[i][graffitiPosZ], g_aGraffitiData[i][graffitiRotX], g_aGraffitiData[i][graffitiRotY], g_aGraffitiData[i][graffitiRotZ], -1, 0, -1, 5000.0);
	}
	return 1;
}*/



CMD:gotogangtag(playerid, params[])
{
	new gangtagid;

	if(PlayerData[playerid][pAdmin] < HEAD_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!PlayerData[playerid][pAdminDuty] && PlayerData[playerid][pAdmin] < GENERAL_MANAGER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "i", gangtagid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotogangtag [gangtagid]");
	}
	if(!(0 <= gangtagid < MAX_GRAFFITI_POINTS) || !GraffitiData[gangtagid][graffitiExists])
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
	new id = Graffiti_Nearest(playerid);

	if (id == -1)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not near any graffiti point.");
	}
    if (IsSprayingInProgress(id))
    {
        return SendClientMessage(playerid, COLOR_GREY, "There is another player spraying at this point already.");
	}
	if(PlayerData[playerid][pGang] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");
	}
	if(PlayerData[playerid][pGangRank] < 5)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You must be at least rank 5 to tag a wall");
	}
	if(PlayerData[playerid][pSpraycans] <= 0)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You don't have enough spraycans for this.");
	}

	Dialog_Show(playerid, Graffiti_Type, DIALOG_STYLE_LIST, "Graffiti Style", "Default Gang Tags\nCustom Text", "Select", "Close");

	return 1;
}

Dialog:Graffiti_Type(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			Dialog_Show(playerid, Dialog_Tag_Default, DIALOG_STYLE_LIST, "Default Tag", "Pink graffiti Temple Drive Ballas\nOrange graffiti Varrio loz aztecas\nDark green graffiti Seville BLVD\nOrange graffiti Varrio Los Aztecas\nPurple graffiti Kilo tray Ballas\nPurple graffiti San Fiero Rifa\nDark green graffiti Los Santos Vagos\nPurple graffiti Front Yard Ballaz\nPink graffiti Rollin Heights Ballas\nDark blue Temple drive Ballas", "Select", "Cancel");
		}
		if(listitem == 1)
		{
			Dialog_Show(playerid, Dialog_Tag_Font, DIALOG_STYLE_LIST, "Chose a font!", "Arial\nDiploma\nCourier\nImpact\nPricedown\nDaredevil\nBombing\naaaiight! fat\nFrom Street Art\nGhang\nGraffogie\nGraphers Blog\nNosegrind Demo", "Select", "Cancel");
		}
	}
	return 1;
}

Dialog:Dialog_Tag_Default(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = Graffiti_Nearest(playerid);
	    switch(listitem)
	    {
			case 0:
			{
			    gang_tag_chosen[playerid] = 1529;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 1:
			{
			    gang_tag_chosen[playerid] = 1531;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));

			}
			case 2:
			{
			    gang_tag_chosen[playerid] = 18660;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 3:
			{
			    gang_tag_chosen[playerid] = 18661;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 4:
			{
			    gang_tag_chosen[playerid] = 18662;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
   		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 5:
			{
			    gang_tag_chosen[playerid] = 18663;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
   		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 6:
			{
			    gang_tag_chosen[playerid] = 18665;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
   		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 7:
			{
			    gang_tag_chosen[playerid] = 18666;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
   		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 8:
			{
			    gang_tag_chosen[playerid] = 18667;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
   		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
			case 9:
			{
			    gang_tag_chosen[playerid] = 18664;
			    SendClientMessageEx(playerid, -1, "You've chose %s", inputtext);
   		        PlayerGraffiti[playerid] = id;
		        PlayerGraffitiTime[playerid] = 15;
				PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
				SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
				SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
			}
	    }
	}
	return 1;
}

Dialog:Dialog_Tag_Font(playerid, response, listitem, inputtext[])
{
	if(response)
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
	    new id = Graffiti_Nearest(playerid);

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
        PlayerGraffiti[playerid] = id;
        PlayerGraffitiTime[playerid] = 15;
		strpack(PlayerGraffitiText[playerid], inputtext, 64 char);

		PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0);
		SendAdminMessage(COLOR_LIGHTRED, "%s[ID %i] has started spraying a gang tag %s", GetRPName(playerid), playerid, inputtext);
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);
		SendProximityMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a can of spray paint and sprays the wall.", GetRPName(playerid));
	}
	return 1;
}

