// Simple & Accurate Anti-C-Bug by Whitetiger
#include <YSI\y_hooks>

static NotMoving[MAX_PLAYERS];
static WeaponID[MAX_PLAYERS];
static CheckCrouch[MAX_PLAYERS];
static Ammo[MAX_PLAYERS][48];


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsAdminOnDuty(playerid, false))
    {
        return 1;
    }
    
    if((newkeys & KEY_FIRE) && (oldkeys & KEY_CROUCH) && !((oldkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) || (oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) ) 
    {
        switch(GetPlayerWeapon(playerid)) 
        {
		    case 23..25, 27, 29..34, 41: 
            {
		        if(Ammo[playerid][GetPlayerWeapon(playerid)] > GetPlayerAmmo(playerid)) 
                {
					OnPlayerCBug(playerid);
				}
				return 1;
			}
		}
	}

	if(CheckCrouch[playerid] == 1) 
    {
		switch(WeaponID[playerid]) 
        {
		    case 23..25, 27, 29..34, 41: 
            {
		    	if((newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK ) 
                {
		    		if(Ammo[playerid][GetPlayerWeapon(playerid)] > GetPlayerAmmo(playerid)) 
                    {
						OnPlayerCBug(playerid);
					}
		    	}
		    }
		}
	}
	else if(((newkeys & KEY_FIRE) && (newkeys & KEY_HANDBRAKE) && !((newkeys & KEY_SPRINT) || (newkeys & KEY_JUMP))) ||
	(newkeys & KEY_FIRE) && !((newkeys & KEY_SPRINT) || (newkeys & KEY_JUMP)) ||
	(NotMoving[playerid] && (newkeys & KEY_FIRE) && (newkeys & KEY_HANDBRAKE)) ||
	(NotMoving[playerid] && (newkeys & KEY_FIRE)) ||
	(newkeys & KEY_FIRE) && (oldkeys & KEY_CROUCH) && !((oldkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) ||
	(oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) ) 
    {
		SetTimerEx("AntiCbug_CrouchCheck", 3000, 0, "d", playerid);
		CheckCrouch[playerid] = 1;
		WeaponID[playerid] = GetPlayerWeapon(playerid);
		Ammo[playerid][GetPlayerWeapon(playerid)] = GetPlayerAmmo(playerid);
		return 1;
	}

	return 1;
}

hook OnPlayerUpdate(playerid)
{
    if(IsAdminOnDuty(playerid, false))
    {
        return 1;
    }
	new Keys, ud, lr;
	GetPlayerKeys(playerid, Keys, ud, lr);

	if(CheckCrouch[playerid] == 1) 
    {
		switch(WeaponID[playerid]) 
        {
		    case 23..25, 27, 29..34, 41: {
		    	if((Keys & KEY_CROUCH) && !((Keys & KEY_FIRE) || (Keys & KEY_HANDBRAKE)) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK ) 
                {
		    		if(Ammo[playerid][GetPlayerWeapon(playerid)] > GetPlayerAmmo(playerid)) 
                    {
						OnPlayerCBug(playerid);
					}
		    	}
		    }
		}
	}

	NotMoving[playerid] = (!ud && !lr); 

	return 1;
}

OnPlayerCBug(playerid) 
{
    GameTextForPlayer(playerid, "~r~C-bug is not allowed", 3000, 3);
    ApplyAnimation(playerid, "SWORD", "sword_block", 4.0, 0, 0, 0, 0, 0, 1);
    SendAdminWarning(2, "%s[%i] is possibly abusing Crouch bugging (C-Bug) with a %s.", GetRPName(playerid), playerid, GetWeaponNameEx(GetPlayerWeapon(playerid)));
    SetPlayerArmedWeapon(playerid, 0);
    
	new Float:Pos[3];
	GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
	SetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]+2.5);
	
    PlayerPlaySound(playerid,1190,0.0,0.0,0.0);
	
    CheckCrouch[playerid] = 0;
	return 1;
}

forward AntiCbug_CrouchCheck(playerid);
public AntiCbug_CrouchCheck(playerid) 
{
	CheckCrouch[playerid] = 0;
	return 1;
}

