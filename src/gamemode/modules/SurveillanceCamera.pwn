
#include <YSI\y_hooks>

static SurveillanceCamera[MAX_PLAYERS];

hook OnGameModeInit()
{
	CreateDynamic3DTextLabel("/cam\nto open the surveillance camera", COLOR_YELLOW, 1579.942626, -1634.915771, 13.561556, 10.0);
	CreateDynamicPickup(1253, 1, 1579.942626, -1634.915771, 13.561556);
}

hook OnPlayerInit(playerid)
{
	SurveillanceCamera[playerid] = false;
}

CMD:cam(playerid, params[])
{
    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you aren't apart of law enforcement.");
	}

    if (PlayerData[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any faction at the moment.");
    }

	if (SurveillanceCamera[playerid] && !strcmp(params, "off", true))
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 1579.942626, -1634.915771, 13.561556);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerFacingAngle(playerid, 270.0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid,1);
	}

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1579.942626, -1634.915771, 13.561556))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not in the location of the surveillance camera.");
	}

    if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_GREY, "USAGE: /cam [location] (or /cam off)");
		SendClientMessage(playerid, COLOR_GREY, "General locations to watch: gym, rmpd, allsaints, countygen, tgb, bank, casino, motel, cityhall, mall");
        SendClientMessage(playerid, COLOR_GREY, "Point locations to watch: mp1, df, mf1, dh, mp2, cl, mf2, aec, ffc");
	    return 1;
	}

	SurveillanceCamera[playerid] = true;
	if(strcmp(params, "gym", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 2212.61, -1730.57, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2208.67, -1733.71, 27.48);
		SetPlayerCameraLookAt(playerid, 2225.25, -1723.1, 13.56);
	}
	else if(strcmp(params, "lspd", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 1504.23, -1700.17, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1500.21, -1691.75, 38.38);
		SetPlayerCameraLookAt(playerid, 1541.46, -1676.17, 13.55);
	}
	else if(strcmp(params, "allsaints", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 1201.12, -1324, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
		SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);
	}
	else if(strcmp(params, "countygen", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off )).");
		SetPlayerPos(playerid, 1989.24, -1461.38, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1981.79, -1461.55, 31.93);
		SetPlayerCameraLookAt(playerid, 2021.23, -1427.48, 13.97);
	}
	else if(strcmp(params, "tgb", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off )).");
		SetPlayerPos(playerid, 2319.09, -1650.90, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2336.31, -1664.76, 24.98);
		SetPlayerCameraLookAt(playerid, 2319.09, -1650.90, 14.16);
	}
	else if(strcmp(params, "casino", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 1466.24, -1023.05, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1502.28, -1044.47, 31.19);
		SetPlayerCameraLookAt(playerid, 1466.24, -1023.05, 23.83);
	}
	else if(strcmp(params, "motel", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 2215.73, -1163.39, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2203.05, -1152.81, 37.03);
		SetPlayerCameraLookAt(playerid, 2215.73, -1163.39, 25.73);
	}
	else if(strcmp(params, "cityhall", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 1478.936035, -1746.446655, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1447.461669, -1717.788085, 44.047473);
		SetPlayerCameraLookAt(playerid, 1478.936035, -1746.446655, 14.347633);
	}
	else if(strcmp(params, "mall", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
		SetPlayerPos(playerid, 1127.245483, -1451.613891, -80.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1092.614868, -1499.197998, 42.018226);
		SetPlayerCameraLookAt(playerid, 1127.245483, -1451.613891, 15.796875);
	}
	else if(strcmp(params, "mp1", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 1423.773437, -1320.386962, -60.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1411.689941, -1352.002929, 24.477527);
		SetPlayerCameraLookAt(playerid, 1423.773437, -1320.386962, 13.554687);
	}
	else if(strcmp(params, "df", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 2205.938964, 1582.210449, 987.316528);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2222.844482, 1590.667968, 1002.612915);
		SetPlayerCameraLookAt(playerid, 2206.402587, 1582.398681, 999.976562);
	}
	else if(strcmp(params, "mf1", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 2172.315185, -2263.781250, -60.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2206.363769, -2262.568359, 24.240808);
		SetPlayerCameraLookAt(playerid, 2172.315185, -2263.781250, 13.335824);
	}
	else if(strcmp(params, "dh", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 323.577026, 1118.344116, 1063.765625);
		SetPlayerInterior(playerid, 5);
		SetPlayerVirtualWorld(playerid, 20019);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 316.387817, 1123.946289, 1085.046020);
		SetPlayerCameraLookAt(playerid, 323.577026, 1118.344116, 1083.882812);
	}
	else if(strcmp(params, "mf2", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 2390.212402, -2008.328491, -60.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2410.285644, -2013.919433, 21.716161);
		SetPlayerCameraLookAt(playerid, 2390.212402, -2008.328491, 13.553703);
	}
	else if(strcmp(params, "aec", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 2346.013916, -1185.367065, 977.425842);
		SetPlayerInterior(playerid, 5);
		SetPlayerVirtualWorld(playerid, 20020);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2342.012207, -1180.969848, 1029.412353);
		SetPlayerCameraLookAt(playerid, 2346.013916, -1185.367065, 1027.976562);
	}
	else if(strcmp(params, "ffc", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 2282.298828, -1110.143798, -35.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2306.088623, -1133.968627, 52.929584);
		SetPlayerCameraLookAt(playerid, 2282.298828, -1110.143798, 37.976562);
	}
	else if(strcmp(params, "17", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid,2729.929687, -2451.353271, -60.0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2780.443847, -2383.833984, 31.127187);
		SetPlayerCameraLookAt(playerid, 2729.929687, -2451.353271, 17.593746);
	}
	else if(strcmp(params, "18", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You are now on a mission to monitor city cameras (( to close the camera use /cam off ))");
  		SetPlayerPos(playerid, 2662.808105, -2133.713623, -39.590702);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2662.808105, -2133.713623, 26.140636);
		SetPlayerCameraLookAt(playerid, 2636.352294, -2109.808349, 13.546875);
	}
	else
	{
		SurveillanceCamera[playerid] = false;
	}
	return 1;
}
