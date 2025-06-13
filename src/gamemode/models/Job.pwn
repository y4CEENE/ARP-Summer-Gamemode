/// @file      Job.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


enum
{
    JOB_NONE = -1,
    JOB_PIZZAMAN,
    JOB_TRUCKER,
    JOB_FISHERMAN,
    JOB_ARMSDEALER,
    JOB_MECHANIC,
    JOB_MINER,
    JOB_TAXIDRIVER,
    JOB_DRUGDEALER,
    JOB_DRUGSMUGGLER,
    JOB_LAWYER,
    JOB_DETECTIVE,
    JOB_GARBAGEMAN,
    JOB_FARMER,
    JOB_HOOKER,
    JOB_CRAFTMAN,
    JOB_FORKLIFT,
    JOB_CARJACKER,
    JOB_ROBBERY,
    JOB_SWEEPER,
    JOB_BARTENDER,
    JOB_LUMBERJACK,
    JOB_CONSTRUCTION,
    JOB_MILKER,
    //JOB_RECYCLE,
    JOB_BUTCHER,
    JOB_BRINKS,
    JOB_SIZE
};

enum jobEnum
{
    jobShortName[32],
    jobName[32],
    jobID,
    Float:jobX,
    Float:jobY,
    Float:jobZ,
    Float:actorangle,
    jobActor,
    jobActorID,
    jobHelp[128]
};

new const jobLocations[][jobEnum] =
{
    {"pizzaman",    "Pizzaman",       JOB_PIZZAMAN,          2104.7771, -1805.1772,   13.5547,  89.4295, 155, INVALID_ACTOR_ID, "/getpizza"},
    {"trucker",     "Trucker",        JOB_TRUCKER,           2218.5190, -2663.3662,   13.5490,  51.7563, 236, INVALID_ACTOR_ID, "/loadtruck, /canceltruck, /delivertruck, /detach, /deliveryinfo"},
    {"fisherman",   "Fisherman",      JOB_FISHERMAN,          734.7008, -1413.0004,   13.5280, 340.1763, 261, INVALID_ACTOR_ID, "/net, /myfish, /gofish, /endfish, /fish, /sellfish"},
    {"armsdealer",  "Arms Dealer",    JOB_ARMSDEALER,        1365.9685, -1274.6963,   13.5469, 138.5629,  30, INVALID_ACTOR_ID, "/getmats, /sellmats, /sellgun"},
    {"mechanic",    "Mechanic",       JOB_MECHANIC,          1957.9480, -1578.8147,   13.7161, 182.3973, 268, INVALID_ACTOR_ID, "/repair, /nos, /hyd, /takecall, /tow, /stoptow, /buycomps"},
    {"sfmechanic",  "SF Mechanic",    JOB_MECHANIC,          -2101.292,   -36.4850,   35.3203, 297.9422, 268, INVALID_ACTOR_ID, ""},
    {"miner",       "Miner",          JOB_MINER,             1262.5063, -1265.6266,   13.3809,   0.8926, 260, INVALID_ACTOR_ID, "/mine"},
    {"taxidriver",  "Taxi Driver",    JOB_TAXIDRIVER,        1748.1373, -1863.0981,   13.5755, 356.1966,   7, INVALID_ACTOR_ID, "/setfare, /takecall"},
    {"drugdealer",  "Drug Dealer",    JOB_DRUGDEALER,        2160.2219, -1698.5747,   15.0859,  88.8670,  29, INVALID_ACTOR_ID, "/getseeds, /getchems, /getcocaine, /planthelp, /cookheroin"},
    {"drugsmuggler","Drug Smuggler",  JOB_DRUGSMUGGLER,      1767.2609, -2042.0455,   13.5316, 265.8613,  28, INVALID_ACTOR_ID, "/getcrate, /loadpack"},
    {"lawyer",      "Lawyer",         JOB_LAWYER,            1381.0668, -1086.6857,   27.3906,  98.3046,  17, INVALID_ACTOR_ID, "/defend, /free, /wanted, /neutralize"},
    {"detective",   "Detective",      JOB_DETECTIVE,         1547.6234, -1680.8387,   13.5601,  90.0000, 147, INVALID_ACTOR_ID, "/find"},
    {"garbageman",  "Garbage Man",    JOB_GARBAGEMAN,        2404.0730, -2060.3748,   13.5469, 231.9457, 142, INVALID_ACTOR_ID, "/garbage"},
    {"farmer",      "Farmer",         JOB_FARMER,            -366.3515, -1412.8286,   25.7266,  36.7287, 158, INVALID_ACTOR_ID, "/harvest"},
    {"hooker",      "Hooker",         JOB_HOOKER,            2423.8901, -1220.3479,   25.4832, 145.0000, 246, INVALID_ACTOR_ID, "/sex"},
    {"bartender",   "Bartender",      JOB_BARTENDER,         1833.6382, -1679.3398,   13.4650, 130.0000, 171, INVALID_ACTOR_ID, "/selldrink"},
    {"craftman",    "Craft Man",      JOB_CRAFTMAN,          2194.4561, -1973.1625,   13.5592, 162.1549, 289, INVALID_ACTOR_ID, "/getmats, /sellmats, /craft, /craftinventory"},
    {"forklift",    "Forklift",       JOB_FORKLIFT,          2441.6909, -2115.9131,   13.5469,  35.6998,  16, INVALID_ACTOR_ID, ""},
    {"lumberjack",  "Lumberjack",     JOB_LUMBERJACK,        2532.8455, -836.62140,   88.3442, 116.8363,  16, INVALID_ACTOR_ID, "/log"},
    {"construction","Construction",   JOB_CONSTRUCTION,     -2061.0977, -109.87760,   35.3259, 224.0000,  16, INVALID_ACTOR_ID, "/makeciment"},
    {"milker",      "Milker",         JOB_MILKER,            1033.5572, -296.79769,   73.9921, 182.19,   161, INVALID_ACTOR_ID, "/buybocket, /milk, /sellmilk"},
    //{"recycle",     "Recycle",        JOB_RECYCLE,          -2095.9714, -2414.2709,   30.6250, 293.37,     6, INVALID_ACTOR_ID, "Use N To Start The Job"},
    {"butcher",     "Butcher",        JOB_BUTCHER,          -2545.1672,  187.10340,   13.0391,  50.0000, 168, INVALID_ACTOR_ID, "/butcher"},
    {"brinks",      "Brinks",         JOB_BRINKS,           -1495.6901,  841.2843,     7.1875, 162.2570,  30, INVALID_ACTOR_ID, "/loadcash"},
    //entrance that can't be found on /locate must have empty shortname and placed under this line
    {"",            "Drug Smuggler",  JOB_DRUGSMUGGLER,      2355.1421, -1169.8289,   28.0375,  26.7895,  28, INVALID_ACTOR_ID, ""}
};
