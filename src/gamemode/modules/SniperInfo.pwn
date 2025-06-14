#include <YSI\y_hooks>

static PlayerText:SniperTextDraw[MAX_PLAYERS];
static SniperAimingAt[MAX_PLAYERS];

IsPlayerAimingAtPlayer(playerid, aimid) 
{
    new Float:X1, Float:Y1, Float:Z1, Float:X2, Float:Y2, Float:Z2;
    GetPlayerPos(playerid, X1, Y1, Z1);
    GetPlayerPos(aimid, X2, Y2, Z2);
    new Float:Distance = floatsqroot(floatpower(floatabs(X1 - X2), 2) + floatpower(floatabs(Y1 - Y2), 2));
    if(Distance < 100) {
        new Float:A;
        GetPlayerFacingAngle(playerid, A);
        X1 += (Distance * floatsin(-A, degrees));
        Y1 += (Distance * floatcos(-A, degrees));
        Distance = floatsqroot(floatpower(floatabs(X1 - X2), 2) + floatpower(floatabs(Y1 - Y2), 2));
        if(Distance < 1.3) 
        {
            return true;
        }
    }
    return false;
}


task SniperAimingCheck[750]() 
{
    foreach(new playerid : Player)
    {
        foreach(new targetid : Player)
        {
            if(playerid != targetid)
            {
                if(SniperAimingAt[playerid] == targetid && (!IsPlayerAimingAtPlayer(playerid, targetid) || GetPlayerWeapon(playerid) != 34))
                {
                    PlayerTextDrawHide(playerid, SniperTextDraw[playerid]);
                    SniperAimingAt[playerid] = INVALID_PLAYER_ID;
                }

                if(IsPlayerAimingAtPlayer(playerid, targetid) && GetPlayerWeapon(playerid) == 34)
                {
                    new Float:x,Float:y,Float:z;
                    new weaponname[256];
                    new string[128];
                    GetPlayerPos(targetid,x,y,z);
                    GetWeaponName(GetPlayerWeapon(targetid), weaponname, sizeof(weaponname));
                    format(string, 128, "~g~%s dist: ~r~%d m.~n~~b~Ping: ~r~%dms~n~~g~AMSL: ~r~%d m.~n~~b~Weapon: ~r~%s~p~", 
                                    GetPlayerNameEx(targetid), 
                                    floatround(GetDistanceBetweenPlayers(targetid, playerid)), 
                                    GetPlayerPing(targetid), 
                                    floatround(z), 
                                    weaponname);
                    PlayerTextDrawSetString(playerid, SniperTextDraw[playerid], string);
                    PlayerTextDrawShow(playerid, SniperTextDraw[playerid]);
                    SniperAimingAt[playerid] = targetid;
                }
            }
        }
    }
    return 1;
}

hook OnPlayerInit(playerid) 
{
    SniperTextDraw[playerid] = CreatePlayerTextDraw(playerid, 406, 307, "PREVED");
    PlayerTextDrawAlignment        (playerid, SniperTextDraw[playerid], 0);
    PlayerTextDrawBackgroundColor  (playerid, SniperTextDraw[playerid], 0x000000ff);
    PlayerTextDrawFont             (playerid, SniperTextDraw[playerid], 2);
    PlayerTextDrawLetterSize       (playerid, SniperTextDraw[playerid], 0.3, 1.100000);
    PlayerTextDrawColor            (playerid, SniperTextDraw[playerid], 0xffffffff);
    PlayerTextDrawSetOutline       (playerid, SniperTextDraw[playerid], 1);
    PlayerTextDrawSetProportional  (playerid, SniperTextDraw[playerid], 1);
    PlayerTextDrawSetShadow        (playerid, SniperTextDraw[playerid], 1);
    SniperAimingAt[playerid] = INVALID_PLAYER_ID;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    PlayerTextDrawHide(playerid, SniperTextDraw[playerid]);
    PlayerTextDrawDestroy(playerid, SniperTextDraw[playerid]);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if(oldkeys == 128) 
    {
        PlayerTextDrawHide(playerid, SniperTextDraw[playerid]);
        SniperAimingAt[playerid] = INVALID_PLAYER_ID;
    }
    return 1;
}
