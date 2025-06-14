#include <YSI\y_hooks>

#define JELLYFISH_LB_PRICE 40

static ScubaDiverObject[MAX_PLAYERS];
static ScubaDiverStatus[MAX_PLAYERS];
static ScubaDiverWeight[MAX_PLAYERS];

enum jellyFishEnum{
    Float:jfX,
    Float:jfY,
    Float:jfZ,
    jfPickupID
}

static JellyFish[][jellyFishEnum]={
    {92.28782, -2007.75781, -6.15964, 0},
    {83.45240, -2010.20886, -6.20040, 0},
    {91.69806, -2014.85156, -6.31861, 0},
    {88.84829, -2015.84167, -6.33795, 0},
    {86.12655, -2006.79785, -6.11844, 0},
    {100.28447, -2017.29724, -6.29905, 0},
    {92.71991, -2028.46997, -6.27928, 0},
    {81.23080, -2024.29163, -6.24072, 0},
    {90.85152, -2021.58362, -6.35713, 0},
    {190.19791, -2016.19373, -4.27460, 0},
    {188.81883, -2010.36353, -4.27460, 0},
    {192.28165, -2009.29260, -4.27460, 0},
    {201.45697, -2011.63416, -4.27460, 0},
    {194.48730, -2022.70435, -4.27460, 0},
    {183.53880, -2018.44397, -4.27460, 0},
    {186.30247, -2004.28882, -4.27460, 0},
    {195.72850, -2001.77515, -4.27460, 0},
    {190.17192, -2000.78198, -4.27460, 0},
    {152.70210, -2042.70618, -17.09425, 0},
    {150.95689, -2037.12268, -17.18244, 0},
    {154.05038, -2036.30103, -17.27154, 0},
    {162.85243, -2038.89453, -17.36151, 0},
    {155.50583, -2050.21899, -17.45237, 0},
    {144.20169, -2046.20776, -17.52553, 0},
    {146.60796, -2032.30457, -17.59806, 0},
    {155.67313, -2030.04565, -17.67128, 0},
    {149.75183, -2029.30688, -17.74521, 0},
    {157.33420, -2038.31519, -8.05827, 0},
    {155.64023, -2032.67871, -8.05610, 0},
    {158.78569, -2031.80408, -8.05394, 0},
    {167.64020, -2034.34326, -8.05173, 0},
    {160.34677, -2045.61182, -8.04949, 0},
    {149.09644, -2041.54602, -8.02863, 0},
    {151.55705, -2027.58606, -8.00619, 0},
    {160.67729, -2025.27014, -7.98349, 0},
    {154.81171, -2024.47302, -7.96054, 0},
    {159.90532, -2011.31018, -5.03576, 0},
    {158.40549, -2005.62610, -5.00336, 0},
    {161.74849, -2004.70142, -4.97068, 0},
    {170.80386, -2007.18689, -4.93764, 0},
    {163.71480, -2018.39954, -4.90425, 0},
    {152.66719, -2014.25647, -4.85194, 0},
    {155.33372, -2000.21423, -4.79773, 0},
    {164.63130, -1997.84070, -4.74295, 0},
    {158.95065, -1997.00476, -4.68759, 0},
    {114.02735, -2032.06006, -5.03576, 0},
    {112.09163, -2026.50940, -5.00336, 0},
    {115.00872, -2025.71545, -4.97068, 0},
    {123.66236, -2028.36584, -4.93764, 0},
    {116.16473, -2039.74829, -4.90425, 0},
    {104.70152, -2035.77771, -4.85194, 0},
    {106.94531, -2021.91162, -4.79773, 0},
    {115.84470, -2019.69031, -4.74295, 0},
    {109.75462, -2018.98682, -4.68759, 0},
    {131.52815, -2021.13928, -3.28681, 0},
    {129.91147, -2015.41431, -3.23692, 0},
    {133.15488, -2014.44177, -3.18657, 0},
    {142.14211, -2016.91028, -3.13569, 0},
    {134.98573, -2028.10718, -3.08429, 0},
    {123.87666, -2023.96619, -3.01377, 0},
    {126.48284, -2009.92651, -2.94118, 0},
    {135.71025, -2007.52051, -2.86783, 0},
    {129.94843, -2006.60962, -2.79372, 0},
    {96.15096, -2038.88379, -10.42296, 0},
    {94.21833, -2033.28784, -10.44443, 0},
    {97.14181, -2032.44580, -10.46616, 0},
    {105.8021, -2035.04456, -10.48807, 0},
    {98.32093, -2046.37366, -10.51019, 0},
    {86.91560, -2042.35571, -10.51394, 0},
    {89.22439, -2028.43738, -10.51635, 0},
    {98.15059, -2026.15442, -10.51875, 0},
    {92.08376, -2025.36621, -10.52115, 0},
    {96.15096, -2038.88379, -4.28692, 0},
    {94.21833, -2033.28784, -4.24704, 0},
    {97.14181, -2032.44580, -4.20679, 0},
    {105.8051, -2035.04456, -4.16611, 0},
    {98.32093, -2046.37366, -4.12501, 0},
    {86.91560, -2042.35571, -4.06490, 0},
    {89.22439, -2028.43738, -4.00283, 0},
    {98.15059, -2026.15442, -3.94009, 0},
    {92.08376, -2025.36621, -3.87671, 0},
    {93.85023, -2022.69263, -2.42455, 0},
    {91.89456, -2016.97192, -2.36605, 0},
    {94.79270, -2016.00293, -2.30699, 0},
    {103.4283, -2018.47095, -2.24731, 0},
    {95.91389, -2029.66565, -2.18703, 0},
    {84.47575, -2025.51038, -2.10754, 0},
    {86.74921, -2011.45056, -2.02589, 0},
    {95.63738, -2009.02332, -1.94338, 0},
    {89.52981, -2008.08740, -1.86003, 0},
    {90.85152, -2021.58362, -9.40008, 0},
    {88.84829, -2015.84167, -9.41133, 0},
    {91.69806, -2014.85156, -9.42272, 0},
    {93.60755, -2019.12500, -9.43420, 0},
    {92.71991, -2028.46997, -9.44578, 0},
    {81.23080, -2024.29163, -9.43888, 0},
    {83.45240, -2010.20886, -9.43054, 0},
    {92.28782, -2007.75781, -9.42209, 0},
    {86.12655, -2006.79785, -9.41352, 0},
    {100.2844, -2017.29724, -9.43420, 0}
};

hook OnPlayerInit(playerid)
{
    ScubaDiverObject[playerid] = 0;
    ScubaDiverWeight[playerid] = 0;
    ScubaDiverStatus[playerid] = 0;    
    return 1;
}

hook OnLoadGameMode(timestamp)
{
    CreateDynamic3DTextLabel("{33CCFF}Activity: {FFFFFF}Scuba diving{33CCFF}\n{33CCFF}Type {FFFFFF}/startdiving {33CCFF}to\nget oxygen and start diving.\n{FFFFFF}/enddiving{33CCFF} to get your payment", 
    COLOR_YELLOW, 152.8682, -1961.4235, 3.7734, 10.0, .testlos = 1, .streamdistance = 10.0);
    CreateDynamicMapIcon(152.8682,-1961.4235,3.7734, 56, 0, .style = MAPICON_GLOBAL);
    CreateActor(2, 152.8682,-1961.4235,3.7734,210.8498);

    for(new i=0;i<sizeof(JellyFish);i++)
    {
        if(random(2))
            JellyFish[i][jfPickupID] = CreateDynamicPickup(1602, 2, JellyFish[i][jfX], JellyFish[i][jfY], JellyFish[i][jfZ]);
        else JellyFish[i][jfPickupID] = CreateDynamicPickup(1603, 2, JellyFish[i][jfX], JellyFish[i][jfY], JellyFish[i][jfZ]+1.0);
    }
    return 1;
}

IsJellyFish(pickupid)
{
    for(new i=0;i<sizeof(JellyFish);i++)
    {
        if(JellyFish[i][jfPickupID] == pickupid)
            return 1;
    }
    return 0;
}


PickUpJellyFish(playerid)
{
    new weight = 1 + random(3);
    new price = weight * JELLYFISH_LB_PRICE;
    if(weight + ScubaDiverWeight[playerid] > 24)
    {
        SendClientMessageEx(playerid, COLOR_RED, "You lost all your jellyfish.");
        ScubaDiverWeight[playerid]=0;
    } else {
        ScubaDiverWeight[playerid] += weight;
        SendClientMessageEx(playerid, COLOR_GREY, "You cought %d lb of jellyfish with a value of $%d. You have now %d lb.", weight, price, ScubaDiverWeight[playerid]);
    } 

    return 1;
}

CMD:startdiving(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid,10.0,152.8682,-1961.4235,3.7734))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not at lighthouse.");
	}
    if(ScubaDiverObject[playerid] == 0)
        ScubaDiverObject[playerid] = 
        SetPlayerAttachedObject(playerid, 9, 1010, 1, 0.000000, -0.123999, 0.000000, -93.199966, 175.000000, -0.599999, 1.000000, 1.000000, 1.000000);
    ScubaDiverWeight[playerid] = 0;
    ScubaDiverStatus[playerid] = 1;
	return SendClientMessage(playerid, COLOR_AQUA, "* You are equiped with oxygen. Dive and catch jellyfish then come back to get yor payment.");
}

CMD:enddiving(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid,10.0,152.8682,-1961.4235,3.7734))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not at lighthouse.");
	}
    
    if(ScubaDiverWeight[playerid])
    {
        new price = ScubaDiverWeight[playerid] * JELLYFISH_LB_PRICE;
        GivePlayerCash(playerid, price);
        SendClientMessageEx(playerid, COLOR_AQUA, "You sold %d lb of jellyfish for $%d.", ScubaDiverWeight[playerid], price);
    }

    if(ScubaDiverObject[playerid] != 0)
        RemovePlayerAttachedObject(playerid, 9);
    ScubaDiverObject[playerid] = 0;
    ScubaDiverWeight[playerid] = 0;
    ScubaDiverStatus[playerid] = 0;
    return 1;
}
