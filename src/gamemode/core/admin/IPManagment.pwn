#include <YSI\y_hooks>
/*
	Credits: Whitetiger, RaekwonDaChef, Y_Less, Andreas Gohr.
	
	MaxMind, GeoIP and related marks are registered trademarks of MaxMind, Inc.
 */
 
static DB:geoip_db;
static DB:geoip_city;
static DBResult:_result;
static g_iBackwardsCompat;

GetIPCountry(ip[], dest[], const len = sizeof(dest)) 
{
	new tmp = IPToInt(ip);
    	
	new string[500];
	
	geoip_db = db_open(GetGeoIPMainFile());

	if(g_iBackwardsCompat == 1) {
	    format(string, sizeof(string), "SELECT cn FROM ip_country WHERE idx >= (%d-(%d %% 65536)) AND ip_to >= %d AND  ip_from < %d LIMIT 1", tmp, tmp, tmp, tmp);
	} else {
		format(string, sizeof(string), "SELECT loc.*\n FROM loc_country loc,\n blocks_country blk\n WHERE blk.idx >= (%d-(%d %% 65536))\n AND blk.startIpNum < %d\n AND blk.endIpNum > %d\n AND loc.locId = blk.locId LIMIT 1;", tmp, tmp, tmp, tmp);
	}

    _result = db_query(geoip_db, string);
    if(db_num_rows(_result) >= 1)
    {
  		db_get_field_assoc(_result,"cn",dest,len);
    }
    db_free_result(_result);
	db_close(geoip_db);
	
	if(!strlen(dest)) format(dest, len, "Unknown");
	
	return true;
}

GetIPISP(ip[], dest[], const len = sizeof(dest))
{

	new tmp = IPToInt(ip);
	
	new string[500];
	format(string, sizeof(string), "SELECT internet_service_provider FROM geo_isp WHERE idx >= (%d-(%d %% 65536)) AND ip_to >= %d AND  ip_from < %d LIMIT 1", tmp, tmp, tmp, tmp);

	geoip_db = db_open(GetGeoIPMainFile());
    _result = db_query(geoip_db, string);
    if(db_num_rows(_result) >= 1)
    {
        db_get_field_assoc(_result,"internet_service_provider",dest,len);
    }
    db_free_result(_result);
	db_close(geoip_db);
	
	if(!strlen(dest)) format(dest, len, "Unknown");

	return true;
}

GetIPCity(ip[], dest[], const len = sizeof(dest))
{
	new tmp = IPToInt(ip);
	
	new string[500];
	format(string, sizeof(string), "SELECT loc.*\n FROM geolocation loc,\n geoblocks blk\n WHERE blk.idx = (%d-(%d %% 65536))\n AND blk.startIpNum < %d\n AND blk.endIpNum > %d\n AND loc.locId = blk.locId LIMIT 1;", tmp, tmp, tmp, tmp);

	geoip_city = db_open(GetGeoIPCity());
    _result = db_query(geoip_city, string);
    if(db_num_rows(_result) >= 1)
    {
        db_get_field_assoc(_result,"city",dest,len);
    }
    db_free_result(_result);
	db_close(geoip_city);
	
	if(!strlen(dest)) format(dest, len, "Unknown");
	
	return true;
}

GetIPGMT(ip[])
{
	new tmp = IPToInt(ip);
	
	new dest[50];
	
	new string[500];
	format(string, sizeof(string), "SELECT blk.*, loc.longitude\n FROM geolocation loc,\n geoblocks blk\n WHERE blk.idx = (%d-(%d %% 65536))\n AND blk.startIpNum < %d\n AND blk.endIpNum > %d\n AND loc.locId = blk.locId LIMIT 1;", tmp, tmp, tmp, tmp);

	geoip_city = db_open(GetGeoIPCity());
    _result = db_query(geoip_city, string);
    if(db_num_rows(_result) >= 1)
    {
        db_get_field_assoc(_result, "longitude", dest, sizeof(dest));
    }
    db_free_result(_result);
	db_close(geoip_city);
	
	if(!strlen(dest)) format(dest, sizeof(dest), "Unknown");
	
	return floatround( strval( dest ) / 15 );
}

hook OnLoadGameMode(timestamp)
{
	geoip_db = db_open(GetGeoIPMainFile());
    _result = db_query(geoip_db, "SELECT name FROM sqlite_master WHERE type='table' AND name='ip_country'");

    if(db_num_rows(_result) >= 1)
    {
        g_iBackwardsCompat = 1;
    }
    else
    {
        g_iBackwardsCompat = 0;
    }
    db_free_result(_result);
	db_close(geoip_db);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    
    new  ip[24], country[64];
	GetPlayerIp(playerid, ip, sizeof(ip));
	GetIPCountry(ip, country, 64);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM banned_countries WHERE country = '%e'", country);
	mysql_tquery(connectionID, queryBuffer, "OnBanCountryCheck", "i", playerid);
    return 1;
}

publish OnBanCountryCheck(playerid)
{

	new rows = cache_get_row_count(connectionID);

    if(rows > 0)
    {
        new country[MAX_PLAYER_NAME];
        new reason[128];
        cache_get_field_content(0, "country", country);
        format(reason, sizeof(reason), "Country '%s' is banned (IP: %s)", country, GetPlayerIP(playerid));

        KickPlayer(playerid, reason, INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
    }
}

CMD:ip(playerid, params[])
{
    return callcmd::getip(playerid, params);
}

CMD:getip(playerid, params[])
{
    new targetid;

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
 	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /getip [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
	}
	if(PlayerData[playerid][pAdmin] < MANAGEMENT && PlayerData[targetid][pAdmin] > 1)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You cannot use this command on another administrator");
	}
    new  ip[24], country[64], city[64], isp[64];
	GetPlayerIp(targetid, ip, sizeof(ip));
	GetIPCountry(ip, country, 64);
	GetIPCity(ip, city, 64);
	GetIPISP(ip, isp, 64);
	
	return SendClientMessageEx(playerid, COLOR_WHITE, "* %s[%i]'s IP: %s, Country: %s, City: %s, ISP: %s, GMT+%d *", GetRPName(targetid), targetid, ip, country, city, isp, GetIPGMT(ip));
}

CMD:bancountry(playerid, params[])
{

    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
 	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bancountry [country_name]");
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO banned_countries VALUES(null, '%s', NOW(), '%e')", GetPlayerNameEx(playerid), params);
    mysql_tquery(connectionID, queryBuffer);
    SendAdminWarning(2, "%s has banned the country '%s'", GetPlayerNameEx(playerid), params);
    return 1;
}

CMD:exportipstats(playerid, params[])
{
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
 	}
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username,ip FROM users");
	mysql_tquery(connectionID, queryBuffer, "OnExportIPStats", "i", playerid);
    return 1;
}

publish OnExportIPStats(playerid)
{
	new rows = cache_get_row_count(connectionID);

    if(!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "There is no user in the database.");
    }
    else
    {
        new File: file = fopen("ipstats.csv", io_write);
        new string[128];
        new username[32], country[64], ip[16];
        fwrite(file, "country,username,ip");
        for(new i=0;i<rows;i++)
        {
            cache_get_field_content(i, "username", username);
            cache_get_field_content(i, "ip", ip);
            GetIPCountry(ip, country, 64);
            format(string, sizeof(string), "%s,%s,%s\n", country, username, ip);
            fwrite(file, string);
        }
        fclose(file);
        SendClientMessage(playerid, COLOR_AQUA, "ipstats exported successfully to ipstats.csv");
    }
}
CMD:unbancountry(playerid, params[])
{
    if(!IsGodAdmin(playerid))
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
 	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bancountry [country_name]");
	}

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM banned_countries where country = '%e'", params);
    mysql_tquery(connectionID, queryBuffer);
    SendAdminWarning(2, "%s has unbanned the country '%s'", params);
    return 1;
}

CMD:ogetip(playerid, params[])
{
	new name[MAX_PLAYER_NAME];

    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ogetip [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, ip, adminlevel FROM "#TABLE_USERS" WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnOfflineGetIP", "i", playerid);

	return 1;
}

CMD:iplookup(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < GENERAL_ADMIN)
	{
	    return SendClientErrorUnauthorizedCmd(playerid);
	}
	if(!IsAnIP(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /iplookup [ip address]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT username, lastlogin FROM "#TABLE_USERS" WHERE ip = '%s' ORDER BY lastlogin DESC", params);
	mysql_tquery(connectionID, queryBuffer, "OnTraceIP", "i", playerid);

	return 1;
}

publish OnOfflineGetIP(playerid)
{
	new rows = cache_get_row_count(connectionID);

    if(!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "The username specified is not registered.");
    }
    else
    {
        new username[MAX_PLAYER_NAME], ip[16];


        cache_get_field_content(0, "username", username);
        cache_get_field_content(0, "ip", ip);

        if((cache_get_field_content_int(0, "adminlevel") > PlayerData[playerid][pAdmin]))
        {
            SendClientMessage(playerid, COLOR_GREY, "You cannot check the IP of this admin");
        }
        else
        {
            new  country[64], city[64], isp[64];
            GetIPCountry(ip, country, 64);
            GetIPCity(ip, city, 64);
            GetIPISP(ip, isp, 64);
            
            SendClientMessageEx(playerid, COLOR_WHITE, "* %s's IP: %s, Country: %s, City: %s, ISP: %s, GMT+%d *", username, ip, country, city, isp, GetIPGMT(ip));
        }

    }
}

publish OnTraceIP(playerid)
{
	new rows = cache_get_row_count(connectionID);

    if(rows)
    {
        new username[24], date[24];

        SendClientMessageEx(playerid, COLOR_NAVYBLUE, "___________ %i Results Found ___________", rows);

        for(new i = 0; i < rows; i ++)
        {
            cache_get_field_content(i, "username", username);
            cache_get_field_content(i, "lastlogin", date);

            SendClientMessageEx(playerid, COLOR_GREY2, "Name: %s - Last Seen: %s", username, date);
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "This IP address is not associated with any accounts.");
    }
}
