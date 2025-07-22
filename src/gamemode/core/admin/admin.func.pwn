
IsUIDGodAdmin(uid)
{
    for(new i=0;i<sizeof(GodAdmin);i++)
    {
        if(GodAdmin[i] == uid)
        {
            return true;
        }
    }
    return false;
}

IsGodAdmin(playerid)
{
	if(!PlayerData[playerid][pLogged] || PlayerData[playerid][pKicked])
    {
        return false;
    }

    return IsUIDGodAdmin(PlayerData[playerid][pID]);
}

IsAdmin(playerid, level=1)
{
    return (PlayerData[playerid][pAdmin] >= level)  || IsGodAdmin(playerid);
}

IsAdminOnDuty(playerid, ignore_highrank=true)
{
    if(ignore_highrank)
    {
        return (PlayerData[playerid][pAdminDuty] == 1 || PlayerData[playerid][pAdmin] >= 8);
    }
    return (PlayerData[playerid][pAdminDuty] == 1);
}


SendAdminWarning(admin_level, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
        foreach(new i : Player)
	    {
	        if(IsAdmin(i, admin_level) && PlayerData[i][pLogged])
	        {
			    SendClientMessageEx(i, COLOR_YELLOW, "[AdmWarning]{FFFF00} %s", text);
			}
		}
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

        foreach(new i : Player)
	    {
	        if(IsAdmin(i, admin_level) && PlayerData[i][pLogged])
	        {
			    SendClientMessageEx(i, COLOR_YELLOW, "[AdmWarning]{FFFF00} %s", str);                
			}
		}

		#emit RETN
	}
	return 1;
}
