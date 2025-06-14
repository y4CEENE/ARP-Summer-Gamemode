
public OnPlayerCheat(playerid, cheatid, source[])
{
    new elc_str[120],elc_reason[60];

    switch(cheatid)
    {
        case 1: format(elc_reason,sizeof(elc_reason),"Cheat Argent ( %s $ )",source);
        case 2: 
        {
            if(PlayerHasWeapon(playerid, GetPlayerWeapon(playerid)))
            {
                return 1;
            }
            format(elc_reason,sizeof(elc_reason),"Cheat Arme ( %s )",source); 
        }
        case 3: format(elc_reason,sizeof(elc_reason),"Cheat Munition ( %s Bullets )",source); 
        case 4: format(elc_reason,sizeof(elc_reason),"Cheat Bloque Munition");
        case 5: format(elc_reason,sizeof(elc_reason),"Speed Hack");
        case 6: format(elc_reason,sizeof(elc_reason),"Airbreak/Teleportation Cheat");
        case 7: format(elc_reason,sizeof(elc_reason),"Cheat Vie");
        case 8: format(elc_reason,sizeof(elc_reason),"Cheat Armure");
        case 9: format(elc_reason,sizeof(elc_reason),"Teleportation de vehicules");
        case 10: format(elc_reason,sizeof(elc_reason),"Vehicule Crasher");
    }

    if(( cheatid == 1 || 
         cheatid == 2 || 
         cheatid == 3 || 
         cheatid == 4 || 
         cheatid == 7 ||
         cheatid == 8) && PlayerInfo[playerid][pAdmin] == 0)
    {
        format(elc_str,sizeof(elc_str),"[REX] %s is possibly hacking. *Reason: %s", GetPlayerNameEx(playerid), elc_reason);
        Log("Rex/ELC-AC.log", elc_str);
        ABroadCast(0xBD0000FF, elc_str, 1);
    }
    else
    {
        format(elc_str,sizeof(elc_str),"[REX] %s is possibly hacking. Reason: %s", GetPlayerNameEx(playerid), elc_reason);
        Log("Rex/ELC-AC.log", elc_str);
        ABroadCast(0xBD0000FF, elc_str, 1);
    }
    
    return 1;
}
