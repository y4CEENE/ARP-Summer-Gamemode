#include <YSI\y_hooks>

static IsUsingLoopAnim[MAX_PLAYERS];
static gPlayerAnimLibsPreloaded[MAX_PLAYERS];
static Text:AnimationTD;


hook OnGameModeInit()
{    
	// Animation textdraw
	AnimationTD = TextDrawCreate(435.000000, 426.000000, "Press ~r~~k~~PED_SPRINT~~w~ to stop animation");
	TextDrawBackgroundColor(AnimationTD, 255);
	TextDrawFont(AnimationTD, 2);
	TextDrawLetterSize(AnimationTD, 0.260000, 1.299999);
	TextDrawColor(AnimationTD, -1);
	TextDrawSetOutline(AnimationTD, 1);
	TextDrawSetProportional(AnimationTD, 1);
    return 1;
}

hook OnPlayerHeartBeat(playerid)
{
    if(IsUsingLoopAnim[playerid] && !PlayerData[playerid][pToggleTextdraws]) 
    {
        TextDrawShowForPlayer(playerid, AnimationTD);
    }
    else 
    {
        TextDrawHideForPlayer(playerid, AnimationTD);
    }
    return 1;
}

PreloadPlayerAnims(playerid)
{
    static const animLibraries[][] =
	{
		!"AIRPORT",    !"ATTRACTORS",   !"BAR", 		 !"BASEBALL",
		!"BD_FIRE",    !"BEACH",      	!"BENCHPRESS",   !"BF_INJECTION",
		!"BIKED", 	   !"BIKEH", 	    !"BIKELEAP", 	 !"BIKES",
		!"BIKEV", 	   !"BIKE_DBZ",     !"BMX", 		 !"BOMBER",
		!"BOX", 	   !"BSKTBALL",     !"BUDDY", 		 !"BUS",
		!"CAMERA", 	   !"CAR",          !"CARRY", 		 !"CAR_CHAT",
		!"CASINO",	   !"CHAINSAW",     !"CHOPPA", 		 !"CLOTHES",
		!"COACH", 	   !"COLT45",       !"COP_AMBIENT",  !"COP_DVBYZ",
		!"CRACK", 	   !"CRIB",         !"DAM_JUMP", 	 !"DANCING",
		!"DEALER", 	   !"DILDO",        !"DODGE", 	 	 !"DOZER",
		!"DRIVEBYS",   !"FAT",          !"FIGHT_B", 	 !"FIGHT_C",
		!"FIGHT_D",    !"FIGHT_E",      !"FINALE", 		 !"FINALE2",
		!"FLAME",      !"FLOWERS",      !"FOOD", 	 	 !"FREEWEIGHTS",
		!"GANGS",      !"GHANDS",       !"GHETTO_DB", 	 !"GOGGLES",
		!"GRAFFITI",   !"GRAVEYARD",    !"GRENADE", 	 !"GYMNASIUM",
		!"HAIRCUTS",   !"HEIST9",       !"INT_HOUSE", 	 !"INT_OFFICE",
		!"INT_SHOP",   !"JST_BUISNESS", !"KART", 		 !"KISSING",
		!"KNIFE",      !"LAPDAN1", 		!"LAPDAN2", 	 !"LAPDAN3",
		!"LOWRIDER",   !"MD_CHASE", 	!"MD_END", 	 	 !"MEDIC",
		!"MISC",       !"MTB", 			!"MUSCULAR", 	 !"NEVADA",
		!"ON_LOOKERS", !"OTB", 			!"PARACHUTE", 	 !"PARK",
		!"PAULNMAC",   !"PED", 			!"PLAYER_DVBYS", !"PLAYIDLES",
		!"POLICE",     !"POOL", 		!"POOR", 		 !"PYTHON",
		!"QUAD",       !"QUAD_DBZ", 	!"RAPPING", 	 !"RIFLE",
		!"RIOT",       !"ROB_BANK", 	!"ROCKET",	 	 !"RUSTLER",
		!"RYDER",      !"SCRATCHING", 	!"SHAMAL", 		 !"SHOP",
		!"SHOTGUN",    !"SILENCED", 	!"SKATE", 		 !"SMOKING",
		!"SNIPER",     !"SPRAYCAN", 	!"STRIP", 		 !"SUNBATHE",
		!"SWAT",       !"SWEET", 		!"SWIM", 		 !"SWORD",
		!"TANK",       !"TATTOOS",	 	!"TEC", 		 !"TRAIN",
		!"TRUCK",      !"UZI", 			!"VAN", 		 !"VENDING",
		!"VORTEX",     !"WAYFARER", 	!"WEAPONS", 	 !"WUZI",
		!"WOP",        !"GFUNK", 		!"RUNNINGMAN",   !"BLOWJOBZ",
		!"SNM",        !"SEX",          !"SAMP"
	};

	for(new i = 0; i < sizeof(animLibraries); i ++)
	{
	    ApplyAnimation(playerid, animLibraries[i], "null", 0.0, 0, 0, 0, 0, 0);
	}
}

publish StopLoopingAnimation(playerid)
{
    IsUsingLoopAnim[playerid] = 0;

   	ClearAnimations(playerid, 1);
	TextDrawHideForPlayer(playerid, AnimationTD);

	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    SendClientMessage(playerid, COLOR_GREY, "Animations cleared.");
    return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PlayerData[playerid][pInjured])
	{
        return 1;
    }

	if(!IsUsingLoopAnim[playerid]) 
    {
        return 1;
    }

	if(IsKeyPress(KEY_SPRINT, newkeys, oldkeys))
	{
	    StopLoopingAnimation(playerid);
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(IsUsingLoopAnim[playerid])
	{
        IsUsingLoopAnim[playerid] = 0;
	    TextDrawHideForPlayer(playerid, AnimationTD);
	}

 	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(!gPlayerAnimLibsPreloaded[playerid])
	{
        PreloadPlayerAnims(playerid);
		gPlayerAnimLibsPreloaded[playerid] = 1;
	}
	return 1;
}

hook OnPlayerInit(playerid)
{
    IsUsingLoopAnim[playerid] = 0;
	gPlayerAnimLibsPreloaded[playerid] = 0;
	return 1;
}

PlayAnim(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time)
{
	if(GetPlayerAnimationIndex(playerid) != 0) 
    {
        ClearAnimations(playerid);
    }

	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, 1);

	if(loop > 0 || freeze > 0)
	{
		IsUsingLoopAnim[playerid] = 1;

		if(!PlayerData[playerid][pToggleTextdraws])
		{
			TextDrawShowForPlayer(playerid, AnimationTD);
		}
	}
}

CanPlayerUseAnim(playerid)
{
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || PlayerData[playerid][pInjured] || PlayerData[playerid][pHospital] || IsPlayerMining(playerid) || PlayerData[playerid][pTazedTime] || PlayerData[playerid][pCuffed] || PlayerData[playerid][pLootTime] || IsPlayerFreezed(playerid))
	{
	    return 0;
	}

	return 1;
}

IsAblePedAnimation(playerid)
{
    if(IsPlayerInAnyVehicle(playerid) == 1)
    {
		return SendClientMessage(playerid, COLOR_GRAD2, "This animation requires you to be outside a vehicle.");
	}
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !CanPlayerUseAnim(playerid))
	{
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	return 1;
}

IsAbleVehicleAnimation(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) == 0)
    {
		SendClientMessage(playerid, COLOR_GRAD2, "This animation requires you to be inside a vehicle.");
		return 0;
	}

    if((GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) || !CanPlayerUseAnim(playerid))
	{
   		SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
           
   		return 0;
	}
	return 1;
}

IsCLowrider(carid)
{
	new Cars[] = { 536, 575, 567};
	for(new i = 0; i < sizeof(Cars); i++)
	{
		if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

CMD:animhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "______________________________________________________________________________________");
    SendClientMessage(playerid, COLOR_GREEN, "Available Ped Animations:");
    SendClientMessage(playerid, COLOR_GRAD1, " /coprun /handsup /piss /sneak /drunk /bomb /rob /laugh /lookout /robman /hide /vomit /eat /slapass /crack /fucku /shifty");
    SendClientMessage(playerid, COLOR_GRAD2, " /taichi /drinkwater /checktime /sleep /blob /opendoor /wavedown /cpr /dive /showoff /goggles /cry /throw /robbed /walk");
    SendClientMessage(playerid, COLOR_GRAD3, " /hurt /box /washhands /crabs /salute /jerkoff /stop /rap /wank /chat /sitdown /sitonchair /bat /lean /gesture /fuckme");
    SendClientMessage(playerid, COLOR_GRAD4, " /bodypush /lowbodypush /headbutt /airkick /doorkick /leftslap /elbow /lay /scratch /what /wash /come /hitch /traffic");
    SendClientMessage(playerid, COLOR_GRAD5, " /wave /signal /nobreath /fallover /pedmove /getjiggy /stripclub /smoke /dj /reload /tag /deal /crossarms /cheer /bj");
    SendClientMessage(playerid, COLOR_GRAD6, " /sit /siteat /bar /dance /spank /sexy /holdup /stickjup /copa /misc /snatch /blowjob /kiss /idles /sunbathe /ghands");
    SendClientMessage(playerid, COLOR_GRAD6, " /point /camera /fall /tired /cover /cower /injured /fishing /aim /dodge");
    SendClientMessage(playerid, COLOR_GREEN, "Available Car Animations:");
    SendClientMessage(playerid, COLOR_GRAD6, " /lowrider /carchat");
	SendClientMessage(playerid, COLOR_GREEN, "Use /stopani to stop an animation.");
	return 1;
}

CMD:anims(playerid, params[])
{
	return callcmd::animhelp(playerid, params);
}

CMD:animlist(playerid, params[])
{
	
    Dialog_Show(playerid, SelectAnim, DIALOG_STYLE_LIST, "{FFFFFF}Animation list", "> Dance\nLie Down\nSunbathe\nSit\nSpeaking\nHands up\nGreeting\nAim\nDying\nVomit\nReception ninja\nReception dealer\nHeart massage\nGive something\nKneel down\nLaughed heartily\nShow gang greeting\nPee Standing\nCrouch, closing head", "Select", "Cancel");

    return 1;
}

Dialog:SelectAnim(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    
    switch(listitem)
    {
        case 0: { Dialog_Show(playerid, SelectDanceAnim, DIALOG_STYLE_LIST, "{FFFFFF}Animation list", "Special Dance 1\nSpecial Dance 2\nSpecial Dance 3\nSpecial Dance 4", "Select", "Cancel"); } // > Dance
        case  1: { callcmd::sit(playerid, "1");          } // Lie Down
        case  2: { callcmd::sunbathe(playerid, "1");     } // Sunbathe
        case  3: { callcmd::sitonchair(playerid, "1");   } // Sit
        case  4: { callcmd::chat(playerid, "1");         } // Speaking
        case  5: { callcmd::robbed(playerid, "");        } // Hands up
        case  6: { callcmd::wave(playerid, "1");         } // Greeting
        case  7: { callcmd::aim(playerid, "1");          } // Aim
        case  8: { callcmd::nobreath(playerid, "1");     } // Dying
        case  9: { callcmd::vomit(playerid, "");         } // Vomit
        case 10: { callcmd::taichi(playerid, "");        } // Reception ninja
        case 11: { callcmd::crossarms(playerid, "2");    } // Reception dealer
        case 12: { callcmd::cpr(playerid, "");           } // Heart massage
        case 13: { callcmd::givesomething(playerid, ""); } // Give something
        case 14: { callcmd::idles(playerid, "6");        } // Kneel down
        case 15: { callcmd::laugh(playerid, "");         } // Laughed heartily
        case 16: { callcmd::gesture(playerid, "7");      } // Show gang greeting
        case 17: { callcmd::piss(playerid, "");          } // Pee Standing
        case 18: { callcmd::cower(playerid, "");         } // Crouch, closing head
    }
    return 1;
}


Dialog:SelectDanceAnim(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return 1;
    }
    
    switch(listitem)
    {
        case 0: { callcmd::dance(playerid, "1"); }
        case 1: { callcmd::dance(playerid, "2"); }
        case 2: { callcmd::dance(playerid, "3"); }
        case 3: { callcmd::dance(playerid, "4"); }
    }
    return 1;
}

CMD:stopani(playerid, params[])
{
	return callcmd::stopanim(playerid, params);
}

CMD:stopanim(playerid, params[])
{
    if(!CanPlayerUseAnim(playerid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're currently unable to use this command at this moment.");
	}

	if(IsPlayerInAnyVehicle(playerid) == 1)
	{
		return SendClientMessage(playerid, COLOR_GRAD2, "This command requires you to be outside a vehicle.");
	}

    StopLoopingAnimation(playerid);
    return 1;
}


CMD:bodypush(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0);
	return 1;
}

CMD:lowbodypush(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0);
	return 1;
}

CMD:headbutt(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"WAYFARER","WF_Fwd",4.0,0,0,0,0,0);
	return 1;
}

CMD:airkick(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.0,0,1,1,0,0);
	return 1;
}

CMD:doorkick(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);
	return 1;
}

CMD:leftslap(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"PED","BIKE_elbowL",4.0,0,0,0,0,0);
	return 1;
}

CMD:elbow(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.0,0,1,1,0,0);
	return 1;
}

CMD:coprun(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid,"SWORD","sword_block",50.0,0,1,1,1,1);
	return 1;
}

CMD:handsup(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:piss(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
   	SetPlayerSpecialAction(playerid, 68);
	return 1;
}

CMD:sneak(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	PlayAnim(playerid, "PED", "Player_Sneak", 4.1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:drunk(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
   	PlayAnim(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:bomb(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
   	PlayAnim(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:rob(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	PlayAnim(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 1);
	return 1;
}

CMD:laugh(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	PlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:lookout(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
   	PlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:robman(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:hide(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:vomit(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:eat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:slapass(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:crack(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:fucku(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:taichi(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:drinkwater(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:checktime(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:sleep(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, 0);
    return 1;
}

CMD:blob(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, 0);
    return 1;
}

CMD:opendoor(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:wavedown(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:cpr(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:dive(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0);
    return 1;
}

CMD:showoff(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "Freeweights", "gym_free_celebrate", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:goggles(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:cry(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:throw(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:robbed(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:hurt(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:box(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "GYMNASIUM", "GYMshadowbox", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:washhands(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:crabs(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:salute(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:jerkoff(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "PAULNMAC", "wank_out", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:stop(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    PlayAnim(playerid, "PED", "endchat_01", 4.0, 1, 0, 0, 0, 0);
    return 1;
}

CMD:rap(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
		case 2: PlayAnim(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /rap [1-3]");
	}
	return 1;
}

CMD:wank(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: 
        { 
            PlayAnim(playerid, "PAULNMAC", "wank_in", 4.0, 1, 0, 0, 0, 0); 
            AwardAchievement(playerid, ACH_ADirtyMind);
        }
		case 2: 
        { 
            PlayAnim(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0); 
            AwardAchievement(playerid, ACH_ADirtyMind);
        }
		case 3: 
        { 
            PlayAnim(playerid, "PAULNMAC", "wank_out", 4.0, 1, 0, 0, 0, 0); 
            AwardAchievement(playerid, ACH_ADirtyMind);
        }
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /wank [1-3]");
	}
	return 1;
}

CMD:chat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "PED", "IDLE_CHAT", 4.0, 1, 0, 0, 0, 0);
		case 2: PlayAnim(playerid, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
		case 3:	PlayAnim(playerid, "GANGS", "prtial_gngtlkB", 4.0, 1, 0, 0, 0, 0);
		case 4: PlayAnim(playerid, "GANGS", "prtial_gngtlkE", 4.0, 1, 0, 0, 0, 0);
		case 5: PlayAnim(playerid, "GANGS", "prtial_gngtlkF", 4.0, 1, 0, 0, 0, 0);
		case 6: PlayAnim(playerid, "GANGS", "prtial_gngtlkG", 4.0, 1, 0, 0, 0, 0);
		case 7:	PlayAnim(playerid, "GANGS", "prtial_gngtlkH", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /chat [1-7]");
	}
	return 1;
}

CMD:sitdown(playerid, params[])
{
	return callcmd::sitonchair(playerid, params);
}
	
CMD:sitonchair(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0);
		case 2: PlayAnim(playerid, "CRIB", "PED_Console_Loop", 4.0, 1, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "INT_HOUSE", "LOU_In", 4.0, 0, 0, 0, 1, 1);
		case 4: PlayAnim(playerid, "MISC", "SEAT_LR", 4.0, 1, 0, 0, 0, 0);
		case 5: PlayAnim(playerid, "MISC", "Seat_talk_01", 4.0, 1, 0, 0, 0, 0);
		case 6: PlayAnim(playerid, "MISC", "Seat_talk_02", 4.0, 1, 0, 0, 0, 0);
		case 7: PlayAnim(playerid, "ped", "SEAT_down", 4.0, 0, 0, 0, 1, 1);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sitonchair [1-7]");
	}
	return 1;
}

CMD:bat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid,"BASEBALL","Bat_IDLE",4.1, 0, 1, 1, 1, 1);
		case 2: PlayAnim(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /bat [1-3]");
	}
	return 1;
}

CMD:lean(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "GANGS", "leanIDLE", 4.0, 0, 0, 0, 1, 0);
		case 2: PlayAnim(playerid, "MISC", "Plyrlean_loop", 4.0, 0, 0, 0, 1, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /lean [1-2]");
	}
	return 1;
}

CMD:gesture(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "GHANDS", "gsign1", 4.0, 0, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "GHANDS", "gsign1LH", 4.0, 0, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "GHANDS", "gsign2", 4.0, 0, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "GHANDS", "gsign2LH", 4.0, 0, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "GHANDS", "gsign3", 4.0, 0, 0, 0, 0, 0);
	case 6: PlayAnim(playerid, "GHANDS", "gsign3LH", 4.0, 0, 0, 0, 0, 0);
	case 7: PlayAnim(playerid, "GHANDS", "gsign4", 4.0, 0, 0, 0, 0, 0);
	case 8: PlayAnim(playerid, "GHANDS", "gsign4LH", 4.0, 0, 0, 0, 0, 0);
	case 9: PlayAnim(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
	case 10: PlayAnim(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
	case 11: PlayAnim(playerid, "GHANDS", "gsign5LH", 4.0, 0, 0, 0, 0, 0);
	case 12: PlayAnim(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0);
	case 13: PlayAnim(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0);
	case 14: PlayAnim(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 0, 0, 0, 0);
	case 15: PlayAnim(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /gesture [1-15]");
	}
	return 1;
}

CMD:lay(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /lay [1-3]");
	}
	return 1;
}

CMD:wave(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "KISSING", "gfwave2", 4.0, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "PED", "endchat_03", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /wave [1-3]");
	}
	return 1;
}

CMD:signal(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "POLICE", "CopTraf_Come", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "POLICE", "CopTraf_Stop", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /signal [1-2]");
	}
	return 1;
}

CMD:nobreath(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /nobreath [1-3]");
	}
	return 1;
}

CMD:fallover(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0);
	case 2: PlayAnim(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0);
	case 3: PlayAnim(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0);
	case 4: PlayAnim(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0);
	case 5: PlayAnim(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /fallover [1-5]");
	}
	return 1;
}

CMD:pedmove(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 1);
	case 2: PlayAnim(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 1);
	case 3: PlayAnim(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	case 4: PlayAnim(playerid, "PED", "run_fat", 4.0, 1, 1, 1, 1, 1);
	case 5: PlayAnim(playerid, "PED", "run_fatold", 4.0, 1, 1, 1, 1, 1);
	case 6: PlayAnim(playerid, "PED", "run_old", 4.0, 1, 1, 1, 1, 1);
	case 7: PlayAnim(playerid, "PED", "Run_Wuzi", 4.0, 1, 1, 1, 1, 1);
	case 8: PlayAnim(playerid, "PED", "swat_run", 4.0, 1, 1, 1, 1, 1);
	case 9: PlayAnim(playerid, "PED", "WALK_fat", 4.0, 1, 1, 1, 1, 1);
	case 10: PlayAnim(playerid, "PED", "WALK_fatold", 4.0, 1, 1, 1, 1, 1);
	case 11: PlayAnim(playerid, "PED", "WALK_gang1", 4.0, 1, 1, 1, 1, 1);
	case 12: PlayAnim(playerid, "PED", "WALK_gang2", 4.0, 1, 1, 1, 1, 1);
	case 13: PlayAnim(playerid, "PED", "WALK_old", 4.0, 1, 1, 1, 1, 1);
	case 14: PlayAnim(playerid, "PED", "WALK_shuffle", 4.0, 1, 1, 1, 1, 1);
	case 15: PlayAnim(playerid, "PED", "woman_run", 4.0, 1, 1, 1, 1, 1);
	case 16: PlayAnim(playerid, "PED", "WOMAN_runbusy", 4.0, 1, 1, 1, 1, 1);
	case 17: PlayAnim(playerid, "PED", "WOMAN_runfatold", 4.0, 1, 1, 1, 1, 1);
	case 18: PlayAnim(playerid, "PED", "woman_runpanic", 4.0, 1, 1, 1, 1, 1);
	case 19: PlayAnim(playerid, "PED", "WOMAN_runsexy", 4.0, 1, 1, 1, 1, 1);
	case 20: PlayAnim(playerid, "PED", "WOMAN_walkbusy", 4.0, 1, 1, 1, 1, 1);
	case 21: PlayAnim(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	case 22: PlayAnim(playerid, "PED", "WOMAN_walknorm", 4.0, 1, 1, 1, 1, 1);
	case 23: PlayAnim(playerid, "PED", "WOMAN_walkold", 4.0, 1, 1, 1, 1, 1);
	case 24: PlayAnim(playerid, "PED", "WOMAN_walkpro", 4.0, 1, 1, 1, 1, 1);
	case 25: PlayAnim(playerid, "PED", "WOMAN_walksexy", 4.0, 1, 1, 1, 1, 1);
	case 26: PlayAnim(playerid, "PED", "WOMAN_walkshop", 4.0, 1, 1, 1, 1, 1);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /pedmove [1-26]");
	}
	return 1;
}

CMD:getjiggy(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "DANCING", "DAN_Down_A", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "DANCING", "DAN_Up_A", 4.0, 1, 0, 0, 0, 0);
	case 6: PlayAnim(playerid, "DANCING", "dnce_M_a", 4.0, 1, 0, 0, 0, 0);
	case 7: PlayAnim(playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0);
	case 8: PlayAnim(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0);
	case 9: PlayAnim(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0);
	case 10: PlayAnim(playerid, "DANCING", "dnce_M_d", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /getjiggy [1-10]");
	}
	return 1;
}

CMD:stripclub(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "STRIP", "PLY_CASH", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "STRIP", "PUN_CASH", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /stripclub [1-2]");
	}
	return 1;
}

CMD:smoke(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /smoke [1-2]");
	}
	return 1;
}

CMD:dj(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0);
		case 2: PlayAnim(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0);
		case 4: PlayAnim(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /dj [1-4]");
	}
	return 1;
}

CMD:reload(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /reload [1-2]");
	}
	return 1;
}

CMD:tag(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /tag [1-2]");
	}
	return 1;
}

CMD:deal(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "DEALER", "shop_pay", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /deal [1-2]");
	}
	return 1;
}

CMD:crossarms(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
		case 2: PlayAnim(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);
		case 4: PlayAnim(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0);
		case 5: PlayAnim(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /crossarms [1-5]");
	}
	return 1;
}

CMD:cheer(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "ON_LOOKERS", "shout_01", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "ON_LOOKERS", "shout_02", 4.0, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "ON_LOOKERS", "shout_in", 4.0, 1, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "RIOT", "RIOT_CHANT", 4.0, 1, 0, 0, 0, 0);
	case 6: PlayAnim(playerid, "RIOT", "RIOT_shout", 4.0, 1, 0, 0, 0, 0);
	case 7: PlayAnim(playerid, "STRIP", "PUN_HOLLER", 4.0, 1, 0, 0, 0, 0);
	case 8: PlayAnim(playerid, "OTB", "wtchrace_win", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /cheer [1-8]");
	}
	return 1;
}

CMD:sit(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sit [1-5]");
	}
	return 1;
}

CMD:siteat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /siteat [1-2]");
	}
	return 1;
}

CMD:bar(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0);
	case 2: PlayAnim(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "BAR", "BARman_idle", 4.0, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /bar [1-5]");
	}
	return 1;
}

CMD:dance(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	switch(strval(params))
	{
		case 1: SetPlayerSpecialAction(playerid, 5);
		case 2: SetPlayerSpecialAction(playerid, 6);
		case 3: SetPlayerSpecialAction(playerid, 7);
		case 4: SetPlayerSpecialAction(playerid, 8);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /dance [1-4]");
	}
	return 1;
}

CMD:spank(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "SNM", "SPANKINGW", 4.1, 1, 0, 0, 0, 0);
		case 2: PlayAnim(playerid, "SNM", "SPANKINGP", 4.1, 1, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "SNM", "SPANKEDW", 4.1, 1, 0, 0, 0, 0);
		case 4: PlayAnim(playerid, "SNM", "SPANKEDP", 4.1, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /spank [1-4]");
	}
	return 1;
}

CMD:sexy(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "STRIP", "STR_A2B", 4.1, 0, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "STRIP", "STR_Loop_A", 4.1, 1, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "STRIP", "STR_Loop_B", 4.1, 1, 0, 0, 0, 0);
	case 6: PlayAnim(playerid, "STRIP", "STR_Loop_C", 4.1, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sexy [1-6]");
	}
	return 1;
}

CMD:holdup(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "POOL", "POOL_ChalkCue", 4.1, 0, 1, 1, 1, 1);
	case 2: PlayAnim(playerid, "POOL", "POOL_Idle_Stance", 4.1, 0, 1, 1, 1, 1);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /holdup [1-2]");
	}
	return 1;
}

CMD:stickjup(playerid, params[])
{
    PlayAnim(playerid, "POOL", "POOL_Idle_Stance", 4.1, 0, 1, 1, 1, 1);
    return 1;
}

CMD:copa(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "POLICE", "CopTraf_Away", 4.1, 0, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "POLICE", "CopTraf_Left", 4.1, 0, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "POLICE", "Cop_move_FWD", 4.1, 1, 1, 1, 1, 1);
	case 6: PlayAnim(playerid, "POLICE", "crm_drgbst_01", 4.1, 0, 0, 0, 1, 5000);
	case 7: PlayAnim(playerid, "POLICE", "Door_Kick", 4.1, 0, 1, 1, 1, 1);
	case 8: PlayAnim(playerid, "POLICE", "plc_drgbst_01", 4.1, 0, 0, 0, 0, 5000);
	case 9: PlayAnim(playerid, "POLICE", "plc_drgbst_02", 4.1, 0, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /copa [1-9]");
	}
	return 1;
}

CMD:misc(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "CAR", "Fixn_Car_Loop", 4.1, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "CAR", "flag_drop", 4.1, 0, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "PED", "bomber", 4.1, 0, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /misc [1-3]");
	}
	return 1;
}

CMD:snatch(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "PED", "BIKE_elbowR", 4.1, 0, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /snatch [1-2]");
	}
	return 1;
}

CMD:blowjob(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /blowjob [1-2]");
	}
	return 1;
}

CMD:kiss(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0);
	case 2: PlayAnim(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0);
	case 3: PlayAnim(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0);
	case 4: PlayAnim(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0);
	case 5: PlayAnim(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0);
	case 6: PlayAnim(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /kiss [1-6]");
	}
	return 1;
}

CMD:idles(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "PLAYIDLES", "shift", 4.1, 1, 1, 1, 1, 1);
	case 2: PlayAnim(playerid, "PLAYIDLES", "shldr", 4.1, 1, 1, 1, 1, 1);
	case 3: PlayAnim(playerid, "PLAYIDLES", "stretch", 4.1, 1, 1, 1, 1, 1);
	case 4: PlayAnim(playerid, "PLAYIDLES", "strleg", 4.1, 1, 1, 1, 1, 1);
	case 5: PlayAnim(playerid, "PLAYIDLES", "time", 4.1, 1, 1, 1, 1, 1);
	case 6: PlayAnim(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0);
	case 7: PlayAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 1, 0, 0, 0, 0);
	case 8: PlayAnim(playerid, "COP_AMBIENT", "Coplook_shake", 4.1, 1, 0, 0, 0, 0);
	case 9: PlayAnim(playerid, "COP_AMBIENT", "Coplook_think", 4.1, 1, 0, 0, 0, 0);
	case 10: PlayAnim(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 1, 0, 0, 0, 0);
	case 11: PlayAnim(playerid, "PED", "roadcross", 4.1, 1, 0, 0, 0, 0);
	case 12: PlayAnim(playerid, "PED", "roadcross_female", 4.1, 1, 0, 0, 0, 0);
	case 13: PlayAnim(playerid, "PED", "roadcross_gang", 4.1, 1, 0, 0, 0, 0);
	case 14: PlayAnim(playerid, "PED", "roadcross_old", 4.1, 1, 0, 0, 0, 0);
	case 15: PlayAnim(playerid, "PED", "woman_idlestance", 4.1, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /idles [1-15]");
	}
	return 1;
}

CMD:sunbathe(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "SUNBATHE", "batherdown", 4.1, 0, 1, 1, 1, 1);
	case 2: PlayAnim(playerid, "SUNBATHE", "batherup", 4.1, 0, 1, 1, 1, 1);
	case 3: PlayAnim(playerid, "SUNBATHE", "Lay_Bac_in", 4.1, 0, 1, 1, 1, 1);
	case 4: PlayAnim(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 1, 1);
	case 5: PlayAnim(playerid, "SUNBATHE", "ParkSit_M_IdleA", 4.1, 0, 1, 1, 1, 1);
	case 6: PlayAnim(playerid, "SUNBATHE", "ParkSit_M_IdleB", 4.1, 0, 1, 1, 1, 1);
	case 7: PlayAnim(playerid, "SUNBATHE", "ParkSit_M_IdleC", 4.1, 0, 1, 1, 1, 1);
	case 8: PlayAnim(playerid, "SUNBATHE", "ParkSit_M_in", 4.1, 0, 1, 1, 1, 1);
	case 9: PlayAnim(playerid, "SUNBATHE", "ParkSit_M_out", 4.1, 0, 1, 1, 1, 1);
	case 10: PlayAnim(playerid, "SUNBATHE", "ParkSit_W_idleA", 4.1, 0, 1, 1, 1, 1);
	case 11: PlayAnim(playerid, "SUNBATHE", "ParkSit_W_idleB", 4.1, 0, 1, 1, 1, 1);
	case 12: PlayAnim(playerid, "SUNBATHE", "ParkSit_W_idleC", 4.1, 0, 1, 1, 1, 1);
	case 13: PlayAnim(playerid, "SUNBATHE", "ParkSit_W_in", 4.1, 0, 1, 1, 1, 1);
	case 14: PlayAnim(playerid, "SUNBATHE", "ParkSit_W_out", 4.1, 0, 1, 1, 1, 1);
	case 15: PlayAnim(playerid, "SUNBATHE", "SBATHE_F_LieB2Sit", 4.1, 0, 1, 1, 1, 1);
	case 16: PlayAnim(playerid, "SUNBATHE", "SBATHE_F_Out", 4.1, 0, 1, 1, 1, 1);
	case 17: PlayAnim(playerid, "SUNBATHE", "SitnWait_in_W", 4.1, 0, 1, 1, 1, 1);
	case 18: PlayAnim(playerid, "SUNBATHE", "SitnWait_out_W", 4.1, 0, 1, 1, 1, 1);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sunbathe [1-18]");
	}
	return 1;
}

CMD:lowrider(playerid, params[])
{
	if(!IsAbleVehicleAnimation(playerid)) return 1;
	if(IsCLowrider(GetPlayerVehicleID(playerid)))
	{
		switch(strval(params))
		{
		case 1: PlayAnim(playerid, "LOWRIDER", "lrgirl_bdbnce", 4.1, 0, 1, 1, 1, 1);
		case 2: PlayAnim(playerid, "LOWRIDER", "lrgirl_hair", 4.1, 0, 1, 1, 1, 1);
		case 3: PlayAnim(playerid, "LOWRIDER", "lrgirl_hurry", 4.1, 0, 1, 1, 1, 1);
		case 4: PlayAnim(playerid, "LOWRIDER", "lrgirl_idleloop", 4.1, 0, 1, 1, 1, 1);
		case 5: PlayAnim(playerid, "LOWRIDER", "lrgirl_idle_to_l0", 4.1, 0, 1, 1, 1, 1);
		case 6: PlayAnim(playerid, "LOWRIDER", "lrgirl_l0_bnce", 4.1, 0, 1, 1, 1, 1);
		case 7: PlayAnim(playerid, "LOWRIDER", "lrgirl_l0_loop", 4.1, 0, 1, 1, 1, 1);
		case 8: PlayAnim(playerid, "LOWRIDER", "lrgirl_l0_to_l1", 4.1, 0, 1, 1, 1, 1);
		case 9: PlayAnim(playerid, "LOWRIDER", "lrgirl_l12_to_l0", 4.1, 0, 1, 1, 1, 1);
		case 10: PlayAnim(playerid, "LOWRIDER", "lrgirl_l1_bnce", 4.1, 0, 1, 1, 1, 1);
		case 11: PlayAnim(playerid, "LOWRIDER", "lrgirl_l1_loop", 4.1, 0, 1, 1, 1, 1);
		case 12: PlayAnim(playerid, "LOWRIDER", "lrgirl_l1_to_l2", 4.1, 0, 1, 1, 1, 1);
		case 13: PlayAnim(playerid, "LOWRIDER", "lrgirl_l2_bnce", 4.1, 0, 1, 1, 1, 1);
		case 14: PlayAnim(playerid, "LOWRIDER", "lrgirl_l2_loop", 4.1, 0, 1, 1, 1, 1);
		case 15: PlayAnim(playerid, "LOWRIDER", "lrgirl_l2_to_l3", 4.1, 0, 1, 1, 1, 1);
		case 16: PlayAnim(playerid, "LOWRIDER", "lrgirl_l345_to_l1", 4.1, 0, 1, 1, 1, 1);
		case 17: PlayAnim(playerid, "LOWRIDER", "lrgirl_l3_bnce", 4.1, 0, 1, 1, 1, 1);
		case 18: PlayAnim(playerid, "LOWRIDER", "lrgirl_l3_loop", 4.1, 0, 1, 1, 1, 1);
		case 19: PlayAnim(playerid, "LOWRIDER", "lrgirl_l3_to_l4", 4.1, 0, 1, 1, 1, 1);
		case 20: PlayAnim(playerid, "LOWRIDER", "lrgirl_l4_bnce", 4.1, 0, 1, 1, 1, 1);
		case 21: PlayAnim(playerid, "LOWRIDER", "lrgirl_l4_loop", 4.1, 0, 1, 1, 1, 1);
		case 22: PlayAnim(playerid, "LOWRIDER", "lrgirl_l4_to_l5", 4.1, 0, 1, 1, 1, 1);
		case 23: PlayAnim(playerid, "LOWRIDER", "lrgirl_l5_bnce", 4.1, 0, 1, 1, 1, 1);
		case 24: PlayAnim(playerid, "LOWRIDER", "lrgirl_l5_loop", 4.1, 0, 1, 1, 1, 1);
		case 25: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkB", 4.1, 0, 1, 1, 1, 1);
		case 26: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkC", 4.1, 0, 1, 1, 1, 1);
		case 27: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkD", 4.1, 0, 1, 1, 1, 1);
		case 28: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkE", 4.1, 0, 1, 1, 1, 1);
		case 29: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkF", 4.1, 0, 1, 1, 1, 1);
		case 30: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkG", 4.1, 0, 1, 1, 1, 1);
		case 31: PlayAnim(playerid, "LOWRIDER", "prtial_gngtlkH", 4.1, 0, 1, 1, 1, 1);
		default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /lowrider [1-31]");
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD2, "This animation requires you to be in a convertible lowrider.");
	}
	return 1;
}

CMD:carchat(playerid, params[])
{
	if(!IsAbleVehicleAnimation(playerid)) return 1;
	switch(strval(params))
	{
	case 1: PlayAnim(playerid, "CAR_CHAT", "carfone_in", 4.1, 0, 1, 1, 1, 1);
	case 2: PlayAnim(playerid, "CAR_CHAT", "carfone_loopA", 4.1, 0, 1, 1, 1, 1);
	case 3: PlayAnim(playerid, "CAR_CHAT", "carfone_loopA_to_B", 4.1, 0, 1, 1, 1, 1);
	case 4: PlayAnim(playerid, "CAR_CHAT", "carfone_loopB", 4.1, 0, 1, 1, 1, 1);
	case 5: PlayAnim(playerid, "CAR_CHAT", "carfone_loopB_to_A", 4.1, 0, 1, 1, 1, 1);
	case 6: PlayAnim(playerid, "CAR_CHAT", "carfone_out", 4.1, 0, 1, 1, 1, 1);
	case 7: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc1_BL", 4.1, 0, 1, 1, 1, 1);
	case 8: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc1_BR", 4.1, 0, 1, 1, 1, 1);
	case 9: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc1_FL", 4.1, 0, 1, 1, 1, 1);
	case 10: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc1_FR", 4.1, 0, 1, 1, 1, 1);
	case 11: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc2_FL", 4.1, 0, 1, 1, 1, 1);
	case 12: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc3_BR", 4.1, 0, 1, 1, 1, 1);
	case 13: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc3_FL", 4.1, 0, 1, 1, 1, 1);
	case 14: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc3_FR", 4.1, 0, 1, 1, 1, 1);
	case 15: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.1, 0, 1, 1, 1, 1);
	case 16: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc4_BR", 4.1, 0, 1, 1, 1, 1);
	case 17: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc4_FL", 4.1, 0, 1, 1, 1, 1);
	case 18: PlayAnim(playerid, "CAR_CHAT", "CAR_Sc4_FR", 4.1, 0, 1, 1, 1, 1);
	case 19: PlayAnim(playerid, "CAR", "Sit_relaxed", 4.1, 0, 1, 1, 1, 1);
	//case 20: PlayAnim(playerid, "CAR", "Tap_hand", 4.1, 1, 0, 0, 0, 0);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /carchat [1-19]");
	}
	return 1;
}


CMD:point(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "ON_LOOKERS", "panic_point", 4.1, 0, 0, 0, 0, 0);
		case 2: PlayAnim(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /point [1-2]");
	}

	return 1;
}

CMD:camera(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "CAMERA", "camcrch_comeon", 4.1, 1, 0, 0, 0, 0);
        case 2: PlayAnim(playerid, "CAMERA", "camcrch_idleloop", 4.1, 1, 0, 0, 0, 0);
	    case 3: PlayAnim(playerid, "CAMERA", "camcrch_stay", 4.1, 0, 0, 0, 1, 0);
	    case 4: PlayAnim(playerid, "CAMERA", "camcrch_to_camstnd", 4.1, 1, 0, 0, 0, 0);
	    case 5: PlayAnim(playerid, "CAMERA", "camstnd_comeon", 4.1, 0, 0, 0, 1, 0);
     	case 6: PlayAnim(playerid, "CAMERA", "camstnd_idleloop", 4.1, 1, 0, 0, 0, 0);
       	case 7: PlayAnim(playerid, "CAMERA", "camstnd_lkabt", 4.1, 1, 0, 0, 0, 0);
       	case 8: PlayAnim(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 1, 0, 0, 0, 0);
       	case 9: PlayAnim(playerid, "CAMERA", "piccrch_in", 4.1, 1, 0, 0, 0, 0);
       	case 10: PlayAnim(playerid, "CAMERA", "piccrch_out", 4.1, 0, 0, 0, 1, 0);
       	case 11: PlayAnim(playerid, "CAMERA", "piccrch_take", 4.1, 1, 0, 0, 0, 0);
       	case 12: PlayAnim(playerid, "CAMERA", "picstnd_in", 4.1, 1, 0, 0, 0, 0);
       	case 13: PlayAnim(playerid, "CAMERA", "picstnd_out", 4.1, 1, 0, 0, 0, 0);
       	case 14: PlayAnim(playerid, "CAMERA", "picstnd_take", 4.1, 0, 0, 0, 1, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: {ffffff}/camera [1-14]");
	}

	return 1;
}

CMD:fall(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0);
	    case 2: PlayAnim(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0);
	    case 3: PlayAnim(playerid, "PED", "KO_shot_face", 4.1, 0, 1, 1, 1, 0);
	    case 4: PlayAnim(playerid, "PED", "KO_shot_front", 4.1, 0, 1, 1, 1, 0);
	    case 5: PlayAnim(playerid, "PED", "KO_shot_stom", 4.1, 0, 1, 1, 1, 0);
	    case 6: PlayAnim(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fall [1-6]");
	}

	return 1;
}

CMD:tired(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
        case 2: PlayAnim(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /tired [1-2]");
	}

	return 1;
}

CMD:cover(playerid, params[])
{
	return callcmd::cower(playerid, params);
}

CMD:cower(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "PED", "cower", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

CMD:givesomething(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "KISSING", "gift_give", 4.1, 1, 0, 0, 0, 0);
	return 1;
}
CMD:injured(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "SWAT", "gnstwall_injurd", 4.1, 1, 0, 0, 0, 0);
        case 2: PlayAnim(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /injured [1-2]");
	}

	return 1;
}

CMD:fishing(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "SAMP", "FishingIdle", 4.1, 0, 0, 0, 1, 0);
	return 1;
}

CMD:aim(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "SHOP", "ROB_loop", 4.1, 1, 0, 0, 0, 0);
        case 2: PlayAnim(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /aim [1-2]");
	}

	return 1;
}


CMD:dodge(playerid, params[])
{
	//TODO:check position after animation
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0);
	return 1;
}

CMD:scratch(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "MISC", "Scratchballs_01", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:what(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:wash(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:come(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "WUZI", "Wuzi_follow", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:hitch(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "MISC", "Hiker_Pose", 4.1, 0, 0, 0, 1, 0);
	return 1;
}

CMD:shifty(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	PlayAnim(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:traffic(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0);
        case 2: PlayAnim(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0);
	    default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /traffic [1-2]");
	}

	return 1;
}

CMD:ghands(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0);
		case 2: PlayAnim(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0);
		case 3: PlayAnim(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0);
		case 4: PlayAnim(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0);
		case 5: PlayAnim(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0);
        case 6: PlayAnim(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0);
		case 7: PlayAnim(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0);
		case 8: PlayAnim(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0);
		case 9: PlayAnim(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0);
		case 10: PlayAnim(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ghands [1-10]");
	}

	return 1;
}

CMD:walk(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
		case 1: PlayAnim(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1);
		case 2: PlayAnim(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1);
		case 3: PlayAnim(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1);
		case 4: PlayAnim(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1);
		case 5: PlayAnim(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1);
        case 6: PlayAnim(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1);
		case 7: PlayAnim(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1);
		case 8: PlayAnim(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1);
		case 9: PlayAnim(playerid, "PED", "WALK_shuffle", 4.1, 1, 1, 1, 1, 1);
		case 10: PlayAnim(playerid, "PED", "WALK_Wuzi", 4.1, 1, 1, 1, 1, 1);
		case 11: PlayAnim(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1);
		case 12: PlayAnim(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1);
		case 13: PlayAnim(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1);
		case 14: PlayAnim(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1);
		case 15: PlayAnim(playerid, "PED", "WOMAN_walkpro", 4.1, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /walk [1-15]");
	}

	return 1;
}

CMD:fuckme(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "SNM", "SPANKING_IDLEW", 4.1, 0, 1, 1, 1, 0);
		case 2: PlayAnim(playerid, "SNM", "SPANKING_IDLEP", 4.1, 0, 1, 1, 1, 0);
		case 3: PlayAnim(playerid, "SNM", "SPANKINGW", 4.1, 0, 1, 1, 1, 0);
		case 4: PlayAnim(playerid, "SNM", "SPANKINGP", 4.1, 0, 1, 1, 1, 0);
		case 5: PlayAnim(playerid, "SNM", "SPANKEDW", 4.1, 0, 1, 1, 1, 0);
		case 6: PlayAnim(playerid, "SNM", "SPANKEDP", 4.1, 0, 1, 1, 1, 0);
		case 7: PlayAnim(playerid, "SNM", "SPANKING_ENDW", 4.1, 0, 1, 1, 1, 0);
		case 8: PlayAnim(playerid, "SNM", "SPANKING_ENDP", 4.1, 0, 1, 1, 1, 0);
        default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /fuckme [1-8]");
	}

	return 1;
}

CMD:bj(playerid, params[])
{
    if(!IsAblePedAnimation(playerid)) { return 1; }

	switch(strval(params))
	{
	    case 1: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_START_P", 4.1, 0, 1, 1, 1, 0);
		case 2: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 0, 1, 1, 1, 0);
		case 3: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 0, 1, 1, 1, 0);
		case 4: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 0, 1, 1, 1, 0);
		case 5: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_END_P", 4.1, 0, 1, 1, 1, 0);
		case 6: PlayAnim(playerid, "BLOWJOBZ", "BJ_COUCH_END_W", 4.1, 0, 1, 1, 1, 0);
		case 7: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_START_P", 4.1, 0, 1, 1, 1, 0);
		case 8: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_START_W", 4.1, 0, 1, 1, 1, 0);
		case 9: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0);
		case 10: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0);
		case 11: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_END_P", 4.1, 0, 1, 1, 1, 0);
		case 12: PlayAnim(playerid, "BLOWJOBZ", "BJ_STAND_END_W", 4.1, 0, 1, 1, 1, 0);
        default: SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /bj [1-12]");
	}

	return 1;
}

CMD:animidx(playerid, params[])
{
	if(IsGodAdmin(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Your current: [AnimIdx: %d, PlayerState: %d, SpecialAction: %d]",
		 				GetPlayerAnimationIndex(playerid), GetPlayerState(playerid), GetPlayerSpecialAction(playerid));
		return 1;
	}
	return 0;
}