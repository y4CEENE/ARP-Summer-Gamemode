/// @file      RepairShop.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


IsRepairShopInUse(id)
{
    foreach(new i : Player)
    {
        if (PlayerData[i][pRepairShop] == id && IsPlayerInRangeOfPoint(i, 10.0, g_RepairShops[id][3], g_RepairShops[id][4], g_RepairShops[id][5]))
        {
            return 1;
        }
    }

    return 0;
}
