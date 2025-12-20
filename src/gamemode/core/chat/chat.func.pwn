//CanReceiveMessage doesnt verify if faction exist or gang exist server may crash if you call it without checking this informations;
CanReceiveMessage(sid, rid, MsgTargetEnum:target)
{
    switch(target){
        case mtFaction:         { return PlayerData[rid][pFaction] == PlayerData[sid][pFaction] && 
                                        !PlayerData[rid][pToggleFaction]; }
        case mtAdmin:           { return (PlayerData[rid][pAdmin] > 0 || PlayerData[rid][pDeveloper]) && 
                                        !PlayerData[rid][pToggleAdmin]; }
        case mtGlobal:          { return !PlayerData[rid][pToggleGlobal]; }
        case mtNewbie:          { return !PlayerData[rid][pToggleNewbie]; }
        case mtGang:            { return (PlayerData[rid][pGang] == PlayerData[sid][pGang] && 
                                        !PlayerData[rid][pToggleGang]); }
        case mtCrew:            { return (PlayerData[rid][pGang] == PlayerData[sid][pGang] && 
                                        PlayerData[rid][pCrew] == PlayerData[sid][pCrew]); }
        case mtRadio:           { return (
                                            (
                                                PlayerData[rid][pFaction] == PlayerData[sid][pFaction] && 
                                                !PlayerData[rid][pToggleRadio]
                                            ) || (
                                                PlayerData[rid][pPoliceScanner] &&
                                                PlayerData[rid][pScannerOn] && 
                                                IsEmergencyFaction(sid)
                                            )
                                        ); }
        case mtDeparment:       { new rfactiontype=GetPlayerFaction(rid);
                                return (
                                            (
                                                PlayerData[rid][pPoliceScanner] && 
                                                PlayerData[rid][pScannerOn]
                                            ) || 
                                            (
                                                (!PlayerData[i][pToggleRadio]) && 
                                                (
                                                    rfactiontype == FACTION_POLICE || 
                                                    rfactiontype == FACTION_MEDIC || 
                                                    rfactiontype == FACTION_GOVERNMENT || 
                                                    rfactiontype == FACTION_FEDERAL || 
                                                    rfactiontype == FACTION_ARMY
                                                )
                                            )
                                        ); }
        case mtPrivateRadio:    { return ( PlayerData[rid][pPrivateRadio] && 
                                        PlayerData[rid][pChannel] == PlayerData[sid][pChannel] && 
                                        !PlayerData[rid][pTogglePR]); }
        case mtOOCGlobal:       { return (!PlayerData[rid][pToggleOOC]); }
        case mtFormerAdmin:     { return (
                                            (
                                                PlayerData[rid][pAdmin] > 0 || 
                                                PlayerData[rid][pFormerAdmin]
                                            ) 
                                            && !PlayerData[rid][pToggleAdmin]
                                        ); }
        case mtHelper:          { return (
                                            (
                                                PlayerData[rid][pHelper] > 0 || 
                                                PlayerData[rid][pAdmin] > 0
                                            ) 
                                            && !PlayerData[rid][pToggleHelper]
                                        ); }
        case mtGangAlliance:    { return (
                                            (
                                                PlayerData[rid][pGang] == PlayerData[sid][pGang] || 
                                                PlayerData[rid][pGang] == GangInfo[PlayerData[sid][pGang]][gAlliance]
                                            )
                                            && !PlayerData[rid][pToggleGang]
                                        ); }
        case mtGoverment:       { return false; }//It send to all
    }
    return false;
}
GetChatColor(MsgTargetEnum:target)
{
    switch(target){
        case mtFaction:         { return COLOR_AQUA;                 }//COLOR_YELLOW
        case mtAdmin:           { return COLOR_YELLOW;                 }//COLOR_YELLOW
        case mtGlobal:          { return COLOR_GLOBAL;            }
        case mtNewbie:          { return COLOR_NEWBIE;            }
        case mtGang:            { return COLOR_AQUA;              }
        case mtCrew:            { return COLOR_LIGHTORANGE;              }
        case mtRadio:           { return COLOR_OLDSCHOOL;             }
        case mtDeparment:       { return COLOR_YELLOW;        }
        case mtGoverment:       { return -1;                           }
        case mtPrivateRadio:    { return COLOR_PRIVATERADIO;           }//COLOR_PRIVATERADIO
        case mtOOCGlobal:       { return COLOR_WHITE;                  }//COLOR_WHITE
        case mtFormerAdmin:     { return COLOR_RETIRED;                }//old: COLOR_RETIRED
        case mtHelper:          { return 0xBDF38BFF;                   }//0xBDF38BFF
        case mtGangAlliance:    { return COLOR_GANG_ALLIANCE_CHAT;     }
    }
    for(new i=0;i<sizeof(ChatConfig);i++)
    {
        if(ChatConfig[i][mtTarget] == target)
        {
            return  ChatConfig[i][mtColor];
        }
    }
    return 0xFFFFFFFF;
}
IsOOCChat(MsgTargetEnum:target)
{
    return (
        target==mtOOCGlobal ||
        target==mtGlobal ||
        target==mtFaction
    );
}
GetAdminName(playerid)
{
    new adminname[24];
    strcpy(adminname, GetRPName(playerid));
    if(PlayerData[playerid][pUndercover][0])
    {
        if(strcmp(PlayerData[playerid][pAdminName], "None", true))
        {
            strcpy(adminname, PlayerData[playerid][pAdminName]);
        }
    }
    return adminname;
}

HaveCustomUserTitle(playerid)
{
    return ( 
                (
                    !isnull(PlayerData[playerid][pCustomTitle]) && 
                    strcmp(PlayerData[playerid][pCustomTitle], "None", true) != 0
                ) 
                && PlayerData[playerid][pAdminHide] == 0
            );
}

GetUserTitleColor(playerid)
{
    if(HaveCustomUserTitle(playerid))
    {
		if(PlayerData[playerid][pCustomTColor] == -1 || PlayerData[playerid][pCustomTColor] == -256)
           	return 0xC8C8C8FF;
		else return PlayerData[playerid][pCustomTColor];
    }else if(PlayerData[playerid][pAdmin] > 1 && PlayerData[playerid][pAdminHide] == 0) {
        return -1;
    }else if(PlayerData[playerid][pHelper] > 0){
        return 0x33CCFFFF;
    }else  if(PlayerData[playerid][pFormerAdmin]) {
	    return 0xFF69B5FF;
	}else if(PlayerData[playerid][pDonator] > 0) {
	    return 0xD909D9FF;
	} else if(PlayerData[playerid][pLevel] >= 3) {
	    return -1;
	} else {//Newbie
	    return -1
	}
}
GetUserTitle(playerid)
{
    new usertitle[24];
    if(HaveCustomUserTitle(playerid)) {
	    format(usertitle, sizeof(usertitle), "%s", PlayerData[playerid][pCustomTitle]);
	} else if(PlayerData[playerid][pAdmin] > 1 && PlayerData[playerid][pAdminHide] == 0) {
	  format(usertitle, sizeof(usertitle), "%s", GetAdminRank(playerid));
	} else if(PlayerData[playerid][pHelper] > 0) {
	   format(usertitle, sizeof(usertitle), "%s", GetHelperRank(playerid));
	} else if(PlayerData[playerid][pFormerAdmin]) {
	    usertitle = "Former Admin";
	} else if(PlayerData[playerid][pDonator] > 0) {
        format(usertitle, sizeof(usertitle), "%s VIP", GetVIPRank(PlayerData[playerid][pDonator]));
	} else if(PlayerData[playerid][pLevel] >= 3) {
	    format(usertitle, sizeof(usertitle), "Level %i Player", PlayerData[playerid][pLevel]);
	} else {
	    usertitle = "Newbie";
	}
    return usertitle;
}
GetChatHeader(playerid, MsgTargetEnum:target)
{
    new header[128];
    header="";
    new color = GetChatColor(target) >>> 8;
    switch(target)
    {
        case mtFaction: { 
            format(header,sizeof(header),"%s",FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]])
        }
        //User adminname GetAdminName(playerid); need to check color usertitle
        case mtAdmin:{
            format(header,sizeof(header),"[%s %s{%06x}]",GetAdminDivision(playerid), GetAdminRank1(playerid)); 
        }
        case mtGlobal: { 
            format(header,sizeof(header),"{%06x}%s{%06x}",GetUserTitleColor(playerid)>>>6,GetUserTitle(playerid),color); }
        case mtNewbie: { 
            format(header,sizeof(header),"{%06x}%s{%06x}",GetUserTitleColor(playerid)>>>6,GetUserTitle(playerid),color); }
        case mtGang: { 
            if(PlayerData[playerid][pCrew] >= 0)
                format(header,sizeof(header),"[%s] %s",GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]],
                                                             GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]]); 
            else format(header,sizeof(header),"%s",GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]]); 
        }
        case mtCrew: {
            format(header,sizeof(header),"[%s] %s",GangCrews[PlayerData[playerid][pGang]][PlayerData[playerid][pCrew]],
                                                         GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]]); 
        }
        case mtRadio: { 
            if(PlayerData[playerid][pDivision] != -1)
            format(header,sizeof(header),"[%s] %s", FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]],
                                                          FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]]); 
            else format(header,sizeof(header),"%s", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]]); 
        }
        case mtDeparment:       { 
            if(PlayerData[playerid][pDivision] == -1)
                format(header, sizeof(header), "(%s) %s", FactionInfo[PlayerData[playerid][pFaction]][fShortName], 
                                            FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]]);
            else
                format(header, sizeof(header), "(%s) [%s] %s", FactionInfo[PlayerData[playerid][pFaction]][fShortName],
                                FactionDivisions[PlayerData[playerid][pFaction]][PlayerData[playerid][pDivision]],
                                FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]]);
        }
        //case mtGoverment:       { format(header,sizeof(header),"%s",); }
        case mtPrivateRadio:    { format(header,sizeof(header),"** Radio %i Khz **",PlayerData[playerid][pChannel]); }
        case mtOOCGlobal:       { header = ""; }
        case mtFormerAdmin:     { header = "[FM]"; }
        case mtHelper:          { format(header,sizeof(header),"[Helpers] %s",GetStaffRank(playerid)); }
        case mtGangAlliance:    { format(header,sizeof(header),"[Alliance] %s",GangRanks[PlayerData[playerid][pGang]][PlayerData[playerid][pGangRank]]); }
    }
    return header;
}

PublicAnnoncementChat(playerid, msg[])
{
    new factionid=PlayerData[playerid][pFaction];
    new factionType=FactionInfo[factionid][fType];
    
    switch(factionType)
	{
        case FACTION_MEDIC,FACTION_POLICE,FACTION_GOVERNMENT,FACTION_ARMY,FACTION_FEDERAL:
        {
            if(factionType==FACTION_GOVERNMENT)
	        	SendClientMessageToAll(COLOR_GREY1, "____________ Government News Announcement ____________");
            else SendClientMessageToAll(COLOR_GREY1, "____________ Public Service Announcement ____________");
            
            new color;
            if(FactionInfo[factionid][fColor] == -1 || FactionInfo[factionid][fColor] == -256)
                color = 0xC8C8C8FF;
            else color = FactionInfo[factionid][fColor];
            
			SendClientMessageToAllEx(color>>>8, "* %s %s: %s", FactionRanks[factionid][PlayerData[playerid][pFactionRank]], GetRPName(playerid), msg);
			PlayerData[playerid][pGovTimer] = 30;
        }
		default:
		{
		    SendClientMessage(playerid, COLOR_GREY, "Your faction is not authorized to use this command.");
		}
	}
    return 1;
}

//Dont forget user title
SendMessageToAllMembers(senderid, MsgTargetEnum:target, msg[])
{
    if(target==mtGoverment)
        return PublicAnnoncementChat(senderid,msg);

    new color = GetChatColor(target);

	new msg1[MAX_SPLIT_LENGTH + 1], msg2[MAX_SPLIT_LENGTH + 1];
    new IsMultiLine=(strlen(msg) > MAX_SPLIT_LENGTH);

    if(IsMultiLine)
    {
        format(msg1, sizeof(msg1), "%s %s: %.*s...", GetChatHeader(playerid,target) , GetRPName(senderid), MAX_SPLIT_LENGTH, params);
        format(msg2, sizeof(msg2), "%s %s: ...%s", GetChatHeader(playerid,target) , GetRPName(senderid), params[MAX_SPLIT_LENGTH]);
    }else 
    	format(msg1, sizeof(msg1), "%s %s: %s", GetChatHeader(playerid,target), GetRPName(senderid), params);

    if(IsOOCChat(target))
    {
        format(msg1, sizeof(msg1), "(( %s ))",msg1);
        if(IsMultiLine)
            format(msg2, sizeof(msg2), "(( %s ))",msg2);
    }

    foreach(new i : Player)
	{
	    if(CanReceiveMessage(senderid,i,target))
	    {
	        if(strlen(params) > MAX_SPLIT_LENGTH)
	        {
		        SendClientMessage(i, color, msg1);
                if(IsMultiLine)
                    SendClientMessage(i, color, msg2);
			}
		}
	}
    return 1;
}