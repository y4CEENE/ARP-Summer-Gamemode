/*
	Boxville System
	Author: Tr0Y


*/
#include <YSI\y_hooks>

#define BOXVILLE_MODEL 498

enum E_GANGBOXVILLE
{
    gbVehicle,
    Float:gbX,
    Float:gbY,
    Float:gbZ,
    Float:gbA,
    CrateLoaded,
    Securing
};
new GangBoxville[MAX_GANGS][E_GANGBOXVILLE];

hook OnGameModeInit()
{
    new query[256];
    format(query, sizeof query,
        "CREATE TABLE IF NOT EXISTS gangs_boxville(\
        id INT AUTO_INCREMENT PRIMARY KEY,\
        gang_id INT UNIQUE NOT NULL,\
        modelid INT NOT NULL,\
        color1 INT NOT NULL,\
        color2 INT NOT NULL,\
        x FLOAT NOT NULL,\
        y FLOAT NOT NULL,\
        z FLOAT NOT NULL,\
        angle FLOAT NOT NULL\
        ) ENGINE=InnoDB;"
    );
    mysql_tquery(connectionID, query);

    mysql_tquery(connectionID, "SELECT * FROM gangs_boxville", "LoadGangBoxvilles");
    return 1;
}

forward LoadGangBoxvilles();
public LoadGangBoxvilles()
{
    new rows, fields;
    cache_get_data(rows, fields);

    for(new i; i < rows; i++)
    {
        new gangid = cache_get_field_content_int(i, "gang_id");
        new modelid = cache_get_field_content_int(i, "modelid");
        new color1 = cache_get_field_content_int(i, "color1");
        new color2 = cache_get_field_content_int(i, "color2");

        GangBoxville[gangid][gbX] = cache_get_field_content_float(i, "x");
        GangBoxville[gangid][gbY] = cache_get_field_content_float(i, "y");
        GangBoxville[gangid][gbZ] = cache_get_field_content_float(i, "z");
        GangBoxville[gangid][gbA] = cache_get_field_content_float(i, "angle");

        GangBoxville[gangid][CrateLoaded] = 0;
        GangBoxville[gangid][Securing] = false;

        GangBoxville[gangid][gbVehicle] = CreateVehicle(modelid, GangBoxville[gangid][gbX], GangBoxville[gangid][gbY], GangBoxville[gangid][gbZ], GangBoxville[gangid][gbA], color1, color2, -1);

		new label[64], color = GangInfo[gangid][gColor];
		format(label, sizeof label, "{%06x}%s's\nBoxville", color >>> 8, GangInfo[gangid][gName]);
		CreateDynamic3DTextLabel(label, -1, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, GangBoxville[gangid][gbVehicle], 1);
    }
    return 1;
}

CMD:setupbv(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
        return SendClientErrorUnauthorizedCmd(playerid);

    new gangid = PlayerData[playerid][pGang];
    if(gangid == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a gang.");

    new color1, color2;
    if(sscanf(params, "ii", color1, color2))
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /setupbv [color 1] [color 2]");

    if(IsValidVehicle(GangBoxville[gangid][gbVehicle]))
        return SendClientMessage(playerid, COLOR_GREY, "Your gang already has a Boxville! Use /removeboxville to delete it first.");

    GetPlayerPos(playerid, GangBoxville[gangid][gbX], GangBoxville[gangid][gbY], GangBoxville[gangid][gbZ]);
    GetPlayerFacingAngle(playerid, GangBoxville[gangid][gbA]);

    GangBoxville[gangid][gbVehicle] = CreateVehicle(BOXVILLE_MODEL, GangBoxville[gangid][gbX], GangBoxville[gangid][gbY], GangBoxville[gangid][gbZ], GangBoxville[gangid][gbA], color1, color2, -1);

    GangBoxville[gangid][CrateLoaded] = 0;
    GangBoxville[gangid][Securing] = false;

	new label[64], color = GangInfo[gangid][gColor];
	format(label, sizeof label, "{%06x}%s's\nBoxville", color >>> 8, GangInfo[gangid][gName]);

	CreateDynamic3DTextLabel(label, -1, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, GangBoxville[gangid][gbVehicle], 1);

    new query[512];
    format(query, sizeof query,
        "INSERT INTO gangs_boxville (gang_id, modelid, color1, color2, x, y, z, angle) VALUES (%d, %d, %d, %d, %f, %f, %f, %f) \
        ON DUPLICATE KEY UPDATE modelid=%d, color1=%d, color2=%d, x=%f, y=%f, z=%f, angle=%f",
        gangid, BOXVILLE_MODEL, color1, color2,
        GangBoxville[gangid][gbX], GangBoxville[gangid][gbY], GangBoxville[gangid][gbZ], GangBoxville[gangid][gbA],
        BOXVILLE_MODEL, color1, color2,
        GangBoxville[gangid][gbX], GangBoxville[gangid][gbY], GangBoxville[gangid][gbZ], GangBoxville[gangid][gbA]
    );
    mysql_tquery(connectionID, query);

    SendClientMessageEx(playerid, COLOR_AQUA, "%s's boxville has been setup successfully!", GangInfo[gangid][gName]);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has setup a new boxville for %s.", GetRPName(playerid), GangInfo[gangid][gName]);
    return 1;
}

CMD:removeboxville(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
        return SendClientErrorUnauthorizedCmd(playerid);

    new gangid = PlayerData[playerid][pGang];
    if(gangid == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a gang.");

    if(!IsValidVehicle(GangBoxville[gangid][gbVehicle]))
        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have a boxville set up.");

    DestroyVehicle(GangBoxville[gangid][gbVehicle]);
    GangBoxville[gangid][gbVehicle] = INVALID_VEHICLE_ID;

    new query[128];
    format(query, sizeof query, "DELETE FROM gangs_boxville WHERE gang_id=%d", gangid);
    mysql_tquery(connectionID, query);

    SendClientMessageEx(playerid, COLOR_RED, "%s's boxville has been removed.", GangInfo[gangid][gName]);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s removed the boxville for %s.", GetRPName(playerid), GangInfo[gangid][gName]);
    return 1;
}

CMD:reloadboxville(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];

    if (gangid == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not in a gang.");

    if (PlayerData[playerid][pGangRank] < 5)
        return SendClientMessage(playerid, COLOR_GREY, "You must be rank +5 in order to use this command.");

    if (!IsValidVehicle(GangBoxville[gangid][gbVehicle]))
        return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have a boxville.");

    new query[128];
    format(query, sizeof query, "SELECT * FROM gangs_boxville WHERE gang_id=%d LIMIT 1", gangid);
    mysql_tquery(connectionID, query, "ReloadGangBoxville", "d", playerid);
    return 1;
}

forward ReloadGangBoxville(playerid);
public ReloadGangBoxville(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);
    
    if (!rows)  return SendClientMessage(playerid, COLOR_GREY, "Your gang doesn't have a boxville in the database, contact GangMod.");

    new gangid = PlayerData[playerid][pGang];

    new modelid = cache_get_field_content_int(0, "modelid");
    new color1 = cache_get_field_content_int(0, "color1");
    new color2 = cache_get_field_content_int(0, "color2");

    GangBoxville[gangid][gbX] = cache_get_field_content_float(0, "x");
    GangBoxville[gangid][gbY] = cache_get_field_content_float(0, "y");
    GangBoxville[gangid][gbZ] = cache_get_field_content_float(0, "z");
    GangBoxville[gangid][gbA] = cache_get_field_content_float(0, "angle");

    if (IsValidVehicle(GangBoxville[gangid][gbVehicle]))
        DestroyVehicle(GangBoxville[gangid][gbVehicle]);

    GangBoxville[gangid][gbVehicle] = CreateVehicle(modelid,GangBoxville[gangid][gbX],GangBoxville[gangid][gbY],GangBoxville[gangid][gbZ],GangBoxville[gangid][gbA],color1, color2, -1);

	new label[64], color = GangInfo[gangid][gColor];
	format(label, sizeof label, "{%06x}%s's\nBoxville", color >>> 8, GangInfo[gangid][gName]);

	CreateDynamic3DTextLabel(label, -1, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, GangBoxville[gangid][gbVehicle], 1);

    SendClientMessage(playerid, COLOR_AQUA, "You have reloaded your gang boxville successfully.");
	SendAdminWarning(1, "%s[%i] has reloaded his gang boxville.", GetRPName(playerid), playerid);
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	for(new g = 0; g < MAX_GANGS; g++)
	{
		if(GangBoxville[g][gbVehicle] == vehicleid)
		{
			if(PlayerData[playerid][pGang] != g)
			{
				SendErrorMessage(playerid, "You can't enter this vehicle");
				ClearAnimations(playerid);
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
			else 
			{
                if(!TrainData[Active])
				{
				    if(GangBoxville[g][CrateLoaded] > 0) return 1;
					ClearAnimations(playerid);
					RemovePlayerFromVehicle(playerid);
	  				SendClientMessage(playerid, COLOR_GREY, "You can use this vehicle only if the train is active.");
				}
			}
		}
	}
	return 1;
}

hook OV_DamageStatusUpdate(vehicleid, playerid)
{
	for(new g = 0; g < MAX_GANGS; g++)
	{
		if(vehicleid == GangBoxville[g][gbVehicle])
		{
			SetVehicleHealth(vehicleid, 1000.0);
			return 1;
		}
	}
	return 1;
}
