AcceptNeutralize(playerid)
{
    new giveplayer = DefendNOffer[playerid];
    new noto = DefendNQuantity[playerid];
    new price_buy  = noto * 2; 
    new price_sell = noto * 3 / 2;

    DefendNOffer[playerid] = INVALID_PLAYER_ID;
    DefendNQuantity[playerid] = 0;

    if(giveplayer == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   No-one offered you a neutralize!");
    }
    
    if(!IsPlayerConnected(giveplayer))
    {
        return SendClientMessage(playerid, COLOR_GREY, "   The lawyer has been disappeared!");
    }
    
    if(!IsPlayerNearPlayer(playerid, giveplayer, 5.0))
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You are not near lawyer.");
    }

    if(GetPlayerCash(playerid) < price_buy)
    {
        return SendClientMessage(playerid, COLOR_GREY, "   You can't afford the neutralize!");
    }

    GiveNotoriety(playerid, -noto);
    GiveNotoriety(giveplayer, -30);	
    GivePlayerCash(giveplayer, price_sell);
    GivePlayerCash(playerid, - price_buy);
    IncreaseJobSkill(giveplayer, JOB_LAWYER);

    GivePlayerRankPointLegalJob(giveplayer, noto/100);

    SendClientMessageEx(playerid, COLOR_AQUA, "* You accepted the neutralize for $%d (%d notoriety) from Lawyer %s.", price_buy, noto, GetPlayerNameEx(giveplayer));
    SendClientMessageEx(giveplayer, COLOR_AQUA, "* %s accepted your neutralize, you paid taxes and $%d was added to your money.",GetPlayerNameEx(playerid), price_sell);
    SendClientMessageEx(giveplayer, COLOR_AQUA, "You have lost -30 notoriety for legal affairs, you now have %d.", PlayerData[giveplayer][pNotoriety]);
    

    return 1;
}